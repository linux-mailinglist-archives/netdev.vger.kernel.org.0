Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E8AE6B853D
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 23:52:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230140AbjCMWwT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 18:52:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230137AbjCMWwO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 18:52:14 -0400
Received: from post.baikalelectronics.com (post.baikalelectronics.com [213.79.110.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1A65F49F0;
        Mon, 13 Mar 2023 15:51:51 -0700 (PDT)
Received: from post.baikalelectronics.com (localhost.localdomain [127.0.0.1])
        by post.baikalelectronics.com (Proxmox) with ESMTP id DDD01E0EB4;
        Tue, 14 Mar 2023 01:51:10 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        baikalelectronics.ru; h=cc:cc:content-transfer-encoding
        :content-type:content-type:date:from:from:in-reply-to:message-id
        :mime-version:references:reply-to:subject:subject:to:to; s=post;
         bh=VFkPUzOm4WO2kZ00mW10/1EQVEqfv291U9mtDB6u7+g=; b=nsN4DFTnkKHe
        c+gHezWyGZF/KYPFyUOHVDz/QIMSOZVaFSlsGE0XK+k7ULDofcqyuFEcqSOPQuSQ
        +F5qVSEO+Z57uioppuZwpAifeBYkXttIYY4raz4DwYvlix/4nEQCHI6sWOmDsPHZ
        XWA10Gc9VYZl/KqllKOVK4Ms9CedCtk=
Received: from mail.baikal.int (mail.baikal.int [192.168.51.25])
        by post.baikalelectronics.com (Proxmox) with ESMTP id CD137E0E6A;
        Tue, 14 Mar 2023 01:51:10 +0300 (MSK)
Received: from localhost (10.8.30.10) by mail (192.168.51.25) with Microsoft
 SMTP Server (TLS) id 15.0.1395.4; Tue, 14 Mar 2023 01:51:10 +0300
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
        <linux-kernel@vger.kernel.org>, Rob Herring <robh@kernel.org>
Subject: [PATCH net-next 03/16] dt-bindings: net: dwmac: Fix the TSO property declaration
Date:   Tue, 14 Mar 2023 01:50:50 +0300
Message-ID: <20230313225103.30512-4-Sergey.Semin@baikalelectronics.ru>
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

Indeed the STMMAC driver doesn't take the vendor-specific compatible
string into account to parse the "snps,tso" boolean property. It just
makes sure the node is compatible with DW MAC 4.x, 5.x and DW xGMAC
IP-cores. The original allwinner sunXi bindings file also didn't have the
TSO-related property declared. Neither Ingenic nor Loongson LLD drivers
activate the GMAC4/5/etc-specific core code. Taking all of that into
account fix the conditional statement so the TSO-property would be
evaluated for the compatibles having the corresponding IP-core version by
dropping all of the vendor-specific compatibles from the property
conditional statement.

Signed-off-by: Serge Semin <Sergey.Semin@baikalelectronics.ru>
Reviewed-by: Rob Herring <robh@kernel.org>

---

Note this won't break the bindings description, since the "snps,tso"
property isn't parsed by the denoted glue drivers, but only by the generic
platform DT-parser.

Changelog v1:
- Use correct syntax of the JSON pointers, so the later would begin
  with a '/' after the '#'.
---
 .../devicetree/bindings/net/snps,dwmac.yaml       | 15 ---------------
 1 file changed, 15 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/snps,dwmac.yaml b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
index fb9b8506a48f..92feed3c29bc 100644
--- a/Documentation/devicetree/bindings/net/snps,dwmac.yaml
+++ b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
@@ -590,27 +590,12 @@ allOf:
         compatible:
           contains:
             enum:
-              - allwinner,sun7i-a20-gmac
-              - allwinner,sun8i-a83t-emac
-              - allwinner,sun8i-h3-emac
-              - allwinner,sun8i-r40-gmac
-              - allwinner,sun8i-v3s-emac
-              - allwinner,sun50i-a64-emac
-              - loongson,ls2k-dwmac
-              - loongson,ls7a-dwmac
-              - ingenic,jz4775-mac
-              - ingenic,x1000-mac
-              - ingenic,x1600-mac
-              - ingenic,x1830-mac
-              - ingenic,x2000-mac
               - snps,dwmac-4.00
               - snps,dwmac-4.10a
               - snps,dwmac-4.20a
               - snps,dwmac-5.10a
               - snps,dwxgmac
               - snps,dwxgmac-2.10
-              - st,spear600-gmac
-
     then:
       properties:
         snps,tso:
-- 
2.39.2


