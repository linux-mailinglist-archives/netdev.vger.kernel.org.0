Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05E0E1C6201
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 22:27:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729189AbgEEU1m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 16:27:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729123AbgEEU1j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 16:27:39 -0400
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 190E5C061A10
        for <netdev@vger.kernel.org>; Tue,  5 May 2020 13:27:39 -0700 (PDT)
Received: by mail-qt1-x84a.google.com with SMTP id z8so3012315qtu.17
        for <netdev@vger.kernel.org>; Tue, 05 May 2020 13:27:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=gYaWEKkZQkKb5uQx3SxM8fjVaqeV07VOdxfJw1QzBxM=;
        b=r0UVuiyu95rzput2cIKwtRJ8gOF9GXwk/QFDaOiUTve76z4asiQkBwDublBWWUBYOc
         0PFZyHXtJ1JklBqZyrlS/zGXCSrt/8SOixh9jQiolox/S1UY+s6CzU2pHMXwUggxg82Z
         dZEJNOxYxy403DFmgzYBHgyaghYuyHywdhxwkc+/F+qVK4wBJPxAaiSuZ6+2DpJYB/kv
         lN1XGKm37JHaZXNPxKoEn1TBm4584BHCTFvgTcZq3xs3DWGt59GqsEQK+dcR4LPsAgGQ
         Xab61bqq2P8QtUWacqcWX3bbK53R40fJJxNeAflhWDI76VTME59ZGDVWUmR6bbbT2tWT
         j2xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=gYaWEKkZQkKb5uQx3SxM8fjVaqeV07VOdxfJw1QzBxM=;
        b=UBakJ/sSXUFAXLXu4l30t4pScC1EChYgDpbTMTwxxBGjQjAY9xNkMmzfXgekO/siZ0
         MBPfmd/YlSzenr1y8xjnDRXiNhPARxttNFHkkdiUv01Jl7rPucIx7kUVQJmcgf6VwNJt
         okHHPgvOJSPWXZSU2QjDug60omPWPpcpoQ0d2dCoFkZrWkFICzqy64LcW5NTDjm/SJqI
         6ojD1FlWSOV7ueqNndC60hI+Rzi+B0GJoH91bAyrFvOL5k/NK8xs7MwgFnT+E6CRPqCe
         u42QNivt6OeY7Vqeg+LmJtbS0K6Nz0V/S3yR7ywPHVTKGmRP5aMLv4/0uF/tqyd10npV
         pGhw==
X-Gm-Message-State: AGi0PuZNuFnjPYioRTuLybN0dKzHaOg/8MW7wYdTk5U5r2ItsiUUlhdC
        o1aB4TOEkqDj6pDZuMI+aYuKhd95pS3rQgYizv2ZyksBJDN3N2qHuiG+IDDmiHsxXwUitlXSZ6R
        sHcBU7r864KroP13arP0BGuEPlZNrBKfDjvh7qtfJ3tYHY/hxcCmGAw==
X-Google-Smtp-Source: APiQypI8CmpNvNRETiJ5iwGrXS2AyoIzeu1Cek1sClJ4mORzfDTifmUCFNOeSYJyKFql5hY9Z5DNYYQ=
X-Received: by 2002:a05:6214:572:: with SMTP id cj18mr4510702qvb.209.1588710457906;
 Tue, 05 May 2020 13:27:37 -0700 (PDT)
Date:   Tue,  5 May 2020 13:27:28 -0700
In-Reply-To: <20200505202730.70489-1-sdf@google.com>
Message-Id: <20200505202730.70489-4-sdf@google.com>
Mime-Version: 1.0
References: <20200505202730.70489-1-sdf@google.com>
X-Mailer: git-send-email 2.26.2.526.g744177e7f7-goog
Subject: [PATCH bpf-next v2 3/5] net: refactor arguments of inet{,6}_bind
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>,
        Andrey Ignatov <rdna@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The intent is to add an additional bind parameter in the next commit.
Instead of adding another argument, let's convert all existing
flag arguments into an extendable bit field.

No functional changes.

