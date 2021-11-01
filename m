Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0364944144E
	for <lists+netdev@lfdr.de>; Mon,  1 Nov 2021 08:41:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230289AbhKAHoK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 03:44:10 -0400
Received: from out30-133.freemail.mail.aliyun.com ([115.124.30.133]:55027 "EHLO
        out30-133.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231133AbhKAHoJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Nov 2021 03:44:09 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=tonylu@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0UuVlCTD_1635752494;
Received: from localhost(mailfrom:tonylu@linux.alibaba.com fp:SMTPD_---0UuVlCTD_1635752494)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 01 Nov 2021 15:41:35 +0800
From:   Tony Lu <tonylu@linux.alibaba.com>
To:     kgraul@linux.ibm.com
Cc:     kuba@kernel.org, davem@davemloft.net, guwen@linux.alibaba.com,
        dust.li@linux.alibaba.com, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: [PATCH net-next 3/3] net/smc: Introduce tracepoint for smcr link down
Date:   Mon,  1 Nov 2021 15:39:16 +0800
Message-Id: <20211101073912.60410-4-tonylu@linux.alibaba.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211101073912.60410-1-tonylu@linux.alibaba.com>
References: <20211101073912.60410-1-tonylu@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SMC-R link down event is important to help us find links' issues, we
should track this event, especially in the single nic mode, which means
upper layer connection would be shut down. Then find out the direct
link-down reason in time, not only increased the counter, also the
location of the code who triggered this event.

Signed-off-by: Tony Lu <tonylu@linux.alibaba.com>
Reviewed-by: Wen Gu <guwen@linux.alibaba.com>
---
 net/smc/smc_core.c       |  9 +++++++--
 net/smc/smc_tracepoint.c |  1 +
 net/smc/smc_tracepoint.h | 30 ++++++++++++++++++++++++++++++
 3 files changed, 38 insertions(+), 2 deletions(-)

diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index 8e642f8f334f..49b8ba3bb683 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -34,6 +34,7 @@
 #include "smc_ism.h"
 #include "smc_netlink.h"
 #include "smc_stats.h"
+#include "smc_tracepoint.h"
 
 #define SMC_LGR_NUM_INCR		256
 #define SMC_LGR_FREE_DELAY_SERV		(600 * HZ)
@@ -1620,15 +1621,19 @@ static void smcr_link_down(struct smc_link *lnk)
 /* must be called under lgr->llc_conf_mutex lock */
 void smcr_link_down_cond(struct smc_link *lnk)
 {
-	if (smc_link_downing(&lnk->state))
+	if (smc_link_downing(&lnk->state)) {
+		trace_smcr_link_down(lnk, __builtin_return_address(0));
 		smcr_link_down(lnk);
+	}
 }
 
 /* will get the lgr->llc_conf_mutex lock */
 void smcr_link_down_cond_sched(struct smc_link *lnk)
 {
-	if (smc_link_downing(&lnk->state))
+	if (smc_link_downing(&lnk->state)) {
+		trace_smcr_link_down(lnk, __builtin_return_address(0));
 		schedule_work(&lnk->link_down_wrk);
+	}
 }
 
 void smcr_port_err(struct smc_ib_device *smcibdev, u8 ibport)
diff --git a/net/smc/smc_tracepoint.c b/net/smc/smc_tracepoint.c
index af031811ddb3..8d47ced5a492 100644
--- a/net/smc/smc_tracepoint.c
+++ b/net/smc/smc_tracepoint.c
@@ -6,3 +6,4 @@
 EXPORT_TRACEPOINT_SYMBOL(smc_switch_to_fallback);
 EXPORT_TRACEPOINT_SYMBOL(smc_tx_sendmsg);
 EXPORT_TRACEPOINT_SYMBOL(smc_rx_recvmsg);
+EXPORT_TRACEPOINT_SYMBOL(smcr_link_down);
diff --git a/net/smc/smc_tracepoint.h b/net/smc/smc_tracepoint.h
index eced1546afae..b4c36795a928 100644
--- a/net/smc/smc_tracepoint.h
+++ b/net/smc/smc_tracepoint.h
@@ -75,6 +75,36 @@ DEFINE_EVENT(smc_msg_event, smc_rx_recvmsg,
 	     TP_ARGS(smc, len)
 );
 
+TRACE_EVENT(smcr_link_down,
+
+	    TP_PROTO(const struct smc_link *lnk, void *location),
+
+	    TP_ARGS(lnk, location),
+
+	    TP_STRUCT__entry(
+			     __field(const void *, lnk)
+			     __field(const void *, lgr)
+			     __field(int, state)
+			     __string(name, lnk->ibname)
+			     __field(void *, location)
+	    ),
+
+	    TP_fast_assign(
+			   const struct smc_link_group *lgr = lnk->lgr;
+
+			   __entry->lnk = lnk;
+			   __entry->lgr = lgr;
+			   __entry->state = lnk->state;
+			   __assign_str(name, lnk->ibname);
+			   __entry->location = location;
+	    ),
+
+	    TP_printk("lnk=%p lgr=%p state=%d dev=%s location=%p",
+		      __entry->lnk, __entry->lgr,
+		      __entry->state, __get_str(name),
+		      __entry->location)
+);
+
 #endif /* _TRACE_SMC_H */
 
 #undef TRACE_INCLUDE_PATH
-- 
2.19.1.6.gb485710b

