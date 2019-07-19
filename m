Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 864366EA2B
	for <lists+netdev@lfdr.de>; Fri, 19 Jul 2019 19:31:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731497AbfGSRbP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jul 2019 13:31:15 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:38458 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731435AbfGSRbO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jul 2019 13:31:14 -0400
Received: by mail-qt1-f193.google.com with SMTP id n11so31829541qtl.5
        for <netdev@vger.kernel.org>; Fri, 19 Jul 2019 10:31:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FvdhCFEsoUoZw1zoRXv/xjAnG06uu2HXCns7yQeifDc=;
        b=RvZNFF1IP7r5uJaqFh1HFO2fBBvIPpRwAn7zJgWQe5Ayl/GjAt6t+nh+V3Ep4afu5p
         GWbLYzU/uWq2g+Yzbvxn78cCg5HFPurLJJ6F+VPKrYPLTriedcaONx4lEauBPK7DNtc1
         MCA448WCYZ9gRc6IuktSRTrL8GWrMELd4VIhb2JFWgtHREqkPa/dQMPldFO7ynT04jgx
         NE/Ztb7lBBMmrXdsH23ndZdSvvjPF4R1sirR2qWybe/Oxm1PcvllvRdHVtOwO9vpiGp2
         G87JrvtMP4tc0layp0zx00Wx/ekkAoKSTGz+6QHYvS9hg6SzytdEBj3zHTsMQQLOutK/
         Z8iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FvdhCFEsoUoZw1zoRXv/xjAnG06uu2HXCns7yQeifDc=;
        b=lAHV8Lw/JwV5D+FoMe/LKMnDDnHsgMCUjc151LH8qSHB5wqBad/DdQOHbUmFb46lTO
         cfD5mRB1nt5hvbQyF/fKi/5KSkVjPqvvhZ5mHznwKmy1GYw4N1UF6lHzepLHqAh5y09g
         SatKbwuPy0hEx4NQ+SHVQkyJIgC01Ul74TYmcTg3BM/YMyo+kz34zrV9DQe1vRgl2C7J
         Y0ss1WyARRcfI5/olI7cYyqP56CL6bNHsFRIABSDlVFDsJGlZiLvugh1rcG0zrthqZa/
         CijpsOVbOS90cv6OZnj3tTykPiuogfU8RTZRSrUTj/62E9mzDRV5uNa9+ysm68Z3CfmE
         C+KA==
X-Gm-Message-State: APjAAAU0v5A0SCK7WHNQDKxOdGQtlhh7CJQYgjjIKqp6++tJXXSjYdFY
        6q0qMH7XtnX2Js6hvErIVsAxQg==
X-Google-Smtp-Source: APXvYqyYQgspooizxbAVU8cCtrjjtkSBvNvPalG+O55/PbDHvb7OQ5ktlym57IMDuMGLUBYpW3mxGQ==
X-Received: by 2002:a0c:c688:: with SMTP id d8mr39104800qvj.86.1563557473696;
        Fri, 19 Jul 2019 10:31:13 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id y3sm15568509qtj.46.2019.07.19.10.31.12
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 19 Jul 2019 10:31:13 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     john.fastabend@gmail.com, alexei.starovoitov@gmail.com,
        daniel@iogearbox.net
Cc:     edumazet@google.com, netdev@vger.kernel.org, bpf@vger.kernel.org,
        syzbot+06537213db7ba2745c4a@syzkaller.appspotmail.com,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Dirk van der Merwe <dirk.vandermerwe@netronome.com>
Subject: [PATCH bpf v4 09/14] bpf: sockmap/tls, close can race with map free
Date:   Fri, 19 Jul 2019 10:29:22 -0700
Message-Id: <20190719172927.18181-10-jakub.kicinski@netronome.com>
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

When a map free is called and in parallel a socket is closed we
have two paths that can potentially reset the socket prot ops, the
bpf close() path and the map free path. This creates a problem
with which prot ops should be used from the socket closed side.

If the map_free side completes first then we want to call the
original lowest level ops. However, if the tls path runs first
we want to call the sockmap ops. Additionally there was no locking
around prot updates in TLS code paths so the prot ops could
be changed multiple times once from TLS path and again from sockmap
side potentially leaving ops pointed at either TLS or sockmap
when psock and/or tls context have already been destroyed.

To fix this race first only update ops inside callback lock
so that TLS, sockmap and lowest level all agree on prot state.
Second and a ULP callback update() so that lower layers can
inform the upper layer when they are being removed allowing the
upper layer to reset prot ops.

