// input_file contain the matrix and skeleton data.

//[For Computational Media Students] ***
//Replace your txt file name here
String input_file = "skeleton_2015_12_8_7_35_Yi Ling_5_1.txt";

// Show structures in draw_start_structure for the first start_time_position seconds.
double prepare_time_position =14; //prepare

double start1 = 16;               //walking
double start2 = 18;
double start3 = 19;
double start4 = 21;
double start5 = 28;
double start_time_position = 28;  
double normal_fractal = 60; 
double rotate_fractal = 82.5;       //ending
double ending = 90;
double circle = 100;

float frame_rate = 60;

float easingx = 0.08; // Numbers 0.0 to 1.0
float easingy = 0.08; // Numbers 0.0 to 1.0
float easingz = 0.08; // Numbers 0.0 to 1.0

// input_matrix can also be rotated one
// e.g. "0.319196,0.0774024,0.376992,0,-0.279629,0.383165,0.158089,0,-0.264428,-0.311758,0.287897,0,0,0,-400,1,0.028"
String input_matrix = "1,0,0,0,0,1,0,0,0,0,1,0,0,0,0,5";

//Posture.
String input_skeleton = "";

BufferedReader reader;
float[] matrix = new float[16];

int frame_count = 0;
float sphere_size = 0;

// 0: head, 1: neck, 2: left_shoulder, 3: left_elbow, 4: left_hand
// 5: right_shoulder, 6: right_elbow, 7: right_hand, 8: torso, 9: left_hip
// 10: left_knee, 11: left_foot, 12: right_hip, 13: right_knee, 14: right_foot
// 15: spine_mid, 16: spine_shoulder
ArrayList<PVector> skeleton_points = new ArrayList<PVector>();
ArrayList<PVector> read_skeleton_points = new ArrayList<PVector>();

void setup() {
  background(200);
  fullScreen(P3D);
  reader = createReader(input_file);
  frameRate(frame_rate);
}

void draw() {
  background(200);
  //strokeWeight(3);
  try {
    // read box rotation marix and skeleton position from file.
    String input_line;
    if ((input_line = reader.readLine()) != null) {   
      if (input_line.charAt(0) == 'm') {
        input_matrix = input_line.substring(1);
        read_matrix();
      } else {
        input_skeleton = input_line.substring(0);
        read_skeleton_points.clear();    //clear up arraylist 
        read_skeleton();

        // Draw skeleton.
        pushMatrix();
        resetMatrix(); 
        translate(0, 0, -200);
        applyMatrix(1, 0, 0, matrix[12], 
          0, 1, 0, matrix[13], 
          0, 0, 1, matrix[14], 
          0, 0, 0, matrix[15]);
        draw_skeleton();

        double second = frame_count / frame_rate;
        frame_count++;
       pushMatrix();
       translate(0,-50,0);
        if (second < prepare_time_position) {
        } else if (second >= prepare_time_position && second < start1 ) {
          start1();
        } else if (second >= start1 && second < start2) {
          start2();
        } else if (second >=  start2 && second < start3) {
          start3();
        } else if (second >= start3 && second < start4) {
          start4();
        } else if (second >= start4 && second < start_time_position) {
          start5();
        } else if (second >= start_time_position && second <normal_fractal) {
          draw_structure();
        } else if (second >= normal_fractal && second < rotate_fractal ) {
          draw_six_structure();
        } else if (second >= rotate_fractal && second < ending) {
          draw_polygon_structure();
        } else if (second >= ending && second < circle ) {
          draw_ending_structure();
        } else if (second >= circle ) {
          draw_ending_structure();
        }
        
        popMatrix();
        popMatrix();

        // Draw box.
        pushMatrix();
        resetMatrix();
        translate(0, 0, -200);
        applyMatrix(matrix[0], matrix[4], matrix[8], matrix[12], 
          matrix[1], matrix[5], matrix[9], matrix[13], 
          matrix[2], matrix[6], matrix[10], matrix[14], 
          matrix[3], matrix[7], matrix[11], matrix[15]);
        //draw_box();
        popMatrix();
      }
    } else {
      noLoop();
    }
  } 
  catch(IOException e) {
  }    //Jave has exception

  //for Computational Media Students. Uncomment the following line when you are ready to record your video. ***
  saveFrame("NEW_nameofyourstructure/frame-######.png");
}

void read_matrix() {
  String[] pieces = split(input_matrix, ",");
  for (int i = 0; i < 16; i++) {
    matrix[i] = Float.parseFloat(pieces[i]);
  }
}

