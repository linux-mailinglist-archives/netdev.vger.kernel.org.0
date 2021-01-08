Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B2C92EF6EF
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 19:04:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728674AbhAHSEK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 13:04:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728665AbhAHSEJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jan 2021 13:04:09 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE453C0612A4
        for <netdev@vger.kernel.org>; Fri,  8 Jan 2021 10:03:39 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id w8so16178158ybj.14
        for <netdev@vger.kernel.org>; Fri, 08 Jan 2021 10:03:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=rbPwilzRenpE074u41QU5AA4ZQ+ZyxgWUm1+hI6jy3w=;
        b=pMFePmDAtaQmRsyI9xp6RC5mu8Hzlq1VwwkOtXBhuieSOp9+svdlDSJTZYgIHndQTu
         a6nf1zIfHxAeuW1Y1UT20hoCFHCTdriExfN/gfTpebmNDDNjNObCnLJhJMcd1+84RQO6
         LHZa5HALY9FiDmZo29pnVN2PYXb0RAfvlOgGkqYXT/nxQUe6Mhnn1DbmAckh6NHi3xhV
         tWxiCM2OQt+MsdUj2hDbrJCf9Hu1th+trO1KVzTl9CTJCl7x4IKnN9PmHRGJXX7Hicqd
         MCkCj9R0AIgxgA7B5W2ppdB0V/pG/KhUr9Ovf3QYm6bP0zZTr8oc4V7r/tT3nwVH3Uw2
         TrKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=rbPwilzRenpE074u41QU5AA4ZQ+ZyxgWUm1+hI6jy3w=;
        b=JoBFpcmtVEZtlQrDue/xTan31G0YS1bAS7lALnLLbx6siBagkfOciqapSWCLooK/uu
         wpHAu+wbuGhkiioUi3wra3omB3TdoiU4ZGhDYtJIzr9YwVOl4rxyMvsywI7WRkFdw22a
         y3Cj0xz617eyR/fTk5M2Uwo8x6ffqGZLiylPWId8aHcKNoQB7NRua/N5zVcIx4gFzhhR
         /o//JKmKpBK2YCpy0ByvfNfke1Kc1TAaJuELsnyqMTCN0SYLrWcgdjMK9tq0bBuQJCFY
         olkW1jdIN7zXjGTgff6o7DEAHWwxD5X8vUr/ikO59CPc/3fVQkNC/uvaIYFwcCy8txfU
         P8OA==
X-Gm-Message-State: AOAM533mF6ZAB3baD4pbCzkYCDBkCS3kD5ezkdk0/0nNQNd0XpthY0+6
        2Y/2uT1ycxRmzLux63oHm+cQkxuWVrriJuPpUyrv3X1Gur5yKfibBaGPtXedagWcn+hctZXz+iL
        bR4BpvIPNnDC06GlD3c3s41Y51fe4jFt4pV1pHiNhBpLnvMc3bSSkGA==
X-Google-Smtp-Source: ABdhPJzExFqmHSTh+0nYscEFjSWClSi4bCafNUi4St/sLKLiWTW/irO7YHnp0a26nxET4pCJqJNArbY=
Sender: "sdf via sendgmr" <sdf@sdf2.svl.corp.google.com>
X-Received: from sdf2.svl.corp.google.com ([2620:15c:2c4:1:7220:84ff:fe09:7732])
 (user=sdf job=sendgmr) by 2002:a25:aa87:: with SMTP id t7mr7002460ybi.233.1610129019127;
 Fri, 08 Jan 2021 10:03:39 -0800 (PST)
Date:   Fri,  8 Jan 2021 10:03:32 -0800
In-Reply-To: <20210108180333.180906-1-sdf@google.com>
Message-Id: <20210108180333.180906-3-sdf@google.com>
Mime-Version: 1.0
References: <20210108180333.180906-1-sdf@google.com>
X-Mailer: git-send-email 2.29.2.729.g45daf8777d-goog
Subject: [PATCH bpf-next v5 2/3] bpf: try to avoid kzalloc in cgroup/{s,g}etsockopt
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When we attach a bpf program to cgroup/getsockopt any other getsockopt()
syscall starts incurring kzalloc/kfree cost.

Let add a small buffer on the stack and use it for small (majority)
{s,g}etsockopt values. The buffer is small enough to fit into
the cache line and cover the majority of simple options (most
of them are 4 byte ints).

It seems natural to do the same for setsockopt, but it's a bit more
involved when the BPF program modifies the data (where we have to
kmalloc). The assumption is that for the majority of setsockopt
calls (which are doing pure BPF options or apply policy) this
will bring some benefit as well.

Without this patch (we remove about 1% __kmalloc):
     3.38%     0.07%  tcp_mmap  [kernel.kallsyms]  [k] __cgroup_bpf_run_filter_getsockopt
            |
             --3.30%--__cgroup_bpf_run_filter_getsockopt
                       |
                        --0.81%--__kmalloc

Signed-off-by: Stanislav Fomichev <sdf@google.com>
Cc: Martin KaFai Lau <kafai@fb.com>
Cc: Song Liu <songliubraving@fb.com>
---
 include/linux/filter.h |  5 ++++
 kernel/bpf/cgroup.c    | 52 ++++++++++++++++++++++++++++++++++++------
 2 files changed, 50 insertions(+), 7 deletions(-)

diff --git a/include/linux/filter.h b/include/linux/filter.h
index 29c27656165b..8739f1d4cac4 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -1281,6 +1281,11 @@ struct bpf_sysctl_kern {
 	u64 tmp_reg;
 };
 
