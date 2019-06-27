Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B6085888F
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 19:36:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726883AbfF0Rgp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 13:36:45 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:40177 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726632AbfF0Rgo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 13:36:44 -0400
Received: by mail-pl1-f194.google.com with SMTP id a93so1675612pla.7;
        Thu, 27 Jun 2019 10:36:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=qJWEwf8Wkw7xO+8rTeiXMi5DmcC9FWEMuxJb+RRVkDQ=;
        b=I8gMr9mXskhdcGne6HNgjD62IeEuN5/XdsS2IhoN8f8haJWYSwB2HvAXSwHRt7G7Td
         SLeW0jN8QfJ9LHA+EbGLk3XRo3Z3z74hGL5+v9JqxfNLzIfwMYX43WNzbyCyMFq8rcVV
         T07AjHG9isgqb1cq6O6WBq2HjAQqeN/Ptpdy54hjZ+xu5EUcDUZCGQmjMDmL1G9Zk4OM
         1dRCGipm1Nb0PCP7LIcmnx89L86/QpdeVGlCF0u/G5dV5VGLBtyWe0ICR8lwC6P1lqa4
         T5RDRMPrpOEGSz0jYVWmaOVwivDOZXX1QEhVEhIcJbNvU5PXCyI/zmgooKo2danC26KA
         lakg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=qJWEwf8Wkw7xO+8rTeiXMi5DmcC9FWEMuxJb+RRVkDQ=;
        b=NJ951kxbGLODte5IxTwm9eg7p/aHweG7WZnaH3lK5El4bkj83y4XW9t6w4jfQTUWeF
         UOY9JckoJNz/CoTZy5ISTZbWITbaFGpwTan9uZddsnlDgI/zzSJ3aVD9je350VbBCqbX
         Xh3/BWw6A7fhM3g4rrk21TvMotQdrEXDAwe3EheMbQsmIYEm2Xu7txNj4tinnUOx4CqG
         Up1PRr5MMqDKpzI86uaJU+o5sg5rDxmBtXY3g21bz83PpvGGbczlXDiWTycZcZeQWoxg
         ZYRU/16paDm0pw3pWwyS36AE0qL9L2vqmPVDStptUpm9raTyoZev7cSFHFwtkprhX3Wg
         toEg==
X-Gm-Message-State: APjAAAWrZrTgakFblwL/psWqnsZlcMb19E308o7jne0IGrmj6mbdRIpV
        0aFHP/guszJJRDWDoBtuiZk=
X-Google-Smtp-Source: APXvYqwOJ7Iwiq9NSlqjbGsoyyxT3ml5ONCbBW6BvaZwnneSwmeETeH0it2arEWg2+EguFkfG9QCUQ==
X-Received: by 2002:a17:902:788e:: with SMTP id q14mr6034189pll.234.1561657003074;
        Thu, 27 Jun 2019 10:36:43 -0700 (PDT)
Received: from [127.0.1.1] ([67.136.128.119])
        by smtp.gmail.com with ESMTPSA id j23sm3428822pff.90.2019.06.27.10.36.42
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 27 Jun 2019 10:36:42 -0700 (PDT)
Subject: [PATCH 1/2] tls: remove close callback sock unlock/lock and
 flush_sync
From:   John Fastabend <john.fastabend@gmail.com>
To:     daniel@iogearbox.io, jakub.kicinski@netronome.com, ast@kernel.org
Cc:     netdev@vger.kernel.org, edumazet@google.com,
        john.fastabend@gmail.com, bpf@vger.kernel.org
Date:   Thu, 27 Jun 2019 10:36:42 -0700
Message-ID: <156165700197.32598.17496423044615153967.stgit@john-XPS-13-9370>
In-Reply-To: <156165697019.32598.7171757081688035707.stgit@john-XPS-13-9370>
References: <156165697019.32598.7171757081688035707.stgit@john-XPS-13-9370>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The tls close() callback currently drops the sock lock, makes a
cancel_delayed_work_sync() call, and then relocks the sock. This
seems suspect at best. The lock_sock() is applied to stop concurrent
operations on the socket while tearing the sock down. Further we
will need to add support for unhash() shortly and this complicates
matters because the lock may or may not be held then.

So to fix the above situation and simplify the next patch to add
unhash this patch creates a function tls_sk_proto_cleanup() that
tears down the socket without calling lock_sock/release_sock. In
order to flush the workqueue then we do the following,

  - Add a new bit to ctx, BIT_TX_CLOSING that is set when the
    tls resources are being removed.
  - Check this bit before scheduling any new work. This way we
    avoid queueing new work after tear down has started.
  - With the BIT_TX_CLOSING ensuring no new work is being added
    convert the cancel_delayed_work_sync to flush_delayed_work()
  - Finally call tlx_tx_records() to complete any available records
    before,
  - releasing and removing tls ctx.

The above is implemented for the software case namely any of
the following configurations from build_protos,

   prot[TLS_SW][TLS_BASE]
   prot[TLS_BASE][TLS_SW]
   prot[TLS_SW][TLS_SW]

