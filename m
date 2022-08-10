Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACE7258EF30
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 17:19:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233056AbiHJPTK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 11:19:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233060AbiHJPTF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 11:19:05 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 947D478BF5;
        Wed, 10 Aug 2022 08:19:00 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id y141so13987157pfb.7;
        Wed, 10 Aug 2022 08:19:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=pNR85emlY/Gqguy9oN4UnMeNs/m0sbawgAOOJ626Rfw=;
        b=HmdVUKvwrT1UViXpAx6fWYM+0ZDNfYOxmrnB30CiRN2rC2E1QjFvwLfOCJQU/FCenV
         BzKXikqkfl0qqYG9gE8ni0q2iC6kuVJwzGwrebWErVSXHJaTzNxPEhwkX5ohAL8Km3Mo
         mppRiY0aRuDL5ZlpvTfwn5wri7Q8DMUvQASlbYgftGXuLidGg30oyMO+mknusLYRoFVF
         LtVqKnuHCluZ3fshofQbMDpVszhy0KftU/O4yHE8vQ1Ulvv+xUAvcx2CcSDn2XyOJAiU
         NtUB+yuZ8JDzYVGpsRhjygJ5QnvQjC3jIT0hUlSE3qc91rGlE5O3lHKdWSlUVi7Cake7
         7u9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=pNR85emlY/Gqguy9oN4UnMeNs/m0sbawgAOOJ626Rfw=;
        b=mf3CdMGh/6SI21Kq78HcCgKj0peuvzjXZCmLIHUZzp5HyRRUwZH8wi3kx6ARU4OOGO
         8ds52v2ntRWMAdshywA7NMyuWFijJwJFk+XcKse1vNHsLu8aSFLCj7QusTKeStP/uNs6
         1aN5Fjh42riqK6IX5GTMiQGuSxKD2GKdOImCIUnCCIZcSPgP9w7iKaXS3AVMJ4HL8GJR
         73HRe0DruFhoYKSkFWxo8lTnMtnJWRKDGxK+odam+t0lOrxN+3+XnxzkT7+b0rruI27D
         v6kypstaxrGITUDP+d/Jvj02IgcKmd1y4Rjw0aHizTMxX1kaT2CDE+UEbhehEgsqDjWI
         6Iyg==
X-Gm-Message-State: ACgBeo3aFGon72LtvTqCyS460kQRfluREqxe2uPJi3Im1X9+F982zpyE
        vNRDR+aTV8d3gGridwRBlow=
X-Google-Smtp-Source: AA6agR4KzuyCbK60wPw25WLaEb7jmGLkH6an6vqpHHKoY4X/G3A61HKOHAwjgQDk0pQUhYHI9GJjkA==
X-Received: by 2002:a63:ef54:0:b0:41a:56e7:aeb3 with SMTP id c20-20020a63ef54000000b0041a56e7aeb3mr22908648pgk.49.1660144739831;
        Wed, 10 Aug 2022 08:18:59 -0700 (PDT)
Received: from vultr.guest ([2001:19f0:6001:5c3e:5400:4ff:fe19:c3bc])
        by smtp.gmail.com with ESMTPSA id 85-20020a621558000000b0052b6ed5ca40sm2071935pfv.192.2022.08.10.08.18.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Aug 2022 08:18:58 -0700 (PDT)
From:   Yafang Shao <laoar.shao@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org, hannes@cmpxchg.org,
        mhocko@kernel.org, roman.gushchin@linux.dev, shakeelb@google.com,
        songmuchun@bytedance.com, akpm@linux-foundation.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, linux-mm@kvack.org,
        Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH bpf-next 08/15] bpf: Save memcg in bpf_map_init_from_attr()
Date:   Wed, 10 Aug 2022 15:18:33 +0000
Message-Id: <20220810151840.16394-9-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220810151840.16394-1-laoar.shao@gmail.com>
References: <20220810151840.16394-1-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move bpf_map_save_memcg() into bpf_map_init_from_attr(), then all other
map related memory allocation will be allocated after saving the memcg.
And then we can get memcg from the map in the followup memory allocation.

