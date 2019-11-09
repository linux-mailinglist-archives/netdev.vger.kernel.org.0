Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B93BDF5DFA
	for <lists+netdev@lfdr.de>; Sat,  9 Nov 2019 09:06:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726390AbfKIIGl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Nov 2019 03:06:41 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:52746 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726301AbfKIIGl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Nov 2019 03:06:41 -0500
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id xA984hjF023633
        for <netdev@vger.kernel.org>; Sat, 9 Nov 2019 00:06:39 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=S6i1EbmBfRYxsZNw7U1uvrEzSvEX4CU5VGulTnrMUeg=;
 b=Y5Y20lR1g+2DholRDl9e55XED4YA+1c2ELb7gTQoMwQR+458BMVkUEVnlr+z8QlN9qh3
 S3Uhhqz6mQQqc2soZBxWf68HLmNUZFk5hVrjUZ7+a9dilX/4O+isTg4gzGpTw4Lbk7/l
 p3D5mHwyyHCeAP/R0DY+w0Qkf2O4XLZ0SEk= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 2w5p7m0hq1-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Sat, 09 Nov 2019 00:06:38 -0800
Received: from 2401:db00:30:600c:face:0:1f:0 (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Sat, 9 Nov 2019 00:06:37 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 44C6B2EC1AC6; Sat,  9 Nov 2019 00:06:36 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Rik van Riel <riel@surriel.com>,
        Johannes Weiner <hannes@cmpxchg.org>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v2 bpf-next 1/3] bpf: add mmap() support for BPF_MAP_TYPE_ARRAY
Date:   Sat, 9 Nov 2019 00:06:30 -0800
Message-ID: <20191109080633.2855561-2-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191109080633.2855561-1-andriin@fb.com>
References: <20191109080633.2855561-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-09_02:2019-11-08,2019-11-09 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 spamscore=0 clxscore=1015 lowpriorityscore=0 mlxlogscore=999 bulkscore=0
 suspectscore=25 malwarescore=0 mlxscore=0 adultscore=0 phishscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911090085
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

With BPF_F_MMAPABLE array allocating data in separate chunk of memory,
array_map_gen_lookup has to accomodate these changes. For non-memory-mapped
there are no changes and no extra instructions. For BPF_F_MMAPABLE case,
pointer to where array data is stored has to be dereferenced first.

Generated code for non-memory-mapped array:

; p = bpf_map_lookup_elem(&data_map, &zero);
  22: (18) r1 = map[id:19]
  24: (07) r1 += 408			/* array->inline_data offset */
  25: (61) r0 = *(u32 *)(r2 +0)
  26: (35) if r0 >= 0x3 goto pc+3
  27: (67) r0 <<= 3
  28: (0f) r0 += r1
  29: (05) goto pc+1
  30: (b7) r0 = 0

Generated code for memory-mapped array:

; p = bpf_map_lookup_elem(&data_map, &zero);
  22: (18) r1 = map[id:27]
  24: (07) r1 += 400			/* array->data offset */
  25: (79) r1 = *(u64 *)(r1 +0)		/* extra dereference */
  26: (61) r0 = *(u32 *)(r2 +0)
  27: (35) if r0 >= 0x3 goto pc+3
  28: (67) r0 <<= 3
  29: (0f) r0 += r1
  30: (05) goto pc+1
  31: (b7) r0 = 0

Cc: Rik van Riel <riel@surriel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 include/linux/bpf.h            |   9 ++-
 include/uapi/linux/bpf.h       |   3 +
 kernel/bpf/arraymap.c          | 111 +++++++++++++++++++++++++++++----
 kernel/bpf/syscall.c           |  47 ++++++++++++++
 tools/include/uapi/linux/bpf.h |   3 +
 5 files changed, 159 insertions(+), 14 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 7c7f518811a6..296332227959 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -12,6 +12,7 @@
 #include <linux/err.h>
 #include <linux/rbtree_latch.h>
 #include <linux/numa.h>
+#include <linux/mm_types.h>
 #include <linux/wait.h>
 #include <linux/u64_stats_sync.h>
 
@@ -66,6 +67,7 @@ struct bpf_map_ops {
 				     u64 *imm, u32 off);
 	int (*map_direct_value_meta)(const struct bpf_map *map,
 				     u64 imm, u32 *off);
