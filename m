Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30AEB124961
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 15:23:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727067AbfLROXJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 09:23:09 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:53014 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726856AbfLROXJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 09:23:09 -0500
Received: by mail-wm1-f66.google.com with SMTP id p9so2035582wmc.2;
        Wed, 18 Dec 2019 06:23:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=yTAHBzvqCaoJgqfSRsUsNMxKMvNoDfkHSypsvPelkGk=;
        b=fYGjgwOXPz3ECGLyzdJZYhasMW9xN2Mow2ChePFXHc/IdC4WK3CP2OIXL50TAQcZKt
         gu9Roq8FPlM8WSJ7/ofYn5iMIH/s3Y3ENEiJ2ZMKci0dfy4BLRS/K5crT1cpSX10OE2A
         6RfRfs4lVEKHKbBs6h59K6FF6grM/Bhnd2cShoADcp8AzpMWs4D6+mEhEP2K8X+Pn7FH
         gOi7nAxHWLE9MquaeaICCokdza80jDyHCRIe6Bu3lXG/w3UxRh/00Qe2ijHU/kkoFR4t
         mP+ki3SQqhfViZzpYvBZPsjPNCg6eozwDvNaiS/kY0tNfhNNeNCNd7WO51gmL34BPU8R
         +xYg==
X-Gm-Message-State: APjAAAV3gPOchSIuPiK/aHytkXqy98yOl3hZM+2zzhIamX9nn5tMFYV0
        Z1lXGhypUXFSArX3MOOg1cU=
X-Google-Smtp-Source: APXvYqzFO5YRGB7XOnhpXfRYgyBqTt/qQEVrZY+E987/rRxqE4t57OuVY27rlq7ASBK57l7fj4HMOQ==
X-Received: by 2002:a7b:cc81:: with SMTP id p1mr3667962wma.62.1576678985336;
        Wed, 18 Dec 2019 06:23:05 -0800 (PST)
Received: from Omicron ([217.76.31.1])
        by smtp.gmail.com with ESMTPSA id 60sm2800836wrn.86.2019.12.18.06.23.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Dec 2019 06:23:04 -0800 (PST)
Date:   Wed, 18 Dec 2019 15:23:04 +0100
From:   Paul Chaignon <paul.chaignon@orange.com>
To:     bpf@vger.kernel.org
Cc:     paul.chaignon@gmail.com, netdev@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Subject: [PATCH bpf-next 1/3] bpf: Single-cpu updates for per-cpu maps
Message-ID: <ec8fd77bb20881e7149f7444e731c510790191ce.1576673842.git.paul.chaignon@orange.com>
References: <cover.1576673841.git.paul.chaignon@orange.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1576673841.git.paul.chaignon@orange.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, userspace programs have to update the values of all CPUs at
once when updating per-cpu maps.  This limitation prevents the update of
a single CPU's value without the risk of missing concurrent updates on
other CPU's values.

This patch allows userspace to update the value of a specific CPU in
per-cpu maps.  The CPU whose value should be updated is encoded in the
32 upper-bits of the flags argument, as follows.  The new BPF_CPU flag
can be combined with existing flags.

  bpf_map_update_elem(..., cpuid << 32 | BPF_CPU)

