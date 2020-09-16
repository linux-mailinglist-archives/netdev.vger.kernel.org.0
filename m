Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DA2026BE55
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 09:41:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726453AbgIPHlk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 03:41:40 -0400
Received: from mga06.intel.com ([134.134.136.31]:22286 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726068AbgIPHli (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Sep 2020 03:41:38 -0400
IronPort-SDR: 3JmNJ9wVVZzfHijVgY3ryvMLN0X9uiO8NV8QmE/Hmp3pFmtuUFhrjc1YoFk2dJd0GRdBFwzGpe
 UL8+TG9fRHlw==
X-IronPort-AV: E=McAfee;i="6000,8403,9745"; a="220974928"
X-IronPort-AV: E=Sophos;i="5.76,432,1592895600"; 
   d="scan'208";a="220974928"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2020 00:38:35 -0700
IronPort-SDR: sBLZ0kZia7WSDi303h9IxHf1flKKuLD21QnAjL2/EerHDasVk7r6sMFVB+QytzlxGCFfFMBqOP
 XaiKmQUl+1lg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,432,1592895600"; 
   d="scan'208";a="302471420"
Received: from glass.png.intel.com ([172.30.181.92])
  by orsmga003.jf.intel.com with ESMTP; 16 Sep 2020 00:38:30 -0700
From:   Wong Vee Khee <vee.khee.wong@intel.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Voon Wei Feng <weifeng.voon@intel.com>,
        Song Yoong Siang <yoong.siang.song@intel.com>,
        Wong Vee Khee <vee.khee.wong@intel.com>,
        Vijaya Balan Sadhishkhanna 
        <sadhishkhanna.vijaya.balan@intel.com>,
        Seow Chen Yong <chen.yong.seow@intel.com>
Subject: [PATCH net-next] net: stmmac: Add support to Ethtool get/set ring parameters
Date:   Wed, 16 Sep 2020 15:40:20 +0800
Message-Id: <20200916074020.25491-1-vee.khee.wong@intel.com>
X-Mailer: git-send-email 2.17.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Song, Yoong Siang" <yoong.siang.song@intel.com>

This patch add support to --show-ring & --set-ring Ethtool functions:
- Adding min, max, power of two check to new ring parameter's value.
- Bring down the network interface before changing the value of ring
  parameters.
- Bring up the network interface after changing the value of ring
  parameters.

Signed-off-by: Song, Yoong Siang <yoong.siang.song@intel.com>
Signed-off-by: Voon Weifeng <weifeng.voon@intel.com>
Signed-off-by: Ong Boon Leong <boon.leong.ong@intel.com>
---
 .../net/ethernet/stmicro/stmmac/chain_mode.c  |   7 +-
 drivers/net/ethernet/stmicro/stmmac/common.h  |  13 +-
 .../net/ethernet/stmicro/stmmac/ring_mode.c   |   2 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac.h  |   3 +
 .../ethernet/stmicro/stmmac/stmmac_ethtool.c  |  29 ++++
 .../net/ethernet/stmicro/stmmac/stmmac_main.c | 135 +++++++++++-------
 .../stmicro/stmmac/stmmac_selftests.c         |   2 +-
 7 files changed, 132 insertions(+), 59 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/chain_mode.c b/drivers/net/ethernet/stmicro/stmmac/chain_mode.c
index 52971f5293aa..d2cdc02d9f94 100644
--- a/drivers/net/ethernet/stmicro/stmmac/chain_mode.c
+++ b/drivers/net/ethernet/stmicro/stmmac/chain_mode.c
@@ -46,7 +46,7 @@ static int jumbo_frm(void *p, struct sk_buff *skb, int csum)
 
 	while (len != 0) {
 		tx_q->tx_skbuff[entry] = NULL;
-		entry = STMMAC_GET_ENTRY(entry, DMA_TX_SIZE);
+		entry = STMMAC_GET_ENTRY(entry, priv->dma_tx_size);
 		desc = tx_q->dma_tx + entry;
 
 		if (len > bmax) {
@@ -137,7 +137,7 @@ static void refill_desc3(void *priv_ptr, struct dma_desc *p)
 		 */
 		p->des3 = cpu_to_le32((unsigned int)(rx_q->dma_rx_phy +
 				      (((rx_q->dirty_rx) + 1) %
-				       DMA_RX_SIZE) *
+				       priv->dma_rx_size) *
 				      sizeof(struct dma_desc)));
 }
 
@@ -154,7 +154,8 @@ static void clean_desc3(void *priv_ptr, struct dma_desc *p)
 		 * to keep explicit chaining in the descriptor.
 		 */
 		p->des3 = cpu_to_le32((unsigned int)((tx_q->dma_tx_phy +
-				      ((tx_q->dirty_tx + 1) % DMA_TX_SIZE))
+				      ((tx_q->dirty_tx + 1) %
+				       priv->dma_tx_size))
 				      * sizeof(struct dma_desc)));
 }
 
