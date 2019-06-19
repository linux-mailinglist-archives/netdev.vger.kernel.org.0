Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47B9D4B53B
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 11:47:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731517AbfFSJrp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 05:47:45 -0400
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:42919 "EHLO
        relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726958AbfFSJro (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jun 2019 05:47:44 -0400
X-Originating-IP: 90.88.23.150
Received: from localhost (aaubervilliers-681-1-81-150.w90-88.abo.wanadoo.fr [90.88.23.150])
        (Authenticated sender: maxime.ripard@bootlin.com)
        by relay5-d.mail.gandi.net (Postfix) with ESMTPSA id 937AA1C0012;
        Wed, 19 Jun 2019 09:47:39 +0000 (UTC)
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
        =?UTF-8?q?Antoine=20T=C3=A9nart?= <antoine.tenart@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Rob Herring <robh@kernel.org>
Subject: [PATCH v3 02/16] dt-bindings: net: Add a YAML schemas for the generic PHY options
Date:   Wed, 19 Jun 2019 11:47:11 +0200
Message-Id: <4ad9bb186b94b9c2c3ea44296ac8710db5636893.1560937626.git-series.maxime.ripard@bootlin.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <27aeb33cf5b896900d5d11bd6957eda268014f0c.1560937626.git-series.maxime.ripard@bootlin.com>
References: <27aeb33cf5b896900d5d11bd6957eda268014f0c.1560937626.git-series.maxime.ripard@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The networking PHYs have a number of available device tree properties that
can be used in their device tree node. Add a YAML schemas for those.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Rob Herring <robh@kernel.org>
Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>

---

Changes from v1:
  - Add missing compatible options
  - add missing phy speeds
  - Fix the maintainers entry
  - Add a custom select clause to make it validate all phy nodes, and not
    just the ones with a compatible
---
 Documentation/devicetree/bindings/net/ethernet-phy.yaml | 179 +++++++++-
 Documentation/devicetree/bindings/net/phy.txt           |  80 +----
 2 files changed, 180 insertions(+), 79 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/ethernet-phy.yaml

diff --git a/Documentation/devicetree/bindings/net/ethernet-phy.yaml b/Documentation/devicetree/bindings/net/ethernet-phy.yaml
new file mode 100644
index 000000000000..81d2016d7232
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/ethernet-phy.yaml
@@ -0,0 +1,179 @@
+# SPDX-License-Identifier: GPL-2.0
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/ethernet-phy.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Ethernet PHY Generic Binding
+
+maintainers:
+  - Andrew Lunn <andrew@lunn.ch>
+  - Florian Fainelli <f.fainelli@gmail.com>
+  - Heiner Kallweit <hkallweit1@gmail.com>
+
+# The dt-schema tools will generate a select statement first by using
+# the compatible, and second by using the node name if any. In our
+# case, the node name is the one we want to match on, while the
+# compatible is optional.
+select:
+  properties:
+    $nodename:
+      pattern: "^ethernet-phy(@[a-f0-9]+)?$"
+
+  required:
+    - $nodename
+
+properties:
+  $nodename:
+    pattern: "^ethernet-phy(@[a-f0-9]+)?$"
+
+  compatible:
+    oneOf:
+      - const: ethernet-phy-ieee802.3-c22
+        description: PHYs that implement IEEE802.3 clause 22
+      - const: ethernet-phy-ieee802.3-c45
+        description: PHYs that implement IEEE802.3 clause 45
+      - pattern: "^ethernet-phy-id[a-f0-9]{4}\\.[a-f0-9]{4}$"
+        description:
+          If the PHY reports an incorrect ID (or none at all) then the
+          compatible list may contain an entry with the correct PHY ID
+          in the above form.
+          The first group of digits is the 16 bit Phy Identifier 1
+          register, this is the chip vendor OUI bits 3:18. The
+          second group of digits is the Phy Identifier 2 register,
+          this is the chip vendor OUI bits 19:24, followed by 10
+          bits of a vendor specific ID.
+      - items:
+          - pattern: "^ethernet-phy-id[a-f0-9]{4}\\.[a-f0-9]{4}$"
+          - const: ethernet-phy-ieee802.3-c45
+
+  reg:
+    maxItems: 1
+    minimum: 0
+    maximum: 31
+    description:
+      The ID number for the PHY.
+
+  interrupts:
+    maxItems: 1
+
+  max-speed:
+    enum:
+      - 10
+      - 100
+      - 1000
+      - 2500
+      - 5000
+      - 10000
+      - 20000
+      - 25000
+      - 40000
+      - 50000
+      - 56000
+      - 100000
+      - 200000
+    description:
+      Maximum PHY supported speed in Mbits / seconds.
+
+  broken-turn-around:
+    $ref: /schemas/types.yaml#definitions/flag
+    description:
+      If set, indicates the PHY device does not correctly release
+      the turn around line low at the end of a MDIO transaction.
+
+  enet-phy-lane-swap:
+    $ref: /schemas/types.yaml#definitions/flag
+    description:
+      If set, indicates the PHY will swap the TX/RX lanes to
+      compensate for the board being designed with the lanes
+      swapped.
+
+  eee-broken-100tx:
+    $ref: /schemas/types.yaml#definitions/flag
+    description:
+      Mark the corresponding energy efficient ethernet mode as
+      broken and request the ethernet to stop advertising it.
+
+  eee-broken-1000t:
+    $ref: /schemas/types.yaml#definitions/flag
+    description:
+      Mark the corresponding energy efficient ethernet mode as
+      broken and request the ethernet to stop advertising it.
+
+  eee-broken-10gt:
+    $ref: /schemas/types.yaml#definitions/flag
+    description:
+      Mark the corresponding energy efficient ethernet mode as
+      broken and request the ethernet to stop advertising it.
+
+  eee-broken-1000kx:
+    $ref: /schemas/types.yaml#definitions/flag
+    description:
+      Mark the corresponding energy efficient ethernet mode as
+      broken and request the ethernet to stop advertising it.
+
+  eee-broken-10gkx4:
+    $ref: /schemas/types.yaml#definitions/flag
+    description:
+      Mark the corresponding energy efficient ethernet mode as
+      broken and request the ethernet to stop advertising it.
+
+  eee-broken-10gkr:
+    $ref: /schemas/types.yaml#definitions/flag
+    description:
+      Mark the corresponding energy efficient ethernet mode as
+      broken and request the ethernet to stop advertising it.
+
+  phy-is-integrated:
+    $ref: /schemas/types.yaml#definitions/flag
+    description:
+      If set, indicates that the PHY is integrated into the same
+      physical package as the Ethernet MAC. If needed, muxers
+      should be configured to ensure the integrated PHY is
+      used. The absence of this property indicates the muxers
+      should be configured so that the external PHY is used.
+
+  resets:
+    maxItems: 1
+
+  reset-names:
+    const: phy
+
+  reset-gpios:
+    maxItems: 1
+    description:
+      The GPIO phandle and specifier for the PHY reset signal.
+
+  reset-assert-us:
+    description:
+      Delay after the reset was asserted in microseconds. If this
+      property is missing the delay will be skipped.
+
+  reset-deassert-us:
+    description:
+      Delay after the reset was deasserted in microseconds. If
+      this property is missing the delay will be skipped.
+
+required:
+  - reg
+  - interrupts
+
+examples:
+  - |
+    ethernet {
+        #address-cells = <1>;
+        #size-cells = <0>;
+
+        ethernet-phy@0 {
+            compatible = "ethernet-phy-id0141.0e90", "ethernet-phy-ieee802.3-c22";
+            interrupt-parent = <&PIC>;
+            interrupts = <35 1>;
+            reg = <0>;
+
+            resets = <&rst 8>;
+            reset-names = "phy";
+            reset-gpios = <&gpio1 4 1>;
+            reset-assert-us = <1000>;
+            reset-deassert-us = <2000>;
+        };
+    };
diff --git a/Documentation/devicetree/bindings/net/phy.txt b/Documentation/devicetree/bindings/net/phy.txt
index 9b9e5b1765dd..2399ee60caed 100644
--- a/Documentation/devicetree/bindings/net/phy.txt
+++ b/Documentation/devicetree/bindings/net/phy.txt
@@ -1,79 +1 @@
-PHY nodes
-
-Required properties:
-
- - interrupts : interrupt specifier for the sole interrupt.
- - reg : The ID number for the phy, usually a small integer
-
-Optional Properties:
-
-- compatible: Compatible list, may contain
-  "ethernet-phy-ieee802.3-c22" or "ethernet-phy-ieee802.3-c45" for
-  PHYs that implement IEEE802.3 clause 22 or IEEE802.3 clause 45
-  specifications. If neither of these are specified, the default is to
-  assume clause 22.
-
-  If the PHY reports an incorrect ID (or none at all) then the
-  "compatible" list may contain an entry with the correct PHY ID in the
-  form: "ethernet-phy-idAAAA.BBBB" where
-     AAAA - The value of the 16 bit Phy Identifier 1 register as
-            4 hex digits. This is the chip vendor OUI bits 3:18
-     BBBB - The value of the 16 bit Phy Identifier 2 register as
-            4 hex digits. This is the chip vendor OUI bits 19:24,
-            followed by 10 bits of a vendor specific ID.
-
-  The compatible list should not contain other values than those
-  listed here.
-
-- max-speed: Maximum PHY supported speed (10, 100, 1000...)
-
-- broken-turn-around: If set, indicates the PHY device does not correctly
-  release the turn around line low at the end of a MDIO transaction.
-
-- enet-phy-lane-swap: If set, indicates the PHY will swap the TX/RX lanes to
-  compensate for the board being designed with the lanes swapped.
-
-- enet-phy-lane-no-swap: If set, indicates that PHY will disable swap of the
-  TX/RX lanes. This property allows the PHY to work correcly after e.g. wrong
-  bootstrap configuration caused by issues in PCB layout design.
-
-- eee-broken-100tx:
-- eee-broken-1000t:
-- eee-broken-10gt:
-- eee-broken-1000kx:
-- eee-broken-10gkx4:
-- eee-broken-10gkr:
-  Mark the corresponding energy efficient ethernet mode as broken and
-  request the ethernet to stop advertising it.
-
-- phy-is-integrated: If set, indicates that the PHY is integrated into the same
-  physical package as the Ethernet MAC. If needed, muxers should be configured
-  to ensure the integrated PHY is used. The absence of this property indicates
-  the muxers should be configured so that the external PHY is used.
-
-- resets: The reset-controller phandle and specifier for the PHY reset signal.
-
-- reset-names: Must be "phy" for the PHY reset signal.
-
-- reset-gpios: The GPIO phandle and specifier for the PHY reset signal.
-
-- reset-assert-us: Delay after the reset was asserted in microseconds.
-  If this property is missing the delay will be skipped.
-
-- reset-deassert-us: Delay after the reset was deasserted in microseconds.
-  If this property is missing the delay will be skipped.
-
-Example:
-
-ethernet-phy@0 {
-	compatible = "ethernet-phy-id0141.0e90", "ethernet-phy-ieee802.3-c22";
-	interrupt-parent = <&PIC>;
-	interrupts = <35 IRQ_TYPE_EDGE_RISING>;
-	reg = <0>;
-
-	resets = <&rst 8>;
-	reset-names = "phy";
-	reset-gpios = <&gpio1 4 GPIO_ACTIVE_LOW>;
-	reset-assert-us = <1000>;
-	reset-deassert-us = <2000>;
-};
+This file has moved to ethernet-phy.yaml.
-- 
git-series 0.9.1
