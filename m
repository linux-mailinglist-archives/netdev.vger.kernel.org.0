Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E12E038B0CF
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 16:00:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241171AbhETOBe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 May 2021 10:01:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243606AbhETOAW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 May 2021 10:00:22 -0400
Received: from xavier.telenet-ops.be (xavier.telenet-ops.be [IPv6:2a02:1800:120:4::f00:14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23BD3C061343
        for <netdev@vger.kernel.org>; Thu, 20 May 2021 06:58:50 -0700 (PDT)
Received: from ramsan.of.borg ([IPv6:2a02:1810:ac12:ed20:9cc6:7165:bcc2:1e70])
        by xavier.telenet-ops.be with bizsmtp
        id 71yi2500P31btb9011yiog; Thu, 20 May 2021 15:58:47 +0200
Received: from rox.of.borg ([192.168.97.57])
        by ramsan.of.borg with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <geert@linux-m68k.org>)
        id 1ljjCE-007Wn6-6i; Thu, 20 May 2021 15:58:42 +0200
Received: from geert by rox.of.borg with local (Exim 4.93)
        (envelope-from <geert@linux-m68k.org>)
        id 1ljjCD-008zrw-KE; Thu, 20 May 2021 15:58:41 +0200
From:   Geert Uytterhoeven <geert+renesas@glider.be>
To:     Rob Herring <robh+dt@kernel.org>, Shawn Guo <shawnguo@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     devicetree@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-mips@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH 5/5] dt-bindings: net: sms911x: Convert to json-schema
Date:   Thu, 20 May 2021 15:58:39 +0200
Message-Id: <f3f33f75c8911697f2c1dbde626f01187199bdc2.1621518686.git.geert+renesas@glider.be>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1621518686.git.geert+renesas@glider.be>
References: <cover.1621518686.git.geert+renesas@glider.be>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert the Smart Mixed-Signal Connectivity (SMSC) LAN911x/912x
Controller Device Tree binding documentation to json-schema.

Document missing properties.
Make "phy-mode" not required, as many DTS files do not have it, and the
Linux drivers falls back to PHY_INTERFACE_MODE_NA.
Correct nodename in example.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
I have listed Shawn as the maintainer, as he wrote the original
bindings.  Shawn: Please scream if this is inappropriate ;-)

I left "additionalProperties: true", as there are lots of bus-specific
properties ("qcom,*", "samsung,*", "fsl,*", "gpmc,*", ...) to be found,
that actually depend on the compatible value of the parent node.

---
 .../devicetree/bindings/net/gpmc-eth.txt      |   2 +-
 .../devicetree/bindings/net/smsc,lan9115.yaml | 107 ++++++++++++++++++
 .../devicetree/bindings/net/smsc911x.txt      |  43 -------
 3 files changed, 108 insertions(+), 44 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/smsc,lan9115.yaml
 delete mode 100644 Documentation/devicetree/bindings/net/smsc911x.txt

diff --git a/Documentation/devicetree/bindings/net/gpmc-eth.txt b/Documentation/devicetree/bindings/net/gpmc-eth.txt
index f7da3d73ca1b2e15..32821066a85b0078 100644
--- a/Documentation/devicetree/bindings/net/gpmc-eth.txt
+++ b/Documentation/devicetree/bindings/net/gpmc-eth.txt
@@ -13,7 +13,7 @@ Documentation/devicetree/bindings/memory-controllers/omap-gpmc.txt
 
 For the properties relevant to the ethernet controller connected to the GPMC
 refer to the binding documentation of the device. For example, the documentation
-for the SMSC 911x is Documentation/devicetree/bindings/net/smsc911x.txt
+for the SMSC 911x is Documentation/devicetree/bindings/net/smsc,lan9115.yaml
 
 Child nodes need to specify the GPMC bus address width using the "bank-width"
 property but is possible that an ethernet controller also has a property to
