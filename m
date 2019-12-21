Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ECD741287C4
	for <lists+netdev@lfdr.de>; Sat, 21 Dec 2019 07:26:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726182AbfLUG0L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Dec 2019 01:26:11 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:37140 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726107AbfLUG0K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Dec 2019 01:26:10 -0500
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id xBL6OZKq019573
        for <netdev@vger.kernel.org>; Fri, 20 Dec 2019 22:26:09 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=+hH2KtNgywUEHhAkz28bzMJ2nFaWJPsIajemlueCmo4=;
 b=DZTCSt3qRAy+iLZBJQc3fCdBkGordCrwSi9rYuvjpKELNG3fc4k9Fbxclz4GzPIdtEMH
 vmuxBmmwUqdoGvmIIUItLsPA2u+DXLPWfOtduhX9e2GyhWhV/XsTXDHa/PmSAqWeg46q
 UTSaAoYO4agkPSXWruARGx2uOv1aSwTsTC0= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 2x14s8a69t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 20 Dec 2019 22:26:09 -0800
Received: from intmgw001.06.prn3.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 20 Dec 2019 22:26:08 -0800
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id AE5CE2946127; Fri, 20 Dec 2019 22:26:06 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Martin KaFai Lau <kafai@fb.com>
Smtp-Origin-Hostname: devbig005.ftw2.facebook.com
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>, <kernel-team@fb.com>,
        <netdev@vger.kernel.org>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next v2 05/11] bpf: Introduce BPF_PROG_TYPE_STRUCT_OPS
Date:   Fri, 20 Dec 2019 22:26:06 -0800
Message-ID: <20191221062606.1182939-1-kafai@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191221062556.1182261-1-kafai@fb.com>
References: <20191221062556.1182261-1-kafai@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-21_01:2019-12-17,2019-12-21 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0
 malwarescore=0 impostorscore=0 mlxscore=0 adultscore=0 bulkscore=0
 lowpriorityscore=0 suspectscore=38 mlxlogscore=999 phishscore=0
 clxscore=1015 priorityscore=1501 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1910280000 definitions=main-1912210054
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch allows the kernel's struct ops (i.e. func ptr) to be
implemented in BPF.  The first use case in this series is the
"struct tcp_congestion_ops" which will be introduced in a
latter patch.

This patch introduces a new prog type BPF_PROG_TYPE_STRUCT_OPS.
The BPF_PROG_TYPE_STRUCT_OPS prog is verified against a particular
func ptr of a kernel struct.  The attr->attach_btf_id is the btf id
of a kernel struct.  The attr->expected_attach_type is the member
"index" of that kernel struct.  The first member of a struct starts
with member index 0.  That will avoid ambiguity when a kernel struct
has multiple func ptrs with the same func signature.

For example, a BPF_PROG_TYPE_STRUCT_OPS prog is written
to implement the "init" func ptr of the "struct tcp_congestion_ops".
The attr->attach_btf_id is the btf id of the "struct tcp_congestion_ops"
of the _running_ kernel.  The attr->expected_attach_type is 3.

The ctx of BPF_PROG_TYPE_STRUCT_OPS is an array of u64 args saved
by arch_prepare_bpf_trampoline that will be done in the next
patch when introducing BPF_MAP_TYPE_STRUCT_OPS.

"struct bpf_struct_ops" is introduced as a common interface for the kernel
struct that supports BPF_PROG_TYPE_STRUCT_OPS prog.  The supporting kernel
struct will need to implement an instance of the "struct bpf_struct_ops".

The supporting kernel struct also needs to implement a bpf_verifier_ops.
During BPF_PROG_LOAD, bpf_struct_ops_find() will find the right
bpf_verifier_ops by searching the attr->attach_btf_id.

A new "btf_struct_access" is also added to the bpf_verifier_ops such
that the supporting kernel struct can optionally provide its own specific
check on accessing the func arg (e.g. provide limited write access).

After btf_vmlinux is parsed, the new bpf_struct_ops_init() is called
to initialize some values (e.g. the btf id of the supporting kernel
struct) and it can only be done once the btf_vmlinux is available.

