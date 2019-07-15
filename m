Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4337969D0D
	for <lists+netdev@lfdr.de>; Mon, 15 Jul 2019 22:49:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732348AbfGOUtc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 16:49:32 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:41639 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729505AbfGOUtb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jul 2019 16:49:31 -0400
Received: by mail-ot1-f68.google.com with SMTP id o101so18533062ota.8;
        Mon, 15 Jul 2019 13:49:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=vmW6M38859vActXSBpqLHrDceWezbmKov04rtR+CpkU=;
        b=NQFF6mr6UoRsUaQEJmUehwrHUvePKXsc1oSGcn0KoDkwGFZ5Qo3DFimZxWIW9EkaH5
         NF9iJvE5iSZHAQrag8VeC85EwqRio6qXKkBZ3w6pL8q9oHgL5XyHBged77omwIr5LO9e
         upk6pp+blH5VsFb9Stqm4/DYVr6u6x0Fgdw3DmaiH6U+OQVbS4Qo9GIk8rwNziz/un9X
         lHGMGGR2hppG6IolQt52Wn4D1pu9z1/i8N8olOgaGddY1lxvWjqzAq09KtL5OxBt4Sjg
         otI2vqngR2y/Iw4p43AyIkxUHx1FslS2KdlwCfTukpaJPO+UNaTtlvZi/rocVmtYcNt3
         rRLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=vmW6M38859vActXSBpqLHrDceWezbmKov04rtR+CpkU=;
        b=hly4e4jD9l1xTYRDfEhVp224DVT0HlcI+YFKp07E8Vcu/kU/BqXPUQzBEGAPiHx+K9
         XgHMB8vCpjO71bW8KDjWMZHM+K0nU1aqBMdoDXajByWoTsMz6iaL+CCsYPSpTsMo2GCq
         KHupprBc2Bw4kwWziCiPLY27HYsTZ6VeWwQDFF8gw8y+sdtCGNNwAbfV2wxSIzCn2aYY
         IwISUqidvQA6g8DeNaO+Zpt9BY5cCKTR+81p7pAJbgaLdsmIsoGtA/3J42RP7s7jIG58
         n9g4PFfU/2c4GzX7/j2HWd+rx+kS/KxhWS/kYm4YWnwCMYbVuqEzo4TfLXlSQKJ/7XNl
         cu3Q==
X-Gm-Message-State: APjAAAVGRdZ/ewvvu8PWpmyHwTqM3R10vSBCbJmmIjT3EdhaOvderNeH
        tdTIhb4KdLa/X6LR94KEv1g=
X-Google-Smtp-Source: APXvYqzjl3rAa+33Rdb6bsu3pGPhRZdI3en8kwNMYx7Pz2Hv6Q9Viet+vL1VxPicbJIrs0jkp3dNPw==
X-Received: by 2002:a05:6830:154e:: with SMTP id l14mr20206506otp.365.1563223770653;
        Mon, 15 Jul 2019 13:49:30 -0700 (PDT)
Received: from [127.0.1.1] ([99.0.85.34])
        by smtp.gmail.com with ESMTPSA id u17sm6232175oif.11.2019.07.15.13.49.29
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 15 Jul 2019 13:49:30 -0700 (PDT)
Subject: [bpf PATCH v3 4/8] bpf: tls fix transition through disconnect with
 close
From:   John Fastabend <john.fastabend@gmail.com>
To:     jakub.kicinski@netronome.com, ast@kernel.org, daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, edumazet@google.com,
        john.fastabend@gmail.com, bpf@vger.kernel.org
Date:   Mon, 15 Jul 2019 13:49:29 -0700
Message-ID: <156322376920.18678.2076367069324125104.stgit@john-XPS-13-9370>
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

It is possible (via shutdown()) for TCP socks to go through TCP_CLOSE
state via tcp_dosconnect() without actually calling tcp_close which
would then call the tls close callback. Because of this a user could
disconnect a socket then put it in a LISTEN state which would break
our assumptions about sockets always being ESTABLISHED state.

