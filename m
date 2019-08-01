Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B40B7E4D1
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 23:36:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389193AbfHAVgW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 17:36:22 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:38988 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389188AbfHAVgW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Aug 2019 17:36:22 -0400
Received: by mail-qk1-f194.google.com with SMTP id w190so53240988qkc.6
        for <netdev@vger.kernel.org>; Thu, 01 Aug 2019 14:36:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZafVAoqQAObiI2zFtd1RBARZ5gXPI/lNXv66jSumIps=;
        b=kbaCkkr/Omp9npGmtWT0VC8NYb816muo3mxBuaQiIk1AbHMwjA+gEVvVKaGVhRgvwj
         6+eofxE15PK3APm9EHbET8KzBO/fRSmRDBi1/SxxZqmRIVZU3DYO7vMc6YeHpy8wXdVk
         i30/CSuN2p+S0SjEfRgc23EkNC1+oAVkZPxQftZ3bkl5+avbBgV3Xx20CNBVWT5Mqq0a
         /hz/ToA4yqM74NiTxiQ7jJQlHgM1PxlEYyRnHDBYW4RdSzm7Xl7rkhAB0/OzgAlK/b0I
         zWfaTl+Wxyxyz0eTFVYSVWHxrrHSlFZQiMvCYdJ4//IMzNQDls8T7WOaeCftDXcuZuk2
         xNRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZafVAoqQAObiI2zFtd1RBARZ5gXPI/lNXv66jSumIps=;
        b=bJKsOmpJjwiy+WNzx/SILe+fjHygIO9vwJovL4SHR7L3ef5YmLFMjmvM6ELsWjrsZw
         JgcewABoBa7lGkpCeHlAHU8/HYpwXvk2Ap8/O0iDdWzDyexD+8Qim+BcEQPz1Aq5tMUs
         pnKlYesjWcEyl+dIUJXJuhICnBut8woThaXwYlh1V/PKGt9Ri5ZGNikQNtK2igDUhNY7
         SAmTwdRBjSz6z3sqqzw+ai/tuuIUVrlLNXrfoC9BFz+UmLlCUUFOpj0/SE3FtBaX0aT/
         MEtWcRuhk3+cKPl9Qa0qtxVR1XGUjp5vM7WkdE+E+RIs02ZbutTJ86cgWPOtiI5T3+kX
         S4MA==
X-Gm-Message-State: APjAAAUiYjUa0yhL+AI1ls4CVrwkn2j9Km+Urms8HKUTDo5KQzJdYozw
        LDq1ryc388XAwsM6g6/p4Vs3qQ==
X-Google-Smtp-Source: APXvYqx7ZNiPhe/xOGTWlN/g8EKGJhBCwPZebG67yTgvoxtNPrLtpLyx2JivyRmJm+Aw+hRt7MHh9Q==
X-Received: by 2002:a37:dcc2:: with SMTP id v185mr24368240qki.481.1564695381074;
        Thu, 01 Aug 2019 14:36:21 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id j19sm28746216qtq.94.2019.08.01.14.36.19
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 01 Aug 2019 14:36:20 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        edumazet@google.com, davejwatson@fb.com, borisp@mellanox.com,
        aviadye@mellanox.com, john.fastabend@gmail.com,
        daniel@iogearbox.net, Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: [PATCH net 1/2] net/tls: partially revert fix transition through disconnect with close
Date:   Thu,  1 Aug 2019 14:36:01 -0700
Message-Id: <20190801213602.19634-1-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Looks like we were slightly overzealous with the shutdown()
cleanup. Even though the sock->sk_state can reach CLOSED again,
socket->state will not got back to SS_UNCONNECTED once
connections is ESTABLISHED. Meaning we will see EISCONN if
we try to reconnect, and EINVAL if we try to listen.

Only listen sockets can be shutdown() and reused, but since
ESTABLISHED sockets can never be re-connected() or used for
listen() we don't need to try to clean up the ULP state early.

Fixes: 32857cf57f92 ("net/tls: fix transition through disconnect with close")
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
---
 Documentation/networking/tls-offload.rst |  6 ---
 include/net/tls.h                        |  2 -
 net/tls/tls_main.c                       | 55 ------------------------
 3 files changed, 63 deletions(-)

diff --git a/Documentation/networking/tls-offload.rst b/Documentation/networking/tls-offload.rst
index 2d9f9ebf4117..b70b70dc4524 100644
--- a/Documentation/networking/tls-offload.rst
+++ b/Documentation/networking/tls-offload.rst
@@ -524,9 +524,3 @@ Redirects leak clear text
 
 In the RX direction, if segment has already been decrypted by the device
 and it gets redirected or mirrored - clear text will be transmitted out.
