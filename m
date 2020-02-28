Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1E0E1736A2
	for <lists+netdev@lfdr.de>; Fri, 28 Feb 2020 12:55:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727073AbgB1LzM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Feb 2020 06:55:12 -0500
Received: from mail-wm1-f46.google.com ([209.85.128.46]:33247 "EHLO
        mail-wm1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726878AbgB1Lyo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Feb 2020 06:54:44 -0500
Received: by mail-wm1-f46.google.com with SMTP id m10so9187886wmc.0
        for <netdev@vger.kernel.org>; Fri, 28 Feb 2020 03:54:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3AjfHwxc7+pE1DB75z91GO99ApUXoYyaQ80TOOs+VtU=;
        b=Ha0XE9y0tZEnH8zUfgSFRimmtwceWEwDrcihQJALtXrXAganUeAWx+mPpDbOL1d7F6
         9RwEyRZRkB8UaxtfnGcLz0nxG/3xSyVrZNRGXPuhaWKv6fVZYx+NWfqZyUFdsUSyQt8+
         jXvjr4eUBC+1sR9v5pEY5JtDbMPfBxJp0nHhA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3AjfHwxc7+pE1DB75z91GO99ApUXoYyaQ80TOOs+VtU=;
        b=ivFFR6a2qRKjfVj4MAVK6VbmP1qkRPGksPrT30MypdAxB6xXlNsKv8iQqA+ZhYWSTX
         ye1C2GH2D6PM2VYvelvOU16cnbKrGtHSp2QdNGMgt6DYmzXRdYMXbUcCzksAtfRGSMb+
         VSTfoYjOzCdVdxc34wINJ/EFo5izQMjFfbPa7X1vmSRI9yRuerekn2TjIMDiyzpCphLh
         jbpNgT6UJYjx3c3mCG5sbrwcH+3z6Z51QozdIg8h7EWDuD7tdqd95z1NamSCgRmGWJf1
         FLaqoQPdqipY520fv01cZ1Qdy9QUwEegsn4j1slt3IQgC9aUEjA+GTq3jQaRSKJsBdz1
         PPDQ==
X-Gm-Message-State: APjAAAUpOD1cc8DrQPQFTM44PEn58lTMaywO187VfzbTeAzMTSK/wDSA
        FaLNodUvYThGhxLi47TzkbF99A==
X-Google-Smtp-Source: APXvYqxLbwznMzNR4oXKAzcAmPdyIvyhGQxT5DxFukyboaYHpkwdDRSR06Dd0IVjk4RlpDH4HEE0SQ==
X-Received: by 2002:a05:600c:114d:: with SMTP id z13mr4470135wmz.105.1582890882134;
        Fri, 28 Feb 2020 03:54:42 -0800 (PST)
Received: from antares.lan (b.2.d.a.1.b.1.b.2.c.5.e.0.3.d.4.f.f.6.2.a.5.a.7.0.b.8.0.1.0.0.2.ip6.arpa. [2001:8b0:7a5a:26ff:4d30:e5c2:b1b1:ad2b])
        by smtp.gmail.com with ESMTPSA id q125sm2044284wme.19.2020.02.28.03.54.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Feb 2020 03:54:41 -0800 (PST)
From:   Lorenz Bauer <lmb@cloudflare.com>
To:     john.fastabend@gmail.com, Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     kernel-team@cloudflare.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH bpf-next v2 5/9] bpf: sockmap: allow UDP sockets
Date:   Fri, 28 Feb 2020 11:53:40 +0000
Message-Id: <20200228115344.17742-6-lmb@cloudflare.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200228115344.17742-1-lmb@cloudflare.com>
References: <20200228115344.17742-1-lmb@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add basic psock hooks for UDP sockets. This allows adding and
removing sockets, as well as automatic removal on unhash and close.

sock_map_sk_state_allowed is called from the syscall path, and
ensures that only established or listening sockets are added.
No such check exists for the BPF path: we rely on sockets being
in particular states when a BPF sock ops hook is executed.
For the passive open hook this means that sockets are actually in
TCP_SYN_RECV state (and unhashed) when they are added to the
sock map.

UDP sockets are not saddled with this inconsistency, and so the
checks for both syscall and BPF path should be identical. Rather
than duplicating the logic into sock_map_sk_state_allowed merge
it with sock_map_sk_is_suitable.

Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
---
 MAINTAINERS         |  1 +
 include/linux/udp.h |  4 ++++
 net/core/sock_map.c | 52 ++++++++++++++++++++++++++------------------
 net/ipv4/Makefile   |  1 +
 net/ipv4/udp_bpf.c  | 53 +++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 90 insertions(+), 21 deletions(-)
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
index aa84597bdc33..2485a35d113c 100644
--- a/include/linux/udp.h
+++ b/include/linux/udp.h
@@ -143,4 +143,8 @@ static inline bool udp_unexpected_gso(struct sock *sk, struct sk_buff *skb)
 
 #define IS_UDPLITE(__sk) (__sk->sk_protocol == IPPROTO_UDPLITE)
 
+#ifdef CONFIG_BPF_STREAM_PARSER
+int udp_bpf_init(struct sock *sk);
+#endif
+
 #endif	/* _LINUX_UDP_H */
