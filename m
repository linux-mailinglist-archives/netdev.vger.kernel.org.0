Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7BEF1736A4
	for <lists+netdev@lfdr.de>; Fri, 28 Feb 2020 12:55:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726875AbgB1LzM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Feb 2020 06:55:12 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:35085 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726857AbgB1Lyo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Feb 2020 06:54:44 -0500
Received: by mail-wm1-f67.google.com with SMTP id m3so2910677wmi.0
        for <netdev@vger.kernel.org>; Fri, 28 Feb 2020 03:54:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dVH4CZ/n/vhyeHw9aVUUIAVRq16r7bKo+J9/E7OEnjE=;
        b=bHmAAUIs9fimdJTLzM8yQpg8MLtiKm5C2atBpZIX4EXpYn/qjemNAkmbn4PO1lbzbW
         u92BoJOu87va2tEgUJxx5svM3xZ6VNwJKiXf2Xs19jg5RL3ZJZ5V73NLGg+61s6FmPpV
         q597nf4pKfbAjUCSRMjyyxHi/e1CCXxS12jCc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dVH4CZ/n/vhyeHw9aVUUIAVRq16r7bKo+J9/E7OEnjE=;
        b=XQvexeMMRJSDLbWUj04l480jBMNeK2N6rzuGcR9vLaKjnfIS35sWqDwtPyyS1XHDI1
         zbaE7lM66JvvtP7M0mZanHudRbeFx6upWiAnY+nslbgFIztyb3hYCNEhAFoXFXLNf6ak
         1y6kqyWCMVrkhwkdrNoJ0bynFekHxBZbO6JC81BkzWTYUpBOxqZQydkAb4mX7yhiwL1a
         R2mTWzP+YS3FCBFOxvuMXz8BdxsTScEspJ0bsh7LELZljepbMAyyO8T+FZPcWGheOQ+1
         zttEY670SXFJZmR4DTZtyaaYCBMVhEaINc/UtIfeMvYAcI8y48lDzEcH5OtzpOfysZyp
         T7jQ==
X-Gm-Message-State: APjAAAVsRJNV4qIJWbkLvRhF6v+5RRHdy5rIVnSjm4II6tTZGOqROj3+
        X5jhc9yLM1VAtO/fsc9z2A49TA==
X-Google-Smtp-Source: APXvYqxGKFWCi9Ja0FAVGcrXkzZsEB9M0lE0ExQgrS2WAs/PJ9wiFR4R4zT87ATQpEIFIFZ4ZsE5eQ==
X-Received: by 2002:a05:600c:2046:: with SMTP id p6mr4288882wmg.167.1582890879464;
        Fri, 28 Feb 2020 03:54:39 -0800 (PST)
Received: from antares.lan (b.2.d.a.1.b.1.b.2.c.5.e.0.3.d.4.f.f.6.2.a.5.a.7.0.b.8.0.1.0.0.2.ip6.arpa. [2001:8b0:7a5a:26ff:4d30:e5c2:b1b1:ad2b])
        by smtp.gmail.com with ESMTPSA id q125sm2044284wme.19.2020.02.28.03.54.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Feb 2020 03:54:38 -0800 (PST)
From:   Lorenz Bauer <lmb@cloudflare.com>
To:     john.fastabend@gmail.com, Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     kernel-team@cloudflare.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH bpf-next v2 4/9] skmsg: introduce sk_psock_hooks
Date:   Fri, 28 Feb 2020 11:53:39 +0000
Message-Id: <20200228115344.17742-5-lmb@cloudflare.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200228115344.17742-1-lmb@cloudflare.com>
References: <20200228115344.17742-1-lmb@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The sockmap works by overriding some of the callbacks in sk->sk_prot, while
leaving others untouched. This means that we need access to the struct proto
for any protocol we want to support. For IPv4 this is trivial, since both
TCP and UDP are always compiled in. IPv6 may be disabled or compiled as a
module, so the existing TCP sockmap hooks use some trickery to lazily
initialize the modified struct proto for TCPv6.

