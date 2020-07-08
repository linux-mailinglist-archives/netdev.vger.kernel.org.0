Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9226A218AC5
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 17:05:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730092AbgGHPF1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 11:05:27 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:7952 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729868AbgGHPF0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 11:05:26 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 068F1xM4056062;
        Wed, 8 Jul 2020 11:05:22 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com with ESMTP id 325brdhr5r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Jul 2020 11:05:22 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 068Ep1MM017881;
        Wed, 8 Jul 2020 15:05:20 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06ams.nl.ibm.com with ESMTP id 322h1h4kfm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Jul 2020 15:05:20 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 068F5Hks21823492
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 8 Jul 2020 15:05:17 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4D5E8AE055;
        Wed,  8 Jul 2020 15:05:17 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 17535AE04D;
        Wed,  8 Jul 2020 15:05:17 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  8 Jul 2020 15:05:17 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: [PATCH net 1/5] net/smc: separate LLC wait queues for flow and messages
Date:   Wed,  8 Jul 2020 17:05:11 +0200
Message-Id: <20200708150515.44938-2-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200708150515.44938-1-kgraul@linux.ibm.com>
References: <20200708150515.44938-1-kgraul@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-08_12:2020-07-08,2020-07-08 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 malwarescore=0
 phishscore=0 clxscore=1015 adultscore=0 cotscore=-2147483648
 suspectscore=3 lowpriorityscore=0 bulkscore=0 mlxlogscore=999
 impostorscore=0 mlxscore=0 priorityscore=1501 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2007080103
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There might be races in scenarios where both SMC link groups are on the
same system. Prevent that by creating separate wait queues for LLC flows
and messages. Switch to non-interruptable versions of wait_event() and
wake_up() for the llc flow waiter to make sure the waiters get control
sequentially. Fine tune the llc_flow_lock to include the assignment of
the message. Write to system log when an unexpected message was
dropped. And remove an extra indirection and use the existing local
variable lgr in smc_llc_enqueue().

Fixes: 555da9af827d ("net/smc: add event-based llc_flow framework")
Reviewed-by: Ursula Braun <ubraun@linux.ibm.com>
Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
---
 net/smc/smc_core.c | 38 ++++++++++++---------
 net/smc/smc_core.h |  4 ++-
 net/smc/smc_llc.c  | 83 +++++++++++++++++++++++++++++-----------------
 3 files changed, 77 insertions(+), 48 deletions(-)

diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index 7964a21e5e6f..d695ce71837e 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -247,7 +247,8 @@ static void smcr_lgr_link_deactivate_all(struct smc_link_group *lgr)
 		if (smc_link_usable(lnk))
 			lnk->state = SMC_LNK_INACTIVE;
 	}
-	wake_up_interruptible_all(&lgr->llc_waiter);
+	wake_up_all(&lgr->llc_msg_waiter);
+	wake_up_all(&lgr->llc_flow_waiter);
 }
 
 static void smc_lgr_free(struct smc_link_group *lgr);
@@ -1130,18 +1131,19 @@ static void smcr_link_up(struct smc_link_group *lgr,
 			return;
 		if (lgr->llc_flow_lcl.type != SMC_LLC_FLOW_NONE) {
 			/* some other llc task is ongoing */
-			wait_event_interruptible_timeout(lgr->llc_waiter,
-				(lgr->llc_flow_lcl.type == SMC_LLC_FLOW_NONE),
+			wait_event_timeout(lgr->llc_flow_waiter,
+				(list_empty(&lgr->list) ||
+				 lgr->llc_flow_lcl.type == SMC_LLC_FLOW_NONE),
 				SMC_LLC_WAIT_TIME);
 		}
-		if (list_empty(&lgr->list) ||
-		    !smc_ib_port_active(smcibdev, ibport))
-			return; /* lgr or device no longer active */
-		link = smc_llc_usable_link(lgr);
-		if (!link)
-			return;
-		smc_llc_send_add_link(link, smcibdev->mac[ibport - 1], gid,
-				      NULL, SMC_LLC_REQ);
+		/* lgr or device no longer active? */
+		if (!list_empty(&lgr->list) &&
+		    smc_ib_port_active(smcibdev, ibport))
+			link = smc_llc_usable_link(lgr);
+		if (link)
+			smc_llc_send_add_link(link, smcibdev->mac[ibport - 1],
+					      gid, NULL, SMC_LLC_REQ);
+		wake_up(&lgr->llc_flow_waiter);	/* wake up next waiter */
 	}
 }
 
