Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9A2B31FB89
	for <lists+netdev@lfdr.de>; Fri, 19 Feb 2021 16:00:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229871AbhBSPA1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Feb 2021 10:00:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229804AbhBSPAT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Feb 2021 10:00:19 -0500
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3C7FC061786;
        Fri, 19 Feb 2021 06:59:35 -0800 (PST)
Received: by mail-lj1-x22e.google.com with SMTP id c8so21954751ljd.12;
        Fri, 19 Feb 2021 06:59:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=70o7hQc46bgRHgX4GuLfjPZ2Ox7mTbSPY6X+myc7X7M=;
        b=otKohPQw+ieJglES87MDV+C0Ar12+MeWPC0bTGBeG768bjI0StENxVNrYa5EIuaZa4
         Frc/5pPVp9AvMYgWTnKz29qfOw5uzV2yb0aa3akPyPapxWjzlwV6IfgrpBfReMcxfDzV
         0GlDwatE4Xn8QSiztCbwfhySXmPReWu1BglSSJKCjDFV7zApTYkR6L5Cw0BAOLA1/Aq4
         Z+TBjB9k+IgfuEZT/aRRM6FsgZ0Y6bX7anr/CQIiB0Xas3uUB3jjU3Ac+gVTPpxE3IUq
         VV/Qd6b1c8HH7IxZWicS7kGP2fU2rIaa6Fh2B1068VLvIt6YxCdTKRjiftz3WrrxNUjD
         sWUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=70o7hQc46bgRHgX4GuLfjPZ2Ox7mTbSPY6X+myc7X7M=;
        b=tg7TYomzpbB7YB3SQc29dPI1XQ9R/7MYJzG0HH2VZxRnYRK9+XN00Jl20becYHsFKf
         vVDAcsJd90I8H/BAQPxRMENaH9qV2w0akCVj8C+Fw/SRvkPRa+YOJzXSx6K5hJj8W3Kb
         0buAPk0akepForZqmIB6jWivCoz1dD0tIWbUtpO6cGt2qIFVNyLtCydZTemoQqAd6+L3
         tCl4wN9l289Xf4+2+P3x96ZtyUu8dwbHwX1l+5PZzToWgdXIcFzKfcyDJat5laYEPJTy
         2au6X/NH+b33rMUuf5m0N2O2G+uowdhT38etDfSPsmJKNJqdpBEaPZUOJD9xH+7G4nP2
         1d6A==
X-Gm-Message-State: AOAM533rkre9bvZfQY+5Xq5d7AGgSsL7ToEVIAcqPiIAtjrESfEba1Sy
        cNkEwkFKCgcxw1D0+XgGXpc=
X-Google-Smtp-Source: ABdhPJyPo9OznBn3n5u3QkOipPvMzMFG0hGB8oyjb84ECiNsaY3QJdO+V7evwSxc+PAoks20N38btQ==
X-Received: by 2002:ac2:4c12:: with SMTP id t18mr699573lfq.191.1613746774028;
        Fri, 19 Feb 2021 06:59:34 -0800 (PST)
Received: from btopel-mobl.ger.intel.com (c213-102-90-208.bredband.comhem.se. [213.102.90.208])
        by smtp.gmail.com with ESMTPSA id d9sm974092lfl.290.2021.02.19.06.59.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Feb 2021 06:59:33 -0800 (PST)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        maciej.fijalkowski@intel.com, hawk@kernel.org, toke@redhat.com,
        magnus.karlsson@intel.com, john.fastabend@gmail.com,
        kuba@kernel.org, davem@davemloft.net
Subject: [PATCH bpf-next 1/2] bpf, xdp: per-map bpf_redirect_map functions for XDP
Date:   Fri, 19 Feb 2021 15:59:21 +0100
Message-Id: <20210219145922.63655-2-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210219145922.63655-1-bjorn.topel@gmail.com>
References: <20210219145922.63655-1-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Björn Töpel <bjorn.topel@intel.com>

Currently the bpf_redirect_map() implementation dispatches to the
correct map-lookup function via a switch-statement. To avoid the
dispatching, this change adds one bpf_redirect_map() implementation per
map. Correct function is automatically selected by the BPF verifier.

rfc->v1: Get rid of the macro and use __always_inline. (Jesper)

Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 include/linux/bpf.h    | 20 +++++++------
 include/linux/filter.h |  2 ++
 include/net/xdp_sock.h |  6 ++--
 kernel/bpf/cpumap.c    |  2 +-
 kernel/bpf/devmap.c    |  4 +--
 kernel/bpf/verifier.c  | 28 +++++++++++-------
 net/core/filter.c      | 67 ++++++++++++++++++++++++++----------------
 7 files changed, 76 insertions(+), 53 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index cccaef1088ea..3dd186eeaf98 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -314,12 +314,14 @@ enum bpf_return_type {
 	RET_PTR_TO_BTF_ID,		/* returns a pointer to a btf_id */
 };
 
