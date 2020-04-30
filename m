Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 035401BFAFD
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 15:57:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729200AbgD3N45 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 09:56:57 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:46376 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729195AbgD3N4M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 09:56:12 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03UDacrF122745;
        Thu, 30 Apr 2020 09:56:11 -0400
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30mggwypbr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 30 Apr 2020 09:56:10 -0400
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 03UDmWBM016655;
        Thu, 30 Apr 2020 13:56:08 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma04fra.de.ibm.com with ESMTP id 30mcu5aqcp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 30 Apr 2020 13:56:08 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 03UDsuah59965866
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Apr 2020 13:54:56 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 59FC04C044;
        Thu, 30 Apr 2020 13:56:05 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 23AF54C040;
        Thu, 30 Apr 2020 13:56:05 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 30 Apr 2020 13:56:05 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: [PATCH net-next 05/14] net/smc: adapt SMC server code to use the LLC flow
Date:   Thu, 30 Apr 2020 15:55:42 +0200
Message-Id: <20200430135551.26267-6-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200430135551.26267-1-kgraul@linux.ibm.com>
References: <20200430135551.26267-1-kgraul@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-30_08:2020-04-30,2020-04-30 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 spamscore=0
 suspectscore=3 mlxscore=0 lowpriorityscore=0 adultscore=0 phishscore=0
 bulkscore=0 priorityscore=1501 malwarescore=0 clxscore=1015
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004300106
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Change the code that processes the SMC server part of connection
establishment to use the LLC flow framework (CONFIRM_LINK response
messages).

Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
Reviewed-by: Ursula Braun <ubraun@linux.ibm.com>
---
 net/smc/af_smc.c   | 39 +++++++++++++++------------------------
 net/smc/smc_core.h |  3 ---
 net/smc/smc_llc.c  | 20 +++++---------------
 3 files changed, 20 insertions(+), 42 deletions(-)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index e859e3f420d9..ab3aef1ddfa4 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -1019,9 +1019,11 @@ void smc_close_non_accepted(struct sock *sk)
 static int smcr_serv_conf_first_link(struct smc_sock *smc)
 {
 	struct smc_link *link = smc->conn.lnk;
-	int rest;
+	struct smc_llc_qentry *qentry;
 	int rc;
 
+	link->lgr->type = SMC_LGR_SINGLE;
+
 	if (smcr_link_reg_rmb(link, smc->conn.rmb_desc, false))
 		return SMC_CLC_DECL_ERR_REGRMB;
 
@@ -1031,40 +1033,27 @@ static int smcr_serv_conf_first_link(struct smc_sock *smc)
 		return SMC_CLC_DECL_TIMEOUT_CL;
 
 	/* receive CONFIRM LINK response from client over the RoCE fabric */
-	rest = wait_for_completion_interruptible_timeout(
-		&link->llc_confirm_resp,
-		SMC_LLC_WAIT_FIRST_TIME);
-	if (rest <= 0) {
+	qentry = smc_llc_wait(link->lgr, link, SMC_LLC_WAIT_TIME,
+			      SMC_LLC_CONFIRM_LINK);
+	if (!qentry) {
 		struct smc_clc_msg_decline dclc;
 
 		rc = smc_clc_wait_msg(smc, &dclc, sizeof(dclc),
 				      SMC_CLC_DECLINE, CLC_WAIT_TIME_SHORT);
 		return rc == -EAGAIN ? SMC_CLC_DECL_TIMEOUT_CL : rc;
 	}
-
-	if (link->llc_confirm_resp_rc)
+	rc = smc_llc_eval_conf_link(qentry, SMC_LLC_RESP);
+	smc_llc_flow_qentry_del(&link->lgr->llc_flow_lcl);
+	if (rc)
 		return SMC_CLC_DECL_RMBE_EC;
 
-	/* send ADD LINK request to client over the RoCE fabric */
-	rc = smc_llc_send_add_link(link,
-				   link->smcibdev->mac[link->ibport - 1],
-				   link->gid, SMC_LLC_REQ);
-	if (rc < 0)
-		return SMC_CLC_DECL_TIMEOUT_AL;
-
-	/* receive ADD LINK response from client over the RoCE fabric */
-	rest = wait_for_completion_interruptible_timeout(&link->llc_add_resp,
-							 SMC_LLC_WAIT_TIME);
-	if (rest <= 0) {
-		struct smc_clc_msg_decline dclc;
-
-		rc = smc_clc_wait_msg(smc, &dclc, sizeof(dclc),
-				      SMC_CLC_DECLINE, CLC_WAIT_TIME_SHORT);
-		return rc == -EAGAIN ? SMC_CLC_DECL_TIMEOUT_AL : rc;
-	}
+	/* confirm_rkey is implicit on 1st contact */
+	smc->conn.rmb_desc->is_conf_rkey = true;
 
 	smc_llc_link_active(link);
 
+	/* initial contact - try to establish second link */
+	/* tbd: call smc_llc_srv_add_link(link); */
 	return 0;
 }
 
@@ -1240,7 +1229,9 @@ static int smc_listen_rdma_finish(struct smc_sock *new_smc,
 			goto decline;
 		}
 		/* QP confirmation over RoCE fabric */
+		smc_llc_flow_initiate(link->lgr, SMC_LLC_FLOW_ADD_LINK);
 		reason_code = smcr_serv_conf_first_link(new_smc);
+		smc_llc_flow_stop(link->lgr, &link->lgr->llc_flow_lcl);
 		if (reason_code)
 			goto decline;
 	}
