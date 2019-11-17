Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA0F4FF821
	for <lists+netdev@lfdr.de>; Sun, 17 Nov 2019 07:50:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726062AbfKQGuv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Nov 2019 01:50:51 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:24172 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726032AbfKQGuv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Nov 2019 01:50:51 -0500
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xAH6mUX3010529
        for <netdev@vger.kernel.org>; Sat, 16 Nov 2019 22:50:50 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=WNRhByeZiYuBpIfbSRQPKTOmS6F0BWGyByRaoHGmyMY=;
 b=GZkx6X4L0bKhRKcbclqgMM9uXDif4SBZtDyWEMTe/DsOO1VZ8ZTGSp6IvykR/kiqewOk
 6Cz6XRXom8cTSUlzyD4qOUBfYDmM4hmAcYCTjikFsrRbbKUXkA5GBQ9e3aW/n710RXYf
 DKKT29C1o1pNvF3H9L/Ap6lHePGgdGs5PWc= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2wah9uyrn8-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Sat, 16 Nov 2019 22:50:49 -0800
Received: from 2401:db00:2120:80d4:face:0:39:0 (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Sat, 16 Nov 2019 22:50:48 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 0CAB72EC18AA; Sat, 16 Nov 2019 22:50:45 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Rik van Riel <riel@surriel.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v5 bpf-next 3/5] bpf: add mmap() support for BPF_MAP_TYPE_ARRAY
Date:   Sat, 16 Nov 2019 22:50:33 -0800
Message-ID: <20191117065035.202462-4-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191117065035.202462-1-andriin@fb.com>
References: <20191117065035.202462-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-17_01:2019-11-15,2019-11-16 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 mlxlogscore=999 adultscore=0 bulkscore=0 mlxscore=0 lowpriorityscore=0
 clxscore=1015 suspectscore=25 phishscore=0 spamscore=0 priorityscore=1501
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911170063
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add ability to memory-map contents of BPF array map. This is extremely useful
for working with BPF global data from userspace programs. It allows to avoid
typical bpf_map_{lookup,update}_elem operations, improving both performance
and usability.

There had to be special considerations for map freezing, to avoid having
writable memory view into a frozen map. To solve this issue, map freezing and
mmap-ing is happening under mutex now:
  - if map is already frozen, no writable mapping is allowed;
  - if map has writable memory mappings active (accounted in map->writecnt),
    map freezing will keep failing with -EBUSY;
  - once number of writable memory mappings drops to zero, map freezing can be
    performed again.

Only non-per-CPU plain arrays are supported right now. Maps with spinlocks
can't be memory mapped either.

For BPF_F_MMAPABLE array, memory allocation has to be done through vmalloc()
to be mmap()'able. We also need to make sure that array data memory is
page-sized and page-aligned, so we over-allocate memory in such a way that
struct bpf_array is at the end of a single page of memory with array->value
being aligned with the start of the second page. On deallocation we need to
accomodate this memory arrangement to free vmalloc()'ed memory correctly.

One important consideration regarding how memory-mapping subsystem functions.
Memory-mapping subsystem provides few optional callbacks, among them open()
and close().  close() is called for each memory region that is unmapped, so
that users can decrease their reference counters and free up resources, if
necessary. open() is *almost* symmetrical: it's called for each memory region
that is being mapped, **except** the very first one. So bpf_map_mmap does
initial refcnt bump, while open() will do any extra ones after that. Thus
number of close() calls is equal to number of open() calls plus one more.

Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Rik van Riel <riel@surriel.com>
Acked-by: Song Liu <songliubraving@fb.com>
Acked-by: John Fastabend <john.fastabend@gmail.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 include/linux/bpf.h            | 11 ++--
 include/linux/vmalloc.h        |  1 +
 include/uapi/linux/bpf.h       |  3 ++
 kernel/bpf/arraymap.c          | 58 +++++++++++++++++---
 kernel/bpf/syscall.c           | 99 ++++++++++++++++++++++++++++++++--
 mm/vmalloc.c                   | 20 +++++++
 tools/include/uapi/linux/bpf.h |  3 ++
 7 files changed, 183 insertions(+), 12 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index fb606dc61a3a..e913dd5946ae 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -12,6 +12,7 @@
 #include <linux/err.h>
 #include <linux/rbtree_latch.h>
 #include <linux/numa.h>