The implication is a follow up patch is needed to resolve the
hardware offload case.

Tested with net selftests and bpf selftests.

Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 include/net/tls.h  |    4 ++--
 net/tls/tls_main.c |   54 ++++++++++++++++++++++++++--------------------------
 net/tls/tls_sw.c   |   50 ++++++++++++++++++++++++++++++++----------------
 3 files changed, 62 insertions(+), 46 deletions(-)

diff --git a/include/net/tls.h b/include/net/tls.h
index 4a55ce6a303f..6fe1f5c96f4a 100644
--- a/include/net/tls.h
+++ b/include/net/tls.h
@@ -105,9 +105,7 @@ struct tls_device {
 enum {
 	TLS_BASE,
 	TLS_SW,
-#ifdef CONFIG_TLS_DEVICE
 	TLS_HW,
-#endif
 	TLS_HW_RECORD,
 	TLS_NUM_CONFIG,
 };
@@ -160,6 +158,7 @@ struct tls_sw_context_tx {
 	int async_capable;
 
 #define BIT_TX_SCHEDULED	0
+#define BIT_TX_CLOSING		1
 	unsigned long tx_bitmask;
 };
 
@@ -327,6 +326,7 @@ void tls_sw_close(struct sock *sk, long timeout);
 void tls_sw_free_resources_tx(struct sock *sk);
 void tls_sw_free_resources_rx(struct sock *sk);
 void tls_sw_release_resources_rx(struct sock *sk);
+void tls_sw_release_strp_rx(struct tls_context *tls_ctx);
 int tls_sw_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 		   int nonblock, int flags, int *addr_len);
 bool tls_sw_stream_read(const struct sock *sk);
diff --git a/net/tls/tls_main.c b/net/tls/tls_main.c
index fc81ae18cc44..51cb19e24dd9 100644
--- a/net/tls/tls_main.c
+++ b/net/tls/tls_main.c
@@ -261,24 +261,9 @@ static void tls_ctx_free(struct tls_context *ctx)
 	kfree(ctx);
 }
 
