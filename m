Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 757B91DDD13
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 04:24:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727837AbgEVCXt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 22:23:49 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:46190 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727794AbgEVCXs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 22:23:48 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04M2LM53003737
        for <netdev@vger.kernel.org>; Thu, 21 May 2020 19:23:47 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=nDfUsQsACtAzt8gfblfmYubzrh49rUze0IvmFCrIFjg=;
 b=FhIfD7z39W3teLNHlvPElsYI5hX9HqQG5D3XhndYGFforVNIkDAsYRznnM1HnWTZUX63
 b01AGGwAoniTT/CtiGsxbjnct/2d8Q8VxUtFlwI7mGFaBUqjkMyCN1uOu+HU5JspO0dB
 aSiaRrrBpLzMIo6/3A6Th2Ps09X5RIPe14A= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3152xu2nf6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 21 May 2020 19:23:47 -0700
Received: from intmgw003.08.frc2.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:21d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 21 May 2020 19:23:46 -0700
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id E970929455B1; Thu, 21 May 2020 19:23:42 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Martin KaFai Lau <kafai@fb.com>
Smtp-Origin-Hostname: devbig005.ftw2.facebook.com
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        <netdev@vger.kernel.org>, Andrey Ignatov <rdna@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v2 bpf-next 1/3] bpf: Consolidate inner-map-compatible properties into bpf_types.h
Date:   Thu, 21 May 2020 19:23:42 -0700
Message-ID: <20200522022342.899756-1-kafai@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200522022336.899416-1-kafai@fb.com>
References: <20200522022336.899416-1-kafai@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-21_16:2020-05-21,2020-05-21 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=13
 cotscore=-2147483648 priorityscore=1501 mlxscore=0 malwarescore=0
 adultscore=0 mlxlogscore=999 lowpriorityscore=0 phishscore=0 clxscore=1015
 bulkscore=0 spamscore=0 impostorscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005220017
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds a "properties" member to "struct bpf_map".  The propertie=
s of
individual map-type is tagged in the "BPF_MAP_TYPE_FL" in bpf_types.h.
The original "BPF_MAP_TYPE" is defined to "BPF_MAP_TYPE_FL(..., 0)".

It will be less error prone when a map's properties is decided at the sam=
e
place as the new map type is added in bpf_types.h.  That will help to
avoid mistake like missing modification in other source files like
the map_in_map.c here or other source files in the future.

Cc: Andrey Ignatov <rdna@fb.com>
Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 include/linux/bpf.h       |  8 ++++++--
 include/linux/bpf_types.h | 19 +++++++++++++++----
 kernel/bpf/btf.c          |  4 ++--
 kernel/bpf/map_in_map.c   |  9 ++-------
 kernel/bpf/syscall.c      | 25 +++++++++++++++++++------
 kernel/bpf/verifier.c     |  4 ++--
 6 files changed, 46 insertions(+), 23 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index efe8836b5c48..f947d899aa46 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -97,6 +97,9 @@ struct bpf_map_memory {
 	struct user_struct *user;
 };
