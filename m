Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0AFF51736A1
	for <lists+netdev@lfdr.de>; Fri, 28 Feb 2020 12:55:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726860AbgB1Lym (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Feb 2020 06:54:42 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:56122 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726788AbgB1Lyk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Feb 2020 06:54:40 -0500
Received: by mail-wm1-f66.google.com with SMTP id q9so2871709wmj.5
        for <netdev@vger.kernel.org>; Fri, 28 Feb 2020 03:54:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pBH5xke6c0o75Z2jP2WKzrpelxlnY2czGETtY/xCf6o=;
        b=EiGgTIsqxFNr88k3GcHEunIPCrPBYBk1b/AeBrfcU0pMlbnlnUcALg9u7OPSCDC81B
         riUwvgMOUHoW3eqVKn6Dnxj6k9Z2rTGF86YJXzefspoUjhwzSe+W5jyPgfrioS/MBgXz
         lMRowyVIXtf4nwFd7eKu6OhKnqf5j+MpFLV0c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pBH5xke6c0o75Z2jP2WKzrpelxlnY2czGETtY/xCf6o=;
        b=DA4pR+y+6nMabq/u0u1aZ/yEd2j9KXgpiXDV1tum7PrNiBK+Tsonfs2PXK72gEiWz/
         uB/J+UZA31kYXjIvPka3N4Mlb/37V+LSWOFj5Zh3Movx5fsffB4zq9IRtGX9jOfcWTQ4
         5ZVOjJnER6YyBu89aZoRR25eqfwClCWxqy3wYWsZDGNROzcVgBbBSpEt1FJ+IofmyJ8e
         6QoycTwaXFdUNN/ba5pZNo857NjtWV6rNd+7zk6c7zckpKX1O6a3weIAcrHGwQaBdFU0
         xO1cLCoJGFXVcWyj+vFThcwJfQ6ovF/rXu5sVeDOSGZhugfkeJs1aZhUTJ4vBAyl+tHZ
         VmmA==
X-Gm-Message-State: APjAAAUokfIbSmFNkefSykj1j3VcwrOV99SbeqcOb/JNRTY2zLp/mHLA
        CRXORf974BVyx1nsRKlgWAWnJg==
X-Google-Smtp-Source: APXvYqz/85354E0iXO8HJMumMsLfKuxi5v+28Zt7mX4pHeqof6Tr/Esvhjz910BBIGjO0GGuPYh7lw==
X-Received: by 2002:a7b:cae9:: with SMTP id t9mr4450584wml.186.1582890876997;
        Fri, 28 Feb 2020 03:54:36 -0800 (PST)
Received: from antares.lan (b.2.d.a.1.b.1.b.2.c.5.e.0.3.d.4.f.f.6.2.a.5.a.7.0.b.8.0.1.0.0.2.ip6.arpa. [2001:8b0:7a5a:26ff:4d30:e5c2:b1b1:ad2b])
        by smtp.gmail.com with ESMTPSA id q125sm2044284wme.19.2020.02.28.03.54.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Feb 2020 03:54:36 -0800 (PST)
From:   Lorenz Bauer <lmb@cloudflare.com>
To:     john.fastabend@gmail.com, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Cc:     kernel-team@cloudflare.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH bpf-next v2 3/9] bpf: sockmap: move generic sockmap hooks from BPF TCP
Date:   Fri, 28 Feb 2020 11:53:38 +0000
Message-Id: <20200228115344.17742-4-lmb@cloudflare.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200228115344.17742-1-lmb@cloudflare.com>
References: <20200228115344.17742-1-lmb@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The close, unhash and clone handlers from TCP sockmap are actually generic,
and can be reused by UDP sockmap. Move the helpers into the sockmap code
base and expose them. This requires tcp_bpf_(re)init and tcp_bpf_clone to
be conditional on BPF_STREAM_PARSER.

Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
---
 include/linux/bpf.h   |  4 ++-
 include/linux/skmsg.h | 28 ----------------
 include/net/tcp.h     | 15 +++++----
 net/core/sock_map.c   | 77 +++++++++++++++++++++++++++++++++++++++++--
 net/ipv4/tcp_bpf.c    | 59 ++++-----------------------------
 5 files changed, 92 insertions(+), 91 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 1acd5bf70350..00bb3c59c2ae 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1385,6 +1385,8 @@ static inline void bpf_map_offload_map_free(struct bpf_map *map)
 #if defined(CONFIG_BPF_STREAM_PARSER)
 int sock_map_prog_update(struct bpf_map *map, struct bpf_prog *prog, u32 which);
 int sock_map_get_from_fd(const union bpf_attr *attr, struct bpf_prog *prog);
