Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 040752317E4
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 05:00:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731164AbgG2DAf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 23:00:35 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:8847 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728401AbgG2DAf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 23:00:35 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 20DF341D5DD887D6225E;
        Wed, 29 Jul 2020 11:00:33 +0800 (CST)
Received: from huawei.com (10.175.101.6) by DGGEMS413-HUB.china.huawei.com
 (10.3.19.213) with Microsoft SMTP Server id 14.3.487.0; Wed, 29 Jul 2020
 11:00:29 +0800
From:   Lu Wei <luwei32@huawei.com>
To:     <ulli.kroll@googlemail.com>, <linus.walleij@linaro.org>,
        <davem@davemloft.net>, <kuba@kernel.org>,
        <mirq-linux@rere.qmqm.pl>, <linux-arm-kernel@lists.infradead.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] net: ethernet: fix potential memory leak in gemini_ethernet_port_probe()
Date:   Wed, 29 Jul 2020 11:46:06 +0800
Message-ID: <20200729034606.89041-1-luwei32@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.101.6]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If some processes in gemini_ethernet_port_probe() fail,
free_netdev(dev) needs to be called to avoid a memory leak.

Fixes: 4d5ae32f5e1e ("net: ethernet: Add a driver for Gemini gigabit ethernet")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Lu Wei <luwei32@huawei.com>
---
 drivers/net/ethernet/cortina/gemini.c | 24 +++++++++++++++++++-----
 1 file changed, 19 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/cortina/gemini.c b/drivers/net/ethernet/cortina/gemini.c
index 8d13ea370db1..5e93a1a570b6 100644
--- a/drivers/net/ethernet/cortina/gemini.c
+++ b/drivers/net/ethernet/cortina/gemini.c
@@ -2407,37 +2407,48 @@ static int gemini_ethernet_port_probe(struct platform_device *pdev)
 	dmares = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!dmares) {
 		dev_err(dev, "no DMA resource\n");
+		free_netdev(netdev);
 		return -ENODEV;
 	}
 	port->dma_base = devm_ioremap_resource(dev, dmares);
-	if (IS_ERR(port->dma_base))
+	if (IS_ERR(port->dma_base)) {
+		free_netdev(netdev);
 		return PTR_ERR(port->dma_base);
+	}
 
 	/* GMAC config memory */
 	gmacres = platform_get_resource(pdev, IORESOURCE_MEM, 1);
 	if (!gmacres) {
 		dev_err(dev, "no GMAC resource\n");
+		free_netdev(netdev);
 		return -ENODEV;
 	}
 	port->gmac_base = devm_ioremap_resource(dev, gmacres);
-	if (IS_ERR(port->gmac_base))
+	if (IS_ERR(port->gmac_base)) {
+		free_netdev(netdev);
 		return PTR_ERR(port->gmac_base);
+	}
 
 	/* Interrupt */
 	irq = platform_get_irq(pdev, 0);
-	if (irq <= 0)
+	if (irq <= 0) {
+		free_netdev(netdev);
 		return irq ? irq : -ENODEV;
+	}
 	port->irq = irq;
 
 	/* Clock the port */
 	port->pclk = devm_clk_get(dev, "PCLK");
 	if (IS_ERR(port->pclk)) {
 		dev_err(dev, "no PCLK\n");
+		free_netdev(netdev);
 		return PTR_ERR(port->pclk);
 	}
 	ret = clk_prepare_enable(port->pclk);
-	if (ret)
+	if (ret) {
+		free_netdev(netdev);
 		return ret;
+	}
 
 	/* Maybe there is a nice ethernet address we should use */
 	gemini_port_save_mac_addr(port);
@@ -2446,6 +2457,7 @@ static int gemini_ethernet_port_probe(struct platform_device *pdev)
 	port->reset = devm_reset_control_get_exclusive(dev, NULL);
 	if (IS_ERR(port->reset)) {
 		dev_err(dev, "no reset\n");
+		free_netdev(netdev);
 		return PTR_ERR(port->reset);
 	}
 	reset_control_reset(port->reset);
@@ -2501,8 +2513,10 @@ static int gemini_ethernet_port_probe(struct platform_device *pdev)
 					IRQF_SHARED,
 					port_names[port->id],
 					port);
-	if (ret)
+	if (ret) {
+		free_netdev(netdev);
 		return ret;
+	}
 
 	ret = register_netdev(netdev);
 	if (!ret) {
-- 
2.17.1

