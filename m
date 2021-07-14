Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7D023C812E
	for <lists+netdev@lfdr.de>; Wed, 14 Jul 2021 11:14:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238852AbhGNJQu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Jul 2021 05:16:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238860AbhGNJQe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Jul 2021 05:16:34 -0400
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0036C0613F0;
        Wed, 14 Jul 2021 02:13:41 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1626254017;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=iuf5ClwKO+MjUIoEMEoCrUif0SaILAPtrItiiLgn3b8=;
        b=mpW58c2HnsNVcwFUiIiEZJov7XwdflvTqkOcVInxJ94B90GkH5k2qmvgJvuw8SpwuveJm+
        bIN1lBqunEDxrYPex9s0gR9eYT616dqO2Ph7QWeo8A8TP/j1vrPkVpii7TLeiWJn3l3mQ+
        dw4ZjxY8Kh8uMxuYTmL+Hgb5PEvXwyw=
From:   Yajun Deng <yajun.deng@linux.dev>
To:     davem@davemloft.net, kuba@kernel.org, gustavoars@kernel.org,
        matthieu.baerts@tessares.net, yajun.deng@linux.dev,
        usuraj35@gmail.com
Cc:     linux-decnet-user@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net: decnet: Fix sleeping inside in af_decnet
Date:   Wed, 14 Jul 2021 17:13:20 +0800
Message-Id: <20210714091320.20718-1-yajun.deng@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: yajun.deng@linux.dev
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The release_sock() is blocking function, it would change the state
after sleeping. use wait_woken() instead.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Yajun Deng <yajun.deng@linux.dev>
---
 net/decnet/af_decnet.c | 27 ++++++++++++---------------
 1 file changed, 12 insertions(+), 15 deletions(-)

diff --git a/net/decnet/af_decnet.c b/net/decnet/af_decnet.c
index 5dbd45dc35ad..dc92a67baea3 100644
--- a/net/decnet/af_decnet.c
+++ b/net/decnet/af_decnet.c
@@ -816,7 +816,7 @@ static int dn_auto_bind(struct socket *sock)
 static int dn_confirm_accept(struct sock *sk, long *timeo, gfp_t allocation)
 {
 	struct dn_scp *scp = DN_SK(sk);
-	DEFINE_WAIT(wait);
+	DEFINE_WAIT_FUNC(wait, woken_wake_function);
 	int err;
 
 	if (scp->state != DN_CR)
@@ -826,11 +826,11 @@ static int dn_confirm_accept(struct sock *sk, long *timeo, gfp_t allocation)
 	scp->segsize_loc = dst_metric_advmss(__sk_dst_get(sk));
 	dn_send_conn_conf(sk, allocation);
 
-	prepare_to_wait(sk_sleep(sk), &wait, TASK_INTERRUPTIBLE);
+	add_wait_queue(sk_sleep(sk), &wait);
 	for(;;) {
 		release_sock(sk);
 		if (scp->state == DN_CC)
-			*timeo = schedule_timeout(*timeo);
+			*timeo = wait_woken(&wait, TASK_INTERRUPTIBLE, *timeo);
 		lock_sock(sk);
 		err = 0;
 		if (scp->state == DN_RUN)
@@ -844,9 +844,8 @@ static int dn_confirm_accept(struct sock *sk, long *timeo, gfp_t allocation)
 		err = -EAGAIN;
 		if (!*timeo)
 			break;
-		prepare_to_wait(sk_sleep(sk), &wait, TASK_INTERRUPTIBLE);
 	}
-	finish_wait(sk_sleep(sk), &wait);
+	remove_wait_queue(sk_sleep(sk), &wait);
 	if (err == 0) {
 		sk->sk_socket->state = SS_CONNECTED;
 	} else if (scp->state != DN_CC) {
@@ -858,7 +857,7 @@ static int dn_confirm_accept(struct sock *sk, long *timeo, gfp_t allocation)
 static int dn_wait_run(struct sock *sk, long *timeo)
 {
 	struct dn_scp *scp = DN_SK(sk);
-	DEFINE_WAIT(wait);
+	DEFINE_WAIT_FUNC(wait, woken_wake_function);
 	int err = 0;
 
 	if (scp->state == DN_RUN)
@@ -867,11 +866,11 @@ static int dn_wait_run(struct sock *sk, long *timeo)
 	if (!*timeo)
 		return -EALREADY;
 
-	prepare_to_wait(sk_sleep(sk), &wait, TASK_INTERRUPTIBLE);
+	add_wait_queue(sk_sleep(sk), &wait);
 	for(;;) {
 		release_sock(sk);
 		if (scp->state == DN_CI || scp->state == DN_CC)
-			*timeo = schedule_timeout(*timeo);
+			*timeo = wait_woken(&wait, TASK_INTERRUPTIBLE, *timeo);
 		lock_sock(sk);
 		err = 0;
 		if (scp->state == DN_RUN)
@@ -885,9 +884,8 @@ static int dn_wait_run(struct sock *sk, long *timeo)
 		err = -ETIMEDOUT;
 		if (!*timeo)
 			break;
-		prepare_to_wait(sk_sleep(sk), &wait, TASK_INTERRUPTIBLE);
 	}
-	finish_wait(sk_sleep(sk), &wait);
+	remove_wait_queue(sk_sleep(sk), &wait);
 out:
 	if (err == 0) {
 		sk->sk_socket->state = SS_CONNECTED;
@@ -1032,16 +1030,16 @@ static void dn_user_copy(struct sk_buff *skb, struct optdata_dn *opt)
 
 static struct sk_buff *dn_wait_for_connect(struct sock *sk, long *timeo)
 {
-	DEFINE_WAIT(wait);
+	DEFINE_WAIT_FUNC(wait, woken_wake_function);
 	struct sk_buff *skb = NULL;
 	int err = 0;
 
-	prepare_to_wait(sk_sleep(sk), &wait, TASK_INTERRUPTIBLE);
+	add_wait_queue(sk_sleep(sk), &wait);
 	for(;;) {
 		release_sock(sk);
 		skb = skb_dequeue(&sk->sk_receive_queue);
 		if (skb == NULL) {
-			*timeo = schedule_timeout(*timeo);
+			*timeo = wait_woken(&wait, TASK_INTERRUPTIBLE, *timeo);
 			skb = skb_dequeue(&sk->sk_receive_queue);
 		}
 		lock_sock(sk);
@@ -1056,9 +1054,8 @@ static struct sk_buff *dn_wait_for_connect(struct sock *sk, long *timeo)
 		err = -EAGAIN;
 		if (!*timeo)
 			break;
-		prepare_to_wait(sk_sleep(sk), &wait, TASK_INTERRUPTIBLE);
 	}
-	finish_wait(sk_sleep(sk), &wait);
+	remove_wait_queue(sk_sleep(sk), &wait);
 
 	return skb == NULL ? ERR_PTR(err) : skb;
 }
-- 
2.32.0

