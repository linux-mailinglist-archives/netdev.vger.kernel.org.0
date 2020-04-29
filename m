Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62CFA1BE23E
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 17:12:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727855AbgD2PL5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 11:11:57 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:57208 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727122AbgD2PLm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 11:11:42 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03TF2iQD133621;
        Wed, 29 Apr 2020 11:11:39 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 30pjxwanev-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 29 Apr 2020 11:11:38 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 03TFAsus006674;
        Wed, 29 Apr 2020 15:11:37 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03ams.nl.ibm.com with ESMTP id 30mcu5rnr7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 29 Apr 2020 15:11:36 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 03TFBXa353805502
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 Apr 2020 15:11:34 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DE11DAE057;
        Wed, 29 Apr 2020 15:11:32 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9AC2EAE065;
        Wed, 29 Apr 2020 15:11:32 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 29 Apr 2020 15:11:32 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: [PATCH net-next 11/13] net/smc: process llc responses in tasklet context
Date:   Wed, 29 Apr 2020 17:10:47 +0200
Message-Id: <20200429151049.49979-12-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200429151049.49979-1-kgraul@linux.ibm.com>
References: <20200429151049.49979-1-kgraul@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-29_07:2020-04-29,2020-04-29 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0
 priorityscore=1501 phishscore=0 adultscore=0 malwarescore=0
 impostorscore=0 mlxlogscore=999 bulkscore=0 lowpriorityscore=0 mlxscore=0
 suspectscore=3 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2004290122
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When llc responses are received then possible waiters for this response
are to be notified. This can be done in tasklet context, without to
use a work in the llc work queue. Move all code that handles llc
responses into smc_llc_rx_response().

Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
Reviewed-by: Ursula Braun <ubraun@linux.ibm.com>
---
 net/smc/smc_core.h |   8 +-
 net/smc/smc_llc.c  | 216 +++++++++++++++++++++++----------------------
 2 files changed, 116 insertions(+), 108 deletions(-)

diff --git a/net/smc/smc_core.h b/net/smc/smc_core.h
index 6548e9a06f73..d785656b3489 100644
--- a/net/smc/smc_core.h
+++ b/net/smc/smc_core.h
@@ -129,10 +129,10 @@ struct smc_link {
 	struct delayed_work	llc_testlink_wrk; /* testlink worker */
 	struct completion	llc_testlink_resp; /* wait for rx of testlink */
 	int			llc_testlink_time; /* testlink interval */
-	struct completion	llc_confirm_rkey; /* wait 4 rx of cnf rkey */
-	int			llc_confirm_rkey_rc; /* rc from cnf rkey msg */
-	struct completion	llc_delete_rkey; /* wait 4 rx of del rkey */
-	int			llc_delete_rkey_rc; /* rc from del rkey msg */
+	struct completion	llc_confirm_rkey_resp; /* w4 rx of cnf rkey */
+	int			llc_confirm_rkey_resp_rc; /* rc from cnf rkey */
+	struct completion	llc_delete_rkey_resp; /* w4 rx of del rkey */
+	int			llc_delete_rkey_resp_rc; /* rc from del rkey */
 	struct mutex		llc_delete_rkey_mutex; /* serialize usage */
 };
 
