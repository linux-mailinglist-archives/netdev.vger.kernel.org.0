Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CAD26652C9
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 05:24:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229680AbjAKEYC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 23:24:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235504AbjAKEXD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 23:23:03 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBDAE13D64
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 20:22:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=0azbnQLE/iS8Hxok7qIg20pGmsfVsXiZRb6KS8BjIqY=; b=QqMEVI1eVM8Ds6Qm2wr6OiPby+
        0KEYFh7xMhh675MlHV84blnuHBpci3KHmGqP0UsWlt60pEIvf00zvPrMoq27p3UlcbxtnCS0DNbOG
        i6L2ELQ7Kuu1u3+P2l+IuEBmJ851mjXpTmKG5MdjdeFkQepZ3CBrV1cikM9d2RRI9Qe4biGHqR5ui
        0rPqddyAMr1BpWxQ3+8lwQtVgDo9GFrTf53Tt61u4Wy6MtKWOCsc8/QquQlyW2Vn8J3O2RCyghCFZ
        4PSHlO9nMD3pBnqXRMWcE4DADJ28gwW7rN8cq/wTFHN35hUIgFMDMYtb06KUuoMlrE44rvOjZ7RUh
        wH/NcNQw==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pFScy-003nxm-DB; Wed, 11 Jan 2023 04:22:16 +0000
From:   "Matthew Wilcox (Oracle)" <willy@infradead.org>
To:     Jesper Dangaard Brouer <hawk@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        netdev@vger.kernel.org, linux-mm@kvack.org,
        Shakeel Butt <shakeelb@google.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>
Subject: [PATCH v3 03/26] page_pool: Add netmem_set_dma_addr() and netmem_get_dma_addr()
Date:   Wed, 11 Jan 2023 04:21:51 +0000
Message-Id: <20230111042214.907030-4-willy@infradead.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20230111042214.907030-1-willy@infradead.org>
References: <20230111042214.907030-1-willy@infradead.org>
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
Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>
Reviewed-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
---
 include/net/page_pool.h | 24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

diff --git a/include/net/page_pool.h b/include/net/page_pool.h
index 414907e67ff6..ff4d11d43697 100644
--- a/include/net/page_pool.h
+++ b/include/net/page_pool.h
@@ -449,21 +449,33 @@ static inline void page_pool_recycle_direct(struct page_pool *pool,
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
+/* Compat, remove when all users gone */
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
+/* Compat, remove when all users gone */
+static inline void page_pool_set_dma_addr(struct page *page, dma_addr_t addr)
+{
+	netmem_set_dma_addr(page_netmem(page), addr);
 }
 
 static inline bool is_page_pool_compiled_in(void)
-- 
2.35.1