diff --git a/drivers/net/ethernet/stmicro/stmmac/common.h b/drivers/net/ethernet/stmicro/stmmac/common.h
index acc5e3fc1c2f..cafa8e3c3573 100644
--- a/drivers/net/ethernet/stmicro/stmmac/common.h
+++ b/drivers/net/ethernet/stmicro/stmmac/common.h
@@ -42,9 +42,16 @@
 
 #define STMMAC_CHAN0	0	/* Always supported and default for all chips */
 
-/* These need to be power of two, and >= 4 */
-#define DMA_TX_SIZE 512
-#define DMA_RX_SIZE 512
+/* TX and RX Descriptor Length, these need to be power of two.
+ * TX descriptor length less than 64 may cause transmit queue timed out error.
+ * RX descriptor length less than 64 may cause inconsistent Rx chain error.
+ */
+#define DMA_MIN_TX_SIZE		64
+#define DMA_MAX_TX_SIZE		1024
+#define DMA_DEFAULT_TX_SIZE	512
+#define DMA_MIN_RX_SIZE		64
+#define DMA_MAX_RX_SIZE		1024
+#define DMA_DEFAULT_RX_SIZE	512
 #define STMMAC_GET_ENTRY(x, size)	((x + 1) & (size - 1))
 
 #undef FRAME_FILTER_DEBUG
diff --git a/drivers/net/ethernet/stmicro/stmmac/ring_mode.c b/drivers/net/ethernet/stmicro/stmmac/ring_mode.c
index 14bd5e7b9875..8ad900949dc8 100644
--- a/drivers/net/ethernet/stmicro/stmmac/ring_mode.c
+++ b/drivers/net/ethernet/stmicro/stmmac/ring_mode.c
@@ -51,7 +51,7 @@ static int jumbo_frm(void *p, struct sk_buff *skb, int csum)
 		stmmac_prepare_tx_desc(priv, desc, 1, bmax, csum,
 				STMMAC_RING_MODE, 0, false, skb->len);
 		tx_q->tx_skbuff[entry] = NULL;
