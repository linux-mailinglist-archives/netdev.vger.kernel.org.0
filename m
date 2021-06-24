Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E555D3B24F3
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 04:25:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229934AbhFXC1s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 22:27:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229826AbhFXC1p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Jun 2021 22:27:45 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6BA5C061756;
        Wed, 23 Jun 2021 19:25:25 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id x22so2141177pll.11;
        Wed, 23 Jun 2021 19:25:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=k8Jw4gU9Aag+N2sJA25ZSQ9Q6N8K+VrWQzo9FeBc4Ng=;
        b=dSW9J3MCQ78Sd+2k+HwW4YKpWjjYtfylvVJKrNewTQtCgBiRwClp0CWv7gfZh+7M7l
         cwok6k7d/jzNnTyySFi5cCuxYjJVq4b/BXHJvfpC9h2Qvvv4SmHGzXgm821ZbIe5rpvO
         taBnexsDk3344xBQ0jn8H1SRie5Pnt5Dd7e2b3Ri6ZWy9bg/h1f89OT6HvF0/YxBJcGK
         PvXkxrkmXAEveRsMi9ysozgV+Cm2SivysPJf9x2p/WpIIWoJXgqBhTtnQ3FaDQ0fB6i6
         NaiK3+/KDW6craKSSz6RPzCZ1IqVbd3r3q1iW0vB+knAf2bSR+yNv5xrrqknNlLzxsG4
         gYzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=k8Jw4gU9Aag+N2sJA25ZSQ9Q6N8K+VrWQzo9FeBc4Ng=;
        b=hBqtXBXBWtbMgjXW3eoBt8Udm2TqEm3ZMEBXCiH5iIxLP0k3FD6Gs2HE85bT+gZvZp
         KHCW3Q/ir2vFnzW1lcWKuxiE19AqwiHyLF8mFxvYFOfuytJqFmSSRjaM5UsQu/npXw7X
         TU5s9em7Y0WvMIxmi01ofmvFhGh7UT1YExdTCI6LtVo+WepiRqx9FhaXbl0U4G0Wt73i
         KBjsNtONLPoWNu6RV3vTXE7nvaVXtPBGHvM4ldRGf3tT5TztfvXK4SXLnaAJHkZSgNZ+
         gBv50QZ2vuW2aNXP2KhNklVFm0um9WHqWqMnzNky9z/gcYMejQSeWIbvpl2bRUyQjWww
         oiVg==
X-Gm-Message-State: AOAM5330tUVq63TN7Lkduwbes1u4poAQDaLI0GGjivYXG15x0+Qo5ilc
        6ocs8hsSgoLwn3NbGnvzQ4k=
X-Google-Smtp-Source: ABdhPJwQoBWKQ1pvrTzrvhlpgCIICBo33t1i50XmQpbiIQRwhM07h6klAbeGKAUi0Z/TO0aaXR6J0g==
X-Received: by 2002:a17:90a:1d0e:: with SMTP id c14mr12814954pjd.171.1624501525281;
        Wed, 23 Jun 2021 19:25:25 -0700 (PDT)
Received: from ast-mbp.thefacebook.com ([2620:10d:c090:400::5:a319])
        by smtp.gmail.com with ESMTPSA id f17sm4675965pjj.21.2021.06.23.19.25.23
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 23 Jun 2021 19:25:24 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, andrii@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH v3 bpf-next 2/8] bpf: Add map side support for bpf timers.
Date:   Wed, 23 Jun 2021 19:25:12 -0700
Message-Id: <20210624022518.57875-3-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.13.5
In-Reply-To: <20210624022518.57875-1-alexei.starovoitov@gmail.com>
References: <20210624022518.57875-1-alexei.starovoitov@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>

