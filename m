Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85F7B2F80E8
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 17:37:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731582AbhAOQg0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 11:36:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730515AbhAOQgZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 11:36:25 -0500
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D3FDC061798
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 08:35:11 -0800 (PST)
Received: by mail-qk1-x749.google.com with SMTP id u17so8498397qku.17
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 08:35:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=2mk+NTJkPfaaUrkA8BKA5Tl4XuO2tFi3Wzuv9ptgzAw=;
        b=hb01zZe/9x9+ShpGyag0yVTQgvlw+H/q5FhOVjxdUDiS5JUQEK7L2n73pjnWBTXrbT
         HAn1nMMeuMM0MQsJ3PHi0c6q7VUp/UWIUt5I3y8hLq7s0n1MzbcbeZFbTXQScll/mYTp
         vPiydkBcxBGuSMpRvxaJqDW+HOXC5z0/LIeDqsmUHNmo3VAsYXXpXBqjoeCufzYmg3P+
         zTGCGf7Cf9yZTox94DmeIryptYTpyKG60zR3fVSHEScYE0K2C3k63gJQf453WC84a6iz
         OGTyjzLMY+MKRup1xeDAHbISZmQXbq7puJOQOU/uKmPn8Y+RabXYMAqfvu5y8jI+zCct
         vW7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=2mk+NTJkPfaaUrkA8BKA5Tl4XuO2tFi3Wzuv9ptgzAw=;
        b=tCPSNwOFSxHLixDY8y0/odse11WAz1Ddt5yEwbqe7UlokRzwsqhWh3I++7leokXIIZ
         YXbSHGfO5l0xtcJF6opmtdkFMsGBM6jXReJilN3JS7nFAmanLRCEwvVbA8nNTUUPEmqO
         CHoI4nQbSOnyOjh+oJpNfeyLoZbPtivw+a3KH1QgBDddjFaGFE/fiEuTKW2cJyg8tf15
         F6SwKoiBwvoFGcZ3/bEyJD3sdM2CfBPFEcFEJwTcoIg2BDBJCxsAuQ84JMI4XeyEWdxQ
         L4Nchqnhuk2O4aF8FXSQCpz9lWtC2Bf1zxImrqbdj2M6V0YeAbOHXCGK9m+/1mCotz4b
         ILhw==
X-Gm-Message-State: AOAM532DcUnGLZJxWsTwTAb/BQ6A3+D6/apg4nvIUzr8Nd0Q39aESbmT
        VVomvUTZgX0con7U/XRmY3EdrrnQw3LThgwVpWyKQ1H9VcVPqOnEv2h9zr5LeTnsPMql1zrF8fL
        fuS8mrHCY4Qr1Er0CFxXsb0r2TVXIFX+kjyOBYtuDjsfKuhMr++8J3w==
X-Google-Smtp-Source: ABdhPJwNkLtHgNn7arsRpMiCy8zdNB5BodJQVkaVxiJrapLBzjFNPImQuL0XflDwrLG1DyDr5hM9N/0=
Sender: "sdf via sendgmr" <sdf@sdf2.svl.corp.google.com>
X-Received: from sdf2.svl.corp.google.com ([2620:15c:2c4:1:7220:84ff:fe09:7732])
 (user=sdf job=sendgmr) by 2002:a05:6214:1904:: with SMTP id
 er4mr13029230qvb.49.1610728510659; Fri, 15 Jan 2021 08:35:10 -0800 (PST)
Date:   Fri, 15 Jan 2021 08:35:01 -0800
In-Reply-To: <20210115163501.805133-1-sdf@google.com>
Message-Id: <20210115163501.805133-4-sdf@google.com>
Mime-Version: 1.0
References: <20210115163501.805133-1-sdf@google.com>
X-Mailer: git-send-email 2.30.0.284.gd98b1dd5eaa7-goog
Subject: [PATCH bpf-next v9 3/3] bpf: split cgroup_bpf_enabled per attach type
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>,
        Song Liu <songliubraving@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When we attach any cgroup hook, the rest (even if unused/unattached) start
