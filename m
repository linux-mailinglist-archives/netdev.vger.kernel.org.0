Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7DB4279CF
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 11:57:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730353AbfEWJ50 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 05:57:26 -0400
Received: from relay1-d.mail.gandi.net ([217.70.183.193]:55893 "EHLO
        relay1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727466AbfEWJ50 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 05:57:26 -0400
X-Originating-IP: 90.88.22.185
Received: from localhost (aaubervilliers-681-1-80-185.w90-88.abo.wanadoo.fr [90.88.22.185])
        (Authenticated sender: maxime.ripard@bootlin.com)
        by relay1-d.mail.gandi.net (Postfix) with ESMTPSA id 741AD240014;
        Thu, 23 May 2019 09:56:57 +0000 (UTC)
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
Subject: [PATCH 1/8] dt-bindings: net: Add YAML schemas for the generic Ethernet options
Date:   Thu, 23 May 2019 11:56:44 +0200
Message-Id: <74d98cc3c744d53710c841381efd41cf5f15e656.1558605170.git-series.maxime.ripard@bootlin.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Ethernet controllers have a good number of generic options that can be
needed in a device tree. Add a YAML schemas for those.

Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
---
 Documentation/devicetree/bindings/net/ethernet-controller.yaml | 197 +++++++-
 Documentation/devicetree/bindings/net/ethernet.txt             |  68 +--
 Documentation/devicetree/bindings/net/fixed-link.txt           |  55 +--
 3 files changed, 199 insertions(+), 121 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/ethernet-controller.yaml

diff --git a/Documentation/devicetree/bindings/net/ethernet-controller.yaml b/Documentation/devicetree/bindings/net/ethernet-controller.yaml
new file mode 100644
index 000000000000..1c6e9e755481
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/ethernet-controller.yaml
@@ -0,0 +1,197 @@
+# SPDX-License-Identifier: GPL-2.0
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/ethernet-controller.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Ethernet Controller Generic Binding
+
+maintainers:
+  - David S. Miller <davem@davemloft.net>
+
+properties:
+  $nodename:
+    pattern: "^ethernet(@.*)?$"
+
+  local-mac-address:
+    allOf:
+      - $ref: /schemas/types.yaml#definitions/uint8-array
+      - minItems: 6
+        maxItems: 6
+    description:
+      Specifies the MAC address that was assigned to the network device.
+
+  mac-address:
+    allOf:
+      - $ref: /schemas/types.yaml#definitions/uint8-array
+      - minItems: 6
+        maxItems: 6
+    description:
+      Specifies the MAC address that was last used by the boot
+      program; should be used in cases where the MAC address assigned
+      to the device by the boot program is different from the
+      local-mac-address property.
+
+  max-frame-size:
+    $ref: /schemas/types.yaml#definitions/uint32
+    description:
+      Maximum transfer unit (IEEE defined MTU), rather than the
+      maximum frame size (there\'s contradiction in the Devicetree
+      Specification).
+
+  max-speed:
+    $ref: /schemas/types.yaml#definitions/uint32
+    description:
+      Specifies maximum speed in Mbit/s supported by the device.
+
+  nvmem-cells:
+    maxItems: 1
+    description:
+      Reference to an nvmem node for the MAC address
+
+  nvmem-cells-names:
+    const: mac-address
+
+  phy-connection-type:
+    description:
+      Operation mode of the PHY interface
+    oneOf:
+      - const: internal
+        description:
+          there is not a standard bus between the MAC and the PHY,
+          something proprietary is being used to embed the PHY in the
+          MAC.
+      - const: mii
+      - const: gmii
+      - const: sgmii
+      - const: qsgmii
+      - const: tbi
+      - const: rev-mii
+      - const: rmii
+      - const: rgmii
+        description:
+          RX and TX delays are added by the MAC when required
+      - const: rgmii-id
+        description:
+          RGMII with internal RX and TX delays provided by the PHY,
+          the MAC should not add the RX or TX delays in this case
+      - const: rgmii-rxid
+        description:
+          RGMII with internal RX delay provided by the PHY, the MAC
+          should not add an RX delay in this case
+      - const: rgmii-txid
+        description:
+          RGMII with internal TX delay provided by the PHY, the MAC
+          should not add an TX delay in this case
+      - const: rtbi
+      - const: smii
+      - const: xgmii
+      - const: trgmii
+      - const: 1000base-x
+      - const: 2500base-x
+      - const: rxaui
+      - const: xaui
+      - const: 10gbase-kr
+        description:
+          10GBASE-KR, XFI, SFI
+
+  phy-mode:
+    $ref: "#/properties/phy-connection-type"
+    description:
+      Deprecated in favor of phy-connection-type
+
+  phy-handle:
+    $ref: /schemas/types.yaml#definitions/phandle
+    description:
+      Specifies a reference to a node representing a PHY device.
+
+  phy:
+    $ref: "#/properties/phy-handle"
+    description:
+      Deprecated in favor of phy-handle
+
+  phy-device:
+    $ref: "#/properties/phy-handle"
+    description:
+      Deprecated in favor of phy-handle
+
+  rx-fifo-depth:
+    $ref: /schemas/types.yaml#definitions/uint32
+    description:
+      The size of the controller\'s receive fifo in bytes. This is used
+      for components that can have configurable receive fifo sizes,
+      and is useful for determining certain configuration settings
+      such as flow control thresholds.
+
+  tx-fifo-depth:
+    $ref: /schemas/types.yaml#definitions/uint32
+    description:
+      The size of the controller\'s transmit fifo in bytes. This
+      is used for components that can have configurable fifo sizes.
+
+  managed:
+    allOf:
+      - $ref: /schemas/types.yaml#definitions/string
+      - default: auto
+        enum:
+          - auto
+          - in-band-status
+    description:
+      Specifies the PHY management type. If auto is set and fixed-link
+      is not specified, it uses MDIO for management.
+
+  fixed-link:
+    allOf:
+      - if:
+          type: array
+        then:
+          minItems: 1
+          maxItems: 1
+          items:
+            type: array
+            minItems: 5
+            maxItems: 5
+          description:
+            An array of 5 cells, with the following accepted values
+              - At index 0, the emulated PHY ID, choose any but but
+                unique to the all specified fixed-links, from 0 to 31
+              - at index 1, duplex configuration with 0 for half duplex
+                or 1 for full duplex
+              - at index 2, link speed in Mbits/sec, accepted values are
+                10, 100 and 1000
+              - at index 3, pause configuration with 0 for no pause, 1
+                for pause
+              - at index 4, asymmetric pause configuration with 0 for no
+                asymmetric pause, 1 for asymmetric pause
+
+
+      - if:
+          type: object
+        then:
+          properties:
+            speed:
+              allOf:
+                - $ref: /schemas/types.yaml#definitions/uint32
+                - enum: [10, 100, 1000]
+              description:
+                Link speed.
+
+            full-duplex:
+              $ref: /schemas/types.yaml#definitions/flag
+              description:
+                Indicates that full-duplex is used. When absent, half
+                duplex is assumed.
+
+            asym-pause:
+              $ref: /schemas/types.yaml#definitions/flag
+              description:
+                Indicates that asym_pause should be enabled.
+
+            link-gpios:
+              description:
+                GPIO to determine if the link is up
+
+          required:
+            - speed
+
+...
diff --git a/Documentation/devicetree/bindings/net/ethernet.txt b/Documentation/devicetree/bindings/net/ethernet.txt
index e88c3641d613..5df413d01be2 100644
--- a/Documentation/devicetree/bindings/net/ethernet.txt
+++ b/Documentation/devicetree/bindings/net/ethernet.txt
@@ -1,67 +1 @@
-The following properties are common to the Ethernet controllers:
-
-NOTE: All 'phy*' properties documented below are Ethernet specific. For the
-generic PHY 'phys' property, see
-Documentation/devicetree/bindings/phy/phy-bindings.txt.
-
-- mac-address: array of 6 bytes, specifies the MAC address that was last used by
-  the boot program; should be used in cases where the MAC address assigned to
-  the device by the boot program is different from the "local-mac-address"
-  property;
-- local-mac-address: array of 6 bytes, specifies the MAC address that was
-  assigned to the network device;
-- nvmem-cells: phandle, reference to an nvmem node for the MAC address
-- nvmem-cell-names: string, should be "mac-address" if nvmem is to be used
-- max-speed: number, specifies maximum speed in Mbit/s supported by the device;
-- max-frame-size: number, maximum transfer unit (IEEE defined MTU), rather than
-  the maximum frame size (there's contradiction in the Devicetree
-  Specification).
-- phy-mode: string, operation mode of the PHY interface. This is now a de-facto
-  standard property; supported values are:
-  * "internal" (Internal means there is not a standard bus between the MAC and
-     the PHY, something proprietary is being used to embed the PHY in the MAC.)
-  * "mii"
-  * "gmii"
-  * "sgmii"
-  * "qsgmii"
-  * "tbi"
-  * "rev-mii"
-  * "rmii"
-  * "rgmii" (RX and TX delays are added by the MAC when required)
-  * "rgmii-id" (RGMII with internal RX and TX delays provided by the PHY, the
-     MAC should not add the RX or TX delays in this case)
-  * "rgmii-rxid" (RGMII with internal RX delay provided by the PHY, the MAC
-     should not add an RX delay in this case)
-  * "rgmii-txid" (RGMII with internal TX delay provided by the PHY, the MAC
-     should not add an TX delay in this case)
-  * "rtbi"
-  * "smii"
-  * "xgmii"
-  * "trgmii"
-  * "1000base-x",
-  * "2500base-x",
-  * "rxaui"
-  * "xaui"
-  * "10gbase-kr" (10GBASE-KR, XFI, SFI)
-- phy-connection-type: the same as "phy-mode" property but described in the
-  Devicetree Specification;
-- phy-handle: phandle, specifies a reference to a node representing a PHY
-  device; this property is described in the Devicetree Specification and so
-  preferred;
-- phy: the same as "phy-handle" property, not recommended for new bindings.
-- phy-device: the same as "phy-handle" property, not recommended for new
-  bindings.
-- rx-fifo-depth: the size of the controller's receive fifo in bytes. This
-  is used for components that can have configurable receive fifo sizes,
-  and is useful for determining certain configuration settings such as
-  flow control thresholds.
-- tx-fifo-depth: the size of the controller's transmit fifo in bytes. This
-  is used for components that can have configurable fifo sizes.
-- managed: string, specifies the PHY management type. Supported values are:
-  "auto", "in-band-status". "auto" is the default, it usess MDIO for
-  management if fixed-link is not specified.
-
-Child nodes of the Ethernet controller are typically the individual PHY devices
-connected via the MDIO bus (sometimes the MDIO bus controller is separate).
-They are described in the phy.txt file in this same directory.
-For non-MDIO PHY management see fixed-link.txt.
+This file has moved to ethernet-controller.yaml.
diff --git a/Documentation/devicetree/bindings/net/fixed-link.txt b/Documentation/devicetree/bindings/net/fixed-link.txt
index ec5d889fe3d8..5df413d01be2 100644
--- a/Documentation/devicetree/bindings/net/fixed-link.txt
+++ b/Documentation/devicetree/bindings/net/fixed-link.txt
@@ -1,54 +1 @@
-Fixed link Device Tree binding
-------------------------------
-
-Some Ethernet MACs have a "fixed link", and are not connected to a
-normal MDIO-managed PHY device. For those situations, a Device Tree
-binding allows to describe a "fixed link".
-
-Such a fixed link situation is described by creating a 'fixed-link'
-sub-node of the Ethernet MAC device node, with the following
-properties:
-
-* 'speed' (integer, mandatory), to indicate the link speed. Accepted
-  values are 10, 100 and 1000
-* 'full-duplex' (boolean, optional), to indicate that full duplex is
-  used. When absent, half duplex is assumed.
-* 'pause' (boolean, optional), to indicate that pause should be
-  enabled.
-* 'asym-pause' (boolean, optional), to indicate that asym_pause should
-  be enabled.
-* 'link-gpios' ('gpio-list', optional), to indicate if a gpio can be read
-  to determine if the link is up.
-
-Old, deprecated 'fixed-link' binding:
-
-* A 'fixed-link' property in the Ethernet MAC node, with 5 cells, of the
-  form <a b c d e> with the following accepted values:
-  - a: emulated PHY ID, choose any but but unique to the all specified
-    fixed-links, from 0 to 31
-  - b: duplex configuration: 0 for half duplex, 1 for full duplex
-  - c: link speed in Mbits/sec, accepted values are: 10, 100 and 1000
-  - d: pause configuration: 0 for no pause, 1 for pause
-  - e: asymmetric pause configuration: 0 for no asymmetric pause, 1 for
-    asymmetric pause
-
-Examples:
-
-ethernet@0 {
-	...
-	fixed-link {
-	      speed = <1000>;
-	      full-duplex;
-	};
-	...
-};
-
-ethernet@1 {
-	...
-	fixed-link {
-	      speed = <1000>;
-	      pause;
-	      link-gpios = <&gpio0 12 GPIO_ACTIVE_HIGH>;
-	};
-	...
-};
+This file has moved to ethernet-controller.yaml.

base-commit: 47e4b09372425c32ff2b1e699d9f059a16056b3c
-- 
git-series 0.9.1
