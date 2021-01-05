Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71C9A2EB503
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 22:47:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731578AbhAEVpP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 16:45:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731553AbhAEVpO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jan 2021 16:45:14 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 817F1C06179F
        for <netdev@vger.kernel.org>; Tue,  5 Jan 2021 13:43:59 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id d187so1351862ybc.6
        for <netdev@vger.kernel.org>; Tue, 05 Jan 2021 13:43:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=/YPqH1RQ8TMuqVKScmdEk231ZnY94EC9bD9gJ5IJ+zo=;
        b=EKg4Gu42zSfZT+J8h0zk7VTsFGON3/IOB+H7n59GtkFU3Zc9drBtIZqcgxdPfhJ5SS
         hJWy38gRnlYp8EABGBT9HWqJQdr1JBPA3Q4qG7OnLng9C+Or5mjKfdyPfhGnZsiSAWOK
         Krx9Tx64GmHrfqK/sdL9k+cgUk3shfwsReCQp6Bu7K/HO8lpu2xfSEPnN4fBdqzSVOk9
         wKJOo85n/ONSCJplweL0ldJ3gFzV41QweHuH9l5butRyMe/shntZXAFUeBAiZf8dw0mX
         p9QLUE01FF/nxD3awJO5fE0PLwziiV1cx6nD2Axxt0uD0Ndl4nUZaqutHSByl3gwlUpb
         erOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=/YPqH1RQ8TMuqVKScmdEk231ZnY94EC9bD9gJ5IJ+zo=;
        b=b9V/W03uZZV7ok2/nRKwGos8OdhPEaPcAFyJ7I7AMYLKqN5quD23KJXNvjU7DULx7U
         uGILbyVKZ5vPTc+Es7nhI0kXaxb+B8DPIqIonLj43OQ6A1cC9ZnGMUOIMyjrVOvv41Hi
         hw8pvOcO01lV8+KdWOh+25iLt3fpIfUmkBKUiorOXpdfy/3FWl1MJBrRB6ZD6YU36LIX
         MYlmQDfQAn1RzZf6urbtGjpKyT/GewfroXuo1Ide5aaW5oPfTGHudSbF9FtpZ8XrgaSX
         lhtJgWWI18YgkOjdTB/0kz/OLM/6w7GJmkx+9VE+6jIAKhOgrHRBY/E4zkmKnRhA3jcz
         8OPA==
X-Gm-Message-State: AOAM533/FKbBWAwCSLDyK/YNuwSHerKpIylj65OLHpvcuXTitnmIFZK6
        8ehTK7V6kcHWNvO3HR3E7Ii7P9kUB/AnV2kUvyDAEwom4eEMSwgNOrvp/b9ydL7qGk1//taWQYJ
        WNuh1HfDgWYPSId8CGdu6OvCJ9NUWzHPTm5xavj+lCyUpAFpYOSTbbw==
X-Google-Smtp-Source: ABdhPJx9t3z74mpnQJvwcawEu42zdhmmu4+C1wTvqfksHdq8iUhFa7o3csb2147Zb0ccBK3KbmpGFgY=
Sender: "sdf via sendgmr" <sdf@sdf2.svl.corp.google.com>
X-Received: from sdf2.svl.corp.google.com ([2620:15c:2c4:1:7220:84ff:fe09:7732])
 (user=sdf job=sendgmr) by 2002:a25:3206:: with SMTP id y6mr2116887yby.127.1609883038671;
 Tue, 05 Jan 2021 13:43:58 -0800 (PST)
Date:   Tue,  5 Jan 2021 13:43:50 -0800
In-Reply-To: <20210105214350.138053-1-sdf@google.com>
Message-Id: <20210105214350.138053-4-sdf@google.com>
Mime-Version: 1.0
References: <20210105214350.138053-1-sdf@google.com>
X-Mailer: git-send-email 2.29.2.729.g45daf8777d-goog
Subject: [PATCH bpf-next v3 3/3] bpf: remove extra lock_sock for TCP_ZEROCOPY_RECEIVE
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
3% overhead for locking/unlocking the socket.

