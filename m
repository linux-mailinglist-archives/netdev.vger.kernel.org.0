Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C0262CAF84
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 23:02:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726410AbgLAWB1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 17:01:27 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:22468 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390503AbgLAV76 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Dec 2020 16:59:58 -0500
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B1Lmm1T007480
        for <netdev@vger.kernel.org>; Tue, 1 Dec 2020 13:59:17 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=X6t81WEKJObUiIPPIr/tVF63ksn+2IHyyvPJDgAFLNc=;
 b=jjZQpYxPxav1zbqobKdSQ2u0eSIp8fTY2OSBErnIPllxEEjF8Ranu24TMUqtNmYjLexd
 SfJ4vcIxYV3h42gqkp2Kpwx1shedZ0K6B6jISEyJ0XvjPb81OyRYrY9UlcYIBfHvTYQJ
 t7TuS0A/WAiZMVBaf2noyZTu8F2xWiylM8w= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3547psq7s8-19
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 01 Dec 2020 13:59:17 -0800
Received: from intmgw001.41.prn1.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:11d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 1 Dec 2020 13:59:11 -0800
Received: by devvm3388.prn0.facebook.com (Postfix, from userid 111017)
        id 58AA119702AA; Tue,  1 Dec 2020 13:59:06 -0800 (PST)
From:   Roman Gushchin <guro@fb.com>
To:     <bpf@vger.kernel.org>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <netdev@vger.kernel.org>,
        <andrii@kernel.org>, <akpm@linux-foundation.org>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <kernel-team@fb.com>
Subject: [PATCH bpf-next v9 06/34] bpf: prepare for memcg-based memory accounting for bpf maps
Date:   Tue, 1 Dec 2020 13:58:32 -0800
Message-ID: <20201201215900.3569844-7-guro@fb.com>
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

Bpf maps can be updated from an interrupt context and in such
case there is no process which can be charged. It makes the memory
accounting of bpf maps non-trivial.

