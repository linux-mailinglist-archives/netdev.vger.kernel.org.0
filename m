Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDF826B85BE
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 00:00:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229685AbjCMXAZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 19:00:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229872AbjCMXAV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 19:00:21 -0400
Received: from post.baikalelectronics.com (post.baikalelectronics.com [213.79.110.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CE20783FF;
        Mon, 13 Mar 2023 15:59:48 -0700 (PDT)
Received: from post.baikalelectronics.com (localhost.localdomain [127.0.0.1])
        by post.baikalelectronics.com (Proxmox) with ESMTP id 3F5A0E0EC1;
        Tue, 14 Mar 2023 01:51:31 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        baikalelectronics.ru; h=cc:cc:content-transfer-encoding
        :content-type:content-type:date:from:from:in-reply-to:message-id
        :mime-version:references:reply-to:subject:subject:to:to; s=post;
         bh=GDWLCKbTjZjHBGbg9BZjPvJY7ns7quDEaw1d5obfFoI=; b=Su5mxlbVtf7o
        HyrJOJcxzszhKpQ6kT8G485hALnO3itaeV7HwX6WS1qCTYw/blglbHawXh2+wssm
        Oeve5lvR0oImztmoDy88paEtRG0KeZc0fJBGTupcoKoJmClWy0JNd/ASS5/tg+Ln
        rrPM41V8hbhipuR7e48Ul7M4eS3qW5Q=
Received: from mail.baikal.int (mail.baikal.int [192.168.51.25])
        by post.baikalelectronics.com (Proxmox) with ESMTP id 2827BE0E6A;
        Tue, 14 Mar 2023 01:51:31 +0300 (MSK)
Received: from localhost (10.8.30.10) by mail (192.168.51.25) with Microsoft
 SMTP Server (TLS) id 15.0.1395.4; Tue, 14 Mar 2023 01:51:30 +0300
From:   Serge Semin <Sergey.Semin@baikalelectronics.ru>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
CC:     Serge Semin <Sergey.Semin@baikalelectronics.ru>,
        Serge Semin <fancer.lancer@gmail.com>,
        Alexey Malahov <Alexey.Malahov@baikalelectronics.ru>,
        Pavel Parkhomenko <Pavel.Parkhomenko@baikalelectronics.ru>,
        Christian Marangi <ansuelsmth@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Biao Huang <biao.huang@mediatek.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        <devicetree@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next 15/16] dt-bindings: net: dwmac: Simplify MTL queue props dependencies
Date:   Tue, 14 Mar 2023 01:51:02 +0300
Message-ID: <20230313225103.30512-16-Sergey.Semin@baikalelectronics.ru>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230313225103.30512-1-Sergey.Semin@baikalelectronics.ru>
References: <20230313225103.30512-1-Sergey.Semin@baikalelectronics.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.8.30.10]
X-ClientProxiedBy: MAIL.baikal.int (192.168.51.25) To mail (192.168.51.25)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently the Tx/Rx queues properties interdependencies are described by
means of the pattern: "if: required: X, then: properties: Y: false, Z:
false, etc". Due to very unfortunate MTL Tx/Rx queue DT-node design the
resultant sub-nodes schemas look very bulky and thus hard to read. The
situation can be improved by using the "allOf:/oneOf: required: X,
required: Y, etc" pattern instead thus getting shorter and a bit easier to
comprehend constructions.

Signed-off-by: Serge Semin <Sergey.Semin@baikalelectronics.ru>

---

Note the solution can be shortened out a bit further by replacing the
single-entry allOf statements with just the "not: required: etc" pattern.
But in order to do that the DT-schema validation tool must be fixed like
this:

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

Thus all the patterns like
allOf:
  - not:
      required:
        - X
could be replaced with just
not:
  required:
    - X
---
 .../devicetree/bindings/net/snps,dwmac.yaml   | 175 +++++++-----------
 1 file changed, 63 insertions(+), 112 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/snps,dwmac.yaml b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
index a863b5860566..9df301cf674e 100644
--- a/Documentation/devicetree/bindings/net/snps,dwmac.yaml
+++ b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
@@ -127,19 +127,6 @@ properties:
         $ref: /schemas/types.yaml#/definitions/flag
         description: Weighted Strict priority
 