diff --git a/Documentation/devicetree/bindings/net/smsc,lan9115.yaml b/Documentation/devicetree/bindings/net/smsc,lan9115.yaml
new file mode 100644
index 0000000000000000..294fa3edf966695a
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/smsc,lan9115.yaml
@@ -0,0 +1,107 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/smsc,lan9115.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Smart Mixed-Signal Connectivity (SMSC) LAN911x/912x Controller
+
+maintainers:
+  - Shawn Guo <shawnguo@kernel.org>
+
+allOf:
+  - $ref: ethernet-controller.yaml#
+
+properties:
+  compatible:
+    oneOf:
+      - const: smsc,lan9115
+      - items:
+          - enum:
+              - "smsc,lan89218"
+              - "smsc,lan9117"
+              - "smsc,lan9118"
+              - "smsc,lan9220"
+              - "smsc,lan9221"
+          - const: smsc,lan9115
+
+  reg:
+    maxItems: 1
+
+  reg-shift: true
+
+  reg-io-width:
+    enum: [ 2, 4 ]
+    default: 2
+
+  interrupts:
+    minItems: 1
+    items:
+      - description:
+          LAN interrupt line
+      - description:
+          Optional PME (power management event) interrupt that is able to wake
+          up the host system with a 50ms pulse on network activity
+
+  clocks:
+    maxItems: 1
+
+  phy-mode: true
+
+  smsc,irq-active-high:
+    type: boolean
+    description: Indicates the IRQ polarity is active-high
+
+  smsc,irq-push-pull:
+    type: boolean
+    description: Indicates the IRQ type is push-pull
+
+  smsc,force-internal-phy:
+    type: boolean
+    description: Forces SMSC LAN controller to use internal PHY
+
+  smsc,force-external-phy:
+    type: boolean
+    description: Forces SMSC LAN controller to use external PHY
+
+  smsc,save-mac-address:
+    type: boolean
+    description:
+      Indicates that MAC address needs to be saved before resetting the
+      controller
+
+  reset-gpios:
+    maxItems: 1
+    description:
+      A GPIO line connected to the RESET (active low) signal of the device.
+      On many systems this is wired high so the device goes out of reset at
+      power-on, but if it is under program control, this optional GPIO can
+      wake up in response to it.
+
+  vdd33a-supply:
+    description: 3.3V analog power supply
+
+  vddvario-supply:
+    description: IO logic power supply
+
+required:
+  - compatible
+  - reg
+  - interrupts
+
+additionalProperties: true
+
+examples:
+  - |
+    #include <dt-bindings/gpio/gpio.h>
+
+    ethernet@f4000000 {
+            compatible = "smsc,lan9220", "smsc,lan9115";
+            reg = <0xf4000000 0x2000000>;
+            phy-mode = "mii";
+            interrupt-parent = <&gpio1>;
+            interrupts = <31>, <32>;
+            reset-gpios = <&gpio1 30 GPIO_ACTIVE_LOW>;
+            reg-io-width = <4>;
+            smsc,irq-push-pull;
+    };
diff --git a/Documentation/devicetree/bindings/net/smsc911x.txt b/Documentation/devicetree/bindings/net/smsc911x.txt
deleted file mode 100644
index acfafc8e143c4c85..0000000000000000
--- a/Documentation/devicetree/bindings/net/smsc911x.txt
+++ /dev/null
@@ -1,43 +0,0 @@
-* Smart Mixed-Signal Connectivity (SMSC) LAN911x/912x Controller
-
-Required properties:
-- compatible : Should be "smsc,lan<model>", "smsc,lan9115"
-- reg : Address and length of the io space for SMSC LAN
-- interrupts : one or two interrupt specifiers
-  - The first interrupt is the SMSC LAN interrupt line
-  - The second interrupt (if present) is the PME (power
-    management event) interrupt that is able to wake up the host
-     system with a 50ms pulse on network activity
-- phy-mode : See ethernet.txt file in the same directory
-
-Optional properties:
-- reg-shift : Specify the quantity to shift the register offsets by
-- reg-io-width : Specify the size (in bytes) of the IO accesses that
-  should be performed on the device.  Valid value for SMSC LAN is
-  2 or 4.  If it's omitted or invalid, the size would be 2.
-- smsc,irq-active-high : Indicates the IRQ polarity is active-high
-- smsc,irq-push-pull : Indicates the IRQ type is push-pull
-- smsc,force-internal-phy : Forces SMSC LAN controller to use
-  internal PHY
-- smsc,force-external-phy : Forces SMSC LAN controller to use
-  external PHY
-- smsc,save-mac-address : Indicates that mac address needs to be saved
-  before resetting the controller
-- reset-gpios : a GPIO line connected to the RESET (active low) signal
-  of the device. On many systems this is wired high so the device goes
-  out of reset at power-on, but if it is under program control, this
-  optional GPIO can wake up in response to it.
-- vdd33a-supply, vddvario-supply : 3.3V analog and IO logic power supplies
-
-Examples:
-
-lan9220@f4000000 {
-	compatible = "smsc,lan9220", "smsc,lan9115";
-	reg = <0xf4000000 0x2000000>;
-	phy-mode = "mii";
-	interrupt-parent = <&gpio1>;
-	interrupts = <31>, <32>;
-	reset-gpios = <&gpio1 30 GPIO_ACTIVE_LOW>;
-	reg-io-width = <4>;
-	smsc,irq-push-pull;
-};
-- 
2.25.1

