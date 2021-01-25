Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 629E8303360
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 05:52:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728753AbhAZEvm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 23:51:42 -0500
Received: from mga09.intel.com ([134.134.136.24]:41204 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726599AbhAYJig (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Jan 2021 04:38:36 -0500
IronPort-SDR: c+rXN6zaSlMWs8FhuD+EOo7gFpgIR4tMSWYNEXOYx09MqvtUzFojMQl67G5s3vNrRCAFwBZ3WY
 qjidMMn0kk7A==
X-IronPort-AV: E=McAfee;i="6000,8403,9874"; a="179844618"
X-IronPort-AV: E=Sophos;i="5.79,373,1602572400"; 
   d="scan'208";a="179844618"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jan 2021 01:37:18 -0800
IronPort-SDR: /NdZj+bUccvM0nDk8SVf22XFCf5bVAGq6J9mL22s9fes47k/d8qnlBc1gPqTetxqhu8znpOMG6
 OxaspNW7RX1g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,373,1602572400"; 
   d="scan'208";a="577321002"
Received: from silpixa00399839.ir.intel.com (HELO localhost.localdomain) ([10.237.222.142])
  by fmsmga005.fm.intel.com with ESMTP; 25 Jan 2021 01:37:16 -0800
From:   Ciara Loftus <ciara.loftus@intel.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        magnus.karlsson@intel.com, bjorn@kernel.org,
        weqaar.a.janjua@intel.com
Cc:     Ciara Loftus <ciara.loftus@intel.com>
Subject: [PATCH bpf-next 1/6] xsk: add tracepoints for packet drops
Date:   Mon, 25 Jan 2021 09:07:34 +0000
Message-Id: <20210125090739.1045-2-ciara.loftus@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210125090739.1045-1-ciara.loftus@intel.com>
References: <20210125090739.1045-1-ciara.loftus@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit introduces static perf tracepoints for AF_XDP which
report information about packet drops, such as the netdev, qid and
high level reason for the drop. The tracepoint can be
enabled/disabled by toggling
/sys/kernel/debug/tracing/events/xsk/xsk_packet_drop/enable

Signed-off-by: Ciara Loftus <ciara.loftus@intel.com>
---
 MAINTAINERS                       |  1 +
 include/linux/bpf_trace.h         |  1 +
 include/trace/events/xsk.h        | 45 +++++++++++++++++++++++++++++++
 include/uapi/linux/if_xdp.h       |  8 ++++++
 kernel/bpf/core.c                 |  1 +
 net/xdp/xsk.c                     |  5 ++++
 net/xdp/xsk_buff_pool.c           |  8 +++++-
 tools/include/uapi/linux/if_xdp.h |  8 ++++++
 8 files changed, 76 insertions(+), 1 deletion(-)
 create mode 100644 include/trace/events/xsk.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 1df56a32d2df..efe6662d4198 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -19440,6 +19440,7 @@ S:	Maintained
 F:	Documentation/networking/af_xdp.rst
 F:	include/net/xdp_sock*
 F:	include/net/xsk_buff_pool.h
+F:	include/trace/events/xsk.h
 F:	include/uapi/linux/if_xdp.h
 F:	include/uapi/linux/xdp_diag.h
 F:	include/net/netns/xdp.h
diff --git a/include/linux/bpf_trace.h b/include/linux/bpf_trace.h
index ddf896abcfb6..477d29b6c2c1 100644
--- a/include/linux/bpf_trace.h
+++ b/include/linux/bpf_trace.h
@@ -3,5 +3,6 @@
 #define __LINUX_BPF_TRACE_H__
 
 #include <trace/events/xdp.h>
+#include <trace/events/xsk.h>
 
 #endif /* __LINUX_BPF_TRACE_H__ */
diff --git a/include/trace/events/xsk.h b/include/trace/events/xsk.h
new file mode 100644
index 000000000000..4f5629ba1b0f
--- /dev/null
+++ b/include/trace/events/xsk.h
@@ -0,0 +1,45 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright(c) 2021 Intel Corporation. */
+
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM xsk
+
+#if !defined(_TRACE_XSK_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_XSK_H
+
+#include <linux/if_xdp.h>
+#include <linux/tracepoint.h>
+
+#define print_reason(val) \
+	__print_symbolic(val, \
+			{ XSK_TRACE_DROP_RXQ_FULL, "rxq full" }, \
+			{ XSK_TRACE_DROP_PKT_TOO_BIG, "packet too big" }, \
+			{ XSK_TRACE_DROP_FQ_EMPTY, "fq empty" }, \
+			{ XSK_TRACE_DROP_POOL_EMPTY, "xskb pool empty" }, \
+			{ XSK_TRACE_DROP_DRV_ERR_TX, "driver error on tx" })
+
+TRACE_EVENT(xsk_packet_drop,
+
+	TP_PROTO(char *name, u16 queue_id, u32 reason),
+
+	TP_ARGS(name, queue_id, reason),
+
+	TP_STRUCT__entry(
+		__field(char *, name)
+		__field(u16, queue_id)
+		__field(u32, reason)
+	),
+
+	TP_fast_assign(
+		__entry->name = name;
+		__entry->queue_id = queue_id;
+		__entry->reason = reason;
+	),
+
+	TP_printk("netdev: %s qid %u reason: %s", __entry->name,
+			__entry->queue_id, print_reason(__entry->reason))
+);
+
+#endif /* _TRACE_XSK_H */
+
+#include <trace/define_trace.h>
diff --git a/include/uapi/linux/if_xdp.h b/include/uapi/linux/if_xdp.h
index a78a8096f4ce..5f1b8bf99bb5 100644
--- a/include/uapi/linux/if_xdp.h
+++ b/include/uapi/linux/if_xdp.h
@@ -108,4 +108,12 @@ struct xdp_desc {
 
 /* UMEM descriptor is __u64 */
 
+enum xdp_trace_reasons {
+	XSK_TRACE_DROP_RXQ_FULL,
+	XSK_TRACE_DROP_PKT_TOO_BIG,
+	XSK_TRACE_DROP_FQ_EMPTY,
+	XSK_TRACE_DROP_POOL_EMPTY,
+	XSK_TRACE_DROP_DRV_ERR_TX,
+};
+
 #endif /* _LINUX_IF_XDP_H */
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 5bbd4884ff7a..442b0d7f9bf8 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -2362,3 +2362,4 @@ EXPORT_SYMBOL(bpf_stats_enabled_key);
 
 EXPORT_TRACEPOINT_SYMBOL_GPL(xdp_exception);
 EXPORT_TRACEPOINT_SYMBOL_GPL(xdp_bulk_tx);
+EXPORT_TRACEPOINT_SYMBOL_GPL(xsk_packet_drop);
diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index 4a83117507f5..7e08f013bc99 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -11,6 +11,7 @@
 
 #define pr_fmt(fmt) "AF_XDP: %s: " fmt, __func__
 
+#include <linux/bpf_trace.h>
 #include <linux/if_xdp.h>
 #include <linux/init.h>
 #include <linux/sched/mm.h>
@@ -158,6 +159,7 @@ static int __xsk_rcv_zc(struct xdp_sock *xs, struct xdp_buff *xdp, u32 len)
 	addr = xp_get_handle(xskb);
 	err = xskq_prod_reserve_desc(xs->rx, addr, len);
 	if (err) {
+		trace_xsk_packet_drop(xs->dev->name, xs->queue_id, XSK_TRACE_DROP_RXQ_FULL);
 		xs->rx_queue_full++;
 		return err;
 	}
@@ -191,6 +193,7 @@ static int __xsk_rcv(struct xdp_sock *xs, struct xdp_buff *xdp, u32 len,
 	int err;
 
 	if (len > xsk_pool_get_rx_frame_size(xs->pool)) {
+		trace_xsk_packet_drop(xs->dev->name, xs->queue_id, XSK_TRACE_DROP_PKT_TOO_BIG);
 		xs->rx_dropped++;
 		return -ENOSPC;
 	}
@@ -501,6 +504,8 @@ static int xsk_generic_xmit(struct sock *sk)
 		if (err == NET_XMIT_DROP) {
 			/* SKB completed but not sent */
 			err = -EBUSY;
+			trace_xsk_packet_drop(xs->dev->name, xs->queue_id,
+					      XSK_TRACE_DROP_DRV_ERR_TX);
 			goto out;
 		}
 
diff --git a/net/xdp/xsk_buff_pool.c b/net/xdp/xsk_buff_pool.c
index 20598eea658c..f89f32737295 100644
--- a/net/xdp/xsk_buff_pool.c
+++ b/net/xdp/xsk_buff_pool.c
@@ -1,5 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 
+#include <linux/bpf_trace.h>
 #include <net/xsk_buff_pool.h>
 #include <net/xdp_sock.h>
 #include <net/xdp_sock_drv.h>
@@ -451,8 +452,11 @@ static struct xdp_buff_xsk *__xp_alloc(struct xsk_buff_pool *pool)
 	u64 addr;
 	bool ok;
 
-	if (pool->free_heads_cnt == 0)
+	if (pool->free_heads_cnt == 0) {
+		trace_xsk_packet_drop(pool->netdev->name, pool->queue_id,
+				      XSK_TRACE_DROP_POOL_EMPTY);
 		return NULL;
+	}
 
 	xskb = pool->free_heads[--pool->free_heads_cnt];
 
@@ -460,6 +464,8 @@ static struct xdp_buff_xsk *__xp_alloc(struct xsk_buff_pool *pool)
 		if (!xskq_cons_peek_addr_unchecked(pool->fq, &addr)) {
 			pool->fq->queue_empty_descs++;
 			xp_release(xskb);
+			trace_xsk_packet_drop(pool->netdev->name, pool->queue_id,
+					      XSK_TRACE_DROP_FQ_EMPTY);
 			return NULL;
 		}
 
diff --git a/tools/include/uapi/linux/if_xdp.h b/tools/include/uapi/linux/if_xdp.h
index a78a8096f4ce..5f1b8bf99bb5 100644
--- a/tools/include/uapi/linux/if_xdp.h
+++ b/tools/include/uapi/linux/if_xdp.h
@@ -108,4 +108,12 @@ struct xdp_desc {
 
 /* UMEM descriptor is __u64 */
 
+enum xdp_trace_reasons {
+	XSK_TRACE_DROP_RXQ_FULL,
+	XSK_TRACE_DROP_PKT_TOO_BIG,
+	XSK_TRACE_DROP_FQ_EMPTY,
+	XSK_TRACE_DROP_POOL_EMPTY,
+	XSK_TRACE_DROP_DRV_ERR_TX,
+};
+
 #endif /* _LINUX_IF_XDP_H */
-- 
2.17.1

