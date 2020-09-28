module inner_round_corner(r, h, ang=90, back = 0.1){
  cx = r*(1-cos(ang/2+45));
  translate([-r*(1-sin(ang/2+45)), -r*(1-sin(ang/2+45)),0])
  difference(){
    translate([-back, -back, 0])
    cube([cx+back, cx+back, h]);
    translate([r,r,-1])
      cylinder(r=r, h=h+2);
  }
}

module rounded_cube2(v, r){
  $fs = 1;
  if(v[2]){
    union(){
      translate([r,0,0])           cube([v[0]-2*r, v[1]    , v[2]]);
      translate([0,r,0])           cube([v[0]    , v[1]-2*r, v[2]]);
      translate([r,r,0])           cylinder(h=v[2], r=r);
      translate([v[0]-r,r,0])      cylinder(h=v[2], r=r);
      translate([v[0]-r,v[1]-r,0]) cylinder(h=v[2], r=r);
      translate([r,v[1]-r,0])      cylinder(h=v[2], r=r);
    }
  } else {
    union(){
      translate([r,0])           square([v[0]-2*r, v[1]    ]);
      translate([0,r])           square([v[0]    , v[1]-2*r]);
      translate([r,r])           circle(r=r);
      translate([v[0]-r,r])      circle(r=r);
      translate([v[0]-r,v[1]-r]) circle(r=r);
      translate([r,v[1]-r])      circle(r=r);
    }
  }
}

module top_rounded_cube2(v, r){
  translate([0,v[1],0])
    rotate([90,0,0])
      rounded_cube2([v[0], v[2], v[1]], r);
}


$fn=100;
module snurreskive_plate(){
  cylinder(d1 = 22, d2 = 17, h = 6.1);
}

module snurreskive_plate_plupp() {
  difference(){
    union() {
      translate([-3, -27/2/2, 0])
        top_rounded_cube2([6, 27/2, 14.3], 3);
      for(k=[0,1])
        mirror([k,0,0])
          translate([6/2, 27/2/2, 6.1])
          rotate([90,0,0])
          inner_round_corner(1, 27/2);
    }
    translate([0,0,14.3-3])
      rotate([90,0,0])
        cylinder(d=3.1, h=41, center=true);
  }
}

//snurreskive();
module snurreskive() {
  snurreskive_plate();
  snurreskive_plate_plupp();
}

//translate([9, -24/2, -7])
//  %picam();
module picam() {
  difference() {
    cube([24, 25, 2]);
    translate([2, 2, -1])
      cylinder(d=2, h=4);
    translate([12.5+2, 2, -1])
      cylinder(d=2, h=4);
    translate([12.5+2, 25-2, -1])
      cylinder(d=2, h=4);
    translate([2, 25-2, -1])
      cylinder(d=2, h=4);
  }
}

module snurreskive2_inner() {
  cylinder(d1 = 31.5, d2 = 28.5, h=5.1);
}


//translate([(31)/2+3.5,0,-2]) {
//snurreskive2();
//translate([-2-12.5/2, -25/2, 9.6])
//  %picam();
//}
module snurreskive2() {
  difference() {
    union() {
      snurreskive2_inner();
      for(i=[1,-1])
        for(j=[1,-1])
          translate([i*12.5/2, j*21/2, 0])
            cylinder(d=4, h=9.5);
    }
    for(i=[1,-1])
      for(j=[1,-1])
        translate([i*12.5/2, j*21/2, -0.1]) {
          cylinder(d=2.1, h=9.7);
          // M2 nutlocks. Most people won't have M2 screws, so don't bother
          //cylinder(d=4/cos(30), h=2, $fn=6);
        }
  }

}


//vippeplate();
module vippeplate(){
    difference() {
      hull() {
        rotate([90,0,0])
          cylinder(d=6, h=34, center=true);
        translate([34-3/2,0,0])
          rotate([90,0,0])
            cylinder(d=6, h=34, center=true);
      }
      rotate([90,0,0])
         cylinder(d=3.1, h=100, center=true);
      cube([6.5, 27/2, 7], center=true);
      translate([(31)/2+4,0,-2]) {
        hull() {
          snurreskive2_inner();
          translate([20,0,0]) {
            snurreskive2_inner();
          }
        }
        hull() {
          translate([0,0,-2])
            cylinder(d=28.5, h=6);
          translate([20,0,-2])
            cylinder(d=28.5, h=6);
        }
      }
      translate([31/2+4,0,0]){
        rotate([0,0,90-10])
          rotate([0,90,0])
            cylinder(d=2.7, h=50);
        rotate([0,0,90+180+10])
          rotate([0,90,0])
            cylinder(d=2.7, h=50);
      }
    }
}

//base();
module base() {
  difference() {
    translate([0,0,-2])
      cylinder(d = 25 + 4, h=8);
    hull() {
      scale([1.01, 1.01, 1])
        snurreskive_plate();
      translate([0,-10,0])
        scale([1.01, 1.01, 1])
          snurreskive_plate();
    }
    rotate([0,0,90])
      translate([0,0,3.5])
        rotate([0,90,0])
          cylinder(d=2.7, h=50, center=true);
    rotate([0,0,-15])
      translate([0,0,3.5])
        rotate([0,90,0])
          cylinder(d=2.7, h=50);
    rotate([0,0,180+15])
      translate([0,0,3.5])
        rotate([0,90,0])
          cylinder(d=2.7, h=50);
  }
}

assembly();
module assembly() {
  translate([0,0,14.3-3]) {
    vippeplate();
    translate([(31)/2+3.5,0,-2]) {
      snurreskive2();
      translate([-2-12.5/2, -25/2, 9.6])
        %picam();
    }
  }
  base();
  snurreskive();
}