-		entry = STMMAC_GET_ENTRY(entry, DMA_TX_SIZE);
+		entry = STMMAC_GET_ENTRY(entry, priv->dma_tx_size);
 
 		if (priv->extend_desc)
 			desc = (struct dma_desc *)(tx_q->dma_etx + entry);
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac.h b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
index 509ce067538e..014a816c9d0b 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac.h
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
@@ -171,9 +171,11 @@ struct stmmac_priv {
 
 	/* RX Queue */
 	struct stmmac_rx_queue rx_queue[MTL_MAX_RX_QUEUES];
+	unsigned int dma_rx_size;
 
 	/* TX Queue */
 	struct stmmac_tx_queue tx_queue[MTL_MAX_TX_QUEUES];
+	unsigned int dma_tx_size;
 
 	/* Generic channel for NAPI */
 	struct stmmac_channel channel[STMMAC_CH_MAX];
@@ -265,6 +267,7 @@ int stmmac_dvr_probe(struct device *device,
 void stmmac_disable_eee_mode(struct stmmac_priv *priv);
 bool stmmac_eee_init(struct stmmac_priv *priv);
 int stmmac_reinit_queues(struct net_device *dev, u32 rx_cnt, u32 tx_cnt);
+int stmmac_reinit_ringparam(struct net_device *dev, u32 rx_size, u32 tx_size);
 
 #if IS_ENABLED(CONFIG_STMMAC_SELFTESTS)
 void stmmac_selftest_run(struct net_device *dev,
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
index db681287c273..5cfc942dbabf 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
@@ -440,6 +440,33 @@ static int stmmac_nway_reset(struct net_device *dev)
 	return phylink_ethtool_nway_reset(priv->phylink);
 }
 
+static void stmmac_get_ringparam(struct net_device *netdev,
+				 struct ethtool_ringparam *ring)
+{
+	struct stmmac_priv *priv = netdev_priv(netdev);
+
+	ring->rx_max_pending = DMA_MAX_RX_SIZE;
+	ring->tx_max_pending = DMA_MAX_TX_SIZE;
+	ring->rx_pending = priv->dma_rx_size;
+	ring->tx_pending = priv->dma_tx_size;
+}
+
+static int stmmac_set_ringparam(struct net_device *netdev,
+				struct ethtool_ringparam *ring)
+{
+	if (ring->rx_mini_pending || ring->rx_jumbo_pending ||
+	    ring->rx_pending < DMA_MIN_RX_SIZE ||
+	    ring->rx_pending > DMA_MAX_RX_SIZE ||
+	    !is_power_of_2(ring->rx_pending) ||
+	    ring->tx_pending < DMA_MIN_TX_SIZE ||
+	    ring->tx_pending > DMA_MAX_TX_SIZE ||
+	    !is_power_of_2(ring->tx_pending))
+		return -EINVAL;
+
+	return stmmac_reinit_ringparam(netdev, ring->rx_pending,
+				       ring->tx_pending);
+}
+
 static void
 stmmac_get_pauseparam(struct net_device *netdev,
 		      struct ethtool_pauseparam *pause)
@@ -947,6 +974,8 @@ static const struct ethtool_ops stmmac_ethtool_ops = {
 	.get_regs_len = stmmac_ethtool_get_regs_len,
 	.get_link = ethtool_op_get_link,
 	.nway_reset = stmmac_nway_reset,
+	.get_ringparam = stmmac_get_ringparam,
+	.set_ringparam = stmmac_set_ringparam,
 	.get_pauseparam = stmmac_get_pauseparam,
 	.set_pauseparam = stmmac_set_pauseparam,
 	.self_test = stmmac_selftest_run,
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index e2c579cf3b15..df2c74bbfcff 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -63,8 +63,8 @@ static int phyaddr = -1;
 module_param(phyaddr, int, 0444);
 MODULE_PARM_DESC(phyaddr, "Physical device address");
 
-#define STMMAC_TX_THRESH	(DMA_TX_SIZE / 4)
-#define STMMAC_RX_THRESH	(DMA_RX_SIZE / 4)
+#define STMMAC_TX_THRESH(x)	((x)->dma_tx_size / 4)
+#define STMMAC_RX_THRESH(x)	((x)->dma_rx_size / 4)
 
 static int flow_ctrl = FLOW_AUTO;
 module_param(flow_ctrl, int, 0644);
@@ -271,7 +271,7 @@ static inline u32 stmmac_tx_avail(struct stmmac_priv *priv, u32 queue)
 	if (tx_q->dirty_tx > tx_q->cur_tx)
 		avail = tx_q->dirty_tx - tx_q->cur_tx - 1;
 	else
-		avail = DMA_TX_SIZE - tx_q->cur_tx + tx_q->dirty_tx - 1;
+		avail = priv->dma_tx_size - tx_q->cur_tx + tx_q->dirty_tx - 1;
 
 	return avail;
 }
@@ -289,7 +289,7 @@ static inline u32 stmmac_rx_dirty(struct stmmac_priv *priv, u32 queue)
 	if (rx_q->dirty_rx <= rx_q->cur_rx)
 		dirty = rx_q->cur_rx - rx_q->dirty_rx;
 	else
-		dirty = DMA_RX_SIZE - rx_q->dirty_rx + rx_q->cur_rx;
+		dirty = priv->dma_rx_size - rx_q->dirty_rx + rx_q->cur_rx;
 
 	return dirty;
 }
@@ -1120,7 +1120,7 @@ static void stmmac_display_rx_rings(struct stmmac_priv *priv)
 			head_rx = (void *)rx_q->dma_rx;
 
 		/* Display RX ring */
-		stmmac_display_ring(priv, head_rx, DMA_RX_SIZE, true);
+		stmmac_display_ring(priv, head_rx, priv->dma_rx_size, true);
 	}
 }
 
