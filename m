Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81DF12A7685
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 05:34:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731925AbgKEEem convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 4 Nov 2020 23:34:42 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:29744 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731519AbgKEEem (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 23:34:42 -0500
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0A54YdeH031547
        for <netdev@vger.kernel.org>; Wed, 4 Nov 2020 20:34:40 -0800
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 34m5r5h4ur-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 04 Nov 2020 20:34:39 -0800
Received: from intmgw003.03.ash8.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:11d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 4 Nov 2020 20:34:33 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 97D652EC8E04; Wed,  4 Nov 2020 20:34:25 -0800 (PST)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii@kernel.org>, <kernel-team@fb.com>,
        Song Liu <songliubraving@fb.com>
Subject: [PATCH v2 bpf-next 10/11] selftests/bpf: add split BTF dedup selftests
Date:   Wed, 4 Nov 2020 20:34:00 -0800
Message-ID: <20201105043402.2530976-11-andrii@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20201105043402.2530976-1-andrii@kernel.org>
References: <20201105043402.2530976-1-andrii@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-05_01:2020-11-05,2020-11-05 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 adultscore=0
 malwarescore=0 phishscore=0 bulkscore=0 lowpriorityscore=0
 priorityscore=1501 mlxlogscore=999 suspectscore=25 clxscore=1015
 spamscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2011050033
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add selftests validating BTF deduplication for split BTF case. Add a helper
macro that allows to validate entire BTF with raw BTF dump, not just
type-by-type. This saves tons of code and complexity.

Acked-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
---
 tools/testing/selftests/bpf/btf_helpers.c     |  59 ++++
 tools/testing/selftests/bpf/btf_helpers.h     |   7 +
 .../bpf/prog_tests/btf_dedup_split.c          | 325 ++++++++++++++++++
 3 files changed, 391 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/btf_dedup_split.c

diff --git a/tools/testing/selftests/bpf/btf_helpers.c b/tools/testing/selftests/bpf/btf_helpers.c
index abc3f6c04cfc..48f90490f922 100644
--- a/tools/testing/selftests/bpf/btf_helpers.c
+++ b/tools/testing/selftests/bpf/btf_helpers.c
@@ -3,6 +3,8 @@
 #include <stdio.h>
 #include <errno.h>
 #include <bpf/btf.h>
+#include <bpf/libbpf.h>
+#include "test_progs.h"
 
 static const char * const btf_kind_str_mapping[] = {
 	[BTF_KIND_UNKN]		= "UNKNOWN",
@@ -198,3 +200,60 @@ const char *btf_type_raw_dump(const struct btf *btf, int type_id)
 
 	return buf;
 }
+
+int btf_validate_raw(struct btf *btf, int nr_types, const char *exp_types[])
+{
+	int i;
+	bool ok = true;
+
+	ASSERT_EQ(btf__get_nr_types(btf), nr_types, "btf_nr_types");
+
+	for (i = 1; i <= nr_types; i++) {
+		if (!ASSERT_STREQ(btf_type_raw_dump(btf, i), exp_types[i - 1], "raw_dump"))
+			ok = false;
+	}
+
+	return ok;
+}
+
+static void btf_dump_printf(void *ctx, const char *fmt, va_list args)
+{
+	vfprintf(ctx, fmt, args);
+}
+
+/* Print BTF-to-C dump into a local buffer and return string pointer back.
+ * Buffer *will* be overwritten by subsequent btf_type_raw_dump() calls
+ */
+const char *btf_type_c_dump(const struct btf *btf)
+{
+	static char buf[16 * 1024];
+	FILE *buf_file;
+	struct btf_dump *d = NULL;
+	struct btf_dump_opts opts = {};
+	int err, i;
+
+	buf_file = fmemopen(buf, sizeof(buf) - 1, "w");
+	if (!buf_file) {
+		fprintf(stderr, "Failed to open memstream: %d\n", errno);
+		return NULL;
+	}
+
+	opts.ctx = buf_file;
+	d = btf_dump__new(btf, NULL, &opts, btf_dump_printf);
+	if (libbpf_get_error(d)) {
+		fprintf(stderr, "Failed to create btf_dump instance: %ld\n", libbpf_get_error(d));
+		return NULL;
+	}
+
+	for (i = 1; i <= btf__get_nr_types(btf); i++) {
+		err = btf_dump__dump_type(d, i);
+		if (err) {
+			fprintf(stderr, "Failed to dump type [%d]: %d\n", i, err);
+			return NULL;
+		}
+	}
+
+	fflush(buf_file);
+	fclose(buf_file);
+	return buf;
+}
diff --git a/tools/testing/selftests/bpf/btf_helpers.h b/tools/testing/selftests/bpf/btf_helpers.h
index 2c9ce1b61dc9..295c0137d9bd 100644
--- a/tools/testing/selftests/bpf/btf_helpers.h
+++ b/tools/testing/selftests/bpf/btf_helpers.h
@@ -8,5 +8,12 @@
 
 int fprintf_btf_type_raw(FILE *out, const struct btf *btf, __u32 id);
 const char *btf_type_raw_dump(const struct btf *btf, int type_id);
+int btf_validate_raw(struct btf *btf, int nr_types, const char *exp_types[]);
 
+#define VALIDATE_RAW_BTF(btf, raw_types...)				\
+	btf_validate_raw(btf,						\
+			 sizeof((const char *[]){raw_types})/sizeof(void *),\
+			 (const char *[]){raw_types})
+
+const char *btf_type_c_dump(const struct btf *btf);
 #endif
diff --git a/tools/testing/selftests/bpf/prog_tests/btf_dedup_split.c b/tools/testing/selftests/bpf/prog_tests/btf_dedup_split.c
new file mode 100644
index 000000000000..64554fd33547
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/btf_dedup_split.c
@@ -0,0 +1,325 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2020 Facebook */
+#include <test_progs.h>
+#include <bpf/btf.h>
+#include "btf_helpers.h"
+
+static void test_split_simple() {
+	const struct btf_type *t;
+	struct btf *btf1, *btf2;
+	int str_off, err;
+
+	btf1 = btf__new_empty();
+	if (!ASSERT_OK_PTR(btf1, "empty_main_btf"))
+		return;
+
+	btf__set_pointer_size(btf1, 8); /* enforce 64-bit arch */
+
+	btf__add_int(btf1, "int", 4, BTF_INT_SIGNED);	/* [1] int */
+	btf__add_ptr(btf1, 1);				/* [2] ptr to int */
+	btf__add_struct(btf1, "s1", 4);			/* [3] struct s1 { */
+	btf__add_field(btf1, "f1", 1, 0, 0);		/*      int f1; */
+							/* } */
+
+	VALIDATE_RAW_BTF(
+		btf1,
+		"[1] INT 'int' size=4 bits_offset=0 nr_bits=32 encoding=SIGNED",
+		"[2] PTR '(anon)' type_id=1",
+		"[3] STRUCT 's1' size=4 vlen=1\n"
+		"\t'f1' type_id=1 bits_offset=0");
+
+	ASSERT_STREQ(btf_type_c_dump(btf1), "\
+struct s1 {\n\
+	int f1;\n\
+};\n\n", "c_dump");
+
+	btf2 = btf__new_empty_split(btf1);
+	if (!ASSERT_OK_PTR(btf2, "empty_split_btf"))
+		goto cleanup;
+
+	/* pointer size should be "inherited" from main BTF */
+	ASSERT_EQ(btf__pointer_size(btf2), 8, "inherit_ptr_sz");
+
+	str_off = btf__find_str(btf2, "int");
+	ASSERT_NEQ(str_off, -ENOENT, "str_int_missing");
+
+	t = btf__type_by_id(btf2, 1);
+	if (!ASSERT_OK_PTR(t, "int_type"))
+		goto cleanup;
+	ASSERT_EQ(btf_is_int(t), true, "int_kind");
+	ASSERT_STREQ(btf__str_by_offset(btf2, t->name_off), "int", "int_name");
+
+	btf__add_struct(btf2, "s2", 16);		/* [4] struct s2 {	*/
+	btf__add_field(btf2, "f1", 6, 0, 0);		/*      struct s1 f1;	*/
+	btf__add_field(btf2, "f2", 5, 32, 0);		/*      int f2;		*/
+	btf__add_field(btf2, "f3", 2, 64, 0);		/*      int *f3;	*/
+							/* } */
+
+	/* duplicated int */
+	btf__add_int(btf2, "int", 4, BTF_INT_SIGNED);	/* [5] int */
+
+	/* duplicated struct s1 */
+	btf__add_struct(btf2, "s1", 4);			/* [6] struct s1 { */
+	btf__add_field(btf2, "f1", 5, 0, 0);		/*      int f1; */
+							/* } */
+
+	VALIDATE_RAW_BTF(
+		btf2,
+		"[1] INT 'int' size=4 bits_offset=0 nr_bits=32 encoding=SIGNED",
+		"[2] PTR '(anon)' type_id=1",
+		"[3] STRUCT 's1' size=4 vlen=1\n"
+		"\t'f1' type_id=1 bits_offset=0",
+		"[4] STRUCT 's2' size=16 vlen=3\n"
+		"\t'f1' type_id=6 bits_offset=0\n"
+		"\t'f2' type_id=5 bits_offset=32\n"
+		"\t'f3' type_id=2 bits_offset=64",
+		"[5] INT 'int' size=4 bits_offset=0 nr_bits=32 encoding=SIGNED",
+		"[6] STRUCT 's1' size=4 vlen=1\n"
+		"\t'f1' type_id=5 bits_offset=0");
+
+	ASSERT_STREQ(btf_type_c_dump(btf2), "\
+struct s1 {\n\
+	int f1;\n\
+};\n\
+\n\
+struct s1___2 {\n\
+	int f1;\n\
+};\n\
+\n\
+struct s2 {\n\
+	struct s1___2 f1;\n\
+	int f2;\n\
+	int *f3;\n\
+};\n\n", "c_dump");
+
+	err = btf__dedup(btf2, NULL, NULL);
+	if (!ASSERT_OK(err, "btf_dedup"))
+		goto cleanup;
+
+	VALIDATE_RAW_BTF(
+		btf2,
+		"[1] INT 'int' size=4 bits_offset=0 nr_bits=32 encoding=SIGNED",
+		"[2] PTR '(anon)' type_id=1",
+		"[3] STRUCT 's1' size=4 vlen=1\n"
+		"\t'f1' type_id=1 bits_offset=0",
+		"[4] STRUCT 's2' size=16 vlen=3\n"
+		"\t'f1' type_id=3 bits_offset=0\n"
+		"\t'f2' type_id=1 bits_offset=32\n"
+		"\t'f3' type_id=2 bits_offset=64");
+
+	ASSERT_STREQ(btf_type_c_dump(btf2), "\
+struct s1 {\n\
+	int f1;\n\
+};\n\
+\n\
+struct s2 {\n\
+	struct s1 f1;\n\
+	int f2;\n\
+	int *f3;\n\
+};\n\n", "c_dump");
+
+cleanup:
+	btf__free(btf2);
+	btf__free(btf1);
+}
+
+static void test_split_fwd_resolve() {
+	struct btf *btf1, *btf2;
+	int err;
+
+	btf1 = btf__new_empty();
+	if (!ASSERT_OK_PTR(btf1, "empty_main_btf"))
+		return;
+
+	btf__set_pointer_size(btf1, 8); /* enforce 64-bit arch */
+
+	btf__add_int(btf1, "int", 4, BTF_INT_SIGNED);	/* [1] int */
+	btf__add_ptr(btf1, 4);				/* [2] ptr to struct s1 */
+	btf__add_ptr(btf1, 5);				/* [3] ptr to struct s2 */
+	btf__add_struct(btf1, "s1", 16);		/* [4] struct s1 { */
+	btf__add_field(btf1, "f1", 2, 0, 0);		/*      struct s1 *f1; */
+	btf__add_field(btf1, "f2", 3, 64, 0);		/*      struct s2 *f2; */
+							/* } */
+	btf__add_struct(btf1, "s2", 4);			/* [5] struct s2 { */
+	btf__add_field(btf1, "f1", 1, 0, 0);		/*      int f1; */
+							/* } */
+
+	VALIDATE_RAW_BTF(
+		btf1,
+		"[1] INT 'int' size=4 bits_offset=0 nr_bits=32 encoding=SIGNED",
+		"[2] PTR '(anon)' type_id=4",
+		"[3] PTR '(anon)' type_id=5",
+		"[4] STRUCT 's1' size=16 vlen=2\n"
+		"\t'f1' type_id=2 bits_offset=0\n"
+		"\t'f2' type_id=3 bits_offset=64",
+		"[5] STRUCT 's2' size=4 vlen=1\n"
+		"\t'f1' type_id=1 bits_offset=0");
+
+	btf2 = btf__new_empty_split(btf1);
+	if (!ASSERT_OK_PTR(btf2, "empty_split_btf"))
+		goto cleanup;
+
+	btf__add_int(btf2, "int", 4, BTF_INT_SIGNED);	/* [6] int */
+	btf__add_ptr(btf2, 10);				/* [7] ptr to struct s1 */
+	btf__add_fwd(btf2, "s2", BTF_FWD_STRUCT);	/* [8] fwd for struct s2 */
+	btf__add_ptr(btf2, 8);				/* [9] ptr to fwd struct s2 */
+	btf__add_struct(btf2, "s1", 16);		/* [10] struct s1 { */
+	btf__add_field(btf2, "f1", 7, 0, 0);		/*      struct s1 *f1; */
+	btf__add_field(btf2, "f2", 9, 64, 0);		/*      struct s2 *f2; */
+							/* } */
+
+	VALIDATE_RAW_BTF(
+		btf2,
+		"[1] INT 'int' size=4 bits_offset=0 nr_bits=32 encoding=SIGNED",
+		"[2] PTR '(anon)' type_id=4",
+		"[3] PTR '(anon)' type_id=5",
+		"[4] STRUCT 's1' size=16 vlen=2\n"
+		"\t'f1' type_id=2 bits_offset=0\n"
+		"\t'f2' type_id=3 bits_offset=64",
+		"[5] STRUCT 's2' size=4 vlen=1\n"
+		"\t'f1' type_id=1 bits_offset=0",
+		"[6] INT 'int' size=4 bits_offset=0 nr_bits=32 encoding=SIGNED",
+		"[7] PTR '(anon)' type_id=10",
+		"[8] FWD 's2' fwd_kind=struct",
+		"[9] PTR '(anon)' type_id=8",
+		"[10] STRUCT 's1' size=16 vlen=2\n"
+		"\t'f1' type_id=7 bits_offset=0\n"
+		"\t'f2' type_id=9 bits_offset=64");
+
+	err = btf__dedup(btf2, NULL, NULL);
+	if (!ASSERT_OK(err, "btf_dedup"))
+		goto cleanup;
+
+	VALIDATE_RAW_BTF(
+		btf2,
+		"[1] INT 'int' size=4 bits_offset=0 nr_bits=32 encoding=SIGNED",
+		"[2] PTR '(anon)' type_id=4",
+		"[3] PTR '(anon)' type_id=5",
+		"[4] STRUCT 's1' size=16 vlen=2\n"
+		"\t'f1' type_id=2 bits_offset=0\n"
+		"\t'f2' type_id=3 bits_offset=64",
+		"[5] STRUCT 's2' size=4 vlen=1\n"
+		"\t'f1' type_id=1 bits_offset=0");
+
+cleanup:
+	btf__free(btf2);
+	btf__free(btf1);
+}
+
+static void test_split_struct_duped() {
+	struct btf *btf1, *btf2;
+	int err;
+
+	btf1 = btf__new_empty();
+	if (!ASSERT_OK_PTR(btf1, "empty_main_btf"))
+		return;
+
+	btf__set_pointer_size(btf1, 8); /* enforce 64-bit arch */
+
+	btf__add_int(btf1, "int", 4, BTF_INT_SIGNED);	/* [1] int */
+	btf__add_ptr(btf1, 5);				/* [2] ptr to struct s1 */
+	btf__add_fwd(btf1, "s2", BTF_FWD_STRUCT);	/* [3] fwd for struct s2 */
+	btf__add_ptr(btf1, 3);				/* [4] ptr to fwd struct s2 */
+	btf__add_struct(btf1, "s1", 16);		/* [5] struct s1 { */
+	btf__add_field(btf1, "f1", 2, 0, 0);		/*      struct s1 *f1; */
+	btf__add_field(btf1, "f2", 4, 64, 0);		/*      struct s2 *f2; */
+							/* } */
+
+	VALIDATE_RAW_BTF(
+		btf1,
+		"[1] INT 'int' size=4 bits_offset=0 nr_bits=32 encoding=SIGNED",
+		"[2] PTR '(anon)' type_id=5",
+		"[3] FWD 's2' fwd_kind=struct",
+		"[4] PTR '(anon)' type_id=3",
+		"[5] STRUCT 's1' size=16 vlen=2\n"
+		"\t'f1' type_id=2 bits_offset=0\n"
+		"\t'f2' type_id=4 bits_offset=64");
+
+	btf2 = btf__new_empty_split(btf1);
+	if (!ASSERT_OK_PTR(btf2, "empty_split_btf"))
+		goto cleanup;
+
+	btf__add_int(btf2, "int", 4, BTF_INT_SIGNED);	/* [6] int */
+	btf__add_ptr(btf2, 10);				/* [7] ptr to struct s1 */
+	btf__add_fwd(btf2, "s2", BTF_FWD_STRUCT);	/* [8] fwd for struct s2 */
+	btf__add_ptr(btf2, 11);				/* [9] ptr to struct s2 */
+	btf__add_struct(btf2, "s1", 16);		/* [10] struct s1 { */
+	btf__add_field(btf2, "f1", 7, 0, 0);		/*      struct s1 *f1; */
+	btf__add_field(btf2, "f2", 9, 64, 0);		/*      struct s2 *f2; */
+							/* } */
+	btf__add_struct(btf2, "s2", 40);		/* [11] struct s2 {	*/
+	btf__add_field(btf2, "f1", 7, 0, 0);		/*      struct s1 *f1;	*/
+	btf__add_field(btf2, "f2", 9, 64, 0);		/*      struct s2 *f2;	*/
+	btf__add_field(btf2, "f3", 6, 128, 0);		/*      int f3;		*/
+	btf__add_field(btf2, "f4", 10, 192, 0);		/*      struct s1 f4;	*/
+							/* } */
+	btf__add_ptr(btf2, 8);				/* [12] ptr to fwd struct s2 */
+	btf__add_struct(btf2, "s3", 8);			/* [13] struct s3 { */
+	btf__add_field(btf2, "f1", 12, 0, 0);		/*      struct s2 *f1; (fwd) */
+							/* } */
+
+	VALIDATE_RAW_BTF(
+		btf2,
+		"[1] INT 'int' size=4 bits_offset=0 nr_bits=32 encoding=SIGNED",
+		"[2] PTR '(anon)' type_id=5",
+		"[3] FWD 's2' fwd_kind=struct",
+		"[4] PTR '(anon)' type_id=3",
+		"[5] STRUCT 's1' size=16 vlen=2\n"
+		"\t'f1' type_id=2 bits_offset=0\n"
+		"\t'f2' type_id=4 bits_offset=64",
+		"[6] INT 'int' size=4 bits_offset=0 nr_bits=32 encoding=SIGNED",
+		"[7] PTR '(anon)' type_id=10",
+		"[8] FWD 's2' fwd_kind=struct",
+		"[9] PTR '(anon)' type_id=11",
+		"[10] STRUCT 's1' size=16 vlen=2\n"
+		"\t'f1' type_id=7 bits_offset=0\n"
+		"\t'f2' type_id=9 bits_offset=64",
+		"[11] STRUCT 's2' size=40 vlen=4\n"
+		"\t'f1' type_id=7 bits_offset=0\n"
+		"\t'f2' type_id=9 bits_offset=64\n"
+		"\t'f3' type_id=6 bits_offset=128\n"
+		"\t'f4' type_id=10 bits_offset=192",
+		"[12] PTR '(anon)' type_id=8",
+		"[13] STRUCT 's3' size=8 vlen=1\n"
+		"\t'f1' type_id=12 bits_offset=0");
+
+	err = btf__dedup(btf2, NULL, NULL);
+	if (!ASSERT_OK(err, "btf_dedup"))
+		goto cleanup;
+
+	VALIDATE_RAW_BTF(
+		btf2,
+		"[1] INT 'int' size=4 bits_offset=0 nr_bits=32 encoding=SIGNED",
+		"[2] PTR '(anon)' type_id=5",
+		"[3] FWD 's2' fwd_kind=struct",
+		"[4] PTR '(anon)' type_id=3",
+		"[5] STRUCT 's1' size=16 vlen=2\n"
+		"\t'f1' type_id=2 bits_offset=0\n"
+		"\t'f2' type_id=4 bits_offset=64",
+		"[6] PTR '(anon)' type_id=8",
+		"[7] PTR '(anon)' type_id=9",
+		"[8] STRUCT 's1' size=16 vlen=2\n"
+		"\t'f1' type_id=6 bits_offset=0\n"
+		"\t'f2' type_id=7 bits_offset=64",
+		"[9] STRUCT 's2' size=40 vlen=4\n"
+		"\t'f1' type_id=6 bits_offset=0\n"
+		"\t'f2' type_id=7 bits_offset=64\n"
+		"\t'f3' type_id=1 bits_offset=128\n"
+		"\t'f4' type_id=8 bits_offset=192",
+		"[10] STRUCT 's3' size=8 vlen=1\n"
+		"\t'f1' type_id=7 bits_offset=0");
+
+cleanup:
+	btf__free(btf2);
+	btf__free(btf1);
+}
+
+void test_btf_dedup_split()
+{
+	if (test__start_subtest("split_simple"))
+		test_split_simple();
+	if (test__start_subtest("split_struct_duped"))
+		test_split_struct_duped();
+	if (test__start_subtest("split_fwd_resolve"))
+		test_split_fwd_resolve();
+}
-- 
2.24.1

