Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1EA1279894
	for <lists+netdev@lfdr.de>; Sat, 26 Sep 2020 12:46:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729366AbgIZKpw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Sep 2020 06:45:52 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:7540 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727321AbgIZKoz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Sep 2020 06:44:55 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08QAgtAu052713;
        Sat, 26 Sep 2020 06:44:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=zc+JvPl6f8MbGrfYoeDoRgEHmwgZqnLImI5bt9anyh8=;
 b=KZC60/h4sdJm+Q4bx/YGBfqOFajppicMX4JCFRl2jowHHk3slssdXcYGB4oxuMVJdbg8
 Q7eCbPA8Xuwj+SNNydMECvQFbcp50dMQ5R3p7021QRU1d0NhWoQqKjVZZr/7vEEayNJ/
 icbxW+rZX+Ftm2qfmHXv2aCCSWippc2B+K4sOs7TRfKRf/93nGpglDm+ako9CGqOSZKD
 7vLBEwSwuLnkw4+tFOEcm/zh4SZmrOXzptP0s6zwbzXfr/BtE+d3J4eTOw/Y4+So3PAU
 PVxH0tIK8aFCwCho6IX5Lij4WiY2TPw2XVVAxvY+UlNewYGAx7aNiWMFP/gXR7f5mUR9 CA== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com with ESMTP id 33t44pr0j8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 26 Sep 2020 06:44:52 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08QAgjMn015718;
        Sat, 26 Sep 2020 10:44:50 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma06ams.nl.ibm.com with ESMTP id 33svwgra04-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 26 Sep 2020 10:44:50 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08QAilqK25821678
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 26 Sep 2020 10:44:47 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7577CA405B;
        Sat, 26 Sep 2020 10:44:47 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 368FDA405C;
        Sat, 26 Sep 2020 10:44:47 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Sat, 26 Sep 2020 10:44:47 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: [PATCH net-next 09/14] net/smc: determine proposed ISM devices
Date:   Sat, 26 Sep 2020 12:44:27 +0200
Message-Id: <20200926104432.74293-10-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200926104432.74293-1-kgraul@linux.ibm.com>
References: <20200926104432.74293-1-kgraul@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-26_06:2020-09-24,2020-09-26 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501 mlxscore=0
 phishscore=0 spamscore=0 clxscore=1015 adultscore=0 suspectscore=1
 impostorscore=0 malwarescore=0 lowpriorityscore=0 bulkscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009260091
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ursula Braun <ubraun@linux.ibm.com>

SMCD Version 2 allows to propose up to 8 additional ISM devices
offered to the peer as candidates for SMCD communication.
This patch covers determination of the ISM devices to be proposed.
ISM devices without PNETID are preferred, since ISM devices with
PNETID are a V1 leftover and will disappear over the time.

Signed-off-by: Ursula Braun <ubraun@linux.ibm.com>
Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
---
 net/smc/af_smc.c   | 165 ++++++++++++++++++++++++++++++++-------------
 net/smc/smc.h      |   1 +
 net/smc/smc_clc.c  |  11 ++-
 net/smc/smc_clc.h  |   3 +-
 net/smc/smc_core.h |   4 ++
 net/smc/smc_ism.c  |   6 +-
 net/smc/smc_pnet.c |   2 +-
 net/smc/smc_pnet.h |   1 +
 8 files changed, 135 insertions(+), 58 deletions(-)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index f02ed74a28e6..1d01a01c7fd5 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -571,6 +571,41 @@ static int smc_find_ism_device(struct smc_sock *smc, struct smc_init_info *ini)
 	return 0;
 }
 
