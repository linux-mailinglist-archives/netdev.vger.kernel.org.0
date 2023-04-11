Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CDF86DE089
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 18:10:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229809AbjDKQKX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 12:10:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229709AbjDKQKQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 12:10:16 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21CAE30C0
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 09:09:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681229364;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ivyfYwnUZR0ptY6OLV+4rOfP5TDkuV50aqZyhshAVbQ=;
        b=cagfA6i8tbLCDF84BwooxxX4L5hAgjKtBc6IQEmlAtzKAQgjLOn65uJAuEWc2mE+4YT2oW
        TCOJk/0wTViNmySDv9xfhx3ej5UUlkYKkuRR4lwOTjg7U/b/vZY+JGkCZgrVGWZ1ng+so1
        MpfBQyhx9H0KltTQh5KpmaMdxesClCs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-180-vRsXjnCWNMOIS6VRPgPWxQ-1; Tue, 11 Apr 2023 12:09:20 -0400
X-MC-Unique: vRsXjnCWNMOIS6VRPgPWxQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A59BA85A588;
        Tue, 11 Apr 2023 16:09:18 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0CE7714171D5;
        Tue, 11 Apr 2023 16:09:13 +0000 (UTC)
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     David Howells <dhowells@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>,
        Jens Axboe <axboe@kernel.dk>, Jeff Layton <jlayton@kernel.org>,
        Christian Brauner <brauner@kernel.org>,
        Chuck Lever III <chuck.lever@oracle.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Jeroen de Borst <jeroendb@google.com>,
        Catherine Sullivan <csully@google.com>,
        Shailend Chand <shailend@google.com>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Keith Busch <kbusch@kernel.org>, Jens Axboe <axboe@fb.com>,
        Christoph Hellwig <hch@lst.de>,
        Sagi Grimberg <sagi@grimberg.me>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-nvme@lists.infradead.org
Subject: [PATCH net-next v6 03/18] mm: Make the page_frag_cache allocator use multipage folios
Date:   Tue, 11 Apr 2023 17:08:47 +0100
Message-Id: <20230411160902.4134381-4-dhowells@redhat.com>
In-Reply-To: <20230411160902.4134381-1-dhowells@redhat.com>
References: <20230411160902.4134381-1-dhowells@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Change the page_frag_cache allocator to use multipage folios rather than
groups of pages.  This reduces page_frag_free to just a folio_put() or
put_page().

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

Notes:
    ver #6)
     - Removed a couple of leftover page pointer declarations.

 drivers/net/ethernet/google/gve/gve_main.c |  11 +--
 drivers/net/ethernet/mediatek/mtk_wed_wo.c |  17 +---
 drivers/nvme/host/tcp.c                    |   8 +-
 drivers/nvme/target/tcp.c                  |   5 +-
 include/linux/gfp.h                        |   2 +
 include/linux/mm_types.h                   |  13 +--
 mm/page_frag_alloc.c                       | 102 +++++++++++----------
 7 files changed, 67 insertions(+), 91 deletions(-)

diff --git a/drivers/net/ethernet/google/gve/gve_main.c b/drivers/net/ethernet/google/gve/gve_main.c
index 57ce74315eba..b2fc1a3e6340 100644
--- a/drivers/net/ethernet/google/gve/gve_main.c
+++ b/drivers/net/ethernet/google/gve/gve_main.c
@@ -1263,17 +1263,10 @@ static void gve_unreg_xdp_info(struct gve_priv *priv)
 
 static void gve_drain_page_cache(struct gve_priv *priv)
 {
-	struct page_frag_cache *nc;
 	int i;
 
-	for (i = 0; i < priv->rx_cfg.num_queues; i++) {
-		nc = &priv->rx[i].page_cache;
-		if (nc->va) {
-			__page_frag_cache_drain(virt_to_page(nc->va),
-						nc->pagecnt_bias);
-			nc->va = NULL;
-		}
-	}
+	for (i = 0; i < priv->rx_cfg.num_queues; i++)
+		page_frag_cache_clear(&priv->rx[i].page_cache);
 }
 
 static int gve_open(struct net_device *dev)
