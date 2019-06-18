Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 925954A1A4
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 15:06:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729115AbfFRNGH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 09:06:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34052 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728699AbfFRNGH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Jun 2019 09:06:07 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id EC334356CF;
        Tue, 18 Jun 2019 13:06:01 +0000 (UTC)
Received: from firesoul.localdomain (ovpn-200-41.brq.redhat.com [10.40.200.41])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E653D7E8EE;
        Tue, 18 Jun 2019 13:05:58 +0000 (UTC)
Received: from [192.168.5.1] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id 1D7F0306665E6;
        Tue, 18 Jun 2019 15:05:58 +0200 (CEST)
Subject: [PATCH net-next v2 10/12] xdp: add tracepoints for XDP mem
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     netdev@vger.kernel.org,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Toke =?utf-8?q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        Tariq Toukan <tariqt@mellanox.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     toshiaki.makita1@gmail.com, grygorii.strashko@ti.com,
        ivan.khoronzhuk@linaro.org, mcroce@redhat.com
Date:   Tue, 18 Jun 2019 15:05:58 +0200
Message-ID: <156086315805.27760.17018812015980873364.stgit@firesoul>
In-Reply-To: <156086304827.27760.11339786046465638081.stgit@firesoul>
References: <156086304827.27760.11339786046465638081.stgit@firesoul>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.30]); Tue, 18 Jun 2019 13:06:07 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These tracepoints make it easier to troubleshoot XDP mem id disconnect.

The xdp:mem_disconnect tracepoint cannot be replaced via kprobe. It is
placed at the last stable place for the pointer to struct xdp_mem_allocator,
just before it's scheduled for RCU removal. It also extract info on
'safe_to_remove' and 'force'.

Detailed info about in-flight pages is not available at this layer. The next
patch will added tracepoints needed at the page_pool layer for this.

Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
---
 include/net/xdp_priv.h     |   23 +++++++++
 include/trace/events/xdp.h |  115 ++++++++++++++++++++++++++++++++++++++++++++
 net/core/xdp.c             |   21 ++------
 3 files changed, 143 insertions(+), 16 deletions(-)
 create mode 100644 include/net/xdp_priv.h

diff --git a/include/net/xdp_priv.h b/include/net/xdp_priv.h
new file mode 100644
index 000000000000..6a8cba6ea79a
--- /dev/null
+++ b/include/net/xdp_priv.h
@@ -0,0 +1,23 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __LINUX_NET_XDP_PRIV_H__
+#define __LINUX_NET_XDP_PRIV_H__
+
+#include <linux/rhashtable.h>
+
+/* Private to net/core/xdp.c, but used by trace/events/xdp.h */
+struct xdp_mem_allocator {
+	struct xdp_mem_info mem;
+	union {
+		void *allocator;
+		struct page_pool *page_pool;
+		struct zero_copy_allocator *zc_alloc;
+	};
+	int disconnect_cnt;
+	unsigned long defer_start;
+	struct rhash_head node;
+	struct rcu_head rcu;
+	struct delayed_work defer_wq;
+	unsigned long defer_warn;
+};
+
+#endif /* __LINUX_NET_XDP_PRIV_H__ */
diff --git a/include/trace/events/xdp.h b/include/trace/events/xdp.h
index e95cb86b65cf..bb5e380e2ef3 100644
--- a/include/trace/events/xdp.h
+++ b/include/trace/events/xdp.h
@@ -269,6 +269,121 @@ TRACE_EVENT(xdp_devmap_xmit,
 		  __entry->from_ifindex, __entry->to_ifindex, __entry->err)
 );
 
