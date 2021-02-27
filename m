Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEB58326D03
	for <lists+netdev@lfdr.de>; Sat, 27 Feb 2021 13:23:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230095AbhB0MWb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Feb 2021 07:22:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230083AbhB0MW2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Feb 2021 07:22:28 -0500
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D026BC061756;
        Sat, 27 Feb 2021 04:21:47 -0800 (PST)
Received: by mail-lf1-x132.google.com with SMTP id j19so17908670lfr.12;
        Sat, 27 Feb 2021 04:21:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jOZ2TY1OAMqvL89bBM7KLljyCnM75GFsFupPDrXLkFk=;
        b=u9DuMchycdttkHLFePFZbszJq1lNPAJHkfE7xruJAdsBd86vQiYokQEX5j7avAwHHL
         xWV3Oj/MDZnMXnr3LTuOJZg964i2oxGJ4gQuIJB9xgWPl+QDYtbdvBvx/0frPsXa0ErM
         Ri+0Kc0R2ZQAHtgswN4FUVAN06Hy4EPMUuzfOvgKPRRGSlv6nTTKgxPKxPJCDlLbVWGi
         rxhg5/QQx9iKJrPGR2zEeGLxZbev/CcE11wA41hSZZSdry38Dj6BHbo8bW3WbnjXg42m
         Rvb7J501gwIKXsxw5VjLDMOGn7gYjqpE1QKyApPqY6C3TmeE64b1MaSjvYxA3vSQG59n
         yoAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jOZ2TY1OAMqvL89bBM7KLljyCnM75GFsFupPDrXLkFk=;
        b=AlFmPNStVqq0/DS/SpB9A3lIRYOIM47dbiYlyS2ttqRf6WBfHdP+/YelwREpfuUqcT
         fszW7QGXuXICXIqtytqGKCfxfwvoh460qN/RqAVHi5QS1ain0yvqCr+9IgfLg+dRb6N2
         b0NNKszJt1LlPuizy6iswk3+8GU7zJ76whTi/9i94C/2qA6AqxNLWoyPDZvx+QFq3RRQ
         eJzMTRPz4Xg59FopDpyld5dmi5aBP/gFhWw1bU/GHLA68FmYqqpl6EflHDr6khZKMysF
         UeLZHkMmivqW8mHFrcd55zSWfySdT170m20alLRx0p3Lyu2rV3FLntuCavh+Ul00ZjtO
         yIIw==
X-Gm-Message-State: AOAM531Di4nPxMtUCWgF3sTOv+NOD5xKSQPCh0SR/HDxoZotrIODj0WW
        qqt7/XkmMoQGcUCZOa3h6N4=
X-Google-Smtp-Source: ABdhPJykWREJh8vevPTph9x0fKOgRz7n/AF/671y2yLYnA4X8b4wmLTZsfSrSUhSxilx/lhDN2r2rA==
X-Received: by 2002:a19:309:: with SMTP id 9mr4532993lfd.268.1614428506261;
        Sat, 27 Feb 2021 04:21:46 -0800 (PST)
Received: from btopel-mobl.ger.intel.com (c213-102-90-208.bredband.comhem.se. [213.102.90.208])
        by smtp.gmail.com with ESMTPSA id u14sm1738091lfl.40.2021.02.27.04.21.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 27 Feb 2021 04:21:45 -0800 (PST)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        maciej.fijalkowski@intel.com, hawk@kernel.org, toke@redhat.com,
        magnus.karlsson@intel.com, john.fastabend@gmail.com,
        kuba@kernel.org, davem@davemloft.net,
        Jesper Dangaard Brouer <brouer@redhat.com>
Subject: [PATCH bpf-next v5 1/2] bpf, xdp: make bpf_redirect_map() a map operation
Date:   Sat, 27 Feb 2021 13:21:38 +0100
Message-Id: <20210227122139.183284-2-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210227122139.183284-1-bjorn.topel@gmail.com>
References: <20210227122139.183284-1-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Björn Töpel <bjorn.topel@intel.com>

Currently the bpf_redirect_map() implementation dispatches to the
correct map-lookup function via a switch-statement. To avoid the
dispatching, this change adds bpf_redirect_map() as a map
operation. Each map provides its bpf_redirect_map() version, and
correct function is automatically selected by the BPF verifier.

