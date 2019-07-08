Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 829B362925
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 21:15:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403871AbfGHTPe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 15:15:34 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:34897 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728827AbfGHTPd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 15:15:33 -0400
Received: by mail-io1-f65.google.com with SMTP id m24so28331336ioo.2;
        Mon, 08 Jul 2019 12:15:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=QP2BQLcDax4oZj4bSFvh8EyG6vL9pp9ZKdbj2H2DM00=;
        b=eCAOBsM34g1rAjGofOPcZnsTLxwSEKDrWSRNkD1rnDVJ5B6VybqOeVDJxcBCNHU79x
         m2YN7DxKrgD0kdfKexYWKolUE4r90H6+kOCEaFaGTx1hMBSow28SOgd9YeOPU2ibOuIy
         f0lEoxhB8T97JkNRk76xJcKRmgR1/IO4sWj+g96OxxRZbYd+DWsbsfmXrQ/nycJPOzpt
         TAKDQcqjaBBNmFtzZg6WsG/pOwOBqkjl2J0bhwZD5zm5Ihspwh+nq4idx+oynQDNTLSI
         PjurtbvRnMjyGDc0FnHi2Gr3GT4yDboMOVmnnBaaUjKd5DC14GPZ0Dt/+UtInWsrIW49
         1WWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=QP2BQLcDax4oZj4bSFvh8EyG6vL9pp9ZKdbj2H2DM00=;
        b=rMFJPGDkoFmYzhPL/AuMWLaqs2HEcAs4+q+OvP+uGDtV90tu44a+0ZB1sP14XDsvxs
         PDc5ttpcLXp/gjTPvx6PhFUGNPzABNjpX6K250Lp9qdUykGcjHG6qEgMsSx3sUaRuU3N
         qOKG5zDZfEqG+cLXWX2llY1WbYkTICtdJLFHLor9WPnIKqVDh1vh0wUqzu9zjU1mPcI5
         0q5DWJ4G06UOI2tJXJ9yl/k7FVTlNs2WJlSMzcpPMvIAfMn84I2kiOjNko9Gsc273dY3
         cp3TKNccDJd9qkKJy9iQgfCldaQTMPL7rTXpbF+2B9t+6+mMXSVylBKBBI4mDXAvXylr
         6A/w==
X-Gm-Message-State: APjAAAXwbExI1ln/65mzmBSs54Srs0WnpZ+FsYb6NZ8ZR2BBtvqCcrlM
        +GonV+3RiRMrmGOL6YVs8tc=
X-Google-Smtp-Source: APXvYqyBrhPyBUUvj+cE1ZyGeWfTlVkncjlSoabTSCZNQaU5A3YOR5JTS/dYB/TFR/eO47LKDoD1RQ==
X-Received: by 2002:a02:5ec3:: with SMTP id h186mr17005079jab.110.1562613332141;
        Mon, 08 Jul 2019 12:15:32 -0700 (PDT)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id u4sm23675520iol.59.2019.07.08.12.15.24
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 08 Jul 2019 12:15:31 -0700 (PDT)
Subject: [bpf PATCH v2 6/6] bpf: sockmap/tls, close can race with map free
From:   John Fastabend <john.fastabend@gmail.com>
To:     jakub.kicinski@netronome.com, ast@kernel.org, daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, edumazet@google.com,
        john.fastabend@gmail.com, bpf@vger.kernel.org
Date:   Mon, 08 Jul 2019 19:15:18 +0000
Message-ID: <156261331866.31108.6405316261950259075.stgit@ubuntu3-kvm1>
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

Reported-by: syzbot+06537213db7ba2745c4a@syzkaller.appspotmail.com
Fixes: 02c558b2d5d6 ("bpf: sockmap, support for msg_peek in sk_msg with redirect ingress")
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 include/linux/skmsg.h |    8 +++++++-
 include/net/tcp.h     |    3 +++
 net/core/skmsg.c      |    4 ++--
 net/ipv4/tcp_ulp.c    |   13 +++++++++++++
 net/tls/tls_main.c    |   35 +++++++++++++++++++++++++++++------
 5 files changed, 54 insertions(+), 9 deletions(-)

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
index 9d36cc88d043..123cac4c96f2 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -2102,6 +2102,8 @@ struct tcp_ulp_ops {
 
 	/* initialize ulp */
 	int (*init)(struct sock *sk);
+	/* update ulp */
+	void (*update)(struct sock *sk, struct proto *p);
 	/* cleanup ulp */
 	void (*release)(struct sock *sk);
 
@@ -2113,6 +2115,7 @@ void tcp_unregister_ulp(struct tcp_ulp_ops *type);
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
index e8418456ee24..4ba5476fbc5f 100644
--- a/net/tls/tls_main.c
+++ b/net/tls/tls_main.c
@@ -336,15 +336,17 @@ static void tls_sk_proto_unhash(struct sock *sk)
 
 static void tls_sk_proto_close(struct sock *sk, long timeout)
 {
+	struct inet_connection_sock *icsk = inet_csk(sk);
 	struct tls_context *ctx = tls_get_ctx(sk);
 	long timeo = sock_sndtimeo(sk, 0);
-	void (*sk_proto_close)(struct sock *sk, long timeout);
+
+	if (unlikely(!ctx))
+		return;
 
 	if (ctx->tx_conf == TLS_SW)
 		tls_sw_cancel_work_tx(ctx);
 
 	lock_sock(sk);
-	sk_proto_close = ctx->sk_proto_close;
 
 	if (ctx->tx_conf == TLS_HW_RECORD && ctx->rx_conf == TLS_HW_RECORD)
 		goto skip_tx_cleanup;
@@ -352,15 +354,18 @@ static void tls_sk_proto_close(struct sock *sk, long timeout)
 	if (ctx->tx_conf == TLS_BASE && ctx->rx_conf == TLS_BASE)
 		goto skip_tx_cleanup;
 
-	sk->sk_prot = ctx->sk_proto;
 	tls_sk_proto_cleanup(sk, ctx, timeo);
 
 skip_tx_cleanup:
+	write_lock_bh(&sk->sk_callback_lock);
+	icsk->icsk_ulp_data = NULL;
+	if (sk->sk_prot->close == tls_sk_proto_close)
+		sk->sk_prot = ctx->sk_proto;
+	write_unlock_bh(&sk->sk_callback_lock);
 	release_sock(sk);
 	if (ctx->rx_conf == TLS_SW)
 		tls_sw_release_strp_rx(ctx);
-	sk_proto_close(sk, timeout);
-
+	ctx->sk_proto_close(sk, timeout);
 	if (ctx->tx_conf != TLS_HW && ctx->rx_conf != TLS_HW &&
 	    ctx->tx_conf != TLS_HW_RECORD && ctx->rx_conf != TLS_HW_RECORD)
 		tls_ctx_free(ctx);
@@ -836,22 +841,39 @@ static int tls_init(struct sock *sk)
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
+		ctx->unhash = p->unhash;
+		ctx->sk_proto = p;
+	} else {
+		sk->sk_prot = p;
+	}
+}
+
 void tls_register_device(struct tls_device *device)
 {
 	spin_lock_bh(&device_spinlock);
@@ -872,6 +894,7 @@ static struct tcp_ulp_ops tcp_tls_ulp_ops __read_mostly = {
 	.name			= "tls",
 	.owner			= THIS_MODULE,
 	.init			= tls_init,
+	.update			= tls_update,
 };
 
 static int __init tls_register(void)

