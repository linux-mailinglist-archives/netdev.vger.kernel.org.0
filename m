Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6260465F61B
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 22:47:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235963AbjAEVrC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 16:47:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235964AbjAEVqe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 16:46:34 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE901676E0
        for <netdev@vger.kernel.org>; Thu,  5 Jan 2023 13:46:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=XzNLmzeaTRndPTdBRkbz1QwQlJaxQtYQ8oYGbdWHgIU=; b=u4dKmd+GIBUTWoEI1d2yL90ucO
        smpmlMFOAM9jvJ8P9o3Nra6X56WE+7Cgjh7qFCAbDGNPEZz297FCeMCIWPizsR4AxNSTzclv6vSbh
        mFWtoewljDFBlsdqYvDNXr8XR4PeyuhuMvSQR8EyAWnjpiptAZo1jwhVNFPoklDXNEkvCoOyYKXB9
        5xgcTwduMQuLQO9VFcfRKltuy27//Pac1PGuEiYSvrpn8hECnviKdW6r/YT+r+ErCAUy1Asz765C9
        AnUlTaMkaEP5HdYd1xvryUDuy5DSwwTpftrhVn41OQZbJYBDoWVCHHocqnah/5Y5qn/aOB7E1ddbx
        S+Jx4aKQ==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pDY4J-00GWoR-CI; Thu, 05 Jan 2023 21:46:35 +0000
From:   "Matthew Wilcox (Oracle)" <willy@infradead.org>
To:     Jesper Dangaard Brouer <hawk@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        netdev@vger.kernel.org, linux-mm@kvack.org,
        Shakeel Butt <shakeelb@google.com>
Subject: [PATCH v2 20/24] mm: Remove page pool members from struct page
Date:   Thu,  5 Jan 2023 21:46:27 +0000
Message-Id: <20230105214631.3939268-21-willy@infradead.org>
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

These are now split out into their own netmem struct.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 include/linux/mm_types.h | 22 ----------------------
 include/net/page_pool.h  |  4 ----
 2 files changed, 26 deletions(-)

diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 603b615f1bf3..90d91088a9d5 100644
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
index a9dae4b5f2f7..c607d67c96dc 100644
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

