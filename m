Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B70832A2E9
	for <lists+netdev@lfdr.de>; Tue,  2 Mar 2021 16:00:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377922AbhCBIpB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Mar 2021 03:45:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1443987AbhCBCil (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Mar 2021 21:38:41 -0500
Received: from mail-ot1-x32e.google.com (mail-ot1-x32e.google.com [IPv6:2607:f8b0:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9670C06178C;
        Mon,  1 Mar 2021 18:37:56 -0800 (PST)
Received: by mail-ot1-x32e.google.com with SMTP id v12so17501922ott.10;
        Mon, 01 Mar 2021 18:37:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=j8szdQHqxNM49f5Dn5eqx7rGepeaUprOkfzillf7fmE=;
        b=poZJmL/g9qNymTsLQdBQPrzyHEh5sb3QIw+QIjIaNj4aaVqu5wtlGSHnfkQNwSK9wk
         UmKvg4YnbdrKHJmq+9Fh/QG9IbVD8Q1ntNs4XUjPAP5nv6fe6gzMIb73jrOz3TdWEhZd
         R0UWvTZnOBUvbPLmv/9rur8ACXSAdDkjOqyUdXtYQPDBT6gvwj3aBuOK7wJUmZeQnud2
         NntMYqaEnLfftTSf9N7VMfqIoBw8MuKKFD9rp5V9hmp8BXyKMAvBc1d5FkYPQIdKqQp1
         qLRzqbtLVEd4JX5z9qM1H6ZO7xXvhdW9rF3FEkci1s2/FcYhH3nNCH0Edqlf//J+5AQC
         J9ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=j8szdQHqxNM49f5Dn5eqx7rGepeaUprOkfzillf7fmE=;
        b=lA7yKQzTjzUNGAVqWulLAtCOe94FLtV/XRPl7YAb/npSU+Htg6qRWJATIC8lawFKZ7
         qpVf26y9RUVmTng3+9xuXcF5YYX3ko6NbW5Txkvsu3HmwAJgvtH115iZjn68HkRisOub
         0y1ogSo4+Ki8q1crobtY3BPeJCQuyDgBYtj9pE9X6rFHB9eh9hUNqmkIBzYnd59BQqS1
         NC71nOdGMUssI1nozkup05vjD3PqZKY+0RrajxxDWxeB+z6PC8YqKr0d6E8y9tGnCfch
         FQ2S2LP8P41YI9Ct4TofL4NIOfsiIK4HBqEsuCyx7oDMuD8k9dmAqCRdBJ/bMh7pknXC
         +gHg==
X-Gm-Message-State: AOAM5325cIKYmmmkLgM5Gm6IJCjFUPDer4yKg+iuRKwrpxaft5z0vdSS
        wIn9knMak0Y6S4jFbTw1Wh9+4IJeEjdt2w==
X-Google-Smtp-Source: ABdhPJzM0P0aOvUFaxvob49yEobeyDrhf8CcYpkHn6GWpxio4HG51XnN1nEqhzPVzDK1OC3twZEegA==
X-Received: by 2002:a05:6830:8d:: with SMTP id a13mr15857425oto.69.1614652676126;
        Mon, 01 Mar 2021 18:37:56 -0800 (PST)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:1bb:8d29:39ef:5fe5])
        by smtp.gmail.com with ESMTPSA id a30sm100058oiy.42.2021.03.01.18.37.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Mar 2021 18:37:55 -0800 (PST)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, duanxiongchun@bytedance.com,
        wangdongdong.6@bytedance.com, jiang.wang@bytedance.com,
        Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: [Patch bpf-next v2 2/9] sock: introduce sk_prot->update_proto()
Date:   Mon,  1 Mar 2021 18:37:36 -0800
Message-Id: <20210302023743.24123-3-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210302023743.24123-1-xiyou.wangcong@gmail.com>
References: <20210302023743.24123-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

Currently sockmap calls into each protocol to update the struct
proto and replace it. This certainly won't work when the protocol
is implemented as a module, for example, AF_UNIX.

Introduce a new ops sk->sk_prot->update_proto(), so each protocol
can implement its own way to replace the struct proto. This also
helps get rid of symbol dependencies on CONFIG_INET.

Cc: John Fastabend <john.fastabend@gmail.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Jakub Sitnicki <jakub@cloudflare.com>
Cc: Lorenz Bauer <lmb@cloudflare.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 include/linux/skmsg.h | 18 +++---------------
 include/net/sock.h    |  3 +++
 include/net/tcp.h     |  1 +
 include/net/udp.h     |  1 +
 net/core/skmsg.c      |  5 -----
 net/core/sock_map.c   | 24 ++++--------------------
 net/ipv4/tcp_bpf.c    | 23 ++++++++++++++++++++---
 net/ipv4/tcp_ipv4.c   |  3 +++
 net/ipv4/udp.c        |  3 +++
 net/ipv4/udp_bpf.c    | 14 ++++++++++++--
 net/ipv6/tcp_ipv6.c   |  3 +++
 net/ipv6/udp.c        |  3 +++
 12 files changed, 56 insertions(+), 45 deletions(-)

diff --git a/include/linux/skmsg.h b/include/linux/skmsg.h
index 451530d41af7..b5df69d5d397 100644
--- a/include/linux/skmsg.h
+++ b/include/linux/skmsg.h
@@ -98,6 +98,7 @@ struct sk_psock {
 	void (*saved_close)(struct sock *sk, long timeout);
 	void (*saved_write_space)(struct sock *sk);
 	void (*saved_data_ready)(struct sock *sk);
+	int  (*saved_update_proto)(struct sock *sk, bool restore);
 	struct proto			*sk_proto;
 	struct sk_psock_work_state	work_state;
 	struct work_struct		work;
@@ -350,25 +351,12 @@ static inline void sk_psock_cork_free(struct sk_psock *psock)
 	}
 }
 
