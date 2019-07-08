Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8733362916
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 21:14:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391487AbfGHTOA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 15:14:00 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:43626 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728827AbfGHTOA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 15:14:00 -0400
Received: by mail-io1-f68.google.com with SMTP id k20so37738549ios.10;
        Mon, 08 Jul 2019 12:13:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=OkBt5UDkvteL6zmVGFv0ClYVAZZcXsFBdk1jOy9OQfg=;
        b=qoDiqNovyJm9oUZmEkXMWQRQPntJpG3eyaSkeRLsk1CC2+QJI6teWKbpwjZ1f3yI/v
         RxhVGPxCw8gOnq3T0bCcOO5yHqjgxG2jP4rvrZv0kT96pAssyobP6opZ5fQij/PBUFG4
         xWXt77ER7jRWCfwlcMFCCFZ8NggKN3Xl9v8R8pE1aW2I/QfK31bfItwbEOJ1wn8e4cvh
         9qwVFyJVBE9FRR3ie6koCjSV8ruwA1tFgWlyN3JOgy7qlGoSgYqux/l9WJIUycQs2MAz
         opk809quzD60GavPuLAImcUN+6dco0wnyP1t0Qn1wW14hwbEMgGpAvdCQosjHiv6ecIc
         k0Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=OkBt5UDkvteL6zmVGFv0ClYVAZZcXsFBdk1jOy9OQfg=;
        b=CGCzWmO95vRrKLDna6c+aUqj6leZSacpADWBvIw9lmDSHTO2PiIW9YJJNY1a7DSk3E
         vu7I5kY8TsPOfAvXCmgpwz7sBumJxUcZ35TyA3+QZwY/0WrlyT8DmkPjzIK2EZKhopak
         eAepWVMayHfIOjs5uhFhkp9HojqACY10kswscCArQyM4ivyXaaGyq3zLFge1J5N9l/i2
         KMr9fasTbQOh4ZH84+RHZR0HzpU+6Y9sX1ZyjBGG+3gsZ0YndNi1OXY0PZ+5/uBkUxMf
         ecnOn9xxs6mtqvHgFhQNQJpE9gpl12PIgBOAS3tzJX++DeOjR8uxVhnErmZCFkJ9OgKM
         VsEA==
X-Gm-Message-State: APjAAAWxqcijZeWVWBNeq7afEs6gSSX2XdUZ0MRlmKzlp192ThAX8+gK
        YpopS9cFj6tJfzjHz3mZ2bs=
X-Google-Smtp-Source: APXvYqwA8U7ZwZ92WXuvKM4M1uPu17rs5y7Vmsjj7iRvtjYgjXg01k2pnri0ORVGN3yxYE95PFwjoA==
X-Received: by 2002:a02:3904:: with SMTP id l4mr540217jaa.81.1562613239387;
        Mon, 08 Jul 2019 12:13:59 -0700 (PDT)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id s10sm8804137iod.46.2019.07.08.12.13.52
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 08 Jul 2019 12:13:58 -0700 (PDT)
Subject: [bpf PATCH v2 1/6] tls: remove close callback sock unlock/lock and
 flush_sync
From:   John Fastabend <john.fastabend@gmail.com>
To:     jakub.kicinski@netronome.com, ast@kernel.org, daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, edumazet@google.com,
        john.fastabend@gmail.com, bpf@vger.kernel.org
Date:   Mon, 08 Jul 2019 19:13:47 +0000
Message-ID: <156261322680.31108.7327349397950347146.stgit@ubuntu3-kvm1>
In-Reply-To: <156261310104.31108.4569969631798277807.stgit@ubuntu3-kvm1>
References: <156261310104.31108.4569969631798277807.stgit@ubuntu3-kvm1>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The tls close() callback currently drops the sock lock, makes a
cancel_delayed_work_sync() call, and then relocks the sock. The
same pattern is used again to call strp_done().

By restructuring the code we can avoid droping lock and then
reclaiming it. To simplify this we do the following,

 tls_sk_proto_close
  set_bit(CLOSING)
  set_bit(SCHEDULE)
  cancel_delay_work_sync() <- cancel workqueue
  lock_sock(sk)
  ...
  release_sock(sk)
  strp_done()

Setting the CLOSING bit prevents the SCHEDULE bit from being
cleared by any workqueue items e.g. if one happens to be
scheduled and run between when we set SCHEDULE bit and cancel
work. Then because SCHEDULE bit is set now no new work will
be scheduled.

Then strp_done() is called after the sk work is completed.
Any outstanding work is sync'd and finally ctx is free'd.

Tested with net selftests and bpf selftests.

Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 include/net/tls.h  |    4 ++--
 net/tls/tls_main.c |   56 ++++++++++++++++++++++++++--------------------------
 net/tls/tls_sw.c   |   38 ++++++++++++++++++++++-------------
 3 files changed, 54 insertions(+), 44 deletions(-)

