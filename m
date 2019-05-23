Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6101279DE
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 11:58:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730469AbfEWJ5s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 05:57:48 -0400
Received: from relay8-d.mail.gandi.net ([217.70.183.201]:42087 "EHLO
        relay8-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730404AbfEWJ5r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 05:57:47 -0400
X-Originating-IP: 90.88.22.185
Received: from localhost (aaubervilliers-681-1-80-185.w90-88.abo.wanadoo.fr [90.88.22.185])
        (Authenticated sender: maxime.ripard@bootlin.com)
        by relay8-d.mail.gandi.net (Postfix) with ESMTPSA id 96BFB1BF210;
        Thu, 23 May 2019 09:57:36 +0000 (UTC)
From:   Maxime Ripard <maxime.ripard@bootlin.com>
To:     Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Chen-Yu Tsai <wens@csie.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>
Cc:     Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        =?UTF-8?q?Antoine=20T=C3=A9nart?= <antoine.tenart@bootlin.com>
Subject: [PATCH 7/8] dt-bindings: net: sun7i-gmac: Convert the binding to a schemas
Date:   Thu, 23 May 2019 11:56:50 +0200
Message-Id: <6f16585ffdc75af4e023c4d3ebba68feb65cc26e.1558605170.git-series.maxime.ripard@bootlin.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <74d98cc3c744d53710c841381efd41cf5f15e656.1558605170.git-series.maxime.ripard@bootlin.com>
References: <74d98cc3c744d53710c841381efd41cf5f15e656.1558605170.git-series.maxime.ripard@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Switch our Allwinner A20 GMAC controller binding to a YAML schema to enable
the DT validation. Since that controller is based on a Synopsys IP, let's
add the validation to that schemas with a bunch of conditionals.

Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
---
 Documentation/devicetree/bindings/net/allwinner,sun7i-a20-gmac.txt | 27 ---------------------------
 Documentation/devicetree/bindings/net/snps,dwmac.yaml              | 45 +++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 45 insertions(+), 27 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/net/allwinner,sun7i-a20-gmac.txt

diff --git a/Documentation/devicetree/bindings/net/allwinner,sun7i-a20-gmac.txt b/Documentation/devicetree/bindings/net/allwinner,sun7i-a20-gmac.txt
deleted file mode 100644
index 8b3f953656e3..000000000000
--- a/Documentation/devicetree/bindings/net/allwinner,sun7i-a20-gmac.txt
+++ /dev/null
@@ -1,27 +0,0 @@
-* Allwinner GMAC ethernet controller
-
-This device is a platform glue layer for stmmac.
-Please see stmmac.txt for the other unchanged properties.
-
-Required properties:
- - compatible:  Should be "allwinner,sun7i-a20-gmac"
- - clocks: Should contain the GMAC main clock, and tx clock
-   The tx clock type should be "allwinner,sun7i-a20-gmac-clk"
- - clock-names: Should contain the clock names "stmmaceth",
-   and "allwinner_gmac_tx"
-
-Optional properties:
-- phy-supply: phandle to a regulator if the PHY needs one
-
-Examples:
-
-	gmac: ethernet@1c50000 {
-		compatible = "allwinner,sun7i-a20-gmac";
-		reg = <0x01c50000 0x10000>,
-		      <0x01c20164 0x4>;
-		interrupts = <0 85 1>;
-		interrupt-names = "macirq";
-		clocks = <&ahb_gates 49>, <&gmac_tx>;
-		clock-names = "stmmaceth", "allwinner_gmac_tx";
-		phy-mode = "mii";
-	};
diff --git a/Documentation/devicetree/bindings/net/snps,dwmac.yaml b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
index be3ada5121e1..d213c32ef153 100644
--- a/Documentation/devicetree/bindings/net/snps,dwmac.yaml
+++ b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
@@ -14,6 +14,7 @@ maintainers:
 properties:
   compatible:
     oneOf:
+      - const: allwinner,sun7i-a20-gmac
       - const: snps,dwmac
       - const: snps,dwmac-3.50a
       - const: snps,dwmac-3.610
@@ -232,6 +233,7 @@ allOf:
       properties:
         compatible:
           enum:
+            - allwinner,sun7i-a20-gmac
             - snps,dwxgmac
             - snps,dwxgmac-2.10
             - st,spear600-gmac
@@ -273,6 +275,37 @@ allOf:
             Enables the TSO feature otherwise it will be managed by
             MAC HW capability register. Only for GMAC4 and newer.
 
+  - if:
+      properties:
+        compatible:
+          const: allwinner,sun7i-a20-gmac
+
+    then:
+      properties:
+        interrupts:
+          maxItems: 1
+
+        interrupt-names:
+          const: macirq
+
+        clocks:
+          items:
+            - description: GMAC main clock
+            - description: TX clock
+
+        clock-names:
+          items:
+            - const: stmmaceth
+            - const: allwinner_gmac_tx
+
+        phy-supply:
+          description:
+            PHY regulator
+
+      required:
+        - clocks
+        - clock-names
+
 examples:
   - |
     stmmac_axi_setup: stmmac-axi-config {
@@ -337,6 +370,18 @@ examples:
         };
     };
 
+  - |
+    gmac: ethernet@1c50000 {
+        compatible = "allwinner,sun7i-a20-gmac";
+        reg = <0x01c50000 0x10000>,
+              <0x01c20164 0x4>;
+        interrupts = <0 85 1>;
+        interrupt-names = "macirq";
+        clocks = <&ahb_gates 49>, <&gmac_tx>;
+        clock-names = "stmmaceth", "allwinner_gmac_tx";
+        phy-mode = "mii";
+    };
+
 # FIXME: We should set it, but it would report all the generic
 # properties as additional properties.
 # additionalProperties: false
-- 
git-series 0.9.1