Restrict bpf timers to array, hash (both preallocated and kmalloced), and
lru map types. The per-cpu maps with timers don't make sense, since 'struct
bpf_timer' is a part of map value. bpf timers in per-cpu maps would mean that
the number of timers depends on number of possible cpus and timers would not be
accessible from all cpus. lpm map support can be added in the future.
The timers in inner maps are supported.

The bpf_map_update/delete_elem() helpers and sys_bpf commands cancel and free
bpf_timer in a given map element.

Similar to 'struct bpf_spin_lock' BTF is required and it is used to validate
that map element indeed contains 'struct bpf_timer'.

Make check_and_init_map_value() init both bpf_spin_lock and bpf_timer when
map element data is reused in preallocated htab and lru maps.

Teach copy_map_value() to support both bpf_spin_lock and bpf_timer in a single
map element. There could be one of each, but not more than one. Due to 'one
bpf_timer in one element' restriction do not support timers in global data,
since global data is a map of single element, but from bpf program side it's
seen as many global variables and restriction of single global timer would be
odd. The sys_bpf map_freeze and sys_mmap syscalls are not allowed on maps with
timers, since user space could have corrupted mmap element and crashed the
kernel. The maps with timers cannot be readonly. Due to these restrictions
search for bpf_timer in datasec BTF in case it was placed in the global data to
report clear error.

The previous patch allowed 'struct bpf_timer' as a first field in a map
element only. Relax this restriction.

Refactor lru map to s/bpf_lru_push_free/htab_lru_push_free/ to cancel and free
the timer when lru map deletes an element as a part of it eviction algorithm.

Make sure that bpf program cannot access 'struct bpf_timer' via direct load/store.
The timer operation are done through helpers only.
This is similar to 'struct bpf_spin_lock'.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 include/linux/bpf.h        | 44 ++++++++++++-----
 include/linux/btf.h        |  1 +
 kernel/bpf/arraymap.c      | 22 +++++++++
 kernel/bpf/btf.c           | 77 ++++++++++++++++++++++++------
 kernel/bpf/hashtab.c       | 96 +++++++++++++++++++++++++++++++++-----
 kernel/bpf/local_storage.c |  4 +-
 kernel/bpf/map_in_map.c    |  1 +
 kernel/bpf/syscall.c       | 21 +++++++--
 kernel/bpf/verifier.c      | 30 ++++++++++--
 9 files changed, 251 insertions(+), 45 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 72da9d4d070c..90e6c6d1404c 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -198,24 +198,46 @@ static inline bool map_value_has_spin_lock(const struct bpf_map *map)
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
index 3c4105603f9d..7f07bb7adf63 100644
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
@@ -374,6 +381,19 @@ static void *array_map_vmalloc_addr(struct bpf_array *array)
 	return (void *)round_down((unsigned long)array, PAGE_SIZE);
 }
 
