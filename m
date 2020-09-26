Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9ADFA279884
	for <lists+netdev@lfdr.de>; Sat, 26 Sep 2020 12:46:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729122AbgIZKpH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Sep 2020 06:45:07 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:17254 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728274AbgIZKoz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Sep 2020 06:44:55 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08QAX0TW072594;
        Sat, 26 Sep 2020 06:44:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=EMNrWQdlaIPv+eIYEljgizY+V9rzsbRGHRvOTpJnHDQ=;
 b=MeBUbQKgWEKBEjC9qEGpgU6nMHnq0CYwtWB1dkUMMv9mKWboikZcyZW+i+uOfCopblxH
 RlMScDBRtV8O8scupAy4cmVe/brSiMXUzhm4ilsIf8o2595nSEgtHudNphSdx/6+bl38
 qJutI6pjnlE2bK17bqDtLHLae7Scm00cUA9Thch1F5s8Awl//NVkm2S7FlyDEnzXDrv/
 d3kOdjsvJ48IUtXERwekmJdTBGJURBDoIUuBuFPNuVNr7h2fw0iyeO3SdkaS4cKw1QrI
 tWToaOtH+g+XhoiqlFN6vldHceS69oDn8bey6R8KQgK0P0xWy3IQdoyHpaqZYKOP+m08 9A== 
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33t2cmhtj5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 26 Sep 2020 06:44:54 -0400
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08QAhJDs016243;
        Sat, 26 Sep 2020 10:44:51 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma06fra.de.ibm.com with ESMTP id 33svwgr52u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 26 Sep 2020 10:44:51 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08QAimX310420512
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 26 Sep 2020 10:44:48 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 62436A4064;
        Sat, 26 Sep 2020 10:44:48 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 23C4BA405F;
        Sat, 26 Sep 2020 10:44:48 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Sat, 26 Sep 2020 10:44:48 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: [PATCH net-next 12/14] net/smc: CLC accept / confirm V2
Date:   Sat, 26 Sep 2020 12:44:30 +0200
Message-Id: <20200926104432.74293-13-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200926104432.74293-1-kgraul@linux.ibm.com>
References: <20200926104432.74293-1-kgraul@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-26_07:2020-09-24,2020-09-26 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 phishscore=0
 mlxscore=0 lowpriorityscore=0 bulkscore=0 impostorscore=0 adultscore=0
 suspectscore=3 priorityscore=1501 mlxlogscore=999 malwarescore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009260096
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ursula Braun <ubraun@linux.ibm.com>

The new format of SMCD V2 CLC accept and confirm is introduced,
and building and checking of SMCD V2 CLC accepts / confirms is adapted
accordingly.

Signed-off-by: Ursula Braun <ubraun@linux.ibm.com>
Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
---
 net/smc/af_smc.c  | 101 ++++++++++++++++++++++++++++++++++++----------
 net/smc/smc_clc.c |  99 +++++++++++++++++++++++++++++++--------------
 net/smc/smc_clc.h |  27 ++++++++++---
 3 files changed, 170 insertions(+), 57 deletions(-)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index 3963a4d2b79f..da282a860cfb 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -660,9 +660,13 @@ static int smc_connect_ism_vlan_cleanup(struct smc_sock *smc,
 	return 0;
 }
 
