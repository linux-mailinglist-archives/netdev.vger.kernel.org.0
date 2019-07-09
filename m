Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD47163292
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 10:03:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726636AbfGIID0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jul 2019 04:03:26 -0400
Received: from smtprelay-out1.synopsys.com ([198.182.61.142]:48378 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726251AbfGIIDS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jul 2019 04:03:18 -0400
Received: from mailhost.synopsys.com (mdc-mailhost1.synopsys.com [10.225.0.209])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id CB6FBC0A74;
        Tue,  9 Jul 2019 08:03:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1562659397; bh=utgIZ0MmwGeJhJE+hj23sGGUTNvCL1/79z2dgnYS5tY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=j9gmMQ4uPZltW4u3nOOTLReJUBMZOvlLSPWgqu92siVf7ttYmgklA90F6TNPfBhd0
         UgVgsvqw/40ma84IpB/WSeulDJ25n6uEt4lvXUug4NoVK8Emn1cFOWQ/nSvCz1BnvS
         +3V0fLPJi/VOzjcL2DV1qS5s2mBs+F8w12Sdpb6N3CgaHTlAnnrkxDwHYo0zQfYgcr
         2q/BrkBov5wWsXaDS7th3sUOzlsFSzWV1bD4tInbl+KSTXCU+zev5mmETSYCsqo67T
         v0hB1SngUA4DIZiJvN9w3Rr/TPTeBgvn3MxqDGcHF00YCSVhM3XokvZDzs6r8ZVuBp
         gMg2d18wx0CHA==
Received: from de02.synopsys.com (de02.internal.synopsys.com [10.225.17.21])
        by mailhost.synopsys.com (Postfix) with ESMTP id EFFBBA005F;
        Tue,  9 Jul 2019 08:03:13 +0000 (UTC)
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by de02.synopsys.com (Postfix) with ESMTP id 877F23F836;
        Tue,  9 Jul 2019 10:03:13 +0200 (CEST)
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     netdev@vger.kernel.org
Cc:     Joao Pinto <Joao.Pinto@synopsys.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH net-next v4 3/3] net: stmmac: Introducing support for Page Pool
Date:   Tue,  9 Jul 2019 10:03:00 +0200
Message-Id: <a984010950c1f7a509808282fbfa5b7c157948c5.1562659012.git.joabreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1562659012.git.joabreu@synopsys.com>
References: <cover.1562659012.git.joabreu@synopsys.com>
In-Reply-To: <cover.1562659012.git.joabreu@synopsys.com>
References: <cover.1562659012.git.joabreu@synopsys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mapping and unmapping DMA region is an high bottleneck in stmmac driver,
specially in the RX path.

This commit introduces support for Page Pool API and uses it in all RX
queues. With this change, we get more stable troughput and some increase
of banwidth with iperf:
	- MAC1000 - 950 Mbps
	- XGMAC: 9.22 Gbps

Changes from v3:
	- Use page_pool_destroy() (Ilias)
Changes from v2:
	- Uncoditionally call page_pool_free() (Jesper)
Changes from v1:
	- Use page_pool_get_dma_addr() (Jesper)
	- Add a comment (Jesper)
	- Add page_pool_free() call (Jesper)
	- Reintroduce sync_single_for_device (Arnd / Ilias)

Signed-off-by: Jose Abreu <joabreu@synopsys.com>
Acked-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>

---
Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>
Cc: Alexandre Torgue <alexandre.torgue@st.com>
Cc: Jose Abreu <joabreu@synopsys.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc: netdev@vger.kernel.org
Cc: linux-stm32@st-md-mailman.stormreply.com
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Cc: Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/ethernet/stmicro/stmmac/Kconfig       |   1 +
 drivers/net/ethernet/stmicro/stmmac/stmmac.h      |  10 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 203 +++++++---------------
 3 files changed, 70 insertions(+), 144 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/Kconfig b/drivers/net/ethernet/stmicro/stmmac/Kconfig
