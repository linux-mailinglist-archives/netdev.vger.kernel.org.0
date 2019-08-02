Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65EC37EF97
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 10:48:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404441AbfHBIsL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Aug 2019 04:48:11 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:38302 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2404364AbfHBIsL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Aug 2019 04:48:11 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x728lL2u051832
        for <netdev@vger.kernel.org>; Fri, 2 Aug 2019 04:48:10 -0400
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2u4g83c2j2-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 02 Aug 2019 04:48:09 -0400
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <kgraul@linux.ibm.com>;
        Fri, 2 Aug 2019 09:48:06 +0100
Received: from b06cxnps4075.portsmouth.uk.ibm.com (9.149.109.197)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 2 Aug 2019 09:48:05 +0100
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x728m4oT56688878
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 2 Aug 2019 08:48:04 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 31CC9A4051;
        Fri,  2 Aug 2019 08:48:04 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EA378A404D;
        Fri,  2 Aug 2019 08:48:03 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  2 Aug 2019 08:48:03 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        gor@linux.ibm.com, heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: [PATCH net] net/smc: avoid fallback in case of non-blocking connect
Date:   Fri,  2 Aug 2019 10:47:50 +0200
X-Mailer: git-send-email 2.17.1
X-TM-AS-GCONF: 00
x-cbid: 19080208-0028-0000-0000-0000038A55BD
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19080208-0029-0000-0000-0000244AAD11
Message-Id: <20190802084750.5518-1-kgraul@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-02_04:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908020089
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ursula Braun <ubraun@linux.ibm.com>

FASTOPEN is not possible with SMC. sendmsg() with msg_flag MSG_FASTOPEN
triggers a fallback to TCP if the socket is in state SMC_INIT.
But if a nonblocking connect is already started, fallback to TCP
is no longer possible, even though the socket may still be in state
SMC_INIT.
And if a nonblocking connect is already started, a listen() call
does not make sense.

Reported-by: syzbot+bd8cc73d665590a1fcad@syzkaller.appspotmail.com
Fixes: 50717a37db032 ("net/smc: nonblocking connect rework")
Signed-off-by: Ursula Braun <ubraun@linux.ibm.com>
Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
---
 net/smc/af_smc.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index f5ea09258ab0..5b932583e407 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -263,7 +263,7 @@ static int smc_bind(struct socket *sock, struct sockaddr *uaddr,
 
 	/* Check if socket is already active */
 	rc = -EINVAL;
-	if (sk->sk_state != SMC_INIT)
+	if (sk->sk_state != SMC_INIT || smc->connect_nonblock)
 		goto out_rel;
 
 	smc->clcsock->sk->sk_reuse = sk->sk_reuse;
@@ -1390,7 +1390,8 @@ static int smc_listen(struct socket *sock, int backlog)
 	lock_sock(sk);
 
 	rc = -EINVAL;
-	if ((sk->sk_state != SMC_INIT) && (sk->sk_state != SMC_LISTEN))
+	if ((sk->sk_state != SMC_INIT && sk->sk_state != SMC_LISTEN) ||
+	    smc->connect_nonblock)
 		goto out;
 
 	rc = 0;
@@ -1518,7 +1519,7 @@ static int smc_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
 		goto out;
 
 	if (msg->msg_flags & MSG_FASTOPEN) {
-		if (sk->sk_state == SMC_INIT) {
+		if (sk->sk_state == SMC_INIT && !smc->connect_nonblock) {
 			smc_switch_to_fallback(smc);
 			smc->fallback_rsn = SMC_CLC_DECL_OPTUNSUPP;
 		} else {
-- 
2.21.0

