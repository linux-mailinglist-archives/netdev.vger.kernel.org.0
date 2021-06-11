Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60EA13A3AD6
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 06:24:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230272AbhFKE0r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 00:26:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229582AbhFKE0r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 00:26:47 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C543C061574;
        Thu, 10 Jun 2021 21:24:50 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id e7so2185986plj.7;
        Thu, 10 Jun 2021 21:24:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=zqnGXSYcl8VzctxJvTnbyv5jV0Vekq5Rs999ZFk6l14=;
        b=VBs+ZoZb2SGfDyFPTAMS3W4tl12bm6OyuyUjs3kAGq9d1OwTvE4+BNt/4ZGx4hUg4C
         oD8ecIAuat7QstdUYlkYJSx8gvwRccLNvcvf3IwcB0eN2mYYGxhcAeLi4hpBclp7jJqH
         p2p3Q2SZf53HqkZxcLDsw4kPvF41/DebZVOONH517/vQZTitmCRv5ZvYw6vsitUEQnab
         FXzaGKrXK6xgibriCm7+/Gq8JD0uCuaWSB9jxTmHYes6TQ5uHKM5jVv2LdPcl7gYc29I
         4GZpEF41x8M7R0khhnJTfZ0bvXMQ38aQNH3iiZApMV7pIiBqd3DZZcxP6y9hp4M0+yCm
         Dz+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=zqnGXSYcl8VzctxJvTnbyv5jV0Vekq5Rs999ZFk6l14=;
        b=lWT2I/fuQuC3osPROkOVcCN3RxAeMnsHISWwi5wmXh/OrNb6oODOFJvU3feKFM7mTb
         8VYzFTxcKH1yIEyv3reWMRKoxZRRUyrLSLUo98lSSp/4eZ0WNSfdxocU8QC0fvhCsfFt
         uLwxCQ6fnhCDM920tNcsR9BkVE2xB343VVhVgu1QoUPxiyLwo7B3ant26PGx5wFZh3mh
         PMalnEcXMiF5/p+4LJHYpNT6lrSSzVUsYsVdhi4vpbyQMoVJ8/50wzrF2bfgjtk0IYo0
         CyTK9+BUUfMv5kceI8fYv+i/3/AXxAeALcAwS+/uxbshZJFY5f9SMJEXFSPTrXmrMLYk
         80Gw==
X-Gm-Message-State: AOAM530tKkBpcEKuIvGPcsAw5YG/BWR/qzr9VuKO70bhOOVvptPMcZyx
        PK7EzoPbIlWQgFe/yvlu8Gk=
X-Google-Smtp-Source: ABdhPJz5In3X7RO+oSLI3Izkzqq0NPz7/2rp7WFoTcoPnll+hUVKyvCkCDqbm6IM0ieo6HBUvmeoLQ==
X-Received: by 2002:a17:90a:ff12:: with SMTP id ce18mr2417277pjb.215.1623385489673;
        Thu, 10 Jun 2021 21:24:49 -0700 (PDT)
Received: from ast-mbp.thefacebook.com ([2620:10d:c090:400::5:7360])
        by smtp.gmail.com with ESMTPSA id p11sm3942234pgn.65.2021.06.10.21.24.47
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 10 Jun 2021 21:24:49 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, andrii@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH v2 bpf-next 2/3] bpf: Add verifier checks for bpf_timer.
Date:   Thu, 10 Jun 2021 21:24:41 -0700
Message-Id: <20210611042442.65444-3-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.13.5
In-Reply-To: <20210611042442.65444-1-alexei.starovoitov@gmail.com>
References: <20210611042442.65444-1-alexei.starovoitov@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>