The R0 checks at BPF_EXIT is excluded for the BPF_PROG_TYPE_STRUCT_OPS prog
if the return type of the prog->aux->attach_func_proto is "void".

Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 include/linux/bpf.h               |  30 +++++++
 include/linux/bpf_types.h         |   4 +
 include/linux/btf.h               |  34 ++++++++
 include/uapi/linux/bpf.h          |   1 +
 kernel/bpf/Makefile               |   2 +-
 kernel/bpf/bpf_struct_ops.c       | 122 +++++++++++++++++++++++++++
 kernel/bpf/bpf_struct_ops_types.h |   4 +
 kernel/bpf/btf.c                  |  88 ++++++++++++++------
 kernel/bpf/syscall.c              |  17 ++--
 kernel/bpf/verifier.c             | 134 +++++++++++++++++++++++-------
 10 files changed, 372 insertions(+), 64 deletions(-)
 create mode 100644 kernel/bpf/bpf_struct_ops.c
 create mode 100644 kernel/bpf/bpf_struct_ops_types.h

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 8f3e00c84f39..b8f087eb4bdf 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -349,6 +349,10 @@ struct bpf_verifier_ops {
 				  const struct bpf_insn *src,
 				  struct bpf_insn *dst,
 				  struct bpf_prog *prog, u32 *target_size);
