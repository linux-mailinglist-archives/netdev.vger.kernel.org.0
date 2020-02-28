Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3FDA173239
	for <lists+netdev@lfdr.de>; Fri, 28 Feb 2020 08:57:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726714AbgB1H5d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Feb 2020 02:57:33 -0500
Received: from first.geanix.com ([116.203.34.67]:36212 "EHLO first.geanix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725928AbgB1H5d (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 Feb 2020 02:57:33 -0500
Received: from localhost (87-49-45-242-mobile.dk.customer.tdc.net [87.49.45.242])
        by first.geanix.com (Postfix) with ESMTPSA id 2C25EC109A;
        Fri, 28 Feb 2020 07:57:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=geanix.com; s=first;
        t=1582876650; bh=pu008Gz3YHiKBnfA0wxxtEqP1jcbiBf1/bcj+C4AoHk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=JX+7pLD4aWaYRlHul/UghvCnT4wEtF6vAmJk74bOwPls8LhBwWSwJtAa9BKJLoyRd
         vk5EBPM/Z6b8qA93mI7Xt2qBKA6R33txnFM8njBw6+ECiTE5KSxgqtBiGwe8L2zVRC
         cIniguP1sxPvIHrjt8uauqilzRCKkL9k34Fek+66HLv1uw4URhxdWiHu+K9GyyydS4
         iARb8cy2gCUFwrSScC0A2oKqkoqfjjfb454Mn/osamVTRQLjsDT3mxIpy7+IYo6n6N
         eLZOr7hgBMrh0mKjGv/JwWADUnerPrBi4iNg+UHb/orQHczdRmw3BVKTYvJn98INpd
         9cT0FV3De3eQg==
From:   Esben Haabendal <esben@geanix.com>
To:     netdev@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org, Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Michal Simek <michal.simek@xilinx.com>,
        =?UTF-8?q?Petr=20=C5=A0tetiar?= <ynezz@true.cz>
Subject: [PATCH net-next 3/4] net: ll_temac: Make RX/TX ring sizes configurable
Date:   Fri, 28 Feb 2020 08:57:26 +0100
Message-Id: <dcd3bb411ba861afcd19b9ba56def01d47c3bce7.1582875715.git.esben@geanix.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1582875715.git.esben@geanix.com>
References: <cover.1582875715.git.esben@geanix.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=4.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,UNPARSEABLE_RELAY,URIBL_BLOCKED
        autolearn=disabled version=3.4.4
X-Spam-Checker-Version: SpamAssassin 3.4.4 (2020-01-24) on 05ff821c8cf1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for setting the RX and TX ring sizes for this driver using
ethtool. Also increase the default RX ring size as the previous default
was far too low for good performance in some configurations.

Signed-off-by: Esben Haabendal <esben@geanix.com>
---
 drivers/net/ethernet/xilinx/ll_temac.h      |  2 +
 drivers/net/ethernet/xilinx/ll_temac_main.c | 96 +++++++++++++++------
 2 files changed, 72 insertions(+), 26 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/ll_temac.h b/drivers/net/ethernet/xilinx/ll_temac.h
index 463ef9eaf42d..8777ec6e21c8 100644
--- a/drivers/net/ethernet/xilinx/ll_temac.h
+++ b/drivers/net/ethernet/xilinx/ll_temac.h
@@ -369,8 +369,10 @@ struct temac_local {
 	/* Buffer descriptors */
 	struct cdmac_bd *tx_bd_v;
 	dma_addr_t tx_bd_p;
+	u32 tx_bd_num;
 	struct cdmac_bd *rx_bd_v;
 	dma_addr_t rx_bd_p;
+	u32 rx_bd_num;
 	int tx_bd_ci;
 	int tx_bd_tail;
 	int rx_bd_ci;
diff --git a/drivers/net/ethernet/xilinx/ll_temac_main.c b/drivers/net/ethernet/xilinx/ll_temac_main.c
index d6853c44e672..5735acb44b57 100644
--- a/drivers/net/ethernet/xilinx/ll_temac_main.c
+++ b/drivers/net/ethernet/xilinx/ll_temac_main.c
@@ -58,8 +58,11 @@
 
 #include "ll_temac.h"
 
-#define TX_BD_NUM   64
-#define RX_BD_NUM   128
+/* Descriptors defines for Tx and Rx DMA */
+#define TX_BD_NUM_DEFAULT		64
+#define RX_BD_NUM_DEFAULT		1024
+#define TX_BD_NUM_MAX			4096
+#define RX_BD_NUM_MAX			4096
 
 /* ---------------------------------------------------------------------
  * Low level register access functions
@@ -301,7 +304,7 @@ static void temac_dma_bd_release(struct net_device *ndev)
 	/* Reset Local Link (DMA) */
 	lp->dma_out(lp, DMA_CONTROL_REG, DMA_CONTROL_RST);
 
-	for (i = 0; i < RX_BD_NUM; i++) {
+	for (i = 0; i < lp->rx_bd_num; i++) {
 		if (!lp->rx_skb[i])
 			break;
 		else {
@@ -312,12 +315,12 @@ static void temac_dma_bd_release(struct net_device *ndev)
 	}
 	if (lp->rx_bd_v)
 		dma_free_coherent(ndev->dev.parent,
-				sizeof(*lp->rx_bd_v) * RX_BD_NUM,
-				lp->rx_bd_v, lp->rx_bd_p);
+				  sizeof(*lp->rx_bd_v) * lp->rx_bd_num,
+				  lp->rx_bd_v, lp->rx_bd_p);
 	if (lp->tx_bd_v)
 		dma_free_coherent(ndev->dev.parent,
-				sizeof(*lp->tx_bd_v) * TX_BD_NUM,
-				lp->tx_bd_v, lp->tx_bd_p);
+				  sizeof(*lp->tx_bd_v) * lp->tx_bd_num,
+				  lp->tx_bd_v, lp->tx_bd_p);
 }
 
 /**
@@ -330,33 +333,33 @@ static int temac_dma_bd_init(struct net_device *ndev)
 	dma_addr_t skb_dma_addr;
 	int i;
 
-	lp->rx_skb = devm_kcalloc(&ndev->dev, RX_BD_NUM, sizeof(*lp->rx_skb),
-				  GFP_KERNEL);
+	lp->rx_skb = devm_kcalloc(&ndev->dev, lp->rx_bd_num,
+				  sizeof(*lp->rx_skb), GFP_KERNEL);
 	if (!lp->rx_skb)
 		goto out;
 
 	/* allocate the tx and rx ring buffer descriptors. */
 	/* returns a virtual address and a physical address. */
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
 		lp->tx_bd_v[i].next = cpu_to_be32(lp->tx_bd_p
-				+ sizeof(*lp->tx_bd_v) * ((i + 1) % TX_BD_NUM));
+			+ sizeof(*lp->tx_bd_v) * ((i + 1) % lp->tx_bd_num));
 	}
 
