Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 864C916C2E5
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 14:56:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730488AbgBYN4t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 08:56:49 -0500
Received: from mail-wm1-f42.google.com ([209.85.128.42]:37463 "EHLO
        mail-wm1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730228AbgBYN4r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Feb 2020 08:56:47 -0500
Received: by mail-wm1-f42.google.com with SMTP id a6so3245942wme.2
        for <netdev@vger.kernel.org>; Tue, 25 Feb 2020 05:56:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=59eBK88lSB2D3XYVgkWiAVbz/oypnY57KcXTslgb3N4=;
        b=MXNOXsKCId+2rMAmz4n/MBNehlvM6kr6+fn0eMk8c5kXH862yUO29DckTmxPSyxa/H
         lwOfk2FInlStT3opaXvII+8lqm6rAqUUjh1FQwxlo3oubAuwfbhWyHqDa505pRO4IEwR
         /40NMURLeXMg3RoOPNtZZvL/+6dF+C5Jr6Otg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=59eBK88lSB2D3XYVgkWiAVbz/oypnY57KcXTslgb3N4=;
        b=bHOL8J8jd/myVxlIxlc9KSABVmsjljWBGXduasumrSB6jnkvXIYMEAKgpBGeZEHATi
         vMA/wMRscu7DUO9SO4svQEIwcKQ5u1dh3ZZEOglHjddr5pM2+3C5gsWyqRaCXHMIibdb
         gCcHWG6situXOMbJRY46dA6qTfRZT+97VoA69FW1ISnUOMTf7Kz3QpCtga2QwF6FYaQF
         QLJjRlm2Gid41ZOt7hkmMud45KT31vov3FDFFJhuUM7TniRhUaY3qIddyraxxZe4zYgZ
         oWTeiK6/eR6RxP2yq7sdS3STFAd3IQtDc8Ea5TL4yvKxbpJTABueHJvVS04Ta7TI3IDa
         lgXg==
X-Gm-Message-State: APjAAAVN3XQskRo4bzyvFWYlepUrcnx5IvdtbIO8NsOAPmInadRrKTQ1
        mDix+XI9NEBV/URXGRh2pDOgpqFs5K7Jjw==
X-Google-Smtp-Source: APXvYqxTNO5ANWSYyQ1ef+Vvc2vX6TKpdqbsIY57CNG7Sjv2XfE5AkWTWeBaOm6Pzc5QqTZurorIHg==
X-Received: by 2002:a1c:1d90:: with SMTP id d138mr3608448wmd.163.1582639005208;
        Tue, 25 Feb 2020 05:56:45 -0800 (PST)
Received: from localhost.localdomain ([2a06:98c0:1000:8800:3dea:15ba:1870:8e94])
        by smtp.gmail.com with ESMTPSA id t128sm4463580wmf.28.2020.02.25.05.56.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Feb 2020 05:56:44 -0800 (PST)
From:   Lorenz Bauer <lmb@cloudflare.com>
To:     ast@kernel.org, daniel@iogearbox.net, john.fastabend@gmail.com
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@cloudflare.com, Lorenz Bauer <lmb@cloudflare.com>
Subject: [PATCH bpf-next 4/7] bpf: sockmap: allow UDP sockets
Date:   Tue, 25 Feb 2020 13:56:33 +0000
Message-Id: <20200225135636.5768-5-lmb@cloudflare.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200225135636.5768-1-lmb@cloudflare.com>
References: <20200225135636.5768-1-lmb@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add basic psock hooks for UDP sockets. This allows adding and
removing sockets, as well as automatic removal on unhash and close.

Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
---
 MAINTAINERS         |  1 +
 include/linux/udp.h |  4 ++++
 net/core/sock_map.c | 47 +++++++++++++++++++++++-----------------
 net/ipv4/Makefile   |  1 +
 net/ipv4/udp_bpf.c  | 53 +++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 86 insertions(+), 20 deletions(-)
 create mode 100644 net/ipv4/udp_bpf.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 2af5fa73155e..495ba52038ad 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9358,6 +9358,7 @@ F:	include/linux/skmsg.h
 F:	net/core/skmsg.c
 F:	net/core/sock_map.c
 F:	net/ipv4/tcp_bpf.c
+F:	net/ipv4/udp_bpf.c
 
 LANTIQ / INTEL Ethernet drivers
 M:	Hauke Mehrtens <hauke@hauke-m.de>
diff --git a/include/linux/udp.h b/include/linux/udp.h
index aa84597bdc33..d90d8fd5f73d 100644
--- a/include/linux/udp.h
+++ b/include/linux/udp.h
@@ -143,4 +143,8 @@ static inline bool udp_unexpected_gso(struct sock *sk, struct sk_buff *skb)
 
 #define IS_UDPLITE(__sk) (__sk->sk_protocol == IPPROTO_UDPLITE)
 
+#if defined(CONFIG_NET_SOCK_MSG)
+int udp_bpf_init(struct sock *sk);
+#endif
+
 #endif	/* _LINUX_UDP_H */
diff --git a/net/core/sock_map.c b/net/core/sock_map.c
index c84cc9fc7f6b..f998192c425f 100644
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -153,7 +153,7 @@ static struct sk_psock *sock_map_psock_get_checked(struct sock *sk)
 	rcu_read_lock();
 	psock = sk_psock(sk);
 	if (psock) {
-		if (sk->sk_prot->recvmsg != tcp_bpf_recvmsg) {
+		if (sk->sk_prot->close != sock_map_close) {
 			psock = ERR_PTR(-EBUSY);
 			goto out;
 		}
@@ -166,6 +166,14 @@ static struct sk_psock *sock_map_psock_get_checked(struct sock *sk)
 	return psock;
 }
 
+static int sock_map_init_hooks(struct sock *sk)
+{
+	if (sk->sk_type == SOCK_DGRAM)
+		return udp_bpf_init(sk);
+	else
+		return tcp_bpf_init(sk);
+}
+
 static int sock_map_link(struct bpf_map *map, struct sk_psock_progs *progs,
 			 struct sock *sk)
 {
@@ -220,7 +228,7 @@ static int sock_map_link(struct bpf_map *map, struct sk_psock_progs *progs,
 	if (msg_parser)
 		psock_set_prog(&psock->progs.msg_parser, msg_parser);
 
-	ret = tcp_bpf_init(sk);
+	ret = sock_map_init_hooks(sk);
 	if (ret < 0)
 		goto out_drop;
 
@@ -267,7 +275,7 @@ static int sock_map_link_no_progs(struct bpf_map *map, struct sock *sk)
 		return -ENOMEM;
 
 init:
-	ret = tcp_bpf_init(sk);
+	ret = sock_map_init_hooks(sk);
 	if (ret < 0)
 		sk_psock_put(sk, psock);
 	return ret;
@@ -394,9 +402,14 @@ static int sock_map_get_next_key(struct bpf_map *map, void *key, void *next)
 	return 0;
 }
 
+static bool sock_map_sk_is_tcp(const struct sock *sk)
+{
+	return sk->sk_type == SOCK_STREAM && sk->sk_protocol == IPPROTO_TCP;
+}
+
 static bool sock_map_redirect_allowed(const struct sock *sk)
 {
-	return sk->sk_state != TCP_LISTEN;
+	return sock_map_sk_is_tcp(sk) && sk->sk_state != TCP_LISTEN;
 }
 
 static int sock_map_update_common(struct bpf_map *map, u32 idx,
@@ -466,15 +479,17 @@ static bool sock_map_op_okay(const struct bpf_sock_ops_kern *ops)
 	       ops->op == BPF_SOCK_OPS_TCP_LISTEN_CB;
 }
 
+static bool sock_map_sk_is_udp(const struct sock *sk)
+{
+	return sk->sk_type == SOCK_DGRAM && sk->sk_protocol == IPPROTO_UDP;
+}
+
 static bool sock_map_sk_is_suitable(const struct sock *sk)
 {
-	return sk->sk_type == SOCK_STREAM &&
-	       sk->sk_protocol == IPPROTO_TCP;
-}
+	const int tcp_flags = TCPF_ESTABLISHED | TCPF_LISTEN | TCPF_SYN_RECV;
 
-static bool sock_map_sk_state_allowed(const struct sock *sk)
-{
-	return (1 << sk->sk_state) & (TCPF_ESTABLISHED | TCPF_LISTEN);
+	return (sock_map_sk_is_udp(sk) && sk_hashed(sk)) ||
+	       (sock_map_sk_is_tcp(sk) && (1 << sk->sk_state) & tcp_flags);
 }
 
 static int sock_map_update_elem(struct bpf_map *map, void *key,
@@ -501,13 +516,9 @@ static int sock_map_update_elem(struct bpf_map *map, void *key,
 		ret = -EINVAL;
 		goto out;
 	}
-	if (!sock_map_sk_is_suitable(sk)) {
-		ret = -EOPNOTSUPP;
-		goto out;
-	}
 
 	sock_map_sk_acquire(sk);
-	if (!sock_map_sk_state_allowed(sk))
+	if (!sock_map_sk_is_suitable(sk))
 		ret = -EOPNOTSUPP;
 	else
 		ret = sock_map_update_common(map, idx, sk, flags);
@@ -849,13 +860,9 @@ static int sock_hash_update_elem(struct bpf_map *map, void *key,
 		ret = -EINVAL;
 		goto out;
 	}
-	if (!sock_map_sk_is_suitable(sk)) {
-		ret = -EOPNOTSUPP;
-		goto out;
-	}
 
 	sock_map_sk_acquire(sk);
-	if (!sock_map_sk_state_allowed(sk))
+	if (!sock_map_sk_is_suitable(sk))
 		ret = -EOPNOTSUPP;
 	else
 		ret = sock_hash_update_common(map, key, sk, flags);
diff --git a/net/ipv4/Makefile b/net/ipv4/Makefile
index 9d97bace13c8..48cc05d365e4 100644
--- a/net/ipv4/Makefile
+++ b/net/ipv4/Makefile
@@ -61,6 +61,7 @@ obj-$(CONFIG_TCP_CONG_LP) += tcp_lp.o
 obj-$(CONFIG_TCP_CONG_YEAH) += tcp_yeah.o
 obj-$(CONFIG_TCP_CONG_ILLINOIS) += tcp_illinois.o
 obj-$(CONFIG_NET_SOCK_MSG) += tcp_bpf.o
+obj-$(CONFIG_NET_SOCK_MSG) += udp_bpf.o
 obj-$(CONFIG_NETLABEL) += cipso_ipv4.o
 
 obj-$(CONFIG_XFRM) += xfrm4_policy.o xfrm4_state.o xfrm4_input.o \
diff --git a/net/ipv4/udp_bpf.c b/net/ipv4/udp_bpf.c
new file mode 100644
index 000000000000..e085a0648a94
--- /dev/null
+++ b/net/ipv4/udp_bpf.c
@@ -0,0 +1,53 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2020 Cloudflare Ltd https://cloudflare.com */
+
+#include <linux/bpf.h>
+#include <linux/filter.h>
+#include <linux/init.h>
+#include <linux/skmsg.h>
+#include <linux/wait.h>
+#include <net/udp.h>
+
+#include <net/inet_common.h>
+
+static int udp_bpf_rebuild_protos(struct proto *prot, struct proto *base)
+{
+	*prot        = *base;
+	prot->unhash = sock_map_unhash;
+	prot->close  = sock_map_close;
+	return 0;
+}
+
+static struct proto *udp_bpf_choose_proto(struct proto prot[],
+					  struct sk_psock *psock)
+{
+	return prot;
+}
+
+static struct proto udpv4_proto;
+static struct proto udpv6_proto;
+
+static struct sk_psock_hooks udp_psock_proto __read_mostly = {
+	.ipv4 = &udpv4_proto,
+	.ipv6 = &udpv6_proto,
+	.rebuild_proto = udp_bpf_rebuild_protos,
+	.choose_proto = udp_bpf_choose_proto,
+};
+
+static int __init udp_bpf_init_psock_hooks(void)
+{
+	return sk_psock_hooks_init(&udp_psock_proto, &udp_prot);
+}
+core_initcall(udp_bpf_init_psock_hooks);
+
+int udp_bpf_init(struct sock *sk)
+{
+	int ret;
+
+	sock_owned_by_me(sk);
+
+	rcu_read_lock();
+	ret = sk_psock_hooks_install(&udp_psock_proto, sk);
+	rcu_read_unlock();
+	return ret;
+}
-- 
2.20.1

