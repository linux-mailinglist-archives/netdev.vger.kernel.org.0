Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E711B2FDF0A
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 02:57:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392596AbhAUBqj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 20:46:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390181AbhAUBXY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 20:23:24 -0500
Received: from mail-qv1-xf49.google.com (mail-qv1-xf49.google.com [IPv6:2607:f8b0:4864:20::f49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BEC2C061757
        for <netdev@vger.kernel.org>; Wed, 20 Jan 2021 17:22:44 -0800 (PST)
Received: by mail-qv1-xf49.google.com with SMTP id j24so320921qvg.8
        for <netdev@vger.kernel.org>; Wed, 20 Jan 2021 17:22:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=cqqLarYZEILZJj5WEn8kYVS4VFpMhoB239WWzcW299Q=;
        b=nLI58/Qwvh75XxEdy2ctCbqmULCF0tsfBi+0O+1mGvjo1j/SDARcNaPVPxpzZuK3Gz
         92kdetH6J67aly/O4pTCuOnDe21eanq5erDNjKdTPYmaUv2Po5oiyJHgosSr82wdkglh
         H8HEExyx4Mb+FQe6qRGrGgynTTob8tP4MWRXTCNCguf4m8eq8UisbcjKk2TFmamSXu8G
         BGYdJ+S2/aM2OCSjbMxobnU3gsgAGhS1R5dx4CM0zFEije5V/oCfIcXfAhkP85nX74Rq
         Y+C1ly7lEvb5G7eS3YGBT8lFeHCgJG3r7g10senUFx3iLYv+76JTTutOSIyUdVlrmCg9
         pLZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=cqqLarYZEILZJj5WEn8kYVS4VFpMhoB239WWzcW299Q=;
        b=pOCoFx2O3bA7JAqKveSlYlHmlnV3O27UbKv1tErUfH4FiNz9rgMs4XZ799xSYaDBHs
         GH6oLT8cX4Odn3kwd3c/sWjWCoUzX1LfC6tSyvW0iwnExBBKLJEWancZnfOL5scI9goI
         SgOGK36kceZ6ZTioonnz8ltZsGjW0PZKm0NnHvEkowlK+vtj9HsurKFQurZJtY7bexVM
         LarVyi9fje3RafQfUKTYpzjobEwpgfFhE4/ObBhvD/8/M/2jfINvVvBiLp9NmHd6PFxP
         9pl8rUzUl2E+s2fBfhbuosjCnEfxhR4KFZT61GOlW8emxzzXsqjnpbHJJLEjhxrjbdX3
         nTmw==
X-Gm-Message-State: AOAM532JWBcqyQY576XNgHg1WD6v21JjewlVWYNi7d6Uu09pjiR8Xy/d
        5iEchJjdyraBgZ+4rygnHy7HjTGAF0k+G/GoEFe+KMM6mgTxWtLyvoMT15B0/XkkLSxnRxzsny/
        Vy1kSICYTSK6cWsUj56KZfANxc5CNN/Is0DitkabIhqn8GOUBKppkXw==
X-Google-Smtp-Source: ABdhPJyPr6rGlt/2CYc5rsFFFODJXgui0NWlO0arQSRt4b+KtaYag7WIjtuubNLlim4J1SZGfSgAlEI=
Sender: "sdf via sendgmr" <sdf@sdf2.svl.corp.google.com>
X-Received: from sdf2.svl.corp.google.com ([2620:15c:2c4:1:7220:84ff:fe09:7732])
 (user=sdf job=sendgmr) by 2002:a05:6214:321:: with SMTP id
 j1mr12646475qvu.32.1611192163405; Wed, 20 Jan 2021 17:22:43 -0800 (PST)
Date:   Wed, 20 Jan 2021 17:22:40 -0800
Message-Id: <20210121012241.2109147-1-sdf@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.30.0.284.gd98b1dd5eaa7-goog
Subject: [PATCH bpf-next 1/2] bpf: allow rewriting to ports under ip_unprivileged_port_start
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

At the moment, BPF_CGROUP_INET{4,6}_BIND hooks can rewrite user_port
to the privileged ones (< ip_unprivileged_port_start), but it will
be rejected later on in the __inet_bind or __inet6_bind.

Let's export 'port_changed' event from the BPF program and bypass
ip_unprivileged_port_start range check when we've seen that
the program explicitly overrode the port. This is accomplished
by generating instructions to set ctx->port_changed along with
updating ctx->user_port.

Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 include/linux/bpf-cgroup.h | 30 ++++++++++++++++++++----------
 include/linux/filter.h     |  1 +
 include/net/inet_common.h  |  3 +++
 kernel/bpf/cgroup.c        |  8 +++++++-
 net/core/filter.c          | 13 +++++++++++++
 net/ipv4/af_inet.c         |  9 ++++++---
 net/ipv6/af_inet6.c        |  6 ++++--
 7 files changed, 54 insertions(+), 16 deletions(-)

diff --git a/include/linux/bpf-cgroup.h b/include/linux/bpf-cgroup.h
index 0748fd87969e..874ed865bea1 100644
--- a/include/linux/bpf-cgroup.h
+++ b/include/linux/bpf-cgroup.h
@@ -125,7 +125,8 @@ int __cgroup_bpf_run_filter_sk(struct sock *sk,
 int __cgroup_bpf_run_filter_sock_addr(struct sock *sk,
 				      struct sockaddr *uaddr,
 				      enum bpf_attach_type type,
-				      void *t_ctx);
+				      void *t_ctx,
+				      bool *port_changed);
 
 int __cgroup_bpf_run_filter_sock_ops(struct sock *sk,
 				     struct bpf_sock_ops_kern *sock_ops,
@@ -234,7 +235,7 @@ int bpf_percpu_cgroup_storage_update(struct bpf_map *map, void *key,
 	int __ret = 0;							       \
 	if (cgroup_bpf_enabled(type))					       \
 		__ret = __cgroup_bpf_run_filter_sock_addr(sk, uaddr, type,     \
-							  NULL);	       \
+							  NULL, NULL);	       \
 	__ret;								       \
 })
 
@@ -244,17 +245,27 @@ int bpf_percpu_cgroup_storage_update(struct bpf_map *map, void *key,
 	if (cgroup_bpf_enabled(type))	{				       \
 		lock_sock(sk);						       \
 		__ret = __cgroup_bpf_run_filter_sock_addr(sk, uaddr, type,     \
-							  t_ctx);	       \
+							  t_ctx, NULL);	       \
 		release_sock(sk);					       \
 	}								       \
 	__ret;								       \
 })
 
