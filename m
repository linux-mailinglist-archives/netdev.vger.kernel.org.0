Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA08D1A314
	for <lists+netdev@lfdr.de>; Fri, 10 May 2019 20:42:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727962AbfEJSmB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 May 2019 14:42:01 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:60794 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727953AbfEJSmA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 May 2019 14:42:00 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.27/8.16.0.27) with SMTP id x4AIcbrM028360
        for <netdev@vger.kernel.org>; Fri, 10 May 2019 11:41:58 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=LjIYsaO6YNUs964qfmG5hs7tIneBVxTe+a2gYwThgaI=;
 b=mbtlKIrY7zNbsnfPhER4LLrecEzrhP59ng2nQ0HY6GNruQsANjReJ5ZosG8qdqrX13by
 me2bvb/9u+sLQ5JbKLgUbYwl4mjhG9zfqgYxJ9SARCxngnxaXoGO2V3oW227cZihVtZu
 P9s7zbBpMWUYxlrNndOwlmh/OTR95NB9DIU= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by m0089730.ppops.net with ESMTP id 2sd67et85b-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 10 May 2019 11:41:58 -0700
Received: from mx-out.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Fri, 10 May 2019 11:41:56 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id C54E986254F; Fri, 10 May 2019 11:41:51 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <andrii.nakryiko@gmail.com>, <netdev@vger.kernel.org>,
        <ast@fb.com>, <yhs@fb.com>, <daniel@iogearbox.net>
CC:     Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH v2 bpf] libbpf: detect supported kernel BTF features and sanitize BTF
Date:   Fri, 10 May 2019 11:41:50 -0700
Message-ID: <20190510184150.1671773-1-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-09_02:,,
 signatures=0
