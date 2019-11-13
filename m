Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 059B3FA77A
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 04:44:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727447AbfKMDon (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 22:44:43 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:41034 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727352AbfKMDon (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 22:44:43 -0500
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xAD3Bm0G013685
        for <netdev@vger.kernel.org>; Tue, 12 Nov 2019 19:15:27 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=C3LhrTNW8USJ+Tzm4ZPxQq0JMUbu8Zs8eGS16yev4hQ=;
 b=HsnnQomVLcdZnrwwLljL70T6rlkBVkp4E5Z2WP6buLwOaYM8pJubtD8WXWjkWYzv7018
 2vCSy55MolpMlQm4GVtndtfggVqVFvwT+JzKVKfCxp7JnMEueVGk1AIEqb0FiP7ioPtb
 BbHhK8E4nNZDNmZHYzb1vlkC3FiDmKYWh1o= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2w7pr7drhv-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 12 Nov 2019 19:15:27 -0800
Received: from 2401:db00:12:9028:face:0:29:0 (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::127) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Tue, 12 Nov 2019 19:15:26 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 6C93F2EC1B1D; Tue, 12 Nov 2019 19:15:25 -0800 (PST)
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
Subject: [PATCH v3 bpf-next 1/3] bpf: add mmap() support for BPF_MAP_TYPE_ARRAY
Date:   Tue, 12 Nov 2019 19:15:16 -0800
Message-ID: <20191113031518.155618-2-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191113031518.155618-1-andriin@fb.com>
References: <20191113031518.155618-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-12_10:2019-11-11,2019-11-12 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0 clxscore=1015
 mlxscore=0 suspectscore=25 lowpriorityscore=0 mlxlogscore=999
 impostorscore=0 malwarescore=0 bulkscore=0 adultscore=0 phishscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911130026
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

Cc: Rik van Riel <riel@surriel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 include/linux/bpf.h            |  6 ++-
 include/uapi/linux/bpf.h       |  3 ++
 kernel/bpf/arraymap.c          | 93 +++++++++++++++++++++++++++++++---
 kernel/bpf/syscall.c           | 47 +++++++++++++++++
 tools/include/uapi/linux/bpf.h |  3 ++
 5 files changed, 145 insertions(+), 7 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 7c7f518811a6..ab9a24b94357 100644
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
index 1c65ce0098a9..08dc9634c5ed 100644
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
@@ -102,10 +106,20 @@ static struct bpf_map *array_map_alloc(union bpf_attr *attr)
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
+			array_size = round_up(array_size, PAGE_SIZE);
+			array_size += (u64) max_entries * elem_size;
+			array_size = round_up(array_size, PAGE_SIZE);
+		} else {
+			array_size += (u64) max_entries * elem_size;
+		}
+	}
 
 	/* make sure there is no u32 overflow later in round_up() */
 	cost = array_size;
@@ -117,7 +131,20 @@ static struct bpf_map *array_map_alloc(union bpf_attr *attr)
 		return ERR_PTR(ret);
 
 	/* allocate all map elements and zero-initialize them */
-	array = bpf_map_area_alloc(array_size, numa_node);
+	if (attr->map_flags & BPF_F_MMAPABLE) {
+		void *data;
+
+		/* kmalloc'ed memory can't be mmap'ed, use explicit vmalloc */
+		data = vzalloc_node(array_size, numa_node);
+		if (!data) {
+			bpf_map_charge_finish(&mem);
+			return ERR_PTR(-ENOMEM);
+		}
+		array = data + round_up(sizeof(struct bpf_array), PAGE_SIZE)
+			- offsetof(struct bpf_array, value);
+	} else {
+		array = bpf_map_area_alloc(array_size, numa_node);
+	}
 	if (!array) {
 		bpf_map_charge_finish(&mem);
 		return ERR_PTR(-ENOMEM);
@@ -365,7 +392,10 @@ static void array_map_free(struct bpf_map *map)
 	if (array->map.map_type == BPF_MAP_TYPE_PERCPU_ARRAY)
 		bpf_array_free_percpu(array);
 
-	bpf_map_area_free(array);
+	if (array->map.map_flags & BPF_F_MMAPABLE)
+		bpf_map_area_free((void *)round_down((long)array, PAGE_SIZE));
+	else
+		bpf_map_area_free(array);
 }
 
 static void array_map_seq_show_elem(struct bpf_map *map, void *key,
@@ -444,6 +474,56 @@ static int array_map_check_btf(const struct bpf_map *map,
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
+	void *p = array->value + (vmf->pgoff << PAGE_SHIFT);
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
@@ -455,6 +535,7 @@ const struct bpf_map_ops array_map_ops = {
 	.map_gen_lookup = array_map_gen_lookup,
 	.map_direct_value_addr = array_map_direct_value_addr,
 	.map_direct_value_meta = array_map_direct_value_meta,
+	.map_mmap = array_map_mmap,
 	.map_seq_show_elem = array_map_seq_show_elem,
 	.map_check_btf = array_map_check_btf,
 };
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

