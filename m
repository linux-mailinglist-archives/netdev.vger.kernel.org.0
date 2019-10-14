Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3DB1FD6C37
	for <lists+netdev@lfdr.de>; Tue, 15 Oct 2019 01:49:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726756AbfJNXtq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Oct 2019 19:49:46 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:15308 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726685AbfJNXtp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Oct 2019 19:49:45 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id x9ENlZDA014323
        for <netdev@vger.kernel.org>; Mon, 14 Oct 2019 16:49:44 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=IKFoOguQkdICZ4aPIcr9FHOecHKHaSDXEv0+h36rDGw=;
 b=G2O7DDguyMEB5nDDK/KJJncTqXQj7LSMkhwxHPBxMTKx5UteWm3E3u1bOWo3gR0sjf6p
 miJcsKCoWczqIu7t4qTsNZyKiFBDhaAaQ9YWBvR7MCC3b1rKN0es9+qJTXP+BM4Elemw
 BnJpu6uaV9RC4gY5qBw9YBNoHmOAzUyh6tA= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by m0001303.ppops.net with ESMTP id 2vkagnhfr9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 14 Oct 2019 16:49:43 -0700
Received: from 2401:db00:12:9028:face:0:29:0 (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::127) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Mon, 14 Oct 2019 16:49:42 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id B06C68618F6; Mon, 14 Oct 2019 16:49:40 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH bpf-next 5/5] selftests/bpf: add field existence CO-RE relocs tests
Date:   Mon, 14 Oct 2019 16:49:28 -0700
Message-ID: <20191014234928.561043-6-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191014234928.561043-1-andriin@fb.com>
References: <20191014234928.561043-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-14_11:2019-10-11,2019-10-14 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015
 impostorscore=0 spamscore=0 mlxscore=0 adultscore=0 priorityscore=1501
 suspectscore=67 malwarescore=0 bulkscore=0 phishscore=0 mlxlogscore=999
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910140199
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a bunch of tests validating CO-RE is handling field existence
relocation. Relaxed CO-RE relocation mode is activated for these new
tests to prevent libbpf from rejecting BPF object for no-match
relocation, even though test BPF program is not going to use that
relocation, if field is missing.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 .../selftests/bpf/prog_tests/core_reloc.c     | 76 +++++++++++++++++-
 .../bpf/progs/btf__core_reloc_existence.c     |  3 +
 ...ore_reloc_existence___err_wrong_arr_kind.c |  3 +
 ...loc_existence___err_wrong_arr_value_type.c |  3 +
 ...ore_reloc_existence___err_wrong_int_kind.c |  3 +
 ..._core_reloc_existence___err_wrong_int_sz.c |  3 +
 ...ore_reloc_existence___err_wrong_int_type.c |  3 +
 ..._reloc_existence___err_wrong_struct_type.c |  3 +
 .../btf__core_reloc_existence___minimal.c     |  3 +
 .../selftests/bpf/progs/core_reloc_types.h    | 56 +++++++++++++
 .../bpf/progs/test_core_reloc_existence.c     | 79 +++++++++++++++++++
 11 files changed, 233 insertions(+), 2 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_existence.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_existence___err_wrong_arr_kind.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_existence___err_wrong_arr_value_type.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_existence___err_wrong_int_kind.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_existence___err_wrong_int_sz.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_existence___err_wrong_int_type.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_existence___err_wrong_struct_type.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_existence___minimal.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_core_reloc_existence.c

diff --git a/tools/testing/selftests/bpf/prog_tests/core_reloc.c b/tools/testing/selftests/bpf/prog_tests/core_reloc.c
index 21a0dff66241..7e2f5b4bf7f3 100644
--- a/tools/testing/selftests/bpf/prog_tests/core_reloc.c
+++ b/tools/testing/selftests/bpf/prog_tests/core_reloc.c
@@ -174,6 +174,21 @@
 	.fails = true,							\
 }
 
