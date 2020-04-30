Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CE601BFAE0
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 15:56:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728391AbgD3N40 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 09:56:26 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:17018 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728074AbgD3N4X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 09:56:23 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03UDah17141386;
        Thu, 30 Apr 2020 09:56:13 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 30qxvqam83-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 30 Apr 2020 09:56:09 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 03UDmUra031754;
        Thu, 30 Apr 2020 13:56:07 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04ams.nl.ibm.com with ESMTP id 30mcu72qdv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 30 Apr 2020 13:56:06 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 03UDu4H559179308
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Apr 2020 13:56:04 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3A5A24C050;
        Thu, 30 Apr 2020 13:56:04 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F408C4C046;
        Thu, 30 Apr 2020 13:56:03 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 30 Apr 2020 13:56:03 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: [PATCH net-next 01/14] net/smc: add event-based llc_flow framework
Date:   Thu, 30 Apr 2020 15:55:38 +0200
Message-Id: <20200430135551.26267-2-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200430135551.26267-1-kgraul@linux.ibm.com>
References: <20200430135551.26267-1-kgraul@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-30_08:2020-04-30,2020-04-30 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 mlxscore=0
 priorityscore=1501 phishscore=0 mlxlogscore=956 suspectscore=3
 malwarescore=0 lowpriorityscore=0 impostorscore=0 bulkscore=0
 clxscore=1015 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004300106
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The new framework allows to start specific types of LLC control flows,
protects active flows and makes it possible to wait for flows to finish
before starting a new flow.
This mechanism is used for the LLC control layer to model flows like
'add link' or 'delete link' which need to send/receive several LLC
messages and are not allowed to get interrupted by the wrong type of
messages.
'Add link' or 'Delete link' messages arriving in the middle of a flow
are delayed and processed when the current flow finished.

Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
Reviewed-by: Ursula Braun <ubraun@linux.ibm.com>
---
 net/smc/smc_core.c |   2 +
 net/smc/smc_core.h |  24 +++++++
 net/smc/smc_llc.c  | 165 +++++++++++++++++++++++++++++++++++++++++++++
 net/smc/smc_llc.h  |   8 +++
 4 files changed, 199 insertions(+)

diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index db49f8cd5c95..4867ddcfe0c6 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -263,6 +263,7 @@ static void smc_lgr_free_work(struct work_struct *work)
 			if (smc_link_usable(lnk))
 				lnk->state = SMC_LNK_INACTIVE;
 		}
+		wake_up_interruptible_all(&lgr->llc_waiter);
 	}
 	smc_lgr_free(lgr);
 }
@@ -696,6 +697,7 @@ static void smc_lgr_cleanup(struct smc_link_group *lgr)
 			if (smc_link_usable(lnk))
 				lnk->state = SMC_LNK_INACTIVE;
 		}
+		wake_up_interruptible_all(&lgr->llc_waiter);
 	}
 }
 
