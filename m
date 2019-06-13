Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CDC7E44AB0
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 20:29:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728971AbfFMS3C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 14:29:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56476 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727058AbfFMS3B (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Jun 2019 14:29:01 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 55CDE81F0C;
        Thu, 13 Jun 2019 18:29:01 +0000 (UTC)
Received: from firesoul.localdomain (ovpn-200-44.brq.redhat.com [10.40.200.44])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 969265E7C4;
        Thu, 13 Jun 2019 18:28:58 +0000 (UTC)
Received: from [192.168.5.1] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id BFAD13009AEFD;
        Thu, 13 Jun 2019 20:28:57 +0200 (CEST)
Subject: [PATCH net-next v1 11/11] page_pool: add tracepoints for page_pool
 with details need by XDP
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     netdev@vger.kernel.org,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Toke =?utf-8?q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        Tariq Toukan <tariqt@mellanox.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     toshiaki.makita1@gmail.com, grygorii.strashko@ti.com,
        ivan.khoronzhuk@linaro.org, mcroce@redhat.com
Date:   Thu, 13 Jun 2019 20:28:57 +0200
Message-ID: <156045053771.29115.2828671939723416430.stgit@firesoul>
In-Reply-To: <156045046024.29115.11802895015973488428.stgit@firesoul>
References: <156045046024.29115.11802895015973488428.stgit@firesoul>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.27]); Thu, 13 Jun 2019 18:29:01 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The xdp tracepoints for mem id disconnect don't carry information about, why
it was not safe_to_remove.  The tracepoint page_pool:page_pool_inflight in
this patch can be used for extract this info for further debugging.

This patchset also adds tracepoint for the pages_state_* release/hold
transitions, including a pointer to the page.  This can be used for stats
about in-flight pages, or used to debug page leakage via keeping track of
page pointer and combining this with kprobe for __put_page().

Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
---
 include/trace/events/page_pool.h |   87 ++++++++++++++++++++++++++++++++++++++
 net/core/net-traces.c            |    4 ++
 net/core/page_pool.c             |    9 +++-
 3 files changed, 99 insertions(+), 1 deletion(-)
 create mode 100644 include/trace/events/page_pool.h

diff --git a/include/trace/events/page_pool.h b/include/trace/events/page_pool.h
new file mode 100644
index 000000000000..47b5ee880aa9
--- /dev/null
+++ b/include/trace/events/page_pool.h
@@ -0,0 +1,87 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM page_pool
+
+#if !defined(_TRACE_PAGE_POOL_H) || defined(TRACE_HEADER_MULTI_READ)
+#define      _TRACE_PAGE_POOL_H
+
+#include <linux/types.h>
+#include <linux/tracepoint.h>
+
+#include <net/page_pool.h>
+
+TRACE_EVENT(page_pool_inflight,
+
+	TP_PROTO(const struct page_pool *pool,
+		 s32 inflight, u32 hold, u32 release),
+
+	TP_ARGS(pool, inflight, hold, release),
+
+	TP_STRUCT__entry(
+		__field(const struct page_pool *, pool)
+		__field(s32,	inflight)
+		__field(u32,	hold)
+		__field(u32,	release)
+	),
+
+	TP_fast_assign(
+		__entry->pool		= pool;
+		__entry->inflight	= inflight;
+		__entry->hold		= hold;
+		__entry->release	= release;
+	),
+
+	TP_printk("page_pool=%p inflight=%d hold=%u release=%u",
+	  __entry->pool, __entry->inflight, __entry->hold, __entry->release)
+);
+
+TRACE_EVENT(page_pool_state_release,
+
+	TP_PROTO(const struct page_pool *pool,
+		 const struct page *page, u32 release),
+
+	TP_ARGS(pool, page, release),
+
+	TP_STRUCT__entry(
+		__field(const struct page_pool *,	pool)
+		__field(const struct page *,		page)
+		__field(u32,				release)
+	),
+
+	TP_fast_assign(
+		__entry->pool		= pool;
+		__entry->page		= page;
+		__entry->release	= release;
+	),
+
+	TP_printk("page_pool=%p page=%p release=%u",
+		  __entry->pool, __entry->page, __entry->release)
+);
+
+TRACE_EVENT(page_pool_state_hold,
+
+	TP_PROTO(const struct page_pool *pool,
+		 const struct page *page, u32 hold),
+
+	TP_ARGS(pool, page, hold),
+
+	TP_STRUCT__entry(
+		__field(const struct page_pool *,	pool)
+		__field(const struct page *,		page)
+		__field(u32,				hold)
+	),
+
+	TP_fast_assign(
+		__entry->pool	= pool;
+		__entry->page	= page;
+		__entry->hold	= hold;
+	),
+
+	TP_printk("page_pool=%p page=%p hold=%u",
+		  __entry->pool, __entry->page, __entry->hold)
+);
+
+#endif /* _TRACE_PAGE_POOL_H */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
diff --git a/net/core/net-traces.c b/net/core/net-traces.c
index 470b179d599e..283ddb2dbc7d 100644
--- a/net/core/net-traces.c
+++ b/net/core/net-traces.c
@@ -43,6 +43,10 @@ EXPORT_TRACEPOINT_SYMBOL_GPL(fdb_delete);
 EXPORT_TRACEPOINT_SYMBOL_GPL(br_fdb_update);
 #endif
 
+#if IS_ENABLED(CONFIG_PAGE_POOL)
+#include <trace/events/page_pool.h>
+#endif
+
 #include <trace/events/neigh.h>
 EXPORT_TRACEPOINT_SYMBOL_GPL(neigh_update);
 EXPORT_TRACEPOINT_SYMBOL_GPL(neigh_update_done);
diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index 42c3b0a5a259..f55ab055d543 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -4,6 +4,7 @@
  *	Author:	Jesper Dangaard Brouer <netoptimizer@brouer.com>
  *	Copyright (C) 2016 Red Hat, Inc.
  */
+
 #include <linux/types.h>
 #include <linux/kernel.h>
 #include <linux/slab.h>
@@ -14,6 +15,8 @@
 #include <linux/page-flags.h>
 #include <linux/mm.h> /* for __put_page() */
 
+#include <trace/events/page_pool.h>
+
 static int page_pool_init(struct page_pool *pool,
 			  const struct page_pool_params *params)
 {
@@ -156,6 +159,8 @@ static struct page *__page_pool_alloc_pages_slow(struct page_pool *pool,
 	/* Track how many pages are held 'in-flight' */
 	pool->pages_state_hold_cnt++;
 
+	trace_page_pool_state_hold(pool, page, pool->pages_state_hold_cnt);
+
 	/* When page just alloc'ed is should/must have refcnt 1. */
 	return page;
 }
@@ -191,7 +196,7 @@ static s32 page_pool_inflight(struct page_pool *pool)
 
 	distance = _distance(hold_cnt, release_cnt);
 
-	/* TODO: Add tracepoint here */
+	trace_page_pool_inflight(pool, distance, hold_cnt, release_cnt);
 	return distance;
 }
 
@@ -222,6 +227,8 @@ static void __page_pool_clean_page(struct page_pool *pool,
 	page->dma_addr = 0;
 skip_dma_unmap:
 	atomic_inc(&pool->pages_state_release_cnt);
+	trace_page_pool_state_release(pool, page,
+			      atomic_read(&pool->pages_state_release_cnt));
 }
 
 /* unmap the page and clean our state */

