Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83011362BCA
	for <lists+netdev@lfdr.de>; Sat, 17 Apr 2021 01:08:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234973AbhDPXIy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 19:08:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233979AbhDPXIw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Apr 2021 19:08:52 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28BE1C061574;
        Fri, 16 Apr 2021 16:08:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=7RQQOKlZfptY8lQfv4l5MN8bW99nIhpZAUjYQWKjbHY=; b=YmfVnEk3XiuEP8jmPep/KMKTCm
        FCer4kctEbk/+GNHuBZ8YFNrdKU44xlcl41J+bNFEc53pi74cE5/BLRbsjHC4f8PKiEVIVwlUAR7t
        Z55+HNT/99N2xVNKwp+BxJDdxbFavbZStT6ml+LiqeSScnyJEGjUY1qv3vZy9XpWik8pDr0R3u9mr
        YZpRlXaZY6zK/e2aevHlOS8hCwxYF9T5hfqXwKOxLAXe4vi1AER+8AHlbktawk4qufHp5LqztQe62
        fJGCts2hlsjYoXQcLvgSA+p/Z2uMF0IYb8xmYDmqAjunEiQdpXqkeM7qmy56jDoYHdcHnWv1GagYl
        bqoyQWlQ==;
Received: from willy by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lXXYn-00AZOP-Kg; Fri, 16 Apr 2021 23:07:43 +0000
From:   "Matthew Wilcox (Oracle)" <willy@infradead.org>
To:     brouer@redhat.com
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        netdev@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linux-mips@vger.kernel.org,
        ilias.apalodimas@linaro.org, mcroce@linux.microsoft.com,
        grygorii.strashko@ti.com, arnd@kernel.org, hch@lst.de,
        linux-snps-arc@lists.infradead.org, mhocko@kernel.org,
        mgorman@suse.de
Subject: [PATCH 2/2] mm: Indicate pfmemalloc pages in compound_head
Date:   Sat, 17 Apr 2021 00:07:24 +0100
Message-Id: <20210416230724.2519198-3-willy@infradead.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210416230724.2519198-1-willy@infradead.org>
References: <20210416230724.2519198-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The net page_pool wants to use a magic value to identify page pool pages.
The best place to put it is in the first word where it can be clearly a
non-pointer value.  That means shifting dma_addr up to alias with ->index,
which means we need to find another way to indicate page_is_pfmemalloc().
Since page_pool doesn't want to set its magic value on pages which are
pfmemalloc, we can use bit 1 of compound_head to indicate that the page
came from the memory reserves.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 include/linux/mm.h       | 12 +++++++-----
 include/linux/mm_types.h |  7 +++----
 2 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 8ba434287387..44eab3f6d5ae 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1629,10 +1629,12 @@ struct address_space *page_mapping_file(struct page *page);
 static inline bool page_is_pfmemalloc(const struct page *page)
 {
 	/*
-	 * Page index cannot be this large so this must be
-	 * a pfmemalloc page.
+	 * This is not a tail page; compound_head of a head page is unused
+	 * at return from the page allocator, and will be overwritten
+	 * by callers who do not care whether the page came from the
+	 * reserves.
 	 */
-	return page->index == -1UL;
+	return page->compound_head & 2;
 }
 
 /*
@@ -1641,12 +1643,12 @@ static inline bool page_is_pfmemalloc(const struct page *page)
  */
 static inline void set_page_pfmemalloc(struct page *page)
 {
-	page->index = -1UL;
+	page->compound_head = 2;
 }
 
 static inline void clear_page_pfmemalloc(struct page *page)
 {
-	page->index = 0;
+	page->compound_head = 0;
 }
 
 /*
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 5aacc1c10a45..39f7163dcace 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -96,10 +96,9 @@ struct page {
 			unsigned long private;
 		};
 		struct {	/* page_pool used by netstack */
-			/**
-			 * @dma_addr: might require a 64-bit value on
-			 * 32-bit architectures.
-			 */
+			unsigned long pp_magic;
+			unsigned long xmi;
+			unsigned long _pp_mapping_pad;
 			unsigned long dma_addr[2];
 		};
 		struct {	/* slab, slob and slub */
-- 
2.30.2

