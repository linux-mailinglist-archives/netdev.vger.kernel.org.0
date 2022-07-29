Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55089585273
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 17:24:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237458AbiG2PYH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 11:24:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237430AbiG2PXl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 11:23:41 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DE8C6546;
        Fri, 29 Jul 2022 08:23:34 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id iw1so4901912plb.6;
        Fri, 29 Jul 2022 08:23:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hWvKtt0XsSyCHiHPOrXuWkS8k5NNSExSS5sGNFOGCEo=;
        b=qWi0F7JQtGNO72/yD8SADSq0iUTPIzfVVNivxPXcllDpCr8afwl+L1eKtBkdummbGD
         ol5bniw8M4HC777V2VNaap8wSD5bjlvQGjG5qK/hua8LfNS1zsK9q48aFSAaHEIpav1c
         /vs+78hWlfzltwsqhVj87O9e9wsbfsutUMsnbe8rloQ7TqR+7HN7LI9Mqph6jAiU7CBo
         kGRyTFn28jBIzJykLM4ZDq3+BTx6Ev9unZc92F7mF32vhJJ4/iSADoO4fqqxZSL9vGjj
         M9DUjUpDvf166rl0U/p6EZKbpSDeDbI/WcL3/kPfb/jn+bnLwSAr487UXyUZii141IzA
         8xJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hWvKtt0XsSyCHiHPOrXuWkS8k5NNSExSS5sGNFOGCEo=;
        b=kFvFL4nscB819Hc1c9YMbwqDh0xjSpit+/xLcOo2lmzJoJUXE80Zesdlkdc8ctDjKM
         MFp9oSnYAIrDgJ6FzXHX62ghDAymPyAexjcRP/8akZ/md33BnxUuDL9nJqvUL5R4n8Qg
         fXSRF0C0GUuzR26tCnxtmd8rQJ6JNzNvYpSRtpWM+BVep8MsWDK42XicxxiQoRWl3VaT
         d/EZJquHre0wRXtfAcRQnaVfjmTrG1vLAPZV2RG5zXUZp9clfpld9wL2k3gUMiffy6tW
         U4AVUYqdkuqASkPC3V7h6gZ/qdNpP5GVx8ngGP76BPKTNBK4S99cOmPT1yzCY3j20PpW
         nHzQ==
X-Gm-Message-State: ACgBeo0IT+o8ol277n+qPh1nz7WJ533f8bgSsjyV+tNHJ6V/QLPiPnrF
        0UWRwEO4ORQajQ8ntO3tdFo=
X-Google-Smtp-Source: AA6agR4CRDOkwFeL7KUH3JCciqczj/ZDeXcs8fab8fsjkB4V9xWoxKgT+VUKmGt2New9nthSlDQ2Zw==
X-Received: by 2002:a17:902:7796:b0:16d:41b2:dd36 with SMTP id o22-20020a170902779600b0016d41b2dd36mr4237120pll.137.1659108213626;
        Fri, 29 Jul 2022 08:23:33 -0700 (PDT)
Received: from vultr.guest ([2001:19f0:6001:2912:5400:4ff:fe16:4344])
        by smtp.gmail.com with ESMTPSA id b12-20020a1709027e0c00b0016d3a354cffsm3714219plm.89.2022.07.29.08.23.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Jul 2022 08:23:32 -0700 (PDT)
From:   Yafang Shao <laoar.shao@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org, hannes@cmpxchg.org,
        mhocko@kernel.org, roman.gushchin@linux.dev, shakeelb@google.com,
        songmuchun@bytedance.com, akpm@linux-foundation.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, linux-mm@kvack.org,
        Yafang Shao <laoar.shao@gmail.com>
