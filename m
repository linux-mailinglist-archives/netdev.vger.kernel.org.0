Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25C2E380BE
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 00:29:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729324AbfFFW3s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 18:29:48 -0400
Received: from sed198n136.SEDSystems.ca ([198.169.180.136]:14443 "EHLO
        sed198n136.sedsystems.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727450AbfFFW3Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 18:29:25 -0400
Received: from barney.sedsystems.ca (barney [198.169.180.121])
        by sed198n136.sedsystems.ca  with ESMTP id x56MTHsl030178
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 6 Jun 2019 16:29:20 -0600 (CST)
Received: from SED.RFC1918.192.168.sedsystems.ca (eng1n65.eng.sedsystems.ca [172.21.1.65])
        by barney.sedsystems.ca (8.14.7/8.14.4) with ESMTP id x56MTAP8028001
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Thu, 6 Jun 2019 16:29:17 -0600
From:   Robert Hancock <hancock@sedsystems.ca>
To:     netdev@vger.kernel.org
Cc:     anirudh@xilinx.com, John.Linn@xilinx.com, andrew@lunn.ch,
        davem@davemloft.net, Robert Hancock <hancock@sedsystems.ca>
Subject: [PATCH net-next v5 09/20] net: axienet: Make RX/TX ring sizes configurable
Date:   Thu,  6 Jun 2019 16:28:13 -0600
Message-Id: <1559860104-927-10-git-send-email-hancock@sedsystems.ca>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1559860104-927-1-git-send-email-hancock@sedsystems.ca>
References: <1559860104-927-1-git-send-email-hancock@sedsystems.ca>
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
index 1ffb113..6b6d28f 100644
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
index bdc6e80..2c2d626 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -39,9 +39,11 @@
 
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
@@ -157,7 +159,7 @@ static void axienet_dma_bd_release(struct net_device *ndev)
 	int i;
 	struct axienet_local *lp = netdev_priv(ndev);
 
-	for (i = 0; i < RX_BD_NUM; i++) {
+	for (i = 0; i < lp->rx_bd_num; i++) {
 		dma_unmap_single(ndev->dev.parent, lp->rx_bd_v[i].phys,
 				 lp->max_frm_size, DMA_FROM_DEVICE);
 		dev_kfree_skb(lp->rx_bd_v[i].skb);
@@ -165,13 +167,13 @@ static void axienet_dma_bd_release(struct net_device *ndev)
 
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
@@ -201,27 +203,27 @@ static int axienet_dma_bd_init(struct net_device *ndev)
 
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
@@ -269,7 +271,7 @@ static int axienet_dma_bd_init(struct net_device *ndev)
 	axienet_dma_out32(lp, XAXIDMA_RX_CR_OFFSET,
 			  cr | XAXIDMA_CR_RUNSTOP_MASK);
 	axienet_dma_out32(lp, XAXIDMA_RX_TDESC_OFFSET, lp->rx_bd_p +
-			  (sizeof(*lp->rx_bd_v) * (RX_BD_NUM - 1)));
+			  (sizeof(*lp->rx_bd_v) * (lp->rx_bd_num - 1)));
 
 	/* Write to the RS (Run-stop) bit in the Tx channel control register.
 	 * Tx channel is now ready to run. But only after we write to the
@@ -610,8 +612,8 @@ static void axienet_start_xmit_done(struct net_device *ndev)
 		size += status & XAXIDMA_BD_STS_ACTUAL_LEN_MASK;
 		packets++;
 
-		++lp->tx_bd_ci;
-		lp->tx_bd_ci %= TX_BD_NUM;
+		if (++lp->tx_bd_ci >= lp->tx_bd_num)
+			lp->tx_bd_ci = 0;
 		cur_p = &lp->tx_bd_v[lp->tx_bd_ci];
 		status = cur_p->status;
 	}
@@ -638,7 +640,7 @@ static inline int axienet_check_tx_bd_space(struct axienet_local *lp,
 					    int num_frag)
 {
 	struct axidma_bd *cur_p;
-	cur_p = &lp->tx_bd_v[(lp->tx_bd_tail + num_frag) % TX_BD_NUM];
+	cur_p = &lp->tx_bd_v[(lp->tx_bd_tail + num_frag) % lp->tx_bd_num];
 	if (cur_p->status & XAXIDMA_BD_STS_ALL_MASK)
 		return NETDEV_TX_BUSY;
 	return 0;
@@ -698,8 +700,8 @@ static inline int axienet_check_tx_bd_space(struct axienet_local *lp,
 				     skb_headlen(skb), DMA_TO_DEVICE);
 
 	for (ii = 0; ii < num_frag; ii++) {
-		++lp->tx_bd_tail;
-		lp->tx_bd_tail %= TX_BD_NUM;
+		if (++lp->tx_bd_tail >= lp->tx_bd_num)
+			lp->tx_bd_tail = 0;
 		cur_p = &lp->tx_bd_v[lp->tx_bd_tail];
 		frag = &skb_shinfo(skb)->frags[ii];
 		cur_p->phys = dma_map_single(ndev->dev.parent,
@@ -715,8 +717,8 @@ static inline int axienet_check_tx_bd_space(struct axienet_local *lp,
 	tail_p = lp->tx_bd_p + sizeof(*lp->tx_bd_v) * lp->tx_bd_tail;
 	/* Start the transfer */
 	axienet_dma_out32(lp, XAXIDMA_TX_TDESC_OFFSET, tail_p);
-	++lp->tx_bd_tail;
-	lp->tx_bd_tail %= TX_BD_NUM;
+	if (++lp->tx_bd_tail >= lp->tx_bd_num)
+		lp->tx_bd_tail = 0;
 
 	return NETDEV_TX_OK;
 }
@@ -790,8 +792,8 @@ static void axienet_recv(struct net_device *ndev)
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
@@ -1357,7 +1395,7 @@ static void axienet_dma_err_handler(unsigned long data)
 	axienet_mdio_enable(lp);
 	mutex_unlock(&lp->mii_bus->mdio_lock);
 
-	for (i = 0; i < TX_BD_NUM; i++) {
+	for (i = 0; i < lp->tx_bd_num; i++) {
 		cur_p = &lp->tx_bd_v[i];
 		if (cur_p->phys)
 			dma_unmap_single(ndev->dev.parent, cur_p->phys,
@@ -1377,7 +1415,7 @@ static void axienet_dma_err_handler(unsigned long data)
 		cur_p->skb = NULL;
 	}
 
-	for (i = 0; i < RX_BD_NUM; i++) {
+	for (i = 0; i < lp->rx_bd_num; i++) {
 		cur_p = &lp->rx_bd_v[i];
 		cur_p->status = 0;
 		cur_p->app0 = 0;
@@ -1425,7 +1463,7 @@ static void axienet_dma_err_handler(unsigned long data)
 	axienet_dma_out32(lp, XAXIDMA_RX_CR_OFFSET,
 			  cr | XAXIDMA_CR_RUNSTOP_MASK);
 	axienet_dma_out32(lp, XAXIDMA_RX_TDESC_OFFSET, lp->rx_bd_p +
-			  (sizeof(*lp->rx_bd_v) * (RX_BD_NUM - 1)));
+			  (sizeof(*lp->rx_bd_v) * (lp->rx_bd_num - 1)));
 
 	/* Write to the RS (Run-stop) bit in the Tx channel control register.
 	 * Tx channel is now ready to run. But only after we write to the
@@ -1497,6 +1535,8 @@ static int axienet_probe(struct platform_device *pdev)
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

