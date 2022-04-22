Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A642450B273
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 09:59:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1445409AbiDVIAn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 04:00:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1445374AbiDVIAB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 04:00:01 -0400
Received: from out30-56.freemail.mail.aliyun.com (out30-56.freemail.mail.aliyun.com [115.124.30.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6286527F9;
        Fri, 22 Apr 2022 00:56:30 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04357;MF=guwen@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0VAlrUe4_1650614187;
Received: from e02h04404.eu6sqa(mailfrom:guwen@linux.alibaba.com fp:SMTPD_---0VAlrUe4_1650614187)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 22 Apr 2022 15:56:28 +0800
From:   Wen Gu <guwen@linux.alibaba.com>
To:     kgraul@linux.ibm.com, davem@davemloft.net, kuba@kernel.org
Cc:     linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net 1/2] net/smc: Only save the original clcsock callback functions
Date:   Fri, 22 Apr 2022 15:56:18 +0800
Message-Id: <1650614179-11529-2-git-send-email-guwen@linux.alibaba.com>
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

Both listen and fallback process will save the current clcsock
callback functions and establish new ones. But if both of them
happen, the saved callback functions will be overwritten.

So this patch introduces some helpers to ensure that only save
the original callback functions of clcsock.

Fixes: 341adeec9ada ("net/smc: Forward wakeup to smc socket waitqueue after fallback")
Signed-off-by: Wen Gu <guwen@linux.alibaba.com>
---
 net/smc/af_smc.c    | 55 +++++++++++++++++++++++++++++++++++------------------
 net/smc/smc.h       | 29 ++++++++++++++++++++++++++++
 net/smc/smc_close.c |  3 ++-
 3 files changed, 67 insertions(+), 20 deletions(-)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index 14ddc40..7ee356f 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -373,6 +373,7 @@ static struct sock *smc_sock_alloc(struct net *net, struct socket *sock,
 	sk->sk_prot->hash(sk);
 	sk_refcnt_debug_inc(sk);
 	mutex_init(&smc->clcsock_release_lock);
+	smc_init_saved_callbacks(smc);
 
 	return sk;
 }
@@ -782,9 +783,24 @@ static void smc_fback_error_report(struct sock *clcsk)
 	smc_fback_forward_wakeup(smc, clcsk, smc->clcsk_error_report);
 }
 
+static void smc_fback_replace_callbacks(struct smc_sock *smc)
+{
+	struct sock *clcsk = smc->clcsock->sk;
+
+	clcsk->sk_user_data = (void *)((uintptr_t)smc | SK_USER_DATA_NOCOPY);
+
+	smc_clcsock_replace_cb(&clcsk->sk_state_change, smc_fback_state_change,
+			       &smc->clcsk_state_change);
+	smc_clcsock_replace_cb(&clcsk->sk_data_ready, smc_fback_data_ready,
+			       &smc->clcsk_data_ready);
+	smc_clcsock_replace_cb(&clcsk->sk_write_space, smc_fback_write_space,
+			       &smc->clcsk_write_space);
+	smc_clcsock_replace_cb(&clcsk->sk_error_report, smc_fback_error_report,
+			       &smc->clcsk_error_report);
+}
+
 static int smc_switch_to_fallback(struct smc_sock *smc, int reason_code)
 {
-	struct sock *clcsk;
 	int rc = 0;
 
 	mutex_lock(&smc->clcsock_release_lock);
@@ -792,10 +808,7 @@ static int smc_switch_to_fallback(struct smc_sock *smc, int reason_code)
 		rc = -EBADF;
 		goto out;
 	}
-	clcsk = smc->clcsock->sk;
 
-	if (smc->use_fallback)
-		goto out;
 	smc->use_fallback = true;
 	smc->fallback_rsn = reason_code;
 	smc_stat_fallback(smc);
@@ -810,18 +823,7 @@ static int smc_switch_to_fallback(struct smc_sock *smc, int reason_code)
 		 * in smc sk->sk_wq and they should be woken up
 		 * as clcsock's wait queue is woken up.
 		 */
-		smc->clcsk_state_change = clcsk->sk_state_change;
-		smc->clcsk_data_ready = clcsk->sk_data_ready;
-		smc->clcsk_write_space = clcsk->sk_write_space;
-		smc->clcsk_error_report = clcsk->sk_error_report;
-
-		clcsk->sk_state_change = smc_fback_state_change;
-		clcsk->sk_data_ready = smc_fback_data_ready;
-		clcsk->sk_write_space = smc_fback_write_space;
-		clcsk->sk_error_report = smc_fback_error_report;
-
-		smc->clcsock->sk->sk_user_data =
-			(void *)((uintptr_t)smc | SK_USER_DATA_NOCOPY);
+		smc_fback_replace_callbacks(smc);
 	}
 out:
 	mutex_unlock(&smc->clcsock_release_lock);