@@ -1143,7 +1143,7 @@ static void stmmac_display_tx_rings(struct stmmac_priv *priv)
 		else
 			head_tx = (void *)tx_q->dma_tx;
 
-		stmmac_display_ring(priv, head_tx, DMA_TX_SIZE, false);
+		stmmac_display_ring(priv, head_tx, priv->dma_tx_size, false);
 	}
 }
 
@@ -1187,16 +1187,16 @@ static void stmmac_clear_rx_descriptors(struct stmmac_priv *priv, u32 queue)
 	int i;
 
 	/* Clear the RX descriptors */
-	for (i = 0; i < DMA_RX_SIZE; i++)
+	for (i = 0; i < priv->dma_rx_size; i++)
 		if (priv->extend_desc)
 			stmmac_init_rx_desc(priv, &rx_q->dma_erx[i].basic,
 					priv->use_riwt, priv->mode,
-					(i == DMA_RX_SIZE - 1),
+					(i == priv->dma_rx_size - 1),
 					priv->dma_buf_sz);
 		else
 			stmmac_init_rx_desc(priv, &rx_q->dma_rx[i],
 					priv->use_riwt, priv->mode,
-					(i == DMA_RX_SIZE - 1),
+					(i == priv->dma_rx_size - 1),
 					priv->dma_buf_sz);
 }
 
@@ -1213,8 +1213,8 @@ static void stmmac_clear_tx_descriptors(struct stmmac_priv *priv, u32 queue)
 	int i;
 
 	/* Clear the TX descriptors */
-	for (i = 0; i < DMA_TX_SIZE; i++) {
-		int last = (i == (DMA_TX_SIZE - 1));
+	for (i = 0; i < priv->dma_tx_size; i++) {
+		int last = (i == (priv->dma_tx_size - 1));
 		struct dma_desc *p;
 
 		if (priv->extend_desc)
@@ -1368,7 +1368,7 @@ static int init_dma_rx_desc_rings(struct net_device *dev, gfp_t flags)
 
 		stmmac_clear_rx_descriptors(priv, queue);
 
-		for (i = 0; i < DMA_RX_SIZE; i++) {
+		for (i = 0; i < priv->dma_rx_size; i++) {
 			struct dma_desc *p;
 
 			if (priv->extend_desc)
@@ -1383,16 +1383,18 @@ static int init_dma_rx_desc_rings(struct net_device *dev, gfp_t flags)
 		}
 
 		rx_q->cur_rx = 0;
-		rx_q->dirty_rx = (unsigned int)(i - DMA_RX_SIZE);
+		rx_q->dirty_rx = (unsigned int)(i - priv->dma_rx_size);
 
 		/* Setup the chained descriptor addresses */
 		if (priv->mode == STMMAC_CHAIN_MODE) {
 			if (priv->extend_desc)
 				stmmac_mode_init(priv, rx_q->dma_erx,
-						rx_q->dma_rx_phy, DMA_RX_SIZE, 1);
+						 rx_q->dma_rx_phy,
+						 priv->dma_rx_size, 1);
 			else
 				stmmac_mode_init(priv, rx_q->dma_rx,
-						rx_q->dma_rx_phy, DMA_RX_SIZE, 0);
+						 rx_q->dma_rx_phy,
+						 priv->dma_rx_size, 0);
 		}
 	}
 
@@ -1406,7 +1408,7 @@ static int init_dma_rx_desc_rings(struct net_device *dev, gfp_t flags)
 		if (queue == 0)
 			break;
 
-		i = DMA_RX_SIZE;
+		i = priv->dma_rx_size;
 		queue--;
 	}
 
@@ -1438,13 +1440,15 @@ static int init_dma_tx_desc_rings(struct net_device *dev)
 		if (priv->mode == STMMAC_CHAIN_MODE) {
 			if (priv->extend_desc)
 				stmmac_mode_init(priv, tx_q->dma_etx,
-						tx_q->dma_tx_phy, DMA_TX_SIZE, 1);
+						 tx_q->dma_tx_phy,
+						 priv->dma_tx_size, 1);
 			else if (!(tx_q->tbs & STMMAC_TBS_AVAIL))
 				stmmac_mode_init(priv, tx_q->dma_tx,
-						tx_q->dma_tx_phy, DMA_TX_SIZE, 0);
+						 tx_q->dma_tx_phy,
+						 priv->dma_tx_size, 0);
 		}
 
