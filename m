Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9753F1C42F0
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 19:34:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730423AbgEDRej (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 13:34:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730404AbgEDRei (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 13:34:38 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACA2DC061A0F
        for <netdev@vger.kernel.org>; Mon,  4 May 2020 10:34:38 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id r14so234109ybk.21
        for <netdev@vger.kernel.org>; Mon, 04 May 2020 10:34:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=wBE7hm6quI+iooNO3qC1XtqSbOT/H5iFWRQbKwBhMTE=;
        b=WJKKaDHk/vf/c0Nn0BqzzyJw35wjWGq8OjecyKB9q3mUeYtX/Fo6qSG3eMwhYXjRq/
         09RVKI/+GqGvJgLO+H1q3CKt89P6O0MvASqs25MxVSajaydCv1khR3+Hjyuo41Pxfgzw
         Pjhm5AWV78S79bCPo8JBpkRKyohJOGEPk0kQv3w5AXA52c2+mV5Xk5OweaB1ueRonkjp
         aOwsWoJ2U0pRF+AbLCoaO+8/2U/83oDti3foeEaF7OyWCbMlt+PnihKDJ5rRZVMIP9dS
         wj9hMKsIR1PFEqVmS1XfYi64laC6vBdWqJFYwbNgVxXUDTbW1+e6LTk1d0IhtNJBhz8q
         F6Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=wBE7hm6quI+iooNO3qC1XtqSbOT/H5iFWRQbKwBhMTE=;
        b=rRDmBxdlE51NB8WZuOpr054imSQZomjPySTsHaXRX3rzI1z1Ud4KngvC81kqc1HkSb
         lIUQ82c6GuKfptJq1Le2SF7Vac8AdVHvfsaY0tgX9G8Uc4kDR9P53wu8n4AEdWUfQBdw
         fP7fi6bOxvrIHXc/PbC+D0PCdkYrHLqdxAXtPffOG5G6NNM2rYiXm4Q+/+w0cckXIjBq
         gCv9Mg31EzHSyTaluodU8B/yIM45MrVCAkz0PKwOknT3NGdDn4xjtTeJyVS/r90ynwQs
         K0Xz3pScyAoI20zc2Ymq1lcTpEt94HrzCeejeyRb/M0TTBzyJ53uOX0Odb/G8bc6ndi7
         HP3g==
X-Gm-Message-State: AGi0Pua+ObHA0njq4IUwl1AedhTkjb5jyMtHMvJTrvJ0qQ1K9lX692xF
        IOVEsVauxkLH3YgR+l6GHzRfsdRiQj8Ujw0ZkqpGACLL+1GjrX7iK0lBa+QBvgA3VE+5huaqSET
        pdd6Z5IO7CcJ636GkQ9qgoA6hf5lblTwVlUu5lB0aoigL3ooopS/zjw==
X-Google-Smtp-Source: APiQypJBba7RWDeEUwV7G604qNN68azWZFCTnB8mAjPgXRWt6PeWtghxoIOZvkxlNI33L4j9WRjSlRs=
X-Received: by 2002:a25:3295:: with SMTP id y143mr513997yby.390.1588613677791;
 Mon, 04 May 2020 10:34:37 -0700 (PDT)
Date:   Mon,  4 May 2020 10:34:29 -0700
In-Reply-To: <20200504173430.6629-1-sdf@google.com>
Message-Id: <20200504173430.6629-4-sdf@google.com>
Mime-Version: 1.0
References: <20200504173430.6629-1-sdf@google.com>
X-Mailer: git-send-email 2.26.2.526.g744177e7f7-goog
Subject: [PATCH bpf-next 3/4] net: refactor arguments of inet{,6}_bind
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
index ae2ba897675c..a0fb68f5bf59 100644
--- a/include/net/inet_common.h
+++ b/include/net/inet_common.h
@@ -35,8 +35,12 @@ int inet_shutdown(struct socket *sock, int how);
 int inet_listen(struct socket *sock, int backlog);
 void inet_sock_destruct(struct sock *sk);
 int inet_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len);
+// Don't allocate port at this moment, defer to connect.
+#define BIND_FORCE_ADDRESS_NO_PORT	(1 << 0)
+// Grab and release socket lock.
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

