Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97D3965F623
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 22:47:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236002AbjAEVrR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 16:47:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235998AbjAEVqg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 16:46:36 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CE01676F6
        for <netdev@vger.kernel.org>; Thu,  5 Jan 2023 13:46:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=W4vmcDs403XfI6fIMo3T6IvLzSI+XWgXJovz62XtHH4=; b=n/jZKMKK3aiij1j6pwIiyMsZPm
        T0LjJu2/hgZfcGGpORq5I3fkh6vjf2ZKIx0yDWVk8CTcXUTGPUYQ9qnemDEcqsErYirn5x9Xl9B4y
        cqHpI5wfN0H8tp6hqSvs4TKCHnOp59S59dziMWbcx0P9dExsK85AS5+rsPL5SJ76B7f8WMQAvMi5u
        aXfld+Pha+MGc5RD9BgmOfvMgFJ3KmAyX1lO0PrY/Hgu+nKUEunqtWbe+OEj8g9vfBHpmbIBWHpHQ
        TscltBITtNKX7ER8xSJ2WOJ4odicjBxlP/k2jhN+wor/+3/wDTQ6hZBalby9WbVcCBMfqpqq73dY3
        7mhXMXwQ==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pDY4H-00GWmz-FE; Thu, 05 Jan 2023 21:46:33 +0000
From:   "Matthew Wilcox (Oracle)" <willy@infradead.org>
To:     Jesper Dangaard Brouer <hawk@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        netdev@vger.kernel.org, linux-mm@kvack.org,
        Shakeel Butt <shakeelb@google.com>
Subject: [PATCH v2 03/24] page_pool: Add netmem_set_dma_addr() and netmem_get_dma_addr()
Date:   Thu,  5 Jan 2023 21:46:10 +0000
Message-Id: <20230105214631.3939268-4-willy@infradead.org>
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

Turn page_pool_set_dma_addr() and page_pool_get_dma_addr() into
wrappers.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 include/net/page_pool.h | 22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/include/net/page_pool.h b/include/net/page_pool.h
index 84b4ea8af015..196b585763d9 100644
--- a/include/net/page_pool.h
+++ b/include/net/page_pool.h
@@ -449,21 +449,31 @@ static inline void page_pool_recycle_direct(struct page_pool *pool,
 #define PAGE_POOL_DMA_USE_PP_FRAG_COUNT	\
 		(sizeof(dma_addr_t) > sizeof(unsigned long))
 
-static inline dma_addr_t page_pool_get_dma_addr(struct page *page)
+static inline dma_addr_t netmem_get_dma_addr(struct netmem *nmem)
 {
-	dma_addr_t ret = page->dma_addr;
+	dma_addr_t ret = nmem->dma_addr;
 
 	if (PAGE_POOL_DMA_USE_PP_FRAG_COUNT)
-		ret |= (dma_addr_t)page->dma_addr_upper << 16 << 16;
+		ret |= (dma_addr_t)nmem->dma_addr_upper << 16 << 16;
 
 	return ret;
 }
 
-static inline void page_pool_set_dma_addr(struct page *page, dma_addr_t addr)
+static inline dma_addr_t page_pool_get_dma_addr(struct page *page)
+{
+	return netmem_get_dma_addr(page_netmem(page));
+}
+
+static inline void netmem_set_dma_addr(struct netmem *nmem, dma_addr_t addr)
 {
-	page->dma_addr = addr;
+	nmem->dma_addr = addr;
 	if (PAGE_POOL_DMA_USE_PP_FRAG_COUNT)
-		page->dma_addr_upper = upper_32_bits(addr);
+		nmem->dma_addr_upper = upper_32_bits(addr);
+}
+
+static inline void page_pool_set_dma_addr(struct page *page, dma_addr_t addr)
+{
+	netmem_set_dma_addr(page_netmem(page), addr);
 }
 
 static inline bool is_page_pool_compiled_in(void)
-- 
2.35.1

