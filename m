Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A5F12A767E
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 05:34:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731698AbgKEEe3 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 4 Nov 2020 23:34:29 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:11700 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731472AbgKEEeZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 23:34:25 -0500
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0A54Y0xQ003238
        for <netdev@vger.kernel.org>; Wed, 4 Nov 2020 20:34:22 -0800
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 34kf5c7r82-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 04 Nov 2020 20:34:22 -0800
Received: from intmgw003.03.ash8.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:11d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 4 Nov 2020 20:34:20 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id CE6232EC8E04; Wed,  4 Nov 2020 20:34:16 -0800 (PST)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii@kernel.org>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Song Liu <songliubraving@fb.com>
Subject: [PATCH v2 bpf-next 06/11] selftests/bpf: add checking of raw type dump in BTF writer APIs selftests
Date:   Wed, 4 Nov 2020 20:33:56 -0800
Message-ID: <20201105043402.2530976-7-andrii@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20201105043402.2530976-1-andrii@kernel.org>
References: <20201105043402.2530976-1-andrii@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-05_01:2020-11-05,2020-11-05 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0 spamscore=0
 clxscore=1015 phishscore=0 impostorscore=0 mlxscore=0 mlxlogscore=999
 suspectscore=25 priorityscore=1501 malwarescore=0 bulkscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011050033
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrii Nakryiko <andriin@fb.com>

Add re-usable btf_helpers.{c,h} to provide BTF-related testing routines. Start
with adding a raw BTF dumping helpers.

Raw BTF dump is the most succinct and at the same time a very human-friendly
way to validate exact contents of BTF types. Cross-validate raw BTF dump and
writable BTF in a single selftest. Raw type dump checks also serve as a good
self-documentation.

Acked-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
---
 tools/testing/selftests/bpf/Makefile          |   2 +-
 tools/testing/selftests/bpf/btf_helpers.c     | 200 ++++++++++++++++++
 tools/testing/selftests/bpf/btf_helpers.h     |  12 ++
 .../selftests/bpf/prog_tests/btf_write.c      |  43 ++++
 4 files changed, 256 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/bpf/btf_helpers.c
 create mode 100644 tools/testing/selftests/bpf/btf_helpers.h

diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index 50e5b18fc455..c1708ffa6b1c 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -386,7 +386,7 @@ TRUNNER_TESTS_DIR := prog_tests
 TRUNNER_BPF_PROGS_DIR := progs
 TRUNNER_EXTRA_SOURCES := test_progs.c cgroup_helpers.c trace_helpers.c	\
 			 network_helpers.c testing_helpers.c		\
-			 flow_dissector_load.h
+			 btf_helpers.c	flow_dissector_load.h
 TRUNNER_EXTRA_FILES := $(OUTPUT)/urandom_read				\
 		       $(wildcard progs/btf_dump_test_case_*.c)
 TRUNNER_BPF_BUILD_RULE := CLANG_BPF_BUILD_RULE
