Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 725DD6652C6
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 05:23:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235542AbjAKEXE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 23:23:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231478AbjAKEWW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 23:22:22 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1505657F
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 20:22:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=I7aASeW2bakt0a8pxVeEBiqLf4GO7WCoG44w/epo15A=; b=uSu5hoIgzDuHOgIJLcq8PNEDzt
        SDNRMpkVSmukNDELlT4wmw0nN8d0STryyMwkA+yq08u3WIKobL5OUpuLgNQR0ejpOVFDPXrN+cukw
        Bm/Nic1p/cRl8RdUNGMt349f4EXBtNG00qE5v8infB+/jfzTcKycMNzKUFkFBunH3rdEgsNk+fDXK
        09RberagCyyu0kXSP+W4OOR/dNGz6yOgAXQ6bEXiuuCGMGP3GXkJpaV/AYh+XGR8iUzJ/PV2hk4kp
        JnVjwSQBBKGA46RWkMdbc4n3dEwzedYAFKtaDLtzvg7xNdGPeuc3X62IUi8mQ+3NcmmHrgxoUdwls
        NmEHsHIQ==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pFScy-003nxi-8L; Wed, 11 Jan 2023 04:22:16 +0000
From:   "Matthew Wilcox (Oracle)" <willy@infradead.org>
To:     Jesper Dangaard Brouer <hawk@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        netdev@vger.kernel.org, linux-mm@kvack.org,
        Shakeel Butt <shakeelb@google.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>
Subject: [PATCH v3 01/26] netmem: Create new type
Date:   Wed, 11 Jan 2023 04:21:49 +0000
Message-Id: <20230111042214.907030-2-willy@infradead.org>
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

As part of simplifying struct page, create a new netmem type which
mirrors the page_pool members in struct page.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>
Acked-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
---
 Documentation/networking/page_pool.rst |  5 +++
 include/net/page_pool.h                | 46 ++++++++++++++++++++++++++
 2 files changed, 51 insertions(+)

diff --git a/Documentation/networking/page_pool.rst b/Documentation/networking/page_pool.rst
index 5db8c263b0c6..2c3c81473b97 100644
--- a/Documentation/networking/page_pool.rst
+++ b/Documentation/networking/page_pool.rst
@@ -221,3 +221,8 @@ Driver unload
     /* Driver unload */
     page_pool_put_full_page(page_pool, page, false);
     xdp_rxq_info_unreg(&xdp_rxq);
+
+Functions and structures
+========================
+
+.. kernel-doc:: include/net/page_pool.h
diff --git a/include/net/page_pool.h b/include/net/page_pool.h
index 813c93499f20..cbea4df54918 100644
--- a/include/net/page_pool.h
+++ b/include/net/page_pool.h
@@ -50,6 +50,52 @@
 				 PP_FLAG_DMA_SYNC_DEV |\
 				 PP_FLAG_PAGE_FRAG)
 
+/**
+ * struct netmem - A memory allocation from a &struct page_pool.
+ * @flags: The same as the page flags.  Do not use directly.
+ * @pp_magic: Magic value to avoid recycling non page_pool allocated pages.
+ * @pp: The page pool this netmem was allocated from.
+ * @dma_addr: Call netmem_get_dma_addr() to read this value.
+ * @dma_addr_upper: Might need to be 64-bit on 32-bit architectures.
+ * @pp_frag_count: For frag page support, not supported in 32-bit
+ *   architectures with 64-bit DMA.
+ * @_mapcount: Do not access this member directly.
+ * @_refcount: Do not access this member directly.  Read it using
+ *   netmem_ref_count() and manipulate it with netmem_get() and netmem_put().
+ *
+ * This struct overlays struct page for now.  Do not modify without a
+ * good understanding of the issues.
+ */
+struct netmem {
+	unsigned long flags;
+	unsigned long pp_magic;
+	struct page_pool *pp;
+	/* private: no need to document this padding */
+	unsigned long _pp_mapping_pad;	/* aliases with folio->mapping */
+	/* public: */
+	unsigned long dma_addr;
+	union {
+		unsigned long dma_addr_upper;
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

