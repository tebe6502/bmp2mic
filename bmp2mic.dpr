// BMP2MIC v1.4 (08.09.2009 .. 21.12.2014) by Tebe/Madteam

program bmp2mic;

{$APPTYPE CONSOLE}

uses Windows, SysUtils, Graphics, PngImage, Classes, ExtCtrls;


type

  tYUV  = record
           y,u,v: double;
          end;


var
   input_file, output_file: string;

   Param_counter: integer;

   resize: Boolean = false;
   hires : Boolean = false;

const

title = 'BMP2MIC v1.4';

defPal: array [0..255] of TColor=
 ($00000000, $003B3B3B, $00494949, $00575757,
 $00656565, $00737373, $00818181, $008F8F8F,
 $009D9D9D, $00ABABAB, $00B9B9B9, $00C7C7C7,
 $00D5D5D5, $00E3E3E3, $00F1F1F1, $00FFFFFF,
 $0000235C, $0000316A, $00003F78, $000A4D86,
 $00185B94, $002669A2, $003477B0, $004285BE,
 $005093CC, $005EA1DA, $006CAFE8, $007ABDF6,
 $0088CBFF, $0096D9FF, $00A4E7FF, $00B2F5FF,
 $00091469, $00172277, $00253085, $00333E93,
 $00414CA1, $004F5AAF, $005D68BD, $006B76CB,
 $007984D9, $008792E7, $0095A0F5, $00A3AEFF,
 $00B1BCFF, $00BFCAFF, $00CDD8FF, $00DBE6FF,
 $00380A6C, $0046187A, $00542688, $00623496,
 $007042A4, $007E50B2, $008C5EC0, $009A6CCE,
 $00A87ADC, $00B688EA, $00C496F8, $00D2A4FF,
 $00E0B2FF, $00EEC0FF, $00FCCEFF, $00FFDCFF,
 $00650564, $00731372, $00812180, $008F2F8E,
 $009D3D9C, $00AB4BAA, $00B959B8, $00C767C6,
 $00D575D4, $00E383E2, $00F191F0, $00FF9FFE,
 $00FFADFF, $00FFBBFF, $00FFC9FF, $00FFD7FF,
 $00890752, $00971560, $00A5236E, $00B3317C,
 $00C13F8A, $00CF4D98, $00DD5BA6, $00EB69B4,
 $00F977C2, $00FF85D0, $00FF93DE, $00FFA1EC,
 $00FFAFFA, $00FFBDFF, $00FFCBFF, $00FFD9FF,
 $009C103A, $00AA1E48, $00B82C56, $00C63A64,
 $00D44872, $00E25680, $00F0648E, $00FE729C,
 $00FF80AA, $00FF8EB8, $00FF9CC6, $00FFAAD4,
 $00FFB8E2, $00FFC6F0, $00FFD4FE, $00FFE2FF,
 $009C1E1F, $00AA2C2D, $00B83A3B, $00C64849,
 $00D45657, $00E26465, $00F07273, $00FE8081,
 $00FF8E8F, $00FF9C9D, $00FFAAAB, $00FFB8B9,
 $00FFC6C7, $00FFD4D5, $00FFE2E3, $00FFF0F1,
 $00892E07, $00973C15, $00A54A23, $00B35831,
 $00C1663F, $00CF744D, $00DD825B, $00EB9069,
 $00F99E77, $00FFAC85, $00FFBA93, $00FFC8A1,
 $00FFD6AF, $00FFE4BD, $00FFF2CB, $00FFFFD9,
 $00653E00, $00734C03, $00815A11, $008F681F,
 $009D762D, $00AB843B, $00B99249, $00C7A057,
 $00D5AE65, $00E3BC73, $00F1CA81, $00FFD88F,
 $00FFE69D, $00FFF4AB, $00FFFFB9, $00FFFFC7,
 $00384B00, $00465900, $00546709, $00627517,
 $00708325, $007E9133, $008C9F41, $009AAD4F,
 $00A8BB5D, $00B6C96B, $00C4D779, $00D2E587,
 $00E0F395, $00EEFFA3, $00FCFFB1, $00FFFFBF,
 $00095200, $00176000, $00256E0C, $00337C1A,
 $00418A28, $004F9836, $005DA644, $006BB452,
 $0079C260, $0087D06E, $0095DE7C, $00A3EC8A,
 $00B1FA98, $00BFFFA6, $00CDFFB4, $00DBFFC2,
 $00005300, $0000610B, $00006F19, $000A7D27,
 $00188B35, $00269943, $0034A751, $0042B55F,
 $0050C36D, $005ED17B, $006CDF89, $007AED97,
 $0088FBA5, $0096FFB3, $00A4FFC1, $00B2FFCF,
 $00004E13, $00005C21, $00006A2F, $0000783D,
 $0000864B, $000B9459, $0019A267, $0027B075,
 $0035BE83, $0043CC91, $0051DA9F, $005FE8AD,
 $006DF6BB, $007BFFC9, $0089FFD7, $0097FFE5,
 $0000432D, $0000513B, $00005F49, $00006D57,
 $00007B65, $00018973, $000F9781, $001DA58F,
 $002BB39D, $0039C1AB, $0047CFB9, $0055DDC7,
 $0063EBD5, $0071F9E3, $007FFFF1, $008DFFFF,
 $00003346, $00004154, $00004F62, $00005D70,
 $00006B7E, $000B798C, $0019879A, $002795A8,
 $0035A3B6, $0043B1C4, $0051BFD2, $005FCDE0,
 $006DDBEE, $007BE9FC, $0089F7FF, $0097FFFF);


