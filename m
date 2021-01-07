Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42AA62ED6DE
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 19:45:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729185AbhAGSo3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 13:44:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727177AbhAGSo2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jan 2021 13:44:28 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DE56C0612FE
        for <netdev@vger.kernel.org>; Thu,  7 Jan 2021 10:43:14 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id c9so11859895ybs.8
        for <netdev@vger.kernel.org>; Thu, 07 Jan 2021 10:43:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=0Lt9L+ol0tsNmbBSajXxpZf/QkBU7nNaW69TAkZsRxs=;
        b=q8zGpbJ6CfWnwFOzTY57utDi/VDT0Ebnzi0ZAM5kcwQARJtgahpyx9MalDm8A2PA2N
         Sxh71owmMATu1s6JmFLQgCKX409derZ3mhWyhW86gjMG4CXAA+vZJOX6ZcFwKcYU9nvD
         xDjJijeQ1HdKVDRFLQjHMC69pGJRoPZ7QSHZw7FhSYqLVE/5RIdjZJ72T7WXH6OXW3iW
         aLIpy4Glpg1cik2HF7uf1Ki3Vm2r0ykP+wUV/PIL/NJ865J1tElBISzT0uicZJBgbIzh
         F3wlJlOuH0T8gKjBmh29Rke6o9E4JWXJIxr7qEDTYBlLb7K2aGiDV3IgsiKNfbOCXyIy
         p0VA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=0Lt9L+ol0tsNmbBSajXxpZf/QkBU7nNaW69TAkZsRxs=;
        b=YXCFUPGntlDLXBHB8jEnkb+rT9+dVCfm4ZBY0yd77jzFtFIQldksFBRuWc6DKxyl0r
         TevGzKpB4V5VRSaUXIXMxNmvunbB1FdQ98mcvNMa1qjz6IRQk5RUkwPIqHQCgqCeLdn4
         EqU7G0/D7yHXcJdEtpyxnyciQ8/QuEqki3S/tcLzEd6tp0FLfbLl+YxdszRtk93hWArS
         fwjbiyPUIacfhJiqqKpuSCjz6/062MMp/FcUJsShuFqUQJDWWyYn9zTXoPwxPOAbqnbK
         Ki4pmNoYrXA+Syu3Cqj6Sjr01qtzpZJGfKgTyQvwA4UwhDKtevXSiZ6s8wt1K+9CG8Qv
         YRuQ==
X-Gm-Message-State: AOAM533gmYozqPz5ERfe6a3IbyD0V8DmcO6aiM7ZscpHMu8ogCBdycw7
        fvJEe+FYyQpU1QS5ZO0GsvUrc1lWv5+loq0PYABlObcrdxOSM6KsfK5a8/Oq7P0yFA0AjBZD5fh
        dAyn5kPErwddIedxObKLVP2E192ZUrs25jqY2oEiycAMFwxipxgLa/w==
X-Google-Smtp-Source: ABdhPJxXbhFZ0KNEk94NxpOeH0Z0x+6MbPT2RRObinAE5X/Lmlim3JVGPX7Gg3MsAnPxFY8RSO2yQs4=
Sender: "sdf via sendgmr" <sdf@sdf2.svl.corp.google.com>
X-Received: from sdf2.svl.corp.google.com ([2620:15c:2c4:1:7220:84ff:fe09:7732])
 (user=sdf job=sendgmr) by 2002:a25:d1c4:: with SMTP id i187mr203777ybg.7.1610044993376;
 Thu, 07 Jan 2021 10:43:13 -0800 (PST)
Date:   Thu,  7 Jan 2021 10:43:05 -0800
In-Reply-To: <20210107184305.444635-1-sdf@google.com>
Message-Id: <20210107184305.444635-4-sdf@google.com>
Mime-Version: 1.0
References: <20210107184305.444635-1-sdf@google.com>
X-Mailer: git-send-email 2.29.2.729.g45daf8777d-goog
Subject: [PATCH bpf-next v4 3/3] bpf: remove extra lock_sock for TCP_ZEROCOPY_RECEIVE
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add custom implementation of getsockopt hook for TCP_ZEROCOPY_RECEIVE.
We skip generic hooks for TCP_ZEROCOPY_RECEIVE and have a custom
call in do_tcp_getsockopt using the on-stack data. This removes
2% overhead for locking/unlocking the socket.