diff --git a/tools/testing/selftests/bpf/btf_helpers.c b/tools/testing/selftests/bpf/btf_helpers.c
new file mode 100644
index 000000000000..abc3f6c04cfc
--- /dev/null
+++ b/tools/testing/selftests/bpf/btf_helpers.c
@@ -0,0 +1,200 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2020 Facebook */
+#include <stdio.h>
+#include <errno.h>
+#include <bpf/btf.h>
+
+static const char * const btf_kind_str_mapping[] = {
+	[BTF_KIND_UNKN]		= "UNKNOWN",
+	[BTF_KIND_INT]		= "INT",
+	[BTF_KIND_PTR]		= "PTR",
+	[BTF_KIND_ARRAY]	= "ARRAY",
+	[BTF_KIND_STRUCT]	= "STRUCT",
+	[BTF_KIND_UNION]	= "UNION",
+	[BTF_KIND_ENUM]		= "ENUM",
+	[BTF_KIND_FWD]		= "FWD",
+	[BTF_KIND_TYPEDEF]	= "TYPEDEF",
+	[BTF_KIND_VOLATILE]	= "VOLATILE",
+	[BTF_KIND_CONST]	= "CONST",
+	[BTF_KIND_RESTRICT]	= "RESTRICT",
+	[BTF_KIND_FUNC]		= "FUNC",
+	[BTF_KIND_FUNC_PROTO]	= "FUNC_PROTO",
+	[BTF_KIND_VAR]		= "VAR",
+	[BTF_KIND_DATASEC]	= "DATASEC",
+};
+
+static const char *btf_kind_str(__u16 kind)
+{
+	if (kind > BTF_KIND_DATASEC)
+		return "UNKNOWN";
+	return btf_kind_str_mapping[kind];
+}
+
+static const char *btf_int_enc_str(__u8 encoding)
+{
+	switch (encoding) {
+	case 0:
+		return "(none)";
+	case BTF_INT_SIGNED:
+		return "SIGNED";
+	case BTF_INT_CHAR:
+		return "CHAR";
+	case BTF_INT_BOOL:
+		return "BOOL";
+	default:
+		return "UNKN";
+	}
+}
+
+static const char *btf_var_linkage_str(__u32 linkage)
+{
+	switch (linkage) {
+	case BTF_VAR_STATIC:
+		return "static";
+	case BTF_VAR_GLOBAL_ALLOCATED:
+		return "global-alloc";
+	default:
+		return "(unknown)";
+	}
+}
+
+static const char *btf_func_linkage_str(const struct btf_type *t)
+{
+	switch (btf_vlen(t)) {
+	case BTF_FUNC_STATIC:
+		return "static";
+	case BTF_FUNC_GLOBAL:
+		return "global";
+	case BTF_FUNC_EXTERN:
+		return "extern";
+	default:
+		return "(unknown)";
+	}
+}
+
+static const char *btf_str(const struct btf *btf, __u32 off)
+{
+	if (!off)
+		return "(anon)";
+	return btf__str_by_offset(btf, off) ?: "(invalid)";
+}
+
+int fprintf_btf_type_raw(FILE *out, const struct btf *btf, __u32 id)
+{
+	const struct btf_type *t;
+	int kind, i;
+	__u32 vlen;
+
+	t = btf__type_by_id(btf, id);
+	if (!t)
+		return -EINVAL;
+
+	vlen = btf_vlen(t);
+	kind = btf_kind(t);
+
+	fprintf(out, "[%u] %s '%s'", id, btf_kind_str(kind), btf_str(btf, t->name_off));
+
+	switch (kind) {
+	case BTF_KIND_INT:
+		fprintf(out, " size=%u bits_offset=%u nr_bits=%u encoding=%s",
+			t->size, btf_int_offset(t), btf_int_bits(t),
+			btf_int_enc_str(btf_int_encoding(t)));
+		break;
+	case BTF_KIND_PTR:
+	case BTF_KIND_CONST:
+	case BTF_KIND_VOLATILE:
+	case BTF_KIND_RESTRICT:
+	case BTF_KIND_TYPEDEF:
+		fprintf(out, " type_id=%u", t->type);
+		break;
+	case BTF_KIND_ARRAY: {
+		const struct btf_array *arr = btf_array(t);
+
+		fprintf(out, " type_id=%u index_type_id=%u nr_elems=%u",
+			arr->type, arr->index_type, arr->nelems);
+		break;
+	}
+	case BTF_KIND_STRUCT:
+	case BTF_KIND_UNION: {
+		const struct btf_member *m = btf_members(t);
+
+		fprintf(out, " size=%u vlen=%u", t->size, vlen);
+		for (i = 0; i < vlen; i++, m++) {
+			__u32 bit_off, bit_sz;
+
+			bit_off = btf_member_bit_offset(t, i);
+			bit_sz = btf_member_bitfield_size(t, i);
+			fprintf(out, "\n\t'%s' type_id=%u bits_offset=%u",
+				btf_str(btf, m->name_off), m->type, bit_off);
+			if (bit_sz)
+				fprintf(out, " bitfield_size=%u", bit_sz);
+		}
+		break;
+	}
+	case BTF_KIND_ENUM: {
+		const struct btf_enum *v = btf_enum(t);
+
+		fprintf(out, " size=%u vlen=%u", t->size, vlen);
+		for (i = 0; i < vlen; i++, v++) {
+			fprintf(out, "\n\t'%s' val=%u",
+				btf_str(btf, v->name_off), v->val);
+		}
+		break;
+	}
+	case BTF_KIND_FWD:
+		fprintf(out, " fwd_kind=%s", btf_kflag(t) ? "union" : "struct");
+		break;
+	case BTF_KIND_FUNC:
+		fprintf(out, " type_id=%u linkage=%s", t->type, btf_func_linkage_str(t));
+		break;
+	case BTF_KIND_FUNC_PROTO: {
+		const struct btf_param *p = btf_params(t);
+
+		fprintf(out, " ret_type_id=%u vlen=%u", t->type, vlen);
+		for (i = 0; i < vlen; i++, p++) {
+			fprintf(out, "\n\t'%s' type_id=%u",
+				btf_str(btf, p->name_off), p->type);
+		}
+		break;
+	}
+	case BTF_KIND_VAR:
+		fprintf(out, " type_id=%u, linkage=%s",
+			t->type, btf_var_linkage_str(btf_var(t)->linkage));
+		break;
+	case BTF_KIND_DATASEC: {
+		const struct btf_var_secinfo *v = btf_var_secinfos(t);
+
+		fprintf(out, " size=%u vlen=%u", t->size, vlen);
+		for (i = 0; i < vlen; i++, v++) {
+			fprintf(out, "\n\ttype_id=%u offset=%u size=%u",
+				v->type, v->offset, v->size);
+		}
+		break;
+	}
+	default:
+		break;
+	}
+
+	return 0;
+}
+
+/* Print raw BTF type dump into a local buffer and return string pointer back.
+ * Buffer *will* be overwritten by subsequent btf_type_raw_dump() calls
+ */
+const char *btf_type_raw_dump(const struct btf *btf, int type_id)
+{
+	static char buf[16 * 1024];
+	FILE *buf_file;
+
+	buf_file = fmemopen(buf, sizeof(buf) - 1, "w");
+	if (!buf_file) {
+		fprintf(stderr, "Failed to open memstream: %d\n", errno);
+		return NULL;
+	}
+
+	fprintf_btf_type_raw(buf_file, btf, type_id);
+	fflush(buf_file);
+	fclose(buf_file);
+
+	return buf;
+}
diff --git a/tools/testing/selftests/bpf/btf_helpers.h b/tools/testing/selftests/bpf/btf_helpers.h
new file mode 100644
index 000000000000..2c9ce1b61dc9
--- /dev/null
+++ b/tools/testing/selftests/bpf/btf_helpers.h
@@ -0,0 +1,12 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (c) 2020 Facebook */
+#ifndef __BTF_HELPERS_H
+#define __BTF_HELPERS_H
+
+#include <stdio.h>
+#include <bpf/btf.h>
+
+int fprintf_btf_type_raw(FILE *out, const struct btf *btf, __u32 id);
+const char *btf_type_raw_dump(const struct btf *btf, int type_id);
+
+#endif
diff --git a/tools/testing/selftests/bpf/prog_tests/btf_write.c b/tools/testing/selftests/bpf/prog_tests/btf_write.c
index 314e1e7c36df..f36da15b134f 100644
--- a/tools/testing/selftests/bpf/prog_tests/btf_write.c
+++ b/tools/testing/selftests/bpf/prog_tests/btf_write.c
@@ -2,6 +2,7 @@
 /* Copyright (c) 2020 Facebook */
 #include <test_progs.h>
 #include <bpf/btf.h>
