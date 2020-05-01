Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAB731C111D
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 12:48:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728661AbgEAKsg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 06:48:36 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:57462 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728609AbgEAKsb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 May 2020 06:48:31 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 041AWOBU014922;
        Fri, 1 May 2020 06:48:27 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 30r84me1r1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 01 May 2020 06:48:27 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 041Ak6bY026486;
        Fri, 1 May 2020 10:48:25 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03ams.nl.ibm.com with ESMTP id 30mcu5vh5m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 01 May 2020 10:48:25 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 041AmM6P45940818
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 1 May 2020 10:48:22 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AE369A4054;
        Fri,  1 May 2020 10:48:22 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 72689A405B;
        Fri,  1 May 2020 10:48:22 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  1 May 2020 10:48:22 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: [PATCH net-next 01/13] net/smc: multiple link support for rmb buffer registration
Date:   Fri,  1 May 2020 12:48:01 +0200
Message-Id: <20200501104813.76601-2-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200501104813.76601-1-kgraul@linux.ibm.com>
References: <20200501104813.76601-1-kgraul@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-05-01_03:2020-04-30,2020-05-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 lowpriorityscore=0
 malwarescore=0 bulkscore=0 impostorscore=0 clxscore=1015 suspectscore=3
 spamscore=0 priorityscore=1501 phishscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005010073
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The CONFIRM_RKEY LLC processing handles all links in one LLC message.
Move the call to this processing out of smcr_link_reg_rmb() which does
processing per link, into smcr_lgr_reg_rmbs() which is responsible for
link group level processing. Move smcr_link_reg_rmb() into module
smc_core.c.
From af_smc.c now call smcr_lgr_reg_rmbs() to register new rmbs on all
available links.

Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
Reviewed-by: Ursula Braun <ubraun@linux.ibm.com>
---
 net/smc/af_smc.c   | 54 ++++++++++++++++------------------------------
 net/smc/smc_core.c | 16 ++++++++++++++
 net/smc/smc_core.h |  1 +
 3 files changed, 36 insertions(+), 35 deletions(-)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index bd9662d06896..20d6d3fbb86c 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -337,46 +337,30 @@ static void smc_copy_sock_settings_to_smc(struct smc_sock *smc)
 	smc_copy_sock_settings(&smc->sk, smc->clcsock->sk, SK_FLAGS_CLC_TO_SMC);
 }
 
-/* register a new rmb, send confirm_rkey msg to register with peer */
-static int smcr_link_reg_rmb(struct smc_link *link,
-			     struct smc_buf_desc *rmb_desc, bool conf_rkey)
-{
-	if (!rmb_desc->is_reg_mr[link->link_idx]) {
-		/* register memory region for new rmb */
-		if (smc_wr_reg_send(link, rmb_desc->mr_rx[link->link_idx])) {
-			rmb_desc->is_reg_err = true;
-			return -EFAULT;
-		}
-		rmb_desc->is_reg_mr[link->link_idx] = true;
-	}
-	if (!conf_rkey)
-		return 0;
-
-	/* exchange confirm_rkey msg with peer */
-	if (!rmb_desc->is_conf_rkey) {
-		if (smc_llc_do_confirm_rkey(link, rmb_desc)) {
-			rmb_desc->is_reg_err = true;
-			return -EFAULT;
-		}
-		rmb_desc->is_conf_rkey = true;
-	}
-	return 0;
-}
-
 /* register the new rmb on all links */
