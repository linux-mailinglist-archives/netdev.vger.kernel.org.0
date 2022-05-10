Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D2CA5209F2
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 02:20:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233482AbiEJAWi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 20:22:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233600AbiEJAWa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 20:22:30 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 437D628C9FF
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 17:18:30 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id ij27-20020a170902ab5b00b0015d41282214so9025874plb.9
        for <netdev@vger.kernel.org>; Mon, 09 May 2022 17:18:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=PLe94BZhE80q/pDQVvt5DmK8lXFEEEfCjMN3zuEnNPw=;
        b=b2rDa5+JQZQE63OVUadnzrDA9sRT5AyfXJyIIB31LrDJUWYPfnBVOfa5ojXs9imp6d
         DwF4Awnj/fUwKBhjAsgQY8m/yjkmSpC8h+esfZ2DRrbYeFr9Z/TmnLxUNToiDS3GuWhL
         I1CZcBuzvF+TZLDnC8IEwjt7q1mTj3TCig5j9p1Ib8ZD2Ruj1aVOM/uCMLOLMW0lhB+V
         JFmWTSNEtcFtJ3hkLXygufK/9TBzOJNp+Fh6TscWo5hSpcL6vJVLjYxwh5He67lJ6S5P
         g9h25soVq8JfMXLQ4xTp/9u3XVMKLP8/QyHCB1uSKJk2RK02ZF3mB9ksJ9Py4vK/Ika7
         3aDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=PLe94BZhE80q/pDQVvt5DmK8lXFEEEfCjMN3zuEnNPw=;
        b=SWMaSeFfTB0sHNZ7PDTU3ZgAA5CuXRl2JYWw3c+LZ3HORajsHWxqlHZNqL9B0HdToj
         BgqZKQhr5YSOclVwL0p335ljmPvb5gIUy0tv5RO2dYe8q5iJD8Upfca1ds0akF/E30DY
         NySY8XB6xncFQqmMGhSNP70heZ1tLK3QKbGtnQGmFnpgC4sIntDVS9tE+MyrC8li8d0N
         mH+zCVeOqds9v9za4/JqF9hAjwVB0TT7ndGrWANnZsfBEPSEYMtJ9CddgNYsBvjkOpwB
         wSzzVEJdUUAb2NlPnLH4seVHMD/XACCBAle7DBuhutd/u8r82FWhEbsD6aF/zmiXQ/XX
         URAQ==
X-Gm-Message-State: AOAM533pIf6kA1u3Nyc3Y9XfWx5i4HoJ6+KxZEePqGI/XQtPK0Ts7l+X
        5aPzgbkHGvPFaMyDaOt7T5aiAoKO/AEy/rDA
X-Google-Smtp-Source: ABdhPJz/zhDfC/scR3LASeLDbHzHW221VoVK/8Sqq0+Z+mT9XUaQdCel9UEi8YE3fJyduB/0tUYYEcm0Ld+tn4Li
X-Received: from yosry.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2327])
 (user=yosryahmed job=sendgmr) by 2002:a17:90a:e510:b0:1d9:ee23:9fa1 with SMTP
 id t16-20020a17090ae51000b001d9ee239fa1mr16845pjy.0.1652141908990; Mon, 09
 May 2022 17:18:28 -0700 (PDT)
Date:   Tue, 10 May 2022 00:18:03 +0000
In-Reply-To: <20220510001807.4132027-1-yosryahmed@google.com>
Message-Id: <20220510001807.4132027-6-yosryahmed@google.com>
Mime-Version: 1.0
References: <20220510001807.4132027-1-yosryahmed@google.com>
X-Mailer: git-send-email 2.36.0.512.ge40c2bad7a-goog
Subject: [RFC PATCH bpf-next 5/9] bpf: add bpf_map_lookup_percpu_elem() helper
From:   Yosry Ahmed <yosryahmed@google.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Hao Luo <haoluo@google.com>,
        Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Shuah Khan <shuah@kernel.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Michal Hocko <mhocko@kernel.org>
Cc:     Stanislav Fomichev <sdf@google.com>,
        David Rientjes <rientjes@google.com>,
        Greg Thelen <gthelen@google.com>,
        Shakeel Butt <shakeelb@google.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, cgroups@vger.kernel.org,
        Yosry Ahmed <yosryahmed@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a helper for bpf programs to lookup a percpu element for a cpu other
than the current one. This is useful for rstat flusher programs as they
get called to aggregate stats from different cpus, regardless of the
current cpu.

Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
---
 include/linux/bpf.h            |  2 ++
 include/uapi/linux/bpf.h       |  9 +++++++++
 kernel/bpf/arraymap.c          | 11 ++++++++---
 kernel/bpf/hashtab.c           | 25 +++++++++++--------------
 kernel/bpf/helpers.c           | 26 ++++++++++++++++++++++++++
 kernel/bpf/verifier.c          |  6 ++++++
 tools/include/uapi/linux/bpf.h |  9 +++++++++
 7 files changed, 71 insertions(+), 17 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index bdb5298735ce..f6fa35ffe311 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1665,6 +1665,8 @@ int map_set_for_each_callback_args(struct bpf_verifier_env *env,
 				   struct bpf_func_state *caller,
 				   struct bpf_func_state *callee);
 
