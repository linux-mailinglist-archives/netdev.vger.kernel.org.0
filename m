Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A4471BFAD2
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 15:56:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729202AbgD3N4Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 09:56:16 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:19060 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729196AbgD3N4N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 09:56:13 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03UDac3x014425;
        Thu, 30 Apr 2020 09:56:10 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30q7qjypgh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 30 Apr 2020 09:56:10 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 03UDmSLH031747;
        Thu, 30 Apr 2020 13:56:08 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma04ams.nl.ibm.com with ESMTP id 30mcu72qe1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 30 Apr 2020 13:56:08 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 03UDsv4N59965870
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Apr 2020 13:54:57 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A08764C040;
        Thu, 30 Apr 2020 13:56:05 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 64FDD4C04E;
        Thu, 30 Apr 2020 13:56:05 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 30 Apr 2020 13:56:05 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: [PATCH net-next 06/14] net/smc: adapt SMC client code to use the LLC flow
Date:   Thu, 30 Apr 2020 15:55:43 +0200
Message-Id: <20200430135551.26267-7-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200430135551.26267-1-kgraul@linux.ibm.com>
References: <20200430135551.26267-1-kgraul@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-30_08:2020-04-30,2020-04-30 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 spamscore=0
 priorityscore=1501 bulkscore=0 malwarescore=0 suspectscore=1
 mlxlogscore=999 lowpriorityscore=0 phishscore=0 adultscore=0
 impostorscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2004300111
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Change the code that processes the SMC client part of connection
establishment to use the LLC flow framework (CONFIRM_LINK request
messages).

Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
Reviewed-by: Ursula Braun <ubraun@linux.ibm.com>
---
 net/smc/af_smc.c   | 69 ++++++++++++++++++++++++++++----------------
 net/smc/smc_clc.h  |  1 +
 net/smc/smc_core.h |  3 --
 net/smc/smc_llc.c  | 72 ++++++++++++++++------------------------------
 4 files changed, 71 insertions(+), 74 deletions(-)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index ab3aef1ddfa4..bd9662d06896 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -382,22 +382,24 @@ static int smcr_lgr_reg_rmbs(struct smc_link_group *lgr,
 static int smcr_clnt_conf_first_link(struct smc_sock *smc)
 {
 	struct smc_link *link = smc->conn.lnk;
-	int rest;
+	struct smc_llc_qentry *qentry;
 	int rc;
 
+	link->lgr->type = SMC_LGR_SINGLE;
+
 	/* receive CONFIRM LINK request from server over RoCE fabric */
-	rest = wait_for_completion_interruptible_timeout(
-		&link->llc_confirm,
-		SMC_LLC_WAIT_FIRST_TIME);
-	if (rest <= 0) {
+	qentry = smc_llc_wait(link->lgr, NULL, SMC_LLC_WAIT_TIME,
+			      SMC_LLC_CONFIRM_LINK);
+	if (!qentry) {
 		struct smc_clc_msg_decline dclc;
 
 		rc = smc_clc_wait_msg(smc, &dclc, sizeof(dclc),
 				      SMC_CLC_DECLINE, CLC_WAIT_TIME_SHORT);
 		return rc == -EAGAIN ? SMC_CLC_DECL_TIMEOUT_CL : rc;
 	}
-
-	if (link->llc_confirm_rc)
+	rc = smc_llc_eval_conf_link(qentry, SMC_LLC_REQ);
+	smc_llc_flow_qentry_del(&link->lgr->llc_flow_lcl);
+	if (rc)
 		return SMC_CLC_DECL_RMBE_EC;
 
 	rc = smc_ib_modify_qp_rts(link);
@@ -409,31 +411,30 @@ static int smcr_clnt_conf_first_link(struct smc_sock *smc)
 	if (smcr_link_reg_rmb(link, smc->conn.rmb_desc, false))
 		return SMC_CLC_DECL_ERR_REGRMB;
 
+	/* confirm_rkey is implicit on 1st contact */
+	smc->conn.rmb_desc->is_conf_rkey = true;
+
 	/* send CONFIRM LINK response over RoCE fabric */
 	rc = smc_llc_send_confirm_link(link, SMC_LLC_RESP);
 	if (rc < 0)
 		return SMC_CLC_DECL_TIMEOUT_CL;
 
-	/* receive ADD LINK request from server over RoCE fabric */
-	rest = wait_for_completion_interruptible_timeout(&link->llc_add,
-							 SMC_LLC_WAIT_TIME);
-	if (rest <= 0) {
+	smc_llc_link_active(link);
+
+	/* optional 2nd link, receive ADD LINK request from server */
+	qentry = smc_llc_wait(link->lgr, NULL, SMC_LLC_WAIT_TIME,
+			      SMC_LLC_ADD_LINK);
+	if (!qentry) {
 		struct smc_clc_msg_decline dclc;
 
 		rc = smc_clc_wait_msg(smc, &dclc, sizeof(dclc),
 				      SMC_CLC_DECLINE, CLC_WAIT_TIME_SHORT);
-		return rc == -EAGAIN ? SMC_CLC_DECL_TIMEOUT_AL : rc;
+		if (rc == -EAGAIN)
+			rc = 0; /* no DECLINE received, go with one link */
+		return rc;
 	}
-
-	/* send add link reject message, only one link supported for now */
-	rc = smc_llc_send_add_link(link,
-				   link->smcibdev->mac[link->ibport - 1],
-				   link->gid, SMC_LLC_RESP);
-	if (rc < 0)
-		return SMC_CLC_DECL_TIMEOUT_AL;
-
-	smc_llc_link_active(link);
-
+	smc_llc_flow_qentry_clr(&link->lgr->llc_flow_lcl);
+	/* tbd: call smc_llc_cli_add_link(link, qentry); */
 	return 0;
 }
 
@@ -613,8 +614,8 @@ static int smc_connect_rdma(struct smc_sock *smc,
 			    struct smc_clc_msg_accept_confirm *aclc,
 			    struct smc_init_info *ini)
 {
+	int i, reason_code = 0;
 	struct smc_link *link;
-	int reason_code = 0;
 
 	ini->is_smcd = false;
 	ini->ib_lcl = &aclc->lcl;
@@ -627,10 +628,28 @@ static int smc_connect_rdma(struct smc_sock *smc,
 		mutex_unlock(&smc_client_lgr_pending);
 		return reason_code;
 	}
-	link = smc->conn.lnk;
 
 	smc_conn_save_peer_info(smc, aclc);
 
+	if (ini->cln_first_contact == SMC_FIRST_CONTACT) {
+		link = smc->conn.lnk;
+	} else {
+		/* set link that was assigned by server */
+		link = NULL;
+		for (i = 0; i < SMC_LINKS_PER_LGR_MAX; i++) {
+			struct smc_link *l = &smc->conn.lgr->lnk[i];
+
+			if (l->peer_qpn == ntoh24(aclc->qpn)) {
+				link = l;
+				break;
+			}
+		}
+		if (!link)
+			return smc_connect_abort(smc, SMC_CLC_DECL_NOSRVLINK,
+						 ini->cln_first_contact);
+		smc->conn.lnk = link;
+	}
+
 	/* create send buffer and rmb */
 	if (smc_buf_create(smc, false))
 		return smc_connect_abort(smc, SMC_CLC_DECL_MEM,
@@ -666,7 +685,9 @@ static int smc_connect_rdma(struct smc_sock *smc,
 
 	if (ini->cln_first_contact == SMC_FIRST_CONTACT) {
 		/* QP confirmation over RoCE fabric */
+		smc_llc_flow_initiate(link->lgr, SMC_LLC_FLOW_ADD_LINK);
 		reason_code = smcr_clnt_conf_first_link(smc);
+		smc_llc_flow_stop(link->lgr, &link->lgr->llc_flow_lcl);
 		if (reason_code)
 			return smc_connect_abort(smc, reason_code,
 						 ini->cln_first_contact);
diff --git a/net/smc/smc_clc.h b/net/smc/smc_clc.h
index 4f2e150a2be1..465876701b75 100644
--- a/net/smc/smc_clc.h
+++ b/net/smc/smc_clc.h
@@ -45,6 +45,7 @@
 #define SMC_CLC_DECL_GETVLANERR	0x03080000  /* err to get vlan id of ip device*/
 #define SMC_CLC_DECL_ISMVLANERR	0x03090000  /* err to reg vlan id on ism dev  */
 #define SMC_CLC_DECL_NOACTLINK	0x030a0000  /* no active smc-r link in lgr    */
+#define SMC_CLC_DECL_NOSRVLINK	0x030b0000  /* SMC-R link from srv not found  */
 #define SMC_CLC_DECL_SYNCERR	0x04000000  /* synchronization error          */
 #define SMC_CLC_DECL_PEERDECL	0x05000000  /* peer declined during handshake */
 #define SMC_CLC_DECL_INTERR	0x09990000  /* internal error		      */
diff --git a/net/smc/smc_core.h b/net/smc/smc_core.h
index 01a9cb885ef2..31237c4c0d93 100644
--- a/net/smc/smc_core.h
+++ b/net/smc/smc_core.h
@@ -120,9 +120,6 @@ struct smc_link {
 	struct smc_link_group	*lgr;		/* parent link group */
 
 	enum smc_link_state	state;		/* state of link */
-	struct completion	llc_confirm;	/* wait for rx of conf link */
-	int			llc_confirm_rc; /* rc from confirm link msg */
-	struct completion	llc_add;	/* wait for rx of add link */
 	struct delayed_work	llc_testlink_wrk; /* testlink worker */
 	struct completion	llc_testlink_resp; /* wait for rx of testlink */
 	int			llc_testlink_time; /* testlink interval */
diff --git a/net/smc/smc_llc.c b/net/smc/smc_llc.c
index 5381b16fd482..644e9ab0dec5 100644
--- a/net/smc/smc_llc.c
+++ b/net/smc/smc_llc.c
@@ -528,47 +528,6 @@ static int smc_llc_send_message(struct smc_link *link, void *llcbuf)
 
 /********************************* receive ***********************************/
 
-static void smc_llc_rx_confirm_link(struct smc_link *link,
-				    struct smc_llc_msg_confirm_link *llc)
-{
-	struct smc_link_group *lgr = smc_get_lgr(link);
-	int conf_rc = 0;
-
-	/* RMBE eyecatchers are not supported */
-	if (!(llc->hd.flags & SMC_LLC_FLAG_NO_RMBE_EYEC))
-		conf_rc = ENOTSUPP;
-
-	if (lgr->role == SMC_CLNT &&
-	    link->state == SMC_LNK_ACTIVATING) {
-		link->llc_confirm_rc = conf_rc;
-		link->link_id = llc->link_num;
-		complete(&link->llc_confirm);
-	}
-}
-
-static void smc_llc_rx_add_link(struct smc_link *link,
-				struct smc_llc_msg_add_link *llc)
-{
-	struct smc_link_group *lgr = smc_get_lgr(link);
-
-	if (link->state == SMC_LNK_ACTIVATING) {
-		complete(&link->llc_add);
-		return;
-	}
-
-	if (lgr->role == SMC_SERV) {
-		smc_llc_prep_add_link(llc, link,
-				link->smcibdev->mac[link->ibport - 1],
-				link->gid, SMC_LLC_REQ);
-
-	} else {
-		smc_llc_prep_add_link(llc, link,
-				link->smcibdev->mac[link->ibport - 1],
-				link->gid, SMC_LLC_RESP);
-	}
-	smc_llc_send_message(link, llc);
-}
-
 static void smc_llc_rx_delete_link(struct smc_link *link,
 				   struct smc_llc_msg_del_link *llc)
 {
@@ -657,6 +616,7 @@ static void smc_llc_event_handler(struct smc_llc_qentry *qentry)
 {
 	union smc_llc_msg *llc = &qentry->msg;
 	struct smc_link *link = qentry->link;
+	struct smc_link_group *lgr = link->lgr;
 
 	if (!smc_link_usable(link))
 		goto out;
@@ -665,11 +625,31 @@ static void smc_llc_event_handler(struct smc_llc_qentry *qentry)
 	case SMC_LLC_TEST_LINK:
 		smc_llc_rx_test_link(link, &llc->test_link);
 		break;
-	case SMC_LLC_CONFIRM_LINK:
-		smc_llc_rx_confirm_link(link, &llc->confirm_link);
-		break;
 	case SMC_LLC_ADD_LINK:
-		smc_llc_rx_add_link(link, &llc->add_link);
+		if (list_empty(&lgr->list))
+			goto out;	/* lgr is terminating */
+		if (lgr->role == SMC_CLNT) {
+			if (lgr->llc_flow_lcl.type == SMC_LLC_FLOW_ADD_LINK) {
+				/* a flow is waiting for this message */
+				smc_llc_flow_qentry_set(&lgr->llc_flow_lcl,
+							qentry);
+				wake_up_interruptible(&lgr->llc_waiter);
+			} else if (smc_llc_flow_start(&lgr->llc_flow_lcl,
+						      qentry)) {
+				/* tbd: schedule_work(&lgr->llc_add_link_work); */
+			}
+		} else if (smc_llc_flow_start(&lgr->llc_flow_lcl, qentry)) {
+			/* as smc server, handle client suggestion */
+			/* tbd: schedule_work(&lgr->llc_add_link_work); */
+		}
+		return;
+	case SMC_LLC_CONFIRM_LINK:
+		if (lgr->llc_flow_lcl.type != SMC_LLC_FLOW_NONE) {
+			/* a flow is waiting for this message */
+			smc_llc_flow_qentry_set(&lgr->llc_flow_lcl, qentry);
+			wake_up_interruptible(&lgr->llc_waiter);
+			return;
+		}
 		break;
 	case SMC_LLC_DELETE_LINK:
 		smc_llc_rx_delete_link(link, &llc->delete_link);
@@ -857,8 +837,6 @@ void smc_llc_lgr_clear(struct smc_link_group *lgr)
 
 int smc_llc_link_init(struct smc_link *link)
 {
-	init_completion(&link->llc_confirm);
-	init_completion(&link->llc_add);
 	init_completion(&link->llc_confirm_rkey_resp);
 	init_completion(&link->llc_delete_rkey_resp);
 	mutex_init(&link->llc_delete_rkey_mutex);
-- 
2.17.1

