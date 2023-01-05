Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DD3F65F62B
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 22:49:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236121AbjAEVsK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 16:48:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235873AbjAEVrk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 16:47:40 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE65C67BDB
        for <netdev@vger.kernel.org>; Thu,  5 Jan 2023 13:46:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=JiZMgS7pP8K35sUweK//q6lTVK6Ins4aBIFLXYHxMXM=; b=uV5/9afYQTK6Ax4FZjDPpMUM37
        LPW3S7HgMGYEoWN149Ks4YyYSFd62TzasTqA0XLNdbQhvSOO7x1ioDOrBVe/1tEwhgvtpzYlA81U/
        0vU4/lkVOAeD7xVEnE5Y14DRi3c3gPVyCOyQLrE6/AqWkkiH4zPO1+MTVyN1fNDKUZ/GMTVR0svHU
        F1lFCFJhcG/mC2I6dRqcRLd481TY87Ihvb2toeuTxhOI6pDAxfMTXjJhwyjCr8ku2mceS/cgW2Q2N
        DKlMmDi/FFO75wJktAPF+uPclhXSmvOEAj74/z1AxkICFNWkqkHQVrs5ICM5audupzRE8L8j87z5u
        Y8163Y0g==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pDY4H-00GWn7-QL; Thu, 05 Jan 2023 21:46:33 +0000
From:   "Matthew Wilcox (Oracle)" <willy@infradead.org>
To:     Jesper Dangaard Brouer <hawk@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        netdev@vger.kernel.org, linux-mm@kvack.org,
        Shakeel Butt <shakeelb@google.com>
Subject: [PATCH v2 07/24] page_pool: Convert __page_pool_put_page() to __page_pool_put_netmem()
Date:   Thu,  5 Jan 2023 21:46:14 +0000
Message-Id: <20230105214631.3939268-8-willy@infradead.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20230105214631.3939268-1-willy@infradead.org>
References: <20230105214631.3939268-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Removes the call to compound_head() hidden in put_page() which
saves 169 bytes of kernel text as __page_pool_put_page() is
inlined twice.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 net/core/page_pool.c | 29 +++++++++++++++++++----------
 1 file changed, 19 insertions(+), 10 deletions(-)

diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index b606952773a6..8f3f7cc5a2d5 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -558,8 +558,8 @@ static bool page_pool_recycle_in_cache(struct page *page,
  * If the page refcnt != 1, then the page will be returned to memory
  * subsystem.
  */
-static __always_inline struct page *
-__page_pool_put_page(struct page_pool *pool, struct page *page,
+static __always_inline struct netmem *
+__page_pool_put_netmem(struct page_pool *pool, struct netmem *nmem,
 		     unsigned int dma_sync_size, bool allow_direct)
 {
 	/* This allocator is optimized for the XDP mode that uses
@@ -571,19 +571,20 @@ __page_pool_put_page(struct page_pool *pool, struct page *page,
 	 * page is NOT reusable when allocated when system is under
 	 * some pressure. (page_is_pfmemalloc)
 	 */
-	if (likely(page_ref_count(page) == 1 && !page_is_pfmemalloc(page))) {
-		/* Read barrier done in page_ref_count / READ_ONCE */
+	if (likely(netmem_ref_count(nmem) == 1 &&
+		   !netmem_is_pfmemalloc(nmem))) {
+		/* Read barrier done in netmem_ref_count / READ_ONCE */
 
 		if (pool->p.flags & PP_FLAG_DMA_SYNC_DEV)
-			page_pool_dma_sync_for_device(pool, page,
+			page_pool_dma_sync_for_device(pool, netmem_page(nmem),
 						      dma_sync_size);
 
 		if (allow_direct && in_serving_softirq() &&
-		    page_pool_recycle_in_cache(page, pool))
+		    page_pool_recycle_in_cache(netmem_page(nmem), pool))
 			return NULL;
 
 		/* Page found as candidate for recycling */
-		return page;
+		return nmem;
 	}
 	/* Fallback/non-XDP mode: API user have elevated refcnt.
 	 *
@@ -599,13 +600,21 @@ __page_pool_put_page(struct page_pool *pool, struct page *page,
 	 * will be invoking put_page.
 	 */
 	recycle_stat_inc(pool, released_refcnt);
-	/* Do not replace this with page_pool_return_page() */
-	page_pool_release_page(pool, page);
-	put_page(page);
+	/* Do not replace this with page_pool_return_netmem() */
+	page_pool_release_netmem(pool, nmem);
+	netmem_put(nmem);
 
 	return NULL;
 }
 
+static __always_inline struct page *
+__page_pool_put_page(struct page_pool *pool, struct page *page,
+		     unsigned int dma_sync_size, bool allow_direct)
+{
+	return netmem_page(__page_pool_put_netmem(pool, page_netmem(page),
+						dma_sync_size, allow_direct));
+}
+
 void page_pool_put_defragged_page(struct page_pool *pool, struct page *page,
 				  unsigned int dma_sync_size, bool allow_direct)
 {
-- 
2.35.1

