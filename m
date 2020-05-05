Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F32401C5370
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 12:42:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728627AbgEEKm1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 06:42:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728401AbgEEKm1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 06:42:27 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E358CC061A10
        for <netdev@vger.kernel.org>; Tue,  5 May 2020 03:42:26 -0700 (PDT)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1jVv1n-0000cZ-GV; Tue, 05 May 2020 12:42:19 +0200
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1jVv1k-0002mo-MH; Tue, 05 May 2020 12:42:16 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <robh+dt@kernel.org>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Marek Vasut <marex@denx.de>, David Jander <david@protonic.nl>,
        devicetree@vger.kernel.org
Subject: [PATCH v1] dt-bindings: net: nxp,tja11xx: rework validation support
Date:   Tue,  5 May 2020 12:42:15 +0200
Message-Id: <20200505104215.8975-1-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To properly identify this node, we need to use ethernet-phy-id0180.dc80.
And add missing required properties.

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 .../devicetree/bindings/net/nxp,tja11xx.yaml  | 55 ++++++++++++-------
 1 file changed, 35 insertions(+), 20 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/nxp,tja11xx.yaml b/Documentation/devicetree/bindings/net/nxp,tja11xx.yaml
index 42be0255512b3..cc322107a24a2 100644
--- a/Documentation/devicetree/bindings/net/nxp,tja11xx.yaml
+++ b/Documentation/devicetree/bindings/net/nxp,tja11xx.yaml
@@ -1,4 +1,4 @@
-# SPDX-License-Identifier: GPL-2.0+
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
 %YAML 1.2
 ---
 $id: http://devicetree.org/schemas/net/nxp,tja11xx.yaml#
@@ -12,44 +12,59 @@ maintainers:
   - Heiner Kallweit <hkallweit1@gmail.com>
 
 description:
-  Bindings for NXP TJA11xx automotive PHYs
+  Bindings for the NXP TJA1102 automotive PHY. This is a dual PHY package where
+  only the first PHY has global configuration register and HW health
+  monitoring.
 
-allOf:
-  - $ref: ethernet-phy.yaml#
+properties:
+  compatible:
+    const: ethernet-phy-id0180.dc80
+    description: ethernet-phy-id0180.dc80 used for TJA1102 PHY
+
+  reg:
+    minimum: 0
+    maximum: 14
+    description:
+      The PHY address of the parent PHY.
+
+  '#address-cells':
+    description: number of address cells for the MDIO bus
+    const: 1
+
+  '#size-cells':
+    description: number of size cells on the MDIO bus
+    const: 0
 
 patternProperties:
-  "^ethernet-phy@[0-9a-f]+$":
+  "^ethernet-phy@[0-9a-f]$":
     type: object
-    description: |
-      Some packages have multiple PHYs. Secondary PHY should be defines as
-      subnode of the first (parent) PHY.
+    description:
+      Integrated PHY node
 
     properties:
       reg:
-        minimum: 0
-        maximum: 31
+        minimum: 1
+        maximum: 15
         description:
-          The ID number for the child PHY. Should be +1 of parent PHY.
+          The PHY address of the slave PHY. Should be +1 of parent PHY.
 
     required:
       - reg
 
-examples:
-  - |
-    mdio {
-        #address-cells = <1>;
-        #size-cells = <0>;
+required:
+  - compatible
+  - reg
+  - '#address-cells'
+  - '#size-cells'
 
-        tja1101_phy0: ethernet-phy@4 {
-            reg = <0x4>;
-        };
-    };
+examples:
   - |
     mdio {
         #address-cells = <1>;
         #size-cells = <0>;
 
         tja1102_phy0: ethernet-phy@4 {
+            compatible = "ethernet-phy-id0180.dc80";
             reg = <0x4>;
             #address-cells = <1>;
             #size-cells = <0>;
-- 
2.26.2

