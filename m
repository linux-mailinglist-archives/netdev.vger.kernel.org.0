Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA36A313438
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 15:01:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232307AbhBHOBE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 09:01:04 -0500
Received: from mail.baikalelectronics.com ([87.245.175.226]:57066 "EHLO
        mail.baikalelectronics.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231902AbhBHN5v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 08:57:51 -0500
From:   Serge Semin <Sergey.Semin@baikalelectronics.ru>
To:     Rob Herring <robh+dt@kernel.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hovold <johan@kernel.org>,
        Maxime Ripard <mripard@kernel.org>,
        Joao Pinto <jpinto@synopsys.com>,
        Lars Persson <larper@axis.com>
CC:     Serge Semin <Sergey.Semin@baikalelectronics.ru>,
        Serge Semin <fancer.lancer@gmail.com>,
        Alexey Malahov <Alexey.Malahov@baikalelectronics.ru>,
        Pavel Parkhomenko <Pavel.Parkhomenko@baikalelectronics.ru>,
        Vyacheslav Mitrofanov 
        <Vyacheslav.Mitrofanov@baikalelectronics.ru>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        <netdev@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 07/24] dt-bindings: net: dwmac: Detach Generic DW MAC bindings
Date:   Mon, 8 Feb 2021 16:55:51 +0300
Message-ID: <20210208135609.7685-8-Sergey.Semin@baikalelectronics.ru>
In-Reply-To: <20210208135609.7685-1-Sergey.Semin@baikalelectronics.ru>
References: <20210208135609.7685-1-Sergey.Semin@baikalelectronics.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ClientProxiedBy: MAIL.baikal.int (192.168.51.25) To mail (192.168.51.25)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently the snps,dwmac.yaml DT bindings file is used for both DT nodes
describing generic DW MAC devices and as DT schema with common properties
to be evaluated against a vendor-specific DW MAC IP-cores. Due to such
dual-purpose design the "compatible" property of the common DW MAC schema
needs to contain the vendor-specific strings to successfully pass the
schema evaluation in case if it's referenced from the vendor-specific DT
bindings. That's a bad design from maintainability point of view, since
adding/removing any DW MAC-based device bindings requires the common
schema modification. In order to fix that let's detach the schema which
provides the generic DW MAC DT nodes evaluation into a dedicated DT
bindings file preserving the common DW MAC properties declaration in the
snps,dwmac.yaml file. By doing so we'll still provide a common properties
evaluation for each vendor-specific MAC bindings which refer to the
common bindings file, while the generic DW MAC DT nodes will be checked
against the new snps,dwmac-generic.yaml DT schema.

Signed-off-by: Serge Semin <Sergey.Semin@baikalelectronics.ru>

---

Changelog v2:
- Add a note to the snps,dwmac-generic.yaml bindings file description of
  a requirement to create a new DT bindings file for the vendor-specific
  versions of the DW MAC.
---
 .../bindings/net/snps,dwmac-generic.yaml      | 154 ++++++++++++++++++
 .../devicetree/bindings/net/snps,dwmac.yaml   | 139 +---------------
 2 files changed, 155 insertions(+), 138 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/snps,dwmac-generic.yaml

