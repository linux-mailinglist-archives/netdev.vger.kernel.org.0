Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B18F31DF061
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 22:11:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730992AbgEVULA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 16:11:00 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:6174 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730893AbgEVUK7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 May 2020 16:10:59 -0400
Received: from cyclone.blr.asicdesigners.com (cyclone.blr.asicdesigners.com [10.193.186.206])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 04MKAmqA022450;
        Fri, 22 May 2020 13:10:49 -0700
From:   Vinay Kumar Yadav <vinay.yadav@chelsio.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     kuba@kernel.org, secdev@chelsio.com,
        Vinay Kumar Yadav <vinay.yadav@chelsio.com>
Subject: [PATCH net-next,v2] net/tls: fix race condition causing kernel panic
Date:   Sat, 23 May 2020 01:40:31 +0530
Message-Id: <20200522201031.32516-1-vinay.yadav@chelsio.com>
X-Mailer: git-send-email 2.18.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tls_sw_recvmsg() and tls_decrypt_done() can be run concurrently.
// tls_sw_recvmsg()
	if (atomic_read(&ctx->decrypt_pending))
		crypto_wait_req(-EINPROGRESS, &ctx->async_wait);
	else
		reinit_completion(&ctx->async_wait.completion);

//tls_decrypt_done()
  	pending = atomic_dec_return(&ctx->decrypt_pending);

  	if (!pending && READ_ONCE(ctx->async_notify))
  		complete(&ctx->async_wait.completion);

Consider the scenario tls_decrypt_done() is about to run complete()

	if (!pending && READ_ONCE(ctx->async_notify))

and tls_sw_recvmsg() reads decrypt_pending == 0, does reinit_completion(),
then tls_decrypt_done() runs complete(). This sequence of execution
results in wrong completion. Consequently, for next decrypt request,
it will not wait for completion, eventually on connection close, crypto
resources freed, there is no way to handle pending decrypt response.

This race condition can be avoided by having atomic_read() mutually
exclusive with atomic_dec_return(),complete().Intoduced spin lock to
ensure the mutual exclution.

Addressed similar problem in tx direction.

v1->v2:
- More readable commit message.
- Corrected the lock to fix new race scenario.
- Removed barrier which is not needed now.

Signed-off-by: Vinay Kumar Yadav <vinay.yadav@chelsio.com>
---
 include/net/tls.h |  4 ++++
 net/tls/tls_sw.c  | 33 +++++++++++++++++++++++++++------
 2 files changed, 31 insertions(+), 6 deletions(-)

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
index c98e602a1a2d..f29ea717590c 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -206,10 +206,12 @@ static void tls_decrypt_done(struct crypto_async_request *req, int err)
 
 	kfree(aead_req);
 
+	spin_lock_bh(&ctx->decrypt_compl_lock);
 	pending = atomic_dec_return(&ctx->decrypt_pending);
 
-	if (!pending && READ_ONCE(ctx->async_notify))
+	if (!pending && ctx->async_notify)
 		complete(&ctx->async_wait.completion);
+	spin_unlock_bh(&ctx->decrypt_compl_lock);
 }
 
 static int tls_do_decryption(struct sock *sk,
@@ -467,10 +469,12 @@ static void tls_encrypt_done(struct crypto_async_request *req, int err)
 			ready = true;
 	}
 
+	spin_lock_bh(&ctx->encrypt_compl_lock);
 	pending = atomic_dec_return(&ctx->encrypt_pending);
 
-	if (!pending && READ_ONCE(ctx->async_notify))
+	if (!pending && ctx->async_notify)
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
@@ -1090,13 +1095,19 @@ int tls_sw_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
 		goto send_end;
 	} else if (num_zc) {
 		/* Wait for pending encryptions to get completed */
-		smp_store_mb(ctx->async_notify, true);
+		spin_lock_bh(&ctx->encrypt_compl_lock);
+		ctx->async_notify = true;
 
-		if (atomic_read(&ctx->encrypt_pending))
+		pending = atomic_read(&ctx->encrypt_pending);
+		spin_unlock_bh(&ctx->encrypt_compl_lock);
+		if (pending)
 			crypto_wait_req(-EINPROGRESS, &ctx->async_wait);
 		else
 			reinit_completion(&ctx->async_wait.completion);
 
+		/* There can be no concurrent accesses, since we have no
+		 * pending encrypt operations
+		 */
 		WRITE_ONCE(ctx->async_notify, false);
 
 		if (ctx->async_wait.err) {
@@ -1727,6 +1738,7 @@ int tls_sw_recvmsg(struct sock *sk,
 	bool is_kvec = iov_iter_is_kvec(&msg->msg_iter);
 	bool is_peek = flags & MSG_PEEK;
 	int num_async = 0;
+	int pending;
 
 	flags |= nonblock;
 
@@ -1889,8 +1901,11 @@ int tls_sw_recvmsg(struct sock *sk,
 recv_end:
 	if (num_async) {
 		/* Wait for all previously submitted records to be decrypted */
-		smp_store_mb(ctx->async_notify, true);
-		if (atomic_read(&ctx->decrypt_pending)) {
+		spin_lock_bh(&ctx->decrypt_compl_lock);
+		ctx->async_notify = true;
+		pending = atomic_read(&ctx->decrypt_pending);
+		spin_unlock_bh(&ctx->decrypt_compl_lock);
+		if (pending) {
 			err = crypto_wait_req(-EINPROGRESS, &ctx->async_wait);
 			if (err) {
 				/* one of async decrypt failed */
@@ -1902,6 +1917,10 @@ int tls_sw_recvmsg(struct sock *sk,
 		} else {
 			reinit_completion(&ctx->async_wait.completion);
 		}
+
+		/* There can be no concurrent accesses, since we have no
+		 * pending decrypt operations
+		 */
 		WRITE_ONCE(ctx->async_notify, false);
 
 		/* Drain records from the rx_list & copy if required */
@@ -2287,6 +2306,7 @@ int tls_set_sw_offload(struct sock *sk, struct tls_context *ctx, int tx)
 
 	if (tx) {
 		crypto_init_wait(&sw_ctx_tx->async_wait);
+		spin_lock_init(&sw_ctx_tx->encrypt_compl_lock);
 		crypto_info = &ctx->crypto_send.info;
 		cctx = &ctx->tx;
 		aead = &sw_ctx_tx->aead_send;
@@ -2295,6 +2315,7 @@ int tls_set_sw_offload(struct sock *sk, struct tls_context *ctx, int tx)
 		sw_ctx_tx->tx_work.sk = sk;
 	} else {
 		crypto_init_wait(&sw_ctx_rx->async_wait);
+		spin_lock_init(&sw_ctx_rx->decrypt_compl_lock);
 		crypto_info = &ctx->crypto_recv.info;
 		cctx = &ctx->rx;
 		skb_queue_head_init(&sw_ctx_rx->rx_list);
-- 
2.18.1

