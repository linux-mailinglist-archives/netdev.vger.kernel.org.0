Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 189D61BFAFB
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 15:57:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728341AbgD3N4z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 09:56:55 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:9220 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729200AbgD3N4M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 09:56:12 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03UDaccZ037556;
        Thu, 30 Apr 2020 09:56:11 -0400
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30mfhgpp7p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 30 Apr 2020 09:56:11 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 03UDml1B002971;
        Thu, 30 Apr 2020 13:56:09 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03fra.de.ibm.com with ESMTP id 30mcu5aquh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 30 Apr 2020 13:56:09 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 03UDu6h565405172
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Apr 2020 13:56:06 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3A7C74C040;
        Thu, 30 Apr 2020 13:56:06 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 003D34C04A;
        Thu, 30 Apr 2020 13:56:06 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 30 Apr 2020 13:56:05 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: [PATCH net-next 08/14] net/smc: multiple link support and LLC flow for smc_llc_do_delete_rkey
Date:   Thu, 30 Apr 2020 15:55:45 +0200
Message-Id: <20200430135551.26267-9-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200430135551.26267-1-kgraul@linux.ibm.com>
References: <20200430135551.26267-1-kgraul@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-30_08:2020-04-30,2020-04-30 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 suspectscore=1
 phishscore=0 lowpriorityscore=0 bulkscore=0 adultscore=0 mlxlogscore=999
 malwarescore=0 impostorscore=0 clxscore=1015 priorityscore=1501
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004300106
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adapt smc_llc_do_delete_rkey() to use the LLC flow and support multiple
links when deleting the rkeys for rmb buffers at the peer.

Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
Reviewed-by: Ursula Braun <ubraun@linux.ibm.com>
---
 net/smc/smc_core.c | 10 ++++------
 net/smc/smc_core.h |  3 ---
 net/smc/smc_llc.c  | 39 +++++++++++++++++++--------------------
 net/smc/smc_llc.h  |  2 +-
 4 files changed, 24 insertions(+), 30 deletions(-)

diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index 4867ddcfe0c6..f71a366ed6ac 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -446,13 +446,11 @@ static int smc_lgr_create(struct smc_sock *smc, struct smc_init_info *ini)
 }
 
 static void smcr_buf_unuse(struct smc_buf_desc *rmb_desc,
-			   struct smc_link *lnk)
+			   struct smc_link_group *lgr)
 {
-	struct smc_link_group *lgr = lnk->lgr;
-
 	if (rmb_desc->is_conf_rkey && !list_empty(&lgr->list)) {
 		/* unregister rmb with peer */
-		smc_llc_do_delete_rkey(lnk, rmb_desc);
+		smc_llc_do_delete_rkey(lgr, rmb_desc);
 		rmb_desc->is_conf_rkey = false;
 	}
 	if (rmb_desc->is_reg_err) {
@@ -475,7 +473,7 @@ static void smc_buf_unuse(struct smc_connection *conn,
 	if (conn->rmb_desc && lgr->is_smcd)
 		conn->rmb_desc->used = 0;
 	else if (conn->rmb_desc)
-		smcr_buf_unuse(conn->rmb_desc, conn->lnk);
+		smcr_buf_unuse(conn->rmb_desc, lgr);
 }
 
 /* remove a finished connection from its link group */
@@ -1169,7 +1167,6 @@ static int smcr_buf_map_usable_links(struct smc_link_group *lgr,
 		if (!smc_link_usable(lnk))
 			continue;
 		if (smcr_buf_map_link(buf_desc, is_rmb, lnk)) {
-			smcr_buf_unuse(buf_desc, lnk);
 			rc = -ENOMEM;
 			goto out;
 		}
@@ -1275,6 +1272,7 @@ static int __smc_buf_create(struct smc_sock *smc, bool is_smcd, bool is_rmb)
 
 	if (!is_smcd) {
 		if (smcr_buf_map_usable_links(lgr, buf_desc, is_rmb)) {
+			smcr_buf_unuse(buf_desc, lgr);
 			return -ENOMEM;
 		}
 	}
diff --git a/net/smc/smc_core.h b/net/smc/smc_core.h
index 4e0dfb1d5804..364a54e28d61 100644
--- a/net/smc/smc_core.h
+++ b/net/smc/smc_core.h
@@ -123,9 +123,6 @@ struct smc_link {
 	struct delayed_work	llc_testlink_wrk; /* testlink worker */
 	struct completion	llc_testlink_resp; /* wait for rx of testlink */
 	int			llc_testlink_time; /* testlink interval */
-	struct completion	llc_delete_rkey_resp; /* w4 rx of del rkey */
-	int			llc_delete_rkey_resp_rc; /* rc from del rkey */
-	struct mutex		llc_delete_rkey_mutex; /* serialize usage */
 };
 
 /* For now we just allow one parallel link per link group. The SMC protocol
diff --git a/net/smc/smc_llc.c b/net/smc/smc_llc.c
index 5db11f54b4cd..f9ec270818fa 100644
--- a/net/smc/smc_llc.c
+++ b/net/smc/smc_llc.c
@@ -720,7 +720,6 @@ static void smc_llc_rx_response(struct smc_link *link,
 				struct smc_llc_qentry *qentry)
 {
 	u8 llc_type = qentry->msg.raw.hdr.common.type;
-	union smc_llc_msg *llc = &qentry->msg;
 
 	switch (llc_type) {
 	case SMC_LLC_TEST_LINK:
@@ -730,6 +729,7 @@ static void smc_llc_rx_response(struct smc_link *link,
 	case SMC_LLC_ADD_LINK:
 	case SMC_LLC_CONFIRM_LINK:
 	case SMC_LLC_CONFIRM_RKEY:
+	case SMC_LLC_DELETE_RKEY:
 		/* assign responses to the local flow, we requested them */
 		smc_llc_flow_qentry_set(&link->lgr->llc_flow_lcl, qentry);
 		wake_up_interruptible(&link->lgr->llc_waiter);
@@ -741,11 +741,6 @@ static void smc_llc_rx_response(struct smc_link *link,
 	case SMC_LLC_CONFIRM_RKEY_CONT:
 		/* unused as long as we don't send this type of msg */
 		break;
-	case SMC_LLC_DELETE_RKEY:
-		link->llc_delete_rkey_resp_rc = llc->raw.hdr.flags &
-						SMC_LLC_FLAG_RKEY_NEG;
-		complete(&link->llc_delete_rkey_resp);
-		break;
 	}
 	kfree(qentry);
 }
@@ -850,8 +845,6 @@ void smc_llc_lgr_clear(struct smc_link_group *lgr)
 
 int smc_llc_link_init(struct smc_link *link)
 {
-	init_completion(&link->llc_delete_rkey_resp);
-	mutex_init(&link->llc_delete_rkey_mutex);
 	init_completion(&link->llc_testlink_resp);
 	INIT_DELAYED_WORK(&link->llc_testlink_wrk, smc_llc_testlink_work);
 	return 0;
@@ -909,27 +902,33 @@ int smc_llc_do_confirm_rkey(struct smc_link *send_link,
 }
 
 /* unregister an rtoken at the remote peer */
-int smc_llc_do_delete_rkey(struct smc_link *link,
+int smc_llc_do_delete_rkey(struct smc_link_group *lgr,
 			   struct smc_buf_desc *rmb_desc)
 {
+	struct smc_llc_qentry *qentry = NULL;
+	struct smc_link *send_link;
 	int rc = 0;
 
-	mutex_lock(&link->llc_delete_rkey_mutex);
-	if (link->state != SMC_LNK_ACTIVE)
-		goto out;
-	reinit_completion(&link->llc_delete_rkey_resp);
-	rc = smc_llc_send_delete_rkey(link, rmb_desc);
+	send_link = smc_llc_usable_link(lgr);
+	if (!send_link)
+		return -ENOLINK;
+
+	rc = smc_llc_flow_initiate(lgr, SMC_LLC_FLOW_RKEY);
+	if (rc)
+		return rc;
+	/* protected by llc_flow control */
+	rc = smc_llc_send_delete_rkey(send_link, rmb_desc);
 	if (rc)
 		goto out;
 	/* receive DELETE RKEY response from server over RoCE fabric */
-	rc = wait_for_completion_interruptible_timeout(
-			&link->llc_delete_rkey_resp, SMC_LLC_WAIT_TIME);
-	if (rc <= 0 || link->llc_delete_rkey_resp_rc)
+	qentry = smc_llc_wait(lgr, send_link, SMC_LLC_WAIT_TIME,
+			      SMC_LLC_DELETE_RKEY);
+	if (!qentry || (qentry->msg.raw.hdr.flags & SMC_LLC_FLAG_RKEY_NEG))
 		rc = -EFAULT;
-	else
-		rc = 0;
 out:
-	mutex_unlock(&link->llc_delete_rkey_mutex);
+	if (qentry)
+		smc_llc_flow_qentry_del(&lgr->llc_flow_lcl);
+	smc_llc_flow_stop(lgr, &lgr->llc_flow_lcl);
 	return rc;
 }
 
diff --git a/net/smc/smc_llc.h b/net/smc/smc_llc.h
index d82d8346b61e..e9f23affece6 100644
--- a/net/smc/smc_llc.h
+++ b/net/smc/smc_llc.h
@@ -61,7 +61,7 @@ void smc_llc_link_deleting(struct smc_link *link);
 void smc_llc_link_clear(struct smc_link *link);
 int smc_llc_do_confirm_rkey(struct smc_link *send_link,
 			    struct smc_buf_desc *rmb_desc);
-int smc_llc_do_delete_rkey(struct smc_link *link,
+int smc_llc_do_delete_rkey(struct smc_link_group *lgr,
 			   struct smc_buf_desc *rmb_desc);
 int smc_llc_flow_initiate(struct smc_link_group *lgr,
 			  enum smc_llc_flowtype type);
-- 
2.17.1