To pair with this change, bpf_map_release_memcg() is moved into
bpf_map_area_free(). A new parameter struct bpf_map is introduced into
bpf_map_area_free() for this purpose.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 include/linux/bpf.h            |  2 +-
 kernel/bpf/arraymap.c          |  8 +++---
 kernel/bpf/bloom_filter.c      |  2 +-
 kernel/bpf/bpf_local_storage.c |  4 +--
 kernel/bpf/bpf_struct_ops.c    |  6 ++---
 kernel/bpf/cpumap.c            |  6 ++---
 kernel/bpf/devmap.c            |  8 +++---
 kernel/bpf/hashtab.c           | 10 +++----
 kernel/bpf/local_storage.c     |  2 +-
 kernel/bpf/lpm_trie.c          |  2 +-
 kernel/bpf/offload.c           |  4 +--
 kernel/bpf/queue_stack_maps.c  |  2 +-
 kernel/bpf/reuseport_array.c   |  2 +-
 kernel/bpf/ringbuf.c           |  8 +++---
 kernel/bpf/stackmap.c          |  8 +++---
 kernel/bpf/syscall.c           | 60 ++++++++++++++++++++++--------------------
 net/core/sock_map.c            | 12 ++++-----
 net/xdp/xskmap.c               |  2 +-
 18 files changed, 76 insertions(+), 72 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index fe3b565..414f8b7 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1637,7 +1637,7 @@ struct bpf_prog *bpf_prog_get_type_dev(u32 ufd, enum bpf_prog_type type,
 void bpf_map_put(struct bpf_map *map);
 void *bpf_map_area_alloc(u64 size, int numa_node);
 void *bpf_map_area_mmapable_alloc(u64 size, int numa_node);
-void bpf_map_area_free(void *base);
+void bpf_map_area_free(void *base, struct bpf_map *map);
 bool bpf_map_write_active(const struct bpf_map *map);
 void bpf_map_init_from_attr(struct bpf_map *map, union bpf_attr *attr);
 int  generic_map_lookup_batch(struct bpf_map *map,
diff --git a/kernel/bpf/arraymap.c b/kernel/bpf/arraymap.c
index d3e734b..9ce4d1b 100644
--- a/kernel/bpf/arraymap.c
+++ b/kernel/bpf/arraymap.c
@@ -147,7 +147,7 @@ static struct bpf_map *array_map_alloc(union bpf_attr *attr)
 	array->elem_size = elem_size;
 
 	if (percpu && bpf_array_alloc_percpu(array)) {
-		bpf_map_area_free(array);
+		bpf_map_area_free(array, &array->map);
 		return ERR_PTR(-ENOMEM);
 	}
 
@@ -430,9 +430,9 @@ static void array_map_free(struct bpf_map *map)
 		bpf_array_free_percpu(array);
 
 	if (array->map.map_flags & BPF_F_MMAPABLE)
-		bpf_map_area_free(array_map_vmalloc_addr(array));
+		bpf_map_area_free(array_map_vmalloc_addr(array), map);
 	else
-		bpf_map_area_free(array);
+		bpf_map_area_free(array, map);
 }
 
 static void array_map_seq_show_elem(struct bpf_map *map, void *key,
@@ -774,7 +774,7 @@ static void fd_array_map_free(struct bpf_map *map)
 	for (i = 0; i < array->map.max_entries; i++)
 		BUG_ON(array->ptrs[i] != NULL);
 
-	bpf_map_area_free(array);
+	bpf_map_area_free(array, map);
 }
 
 static void *fd_array_map_lookup_elem(struct bpf_map *map, void *key)
diff --git a/kernel/bpf/bloom_filter.c b/kernel/bpf/bloom_filter.c
index b9ea539..e59064d 100644
--- a/kernel/bpf/bloom_filter.c
+++ b/kernel/bpf/bloom_filter.c
@@ -168,7 +168,7 @@ static void bloom_map_free(struct bpf_map *map)
 	struct bpf_bloom_filter *bloom =
 		container_of(map, struct bpf_bloom_filter, map);
 
-	bpf_map_area_free(bloom);
+	bpf_map_area_free(bloom, map);
 }
 
 static void *bloom_map_lookup_elem(struct bpf_map *map, void *key)