Add appropriate safety checks for bpf_timer:
- restrict to array, hash, lru. per-cpu maps cannot be supported.
- kfree bpf_timer during map_delete_elem and map_free.
- verifier btf checks.
- safe interaction with lookup/update/delete operations and iterator.
- relax the first field only requirement of the previous patch.
- search for bpf_timer in datasec in case it was placed in global data.
- check prog_rdonly, frozen flags.
- mmap is not allowed.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 include/linux/bpf.h        | 45 ++++++++++++++++------
 include/linux/btf.h        |  1 +
 kernel/bpf/arraymap.c      | 14 +++++++
 kernel/bpf/btf.c           | 77 +++++++++++++++++++++++++++++++-------
 kernel/bpf/hashtab.c       | 56 +++++++++++++++++++++------
 kernel/bpf/helpers.c       |  2 +-
 kernel/bpf/local_storage.c |  4 +-
 kernel/bpf/map_in_map.c    |  1 +
 kernel/bpf/syscall.c       | 21 +++++++++--
 kernel/bpf/verifier.c      | 30 +++++++++++++--
 10 files changed, 205 insertions(+), 46 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 3816b6bae6d3..7c403235c7e8 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -168,6 +168,7 @@ struct bpf_map {
 	u32 max_entries;
 	u32 map_flags;
 	int spin_lock_off; /* >=0 valid offset, <0 error */
+	int timer_off; /* >=0 valid offset, <0 error */
 	u32 id;
 	int numa_node;
 	u32 btf_key_type_id;
@@ -197,24 +198,46 @@ static inline bool map_value_has_spin_lock(const struct bpf_map *map)
 	return map->spin_lock_off >= 0;
 }
 
-static inline void check_and_init_map_lock(struct bpf_map *map, void *dst)
+static inline bool map_value_has_timer(const struct bpf_map *map)
 {
-	if (likely(!map_value_has_spin_lock(map)))
-		return;
-	*(struct bpf_spin_lock *)(dst + map->spin_lock_off) =
-		(struct bpf_spin_lock){};
+	return map->timer_off >= 0;
 }
 
