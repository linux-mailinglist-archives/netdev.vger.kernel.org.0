Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FC0639D6C0
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 10:07:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230220AbhFGIJi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 04:09:38 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:4375 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbhFGIJh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Jun 2021 04:09:37 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4Fz5VM2tvkz69cH;
        Mon,  7 Jun 2021 16:03:55 +0800 (CST)
Received: from dggpeml500017.china.huawei.com (7.185.36.243) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 7 Jun 2021 16:07:32 +0800
Received: from huawei.com (10.175.103.91) by dggpeml500017.china.huawei.com
 (7.185.36.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Mon, 7 Jun 2021
 16:07:31 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <ulli.kroll@googlemail.com>, <linus.walleij@linaro.org>,
        <davem@davemloft.net>, <kuba@kernel.org>
Subject: [PATCH net-next v3] net: gemini: Use devm_platform_get_and_ioremap_resource()
Date:   Mon, 7 Jun 2021 16:11:45 +0800
Message-ID: <20210607081145.1617593-1-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.103.91]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpeml500017.china.huawei.com (7.185.36.243)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use devm_platform_get_and_ioremap_resource() to simplify
code.

Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
---
v3:
  remove netdev_info(...) in gemini_ethernet_port_probe()
v2:
  Also use devm_platform_get_and_ioremap_resource() in gemini_ethernet_probe().
  Keep the error message to distinguish remap which address failed in
  gemini_ethernet_port_probe().
---
 drivers/net/ethernet/cortina/gemini.c | 34 +++++++--------------------
 1 file changed, 9 insertions(+), 25 deletions(-)

diff --git a/drivers/net/ethernet/cortina/gemini.c b/drivers/net/ethernet/cortina/gemini.c
index 8df6f081f244..c2ebb3388789 100644
--- a/drivers/net/ethernet/cortina/gemini.c
+++ b/drivers/net/ethernet/cortina/gemini.c
@@ -2356,8 +2356,6 @@ static int gemini_ethernet_port_probe(struct platform_device *pdev)
 	struct device *dev = &pdev->dev;
 	struct gemini_ethernet *geth;
 	struct net_device *netdev;
-	struct resource *gmacres;
-	struct resource *dmares;
 	struct device *parent;
 	unsigned int id;
 	int irq;
@@ -2390,24 +2388,18 @@ static int gemini_ethernet_port_probe(struct platform_device *pdev)
 	port->msg_enable = netif_msg_init(debug, DEFAULT_MSG_ENABLE);
 
 	/* DMA memory */
-	dmares = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!dmares) {
-		dev_err(dev, "no DMA resource\n");
-		return -ENODEV;
-	}
-	port->dma_base = devm_ioremap_resource(dev, dmares);
-	if (IS_ERR(port->dma_base))
+	port->dma_base = devm_platform_get_and_ioremap_resource(pdev, 0, NULL);
+	if (IS_ERR(port->dma_base)) {
+		dev_err(dev, "get DMA address failed\n");
 		return PTR_ERR(port->dma_base);
+	}
 
 	/* GMAC config memory */
-	gmacres = platform_get_resource(pdev, IORESOURCE_MEM, 1);
-	if (!gmacres) {
-		dev_err(dev, "no GMAC resource\n");
-		return -ENODEV;
-	}
-	port->gmac_base = devm_ioremap_resource(dev, gmacres);
-	if (IS_ERR(port->gmac_base))
+	port->gmac_base = devm_platform_get_and_ioremap_resource(pdev, 1, NULL);
+	if (IS_ERR(port->gmac_base)) {
+		dev_err(dev, "get GMAC address failed\n");
 		return PTR_ERR(port->gmac_base);
+	}
 
 	/* Interrupt */
 	irq = platform_get_irq(pdev, 0);
@@ -2502,10 +2494,6 @@ static int gemini_ethernet_port_probe(struct platform_device *pdev)
 	if (ret)
 		goto unprepare;
 
-	netdev_info(netdev,
-		    "irq %d, DMA @ 0x%pap, GMAC @ 0x%pap\n",
-		    port->irq, &dmares->start,
-		    &gmacres->start);
 	return 0;
 
 unprepare:
@@ -2544,17 +2532,13 @@ static int gemini_ethernet_probe(struct platform_device *pdev)
 	struct device *dev = &pdev->dev;
 	struct gemini_ethernet *geth;
 	unsigned int retry = 5;
-	struct resource *res;
 	u32 val;
 
 	/* Global registers */
 	geth = devm_kzalloc(dev, sizeof(*geth), GFP_KERNEL);
 	if (!geth)
 		return -ENOMEM;
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res)
-		return -ENODEV;
-	geth->base = devm_ioremap_resource(dev, res);
+	geth->base = devm_platform_get_and_ioremap_resource(pdev, 0, NULL);
 	if (IS_ERR(geth->base))
 		return PTR_ERR(geth->base);
 	geth->dev = dev;
-- 
2.25.1

