Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DC89327F82
	for <lists+netdev@lfdr.de>; Mon,  1 Mar 2021 14:31:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235683AbhCANbZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Mar 2021 08:31:25 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:23732 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235298AbhCANbW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Mar 2021 08:31:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614605395;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=V3nJAH4Fr9s5L4Cmzuk5Z6xXyAlbwOdVUDrZUdeXL9s=;
        b=dFWDKsHt88aE8nneEDZrjQZ4mVZ2fEMCJ1v3iAynBrGwtl3PjqlBm7OJnaNhcbP7E+/d4c
        PVwy9wh/ALfmAwY4u5Q6mEKzKBvXiuZ6E175aNizQVwVwQ4bQR32vVOhMCtLTU/RjnsSHw
        kvYPys5NPhFt9PqoF4KDeCEGzphbwVw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-325-bGuJeqwUNbaBMv1MGtCakQ-1; Mon, 01 Mar 2021 08:29:51 -0500
X-MC-Unique: bGuJeqwUNbaBMv1MGtCakQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8E21486A093;
        Mon,  1 Mar 2021 13:29:49 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.40.208.7])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DB5F4709B7;
        Mon,  1 Mar 2021 13:29:48 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id C3AEF30736C74;
        Mon,  1 Mar 2021 14:29:47 +0100 (CET)
Subject: [PATCH RFC V2 net-next 1/2] net: page_pool: refactor dma_map into own
 function page_pool_dma_map
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Mel Gorman <mgorman@techsingularity.net>, linux-mm@kvack.org
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>, chuck.lever@oracle.com,
        netdev@vger.kernel.org, linux-nfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Mon, 01 Mar 2021 14:29:47 +0100
Message-ID: <161460538773.3031322.9989061900150136454.stgit@firesoul>
In-Reply-To: <161460522573.3031322.15721946341157092594.stgit@firesoul>
References: <161460522573.3031322.15721946341157092594.stgit@firesoul>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation for next patch, move the dma mapping into its own
function, as this will make it easier to follow the changes.

V2: make page_pool_dma_map return boolean (Ilias)

Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
---
 net/core/page_pool.c |   45 ++++++++++++++++++++++++++-------------------
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


