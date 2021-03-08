Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10C52330C5D
	for <lists+netdev@lfdr.de>; Mon,  8 Mar 2021 12:29:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231719AbhCHL3Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Mar 2021 06:29:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230522AbhCHL3Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Mar 2021 06:29:16 -0500
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50F16C06174A;
        Mon,  8 Mar 2021 03:29:16 -0800 (PST)
Received: by mail-lf1-x132.google.com with SMTP id v2so7442000lft.9;
        Mon, 08 Mar 2021 03:29:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zxmqBkkiPXC0aOfhpg7EfwuhvYcRnsA7sefsOYXpVYA=;
        b=Qhj71mLa8G5T3yqc0sohXoryMqolfcbIXpOTSu0Lw6AyVzaToXkUvtXu5kLP0iVA9t
         tNPigQyZabUoAY2inasd8+mt7VVxqbjHaa4cQe9MbLAczFA5fubt7gtfNKJ+U5fW2i7K
         x60Vns7ReCM8sYRv0DnKU8VB3OK7lKPMfeBAFH9jCI8PSq6cGws0NwGkMsWRBAofm1CW
         QMDtrBBgC6I9g46sM0DwW+yzEnbLqB6N/Pwspbx2cB902jfRZFy2/ZQxl9ImEGOt3N8r
         mdjmlrO9pRgGwrbfB8zsrEiICuHAz94LBftHVh64HuNHBfqC+HbIBxoFXR/F7bOWKVws
         4qBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zxmqBkkiPXC0aOfhpg7EfwuhvYcRnsA7sefsOYXpVYA=;
        b=YjbBGPW/R8IMWp0EU0/4/Qdf+lYSNFWFQDj7mUXkqe1AT7vUEbOJsNtzLcc4PPmZo/
         De2RsJc2tEORgNXlmXhldVYblf1pFJBcyZEKxAXmv9qmmWrnPoydz6Twzp61u38K3/gR
         jHN74bNugVxdvvt1kjWLxTBLA/4A75pDxckfTgsf9Fv0YouCrq9n9DqbYZCuw/tN5jtK
         Nhj8ELTPh+ygRl2H8DYhB6oCEGconol5/VeiuCqCvbWd0o56IDIFcQVS4lS3sbViRhHf
         nEUqdvEt0g8+nnalJgwvT7a4BmFaDxARbpyWzZj6EGs60pEwvOooth4h6eVFacgNURTq
         Fdzg==
X-Gm-Message-State: AOAM5300E9SJcMtBPYyKDHZuOvhGdMVcBDQcW2VF9N1u4KlbdB44uvmw
        Ryn6H6KS8h0CzDY3E9bDc94=
X-Google-Smtp-Source: ABdhPJxIwSH2Yl8n1kac4LApWLsod56BE0g2IOaYqhFcszp+CPqSldw/RSDQL4IBEc+c9GkUQwmcjQ==
X-Received: by 2002:ac2:41c5:: with SMTP id d5mr14124625lfi.459.1615202954717;
        Mon, 08 Mar 2021 03:29:14 -0800 (PST)
Received: from btopel-mobl.ger.intel.com (c213-102-90-208.bredband.comhem.se. [213.102.90.208])
        by smtp.gmail.com with ESMTPSA id w23sm1456145lji.127.2021.03.08.03.29.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Mar 2021 03:29:14 -0800 (PST)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        maciej.fijalkowski@intel.com, hawk@kernel.org, toke@redhat.com,
        magnus.karlsson@intel.com, john.fastabend@gmail.com,
        kuba@kernel.org, davem@davemloft.net,
        Jesper Dangaard Brouer <brouer@redhat.com>