+#define SMC_CLC_MAX_ACCEPT_LEN \
+	(sizeof(struct smc_clc_msg_accept_confirm_v2) + \
+	 sizeof(struct smc_clc_msg_trail))
+
 /* CLC handshake during connect */
 static int smc_connect_clc(struct smc_sock *smc,
-			   struct smc_clc_msg_accept_confirm *aclc,
+			   struct smc_clc_msg_accept_confirm_v2 *aclc2,
 			   struct smc_init_info *ini)
 {
 	int rc = 0;
@@ -672,8 +676,8 @@ static int smc_connect_clc(struct smc_sock *smc,
 	if (rc)
 		return rc;
 	/* receive SMC Accept CLC message */
-	return smc_clc_wait_msg(smc, aclc, sizeof(*aclc), SMC_CLC_ACCEPT,
-				CLC_WAIT_TIME);
+	return smc_clc_wait_msg(smc, aclc2, SMC_CLC_MAX_ACCEPT_LEN,
+				SMC_CLC_ACCEPT, CLC_WAIT_TIME);
 }
 
 /* setup for RDMA connection of client */
@@ -747,7 +751,8 @@ static int smc_connect_rdma(struct smc_sock *smc,
 	}
 	smc_rmb_sync_sg_for_device(&smc->conn);
 
-	reason_code = smc_clc_send_confirm(smc);
+	reason_code = smc_clc_send_confirm(smc, ini->first_contact_local,
+					   SMC_V1);
 	if (reason_code)
 		return smc_connect_abort(smc, reason_code,
 					 ini->first_contact_local);
@@ -773,6 +778,25 @@ static int smc_connect_rdma(struct smc_sock *smc,
 	return 0;
 }
 
+/* The server has chosen one of the proposed ISM devices for the communication.
+ * Determine from the CHID of the received CLC ACCEPT the ISM device chosen.
+ */
+static int
+smc_v2_determine_accepted_chid(struct smc_clc_msg_accept_confirm_v2 *aclc,
+			       struct smc_init_info *ini)
+{
+	int i;
+
+	for (i = 0; i < ini->ism_offered_cnt + 1; i++) {
+		if (ini->ism_chid[i] == ntohs(aclc->chid)) {
+			ini->ism_selected = i;
+			return 0;
+		}
+	}
+
+	return -EPROTO;
+}
+
 /* setup for ISM connection of client */
 static int smc_connect_ism(struct smc_sock *smc,
 			   struct smc_clc_msg_accept_confirm *aclc,
@@ -781,9 +805,18 @@ static int smc_connect_ism(struct smc_sock *smc,
 	int rc = 0;
 
 	ini->is_smcd = true;
-	ini->ism_peer_gid[0] = aclc->d0.gid;
 	ini->first_contact_peer = aclc->hdr.typev2 & SMC_FIRST_CONTACT_MASK;
 
+	if (aclc->hdr.version == SMC_V2) {
+		struct smc_clc_msg_accept_confirm_v2 *aclc_v2 =
+			(struct smc_clc_msg_accept_confirm_v2 *)aclc;
+
+		rc = smc_v2_determine_accepted_chid(aclc_v2, ini);
+		if (rc)
+			return rc;
+	}
+	ini->ism_peer_gid[ini->ism_selected] = aclc->d0.gid;
+
 	/* there is only one lgr role for SMC-D; use server lock */
 	mutex_lock(&smc_server_lgr_pending);
 	rc = smc_conn_create(smc, ini);
@@ -805,7 +838,8 @@ static int smc_connect_ism(struct smc_sock *smc,
 	smc_rx_init(smc);
 	smc_tx_init(smc);
 
-	rc = smc_clc_send_confirm(smc);
+	rc = smc_clc_send_confirm(smc, ini->first_contact_local,
+				  aclc->hdr.version);
 	if (rc)
 		return smc_connect_abort(smc, rc, ini->first_contact_local);
 	mutex_unlock(&smc_server_lgr_pending);
@@ -825,7 +859,12 @@ static int smc_connect_check_aclc(struct smc_init_info *ini,
 	if ((aclc->hdr.typev1 == SMC_TYPE_R &&
 	     !smcr_indicated(ini->smc_type_v1)) ||
 	    (aclc->hdr.typev1 == SMC_TYPE_D &&
-	     !smcd_indicated(ini->smc_type_v1)))
+	     ((!smcd_indicated(ini->smc_type_v1) &&
+	       !smcd_indicated(ini->smc_type_v2)) ||
+	      (aclc->hdr.version == SMC_V1 &&
+	       !smcd_indicated(ini->smc_type_v1)) ||
+	      (aclc->hdr.version == SMC_V2 &&
+	       !smcd_indicated(ini->smc_type_v2)))))
 		return SMC_CLC_DECL_MODEUNSUPP;
 
 	return 0;
@@ -834,8 +873,10 @@ static int smc_connect_check_aclc(struct smc_init_info *ini,
 /* perform steps before actually connecting */
 static int __smc_connect(struct smc_sock *smc)
 {
-	struct smc_clc_msg_accept_confirm aclc;
+	struct smc_clc_msg_accept_confirm_v2 *aclc2;
+	struct smc_clc_msg_accept_confirm *aclc;
 	struct smc_init_info *ini = NULL;
+	u8 *buf = NULL;
 	int rc = 0;
 
 	if (smc->use_fallback)
@@ -872,30 +913,40 @@ static int __smc_connect(struct smc_sock *smc)
 	if (rc)
 		goto fallback;
 
+	buf = kzalloc(SMC_CLC_MAX_ACCEPT_LEN, GFP_KERNEL);
+	if (!buf) {
+		rc = SMC_CLC_DECL_MEM;
+		goto fallback;
+	}
+	aclc2 = (struct smc_clc_msg_accept_confirm_v2 *)buf;
+	aclc = (struct smc_clc_msg_accept_confirm *)aclc2;
+
 	/* perform CLC handshake */
-	rc = smc_connect_clc(smc, &aclc, ini);
+	rc = smc_connect_clc(smc, aclc2, ini);
 	if (rc)
 		goto vlan_cleanup;
 
 	/* check if smc modes and versions of CLC proposal and accept match */
-	rc = smc_connect_check_aclc(ini, &aclc);
+	rc = smc_connect_check_aclc(ini, aclc);
 	if (rc)
 		goto vlan_cleanup;
 
 	/* depending on previous steps, connect using rdma or ism */
-	if (aclc.hdr.typev1 == SMC_TYPE_R)
-		rc = smc_connect_rdma(smc, &aclc, ini);
-	else if (aclc.hdr.typev1 == SMC_TYPE_D)
-		rc = smc_connect_ism(smc, &aclc, ini);
+	if (aclc->hdr.typev1 == SMC_TYPE_R)
+		rc = smc_connect_rdma(smc, aclc, ini);
+	else if (aclc->hdr.typev1 == SMC_TYPE_D)
+		rc = smc_connect_ism(smc, aclc, ini);
 	if (rc)
 		goto vlan_cleanup;
 
 	smc_connect_ism_vlan_cleanup(smc, ini);
+	kfree(buf);
 	kfree(ini);
 	return 0;
 
 vlan_cleanup:
 	smc_connect_ism_vlan_cleanup(smc, ini);
+	kfree(buf);
 fallback:
 	kfree(ini);
 	return smc_connect_decline_fallback(smc, rc);
@@ -1214,10 +1265,10 @@ static void smc_listen_out_err(struct smc_sock *new_smc)
 
 /* listen worker: decline and fall back if possible */
 static void smc_listen_decline(struct smc_sock *new_smc, int reason_code,
-			       bool local_first)
+			       struct smc_init_info *ini)
 {
 	/* RDMA setup failed, switch back to TCP */
-	if (local_first)
+	if (ini->first_contact_local)
 		smc_lgr_cleanup_early(&new_smc->conn);
 	else
 		smc_conn_free(&new_smc->conn);
@@ -1560,7 +1611,8 @@ static void smc_listen_work(struct work_struct *work)
 	struct smc_sock *new_smc = container_of(work, struct smc_sock,
 						smc_listen_work);
 	struct socket *newclcsock = new_smc->clcsock;
-	struct smc_clc_msg_accept_confirm cclc;
+	struct smc_clc_msg_accept_confirm_v2 *cclc2;
+	struct smc_clc_msg_accept_confirm *cclc;
 	struct smc_clc_msg_proposal_area *buf;
 	struct smc_clc_msg_proposal *pclc;
 	struct smc_init_info *ini = NULL;
@@ -1624,7 +1676,8 @@ static void smc_listen_work(struct work_struct *work)
 		goto out_unlock;
 
 	/* send SMC Accept CLC message */
-	rc = smc_clc_send_accept(new_smc, ini->first_contact_local);
+	rc = smc_clc_send_accept(new_smc, ini->first_contact_local,
+				 ini->smcd_version == SMC_V2 ? SMC_V2 : SMC_V1);
 	if (rc)
 		goto out_unlock;
 
@@ -1633,7 +1686,11 @@ static void smc_listen_work(struct work_struct *work)
 		mutex_unlock(&smc_server_lgr_pending);
 
 	/* receive SMC Confirm CLC message */
-	rc = smc_clc_wait_msg(new_smc, &cclc, sizeof(cclc),
+	cclc2 = (struct smc_clc_msg_accept_confirm_v2 *)buf;
+	cclc = (struct smc_clc_msg_accept_confirm *)cclc2;
+	memset(buf, 0, sizeof(struct smc_clc_msg_proposal_area));
+	rc = smc_clc_wait_msg(new_smc, cclc2,
+			      sizeof(struct smc_clc_msg_proposal_area),
 			      SMC_CLC_CONFIRM, CLC_WAIT_TIME);
 	if (rc) {
 		if (!ini->is_smcd)
@@ -1643,20 +1700,20 @@ static void smc_listen_work(struct work_struct *work)
 
 	/* finish worker */
 	if (!ini->is_smcd) {
-		rc = smc_listen_rdma_finish(new_smc, &cclc,
+		rc = smc_listen_rdma_finish(new_smc, cclc,
 					    ini->first_contact_local);
 		if (rc)
 			goto out_unlock;
 		mutex_unlock(&smc_server_lgr_pending);
 	}
-	smc_conn_save_peer_info(new_smc, &cclc);
+	smc_conn_save_peer_info(new_smc, cclc);
 	smc_listen_out_connected(new_smc);
 	goto out_free;
 
 out_unlock:
 	mutex_unlock(&smc_server_lgr_pending);
 out_decl:
-	smc_listen_decline(new_smc, rc, ini ? ini->first_contact_local : 0);
+	smc_listen_decline(new_smc, rc, ini);
 out_free:
 	kfree(ini);
 	kfree(buf);
diff --git a/net/smc/smc_clc.c b/net/smc/smc_clc.c
index 037c92a0c2b9..a2eb59dbcdb0 100644
--- a/net/smc/smc_clc.c
+++ b/net/smc/smc_clc.c
@@ -27,6 +27,7 @@
 
 #define SMCR_CLC_ACCEPT_CONFIRM_LEN 68
 #define SMCD_CLC_ACCEPT_CONFIRM_LEN 48
+#define SMCD_CLC_ACCEPT_CONFIRM_LEN_V2 78
 #define SMC_CLC_RECV_BUF_LEN	100
 
 /* eye catcher "SMCR" EBCDIC for CLC messages */
@@ -75,12 +76,34 @@ static bool smc_clc_msg_prop_valid(struct smc_clc_msg_proposal *pclc)
 	return true;
 }
 
+/* check arriving CLC accept or confirm */
+static bool
+smc_clc_msg_acc_conf_valid(struct smc_clc_msg_accept_confirm_v2 *clc_v2)
+{
+	struct smc_clc_msg_hdr *hdr = &clc_v2->hdr;
+
+	if (hdr->typev1 != SMC_TYPE_R && hdr->typev1 != SMC_TYPE_D)
+		return false;
+	if (hdr->version == SMC_V1) {
+		if ((hdr->typev1 == SMC_TYPE_R &&
+		     ntohs(hdr->length) != SMCR_CLC_ACCEPT_CONFIRM_LEN) ||
+		    (hdr->typev1 == SMC_TYPE_D &&
+		     ntohs(hdr->length) != SMCD_CLC_ACCEPT_CONFIRM_LEN))
+			return false;
+	} else {
+		if (hdr->typev1 == SMC_TYPE_D &&
+		    ntohs(hdr->length) != SMCD_CLC_ACCEPT_CONFIRM_LEN_V2)
+			return false;
+	}
+	return true;
+}
+
 /* check if received message has a correct header length and contains valid
  * heading and trailing eyecatchers
  */
 static bool smc_clc_msg_hdr_valid(struct smc_clc_msg_hdr *clcm, bool check_trl)
 {
-	struct smc_clc_msg_accept_confirm *clc;
+	struct smc_clc_msg_accept_confirm_v2 *clc_v2;
 	struct smc_clc_msg_proposal *pclc;
 	struct smc_clc_msg_decline *dclc;
 	struct smc_clc_msg_trail *trl;
@@ -98,16 +121,12 @@ static bool smc_clc_msg_hdr_valid(struct smc_clc_msg_hdr *clcm, bool check_trl)
 		break;
 	case SMC_CLC_ACCEPT:
 	case SMC_CLC_CONFIRM:
-		if (clcm->typev1 != SMC_TYPE_R && clcm->typev1 != SMC_TYPE_D)
-			return false;
-		clc = (struct smc_clc_msg_accept_confirm *)clcm;
-		if ((clcm->typev1 == SMC_TYPE_R &&
-		     ntohs(clc->hdr.length) != SMCR_CLC_ACCEPT_CONFIRM_LEN) ||
-		    (clcm->typev1 == SMC_TYPE_D &&
-		     ntohs(clc->hdr.length) != SMCD_CLC_ACCEPT_CONFIRM_LEN))
+		clc_v2 = (struct smc_clc_msg_accept_confirm_v2 *)clcm;
+		if (!smc_clc_msg_acc_conf_valid(clc_v2))
 			return false;
 		trl = (struct smc_clc_msg_trail *)
-			((u8 *)clc + ntohs(clc->hdr.length) - sizeof(*trl));
+			((u8 *)clc_v2 + ntohs(clc_v2->hdr.length) -
+							sizeof(*trl));
 		break;
 	case SMC_CLC_DECLINE:
 		dclc = (struct smc_clc_msg_decline *)clcm;
@@ -599,17 +618,19 @@ int smc_clc_send_proposal(struct smc_sock *smc, struct smc_init_info *ini)
 
 /* build and send CLC CONFIRM / ACCEPT message */
 static int smc_clc_send_confirm_accept(struct smc_sock *smc,
-				       struct smc_clc_msg_accept_confirm *clc,
-				       int first_contact)
+				       struct smc_clc_msg_accept_confirm_v2 *clc_v2,
+				       int first_contact, u8 version)
 {
 	struct smc_connection *conn = &smc->conn;
+	struct smc_clc_msg_accept_confirm *clc;
 	struct smc_clc_msg_trail trl;
 	struct kvec vec[2];
 	struct msghdr msg;
 	int i;
 
 	/* send SMC Confirm CLC msg */
-	clc->hdr.version = SMC_V1;		/* SMC version */
+	clc = (struct smc_clc_msg_accept_confirm *)clc_v2;
+	clc->hdr.version = version;	/* SMC version */
 	if (first_contact)
 		clc->hdr.typev2 |= SMC_FIRST_CONTACT_MASK;
 	if (conn->lgr->is_smcd) {
@@ -617,12 +638,23 @@ static int smc_clc_send_confirm_accept(struct smc_sock *smc,
 		memcpy(clc->hdr.eyecatcher, SMCD_EYECATCHER,
 		       sizeof(SMCD_EYECATCHER));
 		clc->hdr.typev1 = SMC_TYPE_D;
-		clc->hdr.length = htons(SMCD_CLC_ACCEPT_CONFIRM_LEN);
 		clc->d0.gid = conn->lgr->smcd->local_gid;
 		clc->d0.token = conn->rmb_desc->token;
 		clc->d0.dmbe_size = conn->rmbe_size_short;
 		clc->d0.dmbe_idx = 0;
 		memcpy(&clc->d0.linkid, conn->lgr->id, SMC_LGR_ID_SIZE);
+		if (version == SMC_V1) {
+			clc->hdr.length = htons(SMCD_CLC_ACCEPT_CONFIRM_LEN);
+		} else {
+			u8 *eid = NULL;
+
+			clc_v2->chid = htons(smc_ism_get_chid(conn->lgr->smcd));
+			smc_ism_get_system_eid(conn->lgr->smcd, &eid);
+			if (eid)
+				memcpy(clc_v2->eid, eid, SMC_MAX_EID_LEN);
+			clc_v2->hdr.length =
+					htons(SMCD_CLC_ACCEPT_CONFIRM_LEN_V2);
+		}
 		memcpy(trl.eyecatcher, SMCD_EYECATCHER,
 		       sizeof(SMCD_EYECATCHER));
 	} else {
@@ -661,11 +693,14 @@ static int smc_clc_send_confirm_accept(struct smc_sock *smc,
 
 	memset(&msg, 0, sizeof(msg));
 	i = 0;
-	vec[i].iov_base = clc;
-	vec[i++].iov_len = (clc->hdr.typev1 == SMC_TYPE_D ?
-			    SMCD_CLC_ACCEPT_CONFIRM_LEN :
-			    SMCR_CLC_ACCEPT_CONFIRM_LEN) -
-			   sizeof(trl);
+	vec[i].iov_base = clc_v2;
+	if (version > SMC_V1)
+		vec[i++].iov_len = SMCD_CLC_ACCEPT_CONFIRM_LEN_V2 - sizeof(trl);
+	else
+		vec[i++].iov_len = (clc->hdr.typev1 == SMC_TYPE_D ?
+						SMCD_CLC_ACCEPT_CONFIRM_LEN :
+						SMCR_CLC_ACCEPT_CONFIRM_LEN) -
+				   sizeof(trl);
 	vec[i].iov_base = &trl;
 	vec[i++].iov_len = sizeof(trl);
 	return kernel_sendmsg(smc->clcsock, &msg, vec, 1,
@@ -673,17 +708,19 @@ static int smc_clc_send_confirm_accept(struct smc_sock *smc,
 }
 
 /* send CLC CONFIRM message across internal TCP socket */
-int smc_clc_send_confirm(struct smc_sock *smc)
+int smc_clc_send_confirm(struct smc_sock *smc, bool clnt_first_contact,
+			 u8 version)
 {
-	struct smc_clc_msg_accept_confirm cclc;
+	struct smc_clc_msg_accept_confirm_v2 cclc_v2;
 	int reason_code = 0;
 	int len;
 
 	/* send SMC Confirm CLC msg */
-	memset(&cclc, 0, sizeof(cclc));
-	cclc.hdr.type = SMC_CLC_CONFIRM;
-	len = smc_clc_send_confirm_accept(smc, &cclc, 0);
-	if (len < ntohs(cclc.hdr.length)) {
+	memset(&cclc_v2, 0, sizeof(cclc_v2));
+	cclc_v2.hdr.type = SMC_CLC_CONFIRM;
+	len = smc_clc_send_confirm_accept(smc, &cclc_v2, clnt_first_contact,
+					  version);
+	if (len < ntohs(cclc_v2.hdr.length)) {
 		if (len >= 0) {
 			reason_code = -ENETUNREACH;
 			smc->sk.sk_err = -reason_code;
@@ -696,15 +733,17 @@ int smc_clc_send_confirm(struct smc_sock *smc)
 }
 
 /* send CLC ACCEPT message across internal TCP socket */
-int smc_clc_send_accept(struct smc_sock *new_smc, bool srv_first_contact)
+int smc_clc_send_accept(struct smc_sock *new_smc, bool srv_first_contact,
+			u8 version)
 {
-	struct smc_clc_msg_accept_confirm aclc;
+	struct smc_clc_msg_accept_confirm_v2 aclc_v2;
 	int len;
 
-	memset(&aclc, 0, sizeof(aclc));
-	aclc.hdr.type = SMC_CLC_ACCEPT;
-	len = smc_clc_send_confirm_accept(new_smc, &aclc, srv_first_contact);
-	if (len < ntohs(aclc.hdr.length))
+	memset(&aclc_v2, 0, sizeof(aclc_v2));
+	aclc_v2.hdr.type = SMC_CLC_ACCEPT;
+	len = smc_clc_send_confirm_accept(new_smc, &aclc_v2, srv_first_contact,
+					  version);
+	if (len < ntohs(aclc_v2.hdr.length))
 		len = len >= 0 ? -EPROTO : -new_smc->clcsock->sk->sk_err;
 
 	return len > 0 ? 0 : len;
diff --git a/net/smc/smc_clc.h b/net/smc/smc_clc.h
index 5cefb0a09eaf..926b86cce68f 100644
--- a/net/smc/smc_clc.h
+++ b/net/smc/smc_clc.h
@@ -184,7 +184,7 @@ struct smcr_clc_msg_accept_confirm {	/* SMCR accept/confirm */
 	u8 psn[3];		/* packet sequence number */
 } __packed;
 
-struct smcd_clc_msg_accept_confirm {	/* SMCD accept/confirm */
+struct smcd_clc_msg_accept_confirm_common {	/* SMCD accept/confirm */
 	u64 gid;		/* Sender GID */
 	u64 token;		/* DMB token */
 	u8 dmbe_idx;		/* DMBE index */
@@ -197,17 +197,32 @@ struct smcd_clc_msg_accept_confirm {	/* SMCD accept/confirm */
 #endif
 	u16 reserved4;
 	__be32 linkid;		/* Link identifier */
-	u32 reserved5[3];
 } __packed;
 
 struct smc_clc_msg_accept_confirm {	/* clc accept / confirm message */
 	struct smc_clc_msg_hdr hdr;
 	union {
 		struct smcr_clc_msg_accept_confirm r0; /* SMC-R */
-		struct smcd_clc_msg_accept_confirm d0; /* SMC-D */
+		struct { /* SMC-D */
+			struct smcd_clc_msg_accept_confirm_common d0;
+			u32 reserved5[3];
+		};
 	};
 } __packed;			/* format defined in RFC7609 */
 
+struct smc_clc_msg_accept_confirm_v2 {	/* clc accept / confirm message */
+	struct smc_clc_msg_hdr hdr;
+	union {
+		struct smcr_clc_msg_accept_confirm r0; /* SMC-R */
+		struct { /* SMC-D */
+			struct smcd_clc_msg_accept_confirm_common d0;
+			__be16 chid;
+			u8 eid[SMC_MAX_EID_LEN];
+			u8 reserved5[8];
+		};
+	};
+};
+
 struct smc_clc_msg_decline {	/* clc decline message */
 	struct smc_clc_msg_hdr hdr;
 	u8 id_for_peer[SMC_SYSTEMID_LEN]; /* sender peer_id */
@@ -285,7 +300,9 @@ int smc_clc_wait_msg(struct smc_sock *smc, void *buf, int buflen,
 		     u8 expected_type, unsigned long timeout);
 int smc_clc_send_decline(struct smc_sock *smc, u32 peer_diag_info);
 int smc_clc_send_proposal(struct smc_sock *smc, struct smc_init_info *ini);
-int smc_clc_send_confirm(struct smc_sock *smc);
-int smc_clc_send_accept(struct smc_sock *smc, bool srv_first_contact);
+int smc_clc_send_confirm(struct smc_sock *smc, bool clnt_first_contact,
+			 u8 version);
+int smc_clc_send_accept(struct smc_sock *smc, bool srv_first_contact,
+			u8 version);
 
 #endif
-- 
2.17.1

