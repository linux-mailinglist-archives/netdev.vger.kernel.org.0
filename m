Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF24F327BE1
	for <lists+netdev@lfdr.de>; Mon,  1 Mar 2021 11:22:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233405AbhCAKVP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Mar 2021 05:21:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233999AbhCAKUW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Mar 2021 05:20:22 -0500
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DB23C06178A
        for <netdev@vger.kernel.org>; Mon,  1 Mar 2021 02:19:28 -0800 (PST)
Received: by mail-wr1-x430.google.com with SMTP id u14so15498694wri.3
        for <netdev@vger.kernel.org>; Mon, 01 Mar 2021 02:19:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OnsCq72NIqxbQo7TReAl86Zu/9YUEW7JMMbum4NscOE=;
        b=mjxnKXBBO1XFPAlVuDfxGyBtb3BInnRlYp8ytY10qggxzzouMFFV2rKWRWaGvylP0x
         oI7iw6KJiKQzXPruu/EWzhJHehgpH6LUupxGlzHafKKbKKDsdaqHCfAGsTP/vwqbwHCQ
         5macAMnaStOske7A78Y3pbaeH3lzrM6pyq9X0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OnsCq72NIqxbQo7TReAl86Zu/9YUEW7JMMbum4NscOE=;
        b=GjBNUrB44ORzfqLK/5Yec7gf3WPnoR2jXVbgXeOq0hzjyBO9IQ69UTpnGxiVI/Jg9P
         HqU1XBJ4lrjiJeTrrDjCb2mF2ckCsJExqZf2SO+l7c9JhcKJXMGmmQhKiN97sryPOqsX
         C2CNo+mHEY3+MoNqQDxlEqm0REjxBZ+lKcZbTeTmCJi5E6B2HbfiCHjjMWLpnPKAVe25
         aXTV+lGB72Fey3MAespOKAXmAjaxnE3EhCH6E5eY0dtUwGF6Y13jkr1U37e7iqU2HbvO
         aWNcSMEvaRlhk1/AHEnO4H2JDn5fZKAezpA9+Lg2FD1rSUorJLVAMFXAPUSv0sWxJE3x
         s0Ig==
X-Gm-Message-State: AOAM531B9J4r4O4PEH4lhoC29oCnSNkGY7wKzovOM1dGaPmnZ0fmvdlq
        HLi+Mxqr71MIhnUIfyITIrTSxg==
X-Google-Smtp-Source: ABdhPJxh9kXQCKrP11qiDG/0TFc1wu5U2rxKydjfwo/D7jVSTgionMBTeGSAsdyd5LlT09DykPZWjA==
X-Received: by 2002:a5d:6809:: with SMTP id w9mr15141228wru.376.1614593967182;
        Mon, 01 Mar 2021 02:19:27 -0800 (PST)
Received: from localhost.localdomain (2.b.a.d.8.4.b.a.9.e.4.2.1.8.0.5.f.f.6.2.a.5.a.7.0.b.8.0.1.0.0.2.ip6.arpa. [2001:8b0:7a5a:26ff:5081:24e9:ab48:dab2])
        by smtp.gmail.com with ESMTPSA id a198sm14134600wmd.11.2021.03.01.02.19.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Mar 2021 02:19:26 -0800 (PST)
From:   Lorenz Bauer <lmb@cloudflare.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org
Cc:     kernel-team@cloudflare.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Lorenz Bauer <lmb@cloudflare.com>
Subject: [PATCH bpf-next v3 2/5] bpf: add PROG_TEST_RUN support for sk_lookup programs
Date:   Mon,  1 Mar 2021 10:18:56 +0000
Message-Id: <20210301101859.46045-3-lmb@cloudflare.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210301101859.46045-1-lmb@cloudflare.com>
References: <20210301101859.46045-1-lmb@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Allow to pass sk_lookup programs to PROG_TEST_RUN. User space
provides the full bpf_sk_lookup struct as context. Since the
context includes a socket pointer that can't be exposed
to user space we define that PROG_TEST_RUN returns the cookie
of the selected socket or zero in place of the socket pointer.

