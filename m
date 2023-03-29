Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B7C86CDBCA
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 16:16:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230429AbjC2OQm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 10:16:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230241AbjC2OQd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 10:16:33 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01FF659D8
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 07:15:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680099262;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=w9vYmidIh5WhninpbPh1DpHK4Q4l9z+4/ehUwmRVCvg=;
        b=ihZieKEPis50jocnwXZWG6sWbc06fopyazPraZXycY7igVKA19CwgVCo44ipQq0W6KZoyC
        Je0TSsaSPksv+wfDgOqYYsIc7jJ4YfyFJjOJ22Oh4Xpew3lk7OVBVNO49lORHO2zomCd8d
        1p1DlVcQLKqjERa5Ve+hyoTFENtp7+o=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-187-vEQ2qQN_Nv6Frz5PzfcuyA-1; Wed, 29 Mar 2023 10:14:16 -0400
X-MC-Unique: vEQ2qQN_Nv6Frz5PzfcuyA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C7D96801779;
        Wed, 29 Mar 2023 14:14:15 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E3D6E4020C83;
        Wed, 29 Mar 2023 14:14:13 +0000 (UTC)
From:   David Howells <dhowells@redhat.com>
To:     Matthew Wilcox <willy@infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     David Howells <dhowells@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>,
        Jens Axboe <axboe@kernel.dk>, Jeff Layton <jlayton@kernel.org>,
        Christian Brauner <brauner@kernel.org>,
        Chuck Lever III <chuck.lever@oracle.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        netdev@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [RFC PATCH v2 06/48] mm: Make the page_frag_cache allocator use multipage folios
Date:   Wed, 29 Mar 2023 15:13:12 +0100
Message-Id: <20230329141354.516864-7-dhowells@redhat.com>
In-Reply-To: <20230329141354.516864-1-dhowells@redhat.com>
References: <20230329141354.516864-1-dhowells@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
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
cc: Matthew Wilcox <willy@infradead.org>
cc: netdev@vger.kernel.org
---
 include/linux/mm_types.h | 13 ++----
 mm/page_frag_alloc.c     | 88 +++++++++++++++++++---------------------
 2 files changed, 45 insertions(+), 56 deletions(-)

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
index bee95824ef8f..c3792b68ce32 100644
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
 
@@ -50,54 +51,47 @@ void *page_frag_alloc_align(struct page_frag_cache *nc,
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
+		/* Reuse the folio if everyone we gave it to has finished with it. */
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
@@ -107,15 +101,17 @@ void *page_frag_alloc_align(struct page_frag_cache *nc,
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
 
@@ -124,8 +120,6 @@ EXPORT_SYMBOL(page_frag_alloc_align);
  */
 void page_frag_free(void *addr)
 {
-	struct page *page = virt_to_head_page(addr);
-
-	__free_pages(page, compound_order(page));
+	folio_put(virt_to_folio(addr));
 }
 EXPORT_SYMBOL(page_frag_free);

