Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6C696AB568
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 05:10:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229783AbjCFEKF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Mar 2023 23:10:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229663AbjCFEJP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Mar 2023 23:09:15 -0500
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01F2FC67E;
        Sun,  5 Mar 2023 20:08:57 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R451e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046059;MF=alibuda@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0Vd8X437_1678075728;
Received: from j66a10360.sqa.eu95.tbsite.net(mailfrom:alibuda@linux.alibaba.com fp:SMTPD_---0Vd8X437_1678075728)
          by smtp.aliyun-inc.com;
          Mon, 06 Mar 2023 12:08:55 +0800
From:   "D. Wythe" <alibuda@linux.alibaba.com>
To:     kgraul@linux.ibm.com, wenjia@linux.ibm.com, jaka@linux.ibm.com
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: [PATCH net] net/smc: fix fallback failed while sendmsg with fastopen
Date:   Mon,  6 Mar 2023 12:08:48 +0800
Message-Id: <1678075728-18812-1-git-send-email-alibuda@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "D. Wythe" <alibuda@linux.alibaba.com>

Before determining whether the msg has unsupported options, it has been
prematurely terminated by the wrong status check.

For the application, the general method of MSG_FASTOPEN likes

fd = socket(...)
/* rather than connect */
sendto(fd, data, len, MSG_FASTOPEN)

Hence, We need to check the flag before state check, because the sock state
here is always SMC_INIT when applications tries MSG_FASTOPEN. Once we
found unsupported options, fallback it to TCP.

Fixes: ee9dfbef02d1 ("net/smc: handle sockopts forcing fallback")
Signed-off-by: D. Wythe <alibuda@linux.alibaba.com>
---
 net/smc/af_smc.c | 26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index b233c94..fd80879 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -2662,24 +2662,30 @@ static int smc_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
 	int rc = -EPIPE;
 
 	smc = smc_sk(sk);
-	lock_sock(sk);
-	if ((sk->sk_state != SMC_ACTIVE) &&
-	    (sk->sk_state != SMC_APPCLOSEWAIT1) &&
-	    (sk->sk_state != SMC_INIT))
-		goto out;
 
+	/* SMC do not support connect with fastopen */
 	if (msg->msg_flags & MSG_FASTOPEN) {
+		rc = -EINVAL;
+		lock_sock(sk);
+		/* not perform connect yet, fallback it */
 		if (sk->sk_state == SMC_INIT && !smc->connect_nonblock) {
 			rc = smc_switch_to_fallback(smc, SMC_CLC_DECL_OPTUNSUPP);
-			if (rc)
-				goto out;
-		} else {
-			rc = -EINVAL;
-			goto out;
+			/*  fallback success */
+			if (rc == 0)
+				goto fallback;	/* with sock lock hold */
 		}
+		release_sock(sk);
+		return rc;
 	}
 
+	lock_sock(sk);
+	if (sk->sk_state != SMC_ACTIVE &&
+	    sk->sk_state != SMC_APPCLOSEWAIT1 &&
+	    sk->sk_state != SMC_INIT)
+		goto out;
+
 	if (smc->use_fallback) {
+fallback:
 		rc = smc->clcsock->ops->sendmsg(smc->clcsock, msg, len);
 	} else {
 		rc = smc_tx_sendmsg(smc, msg, len);
-- 
1.8.3.1