-#define BPF_CGROUP_RUN_PROG_INET4_BIND_LOCK(sk, uaddr)			       \
-	BPF_CGROUP_RUN_SA_PROG_LOCK(sk, uaddr, BPF_CGROUP_INET4_BIND, NULL)
-
-#define BPF_CGROUP_RUN_PROG_INET6_BIND_LOCK(sk, uaddr)			       \
-	BPF_CGROUP_RUN_SA_PROG_LOCK(sk, uaddr, BPF_CGROUP_INET6_BIND, NULL)
+#define BPF_CGROUP_RUN_PROG_INET_BIND_LOCK(sk, uaddr, type, flags)	       \
+({									       \
+	bool port_changed = false;					       \
+	int __ret = 0;							       \
+	if (cgroup_bpf_enabled(type))	{				       \
+		lock_sock(sk);						       \
+		__ret = __cgroup_bpf_run_filter_sock_addr(sk, uaddr, type,     \
+							  NULL,		       \
+							  &port_changed);      \
+		release_sock(sk);					       \
+		if (port_changed)					       \
+			*flags |= BIND_NO_CAP_NET_BIND_SERVICE;		       \
+	}								       \
+	__ret;								       \
+})
 
 #define BPF_CGROUP_PRE_CONNECT_ENABLED(sk)				       \
 	((cgroup_bpf_enabled(BPF_CGROUP_INET4_CONNECT) ||		       \
@@ -453,8 +464,7 @@ static inline int bpf_percpu_cgroup_storage_update(struct bpf_map *map,
 #define BPF_CGROUP_RUN_PROG_INET_EGRESS(sk,skb) ({ 0; })
 #define BPF_CGROUP_RUN_PROG_INET_SOCK(sk) ({ 0; })
 #define BPF_CGROUP_RUN_PROG_INET_SOCK_RELEASE(sk) ({ 0; })
-#define BPF_CGROUP_RUN_PROG_INET4_BIND_LOCK(sk, uaddr) ({ 0; })
-#define BPF_CGROUP_RUN_PROG_INET6_BIND_LOCK(sk, uaddr) ({ 0; })
+#define BPF_CGROUP_RUN_PROG_INET_BIND_LOCK(sk, uaddr, type, flags) ({ 0; })
 #define BPF_CGROUP_RUN_PROG_INET4_POST_BIND(sk) ({ 0; })
 #define BPF_CGROUP_RUN_PROG_INET6_POST_BIND(sk) ({ 0; })
 #define BPF_CGROUP_RUN_PROG_INET4_CONNECT(sk, uaddr) ({ 0; })
diff --git a/include/linux/filter.h b/include/linux/filter.h
index 5b3137d7b690..9bee8c057dd2 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -1258,6 +1258,7 @@ struct bpf_sock_addr_kern {
 	 */
 	u64 tmp_reg;
 	void *t_ctx;	/* Attach type specific context. */
+	u32 port_changed;
 };
 
 struct bpf_sock_ops_kern {
diff --git a/include/net/inet_common.h b/include/net/inet_common.h
index cb2818862919..9ba935c15869 100644
--- a/include/net/inet_common.h
+++ b/include/net/inet_common.h
@@ -41,6 +41,9 @@ int inet_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len);
 #define BIND_WITH_LOCK			(1 << 1)
 /* Called from BPF program. */
 #define BIND_FROM_BPF			(1 << 2)
+/* Skip CAP_NET_BIND_SERVICE check. */
+#define BIND_NO_CAP_NET_BIND_SERVICE	(1 << 3)
+
 int __inet_bind(struct sock *sk, struct sockaddr *uaddr, int addr_len,
 		u32 flags);
 int inet_getname(struct socket *sock, struct sockaddr *uaddr,
diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
index da649f20d6b2..f5d6205f1717 100644
--- a/kernel/bpf/cgroup.c
+++ b/kernel/bpf/cgroup.c
@@ -1055,6 +1055,8 @@ EXPORT_SYMBOL(__cgroup_bpf_run_filter_sk);
  * @uaddr: sockaddr struct provided by user
  * @type: The type of program to be exectuted
  * @t_ctx: Pointer to attach type specific context
+ * @port_changed: Pointer to bool which will be set to 'true' when BPF
+ *                program updates user_port
  *
  * socket is expected to be of type INET or INET6.
  *
@@ -1064,7 +1066,8 @@ EXPORT_SYMBOL(__cgroup_bpf_run_filter_sk);
 int __cgroup_bpf_run_filter_sock_addr(struct sock *sk,
 				      struct sockaddr *uaddr,
 				      enum bpf_attach_type type,
-				      void *t_ctx)
+				      void *t_ctx,
+				      bool *port_changed)
 {
 	struct bpf_sock_addr_kern ctx = {
 		.sk = sk,
@@ -1089,6 +1092,9 @@ int __cgroup_bpf_run_filter_sock_addr(struct sock *sk,
 	cgrp = sock_cgroup_ptr(&sk->sk_cgrp_data);
 	ret = BPF_PROG_RUN_ARRAY(cgrp->bpf.effective[type], &ctx, BPF_PROG_RUN);
 
+	if (port_changed)
+		*port_changed = ctx.port_changed;
+
 	return ret == 1 ? 0 : -EPERM;
 }
 EXPORT_SYMBOL(__cgroup_bpf_run_filter_sock_addr);
diff --git a/net/core/filter.c b/net/core/filter.c
index 9ab94e90d660..b3dd02eb9551 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -9028,6 +9028,19 @@ static u32 sock_addr_convert_ctx_access(enum bpf_access_type type,
 			     offsetof(struct sockaddr_in6, sin6_port));
 		BUILD_BUG_ON(sizeof_field(struct sockaddr_in, sin_port) !=
 			     sizeof_field(struct sockaddr_in6, sin6_port));
+
+		/* Set bpf_sock_addr_kern->port_changed=1 whenever
+		 * the port is updated from the BPF program.
+		 */
+		if (type == BPF_WRITE) {
+			*insn++ = BPF_ST_MEM(BPF_FIELD_SIZEOF(struct bpf_sock_addr_kern,
+							      port_changed),
+					     si->dst_reg,
+					     offsetof(struct bpf_sock_addr_kern,
+						      port_changed),
+					     1);
+		}
+
 		/* Account for sin6_port being smaller than user_port. */
 		port_size = min(port_size, BPF_LDST_BYTES(si));
 		SOCK_ADDR_LOAD_OR_STORE_NESTED_FIELD_SIZE_OFF(
diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index 6ba2930ff49b..aaa94bea19c3 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -438,6 +438,7 @@ EXPORT_SYMBOL(inet_release);
 int inet_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len)
 {
 	struct sock *sk = sock->sk;
+	u32 flags = BIND_WITH_LOCK;
 	int err;
 
 	/* If the socket has its own bind function then use it. (RAW) */
@@ -450,11 +451,12 @@ int inet_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len)
 	/* BPF prog is run before any checks are done so that if the prog
 	 * changes context in a wrong way it will be caught.
 	 */
-	err = BPF_CGROUP_RUN_PROG_INET4_BIND_LOCK(sk, uaddr);
+	err = BPF_CGROUP_RUN_PROG_INET_BIND_LOCK(sk, uaddr,
+						 BPF_CGROUP_INET4_BIND, &flags);
 	if (err)
 		return err;
 
-	return __inet_bind(sk, uaddr, addr_len, BIND_WITH_LOCK);
+	return __inet_bind(sk, uaddr, addr_len, flags);
 }
 EXPORT_SYMBOL(inet_bind);
 
@@ -499,7 +501,8 @@ int __inet_bind(struct sock *sk, struct sockaddr *uaddr, int addr_len,
 
 	snum = ntohs(addr->sin_port);
 	err = -EACCES;
-	if (snum && inet_port_requires_bind_service(net, snum) &&
+	if (!(flags & BIND_NO_CAP_NET_BIND_SERVICE) &&
+	    snum && inet_port_requires_bind_service(net, snum) &&
 	    !ns_capable(net->user_ns, CAP_NET_BIND_SERVICE))
 		goto out;
 
diff --git a/net/ipv6/af_inet6.c b/net/ipv6/af_inet6.c
index b9c654836b72..3e523c4f5226 100644
--- a/net/ipv6/af_inet6.c
+++ b/net/ipv6/af_inet6.c
@@ -439,6 +439,7 @@ static int __inet6_bind(struct sock *sk, struct sockaddr *uaddr, int addr_len,
 int inet6_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len)
 {
 	struct sock *sk = sock->sk;
+	u32 flags = BIND_WITH_LOCK;
 	int err = 0;
 
 	/* If the socket has its own bind function then use it. */
@@ -451,11 +452,12 @@ int inet6_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len)
 	/* BPF prog is run before any checks are done so that if the prog
 	 * changes context in a wrong way it will be caught.
 	 */
-	err = BPF_CGROUP_RUN_PROG_INET6_BIND_LOCK(sk, uaddr);
+	err = BPF_CGROUP_RUN_PROG_INET_BIND_LOCK(sk, uaddr,
+						 BPF_CGROUP_INET6_BIND, &flags);
 	if (err)
 		return err;
 
-	return __inet6_bind(sk, uaddr, addr_len, BIND_WITH_LOCK);
+	return __inet6_bind(sk, uaddr, addr_len, flags);
 }
 EXPORT_SYMBOL(inet6_bind);
 
-- 
2.30.0.284.gd98b1dd5eaa7-goog

