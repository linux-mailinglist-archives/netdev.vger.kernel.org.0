Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 445B86B8557
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 23:53:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229482AbjCMWxe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 18:53:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230232AbjCMWxF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 18:53:05 -0400
Received: from post.baikalelectronics.com (post.baikalelectronics.com [213.79.110.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EBB9C92700;
        Mon, 13 Mar 2023 15:52:22 -0700 (PDT)
Received: from post.baikalelectronics.com (localhost.localdomain [127.0.0.1])
        by post.baikalelectronics.com (Proxmox) with ESMTP id 481C7E0EBD;
        Tue, 14 Mar 2023 01:51:24 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        baikalelectronics.ru; h=cc:cc:content-transfer-encoding
        :content-type:content-type:date:from:from:in-reply-to:message-id
        :mime-version:references:reply-to:subject:subject:to:to; s=post;
         bh=+OS7gKmNrCQi7J6HvsjQM8Wy5XPVxZEjlX8wgOsbMHA=; b=mogFCfYvuc56
        kfRSaRAV+ww3e+h3XSTnsXj6z9p27ZhEZU5QmlFLM9dZLWFMbsJD/A3xjpoGcjc/
        CiA47wdQWh/sbBxzNJDbCm7JrShd6jlLALTI9cQ3mQ4jTmt3sueHpo3fnkYI6C0R
        SOl+sO6oJEfs2qfK8C9sN2YOFqhK+RE=
Received: from mail.baikal.int (mail.baikal.int [192.168.51.25])
        by post.baikalelectronics.com (Proxmox) with ESMTP id EF31AE0E6A;
        Tue, 14 Mar 2023 01:51:23 +0300 (MSK)
Received: from localhost (10.8.30.10) by mail (192.168.51.25) with Microsoft
 SMTP Server (TLS) id 15.0.1395.4; Tue, 14 Mar 2023 01:51:23 +0300
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
Subject: [PATCH net-next 11/16] dt-bindings: net: dwmac: Add MTL Rx Queue properties constraints
Date:   Tue, 14 Mar 2023 01:50:58 +0300
Message-ID: <20230313225103.30512-12-Sergey.Semin@baikalelectronics.ru>
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

Currently none of the MTL Rx Queues QoS-related DT-properties have been
equipped with the proper constraints. Meanwhile they can be specified at
least based on the corresponding CSR field sizes or the DW (x|xG)MAC
IP-core synthesize parameter constraints. Let's do that:
+ snps,rx-queues-to-use - number of Rx queues to utilise is limited with a
number of available queues. DW MAC/GMAC: no queues, DW Eth QoS: <= 8, DW
xGMAC: <= 12.
+ snps,map-to-dma-channel - DMA channel ID is limited with a number of
available DMA-channels. DW MAC/GMAC: <= 3, DW Eth QoS: <= 8, DW xGMAC: <=
16.
+ snps,priority - bitfield of the USP (user Priority) values of the tagged
packets is limited with the corresponding CSR field width or a maximum
possible VLAN tag PRI field value (it's 7). DW MAC/GMAC: no queues, DW Eth
QoS: 0xff, DW xGMAC: 0xff.

Since the constraints vary for different IP-cores and the DT-schema is
common for all of them the least restrictive values are chosen. The info
above can be used for the IP-core specific DT-schemas if anybody ever is
bothered with one to create.

Signed-off-by: Serge Semin <Sergey.Semin@baikalelectronics.ru>
---
 .../devicetree/bindings/net/snps,dwmac.yaml          | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/net/snps,dwmac.yaml b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
index f24718a8d184..e5662b1498b7 100644
--- a/Documentation/devicetree/bindings/net/snps,dwmac.yaml
+++ b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
@@ -115,6 +115,10 @@ properties:
       snps,rx-queues-to-use:
         $ref: /schemas/types.yaml#/definitions/uint32
         description: number of RX queues to be used in the driver
+        default: 1
+        minimum: 1
+        maximum: 12
+
       snps,rx-sched-sp:
         type: boolean
         description: Strict priority
@@ -135,7 +139,7 @@ properties:
           properties:
             snps,rx-sched-sp: false
     patternProperties:
-      "^queue[0-9]$":
+      "^queue([0-9]|1[0-1])$":
         description: Each subnode represents a queue.
         type: object
         properties:
@@ -148,6 +152,9 @@ properties:
           snps,map-to-dma-channel:
             $ref: /schemas/types.yaml#/definitions/uint32
             description: DMA channel id to map
+            minimum: 0
+            maximum: 15
+
           snps,route-avcp:
             type: boolean
             description: AV Untagged Control packets
@@ -166,6 +173,9 @@ properties:
           snps,priority:
             $ref: /schemas/types.yaml#/definitions/uint32
             description: Bitmask of the tagged frames priorities assigned to the queue
+            minimum: 0
+            maximum: 0xFF
+
         allOf:
           - if:
               required:
-- 
2.39.2