diff --git a/net/smc/smc_core.h b/net/smc/smc_core.h
index 51366a9f4980..01a9cb885ef2 100644
--- a/net/smc/smc_core.h
+++ b/net/smc/smc_core.h
@@ -121,11 +121,8 @@ struct smc_link {
 
 	enum smc_link_state	state;		/* state of link */
 	struct completion	llc_confirm;	/* wait for rx of conf link */
-	struct completion	llc_confirm_resp; /* wait 4 rx of cnf lnk rsp */
 	int			llc_confirm_rc; /* rc from confirm link msg */
-	int			llc_confirm_resp_rc; /* rc from conf_resp msg */
 	struct completion	llc_add;	/* wait for rx of add link */
-	struct completion	llc_add_resp;	/* wait for rx of add link rsp*/
 	struct delayed_work	llc_testlink_wrk; /* testlink worker */
 	struct completion	llc_testlink_resp; /* wait for rx of testlink */
 	int			llc_testlink_time; /* testlink interval */
diff --git a/net/smc/smc_llc.c b/net/smc/smc_llc.c
index 9248b90fe37e..5381b16fd482 100644
--- a/net/smc/smc_llc.c
+++ b/net/smc/smc_llc.c
@@ -724,26 +724,18 @@ static void smc_llc_rx_response(struct smc_link *link,
 {
 	u8 llc_type = qentry->msg.raw.hdr.common.type;
 	union smc_llc_msg *llc = &qentry->msg;
-	int rc = 0;
 
 	switch (llc_type) {
 	case SMC_LLC_TEST_LINK:
 		if (link->state == SMC_LNK_ACTIVE)
 			complete(&link->llc_testlink_resp);
 		break;
-	case SMC_LLC_CONFIRM_LINK:
-		if (!(llc->raw.hdr.flags & SMC_LLC_FLAG_NO_RMBE_EYEC))
-			rc = ENOTSUPP;
-		if (link->lgr->role == SMC_SERV &&
-		    link->state == SMC_LNK_ACTIVATING) {
-			link->llc_confirm_resp_rc = rc;
-			complete(&link->llc_confirm_resp);
-		}
-		break;
 	case SMC_LLC_ADD_LINK:
-		if (link->state == SMC_LNK_ACTIVATING)
-			complete(&link->llc_add_resp);
-		break;
+	case SMC_LLC_CONFIRM_LINK:
+		/* assign responses to the local flow, we requested them */
+		smc_llc_flow_qentry_set(&link->lgr->llc_flow_lcl, qentry);
+		wake_up_interruptible(&link->lgr->llc_waiter);
+		return;
 	case SMC_LLC_DELETE_LINK:
 		if (link->lgr->role == SMC_SERV)
 			smc_lgr_schedule_free_work_fast(link->lgr);
@@ -866,9 +858,7 @@ void smc_llc_lgr_clear(struct smc_link_group *lgr)
 int smc_llc_link_init(struct smc_link *link)
 {
 	init_completion(&link->llc_confirm);
-	init_completion(&link->llc_confirm_resp);
 	init_completion(&link->llc_add);
-	init_completion(&link->llc_add_resp);
 	init_completion(&link->llc_confirm_rkey_resp);
 	init_completion(&link->llc_delete_rkey_resp);
 	mutex_init(&link->llc_delete_rkey_mutex);
-- 
2.17.1

