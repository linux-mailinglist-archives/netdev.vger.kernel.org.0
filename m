Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C9C42C2F3A
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 18:51:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404085AbgKXRvM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 12:51:12 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:8232 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2404038AbgKXRvM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Nov 2020 12:51:12 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AOHVHg6183288;
        Tue, 24 Nov 2020 12:51:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=Y0Si9ld4jINnabZQldllY7S5e+r9HyrnF/BM5Yj7/7A=;
 b=W5FWeysztburYGJsLTvXipTgXMsZvqz7W+JE1xF4LAOZxQjWVCA/+BxeKaUvpyUiN3Ur
 l1iaQfEaQvMEJJVw2cVoU8qTaWb9RMnsY7FvPmrOCHnjMLZemx+Juq6MkiyUos3jWziH
 W8ThxYbcH5uxW5VN88WpMKKEAYX20yjo4iYlkddSRY5bQUARZYwmzmC9Xd1dcKXZrA7D
 /uSy7rMS07v2iupWrxSJeZY/RPX/81G8PRj88Lb43YLFlD4imXTj2wa9zrwd+dJTKAzX
 GzVZT5kpCzC9Sc2weCW0bXlz4iHVqnFsONAAuIjkHofifXpAlY7xunzc+G+3RNK90kCi 3g== 
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3513uwevsk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 Nov 2020 12:51:08 -0500
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0AOHgLlc003336;
        Tue, 24 Nov 2020 17:51:06 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04ams.nl.ibm.com with ESMTP id 34xth8kqg9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 Nov 2020 17:51:06 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0AOHp4ZL54002112
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Nov 2020 17:51:04 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EEEB6A405B;
        Tue, 24 Nov 2020 17:51:03 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B8082A406B;
        Tue, 24 Nov 2020 17:51:03 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 24 Nov 2020 17:51:03 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Heiko Carstens <hca@linux.ibm.com>,
        Stefan Raspl <raspl@linux.ibm.com>, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: [PATCH net-next v5 02/14] net/smc: Use active link of the connection
Date:   Tue, 24 Nov 2020 18:50:35 +0100
Message-Id: <20201124175047.56949-3-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201124175047.56949-1-kgraul@linux.ibm.com>
References: <20201124175047.56949-1-kgraul@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-24_05:2020-11-24,2020-11-24 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 priorityscore=1501 lowpriorityscore=0 bulkscore=0 spamscore=0 phishscore=0
 mlxscore=0 mlxlogscore=999 clxscore=1015 impostorscore=0 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011240104
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

