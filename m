Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F95A607D38
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 19:11:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230322AbiJURLI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 13:11:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230198AbiJURLG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 13:11:06 -0400
Received: from madras.collabora.co.uk (madras.collabora.co.uk [46.235.227.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B83B24F7B1;
        Fri, 21 Oct 2022 10:11:03 -0700 (PDT)
Received: from jupiter.universe (dyndsl-037-138-189-087.ewe-ip-backbone.de [37.138.189.87])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (No client certificate requested)
        (Authenticated sender: sre)
        by madras.collabora.co.uk (Postfix) with ESMTPSA id E0FDC660247B;
        Fri, 21 Oct 2022 18:11:01 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1666372262;
        bh=pfLYlNjdQjUCudVl5O8l7LMAsm0aKeqVb1Wm1G6oYlw=;
        h=From:To:Cc:Subject:Date:From;
        b=Ispp+w+Ie/L9RA1wxqKgCDmSJW5noF5X1s4sosHCgsInGmtmuWf2GAt3v3x35z/fc
         mKUNhGvxhIj30Do+lp+4RJZjzoYsli7czI/diwlViFa0uCrIMATl6CVOWqOJFSLUeQ
         xTtLDWCx+fuoJ4qImrpmXaSgJgZ5Q0VQOVVkyOc60UzGuyb0AZZ6KwXYvwl9EvhVpc
         NHoziNhIHqY3bvgqbjPeAbQ4T9qbcgdbVFlFWekwOCIwQK0L9A69i+D6Uf2iZ21T08
         vGx/ofOErAfuQHxpAoYiBR9Qx02E7JWodIanBGWFgRMDpcZ/8UqoaioXr16Vlc/l4Y
         2zfrzou4zJ8DQ==
Received: by jupiter.universe (Postfix, from userid 1000)
        id F37BE48082E; Fri, 21 Oct 2022 19:10:59 +0200 (CEST)
From:   Sebastian Reichel <sebastian.reichel@collabora.com>
To:     Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Jose Abreu <joabreu@synopsys.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        kernel@collabora.com
Subject: [PATCH 1/1] dt-bindings: net: snps,dwmac: Document queue config subnodes
Date:   Fri, 21 Oct 2022 19:10:55 +0200
Message-Id: <20221021171055.85888-1-sebastian.reichel@collabora.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The queue configuration is referenced by snps,mtl-rx-config and
snps,mtl-tx-config. Most in-tree DTs put the referenced object
as child node of the dwmac node.

This adds proper description for this setup, which has the
advantage of properly making sure only known properties are
used.

Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
---
 .../devicetree/bindings/net/snps,dwmac.yaml   | 154 ++++++++++++------
 1 file changed, 108 insertions(+), 46 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/snps,dwmac.yaml b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
index 13b984076af5..0bf6112cec2f 100644
--- a/Documentation/devicetree/bindings/net/snps,dwmac.yaml
+++ b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
@@ -167,56 +167,118 @@ properties:
   snps,mtl-rx-config:
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
+      Multiple RX Queues parameters. Phandle to a node that
+      implements the 'rx-queues-config' object described in
+      this binding.
+
+  rx-queues-config:
+    type: object
+    properties:
+      snps,rx-queues-to-use:
+        $ref: /schemas/types.yaml#/definitions/uint32
+        description: number of RX queues to be used in the driver
+      snps,rx-sched-sp:
+        type: boolean
+        description: Strict priority
+      snps,rx-sched-wsp:
+        type: boolean
+        description: Weighted Strict priority
+    patternProperties:
+      "^queue[0-9]$":
+        description: Each subnode represents a queue.
+        type: object
+        properties:
+          snps,dcb-algorithm:
+            type: boolean
+            description: Queue to be enabled as DCB
+          snps,avb-algorithm:
+            type: boolean
+            description: Queue to be enabled as AVB
+          snps,map-to-dma-channel:
+            $ref: /schemas/types.yaml#/definitions/uint32
+            description: DMA channel id to map
+          snps,route-avcp:
+            type: boolean
+            description: AV Untagged Control packets
+          snps,route-ptp:
+            type: boolean
+            description: PTP Packets
+          snps,route-dcbcp:
+            type: boolean
+            description: DCB Control Packets
+          snps,route-up:
+            type: boolean
+            description: Untagged Packets
+          snps,route-multi-broad:
+            type: boolean
+            description: Multicast & Broadcast Packets
+          snps,priority:
+            $ref: /schemas/types.yaml#/definitions/uint32
+            description: Bitmask of the tagged frames priorities assigned to the queue
+    additionalProperties: false
 
   snps,mtl-tx-config:
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
+      Multiple TX Queues parameters. Phandle to a node that
+      implements the 'tx-queues-config' object described in
+      this binding.
+
+  tx-queues-config:
+    type: object
+    properties:
+      snps,tx-queues-to-use:
+        $ref: /schemas/types.yaml#/definitions/uint32
+        description: number of TX queues to be used in the driver
+      snps,tx-sched-wrr:
+        type: boolean
+        description: Weighted Round Robin
+      snps,tx-sched-wfq:
+        type: boolean
+        description: Weighted Fair Queuing
+      snps,tx-sched-dwrr:
+        type: boolean
+        description: Deficit Weighted Round Robin
+      snps,tx-sched-sp:
+        type: boolean
+        description: Strict priority
+    patternProperties:
+      "^queue[0-9]$":
+        description: Each subnode represents a queue.
+        type: object
+        properties:
+          snps,weight:
+            $ref: /schemas/types.yaml#/definitions/uint32
+            description: TX queue weight (if using a DCB weight algorithm)
+          snps,dcb-algorithm:
+            type: boolean
+            description: TX queue will be working in DCB
+          snps,avb-algorithm:
+            type: boolean
+            description:
+              TX queue will be working in AVB.
+              Queue 0 is reserved for legacy traffic and so no AVB is
+              available in this queue.
+          snps,send_slope:
+            type: boolean
+            description: enable Low Power Interface
+          snps,idle_slope:
+            type: boolean
+            description: unlock on WoL
+          snps,high_credit:
+            type: boolean
+            description: max write outstanding req. limit
+          snps,low_credit:
+            type: boolean
+            description: max read outstanding req. limit
+          snps,priority:
+            $ref: /schemas/types.yaml#/definitions/uint32
+            description:
+              Bitmask of the tagged frames priorities assigned to the queue.
+              When a PFC frame is received with priorities matching the bitmask,
+              the queue is blocked from transmitting for the pause time specified
+              in the PFC frame.
+    additionalProperties: false
 
   snps,reset-gpio:
     deprecated: true
-- 
2.35.1