Subject: [RFC PATCH bpf-next 06/15] bpf: Use bpf_map_container_alloc helpers in various bpf maps
Date:   Fri, 29 Jul 2022 15:23:07 +0000
Message-Id: <20220729152316.58205-7-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220729152316.58205-1-laoar.shao@gmail.com>
References: <20220729152316.58205-1-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With the preparation of previous patch, now we can use the helper
bpf_map_container_alloc() to allocate all bpf maps.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 include/linux/bpf.h            |  1 -
 kernel/bpf/arraymap.c          | 19 +++++++++++--------
 kernel/bpf/bloom_filter.c      |  4 ++--
 kernel/bpf/bpf_local_storage.c |  6 +++---
 kernel/bpf/bpf_struct_ops.c    |  4 ++--
 kernel/bpf/cpumap.c            |  6 +++---
 kernel/bpf/devmap.c            |  6 +++---
 kernel/bpf/hashtab.c           |  6 +++---
 kernel/bpf/local_storage.c     |  4 ++--
 kernel/bpf/lpm_trie.c          |  4 ++--
 kernel/bpf/offload.c           |  2 +-
 kernel/bpf/queue_stack_maps.c  |  4 ++--
 kernel/bpf/reuseport_array.c   |  4 ++--
 kernel/bpf/ringbuf.c           |  6 +++---
 kernel/bpf/stackmap.c          |  6 +++---
 kernel/bpf/syscall.c           |  8 --------
 net/core/sock_map.c            | 12 ++++++------
 net/xdp/xskmap.c               |  4 ++--
 18 files changed, 50 insertions(+), 56 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 2d971b0eb24b..3f9893e14124 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1638,7 +1638,6 @@ void *bpf_map_container_alloc(u64 size, int numa_node);
 void *bpf_map_container_mmapable_alloc(u64 size, int numa_node,
 				       u32 align, u32 offset);
 void *bpf_map_area_alloc(u64 size, int numa_node);
-void *bpf_map_area_mmapable_alloc(u64 size, int numa_node);
 void bpf_map_area_free(void *base);
 void bpf_map_container_free(void *base);
 bool bpf_map_write_active(const struct bpf_map *map);
diff --git a/kernel/bpf/arraymap.c b/kernel/bpf/arraymap.c
index d3e734bf8056..9517619dbe8d 100644
--- a/kernel/bpf/arraymap.c
+++ b/kernel/bpf/arraymap.c
@@ -126,16 +126,18 @@ static struct bpf_map *array_map_alloc(union bpf_attr *attr)
 
 	/* allocate all map elements and zero-initialize them */
 	if (attr->map_flags & BPF_F_MMAPABLE) {
+		u32 align = PAGE_ALIGN(sizeof(struct bpf_array));
+		u32 offset = offsetof(struct bpf_array, value);
 		void *data;
 
 		/* kmalloc'ed memory can't be mmap'ed, use explicit vmalloc */
-		data = bpf_map_area_mmapable_alloc(array_size, numa_node);
+		data = bpf_map_container_mmapable_alloc(array_size, numa_node,
+							align, offset);
 		if (!data)
 			return ERR_PTR(-ENOMEM);
-		array = data + PAGE_ALIGN(sizeof(struct bpf_array))
-			- offsetof(struct bpf_array, value);
+		array = data + align - offset;
 	} else {
-		array = bpf_map_area_alloc(array_size, numa_node);
+		array = bpf_map_container_alloc(array_size, numa_node);
 	}
 	if (!array)
 		return ERR_PTR(-ENOMEM);
@@ -147,7 +149,7 @@ static struct bpf_map *array_map_alloc(union bpf_attr *attr)
 	array->elem_size = elem_size;
 
 	if (percpu && bpf_array_alloc_percpu(array)) {
-		bpf_map_area_free(array);
+		bpf_map_container_free(array);
 		return ERR_PTR(-ENOMEM);
 	}
 
@@ -420,6 +422,7 @@ static void array_map_free(struct bpf_map *map)
 	struct bpf_array *array = container_of(map, struct bpf_array, map);
 	int i;
 
+
 	if (map_value_has_kptrs(map)) {
 		for (i = 0; i < array->map.max_entries; i++)
 			bpf_map_free_kptrs(map, array_map_elem_ptr(array, i));
@@ -430,9 +433,9 @@ static void array_map_free(struct bpf_map *map)
 		bpf_array_free_percpu(array);
 
 	if (array->map.map_flags & BPF_F_MMAPABLE)
-		bpf_map_area_free(array_map_vmalloc_addr(array));
+		bpf_map_container_free(array_map_vmalloc_addr(array));
 	else
-		bpf_map_area_free(array);
+		bpf_map_container_free(array);
 }
 
 static void array_map_seq_show_elem(struct bpf_map *map, void *key,
@@ -774,7 +777,7 @@ static void fd_array_map_free(struct bpf_map *map)
 	for (i = 0; i < array->map.max_entries; i++)
 		BUG_ON(array->ptrs[i] != NULL);
 
-	bpf_map_area_free(array);
+	bpf_map_container_free(array);
 }
 
 static void *fd_array_map_lookup_elem(struct bpf_map *map, void *key)