This gets us close to allowing sockmap and tls to be stacked
in arbitrary order but will save that patch for *next trees.

v4:
 - make sure we don't free things for device;
 - remove the checks which swap the callbacks back
   only if TLS is at the top.

Reported-by: syzbot+06537213db7ba2745c4a@syzkaller.appspotmail.com
Fixes: 02c558b2d5d6 ("bpf: sockmap, support for msg_peek in sk_msg with redirect ingress")
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: Dirk van der Merwe <dirk.vandermerwe@netronome.com>
---
Let's add the check that TLS's callbacks are on top when stacking in
any order is actually supported. Or perhaps let's just not support
it until we fix the remaining bugs and races?
---
 include/linux/skmsg.h |  8 +++++++-
 include/net/tcp.h     |  3 +++
 net/core/skmsg.c      |  4 ++--
 net/ipv4/tcp_ulp.c    | 13 +++++++++++++
 net/tls/tls_main.c    | 33 ++++++++++++++++++++++++++++-----
 5 files changed, 53 insertions(+), 8 deletions(-)

diff --git a/include/linux/skmsg.h b/include/linux/skmsg.h
index 50ced8aba9db..e4b3fb4bb77c 100644
--- a/include/linux/skmsg.h
+++ b/include/linux/skmsg.h
@@ -354,7 +354,13 @@ static inline void sk_psock_restore_proto(struct sock *sk,
 	sk->sk_write_space = psock->saved_write_space;
 
 	if (psock->sk_proto) {
-		sk->sk_prot = psock->sk_proto;
+		struct inet_connection_sock *icsk = inet_csk(sk);
+		bool has_ulp = !!icsk->icsk_ulp_data;
+
+		if (has_ulp)
+			tcp_update_ulp(sk, psock->sk_proto);
+		else
+			sk->sk_prot = psock->sk_proto;
 		psock->sk_proto = NULL;
 	}
 }
