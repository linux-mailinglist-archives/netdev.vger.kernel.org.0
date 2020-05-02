Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9CDD1C256A
	for <lists+netdev@lfdr.de>; Sat,  2 May 2020 14:36:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728020AbgEBMgh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 May 2020 08:36:37 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:28160 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727860AbgEBMgS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 May 2020 08:36:18 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 042CW7LX018461;
        Sat, 2 May 2020 08:36:16 -0400
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0b-001b2d01.pphosted.com with ESMTP id 30s5qgbt72-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 02 May 2020 08:36:16 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 042CZc8l011613;
        Sat, 2 May 2020 12:36:14 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03fra.de.ibm.com with ESMTP id 30s0g5g9yv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 02 May 2020 12:36:14 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 042CaB7o65405210
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 2 May 2020 12:36:11 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 43E16A405B;
        Sat,  2 May 2020 12:36:11 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 05E92A405F;
        Sat,  2 May 2020 12:36:11 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Sat,  2 May 2020 12:36:10 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: [PATCH net-next 09/13] net/smc: llc_del_link_work and use the LLC flow for delete link
Date:   Sat,  2 May 2020 14:35:48 +0200
Message-Id: <20200502123552.17204-10-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200502123552.17204-1-kgraul@linux.ibm.com>
References: <20200502123552.17204-1-kgraul@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-05-02_06:2020-05-01,2020-05-02 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxscore=0
 malwarescore=0 suspectscore=3 clxscore=1015 priorityscore=1501
 phishscore=0 bulkscore=0 spamscore=0 impostorscore=0 lowpriorityscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005020109
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce a work that is scheduled when a new DELETE_LINK LLC request is
received. The work will call either the SMC client or SMC server
DELETE_LINK processing.
And use the LLC flow framework to process incoming DELETE_LINK LLC
messages, scheduling the llc_del_link_work for those events.
With these changes smc_lgr_forget() is only called by one function and
can be migrated into smc_lgr_cleanup_early().

Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
Reviewed-by: Ursula Braun <ubraun@linux.ibm.com>
---
 net/smc/smc_core.c | 22 +++++++------------
 net/smc/smc_core.h |  2 +-
 net/smc/smc_llc.c  | 55 ++++++++++++++++++++++++++++++----------------
 3 files changed, 45 insertions(+), 34 deletions(-)

diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index 2f8faa9c9e8e..a964304283fa 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -193,12 +193,19 @@ static void smc_lgr_unregister_conn(struct smc_connection *conn)
 void smc_lgr_cleanup_early(struct smc_connection *conn)
 {
 	struct smc_link_group *lgr = conn->lgr;
+	struct list_head *lgr_list;
+	spinlock_t *lgr_lock;
 
 	if (!lgr)
 		return;
 
 	smc_conn_free(conn);
-	smc_lgr_forget(lgr);
+	lgr_list = smc_lgr_list_head(lgr, &lgr_lock);
+	spin_lock_bh(lgr_lock);
+	/* do not use this link group for new connections */
+	if (!list_empty(lgr_list))
+		list_del_init(lgr_list);
+	spin_unlock_bh(lgr_lock);
 	smc_lgr_schedule_free_work_fast(lgr);
 }
 
@@ -653,19 +660,6 @@ static void smc_lgr_free(struct smc_link_group *lgr)
 	kfree(lgr);
 }
 
