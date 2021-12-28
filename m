Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D4F4480969
	for <lists+netdev@lfdr.de>; Tue, 28 Dec 2021 14:07:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231965AbhL1NHM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Dec 2021 08:07:12 -0500
Received: from out30-56.freemail.mail.aliyun.com ([115.124.30.56]:41222 "EHLO
        out30-56.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232035AbhL1NHJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Dec 2021 08:07:09 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R931e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=tonylu@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0V06pjRo_1640696826;
Received: from localhost(mailfrom:tonylu@linux.alibaba.com fp:SMTPD_---0V06pjRo_1640696826)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 28 Dec 2021 21:07:07 +0800
From:   Tony Lu <tonylu@linux.alibaba.com>
To:     kgraul@linux.ibm.com
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: [PATCH 3/4] net/smc: Print net namespace in log
Date:   Tue, 28 Dec 2021 21:06:11 +0800
Message-Id: <20211228130611.19124-4-tonylu@linux.alibaba.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211228130611.19124-1-tonylu@linux.alibaba.com>
References: <20211228130611.19124-1-tonylu@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds net namespace ID to the kernel log, net_cookie is unique in
the whole system. It is useful in container environment.

Signed-off-by: Tony Lu <tonylu@linux.alibaba.com>
---
 net/smc/smc_core.c |  4 ++--
 net/smc/smc_llc.c  | 19 ++++++++++++-------
 2 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index b9d6148d1287..42be10d9c780 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -1537,9 +1537,9 @@ void smcr_lgr_set_type(struct smc_link_group *lgr, enum smc_lgr_type new_type)
 		lgr_type = "ASYMMETRIC_LOCAL";
 		break;
 	}
-	pr_warn_ratelimited("smc: SMC-R lg %*phN state changed: "
+	pr_warn_ratelimited("smc: SMC-R lg %*phN net %llu state changed: "
 			    "%s, pnetid %.16s\n", SMC_LGR_ID_SIZE, &lgr->id,
-			    lgr_type, lgr->pnet_id);
+			    lgr->net->net_cookie, lgr_type, lgr->pnet_id);
 }
 
 /* set new lgr type and tag a link as asymmetric */
diff --git a/net/smc/smc_llc.c b/net/smc/smc_llc.c
index b102680296b8..991ace8e316b 100644
--- a/net/smc/smc_llc.c
+++ b/net/smc/smc_llc.c
@@ -242,9 +242,10 @@ static void smc_llc_flow_parallel(struct smc_link_group *lgr, u8 flow_type,
 	}
 	/* drop parallel or already-in-progress llc requests */
 	if (flow_type != msg_type)
-		pr_warn_once("smc: SMC-R lg %*phN dropped parallel "
+		pr_warn_once("smc: SMC-R lg %*phN net %llu dropped parallel "
 			     "LLC msg: msg %d flow %d role %d\n",
 			     SMC_LGR_ID_SIZE, &lgr->id,
+			     lgr->net->net_cookie,
 			     qentry->msg.raw.hdr.common.type,
 			     flow_type, lgr->role);
 	kfree(qentry);
@@ -359,9 +360,10 @@ struct smc_llc_qentry *smc_llc_wait(struct smc_link_group *lgr,
 					   smc_llc_flow_qentry_clr(flow));
 			return NULL;
 		}
-		pr_warn_once("smc: SMC-R lg %*phN dropped unexpected LLC msg: "
+		pr_warn_once("smc: SMC-R lg %*phN net %llu dropped unexpected LLC msg: "
 			     "msg %d exp %d flow %d role %d flags %x\n",
-			     SMC_LGR_ID_SIZE, &lgr->id, rcv_msg, exp_msg,
+			     SMC_LGR_ID_SIZE, &lgr->id, lgr->net->net_cookie,
+			     rcv_msg, exp_msg,
 			     flow->type, lgr->role,
 			     flow->qentry->msg.raw.hdr.flags);
 		smc_llc_flow_qentry_del(flow);
@@ -1816,8 +1818,9 @@ static void smc_llc_rmt_delete_rkey(struct smc_link_group *lgr)
 
 static void smc_llc_protocol_violation(struct smc_link_group *lgr, u8 type)
 {
-	pr_warn_ratelimited("smc: SMC-R lg %*phN LLC protocol violation: "
-			    "llc_type %d\n", SMC_LGR_ID_SIZE, &lgr->id, type);
+	pr_warn_ratelimited("smc: SMC-R lg %*phN net %llu LLC protocol violation: "
+			    "llc_type %d\n", SMC_LGR_ID_SIZE, &lgr->id,
+			    lgr->net->net_cookie, type);
 	smc_llc_set_termination_rsn(lgr, SMC_LLC_DEL_PROT_VIOL);
 	smc_lgr_terminate_sched(lgr);
 }
@@ -2146,9 +2149,10 @@ int smc_llc_link_init(struct smc_link *link)
 
 void smc_llc_link_active(struct smc_link *link)
 {
-	pr_warn_ratelimited("smc: SMC-R lg %*phN link added: id %*phN, "
+	pr_warn_ratelimited("smc: SMC-R lg %*phN net %llu link added: id %*phN, "
 			    "peerid %*phN, ibdev %s, ibport %d\n",
 			    SMC_LGR_ID_SIZE, &link->lgr->id,
+			    link->lgr->net->net_cookie,
 			    SMC_LGR_ID_SIZE, &link->link_uid,
 			    SMC_LGR_ID_SIZE, &link->peer_link_uid,
 			    link->smcibdev->ibdev->name, link->ibport);
@@ -2164,9 +2168,10 @@ void smc_llc_link_active(struct smc_link *link)
 void smc_llc_link_clear(struct smc_link *link, bool log)
 {
 	if (log)
-		pr_warn_ratelimited("smc: SMC-R lg %*phN link removed: id %*phN"
+		pr_warn_ratelimited("smc: SMC-R lg %*phN net %llu link removed: id %*phN"
 				    ", peerid %*phN, ibdev %s, ibport %d\n",
 				    SMC_LGR_ID_SIZE, &link->lgr->id,
+				    link->lgr->net->net_cookie,
 				    SMC_LGR_ID_SIZE, &link->link_uid,
 				    SMC_LGR_ID_SIZE, &link->peer_link_uid,
 				    link->smcibdev->ibdev->name, link->ibport);
-- 
2.32.0.3.g01195cf9f