+/* determine possible V2 ISM devices (either without PNETID or with PNETID plus
+ * PNETID matching net_device)
+ */
+static int smc_find_ism_v2_device_clnt(struct smc_sock *smc,
+				       struct smc_init_info *ini)
+{
+	int rc = SMC_CLC_DECL_NOSMCDDEV;
+	struct smcd_dev *smcd;
+	int i = 1;
+
+	if (smcd_indicated(ini->smc_type_v1))
+		rc = 0;		/* already initialized for V1 */
+	mutex_lock(&smcd_dev_list.mutex);
+	list_for_each_entry(smcd, &smcd_dev_list.list, list) {
+		if (smcd->going_away || smcd == ini->ism_dev[0])
+			continue;
+		if (!smc_pnet_is_pnetid_set(smcd->pnetid) ||
+		    smc_pnet_is_ndev_pnetid(sock_net(&smc->sk), smcd->pnetid)) {
+			ini->ism_dev[i] = smcd;
+			ini->ism_chid[i] = smc_ism_get_chid(ini->ism_dev[i]);
+			ini->is_smcd = true;
+			rc = 0;
+			i++;
+			if (i > SMC_MAX_ISM_DEVS)
+				break;
+		}
+	}
+	mutex_unlock(&smcd_dev_list.mutex);
+	ini->ism_offered_cnt = i - 1;
+	if (!ini->ism_dev[0] && !ini->ism_dev[1])
+		ini->smcd_version = 0;
+
+	return rc;
+}
+
 /* Check for VLAN ID and register it on ISM device just for CLC handshake */
 static int smc_connect_ism_vlan_setup(struct smc_sock *smc,
 				      struct smc_init_info *ini)
@@ -580,13 +615,45 @@ static int smc_connect_ism_vlan_setup(struct smc_sock *smc,
 	return 0;
 }
 
+static int smc_find_proposal_devices(struct smc_sock *smc,
+				     struct smc_init_info *ini)
+{
+	int rc = 0;
+
+	/* check if there is an ism device available */
+	if (ini->smcd_version & SMC_V1) {
+		if (smc_find_ism_device(smc, ini) ||
+		    smc_connect_ism_vlan_setup(smc, ini)) {
+			if (ini->smc_type_v1 == SMC_TYPE_B)
+				ini->smc_type_v1 = SMC_TYPE_R;
+			else
+				ini->smc_type_v1 = SMC_TYPE_N;
+		} /* else ISM V1 is supported for this connection */
+		if (smc_find_rdma_device(smc, ini)) {
+			if (ini->smc_type_v1 == SMC_TYPE_B)
+				ini->smc_type_v1 = SMC_TYPE_D;
+			else
+				ini->smc_type_v1 = SMC_TYPE_N;
+		} /* else RDMA is supported for this connection */
+	}
+	if (smc_ism_v2_capable && smc_find_ism_v2_device_clnt(smc, ini))
+		ini->smc_type_v2 = SMC_TYPE_N;
+
+	/* if neither ISM nor RDMA are supported, fallback */
+	if (!smcr_indicated(ini->smc_type_v1) &&
+	    ini->smc_type_v1 == SMC_TYPE_N && ini->smc_type_v2 == SMC_TYPE_N)
+		rc = SMC_CLC_DECL_NOSMCDEV;
+
+	return rc;
+}
+
 /* cleanup temporary VLAN ID registration used for CLC handshake. If ISM is
  * used, the VLAN ID will be registered again during the connection setup.
  */
