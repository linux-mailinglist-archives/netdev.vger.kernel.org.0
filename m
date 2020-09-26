Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA6F6279882
	for <lists+netdev@lfdr.de>; Sat, 26 Sep 2020 12:46:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729106AbgIZKpC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Sep 2020 06:45:02 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:34496 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726935AbgIZKoy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Sep 2020 06:44:54 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08QAWYot045122;
        Sat, 26 Sep 2020 06:44:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=7nav4aXpjbPdur/PdDJwEUODjYG9WIzvjBtrmUgh0ao=;
 b=tgEc0/AKrdigOzoiVt4gJ5jdr6gSCo7heqK76JtjEk/teFdtuwBV3A8qpEeagBbK3a9X
 Ln2dM7LWuu67cwlobZV03YhhgkK+1vwN0104/EPLQ5NYb23WKLdAFXUPK4Hqu+csEyFY
 j8kzqs7njZubBaOz14jkXZgkONg3/rwHQYdqhdOgpZjMPBF7ffB/sVkYowOLwh6ca09t
 pdTCxSGJNr+G0f+7fmqfk6OyepUcTss6APoH7nL8OsRV41tiACtuWfyMaUvXRoTgzPSQ
 tYTVaQSrLOd1dck7UvkckO+L4OOb7m5szCIUbgC/ASEnvqo/TTzEUopBxtJcLikR4GBT Ag== 
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33t33j120u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 26 Sep 2020 06:44:50 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08QAghIk013194;
        Sat, 26 Sep 2020 10:44:48 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma02fra.de.ibm.com with ESMTP id 33sw9804qr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 26 Sep 2020 10:44:48 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08QAijSs29360524
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 26 Sep 2020 10:44:45 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A53D8A4054;
        Sat, 26 Sep 2020 10:44:45 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6109DA4060;
        Sat, 26 Sep 2020 10:44:45 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Sat, 26 Sep 2020 10:44:45 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: [PATCH net-next 03/14] net/smc: separate find device functions
Date:   Sat, 26 Sep 2020 12:44:21 +0200
Message-Id: <20200926104432.74293-4-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200926104432.74293-1-kgraul@linux.ibm.com>
References: <20200926104432.74293-1-kgraul@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-26_06:2020-09-24,2020-09-26 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=1
 mlxlogscore=999 lowpriorityscore=0 impostorscore=0 spamscore=0 mlxscore=0
 adultscore=0 phishscore=0 priorityscore=1501 clxscore=1015 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009260096
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ursula Braun <ubraun@linux.ibm.com>

This patch provides better separation of device determinations
in function smc_listen_work(). No functional change.

