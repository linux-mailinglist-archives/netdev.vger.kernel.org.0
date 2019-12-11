Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D2FC11AACF
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 13:30:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729238AbfLKMaq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 07:30:46 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:37931 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728991AbfLKMaq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 07:30:46 -0500
Received: by mail-pg1-f194.google.com with SMTP id a33so10499565pgm.5;
        Wed, 11 Dec 2019 04:30:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rRqDcNnLG2JtDn1sPfTbToIau7rGU2D371JxWP2l1oM=;
        b=UESBXhNhm/fU42wAN7zXRLTsX4kwyx6zTZgQhV1dxBYEa4/mIqhy2IjwGmeXrO8EvH
         5RhSFWkccCZwqkm0DqWBIsVbuugTe1VUlRcyAZHYJnrFd4J4gGMJzWaFLY7Duf6YB4oV
         f/K8/67nKnEACiVo419hg1S6CkowWdr2KwAAJ2+36JrHkZyz9g3MR3WsskJUkQnMSQBv
         gXmCs27POgEkHlYWlfqhoADbvb33UoxDUkCL20iwGAc9XggbKyhDokgN1p7htv31T3w0
         RW6nxRA4o9M7J6lszpfqUZiLuSJt52u509ZW3YOasSnBgLeYPh5BsRRsIQCUwH+wRpff
         +5yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rRqDcNnLG2JtDn1sPfTbToIau7rGU2D371JxWP2l1oM=;
        b=EZvvUT7bKWh/KDEsZPUj0gCBqs+lICcy49vZQ+RM1hqJJaS26ofmKNxi9X/bzqkiFD
         vJJB7uS11gcem0sHjDi2qu7HNXgXcqrSXkDqMtLH6AZ+G3BRLPrkv2VMm8QW78XVPEVq
         LGD81BJWcdo74BQhoCFP3/aAwFbPb1Xl/VjWD/8M1fGFvyQkPtzsfySYOzDiCk1z1Nua
         GIfgQ97WPEqc7MEMC9+2OkwS0CLqqb8lpgovUHrrr3Hh/ndsQmoU6H9xFLQhERB3899y
         iTsFXkcaYH1uYEgwx4mnAIAdUzrxi0FbS9Y1qwK3ssNyuaYbUNzB7fppdYi3cs80F/9W
         yOeg==
X-Gm-Message-State: APjAAAVXdSblfxcJhXquFnNRnFXcg5VWH173Al/NgkkCMg9iQBITHauj
        RKKGpegxGcHzCx90cnj2uKnU0pSE4qefnA==
X-Google-Smtp-Source: APXvYqwncnpLtyt/7duSUXkZX2hZEvBRGwh1IhPKcK5TNLkPWK2RE41bK1PHmbpxBR8yU0SmJEyYkQ==
X-Received: by 2002:a65:654d:: with SMTP id a13mr3899460pgw.141.1576067445092;
        Wed, 11 Dec 2019 04:30:45 -0800 (PST)
Received: from btopel-mobl.ger.intel.com ([192.55.55.41])
        by smtp.gmail.com with ESMTPSA id 24sm3097132pfn.101.2019.12.11.04.30.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Dec 2019 04:30:44 -0800 (PST)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        bpf@vger.kernel.org, magnus.karlsson@gmail.com,
        magnus.karlsson@intel.com, jonathan.lemon@gmail.com,
        ecree@solarflare.com, thoiland@redhat.com, brouer@redhat.com,
        andrii.nakryiko@gmail.com
Subject: [PATCH bpf-next v4 3/6] bpf, xdp: start using the BPF dispatcher for XDP
Date:   Wed, 11 Dec 2019 13:30:14 +0100
Message-Id: <20191211123017.13212-4-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191211123017.13212-1-bjorn.topel@gmail.com>
References: <20191211123017.13212-1-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Björn Töpel <bjorn.topel@intel.com>

