Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4520F2CAF4B
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 23:02:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390668AbgLAV76 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 16:59:58 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:5488 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390304AbgLAV75 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Dec 2020 16:59:57 -0500
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B1Lmm1P007480
        for <netdev@vger.kernel.org>; Tue, 1 Dec 2020 13:59:16 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=A/7JL5upcPb0ENghGdezgV2kpDP37JUJ4aa5/mTexwQ=;
 b=c6uX2ZzxduadLfYNOj0L+4pW9UNs6ZsaLTeAyZiwV54TsCZlJ2kmMGkMzFCZa6shcxaV
 KolAHGpxzYsBrOV5UBEWZYWdHBLZlUVExcII0H7ShbX9Mktpk5NtKGAY7o2gsTiPn+US
 OEQWM7j4GdYfodAJle59+0hf76L5GJlNTy0= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3547psq7s8-16
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 01 Dec 2020 13:59:16 -0800
Received: from intmgw001.06.prn3.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:11d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 1 Dec 2020 13:59:09 -0800
Received: by devvm3388.prn0.facebook.com (Postfix, from userid 111017)
        id D80F319702DE; Tue,  1 Dec 2020 13:59:06 -0800 (PST)
From:   Roman Gushchin <guro@fb.com>
To:     <bpf@vger.kernel.org>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <netdev@vger.kernel.org>,
        <andrii@kernel.org>, <akpm@linux-foundation.org>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <kernel-team@fb.com>
Subject: [PATCH bpf-next v9 32/34] bpf: eliminate rlimit-based memory accounting infra for bpf maps
Date:   Tue, 1 Dec 2020 13:58:58 -0800
Message-ID: <20201201215900.3569844-33-guro@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20201201215900.3569844-1-guro@fb.com>
References: <20201201215900.3569844-1-guro@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-12-01_11:2020-11-30,2020-12-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 mlxscore=0 malwarescore=0 spamscore=0 priorityscore=1501 bulkscore=0
 mlxlogscore=999 adultscore=0 suspectscore=38 lowpriorityscore=0
 phishscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012010131
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove rlimit-based accounting infrastructure code, which is not used
anymore.

To provide a backward compatibility, use an approximation of the
bpf map memory footprint as a "memlock" value, available to a user
via map info. The approximation is based on the maximal number of
elements and key and value sizes.

Signed-off-by: Roman Gushchin <guro@fb.com>
Acked-by: Song Liu <songliubraving@fb.com>
---
 include/linux/bpf.h                           | 12 ---
 kernel/bpf/syscall.c                          | 96 ++++---------------
 .../selftests/bpf/progs/bpf_iter_bpf_map.c    |  2 +-
 .../selftests/bpf/progs/map_ptr_kern.c        |  7 --
 4 files changed, 17 insertions(+), 100 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index e1f2c95c15ec..61331a148cde 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -138,11 +138,6 @@ struct bpf_map_ops {
 	const struct bpf_iter_seq_info *iter_seq_info;
 };
