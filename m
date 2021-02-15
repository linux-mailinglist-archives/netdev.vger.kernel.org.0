Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75DCE31B4F7
	for <lists+netdev@lfdr.de>; Mon, 15 Feb 2021 06:13:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229952AbhBOFKF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Feb 2021 00:10:05 -0500
Received: from mo-csw1514.securemx.jp ([210.130.202.153]:47020 "EHLO
        mo-csw.securemx.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229899AbhBOFJh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Feb 2021 00:09:37 -0500
Received: by mo-csw.securemx.jp (mx-mo-csw1514) id 11F577JC005999; Mon, 15 Feb 2021 14:07:08 +0900
X-Iguazu-Qid: 34tMK0YvjMT9ORWEI9
X-Iguazu-QSIG: v=2; s=0; t=1613365627; q=34tMK0YvjMT9ORWEI9; m=ysCQuRG+tcssHoRPe7pUYd88gwDHmOhYSkUu8uv/2GE=
Received: from imx12.toshiba.co.jp (imx12.toshiba.co.jp [61.202.160.132])
        by relay.securemx.jp (mx-mr1510) id 11F575mV005051;
        Mon, 15 Feb 2021 14:07:06 +0900
Received: from enc02.toshiba.co.jp ([61.202.160.51])
        by imx12.toshiba.co.jp  with ESMTP id 11F575x8029846;
        Mon, 15 Feb 2021 14:07:05 +0900 (JST)
Received: from hop101.toshiba.co.jp ([133.199.85.107])
        by enc02.toshiba.co.jp  with ESMTP id 11F5747X021279;
        Mon, 15 Feb 2021 14:07:05 +0900
From:   Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>, leon@kernel.org,
        arnd@kernel.org, devicetree@vger.kernel.org,
        netdev@vger.kernel.org, punit1.agrawal@toshiba.co.jp,
        yuji2.ishikawa@toshiba.co.jp, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
Subject: [PATCH 4/4] arm: dts: visconti: Add DT support for Toshiba Visconti5 ethernet controller
Date:   Mon, 15 Feb 2021 14:06:55 +0900
X-TSB-HOP: ON
Message-Id: <20210215050655.2532-5-nobuhiro1.iwamatsu@toshiba.co.jp>
X-Mailer: git-send-email 2.30.0.rc2
In-Reply-To: <20210215050655.2532-1-nobuhiro1.iwamatsu@toshiba.co.jp>
References: <20210215050655.2532-1-nobuhiro1.iwamatsu@toshiba.co.jp>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the ethernet controller node in Toshiba Visconti5 SoC-specific DT file.
And enable this node in TMPV7708 RM main board's board-specific DT file.

Signed-off-by: Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
---
 .../boot/dts/toshiba/tmpv7708-rm-mbrc.dts     | 18 +++++++++++++
 arch/arm64/boot/dts/toshiba/tmpv7708.dtsi     | 25 +++++++++++++++++++
 2 files changed, 43 insertions(+)

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
index 242f25f4e12a..3366786699fc 100644
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
@@ -384,6 +398,17 @@ spi6: spi@28146000 {
 			#size-cells = <0>;
 			status = "disabled";
 		};
+
+		piether: ethernet@28000000 {
+			compatible = "toshiba,visconti-dwmac", "snps,dwmac-4.20a";
+			reg = <0 0x28000000 0 0x10000>;
+			interrupts = <GIC_SPI 156 IRQ_TYPE_LEVEL_HIGH>;
+			interrupt-names = "macirq";
+			snps,txpbl = <4>;
+			snps,rxpbl = <4>;
+			snps,tso;
+			status = "disabled";
+		};
 	};
 };
 
-- 
2.30.0.rc2

