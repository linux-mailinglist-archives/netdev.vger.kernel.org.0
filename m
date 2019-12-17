Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5996122B7A
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 13:28:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727868AbfLQM2b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 07:28:31 -0500
Received: from www62.your-server.de ([213.133.104.62]:36510 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726962AbfLQM2a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 07:28:30 -0500
Received: from 31.249.197.178.dynamic.dsl-lte-bonding.lssmb00p-msn.res.cust.swisscom.ch ([178.197.249.31] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1ihBxj-0006vF-Ve; Tue, 17 Dec 2019 13:28:28 +0100
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     ast@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Roman Gushchin <guro@fb.com>, Martin KaFai Lau <kafai@fb.com>
Subject: [PATCH bpf] bpf: Fix cgroup local storage prog tracking
Date:   Tue, 17 Dec 2019 13:28:16 +0100
Message-Id: <1471c69eca3022218666f909bc927a92388fd09e.1576580332.git.daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25666/Tue Dec 17 10:54:52 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Recently noticed that we're tracking programs related to local storage maps
through their prog pointer. This is a wrong assumption since the prog pointer
can still change throughout the verification process, for example, whenever
bpf_patch_insn_single() is called.

Therefore, the prog pointer that was assigned via bpf_cgroup_storage_assign()
is not guaranteed to be the same as we pass in bpf_cgroup_storage_release()
and the map would therefore remain in busy state forever. Fix this by using
the prog's aux pointer which is stable throughout verification and beyond.

Fixes: de9cbbaadba5 ("bpf: introduce cgroup storage maps")
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Cc: Roman Gushchin <guro@fb.com>
Cc: Martin KaFai Lau <kafai@fb.com>
---
 include/linux/bpf-cgroup.h |  8 ++++----
 kernel/bpf/core.c          |  3 +--
 kernel/bpf/local_storage.c | 24 ++++++++++++------------
 kernel/bpf/verifier.c      |  2 +-
 4 files changed, 18 insertions(+), 19 deletions(-)

diff --git a/include/linux/bpf-cgroup.h b/include/linux/bpf-cgroup.h
index 169fd25f6bc2..9be71c195d74 100644
--- a/include/linux/bpf-cgroup.h
+++ b/include/linux/bpf-cgroup.h
@@ -157,8 +157,8 @@ void bpf_cgroup_storage_link(struct bpf_cgroup_storage *storage,
 			     struct cgroup *cgroup,
 			     enum bpf_attach_type type);
 void bpf_cgroup_storage_unlink(struct bpf_cgroup_storage *storage);
-int bpf_cgroup_storage_assign(struct bpf_prog *prog, struct bpf_map *map);
-void bpf_cgroup_storage_release(struct bpf_prog *prog, struct bpf_map *map);
+int bpf_cgroup_storage_assign(struct bpf_prog_aux *aux, struct bpf_map *map);
+void bpf_cgroup_storage_release(struct bpf_prog_aux *aux, struct bpf_map *map);
 
 int bpf_percpu_cgroup_storage_copy(struct bpf_map *map, void *key, void *value);
 int bpf_percpu_cgroup_storage_update(struct bpf_map *map, void *key,
@@ -360,9 +360,9 @@ static inline int cgroup_bpf_prog_query(const union bpf_attr *attr,
 
 static inline void bpf_cgroup_storage_set(
 	struct bpf_cgroup_storage *storage[MAX_BPF_CGROUP_STORAGE_TYPE]) {}
-static inline int bpf_cgroup_storage_assign(struct bpf_prog *prog,
+static inline int bpf_cgroup_storage_assign(struct bpf_prog_aux *aux,
 					    struct bpf_map *map) { return 0; }
-static inline void bpf_cgroup_storage_release(struct bpf_prog *prog,
+static inline void bpf_cgroup_storage_release(struct bpf_prog_aux *aux,
 					      struct bpf_map *map) {}
 static inline struct bpf_cgroup_storage *bpf_cgroup_storage_alloc(
 	struct bpf_prog *prog, enum bpf_cgroup_storage_type stype) { return NULL; }
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 6231858df723..af6b738cf435 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -2043,8 +2043,7 @@ static void bpf_free_cgroup_storage(struct bpf_prog_aux *aux)
 	for_each_cgroup_storage_type(stype) {
 		if (!aux->cgroup_storage[stype])
 			continue;
-		bpf_cgroup_storage_release(aux->prog,
-					   aux->cgroup_storage[stype]);
+		bpf_cgroup_storage_release(aux, aux->cgroup_storage[stype]);
 	}
 }
 
diff --git a/kernel/bpf/local_storage.c b/kernel/bpf/local_storage.c
index 2ba750725cb2..6bf605dd4b94 100644
--- a/kernel/bpf/local_storage.c
+++ b/kernel/bpf/local_storage.c
@@ -20,7 +20,7 @@ struct bpf_cgroup_storage_map {
 	struct bpf_map map;
 
 	spinlock_t lock;
-	struct bpf_prog *prog;
+	struct bpf_prog_aux *aux;
 	struct rb_root root;
 	struct list_head list;
 };
@@ -420,7 +420,7 @@ const struct bpf_map_ops cgroup_storage_map_ops = {
 	.map_seq_show_elem = cgroup_storage_seq_show_elem,
 };
 
-int bpf_cgroup_storage_assign(struct bpf_prog *prog, struct bpf_map *_map)
+int bpf_cgroup_storage_assign(struct bpf_prog_aux *aux, struct bpf_map *_map)
 {
 	enum bpf_cgroup_storage_type stype = cgroup_storage_type(_map);
 	struct bpf_cgroup_storage_map *map = map_to_storage(_map);
@@ -428,14 +428,14 @@ int bpf_cgroup_storage_assign(struct bpf_prog *prog, struct bpf_map *_map)
 
 	spin_lock_bh(&map->lock);
 
-	if (map->prog && map->prog != prog)
+	if (map->aux && map->aux != aux)
 		goto unlock;
-	if (prog->aux->cgroup_storage[stype] &&
-	    prog->aux->cgroup_storage[stype] != _map)
+	if (aux->cgroup_storage[stype] &&
+	    aux->cgroup_storage[stype] != _map)
 		goto unlock;
 
-	map->prog = prog;
-	prog->aux->cgroup_storage[stype] = _map;
+	map->aux = aux;
+	aux->cgroup_storage[stype] = _map;
 	ret = 0;
 unlock:
 	spin_unlock_bh(&map->lock);
@@ -443,16 +443,16 @@ int bpf_cgroup_storage_assign(struct bpf_prog *prog, struct bpf_map *_map)
 	return ret;
 }
 
-void bpf_cgroup_storage_release(struct bpf_prog *prog, struct bpf_map *_map)
+void bpf_cgroup_storage_release(struct bpf_prog_aux *aux, struct bpf_map *_map)
 {
 	enum bpf_cgroup_storage_type stype = cgroup_storage_type(_map);
 	struct bpf_cgroup_storage_map *map = map_to_storage(_map);
 
 	spin_lock_bh(&map->lock);
-	if (map->prog == prog) {
-		WARN_ON(prog->aux->cgroup_storage[stype] != _map);
-		map->prog = NULL;
-		prog->aux->cgroup_storage[stype] = NULL;
+	if (map->aux == aux) {
+		WARN_ON(aux->cgroup_storage[stype] != _map);
+		map->aux = NULL;
+		aux->cgroup_storage[stype] = NULL;
 	}
 	spin_unlock_bh(&map->lock);
 }
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index a1acdce77070..6ef71429d997 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -8268,7 +8268,7 @@ static int replace_map_fd_with_map_ptr(struct bpf_verifier_env *env)
 			env->used_maps[env->used_map_cnt++] = map;
 
 			if (bpf_map_is_cgroup_storage(map) &&
-			    bpf_cgroup_storage_assign(env->prog, map)) {
+			    bpf_cgroup_storage_assign(env->prog->aux, map)) {
 				verbose(env, "only one cgroup storage of each type is allowed\n");
 				fdput(f);
 				return -EBUSY;
-- 
2.21.0