Also:
- Removed BUILD_BUG_ON (zerocopy doesn't depend on the buf size anymore)
- Separated on-stack buffer into bpf_sockopt_buf and downsized to 32 bytes
  (let's keep it to help with the other options)

(I can probably split this patch into two: add new features and rework
 bpf_sockopt_buf; can follow up if the approach in general sounds
 good).

Without this patch:
     1.87%     0.06%  tcp_mmap  [kernel.kallsyms]  [k] __cgroup_bpf_run_filter_getsockopt

With the patch applied:
     0.52%     0.12%  tcp_mmap  [kernel.kallsyms]  [k] __cgroup_bpf_run_filter_getsockopt_kern

Signed-off-by: Stanislav Fomichev <sdf@google.com>
Cc: Martin KaFai Lau <kafai@fb.com>
Cc: Song Liu <songliubraving@fb.com>
Cc: Eric Dumazet <edumazet@google.com>
---
 include/linux/bpf-cgroup.h                    | 25 ++++-
 include/linux/filter.h                        |  6 +-
 include/net/sock.h                            |  2 +
 include/net/tcp.h                             |  1 +
 kernel/bpf/cgroup.c                           | 93 +++++++++++++------
 net/ipv4/tcp.c                                | 14 +++
 net/ipv4/tcp_ipv4.c                           |  1 +
 net/ipv6/tcp_ipv6.c                           |  1 +
 .../selftests/bpf/prog_tests/sockopt_sk.c     | 22 +++++
 .../testing/selftests/bpf/progs/sockopt_sk.c  | 15 +++
 10 files changed, 147 insertions(+), 33 deletions(-)

diff --git a/include/linux/bpf-cgroup.h b/include/linux/bpf-cgroup.h
index dd4b8e300746..cbba9c9ab073 100644
--- a/include/linux/bpf-cgroup.h
+++ b/include/linux/bpf-cgroup.h
@@ -147,6 +147,10 @@ int __cgroup_bpf_run_filter_getsockopt(struct sock *sk, int level,
 				       int __user *optlen, int max_optlen,
 				       int retval);
 
+int __cgroup_bpf_run_filter_getsockopt_kern(struct sock *sk, int level,
+					    int optname, void *optval,
+					    int *optlen, int retval);
+
 static inline enum bpf_cgroup_storage_type cgroup_storage_type(
 	struct bpf_map *map)
 {
@@ -366,10 +370,21 @@ int bpf_percpu_cgroup_storage_update(struct bpf_map *map, void *key,
 ({									       \
 	int __ret = retval;						       \
 	if (cgroup_bpf_enabled(BPF_CGROUP_GETSOCKOPT))			       \
-		__ret = __cgroup_bpf_run_filter_getsockopt(sock, level,	       \
-							   optname, optval,    \
-							   optlen, max_optlen, \
-							   retval);	       \
+		if (!(sock)->sk_prot->bpf_bypass_getsockopt ||		       \
+		    !(sock)->sk_prot->bpf_bypass_getsockopt(level, optname))   \
+			__ret = __cgroup_bpf_run_filter_getsockopt(	       \
+				sock, level, optname, optval, optlen,	       \
+				max_optlen, retval);			       \
+	__ret;								       \
+})
+
+#define BPF_CGROUP_RUN_PROG_GETSOCKOPT_KERN(sock, level, optname, optval,      \
+					    optlen, retval)		       \
+({									       \
+	int __ret = retval;						       \
+	if (cgroup_bpf_enabled(BPF_CGROUP_GETSOCKOPT))			       \
+		__ret = __cgroup_bpf_run_filter_getsockopt_kern(	       \
+			sock, level, optname, optval, optlen, retval);	       \
 	__ret;								       \
 })
 
@@ -454,6 +469,8 @@ static inline int bpf_percpu_cgroup_storage_update(struct bpf_map *map,
 #define BPF_CGROUP_GETSOCKOPT_MAX_OPTLEN(optlen) ({ 0; })
 #define BPF_CGROUP_RUN_PROG_GETSOCKOPT(sock, level, optname, optval, \
 				       optlen, max_optlen, retval) ({ retval; })
+#define BPF_CGROUP_RUN_PROG_GETSOCKOPT_KERN(sock, level, optname, optval, \
+					    optlen, retval) ({ retval; })
 #define BPF_CGROUP_RUN_PROG_SETSOCKOPT(sock, level, optname, optval, optlen, \
 				       kernel_optval) ({ 0; })
 
diff --git a/include/linux/filter.h b/include/linux/filter.h
index 54a4225f36d8..8739f1d4cac4 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -1281,7 +1281,10 @@ struct bpf_sysctl_kern {
 	u64 tmp_reg;
 };
 
-#define BPF_SOCKOPT_KERN_BUF_SIZE	64
+#define BPF_SOCKOPT_KERN_BUF_SIZE	32
+struct bpf_sockopt_buf {
+	u8		data[BPF_SOCKOPT_KERN_BUF_SIZE];
+};
 
 struct bpf_sockopt_kern {
 	struct sock	*sk;
@@ -1291,7 +1294,6 @@ struct bpf_sockopt_kern {
 	s32		optname;
 	s32		optlen;
 	s32		retval;
-	u8		buf[BPF_SOCKOPT_KERN_BUF_SIZE];
 };
 
 int copy_bpf_fprog_from_user(struct sock_fprog *dst, sockptr_t src, int len);
diff --git a/include/net/sock.h b/include/net/sock.h
index bdc4323ce53c..ebf44d724845 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1174,6 +1174,8 @@ struct proto {
 
 	int			(*backlog_rcv) (struct sock *sk,
 						struct sk_buff *skb);
+	bool			(*bpf_bypass_getsockopt)(int level,
+							 int optname);
 
 	void		(*release_cb)(struct sock *sk);
 
diff --git a/include/net/tcp.h b/include/net/tcp.h
index 78d13c88720f..4bb42fb19711 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -403,6 +403,7 @@ __poll_t tcp_poll(struct file *file, struct socket *sock,
 		      struct poll_table_struct *wait);
 int tcp_getsockopt(struct sock *sk, int level, int optname,
 		   char __user *optval, int __user *optlen);
+bool tcp_bpf_bypass_getsockopt(int level, int optname);
 int tcp_setsockopt(struct sock *sk, int level, int optname, sockptr_t optval,
 		   unsigned int optlen);
 void tcp_set_keepalive(struct sock *sk, int val);
diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
index adbecdcaa370..e82df63aedc7 100644
--- a/kernel/bpf/cgroup.c
+++ b/kernel/bpf/cgroup.c
@@ -16,7 +16,6 @@
 #include <linux/bpf-cgroup.h>
 #include <net/sock.h>
 #include <net/bpf_sk_storage.h>
-#include <uapi/linux/tcp.h> /* sizeof(struct tcp_zerocopy_receive) */
 
 #include "../cgroup/cgroup-internal.h"
 
@@ -1299,7 +1298,8 @@ static bool __cgroup_bpf_prog_array_is_empty(struct cgroup *cgrp,
 	return empty;
 }
 
-static int sockopt_alloc_buf(struct bpf_sockopt_kern *ctx, int max_optlen)
+static int sockopt_alloc_buf(struct bpf_sockopt_kern *ctx, int max_optlen,
+			     struct bpf_sockopt_buf *buf)
 {
 	if (unlikely(max_optlen < 0))
 		return -EINVAL;
@@ -1311,18 +1311,11 @@ static int sockopt_alloc_buf(struct bpf_sockopt_kern *ctx, int max_optlen)
 		max_optlen = PAGE_SIZE;
 	}
 
-	if (max_optlen <= sizeof(ctx->buf)) {
+	if (max_optlen <= sizeof(buf->data)) {
 		/* When the optval fits into BPF_SOCKOPT_KERN_BUF_SIZE
 		 * bytes avoid the cost of kzalloc.
-		 *
-		 * In order to remove extra allocations from the TCP
-		 * fast zero-copy path ensure that buffer covers
-		 * the size of struct tcp_zerocopy_receive.
 		 */
-		BUILD_BUG_ON(sizeof(struct tcp_zerocopy_receive) >
-			     BPF_SOCKOPT_KERN_BUF_SIZE);
-
-		ctx->optval = ctx->buf;
+		ctx->optval = buf->data;
 		ctx->optval_end = ctx->optval + max_optlen;
 		return max_optlen;
 	}
@@ -1336,16 +1329,18 @@ static int sockopt_alloc_buf(struct bpf_sockopt_kern *ctx, int max_optlen)
 	return max_optlen;
 }
 
-static void sockopt_free_buf(struct bpf_sockopt_kern *ctx)
+static void sockopt_free_buf(struct bpf_sockopt_kern *ctx,
+			     struct bpf_sockopt_buf *buf)
 {
-	if (ctx->optval == ctx->buf)
+	if (ctx->optval == buf->data)
 		return;
 	kfree(ctx->optval);
 }
 
-static bool sockopt_buf_allocated(struct bpf_sockopt_kern *ctx)
+static bool sockopt_buf_allocated(struct bpf_sockopt_kern *ctx,
+				  struct bpf_sockopt_buf *buf)
 {
-	return ctx->optval != ctx->buf;
+	return ctx->optval != buf->data;
 }
 
 int __cgroup_bpf_run_filter_setsockopt(struct sock *sk, int *level,
@@ -1353,6 +1348,7 @@ int __cgroup_bpf_run_filter_setsockopt(struct sock *sk, int *level,
 				       int *optlen, char **kernel_optval)
 {
 	struct cgroup *cgrp = sock_cgroup_ptr(&sk->sk_cgrp_data);
+	struct bpf_sockopt_buf buf = {};
 	struct bpf_sockopt_kern ctx = {
 		.sk = sk,
 		.level = *level,
@@ -1373,7 +1369,7 @@ int __cgroup_bpf_run_filter_setsockopt(struct sock *sk, int *level,
 	 */
 	max_optlen = max_t(int, 16, *optlen);
 
-	max_optlen = sockopt_alloc_buf(&ctx, max_optlen);
+	max_optlen = sockopt_alloc_buf(&ctx, max_optlen, &buf);
 	if (max_optlen < 0)
 		return max_optlen;
 
@@ -1419,7 +1415,7 @@ int __cgroup_bpf_run_filter_setsockopt(struct sock *sk, int *level,
 			 * No way to export on-stack buf, have to allocate a
 			 * new buffer.
 			 */
-			if (!sockopt_buf_allocated(&ctx)) {
+			if (!sockopt_buf_allocated(&ctx, &buf)) {
 				void *p = kzalloc(ctx.optlen, GFP_USER);
 
 				if (!p) {
@@ -1436,7 +1432,7 @@ int __cgroup_bpf_run_filter_setsockopt(struct sock *sk, int *level,
 
 out:
 	if (ret)
-		sockopt_free_buf(&ctx);
+		sockopt_free_buf(&ctx, &buf);
 	return ret;
 }
 
@@ -1445,15 +1441,20 @@ int __cgroup_bpf_run_filter_getsockopt(struct sock *sk, int level,
 				       int __user *optlen, int max_optlen,
 				       int retval)
 {
-	struct cgroup *cgrp = sock_cgroup_ptr(&sk->sk_cgrp_data);
-	struct bpf_sockopt_kern ctx = {
-		.sk = sk,
-		.level = level,
-		.optname = optname,
-		.retval = retval,
-	};
+	struct bpf_sockopt_kern ctx;
+	struct bpf_sockopt_buf buf;
+	struct cgroup *cgrp;
 	int ret;
 
+	memset(&buf, 0, sizeof(buf));
+	memset(&ctx, 0, sizeof(ctx));
+
+	cgrp = sock_cgroup_ptr(&sk->sk_cgrp_data);
+	ctx.sk = sk;
+	ctx.level = level;
+	ctx.optname = optname;
+	ctx.retval = retval;
+
 	/* Opportunistic check to see whether we have any BPF program
 	 * attached to the hook so we don't waste time allocating
 	 * memory and locking the socket.
@@ -1463,7 +1464,7 @@ int __cgroup_bpf_run_filter_getsockopt(struct sock *sk, int level,
 
 	ctx.optlen = max_optlen;
 
-	max_optlen = sockopt_alloc_buf(&ctx, max_optlen);
+	max_optlen = sockopt_alloc_buf(&ctx, max_optlen, &buf);
 	if (max_optlen < 0)
 		return max_optlen;
 
@@ -1521,9 +1522,47 @@ int __cgroup_bpf_run_filter_getsockopt(struct sock *sk, int level,
 	ret = ctx.retval;
 
 out:
-	sockopt_free_buf(&ctx);
+	sockopt_free_buf(&ctx, &buf);
 	return ret;
 }
+
+int __cgroup_bpf_run_filter_getsockopt_kern(struct sock *sk, int level,
+					    int optname, void *optval,
+					    int *optlen, int retval)
+{
+	struct cgroup *cgrp = sock_cgroup_ptr(&sk->sk_cgrp_data);
+	struct bpf_sockopt_kern ctx = {
+		.sk = sk,
+		.level = level,
+		.optname = optname,
+		.retval = retval,
+		.optlen = *optlen,
+		.optval = optval,
+		.optval_end = optval + *optlen,
+	};
+	int ret;
+
+	ret = BPF_PROG_RUN_ARRAY(cgrp->bpf.effective[BPF_CGROUP_GETSOCKOPT],
+				 &ctx, BPF_PROG_RUN);
+	if (!ret)
+		return -EPERM;
+
+	if (ctx.optlen > *optlen)
+		return -EFAULT;
+
+	/* BPF programs only allowed to set retval to 0, not some
+	 * arbitrary value.
+	 */
+	if (ctx.retval != 0 && ctx.retval != retval)
+		return -EFAULT;
+
+	/* BPF programs can shrink the buffer, export the modifications.
+	 */
+	if (ctx.optlen != 0)
+		*optlen = ctx.optlen;
+
+	return ctx.retval;
+}
 #endif
 
 static ssize_t sysctl_cpy_dir(const struct ctl_dir *dir, char **bufp,
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index ed42d2193c5c..ef3c895b66c1 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -4098,6 +4098,8 @@ static int do_tcp_getsockopt(struct sock *sk, int level,
 			return -EFAULT;
 		lock_sock(sk);
 		err = tcp_zerocopy_receive(sk, &zc);
+		err = BPF_CGROUP_RUN_PROG_GETSOCKOPT_KERN(sk, level, optname,
+							  &zc, &len, err);
 		release_sock(sk);
 		if (len >= offsetofend(struct tcp_zerocopy_receive, err))
 			goto zerocopy_rcv_sk_err;
@@ -4132,6 +4134,18 @@ static int do_tcp_getsockopt(struct sock *sk, int level,
 	return 0;
 }
 
+bool tcp_bpf_bypass_getsockopt(int level, int optname)
+{
+	/* TCP do_tcp_getsockopt has optimized getsockopt implementation
+	 * to avoid extra socket lock for TCP_ZEROCOPY_RECEIVE.
+	 */
+	if (level == SOL_TCP && optname == TCP_ZEROCOPY_RECEIVE)
+		return true;
+
+	return false;
+}
+EXPORT_SYMBOL(tcp_bpf_bypass_getsockopt);
+
 int tcp_getsockopt(struct sock *sk, int level, int optname, char __user *optval,
 		   int __user *optlen)
 {
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 58207c7769d0..8b4906980fce 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -2792,6 +2792,7 @@ struct proto tcp_prot = {
 	.shutdown		= tcp_shutdown,
 	.setsockopt		= tcp_setsockopt,
 	.getsockopt		= tcp_getsockopt,
+	.bpf_bypass_getsockopt	= tcp_bpf_bypass_getsockopt,
 	.keepalive		= tcp_set_keepalive,
 	.recvmsg		= tcp_recvmsg,
 	.sendmsg		= tcp_sendmsg,
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index e254569a3005..6624eccff85b 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -2121,6 +2121,7 @@ struct proto tcpv6_prot = {
 	.shutdown		= tcp_shutdown,
 	.setsockopt		= tcp_setsockopt,
 	.getsockopt		= tcp_getsockopt,
+	.bpf_bypass_getsockopt	= tcp_bpf_bypass_getsockopt,
 	.keepalive		= tcp_set_keepalive,
 	.recvmsg		= tcp_recvmsg,
 	.sendmsg		= tcp_sendmsg,
diff --git a/tools/testing/selftests/bpf/prog_tests/sockopt_sk.c b/tools/testing/selftests/bpf/prog_tests/sockopt_sk.c
index b25c9c45c148..6bb18b1d8578 100644
--- a/tools/testing/selftests/bpf/prog_tests/sockopt_sk.c
+++ b/tools/testing/selftests/bpf/prog_tests/sockopt_sk.c
@@ -11,6 +11,7 @@ static int getsetsockopt(void)
 		char u8[4];
 		__u32 u32;
 		char cc[16]; /* TCP_CA_NAME_MAX */
+		struct tcp_zerocopy_receive zc;
 	} buf = {};
 	socklen_t optlen;
 	char *big_buf = NULL;
@@ -154,6 +155,27 @@ static int getsetsockopt(void)
 		goto err;
 	}
 
+	/* TCP_ZEROCOPY_RECEIVE triggers */
+	memset(&buf, 0, sizeof(buf));
+	optlen = sizeof(buf.zc);
+	err = getsockopt(fd, SOL_TCP, TCP_ZEROCOPY_RECEIVE, &buf, &optlen);
+	if (err) {
+		log_err("Unexpected getsockopt(TCP_ZEROCOPY_RECEIVE) err=%d errno=%d",
+			err, errno);
+		goto err;
+	}
+
+	memset(&buf, 0, sizeof(buf));
+	buf.zc.address = 12345; /* rejected by BPF */
+	optlen = sizeof(buf.zc);
+	errno = 0;
+	err = getsockopt(fd, SOL_TCP, TCP_ZEROCOPY_RECEIVE, &buf, &optlen);
+	if (errno != EPERM) {
+		log_err("Unexpected getsockopt(TCP_ZEROCOPY_RECEIVE) err=%d errno=%d",
+			err, errno);
+		goto err;
+	}
+
 	free(big_buf);
 	close(fd);
 	return 0;
diff --git a/tools/testing/selftests/bpf/progs/sockopt_sk.c b/tools/testing/selftests/bpf/progs/sockopt_sk.c
index 712df7b49cb1..c726f0763a13 100644
--- a/tools/testing/selftests/bpf/progs/sockopt_sk.c
+++ b/tools/testing/selftests/bpf/progs/sockopt_sk.c
@@ -57,6 +57,21 @@ int _getsockopt(struct bpf_sockopt *ctx)
 		return 1;
 	}
 
+	if (ctx->level == SOL_TCP && ctx->optname == TCP_ZEROCOPY_RECEIVE) {
+		/* Verify that TCP_ZEROCOPY_RECEIVE triggers.
+		 * It has a custom implementation for performance
+		 * reasons.
+		 */
+
+		if (optval + sizeof(struct tcp_zerocopy_receive) > optval_end)
+			return 0; /* EPERM, bounds check */
+
+		if (((struct tcp_zerocopy_receive *)optval)->address != 0)
+			return 0; /* EPERM, unexpected data */
+
+		return 1;
+	}
+
 	if (ctx->level == SOL_IP && ctx->optname == IP_FREEBIND) {
 		if (optval + 1 > optval_end)
 			return 0; /* EPERM, bounds check */
-- 
2.29.2.729.g45daf8777d-goog

