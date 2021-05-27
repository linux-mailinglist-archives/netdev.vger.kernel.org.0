Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DCEC3925CE
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 06:03:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229672AbhE0EEn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 00:04:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229707AbhE0EEl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 May 2021 00:04:41 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70A06C061574;
        Wed, 26 May 2021 21:03:07 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id mp9-20020a17090b1909b029015fd1e3ad5aso1548704pjb.3;
        Wed, 26 May 2021 21:03:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=E3pX/gvL8yWQJckxUmg8dAnaOkARmPamj0hr7KGPAhU=;
        b=kvf10YXwyZw5yDuSfP0ei9SnfxZmfWd8QmLkH5VaUV2LGNAxA8Ic35Y4eK/EvryadQ
         BbvvbiRoteiAeeFi0DoORdlPG7sWZqK9k0Cl/dDd09LQkbD5W1mMspaw7QOu8KP5Yv8q
         pp5g3rwGJRr1Jot4FJzAGETabrpQkp8lBk5SGFFLXgu+LVcw+t9tW5Vh/i5CbnFAafnk
         d4n9QQEZ7GzH0sdao/uQMiiiKwIknF97/u8SbaxnSpoEDkuKK0Udd8zDF5SrOtantgK3
         CsQU0chXrhu9UA8AnOzWXLfMdyb6GVNHR027YchvTtKg9CbD0Ct9F9Z9STuq2uRevQGn
         UGXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=E3pX/gvL8yWQJckxUmg8dAnaOkARmPamj0hr7KGPAhU=;
        b=WL3xfOuwJVQKJPWSATT3O0ccCp/S/OFNX26gmHOy/noM1EuyVAclxLh6oKWV1gSdJJ
         F4hSXztzmr6zU05SzHINaUAp7J9mGb8hbixtUGy29+UKzYDa3P9tBBQDyt+4oFcLynQ+
         NANvyeWNT6QX3yotbFZEauY8W2xwsIjzyAfCai3hs85avAcMDoz4CjzuBTWDgkNhKDHX
         3FbZc1SbHKvf/PwQuG/TgkThAlHHwx2+53lGRL7VRn9S7KnaAlijNNjhNimXRMwXuL19
         svPtNcADW12buTASocEwJKvyyukIrj98yu1oc7I8vJNIunPHChORrYrbpssly3lgqnXL
         ubDw==
X-Gm-Message-State: AOAM530e9uKhgOvDnVgb1/ib4ld2nPNAYIuC9DvKF0VDLivjchCR77KH
        K6W8cZx3g7c93UcvUbInfKc=
X-Google-Smtp-Source: ABdhPJyMJWxSa44T20kVf/DcIu7ekxrIFLo8/g72gVFj1JxwxXFs/HIUhPfUZWe5k24uGtKnszLcaQ==
X-Received: by 2002:a17:90a:bf91:: with SMTP id d17mr6554254pjs.17.1622088186638;
        Wed, 26 May 2021 21:03:06 -0700 (PDT)