diff --git a/drivers/net/ethernet/mediatek/mtk_wed_wo.c b/drivers/net/ethernet/mediatek/mtk_wed_wo.c
index 69fba29055e9..d90fea2c7d04 100644
--- a/drivers/net/ethernet/mediatek/mtk_wed_wo.c
+++ b/drivers/net/ethernet/mediatek/mtk_wed_wo.c
@@ -286,7 +286,6 @@ mtk_wed_wo_queue_free(struct mtk_wed_wo *wo, struct mtk_wed_wo_queue *q)
 static void
 mtk_wed_wo_queue_tx_clean(struct mtk_wed_wo *wo, struct mtk_wed_wo_queue *q)
 {
-	struct page *page;
 	int i;
 
 	for (i = 0; i < q->n_desc; i++) {
@@ -298,19 +297,12 @@ mtk_wed_wo_queue_tx_clean(struct mtk_wed_wo *wo, struct mtk_wed_wo_queue *q)
 		entry->buf = NULL;
 	}
 
-	if (!q->cache.va)
-		return;
-
-	page = virt_to_page(q->cache.va);
-	__page_frag_cache_drain(page, q->cache.pagecnt_bias);
-	memset(&q->cache, 0, sizeof(q->cache));
+	page_frag_cache_clear(&q->cache);
 }
 
 static void
 mtk_wed_wo_queue_rx_clean(struct mtk_wed_wo *wo, struct mtk_wed_wo_queue *q)
 {
-	struct page *page;
-
 	for (;;) {
 		void *buf = mtk_wed_wo_dequeue(wo, q, NULL, true);
 
@@ -320,12 +312,7 @@ mtk_wed_wo_queue_rx_clean(struct mtk_wed_wo *wo, struct mtk_wed_wo_queue *q)
 		skb_free_frag(buf);
 	}
 
-	if (!q->cache.va)
-		return;
-
-	page = virt_to_page(q->cache.va);
-	__page_frag_cache_drain(page, q->cache.pagecnt_bias);
-	memset(&q->cache, 0, sizeof(q->cache));
+	page_frag_cache_clear(&q->cache);
 }
 
 static void
diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
index 42c0598c31f2..05629e83b41d 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -1312,7 +1312,6 @@ static int nvme_tcp_alloc_async_req(struct nvme_tcp_ctrl *ctrl)
 
 static void nvme_tcp_free_queue(struct nvme_ctrl *nctrl, int qid)
 {
-	struct page *page;
 	struct nvme_tcp_ctrl *ctrl = to_tcp_ctrl(nctrl);
 	struct nvme_tcp_queue *queue = &ctrl->queues[qid];
 	unsigned int noreclaim_flag;
@@ -1323,12 +1322,7 @@ static void nvme_tcp_free_queue(struct nvme_ctrl *nctrl, int qid)
 	if (queue->hdr_digest || queue->data_digest)
 		nvme_tcp_free_crypto(queue);
 
-	if (queue->pf_cache.va) {
-		page = virt_to_head_page(queue->pf_cache.va);
-		__page_frag_cache_drain(page, queue->pf_cache.pagecnt_bias);
-		queue->pf_cache.va = NULL;
-	}
-
+	page_frag_cache_clear(&queue->pf_cache);
 	noreclaim_flag = memalloc_noreclaim_save();
 	sock_release(queue->sock);
 	memalloc_noreclaim_restore(noreclaim_flag);
diff --git a/drivers/nvme/target/tcp.c b/drivers/nvme/target/tcp.c
index 66e8f9fd0ca7..ae871c31cf00 100644
--- a/drivers/nvme/target/tcp.c
+++ b/drivers/nvme/target/tcp.c
@@ -1438,7 +1438,6 @@ static void nvmet_tcp_free_cmd_data_in_buffers(struct nvmet_tcp_queue *queue)
 
 static void nvmet_tcp_release_queue_work(struct work_struct *w)
 {
-	struct page *page;
 	struct nvmet_tcp_queue *queue =
 		container_of(w, struct nvmet_tcp_queue, release_work);
 
@@ -1460,9 +1459,7 @@ static void nvmet_tcp_release_queue_work(struct work_struct *w)
 	if (queue->hdr_digest || queue->data_digest)
 		nvmet_tcp_free_crypto(queue);
 	ida_free(&nvmet_tcp_queue_ida, queue->idx);
-
-	page = virt_to_head_page(queue->pf_cache.va);
-	__page_frag_cache_drain(page, queue->pf_cache.pagecnt_bias);
+	page_frag_cache_clear(&queue->pf_cache);
 	kfree(queue);
 }
 
diff --git a/include/linux/gfp.h b/include/linux/gfp.h
index 65a78773dcca..9f77ba6af361 100644
--- a/include/linux/gfp.h
+++ b/include/linux/gfp.h
@@ -314,6 +314,8 @@ static inline void *page_frag_alloc(struct page_frag_cache *nc,
 	return page_frag_alloc_align(nc, fragsz, gfp_mask, ~0u);
 }
 
+void page_frag_cache_clear(struct page_frag_cache *nc);
+
 extern void page_frag_free(void *addr);
 
 #define __free_page(page) __free_pages((page), 0)
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 0722859c3647..49a70b3f44a9 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -420,18 +420,13 @@ static inline void *folio_get_private(struct folio *folio)
 }
 
 struct page_frag_cache {
-	void * va;
-#if (PAGE_SIZE < PAGE_FRAG_CACHE_MAX_SIZE)
-	__u16 offset;
-	__u16 size;
-#else
-	__u32 offset;
-#endif
+	struct folio	*folio;
+	unsigned int	offset;
 	/* we maintain a pagecount bias, so that we dont dirty cache line
 	 * containing page->_refcount every time we allocate a fragment.
 	 */
-	unsigned int		pagecnt_bias;
-	bool pfmemalloc;
+	unsigned int	pagecnt_bias;
+	bool		pfmemalloc;
 };
 
 typedef unsigned long vm_flags_t;