-static inline void sk_psock_update_proto(struct sock *sk,
-					 struct sk_psock *psock,
-					 struct proto *ops)
-{
-	/* Pairs with lockless read in sk_clone_lock() */
-	WRITE_ONCE(sk->sk_prot, ops);
-}
-
 static inline void sk_psock_restore_proto(struct sock *sk,
 					  struct sk_psock *psock)
 {
 	sk->sk_prot->unhash = psock->saved_unhash;
-	if (inet_csk_has_ulp(sk)) {
-		tcp_update_ulp(sk, psock->sk_proto, psock->saved_write_space);
-	} else {
-		sk->sk_write_space = psock->saved_write_space;
-		/* Pairs with lockless read in sk_clone_lock() */
-		WRITE_ONCE(sk->sk_prot, psock->sk_proto);
-	}
+	if (psock->saved_update_proto)
+		psock->saved_update_proto(sk, true);
 }
 
 static inline void sk_psock_set_state(struct sk_psock *psock,
diff --git a/include/net/sock.h b/include/net/sock.h
index 636810ddcd9b..0e8577c917e8 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1184,6 +1184,9 @@ struct proto {
 	void			(*unhash)(struct sock *sk);
 	void			(*rehash)(struct sock *sk);
 	int			(*get_port)(struct sock *sk, unsigned short snum);
+#ifdef CONFIG_BPF_SYSCALL
+	int			(*update_proto)(struct sock *sk, bool restore);
+#endif
 
 	/* Keeping track of sockets in use */
 #ifdef CONFIG_PROC_FS
diff --git a/include/net/tcp.h b/include/net/tcp.h
index 075de26f449d..2efa4e5ea23d 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -2203,6 +2203,7 @@ struct sk_psock;
 
 #ifdef CONFIG_BPF_SYSCALL
 struct proto *tcp_bpf_get_proto(struct sock *sk, struct sk_psock *psock);
+int tcp_bpf_update_proto(struct sock *sk, bool restore);
 void tcp_bpf_clone(const struct sock *sk, struct sock *newsk);
 #endif /* CONFIG_BPF_SYSCALL */
 
diff --git a/include/net/udp.h b/include/net/udp.h
index d4d064c59232..df7cc1edc200 100644
--- a/include/net/udp.h
+++ b/include/net/udp.h
@@ -518,6 +518,7 @@ static inline struct sk_buff *udp_rcv_segment(struct sock *sk,
 #ifdef CONFIG_BPF_SYSCALL
 struct sk_psock;
 struct proto *udp_bpf_get_proto(struct sock *sk, struct sk_psock *psock);
+int udp_bpf_update_proto(struct sock *sk, bool restore);
 #endif
 
 #endif	/* _UDP_H */
diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index 5efd790f1b47..7dbd8344ec89 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -563,11 +563,6 @@ struct sk_psock *sk_psock_init(struct sock *sk, int node)
 
 	write_lock_bh(&sk->sk_callback_lock);
 
-	if (inet_csk_has_ulp(sk)) {
-		psock = ERR_PTR(-EINVAL);
-		goto out;
-	}
-
 	if (sk->sk_user_data) {
 		psock = ERR_PTR(-EBUSY);
 		goto out;
diff --git a/net/core/sock_map.c b/net/core/sock_map.c
index 3bddd9dd2da2..13d2af5bb81c 100644
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -184,26 +184,10 @@ static void sock_map_unref(struct sock *sk, void *link_raw)
 
 static int sock_map_init_proto(struct sock *sk, struct sk_psock *psock)
 {
-	struct proto *prot;
-
-	switch (sk->sk_type) {
-	case SOCK_STREAM:
-		prot = tcp_bpf_get_proto(sk, psock);
-		break;
-
-	case SOCK_DGRAM:
-		prot = udp_bpf_get_proto(sk, psock);
-		break;
-
-	default:
+	if (!sk->sk_prot->update_proto)
 		return -EINVAL;
-	}
-
-	if (IS_ERR(prot))
-		return PTR_ERR(prot);
-
-	sk_psock_update_proto(sk, psock, prot);
-	return 0;
+	psock->saved_update_proto = sk->sk_prot->update_proto;
+	return sk->sk_prot->update_proto(sk, false);
 }
 
 static struct sk_psock *sock_map_psock_get_checked(struct sock *sk)
@@ -570,7 +554,7 @@ static bool sock_map_redirect_allowed(const struct sock *sk)
 
 static bool sock_map_sk_is_suitable(const struct sock *sk)
 {
-	return sk_is_tcp(sk) || sk_is_udp(sk);
+	return !!sk->sk_prot->update_proto;
 }
 
 static bool sock_map_sk_state_allowed(const struct sock *sk)
diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
index 17c322b875fd..737726c8138c 100644
--- a/net/ipv4/tcp_bpf.c
+++ b/net/ipv4/tcp_bpf.c
@@ -601,19 +601,36 @@ static int tcp_bpf_assert_proto_ops(struct proto *ops)
 	       ops->sendpage == tcp_sendpage ? 0 : -ENOTSUPP;
 }
 
-struct proto *tcp_bpf_get_proto(struct sock *sk, struct sk_psock *psock)
+int tcp_bpf_update_proto(struct sock *sk, bool restore)
 {
+	struct sk_psock *psock = sk_psock(sk);
 	int family = sk->sk_family == AF_INET6 ? TCP_BPF_IPV6 : TCP_BPF_IPV4;
 	int config = psock->progs.msg_parser   ? TCP_BPF_TX   : TCP_BPF_BASE;
 
+	if (restore) {
+		if (inet_csk_has_ulp(sk)) {
+			tcp_update_ulp(sk, psock->sk_proto, psock->saved_write_space);
+		} else {
+			sk->sk_write_space = psock->saved_write_space;
+			/* Pairs with lockless read in sk_clone_lock() */
+			WRITE_ONCE(sk->sk_prot, psock->sk_proto);
+		}
+		return 0;
+	}
+
+	if (inet_csk_has_ulp(sk))
+		return -EINVAL;
+
 	if (sk->sk_family == AF_INET6) {
 		if (tcp_bpf_assert_proto_ops(psock->sk_proto))
-			return ERR_PTR(-EINVAL);
+			return -EINVAL;
 
 		tcp_bpf_check_v6_needs_rebuild(psock->sk_proto);
 	}
 
-	return &tcp_bpf_prots[family][config];
+	/* Pairs with lockless read in sk_clone_lock() */
+	WRITE_ONCE(sk->sk_prot, &tcp_bpf_prots[family][config]);
+	return 0;
 }
 
 /* If a child got cloned from a listening socket that had tcp_bpf
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index daad4f99db32..21c9e262d07c 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -2806,6 +2806,9 @@ struct proto tcp_prot = {
 	.hash			= inet_hash,
 	.unhash			= inet_unhash,
 	.get_port		= inet_csk_get_port,
+#ifdef CONFIG_BPF_SYSCALL
+	.update_proto		= tcp_bpf_update_proto,
+#endif
 	.enter_memory_pressure	= tcp_enter_memory_pressure,
 	.leave_memory_pressure	= tcp_leave_memory_pressure,
 	.stream_memory_free	= tcp_stream_memory_free,
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 4a0478b17243..dbd25b59ce0e 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -2849,6 +2849,9 @@ struct proto udp_prot = {
 	.unhash			= udp_lib_unhash,
 	.rehash			= udp_v4_rehash,
 	.get_port		= udp_v4_get_port,
+#ifdef CONFIG_BPF_SYSCALL
+	.update_proto		= udp_bpf_update_proto,
+#endif
 	.memory_allocated	= &udp_memory_allocated,
 	.sysctl_mem		= sysctl_udp_mem,
 	.sysctl_wmem_offset	= offsetof(struct net, ipv4.sysctl_udp_wmem_min),
diff --git a/net/ipv4/udp_bpf.c b/net/ipv4/udp_bpf.c
index 7a94791efc1a..595836088e85 100644
--- a/net/ipv4/udp_bpf.c
+++ b/net/ipv4/udp_bpf.c
@@ -41,12 +41,22 @@ static int __init udp_bpf_v4_build_proto(void)
 }
 core_initcall(udp_bpf_v4_build_proto);
 
-struct proto *udp_bpf_get_proto(struct sock *sk, struct sk_psock *psock)
+int udp_bpf_update_proto(struct sock *sk, bool restore)
 {
 	int family = sk->sk_family == AF_INET ? UDP_BPF_IPV4 : UDP_BPF_IPV6;
+	struct sk_psock *psock = sk_psock(sk);
+
+	if (restore) {
+		sk->sk_write_space = psock->saved_write_space;
+		/* Pairs with lockless read in sk_clone_lock() */
+		WRITE_ONCE(sk->sk_prot, psock->sk_proto);
+		return 0;
+	}
 
 	if (sk->sk_family == AF_INET6)
 		udp_bpf_check_v6_needs_rebuild(psock->sk_proto);
 
-	return &udp_bpf_prots[family];
+	/* Pairs with lockless read in sk_clone_lock() */
+	WRITE_ONCE(sk->sk_prot, &udp_bpf_prots[family]);
+	return 0;
 }
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index bd44ded7e50c..ea5be7e7fcb8 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -2134,6 +2134,9 @@ struct proto tcpv6_prot = {
 	.hash			= inet6_hash,
 	.unhash			= inet_unhash,
 	.get_port		= inet_csk_get_port,
+#ifdef CONFIG_BPF_SYSCALL
+	.update_proto		= tcp_bpf_update_proto,
+#endif
 	.enter_memory_pressure	= tcp_enter_memory_pressure,
 	.leave_memory_pressure	= tcp_leave_memory_pressure,
 	.stream_memory_free	= tcp_stream_memory_free,
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index d25e5a9252fd..105ba0cf739d 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -1713,6 +1713,9 @@ struct proto udpv6_prot = {
 	.unhash			= udp_lib_unhash,
 	.rehash			= udp_v6_rehash,
 	.get_port		= udp_v6_get_port,
+#ifdef CONFIG_BPF_SYSCALL
+	.update_proto		= udp_bpf_update_proto,
+#endif
 	.memory_allocated	= &udp_memory_allocated,
 	.sysctl_mem		= sysctl_udp_mem,
 	.sysctl_wmem_offset     = offsetof(struct net, ipv4.sysctl_udp_wmem_min),
-- 
2.25.1