@@ -1195,13 +1197,17 @@ static void smcr_link_down(struct smc_link *lnk)
 		if (lgr->llc_flow_lcl.type != SMC_LLC_FLOW_NONE) {
 			/* another llc task is ongoing */
 			mutex_unlock(&lgr->llc_conf_mutex);
-			wait_event_interruptible_timeout(lgr->llc_waiter,
-				(lgr->llc_flow_lcl.type == SMC_LLC_FLOW_NONE),
+			wait_event_timeout(lgr->llc_flow_waiter,
+				(list_empty(&lgr->list) ||
+				 lgr->llc_flow_lcl.type == SMC_LLC_FLOW_NONE),
 				SMC_LLC_WAIT_TIME);
 			mutex_lock(&lgr->llc_conf_mutex);
 		}
-		smc_llc_send_delete_link(to_lnk, del_link_id, SMC_LLC_REQ, true,
-					 SMC_LLC_DEL_LOST_PATH);
+		if (!list_empty(&lgr->list))
+			smc_llc_send_delete_link(to_lnk, del_link_id,
+						 SMC_LLC_REQ, true,
+						 SMC_LLC_DEL_LOST_PATH);
+		wake_up(&lgr->llc_flow_waiter);	/* wake up next waiter */
 	}
 }
 
@@ -1262,7 +1268,7 @@ static void smc_link_down_work(struct work_struct *work)
 
 	if (list_empty(&lgr->list))
 		return;
-	wake_up_interruptible_all(&lgr->llc_waiter);
+	wake_up_all(&lgr->llc_msg_waiter);
 	mutex_lock(&lgr->llc_conf_mutex);
 	smcr_link_down(link);
 	mutex_unlock(&lgr->llc_conf_mutex);
diff --git a/net/smc/smc_core.h b/net/smc/smc_core.h
index 86d160f0d187..c3ff512fd891 100644
--- a/net/smc/smc_core.h
+++ b/net/smc/smc_core.h
@@ -262,8 +262,10 @@ struct smc_link_group {
 			struct work_struct	llc_del_link_work;
 			struct work_struct	llc_event_work;
 						/* llc event worker */
-			wait_queue_head_t	llc_waiter;
+			wait_queue_head_t	llc_flow_waiter;
 						/* w4 next llc event */
+			wait_queue_head_t	llc_msg_waiter;
+						/* w4 next llc msg */
 			struct smc_llc_flow	llc_flow_lcl;
 						/* llc local control field */
 			struct smc_llc_flow	llc_flow_rmt;
diff --git a/net/smc/smc_llc.c b/net/smc/smc_llc.c
index 391237b601fe..df164232574b 100644
--- a/net/smc/smc_llc.c
+++ b/net/smc/smc_llc.c
@@ -186,6 +186,26 @@ static inline void smc_llc_flow_qentry_set(struct smc_llc_flow *flow,
 	flow->qentry = qentry;
 }
 
+static void smc_llc_flow_parallel(struct smc_link_group *lgr, u8 flow_type,
+				  struct smc_llc_qentry *qentry)
+{
+	u8 msg_type = qentry->msg.raw.hdr.common.type;
+
+	if ((msg_type == SMC_LLC_ADD_LINK || msg_type == SMC_LLC_DELETE_LINK) &&
+	    flow_type != msg_type && !lgr->delayed_event) {
+		lgr->delayed_event = qentry;
+		return;
+	}
+	/* drop parallel or already-in-progress llc requests */
+	if (flow_type != msg_type)
+		pr_warn_once("smc: SMC-R lg %*phN dropped parallel "
+			     "LLC msg: msg %d flow %d role %d\n",
+			     SMC_LGR_ID_SIZE, &lgr->id,
+			     qentry->msg.raw.hdr.common.type,
+			     flow_type, lgr->role);
+	kfree(qentry);
+}
+
 /* try to start a new llc flow, initiated by an incoming llc msg */
 static bool smc_llc_flow_start(struct smc_llc_flow *flow,
 			       struct smc_llc_qentry *qentry)
@@ -195,14 +215,7 @@ static bool smc_llc_flow_start(struct smc_llc_flow *flow,
 	spin_lock_bh(&lgr->llc_flow_lock);
 	if (flow->type) {
 		/* a flow is already active */
-		if ((qentry->msg.raw.hdr.common.type == SMC_LLC_ADD_LINK ||
-		     qentry->msg.raw.hdr.common.type == SMC_LLC_DELETE_LINK) &&
-		    !lgr->delayed_event) {
-			lgr->delayed_event = qentry;
-		} else {
-			/* forget this llc request */
-			kfree(qentry);
-		}
+		smc_llc_flow_parallel(lgr, flow->type, qentry);
 		spin_unlock_bh(&lgr->llc_flow_lock);
 		return false;
 	}
@@ -222,8 +235,8 @@ static bool smc_llc_flow_start(struct smc_llc_flow *flow,
 	}
 	if (qentry == lgr->delayed_event)
 		lgr->delayed_event = NULL;
-	spin_unlock_bh(&lgr->llc_flow_lock);
 	smc_llc_flow_qentry_set(flow, qentry);
+	spin_unlock_bh(&lgr->llc_flow_lock);
 	return true;
 }
 
@@ -251,11 +264,11 @@ int smc_llc_flow_initiate(struct smc_link_group *lgr,
 		return 0;
 	}
 	spin_unlock_bh(&lgr->llc_flow_lock);
-	rc = wait_event_interruptible_timeout(lgr->llc_waiter,
-			(lgr->llc_flow_lcl.type == SMC_LLC_FLOW_NONE &&
-			 (lgr->llc_flow_rmt.type == SMC_LLC_FLOW_NONE ||
-			  lgr->llc_flow_rmt.type == allowed_remote)),
-			SMC_LLC_WAIT_TIME);
+	rc = wait_event_timeout(lgr->llc_flow_waiter, (list_empty(&lgr->list) ||
+				(lgr->llc_flow_lcl.type == SMC_LLC_FLOW_NONE &&
+				 (lgr->llc_flow_rmt.type == SMC_LLC_FLOW_NONE ||
+				  lgr->llc_flow_rmt.type == allowed_remote))),
+				SMC_LLC_WAIT_TIME * 10);
 	if (!rc)
 		return -ETIMEDOUT;
 	goto again;
@@ -272,7 +285,7 @@ void smc_llc_flow_stop(struct smc_link_group *lgr, struct smc_llc_flow *flow)
 	    flow == &lgr->llc_flow_lcl)
 		schedule_work(&lgr->llc_event_work);
 	else