-static void tls_sk_proto_close(struct sock *sk, long timeout)
+static void tls_sk_proto_cleanup(struct sock *sk,
+				 struct tls_context *ctx, long timeo)
 {
-	struct tls_context *ctx = tls_get_ctx(sk);
-	long timeo = sock_sndtimeo(sk, 0);
-	void (*sk_proto_close)(struct sock *sk, long timeout);
-	bool free_ctx = false;
-
-	lock_sock(sk);
-	sk_proto_close = ctx->sk_proto_close;
-
-	if (ctx->tx_conf == TLS_HW_RECORD && ctx->rx_conf == TLS_HW_RECORD)
-		goto skip_tx_cleanup;
-
-	if (ctx->tx_conf == TLS_BASE && ctx->rx_conf == TLS_BASE) {
-		free_ctx = true;
-		goto skip_tx_cleanup;
-	}
-
 	if (!tls_complete_pending_work(sk, ctx, 0, &timeo))
 		tls_handle_open_record(sk, 0);
 
@@ -299,22 +284,37 @@ static void tls_sk_proto_close(struct sock *sk, long timeout)
 #ifdef CONFIG_TLS_DEVICE
 	if (ctx->rx_conf == TLS_HW)
 		tls_device_offload_cleanup_rx(sk);
-
-	if (ctx->tx_conf != TLS_HW && ctx->rx_conf != TLS_HW) {
-#else
-	{
 #endif
-		tls_ctx_free(ctx);
-		ctx = NULL;
+}
+
+static void tls_sk_proto_close(struct sock *sk, long timeout)
+{
+	struct tls_context *ctx = tls_get_ctx(sk);
+	long timeo = sock_sndtimeo(sk, 0);
+	void (*sk_proto_close)(struct sock *sk, long timeout);
+	bool free_ctx = false;
+
+	lock_sock(sk);
+	sk_proto_close = ctx->sk_proto_close;
+
+	if (ctx->tx_conf == TLS_HW_RECORD && ctx->rx_conf == TLS_HW_RECORD)
+		goto skip_tx_cleanup;
+
+	if (ctx->tx_conf == TLS_BASE && ctx->rx_conf == TLS_BASE) {
+		free_ctx = true;
+		goto skip_tx_cleanup;
 	}
 
+	tls_sk_proto_cleanup(sk, ctx, timeo);
+
 skip_tx_cleanup:
 	release_sock(sk);
+	if (ctx->rx_conf == TLS_SW)
+		tls_sw_release_strp_rx(ctx);
 	sk_proto_close(sk, timeout);
-	/* free ctx for TLS_HW_RECORD, used by tcp_set_state
-	 * for sk->sk_prot->unhash [tls_hw_unhash]
-	 */
-	if (free_ctx)
+
+	if (ctx->tx_conf != TLS_HW && ctx->rx_conf != TLS_HW &&
+	    ctx->tx_conf != TLS_HW_RECORD && ctx->rx_conf != TLS_HW_RECORD)
 		tls_ctx_free(ctx);
 }
 
diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index 455a782c7658..d234a6b818e6 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -473,7 +473,8 @@ static void tls_encrypt_done(struct crypto_async_request *req, int err)
 		return;
 
 	/* Schedule the transmission */
-	if (!test_and_set_bit(BIT_TX_SCHEDULED, &ctx->tx_bitmask))
+	if (!test_and_set_bit(BIT_TX_SCHEDULED, &ctx->tx_bitmask) &&
+	    !test_bit(BIT_TX_CLOSING, &ctx->tx_bitmask))
 		schedule_delayed_work(&ctx->tx_work.work, 1);
 }
 
@@ -2058,16 +2059,26 @@ void tls_sw_free_resources_tx(struct sock *sk)
 	struct tls_sw_context_tx *ctx = tls_sw_ctx_tx(tls_ctx);
 	struct tls_rec *rec, *tmp;
 
+	/* Set TX CLOSING bit to stop tx_work from being scheduled
+	 * while tearing down TX context. We will flush any pending
+	 * work before free'ing ctx anyways. If already set then
+	 * another call is already free'ing resources.
+	 */
+	if (test_and_set_bit(BIT_TX_CLOSING, &ctx->tx_bitmask))
+		return;
+
 	/* Wait for any pending async encryptions to complete */
 	smp_store_mb(ctx->async_notify, true);
 	if (atomic_read(&ctx->encrypt_pending))
 		crypto_wait_req(-EINPROGRESS, &ctx->async_wait);
 
-	release_sock(sk);
-	cancel_delayed_work_sync(&ctx->tx_work.work);
-	lock_sock(sk);
-
-	/* Tx whatever records we can transmit and abandon the rest */
+	/* Flush work queue and then Tx whatever records we can
+	 * transmit and abandon the rest, lock_sock(sk) must be
+	 * held here. We ensure no further work is enqueue by
+	 * checking CLOSING bit before queueing new work and
+	 * setting it above.
+	 */
+	flush_delayed_work(&ctx->tx_work.work);
 	tls_tx_records(sk, -1);
 
 	/* Free up un-sent records in tx_list. First, free
@@ -2111,22 +2122,22 @@ void tls_sw_release_resources_rx(struct sock *sk)
 		write_lock_bh(&sk->sk_callback_lock);
 		sk->sk_data_ready = ctx->saved_data_ready;
 		write_unlock_bh(&sk->sk_callback_lock);
-		release_sock(sk);
-		strp_done(&ctx->strp);
-		lock_sock(sk);
 	}
 }
 
-void tls_sw_free_resources_rx(struct sock *sk)
+void tls_sw_release_strp_rx(struct tls_context *tls_ctx)
 {
-	struct tls_context *tls_ctx = tls_get_ctx(sk);
 	struct tls_sw_context_rx *ctx = tls_sw_ctx_rx(tls_ctx);
 
-	tls_sw_release_resources_rx(sk);
-
+	strp_done(&ctx->strp);
 	kfree(ctx);
 }
 
+void tls_sw_free_resources_rx(struct sock *sk)
+{
+	tls_sw_release_resources_rx(sk);
+}
+
 /* The work handler to transmitt the encrypted records in tx_list */
 static void tx_work_handler(struct work_struct *work)
 {
@@ -2140,9 +2151,14 @@ static void tx_work_handler(struct work_struct *work)
 	if (!test_and_clear_bit(BIT_TX_SCHEDULED, &ctx->tx_bitmask))
 		return;
 
-	lock_sock(sk);
+	/* If we are running from a socket close operation then the
+	 * lock is already held so we do not need to hold it.
+	 */
+	if (likely(!test_bit(BIT_TX_CLOSING, &ctx->tx_bitmask)))
+		lock_sock(sk);
 	tls_tx_records(sk, -1);
-	release_sock(sk);
+	if (likely(!test_bit(BIT_TX_CLOSING, &ctx->tx_bitmask)))
+		release_sock(sk);
 }
 
 void tls_sw_write_space(struct sock *sk, struct tls_context *ctx)
@@ -2152,8 +2168,8 @@ void tls_sw_write_space(struct sock *sk, struct tls_context *ctx)
 	/* Schedule the transmission if tx list is ready */
 	if (is_tx_ready(tx_ctx) && !sk->sk_write_pending) {
 		/* Schedule the transmission */
-		if (!test_and_set_bit(BIT_TX_SCHEDULED,
-				      &tx_ctx->tx_bitmask))
+		if (!test_and_set_bit(BIT_TX_SCHEDULED, &tx_ctx->tx_bitmask) &&
+		    !test_bit(BIT_TX_CLOSING, &tx_ctx->tx_bitmask))
 			schedule_delayed_work(&tx_ctx->tx_work.work, 0);
 	}
 }

