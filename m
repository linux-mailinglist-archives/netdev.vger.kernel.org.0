Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0519217DE6D
	for <lists+netdev@lfdr.de>; Mon,  9 Mar 2020 12:14:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726901AbgCILN0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 07:13:26 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:37449 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725956AbgCILNU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Mar 2020 07:13:20 -0400
Received: by mail-wr1-f68.google.com with SMTP id 6so10531358wre.4
        for <netdev@vger.kernel.org>; Mon, 09 Mar 2020 04:13:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fj6q8nKdbhzIPbe8bJFwYe1Wz8HuLpu2bXhMZ8eXgbI=;
        b=EgCNYDwdCAH0hbBs8D/7Srtr9BsR2vk0GbFL2RYwrMD1hZNxW4VFO3zc+sn9VHpkAd
         AkSCAeDrJgFGVED4rxvHoCNnc2LlLBqeAvbMLT1wD6bvosq2OapjOUJnO7i9gnA1GAJp
         TKr6oQ4TGwKRVASBxf3F2ACqmhN4SPA9CAv58=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fj6q8nKdbhzIPbe8bJFwYe1Wz8HuLpu2bXhMZ8eXgbI=;
        b=Qi+ua0Jf3VwCEpZ1+HcyvVrcIgGfawYtySkDRpTG+yRUcDrtBl/QNL3fPvyl66oQGT
         5PkGMpaNlpqp7sqCyyyH61X/IdkDYa36eq1zXtwMunBeJm9p49FOzLxPQso/Gm9pVN0e
         uD7B7pnBWcf7+625Yj3lTJjfTA9UwsXn3zVq8Y3DKxDSX5YnGRXDS5iSJDTiCEdn8BTp
         +Wu+wLNr/2eQy9E0o5wxOQmCSKfmCtDouoQD91EWtZeaPcZS1Ip9L3fZEKeUWw2dBPzq
         30GeaC/NOEZ2/EfOfBIarWcqzPSXejyqccMnO5Ffpt0r7TyddxPJ46OC0ordCwQxmZi/
         jsfA==
X-Gm-Message-State: ANhLgQ0fEz3yShy5aYTTaWcmh7zd9udFGkzFjX62t4nFfi+sigRc+ijo
        7iZtZ9aAp/1fgjFaO3E/+FJFyQ==
X-Google-Smtp-Source: ADFU+vtYnTcdYhlJ83kV2U1Y5cReFplkear+nIjA5iko/6Q85uHsimlW2hXSHyQwUOC+LlntaZt3nw==
X-Received: by 2002:adf:a285:: with SMTP id s5mr21672189wra.118.1583752398052;
        Mon, 09 Mar 2020 04:13:18 -0700 (PDT)
Received: from localhost.localdomain ([2a06:98c0:1000:8250:3dcc:c1d:7f05:4873])
        by smtp.gmail.com with ESMTPSA id a5sm25732846wmb.37.2020.03.09.04.13.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Mar 2020 04:13:17 -0700 (PDT)
From:   Lorenz Bauer <lmb@cloudflare.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Cc:     kernel-team@cloudflare.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH bpf-next v4 05/12] bpf: sockmap: move generic sockmap hooks from BPF TCP
Date:   Mon,  9 Mar 2020 11:12:36 +0000
Message-Id: <20200309111243.6982-6-lmb@cloudflare.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200309111243.6982-1-lmb@cloudflare.com>
References: <20200309111243.6982-1-lmb@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The init, close and unhash handlers from TCP sockmap are generic,
and can be reused by UDP sockmap. Move the helpers into the sockmap code
base and expose them. This requires tcp_bpf_get_proto and tcp_bpf_clone to
be conditional on BPF_STREAM_PARSER.

