Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F31A58EF2A
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 17:19:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233038AbiHJPS4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 11:18:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232999AbiHJPSx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 11:18:53 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BE6E78BCA;
        Wed, 10 Aug 2022 08:18:52 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id t22-20020a17090a449600b001f617f2bf3eso3717685pjg.0;
        Wed, 10 Aug 2022 08:18:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=kdwwAaZR+asNE4VplBgkNqPcX927kxyG8S7wtrO1tJQ=;
        b=DtMIAdfYNd+6krVLUt0b4W/LijFJKwIGp5JOfCRmrJJiDP2+FSE8vqIXJXTQFl+LYe
         STuuDOcSIZPTH3lx0BuajtH5E6c6X347lrKXrVdd0FeiWDf8CqFkjbdjHuvUiB8pFwIU
         WZH8a3UrSr/nbWO5ADjfEVtStTblyelcn5ZnblDGovut7xU8YCkIY73LbjWk0W7voxPh
         w4uufLb0JKRjOSAwPLaZIMigZMnp8piOdHTxt9t87eEzu766zAKQyGvWjtujB8sLUzRI
         e152lm7FCAJii4mblD/u42vu51bEDhWS2V13RtGmiCWjKgcwt9uudhoMpdbzSNxVy5Sc
         u7vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=kdwwAaZR+asNE4VplBgkNqPcX927kxyG8S7wtrO1tJQ=;
        b=7FfNmIZAGsZ+9V+UL4oclfpBLePV/kRSRhSbuWj2n5B18hKhK9Njp3V8gs/kQDjOAd
         0npsNvXKDRcbpg+xm1efG3VQnK5F0QPYg7aMDyp/NazViqRf6AMXB2/BP9HYMSw4gahI
         GxEgONKjoMRDrMC0hA+gmJA4mTDkc2WsQtesD/xDB+DC92BTyS6hrNp1kGSw2T8E/27/
         S0R3vYWyIWpHbX458+Uk2CXPBhmcMe6WveRxUANZZ6E5S8ibOZBWWRrK7xRHaxbeYYEz
         YTvg3qkBd+s0WfbYuyIYso/HcKiN/rDKvpb3unHnGZ2isAvSNqc4ziaILDQ0yvI/MGuU
         DM/A==
X-Gm-Message-State: ACgBeo1n7PRmszuQ6w45wv60GICk+5LeqBi9wxlL9KfzH7xOFF7Crdnv
        hHOkVXNPGpAA4ZDsnBTfPQc=
X-Google-Smtp-Source: AA6agR5ZP1E2zsKWFzCfFu47w/Pccm+vqmJRsO9y2UBclWBS6HzwGq8nnjbZmM8oMmz9dZEFYXG+2w==
X-Received: by 2002:a17:90b:17c9:b0:1f3:3a7c:a3a7 with SMTP id me9-20020a17090b17c900b001f33a7ca3a7mr4437962pjb.76.1660144731574;
        Wed, 10 Aug 2022 08:18:51 -0700 (PDT)
Received: from vultr.guest ([2001:19f0:6001:5c3e:5400:4ff:fe19:c3bc])
        by smtp.gmail.com with ESMTPSA id 85-20020a621558000000b0052b6ed5ca40sm2071935pfv.192.2022.08.10.08.18.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Aug 2022 08:18:50 -0700 (PDT)
From:   Yafang Shao <laoar.shao@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org, hannes@cmpxchg.org,
        mhocko@kernel.org, roman.gushchin@linux.dev, shakeelb@google.com,
        songmuchun@bytedance.com, akpm@linux-foundation.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, linux-mm@kvack.org,
        Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH bpf-next 04/15] bpf: Use bpf_map_area_alloc consistently on bpf map creation
Date:   Wed, 10 Aug 2022 15:18:29 +0000
Message-Id: <20220810151840.16394-5-laoar.shao@gmail.com>
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

Let's use the generic helper bpf_map_area_alloc() instead of the
open-coded kzalloc helpers in bpf maps creation path.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 kernel/bpf/bpf_local_storage.c |  6 +++---
 kernel/bpf/cpumap.c            |  6 +++---
 kernel/bpf/devmap.c            |  6 +++---
 kernel/bpf/hashtab.c           |  6 +++---
 kernel/bpf/local_storage.c     |  5 ++---
 kernel/bpf/lpm_trie.c          |  4 ++--
 kernel/bpf/offload.c           |  6 +++---
 kernel/bpf/ringbuf.c           |  6 +++---
 net/core/sock_map.c            | 12 ++++++------
 9 files changed, 28 insertions(+), 29 deletions(-)