-static int smcr_lgr_reg_rmbs(struct smc_link_group *lgr,
+static int smcr_lgr_reg_rmbs(struct smc_link *link,
 			     struct smc_buf_desc *rmb_desc)
 {
-	int i, rc;
+	struct smc_link_group *lgr = link->lgr;
+	int i, rc = 0;
 
 	for (i = 0; i < SMC_LINKS_PER_LGR_MAX; i++) {
 		if (lgr->lnk[i].state != SMC_LNK_ACTIVE)
 			continue;
-		rc = smcr_link_reg_rmb(&lgr->lnk[i], rmb_desc, true);
+		rc = smcr_link_reg_rmb(&lgr->lnk[i], rmb_desc);
 		if (rc)
-			return rc;
+			goto out;
 	}
-	return 0;
+
+	/* exchange confirm_rkey msg with peer */
+	rc = smc_llc_do_confirm_rkey(link, rmb_desc);
+	if (rc) {
+		rc = -EFAULT;
+		goto out;
+	}
+	rmb_desc->is_conf_rkey = true;
+out:
+	return rc;
 }
 
 static int smcr_clnt_conf_first_link(struct smc_sock *smc)
@@ -408,7 +392,7 @@ static int smcr_clnt_conf_first_link(struct smc_sock *smc)
 
 	smc_wr_remember_qp_attr(link);
 
-	if (smcr_link_reg_rmb(link, smc->conn.rmb_desc, false))
+	if (smcr_link_reg_rmb(link, smc->conn.rmb_desc))
 		return SMC_CLC_DECL_ERR_REGRMB;
 
 	/* confirm_rkey is implicit on 1st contact */
@@ -670,7 +654,7 @@ static int smc_connect_rdma(struct smc_sock *smc,
 			return smc_connect_abort(smc, SMC_CLC_DECL_ERR_RDYLNK,
 						 ini->cln_first_contact);
 	} else {
-		if (smcr_lgr_reg_rmbs(smc->conn.lgr, smc->conn.rmb_desc))
+		if (smcr_lgr_reg_rmbs(link, smc->conn.rmb_desc))
 			return smc_connect_abort(smc, SMC_CLC_DECL_ERR_REGRMB,
 						 ini->cln_first_contact);
 	}
@@ -1045,7 +1029,7 @@ static int smcr_serv_conf_first_link(struct smc_sock *smc)
 
 	link->lgr->type = SMC_LGR_SINGLE;
 
-	if (smcr_link_reg_rmb(link, smc->conn.rmb_desc, false))
+	if (smcr_link_reg_rmb(link, smc->conn.rmb_desc))
 		return SMC_CLC_DECL_ERR_REGRMB;
 
 	/* send CONFIRM LINK request to client over the RoCE fabric */
@@ -1220,7 +1204,7 @@ static int smc_listen_rdma_reg(struct smc_sock *new_smc, int local_contact)
 	struct smc_connection *conn = &new_smc->conn;
 
 	if (local_contact != SMC_FIRST_CONTACT) {
-		if (smcr_lgr_reg_rmbs(conn->lgr, conn->rmb_desc))
+		if (smcr_lgr_reg_rmbs(conn->lnk, conn->rmb_desc))
 			return SMC_CLC_DECL_ERR_REGRMB;
 	}
 	smc_rmb_sync_sg_for_device(&new_smc->conn);
diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index 3539ceef9a97..de6bc36fe9a7 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -1127,6 +1127,22 @@ static int smcr_buf_map_link(struct smc_buf_desc *buf_desc, bool is_rmb,
 	return rc;
 }
 
+/* register a new rmb on IB device */
+int smcr_link_reg_rmb(struct smc_link *link, struct smc_buf_desc *rmb_desc)
+{
+	if (list_empty(&link->lgr->list))
+		return -ENOLINK;
+	if (!rmb_desc->is_reg_mr[link->link_idx]) {
+		/* register memory region for new rmb */
+		if (smc_wr_reg_send(link, rmb_desc->mr_rx[link->link_idx])) {
+			rmb_desc->is_reg_err = true;
+			return -EFAULT;
+		}
+		rmb_desc->is_reg_mr[link->link_idx] = true;
+	}
+	return 0;
+}
+
 static struct smc_buf_desc *smcr_new_buf_create(struct smc_link_group *lgr,
 						bool is_rmb, int bufsize)
 {
diff --git a/net/smc/smc_core.h b/net/smc/smc_core.h
index f12474cc666c..fd512188d2c6 100644
--- a/net/smc/smc_core.h
+++ b/net/smc/smc_core.h
@@ -367,6 +367,7 @@ void smc_lgr_schedule_free_work_fast(struct smc_link_group *lgr);
 int smc_core_init(void);
 void smc_core_exit(void);
 
+int smcr_link_reg_rmb(struct smc_link *link, struct smc_buf_desc *rmb_desc);
 static inline struct smc_link_group *smc_get_lgr(struct smc_link *link)
 {
 	return link->lgr;
-- 
2.17.1