-static int smc_connect_ism_vlan_cleanup(struct smc_sock *smc, bool is_smcd,
+static int smc_connect_ism_vlan_cleanup(struct smc_sock *smc,
 					struct smc_init_info *ini)
 {
-	if (!is_smcd)
+	if (!smcd_indicated(ini->smc_type_v1))
 		return 0;
 	if (ini->vlan_id && smc_ism_put_vlan(ini->ism_dev[0], ini->vlan_id))
 		return SMC_CLC_DECL_CNFERR;
@@ -594,14 +661,14 @@ static int smc_connect_ism_vlan_cleanup(struct smc_sock *smc, bool is_smcd,
 }
 
 /* CLC handshake during connect */
-static int smc_connect_clc(struct smc_sock *smc, int smc_type,
+static int smc_connect_clc(struct smc_sock *smc,
 			   struct smc_clc_msg_accept_confirm *aclc,
 			   struct smc_init_info *ini)
 {
 	int rc = 0;
 
 	/* do inband token exchange */
-	rc = smc_clc_send_proposal(smc, smc_type, ini);
+	rc = smc_clc_send_proposal(smc, ini);
 	if (rc)
 		return rc;
 	/* receive SMC Accept CLC message */
@@ -751,13 +818,24 @@ static int smc_connect_ism(struct smc_sock *smc,
 	return 0;
 }
 
+/* check if received accept type and version matches a proposed one */
+static int smc_connect_check_aclc(struct smc_init_info *ini,
+				  struct smc_clc_msg_accept_confirm *aclc)
+{
+	if ((aclc->hdr.typev1 == SMC_TYPE_R &&
+	     !smcr_indicated(ini->smc_type_v1)) ||
+	    (aclc->hdr.typev1 == SMC_TYPE_D &&
+	     !smcd_indicated(ini->smc_type_v1)))
+		return SMC_CLC_DECL_MODEUNSUPP;
+
+	return 0;
+}
+
 /* perform steps before actually connecting */
 static int __smc_connect(struct smc_sock *smc)
 {
-	bool ism_supported = false, rdma_supported = false;
 	struct smc_clc_msg_accept_confirm aclc;
 	struct smc_init_info *ini = NULL;
-	int smc_type;
 	int rc = 0;
 
 	if (smc->use_fallback)
@@ -775,61 +853,52 @@ static int __smc_connect(struct smc_sock *smc)
 	if (!ini)
 		return smc_connect_decline_fallback(smc, SMC_CLC_DECL_MEM);
 
+	ini->smcd_version = SMC_V1;
+	ini->smcd_version |= smc_ism_v2_capable ? SMC_V2 : 0;
+	ini->smc_type_v1 = SMC_TYPE_B;
+	ini->smc_type_v2 = smc_ism_v2_capable ? SMC_TYPE_D : SMC_TYPE_N;
+
 	/* get vlan id from IP device */
 	if (smc_vlan_by_tcpsk(smc->clcsock, ini)) {
-		kfree(ini);
-		return smc_connect_decline_fallback(smc,
-						    SMC_CLC_DECL_GETVLANERR);
-	}
-
-	/* check if there is an ism device available */
-	if (!smc_find_ism_device(smc, ini) &&
-	    !smc_connect_ism_vlan_setup(smc, ini)) {
-		/* ISM is supported for this connection */
-		ism_supported = true;
-		smc_type = SMC_TYPE_D;
-	}
-
-	/* check if there is a rdma device available */
-	if (!smc_find_rdma_device(smc, ini)) {
-		/* RDMA is supported for this connection */
-		rdma_supported = true;
-		if (ism_supported)
-			smc_type = SMC_TYPE_B; /* both */
-		else
-			smc_type = SMC_TYPE_R; /* only RDMA */
+		ini->smcd_version &= ~SMC_V1;
+		ini->smc_type_v1 = SMC_TYPE_N;
+		if (!ini->smcd_version) {
+			rc = SMC_CLC_DECL_GETVLANERR;
+			goto fallback;
+		}
 	}
 
-	/* if neither ISM nor RDMA are supported, fallback */
-	if (!rdma_supported && !ism_supported) {
-		kfree(ini);
-		return smc_connect_decline_fallback(smc, SMC_CLC_DECL_NOSMCDEV);
-	}
+	rc = smc_find_proposal_devices(smc, ini);
+	if (rc)
+		goto fallback;
 
 	/* perform CLC handshake */
-	rc = smc_connect_clc(smc, smc_type, &aclc, ini);
-	if (rc) {
-		smc_connect_ism_vlan_cleanup(smc, ism_supported, ini);
-		kfree(ini);
-		return smc_connect_decline_fallback(smc, rc);
-	}
+	rc = smc_connect_clc(smc, &aclc, ini);
+	if (rc)
+		goto vlan_cleanup;
+
+	/* check if smc modes and versions of CLC proposal and accept match */
+	rc = smc_connect_check_aclc(ini, &aclc);
+	if (rc)
+		goto vlan_cleanup;
 
 	/* depending on previous steps, connect using rdma or ism */
-	if (rdma_supported && aclc.hdr.typev1 == SMC_TYPE_R)
+	if (aclc.hdr.typev1 == SMC_TYPE_R)
 		rc = smc_connect_rdma(smc, &aclc, ini);
-	else if (ism_supported && aclc.hdr.typev1 == SMC_TYPE_D)
+	else if (aclc.hdr.typev1 == SMC_TYPE_D)
 		rc = smc_connect_ism(smc, &aclc, ini);
-	else
-		rc = SMC_CLC_DECL_MODEUNSUPP;
-	if (rc) {
-		smc_connect_ism_vlan_cleanup(smc, ism_supported, ini);
-		kfree(ini);
-		return smc_connect_decline_fallback(smc, rc);
-	}
+	if (rc)
+		goto vlan_cleanup;
 
-	smc_connect_ism_vlan_cleanup(smc, ism_supported, ini);
+	smc_connect_ism_vlan_cleanup(smc, ini);
 	kfree(ini);
 	return 0;
+
+vlan_cleanup:
+	smc_connect_ism_vlan_cleanup(smc, ini);
+fallback:
+	kfree(ini);
+	return smc_connect_decline_fallback(smc, rc);
 }
 
 static void smc_connect_work(struct work_struct *work)
diff --git a/net/smc/smc.h b/net/smc/smc.h
index 6c89cb80860b..0b9c904e2282 100644
--- a/net/smc/smc.h
+++ b/net/smc/smc.h
@@ -19,6 +19,7 @@
 #include "smc_ib.h"
 
 #define SMC_V1		1		/* SMC version V1 */
+#define SMC_V2		2		/* SMC version V2 */
 
 #define SMCPROTO_SMC		0	/* SMC protocol, IPv4 */
 #define SMCPROTO_SMC6		1	/* SMC protocol, IPv6 */
diff --git a/net/smc/smc_clc.c b/net/smc/smc_clc.c
index fca718836ec1..26f1cdd35cb1 100644
--- a/net/smc/smc_clc.c
+++ b/net/smc/smc_clc.c
@@ -410,8 +410,7 @@ int smc_clc_send_decline(struct smc_sock *smc, u32 peer_diag_info)
 }
 
 /* send CLC PROPOSAL message across internal TCP socket */
-int smc_clc_send_proposal(struct smc_sock *smc, int smc_type,
-			  struct smc_init_info *ini)
+int smc_clc_send_proposal(struct smc_sock *smc, struct smc_init_info *ini)
 {
 	struct smc_clc_msg_proposal_prefix *pclc_prfx;
 	struct smc_clc_msg_proposal *pclc_base;
@@ -449,8 +448,8 @@ int smc_clc_send_proposal(struct smc_sock *smc, int smc_type,
 	       sizeof(SMC_EYECATCHER));
 	pclc_base->hdr.type = SMC_CLC_PROPOSAL;
 	pclc_base->hdr.version = SMC_V1;		/* SMC version */
-	pclc_base->hdr.typev1 = smc_type;
-	if (smcr_indicated(smc_type)) {
+	pclc_base->hdr.typev1 = ini->smc_type_v1;
+	if (smcr_indicated(ini->smc_type_v1)) {
 		/* add SMC-R specifics */
 		memcpy(pclc_base->lcl.id_for_peer, local_systemid,
 		       sizeof(local_systemid));
@@ -459,7 +458,7 @@ int smc_clc_send_proposal(struct smc_sock *smc, int smc_type,
 		       ETH_ALEN);
 		pclc_base->iparea_offset = htons(0);
 	}
-	if (smcd_indicated(smc_type)) {
+	if (smcd_indicated(ini->smc_type_v1)) {
 		/* add SMC-D specifics */
 		plen += sizeof(*pclc_smcd);
 		pclc_base->iparea_offset = htons(sizeof(*pclc_smcd));
@@ -472,7 +471,7 @@ int smc_clc_send_proposal(struct smc_sock *smc, int smc_type,
 	i = 0;
 	vec[i].iov_base = pclc_base;
 	vec[i++].iov_len = sizeof(*pclc_base);
-	if (smcd_indicated(smc_type)) {
+	if (smcd_indicated(ini->smc_type_v1)) {
 		vec[i].iov_base = pclc_smcd;
 		vec[i++].iov_len = sizeof(*pclc_smcd);
 	}
diff --git a/net/smc/smc_clc.h b/net/smc/smc_clc.h
index c4644d14beae..a3aa90bf4ad7 100644
--- a/net/smc/smc_clc.h
+++ b/net/smc/smc_clc.h
@@ -205,8 +205,7 @@ int smc_clc_prfx_match(struct socket *clcsock,
 int smc_clc_wait_msg(struct smc_sock *smc, void *buf, int buflen,
 		     u8 expected_type, unsigned long timeout);
 int smc_clc_send_decline(struct smc_sock *smc, u32 peer_diag_info);
-int smc_clc_send_proposal(struct smc_sock *smc, int smc_type,
-			  struct smc_init_info *ini);
+int smc_clc_send_proposal(struct smc_sock *smc, struct smc_init_info *ini);
 int smc_clc_send_confirm(struct smc_sock *smc);
 int smc_clc_send_accept(struct smc_sock *smc, bool srv_first_contact);
 
diff --git a/net/smc/smc_core.h b/net/smc/smc_core.h
index d33bcbc3238f..39a5e2156694 100644
--- a/net/smc/smc_core.h
+++ b/net/smc/smc_core.h
@@ -291,6 +291,8 @@ struct smc_clc_msg_local;
 
 struct smc_init_info {
 	u8			is_smcd;
+	u8			smc_type_v1;
+	u8			smc_type_v2;
 	u8			first_contact_peer;
 	u8			first_contact_local;
 	unsigned short		vlan_id;
@@ -304,6 +306,8 @@ struct smc_init_info {
 	u64			ism_peer_gid[SMC_MAX_ISM_DEVS + 1];
 	struct smcd_dev		*ism_dev[SMC_MAX_ISM_DEVS + 1];
 	u16			ism_chid[SMC_MAX_ISM_DEVS + 1];
+	u8			ism_offered_cnt; /* # of ISM devices offered */
+	u8			smcd_version;
 };
 
 /* Find the connection associated with the given alert token in the link group.
diff --git a/net/smc/smc_ism.c b/net/smc/smc_ism.c
index c5a5b70251b6..e9a6487a42cb 100644
--- a/net/smc/smc_ism.c
+++ b/net/smc/smc_ism.c
@@ -338,7 +338,11 @@ int smcd_register_dev(struct smcd_dev *smcd)
 		if ((*system_eid) + 24 != '0' || (*system_eid) + 28 != '0')
 			smc_ism_v2_capable = true;
 	}
-	list_add_tail(&smcd->list, &smcd_dev_list.list);
+	/* sort list: devices without pnetid before devices with pnetid */
+	if (smcd->pnetid[0])
+		list_add_tail(&smcd->list, &smcd_dev_list.list);
+	else
+		list_add(&smcd->list, &smcd_dev_list.list);
 	mutex_unlock(&smcd_dev_list.mutex);
 
 	pr_warn_ratelimited("smc: adding smcd device %s with pnetid %.16s%s\n",
diff --git a/net/smc/smc_pnet.c b/net/smc/smc_pnet.c
index 8a91ca22712f..9df82ed3bb06 100644
--- a/net/smc/smc_pnet.c
+++ b/net/smc/smc_pnet.c
@@ -73,7 +73,7 @@ struct smc_pnetentry {
 };
 
 /* Check if the pnetid is set */
-static bool smc_pnet_is_pnetid_set(u8 *pnetid)
+bool smc_pnet_is_pnetid_set(u8 *pnetid)
 {
 	if (pnetid[0] == 0 || pnetid[0] == _S)
 		return false;
diff --git a/net/smc/smc_pnet.h b/net/smc/smc_pnet.h
index 677a47ac158e..14039272f7e4 100644
--- a/net/smc/smc_pnet.h
+++ b/net/smc/smc_pnet.h
@@ -66,4 +66,5 @@ void smc_pnet_find_alt_roce(struct smc_link_group *lgr,
 			    struct smc_init_info *ini,
 			    struct smc_ib_device *known_dev);
 bool smc_pnet_is_ndev_pnetid(struct net *net, u8 *pnetid);
+bool smc_pnet_is_pnetid_set(u8 *pnetid);
 #endif
-- 
2.17.1

