Return-Path: <netdev+bounces-5096-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8723F70FA6B
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 17:36:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3D7A7281460
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 15:36:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 642FC19BB3;
	Wed, 24 May 2023 15:34:34 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EC3719E4A
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 15:34:34 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED825E78
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 08:34:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684942426;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=p71nalHI+W3yFqMm+4MkrrRPKSqs6pNOJ/pHSBSTc4w=;
	b=aPpTxmg75JgzmpqghhKOZdv7KS7NHZBdjnV8FeuNzpbr175Ct7O3BjO/jqgw0E22vCh/00
	8Wr06XfQckt7rt1E2Y0vTut82eBcKQk1MvG/VAS/wWFCMOn0BOSPnwXAtQXPLNIDwAejNO
	D5k+Y+EvPDqFMvxfBriDXeduuJW0/xs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-136-3nahLBV-MXSO5tBDJHqSWA-1; Wed, 24 May 2023 11:33:43 -0400
X-MC-Unique: 3nahLBV-MXSO5tBDJHqSWA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 19058800888;
	Wed, 24 May 2023 15:33:41 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.39.192.68])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 217A440C6CCC;
	Wed, 24 May 2023 15:33:37 +0000 (UTC)
From: David Howells <dhowells@redhat.com>
To: netdev@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
	David Ahern <dsahern@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Jens Axboe <axboe@kernel.dk>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Jeroen de Borst <jeroendb@google.com>,
	Catherine Sullivan <csully@google.com>,
	Shailend Chand <shailend@google.com>,
	Felix Fietkau <nbd@nbd.name>,
	John Crispin <john@phrozen.org>,
	Sean Wang <sean.wang@mediatek.com>,
	Mark Lee <Mark-MC.Lee@mediatek.com>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Keith Busch <kbusch@kernel.org>,
	Jens Axboe <axboe@fb.com>,
	Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org,
	linux-nvme@lists.infradead.org
Subject: [PATCH net-next 06/12] mm: Make the page_frag_cache allocator use per-cpu
Date: Wed, 24 May 2023 16:33:05 +0100
Message-Id: <20230524153311.3625329-7-dhowells@redhat.com>
In-Reply-To: <20230524153311.3625329-1-dhowells@redhat.com>
References: <20230524153311.3625329-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Make the page_frag_cache allocator have a separate allocation bucket for
each cpu to avoid racing.  This means that no lock is required, other than
preempt disablement, to allocate from it, though if a softirq wants to
access it, then softirq disablement will need to be added.

Make the NVMe, mediatek and GVE drivers pass in NULL to page_frag_cache()
and use the default allocation buckets rather than defining their own.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: "David S. Miller" <davem@davemloft.net>
cc: Eric Dumazet <edumazet@google.com>
cc: Jakub Kicinski <kuba@kernel.org>
cc: Paolo Abeni <pabeni@redhat.com>
cc: Jens Axboe <axboe@kernel.dk>
cc: Jeroen de Borst <jeroendb@google.com>
cc: Catherine Sullivan <csully@google.com>
cc: Shailend Chand <shailend@google.com>
cc: Felix Fietkau <nbd@nbd.name>
cc: John Crispin <john@phrozen.org>
cc: Sean Wang <sean.wang@mediatek.com>
cc: Mark Lee <Mark-MC.Lee@mediatek.com>
cc: Lorenzo Bianconi <lorenzo@kernel.org>
cc: Matthias Brugger <matthias.bgg@gmail.com>
cc: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
cc: Keith Busch <kbusch@kernel.org>
cc: Jens Axboe <axboe@fb.com>
cc: Christoph Hellwig <hch@lst.de>
cc: Sagi Grimberg <sagi@grimberg.me>
cc: Chaitanya Kulkarni <kch@nvidia.com>
cc: Andrew Morton <akpm@linux-foundation.org>
cc: Matthew Wilcox <willy@infradead.org>
cc: netdev@vger.kernel.org
cc: linux-arm-kernel@lists.infradead.org
cc: linux-mediatek@lists.infradead.org
cc: linux-nvme@lists.infradead.org
cc: linux-mm@kvack.org
---
 drivers/net/ethernet/google/gve/gve.h      |   1 -
 drivers/net/ethernet/google/gve/gve_main.c |   9 -
 drivers/net/ethernet/google/gve/gve_rx.c   |   2 +-
 drivers/net/ethernet/mediatek/mtk_wed_wo.c |   6 +-
 drivers/net/ethernet/mediatek/mtk_wed_wo.h |   2 -
 drivers/nvme/host/tcp.c                    |  13 +-
 drivers/nvme/target/tcp.c                  |  19 +-
 include/linux/gfp.h                        |  19 +-
 mm/page_frag_alloc.c                       | 202 +++++++++++++--------
 net/core/skbuff.c                          |  32 ++--
 10 files changed, 163 insertions(+), 142 deletions(-)

