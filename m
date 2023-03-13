Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA6246B85C1
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 00:00:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230164AbjCMXA2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 19:00:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229957AbjCMXAW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 19:00:22 -0400
Received: from post.baikalelectronics.com (post.baikalelectronics.com [213.79.110.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E40658691;
        Mon, 13 Mar 2023 15:59:48 -0700 (PDT)
Received: from post.baikalelectronics.com (localhost.localdomain [127.0.0.1])
        by post.baikalelectronics.com (Proxmox) with ESMTP id 231BCE0EBE;
        Tue, 14 Mar 2023 01:51:26 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        baikalelectronics.ru; h=cc:cc:content-transfer-encoding
        :content-type:content-type:date:from:from:in-reply-to:message-id
        :mime-version:references:reply-to:subject:subject:to:to; s=post;
         bh=7MVrtnm6qrHIhyMF9F8ZCjZqai+ZJoeGYKX8whtHDxE=; b=RzpF8eyD0bFT
        LpgQVaXR27miDGoRlb2j8Q2Ima/XWvMj0j2Ovxl2X9H9aHQYRms2xMlDqYPDOcL6
        /DVYsVbbfKl1LruGW7wf+dkXssg99k8UDCidTJAURYjXXpHNkJgLvSBg/pRK4JFm
        aI9ZkSDZ5DX4fmfbZsUsSYYYNZiAxqs=
Received: from mail.baikal.int (mail.baikal.int [192.168.51.25])
        by post.baikalelectronics.com (Proxmox) with ESMTP id 00EF5E0E6A;
        Tue, 14 Mar 2023 01:51:26 +0300 (MSK)
Received: from localhost (10.8.30.10) by mail (192.168.51.25) with Microsoft
 SMTP Server (TLS) id 15.0.1395.4; Tue, 14 Mar 2023 01:51:25 +0300
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
        <linux-kernel@vger.kernel.org>,
        Alexandre Torgue <alexandre.torgue@st.com>
Subject: [PATCH net-next 12/16] dt-bindings: net: dwmac: Add MTL Tx Queue properties constraints
Date:   Tue, 14 Mar 2023 01:50:59 +0300
Message-ID: <20230313225103.30512-13-Sergey.Semin@baikalelectronics.ru>
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

Currently none of the MTL Tx Queues QoS-related DT-properties have been
equipped with the proper constraints meanwhile they can be specified at
least based on the corresponding CSR field sizes or the DW (x|xG)MAC
IP-core synthesize parameter constraints. Let's do that:
+ snps,tx-queues-to-use - number of Tx queues to utilise is limited with a
number of available queues. DW MAC/GMAC: no queues, DW Eth QoS: <= 8, DW
xGMAC: <= 16.
+ snps,weight - Tx Queue/Traffic Class quantum/weight utilised depending
on enabled algorithm for the Data Center Bridging feature: DWRR (up to
0x1312D0 bytes to add to credit) or WFQ (up to 0x3FFF - least bandwidth)
or WFQ (up to 0x64). DW MAC/GMAC: no queues, DW Eth QoS: <= 0x1312D0, DW
xGMAC: <= 0x1312D0.
+ snps,send_slope - Tx Queue/Traffic Class Send-Slope credit value
subtracted from the accumulated credit for the Audio/Video bridging
feature (CBS algorithm, bits per cycle scaled up by 1,024). DW MAC/GMAC:
no queues, DW Eth QoS: <= 0x2000, DW xGMAC: <= 0x3FFF.
+ snps,idle_slope - same meaning as snps,send_slope except it's determines
the Idle-Slope credit of CBS algorithm. DW MAC/GMAC: no queues, DW Eth
QoS: <= 0x2000, DW xGMAC: <= 0x8000.
+ snps,high_credit/snps,low_credit - maximum and minimum values
accumulated in the credit for the Audio/Video bridging feature (CBS
algorithm, bits scaled up by 1,024). DW MAC/GMAC: no queues, DW Eth
QoS: <= 0x1FFFFFFF, DW xGMAC: <= 0x1FFFFFFF.
+ snps,priority - Tx Queue/Traffic Class priority (enabled by the
PFC-packets) limits determined by the VLAN tag PRI field width (it's 7).
DW MAC/GMAC: no queues, DW Eth QoS: 0xff, DW xGMAC: 0xff.

Since the constraints vary for different IP-cores and the DT-schema is
common for all of them the least restrictive values are chosen. The info
above can be used for the IP-core specific DT-schemas if anybody ever is
bothered with one to create.

Signed-off-by: Serge Semin <Sergey.Semin@baikalelectronics.ru>
---
 .../bindings/net/snps,dwmac-generic.yaml      |  2 +-
 .../devicetree/bindings/net/snps,dwmac.yaml   | 24 ++++++++++++++++++-
 2 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/snps,dwmac-generic.yaml b/Documentation/devicetree/bindings/net/snps,dwmac-generic.yaml
index ae740a1ab213..2974af79511d 100644
--- a/Documentation/devicetree/bindings/net/snps,dwmac-generic.yaml
+++ b/Documentation/devicetree/bindings/net/snps,dwmac-generic.yaml
@@ -137,7 +137,7 @@ examples:
                 snps,send_slope = <0x1000>;
                 snps,idle_slope = <0x1000>;
                 snps,high_credit = <0x3E800>;
-                snps,low_credit = <0xFFC18000>;
+                snps,low_credit = <0x1FC18000>;
                 snps,priority = <0x1>;
             };
         };
diff --git a/Documentation/devicetree/bindings/net/snps,dwmac.yaml b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
index e5662b1498b7..2ebf7995426b 100644
--- a/Documentation/devicetree/bindings/net/snps,dwmac.yaml
+++ b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
@@ -250,6 +250,10 @@ properties:
       snps,tx-queues-to-use:
         $ref: /schemas/types.yaml#/definitions/uint32
         description: number of TX queues to be used in the driver
+        default: 1
+        minimum: 1
+        maximum: 16
+
       snps,tx-sched-wrr:
         type: boolean
         description: Weighted Round Robin
@@ -296,13 +300,16 @@ properties:
             snps,tx-sched-wfq: false
             snps,tx-sched-dwrr: false
     patternProperties:
-      "^queue[0-9]$":
+      "^queue([0-9]|1[0-5])$":
         description: Each subnode represents a queue.
         type: object
         properties:
           snps,weight:
             $ref: /schemas/types.yaml#/definitions/uint32
             description: TX queue weight (if using a DCB weight algorithm)
+            minimum: 0
+            maximum: 0x1312D0
+
           snps,dcb-algorithm:
             type: boolean
             description: TX queue will be working in DCB
@@ -315,15 +322,27 @@ properties:
           snps,send_slope:
             $ref: /schemas/types.yaml#/definitions/uint32
             description: enable Low Power Interface
+            minimum: 0
+            maximum: 0x3FFF
+
           snps,idle_slope:
             $ref: /schemas/types.yaml#/definitions/uint32
             description: unlock on WoL
+            minimum: 0
+            maximum: 0x8000
+
           snps,high_credit:
             $ref: /schemas/types.yaml#/definitions/uint32
             description: max write outstanding req. limit
+            minimum: 0
+            maximum: 0x1FFFFFFF
+
           snps,low_credit:
             $ref: /schemas/types.yaml#/definitions/uint32
             description: max read outstanding req. limit
+            minimum: 0
+            maximum: 0x1FFFFFFF
+
           snps,priority:
             $ref: /schemas/types.yaml#/definitions/uint32
             description:
@@ -331,6 +350,9 @@ properties:
               When a PFC frame is received with priorities matching the bitmask,
               the queue is blocked from transmitting for the pause time specified
               in the PFC frame.
+            minimum: 0
+            maximum: 0xFF
+
         allOf:
           - if:
               required:
-- 
2.39.2


