Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 548D1279893
	for <lists+netdev@lfdr.de>; Sat, 26 Sep 2020 12:46:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729347AbgIZKpp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Sep 2020 06:45:45 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:38010 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728330AbgIZKo4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Sep 2020 06:44:56 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08QAVhob058887;
        Sat, 26 Sep 2020 06:44:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=BZRHHoWUWXnR0fv/BmxgVTN+BYhrrZ6M0JCA4HomkyU=;
 b=kSWXjqlcKR1LnnUvauZMygYQ1g84/q5QGWDiPJogCxWlyc7PCmaPxuRgBC5YfE3MSm56
 lzVApqH7wTBUE2i6DfxH+ZCJBGOFBiLZnXv05TpKxEqNFyE5TlQZnVMd3qe7QtCBodPS
 cfkYoZY7jVp04SALh1EbWY94xtQzeR/ZaMsoyPH0aOaUqMmDN0qnuYEmZdpuJDftZuoM
 w3G+kinuZduJ/iL8rkejlPraFUbpGPZedz1/H2YvrxFYsNMab+3IMW1mE/uVWlw/DvtW
 NMKEbr+B9zneG0wvyJG26Mo1tSAHMY4xeKA3cK8PbAOn7OFBh8vezSCWZAiQgJW3AbcZ FQ== 
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33t2c2sutx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 26 Sep 2020 06:44:53 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08QAgRHO025655;
        Sat, 26 Sep 2020 10:44:52 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03fra.de.ibm.com with ESMTP id 33sw9884p3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 26 Sep 2020 10:44:51 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08QAinVI31523100
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 26 Sep 2020 10:44:49 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0E2F4A4054;
        Sat, 26 Sep 2020 10:44:49 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C812BA405C;
        Sat, 26 Sep 2020 10:44:48 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Sat, 26 Sep 2020 10:44:48 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: [PATCH net-next 14/14] net/smc: CLC decline - V2 enhancements
Date:   Sat, 26 Sep 2020 12:44:32 +0200
Message-Id: <20200926104432.74293-15-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200926104432.74293-1-kgraul@linux.ibm.com>
References: <20200926104432.74293-1-kgraul@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-26_06:2020-09-24,2020-09-26 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=3 malwarescore=0
 clxscore=1015 mlxscore=0 lowpriorityscore=0 spamscore=0 impostorscore=0
 phishscore=0 bulkscore=0 adultscore=0 mlxlogscore=999 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009260091
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ursula Braun <ubraun@linux.ibm.com>

This patch covers the small SMCD version 2 changes for CLC decline.

Signed-off-by: Ursula Braun <ubraun@linux.ibm.com>
Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
---
 net/smc/af_smc.c  | 27 +++++++++++++++++----------
 net/smc/smc_clc.c |  5 +++--
 net/smc/smc_clc.h | 13 ++++++++++---
 3 files changed, 30 insertions(+), 15 deletions(-)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index 3007f9c36d2c..ec933565d912 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -531,7 +531,8 @@ static int smc_connect_fallback(struct smc_sock *smc, int reason_code)
 }
 
 /* decline and fall back during connect */
