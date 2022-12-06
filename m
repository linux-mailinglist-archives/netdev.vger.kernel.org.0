Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 940DE6448DE
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 17:11:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233826AbiLFQL3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 11:11:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231669AbiLFQK7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 11:10:59 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D1992EF4F
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 08:05:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=4icAOvmrxTKchMrADp++FcHPPFRR8CrUb6dlnPoOzwg=; b=AlPNq+68y2pVteEGObEwIqxqNG
        w47ES80i4MSal/x+QtESa8ln4fY9Ig+suDfDv5o+9uPrAvZE59sKf5ujHFFhlO0LuH5ZAr/+Oz03K
        RK98ssOFJz0Fg+5abxSlTZtEnxJAYJexTTfKGgW1hs464jVX5oIDEpe/k9Ptxoo1+OQmk0K3/JmZ+
        uD3YNC3PmVgXDtVUZ/Pk9KIXLyW8Vj3AZNckV8HovmlQ6We+fV4121Y7MVK5Wrk2EPgo+lPnBbzAV
        n62kBU1xzl17809N27C/j4/q4ppdPBOeUZuCk5nH45BXuXny0SL7j79UMHJ7JNMGVU/OD0ChscirV
        Kzw93ybw==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1p2aRv-004aAm-6J; Tue, 06 Dec 2022 16:05:39 +0000
From:   "Matthew Wilcox (Oracle)" <willy@infradead.org>
To:     Jesper Dangaard Brouer <hawk@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        netdev@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH 25/26] netpool: Additional utility functions
Date:   Tue,  6 Dec 2022 16:05:36 +0000
Message-Id: <20221206160537.1092343-1-willy@infradead.org>
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

To be folded into earlier commit
---
 include/net/page_pool.h | 25 ++++++++++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)

diff --git a/include/net/page_pool.h b/include/net/page_pool.h
index 4878fe30f52c..94bad45ed8d0 100644
--- a/include/net/page_pool.h
+++ b/include/net/page_pool.h
@@ -117,16 +117,28 @@ static inline void *netmem_to_virt(const struct netmem *nmem)
 	return page_to_virt(netmem_page(nmem));
 }
 
+static inline void *netmem_address(const struct netmem *nmem)
+{
+	return page_address(netmem_page(nmem));
+}
+
 static inline int netmem_ref_count(const struct netmem *nmem)
 {
 	return page_ref_count(netmem_page(nmem));
 }
 
+static inline void netmem_get(struct netmem *nmem)
+{
+	struct folio *folio = (struct folio *)nmem;
+
+	folio_get(folio);
+}
+
 static inline void netmem_put(struct netmem *nmem)
 {
 	struct folio *folio = (struct folio *)nmem;
 
-	return folio_put(folio);
+	folio_put(folio);
 }
 
 static inline bool netmem_is_pfmemalloc(const struct netmem *nmem)
@@ -295,6 +307,11 @@ struct page_pool {
 
 struct netmem *page_pool_alloc_netmem(struct page_pool *pool, gfp_t gfp);
 
+static inline struct netmem *page_pool_dev_alloc_netmem(struct page_pool *pool)
+{
+	return page_pool_alloc_netmem(pool, GFP_ATOMIC | __GFP_NOWARN);
+}
+
 static inline
 struct page *page_pool_alloc_pages(struct page_pool *pool, gfp_t gfp)
 {
@@ -452,6 +469,12 @@ static inline void page_pool_recycle_direct(struct page_pool *pool,
 	page_pool_put_full_page(pool, page, true);
 }
 
+static inline void page_pool_recycle_netmem(struct page_pool *pool,
+					    struct netmem *nmem)
+{
+	page_pool_put_full_netmem(pool, nmem, true);
+}
+
 #define PAGE_POOL_DMA_USE_PP_FRAG_COUNT	\
 		(sizeof(dma_addr_t) > sizeof(unsigned long))
 
-- 
2.35.1