+static void array_map_free_timers(struct bpf_map *map)
+{
+	struct bpf_array *array = container_of(map, struct bpf_array, map);
+	int i;
+
+	if (likely(!map_value_has_timer(map)))
+		return;
+
+	for (i = 0; i < array->map.max_entries; i++)
+		bpf_timer_cancel_and_free(array->value + array->elem_size * i +
+					  map->timer_off);
+}
+
 /* Called when map->refcnt goes to zero, either from workqueue or from syscall */
 static void array_map_free(struct bpf_map *map)
 {
@@ -382,6 +402,7 @@ static void array_map_free(struct bpf_map *map)
 	if (array->map.map_type == BPF_MAP_TYPE_PERCPU_ARRAY)
 		bpf_array_free_percpu(array);
 
+	array_map_free_timers(map);
 	if (array->map.map_flags & BPF_F_MMAPABLE)
 		bpf_map_area_free(array_map_vmalloc_addr(array));
 	else
@@ -668,6 +689,7 @@ const struct bpf_map_ops array_map_ops = {
 	.map_alloc = array_map_alloc,
 	.map_free = array_map_free,
 	.map_get_next_key = array_map_get_next_key,
+	.map_release_uref = array_map_free_timers,
 	.map_lookup_elem = array_map_lookup_elem,
 	.map_update_elem = array_map_update_elem,
 	.map_delete_elem = array_map_delete_elem,
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index cb4b72997d9b..7780131f710e 100644
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
index 6f6681b07364..e85a5839ffe8 100644
--- a/kernel/bpf/hashtab.c
+++ b/kernel/bpf/hashtab.c
@@ -228,6 +228,28 @@ static struct htab_elem *get_htab_elem(struct bpf_htab *htab, int i)
 	return (struct htab_elem *) (htab->elems + i * (u64)htab->elem_size);
 }
 
+static void htab_free_prealloced_timers(struct bpf_htab *htab)
+{
+	u32 num_entries = htab->map.max_entries;
+	int i;
+
+	if (likely(!map_value_has_timer(&htab->map)))
+		return;
+	if (!htab_is_percpu(htab) && !htab_is_lru(htab))
+		/* htab has extra_elems */
+		num_entries += num_possible_cpus();
+
+	for (i = 0; i < num_entries; i++) {
+		struct htab_elem *elem;
+
+		elem = get_htab_elem(htab, i);
+		bpf_timer_cancel_and_free(elem->key +
+					  round_up(htab->map.key_size, 8) +
+					  htab->map.timer_off);
+		cond_resched();
+	}
+}
+
 static void htab_free_elems(struct bpf_htab *htab)
 {
 	int i;
@@ -244,6 +266,7 @@ static void htab_free_elems(struct bpf_htab *htab)
 		cond_resched();
 	}
 free_elems:
+	htab_free_prealloced_timers(htab);
 	bpf_map_area_free(htab->elems);
 }
 