-		wake_up_interruptible(&lgr->llc_waiter);
+		wake_up(&lgr->llc_flow_waiter);
 }
 
 /* lnk is optional and used for early wakeup when link goes down, useful in
@@ -283,26 +296,32 @@ struct smc_llc_qentry *smc_llc_wait(struct smc_link_group *lgr,
 				    int time_out, u8 exp_msg)
 {
 	struct smc_llc_flow *flow = &lgr->llc_flow_lcl;
+	u8 rcv_msg;
 
-	wait_event_interruptible_timeout(lgr->llc_waiter,
-					 (flow->qentry ||
-					  (lnk && !smc_link_usable(lnk)) ||
-					  list_empty(&lgr->list)),
-					 time_out);
+	wait_event_timeout(lgr->llc_msg_waiter,
+			   (flow->qentry ||
+			    (lnk && !smc_link_usable(lnk)) ||
+			    list_empty(&lgr->list)),
+			   time_out);
 	if (!flow->qentry ||
 	    (lnk && !smc_link_usable(lnk)) || list_empty(&lgr->list)) {
 		smc_llc_flow_qentry_del(flow);
 		goto out;
 	}
-	if (exp_msg && flow->qentry->msg.raw.hdr.common.type != exp_msg) {
+	rcv_msg = flow->qentry->msg.raw.hdr.common.type;
+	if (exp_msg && rcv_msg != exp_msg) {
 		if (exp_msg == SMC_LLC_ADD_LINK &&
-		    flow->qentry->msg.raw.hdr.common.type ==
-		    SMC_LLC_DELETE_LINK) {
+		    rcv_msg == SMC_LLC_DELETE_LINK) {
 			/* flow_start will delay the unexpected msg */
 			smc_llc_flow_start(&lgr->llc_flow_lcl,
 					   smc_llc_flow_qentry_clr(flow));
 			return NULL;
 		}
+		pr_warn_once("smc: SMC-R lg %*phN dropped unexpected LLC msg: "
+			     "msg %d exp %d flow %d role %d flags %x\n",
+			     SMC_LGR_ID_SIZE, &lgr->id, rcv_msg, exp_msg,
+			     flow->type, lgr->role,
+			     flow->qentry->msg.raw.hdr.flags);
 		smc_llc_flow_qentry_del(flow);
 	}
 out:
@@ -1459,7 +1478,7 @@ static void smc_llc_event_handler(struct smc_llc_qentry *qentry)
 				/* a flow is waiting for this message */
 				smc_llc_flow_qentry_set(&lgr->llc_flow_lcl,
 							qentry);
