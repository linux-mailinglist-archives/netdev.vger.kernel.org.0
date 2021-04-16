Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDBD6362B2B
	for <lists+netdev@lfdr.de>; Sat, 17 Apr 2021 00:40:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234867AbhDPWjA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 18:39:00 -0400
Received: from mga01.intel.com ([192.55.52.88]:38339 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234654AbhDPWiu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Apr 2021 18:38:50 -0400
IronPort-SDR: p/ogEMuRH47kJQRfXBrasjP34cG9cstdXzKRndSZaflyZWnDxVVwBNXAHtysllZE7orkSDC6Kh
 VUbUGpEFcwGg==
X-IronPort-AV: E=McAfee;i="6200,9189,9956"; a="215670606"
X-IronPort-AV: E=Sophos;i="5.82,228,1613462400"; 
   d="scan'208";a="215670606"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2021 15:38:17 -0700
IronPort-SDR: cCiJlEMvAC3f2Vu03CHI5SvgNxgnrS14pJYYPOHUXGG8G+bxhjrtmtAtAXHHCVe2W45XrloeYr
 1J2VMVp4eSJA==
X-IronPort-AV: E=Sophos;i="5.82,228,1613462400"; 
   d="scan'208";a="462107392"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.209.43.70])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2021 15:38:17 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Geliang Tang <geliangtang@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev, Paolo Abeni <pabeni@redhat.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 4/8] mptcp: add tracepoint in mptcp_subflow_get_send
Date:   Fri, 16 Apr 2021 15:38:04 -0700
Message-Id: <20210416223808.298842-5-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210416223808.298842-1-mathew.j.martineau@linux.intel.com>
References: <20210416223808.298842-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geliang Tang <geliangtang@gmail.com>

This patch added a tracepoint in the packet scheduler function
mptcp_subflow_get_send().

Suggested-by: Paolo Abeni <pabeni@redhat.com>
Acked-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Geliang Tang <geliangtang@gmail.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 MAINTAINERS                  |  1 +
 include/trace/events/mptcp.h | 60 ++++++++++++++++++++++++++++++++++++
 net/mptcp/protocol.c         |  8 ++---
 3 files changed, 65 insertions(+), 4 deletions(-)
 create mode 100644 include/trace/events/mptcp.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 795b9941c151..0f82854cc430 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -12546,6 +12546,7 @@ W:	https://github.com/multipath-tcp/mptcp_net-next/wiki
 B:	https://github.com/multipath-tcp/mptcp_net-next/issues
 F:	Documentation/networking/mptcp-sysctl.rst
 F:	include/net/mptcp.h
+F:	include/trace/events/mptcp.h
 F:	include/uapi/linux/mptcp.h
 F:	net/mptcp/
 F:	tools/testing/selftests/net/mptcp/
diff --git a/include/trace/events/mptcp.h b/include/trace/events/mptcp.h
new file mode 100644
index 000000000000..b1617a0162da
--- /dev/null
+++ b/include/trace/events/mptcp.h
@@ -0,0 +1,60 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM mptcp
+
+#if !defined(_TRACE_MPTCP_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_MPTCP_H
+
+#include <linux/tracepoint.h>
+
+TRACE_EVENT(mptcp_subflow_get_send,
+
+	TP_PROTO(struct mptcp_subflow_context *subflow),
+
+	TP_ARGS(subflow),
+
+	TP_STRUCT__entry(
+		__field(bool, active)
+		__field(bool, free)
+		__field(u32, snd_wnd)
+		__field(u32, pace)
+		__field(u8, backup)
+		__field(u64, ratio)
+	),
+
+	TP_fast_assign(
+		struct sock *ssk;
+
+		__entry->active = mptcp_subflow_active(subflow);
+		__entry->backup = subflow->backup;
+
+		if (subflow->tcp_sock && sk_fullsock(subflow->tcp_sock))
+			__entry->free = sk_stream_memory_free(subflow->tcp_sock);
+		else
+			__entry->free = 0;
+
+		ssk = mptcp_subflow_tcp_sock(subflow);
+		if (ssk && sk_fullsock(ssk)) {
+			__entry->snd_wnd = tcp_sk(ssk)->snd_wnd;
+			__entry->pace = ssk->sk_pacing_rate;
+		} else {
+			__entry->snd_wnd = 0;
+			__entry->pace = 0;
+		}
+
+		if (ssk && sk_fullsock(ssk) && __entry->pace)
+			__entry->ratio = div_u64((u64)ssk->sk_wmem_queued << 32, __entry->pace);
+		else
+			__entry->ratio = 0;
+	),
+
+	TP_printk("active=%d free=%d snd_wnd=%u pace=%u backup=%u ratio=%llu",
+		  __entry->active, __entry->free,
+		  __entry->snd_wnd, __entry->pace,
+		  __entry->backup, __entry->ratio)
+);
+
+#endif /* _TRACE_MPTCP_H */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 5a05c6ca943c..e26ea143754d 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -25,6 +25,9 @@
 #include "protocol.h"
 #include "mib.h"
 
+#define CREATE_TRACE_POINTS
+#include <trace/events/mptcp.h>
+
 #if IS_ENABLED(CONFIG_MPTCP_IPV6)
 struct mptcp6_sock {
 	struct mptcp_sock msk;
@@ -1410,6 +1413,7 @@ static struct sock *mptcp_subflow_get_send(struct mptcp_sock *msk)
 		send_info[i].ratio = -1;
 	}
 	mptcp_for_each_subflow(msk, subflow) {
+		trace_mptcp_subflow_get_send(subflow);
 		ssk =  mptcp_subflow_tcp_sock(subflow);
 		if (!mptcp_subflow_active(subflow))
 			continue;
@@ -1430,10 +1434,6 @@ static struct sock *mptcp_subflow_get_send(struct mptcp_sock *msk)
 		}
 	}
 
-	pr_debug("msk=%p nr_active=%d ssk=%p:%lld backup=%p:%lld",
-		 msk, nr_active, send_info[0].ssk, send_info[0].ratio,
-		 send_info[1].ssk, send_info[1].ratio);
-
 	/* pick the best backup if no other subflow is active */
 	if (!nr_active)
 		send_info[0].ssk = send_info[1].ssk;
-- 
2.31.1