+typedef u64 (*bpf_func_proto_func)(u64 r1, u64 r2, u64 r3, u64 r4, u64 r5);
+
 /* eBPF function prototype used by verifier to allow BPF_CALLs from eBPF programs
  * to in-kernel helper functions and for adjusting imm32 field in BPF_CALL
  * instructions after verifying
  */
 struct bpf_func_proto {
-	u64 (*func)(u64 r1, u64 r2, u64 r3, u64 r4, u64 r5);
+	bpf_func_proto_func func;
 	bool gpl_only;
 	bool pkt_access;
 	enum bpf_return_type ret_type;
@@ -1429,9 +1431,11 @@ struct btf *bpf_get_btf_vmlinux(void);
 /* Map specifics */
 struct xdp_buff;
 struct sk_buff;
+struct bpf_dtab_netdev;
+struct bpf_cpu_map_entry;
 
-struct bpf_dtab_netdev *__dev_map_lookup_elem(struct bpf_map *map, u32 key);
-struct bpf_dtab_netdev *__dev_map_hash_lookup_elem(struct bpf_map *map, u32 key);
+void *__dev_map_lookup_elem(struct bpf_map *map, u32 key);
+void *__dev_map_hash_lookup_elem(struct bpf_map *map, u32 key);
 void __dev_flush(void);
 int dev_xdp_enqueue(struct net_device *dev, struct xdp_buff *xdp,
 		    struct net_device *dev_rx);
@@ -1441,7 +1445,7 @@ int dev_map_generic_redirect(struct bpf_dtab_netdev *dst, struct sk_buff *skb,
 			     struct bpf_prog *xdp_prog);
 bool dev_map_can_have_prog(struct bpf_map *map);
 
-struct bpf_cpu_map_entry *__cpu_map_lookup_elem(struct bpf_map *map, u32 key);
+void *__cpu_map_lookup_elem(struct bpf_map *map, u32 key);
 void __cpu_map_flush(void);
 int cpu_map_enqueue(struct bpf_cpu_map_entry *rcpu, struct xdp_buff *xdp,
 		    struct net_device *dev_rx);
@@ -1568,14 +1572,12 @@ static inline int bpf_obj_get_user(const char __user *pathname, int flags)
 	return -EOPNOTSUPP;
 }
 
-static inline struct net_device  *__dev_map_lookup_elem(struct bpf_map *map,
-						       u32 key)
+static inline void  *__dev_map_lookup_elem(struct bpf_map *map, u32 key)
 {
 	return NULL;
 }
 
-static inline struct net_device  *__dev_map_hash_lookup_elem(struct bpf_map *map,
-							     u32 key)
+static inline void  *__dev_map_hash_lookup_elem(struct bpf_map *map, u32 key)
 {
 	return NULL;
 }
@@ -1615,7 +1617,7 @@ static inline int dev_map_generic_redirect(struct bpf_dtab_netdev *dst,
 }
 
 static inline
-struct bpf_cpu_map_entry *__cpu_map_lookup_elem(struct bpf_map *map, u32 key)
+void *__cpu_map_lookup_elem(struct bpf_map *map, u32 key)
 {
 	return NULL;
 }
diff --git a/include/linux/filter.h b/include/linux/filter.h
index 3b00fc906ccd..1dedcf66b694 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -1472,4 +1472,6 @@ static inline bool bpf_sk_lookup_run_v6(struct net *net, int protocol,
 }
 #endif /* IS_ENABLED(CONFIG_IPV6) */
 
+bpf_func_proto_func get_xdp_redirect_func(enum bpf_map_type map_type);
+
 #endif /* __LINUX_FILTER_H__ */
diff --git a/include/net/xdp_sock.h b/include/net/xdp_sock.h
index cc17bc957548..da4139a58630 100644
--- a/include/net/xdp_sock.h
+++ b/include/net/xdp_sock.h
@@ -80,8 +80,7 @@ int xsk_generic_rcv(struct xdp_sock *xs, struct xdp_buff *xdp);
 int __xsk_map_redirect(struct xdp_sock *xs, struct xdp_buff *xdp);
 void __xsk_map_flush(void);
 