diff --git a/kernel/bpf/bpf_local_storage.c b/kernel/bpf/bpf_local_storage.c
index 8ce40fd..4ee2e72 100644
--- a/kernel/bpf/bpf_local_storage.c
+++ b/kernel/bpf/bpf_local_storage.c
@@ -582,7 +582,7 @@ void bpf_local_storage_map_free(struct bpf_local_storage_map *smap,
 	synchronize_rcu();
 
 	kvfree(smap->buckets);
-	kfree(smap);
+	bpf_map_area_free(smap);
 }
 
 int bpf_local_storage_map_alloc_check(union bpf_attr *attr)
@@ -610,7 +610,7 @@ struct bpf_local_storage_map *bpf_local_storage_map_alloc(union bpf_attr *attr)
 	unsigned int i;
 	u32 nbuckets;
 
-	smap = kzalloc(sizeof(*smap), GFP_USER | __GFP_NOWARN | __GFP_ACCOUNT);
+	smap = bpf_map_area_alloc(sizeof(*smap), NUMA_NO_NODE);
 	if (!smap)
 		return ERR_PTR(-ENOMEM);
 	bpf_map_init_from_attr(&smap->map, attr);
@@ -623,7 +623,7 @@ struct bpf_local_storage_map *bpf_local_storage_map_alloc(union bpf_attr *attr)
 	smap->buckets = kvcalloc(sizeof(*smap->buckets), nbuckets,
 				 GFP_USER | __GFP_NOWARN | __GFP_ACCOUNT);
 	if (!smap->buckets) {
-		kfree(smap);
+		bpf_map_area_free(smap);
 		return ERR_PTR(-ENOMEM);
 	}
 
diff --git a/kernel/bpf/cpumap.c b/kernel/bpf/cpumap.c
index b25ca9d..b5ba34d 100644
--- a/kernel/bpf/cpumap.c
+++ b/kernel/bpf/cpumap.c
@@ -97,7 +97,7 @@ static struct bpf_map *cpu_map_alloc(union bpf_attr *attr)
 	    attr->map_flags & ~BPF_F_NUMA_NODE)
 		return ERR_PTR(-EINVAL);
 
-	cmap = kzalloc(sizeof(*cmap), GFP_USER | __GFP_NOWARN |  __GFP_ACCOUNT);
+	cmap = bpf_map_area_alloc(sizeof(*cmap), NUMA_NO_NODE);
 	if (!cmap)
 		return ERR_PTR(-ENOMEM);
 
@@ -118,7 +118,7 @@ static struct bpf_map *cpu_map_alloc(union bpf_attr *attr)
 
 	return &cmap->map;
 free_cmap:
-	kfree(cmap);
+	bpf_map_area_free(cmap);
 	return ERR_PTR(err);
 }
 
@@ -623,7 +623,7 @@ static void cpu_map_free(struct bpf_map *map)
 		__cpu_map_entry_replace(cmap, i, NULL); /* call_rcu */
 	}
 	bpf_map_area_free(cmap->cpu_map);
