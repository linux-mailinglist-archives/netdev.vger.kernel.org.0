Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4289E4DE98E
	for <lists+netdev@lfdr.de>; Sat, 19 Mar 2022 18:30:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243393AbiCSRcN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Mar 2022 13:32:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243300AbiCSRcF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Mar 2022 13:32:05 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 564CB45505;
        Sat, 19 Mar 2022 10:30:44 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id s11so12095356pfu.13;
        Sat, 19 Mar 2022 10:30:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pfPDh91liqZm+BP4mghw0y9pBJj8lD1CecCVSBxX9RQ=;
        b=LiVGSCcXA6fHEXuuBuyhZr2cUPqAXeiwwy8Is9dF8j216O3XiRVmmBHNuvfaDGVv19
         741ttud2pKa+CpCpdY27U034+eAiYDX4yOgjoX7e8VxXXWL+ze7fsqT7HfKNQgfXKH2o
         zZejoBD6UhxhZjz+912GqD8nwU+A/+GM99pTo1lSHZp8b9yP0z5AV3BUytsevTo742tr
         xeWn53M5qe+Uw2hkQIxmpQp22r6PCBMPEjxQd9HbJoQ7BcJYu1Hob0OSCGKWGveTpxK3
         GJTitbn7tITZXV9f8dAQTy2ibHHjr/ZTfwzMoR8TAsnCAC7G1rhRfkwpbnyn99q9FD9X
         AcHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pfPDh91liqZm+BP4mghw0y9pBJj8lD1CecCVSBxX9RQ=;
        b=nQcSaYaWPeSuc6mQNWPA9HNgd18/JEYQmNt9VcEB7Lj5tqFjRghvhdB7N9HOzkLmEd
         Df56jECbHxtGz2LekvYFoXkuoZ/5NCOOB4EjTQwY5iVDValkTKPYtVFZH9RGx9qA9/Ms
         E0yfdRP+qy/B8vSIJe8L/xUwQBcbwGqFYujD89K16wkX4NClOrotOujHRwFhFbrKKFIV
         ysbyChz1t3+MSEe/8JMrRkhxRBtkvsdsG+Pf8H0oIrk3gDUyYOY9otPY2LldC30M5R96
         JGz2cP6hBlNVhcPSnCHo4KbHaFPytN1uPcAzPBqA6lcbrgnmLMDzB0tFpe7/NfXO12ba
         QIdA==
X-Gm-Message-State: AOAM530Y2UdL8bbWk1k6/DflN9E9U58H0gDXXkll1vKfZ7RvKQYVADyQ
        0GF6z1jfypFe7N8UMwjrLPQ=
X-Google-Smtp-Source: ABdhPJwXxdHfQIbhiS31nJsRloSgUOj73eXxsJggkaIikMTT44n46uK1Cl3+YoW4QIW7h+1LM3C1Zw==
X-Received: by 2002:a63:af06:0:b0:378:3582:a49f with SMTP id w6-20020a63af06000000b003783582a49fmr12325169pge.125.1647711043808;
        Sat, 19 Mar 2022 10:30:43 -0700 (PDT)
Received: from vultr.guest ([2001:19f0:6001:4ab8:5400:3ff:fee9:a154])
        by smtp.gmail.com with ESMTPSA id k21-20020aa788d5000000b004f71bff2893sm12722136pff.67.2022.03.19.10.30.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Mar 2022 10:30:43 -0700 (PDT)
From:   Yafang Shao <laoar.shao@gmail.com>
To:     roman.gushchin@linux.dev, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, shuah@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org, Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH 03/14] bpf: Enable no charge in map _CREATE_FLAG_MASK
Date:   Sat, 19 Mar 2022 17:30:25 +0000
Message-Id: <20220319173036.23352-4-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220319173036.23352-1-laoar.shao@gmail.com>
References: <20220319173036.23352-1-laoar.shao@gmail.com>
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

