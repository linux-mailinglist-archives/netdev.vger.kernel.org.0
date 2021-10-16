Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73CFC4301A6
	for <lists+netdev@lfdr.de>; Sat, 16 Oct 2021 11:39:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243994AbhJPJlN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Oct 2021 05:41:13 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:31862 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243966AbhJPJkk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Oct 2021 05:40:40 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19G8gCdT023627;
        Sat, 16 Oct 2021 05:38:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=4pC2QVp11GvrTRuuazetFbyn4+oMmwqhiI9fK7ct2fQ=;
 b=jD53CmGR8r6mPqKyyLIrYF3zbBzsAPu/R+lAyH9hgzoPOJaH87aALOC58TfCAgH5mvnf
 eyglnY+jdgneg16pEAWB45aTs2WL0VZrxztZGWFe7sSbRYJZ4FTV85FCav1fyuITGKjJ
 DGA5xtuEad/9KoevAihoN+LYDV89rHcyX7vrZFzIMXnAXlNQIRytavkXJq895BZvMN5B
 onm9kbJn/44nXW5bO7RDKU8dqHTdE8S6MjhLLBHapGn4eKEP057jp3BVhDFlohUZSlvD
 rkvcnaUFIySEFfJvoPQuwozAJJEdRXjrDPe+n+8jlNgOc+Gyaglh7ACJQkAGu38qHmW7 Hw== 
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bqueyrx9p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 16 Oct 2021 05:38:29 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19G9c99v008234;
        Sat, 16 Oct 2021 09:38:27 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma05fra.de.ibm.com with ESMTP id 3bqpc9161a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 16 Oct 2021 09:38:27 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19G9WeiC59572540
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 16 Oct 2021 09:32:40 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A017F4C040;
        Sat, 16 Oct 2021 09:38:24 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 69F444C050;
        Sat, 16 Oct 2021 09:38:24 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Sat, 16 Oct 2021 09:38:24 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>, linux-rdma@vger.kernel.org
Subject: [PATCH net-next v3 05/10] net/smc: add v2 format of CLC decline message
Date:   Sat, 16 Oct 2021 11:37:47 +0200
Message-Id: <20211016093752.3564615-6-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211016093752.3564615-1-kgraul@linux.ibm.com>
References: <20211016093752.3564615-1-kgraul@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: XMrA2g1CoCZtJ5uTpCcIR0RpouRtHWup
X-Proofpoint-GUID: XMrA2g1CoCZtJ5uTpCcIR0RpouRtHWup
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-16_03,2021-10-14_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0
 priorityscore=1501 phishscore=0 mlxlogscore=999 suspectscore=0 bulkscore=0
 impostorscore=0 malwarescore=0 lowpriorityscore=0 clxscore=1015 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110160058
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The CLC decline message changed with SMC-Rv2 and supports up to
4 additional diagnosis codes.

Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
---
 net/smc/smc_clc.c | 47 +++++++++++++++++++++++++++++++++++++----------
 net/smc/smc_clc.h | 18 ++++++++++++++++++
 2 files changed, 55 insertions(+), 10 deletions(-)

diff --git a/net/smc/smc_clc.c b/net/smc/smc_clc.c
index 5cc2e2dc7417..8409ab71a5e4 100644
--- a/net/smc/smc_clc.c
+++ b/net/smc/smc_clc.c
@@ -400,6 +400,24 @@ smc_clc_msg_acc_conf_valid(struct smc_clc_msg_accept_confirm_v2 *clc_v2)
 	return true;
 }
 