Cc: Andrey Ignatov <rdna@fb.com>
Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 include/net/inet_common.h |  6 +++++-
 include/net/ipv6_stubs.h  |  2 +-
 net/core/filter.c         |  6 ++++--
 net/ipv4/af_inet.c        | 10 +++++-----
 net/ipv6/af_inet6.c       | 10 +++++-----
 5 files changed, 20 insertions(+), 14 deletions(-)

diff --git a/include/net/inet_common.h b/include/net/inet_common.h
index ae2ba897675c..c38f4f7d660a 100644
--- a/include/net/inet_common.h
+++ b/include/net/inet_common.h
@@ -35,8 +35,12 @@ int inet_shutdown(struct socket *sock, int how);
 int inet_listen(struct socket *sock, int backlog);
 void inet_sock_destruct(struct sock *sk);
 int inet_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len);
+/* Don't allocate port at this moment, defer to connect. */
+#define BIND_FORCE_ADDRESS_NO_PORT	(1 << 0)
+/* Grab and release socket lock. */
+#define BIND_WITH_LOCK			(1 << 1)
 int __inet_bind(struct sock *sk, struct sockaddr *uaddr, int addr_len,
-		bool force_bind_address_no_port, bool with_lock);
+		u32 flags);
 int inet_getname(struct socket *sock, struct sockaddr *uaddr,
 		 int peer);
 int inet_ioctl(struct socket *sock, unsigned int cmd, unsigned long arg);