diff --git a/kernel/bpf/bloom_filter.c b/kernel/bpf/bloom_filter.c
index b9ea539a5561..8b3194903b52 100644
--- a/kernel/bpf/bloom_filter.c
+++ b/kernel/bpf/bloom_filter.c
@@ -142,7 +142,7 @@ static struct bpf_map *bloom_map_alloc(union bpf_attr *attr)
 	}
 
 	bitset_bytes = roundup(bitset_bytes, sizeof(unsigned long));
-	bloom = bpf_map_area_alloc(sizeof(*bloom) + bitset_bytes, numa_node);
+	bloom = bpf_map_container_alloc(sizeof(*bloom) + bitset_bytes, numa_node);
 
 	if (!bloom)
 		return ERR_PTR(-ENOMEM);
@@ -168,7 +168,7 @@ static void bloom_map_free(struct bpf_map *map)
 	struct bpf_bloom_filter *bloom =
 		container_of(map, struct bpf_bloom_filter, map);
 
-	bpf_map_area_free(bloom);
+	bpf_map_container_free(bloom);
 }
 
 static void *bloom_map_lookup_elem(struct bpf_map *map, void *key)
diff --git a/kernel/bpf/bpf_local_storage.c b/kernel/bpf/bpf_local_storage.c
index 4ee2e7286c23..0b50cb2e1d5b 100644
--- a/kernel/bpf/bpf_local_storage.c
+++ b/kernel/bpf/bpf_local_storage.c
@@ -582,7 +582,7 @@ void bpf_local_storage_map_free(struct bpf_local_storage_map *smap,
 	synchronize_rcu();
 
 	kvfree(smap->buckets);
-	bpf_map_area_free(smap);
+	bpf_map_container_free(smap);
 }
 
 int bpf_local_storage_map_alloc_check(union bpf_attr *attr)
@@ -610,7 +610,7 @@ struct bpf_local_storage_map *bpf_local_storage_map_alloc(union bpf_attr *attr)
 	unsigned int i;
 	u32 nbuckets;
 
-	smap = bpf_map_area_alloc(sizeof(*smap), NUMA_NO_NODE);
+	smap = bpf_map_container_alloc(sizeof(*smap), NUMA_NO_NODE);
 	if (!smap)
 		return ERR_PTR(-ENOMEM);
 	bpf_map_init_from_attr(&smap->map, attr);
@@ -623,7 +623,7 @@ struct bpf_local_storage_map *bpf_local_storage_map_alloc(union bpf_attr *attr)
 	smap->buckets = kvcalloc(sizeof(*smap->buckets), nbuckets,
 				 GFP_USER | __GFP_NOWARN | __GFP_ACCOUNT);
 	if (!smap->buckets) {
-		bpf_map_area_free(smap);
+		bpf_map_container_free(smap);
 		return ERR_PTR(-ENOMEM);
 	}
 
diff --git a/kernel/bpf/bpf_struct_ops.c b/kernel/bpf/bpf_struct_ops.c
index 84b2d9dba79a..66df3059a3fe 100644
--- a/kernel/bpf/bpf_struct_ops.c
+++ b/kernel/bpf/bpf_struct_ops.c
@@ -580,7 +580,7 @@ static void bpf_struct_ops_map_free(struct bpf_map *map)
 	bpf_map_area_free(st_map->links);
 	bpf_jit_free_exec(st_map->image);
 	bpf_map_area_free(st_map->uvalue);
-	bpf_map_area_free(st_map);
+	bpf_map_container_free(st_map);
 }
 
 static int bpf_struct_ops_map_alloc_check(union bpf_attr *attr)
@@ -618,7 +618,7 @@ static struct bpf_map *bpf_struct_ops_map_alloc(union bpf_attr *attr)
 		 */
 		(vt->size - sizeof(struct bpf_struct_ops_value));
 
-	st_map = bpf_map_area_alloc(st_map_size, NUMA_NO_NODE);
+	st_map = bpf_map_container_alloc(st_map_size, NUMA_NO_NODE);
 	if (!st_map)
 		return ERR_PTR(-ENOMEM);
 
