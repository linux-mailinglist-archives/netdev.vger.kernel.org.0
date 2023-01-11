Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 000126652B7
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 05:22:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235240AbjAKEW0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 23:22:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231303AbjAKEWK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 23:22:10 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45A5565EC
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 20:22:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=OBSzJ4w2B3aAKm7QVu3HQC5r9WPsQ9tzpI4Tb+ORw1s=; b=apyePiHKvq7zkmyHZHbTbkIw08
        zviH/7IF8Gu1CbA8dLQus5zZBliFQeGyNSnZrXlbNolxI7/5e62h+9aMzcG7EsPpOX7JHHjc0NVGd
        PaeT2MKZ9IuVQZFV/KChBa4pRZUvBuL0OM4XFJoo2ali4CNO+yeohlS8ctbVEexcA68hcyzU1xUM2
        QxeVzRC5R+t70nhfwwxT3pikwvstwykKVGItH9qC5WrXYfLrNsCrEGxgdUc56E3JrB/TVoSCW5UEU
        LT/f6JregHr6grPzcjNbj3smDAs+cp9shiepYEzghoacuOWVbicHqfSU20TErjXAE5zyekug1FmPn
        FlyTpmfw==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pFScz-003nyc-Lx; Wed, 11 Jan 2023 04:22:17 +0000
From:   "Matthew Wilcox (Oracle)" <willy@infradead.org>
To:     Jesper Dangaard Brouer <hawk@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        netdev@vger.kernel.org, linux-mm@kvack.org,
        Shakeel Butt <shakeelb@google.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>
Subject: [PATCH v3 18/26] page_pool: Allow page_pool_recycle_direct() to take a netmem or a page
Date:   Wed, 11 Jan 2023 04:22:06 +0000
Message-Id: <20230111042214.907030-19-willy@infradead.org>
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

With no better name for a variant of page_pool_recycle_direct() which
takes a netmem instead of a page, use _Generic() to allow it to take
either a page or a netmem argument.  It's a bit ugly, but maybe not
the worst alternative?

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
---
 include/net/page_pool.h | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/include/net/page_pool.h b/include/net/page_pool.h
index e205eaed21a5..64ac397dcd9f 100644
--- a/include/net/page_pool.h
+++ b/include/net/page_pool.h
@@ -482,12 +482,22 @@ static inline void page_pool_put_full_page(struct page_pool *pool,
 }
 
 /* Same as above but the caller must guarantee safe context. e.g NAPI */
-static inline void page_pool_recycle_direct(struct page_pool *pool,
+static inline void __page_pool_recycle_direct(struct page_pool *pool,
+					    struct netmem *nmem)
+{
+	page_pool_put_full_netmem(pool, nmem, true);
+}
+
+static inline void __page_pool_recycle_page_direct(struct page_pool *pool,
 					    struct page *page)
 {
-	page_pool_put_full_page(pool, page, true);
+	page_pool_put_full_netmem(pool, page_netmem(page), true);
 }
 
+#define page_pool_recycle_direct(pool, mem)	_Generic((mem),		\
+	struct netmem *: __page_pool_recycle_direct(pool, (struct netmem *)mem),		\
+	struct page *:	 __page_pool_recycle_page_direct(pool, (struct page *)mem))
+
 #define PAGE_POOL_DMA_USE_PP_FRAG_COUNT	\
 		(sizeof(dma_addr_t) > sizeof(unsigned long))
 
-- 
2.35.1