+#define EXISTENCE_DATA(struct_name) STRUCT_TO_CHAR_PTR(struct_name) {	\
+	.a = 42,							\
+}
+
+#define EXISTENCE_CASE_COMMON(name)					\
+	.case_name = #name,						\
+	.bpf_obj_file = "test_core_reloc_existence.o",			\
+	.btf_src_file = "btf__core_reloc_" #name ".o",			\
+	.relaxed_core_relocs = true					\
+
+#define EXISTENCE_ERR_CASE(name) {					\
+	EXISTENCE_CASE_COMMON(name),					\
+	.fails = true,							\
+}
+
 struct core_reloc_test_case {
 	const char *case_name;
 	const char *bpf_obj_file;
@@ -183,6 +198,7 @@ struct core_reloc_test_case {
 	const char *output;
 	int output_len;
 	bool fails;
+	bool relaxed_core_relocs;
 };
 
 static struct core_reloc_test_case test_cases[] = {
@@ -283,6 +299,59 @@ static struct core_reloc_test_case test_cases[] = {
 		},
 		.output_len = sizeof(struct core_reloc_misc_output),
 	},
+
+	/* validate field existence checks */
+	{
+		EXISTENCE_CASE_COMMON(existence),
+		.input = STRUCT_TO_CHAR_PTR(core_reloc_existence) {
+			.a = 1,
+			.b = 2,
+			.c = 3,
+			.arr = { 4 },
+			.s = { .x = 5 },
+		},
+		.input_len = sizeof(struct core_reloc_existence),
+		.output = STRUCT_TO_CHAR_PTR(core_reloc_existence_output) {
+			.a_exists = 1,
+			.b_exists = 1,
+			.c_exists = 1,
+			.arr_exists = 1,
+			.s_exists = 1,
+			.a_value = 1,
+			.b_value = 2,
+			.c_value = 3,
+			.arr_value = 4,
+			.s_value = 5,
+		},
+		.output_len = sizeof(struct core_reloc_existence_output),
+	},
+	{
+		EXISTENCE_CASE_COMMON(existence___minimal),
+		.input = STRUCT_TO_CHAR_PTR(core_reloc_existence___minimal) {
+			.a = 42,
+		},
+		.input_len = sizeof(struct core_reloc_existence),
+		.output = STRUCT_TO_CHAR_PTR(core_reloc_existence_output) {
+			.a_exists = 1,
+			.b_exists = 0,
+			.c_exists = 0,
+			.arr_exists = 0,
+			.s_exists = 0,
+			.a_value = 42,
+			.b_value = 0xff000002u,
+			.c_value = 0xff000003u,
+			.arr_value = 0xff000004u,
+			.s_value = 0xff000005u,
+		},
+		.output_len = sizeof(struct core_reloc_existence_output),
+	},
+
+	EXISTENCE_ERR_CASE(existence__err_int_sz),
+	EXISTENCE_ERR_CASE(existence__err_int_type),
+	EXISTENCE_ERR_CASE(existence__err_int_kind),
+	EXISTENCE_ERR_CASE(existence__err_arr_kind),
+	EXISTENCE_ERR_CASE(existence__err_arr_value_type),
+	EXISTENCE_ERR_CASE(existence__err_struct_type),
 };
 
 struct data {
@@ -305,11 +374,14 @@ void test_core_reloc(void)
 
 	for (i = 0; i < ARRAY_SIZE(test_cases); i++) {
 		test_case = &test_cases[i];
-
 		if (!test__start_subtest(test_case->case_name))
 			continue;
 
-		obj = bpf_object__open(test_case->bpf_obj_file);
+		LIBBPF_OPTS(bpf_object_open_opts, opts,
+			.relaxed_core_relocs = test_case->relaxed_core_relocs,
+		);
+
+		obj = bpf_object__open_file(test_case->bpf_obj_file, &opts);
 		if (CHECK(IS_ERR_OR_NULL(obj), "obj_open",
 			  "failed to open '%s': %ld\n",
 			  test_case->bpf_obj_file, PTR_ERR(obj)))
diff --git a/tools/testing/selftests/bpf/progs/btf__core_reloc_existence.c b/tools/testing/selftests/bpf/progs/btf__core_reloc_existence.c
new file mode 100644
index 000000000000..0b62315ad46c
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/btf__core_reloc_existence.c
@@ -0,0 +1,3 @@
+#include "core_reloc_types.h"
+
+void f(struct core_reloc_existence x) {}
diff --git a/tools/testing/selftests/bpf/progs/btf__core_reloc_existence___err_wrong_arr_kind.c b/tools/testing/selftests/bpf/progs/btf__core_reloc_existence___err_wrong_arr_kind.c
new file mode 100644
index 000000000000..dd0ffa518f36
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/btf__core_reloc_existence___err_wrong_arr_kind.c
@@ -0,0 +1,3 @@
+#include "core_reloc_types.h"
+
+void f(struct core_reloc_existence___err_wrong_arr_kind x) {}
diff --git a/tools/testing/selftests/bpf/progs/btf__core_reloc_existence___err_wrong_arr_value_type.c b/tools/testing/selftests/bpf/progs/btf__core_reloc_existence___err_wrong_arr_value_type.c
new file mode 100644
index 000000000000..bc83372088ad
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/btf__core_reloc_existence___err_wrong_arr_value_type.c
@@ -0,0 +1,3 @@
+#include "core_reloc_types.h"
+
+void f(struct core_reloc_existence___err_wrong_arr_value_type x) {}
diff --git a/tools/testing/selftests/bpf/progs/btf__core_reloc_existence___err_wrong_int_kind.c b/tools/testing/selftests/bpf/progs/btf__core_reloc_existence___err_wrong_int_kind.c
new file mode 100644
index 000000000000..917bec41be08
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/btf__core_reloc_existence___err_wrong_int_kind.c
@@ -0,0 +1,3 @@
+#include "core_reloc_types.h"
+
+void f(struct core_reloc_existence___err_wrong_int_kind x) {}
diff --git a/tools/testing/selftests/bpf/progs/btf__core_reloc_existence___err_wrong_int_sz.c b/tools/testing/selftests/bpf/progs/btf__core_reloc_existence___err_wrong_int_sz.c
new file mode 100644
index 000000000000..6ec7e6ec1c91
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/btf__core_reloc_existence___err_wrong_int_sz.c
@@ -0,0 +1,3 @@
+#include "core_reloc_types.h"
+
+void f(struct core_reloc_existence___err_wrong_int_sz x) {}
diff --git a/tools/testing/selftests/bpf/progs/btf__core_reloc_existence___err_wrong_int_type.c b/tools/testing/selftests/bpf/progs/btf__core_reloc_existence___err_wrong_int_type.c
new file mode 100644
index 000000000000..7bbcacf2b0d1
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/btf__core_reloc_existence___err_wrong_int_type.c
@@ -0,0 +1,3 @@
+#include "core_reloc_types.h"
+
+void f(struct core_reloc_existence___err_wrong_int_type x) {}
diff --git a/tools/testing/selftests/bpf/progs/btf__core_reloc_existence___err_wrong_struct_type.c b/tools/testing/selftests/bpf/progs/btf__core_reloc_existence___err_wrong_struct_type.c
new file mode 100644
index 000000000000..f384dd38ec70
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/btf__core_reloc_existence___err_wrong_struct_type.c
@@ -0,0 +1,3 @@
+#include "core_reloc_types.h"
+
+void f(struct core_reloc_existence___err_wrong_struct_type x) {}
diff --git a/tools/testing/selftests/bpf/progs/btf__core_reloc_existence___minimal.c b/tools/testing/selftests/bpf/progs/btf__core_reloc_existence___minimal.c
new file mode 100644
index 000000000000..aec2dec20e90
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/btf__core_reloc_existence___minimal.c
@@ -0,0 +1,3 @@
+#include "core_reloc_types.h"
+
+void f(struct core_reloc_existence___minimal x) {}
diff --git a/tools/testing/selftests/bpf/progs/core_reloc_types.h b/tools/testing/selftests/bpf/progs/core_reloc_types.h
index 9a6bdeb4894c..ad763ec0ba8f 100644
--- a/tools/testing/selftests/bpf/progs/core_reloc_types.h
+++ b/tools/testing/selftests/bpf/progs/core_reloc_types.h
@@ -674,3 +674,59 @@ struct core_reloc_misc_extensible {
 	int c;
 	int d;
 };
+
+/*
+ * EXISTENCE
+ */
+struct core_reloc_existence_output {
+	int a_exists;
+	int a_value;
+	int b_exists;
+	int b_value;
+	int c_exists;
+	int c_value;
+	int arr_exists;
+	int arr_value;
+	int s_exists;
+	int s_value;
+};
+
+struct core_reloc_existence {
+	int a;
+	struct {
+		int b;
+	};
+	int c;
+	int arr[1];
+	struct {
+		int x;
+	} s;
+};
+
+struct core_reloc_existence___minimal {
+	int a;
+};
+
+struct core_reloc_existence___err_wrong_int_sz {
+	short a;
+};
+
+struct core_reloc_existence___err_wrong_int_type {
+	int b[1];
+};
+
+struct core_reloc_existence___err_wrong_int_kind {
+	struct{ int x; } c;
+};
+
+struct core_reloc_existence___err_wrong_arr_kind {
+	int arr;
+};
+
+struct core_reloc_existence___err_wrong_arr_value_type {
+	short arr[1];
+};
+
+struct core_reloc_existence___err_wrong_struct_type {
+	int s;
+};
diff --git a/tools/testing/selftests/bpf/progs/test_core_reloc_existence.c b/tools/testing/selftests/bpf/progs/test_core_reloc_existence.c
new file mode 100644
index 000000000000..fdf0fdc361e0
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_core_reloc_existence.c
@@ -0,0 +1,79 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright (c) 2019 Facebook
+
+#include <linux/bpf.h>
+#include <stdint.h>
+#include "bpf_helpers.h"
+#include "bpf_core_read.h"
+
+char _license[] SEC("license") = "GPL";
+
+static volatile struct data {
+	char in[256];
+	char out[256];
+} data;
+
+struct core_reloc_existence_output {
+	int a_exists;
+	int a_value;
+	int b_exists;
+	int b_value;
+	int c_exists;
+	int c_value;
+	int arr_exists;
+	int arr_value;
+	int s_exists;
+	int s_value;
+};
+
+struct core_reloc_existence {
+	struct {
+		int x;
+	} s;
+	int arr[1];
+	int a;
+	struct {
+		int b;
+	};
+	int c;
+};
+
+SEC("raw_tracepoint/sys_enter")
+int test_core_existence(void *ctx)
+{
+	struct core_reloc_existence *in = (void *)&data.in;
+	struct core_reloc_existence_output *out = (void *)&data.out;
+
+	out->a_exists = __builtin_preserve_field_info(in->a, BPF_FI_EXISTS);
+	if (__builtin_preserve_field_info(in->a, BPF_FI_EXISTS))
+		out->a_value = BPF_CORE_READ(in, a);
+	else
+		out->a_value = 0xff000001u;
+
+	out->b_exists = __builtin_preserve_field_info(in->b, BPF_FI_EXISTS);
+	if (__builtin_preserve_field_info(in->b, BPF_FI_EXISTS))
+		out->b_value = BPF_CORE_READ(in, b);
+	else
+		out->b_value = 0xff000002u;
+
+	out->c_exists = __builtin_preserve_field_info(in->c, BPF_FI_EXISTS);
+	if (__builtin_preserve_field_info(in->c, BPF_FI_EXISTS))
+		out->c_value = BPF_CORE_READ(in, c);
+	else
+		out->c_value = 0xff000003u;
+
+	out->arr_exists = __builtin_preserve_field_info(in->arr, BPF_FI_EXISTS);
+	if (__builtin_preserve_field_info(in->arr, BPF_FI_EXISTS))
+		out->arr_value = BPF_CORE_READ(in, arr[0]);
+	else
+		out->arr_value = 0xff000004u;
+
+	out->s_exists = __builtin_preserve_field_info(in->s, BPF_FI_EXISTS);
+	if (__builtin_preserve_field_info(in->s, BPF_FI_EXISTS))
+		out->s_value = BPF_CORE_READ(in, s.x);
+	else
+		out->s_value = 0xff000005u;
+
+	return 0;
+}
+
-- 
2.17.1