@@ -265,8 +288,11 @@ static struct htab_elem *prealloc_lru_pop(struct bpf_htab *htab, void *key,
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
 
@@ -694,6 +720,14 @@ static int htab_lru_map_gen_lookup(struct bpf_map *map,
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
@@ -718,6 +752,7 @@ static bool htab_lru_map_delete_node(void *arg, struct bpf_lru_node *node)
 	hlist_nulls_for_each_entry_rcu(l, n, head, hash_node)
 		if (l == tgt_l) {
 			hlist_nulls_del_rcu(&l->hash_node);
+			check_and_free_timer(htab, l);
 			break;
 		}
 
@@ -789,6 +824,7 @@ static void htab_elem_free(struct bpf_htab *htab, struct htab_elem *l)
 {
 	if (htab->map.map_type == BPF_MAP_TYPE_PERCPU_HASH)
 		free_percpu(htab_elem_get_ptr(l, htab->map.key_size));
+	check_and_free_timer(htab, l);
 	kfree(l);
 }
 
@@ -816,6 +852,7 @@ static void free_htab_elem(struct bpf_htab *htab, struct htab_elem *l)
 	htab_put_fd_value(htab, l);
 
 	if (htab_is_prealloc(htab)) {
+		check_and_free_timer(htab, l);
 		__pcpu_freelist_push(&htab->freelist, &l->fnode);
 	} else {
 		atomic_dec(&htab->count);
@@ -919,8 +956,8 @@ static struct htab_elem *alloc_htab_elem(struct bpf_htab *htab, void *key,
 			l_new = ERR_PTR(-ENOMEM);
 			goto dec_count;
 		}
-		check_and_init_map_lock(&htab->map,
-					l_new->key + round_up(key_size, 8));
+		check_and_init_map_value(&htab->map,
+					 l_new->key + round_up(key_size, 8));
 	}
 
 	memcpy(l_new->key, key, key_size);
@@ -1060,6 +1097,8 @@ static int htab_map_update_elem(struct bpf_map *map, void *key, void *value,
 		hlist_nulls_del_rcu(&l_old->hash_node);
 		if (!htab_is_prealloc(htab))
 			free_htab_elem(htab, l_old);
+		else
+			check_and_free_timer(htab, l_old);
 	}
 	ret = 0;
 err:
@@ -1067,6 +1106,12 @@ static int htab_map_update_elem(struct bpf_map *map, void *key, void *value,
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
@@ -1099,7 +1144,8 @@ static int htab_lru_map_update_elem(struct bpf_map *map, void *key, void *value,
 	l_new = prealloc_lru_pop(htab, key, hash);
 	if (!l_new)
 		return -ENOMEM;
-	memcpy(l_new->key + round_up(map->key_size, 8), value, map->value_size);
+	copy_map_value(&htab->map,
+		       l_new->key + round_up(map->key_size, 8), value);
 
 	ret = htab_lock_bucket(htab, b, hash, &flags);
 	if (ret)
@@ -1125,9 +1171,9 @@ static int htab_lru_map_update_elem(struct bpf_map *map, void *key, void *value,
 	htab_unlock_bucket(htab, b, hash, flags);
 
 	if (ret)
-		bpf_lru_push_free(&htab->lru, &l_new->lru_node);
+		htab_lru_push_free(htab, l_new);
 	else if (l_old)
-		bpf_lru_push_free(&htab->lru, &l_old->lru_node);
+		htab_lru_push_free(htab, l_old);
 
 	return ret;
 }
@@ -1332,7 +1378,7 @@ static int htab_lru_map_delete_elem(struct bpf_map *map, void *key)
 
 	htab_unlock_bucket(htab, b, hash, flags);
 	if (l)
-		bpf_lru_push_free(&htab->lru, &l->lru_node);
+		htab_lru_push_free(htab, l);
 	return ret;
 }
 
@@ -1352,6 +1398,32 @@ static void delete_all_elements(struct bpf_htab *htab)
 	}
 }
 
+static void htab_free_malloced_timers(struct bpf_htab *htab)
+{
+	int i;
+
+	for (i = 0; i < htab->n_buckets; i++) {
+		struct hlist_nulls_head *head = select_bucket(htab, i);
+		struct hlist_nulls_node *n;
+		struct htab_elem *l;
+
+		hlist_nulls_for_each_entry(l, n, head, hash_node)
+			check_and_free_timer(htab, l);
+	}
+}
+
+static void htab_map_free_timers(struct bpf_map *map)
+{
+	struct bpf_htab *htab = container_of(map, struct bpf_htab, map);
+
+	if (likely(!map_value_has_timer(&htab->map)))
+		return;
+	if (!htab_is_prealloc(htab))
+		htab_free_malloced_timers(htab);
+	else
+		htab_free_prealloced_timers(htab);
+}
+
 /* Called when map->refcnt goes to zero, either from workqueue or from syscall */
 static void htab_map_free(struct bpf_map *map)
 {
@@ -1449,7 +1521,7 @@ static int __htab_map_lookup_and_delete_elem(struct bpf_map *map, void *key,
 			else
 				copy_map_value(map, value, l->key +
 					       roundup_key_size);
-			check_and_init_map_lock(map, value);
+			check_and_init_map_value(map, value);
 		}
 
 		hlist_nulls_del_rcu(&l->hash_node);
@@ -1460,7 +1532,7 @@ static int __htab_map_lookup_and_delete_elem(struct bpf_map *map, void *key,
 	htab_unlock_bucket(htab, b, hash, bflags);
 
 	if (is_lru_map && l)
-		bpf_lru_push_free(&htab->lru, &l->lru_node);
+		htab_lru_push_free(htab, l);
 
 	return ret;
 }
@@ -1638,7 +1710,7 @@ __htab_map_lookup_and_delete_batch(struct bpf_map *map,
 						      true);
 			else
 				copy_map_value(map, dst_val, value);
-			check_and_init_map_lock(map, dst_val);
+			check_and_init_map_value(map, dst_val);
 		}
 		if (do_delete) {
 			hlist_nulls_del_rcu(&l->hash_node);
@@ -1665,7 +1737,7 @@ __htab_map_lookup_and_delete_batch(struct bpf_map *map,
 	while (node_to_free) {
 		l = node_to_free;
 		node_to_free = node_to_free->batch_flink;
-		bpf_lru_push_free(&htab->lru, &l->lru_node);
+		htab_lru_push_free(htab, l);
 	}
 
 next_batch:
@@ -2027,6 +2099,7 @@ const struct bpf_map_ops htab_map_ops = {
 	.map_alloc = htab_map_alloc,
 	.map_free = htab_map_free,
 	.map_get_next_key = htab_map_get_next_key,
+	.map_release_uref = htab_map_free_timers,
 	.map_lookup_elem = htab_map_lookup_elem,
 	.map_lookup_and_delete_elem = htab_map_lookup_and_delete_elem,
 	.map_update_elem = htab_map_update_elem,
@@ -2048,6 +2121,7 @@ const struct bpf_map_ops htab_lru_map_ops = {
 	.map_alloc = htab_map_alloc,
 	.map_free = htab_map_free,
 	.map_get_next_key = htab_map_get_next_key,
+	.map_release_uref = htab_map_free_timers,
 	.map_lookup_elem = htab_lru_map_lookup_elem,
 	.map_lookup_and_delete_elem = htab_lru_map_lookup_and_delete_elem,
 	.map_lookup_elem_sys_only = htab_lru_map_lookup_elem_sys,
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
index e343f158e556..29c1d2f8d94c 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -260,8 +260,8 @@ static int bpf_map_copy_value(struct bpf_map *map, void *key, void *value,
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
@@ -623,7 +623,8 @@ static int bpf_map_mmap(struct file *filp, struct vm_area_struct *vma)
 	struct bpf_map *map = filp->private_data;
 	int err;
 
-	if (!map->ops->map_mmap || map_value_has_spin_lock(map))
+	if (!map->ops->map_mmap || map_value_has_spin_lock(map) ||
+	    map_value_has_timer(map))
 		return -ENOTSUPP;
 
 	if (!(vma->vm_flags & VM_SHARED))
@@ -793,6 +794,16 @@ static int map_check_btf(struct bpf_map *map, const struct btf *btf,
 		}
 	}
 
+	map->timer_off = btf_find_timer(btf, value_type);
+	if (map_value_has_timer(map)) {
+		if (map->map_flags & BPF_F_RDONLY_PROG)
+			return -EACCES;
+		if (map->map_type != BPF_MAP_TYPE_HASH &&
+		    map->map_type != BPF_MAP_TYPE_LRU_HASH &&
+		    map->map_type != BPF_MAP_TYPE_ARRAY)
+			return -EOPNOTSUPP;
+	}
+
 	if (map->ops->map_check_btf)
 		ret = map->ops->map_check_btf(map, btf, key_type, value_type);
 
@@ -844,6 +855,7 @@ static int map_create(union bpf_attr *attr)
 	mutex_init(&map->freeze_mutex);
 
 	map->spin_lock_off = -EINVAL;
+	map->timer_off = -EINVAL;
 	if (attr->btf_key_type_id || attr->btf_value_type_id ||
 	    /* Even the map's value is a kernel's struct,
 	     * the bpf_prog.o must have BTF to begin with
@@ -1591,7 +1603,8 @@ static int map_freeze(const union bpf_attr *attr)
 	if (IS_ERR(map))
 		return PTR_ERR(map);
 
-	if (map->map_type == BPF_MAP_TYPE_STRUCT_OPS) {
+	if (map->map_type == BPF_MAP_TYPE_STRUCT_OPS ||
+	    map_value_has_timer(map)) {
 		fdput(f);
 		return -ENOTSUPP;
 	}
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index fa15bd30e331..7868481af61c 100644
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
 	if (meta->map_ptr) {
-- 
2.30.2

