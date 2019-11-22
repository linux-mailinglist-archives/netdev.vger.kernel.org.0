Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A30C107940
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 21:08:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727149AbfKVUIX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 15:08:23 -0500
Received: from www62.your-server.de ([213.133.104.62]:37350 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726705AbfKVUIQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Nov 2019 15:08:16 -0500
Received: from 30.248.197.178.dynamic.dsl-lte-bonding.zhbmb00p-msn.res.cust.swisscom.ch ([178.197.248.30] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iYFDx-0004Z2-35; Fri, 22 Nov 2019 21:08:13 +0100
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     ast@kernel.org
Cc:     john.fastabend@gmail.com, andrii.nakryiko@gmail.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH bpf-next v2 5/8] bpf: add poke dependency tracking for prog array maps
Date:   Fri, 22 Nov 2019 21:07:58 +0100
Message-Id: <1fb364bb3c565b3e415d5ea348f036ff379e779d.1574452833.git.daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <cover.1574452833.git.daniel@iogearbox.net>
References: <cover.1574452833.git.daniel@iogearbox.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25641/Fri Nov 22 11:06:48 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This work adds program tracking to prog array maps. This is needed such
that upon prog array updates/deletions we can fix up all programs which
make use of this tail call map. We add ops->map_poke_{un,}track()
helpers to maps to maintain the list of programs and ops->map_poke_run()
for triggering the actual update.

bpf_array_aux is extended to contain the list head and poke_mutex in
order to serialize program patching during updates/deletions.
bpf_free_used_maps() will untrack the program shortly before dropping
the reference to the map. For clearing out the prog array once all urefs
are dropped we need to use schedule_work() to have a sleepable context.

The prog_array_map_poke_run() is triggered during updates/deletions and
walks the maintained prog list. It checks in their poke_tabs whether the
map and key is matching and runs the actual bpf_arch_text_poke() for
patching in the nop or new jmp location. Depending on the type of update,
we use one of BPF_MOD_{NOP_TO_JUMP,JUMP_TO_NOP,JUMP_TO_JUMP}.

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
---
 include/linux/bpf.h   |  12 +++
 kernel/bpf/arraymap.c | 183 +++++++++++++++++++++++++++++++++++++++++-
 kernel/bpf/core.c     |   9 ++-
 kernel/bpf/syscall.c  |  20 +++--
 4 files changed, 212 insertions(+), 12 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 312983bf7faa..c2f07fd410c1 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -22,6 +22,7 @@ struct bpf_verifier_env;
 struct bpf_verifier_log;
 struct perf_event;
 struct bpf_prog;
+struct bpf_prog_aux;
 struct bpf_map;
 struct sock;
 struct seq_file;
@@ -64,6 +65,12 @@ struct bpf_map_ops {
 			     const struct btf_type *key_type,
 			     const struct btf_type *value_type);
 
+	/* Prog poke tracking helpers. */
+	int (*map_poke_track)(struct bpf_map *map, struct bpf_prog_aux *aux);
+	void (*map_poke_untrack)(struct bpf_map *map, struct bpf_prog_aux *aux);
+	void (*map_poke_run)(struct bpf_map *map, u32 key, struct bpf_prog *old,
+			     struct bpf_prog *new);
+
 	/* Direct value access helpers. */
 	int (*map_direct_value_addr)(const struct bpf_map *map,
 				     u64 *imm, u32 off);
@@ -588,6 +595,11 @@ struct bpf_array_aux {
 	 */
 	enum bpf_prog_type type;
 	bool jited;
+	/* Programs with direct jumps into programs part of this array. */
+	struct list_head poke_progs;
+	struct bpf_map *map;
+	struct mutex poke_mutex;
+	struct work_struct work;
 };
 
 struct bpf_array {
diff --git a/kernel/bpf/arraymap.c b/kernel/bpf/arraymap.c
index 57da950ee55b..58bdf5fd24cc 100644
--- a/kernel/bpf/arraymap.c
+++ b/kernel/bpf/arraymap.c
@@ -586,10 +586,17 @@ int bpf_fd_array_map_update_elem(struct bpf_map *map, struct file *map_file,
 	if (IS_ERR(new_ptr))
 		return PTR_ERR(new_ptr);
 
-	old_ptr = xchg(array->ptrs + index, new_ptr);
+	if (map->ops->map_poke_run) {
+		mutex_lock(&array->aux->poke_mutex);
+		old_ptr = xchg(array->ptrs + index, new_ptr);
+		map->ops->map_poke_run(map, index, old_ptr, new_ptr);
+		mutex_unlock(&array->aux->poke_mutex);
+	} else {
+		old_ptr = xchg(array->ptrs + index, new_ptr);
+	}
+
 	if (old_ptr)
 		map->ops->map_fd_put_ptr(old_ptr);
-
 	return 0;
 }
 
@@ -602,7 +609,15 @@ static int fd_array_map_delete_elem(struct bpf_map *map, void *key)
 	if (index >= array->map.max_entries)
 		return -E2BIG;
 
-	old_ptr = xchg(array->ptrs + index, NULL);
+	if (map->ops->map_poke_run) {
+		mutex_lock(&array->aux->poke_mutex);
+		old_ptr = xchg(array->ptrs + index, NULL);
+		map->ops->map_poke_run(map, index, old_ptr, NULL);
+		mutex_unlock(&array->aux->poke_mutex);
+	} else {
+		old_ptr = xchg(array->ptrs + index, NULL);
+	}
+
 	if (old_ptr) {
 		map->ops->map_fd_put_ptr(old_ptr);
 		return 0;
@@ -671,6 +686,152 @@ static void prog_array_map_seq_show_elem(struct bpf_map *map, void *key,
 	rcu_read_unlock();
 }
 
+struct prog_poke_elem {
+	struct list_head list;
+	struct bpf_prog_aux *aux;
+};
+
+static int prog_array_map_poke_track(struct bpf_map *map,
+				     struct bpf_prog_aux *prog_aux)
+{
+	struct prog_poke_elem *elem;
+	struct bpf_array_aux *aux;
+	int ret = 0;
+
+	aux = container_of(map, struct bpf_array, map)->aux;
+	mutex_lock(&aux->poke_mutex);
+	list_for_each_entry(elem, &aux->poke_progs, list) {
+		if (elem->aux == prog_aux)
+			goto out;
+	}
+
+	elem = kmalloc(sizeof(*elem), GFP_KERNEL);
+	if (!elem) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	INIT_LIST_HEAD(&elem->list);
+	/* We must track the program's aux info at this point in time
+	 * since the program pointer itself may not be stable yet, see
+	 * also comment in prog_array_map_poke_run().
+	 */
+	elem->aux = prog_aux;
+
+	list_add_tail(&elem->list, &aux->poke_progs);
+out:
+	mutex_unlock(&aux->poke_mutex);
+	return ret;
+}
+
+static void prog_array_map_poke_untrack(struct bpf_map *map,
+					struct bpf_prog_aux *prog_aux)
+{
+	struct prog_poke_elem *elem, *tmp;
+	struct bpf_array_aux *aux;
+
+	aux = container_of(map, struct bpf_array, map)->aux;
+	mutex_lock(&aux->poke_mutex);
+	list_for_each_entry_safe(elem, tmp, &aux->poke_progs, list) {
+		if (elem->aux == prog_aux) {
+			list_del_init(&elem->list);
+			kfree(elem);
+			break;
+		}
+	}
+	mutex_unlock(&aux->poke_mutex);
+}
+
+static void prog_array_map_poke_run(struct bpf_map *map, u32 key,
+				    struct bpf_prog *old,
+				    struct bpf_prog *new)
+{
+	enum bpf_text_poke_type type;
+	struct prog_poke_elem *elem;
+	struct bpf_array_aux *aux;
+
+	if (!old && new)
+		type = BPF_MOD_NOP_TO_JUMP;
+	else if (old && !new)
+		type = BPF_MOD_JUMP_TO_NOP;
+	else if (old && new)
+		type = BPF_MOD_JUMP_TO_JUMP;
+	else
+		return;
+
+	aux = container_of(map, struct bpf_array, map)->aux;
+	WARN_ON_ONCE(!mutex_is_locked(&aux->poke_mutex));
+
+	list_for_each_entry(elem, &aux->poke_progs, list) {
+		struct bpf_jit_poke_descriptor *poke;
+		int i, ret;
+
+		for (i = 0; i < elem->aux->size_poke_tab; i++) {
+			poke = &elem->aux->poke_tab[i];
+
+			/* Few things to be aware of:
+			 *
+			 * 1) We can only ever access aux in this context, but
+			 *    not aux->prog since it might not be stable yet and
+			 *    there could be danger of use after free otherwise.
+			 * 2) Initially when we start tracking aux, the program
+			 *    is not JITed yet and also does not have a kallsyms
+			 *    entry. We skip these as poke->ip_stable is not
+			 *    active yet. The JIT will do the final fixup before
+			 *    setting it stable. The various poke->ip_stable are
+			 *    successively activated, so tail call updates can
+			 *    arrive from here while JIT is still finishing its
+			 *    final fixup for non-activated poke entries.
+			 * 3) On program teardown, the program's kallsym entry gets
+			 *    removed out of RCU callback, but we can only untrack
+			 *    from sleepable context, therefore bpf_arch_text_poke()
+			 *    might not see that this is in BPF text section and
+			 *    bails out with -EINVAL. As these are unreachable since
+			 *    RCU grace period already passed, we simply skip them.
+			 * 4) Also programs reaching refcount of zero while patching
+			 *    is in progress is okay since we're protected under
+			 *    poke_mutex and untrack the programs before the JIT
+			 *    buffer is freed. When we're still in the middle of
+			 *    patching and suddenly kallsyms entry of the program
+			 *    gets evicted, we just skip the rest which is fine due
+			 *    to point 3).
+			 * 5) Any other error happening below from bpf_arch_text_poke()
+			 *    is a unexpected bug.
+			 */
+			if (!READ_ONCE(poke->ip_stable))
+				continue;
+			if (poke->reason != BPF_POKE_REASON_TAIL_CALL)
+				continue;
+			if (poke->tail_call.map != map ||
+			    poke->tail_call.key != key)
+				continue;
+
+			ret = bpf_arch_text_poke(poke->ip, type,
+						 old ? (u8 *)old->bpf_func +
+						 poke->adj_off : NULL,
+						 new ? (u8 *)new->bpf_func +
+						 poke->adj_off : NULL);
+			BUG_ON(ret < 0 && ret != -EINVAL);
+		}
+	}
+}
+
+static void prog_array_map_clear_deferred(struct work_struct *work)
+{
+	struct bpf_map *map = container_of(work, struct bpf_array_aux,
+					   work)->map;
+	bpf_fd_array_map_clear(map);
+	bpf_map_put(map);
+}
+
+static void prog_array_map_clear(struct bpf_map *map)
+{
+	struct bpf_array_aux *aux = container_of(map, struct bpf_array,
+						 map)->aux;
+	bpf_map_inc(map);
+	schedule_work(&aux->work);
+}
+
 static struct bpf_map *prog_array_map_alloc(union bpf_attr *attr)
 {
 	struct bpf_array_aux *aux;
@@ -680,6 +841,10 @@ static struct bpf_map *prog_array_map_alloc(union bpf_attr *attr)
 	if (!aux)
 		return ERR_PTR(-ENOMEM);
 
+	INIT_WORK(&aux->work, prog_array_map_clear_deferred);
+	INIT_LIST_HEAD(&aux->poke_progs);
+	mutex_init(&aux->poke_mutex);
+
 	map = array_map_alloc(attr);
 	if (IS_ERR(map)) {
 		kfree(aux);
@@ -687,14 +852,21 @@ static struct bpf_map *prog_array_map_alloc(union bpf_attr *attr)
 	}
 
 	container_of(map, struct bpf_array, map)->aux = aux;
+	aux->map = map;
+
 	return map;
 }
 
 static void prog_array_map_free(struct bpf_map *map)
 {
+	struct prog_poke_elem *elem, *tmp;
 	struct bpf_array_aux *aux;
 
 	aux = container_of(map, struct bpf_array, map)->aux;
+	list_for_each_entry_safe(elem, tmp, &aux->poke_progs, list) {
+		list_del_init(&elem->list);
+		kfree(elem);
+	}
 	kfree(aux);
 	fd_array_map_free(map);
 }
@@ -703,13 +875,16 @@ const struct bpf_map_ops prog_array_map_ops = {
 	.map_alloc_check = fd_array_map_alloc_check,
 	.map_alloc = prog_array_map_alloc,
 	.map_free = prog_array_map_free,
+	.map_poke_track = prog_array_map_poke_track,
+	.map_poke_untrack = prog_array_map_poke_untrack,
+	.map_poke_run = prog_array_map_poke_run,
 	.map_get_next_key = array_map_get_next_key,
 	.map_lookup_elem = fd_array_map_lookup_elem,
 	.map_delete_elem = fd_array_map_delete_elem,
 	.map_fd_get_ptr = prog_fd_array_get_ptr,
 	.map_fd_put_ptr = prog_fd_array_put_ptr,
 	.map_fd_sys_lookup_elem = prog_fd_array_sys_lookup_elem,
-	.map_release_uref = bpf_fd_array_map_clear,
+	.map_release_uref = prog_array_map_clear,
 	.map_seq_show_elem = prog_array_map_seq_show_elem,
 };
 
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 608b7085e0c9..49e32acad7d8 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -2050,11 +2050,16 @@ static void bpf_free_cgroup_storage(struct bpf_prog_aux *aux)
 
 static void bpf_free_used_maps(struct bpf_prog_aux *aux)
 {
+	struct bpf_map *map;
 	int i;
 
 	bpf_free_cgroup_storage(aux);
-	for (i = 0; i < aux->used_map_cnt; i++)
-		bpf_map_put(aux->used_maps[i]);
+	for (i = 0; i < aux->used_map_cnt; i++) {
+		map = aux->used_maps[i];
+		if (map->ops->map_poke_untrack)
+			map->ops->map_poke_untrack(map, aux);
+		bpf_map_put(map);
+	}
 	kfree(aux->used_maps);
 }
 
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 5a9873e58a01..bb002f15b32a 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -26,12 +26,13 @@
 #include <linux/audit.h>
 #include <uapi/linux/btf.h>
 
-#define IS_FD_ARRAY(map) ((map)->map_type == BPF_MAP_TYPE_PROG_ARRAY || \
-			   (map)->map_type == BPF_MAP_TYPE_PERF_EVENT_ARRAY || \
-			   (map)->map_type == BPF_MAP_TYPE_CGROUP_ARRAY || \
-			   (map)->map_type == BPF_MAP_TYPE_ARRAY_OF_MAPS)
+#define IS_FD_ARRAY(map) ((map)->map_type == BPF_MAP_TYPE_PERF_EVENT_ARRAY || \
+			  (map)->map_type == BPF_MAP_TYPE_CGROUP_ARRAY || \
+			  (map)->map_type == BPF_MAP_TYPE_ARRAY_OF_MAPS)
+#define IS_FD_PROG_ARRAY(map) ((map)->map_type == BPF_MAP_TYPE_PROG_ARRAY)
 #define IS_FD_HASH(map) ((map)->map_type == BPF_MAP_TYPE_HASH_OF_MAPS)
-#define IS_FD_MAP(map) (IS_FD_ARRAY(map) || IS_FD_HASH(map))
+#define IS_FD_MAP(map) (IS_FD_ARRAY(map) || IS_FD_PROG_ARRAY(map) || \
+			IS_FD_HASH(map))
 
 #define BPF_OBJ_FLAG_MASK   (BPF_F_RDONLY | BPF_F_WRONLY)
 