Many maps have their create masks to warn the invalid map flag. Set
BPF_F_NO_CHARGE in all these masks to enable it.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 kernel/bpf/arraymap.c          | 2 +-
 kernel/bpf/bloom_filter.c      | 4 ++--
 kernel/bpf/bpf_local_storage.c | 3 ++-
 kernel/bpf/bpf_struct_ops.c    | 5 ++++-
 kernel/bpf/cpumap.c            | 5 ++++-
 kernel/bpf/devmap.c            | 2 +-
 kernel/bpf/hashtab.c           | 2 +-
 kernel/bpf/local_storage.c     | 2 +-
 kernel/bpf/lpm_trie.c          | 2 +-
 kernel/bpf/queue_stack_maps.c  | 2 +-
 kernel/bpf/ringbuf.c           | 2 +-
 kernel/bpf/stackmap.c          | 2 +-
 net/core/sock_map.c            | 2 +-
 net/xdp/xskmap.c               | 5 ++++-
 14 files changed, 25 insertions(+), 15 deletions(-)

diff --git a/kernel/bpf/arraymap.c b/kernel/bpf/arraymap.c
index 7f145aefbff8..ac123747303c 100644
--- a/kernel/bpf/arraymap.c
+++ b/kernel/bpf/arraymap.c
@@ -16,7 +16,7 @@
 
 #define ARRAY_CREATE_FLAG_MASK \
 	(BPF_F_NUMA_NODE | BPF_F_MMAPABLE | BPF_F_ACCESS_MASK | \
-	 BPF_F_PRESERVE_ELEMS | BPF_F_INNER_MAP)
+	 BPF_F_PRESERVE_ELEMS | BPF_F_INNER_MAP | BPF_F_NO_CHARGE)
 
 static void bpf_array_free_percpu(struct bpf_array *array)
 {
diff --git a/kernel/bpf/bloom_filter.c b/kernel/bpf/bloom_filter.c
index b141a1346f72..f8ebfb4831e5 100644
--- a/kernel/bpf/bloom_filter.c
+++ b/kernel/bpf/bloom_filter.c
@@ -8,8 +8,8 @@
 #include <linux/jhash.h>
 #include <linux/random.h>
 
-#define BLOOM_CREATE_FLAG_MASK \
-	(BPF_F_NUMA_NODE | BPF_F_ZERO_SEED | BPF_F_ACCESS_MASK)
+#define BLOOM_CREATE_FLAG_MASK	(BPF_F_NUMA_NODE |	\
+	BPF_F_ZERO_SEED | BPF_F_ACCESS_MASK | BPF_F_NO_CHARGE)
 
 struct bpf_bloom_filter {
 	struct bpf_map map;
diff --git a/kernel/bpf/bpf_local_storage.c b/kernel/bpf/bpf_local_storage.c
index 092a1ac772d7..a92d3032fcde 100644
--- a/kernel/bpf/bpf_local_storage.c
+++ b/kernel/bpf/bpf_local_storage.c
@@ -15,7 +15,8 @@
 #include <linux/rcupdate_trace.h>
 #include <linux/rcupdate_wait.h>
 
-#define BPF_LOCAL_STORAGE_CREATE_FLAG_MASK (BPF_F_NO_PREALLOC | BPF_F_CLONE)
+#define BPF_LOCAL_STORAGE_CREATE_FLAG_MASK	\
+	(BPF_F_NO_PREALLOC | BPF_F_CLONE | BPF_F_NO_CHARGE)
 
 static struct bpf_local_storage_map_bucket *
 select_bucket(struct bpf_local_storage_map *smap,
diff --git a/kernel/bpf/bpf_struct_ops.c b/kernel/bpf/bpf_struct_ops.c
index 21069dbe9138..09eb848e6d12 100644
--- a/kernel/bpf/bpf_struct_ops.c
+++ b/kernel/bpf/bpf_struct_ops.c
@@ -21,6 +21,8 @@ enum bpf_struct_ops_state {
 	refcount_t refcnt;				\
 	enum bpf_struct_ops_state state
 
+#define STRUCT_OPS_CREATE_FLAG_MASK (BPF_F_NO_CHARGE)
+
 struct bpf_struct_ops_value {
 	BPF_STRUCT_OPS_COMMON_VALUE;
 	char data[] ____cacheline_aligned_in_smp;
@@ -556,7 +558,8 @@ static void bpf_struct_ops_map_free(struct bpf_map *map)
 static int bpf_struct_ops_map_alloc_check(union bpf_attr *attr)
 {
 	if (attr->key_size != sizeof(unsigned int) || attr->max_entries != 1 ||
-	    attr->map_flags || !attr->btf_vmlinux_value_type_id)
+		attr->map_flags & ~STRUCT_OPS_CREATE_FLAG_MASK ||
+		!attr->btf_vmlinux_value_type_id)
 		return -EINVAL;
 	return 0;
 }
diff --git a/kernel/bpf/cpumap.c b/kernel/bpf/cpumap.c
index 650e5d21f90d..201226fc652b 100644
--- a/kernel/bpf/cpumap.c
+++ b/kernel/bpf/cpumap.c
@@ -39,6 +39,9 @@
  */
 
 #define CPU_MAP_BULK_SIZE 8  /* 8 == one cacheline on 64-bit archs */
+
+#define CPU_MAP_CREATE_FLAG_MASK (BPF_F_NUMA_NODE | BPF_F_NO_CHARGE)
+
 struct bpf_cpu_map_entry;
 struct bpf_cpu_map;
 
@@ -93,7 +96,7 @@ static struct bpf_map *cpu_map_alloc(union bpf_attr *attr)
 	if (attr->max_entries == 0 || attr->key_size != 4 ||
 	    (value_size != offsetofend(struct bpf_cpumap_val, qsize) &&
 	     value_size != offsetofend(struct bpf_cpumap_val, bpf_prog.fd)) ||
-	    attr->map_flags & ~BPF_F_NUMA_NODE)
+	    attr->map_flags & ~CPU_MAP_CREATE_FLAG_MASK)
 		return ERR_PTR(-EINVAL);
 
 	cmap = kzalloc(sizeof(*cmap), GFP_USER | __GFP_ACCOUNT);
diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
index 038f6d7a83e4..39bf8b521f27 100644
--- a/kernel/bpf/devmap.c
+++ b/kernel/bpf/devmap.c
@@ -50,7 +50,7 @@
 #include <trace/events/xdp.h>
 
 #define DEV_CREATE_FLAG_MASK \
-	(BPF_F_NUMA_NODE | BPF_F_RDONLY | BPF_F_WRONLY)
+	(BPF_F_NUMA_NODE | BPF_F_RDONLY | BPF_F_WRONLY | BPF_F_NO_CHARGE)
 
 struct xdp_dev_bulk_queue {
 	struct xdp_frame *q[DEV_MAP_BULK_SIZE];
diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
index 65877967f414..5c6ec8780b09 100644
--- a/kernel/bpf/hashtab.c
+++ b/kernel/bpf/hashtab.c
@@ -16,7 +16,7 @@
 
 #define HTAB_CREATE_FLAG_MASK						\
 	(BPF_F_NO_PREALLOC | BPF_F_NO_COMMON_LRU | BPF_F_NUMA_NODE |	\
-	 BPF_F_ACCESS_MASK | BPF_F_ZERO_SEED)
+	 BPF_F_ACCESS_MASK | BPF_F_ZERO_SEED | BPF_F_NO_CHARGE)
 
 #define BATCH_OPS(_name)			\
 	.map_lookup_batch =			\
diff --git a/kernel/bpf/local_storage.c b/kernel/bpf/local_storage.c
index 497916060ac7..865766c240d6 100644
--- a/kernel/bpf/local_storage.c
+++ b/kernel/bpf/local_storage.c
@@ -15,7 +15,7 @@
 #include "../cgroup/cgroup-internal.h"
 
 #define LOCAL_STORAGE_CREATE_FLAG_MASK					\
-	(BPF_F_NUMA_NODE | BPF_F_ACCESS_MASK)
+	(BPF_F_NUMA_NODE | BPF_F_ACCESS_MASK | BPF_F_NO_CHARGE)
 
 struct bpf_cgroup_storage_map {
 	struct bpf_map map;
diff --git a/kernel/bpf/lpm_trie.c b/kernel/bpf/lpm_trie.c
index 5763cc7ac4f1..f42edf613624 100644
--- a/kernel/bpf/lpm_trie.c
+++ b/kernel/bpf/lpm_trie.c
@@ -537,7 +537,7 @@ static int trie_delete_elem(struct bpf_map *map, void *_key)
 #define LPM_KEY_SIZE_MIN	LPM_KEY_SIZE(LPM_DATA_SIZE_MIN)
 
 #define LPM_CREATE_FLAG_MASK	(BPF_F_NO_PREALLOC | BPF_F_NUMA_NODE |	\
-				 BPF_F_ACCESS_MASK)
+				 BPF_F_ACCESS_MASK | BPF_F_NO_CHARGE)
 
 static struct bpf_map *trie_alloc(union bpf_attr *attr)
 {
diff --git a/kernel/bpf/queue_stack_maps.c b/kernel/bpf/queue_stack_maps.c
index f9c734aaa990..c78eed4659ce 100644
--- a/kernel/bpf/queue_stack_maps.c
+++ b/kernel/bpf/queue_stack_maps.c
@@ -11,7 +11,7 @@
 #include "percpu_freelist.h"
 
 #define QUEUE_STACK_CREATE_FLAG_MASK \
-	(BPF_F_NUMA_NODE | BPF_F_ACCESS_MASK)
+	(BPF_F_NUMA_NODE | BPF_F_ACCESS_MASK | BPF_F_NO_CHARGE)
 
 struct bpf_queue_stack {
 	struct bpf_map map;
diff --git a/kernel/bpf/ringbuf.c b/kernel/bpf/ringbuf.c
index 710ba9de12ce..88779f688679 100644
--- a/kernel/bpf/ringbuf.c
+++ b/kernel/bpf/ringbuf.c
@@ -11,7 +11,7 @@
 #include <linux/kmemleak.h>
 #include <uapi/linux/btf.h>
 
-#define RINGBUF_CREATE_FLAG_MASK (BPF_F_NUMA_NODE)
+#define RINGBUF_CREATE_FLAG_MASK (BPF_F_NUMA_NODE | BPF_F_NO_CHARGE)
 
 /* non-mmap()'able part of bpf_ringbuf (everything up to consumer page) */
 #define RINGBUF_PGOFF \
diff --git a/kernel/bpf/stackmap.c b/kernel/bpf/stackmap.c
index 38bdfcd06f55..b2e7dc1d9f5a 100644
--- a/kernel/bpf/stackmap.c
+++ b/kernel/bpf/stackmap.c
@@ -14,7 +14,7 @@
 
 #define STACK_CREATE_FLAG_MASK					\
 	(BPF_F_NUMA_NODE | BPF_F_RDONLY | BPF_F_WRONLY |	\
-	 BPF_F_STACK_BUILD_ID)
+	 BPF_F_STACK_BUILD_ID | BPF_F_NO_CHARGE)
 
 struct stack_map_bucket {
 	struct pcpu_freelist_node fnode;
diff --git a/net/core/sock_map.c b/net/core/sock_map.c
index 2d213c4011db..7b0215bea413 100644
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -22,7 +22,7 @@ struct bpf_stab {
 };
 
 #define SOCK_CREATE_FLAG_MASK				\
-	(BPF_F_NUMA_NODE | BPF_F_RDONLY | BPF_F_WRONLY)
+	(BPF_F_NUMA_NODE | BPF_F_RDONLY | BPF_F_WRONLY | BPF_F_NO_CHARGE)
 
 static int sock_map_prog_update(struct bpf_map *map, struct bpf_prog *prog,
 				struct bpf_prog *old, u32 which);
diff --git a/net/xdp/xskmap.c b/net/xdp/xskmap.c
index 65b53fb3de13..10a5ae727bd5 100644
--- a/net/xdp/xskmap.c
+++ b/net/xdp/xskmap.c
@@ -12,6 +12,9 @@
 
 #include "xsk.h"
 
+#define XSK_MAP_CREATE_FLAG_MASK	\
+		(BPF_F_NUMA_NODE | BPF_F_RDONLY | BPF_F_WRONLY | BPF_F_NO_CHARGE)
+
 static struct xsk_map_node *xsk_map_node_alloc(struct xsk_map *map,
 					       struct xdp_sock __rcu **map_entry)
 {
@@ -68,7 +71,7 @@ static struct bpf_map *xsk_map_alloc(union bpf_attr *attr)
 
 	if (attr->max_entries == 0 || attr->key_size != 4 ||
 	    attr->value_size != 4 ||
-	    attr->map_flags & ~(BPF_F_NUMA_NODE | BPF_F_RDONLY | BPF_F_WRONLY))
+	    attr->map_flags & ~XSK_MAP_CREATE_FLAG_MASK)
 		return ERR_PTR(-EINVAL);
 
 	numa_node = bpf_map_attr_numa_node(attr);
-- 
2.17.1

