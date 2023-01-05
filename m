Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D94C665F620
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 22:47:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235982AbjAEVrN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 16:47:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235991AbjAEVqg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 16:46:36 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F384676E4
        for <netdev@vger.kernel.org>; Thu,  5 Jan 2023 13:46:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=GWMUnP6ZrRdKj2hFTaHbCRwTRDJYekvQZX3sCfTMPHs=; b=ZtCJTQjorvaZ8yTcaNI0TKtm8W
        X1+w3qQkODaIolnPp096kMuSh0atNQoN1z+vkL2A47IAyHaHv4O9LdhsoPVFHa/KNdq+otClH+IJ/
        3eLcFE88KlgfKzZ54h4aVravLNNfu4Uu54ZZcTGtYCtKN0ZYb0MMVWVYqnNj8NROVfSlZn2XQfFgK
        iP9bqK5zjmZ69Fjvp7w1LnKCXu7V2S0kKDruvuBmTtG5zwTuK/W3BjdTk49iubiYKAj+VtxFZafR+
        wEA8nkCiZ1XOaWg2j4rdA9IFIm0MlnmIbgTlPu3n2opR+u1rQt48gQ9x+Sk+LwfXYXJS3YC5DKssI
        KLMK974Q==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pDY4H-00GWmx-D2; Thu, 05 Jan 2023 21:46:33 +0000
From:   "Matthew Wilcox (Oracle)" <willy@infradead.org>
To:     Jesper Dangaard Brouer <hawk@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        netdev@vger.kernel.org, linux-mm@kvack.org,
        Shakeel Butt <shakeelb@google.com>
Subject: [PATCH v2 02/24] netmem: Add utility functions
Date:   Thu,  5 Jan 2023 21:46:09 +0000
Message-Id: <20230105214631.3939268-3-willy@infradead.org>
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

netmem_page() is defined this way to preserve constness.  page_netmem()
doesn't call compound_head() because netmem users always use the head
page; it does include a debugging assert to check that it's true.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 include/net/page_pool.h | 59 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 59 insertions(+)

diff --git a/include/net/page_pool.h b/include/net/page_pool.h
index cbea4df54918..84b4ea8af015 100644
--- a/include/net/page_pool.h
+++ b/include/net/page_pool.h
@@ -96,6 +96,65 @@ NETMEM_MATCH(_refcount, _refcount);
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
+static inline void *netmem_to_virt(const struct netmem *nmem)
+{
+	return page_to_virt(netmem_page(nmem));
+}
+
+static inline void *netmem_address(const struct netmem *nmem)
+{
+	return page_address(netmem_page(nmem));
+}
+
+static inline int netmem_ref_count(const struct netmem *nmem)
+{
+	return page_ref_count(netmem_page(nmem));
+}
+
+static inline void netmem_get(struct netmem *nmem)
+{
+	struct folio *folio = (struct folio *)nmem;
+
+	folio_get(folio);
+}
+
+static inline void netmem_put(struct netmem *nmem)
+{
+	struct folio *folio = (struct folio *)nmem;
+
+	folio_put(folio);
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

