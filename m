Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C9003483D4
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 22:36:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234167AbhCXVfd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 17:35:33 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:26534 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234068AbhCXVfI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Mar 2021 17:35:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616621707;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6BnFLXKVdKYd+FoHFgU/6B9JS5Q/kAb0dewwrIr5OVo=;
        b=GVHrNuml0fxIswC3UNeJMDR0Kzi7+zG+f5nM9XQhg5wiDBNmycgNbzQt9tjYEut7y26SK/
        AiuZxMlE9YFYYgS6Iu4LIDnS8dHVewBbb2Fid6o66Kax04r2mao/JOGj/bNZvMRHMLJoXY
        0k8+YaIDFJlMHMXGAUE50pLwTbkZIp8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-40-u3BcfBy3OJWg78JhInYkYQ-1; Wed, 24 Mar 2021 17:35:05 -0400
X-MC-Unique: u3BcfBy3OJWg78JhInYkYQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 254FF801817;
        Wed, 24 Mar 2021 21:35:04 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.40.208.69])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5E1E65D9DE;
        Wed, 24 Mar 2021 21:35:00 +0000 (UTC)
Received: from [10.1.1.1] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id 4E956300A2A79;
        Wed, 24 Mar 2021 22:34:59 +0100 (CET)
Subject: [PATCH mel-git 3/3] net: page_pool: convert to use
 alloc_pages_bulk_array variant
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Mel Gorman <mgorman@techsingularity.net>, linux-mm@kvack.org
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>, chuck.lever@oracle.com,
        Alexander Duyck <alexander.duyck@gmail.com>,
        netdev@vger.kernel.org, linux-nfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Wed, 24 Mar 2021 22:34:59 +0100
Message-ID: <161662169926.940814.10878534922009676003.stgit@firesoul>
In-Reply-To: <161662166301.940814.9765023867613542235.stgit@firesoul>
References: <161662166301.940814.9765023867613542235.stgit@firesoul>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Using the API variant alloc_pages_bulk_array from page_pool
was done in a separate patch to ease benchmarking the
variants separately.  Maintainers can squash patch if preferred.

Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
---
 include/net/page_pool.h |    2 +-
 net/core/page_pool.c    |   22 ++++++++++++++++------
 2 files changed, 17 insertions(+), 7 deletions(-)

diff --git a/include/net/page_pool.h b/include/net/page_pool.h
index b5b195305346..6d517a37c18b 100644
--- a/include/net/page_pool.h
+++ b/include/net/page_pool.h
@@ -65,7 +65,7 @@
 #define PP_ALLOC_CACHE_REFILL	64
 struct pp_alloc_cache {
 	u32 count;
-	void *cache[PP_ALLOC_CACHE_SIZE];
+	struct page *cache[PP_ALLOC_CACHE_SIZE];
 };
 
 struct page_pool_params {
diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index 3bf6e7f5fc89..9ec1aa9640ad 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -233,24 +233,34 @@ static struct page *__page_pool_alloc_pages_slow(struct page_pool *pool,
 	const int bulk = PP_ALLOC_CACHE_REFILL;
 	unsigned int pp_flags = pool->p.flags;
 	unsigned int pp_order = pool->p.order;
-	struct page *page, *next;
-	LIST_HEAD(page_list);
+	struct page *page;
+	int i, nr_pages;
 
 	/* Don't support bulk alloc for high-order pages */
 	if (unlikely(pp_order))
 		return __page_pool_alloc_page_order(pool, gfp);
 
-	if (unlikely(!alloc_pages_bulk_list(gfp, bulk, &page_list)))
+	/* Unnecessary as alloc cache is empty, but guarantees zero count */
+	if (unlikely(pool->alloc.count > 0))
+		return pool->alloc.cache[--pool->alloc.count];
+
+	/* Mark empty alloc.cache slots "empty" for alloc_pages_bulk_array */
+	memset(&pool->alloc.cache, 0, sizeof(void *) * bulk);
+
+	nr_pages = alloc_pages_bulk_array(gfp, bulk, pool->alloc.cache);
+	if (unlikely(!nr_pages))
 		return NULL;
 
-	list_for_each_entry_safe(page, next, &page_list, lru) {
-		list_del(&page->lru);
+	/* Pages have been filled into alloc.cache array, but count is zero and
+	 * page element have not been (possibly) DMA mapped.
+	 */
+	for (i = 0; i < nr_pages; i++) {
+		page = pool->alloc.cache[i];
 		if ((pp_flags & PP_FLAG_DMA_MAP) &&
 		    unlikely(!page_pool_dma_map(pool, page))) {
 			put_page(page);
 			continue;
 		}
-		/* Alloc cache have room as it is empty on function call */
 		pool->alloc.cache[pool->alloc.count++] = page;
 		/* Track how many pages are held 'in-flight' */
 		pool->pages_state_hold_cnt++;


