Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 382B0264A42
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 18:49:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727037AbgIJQty (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 12:49:54 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:59370 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726801AbgIJQtV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 12:49:21 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08AGi8Hg120876;
        Thu, 10 Sep 2020 12:49:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=6jX6VqPUBvoDZTS2Yu5LDt+OMT6AkNTfOhgRTJd3trA=;
 b=GvX+dpPi7YeUI2ROfvtjUdVFRQVzL2JnlZcW2srQ+6gm+uVho96whQEyE+mTsCz3TYDO
 Cy06PGX+eq6em99GX1vRR+G7fym8sE5tPU6C0XpxulBLLHn8AQURFJHCU/+M2Y0F59oI
 sPDybV2qpJaK06e7qNd3JTise+nasJIaO8TXLCInKZ2Yoqayfg135GKPfnSsPCMeL70v
 oDNupY+/b5LdfpM63vcyzrbGjHxLu5MYK8NQiEm7UvAD6s1xkcPf3p9e0dinI+jtkELt
 X7jhilEzTN+V3Ieed6RnFwzpYy8E+Fx2iS+q+rCjTi+prO6E0OwLxm4BuJgzw+kYvJxt VA== 
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33fqx1g404-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Sep 2020 12:49:04 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08AGkekr017189;
        Thu, 10 Sep 2020 16:49:02 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04ams.nl.ibm.com with ESMTP id 33c2a8e9qv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Sep 2020 16:49:02 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08AGmx3t33358134
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Sep 2020 16:48:59 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 456CC4C044;
        Thu, 10 Sep 2020 16:48:59 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 158404C04A;
        Thu, 10 Sep 2020 16:48:59 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 10 Sep 2020 16:48:59 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: [PATCH net-next 01/10] net/smc: reduce active tcp_listen workers
Date:   Thu, 10 Sep 2020 18:48:20 +0200
Message-Id: <20200910164829.65426-2-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200910164829.65426-1-kgraul@linux.ibm.com>
References: <20200910164829.65426-1-kgraul@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-10_05:2020-09-10,2020-09-10 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 priorityscore=1501 impostorscore=0 lowpriorityscore=0 bulkscore=0
 malwarescore=0 suspectscore=1 mlxlogscore=701 clxscore=1015 spamscore=0
 mlxscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009100153
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ursula Braun <ubraun@linux.ibm.com>

SMC starts a separate tcp_listen worker for every SMC socket in
state SMC_LISTEN, and can accept an incoming connection request only,
if this worker is really running and waiting in kernel_accept(). But
the number of running workers is limited.
This patch reworks the listening SMC code and starts a tcp_listen worker
after the SYN-ACK handshake on the internal clc-socket only.

Suggested-by: Karsten Graul <kgraul@linux.ibm.com>
Signed-off-by: Ursula Braun <ubraun@linux.ibm.com>
Reviewed-by: Guvenc Gulce <guvenc@linux.ibm.com>
Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
---
 net/smc/af_smc.c    | 38 +++++++++++++++++++++++++++++++-------
 net/smc/smc.h       |  2 ++
 net/smc/smc_close.c |  7 +++----
 3 files changed, 36 insertions(+), 11 deletions(-)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index e7649bbc2b87..7212de4da71d 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -940,10 +940,10 @@ static int smc_clcsock_accept(struct smc_sock *lsmc, struct smc_sock **new_smc)
 
 	mutex_lock(&lsmc->clcsock_release_lock);
 	if (lsmc->clcsock)
-		rc = kernel_accept(lsmc->clcsock, &new_clcsock, 0);
+		rc = kernel_accept(lsmc->clcsock, &new_clcsock, SOCK_NONBLOCK);
 	mutex_unlock(&lsmc->clcsock_release_lock);
 	lock_sock(lsk);
-	if  (rc < 0)
+	if  (rc < 0 && rc != -EAGAIN)
 		lsk->sk_err = -rc;
 	if (rc < 0 || lsk->sk_state == SMC_CLOSED) {
 		new_sk->sk_prot->unhash(new_sk);
@@ -956,6 +956,10 @@ static int smc_clcsock_accept(struct smc_sock *lsmc, struct smc_sock **new_smc)
 		goto out;
 	}
 
+	/* new clcsock has inherited the smc listen-specific sk_data_ready
+	 * function; switch it back to the original sk_data_ready function
+	 */
+	new_clcsock->sk->sk_data_ready = lsmc->clcsk_data_ready;
 	(*new_smc)->clcsock = new_clcsock;
 out:
 	return rc;
@@ -1406,7 +1410,7 @@ static void smc_tcp_listen_work(struct work_struct *work)
 	lock_sock(lsk);
 	while (lsk->sk_state == SMC_LISTEN) {
 		rc = smc_clcsock_accept(lsmc, &new_smc);
-		if (rc)
+		if (rc) /* clcsock accept queue empty or error */
 			goto out;
 		if (!new_smc)
 			continue;
@@ -1426,7 +1430,23 @@ static void smc_tcp_listen_work(struct work_struct *work)
 
 out:
 	release_sock(lsk);
-	sock_put(&lsmc->sk); /* sock_hold in smc_listen */
+	sock_put(&lsmc->sk); /* sock_hold in smc_clcsock_data_ready() */
+}
+
+static void smc_clcsock_data_ready(struct sock *listen_clcsock)
+{
+	struct smc_sock *lsmc;
+
+	lsmc = (struct smc_sock *)
+	       ((uintptr_t)listen_clcsock->sk_user_data & ~SK_USER_DATA_NOCOPY);
+	if (!lsmc)
+		return;
+	lsmc->clcsk_data_ready(listen_clcsock);
+	if (lsmc->sk.sk_state == SMC_LISTEN) {
+		sock_hold(&lsmc->sk); /* sock_put in smc_tcp_listen_work() */
+		if (!schedule_work(&lsmc->tcp_listen_work))
+			sock_put(&lsmc->sk);
+	}
 }
 
 static int smc_listen(struct socket *sock, int backlog)
@@ -1455,15 +1475,19 @@ static int smc_listen(struct socket *sock, int backlog)
 	if (!smc->use_fallback)
 		tcp_sk(smc->clcsock->sk)->syn_smc = 1;
 
+	/* save original sk_data_ready function and establish
+	 * smc-specific sk_data_ready function
+	 */
+	smc->clcsk_data_ready = smc->clcsock->sk->sk_data_ready;
+	smc->clcsock->sk->sk_data_ready = smc_clcsock_data_ready;
+	smc->clcsock->sk->sk_user_data =
+		(void *)((uintptr_t)smc | SK_USER_DATA_NOCOPY);
 	rc = kernel_listen(smc->clcsock, backlog);
 	if (rc)
 		goto out;
 	sk->sk_max_ack_backlog = backlog;
 	sk->sk_ack_backlog = 0;
 	sk->sk_state = SMC_LISTEN;
-	sock_hold(sk); /* sock_hold in tcp_listen_worker */
-	if (!schedule_work(&smc->tcp_listen_work))
-		sock_put(sk);
 
 out:
 	release_sock(sk);
diff --git a/net/smc/smc.h b/net/smc/smc.h
index 6f1c42da7a4c..f38144f83f54 100644
--- a/net/smc/smc.h
+++ b/net/smc/smc.h
@@ -201,6 +201,8 @@ struct smc_connection {
 struct smc_sock {				/* smc sock container */
 	struct sock		sk;
 	struct socket		*clcsock;	/* internal tcp socket */
+	void			(*clcsk_data_ready)(struct sock *sk);
+						/* original data_ready fct. **/
 	struct smc_connection	conn;		/* smc connection */
 	struct smc_sock		*listen_smc;	/* listen parent */
 	struct work_struct	connect_work;	/* handle non-blocking connect*/
diff --git a/net/smc/smc_close.c b/net/smc/smc_close.c
index 0e7409e469c0..10d05a6d34fc 100644
--- a/net/smc/smc_close.c
+++ b/net/smc/smc_close.c
@@ -208,12 +208,11 @@ int smc_close_active(struct smc_sock *smc)
 		break;
 	case SMC_LISTEN:
 		sk->sk_state = SMC_CLOSED;
+		smc->clcsock->sk->sk_data_ready = smc->clcsk_data_ready;
+		smc->clcsock->sk->sk_user_data = NULL;
 		sk->sk_state_change(sk); /* wake up accept */
-		if (smc->clcsock && smc->clcsock->sk) {
+		if (smc->clcsock && smc->clcsock->sk)
 			rc = kernel_sock_shutdown(smc->clcsock, SHUT_RDWR);
-			/* wake up kernel_accept of smc_tcp_listen_worker */
-			smc->clcsock->sk->sk_data_ready(smc->clcsock->sk);
-		}
 		smc_close_cleanup_listen(sk);
 		release_sock(sk);
 		flush_work(&smc->tcp_listen_work);
-- 
2.17.1

