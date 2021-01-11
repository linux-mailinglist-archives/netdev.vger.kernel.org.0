Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38AA62F1C80
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 18:35:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389515AbhAKRfN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 12:35:13 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:33530 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389459AbhAKRfL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 12:35:11 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10BHJR5b063297;
        Mon, 11 Jan 2021 17:33:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=NOSUXFTDnwbckaG0jAookOPHjLUPsBwPhIerfpWkrpI=;
 b=m6HIhB956Q57vUhT1qIGYfnAqbQ4PmuMmPK2y+f5UeCITTkqu+KBb75AFf5tsudKHTkj
 GeP2sPdtmazLJlkJlvzE3h3bufbEkVg6SOEWVhklp4H+MBoTCZ3zyHQihrnq4q973NtL
 pB4cuPSwB3tNETVzSjuWVvV2c1yUj+IoLS4bZW5Wmi2nlGsno9aAlzABe8MY5w5LFnYl
 kftJprxNF5tTy5PKjhZ4aGo0/gl6wfNZmTBsu3JN7UXuzgR5j2K/UKc0uEHo2A0epWoS
 wjXUsMUUOxt3OETKwJkSr7leR3B42RVyFbjdOrGu9M5ATxg/8HZknyT0ObYqXn1OaP/f nw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 360kg1jdfr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 11 Jan 2021 17:33:27 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10BHKS85017381;
        Mon, 11 Jan 2021 17:33:27 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 360kf3v4km-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Jan 2021 17:33:26 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 10BHXOM8009846;
        Mon, 11 Jan 2021 17:33:24 GMT
Received: from localhost.localdomain (/95.45.14.174)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 11 Jan 2021 09:33:23 -0800
From:   Alan Maguire <alan.maguire@oracle.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, rostedt@goodmis.org,
        mingo@redhat.com, haoluo@google.com, jolsa@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kselftest@vger.kernel.org,
        shuah@kernel.org
Subject: [RFC PATCH bpf-next 1/2] bpf: share BTF "show" implementation between kernel and libbpf
Date:   Mon, 11 Jan 2021 17:32:52 +0000
Message-Id: <1610386373-24162-2-git-send-email-alan.maguire@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1610386373-24162-1-git-send-email-alan.maguire@oracle.com>
References: <1610386373-24162-1-git-send-email-alan.maguire@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9861 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 mlxlogscore=999 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101110100
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9861 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 clxscore=1015 impostorscore=0 spamscore=0 priorityscore=1501 mlxscore=0
 phishscore=0 mlxlogscore=999 bulkscore=0 adultscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101110100
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

libbpf already supports a "dumper" API for dumping type information,
but there is currently no support for dumping typed _data_ via libbpf.
However this functionality does exist in the kernel, in part to
facilitate the bpf_snprintf_btf() helper which dumps a string
representation of the pointer passed in utilizing the BTF type id
of the data pointed to.  For example, the pair of a pointer to
a "struct sk_buff" and the BTF type id of "struct sk_buff" can be
used.

Here the kernel code is generalized into btf_show_common.c.  For the
most part, code is identical for userspace and kernel, beyond a few API
differences and missing functions.  The only significant differences are

 - the "safe copy" logic used by the kernel to ensure we do not induce a
   crash during BPF operation; and
 - the BTF seq file support that is kernel-only.

The mechanics are to maintain identical btf_show_common.c files in
kernel/bpf and tools/lib/bpf , and a common header btf_common.h in
include/linux/ and tools/lib/bpf/.  This file duplication seems to
be the common practice with duplication between kernel and tools/
so it's the approach taken here.

The common code approach could likely be explored further, but here
the minimum common code required to support BTF show functionality is
used.

Currently the only "show" function for userspace is to write the
representation of the typed data to a string via

LIBBPF_API int
btf__snprintf(struct btf *btf, char *buf, int len, __u32 id, void *obj,
	      __u64 flags);

...but other approaches could be pursued including printf()-based
show, or even a callback mechanism could be supported to allow
user-defined show functions.

Here's an example usage, storing a string representation of
struct sk_buff *skb in buf:

	struct btf *btf = libbpf_find_kernel_btf();
	char buf[8192];
	__s32 skb_id;

	skb_id = btf__find_by_name_kind(btf, "sk_buff", BTF_KIND_STRUCT);
	if (skb_id < 0)
                fprintf(stderr, "no skbuff, err %d\n", skb_id);
	else
		btf__snprintf(btf, buf, sizeof(buf), skb_id, skb, 0);

Suggested-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
---
 include/linux/btf.h             |  121 +---
 include/linux/btf_common.h      |  286 +++++++++
 kernel/bpf/Makefile             |    2 +-
 kernel/bpf/arraymap.c           |    1 +
 kernel/bpf/bpf_struct_ops.c     |    1 +
 kernel/bpf/btf.c                | 1215 +-------------------------------------
 kernel/bpf/btf_show_common.c    | 1218 +++++++++++++++++++++++++++++++++++++++
 kernel/bpf/core.c               |    1 +
 kernel/bpf/hashtab.c            |    1 +
 kernel/bpf/local_storage.c      |    1 +
 kernel/bpf/verifier.c           |    1 +
 kernel/trace/bpf_trace.c        |    1 +
 tools/lib/bpf/Build             |    2 +-
 tools/lib/bpf/btf.h             |    7 +
 tools/lib/bpf/btf_common.h      |  286 +++++++++
 tools/lib/bpf/btf_show_common.c | 1218 +++++++++++++++++++++++++++++++++++++++
 tools/lib/bpf/libbpf.map        |    1 +
 17 files changed, 3044 insertions(+), 1319 deletions(-)
 create mode 100644 include/linux/btf_common.h
 create mode 100644 kernel/bpf/btf_show_common.c
 create mode 100644 tools/lib/bpf/btf_common.h
 create mode 100644 tools/lib/bpf/btf_show_common.c

diff --git a/include/linux/btf.h b/include/linux/btf.h
index 4c200f5..a1f6325 100644
--- a/include/linux/btf.h
+++ b/include/linux/btf.h
@@ -50,43 +50,6 @@ const struct btf_type *btf_type_id_size(const struct btf *btf,
 					u32 *type_id,
 					u32 *ret_size);
 
-/*
- * Options to control show behaviour.
- *	- BTF_SHOW_COMPACT: no formatting around type information
- *	- BTF_SHOW_NONAME: no struct/union member names/types
- *	- BTF_SHOW_PTR_RAW: show raw (unobfuscated) pointer values;
- *	  equivalent to %px.
- *	- BTF_SHOW_ZERO: show zero-valued struct/union members; they
- *	  are not displayed by default
- *	- BTF_SHOW_UNSAFE: skip use of bpf_probe_read() to safely read
- *	  data before displaying it.
- */
-#define BTF_SHOW_COMPACT	BTF_F_COMPACT
-#define BTF_SHOW_NONAME		BTF_F_NONAME
-#define BTF_SHOW_PTR_RAW	BTF_F_PTR_RAW
-#define BTF_SHOW_ZERO		BTF_F_ZERO
-#define BTF_SHOW_UNSAFE		(1ULL << 4)
-
-void btf_type_seq_show(const struct btf *btf, u32 type_id, void *obj,
-		       struct seq_file *m);
-int btf_type_seq_show_flags(const struct btf *btf, u32 type_id, void *obj,
-			    struct seq_file *m, u64 flags);
-
-/*
- * Copy len bytes of string representation of obj of BTF type_id into buf.
- *
- * @btf: struct btf object
- * @type_id: type id of type obj points to
- * @obj: pointer to typed data
- * @buf: buffer to write to
- * @len: maximum length to write to buf
- * @flags: show options (see above)
- *
- * Return: length that would have been/was copied as per snprintf, or
- *	   negative error.
- */
-int btf_type_snprintf_show(const struct btf *btf, u32 type_id, void *obj,
-			   char *buf, int len, u64 flags);
 
 int btf_get_fd_by_id(u32 id);
 u32 btf_obj_id(const struct btf *btf);
@@ -96,9 +59,8 @@ bool btf_member_is_reg_int(const struct btf *btf, const struct btf_type *s,
 			   u32 expected_offset, u32 expected_size);
 int btf_find_spin_lock(const struct btf *btf, const struct btf_type *t);
 bool btf_type_is_void(const struct btf_type *t);
+
 s32 btf_find_by_name_kind(const struct btf *btf, const char *name, u8 kind);