diff --git a/net/smc/smc_llc.c b/net/smc/smc_llc.c
index be74876a36ae..265889c8b03b 100644
--- a/net/smc/smc_llc.c
+++ b/net/smc/smc_llc.c
@@ -384,27 +384,17 @@ static void smc_llc_rx_confirm_link(struct smc_link *link,
 				    struct smc_llc_msg_confirm_link *llc)
 {
 	struct smc_link_group *lgr = smc_get_lgr(link);
-	int conf_rc;
+	int conf_rc = 0;
 
 	/* RMBE eyecatchers are not supported */
-	if (llc->hd.flags & SMC_LLC_FLAG_NO_RMBE_EYEC)
-		conf_rc = 0;
-	else
+	if (!(llc->hd.flags & SMC_LLC_FLAG_NO_RMBE_EYEC))
 		conf_rc = ENOTSUPP;
 
-	if (llc->hd.flags & SMC_LLC_FLAG_RESP) {
-		if (lgr->role == SMC_SERV &&
-		    link->state == SMC_LNK_ACTIVATING) {
-			link->llc_confirm_resp_rc = conf_rc;
-			complete(&link->llc_confirm_resp);
-		}
-	} else {
-		if (lgr->role == SMC_CLNT &&
-		    link->state == SMC_LNK_ACTIVATING) {
-			link->llc_confirm_rc = conf_rc;
-			link->link_id = llc->link_num;
-			complete(&link->llc_confirm);
-		}
+	if (lgr->role == SMC_CLNT &&
+	    link->state == SMC_LNK_ACTIVATING) {
+		link->llc_confirm_rc = conf_rc;
+		link->link_id = llc->link_num;
+		complete(&link->llc_confirm);
 	}
 }
 
@@ -413,27 +403,22 @@ static void smc_llc_rx_add_link(struct smc_link *link,
 {
 	struct smc_link_group *lgr = smc_get_lgr(link);
 
-	if (llc->hd.flags & SMC_LLC_FLAG_RESP) {
-		if (link->state == SMC_LNK_ACTIVATING)
-			complete(&link->llc_add_resp);
-	} else {
-		if (link->state == SMC_LNK_ACTIVATING) {
-			complete(&link->llc_add);
-			return;
-		}
+	if (link->state == SMC_LNK_ACTIVATING) {
+		complete(&link->llc_add);
+		return;
+	}
 
-		if (lgr->role == SMC_SERV) {
-			smc_llc_prep_add_link(llc, link,
-					link->smcibdev->mac[link->ibport - 1],
-					link->gid, SMC_LLC_REQ);
+	if (lgr->role == SMC_SERV) {
+		smc_llc_prep_add_link(llc, link,
+				link->smcibdev->mac[link->ibport - 1],
+				link->gid, SMC_LLC_REQ);
 
-		} else {
-			smc_llc_prep_add_link(llc, link,
-					link->smcibdev->mac[link->ibport - 1],
-					link->gid, SMC_LLC_RESP);
-		}
-		smc_llc_send_message(link, llc);
+	} else {
+		smc_llc_prep_add_link(llc, link,
+				link->smcibdev->mac[link->ibport - 1],
+				link->gid, SMC_LLC_RESP);
 	}
+	smc_llc_send_message(link, llc);
 }
 
 static void smc_llc_rx_delete_link(struct smc_link *link,
@@ -441,34 +426,24 @@ static void smc_llc_rx_delete_link(struct smc_link *link,
 {
 	struct smc_link_group *lgr = smc_get_lgr(link);
 
-	if (llc->hd.flags & SMC_LLC_FLAG_RESP) {
-		if (lgr->role == SMC_SERV)
-			smc_lgr_schedule_free_work_fast(lgr);
+	smc_lgr_forget(lgr);
+	smc_llc_link_deleting(link);
+	if (lgr->role == SMC_SERV) {
+		/* client asks to delete this link, send request */
+		smc_llc_prep_delete_link(llc, link, SMC_LLC_REQ, true);
 	} else {
-		smc_lgr_forget(lgr);
-		smc_llc_link_deleting(link);
-		if (lgr->role == SMC_SERV) {
-			/* client asks to delete this link, send request */
-			smc_llc_prep_delete_link(llc, link, SMC_LLC_REQ, true);
-		} else {
-			/* server requests to delete this link, send response */
-			smc_llc_prep_delete_link(llc, link, SMC_LLC_RESP, true);
-		}
-		smc_llc_send_message(link, llc);
-		smc_lgr_terminate_sched(lgr);
+		/* server requests to delete this link, send response */
+		smc_llc_prep_delete_link(llc, link, SMC_LLC_RESP, true);
 	}
+	smc_llc_send_message(link, llc);
+	smc_lgr_terminate_sched(lgr);
 }
 
 static void smc_llc_rx_test_link(struct smc_link *link,
 				 struct smc_llc_msg_test_link *llc)
 {
-	if (llc->hd.flags & SMC_LLC_FLAG_RESP) {
-		if (link->state == SMC_LNK_ACTIVE)
-			complete(&link->llc_testlink_resp);
-	} else {
-		llc->hd.flags |= SMC_LLC_FLAG_RESP;
-		smc_llc_send_message(link, llc);
-	}
+	llc->hd.flags |= SMC_LLC_FLAG_RESP;
+	smc_llc_send_message(link, llc);
 }
 
 static void smc_llc_rx_confirm_rkey(struct smc_link *link,
@@ -476,34 +451,24 @@ static void smc_llc_rx_confirm_rkey(struct smc_link *link,
 {
 	int rc;
 
-	if (llc->hd.flags & SMC_LLC_FLAG_RESP) {
-		link->llc_confirm_rkey_rc = llc->hd.flags &
-					    SMC_LLC_FLAG_RKEY_NEG;
-		complete(&link->llc_confirm_rkey);
-	} else {
-		rc = smc_rtoken_add(link,
-				    llc->rtoken[0].rmb_vaddr,
-				    llc->rtoken[0].rmb_key);
+	rc = smc_rtoken_add(link,
+			    llc->rtoken[0].rmb_vaddr,
+			    llc->rtoken[0].rmb_key);
 
-		/* ignore rtokens for other links, we have only one link */
+	/* ignore rtokens for other links, we have only one link */
 
-		llc->hd.flags |= SMC_LLC_FLAG_RESP;
-		if (rc < 0)
-			llc->hd.flags |= SMC_LLC_FLAG_RKEY_NEG;
-		smc_llc_send_message(link, llc);
-	}
+	llc->hd.flags |= SMC_LLC_FLAG_RESP;
+	if (rc < 0)
+		llc->hd.flags |= SMC_LLC_FLAG_RKEY_NEG;
+	smc_llc_send_message(link, llc);
 }
 
 static void smc_llc_rx_confirm_rkey_cont(struct smc_link *link,
 				      struct smc_llc_msg_confirm_rkey_cont *llc)
 {
-	if (llc->hd.flags & SMC_LLC_FLAG_RESP) {
-		/* unused as long as we don't send this type of msg */
-	} else {
-		/* ignore rtokens for other links, we have only one link */
-		llc->hd.flags |= SMC_LLC_FLAG_RESP;
-		smc_llc_send_message(link, llc);
-	}
+	/* ignore rtokens for other links, we have only one link */
+	llc->hd.flags |= SMC_LLC_FLAG_RESP;
+	smc_llc_send_message(link, llc);
 }
 
 static void smc_llc_rx_delete_rkey(struct smc_link *link,
@@ -512,25 +477,19 @@ static void smc_llc_rx_delete_rkey(struct smc_link *link,
 	u8 err_mask = 0;
 	int i, max;
 
-	if (llc->hd.flags & SMC_LLC_FLAG_RESP) {
-		link->llc_delete_rkey_rc = llc->hd.flags &
-					    SMC_LLC_FLAG_RKEY_NEG;
-		complete(&link->llc_delete_rkey);
-	} else {
-		max = min_t(u8, llc->num_rkeys, SMC_LLC_DEL_RKEY_MAX);
-		for (i = 0; i < max; i++) {
-			if (smc_rtoken_delete(link, llc->rkey[i]))
-				err_mask |= 1 << (SMC_LLC_DEL_RKEY_MAX - 1 - i);
-		}
-
-		if (err_mask) {
-			llc->hd.flags |= SMC_LLC_FLAG_RKEY_NEG;
-			llc->err_mask = err_mask;
-		}
+	max = min_t(u8, llc->num_rkeys, SMC_LLC_DEL_RKEY_MAX);
+	for (i = 0; i < max; i++) {
+		if (smc_rtoken_delete(link, llc->rkey[i]))
+			err_mask |= 1 << (SMC_LLC_DEL_RKEY_MAX - 1 - i);
+	}
 
-		llc->hd.flags |= SMC_LLC_FLAG_RESP;
-		smc_llc_send_message(link, llc);
+	if (err_mask) {
+		llc->hd.flags |= SMC_LLC_FLAG_RKEY_NEG;
+		llc->err_mask = err_mask;
 	}
+
+	llc->hd.flags |= SMC_LLC_FLAG_RESP;
+	smc_llc_send_message(link, llc);
 }
 
 /* flush the llc event queue */
@@ -601,6 +560,49 @@ static void smc_llc_event_work(struct work_struct *work)
 	spin_unlock_bh(&lgr->llc_event_q_lock);
 }
 
+/* process llc responses in tasklet context */
+static void smc_llc_rx_response(struct smc_link *link, union smc_llc_msg *llc)
+{
+	int rc = 0;
+
+	switch (llc->raw.hdr.common.type) {
+	case SMC_LLC_TEST_LINK:
+		if (link->state == SMC_LNK_ACTIVE)
+			complete(&link->llc_testlink_resp);
+		break;
+	case SMC_LLC_CONFIRM_LINK:
+		if (!(llc->raw.hdr.flags & SMC_LLC_FLAG_NO_RMBE_EYEC))
+			rc = ENOTSUPP;
+		if (link->lgr->role == SMC_SERV &&
+		    link->state == SMC_LNK_ACTIVATING) {
+			link->llc_confirm_resp_rc = rc;
+			complete(&link->llc_confirm_resp);
+		}
+		break;
+	case SMC_LLC_ADD_LINK:
+		if (link->state == SMC_LNK_ACTIVATING)
+			complete(&link->llc_add_resp);
+		break;
+	case SMC_LLC_DELETE_LINK:
+		if (link->lgr->role == SMC_SERV)
+			smc_lgr_schedule_free_work_fast(link->lgr);
+		break;
+	case SMC_LLC_CONFIRM_RKEY:
+		link->llc_confirm_rkey_resp_rc = llc->raw.hdr.flags &
+						 SMC_LLC_FLAG_RKEY_NEG;
+		complete(&link->llc_confirm_rkey_resp);
+		break;
+	case SMC_LLC_CONFIRM_RKEY_CONT:
+		/* unused as long as we don't send this type of msg */
+		break;
+	case SMC_LLC_DELETE_RKEY:
+		link->llc_delete_rkey_resp_rc = llc->raw.hdr.flags &
+						SMC_LLC_FLAG_RKEY_NEG;
+		complete(&link->llc_delete_rkey_resp);
+		break;
+	}
+}
+
 /* copy received msg and add it to the event queue */
 static void smc_llc_rx_handler(struct ib_wc *wc, void *buf)
 {
@@ -615,6 +617,12 @@ static void smc_llc_rx_handler(struct ib_wc *wc, void *buf)
 	if (llc->raw.hdr.length != sizeof(*llc))
 		return; /* invalid message */
 
+	/* process responses immediately */
+	if (llc->raw.hdr.flags & SMC_LLC_FLAG_RESP) {
+		smc_llc_rx_response(link, llc);
+		return;
+	}
+
 	qentry = kmalloc(sizeof(*qentry), GFP_ATOMIC);
 	if (!qentry)
 		return;
@@ -667,8 +675,8 @@ int smc_llc_link_init(struct smc_link *link)
 	init_completion(&link->llc_confirm_resp);
 	init_completion(&link->llc_add);
 	init_completion(&link->llc_add_resp);
-	init_completion(&link->llc_confirm_rkey);
-	init_completion(&link->llc_delete_rkey);
+	init_completion(&link->llc_confirm_rkey_resp);
+	init_completion(&link->llc_delete_rkey_resp);
 	mutex_init(&link->llc_delete_rkey_mutex);
 	init_completion(&link->llc_testlink_resp);
 	INIT_WORK(&link->lgr->llc_event_work, smc_llc_event_work);
@@ -708,14 +716,14 @@ int smc_llc_do_confirm_rkey(struct smc_link *link,
 	int rc;
 
 	/* protected by mutex smc_create_lgr_pending */
-	reinit_completion(&link->llc_confirm_rkey);
+	reinit_completion(&link->llc_confirm_rkey_resp);
 	rc = smc_llc_send_confirm_rkey(link, rmb_desc);
 	if (rc)
 		return rc;
 	/* receive CONFIRM RKEY response from server over RoCE fabric */
-	rc = wait_for_completion_interruptible_timeout(&link->llc_confirm_rkey,
-						       SMC_LLC_WAIT_TIME);
-	if (rc <= 0 || link->llc_confirm_rkey_rc)
+	rc = wait_for_completion_interruptible_timeout(
+			&link->llc_confirm_rkey_resp, SMC_LLC_WAIT_TIME);
+	if (rc <= 0 || link->llc_confirm_rkey_resp_rc)
 		return -EFAULT;
 	return 0;
 }
@@ -729,14 +737,14 @@ int smc_llc_do_delete_rkey(struct smc_link *link,
 	mutex_lock(&link->llc_delete_rkey_mutex);
 	if (link->state != SMC_LNK_ACTIVE)
 		goto out;
-	reinit_completion(&link->llc_delete_rkey);
+	reinit_completion(&link->llc_delete_rkey_resp);
 	rc = smc_llc_send_delete_rkey(link, rmb_desc);
 	if (rc)
 		goto out;
 	/* receive DELETE RKEY response from server over RoCE fabric */
-	rc = wait_for_completion_interruptible_timeout(&link->llc_delete_rkey,
-						       SMC_LLC_WAIT_TIME);
-	if (rc <= 0 || link->llc_delete_rkey_rc)
+	rc = wait_for_completion_interruptible_timeout(
+			&link->llc_delete_rkey_resp, SMC_LLC_WAIT_TIME);
+	if (rc <= 0 || link->llc_delete_rkey_resp_rc)
 		rc = -EFAULT;
 	else
 		rc = 0;
-- 
2.17.1