Signed-off-by: Paul Chaignon <paul.chaignon@orange.com>
---
 include/uapi/linux/bpf.h       |  4 +++
 kernel/bpf/arraymap.c          | 19 ++++++++-----
 kernel/bpf/hashtab.c           | 49 ++++++++++++++++++++--------------
 kernel/bpf/local_storage.c     | 16 +++++++----
 kernel/bpf/syscall.c           | 17 +++++++++---
 tools/include/uapi/linux/bpf.h |  4 +++
 6 files changed, 74 insertions(+), 35 deletions(-)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index dbbcf0b02970..2efb17d2c77a 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -316,6 +316,10 @@ enum bpf_attach_type {
 #define BPF_NOEXIST	1 /* create new element if it didn't exist */
 #define BPF_EXIST	2 /* update existing element */
 #define BPF_F_LOCK	4 /* spin_lock-ed map_lookup/map_update */
+#define BPF_CPU		8 /* single-cpu update for per-cpu maps */
+
+/* CPU mask for single-cpu updates */
+#define BPF_CPU_MASK	0xFFFFFFFF00000000ULL
 
 /* flags for BPF_MAP_CREATE command */
 #define BPF_F_NO_PREALLOC	(1U << 0)
diff --git a/kernel/bpf/arraymap.c b/kernel/bpf/arraymap.c
index f0d19bbb9211..a96e94696819 100644
--- a/kernel/bpf/arraymap.c
+++ b/kernel/bpf/arraymap.c
@@ -302,7 +302,8 @@ static int array_map_update_elem(struct bpf_map *map, void *key, void *value,
 	u32 index = *(u32 *)key;
 	char *val;
 
-	if (unlikely((map_flags & ~BPF_F_LOCK) > BPF_EXIST))
+	if (unlikely((map_flags & ~BPF_CPU_MASK & ~BPF_F_LOCK &
+				  ~BPF_CPU) > BPF_EXIST))
 		/* unknown flags */
 		return -EINVAL;
 
@@ -341,7 +342,7 @@ int bpf_percpu_array_update(struct bpf_map *map, void *key, void *value,
 	int cpu, off = 0;
 	u32 size;
 
-	if (unlikely(map_flags > BPF_EXIST))
+	if (unlikely((map_flags & ~BPF_CPU_MASK & ~BPF_CPU) > BPF_EXIST))
 		/* unknown flags */
 		return -EINVAL;
 
@@ -349,7 +350,7 @@ int bpf_percpu_array_update(struct bpf_map *map, void *key, void *value,
 		/* all elements were pre-allocated, cannot insert a new one */
 		return -E2BIG;
 
-	if (unlikely(map_flags == BPF_NOEXIST))
+	if (unlikely(map_flags & BPF_NOEXIST))
 		/* all elements already exist */
 		return -EEXIST;
 
@@ -362,9 +363,15 @@ int bpf_percpu_array_update(struct bpf_map *map, void *key, void *value,
 	size = round_up(map->value_size, 8);
 	rcu_read_lock();
 	pptr = array->pptrs[index & array->index_mask];
-	for_each_possible_cpu(cpu) {
-		bpf_long_memcpy(per_cpu_ptr(pptr, cpu), value + off, size);
-		off += size;
+	if (map_flags & BPF_CPU) {
+		bpf_long_memcpy(per_cpu_ptr(pptr, map_flags >> 32), value,
+				size);
+	} else {
+		for_each_possible_cpu(cpu) {
+			bpf_long_memcpy(per_cpu_ptr(pptr, cpu), value + off,
+					size);
+			off += size;
+		}
 	}
 	rcu_read_unlock();
 	return 0;
diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
index 22066a62c8c9..be45c7c4509f 100644
--- a/kernel/bpf/hashtab.c
+++ b/kernel/bpf/hashtab.c
@@ -695,12 +695,12 @@ static void free_htab_elem(struct bpf_htab *htab, struct htab_elem *l)
 }
 
 static void pcpu_copy_value(struct bpf_htab *htab, void __percpu *pptr,
-			    void *value, bool onallcpus)
+			    void *value, int cpuid)
 {
-	if (!onallcpus) {
+	if (cpuid == -1) {
 		/* copy true value_size bytes */
 		memcpy(this_cpu_ptr(pptr), value, htab->map.value_size);
-	} else {
+	} else if (cpuid == -2) {
 		u32 size = round_up(htab->map.value_size, 8);
 		int off = 0, cpu;
 
@@ -709,6 +709,10 @@ static void pcpu_copy_value(struct bpf_htab *htab, void __percpu *pptr,
 					value + off, size);
 			off += size;
 		}
+	} else {
+		u32 size = round_up(htab->map.value_size, 8);
+
+		bpf_long_memcpy(per_cpu_ptr(pptr, cpuid), value, size);
 	}
 }
 
@@ -720,7 +724,7 @@ static bool fd_htab_map_needs_adjust(const struct bpf_htab *htab)
 
 static struct htab_elem *alloc_htab_elem(struct bpf_htab *htab, void *key,
 					 void *value, u32 key_size, u32 hash,
-					 bool percpu, bool onallcpus,
+					 bool percpu, int cpuid,
 					 struct htab_elem *old_elem)
 {
 	u32 size = htab->map.value_size;
@@ -781,7 +785,7 @@ static struct htab_elem *alloc_htab_elem(struct bpf_htab *htab, void *key,
 			}
 		}
 
-		pcpu_copy_value(htab, pptr, value, onallcpus);
+		pcpu_copy_value(htab, pptr, value, cpuid);
 
 		if (!prealloc)
 			htab_elem_set_ptr(l_new, key_size, pptr);
@@ -804,11 +808,11 @@ static struct htab_elem *alloc_htab_elem(struct bpf_htab *htab, void *key,
 static int check_flags(struct bpf_htab *htab, struct htab_elem *l_old,
 		       u64 map_flags)
 {
-	if (l_old && (map_flags & ~BPF_F_LOCK) == BPF_NOEXIST)
+	if (l_old && (map_flags & BPF_NOEXIST) == BPF_NOEXIST)
 		/* elem already exists */
 		return -EEXIST;
 
-	if (!l_old && (map_flags & ~BPF_F_LOCK) == BPF_EXIST)
+	if (!l_old && (map_flags & BPF_EXIST) == BPF_EXIST)
 		/* elem doesn't exist, cannot update it */
 		return -ENOENT;
 
@@ -827,7 +831,8 @@ static int htab_map_update_elem(struct bpf_map *map, void *key, void *value,
 	u32 key_size, hash;
 	int ret;
 
-	if (unlikely((map_flags & ~BPF_F_LOCK) > BPF_EXIST))
+	if (unlikely((map_flags & ~BPF_CPU_MASK & ~BPF_F_LOCK &
+				  ~BPF_CPU) > BPF_EXIST))
 		/* unknown flags */
 		return -EINVAL;
 
@@ -919,7 +924,7 @@ static int htab_lru_map_update_elem(struct bpf_map *map, void *key, void *value,
 	u32 key_size, hash;
 	int ret;
 
-	if (unlikely(map_flags > BPF_EXIST))
+	if (unlikely((map_flags & ~BPF_CPU_MASK & ~BPF_CPU) > BPF_EXIST))
 		/* unknown flags */
 		return -EINVAL;
 
@@ -974,7 +979,7 @@ static int htab_lru_map_update_elem(struct bpf_map *map, void *key, void *value,
 
 static int __htab_percpu_map_update_elem(struct bpf_map *map, void *key,
 					 void *value, u64 map_flags,
-					 bool onallcpus)
+					 int cpuid)
 {
 	struct bpf_htab *htab = container_of(map, struct bpf_htab, map);
 	struct htab_elem *l_new = NULL, *l_old;
@@ -984,7 +989,7 @@ static int __htab_percpu_map_update_elem(struct bpf_map *map, void *key,
 	u32 key_size, hash;
 	int ret;
 
-	if (unlikely(map_flags > BPF_EXIST))
+	if (unlikely((map_flags & ~BPF_CPU_MASK & ~BPF_CPU) > BPF_EXIST))
 		/* unknown flags */
 		return -EINVAL;
 
@@ -1009,10 +1014,10 @@ static int __htab_percpu_map_update_elem(struct bpf_map *map, void *key,
 	if (l_old) {
 		/* per-cpu hash map can update value in-place */
 		pcpu_copy_value(htab, htab_elem_get_ptr(l_old, key_size),
-				value, onallcpus);
+				value, cpuid);
 	} else {
 		l_new = alloc_htab_elem(htab, key, value, key_size,
-					hash, true, onallcpus, NULL);
+					hash, true, cpuid, NULL);
 		if (IS_ERR(l_new)) {
 			ret = PTR_ERR(l_new);
 			goto err;
@@ -1027,7 +1032,7 @@ static int __htab_percpu_map_update_elem(struct bpf_map *map, void *key,
 
 static int __htab_lru_percpu_map_update_elem(struct bpf_map *map, void *key,
 					     void *value, u64 map_flags,
-					     bool onallcpus)
+					     int cpuid)
 {
 	struct bpf_htab *htab = container_of(map, struct bpf_htab, map);
 	struct htab_elem *l_new = NULL, *l_old;
@@ -1075,10 +1080,10 @@ static int __htab_lru_percpu_map_update_elem(struct bpf_map *map, void *key,
 
 		/* per-cpu hash map can update value in-place */
 		pcpu_copy_value(htab, htab_elem_get_ptr(l_old, key_size),
-				value, onallcpus);
+				value, cpuid);
 	} else {
 		pcpu_copy_value(htab, htab_elem_get_ptr(l_new, key_size),
-				value, onallcpus);
+				value, cpuid);
 		hlist_nulls_add_head_rcu(&l_new->hash_node, head);
 		l_new = NULL;
 	}
@@ -1093,14 +1098,14 @@ static int __htab_lru_percpu_map_update_elem(struct bpf_map *map, void *key,
 static int htab_percpu_map_update_elem(struct bpf_map *map, void *key,
 				       void *value, u64 map_flags)
 {
-	return __htab_percpu_map_update_elem(map, key, value, map_flags, false);
+	return __htab_percpu_map_update_elem(map, key, value, map_flags, -1);
 }
 
 static int htab_lru_percpu_map_update_elem(struct bpf_map *map, void *key,
 					   void *value, u64 map_flags)
 {
 	return __htab_lru_percpu_map_update_elem(map, key, value, map_flags,
-						 false);
+						 -1);
 }
 
 /* Called from syscall or from eBPF program */
@@ -1316,15 +1321,19 @@ int bpf_percpu_hash_update(struct bpf_map *map, void *key, void *value,
 			   u64 map_flags)
 {
 	struct bpf_htab *htab = container_of(map, struct bpf_htab, map);
+	int cpuid = -2; /* update values of all cpus */
 	int ret;
 
+	if (map_flags & BPF_CPU)
+		cpuid = map_flags >> 32;
+
 	rcu_read_lock();
 	if (htab_is_lru(htab))
 		ret = __htab_lru_percpu_map_update_elem(map, key, value,
-							map_flags, true);
+							map_flags, cpuid);
 	else
 		ret = __htab_percpu_map_update_elem(map, key, value, map_flags,
-						    true);
+						    cpuid);
 	rcu_read_unlock();
 
 	return ret;
diff --git a/kernel/bpf/local_storage.c b/kernel/bpf/local_storage.c
index 2ba750725cb2..2f93d75fc74b 100644
--- a/kernel/bpf/local_storage.c
+++ b/kernel/bpf/local_storage.c
@@ -206,7 +206,7 @@ int bpf_percpu_cgroup_storage_update(struct bpf_map *_map, void *_key,
 	int cpu, off = 0;
 	u32 size;
 
-	if (map_flags != BPF_ANY && map_flags != BPF_EXIST)
+	if (map_flags & ~BPF_CPU_MASK & ~BPF_CPU & ~BPF_EXIST)
 		return -EINVAL;
 
 	rcu_read_lock();
@@ -223,10 +223,16 @@ int bpf_percpu_cgroup_storage_update(struct bpf_map *_map, void *_key,
 	 * so no kernel data leaks possible
 	 */
 	size = round_up(_map->value_size, 8);
-	for_each_possible_cpu(cpu) {
-		bpf_long_memcpy(per_cpu_ptr(storage->percpu_buf, cpu),
-				value + off, size);
-		off += size;
+	if (map_flags & BPF_CPU) {
+		cpu = map_flags >> 32;
+		bpf_long_memcpy(per_cpu_ptr(storage->percpu_buf, cpu), value,
+				size);
+	} else {
+		for_each_possible_cpu(cpu) {
+			bpf_long_memcpy(per_cpu_ptr(storage->percpu_buf, cpu),
+					value + off, size);
+			off += size;
+		}
 	}
 	rcu_read_unlock();
 	return 0;
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index b08c362f4e02..83e190929f2e 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -953,7 +953,9 @@ static int map_update_elem(union bpf_attr *attr)
 	struct bpf_map *map;
 	void *key, *value;
 	u32 value_size;
+	bool per_cpu;
 	struct fd f;
+	int cpuid;
 	int err;
 
 	if (CHECK_ATTR(BPF_MAP_UPDATE_ELEM))
@@ -974,16 +976,23 @@ static int map_update_elem(union bpf_attr *attr)
 		goto err_put;
 	}
 
+	per_cpu = map->map_type == BPF_MAP_TYPE_PERCPU_HASH ||
+		  map->map_type == BPF_MAP_TYPE_LRU_PERCPU_HASH ||
+		  map->map_type == BPF_MAP_TYPE_PERCPU_ARRAY ||
+		  map->map_type == BPF_MAP_TYPE_PERCPU_CGROUP_STORAGE;
+	if ((attr->flags & BPF_CPU) &&
+	    (!per_cpu || (attr->flags >> 32) >= num_possible_cpus())) {
+		err = -EINVAL;
+		goto err_put;
+	}
+
 	key = __bpf_copy_key(ukey, map->key_size);
 	if (IS_ERR(key)) {
 		err = PTR_ERR(key);
 		goto err_put;
 	}
 
-	if (map->map_type == BPF_MAP_TYPE_PERCPU_HASH ||
-	    map->map_type == BPF_MAP_TYPE_LRU_PERCPU_HASH ||
-	    map->map_type == BPF_MAP_TYPE_PERCPU_ARRAY ||
-	    map->map_type == BPF_MAP_TYPE_PERCPU_CGROUP_STORAGE)
+	if (per_cpu && !(attr->flags & BPF_CPU))
 		value_size = round_up(map->value_size, 8) * num_possible_cpus();
 	else
 		value_size = map->value_size;
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index dbbcf0b02970..2efb17d2c77a 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -316,6 +316,10 @@ enum bpf_attach_type {
 #define BPF_NOEXIST	1 /* create new element if it didn't exist */
 #define BPF_EXIST	2 /* update existing element */
 #define BPF_F_LOCK	4 /* spin_lock-ed map_lookup/map_update */
+#define BPF_CPU		8 /* single-cpu update for per-cpu maps */
+
+/* CPU mask for single-cpu updates */
+#define BPF_CPU_MASK	0xFFFFFFFF00000000ULL
 
 /* flags for BPF_MAP_CREATE command */
 #define BPF_F_NO_PREALLOC	(1U << 0)
-- 
2.24.0

