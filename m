Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D6F678920
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 12:04:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728231AbfG2KEB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 06:04:01 -0400
Received: from inva021.nxp.com ([92.121.34.21]:42720 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728151AbfG2KDx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Jul 2019 06:03:53 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 35D8F2014D2;
        Mon, 29 Jul 2019 12:03:51 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 260172014CE;
        Mon, 29 Jul 2019 12:03:51 +0200 (CEST)
Received: from fsr-ub1664-016.ea.freescale.net (fsr-ub1664-016.ea.freescale.net [10.171.71.216])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id B199A205F3;
        Mon, 29 Jul 2019 12:03:50 +0200 (CEST)
From:   Claudiu Manoil <claudiu.manoil@nxp.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     andrew@lunn.ch, Rob Herring <robh+dt@kernel.org>,
        Li Yang <leoyang.li@nxp.com>, alexandru.marginean@nxp.com,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v3 4/4] arm64: dts: fsl: ls1028a: Enable eth port1 on the ls1028a QDS board
Date:   Mon, 29 Jul 2019 13:03:47 +0300
Message-Id: <1564394627-3810-5-git-send-email-claudiu.manoil@nxp.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1564394627-3810-1-git-send-email-claudiu.manoil@nxp.com>
References: <1564394627-3810-1-git-send-email-claudiu.manoil@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

LS1028a has one Ethernet management interface. On the QDS board, the
MDIO signals are multiplexed to either on-board AR8035 PHY device or
to 4 PCIe slots allowing for SGMII cards.
To enable the Ethernet ENETC Port 1, which can only be connected to a
RGMII PHY, the multiplexer needs to be configured to route the MDIO to
the AR8035 PHY.  The MDIO/MDC routing is controlled by bits 7:4 of FPGA
board config register 0x54, and value 0 selects the on-board RGMII PHY.
The FPGA board config registers are accessible on the i2c bus, at address
0x66.

The PF3 MDIO PCIe integrated endpoint device allows for centralized access
to the MDIO bus.  Add the corresponding devicetree node and set it to be
the MDIO bus parent.

Signed-off-by: Alex Marginean <alexandru.marginean@nxp.com>
Signed-off-by: Claudiu Manoil <claudiu.manoil@nxp.com>
---
v1 - none
v2 - none
v3 - none

 .../boot/dts/freescale/fsl-ls1028a-qds.dts    | 40 +++++++++++++++++++
 .../arm64/boot/dts/freescale/fsl-ls1028a.dtsi |  6 +++
 2 files changed, 46 insertions(+)

diff --git a/arch/arm64/boot/dts/freescale/fsl-ls1028a-qds.dts b/arch/arm64/boot/dts/freescale/fsl-ls1028a-qds.dts
index de6ef39f3118..663c4b728c07 100644
--- a/arch/arm64/boot/dts/freescale/fsl-ls1028a-qds.dts
+++ b/arch/arm64/boot/dts/freescale/fsl-ls1028a-qds.dts
@@ -85,6 +85,26 @@
 			system-clock-frequency = <25000000>;
 		};
 	};
+
+	mdio-mux {
+		compatible = "mdio-mux-multiplexer";
+		mux-controls = <&mux 0>;
+		mdio-parent-bus = <&enetc_mdio_pf3>;
+		#address-cells=<1>;
+		#size-cells = <0>;
+
+		/* on-board RGMII PHY */
+		mdio@0 {
+			#address-cells = <1>;
+			#size-cells = <0>;
+			reg = <0>;
+
+			qds_phy1: ethernet-phy@5 {
+				/* Atheros 8035 */
+				reg = <5>;
+			};
+		};
+	};
 };
 
 &duart0 {
@@ -164,6 +184,26 @@
 			};
 		};
 	};
+
+	fpga@66 {
+		#address-cells = <1>;
+		#size-cells = <0>;
+		compatible = "fsl,ls1028aqds-fpga", "fsl,fpga-qixis-i2c",
+			     "simple-mfd";
+		reg = <0x66>;
+
+		mux: mux-controller {
+			compatible = "reg-mux";
+			#mux-control-cells = <1>;
+			mux-reg-masks = <0x54 0xf0>; /* 0: reg 0x54, bits 7:4 */
+		};
+	};
+
+};
+
+&enetc_port1 {
+	phy-handle = <&qds_phy1>;
+	phy-connection-type = "rgmii-id";
 };
 
 &sai1 {
diff --git a/arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi b/arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi
index 7975519b4f56..de71153fda00 100644
--- a/arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi
+++ b/arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi
@@ -536,6 +536,12 @@
 				compatible = "fsl,enetc";
 				reg = <0x000100 0 0 0 0>;
 			};
+			enetc_mdio_pf3: mdio@0,3 {
+				compatible = "fsl,enetc-mdio";
+				reg = <0x000300 0 0 0 0>;
+				#address-cells = <1>;
+				#size-cells = <0>;
+			};
 			ethernet@0,4 {
 				compatible = "fsl,enetc-ptp";
 				reg = <0x000400 0 0 0 0>;
-- 
2.17.1