-	kfree(cmap);
+	bpf_map_area_free(cmap);
 }
 
 /* Elements are kept alive by RCU; either by rcu_read_lock() (from syscall) or
diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
index 88feaa0..f9a87dc 100644
--- a/kernel/bpf/devmap.c
+++ b/kernel/bpf/devmap.c
@@ -163,13 +163,13 @@ static struct bpf_map *dev_map_alloc(union bpf_attr *attr)
 	if (!capable(CAP_NET_ADMIN))
 		return ERR_PTR(-EPERM);
 
-	dtab = kzalloc(sizeof(*dtab), GFP_USER | __GFP_NOWARN | __GFP_ACCOUNT);
+	dtab = bpf_map_area_alloc(sizeof(*dtab), NUMA_NO_NODE);
 	if (!dtab)
 		return ERR_PTR(-ENOMEM);
 
 	err = dev_map_init_map(dtab, attr);
 	if (err) {
-		kfree(dtab);
+		bpf_map_area_free(dtab);
 		return ERR_PTR(err);
 	}
 
@@ -240,7 +240,7 @@ static void dev_map_free(struct bpf_map *map)
 		bpf_map_area_free(dtab->netdev_map);
 	}
 
-	kfree(dtab);
+	bpf_map_area_free(dtab);
 }
 
 static int dev_map_get_next_key(struct bpf_map *map, void *key, void *next_key)
diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
index f1e5303..8392f7f 100644
--- a/kernel/bpf/hashtab.c
+++ b/kernel/bpf/hashtab.c
@@ -495,7 +495,7 @@ static struct bpf_map *htab_map_alloc(union bpf_attr *attr)
 	struct bpf_htab *htab;
 	int err, i;
 
-	htab = kzalloc(sizeof(*htab), GFP_USER | __GFP_NOWARN | __GFP_ACCOUNT);
+	htab = bpf_map_area_alloc(sizeof(*htab), NUMA_NO_NODE);
 	if (!htab)
 		return ERR_PTR(-ENOMEM);
 
@@ -579,7 +579,7 @@ static struct bpf_map *htab_map_alloc(union bpf_attr *attr)
 	bpf_map_area_free(htab->buckets);
 free_htab:
 	lockdep_unregister_key(&htab->lockdep_key);
-	kfree(htab);
+	bpf_map_area_free(htab);
 	return ERR_PTR(err);
 }
 
@@ -1496,7 +1496,7 @@ static void htab_map_free(struct bpf_map *map)
 	for (i = 0; i < HASHTAB_MAP_LOCK_COUNT; i++)
 		free_percpu(htab->map_locked[i]);
 	lockdep_unregister_key(&htab->lockdep_key);
-	kfree(htab);
+	bpf_map_area_free(htab);
 }
 
 static void htab_map_seq_show_elem(struct bpf_map *map, void *key,
diff --git a/kernel/bpf/local_storage.c b/kernel/bpf/local_storage.c
index a64255e..098cf33 100644
--- a/kernel/bpf/local_storage.c
+++ b/kernel/bpf/local_storage.c
@@ -313,8 +313,7 @@ static struct bpf_map *cgroup_storage_map_alloc(union bpf_attr *attr)
 		/* max_entries is not used and enforced to be 0 */
 		return ERR_PTR(-EINVAL);
 
-	map = kzalloc_node(sizeof(struct bpf_cgroup_storage_map),
-			   GFP_USER | __GFP_NOWARN | __GFP_ACCOUNT, numa_node);
+	map = bpf_map_area_alloc(sizeof(struct bpf_cgroup_storage_map), numa_node);
 	if (!map)
 		return ERR_PTR(-ENOMEM);
 
@@ -346,7 +345,7 @@ static void cgroup_storage_map_free(struct bpf_map *_map)
 	WARN_ON(!RB_EMPTY_ROOT(&map->root));
 	WARN_ON(!list_empty(&map->list));
 
-	kfree(map);
+	bpf_map_area_free(map);
 }
 
 static int cgroup_storage_delete_elem(struct bpf_map *map, void *key)
diff --git a/kernel/bpf/lpm_trie.c b/kernel/bpf/lpm_trie.c
index d789e3b..d833496 100644
--- a/kernel/bpf/lpm_trie.c
+++ b/kernel/bpf/lpm_trie.c
@@ -558,7 +558,7 @@ static struct bpf_map *trie_alloc(union bpf_attr *attr)
 	    attr->value_size > LPM_VAL_SIZE_MAX)
 		return ERR_PTR(-EINVAL);
 
-	trie = kzalloc(sizeof(*trie), GFP_USER | __GFP_NOWARN | __GFP_ACCOUNT);
+	trie = bpf_map_area_alloc(sizeof(*trie), NUMA_NO_NODE);
 	if (!trie)
 		return ERR_PTR(-ENOMEM);
 
@@ -609,7 +609,7 @@ static void trie_free(struct bpf_map *map)
 	}
 
 out:
-	kfree(trie);
+	bpf_map_area_free(trie);
 }
 
 static int trie_get_next_key(struct bpf_map *map, void *_key, void *_next_key)
diff --git a/kernel/bpf/offload.c b/kernel/bpf/offload.c
index 5a629a1..13e4efc 100644
--- a/kernel/bpf/offload.c
+++ b/kernel/bpf/offload.c
@@ -372,7 +372,7 @@ struct bpf_map *bpf_map_offload_map_alloc(union bpf_attr *attr)
 	    attr->map_type != BPF_MAP_TYPE_HASH)
 		return ERR_PTR(-EINVAL);
 
-	offmap = kzalloc(sizeof(*offmap), GFP_USER | __GFP_NOWARN);
+	offmap = bpf_map_area_alloc(sizeof(*offmap), NUMA_NO_NODE);
 	if (!offmap)
 		return ERR_PTR(-ENOMEM);
 
@@ -404,7 +404,7 @@ struct bpf_map *bpf_map_offload_map_alloc(union bpf_attr *attr)
 err_unlock:
 	up_write(&bpf_devs_lock);
 	rtnl_unlock();
