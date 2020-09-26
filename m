Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D68227988A
	for <lists+netdev@lfdr.de>; Sat, 26 Sep 2020 12:46:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729260AbgIZKp0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Sep 2020 06:45:26 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:34690 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727408AbgIZKo5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Sep 2020 06:44:57 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08QAWTsQ158867;
        Sat, 26 Sep 2020 06:44:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=LMvsCSRBqoiORIlphqgKqvMpWi8ZFDxZlzc2nckPix0=;
 b=iprzRavjRiimoo6FB+opuagoDsC6R6WPa1ziOd8rMrmE0wCRL796WPwtVdIr1ihPd36N
 MpCV3jjnxNT5/BfuwoIjF6W2K7akgaLmQliT+fkO1b8HKCTtbzWpcQ8dOgYie8L6Sqmd
 AG8lwXJbM0jRRISkqRLrIm71TvBGAIHHQQbpHz7E+Y7YLF7xDPFNghnLaHBKTD1Chc/O
 lK0mQZBUBWuZ83MVhunr27piKOB5pH+aVrQoLKf7j3Y28y3uuM8ZVoIGjlm/Ktf1ayTF
 GpM1rCmEkeJtwVa8RkOm1zekrwPUftf4aVA17JrtOMnHFaLxQpxoeICGhfWYAsp6JJaD og== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 33t3xqr6jg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 26 Sep 2020 06:44:52 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08QAhog6003122;
        Sat, 26 Sep 2020 10:44:51 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03ams.nl.ibm.com with ESMTP id 33sw98097c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 26 Sep 2020 10:44:51 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08QAim4N29622628
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 26 Sep 2020 10:44:48 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 17B50A405C;
        Sat, 26 Sep 2020 10:44:48 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CC399A4062;
        Sat, 26 Sep 2020 10:44:47 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Sat, 26 Sep 2020 10:44:47 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: [PATCH net-next 11/14] net/smc: determine accepted ISM devices
Date:   Sat, 26 Sep 2020 12:44:29 +0200
Message-Id: <20200926104432.74293-12-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200926104432.74293-1-kgraul@linux.ibm.com>
References: <20200926104432.74293-1-kgraul@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-26_06:2020-09-24,2020-09-26 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 lowpriorityscore=0 suspectscore=1 bulkscore=0 mlxlogscore=999
 clxscore=1015 impostorscore=0 priorityscore=1501 phishscore=0 mlxscore=0
 spamscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009260091
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ursula Braun <ubraun@linux.ibm.com>

SMCD Version 2 allows to propose up to 8 additional ISM devices
offered to the peer as candidates for SMCD communication.
This patch covers the server side, i.e. selection of an ISM device
matching one of the proposed ISM devices, that will be used for
CLC accept

Signed-off-by: Ursula Braun <ubraun@linux.ibm.com>
Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
---
 net/smc/af_smc.c   | 202 +++++++++++++++++++++++++++++++++++++++------
 net/smc/smc_clc.h  |  16 ++++
 net/smc/smc_core.c |  23 +++---
 net/smc/smc_core.h |   1 +
 4 files changed, 208 insertions(+), 34 deletions(-)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index 10374673f75f..3963a4d2b79f 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -1236,6 +1236,47 @@ static void smc_listen_decline(struct smc_sock *new_smc, int reason_code,
 	smc_listen_out_connected(new_smc);
 }
 
