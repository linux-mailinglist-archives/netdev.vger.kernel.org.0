Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B88782B1133
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 23:16:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727593AbgKLWQK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 17:16:10 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:47702 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727535AbgKLWQH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 17:16:07 -0500
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 0ACMCla3024884
        for <netdev@vger.kernel.org>; Thu, 12 Nov 2020 14:16:06 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=7uzhk17n4QpogwpKk1SOusxxl7O/PzbHTgMLMiHq61w=;
 b=QeO9KQu8l7PXiew3JpL00Rg1wcc80rgSdKIMVj9k3L+Ntnshrvzs3x+Q5isiOf7spI6D
 Tdo5NUVJ+4bG0MmSbrvBfojj1cVoqmesP/EQvU0iFIIwnNgo7mzvt/kU9azY4Bpz8ILz
 MgQc/eExJgJ0SwzcnoaLIxp70Jq0FzJWwww= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0089730.ppops.net with ESMTP id 34r4sh5c9m-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 12 Nov 2020 14:16:06 -0800
Received: from intmgw002.06.prn3.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:11d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 12 Nov 2020 14:16:01 -0800
Received: by devvm3388.prn0.facebook.com (Postfix, from userid 111017)
        id 6C157A7D246; Thu, 12 Nov 2020 14:16:01 -0800 (PST)
From:   Roman Gushchin <guro@fb.com>
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        <netdev@vger.kernel.org>, Andrii Nakryiko <andrii@kernel.org>,
        Shakeel Butt <shakeelb@google.com>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <kernel-team@fb.com>,
        Roman Gushchin <guro@fb.com>
Subject: [PATCH bpf-next v5 32/34] bpf: eliminate rlimit-based memory accounting infra for bpf maps
Date:   Thu, 12 Nov 2020 14:15:41 -0800
Message-ID: <20201112221543.3621014-33-guro@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20201112221543.3621014-1-guro@fb.com>
References: <20201112221543.3621014-1-guro@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-12_13:2020-11-12,2020-11-12 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 adultscore=0 clxscore=1015 suspectscore=38 bulkscore=0 mlxlogscore=999
 priorityscore=1501 lowpriorityscore=0 mlxscore=0 phishscore=0 spamscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011120126
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove rlimit-based accounting infrastructure code, which is not used
anymore.

Signed-off-by: Roman Gushchin <guro@fb.com>
---
 include/linux/bpf.h                           | 12 ----
 kernel/bpf/syscall.c                          | 64 +------------------
 .../selftests/bpf/progs/bpf_iter_bpf_map.c    |  2 +-
 .../selftests/bpf/progs/map_ptr_kern.c        |  7 --
 4 files changed, 3 insertions(+), 82 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 1d6e7b125877..6f1ef8a1e25f 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -136,11 +136,6 @@ struct bpf_map_ops {
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
@@ -161,7 +156,6 @@ struct bpf_map {
 	u32 btf_key_type_id;
 	u32 btf_value_type_id;
 	struct btf *btf;
-	struct bpf_map_memory memory;
 #ifdef CONFIG_MEMCG_KMEM
 	struct mem_cgroup *memcg;
 #endif
@@ -1222,12 +1216,6 @@ void bpf_map_inc_with_uref(struct bpf_map *map);
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
index fcadf953989f..9f41edbae3f8 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -359,60 +359,6 @@ static void bpf_uncharge_memlock(struct user_struct =
*user, u32 pages)
 		atomic_long_sub(pages, &user->locked_vm);
 }
=20
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
@@ -482,14 +428,11 @@ static void bpf_map_release_memcg(struct bpf_map *m=
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
@@ -568,7 +511,7 @@ static void bpf_map_show_fdinfo(struct seq_file *m, s=
truct file *filp)
 		   "value_size:\t%u\n"
 		   "max_entries:\t%u\n"
 		   "map_flags:\t%#x\n"
-		   "memlock:\t%llu\n"
+		   "memlock:\t%llu\n" /* deprecated */
 		   "map_id:\t%u\n"
 		   "frozen:\t%u\n",
 		   map->map_type,
@@ -576,7 +519,7 @@ static void bpf_map_show_fdinfo(struct seq_file *m, s=
truct file *filp)
 		   map->value_size,
 		   map->max_entries,
 		   map->map_flags,
-		   map->memory.pages * 1ULL << PAGE_SHIFT,
+		   0LLU,
 		   map->id,
 		   READ_ONCE(map->frozen));
 	if (type) {
@@ -819,7 +762,6 @@ static int map_check_btf(struct bpf_map *map, const s=
truct btf *btf,
 static int map_create(union bpf_attr *attr)
 {
 	int numa_node =3D bpf_map_attr_numa_node(attr);
-	struct bpf_map_memory mem;
 	struct bpf_map *map;
 	int f_flags;
 	int err;
@@ -918,9 +860,7 @@ static int map_create(union bpf_attr *attr)
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