diff --git a/mm/page_frag_alloc.c b/mm/page_frag_alloc.c
index bee95824ef8f..ac4cf1eac8ea 100644
--- a/mm/page_frag_alloc.c
+++ b/mm/page_frag_alloc.c
@@ -16,88 +16,96 @@
 #include <linux/init.h>
 #include <linux/mm.h>
 
-static struct page *__page_frag_cache_refill(struct page_frag_cache *nc,
-					     gfp_t gfp_mask)
+/*
+ * Allocate a new folio for the frag cache.
+ */
+static struct folio *page_frag_cache_refill(struct page_frag_cache *nc,
+					    gfp_t gfp_mask)
 {
-	struct page *page = NULL;
+	struct folio *folio = NULL;
 	gfp_t gfp = gfp_mask;
 
 #if (PAGE_SIZE < PAGE_FRAG_CACHE_MAX_SIZE)
-	gfp_mask |= __GFP_COMP | __GFP_NOWARN | __GFP_NORETRY |
-		    __GFP_NOMEMALLOC;
-	page = alloc_pages_node(NUMA_NO_NODE, gfp_mask,
-				PAGE_FRAG_CACHE_MAX_ORDER);
-	nc->size = page ? PAGE_FRAG_CACHE_MAX_SIZE : PAGE_SIZE;
+	gfp_mask |= __GFP_NOWARN | __GFP_NORETRY | __GFP_NOMEMALLOC;
+	folio = folio_alloc(gfp_mask, PAGE_FRAG_CACHE_MAX_ORDER);
 #endif
-	if (unlikely(!page))
-		page = alloc_pages_node(NUMA_NO_NODE, gfp, 0);
-
-	nc->va = page ? page_address(page) : NULL;
+	if (unlikely(!folio))
+		folio = folio_alloc(gfp, 0);
 
-	return page;
+	if (folio)
+		nc->folio = folio;
+	return folio;
 }
 
 void __page_frag_cache_drain(struct page *page, unsigned int count)
 {
-	VM_BUG_ON_PAGE(page_ref_count(page) == 0, page);
+	struct folio *folio = page_folio(page);
 
-	if (page_ref_sub_and_test(page, count - 1))
-		__free_pages(page, compound_order(page));
+	VM_BUG_ON_FOLIO(folio_ref_count(folio) == 0, folio);
+
+	folio_put_refs(folio, count);
 }
 EXPORT_SYMBOL(__page_frag_cache_drain);
 
