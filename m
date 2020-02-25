Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85EB316C2E7
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 14:56:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730499AbgBYN4v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 08:56:51 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:38118 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730340AbgBYN4r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Feb 2020 08:56:47 -0500
Received: by mail-wm1-f67.google.com with SMTP id a9so3247489wmj.3
        for <netdev@vger.kernel.org>; Tue, 25 Feb 2020 05:56:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6trGj3ZxAEym4kOmMJM6kP41Fhmdj2jr0SexhJ+xY5g=;
        b=KAFScvGaqf/JHH7ZB91aznHMnA9aBRAI44mdZm2EfMFxlNcUFqlj+FqDDG4rc3/xy+
         Bj/jPzuJtjqy9iEDkJWglLH32jLZfLRGPVzVMecj8HtJxbDI7J5Ry2DFHM8Z9y80wzFJ
         bP/hhS43DPEY25E4FS4Z+x+seObLXz7JwxvTY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6trGj3ZxAEym4kOmMJM6kP41Fhmdj2jr0SexhJ+xY5g=;
        b=JBjTY8XcoxEfTuh1oYB9ZOYYNvKlC/ac/VtlwpC4TJElHDftb3ZzNKqMq2RC7ucY68
         vnCT0qu6GZTBsrswSkUKD/OWN2EwjR2JKk5xbsH9v7a+4DIwKUYd5jxT/rwOVKworwLH
         cI0iHGQeiYNfM/JmlmleB4NBBXSLWiXAeW4vrlaLDU8BxgjIuYRwancDSAj4k331KC/C
         M06AHBCC0gpIXNgQ51PpwHMYY05pAf/6Umk/QymooB0Ed06izh0eM5S6E/wzhqnB238l
         swj64+BnzwVmTfaEMCaop5c2XJXYNYV+M8EXr3XQcxk/AN+BhrSakvrsRHPohko0RwSH
         QasA==
X-Gm-Message-State: APjAAAV5VcfmmLbM8z4YJ3XDz7+lYtcL9z7Vb04Z1zCpfX540sSDaxfL
        sTBnYny67AXX+LdHSWCewWjuhw==
X-Google-Smtp-Source: APXvYqznxpdPPmOfbgK9/GYySRY5epb29T6UH54vlkhq5WJ4yhSLWLzeDL+cuAhcfpkV7KK/+xO0wg==
X-Received: by 2002:a05:600c:2104:: with SMTP id u4mr5538875wml.93.1582639003927;
        Tue, 25 Feb 2020 05:56:43 -0800 (PST)
Received: from localhost.localdomain ([2a06:98c0:1000:8800:3dea:15ba:1870:8e94])
        by smtp.gmail.com with ESMTPSA id t128sm4463580wmf.28.2020.02.25.05.56.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Feb 2020 05:56:43 -0800 (PST)
From:   Lorenz Bauer <lmb@cloudflare.com>
To:     ast@kernel.org, daniel@iogearbox.net, john.fastabend@gmail.com
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@cloudflare.com, Lorenz Bauer <lmb@cloudflare.com>
Subject: [PATCH bpf-next 3/7] skmsg: introduce sk_psock_hooks
Date:   Tue, 25 Feb 2020 13:56:32 +0000
Message-Id: <20200225135636.5768-4-lmb@cloudflare.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200225135636.5768-1-lmb@cloudflare.com>
References: <20200225135636.5768-1-lmb@cloudflare.com>
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
 include/linux/skmsg.h |  36 ++++++++-----
 include/net/tcp.h     |   1 -
 net/core/skmsg.c      |  52 +++++++++++++++++++
 net/core/sock_map.c   |  24 ++++-----
 net/ipv4/tcp_bpf.c    | 114 ++++++++++++------------------------------
 5 files changed, 116 insertions(+), 111 deletions(-)

diff --git a/include/linux/skmsg.h b/include/linux/skmsg.h
index c881094387db..70d65ab10b5c 100644
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
+	hooks->ipv6_lock = __SPIN_LOCK_UNLOCKED();
+	return hooks->rebuild_proto(hooks->ipv4, ipv4_base);
+}
+
+int sk_psock_hooks_install(struct sk_psock_hooks *hooks, struct sock *sk);
+
 #endif /* _LINUX_SKMSG_H */
diff --git a/include/net/tcp.h b/include/net/tcp.h
index 07f947cc80e6..ccf39d80b695 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -2196,7 +2196,6 @@ struct sk_msg;
 struct sk_psock;
 
 int tcp_bpf_init(struct sock *sk);
-void tcp_bpf_reinit(struct sock *sk);
 int tcp_bpf_sendmsg_redir(struct sock *sk, struct sk_msg *msg, u32 bytes,
 			  int flags);
 int tcp_bpf_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index eeb28cb85664..a9bdf02c2539 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -844,3 +844,55 @@ void sk_psock_stop_strp(struct sock *sk, struct sk_psock *psock)
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
+	/* Initialize saved callbacks and original proto only once.
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
index 90955c96a9a8..81c0431a8dbd 100644
--- a/net/ipv4/tcp_bpf.c
+++ b/net/ipv4/tcp_bpf.c
@@ -528,25 +528,23 @@ static int tcp_bpf_sendpage(struct sock *sk, struct page *page, int offset,
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
@@ -556,91 +554,42 @@ static void tcp_bpf_rebuild_protos(struct proto prot[TCP_BPF_NUM_CFGS],
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
@@ -650,9 +599,10 @@ int tcp_bpf_init(struct sock *sk)
  */
 void tcp_bpf_clone(const struct sock *sk, struct sock *newsk)
 {
-	int family = sk->sk_family == AF_INET6 ? TCP_BPF_IPV6 : TCP_BPF_IPV4;
-	struct proto *prot = newsk->sk_prot;
+	struct proto *prot = READ_ONCE(sk->sk_prot);
 
-	if (prot == &tcp_bpf_prots[family][TCP_BPF_BASE])
+	/* TCP_LISTEN can only use TCP_BPF_BASE, so this is safe */
+	if (unlikely(prot == &tcp_bpf_ipv4[TCP_BPF_BASE] ||
+	             prot == &tcp_bpf_ipv6[TCP_BPF_BASE]))
 		newsk->sk_prot = sk->sk_prot_creator;
 }
-- 
2.20.1

