Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A02C1AD01F
	for <lists+netdev@lfdr.de>; Thu, 16 Apr 2020 21:06:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731453AbgDPTGX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Apr 2020 15:06:23 -0400
Received: from mailoutvs19.siol.net ([185.57.226.210]:37026 "EHLO
        mail.siol.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730255AbgDPTGN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Apr 2020 15:06:13 -0400
Received: from localhost (localhost [127.0.0.1])
        by mail.siol.net (Postfix) with ESMTP id 128D65246A6;
        Thu, 16 Apr 2020 20:58:16 +0200 (CEST)
X-Virus-Scanned: amavisd-new at psrvmta09.zcs-production.pri
Received: from mail.siol.net ([127.0.0.1])
        by localhost (psrvmta09.zcs-production.pri [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id clAohr0pdr4F; Thu, 16 Apr 2020 20:58:15 +0200 (CEST)
Received: from mail.siol.net (localhost [127.0.0.1])
        by mail.siol.net (Postfix) with ESMTPS id 9EA805246A3;
        Thu, 16 Apr 2020 20:58:15 +0200 (CEST)
Received: from localhost.localdomain (cpe-194-152-20-232.static.triera.net [194.152.20.232])
        (Authenticated sender: 031275009)
        by mail.siol.net (Postfix) with ESMTPSA id 342E15246A5;
        Thu, 16 Apr 2020 20:58:13 +0200 (CEST)
From:   Jernej Skrabec <jernej.skrabec@siol.net>
To:     robh+dt@kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com
Cc:     mripard@kernel.org, wens@csie.org, lee.jones@linaro.org,
        linux@armlinux.org.uk, davem@davemloft.net,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [RFC PATCH 3/4] arm64: dts: allwinner: h6: Add AC200 EPHY related nodes
Date:   Thu, 16 Apr 2020 20:57:57 +0200
Message-Id: <20200416185758.1388148-4-jernej.skrabec@siol.net>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200416185758.1388148-1-jernej.skrabec@siol.net>
References: <20200416185758.1388148-1-jernej.skrabec@siol.net>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Allwinner H6 contains copackaged AC200 multi functional IC which takes
care for analog audio, CVBS output, (another) RTC and Ethernet PHY.

Add support for Ethernet PHY for now.

Signed-off-by: Jernej Skrabec <jernej.skrabec@siol.net>
---
 arch/arm64/boot/dts/allwinner/sun50i-h6.dtsi | 63 ++++++++++++++++++++
 1 file changed, 63 insertions(+)

diff --git a/arch/arm64/boot/dts/allwinner/sun50i-h6.dtsi b/arch/arm64/bo=
ot/dts/allwinner/sun50i-h6.dtsi
index a5ee68388bd3..8663d2146e0f 100644
--- a/arch/arm64/boot/dts/allwinner/sun50i-h6.dtsi
+++ b/arch/arm64/boot/dts/allwinner/sun50i-h6.dtsi
@@ -16,6 +16,16 @@ / {
 	#address-cells =3D <1>;
 	#size-cells =3D <1>;
=20
+	ac200_pwm_clk: ac200_clk {
+		compatible =3D "pwm-clock";
+		#clock-cells =3D <0>;
+		clock-frequency =3D <24000000>;
+		pinctrl-names =3D "default";
+		pinctrl-0 =3D <&pwm1_pin>;
+		pwms =3D <&pwm 1 42 0>;
+		status =3D "disabled";
+	};
+
 	cpus {
 		#address-cells =3D <1>;
 		#size-cells =3D <0>;
@@ -250,6 +260,10 @@ sid: efuse@3006000 {
 			ths_calibration: thermal-sensor-calibration@14 {
 				reg =3D <0x14 0x8>;
 			};
+
+			ephy_calibration: ephy-calibration@2c {
+				reg =3D <0x2c 0x2>;
+			};
 		};
=20
 		watchdog: watchdog@30090a0 {
@@ -294,6 +308,14 @@ ext_rgmii_pins: rgmii-pins {
 				drive-strength =3D <40>;
 			};
=20
+			/omit-if-no-ref/
+			ext_rmii_pins: rmii_pins {
+				pins =3D "PA0", "PA1", "PA2", "PA3", "PA4",
+				       "PA5", "PA6", "PA7", "PA8", "PA9";
+				function =3D "emac";
+				drive-strength =3D <40>;
+			};
+
 			hdmi_pins: hdmi-pins {
 				pins =3D "PH8", "PH9", "PH10";
 				function =3D "hdmi";
@@ -314,6 +336,11 @@ i2c2_pins: i2c2-pins {
 				function =3D "i2c2";
 			};
=20
+			i2c3_pins: i2c3-pins {
+				pins =3D "PB17", "PB18";
+				function =3D "i2c3";
+			};
+
 			mmc0_pins: mmc0-pins {
 				pins =3D "PF0", "PF1", "PF2", "PF3",
 				       "PF4", "PF5";
@@ -331,6 +358,11 @@ mmc1_pins: mmc1-pins {
 				bias-pull-up;
 			};
=20
+			pwm1_pin: pwm1-pin {
+				pins =3D "PB19";
+				function =3D "pwm1";
+			};
+
 			mmc2_pins: mmc2-pins {
 				pins =3D "PC1", "PC4", "PC5", "PC6",
 				       "PC7", "PC8", "PC9", "PC10",
@@ -531,6 +563,37 @@ i2c2: i2c@5002800 {
 			#size-cells =3D <0>;
 		};
=20
+		i2c3: i2c@5002c00 {
+			compatible =3D "allwinner,sun50i-h6-i2c",
+				     "allwinner,sun6i-a31-i2c";
+			reg =3D <0x05002c00 0x400>;
+			interrupts =3D <GIC_SPI 7 IRQ_TYPE_LEVEL_HIGH>;
+			clocks =3D <&ccu CLK_BUS_I2C3>;
+			resets =3D <&ccu RST_BUS_I2C3>;
+			pinctrl-names =3D "default";
+			pinctrl-0 =3D <&i2c3_pins>;
+			status =3D "disabled";
+			#address-cells =3D <1>;
+			#size-cells =3D <0>;
+
+			ac200: mfd@10 {
+				compatible =3D "x-powers,ac200";
+				reg =3D <0x10>;
+				clocks =3D <&ac200_pwm_clk>;
+				interrupt-parent =3D <&pio>;
+				interrupts =3D <1 20 IRQ_TYPE_LEVEL_LOW>;
+				interrupt-controller;
+				#interrupt-cells =3D <1>;
+
+				ac200_ephy: phy {
+					compatible =3D "x-powers,ac200-ephy";
+					nvmem-cells =3D <&ephy_calibration>;
+					nvmem-cell-names =3D "calibration";
+					status =3D "disabled";
+				};
+			};
+		};
+
 		spi0: spi@5010000 {
 			compatible =3D "allwinner,sun50i-h6-spi",
 				     "allwinner,sun8i-h3-spi";
--=20
2.26.0