+#define BPF_SOCKOPT_KERN_BUF_SIZE	32
+struct bpf_sockopt_buf {
+	u8		data[BPF_SOCKOPT_KERN_BUF_SIZE];
+};
+
 struct bpf_sockopt_kern {
 	struct sock	*sk;
 	u8		*optval;
diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
index c41bb2f34013..a9aad9c419e1 100644
--- a/kernel/bpf/cgroup.c
+++ b/kernel/bpf/cgroup.c
@@ -1298,7 +1298,8 @@ static bool __cgroup_bpf_prog_array_is_empty(struct cgroup *cgrp,
 	return empty;
 }
 
-static int sockopt_alloc_buf(struct bpf_sockopt_kern *ctx, int max_optlen)
+static int sockopt_alloc_buf(struct bpf_sockopt_kern *ctx, int max_optlen,
+			     struct bpf_sockopt_buf *buf)
 {
 	if (unlikely(max_optlen < 0))
 		return -EINVAL;
@@ -1310,6 +1311,15 @@ static int sockopt_alloc_buf(struct bpf_sockopt_kern *ctx, int max_optlen)
 		max_optlen = PAGE_SIZE;
 	}
 
+	if (max_optlen <= sizeof(buf->data)) {
+		/* When the optval fits into BPF_SOCKOPT_KERN_BUF_SIZE
+		 * bytes avoid the cost of kzalloc.
+		 */
+		ctx->optval = buf->data;
+		ctx->optval_end = ctx->optval + max_optlen;
+		return max_optlen;
+	}
+
 	ctx->optval = kzalloc(max_optlen, GFP_USER);
 	if (!ctx->optval)
 		return -ENOMEM;
@@ -1319,16 +1329,26 @@ static int sockopt_alloc_buf(struct bpf_sockopt_kern *ctx, int max_optlen)
 	return max_optlen;
 }
 
-static void sockopt_free_buf(struct bpf_sockopt_kern *ctx)
+static void sockopt_free_buf(struct bpf_sockopt_kern *ctx,
+			     struct bpf_sockopt_buf *buf)
 {
+	if (ctx->optval == buf->data)
+		return;
 	kfree(ctx->optval);
 }
 
+static bool sockopt_buf_allocated(struct bpf_sockopt_kern *ctx,
+				  struct bpf_sockopt_buf *buf)
+{
+	return ctx->optval != buf->data;
+}
+
 int __cgroup_bpf_run_filter_setsockopt(struct sock *sk, int *level,
 				       int *optname, char __user *optval,
 				       int *optlen, char **kernel_optval)
 {
 	struct cgroup *cgrp = sock_cgroup_ptr(&sk->sk_cgrp_data);
+	struct bpf_sockopt_buf buf = {};
 	struct bpf_sockopt_kern ctx = {
 		.sk = sk,
 		.level = *level,
@@ -1350,7 +1370,7 @@ int __cgroup_bpf_run_filter_setsockopt(struct sock *sk, int *level,
 	 */
 	max_optlen = max_t(int, 16, *optlen);
 
-	max_optlen = sockopt_alloc_buf(&ctx, max_optlen);
+	max_optlen = sockopt_alloc_buf(&ctx, max_optlen, &buf);
 	if (max_optlen < 0)
 		return max_optlen;
 
@@ -1390,13 +1410,30 @@ int __cgroup_bpf_run_filter_setsockopt(struct sock *sk, int *level,
 		 */
 		if (ctx.optlen != 0) {
 			*optlen = ctx.optlen;
-			*kernel_optval = ctx.optval;
+			/* We've used bpf_sockopt_kern->buf as an intermediary
+			 * storage, but the BPF program indicates that we need
+			 * to pass this data to the kernel setsockopt handler.
+			 * No way to export on-stack buf, have to allocate a
+			 * new buffer.
+			 */
+			if (!sockopt_buf_allocated(&ctx, &buf)) {
+				void *p = kzalloc(ctx.optlen, GFP_USER);
+
+				if (!p) {
+					ret = -ENOMEM;
+					goto out;
+				}
+				memcpy(p, ctx.optval, ctx.optlen);
+				*kernel_optval = p;
+			} else {
+				*kernel_optval = ctx.optval;
+			}
 		}
 	}
 
 out:
 	if (ret)
-		sockopt_free_buf(&ctx);
+		sockopt_free_buf(&ctx, &buf);
 	return ret;
 }
 
@@ -1406,6 +1443,7 @@ int __cgroup_bpf_run_filter_getsockopt(struct sock *sk, int level,
 				       int retval)
 {
 	struct cgroup *cgrp = sock_cgroup_ptr(&sk->sk_cgrp_data);
+	struct bpf_sockopt_buf buf = {};
 	struct bpf_sockopt_kern ctx = {
 		.sk = sk,
 		.level = level,
@@ -1424,7 +1462,7 @@ int __cgroup_bpf_run_filter_getsockopt(struct sock *sk, int level,
 
 	ctx.optlen = max_optlen;
 
-	max_optlen = sockopt_alloc_buf(&ctx, max_optlen);
+	max_optlen = sockopt_alloc_buf(&ctx, max_optlen, &buf);
 	if (max_optlen < 0)
 		return max_optlen;
 
@@ -1482,7 +1520,7 @@ int __cgroup_bpf_run_filter_getsockopt(struct sock *sk, int level,
 	ret = ctx.retval;
 
 out:
-	sockopt_free_buf(&ctx);
+	sockopt_free_buf(&ctx, &buf);
 	return ret;
 }
 
-- 
2.29.2.729.g45daf8777d-goog

