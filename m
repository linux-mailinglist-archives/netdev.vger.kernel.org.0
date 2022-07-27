Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1472581E11
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 05:15:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240269AbiG0DPo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 23:15:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240250AbiG0DPe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 23:15:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46FE620F57
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 20:15:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 56471617A4
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 03:15:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D97DC43140;
        Wed, 27 Jul 2022 03:15:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658891728;
        bh=VPtOcUvdiHWkg4sltjX6PQZy8GnDVhv4g62dFSjc5qU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lTkCBrGExyj9b6nuwQneQEyaQu6R7ILZ8/CD0qbT4eMol84lku41Z+eSoeP+Kfz+T
         NspVDMPG0Q686rNoxxbxDl/72MqgbVQGGLsStEyAsVnvYpRSOUa70ENpVUxV/mTCDE
         Bgyq1I38Vtunr/NgfHs5AN3D3Hn+dbAm6Njn0zKUS7wRkucpgYjwQPg3cyJOknPx8Q
         hJxF7cU7z6ctifCPdIRFeTlJr6oG+Qs1EbwtKcmP6rB34by798r18+m8+OZP/0Bfyf
         ehR1vK4fCiTSpx+PNm6MSTwJtOR8FtLsLJIzVc5y0yEg8ooXz4lE/xTLZIUc5iQG91
         IObib3MZuzBMA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        borisp@nvidia.com, john.fastabend@gmail.com, maximmi@nvidia.com,
        tariqt@nvidia.com, vfedorenko@novek.ru,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 2/4] tls: rx: don't consider sock_rcvtimeo() cumulative
Date:   Tue, 26 Jul 2022 20:15:22 -0700
Message-Id: <20220727031524.358216-3-kuba@kernel.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727031524.358216-1-kuba@kernel.org>
References: <20220727031524.358216-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Eric indicates that restarting rcvtimeo on every wait may be fine.
I thought that we should consider it cumulative, and made
tls_rx_reader_lock() return the remaining timeo after acquiring
the reader lock.

tls_rx_rec_wait() gets its timeout passed in by value so it
does not keep track of time previously spent.

Make the lock waiting consistent with tls_rx_rec_wait() - don't
keep track of time spent.

Read the timeo fresh in tls_rx_rec_wait().
It's unclear to me why callers are supposed to cache the value.

Link: https://lore.kernel.org/all/CANn89iKcmSfWgvZjzNGbsrndmCch2HC_EPZ7qmGboDNaWoviNQ@mail.gmail.com/
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/tls/tls_sw.c | 37 +++++++++++++++++++------------------
 1 file changed, 19 insertions(+), 18 deletions(-)

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index 0fc24a5ce208..8bac7ea2c264 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -1283,11 +1283,14 @@ int tls_sw_sendpage(struct sock *sk, struct page *page,
 
 static int
 tls_rx_rec_wait(struct sock *sk, struct sk_psock *psock, bool nonblock,
-		bool released, long timeo)
+		bool released)
 {
 	struct tls_context *tls_ctx = tls_get_ctx(sk);
 	struct tls_sw_context_rx *ctx = tls_sw_ctx_rx(tls_ctx);
 	DEFINE_WAIT_FUNC(wait, woken_wake_function);
+	long timeo;
+
+	timeo = sock_rcvtimeo(sk, nonblock);
 
 	while (!tls_strp_msg_ready(ctx)) {
 		if (!sk_psock_queue_empty(psock))
@@ -1308,7 +1311,7 @@ tls_rx_rec_wait(struct sock *sk, struct sk_psock *psock, bool nonblock,
 		if (sock_flag(sk, SOCK_DONE))
 			return 0;
 
-		if (nonblock || !timeo)
+		if (!timeo)
 			return -EAGAIN;
 
 		released = true;
@@ -1842,8 +1845,8 @@ tls_read_flush_backlog(struct sock *sk, struct tls_prot_info *prot,
 	return sk_flush_backlog(sk);
 }
 
-static long tls_rx_reader_lock(struct sock *sk, struct tls_sw_context_rx *ctx,
-			       bool nonblock)
+static int tls_rx_reader_lock(struct sock *sk, struct tls_sw_context_rx *ctx,
+			      bool nonblock)
 {
 	long timeo;
 	int err;
@@ -1874,7 +1877,7 @@ static long tls_rx_reader_lock(struct sock *sk, struct tls_sw_context_rx *ctx,
 
 	WRITE_ONCE(ctx->reader_present, 1);
 
-	return timeo;
+	return 0;
 
 err_unlock:
 	release_sock(sk);
@@ -1913,8 +1916,7 @@ int tls_sw_recvmsg(struct sock *sk,
 	struct tls_msg *tlm;
 	ssize_t copied = 0;
 	bool async = false;
-	int target, err = 0;
-	long timeo;
+	int target, err;
 	bool is_kvec = iov_iter_is_kvec(&msg->msg_iter);
 	bool is_peek = flags & MSG_PEEK;
 	bool released = true;
@@ -1925,9 +1927,9 @@ int tls_sw_recvmsg(struct sock *sk,
 		return sock_recv_errqueue(sk, msg, len, SOL_IP, IP_RECVERR);
 
 	psock = sk_psock_get(sk);
-	timeo = tls_rx_reader_lock(sk, ctx, flags & MSG_DONTWAIT);
-	if (timeo < 0)
-		return timeo;
+	err = tls_rx_reader_lock(sk, ctx, flags & MSG_DONTWAIT);
+	if (err < 0)
+		return err;
 	bpf_strp_enabled = sk_psock_strp_enabled(psock);
 
 	/* If crypto failed the connection is broken */
@@ -1954,8 +1956,8 @@ int tls_sw_recvmsg(struct sock *sk,
 		struct tls_decrypt_arg darg;
 		int to_decrypt, chunk;
 
-		err = tls_rx_rec_wait(sk, psock, flags & MSG_DONTWAIT, released,
-				      timeo);
+		err = tls_rx_rec_wait(sk, psock, flags & MSG_DONTWAIT,
+				      released);
 		if (err <= 0) {
 			if (psock) {
 				chunk = sk_msg_recvmsg(sk, psock, msg, len,
@@ -2131,13 +2133,12 @@ ssize_t tls_sw_splice_read(struct socket *sock,  loff_t *ppos,
 	struct tls_msg *tlm;
 	struct sk_buff *skb;
 	ssize_t copied = 0;
-	int err = 0;
-	long timeo;
 	int chunk;
+	int err;
 
-	timeo = tls_rx_reader_lock(sk, ctx, flags & SPLICE_F_NONBLOCK);
-	if (timeo < 0)
-		return timeo;
+	err = tls_rx_reader_lock(sk, ctx, flags & SPLICE_F_NONBLOCK);
+	if (err < 0)
+		return err;
 
 	if (!skb_queue_empty(&ctx->rx_list)) {
 		skb = __skb_dequeue(&ctx->rx_list);
@@ -2145,7 +2146,7 @@ ssize_t tls_sw_splice_read(struct socket *sock,  loff_t *ppos,
 		struct tls_decrypt_arg darg;
 
 		err = tls_rx_rec_wait(sk, NULL, flags & SPLICE_F_NONBLOCK,
-				      true, timeo);
+				      true);
 		if (err <= 0)
 			goto splice_read_end;
 
-- 
2.37.1

