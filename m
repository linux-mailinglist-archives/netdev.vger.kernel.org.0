Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73CFE1DD6FC
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 21:18:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729615AbgEUTSF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 15:18:05 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:22078 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729635AbgEUTSE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 15:18:04 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04LJD59G012778
        for <netdev@vger.kernel.org>; Thu, 21 May 2020 12:18:03 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=cXe2f59rExp3hHodRaQ5LlGiQ51cnW0jOl4IYSQrfH4=;
 b=G/3hhvEewd1XBVo97nbd7Jz0IY86cjwZt1BY6regdDICatTftLV0fUSoHvsSYGUvqapI
 QPbGItQ1UlkQmGOo0FDNLvC3p8Yvwy8lysvfIyQT4De8ka0LRw1PbA2EQg8f3gA6Niy+
 1BVomrdCKkJMqLwyMV1KxR06LTZtEJJKRGU= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 314jubhr8c-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 21 May 2020 12:18:03 -0700
Received: from intmgw003.03.ash8.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:11d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 21 May 2020 12:18:02 -0700
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id 755B32942F51; Thu, 21 May 2020 12:17:58 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Martin KaFai Lau <kafai@fb.com>
Smtp-Origin-Hostname: devbig005.ftw2.facebook.com
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        <netdev@vger.kernel.org>, Andrey Ignatov <rdna@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 1/3] bpf: Clean up inner map type check
Date:   Thu, 21 May 2020 12:17:58 -0700
Message-ID: <20200521191758.3448793-1-kafai@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200521191752.3448223-1-kafai@fb.com>
References: <20200521191752.3448223-1-kafai@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-21_13:2020-05-21,2020-05-21 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 lowpriorityscore=0 malwarescore=0 mlxscore=0 spamscore=0
 cotscore=-2147483648 mlxlogscore=999 clxscore=1015 bulkscore=0
 adultscore=0 impostorscore=0 suspectscore=13 phishscore=0 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005210140
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds a "capability" member to "struct bpf_map".  Each map-type=
's
capability is tagged in the "BPF_MAP_TYPE" in bpf_types.h.  This will
clean up the individual check in bpf_map_meta_alloc() which decides
if a map can be used as an inner map.

It will be less error prone to decide its capability at the same place
as the new map type is added in bpf_types.h.  That will help to avoid
mistake like missing modification in other source files like
the map_in_map.c here.

Cc: Andrey Ignatov <rdna@fb.com>
Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 include/linux/bpf.h       |  6 +++-
 include/linux/bpf_types.h | 62 ++++++++++++++++++++++-----------------
 kernel/bpf/btf.c          |  2 +-
 kernel/bpf/map_in_map.c   |  9 ++----
 kernel/bpf/syscall.c      | 19 ++++++++++--
 kernel/bpf/verifier.c     |  2 +-
 6 files changed, 60 insertions(+), 40 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index efe8836b5c48..1e20b9911d48 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -97,6 +97,9 @@ struct bpf_map_memory {
 	struct user_struct *user;
 };
