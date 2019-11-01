Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D2C1ECB60
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 23:28:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727718AbfKAW22 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 18:28:28 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:7750 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727499AbfKAW21 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Nov 2019 18:28:27 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xA1MQXVT029612
        for <netdev@vger.kernel.org>; Fri, 1 Nov 2019 15:28:26 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=oAHtq1H1dq9ZmP9y29A7ivZ0MA9OmlFeaq9c4Wk3y6k=;
 b=rYmHM0aYCGlSyXMR8ZSGs1eFwHRaPP/jHKtMaYad7M2tGabNhA4EDfnkFRRjNH27SIBp
 qdA/mvM3CLa4HOweCgaMoQyteELmbGp8d2GdTeUr7VEIJKL5eNvixao41o4mhhDWYWoI
 3SPDa044sWvhKOQYxzhSZa/Ze4xNnMJCdZY= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2w0tsk0uvg-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 01 Nov 2019 15:28:26 -0700
Received: from 2401:db00:2050:5076:face:0:9:0 (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::127) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Fri, 1 Nov 2019 15:28:23 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 721932EC1B43; Fri,  1 Nov 2019 15:28:22 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>, <yhs@fb.com>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v2 bpf-next 4/5] selftest/bpf: add relocatable bitfield reading tests
Date:   Fri, 1 Nov 2019 15:28:09 -0700
Message-ID: <20191101222810.1246166-5-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191101222810.1246166-1-andriin@fb.com>
References: <20191101222810.1246166-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-11-01_08:2019-11-01,2019-11-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0
 suspectscore=67 malwarescore=0 clxscore=1015 mlxscore=0 lowpriorityscore=0
 priorityscore=1501 bulkscore=0 adultscore=0 spamscore=0 impostorscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1911010207
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a bunch of selftests verifying correctness of relocatable bitfield reading
support in libbpf. Both bpf_probe_read()-based and direct read-based bitfield
macros are tested. core_reloc.c "test_harness" is extended to support raw
tracepoint and new typed raw tracepoints as test BPF program types.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 .../selftests/bpf/prog_tests/core_reloc.c     | 84 ++++++++++++++++++-
 .../bpf/progs/btf__core_reloc_bitfields.c     |  3 +
 ...tf__core_reloc_bitfields___bit_sz_change.c |  3 +
 ...__core_reloc_bitfields___bitfield_vs_int.c |  3 +
 ...e_reloc_bitfields___err_too_big_bitfield.c |  3 +
 ...__core_reloc_bitfields___just_big_enough.c |  3 +
 .../selftests/bpf/progs/core_reloc_types.h    | 72 ++++++++++++++++
 .../progs/test_core_reloc_bitfields_direct.c  | 63 ++++++++++++++
 .../progs/test_core_reloc_bitfields_probed.c  | 62 ++++++++++++++
 9 files changed, 294 insertions(+), 2 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_bitfields.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_bitfields___bit_sz_change.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_bitfields___bitfield_vs_int.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_bitfields___err_too_big_bitfield.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_bitfields___just_big_enough.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_core_reloc_bitfields_direct.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_core_reloc_bitfields_probed.c

diff --git a/tools/testing/selftests/bpf/prog_tests/core_reloc.c b/tools/testing/selftests/bpf/prog_tests/core_reloc.c
index 09dfa75fe948..340aa12cea06 100644
--- a/tools/testing/selftests/bpf/prog_tests/core_reloc.c
+++ b/tools/testing/selftests/bpf/prog_tests/core_reloc.c
@@ -189,6 +189,42 @@
 	.fails = true,							\
 }
 