=20
-struct bpf_map_memory {
-	u32 pages;
-	struct user_struct *user;
-};
-
 struct bpf_map {
 	/* The first two cachelines with read-mostly members of which some
 	 * are also accessed in fast-path (e.g. ops, max_entries).
@@ -163,7 +158,6 @@ struct bpf_map {
 	u32 btf_key_type_id;
 	u32 btf_value_type_id;
 	struct btf *btf;
-	struct bpf_map_memory memory;
 #ifdef CONFIG_MEMCG_KMEM
 	struct mem_cgroup *memcg;
 #endif
@@ -1224,12 +1218,6 @@ void bpf_map_inc_with_uref(struct bpf_map *map);
 struct bpf_map * __must_check bpf_map_inc_not_zero(struct bpf_map *map);
 void bpf_map_put_with_uref(struct bpf_map *map);
 void bpf_map_put(struct bpf_map *map);
-int bpf_map_charge_memlock(struct bpf_map *map, u32 pages);
-void bpf_map_uncharge_memlock(struct bpf_map *map, u32 pages);
-int bpf_map_charge_init(struct bpf_map_memory *mem, u64 size);
-void bpf_map_charge_finish(struct bpf_map_memory *mem);
-void bpf_map_charge_move(struct bpf_map_memory *dst,
-			 struct bpf_map_memory *src);
 void *bpf_map_area_alloc(u64 size, int numa_node);
 void *bpf_map_area_mmapable_alloc(u64 size, int numa_node);
 void bpf_map_area_free(void *base);
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index dff3a5f62d7a..29096d96d989 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -128,7 +128,7 @@ static struct bpf_map *find_and_alloc_map(union bpf_a=
ttr *attr)
 	return map;
 }
=20
-static u32 bpf_map_value_size(struct bpf_map *map)
+static u32 bpf_map_value_size(const struct bpf_map *map)
 {
 	if (map->map_type =3D=3D BPF_MAP_TYPE_PERCPU_HASH ||
 	    map->map_type =3D=3D BPF_MAP_TYPE_LRU_PERCPU_HASH ||
@@ -346,77 +346,6 @@ void bpf_map_init_from_attr(struct bpf_map *map, uni=
on bpf_attr *attr)
 	map->numa_node =3D bpf_map_attr_numa_node(attr);
 }
=20
-static int bpf_charge_memlock(struct user_struct *user, u32 pages)
-{
-	unsigned long memlock_limit =3D rlimit(RLIMIT_MEMLOCK) >> PAGE_SHIFT;
-
-	if (atomic_long_add_return(pages, &user->locked_vm) > memlock_limit) {
-		atomic_long_sub(pages, &user->locked_vm);
-		return -EPERM;
-	}
-	return 0;
-}
-
-static void bpf_uncharge_memlock(struct user_struct *user, u32 pages)
-{
-	if (user)
-		atomic_long_sub(pages, &user->locked_vm);
-}
-
-int bpf_map_charge_init(struct bpf_map_memory *mem, u64 size)
-{
-	u32 pages =3D round_up(size, PAGE_SIZE) >> PAGE_SHIFT;
-	struct user_struct *user;
-	int ret;
-
-	if (size >=3D U32_MAX - PAGE_SIZE)
-		return -E2BIG;
-
-	user =3D get_current_user();
-	ret =3D bpf_charge_memlock(user, pages);
-	if (ret) {
-		free_uid(user);
-		return ret;
-	}
-
-	mem->pages =3D pages;
-	mem->user =3D user;
-
-	return 0;
-}
-
-void bpf_map_charge_finish(struct bpf_map_memory *mem)
-{
-	bpf_uncharge_memlock(mem->user, mem->pages);
-	free_uid(mem->user);
-}
-
-void bpf_map_charge_move(struct bpf_map_memory *dst,
-			 struct bpf_map_memory *src)
-{
-	*dst =3D *src;
-
-	/* Make sure src will not be used for the redundant uncharging. */
-	memset(src, 0, sizeof(struct bpf_map_memory));
-}
-
-int bpf_map_charge_memlock(struct bpf_map *map, u32 pages)
-{
-	int ret;
-
-	ret =3D bpf_charge_memlock(map->memory.user, pages);
-	if (ret)
-		return ret;
-	map->memory.pages +=3D pages;
-	return ret;
-}
-
-void bpf_map_uncharge_memlock(struct bpf_map *map, u32 pages)
-{
-	bpf_uncharge_memlock(map->memory.user, pages);
-	map->memory.pages -=3D pages;
-}
-
 static int bpf_map_alloc_id(struct bpf_map *map)
 {
 	int id;
@@ -524,14 +453,11 @@ static void bpf_map_release_memcg(struct bpf_map *m=
ap)
 static void bpf_map_free_deferred(struct work_struct *work)
 {
 	struct bpf_map *map =3D container_of(work, struct bpf_map, work);
-	struct bpf_map_memory mem;
=20
-	bpf_map_charge_move(&mem, &map->memory);
 	security_bpf_map_free(map);
 	bpf_map_release_memcg(map);
 	/* implementation dependent freeing */
 	map->ops->map_free(map);
-	bpf_map_charge_finish(&mem);
 }
=20
 static void bpf_map_put_uref(struct bpf_map *map)
@@ -592,6 +518,19 @@ static fmode_t map_get_sys_perms(struct bpf_map *map=
, struct fd f)
 }
=20
 #ifdef CONFIG_PROC_FS
