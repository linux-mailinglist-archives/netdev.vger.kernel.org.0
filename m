Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC9AC313415
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 14:58:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231929AbhBHN6A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 08:58:00 -0500
Received: from mail.baikalelectronics.com ([87.245.175.226]:56802 "EHLO
        mail.baikalelectronics.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231579AbhBHN5C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 08:57:02 -0500
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
Subject: [PATCH v2 04/24] dt-bindings: net: dwmac: Refactor snps,*-config properties
Date:   Mon, 8 Feb 2021 16:55:48 +0300
Message-ID: <20210208135609.7685-5-Sergey.Semin@baikalelectronics.ru>
In-Reply-To: <20210208135609.7685-1-Sergey.Semin@baikalelectronics.ru>
References: <20210208135609.7685-1-Sergey.Semin@baikalelectronics.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ClientProxiedBy: MAIL.baikal.int (192.168.51.25) To mail (192.168.51.25)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently the "snps,axi-config", "snps,mtl-rx-config" and
"snps,mtl-tx-config" properties are declared as a single phandle reference
to a node with corresponding parameters defined. That's not good for
several reasons. First of all scattering around a device tree some
particular device-specific configs with no visual relation to that device
isn't suitable from maintainability point of view. That leads to a
disturbed representation of the actual device tree mixing actual device
nodes and some vendor-specific configs. Secondly using the same configs
set for several device nodes doesn't represent well the devices structure,
since the interfaces these configs describe in hardware belong to
different devices and may actually differ. In the later case having the
configs node separated from the corresponding device nodes gets to be
even unjustified.

So instead of having a separate DW *MAC configs nodes we suggest to
define them as sub-nodes of the device nodes, which interfaces they
actually describe. By doing so we'll make the DW *MAC nodes visually
correct describing all the aspects of the IP-core configuration. Thus
we'll be able to describe the configs sub-nodes bindings right in the
snps,dwmac.yaml file.

Note the former "snps,axi-config", "snps,mtl-rx-config" and
"snps,mtl-tx-config" properties have been marked as deprecated in favor of
the added by this commit "axi-config", "mtl-rx-config" and "mtl-tx-config"
sub-nodes respectively.

Signed-off-by: Serge Semin <Sergey.Semin@baikalelectronics.ru>

---

Note this change will work only if DT-schema tool is fixed like this:

--- a/meta-schemas/nodes.yaml	2021-02-08 14:20:56.732447780 +0300
+++ b/meta-schemas/nodes.yaml	2021-02-08 14:21:00.736492245 +0300
@@ -22,6 +22,7 @@
     - unevaluatedProperties
     - deprecated
     - required
+    - not
     - allOf
     - anyOf
     - oneOf

So a property with name "not" would be allowed and the "not-required"
pattern would work.

Changelog v2:
- Add the new sub-nodes "axi-config", "mtl-rx-config" and "mtl-tx-config"
  describing the nodes now deprecated properties were supposed to
  refer to.
- Fix invalid identation in the "snps,route-*" property settings.
- Use correct syntax of the JSON pointers, so the later would begin
  with a '/' after the '#'.
---
 .../devicetree/bindings/net/snps,dwmac.yaml   | 389 +++++++++++++-----
 1 file changed, 297 insertions(+), 92 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/snps,dwmac.yaml b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
index 03d58bf9965f..4dda9ffa822c 100644
--- a/Documentation/devicetree/bindings/net/snps,dwmac.yaml
+++ b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
@@ -150,73 +150,264 @@ properties:
       in a different mode than the PHY in order to function.
 
   snps,axi-config:
+    deprecated: true
     $ref: /schemas/types.yaml#/definitions/phandle
     description:
-      AXI BUS Mode parameters. Phandle to a node that can contain the
-      following properties
-        * snps,lpi_en, enable Low Power Interface
-        * snps,xit_frm, unlock on WoL
-        * snps,wr_osr_lmt, max write outstanding req. limit
-        * snps,rd_osr_lmt, max read outstanding req. limit
-        * snps,kbbe, do not cross 1KiB boundary.
-        * snps,blen, this is a vector of supported burst length.
-        * snps,fb, fixed-burst
-        * snps,mb, mixed-burst
-        * snps,rb, rebuild INCRx Burst
+      AXI BUS Mode parameters. Phandle to a node that contains the properties
+      described in the 'axi-config' sub-node.
+
+  axi-config:
+    type: object
+    description: AXI BUS Mode parameters
+
+    properties:
+      snps,lpi_en:
+        $ref: /schemas/types.yaml#/definitions/flag
+        description: Enable Low Power Interface
+
+      snps,xit_frm:
+        $ref: /schemas/types.yaml#/definitions/flag
+        description: Unlock on WoL
+
+      snps,wr_osr_lmt:
+        $ref: /schemas/types.yaml#/definitions/uint32
+        description: Max write outstanding req. limit
+        default: 1
+        minimum: 0
+        maximum: 15
+
+      snps,rd_osr_lmt:
+        $ref: /schemas/types.yaml#/definitions/uint32
+        description: Max read outstanding req. limit
+        default: 1
+        minimum: 0
+        maximum: 15
+
+      snps,kbbe:
+        $ref: /schemas/types.yaml#/definitions/flag
+        description: Do not cross 1KiB boundary
+
+      snps,blen:
+        $ref: /schemas/types.yaml#/definitions/uint32-array
+        description: A vector of supported burst lengths
+        minItems: 7
+        maxItems: 7
+        items:
+          enum: [256, 128, 64, 32, 16, 8, 4, 0]
+
+      snps,fb:
+        $ref: /schemas/types.yaml#/definitions/flag
+        description: Fixed-burst
+
+      snps,mb:
+        $ref: /schemas/types.yaml#/definitions/flag
+        description: Mixed-burst
+
+      snps,rb:
+        $ref: /schemas/types.yaml#/definitions/flag
+        description: Rebuild INCRx Burst
+
+    additionalProperties: false
 
   snps,mtl-rx-config:
+    deprecated: true
     $ref: /schemas/types.yaml#/definitions/phandle
     description:
-      Multiple RX Queues parameters. Phandle to a node that can
-      contain the following properties
-        * snps,rx-queues-to-use, number of RX queues to be used in the
-          driver
-        * Choose one of these RX scheduling algorithms
-          * snps,rx-sched-sp, Strict priority
-          * snps,rx-sched-wsp, Weighted Strict priority
-        * For each RX queue
-          * Choose one of these modes
-            * snps,dcb-algorithm, Queue to be enabled as DCB
-            * snps,avb-algorithm, Queue to be enabled as AVB
-          * snps,map-to-dma-channel, Channel to map
-          * Specifiy specific packet routing
-            * snps,route-avcp, AV Untagged Control packets
-            * snps,route-ptp, PTP Packets
-            * snps,route-dcbcp, DCB Control Packets
-            * snps,route-up, Untagged Packets
-            * snps,route-multi-broad, Multicast & Broadcast Packets
-          * snps,priority, bitmask of the tagged frames priorities assigned to
-            the queue
+      Multiple RX Queues parameters. Phandle to a node that contains the
+      properties described in the 'mtl-rx-config' sub-node.
+
+  mtl-rx-config:
+    type: object
+    description: Multiple RX Queues parameters
+
+    properties:
+      snps,rx-queues-to-use:
+        $ref: /schemas/types.yaml#/definitions/uint32
+        description: Number of RX queues to be used in the driver
+        default: 1
+        minimum: 1
+
+    patternProperties:
+      "^snps,rx-sched-(sp|wsp)$":
+        $ref: /schemas/types.yaml#/definitions/flag
+        description: Strict/Weighted Strict RX scheduling priority
+
+      "^queue[0-9]$":
+        type: object
+        description: Each RX Queue parameters
+
+        properties:
+          snps,map-to-dma-channel:
+            $ref: /schemas/types.yaml#/definitions/uint32
+            description: DMA channel to map
+
+          snps,priority:
+            $ref: /schemas/types.yaml#/definitions/uint32
+            description: RX queue priority
+            minimum: 0
+            maximum: 15
+
+        patternProperties:
+          "^snps,(dcb|avb)-algorithm$":
+            $ref: /schemas/types.yaml#/definitions/flag
+            description: Enable Queue as DCB/AVB
+
+          "^snps,route-(avcp|ptp|dcbcp|up|multi-broad)$":
+            $ref: /schemas/types.yaml#/definitions/flag
+            description:
+              AV Untagged/PTP/DCB Control/Untagged/Multicast & Broadcast
+              packets routing respectively.
+
+        additionalProperties: false
+
+        # Choose only one of the Queue modes and the packets routing
+        allOf:
+          - not:
+              required:
+                - snps,dcb-algorithm
+                - snps,avb-algorithm
+          - oneOf:
+              - required:
+                  - snps,route-avcp
+              - required:
+                  - snps,route-ptp
+              - required:
+                  - snps,route-dcbcp
+              - required:
+                  - snps,route-up
+              - required:
+                  - snps,route-multi-broad
+              - not:
+                  anyOf:
+                    - required:
+                        - snps,route-avcp
+                    - required:
+                        - snps,route-ptp
+                    - required:
+                        - snps,route-dcbcp
+                    - required:
+                        - snps,route-up
+                    - required:
+                        - snps,route-multi-broad
+
+    additionalProperties: false
+
+    # Choose one of the RX scheduling algorithms
+    not:
+      required:
+        - snps,rx-sched-sp
+        - snps,rx-sched-wsp
 
   snps,mtl-tx-config:
+    deprecated: true
     $ref: /schemas/types.yaml#/definitions/phandle
     description:
-      Multiple TX Queues parameters. Phandle to a node that can
-      contain the following properties
-        * snps,tx-queues-to-use, number of TX queues to be used in the
-          driver
-        * Choose one of these TX scheduling algorithms
-          * snps,tx-sched-wrr, Weighted Round Robin
-          * snps,tx-sched-wfq, Weighted Fair Queuing
-          * snps,tx-sched-dwrr, Deficit Weighted Round Robin
-          * snps,tx-sched-sp, Strict priority
-        * For each TX queue
-          * snps,weight, TX queue weight (if using a DCB weight
-            algorithm)
-          * Choose one of these modes
-            * snps,dcb-algorithm, TX queue will be working in DCB
-            * snps,avb-algorithm, TX queue will be working in AVB
-              [Attention] Queue 0 is reserved for legacy traffic
-                          and so no AVB is available in this queue.
-          * Configure Credit Base Shaper (if AVB Mode selected)
-            * snps,send_slope, enable Low Power Interface
-            * snps,idle_slope, unlock on WoL
-            * snps,high_credit, max write outstanding req. limit
-            * snps,low_credit, max read outstanding req. limit
-          * snps,priority, bitmask of the priorities assigned to the queue.
-            When a PFC frame is received with priorities matching the bitmask,
-            the queue is blocked from transmitting for the pause time specified
-            in the PFC frame.
+      Multiple TX Queues parameters. Phandle to a node that contains the
+      properties described in the 'mtl-tx-config' sub-node.
+
+  mtl-tx-config:
+    type: object
+    description: Multiple TX Queues parameters
+
+    properties:
+      snps,tx-queues-to-use:
+        $ref: /schemas/types.yaml#/definitions/uint32
+        description: Number of TX queues to be used in the driver
+        default: 1
+        minimum: 1
+
+    patternProperties:
+      "^snps,tx-sched-(wrr|wfq|dwrr|sp)$":
+        $ref: /schemas/types.yaml#/definitions/flag
+        description:
+          Weighted Round Robin, Weighted Fair Queuing,
+          Deficit Weighted Round Robin or Strict TX scheduling priority.
+
+      "^queue[0-9]$":
+        type: object
+        description: Each TX Queue parameters
+
+        properties:
+          snps,priority:
+            $ref: /schemas/types.yaml#/definitions/uint32
+            description: TX queue priority
+            minimum: 0
+            maximum: 15
+
+          snps,weight:
+            $ref: /schemas/types.yaml#/definitions/uint32
+            description: TX queue weight (if using a DCB weight algorithm)
+            minimum: 0
+            maximum: 0x1FFFFF
+
+          snps,send_slope:
+            $ref: /schemas/types.yaml#/definitions/uint32
+            description: Enable Low Power Interface
+            minimum: 0
+            maximum: 0x3FFF
+
+          snps,idle_slope:
+            $ref: /schemas/types.yaml#/definitions/uint32
+            description: Unlock on WoL
+            minimum: 0
+            maximum: 0x1FFFFF
+
+          snps,high_credit:
+            $ref: /schemas/types.yaml#/definitions/uint32
+            description: Max write outstanding req. limit
+            minimum: 0
+            maximum: 0x1FFFFFFF
+
+          snps,low_credit:
+            $ref: /schemas/types.yaml#/definitions/uint32
+            description: Max read outstanding req. limit
+            minimum: 0
+            maximum: 0x1FFFFFFF
+
+        patternProperties:
+          "^snps,(dcb|avb)-algorithm$":
+            $ref: /schemas/types.yaml#/definitions/flag
+            description:
+              Enable Queue as DCB/AVB. Note Queue 0 is reserved for legacy
+              traffic and so no AVB is available in this queue.
+
+        additionalProperties: false
+
+        # Choose only one of the Queue modes
+        not:
+          required:
+            - snps,dcb-algorithm
+            - snps,avb-algorithm
+
+        # Credit Base Shaper is configurable for AVB Mode only
+        dependencies:
+          snps,send_slope: ["snps,avb-algorithm"]
+          snps,idle_slope: ["snps,avb-algorithm"]
+          snps,high_credit: ["snps,avb-algorithm"]
+          snps,low_credit: ["snps,avb-algorithm"]
+
+    additionalProperties: false
+
+    # Choose one of the TX scheduling algorithms
+    oneOf:
+      - required:
+          - snps,tx-sched-wrr
+      - required:
+          - snps,tx-sched-wfq
+      - required:
+          - snps,tx-sched-dwrr
+      - required:
+          - snps,tx-sched-sp
+      - not:
+          anyOf:
+            - required:
+                - snps,tx-sched-wrr
+            - required:
+                - snps,tx-sched-wfq
+            - required:
+                - snps,tx-sched-dwrr
+            - required:
+                - snps,tx-sched-sp
 
   snps,reset-gpio:
     deprecated: true
@@ -345,41 +536,6 @@ additionalProperties: true
 
 examples:
   - |
-    stmmac_axi_setup: stmmac-axi-config {
-        snps,wr_osr_lmt = <0xf>;
-        snps,rd_osr_lmt = <0xf>;
-        snps,blen = <256 128 64 32 0 0 0>;
-    };
-
-    mtl_rx_setup: rx-queues-config {
-        snps,rx-queues-to-use = <1>;
-        snps,rx-sched-sp;
-        queue0 {
-            snps,dcb-algorithm;
-            snps,map-to-dma-channel = <0x0>;
-            snps,priority = <0x0>;
-        };
-    };
-
-    mtl_tx_setup: tx-queues-config {
-        snps,tx-queues-to-use = <2>;
-        snps,tx-sched-wrr;
-        queue0 {
-            snps,weight = <0x10>;
-            snps,dcb-algorithm;
-            snps,priority = <0x0>;
-        };
-
-        queue1 {
-            snps,avb-algorithm;
-            snps,send_slope = <0x1000>;
-            snps,idle_slope = <0x1000>;
-            snps,high_credit = <0x3E800>;
-            snps,low_credit = <0xFFC18000>;
-            snps,priority = <0x1>;
-        };
-    };
-
     gmac0: ethernet@e0800000 {
         compatible = "snps,dwxgmac-2.10", "snps,dwxgmac";
         reg = <0xe0800000 0x8000>;
@@ -407,6 +563,55 @@ examples:
             };
         };
     };