+#define BITFIELDS_CASE_COMMON(objfile, test_name_prefix,  name)		\
+	.case_name = test_name_prefix#name,				\
+	.bpf_obj_file = objfile,					\
+	.btf_src_file = "btf__core_reloc_" #name ".o"
+
+#define BITFIELDS_CASE(name, ...) {					\
+	BITFIELDS_CASE_COMMON("test_core_reloc_bitfields_probed.o",	\
+			      "direct:", name),				\
+	.input = STRUCT_TO_CHAR_PTR(core_reloc_##name) __VA_ARGS__,	\
+	.input_len = sizeof(struct core_reloc_##name),			\
+	.output = STRUCT_TO_CHAR_PTR(core_reloc_bitfields_output)	\
+		__VA_ARGS__,						\
+	.output_len = sizeof(struct core_reloc_bitfields_output),	\
+}, {									\
+	BITFIELDS_CASE_COMMON("test_core_reloc_bitfields_direct.o",	\
+			      "probed:", name),				\
+	.input = STRUCT_TO_CHAR_PTR(core_reloc_##name) __VA_ARGS__,	\
+	.input_len = sizeof(struct core_reloc_##name),			\
+	.output = STRUCT_TO_CHAR_PTR(core_reloc_bitfields_output)	\
+		__VA_ARGS__,						\
+	.output_len = sizeof(struct core_reloc_bitfields_output),	\
+	.direct_raw_tp = true,						\
+}
+
+
+#define BITFIELDS_ERR_CASE(name) {					\
+	BITFIELDS_CASE_COMMON("test_core_reloc_bitfields_probed.o",	\
+			      "probed:", name),				\
+	.fails = true,							\
+}, {									\
+	BITFIELDS_CASE_COMMON("test_core_reloc_bitfields_direct.o",	\
+			      "direct:", name),				\
+	.direct_raw_tp = true,						\
+	.fails = true,							\
+}
+
 struct core_reloc_test_case {
 	const char *case_name;
 	const char *bpf_obj_file;
@@ -199,6 +235,7 @@ struct core_reloc_test_case {
 	int output_len;
 	bool fails;
 	bool relaxed_core_relocs;
+	bool direct_raw_tp;
 };
 
 static struct core_reloc_test_case test_cases[] = {
@@ -352,6 +389,40 @@ static struct core_reloc_test_case test_cases[] = {
 	EXISTENCE_ERR_CASE(existence__err_arr_kind),
 	EXISTENCE_ERR_CASE(existence__err_arr_value_type),
 	EXISTENCE_ERR_CASE(existence__err_struct_type),
+
+	/* bitfield relocation checks */
+	BITFIELDS_CASE(bitfields, {
+		.ub1 = 1,
+		.ub2 = 2,
+		.ub7 = 96,
+		.sb4 = -7,
+		.sb20 = -0x76543,
+		.u32 = 0x80000000,
+		.s32 = -0x76543210,
+	}),
+	BITFIELDS_CASE(bitfields___bit_sz_change, {
+		.ub1 = 6,
+		.ub2 = 0xABCDE,
+		.ub7 = 1,
+		.sb4 = -1,
+		.sb20 = -0x17654321,
+		.u32 = 0xBEEF,
+		.s32 = -0x3FEDCBA987654321,
+	}),
+	BITFIELDS_CASE(bitfields___bitfield_vs_int, {
+		.ub1 = 0xFEDCBA9876543210,
+		.ub2 = 0xA6,
+		.ub7 = -0x7EDCBA987654321,
+		.sb4 = -0x6123456789ABCDE,
+		.sb20 = 0xD00D,
+		.u32 = -0x76543,
+		.s32 = 0x0ADEADBEEFBADB0B,
+	}),
+	BITFIELDS_CASE(bitfields___just_big_enough, {
+		.ub1 = 0xF,
+		.ub2 = 0x0812345678FEDCBA,
+	}),
+	BITFIELDS_ERR_CASE(bitfields___err_too_big_bitfield),
 };
 
 struct data {
@@ -361,9 +432,9 @@ struct data {
 
 void test_core_reloc(void)
 {
-	const char *probe_name = "raw_tracepoint/sys_enter";
 	struct bpf_object_load_attr load_attr = {};
 	struct core_reloc_test_case *test_case;
+	const char *tp_name, *probe_name;
 	int err, duration = 0, i, equal;
 	struct bpf_link *link = NULL;
 	struct bpf_map *data_map;
@@ -387,6 +458,15 @@ void test_core_reloc(void)
 			  test_case->bpf_obj_file, PTR_ERR(obj)))
 			continue;
 
+		/* for typed raw tracepoints, NULL should be specified */
+		if (test_case->direct_raw_tp) {
+			probe_name = "tp_btf/sys_enter";
+			tp_name = NULL;
+		} else {
+			probe_name = "raw_tracepoint/sys_enter";
+			tp_name = "sys_enter";
+		}
+
 		prog = bpf_object__find_program_by_title(obj, probe_name);
 		if (CHECK(!prog, "find_probe",
 			  "prog '%s' not found\n", probe_name))
@@ -407,7 +487,7 @@ void test_core_reloc(void)
 				goto cleanup;
 		}
 
-		link = bpf_program__attach_raw_tracepoint(prog, "sys_enter");
+		link = bpf_program__attach_raw_tracepoint(prog, tp_name);
 		if (CHECK(IS_ERR(link), "attach_raw_tp", "err %ld\n",
 			  PTR_ERR(link)))
 			goto cleanup;
diff --git a/tools/testing/selftests/bpf/progs/btf__core_reloc_bitfields.c b/tools/testing/selftests/bpf/progs/btf__core_reloc_bitfields.c
new file mode 100644
index 000000000000..cff6f1836cc5
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/btf__core_reloc_bitfields.c
@@ -0,0 +1,3 @@
+#include "core_reloc_types.h"
+
+void f(struct core_reloc_bitfields x) {}
diff --git a/tools/testing/selftests/bpf/progs/btf__core_reloc_bitfields___bit_sz_change.c b/tools/testing/selftests/bpf/progs/btf__core_reloc_bitfields___bit_sz_change.c
new file mode 100644
index 000000000000..a1cd157d5451
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/btf__core_reloc_bitfields___bit_sz_change.c
@@ -0,0 +1,3 @@
+#include "core_reloc_types.h"
+
+void f(struct core_reloc_bitfields___bit_sz_change x) {}
diff --git a/tools/testing/selftests/bpf/progs/btf__core_reloc_bitfields___bitfield_vs_int.c b/tools/testing/selftests/bpf/progs/btf__core_reloc_bitfields___bitfield_vs_int.c
new file mode 100644
index 000000000000..3f2c7b07c456
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/btf__core_reloc_bitfields___bitfield_vs_int.c
@@ -0,0 +1,3 @@
+#include "core_reloc_types.h"
+
+void f(struct core_reloc_bitfields___bitfield_vs_int x) {}
diff --git a/tools/testing/selftests/bpf/progs/btf__core_reloc_bitfields___err_too_big_bitfield.c b/tools/testing/selftests/bpf/progs/btf__core_reloc_bitfields___err_too_big_bitfield.c
new file mode 100644
index 000000000000..f9746d6be399
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/btf__core_reloc_bitfields___err_too_big_bitfield.c
@@ -0,0 +1,3 @@
+#include "core_reloc_types.h"
+
+void f(struct core_reloc_bitfields___err_too_big_bitfield x) {}
diff --git a/tools/testing/selftests/bpf/progs/btf__core_reloc_bitfields___just_big_enough.c b/tools/testing/selftests/bpf/progs/btf__core_reloc_bitfields___just_big_enough.c
new file mode 100644
index 000000000000..e7c75a6953dd
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/btf__core_reloc_bitfields___just_big_enough.c
@@ -0,0 +1,3 @@
+#include "core_reloc_types.h"
+
+void f(struct core_reloc_bitfields___just_big_enough x) {}
diff --git a/tools/testing/selftests/bpf/progs/core_reloc_types.h b/tools/testing/selftests/bpf/progs/core_reloc_types.h
index 3fe54f6f82cf..7eb08d99ec46 100644
--- a/tools/testing/selftests/bpf/progs/core_reloc_types.h
+++ b/tools/testing/selftests/bpf/progs/core_reloc_types.h
@@ -662,3 +662,75 @@ struct core_reloc_existence___err_wrong_arr_value_type {
 struct core_reloc_existence___err_wrong_struct_type {
 	int s;
 };
+
+/*
+ * BITFIELDS
+ */
+/* bitfield read results, all as plain integers */
+struct core_reloc_bitfields_output {
+	int64_t		ub1;
+	int64_t		ub2;
+	int64_t		ub7;
+	int64_t		sb4;
+	int64_t		sb20;
+	int64_t		u32;
+	int64_t		s32;
+};
+
+struct core_reloc_bitfields {
+	/* unsigned bitfields */
+	uint8_t		ub1: 1;
+	uint8_t		ub2: 2;
+	uint32_t	ub7: 7;
+	/* signed bitfields */
+	int8_t		sb4: 4;
+	int32_t		sb20: 20;
+	/* non-bitfields */
+	uint32_t	u32;
+	int32_t		s32;
+};
+
+/* different bit sizes (both up and down) */
+struct core_reloc_bitfields___bit_sz_change {
+	/* unsigned bitfields */
+	uint16_t	ub1: 3;		/*  1 ->  3 */
+	uint32_t	ub2: 20;	/*  2 -> 20 */
+	uint8_t		ub7: 1;		/*  7 ->  1 */
+	/* signed bitfields */
+	int8_t		sb4: 1;		/*  4 ->  1 */
+	int32_t		sb20: 30;	/* 20 -> 30 */
+	/* non-bitfields */
+	uint16_t	u32;		/* 32 -> 16 */
+	int64_t		s32;		/* 32 -> 64 */
+};
+
+/* turn bitfield into non-bitfield and vice versa */
+struct core_reloc_bitfields___bitfield_vs_int {
+	uint64_t	ub1;		/*  3 -> 64 non-bitfield */
+	uint8_t		ub2;		/* 20 ->  8 non-bitfield */
+	int64_t		ub7;		/*  7 -> 64 non-bitfield signed */
+	int64_t		sb4;		/*  4 -> 64 non-bitfield signed */
+	uint64_t	sb20;		/* 20 -> 16 non-bitfield unsigned */
+	int32_t		u32: 20;	/* 32 non-bitfield -> 20 bitfield */
+	uint64_t	s32: 60;	/* 32 non-bitfield -> 60 bitfield */
+};
+
+struct core_reloc_bitfields___just_big_enough {
+	uint64_t	ub1: 4;
+	uint64_t	ub2: 60; /* packed tightly */
+	uint32_t	ub7;
+	uint32_t	sb4;
+	uint32_t	sb20;
+	uint32_t	u32;
+	uint32_t	s32;
+} __attribute__((packed)) ;
+
+struct core_reloc_bitfields___err_too_big_bitfield {
+	uint64_t	ub1: 4;
+	uint64_t	ub2: 61; /* packed tightly */
+	uint32_t	ub7;
+	uint32_t	sb4;
+	uint32_t	sb20;
+	uint32_t	u32;
+	uint32_t	s32;
+} __attribute__((packed)) ;
diff --git a/tools/testing/selftests/bpf/progs/test_core_reloc_bitfields_direct.c b/tools/testing/selftests/bpf/progs/test_core_reloc_bitfields_direct.c
new file mode 100644
index 000000000000..738b34b72655
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_core_reloc_bitfields_direct.c
@@ -0,0 +1,63 @@
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
+struct core_reloc_bitfields {
+	/* unsigned bitfields */
+	uint8_t		ub1: 1;
+	uint8_t		ub2: 2;
+	uint32_t	ub7: 7;
+	/* signed bitfields */
+	int8_t		sb4: 4;
+	int32_t		sb20: 20;
+	/* non-bitfields */
+	uint32_t	u32;
+	int32_t		s32;
+};
+
+/* bitfield read results, all as plain integers */
+struct core_reloc_bitfields_output {
+	int64_t		ub1;
+	int64_t		ub2;
+	int64_t		ub7;
+	int64_t		sb4;
+	int64_t		sb20;
+	int64_t		u32;
+	int64_t		s32;
+};
+
+struct pt_regs;
+
+struct trace_sys_enter {
+	struct pt_regs *regs;
+	long id;
+};
+
+SEC("tp_btf/sys_enter")
+int test_core_bitfields_direct(void *ctx)
+{
+	struct core_reloc_bitfields *in = (void *)&data.in;
+	struct core_reloc_bitfields_output *out = (void *)&data.out;
+
+	out->ub1 = BPF_CORE_READ_BITFIELD(in, ub1);
+	out->ub2 = BPF_CORE_READ_BITFIELD(in, ub2);
+	out->ub7 = BPF_CORE_READ_BITFIELD(in, ub7);
+	out->sb4 = BPF_CORE_READ_BITFIELD(in, sb4);
+	out->sb20 = BPF_CORE_READ_BITFIELD(in, sb20);
+	out->u32 = BPF_CORE_READ_BITFIELD(in, u32);
+	out->s32 = BPF_CORE_READ_BITFIELD(in, s32);
+
+	return 0;
+}
+
diff --git a/tools/testing/selftests/bpf/progs/test_core_reloc_bitfields_probed.c b/tools/testing/selftests/bpf/progs/test_core_reloc_bitfields_probed.c
new file mode 100644
index 000000000000..a381f8ac2419
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_core_reloc_bitfields_probed.c
@@ -0,0 +1,62 @@
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
+struct core_reloc_bitfields {
+	/* unsigned bitfields */
+	uint8_t		ub1: 1;
+	uint8_t		ub2: 2;
+	uint32_t	ub7: 7;
+	/* signed bitfields */
+	int8_t		sb4: 4;
+	int32_t		sb20: 20;
+	/* non-bitfields */
+	uint32_t	u32;
+	int32_t		s32;
+};
+
+/* bitfield read results, all as plain integers */
+struct core_reloc_bitfields_output {
+	int64_t		ub1;
+	int64_t		ub2;
+	int64_t		ub7;
+	int64_t		sb4;
+	int64_t		sb20;
+	int64_t		u32;
+	int64_t		s32;
+};
+
+#define TRANSFER_BITFIELD(in, out, field)				\
+	if (BPF_CORE_READ_BITFIELD_PROBED(in, field, &res))		\
+		return 1;						\
+	out->field = res
+
+SEC("raw_tracepoint/sys_enter")
+int test_core_bitfields(void *ctx)
+{
+	struct core_reloc_bitfields *in = (void *)&data.in;
+	struct core_reloc_bitfields_output *out = (void *)&data.out;
+	uint64_t res;
+
+	TRANSFER_BITFIELD(in, out, ub1);
+	TRANSFER_BITFIELD(in, out, ub2);
+	TRANSFER_BITFIELD(in, out, ub7);
+	TRANSFER_BITFIELD(in, out, sb4);
+	TRANSFER_BITFIELD(in, out, sb20);
+	TRANSFER_BITFIELD(in, out, u32);
+	TRANSFER_BITFIELD(in, out, s32);
+
+	return 0;
+}
+
-- 
2.17.1

