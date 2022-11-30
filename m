Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A14C063E318
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 23:08:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229796AbiK3WIS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 17:08:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229759AbiK3WIH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 17:08:07 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 672225FB88
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 14:08:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=6uhBgyX+WOyze+nX1i+x8P3OR4HsIe/Xfex6UDdj364=; b=q3oxrqh0vGrpyiYKfQtxT6VSfJ
        8RSEUc1UTMpje9rAnyi5OwG5k/ihjmqanRqqqx2ltL/UZOw9qwiGYieZF1aq0PpqK/xIubDs+iMtS
        KjqD24rMb7tDwGWSk8IuQ3QFJhbG44j3XhyL/KH13j/sEYrox0SHG9TCJ3sAt9TB0H65At7xEsGAs
        7hrjfSXADqa2NcG6KMRLfJC3VvyWa7XH6SElXVfZ04Ctck2jtZJcGhN6iYgX/rHN0pHfF1Z56I5ip
        Y3aZOF1PoC8PsiSvRLsc3aw9ay/3FCvUsfdNfgab85nW4hVhJMxKrsazqry4kaeTHlWta5Me5OCJs
        uHwPIN2w==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1p0VFN-00FLVD-2m; Wed, 30 Nov 2022 22:08:05 +0000
From:   "Matthew Wilcox (Oracle)" <willy@infradead.org>
To:     Jesper Dangaard Brouer <hawk@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        netdev@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH 06/24] page_pool: Convert page_pool_return_page() to page_pool_return_netmem()
Date:   Wed, 30 Nov 2022 22:07:45 +0000
Message-Id: <20221130220803.3657490-7-willy@infradead.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20221130220803.3657490-1-willy@infradead.org>
References: <20221130220803.3657490-1-willy@infradead.org>
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

Removes a call to compound_head(), saving 464 bytes of kernel text
as page_pool_return_page() is inlined seven times.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 net/core/page_pool.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index 4e985502c569..b606952773a6 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -220,7 +220,13 @@ struct page_pool *page_pool_create(const struct page_pool_params *params)
 }
 EXPORT_SYMBOL(page_pool_create);
 
-static void page_pool_return_page(struct page_pool *pool, struct page *page);
+static void page_pool_return_netmem(struct page_pool *pool, struct netmem *nm);
+
+static inline
+void page_pool_return_page(struct page_pool *pool, struct page *page)
+{
+	page_pool_return_netmem(pool, page_netmem(page));
+}
 
 noinline
 static struct page *page_pool_refill_alloc_cache(struct page_pool *pool)
@@ -499,11 +505,11 @@ void page_pool_release_netmem(struct page_pool *pool, struct netmem *nmem)
 EXPORT_SYMBOL(page_pool_release_netmem);
 
 /* Return a page to the page allocator, cleaning up our state */
-static void page_pool_return_page(struct page_pool *pool, struct page *page)
+static void page_pool_return_netmem(struct page_pool *pool, struct netmem *nmem)
 {
-	page_pool_release_page(pool, page);
+	page_pool_release_netmem(pool, nmem);
 
-	put_page(page);
+	netmem_put(nmem);
 	/* An optimization would be to call __free_pages(page, pool->p.order)
 	 * knowing page is not part of page-cache (thus avoiding a
 	 * __page_cache_release() call).
-- 
2.35.1

