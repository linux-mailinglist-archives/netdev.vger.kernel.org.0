Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82EA335CA19
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 17:38:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243020AbhDLPhs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 11:37:48 -0400
Received: from mga05.intel.com ([192.55.52.43]:41987 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243002AbhDLPhr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Apr 2021 11:37:47 -0400
IronPort-SDR: bIP6XHNUPUoNcK8eylvrkKGI9H1OYI8nHxaTUG7Zfj7oh9hMIdt8+eDHXQ4OHDdsQNf2L2X2uo
 5HE12cN3+J+Q==
X-IronPort-AV: E=McAfee;i="6200,9189,9952"; a="279520347"
X-IronPort-AV: E=Sophos;i="5.82,216,1613462400"; 
   d="scan'208";a="279520347"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2021 08:37:27 -0700
IronPort-SDR: bd+EADXBvpH+5fMGfOG23IswEqIT2UHjFMkiCtd7FVK+CPqidADNdIMjGm5EiTdDzu0uiboKeD
 qbMp2p7zfcng==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,216,1613462400"; 
   d="scan'208";a="614609580"
Received: from glass.png.intel.com ([10.158.65.59])
  by fmsmga005.fm.intel.com with ESMTP; 12 Apr 2021 08:37:22 -0700
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
Cc:     Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, Ong Boon Leong <boon.leong.ong@intel.com>
Subject: [PATCH net-next 3/7] net: stmmac: refactor stmmac_init_rx_buffers for stmmac_reinit_rx_buffers
Date:   Mon, 12 Apr 2021 23:41:26 +0800
Message-Id: <20210412154130.20742-4-boon.leong.ong@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210412154130.20742-1-boon.leong.ong@intel.com>
References: <20210412154130.20742-1-boon.leong.ong@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The per-queue RX buffer allocation in stmmac_reinit_rx_buffers() can be
made to use stmmac_alloc_rx_buffers() by merging the page_pool alloc
checks for "buf->page" and "buf->sec_page" in stmmac_init_rx_buffers().

This is in preparation for XSK pool allocation later.

Signed-off-by: Ong Boon Leong <boon.leong.ong@intel.com>
---
 .../net/ethernet/stmicro/stmmac/stmmac_main.c | 378 +++++++++---------
 1 file changed, 189 insertions(+), 189 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index a6c3414fd231..7e889ef0c7b5 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -1388,12 +1388,14 @@ static int stmmac_init_rx_buffers(struct stmmac_priv *priv, struct dma_desc *p,
 	struct stmmac_rx_queue *rx_q = &priv->rx_queue[queue];
 	struct stmmac_rx_buffer *buf = &rx_q->buf_pool[i];
 
-	buf->page = page_pool_dev_alloc_pages(rx_q->page_pool);
-	if (!buf->page)
-		return -ENOMEM;
-	buf->page_offset = stmmac_rx_offset(priv);
+	if (!buf->page) {
+		buf->page = page_pool_dev_alloc_pages(rx_q->page_pool);
+		if (!buf->page)
+			return -ENOMEM;
+		buf->page_offset = stmmac_rx_offset(priv);
+	}
 
-	if (priv->sph) {
+	if (priv->sph && !buf->sec_page) {
 		buf->sec_page = page_pool_dev_alloc_pages(rx_q->page_pool);
 		if (!buf->sec_page)
 			return -ENOMEM;
@@ -1547,48 +1549,16 @@ static void stmmac_reinit_rx_buffers(struct stmmac_priv *priv)
 {
 	u32 rx_count = priv->plat->rx_queues_to_use;
 	u32 queue;
-	int i;
 
 	for (queue = 0; queue < rx_count; queue++)
 		dma_recycle_rx_skbufs(priv, queue);
 
 	for (queue = 0; queue < rx_count; queue++) {
-		struct stmmac_rx_queue *rx_q = &priv->rx_queue[queue];
-
-		for (i = 0; i < priv->dma_rx_size; i++) {
-			struct stmmac_rx_buffer *buf = &rx_q->buf_pool[i];
-			struct dma_desc *p;
-
-			if (priv->extend_desc)
-				p = &((rx_q->dma_erx + i)->basic);
-			else
-				p = rx_q->dma_rx + i;
-
-			if (!buf->page) {
-				buf->page = page_pool_dev_alloc_pages(rx_q->page_pool);
-				if (!buf->page)
-					goto err_reinit_rx_buffers;
-
-				buf->addr = page_pool_get_dma_addr(buf->page) +
-					    buf->page_offset;
-			}
-
-			if (priv->sph && !buf->sec_page) {
-				buf->sec_page = page_pool_dev_alloc_pages(rx_q->page_pool);
-				if (!buf->sec_page)
-					goto err_reinit_rx_buffers;
-
-				buf->sec_addr = page_pool_get_dma_addr(buf->sec_page);
-			}
+		int ret;
 
-			stmmac_set_desc_addr(priv, p, buf->addr);
-			if (priv->sph)
-				stmmac_set_desc_sec_addr(priv, p, buf->sec_addr, true);
-			else
-				stmmac_set_desc_sec_addr(priv, p, buf->sec_addr, false);
-			if (priv->dma_buf_sz == BUF_SIZE_16KiB)
-				stmmac_init_desc3(priv, p);
-		}
+		ret = stmmac_alloc_rx_buffers(priv, queue, GFP_KERNEL);
+		if (ret < 0)
+			goto err_reinit_rx_buffers;
 	}
 
 	return;
@@ -1791,153 +1761,173 @@ static void stmmac_free_tx_skbufs(struct stmmac_priv *priv)
 }
 
 /**
- * free_dma_rx_desc_resources - free RX dma desc resources
+ * __free_dma_rx_desc_resources - free RX dma desc resources (per queue)
  * @priv: private structure
+ * @queue: RX queue index
  */
-static void free_dma_rx_desc_resources(struct stmmac_priv *priv)
+static void __free_dma_rx_desc_resources(struct stmmac_priv *priv, u32 queue)
 {
-	u32 rx_count = priv->plat->rx_queues_to_use;
-	u32 queue;
+	struct stmmac_rx_queue *rx_q = &priv->rx_queue[queue];
 
-	/* Free RX queue resources */
-	for (queue = 0; queue < rx_count; queue++) {
-		struct stmmac_rx_queue *rx_q = &priv->rx_queue[queue];
+	/* Release the DMA RX socket buffers */
+	dma_free_rx_skbufs(priv, queue);
 
-		/* Release the DMA RX socket buffers */
-		dma_free_rx_skbufs(priv, queue);
+	/* Free DMA regions of consistent memory previously allocated */
+	if (!priv->extend_desc)
+		dma_free_coherent(priv->device, priv->dma_rx_size *
+				  sizeof(struct dma_desc),
+				  rx_q->dma_rx, rx_q->dma_rx_phy);
+	else
+		dma_free_coherent(priv->device, priv->dma_rx_size *
+				  sizeof(struct dma_extended_desc),
+				  rx_q->dma_erx, rx_q->dma_rx_phy);
 
-		/* Free DMA regions of consistent memory previously allocated */
-		if (!priv->extend_desc)
-			dma_free_coherent(priv->device, priv->dma_rx_size *
-					  sizeof(struct dma_desc),
-					  rx_q->dma_rx, rx_q->dma_rx_phy);
-		else
-			dma_free_coherent(priv->device, priv->dma_rx_size *
-					  sizeof(struct dma_extended_desc),
-					  rx_q->dma_erx, rx_q->dma_rx_phy);
+	if (xdp_rxq_info_is_reg(&rx_q->xdp_rxq))
+		xdp_rxq_info_unreg(&rx_q->xdp_rxq);
 
-		if (xdp_rxq_info_is_reg(&rx_q->xdp_rxq))
-			xdp_rxq_info_unreg(&rx_q->xdp_rxq);
+	kfree(rx_q->buf_pool);
+	if (rx_q->page_pool)
+		page_pool_destroy(rx_q->page_pool);
+}
 
-		kfree(rx_q->buf_pool);
-		if (rx_q->page_pool)
-			page_pool_destroy(rx_q->page_pool);
-	}
+static void free_dma_rx_desc_resources(struct stmmac_priv *priv)
+{
+	u32 rx_count = priv->plat->rx_queues_to_use;
+	u32 queue;
+
+	/* Free RX queue resources */
+	for (queue = 0; queue < rx_count; queue++)
+		__free_dma_rx_desc_resources(priv, queue);
 }
 
 /**
- * free_dma_tx_desc_resources - free TX dma desc resources
+ * __free_dma_tx_desc_resources - free TX dma desc resources (per queue)
  * @priv: private structure
+ * @queue: TX queue index
  */
-static void free_dma_tx_desc_resources(struct stmmac_priv *priv)
+static void __free_dma_tx_desc_resources(struct stmmac_priv *priv, u32 queue)
 {
-	u32 tx_count = priv->plat->tx_queues_to_use;
-	u32 queue;
+	struct stmmac_tx_queue *tx_q = &priv->tx_queue[queue];
+	size_t size;
+	void *addr;
 
-	/* Free TX queue resources */
-	for (queue = 0; queue < tx_count; queue++) {
-		struct stmmac_tx_queue *tx_q = &priv->tx_queue[queue];
-		size_t size;
-		void *addr;
+	/* Release the DMA TX socket buffers */
+	dma_free_tx_skbufs(priv, queue);
+
+	if (priv->extend_desc) {
+		size = sizeof(struct dma_extended_desc);
+		addr = tx_q->dma_etx;
+	} else if (tx_q->tbs & STMMAC_TBS_AVAIL) {
+		size = sizeof(struct dma_edesc);
+		addr = tx_q->dma_entx;
+	} else {
+		size = sizeof(struct dma_desc);
+		addr = tx_q->dma_tx;
+	}
 
-		/* Release the DMA TX socket buffers */
-		dma_free_tx_skbufs(priv, queue);
+	size *= priv->dma_tx_size;
 
-		if (priv->extend_desc) {
-			size = sizeof(struct dma_extended_desc);
-			addr = tx_q->dma_etx;
-		} else if (tx_q->tbs & STMMAC_TBS_AVAIL) {
-			size = sizeof(struct dma_edesc);
-			addr = tx_q->dma_entx;
-		} else {
-			size = sizeof(struct dma_desc);
-			addr = tx_q->dma_tx;
-		}
+	dma_free_coherent(priv->device, size, addr, tx_q->dma_tx_phy);
 
-		size *= priv->dma_tx_size;
+	kfree(tx_q->tx_skbuff_dma);
+	kfree(tx_q->tx_skbuff);
+}
 
-		dma_free_coherent(priv->device, size, addr, tx_q->dma_tx_phy);
+static void free_dma_tx_desc_resources(struct stmmac_priv *priv)
+{
+	u32 tx_count = priv->plat->tx_queues_to_use;
+	u32 queue;
 
-		kfree(tx_q->tx_skbuff_dma);
-		kfree(tx_q->tx_skbuff);
-	}
+	/* Free TX queue resources */
+	for (queue = 0; queue < tx_count; queue++)
+		__free_dma_tx_desc_resources(priv, queue);
 }
 
 /**
- * alloc_dma_rx_desc_resources - alloc RX resources.
+ * __alloc_dma_rx_desc_resources - alloc RX resources (per queue).
  * @priv: private structure
+ * @queue: RX queue index
  * Description: according to which descriptor can be used (extend or basic)
  * this function allocates the resources for TX and RX paths. In case of
  * reception, for example, it pre-allocated the RX socket buffer in order to
  * allow zero-copy mechanism.
  */
-static int alloc_dma_rx_desc_resources(struct stmmac_priv *priv)
+static int __alloc_dma_rx_desc_resources(struct stmmac_priv *priv, u32 queue)
 {
+	struct stmmac_rx_queue *rx_q = &priv->rx_queue[queue];
+	struct stmmac_channel *ch = &priv->channel[queue];
 	bool xdp_prog = stmmac_xdp_is_enabled(priv);
-	u32 rx_count = priv->plat->rx_queues_to_use;
-	int ret = -ENOMEM;
-	u32 queue;
+	struct page_pool_params pp_params = { 0 };
+	unsigned int num_pages;
+	int ret;
 
-	/* RX queues buffers and DMA */
-	for (queue = 0; queue < rx_count; queue++) {
-		struct stmmac_rx_queue *rx_q = &priv->rx_queue[queue];
-		struct stmmac_channel *ch = &priv->channel[queue];
-		struct page_pool_params pp_params = { 0 };
-		unsigned int num_pages;
-		int ret;
+	rx_q->queue_index = queue;
+	rx_q->priv_data = priv;
+
+	pp_params.flags = PP_FLAG_DMA_MAP | PP_FLAG_DMA_SYNC_DEV;
+	pp_params.pool_size = priv->dma_rx_size;
+	num_pages = DIV_ROUND_UP(priv->dma_buf_sz, PAGE_SIZE);
+	pp_params.order = ilog2(num_pages);
+	pp_params.nid = dev_to_node(priv->device);
+	pp_params.dev = priv->device;
+	pp_params.dma_dir = xdp_prog ? DMA_BIDIRECTIONAL : DMA_FROM_DEVICE;
+	pp_params.offset = stmmac_rx_offset(priv);
+	pp_params.max_len = STMMAC_MAX_RX_BUF_SIZE(num_pages);
+
+	rx_q->page_pool = page_pool_create(&pp_params);
+	if (IS_ERR(rx_q->page_pool)) {
+		ret = PTR_ERR(rx_q->page_pool);
+		rx_q->page_pool = NULL;
+		return ret;
+	}
 
-		rx_q->queue_index = queue;
-		rx_q->priv_data = priv;
-
-		pp_params.flags = PP_FLAG_DMA_MAP | PP_FLAG_DMA_SYNC_DEV;
-		pp_params.pool_size = priv->dma_rx_size;
-		num_pages = DIV_ROUND_UP(priv->dma_buf_sz, PAGE_SIZE);
-		pp_params.order = ilog2(num_pages);
-		pp_params.nid = dev_to_node(priv->device);
-		pp_params.dev = priv->device;
-		pp_params.dma_dir = xdp_prog ? DMA_BIDIRECTIONAL : DMA_FROM_DEVICE;
-		pp_params.offset = stmmac_rx_offset(priv);
-		pp_params.max_len = STMMAC_MAX_RX_BUF_SIZE(num_pages);
-
-		rx_q->page_pool = page_pool_create(&pp_params);
-		if (IS_ERR(rx_q->page_pool)) {
-			ret = PTR_ERR(rx_q->page_pool);
-			rx_q->page_pool = NULL;
-			goto err_dma;
-		}
+	rx_q->buf_pool = kcalloc(priv->dma_rx_size,
+				 sizeof(*rx_q->buf_pool),
+				 GFP_KERNEL);
+	if (!rx_q->buf_pool)
+		return -ENOMEM;
 
-		rx_q->buf_pool = kcalloc(priv->dma_rx_size,
-					 sizeof(*rx_q->buf_pool),
-					 GFP_KERNEL);
-		if (!rx_q->buf_pool)
-			goto err_dma;
+	if (priv->extend_desc) {
+		rx_q->dma_erx = dma_alloc_coherent(priv->device,
+						   priv->dma_rx_size *
+						   sizeof(struct dma_extended_desc),
+						   &rx_q->dma_rx_phy,
+						   GFP_KERNEL);
+		if (!rx_q->dma_erx)
+			return -ENOMEM;
 
-		if (priv->extend_desc) {
-			rx_q->dma_erx = dma_alloc_coherent(priv->device,
-							   priv->dma_rx_size *
-							   sizeof(struct dma_extended_desc),
-							   &rx_q->dma_rx_phy,
-							   GFP_KERNEL);
-			if (!rx_q->dma_erx)
-				goto err_dma;
+	} else {
+		rx_q->dma_rx = dma_alloc_coherent(priv->device,
+						  priv->dma_rx_size *
+						  sizeof(struct dma_desc),
+						  &rx_q->dma_rx_phy,
+						  GFP_KERNEL);
+		if (!rx_q->dma_rx)
+			return -ENOMEM;
+	}
 
-		} else {
-			rx_q->dma_rx = dma_alloc_coherent(priv->device,
-							  priv->dma_rx_size *
-							  sizeof(struct dma_desc),
-							  &rx_q->dma_rx_phy,
-							  GFP_KERNEL);
-			if (!rx_q->dma_rx)
-				goto err_dma;
-		}
+	ret = xdp_rxq_info_reg(&rx_q->xdp_rxq, priv->dev,
+			       rx_q->queue_index,
+			       ch->rx_napi.napi_id);
+	if (ret) {
+		netdev_err(priv->dev, "Failed to register xdp rxq info\n");
+		return -EINVAL;
+	}
 
-		ret = xdp_rxq_info_reg(&rx_q->xdp_rxq, priv->dev,
-				       rx_q->queue_index,
-				       ch->rx_napi.napi_id);
-		if (ret) {
-			netdev_err(priv->dev, "Failed to register xdp rxq info\n");
+	return 0;
+}
+
+static int alloc_dma_rx_desc_resources(struct stmmac_priv *priv)
+{
+	u32 rx_count = priv->plat->rx_queues_to_use;
+	u32 queue;
+	int ret;
+
+	/* RX queues buffers and DMA */
+	for (queue = 0; queue < rx_count; queue++) {
+		ret = __alloc_dma_rx_desc_resources(priv, queue);
+		if (ret)
 			goto err_dma;
-		}
 	}
 
 	return 0;
@@ -1949,60 +1939,70 @@ static int alloc_dma_rx_desc_resources(struct stmmac_priv *priv)
 }
 
 /**
- * alloc_dma_tx_desc_resources - alloc TX resources.
+ * __alloc_dma_tx_desc_resources - alloc TX resources (per queue).
  * @priv: private structure
+ * @queue: TX queue index
  * Description: according to which descriptor can be used (extend or basic)
  * this function allocates the resources for TX and RX paths. In case of
  * reception, for example, it pre-allocated the RX socket buffer in order to
  * allow zero-copy mechanism.
  */
-static int alloc_dma_tx_desc_resources(struct stmmac_priv *priv)
+static int __alloc_dma_tx_desc_resources(struct stmmac_priv *priv, u32 queue)
 {
-	u32 tx_count = priv->plat->tx_queues_to_use;
-	int ret = -ENOMEM;
-	u32 queue;
+	struct stmmac_tx_queue *tx_q = &priv->tx_queue[queue];
+	size_t size;
+	void *addr;
 
-	/* TX queues buffers and DMA */
-	for (queue = 0; queue < tx_count; queue++) {
-		struct stmmac_tx_queue *tx_q = &priv->tx_queue[queue];
-		size_t size;
-		void *addr;
+	tx_q->queue_index = queue;
+	tx_q->priv_data = priv;
 
-		tx_q->queue_index = queue;
-		tx_q->priv_data = priv;
+	tx_q->tx_skbuff_dma = kcalloc(priv->dma_tx_size,
+				      sizeof(*tx_q->tx_skbuff_dma),
+				      GFP_KERNEL);
+	if (!tx_q->tx_skbuff_dma)
+		return -ENOMEM;
 
-		tx_q->tx_skbuff_dma = kcalloc(priv->dma_tx_size,
-					      sizeof(*tx_q->tx_skbuff_dma),
-					      GFP_KERNEL);
-		if (!tx_q->tx_skbuff_dma)
-			goto err_dma;
+	tx_q->tx_skbuff = kcalloc(priv->dma_tx_size,
+				  sizeof(struct sk_buff *),
+				  GFP_KERNEL);
+	if (!tx_q->tx_skbuff)
+		return -ENOMEM;
 
-		tx_q->tx_skbuff = kcalloc(priv->dma_tx_size,
-					  sizeof(struct sk_buff *),
-					  GFP_KERNEL);
-		if (!tx_q->tx_skbuff)
-			goto err_dma;
+	if (priv->extend_desc)
+		size = sizeof(struct dma_extended_desc);
+	else if (tx_q->tbs & STMMAC_TBS_AVAIL)
+		size = sizeof(struct dma_edesc);
+	else
+		size = sizeof(struct dma_desc);
 
-		if (priv->extend_desc)
-			size = sizeof(struct dma_extended_desc);
-		else if (tx_q->tbs & STMMAC_TBS_AVAIL)
-			size = sizeof(struct dma_edesc);
-		else
-			size = sizeof(struct dma_desc);
+	size *= priv->dma_tx_size;
 
-		size *= priv->dma_tx_size;
+	addr = dma_alloc_coherent(priv->device, size,
+				  &tx_q->dma_tx_phy, GFP_KERNEL);
+	if (!addr)
+		return -ENOMEM;
 
-		addr = dma_alloc_coherent(priv->device, size,
-					  &tx_q->dma_tx_phy, GFP_KERNEL);
-		if (!addr)
-			goto err_dma;
+	if (priv->extend_desc)
+		tx_q->dma_etx = addr;
+	else if (tx_q->tbs & STMMAC_TBS_AVAIL)
+		tx_q->dma_entx = addr;
+	else
+		tx_q->dma_tx = addr;
 
-		if (priv->extend_desc)
-			tx_q->dma_etx = addr;
-		else if (tx_q->tbs & STMMAC_TBS_AVAIL)
-			tx_q->dma_entx = addr;
-		else
-			tx_q->dma_tx = addr;
+	return 0;
+}
+
+static int alloc_dma_tx_desc_resources(struct stmmac_priv *priv)
+{
+	u32 tx_count = priv->plat->tx_queues_to_use;
+	u32 queue;
+	int ret;
+
+	/* TX queues buffers and DMA */
+	for (queue = 0; queue < tx_count; queue++) {
+		ret = __alloc_dma_tx_desc_resources(priv, queue);
+		if (ret)
+			goto err_dma;
 	}
 
 	return 0;
-- 
2.25.1

