Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CC1C50B26B
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 09:59:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1445408AbiDVIAm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 04:00:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1445412AbiDVIAB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 04:00:01 -0400
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24247527FC;
        Fri, 22 Apr 2022 00:56:30 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=guwen@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0VAlrUeF_1650614188;
Received: from e02h04404.eu6sqa(mailfrom:guwen@linux.alibaba.com fp:SMTPD_---0VAlrUeF_1650614188)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 22 Apr 2022 15:56:28 +0800
From:   Wen Gu <guwen@linux.alibaba.com>
To:     kgraul@linux.ibm.com, davem@davemloft.net, kuba@kernel.org
Cc:     linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net 2/2] net/smc: Fix slab-out-of-bounds issue in fallback
Date:   Fri, 22 Apr 2022 15:56:19 +0800
Message-Id: <1650614179-11529-3-git-send-email-guwen@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1650614179-11529-1-git-send-email-guwen@linux.alibaba.com>
References: <1650614179-11529-1-git-send-email-guwen@linux.alibaba.com>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot reported a slab-out-of-bounds/use-after-free issue,
which was caused by accessing an already freed smc sock in
fallback-specific callback functions of clcsock.

This patch fixes the issue by restoring fallback-specific
callback functions to original ones and resetting clcsock
sk_user_data to NULL before freeing smc sock.

Meanwhile, this patch introduces sk_callback_lock to make
the access and assignment to sk_user_data mutually exclusive.

Reported-by: syzbot+b425899ed22c6943e00b@syzkaller.appspotmail.com
Fixes: 341adeec9ada ("net/smc: Forward wakeup to smc socket waitqueue after fallback")
Link: https://lore.kernel.org/r/00000000000013ca8105d7ae3ada@google.com/
Signed-off-by: Wen Gu <guwen@linux.alibaba.com>
---
 net/smc/af_smc.c    | 80 ++++++++++++++++++++++++++++++++++++++---------------
 net/smc/smc_close.c |  2 ++
 2 files changed, 59 insertions(+), 23 deletions(-)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index 7ee356f..6eb3421 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -243,11 +243,27 @@ struct proto smc_proto6 = {
 };
 EXPORT_SYMBOL_GPL(smc_proto6);
 
+static void smc_fback_restore_callbacks(struct smc_sock *smc)
+{
+	struct sock *clcsk = smc->clcsock->sk;
+
+	write_lock_bh(&clcsk->sk_callback_lock);
+	clcsk->sk_user_data = NULL;
+
+	smc_clcsock_restore_cb(&clcsk->sk_state_change, &smc->clcsk_state_change);
+	smc_clcsock_restore_cb(&clcsk->sk_data_ready, &smc->clcsk_data_ready);
+	smc_clcsock_restore_cb(&clcsk->sk_write_space, &smc->clcsk_write_space);
+	smc_clcsock_restore_cb(&clcsk->sk_error_report, &smc->clcsk_error_report);
+
+	write_unlock_bh(&clcsk->sk_callback_lock);
+}
+
 static void smc_restore_fallback_changes(struct smc_sock *smc)
 {
 	if (smc->clcsock->file) { /* non-accepted sockets have no file yet */
 		smc->clcsock->file->private_data = smc->sk.sk_socket;
 		smc->clcsock->file = NULL;
+		smc_fback_restore_callbacks(smc);
 	}
 }
 