-	kfree(offmap);
+	bpf_map_area_free(offmap);
 	return ERR_PTR(err);
 }
 
@@ -428,7 +428,7 @@ void bpf_map_offload_map_free(struct bpf_map *map)
 	up_write(&bpf_devs_lock);
 	rtnl_unlock();
 
-	kfree(offmap);
+	bpf_map_area_free(offmap);
 }
 
 int bpf_map_offload_lookup_elem(struct bpf_map *map, void *key, void *value)
diff --git a/kernel/bpf/ringbuf.c b/kernel/bpf/ringbuf.c
index df8062c..b483aea 100644
--- a/kernel/bpf/ringbuf.c
+++ b/kernel/bpf/ringbuf.c
@@ -164,7 +164,7 @@ static struct bpf_map *ringbuf_map_alloc(union bpf_attr *attr)
 		return ERR_PTR(-E2BIG);
 #endif
 
-	rb_map = kzalloc(sizeof(*rb_map), GFP_USER | __GFP_NOWARN | __GFP_ACCOUNT);
+	rb_map = bpf_map_area_alloc(sizeof(*rb_map), NUMA_NO_NODE);
 	if (!rb_map)
 		return ERR_PTR(-ENOMEM);
 
@@ -172,7 +172,7 @@ static struct bpf_map *ringbuf_map_alloc(union bpf_attr *attr)
 
 	rb_map->rb = bpf_ringbuf_alloc(attr->max_entries, rb_map->map.numa_node);
 	if (!rb_map->rb) {
-		kfree(rb_map);
+		bpf_map_area_free(rb_map);
 		return ERR_PTR(-ENOMEM);
 	}
 
@@ -199,7 +199,7 @@ static void ringbuf_map_free(struct bpf_map *map)
 
 	rb_map = container_of(map, struct bpf_ringbuf_map, map);
 	bpf_ringbuf_free(rb_map->rb);
-	kfree(rb_map);
+	bpf_map_area_free(rb_map);
 }
 
 static void *ringbuf_map_lookup_elem(struct bpf_map *map, void *key)
diff --git a/net/core/sock_map.c b/net/core/sock_map.c
index 763d771..d0c4338 100644
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -41,7 +41,7 @@ static struct bpf_map *sock_map_alloc(union bpf_attr *attr)
 	    attr->map_flags & ~SOCK_CREATE_FLAG_MASK)
 		return ERR_PTR(-EINVAL);
 
-	stab = kzalloc(sizeof(*stab), GFP_USER | __GFP_NOWARN | __GFP_ACCOUNT);
+	stab = bpf_map_area_alloc(sizeof(*stab), NUMA_NO_NODE);
 	if (!stab)
 		return ERR_PTR(-ENOMEM);
 
@@ -52,7 +52,7 @@ static struct bpf_map *sock_map_alloc(union bpf_attr *attr)
 				       sizeof(struct sock *),
 				       stab->map.numa_node);
 	if (!stab->sks) {
-		kfree(stab);
+		bpf_map_area_free(stab);
 		return ERR_PTR(-ENOMEM);
 	}
 
@@ -361,7 +361,7 @@ static void sock_map_free(struct bpf_map *map)
 	synchronize_rcu();
 
 	bpf_map_area_free(stab->sks);
-	kfree(stab);
+	bpf_map_area_free(stab);
 }
 
 static void sock_map_release_progs(struct bpf_map *map)
@@ -1076,7 +1076,7 @@ static struct bpf_map *sock_hash_alloc(union bpf_attr *attr)
 	if (attr->key_size > MAX_BPF_STACK)
 		return ERR_PTR(-E2BIG);
 
-	htab = kzalloc(sizeof(*htab), GFP_USER | __GFP_NOWARN | __GFP_ACCOUNT);
+	htab = bpf_map_area_alloc(sizeof(*htab), NUMA_NO_NODE);
 	if (!htab)
 		return ERR_PTR(-ENOMEM);
 
@@ -1106,7 +1106,7 @@ static struct bpf_map *sock_hash_alloc(union bpf_attr *attr)
 
 	return &htab->map;
 free_htab:
-	kfree(htab);
+	bpf_map_area_free(htab);
 	return ERR_PTR(err);
 }
 
@@ -1159,7 +1159,7 @@ static void sock_hash_free(struct bpf_map *map)
 	synchronize_rcu();
 
 	bpf_map_area_free(htab->buckets);
-	kfree(htab);
+	bpf_map_area_free(htab);
 }
 
 static void *sock_hash_lookup_sys(struct bpf_map *map, void *key)
-- 
1.8.3.1