@@ -1594,6 +1596,19 @@ static int smc_clcsock_accept(struct smc_sock *lsmc, struct smc_sock **new_smc)
 	 * function; switch it back to the original sk_data_ready function
 	 */
 	new_clcsock->sk->sk_data_ready = lsmc->clcsk_data_ready;
+
+	/* if new clcsock has also inherited the fallback-specific callback
+	 * functions, switch them back to the original ones.
+	 */
+	if (lsmc->use_fallback) {
+		if (lsmc->clcsk_state_change)
+			new_clcsock->sk->sk_state_change = lsmc->clcsk_state_change;
+		if (lsmc->clcsk_write_space)
+			new_clcsock->sk->sk_write_space = lsmc->clcsk_write_space;
+		if (lsmc->clcsk_error_report)
+			new_clcsock->sk->sk_error_report = lsmc->clcsk_error_report;
+	}
+
 	(*new_smc)->clcsock = new_clcsock;
 out:
 	return rc;
@@ -2395,10 +2410,10 @@ static int smc_listen(struct socket *sock, int backlog)
 	/* save original sk_data_ready function and establish
 	 * smc-specific sk_data_ready function
 	 */
-	smc->clcsk_data_ready = smc->clcsock->sk->sk_data_ready;
-	smc->clcsock->sk->sk_data_ready = smc_clcsock_data_ready;
 	smc->clcsock->sk->sk_user_data =
 		(void *)((uintptr_t)smc | SK_USER_DATA_NOCOPY);
+	smc_clcsock_replace_cb(&smc->clcsock->sk->sk_data_ready,
+			       smc_clcsock_data_ready, &smc->clcsk_data_ready);
 
 	/* save original ops */
 	smc->ori_af_ops = inet_csk(smc->clcsock->sk)->icsk_af_ops;
@@ -2413,7 +2428,9 @@ static int smc_listen(struct socket *sock, int backlog)
 
 	rc = kernel_listen(smc->clcsock, backlog);
 	if (rc) {
-		smc->clcsock->sk->sk_data_ready = smc->clcsk_data_ready;
+		smc_clcsock_restore_cb(&smc->clcsock->sk->sk_data_ready,
+				       &smc->clcsk_data_ready);
+		smc->clcsock->sk->sk_user_data = NULL;
 		goto out;
 	}
 	sk->sk_max_ack_backlog = backlog;
diff --git a/net/smc/smc.h b/net/smc/smc.h
index ea06205..5ed765e 100644
--- a/net/smc/smc.h
+++ b/net/smc/smc.h
@@ -288,12 +288,41 @@ static inline struct smc_sock *smc_sk(const struct sock *sk)
 	return (struct smc_sock *)sk;
 }
 
+static inline void smc_init_saved_callbacks(struct smc_sock *smc)
+{
+	smc->clcsk_state_change	= NULL;
+	smc->clcsk_data_ready	= NULL;
+	smc->clcsk_write_space	= NULL;
+	smc->clcsk_error_report	= NULL;
+}
+
 static inline struct smc_sock *smc_clcsock_user_data(const struct sock *clcsk)
 {
 	return (struct smc_sock *)
 	       ((uintptr_t)clcsk->sk_user_data & ~SK_USER_DATA_NOCOPY);
 }
 
+/* save target_cb in saved_cb, and replace target_cb with new_cb */
+static inline void smc_clcsock_replace_cb(void (**target_cb)(struct sock *),
+					  void (*new_cb)(struct sock *),
+					  void (**saved_cb)(struct sock *))
+{
+	/* only save once */
+	if (!*saved_cb)
+		*saved_cb = *target_cb;
+	*target_cb = new_cb;
+}
+
+/* restore target_cb to saved_cb, and reset saved_cb to NULL */
+static inline void smc_clcsock_restore_cb(void (**target_cb)(struct sock *),
+					  void (**saved_cb)(struct sock *))
+{
+	if (!*saved_cb)
+		return;
+	*target_cb = *saved_cb;
+	*saved_cb = NULL;
+}
+
 extern struct workqueue_struct	*smc_hs_wq;	/* wq for handshake work */
 extern struct workqueue_struct	*smc_close_wq;	/* wq for close work */
 
diff --git a/net/smc/smc_close.c b/net/smc/smc_close.c
index 676cb23..7bd1ef5 100644
--- a/net/smc/smc_close.c
+++ b/net/smc/smc_close.c
@@ -214,7 +214,8 @@ int smc_close_active(struct smc_sock *smc)
 		sk->sk_state = SMC_CLOSED;
 		sk->sk_state_change(sk); /* wake up accept */
 		if (smc->clcsock && smc->clcsock->sk) {
-			smc->clcsock->sk->sk_data_ready = smc->clcsk_data_ready;
+			smc_clcsock_restore_cb(&smc->clcsock->sk->sk_data_ready,
+					       &smc->clcsk_data_ready);
 			smc->clcsock->sk->sk_user_data = NULL;
 			rc = kernel_sock_shutdown(smc->clcsock, SHUT_RDWR);
 		}
-- 
1.8.3.1