+/* Expect users already include <net/xdp.h>, but not xdp_priv.h */
+#include <net/xdp_priv.h>
+
+#define __MEM_TYPE_MAP(FN)	\
+	FN(PAGE_SHARED)		\
+	FN(PAGE_ORDER0)		\
+	FN(PAGE_POOL)		\
+	FN(ZERO_COPY)
+
+#define __MEM_TYPE_TP_FN(x)	\
+	TRACE_DEFINE_ENUM(MEM_TYPE_##x);
+#define __MEM_TYPE_SYM_FN(x)	\
+	{ MEM_TYPE_##x, #x },
+#define __MEM_TYPE_SYM_TAB	\
+	__MEM_TYPE_MAP(__MEM_TYPE_SYM_FN) { -1, 0 }
+__MEM_TYPE_MAP(__MEM_TYPE_TP_FN)
+
+TRACE_EVENT(mem_disconnect,
+
+	TP_PROTO(const struct xdp_mem_allocator *xa,
+		 bool safe_to_remove, bool force),
+
+	TP_ARGS(xa, safe_to_remove, force),
+
+	TP_STRUCT__entry(
+		__field(const struct xdp_mem_allocator *,	xa)
+		__field(u32,		mem_id)
+		__field(u32,		mem_type)
+		__field(const void *,	allocator)
+		__field(bool,		safe_to_remove)
+		__field(bool,		force)
+		__field(int,		disconnect_cnt)
+	),
+
+	TP_fast_assign(
+		__entry->xa		= xa;
+		__entry->mem_id		= xa->mem.id;
+		__entry->mem_type	= xa->mem.type;
+		__entry->allocator	= xa->allocator;
+		__entry->safe_to_remove	= safe_to_remove;
+		__entry->force		= force;
+		__entry->disconnect_cnt	= xa->disconnect_cnt;
+	),
+
+	TP_printk("mem_id=%d mem_type=%s allocator=%p"
+		  " safe_to_remove=%s force=%s disconnect_cnt=%d",
+		  __entry->mem_id,
+		  __print_symbolic(__entry->mem_type, __MEM_TYPE_SYM_TAB),
+		  __entry->allocator,
+		  __entry->safe_to_remove ? "true" : "false",
+		  __entry->force ? "true" : "false",
+		  __entry->disconnect_cnt
+	)
+);
+
+TRACE_EVENT(mem_connect,
+
+	TP_PROTO(const struct xdp_mem_allocator *xa,
+		 const struct xdp_rxq_info *rxq),
+
+	TP_ARGS(xa, rxq),
+
+	TP_STRUCT__entry(
+		__field(const struct xdp_mem_allocator *,	xa)
+		__field(u32,		mem_id)
+		__field(u32,		mem_type)
+		__field(const void *,	allocator)
+		__field(const struct xdp_rxq_info *,		rxq)
+		__field(int,		ifindex)
+	),
+
+	TP_fast_assign(
+		__entry->xa		= xa;
+		__entry->mem_id		= xa->mem.id;
+		__entry->mem_type	= xa->mem.type;
+		__entry->allocator	= xa->allocator;
+		__entry->rxq		= rxq;
+		__entry->ifindex	= rxq->dev->ifindex;
+	),
+
+	TP_printk("mem_id=%d mem_type=%s allocator=%p"
+		  " ifindex=%d",
+		  __entry->mem_id,
+		  __print_symbolic(__entry->mem_type, __MEM_TYPE_SYM_TAB),
+		  __entry->allocator,
+		  __entry->ifindex
+	)
+);
+
+TRACE_EVENT(mem_return_failed,
+
+	TP_PROTO(const struct xdp_mem_info *mem,
+		 const struct page *page),
+
+	TP_ARGS(mem, page),
+
+	TP_STRUCT__entry(
+		__field(const struct page *,	page)
+		__field(u32,		mem_id)
+		__field(u32,		mem_type)
+	),
+
+	TP_fast_assign(
+		__entry->page		= page;
+		__entry->mem_id		= mem->id;
+		__entry->mem_type	= mem->type;
+	),
+
+	TP_printk("mem_id=%d mem_type=%s page=%p",
+		  __entry->mem_id,
+		  __print_symbolic(__entry->mem_type, __MEM_TYPE_SYM_TAB),
+		  __entry->page
+	)
+);
+
 #endif /* _TRACE_XDP_H */
 
 #include <trace/define_trace.h>
diff --git a/net/core/xdp.c b/net/core/xdp.c
index 53bce4fa776a..4ad9e48b76a8 100644
--- a/net/core/xdp.c
+++ b/net/core/xdp.c
@@ -14,6 +14,8 @@
 #include <net/page_pool.h>
 
 #include <net/xdp.h>
+#include <net/xdp_priv.h> /* struct xdp_mem_allocator */
+#include <trace/events/xdp.h>
 
 #define REG_STATE_NEW		0x0
 #define REG_STATE_REGISTERED	0x1
@@ -29,21 +31,6 @@ static int mem_id_next = MEM_ID_MIN;
 static bool mem_id_init; /* false */
 static struct rhashtable *mem_id_ht;
 
-struct xdp_mem_allocator {
-	struct xdp_mem_info mem;
-	union {
-		void *allocator;
-		struct page_pool *page_pool;
-		struct zero_copy_allocator *zc_alloc;
-	};
-	struct rhash_head node;
-	struct rcu_head rcu;
-	struct delayed_work defer_wq;
-	unsigned long defer_start;
-	unsigned long defer_warn;
-	int disconnect_cnt;
-};
-
 static u32 xdp_mem_id_hashfn(const void *data, u32 len, u32 seed)
 {
 	const u32 *k = data;
@@ -117,7 +104,7 @@ bool __mem_id_disconnect(int id, bool force)
 	if (xa->mem.type == MEM_TYPE_PAGE_POOL)
 		safe_to_remove = page_pool_request_shutdown(xa->page_pool);
 
-	/* TODO: Tracepoint will be added here in next-patch */
+	trace_mem_disconnect(xa, safe_to_remove, force);
 
 	if ((safe_to_remove || force) &&
 	    !rhashtable_remove_fast(mem_id_ht, &xa->node, mem_id_rht_params))
@@ -385,6 +372,7 @@ int xdp_rxq_info_reg_mem_model(struct xdp_rxq_info *xdp_rxq,
 
 	mutex_unlock(&mem_id_lock);
 
+	trace_mem_connect(xdp_alloc, xdp_rxq);
 	return 0;
 err:
 	mutex_unlock(&mem_id_lock);
@@ -417,6 +405,7 @@ static void __xdp_return(void *data, struct xdp_mem_info *mem, bool napi_direct,
 		} else {
 			/* Hopefully stack show who to blame for late return */
 			WARN_ONCE(1, "page_pool gone mem.id=%d", mem->id);
+			trace_mem_return_failed(mem, page);
 			put_page(page);
 		}
 		rcu_read_unlock();

