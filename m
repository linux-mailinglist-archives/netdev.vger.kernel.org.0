Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A7A832C405
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 01:52:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354348AbhCDAKO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Mar 2021 19:10:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1843040AbhCCKYs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Mar 2021 05:24:48 -0500
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 739B1C08ED8C
        for <netdev@vger.kernel.org>; Wed,  3 Mar 2021 02:18:29 -0800 (PST)
Received: by mail-wm1-x32f.google.com with SMTP id w7so4677058wmb.5
        for <netdev@vger.kernel.org>; Wed, 03 Mar 2021 02:18:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3L8Af0NsHi6NbZmwX1bPczjtIU1FRnqX30og/GJzPuU=;
        b=lsB/PIqOGefbXTCakX5fRINXYvHRNLj03O20UKM8dvbetpnagjYmM2sCH+TMjckDCB
         YvjZxmkyhHOMcR+RTAdzlPj/NWDHrsmrIosn+u8Gq/Da2owPyWFS3dG7PILZ3n795Pz8
         9rHWFbYyAoJJDjKmQnwnRUm9Db58+/3gD4peo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3L8Af0NsHi6NbZmwX1bPczjtIU1FRnqX30og/GJzPuU=;
        b=oq3rfpwDJUEmrLYol3jyccCGwrDz+CAAPAxDssSh0pNVe6F6vQI5Dps5YxDXEYSWl9
         loo7tIpX6Pv3jKlONWXCd/y1ejSnzbn1fVUiMPgY3+kmFWqyMDDzKcRqZ8RMRDjSPFzm
         /+UVJ0GYHwMYq+zYAMmhiHwWWDhGoLJI2D5DEQZfY6RIShTGidlj+zQ1FdD2cTz4U6EN
         kt47V6Gkvhy/fYPJsC97NI2YBcgNuvUTE00h3IFGXgoKP/do42VUmHxG11AJTGEXegTe
         Nbt7VbVRK4ZYbP8a4fGh9vsRDjnCAh0Xd8S+l7bJg5q/0Spqx6qAhcDwyeumWua4fNdI
         9G+A==
X-Gm-Message-State: AOAM532AcBvQnBuBzM8bY4NJu0xjN/PJRCFtzQsgjvcj+6zDZQHOwqYz
        q99CkGU5y58epkZ68WjMhQs3hw==
X-Google-Smtp-Source: ABdhPJyjYzcvjZQWeYQ1SHYVETcfCGY4Pb445OMt0vS5AZwSluI471jFYqPLsIdbaKpRVC0sKEED3w==
X-Received: by 2002:a7b:c308:: with SMTP id k8mr8317689wmj.54.1614766708116;
        Wed, 03 Mar 2021 02:18:28 -0800 (PST)
Received: from localhost.localdomain (c.a.8.8.c.1.2.8.8.7.0.2.6.c.a.1.f.f.6.2.a.5.a.7.0.b.8.0.1.0.0.2.ip6.arpa. [2001:8b0:7a5a:26ff:1ac6:2078:821c:88ac])
        by smtp.gmail.com with ESMTPSA id r26sm1710761wmn.28.2021.03.03.02.18.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Mar 2021 02:18:27 -0800 (PST)
From:   Lorenz Bauer <lmb@cloudflare.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org
Cc:     kernel-team@cloudflare.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Lorenz Bauer <lmb@cloudflare.com>
Subject: [PATCH bpf-next v4 2/5] bpf: add PROG_TEST_RUN support for sk_lookup programs
Date:   Wed,  3 Mar 2021 10:18:13 +0000
Message-Id: <20210303101816.36774-3-lmb@cloudflare.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210303101816.36774-1-lmb@cloudflare.com>
References: <20210303101816.36774-1-lmb@cloudflare.com>
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
index eb3c78cd4d7c..0abdd67f44b1 100644
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
+	struct bpf_test_timer t = { NO_PREEMPT };
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
+	bpf_test_timer_enter(&t);
+	do {
+		ctx.selected_sk = NULL;
+		retval = BPF_PROG_SK_LOOKUP_RUN_ARRAY(progs, ctx, BPF_PROG_RUN);
+	} while (bpf_test_timer_continue(&t, repeat, &ret, &duration));
+	bpf_test_timer_leave(&t);
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

