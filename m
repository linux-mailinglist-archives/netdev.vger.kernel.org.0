Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43A825831A
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 15:07:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726462AbfF0NHE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 09:07:04 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:2530 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726059AbfF0NHE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 09:07:04 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5RD6cPc140180
        for <netdev@vger.kernel.org>; Thu, 27 Jun 2019 09:07:03 -0400
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2tcx3cs3sd-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 27 Jun 2019 09:06:54 -0400
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <kgraul@linux.ibm.com>;
        Thu, 27 Jun 2019 14:05:19 +0100
Received: from b06avi18878370.portsmouth.uk.ibm.com (9.149.26.194)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 27 Jun 2019 14:05:17 +0100
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x5RD5GTo26673416
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Jun 2019 13:05:16 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E310AA405B;
        Thu, 27 Jun 2019 13:05:15 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9F812A405C;
        Thu, 27 Jun 2019 13:05:15 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 27 Jun 2019 13:05:15 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        gor@linux.ibm.com, heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: [PATCH] net/smc: common release code for non-accepted sockets
Date:   Thu, 27 Jun 2019 15:04:52 +0200
X-Mailer: git-send-email 2.17.1
X-TM-AS-GCONF: 00
x-cbid: 19062713-0028-0000-0000-0000037E182D
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19062713-0029-0000-0000-0000243E425B
Message-Id: <20190627130452.15408-1-kgraul@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-27_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=791 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906270153
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ursula Braun <ubraun@linux.ibm.com>

There are common steps when releasing an accepted or unaccepted socket.
Move this code into a common routine.

Signed-off-by: Ursula Braun <ubraun@linux.ibm.com>
Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
---
 net/smc/af_smc.c | 73 +++++++++++++++++++++---------------------------
 1 file changed, 32 insertions(+), 41 deletions(-)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index 7621ec2f539c..302e355f2ebc 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -123,30 +123,11 @@ struct proto smc_proto6 = {
 };
 EXPORT_SYMBOL_GPL(smc_proto6);
 
-static int smc_release(struct socket *sock)
+static int __smc_release(struct smc_sock *smc)
 {
-	struct sock *sk = sock->sk;
-	struct smc_sock *smc;
+	struct sock *sk = &smc->sk;
 	int rc = 0;
 
-	if (!sk)
-		goto out;
-
-	smc = smc_sk(sk);
-
-	/* cleanup for a dangling non-blocking connect */
-	if (smc->connect_nonblock && sk->sk_state == SMC_INIT)
-		tcp_abort(smc->clcsock->sk, ECONNABORTED);
-	flush_work(&smc->connect_work);
-
-	if (sk->sk_state == SMC_LISTEN)
-		/* smc_close_non_accepted() is called and acquires
-		 * sock lock for child sockets again
-		 */
-		lock_sock_nested(sk, SINGLE_DEPTH_NESTING);
-	else
-		lock_sock(sk);
-
 	if (!smc->use_fallback) {
 		rc = smc_close_active(smc);
 		sock_set_flag(sk, SOCK_DEAD);
@@ -174,6 +155,35 @@ static int smc_release(struct socket *sock)
 			smc_conn_free(&smc->conn);
 	}
 
+	return rc;
+}
+
+static int smc_release(struct socket *sock)
+{
+	struct sock *sk = sock->sk;
+	struct smc_sock *smc;
+	int rc = 0;
+
+	if (!sk)
+		goto out;
+
+	smc = smc_sk(sk);
+
+	/* cleanup for a dangling non-blocking connect */
+	if (smc->connect_nonblock && sk->sk_state == SMC_INIT)
+		tcp_abort(smc->clcsock->sk, ECONNABORTED);
+	flush_work(&smc->connect_work);
+
+	if (sk->sk_state == SMC_LISTEN)
+		/* smc_close_non_accepted() is called and acquires
+		 * sock lock for child sockets again
+		 */
+		lock_sock_nested(sk, SINGLE_DEPTH_NESTING);
+	else
+		lock_sock(sk);
+
+	rc = __smc_release(smc);
+
 	/* detach socket */
 	sock_orphan(sk);
 	sock->sk = NULL;
@@ -964,26 +974,7 @@ void smc_close_non_accepted(struct sock *sk)
 	if (!sk->sk_lingertime)
 		/* wait for peer closing */
 		sk->sk_lingertime = SMC_MAX_STREAM_WAIT_TIMEOUT;
-	if (!smc->use_fallback) {
-		smc_close_active(smc);
-		sock_set_flag(sk, SOCK_DEAD);
-		sk->sk_shutdown |= SHUTDOWN_MASK;
-	}
-	sk->sk_prot->unhash(sk);
-	if (smc->clcsock) {
-		struct socket *tcp;
-
-		tcp = smc->clcsock;
-		smc->clcsock = NULL;
-		sock_release(tcp);
-	}
-	if (smc->use_fallback) {
-		sock_put(sk); /* passive closing */
-		sk->sk_state = SMC_CLOSED;
-	} else {
-		if (sk->sk_state == SMC_CLOSED)
-			smc_conn_free(&smc->conn);
-	}
+	__smc_release(smc);
 	release_sock(sk);
 	sock_put(sk); /* final sock_put */
 }
-- 
2.21.0

