Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94F5C314B1
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 20:30:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727195AbfEaSai (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 14:30:38 -0400
Received: from sed198n136.SEDSystems.ca ([198.169.180.136]:25532 "EHLO
        sed198n136.sedsystems.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727173AbfEaSab (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 14:30:31 -0400
X-Greylist: delayed 854 seconds by postgrey-1.27 at vger.kernel.org; Fri, 31 May 2019 14:30:19 EDT
Received: from barney.sedsystems.ca (barney [198.169.180.121])
        by sed198n136.sedsystems.ca  with ESMTP id x4VIGBCj002567
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 31 May 2019 12:16:11 -0600 (CST)
Received: from SED.RFC1918.192.168.sedsystems.ca (eng1n65.eng.sedsystems.ca [172.21.1.65])
        by barney.sedsystems.ca (8.14.7/8.14.4) with ESMTP id x4VIG5Dj043766
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Fri, 31 May 2019 12:16:11 -0600
From:   Robert Hancock <hancock@sedsystems.ca>
To:     netdev@vger.kernel.org
Cc:     anirudh@xilinx.com, John.Linn@xilinx.com,
        Robert Hancock <hancock@sedsystems.ca>
Subject: [PATCH net-next 01/13] net: axienet: Fixed 64-bit compile, enable build on X86 and ARM
Date:   Fri, 31 May 2019 12:15:33 -0600
Message-Id: <1559326545-28825-2-git-send-email-hancock@sedsystems.ca>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1559326545-28825-1-git-send-email-hancock@sedsystems.ca>
References: <1559326545-28825-1-git-send-email-hancock@sedsystems.ca>
X-Scanned-By: MIMEDefang 2.64 on 198.169.180.136
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixed some 64-bit issues in this driver, such as casting skb pointers to
32-bit values. Also changed the way the MDIO bus name was constructed so
that it works in all cases.

Signed-off-by: Robert Hancock <hancock@sedsystems.ca>
---
 drivers/net/ethernet/xilinx/Kconfig               |  4 +--
 drivers/net/ethernet/xilinx/xilinx_axienet.h      | 25 +++++++++------
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c | 39 +++++++++++++++--------
 drivers/net/ethernet/xilinx/xilinx_axienet_mdio.c | 11 +++----
 4 files changed, 47 insertions(+), 32 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/Kconfig b/drivers/net/ethernet/xilinx/Kconfig
index af96e05..f0b6896 100644
--- a/drivers/net/ethernet/xilinx/Kconfig
+++ b/drivers/net/ethernet/xilinx/Kconfig
@@ -6,7 +6,7 @@
 config NET_VENDOR_XILINX
 	bool "Xilinx devices"
 	default y
-	depends on PPC || PPC32 || MICROBLAZE || ARCH_ZYNQ || MIPS || X86 || COMPILE_TEST
+	depends on PPC || PPC32 || MICROBLAZE || ARCH_ZYNQ || MIPS || X86 || ARM || COMPILE_TEST
 	---help---
 	  If you have a network (Ethernet) card belonging to this class, say Y.
 
@@ -26,7 +26,7 @@ config XILINX_EMACLITE
 
 config XILINX_AXI_EMAC
 	tristate "Xilinx 10/100/1000 AXI Ethernet support"
-	depends on MICROBLAZE
+	depends on MICROBLAZE || X86 || ARM
 	select PHYLIB
 	---help---
 	  This driver supports the 10/100/1000 Ethernet from Xilinx for the
diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet.h b/drivers/net/ethernet/xilinx/xilinx_axienet.h
index 011adae..0d89ebc 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet.h
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet.h
@@ -356,9 +356,6 @@
  * @app2:         MM2S/S2MM User Application Field 2.
  * @app3:         MM2S/S2MM User Application Field 3.
  * @app4:         MM2S/S2MM User Application Field 4.
- * @sw_id_offset: MM2S/S2MM Sw ID
- * @reserved5:    Reserved and not used
- * @reserved6:    Reserved and not used
  */
 struct axidma_bd {
 	u32 next;	/* Physical address of next buffer descriptor */
@@ -373,11 +370,9 @@ struct axidma_bd {
 	u32 app1;	/* TX start << 16 | insert */
 	u32 app2;	/* TX csum seed */
 	u32 app3;
-	u32 app4;
-	u32 sw_id_offset;
-	u32 reserved5;
-	u32 reserved6;
-};
+	u32 app4;   /* Last field used by HW */
+	struct sk_buff *skb;
+} __aligned(XAXIDMA_BD_MINIMUM_ALIGNMENT);
 
 /**
  * struct axienet_local - axienet private per device data
@@ -385,6 +380,7 @@ struct axidma_bd {
  * @dev:	Pointer to device structure
  * @phy_node:	Pointer to device node structure
  * @mii_bus:	Pointer to MII bus structure
+ * @regs_start: Resource start for axienet device addresses
  * @regs:	Base address for the axienet_local device address space
  * @dma_regs:	Base address for the axidma device address space
  * @dma_err_tasklet: Tasklet structure to process Axi DMA errors
@@ -426,6 +422,7 @@ struct axienet_local {
 	struct mii_bus *mii_bus;	/* MII bus reference */
 
 	/* IO registers, dma functions and IRQs */
+	resource_size_t regs_start;
 	void __iomem *regs;
 	void __iomem *dma_regs;
 
@@ -481,7 +478,11 @@ struct axienet_option {
  */
 static inline u32 axienet_ior(struct axienet_local *lp, off_t offset)
 {
-	return in_be32(lp->regs + offset);
+#ifdef CONFIG_MICROBLAZE
+	return __raw_readl(lp->regs + offset);
+#else
+	return ioread32(lp->regs + offset);
+#endif
 }
 
 static inline u32 axinet_ior_read_mcr(struct axienet_local *lp)
@@ -501,7 +502,11 @@ static inline u32 axinet_ior_read_mcr(struct axienet_local *lp)
 static inline void axienet_iow(struct axienet_local *lp, off_t offset,
 			       u32 value)
 {
-	out_be32((lp->regs + offset), value);
+#ifdef CONFIG_MICROBLAZE
+	__raw_writel(value, lp->regs + offset);
+#else
+	iowrite32(value, lp->regs + offset);
+#endif
 }
 
 /* Function prototypes visible in xilinx_axienet_mdio.c for other files */
diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index 831967f..c0a8861 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -125,7 +125,11 @@
  */
 static inline u32 axienet_dma_in32(struct axienet_local *lp, off_t reg)
 {
-	return in_be32(lp->dma_regs + reg);
+#ifdef CONFIG_MICROBLAZE
+	return __raw_readl(lp->dma_regs + reg);
+#else
+	return ioread32(lp->dma_regs + reg);
+#endif
 }
 
 /**
@@ -140,7 +144,11 @@ static inline u32 axienet_dma_in32(struct axienet_local *lp, off_t reg)
 static inline void axienet_dma_out32(struct axienet_local *lp,
 				     off_t reg, u32 value)
 {
-	out_be32((lp->dma_regs + reg), value);
+#ifdef CONFIG_MICROBLAZE
+	__raw_writel(value, lp->dma_regs + reg);
+#else
+	iowrite32(value, lp->dma_regs + reg);
+#endif
 }
 
 /**
@@ -159,8 +167,7 @@ static void axienet_dma_bd_release(struct net_device *ndev)
 	for (i = 0; i < RX_BD_NUM; i++) {
 		dma_unmap_single(ndev->dev.parent, lp->rx_bd_v[i].phys,
 				 lp->max_frm_size, DMA_FROM_DEVICE);
-		dev_kfree_skb((struct sk_buff *)
-			      (lp->rx_bd_v[i].sw_id_offset));
+		dev_kfree_skb(lp->rx_bd_v[i].skb);
 	}
 
 	if (lp->rx_bd_v) {
@@ -227,7 +234,7 @@ static int axienet_dma_bd_init(struct net_device *ndev)
 		if (!skb)
 			goto out;
 
-		lp->rx_bd_v[i].sw_id_offset = (u32) skb;
+		lp->rx_bd_v[i].skb = skb;
 		lp->rx_bd_v[i].phys = dma_map_single(ndev->dev.parent,
 						     skb->data,
 						     lp->max_frm_size,
@@ -595,14 +602,15 @@ static void axienet_start_xmit_done(struct net_device *ndev)
 		dma_unmap_single(ndev->dev.parent, cur_p->phys,
 				(cur_p->cntrl & XAXIDMA_BD_CTRL_LENGTH_MASK),
 				DMA_TO_DEVICE);
-		if (cur_p->app4)
-			dev_consume_skb_irq((struct sk_buff *)cur_p->app4);
+		if (cur_p->skb)
+			dev_consume_skb_irq(cur_p->skb);
 		/*cur_p->phys = 0;*/
 		cur_p->app0 = 0;
 		cur_p->app1 = 0;
 		cur_p->app2 = 0;
 		cur_p->app4 = 0;
 		cur_p->status = 0;
+		cur_p->skb = NULL;
 
 		size += status & XAXIDMA_BD_STS_ACTUAL_LEN_MASK;
 		packets++;
@@ -707,7 +715,7 @@ static inline int axienet_check_tx_bd_space(struct axienet_local *lp,
 	}
 
 	cur_p->cntrl |= XAXIDMA_BD_CTRL_TXEOF_MASK;
-	cur_p->app4 = (unsigned long)skb;
+	cur_p->skb = skb;
 
 	tail_p = lp->tx_bd_p + sizeof(*lp->tx_bd_v) * lp->tx_bd_tail;
 	/* Start the transfer */
@@ -742,13 +750,15 @@ static void axienet_recv(struct net_device *ndev)
 
 	while ((cur_p->status & XAXIDMA_BD_STS_COMPLETE_MASK)) {
 		tail_p = lp->rx_bd_p + sizeof(*lp->rx_bd_v) * lp->rx_bd_ci;
-		skb = (struct sk_buff *) (cur_p->sw_id_offset);
-		length = cur_p->app4 & 0x0000FFFF;
 
 		dma_unmap_single(ndev->dev.parent, cur_p->phys,
 				 lp->max_frm_size,
 				 DMA_FROM_DEVICE);
 
+		skb = cur_p->skb;
+		cur_p->skb = NULL;
+		length = cur_p->app4 & 0x0000FFFF;
+
 		skb_put(skb, length);
 		skb->protocol = eth_type_trans(skb, ndev);
 		/*skb_checksum_none_assert(skb);*/
@@ -783,7 +793,7 @@ static void axienet_recv(struct net_device *ndev)
 					     DMA_FROM_DEVICE);
 		cur_p->cntrl = lp->max_frm_size;
 		cur_p->status = 0;
-		cur_p->sw_id_offset = (u32) new_skb;
+		cur_p->skb = new_skb;
 
 		++lp->rx_bd_ci;
 		lp->rx_bd_ci %= RX_BD_NUM;
@@ -1343,8 +1353,8 @@ static void axienet_dma_err_handler(unsigned long data)
 					 (cur_p->cntrl &
 					  XAXIDMA_BD_CTRL_LENGTH_MASK),
 					 DMA_TO_DEVICE);
-		if (cur_p->app4)
-			dev_kfree_skb_irq((struct sk_buff *) cur_p->app4);
+		if (cur_p->skb)
+			dev_kfree_skb_irq(cur_p->skb);
 		cur_p->phys = 0;
 		cur_p->cntrl = 0;
 		cur_p->status = 0;
@@ -1353,7 +1363,7 @@ static void axienet_dma_err_handler(unsigned long data)
 		cur_p->app2 = 0;
 		cur_p->app3 = 0;
 		cur_p->app4 = 0;
-		cur_p->sw_id_offset = 0;
+		cur_p->skb = NULL;
 	}
 
 	for (i = 0; i < RX_BD_NUM; i++) {
@@ -1478,6 +1488,7 @@ static int axienet_probe(struct platform_device *pdev)
 	lp->options = XAE_OPTION_DEFAULTS;
 	/* Map device registers */
 	ethres = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	lp->regs_start = ethres->start;
 	lp->regs = devm_ioremap_resource(&pdev->dev, ethres);
 	if (IS_ERR(lp->regs)) {
 		dev_err(&pdev->dev, "could not map Axi Ethernet regs.\n");
diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_mdio.c b/drivers/net/ethernet/xilinx/xilinx_axienet_mdio.c
index 704babd..665ae1d 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_mdio.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_mdio.c
@@ -127,7 +127,7 @@ int axienet_mdio_setup(struct axienet_local *lp, struct device_node *np)
 	int ret;
 	u32 clk_div, host_clock;
 	struct mii_bus *bus;
-	struct resource res;
+	struct device_node *mdio_node;
 	struct device_node *np1;
 
 	/* clk_div can be calculated by deriving it from the equation:
@@ -199,10 +199,9 @@ int axienet_mdio_setup(struct axienet_local *lp, struct device_node *np)
 	if (!bus)
 		return -ENOMEM;
 
-	np1 = of_get_parent(lp->phy_node);
-	of_address_to_resource(np1, 0, &res);
-	snprintf(bus->id, MII_BUS_ID_SIZE, "%.8llx",
-		 (unsigned long long) res.start);
+	mdio_node = of_get_parent(lp->phy_node);
+	snprintf(bus->id, MII_BUS_ID_SIZE, "axienet-%.8llx",
+		 (unsigned long long)lp->regs_start);
 
 	bus->priv = lp;
 	bus->name = "Xilinx Axi Ethernet MDIO";
@@ -211,7 +210,7 @@ int axienet_mdio_setup(struct axienet_local *lp, struct device_node *np)
 	bus->parent = lp->dev;
 	lp->mii_bus = bus;
 
-	ret = of_mdiobus_register(bus, np1);
+	ret = of_mdiobus_register(bus, mdio_node);
 	if (ret) {
 		mdiobus_free(bus);
 		lp->mii_bus = NULL;
-- 
1.8.3.1