diff --git a/kernel/bpf/bpf_local_storage.c b/kernel/bpf/bpf_local_storage.c
index 4ee2e72..77e075b 100644
--- a/kernel/bpf/bpf_local_storage.c
+++ b/kernel/bpf/bpf_local_storage.c
@@ -582,7 +582,7 @@ void bpf_local_storage_map_free(struct bpf_local_storage_map *smap,
 	synchronize_rcu();
 
 	kvfree(smap->buckets);
-	bpf_map_area_free(smap);
+	bpf_map_area_free(smap, &smap->map);
 }
 
 int bpf_local_storage_map_alloc_check(union bpf_attr *attr)
@@ -623,7 +623,7 @@ struct bpf_local_storage_map *bpf_local_storage_map_alloc(union bpf_attr *attr)
 	smap->buckets = kvcalloc(sizeof(*smap->buckets), nbuckets,
 				 GFP_USER | __GFP_NOWARN | __GFP_ACCOUNT);
 	if (!smap->buckets) {
-		bpf_map_area_free(smap);
+		bpf_map_area_free(smap, &smap->map);
 		return ERR_PTR(-ENOMEM);
 	}
 
diff --git a/kernel/bpf/bpf_struct_ops.c b/kernel/bpf/bpf_struct_ops.c
index 36f24f8..9fb8ad1 100644
--- a/kernel/bpf/bpf_struct_ops.c
+++ b/kernel/bpf/bpf_struct_ops.c
@@ -577,10 +577,10 @@ static void bpf_struct_ops_map_free(struct bpf_map *map)
 
 	if (st_map->links)
 		bpf_struct_ops_map_put_progs(st_map);
-	bpf_map_area_free(st_map->links);
+	bpf_map_area_free(st_map->links, NULL);
 	bpf_jit_free_exec(st_map->image);
-	bpf_map_area_free(st_map->uvalue);
-	bpf_map_area_free(st_map);
+	bpf_map_area_free(st_map->uvalue, NULL);
+	bpf_map_area_free(st_map, map);
 }
 
 static int bpf_struct_ops_map_alloc_check(union bpf_attr *attr)
diff --git a/kernel/bpf/cpumap.c b/kernel/bpf/cpumap.c
index b5ba34d..7de2ae6 100644
--- a/kernel/bpf/cpumap.c
+++ b/kernel/bpf/cpumap.c
@@ -118,7 +118,7 @@ static struct bpf_map *cpu_map_alloc(union bpf_attr *attr)
 
 	return &cmap->map;
 free_cmap:
-	bpf_map_area_free(cmap);
+	bpf_map_area_free(cmap, &cmap->map);
 	return ERR_PTR(err);
 }
 
@@ -622,8 +622,8 @@ static void cpu_map_free(struct bpf_map *map)
 		/* bq flush and cleanup happens after RCU grace-period */
 		__cpu_map_entry_replace(cmap, i, NULL); /* call_rcu */
 	}
