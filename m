Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C3C13483D1
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 22:35:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230362AbhCXVf0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 17:35:26 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:52936 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233901AbhCXVe6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Mar 2021 17:34:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616621697;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UfGrVeHEI0sce0qvVh5BuQBoPgz+S960/h6BqEQEhUA=;
        b=ERRuAvWGOk6kXTebuYVxuL3GFM5ehcFn75ujfGQJeM8lhg2Q/I7azmcpLb+dpquTzbZeUH
        J6bGz9Lq2fEUIHr8MpKCpmffwT5kbjtwfJ9Qn3W++jp0yEJukZ87NMYhhbXb+hQ8LST8pI
        0iTAlE3a5Gx2pzARdJ8+emv4zM1GrS4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-339-SdPLb4OhPCStBnI5K1dcdA-1; Wed, 24 Mar 2021 17:34:55 -0400
X-MC-Unique: SdPLb4OhPCStBnI5K1dcdA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4FC30185302D;
        Wed, 24 Mar 2021 21:34:53 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.40.208.69])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 452EB6A8F1;
        Wed, 24 Mar 2021 21:34:50 +0000 (UTC)
Received: from [10.1.1.1] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id 2CC8E300A2A79;
        Wed, 24 Mar 2021 22:34:49 +0100 (CET)
Subject: [PATCH mel-git 1/3] net: page_pool: refactor dma_map into own
 function page_pool_dma_map
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Mel Gorman <mgorman@techsingularity.net>, linux-mm@kvack.org
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>, chuck.lever@oracle.com,
        Alexander Duyck <alexander.duyck@gmail.com>,
        netdev@vger.kernel.org, linux-nfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Wed, 24 Mar 2021 22:34:49 +0100
Message-ID: <161662168912.940814.14561278459325120343.stgit@firesoul>
In-Reply-To: <161662166301.940814.9765023867613542235.stgit@firesoul>
References: <161662166301.940814.9765023867613542235.stgit@firesoul>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation for next patch, move the dma mapping into its own
function, as this will make it easier to follow the changes.

V2: make page_pool_dma_map return boolean (Ilias)

Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Reviewed-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
---
 net/core/page_pool.c |   45 ++++++++++++++++++++++++++-------------------
 1 file changed, 26 insertions(+), 19 deletions(-)

diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index ad8b0707af04..40e1b2beaa6c 100644
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
+	if ((pp_flags & PP_FLAG_DMA_MAP) &&
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


