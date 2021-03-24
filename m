Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06F483483D3
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 22:36:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238474AbhCXVf3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 17:35:29 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:40385 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234021AbhCXVfF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Mar 2021 17:35:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616621704;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xNVBBcPNMnk3z4ciJsLBFU3/kjZdyv/OnoV8PVtQezs=;
        b=Pu3Ol0vJFfP9icZMFqMot+5NVPvi78Ze2YK+Gw1k4JPfuHa7rma35b79cYSl/Yc1qNJ+HL
        61EvOE1iVBrcNY+4NG8RTgJtLrKx23nBv4FWx/CEDLLIfrcr9lI93nomeyF//wQ8t71QER
        7yIkCFdq7p0gi4rgBc4Mq9Fzf4Jjs/A=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-378--H7b821KPA-OGqUEpO9hVQ-1; Wed, 24 Mar 2021 17:35:00 -0400
X-MC-Unique: -H7b821KPA-OGqUEpO9hVQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E85431009462;
        Wed, 24 Mar 2021 21:34:58 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.40.208.69])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 435BB6E6F5;
        Wed, 24 Mar 2021 21:34:55 +0000 (UTC)
Received: from [10.1.1.1] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id 3DA90300A2A79;
        Wed, 24 Mar 2021 22:34:54 +0100 (CET)
Subject: [PATCH mel-git 2/3] net: page_pool: use alloc_pages_bulk in refill
 code path
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Mel Gorman <mgorman@techsingularity.net>, linux-mm@kvack.org
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>, chuck.lever@oracle.com,
        Alexander Duyck <alexander.duyck@gmail.com>,
        netdev@vger.kernel.org, linux-nfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Wed, 24 Mar 2021 22:34:54 +0100
Message-ID: <161662169419.940814.17570004014550134474.stgit@firesoul>
In-Reply-To: <161662166301.940814.9765023867613542235.stgit@firesoul>
References: <161662166301.940814.9765023867613542235.stgit@firesoul>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are cases where the page_pool need to refill with pages from the
page allocator. Some workloads cause the page_pool to release pages
instead of recycling these pages.

For these workload it can improve performance to bulk alloc pages from
the page-allocator to refill the alloc cache.

For XDP-redirect workload with 100G mlx5 driver (that use page_pool)
redirecting xdp_frame packets into a veth, that does XDP_PASS to create
an SKB from the xdp_frame, which then cannot return the page to the
page_pool.

Performance results under GitHub xdp-project[1]:
 [1] https://github.com/xdp-project/xdp-project/blob/master/areas/mem/page_pool06_alloc_pages_bulk.org

Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
---
 net/core/page_pool.c |   72 ++++++++++++++++++++++++++++++++------------------
 1 file changed, 46 insertions(+), 26 deletions(-)

diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index 40e1b2beaa6c..3bf6e7f5fc89 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -203,38 +203,17 @@ static bool page_pool_dma_map(struct page_pool *pool, struct page *page)
 	return true;
 }
 
-/* slow path */
-noinline
-static struct page *__page_pool_alloc_pages_slow(struct page_pool *pool,
-						 gfp_t _gfp)
+static struct page *__page_pool_alloc_page_order(struct page_pool *pool,
+						 gfp_t gfp)
 {
-	unsigned int pp_flags = pool->p.flags;
 	struct page *page;
-	gfp_t gfp = _gfp;
-
-	/* We could always set __GFP_COMP, and avoid this branch, as
-	 * prep_new_page() can handle order-0 with __GFP_COMP.
-	 */
-	if (pool->p.order)
-		gfp |= __GFP_COMP;
-
-	/* FUTURE development:
-	 *
-	 * Current slow-path essentially falls back to single page
-	 * allocations, which doesn't improve performance.  This code
-	 * need bulk allocation support from the page allocator code.
-	 */
 
-	/* Cache was empty, do real allocation */
-#ifdef CONFIG_NUMA
+	gfp |= __GFP_COMP;
 	page = alloc_pages_node(pool->p.nid, gfp, pool->p.order);
-#else
-	page = alloc_pages(gfp, pool->p.order);
-#endif
-	if (!page)
+	if (unlikely(!page))
 		return NULL;
 
-	if ((pp_flags & PP_FLAG_DMA_MAP) &&
+	if ((pool->p.flags & PP_FLAG_DMA_MAP) &&
 	    unlikely(!page_pool_dma_map(pool, page))) {
 		put_page(page);
 		return NULL;
@@ -243,6 +222,47 @@ static struct page *__page_pool_alloc_pages_slow(struct page_pool *pool,
 	/* Track how many pages are held 'in-flight' */
 	pool->pages_state_hold_cnt++;
 	trace_page_pool_state_hold(pool, page, pool->pages_state_hold_cnt);
+	return page;
+}
+
+/* slow path */
+noinline
+static struct page *__page_pool_alloc_pages_slow(struct page_pool *pool,
+						 gfp_t gfp)
+{
+	const int bulk = PP_ALLOC_CACHE_REFILL;
+	unsigned int pp_flags = pool->p.flags;
+	unsigned int pp_order = pool->p.order;
+	struct page *page, *next;
+	LIST_HEAD(page_list);
+
+	/* Don't support bulk alloc for high-order pages */
+	if (unlikely(pp_order))
+		return __page_pool_alloc_page_order(pool, gfp);
+
+	if (unlikely(!alloc_pages_bulk_list(gfp, bulk, &page_list)))
+		return NULL;
+
+	list_for_each_entry_safe(page, next, &page_list, lru) {
+		list_del(&page->lru);
+		if ((pp_flags & PP_FLAG_DMA_MAP) &&
+		    unlikely(!page_pool_dma_map(pool, page))) {
+			put_page(page);
+			continue;
+		}
+		/* Alloc cache have room as it is empty on function call */
+		pool->alloc.cache[pool->alloc.count++] = page;
+		/* Track how many pages are held 'in-flight' */
+		pool->pages_state_hold_cnt++;
+		trace_page_pool_state_hold(pool, page,
+					   pool->pages_state_hold_cnt);
+	}
+
+	/* Return last page */
+	if (likely(pool->alloc.count > 0))
+		page = pool->alloc.cache[--pool->alloc.count];
+	else
+		page = NULL;
 
 	/* When page just alloc'ed is should/must have refcnt 1. */
 	return page;