+/* listen worker: version checking */
+static int smc_listen_v2_check(struct smc_sock *new_smc,
+			       struct smc_clc_msg_proposal *pclc,
+			       struct smc_init_info *ini)
+{
+	struct smc_clc_smcd_v2_extension *pclc_smcd_v2_ext;
+	struct smc_clc_v2_extension *pclc_v2_ext;
+
+	ini->smc_type_v1 = pclc->hdr.typev1;
+	ini->smc_type_v2 = pclc->hdr.typev2;
+	ini->smcd_version = ini->smc_type_v1 != SMC_TYPE_N ? SMC_V1 : 0;
+	if (pclc->hdr.version > SMC_V1)
+		ini->smcd_version |=
+				ini->smc_type_v2 != SMC_TYPE_N ? SMC_V2 : 0;
+	if (!smc_ism_v2_capable) {
+		ini->smcd_version &= ~SMC_V2;
+		goto out;
+	}
+	pclc_v2_ext = smc_get_clc_v2_ext(pclc);
+	if (!pclc_v2_ext) {
+		ini->smcd_version &= ~SMC_V2;
+		goto out;
+	}
+	pclc_smcd_v2_ext = smc_get_clc_smcd_v2_ext(pclc_v2_ext);
+	if (!pclc_smcd_v2_ext)
+		ini->smcd_version &= ~SMC_V2;
+
+out:
+	if (!ini->smcd_version) {
+		if (pclc->hdr.typev1 == SMC_TYPE_B ||
+		    pclc->hdr.typev2 == SMC_TYPE_B)
+			return SMC_CLC_DECL_NOSMCDEV;
+		if (pclc->hdr.typev1 == SMC_TYPE_D ||
+		    pclc->hdr.typev2 == SMC_TYPE_D)
+			return SMC_CLC_DECL_NOSMCDDEV;
+		return SMC_CLC_DECL_NOSMCRDEV;
+	}
+
+	return 0;
+}
+
 /* listen worker: check prefixes */
 static int smc_listen_prfx_check(struct smc_sock *new_smc,
 				 struct smc_clc_msg_proposal *pclc)
