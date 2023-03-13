Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 977E46B855A
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 23:53:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229700AbjCMWxh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 18:53:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229612AbjCMWxH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 18:53:07 -0400
Received: from post.baikalelectronics.com (post.baikalelectronics.com [213.79.110.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 77A8792726;
        Mon, 13 Mar 2023 15:52:27 -0700 (PDT)
Received: from post.baikalelectronics.com (localhost.localdomain [127.0.0.1])
        by post.baikalelectronics.com (Proxmox) with ESMTP id 5CF5CE0EBB;
        Tue, 14 Mar 2023 01:51:22 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        baikalelectronics.ru; h=cc:cc:content-transfer-encoding
        :content-type:content-type:date:from:from:in-reply-to:message-id
        :mime-version:references:reply-to:subject:subject:to:to; s=post;
         bh=/8CHQKcSQNOd84jUFb0GyleIApZIHIOE6ipgEgcboPQ=; b=ZuW2NnJXGaCa
        c8rmEbdZS4jhKDKbFuLmgLUJ+xIQ3xyiHEkmBOC7PdC6lZ7b+c5VFWNEbQPmZX/r
        BJAccZwbsCKjZvg5sCodLLvxDU7/kYeB0NoZnb+fLzdRMC1+gNOzYG+fYnWWmvKc
        TVssdaQGDKLUn6Eam7qkE2qryHILJKM=
Received: from mail.baikal.int (mail.baikal.int [192.168.51.25])
        by post.baikalelectronics.com (Proxmox) with ESMTP id 3DF24E0E6A;
        Tue, 14 Mar 2023 01:51:22 +0300 (MSK)
Received: from localhost (10.8.30.10) by mail (192.168.51.25) with Microsoft
 SMTP Server (TLS) id 15.0.1395.4; Tue, 14 Mar 2023 01:51:21 +0300
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
Subject: [PATCH net-next 10/16] dt-bindings: net: dwmac: Add AXI-bus properties constraints
Date:   Tue, 14 Mar 2023 01:50:57 +0300
Message-ID: <20230313225103.30512-11-Sergey.Semin@baikalelectronics.ru>
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

Currently none of the AXI-bus non-boolean DT-properties have constraints
defined meanwhile they can be specified at least based on the
corresponding device configs. Let's do that:
+ snps,wr_osr_lm/snps,rd_osr_lmt - maximum number of outstanding AXI-bus
read/write requests is limited with the IP-core synthesize parameter
AXI_MAX_{RD,WR}_REQ. DW MAC/GMAC: <= 16, DW Eth QoS: <= 32, DW xGMAC: <=
64. The least restrictive constraint is defined since the DT-schema is
common for all IP-cores.
+ snps,blen - array of the burst lengths supported by the AXI-bus. Values
are limited by the AXI3/4 bus standard, available AXI/System bus CSR flags
and the AXI-bus IP-core synthesize config . All DW *MACs support setting
the burst length within the set: 4, 8, 16, 32, 64, 128, 256. If some burst
length is unsupported a zero value can be specified instead in the array.

Signed-off-by: Serge Semin <Sergey.Semin@baikalelectronics.ru>
---
 Documentation/devicetree/bindings/net/snps,dwmac.yaml | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/snps,dwmac.yaml b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
index d1b2910b799b..f24718a8d184 100644
--- a/Documentation/devicetree/bindings/net/snps,dwmac.yaml
+++ b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
@@ -484,11 +484,17 @@ properties:
         $ref: /schemas/types.yaml#/definitions/uint32
         description:
           max write outstanding req. limit
+        default: 1
+        minimum: 1
+        maximum: 64
 
       snps,rd_osr_lmt:
         $ref: /schemas/types.yaml#/definitions/uint32
         description:
           max read outstanding req. limit
+        default: 1
+        minimum: 1
+        maximum: 64
 
       snps,kbbe:
         $ref: /schemas/types.yaml#/definitions/uint32
@@ -501,6 +507,8 @@ properties:
           this is a vector of supported burst length.
         minItems: 7
         maxItems: 7
+        items:
+          enum: [256, 128, 64, 32, 16, 8, 4, 0]
 
       snps,fb:
         $ref: /schemas/types.yaml#/definitions/flag
-- 
2.39.2


