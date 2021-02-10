Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C78CF316C87
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 18:25:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232052AbhBJRYz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 12:24:55 -0500
Received: from mo-csw-fb1114.securemx.jp ([210.130.202.173]:58888 "EHLO
        mo-csw-fb.securemx.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231543AbhBJRYt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 12:24:49 -0500
Received: by mo-csw-fb.securemx.jp (mx-mo-csw-fb1114) id 11AGYvZx019690; Thu, 11 Feb 2021 01:34:57 +0900
Received: by mo-csw.securemx.jp (mx-mo-csw1116) id 11AGUB4b006826; Thu, 11 Feb 2021 01:30:11 +0900
X-Iguazu-Qid: 2wGqhgW4xaueMBSRto
X-Iguazu-QSIG: v=2; s=0; t=1612974610; q=2wGqhgW4xaueMBSRto; m=ZHb/nLnVYDrFCjWRAERWKgGTvH0octWl57WAenaU1E0=
Received: from imx2.toshiba.co.jp (imx2.toshiba.co.jp [106.186.93.51])
        by relay.securemx.jp (mx-mr1112) id 11AGU9rA026238;
        Thu, 11 Feb 2021 01:30:09 +0900
Received: from enc01.toshiba.co.jp ([106.186.93.100])
        by imx2.toshiba.co.jp  with ESMTP id 11AGU9ma007062;
        Thu, 11 Feb 2021 01:30:09 +0900 (JST)
Received: from hop001.toshiba.co.jp ([133.199.164.63])
        by enc01.toshiba.co.jp  with ESMTP id 11AGU8I3029439;
        Thu, 11 Feb 2021 01:30:08 +0900
From:   Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        punit1.agrawal@toshiba.co.jp, yuji2.ishikawa@toshiba.co.jp,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
Subject: [PATCH 4/4] arm: dts: visconti: Add DT support for Toshiba Visconti5 ethernet controller
Date:   Thu, 11 Feb 2021 01:29:54 +0900
X-TSB-HOP: ON
Message-Id: <20210210162954.3955785-5-nobuhiro1.iwamatsu@toshiba.co.jp>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210210162954.3955785-1-nobuhiro1.iwamatsu@toshiba.co.jp>
References: <20210210162954.3955785-1-nobuhiro1.iwamatsu@toshiba.co.jp>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the ethernet controller node in Toshiba Visconti5 SoC-specific DT file.
And enable this node in TMPV7708 RM main board's board-specific DT file.

Signed-off-by: Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
---
 .../boot/dts/toshiba/tmpv7708-rm-mbrc.dts     | 18 ++++++++++++++
 arch/arm64/boot/dts/toshiba/tmpv7708.dtsi     | 24 +++++++++++++++++++
 2 files changed, 42 insertions(+)

diff --git a/arch/arm64/boot/dts/toshiba/tmpv7708-rm-mbrc.dts b/arch/arm64/boot/dts/toshiba/tmpv7708-rm-mbrc.dts
index ed0bf7f13f54..48fa8776e36f 100644
--- a/arch/arm64/boot/dts/toshiba/tmpv7708-rm-mbrc.dts
+++ b/arch/arm64/boot/dts/toshiba/tmpv7708-rm-mbrc.dts
@@ -41,3 +41,21 @@ &uart1 {
 	clocks = <&uart_clk>;
 	clock-names = "apb_pclk";
 };
+
+&piether {
+	status = "okay";
+	phy-handle = <&phy0>;
+	phy-mode = "rgmii-id";
+	clocks = <&clk300mhz>, <&clk125mhz>;
+	clock-names = "stmmaceth", "phy_ref_clk";
+
+	mdio0 {
+		#address-cells = <1>;
+		#size-cells = <0>;
+		compatible = "snps,dwmac-mdio";
+		phy0: ethernet-phy@1 {
+			device_type = "ethernet-phy";
+			reg = <0x1>;
+		};
+	};
+};
diff --git a/arch/arm64/boot/dts/toshiba/tmpv7708.dtsi b/arch/arm64/boot/dts/toshiba/tmpv7708.dtsi
index 242f25f4e12a..fabb8d66ef93 100644
--- a/arch/arm64/boot/dts/toshiba/tmpv7708.dtsi
+++ b/arch/arm64/boot/dts/toshiba/tmpv7708.dtsi
@@ -134,6 +134,20 @@ uart_clk: uart-clk {
 		#clock-cells = <0>;
 	};
 
+	clk125mhz: clk125mhz {
+		compatible = "fixed-clock";
+		clock-frequency = <125000000>;
+		#clock-cells = <0>;
+		clock-output-names = "clk125mhz";
+	};
+
+	clk300mhz: clk300mhz {
+		compatible = "fixed-clock";
+		clock-frequency = <300000000>;
+		#clock-cells = <0>;
+		clock-output-names = "clk300mhz";
+	};
+
 	soc {
 		#address-cells = <2>;
 		#size-cells = <2>;
@@ -384,6 +398,16 @@ spi6: spi@28146000 {
 			#size-cells = <0>;
 			status = "disabled";
 		};
+
+		piether: ethernet@28000000 {
+			compatible = "toshiba,visconti-dwmac";
+			reg = <0 0x28000000 0 0x10000>;
+			interrupts = <GIC_SPI 156 IRQ_TYPE_LEVEL_HIGH>;
+			interrupt-names = "macirq";
+			snps,txpbl = <4>;
+			snps,rxpbl = <4>;
+			status = "disabled";
+		};
 	};
 };
 
-- 
2.27.0

