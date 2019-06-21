Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB2EB4EC3D
	for <lists+netdev@lfdr.de>; Fri, 21 Jun 2019 17:39:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726606AbfFUPjK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jun 2019 11:39:10 -0400
Received: from inva021.nxp.com ([92.121.34.21]:48338 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726485AbfFUPi7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 Jun 2019 11:38:59 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 730822009FC;
        Fri, 21 Jun 2019 17:38:56 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 6502C200071;
        Fri, 21 Jun 2019 17:38:56 +0200 (CEST)
Received: from fsr-ub1664-016.ea.freescale.net (fsr-ub1664-016.ea.freescale.net [10.171.71.216])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id E7B4B20629;
        Fri, 21 Jun 2019 17:38:55 +0200 (CEST)
From:   Claudiu Manoil <claudiu.manoil@nxp.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Rob Herring <robh+dt@kernel.org>,
        Allan Nielsen <Allan.Nielsen@microsemi.com>,
        alexandru.marginean@nxp.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, UNGLinuxDriver@microchip.com
Subject: [PATCH net-next 4/6] arm64: dts: fsl: ls1028a: Add Felix switch port DT node
Date:   Fri, 21 Jun 2019 18:38:50 +0300
Message-Id: <1561131532-14860-5-git-send-email-claudiu.manoil@nxp.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1561131532-14860-1-git-send-email-claudiu.manoil@nxp.com>
References: <1561131532-14860-1-git-send-email-claudiu.manoil@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the switch device node, available on PF5, so that the
switch port sub-nodes (net devices) can be linked to
corresponding board specific phy nodes (external ports) or
have their link mode defined (internal ports).
The switch device features 6 ports, 4 with external links
and 2 internally facing to the ls1028a SoC and connected via
fixed links to 2 internal enetc ethernet controller ports.
Add the corresponding enetc internal port device nodes,
mapped to PF2 and PF6 PCIe functions.
And don't forget to enable the 4MB BAR4 in the root complex
ECAM space, where the switch registers are mapped.

Signed-off-by: Claudiu Manoil <claudiu.manoil@nxp.com>
---
 .../arm64/boot/dts/freescale/fsl-ls1028a.dtsi | 58 ++++++++++++++++++-
 1 file changed, 57 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi b/arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi
index 4cdf84c63320..2462dd936212 100644
--- a/arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi
+++ b/arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi
@@ -421,7 +421,9 @@
 				  /* PF1: VF0-1 BAR0 - non-prefetchable memory */
 				  0x82000000 0x0 0x00000000  0x1 0xf8210000  0x0 0x020000
 				  /* PF1: VF0-1 BAR2 - prefetchable memory */
-				  0xc2000000 0x0 0x00000000  0x1 0xf8230000  0x0 0x020000>;
+				  0xc2000000 0x0 0x00000000  0x1 0xf8230000  0x0 0x020000
+				  /* BAR4 (PF5) - non-prefetchable memory */
+				  0x82000000 0x0 0x00000000  0x1 0xfc000000  0x0 0x400000>;
 
 			enetc_port0: ethernet@0,0 {
 				compatible = "fsl,enetc";
@@ -431,12 +433,66 @@
 				compatible = "fsl,enetc";
 				reg = <0x000100 0 0 0 0>;
 			};
+			ethernet@0,2 {
+				compatible = "fsl,enetc";
+				reg = <0x000200 0 0 0 0>;
+				fixed-link {
+					speed = <1000>;
+					full-duplex;
+				};
+			};
 			ethernet@0,4 {
 				compatible = "fsl,enetc-ptp";
 				reg = <0x000400 0 0 0 0>;
 				clocks = <&clockgen 4 0>;
 				little-endian;
 			};
+			switch@0,5 {
+				compatible = "mscc,felix-switch";
+				reg = <0x000500 0 0 0 0>;
+
+				ethernet-ports {
+					#address-cells = <1>;
+					#size-cells = <0>;
+
+					/* external ports */
+					switch_port0: port@0 {
+						reg = <0>;
+					};
+					switch_port1: port@1 {
+						reg = <1>;
+					};
+					switch_port2: port@2 {
+						reg = <2>;
+					};
+					switch_port3: port@3 {
+						reg = <3>;
+					};
+					/* internal to-cpu ports */
+					port@4 {
+						reg = <4>;
+						fixed-link {
+							speed = <1000>;
+							full-duplex;
+						};
+					};
+					port@5 {
+						reg = <5>;
+						fixed-link {
+							speed = <1000>;
+							full-duplex;
+						};
+					};
+				};
+			};
+			ethernet@0,6 {
+				compatible = "fsl,enetc";
+				reg = <0x000600 0 0 0 0>;
+				fixed-link {
+					speed = <1000>;
+					full-duplex;
+				};
+			};
 		};
 	};
 };
-- 
2.17.1