void read_skeleton() {
  String[] pieces = split(input_skeleton, ",");
  for (int i = 0; i < 17*3; i+=3) {
    PVector point = new PVector(Float.parseFloat(pieces[i]), 
      -Float.parseFloat(pieces[i+1]), 
      Float.parseFloat(pieces[i+2]));
    read_skeleton_points.add(point);
    if (skeleton_points.size() < 17) {
      skeleton_points.add(point);
    }
  }
  for (int i = 0; i < 17; ++i) {
    skeleton_points.get(i).x += (read_skeleton_points.get(i).x - skeleton_points.get(i).x) * easingx;
    skeleton_points.get(i).y += (read_skeleton_points.get(i).y - skeleton_points.get(i).y) * easingy;
    skeleton_points.get(i).z += (read_skeleton_points.get(i).z - skeleton_points.get(i).z) * easingz;
  }
}

void start1() {
  for (float r=200; r>10; r=r*0.8) { 
    translate(skeleton_points.get(14).x/4, 0, skeleton_points.get(14).z/4);
    scale(0.85);
    stroke(255);

    noFill();
    rectMode(RADIUS);
    float x = 0;
    //float y = skeleton_points.get(15).y+90;
    float y = 100;
    ellipse(x-r, y, 2*r, 2*r);
  }
}
void start2() {
  for (float r=200; r>10; r=r*0.8) { 
    translate(skeleton_points.get(14).x/4, 0, skeleton_points.get(14).z/4);
    scale(0.85);
    stroke(255);

    noFill();
    rectMode(RADIUS);
    float x = 0;
    //float y = skeleton_points.get(15).y+90;
    float y = 100;
    ellipse(x+r, y, 2*r, 2*r);
    ellipse(x-r, y, 2*r, 2*r);
  }
}

void start3() {
  for (float r=200; r>10; r=r*0.8) { 
    translate(skeleton_points.get(14).x/4, 0, skeleton_points.get(14).z/4);
    scale(0.85);
    stroke(255);

    noFill();
    rectMode(RADIUS);
    float x = 0;
    //float y = skeleton_points.get(15).y+90;
    float y = 100;
    ellipse(x+r, y, 2*r, 2*r);
    ellipse(x-r, y, 2*r, 2*r);
    ellipse(x, y+r, 2*r, 2*r);
  }
}
void start4() {
  for (float r=200; r>10; r=r*0.8) { 
    translate(skeleton_points.get(14).x/4, 0, skeleton_points.get(14).z/4);
    scale(0.85);
    stroke(255);

    noFill();
    rectMode(RADIUS);
    float x = 0;
    //float y = skeleton_points.get(15).y+90;
    float y = 100;
    ellipse(x+r, y, 2*r, 2*r);
    ellipse(x-r, y, 2*r, 2*r);
    ellipse(x, y+r, 2*r, 2*r);
    ellipse(x, y-r, 2*r, 2*r);
  }
}

void start5() {    

  for (float r=200; r>10; r=r*0.8) { 
    translate(skeleton_points.get(14).x/4, 0, skeleton_points.get(14).z/4);
    scale(0.85);
    stroke(255);

    noFill();
    rectMode(RADIUS);
    float x = 0;
    //float y = skeleton_points.get(15).y+90;
    float y = 100;
    rect(x, y, r, r);
    ellipse(x+r, y, 2*r, 2*r);
    ellipse(x-r, y, 2*r, 2*r);
    ellipse(x, y+r, 2*r, 2*r);
    ellipse(x, y-r, 2*r, 2*r);
  }
}
// 7_fading,4_color
void draw_structure() {
  float cr=map(skeleton_points.get(7).y, 100, -200, 255, 20);
  float cg=0;
  float cb=0;
  if (skeleton_points.get(7).y<0) {
    cg = map(skeleton_points.get(7).x, -100, 100, 20, 140);
    cb = map(skeleton_points.get(7).x, -100, 100, 150, 200);
  } else if (skeleton_points.get(7).y>0) {
    cg = map(skeleton_points.get(7).x, -100, 100, 250, 60);
    cb = map(skeleton_points.get(7).x, -100, 100, 220, 140);
  }
  print(cr, cg, cb);

  for (float r=200; r>10; r=r*0.8) {

    translate(skeleton_points.get(4).x/2, skeleton_points.get(4).y/2, 0);
    scale(0.9);
    stroke(cr, cg, cb);
    fill(cr, cg, cb, 20);
    rectMode(RADIUS);
    //stroke(frameCount%200, 50, 135);
    //fill(frameCount%200, 50, 135, 50);
    float x = skeleton_points.get(11).x;

    float y = 100;
    rect(x, y, r, r);
    ellipse(x+r, y, 2*r, 2*r);
    ellipse(x-r, y, 2*r, 2*r);
    ellipse(x, y+r, 2*r, 2*r);
    ellipse(x, y-r, 2*r, 2*r);
    println(r);
  }
}
// after quick section
void draw_polygon_structure() {
  int n=0;
  if ( abs(skeleton_points.get(4).y)>0 && abs(skeleton_points.get(4).y) <20) {
    n=5;
  } else if (abs(skeleton_points.get(4).y)>20 && abs(skeleton_points.get(4).y) <40) {
    n=6;
  } else if (abs(skeleton_points.get(4).y)>40 && abs(skeleton_points.get(4).y) <60) {
    n=7;
  } else if (abs(skeleton_points.get(4).y)>60 && abs(skeleton_points.get(4).y) <80) {
    n=8;
  } else if (abs(skeleton_points.get(4).y)>80 && abs(skeleton_points.get(4).y) <100) {
    n=9;
  } else if (abs(skeleton_points.get(4).y)>100 && abs(skeleton_points.get(4).y) <120) {
    n=10;
  } else if (abs(skeleton_points.get(4).y)>120) {
    n=12;
  }
  for (float r = 200; r>10; r=r*0.8) {

    translate(skeleton_points.get(7).x/4, skeleton_points.get(7).y/4, 0);
    scale(0.85);
    //noStroke();
    stroke(r, frameCount%150, 135);
    fill(r, frameCount%150, 135, 20);
    rectMode(RADIUS);
    //stroke(frameCount%200, 50, 135);
    //fill(frameCount%200, 50, 135, 50);
    float x = skeleton_points.get(14).x;
    //float y = skeleton_points.get(15).y+90;
    float y = 100;
    rect(x, y, r, r);
    polygon(x+r, y, r, n);
    polygon(x-r, y, r, n);
    polygon(x, y+r, r, n);
    polygon(x, y-r, r, n);
  }
}
//ending