+/* check arriving CLC decline */
+static bool
+smc_clc_msg_decl_valid(struct smc_clc_msg_decline *dclc)
+{
+	struct smc_clc_msg_hdr *hdr = &dclc->hdr;
+
+	if (hdr->typev1 != SMC_TYPE_R && hdr->typev1 != SMC_TYPE_D)
+		return false;
+	if (hdr->version == SMC_V1) {
+		if (ntohs(hdr->length) != sizeof(struct smc_clc_msg_decline))
+			return false;
+	} else {
+		if (ntohs(hdr->length) != sizeof(struct smc_clc_msg_decline_v2))
+			return false;
+	}
+	return true;
+}
+
 static void smc_clc_fill_fce(struct smc_clc_first_contact_ext *fce, int *len)
 {
 	memset(fce, 0, sizeof(*fce));
@@ -441,9 +459,9 @@ static bool smc_clc_msg_hdr_valid(struct smc_clc_msg_hdr *clcm, bool check_trl)
 		break;
 	case SMC_CLC_DECLINE:
 		dclc = (struct smc_clc_msg_decline *)clcm;
-		if (ntohs(dclc->hdr.length) != sizeof(*dclc))
+		if (!smc_clc_msg_decl_valid(dclc))
 			return false;
-		trl = &dclc->trl;
+		check_trl = false;
 		break;
 	default:
 		return false;
@@ -742,15 +760,16 @@ int smc_clc_wait_msg(struct smc_sock *smc, void *buf, int buflen,
 /* send CLC DECLINE message across internal TCP socket */
 int smc_clc_send_decline(struct smc_sock *smc, u32 peer_diag_info, u8 version)
 {
-	struct smc_clc_msg_decline dclc;
+	struct smc_clc_msg_decline *dclc_v1;
+	struct smc_clc_msg_decline_v2 dclc;
 	struct msghdr msg;
+	int len, send_len;
 	struct kvec vec;
-	int len;
 
+	dclc_v1 = (struct smc_clc_msg_decline *)&dclc;
 	memset(&dclc, 0, sizeof(dclc));
 	memcpy(dclc.hdr.eyecatcher, SMC_EYECATCHER, sizeof(SMC_EYECATCHER));
 	dclc.hdr.type = SMC_CLC_DECLINE;
-	dclc.hdr.length = htons(sizeof(struct smc_clc_msg_decline));
 	dclc.hdr.version = version;
 	dclc.os_type = version == SMC_V1 ? 0 : SMC_CLC_OS_LINUX;
 	dclc.hdr.typev2 = (peer_diag_info == SMC_CLC_DECL_SYNCERR) ?
@@ -760,14 +779,22 @@ int smc_clc_send_decline(struct smc_sock *smc, u32 peer_diag_info, u8 version)
 		memcpy(dclc.id_for_peer, local_systemid,
 		       sizeof(local_systemid));
 	dclc.peer_diagnosis = htonl(peer_diag_info);
-	memcpy(dclc.trl.eyecatcher, SMC_EYECATCHER, sizeof(SMC_EYECATCHER));
+	if (version == SMC_V1) {
+		memcpy(dclc_v1->trl.eyecatcher, SMC_EYECATCHER,
+		       sizeof(SMC_EYECATCHER));
+		send_len = sizeof(*dclc_v1);
+	} else {
+		memcpy(dclc.trl.eyecatcher, SMC_EYECATCHER,
+		       sizeof(SMC_EYECATCHER));
+		send_len = sizeof(dclc);
+	}
+	dclc.hdr.length = htons(send_len);
 
 	memset(&msg, 0, sizeof(msg));
 	vec.iov_base = &dclc;
-	vec.iov_len = sizeof(struct smc_clc_msg_decline);
-	len = kernel_sendmsg(smc->clcsock, &msg, &vec, 1,
-			     sizeof(struct smc_clc_msg_decline));
-	if (len < 0 || len < sizeof(struct smc_clc_msg_decline))
+	vec.iov_len = send_len;
+	len = kernel_sendmsg(smc->clcsock, &msg, &vec, 1, send_len);
+	if (len < 0 || len < send_len)
 		len = -EPROTO;
 	return len > 0 ? 0 : len;
 }
diff --git a/net/smc/smc_clc.h b/net/smc/smc_clc.h
index 22c079ed77a9..83f02f131fc0 100644
--- a/net/smc/smc_clc.h
+++ b/net/smc/smc_clc.h
@@ -281,6 +281,24 @@ struct smc_clc_msg_decline {	/* clc decline message */
 	struct smc_clc_msg_trail trl; /* eye catcher "SMCD" or "SMCR" EBCDIC */
 } __aligned(4);
 
+#define SMC_DECL_DIAG_COUNT_V2	4 /* no. of additional peer diagnosis codes */
+
+struct smc_clc_msg_decline_v2 {	/* clc decline message */
+	struct smc_clc_msg_hdr hdr;
+	u8 id_for_peer[SMC_SYSTEMID_LEN]; /* sender peer_id */
+	__be32 peer_diagnosis;	/* diagnosis information */
+#if defined(__BIG_ENDIAN_BITFIELD)
+	u8 os_type  : 4,
+	   reserved : 4;
+#elif defined(__LITTLE_ENDIAN_BITFIELD)
+	u8 reserved : 4,
+	   os_type  : 4;
+#endif
+	u8 reserved2[3];
+	__be32 peer_diagnosis_v2[SMC_DECL_DIAG_COUNT_V2];
+	struct smc_clc_msg_trail trl; /* eye catcher "SMCD" or "SMCR" EBCDIC */
+} __aligned(4);
+
 /* determine start of the prefix area within the proposal message */
 static inline struct smc_clc_msg_proposal_prefix *
 smc_clc_proposal_get_prefix(struct smc_clc_msg_proposal *pclc)
-- 
2.25.1

