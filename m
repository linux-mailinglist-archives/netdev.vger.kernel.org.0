Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EA274AF02B
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 12:55:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231509AbiBILzX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 06:55:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230393AbiBILzO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 06:55:14 -0500
Received: from codeconstruct.com.au (pi.codeconstruct.com.au [203.29.241.158])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A2FEC1036AA;
        Wed,  9 Feb 2022 02:48:00 -0800 (PST)
Received: by codeconstruct.com.au (Postfix, from userid 10001)
        id 38A202029C; Wed,  9 Feb 2022 18:31:51 +0800 (AWST)
From:   Matt Johnston <matt@codeconstruct.com.au>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jeremy Kerr <jk@codeconstruct.com.au>,
        linux-i2c@vger.kernel.org, netdev@vger.kernel.org,
        Zev Weiss <zev@bewilderbeest.net>,
        Rob Herring <robh@kernel.org>
Subject: [PATCH net-next v4 1/2] dt-bindings: net: New binding mctp-i2c-controller
Date:   Wed,  9 Feb 2022 18:31:20 +0800
Message-Id: <20220209103121.3907832-2-matt@codeconstruct.com.au>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220209103121.3907832-1-matt@codeconstruct.com.au>
References: <20220209103121.3907832-1-matt@codeconstruct.com.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,KHOP_HELO_FCRDNS,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Used to define a local endpoint to communicate with MCTP peripherals
attached to an I2C bus. This I2C endpoint can communicate with remote
MCTP devices on the I2C bus.

In the example I2C topology below (matching the second yaml example) we
have MCTP devices on busses i2c1 and i2c6. MCTP-supporting busses are
indicated by the 'mctp-controller' DT property on an I2C bus node.

A mctp-i2c-controller I2C client DT node is placed at the top of the
mux topology, since only the root I2C adapter will support I2C slave
functionality.
                                               .-------.
                                               |eeprom |
    .------------.     .------.               /'-------'
    | adapter    |     | mux  --@0,i2c5------'
    | i2c1       ----.*|      --@1,i2c6--.--.
    |............|    \'------'           \  \  .........
    | mctp-i2c-  |     \                   \  \ .mctpB  .
    | controller |      \                   \  '.0x30   .
    |            |       \  .........        \  '.......'
    | 0x50       |        \ .mctpA  .         \ .........
    '------------'         '.0x1d   .          '.mctpC  .
                            '.......'          '.0x31   .
                                                '.......'
(mctpX boxes above are remote MCTP devices not included in the DT at
present, they can be hotplugged/probed at runtime. A DT binding for
specific fixed MCTP devices could be added later if required)

Signed-off-by: Matt Johnston <matt@codeconstruct.com.au>
Reviewed-by: Rob Herring <robh@kernel.org>
---
 Documentation/devicetree/bindings/i2c/i2c.txt |  4 +
 .../bindings/net/mctp-i2c-controller.yaml     | 92 +++++++++++++++++++
 2 files changed, 96 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/mctp-i2c-controller.yaml

diff --git a/Documentation/devicetree/bindings/i2c/i2c.txt b/Documentation/devicetree/bindings/i2c/i2c.txt
index b864916e087f..fc3dd7ec0445 100644
--- a/Documentation/devicetree/bindings/i2c/i2c.txt
+++ b/Documentation/devicetree/bindings/i2c/i2c.txt
@@ -95,6 +95,10 @@ wants to support one of the below features, it should adapt these bindings.
 - smbus-alert
 	states that the optional SMBus-Alert feature apply to this bus.
 
+- mctp-controller
+	indicates that the system is accessible via this bus as an endpoint for
+	MCTP over I2C transport.
+
 Required properties (per child device)
 --------------------------------------
 
diff --git a/Documentation/devicetree/bindings/net/mctp-i2c-controller.yaml b/Documentation/devicetree/bindings/net/mctp-i2c-controller.yaml
new file mode 100644
index 000000000000..afd11c9422fa
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/mctp-i2c-controller.yaml
@@ -0,0 +1,92 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/mctp-i2c-controller.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: MCTP I2C transport binding
+
+maintainers:
+  - Matt Johnston <matt@codeconstruct.com.au>
+
+description: |
+  An mctp-i2c-controller defines a local MCTP endpoint on an I2C controller.
+  MCTP I2C is specified by DMTF DSP0237.
+
+  An mctp-i2c-controller must be attached to an I2C adapter which supports
+  slave functionality. I2C busses (either directly or as subordinate mux
+  busses) are attached to the mctp-i2c-controller with a 'mctp-controller'
+  property on each used bus. Each mctp-controller I2C bus will be presented
+  to the host system as a separate MCTP I2C instance.
+
+properties:
+  compatible:
+    const: mctp-i2c-controller
+
+  reg:
+    minimum: 0x40000000
+    maximum: 0x4000007f
+    description: |
+      7 bit I2C address of the local endpoint.
+      I2C_OWN_SLAVE_ADDRESS (1<<30) flag must be set.
+
+additionalProperties: false
+
+required:
+  - compatible
+  - reg
+
+examples:
+  - |
+    // Basic case of a single I2C bus
+    #include <dt-bindings/i2c/i2c.h>
+
+    i2c {
+      #address-cells = <1>;
+      #size-cells = <0>;
+      mctp-controller;
+
+      mctp@30 {
+        compatible = "mctp-i2c-controller";
+        reg = <(0x30 | I2C_OWN_SLAVE_ADDRESS)>;
+      };
+    };
+
+  - |
+    // Mux topology with multiple MCTP-handling busses under
+    // a single mctp-i2c-controller.
+    // i2c1 and i2c6 can have MCTP devices, i2c5 does not.
+    #include <dt-bindings/i2c/i2c.h>
+
+    i2c1: i2c {
+      #address-cells = <1>;
+      #size-cells = <0>;
+      mctp-controller;
+
+      mctp@50 {
+        compatible = "mctp-i2c-controller";
+        reg = <(0x50 | I2C_OWN_SLAVE_ADDRESS)>;
+      };
+    };
+
+    i2c-mux {
+      #address-cells = <1>;
+      #size-cells = <0>;
+      i2c-parent = <&i2c1>;
+
+      i2c5: i2c@0 {
+        #address-cells = <1>;
+        #size-cells = <0>;
+        reg = <0>;
+        eeprom@33 {
+          reg = <0x33>;
+        };
+      };
+
+      i2c6: i2c@1 {
+        #address-cells = <1>;
+        #size-cells = <0>;
+        reg = <1>;
+        mctp-controller;
+      };
+    };
-- 
2.32.0