-	for (i = 0; i < RX_BD_NUM; i++) {
+	for (i = 0; i < lp->rx_bd_num; i++) {
 		lp->rx_bd_v[i].next = cpu_to_be32(lp->rx_bd_p
-				+ sizeof(*lp->rx_bd_v) * ((i + 1) % RX_BD_NUM));
+			+ sizeof(*lp->rx_bd_v) * ((i + 1) % lp->rx_bd_num));
 
 		skb = netdev_alloc_skb_ip_align(ndev,
 						XTE_MAX_JUMBO_FRAME_SIZE);
@@ -389,7 +392,7 @@ static int temac_dma_bd_init(struct net_device *ndev)
 	lp->tx_bd_ci = 0;
 	lp->tx_bd_tail = 0;
 	lp->rx_bd_ci = 0;
-	lp->rx_bd_tail = RX_BD_NUM - 1;
+	lp->rx_bd_tail = lp->rx_bd_num - 1;
 
 	/* Enable RX DMA transfers */
 	wmb();
@@ -784,7 +787,7 @@ static void temac_start_xmit_done(struct net_device *ndev)
 		ndev->stats.tx_bytes += be32_to_cpu(cur_p->len);
 
 		lp->tx_bd_ci++;
-		if (lp->tx_bd_ci >= TX_BD_NUM)
+		if (lp->tx_bd_ci >= lp->tx_bd_num)
 			lp->tx_bd_ci = 0;
 
 		cur_p = &lp->tx_bd_v[lp->tx_bd_ci];
@@ -810,7 +813,7 @@ static inline int temac_check_tx_bd_space(struct temac_local *lp, int num_frag)
 			return NETDEV_TX_BUSY;
 
 		tail++;
-		if (tail >= TX_BD_NUM)
+		if (tail >= lp->tx_bd_num)
 			tail = 0;
 
 		cur_p = &lp->tx_bd_v[tail];
@@ -874,7 +877,7 @@ temac_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 	ptr_to_txbd((void *)skb, cur_p);
 
 	for (ii = 0; ii < num_frag; ii++) {
-		if (++lp->tx_bd_tail >= TX_BD_NUM)
+		if (++lp->tx_bd_tail >= lp->tx_bd_num)
 			lp->tx_bd_tail = 0;
 
 		cur_p = &lp->tx_bd_v[lp->tx_bd_tail];
@@ -884,7 +887,7 @@ temac_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 					      DMA_TO_DEVICE);
 		if (dma_mapping_error(ndev->dev.parent, skb_dma_addr)) {
 			if (--lp->tx_bd_tail < 0)
-				lp->tx_bd_tail = TX_BD_NUM - 1;
+				lp->tx_bd_tail = lp->tx_bd_num - 1;
 			cur_p = &lp->tx_bd_v[lp->tx_bd_tail];
 			while (--ii >= 0) {
 				--frag;
@@ -893,7 +896,7 @@ temac_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 						 skb_frag_size(frag),
 						 DMA_TO_DEVICE);
 				if (--lp->tx_bd_tail < 0)
-					lp->tx_bd_tail = TX_BD_NUM - 1;
+					lp->tx_bd_tail = lp->tx_bd_num - 1;
 				cur_p = &lp->tx_bd_v[lp->tx_bd_tail];
 			}
 			dma_unmap_single(ndev->dev.parent,
@@ -912,7 +915,7 @@ temac_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 
 	tail_p = lp->tx_bd_p + sizeof(*lp->tx_bd_v) * lp->tx_bd_tail;
 	lp->tx_bd_tail++;
-	if (lp->tx_bd_tail >= TX_BD_NUM)
+	if (lp->tx_bd_tail >= lp->tx_bd_num)
 		lp->tx_bd_tail = 0;
 
 	skb_tx_timestamp(skb);
@@ -932,7 +935,7 @@ static int ll_temac_recv_buffers_available(struct temac_local *lp)
 		return 0;
 	available = 1 + lp->rx_bd_tail - lp->rx_bd_ci;
 	if (available <= 0)
-		available += RX_BD_NUM;
+		available += lp->rx_bd_num;
 	return available;
 }
 
@@ -1001,7 +1004,7 @@ static void ll_temac_recv(struct net_device *ndev)
 		ndev->stats.rx_bytes += length;
 
 		rx_bd = lp->rx_bd_ci;
-		if (++lp->rx_bd_ci >= RX_BD_NUM)
+		if (++lp->rx_bd_ci >= lp->rx_bd_num)
 			lp->rx_bd_ci = 0;
 	} while (rx_bd != lp->rx_bd_tail);
 
