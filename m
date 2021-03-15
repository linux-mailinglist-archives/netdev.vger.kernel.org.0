Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABA4C33C6E2
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 20:34:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233661AbhCOTds (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 15:33:48 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:46350 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233675AbhCOTdk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Mar 2021 15:33:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615836819;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ikEFCrnLtZHBa2my38LuFFSw28vFN+co4nd7kls4/Ls=;
        b=dVggWBbrXZ6tPWQZ8tmsn4A0uDZaDXeL49artzLpdvzMAswDf1eaxLZHSvmFHMAZtpo73G
        DLzDJWpDFaRIprfhq1kN9sY04Y6GgxIvgxRxFghrEk/qWkYPsA8XQfkDUEdFAxpc5Vzy0F
        WxbAuZ+qbYeJMbkSnV1INF1C3Lrtok4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-167-hrO1AAzdOyCqU8E3y8_3IA-1; Mon, 15 Mar 2021 15:33:35 -0400
X-MC-Unique: hrO1AAzdOyCqU8E3y8_3IA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 013C3100C618;
        Mon, 15 Mar 2021 19:33:34 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.40.208.15])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7612E19701;
        Mon, 15 Mar 2021 19:33:30 +0000 (UTC)
Received: from [10.1.1.1] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id 624AF3250E696;
        Mon, 15 Mar 2021 20:33:29 +0100 (CET)
Subject: [PATCH mel-git] net: page_pool: use alloc_pages_bulk in refill code
 path
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Mel Gorman <mgorman@techsingularity.net>, linux-mm@kvack.org
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>, chuck.lever@oracle.com,
        Alexander Duyck <alexander.duyck@gmail.com>,
        netdev@vger.kernel.org, linux-nfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Mon, 15 Mar 2021 20:33:29 +0100
Message-ID: <161583680934.3715498.9919702368074023313.stgit@firesoul>
In-Reply-To: <161583677541.3715498.6118778324185171839.stgit@firesoul>
References: <161583677541.3715498.6118778324185171839.stgit@firesoul>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
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
page_pool. In this case, we saw[1] an improvement of 13% from using
the alloc_pages_bulk API (3,810,013 pps -> 4,308,208 pps).

[1] https://github.com/xdp-project/xdp-project/blob/master/areas/mem/page_pool06_alloc_pages_bulk.org

Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
---
 net/core/page_pool.c |   73 ++++++++++++++++++++++++++++++++------------------
 1 file changed, 47 insertions(+), 26 deletions(-)

diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index 40e1b2beaa6c..7c194335c066 100644
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
@@ -243,6 +222,48 @@ static struct page *__page_pool_alloc_pages_slow(struct page_pool *pool,
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
+	int pp_nid = pool->p.nid;
+	struct page *page, *next;
+	LIST_HEAD(page_list);
+
+	/* Don't support bulk alloc for high-order pages */
+	if (unlikely(pp_order))
+		return __page_pool_alloc_page_order(pool, gfp);
+
+	if (unlikely(!__alloc_pages_bulk(gfp, pp_nid, NULL, bulk, &page_list)))
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


