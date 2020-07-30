Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A20E233AB7
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 23:25:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730972AbgG3VZW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 17:25:22 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:27206 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730706AbgG3VXW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jul 2020 17:23:22 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06ULFarn011439
        for <netdev@vger.kernel.org>; Thu, 30 Jul 2020 14:23:21 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=D5ZX8yHdLrdkenHGlZwdSW3KAnS52mlWeRURxGI7Doo=;
 b=CuuOI51bELalc36smOLkK6fkO18VDEUeCdy17f38dEMwiiG8mQGMvxSkUHIHkwokggpG
 SnulRgEt+A+23YrKoPF22fxK/YK5cnuYa/4PNnPSc1kelL3g6516NhdskEdngblXyCMK
 tlpAmo+XJwRQPtET8W1eEuo/HSS35RPv2Ss= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 32kcbuy0yx-10
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 30 Jul 2020 14:23:21 -0700
Received: from intmgw001.06.prn3.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:21d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 30 Jul 2020 14:23:19 -0700
Received: by devvm1096.prn0.facebook.com (Postfix, from userid 111017)
        id 26E4120B00D2; Thu, 30 Jul 2020 14:23:13 -0700 (PDT)
Smtp-Origin-Hostprefix: devvm
From:   Roman Gushchin <guro@fb.com>
Smtp-Origin-Hostname: devvm1096.prn0.facebook.com
To:     <bpf@vger.kernel.org>
CC:     <netdev@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        <linux-kernel@vger.kernel.org>, Roman Gushchin <guro@fb.com>
Smtp-Origin-Cluster: prn0c01
Subject: [PATCH bpf-next v3 27/29] bpf: eliminate rlimit-based memory accounting infra for bpf maps
Date:   Thu, 30 Jul 2020 14:23:08 -0700
Message-ID: <20200730212310.2609108-28-guro@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200730212310.2609108-1-guro@fb.com>
References: <20200730212310.2609108-1-guro@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-30_15:2020-07-30,2020-07-30 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=999
 bulkscore=0 clxscore=1015 suspectscore=38 phishscore=0 malwarescore=0
 priorityscore=1501 adultscore=0 spamscore=0 impostorscore=0 mlxscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007300150
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove rlimit-based accounting infrastructure code, which is not used
anymore.

Signed-off-by: Roman Gushchin <guro@fb.com>
---
 include/linux/bpf.h                           | 12 ----
 kernel/bpf/syscall.c                          | 64 +------------------
 .../selftests/bpf/progs/map_ptr_kern.c        |  5 --
 3 files changed, 2 insertions(+), 79 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 40c5e206ecf2..25821dcf822a 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -112,11 +112,6 @@ struct bpf_map_ops {
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
@@ -137,7 +132,6 @@ struct bpf_map {
 	u32 btf_key_type_id;
 	u32 btf_value_type_id;
 	struct btf *btf;
-	struct bpf_map_memory memory;
 	char name[BPF_OBJ_NAME_LEN];
 	u32 btf_vmlinux_value_type_id;
 	bool bypass_spec_v1;
@@ -1143,12 +1137,6 @@ void bpf_map_inc_with_uref(struct bpf_map *map);
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
index a53e7aff3efc..a204a9e4a2cb 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -354,60 +354,6 @@ static void bpf_uncharge_memlock(struct user_struct =
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
@@ -456,13 +402,10 @@ void bpf_map_free_id(struct bpf_map *map, bool do_i=
dr_lock)
 static void bpf_map_free_deferred(struct work_struct *work)
 {
 	struct bpf_map *map =3D container_of(work, struct bpf_map, work);
-	struct bpf_map_memory mem;
=20
-	bpf_map_charge_move(&mem, &map->memory);
 	security_bpf_map_free(map);
 	/* implementation dependent freeing */
 	map->ops->map_free(map);
-	bpf_map_charge_finish(&mem);
 }
=20
 static void bpf_map_put_uref(struct bpf_map *map)
@@ -541,7 +484,7 @@ static void bpf_map_show_fdinfo(struct seq_file *m, s=
truct file *filp)
 		   "value_size:\t%u\n"
 		   "max_entries:\t%u\n"
 		   "map_flags:\t%#x\n"
-		   "memlock:\t%llu\n"
+		   "memlock:\t%llu\n" /* deprecated */
 		   "map_id:\t%u\n"
 		   "frozen:\t%u\n",
 		   map->map_type,
@@ -549,7 +492,7 @@ static void bpf_map_show_fdinfo(struct seq_file *m, s=
truct file *filp)
 		   map->value_size,
 		   map->max_entries,
 		   map->map_flags,
-		   map->memory.pages * 1ULL << PAGE_SHIFT,
+		   0LLU,
 		   map->id,
 		   READ_ONCE(map->frozen));
 	if (type) {
@@ -790,7 +733,6 @@ static int map_check_btf(struct bpf_map *map, const s=
truct btf *btf,
 static int map_create(union bpf_attr *attr)
 {
 	int numa_node =3D bpf_map_attr_numa_node(attr);
-	struct bpf_map_memory mem;
 	struct bpf_map *map;
 	int f_flags;
 	int err;
@@ -887,9 +829,7 @@ static int map_create(union bpf_attr *attr)
 	security_bpf_map_free(map);
 free_map:
 	btf_put(map->btf);
-	bpf_map_charge_move(&mem, &map->memory);
 	map->ops->map_free(map);
-	bpf_map_charge_finish(&mem);
 	return err;
 }
=20
diff --git a/tools/testing/selftests/bpf/progs/map_ptr_kern.c b/tools/tes=
ting/selftests/bpf/progs/map_ptr_kern.c
index 473665cac67e..49d1dcaf7999 100644
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
--=20
2.26.2

