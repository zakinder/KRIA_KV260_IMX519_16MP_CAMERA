-------------------------------------------------------------------------------
--
-- Filename    : ccm.vhd
-- Create Date : 05022019 [05-02-2019]
-- Author      : Zakinder
--
-- Description:
-- This file instantiation
--
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.fixed_pkg.all;
use work.float_pkg.all;
use work.constants_package.all;
use work.vpf_records.all;
use work.ports_package.all;
entity ccm is
  port (
    clk              : in std_logic;
    rst_l            : in std_logic;
    k_config_number  : in integer;
    coefficients_in     : in coefficient_values;
    coefficients_out : out coefficient_values;
    iRgb             : in channel;
    oRgb             : out channel);
end ccm;
architecture Behavioral of ccm is
  signal ccRgb                : ccm_rgb_record;
  signal rgbSyncValid         : std_logic_vector(11 downto 0) := x"000";
  signal rgbSyncEol           : std_logic_vector(11 downto 0) := x"000";
  signal rgbSyncSof           : std_logic_vector(11 downto 0) := x"000";
  signal rgbSyncEof           : std_logic_vector(11 downto 0) := x"000";
  signal rgb_ccm              : channel;
  signal i_k_config_number    : integer := 2;
begin
i_k_config_number <= k_config_number;
rgbToSf_P: process (clk,rst_l)begin
    if rst_l = '0' then
        ccRgb.rgbToSf.red    <= (others => '0');
        ccRgb.rgbToSf.green  <= (others => '0');
        ccRgb.rgbToSf.blue   <= (others => '0');
    elsif rising_edge(clk) then
        ccRgb.rgbToSf.red    <= to_sfixed('0' & iRgb.red,ccRgb.rgbToSf.red);
        ccRgb.rgbToSf.green  <= to_sfixed('0' & iRgb.green,ccRgb.rgbToSf.green);
        ccRgb.rgbToSf.blue   <= to_sfixed('0' & iRgb.blue,ccRgb.rgbToSf.blue);
    end if;
end process rgbToSf_P;
process (clk)begin
    if rising_edge(clk) then
      rgbSyncValid(0)  <= iRgb.valid;
      rgbSyncValid(1)  <= rgbSyncValid(0);
      rgbSyncValid(2)  <= rgbSyncValid(1);
      rgbSyncValid(3)  <= rgbSyncValid(2);
      rgbSyncValid(4)  <= rgbSyncValid(3);
      rgbSyncValid(5)  <= rgbSyncValid(4);
      rgbSyncValid(6)  <= rgbSyncValid(5);
      rgbSyncValid(7)  <= rgbSyncValid(6);
      rgbSyncValid(8)  <= rgbSyncValid(7);
      rgbSyncValid(9)  <= rgbSyncValid(8);
      rgbSyncValid(10) <= rgbSyncValid(9);
    end if;
end process;
process (clk)begin
    if rising_edge(clk) then
      rgbSyncEol(0)  <= iRgb.eol;
      rgbSyncEol(1)  <= rgbSyncEol(0);
      rgbSyncEol(2)  <= rgbSyncEol(1);
      rgbSyncEol(3)  <= rgbSyncEol(2);
      rgbSyncEol(4)  <= rgbSyncEol(3);
      rgbSyncEol(5)  <= rgbSyncEol(4);
      rgbSyncEol(6)  <= rgbSyncEol(5);
      rgbSyncEol(7)  <= rgbSyncEol(6);
      rgbSyncEol(8)  <= rgbSyncEol(4);
      rgbSyncEol(9)  <= rgbSyncEol(8);
      rgbSyncEol(10) <= rgbSyncEol(9);
    end if;
end process;
process (clk)begin
    if rising_edge(clk) then
      rgbSyncSof(0)  <= iRgb.sof;
      rgbSyncSof(1)  <= rgbSyncSof(0);
      rgbSyncSof(2)  <= rgbSyncSof(1);
      rgbSyncSof(3)  <= rgbSyncSof(2);
      rgbSyncSof(4)  <= rgbSyncSof(3);
      rgbSyncSof(5)  <= rgbSyncSof(4);
      rgbSyncSof(6)  <= rgbSyncSof(5);
      rgbSyncSof(7)  <= rgbSyncSof(6);
      rgbSyncSof(8)  <= rgbSyncSof(4);
      rgbSyncSof(9)  <= rgbSyncSof(8);
      rgbSyncSof(10) <= rgbSyncSof(9);
    end if;
end process;
process (clk)begin
    if rising_edge(clk) then
      rgbSyncEof(0)  <= iRgb.eof;
      rgbSyncEof(1)  <= rgbSyncEof(0);
      rgbSyncEof(2)  <= rgbSyncEof(1);
      rgbSyncEof(3)  <= rgbSyncEof(2);
      rgbSyncEof(4)  <= rgbSyncEof(3);
      rgbSyncEof(5)  <= rgbSyncEof(4);
      rgbSyncEof(6)  <= rgbSyncEof(5);
      rgbSyncEof(7)  <= rgbSyncEof(6);
      rgbSyncEof(8)  <= rgbSyncEof(4);
      rgbSyncEof(9)  <= rgbSyncEof(8);
      rgbSyncEof(10) <= rgbSyncEof(9);
    end if;
end process;


process (clk)begin
    if rising_edge(clk) then
        oRgb.eol <= rgbSyncEol(6);
        oRgb.sof <= rgbSyncSof(6);
        oRgb.eof <= rgbSyncEof(6);
    end if;
end process;