The moved functions are unmodified, except that sk_psock_unlink is
renamed to sock_map_unlink to better match its behaviour.

Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
Reviewed-by: Jakub Sitnicki <jakub@cloudflare.com>
Acked-by: John Fastabend <john.fastabend@gmail.com>
---
 include/linux/bpf.h   |   4 +-
 include/linux/skmsg.h |  28 -----------
 include/net/tcp.h     |  15 +++---
 net/core/sock_map.c   | 106 ++++++++++++++++++++++++++++++++++++++++--
 net/ipv4/tcp_bpf.c    |  84 ++-------------------------------
 5 files changed, 118 insertions(+), 119 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 40c53924571d..94a329b9da81 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1419,6 +1419,8 @@ static inline void bpf_map_offload_map_free(struct bpf_map *map)
 #if defined(CONFIG_BPF_STREAM_PARSER)
 int sock_map_prog_update(struct bpf_map *map, struct bpf_prog *prog, u32 which);
 int sock_map_get_from_fd(const union bpf_attr *attr, struct bpf_prog *prog);
+void sock_map_unhash(struct sock *sk);
+void sock_map_close(struct sock *sk, long timeout);
 #else
 static inline int sock_map_prog_update(struct bpf_map *map,
 				       struct bpf_prog *prog, u32 which)
@@ -1431,7 +1433,7 @@ static inline int sock_map_get_from_fd(const union bpf_attr *attr,
 {
 	return -EINVAL;
 }
-#endif
+#endif /* CONFIG_BPF_STREAM_PARSER */
 
 #if defined(CONFIG_INET) && defined(CONFIG_BPF_SYSCALL)
 void bpf_sk_reuseport_detach(struct sock *sk);
diff --git a/include/linux/skmsg.h b/include/linux/skmsg.h
index 2be51b7a5800..8a709f63c5e5 100644
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
 
@@ -399,26 +391,6 @@ static inline bool sk_psock_test_state(const struct sk_psock *psock,
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
index ad3abeaa703e..43fa07a36fa6 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -2195,19 +2195,22 @@ void tcp_update_ulp(struct sock *sk, struct proto *p,
 struct sk_msg;
 struct sk_psock;
 
+#ifdef CONFIG_BPF_STREAM_PARSER
+struct proto *tcp_bpf_get_proto(struct sock *sk, struct sk_psock *psock);
+void tcp_bpf_clone(const struct sock *sk, struct sock *newsk);
+#else
+static inline void tcp_bpf_clone(const struct sock *sk, struct sock *newsk)
+{
+}
+#endif /* CONFIG_BPF_STREAM_PARSER */
+
 #ifdef CONFIG_NET_SOCK_MSG
-int tcp_bpf_init(struct sock *sk);
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
index fafcbd22ecba..cb240d87e068 100644
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -141,6 +141,51 @@ static void sock_map_unref(struct sock *sk, void *link_raw)
 	}
 }
 
+static int sock_map_init_proto(struct sock *sk)
+{
+	struct sk_psock *psock;
+	struct proto *prot;
+
+	sock_owned_by_me(sk);
+
+	rcu_read_lock();
+	psock = sk_psock(sk);
+	if (unlikely(!psock)) {
+		rcu_read_unlock();
+		return -EINVAL;
+	}
+
+	prot = tcp_bpf_get_proto(sk, psock);
+	if (IS_ERR(prot)) {
+		rcu_read_unlock();
+		return PTR_ERR(prot);
+	}
+
+	sk_psock_update_proto(sk, psock, prot);
+	rcu_read_unlock();
+	return 0;
+}
+
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
@@ -172,7 +217,7 @@ static int sock_map_link(struct bpf_map *map, struct sk_psock_progs *progs,
 		}
 	}
 
