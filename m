Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1924B56979B
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 03:35:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234889AbiGGBf1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 21:35:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234878AbiGGBfW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 21:35:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E43D2ED58
        for <netdev@vger.kernel.org>; Wed,  6 Jul 2022 18:35:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E1E0F6208B
        for <netdev@vger.kernel.org>; Thu,  7 Jul 2022 01:35:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 523FFC341CE;
        Thu,  7 Jul 2022 01:35:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657157719;
        bh=QSbovaNrg7oDWteVG7XBpM27XCJ6BQnIlSqtJIyUNuc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WCfa+KoNW8RyDMQ4htBAiTTcAI8NxyLTRSPKmzKNTzw7Lhz7u8QkIB5pSJaU3+uhT
         q1I/xb7etmPggSW8wNZAty9Ek55B/NcIT58C+pPvl+ho0Q6hFpOoFegPrncQPYMpLV
         qx4g12aC2/KBzlhapOerl7Bodde63tTTJ89etqGqRc65EGyvEQYXPnLPcq25eVgLfl
         L0/6zexi7F7qFYpZkvLgAwEyVd+VPg3zeayN1nNnVQKAc2qXNr1+H3OtMmkfjv6HyM
         uTwGEgVo/xxW5m/NYA5JLvO249RRbW7pfVOs7nAbDxLRgzinHZnrnx5PH/0vMPztku
         nNTSFyhHxL7LQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        borisp@nvidia.com, john.fastabend@gmail.com, maximmi@nvidia.com,
        tariqt@nvidia.com, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 6/6] tls: rx: make tls_wait_data() return an recvmsg retcode
Date:   Wed,  6 Jul 2022 18:35:10 -0700
Message-Id: <20220707013510.1372695-7-kuba@kernel.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220707013510.1372695-1-kuba@kernel.org>
References: <20220707013510.1372695-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tls_wait_data() sets the return code as an output parameter
and always returns ctx->recv_pkt on success.

Return the error code directly and let the caller read the skb
from the context. Use positive return code to indicate ctx->recv_pkt
is ready.

While touching the definition of the function rename it.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/tls/tls_sw.c | 53 ++++++++++++++++++++++++------------------------
 1 file changed, 26 insertions(+), 27 deletions(-)

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index 337adab85037..e659be0c1e9c 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -1305,54 +1305,50 @@ int tls_sw_sendpage(struct sock *sk, struct page *page,
 	return ret;
 }
 
-static struct sk_buff *tls_wait_data(struct sock *sk, struct sk_psock *psock,
-				     bool nonblock, long timeo, int *err)
+static int
+tls_rx_rec_wait(struct sock *sk, struct sk_psock *psock, bool nonblock,
+		long timeo)
 {
 	struct tls_context *tls_ctx = tls_get_ctx(sk);
 	struct tls_sw_context_rx *ctx = tls_sw_ctx_rx(tls_ctx);
-	struct sk_buff *skb;
 	DEFINE_WAIT_FUNC(wait, woken_wake_function);
 
-	while (!(skb = ctx->recv_pkt) && sk_psock_queue_empty(psock)) {
-		if (sk->sk_err) {
-			*err = sock_error(sk);
-			return NULL;
-		}
+	while (!ctx->recv_pkt) {
+		if (!sk_psock_queue_empty(psock))
+			return 0;
+
+		if (sk->sk_err)
+			return sock_error(sk);
 
 		if (!skb_queue_empty(&sk->sk_receive_queue)) {
 			__strp_unpause(&ctx->strp);
 			if (ctx->recv_pkt)
-				return ctx->recv_pkt;
+				break;
 		}
 
 		if (sk->sk_shutdown & RCV_SHUTDOWN)
-			return NULL;
+			return 0;
 
 		if (sock_flag(sk, SOCK_DONE))
-			return NULL;
+			return 0;
 
-		if (nonblock || !timeo) {
-			*err = -EAGAIN;
-			return NULL;
-		}
+		if (nonblock || !timeo)
+			return -EAGAIN;
 
 		add_wait_queue(sk_sleep(sk), &wait);
 		sk_set_bit(SOCKWQ_ASYNC_WAITDATA, sk);
 		sk_wait_event(sk, &timeo,
-			      ctx->recv_pkt != skb ||
-			      !sk_psock_queue_empty(psock),
+			      ctx->recv_pkt || !sk_psock_queue_empty(psock),
 			      &wait);
 		sk_clear_bit(SOCKWQ_ASYNC_WAITDATA, sk);
 		remove_wait_queue(sk_sleep(sk), &wait);
 
 		/* Handle signals */
-		if (signal_pending(current)) {
-			*err = sock_intr_errno(timeo);
-			return NULL;
-		}
+		if (signal_pending(current))
+			return sock_intr_errno(timeo);
 	}
 
-	return skb;
+	return 1;
 }
 
 static int tls_setup_from_iter(struct iov_iter *from,
@@ -1812,8 +1808,8 @@ int tls_sw_recvmsg(struct sock *sk,
 		struct tls_decrypt_arg darg = {};
 		int to_decrypt, chunk;
 
-		skb = tls_wait_data(sk, psock, flags & MSG_DONTWAIT, timeo, &err);
-		if (!skb) {
+		err = tls_rx_rec_wait(sk, psock, flags & MSG_DONTWAIT, timeo);
+		if (err <= 0) {
 			if (psock) {
 				chunk = sk_msg_recvmsg(sk, psock, msg, len,
 						       flags);
@@ -1823,6 +1819,7 @@ int tls_sw_recvmsg(struct sock *sk,
 			goto recv_end;
 		}
 
+		skb = ctx->recv_pkt;
 		rxm = strp_msg(skb);
 		tlm = tls_msg(skb);
 
@@ -1989,11 +1986,13 @@ ssize_t tls_sw_splice_read(struct socket *sock,  loff_t *ppos,
 	} else {
 		struct tls_decrypt_arg darg = {};
 
-		skb = tls_wait_data(sk, NULL, flags & SPLICE_F_NONBLOCK, timeo,
-				    &err);
-		if (!skb)
+		err = tls_rx_rec_wait(sk, NULL, flags & SPLICE_F_NONBLOCK,
+				      timeo);
+		if (err <= 0)
 			goto splice_read_end;
 
+		skb = ctx->recv_pkt;
+
 		err = decrypt_skb_update(sk, skb, NULL, &darg);
 		if (err < 0) {
 			tls_err_abort(sk, -EBADMSG);
-- 
2.36.1