+	int (*btf_struct_access)(struct bpf_verifier_log *log,
+				 const struct btf_type *t, int off, int size,
+				 enum bpf_access_type atype,
+				 u32 *next_btf_id);
 };
 
 struct bpf_prog_offload_ops {
@@ -667,6 +671,32 @@ struct bpf_array_aux {
 	struct work_struct work;
 };
 
+struct btf_type;
+struct btf_member;
+
+#define BPF_STRUCT_OPS_MAX_NR_MEMBERS 64
+struct bpf_struct_ops {
+	const struct bpf_verifier_ops *verifier_ops;
+	int (*init)(struct btf *_btf_vmlinux);
+	int (*check_member)(const struct btf_type *t,
+			    const struct btf_member *member);
+	const struct btf_type *type;
+	const char *name;
+	struct btf_func_model func_models[BPF_STRUCT_OPS_MAX_NR_MEMBERS];
+	u32 type_id;
+};
+
+#if defined(CONFIG_BPF_JIT)
+const struct bpf_struct_ops *bpf_struct_ops_find(u32 type_id);
+void bpf_struct_ops_init(struct btf *_btf_vmlinux);
+#else
+static inline const struct bpf_struct_ops *bpf_struct_ops_find(u32 type_id)
+{
+	return NULL;
+}
+static inline void bpf_struct_ops_init(struct btf *_btf_vmlinux) { }
+#endif
+
 struct bpf_array {
 	struct bpf_map map;
 	u32 elem_size;
diff --git a/include/linux/bpf_types.h b/include/linux/bpf_types.h
index 93740b3614d7..fadd243ffa2d 100644
--- a/include/linux/bpf_types.h
+++ b/include/linux/bpf_types.h
@@ -65,6 +65,10 @@ BPF_PROG_TYPE(BPF_PROG_TYPE_LIRC_MODE2, lirc_mode2,
 BPF_PROG_TYPE(BPF_PROG_TYPE_SK_REUSEPORT, sk_reuseport,
 	      struct sk_reuseport_md, struct sk_reuseport_kern)
 #endif
+#if defined(CONFIG_BPF_JIT)
+BPF_PROG_TYPE(BPF_PROG_TYPE_STRUCT_OPS, bpf_struct_ops,
+	      void *, void *)
+#endif
 
 BPF_MAP_TYPE(BPF_MAP_TYPE_ARRAY, array_map_ops)
 BPF_MAP_TYPE(BPF_MAP_TYPE_PERCPU_ARRAY, percpu_array_map_ops)
diff --git a/include/linux/btf.h b/include/linux/btf.h
index 79d4abc2556a..f74a09a7120b 100644
--- a/include/linux/btf.h
+++ b/include/linux/btf.h
@@ -53,6 +53,18 @@ bool btf_member_is_reg_int(const struct btf *btf, const struct btf_type *s,
 			   u32 expected_offset, u32 expected_size);
 int btf_find_spin_lock(const struct btf *btf, const struct btf_type *t);
 bool btf_type_is_void(const struct btf_type *t);
+s32 btf_find_by_name_kind(const struct btf *btf, const char *name, u8 kind);
+const struct btf_type *btf_type_skip_modifiers(const struct btf *btf,
+					       u32 id, u32 *res_id);
+const struct btf_type *btf_type_resolve_ptr(const struct btf *btf,
+					    u32 id, u32 *res_id);
+const struct btf_type *btf_type_resolve_func_ptr(const struct btf *btf,
+						 u32 id, u32 *res_id);
+
+#define for_each_member(i, struct_type, member)			\
+	for (i = 0, member = btf_type_member(struct_type);	\
+	     i < btf_type_vlen(struct_type);			\
+	     i++, member++)
 
 static inline bool btf_type_is_ptr(const struct btf_type *t)
 {
@@ -84,6 +96,28 @@ static inline bool btf_type_is_func_proto(const struct btf_type *t)
 	return BTF_INFO_KIND(t->info) == BTF_KIND_FUNC_PROTO;
 }
 
+static inline u16 btf_type_vlen(const struct btf_type *t)
+{
+	return BTF_INFO_VLEN(t->info);
+}
+
+static inline bool btf_type_kflag(const struct btf_type *t)
+{
+	return BTF_INFO_KFLAG(t->info);
+}
+
+static inline u32 btf_member_bitfield_size(const struct btf_type *struct_type,
+					   const struct btf_member *member)
+{
+	return btf_type_kflag(struct_type) ? BTF_MEMBER_BITFIELD_SIZE(member->offset)
+					   : 0;
+}
+
+static inline const struct btf_member *btf_type_member(const struct btf_type *t)
+{
+	return (const struct btf_member *)(t + 1);
+}
+
 #ifdef CONFIG_BPF_SYSCALL
 const struct btf_type *btf_type_by_id(const struct btf *btf, u32 type_id);
 const char *btf_name_by_offset(const struct btf *btf, u32 offset);
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 7df436da542d..c1eeb3e0e116 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -174,6 +174,7 @@ enum bpf_prog_type {
 	BPF_PROG_TYPE_RAW_TRACEPOINT_WRITABLE,
 	BPF_PROG_TYPE_CGROUP_SOCKOPT,
 	BPF_PROG_TYPE_TRACING,
+	BPF_PROG_TYPE_STRUCT_OPS,
 };
 
 enum bpf_attach_type {
diff --git a/kernel/bpf/Makefile b/kernel/bpf/Makefile
index d4f330351f87..0e636387db6f 100644
--- a/kernel/bpf/Makefile
+++ b/kernel/bpf/Makefile
@@ -6,7 +6,7 @@ obj-$(CONFIG_BPF_SYSCALL) += syscall.o verifier.o inode.o helpers.o tnum.o
 obj-$(CONFIG_BPF_SYSCALL) += hashtab.o arraymap.o percpu_freelist.o bpf_lru_list.o lpm_trie.o map_in_map.o
 obj-$(CONFIG_BPF_SYSCALL) += local_storage.o queue_stack_maps.o
 obj-$(CONFIG_BPF_SYSCALL) += disasm.o
-obj-$(CONFIG_BPF_JIT) += trampoline.o
+obj-$(CONFIG_BPF_JIT) += trampoline.o bpf_struct_ops.o
 obj-$(CONFIG_BPF_SYSCALL) += btf.o
 obj-$(CONFIG_BPF_JIT) += dispatcher.o
 ifeq ($(CONFIG_NET),y)
diff --git a/kernel/bpf/bpf_struct_ops.c b/kernel/bpf/bpf_struct_ops.c
new file mode 100644
index 000000000000..c9f81bd1df83
--- /dev/null
+++ b/kernel/bpf/bpf_struct_ops.c
@@ -0,0 +1,122 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright (c) 2019 Facebook */
+
+#include <linux/bpf.h>
+#include <linux/bpf_verifier.h>
+#include <linux/btf.h>
+#include <linux/filter.h>
+#include <linux/slab.h>
+#include <linux/numa.h>
+#include <linux/seq_file.h>
+#include <linux/refcount.h>
+
+#define BPF_STRUCT_OPS_TYPE(_name)				\
+extern struct bpf_struct_ops bpf_##_name;
+#include "bpf_struct_ops_types.h"
+#undef BPF_STRUCT_OPS_TYPE
+
+enum {
+#define BPF_STRUCT_OPS_TYPE(_name) BPF_STRUCT_OPS_TYPE_##_name,
+#include "bpf_struct_ops_types.h"
+#undef BPF_STRUCT_OPS_TYPE
+	__NR_BPF_STRUCT_OPS_TYPE,
+};
+
+static struct bpf_struct_ops * const bpf_struct_ops[] = {
+#define BPF_STRUCT_OPS_TYPE(_name)				\
+	[BPF_STRUCT_OPS_TYPE_##_name] = &bpf_##_name,
+#include "bpf_struct_ops_types.h"
+#undef BPF_STRUCT_OPS_TYPE
+};
+
+const struct bpf_verifier_ops bpf_struct_ops_verifier_ops = {
+};
+
+const struct bpf_prog_ops bpf_struct_ops_prog_ops = {
+};
+
+void bpf_struct_ops_init(struct btf *_btf_vmlinux)
+{
+	const struct btf_member *member;
+	struct bpf_struct_ops *st_ops;
+	struct bpf_verifier_log log = {};
+	const struct btf_type *t;
+	const char *mname;
+	s32 type_id;
+	u32 i, j;
+
+	for (i = 0; i < ARRAY_SIZE(bpf_struct_ops); i++) {
+		st_ops = bpf_struct_ops[i];
+
+		type_id = btf_find_by_name_kind(_btf_vmlinux, st_ops->name,
+						BTF_KIND_STRUCT);
+		if (type_id < 0) {
+			pr_warn("Cannot find struct %s in btf_vmlinux\n",
+				st_ops->name);
+			continue;
+		}
+		t = btf_type_by_id(_btf_vmlinux, type_id);
+		if (btf_type_vlen(t) > BPF_STRUCT_OPS_MAX_NR_MEMBERS) {
+			pr_warn("Cannot support #%u members in struct %s\n",
+				btf_type_vlen(t), st_ops->name);
+			continue;
+		}
+
+		for_each_member(j, t, member) {
+			const struct btf_type *func_proto;
+
+			mname = btf_name_by_offset(_btf_vmlinux,
+						   member->name_off);
+			if (!*mname) {
+				pr_warn("anon member in struct %s is not supported\n",
+					st_ops->name);
+				break;
+			}
+
+			if (btf_member_bitfield_size(t, member)) {
+				pr_warn("bit field member %s in struct %s is not supported\n",
+					mname, st_ops->name);
+				break;
+			}
+
+			func_proto = btf_type_resolve_func_ptr(_btf_vmlinux,
+							       member->type,
+							       NULL);
+			if (func_proto &&
+			    btf_distill_func_proto(&log, _btf_vmlinux,
+						   func_proto, mname,
+						   &st_ops->func_models[j])) {
+				pr_warn("Error in parsing func ptr %s in struct %s\n",
+					mname, st_ops->name);
+				break;
+			}
+		}
+
+		if (j == btf_type_vlen(t)) {
+			if (st_ops->init(_btf_vmlinux)) {
+				pr_warn("Error in init bpf_struct_ops %s\n",
+					st_ops->name);
+			} else {
+				st_ops->type_id = type_id;
+				st_ops->type = t;
+			}
+		}
+	}
+}
+
+extern struct btf *btf_vmlinux;
+
+const struct bpf_struct_ops *bpf_struct_ops_find(u32 type_id)
+{
+	unsigned int i;
+
+	if (!type_id || !btf_vmlinux)
+		return NULL;
+
+	for (i = 0; i < ARRAY_SIZE(bpf_struct_ops); i++) {
+		if (bpf_struct_ops[i]->type_id == type_id)
+			return bpf_struct_ops[i];
+	}
+
+	return NULL;
+}
diff --git a/kernel/bpf/bpf_struct_ops_types.h b/kernel/bpf/bpf_struct_ops_types.h
new file mode 100644
index 000000000000..7bb13ff49ec2
--- /dev/null
+++ b/kernel/bpf/bpf_struct_ops_types.h
@@ -0,0 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* internal file - do not include directly */
+
+/* To be filled in a later patch */
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index da73b63acfc5..0e879a512cf4 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -180,11 +180,6 @@
  */
 #define BTF_MAX_SIZE (16 * 1024 * 1024)
 
-#define for_each_member(i, struct_type, member)			\
-	for (i = 0, member = btf_type_member(struct_type);	\
-	     i < btf_type_vlen(struct_type);			\
-	     i++, member++)
-
 #define for_each_member_from(i, from, struct_type, member)		\
 	for (i = from, member = btf_type_member(struct_type) + from;	\
 	     i < btf_type_vlen(struct_type);				\
@@ -382,6 +377,65 @@ static bool btf_type_is_datasec(const struct btf_type *t)
 	return BTF_INFO_KIND(t->info) == BTF_KIND_DATASEC;
 }
 
+s32 btf_find_by_name_kind(const struct btf *btf, const char *name, u8 kind)
+{
+	const struct btf_type *t;
+	const char *tname;
+	u32 i;
+
+	for (i = 1; i <= btf->nr_types; i++) {
+		t = btf->types[i];
+		if (BTF_INFO_KIND(t->info) != kind)
+			continue;
+
+		tname = btf_name_by_offset(btf, t->name_off);
+		if (!strcmp(tname, name))
+			return i;
+	}
+
+	return -ENOENT;
+}
+
+const struct btf_type *btf_type_skip_modifiers(const struct btf *btf,
+					       u32 id, u32 *res_id)
+{
+	const struct btf_type *t = btf_type_by_id(btf, id);
+
+	while (btf_type_is_modifier(t)) {
+		id = t->type;
+		t = btf_type_by_id(btf, t->type);
+	}
+
+	if (res_id)
+		*res_id = id;
+
+	return t;
+}
+
+const struct btf_type *btf_type_resolve_ptr(const struct btf *btf,
+					    u32 id, u32 *res_id)
+{
+	const struct btf_type *t;
+
+	t = btf_type_skip_modifiers(btf, id, NULL);
+	if (!btf_type_is_ptr(t))
+		return NULL;
+
+	return btf_type_skip_modifiers(btf, t->type, res_id);
+}
+
+const struct btf_type *btf_type_resolve_func_ptr(const struct btf *btf,
+						 u32 id, u32 *res_id)
+{
+	const struct btf_type *ptype;
+
+	ptype = btf_type_resolve_ptr(btf, id, res_id);
+	if (ptype && btf_type_is_func_proto(ptype))
+		return ptype;
+
+	return NULL;
+}
+
 /* Types that act only as a source, not sink or intermediate
  * type when resolving.
  */
@@ -446,16 +500,6 @@ static const char *btf_int_encoding_str(u8 encoding)
 		return "UNKN";
 }
 
-static u16 btf_type_vlen(const struct btf_type *t)
-{
-	return BTF_INFO_VLEN(t->info);
-}
-
-static bool btf_type_kflag(const struct btf_type *t)
-{
-	return BTF_INFO_KFLAG(t->info);
-}
-
 static u32 btf_member_bit_offset(const struct btf_type *struct_type,
 			     const struct btf_member *member)
 {
@@ -463,13 +507,6 @@ static u32 btf_member_bit_offset(const struct btf_type *struct_type,
 					   : member->offset;
 }
 
-static u32 btf_member_bitfield_size(const struct btf_type *struct_type,
-				    const struct btf_member *member)
-{
-	return btf_type_kflag(struct_type) ? BTF_MEMBER_BITFIELD_SIZE(member->offset)
-					   : 0;
-}
-
 static u32 btf_type_int(const struct btf_type *t)
 {
 	return *(u32 *)(t + 1);
@@ -480,11 +517,6 @@ static const struct btf_array *btf_type_array(const struct btf_type *t)
 	return (const struct btf_array *)(t + 1);
 }
 
-static const struct btf_member *btf_type_member(const struct btf_type *t)
-{
-	return (const struct btf_member *)(t + 1);
-}
-
 static const struct btf_enum *btf_type_enum(const struct btf_type *t)
 {
 	return (const struct btf_enum *)(t + 1);
@@ -3604,6 +3636,8 @@ struct btf *btf_parse_vmlinux(void)
 		goto errout;
 	}
 
+	bpf_struct_ops_init(btf);
+
 	btf_verifier_env_free(env);
 	refcount_set(&btf->refcnt, 1);
 	return btf;
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 81ee8595dfee..03a02ef4c496 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -1672,17 +1672,22 @@ bpf_prog_load_check_attach(enum bpf_prog_type prog_type,
 			   enum bpf_attach_type expected_attach_type,
 			   u32 btf_id, u32 prog_fd)
 {
-	switch (prog_type) {
-	case BPF_PROG_TYPE_TRACING:
+	if (btf_id) {
 		if (btf_id > BTF_MAX_TYPE)
 			return -EINVAL;
-		break;
-	default:
-		if (btf_id || prog_fd)
+
+		switch (prog_type) {
+		case BPF_PROG_TYPE_TRACING:
+		case BPF_PROG_TYPE_STRUCT_OPS:
+			break;
+		default:
 			return -EINVAL;
-		break;
+		}
 	}
 
+	if (prog_fd && prog_type != BPF_PROG_TYPE_TRACING)
+		return -EINVAL;
+
 	switch (prog_type) {
 	case BPF_PROG_TYPE_CGROUP_SOCK:
 		switch (expected_attach_type) {
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 408264c1d55b..4c1eaa1a2965 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -2858,11 +2858,6 @@ static int check_ptr_to_btf_access(struct bpf_verifier_env *env,
 	u32 btf_id;
 	int ret;
 
-	if (atype != BPF_READ) {
-		verbose(env, "only read is supported\n");
-		return -EACCES;
-	}
-
 	if (off < 0) {
 		verbose(env,
 			"R%d is ptr_%s invalid negative access: off=%d\n",
@@ -2879,17 +2874,32 @@ static int check_ptr_to_btf_access(struct bpf_verifier_env *env,
 		return -EACCES;
 	}
 
-	ret = btf_struct_access(&env->log, t, off, size, atype, &btf_id);
+	if (env->ops->btf_struct_access) {
+		ret = env->ops->btf_struct_access(&env->log, t, off, size,
+						  atype, &btf_id);
+	} else {
+		if (atype != BPF_READ) {
+			verbose(env, "only read is supported\n");
+			return -EACCES;
+		}
+
+		ret = btf_struct_access(&env->log, t, off, size, atype,
+					&btf_id);
+	}
+
 	if (ret < 0)
 		return ret;
 
-	if (ret == SCALAR_VALUE) {
-		mark_reg_unknown(env, regs, value_regno);
-		return 0;
+	if (atype == BPF_READ) {
+		if (ret == SCALAR_VALUE) {
+			mark_reg_unknown(env, regs, value_regno);
+			return 0;
+		}
+		mark_reg_known_zero(env, regs, value_regno);
+		regs[value_regno].type = PTR_TO_BTF_ID;
+		regs[value_regno].btf_id = btf_id;
 	}
-	mark_reg_known_zero(env, regs, value_regno);
-	regs[value_regno].type = PTR_TO_BTF_ID;
-	regs[value_regno].btf_id = btf_id;
+
 	return 0;
 }
 
@@ -6343,8 +6353,30 @@ static int check_ld_abs(struct bpf_verifier_env *env, struct bpf_insn *insn)
 static int check_return_code(struct bpf_verifier_env *env)
 {
 	struct tnum enforce_attach_type_range = tnum_unknown;
+	const struct bpf_prog *prog = env->prog;
 	struct bpf_reg_state *reg;
 	struct tnum range = tnum_range(0, 1);
+	int err;
+
+	/* The struct_ops func-ptr's return type could be "void" */
+	if (env->prog->type == BPF_PROG_TYPE_STRUCT_OPS &&
+	    !prog->aux->attach_func_proto->type)
+		return 0;
+
+	/* eBPF calling convetion is such that R0 is used
+	 * to return the value from eBPF program.
+	 * Make sure that it's readable at this time
+	 * of bpf_exit, which means that program wrote
+	 * something into it earlier
+	 */
+	err = check_reg_arg(env, BPF_REG_0, SRC_OP);
+	if (err)
+		return err;
+
+	if (is_pointer_value(env, BPF_REG_0)) {
+		verbose(env, "R0 leaks addr as return value\n");
+		return -EACCES;
+	}
 
 	switch (env->prog->type) {
 	case BPF_PROG_TYPE_CGROUP_SOCK_ADDR:
@@ -8010,21 +8042,6 @@ static int do_check(struct bpf_verifier_env *env)
 				if (err)
 					return err;
 
-				/* eBPF calling convetion is such that R0 is used
-				 * to return the value from eBPF program.
-				 * Make sure that it's readable at this time
-				 * of bpf_exit, which means that program wrote
-				 * something into it earlier
-				 */
-				err = check_reg_arg(env, BPF_REG_0, SRC_OP);
-				if (err)
-					return err;
-
-				if (is_pointer_value(env, BPF_REG_0)) {
-					verbose(env, "R0 leaks addr as return value\n");
-					return -EACCES;
-				}
-
 				err = check_return_code(env);
 				if (err)
 					return err;
@@ -8833,12 +8850,14 @@ static int convert_ctx_accesses(struct bpf_verifier_env *env)
 			convert_ctx_access = bpf_xdp_sock_convert_ctx_access;
 			break;
 		case PTR_TO_BTF_ID:
-			if (type == BPF_WRITE) {
+			if (type == BPF_READ) {
+				insn->code = BPF_LDX | BPF_PROBE_MEM |
+					BPF_SIZE((insn)->code);
+				env->prog->aux->num_exentries++;
+			} else if (env->prog->type != BPF_PROG_TYPE_STRUCT_OPS) {
 				verbose(env, "Writes through BTF pointers are not allowed\n");
 				return -EINVAL;
 			}
-			insn->code = BPF_LDX | BPF_PROBE_MEM | BPF_SIZE((insn)->code);
-			env->prog->aux->num_exentries++;
 			continue;
 		default:
 			continue;
@@ -9505,6 +9524,58 @@ static void print_verification_stats(struct bpf_verifier_env *env)
 		env->peak_states, env->longest_mark_read_walk);
 }
 
+static int check_struct_ops_btf_id(struct bpf_verifier_env *env)
+{
+	const struct btf_type *t, *func_proto;
+	const struct bpf_struct_ops *st_ops;
+	const struct btf_member *member;
+	struct bpf_prog *prog = env->prog;
+	u32 btf_id, member_idx;
+	const char *mname;
+
+	btf_id = prog->aux->attach_btf_id;
+	st_ops = bpf_struct_ops_find(btf_id);
+	if (!st_ops) {
+		verbose(env, "attach_btf_id %u is not a supported struct\n",
+			btf_id);
+		return -ENOTSUPP;
+	}
+
+	t = st_ops->type;
+	member_idx = prog->expected_attach_type;
+	if (member_idx >= btf_type_vlen(t)) {
+		verbose(env, "attach to invalid member idx %u of struct %s\n",
+			member_idx, st_ops->name);
+		return -EINVAL;
+	}
+
+	member = &btf_type_member(t)[member_idx];
+	mname = btf_name_by_offset(btf_vmlinux, member->name_off);
+	func_proto = btf_type_resolve_func_ptr(btf_vmlinux, member->type,
+					       NULL);
+	if (!func_proto) {
+		verbose(env, "attach to invalid member %s(@idx %u) of struct %s\n",
+			mname, member_idx, st_ops->name);
+		return -EINVAL;
+	}
+
+	if (st_ops->check_member) {
+		int err = st_ops->check_member(t, member);
+
+		if (err) {
+			verbose(env, "attach to unsupported member %s of struct %s\n",
+				mname, st_ops->name);
+			return err;
+		}
+	}
+
+	prog->aux->attach_func_proto = func_proto;
+	prog->aux->attach_func_name = mname;
+	env->ops = st_ops->verifier_ops;
+
+	return 0;
+}
+
 static int check_attach_btf_id(struct bpf_verifier_env *env)
 {
 	struct bpf_prog *prog = env->prog;
@@ -9520,6 +9591,9 @@ static int check_attach_btf_id(struct bpf_verifier_env *env)
 	long addr;
 	u64 key;
 
+	if (prog->type == BPF_PROG_TYPE_STRUCT_OPS)
+		return check_struct_ops_btf_id(env);
+
 	if (prog->type != BPF_PROG_TYPE_TRACING)
 		return 0;
 
-- 
2.17.1