Also:
- Removed BUILD_BUG_ON (zerocopy doesn't depend on the buf size anymore)
- Separated on-stack buffer into bpf_sockopt_buf and downsized to 32 bytes
  (let's keep it to help with the other options)

(I can probably split this patch into two: add new features and rework
 bpf_sockopt_buf; can follow up if the approach in general sounds
 good).

Without this patch:
     3.29%     0.07%  tcp_mmap  [kernel.kallsyms]  [k] __cgroup_bpf_run_filter_getsockopt
            |
             --3.22%--__cgroup_bpf_run_filter_getsockopt
                       |
                       |--0.66%--lock_sock_nested
                       |
                       |--0.57%--__might_fault
                       |
                        --0.56%--release_sock

With the patch applied:
     0.42%     0.10%  tcp_mmap  [kernel.kallsyms]  [k] __cgroup_bpf_run_filter_getsockopt_kern
     0.02%     0.02%  tcp_mmap  [kernel.kallsyms]  [k] __cgroup_bpf_run_filter_getsockopt

Signed-off-by: Stanislav Fomichev <sdf@google.com>
Cc: Martin KaFai Lau <kafai@fb.com>
Cc: Song Liu <songliubraving@fb.com>
Cc: Eric Dumazet <edumazet@google.com>
---
 include/linux/bpf-cgroup.h                    |  16 +++
 include/linux/filter.h                        |   6 +-
 kernel/bpf/cgroup.c                           | 103 +++++++++++++-----
 net/ipv4/tcp.c                                |   2 +
 .../selftests/bpf/prog_tests/sockopt_sk.c     |  22 ++++
 .../testing/selftests/bpf/progs/sockopt_sk.c  |  15 +++
 6 files changed, 135 insertions(+), 29 deletions(-)

diff --git a/include/linux/bpf-cgroup.h b/include/linux/bpf-cgroup.h
index dd4b8e300746..e8ed9a839abe 100644
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
@@ -373,6 +377,16 @@ int bpf_percpu_cgroup_storage_update(struct bpf_map *map, void *key,
 	__ret;								       \
 })
 
+#define BPF_CGROUP_RUN_PROG_GETSOCKOPT_KERN(sock, level, optname, optval,      \
+					    optlen, retval)		       \
+({									       \
+	int __ret = retval;						       \
+	if (cgroup_bpf_enabled(BPF_CGROUP_GETSOCKOPT))			       \
+		__ret = __cgroup_bpf_run_filter_getsockopt_kern(	       \
+			sock, level, optname, optval, optlen, retval);	       \
+	__ret;								       \
+})
+
 int cgroup_bpf_prog_attach(const union bpf_attr *attr,
 			   enum bpf_prog_type ptype, struct bpf_prog *prog);
 int cgroup_bpf_prog_detach(const union bpf_attr *attr,
@@ -454,6 +468,8 @@ static inline int bpf_percpu_cgroup_storage_update(struct bpf_map *map,
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
diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
index adbecdcaa370..5ac927b8d75b 100644
--- a/kernel/bpf/cgroup.c
+++ b/kernel/bpf/cgroup.c
@@ -16,7 +16,7 @@
 #include <linux/bpf-cgroup.h>
 #include <net/sock.h>
 #include <net/bpf_sk_storage.h>
-#include <uapi/linux/tcp.h> /* sizeof(struct tcp_zerocopy_receive) */
+#include <net/tcp.h> /* sizeof(struct tcp_zerocopy_receive) & tcp_getsockopt */
 
 #include "../cgroup/cgroup-internal.h"
 
@@ -1299,7 +1299,8 @@ static bool __cgroup_bpf_prog_array_is_empty(struct cgroup *cgrp,
 	return empty;
 }
 
-static int sockopt_alloc_buf(struct bpf_sockopt_kern *ctx, int max_optlen)
+static int sockopt_alloc_buf(struct bpf_sockopt_kern *ctx, int max_optlen,
+			     struct bpf_sockopt_buf *buf)
 {
 	if (unlikely(max_optlen < 0))
 		return -EINVAL;
@@ -1311,18 +1312,11 @@ static int sockopt_alloc_buf(struct bpf_sockopt_kern *ctx, int max_optlen)
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
@@ -1336,16 +1330,18 @@ static int sockopt_alloc_buf(struct bpf_sockopt_kern *ctx, int max_optlen)
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
@@ -1353,6 +1349,7 @@ int __cgroup_bpf_run_filter_setsockopt(struct sock *sk, int *level,
 				       int *optlen, char **kernel_optval)
 {
 	struct cgroup *cgrp = sock_cgroup_ptr(&sk->sk_cgrp_data);
+	struct bpf_sockopt_buf buf = {};
 	struct bpf_sockopt_kern ctx = {
 		.sk = sk,
 		.level = *level,
@@ -1373,7 +1370,7 @@ int __cgroup_bpf_run_filter_setsockopt(struct sock *sk, int *level,
 	 */
 	max_optlen = max_t(int, 16, *optlen);
 
-	max_optlen = sockopt_alloc_buf(&ctx, max_optlen);
+	max_optlen = sockopt_alloc_buf(&ctx, max_optlen, &buf);
 	if (max_optlen < 0)
 		return max_optlen;
 
@@ -1419,7 +1416,7 @@ int __cgroup_bpf_run_filter_setsockopt(struct sock *sk, int *level,
 			 * No way to export on-stack buf, have to allocate a
 			 * new buffer.
 			 */
-			if (!sockopt_buf_allocated(&ctx)) {
+			if (!sockopt_buf_allocated(&ctx, &buf)) {
 				void *p = kzalloc(ctx.optlen, GFP_USER);
 
 				if (!p) {
@@ -1436,7 +1433,7 @@ int __cgroup_bpf_run_filter_setsockopt(struct sock *sk, int *level,
 
 out:
 	if (ret)
-		sockopt_free_buf(&ctx);
+		sockopt_free_buf(&ctx, &buf);
 	return ret;
 }
 
@@ -1445,15 +1442,29 @@ int __cgroup_bpf_run_filter_getsockopt(struct sock *sk, int level,
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
 
+#ifdef CONFIG_INET
+	/* TCP do_tcp_getsockopt has optimized getsockopt implementation
+	 * to avoid extra socket lock for TCP_ZEROCOPY_RECEIVE.
+	 */
+	if (sk->sk_prot->getsockopt == tcp_getsockopt &&
+	    level == SOL_TCP && optname == TCP_ZEROCOPY_RECEIVE)
+		return retval;
+#endif
+
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
@@ -1463,7 +1474,7 @@ int __cgroup_bpf_run_filter_getsockopt(struct sock *sk, int level,
 
 	ctx.optlen = max_optlen;
 
-	max_optlen = sockopt_alloc_buf(&ctx, max_optlen);
+	max_optlen = sockopt_alloc_buf(&ctx, max_optlen, &buf);
 	if (max_optlen < 0)
 		return max_optlen;
 
@@ -1521,9 +1532,47 @@ int __cgroup_bpf_run_filter_getsockopt(struct sock *sk, int level,
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
index ed42d2193c5c..d5367a879ed2 100644
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

