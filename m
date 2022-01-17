Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79F1F490F96
	for <lists+netdev@lfdr.de>; Mon, 17 Jan 2022 18:31:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239295AbiAQRao (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 12:30:44 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:45938 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239321AbiAQRaf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 12:30:35 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AD33560B52;
        Mon, 17 Jan 2022 17:30:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35B60C36AF2;
        Mon, 17 Jan 2022 17:30:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642440634;
        bh=kzjtGk8moyVLKEZgG2O6yGRBwFiHkRvLQIrzHnRjC/w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s6ra3t1naloapDdHFRzQuhOeOaeeBJ3yTaU2Xzvhc0NV8ztSV4hHqnMIvvmi50nlm
         8LSf4TbIcWDhacL0qVKUjUNfmgh9tQ2B8aEbgvR03w4zXMNjMkIvgzX/VhZ1vj9SRr
         b/ptzhonl61UzDmFjrTqsw2YlLGZyHW0oNg5grPRTZs+JnEGJrGVMIJo6bjEJxjK3o
         73JiA7duzlAxPXO8Q0xyiONLUBY54L44n3HVHBvUQ5+dTAHvSoRs4WN/zxQpyHRE7n
         +FdO0wReTGk7xUzDNYGFwErZQ+/KbXInYd/bNxNHJiLS/sJn9ceLNHkVcahmgZKUgN
         QunHW932TzrNw==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        john.fastabend@gmail.com, dsahern@kernel.org, brouer@redhat.com,
        echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com
Subject: [PATCH v22 bpf-next 19/23] bpf: generalise tail call map compatibility check
Date:   Mon, 17 Jan 2022 18:28:31 +0100
Message-Id: <2e702db189683545e088b74f7d95eb396a329f64.1642439548.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1642439548.git.lorenzo@kernel.org>
References: <cover.1642439548.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Toke Hoiland-Jorgensen <toke@redhat.com>

The check for tail call map compatibility ensures that tail calls only
happen between maps of the same type. To ensure backwards compatibility for
XDP multi-frags we need a similar type of check for cpumap and devmap
programs, so move the state from bpf_array_aux into bpf_map, add
xdp_has_frags to the check, and apply the same check to cpumap and devmap.

Acked-by: John Fastabend <john.fastabend@gmail.com>
Co-developed-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Toke Hoiland-Jorgensen <toke@redhat.com>
---
 include/linux/bpf.h   | 30 +++++++++++++++++++-----------
 kernel/bpf/arraymap.c |  4 +---
 kernel/bpf/core.c     | 28 ++++++++++++++--------------
 kernel/bpf/cpumap.c   |  8 +++++---
 kernel/bpf/devmap.c   |  3 ++-
 kernel/bpf/syscall.c  | 21 +++++++++++----------
 6 files changed, 52 insertions(+), 42 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 909fa29981fd..251c5e27805e 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -194,6 +194,17 @@ struct bpf_map {
 	struct work_struct work;
 	struct mutex freeze_mutex;
 	atomic64_t writecnt;
+	/* 'Ownership' of program-containing map is claimed by the first program
+	 * that is going to use this map or by the first program which FD is
+	 * stored in the map to make sure that all callers and callees have the
+	 * same prog type, JITed flag and xdp_has_frags flag.
+	 */
+	struct {
+		spinlock_t lock;
+		enum bpf_prog_type type;
+		bool jited;
+		bool xdp_has_frags;
+	} owner;
 };
 
 static inline bool map_value_has_spin_lock(const struct bpf_map *map)
@@ -995,16 +1006,6 @@ struct bpf_prog_aux {
 };
 
 struct bpf_array_aux {
-	/* 'Ownership' of prog array is claimed by the first program that
-	 * is going to use this map or by the first program which FD is
-	 * stored in the map to make sure that all callers and callees have
-	 * the same prog type and JITed flag.
-	 */
-	struct {
-		spinlock_t lock;
-		enum bpf_prog_type type;
-		bool jited;
-	} owner;
 	/* Programs with direct jumps into programs part of this array. */
 	struct list_head poke_progs;
 	struct bpf_map *map;
@@ -1179,7 +1180,14 @@ struct bpf_event_entry {
 	struct rcu_head rcu;
 };
 
-bool bpf_prog_array_compatible(struct bpf_array *array, const struct bpf_prog *fp);
+static inline bool map_type_contains_progs(struct bpf_map *map)
+{
+	return map->map_type == BPF_MAP_TYPE_PROG_ARRAY ||
+	       map->map_type == BPF_MAP_TYPE_DEVMAP ||
+	       map->map_type == BPF_MAP_TYPE_CPUMAP;
+}
+
+bool bpf_prog_map_compatible(struct bpf_map *map, const struct bpf_prog *fp);
 int bpf_prog_calc_tag(struct bpf_prog *fp);
 
 const struct bpf_func_proto *bpf_get_trace_printk_proto(void);
diff --git a/kernel/bpf/arraymap.c b/kernel/bpf/arraymap.c
index c7a5be3bf8be..7f145aefbff8 100644
--- a/kernel/bpf/arraymap.c
+++ b/kernel/bpf/arraymap.c
@@ -837,13 +837,12 @@ static int fd_array_map_delete_elem(struct bpf_map *map, void *key)
 static void *prog_fd_array_get_ptr(struct bpf_map *map,
 				   struct file *map_file, int fd)
 {
-	struct bpf_array *array = container_of(map, struct bpf_array, map);
 	struct bpf_prog *prog = bpf_prog_get(fd);
 
 	if (IS_ERR(prog))
 		return prog;
 
-	if (!bpf_prog_array_compatible(array, prog)) {
+	if (!bpf_prog_map_compatible(map, prog)) {
 		bpf_prog_put(prog);
 		return ERR_PTR(-EINVAL);
 	}
@@ -1071,7 +1070,6 @@ static struct bpf_map *prog_array_map_alloc(union bpf_attr *attr)
 	INIT_WORK(&aux->work, prog_array_map_clear_deferred);
 	INIT_LIST_HEAD(&aux->poke_progs);
 	mutex_init(&aux->poke_mutex);
-	spin_lock_init(&aux->owner.lock);
 
 	map = array_map_alloc(attr);
 	if (IS_ERR(map)) {
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index de3e5bc6781f..0a1cfd8544b9 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -1829,28 +1829,30 @@ static unsigned int __bpf_prog_ret0_warn(const void *ctx,
 }
 #endif
 
-bool bpf_prog_array_compatible(struct bpf_array *array,
-			       const struct bpf_prog *fp)
+bool bpf_prog_map_compatible(struct bpf_map *map,
+			     const struct bpf_prog *fp)
 {
 	bool ret;
 
 	if (fp->kprobe_override)
 		return false;
 
-	spin_lock(&array->aux->owner.lock);
-
-	if (!array->aux->owner.type) {
+	spin_lock(&map->owner.lock);
+	if (!map->owner.type) {
 		/* There's no owner yet where we could check for
 		 * compatibility.
 		 */
-		array->aux->owner.type  = fp->type;
-		array->aux->owner.jited = fp->jited;
+		map->owner.type  = fp->type;
+		map->owner.jited = fp->jited;
+		map->owner.xdp_has_frags = fp->aux->xdp_has_frags;
 		ret = true;
 	} else {
-		ret = array->aux->owner.type  == fp->type &&
-		      array->aux->owner.jited == fp->jited;
+		ret = map->owner.type  == fp->type &&
+		      map->owner.jited == fp->jited &&
+		      map->owner.xdp_has_frags == fp->aux->xdp_has_frags;
 	}
-	spin_unlock(&array->aux->owner.lock);
+	spin_unlock(&map->owner.lock);
+
 	return ret;
 }
 
@@ -1862,13 +1864,11 @@ static int bpf_check_tail_call(const struct bpf_prog *fp)
 	mutex_lock(&aux->used_maps_mutex);
 	for (i = 0; i < aux->used_map_cnt; i++) {
 		struct bpf_map *map = aux->used_maps[i];
-		struct bpf_array *array;
 
-		if (map->map_type != BPF_MAP_TYPE_PROG_ARRAY)
+		if (!map_type_contains_progs(map))
 			continue;
 
-		array = container_of(map, struct bpf_array, map);
-		if (!bpf_prog_array_compatible(array, fp)) {
+		if (!bpf_prog_map_compatible(map, fp)) {
 			ret = -EINVAL;
 			goto out;
 		}
diff --git a/kernel/bpf/cpumap.c b/kernel/bpf/cpumap.c
index b3e6b9422238..650e5d21f90d 100644
--- a/kernel/bpf/cpumap.c
+++ b/kernel/bpf/cpumap.c
@@ -397,7 +397,8 @@ static int cpu_map_kthread_run(void *data)
 	return 0;
 }
 
-static int __cpu_map_load_bpf_program(struct bpf_cpu_map_entry *rcpu, int fd)
+static int __cpu_map_load_bpf_program(struct bpf_cpu_map_entry *rcpu,
+				      struct bpf_map *map, int fd)
 {
 	struct bpf_prog *prog;
 
@@ -405,7 +406,8 @@ static int __cpu_map_load_bpf_program(struct bpf_cpu_map_entry *rcpu, int fd)
 	if (IS_ERR(prog))
 		return PTR_ERR(prog);
 
-	if (prog->expected_attach_type != BPF_XDP_CPUMAP) {
+	if (prog->expected_attach_type != BPF_XDP_CPUMAP ||
+	    !bpf_prog_map_compatible(map, prog)) {
 		bpf_prog_put(prog);
 		return -EINVAL;
 	}
@@ -457,7 +459,7 @@ __cpu_map_entry_alloc(struct bpf_map *map, struct bpf_cpumap_val *value,
 	rcpu->map_id = map->id;
 	rcpu->value.qsize  = value->qsize;
 
-	if (fd > 0 && __cpu_map_load_bpf_program(rcpu, fd))
+	if (fd > 0 && __cpu_map_load_bpf_program(rcpu, map, fd))
 		goto free_ptr_ring;
 
 	/* Setup kthread */
diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
index fe019dbdb3f0..038f6d7a83e4 100644
--- a/kernel/bpf/devmap.c
+++ b/kernel/bpf/devmap.c
@@ -858,7 +858,8 @@ static struct bpf_dtab_netdev *__dev_map_alloc_node(struct net *net,
 					     BPF_PROG_TYPE_XDP, false);
 		if (IS_ERR(prog))
 			goto err_put_dev;
-		if (prog->expected_attach_type != BPF_XDP_DEVMAP)
+		if (prog->expected_attach_type != BPF_XDP_DEVMAP ||
+		    !bpf_prog_map_compatible(&dtab->map, prog))
 			goto err_put_prog;
 	}
 
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index e3c9deb7e25f..2c50d26814d9 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -556,16 +556,15 @@ static unsigned long bpf_map_memory_footprint(const struct bpf_map *map)
 
 static void bpf_map_show_fdinfo(struct seq_file *m, struct file *filp)
 {
-	const struct bpf_map *map = filp->private_data;
-	const struct bpf_array *array;
-	u32 type = 0, jited = 0;
-
-	if (map->map_type == BPF_MAP_TYPE_PROG_ARRAY) {
-		array = container_of(map, struct bpf_array, map);
-		spin_lock(&array->aux->owner.lock);
-		type  = array->aux->owner.type;
-		jited = array->aux->owner.jited;
-		spin_unlock(&array->aux->owner.lock);
+	struct bpf_map *map = filp->private_data;
+	u32 type = 0, jited = 0, xdp_has_frags = 0;
+
+	if (map_type_contains_progs(map)) {
+		spin_lock(&map->owner.lock);
+		type  = map->owner.type;
+		jited = map->owner.jited;
+		xdp_has_frags = map->owner.xdp_has_frags;
+		spin_unlock(&map->owner.lock);
 	}
 
 	seq_printf(m,
@@ -590,6 +589,7 @@ static void bpf_map_show_fdinfo(struct seq_file *m, struct file *filp)
 	if (type) {
 		seq_printf(m, "owner_prog_type:\t%u\n", type);
 		seq_printf(m, "owner_jited:\t%u\n", jited);
+		seq_printf(m, "owner_xdp_has_frags:\t%u\n", xdp_has_frags);
 	}
 }
 #endif
@@ -874,6 +874,7 @@ static int map_create(union bpf_attr *attr)
 	atomic64_set(&map->refcnt, 1);
 	atomic64_set(&map->usercnt, 1);
 	mutex_init(&map->freeze_mutex);
+	spin_lock_init(&map->owner.lock);
 
 	map->spin_lock_off = -EINVAL;
 	map->timer_off = -EINVAL;
-- 
2.34.1

