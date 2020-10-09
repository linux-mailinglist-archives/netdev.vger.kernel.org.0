Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2442D2899EA
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 22:43:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390903AbgJIUnI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 16:43:08 -0400
Received: from www62.your-server.de ([213.133.104.62]:39476 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388554AbgJIUm6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Oct 2020 16:42:58 -0400
Received: from 75.57.196.178.dynamic.wline.res.cust.swisscom.ch ([178.196.57.75] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1kQzE1-00084y-UW; Fri, 09 Oct 2020 22:42:50 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     ast@kernel.org
Cc:     daniel@iogearbox.net, john.fastabend@gmail.com, yhs@fb.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
Subject: [PATCH bpf-next v3 3/6] bpf: allow for map-in-map with dynamic inner array map entries
Date:   Fri,  9 Oct 2020 22:42:42 +0200
Message-Id: <20201009204245.27905-4-daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20201009204245.27905-1-daniel@iogearbox.net>
References: <20201009204245.27905-1-daniel@iogearbox.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/25952/Fri Oct  9 15:52:40 2020)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Recent work in f4d05259213f ("bpf: Add map_meta_equal map ops") and 134fede4eecf
("bpf: Relax max_entries check for most of the inner map types") added support
for dynamic inner max elements for most map-in-map types. Exceptions were maps
like array or prog array where the map_gen_lookup() callback uses the maps'
max_entries field as a constant when emitting instructions.

We recently implemented Maglev consistent hashing into Cilium's load balancer
which uses map-in-map with an outer map being hash and inner being array holding
the Maglev backend table for each service. This has been designed this way in
order to reduce overall memory consumption given the outer hash map allows to
avoid preallocating a large, flat memory area for all services. Also, the
number of service mappings is not always known a-priori.

The use case for dynamic inner array map entries is to further reduce memory
overhead, for example, some services might just have a small number of back
ends while others could have a large number. Right now the Maglev backend table
for small and large number of backends would need to have the same inner array
map entries which adds a lot of unneeded overhead.

Dynamic inner array map entries can be realized by avoiding the inlined code
generation for their lookup. The lookup will still be efficient since it will
be calling into array_map_lookup_elem() directly and thus avoiding retpoline.
The patch adds a BPF_F_NO_INLINE flag to map creation which therefore skips
inline code generation and relaxes array_map_meta_equal() check to ignore both
maps' max_entries.

Example code generation where inner map is dynamic sized array:

  # bpftool p d x i 125
  int handle__sys_enter(void * ctx):
  ; int handle__sys_enter(void *ctx)
     0: (b4) w1 = 0
  ; int key = 0;
     1: (63) *(u32 *)(r10 -4) = r1
     2: (bf) r2 = r10
  ;
     3: (07) r2 += -4
  ; inner_map = bpf_map_lookup_elem(&outer_arr_dyn, &key);
     4: (18) r1 = map[id:468]
     6: (07) r1 += 272
     7: (61) r0 = *(u32 *)(r2 +0)
     8: (35) if r0 >= 0x3 goto pc+5
     9: (67) r0 <<= 3
    10: (0f) r0 += r1
    11: (79) r0 = *(u64 *)(r0 +0)
    12: (15) if r0 == 0x0 goto pc+1
    13: (05) goto pc+1
    14: (b7) r0 = 0
    15: (b4) w6 = -1
  ; if (!inner_map)
    16: (15) if r0 == 0x0 goto pc+6
    17: (bf) r2 = r10
  ;
    18: (07) r2 += -4
  ; val = bpf_map_lookup_elem(inner_map, &key);
    19: (bf) r1 = r0                               | No inlining but instead
    20: (85) call array_map_lookup_elem#149280     | call to array_map_lookup_elem()
  ; return val ? *val : -1;                        | for inner array lookup.
    21: (15) if r0 == 0x0 goto pc+1
  ; return val ? *val : -1;
    22: (61) r6 = *(u32 *)(r0 +0)
  ; }
    23: (bc) w0 = w6
    24: (95) exit

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Cc: Andrii Nakryiko <andrii.nakryiko@gmail.com>
---
 include/linux/bpf.h            |  2 +-
 include/uapi/linux/bpf.h       |  5 +++++
 kernel/bpf/arraymap.c          | 17 +++++++++++------
 kernel/bpf/hashtab.c           |  6 +++---
 kernel/bpf/verifier.c          |  4 +++-
 net/xdp/xskmap.c               |  2 +-
 tools/include/uapi/linux/bpf.h |  5 +++++
 7 files changed, 29 insertions(+), 12 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index dc63eeed4fd9..2b16bf48aab6 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -82,7 +82,7 @@ struct bpf_map_ops {
 	void *(*map_fd_get_ptr)(struct bpf_map *map, struct file *map_file,
 				int fd);
 	void (*map_fd_put_ptr)(void *ptr);
-	u32 (*map_gen_lookup)(struct bpf_map *map, struct bpf_insn *insn_buf);
+	int (*map_gen_lookup)(struct bpf_map *map, struct bpf_insn *insn_buf);
 	u32 (*map_fd_sys_lookup_elem)(void *ptr);
 	void (*map_seq_show_elem)(struct bpf_map *map, void *key,
 				  struct seq_file *m);
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index b97bc5abb3b8..593963e40956 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -435,6 +435,11 @@ enum {
 
 /* Share perf_event among processes */
 	BPF_F_PRESERVE_ELEMS	= (1U << 11),
+
+/* Do not inline (array) map lookups so the array map can be used for
+ * map in map with dynamic max entries.
+ */
+	BPF_F_NO_INLINE		= (1U << 12),
 };
 
 /* Flags for BPF_PROG_QUERY. */
diff --git a/kernel/bpf/arraymap.c b/kernel/bpf/arraymap.c
index bd777dd6f967..f37f46099733 100644
--- a/kernel/bpf/arraymap.c
+++ b/kernel/bpf/arraymap.c
@@ -16,7 +16,7 @@
 
 #define ARRAY_CREATE_FLAG_MASK \
 	(BPF_F_NUMA_NODE | BPF_F_MMAPABLE | BPF_F_ACCESS_MASK | \
-	 BPF_F_PRESERVE_ELEMS)
+	 BPF_F_PRESERVE_ELEMS | BPF_F_NO_INLINE)
 
 static void bpf_array_free_percpu(struct bpf_array *array)
 {
@@ -62,7 +62,7 @@ int array_map_alloc_check(union bpf_attr *attr)
 		return -EINVAL;
 
 	if (attr->map_type != BPF_MAP_TYPE_ARRAY &&
-	    attr->map_flags & BPF_F_MMAPABLE)
+	    attr->map_flags & (BPF_F_MMAPABLE | BPF_F_NO_INLINE))
 		return -EINVAL;
 
 	if (attr->map_type != BPF_MAP_TYPE_PERF_EVENT_ARRAY &&
@@ -214,7 +214,7 @@ static int array_map_direct_value_meta(const struct bpf_map *map, u64 imm,
 }
 
 /* emit BPF instructions equivalent to C code of array_map_lookup_elem() */
-static u32 array_map_gen_lookup(struct bpf_map *map, struct bpf_insn *insn_buf)
+static int array_map_gen_lookup(struct bpf_map *map, struct bpf_insn *insn_buf)
 {
 	struct bpf_array *array = container_of(map, struct bpf_array, map);
 	struct bpf_insn *insn = insn_buf;
@@ -223,6 +223,9 @@ static u32 array_map_gen_lookup(struct bpf_map *map, struct bpf_insn *insn_buf)
 	const int map_ptr = BPF_REG_1;
 	const int index = BPF_REG_2;
 
+	if (map->map_flags & BPF_F_NO_INLINE)
+		return -EOPNOTSUPP;
+
 	*insn++ = BPF_ALU64_IMM(BPF_ADD, map_ptr, offsetof(struct bpf_array, value));
 	*insn++ = BPF_LDX_MEM(BPF_W, ret, index, 0);
 	if (!map->bypass_spec_v1) {
@@ -496,8 +499,10 @@ static int array_map_mmap(struct bpf_map *map, struct vm_area_struct *vma)
 static bool array_map_meta_equal(const struct bpf_map *meta0,
 				 const struct bpf_map *meta1)
 {
-	return meta0->max_entries == meta1->max_entries &&
-		bpf_map_meta_equal(meta0, meta1);
+	if (!bpf_map_meta_equal(meta0, meta1))
+		return false;
+	return meta0->map_flags & BPF_F_NO_INLINE ? true :
+	       meta0->max_entries == meta1->max_entries;
 }
 
 struct bpf_iter_seq_array_map_info {
@@ -1251,7 +1256,7 @@ static void *array_of_map_lookup_elem(struct bpf_map *map, void *key)
 	return READ_ONCE(*inner_map);
 }
 
-static u32 array_of_map_gen_lookup(struct bpf_map *map,
+static int array_of_map_gen_lookup(struct bpf_map *map,
 				   struct bpf_insn *insn_buf)
 {
 	struct bpf_array *array = container_of(map, struct bpf_array, map);
diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
index 3395cf140d22..1815e97d4c9c 100644
--- a/kernel/bpf/hashtab.c
+++ b/kernel/bpf/hashtab.c
@@ -612,7 +612,7 @@ static void *htab_map_lookup_elem(struct bpf_map *map, void *key)
  * bpf_prog
  *   __htab_map_lookup_elem
  */
-static u32 htab_map_gen_lookup(struct bpf_map *map, struct bpf_insn *insn_buf)
+static int htab_map_gen_lookup(struct bpf_map *map, struct bpf_insn *insn_buf)
 {
 	struct bpf_insn *insn = insn_buf;
 	const int ret = BPF_REG_0;
@@ -651,7 +651,7 @@ static void *htab_lru_map_lookup_elem_sys(struct bpf_map *map, void *key)
 	return __htab_lru_map_lookup_elem(map, key, false);
 }
 
-static u32 htab_lru_map_gen_lookup(struct bpf_map *map,
+static int htab_lru_map_gen_lookup(struct bpf_map *map,
 				   struct bpf_insn *insn_buf)
 {
 	struct bpf_insn *insn = insn_buf;
@@ -2070,7 +2070,7 @@ static void *htab_of_map_lookup_elem(struct bpf_map *map, void *key)
 	return READ_ONCE(*inner_map);
 }
 
-static u32 htab_of_map_gen_lookup(struct bpf_map *map,
+static int htab_of_map_gen_lookup(struct bpf_map *map,
 				  struct bpf_insn *insn_buf)
 {
 	struct bpf_insn *insn = insn_buf;
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 62b804651a48..4ef3584320dc 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -10985,6 +10985,8 @@ static int fixup_bpf_calls(struct bpf_verifier_env *env)
 			if (insn->imm == BPF_FUNC_map_lookup_elem &&
 			    ops->map_gen_lookup) {
 				cnt = ops->map_gen_lookup(map_ptr, insn_buf);
+				if (cnt == -EOPNOTSUPP)
+					goto patch_map_ops_generic;
 				if (cnt == 0 || cnt >= ARRAY_SIZE(insn_buf)) {
 					verbose(env, "bpf verifier is misconfigured\n");
 					return -EINVAL;
@@ -11015,7 +11017,7 @@ static int fixup_bpf_calls(struct bpf_verifier_env *env)
 				     (int (*)(struct bpf_map *map, void *value))NULL));
 			BUILD_BUG_ON(!__same_type(ops->map_peek_elem,
 				     (int (*)(struct bpf_map *map, void *value))NULL));
-
+patch_map_ops_generic:
 			switch (insn->imm) {
 			case BPF_FUNC_map_lookup_elem:
 				insn->imm = BPF_CAST_CALL(ops->map_lookup_elem) -
diff --git a/net/xdp/xskmap.c b/net/xdp/xskmap.c
index 0c5df593bc56..49da2b8ace8b 100644
--- a/net/xdp/xskmap.c
+++ b/net/xdp/xskmap.c
@@ -132,7 +132,7 @@ static int xsk_map_get_next_key(struct bpf_map *map, void *key, void *next_key)
 	return 0;
 }
 
-static u32 xsk_map_gen_lookup(struct bpf_map *map, struct bpf_insn *insn_buf)
+static int xsk_map_gen_lookup(struct bpf_map *map, struct bpf_insn *insn_buf)
 {
 	const int ret = BPF_REG_0, mp = BPF_REG_1, index = BPF_REG_2;
 	struct bpf_insn *insn = insn_buf;
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index b97bc5abb3b8..593963e40956 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -435,6 +435,11 @@ enum {
 
 /* Share perf_event among processes */
 	BPF_F_PRESERVE_ELEMS	= (1U << 11),
+
+/* Do not inline (array) map lookups so the array map can be used for
+ * map in map with dynamic max entries.
+ */
+	BPF_F_NO_INLINE		= (1U << 12),
 };
 
 /* Flags for BPF_PROG_QUERY. */
-- 
2.17.1