A nice side-effect of the code movement is that the map lookup
functions are now local to the map implementation files, which removes
one additional function call.

Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>
Acked-by: Toke Høiland-Jørgensen <toke@redhat.com>
Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 include/linux/bpf.h    | 26 ++++++--------------------
 include/linux/filter.h | 27 +++++++++++++++++++++++++++
 include/net/xdp_sock.h | 19 -------------------
 kernel/bpf/cpumap.c    |  8 +++++++-
 kernel/bpf/devmap.c    | 16 ++++++++++++++--
 kernel/bpf/verifier.c  | 11 +++++++++--
 net/core/filter.c      | 39 +--------------------------------------
 net/xdp/xskmap.c       | 18 ++++++++++++++++++
 8 files changed, 82 insertions(+), 82 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 4c730863fa77..3d3e89a37e62 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -118,6 +118,9 @@ struct bpf_map_ops {
 					   void *owner, u32 size);
 	struct bpf_local_storage __rcu ** (*map_owner_storage_ptr)(void *owner);
 
+	/* XDP helpers.*/
+	int (*map_redirect)(struct bpf_map *map, u32 ifindex, u64 flags);
+
 	/* map_meta_equal must be implemented for maps that can be
 	 * used as an inner map.  It is a runtime check to ensure
 	 * an inner map can be inserted to an outer map.
@@ -1450,9 +1453,9 @@ struct btf *bpf_get_btf_vmlinux(void);
 /* Map specifics */
 struct xdp_buff;
 struct sk_buff;
+struct bpf_dtab_netdev;
+struct bpf_cpu_map_entry;
 
-struct bpf_dtab_netdev *__dev_map_lookup_elem(struct bpf_map *map, u32 key);
-struct bpf_dtab_netdev *__dev_map_hash_lookup_elem(struct bpf_map *map, u32 key);
 void __dev_flush(void);
 int dev_xdp_enqueue(struct net_device *dev, struct xdp_buff *xdp,
 		    struct net_device *dev_rx);
@@ -1462,7 +1465,6 @@ int dev_map_generic_redirect(struct bpf_dtab_netdev *dst, struct sk_buff *skb,
 			     struct bpf_prog *xdp_prog);
 bool dev_map_can_have_prog(struct bpf_map *map);
 
-struct bpf_cpu_map_entry *__cpu_map_lookup_elem(struct bpf_map *map, u32 key);
 void __cpu_map_flush(void);
 int cpu_map_enqueue(struct bpf_cpu_map_entry *rcpu, struct xdp_buff *xdp,
 		    struct net_device *dev_rx);
@@ -1590,17 +1592,6 @@ static inline int bpf_obj_get_user(const char __user *pathname, int flags)
 	return -EOPNOTSUPP;
 }
 
