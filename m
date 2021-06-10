Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A218B3A2583
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 09:32:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230146AbhFJHeN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 03:34:13 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:3933 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230117AbhFJHeM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 03:34:12 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4G0wZt3887z6xCk;
        Thu, 10 Jun 2021 15:29:10 +0800 (CST)
Received: from dggpeml500017.china.huawei.com (7.185.36.243) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 10 Jun 2021 15:32:14 +0800
Received: from huawei.com (10.175.103.91) by dggpeml500017.china.huawei.com
 (7.185.36.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Thu, 10 Jun
 2021 15:32:14 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>,
        <radhey.shyam.pandey@xilinx.com>
Subject: [PATCH net-next] net: axienet: Use devm_platform_get_and_ioremap_resource()
Date:   Thu, 10 Jun 2021 15:36:22 +0800
Message-ID: <20210610073622.4078361-1-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.103.91]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpeml500017.china.huawei.com (7.185.36.243)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use devm_platform_get_and_ioremap_resource() to simplify
code.

Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
---
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index e29ad9a86a3c..13cd799541aa 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -1894,8 +1894,7 @@ static int axienet_probe(struct platform_device *pdev)
 		goto cleanup_clk;
 
 	/* Map device registers */
-	ethres = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	lp->regs = devm_ioremap_resource(&pdev->dev, ethres);
+	lp->regs = devm_platform_get_and_ioremap_resource(pdev, 0, &ethres);
 	if (IS_ERR(lp->regs)) {
 		ret = PTR_ERR(lp->regs);
 		goto cleanup_clk;
@@ -2010,9 +2009,7 @@ static int axienet_probe(struct platform_device *pdev)
 		lp->eth_irq = platform_get_irq_optional(pdev, 0);
 	} else {
 		/* Check for these resources directly on the Ethernet node. */
-		struct resource *res = platform_get_resource(pdev,
-							     IORESOURCE_MEM, 1);
-		lp->dma_regs = devm_ioremap_resource(&pdev->dev, res);
+		lp->dma_regs = devm_platform_get_and_ioremap_resource(pdev, 1, NULL);
 		lp->rx_irq = platform_get_irq(pdev, 1);
 		lp->tx_irq = platform_get_irq(pdev, 0);
 		lp->eth_irq = platform_get_irq_optional(pdev, 2);
-- 
2.25.1

