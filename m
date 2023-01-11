Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1B986652CA
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 05:24:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235802AbjAKEYa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 23:24:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235551AbjAKEXS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 23:23:18 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D727213DEE
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 20:22:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=cNwP0/WvOKg0Wgjxh7GnXV1CpjoOIUWMfQYwPvXk4mY=; b=geBpLgOanato67yHa3PwwMr+ps
        J0i+CTTY7BVztaFUBdnUJY794WUJrkIihg+9U1s8Fno1dzuBOmjnkGMtnElTWov/1Owkx3h4pPDmC
        7oRwKAxWj8vk0tBCecA+0Lt6LtDOI+MzEKIyJNvqWdQrjboBGe9rbZ6gax3F3GhxUij1ew+mEspBO
        e7RyNArQeoVnFrkKTa0LAOyMuRDZ6DqlBrtPiMvbIB+FVkEyv1tC2uXzIn2im7Bg2pY74ayVXnyrj
        V8ki2aGjasVV7gjl1jiEJtrG97Ahy2XxwdNyjrRceRETGqiM0s6wQqyaSTmyz2EzDf/K+kWECVKr4
        lQlaDrAA==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pFScy-003nxk-AX; Wed, 11 Jan 2023 04:22:16 +0000
From:   "Matthew Wilcox (Oracle)" <willy@infradead.org>
To:     Jesper Dangaard Brouer <hawk@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        netdev@vger.kernel.org, linux-mm@kvack.org,
        Shakeel Butt <shakeelb@google.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>
Subject: [PATCH v3 02/26] netmem: Add utility functions
Date:   Wed, 11 Jan 2023 04:21:50 +0000
Message-Id: <20230111042214.907030-3-willy@infradead.org>
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

netmem_page() is defined this way to preserve constness.  page_netmem()
doesn't call compound_head() because netmem users always use the head
page; it does include a debugging assert to check that it's true.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>
Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
---
 include/net/page_pool.h | 59 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 59 insertions(+)

diff --git a/include/net/page_pool.h b/include/net/page_pool.h
index cbea4df54918..414907e67ff6 100644
--- a/include/net/page_pool.h
+++ b/include/net/page_pool.h
@@ -96,6 +96,65 @@ NETMEM_MATCH(_refcount, _refcount);
 #undef NETMEM_MATCH
 static_assert(sizeof(struct netmem) <= sizeof(struct page));
 
+#define netmem_page(nmem) (_Generic((nmem),				\
+	const struct netmem *:	(const struct page *)nmem,		\
+	struct netmem *:	(struct page *)nmem))
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