index 943189dcccb1..2325b40dff6e 100644
--- a/drivers/net/ethernet/stmicro/stmmac/Kconfig
+++ b/drivers/net/ethernet/stmicro/stmmac/Kconfig
@@ -3,6 +3,7 @@ config STMMAC_ETH
 	tristate "STMicroelectronics Multi-Gigabit Ethernet driver"
 	depends on HAS_IOMEM && HAS_DMA
 	select MII
+	select PAGE_POOL
 	select PHYLINK
 	select CRC32
 	imply PTP_1588_CLOCK
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac.h b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
index 513f4e2df5f6..5cd966c154f3 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac.h
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
@@ -20,6 +20,7 @@
 #include <linux/ptp_clock_kernel.h>
 #include <linux/net_tstamp.h>
 #include <linux/reset.h>
+#include <net/page_pool.h>
 
 struct stmmac_resources {
 	void __iomem *addr;
@@ -54,14 +55,19 @@ struct stmmac_tx_queue {
 	u32 mss;
 };
 
+struct stmmac_rx_buffer {
+	struct page *page;
+	dma_addr_t addr;
+};
+
 struct stmmac_rx_queue {
 	u32 rx_count_frames;
 	u32 queue_index;
+	struct page_pool *page_pool;
+	struct stmmac_rx_buffer *buf_pool;
 	struct stmmac_priv *priv_data;
 	struct dma_extended_desc *dma_erx;
 	struct dma_desc *dma_rx ____cacheline_aligned_in_smp;
-	struct sk_buff **rx_skbuff;
-	dma_addr_t *rx_skbuff_dma;
 	unsigned int cur_rx;
 	unsigned int dirty_rx;
 	u32 rx_zeroc_thresh;
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index c142e9367a68..00f2df304e28 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -1197,26 +1197,14 @@ static int stmmac_init_rx_buffers(struct stmmac_priv *priv, struct dma_desc *p,
 				  int i, gfp_t flags, u32 queue)
 {
 	struct stmmac_rx_queue *rx_q = &priv->rx_queue[queue];
-	struct sk_buff *skb;
+	struct stmmac_rx_buffer *buf = &rx_q->buf_pool[i];
 
-	skb = __netdev_alloc_skb_ip_align(priv->dev, priv->dma_buf_sz, flags);
-	if (!skb) {
-		netdev_err(priv->dev,
-			   "%s: Rx init fails; skb is NULL\n", __func__);
+	buf->page = page_pool_dev_alloc_pages(rx_q->page_pool);
+	if (!buf->page)
 		return -ENOMEM;
-	}
-	rx_q->rx_skbuff[i] = skb;
-	rx_q->rx_skbuff_dma[i] = dma_map_single(priv->device, skb->data,
-						priv->dma_buf_sz,
-						DMA_FROM_DEVICE);
-	if (dma_mapping_error(priv->device, rx_q->rx_skbuff_dma[i])) {
-		netdev_err(priv->dev, "%s: DMA mapping error\n", __func__);
-		dev_kfree_skb_any(skb);
-		return -EINVAL;
-	}
-
-	stmmac_set_desc_addr(priv, p, rx_q->rx_skbuff_dma[i]);
 
+	buf->addr = page_pool_get_dma_addr(buf->page);
+	stmmac_set_desc_addr(priv, p, buf->addr);
 	if (priv->dma_buf_sz == BUF_SIZE_16KiB)
 		stmmac_init_desc3(priv, p);
 
@@ -1232,13 +1220,11 @@ static int stmmac_init_rx_buffers(struct stmmac_priv *priv, struct dma_desc *p,
 static void stmmac_free_rx_buffer(struct stmmac_priv *priv, u32 queue, int i)
 {
 	struct stmmac_rx_queue *rx_q = &priv->rx_queue[queue];
+	struct stmmac_rx_buffer *buf = &rx_q->buf_pool[i];
 
-	if (rx_q->rx_skbuff[i]) {
-		dma_unmap_single(priv->device, rx_q->rx_skbuff_dma[i],
-				 priv->dma_buf_sz, DMA_FROM_DEVICE);
-		dev_kfree_skb_any(rx_q->rx_skbuff[i]);
-	}
-	rx_q->rx_skbuff[i] = NULL;
+	if (buf->page)
+		page_pool_put_page(rx_q->page_pool, buf->page, false);
+	buf->page = NULL;
 }
 
 /**
@@ -1321,10 +1307,6 @@ static int init_dma_rx_desc_rings(struct net_device *dev, gfp_t flags)
 						     queue);
 			if (ret)
 				goto err_init_rx_buffers;
-
-			netif_dbg(priv, probe, priv->dev, "[%p]\t[%p]\t[%x]\n",
-				  rx_q->rx_skbuff[i], rx_q->rx_skbuff[i]->data,
-				  (unsigned int)rx_q->rx_skbuff_dma[i]);
 		}
 
 		rx_q->cur_rx = 0;
@@ -1498,8 +1480,11 @@ static void free_dma_rx_desc_resources(struct stmmac_priv *priv)
 					  sizeof(struct dma_extended_desc),
 					  rx_q->dma_erx, rx_q->dma_rx_phy);
 
-		kfree(rx_q->rx_skbuff_dma);
-		kfree(rx_q->rx_skbuff);
+		kfree(rx_q->buf_pool);
+		if (rx_q->page_pool) {
+			page_pool_request_shutdown(rx_q->page_pool);
+			page_pool_destroy(rx_q->page_pool);
+		}
 	}
 }
 
@@ -1551,20 +1536,29 @@ static int alloc_dma_rx_desc_resources(struct stmmac_priv *priv)
 	/* RX queues buffers and DMA */
 	for (queue = 0; queue < rx_count; queue++) {
 		struct stmmac_rx_queue *rx_q = &priv->rx_queue[queue];
+		struct page_pool_params pp_params = { 0 };
 
 		rx_q->queue_index = queue;
 		rx_q->priv_data = priv;
 
-		rx_q->rx_skbuff_dma = kmalloc_array(DMA_RX_SIZE,
-						    sizeof(dma_addr_t),
-						    GFP_KERNEL);
-		if (!rx_q->rx_skbuff_dma)
+		pp_params.flags = PP_FLAG_DMA_MAP;
+		pp_params.pool_size = DMA_RX_SIZE;
+		pp_params.order = DIV_ROUND_UP(priv->dma_buf_sz, PAGE_SIZE);
+		pp_params.nid = dev_to_node(priv->device);
+		pp_params.dev = priv->device;
+		pp_params.dma_dir = DMA_FROM_DEVICE;
+
+		rx_q->page_pool = page_pool_create(&pp_params);
+		if (IS_ERR(rx_q->page_pool)) {
+			ret = PTR_ERR(rx_q->page_pool);
+			rx_q->page_pool = NULL;
 			goto err_dma;
+		}
 
-		rx_q->rx_skbuff = kmalloc_array(DMA_RX_SIZE,
-						sizeof(struct sk_buff *),
-						GFP_KERNEL);
-		if (!rx_q->rx_skbuff)
+		rx_q->buf_pool = kmalloc_array(DMA_RX_SIZE,
+					       sizeof(*rx_q->buf_pool),
+					       GFP_KERNEL);
+		if (!rx_q->buf_pool)
 			goto err_dma;
 
 		if (priv->extend_desc) {
@@ -3286,9 +3280,8 @@ static inline void stmmac_rx_refill(struct stmmac_priv *priv, u32 queue)
 	int dirty = stmmac_rx_dirty(priv, queue);
 	unsigned int entry = rx_q->dirty_rx;
 
-	int bfsize = priv->dma_buf_sz;
-
 	while (dirty-- > 0) {
+		struct stmmac_rx_buffer *buf = &rx_q->buf_pool[entry];
 		struct dma_desc *p;
 		bool use_rx_wd;
 
@@ -3297,49 +3290,22 @@ static inline void stmmac_rx_refill(struct stmmac_priv *priv, u32 queue)
 		else
 			p = rx_q->dma_rx + entry;
 
-		if (likely(!rx_q->rx_skbuff[entry])) {
-			struct sk_buff *skb;
-
-			skb = netdev_alloc_skb_ip_align(priv->dev, bfsize);
-			if (unlikely(!skb)) {
-				/* so for a while no zero-copy! */
-				rx_q->rx_zeroc_thresh = STMMAC_RX_THRESH;
-				if (unlikely(net_ratelimit()))
-					dev_err(priv->device,
-						"fail to alloc skb entry %d\n",
-						entry);
-				break;
-			}
-
-			rx_q->rx_skbuff[entry] = skb;
-			rx_q->rx_skbuff_dma[entry] =
-			    dma_map_single(priv->device, skb->data, bfsize,
-					   DMA_FROM_DEVICE);
-			if (dma_mapping_error(priv->device,
-					      rx_q->rx_skbuff_dma[entry])) {
-				netdev_err(priv->dev, "Rx DMA map failed\n");
-				dev_kfree_skb(skb);
+		if (!buf->page) {
+			buf->page = page_pool_dev_alloc_pages(rx_q->page_pool);
+			if (!buf->page)
 				break;
-			}
-
-			stmmac_set_desc_addr(priv, p, rx_q->rx_skbuff_dma[entry]);
-			stmmac_refill_desc3(priv, rx_q, p);
-
-			if (rx_q->rx_zeroc_thresh > 0)
-				rx_q->rx_zeroc_thresh--;
-
-			netif_dbg(priv, rx_status, priv->dev,
-				  "refill entry #%d\n", entry);
 		}
-		dma_wmb();
+
+		buf->addr = page_pool_get_dma_addr(buf->page);
+		stmmac_set_desc_addr(priv, p, buf->addr);
+		stmmac_refill_desc3(priv, rx_q, p);
 
 		rx_q->rx_count_frames++;
 		rx_q->rx_count_frames %= priv->rx_coal_frames;
 		use_rx_wd = priv->use_riwt && rx_q->rx_count_frames;
 
-		stmmac_set_rx_owner(priv, p, use_rx_wd);
-
 		dma_wmb();
+		stmmac_set_rx_owner(priv, p, use_rx_wd);
 
 		entry = STMMAC_GET_ENTRY(entry, DMA_RX_SIZE);
 	}
@@ -3364,9 +3330,6 @@ static int stmmac_rx(struct stmmac_priv *priv, int limit, u32 queue)
 	unsigned int next_entry = rx_q->cur_rx;
 	int coe = priv->hw->rx_csum;
 	unsigned int count = 0;
-	bool xmac;
-
-	xmac = priv->plat->has_gmac4 || priv->plat->has_xgmac;
 
 	if (netif_msg_rx_status(priv)) {
 		void *rx_head;
@@ -3380,11 +3343,12 @@ static int stmmac_rx(struct stmmac_priv *priv, int limit, u32 queue)
 		stmmac_display_ring(priv, rx_head, DMA_RX_SIZE, true);
 	}
 	while (count < limit) {
+		struct stmmac_rx_buffer *buf;
+		struct dma_desc *np, *p;
 		int entry, status;
-		struct dma_desc *p;
-		struct dma_desc *np;
 
 		entry = next_entry;
+		buf = &rx_q->buf_pool[entry];
 
 		if (priv->extend_desc)
 			p = (struct dma_desc *)(rx_q->dma_erx + entry);
@@ -3414,20 +3378,9 @@ static int stmmac_rx(struct stmmac_priv *priv, int limit, u32 queue)
 			stmmac_rx_extended_status(priv, &priv->dev->stats,
 					&priv->xstats, rx_q->dma_erx + entry);
 		if (unlikely(status == discard_frame)) {
+			page_pool_recycle_direct(rx_q->page_pool, buf->page);
 			priv->dev->stats.rx_errors++;
-			if (priv->hwts_rx_en && !priv->extend_desc) {
-				/* DESC2 & DESC3 will be overwritten by device
-				 * with timestamp value, hence reinitialize
-				 * them in stmmac_rx_refill() function so that
-				 * device can reuse it.
-				 */
-				dev_kfree_skb_any(rx_q->rx_skbuff[entry]);
-				rx_q->rx_skbuff[entry] = NULL;
-				dma_unmap_single(priv->device,
-						 rx_q->rx_skbuff_dma[entry],
-						 priv->dma_buf_sz,
-						 DMA_FROM_DEVICE);
-			}
+			buf->page = NULL;
 		} else {
 			struct sk_buff *skb;
 			int frame_len;
@@ -3467,58 +3420,20 @@ static int stmmac_rx(struct stmmac_priv *priv, int limit, u32 queue)
 					   frame_len, status);
 			}
 
-			/* The zero-copy is always used for all the sizes
-			 * in case of GMAC4 because it needs
-			 * to refill the used descriptors, always.
-			 */
-			if (unlikely(!xmac &&
-				     ((frame_len < priv->rx_copybreak) ||
-				     stmmac_rx_threshold_count(rx_q)))) {
-				skb = netdev_alloc_skb_ip_align(priv->dev,
-								frame_len);
-				if (unlikely(!skb)) {
-					if (net_ratelimit())
-						dev_warn(priv->device,
-							 "packet dropped\n");
-					priv->dev->stats.rx_dropped++;
-					continue;
-				}
-
-				dma_sync_single_for_cpu(priv->device,
-							rx_q->rx_skbuff_dma
-							[entry], frame_len,
-							DMA_FROM_DEVICE);
-				skb_copy_to_linear_data(skb,
-							rx_q->
-							rx_skbuff[entry]->data,
-							frame_len);
-
-				skb_put(skb, frame_len);
-				dma_sync_single_for_device(priv->device,
-							   rx_q->rx_skbuff_dma
-							   [entry], frame_len,
-							   DMA_FROM_DEVICE);
-			} else {
-				skb = rx_q->rx_skbuff[entry];
-				if (unlikely(!skb)) {
-					if (net_ratelimit())
-						netdev_err(priv->dev,
-							   "%s: Inconsistent Rx chain\n",
-							   priv->dev->name);
-					priv->dev->stats.rx_dropped++;
-					continue;
-				}
-				prefetch(skb->data - NET_IP_ALIGN);
-				rx_q->rx_skbuff[entry] = NULL;
-				rx_q->rx_zeroc_thresh++;
-
-				skb_put(skb, frame_len);
-				dma_unmap_single(priv->device,
-						 rx_q->rx_skbuff_dma[entry],
-						 priv->dma_buf_sz,
-						 DMA_FROM_DEVICE);
+			skb = netdev_alloc_skb_ip_align(priv->dev, frame_len);
+			if (unlikely(!skb)) {
+				priv->dev->stats.rx_dropped++;
+				continue;
 			}
 
+			dma_sync_single_for_cpu(priv->device, buf->addr,
+						frame_len, DMA_FROM_DEVICE);
+			skb_copy_to_linear_data(skb, page_address(buf->page),
+						frame_len);
+			skb_put(skb, frame_len);
+			dma_sync_single_for_device(priv->device, buf->addr,
+						   frame_len, DMA_FROM_DEVICE);
+
 			if (netif_msg_pktdata(priv)) {
 				netdev_dbg(priv->dev, "frame received (%dbytes)",
 					   frame_len);
@@ -3538,6 +3453,10 @@ static int stmmac_rx(struct stmmac_priv *priv, int limit, u32 queue)
 
 			napi_gro_receive(&ch->rx_napi, skb);
 
+			/* Data payload copied into SKB, page ready for recycle */
+			page_pool_recycle_direct(rx_q->page_pool, buf->page);
+			buf->page = NULL;
+
 			priv->dev->stats.rx_packets++;
 			priv->dev->stats.rx_bytes += frame_len;
 		}
-- 
2.7.4

