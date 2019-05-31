Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2FDF314B0
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 20:30:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727175AbfEaSab (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 14:30:31 -0400
Received: from sed198n136.SEDSystems.ca ([198.169.180.136]:25532 "EHLO
        sed198n136.sedsystems.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727163AbfEaSaa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 14:30:30 -0400
X-Greylist: delayed 854 seconds by postgrey-1.27 at vger.kernel.org; Fri, 31 May 2019 14:30:19 EDT
Received: from barney.sedsystems.ca (barney [198.169.180.121])
        by sed198n136.sedsystems.ca  with ESMTP id x4VIGLkp009532
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 31 May 2019 12:16:21 -0600 (CST)
Received: from SED.RFC1918.192.168.sedsystems.ca (eng1n65.eng.sedsystems.ca [172.21.1.65])
        by barney.sedsystems.ca (8.14.7/8.14.4) with ESMTP id x4VIG5Dm043766
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Fri, 31 May 2019 12:16:13 -0600
From:   Robert Hancock <hancock@sedsystems.ca>
To:     netdev@vger.kernel.org
Cc:     anirudh@xilinx.com, John.Linn@xilinx.com,
        Robert Hancock <hancock@sedsystems.ca>
Subject: [PATCH net-next 04/13] net: axienet: Make RX/TX ring sizes configurable
Date:   Fri, 31 May 2019 12:15:36 -0600
Message-Id: <1559326545-28825-5-git-send-email-hancock@sedsystems.ca>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1559326545-28825-1-git-send-email-hancock@sedsystems.ca>
References: <1559326545-28825-1-git-send-email-hancock@sedsystems.ca>
X-Scanned-By: MIMEDefang 2.64 on 198.169.180.136
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for setting the RX and TX ring sizes for this driver using
ethtool. Also increase the default RX ring size as the previous default
was far too low for good performance in some configurations.

Signed-off-by: Robert Hancock <hancock@sedsystems.ca>
---
 drivers/net/ethernet/xilinx/xilinx_axienet.h      |  2 +
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c | 90 ++++++++++++++++-------
 2 files changed, 67 insertions(+), 25 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet.h b/drivers/net/ethernet/xilinx/xilinx_axienet.h
index 4d39164..4cd92fe 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet.h
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet.h
@@ -444,8 +444,10 @@ struct axienet_local {
 	/* Buffer descriptors */
 	struct axidma_bd *tx_bd_v;
 	dma_addr_t tx_bd_p;
+	u32 tx_bd_num;
 	struct axidma_bd *rx_bd_v;
 	dma_addr_t rx_bd_p;
+	u32 rx_bd_num;
 	u32 tx_bd_ci;
 	u32 tx_bd_tail;
 	u32 rx_bd_ci;
diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index 3b683ea..decd16e 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -38,9 +38,11 @@
 
 #include "xilinx_axienet.h"
 
-/* Descriptors defines for Tx and Rx DMA - 2^n for the best performance */
-#define TX_BD_NUM		64
-#define RX_BD_NUM		128
+/* Descriptors defines for Tx and Rx DMA */
+#define TX_BD_NUM_DEFAULT		64
+#define RX_BD_NUM_DEFAULT		1024
+#define TX_BD_NUM_MAX			4096
+#define RX_BD_NUM_MAX			4096
 
 /* Must be shorter than length of ethtool_drvinfo.driver field to fit */
 #define DRIVER_NAME		"xaxienet"
@@ -164,7 +166,7 @@ static void axienet_dma_bd_release(struct net_device *ndev)
 	int i;
 	struct axienet_local *lp = netdev_priv(ndev);
 
-	for (i = 0; i < RX_BD_NUM; i++) {
+	for (i = 0; i < lp->rx_bd_num; i++) {
 		dma_unmap_single(ndev->dev.parent, lp->rx_bd_v[i].phys,
 				 lp->max_frm_size, DMA_FROM_DEVICE);
 		dev_kfree_skb(lp->rx_bd_v[i].skb);
@@ -172,13 +174,13 @@ static void axienet_dma_bd_release(struct net_device *ndev)
 
 	if (lp->rx_bd_v) {
 		dma_free_coherent(ndev->dev.parent,
-				  sizeof(*lp->rx_bd_v) * RX_BD_NUM,
+				  sizeof(*lp->rx_bd_v) * lp->rx_bd_num,
 				  lp->rx_bd_v,
 				  lp->rx_bd_p);
 	}
 	if (lp->tx_bd_v) {
 		dma_free_coherent(ndev->dev.parent,
-				  sizeof(*lp->tx_bd_v) * TX_BD_NUM,
+				  sizeof(*lp->tx_bd_v) * lp->tx_bd_num,
 				  lp->tx_bd_v,
 				  lp->tx_bd_p);
 	}
@@ -208,27 +210,27 @@ static int axienet_dma_bd_init(struct net_device *ndev)
 
 	/* Allocate the Tx and Rx buffer descriptors. */
 	lp->tx_bd_v = dma_alloc_coherent(ndev->dev.parent,
-					 sizeof(*lp->tx_bd_v) * TX_BD_NUM,
+					 sizeof(*lp->tx_bd_v) * lp->tx_bd_num,
 					 &lp->tx_bd_p, GFP_KERNEL);
 	if (!lp->tx_bd_v)
 		goto out;
 
 	lp->rx_bd_v = dma_alloc_coherent(ndev->dev.parent,
-					 sizeof(*lp->rx_bd_v) * RX_BD_NUM,
+					 sizeof(*lp->rx_bd_v) * lp->rx_bd_num,
 					 &lp->rx_bd_p, GFP_KERNEL);
 	if (!lp->rx_bd_v)
 		goto out;
 
-	for (i = 0; i < TX_BD_NUM; i++) {
+	for (i = 0; i < lp->tx_bd_num; i++) {
 		lp->tx_bd_v[i].next = lp->tx_bd_p +
 				      sizeof(*lp->tx_bd_v) *
-				      ((i + 1) % TX_BD_NUM);
+				      ((i + 1) % lp->tx_bd_num);
 	}
 
-	for (i = 0; i < RX_BD_NUM; i++) {
+	for (i = 0; i < lp->rx_bd_num; i++) {
 		lp->rx_bd_v[i].next = lp->rx_bd_p +
 				      sizeof(*lp->rx_bd_v) *
-				      ((i + 1) % RX_BD_NUM);
+				      ((i + 1) % lp->rx_bd_num);
 
 		skb = netdev_alloc_skb_ip_align(ndev, lp->max_frm_size);
 		if (!skb)
@@ -276,7 +278,7 @@ static int axienet_dma_bd_init(struct net_device *ndev)
 	axienet_dma_out32(lp, XAXIDMA_RX_CR_OFFSET,
 			  cr | XAXIDMA_CR_RUNSTOP_MASK);
 	axienet_dma_out32(lp, XAXIDMA_RX_TDESC_OFFSET, lp->rx_bd_p +
-			  (sizeof(*lp->rx_bd_v) * (RX_BD_NUM - 1)));
+			  (sizeof(*lp->rx_bd_v) * (lp->rx_bd_num - 1)));
 
 	/* Write to the RS (Run-stop) bit in the Tx channel control register.
 	 * Tx channel is now ready to run. But only after we write to the
@@ -617,8 +619,8 @@ static void axienet_start_xmit_done(struct net_device *ndev)
 		size += status & XAXIDMA_BD_STS_ACTUAL_LEN_MASK;
 		packets++;
 
-		++lp->tx_bd_ci;
-		lp->tx_bd_ci %= TX_BD_NUM;
+		if (++lp->tx_bd_ci >= lp->tx_bd_num)
+			lp->tx_bd_ci = 0;
 		cur_p = &lp->tx_bd_v[lp->tx_bd_ci];
 		status = cur_p->status;
 	}
@@ -645,7 +647,7 @@ static inline int axienet_check_tx_bd_space(struct axienet_local *lp,
 					    int num_frag)
 {
 	struct axidma_bd *cur_p;
-	cur_p = &lp->tx_bd_v[(lp->tx_bd_tail + num_frag) % TX_BD_NUM];
+	cur_p = &lp->tx_bd_v[(lp->tx_bd_tail + num_frag) % lp->tx_bd_num];
 	if (cur_p->status & XAXIDMA_BD_STS_ALL_MASK)
 		return NETDEV_TX_BUSY;
 	return 0;
@@ -705,8 +707,8 @@ static inline int axienet_check_tx_bd_space(struct axienet_local *lp,
 				     skb_headlen(skb), DMA_TO_DEVICE);
 
 	for (ii = 0; ii < num_frag; ii++) {
-		++lp->tx_bd_tail;
-		lp->tx_bd_tail %= TX_BD_NUM;
+		if (++lp->tx_bd_tail >= lp->tx_bd_num)
+			lp->tx_bd_tail = 0;
 		cur_p = &lp->tx_bd_v[lp->tx_bd_tail];
 		frag = &skb_shinfo(skb)->frags[ii];
 		cur_p->phys = dma_map_single(ndev->dev.parent,
@@ -722,8 +724,8 @@ static inline int axienet_check_tx_bd_space(struct axienet_local *lp,
 	tail_p = lp->tx_bd_p + sizeof(*lp->tx_bd_v) * lp->tx_bd_tail;
 	/* Start the transfer */
 	axienet_dma_out32(lp, XAXIDMA_TX_TDESC_OFFSET, tail_p);
-	++lp->tx_bd_tail;
-	lp->tx_bd_tail %= TX_BD_NUM;
+	if (++lp->tx_bd_tail >= lp->tx_bd_num)
+		lp->tx_bd_tail = 0;
 
 	return NETDEV_TX_OK;
 }
@@ -797,8 +799,8 @@ static void axienet_recv(struct net_device *ndev)
 		cur_p->status = 0;
 		cur_p->skb = new_skb;
 
-		++lp->rx_bd_ci;
-		lp->rx_bd_ci %= RX_BD_NUM;
+		if (++lp->rx_bd_ci >= lp->rx_bd_num)
+			lp->rx_bd_ci = 0;
 		cur_p = &lp->rx_bd_v[lp->rx_bd_ci];
 	}
 
@@ -1179,6 +1181,40 @@ static void axienet_ethtools_get_regs(struct net_device *ndev,
 	data[31] = axienet_ior(lp, XAE_AF1_OFFSET);
 }
 
+static void axienet_ethtools_get_ringparam(struct net_device *ndev,
+					   struct ethtool_ringparam *ering)
+{
+	struct axienet_local *lp = netdev_priv(ndev);
+
+	ering->rx_max_pending = RX_BD_NUM_MAX;
+	ering->rx_mini_max_pending = 0;
+	ering->rx_jumbo_max_pending = 0;
+	ering->tx_max_pending = TX_BD_NUM_MAX;
+	ering->rx_pending = lp->rx_bd_num;
+	ering->rx_mini_pending = 0;
+	ering->rx_jumbo_pending = 0;
+	ering->tx_pending = lp->tx_bd_num;
+}
+
+static int axienet_ethtools_set_ringparam(struct net_device *ndev,
+					  struct ethtool_ringparam *ering)
+{
+	struct axienet_local *lp = netdev_priv(ndev);
+
+	if (ering->rx_pending > RX_BD_NUM_MAX ||
+	    ering->rx_mini_pending ||
+	    ering->rx_jumbo_pending ||
+	    ering->rx_pending > TX_BD_NUM_MAX)
+		return -EINVAL;
+
+	if (netif_running(ndev))
+		return -EBUSY;
+
+	lp->rx_bd_num = ering->rx_pending;
+	lp->tx_bd_num = ering->tx_pending;
+	return 0;
+}
+
 /**
  * axienet_ethtools_get_pauseparam - Get the pause parameter setting for
  *				     Tx and Rx paths.
@@ -1320,6 +1356,8 @@ static int axienet_ethtools_set_coalesce(struct net_device *ndev,
 	.get_regs_len   = axienet_ethtools_get_regs_len,
 	.get_regs       = axienet_ethtools_get_regs,
 	.get_link       = ethtool_op_get_link,
+	.get_ringparam	= axienet_ethtools_get_ringparam,
+	.set_ringparam	= axienet_ethtools_set_ringparam,
 	.get_pauseparam = axienet_ethtools_get_pauseparam,
 	.set_pauseparam = axienet_ethtools_set_pauseparam,
 	.get_coalesce   = axienet_ethtools_get_coalesce,
@@ -1354,7 +1392,7 @@ static void axienet_dma_err_handler(unsigned long data)
 	__axienet_device_reset(lp);
 	axienet_mdio_enable(lp);
 
-	for (i = 0; i < TX_BD_NUM; i++) {
+	for (i = 0; i < lp->tx_bd_num; i++) {
 		cur_p = &lp->tx_bd_v[i];
 		if (cur_p->phys)
 			dma_unmap_single(ndev->dev.parent, cur_p->phys,
@@ -1374,7 +1412,7 @@ static void axienet_dma_err_handler(unsigned long data)
 		cur_p->skb = NULL;
 	}
 
-	for (i = 0; i < RX_BD_NUM; i++) {
+	for (i = 0; i < lp->rx_bd_num; i++) {
 		cur_p = &lp->rx_bd_v[i];
 		cur_p->status = 0;
 		cur_p->app0 = 0;
@@ -1422,7 +1460,7 @@ static void axienet_dma_err_handler(unsigned long data)
 	axienet_dma_out32(lp, XAXIDMA_RX_CR_OFFSET,
 			  cr | XAXIDMA_CR_RUNSTOP_MASK);
 	axienet_dma_out32(lp, XAXIDMA_RX_TDESC_OFFSET, lp->rx_bd_p +
-			  (sizeof(*lp->rx_bd_v) * (RX_BD_NUM - 1)));
+			  (sizeof(*lp->rx_bd_v) * (lp->rx_bd_num - 1)));
 
 	/* Write to the RS (Run-stop) bit in the Tx channel control register.
 	 * Tx channel is now ready to run. But only after we write to the
@@ -1494,6 +1532,8 @@ static int axienet_probe(struct platform_device *pdev)
 	lp->ndev = ndev;
 	lp->dev = &pdev->dev;
 	lp->options = XAE_OPTION_DEFAULTS;
+	lp->rx_bd_num = RX_BD_NUM_DEFAULT;
+	lp->tx_bd_num = TX_BD_NUM_DEFAULT;
 	/* Map device registers */
 	ethres = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	lp->regs_start = ethres->start;
-- 
1.8.3.1