Pull this logic into a standalone struct sk_psock_hooks, so that it can be
re-used by UDP sockmap.

Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
---
 include/linux/skmsg.h |  36 +++++++++-----
 include/net/tcp.h     |   1 -
 net/core/skmsg.c      |  55 +++++++++++++++++++++
 net/core/sock_map.c   |  24 ++++-----
 net/ipv4/tcp_bpf.c    | 112 ++++++++++++------------------------------
 5 files changed, 118 insertions(+), 110 deletions(-)

diff --git a/include/linux/skmsg.h b/include/linux/skmsg.h
index c881094387db..174c76c725fb 100644
--- a/include/linux/skmsg.h
+++ b/include/linux/skmsg.h
@@ -109,6 +109,16 @@ struct sk_psock {
 	};
 };
 
+struct sk_psock_hooks {
+	struct proto *base_ipv6;
+	struct proto *ipv4;
+	struct proto *ipv6;
+	spinlock_t ipv6_lock;
+	int (*rebuild_proto)(struct proto prot[], struct proto *base);
+	struct proto *(*choose_proto)(struct proto prot[],
+				      struct sk_psock *psock);
+};
+
 int sk_msg_alloc(struct sock *sk, struct sk_msg *msg, int len,
 		 int elem_first_coalesce);
 int sk_msg_clone(struct sock *sk, struct sk_msg *dst, struct sk_msg *src,
@@ -335,23 +345,14 @@ static inline void sk_psock_cork_free(struct sk_psock *psock)
 	}
 }
 
-static inline void sk_psock_update_proto(struct sock *sk,
-					 struct sk_psock *psock,
-					 struct proto *ops)
-{
-	psock->saved_unhash = sk->sk_prot->unhash;
-	psock->saved_close = sk->sk_prot->close;
-	psock->saved_write_space = sk->sk_write_space;
-
-	psock->sk_proto = sk->sk_prot;
-	/* Pairs with lockless read in sk_clone_lock() */
-	WRITE_ONCE(sk->sk_prot, ops);
-}
-
 static inline void sk_psock_restore_proto(struct sock *sk,
 					  struct sk_psock *psock)
 {
+	if (!psock->sk_proto)
+		return;
+
 	sk->sk_prot->unhash = psock->saved_unhash;
+
 	if (inet_sk(sk)->is_icsk) {
 		tcp_update_ulp(sk, psock->sk_proto, psock->saved_write_space);
 	} else {
@@ -424,4 +425,13 @@ static inline void psock_progs_drop(struct sk_psock_progs *progs)
 	psock_set_prog(&progs->skb_verdict, NULL);
 }
 
+static inline int sk_psock_hooks_init(struct sk_psock_hooks *hooks,
+				       struct proto *ipv4_base)
+{
+	spin_lock_init(&hooks->ipv6_lock);
+	return hooks->rebuild_proto(hooks->ipv4, ipv4_base);
+}
+
+int sk_psock_hooks_install(struct sk_psock_hooks *hooks, struct sock *sk);
+
 #endif /* _LINUX_SKMSG_H */
diff --git a/include/net/tcp.h b/include/net/tcp.h
index f5503b2c7bed..37f89ed7919c 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -2197,7 +2197,6 @@ struct sk_psock;
 
 #ifdef CONFIG_BPF_STREAM_PARSER
 int tcp_bpf_init(struct sock *sk);
-void tcp_bpf_reinit(struct sock *sk);
 void tcp_bpf_clone(const struct sock *sk, struct sock *newsk);
 #else
 static inline void tcp_bpf_clone(const struct sock *sk, struct sock *newsk)
diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index c479372f2cd2..8d46ded3b1a5 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -840,3 +840,58 @@ void sk_psock_stop_strp(struct sock *sk, struct sk_psock *psock)
 	strp_stop(&parser->strp);
 	parser->enabled = false;
 }