-				wake_up_interruptible(&lgr->llc_waiter);
+				wake_up(&lgr->llc_msg_waiter);
 			} else if (smc_llc_flow_start(&lgr->llc_flow_lcl,
 						      qentry)) {
 				schedule_work(&lgr->llc_add_link_work);
@@ -1474,7 +1493,7 @@ static void smc_llc_event_handler(struct smc_llc_qentry *qentry)
 		if (lgr->llc_flow_lcl.type != SMC_LLC_FLOW_NONE) {
 			/* a flow is waiting for this message */
 			smc_llc_flow_qentry_set(&lgr->llc_flow_lcl, qentry);
-			wake_up_interruptible(&lgr->llc_waiter);
+			wake_up(&lgr->llc_msg_waiter);
 			return;
 		}
 		break;
@@ -1485,7 +1504,7 @@ static void smc_llc_event_handler(struct smc_llc_qentry *qentry)
 				/* DEL LINK REQ during ADD LINK SEQ */
 				smc_llc_flow_qentry_set(&lgr->llc_flow_lcl,
 							qentry);
-				wake_up_interruptible(&lgr->llc_waiter);
+				wake_up(&lgr->llc_msg_waiter);
 			} else if (smc_llc_flow_start(&lgr->llc_flow_lcl,
 						      qentry)) {
 				schedule_work(&lgr->llc_del_link_work);
@@ -1496,7 +1515,7 @@ static void smc_llc_event_handler(struct smc_llc_qentry *qentry)
 				/* DEL LINK REQ during ADD LINK SEQ */
 				smc_llc_flow_qentry_set(&lgr->llc_flow_lcl,
 							qentry);
-				wake_up_interruptible(&lgr->llc_waiter);
+				wake_up(&lgr->llc_msg_waiter);
 			} else if (smc_llc_flow_start(&lgr->llc_flow_lcl,
 						      qentry)) {
 				schedule_work(&lgr->llc_del_link_work);
@@ -1581,7 +1600,7 @@ static void smc_llc_rx_response(struct smc_link *link,
 	case SMC_LLC_DELETE_RKEY:
 		/* assign responses to the local flow, we requested them */
 		smc_llc_flow_qentry_set(&link->lgr->llc_flow_lcl, qentry);
-		wake_up_interruptible(&link->lgr->llc_waiter);
+		wake_up(&link->lgr->llc_msg_waiter);
 		return;
 	case SMC_LLC_CONFIRM_RKEY_CONT:
 		/* not used because max links is 3 */
@@ -1616,7 +1635,7 @@ static void smc_llc_enqueue(struct smc_link *link, union smc_llc_msg *llc)
 	spin_lock_irqsave(&lgr->llc_event_q_lock, flags);
 	list_add_tail(&qentry->list, &lgr->llc_event_q);
 	spin_unlock_irqrestore(&lgr->llc_event_q_lock, flags);
-	schedule_work(&link->lgr->llc_event_work);
+	schedule_work(&lgr->llc_event_work);
 }
 
 /* copy received msg and add it to the event queue */
@@ -1677,7 +1696,8 @@ void smc_llc_lgr_init(struct smc_link_group *lgr, struct smc_sock *smc)
 	INIT_LIST_HEAD(&lgr->llc_event_q);
 	spin_lock_init(&lgr->llc_event_q_lock);
 	spin_lock_init(&lgr->llc_flow_lock);
-	init_waitqueue_head(&lgr->llc_waiter);
+	init_waitqueue_head(&lgr->llc_flow_waiter);
+	init_waitqueue_head(&lgr->llc_msg_waiter);
 	mutex_init(&lgr->llc_conf_mutex);
 	lgr->llc_testlink_time = net->ipv4.sysctl_tcp_keepalive_time;
 }
@@ -1686,7 +1706,8 @@ void smc_llc_lgr_init(struct smc_link_group *lgr, struct smc_sock *smc)
 void smc_llc_lgr_clear(struct smc_link_group *lgr)
 {
 	smc_llc_event_flush(lgr);
-	wake_up_interruptible_all(&lgr->llc_waiter);
+	wake_up_all(&lgr->llc_flow_waiter);
+	wake_up_all(&lgr->llc_msg_waiter);
 	cancel_work_sync(&lgr->llc_event_work);
 	cancel_work_sync(&lgr->llc_add_link_work);
 	cancel_work_sync(&lgr->llc_del_link_work);
-- 
2.17.1

