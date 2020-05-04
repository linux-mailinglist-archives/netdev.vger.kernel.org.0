Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AA8F1C3938
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 14:19:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728809AbgEDMTg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 08:19:36 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:46372 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728746AbgEDMTQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 08:19:16 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 044CAxl9113508;
        Mon, 4 May 2020 08:19:14 -0400
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0b-001b2d01.pphosted.com with ESMTP id 30tfg5xpbd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 May 2020 08:19:14 -0400
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 044C9tSv018222;
        Mon, 4 May 2020 12:19:12 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma01fra.de.ibm.com with ESMTP id 30s0g59x4m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 May 2020 12:19:12 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 044CJ9NB3342728
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 4 May 2020 12:19:09 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 82899A4040;
        Mon,  4 May 2020 12:19:09 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 52FDBA405B;
        Mon,  4 May 2020 12:19:09 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  4 May 2020 12:19:09 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: [PATCH net-next 08/12] net/smc: asymmetric link tagging
Date:   Mon,  4 May 2020 14:18:44 +0200
Message-Id: <20200504121848.46585-9-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200504121848.46585-1-kgraul@linux.ibm.com>
References: <20200504121848.46585-1-kgraul@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-05-04_06:2020-05-04,2020-05-04 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 lowpriorityscore=0 clxscore=1015 suspectscore=1 phishscore=0
 priorityscore=1501 bulkscore=0 mlxscore=0 impostorscore=0 adultscore=0
 spamscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005040100
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

New connections must not be assigned to asymmetric links. Add asymmetric
link tagging using new link variable link_is_asym. The new helpers
smcr_lgr_set_type() and smcr_lgr_set_type_asym() are called to set the
state of the link group, and tag all links accordingly.
smcr_lgr_conn_assign_link() respects the link tagging and will not
assign new connections to links tagged as asymmetric link.

Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
Reviewed-by: Ursula Braun <ubraun@linux.ibm.com>
---
 net/smc/smc_core.c | 26 +++++++++++++++++++++++---
 net/smc/smc_core.h |  4 ++++
 net/smc/smc_llc.c  | 20 ++++++++++++++------
 3 files changed, 41 insertions(+), 9 deletions(-)

diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index 9c19b9aa3719..be15b30a1234 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -132,7 +132,7 @@ static int smcr_lgr_conn_assign_link(struct smc_connection *conn, bool first)
 	for (i = 0; i < SMC_LINKS_PER_LGR_MAX; i++) {
 		struct smc_link *lnk = &conn->lgr->lnk[i];
 
-		if (lnk->state != expected)
+		if (lnk->state != expected || lnk->link_is_asym)
 			continue;
 		if (conn->lgr->role == SMC_CLNT) {
 			conn->lnk = lnk; /* temporary, SMC server assigns link*/
@@ -143,7 +143,8 @@ static int smcr_lgr_conn_assign_link(struct smc_connection *conn, bool first)
 				struct smc_link *lnk2;
 
 				lnk2 = &conn->lgr->lnk[j];
-				if (lnk2->state == expected) {
+				if (lnk2->state == expected &&
+				    !lnk2->link_is_asym) {
 					conn->lnk = lnk2;
 					break;
 				}
@@ -1030,6 +1031,25 @@ void smc_smcr_terminate_all(struct smc_ib_device *smcibdev)
 	}
 }
 
+/* set new lgr type and clear all asymmetric link tagging */
+void smcr_lgr_set_type(struct smc_link_group *lgr, enum smc_lgr_type new_type)
+{
+	int i;
+
+	for (i = 0; i < SMC_LINKS_PER_LGR_MAX; i++)
+		if (smc_link_usable(&lgr->lnk[i]))
+			lgr->lnk[i].link_is_asym = false;
+	lgr->type = new_type;
+}
+
+/* set new lgr type and tag a link as asymmetric */
+void smcr_lgr_set_type_asym(struct smc_link_group *lgr,
+			    enum smc_lgr_type new_type, int asym_lnk_idx)
+{
+	smcr_lgr_set_type(lgr, new_type);
+	lgr->lnk[asym_lnk_idx].link_is_asym = true;
+}
+
 /* abort connection, abort_work scheduled from tasklet context */
 static void smc_conn_abort_work(struct work_struct *work)
 {
@@ -1123,7 +1143,7 @@ static void smcr_link_down(struct smc_link *lnk)
 		smcr_link_clear(lnk);
 		return;
 	}
-	lgr->type = SMC_LGR_SINGLE;
+	smcr_lgr_set_type(lgr, SMC_LGR_SINGLE);
 	del_link_id = lnk->link_id;
 
 	if (lgr->role == SMC_SERV) {
diff --git a/net/smc/smc_core.h b/net/smc/smc_core.h
index 86eebbadc8f6..6ed7ab6d89d5 100644
--- a/net/smc/smc_core.h
+++ b/net/smc/smc_core.h
@@ -117,6 +117,7 @@ struct smc_link {
 	u8			peer_gid[SMC_GID_SIZE];	/* gid of peer*/
 	u8			link_id;	/* unique # within link group */
 	u8			link_idx;	/* index in lgr link array */
+	u8			link_is_asym;	/* is link asymmetric? */
 	struct smc_link_group	*lgr;		/* parent link group */
 	struct work_struct	link_down_wrk;	/* wrk to bring link down */
 
@@ -380,6 +381,9 @@ int smcr_link_init(struct smc_link_group *lgr, struct smc_link *lnk,
 void smcr_link_clear(struct smc_link *lnk);
 int smcr_buf_map_lgr(struct smc_link *lnk);
 int smcr_buf_reg_lgr(struct smc_link *lnk);
+void smcr_lgr_set_type(struct smc_link_group *lgr, enum smc_lgr_type new_type);
+void smcr_lgr_set_type_asym(struct smc_link_group *lgr,
+			    enum smc_lgr_type new_type, int asym_lnk_idx);
 int smcr_link_reg_rmb(struct smc_link *link, struct smc_buf_desc *rmb_desc);
 struct smc_link *smc_switch_conns(struct smc_link_group *lgr,
 				  struct smc_link *from_lnk, bool is_dev_err);
diff --git a/net/smc/smc_llc.c b/net/smc/smc_llc.c
index 0ea7ad6188ae..f65b2aac6b52 100644
--- a/net/smc/smc_llc.c
+++ b/net/smc/smc_llc.c
@@ -796,7 +796,11 @@ static int smc_llc_cli_conf_link(struct smc_link *link,
 		return -ENOLINK;
 	}
 	smc_llc_link_active(link_new);
-	lgr->type = lgr_new_t;
+	if (lgr_new_t == SMC_LGR_ASYMMETRIC_LOCAL ||
+	    lgr_new_t == SMC_LGR_ASYMMETRIC_PEER)
+		smcr_lgr_set_type_asym(lgr, lgr_new_t, link_new->link_idx);
+	else
+		smcr_lgr_set_type(lgr, lgr_new_t);
 	return 0;
 }
 
@@ -1038,7 +1042,11 @@ static int smc_llc_srv_conf_link(struct smc_link *link,
 		return -ENOLINK;
 	}
 	smc_llc_link_active(link_new);
-	lgr->type = lgr_new_t;
+	if (lgr_new_t == SMC_LGR_ASYMMETRIC_LOCAL ||
+	    lgr_new_t == SMC_LGR_ASYMMETRIC_PEER)
+		smcr_lgr_set_type_asym(lgr, lgr_new_t, link_new->link_idx);
+	else
+		smcr_lgr_set_type(lgr, lgr_new_t);
 	smc_llc_flow_qentry_del(&lgr->llc_flow_lcl);
 	return 0;
 }
@@ -1223,9 +1231,9 @@ static void smc_llc_process_cli_delete_link(struct smc_link_group *lgr)
 	if (lnk_del == lnk_asym) {
 		/* expected deletion of asym link, don't change lgr state */
 	} else if (active_links == 1) {
-		lgr->type = SMC_LGR_SINGLE;
+		smcr_lgr_set_type(lgr, SMC_LGR_SINGLE);
 	} else if (!active_links) {
-		lgr->type = SMC_LGR_NONE;
+		smcr_lgr_set_type(lgr, SMC_LGR_NONE);
 		smc_lgr_terminate_sched(lgr);
 	}
 out_unlock:
@@ -1314,9 +1322,9 @@ static void smc_llc_process_srv_delete_link(struct smc_link_group *lgr)
 
 	active_links = smc_llc_active_link_count(lgr);
 	if (active_links == 1) {
-		lgr->type = SMC_LGR_SINGLE;
+		smcr_lgr_set_type(lgr, SMC_LGR_SINGLE);
 	} else if (!active_links) {
-		lgr->type = SMC_LGR_NONE;
+		smcr_lgr_set_type(lgr, SMC_LGR_NONE);
 		smc_lgr_terminate_sched(lgr);
 	}
 
-- 
2.17.1