+#include "btf_helpers.h"
 
 static int duration = 0;
 
@@ -39,6 +40,8 @@ void test_btf_write() {
 	ASSERT_EQ(t->size, 4, "int_sz");
 	ASSERT_EQ(btf_int_encoding(t), BTF_INT_SIGNED, "int_enc");
 	ASSERT_EQ(btf_int_bits(t), 32, "int_bits");
+	ASSERT_STREQ(btf_type_raw_dump(btf, 1),
+		     "[1] INT 'int' size=4 bits_offset=0 nr_bits=32 encoding=SIGNED", "raw_dump");
 
 	/* invalid int size */
 	id = btf__add_int(btf, "bad sz int", 7, 0);
@@ -59,24 +62,32 @@ void test_btf_write() {
 	t = btf__type_by_id(btf, 2);
 	ASSERT_EQ(btf_kind(t), BTF_KIND_PTR, "ptr_kind");
 	ASSERT_EQ(t->type, 1, "ptr_type");
+	ASSERT_STREQ(btf_type_raw_dump(btf, 2),
+		     "[2] PTR '(anon)' type_id=1", "raw_dump");
 
 	id = btf__add_const(btf, 5); /* points forward to restrict */
 	ASSERT_EQ(id, 3, "const_id");
 	t = btf__type_by_id(btf, 3);
 	ASSERT_EQ(btf_kind(t), BTF_KIND_CONST, "const_kind");
 	ASSERT_EQ(t->type, 5, "const_type");
+	ASSERT_STREQ(btf_type_raw_dump(btf, 3),
+		     "[3] CONST '(anon)' type_id=5", "raw_dump");
 
 	id = btf__add_volatile(btf, 3);
 	ASSERT_EQ(id, 4, "volatile_id");
 	t = btf__type_by_id(btf, 4);
 	ASSERT_EQ(btf_kind(t), BTF_KIND_VOLATILE, "volatile_kind");
 	ASSERT_EQ(t->type, 3, "volatile_type");
+	ASSERT_STREQ(btf_type_raw_dump(btf, 4),
+		     "[4] VOLATILE '(anon)' type_id=3", "raw_dump");
 
 	id = btf__add_restrict(btf, 4);
 	ASSERT_EQ(id, 5, "restrict_id");
 	t = btf__type_by_id(btf, 5);
 	ASSERT_EQ(btf_kind(t), BTF_KIND_RESTRICT, "restrict_kind");
 	ASSERT_EQ(t->type, 4, "restrict_type");
+	ASSERT_STREQ(btf_type_raw_dump(btf, 5),
+		     "[5] RESTRICT '(anon)' type_id=4", "raw_dump");
 
 	/* ARRAY */
 	id = btf__add_array(btf, 1, 2, 10); /* int *[10] */
@@ -86,6 +97,8 @@ void test_btf_write() {
 	ASSERT_EQ(btf_array(t)->index_type, 1, "array_index_type");
 	ASSERT_EQ(btf_array(t)->type, 2, "array_elem_type");
 	ASSERT_EQ(btf_array(t)->nelems, 10, "array_nelems");
+	ASSERT_STREQ(btf_type_raw_dump(btf, 6),
+		     "[6] ARRAY '(anon)' type_id=2 index_type_id=1 nr_elems=10", "raw_dump");
 
 	/* STRUCT */
 	err = btf__add_field(btf, "field", 1, 0, 0);
@@ -113,6 +126,10 @@ void test_btf_write() {
 	ASSERT_EQ(m->type, 1, "f2_type");
 	ASSERT_EQ(btf_member_bit_offset(t, 1), 32, "f2_bit_off");
 	ASSERT_EQ(btf_member_bitfield_size(t, 1), 16, "f2_bit_sz");
+	ASSERT_STREQ(btf_type_raw_dump(btf, 7),
+		     "[7] STRUCT 's1' size=8 vlen=2\n"
+		     "\t'f1' type_id=1 bits_offset=0\n"
+		     "\t'f2' type_id=1 bits_offset=32 bitfield_size=16", "raw_dump");
 
 	/* UNION */
 	id = btf__add_union(btf, "u1", 8);
@@ -136,6 +153,9 @@ void test_btf_write() {
 	ASSERT_EQ(m->type, 1, "f1_type");
 	ASSERT_EQ(btf_member_bit_offset(t, 0), 0, "f1_bit_off");
 	ASSERT_EQ(btf_member_bitfield_size(t, 0), 16, "f1_bit_sz");
+	ASSERT_STREQ(btf_type_raw_dump(btf, 8),
+		     "[8] UNION 'u1' size=8 vlen=1\n"
+		     "\t'f1' type_id=1 bits_offset=0 bitfield_size=16", "raw_dump");
 
 	/* ENUM */
 	id = btf__add_enum(btf, "e1", 4);
@@ -156,6 +176,10 @@ void test_btf_write() {
 	v = btf_enum(t) + 1;
 	ASSERT_STREQ(btf__str_by_offset(btf, v->name_off), "v2", "v2_name");
 	ASSERT_EQ(v->val, 2, "v2_val");
+	ASSERT_STREQ(btf_type_raw_dump(btf, 9),
+		     "[9] ENUM 'e1' size=4 vlen=2\n"
+		     "\t'v1' val=1\n"
+		     "\t'v2' val=2", "raw_dump");
 
 	/* FWDs */
 	id = btf__add_fwd(btf, "struct_fwd", BTF_FWD_STRUCT);
@@ -164,6 +188,8 @@ void test_btf_write() {
 	ASSERT_STREQ(btf__str_by_offset(btf, t->name_off), "struct_fwd", "fwd_name");
 	ASSERT_EQ(btf_kind(t), BTF_KIND_FWD, "fwd_kind");
 	ASSERT_EQ(btf_kflag(t), 0, "fwd_kflag");
+	ASSERT_STREQ(btf_type_raw_dump(btf, 10),
+		     "[10] FWD 'struct_fwd' fwd_kind=struct", "raw_dump");
 
 	id = btf__add_fwd(btf, "union_fwd", BTF_FWD_UNION);
 	ASSERT_EQ(id, 11, "union_fwd_id");
@@ -171,6 +197,8 @@ void test_btf_write() {
 	ASSERT_STREQ(btf__str_by_offset(btf, t->name_off), "union_fwd", "fwd_name");
 	ASSERT_EQ(btf_kind(t), BTF_KIND_FWD, "fwd_kind");
 	ASSERT_EQ(btf_kflag(t), 1, "fwd_kflag");
+	ASSERT_STREQ(btf_type_raw_dump(btf, 11),
+		     "[11] FWD 'union_fwd' fwd_kind=union", "raw_dump");
 
 	id = btf__add_fwd(btf, "enum_fwd", BTF_FWD_ENUM);
 	ASSERT_EQ(id, 12, "enum_fwd_id");
@@ -179,6 +207,8 @@ void test_btf_write() {
 	ASSERT_EQ(btf_kind(t), BTF_KIND_ENUM, "enum_fwd_kind");
 	ASSERT_EQ(btf_vlen(t), 0, "enum_fwd_kind");
 	ASSERT_EQ(t->size, 4, "enum_fwd_sz");
+	ASSERT_STREQ(btf_type_raw_dump(btf, 12),
+		     "[12] ENUM 'enum_fwd' size=4 vlen=0", "raw_dump");
 
 	/* TYPEDEF */
 	id = btf__add_typedef(btf, "typedef1", 1);
@@ -187,6 +217,8 @@ void test_btf_write() {
 	ASSERT_STREQ(btf__str_by_offset(btf, t->name_off), "typedef1", "typedef_name");
 	ASSERT_EQ(btf_kind(t), BTF_KIND_TYPEDEF, "typedef_kind");
 	ASSERT_EQ(t->type, 1, "typedef_type");
+	ASSERT_STREQ(btf_type_raw_dump(btf, 13),
+		     "[13] TYPEDEF 'typedef1' type_id=1", "raw_dump");
 
 	/* FUNC & FUNC_PROTO */
 	id = btf__add_func(btf, "func1", BTF_FUNC_GLOBAL, 15);
@@ -196,6 +228,8 @@ void test_btf_write() {
 	ASSERT_EQ(t->type, 15, "func_type");
 	ASSERT_EQ(btf_kind(t), BTF_KIND_FUNC, "func_kind");
 	ASSERT_EQ(btf_vlen(t), BTF_FUNC_GLOBAL, "func_vlen");
+	ASSERT_STREQ(btf_type_raw_dump(btf, 14),
+		     "[14] FUNC 'func1' type_id=15 linkage=global", "raw_dump");
 
 	id = btf__add_func_proto(btf, 1);
 	ASSERT_EQ(id, 15, "func_proto_id");
@@ -214,6 +248,10 @@ void test_btf_write() {
 	p = btf_params(t) + 1;
 	ASSERT_STREQ(btf__str_by_offset(btf, p->name_off), "p2", "p2_name");
 	ASSERT_EQ(p->type, 2, "p2_type");
+	ASSERT_STREQ(btf_type_raw_dump(btf, 15),
+		     "[15] FUNC_PROTO '(anon)' ret_type_id=1 vlen=2\n"
+		     "\t'p1' type_id=1\n"
+		     "\t'p2' type_id=2", "raw_dump");
 
 	/* VAR */
 	id = btf__add_var(btf, "var1", BTF_VAR_GLOBAL_ALLOCATED, 1);
@@ -223,6 +261,8 @@ void test_btf_write() {
 	ASSERT_EQ(btf_kind(t), BTF_KIND_VAR, "var_kind");
 	ASSERT_EQ(t->type, 1, "var_type");
 	ASSERT_EQ(btf_var(t)->linkage, BTF_VAR_GLOBAL_ALLOCATED, "var_type");
+	ASSERT_STREQ(btf_type_raw_dump(btf, 16),
+		     "[16] VAR 'var1' type_id=1, linkage=global-alloc", "raw_dump");
 
 	/* DATASECT */
 	id = btf__add_datasec(btf, "datasec1", 12);
@@ -239,6 +279,9 @@ void test_btf_write() {
 	ASSERT_EQ(vi->type, 1, "v1_type");
 	ASSERT_EQ(vi->offset, 4, "v1_off");
 	ASSERT_EQ(vi->size, 8, "v1_sz");
+	ASSERT_STREQ(btf_type_raw_dump(btf, 17),
+		     "[17] DATASEC 'datasec1' size=12 vlen=1\n"
+		     "\ttype_id=1 offset=4 size=8", "raw_dump");
 
 	btf__free(btf);
 }
-- 
2.24.1

