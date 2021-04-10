Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E33535ADFB
	for <lists+netdev@lfdr.de>; Sat, 10 Apr 2021 16:08:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234792AbhDJOIZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Apr 2021 10:08:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234536AbhDJOIY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Apr 2021 10:08:24 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EC88C06138A;
        Sat, 10 Apr 2021 07:08:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=RTtiSoWYCZ04uVGpMhjmbWk2I8ENKaw5/2meK4GSvVY=; b=Ukx/6bcpMFZOkdXU+6AgH4koIC
        JYQO1FzV6/eHzojqXmXhQ/Z2nX30bYjwSNpUwoyoumWWCurMZmGxnEEecD4PaJKmp4GXz6p1b2+/q
        0RMOdRNqSOTRFvUwSPVFDwmRSjjZ3ITuDSJ2aLHHPe64xqcxY+ZqKMubFJS1QJtFXq4Kxm3hnd3of
        BUO/DXOBYmNDLsQ1dD5dC1DSv1nb1TAKfNZI+Mr+uPZqIQ8bzPe8DP+78gLma/EybXZRgoiB8h8sl
        A7MmK5nSVyMIc1DrKxYN/Zbg0WVr4tZgOm6InniGGemi70dpNNfZB+gF4ZdfcKuxzTQhjyUXVU1QB
        g8Q5EMEA==;
Received: from willy by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lVEGC-001lqY-BT; Sat, 10 Apr 2021 14:07:08 +0000
Date:   Sat, 10 Apr 2021 15:06:52 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>,
        kernel test robot <lkp@intel.com>,
        Linux-MM <linux-mm@kvack.org>, kbuild-all@lists.01.org,
        clang-built-linux@googlegroups.com,
        open list <linux-kernel@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        linuxppc-dev@lists.ozlabs.org,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        Matteo Croce <mcroce@linux.microsoft.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: Re: Bogus struct page layout on 32-bit
Message-ID: <20210410140652.GY2531743@casper.infradead.org>
References: <20210409185105.188284-3-willy@infradead.org>
 <202104100656.N7EVvkNZ-lkp@intel.com>
 <20210410024313.GX2531743@casper.infradead.org>
 <20210410082158.79ad09a6@carbon>
 <CAC_iWjLXZ6-hhvmvee6r4R_N64u-hrnLqE_CSS1nQk+YaMQQnA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAC_iWjLXZ6-hhvmvee6r4R_N64u-hrnLqE_CSS1nQk+YaMQQnA@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

How about moving the flags into the union?  A bit messy, but we don't
have to play games with __packed__.

diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 1210a8e41fad..f374d2f06255 100644
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
@@ -96,6 +102,8 @@ struct page {
 			unsigned long private;
 		};
 		struct {	/* page_pool used by netstack */
+			unsigned long _pp_flags;
+			unsigned long _pp_pad;
 			/**
 			 * @dma_addr: might require a 64-bit value even on
 			 * 32-bit architectures.
@@ -103,6 +111,7 @@ struct page {
 			dma_addr_t dma_addr;
 		};
 		struct {	/* slab, slob and slub */
+			unsigned long _slab_flags;
 			union {
 				struct list_head slab_list;
 				struct {	/* Partial pages */
@@ -130,6 +139,7 @@ struct page {
 			};
 		};
 		struct {	/* Tail pages of compound page */
+			unsigned long _tail1_flags;
 			unsigned long compound_head;	/* Bit zero is set */
 
 			/* First tail page only */
@@ -139,12 +149,14 @@ struct page {
 			unsigned int compound_nr; /* 1 << compound_order */
 		};
 		struct {	/* Second tail page of compound page */
+			unsigned long _tail2_flags;
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
@@ -159,6 +171,7 @@ struct page {
 #endif
 		};
 		struct {	/* ZONE_DEVICE pages */
+			unsigned long _zd_flags;
 			/** @pgmap: Points to the hosting device page map. */
 			struct dev_pagemap *pgmap;
 			void *zone_device_data;
@@ -174,8 +187,11 @@ struct page {
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
