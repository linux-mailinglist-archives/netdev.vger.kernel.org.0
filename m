Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FBCF264A54
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 18:52:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726776AbgIJQwS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 12:52:18 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:7714 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727025AbgIJQtW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 12:49:22 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08AGXYnp058975;
        Thu, 10 Sep 2020 12:49:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=BHQ+1cVnYbI0EyMXOTdh1UTrnGYpmRzOBLjvIax/7N0=;
 b=KB7lizZDPcdlTwUPqThtqLv0pSCBckggL3BkUC+HLVFx8bEtBg7Z+r3uB78pNIJtkuhx
 b7QDBUHvFggKf0liHX3HwwM2KfSWoYKB9XRsLKXRajp8SIyZjBCMOPgtU6y/dYHg7fN+
 JDBWixXp77DPGP5mnBtPln/w5DwhSvHir+gjnP2nwZzqy6oGFqayKYZ4DCbvXA8JxKHU
 dI78zTv48RjdRiZXqtTZx3EYZr2eZQVLfEJ90Qm3Coj8+aBIduZTERWqxGDbL4WzasrB
 /aIjDZ4KbVSvTx9Oid8zkgvAD2uCW7C770hIezumzHX2vvrzX/ugyrP8tad4np0WpvuL hA== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33fq2s27np-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Sep 2020 12:49:05 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08AGkwoF021245;
        Thu, 10 Sep 2020 16:49:02 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma06ams.nl.ibm.com with ESMTP id 33dxdr3f9u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Sep 2020 16:49:02 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08AGn0Ya28770810
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Sep 2020 16:49:00 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EAC0A4C050;
        Thu, 10 Sep 2020 16:48:59 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AA6834C04E;
        Thu, 10 Sep 2020 16:48:59 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 10 Sep 2020 16:48:59 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: [PATCH net-next 03/10] net/smc: dynamic allocation of CLC proposal buffer
Date:   Thu, 10 Sep 2020 18:48:22 +0200
Message-Id: <20200910164829.65426-4-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200910164829.65426-1-kgraul@linux.ibm.com>
References: <20200910164829.65426-1-kgraul@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-10_05:2020-09-10,2020-09-10 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 impostorscore=0
 bulkscore=0 priorityscore=1501 mlxscore=0 spamscore=0 phishscore=0
 malwarescore=0 mlxlogscore=999 clxscore=1015 lowpriorityscore=0
 suspectscore=1 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009100153
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ursula Braun <ubraun@linux.ibm.com>

Reduce stack size for smc_listen_work() and smc_clc_send_proposal()
by dynamic allocation of the CLC buffer to be received or sent.

Signed-off-by: Ursula Braun <ubraun@linux.ibm.com>
Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
---
 net/smc/af_smc.c  | 13 +++++--
 net/smc/smc_clc.c | 88 +++++++++++++++++++++++++++--------------------
 net/smc/smc_clc.h | 15 ++++----
 3 files changed, 67 insertions(+), 49 deletions(-)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index 8f6472f4ae21..00e2a4ce0131 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -1276,10 +1276,10 @@ static void smc_listen_work(struct work_struct *work)
 						smc_listen_work);
 	struct socket *newclcsock = new_smc->clcsock;
 	struct smc_clc_msg_accept_confirm cclc;
+	struct smc_clc_msg_proposal_area *buf;
 	struct smc_clc_msg_proposal *pclc;
 	struct smc_init_info ini = {0};
 	bool ism_supported = false;
-	u8 buf[SMC_CLC_MAX_LEN];
 	int rc = 0;
 
 	if (new_smc->listen_smc->sk.sk_state != SMC_LISTEN)
@@ -1301,8 +1301,13 @@ static void smc_listen_work(struct work_struct *work)
 	/* do inband token exchange -
 	 * wait for and receive SMC Proposal CLC message
 	 */
-	pclc = (struct smc_clc_msg_proposal *)&buf;
-	rc = smc_clc_wait_msg(new_smc, pclc, SMC_CLC_MAX_LEN,
+	buf = kzalloc(sizeof(*buf), GFP_KERNEL);
+	if (!buf) {
+		rc = SMC_CLC_DECL_MEM;
+		goto out_decl;
+	}
+	pclc = (struct smc_clc_msg_proposal *)buf;
+	rc = smc_clc_wait_msg(new_smc, pclc, sizeof(*buf),
 			      SMC_CLC_PROPOSAL, CLC_WAIT_TIME);
 	if (rc)
 		goto out_decl;
@@ -1382,6 +1387,7 @@ static void smc_listen_work(struct work_struct *work)
 	}
 
 	/* finish worker */
+	kfree(buf);
 	if (!ism_supported) {
 		rc = smc_listen_rdma_finish(new_smc, &cclc,
 					    ini.first_contact_local);
@@ -1397,6 +1403,7 @@ static void smc_listen_work(struct work_struct *work)
 	mutex_unlock(&smc_server_lgr_pending);
 out_decl:
 	smc_listen_decline(new_smc, rc, ini.first_contact_local);
+	kfree(buf);
 }
 
 static void smc_tcp_listen_work(struct work_struct *work)
