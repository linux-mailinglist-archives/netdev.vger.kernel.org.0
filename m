Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61C5363E324
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 23:09:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229787AbiK3WJT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 17:09:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229820AbiK3WIu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 17:08:50 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6857C950CA
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 14:08:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=XdUZ+/B1a8lpS36cSldYYXGLY2sJggnamDfVktxibus=; b=wSYzYd+gcAS0OyS39Pteb8Kmi7
        0XR76OvpCj2XroqfT5bGk8qgskXN/+XYcI+snuoGPopc918i9YIxBiy95MS6NKqUGGwo+w2bVW2lR
        g6E7aD8WyfLOKe2QGKwQikLGUK4/Al4TSbWJdxZV8Z6NQX9Miu+VKoUVethIgQu6iYBY0fpa8QnEy
        jLQiavCTSra4ppZlE9kKr2uoxiLh93U3CGwQkmTGUsbiws+QXN4kdOLJFyfoyYh0vLg1lxu+YN0/K
        S3BlZLd5JDgH6dIKHk4/ReOWDg/ji7C9+oSF8uK3oRyclV1IkoZDVvOxgVqz4AjpS1+Kb1/Mia4F6
        s5N5sNDw==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1p0VFM-00FLV2-Qa; Wed, 30 Nov 2022 22:08:04 +0000
From:   "Matthew Wilcox (Oracle)" <willy@infradead.org>
To:     Jesper Dangaard Brouer <hawk@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        netdev@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH 03/24] page_pool: Add netmem_set_dma_addr() and netmem_get_dma_addr()
Date:   Wed, 30 Nov 2022 22:07:42 +0000
Message-Id: <20221130220803.3657490-4-willy@infradead.org>
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

Turn page_pool_set_dma_addr() and page_pool_get_dma_addr() into
wrappers.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 include/net/page_pool.h | 22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/include/net/page_pool.h b/include/net/page_pool.h
index 0ce20b95290b..a68746a5b99c 100644
--- a/include/net/page_pool.h
+++ b/include/net/page_pool.h
@@ -427,21 +427,31 @@ static inline void page_pool_recycle_direct(struct page_pool *pool,
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

