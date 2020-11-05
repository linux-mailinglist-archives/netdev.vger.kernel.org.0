Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 758D52A767A
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 05:34:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731564AbgKEEe0 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 4 Nov 2020 23:34:26 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:12094 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731431AbgKEEeV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 23:34:21 -0500
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0A54W758024854
        for <netdev@vger.kernel.org>; Wed, 4 Nov 2020 20:34:20 -0800
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 34m81m0h7d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 04 Nov 2020 20:34:20 -0800
Received: from intmgw002.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 4 Nov 2020 20:34:19 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id A1B482EC8E04; Wed,  4 Nov 2020 20:34:14 -0800 (PST)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii@kernel.org>, <kernel-team@fb.com>,
        Song Liu <songliubraving@fb.com>
Subject: [PATCH v2 bpf-next 05/11] selftests/bpf: add split BTF basic test
Date:   Wed, 4 Nov 2020 20:33:55 -0800
Message-ID: <20201105043402.2530976-6-andrii@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20201105043402.2530976-1-andrii@kernel.org>
References: <20201105043402.2530976-1-andrii@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-05_01:2020-11-05,2020-11-05 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 adultscore=0 mlxlogscore=816 lowpriorityscore=0 clxscore=1034 mlxscore=0
 bulkscore=0 impostorscore=0 phishscore=0 spamscore=0 suspectscore=25
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011050032
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add selftest validating ability to programmatically generate and then dump
split BTF.

Acked-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
---
 .../selftests/bpf/prog_tests/btf_split.c      | 99 +++++++++++++++++++
 tools/testing/selftests/bpf/test_progs.h      | 11 +++
 2 files changed, 110 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/btf_split.c

diff --git a/tools/testing/selftests/bpf/prog_tests/btf_split.c b/tools/testing/selftests/bpf/prog_tests/btf_split.c
new file mode 100644
index 000000000000..ca7c2a91610a
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/btf_split.c
@@ -0,0 +1,99 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2020 Facebook */
+#include <test_progs.h>
+#include <bpf/btf.h>
+
+static char *dump_buf;
+static size_t dump_buf_sz;
+static FILE *dump_buf_file;
+
+static void btf_dump_printf(void *ctx, const char *fmt, va_list args)
+{
+	vfprintf(ctx, fmt, args);
+}
+
+void test_btf_split() {
+	struct btf_dump_opts opts;
+	struct btf_dump *d = NULL;
+	const struct btf_type *t;
+	struct btf *btf1, *btf2;
+	int str_off, i, err;
+
+	btf1 = btf__new_empty();
+	if (!ASSERT_OK_PTR(btf1, "empty_main_btf"))
+		return;
+
+	btf__set_pointer_size(btf1, 8); /* enforce 64-bit arch */
+
+	btf__add_int(btf1, "int", 4, BTF_INT_SIGNED);	/* [1] int */
+	btf__add_ptr(btf1, 1);				/* [2] ptr to int */
+
+	btf__add_struct(btf1, "s1", 4);			/* [3] struct s1 { */
+	btf__add_field(btf1, "f1", 1, 0, 0);		/*      int f1; */
+							/* } */
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
+	btf__add_field(btf2, "f1", 3, 0, 0);		/*      struct s1 f1;	*/
+	btf__add_field(btf2, "f2", 1, 32, 0);		/*      int f2;		*/
+	btf__add_field(btf2, "f3", 2, 64, 0);		/*      int *f3;	*/
+							/* } */
+
+	t = btf__type_by_id(btf1, 4);
+	ASSERT_NULL(t, "split_type_in_main");
+
+	t = btf__type_by_id(btf2, 4);
+	if (!ASSERT_OK_PTR(t, "split_struct_type"))
+		goto cleanup;
+	ASSERT_EQ(btf_is_struct(t), true, "split_struct_kind");
+	ASSERT_EQ(btf_vlen(t), 3, "split_struct_vlen");
+	ASSERT_STREQ(btf__str_by_offset(btf2, t->name_off), "s2", "split_struct_name");
+
+	/* BTF-to-C dump of split BTF */
+	dump_buf_file = open_memstream(&dump_buf, &dump_buf_sz);
+	if (!ASSERT_OK_PTR(dump_buf_file, "dump_memstream"))
+		return;
+	opts.ctx = dump_buf_file;
+	d = btf_dump__new(btf2, NULL, &opts, btf_dump_printf);
+	if (!ASSERT_OK_PTR(d, "btf_dump__new"))
+		goto cleanup;
+	for (i = 1; i <= btf__get_nr_types(btf2); i++) {
+		err = btf_dump__dump_type(d, i);
+		ASSERT_OK(err, "dump_type_ok");
+	}
+	fflush(dump_buf_file);
+	dump_buf[dump_buf_sz] = 0; /* some libc implementations don't do this */
+	ASSERT_STREQ(dump_buf,
+"struct s1 {\n"
+"	int f1;\n"
+"};\n"
+"\n"
+"struct s2 {\n"
+"	struct s1 f1;\n"
+"	int f2;\n"
+"	int *f3;\n"
+"};\n\n", "c_dump");
+
+cleanup:
+	if (dump_buf_file)
+		fclose(dump_buf_file);
+	free(dump_buf);
+	btf_dump__free(d);
+	btf__free(btf1);
+	btf__free(btf2);
+}
diff --git a/tools/testing/selftests/bpf/test_progs.h b/tools/testing/selftests/bpf/test_progs.h
index 238f5f61189e..d6b14853f3bc 100644
--- a/tools/testing/selftests/bpf/test_progs.h
+++ b/tools/testing/selftests/bpf/test_progs.h
@@ -141,6 +141,17 @@ extern int test__join_cgroup(const char *path);
 	___ok;								\
 })
 
+#define ASSERT_NEQ(actual, expected, name) ({				\
+	static int duration = 0;					\
+	typeof(actual) ___act = (actual);				\
+	typeof(expected) ___exp = (expected);				\
+	bool ___ok = ___act != ___exp;					\
+	CHECK(!___ok, (name),						\
+	      "unexpected %s: actual %lld == expected %lld\n",		\
+	      (name), (long long)(___act), (long long)(___exp));	\
+	___ok;								\
+})
+
 #define ASSERT_STREQ(actual, expected, name) ({				\
 	static int duration = 0;					\
 	const char *___act = actual;					\
-- 
2.24.1

