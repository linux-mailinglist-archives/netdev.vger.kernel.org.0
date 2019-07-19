Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6B8C6EA23
	for <lists+netdev@lfdr.de>; Fri, 19 Jul 2019 19:31:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731402AbfGSRbI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jul 2019 13:31:08 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:33067 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731375AbfGSRbH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jul 2019 13:31:07 -0400
Received: by mail-qk1-f196.google.com with SMTP id r6so23829774qkc.0
        for <netdev@vger.kernel.org>; Fri, 19 Jul 2019 10:31:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HkLi9ptiD3MqkGw6P8g48rWja6Y63KF9uag9xMtFkaQ=;
        b=Z8YUnF/eb0jywFQ/twCEg+8bl0KzThHm4s9UcAfKJcWpehKSz1uO5LgAklcgUPG9Ll
         i6aLzT3//xzrp9/4CY1AhnQRBwzHsyR3962dpIHl2FlpVw3ELKiqC3gEa1YZMYzIrIlA
         U4+QDZ98f9Xgq0L27q5mtJAfxXIzgXEgrfC99nrWHWpfxVPfVRGtsmtYkEpQp3Tlw31W
         pJiGPJWqcxBXxYoTsbo24cDwRdo/Kosw+RSEz747P//+d/BkB5klSJV3RWtQcO+GCKcU
         oxQZ9P3IUdsDM1BnvMcXetDWQEnTV+VgdyVO7gh+d31/3yhteeEH+YGFlhx73sLM5Os1
         qwYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HkLi9ptiD3MqkGw6P8g48rWja6Y63KF9uag9xMtFkaQ=;
        b=VQ9B3oKCcsyHGfw/9m4N5BWwXcz5ggHA4FxIMjQ62V+fBccBHl/7SyPNbQ7LSTTjuc
         XSJSai6rWmbNrb1I5j6EaAnXvcGYDwMJZx3vUIk3nMrhYckrw8Gvs5NqMIWuEOGI5xXE
         0F5GxPUtZuK6iFwUMrD05y6NQzZn/TCs6x1/6UKtPUHmeCg/quw/TG15RnlYbTeIo+ZS
         K2HL/xMu5cATf4InwmBx8CDHk+aJBn15t9qv1ehQHzj/smCz7iCGutyY4bo39RApJxk2
         fJoSao3/hGjUzlr33KBdaeJwWho0F92W5B33h7/9gF7UOj33FipK4m2Vmq2hn+ZxEKoO
         QPbA==
X-Gm-Message-State: APjAAAXY7rIWyZa31V2C/9G5rJPSQnuAfA5Om28bO0lIEGdVYNGx5b2X
        vNPTgxEusuOFHjYQkqcWyqtxbA==
X-Google-Smtp-Source: APXvYqyUOPWO0mbH8TtgeIPNC+qfH8OQIq1yg6LLmRhXvdjKOMVBHYAWkg9+E5lI4J3AYYUU0UGMHw==
X-Received: by 2002:a37:6248:: with SMTP id w69mr36096489qkb.225.1563557466695;
        Fri, 19 Jul 2019 10:31:06 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id y3sm15568509qtj.46.2019.07.19.10.31.05
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 19 Jul 2019 10:31:06 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     john.fastabend@gmail.com, alexei.starovoitov@gmail.com,
        daniel@iogearbox.net
Cc:     edumazet@google.com, netdev@vger.kernel.org, bpf@vger.kernel.org,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Dirk van der Merwe <dirk.vandermerwe@netronome.com>
Subject: [PATCH bpf v4 04/14] net/tls: remove sock unlock/lock around strp_done()
Date:   Fri, 19 Jul 2019 10:29:17 -0700
Message-Id: <20190719172927.18181-5-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190719172927.18181-1-jakub.kicinski@netronome.com>
References: <20190719172927.18181-1-jakub.kicinski@netronome.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: John Fastabend <john.fastabend@gmail.com>

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
 include/net/tls.h    |  7 ++---
 net/tls/tls_device.c |  1 -
 net/tls/tls_main.c   | 61 ++++++++++++++++++++++----------------------
 net/tls/tls_sw.c     | 40 +++++++++++++++++++++--------
 4 files changed, 64 insertions(+), 45 deletions(-)

