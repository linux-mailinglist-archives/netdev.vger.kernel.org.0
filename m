Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9426E6EA39
	for <lists+netdev@lfdr.de>; Fri, 19 Jul 2019 19:31:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731422AbfGSRbL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jul 2019 13:31:11 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:44553 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729410AbfGSRbJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jul 2019 13:31:09 -0400
Received: by mail-qt1-f195.google.com with SMTP id 44so803078qtg.11
        for <netdev@vger.kernel.org>; Fri, 19 Jul 2019 10:31:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XtaTC8x/bvaAxD+ukazd4a/fS+Iy7H2AHJmoedmwCMw=;
        b=l2FlBjZGRqPUHVIR9lV0+yQOn5T/HN6DyShHX9rmmZhEVRMEYaOM/H9pjR8sYpVg8X
         eVap05NlCx6ySeMitrmxqmcww4DwiciR9hrWMKsCmbRaNnXFbeNU5di3zM1buw4cS2SO
         wnxU3uKY4dXAIHE8ygbJquZlMJEpxGZOoxRyfKByw6W6hf8ajWKMsKbazDAUTXrCh3Yq
         gH+O/n8TWtzN8LrLzoki/McrXWQTMV7vUaxZ6DYuWMgZcl179JzUBehaUsvQONJERL7O
         lpQWKcKsv4m25Tki6YVq44PXXD91fu9wRsPItuCk+mxLv2oY4dTdqMwaLXTuMlhpItSa
         wVmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XtaTC8x/bvaAxD+ukazd4a/fS+Iy7H2AHJmoedmwCMw=;
        b=hhaOeuDa97DbYJSnRsuOrZ3Ljjm2W/xO4GJn/VxmsCQaNcZdYbh86BHsx9GYO3Gvu7
         TYbEIy4XrKJVk+9aeg5PP50ypKqaN7tBs/Chn9J07MARt5QO4oRZfH2KqHG5L80SoAxF
         55clK57ufKbJyahgicrYcS6maS4rnOu2FW/upmIjH6jzblSd6hQdBzoGS0mQ9oc7f15t
         iO6L/HMrike6mgV3gozqwCc7utdKQFqblqhNnsIQdQp3MVRQ1SphEpo4Zya1PDagK4Do
         zfQY2gJdQ0Sx3wJ37SeJ6UllP9SpxNgjek+lyTe2U9wE8fc3tBiPsG7lwZgaxwDhoAet
         vNTQ==
X-Gm-Message-State: APjAAAUPI2vI0SgHoyBW9Hw/jF3HMra4KDfuP2MYOMvqqaVGoi464a1w
        tn+AFlxHTnOeZ7cRiRubPu8zYQ==
X-Google-Smtp-Source: APXvYqyjV+3YoKg1hO2yE45IqBUirtSv2McHM/X1239U2kfpgiwvLtyoNx6b+7Ztu6f//GCUkctiNg==
X-Received: by 2002:ac8:2774:: with SMTP id h49mr36469409qth.97.1563557468036;
        Fri, 19 Jul 2019 10:31:08 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id y3sm15568509qtj.46.2019.07.19.10.31.06
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 19 Jul 2019 10:31:07 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     john.fastabend@gmail.com, alexei.starovoitov@gmail.com,
        daniel@iogearbox.net
Cc:     edumazet@google.com, netdev@vger.kernel.org, bpf@vger.kernel.org,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: [PATCH bpf v4 05/14] net/tls: fix transition through disconnect with close
Date:   Fri, 19 Jul 2019 10:29:18 -0700
Message-Id: <20190719172927.18181-6-jakub.kicinski@netronome.com>
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

It is possible (via shutdown()) for TCP socks to go through TCP_CLOSE
state via tcp_disconnect() without actually calling tcp_close which
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

v4:
 - add note about tls offload still needing the fix;
 - move sk_proto to the cold cache line;
 - split TX context free into "release" and "free",
   otherwise the GC work itself is in already freed
   memory;
 - more TX before RX for consistency;
 - reuse tls_ctx_free();
 - schedule the GC work after we're done with context
   to avoid UAF;
 - don't set the unhash in all modes, all modes "inherit"
   TLS_BASE's callbacks anyway;
 - disable the unhash hook for TLS_HW.

Fixes: 3c4d7559159bf ("tls: kernel TLS support")
Reported-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
---
 Documentation/networking/tls-offload.rst |  6 +++
 include/net/tls.h                        |  5 ++-
 net/tls/tls_main.c                       | 55 ++++++++++++++++++++++++
 3 files changed, 65 insertions(+), 1 deletion(-)

diff --git a/Documentation/networking/tls-offload.rst b/Documentation/networking/tls-offload.rst
index 048e5ca44824..8a1eeb393316 100644
--- a/Documentation/networking/tls-offload.rst
+++ b/Documentation/networking/tls-offload.rst
@@ -513,3 +513,9 @@ Redirects leak clear text
 
 In the RX direction, if segment has already been decrypted by the device
 and it gets redirected or mirrored - clear text will be transmitted out.