-static inline struct net_device  *__dev_map_lookup_elem(struct bpf_map *map,
-						       u32 key)
-{
-	return NULL;
-}
-
-static inline struct net_device  *__dev_map_hash_lookup_elem(struct bpf_map *map,
-							     u32 key)
-{
-	return NULL;
-}
 static inline bool dev_map_can_have_prog(struct bpf_map *map)
 {
 	return false;
@@ -1612,6 +1603,7 @@ static inline void __dev_flush(void)
 
 struct xdp_buff;
 struct bpf_dtab_netdev;
+struct bpf_cpu_map_entry;
 
 static inline
 int dev_xdp_enqueue(struct net_device *dev, struct xdp_buff *xdp,
@@ -1636,12 +1628,6 @@ static inline int dev_map_generic_redirect(struct bpf_dtab_netdev *dst,
 	return 0;
 }
 
-static inline
-struct bpf_cpu_map_entry *__cpu_map_lookup_elem(struct bpf_map *map, u32 key)
-{
-	return NULL;
-}
-
 static inline void __cpu_map_flush(void)
 {
 }
diff --git a/include/linux/filter.h b/include/linux/filter.h
index 3b00fc906ccd..008691fd3b58 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -1472,4 +1472,31 @@ static inline bool bpf_sk_lookup_run_v6(struct net *net, int protocol,
 }
 #endif /* IS_ENABLED(CONFIG_IPV6) */
 
+static __always_inline int __bpf_xdp_redirect_map(struct bpf_map *map, u32 ifindex, u64 flags,
+						  void *lookup_elem(struct bpf_map *map, u32 key))
+{
+	struct bpf_redirect_info *ri = this_cpu_ptr(&bpf_redirect_info);
+
+	/* Lower bits of the flags are used as return code on lookup failure */
+	if (unlikely(flags > XDP_TX))
+		return XDP_ABORTED;
+
+	ri->tgt_value = lookup_elem(map, ifindex);
+	if (unlikely(!ri->tgt_value)) {
+		/* If the lookup fails we want to clear out the state in the
+		 * redirect_info struct completely, so that if an eBPF program
+		 * performs multiple lookups, the last one always takes
+		 * precedence.
+		 */
+		WRITE_ONCE(ri->map, NULL);
+		return flags;
+	}
+
+	ri->flags = flags;
+	ri->tgt_index = ifindex;
+	WRITE_ONCE(ri->map, map);
+
+	return XDP_REDIRECT;
+}
+
 #endif /* __LINUX_FILTER_H__ */
diff --git a/include/net/xdp_sock.h b/include/net/xdp_sock.h
index cc17bc957548..9c0722c6d7ac 100644
--- a/include/net/xdp_sock.h
+++ b/include/net/xdp_sock.h
@@ -80,19 +80,6 @@ int xsk_generic_rcv(struct xdp_sock *xs, struct xdp_buff *xdp);
 int __xsk_map_redirect(struct xdp_sock *xs, struct xdp_buff *xdp);
 void __xsk_map_flush(void);
 
-static inline struct xdp_sock *__xsk_map_lookup_elem(struct bpf_map *map,
-						     u32 key)
-{
-	struct xsk_map *m = container_of(map, struct xsk_map, map);
-	struct xdp_sock *xs;
-
-	if (key >= map->max_entries)
-		return NULL;
-
-	xs = READ_ONCE(m->xsk_map[key]);
-	return xs;
-}
-
 #else
 
 static inline int xsk_generic_rcv(struct xdp_sock *xs, struct xdp_buff *xdp)
@@ -109,12 +96,6 @@ static inline void __xsk_map_flush(void)
 {
 }
 
-static inline struct xdp_sock *__xsk_map_lookup_elem(struct bpf_map *map,
-						     u32 key)
-{
-	return NULL;
-}
-
 #endif /* CONFIG_XDP_SOCKETS */
 
 #endif /* _LINUX_XDP_SOCK_H */
diff --git a/kernel/bpf/cpumap.c b/kernel/bpf/cpumap.c
index 5d1469de6921..7352d4160b7f 100644
--- a/kernel/bpf/cpumap.c
+++ b/kernel/bpf/cpumap.c
@@ -563,7 +563,7 @@ static void cpu_map_free(struct bpf_map *map)
 	kfree(cmap);
 }
 
-struct bpf_cpu_map_entry *__cpu_map_lookup_elem(struct bpf_map *map, u32 key)
+static void *__cpu_map_lookup_elem(struct bpf_map *map, u32 key)
 {
 	struct bpf_cpu_map *cmap = container_of(map, struct bpf_cpu_map, map);
 	struct bpf_cpu_map_entry *rcpu;
@@ -600,6 +600,11 @@ static int cpu_map_get_next_key(struct bpf_map *map, void *key, void *next_key)
 	return 0;
 }
 
+static int cpu_map_redirect(struct bpf_map *map, u32 ifindex, u64 flags)
+{
+	return __bpf_xdp_redirect_map(map, ifindex, flags, __cpu_map_lookup_elem);
+}
+
 static int cpu_map_btf_id;
 const struct bpf_map_ops cpu_map_ops = {
 	.map_meta_equal		= bpf_map_meta_equal,
@@ -612,6 +617,7 @@ const struct bpf_map_ops cpu_map_ops = {
 	.map_check_btf		= map_check_no_btf,
 	.map_btf_name		= "bpf_cpu_map",
 	.map_btf_id		= &cpu_map_btf_id,
+	.map_redirect		= cpu_map_redirect,
 };
 
 static void bq_flush_to_queue(struct xdp_bulk_queue *bq)
diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
index 85d9d1b72a33..f7f42448259f 100644
--- a/kernel/bpf/devmap.c
+++ b/kernel/bpf/devmap.c
@@ -258,7 +258,7 @@ static int dev_map_get_next_key(struct bpf_map *map, void *key, void *next_key)
 	return 0;
 }
 
-struct bpf_dtab_netdev *__dev_map_hash_lookup_elem(struct bpf_map *map, u32 key)
+static void *__dev_map_hash_lookup_elem(struct bpf_map *map, u32 key)
 {
 	struct bpf_dtab *dtab = container_of(map, struct bpf_dtab, map);
 	struct hlist_head *head = dev_map_index_hash(dtab, key);
@@ -392,7 +392,7 @@ void __dev_flush(void)
  * update happens in parallel here a dev_put wont happen until after reading the
  * ifindex.
  */
-struct bpf_dtab_netdev *__dev_map_lookup_elem(struct bpf_map *map, u32 key)
+static void *__dev_map_lookup_elem(struct bpf_map *map, u32 key)
 {
 	struct bpf_dtab *dtab = container_of(map, struct bpf_dtab, map);
 	struct bpf_dtab_netdev *obj;
@@ -735,6 +735,16 @@ static int dev_map_hash_update_elem(struct bpf_map *map, void *key, void *value,
 					 map, key, value, map_flags);
 }
 
+static int dev_map_redirect(struct bpf_map *map, u32 ifindex, u64 flags)
+{
+	return __bpf_xdp_redirect_map(map, ifindex, flags, __dev_map_lookup_elem);
+}
+
+static int dev_hash_map_redirect(struct bpf_map *map, u32 ifindex, u64 flags)
+{
+	return __bpf_xdp_redirect_map(map, ifindex, flags, __dev_map_hash_lookup_elem);
+}
+
 static int dev_map_btf_id;
 const struct bpf_map_ops dev_map_ops = {
 	.map_meta_equal = bpf_map_meta_equal,
@@ -747,6 +757,7 @@ const struct bpf_map_ops dev_map_ops = {
 	.map_check_btf = map_check_no_btf,
 	.map_btf_name = "bpf_dtab",
 	.map_btf_id = &dev_map_btf_id,
+	.map_redirect = dev_map_redirect,
 };
 
 static int dev_map_hash_map_btf_id;
@@ -761,6 +772,7 @@ const struct bpf_map_ops dev_map_hash_ops = {
 	.map_check_btf = map_check_no_btf,
 	.map_btf_name = "bpf_dtab",
 	.map_btf_id = &dev_map_hash_map_btf_id,
+	.map_redirect = dev_hash_map_redirect,
 };
 
 static void dev_map_hash_remove_netdev(struct bpf_dtab *dtab,
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 9fe90ce52a65..b6c44b85e960 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -5582,7 +5582,8 @@ record_func_map(struct bpf_verifier_env *env, struct bpf_call_arg_meta *meta,
 	    func_id != BPF_FUNC_map_push_elem &&
 	    func_id != BPF_FUNC_map_pop_elem &&
 	    func_id != BPF_FUNC_map_peek_elem &&
-	    func_id != BPF_FUNC_for_each_map_elem)
+	    func_id != BPF_FUNC_for_each_map_elem &&
+	    func_id != BPF_FUNC_redirect_map)
 		return 0;
 
 	if (map == NULL) {
@@ -12017,7 +12018,8 @@ static int do_misc_fixups(struct bpf_verifier_env *env)
 		     insn->imm == BPF_FUNC_map_delete_elem ||
 		     insn->imm == BPF_FUNC_map_push_elem   ||
 		     insn->imm == BPF_FUNC_map_pop_elem    ||
-		     insn->imm == BPF_FUNC_map_peek_elem)) {
+		     insn->imm == BPF_FUNC_map_peek_elem   ||
+		     insn->imm == BPF_FUNC_redirect_map)) {
 			aux = &env->insn_aux_data[i + delta];
 			if (bpf_map_ptr_poisoned(aux))
 				goto patch_call_imm;
@@ -12059,6 +12061,8 @@ static int do_misc_fixups(struct bpf_verifier_env *env)
 				     (int (*)(struct bpf_map *map, void *value))NULL));
 			BUILD_BUG_ON(!__same_type(ops->map_peek_elem,
 				     (int (*)(struct bpf_map *map, void *value))NULL));
