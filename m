Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8ECD4320D68
	for <lists+netdev@lfdr.de>; Sun, 21 Feb 2021 21:11:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230335AbhBUUKr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Feb 2021 15:10:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230253AbhBUUKo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Feb 2021 15:10:44 -0500
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32F0CC061786;
        Sun, 21 Feb 2021 12:10:03 -0800 (PST)
Received: by mail-lj1-x22e.google.com with SMTP id q14so52178203ljp.4;
        Sun, 21 Feb 2021 12:10:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=i973QLQCvNEfbY+mIaLV9rC3ZCnO6nuencEWZbpOb7c=;
        b=IPxA7zoiwm8vmXrkOLyjd0+NJIDwXNUcTx4iL6ZzEkC29kTXM8UeZpTudjVaIHYG1b
         cgi9ZK1UpXPuUDdmB0qO+zvCreScPEV04so3HVE/3+LxlcTFMrTGPm6DPyqVkCZAUDMA
         vl+qSf3mX3VTHm+yery28TWxZHfa6rhyFlHp2WVQGBb9+g6exzFY6IhHToTVxMUyLMc3
         hUo7HcLmgKTC7El4argTmedUHoL5JoMrU9+D9DJXjWoaiaJfvFNn7WMFDmKqNzmjWEZ4
         tl2qnwCONjBa7pwvHQx/9MbA1e/8yUjb+71y0i3YizBSLsFWi+tY2uKXPoDds5VazM9z
         8ZOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=i973QLQCvNEfbY+mIaLV9rC3ZCnO6nuencEWZbpOb7c=;
        b=c0woJj19r7IMkjfhH7p7XljU5HqrdWsdKmuoaQHMfd56wKP+iw7PeLKErVTQ8dHo3O
         0q3aA7x8Ro/XVoOb6mM0ol7bDQnAI1FIgRQZ2vum8YXY8rlrLmio2WVrnVEyScwcpL/s
         85I6i4wyP3Lio94n9/Ltn4BQIHEYvDAxQ5niq/H6nIoOSlTKCiMZokVTlfZTAXD+x9F6
         Rz53cpivUIGN/B3BRbeC/yfdgM6QtneFSfp3Q/+gzRUENAe9pD0vaEtZj5wLiCROOXVy
         I1ozsV88pFTr+8fbjqa4pBYbbORnBfyyUflviSts6BsSeq9XiidjQmEf2kPRj2IOTxUz
         LC/g==
X-Gm-Message-State: AOAM531QRG1x7XyJGNPucGYXQHKyjbGjlNuMGtxZoj/2WOqC55u0LuFM
        l8tTH7WGbp2Mx/1W3a10Edc=
X-Google-Smtp-Source: ABdhPJzgLmDFDjo3GHKciCfMXRPxMH4LzDyuQiKsjzwLqGGqLwjCh1mrAaXZhGahMzJQK4+Hd0U9IA==
X-Received: by 2002:ac2:5311:: with SMTP id c17mr924141lfh.33.1613938201675;
        Sun, 21 Feb 2021 12:10:01 -0800 (PST)
Received: from btopel-mobl.ger.intel.com (c213-102-90-208.bredband.comhem.se. [213.102.90.208])
        by smtp.gmail.com with ESMTPSA id q26sm1657823lfb.86.2021.02.21.12.10.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Feb 2021 12:10:00 -0800 (PST)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        maciej.fijalkowski@intel.com, hawk@kernel.org, toke@redhat.com,
        magnus.karlsson@intel.com, john.fastabend@gmail.com,
        kuba@kernel.org, davem@davemloft.net
Subject: [PATCH bpf-next v3 1/2] bpf, xdp: per-map bpf_redirect_map functions for XDP
Date:   Sun, 21 Feb 2021 21:09:53 +0100
Message-Id: <20210221200954.164125-2-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210221200954.164125-1-bjorn.topel@gmail.com>
References: <20210221200954.164125-1-bjorn.topel@gmail.com>
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

v2->v3 : Fix build when CONFIG_NET is not set. (lkp)
v1->v2 : Re-added comment. (Toke)
rfc->v1: Get rid of the macro and use __always_inline. (Jesper)

