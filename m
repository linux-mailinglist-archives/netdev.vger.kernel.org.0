Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 940D22C3746
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 04:12:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728163AbgKYDC3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 22:02:29 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:64658 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727513AbgKYDBf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Nov 2020 22:01:35 -0500
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AP2skwt014300
        for <netdev@vger.kernel.org>; Tue, 24 Nov 2020 19:01:33 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=gb0DJ6Ifm1SkMikLhD0FNYIqufSNvigQjuDblqWn/7M=;
 b=fUVvfnU4UgtpUF2hK6ke8idJRN8AFmHJuEijWZNBNj5iEDCJidfr0wFTmgOFbFO5MqQI
 ME6ICx0Y+XbV0K0aTellbuwvpY8uA35px8DRFDLbjOeLfMpd5DLoBDV+lT0yi1U73dMT
 MjiSt8CC7HeJfuR0kBuqijibHJMSoXypaqs= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 34ykxgmjxs-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 24 Nov 2020 19:01:33 -0800
Received: from intmgw001.06.prn3.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 24 Nov 2020 19:01:32 -0800
Received: by devvm3388.prn0.facebook.com (Postfix, from userid 111017)
        id 02E2D16A188D; Tue, 24 Nov 2020 19:01:22 -0800 (PST)
From:   Roman Gushchin <guro@fb.com>
To:     <bpf@vger.kernel.org>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <netdev@vger.kernel.org>,
        <andrii@kernel.org>, <akpm@linux-foundation.org>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <kernel-team@fb.com>
Subject: [PATCH bpf-next v8 06/34] bpf: prepare for memcg-based memory accounting for bpf maps
Date:   Tue, 24 Nov 2020 19:00:51 -0800
Message-ID: <20201125030119.2864302-7-guro@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20201125030119.2864302-1-guro@fb.com>
References: <20201125030119.2864302-1-guro@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-24_11:2020-11-24,2020-11-24 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0
 lowpriorityscore=0 suspectscore=38 mlxlogscore=999 priorityscore=1501
 spamscore=0 impostorscore=0 bulkscore=0 malwarescore=0 mlxscore=0
 phishscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011250018
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

To do it, a pointer to the memory cgroup of the process, which created
the map, is saved, and this cgroup can be charged for all allocations
made from an interrupt context. This commit introduces 2 helpers:
bpf_map_kmalloc_node() and bpf_map_alloc_percpu(). They can be used in
the bpf code for accounted memory allocations, both in the process and
interrupt contexts. In the interrupt context they're using the saved
memory cgroup, otherwise the current cgroup is getting charged.

Signed-off-by: Roman Gushchin <guro@fb.com>
---
 include/linux/bpf.h  | 26 +++++++++++++++
 kernel/bpf/syscall.c | 76 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 102 insertions(+)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index e1bcb6d7345c..b11436cb9e3d 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -20,6 +20,7 @@
 #include <linux/module.h>
 #include <linux/kallsyms.h>
 #include <linux/capability.h>
+#include <linux/slab.h>
=20
 struct bpf_verifier_env;
 struct bpf_verifier_log;
@@ -37,6 +38,7 @@ struct bpf_iter_aux_info;
 struct bpf_local_storage;
 struct bpf_local_storage_map;
 struct kobject;
+struct mem_cgroup;
=20
 extern struct idr btf_idr;
 extern spinlock_t btf_idr_lock;
@@ -161,6 +163,9 @@ struct bpf_map {
 	u32 btf_value_type_id;
 	struct btf *btf;
 	struct bpf_map_memory memory;
+#ifdef CONFIG_MEMCG_KMEM
+	struct mem_cgroup *memcg;
+#endif
 	char name[BPF_OBJ_NAME_LEN];
 	u32 btf_vmlinux_value_type_id;
 	bool bypass_spec_v1;
@@ -1240,6 +1245,27 @@ int  generic_map_delete_batch(struct bpf_map *map,
 struct bpf_map *bpf_map_get_curr_or_next(u32 *id);
 struct bpf_prog *bpf_prog_get_curr_or_next(u32 *id);
=20
+#ifdef CONFIG_MEMCG_KMEM
+void *bpf_map_kmalloc_node(const struct bpf_map *map, size_t size, gfp_t=
 flags,
+			   int node);
+void __percpu *bpf_map_alloc_percpu(const struct bpf_map *map, size_t si=
ze,
+				    size_t align, gfp_t gfp);
+#else
+static inline void *
+bpf_map_kmalloc_node(const struct bpf_map *map, size_t size, gfp_t flags=
,
+		     int node)
+{
+	return kmalloc_node(size, flags, node);
+}
+
+static inline void __percpu *
+bpf_map_alloc_percpu(const struct bpf_map *map, size_t size, size_t alig=
n,
+		     gfp_t gfp)
+{
+	return __alloc_percpu_gfp(size, align, gfp);
+}
+#endif
+
 extern int sysctl_unprivileged_bpf_disabled;
=20
 static inline bool bpf_allow_ptr_leaks(void)
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index f3fe9f53f93c..4154c616788c 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -31,6 +31,8 @@
 #include <linux/poll.h>
 #include <linux/bpf-netns.h>
 #include <linux/rcupdate_trace.h>
+#include <linux/memcontrol.h>
+#include <linux/sched/mm.h>
=20
 #define IS_FD_ARRAY(map) ((map)->map_type =3D=3D BPF_MAP_TYPE_PERF_EVENT=
_ARRAY || \
 			  (map)->map_type =3D=3D BPF_MAP_TYPE_CGROUP_ARRAY || \
@@ -456,6 +458,77 @@ void bpf_map_free_id(struct bpf_map *map, bool do_id=
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
+	bool in_interrupt;
+	void *ptr;
+
+	/*
+	 * If the memory allocation is performed from an interrupt context,
+	 * the memory cgroup to charge can't be determined from the context
+	 * of the current task. Instead, we charge the memory cgroup, which
+	 * contained the process created the map.
+	 */
+	in_interrupt =3D in_interrupt();
+	if (in_interrupt)
+		old_memcg =3D set_active_memcg(map->memcg);
+
+	ptr =3D kmalloc_node(size, flags, node);
+
+	if (in_interrupt)
+		set_active_memcg(old_memcg);
+
+	return ptr;
+}
+
+void __percpu *bpf_map_alloc_percpu(const struct bpf_map *map, size_t si=
ze,
+				    size_t align, gfp_t gfp)
+{
+	struct mem_cgroup *old_memcg;
+	bool in_interrupt;
+	void *ptr;
+
+	/*
+	 * If the memory allocation is performed from an interrupt context,
+	 * the memory cgroup to charge can't be determined from the context
+	 * of the current task. Instead, we charge the memory cgroup, which
+	 * contained the process created the map.
+	 */
+	in_interrupt =3D in_interrupt();
+	if (in_interrupt)
+		old_memcg =3D set_active_memcg(map->memcg);
+
+	ptr =3D __alloc_percpu_gfp(size, align, gfp);
+
+	if (in_interrupt)
+		set_active_memcg(old_memcg);
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
@@ -464,6 +537,7 @@ static void bpf_map_free_deferred(struct work_struct =
*work)
=20
 	bpf_map_charge_move(&mem, &map->memory);
 	security_bpf_map_free(map);
+	bpf_map_release_memcg(map);
 	/* implementation dependent freeing */
 	map->ops->map_free(map);
 	bpf_map_charge_finish(&mem);
@@ -875,6 +949,8 @@ static int map_create(union bpf_attr *attr)
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