+/* Provides an approximation of the map's memory footprint.
+ * Used only to provide a backward compatibility and display
+ * a reasonable "memlock" info.
+ */
+static unsigned long bpf_map_memory_footprint(const struct bpf_map *map)
+{
+	unsigned long size;
+
+	size =3D round_up(map->key_size + bpf_map_value_size(map), 8);
+
+	return round_up(map->max_entries * size, PAGE_SIZE);
+}
+
 static void bpf_map_show_fdinfo(struct seq_file *m, struct file *filp)
 {
 	const struct bpf_map *map =3D filp->private_data;
@@ -610,7 +549,7 @@ static void bpf_map_show_fdinfo(struct seq_file *m, s=
truct file *filp)
 		   "value_size:\t%u\n"
 		   "max_entries:\t%u\n"
 		   "map_flags:\t%#x\n"
-		   "memlock:\t%llu\n"
+		   "memlock:\t%lu\n"
 		   "map_id:\t%u\n"
 		   "frozen:\t%u\n",
 		   map->map_type,
@@ -618,7 +557,7 @@ static void bpf_map_show_fdinfo(struct seq_file *m, s=
truct file *filp)
 		   map->value_size,
 		   map->max_entries,
 		   map->map_flags,
-		   map->memory.pages * 1ULL << PAGE_SHIFT,
+		   bpf_map_memory_footprint(map),
 		   map->id,
 		   READ_ONCE(map->frozen));
 	if (type) {
@@ -861,7 +800,6 @@ static int map_check_btf(struct bpf_map *map, const s=
truct btf *btf,
 static int map_create(union bpf_attr *attr)
 {
 	int numa_node =3D bpf_map_attr_numa_node(attr);
-	struct bpf_map_memory mem;
 	struct bpf_map *map;
 	int f_flags;
 	int err;
@@ -960,9 +898,7 @@ static int map_create(union bpf_attr *attr)
 	security_bpf_map_free(map);
 free_map:
 	btf_put(map->btf);
-	bpf_map_charge_move(&mem, &map->memory);
 	map->ops->map_free(map);
-	bpf_map_charge_finish(&mem);
 	return err;
 }
=20
diff --git a/tools/testing/selftests/bpf/progs/bpf_iter_bpf_map.c b/tools=
/testing/selftests/bpf/progs/bpf_iter_bpf_map.c
index 08651b23edba..b83b5d2e17dc 100644
--- a/tools/testing/selftests/bpf/progs/bpf_iter_bpf_map.c
+++ b/tools/testing/selftests/bpf/progs/bpf_iter_bpf_map.c
@@ -23,6 +23,6 @@ int dump_bpf_map(struct bpf_iter__bpf_map *ctx)
=20
 	BPF_SEQ_PRINTF(seq, "%8u %8ld %8ld %10lu\n", map->id, map->refcnt.count=
er,
 		       map->usercnt.counter,
-		       map->memory.user->locked_vm.counter);
+		       0LLU);
 	return 0;
 }
diff --git a/tools/testing/selftests/bpf/progs/map_ptr_kern.c b/tools/tes=
ting/selftests/bpf/progs/map_ptr_kern.c
index c325405751e2..d8850bc6a9f1 100644
--- a/tools/testing/selftests/bpf/progs/map_ptr_kern.c
+++ b/tools/testing/selftests/bpf/progs/map_ptr_kern.c
@@ -26,17 +26,12 @@ __u32 g_line =3D 0;
 		return 0;	\
 })
=20
-struct bpf_map_memory {
-	__u32 pages;
-} __attribute__((preserve_access_index));
-
 struct bpf_map {
 	enum bpf_map_type map_type;
 	__u32 key_size;
 	__u32 value_size;
 	__u32 max_entries;
 	__u32 id;
-	struct bpf_map_memory memory;
 } __attribute__((preserve_access_index));
=20
 static inline int check_bpf_map_fields(struct bpf_map *map, __u32 key_si=
ze,
@@ -47,7 +42,6 @@ static inline int check_bpf_map_fields(struct bpf_map *=
map, __u32 key_size,
 	VERIFY(map->value_size =3D=3D value_size);
 	VERIFY(map->max_entries =3D=3D max_entries);
 	VERIFY(map->id > 0);
-	VERIFY(map->memory.pages > 0);
=20
 	return 1;
 }
@@ -60,7 +54,6 @@ static inline int check_bpf_map_ptr(struct bpf_map *ind=
irect,
 	VERIFY(indirect->value_size =3D=3D direct->value_size);
 	VERIFY(indirect->max_entries =3D=3D direct->max_entries);
 	VERIFY(indirect->id =3D=3D direct->id);
-	VERIFY(indirect->memory.pages =3D=3D direct->memory.pages);
=20
 	return 1;
 }
--=20
2.26.2

