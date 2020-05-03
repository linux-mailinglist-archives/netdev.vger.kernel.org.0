Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCF3D1C2C39
	for <lists+netdev@lfdr.de>; Sun,  3 May 2020 14:39:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728503AbgECMjt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 May 2020 08:39:49 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:25692 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728214AbgECMjr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 May 2020 08:39:47 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 043CWc7G026692;
        Sun, 3 May 2020 08:39:46 -0400
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30s5d2vd25-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 03 May 2020 08:39:46 -0400
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 043CZhWs004008;
        Sun, 3 May 2020 12:39:44 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04fra.de.ibm.com with ESMTP id 30s0g6126p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 03 May 2020 12:39:43 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 043CdfPY22806558
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 3 May 2020 12:39:41 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E55254C046;
        Sun,  3 May 2020 12:39:40 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AF4F54C044;
        Sun,  3 May 2020 12:39:40 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Sun,  3 May 2020 12:39:40 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: [PATCH net-next v2 04/11] net/smc: first part of add link processing as SMC server
Date:   Sun,  3 May 2020 14:38:43 +0200
Message-Id: <20200503123850.57261-5-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200503123850.57261-1-kgraul@linux.ibm.com>
References: <20200503123850.57261-1-kgraul@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-05-03_09:2020-05-01,2020-05-03 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=1 adultscore=0
 impostorscore=0 mlxscore=0 phishscore=0 spamscore=0 bulkscore=0
 lowpriorityscore=0 mlxlogscore=999 malwarescore=0 clxscore=1015
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005030112
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

First set of functions to process an ADD_LINK LLC request as an SMC
server. Find an alternate IB device, determine the new link group type
and get the index for the new link. Then initialize the link and send
the ADD_LINK LLC message to the peer. Save the contents of the response,
ready the link, map all used buffers and register the buffers with the
IB device. If any error occurs, stop the processing and clear the link.
And call smc_llc_srv_add_link() in af_smc.c to start second link
establishment after the initial link of a link group was created.

Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
Reviewed-by: Ursula Braun <ubraun@linux.ibm.com>
---
 net/smc/af_smc.c  |  2 +-
 net/smc/smc_llc.c | 91 ++++++++++++++++++++++++++++++++++++++++++++++-
 net/smc/smc_llc.h |  1 +
 3 files changed, 92 insertions(+), 2 deletions(-)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index 1afb6e4275f2..c67272007f41 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -1067,7 +1067,7 @@ static int smcr_serv_conf_first_link(struct smc_sock *smc)
 	smc_llc_link_active(link);
 
 	/* initial contact - try to establish second link */
-	/* tbd: call smc_llc_srv_add_link(link); */
+	smc_llc_srv_add_link(link);
 	return 0;
 }
 
diff --git a/net/smc/smc_llc.c b/net/smc/smc_llc.c
index d56ca60597d4..e2f254e21759 100644
--- a/net/smc/smc_llc.c
+++ b/net/smc/smc_llc.c
@@ -863,6 +863,94 @@ static void smc_llc_process_cli_add_link(struct smc_link_group *lgr)
 	mutex_unlock(&lgr->llc_conf_mutex);
 }
 
