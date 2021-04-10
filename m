Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7332835B084
	for <lists+netdev@lfdr.de>; Sat, 10 Apr 2021 22:53:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235102AbhDJUxz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Apr 2021 16:53:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234439AbhDJUxz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Apr 2021 16:53:55 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F741C06138A;
        Sat, 10 Apr 2021 13:53:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=yEhz7y0CGZuP2jAZyLJRxF/+72ERrNclNPf+YZnthms=; b=i5gbw5w7uAuWK89bhf2Sg7mZPO
        Pe/IPgz7XQwGqe28En2+H4gPDf6Sym78McWLPJU3KV96pLYwkpSXhe6+oEJ3sAa1/Di6jsUAOzZgi
        ULC+GRiQllP9ZWO9bagsiISYHoJ2xBkKQS4JcFgd70jdxVMTzZv6ZMQNuvd2RX5rGpw0j6hxGI/6d
        xcHwuMMVnefYehJ8tSrn21Atv+iusGtsYROOGw9+gGNxnxg51m4pU3XYrT8rQ9Zf+ph7qJ8WMXrn3
        4FByd97IikiPQkrYqwtPDLgJK/bD1Vt264ofkgkNfniLmGY8lOdL/mFCFddDljXke6n8E79zIv/UV
        yN30XbLQ==;
Received: from willy by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lVKbS-0027wf-Fe; Sat, 10 Apr 2021 20:53:16 +0000
From:   "Matthew Wilcox (Oracle)" <willy@infradead.org>
To:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        netdev@vger.kernel.org
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        linuxppc-dev@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linux-mips@vger.kernel.org,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Matteo Croce <mcroce@linux.microsoft.com>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Arnd Bergmann <arnd@kernel.org>
Subject: [PATCH 1/1] mm: Fix struct page layout on 32-bit systems
Date:   Sat, 10 Apr 2021 21:52:45 +0100
Message-Id: <20210410205246.507048-2-willy@infradead.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210410205246.507048-1-willy@infradead.org>
References: <20210410205246.507048-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

32-bit architectures which expect 8-byte alignment for 8-byte integers
and need 64-bit DMA addresses (arc, arm, mips, ppc) had their struct
page inadvertently expanded in 2019.  When the dma_addr_t was added,
it forced the alignment of the union to 8 bytes, which inserted a 4 byte
gap between 'flags' and the union.

We could fix this by telling the compiler to use a smaller alignment
for the dma_addr, but that seems a little fragile.  Instead, move the
'flags' into the union.  That causes dma_addr to shift into the same
bits as 'mapping', so it would have to be cleared on free.  To avoid
this, insert three words of padding and use the same bits as ->index
and ->private, neither of which have to be cleared on free.

Fixes: c25fff7171be ("mm: add dma_addr_t to struct page")
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 include/linux/mm_types.h | 38 ++++++++++++++++++++++++++------------
 1 file changed, 26 insertions(+), 12 deletions(-)

diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 6613b26a8894..45c563e9b50e 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -68,16 +68,22 @@ struct mem_cgroup;
 #endif
 
 struct page {
-	unsigned long flags;		/* Atomic flags, some possibly
-					 * updated asynchronously */
 	/*
-	 * Five words (20/40 bytes) are available in this union.
-	 * WARNING: bit 0 of the first word is used for PageTail(). That
-	 * means the other users of this union MUST NOT use the bit to
+	 * This union is six words (24 / 48 bytes) in size.
+	 * The first word is reserved for atomic flags, often updated
+	 * asynchronously.  Use the PageFoo() macros to access it.  Some
+	 * of the flags can be reused for your own purposes, but the
+	 * word as a whole often contains other information and overwriting
+	 * it will cause functions like page_zone() and page_node() to stop
+	 * working correctly.
+	 *
+	 * Bit 0 of the second word is used for PageTail(). That
+	 * means the other users of this union MUST leave the bit zero to
 	 * avoid collision and false-positive PageTail().
 	 */
 	union {
 		struct {	/* Page cache and anonymous pages */
+			unsigned long flags;
 			/**
 			 * @lru: Pageout list, eg. active_list protected by
 			 * lruvec->lru_lock.  Sometimes used as a generic list
@@ -96,13 +102,14 @@ struct page {
 			unsigned long private;
 		};
 		struct {	/* page_pool used by netstack */
-			/**
-			 * @dma_addr: might require a 64-bit value even on
-			 * 32-bit architectures.
-			 */
-			dma_addr_t dma_addr;
+			unsigned long _pp_flags;
+			unsigned long pp_magic;
+			unsigned long xmi;
+			unsigned long _pp_mapping_pad;
+			dma_addr_t dma_addr;	/* might be one or two words */
 		};
 		struct {	/* slab, slob and slub */
+			unsigned long _slab_flags;
 			union {
 				struct list_head slab_list;
 				struct {	/* Partial pages */
@@ -130,6 +137,7 @@ struct page {
 			};
 		};
 		struct {	/* Tail pages of compound page */
+			unsigned long _t1_flags;
 			unsigned long compound_head;	/* Bit zero is set */
 
 			/* First tail page only */
@@ -139,12 +147,14 @@ struct page {
 			unsigned int compound_nr; /* 1 << compound_order */
 		};
 		struct {	/* Second tail page of compound page */
+			unsigned long _t2_flags;
 			unsigned long _compound_pad_1;	/* compound_head */
 			atomic_t hpage_pinned_refcount;
 			/* For both global and memcg */
 			struct list_head deferred_list;
 		};
 		struct {	/* Page table pages */
+			unsigned long _pt_flags;
 			unsigned long _pt_pad_1;	/* compound_head */
 			pgtable_t pmd_huge_pte; /* protected by page->ptl */
 			unsigned long _pt_pad_2;	/* mapping */
@@ -159,6 +169,7 @@ struct page {
 #endif
 		};
 		struct {	/* ZONE_DEVICE pages */
+			unsigned long _zd_flags;
 			/** @pgmap: Points to the hosting device page map. */
 			struct dev_pagemap *pgmap;
 			void *zone_device_data;
@@ -174,8 +185,11 @@ struct page {
 			 */
 		};
 
-		/** @rcu_head: You can use this to free a page by RCU. */
-		struct rcu_head rcu_head;
+		struct {
+			unsigned long _rcu_flags;
+			/** @rcu_head: You can use this to free a page by RCU. */
+			struct rcu_head rcu_head;
+		};
 	};
 
 	union {		/* This union is 4 bytes in size. */
-- 
2.30.2