diff --git a/kernel/bpf/cpumap.c b/kernel/bpf/cpumap.c
index b5ba34ddd4b6..23e941826eec 100644
--- a/kernel/bpf/cpumap.c
+++ b/kernel/bpf/cpumap.c
@@ -97,7 +97,7 @@ static struct bpf_map *cpu_map_alloc(union bpf_attr *attr)
 	    attr->map_flags & ~BPF_F_NUMA_NODE)
 		return ERR_PTR(-EINVAL);
 
-	cmap = bpf_map_area_alloc(sizeof(*cmap), NUMA_NO_NODE);
+	cmap = bpf_map_container_alloc(sizeof(*cmap), NUMA_NO_NODE);
 	if (!cmap)
 		return ERR_PTR(-ENOMEM);
 
@@ -118,7 +118,7 @@ static struct bpf_map *cpu_map_alloc(union bpf_attr *attr)
 
 	return &cmap->map;
 free_cmap:
-	bpf_map_area_free(cmap);
+	bpf_map_container_free(cmap);
 	return ERR_PTR(err);
 }
 
@@ -623,7 +623,7 @@ static void cpu_map_free(struct bpf_map *map)
 		__cpu_map_entry_replace(cmap, i, NULL); /* call_rcu */
 	}
 	bpf_map_area_free(cmap->cpu_map);
-	bpf_map_area_free(cmap);
+	bpf_map_container_free(cmap);
 }
 
 /* Elements are kept alive by RCU; either by rcu_read_lock() (from syscall) or
diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
index f9a87dcc5535..3e99c10f1729 100644
--- a/kernel/bpf/devmap.c
+++ b/kernel/bpf/devmap.c
@@ -163,13 +163,13 @@ static struct bpf_map *dev_map_alloc(union bpf_attr *attr)
 	if (!capable(CAP_NET_ADMIN))
 		return ERR_PTR(-EPERM);
 
-	dtab = bpf_map_area_alloc(sizeof(*dtab), NUMA_NO_NODE);
+	dtab = bpf_map_container_alloc(sizeof(*dtab), NUMA_NO_NODE);
 	if (!dtab)
 		return ERR_PTR(-ENOMEM);
 
 	err = dev_map_init_map(dtab, attr);
 	if (err) {
-		bpf_map_area_free(dtab);
+		bpf_map_container_free(dtab);
 		return ERR_PTR(err);
 	}
 
@@ -240,7 +240,7 @@ static void dev_map_free(struct bpf_map *map)
 		bpf_map_area_free(dtab->netdev_map);
 	}
 
-	bpf_map_area_free(dtab);
+	bpf_map_container_free(dtab);
 }
 
 static int dev_map_get_next_key(struct bpf_map *map, void *key, void *next_key)
diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
index 8392f7f8a8ac..d2fb144276ab 100644
--- a/kernel/bpf/hashtab.c
+++ b/kernel/bpf/hashtab.c
@@ -495,7 +495,7 @@ static struct bpf_map *htab_map_alloc(union bpf_attr *attr)
 	struct bpf_htab *htab;
 	int err, i;
 
-	htab = bpf_map_area_alloc(sizeof(*htab), NUMA_NO_NODE);
+	htab = bpf_map_container_alloc(sizeof(*htab), NUMA_NO_NODE);
 	if (!htab)
 		return ERR_PTR(-ENOMEM);
 
@@ -579,7 +579,7 @@ static struct bpf_map *htab_map_alloc(union bpf_attr *attr)
 	bpf_map_area_free(htab->buckets);
 free_htab:
 	lockdep_unregister_key(&htab->lockdep_key);
-	bpf_map_area_free(htab);
+	bpf_map_container_free(htab);
 	return ERR_PTR(err);
 }
 
@@ -1496,7 +1496,7 @@ static void htab_map_free(struct bpf_map *map)
 	for (i = 0; i < HASHTAB_MAP_LOCK_COUNT; i++)
 		free_percpu(htab->map_locked[i]);
 	lockdep_unregister_key(&htab->lockdep_key);
-	bpf_map_area_free(htab);
+	bpf_map_container_free(htab);
 }
 
 static void htab_map_seq_show_elem(struct bpf_map *map, void *key,
diff --git a/kernel/bpf/local_storage.c b/kernel/bpf/local_storage.c
index 098cf336fae6..963dc82e3c50 100644
--- a/kernel/bpf/local_storage.c
+++ b/kernel/bpf/local_storage.c
@@ -313,7 +313,7 @@ static struct bpf_map *cgroup_storage_map_alloc(union bpf_attr *attr)
 		/* max_entries is not used and enforced to be 0 */
 		return ERR_PTR(-EINVAL);
 