-		for (i = 0; i < DMA_TX_SIZE; i++) {
+		for (i = 0; i < priv->dma_tx_size; i++) {
 			struct dma_desc *p;
 			if (priv->extend_desc)
 				p = &((tx_q->dma_etx + i)->basic);
@@ -1508,7 +1512,7 @@ static void dma_free_rx_skbufs(struct stmmac_priv *priv, u32 queue)
 {
 	int i;
 
-	for (i = 0; i < DMA_RX_SIZE; i++)
+	for (i = 0; i < priv->dma_rx_size; i++)
 		stmmac_free_rx_buffer(priv, queue, i);
 }
 
@@ -1521,7 +1525,7 @@ static void dma_free_tx_skbufs(struct stmmac_priv *priv, u32 queue)
 {
 	int i;
 
-	for (i = 0; i < DMA_TX_SIZE; i++)
+	for (i = 0; i < priv->dma_tx_size; i++)
 		stmmac_free_tx_buffer(priv, queue, i);
 }
 
@@ -1543,11 +1547,11 @@ static void free_dma_rx_desc_resources(struct stmmac_priv *priv)
 
 		/* Free DMA regions of consistent memory previously allocated */
 		if (!priv->extend_desc)
-			dma_free_coherent(priv->device,
-					  DMA_RX_SIZE * sizeof(struct dma_desc),
+			dma_free_coherent(priv->device, priv->dma_rx_size *
+					  sizeof(struct dma_desc),
 					  rx_q->dma_rx, rx_q->dma_rx_phy);
 		else
-			dma_free_coherent(priv->device, DMA_RX_SIZE *
+			dma_free_coherent(priv->device, priv->dma_rx_size *
 					  sizeof(struct dma_extended_desc),
 					  rx_q->dma_erx, rx_q->dma_rx_phy);
 
@@ -1586,7 +1590,7 @@ static void free_dma_tx_desc_resources(struct stmmac_priv *priv)
 			addr = tx_q->dma_tx;
 		}
 
-		size *= DMA_TX_SIZE;
+		size *= priv->dma_tx_size;
 
 		dma_free_coherent(priv->device, size, addr, tx_q->dma_tx_phy);
 
@@ -1619,7 +1623,7 @@ static int alloc_dma_rx_desc_resources(struct stmmac_priv *priv)
 		rx_q->priv_data = priv;
 
 		pp_params.flags = PP_FLAG_DMA_MAP;
-		pp_params.pool_size = DMA_RX_SIZE;
+		pp_params.pool_size = priv->dma_rx_size;
 		num_pages = DIV_ROUND_UP(priv->dma_buf_sz, PAGE_SIZE);
 		pp_params.order = ilog2(num_pages);
 		pp_params.nid = dev_to_node(priv->device);
@@ -1633,14 +1637,16 @@ static int alloc_dma_rx_desc_resources(struct stmmac_priv *priv)
 			goto err_dma;
 		}
 
-		rx_q->buf_pool = kcalloc(DMA_RX_SIZE, sizeof(*rx_q->buf_pool),
+		rx_q->buf_pool = kcalloc(priv->dma_rx_size,
+					 sizeof(*rx_q->buf_pool),
 					 GFP_KERNEL);
 		if (!rx_q->buf_pool)
 			goto err_dma;
 
 		if (priv->extend_desc) {
 			rx_q->dma_erx = dma_alloc_coherent(priv->device,
-							   DMA_RX_SIZE * sizeof(struct dma_extended_desc),
+							   priv->dma_rx_size *
+							   sizeof(struct dma_extended_desc),
 							   &rx_q->dma_rx_phy,
 							   GFP_KERNEL);
 			if (!rx_q->dma_erx)
@@ -1648,7 +1654,8 @@ static int alloc_dma_rx_desc_resources(struct stmmac_priv *priv)
 
 		} else {
 			rx_q->dma_rx = dma_alloc_coherent(priv->device,
-							  DMA_RX_SIZE * sizeof(struct dma_desc),
+							  priv->dma_rx_size *
+							  sizeof(struct dma_desc),
 							  &rx_q->dma_rx_phy,
 							  GFP_KERNEL);
 			if (!rx_q->dma_rx)
@@ -1687,13 +1694,13 @@ static int alloc_dma_tx_desc_resources(struct stmmac_priv *priv)
 		tx_q->queue_index = queue;
 		tx_q->priv_data = priv;
 
-		tx_q->tx_skbuff_dma = kcalloc(DMA_TX_SIZE,
+		tx_q->tx_skbuff_dma = kcalloc(priv->dma_tx_size,
 					      sizeof(*tx_q->tx_skbuff_dma),
 					      GFP_KERNEL);
 		if (!tx_q->tx_skbuff_dma)
 			goto err_dma;
 
-		tx_q->tx_skbuff = kcalloc(DMA_TX_SIZE,
+		tx_q->tx_skbuff = kcalloc(priv->dma_tx_size,
 					  sizeof(struct sk_buff *),
 					  GFP_KERNEL);
 		if (!tx_q->tx_skbuff)
@@ -1706,7 +1713,7 @@ static int alloc_dma_tx_desc_resources(struct stmmac_priv *priv)
 		else
 			size = sizeof(struct dma_desc);
 
-		size *= DMA_TX_SIZE;
+		size *= priv->dma_tx_size;
 
 		addr = dma_alloc_coherent(priv->device, size,
 					  &tx_q->dma_tx_phy, GFP_KERNEL);
@@ -2016,7 +2023,7 @@ static int stmmac_tx_clean(struct stmmac_priv *priv, int budget, u32 queue)
 
 		stmmac_release_tx_desc(priv, p, priv->mode);
 
-		entry = STMMAC_GET_ENTRY(entry, DMA_TX_SIZE);
+		entry = STMMAC_GET_ENTRY(entry, priv->dma_tx_size);
 	}
 	tx_q->dirty_tx = entry;
 
@@ -2025,7 +2032,7 @@ static int stmmac_tx_clean(struct stmmac_priv *priv, int budget, u32 queue)
 
 	if (unlikely(netif_tx_queue_stopped(netdev_get_tx_queue(priv->dev,
 								queue))) &&
-	    stmmac_tx_avail(priv, queue) > STMMAC_TX_THRESH) {
+	    stmmac_tx_avail(priv, queue) > STMMAC_TX_THRESH(priv)) {
 
 		netif_dbg(priv, tx_done, priv->dev,
 			  "%s: restart transmit\n", __func__);
@@ -2298,7 +2305,8 @@ static int stmmac_init_dma_engine(struct stmmac_priv *priv)
 				    rx_q->dma_rx_phy, chan);
 
 		rx_q->rx_tail_addr = rx_q->dma_rx_phy +
-			    (DMA_RX_SIZE * sizeof(struct dma_desc));
+				     (priv->dma_rx_size *
+				      sizeof(struct dma_desc));
 		stmmac_set_rx_tail_ptr(priv, priv->ioaddr,
 				       rx_q->rx_tail_addr, chan);
 	}
@@ -2382,12 +2390,12 @@ static void stmmac_set_rings_length(struct stmmac_priv *priv)
 	/* set TX ring length */
 	for (chan = 0; chan < tx_channels_count; chan++)
 		stmmac_set_tx_ring_len(priv, priv->ioaddr,
-				(DMA_TX_SIZE - 1), chan);
+				       (priv->dma_tx_size - 1), chan);
 
 	/* set RX ring length */
 	for (chan = 0; chan < rx_channels_count; chan++)
 		stmmac_set_rx_ring_len(priv, priv->ioaddr,
-				(DMA_RX_SIZE - 1), chan);
+				       (priv->dma_rx_size - 1), chan);
 }
 
 /**
@@ -2767,6 +2775,11 @@ static int stmmac_open(struct net_device *dev)
 
 	priv->rx_copybreak = STMMAC_RX_COPYBREAK;
 
+	if (!priv->dma_tx_size)
+		priv->dma_tx_size = DMA_DEFAULT_TX_SIZE;
+	if (!priv->dma_rx_size)
+		priv->dma_rx_size = DMA_DEFAULT_RX_SIZE;
+
 	/* Earlier check for TBS */
 	for (chan = 0; chan < priv->plat->tx_queues_to_use; chan++) {
 		struct stmmac_tx_queue *tx_q = &priv->tx_queue[chan];
@@ -2936,7 +2949,7 @@ static bool stmmac_vlan_insert(struct stmmac_priv *priv, struct sk_buff *skb,
 		return false;
 
 	stmmac_set_tx_owner(priv, p);
-	tx_q->cur_tx = STMMAC_GET_ENTRY(tx_q->cur_tx, DMA_TX_SIZE);
+	tx_q->cur_tx = STMMAC_GET_ENTRY(tx_q->cur_tx, priv->dma_tx_size);
 	return true;
 }
 
@@ -2964,7 +2977,8 @@ static void stmmac_tso_allocator(struct stmmac_priv *priv, dma_addr_t des,
 	while (tmp_len > 0) {
 		dma_addr_t curr_addr;
 
-		tx_q->cur_tx = STMMAC_GET_ENTRY(tx_q->cur_tx, DMA_TX_SIZE);
+		tx_q->cur_tx = STMMAC_GET_ENTRY(tx_q->cur_tx,
+						priv->dma_tx_size);
 		WARN_ON(tx_q->tx_skbuff[tx_q->cur_tx]);
 
 		if (tx_q->tbs & STMMAC_TBS_AVAIL)
@@ -3071,7 +3085,8 @@ static netdev_tx_t stmmac_tso_xmit(struct sk_buff *skb, struct net_device *dev)
 
 		stmmac_set_mss(priv, mss_desc, mss);
 		tx_q->mss = mss;
-		tx_q->cur_tx = STMMAC_GET_ENTRY(tx_q->cur_tx, DMA_TX_SIZE);
+		tx_q->cur_tx = STMMAC_GET_ENTRY(tx_q->cur_tx,
+						priv->dma_tx_size);
 		WARN_ON(tx_q->tx_skbuff[tx_q->cur_tx]);
 	}
 
@@ -3178,7 +3193,7 @@ static netdev_tx_t stmmac_tso_xmit(struct sk_buff *skb, struct net_device *dev)
 	 * ndo_start_xmit will fill this descriptor the next time it's
 	 * called and stmmac_tx_clean may clean up to this descriptor.
 	 */
-	tx_q->cur_tx = STMMAC_GET_ENTRY(tx_q->cur_tx, DMA_TX_SIZE);
+	tx_q->cur_tx = STMMAC_GET_ENTRY(tx_q->cur_tx, priv->dma_tx_size);
 
 	if (unlikely(stmmac_tx_avail(priv, queue) <= (MAX_SKB_FRAGS + 1))) {
 		netif_dbg(priv, hw, priv->dev, "%s: stop transmitted packets\n",
@@ -3341,7 +3356,7 @@ static netdev_tx_t stmmac_xmit(struct sk_buff *skb, struct net_device *dev)
 		int len = skb_frag_size(frag);
 		bool last_segment = (i == (nfrags - 1));
 
-		entry = STMMAC_GET_ENTRY(entry, DMA_TX_SIZE);
+		entry = STMMAC_GET_ENTRY(entry, priv->dma_tx_size);
 		WARN_ON(tx_q->tx_skbuff[entry]);
 
 		if (likely(priv->extend_desc))
@@ -3409,7 +3424,7 @@ static netdev_tx_t stmmac_xmit(struct sk_buff *skb, struct net_device *dev)
 	 * ndo_start_xmit will fill this descriptor the next time it's
 	 * called and stmmac_tx_clean may clean up to this descriptor.
 	 */
-	entry = STMMAC_GET_ENTRY(entry, DMA_TX_SIZE);
+	entry = STMMAC_GET_ENTRY(entry, priv->dma_tx_size);
 	tx_q->cur_tx = entry;
 
 	if (netif_msg_pktdata(priv)) {
@@ -3594,7 +3609,7 @@ static inline void stmmac_rx_refill(struct stmmac_priv *priv, u32 queue)
 		dma_wmb();
 		stmmac_set_rx_owner(priv, p, use_rx_wd);
 
-		entry = STMMAC_GET_ENTRY(entry, DMA_RX_SIZE);
+		entry = STMMAC_GET_ENTRY(entry, priv->dma_rx_size);
 	}
 	rx_q->dirty_rx = entry;
 	rx_q->rx_tail_addr = rx_q->dma_rx_phy +
@@ -3677,7 +3692,7 @@ static int stmmac_rx(struct stmmac_priv *priv, int limit, u32 queue)
 		else
 			rx_head = (void *)rx_q->dma_rx;
 
-		stmmac_display_ring(priv, rx_head, DMA_RX_SIZE, true);
+		stmmac_display_ring(priv, rx_head, priv->dma_rx_size, true);
 	}
 	while (count < limit) {
 		unsigned int buf1_len = 0, buf2_len = 0;
@@ -3719,7 +3734,8 @@ static int stmmac_rx(struct stmmac_priv *priv, int limit, u32 queue)
 		if (unlikely(status & dma_own))
 			break;
 
-		rx_q->cur_rx = STMMAC_GET_ENTRY(rx_q->cur_rx, DMA_RX_SIZE);
+		rx_q->cur_rx = STMMAC_GET_ENTRY(rx_q->cur_rx,
+						priv->dma_rx_size);
 		next_entry = rx_q->cur_rx;
 
 		if (priv->extend_desc)
@@ -3894,7 +3910,7 @@ static int stmmac_napi_poll_tx(struct napi_struct *napi, int budget)
 
 	priv->xstats.napi_poll++;
 
-	work_done = stmmac_tx_clean(priv, DMA_TX_SIZE, chan);
+	work_done = stmmac_tx_clean(priv, priv->dma_tx_size, chan);
 	work_done = min(work_done, budget);
 
 	if (work_done < budget && napi_complete_done(napi, work_done)) {
@@ -4287,11 +4303,11 @@ static int stmmac_rings_status_show(struct seq_file *seq, void *v)
 		if (priv->extend_desc) {
 			seq_printf(seq, "Extended descriptor ring:\n");
 			sysfs_display_ring((void *)rx_q->dma_erx,
-					   DMA_RX_SIZE, 1, seq);
+					   priv->dma_rx_size, 1, seq);
 		} else {
 			seq_printf(seq, "Descriptor ring:\n");
 			sysfs_display_ring((void *)rx_q->dma_rx,
-					   DMA_RX_SIZE, 0, seq);
+					   priv->dma_rx_size, 0, seq);
 		}
 	}
 
@@ -4303,11 +4319,11 @@ static int stmmac_rings_status_show(struct seq_file *seq, void *v)
 		if (priv->extend_desc) {
 			seq_printf(seq, "Extended descriptor ring:\n");
 			sysfs_display_ring((void *)tx_q->dma_etx,
-					   DMA_TX_SIZE, 1, seq);
+					   priv->dma_tx_size, 1, seq);
 		} else if (!(tx_q->tbs & STMMAC_TBS_AVAIL)) {
 			seq_printf(seq, "Descriptor ring:\n");
 			sysfs_display_ring((void *)tx_q->dma_tx,
-					   DMA_TX_SIZE, 0, seq);
+					   priv->dma_tx_size, 0, seq);
 		}
 	}
 
