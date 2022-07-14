Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A958B5741EA
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 05:33:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233034AbiGNDd3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 23:33:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232903AbiGNDdV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 23:33:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 964A325E98
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 20:33:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 396AFB822A3
        for <netdev@vger.kernel.org>; Thu, 14 Jul 2022 03:33:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50923C3411E;
        Thu, 14 Jul 2022 03:33:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657769597;
        bh=SdkzJGJJm8cgaqgvkiup30RMYGPWm15GcbHJBLoyXhU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VYv+77U0xwTNJFwS2RNl9+USiD5cmx9zU5pWgwKO4NZU01aAYg9VyjUpCHMyNhEYI
         tpMEEeCyFEILmGXt7qn64wuE7HRoJA+xf0n1JlGrWkHUVl4mY/yc0TnOML08NvzMTU
         ET3deVZOUXh4nJ+YddPwuu7wrOtg35SAgcUf3+x64qc1NiveJo0ac7OjxLHXrWJQpm
         SjfU3OjAErVXxP/d2aShhiuOW1gP7AUTGNYEUD+fG3TSVLFB6CiQYSMWC4TH+jxG1b
         hEI+bI/LCUTUngkPSxQhTmVwj7+9sYPdgDlZon5EHKMo8h2FaKt4fSDpclkpwj0LQv
         K1Aa7/etpKrsw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        borisp@nvidia.com, john.fastabend@gmail.com, maximmi@nvidia.com,
        tariqt@nvidia.com, vfedorenko@novek.ru,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 01/11] tls: rx: allow only one reader at a time
Date:   Wed, 13 Jul 2022 20:33:00 -0700
Message-Id: <20220714033310.1273288-2-kuba@kernel.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220714033310.1273288-1-kuba@kernel.org>
References: <20220714033310.1273288-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

recvmsg() in TLS gets data from the skb list (rx_list) or fresh
skbs we read from TCP via strparser. The former holds skbs which were
already decrypted for peek or decrypted and partially consumed.

tls_wait_data() only notices appearance of fresh skbs coming out
of TCP (or psock). It is possible, if there is a concurrent call
to peek() and recv() that the peek() will move the data from input
to rx_list without recv() noticing. recv() will then read data out
of order or never wake up.

This is not a practical use case/concern, but it makes the self
tests less reliable. This patch solves the problem by allowing
only one reader in.

Because having multiple processes calling read()/peek() is not
normal avoid adding a lock and try to fast-path the single reader
case.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 include/net/tls.h |  3 +++
 net/tls/tls_sw.c  | 61 +++++++++++++++++++++++++++++++++++++++++------
 2 files changed, 57 insertions(+), 7 deletions(-)