@@ -1032,7 +1035,7 @@ static void ll_temac_recv(struct net_device *ndev)
 		dma_addr_t skb_dma_addr;
 
 		rx_bd = lp->rx_bd_tail + 1;
-		if (rx_bd >= RX_BD_NUM)
+		if (rx_bd >= lp->rx_bd_num)
 			rx_bd = 0;
 		bd = &lp->rx_bd_v[rx_bd];
 
@@ -1248,13 +1251,52 @@ static const struct attribute_group temac_attr_group = {
 	.attrs = temac_device_attrs,
 };
 
-/* ethtool support */
+/* ---------------------------------------------------------------------
+ * ethtool support
+ */
+
+static void ll_temac_ethtools_get_ringparam(struct net_device *ndev,
+					    struct ethtool_ringparam *ering)
+{
+	struct temac_local *lp = netdev_priv(ndev);
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
+static int ll_temac_ethtools_set_ringparam(struct net_device *ndev,
+					   struct ethtool_ringparam *ering)
+{
+	struct temac_local *lp = netdev_priv(ndev);
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
 static const struct ethtool_ops temac_ethtool_ops = {
 	.nway_reset = phy_ethtool_nway_reset,
 	.get_link = ethtool_op_get_link,
 	.get_ts_info = ethtool_op_get_ts_info,
 	.get_link_ksettings = phy_ethtool_get_link_ksettings,
 	.set_link_ksettings = phy_ethtool_set_link_ksettings,
+	.get_ringparam	= ll_temac_ethtools_get_ringparam,
+	.set_ringparam	= ll_temac_ethtools_set_ringparam,
 };
 
 static int temac_probe(struct platform_device *pdev)
@@ -1298,6 +1340,8 @@ static int temac_probe(struct platform_device *pdev)
 	lp->ndev = ndev;
 	lp->dev = &pdev->dev;
 	lp->options = XTE_OPTION_DEFAULTS;
+	lp->rx_bd_num = RX_BD_NUM_DEFAULT;
+	lp->tx_bd_num = TX_BD_NUM_DEFAULT;
 	spin_lock_init(&lp->rx_lock);
 	INIT_DELAYED_WORK(&lp->restart_work, ll_temac_restart_work_func);
 
-- 
2.25.1