=20
+/* Cannot be used as an inner map */
+#define BPF_MAP_NO_INNER_MAP (1 << 0)
+
 struct bpf_map {
 	/* The first two cachelines with read-mostly members of which some
 	 * are also accessed in fast-path (e.g. ops, max_entries).
@@ -120,6 +123,7 @@ struct bpf_map {
 	struct bpf_map_memory memory;
 	char name[BPF_OBJ_NAME_LEN];
 	u32 btf_vmlinux_value_type_id;
+	u32 properties;
 	bool bypass_spec_v1;
 	bool frozen; /* write-once; write-protected by freeze_mutex */
 	/* 22 bytes hole */
@@ -1037,12 +1041,12 @@ extern const struct file_operations bpf_iter_fops=
;
 #define BPF_PROG_TYPE(_id, _name, prog_ctx_type, kern_ctx_type) \
 	extern const struct bpf_prog_ops _name ## _prog_ops; \
 	extern const struct bpf_verifier_ops _name ## _verifier_ops;
-#define BPF_MAP_TYPE(_id, _ops) \
+#define BPF_MAP_TYPE_FL(_id, _ops, properties) \
 	extern const struct bpf_map_ops _ops;
 #define BPF_LINK_TYPE(_id, _name)
 #include <linux/bpf_types.h>
 #undef BPF_PROG_TYPE
-#undef BPF_MAP_TYPE
+#undef BPF_MAP_TYPE_FL
 #undef BPF_LINK_TYPE
=20
 extern const struct bpf_prog_ops bpf_offload_prog_ops;
diff --git a/include/linux/bpf_types.h b/include/linux/bpf_types.h
index 29d22752fc87..3f32702c9bf4 100644
--- a/include/linux/bpf_types.h
+++ b/include/linux/bpf_types.h
@@ -76,16 +76,25 @@ BPF_PROG_TYPE(BPF_PROG_TYPE_LSM, lsm,
 #endif /* CONFIG_BPF_LSM */
 #endif
=20
+#define BPF_MAP_TYPE(x, y) BPF_MAP_TYPE_FL(x, y, 0)
+
 BPF_MAP_TYPE(BPF_MAP_TYPE_ARRAY, array_map_ops)
 BPF_MAP_TYPE(BPF_MAP_TYPE_PERCPU_ARRAY, percpu_array_map_ops)
-BPF_MAP_TYPE(BPF_MAP_TYPE_PROG_ARRAY, prog_array_map_ops)
+/* prog_array->aux->{type,jited} is a runtime binding.
+ * Doing static check alone in the verifier is not enough,
+ * so BPF_MAP_NO_INNTER_MAP is needed.
+ */
+BPF_MAP_TYPE_FL(BPF_MAP_TYPE_PROG_ARRAY, prog_array_map_ops,
+		BPF_MAP_NO_INNER_MAP)
 BPF_MAP_TYPE(BPF_MAP_TYPE_PERF_EVENT_ARRAY, perf_event_array_map_ops)
 #ifdef CONFIG_CGROUPS
 BPF_MAP_TYPE(BPF_MAP_TYPE_CGROUP_ARRAY, cgroup_array_map_ops)
 #endif
 #ifdef CONFIG_CGROUP_BPF
-BPF_MAP_TYPE(BPF_MAP_TYPE_CGROUP_STORAGE, cgroup_storage_map_ops)
-BPF_MAP_TYPE(BPF_MAP_TYPE_PERCPU_CGROUP_STORAGE, cgroup_storage_map_ops)
+BPF_MAP_TYPE_FL(BPF_MAP_TYPE_CGROUP_STORAGE, cgroup_storage_map_ops,
+		BPF_MAP_NO_INNER_MAP)
+BPF_MAP_TYPE_FL(BPF_MAP_TYPE_PERCPU_CGROUP_STORAGE, cgroup_storage_map_o=
ps,
+		BPF_MAP_NO_INNER_MAP)
 #endif
 BPF_MAP_TYPE(BPF_MAP_TYPE_HASH, htab_map_ops)
 BPF_MAP_TYPE(BPF_MAP_TYPE_PERCPU_HASH, htab_percpu_map_ops)
@@ -116,8 +125,10 @@ BPF_MAP_TYPE(BPF_MAP_TYPE_REUSEPORT_SOCKARRAY, reuse=
port_array_ops)
 BPF_MAP_TYPE(BPF_MAP_TYPE_QUEUE, queue_map_ops)
 BPF_MAP_TYPE(BPF_MAP_TYPE_STACK, stack_map_ops)
 #if defined(CONFIG_BPF_JIT)
-BPF_MAP_TYPE(BPF_MAP_TYPE_STRUCT_OPS, bpf_struct_ops_map_ops)
+BPF_MAP_TYPE_FL(BPF_MAP_TYPE_STRUCT_OPS, bpf_struct_ops_map_ops,
+		BPF_MAP_NO_INNER_MAP)
 #endif
+#undef BPF_MAP_TYPE
=20
 BPF_LINK_TYPE(BPF_LINK_TYPE_RAW_TRACEPOINT, raw_tracepoint)
 BPF_LINK_TYPE(BPF_LINK_TYPE_TRACING, tracing)
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 58c9af1d4808..f527a120eef3 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -3481,7 +3481,7 @@ extern char __weak __start_BTF[];
 extern char __weak __stop_BTF[];
 extern struct btf *btf_vmlinux;
=20
-#define BPF_MAP_TYPE(_id, _ops)
+#define BPF_MAP_TYPE_FL(_id, _ops, properties)
 #define BPF_LINK_TYPE(_id, _name)
 static union {
 	struct bpf_ctx_convert {
@@ -3508,7 +3508,7 @@ static u8 bpf_ctx_convert_map[] =3D {
 #undef BPF_PROG_TYPE
 	0, /* avoid empty array */
 };
-#undef BPF_MAP_TYPE
+#undef BPF_MAP_TYPE_FL
 #undef BPF_LINK_TYPE
=20
 static const struct btf_member *
diff --git a/kernel/bpf/map_in_map.c b/kernel/bpf/map_in_map.c
index 17738c93bec8..d965a1d328a9 100644
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
+	if (inner_map->properties & BPF_MAP_NO_INNER_MAP) {
 		fdput(f);
 		return ERR_PTR(-ENOTSUPP);
 	}
@@ -56,6 +50,7 @@ struct bpf_map *bpf_map_meta_alloc(int inner_map_ufd)
 	inner_map_meta->map_flags =3D inner_map->map_flags;
 	inner_map_meta->max_entries =3D inner_map->max_entries;
 	inner_map_meta->spin_lock_off =3D inner_map->spin_lock_off;
+	inner_map_meta->properties =3D inner_map->properties;
=20
 	/* Misc members not needed in bpf_map_meta_equal() check. */
 	inner_map_meta->ops =3D inner_map->ops;
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 431241c74614..02ec14e3e19a 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -49,12 +49,23 @@ int sysctl_unprivileged_bpf_disabled __read_mostly;
=20
 static const struct bpf_map_ops * const bpf_map_types[] =3D {
 #define BPF_PROG_TYPE(_id, _name, prog_ctx_type, kern_ctx_type)
-#define BPF_MAP_TYPE(_id, _ops) \
+#define BPF_MAP_TYPE_FL(_id, _ops, properties) \
 	[_id] =3D &_ops,
 #define BPF_LINK_TYPE(_id, _name)
 #include <linux/bpf_types.h>
 #undef BPF_PROG_TYPE
-#undef BPF_MAP_TYPE
+#undef BPF_MAP_TYPE_FL
+#undef BPF_LINK_TYPE
+};
+
+static const u32 bpf_map_properties[] =3D {
+#define BPF_PROG_TYPE(_id, _name, prog_ctx_type, kern_ctx_type)
+#define BPF_MAP_TYPE_FL(_id, _ops, properties) \
+	[_id] =3D properties,
+#define BPF_LINK_TYPE(_id, _name)
+#include <linux/bpf_types.h>
+#undef BPF_PROG_TYPE
+#undef BPF_MAP_TYPE_FL
 #undef BPF_LINK_TYPE
 };
=20
@@ -131,6 +142,8 @@ static struct bpf_map *find_and_alloc_map(union bpf_a=
ttr *attr)
 		return map;
 	map->ops =3D ops;
 	map->map_type =3D type;
+	map->properties =3D bpf_map_properties[type];
+
 	return map;
 }
=20
@@ -1551,11 +1564,11 @@ static int map_freeze(const union bpf_attr *attr)
 static const struct bpf_prog_ops * const bpf_prog_types[] =3D {
 #define BPF_PROG_TYPE(_id, _name, prog_ctx_type, kern_ctx_type) \
 	[_id] =3D & _name ## _prog_ops,
-#define BPF_MAP_TYPE(_id, _ops)
+#define BPF_MAP_TYPE_FL(_id, _ops, properties)
 #define BPF_LINK_TYPE(_id, _name)
 #include <linux/bpf_types.h>
 #undef BPF_PROG_TYPE
-#undef BPF_MAP_TYPE
+#undef BPF_MAP_TYPE_FL
 #undef BPF_LINK_TYPE
 };
=20
@@ -2333,14 +2346,14 @@ static int bpf_link_release(struct inode *inode, =
struct file *filp)
=20
 #ifdef CONFIG_PROC_FS
 #define BPF_PROG_TYPE(_id, _name, prog_ctx_type, kern_ctx_type)
-#define BPF_MAP_TYPE(_id, _ops)
+#define BPF_MAP_TYPE_FL(_id, _ops, properties)
 #define BPF_LINK_TYPE(_id, _name) [_id] =3D #_name,
 static const char *bpf_link_type_strs[] =3D {
 	[BPF_LINK_TYPE_UNSPEC] =3D "<invalid>",
 #include <linux/bpf_types.h>
 };
 #undef BPF_PROG_TYPE
-#undef BPF_MAP_TYPE
+#undef BPF_MAP_TYPE_FL
 #undef BPF_LINK_TYPE
=20
 static void bpf_link_show_fdinfo(struct seq_file *m, struct file *filp)
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 2ed8351f47a4..1743e070d08f 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -27,11 +27,11 @@
 static const struct bpf_verifier_ops * const bpf_verifier_ops[] =3D {
 #define BPF_PROG_TYPE(_id, _name, prog_ctx_type, kern_ctx_type) \
 	[_id] =3D & _name ## _verifier_ops,
-#define BPF_MAP_TYPE(_id, _ops)
+#define BPF_MAP_TYPE_FL(_id, _ops, properties)
 #define BPF_LINK_TYPE(_id, _name)
 #include <linux/bpf_types.h>
 #undef BPF_PROG_TYPE
-#undef BPF_MAP_TYPE
+#undef BPF_MAP_TYPE_FL
 #undef BPF_LINK_TYPE
 };
=20
--=20
2.24.1

