Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 189E54C2F99
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 16:26:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236269AbiBXP1O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 10:27:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236366AbiBXP1G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 10:27:06 -0500
Received: from out199-10.us.a.mail.aliyun.com (out199-10.us.a.mail.aliyun.com [47.90.199.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 556991BE4DD;
        Thu, 24 Feb 2022 07:26:23 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=alibuda@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0V5OWGQA_1645716379;
Received: from localhost(mailfrom:alibuda@linux.alibaba.com fp:SMTPD_---0V5OWGQA_1645716379)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 24 Feb 2022 23:26:19 +0800
From:   "D. Wythe" <alibuda@linux.alibaba.com>
To:     kgraul@linux.ibm.com
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: [PATCH net] net/smc: fix connection leak
Date:   Thu, 24 Feb 2022 23:26:19 +0800
Message-Id: <1645716379-30924-1-git-send-email-alibuda@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "D. Wythe" <alibuda@linux.alibaba.com>

There's a potential leak issue under following execution sequence :

smc_release  				smc_connect_work
if (sk->sk_state == SMC_INIT)
					send_clc_confirim
	tcp_abort();
					...
					sk.sk_state = SMC_ACTIVE
smc_close_active
switch(sk->sk_state) {
...
case SMC_ACTIVE:
	smc_close_final()
	// then wait peer closed

Unfortunately, tcp_abort() may discard CLC CONFIRM messages that are
still in the tcp send buffer, in which case our connection token cannot
be delivered to the server side, which means that we cannot get a
passive close message at all. Therefore, it is impossible for the to be
disconnected at all.

This patch tries a very simple way to avoid this issue, once the state
has changed to SMC_ACTIVE after tcp_abort(), we can actively abort the
smc connection, considering that the state is SMC_INIT before
tcp_abort(), abandoning the complete disconnection process should not
cause too much problem.

In fact, this problem may exist as long as the CLC CONFIRM message is
not received by the server. Whether a timer should be added after
smc_close_final() needs to be discussed in the future. But even so, this
patch provides a faster release for connection in above case, it should
also be valuable.

Fixes: 39f41f367b08 ("net/smc: common release code for non-accepted sockets")
Signed-off-by: D. Wythe <alibuda@linux.alibaba.com>
---
 net/smc/af_smc.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index 0b13bb2..3a590de 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -269,7 +269,7 @@ static int smc_release(struct socket *sock)
 {
 	struct sock *sk = sock->sk;
 	struct smc_sock *smc;
-	int rc = 0;
+	int old_state, rc = 0;
 
 	if (!sk)
 		goto out;
@@ -277,8 +277,10 @@ static int smc_release(struct socket *sock)
 	sock_hold(sk); /* sock_put below */
 	smc = smc_sk(sk);
 
+	old_state = sk->sk_state;
+
 	/* cleanup for a dangling non-blocking connect */
-	if (smc->connect_nonblock && sk->sk_state == SMC_INIT)
+	if (smc->connect_nonblock && old_state == SMC_INIT)
 		tcp_abort(smc->clcsock->sk, ECONNABORTED);
 
 	if (cancel_work_sync(&smc->connect_work))
@@ -292,6 +294,10 @@ static int smc_release(struct socket *sock)
 	else
 		lock_sock(sk);
 
+	if (old_state == SMC_INIT && sk->sk_state == SMC_ACTIVE &&
+	    !smc->use_fallback)
+		smc_close_active_abort(smc);
+
 	rc = __smc_release(smc);
 
 	/* detach socket */
-- 
1.8.3.1