@@ -1243,6 +1284,8 @@ static int smc_listen_prfx_check(struct smc_sock *new_smc,
 	struct smc_clc_msg_proposal_prefix *pclc_prfx;
 	struct socket *newclcsock = new_smc->clcsock;
 
+	if (pclc->hdr.typev1 == SMC_TYPE_N)
+		return 0;
 	pclc_prfx = smc_clc_proposal_get_prefix(pclc);
 	if (smc_clc_prfx_match(newclcsock, pclc_prfx))
 		return SMC_CLC_DECL_DIFFPREFIX;
@@ -1292,20 +1335,119 @@ static int smc_listen_ism_init(struct smc_sock *new_smc,
 	return 0;
 }
 
-static void smc_find_ism_device_serv(struct smc_sock *new_smc,
-				     struct smc_clc_msg_proposal *pclc,
-				     struct smc_init_info *ini)
+static bool smc_is_already_selected(struct smcd_dev *smcd,
+				    struct smc_init_info *ini,
+				    int matches)
+{
+	int i;
+
+	for (i = 0; i < matches; i++)
+		if (smcd == ini->ism_dev[i])
+			return true;
+
+	return false;
+}
+
+/* check for ISM devices matching proposed ISM devices */
+static void smc_check_ism_v2_match(struct smc_init_info *ini,
+				   u16 proposed_chid, u64 proposed_gid,
+				   unsigned int *matches)
+{
+	struct smcd_dev *smcd;
+
+	list_for_each_entry(smcd, &smcd_dev_list.list, list) {
+		if (smcd->going_away)
+			continue;
+		if (smc_is_already_selected(smcd, ini, *matches))
+			continue;
+		if (smc_ism_get_chid(smcd) == proposed_chid &&
+		    !smc_ism_cantalk(proposed_gid, ISM_RESERVED_VLANID, smcd)) {
+			ini->ism_peer_gid[*matches] = proposed_gid;
+			ini->ism_dev[*matches] = smcd;
+			(*matches)++;
+			break;
+		}
+	}
+}
+
+static void smc_find_ism_v2_device_serv(struct smc_sock *new_smc,
+					struct smc_clc_msg_proposal *pclc,
+					struct smc_init_info *ini)
+{
+	struct smc_clc_smcd_v2_extension *smcd_v2_ext;
+	struct smc_clc_v2_extension *smc_v2_ext;
+	struct smc_clc_msg_smcd *pclc_smcd;
+	unsigned int matches = 0;
+	u8 *eid = NULL;
+	int i;
+
+	if (!(ini->smcd_version & SMC_V2) || !smcd_indicated(ini->smc_type_v2))
+		return;
+
+	pclc_smcd = smc_get_clc_msg_smcd(pclc);
+	smc_v2_ext = smc_get_clc_v2_ext(pclc);
+	smcd_v2_ext = smc_get_clc_smcd_v2_ext(smc_v2_ext);
+	if (!smcd_v2_ext ||
+	    !smc_v2_ext->hdr.flag.seid) /* no system EID support for SMCD */
+		goto not_found;
+
+	mutex_lock(&smcd_dev_list.mutex);
+	if (pclc_smcd->ism.chid)
+		/* check for ISM device matching proposed native ISM device */
+		smc_check_ism_v2_match(ini, ntohs(pclc_smcd->ism.chid),
+				       ntohll(pclc_smcd->ism.gid), &matches);
+	for (i = 1; i <= smc_v2_ext->hdr.ism_gid_cnt; i++) {
+		/* check for ISM devices matching proposed non-native ISM
+		 * devices
+		 */
+		smc_check_ism_v2_match(ini,
+				       ntohs(smcd_v2_ext->gidchid[i - 1].chid),
+				       ntohll(smcd_v2_ext->gidchid[i - 1].gid),
+				       &matches);
+	}
+	mutex_unlock(&smcd_dev_list.mutex);
+
+	if (ini->ism_dev[0]) {
+		smc_ism_get_system_eid(ini->ism_dev[0], &eid);
+		if (memcmp(eid, smcd_v2_ext->system_eid, SMC_MAX_EID_LEN))
+			goto not_found;
+	} else {
+		goto not_found;
+	}
+
+	/* separate - outside the smcd_dev_list.lock */
+	for (i = 0; i < matches; i++) {
+		ini->smcd_version = SMC_V2;
+		ini->is_smcd = true;
+		ini->ism_selected = i;
+		if (smc_listen_ism_init(new_smc, ini))
+			/* try next active ISM device */
+			continue;
+		return; /* matching and usable V2 ISM device found */
+	}
+
+not_found:
+	ini->smcd_version &= ~SMC_V2;
+	ini->ism_dev[0] = NULL;
+	ini->is_smcd = false;
+}
+
+static void smc_find_ism_v1_device_serv(struct smc_sock *new_smc,
+					struct smc_clc_msg_proposal *pclc,
+					struct smc_init_info *ini)
 {
 	struct smc_clc_msg_smcd *pclc_smcd = smc_get_clc_msg_smcd(pclc);
 
-	if (!smcd_indicated(pclc->hdr.typev1))
+	/* check if ISM V1 is available */
+	if (!(ini->smcd_version & SMC_V1) || !smcd_indicated(ini->smc_type_v1))
 		goto not_found;
 	ini->is_smcd = true; /* prepare ISM check */
 	ini->ism_peer_gid[0] = ntohll(pclc_smcd->ism.gid);
 	if (smc_find_ism_device(new_smc, ini))
 		goto not_found;
+	ini->ism_selected = 0;
 	if (!smc_listen_ism_init(new_smc, ini))
-		return;		/* ISM device found */
+		return;		/* V1 ISM device found */
 
 not_found:
 	ini->ism_dev[0] = NULL;
@@ -1326,13 +1468,13 @@ static int smc_listen_rdma_reg(struct smc_sock *new_smc, bool local_first)
 	return 0;
 }
 
-static int smc_find_rdma_device_serv(struct smc_sock *new_smc,
-				     struct smc_clc_msg_proposal *pclc,
-				     struct smc_init_info *ini)
+static int smc_find_rdma_v1_device_serv(struct smc_sock *new_smc,
+					struct smc_clc_msg_proposal *pclc,
+					struct smc_init_info *ini)
 {
 	int rc;
 
-	if (!smcr_indicated(pclc->hdr.typev1))
+	if (!smcr_indicated(ini->smc_type_v1))
 		return SMC_CLC_DECL_NOSMCDEV;
 
 	/* prepare RDMA check */
@@ -1340,7 +1482,7 @@ static int smc_find_rdma_device_serv(struct smc_sock *new_smc,
 	rc = smc_find_rdma_device(new_smc, ini);
 	if (rc) {
 		/* no RDMA device found */
-		if (pclc->hdr.typev1 == SMC_TYPE_B)
+		if (ini->smc_type_v1 == SMC_TYPE_B)
 			/* neither ISM nor RDMA device found */
 			rc = SMC_CLC_DECL_NOSMCDEV;
 		return rc;
@@ -1356,15 +1498,35 @@ static int smc_listen_find_device(struct smc_sock *new_smc,
 				  struct smc_clc_msg_proposal *pclc,
 				  struct smc_init_info *ini)
 {
-	/* check if ISM is available */
-	smc_find_ism_device_serv(new_smc, pclc, ini);
-	if (ini->is_smcd)
+	int rc;
+
+	/* check for ISM device matching V2 proposed device */
+	smc_find_ism_v2_device_serv(new_smc, pclc, ini);
+	if (ini->ism_dev[0])
 		return 0;
+
+	if (!(ini->smcd_version & SMC_V1))
+		return SMC_CLC_DECL_NOSMCDEV;
+
+	/* check for matching IP prefix and subnet length */
+	rc = smc_listen_prfx_check(new_smc, pclc);
+	if (rc)
+		return rc;
+
+	/* get vlan id from IP device */
+	if (smc_vlan_by_tcpsk(new_smc->clcsock, ini))
+		return SMC_CLC_DECL_GETVLANERR;
+
+	/* check for ISM device matching V1 proposed device */
+	smc_find_ism_v1_device_serv(new_smc, pclc, ini);
+	if (ini->ism_dev[0])
+		return 0;
+
 	if (pclc->hdr.typev1 == SMC_TYPE_D)
 		return SMC_CLC_DECL_NOSMCDDEV; /* skip RDMA and decline */
 
 	/* check if RDMA is available */
-	return smc_find_rdma_device_serv(new_smc, pclc, ini);
+	return smc_find_rdma_v1_device_serv(new_smc, pclc, ini);
 }
 
 /* listen worker: finish RDMA setup */
@@ -1440,22 +1602,16 @@ static void smc_listen_work(struct work_struct *work)
 		goto out_decl;
 	}
 
-	/* check for matching IP prefix and subnet length */
-	rc = smc_listen_prfx_check(new_smc, pclc);
-	if (rc)
-		goto out_decl;
-
 	ini = kzalloc(sizeof(*ini), GFP_KERNEL);
 	if (!ini) {
 		rc = SMC_CLC_DECL_MEM;
 		goto out_decl;
 	}
 
-	/* get vlan id from IP device */
-	if (smc_vlan_by_tcpsk(new_smc->clcsock, ini)) {
-		rc = SMC_CLC_DECL_GETVLANERR;
+	/* initial version checking */
+	rc = smc_listen_v2_check(new_smc, pclc, ini);
+	if (rc)
 		goto out_decl;
-	}
 
 	mutex_lock(&smc_server_lgr_pending);
 	smc_close_init(new_smc);
diff --git a/net/smc/smc_clc.h b/net/smc/smc_clc.h
index 0157cffce62c..5cefb0a09eaf 100644
--- a/net/smc/smc_clc.h
+++ b/net/smc/smc_clc.h
@@ -260,6 +260,22 @@ smc_get_clc_v2_ext(struct smc_clc_msg_proposal *prop)
 	       ntohs(prop_smcd->v2_ext_offset));
 }
 
+static inline struct smc_clc_smcd_v2_extension *
+smc_get_clc_smcd_v2_ext(struct smc_clc_v2_extension *prop_v2ext)
+{
+	if (!prop_v2ext)
+		return NULL;
+	if (!ntohs(prop_v2ext->hdr.smcd_v2_ext_offset))
+		return NULL;
+
+	return (struct smc_clc_smcd_v2_extension *)
+		((u8 *)prop_v2ext +
+		 offsetof(struct smc_clc_v2_extension, hdr) +
+		 offsetof(struct smc_clnt_opts_area_hdr, smcd_v2_ext_offset) +
+		 sizeof(prop_v2ext->hdr.smcd_v2_ext_offset) +
+		 ntohs(prop_v2ext->hdr.smcd_v2_ext_offset));
+}
+
 struct smcd_dev;
 struct smc_init_info;
 
diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index 26db5ef01842..c52acb6fe6c9 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -375,7 +375,8 @@ static int smc_lgr_create(struct smc_sock *smc, struct smc_init_info *ini)
 	int i;
 
 	if (ini->is_smcd && ini->vlan_id) {
-		if (smc_ism_get_vlan(ini->ism_dev[0], ini->vlan_id)) {
+		if (smc_ism_get_vlan(ini->ism_dev[ini->ism_selected],
+				     ini->vlan_id)) {
 			rc = SMC_CLC_DECL_ISMVLANERR;
 			goto out;
 		}
@@ -412,13 +413,13 @@ static int smc_lgr_create(struct smc_sock *smc, struct smc_init_info *ini)
 	lgr->conns_all = RB_ROOT;
 	if (ini->is_smcd) {
 		/* SMC-D specific settings */
-		get_device(&ini->ism_dev[0]->dev);
-		lgr->peer_gid = ini->ism_peer_gid[0];
-		lgr->smcd = ini->ism_dev[0];
-		lgr_list = &ini->ism_dev[0]->lgr_list;
+		get_device(&ini->ism_dev[ini->ism_selected]->dev);
+		lgr->peer_gid = ini->ism_peer_gid[ini->ism_selected];
+		lgr->smcd = ini->ism_dev[ini->ism_selected];
+		lgr_list = &ini->ism_dev[ini->ism_selected]->lgr_list;
 		lgr_lock = &lgr->smcd->lgr_lock;
 		lgr->peer_shutdown = 0;
-		atomic_inc(&ini->ism_dev[0]->lgr_cnt);
+		atomic_inc(&ini->ism_dev[ini->ism_selected]->lgr_cnt);
 	} else {
 		/* SMC-R specific settings */
 		lgr->role = smc->listen_smc ? SMC_SERV : SMC_CLNT;
@@ -449,7 +450,7 @@ static int smc_lgr_create(struct smc_sock *smc, struct smc_init_info *ini)
 	kfree(lgr);
 ism_put_vlan:
 	if (ini->is_smcd && ini->vlan_id)
-		smc_ism_put_vlan(ini->ism_dev[0], ini->vlan_id);
+		smc_ism_put_vlan(ini->ism_dev[ini->ism_selected], ini->vlan_id);
 out:
 	if (rc < 0) {
 		if (rc == -ENOMEM)
@@ -1288,9 +1289,9 @@ int smc_conn_create(struct smc_sock *smc, struct smc_init_info *ini)
 	spinlock_t *lgr_lock;
 	int rc = 0;
 
-	lgr_list = ini->is_smcd ? &ini->ism_dev[0]->lgr_list :
+	lgr_list = ini->is_smcd ? &ini->ism_dev[ini->ism_selected]->lgr_list :
 				  &smc_lgr_list.list;
-	lgr_lock = ini->is_smcd ? &ini->ism_dev[0]->lgr_lock :
+	lgr_lock = ini->is_smcd ? &ini->ism_dev[ini->ism_selected]->lgr_lock :
 				  &smc_lgr_list.lock;
 	ini->first_contact_local = 1;
 	role = smc->listen_smc ? SMC_SERV : SMC_CLNT;
@@ -1303,8 +1304,8 @@ int smc_conn_create(struct smc_sock *smc, struct smc_init_info *ini)
 	list_for_each_entry(lgr, lgr_list, list) {
 		write_lock_bh(&lgr->conns_lock);
 		if ((ini->is_smcd ?
-		     smcd_lgr_match(lgr, ini->ism_dev[0],
-				    ini->ism_peer_gid[0]) :
+		     smcd_lgr_match(lgr, ini->ism_dev[ini->ism_selected],
+				    ini->ism_peer_gid[ini->ism_selected]) :
 		     smcr_lgr_match(lgr, ini->ib_lcl, role, ini->ib_clcqpn)) &&
 		    !lgr->sync_err &&
 		    lgr->vlan_id == ini->vlan_id &&
diff --git a/net/smc/smc_core.h b/net/smc/smc_core.h
index 39a5e2156694..35e38dd26cbf 100644
--- a/net/smc/smc_core.h
+++ b/net/smc/smc_core.h
@@ -307,6 +307,7 @@ struct smc_init_info {
 	struct smcd_dev		*ism_dev[SMC_MAX_ISM_DEVS + 1];
 	u16			ism_chid[SMC_MAX_ISM_DEVS + 1];
 	u8			ism_offered_cnt; /* # of ISM devices offered */
+	u8			ism_selected;    /* index of selected ISM dev*/
 	u8			smcd_version;
 };
 
-- 
2.17.1

