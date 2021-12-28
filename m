Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF7E9480966
	for <lists+netdev@lfdr.de>; Tue, 28 Dec 2021 14:07:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232119AbhL1NHL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Dec 2021 08:07:11 -0500
Received: from out30-44.freemail.mail.aliyun.com ([115.124.30.44]:36963 "EHLO
        out30-44.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232060AbhL1NHK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Dec 2021 08:07:10 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R961e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=tonylu@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0V06pjS-_1640696827;
Received: from localhost(mailfrom:tonylu@linux.alibaba.com fp:SMTPD_---0V06pjS-_1640696827)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 28 Dec 2021 21:07:07 +0800
From:   Tony Lu <tonylu@linux.alibaba.com>
To:     kgraul@linux.ibm.com
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: [PATCH 4/4] net/smc: Add net namespace for tracepoints
Date:   Tue, 28 Dec 2021 21:06:12 +0800
Message-Id: <20211228130611.19124-5-tonylu@linux.alibaba.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211228130611.19124-1-tonylu@linux.alibaba.com>
References: <20211228130611.19124-1-tonylu@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This prints net namespace ID, helps us to distinguish different net
namespaces when using tracepoints.

Signed-off-by: Tony Lu <tonylu@linux.alibaba.com>
---
 net/smc/smc_tracepoint.h | 23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

diff --git a/net/smc/smc_tracepoint.h b/net/smc/smc_tracepoint.h
index ec17f29646f5..9fc5e586d24a 100644
--- a/net/smc/smc_tracepoint.h
+++ b/net/smc/smc_tracepoint.h
@@ -22,6 +22,7 @@ TRACE_EVENT(smc_switch_to_fallback,
 	    TP_STRUCT__entry(
 			     __field(const void *, sk)
 			     __field(const void *, clcsk)
+			     __field(u64, net_cookie)
 			     __field(int, fallback_rsn)
 	    ),
 
@@ -31,11 +32,13 @@ TRACE_EVENT(smc_switch_to_fallback,
 
 			   __entry->sk = sk;
 			   __entry->clcsk = clcsk;
+			   __entry->net_cookie = sock_net(sk)->net_cookie;
 			   __entry->fallback_rsn = fallback_rsn;
 	    ),
 
-	    TP_printk("sk=%p clcsk=%p fallback_rsn=%d",
-		      __entry->sk, __entry->clcsk, __entry->fallback_rsn)
+	    TP_printk("sk=%p clcsk=%p net=%llu fallback_rsn=%d",
+		      __entry->sk, __entry->clcsk,
+		      __entry->net_cookie, __entry->fallback_rsn)
 );
 
 DECLARE_EVENT_CLASS(smc_msg_event,
@@ -46,19 +49,23 @@ DECLARE_EVENT_CLASS(smc_msg_event,
 
 		    TP_STRUCT__entry(
 				     __field(const void *, smc)
+				     __field(u64, net_cookie)
 				     __field(size_t, len)
 				     __string(name, smc->conn.lnk->ibname)
 		    ),
 
 		    TP_fast_assign(
+				   const struct sock *sk = &smc->sk;
+
 				   __entry->smc = smc;
+				   __entry->net_cookie = sock_net(sk)->net_cookie;
 				   __entry->len = len;
 				   __assign_str(name, smc->conn.lnk->ibname);
 		    ),
 
-		    TP_printk("smc=%p len=%zu dev=%s",
-			      __entry->smc, __entry->len,
-			      __get_str(name))
+		    TP_printk("smc=%p net=%llu len=%zu dev=%s",
+			      __entry->smc, __entry->net_cookie,
+			      __entry->len, __get_str(name))
 );
 
 DEFINE_EVENT(smc_msg_event, smc_tx_sendmsg,
@@ -84,6 +91,7 @@ TRACE_EVENT(smcr_link_down,
 	    TP_STRUCT__entry(
 			     __field(const void *, lnk)
 			     __field(const void *, lgr)
+			     __field(u64, net_cookie)
 			     __field(int, state)
 			     __string(name, lnk->ibname)
 			     __field(void *, location)
@@ -94,13 +102,14 @@ TRACE_EVENT(smcr_link_down,
 
 			   __entry->lnk = lnk;
 			   __entry->lgr = lgr;
+			   __entry->net_cookie = lgr->net->net_cookie;
 			   __entry->state = lnk->state;
 			   __assign_str(name, lnk->ibname);
 			   __entry->location = location;
 	    ),
 
-	    TP_printk("lnk=%p lgr=%p state=%d dev=%s location=%pS",
-		      __entry->lnk, __entry->lgr,
+	    TP_printk("lnk=%p lgr=%p net=%llu state=%d dev=%s location=%pS",
+		      __entry->lnk, __entry->lgr, __entry->net_cookie,
 		      __entry->state, __get_str(name),
 		      __entry->location)
 );
-- 
2.32.0.3.g01195cf9f