X-Proofpoint-Spam-Reason: safe
X-FB-Internal: Safe
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Depending on used versions of libbpf, Clang, and kernel, it's possible to
have valid BPF object files with valid BTF information, that still won't
load successfully due to Clang emitting newer BTF features (e.g.,
BTF_KIND_FUNC, .BTF.ext's line_info/func_info, BTF_KIND_DATASEC, etc), that
are not yet supported by older kernel.

This patch adds detection of BTF features and sanitizes BPF object's BTF
by substituting various supported BTF kinds, which have compatible layout:
  - BTF_KIND_FUNC -> BTF_KIND_TYPEDEF
  - BTF_KIND_FUNC_PROTO -> BTF_KIND_ENUM
  - BTF_KIND_VAR -> BTF_KIND_INT
  - BTF_KIND_DATASEC -> BTF_KIND_STRUCT

Replacement is done in such a way as to preserve as much information as
possible (names, sizes, etc) where possible without violating kernel's
validation rules.

v1->v2:
  - add internal libbpf_util.h w/ common stuff
  - switch SK storage BTF to use new libbpf__probe_raw_btf()

Reported-by: Alexei Starovoitov <ast@fb.com>
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/libbpf.c          | 130 +++++++++++++++++++++++++++++++-
 tools/lib/bpf/libbpf_internal.h |  27 +++++++
 tools/lib/bpf/libbpf_probes.c   |  73 ++++++++++--------
 tools/lib/bpf/libbpf_util.h     |  12 +++
 4 files changed, 209 insertions(+), 33 deletions(-)
 create mode 100644 tools/lib/bpf/libbpf_internal.h

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 11a65db4b93f..7e3b79d7c25f 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -44,6 +44,7 @@
 #include "btf.h"
 #include "str_error.h"
 #include "libbpf_util.h"
+#include "libbpf_internal.h"
 
 #ifndef EM_BPF
 #define EM_BPF 247
@@ -128,6 +129,10 @@ struct bpf_capabilities {
 	__u32 name:1;
 	/* v5.2: kernel support for global data sections. */
 	__u32 global_data:1;
+	/* BTF_KIND_FUNC and BTF_KIND_FUNC_PROTO support */
+	__u32 btf_func:1;
+	/* BTF_KIND_VAR and BTF_KIND_DATASEC support */
+	__u32 btf_datasec:1;
 };
 
 /*
@@ -1021,6 +1026,74 @@ static bool section_have_execinstr(struct bpf_object *obj, int idx)
 	return false;
 }
 
+static void bpf_object__sanitize_btf(struct bpf_object *obj)
+{
+	bool has_datasec = obj->caps.btf_datasec;
+	bool has_func = obj->caps.btf_func;
+	struct btf *btf = obj->btf;
+	struct btf_type *t;
+	int i, j, vlen;
+	__u16 kind;
+
+	if (!obj->btf || (has_func && has_datasec))
+		return;
+
+	for (i = 1; i <= btf__get_nr_types(btf); i++) {
+		t = (struct btf_type *)btf__type_by_id(btf, i);
+		kind = BTF_INFO_KIND(t->info);
+
+		if (!has_datasec && kind == BTF_KIND_VAR) {
+			/* replace VAR with INT */
+			t->info = BTF_INFO_ENC(BTF_KIND_INT, 0, 0);
+			t->size = sizeof(int);
+			*(int *)(t+1) = BTF_INT_ENC(0, 0, 32);
+		} else if (!has_datasec && kind == BTF_KIND_DATASEC) {
+			/* replace DATASEC with STRUCT */
+			struct btf_var_secinfo *v = (void *)(t + 1);
+			struct btf_member *m = (void *)(t + 1);
+			struct btf_type *vt;
+			char *name;
+
+			name = (char *)btf__name_by_offset(btf, t->name_off);
+			while (*name) {
+				if (*name == '.')
+					*name = '_';
+				name++;
+			}
+
+			vlen = BTF_INFO_VLEN(t->info);
+			t->info = BTF_INFO_ENC(BTF_KIND_STRUCT, 0, vlen);
+			for (j = 0; j < vlen; j++, v++, m++) {
+				/* order of field assignments is important */
+				m->offset = v->offset * 8;
+				m->type = v->type;
+				/* preserve variable name as member name */
+				vt = (void *)btf__type_by_id(btf, v->type);
+				m->name_off = vt->name_off;
+			}
+		} else if (!has_func && kind == BTF_KIND_FUNC_PROTO) {
+			/* replace FUNC_PROTO with ENUM */
+			vlen = BTF_INFO_VLEN(t->info);
+			t->info = BTF_INFO_ENC(BTF_KIND_ENUM, 0, vlen);
+			t->size = sizeof(__u32); /* kernel enforced */
+		} else if (!has_func && kind == BTF_KIND_FUNC) {
+			/* replace FUNC with TYPEDEF */
+			t->info = BTF_INFO_ENC(BTF_KIND_TYPEDEF, 0, 0);
+		}
+	}
+}
+
+static void bpf_object__sanitize_btf_ext(struct bpf_object *obj)
+{
+	if (!obj->btf_ext)
+		return;
+
+	if (!obj->caps.btf_func) {
+		btf_ext__free(obj->btf_ext);
+		obj->btf_ext = NULL;
+	}
+}
+
 static int bpf_object__elf_collect(struct bpf_object *obj, int flags)
 {
 	Elf *elf = obj->efile.elf;
@@ -1164,8 +1237,10 @@ static int bpf_object__elf_collect(struct bpf_object *obj, int flags)
 			obj->btf = NULL;
 		} else {
 			err = btf__finalize_data(obj, obj->btf);
-			if (!err)
+			if (!err) {
+				bpf_object__sanitize_btf(obj);
 				err = btf__load(obj->btf);
+			}
 			if (err) {
 				pr_warning("Error finalizing and loading %s into kernel: %d. Ignored and continue.\n",
 					   BTF_ELF_SEC, err);
@@ -1187,6 +1262,8 @@ static int bpf_object__elf_collect(struct bpf_object *obj, int flags)
 					   BTF_EXT_ELF_SEC,
 					   PTR_ERR(obj->btf_ext));
 				obj->btf_ext = NULL;
+			} else {
+				bpf_object__sanitize_btf_ext(obj);
 			}
 		}
 	}