// get7 keep spining
void draw_six_structure() {  //speed up

  for (float r=300; r>10; r=r*0.8) {
    translate(skeleton_points.get(4).x/2, skeleton_points.get(4).y/2, 0);
    scale(0.9);
    float theta = 0;
    //float rotate =skeleton_points.get(7).z %100;
    /*
    if (rotate<20) {
      theta = PI/8;
    } else if (rotate>=20 && rotate<40) {
      theta = PI/6;
    } else if (rotate>=40 && rotate<60) {
      theta = PI/4;
    } else if (rotate>=60 && rotate<80) {
      theta = PI/2;
    } else if (rotate>=80 && rotate<100) {
      theta = PI;
    }
    */

    rotate(skeleton_points.get(7).z/500);
    stroke(r, frameCount%150, 135);
    fill(r, frameCount%150, 135, 20);
    rectMode(RADIUS);
    float x = skeleton_points.get(14).x;

    float y =skeleton_points.get(14).y;
     rect(x, y, r, r);
    ellipse(x+r, y, 2*r, 2*r);
    ellipse(x-r, y, 2*r, 2*r);
    ellipse(x, y+r, 2*r, 2*r);
    ellipse(x, y-r, 2*r, 2*r);
  }
}

void rotate () {
  for (int n=5; n<50; n++) {
    int r=5*n;

    translate(skeleton_points.get(7).x/4, skeleton_points.get(7).y/4, 0);
    //scale(0.85);

    float theta = 0;
    float rotate =skeleton_points.get(4).z %100;
    if (rotate<20) {
      theta = PI/8;
    } else if (rotate>=20 && rotate<40) {
      theta = PI/6;
    } else if (rotate>=40 && rotate<60) {
      theta = PI/4;
    } else if (rotate>=60 && rotate<80) {
      theta = PI/2;
    } else if (rotate>=80 && rotate<100) {
      theta = PI;
    }

    rotate(theta);
    stroke(r, frameCount%150, 135);
    fill(r, frameCount%150, 135, 20);
    rectMode(RADIUS);
    //stroke(frameCount%200, 50, 135);
    //fill(frameCount%200, 50, 135, 50);
    float x = skeleton_points.get(15).x;
    float y = skeleton_points.get(15).y+90;
    //rect(x, y, r, r);
    polygon(x, y, r, 15);
  }
}

void draw_ending_structure() {

  for (float r=200; r>10; r=r*0.8) {

    translate(skeleton_points.get(7).x/2, skeleton_points.get(7).y/2, 0);
    scale(0.9);
    stroke(r, frameCount%150, 135);
    fill(r, frameCount%150, 135, 20);
    rectMode(RADIUS);
    //stroke(frameCount%200, 50, 135);
    //fill(frameCount%200, 50, 135, 50);
    float x = skeleton_points.get(15).x;
    float y = skeleton_points.get(15).y+90;
    rect(x, y, r, r);
    ellipse(x+r, y, 2*r, 2*r);
    ellipse(x-r, y, 2*r, 2*r);
    ellipse(x, y+r, 2*r, 2*r);
    ellipse(x, y-r, 2*r, 2*r);
    println(r);
  }
}



