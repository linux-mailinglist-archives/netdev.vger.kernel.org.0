Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5C2B58890
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 19:36:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726913AbfF0Rgu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 13:36:50 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:35499 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726901AbfF0Rgu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 13:36:50 -0400
Received: by mail-pf1-f193.google.com with SMTP id d126so1585390pfd.2;
        Thu, 27 Jun 2019 10:36:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=nAyVVekSlB0wUy48a52kkqnjNBNQOsQG1HeegDUANdU=;
        b=JDr/jdGwkmAuUA7/2v0we3RWeqpjB1oafF4f2UsEfSfjecutu1X0mFjpgbd5uPtlz7
         6bEAXUBS1RbK7Zi1nHm/X/unc5KR4+zKKZ/cqSI+z2X1xkU7ow4HFefszbFiYzje0mJZ
         Cb5fqLH0Ceu8FXRI5dHpRHHn6trHY0ud/PdBsuT3a0zPdqQ6G7g3HV4Emk1XFrDzHR4P
         aXr+rsFOBXoL7PsJ/u0NAd95CNC6e3sIfOP48KG//wJcsDjwoLVV548++kVRNxu7TFki
         s5OgS+xa4NtcctaPgG29CRY+C+MxVYyT5hZCG8M2WjTLgjK5M8O5/ay96g7hYC54wu+P
         IE9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=nAyVVekSlB0wUy48a52kkqnjNBNQOsQG1HeegDUANdU=;
        b=PuVEcAW4hlonaHTNIAIGolGFXEsifxrDX/kBT3/Tu+03U+J6jJTUjlFJFo9K729XMW
         aLfEmKgCqUH46DLeuWo7YydqXSHo7JqQxuwtY250Vt0Eft7okEyqc3zKl/J9Qf4NybGW
         2WzcfYezX+94VQPU/idGBS/ej8tFUJ2RlGM1RNK/+ivQ0FiSwA75vlx5Ei1OWeRLh33f
         8vz40MWPocG8PYdkbL+vGn/ccSYeU6GHC8z0fMPGnWFgBHJ2AudMcX5L1UskDe64e4Il
         CngF3tU0xa/rsMV6pP0Urdrf+ZPk+6j1AFL0JhudeXBVdj3afaMjMMSbEIn/Rk8e6onu
         NHYA==
X-Gm-Message-State: APjAAAX5qeh+Meqm6kSVtasrxIbDUJhOB9h3xorAoEXPAFjD5qHOzgcF
        /HST3oidelKkqZlNNrFhfwI=
X-Google-Smtp-Source: APXvYqxzUoGsrDoGUOaPQ1hecJ00DWkfCUUT3/DDeSfYiUv5EE6JSpvLHXTRXfZV4aJP5HwcWzhYTA==
X-Received: by 2002:a65:6104:: with SMTP id z4mr4818121pgu.319.1561657009110;
        Thu, 27 Jun 2019 10:36:49 -0700 (PDT)
Received: from [127.0.1.1] ([67.136.128.119])
        by smtp.gmail.com with ESMTPSA id f7sm2968790pgc.82.2019.06.27.10.36.48
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 27 Jun 2019 10:36:48 -0700 (PDT)
Subject: [PATCH 2/2] bpf: tls,
 implement unhash to avoid transition out of ESTABLISHED
From:   John Fastabend <john.fastabend@gmail.com>
To:     daniel@iogearbox.io, jakub.kicinski@netronome.com, ast@kernel.org
Cc:     netdev@vger.kernel.org, edumazet@google.com,
        john.fastabend@gmail.com, bpf@vger.kernel.org
Date:   Thu, 27 Jun 2019 10:36:48 -0700
Message-ID: <156165700815.32598.16215539389630396969.stgit@john-XPS-13-9370>
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

It is possible (via shutdown()) for TCP socks to go through TCP_CLOSE
state via tcp_disconnect() without calling into close callback. This
would allow a kTLS enabled socket to exist outside of ESTABLISHED
state which is not supported.

Solve this the same way we solved the sock{map|hash} case by adding
an unhash hook to remove tear down the TLS state.

Tested with bpf and net selftests plus ran syzkaller reproducers
for below listed issues.

Fixes: d91c3e17f75f2 ("net/tls: Only attach to sockets in ESTABLISHED state")
Reported-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot+4207c7f3a443366d8aa2@syzkaller.appspotmail.com
Reported-by: syzbot+06537213db7ba2745c4a@syzkaller.appspotmail.com
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 include/net/tls.h  |    2 ++
 net/tls/tls_main.c |   50 +++++++++++++++++++++++++++++++++++++++++++-------
 2 files changed, 45 insertions(+), 7 deletions(-)

diff --git a/include/net/tls.h b/include/net/tls.h
index 6fe1f5c96f4a..935d65606bb3 100644
--- a/include/net/tls.h
+++ b/include/net/tls.h
@@ -264,6 +264,8 @@ struct tls_context {
 	bool in_tcp_sendpages;
 	bool pending_open_record_frags;
 
+	struct proto *sk_proto;
+
 	int (*push_pending_record)(struct sock *sk, int flags);
 
 	void (*sk_write_space)(struct sock *sk);
diff --git a/net/tls/tls_main.c b/net/tls/tls_main.c
index 51cb19e24dd9..e1750634a53a 100644
--- a/net/tls/tls_main.c
+++ b/net/tls/tls_main.c
@@ -251,11 +251,16 @@ static void tls_write_space(struct sock *sk)
 	ctx->sk_write_space(sk);
 }
 