diff --git a/include/net/tcp.h b/include/net/tcp.h
index f42d300f0cfa..c82a23470081 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -2103,6 +2103,8 @@ struct tcp_ulp_ops {
 
 	/* initialize ulp */
 	int (*init)(struct sock *sk);
+	/* update ulp */
+	void (*update)(struct sock *sk, struct proto *p);
 	/* cleanup ulp */
 	void (*release)(struct sock *sk);
 
@@ -2114,6 +2116,7 @@ void tcp_unregister_ulp(struct tcp_ulp_ops *type);
 int tcp_set_ulp(struct sock *sk, const char *name);
 void tcp_get_available_ulp(char *buf, size_t len);
 void tcp_cleanup_ulp(struct sock *sk);
+void tcp_update_ulp(struct sock *sk, struct proto *p);
 
 #define MODULE_ALIAS_TCP_ULP(name)				\
 	__MODULE_INFO(alias, alias_userspace, name);		\
diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index 93bffaad2135..6832eeb4b785 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -585,12 +585,12 @@ EXPORT_SYMBOL_GPL(sk_psock_destroy);
 
 void sk_psock_drop(struct sock *sk, struct sk_psock *psock)
 {
-	rcu_assign_sk_user_data(sk, NULL);
 	sk_psock_cork_free(psock);
 	sk_psock_zap_ingress(psock);
-	sk_psock_restore_proto(sk, psock);
 
 	write_lock_bh(&sk->sk_callback_lock);
+	sk_psock_restore_proto(sk, psock);
+	rcu_assign_sk_user_data(sk, NULL);
 	if (psock->progs.skb_parser)
 		sk_psock_stop_strp(sk, psock);
 	write_unlock_bh(&sk->sk_callback_lock);
diff --git a/net/ipv4/tcp_ulp.c b/net/ipv4/tcp_ulp.c
index 3d8a1d835471..4849edb62d52 100644
--- a/net/ipv4/tcp_ulp.c
+++ b/net/ipv4/tcp_ulp.c
@@ -96,6 +96,19 @@ void tcp_get_available_ulp(char *buf, size_t maxlen)
 	rcu_read_unlock();
 }
 
+void tcp_update_ulp(struct sock *sk, struct proto *proto)
+{
+	struct inet_connection_sock *icsk = inet_csk(sk);
+
+	if (!icsk->icsk_ulp_ops) {
+		sk->sk_prot = proto;
+		return;
+	}
+
+	if (icsk->icsk_ulp_ops->update)
+		icsk->icsk_ulp_ops->update(sk, proto);
+}
+
 void tcp_cleanup_ulp(struct sock *sk)
 {
 	struct inet_connection_sock *icsk = inet_csk(sk);
diff --git a/net/tls/tls_main.c b/net/tls/tls_main.c
index 48f1c26459d0..f208f8455ef2 100644
--- a/net/tls/tls_main.c
+++ b/net/tls/tls_main.c
@@ -328,7 +328,10 @@ static void tls_sk_proto_unhash(struct sock *sk)
 
 	ctx = tls_get_ctx(sk);
 	tls_sk_proto_cleanup(sk, ctx, timeo);
+	write_lock_bh(&sk->sk_callback_lock);
 	icsk->icsk_ulp_data = NULL;
+	sk->sk_prot = ctx->sk_proto;
+	write_unlock_bh(&sk->sk_callback_lock);
 
 	if (ctx->sk_proto->unhash)
 		ctx->sk_proto->unhash(sk);
@@ -337,7 +340,7 @@ static void tls_sk_proto_unhash(struct sock *sk)
 
 static void tls_sk_proto_close(struct sock *sk, long timeout)
 {
-	void (*sk_proto_close)(struct sock *sk, long timeout);
+	struct inet_connection_sock *icsk = inet_csk(sk);
 	struct tls_context *ctx = tls_get_ctx(sk);
 	long timeo = sock_sndtimeo(sk, 0);
 	bool free_ctx;
@@ -347,12 +350,15 @@ static void tls_sk_proto_close(struct sock *sk, long timeout)
 
 	lock_sock(sk);
 	free_ctx = ctx->tx_conf != TLS_HW && ctx->rx_conf != TLS_HW;
-	sk_proto_close = ctx->sk_proto_close;
 
 	if (ctx->tx_conf != TLS_BASE || ctx->rx_conf != TLS_BASE)
 		tls_sk_proto_cleanup(sk, ctx, timeo);
 
+	write_lock_bh(&sk->sk_callback_lock);
+	if (free_ctx)
+		icsk->icsk_ulp_data = NULL;
 	sk->sk_prot = ctx->sk_proto;
+	write_unlock_bh(&sk->sk_callback_lock);
 	release_sock(sk);
 	if (ctx->tx_conf == TLS_SW)
 		tls_sw_free_ctx_tx(ctx);
@@ -360,7 +366,7 @@ static void tls_sk_proto_close(struct sock *sk, long timeout)
 		tls_sw_strparser_done(ctx);
 	if (ctx->rx_conf == TLS_SW)
 		tls_sw_free_ctx_rx(ctx);
-	sk_proto_close(sk, timeout);
+	ctx->sk_proto_close(sk, timeout);
 
 	if (free_ctx)
 		tls_ctx_free(ctx);
@@ -827,7 +833,7 @@ static int tls_init(struct sock *sk)
 	int rc = 0;
 
 	if (tls_hw_prot(sk))
-		goto out;
+		return 0;
 
 	/* The TLS ulp is currently supported only for TCP sockets
 	 * in ESTABLISHED state.
@@ -838,22 +844,38 @@ static int tls_init(struct sock *sk)
 	if (sk->sk_state != TCP_ESTABLISHED)
 		return -ENOTSUPP;
 
+	tls_build_proto(sk);
+
 	/* allocate tls context */
+	write_lock_bh(&sk->sk_callback_lock);
 	ctx = create_ctx(sk);
 	if (!ctx) {
 		rc = -ENOMEM;
 		goto out;
 	}
 
-	tls_build_proto(sk);
 	ctx->tx_conf = TLS_BASE;
 	ctx->rx_conf = TLS_BASE;
 	ctx->sk_proto = sk->sk_prot;
 	update_sk_prot(sk, ctx);
 out:
+	write_unlock_bh(&sk->sk_callback_lock);
 	return rc;
 }
 
+static void tls_update(struct sock *sk, struct proto *p)
+{
+	struct tls_context *ctx;
+
+	ctx = tls_get_ctx(sk);
+	if (likely(ctx)) {
+		ctx->sk_proto_close = p->close;
+		ctx->sk_proto = p;
+	} else {
+		sk->sk_prot = p;
+	}
+}
+
 void tls_register_device(struct tls_device *device)
 {
 	spin_lock_bh(&device_spinlock);
@@ -874,6 +896,7 @@ static struct tcp_ulp_ops tcp_tls_ulp_ops __read_mostly = {
 	.name			= "tls",
 	.owner			= THIS_MODULE,
 	.init			= tls_init,
+	.update			= tls_update,
 };
 
 static int __init tls_register(void)
-- 
2.21.0