procedure Syntax;
begin
  writeln(title);
  writeln('Convert indexed BMP,PNG (8 bits per Pixel) to MIC.');
  writeln('Usage: bmp2mic input_file [-r] [-h] [output_file]');
  writeln('-r'#9'resize');
  writeln('-h'#9'HiRes (2 colors)');
  halt;
end;


function RGBtoYUV(const cl: TColor): tYUV;
var r,g,b: byte;
begin

 r:=GetRValue(cl);
 g:=GetGValue(cl);
 b:=GetBValue(cl);

 Result.y := 0.299*r + 0.587*g + 0.114*b;
 Result.u := 0.565*(b - Result.y);
 Result.v := 0.713*(r - Result.y);

end;


function AverageColorAtari(const cl: TColor): byte;
var a,b: tYUV;
    i: byte;
    x,p: double;
begin

 Result:=0;

 a:=RGBtoYUV(cl);

 x:=$ff*$ff+$ff*$ff+$ff*$ff;
// x:=sqr(a.y)+sqr(a.u)+sqr(a.v);

 for i:=0 to 255 do begin

   b:=RGBtoYUV(defPal[i]);

   p := Sqr(b.y - a.y) + Sqr(b.u - a.u) + Sqr(b.v - a.v);

   if x>p then begin x:=p; Result:=i end;

  end;

end;


function PNGBitsForPixel(const AColorType,  ABitDepth: Byte): Integer;
begin
  case AColorType of
    COLOR_GRAYSCALEALPHA: Result := (ABitDepth * 2);
    COLOR_RGB:  Result := (ABitDepth * 3);
    COLOR_RGBALPHA: Result := (ABitDepth * 4);
    COLOR_GRAYSCALE, COLOR_PALETTE:  Result := ABitDepth;
  else
      Result := 0;
  end;
end;


procedure MIC;
var bmp: TBitmap;
    p: TMaxLogPalette;
    f: file;
    a: PByteArray;
    i,j, w,h: integer;
    v, nbytes: byte;
    buf: array [0..255] of byte;
    PNG: TPngObject;
    ext: string;
    img: TImage;
begin

 fillchar(buf, sizeof(buf), 0);

 ext:=AnsiUpperCase(ExtractFileExt(input_file));

 if (ext<>'.PNG') and (ext<>'.BMP') then Syntax;

 bmp:=TBitmap.create;

 if ext='.PNG' then begin

     PNG := TPNGObject.Create;
     try
       PNG.LoadFromFile(input_file);

             img:=TImage.Create(nil);         // !!! ta metoda gwarantuje ze nie zmieni sie paleta jak przez BMP.ASSIGN(PNG) dla pf8bit

             img.Picture.Bitmap.PixelFormat := pf8bit;
             img.Picture.Bitmap.Height := PNG.Height;
             img.Picture.Bitmap.Width := PNG.Width;
             if PNGBitsForPixel( PNG.Header.ColorType, PNG.Header.BitDepth )=8 then img.Picture.Bitmap.Palette := PNG.Palette;
             img.Canvas.Draw(0,0,PNG);
             img.Picture.Bitmap.PaletteModified := true;

             bmp.Assign(img.Picture.Bitmap);
             img.Free;

     finally
      PNG.Free;
     end;

 end else
  bmp.LoadFromFile(input_file);


 if bmp.PixelFormat<>pf8bit then begin
  writeln('Only 8 bits per Pixel !');
  bmp.Free;
  halt;
 end;

 GetPaletteEntries(Bmp.Palette, 0, 256, p.palPalEntry);

  if resize then
   w:=bmp.width shr 3
  else
   w:=bmp.width shr 2;

  h:=bmp.height;

  nbytes:=w;

  if w<=32 then nbytes:=32 else
   if w<=40 then nbytes:=40 else
    if w<=48 then nbytes:=48;

  writeln('Width: ',nbytes,' bytes');
  writeln('Height: ',h,' lines');


  if resize then 
   bmp.Width:=nbytes shl 3
  else
   bmp.Width:=nbytes shl 2;

  assignfile(f,output_file); rewrite(f,1);

  for j:=0 to h-1 do begin
   a:=bmp.ScanLine[j];

   for i:=0 to nbytes-1 do begin

 //   try

    if hires then begin

      v:=(a[i*8] and 1) shl 7+(a[i*8+1] and 1) shl 6+(a[i*8+2] and 1) shl 5+(a[i*8+3] and 1) shl 4+(a[i*8+4] and 1) shl 3+(a[i*8+5] and 1) shl 2+(a[i*8+6] and 1) shl 1+(a[i*8+7] and 1);

    end else
     if resize then
      v:=(a[i*8] and 3) shl 6+(a[i*8+2] and 3) shl 4+(a[i*8+4] and 3) shl 2+(a[i*8+6] and 3)
     else
      v:=(a[i*4] and 3) shl 6+(a[i*4+1] and 3) shl 4+(a[i*4+2] and 3) shl 2+(a[i*4+3] and 3);

   // except
   //  v:=0
  //  end;

    buf[i]:=v;
   end;

   blockwrite(f,buf, nbytes);
  end;


//  writeln(nbytes);
  
  fillchar(buf, sizeof(buf), 0);

//  while h<240 do begin blockwrite(f, buf, nbytes); inc(h) end;

  buf[0]:=AverageColorAtari(rgb(p.palPalEntry[0].peRed, p.palPalEntry[0].peGreen, p.palPalEntry[0].peBlue)) and $fe;
  buf[1]:=AverageColorAtari(rgb(p.palPalEntry[1].peRed, p.palPalEntry[1].peGreen, p.palPalEntry[1].peBlue)) and $fe;
  buf[2]:=AverageColorAtari(rgb(p.palPalEntry[2].peRed, p.palPalEntry[2].peGreen, p.palPalEntry[2].peBlue)) and $fe;
  buf[3]:=AverageColorAtari(rgb(p.palPalEntry[3].peRed, p.palPalEntry[3].peGreen, p.palPalEntry[3].peBlue)) and $fe;

  blockwrite(f,buf, 4);
  closefile(f);

  bmp.free;
end;


begin

 if ParamCount>0 then begin

  for Param_counter:=1 to ParamCount do
   if AnsiUpperCase(ParamStr(Param_counter))='-R' then
    resize:=true
   else
    if AnsiUpperCase(ParamStr(Param_counter))='-H' then
     hires:=true
    else
     if input_file='' then input_file:=(ParamStr(Param_counter)) else
      if output_file='' then output_file:=(ParamStr(Param_counter)) else
       Syntax;


  if not(FileExists(input_file)) then Syntax;

  if output_file='' then output_file:=ChangeFileExt(input_file,'.mic');

  MIC;

 end else
  Syntax;

end.