-static void tls_ctx_free(struct tls_context *ctx)
+static void tls_ctx_free(struct sock *sk, struct tls_context *ctx)
 {
+	struct inet_connection_sock *icsk = inet_csk(sk);
+
 	if (!ctx)
 		return;
 
+	sk->sk_prot = ctx->sk_proto;
+	icsk->icsk_ulp_data = NULL;
+
 	memzero_explicit(&ctx->crypto_send, sizeof(ctx->crypto_send));
 	memzero_explicit(&ctx->crypto_recv, sizeof(ctx->crypto_recv));
 	kfree(ctx);
@@ -287,23 +292,49 @@ static void tls_sk_proto_cleanup(struct sock *sk,
 #endif
 }
 
+static void tls_sk_proto_unhash(struct sock *sk)
+{
+	struct tls_context *ctx = tls_get_ctx(sk);
+	void (*sk_proto_unhash)(struct sock *sk);
+	long timeo = sock_sndtimeo(sk, 0);
+
+	if (unlikely(!ctx)) {
+		if (sk->sk_prot->unhash)
+			sk->sk_prot->unhash(sk);
+		return;
+	}
+
+	sk->sk_prot = ctx->sk_proto;
+	sk_proto_unhash = ctx->unhash;
+	tls_sk_proto_cleanup(sk, ctx, timeo);
+	if (ctx->rx_conf == TLS_SW)
+		tls_sw_release_strp_rx(ctx);
+	tls_ctx_free(sk, ctx);
+	if (sk_proto_unhash)
+		sk_proto_unhash(sk);
+}
+
 static void tls_sk_proto_close(struct sock *sk, long timeout)
 {
 	struct tls_context *ctx = tls_get_ctx(sk);
 	long timeo = sock_sndtimeo(sk, 0);
 	void (*sk_proto_close)(struct sock *sk, long timeout);
-	bool free_ctx = false;
+
+	if (unlikely(!ctx)) {
+		if (sk->sk_prot->close)
+			sk->sk_prot->close(sk, timeout);
+		return;
+	}
 
 	lock_sock(sk);
+	sk->sk_prot = ctx->sk_proto;
 	sk_proto_close = ctx->sk_proto_close;
 
 	if (ctx->tx_conf == TLS_HW_RECORD && ctx->rx_conf == TLS_HW_RECORD)
 		goto skip_tx_cleanup;
 
-	if (ctx->tx_conf == TLS_BASE && ctx->rx_conf == TLS_BASE) {
-		free_ctx = true;
+	if (ctx->tx_conf == TLS_BASE && ctx->rx_conf == TLS_BASE)
 		goto skip_tx_cleanup;
-	}
 
 	tls_sk_proto_cleanup(sk, ctx, timeo);
 
@@ -311,11 +342,12 @@ static void tls_sk_proto_close(struct sock *sk, long timeout)
 	release_sock(sk);
 	if (ctx->rx_conf == TLS_SW)
 		tls_sw_release_strp_rx(ctx);
-	sk_proto_close(sk, timeout);
 
 	if (ctx->tx_conf != TLS_HW && ctx->rx_conf != TLS_HW &&
 	    ctx->tx_conf != TLS_HW_RECORD && ctx->rx_conf != TLS_HW_RECORD)
-		tls_ctx_free(ctx);
+		tls_ctx_free(sk, ctx);
+	if (sk_proto_close)
+		sk_proto_close(sk, timeout);
 }
 
 static int do_tls_getsockopt_tx(struct sock *sk, char __user *optval,
@@ -733,16 +765,19 @@ static void build_protos(struct proto prot[TLS_NUM_CONFIG][TLS_NUM_CONFIG],
 	prot[TLS_SW][TLS_BASE] = prot[TLS_BASE][TLS_BASE];
 	prot[TLS_SW][TLS_BASE].sendmsg		= tls_sw_sendmsg;
 	prot[TLS_SW][TLS_BASE].sendpage		= tls_sw_sendpage;
+	prot[TLS_SW][TLS_BASE].unhash		= tls_sk_proto_unhash;
 
 	prot[TLS_BASE][TLS_SW] = prot[TLS_BASE][TLS_BASE];
 	prot[TLS_BASE][TLS_SW].recvmsg		  = tls_sw_recvmsg;
 	prot[TLS_BASE][TLS_SW].stream_memory_read = tls_sw_stream_read;
 	prot[TLS_BASE][TLS_SW].close		  = tls_sk_proto_close;
+	prot[TLS_BASE][TLS_SW].unhash		= tls_sk_proto_unhash;
 
 	prot[TLS_SW][TLS_SW] = prot[TLS_SW][TLS_BASE];
 	prot[TLS_SW][TLS_SW].recvmsg		= tls_sw_recvmsg;
 	prot[TLS_SW][TLS_SW].stream_memory_read	= tls_sw_stream_read;
 	prot[TLS_SW][TLS_SW].close		= tls_sk_proto_close;
+	prot[TLS_SW][TLS_SW].unhash		= tls_sk_proto_unhash;
 
 #ifdef CONFIG_TLS_DEVICE
 	prot[TLS_HW][TLS_BASE] = prot[TLS_BASE][TLS_BASE];
@@ -793,6 +828,7 @@ static int tls_init(struct sock *sk)
 	tls_build_proto(sk);
 	ctx->tx_conf = TLS_BASE;
 	ctx->rx_conf = TLS_BASE;
+	ctx->sk_proto = sk->sk_prot;
 	update_sk_prot(sk, ctx);
 out:
 	return rc;

