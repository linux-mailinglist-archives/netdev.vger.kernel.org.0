Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C007A35DB49
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 11:34:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343574AbhDMJdC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 05:33:02 -0400
Received: from mga05.intel.com ([192.55.52.43]:17206 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245751AbhDMJc4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Apr 2021 05:32:56 -0400
IronPort-SDR: 3o3NpKV6N035xTV4bBznGiyUmYJLyjr/od7OvFk9qv39MGkeEpXdZkpN0COzGODo6zBSS+Gnlh
 cNRfczvIb5dw==
X-IronPort-AV: E=McAfee;i="6200,9189,9952"; a="279681254"
X-IronPort-AV: E=Sophos;i="5.82,219,1613462400"; 
   d="scan'208";a="279681254"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2021 02:32:35 -0700
IronPort-SDR: eYjPnXmx0dR9mpDdGeFmDxICiB8/QGzxfYBMt6jXExw0mVVtcSBUUvslPWRkTa07swzFc/BLIq
 y3nCTLIPAMDg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,219,1613462400"; 
   d="scan'208";a="424178191"
Received: from glass.png.intel.com ([10.158.65.59])
  by orsmga008.jf.intel.com with ESMTP; 13 Apr 2021 02:32:29 -0700
From:   Ong Boon Leong <boon.leong.ong@intel.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     alexandre.torgue@foss.st.com,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, Ong Boon Leong <boon.leong.ong@intel.com>
Subject: [PATCH net-next v2 4/7] net: stmmac: rearrange RX and TX desc init into per-queue basis
Date:   Tue, 13 Apr 2021 17:36:23 +0800
Message-Id: <20210413093626.3447-5-boon.leong.ong@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210413093626.3447-1-boon.leong.ong@intel.com>
References: <20210413093626.3447-1-boon.leong.ong@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Below functions are made to be per-queue in preparation of XDP ZC:

 __init_dma_rx_desc_rings(struct stmmac_priv *priv, u32 queue, gfp_t flags)
 __init_dma_tx_desc_rings(struct stmmac_priv *priv, u32 queue)

The original functions below are stay maintained for all queue usage:

 init_dma_rx_desc_rings(struct net_device *dev, gfp_t flags)
 init_dma_tx_desc_rings(struct net_device *dev)

Signed-off-by: Ong Boon Leong <boon.leong.ong@intel.com>
---
 .../net/ethernet/stmicro/stmmac/stmmac_main.c | 180 ++++++++++--------
 1 file changed, 100 insertions(+), 80 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 7e889ef0c7b5..0804674e628e 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -1575,60 +1575,70 @@ static void stmmac_reinit_rx_buffers(struct stmmac_priv *priv)
 }
 
 /**
- * init_dma_rx_desc_rings - init the RX descriptor rings
- * @dev: net device structure
+ * __init_dma_rx_desc_rings - init the RX descriptor ring (per queue)
+ * @priv: driver private structure
+ * @queue: RX queue index
  * @flags: gfp flag.
  * Description: this function initializes the DMA RX descriptors
  * and allocates the socket buffers. It supports the chained and ring
  * modes.
  */
-static int init_dma_rx_desc_rings(struct net_device *dev, gfp_t flags)
+static int __init_dma_rx_desc_rings(struct stmmac_priv *priv, u32 queue, gfp_t flags)
 {
-	struct stmmac_priv *priv = netdev_priv(dev);
-	u32 rx_count = priv->plat->rx_queues_to_use;
-	int ret = -ENOMEM;
-	int queue;
+	struct stmmac_rx_queue *rx_q = &priv->rx_queue[queue];
+	int ret;
 
-	/* RX INITIALIZATION */
 	netif_dbg(priv, probe, priv->dev,
-		  "SKB addresses:\nskb\t\tskb data\tdma data\n");
+		  "(%s) dma_rx_phy=0x%08x\n", __func__,
+		  (u32)rx_q->dma_rx_phy);
 