-	psock = sk_psock_get_checked(sk);
+	psock = sock_map_psock_get_checked(sk);
 	if (IS_ERR(psock)) {
 		ret = PTR_ERR(psock);
 		goto out_progs;
@@ -196,7 +241,7 @@ static int sock_map_link(struct bpf_map *map, struct sk_psock_progs *progs,
 	if (msg_parser)
 		psock_set_prog(&psock->progs.msg_parser, msg_parser);
 
-	ret = tcp_bpf_init(sk);
+	ret = sock_map_init_proto(sk);
 	if (ret < 0)
 		goto out_drop;
 
@@ -231,7 +276,7 @@ static int sock_map_link_no_progs(struct bpf_map *map, struct sock *sk)
 	struct sk_psock *psock;
 	int ret;
 
-	psock = sk_psock_get_checked(sk);
+	psock = sock_map_psock_get_checked(sk);
 	if (IS_ERR(psock))
 		return PTR_ERR(psock);
 
@@ -241,7 +286,7 @@ static int sock_map_link_no_progs(struct bpf_map *map, struct sock *sk)
 			return -ENOMEM;
 	}
 
-	ret = tcp_bpf_init(sk);
+	ret = sock_map_init_proto(sk);
 	if (ret < 0)
 		sk_psock_put(sk, psock);
 	return ret;
@@ -1120,7 +1165,7 @@ int sock_map_prog_update(struct bpf_map *map, struct bpf_prog *prog,
 	return 0;
 }
 
-void sk_psock_unlink(struct sock *sk, struct sk_psock_link *link)
+static void sock_map_unlink(struct sock *sk, struct sk_psock_link *link)
 {
 	switch (link->map->map_type) {
 	case BPF_MAP_TYPE_SOCKMAP:
@@ -1133,3 +1178,54 @@ void sk_psock_unlink(struct sock *sk, struct sk_psock_link *link)
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
index ed8a8f3c9afe..fe7b4fbc31c1 100644
--- a/net/ipv4/tcp_bpf.c
+++ b/net/ipv4/tcp_bpf.c
@@ -528,57 +528,7 @@ static int tcp_bpf_sendpage(struct sock *sk, struct page *page, int offset,
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
+#ifdef CONFIG_BPF_STREAM_PARSER
 enum {
 	TCP_BPF_IPV4,
 	TCP_BPF_IPV6,
@@ -599,8 +549,8 @@ static void tcp_bpf_rebuild_protos(struct proto prot[TCP_BPF_NUM_CFGS],
 				   struct proto *base)
 {
 	prot[TCP_BPF_BASE]			= *base;
-	prot[TCP_BPF_BASE].unhash		= tcp_bpf_unhash;
-	prot[TCP_BPF_BASE].close		= tcp_bpf_close;
+	prot[TCP_BPF_BASE].unhash		= sock_map_unhash;
+	prot[TCP_BPF_BASE].close		= sock_map_close;
 	prot[TCP_BPF_BASE].recvmsg		= tcp_bpf_recvmsg;
 	prot[TCP_BPF_BASE].stream_memory_read	= tcp_bpf_stream_read;
 
@@ -640,7 +590,7 @@ static int tcp_bpf_assert_proto_ops(struct proto *ops)
 	       ops->sendpage == tcp_sendpage ? 0 : -ENOTSUPP;
 }
 
-static struct proto *tcp_bpf_get_proto(struct sock *sk, struct sk_psock *psock)
+struct proto *tcp_bpf_get_proto(struct sock *sk, struct sk_psock *psock)
 {
 	int family = sk->sk_family == AF_INET6 ? TCP_BPF_IPV6 : TCP_BPF_IPV4;
 	int config = psock->progs.msg_parser   ? TCP_BPF_TX   : TCP_BPF_BASE;
@@ -657,31 +607,6 @@ static struct proto *tcp_bpf_get_proto(struct sock *sk, struct sk_psock *psock)
 	return &tcp_bpf_prots[family][config];
 }
 
-int tcp_bpf_init(struct sock *sk)
-{
-	struct sk_psock *psock;
-	struct proto *prot;
-
-	sock_owned_by_me(sk);
-
-	rcu_read_lock();
-	psock = sk_psock(sk);
-	if (unlikely(!psock)) {
-		rcu_read_unlock();
-		return -EINVAL;
-	}
-
-	prot = tcp_bpf_get_proto(sk, psock);
-	if (IS_ERR(prot)) {
-		rcu_read_unlock();
-		return PTR_ERR(prot);
-	}
-
-	sk_psock_update_proto(sk, psock, prot);
-	rcu_read_unlock();
-	return 0;
-}
-
 /* If a child got cloned from a listening socket that had tcp_bpf
  * protocol callbacks installed, we need to restore the callbacks to
  * the default ones because the child does not inherit the psock state
@@ -695,3 +620,4 @@ void tcp_bpf_clone(const struct sock *sk, struct sock *newsk)
 	if (prot == &tcp_bpf_prots[family][TCP_BPF_BASE])
 		newsk->sk_prot = sk->sk_prot_creator;
 }
+#endif /* CONFIG_BPF_STREAM_PARSER */
-- 
2.20.1

