Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A777963E322
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 23:09:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229831AbiK3WJC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 17:09:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229806AbiK3WIq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 17:08:46 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C0179456A
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 14:08:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=F5jHy32ogt9755aGfnC84dmJ1NGdPkiedk+cdsHjX5I=; b=oJ5Hn8sn07bTx1NIJJF70zKJ0P
        MbtzfSnV7CLskkfgCC+ZM52jHml8etKVxR30Ns6couZTODDzAMhwzg79Ia4zt8BOfCLODCyYSLvit
        9GDiPbAqQune1G8dF5y7Gd5eSNMxlq8UvIz2KvCn2m1ZBCy7fGWma+3TCiN/ZLIUWMek2qJP95L7/
        nt1QoKz8Hf8wiX8N7o40ZAI5dYfFR/1E/Eyd8h9KYzp5hVF13bluFV5JQDv0Ucoz5pSjl71WmMS9z
        8QXgcYJl57Lk3C+U4k1/YhelgbJV9YfNY5A3btlGtIRRfG8rxuuviQV2Haudp+cTGNsgelljBIMq1
        hxNmXCxg==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1p0VFN-00FLVN-Bg; Wed, 30 Nov 2022 22:08:05 +0000
From:   "Matthew Wilcox (Oracle)" <willy@infradead.org>
To:     Jesper Dangaard Brouer <hawk@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        netdev@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH 09/24] page_pool: Convert page_pool_defrag_page() to page_pool_defrag_netmem()
Date:   Wed, 30 Nov 2022 22:07:48 +0000
Message-Id: <20221130220803.3657490-10-willy@infradead.org>
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

Add a page_pool_defrag_page() wrapper.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 include/net/page_pool.h | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/include/net/page_pool.h b/include/net/page_pool.h
index 88eb5be77b2c..bfb77b75f333 100644
--- a/include/net/page_pool.h
+++ b/include/net/page_pool.h
@@ -371,7 +371,7 @@ static inline void page_pool_fragment_page(struct page *page, long nr)
 	atomic_long_set(&page->pp_frag_count, nr);
 }
 
-static inline long page_pool_defrag_page(struct page *page, long nr)
+static inline long page_pool_defrag_netmem(struct netmem *nmem, long nr)
 {
 	long ret;
 
@@ -384,14 +384,19 @@ static inline long page_pool_defrag_page(struct page *page, long nr)
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

