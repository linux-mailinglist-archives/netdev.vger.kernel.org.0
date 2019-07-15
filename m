Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA63069D0B
	for <lists+netdev@lfdr.de>; Mon, 15 Jul 2019 22:49:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732165AbfGOUtZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 16:49:25 -0400
Received: from mail-ot1-f67.google.com ([209.85.210.67]:45677 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729505AbfGOUtZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jul 2019 16:49:25 -0400
Received: by mail-ot1-f67.google.com with SMTP id x21so18506303otq.12;
        Mon, 15 Jul 2019 13:49:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=UiKaE+sa/JTtPfu66ECQVi+EOsevEAKzkG+J0EsB2cI=;
        b=OZNR7DQ0gkcJBaoCDGjC3/4y6j6rKMfEpn+X4u5wlWMn6GyYahj1yxDToa5fZi2Z2I
         PUo77rOZ/iAL/VF3cXcfx1hnWqOERtkDcqMwtcJ2L2rLMtH59kBUveCftVUQQDRpvnuV
         ZCWg3oJ2tEnuboHGXm4iExL1gE4gIxbwgclsr52z8DTH0dNJpkdiYJrGARqRDwfrxKIX
         cBemLZQAJuGFkRA0Kunvwalomj9x/5pJAsPW8M9qhhyr7O4bUw8ef/hC3pi/0Gsllsxa
         qcPMwpO1RYqj/ucbS9UVvQe6JeoMCBKcXvRfppOQG9zL/9ihp5brTOhGpHVJP5sGrCHi
         8mGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=UiKaE+sa/JTtPfu66ECQVi+EOsevEAKzkG+J0EsB2cI=;
        b=PX5Yn4AJj1pVGGbV9Jq5vImFUWhtrkjh1JWgztOq9h8JvFT+gC+I8Lca/1nXmcv2ex
         Uod5szKM034+M938V0t4CtMC3pKDYCRY3mE2V8Qma28dv6t8CaSQfAcaWq3Au2xTbM2d
         3WbAhMxta/3XtvnOYw6lmfMjpVfP84/WvjDyXp92i8o1XXZrRuYo30YM6J2uUdJ6rWnD
         UEpU+iupEUxdTdG/XeJH/e67lWppdg8v9IsXYaWakt9ViEZhk23mUoF5pFbjNju25eja
         zQM9UTl9/n6d1HHLl0eXWpMKU3W5eXGiEG7ZmRNeO5iAES9A9qlL6nHBZiA2xnTUffkL
         5JdA==
X-Gm-Message-State: APjAAAWE6ozHpy6JHA+4wLrJ+1I1MraiLt3TBaw1OJGSff8z54Qv2h+5
        RteDgxNnuWZxZrBZVCFttHM=
X-Google-Smtp-Source: APXvYqyaIr6KH1VdHwm2SPwcp1uLiJQ7gW0tLAbbKd908tfGXryV3v7UkL+o5HSHcoNuorlvLZ3uuA==
X-Received: by 2002:a9d:7741:: with SMTP id t1mr5739795otl.178.1563223763952;
        Mon, 15 Jul 2019 13:49:23 -0700 (PDT)
Received: from [127.0.1.1] ([99.0.85.34])
        by smtp.gmail.com with ESMTPSA id z20sm6088307oic.31.2019.07.15.13.49.23
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 15 Jul 2019 13:49:23 -0700 (PDT)
Subject: [bpf PATCH v3 3/8] tls: remove sock unlock/lock around strp_done()
From:   John Fastabend <john.fastabend@gmail.com>
To:     jakub.kicinski@netronome.com, ast@kernel.org, daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, edumazet@google.com,
        john.fastabend@gmail.com, bpf@vger.kernel.org
Date:   Mon, 15 Jul 2019 13:49:22 -0700
Message-ID: <156322376245.18678.2590668444515934979.stgit@john-XPS-13-9370>
In-Reply-To: <156322373173.18678.6003379631139659856.stgit@john-XPS-13-9370>
References: <156322373173.18678.6003379631139659856.stgit@john-XPS-13-9370>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The tls close() callback currently drops the sock lock to call
strp_done(). Split up the RX cleanup into stopping the strparser
and releasing most resources, syncing strparser and finally
freeing the context.

To avoid the need for a strp_done() call on the cleanup path
of device offload make sure we don't arm the strparser until
we are sure init will be successful.

Signed-off-by: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: Dirk van der Merwe <dirk.vandermerwe@netronome.com>
---
 include/net/tls.h    |    4 ++-
 net/tls/tls_device.c |    1 -
 net/tls/tls_main.c   |   65 +++++++++++++++++++++++++-------------------------
 net/tls/tls_sw.c     |   33 ++++++++++++++++++-------
 4 files changed, 58 insertions(+), 45 deletions(-)

diff --git a/include/net/tls.h b/include/net/tls.h
index d4276cb6de53..72ddd16de056 100644
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
@@ -357,6 +355,7 @@ int tls_sk_attach(struct sock *sk, int optname, char __user *optval,
 
 int tls_set_sw_offload(struct sock *sk, struct tls_context *ctx, int tx);
 void tls_sw_strparser_arm(struct sock *sk, struct tls_context *ctx);
+void tls_sw_strparser_done(struct tls_context *tls_ctx);
 int tls_sw_sendmsg(struct sock *sk, struct msghdr *msg, size_t size);
 int tls_sw_sendpage(struct sock *sk, struct page *page,
 		    int offset, size_t size, int flags);
@@ -365,6 +364,7 @@ void tls_sw_cancel_work_tx(struct tls_context *tls_ctx);
 void tls_sw_free_resources_tx(struct sock *sk);
 void tls_sw_free_resources_rx(struct sock *sk);
 void tls_sw_release_resources_rx(struct sock *sk);
+void tls_sw_free_ctx_rx(struct tls_context *tls_ctx);
 int tls_sw_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 		   int nonblock, int flags, int *addr_len);
 bool tls_sw_stream_read(const struct sock *sk);
diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
index 4d67d72f007c..7c0b2b778703 100644
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -1045,7 +1045,6 @@ int tls_set_device_offload_rx(struct sock *sk, struct tls_context *ctx)
 	rc = tls_set_sw_offload(sk, ctx, 0);
 	if (rc)
 		goto release_ctx;
-	tls_sw_strparser_arm(sk, ctx);
 
 	rc = netdev->tlsdev_ops->tls_dev_add(netdev, sk, TLS_OFFLOAD_CTX_DIR_RX,
 					     &ctx->crypto_recv.info,
diff --git a/net/tls/tls_main.c b/net/tls/tls_main.c
index ddda422498aa..9f4a9da182ae 100644
--- a/net/tls/tls_main.c
+++ b/net/tls/tls_main.c
@@ -261,27 +261,9 @@ void tls_ctx_free(struct tls_context *ctx)
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
-	if (ctx->tx_conf == TLS_SW)
-		tls_sw_cancel_work_tx(ctx);
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
 	if (unlikely(sk->sk_write_pending) &&
 	    !wait_on_pending_writer(sk, &timeo))
 		tls_handle_open_record(sk, 0);
@@ -298,27 +280,44 @@ static void tls_sk_proto_close(struct sock *sk, long timeout)
 	}
 
 	if (ctx->rx_conf == TLS_SW)
-		tls_sw_free_resources_rx(sk);
+		tls_sw_release_resources_rx(sk);
 
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
+	void (*sk_proto_close)(struct sock *sk, long timeout);
+	struct tls_context *ctx = tls_get_ctx(sk);
+	long timeo = sock_sndtimeo(sk, 0);
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
+	if (ctx->rx_conf == TLS_SW || ctx->rx_conf == TLS_HW)
+		tls_sw_strparser_done(ctx);
+	if (ctx->rx_conf == TLS_SW)
+		tls_sw_free_ctx_rx(ctx);
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
 
@@ -544,9 +543,9 @@ static int do_tls_setsockopt_conf(struct sock *sk, char __user *optval,
 			rc = tls_set_sw_offload(sk, ctx, 0);
 			if (rc)
 				goto err_crypto_info;
-			tls_sw_strparser_arm(sk, ctx);
 			conf = TLS_SW;
 		}
+		tls_sw_strparser_arm(sk, ctx);
 	}
 
 	if (tx)
diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index 38c0e53c727d..ee8fef312475 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -2114,25 +2114,40 @@ void tls_sw_release_resources_rx(struct sock *sk)
 		skb_queue_purge(&ctx->rx_list);
 		crypto_free_aead(ctx->aead_recv);
 		strp_stop(&ctx->strp);
-		write_lock_bh(&sk->sk_callback_lock);
-		sk->sk_data_ready = ctx->saved_data_ready;
-		write_unlock_bh(&sk->sk_callback_lock);
-		release_sock(sk);
-		strp_done(&ctx->strp);
-		lock_sock(sk);
+		/* If tls_sw_strparser_arm() was not called (cleanup paths)
+		 * we still want to strp_stop(), but sk->sk_data_ready was
+		 * never swapped.
+		 */
+		if (ctx->saved_data_ready) {
+			write_lock_bh(&sk->sk_callback_lock);
+			sk->sk_data_ready = ctx->saved_data_ready;
+			write_unlock_bh(&sk->sk_callback_lock);
+		}
 	}
 }
 
-void tls_sw_free_resources_rx(struct sock *sk)
+void tls_sw_strparser_done(struct tls_context *tls_ctx)
 {
-	struct tls_context *tls_ctx = tls_get_ctx(sk);
 	struct tls_sw_context_rx *ctx = tls_sw_ctx_rx(tls_ctx);
 
-	tls_sw_release_resources_rx(sk);
+	strp_done(&ctx->strp);
+}
+
+void tls_sw_free_ctx_rx(struct tls_context *tls_ctx)
+{
+	struct tls_sw_context_rx *ctx = tls_sw_ctx_rx(tls_ctx);
 
 	kfree(ctx);
 }
 
+void tls_sw_free_resources_rx(struct sock *sk)
+{
+	struct tls_context *tls_ctx = tls_get_ctx(sk);
+
+	tls_sw_release_resources_rx(sk);
+	tls_sw_free_ctx_rx(tls_ctx);
+}
+
 /* The work handler to transmitt the encrypted records in tx_list */
 static void tx_work_handler(struct work_struct *work)
 {