@@ -4778,6 +4794,23 @@ int stmmac_reinit_queues(struct net_device *dev, u32 rx_cnt, u32 tx_cnt)
 	return ret;
 }
 
+int stmmac_reinit_ringparam(struct net_device *dev, u32 rx_size, u32 tx_size)
+{
+	struct stmmac_priv *priv = netdev_priv(dev);
+	int ret = 0;
+
+	if (netif_running(dev))
+		stmmac_release(dev);
+
+	priv->dma_rx_size = rx_size;
+	priv->dma_tx_size = tx_size;
+
+	if (netif_running(dev))
+		ret = stmmac_open(dev);
+
+	return ret;
+}
+
 /**
  * stmmac_dvr_probe
  * @device: device pointer
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
index bf195adee393..0462dcc93e53 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
@@ -796,7 +796,7 @@ static int stmmac_test_flowctrl(struct stmmac_priv *priv)
 		u32 tail;
 
 		tail = priv->rx_queue[i].dma_rx_phy +
-			(DMA_RX_SIZE * sizeof(struct dma_desc));
+			(priv->dma_rx_size * sizeof(struct dma_desc));
 
 		stmmac_set_rx_tail_ptr(priv, priv->ioaddr, tail, i);
 		stmmac_start_rx(priv, priv->ioaddr, i);
-- 
2.17.0

