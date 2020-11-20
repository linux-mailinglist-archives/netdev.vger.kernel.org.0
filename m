Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAE482BA58B
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 10:11:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727370AbgKTJJy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 04:09:54 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:47536 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727076AbgKTJJu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 04:09:50 -0500
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AK92sDU083705;
        Fri, 20 Nov 2020 04:09:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=W4KBMexQPjUWj2cBMMYs4RkAMaVyQzVmG3fLg/yUmug=;
 b=E48yPKLqcEccwdugiWHgkdty02nHXOg60IKI1AcOTvUfhuewCmYY/I/iJoZ8Pkbcc3h1
 LTcWNTyY0DtS5G23Qde3ez/WV3VpXIPsAHe2u6hersDMczuuJskMOQhkaFf4heD0vQzq
 rU/Gn07mB7fi17t9O2N6CG72WLXjB6cAu5oOyOcwxJppBDSvsGN1umBzAgFm046Pf057
 vVf1bLhg1yxwOa+XKdzoibRwDvLMOfGwXZXbntukHZjmhuf+nGDZPLzFumeqLSsy26L4
 +EuWCV8F+KnRnTR9JHdOsmmHcZUxfFUVK7TvwB3heZeQjtasyKpn9ApB0jcrfbGxcikB hw== 
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34x5v1fnvn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 20 Nov 2020 04:09:45 -0500
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0AK993oI002018;
        Fri, 20 Nov 2020 09:09:44 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03fra.de.ibm.com with ESMTP id 34t6v835h9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 20 Nov 2020 09:09:43 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0AK99fWK852612
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 Nov 2020 09:09:41 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 01A954203F;
        Fri, 20 Nov 2020 09:09:41 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A734342045;
        Fri, 20 Nov 2020 09:09:40 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 20 Nov 2020 09:09:40 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net 2/4] s390/qeth: make af_iucv TX notification call more robust
Date:   Fri, 20 Nov 2020 10:09:37 +0100
Message-Id: <20201120090939.101406-3-jwi@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201120090939.101406-1-jwi@linux.ibm.com>
References: <20201120090939.101406-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-20_03:2020-11-19,2020-11-20 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 impostorscore=0
 clxscore=1015 malwarescore=0 phishscore=0 spamscore=0 mlxscore=0
 lowpriorityscore=0 adultscore=0 suspectscore=0 mlxlogscore=999
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011200056
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Calling into socket code is ugly already, at least check whether we are
dealing with the expected sk_family. Only looking at skb->protocol is
bound to cause troubles (consider eg. af_packet).

Fixes: b333293058aa ("qeth: add support for af_iucv HiperSockets transport")
Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/s390/net/qeth_core_main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index 93c9b30ab17a..715f440bdc7c 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -33,6 +33,7 @@
 
 #include <net/iucv/af_iucv.h>
 #include <net/dsfield.h>
+#include <net/sock.h>
 
 #include <asm/ebcdic.h>
 #include <asm/chpid.h>
@@ -1405,7 +1406,7 @@ static void qeth_notify_skbs(struct qeth_qdio_out_q *q,
 	skb_queue_walk(&buf->skb_list, skb) {
 		QETH_CARD_TEXT_(q->card, 5, "skbn%d", notification);
 		QETH_CARD_TEXT_(q->card, 5, "%lx", (long) skb);
-		if (skb->protocol == htons(ETH_P_AF_IUCV) && skb->sk)
+		if (skb->sk && skb->sk->sk_family == PF_IUCV)
 			iucv_sk(skb->sk)->sk_txnotify(skb, notification);
 	}
 }
-- 
2.17.1