This commit adds a BPF dispatcher for XDP. The dispatcher is updated
from the XDP control-path, dev_xdp_install(), and used when an XDP
program is run via bpf_prog_run_xdp().

Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 include/linux/bpf.h    | 15 +++++++++++++++
 include/linux/filter.h | 40 ++++++++++++++++++++++++----------------
 kernel/bpf/syscall.c   | 26 ++++++++++++++++++--------
 net/core/dev.c         | 19 ++++++++++++++++++-
 net/core/filter.c      |  8 ++++++++
 5 files changed, 83 insertions(+), 25 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index e6a9d74d4e30..ed32b5d901a1 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -488,6 +488,14 @@ struct bpf_dispatcher {
 	u32 image_off;
 };
 
+static __always_inline unsigned int bpf_dispatcher_nopfunc(
+	const void *ctx,
+	const struct bpf_insn *insnsi,
+	unsigned int (*bpf_func)(const void *,
+				 const struct bpf_insn *))
+{
+	return bpf_func(ctx, insnsi);
+}
 #ifdef CONFIG_BPF_JIT
 struct bpf_trampoline *bpf_trampoline_lookup(u64 key);
 int bpf_trampoline_link_prog(struct bpf_prog *prog);
@@ -997,6 +1005,8 @@ int btf_distill_func_proto(struct bpf_verifier_log *log,
 
 int btf_check_func_arg_match(struct bpf_verifier_env *env, int subprog);
 
+struct bpf_prog *bpf_prog_by_id(u32 id);
+
 #else /* !CONFIG_BPF_SYSCALL */
 static inline struct bpf_prog *bpf_prog_get(u32 ufd)
 {
@@ -1128,6 +1138,11 @@ static inline int bpf_prog_test_run_flow_dissector(struct bpf_prog *prog,
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
index a141cb07e76a..37ac7025031d 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -559,23 +559,26 @@ struct sk_filter {
 
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
+#define __BPF_PROG_RUN(prog, ctx, dfunc)	({			\
+	u32 ret;							\
+	cant_sleep();							\
+	if (static_branch_unlikely(&bpf_stats_enabled_key)) {		\
+		struct bpf_prog_stats *stats;				\
+		u64 start = sched_clock();				\
+		ret = dfunc(ctx, (prog)->insnsi, (prog)->bpf_func);	\
+		stats = this_cpu_ptr(prog->aux->stats);			\
+		u64_stats_update_begin(&stats->syncp);			\
+		stats->cnt++;						\
+		stats->nsecs += sched_clock() - start;			\
+		u64_stats_update_end(&stats->syncp);			\
+	} else {							\
+		ret = dfunc(ctx, (prog)->insnsi, (prog)->bpf_func);	\
+	}								\
 	ret; })
 
+#define BPF_PROG_RUN(prog, ctx) __BPF_PROG_RUN(prog, ctx,		\
+					       bpf_dispatcher_nopfunc)
+
 #define BPF_SKB_CB_LEN QDISC_CB_PRIV_LEN
 
 struct bpf_skb_data_end {
@@ -699,6 +702,8 @@ static inline u32 bpf_prog_run_clear_cb(const struct bpf_prog *prog,
 	return res;
 }
 
+DECLARE_BPF_DISPATCHER(bpf_dispatcher_xdp)
+
 static __always_inline u32 bpf_prog_run_xdp(const struct bpf_prog *prog,
 					    struct xdp_buff *xdp)
 {
@@ -708,9 +713,12 @@ static __always_inline u32 bpf_prog_run_xdp(const struct bpf_prog *prog,
 	 * already takes rcu_read_lock() when fetching the program, so
 	 * it's not necessary here anymore.
 	 */
-	return BPF_PROG_RUN(prog, xdp);
+	return __BPF_PROG_RUN(prog, xdp,
+			      BPF_DISPATCHER_FUNC(bpf_dispatcher_xdp));
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
index f1e703eed3d2..a411f7835dee 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -8940,3 +8940,11 @@ const struct bpf_verifier_ops sk_reuseport_verifier_ops = {
 const struct bpf_prog_ops sk_reuseport_prog_ops = {
 };
 #endif /* CONFIG_INET */
+
+DEFINE_BPF_DISPATCHER(bpf_dispatcher_xdp)
+
+void bpf_prog_change_xdp(struct bpf_prog *prev_prog, struct bpf_prog *prog)
+{
+	bpf_dispatcher_change_prog(BPF_DISPATCHER_PTR(bpf_dispatcher_xdp),
+				   prev_prog, prog);
+}
-- 
2.20.1