diff --git a/net/smc/smc_clc.c b/net/smc/smc_clc.c
index c30fad120089..0c8e74faf5ca 100644
--- a/net/smc/smc_clc.c
+++ b/net/smc/smc_clc.c
@@ -153,7 +153,6 @@ static int smc_clc_prfx_set(struct socket *clcsock,
 	struct sockaddr_in *addr;
 	int rc = -ENOENT;
 
-	memset(prop, 0, sizeof(*prop));
 	if (!dst) {
 		rc = -ENOTCONN;
 		goto out;
@@ -412,76 +411,89 @@ int smc_clc_send_decline(struct smc_sock *smc, u32 peer_diag_info)
 int smc_clc_send_proposal(struct smc_sock *smc, int smc_type,
 			  struct smc_init_info *ini)
 {
-	struct smc_clc_ipv6_prefix ipv6_prfx[SMC_CLC_MAX_V6_PREFIX];
-	struct smc_clc_msg_proposal_prefix pclc_prfx;
-	struct smc_clc_msg_smcd pclc_smcd;
-	struct smc_clc_msg_proposal pclc;
-	struct smc_clc_msg_trail trl;
+	struct smc_clc_msg_proposal_prefix *pclc_prfx;
+	struct smc_clc_msg_proposal *pclc_base;
+	struct smc_clc_msg_proposal_area *pclc;
+	struct smc_clc_ipv6_prefix *ipv6_prfx;
+	struct smc_clc_msg_smcd *pclc_smcd;
+	struct smc_clc_msg_trail *trl;
 	int len, i, plen, rc;
 	int reason_code = 0;
 	struct kvec vec[5];
 	struct msghdr msg;
 
+	pclc = kzalloc(sizeof(*pclc), GFP_KERNEL);
+	if (!pclc)
+		return -ENOMEM;
+
+	pclc_base = &pclc->pclc_base;
+	pclc_smcd = &pclc->pclc_smcd;
+	pclc_prfx = &pclc->pclc_prfx;
+	ipv6_prfx = pclc->pclc_prfx_ipv6;
+	trl = &pclc->pclc_trl;
+
 	/* retrieve ip prefixes for CLC proposal msg */
-	rc = smc_clc_prfx_set(smc->clcsock, &pclc_prfx, ipv6_prfx);
-	if (rc)
+	rc = smc_clc_prfx_set(smc->clcsock, pclc_prfx, ipv6_prfx);
+	if (rc) {
+		kfree(pclc);
 		return SMC_CLC_DECL_CNFERR; /* configuration error */
+	}
 
 	/* send SMC Proposal CLC message */
-	plen = sizeof(pclc) + sizeof(pclc_prfx) +
-	       (pclc_prfx.ipv6_prefixes_cnt * sizeof(ipv6_prfx[0])) +
-	       sizeof(trl);
-	memset(&pclc, 0, sizeof(pclc));
-	memcpy(pclc.hdr.eyecatcher, SMC_EYECATCHER, sizeof(SMC_EYECATCHER));
-	pclc.hdr.type = SMC_CLC_PROPOSAL;
-	pclc.hdr.version = SMC_V1;		/* SMC version */
-	pclc.hdr.path = smc_type;
+	plen = sizeof(*pclc_base) + sizeof(*pclc_prfx) +
+	       (pclc_prfx->ipv6_prefixes_cnt * sizeof(ipv6_prfx[0])) +
+	       sizeof(*trl);
+	memcpy(pclc_base->hdr.eyecatcher, SMC_EYECATCHER,
+	       sizeof(SMC_EYECATCHER));
+	pclc_base->hdr.type = SMC_CLC_PROPOSAL;
+	pclc_base->hdr.version = SMC_V1;		/* SMC version */
+	pclc_base->hdr.path = smc_type;
 	if (smc_type == SMC_TYPE_R || smc_type == SMC_TYPE_B) {
 		/* add SMC-R specifics */
-		memcpy(pclc.lcl.id_for_peer, local_systemid,
+		memcpy(pclc_base->lcl.id_for_peer, local_systemid,
 		       sizeof(local_systemid));
-		memcpy(&pclc.lcl.gid, ini->ib_gid, SMC_GID_SIZE);
-		memcpy(&pclc.lcl.mac, &ini->ib_dev->mac[ini->ib_port - 1],
+		memcpy(pclc_base->lcl.gid, ini->ib_gid, SMC_GID_SIZE);
+		memcpy(pclc_base->lcl.mac, &ini->ib_dev->mac[ini->ib_port - 1],
 		       ETH_ALEN);
-		pclc.iparea_offset = htons(0);
+		pclc_base->iparea_offset = htons(0);
 	}
 	if (smc_type == SMC_TYPE_D || smc_type == SMC_TYPE_B) {
 		/* add SMC-D specifics */
-		memset(&pclc_smcd, 0, sizeof(pclc_smcd));
-		plen += sizeof(pclc_smcd);
-		pclc.iparea_offset = htons(SMC_CLC_PROPOSAL_MAX_OFFSET);
-		pclc_smcd.gid = ini->ism_dev->local_gid;
+		plen += sizeof(*pclc_smcd);
+		pclc_base->iparea_offset = htons(sizeof(*pclc_smcd));
+		pclc_smcd->gid = ini->ism_dev->local_gid;
 	}
-	pclc.hdr.length = htons(plen);
+	pclc_base->hdr.length = htons(plen);
 
-	memcpy(trl.eyecatcher, SMC_EYECATCHER, sizeof(SMC_EYECATCHER));
+	memcpy(trl->eyecatcher, SMC_EYECATCHER, sizeof(SMC_EYECATCHER));
 	memset(&msg, 0, sizeof(msg));
 	i = 0;
-	vec[i].iov_base = &pclc;
-	vec[i++].iov_len = sizeof(pclc);
+	vec[i].iov_base = pclc_base;
+	vec[i++].iov_len = sizeof(*pclc_base);
 	if (smc_type == SMC_TYPE_D || smc_type == SMC_TYPE_B) {
-		vec[i].iov_base = &pclc_smcd;
-		vec[i++].iov_len = sizeof(pclc_smcd);
+		vec[i].iov_base = pclc_smcd;
+		vec[i++].iov_len = sizeof(*pclc_smcd);
 	}
-	vec[i].iov_base = &pclc_prfx;
-	vec[i++].iov_len = sizeof(pclc_prfx);
-	if (pclc_prfx.ipv6_prefixes_cnt > 0) {
-		vec[i].iov_base = &ipv6_prfx[0];
-		vec[i++].iov_len = pclc_prfx.ipv6_prefixes_cnt *
+	vec[i].iov_base = pclc_prfx;
+	vec[i++].iov_len = sizeof(*pclc_prfx);
+	if (pclc_prfx->ipv6_prefixes_cnt > 0) {
+		vec[i].iov_base = ipv6_prfx;
+		vec[i++].iov_len = pclc_prfx->ipv6_prefixes_cnt *
 				   sizeof(ipv6_prfx[0]);
 	}
-	vec[i].iov_base = &trl;
-	vec[i++].iov_len = sizeof(trl);
+	vec[i].iov_base = trl;
+	vec[i++].iov_len = sizeof(*trl);
 	/* due to the few bytes needed for clc-handshake this cannot block */
 	len = kernel_sendmsg(smc->clcsock, &msg, vec, i, plen);
 	if (len < 0) {
 		smc->sk.sk_err = smc->clcsock->sk->sk_err;
 		reason_code = -smc->sk.sk_err;
-	} else if (len < (int)sizeof(pclc)) {
+	} else if (len < ntohs(pclc_base->hdr.length)) {
 		reason_code = -ENETUNREACH;
 		smc->sk.sk_err = -reason_code;
 	}
 
+	kfree(pclc);
 	return reason_code;
 }
 
diff --git a/net/smc/smc_clc.h b/net/smc/smc_clc.h
index f98ca84ef2fe..7f7c55ff0476 100644
--- a/net/smc/smc_clc.h
+++ b/net/smc/smc_clc.h
@@ -110,14 +110,13 @@ struct smc_clc_msg_proposal {	/* clc proposal message sent by Linux */
 	__be16 iparea_offset;	/* offset to IP address information area */
 } __aligned(4);
 
-#define SMC_CLC_PROPOSAL_MAX_OFFSET	0x28
-#define SMC_CLC_PROPOSAL_MAX_PREFIX	(SMC_CLC_MAX_V6_PREFIX * \
-					 sizeof(struct smc_clc_ipv6_prefix))
-#define SMC_CLC_MAX_LEN		(sizeof(struct smc_clc_msg_proposal) + \
-				 SMC_CLC_PROPOSAL_MAX_OFFSET + \
-				 sizeof(struct smc_clc_msg_proposal_prefix) + \
-				 SMC_CLC_PROPOSAL_MAX_PREFIX + \
-				 sizeof(struct smc_clc_msg_trail))
+struct smc_clc_msg_proposal_area {
+	struct smc_clc_msg_proposal		pclc_base;
+	struct smc_clc_msg_smcd			pclc_smcd;
+	struct smc_clc_msg_proposal_prefix	pclc_prfx;
+	struct smc_clc_ipv6_prefix	pclc_prfx_ipv6[SMC_CLC_MAX_V6_PREFIX];
+	struct smc_clc_msg_trail		pclc_trl;
+};
 
 struct smc_clc_msg_accept_confirm {	/* clc accept / confirm message */
 	struct smc_clc_msg_hdr hdr;
-- 
2.17.1