+
+shutdown() doesn't clear TLS state
+----------------------------------
+
+shutdown() system call allows for a TLS socket to be reused as a different
+connection. Offload doesn't currently handle that.
diff --git a/include/net/tls.h b/include/net/tls.h
index 235508e35fd4..9e425ac2de45 100644
--- a/include/net/tls.h
+++ b/include/net/tls.h
@@ -271,6 +271,8 @@ struct tls_context {
 	unsigned long flags;
 
 	/* cache cold stuff */
+	struct proto *sk_proto;
+
 	void (*sk_destruct)(struct sock *sk);
 	void (*sk_proto_close)(struct sock *sk, long timeout);
 
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
 void tls_sw_release_resources_tx(struct sock *sk);
 void tls_sw_free_ctx_tx(struct tls_context *tls_ctx);
diff --git a/net/tls/tls_main.c b/net/tls/tls_main.c
index d152a00a7a27..48f1c26459d0 100644
--- a/net/tls/tls_main.c
+++ b/net/tls/tls_main.c
@@ -261,6 +261,33 @@ void tls_ctx_free(struct tls_context *ctx)
 	kfree(ctx);
 }
 
+static void tls_ctx_free_deferred(struct work_struct *gc)
+{
+	struct tls_context *ctx = container_of(gc, struct tls_context, gc);
+
+	/* Ensure any remaining work items are completed. The sk will
+	 * already have lost its tls_ctx reference by the time we get
+	 * here so no xmit operation will actually be performed.
+	 */
+	if (ctx->tx_conf == TLS_SW) {
+		tls_sw_cancel_work_tx(ctx);
+		tls_sw_free_ctx_tx(ctx);
+	}
+
+	if (ctx->rx_conf == TLS_SW) {
+		tls_sw_strparser_done(ctx);
+		tls_sw_free_ctx_rx(ctx);
+	}
+
+	tls_ctx_free(ctx);
+}
+
+static void tls_ctx_free_wq(struct tls_context *ctx)
+{
+	INIT_WORK(&ctx->gc, tls_ctx_free_deferred);
+	schedule_work(&ctx->gc);
+}
+
 static void tls_sk_proto_cleanup(struct sock *sk,
 				 struct tls_context *ctx, long timeo)
 {
@@ -288,6 +315,26 @@ static void tls_sk_proto_cleanup(struct sock *sk,
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
+	tls_sk_proto_cleanup(sk, ctx, timeo);
+	icsk->icsk_ulp_data = NULL;
+
+	if (ctx->sk_proto->unhash)
+		ctx->sk_proto->unhash(sk);
+	tls_ctx_free_wq(ctx);
+}
+
 static void tls_sk_proto_close(struct sock *sk, long timeout)
 {
 	void (*sk_proto_close)(struct sock *sk, long timeout);
@@ -305,6 +352,7 @@ static void tls_sk_proto_close(struct sock *sk, long timeout)
 	if (ctx->tx_conf != TLS_BASE || ctx->rx_conf != TLS_BASE)
 		tls_sk_proto_cleanup(sk, ctx, timeo);
 
+	sk->sk_prot = ctx->sk_proto;
 	release_sock(sk);
 	if (ctx->tx_conf == TLS_SW)
 		tls_sw_free_ctx_tx(ctx);
@@ -608,6 +656,7 @@ static struct tls_context *create_ctx(struct sock *sk)
 	ctx->setsockopt = sk->sk_prot->setsockopt;
 	ctx->getsockopt = sk->sk_prot->getsockopt;
 	ctx->sk_proto_close = sk->sk_prot->close;
+	ctx->unhash = sk->sk_prot->unhash;
 	return ctx;
 }
 
@@ -731,6 +780,7 @@ static void build_protos(struct proto prot[TLS_NUM_CONFIG][TLS_NUM_CONFIG],
 	prot[TLS_BASE][TLS_BASE].setsockopt	= tls_setsockopt;
 	prot[TLS_BASE][TLS_BASE].getsockopt	= tls_getsockopt;
 	prot[TLS_BASE][TLS_BASE].close		= tls_sk_proto_close;
+	prot[TLS_BASE][TLS_BASE].unhash		= tls_sk_proto_unhash;
 
 	prot[TLS_SW][TLS_BASE] = prot[TLS_BASE][TLS_BASE];
 	prot[TLS_SW][TLS_BASE].sendmsg		= tls_sw_sendmsg;
@@ -748,16 +798,20 @@ static void build_protos(struct proto prot[TLS_NUM_CONFIG][TLS_NUM_CONFIG],
 
 #ifdef CONFIG_TLS_DEVICE
 	prot[TLS_HW][TLS_BASE] = prot[TLS_BASE][TLS_BASE];
+	prot[TLS_HW][TLS_BASE].unhash		= base->unhash;
 	prot[TLS_HW][TLS_BASE].sendmsg		= tls_device_sendmsg;
 	prot[TLS_HW][TLS_BASE].sendpage		= tls_device_sendpage;
 
 	prot[TLS_HW][TLS_SW] = prot[TLS_BASE][TLS_SW];
+	prot[TLS_HW][TLS_SW].unhash		= base->unhash;
 	prot[TLS_HW][TLS_SW].sendmsg		= tls_device_sendmsg;
 	prot[TLS_HW][TLS_SW].sendpage		= tls_device_sendpage;
 
 	prot[TLS_BASE][TLS_HW] = prot[TLS_BASE][TLS_SW];
+	prot[TLS_BASE][TLS_HW].unhash		= base->unhash;
 
 	prot[TLS_SW][TLS_HW] = prot[TLS_SW][TLS_SW];
+	prot[TLS_SW][TLS_HW].unhash		= base->unhash;
 
 	prot[TLS_HW][TLS_HW] = prot[TLS_HW][TLS_SW];
 #endif
@@ -794,6 +848,7 @@ static int tls_init(struct sock *sk)
 	tls_build_proto(sk);
 	ctx->tx_conf = TLS_BASE;
 	ctx->rx_conf = TLS_BASE;
+	ctx->sk_proto = sk->sk_prot;
 	update_sk_prot(sk, ctx);
 out:
 	return rc;
-- 
2.21.0

