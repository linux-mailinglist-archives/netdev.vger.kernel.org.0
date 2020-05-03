Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59F2C1C2C4C
	for <lists+netdev@lfdr.de>; Sun,  3 May 2020 14:40:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728425AbgECMkK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 May 2020 08:40:10 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:52146 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728067AbgECMjr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 May 2020 08:39:47 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 043CW61U130562;
        Sun, 3 May 2020 08:39:45 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 30svg7sr7e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 03 May 2020 08:39:45 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 043CZOcn011867;
        Sun, 3 May 2020 12:39:43 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03ams.nl.ibm.com with ESMTP id 30s0g5jn9h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 03 May 2020 12:39:43 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 043CdeBU47841326
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 3 May 2020 12:39:40 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A4E1A4C040;
        Sun,  3 May 2020 12:39:40 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6FBC64C046;
        Sun,  3 May 2020 12:39:40 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Sun,  3 May 2020 12:39:40 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: [PATCH net-next v2 03/11] net/smc: final part of add link processing as SMC client
Date:   Sun,  3 May 2020 14:38:42 +0200
Message-Id: <20200503123850.57261-4-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200503123850.57261-1-kgraul@linux.ibm.com>
References: <20200503123850.57261-1-kgraul@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-05-03_09:2020-05-01,2020-05-03 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 phishscore=0
 spamscore=0 mlxscore=0 suspectscore=1 mlxlogscore=999 clxscore=1015
 lowpriorityscore=0 adultscore=0 bulkscore=0 priorityscore=1501
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005030110
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch finalizes the ADD_LINK processing of new links. Receive the
CONFIRM_LINK request from peer, complete the link initialization,
register all used buffers with the IB device and finally send the
CONFIRM_LINK response, which completes the ADD_LINK processing.
And activate smc_llc_cli_add_link() in af_smc.c.

Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
Reviewed-by: Ursula Braun <ubraun@linux.ibm.com>
---
 net/smc/af_smc.c  |  2 +-
 net/smc/smc_llc.c | 73 +++++++++++++++++++++++++++++++++++++++++++++--
 net/smc/smc_llc.h |  1 +
 3 files changed, 72 insertions(+), 4 deletions(-)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index 6663a63be9e4..1afb6e4275f2 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -427,7 +427,7 @@ static int smcr_clnt_conf_first_link(struct smc_sock *smc)
 		return rc;
 	}
 	smc_llc_flow_qentry_clr(&link->lgr->llc_flow_lcl);
-	/* tbd: call smc_llc_cli_add_link(link, qentry); */
+	smc_llc_cli_add_link(link, qentry);
 	return 0;
 }
 
diff --git a/net/smc/smc_llc.c b/net/smc/smc_llc.c
index a06b618f172e..d56ca60597d4 100644
--- a/net/smc/smc_llc.c
+++ b/net/smc/smc_llc.c
@@ -381,7 +381,7 @@ int smc_llc_send_confirm_link(struct smc_link *link,
 	hton24(confllc->sender_qp_num, link->roce_qp->qp_num);
 	confllc->link_num = link->link_id;
 	memcpy(confllc->link_uid, lgr->id, SMC_LGR_ID_SIZE);
-	confllc->max_links = SMC_LLC_ADD_LNK_MAX_LINKS; /* enforce peer resp. */
+	confllc->max_links = SMC_LLC_ADD_LNK_MAX_LINKS;
 	/* send llc message */
 	rc = smc_wr_tx_send(link, pend);
 	return rc;
@@ -724,6 +724,61 @@ static int smc_llc_cli_add_link_reject(struct smc_llc_qentry *qentry)
 	return smc_llc_send_message(qentry->link, &qentry->msg);
 }
 
