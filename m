Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDCDD6652C8
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 05:23:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230247AbjAKEX3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 23:23:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233245AbjAKEWu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 23:22:50 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 113E513D1C
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 20:22:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=oJXlJV+xhbtSVawf+Q+5NVB7QM515lQScfXBhApxCL8=; b=rXlLddMW1WaOxYEqGX51ttgdPu
        NkyrU0uI1GkRHbtzFkqu/yrvhq81Yd+VFFuPTUs+nLug6/DlUlEh5pObp4GR4SZ3wcArtOicihz0J
        1n8gMsg2B9xcVfnJIPIFnwM0zd7RGQ60pDHj9Eve2PNhiDFfnMShzDvNFOLC20ngWB21qzy/sS3Bm
        DFqWgBnM/vhhiryHYjNPewy45XLCOjejxOsEJ/8JurwWk3b2+d5tFrYXZDJGP0qRsbGdeizb0xZzL
        rFGp+5mRSh4K/R6oy6JF2coujVkTVal2S6qdtma1bAMLu2xMbWM0ZOah7W5RoeVxFRES6pDDLJ9kT
        uwsmNuxw==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pFScy-003nxy-Sc; Wed, 11 Jan 2023 04:22:16 +0000
From:   "Matthew Wilcox (Oracle)" <willy@infradead.org>
To:     Jesper Dangaard Brouer <hawk@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        netdev@vger.kernel.org, linux-mm@kvack.org,
        Shakeel Butt <shakeelb@google.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>
Subject: [PATCH v3 09/26] page_pool: Convert page_pool_defrag_page() to page_pool_defrag_netmem()
Date:   Wed, 11 Jan 2023 04:21:57 +0000
Message-Id: <20230111042214.907030-10-willy@infradead.org>
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

Add a page_pool_defrag_page() wrapper.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>
Reviewed-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
---
 include/net/page_pool.h | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/include/net/page_pool.h b/include/net/page_pool.h
index 583c13f6f2ab..72e241ebed0a 100644
--- a/include/net/page_pool.h
+++ b/include/net/page_pool.h
@@ -394,7 +394,7 @@ static inline void page_pool_fragment_page(struct page *page, long nr)
 	atomic_long_set(&page->pp_frag_count, nr);
 }
 
-static inline long page_pool_defrag_page(struct page *page, long nr)
+static inline long page_pool_defrag_netmem(struct netmem *nmem, long nr)
 {
 	long ret;
 
@@ -407,14 +407,20 @@ static inline long page_pool_defrag_page(struct page *page, long nr)
 	 * especially when dealing with a page that may be partitioned
 	 * into only 2 or 3 pieces.
 	 */
-	if (atomic_long_read(&page->pp_frag_count) == nr)
+	if (atomic_long_read(&nmem->pp_frag_count) == nr)
 		return 0;
 
-	ret = atomic_long_sub_return(nr, &page->pp_frag_count);
+	ret = atomic_long_sub_return(nr, &nmem->pp_frag_count);
 	WARN_ON(ret < 0);
 	return ret;
 }
 
+/* Compat, remove when all users gone */
+static inline long page_pool_defrag_page(struct page *page, long nr)
+{
+	return page_pool_defrag_netmem(page_netmem(page), nr);
+}
+
 static inline bool page_pool_is_last_frag(struct page_pool *pool,
 					  struct page *page)
 {
-- 
2.35.1

