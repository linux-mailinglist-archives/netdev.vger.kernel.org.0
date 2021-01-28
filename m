Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAB39307500
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 12:43:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231527AbhA1LmN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 06:42:13 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:31326 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231462AbhA1Ll6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 06:41:58 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10SBVaHL049752;
        Thu, 28 Jan 2021 06:41:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=HgBY0lzqAJW7PwV0iMzNACC7aJ3+keM5Iqz7N2wgfx4=;
 b=j6LczzMWjSR1jZYE7agkWbhZwcU4hVJK/YsqA0mOmzud6N1MZndQtAcv/8aMR2X5X4NS
 sg+8BBqudPUPmDstunCXrFxVrqq/pOnxCi95+s3yXsxxWt33Gi0pTwDC2MwRyyjXzIq7
 nsblZjdR50BcOSos20OpontzQoS4vTXGdI0b4zmGsmSuVDnIaD+NRM8LFH5y8bVjKY+u
 BLxWK7GImYreNQA+MJG3jxwB3fzo9noTURkHm0d3Ei7IOCN2m1zCIMO5Rh+XGZRm2oOL
 56e+rOIuxGCLbk35WFQCQh7l5mNogik7swDXPvtCDqGR/PL7ePsIBI/AIJP4N7ry35F6 HA== 
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36bre47pvp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 28 Jan 2021 06:41:16 -0500
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10SBcK6A012492;
        Thu, 28 Jan 2021 11:41:14 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma02fra.de.ibm.com with ESMTP id 368be8ag25-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 28 Jan 2021 11:41:14 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10SBfBCD50594264
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Jan 2021 11:41:11 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6B48E4C044;
        Thu, 28 Jan 2021 11:41:11 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0E6054C040;
        Thu, 28 Jan 2021 11:41:11 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 28 Jan 2021 11:41:10 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net-next 2/5] net/af_iucv: don't lookup the socket on TX notification
Date:   Thu, 28 Jan 2021 12:41:05 +0100
Message-Id: <20210128114108.39409-3-jwi@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210128114108.39409-1-jwi@linux.ibm.com>
References: <20210128114108.39409-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-28_05:2021-01-27,2021-01-28 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 malwarescore=0 bulkscore=0 clxscore=1015 lowpriorityscore=0
 priorityscore=1501 mlxscore=0 adultscore=0 spamscore=0 phishscore=0
 suspectscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2101280055
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Whoever called iucv_sk(sk)->sk_txnotify() must already know that they're
dealing with an af_iucv socket.

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 net/iucv/af_iucv.c | 15 +++------------
 1 file changed, 3 insertions(+), 12 deletions(-)

diff --git a/net/iucv/af_iucv.c b/net/iucv/af_iucv.c
index 427a1abce0a8..8683b6939f45 100644
--- a/net/iucv/af_iucv.c
+++ b/net/iucv/af_iucv.c
@@ -2134,23 +2134,14 @@ static int afiucv_hs_rcv(struct sk_buff *skb, struct net_device *dev,
 static void afiucv_hs_callback_txnotify(struct sk_buff *skb,
 					enum iucv_tx_notify n)
 {
-	struct sock *isk = skb->sk;
-	struct sock *sk = NULL;
-	struct iucv_sock *iucv = NULL;
+	struct iucv_sock *iucv = iucv_sk(skb->sk);
+	struct sock *sk = skb->sk;
 	struct sk_buff_head *list;
 	struct sk_buff *list_skb;
 	struct sk_buff *nskb;
 	unsigned long flags;
 
-	read_lock_irqsave(&iucv_sk_list.lock, flags);
-	sk_for_each(sk, &iucv_sk_list.head)
-		if (sk == isk) {
-			iucv = iucv_sk(sk);
-			break;
-		}
-	read_unlock_irqrestore(&iucv_sk_list.lock, flags);
-
-	if (!iucv || sock_flag(sk, SOCK_ZAPPED))
+	if (sock_flag(sk, SOCK_ZAPPED))
 		return;
 
 	list = &iucv->send_skb_q;
-- 
2.17.1