-	map = bpf_map_area_alloc(sizeof(struct bpf_cgroup_storage_map), numa_node);
+	map = bpf_map_container_alloc(sizeof(struct bpf_cgroup_storage_map), numa_node);
 	if (!map)
 		return ERR_PTR(-ENOMEM);
 
@@ -345,7 +345,7 @@ static void cgroup_storage_map_free(struct bpf_map *_map)
 	WARN_ON(!RB_EMPTY_ROOT(&map->root));
 	WARN_ON(!list_empty(&map->list));
 
-	bpf_map_area_free(map);
+	bpf_map_container_free(map);
 }
 
 static int cgroup_storage_delete_elem(struct bpf_map *map, void *key)
diff --git a/kernel/bpf/lpm_trie.c b/kernel/bpf/lpm_trie.c
index d833496e9e42..15ccef2f10a3 100644
--- a/kernel/bpf/lpm_trie.c
+++ b/kernel/bpf/lpm_trie.c
@@ -558,7 +558,7 @@ static struct bpf_map *trie_alloc(union bpf_attr *attr)
 	    attr->value_size > LPM_VAL_SIZE_MAX)
 		return ERR_PTR(-EINVAL);
 
-	trie = bpf_map_area_alloc(sizeof(*trie), NUMA_NO_NODE);
+	trie = bpf_map_container_alloc(sizeof(*trie), NUMA_NO_NODE);
 	if (!trie)
 		return ERR_PTR(-ENOMEM);
 
@@ -609,7 +609,7 @@ static void trie_free(struct bpf_map *map)
 	}
 
 out:
-	bpf_map_area_free(trie);
+	bpf_map_container_free(trie);
 }
 
 static int trie_get_next_key(struct bpf_map *map, void *_key, void *_next_key)
diff --git a/kernel/bpf/offload.c b/kernel/bpf/offload.c
index 5a629a1b971c..02e3f4ef19f5 100644
--- a/kernel/bpf/offload.c
+++ b/kernel/bpf/offload.c
@@ -372,7 +372,7 @@ struct bpf_map *bpf_map_offload_map_alloc(union bpf_attr *attr)
 	    attr->map_type != BPF_MAP_TYPE_HASH)
 		return ERR_PTR(-EINVAL);
 
-	offmap = kzalloc(sizeof(*offmap), GFP_USER | __GFP_NOWARN);
+	offmap = bpf_map_container_alloc(sizeof(*offmap), NUMA_NO_NODE);
 	if (!offmap)
 		return ERR_PTR(-ENOMEM);
 
diff --git a/kernel/bpf/queue_stack_maps.c b/kernel/bpf/queue_stack_maps.c
index 8a5e060de63b..d4c0284c9089 100644
--- a/kernel/bpf/queue_stack_maps.c
+++ b/kernel/bpf/queue_stack_maps.c
@@ -74,7 +74,7 @@ static struct bpf_map *queue_stack_map_alloc(union bpf_attr *attr)
 	size = (u64) attr->max_entries + 1;
 	queue_size = sizeof(*qs) + size * attr->value_size;
 
-	qs = bpf_map_area_alloc(queue_size, numa_node);
+	qs = bpf_map_container_alloc(queue_size, numa_node);
 	if (!qs)
 		return ERR_PTR(-ENOMEM);
 
@@ -92,7 +92,7 @@ static void queue_stack_map_free(struct bpf_map *map)
 {
 	struct bpf_queue_stack *qs = bpf_queue_stack(map);
 
-	bpf_map_area_free(qs);
+	bpf_map_container_free(qs);
 }
 
 static int __queue_map_get(struct bpf_map *map, void *value, bool delete)
diff --git a/kernel/bpf/reuseport_array.c b/kernel/bpf/reuseport_array.c
index e2618fb5870e..d36a60ca68f4 100644
--- a/kernel/bpf/reuseport_array.c
+++ b/kernel/bpf/reuseport_array.c
@@ -146,7 +146,7 @@ static void reuseport_array_free(struct bpf_map *map)
 	 * Once reaching here, all sk->sk_user_data is not
 	 * referencing this "array". "array" can be freed now.
 	 */
