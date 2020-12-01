Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 049BF2CABAF
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 20:22:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392341AbgLATVq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 14:21:46 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:29304 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727229AbgLATVp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Dec 2020 14:21:45 -0500
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B1J1x9e020512;
        Tue, 1 Dec 2020 14:21:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=Y0Si9ld4jINnabZQldllY7S5e+r9HyrnF/BM5Yj7/7A=;
 b=KErcfziyrJmTZIMGs0c3eHR731NvkUkRZKJgWbXmwYwSF3b6NPIEav6mJe25ew+mx7Kb
 KP5sA/rz75D4oQyQ/+fKttGOO+U5GxdtOCM7Vcngl0yi46g9JDbTk45ELGVrd5CLXrnf
 LWvA/AeIDPiGCZlqCfa5L0+z1y6j1pOFIBaq6qFxBBmFscI44xaIFJ9H4/gf8B/mqmtn
 kDpvJLVZUEIZoIh/xUVtmtLqUYRSO+DMLcthamuSyJQ9tFq3zuxCNshrcNRXpWqPYkTq
 OIxfab+atP2rXX27Eg0KxHQv4eb6UbxtQFzuc4POILFGP3BtCH9S6q31mL0f6GqIACPp ZQ== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 355k18r5rj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 01 Dec 2020 14:21:00 -0500
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0B1JID6b010790;
        Tue, 1 Dec 2020 19:20:59 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma06ams.nl.ibm.com with ESMTP id 354fpda6wa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 01 Dec 2020 19:20:58 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0B1JKuZd53150106
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 1 Dec 2020 19:20:56 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 22DB7AE051;
        Tue,  1 Dec 2020 19:20:56 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DCE97AE053;
        Tue,  1 Dec 2020 19:20:55 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  1 Dec 2020 19:20:55 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Heiko Carstens <hca@linux.ibm.com>,
        Stefan Raspl <raspl@linux.ibm.com>, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: [PATCH net-next v7 02/14] net/smc: Use active link of the connection
Date:   Tue,  1 Dec 2020 20:20:37 +0100
Message-Id: <20201201192049.53517-3-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201201192049.53517-1-kgraul@linux.ibm.com>
References: <20201201192049.53517-1-kgraul@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-12-01_07:2020-11-30,2020-12-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 phishscore=0
 adultscore=0 priorityscore=1501 lowpriorityscore=0 impostorscore=0
 suspectscore=0 bulkscore=0 mlxlogscore=999 clxscore=1015 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012010112
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Guvenc Gulce <guvenc@linux.ibm.com>

Use active link of the connection directly and not
via linkgroup array structure when obtaining link
data of the connection.

Signed-off-by: Guvenc Gulce <guvenc@linux.ibm.com>
Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
---
 net/smc/smc_diag.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/smc/smc_diag.c b/net/smc/smc_diag.c
index f15fca59b4b2..c2225231f679 100644
--- a/net/smc/smc_diag.c
+++ b/net/smc/smc_diag.c
@@ -160,17 +160,17 @@ static int __smc_diag_dump(struct sock *sk, struct sk_buff *skb,
 	    !list_empty(&smc->conn.lgr->list)) {
 		struct smc_diag_lgrinfo linfo = {
 			.role = smc->conn.lgr->role,
-			.lnk[0].ibport = smc->conn.lgr->lnk[0].ibport,
-			.lnk[0].link_id = smc->conn.lgr->lnk[0].link_id,
+			.lnk[0].ibport = smc->conn.lnk->ibport,
+			.lnk[0].link_id = smc->conn.lnk->link_id,
 		};
 
 		memcpy(linfo.lnk[0].ibname,
 		       smc->conn.lgr->lnk[0].smcibdev->ibdev->name,
-		       sizeof(smc->conn.lgr->lnk[0].smcibdev->ibdev->name));
+		       sizeof(smc->conn.lnk->smcibdev->ibdev->name));
 		smc_gid_be16_convert(linfo.lnk[0].gid,
-				     smc->conn.lgr->lnk[0].gid);
+				     smc->conn.lnk->gid);
 		smc_gid_be16_convert(linfo.lnk[0].peer_gid,
-				     smc->conn.lgr->lnk[0].peer_gid);
+				     smc->conn.lnk->peer_gid);
 
 		if (nla_put(skb, SMC_DIAG_LGRINFO, sizeof(linfo), &linfo) < 0)
 			goto errout;
-- 
2.17.1

