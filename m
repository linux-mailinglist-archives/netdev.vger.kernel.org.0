Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FAF439C82A
	for <lists+netdev@lfdr.de>; Sat,  5 Jun 2021 14:32:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229996AbhFEMeJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Jun 2021 08:34:09 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:4324 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229902AbhFEMeJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Jun 2021 08:34:09 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4FxzRS5nGTz1BGFd;
        Sat,  5 Jun 2021 20:27:32 +0800 (CST)
Received: from dggpeml500017.china.huawei.com (7.185.36.243) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Sat, 5 Jun 2021 20:32:19 +0800
Received: from huawei.com (10.175.103.91) by dggpeml500017.china.huawei.com
 (7.185.36.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Sat, 5 Jun 2021
 20:32:19 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <ulli.kroll@googlemail.com>, <linus.walleij@linaro.org>,
        <davem@davemloft.net>, <kuba@kernel.org>
Subject: [PATCH net-next v2] net: gemini: Use devm_platform_get_and_ioremap_resource()
Date:   Sat, 5 Jun 2021 20:36:36 +0800
Message-ID: <20210605123636.2485041-1-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.103.91]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpeml500017.china.huawei.com (7.185.36.243)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use devm_platform_get_and_ioremap_resource() to simplify
code.

Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
---
v2:
  Also use devm_platform_get_and_ioremap_resource() in gemini_ethernet_probe().
  Keep the error message to distinguish remap which address failed in
  gemini_ethernet_port_probe().
---
 drivers/net/ethernet/cortina/gemini.c | 28 +++++++++------------------
 1 file changed, 9 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/cortina/gemini.c b/drivers/net/ethernet/cortina/gemini.c
index 8df6f081f244..6f7ff1f1fb2b 100644
--- a/drivers/net/ethernet/cortina/gemini.c
+++ b/drivers/net/ethernet/cortina/gemini.c
@@ -2390,24 +2390,18 @@ static int gemini_ethernet_port_probe(struct platform_device *pdev)
 	port->msg_enable = netif_msg_init(debug, DEFAULT_MSG_ENABLE);
 
 	/* DMA memory */
-	dmares = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!dmares) {
-		dev_err(dev, "no DMA resource\n");
-		return -ENODEV;
-	}
-	port->dma_base = devm_ioremap_resource(dev, dmares);
-	if (IS_ERR(port->dma_base))
+	port->dma_base = devm_platform_get_and_ioremap_resource(pdev, 0, &dmares);
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
+	port->gmac_base = devm_platform_get_and_ioremap_resource(pdev, 1, &gmacres);
+	if (IS_ERR(port->gmac_base)) {
+		dev_err(dev, "get GMAC address failed\n");
 		return PTR_ERR(port->gmac_base);
+	}
 
 	/* Interrupt */
 	irq = platform_get_irq(pdev, 0);
@@ -2544,17 +2538,13 @@ static int gemini_ethernet_probe(struct platform_device *pdev)
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