+  - |
+    gmac1: ethernet@f8010000 {
+        compatible = "snps,dwmac-4.10a", "snps,dwmac";
+        reg = <0xf8010000 0x4000>;
+        interrupts = <0 98 4>;
+        interrupt-names = "macirq";
+        clock-names = "stmmaceth", "ptp_ref";
+        clocks = <&clock 4>, <&clock 5>;
+        phy-mode = "rgmii";
+        snps,txpbl = <8>;
+        snps,rxpbl = <2>;
+        snps,aal;
+        snps,tso;
+
+        axi-config {
+            snps,wr_osr_lmt = <0xf>;
+            snps,rd_osr_lmt = <0xf>;
+            snps,blen = <256 128 64 32 0 0 0>;
+        };
+
+        mtl-rx-config {
+            snps,rx-queues-to-use = <1>;
+            snps,rx-sched-sp;
+            queue0 {
+               snps,dcb-algorithm;
+               snps,map-to-dma-channel = <0x0>;
+               snps,priority = <0x0>;
+            };
+        };
+
+        mtl-tx-config {
+            snps,tx-queues-to-use = <2>;
+            snps,tx-sched-wrr;
+            queue0 {
+                snps,weight = <0x10>;
+                snps,dcb-algorithm;
+                snps,priority = <0x0>;
+            };
+
+            queue1 {
+                snps,avb-algorithm;
+                snps,send_slope = <0x1000>;
+                snps,idle_slope = <0x1000>;
+                snps,high_credit = <0x3E800>;
+                snps,low_credit = <0xFFC18000>;
+                snps,priority = <0x1>;
+            };
+        };
+    };
 
 # FIXME: We should set it, but it would report all the generic
 # properties as additional properties.
-- 
2.29.2