-	bpf_map_area_free(cmap->cpu_map);
-	bpf_map_area_free(cmap);
+	bpf_map_area_free(cmap->cpu_map, NULL);
+	bpf_map_area_free(cmap, map);
 }
 
 /* Elements are kept alive by RCU; either by rcu_read_lock() (from syscall) or
diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
index 20decc7..3268ce7 100644
--- a/kernel/bpf/devmap.c
+++ b/kernel/bpf/devmap.c
@@ -168,7 +168,7 @@ static struct bpf_map *dev_map_alloc(union bpf_attr *attr)
 
 	err = dev_map_init_map(dtab, attr);
 	if (err) {
-		bpf_map_area_free(dtab);
+		bpf_map_area_free(dtab, &dtab->map);
 		return ERR_PTR(err);
 	}
 
@@ -221,7 +221,7 @@ static void dev_map_free(struct bpf_map *map)
 			}
 		}
 
-		bpf_map_area_free(dtab->dev_index_head);
+		bpf_map_area_free(dtab->dev_index_head, NULL);
 	} else {
 		for (i = 0; i < dtab->map.max_entries; i++) {
 			struct bpf_dtab_netdev *dev;
@@ -236,10 +236,10 @@ static void dev_map_free(struct bpf_map *map)
 			kfree(dev);
 		}
 
-		bpf_map_area_free(dtab->netdev_map);
+		bpf_map_area_free(dtab->netdev_map, NULL);
 	}
 
-	bpf_map_area_free(dtab);
+	bpf_map_area_free(dtab, &dtab->map);
 }
 
 static int dev_map_get_next_key(struct bpf_map *map, void *key, void *next_key)
diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
index 48dc04c..1b3653d 100644
--- a/kernel/bpf/hashtab.c
+++ b/kernel/bpf/hashtab.c
@@ -290,7 +290,7 @@ static void htab_free_elems(struct bpf_htab *htab)
 		cond_resched();
 	}
 free_elems:
-	bpf_map_area_free(htab->elems);
+	bpf_map_area_free(htab->elems, NULL);
 }
 
 /* The LRU list has a lock (lru_lock). Each htab bucket has a lock
@@ -576,10 +576,10 @@ static struct bpf_map *htab_map_alloc(union bpf_attr *attr)
 free_map_locked:
 	for (i = 0; i < HASHTAB_MAP_LOCK_COUNT; i++)
 		free_percpu(htab->map_locked[i]);
-	bpf_map_area_free(htab->buckets);
+	bpf_map_area_free(htab->buckets, NULL);
 free_htab:
 	lockdep_unregister_key(&htab->lockdep_key);
-	bpf_map_area_free(htab);
+	bpf_map_area_free(htab, &htab->map);
 	return ERR_PTR(err);
 }
 
@@ -1492,11 +1492,11 @@ static void htab_map_free(struct bpf_map *map)
 
 	bpf_map_free_kptr_off_tab(map);
 	free_percpu(htab->extra_elems);
-	bpf_map_area_free(htab->buckets);
+	bpf_map_area_free(htab->buckets, NULL);
 	for (i = 0; i < HASHTAB_MAP_LOCK_COUNT; i++)
 		free_percpu(htab->map_locked[i]);
 	lockdep_unregister_key(&htab->lockdep_key);
-	bpf_map_area_free(htab);
+	bpf_map_area_free(htab, map);
 }
 
 static void htab_map_seq_show_elem(struct bpf_map *map, void *key,
diff --git a/kernel/bpf/local_storage.c b/kernel/bpf/local_storage.c
index 098cf33..c705d66 100644
--- a/kernel/bpf/local_storage.c
+++ b/kernel/bpf/local_storage.c
@@ -345,7 +345,7 @@ static void cgroup_storage_map_free(struct bpf_map *_map)
 	WARN_ON(!RB_EMPTY_ROOT(&map->root));
 	WARN_ON(!list_empty(&map->list));
 
-	bpf_map_area_free(map);
+	bpf_map_area_free(map, _map);
 }
 
 static int cgroup_storage_delete_elem(struct bpf_map *map, void *key)
diff --git a/kernel/bpf/lpm_trie.c b/kernel/bpf/lpm_trie.c
index d833496..fd99360 100644
--- a/kernel/bpf/lpm_trie.c
+++ b/kernel/bpf/lpm_trie.c
@@ -609,7 +609,7 @@ static void trie_free(struct bpf_map *map)
 	}
 
 out:
-	bpf_map_area_free(trie);
+	bpf_map_area_free(trie, map);
 }
 
 static int trie_get_next_key(struct bpf_map *map, void *_key, void *_next_key)
diff --git a/kernel/bpf/offload.c b/kernel/bpf/offload.c
index 13e4efc..c9941a9 100644
--- a/kernel/bpf/offload.c
+++ b/kernel/bpf/offload.c
@@ -404,7 +404,7 @@ struct bpf_map *bpf_map_offload_map_alloc(union bpf_attr *attr)
 err_unlock:
 	up_write(&bpf_devs_lock);
 	rtnl_unlock();
-	bpf_map_area_free(offmap);
+	bpf_map_area_free(offmap, &offmap->map);
 	return ERR_PTR(err);
 }
 
@@ -428,7 +428,7 @@ void bpf_map_offload_map_free(struct bpf_map *map)
 	up_write(&bpf_devs_lock);
 	rtnl_unlock();
 
-	bpf_map_area_free(offmap);
+	bpf_map_area_free(offmap, map);
 }
 
 int bpf_map_offload_lookup_elem(struct bpf_map *map, void *key, void *value)
diff --git a/kernel/bpf/queue_stack_maps.c b/kernel/bpf/queue_stack_maps.c
index 8a5e060..f2ec0c4 100644
--- a/kernel/bpf/queue_stack_maps.c
+++ b/kernel/bpf/queue_stack_maps.c
@@ -92,7 +92,7 @@ static void queue_stack_map_free(struct bpf_map *map)
 {
 	struct bpf_queue_stack *qs = bpf_queue_stack(map);
 
-	bpf_map_area_free(qs);
+	bpf_map_area_free(qs, map);
 }
 
 static int __queue_map_get(struct bpf_map *map, void *value, bool delete)
diff --git a/kernel/bpf/reuseport_array.c b/kernel/bpf/reuseport_array.c
index e2618fb..594cdb0 100644
--- a/kernel/bpf/reuseport_array.c
+++ b/kernel/bpf/reuseport_array.c
@@ -146,7 +146,7 @@ static void reuseport_array_free(struct bpf_map *map)
 	 * Once reaching here, all sk->sk_user_data is not
 	 * referencing this "array". "array" can be freed now.
 	 */
