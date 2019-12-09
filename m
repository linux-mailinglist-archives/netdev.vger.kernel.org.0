Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38B7D116E40
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 14:55:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727709AbfLINzr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 08:55:47 -0500
Received: from mail-pj1-f65.google.com ([209.85.216.65]:36790 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727200AbfLINzr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Dec 2019 08:55:47 -0500
Received: by mail-pj1-f65.google.com with SMTP id n96so5946735pjc.3;
        Mon, 09 Dec 2019 05:55:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZVDoaxgpZVrkQoQw42pm4MJ8qmzxJwyzH6aUv/MBIjs=;
        b=G83u+WMABmXGCn6LnCSCn4pOHxrx0QLNVM50LfQxJLOB0gfkfJLHf20EEaTMpLKc3m
         8i/Ns3F9G/VcwnktXJGYyYftRxHqP29/Pa3Bh+hp837c+cYyeMMloX41gh7m7iZ4l9gx
         Lyk9BiHZdgAwFisv622RVpCGs8lMjs2Lg6pgL4n2P4dhT0HM5s1/GeOpkBY4QNmFuTT7
         FSKLrXXgPm2jZ6mlXa2WXiWQ0fl429xXghCFj5xat7EzuQBNqU6c07OEmW2KqQhbMquX
         tt+cy5MlHkIjHwiyLS+VxHVZLEP3CnovjPJ06/ufy/N1T3HEMHEt4QU65ncOyARA0C5M
         DK5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZVDoaxgpZVrkQoQw42pm4MJ8qmzxJwyzH6aUv/MBIjs=;
        b=K7B0qzkAv5FwKLY7hri/7awVAQx1ZFGmTFYBkK4mNCPDlhdFQNMKNyk+swBmsaWHAX
         X5t+SPj5Tpc+DQOYBlsIr2c7DMP3L+R/y5vjYQkg02JaAYM1YzwzsAwGYcpRqvUQPxQa
         HvW86h9mhBuzWvqW4/c1zqlrh3/812+YVCEe/mKcYV6y0LBK8zWt8o2arraRPMzO5Pbe
         9sMx8GHo/DrGH5jffwJaJ/HMIRguvY7ShqZZ9am3jkjT3P/S9rng/ryQH0514g39yQ0q
         YbHTudaCZzYG42Yl8TnEGLX+8TkQ8WP63hJNFh1J3hN/1pX3nFWYurM+cUNGDQ1YyHEt
         i3uA==
X-Gm-Message-State: APjAAAUPljDhBol1+p6rN3+5ONV2cjGASrevcJ/Q8lHYNlkEMbra7aLX
        yfTVe+V7mx5QJH/Go9CuaFgLJTLQeT9VpA==
X-Google-Smtp-Source: APXvYqxAsNz0yXnSNoBs/HfWFdzplUM3Btl0PRkxeL7g5cX5PS/bwi92JTgdg26DT7Jc7Leuy8pKXA==
X-Received: by 2002:a17:90b:30c4:: with SMTP id hi4mr32828114pjb.62.1575899745476;
        Mon, 09 Dec 2019 05:55:45 -0800 (PST)
Received: from btopel-mobl.ger.intel.com (fmdmzpr03-ext.fm.intel.com. [192.55.54.38])
        by smtp.gmail.com with ESMTPSA id h26sm19543403pfr.9.2019.12.09.05.55.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Dec 2019 05:55:44 -0800 (PST)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        bpf@vger.kernel.org, magnus.karlsson@gmail.com,
        magnus.karlsson@intel.com, jonathan.lemon@gmail.com,
        ecree@solarflare.com, thoiland@redhat.com,
        andrii.nakryiko@gmail.com
Subject: [PATCH bpf-next v3 3/6] bpf, xdp: start using the BPF dispatcher for XDP
Date:   Mon,  9 Dec 2019 14:55:19 +0100
Message-Id: <20191209135522.16576-4-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191209135522.16576-1-bjorn.topel@gmail.com>
References: <20191209135522.16576-1-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Björn Töpel <bjorn.topel@intel.com>

This commit adds the BPF dispatcher to the XDP control- and
fast-path. The dispatcher is updated in the dev_xdp_install()
function, and used when an XDP program is run via bpf_prog_run_xdp().

Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 include/linux/bpf.h    |  7 ++++++
 include/linux/filter.h | 56 ++++++++++++++++++++++++++++++------------
 kernel/bpf/syscall.c   | 26 ++++++++++++++------
 net/core/dev.c         | 19 +++++++++++++-
 net/core/filter.c      | 22 +++++++++++++++++
 5 files changed, 105 insertions(+), 25 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 5d744828b399..dbc8fa1ca3c3 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -941,6 +941,8 @@ int btf_distill_func_proto(struct bpf_verifier_log *log,
 
 int btf_check_func_arg_match(struct bpf_verifier_env *env, int subprog);
 
+struct bpf_prog *bpf_prog_by_id(u32 id);
+
 #else /* !CONFIG_BPF_SYSCALL */
 static inline struct bpf_prog *bpf_prog_get(u32 ufd)
 {
@@ -1072,6 +1074,11 @@ static inline int bpf_prog_test_run_flow_dissector(struct bpf_prog *prog,
 static inline void bpf_map_put(struct bpf_map *map)
 {
 }
+
+static inline struct bpf_prog *bpf_prog_by_id(u32 id)
+{
+	return ERR_PTR(-ENOTSUPP);
+}
 #endif /* CONFIG_BPF_SYSCALL */
 
 static inline struct bpf_prog *bpf_prog_get_type(u32 ufd,
diff --git a/include/linux/filter.h b/include/linux/filter.h
index a141cb07e76a..7a4cdec572d8 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -557,25 +557,36 @@ struct sk_filter {
 	struct bpf_prog	*prog;
 };
 
+static __always_inline unsigned int bpf_dispatcher_nop(
+	const void *ctx,
+	const struct bpf_insn *insnsi,
+	unsigned int (*bpf_func)(const void *,
+				 const struct bpf_insn *))
+{
+	return bpf_func(ctx, insnsi);
+}
+
 DECLARE_STATIC_KEY_FALSE(bpf_stats_enabled_key);
 
-#define BPF_PROG_RUN(prog, ctx)	({				\
-	u32 ret;						\
-	cant_sleep();						\
-	if (static_branch_unlikely(&bpf_stats_enabled_key)) {	\
-		struct bpf_prog_stats *stats;			\
-		u64 start = sched_clock();			\
-		ret = (*(prog)->bpf_func)(ctx, (prog)->insnsi);	\
-		stats = this_cpu_ptr(prog->aux->stats);		\
-		u64_stats_update_begin(&stats->syncp);		\
-		stats->cnt++;					\
-		stats->nsecs += sched_clock() - start;		\
-		u64_stats_update_end(&stats->syncp);		\
-	} else {						\
-		ret = (*(prog)->bpf_func)(ctx, (prog)->insnsi);	\
-	}							\
+#define __BPF_PROG_RUN(prog, ctx, disp)	({				\
+	u32 ret;							\
+	cant_sleep();							\
+	if (static_branch_unlikely(&bpf_stats_enabled_key)) {		\
+		struct bpf_prog_stats *stats;				\
+		u64 start = sched_clock();				\
+		ret = disp(ctx, (prog)->insnsi, (prog)->bpf_func);	\
+		stats = this_cpu_ptr(prog->aux->stats);			\
+		u64_stats_update_begin(&stats->syncp);			\
+		stats->cnt++;						\
+		stats->nsecs += sched_clock() - start;			\
+		u64_stats_update_end(&stats->syncp);			\
+	} else {							\
+		ret = disp(ctx, (prog)->insnsi, (prog)->bpf_func);	\
+	}								\
 	ret; })
 
+#define BPF_PROG_RUN(prog, ctx) __BPF_PROG_RUN(prog, ctx, bpf_dispatcher_nop)
+
 #define BPF_SKB_CB_LEN QDISC_CB_PRIV_LEN
 
 struct bpf_skb_data_end {
@@ -699,6 +710,17 @@ static inline u32 bpf_prog_run_clear_cb(const struct bpf_prog *prog,
 	return res;
 }
 
+#ifdef CONFIG_BPF_JIT
+unsigned int bpf_dispatcher_xdp(
+	const void *xdp_ctx,
+	const struct bpf_insn *insnsi,
+	unsigned int (*bpf_func)(const void *,
+				 const struct bpf_insn *));
+
+#else
+#define bpf_dispatcher_xdp bpf_dispatcher_nop
+#endif
+
 static __always_inline u32 bpf_prog_run_xdp(const struct bpf_prog *prog,
 					    struct xdp_buff *xdp)
 {
@@ -708,9 +730,11 @@ static __always_inline u32 bpf_prog_run_xdp(const struct bpf_prog *prog,
 	 * already takes rcu_read_lock() when fetching the program, so
 	 * it's not necessary here anymore.
 	 */
-	return BPF_PROG_RUN(prog, xdp);
+	return __BPF_PROG_RUN(prog, xdp, bpf_dispatcher_xdp);
 }
 
+void bpf_prog_change_xdp(struct bpf_prog *prev_prog, struct bpf_prog *prog);
+
 static inline u32 bpf_prog_insn_size(const struct bpf_prog *prog)
 {
 	return prog->len * sizeof(struct bpf_insn);
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index e3461ec59570..1a67d468637b 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -2305,17 +2305,12 @@ static int bpf_obj_get_next_id(const union bpf_attr *attr,
 
 #define BPF_PROG_GET_FD_BY_ID_LAST_FIELD prog_id
 
-static int bpf_prog_get_fd_by_id(const union bpf_attr *attr)
+struct bpf_prog *bpf_prog_by_id(u32 id)
 {
 	struct bpf_prog *prog;
-	u32 id = attr->prog_id;
-	int fd;
-
-	if (CHECK_ATTR(BPF_PROG_GET_FD_BY_ID))
-		return -EINVAL;
 
-	if (!capable(CAP_SYS_ADMIN))
-		return -EPERM;
+	if (!id)
+		return ERR_PTR(-ENOENT);
 
 	spin_lock_bh(&prog_idr_lock);
 	prog = idr_find(&prog_idr, id);
@@ -2324,7 +2319,22 @@ static int bpf_prog_get_fd_by_id(const union bpf_attr *attr)
 	else
 		prog = ERR_PTR(-ENOENT);
 	spin_unlock_bh(&prog_idr_lock);
+	return prog;
+}
+
+static int bpf_prog_get_fd_by_id(const union bpf_attr *attr)
+{
+	struct bpf_prog *prog;
+	u32 id = attr->prog_id;
+	int fd;
+
+	if (CHECK_ATTR(BPF_PROG_GET_FD_BY_ID))
+		return -EINVAL;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
 
+	prog = bpf_prog_by_id(id);
 	if (IS_ERR(prog))
 		return PTR_ERR(prog);
 
diff --git a/net/core/dev.c b/net/core/dev.c
index 2c277b8aba38..255d3cf35360 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -8542,7 +8542,17 @@ static int dev_xdp_install(struct net_device *dev, bpf_op_t bpf_op,
 			   struct netlink_ext_ack *extack, u32 flags,
 			   struct bpf_prog *prog)
 {
+	bool non_hw = !(flags & XDP_FLAGS_HW_MODE);
+	struct bpf_prog *prev_prog = NULL;
 	struct netdev_bpf xdp;
+	int err;
+
+	if (non_hw) {
+		prev_prog = bpf_prog_by_id(__dev_xdp_query(dev, bpf_op,
+							   XDP_QUERY_PROG));
+		if (IS_ERR(prev_prog))
+			prev_prog = NULL;
+	}
 
 	memset(&xdp, 0, sizeof(xdp));
 	if (flags & XDP_FLAGS_HW_MODE)
@@ -8553,7 +8563,14 @@ static int dev_xdp_install(struct net_device *dev, bpf_op_t bpf_op,
 	xdp.flags = flags;
 	xdp.prog = prog;
 
-	return bpf_op(dev, &xdp);
+	err = bpf_op(dev, &xdp);
+	if (!err && non_hw)
+		bpf_prog_change_xdp(prev_prog, prog);
+
+	if (prev_prog)
+		bpf_prog_put(prev_prog);
+
+	return err;
 }
 
 static void dev_xdp_uninstall(struct net_device *dev)
diff --git a/net/core/filter.c b/net/core/filter.c
index f1e703eed3d2..f57a4bd757a7 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -74,6 +74,9 @@
 #include <net/ipv6_stubs.h>
 #include <net/bpf_sk_storage.h>
 
+void bpf_dispatcher_change_prog(void *func, struct bpf_prog *from,
+				struct bpf_prog *to);
+
 /**
  *	sk_filter_trim_cap - run a packet through a socket filter
  *	@sk: sock associated with &sk_buff
@@ -8940,3 +8943,22 @@ const struct bpf_verifier_ops sk_reuseport_verifier_ops = {
 const struct bpf_prog_ops sk_reuseport_prog_ops = {
 };
 #endif /* CONFIG_INET */
+
+#ifdef CONFIG_BPF_JIT
+unsigned int bpf_dispatcher_xdp(const void *xdp_ctx,
+				const struct bpf_insn *insnsi,
+				unsigned int (*bpf_func)(
+					const void *,
+					const struct bpf_insn *))
+{
+	return bpf_func(xdp_ctx, insnsi);
+}
+EXPORT_SYMBOL(bpf_dispatcher_xdp);
+#endif
+
+void bpf_prog_change_xdp(struct bpf_prog *prev_prog, struct bpf_prog *prog)
+{
+#ifdef CONFIG_BPF_JIT
+	bpf_dispatcher_change_prog(bpf_dispatcher_xdp, prev_prog, prog);
+#endif
+}
-- 
2.20.1

