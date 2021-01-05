Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCCF32EB4FE
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 22:44:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731550AbhAEVok (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 16:44:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731530AbhAEVof (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jan 2021 16:44:35 -0500
Received: from mail-qt1-x849.google.com (mail-qt1-x849.google.com [IPv6:2607:f8b0:4864:20::849])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B6F5C061796
        for <netdev@vger.kernel.org>; Tue,  5 Jan 2021 13:43:55 -0800 (PST)
Received: by mail-qt1-x849.google.com with SMTP id i13so757404qtp.10
        for <netdev@vger.kernel.org>; Tue, 05 Jan 2021 13:43:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=YcgFM9JxVnn2FUtJ3TYvGI7wy8QDQYxDD4JBRxekVf4=;
        b=fNU9buwrGkptTrs9Eor3o2JWacGALnWypiJ7IKHdeO7Kh1Fzds7Ya1Nsza/p1QBntk
         vOpUjBVtIAjjpnYNF0zGOPJCqEWIzWQhKlqCZ/9o7GLltb5qBHZWZN5k+mIp8V/9h8Qh
         2NbCRmVu9ZY9MLNZw28O+wkDdsX8JYkIk9YtxsEn3N52w4B6FyvcUoXi95RHHf9iQ0J7
         dgiOeZ3FH5STjROrGPf60z+y1p/0YZRCxg53FjLJEemtU2LjXAzZDiznysEuLQ3GBFpV
         KB7RL0o93nrOPSu+YsukgMbBqkwgR/ZwvOdISWvDUv8bqqOY8jsmC6B1ZSWW2uAqJRhp
         kD8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=YcgFM9JxVnn2FUtJ3TYvGI7wy8QDQYxDD4JBRxekVf4=;
        b=fTaYn0JMfvyYzweEtuqdi+DaSbnP/jtD1tOQOrJghwub4qZmNeLtWL2f6JpoI/stfC
         aSwnehdtc8S6A4KzlqSDgpFw5wK9vmXfTJpCPAArFmf9NKtDfpPMWsMvIOqh9ktlfU58
         SEfhdW2e8aQ+UnZv63dNbov2TG1wwu43TYFbcGVYg5V5BI27bSu80Ac68XDJ4sd5MipX
         ZZ07wG8OTRD/8JFaka8evvI9cTjcMD6Nnij1Fntf4RKJlwDh/nGCBubuxEbio40yVNuT
         +gTwxkft/TMSTjr+9w/vYrp0rmu8hl/xROy9nkz/wWjyFJbSm6ViO2ZggBGxXWx/zC2g
         U68A==
X-Gm-Message-State: AOAM533CR30ANRdJKkC8t7+MTxJuvD5wTEUJqdAAchy4v8f/4BkHei/3
        zoFuYVQgcpKiAHCOkSLyBB9P54kQCF4BRuUOeWEtLJADXLes0Cd68ckpWehjJJsQWYAs42BNb1y
        WdLRlwWsk+BfvjTOprn0Ei6qqA2GQqx8K43DEzeJOBZi3ChD68RPxfA==
X-Google-Smtp-Source: ABdhPJwmv/xWNxYZh7qM9S2TCI60aaUgcrLbCpA7f8iiDNBefzN63EZQfvzXcMoyG4BR4H2zjUlw+2g=
Sender: "sdf via sendgmr" <sdf@sdf2.svl.corp.google.com>
X-Received: from sdf2.svl.corp.google.com ([2620:15c:2c4:1:7220:84ff:fe09:7732])
 (user=sdf job=sendgmr) by 2002:a0c:fcc5:: with SMTP id i5mr1365863qvq.48.1609883034506;
 Tue, 05 Jan 2021 13:43:54 -0800 (PST)
Date:   Tue,  5 Jan 2021 13:43:48 -0800
In-Reply-To: <20210105214350.138053-1-sdf@google.com>
Message-Id: <20210105214350.138053-2-sdf@google.com>
Mime-Version: 1.0
References: <20210105214350.138053-1-sdf@google.com>
X-Mailer: git-send-email 2.29.2.729.g45daf8777d-goog
Subject: [PATCH bpf-next v3 1/3] bpf: try to avoid kzalloc in cgroup/{s,g}etsockopt
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
Cc: Song Liu <songliubraving@fb.com>
---
 include/linux/filter.h |  3 +++
 kernel/bpf/cgroup.c    | 43 +++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 45 insertions(+), 1 deletion(-)

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
index 6ec088a96302..ca6fa599a25d 100644
--- a/kernel/bpf/cgroup.c
+++ b/kernel/bpf/cgroup.c
@@ -16,6 +16,7 @@
 #include <linux/bpf-cgroup.h>
 #include <net/sock.h>
 #include <net/bpf_sk_storage.h>
+#include <uapi/linux/tcp.h> /* sizeof(struct tcp_zerocopy_receive) */
 
 #include "../cgroup/cgroup-internal.h"
 
@@ -1310,6 +1311,22 @@ static int sockopt_alloc_buf(struct bpf_sockopt_kern *ctx, int max_optlen)
 		max_optlen = PAGE_SIZE;
 	}
 
+	if (max_optlen <= sizeof(ctx->buf)) {
+		/* When the optval fits into BPF_SOCKOPT_KERN_BUF_SIZE
+		 * bytes avoid the cost of kzalloc.
+		 *
+		 * In order to remove extra allocations from the TCP
+		 * fast zero-copy path ensure that buffer covers
+		 * the size of struct tcp_zerocopy_receive.
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
@@ -1321,9 +1338,16 @@ static int sockopt_alloc_buf(struct bpf_sockopt_kern *ctx, int max_optlen)
 
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
@@ -1390,7 +1414,24 @@ int __cgroup_bpf_run_filter_setsockopt(struct sock *sk, int *level,
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

