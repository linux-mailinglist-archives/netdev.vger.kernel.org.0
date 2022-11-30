Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B43A63E31F
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 23:08:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229828AbiK3WIb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 17:08:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229762AbiK3WIS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 17:08:18 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1977F8DBED
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 14:08:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=Bf9QgNgl8uu84zUZAyTetZnjlw3v/IdWDtDQm/ZO4Nw=; b=qWaBxKInFy2BBK0lobKCcVwpzx
        F8KWylsxU0loegts+qKNXRjtnAu2jP7Nq///h84MtAOGqmU4IKzRVF+kUq/mW9ysHDT5soCIggufZ
        nyR6XlxKnnOKLbjP/NASbm7jwUiiJB9kzNaMa9e9O/1/L8Q/nMeQrS5s0WoosjIUBUQbJiDEwfo+9
        z2/4sve9GVWIB3yBkwj8SAbdfULtJSzat9twZa82REpw1Pw4VgaEl3/7I9KruP/m4JFqRTdOFaLvm
        opVp6T94gWOdDQuIwtom/BwaJ9ofW/bm0hbaQt8BZhbzvatjtefQZ8PstHfRTTZ5LswKgUTdrCRkk
        2+xGkxsg==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1p0VFM-00FLUz-O0; Wed, 30 Nov 2022 22:08:04 +0000
From:   "Matthew Wilcox (Oracle)" <willy@infradead.org>
To:     Jesper Dangaard Brouer <hawk@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        netdev@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH 02/24] netmem: Add utility functions
Date:   Wed, 30 Nov 2022 22:07:41 +0000
Message-Id: <20221130220803.3657490-3-willy@infradead.org>
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

netmem_page() is defined this way to preserve constness.  page_netmem()
doesn't call compound_head() because netmem users always use the head
page; it does include a debugging assert to check that it's true.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 include/net/page_pool.h | 42 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 42 insertions(+)

diff --git a/include/net/page_pool.h b/include/net/page_pool.h
index af6ff8c302a0..0ce20b95290b 100644
--- a/include/net/page_pool.h
+++ b/include/net/page_pool.h
@@ -91,6 +91,48 @@ NETMEM_MATCH(_refcount, _refcount);
 #undef NETMEM_MATCH
 static_assert(sizeof(struct netmem) <= sizeof(struct page));
 
+#define netmem_page(nmem) (_Generic((*nmem),				\
+	const struct netmem:	(const struct page *)nmem,		\
+	struct netmem:		(struct page *)nmem))
+
+static inline struct netmem *page_netmem(struct page *page)
+{
+	VM_BUG_ON_PAGE(PageTail(page), page);
+	return (struct netmem *)page;
+}
+
+static inline unsigned long netmem_pfn(const struct netmem *nmem)
+{
+	return page_to_pfn(netmem_page(nmem));
+}
+
+static inline unsigned long netmem_nid(const struct netmem *nmem)
+{
+	return page_to_nid(netmem_page(nmem));
+}
+
+static inline struct netmem *virt_to_netmem(const void *x)
+{
+	return page_netmem(virt_to_head_page(x));
+}
+
+static inline int netmem_ref_count(const struct netmem *nmem)
+{
+	return page_ref_count(netmem_page(nmem));
+}
+
+static inline void netmem_put(struct netmem *nmem)
+{
+	struct folio *folio = (struct folio *)nmem;
+
+	return folio_put(folio);
+}
+
+static inline bool netmem_is_pfmemalloc(const struct netmem *nmem)
+{
+	return nmem->pp_magic & BIT(1);
+}
+
 /*
  * Fast allocation side cache array/stack
  *
-- 
2.35.1

