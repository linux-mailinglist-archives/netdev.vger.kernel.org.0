Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 725A5287E06
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 23:32:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729713AbgJHVcF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 17:32:05 -0400
Received: from www62.your-server.de ([213.133.104.62]:46942 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729225AbgJHVby (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 17:31:54 -0400
Received: from 75.57.196.178.dynamic.wline.res.cust.swisscom.ch ([178.196.57.75] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1kQdVv-0007us-Is; Thu, 08 Oct 2020 23:31:51 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     ast@kernel.org
Cc:     daniel@iogearbox.net, john.fastabend@gmail.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH bpf-next 3/6] bpf: allow for map-in-map with dynamic inner array map entries
Date:   Thu,  8 Oct 2020 23:31:45 +0200
Message-Id: <20201008213148.26848-4-daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20201008213148.26848-1-daniel@iogearbox.net>
References: <20201008213148.26848-1-daniel@iogearbox.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/25951/Thu Oct  8 15:53:03 2020)
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
The patch adds a BPF_F_NO_INLINE flag to map creation which internally swaps
out map ops with a variant that does not have map_gen_lookup() callback and
a relaxed map_meta_equal() that calls bpf_map_meta_equal() directly.

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
---
 include/linux/bpf.h            |  1 +
 include/uapi/linux/bpf.h       |  5 +++++
 kernel/bpf/arraymap.c          | 40 ++++++++++++++++++++++++++++++++--
 kernel/bpf/syscall.c           |  3 ++-
 tools/include/uapi/linux/bpf.h |  5 +++++
 5 files changed, 51 insertions(+), 3 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index dc63eeed4fd9..1f454f9ae739 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -54,6 +54,7 @@ struct bpf_iter_seq_info {
 struct bpf_map_ops {
 	/* funcs callable from userspace (via syscall) */
 	int (*map_alloc_check)(union bpf_attr *attr);
+	const struct bpf_map_ops *(*map_swap_ops)(union bpf_attr *attr);
 	struct bpf_map *(*map_alloc)(union bpf_attr *attr);
 	void (*map_release)(struct bpf_map *map, struct file *map_file);
 	void (*map_free)(struct bpf_map *map);
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index ea8dfbe62c7a..eb384264f906 100644
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
index bd777dd6f967..b8ce41fa2fa7 100644
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
@@ -78,6 +78,16 @@ int array_map_alloc_check(union bpf_attr *attr)
 	return 0;
 }
 
+const struct bpf_map_ops array_map_no_inline_ops;
+const struct bpf_map_ops array_map_ops;
+
+static const struct bpf_map_ops *array_map_swap_ops(union bpf_attr *attr)
+{
+	return attr->map_flags & BPF_F_NO_INLINE ?
+	       &array_map_no_inline_ops :
+	       &array_map_ops;
+}
+
 static struct bpf_map *array_map_alloc(union bpf_attr *attr)
 {
 	bool percpu = attr->map_type == BPF_MAP_TYPE_PERCPU_ARRAY;
@@ -639,6 +649,7 @@ static const struct bpf_iter_seq_info iter_seq_info = {
 static int array_map_btf_id;
 const struct bpf_map_ops array_map_ops = {
 	.map_meta_equal = array_map_meta_equal,
+	.map_swap_ops = array_map_swap_ops,
 	.map_alloc_check = array_map_alloc_check,
 	.map_alloc = array_map_alloc,
 	.map_free = array_map_free,
@@ -659,6 +670,31 @@ const struct bpf_map_ops array_map_ops = {
 	.iter_seq_info = &iter_seq_info,
 };
 
+/* Variant which does not have map_gen_lookup() implementation, but
+ * therefore can relax map_meta_equal() check to allow for dynamic
+ * max_entries for inner maps.
+ */
+const struct bpf_map_ops array_map_no_inline_ops = {
+	.map_meta_equal = bpf_map_meta_equal,
+	.map_alloc_check = array_map_alloc_check,
+	.map_alloc = array_map_alloc,
+	.map_free = array_map_free,
+	.map_get_next_key = array_map_get_next_key,
+	.map_lookup_elem = array_map_lookup_elem,
+	.map_update_elem = array_map_update_elem,
+	.map_delete_elem = array_map_delete_elem,
+	.map_direct_value_addr = array_map_direct_value_addr,
+	.map_direct_value_meta = array_map_direct_value_meta,
+	.map_mmap = array_map_mmap,
+	.map_seq_show_elem = array_map_seq_show_elem,
+	.map_check_btf = array_map_check_btf,
+	.map_lookup_batch = generic_map_lookup_batch,
+	.map_update_batch = generic_map_update_batch,
+	.map_btf_name = "bpf_array",
+	.map_btf_id = &array_map_btf_id,
+	.iter_seq_info = &iter_seq_info,
+};
+
 static int percpu_array_map_btf_id;
 const struct bpf_map_ops percpu_array_map_ops = {
 	.map_meta_equal = bpf_map_meta_equal,
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 1110ecd7d1f3..519bf867f065 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -111,7 +111,8 @@ static struct bpf_map *find_and_alloc_map(union bpf_attr *attr)
 	ops = bpf_map_types[type];
 	if (!ops)
 		return ERR_PTR(-EINVAL);
-
+	if (ops->map_swap_ops)
+		ops = ops->map_swap_ops(attr);
 	if (ops->map_alloc_check) {
 		err = ops->map_alloc_check(attr);
 		if (err)
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index ea8dfbe62c7a..eb384264f906 100644
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