+
+static inline int sk_psock_hooks_init_ipv6(struct sk_psock_hooks *hooks,
+					    struct proto *base)
+{
+	int ret = 0;
+
+	if (likely(base == smp_load_acquire(&hooks->base_ipv6)))
+		return 0;
+
+	spin_lock_bh(&hooks->ipv6_lock);
+	if (likely(base != hooks->base_ipv6)) {
+		ret = hooks->rebuild_proto(hooks->ipv6, base);
+		if (!ret)
+			smp_store_release(&hooks->base_ipv6, base);
+	}
+	spin_unlock_bh(&hooks->ipv6_lock);
+	return ret;
+}
+
+int sk_psock_hooks_install(struct sk_psock_hooks *hooks, struct sock *sk)
+{
+	struct sk_psock *psock = sk_psock(sk);
+	struct proto *prot_base;
+
+	WARN_ON_ONCE(!rcu_read_lock_held());
+
+	if (unlikely(!psock))
+		return -EINVAL;
+
+	/* Initialize saved callbacks and original proto only once, since this
+	 * function may be called multiple times for a psock, e.g. when
+	 * psock->progs.msg_parser is updated.
+	 *
+	 * Since we've not installed the hooks, psock is not yet in use and
+	 * we can initialize it without synchronization.
+	 */
+	if (!psock->sk_proto) {
+		struct proto *prot = READ_ONCE(sk->sk_prot);
+
+		if (sk->sk_family == AF_INET6 &&
+		    sk_psock_hooks_init_ipv6(hooks, prot))
+			return -EINVAL;
+
+		psock->saved_unhash = prot->unhash;
+		psock->saved_close = prot->close;
+		psock->saved_write_space = sk->sk_write_space;
+
+		psock->sk_proto = prot;
+	}
+
+	/* Pairs with lockless read in sk_clone_lock() */
+	prot_base = sk->sk_family == AF_INET ? hooks->ipv4 : hooks->ipv6;
+	WRITE_ONCE(sk->sk_prot, hooks->choose_proto(prot_base, psock));
+	return 0;
+}
diff --git a/net/core/sock_map.c b/net/core/sock_map.c
index 459b3ba16023..c84cc9fc7f6b 100644
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -170,8 +170,8 @@ static int sock_map_link(struct bpf_map *map, struct sk_psock_progs *progs,
 			 struct sock *sk)
 {
 	struct bpf_prog *msg_parser, *skb_parser, *skb_verdict;
-	bool skb_progs, sk_psock_is_new = false;
 	struct sk_psock *psock;
+	bool skb_progs;
 	int ret;
 
 	skb_verdict = READ_ONCE(progs->skb_verdict);
@@ -206,9 +206,8 @@ static int sock_map_link(struct bpf_map *map, struct sk_psock_progs *progs,
 	if (psock) {
 		if ((msg_parser && READ_ONCE(psock->progs.msg_parser)) ||
 		    (skb_progs  && READ_ONCE(psock->progs.skb_parser))) {
-			sk_psock_put(sk, psock);
 			ret = -EBUSY;
-			goto out_progs;
+			goto out_drop;
 		}
 	} else {
 		psock = sk_psock_init(sk, map->numa_node);
@@ -216,18 +215,14 @@ static int sock_map_link(struct bpf_map *map, struct sk_psock_progs *progs,
 			ret = -ENOMEM;
 			goto out_progs;
 		}
-		sk_psock_is_new = true;
 	}
 
 	if (msg_parser)
 		psock_set_prog(&psock->progs.msg_parser, msg_parser);
-	if (sk_psock_is_new) {
-		ret = tcp_bpf_init(sk);
-		if (ret < 0)
-			goto out_drop;
-	} else {
-		tcp_bpf_reinit(sk);
-	}
+
+	ret = tcp_bpf_init(sk);
+	if (ret < 0)
+		goto out_drop;
 
 	write_lock_bh(&sk->sk_callback_lock);
 	if (skb_progs && !psock->parser.enabled) {
@@ -264,15 +259,14 @@ static int sock_map_link_no_progs(struct bpf_map *map, struct sock *sk)
 	if (IS_ERR(psock))
 		return PTR_ERR(psock);
 
-	if (psock) {
-		tcp_bpf_reinit(sk);
-		return 0;
-	}
+	if (psock)
+		goto init;
 
 	psock = sk_psock_init(sk, map->numa_node);
 	if (!psock)
 		return -ENOMEM;
 
+init:
 	ret = tcp_bpf_init(sk);
 	if (ret < 0)
 		sk_psock_put(sk, psock);
diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
index 3f9a50e54c1d..390717eae10e 100644
--- a/net/ipv4/tcp_bpf.c
+++ b/net/ipv4/tcp_bpf.c
@@ -531,25 +531,23 @@ static int tcp_bpf_sendpage(struct sock *sk, struct page *page, int offset,
 	return copied ? copied : err;
 }
 
-enum {
-	TCP_BPF_IPV4,
-	TCP_BPF_IPV6,
-	TCP_BPF_NUM_PROTS,
-};
-
 enum {
 	TCP_BPF_BASE,
 	TCP_BPF_TX,
 	TCP_BPF_NUM_CFGS,
 };
 
-static struct proto *tcpv6_prot_saved __read_mostly;
-static DEFINE_SPINLOCK(tcpv6_prot_lock);
-static struct proto tcp_bpf_prots[TCP_BPF_NUM_PROTS][TCP_BPF_NUM_CFGS];
-
-static void tcp_bpf_rebuild_protos(struct proto prot[TCP_BPF_NUM_CFGS],
-				   struct proto *base)
+static int tcp_bpf_rebuild_proto(struct proto prot[], struct proto *base)
 {
+	/* In order to avoid retpoline, we make assumptions when we call
+	 * into ops if e.g. a psock is not present. Make sure they are
+	 * indeed valid assumptions.
+	 */
+	if (base->recvmsg  != tcp_recvmsg ||
+	    base->sendmsg  != tcp_sendmsg ||
+	    base->sendpage != tcp_sendpage)
+		return -ENOTSUPP;
+
 	prot[TCP_BPF_BASE]			= *base;
 	prot[TCP_BPF_BASE].unhash		= sock_map_unhash;
 	prot[TCP_BPF_BASE].close		= sock_map_close;
@@ -559,91 +557,42 @@ static void tcp_bpf_rebuild_protos(struct proto prot[TCP_BPF_NUM_CFGS],
 	prot[TCP_BPF_TX]			= prot[TCP_BPF_BASE];
 	prot[TCP_BPF_TX].sendmsg		= tcp_bpf_sendmsg;
 	prot[TCP_BPF_TX].sendpage		= tcp_bpf_sendpage;
-}
-
-static void tcp_bpf_check_v6_needs_rebuild(struct sock *sk, struct proto *ops)
-{
-	if (sk->sk_family == AF_INET6 &&
-	    unlikely(ops != smp_load_acquire(&tcpv6_prot_saved))) {
-		spin_lock_bh(&tcpv6_prot_lock);
-		if (likely(ops != tcpv6_prot_saved)) {
-			tcp_bpf_rebuild_protos(tcp_bpf_prots[TCP_BPF_IPV6], ops);
-			smp_store_release(&tcpv6_prot_saved, ops);
-		}
-		spin_unlock_bh(&tcpv6_prot_lock);
-	}
-}
-
-static int __init tcp_bpf_v4_build_proto(void)
-{
-	tcp_bpf_rebuild_protos(tcp_bpf_prots[TCP_BPF_IPV4], &tcp_prot);
 	return 0;
 }
-core_initcall(tcp_bpf_v4_build_proto);
 
-static void tcp_bpf_update_sk_prot(struct sock *sk, struct sk_psock *psock)
+static struct proto *tcp_bpf_choose_proto(struct proto prot[],
+					  struct sk_psock *psock)
 {
-	int family = sk->sk_family == AF_INET6 ? TCP_BPF_IPV6 : TCP_BPF_IPV4;
-	int config = psock->progs.msg_parser   ? TCP_BPF_TX   : TCP_BPF_BASE;
+	int config = psock->progs.msg_parser ? TCP_BPF_TX : TCP_BPF_BASE;
 
-	sk_psock_update_proto(sk, psock, &tcp_bpf_prots[family][config]);
+	return &prot[config];
 }
 
-static void tcp_bpf_reinit_sk_prot(struct sock *sk, struct sk_psock *psock)
-{
-	int family = sk->sk_family == AF_INET6 ? TCP_BPF_IPV6 : TCP_BPF_IPV4;
-	int config = psock->progs.msg_parser   ? TCP_BPF_TX   : TCP_BPF_BASE;
-
-	/* Reinit occurs when program types change e.g. TCP_BPF_TX is removed
-	 * or added requiring sk_prot hook updates. We keep original saved
-	 * hooks in this case.
-	 *
-	 * Pairs with lockless read in sk_clone_lock().
-	 */
-	WRITE_ONCE(sk->sk_prot, &tcp_bpf_prots[family][config]);
-}
-
-static int tcp_bpf_assert_proto_ops(struct proto *ops)
-{
-	/* In order to avoid retpoline, we make assumptions when we call
-	 * into ops if e.g. a psock is not present. Make sure they are
-	 * indeed valid assumptions.
-	 */
-	return ops->recvmsg  == tcp_recvmsg &&
-	       ops->sendmsg  == tcp_sendmsg &&
-	       ops->sendpage == tcp_sendpage ? 0 : -ENOTSUPP;
-}
+static struct proto tcp_bpf_ipv4[TCP_BPF_NUM_CFGS];
+static struct proto tcp_bpf_ipv6[TCP_BPF_NUM_CFGS];
+static struct sk_psock_hooks tcp_bpf_hooks __read_mostly = {
+	.ipv4 = &tcp_bpf_ipv4[0],
+	.ipv6 = &tcp_bpf_ipv6[0],
+	.rebuild_proto = tcp_bpf_rebuild_proto,
+	.choose_proto = tcp_bpf_choose_proto,
+};
 
-void tcp_bpf_reinit(struct sock *sk)
+static int __init tcp_bpf_init_psock_hooks(void)
 {
-	struct sk_psock *psock;
-
-	sock_owned_by_me(sk);
-
-	rcu_read_lock();
-	psock = sk_psock(sk);
-	tcp_bpf_reinit_sk_prot(sk, psock);
-	rcu_read_unlock();
+	return sk_psock_hooks_init(&tcp_bpf_hooks, &tcp_prot);
 }
+core_initcall(tcp_bpf_init_psock_hooks);
 
 int tcp_bpf_init(struct sock *sk)
 {
-	struct proto *ops = READ_ONCE(sk->sk_prot);
-	struct sk_psock *psock;
+	int ret;
 
 	sock_owned_by_me(sk);
 
 	rcu_read_lock();
-	psock = sk_psock(sk);
-	if (unlikely(!psock || psock->sk_proto ||
-		     tcp_bpf_assert_proto_ops(ops))) {
-		rcu_read_unlock();
-		return -EINVAL;
-	}
-	tcp_bpf_check_v6_needs_rebuild(sk, ops);
-	tcp_bpf_update_sk_prot(sk, psock);
+	ret = sk_psock_hooks_install(&tcp_bpf_hooks, sk);
 	rcu_read_unlock();
-	return 0;
+	return ret;
 }
 
 /* If a child got cloned from a listening socket that had tcp_bpf
@@ -653,10 +602,11 @@ int tcp_bpf_init(struct sock *sk)
  */
 void tcp_bpf_clone(const struct sock *sk, struct sock *newsk)
 {
-	int family = sk->sk_family == AF_INET6 ? TCP_BPF_IPV6 : TCP_BPF_IPV4;
 	struct proto *prot = newsk->sk_prot;
 
-	if (prot == &tcp_bpf_prots[family][TCP_BPF_BASE])
+	/* TCP_LISTEN can only use TCP_BPF_BASE, so this is safe */
+	if (unlikely(prot == &tcp_bpf_ipv4[TCP_BPF_BASE] ||
+		     prot == &tcp_bpf_ipv6[TCP_BPF_BASE]))
 		newsk->sk_prot = sk->sk_prot_creator;
 }
 #endif /* CONFIG_BPF_STREAM_PARSER */
-- 
2.20.1

