Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 996512EA0A4
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 00:20:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727425AbhADXUT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jan 2021 18:20:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726776AbhADXUT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jan 2021 18:20:19 -0500
Received: from mail-vs1-xe4a.google.com (mail-vs1-xe4a.google.com [IPv6:2607:f8b0:4864:20::e4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 096BEC061793
        for <netdev@vger.kernel.org>; Mon,  4 Jan 2021 15:19:39 -0800 (PST)
Received: by mail-vs1-xe4a.google.com with SMTP id e18so7431498vsh.20
        for <netdev@vger.kernel.org>; Mon, 04 Jan 2021 15:19:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=YdbAgIO2OPnsvaT1YJ6/WAFB+WtpWDBBJcdWS3MT4Zc=;
        b=RttI15fHGDabyDPtR1/WtJj+60bQoGOe+Ho72yf0WfOM16FZR35nhpsoLCyC7g49a3
         k4Cliz0DlKlrfR+IFI5gFSYOz8ERLqqTTHGL/C7viSc+lTYkK75FDquKpWksK6xYV+gR
         W3EOlmWTHnx/TclP+KvoWCEtENcA9CDko3yVPZu0whkpz7MoFxUBSAXwmhOsE/YU97iF
         YAMs8+NvMflCiZcaV5FVXh8QL9Thav+1iWYcQjenNmauEk+p/rXwruG1g/QJKWvoZL8z
         w1aTSDtLMFu5DPJy4A6ieQfx7AWiVl+fzSyEjMZrueYJxzUvkw5hLxQIAS9iWVyy/k7H
         3ylg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=YdbAgIO2OPnsvaT1YJ6/WAFB+WtpWDBBJcdWS3MT4Zc=;
        b=gceI85m54Vp0pvfR9tudWMkxPu3zCDMZvj1T/KFjCcBuDw/qFHuBorTftxjbAPQfJp
         WkYjTjuAmjd3FtWh+5eKaB2DhH6iaZzyz1HuFkNLxdgEw0XSDq81njOFHp3QWQou/vpj
         YA9dBvEhWqoVAE2DNKVx3dn/C60fZqyIHdNRMMxjVd7/4coCe7tv4v55qVXmoss8kVT0
         3Grrv0bG6uESkODFBp3lNd3tZS4s6EUgtSSNtx+grNIVpUzBcWkCM/FE5R6iZMKrwDYg
         njH7J+7uLlztqdT91ktl08w3VChFlUK+bW7PG1gvS9ouEcSdZSJ2tepkaCU5OKVkBDr+
         wcGA==
X-Gm-Message-State: AOAM532VVZcXneWgGPH/pH4dyiyFinbAxPuEgvDZGdHYPMiTkEebGZFS
        +QWzkUIfkgJPbR6Xmp+RdCUfj14+ekjH7rSv6kvUflYbFnXMxthmLvl6zwu1hIUMEaPEEryAOvm
        1B3txGDiGDLNn/jU9G6MBWliPrgMOdH9nxT3u9U+HR/+mANIUIPRLgA==
X-Google-Smtp-Source: ABdhPJyN5Mm/VMNT4Vtvg6Ai+kiZL40mk9j/uSA+S3FkpvfUTubV6DbXQ9UQBouwAegT8oS1buJ7JV4=
Sender: "sdf via sendgmr" <sdf@sdf2.svl.corp.google.com>
X-Received: from sdf2.svl.corp.google.com ([2620:15c:2c4:1:7220:84ff:fe09:7732])
 (user=sdf job=sendgmr) by 2002:a25:7789:: with SMTP id s131mr110750168ybc.212.1609798498611;
 Mon, 04 Jan 2021 14:14:58 -0800 (PST)
Date:   Mon,  4 Jan 2021 14:14:53 -0800
In-Reply-To: <20210104221454.2204239-1-sdf@google.com>
Message-Id: <20210104221454.2204239-2-sdf@google.com>
Mime-Version: 1.0
References: <20210104221454.2204239-1-sdf@google.com>
X-Mailer: git-send-email 2.29.2.729.g45daf8777d-goog
Subject: [PATCH bpf-next v2 1/2] bpf: try to avoid kzalloc in cgroup/{s,g}etsockopt
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>,
        Martin KaFai Lau <kafai@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When we attach a bpf program to cgroup/getsockopt any other getsockopt()
syscall starts incurring kzalloc/kfree cost. While, in general, it's
not an issue, sometimes it is, like in the case of TCP_ZEROCOPY_RECEIVE.
TCP_ZEROCOPY_RECEIVE (ab)uses getsockopt system call to implement
fastpath for incoming TCP, we don't want to have extra allocations in
there.

Let add a small buffer on the stack and use it for small (majority)
{s,g}etsockopt values. I've started with 128 bytes to cover
the options we care about (TCP_ZEROCOPY_RECEIVE which is 32 bytes
currently, with some planned extension to 64).

It seems natural to do the same for setsockopt, but it's a bit more
involved when the BPF program modifies the data (where we have to
kmalloc). The assumption is that for the majority of setsockopt
calls (which are doing pure BPF options or apply policy) this
will bring some benefit as well.

Collected some performance numbers using (on a 65k MTU localhost in a VM):
$ perf record -g -- ./tcp_mmap -s -z
$ ./tcp_mmap -H ::1 -z
$ ...
$ perf report --symbol-filter=__cgroup_bpf_run_filter_getsockopt

Without this patch:
     4.81%     0.07%  tcp_mmap  [kernel.kallsyms]  [k] __cgroup_bpf_run_filter_>
            |
             --4.74%--__cgroup_bpf_run_filter_getsockopt
                       |
                       |--1.06%--__kmalloc
                       |
                       |--0.71%--lock_sock_nested
                       |
                       |--0.62%--__might_fault
                       |
                        --0.52%--release_sock

With the patch applied:
     3.29%     0.07%  tcp_mmap  [kernel.kallsyms]  [k] __cgroup_bpf_run_filter_getsockopt
            |
             --3.22%--__cgroup_bpf_run_filter_getsockopt
                       |
                       |--0.66%--lock_sock_nested
                       |
                       |--0.57%--__might_fault
                       |
                        --0.56%--release_sock

So it saves about 1% of the system call. Unfortunately, we still get
2-3% of overhead due to another socket lock/unlock :-(

Signed-off-by: Stanislav Fomichev <sdf@google.com>
Cc: Martin KaFai Lau <kafai@fb.com>
---
 include/linux/filter.h |  3 +++
 kernel/bpf/cgroup.c    | 40 +++++++++++++++++++++++++++++++++++++++-
 2 files changed, 42 insertions(+), 1 deletion(-)

diff --git a/include/linux/filter.h b/include/linux/filter.h
index 29c27656165b..54a4225f36d8 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -1281,6 +1281,8 @@ struct bpf_sysctl_kern {
 	u64 tmp_reg;
 };
 
+#define BPF_SOCKOPT_KERN_BUF_SIZE	64
+
 struct bpf_sockopt_kern {
 	struct sock	*sk;
 	u8		*optval;
@@ -1289,6 +1291,7 @@ struct bpf_sockopt_kern {
 	s32		optname;
 	s32		optlen;
 	s32		retval;
+	u8		buf[BPF_SOCKOPT_KERN_BUF_SIZE];
 };
 
 int copy_bpf_fprog_from_user(struct sock_fprog *dst, sockptr_t src, int len);
diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
index 6ec088a96302..e6a5c7aec1ec 100644
--- a/kernel/bpf/cgroup.c
+++ b/kernel/bpf/cgroup.c
@@ -16,6 +16,7 @@
 #include <linux/bpf-cgroup.h>
 #include <net/sock.h>
 #include <net/bpf_sk_storage.h>
+#include <net/tcp.h> /* sizeof(struct tcp_zerocopy_receive) */
 
 #include "../cgroup/cgroup-internal.h"
 
@@ -1298,6 +1299,7 @@ static bool __cgroup_bpf_prog_array_is_empty(struct cgroup *cgrp,
 	return empty;
 }
 
+
 static int sockopt_alloc_buf(struct bpf_sockopt_kern *ctx, int max_optlen)
 {
 	if (unlikely(max_optlen < 0))
@@ -1310,6 +1312,18 @@ static int sockopt_alloc_buf(struct bpf_sockopt_kern *ctx, int max_optlen)
 		max_optlen = PAGE_SIZE;
 	}
 
+	if (max_optlen <= sizeof(ctx->buf)) {
+		/* When the optval fits into BPF_SOCKOPT_KERN_BUF_SIZE
+		 * bytes avoid the cost of kzalloc.
+		 */
+		BUILD_BUG_ON(sizeof(struct tcp_zerocopy_receive) >
+			     BPF_SOCKOPT_KERN_BUF_SIZE);
+
+		ctx->optval = ctx->buf;
+		ctx->optval_end = ctx->optval + max_optlen;
+		return max_optlen;
+	}
+
 	ctx->optval = kzalloc(max_optlen, GFP_USER);
 	if (!ctx->optval)
 		return -ENOMEM;
@@ -1321,9 +1335,16 @@ static int sockopt_alloc_buf(struct bpf_sockopt_kern *ctx, int max_optlen)
 
 static void sockopt_free_buf(struct bpf_sockopt_kern *ctx)
 {
+	if (ctx->optval == ctx->buf)
+		return;
 	kfree(ctx->optval);
 }
 
+static bool sockopt_buf_allocated(struct bpf_sockopt_kern *ctx)
+{
+	return ctx->optval != ctx->buf;
+}
+
 int __cgroup_bpf_run_filter_setsockopt(struct sock *sk, int *level,
 				       int *optname, char __user *optval,
 				       int *optlen, char **kernel_optval)
@@ -1390,7 +1411,24 @@ int __cgroup_bpf_run_filter_setsockopt(struct sock *sk, int *level,
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
+			if (!sockopt_buf_allocated(&ctx)) {
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
 
-- 
2.29.2.729.g45daf8777d-goog

