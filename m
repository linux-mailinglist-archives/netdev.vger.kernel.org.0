Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8968C1BFCA
	for <lists+netdev@lfdr.de>; Tue, 14 May 2019 01:19:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726710AbfEMXT0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 May 2019 19:19:26 -0400
Received: from www62.your-server.de ([213.133.104.62]:57884 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726645AbfEMXTW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 May 2019 19:19:22 -0400
Received: from [178.199.41.31] (helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hQKE4-0001rs-Jt; Tue, 14 May 2019 01:19:20 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     ast@kernel.org
Cc:     kafai@fb.com, bpf@vger.kernel.org, netdev@vger.kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH bpf 2/3] bpf, lru: avoid messing with eviction heuristics upon syscall lookup
Date:   Tue, 14 May 2019 01:18:56 +0200
Message-Id: <4d61a8afb6f4c790c34e30db830ad23550ba7712.1557789256.git.daniel@iogearbox.net>
X-Mailer: git-send-email 2.9.5
In-Reply-To: <cover.1557789256.git.daniel@iogearbox.net>
References: <cover.1557789256.git.daniel@iogearbox.net>
In-Reply-To: <cover.1557789256.git.daniel@iogearbox.net>
References: <cover.1557789256.git.daniel@iogearbox.net>
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25448/Mon May 13 09:57:34 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

One of the biggest issues we face right now with picking LRU map over
regular hash table is that a map walk out of user space, for example,
to just dump the existing entries or to remove certain ones, will
completely mess up LRU eviction heuristics and wrong entries such
as just created ones will get evicted instead. The reason for this
is that we mark an entry as "in use" via bpf_lru_node_set_ref() from
system call lookup side as well. Thus upon walk, all entries are
being marked, so information of actual least recently used ones
are "lost".

In case of Cilium where it can be used (besides others) as a BPF
based connection tracker, this current behavior causes disruption
upon control plane changes that need to walk the map from user space
to evict certain entries. Discussion result from bpfconf [0] was that
we should simply just remove marking from system call side as no
good use case could be found where it's actually needed there.
Therefore this patch removes marking for regular LRU and per-CPU
flavor. If there ever should be a need in future, the behavior could
be selected via map creation flag, but due to mentioned reason we
avoid this here.

  [0] http://vger.kernel.org/bpfconf.html

Fixes: 29ba732acbee ("bpf: Add BPF_MAP_TYPE_LRU_HASH")
Fixes: 8f8449384ec3 ("bpf: Add BPF_MAP_TYPE_LRU_PERCPU_HASH")
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Martin KaFai Lau <kafai@fb.com>
---
 kernel/bpf/hashtab.c | 23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
index 192d32e..0f2708f 100644
--- a/kernel/bpf/hashtab.c
+++ b/kernel/bpf/hashtab.c
@@ -527,18 +527,30 @@ static u32 htab_map_gen_lookup(struct bpf_map *map, struct bpf_insn *insn_buf)
 	return insn - insn_buf;
 }
 
-static void *htab_lru_map_lookup_elem(struct bpf_map *map, void *key)
+static __always_inline void *__htab_lru_map_lookup_elem(struct bpf_map *map,
+							void *key, const bool mark)
 {
 	struct htab_elem *l = __htab_map_lookup_elem(map, key);
 
 	if (l) {
-		bpf_lru_node_set_ref(&l->lru_node);
+		if (mark)
+			bpf_lru_node_set_ref(&l->lru_node);
 		return l->key + round_up(map->key_size, 8);
 	}
 
 	return NULL;
 }
 
+static void *htab_lru_map_lookup_elem(struct bpf_map *map, void *key)
+{
+	return __htab_lru_map_lookup_elem(map, key, true);
+}
+
+static void *htab_lru_map_lookup_elem_sys(struct bpf_map *map, void *key)
+{
+	return __htab_lru_map_lookup_elem(map, key, false);
+}
+
 static u32 htab_lru_map_gen_lookup(struct bpf_map *map,
 				   struct bpf_insn *insn_buf)
 {
@@ -1250,6 +1262,7 @@ const struct bpf_map_ops htab_lru_map_ops = {
 	.map_free = htab_map_free,
 	.map_get_next_key = htab_map_get_next_key,
 	.map_lookup_elem = htab_lru_map_lookup_elem,
+	.map_lookup_elem_sys_only = htab_lru_map_lookup_elem_sys,
 	.map_update_elem = htab_lru_map_update_elem,
 	.map_delete_elem = htab_lru_map_delete_elem,
 	.map_gen_lookup = htab_lru_map_gen_lookup,
@@ -1281,7 +1294,6 @@ static void *htab_lru_percpu_map_lookup_elem(struct bpf_map *map, void *key)
 
 int bpf_percpu_hash_copy(struct bpf_map *map, void *key, void *value)
 {
-	struct bpf_htab *htab = container_of(map, struct bpf_htab, map);
 	struct htab_elem *l;
 	void __percpu *pptr;
 	int ret = -ENOENT;
@@ -1297,8 +1309,9 @@ int bpf_percpu_hash_copy(struct bpf_map *map, void *key, void *value)
 	l = __htab_map_lookup_elem(map, key);
 	if (!l)
 		goto out;
-	if (htab_is_lru(htab))
-		bpf_lru_node_set_ref(&l->lru_node);
+	/* We do not mark LRU map element here in order to not mess up
+	 * eviction heuristics when user space does a map walk.
+	 */
 	pptr = htab_elem_get_ptr(l, map->key_size);
 	for_each_possible_cpu(cpu) {
 		bpf_long_memcpy(value + off,
-- 
2.9.5