ccSfConfig_P: process (clk,rst_l)begin
    if rst_l = '0' then
        ccRgb.ccSf.k1           <= to_sfixed(1.500,15,-3);
        ccRgb.ccSf.k2           <= to_sfixed(-0.125,15,-3); 
        ccRgb.ccSf.k3           <= to_sfixed(-0.125,15,-3); 
        ccRgb.ccSf.k4           <= to_sfixed(-0.125,15,-3); 
        ccRgb.ccSf.k5           <= to_sfixed(1.500,15,-3);  
        ccRgb.ccSf.k6           <= to_sfixed(-0.250,15,-3); 
        ccRgb.ccSf.k7           <= to_sfixed(-0.125,15,-3); 
        ccRgb.ccSf.k8           <= to_sfixed(-0.250,15,-3); 
        ccRgb.ccSf.k9           <= to_sfixed(1.500,15,-3);  
    elsif rising_edge(clk) then
    if(i_k_config_number = 0) then
    oRgb.valid <= rgbSyncValid(6);
        ccRgb.ccSf.n1           <= 3000;
        ccRgb.ccSf.n2           <= -100;
        ccRgb.ccSf.n3           <= -100;
        ccRgb.ccSf.k1           <= to_sfixed(ccRgb.ccSf.n1,15,-3); 
        ccRgb.ccSf.k2           <= to_sfixed(ccRgb.ccSf.n2,15,-3);
        ccRgb.ccSf.k3           <= to_sfixed(ccRgb.ccSf.n3,15,-3); 
        ccRgb.ccSf.k4           <= to_sfixed(ccRgb.ccSf.n3,15,-3); 
        ccRgb.ccSf.k5           <= to_sfixed(ccRgb.ccSf.n1,15,-3);
        ccRgb.ccSf.k6           <= to_sfixed(ccRgb.ccSf.n2,15,-3); 
        ccRgb.ccSf.k7           <= to_sfixed(ccRgb.ccSf.n2,15,-3); 
        ccRgb.ccSf.k8           <= to_sfixed(ccRgb.ccSf.n3,15,-3);
        ccRgb.ccSf.k9           <= to_sfixed(ccRgb.ccSf.n1,15,-3);
    elsif(i_k_config_number = 1)then
    oRgb.valid <= rgbSyncValid(6);
        ccRgb.ccSf.k1           <= to_sfixed(to_integer(unsigned(coefficients_in.k1(15 downto 0))),15,-3);
        ccRgb.ccSf.k2           <= to_sfixed(to_integer(signed(coefficients_in.k2(15 downto 0))),15,-3);
        ccRgb.ccSf.k3           <= to_sfixed(to_integer(signed(coefficients_in.k3(15 downto 0))),15,-3);
        ccRgb.ccSf.k4           <= to_sfixed(to_integer(signed(coefficients_in.k4(15 downto 0))),15,-3);
        ccRgb.ccSf.k5           <= to_sfixed(to_integer(unsigned(coefficients_in.k5(15 downto 0))),15,-3);
        ccRgb.ccSf.k6           <= to_sfixed(to_integer(signed(coefficients_in.k6(15 downto 0))),15,-3);
        ccRgb.ccSf.k7           <= to_sfixed(to_integer(signed(coefficients_in.k7(15 downto 0))),15,-3);
        ccRgb.ccSf.k8           <= to_sfixed(to_integer(signed(coefficients_in.k8(15 downto 0))),15,-3);
        ccRgb.ccSf.k9           <= to_sfixed(to_integer(unsigned(coefficients_in.k9(15 downto 0))),15,-3);
    elsif(i_k_config_number = 2)then
    oRgb.valid <= rgbSyncValid(6);

        ccRgb.ccSf.k1           <= to_sfixed(2000.000,15,-3); 
        ccRgb.ccSf.k2           <= to_sfixed(-500.000,15,-3);
        ccRgb.ccSf.k3           <= to_sfixed(-500.000,15,-3);
        
        ccRgb.ccSf.k4           <= to_sfixed(-500.000,15,-3); 
        ccRgb.ccSf.k5           <= to_sfixed(3000.000,15,-3);
        ccRgb.ccSf.k6           <= to_sfixed(-500.000,15,-3);
        
        ccRgb.ccSf.k7           <= to_sfixed(-500.000,15,-3); 
        ccRgb.ccSf.k8           <= to_sfixed(-500.000,15,-3);
        ccRgb.ccSf.k9           <= to_sfixed(2000.000,15,-3);
    elsif(i_k_config_number = 3)then
    oRgb.valid <= rgbSyncValid(6);
        ccRgb.ccSf.k1           <= to_sfixed(2000.000,15,-3); 
        ccRgb.ccSf.k2           <= to_sfixed(-125.000,15,-3);
        ccRgb.ccSf.k3           <= to_sfixed(-350.000,15,-3);
        ccRgb.ccSf.k4           <= to_sfixed(-350.000,15,-3); 
        ccRgb.ccSf.k5           <= to_sfixed(2000.000,15,-3);
        ccRgb.ccSf.k6           <= to_sfixed(-125.000,15,-3);
        ccRgb.ccSf.k7           <= to_sfixed(-500.000,15,-3); 
        ccRgb.ccSf.k8           <= to_sfixed(-500.000,15,-3);
        ccRgb.ccSf.k9           <= to_sfixed(2000.000,15,-3);
    elsif(i_k_config_number = 4)then
    oRgb.valid <= rgbSyncValid(6);
        ccRgb.ccSf.n1           <= 1250;
        ccRgb.ccSf.n2           <= -850;
        ccRgb.ccSf.n3           <= -400;
        ccRgb.ccSf.k1           <= to_sfixed(ccRgb.ccSf.n1,15,-3); 
        ccRgb.ccSf.k2           <= to_sfixed(ccRgb.ccSf.n2,15,-3);
        ccRgb.ccSf.k3           <= to_sfixed(ccRgb.ccSf.n3,15,-3); 
        ccRgb.ccSf.k4           <= to_sfixed(ccRgb.ccSf.n3,15,-3); 
        ccRgb.ccSf.k5           <= to_sfixed(ccRgb.ccSf.n1,15,-3);
        ccRgb.ccSf.k6           <= to_sfixed(ccRgb.ccSf.n2,15,-3); 
        ccRgb.ccSf.k7           <= to_sfixed(ccRgb.ccSf.n2,15,-3); 
        ccRgb.ccSf.k8           <= to_sfixed(ccRgb.ccSf.n3,15,-3);
        ccRgb.ccSf.k9           <= to_sfixed(ccRgb.ccSf.n1,15,-3);
    elsif(i_k_config_number = 5)then
    oRgb.valid <= rgbSyncValid(6);
        ccRgb.ccSf.n1           <= 2500;
        ccRgb.ccSf.n2           <= -1000;
        ccRgb.ccSf.n3           <= -1500;
        ccRgb.ccSf.k1           <= to_sfixed(ccRgb.ccSf.n1,15,-3); 
        ccRgb.ccSf.k2           <= to_sfixed(ccRgb.ccSf.n2,15,-3);
        ccRgb.ccSf.k3           <= to_sfixed(ccRgb.ccSf.n3,15,-3); 
        ccRgb.ccSf.k4           <= to_sfixed(ccRgb.ccSf.n3,15,-3); 
        ccRgb.ccSf.k5           <= to_sfixed(ccRgb.ccSf.n1,15,-3);
        ccRgb.ccSf.k6           <= to_sfixed(ccRgb.ccSf.n2,15,-3); 
        ccRgb.ccSf.k7           <= to_sfixed(ccRgb.ccSf.n2,15,-3); 
        ccRgb.ccSf.k8           <= to_sfixed(ccRgb.ccSf.n3,15,-3);
        ccRgb.ccSf.k9           <= to_sfixed(ccRgb.ccSf.n1,15,-3);
    elsif(i_k_config_number = 6)then
    oRgb.valid <= rgbSyncValid(6);
        -- Contrast = 202,0,0 Exposer = 4
        ccRgb.ccSf.k1           <= to_sfixed(3000.000,15,-3); 
        ccRgb.ccSf.k2           <= to_sfixed(-1000.000,15,-3);
        ccRgb.ccSf.k3           <= to_sfixed(-1000.000,15,-3);
        ccRgb.ccSf.k4           <= to_sfixed(-1500.000,15,-3); 
        ccRgb.ccSf.k5           <= to_sfixed(3000.000,15,-3);
        ccRgb.ccSf.k6           <= to_sfixed(-0500.000,15,-3);
        ccRgb.ccSf.k7           <= to_sfixed(-0500.000,15,-3); 
        ccRgb.ccSf.k8           <= to_sfixed(-1500.000,15,-3);
        ccRgb.ccSf.k9           <= to_sfixed(3000.000,15,-3);
    elsif(i_k_config_number = 7)then
    oRgb.valid <= rgbSyncValid(6);
      -- Contrast = 230,0,0 Exposer = 6
        ccRgb.ccSf.k1           <= to_sfixed(2700.000,15,-3); 
        ccRgb.ccSf.k2           <= to_sfixed(-1000.000,15,-3);
        ccRgb.ccSf.k3           <= to_sfixed(-1000.000,15,-3); 
        ccRgb.ccSf.k4           <= to_sfixed(-1200.000,15,-3); 
        ccRgb.ccSf.k5           <= to_sfixed(2700.000,15,-3);
        ccRgb.ccSf.k6           <= to_sfixed(-1000.000,15,-3);
        ccRgb.ccSf.k7           <= to_sfixed(-1000.000,15,-3); 
        ccRgb.ccSf.k8           <= to_sfixed(-1200.000,15,-3);
        ccRgb.ccSf.k9           <= to_sfixed(2700.000,15,-3);
    elsif(i_k_config_number = 8)then
    oRgb.valid <= rgbSyncValid(6);
        ccRgb.ccSf.n1           <= 4900;
        ccRgb.ccSf.n2           <= -3400;
        ccRgb.ccSf.n3           <= -1600;
        ccRgb.ccSf.k1           <= to_sfixed(ccRgb.ccSf.n1,15,-3); 
        ccRgb.ccSf.k2           <= to_sfixed(ccRgb.ccSf.n2,15,-3);
        ccRgb.ccSf.k3           <= to_sfixed(ccRgb.ccSf.n3,15,-3); 
        ccRgb.ccSf.k4           <= to_sfixed(ccRgb.ccSf.n3,15,-3); 
        ccRgb.ccSf.k5           <= to_sfixed(ccRgb.ccSf.n1,15,-3);
        ccRgb.ccSf.k6           <= to_sfixed(ccRgb.ccSf.n2,15,-3); 
        ccRgb.ccSf.k7           <= to_sfixed(ccRgb.ccSf.n2,15,-3); 
        ccRgb.ccSf.k8           <= to_sfixed(ccRgb.ccSf.n3,15,-3);
        ccRgb.ccSf.k9           <= to_sfixed(ccRgb.ccSf.n1,15,-3);
    elsif(i_k_config_number = 9) then
    oRgb.valid <= rgbSyncValid(6);
        ccRgb.ccSf.k1           <= to_sfixed(1.500,15,-3);  
        ccRgb.ccSf.k2           <= to_sfixed(-0.250,15,-3); 
        ccRgb.ccSf.k3           <= to_sfixed(-0.125,15,-3); 
        ccRgb.ccSf.k4           <= to_sfixed(-0.125,15,-3); 
        ccRgb.ccSf.k5           <= to_sfixed(1.500,15,-3);  
        ccRgb.ccSf.k6           <= to_sfixed(-0.250,15,-3); 
        ccRgb.ccSf.k7           <= to_sfixed(-0.250,15,-3); 
        ccRgb.ccSf.k8           <= to_sfixed(-0.125,15,-3); 
        ccRgb.ccSf.k9           <= to_sfixed(1.500,15,-3);  
    elsif(i_k_config_number = 10)then
    oRgb.valid <= rgbSyncValid(6);
        ----------------------------------------------------
        -- F_XYZ_FRAME
        ----------------------------------------------------
        ccRgb.ccSf.k1           <= to_sfixed(0412.000,15,-3); 
        ccRgb.ccSf.k2           <= to_sfixed(0357.000,15,-3);
        ccRgb.ccSf.k3           <= to_sfixed(0180.000,15,-3); 
        ccRgb.ccSf.k4           <= to_sfixed(0212.000,15,-3); 
        ccRgb.ccSf.k5           <= to_sfixed(0715.000,15,-3);
        ccRgb.ccSf.k6           <= to_sfixed(0072.000,15,-3); 
        ccRgb.ccSf.k7           <= to_sfixed(0019.000,15,-3); 
        ccRgb.ccSf.k8           <= to_sfixed(0119.000,15,-3);
        ccRgb.ccSf.k9           <= to_sfixed(0950.000,15,-3);
    elsif(i_k_config_number = 11)then
    oRgb.valid <= rgbSyncValid(6);
        ----------------------------------------------------
        -- F_LMS_FRAME
        ----------------------------------------------------
        ccRgb.ccSf.k1           <= to_sfixed(0400.000,15,-3); 
        ccRgb.ccSf.k2           <= to_sfixed(0707.000,15,-3);
        ccRgb.ccSf.k3           <= to_sfixed(-0080.000,15,-3); 
        ccRgb.ccSf.k4           <= to_sfixed(-0228.000,15,-3); 
        ccRgb.ccSf.k5           <= to_sfixed(1150.000,15,-3);
        ccRgb.ccSf.k6           <= to_sfixed(0061.000,15,-3); 
        ccRgb.ccSf.k7           <= to_sfixed(0000.000,15,-3); 
        ccRgb.ccSf.k8           <= to_sfixed(0000.000,15,-3);
        ccRgb.ccSf.k9           <= to_sfixed(0918.000,15,-3); 
    elsif(i_k_config_number = 12)then
    oRgb.valid <= rgbSyncValid(6);
        ----------------------------------------------------
        -- YPBPR_FRAME
        ----------------------------------------------------
        ccRgb.ccSf.k1           <= to_sfixed(0213.000,15,-3); 
        ccRgb.ccSf.k2           <= to_sfixed(0715.000,15,-3);
        ccRgb.ccSf.k3           <= to_sfixed(0072.000,15,-3); 
        ccRgb.ccSf.k4           <= to_sfixed(-0115.000,15,-3); 
        ccRgb.ccSf.k5           <= to_sfixed(-0385.000,15,-3);
        ccRgb.ccSf.k6           <= to_sfixed(0500.000,15,-3); 
        ccRgb.ccSf.k7           <= to_sfixed(0500.000,15,-3); 
        ccRgb.ccSf.k8           <= to_sfixed(-0454.000,15,-3);
        ccRgb.ccSf.k9           <= to_sfixed(-0046.000,15,-3); 
    elsif(i_k_config_number = 13)then
    oRgb.valid <= rgbSyncValid(6);
        ----------------------------------------------------
        -- F_YUV_FRAME
        ----------------------------------------------------
        ccRgb.ccSf.k1           <= to_sfixed(0299.000,15,-3); 
        ccRgb.ccSf.k2           <= to_sfixed(0587.000,15,-3);
        ccRgb.ccSf.k3           <= to_sfixed(0114.000,15,-3); 
        ccRgb.ccSf.k4           <= to_sfixed(-0147.000,15,-3); 
        ccRgb.ccSf.k5           <= to_sfixed(-0289.000,15,-3);
        ccRgb.ccSf.k6           <= to_sfixed(0436.000,15,-3); 
        ccRgb.ccSf.k7           <= to_sfixed(0615.000,15,-3); 
        ccRgb.ccSf.k8           <= to_sfixed(-0515.000,15,-3);
        ccRgb.ccSf.k9           <= to_sfixed(-0100.000,15,-3);
    elsif(i_k_config_number = 14)then
    oRgb.valid <= rgbSyncValid(6);
        ----------------------------------------------------
        -- F_YIQ_FRAME
        ----------------------------------------------------
        ccRgb.ccSf.k1           <= to_sfixed(0299.000,15,-3); 
        ccRgb.ccSf.k2           <= to_sfixed(0587.000,15,-3);
        ccRgb.ccSf.k3           <= to_sfixed(0114.000,15,-3); 
        ccRgb.ccSf.k4           <= to_sfixed(0595.000,15,-3); 
        ccRgb.ccSf.k5           <= to_sfixed(-0274.000,15,-3);
        ccRgb.ccSf.k6           <= to_sfixed(-0321.000,15,-3); 
        ccRgb.ccSf.k7           <= to_sfixed(0211.000,15,-3); 
        ccRgb.ccSf.k8           <= to_sfixed(-0522.000,15,-3);
        ccRgb.ccSf.k9           <= to_sfixed(-0311.000,15,-3);
    elsif(i_k_config_number = 15)then
    oRgb.valid <= rgbSyncValid(6);
        ----------------------------------------------------
        -- F_YDRDB_FRAME
        ----------------------------------------------------
        ccRgb.ccSf.k1           <= to_sfixed(0299.000,15,-3); 
        ccRgb.ccSf.k2           <= to_sfixed(0587.000,15,-3);
        ccRgb.ccSf.k3           <= to_sfixed(0114.000,15,-3); 
        ccRgb.ccSf.k4           <= to_sfixed(-0450.000,15,-3); 
        ccRgb.ccSf.k5           <= to_sfixed(-0883.000,15,-3);
        ccRgb.ccSf.k6           <= to_sfixed(1333.000,15,-3); 
        ccRgb.ccSf.k7           <= to_sfixed(-1333.000,15,-3); 
        ccRgb.ccSf.k8           <= to_sfixed(-1160.000,15,-3);
        ccRgb.ccSf.k9           <= to_sfixed(0217.000,15,-3);
    elsif(i_k_config_number = 16)then
    oRgb.valid <= rgbSyncValid(6);
        ----------------------------------------------------
        -- F_HED_FRAME
        ----------------------------------------------------
        
        ccRgb.ccSf.k1           <= to_sfixed(1880.000,15,-3);
        ccRgb.ccSf.k2           <= to_sfixed(-0070.000,15,-3);
        ccRgb.ccSf.k3           <= to_sfixed(-0600.000,15,-3); 
        
        ccRgb.ccSf.k4           <= to_sfixed(-1020.000,15,-3); 
        ccRgb.ccSf.k5           <= to_sfixed(-1130.000,15,-3);
        ccRgb.ccSf.k6           <= to_sfixed(-0480.000,15,-3);
        
        ccRgb.ccSf.k7           <= to_sfixed(-0550.000,15,-3); 
        ccRgb.ccSf.k8           <= to_sfixed(-0130.000,15,-3);
        ccRgb.ccSf.k9           <= to_sfixed(1570.000,15,-3);
        
    elsif(i_k_config_number = 17)then
    oRgb.valid <= rgbSyncValid(6);
        ----------------------------------------------------
        -- F_IPT_FRAME
        ----------------------------------------------------
        ccRgb.ccSf.k1           <= to_sfixed(0400.000,15,-3);
        ccRgb.ccSf.k2           <= to_sfixed(0400.000,15,-3);
        ccRgb.ccSf.k3           <= to_sfixed(0200.000,15,-3); 
        ccRgb.ccSf.k4           <= to_sfixed(4455.000,15,-3); 
        ccRgb.ccSf.k5           <= to_sfixed(-4851.000,15,-3);
        ccRgb.ccSf.k6           <= to_sfixed(3960.000,15,-3); 
        ccRgb.ccSf.k7           <= to_sfixed(8056.000,15,-3); 
        ccRgb.ccSf.k8           <= to_sfixed(3572.000,15,-3);
        ccRgb.ccSf.k9           <= to_sfixed(-1162.000,15,-3);
        
    elsif(i_k_config_number = 18)then
    oRgb.valid <= rgbSyncValid(6);
        ----------------------------------------------------
        -- F_IPT_FRAME
        ----------------------------------------------------
        ccRgb.ccSf.k1           <= to_sfixed(0100.000,15,-3);
        ccRgb.ccSf.k2           <= to_sfixed(0000.000,15,-3);
        ccRgb.ccSf.k3           <= to_sfixed(0000.000,15,-3); 
        ccRgb.ccSf.k4           <= to_sfixed(0000.000,15,-3); 
        ccRgb.ccSf.k5           <= to_sfixed(0100.000,15,-3);
        ccRgb.ccSf.k6           <= to_sfixed(0000.000,15,-3); 
        ccRgb.ccSf.k7           <= to_sfixed(0000.000,15,-3); 
        ccRgb.ccSf.k8           <= to_sfixed(0000.000,15,-3);
        ccRgb.ccSf.k9           <= to_sfixed(0100.000,15,-3);
        
    elsif(i_k_config_number = 19)then
    oRgb.valid <= rgbSyncValid(6);
        ----------------------------------------------------
        -- F_IPT_FRAME
        ----------------------------------------------------
        ccRgb.ccSf.k1           <= to_sfixed(1000.000,15,-3);
        ccRgb.ccSf.k2           <= to_sfixed(0000.000,15,-3);
        ccRgb.ccSf.k3           <= to_sfixed(0000.000,15,-3); 
        ccRgb.ccSf.k4           <= to_sfixed(0000.000,15,-3); 
        ccRgb.ccSf.k5           <= to_sfixed(1000.000,15,-3);
        ccRgb.ccSf.k6           <= to_sfixed(0000.000,15,-3); 
        ccRgb.ccSf.k7           <= to_sfixed(0000.000,15,-3); 
        ccRgb.ccSf.k8           <= to_sfixed(0000.000,15,-3);
        ccRgb.ccSf.k9           <= to_sfixed(1000.000,15,-3);
    elsif(i_k_config_number = 20)then
    oRgb.valid <= rgbSyncValid(6);
        ----------------------------------------------------
        -- F_IPT_FRAME
        ----------------------------------------------------
        ccRgb.ccSf.k1           <= to_sfixed(10000.000,15,-3);
        ccRgb.ccSf.k2           <= to_sfixed(00000.000,15,-3);
        ccRgb.ccSf.k3           <= to_sfixed(00000.000,15,-3); 
        ccRgb.ccSf.k4           <= to_sfixed(00000.000,15,-3); 
        ccRgb.ccSf.k5           <= to_sfixed(10000.000,15,-3);
        ccRgb.ccSf.k6           <= to_sfixed(00000.000,15,-3); 
        ccRgb.ccSf.k7           <= to_sfixed(00000.000,15,-3); 
        ccRgb.ccSf.k8           <= to_sfixed(00000.000,15,-3);
        ccRgb.ccSf.k9           <= to_sfixed(10000.000,15,-3);
    elsif(i_k_config_number = 101)then
        --DARK_CCM CCC1 -------------------
        ccRgb.ccSf.n1           <= 950;
        ccRgb.ccSf.n2           <= -450;
        ccRgb.ccSf.n3           <= -250;
        --DARK_CCM CCC1 -------------------
        ccRgb.ccSf.k1           <= to_sfixed(ccRgb.ccSf.n1,15,-3); 
        ccRgb.ccSf.k2           <= to_sfixed(ccRgb.ccSf.n2,15,-3);
        ccRgb.ccSf.k3           <= to_sfixed(ccRgb.ccSf.n3,15,-3); 
        ccRgb.ccSf.k4           <= to_sfixed(ccRgb.ccSf.n3,15,-3); 
        ccRgb.ccSf.k5           <= to_sfixed(ccRgb.ccSf.n1,15,-3);
        ccRgb.ccSf.k6           <= to_sfixed(ccRgb.ccSf.n2,15,-3); 
        ccRgb.ccSf.k7           <= to_sfixed(ccRgb.ccSf.n2,15,-3); 
        ccRgb.ccSf.k8           <= to_sfixed(ccRgb.ccSf.n3,15,-3);
        ccRgb.ccSf.k9           <= to_sfixed(ccRgb.ccSf.n1,15,-3);
    oRgb.valid <= rgbSyncValid(6);
    elsif(i_k_config_number = 102)then
        --LIGHT_CCM CCC1 ------------------
        ccRgb.ccSf.n1           <= 1200;
        ccRgb.ccSf.n2           <= -50;
        ccRgb.ccSf.n3           <= -100;
        --LIGHT_CCM CCC1 ------------------
        ccRgb.ccSf.k1           <= to_sfixed(ccRgb.ccSf.n1,15,-3); 
        ccRgb.ccSf.k2           <= to_sfixed(ccRgb.ccSf.n2,15,-3);
        ccRgb.ccSf.k3           <= to_sfixed(ccRgb.ccSf.n3,15,-3); 
        ccRgb.ccSf.k4           <= to_sfixed(ccRgb.ccSf.n3,15,-3); 
        ccRgb.ccSf.k5           <= to_sfixed(ccRgb.ccSf.n1,15,-3);
        ccRgb.ccSf.k6           <= to_sfixed(ccRgb.ccSf.n2,15,-3); 
        ccRgb.ccSf.k7           <= to_sfixed(ccRgb.ccSf.n2,15,-3); 
        ccRgb.ccSf.k8           <= to_sfixed(ccRgb.ccSf.n3,15,-3);
        ccRgb.ccSf.k9           <= to_sfixed(ccRgb.ccSf.n1,15,-3);
    oRgb.valid <= rgbSyncValid(6);
    elsif(i_k_config_number = 103)then
        -----------------------------------
        ccRgb.ccSf.n1           <= 1200;
        ccRgb.ccSf.n2           <= 700;
        ccRgb.ccSf.n3           <= 700;
        --balance_ccm CCC1 ----------------
        ccRgb.ccSf.k1           <= to_sfixed(ccRgb.ccSf.n1,15,-3); 
        ccRgb.ccSf.k2           <= to_sfixed(ccRgb.ccSf.n2,15,-3);
        ccRgb.ccSf.k3           <= to_sfixed(ccRgb.ccSf.n3,15,-3); 
        ccRgb.ccSf.k4           <= to_sfixed(ccRgb.ccSf.n3,15,-3); 
        ccRgb.ccSf.k5           <= to_sfixed(ccRgb.ccSf.n1,15,-3);
        ccRgb.ccSf.k6           <= to_sfixed(ccRgb.ccSf.n2,15,-3); 
        ccRgb.ccSf.k7           <= to_sfixed(ccRgb.ccSf.n2,15,-3); 
        ccRgb.ccSf.k8           <= to_sfixed(ccRgb.ccSf.n3,15,-3);
        ccRgb.ccSf.k9           <= to_sfixed(ccRgb.ccSf.n1,15,-3);
    oRgb.valid <= rgbSyncValid(6);
    elsif(i_k_config_number = 104)then
        -----------------------------------
        ccRgb.ccSf.n1           <= 820;
        ccRgb.ccSf.n2           <= -180;
        ccRgb.ccSf.n3           <= -100;
        --dark_ccm CCC2 -------------------
        ccRgb.ccSf.k1           <= to_sfixed(ccRgb.ccSf.n1,15,-3); 
        ccRgb.ccSf.k2           <= to_sfixed(ccRgb.ccSf.n2,15,-3);
        ccRgb.ccSf.k3           <= to_sfixed(ccRgb.ccSf.n3,15,-3); 
        ccRgb.ccSf.k4           <= to_sfixed(ccRgb.ccSf.n3,15,-3); 
        ccRgb.ccSf.k5           <= to_sfixed(ccRgb.ccSf.n1,15,-3);
        ccRgb.ccSf.k6           <= to_sfixed(ccRgb.ccSf.n2,15,-3); 
        ccRgb.ccSf.k7           <= to_sfixed(ccRgb.ccSf.n2,15,-3); 
        ccRgb.ccSf.k8           <= to_sfixed(ccRgb.ccSf.n3,15,-3);
        ccRgb.ccSf.k9           <= to_sfixed(ccRgb.ccSf.n1,15,-3);
    oRgb.valid <= rgbSyncValid(6);
    elsif(i_k_config_number = 105)then
        -----------------------------------
        ccRgb.ccSf.n1           <= 1600;
        ccRgb.ccSf.n2           <= -500;
        ccRgb.ccSf.n3           <= -600;
        --light_ccm CCC2 ------------------
        ccRgb.ccSf.k1           <= to_sfixed(ccRgb.ccSf.n1,15,-3); 
        ccRgb.ccSf.k2           <= to_sfixed(ccRgb.ccSf.n2,15,-3);
        ccRgb.ccSf.k3           <= to_sfixed(ccRgb.ccSf.n3,15,-3); 
        ccRgb.ccSf.k4           <= to_sfixed(ccRgb.ccSf.n3,15,-3); 
        ccRgb.ccSf.k5           <= to_sfixed(ccRgb.ccSf.n1,15,-3);
        ccRgb.ccSf.k6           <= to_sfixed(ccRgb.ccSf.n2,15,-3); 
        ccRgb.ccSf.k7           <= to_sfixed(ccRgb.ccSf.n2,15,-3); 
        ccRgb.ccSf.k8           <= to_sfixed(ccRgb.ccSf.n3,15,-3);
        ccRgb.ccSf.k9           <= to_sfixed(ccRgb.ccSf.n1,15,-3);
    oRgb.valid <= rgbSyncValid(6);
    elsif(i_k_config_number = 106)then
        -----------------------------------
        ccRgb.ccSf.n1           <= 1200;
        ccRgb.ccSf.n2           <= 800;
        ccRgb.ccSf.n3           <= 750;
        --balance_ccm CCC2 ----------------
        ccRgb.ccSf.k1           <= to_sfixed(ccRgb.ccSf.n1,15,-3); 
        ccRgb.ccSf.k2           <= to_sfixed(ccRgb.ccSf.n2,15,-3);
        ccRgb.ccSf.k3           <= to_sfixed(ccRgb.ccSf.n3,15,-3); 
        ccRgb.ccSf.k4           <= to_sfixed(ccRgb.ccSf.n3,15,-3); 
        ccRgb.ccSf.k5           <= to_sfixed(ccRgb.ccSf.n1,15,-3);
        ccRgb.ccSf.k6           <= to_sfixed(ccRgb.ccSf.n2,15,-3); 
        ccRgb.ccSf.k7           <= to_sfixed(ccRgb.ccSf.n2,15,-3); 
        ccRgb.ccSf.k8           <= to_sfixed(ccRgb.ccSf.n3,15,-3);
        ccRgb.ccSf.k9           <= to_sfixed(ccRgb.ccSf.n1,15,-3);
    oRgb.valid <= rgbSyncValid(6);
    elsif(i_k_config_number = 107)then
        -----------------------------------
        ccRgb.ccSf.n1           <= 925;
        ccRgb.ccSf.n2           <= -425;
        ccRgb.ccSf.n3           <= -200;
        --dark_ccm CCC3 -------------------
        ccRgb.ccSf.k1           <= to_sfixed(ccRgb.ccSf.n1,15,-3); 
        ccRgb.ccSf.k2           <= to_sfixed(ccRgb.ccSf.n2,15,-3);
        ccRgb.ccSf.k3           <= to_sfixed(ccRgb.ccSf.n3,15,-3); 
        ccRgb.ccSf.k4           <= to_sfixed(ccRgb.ccSf.n3,15,-3); 
        ccRgb.ccSf.k5           <= to_sfixed(ccRgb.ccSf.n1,15,-3);
        ccRgb.ccSf.k6           <= to_sfixed(ccRgb.ccSf.n2,15,-3); 
        ccRgb.ccSf.k7           <= to_sfixed(ccRgb.ccSf.n2,15,-3); 
        ccRgb.ccSf.k8           <= to_sfixed(ccRgb.ccSf.n3,15,-3);
        ccRgb.ccSf.k9           <= to_sfixed(ccRgb.ccSf.n1,15,-3);
    oRgb.valid <= rgbSyncValid(6);
    elsif(i_k_config_number = 108)then
        -----------------------------------
        ccRgb.ccSf.n1           <= 1200;
        ccRgb.ccSf.n2           <= -400;
        ccRgb.ccSf.n3           <= -600;
        --light_ccm CCC3 ------------------
        ccRgb.ccSf.k1           <= to_sfixed(ccRgb.ccSf.n1,15,-3); 
        ccRgb.ccSf.k2           <= to_sfixed(ccRgb.ccSf.n2,15,-3);
        ccRgb.ccSf.k3           <= to_sfixed(ccRgb.ccSf.n3,15,-3); 
        ccRgb.ccSf.k4           <= to_sfixed(ccRgb.ccSf.n3,15,-3); 
        ccRgb.ccSf.k5           <= to_sfixed(ccRgb.ccSf.n1,15,-3);
        ccRgb.ccSf.k6           <= to_sfixed(ccRgb.ccSf.n2,15,-3); 
        ccRgb.ccSf.k7           <= to_sfixed(ccRgb.ccSf.n2,15,-3); 
        ccRgb.ccSf.k8           <= to_sfixed(ccRgb.ccSf.n3,15,-3);
        ccRgb.ccSf.k9           <= to_sfixed(ccRgb.ccSf.n1,15,-3);
    oRgb.valid <= rgbSyncValid(6);
    elsif(i_k_config_number = 109)then
        -----------------------------------
        ccRgb.ccSf.n1           <= 3200;
        ccRgb.ccSf.n2           <= 2400;
        ccRgb.ccSf.n3           <= 1600;
        --balance_ccm CCC3 ----------------
        ccRgb.ccSf.k1           <= to_sfixed(3200,15,-3); 
        ccRgb.ccSf.k2           <= to_sfixed(1200,15,-3);
        ccRgb.ccSf.k3           <= to_sfixed(800,15,-3);
        ccRgb.ccSf.k4           <= to_sfixed(1600,15,-3); 
        ccRgb.ccSf.k5           <= to_sfixed(2800,15,-3);
        ccRgb.ccSf.k6           <= to_sfixed(2000,15,-3); 
        ccRgb.ccSf.k7           <= to_sfixed(1400,15,-3); 
        ccRgb.ccSf.k8           <= to_sfixed(1800,15,-3);
        ccRgb.ccSf.k9           <= to_sfixed(3200,15,-3);
    oRgb.valid <= rgbSyncValid(6);
    elsif(i_k_config_number = 110)then
        -----------------------------------
        ccRgb.ccSf.n1           <= 1840;
        ccRgb.ccSf.n2           <= -850;
        ccRgb.ccSf.n3           <= -400;
        --dark_ccm CCC4 -------------------
        ccRgb.ccSf.k1           <= to_sfixed(ccRgb.ccSf.n1,15,-3); 
        ccRgb.ccSf.k2           <= to_sfixed(ccRgb.ccSf.n2,15,-3);
        ccRgb.ccSf.k3           <= to_sfixed(ccRgb.ccSf.n3,15,-3); 
        ccRgb.ccSf.k4           <= to_sfixed(ccRgb.ccSf.n3,15,-3); 
        ccRgb.ccSf.k5           <= to_sfixed(ccRgb.ccSf.n1,15,-3);
        ccRgb.ccSf.k6           <= to_sfixed(ccRgb.ccSf.n2,15,-3); 
        ccRgb.ccSf.k7           <= to_sfixed(ccRgb.ccSf.n2,15,-3); 
        ccRgb.ccSf.k8           <= to_sfixed(ccRgb.ccSf.n3,15,-3);
        ccRgb.ccSf.k9           <= to_sfixed(ccRgb.ccSf.n1,15,-3);
    oRgb.valid <= rgbSyncValid(6);
    elsif(i_k_config_number = 111)then
        -----------------------------------
        ccRgb.ccSf.n1           <= 1200;
        ccRgb.ccSf.n2           <= -570;
        ccRgb.ccSf.n3           <= -430;
        --light_ccm CCC4 ------------------
        ccRgb.ccSf.k1           <= to_sfixed(ccRgb.ccSf.n1,15,-3); 
        ccRgb.ccSf.k2           <= to_sfixed(ccRgb.ccSf.n2,15,-3);
        ccRgb.ccSf.k3           <= to_sfixed(ccRgb.ccSf.n3,15,-3); 
        ccRgb.ccSf.k4           <= to_sfixed(ccRgb.ccSf.n3,15,-3); 
        ccRgb.ccSf.k5           <= to_sfixed(ccRgb.ccSf.n1,15,-3);
        ccRgb.ccSf.k6           <= to_sfixed(ccRgb.ccSf.n2,15,-3); 
        ccRgb.ccSf.k7           <= to_sfixed(ccRgb.ccSf.n2,15,-3); 
        ccRgb.ccSf.k8           <= to_sfixed(ccRgb.ccSf.n3,15,-3);
        ccRgb.ccSf.k9           <= to_sfixed(ccRgb.ccSf.n1,15,-3);
    oRgb.valid <= rgbSyncValid(6);
    elsif(i_k_config_number = 112)then
        -----------------------------------
        ccRgb.ccSf.n1           <= 2400;
        ccRgb.ccSf.n2           <= 950;
        ccRgb.ccSf.n3           <= 800;
        --balance_ccm CCC4 ----------------
        ccRgb.ccSf.k1           <= to_sfixed(3400,15,-3); 
        ccRgb.ccSf.k2           <= to_sfixed(950,15,-3);
        ccRgb.ccSf.k3           <= to_sfixed(800,15,-3); 
        ccRgb.ccSf.k4           <= to_sfixed(ccRgb.ccSf.n3,15,-3); 
        ccRgb.ccSf.k5           <= to_sfixed(ccRgb.ccSf.n1,15,-3);
        ccRgb.ccSf.k6           <= to_sfixed(ccRgb.ccSf.n2,15,-3); 
        ccRgb.ccSf.k7           <= to_sfixed(ccRgb.ccSf.n2,15,-3); 
        ccRgb.ccSf.k8           <= to_sfixed(ccRgb.ccSf.n3,15,-3);
        ccRgb.ccSf.k9           <= to_sfixed(ccRgb.ccSf.n1,15,-3);
    oRgb.valid <= rgbSyncValid(6);
    elsif(i_k_config_number = 113)then
        -----------------------------------
        ccRgb.ccSf.n1           <= 1600;
        ccRgb.ccSf.n2           <= -800;
        ccRgb.ccSf.n3           <= -400;
        --dark_ccm CCC5 -------------------
        ccRgb.ccSf.k1           <= to_sfixed(ccRgb.ccSf.n1,15,-3); 
        ccRgb.ccSf.k2           <= to_sfixed(ccRgb.ccSf.n2,15,-3);
        ccRgb.ccSf.k3           <= to_sfixed(ccRgb.ccSf.n3,15,-3); 
        ccRgb.ccSf.k4           <= to_sfixed(ccRgb.ccSf.n3,15,-3); 
        ccRgb.ccSf.k5           <= to_sfixed(ccRgb.ccSf.n1,15,-3);
        ccRgb.ccSf.k6           <= to_sfixed(ccRgb.ccSf.n2,15,-3); 
        ccRgb.ccSf.k7           <= to_sfixed(ccRgb.ccSf.n2,15,-3); 
        ccRgb.ccSf.k8           <= to_sfixed(ccRgb.ccSf.n3,15,-3);
        ccRgb.ccSf.k9           <= to_sfixed(ccRgb.ccSf.n1,15,-3);
    oRgb.valid <= rgbSyncValid(6);
    elsif(i_k_config_number = 114)then
        -----------------------------------
        ccRgb.ccSf.n1           <= 1600;
        ccRgb.ccSf.n2           <= -500;
        ccRgb.ccSf.n3           <= -300;
        --light_ccm CCC5 ------------------
        ccRgb.ccSf.k1           <= to_sfixed(ccRgb.ccSf.n1,15,-3); 
        ccRgb.ccSf.k2           <= to_sfixed(ccRgb.ccSf.n2,15,-3);
        ccRgb.ccSf.k3           <= to_sfixed(ccRgb.ccSf.n3,15,-3); 
        ccRgb.ccSf.k4           <= to_sfixed(ccRgb.ccSf.n3,15,-3); 
        ccRgb.ccSf.k5           <= to_sfixed(ccRgb.ccSf.n1,15,-3);
        ccRgb.ccSf.k6           <= to_sfixed(ccRgb.ccSf.n2,15,-3); 
        ccRgb.ccSf.k7           <= to_sfixed(ccRgb.ccSf.n2,15,-3); 
        ccRgb.ccSf.k8           <= to_sfixed(ccRgb.ccSf.n3,15,-3);
        ccRgb.ccSf.k9           <= to_sfixed(ccRgb.ccSf.n1,15,-3);
    oRgb.valid <= rgbSyncValid(6);
    elsif(i_k_config_number = 115)then
        -----------------------------------
        ccRgb.ccSf.n1           <= 950;
        ccRgb.ccSf.n2           <= 650;
        ccRgb.ccSf.n3           <= 550;
        --balance_ccm CCC5 ----------------
        ccRgb.ccSf.k1           <= to_sfixed(ccRgb.ccSf.n1,15,-3); 
        ccRgb.ccSf.k2           <= to_sfixed(ccRgb.ccSf.n2,15,-3);
        ccRgb.ccSf.k3           <= to_sfixed(ccRgb.ccSf.n3,15,-3); 
        ccRgb.ccSf.k4           <= to_sfixed(ccRgb.ccSf.n3,15,-3); 
        ccRgb.ccSf.k5           <= to_sfixed(ccRgb.ccSf.n1,15,-3);
        ccRgb.ccSf.k6           <= to_sfixed(ccRgb.ccSf.n2,15,-3); 
        ccRgb.ccSf.k7           <= to_sfixed(ccRgb.ccSf.n2,15,-3); 
        ccRgb.ccSf.k8           <= to_sfixed(ccRgb.ccSf.n3,15,-3);
        ccRgb.ccSf.k9           <= to_sfixed(ccRgb.ccSf.n1,15,-3);
    oRgb.valid <= rgbSyncValid(6);
    elsif(i_k_config_number = 116)then
        -----------------------------------
        ccRgb.ccSf.n1           <= 1850;
        ccRgb.ccSf.n2           <= -850;
        ccRgb.ccSf.n3           <= -400;
        --dark_ccm CCC6 -------------------
        ccRgb.ccSf.k1           <= to_sfixed(ccRgb.ccSf.n1,15,-3); 
        ccRgb.ccSf.k2           <= to_sfixed(ccRgb.ccSf.n2,15,-3);
        ccRgb.ccSf.k3           <= to_sfixed(ccRgb.ccSf.n3,15,-3); 
        ccRgb.ccSf.k4           <= to_sfixed(ccRgb.ccSf.n3,15,-3); 
        ccRgb.ccSf.k5           <= to_sfixed(ccRgb.ccSf.n1,15,-3);
        ccRgb.ccSf.k6           <= to_sfixed(ccRgb.ccSf.n2,15,-3); 
        ccRgb.ccSf.k7           <= to_sfixed(ccRgb.ccSf.n2,15,-3); 
        ccRgb.ccSf.k8           <= to_sfixed(ccRgb.ccSf.n3,15,-3);
        ccRgb.ccSf.k9           <= to_sfixed(ccRgb.ccSf.n1,15,-3);
    oRgb.valid <= rgbSyncValid(6);
    elsif(i_k_config_number = 117)then
        -----------------------------------
        ccRgb.ccSf.n1           <= 1700;
        ccRgb.ccSf.n2           <= -600;
        ccRgb.ccSf.n3           <= -200;
        --light_ccm CCC6 ------------------
        ccRgb.ccSf.k1           <= to_sfixed(ccRgb.ccSf.n1,15,-3); 
        ccRgb.ccSf.k2           <= to_sfixed(ccRgb.ccSf.n2,15,-3);
        ccRgb.ccSf.k3           <= to_sfixed(ccRgb.ccSf.n3,15,-3); 
        ccRgb.ccSf.k4           <= to_sfixed(ccRgb.ccSf.n3,15,-3); 
        ccRgb.ccSf.k5           <= to_sfixed(ccRgb.ccSf.n1,15,-3);
        ccRgb.ccSf.k6           <= to_sfixed(ccRgb.ccSf.n2,15,-3); 
        ccRgb.ccSf.k7           <= to_sfixed(ccRgb.ccSf.n2,15,-3); 
        ccRgb.ccSf.k8           <= to_sfixed(ccRgb.ccSf.n3,15,-3);
        ccRgb.ccSf.k9           <= to_sfixed(ccRgb.ccSf.n1,15,-3);
    oRgb.valid <= rgbSyncValid(6);
    elsif(i_k_config_number = 118)then
        -----------------------------------
        ccRgb.ccSf.n1           <= 550;
        ccRgb.ccSf.n2           <= 375;
        ccRgb.ccSf.n3           <= 350;
        --balance_ccm CCC6 ----------------
        ccRgb.ccSf.k1           <= to_sfixed(ccRgb.ccSf.n1,15,-3); 
        ccRgb.ccSf.k2           <= to_sfixed(ccRgb.ccSf.n2,15,-3);
        ccRgb.ccSf.k3           <= to_sfixed(ccRgb.ccSf.n3,15,-3); 
        ccRgb.ccSf.k4           <= to_sfixed(ccRgb.ccSf.n3,15,-3); 
        ccRgb.ccSf.k5           <= to_sfixed(ccRgb.ccSf.n1,15,-3);
        ccRgb.ccSf.k6           <= to_sfixed(ccRgb.ccSf.n2,15,-3); 
        ccRgb.ccSf.k7           <= to_sfixed(ccRgb.ccSf.n2,15,-3); 
        ccRgb.ccSf.k8           <= to_sfixed(ccRgb.ccSf.n3,15,-3);
        ccRgb.ccSf.k9           <= to_sfixed(ccRgb.ccSf.n1,15,-3);
    oRgb.valid <= rgbSyncValid(6);
    elsif(i_k_config_number = 119)then
        -----------------------------------
        ccRgb.ccSf.n1           <= 1500;
        ccRgb.ccSf.n2           <= -650;
        ccRgb.ccSf.n3           <= -650;
        --dark_ccm CCC7 -------------------
        ccRgb.ccSf.k1           <= to_sfixed(ccRgb.ccSf.n1,15,-3); 
        ccRgb.ccSf.k2           <= to_sfixed(ccRgb.ccSf.n2,15,-3);
        ccRgb.ccSf.k3           <= to_sfixed(ccRgb.ccSf.n3,15,-3); 
        ccRgb.ccSf.k4           <= to_sfixed(ccRgb.ccSf.n3,15,-3); 
        ccRgb.ccSf.k5           <= to_sfixed(ccRgb.ccSf.n1,15,-3);
        ccRgb.ccSf.k6           <= to_sfixed(ccRgb.ccSf.n2,15,-3); 
        ccRgb.ccSf.k7           <= to_sfixed(ccRgb.ccSf.n2,15,-3); 
        ccRgb.ccSf.k8           <= to_sfixed(ccRgb.ccSf.n3,15,-3);
        ccRgb.ccSf.k9           <= to_sfixed(ccRgb.ccSf.n1,15,-3);
    oRgb.valid <= rgbSyncValid(6);
    elsif(i_k_config_number = 120)then
        -----------------------------------
        ccRgb.ccSf.n1           <= 1000;
        ccRgb.ccSf.n2           <= -125;
        ccRgb.ccSf.n3           <= -125;
        --light_ccm CCC7 ------------------
        ccRgb.ccSf.k1           <= to_sfixed(ccRgb.ccSf.n1,15,-3); 
        ccRgb.ccSf.k2           <= to_sfixed(ccRgb.ccSf.n2,15,-3);
        ccRgb.ccSf.k3           <= to_sfixed(ccRgb.ccSf.n3,15,-3); 
        ccRgb.ccSf.k4           <= to_sfixed(ccRgb.ccSf.n3,15,-3); 
        ccRgb.ccSf.k5           <= to_sfixed(ccRgb.ccSf.n1,15,-3);
        ccRgb.ccSf.k6           <= to_sfixed(ccRgb.ccSf.n2,15,-3); 
        ccRgb.ccSf.k7           <= to_sfixed(ccRgb.ccSf.n2,15,-3); 
        ccRgb.ccSf.k8           <= to_sfixed(ccRgb.ccSf.n3,15,-3);
        ccRgb.ccSf.k9           <= to_sfixed(ccRgb.ccSf.n1,15,-3);
    oRgb.valid <= rgbSyncValid(6);
    elsif(i_k_config_number = 121)then
        -----------------------------------
        ccRgb.ccSf.n1           <= 1800;
        ccRgb.ccSf.n2           <= 1400;
        ccRgb.ccSf.n3           <= 1400;
        --balance_ccm CCC7 ----------------
        ccRgb.ccSf.k1           <= to_sfixed(ccRgb.ccSf.n1,15,-3); 
        ccRgb.ccSf.k2           <= to_sfixed(ccRgb.ccSf.n2,15,-3);
        ccRgb.ccSf.k3           <= to_sfixed(ccRgb.ccSf.n3,15,-3); 
        ccRgb.ccSf.k4           <= to_sfixed(ccRgb.ccSf.n3,15,-3); 
        ccRgb.ccSf.k5           <= to_sfixed(ccRgb.ccSf.n1,15,-3);
        ccRgb.ccSf.k6           <= to_sfixed(ccRgb.ccSf.n2,15,-3); 
        ccRgb.ccSf.k7           <= to_sfixed(ccRgb.ccSf.n2,15,-3); 
        ccRgb.ccSf.k8           <= to_sfixed(ccRgb.ccSf.n3,15,-3);
        ccRgb.ccSf.k9           <= to_sfixed(ccRgb.ccSf.n1,15,-3);
    oRgb.valid <= rgbSyncValid(6);
    elsif(i_k_config_number = 122)then
        -----------------------------------
        ccRgb.ccSf.n1           <= 1650;
        ccRgb.ccSf.n2           <= -850;
        ccRgb.ccSf.n3           <= -400;
        --dark_ccm CCC8 -------------------
        ccRgb.ccSf.k1           <= to_sfixed(ccRgb.ccSf.n1,15,-3); 
        ccRgb.ccSf.k2           <= to_sfixed(ccRgb.ccSf.n2,15,-3);
        ccRgb.ccSf.k3           <= to_sfixed(ccRgb.ccSf.n3,15,-3); 
        ccRgb.ccSf.k4           <= to_sfixed(ccRgb.ccSf.n3,15,-3); 
        ccRgb.ccSf.k5           <= to_sfixed(ccRgb.ccSf.n1,15,-3);
        ccRgb.ccSf.k6           <= to_sfixed(ccRgb.ccSf.n2,15,-3); 
        ccRgb.ccSf.k7           <= to_sfixed(ccRgb.ccSf.n2,15,-3); 
        ccRgb.ccSf.k8           <= to_sfixed(ccRgb.ccSf.n3,15,-3);
        ccRgb.ccSf.k9           <= to_sfixed(ccRgb.ccSf.n1,15,-3);
    oRgb.valid <= rgbSyncValid(6);
    elsif(i_k_config_number = 123)then
        -----------------------------------
        ccRgb.ccSf.n1           <= 1800;
        ccRgb.ccSf.n2           <= -200;
        ccRgb.ccSf.n3           <= -600;
        -- light_ccm CCC8 -----------------
        ccRgb.ccSf.k1           <= to_sfixed(ccRgb.ccSf.n1,15,-3); 
        ccRgb.ccSf.k2           <= to_sfixed(ccRgb.ccSf.n2,15,-3);
        ccRgb.ccSf.k3           <= to_sfixed(ccRgb.ccSf.n3,15,-3); 
        ccRgb.ccSf.k4           <= to_sfixed(ccRgb.ccSf.n3,15,-3); 
        ccRgb.ccSf.k5           <= to_sfixed(ccRgb.ccSf.n1,15,-3);
        ccRgb.ccSf.k6           <= to_sfixed(ccRgb.ccSf.n2,15,-3); 
        ccRgb.ccSf.k7           <= to_sfixed(ccRgb.ccSf.n2,15,-3); 
        ccRgb.ccSf.k8           <= to_sfixed(ccRgb.ccSf.n3,15,-3);
        ccRgb.ccSf.k9           <= to_sfixed(ccRgb.ccSf.n1,15,-3);
    oRgb.valid <= rgbSyncValid(6);
    elsif(i_k_config_number = 124)then
        -----------------------------------
        ccRgb.ccSf.n1           <= 800;
        ccRgb.ccSf.n2           <= 350;
        ccRgb.ccSf.n3           <= 550;
        -- balance_ccm CCC8 ---------------
        ccRgb.ccSf.k1           <= to_sfixed(ccRgb.ccSf.n1,15,-3); 
        ccRgb.ccSf.k2           <= to_sfixed(ccRgb.ccSf.n2,15,-3);
        ccRgb.ccSf.k3           <= to_sfixed(ccRgb.ccSf.n3,15,-3); 
        ccRgb.ccSf.k4           <= to_sfixed(ccRgb.ccSf.n3,15,-3); 
        ccRgb.ccSf.k5           <= to_sfixed(ccRgb.ccSf.n1,15,-3);
        ccRgb.ccSf.k6           <= to_sfixed(ccRgb.ccSf.n2,15,-3); 
        ccRgb.ccSf.k7           <= to_sfixed(ccRgb.ccSf.n2,15,-3); 
        ccRgb.ccSf.k8           <= to_sfixed(ccRgb.ccSf.n3,15,-3);
        ccRgb.ccSf.k9           <= to_sfixed(ccRgb.ccSf.n1,15,-3);
    oRgb.valid <= rgbSyncValid(6);
    elsif(i_k_config_number = 201)then
        --dark_ccm CCC1
        ccRgb.ccSf.n1           <= 1000;
        ccRgb.ccSf.n2           <= -400;
        ccRgb.ccSf.n3           <= -350;
        ccRgb.ccSf.k1           <= to_sfixed(ccRgb.ccSf.n1,15,-3); 
        ccRgb.ccSf.k2           <= to_sfixed(ccRgb.ccSf.n2,15,-3);
        ccRgb.ccSf.k3           <= to_sfixed(ccRgb.ccSf.n3,15,-3); 
        ccRgb.ccSf.k4           <= to_sfixed(ccRgb.ccSf.n3,15,-3); 
        ccRgb.ccSf.k5           <= to_sfixed(ccRgb.ccSf.n1,15,-3);
        ccRgb.ccSf.k6           <= to_sfixed(ccRgb.ccSf.n2,15,-3); 
        ccRgb.ccSf.k7           <= to_sfixed(ccRgb.ccSf.n2,15,-3); 
        ccRgb.ccSf.k8           <= to_sfixed(ccRgb.ccSf.n3,15,-3);
        ccRgb.ccSf.k9           <= to_sfixed(ccRgb.ccSf.n1,15,-3);
    oRgb.valid <= rgbSyncValid(6);
    elsif(i_k_config_number = 202)then
        --light_ccm CCC1
        ccRgb.ccSf.n1           <= 3500;
        ccRgb.ccSf.n2           <= -750;
        ccRgb.ccSf.n3           <= -1500;
        ccRgb.ccSf.k1           <= to_sfixed(ccRgb.ccSf.n1,15,-3); 
        ccRgb.ccSf.k2           <= to_sfixed(ccRgb.ccSf.n2,15,-3);
        ccRgb.ccSf.k3           <= to_sfixed(ccRgb.ccSf.n3,15,-3); 
        ccRgb.ccSf.k4           <= to_sfixed(ccRgb.ccSf.n3,15,-3); 
        ccRgb.ccSf.k5           <= to_sfixed(ccRgb.ccSf.n1,15,-3);
        ccRgb.ccSf.k6           <= to_sfixed(ccRgb.ccSf.n2,15,-3); 
        ccRgb.ccSf.k7           <= to_sfixed(ccRgb.ccSf.n2,15,-3); 
        ccRgb.ccSf.k8           <= to_sfixed(ccRgb.ccSf.n3,15,-3);
        ccRgb.ccSf.k9           <= to_sfixed(ccRgb.ccSf.n1,15,-3);
    oRgb.valid <= rgbSyncValid(6);
    elsif(i_k_config_number = 203)then
        --balance_ccm CCC1
        ccRgb.ccSf.n1           <= 1000;
        ccRgb.ccSf.n2           <= 450;
        ccRgb.ccSf.n3           <= 500;
        ccRgb.ccSf.k1           <= to_sfixed(ccRgb.ccSf.n1,15,-3); 
        ccRgb.ccSf.k2           <= to_sfixed(ccRgb.ccSf.n2,15,-3);
        ccRgb.ccSf.k3           <= to_sfixed(ccRgb.ccSf.n3,15,-3); 
        ccRgb.ccSf.k4           <= to_sfixed(ccRgb.ccSf.n3,15,-3); 
        ccRgb.ccSf.k5           <= to_sfixed(ccRgb.ccSf.n1,15,-3);
        ccRgb.ccSf.k6           <= to_sfixed(ccRgb.ccSf.n2,15,-3); 
        ccRgb.ccSf.k7           <= to_sfixed(ccRgb.ccSf.n2,15,-3); 
        ccRgb.ccSf.k8           <= to_sfixed(ccRgb.ccSf.n3,15,-3);
        ccRgb.ccSf.k9           <= to_sfixed(ccRgb.ccSf.n1,15,-3);
    oRgb.valid <= rgbSyncValid(6);
    elsif(i_k_config_number = 204)then
        --dark_ccm CCC2
        ccRgb.ccSf.n1           <= 1300;
        ccRgb.ccSf.n2           <= -600;
        ccRgb.ccSf.n3           <= -550;
        ccRgb.ccSf.k1           <= to_sfixed(ccRgb.ccSf.n1,15,-3); 
        ccRgb.ccSf.k2           <= to_sfixed(ccRgb.ccSf.n2,15,-3);
        ccRgb.ccSf.k3           <= to_sfixed(ccRgb.ccSf.n3,15,-3); 
        ccRgb.ccSf.k4           <= to_sfixed(ccRgb.ccSf.n3,15,-3); 
        ccRgb.ccSf.k5           <= to_sfixed(ccRgb.ccSf.n1,15,-3);
        ccRgb.ccSf.k6           <= to_sfixed(ccRgb.ccSf.n2,15,-3); 
        ccRgb.ccSf.k7           <= to_sfixed(ccRgb.ccSf.n2,15,-3); 
        ccRgb.ccSf.k8           <= to_sfixed(ccRgb.ccSf.n3,15,-3);
        ccRgb.ccSf.k9           <= to_sfixed(ccRgb.ccSf.n1,15,-3);
    oRgb.valid <= rgbSyncValid(6);
    elsif(i_k_config_number = 205)then
        --light_ccm CCC2
        ccRgb.ccSf.n1           <= 3000;
        ccRgb.ccSf.n2           <= -500;
        ccRgb.ccSf.n3           <= -1500;
        ccRgb.ccSf.k1           <= to_sfixed(ccRgb.ccSf.n1,15,-3); 
        ccRgb.ccSf.k2           <= to_sfixed(ccRgb.ccSf.n2,15,-3);
        ccRgb.ccSf.k3           <= to_sfixed(ccRgb.ccSf.n3,15,-3); 
        ccRgb.ccSf.k4           <= to_sfixed(ccRgb.ccSf.n3,15,-3); 
        ccRgb.ccSf.k5           <= to_sfixed(ccRgb.ccSf.n1,15,-3);
        ccRgb.ccSf.k6           <= to_sfixed(ccRgb.ccSf.n2,15,-3); 
        ccRgb.ccSf.k7           <= to_sfixed(ccRgb.ccSf.n2,15,-3); 
        ccRgb.ccSf.k8           <= to_sfixed(ccRgb.ccSf.n3,15,-3);
        ccRgb.ccSf.k9           <= to_sfixed(ccRgb.ccSf.n1,15,-3);
    oRgb.valid <= rgbSyncValid(6);
    elsif(i_k_config_number = 206)then
        --balance_ccm CCC2
        ccRgb.ccSf.n1           <= 1200;
        ccRgb.ccSf.n2           <= 500;
        ccRgb.ccSf.n3           <= 700;
        ccRgb.ccSf.k1           <= to_sfixed(ccRgb.ccSf.n1,15,-3); 
        ccRgb.ccSf.k2           <= to_sfixed(ccRgb.ccSf.n2,15,-3);
        ccRgb.ccSf.k3           <= to_sfixed(ccRgb.ccSf.n3,15,-3); 
        ccRgb.ccSf.k4           <= to_sfixed(ccRgb.ccSf.n3,15,-3); 
        ccRgb.ccSf.k5           <= to_sfixed(ccRgb.ccSf.n1,15,-3);
        ccRgb.ccSf.k6           <= to_sfixed(ccRgb.ccSf.n2,15,-3); 
        ccRgb.ccSf.k7           <= to_sfixed(ccRgb.ccSf.n2,15,-3); 
        ccRgb.ccSf.k8           <= to_sfixed(ccRgb.ccSf.n3,15,-3);
        ccRgb.ccSf.k9           <= to_sfixed(ccRgb.ccSf.n1,15,-3);
    oRgb.valid <= rgbSyncValid(6);
    elsif(i_k_config_number = 207)then
        --dark_ccm CCC3
        ccRgb.ccSf.n1           <= 1200;
        ccRgb.ccSf.n2           <= -500;
        ccRgb.ccSf.n3           <= -450;
        ccRgb.ccSf.k1           <= to_sfixed(ccRgb.ccSf.n1,15,-3); 
        ccRgb.ccSf.k2           <= to_sfixed(ccRgb.ccSf.n2,15,-3);
        ccRgb.ccSf.k3           <= to_sfixed(ccRgb.ccSf.n3,15,-3); 
        ccRgb.ccSf.k4           <= to_sfixed(ccRgb.ccSf.n3,15,-3); 
        ccRgb.ccSf.k5           <= to_sfixed(ccRgb.ccSf.n1,15,-3);
        ccRgb.ccSf.k6           <= to_sfixed(ccRgb.ccSf.n2,15,-3); 
        ccRgb.ccSf.k7           <= to_sfixed(ccRgb.ccSf.n2,15,-3); 
        ccRgb.ccSf.k8           <= to_sfixed(ccRgb.ccSf.n3,15,-3);
        ccRgb.ccSf.k9           <= to_sfixed(ccRgb.ccSf.n1,15,-3);
    oRgb.valid <= rgbSyncValid(6);
    elsif(i_k_config_number = 208)then
        --light_ccm CCC3
        ccRgb.ccSf.n1           <= 3000;
        ccRgb.ccSf.n2           <= -500;
        ccRgb.ccSf.n3           <= -1500;
        ccRgb.ccSf.k1           <= to_sfixed(ccRgb.ccSf.n1,15,-3); 
        ccRgb.ccSf.k2           <= to_sfixed(ccRgb.ccSf.n2,15,-3);
        ccRgb.ccSf.k3           <= to_sfixed(ccRgb.ccSf.n3,15,-3); 
        ccRgb.ccSf.k4           <= to_sfixed(ccRgb.ccSf.n3,15,-3); 
        ccRgb.ccSf.k5           <= to_sfixed(ccRgb.ccSf.n1,15,-3);
        ccRgb.ccSf.k6           <= to_sfixed(ccRgb.ccSf.n2,15,-3); 
        ccRgb.ccSf.k7           <= to_sfixed(ccRgb.ccSf.n2,15,-3); 
        ccRgb.ccSf.k8           <= to_sfixed(ccRgb.ccSf.n3,15,-3);
        ccRgb.ccSf.k9           <= to_sfixed(ccRgb.ccSf.n1,15,-3);
    oRgb.valid <= rgbSyncValid(6);
    elsif(i_k_config_number = 209)then
        --balance_ccm CCC3
        ccRgb.ccSf.n1           <= 900;
        ccRgb.ccSf.n2           <= 450;
        ccRgb.ccSf.n3           <= 650;
        ccRgb.ccSf.k1           <= to_sfixed(ccRgb.ccSf.n1,15,-3); 
        ccRgb.ccSf.k2           <= to_sfixed(ccRgb.ccSf.n2,15,-3);
        ccRgb.ccSf.k3           <= to_sfixed(ccRgb.ccSf.n3,15,-3); 
        ccRgb.ccSf.k4           <= to_sfixed(ccRgb.ccSf.n3,15,-3); 
        ccRgb.ccSf.k5           <= to_sfixed(ccRgb.ccSf.n1,15,-3);
        ccRgb.ccSf.k6           <= to_sfixed(ccRgb.ccSf.n2,15,-3); 
        ccRgb.ccSf.k7           <= to_sfixed(ccRgb.ccSf.n2,15,-3); 
        ccRgb.ccSf.k8           <= to_sfixed(ccRgb.ccSf.n3,15,-3);
        ccRgb.ccSf.k9           <= to_sfixed(ccRgb.ccSf.n1,15,-3);
    oRgb.valid <= rgbSyncValid(6);
    elsif(i_k_config_number = 210)then
        --dark_ccm CCC4
        ccRgb.ccSf.n1           <= 1100;
        ccRgb.ccSf.n2           <= -100;
        ccRgb.ccSf.n3           <= -100;
        ccRgb.ccSf.k1           <= to_sfixed(ccRgb.ccSf.n1,15,-3); 
        ccRgb.ccSf.k2           <= to_sfixed(ccRgb.ccSf.n2,15,-3);
        ccRgb.ccSf.k3           <= to_sfixed(ccRgb.ccSf.n3,15,-3); 
        ccRgb.ccSf.k4           <= to_sfixed(ccRgb.ccSf.n3,15,-3); 
        ccRgb.ccSf.k5           <= to_sfixed(ccRgb.ccSf.n1,15,-3);
        ccRgb.ccSf.k6           <= to_sfixed(ccRgb.ccSf.n2,15,-3); 
        ccRgb.ccSf.k7           <= to_sfixed(ccRgb.ccSf.n2,15,-3); 
        ccRgb.ccSf.k8           <= to_sfixed(ccRgb.ccSf.n3,15,-3);
        ccRgb.ccSf.k9           <= to_sfixed(ccRgb.ccSf.n1,15,-3);
    oRgb.valid <= rgbSyncValid(6);
    elsif(i_k_config_number = 211)then
        --light_ccm CCC4
        ccRgb.ccSf.n1           <= 2000;
        ccRgb.ccSf.n2           <= -850;
        ccRgb.ccSf.n3           <= -850;
        ccRgb.ccSf.k1           <= to_sfixed(ccRgb.ccSf.n1,15,-3); 
        ccRgb.ccSf.k2           <= to_sfixed(ccRgb.ccSf.n2,15,-3);
        ccRgb.ccSf.k3           <= to_sfixed(ccRgb.ccSf.n3,15,-3); 
        ccRgb.ccSf.k4           <= to_sfixed(ccRgb.ccSf.n3,15,-3); 
        ccRgb.ccSf.k5           <= to_sfixed(ccRgb.ccSf.n1,15,-3);
        ccRgb.ccSf.k6           <= to_sfixed(ccRgb.ccSf.n2,15,-3); 
        ccRgb.ccSf.k7           <= to_sfixed(ccRgb.ccSf.n2,15,-3); 
        ccRgb.ccSf.k8           <= to_sfixed(ccRgb.ccSf.n3,15,-3);
        ccRgb.ccSf.k9           <= to_sfixed(ccRgb.ccSf.n1,15,-3);
    oRgb.valid <= rgbSyncValid(6);
    elsif(i_k_config_number = 212)then
        --balance_ccm CCC4
        ccRgb.ccSf.n1           <= 900;
        ccRgb.ccSf.n2           <= 650;
        ccRgb.ccSf.n3           <= 600;
        ccRgb.ccSf.k1           <= to_sfixed(ccRgb.ccSf.n1,15,-3); 
        ccRgb.ccSf.k2           <= to_sfixed(ccRgb.ccSf.n2,15,-3);
        ccRgb.ccSf.k3           <= to_sfixed(ccRgb.ccSf.n3,15,-3); 
        ccRgb.ccSf.k4           <= to_sfixed(ccRgb.ccSf.n3,15,-3); 
        ccRgb.ccSf.k5           <= to_sfixed(ccRgb.ccSf.n1,15,-3);
        ccRgb.ccSf.k6           <= to_sfixed(ccRgb.ccSf.n2,15,-3); 
        ccRgb.ccSf.k7           <= to_sfixed(ccRgb.ccSf.n2,15,-3); 
        ccRgb.ccSf.k8           <= to_sfixed(ccRgb.ccSf.n3,15,-3);
        ccRgb.ccSf.k9           <= to_sfixed(ccRgb.ccSf.n1,15,-3);
    oRgb.valid <= rgbSyncValid(6);
    elsif(i_k_config_number = 213)then
        --dark_ccm CCC5
        ccRgb.ccSf.n1           <= 1000;
        ccRgb.ccSf.n2           <= -400;
        ccRgb.ccSf.n3           <= -350;
        ccRgb.ccSf.k1           <= to_sfixed(ccRgb.ccSf.n1,15,-3); 
        ccRgb.ccSf.k2           <= to_sfixed(ccRgb.ccSf.n2,15,-3);
        ccRgb.ccSf.k3           <= to_sfixed(ccRgb.ccSf.n3,15,-3); 
        ccRgb.ccSf.k4           <= to_sfixed(ccRgb.ccSf.n3,15,-3); 
        ccRgb.ccSf.k5           <= to_sfixed(ccRgb.ccSf.n1,15,-3);
        ccRgb.ccSf.k6           <= to_sfixed(ccRgb.ccSf.n2,15,-3); 
        ccRgb.ccSf.k7           <= to_sfixed(ccRgb.ccSf.n2,15,-3); 
        ccRgb.ccSf.k8           <= to_sfixed(ccRgb.ccSf.n3,15,-3);
        ccRgb.ccSf.k9           <= to_sfixed(ccRgb.ccSf.n1,15,-3);
    oRgb.valid <= rgbSyncValid(6);
    elsif(i_k_config_number = 214)then
        --light_ccm CCC5
        ccRgb.ccSf.n1           <= 3000;
        ccRgb.ccSf.n2           <= -500;
        ccRgb.ccSf.n3           <= -1500;
        ccRgb.ccSf.k1           <= to_sfixed(ccRgb.ccSf.n1,15,-3); 
        ccRgb.ccSf.k2           <= to_sfixed(ccRgb.ccSf.n2,15,-3);
        ccRgb.ccSf.k3           <= to_sfixed(ccRgb.ccSf.n3,15,-3); 
        ccRgb.ccSf.k4           <= to_sfixed(ccRgb.ccSf.n3,15,-3); 
        ccRgb.ccSf.k5           <= to_sfixed(ccRgb.ccSf.n1,15,-3);
        ccRgb.ccSf.k6           <= to_sfixed(ccRgb.ccSf.n2,15,-3); 
        ccRgb.ccSf.k7           <= to_sfixed(ccRgb.ccSf.n2,15,-3); 
        ccRgb.ccSf.k8           <= to_sfixed(ccRgb.ccSf.n3,15,-3);
        ccRgb.ccSf.k9           <= to_sfixed(ccRgb.ccSf.n1,15,-3);
    oRgb.valid <= rgbSyncValid(6);
    elsif(i_k_config_number = 215)then
        --balance_ccm CCC5
        ccRgb.ccSf.n1           <= 900;
        ccRgb.ccSf.n2           <= 400;
        ccRgb.ccSf.n3           <= 450;
        ccRgb.ccSf.k1           <= to_sfixed(ccRgb.ccSf.n1,15,-3); 
        ccRgb.ccSf.k2           <= to_sfixed(ccRgb.ccSf.n2,15,-3);
        ccRgb.ccSf.k3           <= to_sfixed(ccRgb.ccSf.n3,15,-3); 
        ccRgb.ccSf.k4           <= to_sfixed(ccRgb.ccSf.n3,15,-3); 
        ccRgb.ccSf.k5           <= to_sfixed(ccRgb.ccSf.n1,15,-3);
        ccRgb.ccSf.k6           <= to_sfixed(ccRgb.ccSf.n2,15,-3); 
        ccRgb.ccSf.k7           <= to_sfixed(ccRgb.ccSf.n2,15,-3); 
        ccRgb.ccSf.k8           <= to_sfixed(ccRgb.ccSf.n3,15,-3);
        ccRgb.ccSf.k9           <= to_sfixed(ccRgb.ccSf.n1,15,-3);
    oRgb.valid <= rgbSyncValid(6);
    elsif(i_k_config_number = 216)then
        --dark_ccm CCC6
        ccRgb.ccSf.n1           <= 900;
        ccRgb.ccSf.n2           <= -400;
        ccRgb.ccSf.n3           <= -350;
        ccRgb.ccSf.k1           <= to_sfixed(ccRgb.ccSf.n1,15,-3); 
        ccRgb.ccSf.k2           <= to_sfixed(ccRgb.ccSf.n2,15,-3);
        ccRgb.ccSf.k3           <= to_sfixed(ccRgb.ccSf.n3,15,-3); 
        ccRgb.ccSf.k4           <= to_sfixed(ccRgb.ccSf.n3,15,-3); 
        ccRgb.ccSf.k5           <= to_sfixed(ccRgb.ccSf.n1,15,-3);
        ccRgb.ccSf.k6           <= to_sfixed(ccRgb.ccSf.n2,15,-3); 
        ccRgb.ccSf.k7           <= to_sfixed(ccRgb.ccSf.n2,15,-3); 
        ccRgb.ccSf.k8           <= to_sfixed(ccRgb.ccSf.n3,15,-3);
        ccRgb.ccSf.k9           <= to_sfixed(ccRgb.ccSf.n1,15,-3);
    oRgb.valid <= rgbSyncValid(6);
    elsif(i_k_config_number = 217)then
        --light_ccm CCC6
        ccRgb.ccSf.n1           <= 4000;
        ccRgb.ccSf.n2           <= -1000;
        ccRgb.ccSf.n3           <= -1500;
        ccRgb.ccSf.k1           <= to_sfixed(ccRgb.ccSf.n1,15,-3); 
        ccRgb.ccSf.k2           <= to_sfixed(ccRgb.ccSf.n2,15,-3);
        ccRgb.ccSf.k3           <= to_sfixed(ccRgb.ccSf.n3,15,-3); 
        ccRgb.ccSf.k4           <= to_sfixed(ccRgb.ccSf.n3,15,-3); 
        ccRgb.ccSf.k5           <= to_sfixed(ccRgb.ccSf.n1,15,-3);
        ccRgb.ccSf.k6           <= to_sfixed(ccRgb.ccSf.n2,15,-3); 
        ccRgb.ccSf.k7           <= to_sfixed(ccRgb.ccSf.n2,15,-3); 
        ccRgb.ccSf.k8           <= to_sfixed(ccRgb.ccSf.n3,15,-3);
        ccRgb.ccSf.k9           <= to_sfixed(ccRgb.ccSf.n1,15,-3);
    oRgb.valid <= rgbSyncValid(6);
    elsif(i_k_config_number = 218)then
        --balance_ccm CCC6
        ccRgb.ccSf.n1           <= 1100;
        ccRgb.ccSf.n2           <= 700;
        ccRgb.ccSf.n3           <= 800;
        ccRgb.ccSf.k1           <= to_sfixed(ccRgb.ccSf.n1,15,-3); 
        ccRgb.ccSf.k2           <= to_sfixed(ccRgb.ccSf.n2,15,-3);
        ccRgb.ccSf.k3           <= to_sfixed(ccRgb.ccSf.n3,15,-3); 
        ccRgb.ccSf.k4           <= to_sfixed(ccRgb.ccSf.n3,15,-3); 
        ccRgb.ccSf.k5           <= to_sfixed(ccRgb.ccSf.n1,15,-3);
        ccRgb.ccSf.k6           <= to_sfixed(ccRgb.ccSf.n2,15,-3); 
        ccRgb.ccSf.k7           <= to_sfixed(ccRgb.ccSf.n2,15,-3); 
        ccRgb.ccSf.k8           <= to_sfixed(ccRgb.ccSf.n3,15,-3);
        ccRgb.ccSf.k9           <= to_sfixed(ccRgb.ccSf.n1,15,-3);
    oRgb.valid <= rgbSyncValid(6);
    elsif(i_k_config_number = 219)then
        --dark_ccm CCC7
        ccRgb.ccSf.n1           <= 1000;
        ccRgb.ccSf.n2           <= -100;
        ccRgb.ccSf.n3           <= -100;
        ccRgb.ccSf.k1           <= to_sfixed(ccRgb.ccSf.n1,15,-3); 
        ccRgb.ccSf.k2           <= to_sfixed(ccRgb.ccSf.n2,15,-3);
        ccRgb.ccSf.k3           <= to_sfixed(ccRgb.ccSf.n3,15,-3); 
        ccRgb.ccSf.k4           <= to_sfixed(ccRgb.ccSf.n3,15,-3); 
        ccRgb.ccSf.k5           <= to_sfixed(ccRgb.ccSf.n1,15,-3);
        ccRgb.ccSf.k6           <= to_sfixed(ccRgb.ccSf.n2,15,-3); 
        ccRgb.ccSf.k7           <= to_sfixed(ccRgb.ccSf.n2,15,-3); 
        ccRgb.ccSf.k8           <= to_sfixed(ccRgb.ccSf.n3,15,-3);
        ccRgb.ccSf.k9           <= to_sfixed(ccRgb.ccSf.n1,15,-3);
    oRgb.valid <= rgbSyncValid(6);
    elsif(i_k_config_number = 220)then
        --light_ccm CCC7
        ccRgb.ccSf.n1           <= 2000;
        ccRgb.ccSf.n2           <= -750;
        ccRgb.ccSf.n3           <= -1000;
        ccRgb.ccSf.k1           <= to_sfixed(ccRgb.ccSf.n1,15,-3); 
        ccRgb.ccSf.k2           <= to_sfixed(ccRgb.ccSf.n2,15,-3);
        ccRgb.ccSf.k3           <= to_sfixed(ccRgb.ccSf.n3,15,-3); 
        ccRgb.ccSf.k4           <= to_sfixed(ccRgb.ccSf.n3,15,-3); 
        ccRgb.ccSf.k5           <= to_sfixed(ccRgb.ccSf.n1,15,-3);
        ccRgb.ccSf.k6           <= to_sfixed(ccRgb.ccSf.n2,15,-3); 
        ccRgb.ccSf.k7           <= to_sfixed(ccRgb.ccSf.n2,15,-3); 
        ccRgb.ccSf.k8           <= to_sfixed(ccRgb.ccSf.n3,15,-3);
        ccRgb.ccSf.k9           <= to_sfixed(ccRgb.ccSf.n1,15,-3);
    oRgb.valid <= rgbSyncValid(6);
    elsif(i_k_config_number = 221)then
        --balance_ccm CCC7
        ccRgb.ccSf.n1           <= 1250;
        ccRgb.ccSf.n2           <= 700;
        ccRgb.ccSf.n3           <= 800;
        ccRgb.ccSf.k1           <= to_sfixed(ccRgb.ccSf.n1,15,-3); 
        ccRgb.ccSf.k2           <= to_sfixed(ccRgb.ccSf.n2,15,-3);
        ccRgb.ccSf.k3           <= to_sfixed(ccRgb.ccSf.n3,15,-3); 
        ccRgb.ccSf.k4           <= to_sfixed(ccRgb.ccSf.n3,15,-3); 
        ccRgb.ccSf.k5           <= to_sfixed(ccRgb.ccSf.n1,15,-3);
        ccRgb.ccSf.k6           <= to_sfixed(ccRgb.ccSf.n2,15,-3); 
        ccRgb.ccSf.k7           <= to_sfixed(ccRgb.ccSf.n2,15,-3); 
        ccRgb.ccSf.k8           <= to_sfixed(ccRgb.ccSf.n3,15,-3);
        ccRgb.ccSf.k9           <= to_sfixed(ccRgb.ccSf.n1,15,-3);
    oRgb.valid <= rgbSyncValid(6);
    elsif(i_k_config_number = 222)then
        --dark_ccm CCC8
        ccRgb.ccSf.n1           <= 500;
        ccRgb.ccSf.n2           <= 200;
        ccRgb.ccSf.n3           <= 100;
        ccRgb.ccSf.k1           <= to_sfixed(ccRgb.ccSf.n1,15,-3); 
        ccRgb.ccSf.k2           <= to_sfixed(ccRgb.ccSf.n2,15,-3);
        ccRgb.ccSf.k3           <= to_sfixed(ccRgb.ccSf.n3,15,-3); 
        ccRgb.ccSf.k4           <= to_sfixed(ccRgb.ccSf.n3,15,-3); 
        ccRgb.ccSf.k5           <= to_sfixed(ccRgb.ccSf.n1,15,-3);
        ccRgb.ccSf.k6           <= to_sfixed(ccRgb.ccSf.n2,15,-3); 
        ccRgb.ccSf.k7           <= to_sfixed(ccRgb.ccSf.n2,15,-3); 
        ccRgb.ccSf.k8           <= to_sfixed(ccRgb.ccSf.n3,15,-3);
        ccRgb.ccSf.k9           <= to_sfixed(ccRgb.ccSf.n1,15,-3);
    oRgb.valid <= rgbSyncValid(6);
    elsif(i_k_config_number = 223)then
        --light_ccm CCC8
        ccRgb.ccSf.n1           <= 2600;
        ccRgb.ccSf.n2           <= -1200;
        ccRgb.ccSf.n3           <= -1200;
        ccRgb.ccSf.k1           <= to_sfixed(ccRgb.ccSf.n1,15,-3); 
        ccRgb.ccSf.k2           <= to_sfixed(ccRgb.ccSf.n2,15,-3);
        ccRgb.ccSf.k3           <= to_sfixed(ccRgb.ccSf.n3,15,-3); 
        ccRgb.ccSf.k4           <= to_sfixed(ccRgb.ccSf.n3,15,-3); 
        ccRgb.ccSf.k5           <= to_sfixed(ccRgb.ccSf.n1,15,-3);
        ccRgb.ccSf.k6           <= to_sfixed(ccRgb.ccSf.n2,15,-3); 
        ccRgb.ccSf.k7           <= to_sfixed(ccRgb.ccSf.n2,15,-3); 
        ccRgb.ccSf.k8           <= to_sfixed(ccRgb.ccSf.n3,15,-3);
        ccRgb.ccSf.k9           <= to_sfixed(ccRgb.ccSf.n1,15,-3);
    oRgb.valid <= rgbSyncValid(6);
    elsif(i_k_config_number = 224)then
        --balance_ccm CCC8
        ccRgb.ccSf.n1           <= 2500;
        ccRgb.ccSf.n2           <= 1400;
        ccRgb.ccSf.n3           <= 1600;
        ccRgb.ccSf.k1           <= to_sfixed(ccRgb.ccSf.n1,15,-3); 
        ccRgb.ccSf.k2           <= to_sfixed(ccRgb.ccSf.n2,15,-3);
        ccRgb.ccSf.k3           <= to_sfixed(ccRgb.ccSf.n3,15,-3); 
        ccRgb.ccSf.k4           <= to_sfixed(ccRgb.ccSf.n3,15,-3); 
        ccRgb.ccSf.k5           <= to_sfixed(ccRgb.ccSf.n1,15,-3);
        ccRgb.ccSf.k6           <= to_sfixed(ccRgb.ccSf.n2,15,-3); 
        ccRgb.ccSf.k7           <= to_sfixed(ccRgb.ccSf.n2,15,-3); 
        ccRgb.ccSf.k8           <= to_sfixed(ccRgb.ccSf.n3,15,-3);
        ccRgb.ccSf.k9           <= to_sfixed(ccRgb.ccSf.n1,15,-3);
    oRgb.valid <= rgbSyncValid(6);
    elsif(i_k_config_number = 300)then
        ccRgb.ccSf.k1           <= to_sfixed(coefficients_in.k1(15 downto 0),15,-3); 
        ccRgb.ccSf.k2           <= to_sfixed(coefficients_in.k2(15 downto 0),15,-3);
        ccRgb.ccSf.k3           <= to_sfixed(coefficients_in.k3(15 downto 0),15,-3); 
        ccRgb.ccSf.k4           <= to_sfixed(coefficients_in.k4(15 downto 0),15,-3); 
        ccRgb.ccSf.k5           <= to_sfixed(coefficients_in.k5(15 downto 0),15,-3);
        ccRgb.ccSf.k6           <= to_sfixed(coefficients_in.k6(15 downto 0),15,-3); 
        ccRgb.ccSf.k7           <= to_sfixed(coefficients_in.k7(15 downto 0),15,-3); 
        ccRgb.ccSf.k8           <= to_sfixed(coefficients_in.k8(15 downto 0),15,-3);
        ccRgb.ccSf.k9           <= to_sfixed(coefficients_in.k9(15 downto 0),15,-3);
    oRgb.valid <= rgbSyncValid(6);
    end if;
    end if;
