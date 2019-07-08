Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3128762919
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 21:14:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391500AbfGHTOS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 15:14:18 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:43697 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728827AbfGHTOS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 15:14:18 -0400
Received: by mail-io1-f67.google.com with SMTP id k20so37740378ios.10;
        Mon, 08 Jul 2019 12:14:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=hXIgA+39NNFcF6s8vWmNwPku9P6vco1srrmA0dk8IiQ=;
        b=LZVUkVTjXxiLLVo4olzoO2KCaynPTs+KBAmkmRw90vnekLx8GCNhN21rPPYCuS+1Rq
         9cipQgCBTNPAHYXu3ZBUPAlj8nfs9Y5w2ALd3RR6dOmBxb1C/DS10x7lTgM/6isOVCzm
         0mn9sBLG9hrJZ2kIOgxgx3ngUd5LIKLt6ETdPFjVg/aO/cCqjmKeu2znWqpFd+PtuRi4
         1M8+wpHFIuu4gJKZ/v7fNMQVsrD7Y8pLTfbDWg+0NBAS7LMYMKrlbgy3LhiVe7BQmDAv
         YuK5usjyYPspILrpWX3U0A10Q+cfhgG2FB+DYpI7QYVJBkucgh7j/05rUYoScvyfJR0u
         EhCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=hXIgA+39NNFcF6s8vWmNwPku9P6vco1srrmA0dk8IiQ=;
        b=MUaZmvyji3kLunPJ+la4TFQro86HlF1wk47DwpOyfS6w8VacM5qzTYnvZzXgtPcXg+
         YPrLcbfDMkRrBpXQM88zi0AnObVmdfRe92hce7Ia/MRyn7xKbd33NbR1G0rVI3WCoWja
         o7u2LxFAIkNUW1ls72WD/FCSJz3uT2HWLeD8a70ZZjyTa/LERN2gdKfeBLv6ZX3YdCkN
         nDPDt0ttVK91pAdS4HDFLX/qx4vC6TX5rZv20XWpJijhnJBA9DA9rys19MKc5cmvFmm3
         MszLAYdhLlDTXHowTlTZDbFzu+kbN3Uxe7sM8iTo6+ijzckX6O62SzyC6JasLX1hVbqB
         PcFw==
X-Gm-Message-State: APjAAAWxsrQYR2fTfJc3NrxImlR0w89J6prv4SBnwWNaEnlRc+oARH9u
        rt3JPGKAx5CBOuztLBrDSc8=
X-Google-Smtp-Source: APXvYqxavi6I2MhtcfpvFdaPFH1fV2WxDLS1yOqRVTBz/gjL+DAeAEZq2KNB8Dc0ezMxJ+kjUi+xqg==
X-Received: by 2002:a05:6602:2289:: with SMTP id d9mr21319341iod.47.1562613257267;
        Mon, 08 Jul 2019 12:14:17 -0700 (PDT)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id n22sm10030848iob.37.2019.07.08.12.14.10
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 08 Jul 2019 12:14:16 -0700 (PDT)
Subject: [bpf PATCH v2 2/6] bpf: tls fix transition through disconnect with
 close
From:   John Fastabend <john.fastabend@gmail.com>
To:     jakub.kicinski@netronome.com, ast@kernel.org, daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, edumazet@google.com,
        john.fastabend@gmail.com, bpf@vger.kernel.org
Date:   Mon, 08 Jul 2019 19:14:05 +0000
Message-ID: <156261324561.31108.14410711674221391677.stgit@ubuntu3-kvm1>
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
 include/net/tls.h  |    6 +++++-
 net/tls/tls_main.c |   54 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 59 insertions(+), 1 deletion(-)

diff --git a/include/net/tls.h b/include/net/tls.h
index 0a3540a6304d..2a98d0584999 100644
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
@@ -356,7 +360,7 @@ int tls_set_sw_offload(struct sock *sk, struct tls_context *ctx, int tx);
 int tls_sw_sendmsg(struct sock *sk, struct msghdr *msg, size_t size);
 int tls_sw_sendpage(struct sock *sk, struct page *page,
 		    int offset, size_t size, int flags);
-void tls_sw_close(struct sock *sk, long timeout);
+void tls_sw_cancel_work_tx(struct tls_context *tls_ctx);
 void tls_sw_free_resources_tx(struct sock *sk);
 void tls_sw_free_resources_rx(struct sock *sk);
 void tls_sw_release_resources_rx(struct sock *sk);
diff --git a/net/tls/tls_main.c b/net/tls/tls_main.c
index d63c3583d2f7..e8418456ee24 100644
--- a/net/tls/tls_main.c
+++ b/net/tls/tls_main.c
@@ -251,6 +251,32 @@ static void tls_write_space(struct sock *sk)
 	ctx->sk_write_space(sk);
 }
 
+static void tls_ctx_free_deferred(struct work_struct *gc)
+{
+	struct tls_context *ctx = container_of(gc, struct tls_context, gc);
+
+	if (ctx->rx_conf == TLS_SW)
+		tls_sw_release_strp_rx(ctx);
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
 static void tls_ctx_free(struct tls_context *ctx)
 {
 	if (!ctx)
@@ -287,6 +313,27 @@ static void tls_sk_proto_cleanup(struct sock *sk,
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
 	struct tls_context *ctx = tls_get_ctx(sk);
@@ -305,6 +352,7 @@ static void tls_sk_proto_close(struct sock *sk, long timeout)
 	if (ctx->tx_conf == TLS_BASE && ctx->rx_conf == TLS_BASE)
 		goto skip_tx_cleanup;
 
+	sk->sk_prot = ctx->sk_proto;
 	tls_sk_proto_cleanup(sk, ctx, timeo);
 
 skip_tx_cleanup:
@@ -606,6 +654,7 @@ static struct tls_context *create_ctx(struct sock *sk)
 	ctx->setsockopt = sk->sk_prot->setsockopt;
 	ctx->getsockopt = sk->sk_prot->getsockopt;
 	ctx->sk_proto_close = sk->sk_prot->close;
+	ctx->unhash = sk->sk_prot->unhash;
 	return ctx;
 }
 
@@ -729,20 +778,24 @@ static void build_protos(struct proto prot[TLS_NUM_CONFIG][TLS_NUM_CONFIG],
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
@@ -793,6 +846,7 @@ static int tls_init(struct sock *sk)
 	tls_build_proto(sk);
 	ctx->tx_conf = TLS_BASE;
 	ctx->rx_conf = TLS_BASE;
+	ctx->sk_proto = sk->sk_prot;
 	update_sk_prot(sk, ctx);
 out:
 	return rc;

