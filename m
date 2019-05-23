Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97B8C279D5
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 11:57:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730379AbfEWJ5g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 05:57:36 -0400
Received: from relay1-d.mail.gandi.net ([217.70.183.193]:57241 "EHLO
        relay1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727466AbfEWJ5g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 05:57:36 -0400
X-Originating-IP: 90.88.22.185
Received: from localhost (aaubervilliers-681-1-80-185.w90-88.abo.wanadoo.fr [90.88.22.185])
        (Authenticated sender: maxime.ripard@bootlin.com)
        by relay1-d.mail.gandi.net (Postfix) with ESMTPSA id 77D3824000E;
        Thu, 23 May 2019 09:57:24 +0000 (UTC)
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
Subject: [PATCH 5/8] dt-bindings: net: sun4i-mdio: Convert the binding to a schemas
Date:   Thu, 23 May 2019 11:56:48 +0200
Message-Id: <cbfb936eb53d0563b67d0f149bfcff50cd302ce6.1558605170.git-series.maxime.ripard@bootlin.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <74d98cc3c744d53710c841381efd41cf5f15e656.1558605170.git-series.maxime.ripard@bootlin.com>
References: <74d98cc3c744d53710c841381efd41cf5f15e656.1558605170.git-series.maxime.ripard@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Switch our Allwinner A10 MDIO controller binding to a YAML schema to enable
the DT validation.

Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
---
 Documentation/devicetree/bindings/net/allwinner,sun4i-a10-mdio.yaml | 55 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 Documentation/devicetree/bindings/net/allwinner,sun4i-mdio.txt      | 27 ---------------------------
 2 files changed, 55 insertions(+), 27 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/allwinner,sun4i-a10-mdio.yaml
 delete mode 100644 Documentation/devicetree/bindings/net/allwinner,sun4i-mdio.txt

diff --git a/Documentation/devicetree/bindings/net/allwinner,sun4i-a10-mdio.yaml b/Documentation/devicetree/bindings/net/allwinner,sun4i-a10-mdio.yaml
new file mode 100644
index 000000000000..32c0fdc57d35
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/allwinner,sun4i-a10-mdio.yaml
@@ -0,0 +1,55 @@
+# SPDX-License-Identifier: GPL-2.0
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/allwinner,sun4i-a10-mdio.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Allwinner A10 MDIO Controller Device Tree Bindings
+
+maintainers:
+  - Chen-Yu Tsai <wens@csie.org>
+  - Maxime Ripard <maxime.ripard@bootlin.com>
+
+properties:
+  "#address-cells":
+    const: 1
+
+  "#size-cells":
+    const: 0
+
+  compatible:
+    enum:
+      - allwinner,sun4i-a10-mdio
+
+      # Deprecated
+      - allwinner,sun4i-mdio
+
+  reg:
+    maxItems: 1
+
+  phy-supply:
+    description: PHY regulator
+
+required:
+  - compatible
+  - reg
+
+examples:
+  - |
+    mdio@1c0b080 {
+        compatible = "allwinner,sun4i-a10-mdio";
+        reg = <0x01c0b080 0x14>;
+        #address-cells = <1>;
+        #size-cells = <0>;
+        phy-supply = <&reg_emac_3v3>;
+
+        phy0: ethernet-phy@0 {
+            reg = <0>;
+        };
+    };
+
+# FIXME: We should set it, but it would report all the generic
+# properties as additional properties.
+# additionalProperties: false
+
+...
diff --git a/Documentation/devicetree/bindings/net/allwinner,sun4i-mdio.txt b/Documentation/devicetree/bindings/net/allwinner,sun4i-mdio.txt
deleted file mode 100644
index ab5b8613b0ef..000000000000
--- a/Documentation/devicetree/bindings/net/allwinner,sun4i-mdio.txt
+++ /dev/null
@@ -1,27 +0,0 @@
-* Allwinner A10 MDIO Ethernet Controller interface
-
-Required properties:
-- compatible: should be "allwinner,sun4i-a10-mdio"
-              (Deprecated: "allwinner,sun4i-mdio").
-- reg: address and length of the register set for the device.
-
-Optional properties:
-- phy-supply: phandle to a regulator if the PHY needs one
-
-Example at the SoC level:
-mdio@1c0b080 {
-	compatible = "allwinner,sun4i-a10-mdio";
-	reg = <0x01c0b080 0x14>;
-	#address-cells = <1>;
-	#size-cells = <0>;
-};
-
-And at the board level:
-
-mdio@1c0b080 {
-	phy-supply = <&reg_emac_3v3>;
-
-	phy0: ethernet-phy@0 {
-		reg = <0>;
-	};
-};
-- 
git-series 0.9.1
