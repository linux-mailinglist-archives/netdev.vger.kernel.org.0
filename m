Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFF931D913D
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 09:44:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728431AbgESHoF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 03:44:05 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:62966 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728380AbgESHoF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 03:44:05 -0400
Received: from cyclone.blr.asicdesigners.com (cyclone.blr.asicdesigners.com [10.193.186.206])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 04J7hi2I010210;
        Tue, 19 May 2020 00:43:45 -0700
From:   Vinay Kumar Yadav <vinay.yadav@chelsio.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     kuba@kernel.org, secdev@chelsio.com,
        Vinay Kumar Yadav <vinay.yadav@chelsio.com>
Subject: [PATCH net-next] net/tls: fix race condition causing kernel panic
Date:   Tue, 19 May 2020 13:13:27 +0530
Message-Id: <20200519074327.32433-1-vinay.yadav@chelsio.com>
X-Mailer: git-send-email 2.18.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tls_sw_recvmsg() and tls_decrypt_done() can be run concurrently.
consider the scenario tls_decrypt_done() is about to run complete()
and tls_sw_recvmsg() completed reinit_completion() then tls_decrypt_done()
runs complete(). This sequence of execution results in wrong
completion (ctx->async_wait.completion.done is 1 but it should
be 0). Consequently, for next decrypt request, it will not wait for
completion and on connection close crypto resources freed
(crypto_free_aead()), there is no way to handle pending decrypt
response.
This race condition can be avoided by having atomic_read()
(in tls_sw_recvmsg()) mutually exclusive with
atomic_dec_return(),complete() (in tls_decrypt_done()).
Intoduced spin lock to ensure the mutual exclution.

Addressed similar problem in tx direction.

Signed-off-by: Vinay Kumar Yadav <vinay.yadav@chelsio.com>
---
 include/net/tls.h |  4 ++++
 net/tls/tls_sw.c  | 18 ++++++++++++++++--
 2 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/include/net/tls.h b/include/net/tls.h
index bf9eb4823933..18cd4f418464 100644
--- a/include/net/tls.h
+++ b/include/net/tls.h
@@ -135,6 +135,8 @@ struct tls_sw_context_tx {
 	struct tls_rec *open_rec;
 	struct list_head tx_list;
 	atomic_t encrypt_pending;
+	/* protect crypto_wait with encrypt_pending */
+	spinlock_t encrypt_compl_lock;
 	int async_notify;
 	u8 async_capable:1;
 
@@ -155,6 +157,8 @@ struct tls_sw_context_rx {
 	u8 async_capable:1;
 	u8 decrypted:1;
 	atomic_t decrypt_pending;
+	/* protect crypto_wait with decrypt_pending*/
+	spinlock_t decrypt_compl_lock;
 	bool async_notify;
 };
 
diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index c98e602a1a2d..3f0446d38a16 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -206,10 +206,12 @@ static void tls_decrypt_done(struct crypto_async_request *req, int err)
 
 	kfree(aead_req);
 
+	spin_lock_bh(&ctx->decrypt_compl_lock);
 	pending = atomic_dec_return(&ctx->decrypt_pending);
 
 	if (!pending && READ_ONCE(ctx->async_notify))
 		complete(&ctx->async_wait.completion);
+	spin_unlock_bh(&ctx->decrypt_compl_lock);
 }
 
 static int tls_do_decryption(struct sock *sk,
@@ -467,10 +469,12 @@ static void tls_encrypt_done(struct crypto_async_request *req, int err)
 			ready = true;
 	}
 
+	spin_lock_bh(&ctx->encrypt_compl_lock);
 	pending = atomic_dec_return(&ctx->encrypt_pending);
 
 	if (!pending && READ_ONCE(ctx->async_notify))
 		complete(&ctx->async_wait.completion);
+	spin_unlock_bh(&ctx->encrypt_compl_lock);
 
 	if (!ready)
 		return;
@@ -924,6 +928,7 @@ int tls_sw_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
 	int num_zc = 0;
 	int orig_size;
 	int ret = 0;
+	int pending;
 
 	if (msg->msg_flags & ~(MSG_MORE | MSG_DONTWAIT | MSG_NOSIGNAL))
 		return -EOPNOTSUPP;
@@ -1092,7 +1097,10 @@ int tls_sw_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
 		/* Wait for pending encryptions to get completed */
 		smp_store_mb(ctx->async_notify, true);
 
-		if (atomic_read(&ctx->encrypt_pending))
+		spin_lock_bh(&ctx->encrypt_compl_lock);
+		pending = atomic_read(&ctx->encrypt_pending);
+		spin_unlock_bh(&ctx->encrypt_compl_lock);
+		if (pending)
 			crypto_wait_req(-EINPROGRESS, &ctx->async_wait);
 		else
 			reinit_completion(&ctx->async_wait.completion);
@@ -1727,6 +1735,7 @@ int tls_sw_recvmsg(struct sock *sk,
 	bool is_kvec = iov_iter_is_kvec(&msg->msg_iter);
 	bool is_peek = flags & MSG_PEEK;
 	int num_async = 0;
+	int pending;
 
 	flags |= nonblock;
 
@@ -1890,7 +1899,10 @@ int tls_sw_recvmsg(struct sock *sk,
 	if (num_async) {
 		/* Wait for all previously submitted records to be decrypted */
 		smp_store_mb(ctx->async_notify, true);
-		if (atomic_read(&ctx->decrypt_pending)) {
+		spin_lock_bh(&ctx->decrypt_compl_lock);
+		pending = atomic_read(&ctx->decrypt_pending);
+		spin_unlock_bh(&ctx->decrypt_compl_lock);
+		if (pending) {
 			err = crypto_wait_req(-EINPROGRESS, &ctx->async_wait);
 			if (err) {
 				/* one of async decrypt failed */
@@ -2287,6 +2299,7 @@ int tls_set_sw_offload(struct sock *sk, struct tls_context *ctx, int tx)
 
 	if (tx) {
 		crypto_init_wait(&sw_ctx_tx->async_wait);
+		spin_lock_init(&sw_ctx_tx->encrypt_compl_lock);
 		crypto_info = &ctx->crypto_send.info;
 		cctx = &ctx->tx;
 		aead = &sw_ctx_tx->aead_send;
@@ -2295,6 +2308,7 @@ int tls_set_sw_offload(struct sock *sk, struct tls_context *ctx, int tx)
 		sw_ctx_tx->tx_work.sk = sk;
 	} else {
 		crypto_init_wait(&sw_ctx_rx->async_wait);
+		spin_lock_init(&sw_ctx_rx->decrypt_compl_lock);
 		crypto_info = &ctx->crypto_recv.info;
 		cctx = &ctx->rx;
 		skb_queue_head_init(&sw_ctx_rx->rx_list);
-- 
2.18.1