end process ccSfConfig_P;



coefficients_out.k1 <= x"0000" & std_logic_vector(ccRgb.ccSf.k1(15 downto 0));
coefficients_out.k2 <= x"FFFF" & std_logic_vector(ccRgb.ccSf.k2(15 downto 0));
coefficients_out.k3 <= x"FFFF" & std_logic_vector(ccRgb.ccSf.k3(15 downto 0));
coefficients_out.k4 <= x"FFFF" & std_logic_vector(ccRgb.ccSf.k4(15 downto 0));
coefficients_out.k5 <= x"0000" & std_logic_vector(ccRgb.ccSf.k5(15 downto 0));
coefficients_out.k6 <= x"FFFF" & std_logic_vector(ccRgb.ccSf.k6(15 downto 0));
coefficients_out.k7 <= x"FFFF" & std_logic_vector(ccRgb.ccSf.k7(15 downto 0));
coefficients_out.k8 <= x"FFFF" & std_logic_vector(ccRgb.ccSf.k8(15 downto 0));
coefficients_out.k9 <= x"0000" & std_logic_vector(ccRgb.ccSf.k9(15 downto 0));



ccProdSf_P: process (clk)begin
    if rising_edge(clk) then
        ccRgb.ccm_prod_1.k1       <= ccRgb.ccSf.k1  * ccRgb.rgbToSf.red;
        ccRgb.ccm_prod_1.k2       <= ccRgb.ccSf.k2  * ccRgb.rgbToSf.green;
        ccRgb.ccm_prod_1.k3       <= ccRgb.ccSf.k3  * ccRgb.rgbToSf.blue;
        ccRgb.ccm_prod_1.k4       <= ccRgb.ccSf.k4  * ccRgb.rgbToSf.red;
        ccRgb.ccm_prod_1.k5       <= ccRgb.ccSf.k5  * ccRgb.rgbToSf.green;
        ccRgb.ccm_prod_1.k6       <= ccRgb.ccSf.k6  * ccRgb.rgbToSf.blue;
        ccRgb.ccm_prod_1.k7       <= ccRgb.ccSf.k7  * ccRgb.rgbToSf.red;
        ccRgb.ccm_prod_1.k8       <= ccRgb.ccSf.k8  * ccRgb.rgbToSf.green;
        ccRgb.ccm_prod_1.k9       <= ccRgb.ccSf.k9  * ccRgb.rgbToSf.blue;
    end if;