Received: from ast-mbp.thefacebook.com ([2620:10d:c090:400::5:6b23])
        by smtp.gmail.com with ESMTPSA id j22sm568281pfd.215.2021.05.26.21.03.04
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 26 May 2021 21:03:06 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, andrii@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH bpf-next 2/3] bpf: Add verifier checks for bpf_timer.
Date:   Wed, 26 May 2021 21:02:58 -0700
Message-Id: <20210527040259.77823-3-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.13.5
In-Reply-To: <20210527040259.77823-1-alexei.starovoitov@gmail.com>
References: <20210527040259.77823-1-alexei.starovoitov@gmail.com>
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
- allow bpf_timer in global data and search for it in datasec.
- check prog_rdonly, frozen flags.
- mmap is allowed. otherwise global timer is not possible.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 include/linux/bpf.h        | 36 +++++++++++++-----
 include/linux/btf.h        |  1 +
 kernel/bpf/arraymap.c      |  7 ++++
 kernel/bpf/btf.c           | 77 +++++++++++++++++++++++++++++++-------
 kernel/bpf/hashtab.c       | 53 ++++++++++++++++++++------
 kernel/bpf/helpers.c       |  2 +-
 kernel/bpf/local_storage.c |  4 +-
 kernel/bpf/syscall.c       | 23 ++++++++++--
 kernel/bpf/verifier.c      | 30 +++++++++++++--
 9 files changed, 190 insertions(+), 43 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 925b8416ea0a..7deff4438808 100644
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
@@ -197,24 +198,41 @@ static inline bool map_value_has_spin_lock(const struct bpf_map *map)
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
+}
+
+void bpf_timer_cancel_and_free(void *timer);
+
+static inline void check_and_init_map_value(struct bpf_map *map, void *dst)
+{
+	if (unlikely(map_value_has_spin_lock(map)))
+		*(struct bpf_spin_lock *)(dst + map->spin_lock_off) =
+			(struct bpf_spin_lock){};
+	if (unlikely(map_value_has_timer(map)))
+		*(struct bpf_timer *)(dst + map->timer_off) =
+			(struct bpf_timer){};
 }
 
 /* copy everything but bpf_spin_lock */
 static inline void copy_map_value(struct bpf_map *map, void *dst, void *src)
 {
+	u32 off = 0, size = 0;
+
 	if (unlikely(map_value_has_spin_lock(map))) {
-		u32 off = map->spin_lock_off;
+		off = map->spin_lock_off;
+		size = sizeof(struct bpf_spin_lock);
+	} else if (unlikely(map_value_has_timer(map))) {
+		off = map->timer_off;
+		size = sizeof(struct bpf_timer);
+	}
 
+	if (unlikely(size)) {
 		memcpy(dst, src, off);
-		memcpy(dst + off + sizeof(struct bpf_spin_lock),
-		       src + off + sizeof(struct bpf_spin_lock),
-		       map->value_size - off - sizeof(struct bpf_spin_lock));
+		memcpy(dst + off + size,
+		       src + off + size,
+		       map->value_size - off - size);
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
index 3c4105603f9d..3fedd9209770 100644
--- a/kernel/bpf/arraymap.c
+++ b/kernel/bpf/arraymap.c
@@ -378,10 +378,17 @@ static void *array_map_vmalloc_addr(struct bpf_array *array)
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
index 6f6681b07364..28d66fa74780 100644
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
 
@@ -785,10 +799,19 @@ static int htab_map_get_next_key(struct bpf_map *map, void *key, void *next_key)
 	return -ENOENT;
 }
 
+static void check_and_free_timer(struct bpf_htab *htab, struct htab_elem *elem)
+{
+	if (unlikely(map_value_has_timer(&htab->map)))
+		bpf_timer_cancel_and_free(elem->key +
+					  round_up(htab->map.key_size, 8) +
+					  htab->map.timer_off);
+}
+
 static void htab_elem_free(struct bpf_htab *htab, struct htab_elem *l)
 {
 	if (htab->map.map_type == BPF_MAP_TYPE_PERCPU_HASH)
 		free_percpu(htab_elem_get_ptr(l, htab->map.key_size));
+	check_and_free_timer(htab, l);
 	kfree(l);
 }
 
@@ -816,6 +839,7 @@ static void free_htab_elem(struct bpf_htab *htab, struct htab_elem *l)
 	htab_put_fd_value(htab, l);
 
 	if (htab_is_prealloc(htab)) {
+		check_and_free_timer(htab, l);
 		__pcpu_freelist_push(&htab->freelist, &l->fnode);
 	} else {
 		atomic_dec(&htab->count);
@@ -919,8 +943,8 @@ static struct htab_elem *alloc_htab_elem(struct bpf_htab *htab, void *key,
 			l_new = ERR_PTR(-ENOMEM);
 			goto dec_count;
 		}
-		check_and_init_map_lock(&htab->map,
-					l_new->key + round_up(key_size, 8));
+		check_and_init_map_value(&htab->map,
+					 l_new->key + round_up(key_size, 8));
 	}
 
 	memcpy(l_new->key, key, key_size);
@@ -1067,6 +1091,12 @@ static int htab_map_update_elem(struct bpf_map *map, void *key, void *value,
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
@@ -1099,7 +1129,8 @@ static int htab_lru_map_update_elem(struct bpf_map *map, void *key, void *value,
 	l_new = prealloc_lru_pop(htab, key, hash);
 	if (!l_new)
 		return -ENOMEM;
-	memcpy(l_new->key + round_up(map->key_size, 8), value, map->value_size);
+	copy_map_value(&htab->map,
+		       l_new->key + round_up(map->key_size, 8), value);
 
 	ret = htab_lock_bucket(htab, b, hash, &flags);
 	if (ret)
@@ -1125,9 +1156,9 @@ static int htab_lru_map_update_elem(struct bpf_map *map, void *key, void *value,
 	htab_unlock_bucket(htab, b, hash, flags);
 
 	if (ret)
-		bpf_lru_push_free(&htab->lru, &l_new->lru_node);
+		htab_lru_push_free(htab, l_new);
 	else if (l_old)
-		bpf_lru_push_free(&htab->lru, &l_old->lru_node);
+		htab_lru_push_free(htab, l_old);
 
 	return ret;
 }
@@ -1332,7 +1363,7 @@ static int htab_lru_map_delete_elem(struct bpf_map *map, void *key)
 
 	htab_unlock_bucket(htab, b, hash, flags);
 	if (l)
-		bpf_lru_push_free(&htab->lru, &l->lru_node);
+		htab_lru_push_free(htab, l);
 	return ret;
 }
 
@@ -1449,7 +1480,7 @@ static int __htab_map_lookup_and_delete_elem(struct bpf_map *map, void *key,
 			else
 				copy_map_value(map, value, l->key +
 					       roundup_key_size);
-			check_and_init_map_lock(map, value);
+			check_and_init_map_value(map, value);
 		}
 
 		hlist_nulls_del_rcu(&l->hash_node);
@@ -1460,7 +1491,7 @@ static int __htab_map_lookup_and_delete_elem(struct bpf_map *map, void *key,
 	htab_unlock_bucket(htab, b, hash, bflags);
 
 	if (is_lru_map && l)
-		bpf_lru_push_free(&htab->lru, &l->lru_node);
+		htab_lru_push_free(htab, l);
 
 	return ret;
 }
@@ -1638,7 +1669,7 @@ __htab_map_lookup_and_delete_batch(struct bpf_map *map,
 						      true);
 			else
 				copy_map_value(map, dst_val, value);
-			check_and_init_map_lock(map, dst_val);
+			check_and_init_map_value(map, dst_val);
 		}
 		if (do_delete) {
 			hlist_nulls_del_rcu(&l->hash_node);
@@ -1665,7 +1696,7 @@ __htab_map_lookup_and_delete_batch(struct bpf_map *map,
 	while (node_to_free) {
 		l = node_to_free;
 		node_to_free = node_to_free->batch_flink;
-		bpf_lru_push_free(&htab->lru, &l->lru_node);
+		htab_lru_push_free(htab, l);
 	}
 
 next_batch:
diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index 6f9620cbe95d..8580b7bfc8bb 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -1039,7 +1039,7 @@ BPF_CALL_5(bpf_timer_init, struct bpf_timer_kern *, timer, void *, cb, int, flag
 	if (!t)
 		return -ENOMEM;
 	t->callback_fn = cb;
-	t->value = (void *)timer /* - offset of bpf_timer inside elem */;
+	t->value = (void *)timer - map->timer_off;
 	t->key = t->value - round_up(map->key_size, 8);
 	t->map = map;
 	t->prog = prog;
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
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 50457019da27..d49ba04d549e 100644
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
@@ -792,6 +792,21 @@ static int map_check_btf(struct bpf_map *map, const struct btf *btf,
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
+		if (map_value_has_spin_lock(map))
+			/* map values with bpf_spin_lock and bpf_timer
+			 * are not supported yet.
+			 */
+			return -EOPNOTSUPP;
+	}
+
 	if (map->ops->map_check_btf)
 		ret = map->ops->map_check_btf(map, btf, key_type, value_type);
 
@@ -843,6 +858,7 @@ static int map_create(union bpf_attr *attr)
 	mutex_init(&map->freeze_mutex);
 
 	map->spin_lock_off = -EINVAL;
+	map->timer_off = -EINVAL;
 	if (attr->btf_key_type_id || attr->btf_value_type_id ||
 	    /* Even the map's value is a kernel's struct,
 	     * the bpf_prog.o must have BTF to begin with
@@ -1590,7 +1606,8 @@ static int map_freeze(const union bpf_attr *attr)
 	if (IS_ERR(map))
 		return PTR_ERR(map);
 
-	if (map->map_type == BPF_MAP_TYPE_STRUCT_OPS) {
+	if (map->map_type == BPF_MAP_TYPE_STRUCT_OPS ||
+	    map_value_has_timer(map)) {
 		fdput(f);
 		return -ENOTSUPP;
 	}
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index f386f85aee5c..0a828dc4968e 100644
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
-		/* todo: relax this requirement */
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