Acked-by: Toke Høiland-Jørgensen <toke@redhat.com>
Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 include/linux/bpf.h    | 20 +++++++-------
 include/linux/filter.h |  9 +++++++
 include/net/xdp_sock.h |  6 ++---
 kernel/bpf/cpumap.c    |  2 +-
 kernel/bpf/devmap.c    |  4 +--
 kernel/bpf/verifier.c  | 17 ++++++++----
 net/core/filter.c      | 61 ++++++++++++++++++++++++++++--------------
 7 files changed, 78 insertions(+), 41 deletions(-)

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
index 3b00fc906ccd..bc2a1ec20d0b 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -1472,4 +1472,13 @@ static inline bool bpf_sk_lookup_run_v6(struct net *net, int protocol,
 }
 #endif /* IS_ENABLED(CONFIG_IPV6) */
 
+#ifdef CONFIG_NET
+bpf_func_proto_func get_xdp_redirect_func(enum bpf_map_type map_type);
+#else
+static inline bpf_func_proto_func get_xdp_redirect_func(enum bpf_map_type map_type)
+{
+	return NULL;
+}
+#endif
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
index 3d34ba492d46..89ccc10c6348 100644
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
@@ -11545,12 +11546,12 @@ static int fixup_bpf_calls(struct bpf_verifier_env *env)
 	struct bpf_prog *prog = env->prog;
 	bool expect_blinding = bpf_jit_blinding_enabled(prog);
 	struct bpf_insn *insn = prog->insnsi;
-	const struct bpf_func_proto *fn;
 	const int insn_cnt = prog->len;
 	const struct bpf_map_ops *ops;
 	struct bpf_insn_aux_data *aux;
 	struct bpf_insn insn_buf[16];
 	struct bpf_prog *new_prog;
+	bpf_func_proto_func func;
 	struct bpf_map *map_ptr;
 	int i, ret, cnt, delta = 0;
 
@@ -11860,17 +11861,23 @@ static int fixup_bpf_calls(struct bpf_verifier_env *env)
 		}
 
 patch_call_imm:
-		fn = env->ops->get_func_proto(insn->imm, env->prog);
+		if (insn->imm == BPF_FUNC_redirect_map) {
+			aux = &env->insn_aux_data[i];
+			map_ptr = BPF_MAP_PTR(aux->map_ptr_state);
+			func = get_xdp_redirect_func(map_ptr->map_type);
+		} else {
+			func = env->ops->get_func_proto(insn->imm, env->prog)->func;
+		}
 		/* all functions that have prototype and verifier allowed
 		 * programs to call them, must be real in-kernel functions
 		 */
-		if (!fn->func) {
+		if (!func) {
 			verbose(env,
 				"kernel subsystem misconfigured func %s#%d\n",
 				func_id_name(insn->imm), insn->imm);
 			return -EFAULT;
 		}
-		insn->imm = fn->func - __bpf_call_base;
+		insn->imm = func - __bpf_call_base;
 	}
 
 	/* Since poke tab is now finalized, publish aux to tracker. */
diff --git a/net/core/filter.c b/net/core/filter.c
index adfdad234674..502e7856f107 100644
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
@@ -4110,8 +4094,9 @@ static const struct bpf_func_proto bpf_xdp_redirect_proto = {
 	.arg2_type      = ARG_ANYTHING,
 };
 
-BPF_CALL_3(bpf_xdp_redirect_map, struct bpf_map *, map, u32, ifindex,
-	   u64, flags)
+static __always_inline s64 __bpf_xdp_redirect_map(struct bpf_map *map, u32 ifindex, u64 flags,
+						  void *lookup_elem(struct bpf_map *map,
+								    u32 key))
 {
 	struct bpf_redirect_info *ri = this_cpu_ptr(&bpf_redirect_info);
 
@@ -4119,7 +4104,7 @@ BPF_CALL_3(bpf_xdp_redirect_map, struct bpf_map *, map, u32, ifindex,
 	if (unlikely(flags > XDP_TX))
 		return XDP_ABORTED;
 
-	ri->tgt_value = __xdp_map_lookup_elem(map, ifindex);
+	ri->tgt_value = lookup_elem(map, ifindex);
 	if (unlikely(!ri->tgt_value)) {
 		/* If the lookup fails we want to clear out the state in the
 		 * redirect_info struct completely, so that if an eBPF program
@@ -4137,8 +4122,44 @@ BPF_CALL_3(bpf_xdp_redirect_map, struct bpf_map *, map, u32, ifindex,
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