diff --git a/Documentation/devicetree/bindings/net/snps,dwmac-generic.yaml b/Documentation/devicetree/bindings/net/snps,dwmac-generic.yaml
new file mode 100644
index 000000000000..6c3bf5b2f890
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/snps,dwmac-generic.yaml
@@ -0,0 +1,154 @@
+# SPDX-License-Identifier: GPL-2.0
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/snps,dwmac-generic.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Synopsys DesignWare Generic MAC Device Tree Bindings
+
+maintainers:
+  - Alexandre Torgue <alexandre.torgue@st.com>
+  - Giuseppe Cavallaro <peppe.cavallaro@st.com>
+  - Jose Abreu <joabreu@synopsys.com>
+
+description:
+  The primary purpose of this bindings file is to validate the Generic
+  Synopsys Desginware MAC DT nodes defined in accordance with the select
+  schema. All new vendor-specific versions of the DW *MAC IP-cores must
+  be described in a dedicated DT bindings file.
+
+# Select the DT nodes, which have got compatible strings either as just a
+# single string with IP-core name optionally followed by the IP version or
+# two strings: one with IP-core name plus the IP version, another as just
+# the IP-core name.
+select:
+  properties:
+    compatible:
+      oneOf:
+        - items:
+            - pattern: "^snps,dw(xg)+mac(-[0-9]+\\.[0-9]+a?)?$"
+        - items:
+            - pattern: "^snps,dwmac-[0-9]+\\.[0-9]+a?$"
+            - const: snps,dwmac
+        - items:
+            - pattern: "^snps,dwxgmac-[0-9]+\\.[0-9]+a?$"
+            - const: snps,dwxgmac
+
+  required:
+    - compatible
+
+allOf:
+  - $ref: snps,dwmac.yaml#
+
+properties:
+  compatible:
+    oneOf:
+      - description: Generic Synopsys DW MAC
+        oneOf:
+          - items:
+              - enum:
+                  - snps,dwmac-3.50a
+                  - snps,dwmac-3.610
+                  - snps,dwmac-3.70a
+                  - snps,dwmac-3.710
+                  - snps,dwmac-4.00
+                  - snps,dwmac-4.10a
+                  - snps,dwmac-4.20a
+              - const: snps,dwmac
+          - const: snps,dwmac
+      - description: Generic Synopsys DW xGMAC
+        oneOf:
+          - items:
+              - enum:
+                  - snps,dwxgmac-2.10
+              - const: snps,dwxgmac
+          - const: snps,dwxgmac
+      - description: ST SPEAr SoC Family GMAC
+        deprecated: true
+        const: st,spear600-gmac
+
+  reg:
+    maxItems: 1
+
+unevaluatedProperties: false
+
+examples:
+  - |
+    gmac0: ethernet@e0800000 {
+      compatible = "snps,dwxgmac-2.10", "snps,dwxgmac";
+      reg = <0xe0800000 0x8000>;
+      interrupt-parent = <&vic1>;
+      interrupts = <24 23 22>;
+      interrupt-names = "macirq", "eth_wake_irq", "eth_lpi";
+      mac-address = [000000000000]; /* Filled in by U-Boot */
+      max-frame-size = <3800>;
+      phy-mode = "gmii";
+      snps,multicast-filter-bins = <256>;
+      snps,perfect-filter-entries = <128>;
+      rx-fifo-depth = <16384>;
+      tx-fifo-depth = <16384>;
+      clocks = <&clock>;
+      clock-names = "stmmaceth";
+      snps,axi-config = <&stmmac_axi_setup>;
+      snps,mtl-rx-config = <&mtl_rx_setup>;
+      snps,mtl-tx-config = <&mtl_tx_setup>;
+      mdio0 {
+        #address-cells = <1>;
+        #size-cells = <0>;
+        compatible = "snps,dwmac-mdio";
+        phy1: ethernet-phy@0 {
+          reg = <0>;
+        };
+      };
+    };
+  - |
+    gmac1: ethernet@f8010000 {
+      compatible = "snps,dwmac-4.10a", "snps,dwmac";
+      reg = <0xf8010000 0x4000>;
+      interrupts = <0 98 4>;
+      interrupt-names = "macirq";
+      clock-names = "stmmaceth", "ptp_ref";
+      clocks = <&clock 4>, <&clock 5>;
+      phy-mode = "rgmii";
+      snps,txpbl = <8>;
+      snps,rxpbl = <2>;
+      snps,aal;
+      snps,tso;
+
+      axi-config {
+        snps,wr_osr_lmt = <0xf>;
+        snps,rd_osr_lmt = <0xf>;
+        snps,blen = <256 128 64 32 0 0 0>;
+      };
+
+      mtl-rx-config {
+        snps,rx-queues-to-use = <1>;
+        snps,rx-sched-sp;
+        queue0 {
+          snps,dcb-algorithm;
+          snps,map-to-dma-channel = <0x0>;
+          snps,priority = <0x0>;
+        };
+      };
+
+      mtl-tx-config {
+        snps,tx-queues-to-use = <2>;
+        snps,tx-sched-wrr;
+
+        queue0 {
+          snps,weight = <0x10>;
+          snps,dcb-algorithm;
+          snps,priority = <0x0>;
+        };
+
+        queue1 {
+          snps,avb-algorithm;
+          snps,send_slope = <0x1000>;
+          snps,idle_slope = <0x1000>;
+          snps,high_credit = <0x3E800>;
+          snps,low_credit = <0x1FC18000>;
+          snps,priority = <0x1>;
+        };
+      };
+    };
+...
diff --git a/Documentation/devicetree/bindings/net/snps,dwmac.yaml b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
index 56baf8e6bf17..bdc437b14878 100644
--- a/Documentation/devicetree/bindings/net/snps,dwmac.yaml
+++ b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
@@ -11,31 +11,7 @@ maintainers:
   - Giuseppe Cavallaro <peppe.cavallaro@st.com>
   - Jose Abreu <joabreu@synopsys.com>
 
-# Select every compatible, including the deprecated ones. This way, we
-# will be able to report a warning when we have that compatible, since
-# we will validate the node thanks to the select, but won't report it
-# as a valid value in the compatible property description
-select:
-  properties:
-    compatible:
-      contains:
-        enum:
-          - snps,dwmac
-          - snps,dwmac-3.50a
-          - snps,dwmac-3.610
-          - snps,dwmac-3.70a
-          - snps,dwmac-3.710
-          - snps,dwmac-4.00
-          - snps,dwmac-4.10a
-          - snps,dwmac-4.20a
-          - snps,dwxgmac
-          - snps,dwxgmac-2.10
-
-          # Deprecated
-          - st,spear600-gmac
-
-  required:
-    - compatible
+select: false
 
 allOf:
   - $ref: "ethernet-controller.yaml#"
