Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE2B42B8F7
	for <lists+netdev@lfdr.de>; Mon, 27 May 2019 18:23:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726982AbfE0QWo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 May 2019 12:22:44 -0400
Received: from vps.xff.cz ([195.181.215.36]:52634 "EHLO vps.xff.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726881AbfE0QWn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 May 2019 12:22:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=megous.com; s=mail;
        t=1558974161; bh=P6oNZcE8gnEVr+Noa52McnHoAnRWnYpUxI4CnwnbrFY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ocV3vRyhBQf437hemhd//ZsvcC9auXu2Dy2crS0ozbCVW3sZkzThqY7HaJ4qPlDa3
         uRaHmdxNgb6DRf9FWPp1tMIdlHrYWFaYcunDB/b0NirutiULxbLFdbW595sQYgcna3
         QcGXIVqY4W57EldweRz3JgvlGSq98yx7a0XH+F90=
From:   megous@megous.com
To:     linux-sunxi@googlegroups.com,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>, Rob Herring <robh+dt@kernel.org>
Cc:     Ondrej Jirman <megous@megous.com>, David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Mark Rutland <mark.rutland@arm.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        dri-devel@lists.freedesktop.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com
Subject: [PATCH v6 6/6] arm64: dts: allwinner: orange-pi-3: Enable HDMI output
Date:   Mon, 27 May 2019 18:22:37 +0200
Message-Id: <20190527162237.18495-7-megous@megous.com>
In-Reply-To: <20190527162237.18495-1-megous@megous.com>
References: <20190527162237.18495-1-megous@megous.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ondrej Jirman <megous@megous.com>

Orange Pi 3 has a DDC_CEC_EN signal connected to PH2, that enables the DDC
I2C bus voltage shifter. Before EDID can be read, we need to pull PH2 high.
This is realized by the ddc-en-gpios property.

Signed-off-by: Ondrej Jirman <megous@megous.com>
---
 .../dts/allwinner/sun50i-h6-orangepi-3.dts    | 26 +++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/arch/arm64/boot/dts/allwinner/sun50i-h6-orangepi-3.dts b/arch/arm64/boot/dts/allwinner/sun50i-h6-orangepi-3.dts
index 2c6807b74ff6..01bb1bafe284 100644
--- a/arch/arm64/boot/dts/allwinner/sun50i-h6-orangepi-3.dts
+++ b/arch/arm64/boot/dts/allwinner/sun50i-h6-orangepi-3.dts
@@ -22,6 +22,18 @@
 		stdout-path = "serial0:115200n8";
 	};
 
+	connector {
+		compatible = "hdmi-connector";
+		ddc-en-gpios = <&pio 7 2 GPIO_ACTIVE_HIGH>; /* PH2 */
+		type = "a";
+
+		port {
+			hdmi_con_in: endpoint {
+				remote-endpoint = <&hdmi_out_con>;
+			};
+		};
+	};
+
 	leds {
 		compatible = "gpio-leds";
 
@@ -72,6 +84,10 @@
 	cpu-supply = <&reg_dcdca>;
 };
 
+&de {
+	status = "okay";
+};
+
 &ehci0 {
 	status = "okay";
 };
@@ -91,6 +107,16 @@
 	status = "okay";
 };
 
+&hdmi {
+	status = "okay";
+};
+
+&hdmi_out {
+	hdmi_out_con: endpoint {
+		remote-endpoint = <&hdmi_con_in>;
+	};
+};
+
 &mdio {
 	ext_rgmii_phy: ethernet-phy@1 {
 		compatible = "ethernet-phy-ieee802.3-c22";
-- 
2.21.0

