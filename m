Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAD1E34BED8
	for <lists+netdev@lfdr.de>; Sun, 28 Mar 2021 22:21:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231585AbhC1UUy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Mar 2021 16:20:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231303AbhC1UU3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Mar 2021 16:20:29 -0400
Received: from mail-oi1-x22a.google.com (mail-oi1-x22a.google.com [IPv6:2607:f8b0:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84FB2C061756;
        Sun, 28 Mar 2021 13:20:28 -0700 (PDT)
Received: by mail-oi1-x22a.google.com with SMTP id k25so11246062oic.4;
        Sun, 28 Mar 2021 13:20:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zvaggGnRUD+zn2YaUId4cvDCkS8Ol7rCuAuVLFLyeI8=;
        b=PnFaIwb8hKHTjIk6WfVM2xNyfjr/cIaIwYeayr5po8++RCVzqThLkoF2afhY2XDjQ1
         MfS/4qPfWKSLhggWJt5kDqKImOxXVqnmzuXpvex9DhUubd4bENzFRD9nSyHmds8xcoRe
         bQrvho7u8/Uy+SQWGLOYsmoc5HkywnDjrBdJ/A6WI6j1RzQhzWGXTqhRA2jYRp41b4XG
         rj2YM+nIwPDguf+qzmlLM/3C5qkLTgTLMdnedkYwsZ1ZZvuRcr1LrZFpLzXPn42rqZ+4
         zXIzA0rxoDXFeU1STrp3XwAZiEiQg+CYfnDdvX5nMUkjptonWCeMmK3xLStNegSsa8Wy
         ihvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zvaggGnRUD+zn2YaUId4cvDCkS8Ol7rCuAuVLFLyeI8=;
        b=h2ZESDEBvLi0kyDKRkhaHWWUf+uGBJkx0IHQ4fRqcAxrxogSkjGBg4VyER5MixGRQ2
         rQx8A4QNvXvO09vj2UWZDE0NJl3rQLK85M87w0PZGCrGGuJuh/pWI1xgQ7V66FYfvGPg
         O5w9opPhdjtiI0qBESAq11N78cnAyRx/8JTzWqQhLjiwtiiTI9WBzoJyG0LIcnryBei1
         vnLXCx012VYW0CDZUPLzhCijTfLPfpFQZAU3Xh3ayED4K/RGBMgsUXYd4bg83p6sPeC1
         1bhPDN82iCSQBu4tlnJ32iwNNk7B7x7oPrzwQ57y4dlQL2kErpb0jm8iNW6fhxxx5+qg
         QT+w==
X-Gm-Message-State: AOAM532evyo0ynVAYml4D5Nw7CGfFi+Q01VTZDs2Mf3jfqIbr8VEcByO
        h+rrYsXy7T7S4KXLUhaWv3y2lX9GQlQ16g==
X-Google-Smtp-Source: ABdhPJzrfoDDjC8B5dsxt1BtdKevYEeB4sL3F7Lpbuba+szbcCszIkRYzygW8M6EqmalUkyK7oL9lw==
X-Received: by 2002:a05:6808:9ad:: with SMTP id e13mr2358709oig.63.1616962827818;
        Sun, 28 Mar 2021 13:20:27 -0700 (PDT)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:bca7:4b69:be8f:21bb])
        by smtp.gmail.com with ESMTPSA id v30sm3898240otb.23.2021.03.28.13.20.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Mar 2021 13:20:27 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, duanxiongchun@bytedance.com,
        wangdongdong.6@bytedance.com, jiang.wang@bytedance.com,
        Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: [Patch bpf-next v7 08/13] sock: introduce sk->sk_prot->psock_update_sk_prot()
Date:   Sun, 28 Mar 2021 13:20:08 -0700
Message-Id: <20210328202013.29223-9-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210328202013.29223-1-xiyou.wangcong@gmail.com>
References: <20210328202013.29223-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

Currently sockmap calls into each protocol to update the struct
proto and replace it. This certainly won't work when the protocol
is implemented as a module, for example, AF_UNIX.

Introduce a new ops sk->sk_prot->psock_update_sk_prot(), so each
protocol can implement its own way to replace the struct proto.
This also helps get rid of symbol dependencies on CONFIG_INET.

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
 net/ipv4/tcp_bpf.c    | 24 +++++++++++++++++++++---
 net/ipv4/tcp_ipv4.c   |  3 +++
 net/ipv4/udp.c        |  3 +++
 net/ipv4/udp_bpf.c    | 15 +++++++++++++--
 net/ipv6/tcp_ipv6.c   |  3 +++
 net/ipv6/udp.c        |  3 +++
 12 files changed, 58 insertions(+), 45 deletions(-)