diff --git a/include/net/tls.h b/include/net/tls.h
index d4276cb6de53..235508e35fd4 100644
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
@@ -357,14 +355,17 @@ int tls_sk_attach(struct sock *sk, int optname, char __user *optval,
 
 int tls_set_sw_offload(struct sock *sk, struct tls_context *ctx, int tx);
 void tls_sw_strparser_arm(struct sock *sk, struct tls_context *ctx);
+void tls_sw_strparser_done(struct tls_context *tls_ctx);
 int tls_sw_sendmsg(struct sock *sk, struct msghdr *msg, size_t size);
 int tls_sw_sendpage(struct sock *sk, struct page *page,
 		    int offset, size_t size, int flags);
 void tls_sw_close(struct sock *sk, long timeout);
 void tls_sw_cancel_work_tx(struct tls_context *tls_ctx);
-void tls_sw_free_resources_tx(struct sock *sk);
+void tls_sw_release_resources_tx(struct sock *sk);
+void tls_sw_free_ctx_tx(struct tls_context *tls_ctx);
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
index 5c29b410cf7d..d152a00a7a27 100644
--- a/net/tls/tls_main.c
+++ b/net/tls/tls_main.c
@@ -261,24 +261,9 @@ void tls_ctx_free(struct tls_context *ctx)
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
-	if (ctx->tx_conf == TLS_BASE && ctx->rx_conf == TLS_BASE) {
-		free_ctx = true;
-		goto skip_tx_cleanup;
-	}
-
 	if (unlikely(sk->sk_write_pending) &&
 	    !wait_on_pending_writer(sk, &timeo))
 		tls_handle_open_record(sk, 0);
@@ -287,7 +272,7 @@ static void tls_sk_proto_close(struct sock *sk, long timeout)
 	if (ctx->tx_conf == TLS_SW) {
 		kfree(ctx->tx.rec_seq);
 		kfree(ctx->tx.iv);
-		tls_sw_free_resources_tx(sk);
+		tls_sw_release_resources_tx(sk);
 #ifdef CONFIG_TLS_DEVICE
 	} else if (ctx->tx_conf == TLS_HW) {
 		tls_device_free_resources_tx(sk);
@@ -295,26 +280,40 @@ static void tls_sk_proto_close(struct sock *sk, long timeout)
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
+	bool free_ctx;
+
+	if (ctx->tx_conf == TLS_SW)
+		tls_sw_cancel_work_tx(ctx);
+
+	lock_sock(sk);
+	free_ctx = ctx->tx_conf != TLS_HW && ctx->rx_conf != TLS_HW;
+	sk_proto_close = ctx->sk_proto_close;
+
+	if (ctx->tx_conf != TLS_BASE || ctx->rx_conf != TLS_BASE)
+		tls_sk_proto_cleanup(sk, ctx, timeo);
 
-skip_tx_cleanup:
 	release_sock(sk);
+	if (ctx->tx_conf == TLS_SW)
+		tls_sw_free_ctx_tx(ctx);
+	if (ctx->rx_conf == TLS_SW || ctx->rx_conf == TLS_HW)
+		tls_sw_strparser_done(ctx);
+	if (ctx->rx_conf == TLS_SW)
+		tls_sw_free_ctx_rx(ctx);
 	sk_proto_close(sk, timeout);
-	/* free ctx for TLS_HW_RECORD, used by tcp_set_state
-	 * for sk->sk_prot->unhash [tls_hw_unhash]
-	 */
+
 	if (free_ctx)
 		tls_ctx_free(ctx);
 }
@@ -541,9 +540,9 @@ static int do_tls_setsockopt_conf(struct sock *sk, char __user *optval,
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
index 38c0e53c727d..91d21b048a9b 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -2063,7 +2063,7 @@ void tls_sw_cancel_work_tx(struct tls_context *tls_ctx)
 	cancel_delayed_work_sync(&ctx->tx_work.work);
 }
 
-void tls_sw_free_resources_tx(struct sock *sk)
+void tls_sw_release_resources_tx(struct sock *sk)
 {
 	struct tls_context *tls_ctx = tls_get_ctx(sk);
 	struct tls_sw_context_tx *ctx = tls_sw_ctx_tx(tls_ctx);
@@ -2096,6 +2096,11 @@ void tls_sw_free_resources_tx(struct sock *sk)
 
 	crypto_free_aead(ctx->aead_send);
 	tls_free_open_rec(sk);
+}
+
+void tls_sw_free_ctx_tx(struct tls_context *tls_ctx)
+{
+	struct tls_sw_context_tx *ctx = tls_sw_ctx_tx(tls_ctx);
 
 	kfree(ctx);
 }
@@ -2114,25 +2119,40 @@ void tls_sw_release_resources_rx(struct sock *sk)
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
-- 
2.21.0

