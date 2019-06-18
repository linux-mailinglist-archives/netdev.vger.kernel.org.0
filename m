Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 904334AA18
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 20:43:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730097AbfFRSnR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 14:43:17 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:52652 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727616AbfFRSnR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 14:43:17 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5IIgs4t104860
        for <netdev@vger.kernel.org>; Tue, 18 Jun 2019 14:43:17 -0400
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2t74wxhhg4-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 18 Jun 2019 14:43:16 -0400
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <jwi@linux.ibm.com>;
        Tue, 18 Jun 2019 19:43:14 +0100
Received: from b06avi18626390.portsmouth.uk.ibm.com (9.149.26.192)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 18 Jun 2019 19:43:11 +0100
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x5IIh2M833816862
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Jun 2019 18:43:02 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 48225A405B;
        Tue, 18 Jun 2019 18:43:10 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0612FA4051;
        Tue, 18 Jun 2019 18:43:10 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 18 Jun 2019 18:43:09 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>
Cc:     <netdev@vger.kernel.org>, <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Stefan Raspl <raspl@linux.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net 1/3] net/af_iucv: remove GFP_DMA restriction for HiperTransport
Date:   Tue, 18 Jun 2019 20:42:59 +0200
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190618184301.96472-1-jwi@linux.ibm.com>
References: <20190618184301.96472-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19061818-0012-0000-0000-0000032A3AF2
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19061818-0013-0000-0000-000021635916
Message-Id: <20190618184301.96472-2-jwi@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-18_08:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906180147
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

af_iucv sockets over z/VM IUCV require that their skbs are allocated
in DMA memory. This restriction doesn't apply to connections over
HiperSockets. So only set this limit for z/VM IUCV sockets, thereby
increasing the likelihood that the large (and linear!) allocations for
HiperTransport messages succeed.

Fixes: 3881ac441f64 ("af_iucv: add HiperSockets transport")
Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
Reviewed-by: Ursula Braun <ubraun@linux.ibm.com>
Reviewed-by: Hendrik Brueckner <brueckner@linux.ibm.com>
---
 net/iucv/af_iucv.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/iucv/af_iucv.c b/net/iucv/af_iucv.c
index 36eb8d1d9128..2ee68d2d4693 100644
--- a/net/iucv/af_iucv.c
+++ b/net/iucv/af_iucv.c
@@ -588,7 +588,6 @@ static struct sock *iucv_sock_alloc(struct socket *sock, int proto, gfp_t prio,
 
 	sk->sk_destruct = iucv_sock_destruct;
 	sk->sk_sndtimeo = IUCV_CONN_TIMEOUT;
-	sk->sk_allocation = GFP_DMA;
 
 	sock_reset_flag(sk, SOCK_ZAPPED);
 
@@ -782,6 +781,7 @@ static int iucv_sock_bind(struct socket *sock, struct sockaddr *addr,
 		memcpy(iucv->src_user_id, iucv_userid, 8);
 		sk->sk_state = IUCV_BOUND;
 		iucv->transport = AF_IUCV_TRANS_IUCV;
+		sk->sk_allocation |= GFP_DMA;
 		if (!iucv->msglimit)
 			iucv->msglimit = IUCV_QUEUELEN_DEFAULT;
 		goto done_unlock;
@@ -806,6 +806,8 @@ static int iucv_sock_autobind(struct sock *sk)
 		return -EPROTO;
 
 	memcpy(iucv->src_user_id, iucv_userid, 8);
+	iucv->transport = AF_IUCV_TRANS_IUCV;
+	sk->sk_allocation |= GFP_DMA;
 
 	write_lock_bh(&iucv_sk_list.lock);
 	__iucv_auto_name(iucv);
@@ -1781,6 +1783,8 @@ static int iucv_callback_connreq(struct iucv_path *path,
 
 	niucv = iucv_sk(nsk);
 	iucv_sock_init(nsk, sk);
+	niucv->transport = AF_IUCV_TRANS_IUCV;
+	nsk->sk_allocation |= GFP_DMA;
 
 	/* Set the new iucv_sock */
 	memcpy(niucv->dst_name, ipuser + 8, 8);
-- 
2.17.1

