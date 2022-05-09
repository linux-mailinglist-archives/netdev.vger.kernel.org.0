Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D03C651FBF1
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 14:03:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233603AbiEIMCq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 08:02:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233583AbiEIMCn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 08:02:43 -0400
Received: from out30-42.freemail.mail.aliyun.com (out30-42.freemail.mail.aliyun.com [115.124.30.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA46B29807;
        Mon,  9 May 2022 04:58:48 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R401e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=guangguan.wang@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0VClEr-M_1652097526;
Received: from localhost.localdomain(mailfrom:guangguan.wang@linux.alibaba.com fp:SMTPD_---0VClEr-M_1652097526)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 09 May 2022 19:58:46 +0800
From:   Guangguan Wang <guangguan.wang@linux.alibaba.com>
To:     kgraul@linux.ibm.com, davem@davemloft.net, kuba@kernel.org
Cc:     linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net 2/2] net/smc: align the connect behaviour with TCP
Date:   Mon,  9 May 2022 19:58:37 +0800
Message-Id: <20220509115837.94911-3-guangguan.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
In-Reply-To: <20220509115837.94911-1-guangguan.wang@linux.alibaba.com>
References: <20220509115837.94911-1-guangguan.wang@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Connect with O_NONBLOCK will not be completed immediately
and returns -EINPROGRESS. It is possible to use selector/poll
for completion by selecting the socket for writing. After select
indicates writability, a second connect function call will return
0 to indicate connected successfully as TCP does, but smc returns
-EISCONN. Use socket state for smc to indicate connect state, which
can help smc aligning the connect behaviour with TCP.

Signed-off-by: Guangguan Wang <guangguan.wang@linux.alibaba.com>
---
 net/smc/af_smc.c | 53 ++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 49 insertions(+), 4 deletions(-)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index fce16b9d6e1a..45f9f7c6e776 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -1544,9 +1544,32 @@ static int smc_connect(struct socket *sock, struct sockaddr *addr,
 		goto out_err;
 
 	lock_sock(sk);
+	switch (sock->state) {
+	default:
+		rc = -EINVAL;
+		goto out;
+	case SS_CONNECTED:
+		rc = sk->sk_state == SMC_ACTIVE ? -EISCONN : -EINVAL;
+		goto out;
+	case SS_CONNECTING:
+		if (sk->sk_state == SMC_ACTIVE) {
+			sock->state = SS_CONNECTED;
+			rc = 0;
+			goto out;
+		}
+		break;
+	case SS_UNCONNECTED:
+		sock->state = SS_CONNECTING;
+		break;
+	}
+
 	switch (sk->sk_state) {
 	default:
 		goto out;
+	case SMC_CLOSED:
+		rc = sock_error(sk) ? : -ECONNABORTED;
+		sock->state = SS_UNCONNECTED;
+		goto out;
 	case SMC_ACTIVE:
 		rc = -EISCONN;
 		goto out;
@@ -1565,18 +1588,22 @@ static int smc_connect(struct socket *sock, struct sockaddr *addr,
 		goto out;
 
 	sock_hold(&smc->sk); /* sock put in passive closing */
-	if (smc->use_fallback)
+	if (smc->use_fallback) {
+		sock->state = SS_CONNECTED;
 		goto out;
+	}
 	if (flags & O_NONBLOCK) {
 		if (queue_work(smc_hs_wq, &smc->connect_work))
 			smc->connect_nonblock = 1;
 		rc = -EINPROGRESS;
 	} else {
 		rc = __smc_connect(smc);
-		if (rc < 0)
+		if (rc < 0) {
 			goto out;
-		else
+		} else {
 			rc = 0; /* success cases including fallback */
+			sock->state = SS_CONNECTED;
+		}
 	}
 
 out:
@@ -1693,6 +1720,7 @@ struct sock *smc_accept_dequeue(struct sock *parent,
 		}
 		if (new_sock) {
 			sock_graft(new_sk, new_sock);
+			new_sock->state = SS_CONNECTED;
 			if (isk->use_fallback) {
 				smc_sk(new_sk)->clcsock->file = new_sock->file;
 				isk->clcsock->file->private_data = isk->clcsock;
@@ -2424,7 +2452,7 @@ static int smc_listen(struct socket *sock, int backlog)
 
 	rc = -EINVAL;
 	if ((sk->sk_state != SMC_INIT && sk->sk_state != SMC_LISTEN) ||
-	    smc->connect_nonblock)
+	    smc->connect_nonblock || sock->state != SS_UNCONNECTED)
 		goto out;
 
 	rc = 0;
@@ -2716,6 +2744,17 @@ static int smc_shutdown(struct socket *sock, int how)
 
 	lock_sock(sk);
 
+	if (sock->state == SS_CONNECTING) {
+		if (sk->sk_state == SMC_ACTIVE)
+			sock->state = SS_CONNECTED;
+		else if (sk->sk_state == SMC_PEERCLOSEWAIT1 ||
+			 sk->sk_state == SMC_PEERCLOSEWAIT2 ||
+			 sk->sk_state == SMC_APPCLOSEWAIT1 ||
+			 sk->sk_state == SMC_APPCLOSEWAIT2 ||
+			 sk->sk_state == SMC_APPFINCLOSEWAIT)
+			sock->state = SS_DISCONNECTING;
+	}
+
 	rc = -ENOTCONN;
 	if ((sk->sk_state != SMC_ACTIVE) &&
 	    (sk->sk_state != SMC_PEERCLOSEWAIT1) &&
@@ -2729,6 +2768,7 @@ static int smc_shutdown(struct socket *sock, int how)
 		sk->sk_shutdown = smc->clcsock->sk->sk_shutdown;
 		if (sk->sk_shutdown == SHUTDOWN_MASK) {
 			sk->sk_state = SMC_CLOSED;
+			sk->sk_socket->state = SS_UNCONNECTED;
 			sock_put(sk);
 		}
 		goto out;
@@ -2754,6 +2794,10 @@ static int smc_shutdown(struct socket *sock, int how)
 	/* map sock_shutdown_cmd constants to sk_shutdown value range */
 	sk->sk_shutdown |= how + 1;
 
+	if (sk->sk_state == SMC_CLOSED)
+		sock->state = SS_UNCONNECTED;
+	else
+		sock->state = SS_DISCONNECTING;
 out:
 	release_sock(sk);
 	return rc ? rc : rc1;
@@ -3139,6 +3183,7 @@ static int __smc_create(struct net *net, struct socket *sock, int protocol,
 
 	rc = -ENOBUFS;
 	sock->ops = &smc_sock_ops;
+	sock->state = SS_UNCONNECTED;
 	sk = smc_sock_alloc(net, sock, protocol);
 	if (!sk)
 		goto out;
-- 
2.24.3 (Apple Git-128)

