Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A5E1E07CC
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 17:48:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388042AbfJVPrv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 11:47:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:46160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387922AbfJVPru (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Oct 2019 11:47:50 -0400
Received: from localhost (lfbn-1-10718-76.w90-89.abo.wanadoo.fr [90.89.68.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 37E52214B2;
        Tue, 22 Oct 2019 15:47:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571759269;
        bh=AejEtY/BzekHga8zdI53AO/Lgt0U9aGhqsnmnZTTvEk=;
        h=From:To:Cc:Subject:Date:From;
        b=uIwo/poRGQ2nZ+Ll0BT/EKjrLOkddCaonISjJKhlgNes7MYBprmOjkz0hJ5OVg9cU
         SQwcO1uSROrdizd+ThAd4149harMVJFT99FKVFGco96K5/coENG9iWDFQHEpNGGv7T
         uPkDFfV/Iu1SCgCew3BL5GqvjsqY5Ahn2GhbVQJU=
From:   Maxime Ripard <mripard@kernel.org>
To:     wg@grandegger.com, mkl@pengutronix.de, davem@davemloft.net
Cc:     Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>,
        devicetree@vger.kernel.org, Chen-Yu Tsai <wens@csie.org>,
        Maxime Ripard <mripard@kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-can@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH] dt-bindings: can: Convert Allwinner A10 CAN controller to a schema
Date:   Tue, 22 Oct 2019 17:47:45 +0200
Message-Id: <20191022154745.41865-1-mripard@kernel.org>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The older Allwinner SoCs have a CAN controller that is supported in Linux,
with a matching Device Tree binding.

Now that we have the DT validation in place, let's convert the device tree
bindings for that controller over to a YAML schemas.

Signed-off-by: Maxime Ripard <mripard@kernel.org>
---
 .../net/can/allwinner,sun4i-a10-can.yaml      | 51 +++++++++++++++++++
 .../devicetree/bindings/net/can/sun4i_can.txt | 36 -------------
 2 files changed, 51 insertions(+), 36 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/can/allwinner,sun4i-a10-can.yaml
 delete mode 100644 Documentation/devicetree/bindings/net/can/sun4i_can.txt

diff --git a/Documentation/devicetree/bindings/net/can/allwinner,sun4i-a10-can.yaml b/Documentation/devicetree/bindings/net/can/allwinner,sun4i-a10-can.yaml
new file mode 100644
index 000000000000..770af7c46114
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/can/allwinner,sun4i-a10-can.yaml
@@ -0,0 +1,51 @@
+# SPDX-License-Identifier: GPL-2.0
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/can/allwinner,sun4i-a10-can.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Allwinner A10 CAN Controller Device Tree Bindings
+
+maintainers:
+  - Chen-Yu Tsai <wens@csie.org>
+  - Maxime Ripard <maxime.ripard@bootlin.com>
+
+properties:
+  compatible:
+    oneOf:
+      - items:
+          - const: allwinner,sun7i-a20-can
+          - const: allwinner,sun4i-a10-can
+      - const: allwinner,sun4i-a10-can
+
+  reg:
+    maxItems: 1
+
+  interrupts:
+    maxItems: 1
+
+  clocks:
+    maxItems: 1
+
+required:
+  - compatible
+  - reg
+  - interrupts
+  - clocks
+
+additionalProperties: false
+
+examples:
+  - |
+    #include <dt-bindings/interrupt-controller/arm-gic.h>
+    #include <dt-bindings/clock/sun7i-a20-ccu.h>
+
+    can0: can@1c2bc00 {
+        compatible = "allwinner,sun7i-a20-can",
+                     "allwinner,sun4i-a10-can";
+        reg = <0x01c2bc00 0x400>;
+        interrupts = <GIC_SPI 26 IRQ_TYPE_LEVEL_HIGH>;
+        clocks = <&ccu CLK_APB1_CAN>;
+    };
+
+...
diff --git a/Documentation/devicetree/bindings/net/can/sun4i_can.txt b/Documentation/devicetree/bindings/net/can/sun4i_can.txt
deleted file mode 100644
index f69845e6feaf..000000000000
--- a/Documentation/devicetree/bindings/net/can/sun4i_can.txt
+++ /dev/null
@@ -1,36 +0,0 @@
-Allwinner A10/A20 CAN controller Device Tree Bindings
------------------------------------------------------
-
-Required properties:
-- compatible: "allwinner,sun4i-a10-can"
-- reg: physical base address and size of the Allwinner A10/A20 CAN register map.
-- interrupts: interrupt specifier for the sole interrupt.
-- clock: phandle and clock specifier.
-
-Example
--------
-
-SoC common .dtsi file:
-
-	can0_pins_a: can0@0 {
-		allwinner,pins = "PH20","PH21";
-		allwinner,function = "can";
-		allwinner,drive = <0>;
-		allwinner,pull = <0>;
-	};
-...
-	can0: can@1c2bc00 {
-		compatible = "allwinner,sun4i-a10-can";
-		reg = <0x01c2bc00 0x400>;
-		interrupts = <0 26 4>;
-		clocks = <&apb1_gates 4>;
-		status = "disabled";
-	};
-
-Board specific .dts file:
-
-	can0: can@1c2bc00 {
-		pinctrl-names = "default";
-		pinctrl-0 = <&can0_pins_a>;
-		status = "okay";
-	};
-- 
2.23.0

