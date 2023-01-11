Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4ACB36652B8
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 05:22:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230471AbjAKEW3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 23:22:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229986AbjAKEWK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 23:22:10 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47EDBDF62
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 20:22:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=Sd/TXFITrHs9oBCigPbZAQGp64qBzBR18nRKYWdlGyA=; b=uodsYMsVSwkp3eHv0O/ZIrmIzF
        zqTlnoaGCM0c2hfy51wGkgmonqy04JlvYKGpEroBQ75AKzircoAGKR634BqCnQBzPz0VK2fpi4FN2
        UUVC84sW6Pd8BRNV2lecki7A+HzPpTH2tkHaXc53cr5AbuWWVOPGpdCWL1FImfAp/JkbfVZBt8Q0/
        6hRzfuO3GyAX5CQGIG4tLPs58rf1YTnUoo0pJ5hVjN+y6vgOwKg+wDw0/ZY+jMIzbRDhjTIwdir3W
        +aJdE3H+Ma/idTUudjtBbxzYr7SiPmbFoPqjbl1FgVNQbq0tXO9OHGH6IUtgz+b0rxA4fgzsISoPn
        4YRc3S0w==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pFSd0-003nyu-1L; Wed, 11 Jan 2023 04:22:18 +0000
From:   "Matthew Wilcox (Oracle)" <willy@infradead.org>
To:     Jesper Dangaard Brouer <hawk@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        netdev@vger.kernel.org, linux-mm@kvack.org,
        Shakeel Butt <shakeelb@google.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>
Subject: [PATCH v3 21/26] mm: Remove page pool members from struct page
Date:   Wed, 11 Jan 2023 04:22:09 +0000
Message-Id: <20230111042214.907030-22-willy@infradead.org>
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

These are now split out into their own netmem struct.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>
Reviewed-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
---
 include/linux/mm_types.h | 22 ----------------------
 include/net/page_pool.h  |  4 ----
 2 files changed, 26 deletions(-)

diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 65b912ba97ef..de545f6cca3c 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -116,28 +116,6 @@ struct page {
 			 */
 			unsigned long private;
 		};
-		struct {	/* page_pool used by netstack */
-			/**
-			 * @pp_magic: magic value to avoid recycling non
-			 * page_pool allocated pages.
-			 */
-			unsigned long pp_magic;
-			struct page_pool *pp;
-			unsigned long _pp_mapping_pad;
-			unsigned long dma_addr;
-			union {
-				/**
-				 * dma_addr_upper: might require a 64-bit
-				 * value on 32-bit architectures.
-				 */
-				unsigned long dma_addr_upper;
-				/**
-				 * For frag page support, not supported in
-				 * 32-bit architectures with 64-bit DMA.
-				 */
-				atomic_long_t pp_frag_count;
-			};
-		};
 		struct {	/* Tail pages of compound page */
 			unsigned long compound_head;	/* Bit zero is set */
 
diff --git a/include/net/page_pool.h b/include/net/page_pool.h
index 5e5030f5bbb4..2f0cd018b8f2 100644
--- a/include/net/page_pool.h
+++ b/include/net/page_pool.h
@@ -86,11 +86,7 @@ struct netmem {
 	static_assert(offsetof(struct page, pg) == offsetof(struct netmem, nm))
 NETMEM_MATCH(flags, flags);
 NETMEM_MATCH(lru, pp_magic);
-NETMEM_MATCH(pp, pp);
 NETMEM_MATCH(mapping, _pp_mapping_pad);
-NETMEM_MATCH(dma_addr, dma_addr);
-NETMEM_MATCH(dma_addr_upper, dma_addr_upper);
-NETMEM_MATCH(pp_frag_count, pp_frag_count);
 NETMEM_MATCH(_mapcount, _mapcount);
 NETMEM_MATCH(_refcount, _refcount);
 #undef NETMEM_MATCH
-- 
2.35.1

