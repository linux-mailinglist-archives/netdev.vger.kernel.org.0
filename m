Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09F9463E327
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 23:09:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229886AbiK3WJb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 17:09:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229770AbiK3WI5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 17:08:57 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86110950DB
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 14:08:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=kUxIquH3iyCGPtE7Ts3ENPkl66ISToAZq9sMocHTp+U=; b=MW1P+4JQRYxrXbBQWHsbro+cbE
        pox2RbEoqlz7zxkanBPj3DmgtujJM77XjWt2WWtg1XkrYkEznPzKiyohNvjB4GfsPGbhezjIxmiUm
        iXpFaTFN2FC9XCmB7x7h6Jf6zvgB6NBHKvFts8Rfy68IY2asXypWBEEO//VrrB/5UVxHwRBxmr2Lm
        0JPlF3fGPA7UL1A7hggdtaogPe04YRh7du0DW1coSNHHhcddFkgZIcOIhYcMrqbwEYa/Ft/4nI9M5
        CGtYZRg3Lx4Z924s6P5l7DIX3m2Gp1UTbDIvyJytEtVGXDPvRwuYIrNRs4FYelVvhgySVFL5GL5wk
        b6AkVs1A==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1p0VFM-00FLUv-LE; Wed, 30 Nov 2022 22:08:04 +0000
From:   "Matthew Wilcox (Oracle)" <willy@infradead.org>
To:     Jesper Dangaard Brouer <hawk@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        netdev@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH 01/24] netmem: Create new type
Date:   Wed, 30 Nov 2022 22:07:40 +0000
Message-Id: <20221130220803.3657490-2-willy@infradead.org>
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

As part of simplifying struct page, create a new netmem type which
mirrors the page_pool members in struct page.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 include/net/page_pool.h | 41 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)

diff --git a/include/net/page_pool.h b/include/net/page_pool.h
index 813c93499f20..af6ff8c302a0 100644
--- a/include/net/page_pool.h
+++ b/include/net/page_pool.h
@@ -50,6 +50,47 @@
 				 PP_FLAG_DMA_SYNC_DEV |\
 				 PP_FLAG_PAGE_FRAG)
 
+/* page_pool used by netstack */
+struct netmem {
+	unsigned long flags;		/* Page flags */
+	/**
+	 * @pp_magic: magic value to avoid recycling non
+	 * page_pool allocated pages.
+	 */
+	unsigned long pp_magic;
+	struct page_pool *pp;
+	unsigned long _pp_mapping_pad;
+	unsigned long dma_addr;
+	union {
+		/**
+		 * dma_addr_upper: might require a 64-bit
+		 * value on 32-bit architectures.
+		 */
+		unsigned long dma_addr_upper;
+		/**
+		 * For frag page support, not supported in
+		 * 32-bit architectures with 64-bit DMA.
+		 */
+		atomic_long_t pp_frag_count;
+	};
+	atomic_t _mapcount;
+	atomic_t _refcount;
+};
+
+#define NETMEM_MATCH(pg, nm)						\
+	static_assert(offsetof(struct page, pg) == offsetof(struct netmem, nm))
+NETMEM_MATCH(flags, flags);
+NETMEM_MATCH(lru, pp_magic);
+NETMEM_MATCH(pp, pp);
+NETMEM_MATCH(mapping, _pp_mapping_pad);
+NETMEM_MATCH(dma_addr, dma_addr);
+NETMEM_MATCH(dma_addr_upper, dma_addr_upper);
+NETMEM_MATCH(pp_frag_count, pp_frag_count);
+NETMEM_MATCH(_mapcount, _mapcount);
+NETMEM_MATCH(_refcount, _refcount);
+#undef NETMEM_MATCH
+static_assert(sizeof(struct netmem) <= sizeof(struct page));
+
 /*
  * Fast allocation side cache array/stack
  *
-- 
2.35.1

