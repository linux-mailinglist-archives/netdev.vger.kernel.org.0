Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A75160C224
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 05:13:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230374AbiJYDNb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 23:13:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230183AbiJYDN3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 23:13:29 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34CE21B9D3
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 20:13:28 -0700 (PDT)
Received: from dggpemm500024.china.huawei.com (unknown [172.30.72.56])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4MxH4x1mpPzJn9v;
        Tue, 25 Oct 2022 11:10:41 +0800 (CST)
Received: from dggpemm500007.china.huawei.com (7.185.36.183) by
 dggpemm500024.china.huawei.com (7.185.36.203) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 25 Oct 2022 11:13:26 +0800
Received: from huawei.com (10.175.103.91) by dggpemm500007.china.huawei.com
 (7.185.36.183) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Tue, 25 Oct
 2022 11:13:26 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>
Subject: [PATCH net-next 1/2] net: natsemi: xtsonic: switch to use platform_get_irq()
Date:   Tue, 25 Oct 2022 11:12:35 +0800
Message-ID: <20221025031236.1031330-1-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.103.91]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpemm500007.china.huawei.com (7.185.36.183)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Switch to use platform_get_irq() which supports more cases.

Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
---
 drivers/net/ethernet/natsemi/xtsonic.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/natsemi/xtsonic.c b/drivers/net/ethernet/natsemi/xtsonic.c
index 52fef34d43f9..ffb3814c54cb 100644
--- a/drivers/net/ethernet/natsemi/xtsonic.c
+++ b/drivers/net/ethernet/natsemi/xtsonic.c
@@ -201,14 +201,17 @@ int xtsonic_probe(struct platform_device *pdev)
 {
 	struct net_device *dev;
 	struct sonic_local *lp;
-	struct resource *resmem, *resirq;
+	struct resource *resmem;
+	int irq;
 	int err = 0;
 
 	if ((resmem = platform_get_resource(pdev, IORESOURCE_MEM, 0)) == NULL)
 		return -ENODEV;
 
-	if ((resirq = platform_get_resource(pdev, IORESOURCE_IRQ, 0)) == NULL)
-		return -ENODEV;
+	irq = platform_get_irq(pdev, 0);
+	if (irq < 0)
+		return irq;
+
 
 	if ((dev = alloc_etherdev(sizeof(struct sonic_local))) == NULL)
 		return -ENOMEM;
@@ -219,7 +222,7 @@ int xtsonic_probe(struct platform_device *pdev)
 	SET_NETDEV_DEV(dev, &pdev->dev);
 
 	dev->base_addr = resmem->start;
-	dev->irq = resirq->start;
+	dev->irq = irq;
 
 	if ((err = sonic_probe1(dev)))
 		goto out;
-- 
2.25.1