-	bpf_map_area_free(array);
+	bpf_map_area_free(array, map);
 }
 
 static struct bpf_map *reuseport_array_alloc(union bpf_attr *attr)
diff --git a/kernel/bpf/ringbuf.c b/kernel/bpf/ringbuf.c
index b483aea..74dd8dc 100644
--- a/kernel/bpf/ringbuf.c
+++ b/kernel/bpf/ringbuf.c
@@ -116,7 +116,7 @@ static struct bpf_ringbuf *bpf_ringbuf_area_alloc(size_t data_sz, int numa_node)
 err_free_pages:
 	for (i = 0; i < nr_pages; i++)
 		__free_page(pages[i]);
-	bpf_map_area_free(pages);
+	bpf_map_area_free(pages, NULL);
 	return NULL;
 }
 
@@ -172,7 +172,7 @@ static struct bpf_map *ringbuf_map_alloc(union bpf_attr *attr)
 
 	rb_map->rb = bpf_ringbuf_alloc(attr->max_entries, rb_map->map.numa_node);
 	if (!rb_map->rb) {
-		bpf_map_area_free(rb_map);
+		bpf_map_area_free(rb_map, &rb_map->map);
 		return ERR_PTR(-ENOMEM);
 	}
 
@@ -190,7 +190,7 @@ static void bpf_ringbuf_free(struct bpf_ringbuf *rb)
 	vunmap(rb);
 	for (i = 0; i < nr_pages; i++)
 		__free_page(pages[i]);
-	bpf_map_area_free(pages);
+	bpf_map_area_free(pages, NULL);
 }
 
 static void ringbuf_map_free(struct bpf_map *map)