+void page_frag_cache_clear(struct page_frag_cache *nc)
+{
+	struct folio *folio = nc->folio;
+
+	if (folio) {
+		VM_BUG_ON_FOLIO(folio_ref_count(folio) == 0, folio);
+		folio_put_refs(folio, nc->pagecnt_bias);
+		nc->folio = NULL;
+	}
+}
+EXPORT_SYMBOL(page_frag_cache_clear);
+
 void *page_frag_alloc_align(struct page_frag_cache *nc,
 		      unsigned int fragsz, gfp_t gfp_mask,
 		      unsigned int align_mask)
 {
-	unsigned int size = PAGE_SIZE;
-	struct page *page;
-	int offset;
+	struct folio *folio = nc->folio;
+	size_t offset;
 
-	if (unlikely(!nc->va)) {
+	if (unlikely(!folio)) {
 refill:
-		page = __page_frag_cache_refill(nc, gfp_mask);
-		if (!page)
+		folio = page_frag_cache_refill(nc, gfp_mask);
+		if (!folio)
 			return NULL;
 
-#if (PAGE_SIZE < PAGE_FRAG_CACHE_MAX_SIZE)
-		/* if size can vary use size else just use PAGE_SIZE */
-		size = nc->size;
-#endif
 		/* Even if we own the page, we do not use atomic_set().
 		 * This would break get_page_unless_zero() users.
 		 */
-		page_ref_add(page, PAGE_FRAG_CACHE_MAX_SIZE);
+		folio_ref_add(folio, PAGE_FRAG_CACHE_MAX_SIZE);
 
 		/* reset page count bias and offset to start of new frag */
-		nc->pfmemalloc = page_is_pfmemalloc(page);
+		nc->pfmemalloc = folio_is_pfmemalloc(folio);
 		nc->pagecnt_bias = PAGE_FRAG_CACHE_MAX_SIZE + 1;
-		nc->offset = size;
+		nc->offset = folio_size(folio);
 	}
 
-	offset = nc->offset - fragsz;
-	if (unlikely(offset < 0)) {
-		page = virt_to_page(nc->va);
-
-		if (page_ref_count(page) != nc->pagecnt_bias)
+	offset = nc->offset;
+	if (unlikely(fragsz > offset)) {
+		/* Reuse the folio if everyone we gave it to has finished with
+		 * it.
+		 */
+		if (!folio_ref_sub_and_test(folio, nc->pagecnt_bias)) {
+			nc->folio = NULL;
 			goto refill;
+		}
+
 		if (unlikely(nc->pfmemalloc)) {
-			page_ref_sub(page, nc->pagecnt_bias - 1);
-			__free_pages(page, compound_order(page));
+			__folio_put(folio);
+			nc->folio = NULL;
 			goto refill;
 		}
 
-#if (PAGE_SIZE < PAGE_FRAG_CACHE_MAX_SIZE)
-		/* if size can vary use size else just use PAGE_SIZE */
-		size = nc->size;
-#endif
 		/* OK, page count is 0, we can safely set it */
-		set_page_count(page, PAGE_FRAG_CACHE_MAX_SIZE + 1);
+		folio_set_count(folio, PAGE_FRAG_CACHE_MAX_SIZE + 1);
 
 		/* reset page count bias and offset to start of new frag */
 		nc->pagecnt_bias = PAGE_FRAG_CACHE_MAX_SIZE + 1;
-		offset = size - fragsz;
-		if (unlikely(offset < 0)) {
+		offset = folio_size(folio);
+		if (unlikely(fragsz > offset)) {
 			/*
 			 * The caller is trying to allocate a fragment
 			 * with fragsz > PAGE_SIZE but the cache isn't big
@@ -107,15 +115,17 @@ void *page_frag_alloc_align(struct page_frag_cache *nc,
 			 * it could make memory pressure worse
 			 * so we simply return NULL here.
 			 */
+			nc->offset = offset;
 			return NULL;
 		}
 	}
 
 	nc->pagecnt_bias--;
+	offset -= fragsz;
 	offset &= align_mask;
 	nc->offset = offset;
 
-	return nc->va + offset;
+	return folio_address(folio) + offset;
 }
 EXPORT_SYMBOL(page_frag_alloc_align);
 
@@ -124,8 +134,6 @@ EXPORT_SYMBOL(page_frag_alloc_align);
  */
 void page_frag_free(void *addr)
 {
-	struct page *page = virt_to_head_page(addr);
-
-	__free_pages(page, compound_order(page));
+	folio_put(virt_to_folio(addr));
 }
 EXPORT_SYMBOL(page_frag_free);