+void sock_map_unhash(struct sock *sk);
+void sock_map_close(struct sock *sk, long timeout);
 #else
 static inline int sock_map_prog_update(struct bpf_map *map,
 				       struct bpf_prog *prog, u32 which)
@@ -1397,7 +1399,7 @@ static inline int sock_map_get_from_fd(const union bpf_attr *attr,
 {
 	return -EINVAL;
 }
-#endif
+#endif /* CONFIG_BPF_STREAM_PARSER */
 
 #if defined(CONFIG_INET) && defined(CONFIG_BPF_SYSCALL)
 void bpf_sk_reuseport_detach(struct sock *sk);
diff --git a/include/linux/skmsg.h b/include/linux/skmsg.h
index 54a9a3e36b29..c881094387db 100644
--- a/include/linux/skmsg.h
+++ b/include/linux/skmsg.h
@@ -323,14 +323,6 @@ static inline void sk_psock_free_link(struct sk_psock_link *link)
 }
 
 struct sk_psock_link *sk_psock_link_pop(struct sk_psock *psock);
-#if defined(CONFIG_BPF_STREAM_PARSER)
-void sk_psock_unlink(struct sock *sk, struct sk_psock_link *link);
-#else
-static inline void sk_psock_unlink(struct sock *sk,
-				   struct sk_psock_link *link)
-{
-}
-#endif
 
 void __sk_psock_purge_ingress_msg(struct sk_psock *psock);
 
@@ -387,26 +379,6 @@ static inline bool sk_psock_test_state(const struct sk_psock *psock,
 	return test_bit(bit, &psock->state);
 }
 