@@ -199,7 +199,7 @@ static void ringbuf_map_free(struct bpf_map *map)
 
 	rb_map = container_of(map, struct bpf_ringbuf_map, map);
 	bpf_ringbuf_free(rb_map->rb);
-	bpf_map_area_free(rb_map);
+	bpf_map_area_free(rb_map, map);
 }
 
 static void *ringbuf_map_lookup_elem(struct bpf_map *map, void *key)
diff --git a/kernel/bpf/stackmap.c b/kernel/bpf/stackmap.c
index 1adbe67..042b7d2 100644
--- a/kernel/bpf/stackmap.c
+++ b/kernel/bpf/stackmap.c
@@ -62,7 +62,7 @@ static int prealloc_elems_and_freelist(struct bpf_stack_map *smap)
 	return 0;
 
 free_elems:
-	bpf_map_area_free(smap->elems);
+	bpf_map_area_free(smap->elems, NULL);
 	return err;
 }
 
@@ -120,7 +120,7 @@ static struct bpf_map *stack_map_alloc(union bpf_attr *attr)
 put_buffers:
 	put_callchain_buffers();
 free_smap:
-	bpf_map_area_free(smap);
+	bpf_map_area_free(smap, &smap->map);
 	return ERR_PTR(err);
 }
 
@@ -648,9 +648,9 @@ static void stack_map_free(struct bpf_map *map)
 {
 	struct bpf_stack_map *smap = container_of(map, struct bpf_stack_map, map);
 
-	bpf_map_area_free(smap->elems);
+	bpf_map_area_free(smap->elems, NULL);
 	pcpu_freelist_destroy(&smap->freelist);
-	bpf_map_area_free(smap);
+	bpf_map_area_free(smap, map);
 	put_callchain_buffers();
 }
 
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 19c3a81..01d8d4a 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -293,6 +293,34 @@ static int bpf_map_copy_value(struct bpf_map *map, void *key, void *value,
 	return err;
 }
 
