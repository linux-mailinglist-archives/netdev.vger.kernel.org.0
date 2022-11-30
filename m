Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FF9E63E313
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 23:08:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229690AbiK3WIK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 17:08:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229754AbiK3WIE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 17:08:04 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8D2D53EFD
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 14:08:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=zWebMUOZHo9GaCcn2DPCoqafVDMpG7RCOZ9SaEUIFhI=; b=Mxgpw5JuDdm3aUTpbihdlCNz7B
        Orno3S0npaZteP2tCsC3vn+2XJrW5EWfw3qXyjmVDJvCs9w/gQ9HLK0TOYNJYjMwCn8+qSwvZoMJh
        ELKC6HWD+qqWDnOYeTWiWLCH0/OVgnt0cbcFuYOWDHBdwqX9ycD0lKQZ82zd6j6AyXQXl/MhfXNue
        58UO5s+X+oTUzS4AgMKU7nngYF21ck1B90Xbv7Q74ufKONaMoo+/ME68jtr2kRmnxpAYo9bWY/dPN
        TNZPtmdHkm0Dr9zYZqINtRJRnZLM6vwYLWXw2Zn/Jco6g9pephvDp0627tTIs9uWxgyyhBVpnXlHy
        WaxAEJew==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1p0VFO-00FLWR-EU; Wed, 30 Nov 2022 22:08:06 +0000
From:   "Matthew Wilcox (Oracle)" <willy@infradead.org>
To:     Jesper Dangaard Brouer <hawk@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        netdev@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH 20/24] mm: Remove page pool members from struct page
Date:   Wed, 30 Nov 2022 22:07:59 +0000
Message-Id: <20221130220803.3657490-21-willy@infradead.org>
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

These are now split out into their own netmem struct.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 include/linux/mm_types.h | 22 ----------------------
 include/net/page_pool.h  |  4 ----
 2 files changed, 26 deletions(-)

diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 1ad1ef3a1288..6999af135f1d 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -113,28 +113,6 @@ struct page {
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
index ce1049a03f2d..222eedc39140 100644
--- a/include/net/page_pool.h
+++ b/include/net/page_pool.h
@@ -81,11 +81,7 @@ struct netmem {
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

