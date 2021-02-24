Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79F34324438
	for <lists+netdev@lfdr.de>; Wed, 24 Feb 2021 20:00:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235657AbhBXS64 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 13:58:56 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:55788 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235750AbhBXS6N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Feb 2021 13:58:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614193006;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SA3Llh8vILJh1ORZtfVQcGyaHvHK4xGRwPJ760zHgnI=;
        b=CuQdz6mu0/zcFi5FS9SJqeXLzWWayMcyDKO9KCOVsQZhKrFmy7nJC3qQ+Ufj6X1H8tL8Sn
        wBGdjbhI+HJ8z9B30GE2EMCm0njSbu4ihS2CmqF3gkuQz7Drpfp+qh1y7gtB9lj1AzpMr1
        BL/WPRMLcSIO2rFDJ2EREVLickCLaRE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-457-BKWPuBlyMWCn288FLnXnWA-1; Wed, 24 Feb 2021 13:56:44 -0500
X-MC-Unique: BKWPuBlyMWCn288FLnXnWA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C09B0107ACF3;
        Wed, 24 Feb 2021 18:56:42 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.40.208.7])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 42AD69CA0;
        Wed, 24 Feb 2021 18:56:42 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id 27A7D30736C73;
        Wed, 24 Feb 2021 19:56:41 +0100 (CET)
Subject: [PATCH RFC net-next 1/3] net: page_pool: refactor dma_map into own
 function page_pool_dma_map
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Mel Gorman <mgorman@techsingularity.net>, linux-mm@kvack.org
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>, chuck.lever@oracle.com,
        netdev@vger.kernel.org, linux-nfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Wed, 24 Feb 2021 19:56:41 +0100
Message-ID: <161419300107.2718959.18302883670835746249.stgit@firesoul>
In-Reply-To: <161419296941.2718959.12575257358107256094.stgit@firesoul>
References: <161419296941.2718959.12575257358107256094.stgit@firesoul>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation for next patch, move the dma mapping into its own
function, as this will make it easier to follow the changes.

Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
---
 net/core/page_pool.c |   49 +++++++++++++++++++++++++++++--------------------
 1 file changed, 29 insertions(+), 20 deletions(-)

diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index ad8b0707af04..50d52aa6fbeb 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -180,6 +180,31 @@ static void page_pool_dma_sync_for_device(struct page_pool *pool,
 					 pool->p.dma_dir);
 }
 
+static struct page * page_pool_dma_map(struct page_pool *pool,
+				       struct page *page)
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
+	if (dma_mapping_error(pool->p.dev, dma)) {
+		put_page(page);
+		return NULL;
+	}
+	page->dma_addr = dma;
+
+	if (pool->p.flags & PP_FLAG_DMA_SYNC_DEV)
+		page_pool_dma_sync_for_device(pool, page, pool->p.max_len);
+
+	return page;
+}
+
 /* slow path */
 noinline
 static struct page *__page_pool_alloc_pages_slow(struct page_pool *pool,
@@ -187,7 +212,6 @@ static struct page *__page_pool_alloc_pages_slow(struct page_pool *pool,
 {
 	struct page *page;
 	gfp_t gfp = _gfp;
-	dma_addr_t dma;
 
 	/* We could always set __GFP_COMP, and avoid this branch, as
 	 * prep_new_page() can handle order-0 with __GFP_COMP.
@@ -211,27 +235,12 @@ static struct page *__page_pool_alloc_pages_slow(struct page_pool *pool,
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
-		put_page(page);
-		return NULL;
+	if (pool->p.flags & PP_FLAG_DMA_MAP) {
+		page = page_pool_dma_map(pool, page);
+		if (!page)
+			return NULL;
 	}
-	page->dma_addr = dma;
-
-	if (pool->p.flags & PP_FLAG_DMA_SYNC_DEV)
-		page_pool_dma_sync_for_device(pool, page, pool->p.max_len);
 
-skip_dma_map:
 	/* Track how many pages are held 'in-flight' */
 	pool->pages_state_hold_cnt++;
 


