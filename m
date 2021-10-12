Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F3FE42A1D7
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 12:18:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235916AbhJLKUe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 06:20:34 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:64706 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S235885AbhJLKUZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Oct 2021 06:20:25 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19C9CNll018680;
        Tue, 12 Oct 2021 06:18:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=4pC2QVp11GvrTRuuazetFbyn4+oMmwqhiI9fK7ct2fQ=;
 b=AumH0VEleTu2aJ3N/x7UGqZu/LQSzLvyZRZoiDeZX7oZcLTN/zb4cPYzeJTWKGP80YoK
 oEsk8fCvLjr15WPhg3SycD2gwsLvxf7ZGkUCgbUOM/vsV4TIOXaqIdR+4UMJ5nd7tlO7
 xH8kYR1WiOY0ekat8+8B1wWEDLuByQCpFsGKWY/TkITzCwODTaDz8Egxqrz/vi8NHaHD
 GtYVbYNwPuJpywjUiakZ+mXgcilhCEj8YtfKSbV8/OnAYlNnnia2fkewvVShtKOex3iC
 spo4QJ5m+UTLBqqhHpQBqGnL9HHKxAe/uDfMAvUBlHkQqIg3juuetJ7SHunpVpLfU2Hk 1g== 
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3bn7h39981-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Oct 2021 06:18:20 -0400
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19CABPdx028386;
        Tue, 12 Oct 2021 10:18:18 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04fra.de.ibm.com with ESMTP id 3bk2qa5dqh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Oct 2021 10:18:18 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19CAICtX59376050
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Oct 2021 10:18:12 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6F735AE055;
        Tue, 12 Oct 2021 10:18:12 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 53340AE053;
        Tue, 12 Oct 2021 10:18:10 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 12 Oct 2021 10:18:10 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH net-next 06/11] net/smc: add v2 format of CLC decline message
Date:   Tue, 12 Oct 2021 12:17:38 +0200
Message-Id: <20211012101743.2282031-7-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211012101743.2282031-1-kgraul@linux.ibm.com>
References: <20211012101743.2282031-1-kgraul@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: geSuORqh1vl9yT6mw_DCbhA8QtqfyeM9
X-Proofpoint-ORIG-GUID: geSuORqh1vl9yT6mw_DCbhA8QtqfyeM9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-12_02,2021-10-12_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 mlxlogscore=999
 suspectscore=0 malwarescore=0 priorityscore=1501 clxscore=1015 bulkscore=0
 phishscore=0 impostorscore=0 lowpriorityscore=0 adultscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110120058
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