+void *bpf_percpu_hash_lookup(struct bpf_map *map, void *key, int cpu);
+void *bpf_percpu_array_lookup(struct bpf_map *map, void *key, int cpu);
 int bpf_percpu_hash_copy(struct bpf_map *map, void *key, void *value);
 int bpf_percpu_array_copy(struct bpf_map *map, void *key, void *value);
 int bpf_percpu_hash_update(struct bpf_map *map, void *key, void *value,
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index fce5535579d6..015ed402c642 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -1553,6 +1553,14 @@ union bpf_attr {
  * 		Map value associated to *key*, or **NULL** if no entry was
  * 		found.
  *
+ * void *bpf_map_lookup_percpu_elem(struct bpf_map *map, const void *key, int cpu)
+ *	Description
+ *		Perform a lookup in percpu *map* for an entry associated to
+ *		*key* for the given *cpu*.
+ *	Return
+ *		Map value associated to *key* per *cpu*, or **NULL** if no entry
+ *		was found.
+ *
  * long bpf_map_update_elem(struct bpf_map *map, const void *key, const void *value, u64 flags)
  * 	Description
  * 		Add or update the value of the entry associated to *key* in
@@ -5169,6 +5177,7 @@ union bpf_attr {
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
 	FN(map_lookup_elem),		\
+	FN(map_lookup_percpu_elem),	\
 	FN(map_update_elem),		\
 	FN(map_delete_elem),		\
 	FN(probe_read),			\
diff --git a/kernel/bpf/arraymap.c b/kernel/bpf/arraymap.c
index 7f145aefbff8..945dae4c20eb 100644
--- a/kernel/bpf/arraymap.c
+++ b/kernel/bpf/arraymap.c
@@ -230,8 +230,7 @@ static int array_map_gen_lookup(struct bpf_map *map, struct bpf_insn *insn_buf)
 	return insn - insn_buf;
 }
 
-/* Called from eBPF program */
-static void *percpu_array_map_lookup_elem(struct bpf_map *map, void *key)
+void *bpf_percpu_array_lookup(struct bpf_map *map, void *key, int cpu)
 {
 	struct bpf_array *array = container_of(map, struct bpf_array, map);
 	u32 index = *(u32 *)key;
@@ -239,7 +238,13 @@ static void *percpu_array_map_lookup_elem(struct bpf_map *map, void *key)
 	if (unlikely(index >= array->map.max_entries))
 		return NULL;
 
-	return this_cpu_ptr(array->pptrs[index & array->index_mask]);
+	return per_cpu_ptr(array->pptrs[index & array->index_mask], cpu);
+}
+
+/* Called from eBPF program */
+static void *percpu_array_map_lookup_elem(struct bpf_map *map, void *key)
+{
+	return bpf_percpu_array_lookup(map, key, smp_processor_id());
 }
 
 int bpf_percpu_array_copy(struct bpf_map *map, void *key, void *value)
diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
index 65877967f414..c6d4699d65e8 100644
--- a/kernel/bpf/hashtab.c
+++ b/kernel/bpf/hashtab.c
@@ -2150,27 +2150,24 @@ const struct bpf_map_ops htab_lru_map_ops = {
 	.iter_seq_info = &iter_seq_info,
 };
 
-/* Called from eBPF program */
-static void *htab_percpu_map_lookup_elem(struct bpf_map *map, void *key)
+void *bpf_percpu_hash_lookup(struct bpf_map *map, void *key, int cpu)
 {
+	struct bpf_htab *htab = container_of(map, struct bpf_htab, map);
 	struct htab_elem *l = __htab_map_lookup_elem(map, key);
 
-	if (l)
-		return this_cpu_ptr(htab_elem_get_ptr(l, map->key_size));
+	if (l) {
+		if (htab_is_lru(htab))
+			bpf_lru_node_set_ref(&l->lru_node);
+		return per_cpu_ptr(htab_elem_get_ptr(l, map->key_size), cpu);
+	}
 	else
 		return NULL;
 }
 
-static void *htab_lru_percpu_map_lookup_elem(struct bpf_map *map, void *key)
+/* Called from eBPF program */
+static void *htab_percpu_map_lookup_elem(struct bpf_map *map, void *key)
 {
-	struct htab_elem *l = __htab_map_lookup_elem(map, key);
-
-	if (l) {
-		bpf_lru_node_set_ref(&l->lru_node);
-		return this_cpu_ptr(htab_elem_get_ptr(l, map->key_size));
-	}
-
-	return NULL;
+	return bpf_percpu_hash_lookup(map, key, smp_processor_id());
 }
 
 int bpf_percpu_hash_copy(struct bpf_map *map, void *key, void *value)
@@ -2279,7 +2276,7 @@ const struct bpf_map_ops htab_lru_percpu_map_ops = {
 	.map_alloc = htab_map_alloc,
 	.map_free = htab_map_free,
 	.map_get_next_key = htab_map_get_next_key,
-	.map_lookup_elem = htab_lru_percpu_map_lookup_elem,
+	.map_lookup_elem = htab_percpu_map_lookup_elem,
 	.map_lookup_and_delete_elem = htab_lru_percpu_map_lookup_and_delete_elem,
 	.map_update_elem = htab_lru_percpu_map_update_elem,
 	.map_delete_elem = htab_lru_map_delete_elem,
diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index d124eed97ad7..abed4e1737f6 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -45,6 +45,30 @@ const struct bpf_func_proto bpf_map_lookup_elem_proto = {
 	.arg2_type	= ARG_PTR_TO_MAP_KEY,
 };
 
+BPF_CALL_3(bpf_map_lookup_percpu_elem, struct bpf_map *, map, void *, key,
+	   int, cpu)
+{
+	WARN_ON_ONCE(!rcu_read_lock_held() && !rcu_read_lock_bh_held());
+	switch (map->map_type) {
+	case BPF_MAP_TYPE_PERCPU_ARRAY:
+		return (unsigned long) bpf_percpu_array_lookup(map, key, cpu);
+	case BPF_MAP_TYPE_PERCPU_HASH:
+	case BPF_MAP_TYPE_LRU_PERCPU_HASH:
+		return (unsigned long) bpf_percpu_hash_lookup(map, key, cpu);
+	default:
+		return (unsigned long) NULL;
+	}
+}
+
+const struct bpf_func_proto bpf_map_lookup_percpu_elem_proto = {
+	.func		= bpf_map_lookup_percpu_elem,
+	.gpl_only	= false,
+	.ret_type	= RET_PTR_TO_MAP_VALUE_OR_NULL,
+	.arg1_type	= ARG_CONST_MAP_PTR,
+	.arg2_type	= ARG_PTR_TO_MAP_KEY,
+	.arg3_type	= ARG_ANYTHING,
+};
+
 BPF_CALL_4(bpf_map_update_elem, struct bpf_map *, map, void *, key,
 	   void *, value, u64, flags)
 {
@@ -1414,6 +1438,8 @@ bpf_base_func_proto(enum bpf_func_id func_id)
 	switch (func_id) {
 	case BPF_FUNC_map_lookup_elem:
 		return &bpf_map_lookup_elem_proto;
+	case BPF_FUNC_map_lookup_percpu_elem:
+		return &bpf_map_lookup_percpu_elem_proto;
 	case BPF_FUNC_map_update_elem:
 		return &bpf_map_update_elem_proto;
 	case BPF_FUNC_map_delete_elem:
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index d175b70067b3..2d7f7c9a970d 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -5879,6 +5879,12 @@ static int check_map_func_compatibility(struct bpf_verifier_env *env,
 		if (map->map_type != BPF_MAP_TYPE_TASK_STORAGE)
 			goto error;
 		break;
+	case BPF_FUNC_map_lookup_percpu_elem:
+		if (map->map_type != BPF_MAP_TYPE_PERCPU_HASH &&
+		    map->map_type != BPF_MAP_TYPE_LRU_PERCPU_HASH &&
+		    map->map_type != BPF_MAP_TYPE_PERCPU_ARRAY)
+			goto error;
+		break;
 	default:
 		break;
 	}
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index fce5535579d6..015ed402c642 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -1553,6 +1553,14 @@ union bpf_attr {
  * 		Map value associated to *key*, or **NULL** if no entry was
  * 		found.
  *
+ * void *bpf_map_lookup_percpu_elem(struct bpf_map *map, const void *key, int cpu)
+ *	Description
+ *		Perform a lookup in percpu *map* for an entry associated to
+ *		*key* for the given *cpu*.
+ *	Return
+ *		Map value associated to *key* per *cpu*, or **NULL** if no entry
+ *		was found.
+ *
  * long bpf_map_update_elem(struct bpf_map *map, const void *key, const void *value, u64 flags)
  * 	Description
  * 		Add or update the value of the entry associated to *key* in
@@ -5169,6 +5177,7 @@ union bpf_attr {
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
 	FN(map_lookup_elem),		\
+	FN(map_lookup_percpu_elem),	\
 	FN(map_update_elem),		\
 	FN(map_delete_elem),		\
 	FN(probe_read),			\
-- 
2.36.0.512.ge40c2bad7a-goog