More directly because close() can call unhash() and unhash is
implemented by sockmap if a sockmap socket has TLS enabled we can
incorrectly destroy the psock from unhash() and then call its close
handler again. But because the psock (sockmap socket representation)
is already destroyed we call close handler in sk->prot. However,
in some cases (TLS BASE/BASE case) this will still point at the
sockmap close handler resulting in a circular call and crash reported
by syzbot.

To fix both above issues implement the unhash() routine for TLS.

Fixes: 3c4d7559159bf ("tls: kernel TLS support")
Reported-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 include/net/tls.h  |    5 ++++-
 net/tls/tls_main.c |   57 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 61 insertions(+), 1 deletion(-)

diff --git a/include/net/tls.h b/include/net/tls.h
index 72ddd16de056..79ef7049375d 100644
--- a/include/net/tls.h
+++ b/include/net/tls.h
@@ -251,6 +251,8 @@ struct tls_context {
 	u8 tx_conf:3;
 	u8 rx_conf:3;
 
+	struct proto *sk_proto;
+
 	int (*push_pending_record)(struct sock *sk, int flags);
 	void (*sk_write_space)(struct sock *sk);
 
@@ -288,6 +290,8 @@ struct tls_context {
 
 	struct list_head list;
 	refcount_t refcount;
+
+	struct work_struct gc;
 };
 
 enum tls_offload_ctx_dir {
@@ -359,7 +363,6 @@ void tls_sw_strparser_done(struct tls_context *tls_ctx);
 int tls_sw_sendmsg(struct sock *sk, struct msghdr *msg, size_t size);
 int tls_sw_sendpage(struct sock *sk, struct page *page,
 		    int offset, size_t size, int flags);
-void tls_sw_close(struct sock *sk, long timeout);
 void tls_sw_cancel_work_tx(struct tls_context *tls_ctx);
 void tls_sw_free_resources_tx(struct sock *sk);
 void tls_sw_free_resources_rx(struct sock *sk);
diff --git a/net/tls/tls_main.c b/net/tls/tls_main.c
index 9f4a9da182ae..f4cb0522fa95 100644
--- a/net/tls/tls_main.c
+++ b/net/tls/tls_main.c
@@ -251,6 +251,35 @@ static void tls_write_space(struct sock *sk)
 	ctx->sk_write_space(sk);
 }
 
+static void tls_ctx_free_deferred(struct work_struct *gc)
+{
+	struct tls_context *ctx = container_of(gc, struct tls_context, gc);
+
+	if (ctx->rx_conf == TLS_SW || ctx->rx_conf == TLS_HW)
+		tls_sw_strparser_done(ctx);
+
+	if (ctx->rx_conf == TLS_SW)
+		tls_sw_free_ctx_rx(ctx);
+
+	/* Ensure any remaining work items are completed. The sk will
+	 * already have lost its tls_ctx reference by the time we get
+	 * here so no xmit operation will actually be performed.
+	 */
+	tls_sw_cancel_work_tx(ctx);
+	kfree(ctx);
+}
+
+static void tls_ctx_free_wq(struct tls_context *ctx)
+{
+	if (!ctx)
+		return;
+
+	memzero_explicit(&ctx->crypto_send, sizeof(ctx->crypto_send));
+	memzero_explicit(&ctx->crypto_recv, sizeof(ctx->crypto_recv));
+	INIT_WORK(&ctx->gc, tls_ctx_free_deferred);
+	schedule_work(&ctx->gc);
+}
+
 void tls_ctx_free(struct tls_context *ctx)
 {
 	if (!ctx)
@@ -288,6 +317,27 @@ static void tls_sk_proto_cleanup(struct sock *sk,
 #endif
 }
 
+static void tls_sk_proto_unhash(struct sock *sk)
+{
+	struct inet_connection_sock *icsk = inet_csk(sk);
+	long timeo = sock_sndtimeo(sk, 0);
+	struct tls_context *ctx;
+
+	if (unlikely(!icsk->icsk_ulp_data)) {
+		if (sk->sk_prot->unhash)
+			sk->sk_prot->unhash(sk);
+	}
+
+	ctx = tls_get_ctx(sk);
+	if (ctx->tx_conf == TLS_SW || ctx->rx_conf == TLS_SW)
+		tls_sk_proto_cleanup(sk, ctx, timeo);
+	icsk->icsk_ulp_data = NULL;
+	tls_ctx_free_wq(ctx);
+
+	if (ctx->unhash)
+		ctx->unhash(sk);
+}
+
 static void tls_sk_proto_close(struct sock *sk, long timeout)
 {
 	void (*sk_proto_close)(struct sock *sk, long timeout);
@@ -306,6 +356,7 @@ static void tls_sk_proto_close(struct sock *sk, long timeout)
 	if (ctx->tx_conf == TLS_BASE && ctx->rx_conf == TLS_BASE)
 		goto skip_tx_cleanup;
 
+	sk->sk_prot = ctx->sk_proto;
 	tls_sk_proto_cleanup(sk, ctx, timeo);
 
 skip_tx_cleanup:
@@ -611,6 +662,7 @@ static struct tls_context *create_ctx(struct sock *sk)
 	ctx->setsockopt = sk->sk_prot->setsockopt;
 	ctx->getsockopt = sk->sk_prot->getsockopt;
 	ctx->sk_proto_close = sk->sk_prot->close;
+	ctx->unhash = sk->sk_prot->unhash;
 	return ctx;
 }
 
@@ -734,20 +786,24 @@ static void build_protos(struct proto prot[TLS_NUM_CONFIG][TLS_NUM_CONFIG],
 	prot[TLS_BASE][TLS_BASE].setsockopt	= tls_setsockopt;
 	prot[TLS_BASE][TLS_BASE].getsockopt	= tls_getsockopt;
 	prot[TLS_BASE][TLS_BASE].close		= tls_sk_proto_close;
+	prot[TLS_BASE][TLS_BASE].unhash		= tls_sk_proto_unhash;
 
 	prot[TLS_SW][TLS_BASE] = prot[TLS_BASE][TLS_BASE];
 	prot[TLS_SW][TLS_BASE].sendmsg		= tls_sw_sendmsg;
 	prot[TLS_SW][TLS_BASE].sendpage		= tls_sw_sendpage;
+	prot[TLS_SW][TLS_BASE].unhash		= tls_sk_proto_unhash;
 
 	prot[TLS_BASE][TLS_SW] = prot[TLS_BASE][TLS_BASE];
 	prot[TLS_BASE][TLS_SW].recvmsg		  = tls_sw_recvmsg;
 	prot[TLS_BASE][TLS_SW].stream_memory_read = tls_sw_stream_read;
 	prot[TLS_BASE][TLS_SW].close		  = tls_sk_proto_close;
+	prot[TLS_BASE][TLS_SW].unhash		  = tls_sk_proto_unhash;
 
 	prot[TLS_SW][TLS_SW] = prot[TLS_SW][TLS_BASE];
 	prot[TLS_SW][TLS_SW].recvmsg		= tls_sw_recvmsg;
 	prot[TLS_SW][TLS_SW].stream_memory_read	= tls_sw_stream_read;
 	prot[TLS_SW][TLS_SW].close		= tls_sk_proto_close;
+	prot[TLS_SW][TLS_SW].unhash		= tls_sk_proto_unhash;
 
 #ifdef CONFIG_TLS_DEVICE
 	prot[TLS_HW][TLS_BASE] = prot[TLS_BASE][TLS_BASE];
@@ -798,6 +854,7 @@ static int tls_init(struct sock *sk)
 	tls_build_proto(sk);
 	ctx->tx_conf = TLS_BASE;
 	ctx->rx_conf = TLS_BASE;
+	ctx->sk_proto = sk->sk_prot;
 	update_sk_prot(sk, ctx);
 out:
 	return rc;

