Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63D6E1C7D6A
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 00:32:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730203AbgEFWcW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 18:32:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730110AbgEFWcU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 18:32:20 -0400
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE6A0C061A10
        for <netdev@vger.kernel.org>; Wed,  6 May 2020 15:32:19 -0700 (PDT)
Received: by mail-qk1-x74a.google.com with SMTP id 11so3444808qkh.7
        for <netdev@vger.kernel.org>; Wed, 06 May 2020 15:32:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=BwxAOhrP+L/inT5n9mADwhDyhK1A3A0kERGdPlhNudo=;
        b=SN/d7RyY2/ZXgJ1/Z8OZ0RAxCK6DjgHpGA3t+lrVYOOp7vVisA+RQ9bND12aztJcHp
         epNdpT8OvO6IQlva937XGphuUkBs9RAWEmJvD8djyXdTBqKWEZX8ywA04oUSXU2QZEWm
         cV4hVKGR48XB9N8lft/WfN0JFI1pkhkSh2x7mCynM4iaP4Pkws8g+3NNvvfhrYy1cIKR
         8SrDL65Qg++5cC1FUHaLvQF7xHojlS8it0mvbLx3K9QTudEBD6nc0geytSbCwsxjL+ZA
         PZ9LQf630Xt+YNY4/ni2mOzWDbAYnvxpV0QrKNc0n38ZxunpUr58JweEzraN5Cd18g4r
         XYpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=BwxAOhrP+L/inT5n9mADwhDyhK1A3A0kERGdPlhNudo=;
        b=SQLbL94aDirlgPyeFS2dMAUPh997QTsQS1aLFIAH/Z6OwFtoEWmc2q5K7jukopXS4K
         CW2LAuZDE1mDHjNmjkzApw+boqnEDtEy3tYGMZGJOOwmvj7Rc5DeEwgIhfCg+U6byThH
         i5U5yMjyzisCS7X6iYmkJ0uMigTSrMhfV65ypHKnuE0VUBT8uyUFiSu3R1PrMB2Q/Spl
         R4ITd47LdokWRMPoZDwlwCpEcPHXHtllh25rD/UCnqINElu5wQldt7KuKW6u4Vs/D4Ki
         yS10Og/p3R4FSdtiGFpktvzaBEiKK6JSLTjLFov83nW1qekLK0LSamWI7pUV12IisVNz
         l2JA==
X-Gm-Message-State: AGi0PuY/lg6PeUZlshjaYXTakalMRdEh0IauUHk88q+5xkyuqpWwl/wa
        GMzBlWl0EJ7McCMKD+kqFxkEbDUMokUSHDMJB/5qs/1zlz4tFEcMAL3aLP6RWU99nmAYUZeu43F
        kxVNPEuN0NaP8zbG9rBo/FZyLijehQ3zDR4c/hRX2jBgDO4J1nZzPQw==
X-Google-Smtp-Source: APiQypKkwQmITUpBD/ZDt4z83QAJLOa8VHE5M2PeVXkBGeQz+cJRPAiwFTUmWWgHaWJfAglETDVbomY=
X-Received: by 2002:a05:6214:114d:: with SMTP id b13mr4170402qvt.44.1588804339009;
 Wed, 06 May 2020 15:32:19 -0700 (PDT)
Date:   Wed,  6 May 2020 15:32:09 -0700
In-Reply-To: <20200506223210.93595-1-sdf@google.com>
Message-Id: <20200506223210.93595-5-sdf@google.com>
Mime-Version: 1.0
References: <20200506223210.93595-1-sdf@google.com>
X-Mailer: git-send-email 2.26.2.526.g744177e7f7-goog
Subject: [PATCH bpf-next v3 4/5] net: refactor arguments of inet{,6}_bind
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>,
        Andrey Ignatov <rdna@fb.com>, Martin KaFai Lau <kafai@fb.com>
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
Cc: Martin KaFai Lau <kafai@fb.com>
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

