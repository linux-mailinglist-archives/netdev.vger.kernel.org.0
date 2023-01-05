Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75FE365F62C
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 22:49:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235251AbjAEVtE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 16:49:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236064AbjAEVrn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 16:47:43 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21A2A69509
        for <netdev@vger.kernel.org>; Thu,  5 Jan 2023 13:46:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=6uhBgyX+WOyze+nX1i+x8P3OR4HsIe/Xfex6UDdj364=; b=v5z/fr3PVZGh697DbXoplcl2Z/
        BZG57SwPmhuMZpINsUVHfbg4HwLTZkzxCUpekfNQSflEsjNiIBTurjWjNONBZ77UiCfo5z++2YbZO
        Jd3vzyVOHp7fae4KvEtSTHMuHXm6y3+OIjuYkrYXdzRsQTsrogD6JmfC10Rq5CJ5oWOhA3lwbawhJ
        K0LqZiP37FtCFstnvEamkO/10fCCEi4mGnvYgwHkraaDlC802vgN6D5r4zaxDMC3tEkpWSYUkfXLR
        PcmDscpmvVMEfJ0R9yb5o6gJIT2s0mf6WNS8TgCdT5ILvN8N5VbL//vZ81IE4hSWYeQijoHEbmbgd
        8TyBMPLg==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pDY4H-00GWn5-NJ; Thu, 05 Jan 2023 21:46:33 +0000
From:   "Matthew Wilcox (Oracle)" <willy@infradead.org>
To:     Jesper Dangaard Brouer <hawk@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        netdev@vger.kernel.org, linux-mm@kvack.org,
        Shakeel Butt <shakeelb@google.com>
Subject: [PATCH v2 06/24] page_pool: Convert page_pool_return_page() to page_pool_return_netmem()
Date:   Thu,  5 Jan 2023 21:46:13 +0000
Message-Id: <20230105214631.3939268-7-willy@infradead.org>
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