+	int (*map_mmap)(struct bpf_map *map, struct vm_area_struct *vma);
 };
 
 struct bpf_map_memory {
@@ -95,7 +97,7 @@ struct bpf_map {
 	struct btf *btf;
 	struct bpf_map_memory memory;
 	bool unpriv_array;
-	bool frozen; /* write-once */
+	bool frozen; /* write-once; write-protected by freeze_mutex */
 	/* 48 bytes hole */
 
 	/* The 3rd and 4th cacheline with misc members to avoid false sharing
@@ -105,6 +107,8 @@ struct bpf_map {
 	atomic_t usercnt;
 	struct work_struct work;
 	char name[BPF_OBJ_NAME_LEN];
+	struct mutex freeze_mutex;
+	int writecnt; /* writable mmap cnt; protected by freeze_mutex */
 };
 
 static inline bool map_value_has_spin_lock(const struct bpf_map *map)
@@ -461,8 +465,9 @@ struct bpf_array {
 	 */
 	enum bpf_prog_type owner_prog_type;
 	bool owner_jited;
+	void *data;
 	union {
-		char value[0] __aligned(8);
+		char inline_data[0] __aligned(8);
 		void *ptrs[0] __aligned(8);
 		void __percpu *pptrs[0] __aligned(8);
 	};
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index df6809a76404..bb39b53622d9 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -346,6 +346,9 @@ enum bpf_attach_type {
 /* Clone map from listener for newly accepted socket */
 #define BPF_F_CLONE		(1U << 9)
 
+/* Enable memory-mapping BPF map */
+#define BPF_F_MMAPABLE		(1U << 10)
+
 /* flags for BPF_PROG_QUERY */
 #define BPF_F_QUERY_EFFECTIVE	(1U << 0)
 
diff --git a/kernel/bpf/arraymap.c b/kernel/bpf/arraymap.c
index 1c65ce0098a9..275973b68bdd 100644
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
@@ -74,7 +78,7 @@ static struct bpf_map *array_map_alloc(union bpf_attr *attr)
 	int ret, numa_node = bpf_map_attr_numa_node(attr);
 	u32 elem_size, index_mask, max_entries;
 	bool unpriv = !capable(CAP_SYS_ADMIN);
-	u64 cost, array_size, mask64;
+	u64 cost, array_size, data_size, mask64;
 	struct bpf_map_memory mem;
 	struct bpf_array *array;
 
@@ -102,13 +106,20 @@ static struct bpf_map *array_map_alloc(union bpf_attr *attr)
 	}
 
 	array_size = sizeof(*array);
-	if (percpu)
+	data_size = 0;
+	if (percpu) {
 		array_size += (u64) max_entries * sizeof(void *);
-	else
-		array_size += (u64) max_entries * elem_size;
+	} else {
+		if (attr->map_flags & BPF_F_MMAPABLE) {
+			data_size = (u64) max_entries * elem_size;
+			data_size = round_up(data_size, PAGE_SIZE);
+		} else {
+			array_size += (u64) max_entries * elem_size;
+		}
+	}
 
 	/* make sure there is no u32 overflow later in round_up() */
-	cost = array_size;
+	cost = array_size + data_size;
 	if (percpu)
 		cost += (u64)attr->max_entries * elem_size * num_possible_cpus();
 
@@ -122,6 +133,19 @@ static struct bpf_map *array_map_alloc(union bpf_attr *attr)
 		bpf_map_charge_finish(&mem);
 		return ERR_PTR(-ENOMEM);
 	}
+	array->data = (void *)&array->inline_data;
+
+	if (attr->map_flags & BPF_F_MMAPABLE) {
+		void *data = vzalloc_node(data_size, numa_node);
+
+		if (!data) {
+			bpf_map_charge_finish(&mem);
+			bpf_map_area_free(array);
+			return ERR_PTR(-ENOMEM);
+		}
+		array->data = data;
+	}
+
 	array->index_mask = index_mask;
 	array->map.unpriv_array = unpriv;
 
@@ -148,7 +172,7 @@ static void *array_map_lookup_elem(struct bpf_map *map, void *key)
 	if (unlikely(index >= array->map.max_entries))
 		return NULL;
 
-	return array->value + array->elem_size * (index & array->index_mask);
+	return array->data + array->elem_size * (index & array->index_mask);
 }
 
 static int array_map_direct_value_addr(const struct bpf_map *map, u64 *imm,
@@ -161,7 +185,7 @@ static int array_map_direct_value_addr(const struct bpf_map *map, u64 *imm,
 	if (off >= map->value_size)
 		return -EINVAL;
 
-	*imm = (unsigned long)array->value;
+	*imm = (unsigned long)array->data;
 	return 0;
 }
 
@@ -169,7 +193,7 @@ static int array_map_direct_value_meta(const struct bpf_map *map, u64 imm,
 				       u32 *off)
 {
 	struct bpf_array *array = container_of(map, struct bpf_array, map);
-	u64 base = (unsigned long)array->value;
+	u64 base = (unsigned long)array->data;
 	u64 range = array->elem_size;
 
 	if (map->max_entries != 1)
@@ -191,7 +215,15 @@ static u32 array_map_gen_lookup(struct bpf_map *map, struct bpf_insn *insn_buf)
 	const int map_ptr = BPF_REG_1;
 	const int index = BPF_REG_2;
 
-	*insn++ = BPF_ALU64_IMM(BPF_ADD, map_ptr, offsetof(struct bpf_array, value));
+	if (map->map_flags & BPF_F_MMAPABLE) {
+		*insn++ = BPF_ALU64_IMM(BPF_ADD, map_ptr,
+					offsetof(struct bpf_array, data));
+		*insn++ = BPF_LDX_MEM(bytes_to_bpf_size(sizeof(void *)),
+				      map_ptr, map_ptr, 0);
+	} else {
+		*insn++ = BPF_ALU64_IMM(BPF_ADD, map_ptr,
+					offsetof(struct bpf_array, inline_data));
+	}
 	*insn++ = BPF_LDX_MEM(BPF_W, ret, index, 0);
 	if (map->unpriv_array) {
 		*insn++ = BPF_JMP_IMM(BPF_JGE, ret, map->max_entries, 4);
@@ -296,7 +328,7 @@ static int array_map_update_elem(struct bpf_map *map, void *key, void *value,
 		memcpy(this_cpu_ptr(array->pptrs[index & array->index_mask]),
 		       value, map->value_size);
 	} else {
-		val = array->value +
+		val = array->data +
 			array->elem_size * (index & array->index_mask);
 		if (map_flags & BPF_F_LOCK)
 			copy_map_value_locked(map, val, value, false);
@@ -365,6 +397,8 @@ static void array_map_free(struct bpf_map *map)
 	if (array->map.map_type == BPF_MAP_TYPE_PERCPU_ARRAY)
 		bpf_array_free_percpu(array);
 
+	if (array->map.map_flags & BPF_F_MMAPABLE)
+		vfree(array->data);
 	bpf_map_area_free(array);
 }
 
@@ -444,6 +478,56 @@ static int array_map_check_btf(const struct bpf_map *map,
 	return 0;
 }
 
+void array_map_mmap_close(struct vm_area_struct *vma)
+{
+	struct bpf_array *array = vma->vm_file->private_data;
+
+	mutex_lock(&array->map.freeze_mutex);
+	if (vma->vm_flags & VM_WRITE)
+		array->map.writecnt--;
+	mutex_unlock(&array->map.freeze_mutex);
+
+	bpf_map_put(&array->map);
+}
+
+static vm_fault_t array_map_mmap_fault(struct vm_fault *vmf)
+{
+	struct bpf_array *array = vmf->vma->vm_file->private_data;
+	void *p = array->data + (vmf->pgoff << PAGE_SHIFT);
+
+	vmf->page = vmalloc_to_page(p);
+	/* bump page refcount, it will be decremented by kernel on unmap */
+	get_page(vmf->page);
+
+	return 0;
+}
+
+static const struct vm_operations_struct array_map_vmops = {
+	.close		= array_map_mmap_close,
+	.fault		= array_map_mmap_fault,
+};
+
+int array_map_mmap(struct bpf_map *map, struct vm_area_struct *vma)
+{
+	struct bpf_array *array = container_of(map, struct bpf_array, map);
+	u64 data_size, vma_size;
+
+	if (!(map->map_flags & BPF_F_MMAPABLE))
+		return -EINVAL;
+
+	data_size = (u64)array->elem_size * map->max_entries;
+	data_size = round_up(data_size, PAGE_SIZE);
+	vma_size = vma->vm_end - vma->vm_start;
+	if (vma_size != data_size)
+		return -EINVAL;
+
+	vma->vm_ops = &array_map_vmops;
+	vma->vm_flags |= VM_DONTCOPY | VM_DONTEXPAND;
+	vma->vm_private_data = array;
+
+	return 0;
+}
+
 const struct bpf_map_ops array_map_ops = {
 	.map_alloc_check = array_map_alloc_check,
 	.map_alloc = array_map_alloc,
@@ -455,6 +539,7 @@ const struct bpf_map_ops array_map_ops = {
 	.map_gen_lookup = array_map_gen_lookup,
 	.map_direct_value_addr = array_map_direct_value_addr,
 	.map_direct_value_meta = array_map_direct_value_meta,
+	.map_mmap = array_map_mmap,
 	.map_seq_show_elem = array_map_seq_show_elem,
 	.map_check_btf = array_map_check_btf,
 };
@@ -810,7 +895,9 @@ static u32 array_of_map_gen_lookup(struct bpf_map *map,
 	const int map_ptr = BPF_REG_1;
 	const int index = BPF_REG_2;
 
-	*insn++ = BPF_ALU64_IMM(BPF_ADD, map_ptr, offsetof(struct bpf_array, value));
+	/* array of maps can't be BPF_F_MMAPABLE, so use inline_data */
+	*insn++ = BPF_ALU64_IMM(BPF_ADD, map_ptr,
+				offsetof(struct bpf_array, inline_data));
 	*insn++ = BPF_LDX_MEM(BPF_W, ret, index, 0);
 	if (map->unpriv_array) {
 		*insn++ = BPF_JMP_IMM(BPF_JGE, ret, map->max_entries, 6);
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 6d9ce95e5a8d..c6ff1034c2f6 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -425,6 +425,43 @@ static ssize_t bpf_dummy_write(struct file *filp, const char __user *buf,
 	return -EINVAL;
 }
 
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
+	map = bpf_map_inc(map, false);
+	if (IS_ERR(map)) {
+		err = PTR_ERR(map);
+		goto out;
+	}
+
+	err = map->ops->map_mmap(map, vma);
+	if (err) {
+		bpf_map_put(map);
+		goto out;
+	}
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
@@ -432,6 +469,7 @@ const struct file_operations bpf_map_fops = {
 	.release	= bpf_map_release,
 	.read		= bpf_dummy_read,
 	.write		= bpf_dummy_write,
+	.mmap		= bpf_map_mmap,
 };
 
 int bpf_map_new_fd(struct bpf_map *map, int flags)
@@ -577,6 +615,7 @@ static int map_create(union bpf_attr *attr)
 
 	atomic_set(&map->refcnt, 1);
 	atomic_set(&map->usercnt, 1);
+	mutex_init(&map->freeze_mutex);
 
 	if (attr->btf_key_type_id || attr->btf_value_type_id) {
 		struct btf *btf;
@@ -1173,6 +1212,13 @@ static int map_freeze(const union bpf_attr *attr)
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
@@ -1184,6 +1230,7 @@ static int map_freeze(const union bpf_attr *attr)
 
 	WRITE_ONCE(map->frozen, true);
 err_put:
+	mutex_unlock(&map->freeze_mutex);
 	fdput(f);
 	return err;
 }
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index df6809a76404..bb39b53622d9 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -346,6 +346,9 @@ enum bpf_attach_type {
 /* Clone map from listener for newly accepted socket */
 #define BPF_F_CLONE		(1U << 9)
 
+/* Enable memory-mapping BPF map */
+#define BPF_F_MMAPABLE		(1U << 10)
+
 /* flags for BPF_PROG_QUERY */
 #define BPF_F_QUERY_EFFECTIVE	(1U << 0)
 
-- 
2.17.1

