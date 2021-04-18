Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE5EA363827
	for <lists+netdev@lfdr.de>; Mon, 19 Apr 2021 00:21:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237155AbhDRWUu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Apr 2021 18:20:50 -0400
Received: from mx2.suse.de ([195.135.220.15]:38318 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235645AbhDRWUY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 18 Apr 2021 18:20:24 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 91C7BB153;
        Sun, 18 Apr 2021 22:19:53 +0000 (UTC)
From:   Thomas Bogendoerfer <tsbogend@alpha.franken.de>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mips@vger.kernel.org
Subject: [PATCH v6 net-next 07/10] net: korina: Add support for device tree
Date:   Mon, 19 Apr 2021 00:19:45 +0200
Message-Id: <20210418221949.130779-8-tsbogend@alpha.franken.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210418221949.130779-1-tsbogend@alpha.franken.de>
References: <20210418221949.130779-1-tsbogend@alpha.franken.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If there is no mac address passed via platform data try to get it via
device tree and fall back to a random mac address, if all fail.

Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
---
 arch/mips/rb532/devices.c     | 20 +++++---------------
 drivers/net/ethernet/korina.c | 32 +++++++++++++++++++++++++-------
 2 files changed, 30 insertions(+), 22 deletions(-)

diff --git a/arch/mips/rb532/devices.c b/arch/mips/rb532/devices.c
index 5fc3c8ee4f31..04684990e28e 100644
--- a/arch/mips/rb532/devices.c
+++ b/arch/mips/rb532/devices.c
@@ -58,37 +58,27 @@ EXPORT_SYMBOL(get_latch_u5);
 
 static struct resource korina_dev0_res[] = {
 	{
-		.name = "korina_regs",
+		.name = "emac",
 		.start = ETH0_BASE_ADDR,
 		.end = ETH0_BASE_ADDR + sizeof(struct eth_regs),
 		.flags = IORESOURCE_MEM,
 	 }, {
-		.name = "korina_rx",
+		.name = "rx",
 		.start = ETH0_DMA_RX_IRQ,
 		.end = ETH0_DMA_RX_IRQ,
 		.flags = IORESOURCE_IRQ
 	}, {
-		.name = "korina_tx",
+		.name = "tx",
 		.start = ETH0_DMA_TX_IRQ,
 		.end = ETH0_DMA_TX_IRQ,
 		.flags = IORESOURCE_IRQ
 	}, {
-		.name = "korina_ovr",
-		.start = ETH0_RX_OVR_IRQ,
-		.end = ETH0_RX_OVR_IRQ,
-		.flags = IORESOURCE_IRQ
-	}, {
-		.name = "korina_und",
-		.start = ETH0_TX_UND_IRQ,
-		.end = ETH0_TX_UND_IRQ,
-		.flags = IORESOURCE_IRQ
-	}, {
-		.name = "korina_dma_rx",
+		.name = "dma_rx",
 		.start = ETH0_RX_DMA_ADDR,
 		.end = ETH0_RX_DMA_ADDR + DMA_CHAN_OFFSET - 1,
 		.flags = IORESOURCE_MEM,
 	 }, {
-		.name = "korina_dma_tx",
+		.name = "dma_tx",
 		.start = ETH0_TX_DMA_ADDR,
 		.end = ETH0_TX_DMA_ADDR + DMA_CHAN_OFFSET - 1,
 		.flags = IORESOURCE_MEM,
diff --git a/drivers/net/ethernet/korina.c b/drivers/net/ethernet/korina.c
index d6dbbdd43d7c..a1f53d7753ae 100644
--- a/drivers/net/ethernet/korina.c
+++ b/drivers/net/ethernet/korina.c
@@ -43,6 +43,8 @@
 #include <linux/ioport.h>
 #include <linux/iopoll.h>
 #include <linux/in.h>
+#include <linux/of_device.h>
+#include <linux/of_net.h>
 #include <linux/slab.h>
 #include <linux/string.h>
 #include <linux/delay.h>
@@ -1068,26 +1070,29 @@ static int korina_probe(struct platform_device *pdev)
 	SET_NETDEV_DEV(dev, &pdev->dev);
 	lp = netdev_priv(dev);
 
-	memcpy(dev->dev_addr, mac_addr, ETH_ALEN);
+	if (mac_addr)
+		ether_addr_copy(dev->dev_addr, mac_addr);
+	else if (of_get_mac_address(pdev->dev.of_node, dev->dev_addr) < 0)
+		eth_hw_addr_random(dev);
 
-	lp->rx_irq = platform_get_irq_byname(pdev, "korina_rx");
-	lp->tx_irq = platform_get_irq_byname(pdev, "korina_tx");
+	lp->rx_irq = platform_get_irq_byname(pdev, "rx");
+	lp->tx_irq = platform_get_irq_byname(pdev, "tx");
 
-	p = devm_platform_ioremap_resource_byname(pdev, "korina_regs");
+	p = devm_platform_ioremap_resource_byname(pdev, "emac");
 	if (!p) {
 		printk(KERN_ERR DRV_NAME ": cannot remap registers\n");
 		return -ENOMEM;
 	}
 	lp->eth_regs = p;
 
-	p = devm_platform_ioremap_resource_byname(pdev, "korina_dma_rx");
+	p = devm_platform_ioremap_resource_byname(pdev, "dma_rx");
 	if (!p) {
 		printk(KERN_ERR DRV_NAME ": cannot remap Rx DMA registers\n");
 		return -ENOMEM;
 	}
 	lp->rx_dma_regs = p;
 
-	p = devm_platform_ioremap_resource_byname(pdev, "korina_dma_tx");
+	p = devm_platform_ioremap_resource_byname(pdev, "dma_tx");
 	if (!p) {
 		printk(KERN_ERR DRV_NAME ": cannot remap Tx DMA registers\n");
 		return -ENOMEM;
@@ -1148,8 +1153,21 @@ static int korina_remove(struct platform_device *pdev)
 	return 0;
 }
 
+#ifdef CONFIG_OF
+static const struct of_device_id korina_match[] = {
+	{
+		.compatible = "idt,3243x-emac",
+	},
+	{ }
+};
+MODULE_DEVICE_TABLE(of, korina_match);
+#endif
+
 static struct platform_driver korina_driver = {
-	.driver.name = "korina",
+	.driver = {
+		.name = "korina",
+		.of_match_table = of_match_ptr(korina_match),
+	},
 	.probe = korina_probe,
 	.remove = korina_remove,
 };
-- 
2.29.2