void polygon(float x, float y, float radius, int npoints) {
  float angle = TWO_PI / npoints;
  beginShape();
  for (float a = 0; a < TWO_PI; a += angle) {
    float sx = x + cos(a) * radius;
    float sy = y + sin(a) * radius;
    vertex(sx, sy);
  }
  endShape(CLOSE);
}


void draw_skeleton() {
  scale(0.8);
  for (int i = 0; i < 17; i++) {
    stroke(255);
    pushMatrix();
    translate(skeleton_points.get(i).x, skeleton_points.get(i).y, skeleton_points.get(i).z);
    sphere(4);
    popMatrix();
  }
noStroke();
  // Line 1: torso, spine_mid, spine_shoulder, neck, head
  line(skeleton_points.get(8).x, skeleton_points.get(8).y, skeleton_points.get(8).z, 
    skeleton_points.get(15).x, skeleton_points.get(15).y, skeleton_points.get(15).z);
  line(skeleton_points.get(15).x, skeleton_points.get(15).y, skeleton_points.get(15).z, 
    skeleton_points.get(16).x, skeleton_points.get(16).y, skeleton_points.get(16).z);
  line(skeleton_points.get(16).x, skeleton_points.get(16).y, skeleton_points.get(16).z, 
    skeleton_points.get(1).x, skeleton_points.get(1).y, skeleton_points.get(1).z);
  line(skeleton_points.get(1).x, skeleton_points.get(1).y, skeleton_points.get(1).z, 
    skeleton_points.get(0).x, skeleton_points.get(0).y, skeleton_points.get(0).z);

  // Line 2: spine_shoulder, right_shoulder, right_elbow, right_hand
  line(skeleton_points.get(16).x, skeleton_points.get(16).y, skeleton_points.get(16).z, 
    skeleton_points.get(5).x, skeleton_points.get(5).y, skeleton_points.get(5).z);
  line(skeleton_points.get(5).x, skeleton_points.get(5).y, skeleton_points.get(5).z, 
    skeleton_points.get(6).x, skeleton_points.get(6).y, skeleton_points.get(6).z);
  line(skeleton_points.get(6).x, skeleton_points.get(6).y, skeleton_points.get(6).z, 
    skeleton_points.get(7).x, skeleton_points.get(7).y, skeleton_points.get(7).z);

  // Line 3: torso, right_hip, right_knee, right_foot
  line(skeleton_points.get(8).x, skeleton_points.get(8).y, skeleton_points.get(8).z, 
    skeleton_points.get(12).x, skeleton_points.get(12).y, skeleton_points.get(12).z);
  line(skeleton_points.get(12).x, skeleton_points.get(12).y, skeleton_points.get(12).z, 
    skeleton_points.get(13).x, skeleton_points.get(13).y, skeleton_points.get(13).z);
  line(skeleton_points.get(13).x, skeleton_points.get(13).y, skeleton_points.get(13).z, 
    skeleton_points.get(14).x, skeleton_points.get(14).y, skeleton_points.get(14).z);

  // Line 4: spine_shoulder, left_shoulder, left_elbow, left_hand
  line(skeleton_points.get(16).x, skeleton_points.get(16).y, skeleton_points.get(16).z, 
    skeleton_points.get(2).x, skeleton_points.get(2).y, skeleton_points.get(2).z);
  line(skeleton_points.get(2).x, skeleton_points.get(2).y, skeleton_points.get(2).z, 
    skeleton_points.get(3).x, skeleton_points.get(3).y, skeleton_points.get(3).z);
  line(skeleton_points.get(3).x, skeleton_points.get(3).y, skeleton_points.get(3).z, 
    skeleton_points.get(4).x, skeleton_points.get(4).y, skeleton_points.get(4).z);

  // Line 5: torso, left_hip, left_knee, left_foot
  line(skeleton_points.get(8).x, skeleton_points.get(8).y, skeleton_points.get(8).z, 
    skeleton_points.get(9).x, skeleton_points.get(9).y, skeleton_points.get(9).z);
  line(skeleton_points.get(9).x, skeleton_points.get(9).y, skeleton_points.get(9).z, 
    skeleton_points.get(10).x, skeleton_points.get(10).y, skeleton_points.get(10).z);
  line(skeleton_points.get(10).x, skeleton_points.get(10).y, skeleton_points.get(10).z, 
    skeleton_points.get(11).x, skeleton_points.get(11).y, skeleton_points.get(11).z);
}