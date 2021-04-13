Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D07AA35E7C1
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 22:50:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348324AbhDMUs5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 16:48:57 -0400
Received: from mx2.suse.de ([195.135.220.15]:41278 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348287AbhDMUsx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Apr 2021 16:48:53 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 262CBAFC4;
        Tue, 13 Apr 2021 20:48:32 +0000 (UTC)
From:   Thomas Bogendoerfer <tsbogend@alpha.franken.de>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 2/7] net: korina: Use devres functions
Date:   Tue, 13 Apr 2021 22:48:13 +0200
Message-Id: <20210413204818.23350-3-tsbogend@alpha.franken.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210413204818.23350-1-tsbogend@alpha.franken.de>
References: <20210413204818.23350-1-tsbogend@alpha.franken.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Simplify probe/remove code by using devm_ functions.

Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
---
 drivers/net/ethernet/korina.c | 64 ++++++++++++-----------------------
 1 file changed, 21 insertions(+), 43 deletions(-)

diff --git a/drivers/net/ethernet/korina.c b/drivers/net/ethernet/korina.c
index 2266b18c1377..3a454f6214b0 100644
--- a/drivers/net/ethernet/korina.c
+++ b/drivers/net/ethernet/korina.c
@@ -104,9 +104,9 @@ enum chain_status {
 
 /* Information that need to be kept for each board. */
 struct korina_private {
-	struct eth_regs *eth_regs;
-	struct dma_reg *rx_dma_regs;
-	struct dma_reg *tx_dma_regs;
+	struct eth_regs __iomem *eth_regs;
+	struct dma_reg __iomem *rx_dma_regs;
+	struct dma_reg __iomem *tx_dma_regs;
 	struct dma_desc *td_ring; /* transmit descriptor ring */
 	struct dma_desc *rd_ring; /* receive descriptor ring  */
 
@@ -1045,10 +1045,10 @@ static int korina_probe(struct platform_device *pdev)
 	struct korina_device *bif = platform_get_drvdata(pdev);
 	struct korina_private *lp;
 	struct net_device *dev;
-	struct resource *r;
+	void __iomem *p;
 	int rc;
 
-	dev = alloc_etherdev(sizeof(struct korina_private));
+	dev = devm_alloc_etherdev(&pdev->dev, sizeof(struct korina_private));
 	if (!dev)
 		return -ENOMEM;
 
@@ -1061,36 +1061,30 @@ static int korina_probe(struct platform_device *pdev)
 	lp->rx_irq = platform_get_irq_byname(pdev, "korina_rx");
 	lp->tx_irq = platform_get_irq_byname(pdev, "korina_tx");
 
-	r = platform_get_resource_byname(pdev, IORESOURCE_MEM, "korina_regs");
-	dev->base_addr = r->start;
-	lp->eth_regs = ioremap(r->start, resource_size(r));
-	if (!lp->eth_regs) {
+	p = devm_platform_ioremap_resource_byname(pdev, "korina_regs");
+	if (!p) {
 		printk(KERN_ERR DRV_NAME ": cannot remap registers\n");
-		rc = -ENXIO;
-		goto probe_err_out;
+		return -ENOMEM;
 	}
+	lp->eth_regs = p;
 
-	r = platform_get_resource_byname(pdev, IORESOURCE_MEM, "korina_dma_rx");
-	lp->rx_dma_regs = ioremap(r->start, resource_size(r));
-	if (!lp->rx_dma_regs) {
+	p = devm_platform_ioremap_resource_byname(pdev, "korina_dma_rx");
+	if (!p) {
 		printk(KERN_ERR DRV_NAME ": cannot remap Rx DMA registers\n");
-		rc = -ENXIO;
-		goto probe_err_dma_rx;
+		return -ENOMEM;
 	}
+	lp->rx_dma_regs = p;
 
-	r = platform_get_resource_byname(pdev, IORESOURCE_MEM, "korina_dma_tx");
-	lp->tx_dma_regs = ioremap(r->start, resource_size(r));
-	if (!lp->tx_dma_regs) {
+	p = devm_platform_ioremap_resource_byname(pdev, "korina_dma_tx");
+	if (!p) {
 		printk(KERN_ERR DRV_NAME ": cannot remap Tx DMA registers\n");
-		rc = -ENXIO;
-		goto probe_err_dma_tx;
+		return -ENOMEM;
 	}
+	lp->tx_dma_regs = p;
 
 	lp->td_ring = kmalloc(TD_RING_SIZE + RD_RING_SIZE, GFP_KERNEL);
-	if (!lp->td_ring) {
-		rc = -ENXIO;
-		goto probe_err_td_ring;
-	}
+	if (!lp->td_ring)
+		return -ENOMEM;
 
 	dma_cache_inv((unsigned long)(lp->td_ring),
 			TD_RING_SIZE + RD_RING_SIZE);
@@ -1120,7 +1114,8 @@ static int korina_probe(struct platform_device *pdev)
 	if (rc < 0) {
 		printk(KERN_ERR DRV_NAME
 			": cannot register net device: %d\n", rc);
-		goto probe_err_register;
+		kfree((struct dma_desc *)KSEG0ADDR(lp->td_ring));
+		return rc;
 	}
 	timer_setup(&lp->media_check_timer, korina_poll_media, 0);
 
@@ -1128,20 +1123,7 @@ static int korina_probe(struct platform_device *pdev)
 
 	printk(KERN_INFO "%s: " DRV_NAME "-" DRV_VERSION " " DRV_RELDATE "\n",
 			dev->name);
-out:
 	return rc;
-
-probe_err_register:
-	kfree((struct dma_desc *)KSEG0ADDR(lp->td_ring));
-probe_err_td_ring:
-	iounmap(lp->tx_dma_regs);
-probe_err_dma_tx:
-	iounmap(lp->rx_dma_regs);
-probe_err_dma_rx:
-	iounmap(lp->eth_regs);
-probe_err_out:
-	free_netdev(dev);
-	goto out;
 }
 
 static int korina_remove(struct platform_device *pdev)
@@ -1149,13 +1131,9 @@ static int korina_remove(struct platform_device *pdev)
 	struct korina_device *bif = platform_get_drvdata(pdev);
 	struct korina_private *lp = netdev_priv(bif->dev);
 
-	iounmap(lp->eth_regs);
-	iounmap(lp->rx_dma_regs);
-	iounmap(lp->tx_dma_regs);
 	kfree((struct dma_desc *)KSEG0ADDR(lp->td_ring));
 
 	unregister_netdev(bif->dev);
-	free_netdev(bif->dev);
 
 	return 0;
 }
-- 
2.29.2

