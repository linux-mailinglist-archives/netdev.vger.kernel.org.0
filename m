Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D76EE218AC2
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 17:05:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730075AbgGHPF2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 11:05:28 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:18482 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729909AbgGHPF0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 11:05:26 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 068F3d8f143173;
        Wed, 8 Jul 2020 11:05:24 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 325ef2vgbq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Jul 2020 11:05:23 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 068EnvhT003406;
        Wed, 8 Jul 2020 15:05:21 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03ams.nl.ibm.com with ESMTP id 322hd7vq1n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Jul 2020 15:05:21 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 068F5Ico63176932
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 8 Jul 2020 15:05:18 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8477AAE055;
        Wed,  8 Jul 2020 15:05:18 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 49F3AAE056;
        Wed,  8 Jul 2020 15:05:18 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  8 Jul 2020 15:05:18 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: [PATCH net 5/5] net/smc: tolerate future SMCD versions
Date:   Wed,  8 Jul 2020 17:05:15 +0200
Message-Id: <20200708150515.44938-6-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200708150515.44938-1-kgraul@linux.ibm.com>
References: <20200708150515.44938-1-kgraul@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-08_13:2020-07-08,2020-07-08 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 malwarescore=0 adultscore=0 suspectscore=1 priorityscore=1501
 clxscore=1015 cotscore=-2147483648 mlxscore=0 bulkscore=0 phishscore=0
 mlxlogscore=876 spamscore=0 impostorscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2007080103
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ursula Braun <ubraun@linux.ibm.com>

CLC proposal messages of future SMCD versions could be larger than SMCD
V1 CLC proposal messages.
To enable toleration in SMC V1 the receival of CLC proposal messages
is adapted:
* accept larger length values in CLC proposal
* check trailing eye catcher for incoming CLC proposal with V1 length only
* receive the whole CLC proposal even in cases it does not fit into the
  V1 buffer

Fixes: e7b7a64a8493d ("smc: support variable CLC proposal messages")
Signed-off-by: Ursula Braun <ubraun@linux.ibm.com>
Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
---
 net/smc/smc_clc.c | 45 ++++++++++++++++++++++++++++++++-------------
 net/smc/smc_clc.h |  2 ++
 2 files changed, 34 insertions(+), 13 deletions(-)

diff --git a/net/smc/smc_clc.c b/net/smc/smc_clc.c
index d5627df24215..779f4142a11d 100644
--- a/net/smc/smc_clc.c
+++ b/net/smc/smc_clc.c
@@ -27,6 +27,7 @@
 
 #define SMCR_CLC_ACCEPT_CONFIRM_LEN 68
 #define SMCD_CLC_ACCEPT_CONFIRM_LEN 48
+#define SMC_CLC_RECV_BUF_LEN	100
 
 /* eye catcher "SMCR" EBCDIC for CLC messages */
 static const char SMC_EYECATCHER[4] = {'\xe2', '\xd4', '\xc3', '\xd9'};
@@ -36,7 +37,7 @@ static const char SMCD_EYECATCHER[4] = {'\xe2', '\xd4', '\xc3', '\xc4'};
 /* check if received message has a correct header length and contains valid
  * heading and trailing eyecatchers
  */
