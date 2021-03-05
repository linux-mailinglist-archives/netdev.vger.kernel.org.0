Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12F1132DF51
	for <lists+netdev@lfdr.de>; Fri,  5 Mar 2021 02:57:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229792AbhCEB5K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Mar 2021 20:57:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229750AbhCEB5J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Mar 2021 20:57:09 -0500
Received: from mail-oo1-xc2e.google.com (mail-oo1-xc2e.google.com [IPv6:2607:f8b0:4864:20::c2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59273C061574;
        Thu,  4 Mar 2021 17:57:09 -0800 (PST)
Received: by mail-oo1-xc2e.google.com with SMTP id x19so52507ooj.10;
        Thu, 04 Mar 2021 17:57:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=02/+efQXRRhrxIoXzRQc0o39Iu9TKok5AO33e3HYfho=;
        b=pyu1tFw1P+8WOpYKHuBWrvTeLCsN1zwWxTxePpNS6s9LbTantjhr/SX693zmK+CU/B
         SAo8orO9A1Ae4OsHT21TMIcpZYeWO8ftQYCyfUlNvFVMinM9THgP6XjuYoIOpk34V7MA
         SGmng1W/el0G9i+Fd//r//cKiY3QCzJcVJ5FsBqlG22uwTVKDS3H9FTLtpDBcHs/TJtU
         315MS/ykGFTfTZ2CdodMObrMazBvIVOPHRn/Cls/aXrqyT1g4Nxiz6G5YHPvkZDnvr9T
         krcB3bMHNtKv6ZEgxE8hQ7PwVllokp50hcmT6OrK9Hnd+HcBCfPH4RtFEwDx1Ue+v6y+
         dyOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=02/+efQXRRhrxIoXzRQc0o39Iu9TKok5AO33e3HYfho=;
        b=jXSStJvuuO2hche6PG5/tBeCCgKo4CiAs/hY6f1/HofUpadFU/MLANTI3Oi17WrwtT
         SIy4o1Qy1rG/NS7XB+kME/oerdiLscSGH+vwIKt1uitzHnjDFJYL/Gflp+XfB0CHCll0
         Qyf0MHTdHQ7o1D4C3RLErS3bX6KR7x5SkCTF1TegC+SJPgQsvfFlFoebS8B7xvGLT6Qs
         ZSnBwV3UE4q8SuB3B9GgqHuYcRI4FR0PVSe7JgBLqUR8kK+ktQQ+Y6XSU1Z0hXbMp/cL
         ypP1K1rnn2Q80jFHmgJYahLW6JrJhAlCy9Ogw9rLOgqnz3KTpJCOY/tMZY7qOVJ78n0X
         Txhg==
X-Gm-Message-State: AOAM532nnXKH1DNKWJ2uubzVkUhBxnkm7qnx9P2LeD6z7+T1WAA+fZoD
        3EM7jvf2E9okpXSz4d+RkOJLxGKFgEDzYQ==
X-Google-Smtp-Source: ABdhPJzpjWrNE3vkoFY6jP8dk1+NUwGDe7/bG/iyBSERM9kI4ZdzzSkhjbKm6d2tWZ/UIXCjKrivvA==
X-Received: by 2002:a4a:a5cc:: with SMTP id k12mr5849754oom.37.1614909427973;
        Thu, 04 Mar 2021 17:57:07 -0800 (PST)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:95de:1d5:1b36:946a])
        by smtp.gmail.com with ESMTPSA id r3sm224126oif.5.2021.03.04.17.57.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Mar 2021 17:57:07 -0800 (PST)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, duanxiongchun@bytedance.com,
        wangdongdong.6@bytedance.com, jiang.wang@bytedance.com,
        Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: [Patch bpf-next v3 2/9] sock: introduce sk->sk_prot->psock_update_sk_prot()
Date:   Thu,  4 Mar 2021 17:56:48 -0800
Message-Id: <20210305015655.14249-3-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210305015655.14249-1-xiyou.wangcong@gmail.com>
References: <20210305015655.14249-1-xiyou.wangcong@gmail.com>
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
index 451530d41af7..c2e2bdff7338 100644
--- a/include/linux/skmsg.h
+++ b/include/linux/skmsg.h
@@ -98,6 +98,7 @@ struct sk_psock {
 	void (*saved_close)(struct sock *sk, long timeout);
 	void (*saved_write_space)(struct sock *sk);
 	void (*saved_data_ready)(struct sock *sk);
+	int  (*psock_update_sk_prot)(struct sock *sk, bool restore);
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
+	if (psock->psock_update_sk_prot)
+		psock->psock_update_sk_prot(sk, true);
 }
 
 static inline void sk_psock_set_state(struct sk_psock *psock,
diff --git a/include/net/sock.h b/include/net/sock.h
index 636810ddcd9b..eda64fbd5e3d 100644
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
index 3bddd9dd2da2..7346c93d0f71 100644
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
index 17c322b875fd..2022de8b625a 100644
--- a/net/ipv4/tcp_bpf.c
+++ b/net/ipv4/tcp_bpf.c
@@ -601,20 +601,38 @@ static int tcp_bpf_assert_proto_ops(struct proto *ops)
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
index bd44ded7e50c..4fdc58a9e19e 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -2134,6 +2134,9 @@ struct proto tcpv6_prot = {
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