-	bpf_map_area_free(array);
+	bpf_map_container_free(array);
 }
 
 static struct bpf_map *reuseport_array_alloc(union bpf_attr *attr)
@@ -158,7 +158,7 @@ static struct bpf_map *reuseport_array_alloc(union bpf_attr *attr)
 		return ERR_PTR(-EPERM);
 
 	/* allocate all map elements and zero-initialize them */
-	array = bpf_map_area_alloc(struct_size(array, ptrs, attr->max_entries), numa_node);
+	array = bpf_map_container_alloc(struct_size(array, ptrs, attr->max_entries), numa_node);
 	if (!array)
 		return ERR_PTR(-ENOMEM);
 
diff --git a/kernel/bpf/ringbuf.c b/kernel/bpf/ringbuf.c
index b483aea35f41..35258aa45236 100644
--- a/kernel/bpf/ringbuf.c
+++ b/kernel/bpf/ringbuf.c
@@ -164,7 +164,7 @@ static struct bpf_map *ringbuf_map_alloc(union bpf_attr *attr)
 		return ERR_PTR(-E2BIG);
 #endif
 
-	rb_map = bpf_map_area_alloc(sizeof(*rb_map), NUMA_NO_NODE);
+	rb_map = bpf_map_container_alloc(sizeof(*rb_map), NUMA_NO_NODE);
 	if (!rb_map)
 		return ERR_PTR(-ENOMEM);
 
@@ -172,7 +172,7 @@ static struct bpf_map *ringbuf_map_alloc(union bpf_attr *attr)
 
 	rb_map->rb = bpf_ringbuf_alloc(attr->max_entries, rb_map->map.numa_node);
 	if (!rb_map->rb) {
-		bpf_map_area_free(rb_map);
+		bpf_map_container_free(rb_map);
 		return ERR_PTR(-ENOMEM);
 	}
 
@@ -199,7 +199,7 @@ static void ringbuf_map_free(struct bpf_map *map)
 
 	rb_map = container_of(map, struct bpf_ringbuf_map, map);
 	bpf_ringbuf_free(rb_map->rb);
-	bpf_map_area_free(rb_map);
+	bpf_map_container_free(rb_map);
 }
 
 static void *ringbuf_map_lookup_elem(struct bpf_map *map, void *key)
diff --git a/kernel/bpf/stackmap.c b/kernel/bpf/stackmap.c
index 1adbe67cdb95..0c3185406f56 100644
--- a/kernel/bpf/stackmap.c
+++ b/kernel/bpf/stackmap.c
@@ -100,7 +100,7 @@ static struct bpf_map *stack_map_alloc(union bpf_attr *attr)
 		return ERR_PTR(-E2BIG);
 
 	cost = n_buckets * sizeof(struct stack_map_bucket *) + sizeof(*smap);
-	smap = bpf_map_area_alloc(cost, bpf_map_attr_numa_node(attr));
+	smap = bpf_map_container_alloc(cost, bpf_map_attr_numa_node(attr));
 	if (!smap)
 		return ERR_PTR(-ENOMEM);
 
@@ -120,7 +120,7 @@ static struct bpf_map *stack_map_alloc(union bpf_attr *attr)
 put_buffers:
 	put_callchain_buffers();
 free_smap:
-	bpf_map_area_free(smap);
+	bpf_map_container_free(smap);
 	return ERR_PTR(err);
 }
 
@@ -650,7 +650,7 @@ static void stack_map_free(struct bpf_map *map)
 
 	bpf_map_area_free(smap->elems);
 	pcpu_freelist_destroy(&smap->freelist);
-	bpf_map_area_free(smap);
+	bpf_map_container_free(smap);
 	put_callchain_buffers();
 }
 
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 1a1a81a11b37..a6f68ade200f 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -339,11 +339,6 @@ void *bpf_map_area_alloc(u64 size, int numa_node)
 	return __bpf_map_area_alloc(size, numa_node, false);
 }
 