end process ccProdSf_P;
ccProdToSn_P: process (clk)begin
    if rising_edge(clk) then
        ccRgb.ccm_prod_2.k1     <= to_signed(ccRgb.ccm_prod_1.k1(21 downto 0), 22);
        ccRgb.ccm_prod_2.k2     <= to_signed(ccRgb.ccm_prod_1.k2(21 downto 0), 22);
        ccRgb.ccm_prod_2.k3     <= to_signed(ccRgb.ccm_prod_1.k3(21 downto 0), 22);
        ccRgb.ccm_prod_2.k4     <= to_signed(ccRgb.ccm_prod_1.k4(21 downto 0), 22);
        ccRgb.ccm_prod_2.k5     <= to_signed(ccRgb.ccm_prod_1.k5(21 downto 0), 22);
        ccRgb.ccm_prod_2.k6     <= to_signed(ccRgb.ccm_prod_1.k6(21 downto 0), 22);
        ccRgb.ccm_prod_2.k7     <= to_signed(ccRgb.ccm_prod_1.k7(21 downto 0), 22);
        ccRgb.ccm_prod_2.k8     <= to_signed(ccRgb.ccm_prod_1.k8(21 downto 0), 22);
        ccRgb.ccm_prod_2.k9     <= to_signed(ccRgb.ccm_prod_1.k9(21 downto 0), 22);
    end if;
