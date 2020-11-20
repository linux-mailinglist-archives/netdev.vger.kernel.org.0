Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DECC2BA70C
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 11:07:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727850AbgKTKHJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 05:07:09 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:34852 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727137AbgKTKHI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 05:07:08 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AKA2A6g160105;
        Fri, 20 Nov 2020 05:07:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id; s=pp1;
 bh=ceNSdD8BsGwIi2MityEclqQHO4eg8Omuo9lv4TCw5lw=;
 b=HnernEPUTwLdJ5CsCZpjRdyxN1ZRdOXR6ytocYvMAnHGbTMN5o7YCjxodpQFBxvt0N0g
 qhMVCjHjdcGk+wrw4Rk32O+ANveh20ApIwI4PEY4wNSsG/HSNi0k0PIcnquIHxHIuO7B
 csqGN3LZrMT2h1QW3a//tIDX2Shpiw+iBhD3SoGaT6Gb6jqiZ29CEJj1sQQ6RzNYtMlH
 bxOqosaZxiKtJ8nwW+Cr1HNDDKALdRzcAaYBVarb9CHVLD3Qz9eBrtc7xSQqQrLp7GBN
 qEVofGfHU8RgyPmDBqeOvvU92I/Uw3jCh4x4qsZGY3xxGFipBAqLb7mEXx7NedwOnDx4 Bg== 
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34x9264yvh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 20 Nov 2020 05:07:06 -0500
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0AKA3Y1M032211;
        Fri, 20 Nov 2020 10:07:03 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04fra.de.ibm.com with ESMTP id 34t6v8b68j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 20 Nov 2020 10:07:03 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0AKA709V8192754
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 Nov 2020 10:07:00 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B399CA4059;
        Fri, 20 Nov 2020 10:07:00 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6ED6BA4051;
        Fri, 20 Nov 2020 10:07:00 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 20 Nov 2020 10:07:00 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net] net/af_iucv: set correct sk_protocol for child sockets
Date:   Fri, 20 Nov 2020 11:06:57 +0100
Message-Id: <20201120100657.34407-1-jwi@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-20_04:2020-11-19,2020-11-20 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 spamscore=0
 suspectscore=2 priorityscore=1501 adultscore=0 mlxlogscore=916 bulkscore=0
 lowpriorityscore=0 malwarescore=0 impostorscore=0 clxscore=1015 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011200063
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Child sockets erroneously inherit their parent's sk_type (ie. SOCK_*),
instead of the PF_IUCV protocol that the parent was created with in
iucv_sock_create().

We're currently not using sk->sk_protocol ourselves, so this shouldn't
have much impact (except eg. getting the output in skb_dump() right).

Fixes: eac3731bd04c ("[S390]: Add AF_IUCV socket support")
Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 net/iucv/af_iucv.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/iucv/af_iucv.c b/net/iucv/af_iucv.c
index 047238f01ba6..db7d888914fa 100644
--- a/net/iucv/af_iucv.c
+++ b/net/iucv/af_iucv.c
@@ -1645,7 +1645,7 @@ static int iucv_callback_connreq(struct iucv_path *path,
 	}
 
 	/* Create the new socket */
-	nsk = iucv_sock_alloc(NULL, sk->sk_type, GFP_ATOMIC, 0);
+	nsk = iucv_sock_alloc(NULL, sk->sk_protocol, GFP_ATOMIC, 0);
 	if (!nsk) {
 		err = pr_iucv->path_sever(path, user_data);
 		iucv_path_free(path);
@@ -1851,7 +1851,7 @@ static int afiucv_hs_callback_syn(struct sock *sk, struct sk_buff *skb)
 		goto out;
 	}
 
-	nsk = iucv_sock_alloc(NULL, sk->sk_type, GFP_ATOMIC, 0);
+	nsk = iucv_sock_alloc(NULL, sk->sk_protocol, GFP_ATOMIC, 0);
 	bh_lock_sock(sk);
 	if ((sk->sk_state != IUCV_LISTEN) ||
 	    sk_acceptq_is_full(sk) ||
-- 
2.17.1