diff --git a/net/smc/smc_core.h b/net/smc/smc_core.h
index b5781511063d..70399217ad6f 100644
--- a/net/smc/smc_core.h
+++ b/net/smc/smc_core.h
@@ -197,6 +197,20 @@ struct smc_rtoken {				/* address/key of remote RMB */
 
 struct smcd_dev;
 
+enum smc_llc_flowtype {
+	SMC_LLC_FLOW_NONE	= 0,
+	SMC_LLC_FLOW_ADD_LINK	= 2,
+	SMC_LLC_FLOW_DEL_LINK	= 4,
+	SMC_LLC_FLOW_RKEY	= 6,
+};
+
+struct smc_llc_qentry;
+
+struct smc_llc_flow {
+	enum smc_llc_flowtype type;
+	struct smc_llc_qentry *qentry;
+};
+
 struct smc_link_group {
 	struct list_head	list;
 	struct rb_root		conns_all;	/* connection tree */
@@ -238,6 +252,16 @@ struct smc_link_group {
 						/* protects llc_event_q */
 			struct work_struct	llc_event_work;
 						/* llc event worker */
+			wait_queue_head_t	llc_waiter;
+						/* w4 next llc event */
+			struct smc_llc_flow	llc_flow_lcl;
+						/* llc local control field */
+			struct smc_llc_flow	llc_flow_rmt;
+						/* llc remote control field */
+			struct smc_llc_qentry	*delayed_event;
+						/* arrived when flow active */
+			spinlock_t		llc_flow_lock;
+						/* protects llc flow */
 			int			llc_testlink_time;
 						/* link keep alive time */
 		};
diff --git a/net/smc/smc_llc.c b/net/smc/smc_llc.c
index e715dd6735ee..647cf1a2dfa5 100644
--- a/net/smc/smc_llc.c
+++ b/net/smc/smc_llc.c
@@ -140,6 +140,154 @@ struct smc_llc_qentry {
 	union smc_llc_msg msg;
 };
 
+struct smc_llc_qentry *smc_llc_flow_qentry_clr(struct smc_llc_flow *flow)
+{
+	struct smc_llc_qentry *qentry = flow->qentry;
+
+	flow->qentry = NULL;
+	return qentry;
+}
+
+void smc_llc_flow_qentry_del(struct smc_llc_flow *flow)
+{
+	struct smc_llc_qentry *qentry;
+
+	if (flow->qentry) {
+		qentry = flow->qentry;
+		flow->qentry = NULL;
+		kfree(qentry);
+	}
+}
+
+static inline void smc_llc_flow_qentry_set(struct smc_llc_flow *flow,
+					   struct smc_llc_qentry *qentry)
+{
+	flow->qentry = qentry;
+}
+
+/* try to start a new llc flow, initiated by an incoming llc msg */
+static bool smc_llc_flow_start(struct smc_llc_flow *flow,
+			       struct smc_llc_qentry *qentry)
+{
+	struct smc_link_group *lgr = qentry->link->lgr;
+
+	spin_lock_bh(&lgr->llc_flow_lock);
+	if (flow->type) {
+		/* a flow is already active */
+		if ((qentry->msg.raw.hdr.common.type == SMC_LLC_ADD_LINK ||
+		     qentry->msg.raw.hdr.common.type == SMC_LLC_DELETE_LINK) &&
+		    !lgr->delayed_event) {
+			lgr->delayed_event = qentry;
+		} else {
+			/* forget this llc request */
+			kfree(qentry);
+		}
+		spin_unlock_bh(&lgr->llc_flow_lock);
+		return false;
+	}
+	switch (qentry->msg.raw.hdr.common.type) {
+	case SMC_LLC_ADD_LINK:
+		flow->type = SMC_LLC_FLOW_ADD_LINK;
+		break;
+	case SMC_LLC_DELETE_LINK:
+		flow->type = SMC_LLC_FLOW_DEL_LINK;
+		break;
+	case SMC_LLC_CONFIRM_RKEY:
+	case SMC_LLC_DELETE_RKEY:
+		flow->type = SMC_LLC_FLOW_RKEY;
+		break;
+	default:
+		flow->type = SMC_LLC_FLOW_NONE;
+	}
+	if (qentry == lgr->delayed_event)
+		lgr->delayed_event = NULL;
+	spin_unlock_bh(&lgr->llc_flow_lock);
+	smc_llc_flow_qentry_set(flow, qentry);
+	return true;
+}
+
+/* start a new local llc flow, wait till current flow finished */
+int smc_llc_flow_initiate(struct smc_link_group *lgr,
+			  enum smc_llc_flowtype type)
+{
+	enum smc_llc_flowtype allowed_remote = SMC_LLC_FLOW_NONE;
+	int rc;
+
+	/* all flows except confirm_rkey and delete_rkey are exclusive,
+	 * confirm/delete rkey flows can run concurrently (local and remote)
+	 */
+	if (type == SMC_LLC_FLOW_RKEY)
+		allowed_remote = SMC_LLC_FLOW_RKEY;
+again:
+	if (list_empty(&lgr->list))
+		return -ENODEV;
+	spin_lock_bh(&lgr->llc_flow_lock);
+	if (lgr->llc_flow_lcl.type == SMC_LLC_FLOW_NONE &&
+	    (lgr->llc_flow_rmt.type == SMC_LLC_FLOW_NONE ||
+	     lgr->llc_flow_rmt.type == allowed_remote)) {
+		lgr->llc_flow_lcl.type = type;
+		spin_unlock_bh(&lgr->llc_flow_lock);
+		return 0;
+	}
+	spin_unlock_bh(&lgr->llc_flow_lock);
+	rc = wait_event_interruptible_timeout(lgr->llc_waiter,
+			(lgr->llc_flow_lcl.type == SMC_LLC_FLOW_NONE &&
+			 (lgr->llc_flow_rmt.type == SMC_LLC_FLOW_NONE ||
+			  lgr->llc_flow_rmt.type == allowed_remote)),
+			SMC_LLC_WAIT_TIME);
+	if (!rc)
+		return -ETIMEDOUT;
+	goto again;
+}
+
+/* finish the current llc flow */
+void smc_llc_flow_stop(struct smc_link_group *lgr, struct smc_llc_flow *flow)
+{
+	spin_lock_bh(&lgr->llc_flow_lock);
+	memset(flow, 0, sizeof(*flow));
+	flow->type = SMC_LLC_FLOW_NONE;
+	spin_unlock_bh(&lgr->llc_flow_lock);
+	if (!list_empty(&lgr->list) && lgr->delayed_event &&
+	    flow == &lgr->llc_flow_lcl)
+		schedule_work(&lgr->llc_event_work);
+	else
+		wake_up_interruptible(&lgr->llc_waiter);
+}
+
+/* lnk is optional and used for early wakeup when link goes down, useful in
+ * cases where we wait for a response on the link after we sent a request
+ */
+struct smc_llc_qentry *smc_llc_wait(struct smc_link_group *lgr,
+				    struct smc_link *lnk,
+				    int time_out, u8 exp_msg)
+{
+	struct smc_llc_flow *flow = &lgr->llc_flow_lcl;
+
+	wait_event_interruptible_timeout(lgr->llc_waiter,
+					 (flow->qentry ||
+					  (lnk && !smc_link_usable(lnk)) ||
+					  list_empty(&lgr->list)),
+					 time_out);
+	if (!flow->qentry ||
+	    (lnk && !smc_link_usable(lnk)) || list_empty(&lgr->list)) {
+		smc_llc_flow_qentry_del(flow);
+		goto out;
+	}
+	if (exp_msg && flow->qentry->msg.raw.hdr.common.type != exp_msg) {
+		if (exp_msg == SMC_LLC_ADD_LINK &&
+		    flow->qentry->msg.raw.hdr.common.type ==
+		    SMC_LLC_DELETE_LINK) {
+			/* flow_start will delay the unexpected msg */
+			smc_llc_flow_start(&lgr->llc_flow_lcl,
+					   smc_llc_flow_qentry_clr(flow));
+			return NULL;
+		}
+		smc_llc_flow_qentry_del(flow);
+	}
+out:
+	return flow->qentry;
+}
+
 /********************************** send *************************************/
 
 struct smc_llc_tx_pend {
@@ -547,6 +695,16 @@ static void smc_llc_event_work(struct work_struct *work)
 						  llc_event_work);
 	struct smc_llc_qentry *qentry;
 
+	if (!lgr->llc_flow_lcl.type && lgr->delayed_event) {
+		if (smc_link_usable(lgr->delayed_event->link)) {
+			smc_llc_event_handler(lgr->delayed_event);
+		} else {
+			qentry = lgr->delayed_event;
+			lgr->delayed_event = NULL;
+			kfree(qentry);
+		}
+	}
+
 again:
 	spin_lock_bh(&lgr->llc_event_q_lock);
 	if (!list_empty(&lgr->llc_event_q)) {
@@ -676,6 +834,8 @@ void smc_llc_lgr_init(struct smc_link_group *lgr, struct smc_sock *smc)
 	INIT_WORK(&lgr->llc_event_work, smc_llc_event_work);
 	INIT_LIST_HEAD(&lgr->llc_event_q);
 	spin_lock_init(&lgr->llc_event_q_lock);
+	spin_lock_init(&lgr->llc_flow_lock);
+	init_waitqueue_head(&lgr->llc_waiter);
 	lgr->llc_testlink_time = net->ipv4.sysctl_tcp_keepalive_time;
 }
 
@@ -683,7 +843,12 @@ void smc_llc_lgr_init(struct smc_link_group *lgr, struct smc_sock *smc)
 void smc_llc_lgr_clear(struct smc_link_group *lgr)
 {
 	smc_llc_event_flush(lgr);
+	wake_up_interruptible_all(&lgr->llc_waiter);
 	cancel_work_sync(&lgr->llc_event_work);
+	if (lgr->delayed_event) {
+		kfree(lgr->delayed_event);
+		lgr->delayed_event = NULL;
+	}
 }
 
 int smc_llc_link_init(struct smc_link *link)
diff --git a/net/smc/smc_llc.h b/net/smc/smc_llc.h
index 66063f22166b..49e99ff00ee7 100644
--- a/net/smc/smc_llc.h
+++ b/net/smc/smc_llc.h
@@ -63,6 +63,14 @@ int smc_llc_do_confirm_rkey(struct smc_link *link,
 			    struct smc_buf_desc *rmb_desc);
 int smc_llc_do_delete_rkey(struct smc_link *link,
 			   struct smc_buf_desc *rmb_desc);
+int smc_llc_flow_initiate(struct smc_link_group *lgr,
+			  enum smc_llc_flowtype type);
+void smc_llc_flow_stop(struct smc_link_group *lgr, struct smc_llc_flow *flow);
+struct smc_llc_qentry *smc_llc_wait(struct smc_link_group *lgr,
+				    struct smc_link *lnk,
+				    int time_out, u8 exp_msg);
+struct smc_llc_qentry *smc_llc_flow_qentry_clr(struct smc_llc_flow *flow);
+void smc_llc_flow_qentry_del(struct smc_llc_flow *flow);
 int smc_llc_init(void) __init;
 
 #endif /* SMC_LLC_H */
-- 
2.17.1

