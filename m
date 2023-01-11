Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AC7E6652B6
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 05:22:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234935AbjAKEWW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 23:22:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231308AbjAKEWK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 23:22:10 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 480ACE0A1
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 20:22:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=kcHD+D5Tm5hJWRmWu3rBaG/FQXhUTdD3u/FWIcAC/HM=; b=TZSfhYSbRvNq1VJQ066og0F5pp
        X1lMd3WlHbOxeJFAiEO/trtpyRTh3ZGdB9Hgtjq3WB8/94sl2BycF5+iHE0TrJIXgn+9lLdB9JhVg
        Fp+viqi93tQr/z+LA97w4RjpVTd3kSsa2e1BEm6SRRHP8NlpFIK7CaD6znKzolsZ1oYneYU1ufM/b
        Jb7CoQ0TK6L4Xli+68eLdBW3MvcEta0mX/auV4z5IJ43LI7rCR6YjgZ69qqHATp7e+HTJ+fWcicLY
        rQDZqW6YH32oJu0DlVbYM7hudn6G/B3C8inqWF0lBORA4eF7/cvroaSkwf+OSzlAKUD+84TpUjNKO
        3bf7XZlQ==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pFScz-003nyW-IM; Wed, 11 Jan 2023 04:22:17 +0000
From:   "Matthew Wilcox (Oracle)" <willy@infradead.org>
To:     Jesper Dangaard Brouer <hawk@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        netdev@vger.kernel.org, linux-mm@kvack.org,
        Shakeel Butt <shakeelb@google.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>
Subject: [PATCH v3 17/26] page_pool: Convert page_pool_return_skb_page() to use netmem
Date:   Wed, 11 Jan 2023 04:22:05 +0000
Message-Id: <20230111042214.907030-18-willy@infradead.org>
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

This function accesses the pagepool members of struct page directly,
so it needs to become netmem.  Add page_pool_put_full_netmem().

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
---
 include/net/page_pool.h |  9 ++++++++-
 net/core/page_pool.c    | 13 ++++++-------
 2 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/include/net/page_pool.h b/include/net/page_pool.h
index a568d94043af..e205eaed21a5 100644
--- a/include/net/page_pool.h
+++ b/include/net/page_pool.h
@@ -468,10 +468,17 @@ static inline void page_pool_put_page(struct page_pool *pool,
 }
 
 /* Same as above but will try to sync the entire area pool->max_len */
+static inline void page_pool_put_full_netmem(struct page_pool *pool,
+		struct netmem *nmem, bool allow_direct)
+{
+	page_pool_put_netmem(pool, nmem, -1, allow_direct);
+}
+
+/* Compat, remove when all users gone */
 static inline void page_pool_put_full_page(struct page_pool *pool,
 					   struct page *page, bool allow_direct)
 {
-	page_pool_put_page(pool, page, -1, allow_direct);
+	page_pool_put_full_netmem(pool, page_netmem(page), allow_direct);
 }
 
 /* Same as above but the caller must guarantee safe context. e.g NAPI */
diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index cd469a9970e7..ddf9f2bb85f7 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -886,28 +886,27 @@ EXPORT_SYMBOL(page_pool_update_nid);
 
 bool page_pool_return_skb_page(struct page *page)
 {
+	struct netmem *nmem = page_netmem(compound_head(page));
 	struct page_pool *pp;
 
-	page = compound_head(page);
-
-	/* page->pp_magic is OR'ed with PP_SIGNATURE after the allocation
+	/* nmem->pp_magic is OR'ed with PP_SIGNATURE after the allocation
 	 * in order to preserve any existing bits, such as bit 0 for the
 	 * head page of compound page and bit 1 for pfmemalloc page, so
 	 * mask those bits for freeing side when doing below checking,
-	 * and page_is_pfmemalloc() is checked in __page_pool_put_page()
+	 * and netmem_is_pfmemalloc() is checked in __page_pool_put_netmem()
 	 * to avoid recycling the pfmemalloc page.
 	 */
-	if (unlikely((page->pp_magic & ~0x3UL) != PP_SIGNATURE))
+	if (unlikely((nmem->pp_magic & ~0x3UL) != PP_SIGNATURE))
 		return false;
 
-	pp = page->pp;
+	pp = nmem->pp;
 
 	/* Driver set this to memory recycling info. Reset it on recycle.
 	 * This will *not* work for NIC using a split-page memory model.
 	 * The page will be returned to the pool here regardless of the
 	 * 'flipped' fragment being in use or not.
 	 */
-	page_pool_put_full_page(pp, page, false);
+	page_pool_put_full_netmem(pp, nmem, false);
 
 	return true;
 }
-- 
2.35.1

