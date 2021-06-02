Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97BDC39853B
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 11:26:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231834AbhFBJ2Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 05:28:16 -0400
Received: from smtp2.axis.com ([195.60.68.18]:15235 "EHLO smtp2.axis.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229618AbhFBJ2N (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Jun 2021 05:28:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=axis.com; q=dns/txt; s=axis-central1; t=1622625991;
  x=1654161991;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=i3LI9KmR0eUSwkVrHTC0g2VV05FuH9FIa/Rx3igcP/E=;
  b=fFC9IC6IRBek2nsmW1QpPgI08SMtCwRtD1JrZwb5Zo5EBYnZ7JbGaZfO
   7vwOVGXPpPa1i1xDxo6SgEGy7AO9mC/E1EYDmKzK52N6boRK9zlKZGU9l
   QXXVQvyhDLRVsguJ29IiZMbAU4zzE4CfdBmGfqT/I3mYbsMVSY7OE5I+h
   qhkIJPOh09aEPMS+6IPQYT6BggaL4x9S/jpe3I2ERtSGr0JhX2d3wlqmP
   6G17im8Z4WIXzjv1FsO3DW6TZq72/aomRNRLpF+jTqJAn+ionSJWYUzDU
   I3IPbjzHdykPuex9yftwHeCm0XJvu7sUx/clAazpLdTfe9fhkN3LM+x11
   Q==;
From:   Vincent Whitchurch <vincent.whitchurch@axis.com>
To:     <akpm@linux-foundation.org>
CC:     <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <rostedt@goodmis.org>,
        <mingo@redhat.com>, <hawk@kernel.org>,
        <ilias.apalodimas@linaro.org>, <kernel@axis.com>,
        Vincent Whitchurch <vincent.whitchurch@axis.com>
Subject: [PATCH] mm, tracing: Unify PFN format strings
Date:   Wed, 2 Jun 2021 11:26:08 +0200
Message-ID: <20210602092608.1493-1-vincent.whitchurch@axis.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some trace event formats print PFNs as hex while others print them as
decimal.  This is rather annoying when attempting to grep through traces
to understand what's going on with a particular page.

 $ git grep -ho 'pfn=[0x%lu]\+' include/trace/events/ | sort | uniq -c
      11 pfn=0x%lx
      12 pfn=%lu
       2 pfn=%lx

Printing as hex is in the majority in the trace events, and all the
normal printks in mm/ also print PFNs as hex, so change all the PFN
formats in the trace events to use 0x%lx.

Signed-off-by: Vincent Whitchurch <vincent.whitchurch@axis.com>
---
 include/trace/events/cma.h       |  4 ++--
 include/trace/events/filemap.h   |  2 +-
 include/trace/events/kmem.h      | 12 ++++++------
 include/trace/events/page_pool.h |  4 ++--
 include/trace/events/pagemap.h   |  4 ++--
 include/trace/events/vmscan.h    |  2 +-
 6 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/include/trace/events/cma.h b/include/trace/events/cma.h
index c3d354702cb0..3d708dae1542 100644
--- a/include/trace/events/cma.h
+++ b/include/trace/events/cma.h
@@ -31,7 +31,7 @@ DECLARE_EVENT_CLASS(cma_alloc_class,
 		__entry->align = align;
 	),
 
-	TP_printk("name=%s pfn=%lx page=%p count=%lu align=%u",
+	TP_printk("name=%s pfn=0x%lx page=%p count=%lu align=%u",
 		  __get_str(name),
 		  __entry->pfn,
 		  __entry->page,
@@ -60,7 +60,7 @@ TRACE_EVENT(cma_release,
 		__entry->count = count;
 	),
 
-	TP_printk("name=%s pfn=%lx page=%p count=%lu",
+	TP_printk("name=%s pfn=0x%lx page=%p count=%lu",
 		  __get_str(name),
 		  __entry->pfn,
 		  __entry->page,
diff --git a/include/trace/events/filemap.h b/include/trace/events/filemap.h
index 796053e162d2..c47b63db124e 100644
--- a/include/trace/events/filemap.h
+++ b/include/trace/events/filemap.h
@@ -36,7 +36,7 @@ DECLARE_EVENT_CLASS(mm_filemap_op_page_cache,
 			__entry->s_dev = page->mapping->host->i_rdev;
 	),
 
-	TP_printk("dev %d:%d ino %lx page=%p pfn=%lu ofs=%lu",
+	TP_printk("dev %d:%d ino %lx page=%p pfn=0x%lx ofs=%lu",
 		MAJOR(__entry->s_dev), MINOR(__entry->s_dev),
 		__entry->i_ino,
 		pfn_to_page(__entry->pfn),
diff --git a/include/trace/events/kmem.h b/include/trace/events/kmem.h
index 829a75692cc0..ddc8c944f417 100644
--- a/include/trace/events/kmem.h
+++ b/include/trace/events/kmem.h
@@ -173,7 +173,7 @@ TRACE_EVENT(mm_page_free,
 		__entry->order		= order;
 	),
 
-	TP_printk("page=%p pfn=%lu order=%d",
+	TP_printk("page=%p pfn=0x%lx order=%d",
 			pfn_to_page(__entry->pfn),
 			__entry->pfn,
 			__entry->order)
@@ -193,7 +193,7 @@ TRACE_EVENT(mm_page_free_batched,
 		__entry->pfn		= page_to_pfn(page);
 	),
 
-	TP_printk("page=%p pfn=%lu order=0",
+	TP_printk("page=%p pfn=0x%lx order=0",
 			pfn_to_page(__entry->pfn),
 			__entry->pfn)
 );
@@ -219,7 +219,7 @@ TRACE_EVENT(mm_page_alloc,
 		__entry->migratetype	= migratetype;
 	),
 
-	TP_printk("page=%p pfn=%lu order=%d migratetype=%d gfp_flags=%s",
+	TP_printk("page=%p pfn=0x%lx order=%d migratetype=%d gfp_flags=%s",
 		__entry->pfn != -1UL ? pfn_to_page(__entry->pfn) : NULL,
 		__entry->pfn != -1UL ? __entry->pfn : 0,
 		__entry->order,
@@ -245,7 +245,7 @@ DECLARE_EVENT_CLASS(mm_page,
 		__entry->migratetype	= migratetype;
 	),
 
-	TP_printk("page=%p pfn=%lu order=%u migratetype=%d percpu_refill=%d",
+	TP_printk("page=%p pfn=0x%lx order=%u migratetype=%d percpu_refill=%d",
 		__entry->pfn != -1UL ? pfn_to_page(__entry->pfn) : NULL,
 		__entry->pfn != -1UL ? __entry->pfn : 0,
 		__entry->order,
@@ -278,7 +278,7 @@ TRACE_EVENT(mm_page_pcpu_drain,
 		__entry->migratetype	= migratetype;
 	),
 
-	TP_printk("page=%p pfn=%lu order=%d migratetype=%d",
+	TP_printk("page=%p pfn=0x%lx order=%d migratetype=%d",
 		pfn_to_page(__entry->pfn), __entry->pfn,
 		__entry->order, __entry->migratetype)
 );
@@ -312,7 +312,7 @@ TRACE_EVENT(mm_page_alloc_extfrag,
 					get_pageblock_migratetype(page));
 	),
 
-	TP_printk("page=%p pfn=%lu alloc_order=%d fallback_order=%d pageblock_order=%d alloc_migratetype=%d fallback_migratetype=%d fragmenting=%d change_ownership=%d",
+	TP_printk("page=%p pfn=0x%lx alloc_order=%d fallback_order=%d pageblock_order=%d alloc_migratetype=%d fallback_migratetype=%d fragmenting=%d change_ownership=%d",
 		pfn_to_page(__entry->pfn),
 		__entry->pfn,
 		__entry->alloc_order,
diff --git a/include/trace/events/page_pool.h b/include/trace/events/page_pool.h
index ad0aa7f31675..ca534501158b 100644
--- a/include/trace/events/page_pool.h
+++ b/include/trace/events/page_pool.h
@@ -60,7 +60,7 @@ TRACE_EVENT(page_pool_state_release,
 		__entry->pfn		= page_to_pfn(page);
 	),
 
-	TP_printk("page_pool=%p page=%p pfn=%lu release=%u",
+	TP_printk("page_pool=%p page=%p pfn=0x%lx release=%u",
 		  __entry->pool, __entry->page, __entry->pfn, __entry->release)
 );
 
@@ -85,7 +85,7 @@ TRACE_EVENT(page_pool_state_hold,
 		__entry->pfn	= page_to_pfn(page);
 	),
 
-	TP_printk("page_pool=%p page=%p pfn=%lu hold=%u",
+	TP_printk("page_pool=%p page=%p pfn=0x%lx hold=%u",
 		  __entry->pool, __entry->page, __entry->pfn, __entry->hold)
 );
 
diff --git a/include/trace/events/pagemap.h b/include/trace/events/pagemap.h
index e1735fe7c76a..1d28431e85bd 100644
--- a/include/trace/events/pagemap.h
+++ b/include/trace/events/pagemap.h
@@ -46,7 +46,7 @@ TRACE_EVENT(mm_lru_insertion,
 	),
 
 	/* Flag format is based on page-types.c formatting for pagemap */
-	TP_printk("page=%p pfn=%lu lru=%d flags=%s%s%s%s%s%s",
+	TP_printk("page=%p pfn=0x%lx lru=%d flags=%s%s%s%s%s%s",
 			__entry->page,
 			__entry->pfn,
 			__entry->lru,
@@ -75,7 +75,7 @@ TRACE_EVENT(mm_lru_activate,
 	),
 
 	/* Flag format is based on page-types.c formatting for pagemap */
-	TP_printk("page=%p pfn=%lu", __entry->page, __entry->pfn)
+	TP_printk("page=%p pfn=0x%lx", __entry->page, __entry->pfn)
 
 );
 
diff --git a/include/trace/events/vmscan.h b/include/trace/events/vmscan.h
index 2070df64958e..00d1180527d8 100644
--- a/include/trace/events/vmscan.h
+++ b/include/trace/events/vmscan.h
@@ -330,7 +330,7 @@ TRACE_EVENT(mm_vmscan_writepage,
 						page_is_file_lru(page));
 	),
 
-	TP_printk("page=%p pfn=%lu flags=%s",
+	TP_printk("page=%p pfn=0x%lx flags=%s",
 		pfn_to_page(__entry->pfn),
 		__entry->pfn,
 		show_reclaim_flags(__entry->reclaim_flags))
-- 
2.28.0

