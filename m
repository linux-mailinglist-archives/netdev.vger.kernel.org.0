Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9D7832443D
	for <lists+netdev@lfdr.de>; Wed, 24 Feb 2021 20:00:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235803AbhBXS72 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 13:59:28 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:53376 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235276AbhBXS6X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Feb 2021 13:58:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614193015;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=J2GT3Unh95elqMpldeh7zjbELEnC6JldM1jdV32+9t4=;
        b=FbrddVRPscMGIQ9iVfEBvL9uUXyFScTh8qwW1gubGlVuOzaC820q7NVH13RcSJhrRz/CJt
        qir5jBcqI1zXVI2xG3uk/uTL6ym9npXUvIgKDt4UEGWD1aj4xyllGCHBCLHc3s0SOT1Rtb
        EilEup0wrIdc+e/03oQidx3uiaS8yTM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-232-Tbd4enyCNjavKWsUbBV3mg-1; Wed, 24 Feb 2021 13:56:51 -0500
X-MC-Unique: Tbd4enyCNjavKWsUbBV3mg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 72FCC1087D61;
        Wed, 24 Feb 2021 18:56:50 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.40.208.7])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4C61F60BE5;
        Wed, 24 Feb 2021 18:56:47 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id 3F99D30736C73;
        Wed, 24 Feb 2021 19:56:46 +0100 (CET)
Subject: [PATCH RFC net-next 2/3] net: page_pool: use alloc_pages_bulk in
 refill code path
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Mel Gorman <mgorman@techsingularity.net>, linux-mm@kvack.org
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>, chuck.lever@oracle.com,
        netdev@vger.kernel.org, linux-nfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Wed, 24 Feb 2021 19:56:46 +0100
Message-ID: <161419300618.2718959.11165518489200268845.stgit@firesoul>
In-Reply-To: <161419296941.2718959.12575257358107256094.stgit@firesoul>
References: <161419296941.2718959.12575257358107256094.stgit@firesoul>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
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
page_pool. In this case, we saw[1] an improvement of 18.8% from using
the alloc_pages_bulk API (3,677,958 pps -> 4,368,926 pps).

[1] https://github.com/xdp-project/xdp-project/blob/master/areas/mem/page_pool06_alloc_pages_bulk.org

Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
---
 net/core/page_pool.c |   65 ++++++++++++++++++++++++++++++++------------------
 1 file changed, 41 insertions(+), 24 deletions(-)

diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index 50d52aa6fbeb..e0ae95fc59f0 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -210,44 +210,61 @@ noinline
 static struct page *__page_pool_alloc_pages_slow(struct page_pool *pool,
 						 gfp_t _gfp)
 {
-	struct page *page;
+	const int bulk = PP_ALLOC_CACHE_REFILL;
+	struct page *page, *next, *first_page;
+	unsigned int pp_flags = pool->p.flags;
+	unsigned int pp_order = pool->p.order;
+	int pp_nid = pool->p.nid;
+	LIST_HEAD(page_list);
 	gfp_t gfp = _gfp;
 
-	/* We could always set __GFP_COMP, and avoid this branch, as
-	 * prep_new_page() can handle order-0 with __GFP_COMP.
-	 */
-	if (pool->p.order)
+	/* Don't support bulk alloc for high-order pages */
+	if (unlikely(pp_order)) {
 		gfp |= __GFP_COMP;
+		first_page = alloc_pages_node(pp_nid, gfp, pp_order);
+		if (unlikely(!first_page))
+			return NULL;
+		goto out;
+	}
 
-	/* FUTURE development:
-	 *
-	 * Current slow-path essentially falls back to single page
-	 * allocations, which doesn't improve performance.  This code
-	 * need bulk allocation support from the page allocator code.
-	 */
-
-	/* Cache was empty, do real allocation */
-#ifdef CONFIG_NUMA
-	page = alloc_pages_node(pool->p.nid, gfp, pool->p.order);
-#else
-	page = alloc_pages(gfp, pool->p.order);
-#endif
-	if (!page)
+	if (unlikely(!__alloc_pages_bulk_nodemask(gfp, pp_nid, NULL,
+						  bulk, &page_list)))
 		return NULL;
 
+	/* First page is extracted and returned to caller */
+	first_page = list_first_entry(&page_list, struct page, lru);
+	list_del(&first_page->lru);
+
+	/* Remaining pages store in alloc.cache */
+	list_for_each_entry_safe(page, next, &page_list, lru) {
+		list_del(&page->lru);
+		if (pp_flags & PP_FLAG_DMA_MAP) {
+			page = page_pool_dma_map(pool, page);
+			if (!page)
+				continue;
+		}
+		if (likely(pool->alloc.count < PP_ALLOC_CACHE_SIZE)) {
+			pool->alloc.cache[pool->alloc.count++] = page;
+			pool->pages_state_hold_cnt++;
+			trace_page_pool_state_hold(pool, page,
+						   pool->pages_state_hold_cnt);
+		} else {
+			put_page(page);
+		}
+	}
+out:
 	if (pool->p.flags & PP_FLAG_DMA_MAP) {
-		page = page_pool_dma_map(pool, page);
-		if (!page)
+		first_page = page_pool_dma_map(pool, first_page);
+		if (!first_page)
 			return NULL;
 	}
 
 	/* Track how many pages are held 'in-flight' */
 	pool->pages_state_hold_cnt++;
-
-	trace_page_pool_state_hold(pool, page, pool->pages_state_hold_cnt);
+	trace_page_pool_state_hold(pool, first_page, pool->pages_state_hold_cnt);
 
 	/* When page just alloc'ed is should/must have refcnt 1. */
-	return page;
+	return first_page;
 }
 
 /* For using page_pool replace: alloc_pages() API calls, but provide


