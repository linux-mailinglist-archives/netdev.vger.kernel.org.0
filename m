Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BF7A2815BB
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 16:50:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388238AbgJBOuJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 10:50:09 -0400
Received: from inva021.nxp.com ([92.121.34.21]:55306 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388074AbgJBOts (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Oct 2020 10:49:48 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 2FECD200D3F;
        Fri,  2 Oct 2020 16:49:46 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 2407A20012D;
        Fri,  2 Oct 2020 16:49:46 +0200 (CEST)
Received: from fsr-ub1864-126.ea.freescale.net (fsr-ub1864-126.ea.freescale.net [10.171.82.212])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id D40A3202AC;
        Fri,  2 Oct 2020 16:49:45 +0200 (CEST)
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     shawnguo@kernel.org, robh+dt@kernel.org,
        devicetree@vger.kernel.org, Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [RESEND net-next 3/9] arm64: dts: ls1088ardb: add necessary DTS nodes for DPMAC2
Date:   Fri,  2 Oct 2020 17:48:41 +0300
Message-Id: <20201002144847.13793-4-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201002144847.13793-1-ioana.ciornei@nxp.com>
References: <20201002144847.13793-1-ioana.ciornei@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Annotate the external MDIO2 node and describe the 10GBASER PHY found on
the LS1088ARDB board and add a phy-handle for DPMAC2 to link it.
Also, add the internal PCS MDIO node for the internal MDIO buses found
on the LS1088A SoC along with its internal PCS PHY and link the
corresponding DPMAC to the PCS through the pcs-handle.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 .../boot/dts/freescale/fsl-ls1088a-rdb.dts    | 19 +++++++++++++++++++
 .../arm64/boot/dts/freescale/fsl-ls1088a.dtsi | 13 +++++++++++++
 2 files changed, 32 insertions(+)

diff --git a/arch/arm64/boot/dts/freescale/fsl-ls1088a-rdb.dts b/arch/arm64/boot/dts/freescale/fsl-ls1088a-rdb.dts
index d7886b084f7f..661898064f0c 100644
--- a/arch/arm64/boot/dts/freescale/fsl-ls1088a-rdb.dts
+++ b/arch/arm64/boot/dts/freescale/fsl-ls1088a-rdb.dts
@@ -17,6 +17,12 @@ / {
 	compatible = "fsl,ls1088a-rdb", "fsl,ls1088a";
 };
 
+&dpmac2 {
+	phy-handle = <&mdio2_aquantia_phy>;
+	phy-connection-type = "10gbase-r";
+	pcs-handle = <&pcs2>;
+};
+
 &dpmac3 {
 	phy-handle = <&mdio1_phy5>;
 	phy-connection-type = "qsgmii";
@@ -109,6 +115,15 @@ mdio1_phy8: emdio1_phy@8 {
 	};
 };
 
+&emdio2 {
+	status = "okay";
+
+	mdio2_aquantia_phy: emdio2_aquantia@0 {
+		compatible = "ethernet-phy-ieee802.3-c45";
+		reg = <0x0>;
+	};
+};
+
 &i2c0 {
 	status = "okay";
 
@@ -179,6 +194,10 @@ &esdhc {
 	status = "okay";
 };
 
+&pcs_mdio2 {
+	status = "okay";
+};
+
 &pcs_mdio3 {
 	status = "okay";
 };
diff --git a/arch/arm64/boot/dts/freescale/fsl-ls1088a.dtsi b/arch/arm64/boot/dts/freescale/fsl-ls1088a.dtsi
index ad8679e58f9a..837d53472000 100644
--- a/arch/arm64/boot/dts/freescale/fsl-ls1088a.dtsi
+++ b/arch/arm64/boot/dts/freescale/fsl-ls1088a.dtsi
@@ -672,6 +672,19 @@ emdio2: mdio@0x8B97000 {
 			status = "disabled";
 		};
 
+		pcs_mdio2: mdio@8c0b000 {
+			compatible = "fsl,fman-memac-mdio";
+			reg = <0x0 0x8c0b000 0x0 0x1000>;
+			little-endian;
+			#address-cells = <1>;
+			#size-cells = <0>;
+			status = "disabled";
+
+			pcs2: pcs-phy@0 {
+				reg = <0>;
+			};
+		};
+
 		pcs_mdio3: mdio@8c0f000 {
 			compatible = "fsl,fman-memac-mdio";
 			reg = <0x0 0x8c0f000 0x0 0x1000>;
-- 
2.28.0