-static bool smc_clc_msg_hdr_valid(struct smc_clc_msg_hdr *clcm)
+static bool smc_clc_msg_hdr_valid(struct smc_clc_msg_hdr *clcm, bool check_trl)
 {
 	struct smc_clc_msg_proposal_prefix *pclc_prfx;
 	struct smc_clc_msg_accept_confirm *clc;
@@ -49,12 +50,9 @@ static bool smc_clc_msg_hdr_valid(struct smc_clc_msg_hdr *clcm)
 		return false;
 	switch (clcm->type) {
 	case SMC_CLC_PROPOSAL:
-		if (clcm->path != SMC_TYPE_R && clcm->path != SMC_TYPE_D &&
-		    clcm->path != SMC_TYPE_B)
-			return false;
 		pclc = (struct smc_clc_msg_proposal *)clcm;
 		pclc_prfx = smc_clc_proposal_get_prefix(pclc);
-		if (ntohs(pclc->hdr.length) !=
+		if (ntohs(pclc->hdr.length) <
 			sizeof(*pclc) + ntohs(pclc->iparea_offset) +
 			sizeof(*pclc_prfx) +
 			pclc_prfx->ipv6_prefixes_cnt *
@@ -86,7 +84,8 @@ static bool smc_clc_msg_hdr_valid(struct smc_clc_msg_hdr *clcm)
 	default:
 		return false;
 	}
-	if (memcmp(trl->eyecatcher, SMC_EYECATCHER, sizeof(SMC_EYECATCHER)) &&
+	if (check_trl &&
+	    memcmp(trl->eyecatcher, SMC_EYECATCHER, sizeof(SMC_EYECATCHER)) &&
 	    memcmp(trl->eyecatcher, SMCD_EYECATCHER, sizeof(SMCD_EYECATCHER)))
 		return false;
 	return true;
@@ -276,7 +275,8 @@ int smc_clc_wait_msg(struct smc_sock *smc, void *buf, int buflen,
 	struct msghdr msg = {NULL, 0};
 	int reason_code = 0;
 	struct kvec vec = {buf, buflen};
-	int len, datlen;
+	int len, datlen, recvlen;
+	bool check_trl = true;
 	int krflags;
 
 	/* peek the first few bytes to determine length of data to receive
@@ -320,10 +320,7 @@ int smc_clc_wait_msg(struct smc_sock *smc, void *buf, int buflen,
 	}
 	datlen = ntohs(clcm->length);
 	if ((len < sizeof(struct smc_clc_msg_hdr)) ||
-	    (datlen > buflen) ||
-	    (clcm->version != SMC_CLC_V1) ||
-	    (clcm->path != SMC_TYPE_R && clcm->path != SMC_TYPE_D &&
-	     clcm->path != SMC_TYPE_B) ||
+	    (clcm->version < SMC_CLC_V1) ||
 	    ((clcm->type != SMC_CLC_DECLINE) &&
 	     (clcm->type != expected_type))) {
 		smc->sk.sk_err = EPROTO;
@@ -331,16 +328,38 @@ int smc_clc_wait_msg(struct smc_sock *smc, void *buf, int buflen,
 		goto out;
 	}
 
+	if (clcm->type == SMC_CLC_PROPOSAL && clcm->path == SMC_TYPE_N)
+		reason_code = SMC_CLC_DECL_VERSMISMAT; /* just V2 offered */
+
 	/* receive the complete CLC message */
 	memset(&msg, 0, sizeof(struct msghdr));
-	iov_iter_kvec(&msg.msg_iter, READ, &vec, 1, datlen);
+	if (datlen > buflen) {
+		check_trl = false;
+		recvlen = buflen;
+	} else {
+		recvlen = datlen;
+	}
+	iov_iter_kvec(&msg.msg_iter, READ, &vec, 1, recvlen);
 	krflags = MSG_WAITALL;
 	len = sock_recvmsg(smc->clcsock, &msg, krflags);
-	if (len < datlen || !smc_clc_msg_hdr_valid(clcm)) {
+	if (len < recvlen || !smc_clc_msg_hdr_valid(clcm, check_trl)) {
 		smc->sk.sk_err = EPROTO;
 		reason_code = -EPROTO;
 		goto out;
 	}
+	datlen -= len;
+	while (datlen) {
+		u8 tmp[SMC_CLC_RECV_BUF_LEN];
+
+		vec.iov_base = &tmp;
+		vec.iov_len = SMC_CLC_RECV_BUF_LEN;
+		/* receive remaining proposal message */
+		recvlen = datlen > SMC_CLC_RECV_BUF_LEN ?
+						SMC_CLC_RECV_BUF_LEN : datlen;
+		iov_iter_kvec(&msg.msg_iter, READ, &vec, 1, recvlen);
+		len = sock_recvmsg(smc->clcsock, &msg, krflags);
+		datlen -= len;
+	}
 	if (clcm->type == SMC_CLC_DECLINE) {
 		struct smc_clc_msg_decline *dclc;
 
diff --git a/net/smc/smc_clc.h b/net/smc/smc_clc.h
index 465876701b75..76c2b150d040 100644
--- a/net/smc/smc_clc.h
+++ b/net/smc/smc_clc.h
@@ -25,6 +25,7 @@
 #define SMC_CLC_V1		0x1		/* SMC version                */
 #define SMC_TYPE_R		0		/* SMC-R only		      */
 #define SMC_TYPE_D		1		/* SMC-D only		      */
+#define SMC_TYPE_N		2		/* neither SMC-R nor SMC-D    */
 #define SMC_TYPE_B		3		/* SMC-R and SMC-D	      */
 #define CLC_WAIT_TIME		(6 * HZ)	/* max. wait time on clcsock  */
 #define CLC_WAIT_TIME_SHORT	HZ		/* short wait time on clcsock */
@@ -46,6 +47,7 @@
 #define SMC_CLC_DECL_ISMVLANERR	0x03090000  /* err to reg vlan id on ism dev  */
 #define SMC_CLC_DECL_NOACTLINK	0x030a0000  /* no active smc-r link in lgr    */
 #define SMC_CLC_DECL_NOSRVLINK	0x030b0000  /* SMC-R link from srv not found  */
+#define SMC_CLC_DECL_VERSMISMAT	0x030c0000  /* SMC version mismatch	      */
 #define SMC_CLC_DECL_SYNCERR	0x04000000  /* synchronization error          */
 #define SMC_CLC_DECL_PEERDECL	0x05000000  /* peer declined during handshake */
 #define SMC_CLC_DECL_INTERR	0x09990000  /* internal error		      */
-- 
2.17.1