-
-shutdown() doesn't clear TLS state
-----------------------------------
-
-shutdown() system call allows for a TLS socket to be reused as a different
-connection. Offload doesn't currently handle that.
diff --git a/include/net/tls.h b/include/net/tls.h
index 9e425ac2de45..41b2d41bb1b8 100644
--- a/include/net/tls.h
+++ b/include/net/tls.h
@@ -290,8 +290,6 @@ struct tls_context {
 
 	struct list_head list;
 	refcount_t refcount;
-
-	struct work_struct gc;
 };
 
 enum tls_offload_ctx_dir {
diff --git a/net/tls/tls_main.c b/net/tls/tls_main.c
index f208f8455ef2..9cbbae606ced 100644
--- a/net/tls/tls_main.c
+++ b/net/tls/tls_main.c
@@ -261,33 +261,6 @@ void tls_ctx_free(struct tls_context *ctx)
 	kfree(ctx);
 }
 
-static void tls_ctx_free_deferred(struct work_struct *gc)
-{
-	struct tls_context *ctx = container_of(gc, struct tls_context, gc);
-
-	/* Ensure any remaining work items are completed. The sk will
-	 * already have lost its tls_ctx reference by the time we get
-	 * here so no xmit operation will actually be performed.
-	 */
-	if (ctx->tx_conf == TLS_SW) {
-		tls_sw_cancel_work_tx(ctx);
-		tls_sw_free_ctx_tx(ctx);
-	}
-
-	if (ctx->rx_conf == TLS_SW) {
-		tls_sw_strparser_done(ctx);
-		tls_sw_free_ctx_rx(ctx);
-	}
-
-	tls_ctx_free(ctx);
-}
-
-static void tls_ctx_free_wq(struct tls_context *ctx)
-{
-	INIT_WORK(&ctx->gc, tls_ctx_free_deferred);
-	schedule_work(&ctx->gc);
-}
-
 static void tls_sk_proto_cleanup(struct sock *sk,
 				 struct tls_context *ctx, long timeo)
 {
@@ -315,29 +288,6 @@ static void tls_sk_proto_cleanup(struct sock *sk,
 #endif
 }
 
-static void tls_sk_proto_unhash(struct sock *sk)
-{
-	struct inet_connection_sock *icsk = inet_csk(sk);
-	long timeo = sock_sndtimeo(sk, 0);
-	struct tls_context *ctx;
-
-	if (unlikely(!icsk->icsk_ulp_data)) {
-		if (sk->sk_prot->unhash)
-			sk->sk_prot->unhash(sk);
-	}
-
-	ctx = tls_get_ctx(sk);
-	tls_sk_proto_cleanup(sk, ctx, timeo);
-	write_lock_bh(&sk->sk_callback_lock);
-	icsk->icsk_ulp_data = NULL;
-	sk->sk_prot = ctx->sk_proto;
-	write_unlock_bh(&sk->sk_callback_lock);
-
-	if (ctx->sk_proto->unhash)
-		ctx->sk_proto->unhash(sk);
-	tls_ctx_free_wq(ctx);
-}
-
 static void tls_sk_proto_close(struct sock *sk, long timeout)
 {
 	struct inet_connection_sock *icsk = inet_csk(sk);
@@ -786,7 +736,6 @@ static void build_protos(struct proto prot[TLS_NUM_CONFIG][TLS_NUM_CONFIG],
 	prot[TLS_BASE][TLS_BASE].setsockopt	= tls_setsockopt;
 	prot[TLS_BASE][TLS_BASE].getsockopt	= tls_getsockopt;
 	prot[TLS_BASE][TLS_BASE].close		= tls_sk_proto_close;
-	prot[TLS_BASE][TLS_BASE].unhash		= tls_sk_proto_unhash;
 
 	prot[TLS_SW][TLS_BASE] = prot[TLS_BASE][TLS_BASE];
 	prot[TLS_SW][TLS_BASE].sendmsg		= tls_sw_sendmsg;
@@ -804,20 +753,16 @@ static void build_protos(struct proto prot[TLS_NUM_CONFIG][TLS_NUM_CONFIG],
 
 #ifdef CONFIG_TLS_DEVICE
 	prot[TLS_HW][TLS_BASE] = prot[TLS_BASE][TLS_BASE];
-	prot[TLS_HW][TLS_BASE].unhash		= base->unhash;
 	prot[TLS_HW][TLS_BASE].sendmsg		= tls_device_sendmsg;
 	prot[TLS_HW][TLS_BASE].sendpage		= tls_device_sendpage;
 
 	prot[TLS_HW][TLS_SW] = prot[TLS_BASE][TLS_SW];
-	prot[TLS_HW][TLS_SW].unhash		= base->unhash;
 	prot[TLS_HW][TLS_SW].sendmsg		= tls_device_sendmsg;
 	prot[TLS_HW][TLS_SW].sendpage		= tls_device_sendpage;
 
 	prot[TLS_BASE][TLS_HW] = prot[TLS_BASE][TLS_SW];
-	prot[TLS_BASE][TLS_HW].unhash		= base->unhash;
 
 	prot[TLS_SW][TLS_HW] = prot[TLS_SW][TLS_SW];
-	prot[TLS_SW][TLS_HW].unhash		= base->unhash;
 
 	prot[TLS_HW][TLS_HW] = prot[TLS_HW][TLS_SW];
 #endif
-- 
2.21.0

