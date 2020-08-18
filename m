Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A490248654
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 15:46:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726734AbgHRNqW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 09:46:22 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:51878 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726480AbgHRNqU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Aug 2020 09:46:20 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id A46A2698D4DD69BE3844;
        Tue, 18 Aug 2020 21:46:16 +0800 (CST)
Received: from huawei.com (10.175.113.133) by DGGEMS409-HUB.china.huawei.com
 (10.3.19.209) with Microsoft SMTP Server id 14.3.487.0; Tue, 18 Aug 2020
 21:46:11 +0800
From:   Wang Hai <wanghai38@huawei.com>
To:     <ulli.kroll@googlemail.com>, <linus.walleij@linaro.org>,
        <davem@davemloft.net>, <kuba@kernel.org>, <mirq-linux@rere.qmqm.pl>
CC:     <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: [PATCH net] net: gemini: Fix missing free_netdev() in error path of gemini_ethernet_port_probe()
Date:   Tue, 18 Aug 2020 21:44:04 +0800
Message-ID: <20200818134404.63828-1-wanghai38@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.113.133]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the missing free_netdev() before return from
gemini_ethernet_port_probe() in the error handling case.

Fixes: 4d5ae32f5e1e ("net: ethernet: Add a driver for Gemini gigabit ethernet")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wang Hai <wanghai38@huawei.com>
---
 drivers/net/ethernet/cortina/gemini.c | 35 ++++++++++++++++++---------
 1 file changed, 23 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/cortina/gemini.c b/drivers/net/ethernet/cortina/gemini.c
index 66e67b24a887..d8de50fde27d 100644
--- a/drivers/net/ethernet/cortina/gemini.c
+++ b/drivers/net/ethernet/cortina/gemini.c
@@ -2407,37 +2407,46 @@ static int gemini_ethernet_port_probe(struct platform_device *pdev)
 	dmares = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!dmares) {
 		dev_err(dev, "no DMA resource\n");
-		return -ENODEV;
+		ret = -ENODEV;
+		goto err_out_free;
 	}
 	port->dma_base = devm_ioremap_resource(dev, dmares);
-	if (IS_ERR(port->dma_base))
-		return PTR_ERR(port->dma_base);
+	if (IS_ERR(port->dma_base)) {
+		ret = PTR_ERR(port->dma_base);
+		goto err_out_free;
+	}
 
 	/* GMAC config memory */
 	gmacres = platform_get_resource(pdev, IORESOURCE_MEM, 1);
 	if (!gmacres) {
 		dev_err(dev, "no GMAC resource\n");
-		return -ENODEV;
+		ret = -ENODEV;
+		goto err_out_free;
 	}
 	port->gmac_base = devm_ioremap_resource(dev, gmacres);
-	if (IS_ERR(port->gmac_base))
-		return PTR_ERR(port->gmac_base);
+	if (IS_ERR(port->gmac_base)) {
+		ret = PTR_ERR(port->gmac_base);
+		goto err_out_free;
+	}
 
 	/* Interrupt */
 	irq = platform_get_irq(pdev, 0);
-	if (irq <= 0)
-		return irq ? irq : -ENODEV;
+	if (irq <= 0) {
+		ret = irq ? irq : -ENODEV;
+		goto err_out_free;
+	}
 	port->irq = irq;
 
 	/* Clock the port */
 	port->pclk = devm_clk_get(dev, "PCLK");
 	if (IS_ERR(port->pclk)) {
 		dev_err(dev, "no PCLK\n");
-		return PTR_ERR(port->pclk);
+		ret = PTR_ERR(port->pclk);
+		goto err_out_free;
 	}
 	ret = clk_prepare_enable(port->pclk);
 	if (ret)
-		return ret;
+		goto err_out_free;
 
 	/* Maybe there is a nice ethernet address we should use */
 	gemini_port_save_mac_addr(port);
@@ -2447,7 +2456,8 @@ static int gemini_ethernet_port_probe(struct platform_device *pdev)
 	if (IS_ERR(port->reset)) {
 		dev_err(dev, "no reset\n");
 		clk_disable_unprepare(port->pclk);
-		return PTR_ERR(port->reset);
+		ret = PTR_ERR(port->reset);
+		goto err_out_free;
 	}
 	reset_control_reset(port->reset);
 	usleep_range(100, 500);
@@ -2504,7 +2514,7 @@ static int gemini_ethernet_port_probe(struct platform_device *pdev)
 					port);
 	if (ret) {
 		clk_disable_unprepare(port->pclk);
-		return ret;
+		goto err_out_free;
 	}
 
 	ret = register_netdev(netdev);
@@ -2520,6 +2530,7 @@ static int gemini_ethernet_port_probe(struct platform_device *pdev)
 		return 0;
 	}
 
+err_out_free:
 	port->netdev = NULL;
 	free_netdev(netdev);
 	return ret;
-- 
2.17.1