-static inline struct xdp_sock *__xsk_map_lookup_elem(struct bpf_map *map,
-						     u32 key)
+static inline void *__xsk_map_lookup_elem(struct bpf_map *map, u32 key)
 {
 	struct xsk_map *m = container_of(map, struct xsk_map, map);
 	struct xdp_sock *xs;
@@ -109,8 +108,7 @@ static inline void __xsk_map_flush(void)
 {
 }
 
-static inline struct xdp_sock *__xsk_map_lookup_elem(struct bpf_map *map,
-						     u32 key)
+static inline void *__xsk_map_lookup_elem(struct bpf_map *map, u32 key)
 {
 	return NULL;
 }
diff --git a/kernel/bpf/cpumap.c b/kernel/bpf/cpumap.c
index 5d1469de6921..a4d2cb93cd69 100644
--- a/kernel/bpf/cpumap.c
+++ b/kernel/bpf/cpumap.c
@@ -563,7 +563,7 @@ static void cpu_map_free(struct bpf_map *map)
 	kfree(cmap);
 }
 
-struct bpf_cpu_map_entry *__cpu_map_lookup_elem(struct bpf_map *map, u32 key)
+void *__cpu_map_lookup_elem(struct bpf_map *map, u32 key)
 {
 	struct bpf_cpu_map *cmap = container_of(map, struct bpf_cpu_map, map);
 	struct bpf_cpu_map_entry *rcpu;
diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
index 85d9d1b72a33..37ac4cde9713 100644
--- a/kernel/bpf/devmap.c
+++ b/kernel/bpf/devmap.c
@@ -258,7 +258,7 @@ static int dev_map_get_next_key(struct bpf_map *map, void *key, void *next_key)
 	return 0;
 }
 
-struct bpf_dtab_netdev *__dev_map_hash_lookup_elem(struct bpf_map *map, u32 key)
+void *__dev_map_hash_lookup_elem(struct bpf_map *map, u32 key)
 {
 	struct bpf_dtab *dtab = container_of(map, struct bpf_dtab, map);
 	struct hlist_head *head = dev_map_index_hash(dtab, key);
@@ -392,7 +392,7 @@ void __dev_flush(void)
  * update happens in parallel here a dev_put wont happen until after reading the
  * ifindex.
  */
-struct bpf_dtab_netdev *__dev_map_lookup_elem(struct bpf_map *map, u32 key)
+void *__dev_map_lookup_elem(struct bpf_map *map, u32 key)
 {
 	struct bpf_dtab *dtab = container_of(map, struct bpf_dtab, map);
 	struct bpf_dtab_netdev *obj;
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 3d34ba492d46..b5fb0c4e911a 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -5409,7 +5409,8 @@ record_func_map(struct bpf_verifier_env *env, struct bpf_call_arg_meta *meta,
 	    func_id != BPF_FUNC_map_delete_elem &&
 	    func_id != BPF_FUNC_map_push_elem &&
 	    func_id != BPF_FUNC_map_pop_elem &&
-	    func_id != BPF_FUNC_map_peek_elem)
+	    func_id != BPF_FUNC_map_peek_elem &&
+	    func_id != BPF_FUNC_redirect_map)
 		return 0;
 
 	if (map == NULL) {
@@ -11860,17 +11861,22 @@ static int fixup_bpf_calls(struct bpf_verifier_env *env)
 		}
 
 patch_call_imm:
-		fn = env->ops->get_func_proto(insn->imm, env->prog);
-		/* all functions that have prototype and verifier allowed
-		 * programs to call them, must be real in-kernel functions
-		 */
-		if (!fn->func) {
-			verbose(env,
-				"kernel subsystem misconfigured func %s#%d\n",
-				func_id_name(insn->imm), insn->imm);
-			return -EFAULT;
+		if (insn->imm == BPF_FUNC_redirect_map) {
+			aux = &env->insn_aux_data[i];
+			map_ptr = BPF_MAP_PTR(aux->map_ptr_state);
+			insn->imm = get_xdp_redirect_func(map_ptr->map_type) - __bpf_call_base;
+		} else {
+			fn = env->ops->get_func_proto(insn->imm, env->prog);
+			/* all functions that have prototype and verifier allowed
+			 * programs to call them, must be real in-kernel functions
+			 */
+			if (!fn->func) {
+				verbose(env, "kernel subsystem misconfigured func %s#%d\n",
+					func_id_name(insn->imm), insn->imm);
+				return -EFAULT;
+			}
+			insn->imm = fn->func - __bpf_call_base;
 		}
-		insn->imm = fn->func - __bpf_call_base;
 	}
 
 	/* Since poke tab is now finalized, publish aux to tracker. */
diff --git a/net/core/filter.c b/net/core/filter.c
index adfdad234674..fd64d768e16a 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -3944,22 +3944,6 @@ void xdp_do_flush(void)
 }
 EXPORT_SYMBOL_GPL(xdp_do_flush);
 
