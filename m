Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50E594458BB
	for <lists+netdev@lfdr.de>; Thu,  4 Nov 2021 18:37:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233972AbhKDRkJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Nov 2021 13:40:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:49274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233937AbhKDRkI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Nov 2021 13:40:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 31F6960724;
        Thu,  4 Nov 2021 17:37:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636047450;
        bh=FwS3hgjgEXuZG9x2cvYYCdv9bbd8SXVyMny4P3YWmqo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I2XMXZbEx4TqXhhJc4ix9yjgTSLMpUDR360DrRnvMhQj7ZA3VJnXhCfX3CtW7Gfkf
         ZAyl0am9t8Xsjv8YgYA4tv1wZgJWvpqmtrxT1uZfTLNChHXWMPu8DJYyYL/Cm/FSOg
         yPcP8OstXKffnlDIEvdTKrBGeiszQMUAWB5t8Fal20C8ylLakGjDSB6Oqz0bs+RnwZ
         1aPVkXm+vfj+6C9L60B2Gagu5Qv35C8GX/vX6VFa5cobd1pjHWlngG9a+Bg7EOcqx5
         /DizRloFfJoGpBa1nuMF1h2iR+A2nGopL722jOabn2qOxmC4i7zt7qUYCgwPpzmRlZ
         kmEkuUnhI+OTA==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        john.fastabend@gmail.com, dsahern@kernel.org, brouer@redhat.com,
        echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com
Subject: [PATCH v17 bpf-next 19/23] bpf: generalise tail call map
Date:   Thu,  4 Nov 2021 18:35:39 +0100
Message-Id: <bb1d0de1e0d25563a3bb1770069d46badaf720a9.1636044387.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1636044387.git.lorenzo@kernel.org>
References: <cover.1636044387.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Toke Hoiland-Jorgensen <toke@redhat.com>

The check for tail call map compatibility ensures that tail calls only
happen between maps of the same type. To ensure backwards compatibility for
XDP multi-buffer we need a similar type of check for cpumap and devmap
programs, so move the state from bpf_array_aux into bpf_map, add xdp_mb to
the check, and apply the same check to cpumap and devmap.

Co-developed-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Toke Hoiland-Jorgensen <toke@redhat.com>
---
 include/linux/bpf.h   | 31 ++++++++++++++++++++-----------
 kernel/bpf/arraymap.c |  4 +---
 kernel/bpf/core.c     | 28 ++++++++++++++--------------
 kernel/bpf/cpumap.c   |  8 +++++---
 kernel/bpf/devmap.c   |  3 ++-
 kernel/bpf/syscall.c  | 21 +++++++++++----------
 6 files changed, 53 insertions(+), 42 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index ba31c22ad839..09f0422d7fcd 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -194,6 +194,18 @@ struct bpf_map {
 	struct work_struct work;
 	struct mutex freeze_mutex;
 	u64 writecnt; /* writable mmap cnt; protected by freeze_mutex */
+
+	/* 'Ownership' of program-containing map is claimed by the first program
+	 * that is going to use this map or by the first program which FD is
+	 * stored in the map to make sure that all callers and callees have the
+	 * same prog type, JITed flag and xdp_mb flag.
+	 */
+	struct {
+		spinlock_t lock;
+		enum bpf_prog_type type;
+		bool jited;
+		bool xdp_mb;
+	} owner;
 };
 
 static inline bool map_value_has_spin_lock(const struct bpf_map *map)
@@ -930,16 +942,6 @@ struct bpf_prog_aux {
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
@@ -1114,7 +1116,14 @@ struct bpf_event_entry {
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
index 327e3996eadb..bd24cc30d3bd 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -1821,28 +1821,30 @@ static unsigned int __bpf_prog_ret0_warn(const void *ctx,
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
+		map->owner.xdp_mb = fp->aux->xdp_mb;
 		ret = true;
 	} else {
-		ret = array->aux->owner.type  == fp->type &&
-		      array->aux->owner.jited == fp->jited;
+		ret = map->owner.type  == fp->type &&
+		      map->owner.jited == fp->jited &&
+		      map->owner.xdp_mb == fp->aux->xdp_mb;
 	}
-	spin_unlock(&array->aux->owner.lock);
+	spin_unlock(&map->owner.lock);
+
 	return ret;
 }
 
@@ -1854,13 +1856,11 @@ static int bpf_check_tail_call(const struct bpf_prog *fp)
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
index 585b2b77ccc4..7f9984e7ba1d 100644
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
index f02d04540c0c..a35edd4a2bf1 100644
--- a/kernel/bpf/devmap.c
+++ b/kernel/bpf/devmap.c
@@ -868,7 +868,8 @@ static struct bpf_dtab_netdev *__dev_map_alloc_node(struct net *net,
 					     BPF_PROG_TYPE_XDP, false);
 		if (IS_ERR(prog))
 			goto err_put_dev;
-		if (prog->expected_attach_type != BPF_XDP_DEVMAP)
+		if (prog->expected_attach_type != BPF_XDP_DEVMAP ||
+		    !bpf_prog_map_compatible(&dtab->map, prog))
 			goto err_put_prog;
 	}
 
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index fbae37d5b329..ba78d3490491 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -540,16 +540,15 @@ static unsigned long bpf_map_memory_footprint(const struct bpf_map *map)
 
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
+	u32 type = 0, jited = 0, xdp_mb = 0;
+
+	if (map_type_contains_progs(map)) {
+		spin_lock(&map->owner.lock);
+		type  = map->owner.type;
+		jited = map->owner.jited;
+		xdp_mb = map->owner.xdp_mb;
+		spin_unlock(&map->owner.lock);
 	}
 
 	seq_printf(m,
@@ -574,6 +573,7 @@ static void bpf_map_show_fdinfo(struct seq_file *m, struct file *filp)
 	if (type) {
 		seq_printf(m, "owner_prog_type:\t%u\n", type);
 		seq_printf(m, "owner_jited:\t%u\n", jited);
+		seq_printf(m, "owner_xdp_mb:\t%u\n", xdp_mb);
 	}
 }
 #endif
@@ -864,6 +864,7 @@ static int map_create(union bpf_attr *attr)
 	atomic64_set(&map->refcnt, 1);
 	atomic64_set(&map->usercnt, 1);
 	mutex_init(&map->freeze_mutex);
+	spin_lock_init(&map->owner.lock);
 
 	map->spin_lock_off = -EINVAL;
 	map->timer_off = -EINVAL;
-- 
2.31.1