@@ -745,48 +761,57 @@ static void smc_fback_forward_wakeup(struct smc_sock *smc, struct sock *clcsk,
 
 static void smc_fback_state_change(struct sock *clcsk)
 {
-	struct smc_sock *smc =
-		smc_clcsock_user_data(clcsk);
+	struct smc_sock *smc;
 
-	if (!smc)
-		return;
-	smc_fback_forward_wakeup(smc, clcsk, smc->clcsk_state_change);
+	read_lock_bh(&clcsk->sk_callback_lock);
+	smc = smc_clcsock_user_data(clcsk);
+	if (smc)
+		smc_fback_forward_wakeup(smc, clcsk,
+					 smc->clcsk_state_change);
+	read_unlock_bh(&clcsk->sk_callback_lock);
 }
 
 static void smc_fback_data_ready(struct sock *clcsk)
 {
-	struct smc_sock *smc =
-		smc_clcsock_user_data(clcsk);
+	struct smc_sock *smc;
 
-	if (!smc)
-		return;
-	smc_fback_forward_wakeup(smc, clcsk, smc->clcsk_data_ready);
+	read_lock_bh(&clcsk->sk_callback_lock);
+	smc = smc_clcsock_user_data(clcsk);
+	if (smc)
+		smc_fback_forward_wakeup(smc, clcsk,
+					 smc->clcsk_data_ready);
+	read_unlock_bh(&clcsk->sk_callback_lock);
 }
 
 static void smc_fback_write_space(struct sock *clcsk)
 {
-	struct smc_sock *smc =
-		smc_clcsock_user_data(clcsk);
+	struct smc_sock *smc;
 
-	if (!smc)
-		return;
-	smc_fback_forward_wakeup(smc, clcsk, smc->clcsk_write_space);
+	read_lock_bh(&clcsk->sk_callback_lock);
+	smc = smc_clcsock_user_data(clcsk);
+	if (smc)
+		smc_fback_forward_wakeup(smc, clcsk,
+					 smc->clcsk_write_space);
+	read_unlock_bh(&clcsk->sk_callback_lock);
 }
 
 static void smc_fback_error_report(struct sock *clcsk)
 {
-	struct smc_sock *smc =
-		smc_clcsock_user_data(clcsk);
+	struct smc_sock *smc;
 
-	if (!smc)
-		return;
-	smc_fback_forward_wakeup(smc, clcsk, smc->clcsk_error_report);
+	read_lock_bh(&clcsk->sk_callback_lock);
+	smc = smc_clcsock_user_data(clcsk);
+	if (smc)
+		smc_fback_forward_wakeup(smc, clcsk,
+					 smc->clcsk_error_report);
+	read_unlock_bh(&clcsk->sk_callback_lock);
 }
 
 static void smc_fback_replace_callbacks(struct smc_sock *smc)
 {
 	struct sock *clcsk = smc->clcsock->sk;
 
+	write_lock_bh(&clcsk->sk_callback_lock);
 	clcsk->sk_user_data = (void *)((uintptr_t)smc | SK_USER_DATA_NOCOPY);
 
 	smc_clcsock_replace_cb(&clcsk->sk_state_change, smc_fback_state_change,
@@ -797,6 +822,8 @@ static void smc_fback_replace_callbacks(struct smc_sock *smc)
 			       &smc->clcsk_write_space);
 	smc_clcsock_replace_cb(&clcsk->sk_error_report, smc_fback_error_report,
 			       &smc->clcsk_error_report);
+
+	write_unlock_bh(&clcsk->sk_callback_lock);
 }
 
 static int smc_switch_to_fallback(struct smc_sock *smc, int reason_code)
@@ -2368,17 +2395,20 @@ static void smc_tcp_listen_work(struct work_struct *work)
 
 static void smc_clcsock_data_ready(struct sock *listen_clcsock)
 {
-	struct smc_sock *lsmc =
-		smc_clcsock_user_data(listen_clcsock);
+	struct smc_sock *lsmc;
 
+	read_lock_bh(&listen_clcsock->sk_callback_lock);
+	lsmc = smc_clcsock_user_data(listen_clcsock);
 	if (!lsmc)
-		return;
+		goto out;
 	lsmc->clcsk_data_ready(listen_clcsock);
 	if (lsmc->sk.sk_state == SMC_LISTEN) {
 		sock_hold(&lsmc->sk); /* sock_put in smc_tcp_listen_work() */
 		if (!queue_work(smc_tcp_ls_wq, &lsmc->tcp_listen_work))
 			sock_put(&lsmc->sk);
 	}
+out:
+	read_unlock_bh(&listen_clcsock->sk_callback_lock);
 }
 
 static int smc_listen(struct socket *sock, int backlog)
@@ -2410,10 +2440,12 @@ static int smc_listen(struct socket *sock, int backlog)
 	/* save original sk_data_ready function and establish
 	 * smc-specific sk_data_ready function
 	 */
+	write_lock_bh(&smc->clcsock->sk->sk_callback_lock);
 	smc->clcsock->sk->sk_user_data =
 		(void *)((uintptr_t)smc | SK_USER_DATA_NOCOPY);
 	smc_clcsock_replace_cb(&smc->clcsock->sk->sk_data_ready,
 			       smc_clcsock_data_ready, &smc->clcsk_data_ready);
+	write_unlock_bh(&smc->clcsock->sk->sk_callback_lock);
 
 	/* save original ops */
 	smc->ori_af_ops = inet_csk(smc->clcsock->sk)->icsk_af_ops;
@@ -2428,9 +2460,11 @@ static int smc_listen(struct socket *sock, int backlog)
 
 	rc = kernel_listen(smc->clcsock, backlog);
 	if (rc) {
+		write_lock_bh(&smc->clcsock->sk->sk_callback_lock);
 		smc_clcsock_restore_cb(&smc->clcsock->sk->sk_data_ready,
 				       &smc->clcsk_data_ready);
 		smc->clcsock->sk->sk_user_data = NULL;
+		write_unlock_bh(&smc->clcsock->sk->sk_callback_lock);
 		goto out;
 	}
 	sk->sk_max_ack_backlog = backlog;
diff --git a/net/smc/smc_close.c b/net/smc/smc_close.c
index 7bd1ef5..31db743 100644
--- a/net/smc/smc_close.c
+++ b/net/smc/smc_close.c
@@ -214,9 +214,11 @@ int smc_close_active(struct smc_sock *smc)
 		sk->sk_state = SMC_CLOSED;
 		sk->sk_state_change(sk); /* wake up accept */
 		if (smc->clcsock && smc->clcsock->sk) {
+			write_lock_bh(&smc->clcsock->sk->sk_callback_lock);
 			smc_clcsock_restore_cb(&smc->clcsock->sk->sk_data_ready,
 					       &smc->clcsk_data_ready);
 			smc->clcsock->sk->sk_user_data = NULL;
+			write_unlock_bh(&smc->clcsock->sk->sk_callback_lock);
 			rc = kernel_sock_shutdown(smc->clcsock, SHUT_RDWR);
 		}
 		smc_close_cleanup_listen(sk);
-- 
1.8.3.1