-/* copy everything but bpf_spin_lock */
+static inline void check_and_init_map_value(struct bpf_map *map, void *dst)
+{
+	if (unlikely(map_value_has_spin_lock(map)))
+		*(struct bpf_spin_lock *)(dst + map->spin_lock_off) =
+			(struct bpf_spin_lock){};
+	if (unlikely(map_value_has_timer(map)))
+		*(struct bpf_timer *)(dst + map->timer_off) =
+			(struct bpf_timer){};
+}
+
+/* copy everything but bpf_spin_lock and bpf_timer. There could be one of each. */
 static inline void copy_map_value(struct bpf_map *map, void *dst, void *src)
 {
+	u32 s_off = 0, s_sz = 0, t_off = 0, t_sz = 0;
+
 	if (unlikely(map_value_has_spin_lock(map))) {
-		u32 off = map->spin_lock_off;
+		s_off = map->spin_lock_off;
+		s_sz = sizeof(struct bpf_spin_lock);
+	} else if (unlikely(map_value_has_timer(map))) {
+		t_off = map->timer_off;
+		t_sz = sizeof(struct bpf_timer);
+	}
 
-		memcpy(dst, src, off);
-		memcpy(dst + off + sizeof(struct bpf_spin_lock),
-		       src + off + sizeof(struct bpf_spin_lock),
-		       map->value_size - off - sizeof(struct bpf_spin_lock));
+	if (unlikely(s_sz || t_sz)) {
+		if (s_off < t_off || !s_sz) {
+			swap(s_off, t_off);
+			swap(s_sz, t_sz);
+		}
+		memcpy(dst, src, t_off);
+		memcpy(dst + t_off + t_sz,
+		       src + t_off + t_sz,
+		       s_off - t_off - t_sz);
+		memcpy(dst + s_off + s_sz,
+		       src + s_off + s_sz,
+		       map->value_size - s_off - s_sz);
 	} else {
 		memcpy(dst, src, map->value_size);
 	}
diff --git a/include/linux/btf.h b/include/linux/btf.h
index 94a0c976c90f..214fde93214b 100644
--- a/include/linux/btf.h
+++ b/include/linux/btf.h
@@ -99,6 +99,7 @@ bool btf_member_is_reg_int(const struct btf *btf, const struct btf_type *s,
 			   const struct btf_member *m,
 			   u32 expected_offset, u32 expected_size);
 int btf_find_spin_lock(const struct btf *btf, const struct btf_type *t);
+int btf_find_timer(const struct btf *btf, const struct btf_type *t);
 bool btf_type_is_void(const struct btf_type *t);
 s32 btf_find_by_name_kind(const struct btf *btf, const char *name, u8 kind);
 const struct btf_type *btf_type_skip_modifiers(const struct btf *btf,
diff --git a/kernel/bpf/arraymap.c b/kernel/bpf/arraymap.c
index 3c4105603f9d..5c84ab7f8872 100644
--- a/kernel/bpf/arraymap.c
+++ b/kernel/bpf/arraymap.c
@@ -287,6 +287,12 @@ static int array_map_get_next_key(struct bpf_map *map, void *key, void *next_key
 	return 0;
 }
 
+static void check_and_free_timer_in_array(struct bpf_array *arr, void *val)
+{
+	if (unlikely(map_value_has_timer(&arr->map)))
+		bpf_timer_cancel_and_free(val + arr->map.timer_off);
+}
+
 /* Called from syscall or from eBPF program */
 static int array_map_update_elem(struct bpf_map *map, void *key, void *value,
 				 u64 map_flags)
@@ -321,6 +327,7 @@ static int array_map_update_elem(struct bpf_map *map, void *key, void *value,
 			copy_map_value_locked(map, val, value, false);
 		else
 			copy_map_value(map, val, value);
+		check_and_free_timer_in_array(array, val);
 	}
 	return 0;
 }
@@ -378,10 +385,17 @@ static void *array_map_vmalloc_addr(struct bpf_array *array)
 static void array_map_free(struct bpf_map *map)
 {
 	struct bpf_array *array = container_of(map, struct bpf_array, map);
+	int i;
 
 	if (array->map.map_type == BPF_MAP_TYPE_PERCPU_ARRAY)
 		bpf_array_free_percpu(array);
 
+	if (unlikely(map_value_has_timer(map)))
+		for (i = 0; i < array->map.max_entries; i++)
+			bpf_timer_cancel_and_free(array->value +
+						  array->elem_size * i +
+						  map->timer_off);
+
 	if (array->map.map_flags & BPF_F_MMAPABLE)
 		bpf_map_area_free(array_map_vmalloc_addr(array));
 	else
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index a6e39c5ea0bf..28a8014b8379 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -3046,43 +3046,92 @@ static void btf_struct_log(struct btf_verifier_env *env,
 	btf_verifier_log(env, "size=%u vlen=%u", t->size, btf_type_vlen(t));
 }
 
-/* find 'struct bpf_spin_lock' in map value.
- * return >= 0 offset if found
- * and < 0 in case of error
- */
-int btf_find_spin_lock(const struct btf *btf, const struct btf_type *t)
+static int btf_find_struct_field(const struct btf *btf, const struct btf_type *t,
+				 const char *name, int sz, int align)
 {
 	const struct btf_member *member;
 	u32 i, off = -ENOENT;
 
-	if (!__btf_type_is_struct(t))
-		return -EINVAL;
-
 	for_each_member(i, t, member) {
 		const struct btf_type *member_type = btf_type_by_id(btf,
 								    member->type);
 		if (!__btf_type_is_struct(member_type))
 			continue;
-		if (member_type->size != sizeof(struct bpf_spin_lock))
+		if (member_type->size != sz)
 			continue;
-		if (strcmp(__btf_name_by_offset(btf, member_type->name_off),
-			   "bpf_spin_lock"))
+		if (strcmp(__btf_name_by_offset(btf, member_type->name_off), name))
 			continue;
 		if (off != -ENOENT)
-			/* only one 'struct bpf_spin_lock' is allowed */
+			/* only one such field is allowed */
 			return -E2BIG;
 		off = btf_member_bit_offset(t, member);
 		if (off % 8)
 			/* valid C code cannot generate such BTF */
 			return -EINVAL;
 		off /= 8;
-		if (off % __alignof__(struct bpf_spin_lock))
-			/* valid struct bpf_spin_lock will be 4 byte aligned */
+		if (off % align)
+			return -EINVAL;
+	}
+	return off;
+}
+
+static int btf_find_datasec_var(const struct btf *btf, const struct btf_type *t,
+				const char *name, int sz, int align)
+{
+	const struct btf_var_secinfo *vsi;
+	u32 i, off = -ENOENT;
+
+	for_each_vsi(i, t, vsi) {
+		const struct btf_type *var = btf_type_by_id(btf, vsi->type);
+		const struct btf_type *var_type = btf_type_by_id(btf, var->type);
+
+		if (!__btf_type_is_struct(var_type))
+			continue;
+		if (var_type->size != sz)
+			continue;
+		if (vsi->size != sz)
+			continue;
+		if (strcmp(__btf_name_by_offset(btf, var_type->name_off), name))
+			continue;
+		if (off != -ENOENT)
+			/* only one such field is allowed */
+			return -E2BIG;
+		off = vsi->offset;
+		if (off % align)
 			return -EINVAL;
 	}
 	return off;
 }
 
+static int btf_find_field(const struct btf *btf, const struct btf_type *t,
+			  const char *name, int sz, int align)
+{
+
+	if (__btf_type_is_struct(t))
+		return btf_find_struct_field(btf, t, name, sz, align);
+	else if (btf_type_is_datasec(t))
+		return btf_find_datasec_var(btf, t, name, sz, align);
+	return -EINVAL;
+}
+
+/* find 'struct bpf_spin_lock' in map value.
+ * return >= 0 offset if found
+ * and < 0 in case of error
+ */
+int btf_find_spin_lock(const struct btf *btf, const struct btf_type *t)
+{
+	return btf_find_field(btf, t, "bpf_spin_lock",
+			      sizeof(struct bpf_spin_lock),
+			      __alignof__(struct bpf_spin_lock));
+}
+
+int btf_find_timer(const struct btf *btf, const struct btf_type *t)
+{
+	return btf_find_field(btf, t, "bpf_timer",
+			      sizeof(struct bpf_timer),
+			      __alignof__(struct bpf_timer));
+}
+
 static void __btf_struct_show(const struct btf *btf, const struct btf_type *t,
 			      u32 type_id, void *data, u8 bits_offset,
 			      struct btf_show *show)
diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
index 6f6681b07364..c885492d0a76 100644
--- a/kernel/bpf/hashtab.c
+++ b/kernel/bpf/hashtab.c
@@ -244,6 +244,17 @@ static void htab_free_elems(struct bpf_htab *htab)
 		cond_resched();
 	}
 free_elems:
+	if (unlikely(map_value_has_timer(&htab->map)))
+		for (i = 0; i < htab->map.max_entries; i++) {
+			struct htab_elem *elem;
+
+			elem = get_htab_elem(htab, i);
+			bpf_timer_cancel_and_free(elem->key +
+						  round_up(htab->map.key_size, 8) +
+						  htab->map.timer_off);
+			cond_resched();
+		}
+
 	bpf_map_area_free(htab->elems);
 }
 
