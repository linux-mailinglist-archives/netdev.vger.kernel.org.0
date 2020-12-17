Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D54A2DD5FE
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 18:24:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728953AbgLQRYK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Dec 2020 12:24:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728534AbgLQRYJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Dec 2020 12:24:09 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8F13C06138C
        for <netdev@vger.kernel.org>; Thu, 17 Dec 2020 09:23:28 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id g67so35960770ybb.9
        for <netdev@vger.kernel.org>; Thu, 17 Dec 2020 09:23:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=5AXqLzqpm9b0otAkhPnvqfPQf6drFsRH9jFZigNRKXQ=;
        b=lZ/fk/CwPlc5nPzd3t7hUgwYz3d4MJwPm7sUBSKP0S0AwawmkGdtJCIGJuN4SL8qua
         SoM+NBmj6ZekjClNoMw7XMNnbR1zp12PkE64uxqWnxXooIIBP/rgtaeh+j//BcslFhF2
         MVUNDtPY26UfSg3QoTZgsD7ogL92wZbS3Kp2RUFLWeRl6Ql4oJ/2Vji5JQxAHOKvZIOb
         0+3YlCrMmeeYgqbKwKbVrcAJ2/gRygcqtD0sMX/GqDbQxVK1GZtzUtt2F0YGEomCMC9O
         uA6ic5epWrs8Cla3Ar0KKBN06hfUhl2KsRiheX7k5jvAhDxfApIbbGV5kM/68J9elYOE
         HM7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=5AXqLzqpm9b0otAkhPnvqfPQf6drFsRH9jFZigNRKXQ=;
        b=BfsxOEs69zBMg+HtiwHM5mCpNBFRPDHzlEZWR5WEaXbJrg4uAFLvCLrY0a3nEWHXTB
         z2C0IgiITFwcmyX7CPrEtqSclA1IyzJGJYoTiMMxIoXFA7duzpAnlb6A764hPnu6OEID
         u4k73NaIXJiaO0/qA7ZdPGBlBayE/gBcquIWodjlkS0yqHCOt0qr/3eZmCH0tTKiZJSu
         To3hjSLm3rEEXDGQoTKVSlOY0lOaHwilYc12jhvsA//2MHrRkInsbK9aNqKisJ3CYclx
         3Hc823HphMS63L7Wd/Tn1qZwdgNWj2haF3fyDHHeb3iPPvBNbqvgeEiLx8mTPz9iKJvs
         mvaw==
X-Gm-Message-State: AOAM531XDeFI0gDKzvGSru66KsY9DPvCh/bPGFavOklqh31FDV0VVB5p
        W4uddWnN+Zgk+vrJaHTwBQ1WAVgBtFtIIsaVAxMuCOlyEMohRF8tIWbL3ccz9vxp82lCPYnoD10
        1m+ynXtoog+fSf30ANxpJeqACOPnOi6VuzwTw7MC6q8fwgRRbWDBMZA==
X-Google-Smtp-Source: ABdhPJyoLpFN/PRHo19zag7xh9oD54/kabFFZscCXlRevN+VHG1SbihLZxpeOaYlhkEK3k+vdpLKyds=
Sender: "sdf via sendgmr" <sdf@sdf2.svl.corp.google.com>
X-Received: from sdf2.svl.corp.google.com ([2620:15c:2c4:1:7220:84ff:fe09:7732])
 (user=sdf job=sendgmr) by 2002:a25:680c:: with SMTP id d12mr263189ybc.336.1608225808125;
 Thu, 17 Dec 2020 09:23:28 -0800 (PST)
Date:   Thu, 17 Dec 2020 09:23:23 -0800
In-Reply-To: <20201217172324.2121488-1-sdf@google.com>
Message-Id: <20201217172324.2121488-2-sdf@google.com>
Mime-Version: 1.0
References: <20201217172324.2121488-1-sdf@google.com>
X-Mailer: git-send-email 2.29.2.729.g45daf8777d-goog
Subject: [PATCH bpf-next 1/2] bpf: try to avoid kzalloc in cgroup/{s,g}etsockopt
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>
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
currently, with some planned extension to 64 + some headroom
for the future).

It seems natural to do the same for setsockopt, but it's a bit more
involved when the BPF program modifies the data (where we have to
kmalloc). The assumption is that for the majority of setsockopt
calls (which are doing pure BPF options or apply policy) this
will bring some benefit as well.

Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 include/linux/filter.h |  3 +++
 kernel/bpf/cgroup.c    | 41 +++++++++++++++++++++++++++++++++++++++--
 2 files changed, 42 insertions(+), 2 deletions(-)

diff --git a/include/linux/filter.h b/include/linux/filter.h
index 29c27656165b..362eb0d7af5d 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -1281,6 +1281,8 @@ struct bpf_sysctl_kern {
 	u64 tmp_reg;
 };
 
+#define BPF_SOCKOPT_KERN_BUF_SIZE	128
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
index 6ec088a96302..0cb5d4376844 100644
--- a/kernel/bpf/cgroup.c
+++ b/kernel/bpf/cgroup.c
@@ -1310,6 +1310,15 @@ static int sockopt_alloc_buf(struct bpf_sockopt_kern *ctx, int max_optlen)
 		max_optlen = PAGE_SIZE;
 	}
 
+	if (max_optlen <= sizeof(ctx->buf)) {
+		/* When the optval fits into BPF_SOCKOPT_KERN_BUF_SIZE
+		 * bytes avoid the cost of kzalloc.
+		 */
+		ctx->optval = ctx->buf;
+		ctx->optval_end = ctx->optval + max_optlen;
+		return max_optlen;
+	}
+
 	ctx->optval = kzalloc(max_optlen, GFP_USER);
 	if (!ctx->optval)
 		return -ENOMEM;
@@ -1321,9 +1330,31 @@ static int sockopt_alloc_buf(struct bpf_sockopt_kern *ctx, int max_optlen)
 
 static void sockopt_free_buf(struct bpf_sockopt_kern *ctx)
 {
+	if (ctx->optval == ctx->buf)
+		return;
 	kfree(ctx->optval);
 }
 
+static void *sockopt_export_buf(struct bpf_sockopt_kern *ctx)
+{
+	void *p;
+
+	if (ctx->optval != ctx->buf)
+		return ctx->optval;
+
+	/* We've used bpf_sockopt_kern->buf as an intermediary storage,
+	 * but the BPF program indicates that we need to pass this
+	 * data to the kernel setsockopt handler. No way to export
+	 * on-stack buf, have to allocate a new buffer. The caller
+	 * is responsible for the kfree().
+	 */
+	p = kzalloc(ctx->optlen, GFP_USER);
+	if (!p)
+		return ERR_PTR(-ENOMEM);
+	memcpy(p, ctx->optval, ctx->optlen);
+	return p;
+}
+
 int __cgroup_bpf_run_filter_setsockopt(struct sock *sk, int *level,
 				       int *optname, char __user *optval,
 				       int *optlen, char **kernel_optval)
@@ -1389,8 +1420,14 @@ int __cgroup_bpf_run_filter_setsockopt(struct sock *sk, int *level,
 		 * use original userspace data.
 		 */
 		if (ctx.optlen != 0) {
-			*optlen = ctx.optlen;
-			*kernel_optval = ctx.optval;
+			void *buf = sockopt_export_buf(&ctx);
+
+			if (!IS_ERR(buf)) {
+				*optlen = ctx.optlen;
+				*kernel_optval = buf;
+			} else {
+				ret = PTR_ERR(buf);
+			}
 		}
 	}
 
-- 
2.29.2.729.g45daf8777d-goog

