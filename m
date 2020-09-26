Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 232F5279883
	for <lists+netdev@lfdr.de>; Sat, 26 Sep 2020 12:46:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729178AbgIZKpF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Sep 2020 06:45:05 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:31606 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727001AbgIZKoz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Sep 2020 06:44:55 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08QAVMOU063285;
        Sat, 26 Sep 2020 06:44:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=IXzN/4Hxk3wLI8l3WmC0dJarSV2hHW8+Bzx2nrMkZ74=;
 b=X8nBmBzHvx49jDw27FaDMZ7dFu02K+xJVnP0cBKlER0mTek9dPboTCXxvvRfQLRs9vew
 hUn1uLSCXPJO7eqfBoHyAYc/VbfnP/c2Q8N1bM8P4t+IikjAxysEZpinzcBSCaGeTQzI
 IiMYWf4yJ+kyco+HLQDSIu0yO2sXM1CVxZGHUaOAYaG6E34s0r4wDTqfAiacY5/Om2HU
 sMwyQCuMe3ljBP6WBD9aJPnLMIZv/sbrEo5Pp5DbT30DXcZKwkAyyzbJn6rPRT+PT2l1
 X+NQfJH4JnkUcG5IiZBjSTEb+BCxGMgX0Yv1u95z54mKCczavDdJhu2v1jIpK5LskSOg 7w== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33t3p6geaq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 26 Sep 2020 06:44:51 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08QAhEKq002923;
        Sat, 26 Sep 2020 10:44:49 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03ams.nl.ibm.com with ESMTP id 33sw98097b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 26 Sep 2020 10:44:49 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08QAikPg18874824
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 26 Sep 2020 10:44:46 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EB27FA4054;
        Sat, 26 Sep 2020 10:44:45 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B1637A405B;
        Sat, 26 Sep 2020 10:44:45 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Sat, 26 Sep 2020 10:44:45 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: [PATCH net-next 04/14] net/smc: split CLC confirm/accept data to be sent
Date:   Sat, 26 Sep 2020 12:44:22 +0200
Message-Id: <20200926104432.74293-5-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200926104432.74293-1-kgraul@linux.ibm.com>
References: <20200926104432.74293-1-kgraul@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-26_06:2020-09-24,2020-09-26 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 bulkscore=0
 adultscore=0 clxscore=1015 spamscore=0 malwarescore=0 mlxlogscore=999
 phishscore=0 lowpriorityscore=0 priorityscore=1501 impostorscore=0
 suspectscore=1 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009260091
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ursula Braun <ubraun@linux.ibm.com>

When sending CLC confirm and CLC accept, separate the trailing
part of the message from the initial part (to be prepared for
future first contact extension).

Signed-off-by: Ursula Braun <ubraun@linux.ibm.com>
Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
---
 net/smc/smc_clc.c | 21 ++++++++++++++-------
 net/smc/smc_clc.h |  6 +-----
 2 files changed, 15 insertions(+), 12 deletions(-)

diff --git a/net/smc/smc_clc.c b/net/smc/smc_clc.c
index 85b41c125368..8ad0bbaac846 100644
--- a/net/smc/smc_clc.c
+++ b/net/smc/smc_clc.c
@@ -505,8 +505,10 @@ static int smc_clc_send_confirm_accept(struct smc_sock *smc,
 				       int first_contact)
 {
 	struct smc_connection *conn = &smc->conn;
+	struct smc_clc_msg_trail trl;
+	struct kvec vec[2];
 	struct msghdr msg;
-	struct kvec vec;
+	int i;
 
 	/* send SMC Confirm CLC msg */
 	clc->hdr.version = SMC_V1;		/* SMC version */
@@ -523,7 +525,7 @@ static int smc_clc_send_confirm_accept(struct smc_sock *smc,
 		clc->d0.dmbe_size = conn->rmbe_size_short;
 		clc->d0.dmbe_idx = 0;
 		memcpy(&clc->d0.linkid, conn->lgr->id, SMC_LGR_ID_SIZE);
-		memcpy(clc->d0.smcd_trl.eyecatcher, SMCD_EYECATCHER,
+		memcpy(trl.eyecatcher, SMCD_EYECATCHER,
 		       sizeof(SMCD_EYECATCHER));
 	} else {
 		struct smc_link *link = conn->lnk;
@@ -556,14 +558,19 @@ static int smc_clc_send_confirm_accept(struct smc_sock *smc,
 		clc->r0.rmb_dma_addr = cpu_to_be64((u64)sg_dma_address
 				(conn->rmb_desc->sgt[link->link_idx].sgl));
 		hton24(clc->r0.psn, link->psn_initial);
-		memcpy(clc->r0.smcr_trl.eyecatcher, SMC_EYECATCHER,
-		       sizeof(SMC_EYECATCHER));
+		memcpy(trl.eyecatcher, SMC_EYECATCHER, sizeof(SMC_EYECATCHER));
 	}
 
 	memset(&msg, 0, sizeof(msg));
-	vec.iov_base = clc;
-	vec.iov_len = ntohs(clc->hdr.length);
-	return kernel_sendmsg(smc->clcsock, &msg, &vec, 1,
+	i = 0;
+	vec[i].iov_base = clc;
+	vec[i++].iov_len = (clc->hdr.typev1 == SMC_TYPE_D ?
+			    SMCD_CLC_ACCEPT_CONFIRM_LEN :
+			    SMCR_CLC_ACCEPT_CONFIRM_LEN) -
+			   sizeof(trl);
+	vec[i].iov_base = &trl;
+	vec[i++].iov_len = sizeof(trl);
+	return kernel_sendmsg(smc->clcsock, &msg, vec, 1,
 			      ntohs(clc->hdr.length));
 }
 
diff --git a/net/smc/smc_clc.h b/net/smc/smc_clc.h
index 5f9fda15f7ff..c4644d14beae 100644
--- a/net/smc/smc_clc.h
+++ b/net/smc/smc_clc.h
@@ -134,8 +134,6 @@ struct smcr_clc_msg_accept_confirm {	/* SMCR accept/confirm */
 	__be64 rmb_dma_addr;	/* RMB virtual address */
 	u8 reserved2;
 	u8 psn[3];		/* packet sequence number */
-	struct smc_clc_msg_trail smcr_trl;
-				/* eye catcher "SMCR" EBCDIC */
 } __packed;
 
 struct smcd_clc_msg_accept_confirm {	/* SMCD accept/confirm */
@@ -150,10 +148,8 @@ struct smcd_clc_msg_accept_confirm {	/* SMCD accept/confirm */
 	   dmbe_size : 4;
 #endif
 	u16 reserved4;
-	u32 linkid;		/* Link identifier */
+	__be32 linkid;		/* Link identifier */
 	u32 reserved5[3];
-	struct smc_clc_msg_trail smcd_trl;
-				/* eye catcher "SMCD" EBCDIC */
 } __packed;
 
 struct smc_clc_msg_accept_confirm {	/* clc accept / confirm message */
-- 
2.17.1

