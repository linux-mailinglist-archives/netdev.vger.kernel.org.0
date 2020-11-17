Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A4FB2B572B
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 03:56:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727199AbgKQCzr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 21:55:47 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:64324 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727096AbgKQCzp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 21:55:45 -0500
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AH2sDwF023481
        for <netdev@vger.kernel.org>; Mon, 16 Nov 2020 18:55:45 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=71ldEajIaYUv8dlOx85zNUyfx3l4oS87UVCe+qPnAkg=;
 b=K7uOkTYoD+rSdVxQx1QnpveoJVRXXh+U+pf3k+HG+/feBIQ3jx3jYBO9m1iE9RA3dIQy
 53LTpvAQhqeWoxw6GKL2PK1IacqDxiQzT5Kk9R7Derfm+qVrR14iL8XBGhiYnrHoR3hK
 YGm4yFjr64np8X8h8AppgiyjmD3gh2fEAZo= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 34uphj4xw3-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 16 Nov 2020 18:55:45 -0800
Received: from intmgw004.06.prn3.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 16 Nov 2020 18:55:42 -0800
Received: by devvm3388.prn0.facebook.com (Postfix, from userid 111017)
        id C58B9C5F7CA; Mon, 16 Nov 2020 18:55:33 -0800 (PST)
From:   Roman Gushchin <guro@fb.com>
To:     <bpf@vger.kernel.org>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <netdev@vger.kernel.org>,
        <andrii@kernel.org>, <akpm@linux-foundation.org>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <kernel-team@fb.com>
Subject: [PATCH v6 06/34] bpf: prepare for memcg-based memory accounting for bpf maps
Date:   Mon, 16 Nov 2020 18:55:01 -0800
Message-ID: <20201117025529.1034387-7-guro@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20201117025529.1034387-1-guro@fb.com>
References: <20201117025529.1034387-1-guro@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-16_13:2020-11-13,2020-11-16 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 impostorscore=0 bulkscore=0 mlxlogscore=999 priorityscore=1501
 malwarescore=0 clxscore=1015 suspectscore=38 adultscore=0 spamscore=0
 mlxscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011170023
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the absolute majority of cases if a process is making a kernel
allocation, it's memory cgroup is getting charged.

Bpf maps can be updated from an interrupt context and in such
case there is no process which can be charged. It makes the memory
accounting of bpf maps non-trivial.

Fortunately, after commit 4127c6504f25 ("mm: kmem: enable kernel
memcg accounting from interrupt contexts") and b87d8cefe43c
("mm, memcg: rework remote charging API to support nesting")
it's finally possible.

To do it, a pointer to the memory cgroup of the process which created
the map is saved, and this cgroup is getting charged for all
allocations made from an interrupt context.

Allocations made from a process context will be accounted in a usual way.

Signed-off-by: Roman Gushchin <guro@fb.com>
Acked-by: Song Liu <songliubraving@fb.com>
---
 include/linux/bpf.h  |  4 ++++
 kernel/bpf/helpers.c | 37 ++++++++++++++++++++++++++++++++++++-
 kernel/bpf/syscall.c | 25 +++++++++++++++++++++++++
 3 files changed, 65 insertions(+), 1 deletion(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 581b2a2e78eb..1d6e7b125877 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -37,6 +37,7 @@ struct bpf_iter_aux_info;
 struct bpf_local_storage;
 struct bpf_local_storage_map;
 struct kobject;
+struct mem_cgroup;
=20
 extern struct idr btf_idr;
 extern spinlock_t btf_idr_lock;
@@ -161,6 +162,9 @@ struct bpf_map {
 	u32 btf_value_type_id;
 	struct btf *btf;
 	struct bpf_map_memory memory;
+#ifdef CONFIG_MEMCG_KMEM
+	struct mem_cgroup *memcg;
+#endif
 	char name[BPF_OBJ_NAME_LEN];
 	u32 btf_vmlinux_value_type_id;
 	bool bypass_spec_v1;
diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index 25520f5eeaf6..b6327cbe7e41 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -14,6 +14,7 @@
 #include <linux/jiffies.h>
 #include <linux/pid_namespace.h>
 #include <linux/proc_ns.h>
+#include <linux/sched/mm.h>
=20
 #include "../../lib/kstrtox.h"
=20
@@ -41,11 +42,45 @@ const struct bpf_func_proto bpf_map_lookup_elem_proto=
 =3D {
 	.arg2_type	=3D ARG_PTR_TO_MAP_KEY,
 };
=20
+#ifdef CONFIG_MEMCG_KMEM
+static __always_inline int __bpf_map_update_elem(struct bpf_map *map, vo=
id *key,
+						 void *value, u64 flags)
+{
+	struct mem_cgroup *old_memcg;
+	bool in_interrupt;
+	int ret;
+
+	/*
+	 * If update from an interrupt context results in a memory allocation,
+	 * the memory cgroup to charge can't be determined from the context
+	 * of the current task. Instead, we charge the memory cgroup, which
+	 * contained a process created the map.
+	 */
+	in_interrupt =3D in_interrupt();
+	if (in_interrupt)
+		old_memcg =3D set_active_memcg(map->memcg);
+
+	ret =3D map->ops->map_update_elem(map, key, value, flags);
+
+	if (in_interrupt)
+		set_active_memcg(old_memcg);
+
+	return ret;
+}
+#else
+static __always_inline int __bpf_map_update_elem(struct bpf_map *map, vo=
id *key,
+						 void *value, u64 flags)
+{
+	return map->ops->map_update_elem(map, key, value, flags);
+}
+#endif
+
 BPF_CALL_4(bpf_map_update_elem, struct bpf_map *, map, void *, key,
 	   void *, value, u64, flags)
 {
 	WARN_ON_ONCE(!rcu_read_lock_held());
-	return map->ops->map_update_elem(map, key, value, flags);
+
+	return __bpf_map_update_elem(map, key, value, flags);
 }
=20
 const struct bpf_func_proto bpf_map_update_elem_proto =3D {
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index f3fe9f53f93c..2d77fc2496da 100644
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
@@ -456,6 +457,27 @@ void bpf_map_free_id(struct bpf_map *map, bool do_id=
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
@@ -464,6 +486,7 @@ static void bpf_map_free_deferred(struct work_struct =
*work)
=20
 	bpf_map_charge_move(&mem, &map->memory);
 	security_bpf_map_free(map);
+	bpf_map_release_memcg(map);
 	/* implementation dependent freeing */
 	map->ops->map_free(map);
 	bpf_map_charge_finish(&mem);
@@ -875,6 +898,8 @@ static int map_create(union bpf_attr *attr)
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

