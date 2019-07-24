Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93A02731EC
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 16:42:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387495AbfGXOlv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 10:41:51 -0400
Received: from inva021.nxp.com ([92.121.34.21]:41194 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726631AbfGXOlq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Jul 2019 10:41:46 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 3F12120034A;
        Wed, 24 Jul 2019 16:41:44 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 317D7200348;
        Wed, 24 Jul 2019 16:41:44 +0200 (CEST)
Received: from fsr-ub1664-016.ea.freescale.net (fsr-ub1664-016.ea.freescale.net [10.171.71.216])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id C0733205D8;
        Wed, 24 Jul 2019 16:41:43 +0200 (CEST)
From:   Claudiu Manoil <claudiu.manoil@nxp.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     andrew@lunn.ch, Rob Herring <robh+dt@kernel.org>,
        Li Yang <leoyang.li@nxp.com>, alexandru.marginean@nxp.com,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v1 3/4] dt-bindings: net: fsl: enetc: Add bindings for the central MDIO PCIe endpoint
Date:   Wed, 24 Jul 2019 17:41:40 +0300
Message-Id: <1563979301-596-4-git-send-email-claudiu.manoil@nxp.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1563979301-596-1-git-send-email-claudiu.manoil@nxp.com>
References: <1563979301-596-1-git-send-email-claudiu.manoil@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The on-chip PCIe root complex that integrates the ENETC ethernet
controllers also integrates a PCIe enpoint for the MDIO controller
provinding for cetralized control of the ENETC mdio bus.
Add bindings for this "central" MDIO Integrated PCIe Endpoit.

Signed-off-by: Claudiu Manoil <claudiu.manoil@nxp.com>
---
v1 - none

 .../devicetree/bindings/net/fsl-enetc.txt     | 42 +++++++++++++++++--
 1 file changed, 39 insertions(+), 3 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/fsl-enetc.txt b/Documentation/devicetree/bindings/net/fsl-enetc.txt
index 25fc687419db..c090f6df7a39 100644
--- a/Documentation/devicetree/bindings/net/fsl-enetc.txt
+++ b/Documentation/devicetree/bindings/net/fsl-enetc.txt
@@ -11,7 +11,9 @@ Required properties:
 		  to parent node bindings.
 - compatible	: Should be "fsl,enetc".
 
-1) The ENETC external port is connected to a MDIO configurable phy:
+1. The ENETC external port is connected to a MDIO configurable phy
+
+1.1. Using the local ENETC Port MDIO interface
 
 In this case, the ENETC node should include a "mdio" sub-node
 that in turn should contain the "ethernet-phy" node describing the
@@ -47,8 +49,42 @@ Example:
 		};
 	};
 
-2) The ENETC port is an internal port or has a fixed-link external
-connection:
+1.2. Using the central MDIO PCIe enpoint device
+
+In this case, the mdio node should be defined as another PCIe
+endpoint node, at the same level with the ENETC port nodes.
+
+Required properties:
+
+- reg		: Specifies PCIe Device Number and Function
+		  Number of the ENETC endpoint device, according
+		  to parent node bindings.
+- compatible	: Should be "fsl,enetc-mdio".
+
+The remaining required mdio bus properties are standard, their bindings
+already defined in Documentation/devicetree/bindings/net/mdio.txt.
+
+Example:
+
+	ethernet@0,0 {
+		compatible = "fsl,enetc";
+		reg = <0x000000 0 0 0 0>;
+		phy-handle = <&sgmii_phy0>;
+		phy-connection-type = "sgmii";
+	};
+
+	mdio@0,3 {
+		compatible = "fsl,enetc-mdio";
+		reg = <0x000300 0 0 0 0>;
+		#address-cells = <1>;
+		#size-cells = <0>;
+		sgmii_phy0: ethernet-phy@2 {
+			reg = <0x2>;
+		};
+	};
+
+2. The ENETC port is an internal port or has a fixed-link external
+connection
 
 In this case, the ENETC port node defines a fixed link connection,
 as specified by Documentation/devicetree/bindings/net/fixed-link.txt.
-- 
2.17.1

