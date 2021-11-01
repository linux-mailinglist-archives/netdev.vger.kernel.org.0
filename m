Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4788441447
	for <lists+netdev@lfdr.de>; Mon,  1 Nov 2021 08:40:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231213AbhKAHnU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 03:43:20 -0400
Received: from out30-133.freemail.mail.aliyun.com ([115.124.30.133]:59393 "EHLO
        out30-133.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229933AbhKAHnQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Nov 2021 03:43:16 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R361e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=tonylu@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0UuWIaRW_1635752440;
Received: from localhost(mailfrom:tonylu@linux.alibaba.com fp:SMTPD_---0UuWIaRW_1635752440)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 01 Nov 2021 15:40:41 +0800
From:   Tony Lu <tonylu@linux.alibaba.com>
To:     kgraul@linux.ibm.com
Cc:     kuba@kernel.org, davem@davemloft.net, guwen@linux.alibaba.com,
        dust.li@linux.alibaba.com, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: [PATCH net-next 1/3] net/smc: Introduce tracepoint for fallback
Date:   Mon,  1 Nov 2021 15:39:12 +0800
Message-Id: <20211101073912.60410-2-tonylu@linux.alibaba.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211101073912.60410-1-tonylu@linux.alibaba.com>
References: <20211101073912.60410-1-tonylu@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This introduces tracepoint for smc fallback to TCP, so that we can track
which connection and why it fallbacks, and map the clcsocks' pointer with
/proc/net/tcp to find more details about TCP connections. Compared with
kprobe or other dynamic tracing, tracepoints are stable and easy to use.

Signed-off-by: Tony Lu <tonylu@linux.alibaba.com>
Reviewed-by: Wen Gu <guwen@linux.alibaba.com>
---
 net/smc/Makefile         |  2 ++
 net/smc/af_smc.c         |  2 ++
 net/smc/smc_tracepoint.c |  6 +++++
 net/smc/smc_tracepoint.h | 49 ++++++++++++++++++++++++++++++++++++++++
 4 files changed, 59 insertions(+)
 create mode 100644 net/smc/smc_tracepoint.c
 create mode 100644 net/smc/smc_tracepoint.h

diff --git a/net/smc/Makefile b/net/smc/Makefile
index 99a0186cba5b..196fb6f01b14 100644
--- a/net/smc/Makefile
+++ b/net/smc/Makefile
@@ -1,5 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0-only
+ccflags-y += -I$(src)
 obj-$(CONFIG_SMC)	+= smc.o
 obj-$(CONFIG_SMC_DIAG)	+= smc_diag.o
 smc-y := af_smc.o smc_pnet.o smc_ib.o smc_clc.o smc_core.o smc_wr.o smc_llc.o
 smc-y += smc_cdc.o smc_tx.o smc_rx.o smc_close.o smc_ism.o smc_netlink.o smc_stats.o
+smc-y += smc_tracepoint.o
diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index 8dc34388b2c1..0cf7ed2f5d41 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -50,6 +50,7 @@
 #include "smc_rx.h"
 #include "smc_close.h"
 #include "smc_stats.h"
+#include "smc_tracepoint.h"
 
 static DEFINE_MUTEX(smc_server_lgr_pending);	/* serialize link group
 						 * creation on server
@@ -564,6 +565,7 @@ static void smc_switch_to_fallback(struct smc_sock *smc, int reason_code)
 	smc->use_fallback = true;
 	smc->fallback_rsn = reason_code;
 	smc_stat_fallback(smc);
+	trace_smc_switch_to_fallback(smc, reason_code);
 	if (smc->sk.sk_socket && smc->sk.sk_socket->file) {
 		smc->clcsock->file = smc->sk.sk_socket->file;
 		smc->clcsock->file->private_data = smc->clcsock;
diff --git a/net/smc/smc_tracepoint.c b/net/smc/smc_tracepoint.c
new file mode 100644
index 000000000000..861a41644971
--- /dev/null
+++ b/net/smc/smc_tracepoint.c
@@ -0,0 +1,6 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+#define CREATE_TRACE_POINTS
+#include "smc_tracepoint.h"
+
+EXPORT_TRACEPOINT_SYMBOL(smc_switch_to_fallback);
diff --git a/net/smc/smc_tracepoint.h b/net/smc/smc_tracepoint.h
new file mode 100644
index 000000000000..3bc97f5f2134
--- /dev/null
+++ b/net/smc/smc_tracepoint.h
@@ -0,0 +1,49 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM smc
+
+#if !defined(_TRACE_SMC_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_SMC_H
+
+#include <linux/ipv6.h>
+#include <linux/tcp.h>
+#include <linux/tracepoint.h>
+#include <net/ipv6.h>
+#include "smc.h"
+#include "smc_core.h"
+
+TRACE_EVENT(smc_switch_to_fallback,
+
+	    TP_PROTO(const struct smc_sock *smc, int fallback_rsn),
+
+	    TP_ARGS(smc, fallback_rsn),
+
+	    TP_STRUCT__entry(
+			     __field(const void *, sk)
+			     __field(const void *, clcsk)
+			     __field(int, fallback_rsn)
+	    ),
+
+	    TP_fast_assign(
+			   const struct sock *sk = &smc->sk;
+			   const struct sock *clcsk = smc->clcsock->sk;
+
+			   __entry->sk = sk;
+			   __entry->clcsk = clcsk;
+			   __entry->fallback_rsn = fallback_rsn;
+	    ),
+
+	    TP_printk("sk=%p clcsk=%p fallback_rsn=%d",
+		      __entry->sk, __entry->clcsk, __entry->fallback_rsn)
+);
+
+#endif /* _TRACE_SMC_H */
+
+#undef TRACE_INCLUDE_PATH
+#define TRACE_INCLUDE_PATH .
+
+#undef TRACE_INCLUDE_FILE
+#define TRACE_INCLUDE_FILE smc_tracepoint
+
+#include <trace/define_trace.h>
-- 
2.19.1.6.gb485710b