diff --git a/include/linux/skmsg.h b/include/linux/skmsg.h
index c83dbc2d81d9..5e800ddc2dc6 100644
--- a/include/linux/skmsg.h
+++ b/include/linux/skmsg.h
@@ -99,6 +99,7 @@ struct sk_psock {
 	void (*saved_close)(struct sock *sk, long timeout);
 	void (*saved_write_space)(struct sock *sk);
 	void (*saved_data_ready)(struct sock *sk);
+	int  (*psock_update_sk_prot)(struct sock *sk, bool restore);
 	struct proto			*sk_proto;
 	struct mutex			work_mutex;
 	struct sk_psock_work_state	work_state;
@@ -395,25 +396,12 @@ static inline void sk_psock_cork_free(struct sk_psock *psock)
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
+	if (psock->psock_update_sk_prot)
+		psock->psock_update_sk_prot(sk, true);
 }
 
 static inline void sk_psock_set_state(struct sk_psock *psock,
diff --git a/include/net/sock.h b/include/net/sock.h
index 0b6266fd6bf6..8b4155e756c2 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1184,6 +1184,9 @@ struct proto {
 	void			(*unhash)(struct sock *sk);
 	void			(*rehash)(struct sock *sk);
 	int			(*get_port)(struct sock *sk, unsigned short snum);
+#ifdef CONFIG_BPF_SYSCALL
+	int			(*psock_update_sk_prot)(struct sock *sk, bool restore);
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
index a045812d7c78..9fc83f7cc1a0 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -562,11 +562,6 @@ struct sk_psock *sk_psock_init(struct sock *sk, int node)
 
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
index c46709786a49..d04b98fc8104 100644
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
+	if (!sk->sk_prot->psock_update_sk_prot)
 		return -EINVAL;
-	}
-
-	if (IS_ERR(prot))
-		return PTR_ERR(prot);
-
-	sk_psock_update_proto(sk, psock, prot);
-	return 0;
+	psock->psock_update_sk_prot = sk->sk_prot->psock_update_sk_prot;
+	return sk->sk_prot->psock_update_sk_prot(sk, false);
 }
 
 static struct sk_psock *sock_map_psock_get_checked(struct sock *sk)
@@ -570,7 +554,7 @@ static bool sock_map_redirect_allowed(const struct sock *sk)
 
 static bool sock_map_sk_is_suitable(const struct sock *sk)
 {
-	return sk_is_tcp(sk) || sk_is_udp(sk);
+	return !!sk->sk_prot->psock_update_sk_prot;
 }
 
 static bool sock_map_sk_state_allowed(const struct sock *sk)
diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
index ae980716d896..ac8cfbaeacd2 100644
--- a/net/ipv4/tcp_bpf.c
+++ b/net/ipv4/tcp_bpf.c
@@ -595,20 +595,38 @@ static int tcp_bpf_assert_proto_ops(struct proto *ops)
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
+EXPORT_SYMBOL_GPL(tcp_bpf_update_proto);
 
 /* If a child got cloned from a listening socket that had tcp_bpf
  * protocol callbacks installed, we need to restore the callbacks to
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index daad4f99db32..dfc6d1c0e710 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -2806,6 +2806,9 @@ struct proto tcp_prot = {
 	.hash			= inet_hash,
 	.unhash			= inet_unhash,
 	.get_port		= inet_csk_get_port,
+#ifdef CONFIG_BPF_SYSCALL
+	.psock_update_sk_prot	= tcp_bpf_update_proto,
+#endif
 	.enter_memory_pressure	= tcp_enter_memory_pressure,
 	.leave_memory_pressure	= tcp_leave_memory_pressure,
 	.stream_memory_free	= tcp_stream_memory_free,
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 4a0478b17243..38952aaee3a1 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -2849,6 +2849,9 @@ struct proto udp_prot = {
 	.unhash			= udp_lib_unhash,
 	.rehash			= udp_v4_rehash,
 	.get_port		= udp_v4_get_port,
+#ifdef CONFIG_BPF_SYSCALL
+	.psock_update_sk_prot	= udp_bpf_update_proto,
+#endif
 	.memory_allocated	= &udp_memory_allocated,
 	.sysctl_mem		= sysctl_udp_mem,
 	.sysctl_wmem_offset	= offsetof(struct net, ipv4.sysctl_udp_wmem_min),
diff --git a/net/ipv4/udp_bpf.c b/net/ipv4/udp_bpf.c
index 7a94791efc1a..6001f93cd3a0 100644
--- a/net/ipv4/udp_bpf.c
+++ b/net/ipv4/udp_bpf.c
@@ -41,12 +41,23 @@ static int __init udp_bpf_v4_build_proto(void)
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
+EXPORT_SYMBOL_GPL(udp_bpf_update_proto);
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index d0f007741e8e..bff22d6ef516 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -2139,6 +2139,9 @@ struct proto tcpv6_prot = {
 	.hash			= inet6_hash,
 	.unhash			= inet_unhash,
 	.get_port		= inet_csk_get_port,
+#ifdef CONFIG_BPF_SYSCALL
+	.psock_update_sk_prot	= tcp_bpf_update_proto,
+#endif
 	.enter_memory_pressure	= tcp_enter_memory_pressure,
 	.leave_memory_pressure	= tcp_leave_memory_pressure,
 	.stream_memory_free	= tcp_stream_memory_free,
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index d25e5a9252fd..ef2c75bb4771 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -1713,6 +1713,9 @@ struct proto udpv6_prot = {
 	.unhash			= udp_lib_unhash,
 	.rehash			= udp_v6_rehash,
 	.get_port		= udp_v6_get_port,
+#ifdef CONFIG_BPF_SYSCALL
+	.psock_update_sk_prot	= udp_bpf_update_proto,
+#endif
 	.memory_allocated	= &udp_memory_allocated,
 	.sysctl_mem		= sysctl_udp_mem,
 	.sysctl_wmem_offset     = offsetof(struct net, ipv4.sysctl_udp_wmem_min),
-- 
2.25.1