to contribute small overhead. In particular, the one we want to avoid is
__cgroup_bpf_run_filter_skb which does two redirections to get to
the cgroup and pushes/pulls skb.

Let's split cgroup_bpf_enabled to be per-attach to make sure
only used attach types trigger.

I've dropped some existing high-level cgroup_bpf_enabled in some
places because BPF_PROG_CGROUP_XXX_RUN macros usually have another
cgroup_bpf_enabled check.

I also had to copy-paste BPF_CGROUP_RUN_SA_PROG_LOCK for
GETPEERNAME/GETSOCKNAME because type for cgroup_bpf_enabled[type]
has to be constant and known at compile time.

Signed-off-by: Stanislav Fomichev <sdf@google.com>
Acked-by: Song Liu <songliubraving@fb.com>
---
 include/linux/bpf-cgroup.h | 38 ++++++++++++++++++++------------------
 kernel/bpf/cgroup.c        | 14 ++++++--------
 net/ipv4/af_inet.c         |  9 +++++----
 net/ipv4/udp.c             |  7 +++----
 net/ipv6/af_inet6.c        |  9 +++++----
 net/ipv6/udp.c             |  7 +++----
 6 files changed, 42 insertions(+), 42 deletions(-)

diff --git a/include/linux/bpf-cgroup.h b/include/linux/bpf-cgroup.h
index bcb2915e6124..0748fd87969e 100644
--- a/include/linux/bpf-cgroup.h
+++ b/include/linux/bpf-cgroup.h
@@ -23,8 +23,8 @@ struct ctl_table_header;
 
 #ifdef CONFIG_CGROUP_BPF
 
-extern struct static_key_false cgroup_bpf_enabled_key;
-#define cgroup_bpf_enabled static_branch_unlikely(&cgroup_bpf_enabled_key)
+extern struct static_key_false cgroup_bpf_enabled_key[MAX_BPF_ATTACH_TYPE];
+#define cgroup_bpf_enabled(type) static_branch_unlikely(&cgroup_bpf_enabled_key[type])
 
 DECLARE_PER_CPU(struct bpf_cgroup_storage*,
 		bpf_cgroup_storage[MAX_BPF_CGROUP_STORAGE_TYPE]);