Subject: [PATCH bpf-next v6 1/2] bpf, xdp: make bpf_redirect_map() a map operation
Date:   Mon,  8 Mar 2021 12:29:06 +0100
Message-Id: <20210308112907.559576-2-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210308112907.559576-1-bjorn.topel@gmail.com>
References: <20210308112907.559576-1-bjorn.topel@gmail.com>
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
 kernel/bpf/verifier.c  | 13 +++++++++++--
 net/core/filter.c      | 39 +--------------------------------------
 net/xdp/xskmap.c       | 16 ++++++++++++++++
 8 files changed, 82 insertions(+), 82 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index c931bc97019d..a25730eaa148 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -118,6 +118,9 @@ struct bpf_map_ops {
 					   void *owner, u32 size);
 	struct bpf_local_storage __rcu ** (*map_owner_storage_ptr)(void *owner);
 
+	/* Misc helpers.*/
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
@@ -1593,17 +1595,6 @@ static inline int bpf_obj_get_user(const char __user *pathname, int flags)
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
@@ -1615,6 +1606,7 @@ static inline void __dev_flush(void)
 
 struct xdp_buff;
 struct bpf_dtab_netdev;
+struct bpf_cpu_map_entry;
 
 static inline
 int dev_xdp_enqueue(struct net_device *dev, struct xdp_buff *xdp,
@@ -1639,12 +1631,6 @@ static inline int dev_map_generic_redirect(struct bpf_dtab_netdev *dst,
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
index 9fe90ce52a65..97eb0b2435b8 100644
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
@@ -12059,6 +12061,9 @@ static int do_misc_fixups(struct bpf_verifier_env *env)
 				     (int (*)(struct bpf_map *map, void *value))NULL));
 			BUILD_BUG_ON(!__same_type(ops->map_peek_elem,
 				     (int (*)(struct bpf_map *map, void *value))NULL));
+			BUILD_BUG_ON(!__same_type(ops->map_redirect,
+				     (int (*)(struct bpf_map *map, u32 ifindex, u64 flags))NULL));
+
 patch_map_ops_generic:
 			switch (insn->imm) {
 			case BPF_FUNC_map_lookup_elem:
@@ -12085,6 +12090,10 @@ static int do_misc_fixups(struct bpf_verifier_env *env)
 				insn->imm = BPF_CAST_CALL(ops->map_peek_elem) -
 					    __bpf_call_base;
 				continue;
+			case BPF_FUNC_redirect_map:
+				insn->imm = BPF_CAST_CALL(ops->map_redirect) -
+					    __bpf_call_base;
+				continue;
 			}
 
 			goto patch_call_imm;
diff --git a/net/core/filter.c b/net/core/filter.c
index 588b19ba0da8..183b0aa6b027 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -3943,22 +3943,6 @@ void xdp_do_flush(void)
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
@@ -4112,28 +4096,7 @@ static const struct bpf_func_proto bpf_xdp_redirect_proto = {
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
index 113fd9017203..fbeb4870f798 100644
--- a/net/xdp/xskmap.c
+++ b/net/xdp/xskmap.c
@@ -125,6 +125,16 @@ static int xsk_map_gen_lookup(struct bpf_map *map, struct bpf_insn *insn_buf)
 	return insn - insn_buf;
 }
 
+static void *__xsk_map_lookup_elem(struct bpf_map *map, u32 key)
+{
+	struct xsk_map *m = container_of(map, struct xsk_map, map);
+
+	if (key >= map->max_entries)
+		return NULL;
+
+	return READ_ONCE(m->xsk_map[key]);
+}
+
 static void *xsk_map_lookup_elem(struct bpf_map *map, void *key)
 {
 	WARN_ON_ONCE(!rcu_read_lock_held());
@@ -215,6 +225,11 @@ static int xsk_map_delete_elem(struct bpf_map *map, void *key)
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
@@ -247,4 +262,5 @@ const struct bpf_map_ops xsk_map_ops = {
 	.map_check_btf = map_check_no_btf,
 	.map_btf_name = "xsk_map",
 	.map_btf_id = &xsk_map_btf_id,
+	.map_redirect = xsk_map_redirect,
 };
-- 
2.27.0

