Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DF0065F613
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 22:47:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235993AbjAEVq6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 16:46:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235955AbjAEVqe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 16:46:34 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59184676DC
        for <netdev@vger.kernel.org>; Thu,  5 Jan 2023 13:46:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=H0WxbnPFe1KwSIjWT4wmoPQAd35t/aj4S8nLWveXfxg=; b=OK6S/uxIVk+67IWWhtmPrP3Q2Z
        WyvKA4Bp/2LYMKs1FgePJYKdVwXc7MsaG2jV52fI4uQFIZd/s4+Vorl1DgyWTf/B8Keq3Km2Ys/Oj
        snwvtgYaWZME5DwCGucVWI9hgKqSKmnrD4PeGm0UYQ58jxMF9qCw5PtlPTopEWoUqVk7LFLl0NwCr
        U77/CCd+eJ3vwfW7uoEs4BzhQJIBSInd1EGihYp0d/GOjsbL9TBcufAfBmbPPOMHrmWiC7jSGJ1+O
        OnoQaRy42+GwDfjrXkyoT4aT4kyVd8NfZ2DYCtc2scUId6QD4f3deEgxRMIsvVfB343ZPmkcQ7Zvc
        VPXTdU1g==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pDY4I-00GWnh-IT; Thu, 05 Jan 2023 21:46:34 +0000
From:   "Matthew Wilcox (Oracle)" <willy@infradead.org>
To:     Jesper Dangaard Brouer <hawk@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        netdev@vger.kernel.org, linux-mm@kvack.org,
        Shakeel Butt <shakeelb@google.com>
Subject: [PATCH v2 14/24] page_pool: Convert page_pool_recycle_in_cache() to netmem
Date:   Thu,  5 Jan 2023 21:46:21 +0000
Message-Id: <20230105214631.3939268-15-willy@infradead.org>
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

Removes a few casts.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 net/core/page_pool.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index 3fa03baa80ee..b925a4dcb09b 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -538,7 +538,7 @@ static bool page_pool_recycle_in_ring(struct page_pool *pool,
  *
  * Caller must provide appropriate safe context.
  */
-static bool page_pool_recycle_in_cache(struct page *page,
+static bool page_pool_recycle_in_cache(struct netmem *nmem,
 				       struct page_pool *pool)
 {
 	if (unlikely(pool->alloc.count == PP_ALLOC_CACHE_SIZE)) {
@@ -547,7 +547,7 @@ static bool page_pool_recycle_in_cache(struct page *page,
 	}
 
 	/* Caller MUST have verified/know (page_ref_count(page) == 1) */
-	pool->alloc.cache[pool->alloc.count++] = page_netmem(page);
+	pool->alloc.cache[pool->alloc.count++] = nmem;
 	recycle_stat_inc(pool, cached);
 	return true;
 }
@@ -580,7 +580,7 @@ __page_pool_put_netmem(struct page_pool *pool, struct netmem *nmem,
 						      dma_sync_size);
 
 		if (allow_direct && in_serving_softirq() &&
-		    page_pool_recycle_in_cache(netmem_page(nmem), pool))
+		    page_pool_recycle_in_cache(nmem, pool))
 			return NULL;
 
 		/* Page found as candidate for recycling */
-- 
2.35.1