@@ -62,35 +38,6 @@ allOf:
             MAC HW capability register.
 
 properties:
-
-  # We need to include all the compatibles from schemas that will
-  # include that schemas, otherwise compatible won't validate for
-  # those.
-  compatible:
-    contains:
-      enum:
-        - allwinner,sun7i-a20-gmac
-        - allwinner,sun8i-a83t-emac
-        - allwinner,sun8i-h3-emac
-        - allwinner,sun8i-r40-emac
-        - allwinner,sun8i-v3s-emac
-        - allwinner,sun50i-a64-emac
-        - amlogic,meson6-dwmac
-        - amlogic,meson8b-dwmac
-        - amlogic,meson8m2-dwmac
-        - amlogic,meson-gxbb-dwmac
-        - amlogic,meson-axg-dwmac
-        - snps,dwmac
-        - snps,dwmac-3.50a
-        - snps,dwmac-3.610
-        - snps,dwmac-3.70a
-        - snps,dwmac-3.710
-        - snps,dwmac-4.00
-        - snps,dwmac-4.10a
-        - snps,dwmac-4.20a
-        - snps,dwxgmac
-        - snps,dwxgmac-2.10
-
   reg:
     minItems: 1
     maxItems: 2
@@ -555,88 +502,4 @@ dependencies:
   snps,reset-delay-us: ["snps,reset-gpio"]
 
 additionalProperties: true
-
-examples:
-  - |
-    gmac0: ethernet@e0800000 {
-        compatible = "snps,dwxgmac-2.10", "snps,dwxgmac";
-        reg = <0xe0800000 0x8000>;
-        interrupt-parent = <&vic1>;
-        interrupts = <24 23 22>;
-        interrupt-names = "macirq", "eth_wake_irq", "eth_lpi";
-        mac-address = [000000000000]; /* Filled in by U-Boot */
-        max-frame-size = <3800>;
-        phy-mode = "gmii";
-        snps,multicast-filter-bins = <256>;
-        snps,perfect-filter-entries = <128>;
-        rx-fifo-depth = <16384>;
-        tx-fifo-depth = <16384>;
-        clocks = <&clock>;
-        clock-names = "stmmaceth";
-        snps,axi-config = <&stmmac_axi_setup>;
-        snps,mtl-rx-config = <&mtl_rx_setup>;
-        snps,mtl-tx-config = <&mtl_tx_setup>;
-        mdio0 {
-            #address-cells = <1>;
-            #size-cells = <0>;
-            compatible = "snps,dwmac-mdio";
-            phy1: ethernet-phy@0 {
-                reg = <0>;
-            };
-        };
-    };
-  - |
-    gmac1: ethernet@f8010000 {
-        compatible = "snps,dwmac-4.10a", "snps,dwmac";
-        reg = <0xf8010000 0x4000>;
-        interrupts = <0 98 4>;
-        interrupt-names = "macirq";
-        clock-names = "stmmaceth", "ptp_ref";
-        clocks = <&clock 4>, <&clock 5>;
-        phy-mode = "rgmii";
-        snps,txpbl = <8>;
-        snps,rxpbl = <2>;
-        snps,aal;
-        snps,tso;
-
-        axi-config {
-            snps,wr_osr_lmt = <0xf>;
-            snps,rd_osr_lmt = <0xf>;
-            snps,blen = <256 128 64 32 0 0 0>;
-        };
-
-        mtl-rx-config {
-            snps,rx-queues-to-use = <1>;
-            snps,rx-sched-sp;
-            queue0 {
-               snps,dcb-algorithm;
-               snps,map-to-dma-channel = <0x0>;
-               snps,priority = <0x0>;
-            };
-        };
-
-        mtl-tx-config {
-            snps,tx-queues-to-use = <2>;
-            snps,tx-sched-wrr;
-            queue0 {
-                snps,weight = <0x10>;
-                snps,dcb-algorithm;
-                snps,priority = <0x0>;
-            };
-
-            queue1 {
-                snps,avb-algorithm;
-                snps,send_slope = <0x1000>;
-                snps,idle_slope = <0x1000>;
-                snps,high_credit = <0x3E800>;
-                snps,low_credit = <0xFFC18000>;
-                snps,priority = <0x1>;
-            };
-        };
-    };
-
-# FIXME: We should set it, but it would report all the generic
-# properties as additional properties.
-# additionalProperties: false
-
 ...
-- 
2.29.2