Fortunately, after commit 4127c6504f25 ("mm: kmem: enable kernel
memcg accounting from interrupt contexts") and commit b87d8cefe43c
("mm, memcg: rework remote charging API to support nesting")
it's finally possible.

To make the ownership model simple and consistent, when the map
is created, the memory cgroup of the current process is recorded.
All subsequent allocations related to the bpf map are charged to
the same memory cgroup. It includes allocations made by any processes
(even if they do belong to a different cgroup) and from interrupts.

This commit introduces 3 new helpers, which will be used by following
commits to enable the accounting of bpf maps memory:
  - bpf_map_kmalloc_node()
  - bpf_map_kzalloc()
  - bpf_map_alloc_percpu()

They are wrapping popular memory allocation functions. They set
the active memory cgroup to the map's memory cgroup and add
__GFP_ACCOUNT to the passed gfp flags. Then they call into
the corresponding memory allocation function and restore
the original active memory cgroup.

These helpers are supposed to use everywhere except the map creation
path. During the map creation when the map structure is allocated by
itself, it cannot be passed to those helpers. In those cases default
memory allocation function will be used with the __GFP_ACCOUNT flag.

Signed-off-by: Roman Gushchin <guro@fb.com>
---
 include/linux/bpf.h  | 34 ++++++++++++++++++++++++
 kernel/bpf/syscall.c | 63 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 97 insertions(+)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index e1bcb6d7345c..e1f2c95c15ec 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -20,6 +20,8 @@
 #include <linux/module.h>
 #include <linux/kallsyms.h>
 #include <linux/capability.h>
+#include <linux/sched/mm.h>
+#include <linux/slab.h>
=20
 struct bpf_verifier_env;
 struct bpf_verifier_log;
@@ -37,6 +39,7 @@ struct bpf_iter_aux_info;
 struct bpf_local_storage;
 struct bpf_local_storage_map;
 struct kobject;
+struct mem_cgroup;
=20
 extern struct idr btf_idr;
 extern spinlock_t btf_idr_lock;
@@ -161,6 +164,9 @@ struct bpf_map {
 	u32 btf_value_type_id;
 	struct btf *btf;
 	struct bpf_map_memory memory;
+#ifdef CONFIG_MEMCG_KMEM
+	struct mem_cgroup *memcg;
+#endif
 	char name[BPF_OBJ_NAME_LEN];
 	u32 btf_vmlinux_value_type_id;
 	bool bypass_spec_v1;
@@ -1240,6 +1246,34 @@ int  generic_map_delete_batch(struct bpf_map *map,
 struct bpf_map *bpf_map_get_curr_or_next(u32 *id);
 struct bpf_prog *bpf_prog_get_curr_or_next(u32 *id);
=20
+#ifdef CONFIG_MEMCG_KMEM
+void *bpf_map_kmalloc_node(const struct bpf_map *map, size_t size, gfp_t=
 flags,
+			   int node);
+void *bpf_map_kzalloc(const struct bpf_map *map, size_t size, gfp_t flag=
s);
+void __percpu *bpf_map_alloc_percpu(const struct bpf_map *map, size_t si=
ze,
+				    size_t align, gfp_t flags);
+#else
+static inline void *
+bpf_map_kmalloc_node(const struct bpf_map *map, size_t size, gfp_t flags=
,
+		     int node)
+{
+	return kmalloc_node(size, flags, node);
+}
+
+static inline void *
+bpf_map_kzalloc(const struct bpf_map *map, size_t size, gfp_t flags)
+{
+	return kzalloc(size, flags);
+}
+
+static inline void __percpu *
+bpf_map_alloc_percpu(const struct bpf_map *map, size_t size, size_t alig=
n,
+		     gfp_t flags)
+{
+	return __alloc_percpu_gfp(size, align, flags);
+}
+#endif
+
 extern int sysctl_unprivileged_bpf_disabled;
=20
 static inline bool bpf_allow_ptr_leaks(void)
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index f3fe9f53f93c..dedbf6d4cd84 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -31,6 +31,7 @@
 #include <linux/poll.h>
 #include <linux/bpf-netns.h>
 #include <linux/rcupdate_trace.h>
+#include <linux/memcontrol.h>
=20
 #define IS_FD_ARRAY(map) ((map)->map_type =3D=3D BPF_MAP_TYPE_PERF_EVENT=
_ARRAY || \
 			  (map)->map_type =3D=3D BPF_MAP_TYPE_CGROUP_ARRAY || \
@@ -456,6 +457,65 @@ void bpf_map_free_id(struct bpf_map *map, bool do_id=
r_lock)
 		__release(&map_idr_lock);
 }
=20
+#ifdef CONFIG_MEMCG_KMEM
+static void bpf_map_save_memcg(struct bpf_map *map)
+{
+	map->memcg =3D get_mem_cgroup_from_mm(current->mm);
+}
+
+static void bpf_map_release_memcg(struct bpf_map *map)
+{
+	mem_cgroup_put(map->memcg);
+}
+
+void *bpf_map_kmalloc_node(const struct bpf_map *map, size_t size, gfp_t=
 flags,
+			   int node)
+{
+	struct mem_cgroup *old_memcg;
+	void *ptr;
+
+	old_memcg =3D set_active_memcg(map->memcg);
+	ptr =3D kmalloc_node(size, flags | __GFP_ACCOUNT, node);
+	set_active_memcg(old_memcg);
+
+	return ptr;
+}
+
+void *bpf_map_kzalloc(const struct bpf_map *map, size_t size, gfp_t flag=
s)
+{
+	struct mem_cgroup *old_memcg;
+	void *ptr;
+
+	old_memcg =3D set_active_memcg(map->memcg);
+	ptr =3D kzalloc(size, flags | __GFP_ACCOUNT);
+	set_active_memcg(old_memcg);
+
+	return ptr;
+}
+
+void __percpu *bpf_map_alloc_percpu(const struct bpf_map *map, size_t si=
ze,
+				    size_t align, gfp_t flags)
+{
+	struct mem_cgroup *old_memcg;
+	void __percpu *ptr;
+
+	old_memcg =3D set_active_memcg(map->memcg);
+	ptr =3D __alloc_percpu_gfp(size, align, flags | __GFP_ACCOUNT);
+	set_active_memcg(old_memcg);
+
+	return ptr;
+}
+
+#else
+static void bpf_map_save_memcg(struct bpf_map *map)
+{
+}
+
+static void bpf_map_release_memcg(struct bpf_map *map)
+{
+}
+#endif
+
 /* called from workqueue */
 static void bpf_map_free_deferred(struct work_struct *work)
 {
@@ -464,6 +524,7 @@ static void bpf_map_free_deferred(struct work_struct =
*work)
=20
 	bpf_map_charge_move(&mem, &map->memory);
 	security_bpf_map_free(map);
+	bpf_map_release_memcg(map);
 	/* implementation dependent freeing */
 	map->ops->map_free(map);
 	bpf_map_charge_finish(&mem);
@@ -875,6 +936,8 @@ static int map_create(union bpf_attr *attr)
 	if (err)
 		goto free_map_sec;
=20
+	bpf_map_save_memcg(map);
+
 	err =3D bpf_map_new_fd(map, f_flags);
 	if (err < 0) {
 		/* failed to allocate fd.
--=20
2.26.2

