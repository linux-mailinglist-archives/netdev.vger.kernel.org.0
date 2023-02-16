Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42445698F4C
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 10:06:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229793AbjBPJGS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 04:06:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbjBPJGR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 04:06:17 -0500
Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D28562E837;
        Thu, 16 Feb 2023 01:06:15 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045168;MF=yang.lee@linux.alibaba.com;NM=1;PH=DS;RN=12;SR=0;TI=SMTPD_---0Vbnt.KT_1676538372;
Received: from localhost(mailfrom:yang.lee@linux.alibaba.com fp:SMTPD_---0Vbnt.KT_1676538372)
          by smtp.aliyun-inc.com;
          Thu, 16 Feb 2023 17:06:12 +0800
From:   Yang Li <yang.lee@linux.alibaba.com>
To:     kuba@kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, pisa@cmp.felk.cvut.cz,
        ondrej.ille@gmail.com, wg@grandegger.com, mkl@pengutronix.de,
        pabeni@redhat.com, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yang Li <yang.lee@linux.alibaba.com>
Subject: [PATCH -next] can: ctucanfd: Use devm_platform_ioremap_resource()
Date:   Thu, 16 Feb 2023 17:06:10 +0800
Message-Id: <20230216090610.130860-1-yang.lee@linux.alibaba.com>
X-Mailer: git-send-email 2.20.1.7.g153144c
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert platform_get_resource(), devm_ioremap_resource() to a single
call to Use devm_platform_ioremap_resource(), as this is exactly
what this function does.

Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
---
 drivers/net/can/ctucanfd/ctucanfd_platform.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/can/ctucanfd/ctucanfd_platform.c b/drivers/net/can/ctucanfd/ctucanfd_platform.c
index f83684f006ea..a17561d97192 100644
--- a/drivers/net/can/ctucanfd/ctucanfd_platform.c
+++ b/drivers/net/can/ctucanfd/ctucanfd_platform.c
@@ -47,7 +47,6 @@ static void ctucan_platform_set_drvdata(struct device *dev,
  */
 static int ctucan_platform_probe(struct platform_device *pdev)
 {
-	struct resource *res; /* IO mem resources */
 	struct device	*dev = &pdev->dev;
 	void __iomem *addr;
 	int ret;
@@ -55,8 +54,7 @@ static int ctucan_platform_probe(struct platform_device *pdev)
 	int irq;
 
 	/* Get the virtual base address for the device */
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	addr = devm_ioremap_resource(dev, res);
+	addr = devm_platform_ioremap_resource(pdev, 0);
 	if (IS_ERR(addr)) {
 		ret = PTR_ERR(addr);
 		goto err;
-- 
2.20.1.7.g153144c