diff --git a/include/net/ipv6_stubs.h b/include/net/ipv6_stubs.h
index a5f7c12c326a..6e622dd3122e 100644
--- a/include/net/ipv6_stubs.h
+++ b/include/net/ipv6_stubs.h
@@ -63,7 +63,7 @@ extern const struct ipv6_stub *ipv6_stub __read_mostly;
 /* A stub used by bpf helpers. Similarly ugly as ipv6_stub */
 struct ipv6_bpf_stub {
 	int (*inet6_bind)(struct sock *sk, struct sockaddr *uaddr, int addr_len,
-			  bool force_bind_address_no_port, bool with_lock);
+			  u32 flags);
 	struct sock *(*udp6_lib_lookup)(struct net *net,
 				     const struct in6_addr *saddr, __be16 sport,
 				     const struct in6_addr *daddr, __be16 dport,
diff --git a/net/core/filter.c b/net/core/filter.c
index dfaf5df13722..fa9ddab5dd1f 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -4538,7 +4538,8 @@ BPF_CALL_3(bpf_bind, struct bpf_sock_addr_kern *, ctx, struct sockaddr *, addr,
 			return err;
 		if (((struct sockaddr_in *)addr)->sin_port != htons(0))
 			return err;
-		return __inet_bind(sk, addr, addr_len, true, false);
+		return __inet_bind(sk, addr, addr_len,
+				   BIND_FORCE_ADDRESS_NO_PORT);
 #if IS_ENABLED(CONFIG_IPV6)
 	} else if (addr->sa_family == AF_INET6) {
 		if (addr_len < SIN6_LEN_RFC2133)
@@ -4548,7 +4549,8 @@ BPF_CALL_3(bpf_bind, struct bpf_sock_addr_kern *, ctx, struct sockaddr *, addr,
 		/* ipv6_bpf_stub cannot be NULL, since it's called from
 		 * bpf_cgroup_inet6_connect hook and ipv6 is already loaded
 		 */
-		return ipv6_bpf_stub->inet6_bind(sk, addr, addr_len, true, false);
+		return ipv6_bpf_stub->inet6_bind(sk, addr, addr_len,
+						 BIND_FORCE_ADDRESS_NO_PORT);
 #endif /* CONFIG_IPV6 */
 	}
 #endif /* CONFIG_INET */
diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index 6177c4ba0037..68e74b1b0f26 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -450,12 +450,12 @@ int inet_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len)
 	if (err)
 		return err;
 
-	return __inet_bind(sk, uaddr, addr_len, false, true);
+	return __inet_bind(sk, uaddr, addr_len, BIND_WITH_LOCK);
 }
 EXPORT_SYMBOL(inet_bind);
 
 int __inet_bind(struct sock *sk, struct sockaddr *uaddr, int addr_len,
-		bool force_bind_address_no_port, bool with_lock)
+		u32 flags)
 {
 	struct sockaddr_in *addr = (struct sockaddr_in *)uaddr;
 	struct inet_sock *inet = inet_sk(sk);
@@ -506,7 +506,7 @@ int __inet_bind(struct sock *sk, struct sockaddr *uaddr, int addr_len,
 	 *      would be illegal to use them (multicast/broadcast) in
 	 *      which case the sending device address is used.
 	 */
-	if (with_lock)
+	if (flags & BIND_WITH_LOCK)
 		lock_sock(sk);
 
 	/* Check these errors (active socket, double bind). */
@@ -520,7 +520,7 @@ int __inet_bind(struct sock *sk, struct sockaddr *uaddr, int addr_len,
 
 	/* Make sure we are allowed to bind here. */
 	if (snum || !(inet->bind_address_no_port ||
-		      force_bind_address_no_port)) {
+		      (flags & BIND_FORCE_ADDRESS_NO_PORT))) {
 		if (sk->sk_prot->get_port(sk, snum)) {
 			inet->inet_saddr = inet->inet_rcv_saddr = 0;
 			err = -EADDRINUSE;
@@ -543,7 +543,7 @@ int __inet_bind(struct sock *sk, struct sockaddr *uaddr, int addr_len,
 	sk_dst_reset(sk);
 	err = 0;
 out_release_sock:
-	if (with_lock)
+	if (flags & BIND_WITH_LOCK)
 		release_sock(sk);
 out:
 	return err;
diff --git a/net/ipv6/af_inet6.c b/net/ipv6/af_inet6.c
index 345baa0a754f..552c2592b81c 100644
--- a/net/ipv6/af_inet6.c
+++ b/net/ipv6/af_inet6.c
@@ -273,7 +273,7 @@ static int inet6_create(struct net *net, struct socket *sock, int protocol,
 }
 
 static int __inet6_bind(struct sock *sk, struct sockaddr *uaddr, int addr_len,
-			bool force_bind_address_no_port, bool with_lock)
+			u32 flags)
 {
 	struct sockaddr_in6 *addr = (struct sockaddr_in6 *)uaddr;
 	struct inet_sock *inet = inet_sk(sk);
@@ -297,7 +297,7 @@ static int __inet6_bind(struct sock *sk, struct sockaddr *uaddr, int addr_len,
 	    !ns_capable(net->user_ns, CAP_NET_BIND_SERVICE))
 		return -EACCES;
 
-	if (with_lock)
+	if (flags & BIND_WITH_LOCK)
 		lock_sock(sk);
 
 	/* Check these errors (active socket, double bind). */
@@ -400,7 +400,7 @@ static int __inet6_bind(struct sock *sk, struct sockaddr *uaddr, int addr_len,
 
 	/* Make sure we are allowed to bind here. */
 	if (snum || !(inet->bind_address_no_port ||
-		      force_bind_address_no_port)) {
+		      (flags & BIND_FORCE_ADDRESS_NO_PORT))) {
 		if (sk->sk_prot->get_port(sk, snum)) {
 			sk->sk_ipv6only = saved_ipv6only;
 			inet_reset_saddr(sk);
@@ -423,7 +423,7 @@ static int __inet6_bind(struct sock *sk, struct sockaddr *uaddr, int addr_len,
 	inet->inet_dport = 0;
 	inet->inet_daddr = 0;
 out:
-	if (with_lock)
+	if (flags & BIND_WITH_LOCK)
 		release_sock(sk);
 	return err;
 out_unlock:
@@ -451,7 +451,7 @@ int inet6_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len)
 	if (err)
 		return err;
 
-	return __inet6_bind(sk, uaddr, addr_len, false, true);
+	return __inet6_bind(sk, uaddr, addr_len, BIND_WITH_LOCK);
 }
 EXPORT_SYMBOL(inet6_bind);
 
-- 
2.26.2.526.g744177e7f7-goog