end process ccProdToSn_P;
process (clk,rst_l)begin
    if rising_edge(clk) then
      ccRgb.ccm_prod_3.k1        <= ccRgb.ccm_prod_2.k1;
      ccRgb.ccm_prod_3.k2        <= ccRgb.ccm_prod_2.k2;
      ccRgb.ccm_prod_3.k3        <= ccRgb.ccm_prod_2.k3;
      ccRgb.ccm_prod_3.k4        <= ccRgb.ccm_prod_2.k4;
      ccRgb.ccm_prod_3.k5        <= ccRgb.ccm_prod_2.k5;
      ccRgb.ccm_prod_3.k6        <= ccRgb.ccm_prod_2.k6;
      ccRgb.ccm_prod_3.k7        <= ccRgb.ccm_prod_2.k7;
      ccRgb.ccm_prod_3.k8        <= ccRgb.ccm_prod_2.k8;
      ccRgb.ccm_prod_3.k9        <= ccRgb.ccm_prod_2.k9;
      ccRgb.ccm_prod_4.red      <= resize(ccRgb.ccm_prod_3.k1, ADD_RESULT_WIDTH+6) +
                                   resize(ccRgb.ccm_prod_3.k2, ADD_RESULT_WIDTH+6) +
                                   resize(ccRgb.ccm_prod_3.k3, ADD_RESULT_WIDTH+6);
      ccRgb.ccm_prod_4.green    <= resize(ccRgb.ccm_prod_3.k4, ADD_RESULT_WIDTH+6) +
                                   resize(ccRgb.ccm_prod_3.k5, ADD_RESULT_WIDTH+6) +
                                   resize(ccRgb.ccm_prod_3.k6, ADD_RESULT_WIDTH+6);
      ccRgb.ccm_prod_4.blue     <= resize(ccRgb.ccm_prod_3.k7, ADD_RESULT_WIDTH+6) +
                                   resize(ccRgb.ccm_prod_3.k8, ADD_RESULT_WIDTH+6) +
                                   resize(ccRgb.ccm_prod_3.k9, ADD_RESULT_WIDTH+6);
      ccRgb.ccm_prod_5.red    <= ccRgb.ccm_prod_4.red(ccRgb.ccm_prod_4.red'left downto FRAC_BITS_TO_KEEP);
      ccRgb.ccm_prod_5.green  <= ccRgb.ccm_prod_4.green(ccRgb.ccm_prod_4.green'left downto FRAC_BITS_TO_KEEP);
      ccRgb.ccm_prod_5.blue   <= ccRgb.ccm_prod_4.blue(ccRgb.ccm_prod_4.blue'left downto FRAC_BITS_TO_KEEP);
    end if;
end process;
rgbSnSumTr_P : process (clk, rst_l)
  begin
    if rising_edge(clk) then
      if unsigned(ccRgb.ccm_prod_5.red(19 downto 17)) /= 0 then
        rgb_ccm.red <= (others => '1');
      else
        rgb_ccm.red <= std_logic_vector(ccRgb.ccm_prod_5.red(16 downto 7));
      end if;
      if unsigned(ccRgb.ccm_prod_5.green(19 downto 17)) /= 0 then
        rgb_ccm.green <= (others => '1');
      else
        rgb_ccm.green <= std_logic_vector(ccRgb.ccm_prod_5.green(16 downto 7));
      end if;
      if unsigned(ccRgb.ccm_prod_5.blue(19 downto 17)) /= 0 then
        rgb_ccm.blue <= (others => '1');
      else
        rgb_ccm.blue <= std_logic_vector(ccRgb.ccm_prod_5.blue(16 downto 7));
      end if;
    end if;
end process rgbSnSumTr_P;
process (clk,rst_l)begin
    if rising_edge(clk) then
        oRgb.red   <= rgb_ccm.red;
        oRgb.green <= rgb_ccm.green;
        oRgb.blue  <= rgb_ccm.blue;
    end if;
end process;
end Behavioral;