@@ -265,8 +276,11 @@ static struct htab_elem *prealloc_lru_pop(struct bpf_htab *htab, void *key,
 	struct htab_elem *l;
 
 	if (node) {
+		u32 key_size = htab->map.key_size;
 		l = container_of(node, struct htab_elem, lru_node);
-		memcpy(l->key, key, htab->map.key_size);
+		memcpy(l->key, key, key_size);
+		check_and_init_map_value(&htab->map,
+					 l->key + round_up(key_size, 8));
 		return l;
 	}
 
@@ -694,6 +708,14 @@ static int htab_lru_map_gen_lookup(struct bpf_map *map,
 	return insn - insn_buf;
 }
 
+static void check_and_free_timer(struct bpf_htab *htab, struct htab_elem *elem)
+{
+	if (unlikely(map_value_has_timer(&htab->map)))
+		bpf_timer_cancel_and_free(elem->key +
+					  round_up(htab->map.key_size, 8) +
+					  htab->map.timer_off);
+}
+
 /* It is called from the bpf_lru_list when the LRU needs to delete
  * older elements from the htab.
  */
@@ -718,6 +740,7 @@ static bool htab_lru_map_delete_node(void *arg, struct bpf_lru_node *node)
 	hlist_nulls_for_each_entry_rcu(l, n, head, hash_node)
 		if (l == tgt_l) {
 			hlist_nulls_del_rcu(&l->hash_node);
+			check_and_free_timer(htab, l);
 			break;
 		}
 
@@ -789,6 +812,7 @@ static void htab_elem_free(struct bpf_htab *htab, struct htab_elem *l)
 {
 	if (htab->map.map_type == BPF_MAP_TYPE_PERCPU_HASH)
 		free_percpu(htab_elem_get_ptr(l, htab->map.key_size));
+	check_and_free_timer(htab, l);
 	kfree(l);
 }
 
@@ -816,6 +840,7 @@ static void free_htab_elem(struct bpf_htab *htab, struct htab_elem *l)
 	htab_put_fd_value(htab, l);
 
 	if (htab_is_prealloc(htab)) {
+		check_and_free_timer(htab, l);
 		__pcpu_freelist_push(&htab->freelist, &l->fnode);
 	} else {
 		atomic_dec(&htab->count);
@@ -919,8 +944,8 @@ static struct htab_elem *alloc_htab_elem(struct bpf_htab *htab, void *key,
 			l_new = ERR_PTR(-ENOMEM);
 			goto dec_count;
 		}
-		check_and_init_map_lock(&htab->map,
-					l_new->key + round_up(key_size, 8));
+		check_and_init_map_value(&htab->map,
+					 l_new->key + round_up(key_size, 8));
 	}
 
 	memcpy(l_new->key, key, key_size);
@@ -1060,6 +1085,8 @@ static int htab_map_update_elem(struct bpf_map *map, void *key, void *value,
 		hlist_nulls_del_rcu(&l_old->hash_node);
 		if (!htab_is_prealloc(htab))
 			free_htab_elem(htab, l_old);
+		else
+			check_and_free_timer(htab, l_old);
 	}
 	ret = 0;
 err:
@@ -1067,6 +1094,12 @@ static int htab_map_update_elem(struct bpf_map *map, void *key, void *value,
 	return ret;
 }
 
+static void htab_lru_push_free(struct bpf_htab *htab, struct htab_elem *elem)
+{
+	check_and_free_timer(htab, elem);
+	bpf_lru_push_free(&htab->lru, &elem->lru_node);
+}
+
 static int htab_lru_map_update_elem(struct bpf_map *map, void *key, void *value,
 				    u64 map_flags)
 {
@@ -1099,7 +1132,8 @@ static int htab_lru_map_update_elem(struct bpf_map *map, void *key, void *value,
 	l_new = prealloc_lru_pop(htab, key, hash);
 	if (!l_new)
 		return -ENOMEM;
-	memcpy(l_new->key + round_up(map->key_size, 8), value, map->value_size);
+	copy_map_value(&htab->map,
+		       l_new->key + round_up(map->key_size, 8), value);
 
 	ret = htab_lock_bucket(htab, b, hash, &flags);
 	if (ret)
@@ -1125,9 +1159,9 @@ static int htab_lru_map_update_elem(struct bpf_map *map, void *key, void *value,
 	htab_unlock_bucket(htab, b, hash, flags);
 
 	if (ret)
-		bpf_lru_push_free(&htab->lru, &l_new->lru_node);
+		htab_lru_push_free(htab, l_new);
 	else if (l_old)
-		bpf_lru_push_free(&htab->lru, &l_old->lru_node);
+		htab_lru_push_free(htab, l_old);
 
 	return ret;
 }
@@ -1332,7 +1366,7 @@ static int htab_lru_map_delete_elem(struct bpf_map *map, void *key)
 
 	htab_unlock_bucket(htab, b, hash, flags);
 	if (l)
-		bpf_lru_push_free(&htab->lru, &l->lru_node);
+		htab_lru_push_free(htab, l);
 	return ret;
 }
 
@@ -1449,7 +1483,7 @@ static int __htab_map_lookup_and_delete_elem(struct bpf_map *map, void *key,
 			else
 				copy_map_value(map, value, l->key +
 					       roundup_key_size);
-			check_and_init_map_lock(map, value);
+			check_and_init_map_value(map, value);
 		}
 
 		hlist_nulls_del_rcu(&l->hash_node);
@@ -1460,7 +1494,7 @@ static int __htab_map_lookup_and_delete_elem(struct bpf_map *map, void *key,
 	htab_unlock_bucket(htab, b, hash, bflags);
 
 	if (is_lru_map && l)
-		bpf_lru_push_free(&htab->lru, &l->lru_node);
+		htab_lru_push_free(htab, l);
 
 	return ret;
 }
@@ -1638,7 +1672,7 @@ __htab_map_lookup_and_delete_batch(struct bpf_map *map,
 						      true);
 			else
 				copy_map_value(map, dst_val, value);
-			check_and_init_map_lock(map, dst_val);
+			check_and_init_map_value(map, dst_val);
 		}
 		if (do_delete) {
 			hlist_nulls_del_rcu(&l->hash_node);
@@ -1665,7 +1699,7 @@ __htab_map_lookup_and_delete_batch(struct bpf_map *map,
 	while (node_to_free) {
 		l = node_to_free;
 		node_to_free = node_to_free->batch_flink;
-		bpf_lru_push_free(&htab->lru, &l->lru_node);
+		htab_lru_push_free(htab, l);
 	}
 
 next_batch:
diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index 3a693d451ca3..b8df592c33cc 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -1072,7 +1072,7 @@ BPF_CALL_5(bpf_timer_init, struct bpf_timer_kern *, timer, void *, cb, int, flag
 		goto out;
 	}
 	t->callback_fn = cb;
-	t->value = (void *)timer /* - offset of bpf_timer inside elem */;
+	t->value = (void *)timer - map->timer_off;
 	t->map = map;
 	t->prog = prog;
 	hrtimer_init(&t->timer, clockid, HRTIMER_MODE_REL_SOFT);
diff --git a/kernel/bpf/local_storage.c b/kernel/bpf/local_storage.c
index bd11db9774c3..95d70a08325d 100644
--- a/kernel/bpf/local_storage.c
+++ b/kernel/bpf/local_storage.c
@@ -173,7 +173,7 @@ static int cgroup_storage_update_elem(struct bpf_map *map, void *key,
 		return -ENOMEM;
 
 	memcpy(&new->data[0], value, map->value_size);
-	check_and_init_map_lock(map, new->data);
+	check_and_init_map_value(map, new->data);
 
 	new = xchg(&storage->buf, new);
 	kfree_rcu(new, rcu);
@@ -509,7 +509,7 @@ struct bpf_cgroup_storage *bpf_cgroup_storage_alloc(struct bpf_prog *prog,
 						    map->numa_node);
 		if (!storage->buf)
 			goto enomem;
-		check_and_init_map_lock(map, storage->buf->data);
+		check_and_init_map_value(map, storage->buf->data);
 	} else {
 		storage->percpu_buf = bpf_map_alloc_percpu(map, size, 8, gfp);
 		if (!storage->percpu_buf)
diff --git a/kernel/bpf/map_in_map.c b/kernel/bpf/map_in_map.c
index 39ab0b68cade..2f961b941159 100644
--- a/kernel/bpf/map_in_map.c
+++ b/kernel/bpf/map_in_map.c
@@ -50,6 +50,7 @@ struct bpf_map *bpf_map_meta_alloc(int inner_map_ufd)
 	inner_map_meta->map_flags = inner_map->map_flags;
 	inner_map_meta->max_entries = inner_map->max_entries;
 	inner_map_meta->spin_lock_off = inner_map->spin_lock_off;
+	inner_map_meta->timer_off = inner_map->timer_off;
 
 	/* Misc members not needed in bpf_map_meta_equal() check. */
 	inner_map_meta->ops = inner_map->ops;
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 50457019da27..0e53f9e10e1a 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -259,8 +259,8 @@ static int bpf_map_copy_value(struct bpf_map *map, void *key, void *value,
 				copy_map_value_locked(map, value, ptr, true);
 			else
 				copy_map_value(map, value, ptr);
-			/* mask lock, since value wasn't zero inited */
-			check_and_init_map_lock(map, value);
+			/* mask lock and timer, since value wasn't zero inited */
+			check_and_init_map_value(map, value);
 		}
 		rcu_read_unlock();
 	}
@@ -622,7 +622,8 @@ static int bpf_map_mmap(struct file *filp, struct vm_area_struct *vma)
 	struct bpf_map *map = filp->private_data;
 	int err;
 
-	if (!map->ops->map_mmap || map_value_has_spin_lock(map))
+	if (!map->ops->map_mmap || map_value_has_spin_lock(map) ||
+	    map_value_has_timer(map))
 		return -ENOTSUPP;
 
 	if (!(vma->vm_flags & VM_SHARED))
@@ -792,6 +793,16 @@ static int map_check_btf(struct bpf_map *map, const struct btf *btf,
 		}
 	}
 
+	map->timer_off = btf_find_timer(btf, value_type);
+	if (map_value_has_timer(map)) {
+		if (map->map_flags & BPF_F_RDONLY_PROG)
+			return -EACCES;
+		if (map->map_type != BPF_MAP_TYPE_HASH &&
+		    map->map_type != BPF_MAP_TYPE_LRU_HASH &&
+		    map->map_type != BPF_MAP_TYPE_ARRAY)
+			return -ENOTSUPP;
+	}
+
 	if (map->ops->map_check_btf)
 		ret = map->ops->map_check_btf(map, btf, key_type, value_type);
 
@@ -843,6 +854,7 @@ static int map_create(union bpf_attr *attr)
 	mutex_init(&map->freeze_mutex);
 
 	map->spin_lock_off = -EINVAL;
+	map->timer_off = -EINVAL;
 	if (attr->btf_key_type_id || attr->btf_value_type_id ||
 	    /* Even the map's value is a kernel's struct,
 	     * the bpf_prog.o must have BTF to begin with
@@ -1590,7 +1602,8 @@ static int map_freeze(const union bpf_attr *attr)
 	if (IS_ERR(map))
 		return PTR_ERR(map);
 
-	if (map->map_type == BPF_MAP_TYPE_STRUCT_OPS) {
+	if (map->map_type == BPF_MAP_TYPE_STRUCT_OPS ||
+	    map_value_has_timer(map)) {
 		fdput(f);
 		return -ENOTSUPP;
 	}
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 44ec9760b562..0ddafa91d0d3 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -3241,6 +3241,15 @@ static int check_map_access(struct bpf_verifier_env *env, u32 regno,
 			return -EACCES;
 		}
 	}
+	if (map_value_has_timer(map)) {
+		u32 t = map->timer_off;
+
+		if (reg->smin_value + off < t + sizeof(struct bpf_timer) &&
+		     t < reg->umax_value + off + size) {
+			verbose(env, "bpf_timer cannot be accessed directly by load/store\n");
+			return -EACCES;
+		}
+	}
 	return err;
 }
 
@@ -4675,9 +4684,24 @@ static int process_timer_func(struct bpf_verifier_env *env, int regno,
 			map->name);
 		return -EINVAL;
 	}
-	if (val) {
-		/* This restriction will be removed in the next patch */
-		verbose(env, "bpf_timer field can only be first in the map value element\n");
+	if (!map_value_has_timer(map)) {
+		if (map->timer_off == -E2BIG)
+			verbose(env,
+				"map '%s' has more than one 'struct bpf_timer'\n",
+				map->name);
+		else if (map->timer_off == -ENOENT)
+			verbose(env,
+				"map '%s' doesn't have 'struct bpf_timer'\n",
+				map->name);
+		else
+			verbose(env,
+				"map '%s' is not a struct type or bpf_timer is mangled\n",
+				map->name);
+		return -EINVAL;
+	}
+	if (map->timer_off != val + reg->off) {
+		verbose(env, "off %lld doesn't point to 'struct bpf_timer' that is at %d\n",
+			val + reg->off, map->timer_off);
 		return -EINVAL;
 	}
 	WARN_ON(meta->map_ptr);
-- 
2.30.2