diff --git a/include/net/tls.h b/include/net/tls.h
index 63e473420b00..0a3540a6304d 100644
--- a/include/net/tls.h
+++ b/include/net/tls.h
@@ -107,9 +107,7 @@ struct tls_device {
 enum {
 	TLS_BASE,
 	TLS_SW,
-#ifdef CONFIG_TLS_DEVICE
 	TLS_HW,
-#endif
 	TLS_HW_RECORD,
 	TLS_NUM_CONFIG,
 };
@@ -162,6 +160,7 @@ struct tls_sw_context_tx {
 	int async_capable;
 
 #define BIT_TX_SCHEDULED	0
+#define BIT_TX_CLOSING		1
 	unsigned long tx_bitmask;
 };
 
@@ -361,6 +360,7 @@ void tls_sw_close(struct sock *sk, long timeout);
 void tls_sw_free_resources_tx(struct sock *sk);
 void tls_sw_free_resources_rx(struct sock *sk);
 void tls_sw_release_resources_rx(struct sock *sk);
+void tls_sw_release_strp_rx(struct tls_context *tls_ctx);
 int tls_sw_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 		   int nonblock, int flags, int *addr_len);
 bool tls_sw_stream_read(const struct sock *sk);
diff --git a/net/tls/tls_main.c b/net/tls/tls_main.c
index fc81ae18cc44..d63c3583d2f7 100644
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
-	}
+}
+
+static void tls_sk_proto_close(struct sock *sk, long timeout)
+{
+	struct tls_context *ctx = tls_get_ctx(sk);
+	long timeo = sock_sndtimeo(sk, 0);
+	void (*sk_proto_close)(struct sock *sk, long timeout);
+
+	if (ctx->tx_conf == TLS_SW)
+		tls_sw_cancel_work_tx(ctx);
+
+	lock_sock(sk);
+	sk_proto_close = ctx->sk_proto_close;
+
+	if (ctx->tx_conf == TLS_HW_RECORD && ctx->rx_conf == TLS_HW_RECORD)
+		goto skip_tx_cleanup;
+
+	if (ctx->tx_conf == TLS_BASE && ctx->rx_conf == TLS_BASE)
+		goto skip_tx_cleanup;
+
+	tls_sk_proto_cleanup(sk, ctx, timeo);
 
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
index db585964b52b..3b01cd72ca6c 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -2053,6 +2053,15 @@ static void tls_data_ready(struct sock *sk)
 	}
 }
 
+void tls_sw_cancel_work_tx(struct tls_context *tls_ctx)
+{
+	struct tls_sw_context_tx *ctx = tls_sw_ctx_tx(tls_ctx);
+
+	set_bit(BIT_TX_CLOSING, &ctx->tx_bitmask);
+	set_bit(BIT_TX_SCHEDULED, &ctx->tx_bitmask);
+	cancel_delayed_work_sync(&ctx->tx_work.work);
+}
+
 void tls_sw_free_resources_tx(struct sock *sk)
 {
 	struct tls_context *tls_ctx = tls_get_ctx(sk);
@@ -2064,11 +2073,6 @@ void tls_sw_free_resources_tx(struct sock *sk)
 	if (atomic_read(&ctx->encrypt_pending))
 		crypto_wait_req(-EINPROGRESS, &ctx->async_wait);
 
-	release_sock(sk);
-	cancel_delayed_work_sync(&ctx->tx_work.work);
-	lock_sock(sk);
-
-	/* Tx whatever records we can transmit and abandon the rest */
 	tls_tx_records(sk, -1);
 
 	/* Free up un-sent records in tx_list. First, free
@@ -2112,22 +2116,22 @@ void tls_sw_release_resources_rx(struct sock *sk)
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
@@ -2136,11 +2140,17 @@ static void tx_work_handler(struct work_struct *work)
 					       struct tx_work, work);
 	struct sock *sk = tx_work->sk;
 	struct tls_context *tls_ctx = tls_get_ctx(sk);
-	struct tls_sw_context_tx *ctx = tls_sw_ctx_tx(tls_ctx);
+	struct tls_sw_context_tx *ctx;
 
-	if (!test_and_clear_bit(BIT_TX_SCHEDULED, &ctx->tx_bitmask))
+	if (unlikely(!tls_ctx))
+		return;
+
+	ctx = tls_sw_ctx_tx(tls_ctx);
+	if (test_bit(BIT_TX_CLOSING, &ctx->tx_bitmask))
 		return;
 
+	if (!test_and_clear_bit(BIT_TX_SCHEDULED, &ctx->tx_bitmask))
+		return;
 	lock_sock(sk);
 	tls_tx_records(sk, -1);
 	release_sock(sk);

