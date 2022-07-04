Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B194564F05
	for <lists+netdev@lfdr.de>; Mon,  4 Jul 2022 09:51:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232807AbiGDHuv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jul 2022 03:50:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230505AbiGDHuq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jul 2022 03:50:46 -0400
Received: from relmlie6.idc.renesas.com (relmlor2.renesas.com [210.160.252.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 537199FE1;
        Mon,  4 Jul 2022 00:50:45 -0700 (PDT)
X-IronPort-AV: E=Sophos;i="5.92,243,1650898800"; 
   d="scan'208";a="126598588"
Received: from unknown (HELO relmlir6.idc.renesas.com) ([10.200.68.152])
  by relmlie6.idc.renesas.com with ESMTP; 04 Jul 2022 16:50:45 +0900
Received: from localhost.localdomain (unknown [10.226.92.214])
        by relmlir6.idc.renesas.com (Postfix) with ESMTP id 0CD9B422FDEB;
        Mon,  4 Jul 2022 16:50:39 +0900 (JST)
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Cc:     Biju Das <biju.das.jz@bp.renesas.com>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        linux-renesas-soc@vger.kernel.org
Subject: [PATCH v3 1/6] dt-bindings: can: sja1000: Convert to json-schema
Date:   Mon,  4 Jul 2022 08:50:27 +0100
Message-Id: <20220704075032.383700-2-biju.das.jz@bp.renesas.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220704075032.383700-1-biju.das.jz@bp.renesas.com>
References: <20220704075032.383700-1-biju.das.jz@bp.renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert the NXP SJA1000 CAN Controller Device Tree binding
documentation to json-schema.

Update the example to match reality.

Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
---
v2->v3:
 * Added reg-io-width is a required property for technologic,sja1000
 * Removed enum type from nxp,tx-output-config and updated the description
   for combination of TX0 and TX1.
 * Updated the example
v1->v2:
 * Moved $ref: can-controller.yaml# to top along with if conditional to
   avoid multiple mapping issues with the if conditional in the subsequent
   patch.
---
 .../bindings/net/can/nxp,sja1000.yaml         | 103 ++++++++++++++++++
 .../devicetree/bindings/net/can/sja1000.txt   |  58 ----------
 2 files changed, 103 insertions(+), 58 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/can/nxp,sja1000.yaml
 delete mode 100644 Documentation/devicetree/bindings/net/can/sja1000.txt

diff --git a/Documentation/devicetree/bindings/net/can/nxp,sja1000.yaml b/Documentation/devicetree/bindings/net/can/nxp,sja1000.yaml
new file mode 100644
index 000000000000..d34060226e4e
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/can/nxp,sja1000.yaml
@@ -0,0 +1,103 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/can/nxp,sja1000.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Memory mapped SJA1000 CAN controller from NXP (formerly Philips)
+
+maintainers:
+  - Wolfgang Grandegger <wg@grandegger.com>
+
+allOf:
+  - $ref: can-controller.yaml#
+  - if:
+      properties:
+        compatible:
+          contains:
+            const: technologic,sja1000
+    then:
+      required:
+        - reg-io-width
+
+properties:
+  compatible:
+    oneOf:
+      - description: NXP SJA1000 CAN Controller
+        const: nxp,sja1000
+      - description: Technologic Systems SJA1000 CAN Controller
+        const: technologic,sja1000
+
+  reg:
+    maxItems: 1
+
+  interrupts:
+    maxItems: 1
+
+  reg-io-width:
+    $ref: /schemas/types.yaml#/definitions/uint32
+    description: I/O register width (in bytes) implemented by this device
+    default: 1
+    enum: [ 1, 2, 4 ]
+
+  nxp,external-clock-frequency:
+    $ref: /schemas/types.yaml#/definitions/uint32
+    default: 16000000
+    description: |
+      Frequency of the external oscillator clock in Hz.
+      The internal clock frequency used by the SJA1000 is half of that value.
+
+  nxp,tx-output-mode:
+    $ref: /schemas/types.yaml#/definitions/uint32
+    enum: [ 0, 1, 2, 3 ]
+    default: 1
+    description: |
+      operation mode of the TX output control logic. Valid values are:
+        <0x0> : bi-phase output mode
+        <0x1> : normal output mode (default)
+        <0x2> : test output mode
+        <0x3> : clock output mode
+
+  nxp,tx-output-config:
+    $ref: /schemas/types.yaml#/definitions/uint32
+    default: 0x02
+    description: |
+      TX output pin configuration. Valid values are any one of the below
+      or combination of TX0 and TX1:
+        <0x01> : TX0 invert
+        <0x02> : TX0 pull-down (default)
+        <0x04> : TX0 pull-up
+        <0x06> : TX0 push-pull
+        <0x08> : TX1 invert
+        <0x10> : TX1 pull-down
+        <0x20> : TX1 pull-up
+        <0x30> : TX1 push-pull
+
+  nxp,clock-out-frequency:
+    $ref: /schemas/types.yaml#/definitions/uint32
+    description: |
+      clock frequency in Hz on the CLKOUT pin.
+      If not specified or if the specified value is 0, the CLKOUT pin
+      will be disabled.
+
+  nxp,no-comparator-bypass:
+    type: boolean
+    description: Allows to disable the CAN input comparator.
+
+required:
+  - compatible
+  - reg
+  - interrupts
+
+unevaluatedProperties: false
+
+examples:
+  - |
+    can@1a000 {
+            compatible = "technologic,sja1000";
+            reg = <0x1a000 0x100>;
+            interrupts = <1>;
+            reg-io-width = <2>;
+            nxp,tx-output-config = <0x06>;
+            nxp,external-clock-frequency = <24000000>;
+    };
diff --git a/Documentation/devicetree/bindings/net/can/sja1000.txt b/Documentation/devicetree/bindings/net/can/sja1000.txt
deleted file mode 100644
index ac3160eca96a..000000000000
--- a/Documentation/devicetree/bindings/net/can/sja1000.txt
+++ /dev/null
@@ -1,58 +0,0 @@
-Memory mapped SJA1000 CAN controller from NXP (formerly Philips)
-
-Required properties:
-
-- compatible : should be one of "nxp,sja1000", "technologic,sja1000".
-
-- reg : should specify the chip select, address offset and size required
-	to map the registers of the SJA1000. The size is usually 0x80.
-
-- interrupts: property with a value describing the interrupt source
-	(number and sensitivity) required for the SJA1000.
-
-Optional properties:
-
-- reg-io-width : Specify the size (in bytes) of the IO accesses that
-	should be performed on the device.  Valid value is 1, 2 or 4.
-	This property is ignored for technologic version.
-	Default to 1 (8 bits).
-
-- nxp,external-clock-frequency : Frequency of the external oscillator
-	clock in Hz. Note that the internal clock frequency used by the
-	SJA1000 is half of that value. If not specified, a default value
-	of 16000000 (16 MHz) is used.
-
-- nxp,tx-output-mode : operation mode of the TX output control logic:
-	<0x0> : bi-phase output mode
-	<0x1> : normal output mode (default)
-	<0x2> : test output mode
-	<0x3> : clock output mode
-
-- nxp,tx-output-config : TX output pin configuration:
-	<0x01> : TX0 invert
-	<0x02> : TX0 pull-down (default)
-	<0x04> : TX0 pull-up
-	<0x06> : TX0 push-pull
-	<0x08> : TX1 invert
-	<0x10> : TX1 pull-down
-	<0x20> : TX1 pull-up
-	<0x30> : TX1 push-pull
-
-- nxp,clock-out-frequency : clock frequency in Hz on the CLKOUT pin.
-	If not specified or if the specified value is 0, the CLKOUT pin
-	will be disabled.
-
-- nxp,no-comparator-bypass : Allows to disable the CAN input comparator.
-
-For further information, please have a look to the SJA1000 data sheet.
-
-Examples:
-
-can@3,100 {
-	compatible = "nxp,sja1000";
-	reg = <3 0x100 0x80>;
-	interrupts = <2 0>;
-	interrupt-parent = <&mpic>;
-	nxp,external-clock-frequency = <16000000>;
-};
-
-- 
2.25.1

