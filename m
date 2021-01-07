Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F06252ED6DC
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 19:44:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729198AbhAGSoC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 13:44:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729180AbhAGSoB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jan 2021 13:44:01 -0500
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 576FEC0612FA
        for <netdev@vger.kernel.org>; Thu,  7 Jan 2021 10:43:10 -0800 (PST)
Received: by mail-qk1-x74a.google.com with SMTP id u9so6958348qkk.5
        for <netdev@vger.kernel.org>; Thu, 07 Jan 2021 10:43:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=KWMiW7hSaREvCv0bJIcH7tpPEqH7tt36pLiggBhx4JI=;
        b=d1tqgJWUWPatMz5vlCPwklkeDD8yJjFQB3UXMDKdxw5qv7v7DjsEUpZLUiZHxNGPZV
         dSt59a1rGDIQrL5bgHtSW8bjTxcTXV+S+i5smwpUBwzCtDoi6spo/MpSXqrLFk5nVyOM
         yPlDm+JM6gCvhLnYkHjowjWDlSwTx9jf8IooYk3YcaTNdIJwvabz0MTOZs+8Bk/+pAcU
         y/bNottlKOqlX9yq7tzRGORYdl/WQLXiESVy+2cpgGH5ZfgF3bWaY4RqFNxYYqJ8e1G5
         FnC1sf4iQeN0pCwrpjzw40E3GXnjJoetGClDfF5i3ba/m4ZjBDtHMOeI3Rp4YFJlpA7s
         irlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=KWMiW7hSaREvCv0bJIcH7tpPEqH7tt36pLiggBhx4JI=;
        b=h2T3tIlGXWCfkLsnATCNlK8YSKUN5hx065U51RWMnNlFEg2fM9x062Xs4JO0iOWjuR
         HZTtBFfC3EZ7ka9vWadwpTvSSRbTZx/Vov3nSF9jCZdwoTOx/zFaT9fGTb/7psx9x+rm
         9xV9n/trfiRLAWdWkrW4buD3ehKvmWCKRH18+BM3DWoprTdUtknWTxjDaz/3D5GIF9Ir
         RpLNmqCsD8S53AhjIhrbq2BMpm6zdNr3ds97GORLYWXxZ431FmcqdwrVo55r0zEo6reS
         WnT5SBPL9YDK7GXNEWReecOjeNzUdljunB/jBhuneyCuvmPvzZhrqski21hBImkMk7bZ
         +Szg==
X-Gm-Message-State: AOAM533QM4yieHOhpRJcP7Yxx/fNrBsv8/+ANCb92HETUmlzL8OM+Urf
        WhqcRsazLOuiwW+0y5W9xZHYNN+T5sFbYaLhw9rTpeiRy4D9o/aCVdvgQ1N0KoMh0zWmgKWIZCT
        I7qSICgW8ZUTfdJZ3Xl8cpTx/mG67biIcV7yi+UCuI7A4UHr8uWN9Bw==
X-Google-Smtp-Source: ABdhPJw7nakW7rdcBkI0wzchA8RVNzP/E/fOgXQZLqZqkqy3FIEGoveZrfhRUp1Zjhgg8YPfXAsRBC8=
Sender: "sdf via sendgmr" <sdf@sdf2.svl.corp.google.com>
X-Received: from sdf2.svl.corp.google.com ([2620:15c:2c4:1:7220:84ff:fe09:7732])
 (user=sdf job=sendgmr) by 2002:a0c:b797:: with SMTP id l23mr168892qve.42.1610044989297;
 Thu, 07 Jan 2021 10:43:09 -0800 (PST)
Date:   Thu,  7 Jan 2021 10:43:03 -0800
In-Reply-To: <20210107184305.444635-1-sdf@google.com>
Message-Id: <20210107184305.444635-2-sdf@google.com>
Mime-Version: 1.0
References: <20210107184305.444635-1-sdf@google.com>
X-Mailer: git-send-email 2.29.2.729.g45daf8777d-goog
Subject: [PATCH bpf-next v4 1/3] bpf: try to avoid kzalloc in cgroup/{s,g}etsockopt
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
     3.38%     0.07%  tcp_mmap  [kernel.kallsyms]  [k] __cgroup_bpf_run_filter_getsockopt
            |
             --3.30%--__cgroup_bpf_run_filter_getsockopt
                       |
                        --0.81%--__kmalloc

With the patch applied:
     1.87%     0.06%  tcp_mmap  [kernel.kallsyms]  [k] __cgroup_bpf_run_filter_getsockopt

So it saves about 1% of the system call. Unfortunately, we still get
2% of overhead due to another socket lock/unlock :-(

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