+#ifdef CONFIG_MEMCG_KMEM
+static void bpf_map_save_memcg(struct bpf_map *map)
+{
+	/* Currently if a map is created by a process belonging to the root
+	 * memory cgroup, get_obj_cgroup_from_current() will return NULL.
+	 * So we have to check map->objcg for being NULL each time it's
+	 * being used.
+	 */
+	map->objcg = get_obj_cgroup_from_current();
+}
+
+static void bpf_map_release_memcg(struct bpf_map *map)
+{
+	if (map->objcg)
+		obj_cgroup_put(map->objcg);
+}
+
+#else
+static void bpf_map_save_memcg(struct bpf_map *map)
+{
+}
+
+static void bpf_map_release_memcg(struct bpf_map *map)
+{
+}
+
+#endif
+
 /* Please, do not use this function outside from the map creation path
  * (e.g. in map update path) without taking care of setting the active
  * memory cgroup (see at bpf_map_kmalloc_node() for example).
@@ -344,8 +372,10 @@ void *bpf_map_area_mmapable_alloc(u64 size, int numa_node)
 	return __bpf_map_area_alloc(size, numa_node, true);
 }
 
-void bpf_map_area_free(void *area)
+void bpf_map_area_free(void *area, struct bpf_map *map)
 {
+	if (map)
+		bpf_map_release_memcg(map);
 	kvfree(area);
 }
 
@@ -363,6 +393,7 @@ static u32 bpf_map_flags_retain_permanent(u32 flags)
 
 void bpf_map_init_from_attr(struct bpf_map *map, union bpf_attr *attr)
 {
+	bpf_map_save_memcg(map);
 	map->map_type = attr->map_type;
 	map->key_size = attr->key_size;
 	map->value_size = attr->value_size;
@@ -417,22 +448,6 @@ void bpf_map_free_id(struct bpf_map *map, bool do_idr_lock)
 }
 
 #ifdef CONFIG_MEMCG_KMEM
-static void bpf_map_save_memcg(struct bpf_map *map)
-{
-	/* Currently if a map is created by a process belonging to the root
-	 * memory cgroup, get_obj_cgroup_from_current() will return NULL.
-	 * So we have to check map->objcg for being NULL each time it's
-	 * being used.
-	 */
-	map->objcg = get_obj_cgroup_from_current();
-}
-
-static void bpf_map_release_memcg(struct bpf_map *map)
-{
-	if (map->objcg)
-		obj_cgroup_put(map->objcg);
-}
-
 void *bpf_map_kmalloc_node(const struct bpf_map *map, size_t size, gfp_t flags,
 			   int node)
 {
@@ -477,14 +492,6 @@ void __percpu *bpf_map_alloc_percpu(const struct bpf_map *map, size_t size,
 	return ptr;
 }
 
-#else
-static void bpf_map_save_memcg(struct bpf_map *map)
-{
-}
-
-static void bpf_map_release_memcg(struct bpf_map *map)
-{
-}
 #endif
 
 static int bpf_map_kptr_off_cmp(const void *a, const void *b)
@@ -605,7 +612,6 @@ static void bpf_map_free_deferred(struct work_struct *work)
 
 	security_bpf_map_free(map);
 	kfree(map->off_arr);
-	bpf_map_release_memcg(map);
 	/* implementation dependent freeing, map_free callback also does
 	 * bpf_map_free_kptr_off_tab, if needed.
 	 */
@@ -1154,8 +1160,6 @@ static int map_create(union bpf_attr *attr)
 	if (err)
 		goto free_map_sec;
 
-	bpf_map_save_memcg(map);
-
 	err = bpf_map_new_fd(map, f_flags);
 	if (err < 0) {
 		/* failed to allocate fd.
diff --git a/net/core/sock_map.c b/net/core/sock_map.c
index d0c4338..e8f414a 100644
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -52,7 +52,7 @@ static struct bpf_map *sock_map_alloc(union bpf_attr *attr)
 				       sizeof(struct sock *),
 				       stab->map.numa_node);
 	if (!stab->sks) {
-		bpf_map_area_free(stab);
+		bpf_map_area_free(stab, &stab->map);
 		return ERR_PTR(-ENOMEM);
 	}
 
@@ -360,8 +360,8 @@ static void sock_map_free(struct bpf_map *map)
 	/* wait for psock readers accessing its map link */
 	synchronize_rcu();
 
-	bpf_map_area_free(stab->sks);
-	bpf_map_area_free(stab);
+	bpf_map_area_free(stab->sks, NULL);
+	bpf_map_area_free(stab, map);
 }
 
 static void sock_map_release_progs(struct bpf_map *map)
@@ -1106,7 +1106,7 @@ static struct bpf_map *sock_hash_alloc(union bpf_attr *attr)
 
 	return &htab->map;
 free_htab:
-	bpf_map_area_free(htab);
+	bpf_map_area_free(htab, &htab->map);
 	return ERR_PTR(err);
 }
 
@@ -1158,8 +1158,8 @@ static void sock_hash_free(struct bpf_map *map)
 	/* wait for psock readers accessing its map link */
 	synchronize_rcu();
 
-	bpf_map_area_free(htab->buckets);
-	bpf_map_area_free(htab);
+	bpf_map_area_free(htab->buckets, NULL);
+	bpf_map_area_free(htab, map);
 }
 
 static void *sock_hash_lookup_sys(struct bpf_map *map, void *key)
diff --git a/net/xdp/xskmap.c b/net/xdp/xskmap.c
index acc8e52..5abb87e 100644
--- a/net/xdp/xskmap.c
+++ b/net/xdp/xskmap.c
@@ -90,7 +90,7 @@ static void xsk_map_free(struct bpf_map *map)
 	struct xsk_map *m = container_of(map, struct xsk_map, map);
 
 	synchronize_net();
-	bpf_map_area_free(m);
+	bpf_map_area_free(m, map);
 }
 
 static int xsk_map_get_next_key(struct bpf_map *map, void *key, void *next_key)
-- 
1.8.3.1