=20
+/* Cannot be used as an inner map */
+#define BPF_MAP_CAP_NO_INNER_MAP (1 << 0)
+
 struct bpf_map {
 	/* The first two cachelines with read-mostly members of which some
 	 * are also accessed in fast-path (e.g. ops, max_entries).
@@ -120,6 +123,7 @@ struct bpf_map {
 	struct bpf_map_memory memory;
 	char name[BPF_OBJ_NAME_LEN];
 	u32 btf_vmlinux_value_type_id;
+	u32 capability;
 	bool bypass_spec_v1;
 	bool frozen; /* write-once; write-protected by freeze_mutex */
 	/* 22 bytes hole */
@@ -1037,7 +1041,7 @@ extern const struct file_operations bpf_iter_fops;
 #define BPF_PROG_TYPE(_id, _name, prog_ctx_type, kern_ctx_type) \
 	extern const struct bpf_prog_ops _name ## _prog_ops; \
 	extern const struct bpf_verifier_ops _name ## _verifier_ops;
-#define BPF_MAP_TYPE(_id, _ops) \
+#define BPF_MAP_TYPE(_id, _ops, map_cap) \
 	extern const struct bpf_map_ops _ops;
 #define BPF_LINK_TYPE(_id, _name)
 #include <linux/bpf_types.h>
diff --git a/include/linux/bpf_types.h b/include/linux/bpf_types.h
index 29d22752fc87..652f17d646dd 100644
--- a/include/linux/bpf_types.h
+++ b/include/linux/bpf_types.h
@@ -76,47 +76,55 @@ BPF_PROG_TYPE(BPF_PROG_TYPE_LSM, lsm,
 #endif /* CONFIG_BPF_LSM */
 #endif
=20
-BPF_MAP_TYPE(BPF_MAP_TYPE_ARRAY, array_map_ops)
-BPF_MAP_TYPE(BPF_MAP_TYPE_PERCPU_ARRAY, percpu_array_map_ops)
-BPF_MAP_TYPE(BPF_MAP_TYPE_PROG_ARRAY, prog_array_map_ops)
-BPF_MAP_TYPE(BPF_MAP_TYPE_PERF_EVENT_ARRAY, perf_event_array_map_ops)
+BPF_MAP_TYPE(BPF_MAP_TYPE_ARRAY, array_map_ops, 0)
+BPF_MAP_TYPE(BPF_MAP_TYPE_PERCPU_ARRAY, percpu_array_map_ops, 0)
+/* prog_array->aux->{type,jited} is a runtime binding.
+ * Doing static check alone in the verifier is not enough,
+ * so BPF_MAP_CAP_NO_INNTER_MAP is needed.
+ */
+BPF_MAP_TYPE(BPF_MAP_TYPE_PROG_ARRAY, prog_array_map_ops,
+	     BPF_MAP_CAP_NO_INNER_MAP)
+BPF_MAP_TYPE(BPF_MAP_TYPE_PERF_EVENT_ARRAY, perf_event_array_map_ops, 0)
 #ifdef CONFIG_CGROUPS
-BPF_MAP_TYPE(BPF_MAP_TYPE_CGROUP_ARRAY, cgroup_array_map_ops)
+BPF_MAP_TYPE(BPF_MAP_TYPE_CGROUP_ARRAY, cgroup_array_map_ops, 0)
 #endif
 #ifdef CONFIG_CGROUP_BPF
-BPF_MAP_TYPE(BPF_MAP_TYPE_CGROUP_STORAGE, cgroup_storage_map_ops)
-BPF_MAP_TYPE(BPF_MAP_TYPE_PERCPU_CGROUP_STORAGE, cgroup_storage_map_ops)
-#endif
-BPF_MAP_TYPE(BPF_MAP_TYPE_HASH, htab_map_ops)
-BPF_MAP_TYPE(BPF_MAP_TYPE_PERCPU_HASH, htab_percpu_map_ops)
-BPF_MAP_TYPE(BPF_MAP_TYPE_LRU_HASH, htab_lru_map_ops)
-BPF_MAP_TYPE(BPF_MAP_TYPE_LRU_PERCPU_HASH, htab_lru_percpu_map_ops)
-BPF_MAP_TYPE(BPF_MAP_TYPE_LPM_TRIE, trie_map_ops)
+BPF_MAP_TYPE(BPF_MAP_TYPE_CGROUP_STORAGE, cgroup_storage_map_ops,
+	     BPF_MAP_CAP_NO_INNER_MAP)
+BPF_MAP_TYPE(BPF_MAP_TYPE_PERCPU_CGROUP_STORAGE, cgroup_storage_map_ops,
+	     BPF_MAP_CAP_NO_INNER_MAP)
+#endif
+BPF_MAP_TYPE(BPF_MAP_TYPE_HASH, htab_map_ops, 0)
+BPF_MAP_TYPE(BPF_MAP_TYPE_PERCPU_HASH, htab_percpu_map_ops, 0)
+BPF_MAP_TYPE(BPF_MAP_TYPE_LRU_HASH, htab_lru_map_ops, 0)
+BPF_MAP_TYPE(BPF_MAP_TYPE_LRU_PERCPU_HASH, htab_lru_percpu_map_ops, 0)
+BPF_MAP_TYPE(BPF_MAP_TYPE_LPM_TRIE, trie_map_ops, 0)
 #ifdef CONFIG_PERF_EVENTS
-BPF_MAP_TYPE(BPF_MAP_TYPE_STACK_TRACE, stack_trace_map_ops)
+BPF_MAP_TYPE(BPF_MAP_TYPE_STACK_TRACE, stack_trace_map_ops, 0)
 #endif
-BPF_MAP_TYPE(BPF_MAP_TYPE_ARRAY_OF_MAPS, array_of_maps_map_ops)
-BPF_MAP_TYPE(BPF_MAP_TYPE_HASH_OF_MAPS, htab_of_maps_map_ops)
+BPF_MAP_TYPE(BPF_MAP_TYPE_ARRAY_OF_MAPS, array_of_maps_map_ops, 0)
+BPF_MAP_TYPE(BPF_MAP_TYPE_HASH_OF_MAPS, htab_of_maps_map_ops, 0)
 #ifdef CONFIG_NET
-BPF_MAP_TYPE(BPF_MAP_TYPE_DEVMAP, dev_map_ops)
-BPF_MAP_TYPE(BPF_MAP_TYPE_DEVMAP_HASH, dev_map_hash_ops)
-BPF_MAP_TYPE(BPF_MAP_TYPE_SK_STORAGE, sk_storage_map_ops)
+BPF_MAP_TYPE(BPF_MAP_TYPE_DEVMAP, dev_map_ops, 0)
+BPF_MAP_TYPE(BPF_MAP_TYPE_DEVMAP_HASH, dev_map_hash_ops, 0)
+BPF_MAP_TYPE(BPF_MAP_TYPE_SK_STORAGE, sk_storage_map_ops, 0)
 #if defined(CONFIG_BPF_STREAM_PARSER)
-BPF_MAP_TYPE(BPF_MAP_TYPE_SOCKMAP, sock_map_ops)
-BPF_MAP_TYPE(BPF_MAP_TYPE_SOCKHASH, sock_hash_ops)
+BPF_MAP_TYPE(BPF_MAP_TYPE_SOCKMAP, sock_map_ops, 0)
+BPF_MAP_TYPE(BPF_MAP_TYPE_SOCKHASH, sock_hash_ops, 0)
 #endif
-BPF_MAP_TYPE(BPF_MAP_TYPE_CPUMAP, cpu_map_ops)
+BPF_MAP_TYPE(BPF_MAP_TYPE_CPUMAP, cpu_map_ops, 0)
 #if defined(CONFIG_XDP_SOCKETS)
-BPF_MAP_TYPE(BPF_MAP_TYPE_XSKMAP, xsk_map_ops)
+BPF_MAP_TYPE(BPF_MAP_TYPE_XSKMAP, xsk_map_ops, 0)
 #endif
 #ifdef CONFIG_INET
-BPF_MAP_TYPE(BPF_MAP_TYPE_REUSEPORT_SOCKARRAY, reuseport_array_ops)
+BPF_MAP_TYPE(BPF_MAP_TYPE_REUSEPORT_SOCKARRAY, reuseport_array_ops, 0)
 #endif
 #endif
-BPF_MAP_TYPE(BPF_MAP_TYPE_QUEUE, queue_map_ops)
-BPF_MAP_TYPE(BPF_MAP_TYPE_STACK, stack_map_ops)
+BPF_MAP_TYPE(BPF_MAP_TYPE_QUEUE, queue_map_ops, 0)
+BPF_MAP_TYPE(BPF_MAP_TYPE_STACK, stack_map_ops, 0)
 #if defined(CONFIG_BPF_JIT)
-BPF_MAP_TYPE(BPF_MAP_TYPE_STRUCT_OPS, bpf_struct_ops_map_ops)
+BPF_MAP_TYPE(BPF_MAP_TYPE_STRUCT_OPS, bpf_struct_ops_map_ops,
+	     BPF_MAP_CAP_NO_INNER_MAP)
 #endif
=20
 BPF_LINK_TYPE(BPF_LINK_TYPE_RAW_TRACEPOINT, raw_tracepoint)
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 58c9af1d4808..6b74ab8f8530 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -3481,7 +3481,7 @@ extern char __weak __start_BTF[];
 extern char __weak __stop_BTF[];
 extern struct btf *btf_vmlinux;
=20
-#define BPF_MAP_TYPE(_id, _ops)
+#define BPF_MAP_TYPE(_id, _ops, map_cap)
 #define BPF_LINK_TYPE(_id, _name)
 static union {
 	struct bpf_ctx_convert {
diff --git a/kernel/bpf/map_in_map.c b/kernel/bpf/map_in_map.c
index 17738c93bec8..6e1286ad7b76 100644
--- a/kernel/bpf/map_in_map.c
+++ b/kernel/bpf/map_in_map.c
@@ -17,13 +17,7 @@ struct bpf_map *bpf_map_meta_alloc(int inner_map_ufd)
 	if (IS_ERR(inner_map))
 		return inner_map;
=20
-	/* prog_array->aux->{type,jited} is a runtime binding.
-	 * Doing static check alone in the verifier is not enough.
-	 */
-	if (inner_map->map_type =3D=3D BPF_MAP_TYPE_PROG_ARRAY ||
-	    inner_map->map_type =3D=3D BPF_MAP_TYPE_CGROUP_STORAGE ||
-	    inner_map->map_type =3D=3D BPF_MAP_TYPE_PERCPU_CGROUP_STORAGE ||
-	    inner_map->map_type =3D=3D BPF_MAP_TYPE_STRUCT_OPS) {
+	if (inner_map->capability & BPF_MAP_CAP_NO_INNER_MAP) {
 		fdput(f);
 		return ERR_PTR(-ENOTSUPP);
 	}
@@ -56,6 +50,7 @@ struct bpf_map *bpf_map_meta_alloc(int inner_map_ufd)
 	inner_map_meta->map_flags =3D inner_map->map_flags;
 	inner_map_meta->max_entries =3D inner_map->max_entries;
 	inner_map_meta->spin_lock_off =3D inner_map->spin_lock_off;
+	inner_map_meta->capability =3D inner_map->capability;
=20
 	/* Misc members not needed in bpf_map_meta_equal() check. */
 	inner_map_meta->ops =3D inner_map->ops;
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 431241c74614..f93a96b8d440 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -49,7 +49,7 @@ int sysctl_unprivileged_bpf_disabled __read_mostly;
=20
 static const struct bpf_map_ops * const bpf_map_types[] =3D {
 #define BPF_PROG_TYPE(_id, _name, prog_ctx_type, kern_ctx_type)
-#define BPF_MAP_TYPE(_id, _ops) \
+#define BPF_MAP_TYPE(_id, _ops, map_cap) \
 	[_id] =3D &_ops,
 #define BPF_LINK_TYPE(_id, _name)
 #include <linux/bpf_types.h>
@@ -58,6 +58,17 @@ static const struct bpf_map_ops * const bpf_map_types[=
] =3D {
 #undef BPF_LINK_TYPE
 };
=20
+static const u32 bpf_map_caps[] =3D {
+#define BPF_PROG_TYPE(_id, _name, prog_ctx_type, kern_ctx_type)
+#define BPF_MAP_TYPE(_id, _ops, map_cap) \
+	[_id] =3D map_cap,
+#define BPF_LINK_TYPE(_id, _name)
+#include <linux/bpf_types.h>
+#undef BPF_PROG_TYPE
+#undef BPF_MAP_TYPE
+#undef BPF_LINK_TYPE
+};
+
 /*
  * If we're handed a bigger struct than we know of, ensure all the unkno=
wn bits
  * are 0 - i.e. new user-space does not rely on any kernel feature exten=
sions
@@ -131,6 +142,8 @@ static struct bpf_map *find_and_alloc_map(union bpf_a=
ttr *attr)
 		return map;
 	map->ops =3D ops;
 	map->map_type =3D type;
+	map->capability =3D bpf_map_caps[type];
+
 	return map;
 }
=20
@@ -1551,7 +1564,7 @@ static int map_freeze(const union bpf_attr *attr)
 static const struct bpf_prog_ops * const bpf_prog_types[] =3D {
 #define BPF_PROG_TYPE(_id, _name, prog_ctx_type, kern_ctx_type) \
 	[_id] =3D & _name ## _prog_ops,
-#define BPF_MAP_TYPE(_id, _ops)
+#define BPF_MAP_TYPE(_id, _ops, map_cap)
 #define BPF_LINK_TYPE(_id, _name)
 #include <linux/bpf_types.h>
 #undef BPF_PROG_TYPE
@@ -2333,7 +2346,7 @@ static int bpf_link_release(struct inode *inode, st=
ruct file *filp)
=20
 #ifdef CONFIG_PROC_FS
 #define BPF_PROG_TYPE(_id, _name, prog_ctx_type, kern_ctx_type)
-#define BPF_MAP_TYPE(_id, _ops)
+#define BPF_MAP_TYPE(_id, _ops, map_cap)
 #define BPF_LINK_TYPE(_id, _name) [_id] =3D #_name,
 static const char *bpf_link_type_strs[] =3D {
 	[BPF_LINK_TYPE_UNSPEC] =3D "<invalid>",
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 2ed8351f47a4..5f3b97d25c4e 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -27,7 +27,7 @@
 static const struct bpf_verifier_ops * const bpf_verifier_ops[] =3D {
 #define BPF_PROG_TYPE(_id, _name, prog_ctx_type, kern_ctx_type) \
 	[_id] =3D & _name ## _verifier_ops,
-#define BPF_MAP_TYPE(_id, _ops)
+#define BPF_MAP_TYPE(_id, _ops, map_cap)
 #define BPF_LINK_TYPE(_id, _name)
 #include <linux/bpf_types.h>
 #undef BPF_PROG_TYPE
--=20
2.24.1

