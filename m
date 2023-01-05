Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4461565F624
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 22:47:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236023AbjAEVrU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 16:47:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235717AbjAEVqh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 16:46:37 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8A2C676C6
        for <netdev@vger.kernel.org>; Thu,  5 Jan 2023 13:46:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=m2s/8OmWFp4OOxmIx+VnG8M6Dr4CWRucDCtkklQeocI=; b=YDs+Z/ZMgVKmuPMKqkqEJsty1B
        A1FgDypFwF+s8OqORQz2gfE0byyC6ttEJOSy/A3Brovfffu+CCpHUC2z9ntVMzE1kI2kv4kqlRrTh
        Y1l0H6sdJzcxuY+NldXWw/oOkzkIrS2qHdRDbK6UORmUKiAmDCCHJcrO+qvQ0eDjZqBaBBll20qea
        eCv0L+rQKZt3bLtTztxVMECB6tO55V4mWnQDPLzwsGevmrTXaBNBH4rYFtYtlEimLEQgTTnrh0jw1
        rFEQL5ZTwGzcOSa3O+IVFSOuR2tow2xdkB9HuW17LZaslvuFrzB/qVMqTBmSy8VYYFuYq6QUUUzaE
        BfaV415A==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pDY4H-00GWnB-Vh; Thu, 05 Jan 2023 21:46:34 +0000
From:   "Matthew Wilcox (Oracle)" <willy@infradead.org>
To:     Jesper Dangaard Brouer <hawk@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        netdev@vger.kernel.org, linux-mm@kvack.org,
        Shakeel Butt <shakeelb@google.com>
Subject: [PATCH v2 09/24] page_pool: Convert page_pool_defrag_page() to page_pool_defrag_netmem()
Date:   Thu,  5 Jan 2023 21:46:16 +0000
Message-Id: <20230105214631.3939268-10-willy@infradead.org>
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

Add a page_pool_defrag_page() wrapper.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 include/net/page_pool.h | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/include/net/page_pool.h b/include/net/page_pool.h
index 63aa530922de..8fe494166427 100644
--- a/include/net/page_pool.h
+++ b/include/net/page_pool.h
@@ -393,7 +393,7 @@ static inline void page_pool_fragment_page(struct page *page, long nr)
 	atomic_long_set(&page->pp_frag_count, nr);
 }
 
-static inline long page_pool_defrag_page(struct page *page, long nr)
+static inline long page_pool_defrag_netmem(struct netmem *nmem, long nr)
 {
 	long ret;
 
@@ -406,14 +406,19 @@ static inline long page_pool_defrag_page(struct page *page, long nr)
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