@@ -189,7 +189,7 @@ int bpf_percpu_cgroup_storage_update(struct bpf_map *map, void *key,
 #define BPF_CGROUP_RUN_PROG_INET_INGRESS(sk, skb)			      \
 ({									      \
 	int __ret = 0;							      \
-	if (cgroup_bpf_enabled)						      \
+	if (cgroup_bpf_enabled(BPF_CGROUP_INET_INGRESS))		      \
 		__ret = __cgroup_bpf_run_filter_skb(sk, skb,		      \
 						    BPF_CGROUP_INET_INGRESS); \
 									      \
@@ -199,7 +199,7 @@ int bpf_percpu_cgroup_storage_update(struct bpf_map *map, void *key,
 #define BPF_CGROUP_RUN_PROG_INET_EGRESS(sk, skb)			       \
 ({									       \
 	int __ret = 0;							       \
-	if (cgroup_bpf_enabled && sk && sk == skb->sk) {		       \
+	if (cgroup_bpf_enabled(BPF_CGROUP_INET_EGRESS) && sk && sk == skb->sk) { \
 		typeof(sk) __sk = sk_to_full_sk(sk);			       \
 		if (sk_fullsock(__sk))					       \
 			__ret = __cgroup_bpf_run_filter_skb(__sk, skb,	       \
@@ -211,7 +211,7 @@ int bpf_percpu_cgroup_storage_update(struct bpf_map *map, void *key,
 #define BPF_CGROUP_RUN_SK_PROG(sk, type)				       \
 ({									       \
 	int __ret = 0;							       \
-	if (cgroup_bpf_enabled) {					       \
+	if (cgroup_bpf_enabled(type)) {					       \
 		__ret = __cgroup_bpf_run_filter_sk(sk, type);		       \
 	}								       \
 	__ret;								       \
@@ -232,7 +232,7 @@ int bpf_percpu_cgroup_storage_update(struct bpf_map *map, void *key,
 #define BPF_CGROUP_RUN_SA_PROG(sk, uaddr, type)				       \
 ({									       \
 	int __ret = 0;							       \
-	if (cgroup_bpf_enabled)						       \
+	if (cgroup_bpf_enabled(type))					       \
 		__ret = __cgroup_bpf_run_filter_sock_addr(sk, uaddr, type,     \
 							  NULL);	       \
 	__ret;								       \
@@ -241,7 +241,7 @@ int bpf_percpu_cgroup_storage_update(struct bpf_map *map, void *key,
 #define BPF_CGROUP_RUN_SA_PROG_LOCK(sk, uaddr, type, t_ctx)		       \
 ({									       \
 	int __ret = 0;							       \
-	if (cgroup_bpf_enabled)	{					       \
+	if (cgroup_bpf_enabled(type))	{				       \
 		lock_sock(sk);						       \
 		__ret = __cgroup_bpf_run_filter_sock_addr(sk, uaddr, type,     \
 							  t_ctx);	       \
@@ -256,8 +256,10 @@ int bpf_percpu_cgroup_storage_update(struct bpf_map *map, void *key,
 #define BPF_CGROUP_RUN_PROG_INET6_BIND_LOCK(sk, uaddr)			       \
 	BPF_CGROUP_RUN_SA_PROG_LOCK(sk, uaddr, BPF_CGROUP_INET6_BIND, NULL)
 
-#define BPF_CGROUP_PRE_CONNECT_ENABLED(sk) (cgroup_bpf_enabled && \
-					    sk->sk_prot->pre_connect)
+#define BPF_CGROUP_PRE_CONNECT_ENABLED(sk)				       \
+	((cgroup_bpf_enabled(BPF_CGROUP_INET4_CONNECT) ||		       \
+	  cgroup_bpf_enabled(BPF_CGROUP_INET6_CONNECT)) &&		       \
+	 (sk)->sk_prot->pre_connect)
 
 #define BPF_CGROUP_RUN_PROG_INET4_CONNECT(sk, uaddr)			       \
 	BPF_CGROUP_RUN_SA_PROG(sk, uaddr, BPF_CGROUP_INET4_CONNECT)
@@ -301,7 +303,7 @@ int bpf_percpu_cgroup_storage_update(struct bpf_map *map, void *key,
 #define BPF_CGROUP_RUN_PROG_SOCK_OPS_SK(sock_ops, sk)			\
 ({									\
 	int __ret = 0;							\
-	if (cgroup_bpf_enabled)						\
+	if (cgroup_bpf_enabled(BPF_CGROUP_SOCK_OPS))			\
 		__ret = __cgroup_bpf_run_filter_sock_ops(sk,		\
 							 sock_ops,	\
 							 BPF_CGROUP_SOCK_OPS); \
@@ -311,7 +313,7 @@ int bpf_percpu_cgroup_storage_update(struct bpf_map *map, void *key,
 #define BPF_CGROUP_RUN_PROG_SOCK_OPS(sock_ops)				       \
 ({									       \
 	int __ret = 0;							       \
-	if (cgroup_bpf_enabled && (sock_ops)->sk) {	       \
+	if (cgroup_bpf_enabled(BPF_CGROUP_SOCK_OPS) && (sock_ops)->sk) {       \
 		typeof(sk) __sk = sk_to_full_sk((sock_ops)->sk);	       \
 		if (__sk && sk_fullsock(__sk))				       \
 			__ret = __cgroup_bpf_run_filter_sock_ops(__sk,	       \
@@ -324,7 +326,7 @@ int bpf_percpu_cgroup_storage_update(struct bpf_map *map, void *key,
 #define BPF_CGROUP_RUN_PROG_DEVICE_CGROUP(type, major, minor, access)	      \
 ({									      \
 	int __ret = 0;							      \
-	if (cgroup_bpf_enabled)						      \
+	if (cgroup_bpf_enabled(BPF_CGROUP_DEVICE))			      \
 		__ret = __cgroup_bpf_check_dev_permission(type, major, minor, \
 							  access,	      \
 							  BPF_CGROUP_DEVICE); \
@@ -336,7 +338,7 @@ int bpf_percpu_cgroup_storage_update(struct bpf_map *map, void *key,
 #define BPF_CGROUP_RUN_PROG_SYSCTL(head, table, write, buf, count, pos)  \
 ({									       \
 	int __ret = 0;							       \
-	if (cgroup_bpf_enabled)						       \
+	if (cgroup_bpf_enabled(BPF_CGROUP_SYSCTL))			       \
 		__ret = __cgroup_bpf_run_filter_sysctl(head, table, write,     \
 						       buf, count, pos,        \
 						       BPF_CGROUP_SYSCTL);     \
@@ -347,7 +349,7 @@ int bpf_percpu_cgroup_storage_update(struct bpf_map *map, void *key,
 				       kernel_optval)			       \
 ({									       \
 	int __ret = 0;							       \
-	if (cgroup_bpf_enabled)						       \
+	if (cgroup_bpf_enabled(BPF_CGROUP_SETSOCKOPT))			       \
 		__ret = __cgroup_bpf_run_filter_setsockopt(sock, level,	       \
 							   optname, optval,    \
 							   optlen,	       \
@@ -358,7 +360,7 @@ int bpf_percpu_cgroup_storage_update(struct bpf_map *map, void *key,
 #define BPF_CGROUP_GETSOCKOPT_MAX_OPTLEN(optlen)			       \
 ({									       \
 	int __ret = 0;							       \
-	if (cgroup_bpf_enabled)						       \
+	if (cgroup_bpf_enabled(BPF_CGROUP_GETSOCKOPT))			       \
 		get_user(__ret, optlen);				       \
 	__ret;								       \
 })
@@ -367,7 +369,7 @@ int bpf_percpu_cgroup_storage_update(struct bpf_map *map, void *key,
 				       max_optlen, retval)		       \
 ({									       \
 	int __ret = retval;						       \
-	if (cgroup_bpf_enabled)						       \
+	if (cgroup_bpf_enabled(BPF_CGROUP_GETSOCKOPT))			       \
 		if (!(sock)->sk_prot->bpf_bypass_getsockopt ||		       \
 		    !INDIRECT_CALL_INET_1((sock)->sk_prot->bpf_bypass_getsockopt, \
 					tcp_bpf_bypass_getsockopt,	       \
@@ -382,7 +384,7 @@ int bpf_percpu_cgroup_storage_update(struct bpf_map *map, void *key,
 					    optlen, retval)		       \
 ({									       \
 	int __ret = retval;						       \
-	if (cgroup_bpf_enabled)						       \
+	if (cgroup_bpf_enabled(BPF_CGROUP_GETSOCKOPT))			       \
 		__ret = __cgroup_bpf_run_filter_getsockopt_kern(	       \
 			sock, level, optname, optval, optlen, retval);	       \
 	__ret;								       \
@@ -444,7 +446,7 @@ static inline int bpf_percpu_cgroup_storage_update(struct bpf_map *map,
 	return 0;
 }
 
-#define cgroup_bpf_enabled (0)
+#define cgroup_bpf_enabled(type) (0)
 #define BPF_CGROUP_RUN_SA_PROG_LOCK(sk, uaddr, type, t_ctx) ({ 0; })
 #define BPF_CGROUP_PRE_CONNECT_ENABLED(sk) (0)
 #define BPF_CGROUP_RUN_PROG_INET_INGRESS(sk,skb) ({ 0; })
diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
index ba8a1199d0ba..da649f20d6b2 100644
--- a/kernel/bpf/cgroup.c
+++ b/kernel/bpf/cgroup.c
@@ -19,7 +19,7 @@
 
 #include "../cgroup/cgroup-internal.h"
 
-DEFINE_STATIC_KEY_FALSE(cgroup_bpf_enabled_key);
+DEFINE_STATIC_KEY_ARRAY_FALSE(cgroup_bpf_enabled_key, MAX_BPF_ATTACH_TYPE);
 EXPORT_SYMBOL(cgroup_bpf_enabled_key);
 
 void cgroup_bpf_offline(struct cgroup *cgrp)
@@ -128,7 +128,7 @@ static void cgroup_bpf_release(struct work_struct *work)
 			if (pl->link)
 				bpf_cgroup_link_auto_detach(pl->link);
 			kfree(pl);
-			static_branch_dec(&cgroup_bpf_enabled_key);
+			static_branch_dec(&cgroup_bpf_enabled_key[type]);
 		}
 		old_array = rcu_dereference_protected(
 				cgrp->bpf.effective[type],
@@ -499,7 +499,7 @@ int __cgroup_bpf_attach(struct cgroup *cgrp,
 	if (old_prog)
 		bpf_prog_put(old_prog);
 	else
-		static_branch_inc(&cgroup_bpf_enabled_key);
+		static_branch_inc(&cgroup_bpf_enabled_key[type]);
 	bpf_cgroup_storages_link(new_storage, cgrp, type);
 	return 0;
 
@@ -698,7 +698,7 @@ int __cgroup_bpf_detach(struct cgroup *cgrp, struct bpf_prog *prog,
 		cgrp->bpf.flags[type] = 0;
 	if (old_prog)
 		bpf_prog_put(old_prog);
-	static_branch_dec(&cgroup_bpf_enabled_key);
+	static_branch_dec(&cgroup_bpf_enabled_key[type]);
 	return 0;
 
 cleanup:
@@ -1360,8 +1360,7 @@ int __cgroup_bpf_run_filter_setsockopt(struct sock *sk, int *level,
 	 * attached to the hook so we don't waste time allocating
 	 * memory and locking the socket.
 	 */
-	if (!cgroup_bpf_enabled ||
-	    __cgroup_bpf_prog_array_is_empty(cgrp, BPF_CGROUP_SETSOCKOPT))
+	if (__cgroup_bpf_prog_array_is_empty(cgrp, BPF_CGROUP_SETSOCKOPT))
 		return 0;
 
 	/* Allocate a bit more than the initial user buffer for
@@ -1457,8 +1456,7 @@ int __cgroup_bpf_run_filter_getsockopt(struct sock *sk, int level,
 	 * attached to the hook so we don't waste time allocating
 	 * memory and locking the socket.
 	 */
-	if (!cgroup_bpf_enabled ||
-	    __cgroup_bpf_prog_array_is_empty(cgrp, BPF_CGROUP_GETSOCKOPT))
+	if (__cgroup_bpf_prog_array_is_empty(cgrp, BPF_CGROUP_GETSOCKOPT))
 		return retval;
 
 	ctx.optlen = max_optlen;
diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index b94fa8eb831b..6ba2930ff49b 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -777,18 +777,19 @@ int inet_getname(struct socket *sock, struct sockaddr *uaddr,
 			return -ENOTCONN;
 		sin->sin_port = inet->inet_dport;
 		sin->sin_addr.s_addr = inet->inet_daddr;
+		BPF_CGROUP_RUN_SA_PROG_LOCK(sk, (struct sockaddr *)sin,
+					    BPF_CGROUP_INET4_GETPEERNAME,
+					    NULL);
 	} else {
 		__be32 addr = inet->inet_rcv_saddr;
 		if (!addr)
 			addr = inet->inet_saddr;
 		sin->sin_port = inet->inet_sport;
 		sin->sin_addr.s_addr = addr;
-	}
-	if (cgroup_bpf_enabled)
 		BPF_CGROUP_RUN_SA_PROG_LOCK(sk, (struct sockaddr *)sin,
-					    peer ? BPF_CGROUP_INET4_GETPEERNAME :
-						   BPF_CGROUP_INET4_GETSOCKNAME,
+					    BPF_CGROUP_INET4_GETSOCKNAME,
 					    NULL);
+	}
 	memset(sin->sin_zero, 0, sizeof(sin->sin_zero));
 	return sizeof(*sin);
 }
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 7103b0a89756..51535d2a23cf 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -1124,7 +1124,7 @@ int udp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 		rcu_read_unlock();
 	}
 
-	if (cgroup_bpf_enabled && !connected) {
+	if (cgroup_bpf_enabled(BPF_CGROUP_UDP4_SENDMSG) && !connected) {
 		err = BPF_CGROUP_RUN_PROG_UDP4_SENDMSG_LOCK(sk,
 					    (struct sockaddr *)usin, &ipc.addr);
 		if (err)
@@ -1858,9 +1858,8 @@ int udp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len, int noblock,
 		memset(sin->sin_zero, 0, sizeof(sin->sin_zero));
 		*addr_len = sizeof(*sin);
 
-		if (cgroup_bpf_enabled)
-			BPF_CGROUP_RUN_PROG_UDP4_RECVMSG_LOCK(sk,
-							(struct sockaddr *)sin);
+		BPF_CGROUP_RUN_PROG_UDP4_RECVMSG_LOCK(sk,
+						      (struct sockaddr *)sin);
 	}
 
 	if (udp_sk(sk)->gro_enabled)
diff --git a/net/ipv6/af_inet6.c b/net/ipv6/af_inet6.c
index 8e9c3e9ea36e..b9c654836b72 100644
--- a/net/ipv6/af_inet6.c
+++ b/net/ipv6/af_inet6.c
@@ -527,18 +527,19 @@ int inet6_getname(struct socket *sock, struct sockaddr *uaddr,
 		sin->sin6_addr = sk->sk_v6_daddr;
 		if (np->sndflow)
 			sin->sin6_flowinfo = np->flow_label;
+		BPF_CGROUP_RUN_SA_PROG_LOCK(sk, (struct sockaddr *)sin,
+					    BPF_CGROUP_INET6_GETPEERNAME,
+					    NULL);
 	} else {
 		if (ipv6_addr_any(&sk->sk_v6_rcv_saddr))
 			sin->sin6_addr = np->saddr;
 		else
 			sin->sin6_addr = sk->sk_v6_rcv_saddr;
 		sin->sin6_port = inet->inet_sport;
-	}
-	if (cgroup_bpf_enabled)
 		BPF_CGROUP_RUN_SA_PROG_LOCK(sk, (struct sockaddr *)sin,
-					    peer ? BPF_CGROUP_INET6_GETPEERNAME :
-						   BPF_CGROUP_INET6_GETSOCKNAME,
+					    BPF_CGROUP_INET6_GETSOCKNAME,
 					    NULL);
+	}
 	sin->sin6_scope_id = ipv6_iface_scope_id(&sin->sin6_addr,
 						 sk->sk_bound_dev_if);
 	return sizeof(*sin);
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index b9f3dfdd2383..a02ac875a923 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -409,9 +409,8 @@ int udpv6_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 		}
 		*addr_len = sizeof(*sin6);
 
-		if (cgroup_bpf_enabled)
-			BPF_CGROUP_RUN_PROG_UDP6_RECVMSG_LOCK(sk,
-						(struct sockaddr *)sin6);
+		BPF_CGROUP_RUN_PROG_UDP6_RECVMSG_LOCK(sk,
+						      (struct sockaddr *)sin6);
 	}
 
 	if (udp_sk(sk)->gro_enabled)
@@ -1462,7 +1461,7 @@ int udpv6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 		fl6.saddr = np->saddr;
 	fl6.fl6_sport = inet->inet_sport;
 
-	if (cgroup_bpf_enabled && !connected) {
+	if (cgroup_bpf_enabled(BPF_CGROUP_UDP6_SENDMSG) && !connected) {
 		err = BPF_CGROUP_RUN_PROG_UDP6_SENDMSG_LOCK(sk,
 					   (struct sockaddr *)sin6, &fl6.saddr);
 		if (err)
-- 
2.30.0.284.gd98b1dd5eaa7-goog