-const struct btf_type *btf_type_skip_modifiers(const struct btf *btf,
-					       u32 id, u32 *res_id);
 const struct btf_type *btf_type_resolve_ptr(const struct btf *btf,
 					    u32 id, u32 *res_id);
 const struct btf_type *btf_type_resolve_func_ptr(const struct btf *btf,
@@ -107,75 +69,7 @@ const struct btf_type *btf_type_resolve_func_ptr(const struct btf *btf,
 btf_resolve_size(const struct btf *btf, const struct btf_type *type,
 		 u32 *type_size);
 
-#define for_each_member(i, struct_type, member)			\
-	for (i = 0, member = btf_type_member(struct_type);	\
-	     i < btf_type_vlen(struct_type);			\
-	     i++, member++)
-
-#define for_each_vsi(i, datasec_type, member)			\
-	for (i = 0, member = btf_type_var_secinfo(datasec_type);	\
-	     i < btf_type_vlen(datasec_type);			\
-	     i++, member++)
-
-static inline bool btf_type_is_ptr(const struct btf_type *t)
-{
-	return BTF_INFO_KIND(t->info) == BTF_KIND_PTR;
-}
-
-static inline bool btf_type_is_int(const struct btf_type *t)
-{
-	return BTF_INFO_KIND(t->info) == BTF_KIND_INT;
-}
-
-static inline bool btf_type_is_small_int(const struct btf_type *t)
-{
-	return btf_type_is_int(t) && t->size <= sizeof(u64);
-}
-
-static inline bool btf_type_is_enum(const struct btf_type *t)
-{
-	return BTF_INFO_KIND(t->info) == BTF_KIND_ENUM;
-}
-
-static inline bool btf_type_is_typedef(const struct btf_type *t)
-{
-	return BTF_INFO_KIND(t->info) == BTF_KIND_TYPEDEF;
-}
 
-static inline bool btf_type_is_func(const struct btf_type *t)
-{
-	return BTF_INFO_KIND(t->info) == BTF_KIND_FUNC;
-}
-
-static inline bool btf_type_is_func_proto(const struct btf_type *t)
-{
-	return BTF_INFO_KIND(t->info) == BTF_KIND_FUNC_PROTO;
-}
-
-static inline bool btf_type_is_var(const struct btf_type *t)
-{
-	return BTF_INFO_KIND(t->info) == BTF_KIND_VAR;
-}
-
-/* union is only a special case of struct:
- * all its offsetof(member) == 0
- */
-static inline bool btf_type_is_struct(const struct btf_type *t)
-{
-	u8 kind = BTF_INFO_KIND(t->info);
-
-	return kind == BTF_KIND_STRUCT || kind == BTF_KIND_UNION;
-}
-
-static inline u16 btf_type_vlen(const struct btf_type *t)
-{
-	return BTF_INFO_VLEN(t->info);
-}
-
-static inline u16 btf_func_linkage(const struct btf_type *t)
-{
-	return BTF_INFO_VLEN(t->info);
-}
 
 static inline bool btf_type_kflag(const struct btf_type *t)
 {
@@ -196,21 +90,12 @@ static inline u32 btf_member_bitfield_size(const struct btf_type *struct_type,
 					   : 0;
 }
 
-static inline const struct btf_member *btf_type_member(const struct btf_type *t)
-{
-	return (const struct btf_member *)(t + 1);
-}
-
-static inline const struct btf_var_secinfo *btf_type_var_secinfo(
-		const struct btf_type *t)
-{
-	return (const struct btf_var_secinfo *)(t + 1);
-}
-
 #ifdef CONFIG_BPF_SYSCALL
 struct bpf_prog;
 
 const struct btf_type *btf_type_by_id(const struct btf *btf, u32 type_id);
+const struct btf_type *btf_type_id_resolve(const struct btf *btf, u32 *type_id);
+bool btf_type_ids_resolved(const struct btf *btf);
 const char *btf_name_by_offset(const struct btf *btf, u32 offset);
 struct btf *btf_parse_vmlinux(void);
 struct btf *bpf_prog_get_target_btf(const struct bpf_prog *prog);
diff --git a/include/linux/btf_common.h b/include/linux/btf_common.h
new file mode 100644
index 0000000..4ec23f0
--- /dev/null
+++ b/include/linux/btf_common.h
@@ -0,0 +1,286 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (c) 2018 Facebook */
+/* Copyright (c) 2021, Oracle and/or its affiliates. */
+
+#ifndef _LINUX_BTF_COMMON_H
+#define _LINUX_BTF_COMMON_H 1
+
+/* Definitions and functions common to libbpf and kernel; current use case
+ * is to facilitate compilation of btf_show_common.c both for the kernel
+ * and libbpf; this allows us to share the code supporting display of BTF
+ * data between kernel and userspace.
+ */
+#include <linux/types.h>
+#include <uapi/linux/btf.h>
+#include <uapi/linux/bpf.h>
+
+#define BITS_PER_U128 (sizeof(u64) * BITS_PER_BYTE * 2)
+#define BITS_PER_BYTE_MASK (BITS_PER_BYTE - 1)
+#define BITS_PER_BYTE_MASKED(bits) ((bits) & BITS_PER_BYTE_MASK)
+#define BITS_ROUNDDOWN_BYTES(bits) ((bits) >> 3)
+#define BITS_ROUNDUP_BYTES(bits) \
+	(BITS_ROUNDDOWN_BYTES(bits) + !!BITS_PER_BYTE_MASKED(bits))
+
+struct btf;
+struct btf_member;
+struct btf_type;
+struct btf_show;
+
+#ifdef __KERNEL__
+
+const char *btf_str_by_offset(const struct btf *btf, u32 offset);
+void btf_type_seq_show(const struct btf *btf, u32 type_id, void *obj,
+		       struct seq_file *m);
+int btf_type_seq_show_flags(const struct btf *btf, u32 type_id, void *obj,
+			    struct seq_file *m, u64 flags);
+
+/* For kernel u64 is long long unsigned int... */
+#define FMT64		"ll"
+
+#else
+/* ...while for userspace it is long unsigned int.  These definitions avoid
+ * format specifier warnings.
+ */
+#define FMT64		"l"
+
+/* libbpf names differ slightly to in-kernel function names. */
+#define btf_type_by_id		btf__type_by_id
+#define btf_name_by_offset	btf__name_by_offset
+#define btf_str_by_offset	btf__str_by_offset
+#define btf_resolve_size	btf__resolve_size
+
+#endif /* __KERNEL__ */
+/*
+ * Options to control show behaviour.
+ *	- BTF_SHOW_COMPACT: no formatting around type information
+ *	- BTF_SHOW_NONAME: no struct/union member names/types
+ *	- BTF_SHOW_PTR_RAW: show raw (unobfuscated) pointer values;
+ *	  equivalent to %px.
+ *	- BTF_SHOW_ZERO: show zero-valued struct/union members; they
+ *	  are not displayed by default
+ *	- BTF_SHOW_UNSAFE: skip use of bpf_probe_read() to safely read
+ *	  data before displaying it.
+ */
+#define BTF_SHOW_COMPACT	BTF_F_COMPACT
+#define BTF_SHOW_NONAME		BTF_F_NONAME
+#define BTF_SHOW_PTR_RAW	BTF_F_PTR_RAW
+#define BTF_SHOW_ZERO		BTF_F_ZERO
+#define BTF_SHOW_UNSAFE		(1ULL << 4)
+
+/*
+ * Copy len bytes of string representation of obj of BTF type_id into buf.
+ *
+ * @btf: struct btf object
+ * @type_id: type id of type obj points to
+ * @obj: pointer to typed data
+ * @buf: buffer to write to
+ * @len: maximum length to write to buf
+ * @flags: show options (see above)
+ *
+ * Return: length that would have been/was copied as per snprintf, or
+ *	   negative error.
+ */
+int btf_type_snprintf_show(const struct btf *btf, u32 type_id, void *obj,
+			   char *buf, int len, u64 flags);
+
+#define for_each_member(i, struct_type, member)			\
+	for (i = 0, member = btf_type_member(struct_type);	\
+	     i < btf_type_vlen(struct_type);			\
+	     i++, member++)
+
+#define for_each_vsi(i, datasec_type, member)			\
+	for (i = 0, member = btf_type_var_secinfo(datasec_type);	\
+	     i < btf_type_vlen(datasec_type);			\
+	     i++, member++)
+
+static inline bool btf_type_is_ptr(const struct btf_type *t)
+{
+	return BTF_INFO_KIND(t->info) == BTF_KIND_PTR;
+}
+
+static inline bool btf_type_is_int(const struct btf_type *t)
+{
+	return BTF_INFO_KIND(t->info) == BTF_KIND_INT;
+}
+
+static inline bool btf_type_is_small_int(const struct btf_type *t)
+{
+	return btf_type_is_int(t) && t->size <= sizeof(u64);
+}
+
+static inline bool btf_type_is_enum(const struct btf_type *t)
+{
+	return BTF_INFO_KIND(t->info) == BTF_KIND_ENUM;
+}
+
+static inline bool btf_type_is_typedef(const struct btf_type *t)
+{
+	return BTF_INFO_KIND(t->info) == BTF_KIND_TYPEDEF;
+}
+
+static inline bool btf_type_is_func(const struct btf_type *t)
+{
+	return BTF_INFO_KIND(t->info) == BTF_KIND_FUNC;
+}
+
+static inline bool btf_type_is_func_proto(const struct btf_type *t)
+{
+	return BTF_INFO_KIND(t->info) == BTF_KIND_FUNC_PROTO;
+}
+
+static inline bool btf_type_is_var(const struct btf_type *t)
+{
+	return BTF_INFO_KIND(t->info) == BTF_KIND_VAR;
+}
+
+/* union is only a special case of struct:
+ * all its offsetof(member) == 0
+ */
+static inline bool btf_type_is_struct(const struct btf_type *t)
+{
+	u8 kind = BTF_INFO_KIND(t->info);
+
+	return kind == BTF_KIND_STRUCT || kind == BTF_KIND_UNION;
+}
+
+static inline bool btf_type_is_modifier(const struct btf_type *t)
+{
+	/* Some of them is not strictly a C modifier
+	 * but they are grouped into the same bucket
+	 * for BTF concern:
+	 *   A type (t) that refers to another
+	 *   type through t->type AND its size cannot
+	 *   be determined without following the t->type.
+	 *
+	 * ptr does not fall into this bucket
+	 * because its size is always sizeof(void *).
+	 */
+	switch (BTF_INFO_KIND(t->info)) {
+	case BTF_KIND_TYPEDEF:
+	case BTF_KIND_VOLATILE:
+	case BTF_KIND_CONST:
+	case BTF_KIND_RESTRICT:
+		return true;
+	default:
+		return false;
+	}
+}
+
+static inline
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
+static inline u32 btf_type_int(const struct btf_type *t)
+{
+	return *(u32 *)(t + 1);
+}
+
+static inline const struct btf_array *btf_type_array(const struct btf_type *t)
+{
+	return (const struct btf_array *)(t + 1);
+}
+
+static inline const struct btf_enum *btf_type_enum(const struct btf_type *t)
+{
+	return (const struct btf_enum *)(t + 1);
+}
+
+static inline const struct btf_var *btf_type_var(const struct btf_type *t)
+{
+	return (const struct btf_var *)(t + 1);
+}
+
+static inline u16 btf_type_vlen(const struct btf_type *t)
+{
+	return BTF_INFO_VLEN(t->info);
+}
+
+static inline u16 btf_func_linkage(const struct btf_type *t)
+{
+	return BTF_INFO_VLEN(t->info);
+}
+
+/* size can be used */
+static inline bool btf_type_has_size(const struct btf_type *t)
+{
+	switch (BTF_INFO_KIND(t->info)) {
+	case BTF_KIND_INT:
+	case BTF_KIND_STRUCT:
+	case BTF_KIND_UNION:
+	case BTF_KIND_ENUM:
+	case BTF_KIND_DATASEC:
+		return true;
+	default:
+		return false;
+	}
+}
+
+static inline const struct btf_member *btf_type_member(const struct btf_type *t)
+{
+	return (const struct btf_member *)(t + 1);
+}
+
+static inline const struct btf_var_secinfo *btf_type_var_secinfo(
+		const struct btf_type *t)
+{
+	return (const struct btf_var_secinfo *)(t + 1);
+}
+
+static inline const char *__btf_name_by_offset(const struct btf *btf,
+					       u32 offset)
+{
+	const char *name;
+
+	if (!offset)
+		return "(anon)";
+
+	name = btf_str_by_offset(btf, offset);
+	return name ?: "(invalid-name-offset)";
+}
+
+/* functions shared between btf.c and btf_show_common.c */
+void btf_type_ops_show(const struct btf *btf, const struct btf_type *t,
+		       __u32 type_id, void *obj, u8 bits_offset,
+		       struct btf_show *show);
+void btf_df_show(const struct btf *btf, const struct btf_type *t,
+		 u32 type_id, void *data, u8 bits_offset,
+		 struct btf_show *show);
+void btf_int_show(const struct btf *btf, const struct btf_type *t,
+		  u32 type_id, void *data, u8 bits_offset,
+		  struct btf_show *show);
+void btf_modifier_show(const struct btf *btf, const struct btf_type *t,
+		       u32 type_id, void *data, u8 bits_offset,
+		       struct btf_show *show);
+void btf_var_show(const struct btf *btf, const struct btf_type *t,
+		  u32 type_id, void *data, u8 bits_offset,
+		  struct btf_show *show);
+void btf_ptr_show(const struct btf *btf, const struct btf_type *t,
+		  u32 type_id, void *data, u8 bits_offset,
+		  struct btf_show *show);
+void btf_array_show(const struct btf *btf, const struct btf_type *t,
+		    u32 type_id, void *data, u8 bits_offset,
+		    struct btf_show *show);
+void btf_struct_show(const struct btf *btf, const struct btf_type *t,
+		     u32 type_id, void *data, u8 bits_offset,
+		     struct btf_show *show);
+void btf_enum_show(const struct btf *btf, const struct btf_type *t,
+		   u32 type_id, void *data, u8 bits_offset,
+		   struct btf_show *show);
+void btf_datasec_show(const struct btf *btf, const struct btf_type *t,
+		      u32 type_id, void *data, u8 bits_offset,
+		      struct btf_show *show);
+
+#endif
diff --git a/kernel/bpf/Makefile b/kernel/bpf/Makefile
index d124934..aecea20 100644
--- a/kernel/bpf/Makefile
+++ b/kernel/bpf/Makefile
@@ -13,7 +13,7 @@ obj-${CONFIG_BPF_LSM}	  += bpf_inode_storage.o
 obj-${CONFIG_BPF_LSM}	  += bpf_task_storage.o
 obj-$(CONFIG_BPF_SYSCALL) += disasm.o
 obj-$(CONFIG_BPF_JIT) += trampoline.o
-obj-$(CONFIG_BPF_SYSCALL) += btf.o
+obj-$(CONFIG_BPF_SYSCALL) += btf.o btf_show_common.o
 obj-$(CONFIG_BPF_JIT) += dispatcher.o
 ifeq ($(CONFIG_NET),y)
 obj-$(CONFIG_BPF_SYSCALL) += devmap.o
diff --git a/kernel/bpf/arraymap.c b/kernel/bpf/arraymap.c
index 1f84533..72f6d26 100644
--- a/kernel/bpf/arraymap.c
+++ b/kernel/bpf/arraymap.c
@@ -4,6 +4,7 @@
  */
 #include <linux/bpf.h>
 #include <linux/btf.h>
+#include <linux/btf_common.h>
 #include <linux/err.h>
 #include <linux/slab.h>
 #include <linux/mm.h>
diff --git a/kernel/bpf/bpf_struct_ops.c b/kernel/bpf/bpf_struct_ops.c
index 1a666a9..a7db2db 100644
--- a/kernel/bpf/bpf_struct_ops.c
+++ b/kernel/bpf/bpf_struct_ops.c
@@ -4,6 +4,7 @@
 #include <linux/bpf.h>
 #include <linux/bpf_verifier.h>
 #include <linux/btf.h>
+#include <linux/btf_common.h>
 #include <linux/filter.h>
 #include <linux/slab.h>
 #include <linux/numa.h>
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 8d6bdb4..01b85c1 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -18,6 +18,7 @@
 #include <linux/sort.h>
 #include <linux/bpf_verifier.h>
 #include <linux/btf.h>
+#include <linux/btf_common.h>
 #include <linux/btf_ids.h>
 #include <linux/skmsg.h>
 #include <linux/perf_event.h>
@@ -166,13 +167,6 @@
  *
  */
 
-#define BITS_PER_U128 (sizeof(u64) * BITS_PER_BYTE * 2)
-#define BITS_PER_BYTE_MASK (BITS_PER_BYTE - 1)
-#define BITS_PER_BYTE_MASKED(bits) ((bits) & BITS_PER_BYTE_MASK)
-#define BITS_ROUNDDOWN_BYTES(bits) ((bits) >> 3)
-#define BITS_ROUNDUP_BYTES(bits) \
-	(BITS_ROUNDDOWN_BYTES(bits) + !!BITS_PER_BYTE_MASKED(bits))
-
 #define BTF_INFO_MASK 0x8f00ffff
 #define BTF_INT_MASK 0x0fffffff
 #define BTF_TYPE_ID_VALID(type_id) ((type_id) <= BTF_MAX_TYPE)
@@ -287,91 +281,6 @@ static const char *btf_type_str(const struct btf_type *t)
 	return btf_kind_str[BTF_INFO_KIND(t->info)];
 }
 
-/* Chunk size we use in safe copy of data to be shown. */
-#define BTF_SHOW_OBJ_SAFE_SIZE		32
-
-/*
- * This is the maximum size of a base type value (equivalent to a
- * 128-bit int); if we are at the end of our safe buffer and have
- * less than 16 bytes space we can't be assured of being able
- * to copy the next type safely, so in such cases we will initiate
- * a new copy.
- */
-#define BTF_SHOW_OBJ_BASE_TYPE_SIZE	16
-
-/* Type name size */
-#define BTF_SHOW_NAME_SIZE		80
-
-/*
- * Common data to all BTF show operations. Private show functions can add
- * their own data to a structure containing a struct btf_show and consult it
- * in the show callback.  See btf_type_show() below.
- *
- * One challenge with showing nested data is we want to skip 0-valued
- * data, but in order to figure out whether a nested object is all zeros
- * we need to walk through it.  As a result, we need to make two passes
- * when handling structs, unions and arrays; the first path simply looks
- * for nonzero data, while the second actually does the display.  The first
- * pass is signalled by show->state.depth_check being set, and if we
- * encounter a non-zero value we set show->state.depth_to_show to
- * the depth at which we encountered it.  When we have completed the
- * first pass, we will know if anything needs to be displayed if
- * depth_to_show > depth.  See btf_[struct,array]_show() for the
- * implementation of this.
- *
- * Another problem is we want to ensure the data for display is safe to
- * access.  To support this, the anonymous "struct {} obj" tracks the data
- * object and our safe copy of it.  We copy portions of the data needed
- * to the object "copy" buffer, but because its size is limited to
- * BTF_SHOW_OBJ_COPY_LEN bytes, multiple copies may be required as we
- * traverse larger objects for display.
- *
- * The various data type show functions all start with a call to
- * btf_show_start_type() which returns a pointer to the safe copy
- * of the data needed (or if BTF_SHOW_UNSAFE is specified, to the
- * raw data itself).  btf_show_obj_safe() is responsible for
- * using copy_from_kernel_nofault() to update the safe data if necessary
- * as we traverse the object's data.  skbuff-like semantics are
- * used:
- *
- * - obj.head points to the start of the toplevel object for display
- * - obj.size is the size of the toplevel object
- * - obj.data points to the current point in the original data at
- *   which our safe data starts.  obj.data will advance as we copy
- *   portions of the data.
- *
- * In most cases a single copy will suffice, but larger data structures
- * such as "struct task_struct" will require many copies.  The logic in
- * btf_show_obj_safe() handles the logic that determines if a new
- * copy_from_kernel_nofault() is needed.
- */
-struct btf_show {
-	u64 flags;
-	void *target;	/* target of show operation (seq file, buffer) */
-	void (*showfn)(struct btf_show *show, const char *fmt, va_list args);
-	const struct btf *btf;
-	/* below are used during iteration */
-	struct {
-		u8 depth;
-		u8 depth_to_show;
-		u8 depth_check;
-		u8 array_member:1,
-		   array_terminated:1;
-		u16 array_encoding;
-		u32 type_id;
-		int status;			/* non-zero for error */
-		const struct btf_type *type;
-		const struct btf_member *member;
-		char name[BTF_SHOW_NAME_SIZE];	/* space for member name/type */
-	} state;
-	struct {
-		u32 size;
-		void *head;
-		void *data;
-		u8 safe[BTF_SHOW_OBJ_SAFE_SIZE];
-	} obj;
-};
-
 struct btf_kind_operations {
 	s32 (*check_meta)(struct btf_verifier_env *env,
 			  const struct btf_type *t,
@@ -399,29 +308,6 @@ struct btf_kind_operations {
 static int btf_resolve(struct btf_verifier_env *env,
 		       const struct btf_type *t, u32 type_id);
 
-static bool btf_type_is_modifier(const struct btf_type *t)
-{
-	/* Some of them is not strictly a C modifier
-	 * but they are grouped into the same bucket
-	 * for BTF concern:
-	 *   A type (t) that refers to another
-	 *   type through t->type AND its size cannot
-	 *   be determined without following the t->type.
-	 *
-	 * ptr does not fall into this bucket
-	 * because its size is always sizeof(void *).
-	 */
-	switch (BTF_INFO_KIND(t->info)) {
-	case BTF_KIND_TYPEDEF:
-	case BTF_KIND_VOLATILE:
-	case BTF_KIND_CONST:
-	case BTF_KIND_RESTRICT:
-		return true;
-	}
-
-	return false;
-}
-
 bool btf_type_is_void(const struct btf_type *t)
 {
 	return t == &btf_void;
@@ -490,22 +376,6 @@ s32 btf_find_by_name_kind(const struct btf *btf, const char *name, u8 kind)
 	return -ENOENT;
 }
 
-const struct btf_type *btf_type_skip_modifiers(const struct btf *btf,
-					       u32 id, u32 *res_id)
-{
-	const struct btf_type *t = btf_type_by_id(btf, id);
-
-	while (btf_type_is_modifier(t)) {
-		id = t->type;
-		t = btf_type_by_id(btf, t->type);
-	}
-
-	if (res_id)
-		*res_id = id;
-
-	return t;
-}
-
 const struct btf_type *btf_type_resolve_ptr(const struct btf *btf,
 					    u32 id, u32 *res_id)
 {
@@ -565,21 +435,6 @@ static bool btf_type_needs_resolve(const struct btf_type *t)
 	       btf_type_is_datasec(t);
 }
 
-/* t->size can be used */
-static bool btf_type_has_size(const struct btf_type *t)
-{
-	switch (BTF_INFO_KIND(t->info)) {
-	case BTF_KIND_INT:
-	case BTF_KIND_STRUCT:
-	case BTF_KIND_UNION:
-	case BTF_KIND_ENUM:
-	case BTF_KIND_DATASEC:
-		return true;
-	}
-
-	return false;
-}
-
 static const char *btf_int_encoding_str(u8 encoding)
 {
 	if (encoding == 0)
@@ -594,29 +449,17 @@ static const char *btf_int_encoding_str(u8 encoding)
 		return "UNKN";
 }
 
-static u32 btf_type_int(const struct btf_type *t)
-{
-	return *(u32 *)(t + 1);
-}
-
-static const struct btf_array *btf_type_array(const struct btf_type *t)
-{
-	return (const struct btf_array *)(t + 1);
-}
-
-static const struct btf_enum *btf_type_enum(const struct btf_type *t)
-{
-	return (const struct btf_enum *)(t + 1);
-}
-
-static const struct btf_var *btf_type_var(const struct btf_type *t)
+static const struct btf_kind_operations *btf_type_ops(const struct btf_type *t)
 {
-	return (const struct btf_var *)(t + 1);
+	return kind_ops[BTF_INFO_KIND(t->info)];
 }
 
-static const struct btf_kind_operations *btf_type_ops(const struct btf_type *t)
+void btf_type_ops_show(const struct btf *btf, const struct btf_type *t,
+		       __u32 type_id, void *obj, u8 bits_offset,
+		       struct btf_show *show)
 {
-	return kind_ops[BTF_INFO_KIND(t->info)];
+	kind_ops[BTF_INFO_KIND(t->info)]->show(btf, t, type_id, obj,
+					       bits_offset, show);
 }
 
 static bool btf_name_offset_valid(const struct btf *btf, u32 offset)
@@ -642,7 +485,7 @@ static bool __btf_name_char_ok(char c, bool first, bool dot_ok)
 	return true;
 }
 
-static const char *btf_str_by_offset(const struct btf *btf, u32 offset)
+const char *btf_str_by_offset(const struct btf *btf, u32 offset)
 {
 	while (offset < btf->start_str_off)
 		btf = btf->base_btf;
@@ -688,17 +531,6 @@ static bool btf_name_valid_section(const struct btf *btf, u32 offset)
 	return __btf_name_valid(btf, offset, true);
 }
 
-static const char *__btf_name_by_offset(const struct btf *btf, u32 offset)
-{
-	const char *name;
-
-	if (!offset)
-		return "(anon)";
-
-	name = btf_str_by_offset(btf, offset);
-	return name ?: "(invalid-name-offset)";
-}
-
 const char *btf_name_by_offset(const struct btf *btf, u32 offset)
 {
 	return btf_str_by_offset(btf, offset);
@@ -779,488 +611,6 @@ bool btf_member_is_reg_int(const struct btf *btf, const struct btf_type *s,
 	return true;
 }
 
-/* Similar to btf_type_skip_modifiers() but does not skip typedefs. */
-static const struct btf_type *btf_type_skip_qualifiers(const struct btf *btf,
-						       u32 id)
-{
-	const struct btf_type *t = btf_type_by_id(btf, id);
-
-	while (btf_type_is_modifier(t) &&
-	       BTF_INFO_KIND(t->info) != BTF_KIND_TYPEDEF) {
-		id = t->type;
-		t = btf_type_by_id(btf, t->type);
-	}
-
-	return t;
-}
-
-#define BTF_SHOW_MAX_ITER	10
-
-#define BTF_KIND_BIT(kind)	(1ULL << kind)
-
-/*
- * Populate show->state.name with type name information.
- * Format of type name is
- *
- * [.member_name = ] (type_name)
- */
-static const char *btf_show_name(struct btf_show *show)
-{
-	/* BTF_MAX_ITER array suffixes "[]" */
-	const char *array_suffixes = "[][][][][][][][][][]";
-	const char *array_suffix = &array_suffixes[strlen(array_suffixes)];
-	/* BTF_MAX_ITER pointer suffixes "*" */
-	const char *ptr_suffixes = "**********";
-	const char *ptr_suffix = &ptr_suffixes[strlen(ptr_suffixes)];
-	const char *name = NULL, *prefix = "", *parens = "";
-	const struct btf_member *m = show->state.member;
-	const struct btf_type *t = show->state.type;
-	const struct btf_array *array;
-	u32 id = show->state.type_id;
-	const char *member = NULL;
-	bool show_member = false;
-	u64 kinds = 0;
-	int i;
-
-	show->state.name[0] = '\0';
-
-	/*
-	 * Don't show type name if we're showing an array member;
-	 * in that case we show the array type so don't need to repeat
-	 * ourselves for each member.
-	 */
-	if (show->state.array_member)
-		return "";
-
-	/* Retrieve member name, if any. */
-	if (m) {
-		member = btf_name_by_offset(show->btf, m->name_off);
-		show_member = strlen(member) > 0;
-		id = m->type;
-	}
-
-	/*
-	 * Start with type_id, as we have resolved the struct btf_type *
-	 * via btf_modifier_show() past the parent typedef to the child
-	 * struct, int etc it is defined as.  In such cases, the type_id
-	 * still represents the starting type while the struct btf_type *
-	 * in our show->state points at the resolved type of the typedef.
-	 */
-	t = btf_type_by_id(show->btf, id);
-	if (!t)
-		return "";
-
-	/*
-	 * The goal here is to build up the right number of pointer and
-	 * array suffixes while ensuring the type name for a typedef
-	 * is represented.  Along the way we accumulate a list of
-	 * BTF kinds we have encountered, since these will inform later
-	 * display; for example, pointer types will not require an
-	 * opening "{" for struct, we will just display the pointer value.
-	 *
-	 * We also want to accumulate the right number of pointer or array
-	 * indices in the format string while iterating until we get to
-	 * the typedef/pointee/array member target type.
-	 *
-	 * We start by pointing at the end of pointer and array suffix
-	 * strings; as we accumulate pointers and arrays we move the pointer
-	 * or array string backwards so it will show the expected number of
-	 * '*' or '[]' for the type.  BTF_SHOW_MAX_ITER of nesting of pointers
-	 * and/or arrays and typedefs are supported as a precaution.
-	 *
-	 * We also want to get typedef name while proceeding to resolve
-	 * type it points to so that we can add parentheses if it is a
-	 * "typedef struct" etc.
-	 */
-	for (i = 0; i < BTF_SHOW_MAX_ITER; i++) {
-
-		switch (BTF_INFO_KIND(t->info)) {
-		case BTF_KIND_TYPEDEF:
-			if (!name)
-				name = btf_name_by_offset(show->btf,
-							       t->name_off);
-			kinds |= BTF_KIND_BIT(BTF_KIND_TYPEDEF);
-			id = t->type;
-			break;
-		case BTF_KIND_ARRAY:
-			kinds |= BTF_KIND_BIT(BTF_KIND_ARRAY);
-			parens = "[";
-			if (!t)
-				return "";
-			array = btf_type_array(t);
-			if (array_suffix > array_suffixes)
-				array_suffix -= 2;
-			id = array->type;
-			break;
-		case BTF_KIND_PTR:
-			kinds |= BTF_KIND_BIT(BTF_KIND_PTR);
-			if (ptr_suffix > ptr_suffixes)
-				ptr_suffix -= 1;
-			id = t->type;
-			break;
-		default:
-			id = 0;
-			break;
-		}
-		if (!id)
-			break;
-		t = btf_type_skip_qualifiers(show->btf, id);
-	}
-	/* We may not be able to represent this type; bail to be safe */
-	if (i == BTF_SHOW_MAX_ITER)
-		return "";
-
-	if (!name)
-		name = btf_name_by_offset(show->btf, t->name_off);
-
-	switch (BTF_INFO_KIND(t->info)) {
-	case BTF_KIND_STRUCT:
-	case BTF_KIND_UNION:
-		prefix = BTF_INFO_KIND(t->info) == BTF_KIND_STRUCT ?
-			 "struct" : "union";
-		/* if it's an array of struct/union, parens is already set */
-		if (!(kinds & (BTF_KIND_BIT(BTF_KIND_ARRAY))))
-			parens = "{";
-		break;
-	case BTF_KIND_ENUM:
-		prefix = "enum";
-		break;
-	default:
-		break;
-	}
-
-	/* pointer does not require parens */
-	if (kinds & BTF_KIND_BIT(BTF_KIND_PTR))
-		parens = "";
-	/* typedef does not require struct/union/enum prefix */
-	if (kinds & BTF_KIND_BIT(BTF_KIND_TYPEDEF))
-		prefix = "";
-
-	if (!name)
-		name = "";
-
-	/* Even if we don't want type name info, we want parentheses etc */
-	if (show->flags & BTF_SHOW_NONAME)
-		snprintf(show->state.name, sizeof(show->state.name), "%s",
-			 parens);
-	else
-		snprintf(show->state.name, sizeof(show->state.name),
-			 "%s%s%s(%s%s%s%s%s%s)%s",
-			 /* first 3 strings comprise ".member = " */
-			 show_member ? "." : "",
-			 show_member ? member : "",
-			 show_member ? " = " : "",
-			 /* ...next is our prefix (struct, enum, etc) */
-			 prefix,
-			 strlen(prefix) > 0 && strlen(name) > 0 ? " " : "",
-			 /* ...this is the type name itself */
-			 name,
-			 /* ...suffixed by the appropriate '*', '[]' suffixes */
-			 strlen(ptr_suffix) > 0 ? " " : "", ptr_suffix,
-			 array_suffix, parens);
-
-	return show->state.name;
-}
-
-static const char *__btf_show_indent(struct btf_show *show)
-{
-	const char *indents = "                                ";
-	const char *indent = &indents[strlen(indents)];
-
-	if ((indent - show->state.depth) >= indents)
-		return indent - show->state.depth;
-	return indents;
-}
-
-static const char *btf_show_indent(struct btf_show *show)
-{
-	return show->flags & BTF_SHOW_COMPACT ? "" : __btf_show_indent(show);
-}
-
-static const char *btf_show_newline(struct btf_show *show)
-{
-	return show->flags & BTF_SHOW_COMPACT ? "" : "\n";
-}
-
-static const char *btf_show_delim(struct btf_show *show)
-{
-	if (show->state.depth == 0)
-		return "";
-
-	if ((show->flags & BTF_SHOW_COMPACT) && show->state.type &&
-		BTF_INFO_KIND(show->state.type->info) == BTF_KIND_UNION)
-		return "|";
-
-	return ",";
-}
-
-__printf(2, 3) static void btf_show(struct btf_show *show, const char *fmt, ...)
-{
-	va_list args;
-
-	if (!show->state.depth_check) {
-		va_start(args, fmt);
-		show->showfn(show, fmt, args);
-		va_end(args);
-	}
-}
-
-/* Macros are used here as btf_show_type_value[s]() prepends and appends
- * format specifiers to the format specifier passed in; these do the work of
- * adding indentation, delimiters etc while the caller simply has to specify
- * the type value(s) in the format specifier + value(s).
- */
-#define btf_show_type_value(show, fmt, value)				       \
-	do {								       \
-		if ((value) != 0 || (show->flags & BTF_SHOW_ZERO) ||	       \
-		    show->state.depth == 0) {				       \
-			btf_show(show, "%s%s" fmt "%s%s",		       \
-				 btf_show_indent(show),			       \
-				 btf_show_name(show),			       \
-				 value, btf_show_delim(show),		       \
-				 btf_show_newline(show));		       \
-			if (show->state.depth > show->state.depth_to_show)     \
-				show->state.depth_to_show = show->state.depth; \
-		}							       \
-	} while (0)
-
-#define btf_show_type_values(show, fmt, ...)				       \
-	do {								       \
-		btf_show(show, "%s%s" fmt "%s%s", btf_show_indent(show),       \
-			 btf_show_name(show),				       \
-			 __VA_ARGS__, btf_show_delim(show),		       \
-			 btf_show_newline(show));			       \
-		if (show->state.depth > show->state.depth_to_show)	       \
-			show->state.depth_to_show = show->state.depth;	       \
-	} while (0)
-
-/* How much is left to copy to safe buffer after @data? */
-static int btf_show_obj_size_left(struct btf_show *show, void *data)
-{
-	return show->obj.head + show->obj.size - data;
-}
-
-/* Is object pointed to by @data of @size already copied to our safe buffer? */
-static bool btf_show_obj_is_safe(struct btf_show *show, void *data, int size)
-{
-	return data >= show->obj.data &&
-	       (data + size) < (show->obj.data + BTF_SHOW_OBJ_SAFE_SIZE);
-}
-
-/*
- * If object pointed to by @data of @size falls within our safe buffer, return
- * the equivalent pointer to the same safe data.  Assumes
- * copy_from_kernel_nofault() has already happened and our safe buffer is
- * populated.
- */
-static void *__btf_show_obj_safe(struct btf_show *show, void *data, int size)
-{
-	if (btf_show_obj_is_safe(show, data, size))
-		return show->obj.safe + (data - show->obj.data);
-	return NULL;
-}
-
-/*
- * Return a safe-to-access version of data pointed to by @data.
- * We do this by copying the relevant amount of information
- * to the struct btf_show obj.safe buffer using copy_from_kernel_nofault().
- *
- * If BTF_SHOW_UNSAFE is specified, just return data as-is; no
- * safe copy is needed.
- *
- * Otherwise we need to determine if we have the required amount
- * of data (determined by the @data pointer and the size of the
- * largest base type we can encounter (represented by
- * BTF_SHOW_OBJ_BASE_TYPE_SIZE). Having that much data ensures
- * that we will be able to print some of the current object,
- * and if more is needed a copy will be triggered.
- * Some objects such as structs will not fit into the buffer;
- * in such cases additional copies when we iterate over their
- * members may be needed.
- *
- * btf_show_obj_safe() is used to return a safe buffer for
- * btf_show_start_type(); this ensures that as we recurse into
- * nested types we always have safe data for the given type.
- * This approach is somewhat wasteful; it's possible for example
- * that when iterating over a large union we'll end up copying the
- * same data repeatedly, but the goal is safety not performance.
- * We use stack data as opposed to per-CPU buffers because the
- * iteration over a type can take some time, and preemption handling
- * would greatly complicate use of the safe buffer.
- */
-static void *btf_show_obj_safe(struct btf_show *show,
-			       const struct btf_type *t,
-			       void *data)
-{
-	const struct btf_type *rt;
-	int size_left, size;
-	void *safe = NULL;
-
-	if (show->flags & BTF_SHOW_UNSAFE)
-		return data;
-
-	rt = btf_resolve_size(show->btf, t, &size);
-	if (IS_ERR(rt)) {
-		show->state.status = PTR_ERR(rt);
-		return NULL;
-	}
-
-	/*
-	 * Is this toplevel object? If so, set total object size and
-	 * initialize pointers.  Otherwise check if we still fall within
-	 * our safe object data.
-	 */
-	if (show->state.depth == 0) {
-		show->obj.size = size;
-		show->obj.head = data;
-	} else {
-		/*
-		 * If the size of the current object is > our remaining
-		 * safe buffer we _may_ need to do a new copy.  However
-		 * consider the case of a nested struct; it's size pushes
-		 * us over the safe buffer limit, but showing any individual
-		 * struct members does not.  In such cases, we don't need
-		 * to initiate a fresh copy yet; however we definitely need
-		 * at least BTF_SHOW_OBJ_BASE_TYPE_SIZE bytes left
-		 * in our buffer, regardless of the current object size.
-		 * The logic here is that as we resolve types we will
-		 * hit a base type at some point, and we need to be sure
-		 * the next chunk of data is safely available to display
-		 * that type info safely.  We cannot rely on the size of
-		 * the current object here because it may be much larger
-		 * than our current buffer (e.g. task_struct is 8k).
-		 * All we want to do here is ensure that we can print the
-		 * next basic type, which we can if either
-		 * - the current type size is within the safe buffer; or
-		 * - at least BTF_SHOW_OBJ_BASE_TYPE_SIZE bytes are left in
-		 *   the safe buffer.
-		 */
-		safe = __btf_show_obj_safe(show, data,
-					   min(size,
-					       BTF_SHOW_OBJ_BASE_TYPE_SIZE));
-	}
-
-	/*
-	 * We need a new copy to our safe object, either because we haven't
-	 * yet copied and are intializing safe data, or because the data
-	 * we want falls outside the boundaries of the safe object.
-	 */
-	if (!safe) {
-		size_left = btf_show_obj_size_left(show, data);
-		if (size_left > BTF_SHOW_OBJ_SAFE_SIZE)
-			size_left = BTF_SHOW_OBJ_SAFE_SIZE;
-		show->state.status = copy_from_kernel_nofault(show->obj.safe,
-							      data, size_left);
-		if (!show->state.status) {
-			show->obj.data = data;
-			safe = show->obj.safe;
-		}
-	}
-
-	return safe;
-}
-
-/*
- * Set the type we are starting to show and return a safe data pointer
- * to be used for showing the associated data.
- */
-static void *btf_show_start_type(struct btf_show *show,
-				 const struct btf_type *t,
-				 u32 type_id, void *data)
-{
-	show->state.type = t;
-	show->state.type_id = type_id;
-	show->state.name[0] = '\0';
-
-	return btf_show_obj_safe(show, t, data);
-}
-
-static void btf_show_end_type(struct btf_show *show)
-{
-	show->state.type = NULL;
-	show->state.type_id = 0;
-	show->state.name[0] = '\0';
-}
-
-static void *btf_show_start_aggr_type(struct btf_show *show,
-				      const struct btf_type *t,
-				      u32 type_id, void *data)
-{
-	void *safe_data = btf_show_start_type(show, t, type_id, data);
-
-	if (!safe_data)
-		return safe_data;
-
-	btf_show(show, "%s%s%s", btf_show_indent(show),
-		 btf_show_name(show),
-		 btf_show_newline(show));
-	show->state.depth++;
-	return safe_data;
-}
-
-static void btf_show_end_aggr_type(struct btf_show *show,
-				   const char *suffix)
-{
-	show->state.depth--;
-	btf_show(show, "%s%s%s%s", btf_show_indent(show), suffix,
-		 btf_show_delim(show), btf_show_newline(show));
-	btf_show_end_type(show);
-}
-
-static void btf_show_start_member(struct btf_show *show,
-				  const struct btf_member *m)
-{
-	show->state.member = m;
-}
-
-static void btf_show_start_array_member(struct btf_show *show)
-{
-	show->state.array_member = 1;
-	btf_show_start_member(show, NULL);
-}
-
-static void btf_show_end_member(struct btf_show *show)
-{
-	show->state.member = NULL;
-}
-
-static void btf_show_end_array_member(struct btf_show *show)
-{
-	show->state.array_member = 0;
-	btf_show_end_member(show);
-}
-
-static void *btf_show_start_array_type(struct btf_show *show,
-				       const struct btf_type *t,
-				       u32 type_id,
-				       u16 array_encoding,
-				       void *data)
-{
-	show->state.array_encoding = array_encoding;
-	show->state.array_terminated = 0;
-	return btf_show_start_aggr_type(show, t, type_id, data);
-}
-
-static void btf_show_end_array_type(struct btf_show *show)
-{
-	show->state.array_encoding = 0;
-	show->state.array_terminated = 0;
-	btf_show_end_aggr_type(show, "]");
-}
-
-static void *btf_show_start_struct_type(struct btf_show *show,
-					const struct btf_type *t,
-					u32 type_id,
-					void *data)
-{
-	return btf_show_start_aggr_type(show, t, type_id, data);
-}
-
-static void btf_show_end_struct_type(struct btf_show *show)
-{
-	btf_show_end_aggr_type(show, "}");
-}
-
 __printf(2, 3) static void __btf_verifier_log(struct bpf_verifier_log *log,
 					      const char *fmt, ...)
 {
@@ -1771,13 +1121,18 @@ static u32 btf_resolved_type_id(const struct btf *btf, u32 type_id)
 }
 
 /* The input param "type_id" must point to a needs_resolve type */
-static const struct btf_type *btf_type_id_resolve(const struct btf *btf,
-						  u32 *type_id)
+const struct btf_type *btf_type_id_resolve(const struct btf *btf,
+					   u32 *type_id)
 {
 	*type_id = btf_resolved_type_id(btf, *type_id);
 	return btf_type_by_id(btf, *type_id);
 }
 
+bool btf_type_ids_resolved(const struct btf *btf)
+{
+	return btf->resolved_ids;
+}
+
 static u32 btf_resolved_type_size(const struct btf *btf, u32 type_id)
 {
 	while (type_id < btf->start_id)
@@ -1878,13 +1233,6 @@ static int btf_df_resolve(struct btf_verifier_env *env,
 	return -EINVAL;
 }
 
-static void btf_df_show(const struct btf *btf, const struct btf_type *t,
-			u32 type_id, void *data, u8 bits_offsets,
-			struct btf_show *show)
-{
-	btf_show(show, "<unsupported kind:%u>", BTF_INFO_KIND(t->info));
-}
-
 static int btf_int_check_member(struct btf_verifier_env *env,
 				const struct btf_type *struct_type,
 				const struct btf_member *member,
@@ -2055,186 +1403,6 @@ static void btf_int_log(struct btf_verifier_env *env,
 			 btf_int_encoding_str(BTF_INT_ENCODING(int_data)));
 }
 
-static void btf_int128_print(struct btf_show *show, void *data)
-{
-	/* data points to a __int128 number.
-	 * Suppose
-	 *     int128_num = *(__int128 *)data;
-	 * The below formulas shows what upper_num and lower_num represents:
-	 *     upper_num = int128_num >> 64;
-	 *     lower_num = int128_num & 0xffffffffFFFFFFFFULL;
-	 */
-	u64 upper_num, lower_num;
-
-#ifdef __BIG_ENDIAN_BITFIELD
-	upper_num = *(u64 *)data;
-	lower_num = *(u64 *)(data + 8);
-#else
-	upper_num = *(u64 *)(data + 8);
-	lower_num = *(u64 *)data;
-#endif
-	if (upper_num == 0)
-		btf_show_type_value(show, "0x%llx", lower_num);
-	else
-		btf_show_type_values(show, "0x%llx%016llx", upper_num,
-				     lower_num);
-}
-
-static void btf_int128_shift(u64 *print_num, u16 left_shift_bits,
-			     u16 right_shift_bits)
-{
-	u64 upper_num, lower_num;
-
-#ifdef __BIG_ENDIAN_BITFIELD
-	upper_num = print_num[0];
-	lower_num = print_num[1];
-#else
-	upper_num = print_num[1];
-	lower_num = print_num[0];
-#endif
-
-	/* shake out un-needed bits by shift/or operations */
-	if (left_shift_bits >= 64) {
-		upper_num = lower_num << (left_shift_bits - 64);
-		lower_num = 0;
-	} else {
-		upper_num = (upper_num << left_shift_bits) |
-			    (lower_num >> (64 - left_shift_bits));
-		lower_num = lower_num << left_shift_bits;
-	}
-
-	if (right_shift_bits >= 64) {
-		lower_num = upper_num >> (right_shift_bits - 64);
-		upper_num = 0;
-	} else {
-		lower_num = (lower_num >> right_shift_bits) |
-			    (upper_num << (64 - right_shift_bits));
-		upper_num = upper_num >> right_shift_bits;
-	}
-
-#ifdef __BIG_ENDIAN_BITFIELD
-	print_num[0] = upper_num;
-	print_num[1] = lower_num;
-#else
-	print_num[0] = lower_num;
-	print_num[1] = upper_num;
-#endif
-}
-
-static void btf_bitfield_show(void *data, u8 bits_offset,
-			      u8 nr_bits, struct btf_show *show)
-{
-	u16 left_shift_bits, right_shift_bits;
-	u8 nr_copy_bytes;
-	u8 nr_copy_bits;
-	u64 print_num[2] = {};
-
-	nr_copy_bits = nr_bits + bits_offset;
-	nr_copy_bytes = BITS_ROUNDUP_BYTES(nr_copy_bits);
-
-	memcpy(print_num, data, nr_copy_bytes);
-
-#ifdef __BIG_ENDIAN_BITFIELD
-	left_shift_bits = bits_offset;
-#else
-	left_shift_bits = BITS_PER_U128 - nr_copy_bits;
-#endif
-	right_shift_bits = BITS_PER_U128 - nr_bits;
-
-	btf_int128_shift(print_num, left_shift_bits, right_shift_bits);
-	btf_int128_print(show, print_num);
-}
-
-
-static void btf_int_bits_show(const struct btf *btf,
-			      const struct btf_type *t,
-			      void *data, u8 bits_offset,
-			      struct btf_show *show)
-{
-	u32 int_data = btf_type_int(t);
-	u8 nr_bits = BTF_INT_BITS(int_data);
-	u8 total_bits_offset;
-
-	/*
-	 * bits_offset is at most 7.
-	 * BTF_INT_OFFSET() cannot exceed 128 bits.
-	 */
-	total_bits_offset = bits_offset + BTF_INT_OFFSET(int_data);
-	data += BITS_ROUNDDOWN_BYTES(total_bits_offset);
-	bits_offset = BITS_PER_BYTE_MASKED(total_bits_offset);
-	btf_bitfield_show(data, bits_offset, nr_bits, show);
-}
-
-static void btf_int_show(const struct btf *btf, const struct btf_type *t,
-			 u32 type_id, void *data, u8 bits_offset,
-			 struct btf_show *show)
-{
-	u32 int_data = btf_type_int(t);
-	u8 encoding = BTF_INT_ENCODING(int_data);
-	bool sign = encoding & BTF_INT_SIGNED;
-	u8 nr_bits = BTF_INT_BITS(int_data);
-	void *safe_data;
-
-	safe_data = btf_show_start_type(show, t, type_id, data);
-	if (!safe_data)
-		return;
-
-	if (bits_offset || BTF_INT_OFFSET(int_data) ||
-	    BITS_PER_BYTE_MASKED(nr_bits)) {
-		btf_int_bits_show(btf, t, safe_data, bits_offset, show);
-		goto out;
-	}
-
-	switch (nr_bits) {
-	case 128:
-		btf_int128_print(show, safe_data);
-		break;
-	case 64:
-		if (sign)
-			btf_show_type_value(show, "%lld", *(s64 *)safe_data);
-		else
-			btf_show_type_value(show, "%llu", *(u64 *)safe_data);
-		break;
-	case 32:
-		if (sign)
-			btf_show_type_value(show, "%d", *(s32 *)safe_data);
-		else
-			btf_show_type_value(show, "%u", *(u32 *)safe_data);
-		break;
-	case 16:
-		if (sign)
-			btf_show_type_value(show, "%d", *(s16 *)safe_data);
-		else
-			btf_show_type_value(show, "%u", *(u16 *)safe_data);
-		break;
-	case 8:
-		if (show->state.array_encoding == BTF_INT_CHAR) {
-			/* check for null terminator */
-			if (show->state.array_terminated)
-				break;
-			if (*(char *)data == '\0') {
-				show->state.array_terminated = 1;
-				break;
-			}
-			if (isprint(*(char *)data)) {
-				btf_show_type_value(show, "'%c'",
-						    *(char *)safe_data);
-				break;
-			}
-		}
-		if (sign)
-			btf_show_type_value(show, "%d", *(s8 *)safe_data);
-		else
-			btf_show_type_value(show, "%u", *(u8 *)safe_data);
-		break;
-	default:
-		btf_int_bits_show(btf, t, safe_data, bits_offset, show);
-		break;
-	}
-out:
-	btf_show_end_type(show);
-}
-
 static const struct btf_kind_operations int_ops = {
 	.check_meta = btf_int_check_meta,
 	.resolve = btf_df_resolve,
@@ -2505,46 +1673,6 @@ static int btf_ptr_resolve(struct btf_verifier_env *env,
 	return 0;
 }
 
-static void btf_modifier_show(const struct btf *btf,
-			      const struct btf_type *t,
-			      u32 type_id, void *data,
-			      u8 bits_offset, struct btf_show *show)
-{
-	if (btf->resolved_ids)
-		t = btf_type_id_resolve(btf, &type_id);
-	else
-		t = btf_type_skip_modifiers(btf, type_id, NULL);
-
-	btf_type_ops(t)->show(btf, t, type_id, data, bits_offset, show);
-}
-
-static void btf_var_show(const struct btf *btf, const struct btf_type *t,
-			 u32 type_id, void *data, u8 bits_offset,
-			 struct btf_show *show)
-{
-	t = btf_type_id_resolve(btf, &type_id);
-
-	btf_type_ops(t)->show(btf, t, type_id, data, bits_offset, show);
-}
-
-static void btf_ptr_show(const struct btf *btf, const struct btf_type *t,
-			 u32 type_id, void *data, u8 bits_offset,
-			 struct btf_show *show)
-{
-	void *safe_data;
-
-	safe_data = btf_show_start_type(show, t, type_id, data);
-	if (!safe_data)
-		return;
-
-	/* It is a hashed value unless BTF_SHOW_PTR_RAW is specified */
-	if (show->flags & BTF_SHOW_PTR_RAW)
-		btf_show_type_value(show, "0x%px", *(void **)safe_data);
-	else
-		btf_show_type_value(show, "0x%p", *(void **)safe_data);
-	btf_show_end_type(show);
-}
-
 static void btf_ref_type_log(struct btf_verifier_env *env,
 			     const struct btf_type *t)
 {
@@ -2766,92 +1894,6 @@ static void btf_array_log(struct btf_verifier_env *env,
 			 array->type, array->index_type, array->nelems);
 }
 
-static void __btf_array_show(const struct btf *btf, const struct btf_type *t,
-			     u32 type_id, void *data, u8 bits_offset,
-			     struct btf_show *show)
-{
-	const struct btf_array *array = btf_type_array(t);
-	const struct btf_kind_operations *elem_ops;
-	const struct btf_type *elem_type;
-	u32 i, elem_size = 0, elem_type_id;
-	u16 encoding = 0;
-
-	elem_type_id = array->type;
-	elem_type = btf_type_skip_modifiers(btf, elem_type_id, NULL);
-	if (elem_type && btf_type_has_size(elem_type))
-		elem_size = elem_type->size;
-
-	if (elem_type && btf_type_is_int(elem_type)) {
-		u32 int_type = btf_type_int(elem_type);
-
-		encoding = BTF_INT_ENCODING(int_type);
-
-		/*
-		 * BTF_INT_CHAR encoding never seems to be set for
-		 * char arrays, so if size is 1 and element is
-		 * printable as a char, we'll do that.
-		 */
-		if (elem_size == 1)
-			encoding = BTF_INT_CHAR;
-	}
-
-	if (!btf_show_start_array_type(show, t, type_id, encoding, data))
-		return;
-
-	if (!elem_type)
-		goto out;
-	elem_ops = btf_type_ops(elem_type);
-
-	for (i = 0; i < array->nelems; i++) {
-
-		btf_show_start_array_member(show);
-
-		elem_ops->show(btf, elem_type, elem_type_id, data,
-			       bits_offset, show);
-		data += elem_size;
-
-		btf_show_end_array_member(show);
-
-		if (show->state.array_terminated)
-			break;
-	}
-out:
-	btf_show_end_array_type(show);
-}
-
-static void btf_array_show(const struct btf *btf, const struct btf_type *t,
-			   u32 type_id, void *data, u8 bits_offset,
-			   struct btf_show *show)
-{
-	const struct btf_member *m = show->state.member;
-
-	/*
-	 * First check if any members would be shown (are non-zero).
-	 * See comments above "struct btf_show" definition for more
-	 * details on how this works at a high-level.
-	 */
-	if (show->state.depth > 0 && !(show->flags & BTF_SHOW_ZERO)) {
-		if (!show->state.depth_check) {
-			show->state.depth_check = show->state.depth + 1;
-			show->state.depth_to_show = 0;
-		}
-		__btf_array_show(btf, t, type_id, data, bits_offset, show);
-		show->state.member = m;
-
-		if (show->state.depth_check != show->state.depth + 1)
-			return;
-		show->state.depth_check = 0;
-
-		if (show->state.depth_to_show <= show->state.depth)
-			return;
-		/*
-		 * Reaching here indicates we have recursed and found
-		 * non-zero array member(s).
-		 */
-	}
-	__btf_array_show(btf, t, type_id, data, bits_offset, show);
-}
-
 static struct btf_kind_operations array_ops = {
 	.check_meta = btf_array_check_meta,
 	.resolve = btf_array_resolve,
@@ -3081,87 +2123,6 @@ int btf_find_spin_lock(const struct btf *btf, const struct btf_type *t)
 	return off;
 }
 
-static void __btf_struct_show(const struct btf *btf, const struct btf_type *t,
-			      u32 type_id, void *data, u8 bits_offset,
-			      struct btf_show *show)
-{
-	const struct btf_member *member;
-	void *safe_data;
-	u32 i;
-
-	safe_data = btf_show_start_struct_type(show, t, type_id, data);
-	if (!safe_data)
-		return;
-
-	for_each_member(i, t, member) {
-		const struct btf_type *member_type = btf_type_by_id(btf,
-								member->type);
-		const struct btf_kind_operations *ops;
-		u32 member_offset, bitfield_size;
-		u32 bytes_offset;
-		u8 bits8_offset;
-
-		btf_show_start_member(show, member);
-
-		member_offset = btf_member_bit_offset(t, member);
-		bitfield_size = btf_member_bitfield_size(t, member);
-		bytes_offset = BITS_ROUNDDOWN_BYTES(member_offset);
-		bits8_offset = BITS_PER_BYTE_MASKED(member_offset);
-		if (bitfield_size) {
-			safe_data = btf_show_start_type(show, member_type,
-							member->type,
-							data + bytes_offset);
-			if (safe_data)
-				btf_bitfield_show(safe_data,
-						  bits8_offset,
-						  bitfield_size, show);
-			btf_show_end_type(show);
-		} else {
-			ops = btf_type_ops(member_type);
-			ops->show(btf, member_type, member->type,
-				  data + bytes_offset, bits8_offset, show);
-		}
-
-		btf_show_end_member(show);
-	}
-
-	btf_show_end_struct_type(show);
-}
-
-static void btf_struct_show(const struct btf *btf, const struct btf_type *t,
-			    u32 type_id, void *data, u8 bits_offset,
-			    struct btf_show *show)
-{
-	const struct btf_member *m = show->state.member;
-
-	/*
-	 * First check if any members would be shown (are non-zero).
-	 * See comments above "struct btf_show" definition for more
-	 * details on how this works at a high-level.
-	 */
-	if (show->state.depth > 0 && !(show->flags & BTF_SHOW_ZERO)) {
-		if (!show->state.depth_check) {
-			show->state.depth_check = show->state.depth + 1;
-			show->state.depth_to_show = 0;
-		}
-		__btf_struct_show(btf, t, type_id, data, bits_offset, show);
-		/* Restore saved member data here */
-		show->state.member = m;
-		if (show->state.depth_check != show->state.depth + 1)
-			return;
-		show->state.depth_check = 0;
-
-		if (show->state.depth_to_show <= show->state.depth)
-			return;
-		/*
-		 * Reaching here indicates we have recursed and found
-		 * non-zero child values.
-		 */
-	}
-
-	__btf_struct_show(btf, t, type_id, data, bits_offset, show);
-}
-
 static struct btf_kind_operations struct_ops = {
 	.check_meta = btf_struct_check_meta,
 	.resolve = btf_struct_resolve,
@@ -3299,37 +2260,6 @@ static void btf_enum_log(struct btf_verifier_env *env,
 	btf_verifier_log(env, "size=%u vlen=%u", t->size, btf_type_vlen(t));
 }
 
-static void btf_enum_show(const struct btf *btf, const struct btf_type *t,
-			  u32 type_id, void *data, u8 bits_offset,
-			  struct btf_show *show)
-{
-	const struct btf_enum *enums = btf_type_enum(t);
-	u32 i, nr_enums = btf_type_vlen(t);
-	void *safe_data;
-	int v;
-
-	safe_data = btf_show_start_type(show, t, type_id, data);
-	if (!safe_data)
-		return;
-
-	v = *(int *)safe_data;
-
-	for (i = 0; i < nr_enums; i++) {
-		if (v != enums[i].val)
-			continue;
-
-		btf_show_type_value(show, "%s",
-				    __btf_name_by_offset(btf,
-							 enums[i].name_off));
-
-		btf_show_end_type(show);
-		return;
-	}
-
-	btf_show_type_value(show, "%d", v);
-	btf_show_end_type(show);
-}
-
 static struct btf_kind_operations enum_ops = {
 	.check_meta = btf_enum_check_meta,
 	.resolve = btf_df_resolve,
@@ -3647,30 +2577,6 @@ static void btf_datasec_log(struct btf_verifier_env *env,
 	btf_verifier_log(env, "size=%u vlen=%u", t->size, btf_type_vlen(t));
 }
 
-static void btf_datasec_show(const struct btf *btf,
-			     const struct btf_type *t, u32 type_id,
-			     void *data, u8 bits_offset,
-			     struct btf_show *show)
-{
-	const struct btf_var_secinfo *vsi;
-	const struct btf_type *var;
-	u32 i;
-
-	if (!btf_show_start_type(show, t, type_id, data))
-		return;
-
-	btf_show_type_value(show, "section (\"%s\") = {",
-			    __btf_name_by_offset(btf, t->name_off));
-	for_each_vsi(i, t, vsi) {
-		var = btf_type_by_id(btf, vsi->type);
-		if (i)
-			btf_show(show, ",");
-		btf_type_ops(var)->show(btf, var, vsi->type,
-					data + vsi->offset, bits_offset, show);
-	}
-	btf_show_end_type(show);
-}
-
 static const struct btf_kind_operations datasec_ops = {
 	.check_meta		= btf_datasec_check_meta,
 	.resolve		= btf_datasec_resolve,
@@ -5483,95 +4389,6 @@ int btf_prepare_func_args(struct bpf_verifier_env *env, int subprog,
 	return 0;
 }
 
-static void btf_type_show(const struct btf *btf, u32 type_id, void *obj,
-			  struct btf_show *show)
-{
-	const struct btf_type *t = btf_type_by_id(btf, type_id);
-
-	show->btf = btf;
-	memset(&show->state, 0, sizeof(show->state));
-	memset(&show->obj, 0, sizeof(show->obj));
-
-	btf_type_ops(t)->show(btf, t, type_id, obj, 0, show);
-}
-
-static void btf_seq_show(struct btf_show *show, const char *fmt,
-			 va_list args)
-{
-	seq_vprintf((struct seq_file *)show->target, fmt, args);
-}
-
-int btf_type_seq_show_flags(const struct btf *btf, u32 type_id,
-			    void *obj, struct seq_file *m, u64 flags)
-{
-	struct btf_show sseq;
-
-	sseq.target = m;
-	sseq.showfn = btf_seq_show;
-	sseq.flags = flags;
-
-	btf_type_show(btf, type_id, obj, &sseq);
-
-	return sseq.state.status;
-}
-
-void btf_type_seq_show(const struct btf *btf, u32 type_id, void *obj,
-		       struct seq_file *m)
-{
-	(void) btf_type_seq_show_flags(btf, type_id, obj, m,
-				       BTF_SHOW_NONAME | BTF_SHOW_COMPACT |
-				       BTF_SHOW_ZERO | BTF_SHOW_UNSAFE);
-}
-
-struct btf_show_snprintf {
-	struct btf_show show;
-	int len_left;		/* space left in string */
-	int len;		/* length we would have written */
-};
-
-static void btf_snprintf_show(struct btf_show *show, const char *fmt,
-			      va_list args)
-{
-	struct btf_show_snprintf *ssnprintf = (struct btf_show_snprintf *)show;
-	int len;
-
-	len = vsnprintf(show->target, ssnprintf->len_left, fmt, args);
-
-	if (len < 0) {
-		ssnprintf->len_left = 0;
-		ssnprintf->len = len;
-	} else if (len > ssnprintf->len_left) {
-		/* no space, drive on to get length we would have written */
-		ssnprintf->len_left = 0;
-		ssnprintf->len += len;
-	} else {
-		ssnprintf->len_left -= len;
-		ssnprintf->len += len;
-		show->target += len;
-	}
-}
-
-int btf_type_snprintf_show(const struct btf *btf, u32 type_id, void *obj,
-			   char *buf, int len, u64 flags)
-{
-	struct btf_show_snprintf ssnprintf;
-
-	ssnprintf.show.target = buf;
-	ssnprintf.show.flags = flags;
-	ssnprintf.show.showfn = btf_snprintf_show;
-	ssnprintf.len_left = len;
-	ssnprintf.len = 0;
-
-	btf_type_show(btf, type_id, obj, (struct btf_show *)&ssnprintf);
-
-	/* If we encontered an error, return it. */
-	if (ssnprintf.show.state.status)
-		return ssnprintf.show.state.status;
-
-	/* Otherwise return length we would have written */
-	return ssnprintf.len;
-}
-
 #ifdef CONFIG_PROC_FS
 static void bpf_btf_show_fdinfo(struct seq_file *m, struct file *filp)
 {
diff --git a/kernel/bpf/btf_show_common.c b/kernel/bpf/btf_show_common.c
new file mode 100644
index 0000000..a6f35c1
--- /dev/null
+++ b/kernel/bpf/btf_show_common.c
@@ -0,0 +1,1218 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2018 Facebook */
+/* Copyright (c) 2021, Oracle and/or its affiliates. */
+
+#include <uapi/linux/btf.h>
+#include <uapi/linux/bpf.h>
+#ifdef __KERNEL__
+#include <uapi/linux/types.h>
+#include <linux/seq_file.h>
+#include <linux/compiler.h>
+#include <linux/ctype.h>
+#include <linux/errno.h>
+#include <linux/slab.h>
+#include <linux/anon_inodes.h>
+#include <linux/file.h>
+#include <linux/uaccess.h>
+#include <linux/kernel.h>
+#include <linux/bpf_verifier.h>
+#include <linux/btf.h>
+#include <linux/btf_common.h>
+#include <linux/btf_ids.h>
+#else
+#include <ctype.h>
+#include <errno.h>
+#include <linux/bits.h>
+#include <stdarg.h>
+#include <stdio.h>
+#include <string.h>
+#include "btf.h"
+#include "btf_common.h"
+
+#define __printf(a, b)  __attribute__((format(printf, a, b)))
+
+#endif /* __KERNEL__ */
+
+/* Chunk size we use in safe copy of data to be shown. */
+#define BTF_SHOW_OBJ_SAFE_SIZE		32
+
+/*
+ * This is the maximum size of a base type value (equivalent to a
+ * 128-bit int); if we are at the end of our safe buffer and have
+ * less than 16 bytes space we can't be assured of being able
+ * to copy the next type safely, so in such cases we will initiate
+ * a new copy.
+ */
+#define BTF_SHOW_OBJ_BASE_TYPE_SIZE	16
+
+/* Type name size */
+#define BTF_SHOW_NAME_SIZE		80
+
+/*
+ * Common data to all BTF show operations. Private show functions can add
+ * their own data to a structure containing a struct btf_show and consult it
+ * in the show callback.  See btf_type_show() below.
+ *
+ * One challenge with showing nested data is we want to skip 0-valued
+ * data, but in order to figure out whether a nested object is all zeros
+ * we need to walk through it.  As a result, we need to make two passes
+ * when handling structs, unions and arrays; the first pass simply looks
+ * for nonzero data, while the second actually does the display.  The first
+ * pass is signalled by show->state.depth_check being set, and if we
+ * encounter a non-zero value we set show->state.depth_to_show to
+ * the depth at which we encountered it.  When we have completed the
+ * first pass, we will know if anything needs to be displayed if
+ * depth_to_show > depth.  See btf_[struct,array]_show() for the
+ * implementation of this.
+ *
+ * Another problem is we want to ensure the data for display is safe to
+ * access.  To support this, the anonymous "struct {} obj" tracks the data
+ * object and our safe copy of it.  We copy portions of the data needed
+ * to the object "copy" buffer, but because its size is limited to
+ * BTF_SHOW_OBJ_COPY_LEN bytes, multiple copies may be required as we
+ * traverse larger objects for display.
+ *
+ * The various data type show functions all start with a call to
+ * btf_show_start_type() which returns a pointer to the safe copy
+ * of the data needed (or if BTF_SHOW_UNSAFE is specified, to the
+ * raw data itself).  btf_show_obj_safe() is responsible for
+ * using copy_from_kernel_nofault() to update the safe data if necessary
+ * as we traverse the object's data.  skbuff-like semantics are
+ * used:
+ *
+ * - obj.head points to the start of the toplevel object for display
+ * - obj.size is the size of the toplevel object
+ * - obj.data points to the current point in the original data at
+ *   which our safe data starts.  obj.data will advance as we copy
+ *   portions of the data.
+ *
+ * In most cases a single copy will suffice, but larger data structures
+ * such as "struct task_struct" will require many copies.  The logic in
+ * btf_show_obj_safe() handles the logic that determines if a new
+ * copy_from_kernel_nofault() is needed.
+ */
+struct btf_show {
+	u64 flags;
+	void *target;	/* target of show operation (seq file, buffer) */
+	void (*showfn)(struct btf_show *show, const char *fmt, va_list args);
+	const struct btf *btf;
+	/* below are used during iteration */
+	struct {
+		u8 depth;
+		u8 depth_to_show;
+		u8 depth_check;
+		u8 array_member:1,
+		   array_terminated:1;
+		u16 array_encoding;
+		u32 type_id;
+		int status;			/* non-zero for error */
+		const struct btf_type *type;
+		const struct btf_member *member;
+		char name[BTF_SHOW_NAME_SIZE];	/* space for member name/type */
+	} state;
+	struct {
+		u32 size;
+		void *head;
+		void *data;
+		u8 safe[BTF_SHOW_OBJ_SAFE_SIZE];
+	} obj;
+};
+
+#ifndef __KERNEL__
+
+static const struct btf_type *btf_type_id_resolve(const struct btf *btf,
+						  u32 *type_id)
+{
+	return btf_type_by_id(btf, *type_id);
+}
+
+/* kernel has multiple ops defined for each kind; here we just need a show op */
+typedef void (*btf_show_op)(const struct btf *btf, const struct btf_type *t,
+			    u32 type_id, void *data, u8 bits_offset,
+			    struct btf_show *show);
+
+btf_show_op show_ops[NR_BTF_KINDS] = {
+	&btf_df_show,
+	&btf_int_show,
+	&btf_ptr_show,
+	&btf_array_show,
+	&btf_struct_show,
+	&btf_struct_show,
+	&btf_enum_show,
+	&btf_df_show,
+	&btf_modifier_show,
+	&btf_modifier_show,
+	&btf_modifier_show,
+	&btf_modifier_show,
+	&btf_df_show,
+	&btf_df_show,
+	&btf_var_show,
+	&btf_datasec_show,
+};
+
+void btf_type_ops_show(const struct btf *btf, const struct btf_type *t,
+		       u32 type_id, void *data, u8 bits_offset,
+		       struct btf_show *show)
+{
+	show_ops[BTF_INFO_KIND(t->info)](btf, t, type_id, data, bits_offset,
+					 show);
+}
+
+#endif /* __KERNEL__ */
+
+/* Similar to btf_type_skip_modifiers() but does not skip typedefs. */
+static const struct btf_type *btf_type_skip_qualifiers(const struct btf *btf,
+						       u32 id)
+{
+	const struct btf_type *t = btf_type_by_id(btf, id);
+
+	while (btf_type_is_modifier(t) &&
+	       BTF_INFO_KIND(t->info) != BTF_KIND_TYPEDEF) {
+		id = t->type;
+		t = btf_type_by_id(btf, t->type);
+	}
+
+	return t;
+}
+
+#define BTF_SHOW_MAX_ITER	10
+
+#define BTF_KIND_BIT(kind)	(1ULL << kind)
+
+/*
+ * Populate show->state.name with type name information.
+ * Format of type name is
+ *
+ * [.member_name = ] (type_name)
+ */
+static const char *btf_show_name(struct btf_show *show)
+{
+	/* BTF_MAX_ITER array suffixes "[]" */
+	const char *array_suffixes = "[][][][][][][][][][]";
+	const char *array_suffix = &array_suffixes[strlen(array_suffixes)];
+	/* BTF_MAX_ITER pointer suffixes "*" */
+	const char *ptr_suffixes = "**********";
+	const char *ptr_suffix = &ptr_suffixes[strlen(ptr_suffixes)];
+	const char *name = NULL, *prefix = "", *parens = "";
+	const struct btf_member *m = show->state.member;
+	const struct btf_type *t = show->state.type;
+	const struct btf_array *array;
+	u32 id = show->state.type_id;
+	const char *member = NULL;
+	bool show_member = false;
+	u64 kinds = 0;
+	int i;
+
+	show->state.name[0] = '\0';
+
+	/*
+	 * Don't show type name if we're showing an array member;
+	 * in that case we show the array type so don't need to repeat
+	 * ourselves for each member.
+	 */
+	if (show->state.array_member)
+		return "";
+
+	/* Retrieve member name, if any. */
+	if (m) {
+		member = btf_name_by_offset(show->btf, m->name_off);
+		show_member = strlen(member) > 0;
+		id = m->type;
+	}
+
+	/*
+	 * Start with type_id, as we have resolved the struct btf_type *
+	 * via btf_modifier_show() past the parent typedef to the child
+	 * struct, int etc it is defined as.  In such cases, the type_id
+	 * still represents the starting type while the struct btf_type *
+	 * in our show->state points at the resolved type of the typedef.
+	 */
+	t = btf_type_by_id(show->btf, id);
+	if (!t)
+		return "";
+
+	/*
+	 * The goal here is to build up the right number of pointer and
+	 * array suffixes while ensuring the type name for a typedef
+	 * is represented.  Along the way we accumulate a list of
+	 * BTF kinds we have encountered, since these will inform later
+	 * display; for example, pointer types will not require an
+	 * opening "{" for struct, we will just display the pointer value.
+	 *
+	 * We also want to accumulate the right number of pointer or array
+	 * indices in the format string while iterating until we get to
+	 * the typedef/pointee/array member target type.
+	 *
+	 * We start by pointing at the end of pointer and array suffix
+	 * strings; as we accumulate pointers and arrays we move the pointer
+	 * or array string backwards so it will show the expected number of
+	 * '*' or '[]' for the type.  BTF_SHOW_MAX_ITER of nesting of pointers
+	 * and/or arrays and typedefs are supported as a precaution.
+	 *
+	 * We also want to get typedef name while proceeding to resolve
+	 * type it points to so that we can add parentheses if it is a
+	 * "typedef struct" etc.
+	 */
+	for (i = 0; i < BTF_SHOW_MAX_ITER; i++) {
+
+		switch (BTF_INFO_KIND(t->info)) {
+		case BTF_KIND_TYPEDEF:
+			if (!name)
+				name = btf_name_by_offset(show->btf,
+							       t->name_off);
+			kinds |= BTF_KIND_BIT(BTF_KIND_TYPEDEF);
+			id = t->type;
+			break;
+		case BTF_KIND_ARRAY:
+			kinds |= BTF_KIND_BIT(BTF_KIND_ARRAY);
+			parens = "[";
+			if (!t)
+				return "";
+			array = btf_type_array(t);
+			if (array_suffix > array_suffixes)
+				array_suffix -= 2;
+			id = array->type;
+			break;
+		case BTF_KIND_PTR:
+			kinds |= BTF_KIND_BIT(BTF_KIND_PTR);
+			if (ptr_suffix > ptr_suffixes)
+				ptr_suffix -= 1;
+			id = t->type;
+			break;
+		default:
+			id = 0;
+			break;
+		}
+		if (!id)
+			break;
+		t = btf_type_skip_qualifiers(show->btf, id);
+	}
+	/* We may not be able to represent this type; bail to be safe */
+	if (i == BTF_SHOW_MAX_ITER)
+		return "";
+
+	if (!name)
+		name = btf_name_by_offset(show->btf, t->name_off);
+
+	switch (BTF_INFO_KIND(t->info)) {
+	case BTF_KIND_STRUCT:
+	case BTF_KIND_UNION:
+		prefix = BTF_INFO_KIND(t->info) == BTF_KIND_STRUCT ?
+			 "struct" : "union";
+		/* if it's an array of struct/union, parens is already set */
+		if (!(kinds & (BTF_KIND_BIT(BTF_KIND_ARRAY))))
+			parens = "{";
+		break;
+	case BTF_KIND_ENUM:
+		prefix = "enum";
+		break;
+	default:
+		break;
+	}
+
+	/* pointer does not require parens */
+	if (kinds & BTF_KIND_BIT(BTF_KIND_PTR))
+		parens = "";
+	/* typedef does not require struct/union/enum prefix */
+	if (kinds & BTF_KIND_BIT(BTF_KIND_TYPEDEF))
+		prefix = "";
+
+	if (!name)
+		name = "";
+
+	/* Even if we don't want type name info, we want parentheses etc */
+	if (show->flags & BTF_SHOW_NONAME)
+		snprintf(show->state.name, sizeof(show->state.name), "%s",
+			 parens);
+	else
+		snprintf(show->state.name, sizeof(show->state.name),
+			 "%s%s%s(%s%s%s%s%s%s)%s",
+			 /* first 3 strings comprise ".member = " */
+			 show_member ? "." : "",
+			 show_member ? member : "",
+			 show_member ? " = " : "",
+			 /* ...next is our prefix (struct, enum, etc) */
+			 prefix,
+			 strlen(prefix) > 0 && strlen(name) > 0 ? " " : "",
+			 /* ...this is the type name itself */
+			 name,
+			 /* ...suffixed by the appropriate '*', '[]' suffixes */
+			 strlen(ptr_suffix) > 0 ? " " : "", ptr_suffix,
+			 array_suffix, parens);
+
+	return show->state.name;
+}
+
+static const char *__btf_show_indent(struct btf_show *show)
+{
+	const char *indents = "                                ";
+	const char *indent = &indents[strlen(indents)];
+
+	if ((indent - show->state.depth) >= indents)
+		return indent - show->state.depth;
+	return indents;
+}
+
+static const char *btf_show_indent(struct btf_show *show)
+{
+	return show->flags & BTF_SHOW_COMPACT ? "" : __btf_show_indent(show);
+}
+
+static const char *btf_show_newline(struct btf_show *show)
+{
+	return show->flags & BTF_SHOW_COMPACT ? "" : "\n";
+}
+
+static const char *btf_show_delim(struct btf_show *show)
+{
+	if (show->state.depth == 0)
+		return "";
+
+	if ((show->flags & BTF_SHOW_COMPACT) && show->state.type &&
+		BTF_INFO_KIND(show->state.type->info) == BTF_KIND_UNION)
+		return "|";
+
+	return ",";
+}
+
+__printf(2, 3) static void btf_show(struct btf_show *show, const char *fmt, ...)
+{
+	va_list args;
+
+	if (!show->state.depth_check) {
+		va_start(args, fmt);
+		show->showfn(show, fmt, args);
+		va_end(args);
+	}
+}
+
+/* Macros are used here as btf_show_type_value[s]() prepends and appends
+ * format specifiers to the format specifier passed in; these do the work of
+ * adding indentation, delimiters etc while the caller simply has to specify
+ * the type value(s) in the format specifier + value(s).
+ */
+#define btf_show_type_value(show, fmt, value)				       \
+	do {								       \
+		if ((value) != 0 || (show->flags & BTF_SHOW_ZERO) ||	       \
+		    show->state.depth == 0) {				       \
+			btf_show(show, "%s%s" fmt "%s%s",		       \
+				 btf_show_indent(show),			       \
+				 btf_show_name(show),			       \
+				 value, btf_show_delim(show),		       \
+				 btf_show_newline(show));		       \
+			if (show->state.depth > show->state.depth_to_show)     \
+				show->state.depth_to_show = show->state.depth; \
+		}							       \
+	} while (0)
+
+#define btf_show_type_values(show, fmt, ...)				       \
+	do {								       \
+		btf_show(show, "%s%s" fmt "%s%s", btf_show_indent(show),       \
+			 btf_show_name(show),				       \
+			 __VA_ARGS__, btf_show_delim(show),		       \
+			 btf_show_newline(show));			       \
+		if (show->state.depth > show->state.depth_to_show)	       \
+			show->state.depth_to_show = show->state.depth;	       \
+	} while (0)
+
+/* Safe copy is needed for the kernel only. */
+#ifdef __KERNEL__
+
+/* How much is left to copy to safe buffer after @data? */
+static int btf_show_obj_size_left(struct btf_show *show, void *data)
+{
+	return show->obj.head + show->obj.size - data;
+}
+
+/* Is object pointed to by @data of @size already copied to our safe buffer? */
+static bool btf_show_obj_is_safe(struct btf_show *show, void *data, int size)
+{
+	return data >= show->obj.data &&
+	       (data + size) < (show->obj.data + BTF_SHOW_OBJ_SAFE_SIZE);
+}
+
+/*
+ * If object pointed to by @data of @size falls within our safe buffer, return
+ * the equivalent pointer to the same safe data.  Assumes
+ * copy_from_kernel_nofault() has already happened and our safe buffer is
+ * populated.
+ */
+static void *__btf_show_obj_safe(struct btf_show *show, void *data, int size)
+{
+	if (btf_show_obj_is_safe(show, data, size))
+		return show->obj.safe + (data - show->obj.data);
+	return NULL;
+}
+
+/*
+ * Return a safe-to-access version of data pointed to by @data.
+ * We do this by copying the relevant amount of information
+ * to the struct btf_show obj.safe buffer using copy_from_kernel_nofault().
+ *
+ * If BTF_SHOW_UNSAFE is specified, just return data as-is; no
+ * safe copy is needed.
+ *
+ * Otherwise we need to determine if we have the required amount
+ * of data (determined by the @data pointer and the size of the
+ * largest base type we can encounter (represented by
+ * BTF_SHOW_OBJ_BASE_TYPE_SIZE). Having that much data ensures
+ * that we will be able to print some of the current object,
+ * and if more is needed a copy will be triggered.
+ * Some objects such as structs will not fit into the buffer;
+ * in such cases additional copies when we iterate over their
+ * members may be needed.
+ *
+ * btf_show_obj_safe() is used to return a safe buffer for
+ * btf_show_start_type(); this ensures that as we recurse into
+ * nested types we always have safe data for the given type.
+ * This approach is somewhat wasteful; it's possible for example
+ * that when iterating over a large union we'll end up copying the
+ * same data repeatedly, but the goal is safety not performance.
+ * We use stack data as opposed to per-CPU buffers because the
+ * iteration over a type can take some time, and preemption handling
+ * would greatly complicate use of the safe buffer.
+ */
+static void *btf_show_obj_safe(struct btf_show *show,
+			       const struct btf_type *t,
+			       void *data)
+{
+	const struct btf_type *rt;
+	int size_left, size;
+	void *safe = NULL;
+
+	if (show->flags & BTF_SHOW_UNSAFE)
+		return data;
+
+	rt = btf_resolve_size(show->btf, t, &size);
+	if (IS_ERR(rt)) {
+		show->state.status = PTR_ERR(rt);
+		return NULL;
+	}
+
+	/*
+	 * Is this toplevel object? If so, set total object size and
+	 * initialize pointers.  Otherwise check if we still fall within
+	 * our safe object data.
+	 */
+	if (show->state.depth == 0) {
+		show->obj.size = size;
+		show->obj.head = data;
+	} else {
+		/*
+		 * If the size of the current object is > our remaining
+		 * safe buffer we _may_ need to do a new copy.  However
+		 * consider the case of a nested struct; it's size pushes
+		 * us over the safe buffer limit, but showing any individual
+		 * struct members does not.  In such cases, we don't need
+		 * to initiate a fresh copy yet; however we definitely need
+		 * at least BTF_SHOW_OBJ_BASE_TYPE_SIZE bytes left
+		 * in our buffer, regardless of the current object size.
+		 * The logic here is that as we resolve types we will
+		 * hit a base type at some point, and we need to be sure
+		 * the next chunk of data is safely available to display
+		 * that type info safely.  We cannot rely on the size of
+		 * the current object here because it may be much larger
+		 * than our current buffer (e.g. task_struct is 8k).
+		 * All we want to do here is ensure that we can print the
+		 * next basic type, which we can if either
+		 * - the current type size is within the safe buffer; or
+		 * - at least BTF_SHOW_OBJ_BASE_TYPE_SIZE bytes are left in
+		 *   the safe buffer.
+		 */
+		safe = __btf_show_obj_safe(show, data,
+					   min(size,
+					       BTF_SHOW_OBJ_BASE_TYPE_SIZE));
+	}
+
+	/*
+	 * We need a new copy to our safe object, either because we haven't
+	 * yet copied and are intializing safe data, or because the data
+	 * we want falls outside the boundaries of the safe object.
+	 */
+	if (!safe) {
+		size_left = btf_show_obj_size_left(show, data);
+		if (size_left > BTF_SHOW_OBJ_SAFE_SIZE)
+			size_left = BTF_SHOW_OBJ_SAFE_SIZE;
+		show->state.status = copy_from_kernel_nofault(show->obj.safe,
+							      data, size_left);
+		if (!show->state.status) {
+			show->obj.data = data;
+			safe = show->obj.safe;
+		}
+	}
+
+	return safe;
+}
+#else
+/* no safe copy required in userspace, just return data buffer as-is */
+static void *btf_show_obj_safe(struct btf_show *show, const struct btf_type *t,
+			       void *data)
+{
+	return data;
+}
+#endif /* __KERNEL__ */
+
+/*
+ * Set the type we are starting to show and return a safe data pointer
+ * to be used for showing the associated data.
+ */
+static void *btf_show_start_type(struct btf_show *show,
+				 const struct btf_type *t,
+				 u32 type_id, void *data)
+{
+	show->state.type = t;
+	show->state.type_id = type_id;
+	show->state.name[0] = '\0';
+
+	return btf_show_obj_safe(show, t, data);
+}
+
+static void btf_show_end_type(struct btf_show *show)
+{
+	show->state.type = NULL;
+	show->state.type_id = 0;
+	show->state.name[0] = '\0';
+}
+
+static void *btf_show_start_aggr_type(struct btf_show *show,
+				      const struct btf_type *t,
+				      u32 type_id, void *data)
+{
+	void *safe_data = btf_show_start_type(show, t, type_id, data);
+
+	if (!safe_data)
+		return safe_data;
+
+	btf_show(show, "%s%s%s", btf_show_indent(show),
+		 btf_show_name(show),
+		 btf_show_newline(show));
+	show->state.depth++;
+	return safe_data;
+}
+
+static void btf_show_end_aggr_type(struct btf_show *show,
+				   const char *suffix)
+{
+	show->state.depth--;
+	btf_show(show, "%s%s%s%s", btf_show_indent(show), suffix,
+		 btf_show_delim(show), btf_show_newline(show));
+	btf_show_end_type(show);
+}
+
+static void btf_show_start_member(struct btf_show *show,
+				  const struct btf_member *m)
+{
+	show->state.member = m;
+}
+
+static void btf_show_start_array_member(struct btf_show *show)
+{
+	show->state.array_member = 1;
+	btf_show_start_member(show, NULL);
+}
+
+static void btf_show_end_member(struct btf_show *show)
+{
+	show->state.member = NULL;
+}
+
+static void btf_show_end_array_member(struct btf_show *show)
+{
+	show->state.array_member = 0;
+	btf_show_end_member(show);
+}
+
+static void *btf_show_start_array_type(struct btf_show *show,
+				       const struct btf_type *t,
+				       u32 type_id,
+				       u16 array_encoding,
+				       void *data)
+{
+	show->state.array_encoding = array_encoding;
+	show->state.array_terminated = 0;
+	return btf_show_start_aggr_type(show, t, type_id, data);
+}
+
+static void btf_show_end_array_type(struct btf_show *show)
+{
+	show->state.array_encoding = 0;
+	show->state.array_terminated = 0;
+	btf_show_end_aggr_type(show, "]");
+}
+
+static void *btf_show_start_struct_type(struct btf_show *show,
+					const struct btf_type *t,
+					u32 type_id,
+					void *data)
+{
+	return btf_show_start_aggr_type(show, t, type_id, data);
+}
+
+static void btf_show_end_struct_type(struct btf_show *show)
+{
+	btf_show_end_aggr_type(show, "}");
+}
+
+void btf_df_show(const struct btf *btf, const struct btf_type *t,
+		 u32 type_id, void *data, u8 bits_offsets,
+		 struct btf_show *show)
+{
+	btf_show(show, "<unsupported kind:%u>", BTF_INFO_KIND(t->info));
+}
+
+static void btf_int128_print(struct btf_show *show, void *data)
+{
+	/* data points to a __int128 number.
+	 * Suppose
+	 *     int128_num = *(__int128 *)data;
+	 * The below formulas shows what upper_num and lower_num represents:
+	 *     upper_num = int128_num >> 64;
+	 *     lower_num = int128_num & 0xffffffffFFFFFFFFULL;
+	 */
+	u64 upper_num, lower_num;
+
+#ifdef __BIG_ENDIAN_BITFIELD
+	upper_num = *(u64 *)data;
+	lower_num = *(u64 *)(data + 8);
+#else
+	upper_num = *(u64 *)(data + 8);
+	lower_num = *(u64 *)data;
+#endif
+	if (upper_num == 0)
+		btf_show_type_value(show, "0x%" FMT64 "x", lower_num);
+	else
+		btf_show_type_values(show, "0x%" FMT64 "x%016" FMT64 "x",
+				     upper_num, lower_num);
+}
+
+static void btf_int128_shift(u64 *print_num, u16 left_shift_bits,
+			     u16 right_shift_bits)
+{
+	u64 upper_num, lower_num;
+
+#ifdef __BIG_ENDIAN_BITFIELD
+	upper_num = print_num[0];
+	lower_num = print_num[1];
+#else
+	upper_num = print_num[1];
+	lower_num = print_num[0];
+#endif
+
+	/* shake out un-needed bits by shift/or operations */
+	if (left_shift_bits >= 64) {
+		upper_num = lower_num << (left_shift_bits - 64);
+		lower_num = 0;
+	} else {
+		upper_num = (upper_num << left_shift_bits) |
+			    (lower_num >> (64 - left_shift_bits));
+		lower_num = lower_num << left_shift_bits;
+	}
+
+	if (right_shift_bits >= 64) {
+		lower_num = upper_num >> (right_shift_bits - 64);
+		upper_num = 0;
+	} else {
+		lower_num = (lower_num >> right_shift_bits) |
+			    (upper_num << (64 - right_shift_bits));
+		upper_num = upper_num >> right_shift_bits;
+	}
+
+#ifdef __BIG_ENDIAN_BITFIELD
+	print_num[0] = upper_num;
+	print_num[1] = lower_num;
+#else
+	print_num[0] = lower_num;
+	print_num[1] = upper_num;
+#endif
+}
+
+static void btf_bitfield_show(void *data, u8 bits_offset,
+			      u8 nr_bits, struct btf_show *show)
+{
+	u16 left_shift_bits, right_shift_bits;
+	u8 nr_copy_bytes;
+	u8 nr_copy_bits;
+	u64 print_num[2] = {};
+
+	nr_copy_bits = nr_bits + bits_offset;
+	nr_copy_bytes = BITS_ROUNDUP_BYTES(nr_copy_bits);
+
+	memcpy(print_num, data, nr_copy_bytes);
+
+#ifdef __BIG_ENDIAN_BITFIELD
+	left_shift_bits = bits_offset;
+#else
+	left_shift_bits = BITS_PER_U128 - nr_copy_bits;
+#endif
+	right_shift_bits = BITS_PER_U128 - nr_bits;
+
+	btf_int128_shift(print_num, left_shift_bits, right_shift_bits);
+	btf_int128_print(show, print_num);
+}
+
+
+static void btf_int_bits_show(const struct btf *btf,
+			      const struct btf_type *t,
+			      void *data, u8 bits_offset,
+			      struct btf_show *show)
+{
+	u32 int_data = btf_type_int(t);
+	u8 nr_bits = BTF_INT_BITS(int_data);
+	u8 total_bits_offset;
+
+	/*
+	 * bits_offset is at most 7.
+	 * BTF_INT_OFFSET() cannot exceed 128 bits.
+	 */
+	total_bits_offset = bits_offset + BTF_INT_OFFSET(int_data);
+	data += BITS_ROUNDDOWN_BYTES(total_bits_offset);
+	bits_offset = BITS_PER_BYTE_MASKED(total_bits_offset);
+	btf_bitfield_show(data, bits_offset, nr_bits, show);
+}
+
+void btf_int_show(const struct btf *btf, const struct btf_type *t,
+		  u32 type_id, void *data, u8 bits_offset,
+		  struct btf_show *show)
+{
+	u32 int_data = btf_type_int(t);
+	u8 encoding = BTF_INT_ENCODING(int_data);
+	bool sign = encoding & BTF_INT_SIGNED;
+	u8 nr_bits = BTF_INT_BITS(int_data);
+	void *safe_data;
+
+	safe_data = btf_show_start_type(show, t, type_id, data);
+	if (!safe_data)
+		return;
+
+	if (bits_offset || BTF_INT_OFFSET(int_data) ||
+	    BITS_PER_BYTE_MASKED(nr_bits)) {
+		btf_int_bits_show(btf, t, safe_data, bits_offset, show);
+		goto out;
+	}
+
+	switch (nr_bits) {
+	case 128:
+		btf_int128_print(show, safe_data);
+		break;
+	case 64:
+		if (sign)
+			btf_show_type_value(show, "%" FMT64 "d",
+					    *(s64 *)safe_data);
+		else
+			btf_show_type_value(show, "%" FMT64 "u",
+					    *(u64 *)safe_data);
+		break;
+	case 32:
+		if (sign)
+			btf_show_type_value(show, "%d", *(s32 *)safe_data);
+		else
+			btf_show_type_value(show, "%u", *(u32 *)safe_data);
+		break;
+	case 16:
+		if (sign)
+			btf_show_type_value(show, "%d", *(s16 *)safe_data);
+		else
+			btf_show_type_value(show, "%u", *(u16 *)safe_data);
+		break;
+	case 8:
+		if (show->state.array_encoding == BTF_INT_CHAR) {
+			/* check for null terminator */
+			if (show->state.array_terminated)
+				break;
+			if (*(char *)data == '\0') {
+				show->state.array_terminated = 1;
+				break;
+			}
+			if (isprint(*(char *)data)) {
+				btf_show_type_value(show, "'%c'",
+						    *(char *)safe_data);
+				break;
+			}
+		}
+		if (sign)
+			btf_show_type_value(show, "%d", *(s8 *)safe_data);
+		else
+			btf_show_type_value(show, "%u", *(u8 *)safe_data);
+		break;
+	default:
+		btf_int_bits_show(btf, t, safe_data, bits_offset, show);
+		break;
+	}
+out:
+	btf_show_end_type(show);
+}
+
+void btf_modifier_show(const struct btf *btf,
+			      const struct btf_type *t,
+			      u32 type_id, void *data,
+			      u8 bits_offset, struct btf_show *show)
+{
+#ifdef __KERNEL__
+	if (btf_type_ids_resolved(btf))
+		t = btf_type_id_resolve(btf, &type_id);
+	else
+#endif /* __KERNEL__ */
+		t = btf_type_skip_modifiers(btf, type_id, NULL);
+
+	btf_type_ops_show(btf, t, type_id, data, bits_offset, show);
+}
+
+void btf_var_show(const struct btf *btf, const struct btf_type *t,
+		  u32 type_id, void *data, u8 bits_offset,
+		  struct btf_show *show)
+{
+	t = btf_type_id_resolve(btf, &type_id);
+
+	btf_type_ops_show(btf, t, type_id, data, bits_offset, show);
+}
+
+void btf_ptr_show(const struct btf *btf, const struct btf_type *t,
+		  u32 type_id, void *data, u8 bits_offset,
+		  struct btf_show *show)
+{
+	void *safe_data;
+
+	safe_data = btf_show_start_type(show, t, type_id, data);
+	if (!safe_data)
+		return;
+
+#ifdef __KERNEL__
+	/* It is a hashed value unless BTF_SHOW_PTR_RAW is specified */
+	if (show->flags & BTF_SHOW_PTR_RAW)
+		btf_show_type_value(show, "0x%px", *(void **)safe_data);
+	else
+		btf_show_type_value(show, "0x%p", *(void **)safe_data);
+#else
+	btf_show_type_value(show, "%p", *(void **)safe_data);
+#endif /* __KERNEL__ */
+	btf_show_end_type(show);
+}
+
+static void __btf_array_show(const struct btf *btf, const struct btf_type *t,
+			     u32 type_id, void *data, u8 bits_offset,
+			     struct btf_show *show)
+{
+	const struct btf_array *array = btf_type_array(t);
+	const struct btf_type *elem_type;
+	u32 i, elem_size = 0, elem_type_id;
+	u16 encoding = 0;
+
+	elem_type_id = array->type;
+	elem_type = btf_type_skip_modifiers(btf, elem_type_id, NULL);
+	if (elem_type && btf_type_has_size(elem_type))
+		elem_size = elem_type->size;
+
+	if (elem_type && btf_type_is_int(elem_type)) {
+		u32 int_type = btf_type_int(elem_type);
+
+		encoding = BTF_INT_ENCODING(int_type);
+
+		/*
+		 * BTF_INT_CHAR encoding never seems to be set for
+		 * char arrays, so if size is 1 and element is
+		 * printable as a char, we'll do that.
+		 */
+		if (elem_size == 1)
+			encoding = BTF_INT_CHAR;
+	}
+
+	if (!btf_show_start_array_type(show, t, type_id, encoding, data))
+		return;
+
+	if (!elem_type)
+		goto out;
+
+	for (i = 0; i < array->nelems; i++) {
+
+		btf_show_start_array_member(show);
+
+		btf_type_ops_show(btf, elem_type, elem_type_id, data,
+				  bits_offset, show);
+		data += elem_size;
+
+		btf_show_end_array_member(show);
+
+		if (show->state.array_terminated)
+			break;
+	}
+out:
+	btf_show_end_array_type(show);
+}
+
+void btf_array_show(const struct btf *btf, const struct btf_type *t,
+		    u32 type_id, void *data, u8 bits_offset,
+		    struct btf_show *show)
+{
+	const struct btf_member *m = show->state.member;
+
+	/*
+	 * First check if any members would be shown (are non-zero).
+	 * See comments above "struct btf_show" definition for more
+	 * details on how this works at a high-level.
+	 */
+	if (show->state.depth > 0 && !(show->flags & BTF_SHOW_ZERO)) {
+		if (!show->state.depth_check) {
+			show->state.depth_check = show->state.depth + 1;
+			show->state.depth_to_show = 0;
+		}
+		__btf_array_show(btf, t, type_id, data, bits_offset, show);
+		show->state.member = m;
+
+		if (show->state.depth_check != show->state.depth + 1)
+			return;
+		show->state.depth_check = 0;
+
+		if (show->state.depth_to_show <= show->state.depth)
+			return;
+		/*
+		 * Reaching here indicates we have recursed and found
+		 * non-zero array member(s).
+		 */
+	}
+	__btf_array_show(btf, t, type_id, data, bits_offset, show);
+}
+
+static void __btf_struct_show(const struct btf *btf, const struct btf_type *t,
+			      u32 type_id, void *data, u8 bits_offset,
+			      struct btf_show *show)
+{
+	const struct btf_member *member;
+	void *safe_data;
+	u32 i;
+
+	safe_data = btf_show_start_struct_type(show, t, type_id, data);
+	if (!safe_data)
+		return;
+
+	for_each_member(i, t, member) {
+		const struct btf_type *member_type = btf_type_by_id(btf,
+								member->type);
+		u32 member_offset, bitfield_size;
+		u32 bytes_offset;
+		u8 bits8_offset;
+
+		btf_show_start_member(show, member);
+
+		/* btf_member_*() function signatures differ between kernel
+		 * and userspace.
+		 */
+#ifdef __KERNEL__
+		member_offset = btf_member_bit_offset(t, member);
+		bitfield_size = btf_member_bitfield_size(t, member);
+#else
+		member_offset = btf_member_bit_offset(t, i);
+		bitfield_size = btf_member_bitfield_size(t, i);
+#endif
+
+		bytes_offset = BITS_ROUNDDOWN_BYTES(member_offset);
+		bits8_offset = BITS_PER_BYTE_MASKED(member_offset);
+		if (bitfield_size) {
+			safe_data = btf_show_start_type(show, member_type,
+							member->type,
+							data + bytes_offset);
+			if (safe_data)
+				btf_bitfield_show(safe_data,
+						  bits8_offset,
+						  bitfield_size, show);
+			btf_show_end_type(show);
+		} else {
+			btf_type_ops_show(btf, member_type, member->type,
+					  data + bytes_offset, bits8_offset,
+					  show);
+		}
+
+		btf_show_end_member(show);
+	}
+
+	btf_show_end_struct_type(show);
+}
+
+void btf_struct_show(const struct btf *btf, const struct btf_type *t,
+		     u32 type_id, void *data, u8 bits_offset,
+		     struct btf_show *show)
+{
+	const struct btf_member *m = show->state.member;
+
+	/*
+	 * First check if any members would be shown (are non-zero).
+	 * See comments above "struct btf_show" definition for more
+	 * details on how this works at a high-level.
+	 */
+	if (show->state.depth > 0 && !(show->flags & BTF_SHOW_ZERO)) {
+		if (!show->state.depth_check) {
+			show->state.depth_check = show->state.depth + 1;
+			show->state.depth_to_show = 0;
+		}
+		__btf_struct_show(btf, t, type_id, data, bits_offset, show);
+		/* Restore saved member data here */
+		show->state.member = m;
+		if (show->state.depth_check != show->state.depth + 1)
+			return;
+		show->state.depth_check = 0;
+
+		if (show->state.depth_to_show <= show->state.depth)
+			return;
+		/*
+		 * Reaching here indicates we have recursed and found
+		 * non-zero child values.
+		 */
+	}
+
+	__btf_struct_show(btf, t, type_id, data, bits_offset, show);
+}
+
+void btf_enum_show(const struct btf *btf, const struct btf_type *t,
+		   u32 type_id, void *data, u8 bits_offset,
+		   struct btf_show *show)
+{
+	const struct btf_enum *enums = btf_type_enum(t);
+	u32 i, nr_enums = btf_type_vlen(t);
+	void *safe_data;
+	int v;
+
+	safe_data = btf_show_start_type(show, t, type_id, data);
+	if (!safe_data)
+		return;
+
+	v = *(int *)safe_data;
+
+	for (i = 0; i < nr_enums; i++) {
+		if (v != enums[i].val)
+			continue;
+
+		btf_show_type_value(show, "%s",
+				    __btf_name_by_offset(btf,
+							 enums[i].name_off));
+
+		btf_show_end_type(show);
+		return;
+	}
+
+	btf_show_type_value(show, "%d", v);
+	btf_show_end_type(show);
+}
+
+void btf_datasec_show(const struct btf *btf,
+		      const struct btf_type *t, u32 type_id,
+		      void *data, u8 bits_offset,
+		      struct btf_show *show)
+{
+	const struct btf_var_secinfo *vsi;
+	const struct btf_type *var;
+	u32 i;
+
+	if (!btf_show_start_type(show, t, type_id, data))
+		return;
+
+	btf_show_type_value(show, "section (\"%s\") = {",
+			    __btf_name_by_offset(btf, t->name_off));
+	for_each_vsi(i, t, vsi) {
+		var = btf_type_by_id(btf, vsi->type);
+		if (i)
+			btf_show(show, ",");
+		btf_type_ops_show(btf, var, vsi->type,
+				  data + vsi->offset, bits_offset, show);
+	}
+	btf_show_end_type(show);
+}
+
+static void btf_type_show(const struct btf *btf, u32 type_id, void *obj,
+			  struct btf_show *show)
+{
+	const struct btf_type *t = btf_type_by_id(btf, type_id);
+
+	show->btf = btf;
+	memset(&show->state, 0, sizeof(show->state));
+	memset(&show->obj, 0, sizeof(show->obj));
+
+	btf_type_ops_show(btf, t, type_id, obj, 0, show);
+}
+
+/* seq_file show is for kernel only. */
+#ifdef __KERNEL__
+static void btf_seq_show(struct btf_show *show, const char *fmt,
+			 va_list args)
+{
+	seq_vprintf((struct seq_file *)show->target, fmt, args);
+}
+
+int btf_type_seq_show_flags(const struct btf *btf, u32 type_id,
+			    void *obj, struct seq_file *m, u64 flags)
+{
+	struct btf_show sseq;
+
+	sseq.target = m;
+	sseq.showfn = btf_seq_show;
+	sseq.flags = flags;
+
+	btf_type_show(btf, type_id, obj, &sseq);
+
+	return sseq.state.status;
+}
+
+void btf_type_seq_show(const struct btf *btf, u32 type_id, void *obj,
+		       struct seq_file *m)
+{
+	(void) btf_type_seq_show_flags(btf, type_id, obj, m,
+				       BTF_SHOW_NONAME | BTF_SHOW_COMPACT |
+				       BTF_SHOW_ZERO | BTF_SHOW_UNSAFE);
+}
+
+#endif /* __KERNEL__ */
+
+struct btf_show_snprintf {
+	struct btf_show show;
+	int len_left;		/* space left in string */
+	int len;		/* length we would have written */
+};
+
+static void btf_snprintf_show(struct btf_show *show, const char *fmt,
+			      va_list args)
+{
+	struct btf_show_snprintf *ssnprintf = (struct btf_show_snprintf *)show;
+	int len;
+
+	len = vsnprintf(show->target, ssnprintf->len_left, fmt, args);
+
+	if (len < 0) {
+		ssnprintf->len_left = 0;
+		ssnprintf->len = len;
+	} else if (len > ssnprintf->len_left) {
+		/* no space, drive on to get length we would have written */
+		ssnprintf->len_left = 0;
+		ssnprintf->len += len;
+	} else {
+		ssnprintf->len_left -= len;
+		ssnprintf->len += len;
+		show->target += len;
+	}
+}
+
+int btf_type_snprintf_show(const struct btf *btf, u32 type_id, void *obj,
+			   char *buf, int len, u64 flags)
+{
+	struct btf_show_snprintf ssnprintf;
+
+	ssnprintf.show.target = buf;
+	ssnprintf.show.flags = flags;
+	ssnprintf.show.showfn = btf_snprintf_show;
+	ssnprintf.len_left = len;
+	ssnprintf.len = 0;
+
+	btf_type_show(btf, type_id, obj, (struct btf_show *)&ssnprintf);
+
+	/* If we encontered an error, return it. */
+	if (ssnprintf.show.state.status)
+		return ssnprintf.show.state.status;
+
+	/* Otherwise return length we would have written */
+	return ssnprintf.len;
+}
+
+#ifndef __KERNEL__
+int btf__snprintf(struct btf *btf, char *buf, int len, __u32 id, void *obj,
+		  __u64 flags)
+{
+	return btf_type_snprintf_show(btf, id, obj, buf, len, flags);
+}
+#endif /* __KERNEL__ */
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 261f869..71d06a1 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -25,6 +25,7 @@
 #include <linux/moduleloader.h>
 #include <linux/bpf.h>
 #include <linux/btf.h>
+#include <linux/btf_common.h>
 #include <linux/objtool.h>
 #include <linux/rbtree_latch.h>
 #include <linux/kallsyms.h>
diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
index 7e84820..a15a1f9 100644
--- a/kernel/bpf/hashtab.c
+++ b/kernel/bpf/hashtab.c
@@ -4,6 +4,7 @@
  */
 #include <linux/bpf.h>
 #include <linux/btf.h>
+#include <linux/btf_common.h>
 #include <linux/jhash.h>
 #include <linux/filter.h>
 #include <linux/rculist_nulls.h>
diff --git a/kernel/bpf/local_storage.c b/kernel/bpf/local_storage.c
index 2d4f9ac..72b33c2 100644
--- a/kernel/bpf/local_storage.c
+++ b/kernel/bpf/local_storage.c
@@ -2,6 +2,7 @@
 #include <linux/bpf-cgroup.h>
 #include <linux/bpf.h>
 #include <linux/btf.h>
+#include <linux/btf_common.h>
 #include <linux/bug.h>
 #include <linux/filter.h>
 #include <linux/mm.h>
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 17270b8..f6b8880 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -9,6 +9,7 @@
 #include <linux/slab.h>
 #include <linux/bpf.h>
 #include <linux/btf.h>
+#include <linux/btf_common.h>
 #include <linux/bpf_verifier.h>
 #include <linux/filter.h>
 #include <net/netlink.h>
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index ebadaa8..5b37234 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -8,6 +8,7 @@
 #include <linux/bpf.h>
 #include <linux/bpf_perf_event.h>
 #include <linux/btf.h>
+#include <linux/btf_common.h>
 #include <linux/filter.h>
 #include <linux/uaccess.h>
 #include <linux/ctype.h>
diff --git a/tools/lib/bpf/Build b/tools/lib/bpf/Build
index 190366d..eb792ad 100644
--- a/tools/lib/bpf/Build
+++ b/tools/lib/bpf/Build
@@ -1,3 +1,3 @@
 libbpf-y := libbpf.o bpf.o nlattr.o btf.o libbpf_errno.o str_error.o \
 	    netlink.o bpf_prog_linfo.o libbpf_probes.o xsk.o hashmap.o \
-	    btf_dump.o ringbuf.o
+	    btf_dump.o btf_show_common.o ringbuf.o
diff --git a/tools/lib/bpf/btf.h b/tools/lib/bpf/btf.h
index 1237bcd..324ec54 100644
--- a/tools/lib/bpf/btf.h
+++ b/tools/lib/bpf/btf.h
@@ -180,6 +180,13 @@ struct btf_dump_emit_type_decl_opts {
 btf_dump__emit_type_decl(struct btf_dump *d, __u32 id,
 			 const struct btf_dump_emit_type_decl_opts *opts);
 
+/* "show" API (shared with kernel) for displaying typed data (as opposed to
+ * dumping a type.
+ */
+LIBBPF_API int
+btf__snprintf(struct btf *btf, char *buf, int len, __u32 id, void *obj,
+	      __u64 flags);
+
 /*
  * A set of helpers for easier BTF types handling
  */
diff --git a/tools/lib/bpf/btf_common.h b/tools/lib/bpf/btf_common.h
new file mode 100644
index 0000000..4ec23f0
--- /dev/null
+++ b/tools/lib/bpf/btf_common.h
@@ -0,0 +1,286 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (c) 2018 Facebook */
+/* Copyright (c) 2021, Oracle and/or its affiliates. */
+
+#ifndef _LINUX_BTF_COMMON_H
+#define _LINUX_BTF_COMMON_H 1
+
+/* Definitions and functions common to libbpf and kernel; current use case
+ * is to facilitate compilation of btf_show_common.c both for the kernel
+ * and libbpf; this allows us to share the code supporting display of BTF
+ * data between kernel and userspace.
+ */
+#include <linux/types.h>
+#include <uapi/linux/btf.h>
+#include <uapi/linux/bpf.h>
+
+#define BITS_PER_U128 (sizeof(u64) * BITS_PER_BYTE * 2)
+#define BITS_PER_BYTE_MASK (BITS_PER_BYTE - 1)
+#define BITS_PER_BYTE_MASKED(bits) ((bits) & BITS_PER_BYTE_MASK)
+#define BITS_ROUNDDOWN_BYTES(bits) ((bits) >> 3)
+#define BITS_ROUNDUP_BYTES(bits) \
+	(BITS_ROUNDDOWN_BYTES(bits) + !!BITS_PER_BYTE_MASKED(bits))
+
+struct btf;
+struct btf_member;
+struct btf_type;
+struct btf_show;
+
+#ifdef __KERNEL__
+
+const char *btf_str_by_offset(const struct btf *btf, u32 offset);
+void btf_type_seq_show(const struct btf *btf, u32 type_id, void *obj,
+		       struct seq_file *m);
+int btf_type_seq_show_flags(const struct btf *btf, u32 type_id, void *obj,
+			    struct seq_file *m, u64 flags);
+
+/* For kernel u64 is long long unsigned int... */
+#define FMT64		"ll"
+
+#else
+/* ...while for userspace it is long unsigned int.  These definitions avoid
+ * format specifier warnings.
+ */
+#define FMT64		"l"
+
+/* libbpf names differ slightly to in-kernel function names. */
+#define btf_type_by_id		btf__type_by_id
+#define btf_name_by_offset	btf__name_by_offset
+#define btf_str_by_offset	btf__str_by_offset
+#define btf_resolve_size	btf__resolve_size
+
+#endif /* __KERNEL__ */
+/*
+ * Options to control show behaviour.
+ *	- BTF_SHOW_COMPACT: no formatting around type information
+ *	- BTF_SHOW_NONAME: no struct/union member names/types
+ *	- BTF_SHOW_PTR_RAW: show raw (unobfuscated) pointer values;
+ *	  equivalent to %px.
+ *	- BTF_SHOW_ZERO: show zero-valued struct/union members; they
+ *	  are not displayed by default
+ *	- BTF_SHOW_UNSAFE: skip use of bpf_probe_read() to safely read
+ *	  data before displaying it.
+ */
+#define BTF_SHOW_COMPACT	BTF_F_COMPACT
+#define BTF_SHOW_NONAME		BTF_F_NONAME
+#define BTF_SHOW_PTR_RAW	BTF_F_PTR_RAW
+#define BTF_SHOW_ZERO		BTF_F_ZERO
+#define BTF_SHOW_UNSAFE		(1ULL << 4)
+
+/*
+ * Copy len bytes of string representation of obj of BTF type_id into buf.
+ *
+ * @btf: struct btf object
+ * @type_id: type id of type obj points to
+ * @obj: pointer to typed data
+ * @buf: buffer to write to
+ * @len: maximum length to write to buf
+ * @flags: show options (see above)
+ *
+ * Return: length that would have been/was copied as per snprintf, or
+ *	   negative error.
+ */
+int btf_type_snprintf_show(const struct btf *btf, u32 type_id, void *obj,
+			   char *buf, int len, u64 flags);
+
+#define for_each_member(i, struct_type, member)			\
+	for (i = 0, member = btf_type_member(struct_type);	\
+	     i < btf_type_vlen(struct_type);			\
+	     i++, member++)
+
+#define for_each_vsi(i, datasec_type, member)			\
+	for (i = 0, member = btf_type_var_secinfo(datasec_type);	\
+	     i < btf_type_vlen(datasec_type);			\
+	     i++, member++)
+
+static inline bool btf_type_is_ptr(const struct btf_type *t)
+{
+	return BTF_INFO_KIND(t->info) == BTF_KIND_PTR;
+}
+
+static inline bool btf_type_is_int(const struct btf_type *t)
+{
+	return BTF_INFO_KIND(t->info) == BTF_KIND_INT;
+}
+
+static inline bool btf_type_is_small_int(const struct btf_type *t)
+{
+	return btf_type_is_int(t) && t->size <= sizeof(u64);
+}
+
+static inline bool btf_type_is_enum(const struct btf_type *t)
+{
+	return BTF_INFO_KIND(t->info) == BTF_KIND_ENUM;
+}
+
+static inline bool btf_type_is_typedef(const struct btf_type *t)
+{
+	return BTF_INFO_KIND(t->info) == BTF_KIND_TYPEDEF;
+}
+
+static inline bool btf_type_is_func(const struct btf_type *t)
+{
+	return BTF_INFO_KIND(t->info) == BTF_KIND_FUNC;
+}
+
+static inline bool btf_type_is_func_proto(const struct btf_type *t)
+{
+	return BTF_INFO_KIND(t->info) == BTF_KIND_FUNC_PROTO;
+}
+
+static inline bool btf_type_is_var(const struct btf_type *t)
+{
+	return BTF_INFO_KIND(t->info) == BTF_KIND_VAR;
+}
+
+/* union is only a special case of struct:
+ * all its offsetof(member) == 0
+ */
+static inline bool btf_type_is_struct(const struct btf_type *t)
+{
+	u8 kind = BTF_INFO_KIND(t->info);
+
+	return kind == BTF_KIND_STRUCT || kind == BTF_KIND_UNION;
+}
+
+static inline bool btf_type_is_modifier(const struct btf_type *t)
+{
+	/* Some of them is not strictly a C modifier
+	 * but they are grouped into the same bucket
+	 * for BTF concern:
+	 *   A type (t) that refers to another
+	 *   type through t->type AND its size cannot
+	 *   be determined without following the t->type.
+	 *
+	 * ptr does not fall into this bucket
+	 * because its size is always sizeof(void *).
+	 */
+	switch (BTF_INFO_KIND(t->info)) {
+	case BTF_KIND_TYPEDEF:
+	case BTF_KIND_VOLATILE:
+	case BTF_KIND_CONST:
+	case BTF_KIND_RESTRICT:
+		return true;
+	default:
+		return false;
+	}
+}
+
+static inline
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
+static inline u32 btf_type_int(const struct btf_type *t)
+{
+	return *(u32 *)(t + 1);
+}
+
+static inline const struct btf_array *btf_type_array(const struct btf_type *t)
+{
+	return (const struct btf_array *)(t + 1);
+}
+
+static inline const struct btf_enum *btf_type_enum(const struct btf_type *t)
+{
+	return (const struct btf_enum *)(t + 1);
+}
+
+static inline const struct btf_var *btf_type_var(const struct btf_type *t)
+{
+	return (const struct btf_var *)(t + 1);
+}
+
+static inline u16 btf_type_vlen(const struct btf_type *t)
+{
+	return BTF_INFO_VLEN(t->info);
+}
+
+static inline u16 btf_func_linkage(const struct btf_type *t)
+{
+	return BTF_INFO_VLEN(t->info);
+}
+
+/* size can be used */
+static inline bool btf_type_has_size(const struct btf_type *t)
+{
+	switch (BTF_INFO_KIND(t->info)) {
+	case BTF_KIND_INT:
+	case BTF_KIND_STRUCT:
+	case BTF_KIND_UNION:
+	case BTF_KIND_ENUM:
+	case BTF_KIND_DATASEC:
+		return true;
+	default:
+		return false;
+	}
+}
+
+static inline const struct btf_member *btf_type_member(const struct btf_type *t)
+{
+	return (const struct btf_member *)(t + 1);
+}
+
+static inline const struct btf_var_secinfo *btf_type_var_secinfo(
+		const struct btf_type *t)
+{
+	return (const struct btf_var_secinfo *)(t + 1);
+}
+
+static inline const char *__btf_name_by_offset(const struct btf *btf,
+					       u32 offset)
+{
+	const char *name;
+
+	if (!offset)
+		return "(anon)";
+
+	name = btf_str_by_offset(btf, offset);
+	return name ?: "(invalid-name-offset)";
+}
+
+/* functions shared between btf.c and btf_show_common.c */
+void btf_type_ops_show(const struct btf *btf, const struct btf_type *t,
+		       __u32 type_id, void *obj, u8 bits_offset,
+		       struct btf_show *show);
+void btf_df_show(const struct btf *btf, const struct btf_type *t,
+		 u32 type_id, void *data, u8 bits_offset,
+		 struct btf_show *show);
+void btf_int_show(const struct btf *btf, const struct btf_type *t,
+		  u32 type_id, void *data, u8 bits_offset,
+		  struct btf_show *show);
+void btf_modifier_show(const struct btf *btf, const struct btf_type *t,
+		       u32 type_id, void *data, u8 bits_offset,
+		       struct btf_show *show);
+void btf_var_show(const struct btf *btf, const struct btf_type *t,
+		  u32 type_id, void *data, u8 bits_offset,
+		  struct btf_show *show);
+void btf_ptr_show(const struct btf *btf, const struct btf_type *t,
+		  u32 type_id, void *data, u8 bits_offset,
+		  struct btf_show *show);
+void btf_array_show(const struct btf *btf, const struct btf_type *t,
+		    u32 type_id, void *data, u8 bits_offset,
+		    struct btf_show *show);
+void btf_struct_show(const struct btf *btf, const struct btf_type *t,
+		     u32 type_id, void *data, u8 bits_offset,
+		     struct btf_show *show);
+void btf_enum_show(const struct btf *btf, const struct btf_type *t,
+		   u32 type_id, void *data, u8 bits_offset,
+		   struct btf_show *show);
+void btf_datasec_show(const struct btf *btf, const struct btf_type *t,
+		      u32 type_id, void *data, u8 bits_offset,
+		      struct btf_show *show);
+
+#endif
diff --git a/tools/lib/bpf/btf_show_common.c b/tools/lib/bpf/btf_show_common.c
new file mode 100644
index 0000000..a6f35c1
--- /dev/null
+++ b/tools/lib/bpf/btf_show_common.c
@@ -0,0 +1,1218 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2018 Facebook */
+/* Copyright (c) 2021, Oracle and/or its affiliates. */
+
+#include <uapi/linux/btf.h>
+#include <uapi/linux/bpf.h>
+#ifdef __KERNEL__
+#include <uapi/linux/types.h>
+#include <linux/seq_file.h>
+#include <linux/compiler.h>
+#include <linux/ctype.h>
+#include <linux/errno.h>
+#include <linux/slab.h>
+#include <linux/anon_inodes.h>
+#include <linux/file.h>
+#include <linux/uaccess.h>
+#include <linux/kernel.h>
+#include <linux/bpf_verifier.h>
+#include <linux/btf.h>
+#include <linux/btf_common.h>
+#include <linux/btf_ids.h>
+#else
+#include <ctype.h>
+#include <errno.h>
+#include <linux/bits.h>
+#include <stdarg.h>
+#include <stdio.h>
+#include <string.h>
+#include "btf.h"
+#include "btf_common.h"
+
+#define __printf(a, b)  __attribute__((format(printf, a, b)))
+
+#endif /* __KERNEL__ */
+
+/* Chunk size we use in safe copy of data to be shown. */
+#define BTF_SHOW_OBJ_SAFE_SIZE		32
+
+/*
+ * This is the maximum size of a base type value (equivalent to a
+ * 128-bit int); if we are at the end of our safe buffer and have
+ * less than 16 bytes space we can't be assured of being able
+ * to copy the next type safely, so in such cases we will initiate
+ * a new copy.
+ */
+#define BTF_SHOW_OBJ_BASE_TYPE_SIZE	16
+
+/* Type name size */
+#define BTF_SHOW_NAME_SIZE		80
+
+/*
+ * Common data to all BTF show operations. Private show functions can add
+ * their own data to a structure containing a struct btf_show and consult it
+ * in the show callback.  See btf_type_show() below.
+ *
+ * One challenge with showing nested data is we want to skip 0-valued
+ * data, but in order to figure out whether a nested object is all zeros
+ * we need to walk through it.  As a result, we need to make two passes
+ * when handling structs, unions and arrays; the first pass simply looks
+ * for nonzero data, while the second actually does the display.  The first
+ * pass is signalled by show->state.depth_check being set, and if we
+ * encounter a non-zero value we set show->state.depth_to_show to
+ * the depth at which we encountered it.  When we have completed the
+ * first pass, we will know if anything needs to be displayed if
+ * depth_to_show > depth.  See btf_[struct,array]_show() for the
+ * implementation of this.
+ *
+ * Another problem is we want to ensure the data for display is safe to
+ * access.  To support this, the anonymous "struct {} obj" tracks the data
+ * object and our safe copy of it.  We copy portions of the data needed
+ * to the object "copy" buffer, but because its size is limited to
+ * BTF_SHOW_OBJ_COPY_LEN bytes, multiple copies may be required as we
+ * traverse larger objects for display.
+ *
+ * The various data type show functions all start with a call to
+ * btf_show_start_type() which returns a pointer to the safe copy
+ * of the data needed (or if BTF_SHOW_UNSAFE is specified, to the
+ * raw data itself).  btf_show_obj_safe() is responsible for
+ * using copy_from_kernel_nofault() to update the safe data if necessary
+ * as we traverse the object's data.  skbuff-like semantics are
+ * used:
+ *
+ * - obj.head points to the start of the toplevel object for display
+ * - obj.size is the size of the toplevel object
+ * - obj.data points to the current point in the original data at
+ *   which our safe data starts.  obj.data will advance as we copy
+ *   portions of the data.
+ *
+ * In most cases a single copy will suffice, but larger data structures
+ * such as "struct task_struct" will require many copies.  The logic in
+ * btf_show_obj_safe() handles the logic that determines if a new
+ * copy_from_kernel_nofault() is needed.
+ */
+struct btf_show {
+	u64 flags;
+	void *target;	/* target of show operation (seq file, buffer) */
+	void (*showfn)(struct btf_show *show, const char *fmt, va_list args);
+	const struct btf *btf;
+	/* below are used during iteration */
+	struct {
+		u8 depth;
+		u8 depth_to_show;
+		u8 depth_check;
+		u8 array_member:1,
+		   array_terminated:1;
+		u16 array_encoding;
+		u32 type_id;
+		int status;			/* non-zero for error */
+		const struct btf_type *type;
+		const struct btf_member *member;
+		char name[BTF_SHOW_NAME_SIZE];	/* space for member name/type */
+	} state;
+	struct {
+		u32 size;
+		void *head;
+		void *data;
+		u8 safe[BTF_SHOW_OBJ_SAFE_SIZE];
+	} obj;
+};
+
+#ifndef __KERNEL__
+
+static const struct btf_type *btf_type_id_resolve(const struct btf *btf,
+						  u32 *type_id)
+{
+	return btf_type_by_id(btf, *type_id);
+}
+
+/* kernel has multiple ops defined for each kind; here we just need a show op */
+typedef void (*btf_show_op)(const struct btf *btf, const struct btf_type *t,
+			    u32 type_id, void *data, u8 bits_offset,
+			    struct btf_show *show);
+
+btf_show_op show_ops[NR_BTF_KINDS] = {
+	&btf_df_show,
+	&btf_int_show,
+	&btf_ptr_show,
+	&btf_array_show,
+	&btf_struct_show,
+	&btf_struct_show,
+	&btf_enum_show,
+	&btf_df_show,
+	&btf_modifier_show,
+	&btf_modifier_show,
+	&btf_modifier_show,
+	&btf_modifier_show,
+	&btf_df_show,
+	&btf_df_show,
+	&btf_var_show,
+	&btf_datasec_show,
+};
+
+void btf_type_ops_show(const struct btf *btf, const struct btf_type *t,
+		       u32 type_id, void *data, u8 bits_offset,
+		       struct btf_show *show)
+{
+	show_ops[BTF_INFO_KIND(t->info)](btf, t, type_id, data, bits_offset,
+					 show);
+}
+
+#endif /* __KERNEL__ */
+
+/* Similar to btf_type_skip_modifiers() but does not skip typedefs. */
+static const struct btf_type *btf_type_skip_qualifiers(const struct btf *btf,
+						       u32 id)
+{
+	const struct btf_type *t = btf_type_by_id(btf, id);
+
+	while (btf_type_is_modifier(t) &&
+	       BTF_INFO_KIND(t->info) != BTF_KIND_TYPEDEF) {
+		id = t->type;
+		t = btf_type_by_id(btf, t->type);
+	}
+
+	return t;
+}
+
+#define BTF_SHOW_MAX_ITER	10
+
+#define BTF_KIND_BIT(kind)	(1ULL << kind)
+
+/*
+ * Populate show->state.name with type name information.
+ * Format of type name is
+ *
+ * [.member_name = ] (type_name)
+ */
+static const char *btf_show_name(struct btf_show *show)
+{
+	/* BTF_MAX_ITER array suffixes "[]" */
+	const char *array_suffixes = "[][][][][][][][][][]";
+	const char *array_suffix = &array_suffixes[strlen(array_suffixes)];
+	/* BTF_MAX_ITER pointer suffixes "*" */
+	const char *ptr_suffixes = "**********";
+	const char *ptr_suffix = &ptr_suffixes[strlen(ptr_suffixes)];
+	const char *name = NULL, *prefix = "", *parens = "";
+	const struct btf_member *m = show->state.member;
+	const struct btf_type *t = show->state.type;
+	const struct btf_array *array;
+	u32 id = show->state.type_id;
+	const char *member = NULL;
+	bool show_member = false;
+	u64 kinds = 0;
+	int i;
+
+	show->state.name[0] = '\0';
+
+	/*
+	 * Don't show type name if we're showing an array member;
+	 * in that case we show the array type so don't need to repeat
+	 * ourselves for each member.
+	 */
+	if (show->state.array_member)
+		return "";
+
+	/* Retrieve member name, if any. */
+	if (m) {
+		member = btf_name_by_offset(show->btf, m->name_off);
+		show_member = strlen(member) > 0;
+		id = m->type;
+	}
+
+	/*
+	 * Start with type_id, as we have resolved the struct btf_type *
+	 * via btf_modifier_show() past the parent typedef to the child
+	 * struct, int etc it is defined as.  In such cases, the type_id
+	 * still represents the starting type while the struct btf_type *
+	 * in our show->state points at the resolved type of the typedef.
+	 */
+	t = btf_type_by_id(show->btf, id);
+	if (!t)
+		return "";
+
+	/*
+	 * The goal here is to build up the right number of pointer and
+	 * array suffixes while ensuring the type name for a typedef
+	 * is represented.  Along the way we accumulate a list of
+	 * BTF kinds we have encountered, since these will inform later
+	 * display; for example, pointer types will not require an
+	 * opening "{" for struct, we will just display the pointer value.
+	 *
+	 * We also want to accumulate the right number of pointer or array
+	 * indices in the format string while iterating until we get to
+	 * the typedef/pointee/array member target type.
+	 *
+	 * We start by pointing at the end of pointer and array suffix
+	 * strings; as we accumulate pointers and arrays we move the pointer
+	 * or array string backwards so it will show the expected number of
+	 * '*' or '[]' for the type.  BTF_SHOW_MAX_ITER of nesting of pointers
+	 * and/or arrays and typedefs are supported as a precaution.
+	 *
+	 * We also want to get typedef name while proceeding to resolve
+	 * type it points to so that we can add parentheses if it is a
+	 * "typedef struct" etc.
+	 */
+	for (i = 0; i < BTF_SHOW_MAX_ITER; i++) {
+
+		switch (BTF_INFO_KIND(t->info)) {
+		case BTF_KIND_TYPEDEF:
+			if (!name)
+				name = btf_name_by_offset(show->btf,
+							       t->name_off);
+			kinds |= BTF_KIND_BIT(BTF_KIND_TYPEDEF);
+			id = t->type;
+			break;
+		case BTF_KIND_ARRAY:
+			kinds |= BTF_KIND_BIT(BTF_KIND_ARRAY);
+			parens = "[";
+			if (!t)
+				return "";
+			array = btf_type_array(t);
+			if (array_suffix > array_suffixes)
+				array_suffix -= 2;
+			id = array->type;
+			break;
+		case BTF_KIND_PTR:
+			kinds |= BTF_KIND_BIT(BTF_KIND_PTR);
+			if (ptr_suffix > ptr_suffixes)
+				ptr_suffix -= 1;
+			id = t->type;
+			break;
+		default:
+			id = 0;
+			break;
+		}
+		if (!id)
+			break;
+		t = btf_type_skip_qualifiers(show->btf, id);
+	}
+	/* We may not be able to represent this type; bail to be safe */
+	if (i == BTF_SHOW_MAX_ITER)
+		return "";
+
+	if (!name)
+		name = btf_name_by_offset(show->btf, t->name_off);
+
+	switch (BTF_INFO_KIND(t->info)) {
+	case BTF_KIND_STRUCT:
+	case BTF_KIND_UNION:
+		prefix = BTF_INFO_KIND(t->info) == BTF_KIND_STRUCT ?
+			 "struct" : "union";
+		/* if it's an array of struct/union, parens is already set */
+		if (!(kinds & (BTF_KIND_BIT(BTF_KIND_ARRAY))))
+			parens = "{";
+		break;
+	case BTF_KIND_ENUM:
+		prefix = "enum";
+		break;
+	default:
+		break;
+	}
+
+	/* pointer does not require parens */
+	if (kinds & BTF_KIND_BIT(BTF_KIND_PTR))
+		parens = "";
+	/* typedef does not require struct/union/enum prefix */
+	if (kinds & BTF_KIND_BIT(BTF_KIND_TYPEDEF))
+		prefix = "";
+
+	if (!name)
+		name = "";
+
+	/* Even if we don't want type name info, we want parentheses etc */
+	if (show->flags & BTF_SHOW_NONAME)
+		snprintf(show->state.name, sizeof(show->state.name), "%s",
+			 parens);
+	else
+		snprintf(show->state.name, sizeof(show->state.name),
+			 "%s%s%s(%s%s%s%s%s%s)%s",
+			 /* first 3 strings comprise ".member = " */
+			 show_member ? "." : "",
+			 show_member ? member : "",
+			 show_member ? " = " : "",
+			 /* ...next is our prefix (struct, enum, etc) */
+			 prefix,
+			 strlen(prefix) > 0 && strlen(name) > 0 ? " " : "",
+			 /* ...this is the type name itself */
+			 name,
+			 /* ...suffixed by the appropriate '*', '[]' suffixes */
+			 strlen(ptr_suffix) > 0 ? " " : "", ptr_suffix,
+			 array_suffix, parens);
+
+	return show->state.name;
+}
+
+static const char *__btf_show_indent(struct btf_show *show)
+{
+	const char *indents = "                                ";
+	const char *indent = &indents[strlen(indents)];
+
+	if ((indent - show->state.depth) >= indents)
+		return indent - show->state.depth;
+	return indents;
+}
+
+static const char *btf_show_indent(struct btf_show *show)
+{
+	return show->flags & BTF_SHOW_COMPACT ? "" : __btf_show_indent(show);
+}
+
+static const char *btf_show_newline(struct btf_show *show)
+{
+	return show->flags & BTF_SHOW_COMPACT ? "" : "\n";
+}
+
+static const char *btf_show_delim(struct btf_show *show)
+{
+	if (show->state.depth == 0)
+		return "";
+
+	if ((show->flags & BTF_SHOW_COMPACT) && show->state.type &&
+		BTF_INFO_KIND(show->state.type->info) == BTF_KIND_UNION)
+		return "|";
+
+	return ",";
+}
+
+__printf(2, 3) static void btf_show(struct btf_show *show, const char *fmt, ...)
+{
+	va_list args;
+
+	if (!show->state.depth_check) {
+		va_start(args, fmt);
+		show->showfn(show, fmt, args);
+		va_end(args);
+	}
+}
+
+/* Macros are used here as btf_show_type_value[s]() prepends and appends
+ * format specifiers to the format specifier passed in; these do the work of
+ * adding indentation, delimiters etc while the caller simply has to specify
+ * the type value(s) in the format specifier + value(s).
+ */
+#define btf_show_type_value(show, fmt, value)				       \
+	do {								       \
+		if ((value) != 0 || (show->flags & BTF_SHOW_ZERO) ||	       \
+		    show->state.depth == 0) {				       \
+			btf_show(show, "%s%s" fmt "%s%s",		       \
+				 btf_show_indent(show),			       \
+				 btf_show_name(show),			       \
+				 value, btf_show_delim(show),		       \
+				 btf_show_newline(show));		       \
+			if (show->state.depth > show->state.depth_to_show)     \
+				show->state.depth_to_show = show->state.depth; \
+		}							       \
+	} while (0)
+
+#define btf_show_type_values(show, fmt, ...)				       \
+	do {								       \
+		btf_show(show, "%s%s" fmt "%s%s", btf_show_indent(show),       \
+			 btf_show_name(show),				       \
+			 __VA_ARGS__, btf_show_delim(show),		       \
+			 btf_show_newline(show));			       \
+		if (show->state.depth > show->state.depth_to_show)	       \
+			show->state.depth_to_show = show->state.depth;	       \
+	} while (0)
+
+/* Safe copy is needed for the kernel only. */
+#ifdef __KERNEL__
+
+/* How much is left to copy to safe buffer after @data? */
+static int btf_show_obj_size_left(struct btf_show *show, void *data)
+{
+	return show->obj.head + show->obj.size - data;
+}
+
+/* Is object pointed to by @data of @size already copied to our safe buffer? */
+static bool btf_show_obj_is_safe(struct btf_show *show, void *data, int size)
+{
+	return data >= show->obj.data &&
+	       (data + size) < (show->obj.data + BTF_SHOW_OBJ_SAFE_SIZE);
+}
+
+/*
+ * If object pointed to by @data of @size falls within our safe buffer, return
+ * the equivalent pointer to the same safe data.  Assumes
+ * copy_from_kernel_nofault() has already happened and our safe buffer is
+ * populated.
+ */
+static void *__btf_show_obj_safe(struct btf_show *show, void *data, int size)
+{
+	if (btf_show_obj_is_safe(show, data, size))
+		return show->obj.safe + (data - show->obj.data);
+	return NULL;
+}
+
+/*
+ * Return a safe-to-access version of data pointed to by @data.
+ * We do this by copying the relevant amount of information
+ * to the struct btf_show obj.safe buffer using copy_from_kernel_nofault().
+ *
+ * If BTF_SHOW_UNSAFE is specified, just return data as-is; no
+ * safe copy is needed.
+ *
+ * Otherwise we need to determine if we have the required amount
+ * of data (determined by the @data pointer and the size of the
+ * largest base type we can encounter (represented by
+ * BTF_SHOW_OBJ_BASE_TYPE_SIZE). Having that much data ensures
+ * that we will be able to print some of the current object,
+ * and if more is needed a copy will be triggered.
+ * Some objects such as structs will not fit into the buffer;
+ * in such cases additional copies when we iterate over their
+ * members may be needed.
+ *
+ * btf_show_obj_safe() is used to return a safe buffer for
+ * btf_show_start_type(); this ensures that as we recurse into
+ * nested types we always have safe data for the given type.
+ * This approach is somewhat wasteful; it's possible for example
+ * that when iterating over a large union we'll end up copying the
+ * same data repeatedly, but the goal is safety not performance.
+ * We use stack data as opposed to per-CPU buffers because the
+ * iteration over a type can take some time, and preemption handling
+ * would greatly complicate use of the safe buffer.
+ */
+static void *btf_show_obj_safe(struct btf_show *show,
+			       const struct btf_type *t,
+			       void *data)
+{
+	const struct btf_type *rt;
+	int size_left, size;
+	void *safe = NULL;
+
+	if (show->flags & BTF_SHOW_UNSAFE)
+		return data;
+
+	rt = btf_resolve_size(show->btf, t, &size);
+	if (IS_ERR(rt)) {
+		show->state.status = PTR_ERR(rt);
+		return NULL;
+	}
+
+	/*
+	 * Is this toplevel object? If so, set total object size and
+	 * initialize pointers.  Otherwise check if we still fall within
+	 * our safe object data.
+	 */
+	if (show->state.depth == 0) {
+		show->obj.size = size;
+		show->obj.head = data;
+	} else {
+		/*
+		 * If the size of the current object is > our remaining
+		 * safe buffer we _may_ need to do a new copy.  However
+		 * consider the case of a nested struct; it's size pushes
+		 * us over the safe buffer limit, but showing any individual
+		 * struct members does not.  In such cases, we don't need
+		 * to initiate a fresh copy yet; however we definitely need
+		 * at least BTF_SHOW_OBJ_BASE_TYPE_SIZE bytes left
+		 * in our buffer, regardless of the current object size.
+		 * The logic here is that as we resolve types we will
+		 * hit a base type at some point, and we need to be sure
+		 * the next chunk of data is safely available to display
+		 * that type info safely.  We cannot rely on the size of
+		 * the current object here because it may be much larger
+		 * than our current buffer (e.g. task_struct is 8k).
+		 * All we want to do here is ensure that we can print the
+		 * next basic type, which we can if either
+		 * - the current type size is within the safe buffer; or
+		 * - at least BTF_SHOW_OBJ_BASE_TYPE_SIZE bytes are left in
+		 *   the safe buffer.
+		 */
+		safe = __btf_show_obj_safe(show, data,
+					   min(size,
+					       BTF_SHOW_OBJ_BASE_TYPE_SIZE));
+	}
+
+	/*
+	 * We need a new copy to our safe object, either because we haven't
+	 * yet copied and are intializing safe data, or because the data
+	 * we want falls outside the boundaries of the safe object.
+	 */
+	if (!safe) {
+		size_left = btf_show_obj_size_left(show, data);
+		if (size_left > BTF_SHOW_OBJ_SAFE_SIZE)
+			size_left = BTF_SHOW_OBJ_SAFE_SIZE;
+		show->state.status = copy_from_kernel_nofault(show->obj.safe,
+							      data, size_left);
+		if (!show->state.status) {
+			show->obj.data = data;
+			safe = show->obj.safe;
+		}
+	}
+
+	return safe;
+}
+#else
+/* no safe copy required in userspace, just return data buffer as-is */
+static void *btf_show_obj_safe(struct btf_show *show, const struct btf_type *t,
+			       void *data)
+{
+	return data;
+}
+#endif /* __KERNEL__ */
+
+/*
+ * Set the type we are starting to show and return a safe data pointer
+ * to be used for showing the associated data.
+ */
+static void *btf_show_start_type(struct btf_show *show,
+				 const struct btf_type *t,
+				 u32 type_id, void *data)
+{
+	show->state.type = t;
+	show->state.type_id = type_id;
+	show->state.name[0] = '\0';
+
+	return btf_show_obj_safe(show, t, data);
+}
+
+static void btf_show_end_type(struct btf_show *show)
+{
+	show->state.type = NULL;
+	show->state.type_id = 0;
+	show->state.name[0] = '\0';
+}
+
+static void *btf_show_start_aggr_type(struct btf_show *show,
+				      const struct btf_type *t,
+				      u32 type_id, void *data)
+{
+	void *safe_data = btf_show_start_type(show, t, type_id, data);
+
+	if (!safe_data)
+		return safe_data;
+
+	btf_show(show, "%s%s%s", btf_show_indent(show),
+		 btf_show_name(show),
+		 btf_show_newline(show));
+	show->state.depth++;
+	return safe_data;
+}
+
+static void btf_show_end_aggr_type(struct btf_show *show,
+				   const char *suffix)
+{
+	show->state.depth--;
+	btf_show(show, "%s%s%s%s", btf_show_indent(show), suffix,
+		 btf_show_delim(show), btf_show_newline(show));
+	btf_show_end_type(show);
+}
+
+static void btf_show_start_member(struct btf_show *show,
+				  const struct btf_member *m)
+{
+	show->state.member = m;
+}
+
+static void btf_show_start_array_member(struct btf_show *show)
+{
+	show->state.array_member = 1;
+	btf_show_start_member(show, NULL);
+}
+
+static void btf_show_end_member(struct btf_show *show)
+{
+	show->state.member = NULL;
+}
+
+static void btf_show_end_array_member(struct btf_show *show)
+{
+	show->state.array_member = 0;
+	btf_show_end_member(show);
+}
+
+static void *btf_show_start_array_type(struct btf_show *show,
+				       const struct btf_type *t,
+				       u32 type_id,
+				       u16 array_encoding,
+				       void *data)
+{
+	show->state.array_encoding = array_encoding;
+	show->state.array_terminated = 0;
+	return btf_show_start_aggr_type(show, t, type_id, data);
+}
+
+static void btf_show_end_array_type(struct btf_show *show)
+{
+	show->state.array_encoding = 0;
+	show->state.array_terminated = 0;
+	btf_show_end_aggr_type(show, "]");
+}
+
+static void *btf_show_start_struct_type(struct btf_show *show,
+					const struct btf_type *t,
+					u32 type_id,
+					void *data)
+{
+	return btf_show_start_aggr_type(show, t, type_id, data);
+}
+
+static void btf_show_end_struct_type(struct btf_show *show)
+{
+	btf_show_end_aggr_type(show, "}");
+}
+
+void btf_df_show(const struct btf *btf, const struct btf_type *t,
+		 u32 type_id, void *data, u8 bits_offsets,
+		 struct btf_show *show)
+{
+	btf_show(show, "<unsupported kind:%u>", BTF_INFO_KIND(t->info));
+}
+
+static void btf_int128_print(struct btf_show *show, void *data)
+{
+	/* data points to a __int128 number.
+	 * Suppose
+	 *     int128_num = *(__int128 *)data;
+	 * The below formulas shows what upper_num and lower_num represents:
+	 *     upper_num = int128_num >> 64;
+	 *     lower_num = int128_num & 0xffffffffFFFFFFFFULL;
+	 */
+	u64 upper_num, lower_num;
+
+#ifdef __BIG_ENDIAN_BITFIELD
+	upper_num = *(u64 *)data;
+	lower_num = *(u64 *)(data + 8);
+#else
+	upper_num = *(u64 *)(data + 8);
+	lower_num = *(u64 *)data;
+#endif
+	if (upper_num == 0)
+		btf_show_type_value(show, "0x%" FMT64 "x", lower_num);
+	else
+		btf_show_type_values(show, "0x%" FMT64 "x%016" FMT64 "x",
+				     upper_num, lower_num);
+}
+
+static void btf_int128_shift(u64 *print_num, u16 left_shift_bits,
+			     u16 right_shift_bits)
+{
+	u64 upper_num, lower_num;
+
+#ifdef __BIG_ENDIAN_BITFIELD
+	upper_num = print_num[0];
+	lower_num = print_num[1];
+#else
+	upper_num = print_num[1];
+	lower_num = print_num[0];
+#endif
+
+	/* shake out un-needed bits by shift/or operations */
+	if (left_shift_bits >= 64) {
+		upper_num = lower_num << (left_shift_bits - 64);
+		lower_num = 0;
+	} else {
+		upper_num = (upper_num << left_shift_bits) |
+			    (lower_num >> (64 - left_shift_bits));
+		lower_num = lower_num << left_shift_bits;
+	}
+
+	if (right_shift_bits >= 64) {
+		lower_num = upper_num >> (right_shift_bits - 64);
+		upper_num = 0;
+	} else {
+		lower_num = (lower_num >> right_shift_bits) |
+			    (upper_num << (64 - right_shift_bits));
+		upper_num = upper_num >> right_shift_bits;
+	}
+
+#ifdef __BIG_ENDIAN_BITFIELD
+	print_num[0] = upper_num;
+	print_num[1] = lower_num;
+#else
+	print_num[0] = lower_num;
+	print_num[1] = upper_num;
+#endif
+}
+
+static void btf_bitfield_show(void *data, u8 bits_offset,
+			      u8 nr_bits, struct btf_show *show)
+{
+	u16 left_shift_bits, right_shift_bits;
+	u8 nr_copy_bytes;
+	u8 nr_copy_bits;
+	u64 print_num[2] = {};
+
+	nr_copy_bits = nr_bits + bits_offset;
+	nr_copy_bytes = BITS_ROUNDUP_BYTES(nr_copy_bits);
+
+	memcpy(print_num, data, nr_copy_bytes);
+
+#ifdef __BIG_ENDIAN_BITFIELD
+	left_shift_bits = bits_offset;
+#else
+	left_shift_bits = BITS_PER_U128 - nr_copy_bits;
+#endif
+	right_shift_bits = BITS_PER_U128 - nr_bits;
+
+	btf_int128_shift(print_num, left_shift_bits, right_shift_bits);
+	btf_int128_print(show, print_num);
+}
+
+
+static void btf_int_bits_show(const struct btf *btf,
+			      const struct btf_type *t,
+			      void *data, u8 bits_offset,
+			      struct btf_show *show)
+{
+	u32 int_data = btf_type_int(t);
+	u8 nr_bits = BTF_INT_BITS(int_data);
+	u8 total_bits_offset;
+
+	/*
+	 * bits_offset is at most 7.
+	 * BTF_INT_OFFSET() cannot exceed 128 bits.
+	 */
+	total_bits_offset = bits_offset + BTF_INT_OFFSET(int_data);
+	data += BITS_ROUNDDOWN_BYTES(total_bits_offset);
+	bits_offset = BITS_PER_BYTE_MASKED(total_bits_offset);
+	btf_bitfield_show(data, bits_offset, nr_bits, show);
+}
+
+void btf_int_show(const struct btf *btf, const struct btf_type *t,
+		  u32 type_id, void *data, u8 bits_offset,
+		  struct btf_show *show)
+{
+	u32 int_data = btf_type_int(t);
+	u8 encoding = BTF_INT_ENCODING(int_data);
+	bool sign = encoding & BTF_INT_SIGNED;
+	u8 nr_bits = BTF_INT_BITS(int_data);
+	void *safe_data;
+
+	safe_data = btf_show_start_type(show, t, type_id, data);
+	if (!safe_data)
+		return;
+
+	if (bits_offset || BTF_INT_OFFSET(int_data) ||
+	    BITS_PER_BYTE_MASKED(nr_bits)) {
+		btf_int_bits_show(btf, t, safe_data, bits_offset, show);
+		goto out;
+	}
+
+	switch (nr_bits) {
+	case 128:
+		btf_int128_print(show, safe_data);
+		break;
+	case 64:
+		if (sign)
+			btf_show_type_value(show, "%" FMT64 "d",
+					    *(s64 *)safe_data);
+		else
+			btf_show_type_value(show, "%" FMT64 "u",
+					    *(u64 *)safe_data);
+		break;
+	case 32:
+		if (sign)
+			btf_show_type_value(show, "%d", *(s32 *)safe_data);
+		else
+			btf_show_type_value(show, "%u", *(u32 *)safe_data);
+		break;
+	case 16:
+		if (sign)
+			btf_show_type_value(show, "%d", *(s16 *)safe_data);
+		else
+			btf_show_type_value(show, "%u", *(u16 *)safe_data);
+		break;
+	case 8:
+		if (show->state.array_encoding == BTF_INT_CHAR) {
+			/* check for null terminator */
+			if (show->state.array_terminated)
+				break;
+			if (*(char *)data == '\0') {
+				show->state.array_terminated = 1;
+				break;
+			}
+			if (isprint(*(char *)data)) {
+				btf_show_type_value(show, "'%c'",
+						    *(char *)safe_data);
+				break;
+			}
+		}
+		if (sign)
+			btf_show_type_value(show, "%d", *(s8 *)safe_data);
+		else
+			btf_show_type_value(show, "%u", *(u8 *)safe_data);
+		break;
+	default:
+		btf_int_bits_show(btf, t, safe_data, bits_offset, show);
+		break;
+	}
+out:
+	btf_show_end_type(show);
+}
+
+void btf_modifier_show(const struct btf *btf,
+			      const struct btf_type *t,
+			      u32 type_id, void *data,
+			      u8 bits_offset, struct btf_show *show)
+{
+#ifdef __KERNEL__
+	if (btf_type_ids_resolved(btf))
+		t = btf_type_id_resolve(btf, &type_id);
+	else
+#endif /* __KERNEL__ */
+		t = btf_type_skip_modifiers(btf, type_id, NULL);
+
+	btf_type_ops_show(btf, t, type_id, data, bits_offset, show);
+}
+
+void btf_var_show(const struct btf *btf, const struct btf_type *t,
+		  u32 type_id, void *data, u8 bits_offset,
+		  struct btf_show *show)
+{
+	t = btf_type_id_resolve(btf, &type_id);
+
+	btf_type_ops_show(btf, t, type_id, data, bits_offset, show);
+}
+
+void btf_ptr_show(const struct btf *btf, const struct btf_type *t,
+		  u32 type_id, void *data, u8 bits_offset,
+		  struct btf_show *show)
+{
+	void *safe_data;
+
+	safe_data = btf_show_start_type(show, t, type_id, data);
+	if (!safe_data)
+		return;
+
+#ifdef __KERNEL__
+	/* It is a hashed value unless BTF_SHOW_PTR_RAW is specified */
+	if (show->flags & BTF_SHOW_PTR_RAW)
+		btf_show_type_value(show, "0x%px", *(void **)safe_data);
+	else
+		btf_show_type_value(show, "0x%p", *(void **)safe_data);
+#else
+	btf_show_type_value(show, "%p", *(void **)safe_data);
+#endif /* __KERNEL__ */
+	btf_show_end_type(show);
+}
+
+static void __btf_array_show(const struct btf *btf, const struct btf_type *t,
+			     u32 type_id, void *data, u8 bits_offset,
+			     struct btf_show *show)
+{
+	const struct btf_array *array = btf_type_array(t);
+	const struct btf_type *elem_type;
+	u32 i, elem_size = 0, elem_type_id;
+	u16 encoding = 0;
+
+	elem_type_id = array->type;
+	elem_type = btf_type_skip_modifiers(btf, elem_type_id, NULL);
+	if (elem_type && btf_type_has_size(elem_type))
+		elem_size = elem_type->size;
+
+	if (elem_type && btf_type_is_int(elem_type)) {
+		u32 int_type = btf_type_int(elem_type);
+
+		encoding = BTF_INT_ENCODING(int_type);
+
+		/*
+		 * BTF_INT_CHAR encoding never seems to be set for
+		 * char arrays, so if size is 1 and element is
+		 * printable as a char, we'll do that.
+		 */
+		if (elem_size == 1)
+			encoding = BTF_INT_CHAR;
+	}
+
+	if (!btf_show_start_array_type(show, t, type_id, encoding, data))
+		return;
+
+	if (!elem_type)
+		goto out;
+
+	for (i = 0; i < array->nelems; i++) {
+
+		btf_show_start_array_member(show);
+
+		btf_type_ops_show(btf, elem_type, elem_type_id, data,
+				  bits_offset, show);
+		data += elem_size;
+
+		btf_show_end_array_member(show);
+
+		if (show->state.array_terminated)
+			break;
+	}
+out:
+	btf_show_end_array_type(show);
+}
+
+void btf_array_show(const struct btf *btf, const struct btf_type *t,
+		    u32 type_id, void *data, u8 bits_offset,
+		    struct btf_show *show)
+{
+	const struct btf_member *m = show->state.member;
+
+	/*
+	 * First check if any members would be shown (are non-zero).
+	 * See comments above "struct btf_show" definition for more
+	 * details on how this works at a high-level.
+	 */
+	if (show->state.depth > 0 && !(show->flags & BTF_SHOW_ZERO)) {
+		if (!show->state.depth_check) {
+			show->state.depth_check = show->state.depth + 1;
+			show->state.depth_to_show = 0;
+		}
+		__btf_array_show(btf, t, type_id, data, bits_offset, show);
+		show->state.member = m;
+
+		if (show->state.depth_check != show->state.depth + 1)
+			return;
+		show->state.depth_check = 0;
+
+		if (show->state.depth_to_show <= show->state.depth)
+			return;
+		/*
+		 * Reaching here indicates we have recursed and found
+		 * non-zero array member(s).
+		 */
+	}
+	__btf_array_show(btf, t, type_id, data, bits_offset, show);
+}
+
+static void __btf_struct_show(const struct btf *btf, const struct btf_type *t,
+			      u32 type_id, void *data, u8 bits_offset,
+			      struct btf_show *show)
+{
+	const struct btf_member *member;
+	void *safe_data;
+	u32 i;
+
+	safe_data = btf_show_start_struct_type(show, t, type_id, data);
+	if (!safe_data)
+		return;
+
+	for_each_member(i, t, member) {
+		const struct btf_type *member_type = btf_type_by_id(btf,
+								member->type);
+		u32 member_offset, bitfield_size;
+		u32 bytes_offset;
+		u8 bits8_offset;
+
+		btf_show_start_member(show, member);
+
+		/* btf_member_*() function signatures differ between kernel
+		 * and userspace.
+		 */
+#ifdef __KERNEL__
+		member_offset = btf_member_bit_offset(t, member);
+		bitfield_size = btf_member_bitfield_size(t, member);
+#else
+		member_offset = btf_member_bit_offset(t, i);
+		bitfield_size = btf_member_bitfield_size(t, i);
+#endif
+
+		bytes_offset = BITS_ROUNDDOWN_BYTES(member_offset);
+		bits8_offset = BITS_PER_BYTE_MASKED(member_offset);
+		if (bitfield_size) {
+			safe_data = btf_show_start_type(show, member_type,
+							member->type,
+							data + bytes_offset);
+			if (safe_data)
+				btf_bitfield_show(safe_data,
+						  bits8_offset,
+						  bitfield_size, show);
+			btf_show_end_type(show);
+		} else {
+			btf_type_ops_show(btf, member_type, member->type,
+					  data + bytes_offset, bits8_offset,
+					  show);
+		}
+
+		btf_show_end_member(show);
+	}
+
+	btf_show_end_struct_type(show);
+}
+
+void btf_struct_show(const struct btf *btf, const struct btf_type *t,
+		     u32 type_id, void *data, u8 bits_offset,
+		     struct btf_show *show)
+{
+	const struct btf_member *m = show->state.member;
+
+	/*
+	 * First check if any members would be shown (are non-zero).
+	 * See comments above "struct btf_show" definition for more
+	 * details on how this works at a high-level.
+	 */
+	if (show->state.depth > 0 && !(show->flags & BTF_SHOW_ZERO)) {
+		if (!show->state.depth_check) {
+			show->state.depth_check = show->state.depth + 1;
+			show->state.depth_to_show = 0;
+		}
+		__btf_struct_show(btf, t, type_id, data, bits_offset, show);
+		/* Restore saved member data here */
+		show->state.member = m;
+		if (show->state.depth_check != show->state.depth + 1)
+			return;
+		show->state.depth_check = 0;
+
+		if (show->state.depth_to_show <= show->state.depth)
+			return;
+		/*
+		 * Reaching here indicates we have recursed and found
+		 * non-zero child values.
+		 */
+	}
+
+	__btf_struct_show(btf, t, type_id, data, bits_offset, show);
+}
+
+void btf_enum_show(const struct btf *btf, const struct btf_type *t,
+		   u32 type_id, void *data, u8 bits_offset,
+		   struct btf_show *show)
+{
+	const struct btf_enum *enums = btf_type_enum(t);
+	u32 i, nr_enums = btf_type_vlen(t);
+	void *safe_data;
+	int v;
+
+	safe_data = btf_show_start_type(show, t, type_id, data);
+	if (!safe_data)
+		return;
+
+	v = *(int *)safe_data;
+
+	for (i = 0; i < nr_enums; i++) {
+		if (v != enums[i].val)
+			continue;
+
+		btf_show_type_value(show, "%s",
+				    __btf_name_by_offset(btf,
+							 enums[i].name_off));
+
+		btf_show_end_type(show);
+		return;
+	}
+
+	btf_show_type_value(show, "%d", v);
+	btf_show_end_type(show);
+}
+
+void btf_datasec_show(const struct btf *btf,
+		      const struct btf_type *t, u32 type_id,
+		      void *data, u8 bits_offset,
+		      struct btf_show *show)
+{
+	const struct btf_var_secinfo *vsi;
+	const struct btf_type *var;
+	u32 i;
+
+	if (!btf_show_start_type(show, t, type_id, data))
+		return;
+
+	btf_show_type_value(show, "section (\"%s\") = {",
+			    __btf_name_by_offset(btf, t->name_off));
+	for_each_vsi(i, t, vsi) {
+		var = btf_type_by_id(btf, vsi->type);
+		if (i)
+			btf_show(show, ",");
+		btf_type_ops_show(btf, var, vsi->type,
+				  data + vsi->offset, bits_offset, show);
+	}
+	btf_show_end_type(show);
+}
+
+static void btf_type_show(const struct btf *btf, u32 type_id, void *obj,
+			  struct btf_show *show)
+{
+	const struct btf_type *t = btf_type_by_id(btf, type_id);
+
+	show->btf = btf;
+	memset(&show->state, 0, sizeof(show->state));
+	memset(&show->obj, 0, sizeof(show->obj));
+
+	btf_type_ops_show(btf, t, type_id, obj, 0, show);
+}
+
+/* seq_file show is for kernel only. */
+#ifdef __KERNEL__
+static void btf_seq_show(struct btf_show *show, const char *fmt,
+			 va_list args)
+{
+	seq_vprintf((struct seq_file *)show->target, fmt, args);
+}
+
+int btf_type_seq_show_flags(const struct btf *btf, u32 type_id,
+			    void *obj, struct seq_file *m, u64 flags)
+{
+	struct btf_show sseq;
+
+	sseq.target = m;
+	sseq.showfn = btf_seq_show;
+	sseq.flags = flags;
+
+	btf_type_show(btf, type_id, obj, &sseq);
+
+	return sseq.state.status;
+}
+
+void btf_type_seq_show(const struct btf *btf, u32 type_id, void *obj,
+		       struct seq_file *m)
+{
+	(void) btf_type_seq_show_flags(btf, type_id, obj, m,
+				       BTF_SHOW_NONAME | BTF_SHOW_COMPACT |
+				       BTF_SHOW_ZERO | BTF_SHOW_UNSAFE);
+}
+
+#endif /* __KERNEL__ */
+
+struct btf_show_snprintf {
+	struct btf_show show;
+	int len_left;		/* space left in string */
+	int len;		/* length we would have written */
+};
+
+static void btf_snprintf_show(struct btf_show *show, const char *fmt,
+			      va_list args)
+{
+	struct btf_show_snprintf *ssnprintf = (struct btf_show_snprintf *)show;
+	int len;
+
+	len = vsnprintf(show->target, ssnprintf->len_left, fmt, args);
+
+	if (len < 0) {
+		ssnprintf->len_left = 0;
+		ssnprintf->len = len;
+	} else if (len > ssnprintf->len_left) {
+		/* no space, drive on to get length we would have written */
+		ssnprintf->len_left = 0;
+		ssnprintf->len += len;
+	} else {
+		ssnprintf->len_left -= len;
+		ssnprintf->len += len;
+		show->target += len;
+	}
+}
+
+int btf_type_snprintf_show(const struct btf *btf, u32 type_id, void *obj,
+			   char *buf, int len, u64 flags)
+{
+	struct btf_show_snprintf ssnprintf;
+
+	ssnprintf.show.target = buf;
+	ssnprintf.show.flags = flags;
+	ssnprintf.show.showfn = btf_snprintf_show;
+	ssnprintf.len_left = len;
+	ssnprintf.len = 0;
+
+	btf_type_show(btf, type_id, obj, (struct btf_show *)&ssnprintf);
+
+	/* If we encontered an error, return it. */
+	if (ssnprintf.show.state.status)
+		return ssnprintf.show.state.status;
+
+	/* Otherwise return length we would have written */
+	return ssnprintf.len;
+}
+
+#ifndef __KERNEL__
+int btf__snprintf(struct btf *btf, char *buf, int len, __u32 id, void *obj,
+		  __u64 flags)
+{
+	return btf_type_snprintf_show(btf, id, obj, buf, len, flags);
+}
+#endif /* __KERNEL__ */
diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
index 1c0fd2d..35bd9dc 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -346,6 +346,7 @@ LIBBPF_0.3.0 {
 		btf__parse_split;
 		btf__new_empty_split;
 		btf__new_split;
+		btf__snprintf;
 		ring_buffer__epoll_fd;
 		xsk_setup_xdp_prog;
 		xsk_socket__update_xskmap;
-- 
1.8.3.1

