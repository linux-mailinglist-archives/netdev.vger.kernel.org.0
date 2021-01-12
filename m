Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 961222F3FEE
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 01:46:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438372AbhALWkM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 17:40:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733073AbhALWkL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 17:40:11 -0500
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23DF9C0617A4
        for <netdev@vger.kernel.org>; Tue, 12 Jan 2021 14:38:56 -0800 (PST)
Received: by mail-qt1-x84a.google.com with SMTP id p20so69226qtq.3
        for <netdev@vger.kernel.org>; Tue, 12 Jan 2021 14:38:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=SmWEDdc6LKmHZ4NY5sVEwDjjxHuX4dbqdYxIh96VHak=;
        b=Pna/NI5rT2CLOt/iFFlDgUJyBzl1PSSHTme61wTa0RVV05+varZI9eYfP3Wc7K/Lvs
         ak0Do6G80Yt5km8THj9pAS+wg84Q5/uw2A7DX9rU11OE5tdEKf/5c4xXtOJljPpGiY05
         4yXLn9pdvKZNCIcOOTp/9oPJPkkLVmLL5nZjGoRbmKN8LH/asd9uhRd9tS361V9lG2TV
         uO5gJgX6hboRoLBQfSo3Zv6pbRAb1KjmmMTJNHGDnUYXhmspgVwd1oFv0c7zw8Vyc8DF
         8xV//QAHvoixcomJ1ojoNC9ScK1mR622u8nlsLk2o7pJQOs4yEHpeOy4+5gANXmCM50A
         DiYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=SmWEDdc6LKmHZ4NY5sVEwDjjxHuX4dbqdYxIh96VHak=;
        b=nSCZO3b+tf1iFDLWWyGkkYikh3U/uvxBt0YhfZC8bOZpEoMq4rzFnKCAFLQi0veDdZ
         E/LLgAFcfDNReJ5wTHqt7qS/14T2g8Cl/2PQJYrts0tzoSzxxHgJPeHZOwacmVLCBok3
         9bHnDq5rf3XUdVdmyDha5uJsCEQFcJjJv+/OSN7Us00p+/YjpObZx6Qq6pIQ73fv8X1m
         8PqQEqFiD1GuYRlhirWmdSPa6w5+jKQH/re+rKf1H2ZQ3/VG/+J31C0EpbmZcUK7LOju
         KQRpbG6YUcuHY1Jzfk0LD84Sl8/hmIipwtPZS0mnh4qZFTXhyOZ4hY/Iio/YvxxBXStI
         cT+g==
X-Gm-Message-State: AOAM531Gll1XxNqLypI1oHU+0ZAM1Uv0u0fhxFjjmIdWJcvrVFQDedvZ
        BUInw87iZwnhxC7ojeNMeyeLrSbmTbpIzRNtS77UIZOhIbhJQtmaWpEabkUmLINFk+HkWJRuGLe
        PjUnf8QgJYyjfsxFxgPr06+Py4A1TWRE/z66ROEDIgD0+owu98FTZeA==
X-Google-Smtp-Source: ABdhPJzjuT0+zV9hv7uMwgcpn3en9DdD9AJ7Nj0XoYmhEuuBRjhFNOUFGgU77zxrjT/83KfBHQaJ9b0=
Sender: "sdf via sendgmr" <sdf@sdf2.svl.corp.google.com>
X-Received: from sdf2.svl.corp.google.com ([2620:15c:2c4:1:7220:84ff:fe09:7732])
 (user=sdf job=sendgmr) by 2002:a0c:c583:: with SMTP id a3mr1886339qvj.15.1610491135301;
 Tue, 12 Jan 2021 14:38:55 -0800 (PST)
Date:   Tue, 12 Jan 2021 14:38:46 -0800
In-Reply-To: <20210112223847.1915615-1-sdf@google.com>
Message-Id: <20210112223847.1915615-4-sdf@google.com>
Mime-Version: 1.0
References: <20210112223847.1915615-1-sdf@google.com>
X-Mailer: git-send-email 2.30.0.284.gd98b1dd5eaa7-goog
Subject: [PATCH bpf-next v7 3/4] bpf: try to avoid kzalloc in cgroup/{s,g}etsockopt
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
index 416e7738981b..dbeef7afbbf9 100644
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
 
@@ -1390,14 +1410,31 @@ int __cgroup_bpf_run_filter_setsockopt(struct sock *sk, int *level,
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
 			/* export and don't free sockopt buf */
 			return 0;
 		}
 	}
 
 out:
-	sockopt_free_buf(&ctx);
+	sockopt_free_buf(&ctx, &buf);
 	return ret;
 }
 
@@ -1407,6 +1444,7 @@ int __cgroup_bpf_run_filter_getsockopt(struct sock *sk, int level,
 				       int retval)
 {
 	struct cgroup *cgrp = sock_cgroup_ptr(&sk->sk_cgrp_data);
+	struct bpf_sockopt_buf buf = {};
 	struct bpf_sockopt_kern ctx = {
 		.sk = sk,
 		.level = level,
@@ -1425,7 +1463,7 @@ int __cgroup_bpf_run_filter_getsockopt(struct sock *sk, int level,
 
 	ctx.optlen = max_optlen;
 
-	max_optlen = sockopt_alloc_buf(&ctx, max_optlen);
+	max_optlen = sockopt_alloc_buf(&ctx, max_optlen, &buf);
 	if (max_optlen < 0)
 		return max_optlen;
 
@@ -1483,7 +1521,7 @@ int __cgroup_bpf_run_filter_getsockopt(struct sock *sk, int level,
 	ret = ctx.retval;
 
 out:
-	sockopt_free_buf(&ctx);
+	sockopt_free_buf(&ctx, &buf);
 	return ret;
 }
 
-- 
2.30.0.284.gd98b1dd5eaa7-goog