+int smc_llc_srv_add_link(struct smc_link *link)
+{
+	enum smc_lgr_type lgr_new_t = SMC_LGR_SYMMETRIC;
+	struct smc_link_group *lgr = link->lgr;
+	struct smc_llc_msg_add_link *add_llc;
+	struct smc_llc_qentry *qentry = NULL;
+	struct smc_link *link_new;
+	struct smc_init_info ini;
+	int lnk_idx, rc = 0;
+
+	/* ignore client add link recommendation, start new flow */
+	ini.vlan_id = lgr->vlan_id;
+	smc_pnet_find_alt_roce(lgr, &ini, link->smcibdev);
+	if (!ini.ib_dev) {
+		lgr_new_t = SMC_LGR_ASYMMETRIC_LOCAL;
+		ini.ib_dev = link->smcibdev;
+		ini.ib_port = link->ibport;
+	}
+	lnk_idx = smc_llc_alloc_alt_link(lgr, lgr_new_t);
+	if (lnk_idx < 0)
+		return 0;
+
+	rc = smcr_link_init(lgr, &lgr->lnk[lnk_idx], lnk_idx, &ini);
+	if (rc)
+		return rc;
+	link_new = &lgr->lnk[lnk_idx];
+	rc = smc_llc_send_add_link(link,
+				   link_new->smcibdev->mac[ini.ib_port - 1],
+				   link_new->gid, link_new, SMC_LLC_REQ);
+	if (rc)
+		goto out_err;
+	/* receive ADD LINK response over the RoCE fabric */
+	qentry = smc_llc_wait(lgr, link, SMC_LLC_WAIT_TIME, SMC_LLC_ADD_LINK);
+	if (!qentry) {
+		rc = -ETIMEDOUT;
+		goto out_err;
+	}
+	add_llc = &qentry->msg.add_link;
+	if (add_llc->hd.flags & SMC_LLC_FLAG_ADD_LNK_REJ) {
+		smc_llc_flow_qentry_del(&lgr->llc_flow_lcl);
+		rc = -ENOLINK;
+		goto out_err;
+	}
+	if (lgr->type == SMC_LGR_SINGLE &&
+	    (!memcmp(add_llc->sender_gid, link->peer_gid, SMC_GID_SIZE) &&
+	     !memcmp(add_llc->sender_mac, link->peer_mac, ETH_ALEN))) {
+		lgr_new_t = SMC_LGR_ASYMMETRIC_PEER;
+	}
+	smc_llc_save_add_link_info(link_new, add_llc);
+	smc_llc_flow_qentry_del(&lgr->llc_flow_lcl);
+
+	rc = smc_ib_ready_link(link_new);
+	if (rc)
+		goto out_err;
+	rc = smcr_buf_map_lgr(link_new);
+	if (rc)
+		goto out_err;
+	rc = smcr_buf_reg_lgr(link_new);
+	if (rc)
+		goto out_err;
+	/* tbd: rc = smc_llc_srv_rkey_exchange(link, link_new); */
+	if (rc)
+		goto out_err;
+	/* tbd: rc = smc_llc_srv_conf_link(link, link_new, lgr_new_t); */
+	if (rc)
+		goto out_err;
+	return 0;
+out_err:
+	smcr_link_clear(link_new);
+	return rc;
+}
+
+static void smc_llc_process_srv_add_link(struct smc_link_group *lgr)
+{
+	struct smc_link *link = lgr->llc_flow_lcl.qentry->link;
+	int rc;
+
+	smc_llc_flow_qentry_del(&lgr->llc_flow_lcl);
+
+	mutex_lock(&lgr->llc_conf_mutex);
+	rc = smc_llc_srv_add_link(link);
+	if (!rc && lgr->type == SMC_LGR_SYMMETRIC) {
+		/* delete any asymmetric link */
+		/* tbd: smc_llc_delete_asym_link(lgr); */
+	}
+	mutex_unlock(&lgr->llc_conf_mutex);
+}
+
 /* worker to process an add link message */
 static void smc_llc_add_link_work(struct work_struct *work)
 {
@@ -877,7 +965,8 @@ static void smc_llc_add_link_work(struct work_struct *work)
 
 	if (lgr->role == SMC_CLNT)
 		smc_llc_process_cli_add_link(lgr);
-	/* tbd: call smc_llc_process_srv_add_link(lgr); */
+	else
+		smc_llc_process_srv_add_link(lgr);
 out:
 	smc_llc_flow_stop(lgr, &lgr->llc_flow_lcl);
 }
diff --git a/net/smc/smc_llc.h b/net/smc/smc_llc.h
index 7c314bbef8c8..1a7748d0541f 100644
--- a/net/smc/smc_llc.h
+++ b/net/smc/smc_llc.h
@@ -89,6 +89,7 @@ struct smc_llc_qentry *smc_llc_wait(struct smc_link_group *lgr,
 struct smc_llc_qentry *smc_llc_flow_qentry_clr(struct smc_llc_flow *flow);
 void smc_llc_flow_qentry_del(struct smc_llc_flow *flow);
 int smc_llc_cli_add_link(struct smc_link *link, struct smc_llc_qentry *qentry);
+int smc_llc_srv_add_link(struct smc_link *link);
 int smc_llc_init(void) __init;
 
 #endif /* SMC_LLC_H */
-- 
2.17.1