We don't support testing programs that select a reuseport socket,
since this would mean running another (unrelated) BPF program
from the sk_lookup test handler.

Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
---
 include/linux/bpf.h            |  10 ++++
 include/uapi/linux/bpf.h       |   5 +-
 net/bpf/test_run.c             | 105 +++++++++++++++++++++++++++++++++
 net/core/filter.c              |   1 +
 tools/include/uapi/linux/bpf.h |   5 +-
 5 files changed, 124 insertions(+), 2 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 4c730863fa77..c931bc97019d 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1491,6 +1491,9 @@ int bpf_prog_test_run_flow_dissector(struct bpf_prog *prog,
 int bpf_prog_test_run_raw_tp(struct bpf_prog *prog,
 			     const union bpf_attr *kattr,
 			     union bpf_attr __user *uattr);
+int bpf_prog_test_run_sk_lookup(struct bpf_prog *prog,
+				const union bpf_attr *kattr,
+				union bpf_attr __user *uattr);
 bool btf_ctx_access(int off, int size, enum bpf_access_type type,
 		    const struct bpf_prog *prog,
 		    struct bpf_insn_access_aux *info);
@@ -1692,6 +1695,13 @@ static inline int bpf_prog_test_run_flow_dissector(struct bpf_prog *prog,
 	return -ENOTSUPP;
 }
 
+static inline int bpf_prog_test_run_sk_lookup(struct bpf_prog *prog,
+					      const union bpf_attr *kattr,
+					      union bpf_attr __user *uattr)
+{
+	return -ENOTSUPP;
+}
+
 static inline void bpf_map_put(struct bpf_map *map)
 {
 }
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index b89af20cfa19..99b39ec5ad44 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -5243,7 +5243,10 @@ struct bpf_pidns_info {
 
 /* User accessible data for SK_LOOKUP programs. Add new fields at the end. */
 struct bpf_sk_lookup {
-	__bpf_md_ptr(struct bpf_sock *, sk); /* Selected socket */
+	union {
+		__bpf_md_ptr(struct bpf_sock *, sk); /* Selected socket */
+		__u64 cookie; /* Non-zero if socket was selected in PROG_TEST_RUN */
+	};
 
 	__u32 family;		/* Protocol family (AF_INET, AF_INET6) */
 	__u32 protocol;		/* IP protocol (IPPROTO_TCP, IPPROTO_UDP) */
diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
index ac8ee36d60cc..0ec6b920484a 100644
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -10,8 +10,10 @@
 #include <net/bpf_sk_storage.h>
 #include <net/sock.h>
 #include <net/tcp.h>
+#include <net/net_namespace.h>
 #include <linux/error-injection.h>
 #include <linux/smp.h>
+#include <linux/sock_diag.h>
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/bpf_test_run.h>
@@ -781,3 +783,106 @@ int bpf_prog_test_run_flow_dissector(struct bpf_prog *prog,
 	kfree(data);
 	return ret;
 }
+
+int bpf_prog_test_run_sk_lookup(struct bpf_prog *prog, const union bpf_attr *kattr,
+				union bpf_attr __user *uattr)
+{
+	struct test_timer t = { NO_PREEMPT };
+	struct bpf_prog_array *progs = NULL;
+	struct bpf_sk_lookup_kern ctx = {};
+	u32 repeat = kattr->test.repeat;
+	struct bpf_sk_lookup *user_ctx;
+	u32 retval, duration;
+	int ret = -EINVAL;
+
+	if (prog->type != BPF_PROG_TYPE_SK_LOOKUP)
+		return -EINVAL;
+
+	if (kattr->test.flags || kattr->test.cpu)
+		return -EINVAL;
+
+	if (kattr->test.data_in || kattr->test.data_size_in || kattr->test.data_out ||
+	    kattr->test.data_size_out)
+		return -EINVAL;
+
+	if (!repeat)
+		repeat = 1;
+
+	user_ctx = bpf_ctx_init(kattr, sizeof(*user_ctx));
+	if (IS_ERR(user_ctx))
+		return PTR_ERR(user_ctx);
+
+	if (!user_ctx)
+		return -EINVAL;
+
+	if (user_ctx->sk)
+		goto out;
+
+	if (!range_is_zero(user_ctx, offsetofend(typeof(*user_ctx), local_port), sizeof(*user_ctx)))
+		goto out;
+
+	if (user_ctx->local_port > U16_MAX || user_ctx->remote_port > U16_MAX) {
+		ret = -ERANGE;
+		goto out;
+	}
+
+	ctx.family = (u16)user_ctx->family;
+	ctx.protocol = (u16)user_ctx->protocol;
+	ctx.dport = (u16)user_ctx->local_port;
+	ctx.sport = (__force __be16)user_ctx->remote_port;
+
+	switch (ctx.family) {
+	case AF_INET:
+		ctx.v4.daddr = (__force __be32)user_ctx->local_ip4;
+		ctx.v4.saddr = (__force __be32)user_ctx->remote_ip4;
+		break;
+
+#if IS_ENABLED(CONFIG_IPV6)
+	case AF_INET6:
+		ctx.v6.daddr = (struct in6_addr *)user_ctx->local_ip6;
+		ctx.v6.saddr = (struct in6_addr *)user_ctx->remote_ip6;
+		break;
+#endif
+
+	default:
+		ret = -EAFNOSUPPORT;
+		goto out;
+	}
+
+	progs = bpf_prog_array_alloc(1, GFP_KERNEL);
+	if (!progs) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	progs->items[0].prog = prog;
+
+	t_enter(&t);
+	do {
+		ctx.selected_sk = NULL;
+		retval = BPF_PROG_SK_LOOKUP_RUN_ARRAY(progs, ctx, BPF_PROG_RUN);
+	} while (t_continue(&t, repeat, &ret, &duration));
+	t_leave(&t);
+
+	if (ret < 0)
+		goto out;
+
+	user_ctx->cookie = 0;
+	if (ctx.selected_sk) {
+		if (ctx.selected_sk->sk_reuseport && !ctx.no_reuseport) {
+			ret = -EOPNOTSUPP;
+			goto out;
+		}
+
+		user_ctx->cookie = sock_gen_cookie(ctx.selected_sk);
+	}
+
+	ret = bpf_test_finish(kattr, uattr, NULL, 0, retval, duration);
+	if (!ret)
+		ret = bpf_ctx_finish(kattr, uattr, user_ctx, sizeof(*user_ctx));
+
+out:
+	bpf_prog_array_free(progs);
+	kfree(user_ctx);
+	return ret;
+}
diff --git a/net/core/filter.c b/net/core/filter.c
index 13bcf248ee7b..a526db494c62 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -10457,6 +10457,7 @@ static u32 sk_lookup_convert_ctx_access(enum bpf_access_type type,
 }
 
 const struct bpf_prog_ops sk_lookup_prog_ops = {
+	.test_run = bpf_prog_test_run_sk_lookup,
 };
 
 const struct bpf_verifier_ops sk_lookup_verifier_ops = {
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index b89af20cfa19..99b39ec5ad44 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -5243,7 +5243,10 @@ struct bpf_pidns_info {
 
 /* User accessible data for SK_LOOKUP programs. Add new fields at the end. */
 struct bpf_sk_lookup {
-	__bpf_md_ptr(struct bpf_sock *, sk); /* Selected socket */
+	union {
+		__bpf_md_ptr(struct bpf_sock *, sk); /* Selected socket */
+		__u64 cookie; /* Non-zero if socket was selected in PROG_TEST_RUN */
+	};
 
 	__u32 family;		/* Protocol family (AF_INET, AF_INET6) */
 	__u32 protocol;		/* IP protocol (IPPROTO_TCP, IPPROTO_UDP) */
-- 
2.27.0