diff --git a/include/net/tls.h b/include/net/tls.h
index 8742e13bc362..e8935cfe0cd6 100644
--- a/include/net/tls.h
+++ b/include/net/tls.h
@@ -116,11 +116,14 @@ struct tls_sw_context_rx {
 	void (*saved_data_ready)(struct sock *sk);
 
 	struct sk_buff *recv_pkt;
+	u8 reader_present;
 	u8 async_capable:1;
 	u8 zc_capable:1;
+	u8 reader_contended:1;
 	atomic_t decrypt_pending;
 	/* protect crypto_wait with decrypt_pending*/
 	spinlock_t decrypt_compl_lock;
+	struct wait_queue_head wq;
 };
 
 struct tls_record_info {
diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index 68d79ee48a56..761a63751616 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -1753,6 +1753,51 @@ tls_read_flush_backlog(struct sock *sk, struct tls_prot_info *prot,
 	sk_flush_backlog(sk);
 }
 
+static long tls_rx_reader_lock(struct sock *sk, struct tls_sw_context_rx *ctx,
+			       bool nonblock)
+{
+	long timeo;
+
+	lock_sock(sk);
+
+	timeo = sock_rcvtimeo(sk, nonblock);
+
+	while (unlikely(ctx->reader_present)) {
+		DEFINE_WAIT_FUNC(wait, woken_wake_function);
+
+		ctx->reader_contended = 1;
+
+		add_wait_queue(&ctx->wq, &wait);
+		sk_wait_event(sk, &timeo,
+			      !READ_ONCE(ctx->reader_present), &wait);
+		remove_wait_queue(&ctx->wq, &wait);
+
+		if (!timeo)
+			return -EAGAIN;
+		if (signal_pending(current))
+			return sock_intr_errno(timeo);
+	}
+
+	WRITE_ONCE(ctx->reader_present, 1);
+
+	return timeo;
+}
+
+static void tls_rx_reader_unlock(struct sock *sk, struct tls_sw_context_rx *ctx)
+{
+	if (unlikely(ctx->reader_contended)) {
+		if (wq_has_sleeper(&ctx->wq))
+			wake_up(&ctx->wq);
+		else
+			ctx->reader_contended = 0;
+
+		WARN_ON_ONCE(!ctx->reader_present);
+	}
+
+	WRITE_ONCE(ctx->reader_present, 0);
+	release_sock(sk);
+}
+
 int tls_sw_recvmsg(struct sock *sk,
 		   struct msghdr *msg,
 		   size_t len,
@@ -1782,7 +1827,9 @@ int tls_sw_recvmsg(struct sock *sk,
 		return sock_recv_errqueue(sk, msg, len, SOL_IP, IP_RECVERR);
 
 	psock = sk_psock_get(sk);
-	lock_sock(sk);
+	timeo = tls_rx_reader_lock(sk, ctx, flags & MSG_DONTWAIT);
+	if (timeo < 0)
+		return timeo;
 	bpf_strp_enabled = sk_psock_strp_enabled(psock);
 
 	/* If crypto failed the connection is broken */
@@ -1801,7 +1848,6 @@ int tls_sw_recvmsg(struct sock *sk,
 
 	target = sock_rcvlowat(sk, flags & MSG_WAITALL, len);
 	len = len - copied;
-	timeo = sock_rcvtimeo(sk, flags & MSG_DONTWAIT);
 
 	zc_capable = !bpf_strp_enabled && !is_kvec && !is_peek &&
 		ctx->zc_capable;
@@ -1956,7 +2002,7 @@ int tls_sw_recvmsg(struct sock *sk,
 	copied += decrypted;
 
 end:
-	release_sock(sk);
+	tls_rx_reader_unlock(sk, ctx);
 	if (psock)
 		sk_psock_put(sk, psock);
 	return copied ? : err;
@@ -1978,9 +2024,9 @@ ssize_t tls_sw_splice_read(struct socket *sock,  loff_t *ppos,
 	long timeo;
 	int chunk;
 
-	lock_sock(sk);
-
-	timeo = sock_rcvtimeo(sk, flags & SPLICE_F_NONBLOCK);
+	timeo = tls_rx_reader_lock(sk, ctx, flags & SPLICE_F_NONBLOCK);
+	if (timeo < 0)
+		return timeo;
 
 	from_queue = !skb_queue_empty(&ctx->rx_list);
 	if (from_queue) {
@@ -2029,7 +2075,7 @@ ssize_t tls_sw_splice_read(struct socket *sock,  loff_t *ppos,
 	}
 
 splice_read_end:
-	release_sock(sk);
+	tls_rx_reader_unlock(sk, ctx);
 	return copied ? : err;
 }
 
@@ -2371,6 +2417,7 @@ int tls_set_sw_offload(struct sock *sk, struct tls_context *ctx, int tx)
 	} else {
 		crypto_init_wait(&sw_ctx_rx->async_wait);
 		spin_lock_init(&sw_ctx_rx->decrypt_compl_lock);
+		init_waitqueue_head(&sw_ctx_rx->wq);
 		crypto_info = &ctx->crypto_recv.info;
 		cctx = &ctx->rx;
 		skb_queue_head_init(&sw_ctx_rx->rx_list);
-- 
2.36.1

