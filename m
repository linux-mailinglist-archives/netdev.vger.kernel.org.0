Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C32073B4666
	for <lists+netdev@lfdr.de>; Fri, 25 Jun 2021 17:11:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231449AbhFYPNw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Jun 2021 11:13:52 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:37284 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229971AbhFYPNv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Jun 2021 11:13:51 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15PF3gnw118623;
        Fri, 25 Jun 2021 11:11:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=rZxA2DyIV3OH1ILfmjFJXRaKtne6I9G56ZzOecjtw4M=;
 b=r+XohzSvT+u6vXjnde+PaN+9DR6goMj84Uv4mN169V930T5X/Sbf7tMm8HiggrX5ySk/
 jbFWMww6gnM9f9VljU8sSWU7XewBPjr4Uqetf9RBEnjHGY8vlt5xlDsmynNMBKy5hHg9
 K6GJO1XGtexfbglK5bzp64Pumqjdj3T3Euo8mShsZb97NLvks3/EY6lvcaGFo/mjjwvT
 7Gq/aXv/zODYvXpOyZay08ztUOxbUZEV3buwu0fszqaxHZlQ4Yj69aXfa9EbWrdJCVgg
 Eoi8l/NPpF7D7Oda3yWqYhuIIn4QJ7eGfFwjYNI0kloAb6ydaMicJi+F2JEvKcr+DRyr yA== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 39dg463yfh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 25 Jun 2021 11:11:26 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 15PF7SjQ006850;
        Fri, 25 Jun 2021 15:11:24 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03ams.nl.ibm.com with ESMTP id 399878b3uj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 25 Jun 2021 15:11:24 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 15PFBLOx29622592
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Jun 2021 15:11:21 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 75167A4040;
        Fri, 25 Jun 2021 15:11:21 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3C4B6A405B;
        Fri, 25 Jun 2021 15:11:21 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 25 Jun 2021 15:11:21 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>,
        Guvenc Gulce <guvenc@linux.ibm.com>
Subject: [PATCH net-next] net/smc: Ensure correct state of the socket in send path
Date:   Fri, 25 Jun 2021 17:11:02 +0200
Message-Id: <20210625151102.447198-1-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Ilxk3u6ue_TQUCVt_EO4rSnp2TS1Uash
X-Proofpoint-ORIG-GUID: Ilxk3u6ue_TQUCVt_EO4rSnp2TS1Uash
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-25_05:2021-06-25,2021-06-25 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 lowpriorityscore=0 suspectscore=0 bulkscore=0 mlxscore=0 malwarescore=0
 clxscore=1015 phishscore=0 adultscore=0 mlxlogscore=999 spamscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106250087
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Guvenc Gulce <guvenc@linux.ibm.com>

When smc_sendmsg() is called before the SMC socket initialization has
completed, smc_tx_sendmsg() will access un-initialized fields of the
SMC socket which results in a null-pointer dereference.
Fix this by checking the socket state first in smc_tx_sendmsg().

Fixes: e0e4b8fa5338 ("net/smc: Add SMC statistics support")
Reported-by: syzbot+5dda108b672b54141857@syzkaller.appspotmail.com
Reviewed-by: Karsten Graul <kgraul@linux.ibm.com>
Signed-off-by: Guvenc Gulce <guvenc@linux.ibm.com>
Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
---
 net/smc/smc_tx.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/smc/smc_tx.c b/net/smc/smc_tx.c
index 075c4f4b41cf..289025cd545a 100644
--- a/net/smc/smc_tx.c
+++ b/net/smc/smc_tx.c
@@ -154,6 +154,9 @@ int smc_tx_sendmsg(struct smc_sock *smc, struct msghdr *msg, size_t len)
 		goto out_err;
 	}
 
+	if (sk->sk_state == SMC_INIT)
+		return -ENOTCONN;
+
 	if (len > conn->sndbuf_desc->len)
 		SMC_STAT_RMB_TX_SIZE_SMALL(smc, !conn->lnk);
 
@@ -164,8 +167,6 @@ int smc_tx_sendmsg(struct smc_sock *smc, struct msghdr *msg, size_t len)
 		SMC_STAT_INC(smc, urg_data_cnt);
 
 	while (msg_data_left(msg)) {
-		if (sk->sk_state == SMC_INIT)
-			return -ENOTCONN;
 		if (smc->sk.sk_shutdown & SEND_SHUTDOWN ||
 		    (smc->sk.sk_err == ECONNABORTED) ||
 		    conn->killed)
-- 
2.25.1