@@ -878,7 +879,7 @@ static int map_lookup_elem(union bpf_attr *attr)
 		err = bpf_percpu_cgroup_storage_copy(map, key, value);
 	} else if (map->map_type == BPF_MAP_TYPE_STACK_TRACE) {
 		err = bpf_stackmap_copy(map, key, value);
-	} else if (IS_FD_ARRAY(map)) {
+	} else if (IS_FD_ARRAY(map) || IS_FD_PROG_ARRAY(map)) {
 		err = bpf_fd_array_map_lookup_elem(map, key, value);
 	} else if (IS_FD_HASH(map)) {
 		err = bpf_fd_htab_map_lookup_elem(map, key, value);
@@ -1005,6 +1006,10 @@ static int map_update_elem(union bpf_attr *attr)
 		   map->map_type == BPF_MAP_TYPE_SOCKMAP) {
 		err = map->ops->map_update_elem(map, key, value, attr->flags);
 		goto out;
+	} else if (IS_FD_PROG_ARRAY(map)) {
+		err = bpf_fd_array_map_update_elem(map, f.file, key, value,
+						   attr->flags);
+		goto out;
 	}
 
 	/* must increment bpf_prog_active to avoid kprobe+bpf triggering from
@@ -1087,6 +1092,9 @@ static int map_delete_elem(union bpf_attr *attr)
 	if (bpf_map_is_dev_bound(map)) {
 		err = bpf_map_offload_delete_elem(map, key);
 		goto out;
+	} else if (IS_FD_PROG_ARRAY(map)) {
+		err = map->ops->map_delete_elem(map, key);
+		goto out;
 	}
 
 	preempt_disable();
-- 
2.21.0

