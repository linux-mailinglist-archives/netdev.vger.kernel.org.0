Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B52A328354
	for <lists+netdev@lfdr.de>; Mon,  1 Mar 2021 17:16:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237683AbhCAQPv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Mar 2021 11:15:51 -0500
Received: from outbound-smtp56.blacknight.com ([46.22.136.240]:59201 "EHLO
        outbound-smtp56.blacknight.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237671AbhCAQNZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Mar 2021 11:13:25 -0500
Received: from mail.blacknight.com (pemlinmail02.blacknight.ie [81.17.254.11])
        by outbound-smtp56.blacknight.com (Postfix) with ESMTPS id 0318AFA935
        for <netdev@vger.kernel.org>; Mon,  1 Mar 2021 16:12:02 +0000 (GMT)
Received: (qmail 30545 invoked from network); 1 Mar 2021 16:12:01 -0000
Received: from unknown (HELO stampy.112glenside.lan) (mgorman@techsingularity.net@[84.203.22.4])
  by 81.17.254.9 with ESMTPA; 1 Mar 2021 16:12:01 -0000
From:   Mel Gorman <mgorman@techsingularity.net>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Chuck Lever <chuck.lever@oracle.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux-Net <netdev@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Linux-NFS <linux-nfs@vger.kernel.org>,
        Mel Gorman <mgorman@techsingularity.net>
Subject: [PATCH 4/5] net: page_pool: refactor dma_map into own function page_pool_dma_map
Date:   Mon,  1 Mar 2021 16:11:59 +0000
Message-Id: <20210301161200.18852-5-mgorman@techsingularity.net>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210301161200.18852-1-mgorman@techsingularity.net>
References: <20210301161200.18852-1-mgorman@techsingularity.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jesper Dangaard Brouer <brouer@redhat.com>

In preparation for next patch, move the dma mapping into its own
function, as this will make it easier to follow the changes.

V2: make page_pool_dma_map return boolean (Ilias)

Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
---
 net/core/page_pool.c | 45 +++++++++++++++++++++++++-------------------
 1 file changed, 26 insertions(+), 19 deletions(-)

diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index ad8b0707af04..a26f2ceb6a87 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -180,14 +180,37 @@ static void page_pool_dma_sync_for_device(struct page_pool *pool,
 					 pool->p.dma_dir);
 }
 
+static bool page_pool_dma_map(struct page_pool *pool, struct page *page)
+{
+	dma_addr_t dma;
+
+	/* Setup DMA mapping: use 'struct page' area for storing DMA-addr
+	 * since dma_addr_t can be either 32 or 64 bits and does not always fit
+	 * into page private data (i.e 32bit cpu with 64bit DMA caps)
+	 * This mapping is kept for lifetime of page, until leaving pool.
+	 */
+	dma = dma_map_page_attrs(pool->p.dev, page, 0,
+				 (PAGE_SIZE << pool->p.order),
+				 pool->p.dma_dir, DMA_ATTR_SKIP_CPU_SYNC);
+	if (dma_mapping_error(pool->p.dev, dma))
+		return false;
+
+	page->dma_addr = dma;
+
+	if (pool->p.flags & PP_FLAG_DMA_SYNC_DEV)
+		page_pool_dma_sync_for_device(pool, page, pool->p.max_len);
+
+	return true;
+}
+
 /* slow path */
 noinline
 static struct page *__page_pool_alloc_pages_slow(struct page_pool *pool,
 						 gfp_t _gfp)
 {
+	unsigned int pp_flags = pool->p.flags;
 	struct page *page;
 	gfp_t gfp = _gfp;
-	dma_addr_t dma;
 
 	/* We could always set __GFP_COMP, and avoid this branch, as
 	 * prep_new_page() can handle order-0 with __GFP_COMP.
@@ -211,30 +234,14 @@ static struct page *__page_pool_alloc_pages_slow(struct page_pool *pool,
 	if (!page)
 		return NULL;
 
-	if (!(pool->p.flags & PP_FLAG_DMA_MAP))
-		goto skip_dma_map;
-
-	/* Setup DMA mapping: use 'struct page' area for storing DMA-addr
-	 * since dma_addr_t can be either 32 or 64 bits and does not always fit
-	 * into page private data (i.e 32bit cpu with 64bit DMA caps)
-	 * This mapping is kept for lifetime of page, until leaving pool.
-	 */
-	dma = dma_map_page_attrs(pool->p.dev, page, 0,
-				 (PAGE_SIZE << pool->p.order),
-				 pool->p.dma_dir, DMA_ATTR_SKIP_CPU_SYNC);
-	if (dma_mapping_error(pool->p.dev, dma)) {
+	if (pp_flags & PP_FLAG_DMA_MAP &&
+	    unlikely(!page_pool_dma_map(pool, page))) {
 		put_page(page);
 		return NULL;
 	}
-	page->dma_addr = dma;
 
-	if (pool->p.flags & PP_FLAG_DMA_SYNC_DEV)
-		page_pool_dma_sync_for_device(pool, page, pool->p.max_len);
-
-skip_dma_map:
 	/* Track how many pages are held 'in-flight' */
 	pool->pages_state_hold_cnt++;
-
 	trace_page_pool_state_hold(pool, page, pool->pages_state_hold_cnt);
 
 	/* When page just alloc'ed is should/must have refcnt 1. */
-- 
2.26.2