diff --git a/drivers/net/ethernet/google/gve/gve.h b/drivers/net/ethernet/google/gve/gve.h
index 98eb78d98e9f..87244ab911bd 100644
--- a/drivers/net/ethernet/google/gve/gve.h
+++ b/drivers/net/ethernet/google/gve/gve.h
@@ -250,7 +250,6 @@ struct gve_rx_ring {
 	struct xdp_rxq_info xdp_rxq;
 	struct xdp_rxq_info xsk_rxq;
 	struct xsk_buff_pool *xsk_pool;
-	struct page_frag_cache page_cache; /* Page cache to allocate XDP frames */
 };
 
 /* A TX desc ring entry */
diff --git a/drivers/net/ethernet/google/gve/gve_main.c b/drivers/net/ethernet/google/gve/gve_main.c
index 55feab29bed9..9f0fb986d61e 100644
--- a/drivers/net/ethernet/google/gve/gve_main.c
+++ b/drivers/net/ethernet/google/gve/gve_main.c
@@ -1249,14 +1249,6 @@ static void gve_unreg_xdp_info(struct gve_priv *priv)
 	}
 }
 
-static void gve_drain_page_cache(struct gve_priv *priv)
-{
-	int i;
-
-	for (i = 0; i < priv->rx_cfg.num_queues; i++)
-		page_frag_cache_clear(&priv->rx[i].page_cache);
-}
-
 static int gve_open(struct net_device *dev)
 {
 	struct gve_priv *priv = netdev_priv(dev);
@@ -1340,7 +1332,6 @@ static int gve_close(struct net_device *dev)
 	netif_carrier_off(dev);
 	if (gve_get_device_rings_ok(priv)) {
 		gve_turndown(priv);
-		gve_drain_page_cache(priv);
 		err = gve_destroy_rings(priv);
 		if (err)
 			goto err;
diff --git a/drivers/net/ethernet/google/gve/gve_rx.c b/drivers/net/ethernet/google/gve/gve_rx.c
index d1da7413dc4d..7ae8377c394f 100644
--- a/drivers/net/ethernet/google/gve/gve_rx.c
+++ b/drivers/net/ethernet/google/gve/gve_rx.c
@@ -634,7 +634,7 @@ static int gve_xdp_redirect(struct net_device *dev, struct gve_rx_ring *rx,
 
 	total_len = headroom + SKB_DATA_ALIGN(len) +
 		SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
-	frame = page_frag_alloc(&rx->page_cache, total_len, GFP_ATOMIC);
+	frame = page_frag_alloc(NULL, total_len, GFP_ATOMIC);
 	if (!frame) {
 		u64_stats_update_begin(&rx->statss);
 		rx->xdp_alloc_fails++;
diff --git a/drivers/net/ethernet/mediatek/mtk_wed_wo.c b/drivers/net/ethernet/mediatek/mtk_wed_wo.c
index d90fea2c7d04..859f34447f2f 100644
--- a/drivers/net/ethernet/mediatek/mtk_wed_wo.c
+++ b/drivers/net/ethernet/mediatek/mtk_wed_wo.c
@@ -143,7 +143,7 @@ mtk_wed_wo_queue_refill(struct mtk_wed_wo *wo, struct mtk_wed_wo_queue *q,
 		dma_addr_t addr;
 		void *buf;
 
-		buf = page_frag_alloc(&q->cache, q->buf_size, GFP_ATOMIC);
+		buf = page_frag_alloc(NULL, q->buf_size, GFP_ATOMIC);
 		if (!buf)
 			break;
 
@@ -296,8 +296,6 @@ mtk_wed_wo_queue_tx_clean(struct mtk_wed_wo *wo, struct mtk_wed_wo_queue *q)
 		skb_free_frag(entry->buf);
 		entry->buf = NULL;
 	}
-
-	page_frag_cache_clear(&q->cache);
 }
 
 static void
@@ -311,8 +309,6 @@ mtk_wed_wo_queue_rx_clean(struct mtk_wed_wo *wo, struct mtk_wed_wo_queue *q)
 
 		skb_free_frag(buf);
 	}
-
-	page_frag_cache_clear(&q->cache);
 }
 
 static void
diff --git a/drivers/net/ethernet/mediatek/mtk_wed_wo.h b/drivers/net/ethernet/mediatek/mtk_wed_wo.h
index 7a1a2a28f1ac..f69bd83dc486 100644
--- a/drivers/net/ethernet/mediatek/mtk_wed_wo.h
+++ b/drivers/net/ethernet/mediatek/mtk_wed_wo.h
@@ -211,8 +211,6 @@ struct mtk_wed_wo_queue_entry {
 struct mtk_wed_wo_queue {
 	struct mtk_wed_wo_queue_regs regs;
 
-	struct page_frag_cache cache;
-
 	struct mtk_wed_wo_queue_desc *desc;
 	dma_addr_t desc_dma;
 
diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
index dcc35f6bff8c..145cf6186509 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -147,8 +147,6 @@ struct nvme_tcp_queue {
 	__le32			exp_ddgst;
 	__le32			recv_ddgst;
 
-	struct page_frag_cache	pf_cache;
-
 	void (*state_change)(struct sock *);
 	void (*data_ready)(struct sock *);
 	void (*write_space)(struct sock *);
@@ -482,9 +480,8 @@ static int nvme_tcp_init_request(struct blk_mq_tag_set *set,
 	struct nvme_tcp_queue *queue = &ctrl->queues[queue_idx];
 	u8 hdgst = nvme_tcp_hdgst_len(queue);
 
-	req->pdu = page_frag_alloc(&queue->pf_cache,
-		sizeof(struct nvme_tcp_cmd_pdu) + hdgst,
-		GFP_KERNEL | __GFP_ZERO);
+	req->pdu = page_frag_alloc(NULL, sizeof(struct nvme_tcp_cmd_pdu) + hdgst,
+				   GFP_KERNEL | __GFP_ZERO);
 	if (!req->pdu)
 		return -ENOMEM;
 
@@ -1303,9 +1300,8 @@ static int nvme_tcp_alloc_async_req(struct nvme_tcp_ctrl *ctrl)
 	struct nvme_tcp_request *async = &ctrl->async_req;
 	u8 hdgst = nvme_tcp_hdgst_len(queue);
 
-	async->pdu = page_frag_alloc(&queue->pf_cache,
-		sizeof(struct nvme_tcp_cmd_pdu) + hdgst,
-		GFP_KERNEL | __GFP_ZERO);
+	async->pdu = page_frag_alloc(NULL, sizeof(struct nvme_tcp_cmd_pdu) + hdgst,
+				     GFP_KERNEL | __GFP_ZERO);
 	if (!async->pdu)
 		return -ENOMEM;
 
@@ -1325,7 +1321,6 @@ static void nvme_tcp_free_queue(struct nvme_ctrl *nctrl, int qid)
 	if (queue->hdr_digest || queue->data_digest)
 		nvme_tcp_free_crypto(queue);
 
-	page_frag_cache_clear(&queue->pf_cache);
 	noreclaim_flag = memalloc_noreclaim_save();
 	sock_release(queue->sock);
 	memalloc_noreclaim_restore(noreclaim_flag);
diff --git a/drivers/nvme/target/tcp.c b/drivers/nvme/target/tcp.c
index 984e6ce85dcd..cb352f5d2bbf 100644
--- a/drivers/nvme/target/tcp.c
+++ b/drivers/nvme/target/tcp.c
@@ -169,8 +169,6 @@ struct nvmet_tcp_queue {
 
 	struct nvmet_tcp_cmd	connect;
 
-	struct page_frag_cache	pf_cache;
-
 	void (*data_ready)(struct sock *);
 	void (*state_change)(struct sock *);
 	void (*write_space)(struct sock *);
@@ -1338,25 +1336,25 @@ static int nvmet_tcp_alloc_cmd(struct nvmet_tcp_queue *queue,
 	c->queue = queue;
 	c->req.port = queue->port->nport;
 
-	c->cmd_pdu = page_frag_alloc(&queue->pf_cache,
-			sizeof(*c->cmd_pdu) + hdgst, GFP_KERNEL | __GFP_ZERO);
+	c->cmd_pdu = page_frag_alloc(NULL, sizeof(*c->cmd_pdu) + hdgst,
+				     GFP_KERNEL | __GFP_ZERO);
 	if (!c->cmd_pdu)
 		return -ENOMEM;
 	c->req.cmd = &c->cmd_pdu->cmd;
 
-	c->rsp_pdu = page_frag_alloc(&queue->pf_cache,
-			sizeof(*c->rsp_pdu) + hdgst, GFP_KERNEL | __GFP_ZERO);
+	c->rsp_pdu = page_frag_alloc(NULL, sizeof(*c->rsp_pdu) + hdgst,
+				     GFP_KERNEL | __GFP_ZERO);
 	if (!c->rsp_pdu)
 		goto out_free_cmd;
 	c->req.cqe = &c->rsp_pdu->cqe;
 
-	c->data_pdu = page_frag_alloc(&queue->pf_cache,
-			sizeof(*c->data_pdu) + hdgst, GFP_KERNEL | __GFP_ZERO);
+	c->data_pdu = page_frag_alloc(NULL, sizeof(*c->data_pdu) + hdgst,
+				      GFP_KERNEL | __GFP_ZERO);
 	if (!c->data_pdu)
 		goto out_free_rsp;
 
-	c->r2t_pdu = page_frag_alloc(&queue->pf_cache,
-			sizeof(*c->r2t_pdu) + hdgst, GFP_KERNEL | __GFP_ZERO);
+	c->r2t_pdu = page_frag_alloc(NULL, sizeof(*c->r2t_pdu) + hdgst,
+				     GFP_KERNEL | __GFP_ZERO);
 	if (!c->r2t_pdu)
 		goto out_free_data;
 
@@ -1485,7 +1483,6 @@ static void nvmet_tcp_release_queue_work(struct work_struct *w)
 	if (queue->hdr_digest || queue->data_digest)
 		nvmet_tcp_free_crypto(queue);
 	ida_free(&nvmet_tcp_queue_ida, queue->idx);
-	page_frag_cache_clear(&queue->pf_cache);
 	kfree(queue);
 }
 
diff --git a/include/linux/gfp.h b/include/linux/gfp.h
index fa30100f46ad..baa25a00d9e3 100644
--- a/include/linux/gfp.h
+++ b/include/linux/gfp.h
@@ -304,18 +304,19 @@ extern void free_pages(unsigned long addr, unsigned int order);
 
 struct page_frag_cache;
 extern void __page_frag_cache_drain(struct page *page, unsigned int count);
-extern void *page_frag_alloc_align(struct page_frag_cache *nc,
-				   unsigned int fragsz, gfp_t gfp_mask,
-				   unsigned int align);
-
-static inline void *page_frag_alloc(struct page_frag_cache *nc,
-			     unsigned int fragsz, gfp_t gfp_mask)
+extern void *page_frag_alloc_align(struct page_frag_cache __percpu *frag_cache,
+				   size_t fragsz, gfp_t gfp,
+				   unsigned long align);
+extern void *page_frag_memdup(struct page_frag_cache __percpu *frag_cache,
+			      const void *p, size_t fragsz, gfp_t gfp,
+			      unsigned long align);
+
+static inline void *page_frag_alloc(struct page_frag_cache __percpu *frag_cache,
+				    size_t fragsz, gfp_t gfp)
 {
-	return page_frag_alloc_align(nc, fragsz, gfp_mask, 1);
+	return page_frag_alloc_align(frag_cache, fragsz, gfp, 1);
 }
 
-void page_frag_cache_clear(struct page_frag_cache *nc);
-
 extern void page_frag_free(void *addr);
 
 #define __free_page(page) __free_pages((page), 0)
diff --git a/mm/page_frag_alloc.c b/mm/page_frag_alloc.c
index 2b73c7f5d9a9..b035bbb34fac 100644
--- a/mm/page_frag_alloc.c
+++ b/mm/page_frag_alloc.c
@@ -16,28 +16,25 @@
 #include <linux/init.h>
 #include <linux/mm.h>
 
+static DEFINE_PER_CPU(struct page_frag_cache, page_frag_default_allocator);
+
 /*
  * Allocate a new folio for the frag cache.
  */
-static struct folio *page_frag_cache_refill(struct page_frag_cache *nc,
-					    gfp_t gfp_mask)
+static struct folio *page_frag_cache_refill(gfp_t gfp)
 {
-	struct folio *folio = NULL;
-	gfp_t gfp;
+	struct folio *folio;
 
-	gfp_mask &= ~__GFP_ZERO;
-	gfp = gfp_mask;
+	gfp &= ~__GFP_ZERO;
 
 #if (PAGE_SIZE < PAGE_FRAG_CACHE_MAX_SIZE)
-	gfp_mask |= __GFP_NOWARN | __GFP_NORETRY | __GFP_NOMEMALLOC;
-	folio = folio_alloc(gfp_mask, PAGE_FRAG_CACHE_MAX_ORDER);
+	folio = folio_alloc(gfp | __GFP_NOWARN | __GFP_NORETRY | __GFP_NOMEMALLOC,
+			    PAGE_FRAG_CACHE_MAX_ORDER);
+	if (folio)
+		return folio;
 #endif
-	if (unlikely(!folio))
-		folio = folio_alloc(gfp, 0);
 
-	if (folio)
-		nc->folio = folio;
-	return folio;
+	return folio_alloc(gfp, 0);
 }
 
 void __page_frag_cache_drain(struct page *page, unsigned int count)
@@ -51,63 +48,70 @@ void __page_frag_cache_drain(struct page *page, unsigned int count)
 EXPORT_SYMBOL(__page_frag_cache_drain);
 
 /**
- * page_frag_cache_clear - Clear out a page fragment cache
- * @nc: The cache to clear
+ * page_frag_alloc_align - Allocate some memory for use in zerocopy
+ * @frag_cache: The frag cache to use (or NULL for the default)
+ * @fragsz: The size of the fragment desired
+ * @gfp: Allocation flags under which to make an allocation
+ * @align: The required alignment
+ *
+ * Allocate some memory for use with zerocopy where protocol bits have to be
+ * mixed in with spliced/zerocopied data.  Unlike memory allocated from the
+ * slab, this memory's lifetime is purely dependent on the folio's refcount.
+ *
+ * The way it works is that a folio is allocated and fragments are broken off
+ * sequentially and returned to the caller with a ref until the folio no longer
+ * has enough spare space - at which point the allocator's ref is dropped and a
+ * new folio is allocated.  The folio remains in existence until the last ref
+ * held by, say, an sk_buff is discarded and then the page is returned to the
+ * page allocator.
  *
- * Discard any pages still cached in a page fragment cache.
+ * Returns a pointer to the memory on success and -ENOMEM on allocation
+ * failure.
+ *
+ * The allocated memory should be disposed of with folio_put().
  */
-void page_frag_cache_clear(struct page_frag_cache *nc)
-{
-	struct folio *folio = nc->folio;
-
-	if (folio) {
-		VM_BUG_ON_FOLIO(folio_ref_count(folio) == 0, folio);
-		folio_put_refs(folio, nc->pagecnt_bias);
-		nc->folio = NULL;
-	}
-}
-EXPORT_SYMBOL(page_frag_cache_clear);
-
-void *page_frag_alloc_align(struct page_frag_cache *nc,
-			    unsigned int fragsz, gfp_t gfp_mask,
-			    unsigned int align)
+void *page_frag_alloc_align(struct page_frag_cache __percpu *frag_cache,
+			    size_t fragsz, gfp_t gfp, unsigned long align)
 {
-	struct folio *folio = nc->folio;
+	struct page_frag_cache *nc;
+	struct folio *folio, *spare = NULL;
 	size_t offset;
 	void *p;
 
 	WARN_ON_ONCE(!is_power_of_2(align));
 
-	if (unlikely(!folio)) {
-refill:
-		folio = page_frag_cache_refill(nc, gfp_mask);
-		if (!folio)
-			return NULL;
-
-		/* Even if we own the page, we do not use atomic_set().
-		 * This would break get_page_unless_zero() users.
-		 */
-		folio_ref_add(folio, PAGE_FRAG_CACHE_MAX_SIZE);
+	if (!frag_cache)
+		frag_cache = &page_frag_default_allocator;
+	if (WARN_ON_ONCE(fragsz == 0))
+		fragsz = 1;
 
-		/* reset page count bias and offset to start of new frag */
-		nc->pfmemalloc = folio_is_pfmemalloc(folio);
-		nc->pagecnt_bias = PAGE_FRAG_CACHE_MAX_SIZE + 1;
-		nc->offset = folio_size(folio);
+	nc = get_cpu_ptr(frag_cache);
+reload:
+	folio = nc->folio;
+	offset = nc->offset;
+try_again:
+
+	/* Make the allocation if there's sufficient space. */
+	if (fragsz <= offset) {
+		nc->pagecnt_bias--;
+		offset = (offset - fragsz) & ~(align - 1);
+		nc->offset = offset;
+		p = folio_address(folio) + offset;
+		put_cpu_ptr(frag_cache);
+		if (spare)
+			folio_put(spare);
+		if (gfp & __GFP_ZERO)
+			return memset(p, 0, fragsz);
+		return p;
 	}
 
-	offset = nc->offset;
-	if (unlikely(fragsz > offset)) {
-		/* Reuse the folio if everyone we gave it to has finished with
-		 * it.
-		 */
-		if (!folio_ref_sub_and_test(folio, nc->pagecnt_bias)) {
-			nc->folio = NULL;
+	/* Insufficient space - see if we can refurbish the current folio. */
+	if (folio) {
+		if (!folio_ref_sub_and_test(folio, nc->pagecnt_bias))
 			goto refill;
-		}
 
 		if (unlikely(nc->pfmemalloc)) {
 			__folio_put(folio);
-			nc->folio = NULL;
 			goto refill;
 		}
 
@@ -117,30 +121,56 @@ void *page_frag_alloc_align(struct page_frag_cache *nc,
 		/* reset page count bias and offset to start of new frag */
 		nc->pagecnt_bias = PAGE_FRAG_CACHE_MAX_SIZE + 1;
 		offset = folio_size(folio);
-		if (unlikely(fragsz > offset)) {
-			/*
-			 * The caller is trying to allocate a fragment
-			 * with fragsz > PAGE_SIZE but the cache isn't big
-			 * enough to satisfy the request, this may
-			 * happen in low memory conditions.
-			 * We don't release the cache page because
-			 * it could make memory pressure worse
-			 * so we simply return NULL here.
-			 */
-			nc->offset = offset;
+		if (unlikely(fragsz > offset))
+			goto frag_too_big;
+		goto try_again;
+	}
+
+refill:
+	if (!spare) {
+		nc->folio = NULL;
+		put_cpu_ptr(frag_cache);
+
+		spare = page_frag_cache_refill(gfp);
+		if (!spare)
 			return NULL;
-		}
+
+		nc = get_cpu_ptr(frag_cache);
+		/* We may now be on a different cpu and/or someone else may
+		 * have refilled it
+		 */
+		nc->pfmemalloc = folio_is_pfmemalloc(spare);
+		if (nc->folio)
+			goto reload;
 	}
 
-	nc->pagecnt_bias--;
-	offset -= fragsz;
-	offset &= ~(align - 1);
+	nc->folio = spare;
+	folio = spare;
+	spare = NULL;
+
+	/* Even if we own the page, we do not use atomic_set().  This would
+	 * break get_page_unless_zero() users.
+	 */
+	folio_ref_add(folio, PAGE_FRAG_CACHE_MAX_SIZE);
+
+	/* Reset page count bias and offset to start of new frag */
+	nc->pagecnt_bias = PAGE_FRAG_CACHE_MAX_SIZE + 1;
+	offset = folio_size(folio);
+	goto try_again;
+
+frag_too_big:
+	/*
+	 * The caller is trying to allocate a fragment with fragsz > PAGE_SIZE
+	 * but the cache isn't big enough to satisfy the request, this may
+	 * happen in low memory conditions.  We don't release the cache page
+	 * because it could make memory pressure worse so we simply return NULL
+	 * here.
+	 */
 	nc->offset = offset;
-
-	p = folio_address(folio) + offset;
-	if (gfp_mask & __GFP_ZERO)
-		return memset(p, 0, fragsz);
-	return p;
+	put_cpu_ptr(frag_cache);
+	if (spare)
+		folio_put(spare);
+	return NULL;
 }
 EXPORT_SYMBOL(page_frag_alloc_align);
 
@@ -152,3 +182,25 @@ void page_frag_free(void *addr)
 	folio_put(virt_to_folio(addr));
 }
 EXPORT_SYMBOL(page_frag_free);
+
+/**
+ * page_frag_memdup - Allocate a page fragment and duplicate some data into it
+ * @frag_cache: The frag cache to use (or NULL for the default)
+ * @fragsz: The amount of memory to copy (maximum 1/2 page).
+ * @p: The source data to copy
+ * @gfp: Allocation flags under which to make an allocation
+ * @align_mask: The required alignment
+ */
+void *page_frag_memdup(struct page_frag_cache __percpu *frag_cache,
+		       const void *p, size_t fragsz, gfp_t gfp,
+		       unsigned long align_mask)
+{
+	void *q;
+
+	q = page_frag_alloc_align(frag_cache, fragsz, gfp, align_mask);
+	if (!q)
+		return q;
+
+	return memcpy(q, p, fragsz);
+}
+EXPORT_SYMBOL(page_frag_memdup);
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index cc507433b357..225a16f3713f 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -263,13 +263,13 @@ static void *page_frag_alloc_1k(struct page_frag_1k *nc, gfp_t gfp_mask)
 #endif
 
 struct napi_alloc_cache {
-	struct page_frag_cache page;
 	struct page_frag_1k page_small;
 	unsigned int skb_count;
 	void *skb_cache[NAPI_SKB_CACHE_SIZE];
 };
 
 static DEFINE_PER_CPU(struct page_frag_cache, netdev_alloc_cache);
+static DEFINE_PER_CPU(struct page_frag_cache, napi_frag_cache);
 static DEFINE_PER_CPU(struct napi_alloc_cache, napi_alloc_cache);
 
 /* Double check that napi_get_frags() allocates skbs with
@@ -291,11 +291,9 @@ void napi_get_frags_check(struct napi_struct *napi)
 
 void *napi_alloc_frag_align(unsigned int fragsz, unsigned int align)
 {
-	struct napi_alloc_cache *nc = this_cpu_ptr(&napi_alloc_cache);
-
 	fragsz = SKB_DATA_ALIGN(fragsz);
 
-	return page_frag_alloc_align(&nc->page, fragsz, GFP_ATOMIC, align);
+	return page_frag_alloc_align(&napi_frag_cache, fragsz, GFP_ATOMIC, align);
 }
 EXPORT_SYMBOL(napi_alloc_frag_align);
 
@@ -305,15 +303,12 @@ void *netdev_alloc_frag_align(unsigned int fragsz, unsigned int align)
 
 	fragsz = SKB_DATA_ALIGN(fragsz);
 	if (in_hardirq() || irqs_disabled()) {
-		struct page_frag_cache *nc = this_cpu_ptr(&netdev_alloc_cache);
-
-		data = page_frag_alloc_align(nc, fragsz, GFP_ATOMIC, align);
+		data = page_frag_alloc_align(&netdev_alloc_cache,
+					     fragsz, GFP_ATOMIC, align);
 	} else {
-		struct napi_alloc_cache *nc;
-
 		local_bh_disable();
-		nc = this_cpu_ptr(&napi_alloc_cache);
-		data = page_frag_alloc_align(&nc->page, fragsz, GFP_ATOMIC, align);
+		data = page_frag_alloc_align(&napi_frag_cache,
+					     fragsz, GFP_ATOMIC, align);
 		local_bh_enable();
 	}
 	return data;
@@ -691,7 +686,6 @@ EXPORT_SYMBOL(__alloc_skb);
 struct sk_buff *__netdev_alloc_skb(struct net_device *dev, unsigned int len,
 				   gfp_t gfp_mask)
 {
-	struct page_frag_cache *nc;
 	struct sk_buff *skb;
 	bool pfmemalloc;
 	void *data;
@@ -716,14 +710,12 @@ struct sk_buff *__netdev_alloc_skb(struct net_device *dev, unsigned int len,
 		gfp_mask |= __GFP_MEMALLOC;
 
 	if (in_hardirq() || irqs_disabled()) {
-		nc = this_cpu_ptr(&netdev_alloc_cache);
-		data = page_frag_alloc(nc, len, gfp_mask);
-		pfmemalloc = nc->pfmemalloc;
+		data = page_frag_alloc(&netdev_alloc_cache, len, gfp_mask);
+		pfmemalloc = folio_is_pfmemalloc(virt_to_folio(data));
 	} else {
 		local_bh_disable();
-		nc = this_cpu_ptr(&napi_alloc_cache.page);
-		data = page_frag_alloc(nc, len, gfp_mask);
-		pfmemalloc = nc->pfmemalloc;
+		data = page_frag_alloc(&napi_frag_cache, len, gfp_mask);
+		pfmemalloc = folio_is_pfmemalloc(virt_to_folio(data));
 		local_bh_enable();
 	}
 
@@ -811,8 +803,8 @@ struct sk_buff *__napi_alloc_skb(struct napi_struct *napi, unsigned int len,
 	} else {
 		len = SKB_HEAD_ALIGN(len);
 
-		data = page_frag_alloc(&nc->page, len, gfp_mask);
-		pfmemalloc = nc->page.pfmemalloc;
+		data = page_frag_alloc(&napi_frag_cache, len, gfp_mask);
+		pfmemalloc = folio_is_pfmemalloc(virt_to_folio(data));
 	}
 
 	if (unlikely(!data))