-    allOf:
-      - if:
-          required:
-            - snps,rx-sched-sp
-        then:
-          properties:
-            snps,rx-sched-wsp: false
-      - if:
-          required:
-            - snps,rx-sched-wsp
-        then:
-          properties:
-            snps,rx-sched-sp: false
     patternProperties:
       "^queue([0-9]|1[0-1])$":
         description: Each subnode represents a queue.
@@ -185,67 +172,46 @@ properties:
             minimum: 0
             maximum: 0xFF
 
+        additionalProperties: false
+
+        # Choose only one of the bridging algorithm and the packets routing
         allOf:
-          - if:
+          - not:
               required:
                 - snps,dcb-algorithm
-            then:
-              properties:
-                snps,avb-algorithm: false
-          - if:
-              required:
                 - snps,avb-algorithm
-            then:
-              properties:
-                snps,dcb-algorithm: false
-          - if:
-              required:
-                - snps,route-avcp
-            then:
-              properties:
-                snps,route-ptp: false
-                snps,route-dcbcp: false
-                snps,route-up: false
-                snps,route-multi-broad: false
-          - if:
-              required:
-                - snps,route-ptp
-            then:
-              properties:
-                snps,route-avcp: false
-                snps,route-dcbcp: false
-                snps,route-up: false
-                snps,route-multi-broad: false
-          - if:
-              required:
-                - snps,route-dcbcp
-            then:
-              properties:
-                snps,route-avcp: false
-                snps,route-ptp: false
-                snps,route-up: false
-                snps,route-multi-broad: false
-          - if:
-              required:
-                - snps,route-up
-            then:
-              properties:
-                snps,route-avcp: false
-                snps,route-ptp: false
-                snps,route-dcbcp: false
-                snps,route-multi-broad: false
-          - if:
-              required:
-                - snps,route-multi-broad
-            then:
-              properties:
-                snps,route-avcp: false
-                snps,route-ptp: false
-                snps,route-dcbcp: false
-                snps,route-up: false
-        additionalProperties: false
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
     additionalProperties: false
 
+    allOf:
+      - not:
+          required:
+            - snps,rx-sched-sp
+            - snps,rx-sched-wsp
+
   snps,mtl-tx-config:
     $ref: /schemas/types.yaml#/definitions/phandle
     description:
@@ -279,39 +245,6 @@ properties:
         $ref: /schemas/types.yaml#/definitions/flag
         description: Strict priority
 
-    allOf:
-      - if:
-          required:
-            - snps,tx-sched-wrr
-        then:
-          properties:
-            snps,tx-sched-wfq: false
-            snps,tx-sched-dwrr: false
-            snps,tx-sched-sp: false
-      - if:
-          required:
-            - snps,tx-sched-wfq
-        then:
-          properties:
-            snps,tx-sched-wrr: false
-            snps,tx-sched-dwrr: false
-            snps,tx-sched-sp: false
-      - if:
-          required:
-            - snps,tx-sched-dwrr
-        then:
-          properties:
-            snps,tx-sched-wrr: false
-            snps,tx-sched-wfq: false
-            snps,tx-sched-sp: false
-      - if:
-          required:
-            - snps,tx-sched-sp
-        then:
-          properties:
-            snps,tx-sched-wrr: false
-            snps,tx-sched-wfq: false
-            snps,tx-sched-dwrr: false
     patternProperties:
       "^queue([0-9]|1[0-5])$":
         description: Each subnode represents a queue.
@@ -380,23 +313,41 @@ properties:
             minimum: 0
             maximum: 0xFF
 
+        additionalProperties: false
+
+        # Choose only one of the Queue TC algo
         allOf:
-          - if:
+          - not:
               required:
                 - snps,dcb-algorithm
-            then:
-              properties:
-                snps,avb-algorithm: false
-          - if:
-              required:
                 - snps,avb-algorithm
-            then:
-              properties:
-                snps,dcb-algorithm: false
-                snps,weight: false
-        additionalProperties: false
+
+        dependencies:
+          snps,weight: ["snps,dcb-algorithm"]
+
     additionalProperties: false
 
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
+
   snps,reset-gpio:
     deprecated: true
     maxItems: 1
-- 
2.39.2


