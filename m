Return-Path: <netdev+bounces-5092-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4CD2B70FA4A
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 17:35:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 00A351C209BD
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 15:35:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB04F19BBE;
	Wed, 24 May 2023 15:34:25 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA30819BA0
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 15:34:25 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B30361A7
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 08:33:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684942414;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=E/mkzJ+c6qr7yPOsPF9NXbENxWjJthPNWT3mBurv3yc=;
	b=Kl/d8uRVqHoqy6t67jIyWJG+FdoHl4o80HDg8dKimTsfU0CPt45a5B+LQPTP6L+bJIV+5t
	Z2DSn7/0jqr36t3FWcRjSDBO1W5aKMCOAj/kPlmw1YdFgSPMS3VrOCe7GNwydphU+RbsA9
	TBaPHlMo6r89U5IgOsGkURKcllo/aoU=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-617-ozOdLk_aN02TMJY6p7EiVg-1; Wed, 24 May 2023 11:33:33 -0400
X-MC-Unique: ozOdLk_aN02TMJY6p7EiVg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B040C280BC80;
	Wed, 24 May 2023 15:33:31 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.39.192.68])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C783840CFD45;
	Wed, 24 May 2023 15:33:27 +0000 (UTC)
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
Subject: [PATCH net-next 04/12] mm: Make the page_frag_cache allocator use multipage folios
Date: Wed, 24 May 2023 16:33:03 +0100
Message-Id: <20230524153311.3625329-5-dhowells@redhat.com>
In-Reply-To: <20230524153311.3625329-1-dhowells@redhat.com>
References: <20230524153311.3625329-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

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
 include/linux/mm_types.h | 13 ++----
 mm/page_frag_alloc.c     | 99 +++++++++++++++++++---------------------
 2 files changed, 52 insertions(+), 60 deletions(-)

diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 306a3d1a0fa6..d7c52a5979cc 100644
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
index 9d3f6fbd9a07..ffd68bfb677d 100644
--- a/mm/page_frag_alloc.c
+++ b/mm/page_frag_alloc.c
@@ -16,33 +16,34 @@
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
+	if (unlikely(!folio))
+		folio = folio_alloc(gfp, 0);
 
-	nc->va = page ? page_address(page) : NULL;
-
-	return page;
+	if (folio)
+		nc->folio = folio;
+	return folio;
 }
 
 void __page_frag_cache_drain(struct page *page, unsigned int count)
 {
-	VM_BUG_ON_PAGE(page_ref_count(page) == 0, page);
+	struct folio *folio = page_folio(page);
+
+	VM_BUG_ON_FOLIO(folio_ref_count(folio) == 0, folio);
 
-	if (page_ref_sub_and_test(page, count - 1))
-		__free_pages(page, compound_order(page));
+	folio_put_refs(folio, count);
 }
 EXPORT_SYMBOL(__page_frag_cache_drain);
 
@@ -54,11 +55,12 @@ EXPORT_SYMBOL(__page_frag_cache_drain);
  */
 void page_frag_cache_clear(struct page_frag_cache *nc)
 {
-	if (nc->va) {
-		struct page *page = virt_to_head_page(nc->va);
+	struct folio *folio = nc->folio;
 
-		__page_frag_cache_drain(page, nc->pagecnt_bias);
-		nc->va = NULL;
+	if (folio) {
+		VM_BUG_ON_FOLIO(folio_ref_count(folio) == 0, folio);
+		folio_put_refs(folio, nc->pagecnt_bias);
+		nc->folio = NULL;
 	}
 }
 EXPORT_SYMBOL(page_frag_cache_clear);
@@ -67,56 +69,51 @@ void *page_frag_alloc_align(struct page_frag_cache *nc,
 			    unsigned int fragsz, gfp_t gfp_mask,
 			    unsigned int align)
 {
-	unsigned int size = PAGE_SIZE;
-	struct page *page;
-	int offset;
+	struct folio *folio = nc->folio;
+	size_t offset;
 
 	WARN_ON_ONCE(!is_power_of_2(align));
 
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
@@ -126,15 +123,17 @@ void *page_frag_alloc_align(struct page_frag_cache *nc,
 			 * it could make memory pressure worse
 			 * so we simply return NULL here.
 			 */
+			nc->offset = offset;
 			return NULL;
 		}
 	}
 
 	nc->pagecnt_bias--;
+	offset -= fragsz;
 	offset &= ~(align - 1);
 	nc->offset = offset;
 
-	return nc->va + offset;
+	return folio_address(folio) + offset;
 }
 EXPORT_SYMBOL(page_frag_alloc_align);
 
@@ -143,8 +142,6 @@ EXPORT_SYMBOL(page_frag_alloc_align);
  */
 void page_frag_free(void *addr)
 {
-	struct page *page = virt_to_head_page(addr);
-
-	__free_pages(page, compound_order(page));
+	folio_put(virt_to_folio(addr));
 }
 EXPORT_SYMBOL(page_frag_free);