+#include <linux/mm_types.h>
 #include <linux/wait.h>
 #include <linux/u64_stats_sync.h>
 #include <linux/refcount.h>
@@ -68,6 +69,7 @@ struct bpf_map_ops {
 				     u64 *imm, u32 off);
 	int (*map_direct_value_meta)(const struct bpf_map *map,
 				     u64 imm, u32 *off);
+	int (*map_mmap)(struct bpf_map *map, struct vm_area_struct *vma);
 };
 
 struct bpf_map_memory {
@@ -96,9 +98,10 @@ struct bpf_map {
 	u32 btf_value_type_id;
 	struct btf *btf;
 	struct bpf_map_memory memory;
+	char name[BPF_OBJ_NAME_LEN];
 	bool unpriv_array;
-	bool frozen; /* write-once */
-	/* 48 bytes hole */
+	bool frozen; /* write-once; write-protected by freeze_mutex */
+	/* 22 bytes hole */
 
 	/* The 3rd and 4th cacheline with misc members to avoid false sharing
 	 * particularly with refcounting.
@@ -106,7 +109,8 @@ struct bpf_map {
 	atomic64_t refcnt ____cacheline_aligned;
 	atomic64_t usercnt;
 	struct work_struct work;
-	char name[BPF_OBJ_NAME_LEN];
+	struct mutex freeze_mutex;
+	u64 writecnt; /* writable mmap cnt; protected by freeze_mutex */
 };
 
 static inline bool map_value_has_spin_lock(const struct bpf_map *map)
@@ -795,6 +799,7 @@ void bpf_map_charge_finish(struct bpf_map_memory *mem);
 void bpf_map_charge_move(struct bpf_map_memory *dst,
 			 struct bpf_map_memory *src);
 void *bpf_map_area_alloc(size_t size, int numa_node);
+void *bpf_map_area_mmapable_alloc(size_t size, int numa_node);
 void bpf_map_area_free(void *base);
 void bpf_map_init_from_attr(struct bpf_map *map, union bpf_attr *attr);
 
diff --git a/include/linux/vmalloc.h b/include/linux/vmalloc.h
index 4e7809408073..b4c58a191eb1 100644
--- a/include/linux/vmalloc.h
+++ b/include/linux/vmalloc.h
@@ -93,6 +93,7 @@ extern void *vzalloc(unsigned long size);
 extern void *vmalloc_user(unsigned long size);
 extern void *vmalloc_node(unsigned long size, int node);
 extern void *vzalloc_node(unsigned long size, int node);
+extern void *vmalloc_user_node_flags(unsigned long size, int node, gfp_t flags);
 extern void *vmalloc_exec(unsigned long size);
 extern void *vmalloc_32(unsigned long size);
 extern void *vmalloc_32_user(unsigned long size);
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 4842a134b202..dbbcf0b02970 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -348,6 +348,9 @@ enum bpf_attach_type {
 /* Clone map from listener for newly accepted socket */
 #define BPF_F_CLONE		(1U << 9)
 
+/* Enable memory-mapping BPF map */
+#define BPF_F_MMAPABLE		(1U << 10)
+
 /* flags for BPF_PROG_QUERY */
 #define BPF_F_QUERY_EFFECTIVE	(1U << 0)
 
diff --git a/kernel/bpf/arraymap.c b/kernel/bpf/arraymap.c
index 1c65ce0098a9..a42097c36b0c 100644
--- a/kernel/bpf/arraymap.c
+++ b/kernel/bpf/arraymap.c
@@ -14,7 +14,7 @@
 #include "map_in_map.h"
 
 #define ARRAY_CREATE_FLAG_MASK \
-	(BPF_F_NUMA_NODE | BPF_F_ACCESS_MASK)
+	(BPF_F_NUMA_NODE | BPF_F_MMAPABLE | BPF_F_ACCESS_MASK)
 
 static void bpf_array_free_percpu(struct bpf_array *array)
 {
@@ -59,6 +59,10 @@ int array_map_alloc_check(union bpf_attr *attr)
 	    (percpu && numa_node != NUMA_NO_NODE))
 		return -EINVAL;
 
+	if (attr->map_type != BPF_MAP_TYPE_ARRAY &&
+	    attr->map_flags & BPF_F_MMAPABLE)
+		return -EINVAL;
+
 	if (attr->value_size > KMALLOC_MAX_SIZE)
 		/* if value_size is bigger, the user space won't be able to
 		 * access the elements.
@@ -102,10 +106,19 @@ static struct bpf_map *array_map_alloc(union bpf_attr *attr)
 	}
 
 	array_size = sizeof(*array);
-	if (percpu)
+	if (percpu) {
 		array_size += (u64) max_entries * sizeof(void *);
-	else
-		array_size += (u64) max_entries * elem_size;
+	} else {
+		/* rely on vmalloc() to return page-aligned memory and
+		 * ensure array->value is exactly page-aligned
+		 */
+		if (attr->map_flags & BPF_F_MMAPABLE) {
+			array_size = PAGE_ALIGN(array_size);
+			array_size += PAGE_ALIGN((u64) max_entries * elem_size);
+		} else {
+			array_size += (u64) max_entries * elem_size;
+		}
+	}
 
 	/* make sure there is no u32 overflow later in round_up() */
 	cost = array_size;
@@ -117,7 +130,20 @@ static struct bpf_map *array_map_alloc(union bpf_attr *attr)
 		return ERR_PTR(ret);
 
 	/* allocate all map elements and zero-initialize them */
-	array = bpf_map_area_alloc(array_size, numa_node);
+	if (attr->map_flags & BPF_F_MMAPABLE) {
+		void *data;
+
+		/* kmalloc'ed memory can't be mmap'ed, use explicit vmalloc */
+		data = bpf_map_area_mmapable_alloc(array_size, numa_node);
+		if (!data) {
+			bpf_map_charge_finish(&mem);
+			return ERR_PTR(-ENOMEM);
+		}
+		array = data + PAGE_ALIGN(sizeof(struct bpf_array))
+			- offsetof(struct bpf_array, value);
+	} else {
+		array = bpf_map_area_alloc(array_size, numa_node);
+	}
 	if (!array) {
 		bpf_map_charge_finish(&mem);
 		return ERR_PTR(-ENOMEM);
@@ -350,6 +376,11 @@ static int array_map_delete_elem(struct bpf_map *map, void *key)
 	return -EINVAL;
 }
 
+static void *array_map_vmalloc_addr(struct bpf_array *array)
+{
+	return (void *)round_down((unsigned long)array, PAGE_SIZE);
+}
+
 /* Called when map->refcnt goes to zero, either from workqueue or from syscall */
 static void array_map_free(struct bpf_map *map)
 {
@@ -365,7 +396,10 @@ static void array_map_free(struct bpf_map *map)
 	if (array->map.map_type == BPF_MAP_TYPE_PERCPU_ARRAY)
 		bpf_array_free_percpu(array);
 
-	bpf_map_area_free(array);
+	if (array->map.map_flags & BPF_F_MMAPABLE)
+		bpf_map_area_free(array_map_vmalloc_addr(array));
+	else
+		bpf_map_area_free(array);
 }
 
 static void array_map_seq_show_elem(struct bpf_map *map, void *key,
@@ -444,6 +478,17 @@ static int array_map_check_btf(const struct bpf_map *map,
 	return 0;
 }
 
+int array_map_mmap(struct bpf_map *map, struct vm_area_struct *vma)
+{
+	struct bpf_array *array = container_of(map, struct bpf_array, map);
+	pgoff_t pgoff = PAGE_ALIGN(sizeof(*array)) >> PAGE_SHIFT;
+
+	if (!(map->map_flags & BPF_F_MMAPABLE))
+		return -EINVAL;
+
+	return remap_vmalloc_range(vma, array_map_vmalloc_addr(array), pgoff);
+}
+
 const struct bpf_map_ops array_map_ops = {
 	.map_alloc_check = array_map_alloc_check,
 	.map_alloc = array_map_alloc,
@@ -455,6 +500,7 @@ const struct bpf_map_ops array_map_ops = {
 	.map_gen_lookup = array_map_gen_lookup,
 	.map_direct_value_addr = array_map_direct_value_addr,
 	.map_direct_value_meta = array_map_direct_value_meta,
+	.map_mmap = array_map_mmap,
 	.map_seq_show_elem = array_map_seq_show_elem,
 	.map_check_btf = array_map_check_btf,
 };
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 52fe4bacb330..79ae97cf18fc 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -127,7 +127,7 @@ static struct bpf_map *find_and_alloc_map(union bpf_attr *attr)
 	return map;
 }
 
-void *bpf_map_area_alloc(size_t size, int numa_node)
+static void *__bpf_map_area_alloc(size_t size, int numa_node, bool mmapable)
 {
 	/* We really just want to fail instead of triggering OOM killer
 	 * under memory pressure, therefore we set __GFP_NORETRY to kmalloc,
@@ -142,18 +142,33 @@ void *bpf_map_area_alloc(size_t size, int numa_node)
 	const gfp_t flags = __GFP_NOWARN | __GFP_ZERO;
 	void *area;
 
-	if (size <= (PAGE_SIZE << PAGE_ALLOC_COSTLY_ORDER)) {
+	/* kmalloc()'ed memory can't be mmap()'ed */
+	if (!mmapable && size <= (PAGE_SIZE << PAGE_ALLOC_COSTLY_ORDER)) {
 		area = kmalloc_node(size, GFP_USER | __GFP_NORETRY | flags,
 				    numa_node);
 		if (area != NULL)
 			return area;
 	}
-
+	if (mmapable) {
+		BUG_ON(!PAGE_ALIGNED(size));
+		return vmalloc_user_node_flags(size, numa_node, GFP_KERNEL |
+					       __GFP_RETRY_MAYFAIL | flags);
+	}
 	return __vmalloc_node_flags_caller(size, numa_node,
 					   GFP_KERNEL | __GFP_RETRY_MAYFAIL |
 					   flags, __builtin_return_address(0));
 }
 
+void *bpf_map_area_alloc(size_t size, int numa_node)
+{
+	return __bpf_map_area_alloc(size, numa_node, false);
+}
+
+void *bpf_map_area_mmapable_alloc(size_t size, int numa_node)
+{
+	return __bpf_map_area_alloc(size, numa_node, true);
+}
+
 void bpf_map_area_free(void *area)
 {
 	kvfree(area);
@@ -425,6 +440,74 @@ static ssize_t bpf_dummy_write(struct file *filp, const char __user *buf,
 	return -EINVAL;
 }
 
+/* called for any extra memory-mapped regions (except initial) */
+static void bpf_map_mmap_open(struct vm_area_struct *vma)
+{
+	struct bpf_map *map = vma->vm_file->private_data;
+
+	bpf_map_inc(map);
+
+	if (vma->vm_flags & VM_WRITE) {
+		mutex_lock(&map->freeze_mutex);
+		map->writecnt++;
+		mutex_unlock(&map->freeze_mutex);
+	}
+}
+
+/* called for all unmapped memory region (including initial) */
+static void bpf_map_mmap_close(struct vm_area_struct *vma)
+{
+	struct bpf_map *map = vma->vm_file->private_data;
+
+	if (vma->vm_flags & VM_WRITE) {
+		mutex_lock(&map->freeze_mutex);
+		map->writecnt--;
+		mutex_unlock(&map->freeze_mutex);
+	}
+
+	bpf_map_put(map);
+}
+
+static const struct vm_operations_struct bpf_map_default_vmops = {
+	.open		= bpf_map_mmap_open,
+	.close		= bpf_map_mmap_close,
+};
+
+static int bpf_map_mmap(struct file *filp, struct vm_area_struct *vma)
+{
+	struct bpf_map *map = filp->private_data;
+	int err;
+
+	if (!map->ops->map_mmap || map_value_has_spin_lock(map))
+		return -ENOTSUPP;
+
+	if (!(vma->vm_flags & VM_SHARED))
+		return -EINVAL;
+
+	mutex_lock(&map->freeze_mutex);
+
+	if ((vma->vm_flags & VM_WRITE) && map->frozen) {
+		err = -EPERM;
+		goto out;
+	}
+
+	/* set default open/close callbacks */
+	vma->vm_ops = &bpf_map_default_vmops;
+	vma->vm_private_data = map;
+
+	err = map->ops->map_mmap(map, vma);
+	if (err)
+		goto out;
+
+	bpf_map_inc(map);
+
+	if (vma->vm_flags & VM_WRITE)
+		map->writecnt++;
+out:
+	mutex_unlock(&map->freeze_mutex);
+	return err;
+}
+
 const struct file_operations bpf_map_fops = {
 #ifdef CONFIG_PROC_FS
 	.show_fdinfo	= bpf_map_show_fdinfo,
@@ -432,6 +515,7 @@ const struct file_operations bpf_map_fops = {
 	.release	= bpf_map_release,
 	.read		= bpf_dummy_read,
 	.write		= bpf_dummy_write,
+	.mmap		= bpf_map_mmap,
 };
 
 int bpf_map_new_fd(struct bpf_map *map, int flags)
@@ -577,6 +661,7 @@ static int map_create(union bpf_attr *attr)
 
 	atomic64_set(&map->refcnt, 1);
 	atomic64_set(&map->usercnt, 1);
+	mutex_init(&map->freeze_mutex);
 
 	if (attr->btf_key_type_id || attr->btf_value_type_id) {
 		struct btf *btf;
@@ -1163,6 +1248,13 @@ static int map_freeze(const union bpf_attr *attr)
 	map = __bpf_map_get(f);
 	if (IS_ERR(map))
 		return PTR_ERR(map);
+
+	mutex_lock(&map->freeze_mutex);
+
+	if (map->writecnt) {
+		err = -EBUSY;
+		goto err_put;
+	}
 	if (READ_ONCE(map->frozen)) {
 		err = -EBUSY;
 		goto err_put;
@@ -1174,6 +1266,7 @@ static int map_freeze(const union bpf_attr *attr)
 
 	WRITE_ONCE(map->frozen, true);
 err_put:
+	mutex_unlock(&map->freeze_mutex);
 	fdput(f);
 	return err;
 }
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index a3c70e275f4e..4a7d7459c4f9 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -2671,6 +2671,26 @@ void *vzalloc_node(unsigned long size, int node)
 }
 EXPORT_SYMBOL(vzalloc_node);
 
+/**
+ * vmalloc_user_node_flags - allocate memory for userspace on a specific node
+ * @size: allocation size
+ * @node: numa node
+ * @flags: flags for the page level allocator
+ *
+ * The resulting memory area is zeroed so it can be mapped to userspace
+ * without leaking data.
+ *
+ * Return: pointer to the allocated memory or %NULL on error
+ */
+void *vmalloc_user_node_flags(unsigned long size, int node, gfp_t flags)
+{
+	return __vmalloc_node_range(size, SHMLBA,  VMALLOC_START, VMALLOC_END,
+				    flags | __GFP_ZERO, PAGE_KERNEL,
+				    VM_USERMAP, node,
+				    __builtin_return_address(0));
+}
+EXPORT_SYMBOL(vmalloc_user_node_flags);
+
 /**
  * vmalloc_exec - allocate virtually contiguous, executable memory
  * @size:	  allocation size
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 4842a134b202..dbbcf0b02970 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -348,6 +348,9 @@ enum bpf_attach_type {
 /* Clone map from listener for newly accepted socket */
 #define BPF_F_CLONE		(1U << 9)
 
+/* Enable memory-mapping BPF map */
+#define BPF_F_MMAPABLE		(1U << 10)
+
 /* flags for BPF_PROG_QUERY */
 #define BPF_F_QUERY_EFFECTIVE	(1U << 0)
 
-- 
2.17.1