diff --git a/net/core/sock_map.c b/net/core/sock_map.c
index c84cc9fc7f6b..d742e1538ae9 100644
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
@@ -466,15 +479,20 @@ static bool sock_map_op_okay(const struct bpf_sock_ops_kern *ops)
 	       ops->op == BPF_SOCK_OPS_TCP_LISTEN_CB;
 }
 
-static bool sock_map_sk_is_suitable(const struct sock *sk)
+static bool sock_map_sk_is_udp(const struct sock *sk)
 {
-	return sk->sk_type == SOCK_STREAM &&
-	       sk->sk_protocol == IPPROTO_TCP;
+	return sk->sk_type == SOCK_DGRAM && sk->sk_protocol == IPPROTO_UDP;
 }
 
-static bool sock_map_sk_state_allowed(const struct sock *sk)
+static bool sock_map_sk_is_suitable(const struct sock *sk, bool from_bpf)
 {
-	return (1 << sk->sk_state) & (TCPF_ESTABLISHED | TCPF_LISTEN);
+	int tcp_flags = TCPF_ESTABLISHED | TCPF_LISTEN;
+
+	if (from_bpf)
+		tcp_flags |= TCPF_SYN_RECV;
+
+	return (sock_map_sk_is_udp(sk) && sk_hashed(sk)) ||
+	       (sock_map_sk_is_tcp(sk) && (1 << sk->sk_state) & tcp_flags);
 }
 
 static int sock_map_update_elem(struct bpf_map *map, void *key,
@@ -501,13 +519,9 @@ static int sock_map_update_elem(struct bpf_map *map, void *key,
 		ret = -EINVAL;
 		goto out;
 	}
-	if (!sock_map_sk_is_suitable(sk)) {
-		ret = -EOPNOTSUPP;
-		goto out;
-	}
 
 	sock_map_sk_acquire(sk);
-	if (!sock_map_sk_state_allowed(sk))
+	if (!sock_map_sk_is_suitable(sk, false))
 		ret = -EOPNOTSUPP;
 	else
 		ret = sock_map_update_common(map, idx, sk, flags);
@@ -522,7 +536,7 @@ BPF_CALL_4(bpf_sock_map_update, struct bpf_sock_ops_kern *, sops,
 {
 	WARN_ON_ONCE(!rcu_read_lock_held());
 
-	if (likely(sock_map_sk_is_suitable(sops->sk) &&
+	if (likely(sock_map_sk_is_suitable(sops->sk, true) &&
 		   sock_map_op_okay(sops)))
 		return sock_map_update_common(map, *(u32 *)key, sops->sk,
 					      flags);
@@ -849,13 +863,9 @@ static int sock_hash_update_elem(struct bpf_map *map, void *key,
 		ret = -EINVAL;
 		goto out;
 	}
-	if (!sock_map_sk_is_suitable(sk)) {
-		ret = -EOPNOTSUPP;
-		goto out;
-	}
 
 	sock_map_sk_acquire(sk);
-	if (!sock_map_sk_state_allowed(sk))
+	if (!sock_map_sk_is_suitable(sk, false))
 		ret = -EOPNOTSUPP;
 	else
 		ret = sock_hash_update_common(map, key, sk, flags);
@@ -1023,7 +1033,7 @@ BPF_CALL_4(bpf_sock_hash_update, struct bpf_sock_ops_kern *, sops,
 {
 	WARN_ON_ONCE(!rcu_read_lock_held());
 
-	if (likely(sock_map_sk_is_suitable(sops->sk) &&
+	if (likely(sock_map_sk_is_suitable(sops->sk, true) &&
 		   sock_map_op_okay(sops)))
 		return sock_hash_update_common(map, key, sops->sk, flags);
 	return -EOPNOTSUPP;
diff --git a/net/ipv4/Makefile b/net/ipv4/Makefile
index 9d97bace13c8..9e1a186a3671 100644
--- a/net/ipv4/Makefile
+++ b/net/ipv4/Makefile
@@ -61,6 +61,7 @@ obj-$(CONFIG_TCP_CONG_LP) += tcp_lp.o
 obj-$(CONFIG_TCP_CONG_YEAH) += tcp_yeah.o
 obj-$(CONFIG_TCP_CONG_ILLINOIS) += tcp_illinois.o
 obj-$(CONFIG_NET_SOCK_MSG) += tcp_bpf.o
+obj-$(CONFIG_BPF_STREAM_PARSER) += udp_bpf.o
 obj-$(CONFIG_NETLABEL) += cipso_ipv4.o
 
 obj-$(CONFIG_XFRM) += xfrm4_policy.o xfrm4_state.o xfrm4_input.o \
diff --git a/net/ipv4/udp_bpf.c b/net/ipv4/udp_bpf.c
new file mode 100644
index 000000000000..3ecf246076be
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
+static struct sk_psock_hooks udp_bpf_hooks __read_mostly = {
+	.ipv4 = &udpv4_proto,
+	.ipv6 = &udpv6_proto,
+	.rebuild_proto = udp_bpf_rebuild_protos,
+	.choose_proto = udp_bpf_choose_proto,
+};
+
+static int __init udp_bpf_init_psock_hooks(void)
+{
+	return sk_psock_hooks_init(&udp_bpf_hooks, &udp_prot);
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
+	ret = sk_psock_hooks_install(&udp_bpf_hooks, sk);
+	rcu_read_unlock();
+	return ret;
+}
-- 
2.20.1

