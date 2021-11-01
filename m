Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11D0D441449
	for <lists+netdev@lfdr.de>; Mon,  1 Nov 2021 08:41:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230097AbhKAHne (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 03:43:34 -0400
Received: from out30-130.freemail.mail.aliyun.com ([115.124.30.130]:39366 "EHLO
        out30-130.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231195AbhKAHnd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Nov 2021 03:43:33 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R481e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=tonylu@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0UuVtx88_1635752458;
Received: from localhost(mailfrom:tonylu@linux.alibaba.com fp:SMTPD_---0UuVtx88_1635752458)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 01 Nov 2021 15:40:58 +0800
From:   Tony Lu <tonylu@linux.alibaba.com>
To:     kgraul@linux.ibm.com
Cc:     kuba@kernel.org, davem@davemloft.net, guwen@linux.alibaba.com,
        dust.li@linux.alibaba.com, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: [PATCH net-next 2/3] net/smc: Introduce tracepoints for tx and rx msg
Date:   Mon,  1 Nov 2021 15:39:14 +0800
Message-Id: <20211101073912.60410-3-tonylu@linux.alibaba.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211101073912.60410-1-tonylu@linux.alibaba.com>
References: <20211101073912.60410-1-tonylu@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This introduce two tracepoints for smc tx and rx msg to help us
diagnosis issues of data path. These two tracepoitns don't cover the
path of CORK or MSG_MORE in tx, just the top half of data path.

Signed-off-by: Tony Lu <tonylu@linux.alibaba.com>
Reviewed-by: Wen Gu <guwen@linux.alibaba.com>
---
 net/smc/smc_rx.c         |  3 +++
 net/smc/smc_tracepoint.c |  2 ++
 net/smc/smc_tracepoint.h | 37 +++++++++++++++++++++++++++++++++++++
 net/smc/smc_tx.c         |  3 +++
 4 files changed, 45 insertions(+)

diff --git a/net/smc/smc_rx.c b/net/smc/smc_rx.c
index 170b733bc736..51e8eb2933ff 100644
--- a/net/smc/smc_rx.c
+++ b/net/smc/smc_rx.c
@@ -22,6 +22,7 @@
 #include "smc_tx.h" /* smc_tx_consumer_update() */
 #include "smc_rx.h"
 #include "smc_stats.h"
+#include "smc_tracepoint.h"
 
 /* callback implementation to wakeup consumers blocked with smc_rx_wait().
  * indirectly called by smc_cdc_msg_recv_action().
@@ -438,6 +439,8 @@ int smc_rx_recvmsg(struct smc_sock *smc, struct msghdr *msg,
 			if (msg && smc_rx_update_consumer(smc, cons, copylen))
 				goto out;
 		}
+
+		trace_smc_rx_recvmsg(smc, copylen);
 	} while (read_remaining);
 out:
 	return read_done;
diff --git a/net/smc/smc_tracepoint.c b/net/smc/smc_tracepoint.c
index 861a41644971..af031811ddb3 100644
--- a/net/smc/smc_tracepoint.c
+++ b/net/smc/smc_tracepoint.c
@@ -4,3 +4,5 @@
 #include "smc_tracepoint.h"
 
 EXPORT_TRACEPOINT_SYMBOL(smc_switch_to_fallback);
+EXPORT_TRACEPOINT_SYMBOL(smc_tx_sendmsg);
+EXPORT_TRACEPOINT_SYMBOL(smc_rx_recvmsg);
diff --git a/net/smc/smc_tracepoint.h b/net/smc/smc_tracepoint.h
index 3bc97f5f2134..eced1546afae 100644
--- a/net/smc/smc_tracepoint.h
+++ b/net/smc/smc_tracepoint.h
@@ -38,6 +38,43 @@ TRACE_EVENT(smc_switch_to_fallback,
 		      __entry->sk, __entry->clcsk, __entry->fallback_rsn)
 );
 
+DECLARE_EVENT_CLASS(smc_msg_event,
+
+		    TP_PROTO(const struct smc_sock *smc, size_t len),
+
+		    TP_ARGS(smc, len),
+
+		    TP_STRUCT__entry(
+				     __field(const void *, smc)
+				     __field(size_t, len)
+				     __string(name, smc->conn.lnk->ibname)
+		    ),
+
+		    TP_fast_assign(
+				   __entry->smc = smc;
+				   __entry->len = len;
+				   __assign_str(name, smc->conn.lnk->ibname);
+		    ),
+
+		    TP_printk("smc=%p len=%zu dev=%s",
+			      __entry->smc, __entry->len,
+			      __get_str(name))
+);
+
+DEFINE_EVENT(smc_msg_event, smc_tx_sendmsg,
+
+	     TP_PROTO(const struct smc_sock *smc, size_t len),
+
+	     TP_ARGS(smc, len)
+);
+
+DEFINE_EVENT(smc_msg_event, smc_rx_recvmsg,
+
+	     TP_PROTO(const struct smc_sock *smc, size_t len),
+
+	     TP_ARGS(smc, len)
+);
+
 #endif /* _TRACE_SMC_H */
 
 #undef TRACE_INCLUDE_PATH
diff --git a/net/smc/smc_tx.c b/net/smc/smc_tx.c
index 738a4a99c827..be241d53020f 100644
--- a/net/smc/smc_tx.c
+++ b/net/smc/smc_tx.c
@@ -28,6 +28,7 @@
 #include "smc_ism.h"
 #include "smc_tx.h"
 #include "smc_stats.h"
+#include "smc_tracepoint.h"
 
 #define SMC_TX_WORK_DELAY	0
 #define SMC_TX_CORK_DELAY	(HZ >> 2)	/* 250 ms */
@@ -245,6 +246,8 @@ int smc_tx_sendmsg(struct smc_sock *smc, struct msghdr *msg, size_t len)
 					   SMC_TX_CORK_DELAY);
 		else
 			smc_tx_sndbuf_nonempty(conn);
+
+		trace_smc_tx_sendmsg(smc, copylen);
 	} /* while (msg_data_left(msg)) */
 
 	return send_done;
-- 
2.19.1.6.gb485710b