-static inline void *__xdp_map_lookup_elem(struct bpf_map *map, u32 index)
-{
-	switch (map->map_type) {
-	case BPF_MAP_TYPE_DEVMAP:
-		return __dev_map_lookup_elem(map, index);
-	case BPF_MAP_TYPE_DEVMAP_HASH:
-		return __dev_map_hash_lookup_elem(map, index);
-	case BPF_MAP_TYPE_CPUMAP:
-		return __cpu_map_lookup_elem(map, index);
-	case BPF_MAP_TYPE_XSKMAP:
-		return __xsk_map_lookup_elem(map, index);
-	default:
-		return NULL;
-	}
-}
-
 void bpf_clear_redirect_map(struct bpf_map *map)
 {
 	struct bpf_redirect_info *ri;
@@ -4110,22 +4094,17 @@ static const struct bpf_func_proto bpf_xdp_redirect_proto = {
 	.arg2_type      = ARG_ANYTHING,
 };
 
-BPF_CALL_3(bpf_xdp_redirect_map, struct bpf_map *, map, u32, ifindex,
-	   u64, flags)
+static __always_inline s64 __bpf_xdp_redirect_map(struct bpf_map *map, u32 ifindex, u64 flags,
+						  void *lookup_elem(struct bpf_map *map,
+								    u32 key))
 {
 	struct bpf_redirect_info *ri = this_cpu_ptr(&bpf_redirect_info);
 
-	/* Lower bits of the flags are used as return code on lookup failure */
 	if (unlikely(flags > XDP_TX))
 		return XDP_ABORTED;
 
-	ri->tgt_value = __xdp_map_lookup_elem(map, ifindex);
+	ri->tgt_value = lookup_elem(map, ifindex);
 	if (unlikely(!ri->tgt_value)) {
-		/* If the lookup fails we want to clear out the state in the
-		 * redirect_info struct completely, so that if an eBPF program
-		 * performs multiple lookups, the last one always takes
-		 * precedence.
-		 */
 		WRITE_ONCE(ri->map, NULL);
 		return flags;
 	}
@@ -4137,8 +4116,44 @@ BPF_CALL_3(bpf_xdp_redirect_map, struct bpf_map *, map, u32, ifindex,
 	return XDP_REDIRECT;
 }
 
+BPF_CALL_3(bpf_xdp_redirect_devmap, struct bpf_map *, map, u32, ifindex, u64, flags)
+{
+	return __bpf_xdp_redirect_map(map, ifindex, flags, __dev_map_lookup_elem);
+}
+
+BPF_CALL_3(bpf_xdp_redirect_devmap_hash, struct bpf_map *, map, u32, ifindex, u64, flags)
+{
+	return __bpf_xdp_redirect_map(map, ifindex, flags, __dev_map_hash_lookup_elem);
+}
+
+BPF_CALL_3(bpf_xdp_redirect_cpumap, struct bpf_map *, map, u32, ifindex, u64, flags)
+{
+	return __bpf_xdp_redirect_map(map, ifindex, flags, __cpu_map_lookup_elem);
+}
+
+BPF_CALL_3(bpf_xdp_redirect_xskmap, struct bpf_map *, map, u32, ifindex, u64, flags)
+{
+	return __bpf_xdp_redirect_map(map, ifindex, flags, __xsk_map_lookup_elem);
+}
+
+bpf_func_proto_func get_xdp_redirect_func(enum bpf_map_type map_type)
+{
+	switch (map_type) {
+	case BPF_MAP_TYPE_DEVMAP:
+		return bpf_xdp_redirect_devmap;
+	case BPF_MAP_TYPE_DEVMAP_HASH:
+		return bpf_xdp_redirect_devmap_hash;
+	case BPF_MAP_TYPE_CPUMAP:
+		return bpf_xdp_redirect_cpumap;
+	case BPF_MAP_TYPE_XSKMAP:
+		return bpf_xdp_redirect_xskmap;
+	default:
+		return NULL;
+	}
+}
+
+/* NB! .func is NULL! get_xdp_redirect_func() is used instead! */
 static const struct bpf_func_proto bpf_xdp_redirect_map_proto = {
-	.func           = bpf_xdp_redirect_map,
 	.gpl_only       = false,
 	.ret_type       = RET_INTEGER,
 	.arg1_type      = ARG_CONST_MAP_PTR,
-- 
2.27.0

