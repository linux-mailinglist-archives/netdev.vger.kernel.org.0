Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1238B24D7DA
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 17:01:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728115AbgHUPBx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 11:01:53 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:30308 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728069AbgHUPBo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Aug 2020 11:01:44 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07LF1Xav013578
        for <netdev@vger.kernel.org>; Fri, 21 Aug 2020 08:01:44 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=Ul+xf1TI54FnPjFpxc3Ihst3TQMepDvmciNWWocFk1Q=;
 b=X9UBRfaZyQqWzJ9tvDuKhWjfiKeHCzV8LSU6YcfZQqOEyfgA1Iu7cmymBDHunq6oDngT
 qPnd/sfDuIbLthIrW0mC6czuKOVvFwjEXSqZpgBg2RnQBmb03ZZy/yusAU9zlsfskQmW
 qNbD42wqrAo7zWO0iiRwsRsLBllgeViIPPE= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 331d50t1dc-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 21 Aug 2020 08:01:44 -0700
Received: from intmgw004.06.prn3.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 21 Aug 2020 08:01:41 -0700
Received: by devvm1096.prn0.facebook.com (Postfix, from userid 111017)
        id 3163A344104B; Fri, 21 Aug 2020 08:01:35 -0700 (PDT)
Smtp-Origin-Hostprefix: devvm
From:   Roman Gushchin <guro@fb.com>
Smtp-Origin-Hostname: devvm1096.prn0.facebook.com
To:     <bpf@vger.kernel.org>
CC:     <netdev@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        <linux-kernel@vger.kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Shakeel Butt <shakeelb@google.com>, <linux-mm@kvack.org>,
        Roman Gushchin <guro@fb.com>
Smtp-Origin-Cluster: prn0c01
Subject: [PATCH bpf-next v4 03/30] bpf: memcg-based memory accounting for bpf maps
Date:   Fri, 21 Aug 2020 08:01:07 -0700
Message-ID: <20200821150134.2581465-4-guro@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200821150134.2581465-1-guro@fb.com>
References: <20200821150134.2581465-1-guro@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-21_08:2020-08-21,2020-08-21 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0
 malwarescore=0 mlxlogscore=999 priorityscore=1501 impostorscore=0
 clxscore=1015 phishscore=0 suspectscore=38 adultscore=0 bulkscore=0
 mlxscore=0 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2008210141
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch enables memcg-based memory accounting for memory allocated
by __bpf_map_area_alloc(), which is used by most map types for
large allocations.

If a map is updated from an interrupt context, and the update
results in memory allocation, the memory cgroup can't be determined
from the context of the current process. To address this case,
bpf map preserves a pointer to the memory cgroup of the process,
which created the map. This memory cgroup is charged for allocations
from interrupt context.

Following patches in the series will refine the accounting for
some map types.

Signed-off-by: Roman Gushchin <guro@fb.com>
---
 include/linux/bpf.h  |  4 ++++
 kernel/bpf/helpers.c | 37 ++++++++++++++++++++++++++++++++++++-
 kernel/bpf/syscall.c | 27 ++++++++++++++++++++++++++-
 3 files changed, 66 insertions(+), 2 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index a9b7185a6b37..b5f178afde94 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -34,6 +34,7 @@ struct btf_type;
 struct exception_table_entry;
 struct seq_operations;
 struct bpf_iter_aux_info;
+struct mem_cgroup;
=20
 extern struct idr btf_idr;
 extern spinlock_t btf_idr_lock;
@@ -138,6 +139,9 @@ struct bpf_map {
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
index be43ab3e619f..f8ce7bc7003f 100644
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
+		old_memcg =3D memalloc_use_memcg(map->memcg);
+
+	ret =3D map->ops->map_update_elem(map, key, value, flags);
+
+	if (in_interrupt)
+		memalloc_use_memcg(old_memcg);
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
index 689d736b6904..683614c17a95 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -29,6 +29,7 @@
 #include <linux/bpf_lsm.h>
 #include <linux/poll.h>
 #include <linux/bpf-netns.h>
+#include <linux/memcontrol.h>
=20
 #define IS_FD_ARRAY(map) ((map)->map_type =3D=3D BPF_MAP_TYPE_PERF_EVENT=
_ARRAY || \
 			  (map)->map_type =3D=3D BPF_MAP_TYPE_CGROUP_ARRAY || \
@@ -275,7 +276,7 @@ static void *__bpf_map_area_alloc(u64 size, int numa_=
node, bool mmapable)
 	 * __GFP_RETRY_MAYFAIL to avoid such situations.
 	 */
=20
-	const gfp_t gfp =3D __GFP_NOWARN | __GFP_ZERO;
+	const gfp_t gfp =3D __GFP_NOWARN | __GFP_ZERO | __GFP_ACCOUNT;
 	unsigned int flags =3D 0;
 	unsigned long align =3D 1;
 	void *area;
@@ -452,6 +453,27 @@ void bpf_map_free_id(struct bpf_map *map, bool do_id=
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
@@ -463,6 +485,7 @@ static void bpf_map_free_deferred(struct work_struct =
*work)
 	/* implementation dependent freeing */
 	map->ops->map_free(map);
 	bpf_map_charge_finish(&mem);
+	bpf_map_release_memcg(map);
 }
=20
 static void bpf_map_put_uref(struct bpf_map *map)
@@ -869,6 +892,8 @@ static int map_create(union bpf_attr *attr)
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