-static int smc_connect_decline_fallback(struct smc_sock *smc, int reason_code)
+static int smc_connect_decline_fallback(struct smc_sock *smc, int reason_code,
+					u8 version)
 {
 	int rc;
 
@@ -541,7 +542,7 @@ static int smc_connect_decline_fallback(struct smc_sock *smc, int reason_code)
 		return reason_code;
 	}
 	if (reason_code != SMC_CLC_DECL_PEERDECL) {
-		rc = smc_clc_send_decline(smc, reason_code);
+		rc = smc_clc_send_decline(smc, reason_code, version);
 		if (rc < 0) {
 			if (smc->sk.sk_state == SMC_INIT)
 				sock_put(&smc->sk); /* passive closing */
@@ -901,6 +902,7 @@ static int smc_connect_check_aclc(struct smc_init_info *ini,
 /* perform steps before actually connecting */
 static int __smc_connect(struct smc_sock *smc)
 {
+	u8 version = smc_ism_v2_capable ? SMC_V2 : SMC_V1;
 	struct smc_clc_msg_accept_confirm_v2 *aclc2;
 	struct smc_clc_msg_accept_confirm *aclc;
 	struct smc_init_info *ini = NULL;
@@ -914,13 +916,15 @@ static int __smc_connect(struct smc_sock *smc)
 	if (!tcp_sk(smc->clcsock->sk)->syn_smc)
 		return smc_connect_fallback(smc, SMC_CLC_DECL_PEERNOSMC);
 
-	/* IPSec connections opt out of SMC-R optimizations */
+	/* IPSec connections opt out of SMC optimizations */
 	if (using_ipsec(smc))
-		return smc_connect_decline_fallback(smc, SMC_CLC_DECL_IPSEC);
+		return smc_connect_decline_fallback(smc, SMC_CLC_DECL_IPSEC,
+						    version);
 
 	ini = kzalloc(sizeof(*ini), GFP_KERNEL);
 	if (!ini)
-		return smc_connect_decline_fallback(smc, SMC_CLC_DECL_MEM);
+		return smc_connect_decline_fallback(smc, SMC_CLC_DECL_MEM,
+						    version);
 
 	ini->smcd_version = SMC_V1;
 	ini->smcd_version |= smc_ism_v2_capable ? SMC_V2 : 0;
@@ -956,6 +960,7 @@ static int __smc_connect(struct smc_sock *smc)
 
 	/* check if smc modes and versions of CLC proposal and accept match */
 	rc = smc_connect_check_aclc(ini, aclc);
+	version = aclc->hdr.version == SMC_V1 ? SMC_V1 : version;
 	if (rc)
 		goto vlan_cleanup;
 
@@ -977,7 +982,7 @@ static int __smc_connect(struct smc_sock *smc)
 	kfree(buf);
 fallback:
 	kfree(ini);
-	return smc_connect_decline_fallback(smc, rc);
+	return smc_connect_decline_fallback(smc, rc, version);
 }
 
 static void smc_connect_work(struct work_struct *work)
@@ -1293,7 +1298,7 @@ static void smc_listen_out_err(struct smc_sock *new_smc)
 
 /* listen worker: decline and fall back if possible */
 static void smc_listen_decline(struct smc_sock *new_smc, int reason_code,
-			       struct smc_init_info *ini)
+			       struct smc_init_info *ini, u8 version)
 {
 	/* RDMA setup failed, switch back to TCP */
 	if (ini->first_contact_local)
@@ -1307,7 +1312,7 @@ static void smc_listen_decline(struct smc_sock *new_smc, int reason_code,
 	smc_switch_to_fallback(new_smc);
 	new_smc->fallback_rsn = reason_code;
 	if (reason_code && reason_code != SMC_CLC_DECL_PEERDECL) {
-		if (smc_clc_send_decline(new_smc, reason_code) < 0) {
+		if (smc_clc_send_decline(new_smc, reason_code, version) < 0) {
 			smc_listen_out_err(new_smc);
 			return;
 		}
@@ -1638,6 +1643,7 @@ static void smc_listen_work(struct work_struct *work)
 {
 	struct smc_sock *new_smc = container_of(work, struct smc_sock,
 						smc_listen_work);
+	u8 version = smc_ism_v2_capable ? SMC_V2 : SMC_V1;
 	struct socket *newclcsock = new_smc->clcsock;
 	struct smc_clc_msg_accept_confirm_v2 *cclc2;
 	struct smc_clc_msg_accept_confirm *cclc;
@@ -1675,8 +1681,9 @@ static void smc_listen_work(struct work_struct *work)
 			      SMC_CLC_PROPOSAL, CLC_WAIT_TIME);
 	if (rc)
 		goto out_decl;
+	version = pclc->hdr.version == SMC_V1 ? SMC_V1 : version;
 
-	/* IPSec connections opt out of SMC-R optimizations */
+	/* IPSec connections opt out of SMC optimizations */
 	if (using_ipsec(new_smc)) {
 		rc = SMC_CLC_DECL_IPSEC;
 		goto out_decl;
@@ -1741,7 +1748,7 @@ static void smc_listen_work(struct work_struct *work)
 out_unlock:
 	mutex_unlock(&smc_server_lgr_pending);
 out_decl:
-	smc_listen_decline(new_smc, rc, ini);
+	smc_listen_decline(new_smc, rc, ini, version);
 out_free:
 	kfree(ini);
 	kfree(buf);
diff --git a/net/smc/smc_clc.c b/net/smc/smc_clc.c
index 6762291b3940..09e36462ec0d 100644
--- a/net/smc/smc_clc.c
+++ b/net/smc/smc_clc.c
@@ -443,7 +443,7 @@ int smc_clc_wait_msg(struct smc_sock *smc, void *buf, int buflen,
 }
 
 /* send CLC DECLINE message across internal TCP socket */
-int smc_clc_send_decline(struct smc_sock *smc, u32 peer_diag_info)
+int smc_clc_send_decline(struct smc_sock *smc, u32 peer_diag_info, u8 version)
 {
 	struct smc_clc_msg_decline dclc;
 	struct msghdr msg;
@@ -454,7 +454,8 @@ int smc_clc_send_decline(struct smc_sock *smc, u32 peer_diag_info)
 	memcpy(dclc.hdr.eyecatcher, SMC_EYECATCHER, sizeof(SMC_EYECATCHER));
 	dclc.hdr.type = SMC_CLC_DECLINE;
 	dclc.hdr.length = htons(sizeof(struct smc_clc_msg_decline));
-	dclc.hdr.version = SMC_V1;
+	dclc.hdr.version = version;
+	dclc.os_type = version == SMC_V1 ? 0 : SMC_CLC_OS_LINUX;
 	dclc.hdr.typev2 = (peer_diag_info == SMC_CLC_DECL_SYNCERR) ?
 						SMC_FIRST_CONTACT_MASK : 0;
 	if ((!smc->conn.lgr || !smc->conn.lgr->is_smcd) &&
diff --git a/net/smc/smc_clc.h b/net/smc/smc_clc.h
index 92179d955f59..b3f46ab79e47 100644
--- a/net/smc/smc_clc.h
+++ b/net/smc/smc_clc.h
@@ -244,8 +244,15 @@ struct smc_clc_msg_decline {	/* clc decline message */
 	struct smc_clc_msg_hdr hdr;
 	u8 id_for_peer[SMC_SYSTEMID_LEN]; /* sender peer_id */
 	__be32 peer_diagnosis;	/* diagnosis information */
-	u8 reserved2[4];
-	struct smc_clc_msg_trail trl; /* eye catcher "SMCR" EBCDIC */
+#if defined(__BIG_ENDIAN_BITFIELD)
+	u8 os_type  : 4,
+	   reserved : 4;
+#elif defined(__LITTLE_ENDIAN_BITFIELD)
+	u8 reserved : 4,
+	   os_type  : 4;
+#endif
+	u8 reserved2[3];
+	struct smc_clc_msg_trail trl; /* eye catcher "SMCD" or "SMCR" EBCDIC */
 } __aligned(4);
 
 /* determine start of the prefix area within the proposal message */
@@ -315,7 +322,7 @@ int smc_clc_prfx_match(struct socket *clcsock,
 		       struct smc_clc_msg_proposal_prefix *prop);
 int smc_clc_wait_msg(struct smc_sock *smc, void *buf, int buflen,
 		     u8 expected_type, unsigned long timeout);
-int smc_clc_send_decline(struct smc_sock *smc, u32 peer_diag_info);
+int smc_clc_send_decline(struct smc_sock *smc, u32 peer_diag_info, u8 version);
 int smc_clc_send_proposal(struct smc_sock *smc, struct smc_init_info *ini);
 int smc_clc_send_confirm(struct smc_sock *smc, bool clnt_first_contact,
 			 u8 version);
-- 
2.17.1

