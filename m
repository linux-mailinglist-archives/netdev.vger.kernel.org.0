Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C26BCFD22C
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 02:04:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727453AbfKOBEW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 20:04:22 -0500
Received: from www62.your-server.de ([213.133.104.62]:50736 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727254AbfKOBEV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 20:04:21 -0500
Received: from 57.248.197.178.dynamic.dsl-lte-bonding.zhbmb00p-msn.res.cust.swisscom.ch ([178.197.248.57] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iVQ27-00080z-Qt; Fri, 15 Nov 2019 02:04:19 +0100
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     ast@kernel.org
Cc:     john.fastabend@gmail.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH rfc bpf-next 4/8] bpf: move owner type,jited info into array auxillary data
Date:   Fri, 15 Nov 2019 02:03:58 +0100
Message-Id: <ba2d30018f57b5608e04e105c6f6692e687698b4.1573779287.git.daniel@iogearbox.net>
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

We're going to extend this with further information which is only
relevant for prog array at this point. Given this info is not used
in critical path, move it into its own structure such that the main
array map structure can be kept on diet.

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
---
 include/linux/bpf.h     | 18 +++++++++++-------
 kernel/bpf/arraymap.c   | 32 ++++++++++++++++++++++++++++++--
 kernel/bpf/core.c       | 11 +++++------
 kernel/bpf/map_in_map.c |  5 ++---
 kernel/bpf/syscall.c    | 16 ++++++----------
 5 files changed, 54 insertions(+), 28 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index ed1725539891..40337fa0e463 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -556,17 +556,21 @@ struct bpf_prog_aux {
 	};
 };
 
+struct bpf_array_aux {
+	/* 'Ownership' of prog array is claimed by the first program that
+	 * is going to use this map or by the first program which FD is
+	 * stored in the map to make sure that all callers and callees have
+	 * the same prog type and JITed flag.
+	 */
+	enum bpf_prog_type type;
+	bool jited;
+};
+
 struct bpf_array {
 	struct bpf_map map;
 	u32 elem_size;
 	u32 index_mask;
-	/* 'ownership' of prog_array is claimed by the first program that
-	 * is going to use this map or by the first program which FD is stored
-	 * in the map to make sure that all callers and callees have the same
-	 * prog_type and JITed flag
-	 */
-	enum bpf_prog_type owner_prog_type;
-	bool owner_jited;
+	struct bpf_array_aux *aux;
 	union {
 		char value[0] __aligned(8);
 		void *ptrs[0] __aligned(8);
diff --git a/kernel/bpf/arraymap.c b/kernel/bpf/arraymap.c
index 1c65ce0098a9..88c1363b2925 100644
--- a/kernel/bpf/arraymap.c
+++ b/kernel/bpf/arraymap.c
@@ -625,10 +625,38 @@ static void prog_array_map_seq_show_elem(struct bpf_map *map, void *key,
 	rcu_read_unlock();
 }
 
+static struct bpf_map *prog_array_map_alloc(union bpf_attr *attr)
+{
+	struct bpf_array_aux *aux;
+	struct bpf_map *map;
+
+	aux = kzalloc(sizeof(*aux), GFP_KERNEL);
+	if (!aux)
+		return ERR_PTR(-ENOMEM);
+
+	map = array_map_alloc(attr);
+	if (IS_ERR(map)) {
+		kfree(aux);
+		return map;
+	}
+
+	container_of(map, struct bpf_array, map)->aux = aux;
+	return map;
+}
+
+static void prog_array_map_free(struct bpf_map *map)
+{
+	struct bpf_array_aux *aux;
+
+	aux = container_of(map, struct bpf_array, map)->aux;
+	kfree(aux);
+	fd_array_map_free(map);
+}
+
 const struct bpf_map_ops prog_array_map_ops = {
 	.map_alloc_check = fd_array_map_alloc_check,
-	.map_alloc = array_map_alloc,
-	.map_free = fd_array_map_free,
+	.map_alloc = prog_array_map_alloc,
+	.map_free = prog_array_map_free,
 	.map_get_next_key = array_map_get_next_key,
 	.map_lookup_elem = fd_array_map_lookup_elem,
 	.map_delete_elem = fd_array_map_delete_elem,
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 516ef5923eea..c359d0a94896 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -1687,18 +1687,17 @@ bool bpf_prog_array_compatible(struct bpf_array *array,
 	if (fp->kprobe_override)
 		return false;
 
-	if (!array->owner_prog_type) {
+	if (!array->aux->type) {
 		/* There's no owner yet where we could check for
 		 * compatibility.
 		 */
-		array->owner_prog_type = fp->type;
-		array->owner_jited = fp->jited;
-
+		array->aux->type  = fp->type;
+		array->aux->jited = fp->jited;
 		return true;
 	}
 
-	return array->owner_prog_type == fp->type &&
-	       array->owner_jited == fp->jited;
+	return array->aux->type  == fp->type &&
+	       array->aux->jited == fp->jited;
 }
 
 static int bpf_check_tail_call(const struct bpf_prog *fp)
diff --git a/kernel/bpf/map_in_map.c b/kernel/bpf/map_in_map.c
index fab4fb134547..296f4ac76211 100644
--- a/kernel/bpf/map_in_map.c
+++ b/kernel/bpf/map_in_map.c
@@ -17,9 +17,8 @@ struct bpf_map *bpf_map_meta_alloc(int inner_map_ufd)
 	if (IS_ERR(inner_map))
 		return inner_map;
 
-	/* prog_array->owner_prog_type and owner_jited
-	 * is a runtime binding.  Doing static check alone
-	 * in the verifier is not enough.
+	/* prog_array->aux->{type,jited} is a runtime binding.
+	 * Doing static check alone in the verifier is not enough.
 	 */
 	if (inner_map->map_type == BPF_MAP_TYPE_PROG_ARRAY ||
 	    inner_map->map_type == BPF_MAP_TYPE_CGROUP_STORAGE ||
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 1b311742a2ea..81057e5922d5 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -371,13 +371,12 @@ static void bpf_map_show_fdinfo(struct seq_file *m, struct file *filp)
 {
 	const struct bpf_map *map = filp->private_data;
 	const struct bpf_array *array;
-	u32 owner_prog_type = 0;
-	u32 owner_jited = 0;
+	u32 type = 0, jited = 0;
 
 	if (map->map_type == BPF_MAP_TYPE_PROG_ARRAY) {
 		array = container_of(map, struct bpf_array, map);
-		owner_prog_type = array->owner_prog_type;
-		owner_jited = array->owner_jited;
+		type  = array->aux->type;
+		jited = array->aux->jited;
 	}
 
 	seq_printf(m,
@@ -397,12 +396,9 @@ static void bpf_map_show_fdinfo(struct seq_file *m, struct file *filp)
 		   map->memory.pages * 1ULL << PAGE_SHIFT,
 		   map->id,
 		   READ_ONCE(map->frozen));
-
-	if (owner_prog_type) {
-		seq_printf(m, "owner_prog_type:\t%u\n",
-			   owner_prog_type);
-		seq_printf(m, "owner_jited:\t%u\n",
-			   owner_jited);
+	if (type) {
+		seq_printf(m, "owner_prog_type:\t%u\n", type);
+		seq_printf(m, "owner_jited:\t%u\n", jited);
 	}
 }
 #endif
-- 
2.21.0