Signed-off-by: Ursula Braun <ubraun@linux.ibm.com>
Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
---
 net/smc/af_smc.c  | 111 ++++++++++++++++++++++++++++------------------
 net/smc/smc_clc.c |   6 +--
 net/smc/smc_clc.h |  13 +++++-
 3 files changed, 84 insertions(+), 46 deletions(-)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index 1a02d3665c46..911482741224 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -1188,7 +1188,6 @@ static int smc_listen_rdma_init(struct smc_sock *new_smc,
 
 /* listen worker: initialize connection and buffers for SMC-D */
 static int smc_listen_ism_init(struct smc_sock *new_smc,
-			       struct smc_clc_msg_proposal *pclc,
 			       struct smc_init_info *ini)
 {
 	int rc;
@@ -1211,6 +1210,26 @@ static int smc_listen_ism_init(struct smc_sock *new_smc,
 	return 0;
 }
 
+static void smc_find_ism_device_serv(struct smc_sock *new_smc,
+				     struct smc_clc_msg_proposal *pclc,
+				     struct smc_init_info *ini)
+{
+	struct smc_clc_msg_smcd *pclc_smcd = smc_get_clc_msg_smcd(pclc);
+
+	if (!smcd_indicated(pclc->hdr.typev1))
+		goto not_found;
+	ini->is_smcd = true; /* prepare ISM check */
+	ini->ism_peer_gid = pclc_smcd->gid;
+	if (smc_find_ism_device(new_smc, ini))
+		goto not_found;
+	if (!smc_listen_ism_init(new_smc, ini))
+		return;		/* ISM device found */
+
+not_found:
+	ini->ism_dev = NULL;
+	ini->is_smcd = false;
+}
+
 /* listen worker: register buffers */
 static int smc_listen_rdma_reg(struct smc_sock *new_smc, bool local_first)
 {
@@ -1225,6 +1244,47 @@ static int smc_listen_rdma_reg(struct smc_sock *new_smc, bool local_first)
 	return 0;
 }
 
+static int smc_find_rdma_device_serv(struct smc_sock *new_smc,
+				     struct smc_clc_msg_proposal *pclc,
+				     struct smc_init_info *ini)
+{
+	int rc;
+
+	if (!smcr_indicated(pclc->hdr.typev1))
+		return SMC_CLC_DECL_NOSMCDEV;
+
+	/* prepare RDMA check */
+	ini->ib_lcl = &pclc->lcl;
+	rc = smc_find_rdma_device(new_smc, ini);
+	if (rc) {
+		/* no RDMA device found */
+		if (pclc->hdr.typev1 == SMC_TYPE_B)
+			/* neither ISM nor RDMA device found */
+			rc = SMC_CLC_DECL_NOSMCDEV;
+		return rc;
+	}
+	rc = smc_listen_rdma_init(new_smc, ini);
+	if (rc)
+		return rc;
+	return smc_listen_rdma_reg(new_smc, ini->first_contact_local);
+}
+
+/* determine the local device matching to proposal */
+static int smc_listen_find_device(struct smc_sock *new_smc,
+				  struct smc_clc_msg_proposal *pclc,
+				  struct smc_init_info *ini)
+{
+	/* check if ISM is available */
+	smc_find_ism_device_serv(new_smc, pclc, ini);
+	if (ini->is_smcd)
+		return 0;
+	if (pclc->hdr.typev1 == SMC_TYPE_D)
+		return SMC_CLC_DECL_NOSMCDDEV; /* skip RDMA and decline */
+
+	/* check if RDMA is available */
+	return smc_find_rdma_device_serv(new_smc, pclc, ini);
+}
+
 /* listen worker: finish RDMA setup */
 static int smc_listen_rdma_finish(struct smc_sock *new_smc,
 				  struct smc_clc_msg_accept_confirm *cclc,
@@ -1250,7 +1310,7 @@ static int smc_listen_rdma_finish(struct smc_sock *new_smc,
 	return reason_code;
 }
 
-/* setup for RDMA connection of server */
+/* setup for connection of server */
 static void smc_listen_work(struct work_struct *work)
 {
 	struct smc_sock *new_smc = container_of(work, struct smc_sock,
@@ -1260,7 +1320,6 @@ static void smc_listen_work(struct work_struct *work)
 	struct smc_clc_msg_proposal_area *buf;
 	struct smc_clc_msg_proposal *pclc;
 	struct smc_init_info ini = {0};
-	bool ism_supported = false;
 	int rc = 0;
 
 	if (new_smc->listen_smc->sk.sk_state != SMC_LISTEN)
@@ -1315,42 +1374,10 @@ static void smc_listen_work(struct work_struct *work)
 	smc_rx_init(new_smc);
 	smc_tx_init(new_smc);
 
-	/* check if ISM is available */
-	if (pclc->hdr.typev1 == SMC_TYPE_D || pclc->hdr.typev1 == SMC_TYPE_B) {
-		struct smc_clc_msg_smcd *pclc_smcd = smc_get_clc_msg_smcd(pclc);
-
-		ini.is_smcd = true; /* prepare ISM check */
-		ini.ism_peer_gid = pclc_smcd->gid;
-		rc = smc_find_ism_device(new_smc, &ini);
-		if (!rc)
-			rc = smc_listen_ism_init(new_smc, pclc, &ini);
-		if (!rc)
-			ism_supported = true;
-		else if (pclc->hdr.typev1 == SMC_TYPE_D)
-			goto out_unlock; /* skip RDMA and decline */
-	}
-
-	/* check if RDMA is available */
-	if (!ism_supported) { /* SMC_TYPE_R or SMC_TYPE_B */
-		/* prepare RDMA check */
-		ini.is_smcd = false;
-		ini.ism_dev = NULL;
-		ini.ib_lcl = &pclc->lcl;
-		rc = smc_find_rdma_device(new_smc, &ini);
-		if (rc) {
-			/* no RDMA device found */
-			if (pclc->hdr.typev1 == SMC_TYPE_B)
-				/* neither ISM nor RDMA device found */
-				rc = SMC_CLC_DECL_NOSMCDEV;
-			goto out_unlock;
-		}
-		rc = smc_listen_rdma_init(new_smc, &ini);
-		if (rc)
-			goto out_unlock;
-		rc = smc_listen_rdma_reg(new_smc, ini.first_contact_local);
-		if (rc)
-			goto out_unlock;
-	}
+	/* determine ISM or RoCE device used for connection */
+	rc = smc_listen_find_device(new_smc, pclc, &ini);
+	if (rc)
+		goto out_unlock;
 
 	/* send SMC Accept CLC message */
 	rc = smc_clc_send_accept(new_smc, ini.first_contact_local);
@@ -1358,20 +1385,20 @@ static void smc_listen_work(struct work_struct *work)
 		goto out_unlock;
 
 	/* SMC-D does not need this lock any more */
-	if (ism_supported)
+	if (ini.is_smcd)
 		mutex_unlock(&smc_server_lgr_pending);
 
 	/* receive SMC Confirm CLC message */
 	rc = smc_clc_wait_msg(new_smc, &cclc, sizeof(cclc),
 			      SMC_CLC_CONFIRM, CLC_WAIT_TIME);
 	if (rc) {
-		if (!ism_supported)
+		if (!ini.is_smcd)
 			goto out_unlock;
 		goto out_decl;
 	}
 
 	/* finish worker */
-	if (!ism_supported) {
+	if (!ini.is_smcd) {
 		rc = smc_listen_rdma_finish(new_smc, &cclc,
 					    ini.first_contact_local);
 		if (rc)
diff --git a/net/smc/smc_clc.c b/net/smc/smc_clc.c
index 524d2b225640..85b41c125368 100644
--- a/net/smc/smc_clc.c
+++ b/net/smc/smc_clc.c
@@ -450,7 +450,7 @@ int smc_clc_send_proposal(struct smc_sock *smc, int smc_type,
 	pclc_base->hdr.type = SMC_CLC_PROPOSAL;
 	pclc_base->hdr.version = SMC_V1;		/* SMC version */
 	pclc_base->hdr.typev1 = smc_type;
-	if (smc_type == SMC_TYPE_R || smc_type == SMC_TYPE_B) {
+	if (smcr_indicated(smc_type)) {
 		/* add SMC-R specifics */
 		memcpy(pclc_base->lcl.id_for_peer, local_systemid,
 		       sizeof(local_systemid));
@@ -459,7 +459,7 @@ int smc_clc_send_proposal(struct smc_sock *smc, int smc_type,
 		       ETH_ALEN);
 		pclc_base->iparea_offset = htons(0);
 	}
-	if (smc_type == SMC_TYPE_D || smc_type == SMC_TYPE_B) {
+	if (smcd_indicated(smc_type)) {
 		/* add SMC-D specifics */
 		plen += sizeof(*pclc_smcd);
 		pclc_base->iparea_offset = htons(sizeof(*pclc_smcd));
@@ -472,7 +472,7 @@ int smc_clc_send_proposal(struct smc_sock *smc, int smc_type,
 	i = 0;
 	vec[i].iov_base = pclc_base;
 	vec[i++].iov_len = sizeof(*pclc_base);
-	if (smc_type == SMC_TYPE_D || smc_type == SMC_TYPE_B) {
+	if (smcd_indicated(smc_type)) {
 		vec[i].iov_base = pclc_smcd;
 		vec[i++].iov_len = sizeof(*pclc_smcd);
 	}
diff --git a/net/smc/smc_clc.h b/net/smc/smc_clc.h
index 5b2d0582886e..5f9fda15f7ff 100644
--- a/net/smc/smc_clc.h
+++ b/net/smc/smc_clc.h
@@ -180,11 +180,22 @@ smc_clc_proposal_get_prefix(struct smc_clc_msg_proposal *pclc)
 	       ((u8 *)pclc + sizeof(*pclc) + ntohs(pclc->iparea_offset));
 }
 
+static inline bool smcr_indicated(int smc_type)
+{
+	return smc_type == SMC_TYPE_R || smc_type == SMC_TYPE_B;
+}
+
+static inline bool smcd_indicated(int smc_type)
+{
+	return smc_type == SMC_TYPE_D || smc_type == SMC_TYPE_B;
+}
+
 /* get SMC-D info from proposal message */
 static inline struct smc_clc_msg_smcd *
 smc_get_clc_msg_smcd(struct smc_clc_msg_proposal *prop)
 {
-	if (ntohs(prop->iparea_offset) != sizeof(struct smc_clc_msg_smcd))
+	if (smcd_indicated(prop->hdr.type) &&
+	    ntohs(prop->iparea_offset) != sizeof(struct smc_clc_msg_smcd))
 		return NULL;
 
 	return (struct smc_clc_msg_smcd *)(prop + 1);
-- 
2.17.1