+			BUILD_BUG_ON(!__same_type(ops->map_redirect,
+				     (int (*)(struct bpf_map *map, u32 ifindex, u64 flags))NULL));
 patch_map_ops_generic:
 			switch (insn->imm) {
 			case BPF_FUNC_map_lookup_elem:
@@ -12085,6 +12089,9 @@ static int do_misc_fixups(struct bpf_verifier_env *env)
 				insn->imm = BPF_CAST_CALL(ops->map_peek_elem) -
 					    __bpf_call_base;
 				continue;
+			case BPF_FUNC_redirect_map:
+				insn->imm = BPF_CAST_CALL(ops->map_redirect) - __bpf_call_base;
+				continue;
 			}
 
 			goto patch_call_imm;
diff --git a/net/core/filter.c b/net/core/filter.c
index 13bcf248ee7b..960299a3744f 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -3934,22 +3934,6 @@ void xdp_do_flush(void)
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
@@ -4103,28 +4087,7 @@ static const struct bpf_func_proto bpf_xdp_redirect_proto = {
 BPF_CALL_3(bpf_xdp_redirect_map, struct bpf_map *, map, u32, ifindex,
 	   u64, flags)
 {
-	struct bpf_redirect_info *ri = this_cpu_ptr(&bpf_redirect_info);
-
-	/* Lower bits of the flags are used as return code on lookup failure */
-	if (unlikely(flags > XDP_TX))
-		return XDP_ABORTED;
-
-	ri->tgt_value = __xdp_map_lookup_elem(map, ifindex);
-	if (unlikely(!ri->tgt_value)) {
-		/* If the lookup fails we want to clear out the state in the
-		 * redirect_info struct completely, so that if an eBPF program
-		 * performs multiple lookups, the last one always takes
-		 * precedence.
-		 */
-		WRITE_ONCE(ri->map, NULL);
-		return flags;
-	}
-
-	ri->flags = flags;
-	ri->tgt_index = ifindex;
-	WRITE_ONCE(ri->map, map);
-
-	return XDP_REDIRECT;
+	return map->ops->map_redirect(map, ifindex, flags);
 }
 
 static const struct bpf_func_proto bpf_xdp_redirect_map_proto = {
diff --git a/net/xdp/xskmap.c b/net/xdp/xskmap.c
index 113fd9017203..711acb3636b3 100644
--- a/net/xdp/xskmap.c
+++ b/net/xdp/xskmap.c
@@ -125,6 +125,18 @@ static int xsk_map_gen_lookup(struct bpf_map *map, struct bpf_insn *insn_buf)
 	return insn - insn_buf;
 }
 
+static void *__xsk_map_lookup_elem(struct bpf_map *map, u32 key)
+{
+	struct xsk_map *m = container_of(map, struct xsk_map, map);
+	struct xdp_sock *xs;
+
+	if (key >= map->max_entries)
+		return NULL;
+
+	xs = READ_ONCE(m->xsk_map[key]);
+	return xs;
+}
+
 static void *xsk_map_lookup_elem(struct bpf_map *map, void *key)
 {
 	WARN_ON_ONCE(!rcu_read_lock_held());
@@ -215,6 +227,11 @@ static int xsk_map_delete_elem(struct bpf_map *map, void *key)
 	return 0;
 }
 
+static int xsk_map_redirect(struct bpf_map *map, u32 ifindex, u64 flags)
+{
+	return __bpf_xdp_redirect_map(map, ifindex, flags, __xsk_map_lookup_elem);
+}
+
 void xsk_map_try_sock_delete(struct xsk_map *map, struct xdp_sock *xs,
 			     struct xdp_sock **map_entry)
 {
@@ -247,4 +264,5 @@ const struct bpf_map_ops xsk_map_ops = {
 	.map_check_btf = map_check_no_btf,
 	.map_btf_name = "xsk_map",
 	.map_btf_id = &xsk_map_btf_id,
+	.map_redirect = xsk_map_redirect,
 };
-- 
2.27.0