-	for (queue = 0; queue < rx_count; queue++) {
-		struct stmmac_rx_queue *rx_q = &priv->rx_queue[queue];
+	stmmac_clear_rx_descriptors(priv, queue);
 
+	WARN_ON(xdp_rxq_info_reg_mem_model(&rx_q->xdp_rxq,
+					   MEM_TYPE_PAGE_POOL,
+					   rx_q->page_pool));
 
-		netif_dbg(priv, probe, priv->dev,
-			  "(%s) dma_rx_phy=0x%08x\n", __func__,
-			  (u32)rx_q->dma_rx_phy);
+	netdev_info(priv->dev,
+		    "Register MEM_TYPE_PAGE_POOL RxQ-%d\n",
+		    rx_q->queue_index);
 
-		stmmac_clear_rx_descriptors(priv, queue);
+	ret = stmmac_alloc_rx_buffers(priv, queue, flags);
+	if (ret < 0)
+		return -ENOMEM;
 
-		WARN_ON(xdp_rxq_info_reg_mem_model(&rx_q->xdp_rxq,
-						   MEM_TYPE_PAGE_POOL,
-						   rx_q->page_pool));
+	rx_q->cur_rx = 0;
+	rx_q->dirty_rx = 0;
 
-		netdev_info(priv->dev,
-			    "Register MEM_TYPE_PAGE_POOL RxQ-%d\n",
-			    rx_q->queue_index);
+	/* Setup the chained descriptor addresses */
+	if (priv->mode == STMMAC_CHAIN_MODE) {
+		if (priv->extend_desc)
+			stmmac_mode_init(priv, rx_q->dma_erx,
+					 rx_q->dma_rx_phy,
+					 priv->dma_rx_size, 1);
+		else
+			stmmac_mode_init(priv, rx_q->dma_rx,
+					 rx_q->dma_rx_phy,
+					 priv->dma_rx_size, 0);
+	}
 
-		ret = stmmac_alloc_rx_buffers(priv, queue, flags);
-		if (ret < 0)
-			goto err_init_rx_buffers;
+	return 0;
+}
 
-		rx_q->cur_rx = 0;
-		rx_q->dirty_rx = 0;
+static int init_dma_rx_desc_rings(struct net_device *dev, gfp_t flags)
+{
+	struct stmmac_priv *priv = netdev_priv(dev);
+	u32 rx_count = priv->plat->rx_queues_to_use;
+	u32 queue;
+	int ret;
 
-		/* Setup the chained descriptor addresses */
-		if (priv->mode == STMMAC_CHAIN_MODE) {
-			if (priv->extend_desc)
-				stmmac_mode_init(priv, rx_q->dma_erx,
-						 rx_q->dma_rx_phy,
-						 priv->dma_rx_size, 1);
-			else
-				stmmac_mode_init(priv, rx_q->dma_rx,
-						 rx_q->dma_rx_phy,
-						 priv->dma_rx_size, 0);
-		}
+	/* RX INITIALIZATION */
+	netif_dbg(priv, probe, priv->dev,
+		  "SKB addresses:\nskb\t\tskb data\tdma data\n");
+
+	for (queue = 0; queue < rx_count; queue++) {
+		ret = __init_dma_rx_desc_rings(priv, queue, flags);
+		if (ret)
+			goto err_init_rx_buffers;
 	}
 
 	return 0;
@@ -1647,63 +1657,73 @@ static int init_dma_rx_desc_rings(struct net_device *dev, gfp_t flags)
 }
 
 /**
- * init_dma_tx_desc_rings - init the TX descriptor rings
- * @dev: net device structure.
+ * __init_dma_tx_desc_rings - init the TX descriptor ring (per queue)
+ * @priv: driver private structure
+ * @queue : TX queue index
  * Description: this function initializes the DMA TX descriptors
  * and allocates the socket buffers. It supports the chained and ring
  * modes.
  */