-void smc_lgr_forget(struct smc_link_group *lgr)
-{
-	struct list_head *lgr_list;
-	spinlock_t *lgr_lock;
-
-	lgr_list = smc_lgr_list_head(lgr, &lgr_lock);
-	spin_lock_bh(lgr_lock);
-	/* do not use this link group for new connections */
-	if (!list_empty(lgr_list))
-		list_del_init(lgr_list);
-	spin_unlock_bh(lgr_lock);
-}
-
 static void smcd_unregister_all_dmbs(struct smc_link_group *lgr)
 {
 	int i;
diff --git a/net/smc/smc_core.h b/net/smc/smc_core.h
index 4e00819e2db7..7fe53feb9dc4 100644
--- a/net/smc/smc_core.h
+++ b/net/smc/smc_core.h
@@ -254,6 +254,7 @@ struct smc_link_group {
 			struct mutex		llc_conf_mutex;
 						/* protects lgr reconfig. */
 			struct work_struct	llc_add_link_work;
+			struct work_struct	llc_del_link_work;
 			struct work_struct	llc_event_work;
 						/* llc event worker */
 			wait_queue_head_t	llc_waiter;
@@ -343,7 +344,6 @@ struct smc_sock;
 struct smc_clc_msg_accept_confirm;
 struct smc_clc_msg_local;
 
-void smc_lgr_forget(struct smc_link_group *lgr);
 void smc_lgr_cleanup_early(struct smc_connection *conn);
 void smc_lgr_terminate_sched(struct smc_link_group *lgr);
 void smcr_port_add(struct smc_ib_device *smcibdev, u8 ibport);
diff --git a/net/smc/smc_llc.c b/net/smc/smc_llc.c
index 9d102c912be9..e4e3910a9624 100644
--- a/net/smc/smc_llc.c
+++ b/net/smc/smc_llc.c
@@ -1118,22 +1118,18 @@ static void smc_llc_add_link_work(struct work_struct *work)
 	smc_llc_flow_stop(lgr, &lgr->llc_flow_lcl);
 }
 
-static void smc_llc_rx_delete_link(struct smc_link *link,
-				   struct smc_llc_msg_del_link *llc)
+static void smc_llc_delete_link_work(struct work_struct *work)
 {
-	struct smc_link_group *lgr = smc_get_lgr(link);
+	struct smc_link_group *lgr = container_of(work, struct smc_link_group,
+						  llc_del_link_work);
 
-	smc_lgr_forget(lgr);
-	if (lgr->role == SMC_SERV) {
-		/* client asks to delete this link, send request */
-		smc_llc_send_delete_link(link, 0, SMC_LLC_REQ, true,
-					 SMC_LLC_DEL_PROG_INIT_TERM);
-	} else {
-		/* server requests to delete this link, send response */
-		smc_llc_send_delete_link(link, 0, SMC_LLC_RESP, true,
-					 SMC_LLC_DEL_PROG_INIT_TERM);
+	if (list_empty(&lgr->list)) {
+		/* link group is terminating */
+		smc_llc_flow_qentry_del(&lgr->llc_flow_lcl);
+		goto out;
 	}
-	smcr_link_down_cond(link);
+out:
+	smc_llc_flow_stop(lgr, &lgr->llc_flow_lcl);
 }
 
 /* process a confirm_rkey request from peer, remote flow */
@@ -1255,8 +1251,30 @@ static void smc_llc_event_handler(struct smc_llc_qentry *qentry)
 		}
 		break;
 	case SMC_LLC_DELETE_LINK:
-		smc_llc_rx_delete_link(link, &llc->delete_link);
-		break;
+		if (lgr->role == SMC_CLNT) {
+			/* server requests to delete this link, send response */
+			if (lgr->llc_flow_lcl.type != SMC_LLC_FLOW_NONE) {
+				/* DEL LINK REQ during ADD LINK SEQ */
+				smc_llc_flow_qentry_set(&lgr->llc_flow_lcl,
+							qentry);
+				wake_up_interruptible(&lgr->llc_waiter);
+			} else if (smc_llc_flow_start(&lgr->llc_flow_lcl,
+						      qentry)) {
+				schedule_work(&lgr->llc_del_link_work);
+			}
+		} else {
+			if (lgr->llc_flow_lcl.type == SMC_LLC_FLOW_ADD_LINK &&
+			    !lgr->llc_flow_lcl.qentry) {
+				/* DEL LINK REQ during ADD LINK SEQ */
+				smc_llc_flow_qentry_set(&lgr->llc_flow_lcl,
+							qentry);
+				wake_up_interruptible(&lgr->llc_waiter);
+			} else if (smc_llc_flow_start(&lgr->llc_flow_lcl,
+						      qentry)) {
+				schedule_work(&lgr->llc_del_link_work);
+			}
+		}
+		return;
 	case SMC_LLC_CONFIRM_RKEY:
 		/* new request from remote, assign to remote flow */
 		if (smc_llc_flow_start(&lgr->llc_flow_rmt, qentry)) {
@@ -1325,6 +1343,7 @@ static void smc_llc_rx_response(struct smc_link *link,
 			complete(&link->llc_testlink_resp);
 		break;
 	case SMC_LLC_ADD_LINK:
+	case SMC_LLC_DELETE_LINK:
 	case SMC_LLC_CONFIRM_LINK:
 	case SMC_LLC_ADD_LINK_CONT:
 	case SMC_LLC_CONFIRM_RKEY:
@@ -1333,10 +1352,6 @@ static void smc_llc_rx_response(struct smc_link *link,
 		smc_llc_flow_qentry_set(&link->lgr->llc_flow_lcl, qentry);
 		wake_up_interruptible(&link->lgr->llc_waiter);
 		return;
-	case SMC_LLC_DELETE_LINK:
-		if (link->lgr->role == SMC_SERV)
-			smc_lgr_schedule_free_work_fast(link->lgr);
-		break;
 	case SMC_LLC_CONFIRM_RKEY_CONT:
 		/* not used because max links is 3 */
 		break;
@@ -1424,6 +1439,7 @@ void smc_llc_lgr_init(struct smc_link_group *lgr, struct smc_sock *smc)
 
 	INIT_WORK(&lgr->llc_event_work, smc_llc_event_work);
 	INIT_WORK(&lgr->llc_add_link_work, smc_llc_add_link_work);
+	INIT_WORK(&lgr->llc_del_link_work, smc_llc_delete_link_work);
 	INIT_LIST_HEAD(&lgr->llc_event_q);
 	spin_lock_init(&lgr->llc_event_q_lock);
 	spin_lock_init(&lgr->llc_flow_lock);
@@ -1439,6 +1455,7 @@ void smc_llc_lgr_clear(struct smc_link_group *lgr)
 	wake_up_interruptible_all(&lgr->llc_waiter);
 	cancel_work_sync(&lgr->llc_event_work);
 	cancel_work_sync(&lgr->llc_add_link_work);
+	cancel_work_sync(&lgr->llc_del_link_work);
 	if (lgr->delayed_event) {
 		kfree(lgr->delayed_event);
 		lgr->delayed_event = NULL;
-- 
2.17.1