-void *bpf_map_area_mmapable_alloc(u64 size, int numa_node)
-{
-	return __bpf_map_area_alloc(size, numa_node, true);
-}
-
 void bpf_map_area_free(void *area)
 {
 	kvfree(area);
@@ -669,7 +664,6 @@ static void bpf_map_free_deferred(struct work_struct *work)
 
 	security_bpf_map_free(map);
 	kfree(map->off_arr);
-	bpf_map_release_memcg(map);
 	/* implementation dependent freeing, map_free callback also does
 	 * bpf_map_free_kptr_off_tab, if needed.
 	 */
@@ -1218,8 +1212,6 @@ static int map_create(union bpf_attr *attr)
 	if (err)
 		goto free_map_sec;
 
-	bpf_map_save_memcg(map);
-
 	err = bpf_map_new_fd(map, f_flags);
 	if (err < 0) {
 		/* failed to allocate fd.
diff --git a/net/core/sock_map.c b/net/core/sock_map.c
index d0c43384d8bf..4b5876c4a47d 100644
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -41,7 +41,7 @@ static struct bpf_map *sock_map_alloc(union bpf_attr *attr)
 	    attr->map_flags & ~SOCK_CREATE_FLAG_MASK)
 		return ERR_PTR(-EINVAL);
 
-	stab = bpf_map_area_alloc(sizeof(*stab), NUMA_NO_NODE);
+	stab = bpf_map_container_alloc(sizeof(*stab), NUMA_NO_NODE);
 	if (!stab)
 		return ERR_PTR(-ENOMEM);
 
@@ -52,7 +52,7 @@ static struct bpf_map *sock_map_alloc(union bpf_attr *attr)
 				       sizeof(struct sock *),
 				       stab->map.numa_node);
 	if (!stab->sks) {
-		bpf_map_area_free(stab);
+		bpf_map_container_free(stab);
 		return ERR_PTR(-ENOMEM);
 	}
 
@@ -361,7 +361,7 @@ static void sock_map_free(struct bpf_map *map)
 	synchronize_rcu();
 
 	bpf_map_area_free(stab->sks);
-	bpf_map_area_free(stab);
+	bpf_map_container_free(stab);
 }
 
 static void sock_map_release_progs(struct bpf_map *map)
@@ -1076,7 +1076,7 @@ static struct bpf_map *sock_hash_alloc(union bpf_attr *attr)
 	if (attr->key_size > MAX_BPF_STACK)
 		return ERR_PTR(-E2BIG);
 
-	htab = bpf_map_area_alloc(sizeof(*htab), NUMA_NO_NODE);
+	htab = bpf_map_container_alloc(sizeof(*htab), NUMA_NO_NODE);
 	if (!htab)
 		return ERR_PTR(-ENOMEM);
 
@@ -1106,7 +1106,7 @@ static struct bpf_map *sock_hash_alloc(union bpf_attr *attr)
 
 	return &htab->map;
 free_htab:
-	bpf_map_area_free(htab);
+	bpf_map_container_free(htab);
 	return ERR_PTR(err);
 }
 
@@ -1159,7 +1159,7 @@ static void sock_hash_free(struct bpf_map *map)
 	synchronize_rcu();
 
 	bpf_map_area_free(htab->buckets);
-	bpf_map_area_free(htab);
+	bpf_map_container_free(htab);
 }
 
 static void *sock_hash_lookup_sys(struct bpf_map *map, void *key)
diff --git a/net/xdp/xskmap.c b/net/xdp/xskmap.c
index acc8e52a4f5f..6cf98f1c621a 100644
--- a/net/xdp/xskmap.c
+++ b/net/xdp/xskmap.c
@@ -75,7 +75,7 @@ static struct bpf_map *xsk_map_alloc(union bpf_attr *attr)
 	numa_node = bpf_map_attr_numa_node(attr);
 	size = struct_size(m, xsk_map, attr->max_entries);
 
-	m = bpf_map_area_alloc(size, numa_node);
+	m = bpf_map_container_alloc(size, numa_node);
 	if (!m)
 		return ERR_PTR(-ENOMEM);
 
@@ -90,7 +90,7 @@ static void xsk_map_free(struct bpf_map *map)
 	struct xsk_map *m = container_of(map, struct xsk_map, map);
 
 	synchronize_net();
-	bpf_map_area_free(m);
+	bpf_map_container_free(m);
 }
 
 static int xsk_map_get_next_key(struct bpf_map *map, void *key, void *next_key)
-- 
2.17.1