-static int init_dma_tx_desc_rings(struct net_device *dev)
+static int __init_dma_tx_desc_rings(struct stmmac_priv *priv, u32 queue)
 {
-	struct stmmac_priv *priv = netdev_priv(dev);
-	u32 tx_queue_cnt = priv->plat->tx_queues_to_use;
-	u32 queue;
+	struct stmmac_tx_queue *tx_q = &priv->tx_queue[queue];
 	int i;
 
-	for (queue = 0; queue < tx_queue_cnt; queue++) {
-		struct stmmac_tx_queue *tx_q = &priv->tx_queue[queue];
-
-		netif_dbg(priv, probe, priv->dev,
-			  "(%s) dma_tx_phy=0x%08x\n", __func__,
-			 (u32)tx_q->dma_tx_phy);
-
-		/* Setup the chained descriptor addresses */
-		if (priv->mode == STMMAC_CHAIN_MODE) {
-			if (priv->extend_desc)
-				stmmac_mode_init(priv, tx_q->dma_etx,
-						 tx_q->dma_tx_phy,
-						 priv->dma_tx_size, 1);
-			else if (!(tx_q->tbs & STMMAC_TBS_AVAIL))
-				stmmac_mode_init(priv, tx_q->dma_tx,
-						 tx_q->dma_tx_phy,
-						 priv->dma_tx_size, 0);
-		}
+	netif_dbg(priv, probe, priv->dev,
+		  "(%s) dma_tx_phy=0x%08x\n", __func__,
+		  (u32)tx_q->dma_tx_phy);
 
-		for (i = 0; i < priv->dma_tx_size; i++) {
-			struct dma_desc *p;
-			if (priv->extend_desc)
-				p = &((tx_q->dma_etx + i)->basic);
-			else if (tx_q->tbs & STMMAC_TBS_AVAIL)
-				p = &((tx_q->dma_entx + i)->basic);
-			else
-				p = tx_q->dma_tx + i;
+	/* Setup the chained descriptor addresses */
+	if (priv->mode == STMMAC_CHAIN_MODE) {
+		if (priv->extend_desc)
+			stmmac_mode_init(priv, tx_q->dma_etx,
+					 tx_q->dma_tx_phy,
+					 priv->dma_tx_size, 1);
+		else if (!(tx_q->tbs & STMMAC_TBS_AVAIL))
+			stmmac_mode_init(priv, tx_q->dma_tx,
+					 tx_q->dma_tx_phy,
+					 priv->dma_tx_size, 0);
+	}
 
-			stmmac_clear_desc(priv, p);
+	for (i = 0; i < priv->dma_tx_size; i++) {
+		struct dma_desc *p;
 
-			tx_q->tx_skbuff_dma[i].buf = 0;
-			tx_q->tx_skbuff_dma[i].map_as_page = false;
-			tx_q->tx_skbuff_dma[i].len = 0;
-			tx_q->tx_skbuff_dma[i].last_segment = false;
-			tx_q->tx_skbuff[i] = NULL;
-		}
+		if (priv->extend_desc)
+			p = &((tx_q->dma_etx + i)->basic);
+		else if (tx_q->tbs & STMMAC_TBS_AVAIL)
+			p = &((tx_q->dma_entx + i)->basic);
+		else
+			p = tx_q->dma_tx + i;
 
-		tx_q->dirty_tx = 0;
-		tx_q->cur_tx = 0;
-		tx_q->mss = 0;
+		stmmac_clear_desc(priv, p);
 
-		netdev_tx_reset_queue(netdev_get_tx_queue(priv->dev, queue));
+		tx_q->tx_skbuff_dma[i].buf = 0;
+		tx_q->tx_skbuff_dma[i].map_as_page = false;
+		tx_q->tx_skbuff_dma[i].len = 0;
+		tx_q->tx_skbuff_dma[i].last_segment = false;
+		tx_q->tx_skbuff[i] = NULL;
 	}
 
+	tx_q->dirty_tx = 0;
+	tx_q->cur_tx = 0;
+	tx_q->mss = 0;
+
+	netdev_tx_reset_queue(netdev_get_tx_queue(priv->dev, queue));
+
+	return 0;
+}
+
+static int init_dma_tx_desc_rings(struct net_device *dev)
+{
+	struct stmmac_priv *priv = netdev_priv(dev);
+	u32 tx_queue_cnt;
+	u32 queue;
+
+	tx_queue_cnt = priv->plat->tx_queues_to_use;
+
+	for (queue = 0; queue < tx_queue_cnt; queue++)
+		__init_dma_tx_desc_rings(priv, queue);
+
 	return 0;
 }
 
-- 
2.25.1

