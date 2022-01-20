Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 404AA4947BC
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 08:03:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358923AbiATHCx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 02:02:53 -0500
Received: from mailgw01.mediatek.com ([60.244.123.138]:60422 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1358879AbiATHCo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jan 2022 02:02:44 -0500
X-UUID: a38643012e5d4eeb8e98916111748a21-20220120
X-UUID: a38643012e5d4eeb8e98916111748a21-20220120
Received: from mtkcas11.mediatek.inc [(172.21.101.40)] by mailgw01.mediatek.com
        (envelope-from <biao.huang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 765182154; Thu, 20 Jan 2022 15:02:41 +0800
Received: from mtkcas11.mediatek.inc (172.21.101.40) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.792.15; Thu, 20 Jan 2022 15:02:39 +0800
Received: from localhost.localdomain (10.17.3.154) by mtkcas11.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 20 Jan 2022 15:02:38 +0800
From:   Biao Huang <biao.huang@mediatek.com>
To:     David Miller <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Fabien Parent <fparent@baylibre.com>
CC:     Jakub Kicinski <kuba@kernel.org>, Felix Fietkau <nbd@nbd.name>,
        "John Crispin" <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>,
        Biao Huang <biao.huang@mediatek.com>,
        Yinghua Pan <ot_yinghua.pan@mediatek.com>,
        <srv_heupstream@mediatek.com>,
        Macpaul Lin <macpaul.lin@mediatek.com>
Subject: [PATCH net-next v1 9/9] net: ethernet: mtk-star-emac: separate tx/rx handling with two NAPIs
Date:   Thu, 20 Jan 2022 15:02:26 +0800
Message-ID: <20220120070226.1492-10-biao.huang@mediatek.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220120070226.1492-1-biao.huang@mediatek.com>
References: <20220120070226.1492-1-biao.huang@mediatek.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-MTK:  N
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Current driver may lost tx interrupts under bidirectional test with iperf3,
which leads to some unexpected issues.

This patch let rx/tx interrupt enable/disable separately, and rx/tx are
handled in different NAPIs.

Signed-off-by: Biao Huang <biao.huang@mediatek.com>
Signed-off-by: Yinghua Pan <ot_yinghua.pan@mediatek.com>
---
 drivers/net/ethernet/mediatek/mtk_star_emac.c | 317 ++++++++++--------
 1 file changed, 181 insertions(+), 136 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_star_emac.c b/drivers/net/ethernet/mediatek/mtk_star_emac.c
index 08a372848651..c46e05bfd8a5 100644
--- a/drivers/net/ethernet/mediatek/mtk_star_emac.c
+++ b/drivers/net/ethernet/mediatek/mtk_star_emac.c
@@ -229,7 +229,7 @@ struct mtk_star_ring_desc_data {
 	struct sk_buff *skb;
 };
 
-#define MTK_STAR_RING_NUM_DESCS			128
+#define MTK_STAR_RING_NUM_DESCS			512
 #define MTK_STAR_NUM_TX_DESCS			MTK_STAR_RING_NUM_DESCS
 #define MTK_STAR_NUM_RX_DESCS			MTK_STAR_RING_NUM_DESCS
 #define MTK_STAR_NUM_DESCS_TOTAL		(MTK_STAR_RING_NUM_DESCS * 2)
@@ -264,7 +264,8 @@ struct mtk_star_priv {
 	struct mtk_star_ring rx_ring;
 
 	struct mii_bus *mii;
-	struct napi_struct napi;
+	struct napi_struct tx_napi;
+	struct napi_struct rx_napi;
 
 	struct device_node *phy_node;
 	phy_interface_t phy_intf;
@@ -380,19 +381,16 @@ mtk_star_ring_push_head_tx(struct mtk_star_ring *ring,
 	mtk_star_ring_push_head(ring, desc_data, flags);
 }
 
-static unsigned int mtk_star_ring_num_used_descs(struct mtk_star_ring *ring)
+static unsigned int mtk_star_tx_ring_avail(struct mtk_star_ring *ring)
 {
-	return abs(ring->head - ring->tail);
-}
+	u32 avail;
 
-static bool mtk_star_ring_full(struct mtk_star_ring *ring)
-{
-	return mtk_star_ring_num_used_descs(ring) == MTK_STAR_RING_NUM_DESCS;
-}
+	if (ring->tail > ring->head)
+		avail = ring->tail - ring->head - 1;
+	else
+		avail = MTK_STAR_RING_NUM_DESCS - ring->head + ring->tail - 1;
 
-static bool mtk_star_ring_descs_available(struct mtk_star_ring *ring)
-{
-	return mtk_star_ring_num_used_descs(ring) > 0;
+	return avail;
 }
 
 static dma_addr_t mtk_star_dma_map_rx(struct mtk_star_priv *priv,
@@ -415,7 +413,7 @@ static void mtk_star_dma_unmap_rx(struct mtk_star_priv *priv,
 }
 
 static dma_addr_t mtk_star_dma_map_tx(struct mtk_star_priv *priv,
-				      struct sk_buff *skb)
+					     struct sk_buff *skb)
 {
 	struct device *dev = mtk_star_get_dev(priv);
 
@@ -437,6 +435,36 @@ static void mtk_star_nic_disable_pd(struct mtk_star_priv *priv)
 			  MTK_STAR_BIT_MAC_CFG_NIC_PD);
 }
 
+static void mtk_star_enable_dma_irq(struct mtk_star_priv *priv,
+				    bool rx, bool tx)
+{
+	u32 value;
+
+	regmap_read(priv->regs, MTK_STAR_REG_INT_MASK, &value);
+
+	if (tx)
+		value &= ~MTK_STAR_BIT_INT_STS_TNTC;
+	if (rx)
+		value &= ~MTK_STAR_BIT_INT_STS_FNRC;
+
+	regmap_write(priv->regs, MTK_STAR_REG_INT_MASK, value);
+}
+
+static void mtk_star_disable_dma_irq(struct mtk_star_priv *priv,
+				     bool rx, bool tx)
+{
+	u32 value;
+
+	regmap_read(priv->regs, MTK_STAR_REG_INT_MASK, &value);
+
+	if (tx)
+		value |= MTK_STAR_BIT_INT_STS_TNTC;
+	if (rx)
+		value |= MTK_STAR_BIT_INT_STS_FNRC;
+
+	regmap_write(priv->regs, MTK_STAR_REG_INT_MASK, value);
+}
+
 /* Unmask the three interrupts we care about, mask all others. */
 static void mtk_star_intr_enable(struct mtk_star_priv *priv)
 {
@@ -452,20 +480,11 @@ static void mtk_star_intr_disable(struct mtk_star_priv *priv)
 	regmap_write(priv->regs, MTK_STAR_REG_INT_MASK, ~0);
 }
 
-static unsigned int mtk_star_intr_read(struct mtk_star_priv *priv)
-{
-	unsigned int val;
-
-	regmap_read(priv->regs, MTK_STAR_REG_INT_STS, &val);
-
-	return val;
-}
-
 static unsigned int mtk_star_intr_ack_all(struct mtk_star_priv *priv)
 {
 	unsigned int val;
 
-	val = mtk_star_intr_read(priv);
+	regmap_read(priv->regs, MTK_STAR_REG_INT_STS, &val);
 	regmap_write(priv->regs, MTK_STAR_REG_INT_STS, val);
 
 	return val;
@@ -737,25 +756,46 @@ static void mtk_star_free_tx_skbs(struct mtk_star_priv *priv)
 	mtk_star_ring_free_skbs(priv, ring, mtk_star_dma_unmap_tx);
 }
 
-/* All processing for TX and RX happens in the napi poll callback.
- *
- * FIXME: The interrupt handling should be more fine-grained with each
- * interrupt enabled/disabled independently when needed. Unfortunatly this
- * turned out to impact the driver's stability and until we have something
- * working properly, we're disabling all interrupts during TX & RX processing
- * or when resetting the counter registers.
+/* mtk_star_handle_irq - Interrupt Handler.
+ * @irq: interrupt number.
+ * @data: pointer to a network interface device structure.
+ * Description : this is the driver interrupt service routine.
+ * it mainly handles:
+ *  1. tx complete interrupt for frame transmission.
+ *  2. rx complete interrupt for frame reception.
+ *  3. MAC Management Counter interrupt to avoid counter overflow.
  */
 static irqreturn_t mtk_star_handle_irq(int irq, void *data)
 {
-	struct mtk_star_priv *priv;
-	struct net_device *ndev;
+	struct net_device *ndev = data;
+	struct mtk_star_priv *priv = netdev_priv(ndev);
+	unsigned int intr_status = mtk_star_intr_ack_all(priv);
+	unsigned long flags = 0;
+
+	if (intr_status & MTK_STAR_BIT_INT_STS_FNRC) {
+		if (napi_schedule_prep(&priv->rx_napi)) {
+			spin_lock_irqsave(&priv->lock, flags);
+			/* mask Rx Complete interrupt */
+			mtk_star_disable_dma_irq(priv, true, false);
+			spin_unlock_irqrestore(&priv->lock, flags);
+			__napi_schedule_irqoff(&priv->rx_napi);
+		}
+	}
 
-	ndev = data;
-	priv = netdev_priv(ndev);
+	if (intr_status & MTK_STAR_BIT_INT_STS_TNTC) {
+		if (napi_schedule_prep(&priv->tx_napi)) {
+			spin_lock_irqsave(&priv->lock, flags);
+			/* mask Tx Complete interrupt */
+			mtk_star_disable_dma_irq(priv, false, true);
+			spin_unlock_irqrestore(&priv->lock, flags);
+			__napi_schedule_irqoff(&priv->tx_napi);
+		}
+	}
 
-	if (netif_running(ndev)) {
-		mtk_star_intr_disable(priv);
-		napi_schedule(&priv->napi);
+	/* interrupt is triggered once any counters reach 0x8000000 */
+	if (intr_status & MTK_STAR_REG_INT_STS_MIB_CNT_TH) {
+		mtk_star_update_stats(priv);
+		mtk_star_reset_counters(priv);
 	}
 
 	return IRQ_HANDLED;
@@ -971,7 +1011,8 @@ static int mtk_star_enable(struct net_device *ndev)
 	if (ret)
 		goto err_free_skbs;
 
-	napi_enable(&priv->napi);
+	napi_enable(&priv->tx_napi);
+	napi_enable(&priv->rx_napi);
 
 	mtk_star_intr_ack_all(priv);
 	mtk_star_intr_enable(priv);
@@ -1004,7 +1045,8 @@ static void mtk_star_disable(struct net_device *ndev)
 	struct mtk_star_priv *priv = netdev_priv(ndev);
 
 	netif_stop_queue(ndev);
-	napi_disable(&priv->napi);
+	napi_disable(&priv->tx_napi);
+	napi_disable(&priv->rx_napi);
 	mtk_star_intr_disable(priv);
 	mtk_star_dma_disable(priv);
 	mtk_star_intr_ack_all(priv);
@@ -1043,6 +1085,17 @@ static int mtk_star_netdev_start_xmit(struct sk_buff *skb,
 	struct mtk_star_ring *ring = &priv->tx_ring;
 	struct device *dev = mtk_star_get_dev(priv);
 	struct mtk_star_ring_desc_data desc_data;
+	int nfrags = skb_shinfo(skb)->nr_frags;
+
+	if (unlikely(mtk_star_tx_ring_avail(ring) < nfrags + 1)) {
+		if (!netif_queue_stopped(ndev)) {
+			netif_stop_queue(ndev);
+			/* This is a hard error, log it. */
+			netdev_err(priv->ndev, "%s: Tx Ring full when queue awake\n",
+				   __func__);
+		}
+		return NETDEV_TX_BUSY;
+	}
 
 	desc_data.dma_addr = mtk_star_dma_map_tx(priv, skb);
 	if (dma_mapping_error(dev, desc_data.dma_addr))
@@ -1050,18 +1103,10 @@ static int mtk_star_netdev_start_xmit(struct sk_buff *skb,
 
 	desc_data.skb = skb;
 	desc_data.len = skb->len;
-
-	spin_lock_bh(&priv->lock);
-
 	mtk_star_ring_push_head_tx(ring, &desc_data);
 
 	netdev_sent_queue(ndev, skb->len);
 
-	if (mtk_star_ring_full(ring))
-		netif_stop_queue(ndev);
-
-	spin_unlock_bh(&priv->lock);
-
 	mtk_star_dma_resume_tx(priv);
 
 	return NETDEV_TX_OK;
@@ -1092,23 +1137,31 @@ static int mtk_star_tx_complete_one(struct mtk_star_priv *priv)
 	return ret;
 }
 
-static void mtk_star_tx_complete_all(struct mtk_star_priv *priv)
+static int mtk_star_tx_poll(struct napi_struct *napi, int budget)
 {
-	struct mtk_star_ring *ring = &priv->tx_ring;
-	struct net_device *ndev = priv->ndev;
-	int ret, pkts_compl, bytes_compl;
+	int ret, pkts_compl = 0, bytes_compl = 0, count = 0;
+	struct mtk_star_priv *priv;
+	struct mtk_star_ring *ring;
+	struct net_device *ndev;
+	unsigned long flags = 0;
+	unsigned int entry;
 	bool wake = false;
 
-	spin_lock(&priv->lock);
+	priv = container_of(napi, struct mtk_star_priv, tx_napi);
+	ndev = priv->ndev;
 
-	for (pkts_compl = 0, bytes_compl = 0;;
+	__netif_tx_lock_bh(netdev_get_tx_queue(priv->ndev, 0));
+	ring = &priv->tx_ring;
+	entry = ring->tail;
+	for (pkts_compl = 0, bytes_compl = 0;
+	     (entry != ring->head) && (count < budget);
 	     pkts_compl++, bytes_compl += ret, wake = true) {
-		if (!mtk_star_ring_descs_available(ring))
-			break;
 
 		ret = mtk_star_tx_complete_one(priv);
 		if (ret < 0)
 			break;
+		count++;
+		entry = ring->tail;
 	}
 
 	netdev_completed_queue(ndev, pkts_compl, bytes_compl);
@@ -1116,7 +1169,16 @@ static void mtk_star_tx_complete_all(struct mtk_star_priv *priv)
 	if (wake && netif_queue_stopped(ndev))
 		netif_wake_queue(ndev);
 
-	spin_unlock(&priv->lock);
+	__netif_tx_unlock_bh(netdev_get_tx_queue(priv->ndev, 0));
+
+	count = min(count, budget);
+	if (count < budget && napi_complete_done(napi, count)) {
+		spin_lock_irqsave(&priv->lock, flags);
+		mtk_star_enable_dma_irq(priv, false, true);
+		spin_unlock_irqrestore(&priv->lock, flags);
+	}
+
+	return count;
 }
 
 static void mtk_star_netdev_get_stats64(struct net_device *ndev,
@@ -1196,7 +1258,7 @@ static const struct ethtool_ops mtk_star_ethtool_ops = {
 	.set_link_ksettings	= phy_ethtool_set_link_ksettings,
 };
 
-static int mtk_star_receive_packet(struct mtk_star_priv *priv)
+static int mtk_star_rx(struct mtk_star_priv *priv, int budget)
 {
 	struct mtk_star_ring *ring = &priv->rx_ring;
 	struct device *dev = mtk_star_get_dev(priv);
@@ -1204,107 +1266,86 @@ static int mtk_star_receive_packet(struct mtk_star_priv *priv)
 	struct net_device *ndev = priv->ndev;
 	struct sk_buff *curr_skb, *new_skb;
 	dma_addr_t new_dma_addr;
-	int ret;
+	int ret, count = 0;
 
-	spin_lock(&priv->lock);
-	ret = mtk_star_ring_pop_tail(ring, &desc_data);
-	spin_unlock(&priv->lock);
-	if (ret)
-		return -1;
+	while (count < budget) {
+		ret = mtk_star_ring_pop_tail(ring, &desc_data);
+		if (ret)
+			return -1;
 
-	curr_skb = desc_data.skb;
+		curr_skb = desc_data.skb;
 
-	if ((desc_data.flags & MTK_STAR_DESC_BIT_RX_CRCE) ||
-	    (desc_data.flags & MTK_STAR_DESC_BIT_RX_OSIZE)) {
-		/* Error packet -> drop and reuse skb. */
-		new_skb = curr_skb;
-		goto push_new_skb;
-	}
+		if ((desc_data.flags & MTK_STAR_DESC_BIT_RX_CRCE) ||
+		    (desc_data.flags & MTK_STAR_DESC_BIT_RX_OSIZE)) {
+			/* Error packet -> drop and reuse skb. */
+			new_skb = curr_skb;
+			goto push_new_skb;
+		}
 
-	/* Prepare new skb before receiving the current one. Reuse the current
-	 * skb if we fail at any point.
-	 */
-	new_skb = mtk_star_alloc_skb(ndev);
-	if (!new_skb) {
-		ndev->stats.rx_dropped++;
-		new_skb = curr_skb;
-		goto push_new_skb;
-	}
+		/* Prepare new skb before receiving the current one.
+		 * Reuse the current skb if we fail at any point.
+		 */
+		new_skb = mtk_star_alloc_skb(ndev);
+		if (!new_skb) {
+			ndev->stats.rx_dropped++;
+			new_skb = curr_skb;
+			goto push_new_skb;
+		}
 
-	new_dma_addr = mtk_star_dma_map_rx(priv, new_skb);
-	if (dma_mapping_error(dev, new_dma_addr)) {
-		ndev->stats.rx_dropped++;
-		dev_kfree_skb(new_skb);
-		new_skb = curr_skb;
-		netdev_err(ndev, "DMA mapping error of RX descriptor\n");
-		goto push_new_skb;
-	}
+		new_dma_addr = mtk_star_dma_map_rx(priv, new_skb);
+		if (dma_mapping_error(dev, new_dma_addr)) {
+			ndev->stats.rx_dropped++;
+			dev_kfree_skb(new_skb);
+			new_skb = curr_skb;
+			netdev_err(ndev, "DMA mapping error of RX descriptor\n");
+			goto push_new_skb;
+		}
 
-	/* We can't fail anymore at this point: it's safe to unmap the skb. */
-	mtk_star_dma_unmap_rx(priv, &desc_data);
+		/* We can't fail anymore at this point:
+		 * it's safe to unmap the skb.
+		 */
+		mtk_star_dma_unmap_rx(priv, &desc_data);
 
-	skb_put(desc_data.skb, desc_data.len);
-	desc_data.skb->ip_summed = CHECKSUM_NONE;
-	desc_data.skb->protocol = eth_type_trans(desc_data.skb, ndev);
-	desc_data.skb->dev = ndev;
-	netif_receive_skb(desc_data.skb);
+		skb_put(desc_data.skb, desc_data.len);
+		desc_data.skb->ip_summed = CHECKSUM_NONE;
+		desc_data.skb->protocol = eth_type_trans(desc_data.skb, ndev);
+		desc_data.skb->dev = ndev;
+		netif_receive_skb(desc_data.skb);
 
-	/* update dma_addr for new skb */
-	desc_data.dma_addr = new_dma_addr;
+		/* update dma_addr for new skb */
+		desc_data.dma_addr = new_dma_addr;
 
 push_new_skb:
-	desc_data.len = skb_tailroom(new_skb);
-	desc_data.skb = new_skb;
-
-	spin_lock(&priv->lock);
-	mtk_star_ring_push_head_rx(ring, &desc_data);
-	spin_unlock(&priv->lock);
-
-	return 0;
-}
 
-static int mtk_star_process_rx(struct mtk_star_priv *priv, int budget)
-{
-	int received, ret;
+		count++;
 
-	for (received = 0, ret = 0; received < budget && ret == 0; received++)
-		ret = mtk_star_receive_packet(priv);
+		desc_data.len = skb_tailroom(new_skb);
+		desc_data.skb = new_skb;
+		mtk_star_ring_push_head_rx(ring, &desc_data);
+	}
 
 	mtk_star_dma_resume_rx(priv);
 
-	return received;
+	return count;
 }
 
-static int mtk_star_poll(struct napi_struct *napi, int budget)
+static int mtk_star_rx_poll(struct napi_struct *napi, int budget)
 {
 	struct mtk_star_priv *priv;
-	unsigned int status;
-	int received = 0;
+	unsigned long flags = 0;
+	int work_done = 0;
 
-	priv = container_of(napi, struct mtk_star_priv, napi);
+	priv = container_of(napi, struct mtk_star_priv, rx_napi);
 
-	status = mtk_star_intr_read(priv);
-	mtk_star_intr_ack_all(priv);
-
-	if (status & MTK_STAR_BIT_INT_STS_TNTC)
-		/* Clean-up all TX descriptors. */
-		mtk_star_tx_complete_all(priv);
-
-	if (status & MTK_STAR_BIT_INT_STS_FNRC)
-		/* Receive up to $budget packets. */
-		received = mtk_star_process_rx(priv, budget);
-
-	if (unlikely(status & MTK_STAR_REG_INT_STS_MIB_CNT_TH)) {
-		mtk_star_update_stats(priv);
-		mtk_star_reset_counters(priv);
+	work_done = mtk_star_rx(priv, budget);
+	if (work_done < budget) {
+		napi_complete_done(napi, work_done);
+		spin_lock_irqsave(&priv->lock, flags);
+		mtk_star_enable_dma_irq(priv, true, false);
+		spin_unlock_irqrestore(&priv->lock, flags);
 	}
 
-	if (received < budget)
-		napi_complete_done(napi, received);
-
-	mtk_star_intr_enable(priv);
-
-	return received;
+	return work_done;
 }
 
 static void mtk_star_mdio_rwok_clear(struct mtk_star_priv *priv)
@@ -1478,6 +1519,7 @@ static int mtk_star_set_timing(struct mtk_star_priv *priv)
 
 	return 0;
 }
+
 static int mtk_star_probe(struct platform_device *pdev)
 {
 	struct device_node *of_node;
@@ -1604,7 +1646,10 @@ static int mtk_star_probe(struct platform_device *pdev)
 	ndev->netdev_ops = &mtk_star_netdev_ops;
 	ndev->ethtool_ops = &mtk_star_ethtool_ops;
 
-	netif_napi_add(ndev, &priv->napi, mtk_star_poll, MTK_STAR_NAPI_WEIGHT);
+	netif_napi_add(ndev, &priv->rx_napi,
+		       mtk_star_rx_poll, MTK_STAR_NAPI_WEIGHT);
+	netif_tx_napi_add(ndev, &priv->tx_napi,
+			  mtk_star_tx_poll, MTK_STAR_NAPI_WEIGHT);
 
 	return devm_register_netdev(dev, ndev);
 }
-- 
2.25.1