-static inline struct sk_psock *sk_psock_get_checked(struct sock *sk)
-{
-	struct sk_psock *psock;
-
-	rcu_read_lock();
-	psock = sk_psock(sk);
-	if (psock) {
-		if (sk->sk_prot->recvmsg != tcp_bpf_recvmsg) {
-			psock = ERR_PTR(-EBUSY);
-			goto out;
-		}
-
-		if (!refcount_inc_not_zero(&psock->refcnt))
-			psock = ERR_PTR(-EBUSY);
-	}
-out:
-	rcu_read_unlock();
-	return psock;
-}
-
 static inline struct sk_psock *sk_psock_get(struct sock *sk)
 {
 	struct sk_psock *psock;
diff --git a/include/net/tcp.h b/include/net/tcp.h
index a30022482dbc..f5503b2c7bed 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -2195,20 +2195,23 @@ void tcp_update_ulp(struct sock *sk, struct proto *p,
 struct sk_msg;
 struct sk_psock;
 
-#ifdef CONFIG_NET_SOCK_MSG
+#ifdef CONFIG_BPF_STREAM_PARSER
 int tcp_bpf_init(struct sock *sk);
 void tcp_bpf_reinit(struct sock *sk);
+void tcp_bpf_clone(const struct sock *sk, struct sock *newsk);
+#else
+static inline void tcp_bpf_clone(const struct sock *sk, struct sock *newsk)
+{
+}
+#endif /* CONFIG_BPF_STREAM_PARSER */
+
+#ifdef CONFIG_NET_SOCK_MSG
 int tcp_bpf_sendmsg_redir(struct sock *sk, struct sk_msg *msg, u32 bytes,
 			  int flags);
 int tcp_bpf_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 		    int nonblock, int flags, int *addr_len);
 int __tcp_bpf_recvmsg(struct sock *sk, struct sk_psock *psock,
 		      struct msghdr *msg, int len, int flags);
-void tcp_bpf_clone(const struct sock *sk, struct sock *newsk);
-#else
-static inline void tcp_bpf_clone(const struct sock *sk, struct sock *newsk)
-{
-}
 #endif /* CONFIG_NET_SOCK_MSG */
 
 /* Call BPF_SOCK_OPS program that returns an int. If the return value
diff --git a/net/core/sock_map.c b/net/core/sock_map.c
index 695ecacc7afa..459b3ba16023 100644
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -146,6 +146,26 @@ static void sock_map_unref(struct sock *sk, void *link_raw)
 	}
 }
 
+static struct sk_psock *sock_map_psock_get_checked(struct sock *sk)
+{
+	struct sk_psock *psock;
+
+	rcu_read_lock();
+	psock = sk_psock(sk);
+	if (psock) {
+		if (sk->sk_prot->recvmsg != tcp_bpf_recvmsg) {
+			psock = ERR_PTR(-EBUSY);
+			goto out;
+		}
+
+		if (!refcount_inc_not_zero(&psock->refcnt))
+			psock = ERR_PTR(-EBUSY);
+	}
+out:
+	rcu_read_unlock();
+	return psock;
+}
+
 static int sock_map_link(struct bpf_map *map, struct sk_psock_progs *progs,
 			 struct sock *sk)
 {
@@ -177,7 +197,7 @@ static int sock_map_link(struct bpf_map *map, struct sk_psock_progs *progs,
 		}
 	}
 
-	psock = sk_psock_get_checked(sk);
+	psock = sock_map_psock_get_checked(sk);
 	if (IS_ERR(psock)) {
 		ret = PTR_ERR(psock);
 		goto out_progs;
@@ -240,7 +260,7 @@ static int sock_map_link_no_progs(struct bpf_map *map, struct sock *sk)
 	struct sk_psock *psock;
 	int ret;
 
-	psock = sk_psock_get_checked(sk);
+	psock = sock_map_psock_get_checked(sk);
 	if (IS_ERR(psock))
 		return PTR_ERR(psock);
 
@@ -1132,7 +1152,7 @@ int sock_map_prog_update(struct bpf_map *map, struct bpf_prog *prog,
 	return 0;
 }
 
-void sk_psock_unlink(struct sock *sk, struct sk_psock_link *link)
+static void sock_map_unlink(struct sock *sk, struct sk_psock_link *link)
 {
 	switch (link->map->map_type) {
 	case BPF_MAP_TYPE_SOCKMAP:
@@ -1145,3 +1165,54 @@ void sk_psock_unlink(struct sock *sk, struct sk_psock_link *link)
 		break;
 	}
 }
+
+static void sock_map_remove_links(struct sock *sk, struct sk_psock *psock)
+{
+	struct sk_psock_link *link;
+
+	while ((link = sk_psock_link_pop(psock))) {
+		sock_map_unlink(sk, link);
+		sk_psock_free_link(link);
+	}
+}
+
+void sock_map_unhash(struct sock *sk)
+{
+	void (*saved_unhash)(struct sock *sk);
+	struct sk_psock *psock;
+
+	rcu_read_lock();
+	psock = sk_psock(sk);
+	if (unlikely(!psock)) {
+		rcu_read_unlock();
+		if (sk->sk_prot->unhash)
+			sk->sk_prot->unhash(sk);
+		return;
+	}
+
+	saved_unhash = psock->saved_unhash;
+	sock_map_remove_links(sk, psock);
+	rcu_read_unlock();
+	saved_unhash(sk);
+}
+
+void sock_map_close(struct sock *sk, long timeout)
+{
+	void (*saved_close)(struct sock *sk, long timeout);
+	struct sk_psock *psock;
+
+	lock_sock(sk);
+	rcu_read_lock();
+	psock = sk_psock(sk);
+	if (unlikely(!psock)) {
+		rcu_read_unlock();
+		release_sock(sk);
+		return sk->sk_prot->close(sk, timeout);
+	}
+
+	saved_close = psock->saved_close;
+	sock_map_remove_links(sk, psock);
+	rcu_read_unlock();
+	release_sock(sk);
+	saved_close(sk, timeout);
+}
diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
index 7d6e1b75d4d4..3f9a50e54c1d 100644
--- a/net/ipv4/tcp_bpf.c
+++ b/net/ipv4/tcp_bpf.c
@@ -10,6 +10,7 @@
 #include <net/inet_common.h>
 #include <net/tls.h>
 
+#ifdef CONFIG_BPF_STREAM_PARSER
 static bool tcp_bpf_stream_read(const struct sock *sk)
 {
 	struct sk_psock *psock;
@@ -22,6 +23,7 @@ static bool tcp_bpf_stream_read(const struct sock *sk)
 	rcu_read_unlock();
 	return !empty;
 }
+#endif /* CONFIG_BPF_STREAM_PARSER */
 
 static int tcp_bpf_wait_data(struct sock *sk, struct sk_psock *psock,
 			     int flags, long timeo, int *err)
@@ -298,6 +300,7 @@ int tcp_bpf_sendmsg_redir(struct sock *sk, struct sk_msg *msg,
 }
 EXPORT_SYMBOL_GPL(tcp_bpf_sendmsg_redir);
 
+#ifdef CONFIG_BPF_STREAM_PARSER
 static int tcp_bpf_send_verdict(struct sock *sk, struct sk_psock *psock,
 				struct sk_msg *msg, int *copied, int flags)
 {
@@ -528,57 +531,6 @@ static int tcp_bpf_sendpage(struct sock *sk, struct page *page, int offset,
 	return copied ? copied : err;
 }
 
-static void tcp_bpf_remove(struct sock *sk, struct sk_psock *psock)
-{
-	struct sk_psock_link *link;
-
-	while ((link = sk_psock_link_pop(psock))) {
-		sk_psock_unlink(sk, link);
-		sk_psock_free_link(link);
-	}
-}
-
-static void tcp_bpf_unhash(struct sock *sk)
-{
-	void (*saved_unhash)(struct sock *sk);
-	struct sk_psock *psock;
-
-	rcu_read_lock();
-	psock = sk_psock(sk);
-	if (unlikely(!psock)) {
-		rcu_read_unlock();
-		if (sk->sk_prot->unhash)
-			sk->sk_prot->unhash(sk);
-		return;
-	}
-
-	saved_unhash = psock->saved_unhash;
-	tcp_bpf_remove(sk, psock);
-	rcu_read_unlock();
-	saved_unhash(sk);
-}
-
-static void tcp_bpf_close(struct sock *sk, long timeout)
-{
-	void (*saved_close)(struct sock *sk, long timeout);
-	struct sk_psock *psock;
-
-	lock_sock(sk);
-	rcu_read_lock();
-	psock = sk_psock(sk);
-	if (unlikely(!psock)) {
-		rcu_read_unlock();
-		release_sock(sk);
-		return sk->sk_prot->close(sk, timeout);
-	}
-
-	saved_close = psock->saved_close;
-	tcp_bpf_remove(sk, psock);
-	rcu_read_unlock();
-	release_sock(sk);
-	saved_close(sk, timeout);
-}
-
 enum {
 	TCP_BPF_IPV4,
 	TCP_BPF_IPV6,
@@ -599,8 +551,8 @@ static void tcp_bpf_rebuild_protos(struct proto prot[TCP_BPF_NUM_CFGS],
 				   struct proto *base)
 {
 	prot[TCP_BPF_BASE]			= *base;
-	prot[TCP_BPF_BASE].unhash		= tcp_bpf_unhash;
-	prot[TCP_BPF_BASE].close		= tcp_bpf_close;
+	prot[TCP_BPF_BASE].unhash		= sock_map_unhash;
+	prot[TCP_BPF_BASE].close		= sock_map_close;
 	prot[TCP_BPF_BASE].recvmsg		= tcp_bpf_recvmsg;
 	prot[TCP_BPF_BASE].stream_memory_read	= tcp_bpf_stream_read;
 
@@ -707,3 +659,4 @@ void tcp_bpf_clone(const struct sock *sk, struct sock *newsk)
 	if (prot == &tcp_bpf_prots[family][TCP_BPF_BASE])
 		newsk->sk_prot = sk->sk_prot_creator;
 }
+#endif /* CONFIG_BPF_STREAM_PARSER */
-- 
2.20.1