@@ -1556,12 +1633,63 @@ bpf_object__probe_global_data(struct bpf_object *obj)
 	return 0;
 }
 
+static int bpf_object__probe_btf_func(struct bpf_object *obj)
+{
+	const char strs[] = "\0int\0x\0a";
+	/* void x(int a) {} */
+	__u32 types[] = {
+		/* int */
+		BTF_TYPE_INT_ENC(1, BTF_INT_SIGNED, 0, 32, 4),  /* [1] */
+		/* FUNC_PROTO */                                /* [2] */
+		BTF_TYPE_ENC(0, BTF_INFO_ENC(BTF_KIND_FUNC_PROTO, 0, 1), 0),
+		BTF_PARAM_ENC(7, 1),
+		/* FUNC x */                                    /* [3] */
+		BTF_TYPE_ENC(5, BTF_INFO_ENC(BTF_KIND_FUNC, 0, 0), 2),
+	};
+	int res;
+
+	res = libbpf__probe_raw_btf((char *)types, sizeof(types),
+				    strs, sizeof(strs));
+	if (res < 0)
+		return res;
+	if (res > 0)
+		obj->caps.btf_func = 1;
+	return 0;
+}
+
+static int bpf_object__probe_btf_datasec(struct bpf_object *obj)
+{
+	const char strs[] = "\0x\0.data";
+	/* static int a; */
+	__u32 types[] = {
+		/* int */
+		BTF_TYPE_INT_ENC(0, BTF_INT_SIGNED, 0, 32, 4),  /* [1] */
+		/* VAR x */                                     /* [2] */
+		BTF_TYPE_ENC(1, BTF_INFO_ENC(BTF_KIND_VAR, 0, 0), 1),
+		BTF_VAR_STATIC,
+		/* DATASEC val */                               /* [3] */
+		BTF_TYPE_ENC(3, BTF_INFO_ENC(BTF_KIND_DATASEC, 0, 1), 4),
+		BTF_VAR_SECINFO_ENC(2, 0, 4),
+	};
+	int res;
+
+	res = libbpf__probe_raw_btf((char *)types, sizeof(types),
+				    strs, sizeof(strs));
+	if (res < 0)
+		return res;
+	if (res > 0)
+		obj->caps.btf_datasec = 1;
+	return 0;
+}
+
 static int
 bpf_object__probe_caps(struct bpf_object *obj)
 {
 	int (*probe_fn[])(struct bpf_object *obj) = {
 		bpf_object__probe_name,
 		bpf_object__probe_global_data,
+		bpf_object__probe_btf_func,
+		bpf_object__probe_btf_datasec,
 	};
 	int i, ret;
 
diff --git a/tools/lib/bpf/libbpf_internal.h b/tools/lib/bpf/libbpf_internal.h
new file mode 100644
index 000000000000..789e435b5900
--- /dev/null
+++ b/tools/lib/bpf/libbpf_internal.h
@@ -0,0 +1,27 @@
+/* SPDX-License-Identifier: (LGPL-2.1 OR BSD-2-Clause) */
+
+/*
+ * Internal libbpf helpers.
+ *
+ * Copyright (c) 2019 Facebook
+ */
+
+#ifndef __LIBBPF_LIBBPF_INTERNAL_H
+#define __LIBBPF_LIBBPF_INTERNAL_H
+
+#define BTF_INFO_ENC(kind, kind_flag, vlen) \
+	((!!(kind_flag) << 31) | ((kind) << 24) | ((vlen) & BTF_MAX_VLEN))
+#define BTF_TYPE_ENC(name, info, size_or_type) (name), (info), (size_or_type)
+#define BTF_INT_ENC(encoding, bits_offset, nr_bits) \
+	((encoding) << 24 | (bits_offset) << 16 | (nr_bits))
+#define BTF_TYPE_INT_ENC(name, encoding, bits_offset, bits, sz) \
+	BTF_TYPE_ENC(name, BTF_INFO_ENC(BTF_KIND_INT, 0, 0), sz), \
+	BTF_INT_ENC(encoding, bits_offset, bits)
+#define BTF_MEMBER_ENC(name, type, bits_offset) (name), (type), (bits_offset)
+#define BTF_PARAM_ENC(name, type) (name), (type)
+#define BTF_VAR_SECINFO_ENC(type, offset, size) (type), (offset), (size)
+
+int libbpf__probe_raw_btf(const char *raw_types, size_t types_len,
+			  const char *str_sec, size_t str_len);
+
+#endif /* __LIBBPF_LIBBPF_INTERNAL_H */
diff --git a/tools/lib/bpf/libbpf_probes.c b/tools/lib/bpf/libbpf_probes.c
index a2c64a9ce1a6..5e2aa83f637a 100644
--- a/tools/lib/bpf/libbpf_probes.c
+++ b/tools/lib/bpf/libbpf_probes.c
@@ -15,6 +15,7 @@
 
 #include "bpf.h"
 #include "libbpf.h"
+#include "libbpf_internal.h"
 
 static bool grep(const char *buffer, const char *pattern)
 {
@@ -132,21 +133,43 @@ bool bpf_probe_prog_type(enum bpf_prog_type prog_type, __u32 ifindex)
 	return errno != EINVAL && errno != EOPNOTSUPP;
 }
 
-static int load_btf(void)
+int libbpf__probe_raw_btf(const char *raw_types, size_t types_len,
+			  const char *str_sec, size_t str_len)
 {
-#define BTF_INFO_ENC(kind, kind_flag, vlen) \
-	((!!(kind_flag) << 31) | ((kind) << 24) | ((vlen) & BTF_MAX_VLEN))
-#define BTF_TYPE_ENC(name, info, size_or_type) \
-	(name), (info), (size_or_type)
-#define BTF_INT_ENC(encoding, bits_offset, nr_bits) \
-	((encoding) << 24 | (bits_offset) << 16 | (nr_bits))
-#define BTF_TYPE_INT_ENC(name, encoding, bits_offset, bits, sz) \
-	BTF_TYPE_ENC(name, BTF_INFO_ENC(BTF_KIND_INT, 0, 0), sz), \
-	BTF_INT_ENC(encoding, bits_offset, bits)
-#define BTF_MEMBER_ENC(name, type, bits_offset) \
-	(name), (type), (bits_offset)
-
-	const char btf_str_sec[] = "\0bpf_spin_lock\0val\0cnt\0l";
+	struct btf_header hdr = {
+		.magic = BTF_MAGIC,
+		.version = BTF_VERSION,
+		.hdr_len = sizeof(struct btf_header),
+		.type_len = types_len,
+		.str_off = types_len,
+		.str_len = str_len,
+	};
+	int btf_fd, btf_len;
+	__u8 *raw_btf;
+
+	btf_len = hdr.hdr_len + hdr.type_len + hdr.str_len;
+	raw_btf = malloc(btf_len);
+	if (!raw_btf)
+		return -ENOMEM;
+
+	memcpy(raw_btf, &hdr, sizeof(hdr));
+	memcpy(raw_btf + hdr.hdr_len, raw_types, hdr.type_len);
+	memcpy(raw_btf + hdr.hdr_len + hdr.type_len, str_sec, hdr.str_len);
+
+	btf_fd = bpf_load_btf(raw_btf, btf_len, NULL, 0, false);
+	if (btf_fd < 0) {
+		free(raw_btf);
+		return 0;
+	}
+
+	close(btf_fd);
+	free(raw_btf);
+	return 1;
+}
+
+static int load_sk_storage_btf(void)
+{
+	const char strs[] = "\0bpf_spin_lock\0val\0cnt\0l";
 	/* struct bpf_spin_lock {
 	 *   int val;
 	 * };
@@ -155,7 +178,7 @@ static int load_btf(void)
 	 *   struct bpf_spin_lock l;
 	 * };
 	 */
-	__u32 btf_raw_types[] = {
+	__u32 types[] = {
 		/* int */
 		BTF_TYPE_INT_ENC(0, BTF_INT_SIGNED, 0, 32, 4),  /* [1] */
 		/* struct bpf_spin_lock */                      /* [2] */
@@ -166,23 +189,9 @@ static int load_btf(void)
 		BTF_MEMBER_ENC(19, 1, 0), /* int cnt; */
 		BTF_MEMBER_ENC(23, 2, 32),/* struct bpf_spin_lock l; */
 	};
-	struct btf_header btf_hdr = {
-		.magic = BTF_MAGIC,
-		.version = BTF_VERSION,
-		.hdr_len = sizeof(struct btf_header),
-		.type_len = sizeof(btf_raw_types),
-		.str_off = sizeof(btf_raw_types),
-		.str_len = sizeof(btf_str_sec),
-	};
-	__u8 raw_btf[sizeof(struct btf_header) + sizeof(btf_raw_types) +
-		     sizeof(btf_str_sec)];
-
-	memcpy(raw_btf, &btf_hdr, sizeof(btf_hdr));
-	memcpy(raw_btf + sizeof(btf_hdr), btf_raw_types, sizeof(btf_raw_types));
-	memcpy(raw_btf + sizeof(btf_hdr) + sizeof(btf_raw_types),
-	       btf_str_sec, sizeof(btf_str_sec));
 
-	return bpf_load_btf(raw_btf, sizeof(raw_btf), 0, 0, 0);
+	return libbpf__probe_raw_btf((char *)types, sizeof(types),
+				     strs, sizeof(strs));
 }
 
 bool bpf_probe_map_type(enum bpf_map_type map_type, __u32 ifindex)
@@ -222,7 +231,7 @@ bool bpf_probe_map_type(enum bpf_map_type map_type, __u32 ifindex)
 		value_size = 8;
 		max_entries = 0;
 		map_flags = BPF_F_NO_PREALLOC;
-		btf_fd = load_btf();
+		btf_fd = load_sk_storage_btf();
 		if (btf_fd < 0)
 			return false;
 		break;
diff --git a/tools/lib/bpf/libbpf_util.h b/tools/lib/bpf/libbpf_util.h
index da94c4cb2e4d..319e744eb33a 100644
--- a/tools/lib/bpf/libbpf_util.h
+++ b/tools/lib/bpf/libbpf_util.h
@@ -57,4 +57,16 @@ do {				\
 } /* extern "C" */
 #endif
 
+#define BTF_INFO_ENC(kind, kind_flag, vlen) \
+	((!!(kind_flag) << 31) | ((kind) << 24) | ((vlen) & BTF_MAX_VLEN))
+#define BTF_TYPE_ENC(name, info, size_or_type) (name), (info), (size_or_type)
+#define BTF_INT_ENC(encoding, bits_offset, nr_bits) \
+	((encoding) << 24 | (bits_offset) << 16 | (nr_bits))
+#define BTF_TYPE_INT_ENC(name, encoding, bits_offset, bits, sz) \
+	BTF_TYPE_ENC(name, BTF_INFO_ENC(BTF_KIND_INT, 0, 0), sz), \
+	BTF_INT_ENC(encoding, bits_offset, bits)
+#define BTF_MEMBER_ENC(name, type, bits_offset) (name), (type), (bits_offset)
+#define BTF_PARAM_ENC(name, type) (name), (type)
+#define BTF_VAR_SECINFO_ENC(type, offset, size) (type), (offset), (size)
+
 #endif
-- 
2.17.1