+static int smc_llc_cli_conf_link(struct smc_link *link,
+				 struct smc_init_info *ini,
+				 struct smc_link *link_new,
+				 enum smc_lgr_type lgr_new_t)
+{
+	struct smc_link_group *lgr = link->lgr;
+	struct smc_llc_msg_del_link *del_llc;
+	struct smc_llc_qentry *qentry = NULL;
+	int rc = 0;
+
+	/* receive CONFIRM LINK request over RoCE fabric */
+	qentry = smc_llc_wait(lgr, NULL, SMC_LLC_WAIT_FIRST_TIME, 0);
+	if (!qentry) {
+		rc = smc_llc_send_delete_link(link, link_new->link_id,
+					      SMC_LLC_REQ, false,
+					      SMC_LLC_DEL_LOST_PATH);
+		return -ENOLINK;
+	}
+	if (qentry->msg.raw.hdr.common.type != SMC_LLC_CONFIRM_LINK) {
+		/* received DELETE_LINK instead */
+		del_llc = &qentry->msg.delete_link;
+		qentry->msg.raw.hdr.flags |= SMC_LLC_FLAG_RESP;
+		smc_llc_send_message(link, &qentry->msg);
+		smc_llc_flow_qentry_del(&lgr->llc_flow_lcl);
+		return -ENOLINK;
+	}
+	smc_llc_flow_qentry_del(&lgr->llc_flow_lcl);
+
+	rc = smc_ib_modify_qp_rts(link_new);
+	if (rc) {
+		smc_llc_send_delete_link(link, link_new->link_id, SMC_LLC_REQ,
+					 false, SMC_LLC_DEL_LOST_PATH);
+		return -ENOLINK;
+	}
+	smc_wr_remember_qp_attr(link_new);
+
+	rc = smcr_buf_reg_lgr(link_new);
+	if (rc) {
+		smc_llc_send_delete_link(link, link_new->link_id, SMC_LLC_REQ,
+					 false, SMC_LLC_DEL_LOST_PATH);
+		return -ENOLINK;
+	}
+
+	/* send CONFIRM LINK response over RoCE fabric */
+	rc = smc_llc_send_confirm_link(link_new, SMC_LLC_RESP);
+	if (rc) {
+		smc_llc_send_delete_link(link, link_new->link_id, SMC_LLC_REQ,
+					 false, SMC_LLC_DEL_LOST_PATH);
+		return -ENOLINK;
+	}
+	smc_llc_link_active(link_new);
+	lgr->type = lgr_new_t;
+	return 0;
+}
+
 static void smc_llc_save_add_link_info(struct smc_link *link,
 				       struct smc_llc_msg_add_link *add_llc)
 {
@@ -785,7 +840,7 @@ int smc_llc_cli_add_link(struct smc_link *link, struct smc_llc_qentry *qentry)
 		rc = 0;
 		goto out_clear_lnk;
 	}
-	/* tbd: rc = smc_llc_cli_conf_link(link, &ini, lnk_new, lgr_new_t); */
+	rc = smc_llc_cli_conf_link(link, &ini, lnk_new, lgr_new_t);
 	if (!rc)
 		goto out;
 out_clear_lnk:
@@ -797,6 +852,17 @@ int smc_llc_cli_add_link(struct smc_link *link, struct smc_llc_qentry *qentry)
 	return rc;
 }
 
+static void smc_llc_process_cli_add_link(struct smc_link_group *lgr)
+{
+	struct smc_llc_qentry *qentry;
+
+	qentry = smc_llc_flow_qentry_clr(&lgr->llc_flow_lcl);
+
+	mutex_lock(&lgr->llc_conf_mutex);
+	smc_llc_cli_add_link(qentry->link, qentry);
+	mutex_unlock(&lgr->llc_conf_mutex);
+}
+
 /* worker to process an add link message */
 static void smc_llc_add_link_work(struct work_struct *work)
 {
@@ -809,7 +875,8 @@ static void smc_llc_add_link_work(struct work_struct *work)
 		goto out;
 	}
 
-	/* tbd: call smc_llc_process_cli_add_link(lgr); */
+	if (lgr->role == SMC_CLNT)
+		smc_llc_process_cli_add_link(lgr);
 	/* tbd: call smc_llc_process_srv_add_link(lgr); */
 out:
 	smc_llc_flow_stop(lgr, &lgr->llc_flow_lcl);
diff --git a/net/smc/smc_llc.h b/net/smc/smc_llc.h
index 97a4f02f5a93..7c314bbef8c8 100644
--- a/net/smc/smc_llc.h
+++ b/net/smc/smc_llc.h
@@ -88,6 +88,7 @@ struct smc_llc_qentry *smc_llc_wait(struct smc_link_group *lgr,
 				    int time_out, u8 exp_msg);
 struct smc_llc_qentry *smc_llc_flow_qentry_clr(struct smc_llc_flow *flow);
 void smc_llc_flow_qentry_del(struct smc_llc_flow *flow);
+int smc_llc_cli_add_link(struct smc_link *link, struct smc_llc_qentry *qentry);
 int smc_llc_init(void) __init;
 
 #endif /* SMC_LLC_H */
-- 
2.17.1

