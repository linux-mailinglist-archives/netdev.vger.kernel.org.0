Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F5809630F
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 16:53:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730457AbfHTOxu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 10:53:50 -0400
Received: from vps.xff.cz ([195.181.215.36]:60112 "EHLO vps.xff.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728283AbfHTOxt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Aug 2019 10:53:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=megous.com; s=mail;
        t=1566312827; bh=/wCPaAVAhM9jkrpOgFjJQndvFQSZ3vor/dhJP6G9DqM=;
        h=From:To:Cc:Subject:Date:References:From;
        b=pr0wChX5ZN4OrzzMX3Txai82qwcOk2weMbp798hGCqayc02tBmkgal0EJDif4lKiO
         0Z5ZyF08kJhi3AKPIG1VQOkAsPGnlq1Ffa9zqT3kRxYLJPaLRGt+jqjuSwbMnK0NXU
         NDc9zrMaKXcYD+Jlu6URuc8eMVTnKofwFD/p2/Bo=
From:   megous@megous.com
To:     "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Maxime Ripard <mripard@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc:     Ondrej Jirman <megous@megous.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com
Subject: [PATCH 6/6] arm64: dts: allwinner: orange-pi-3: Enable ethernet
Date:   Tue, 20 Aug 2019 16:53:43 +0200
Message-Id: <20190820145343.29108-7-megous@megous.com>
In-Reply-To: <20190820145343.29108-1-megous@megous.com>
References: <20190820145343.29108-1-megous@megous.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ondrej Jirman <megous@megous.com>

Orange Pi 3 has two regulators that power the Realtek RTL8211E
PHY. According to the datasheet, both regulators need to be enabled
at the same time, or that "phy-io" should be enabled slightly earlier
than "phy" regulator.

RTL8211E/RTL8211EG datasheet says:

  Note 4: 2.5V (or 1.8/1.5V) RGMII power should be risen simultaneously
  or slightly earlier than 3.3V power. Rising 2.5V (or 1.8/1.5V) power
  later than 3.3V power may lead to errors.

The driver ensures the regulator enable ordering. The timing is set
in DT via startup-delay-us.

We also need to wait at least 30ms after power-up/reset, before
accessing the PHY registers.

All values of RX/TX delay were tested exhaustively and a middle one
of the range of working values was chosen.

Signed-off-by: Ondrej Jirman <megous@megous.com>
---
 .../dts/allwinner/sun50i-h6-orangepi-3.dts    | 40 +++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/arch/arm64/boot/dts/allwinner/sun50i-h6-orangepi-3.dts b/arch/arm64/boot/dts/allwinner/sun50i-h6-orangepi-3.dts
index eda9d5f640b9..18349e60b8c6 100644
--- a/arch/arm64/boot/dts/allwinner/sun50i-h6-orangepi-3.dts
+++ b/arch/arm64/boot/dts/allwinner/sun50i-h6-orangepi-3.dts
@@ -15,6 +15,7 @@
 
 	aliases {
 		serial0 = &uart0;
+		ethernet0 = &emac;
 	};
 
 	chosen {
@@ -56,6 +57,15 @@
 		regulator-max-microvolt = <5000000>;
 		regulator-always-on;
 	};
+
+	reg_gmac_2v5: gmac-2v5 {
+		compatible = "regulator-fixed";
+		regulator-name = "gmac-2v5";
+		regulator-min-microvolt = <2500000>;
+		regulator-max-microvolt = <2500000>;
+		enable-active-high;
+		gpio = <&pio 3 6 GPIO_ACTIVE_HIGH>; /* PD6 */
+	};
 };
 
 &cpu0 {
@@ -74,6 +84,35 @@
 	status = "okay";
 };
 
+&emac {
+	pinctrl-names = "default";
+	pinctrl-0 = <&ext_rgmii_pins>;
+	phy-mode = "rgmii";
+	phy-handle = <&ext_rgmii_phy>;
+	/*
+	 * The board uses 2.5V RGMII signalling. Power sequence to enable
+	 * the phy is to enable GMAC-2V5 and GMAC-3V (aldo2) power rails
+	 * at the same time and to wait 100ms. The driver enables phy-io
+	 * first. Delay is achieved with enable-ramp-delay on reg_aldo2.
+	 */
+	phy-supply = <&reg_aldo2>;
+	phy-io-supply = <&reg_gmac_2v5>;
+	allwinner,rx-delay-ps = <1500>;
+	allwinner,tx-delay-ps = <700>;
+	status = "okay";
+};
+
+&mdio {
+	ext_rgmii_phy: ethernet-phy@1 {
+		compatible = "ethernet-phy-ieee802.3-c22";
+		reg = <1>;
+
+		reset-gpios = <&pio 3 14 GPIO_ACTIVE_LOW>; /* PD14 */
+		reset-assert-us = <15000>;
+		reset-deassert-us = <40000>;
+	};
+};
+
 &hdmi {
 	status = "okay";
 };
@@ -136,6 +175,7 @@
 				regulator-min-microvolt = <3300000>;
 				regulator-max-microvolt = <3300000>;
 				regulator-name = "vcc33-audio-tv-ephy-mac";
+				regulator-enable-ramp-delay = <100000>;
 			};
 
 			/* ALDO3 is shorted to CLDO1 */
-- 
2.22.1

