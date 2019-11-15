Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5174DFD227
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 02:04:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727478AbfKOBEY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 20:04:24 -0500
Received: from www62.your-server.de ([213.133.104.62]:50748 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727355AbfKOBEX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 20:04:23 -0500
Received: from 57.248.197.178.dynamic.dsl-lte-bonding.zhbmb00p-msn.res.cust.swisscom.ch ([178.197.248.57] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iVQ28-00081H-PP; Fri, 15 Nov 2019 02:04:20 +0100
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     ast@kernel.org
Cc:     john.fastabend@gmail.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH rfc bpf-next 6/8] bpf: add poke dependency tracking for prog array maps
Date:   Fri, 15 Nov 2019 02:04:00 +0100
Message-Id: <ff9a3829fb46802262a20dbad1123cd66c118b8b.1573779287.git.daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <cover.1573779287.git.daniel@iogearbox.net>
References: <cover.1573779287.git.daniel@iogearbox.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25633/Thu Nov 14 10:50:04 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This work adds program tracking to prog array maps. This is needed such
that upon prog array updates/deletions we can fix up all programs which
make use of this tail call map. We add ops->map_poke_{un,}track() helpers
to maps to maintain the list of programs and ops->map_poke_run() for
triggering the actual update. bpf_array_aux is extended to contain the
list head and poke_mutex in order to serialize program patching during
updates/deletions. bpf_free_used_maps() will untrack the program shortly
before dropping the reference to the map.

The prog_array_map_poke_run() is triggered during updates/deletions and
walks the maintained prog list. It checks in their poke_tabs whether the
map and key is matching and runs the actual bpf_arch_text_poke() for
patching in the nop or new jmp location. Depending on the type of update,
we use one of BPF_MOD_{NOP_TO_JUMP,JUMP_TO_NOP,JUMP_TO_JUMP}.

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
---
 include/linux/bpf.h   |  36 +++++++++++++
 kernel/bpf/arraymap.c | 120 +++++++++++++++++++++++++++++++++++++++++-
 kernel/bpf/core.c     |   9 +++-
 3 files changed, 162 insertions(+), 3 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 0ff06a0d0058..62a369fb8d98 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -21,6 +21,7 @@ struct bpf_verifier_env;
 struct bpf_verifier_log;
 struct perf_event;
 struct bpf_prog;
+struct bpf_prog_aux;
 struct bpf_map;
 struct sock;
 struct seq_file;
@@ -63,6 +64,12 @@ struct bpf_map_ops {
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
@@ -584,6 +591,9 @@ struct bpf_array_aux {
 	 */
 	enum bpf_prog_type type;
 	bool jited;
+	/* Programs with direct jumps into programs part of this array. */
+	struct list_head poke_progs;
+	struct mutex poke_mutex;
 };
 
 struct bpf_array {
@@ -1325,4 +1335,30 @@ enum bpf_text_poke_type {
 int bpf_arch_text_poke(void *ip, enum bpf_text_poke_type t,
 		       void *addr1, void *addr2);
 
+static inline void bpf_map_poke_lock(struct bpf_map *map)
+	__acquires(&container_of(map, struct bpf_array, map)->aux->poke_mutex)
+{
+#ifdef CONFIG_BPF_SYSCALL
+	struct bpf_array_aux *aux;
+
+	aux = container_of(map, struct bpf_array, map)->aux;
+	if (aux)
+		mutex_lock(&aux->poke_mutex);
+#endif
+	__acquire(&aux->poke_mutex);
+}
+
+static inline void bpf_map_poke_unlock(struct bpf_map *map)
+	__releases(&container_of(map, struct bpf_array, map)->aux->poke_mutex)
+{
+#ifdef CONFIG_BPF_SYSCALL
+	struct bpf_array_aux *aux;
+
+	aux = container_of(map, struct bpf_array, map)->aux;
+	if (aux)
+		mutex_unlock(&aux->poke_mutex);
+#endif
+	__release(&aux->poke_mutex);
+}
+
 #endif /* _LINUX_BPF_H */
diff --git a/kernel/bpf/arraymap.c b/kernel/bpf/arraymap.c
index 88c1363b2925..b9ef993278c6 100644
--- a/kernel/bpf/arraymap.c
+++ b/kernel/bpf/arraymap.c
@@ -540,10 +540,14 @@ int bpf_fd_array_map_update_elem(struct bpf_map *map, struct file *map_file,
 	if (IS_ERR(new_ptr))
 		return PTR_ERR(new_ptr);
 
+	bpf_map_poke_lock(map);
 	old_ptr = xchg(array->ptrs + index, new_ptr);
+	if (map->ops->map_poke_run)
+		map->ops->map_poke_run(map, index, old_ptr, new_ptr);
+	bpf_map_poke_unlock(map);
+
 	if (old_ptr)
 		map->ops->map_fd_put_ptr(old_ptr);
-
 	return 0;
 }
 
@@ -556,7 +560,12 @@ static int fd_array_map_delete_elem(struct bpf_map *map, void *key)
 	if (index >= array->map.max_entries)
 		return -E2BIG;
 
+	bpf_map_poke_lock(map);
 	old_ptr = xchg(array->ptrs + index, NULL);
+	if (map->ops->map_poke_run)
+		map->ops->map_poke_run(map, index, old_ptr, NULL);
+	bpf_map_poke_unlock(map);
+
 	if (old_ptr) {
 		map->ops->map_fd_put_ptr(old_ptr);
 		return 0;
@@ -625,6 +634,104 @@ static void prog_array_map_seq_show_elem(struct bpf_map *map, void *key,
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
+	struct bpf_array_aux *aux;
+	struct prog_poke_elem *elem;
+
+	elem = kmalloc(sizeof(*elem), GFP_KERNEL);
+	if (!elem)
+		return -ENOMEM;
+
+	INIT_LIST_HEAD(&elem->list);
+	elem->aux = prog_aux;
+
+	aux = container_of(map, struct bpf_array, map)->aux;
+	mutex_lock(&aux->poke_mutex);
+	list_add_tail(&elem->list, &aux->poke_progs);
+	mutex_unlock(&aux->poke_mutex);
+	return 0;
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
+	list_for_each_entry(elem, &aux->poke_progs, list) {
+		struct bpf_prog *prog = elem->aux->prog;
+		struct bpf_jit_poke_descriptor *poke;
+		int i, ret;
+
+		/* The prog's kallsym entry was removed out of RCU callback,
+		 * but we can only untrack from sleepable context, therefore
+		 * bpf_arch_text_poke() might not see that this is in BPF text
+		 * section. Given these programs are unreachable, we can skip
+		 * them here. Also programs reaching refcount of zero while
+		 * patching is in progress is okay since we're protected under
+		 * poke_mutex and untrack the programs before the JIT buffer
+		 * is freed. If that happens and if also the RCU callback did
+		 * remove the kallsyms entry in the meantime, bpf_arch_text_poke()
+		 * will bail out with -EINVAL without patching, which is totally
+		 * fine. Any other error happening at that point is a bug.
+		 */
+		if (bpf_prog_under_eviction(prog))
+			continue;
+		for (i = 0; i < prog->aux->size_poke_tab; i++) {
+			poke = &prog->aux->poke_tab[i];
+			if (!READ_ONCE(poke->ip_stable))
+				continue;
+			if (poke->reason != BPF_POKE_REASON_TAIL_CALL)
+				continue;
+			if (poke->tc.map != map || poke->tc.key != key)
+				continue;
+			ret = bpf_arch_text_poke(poke->ip, type,
+						 old ? (u8 *)old->bpf_func +
+						 poke->adj_off : NULL,
+						 new ? (u8 *)new->bpf_func +
+						 poke->adj_off : NULL);
+			/* See comment above. */
+			BUG_ON(ret < 0 && ret != -EINVAL);
+		}
+	}
+}
+
 static struct bpf_map *prog_array_map_alloc(union bpf_attr *attr)
 {
 	struct bpf_array_aux *aux;
@@ -634,6 +741,9 @@ static struct bpf_map *prog_array_map_alloc(union bpf_attr *attr)
 	if (!aux)
 		return ERR_PTR(-ENOMEM);
 
+	INIT_LIST_HEAD(&aux->poke_progs);
+	mutex_init(&aux->poke_mutex);
+
 	map = array_map_alloc(attr);
 	if (IS_ERR(map)) {
 		kfree(aux);
@@ -646,9 +756,14 @@ static struct bpf_map *prog_array_map_alloc(union bpf_attr *attr)
 
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
@@ -657,6 +772,9 @@ const struct bpf_map_ops prog_array_map_ops = {
 	.map_alloc_check = fd_array_map_alloc_check,
 	.map_alloc = prog_array_map_alloc,
 	.map_free = prog_array_map_free,
+	.map_poke_track = prog_array_map_poke_track,
+	.map_poke_untrack = prog_array_map_poke_untrack,
+	.map_poke_run = prog_array_map_poke_run,
 	.map_get_next_key = array_map_get_next_key,
 	.map_lookup_elem = fd_array_map_lookup_elem,
 	.map_delete_elem = fd_array_map_delete_elem,
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 853dc4538442..39750ef3ef31 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -2046,11 +2046,16 @@ static void bpf_free_cgroup_storage(struct bpf_prog_aux *aux)
 
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
 
-- 
2.21.0

