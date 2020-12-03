Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E8CC2CCD8F
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 04:55:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388015AbgLCDxN convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 2 Dec 2020 22:53:13 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:56260 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387928AbgLCDxM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 22:53:12 -0500
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B33kb4I015305
        for <netdev@vger.kernel.org>; Wed, 2 Dec 2020 19:52:30 -0800
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 355t7ybft4-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 02 Dec 2020 19:52:30 -0800
Received: from intmgw002.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 2 Dec 2020 19:52:29 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id C40702ECA822; Wed,  2 Dec 2020 19:52:23 -0800 (PST)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii@kernel.org>, <kernel-team@fb.com>
Subject: [PATCH v5 bpf-next 08/14] selftests/bpf: add CO-RE relocs selftest relying on kernel module BTF
Date:   Wed, 2 Dec 2020 19:51:58 -0800
Message-ID: <20201203035204.1411380-9-andrii@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20201203035204.1411380-1-andrii@kernel.org>
References: <20201203035204.1411380-1-andrii@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-12-03_01:2020-11-30,2020-12-03 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 adultscore=0 priorityscore=1501 bulkscore=0 mlxlogscore=999 phishscore=0
 mlxscore=0 suspectscore=8 impostorscore=0 spamscore=0 lowpriorityscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012030020
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a self-tests validating libbpf is able to perform CO-RE relocations
against the type defined in kernel module BTF. if bpf_testmod.o is not
supported by the kernel (e.g., due to version mismatch), skip tests, instead
of failing.

Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
---
 .../selftests/bpf/prog_tests/core_reloc.c     | 79 ++++++++++++++++---
 .../selftests/bpf/progs/core_reloc_types.h    | 17 ++++
 .../bpf/progs/test_core_reloc_module.c        | 66 ++++++++++++++++
 3 files changed, 151 insertions(+), 11 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/progs/test_core_reloc_module.c

diff --git a/tools/testing/selftests/bpf/prog_tests/core_reloc.c b/tools/testing/selftests/bpf/prog_tests/core_reloc.c
index 30e40ff4b0d8..bb980848cd77 100644
--- a/tools/testing/selftests/bpf/prog_tests/core_reloc.c
+++ b/tools/testing/selftests/bpf/prog_tests/core_reloc.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 #include <test_progs.h>
 #include "progs/core_reloc_types.h"
+#include "bpf_testmod/bpf_testmod.h"
 #include <sys/mman.h>
 #include <sys/syscall.h>
 #include <bpf/btf.h>
@@ -9,6 +10,30 @@ static int duration = 0;
 
 #define STRUCT_TO_CHAR_PTR(struct_name) (const char *)&(struct struct_name)
 
+#define MODULES_CASE(name, sec_name, tp_name) {				\
+	.case_name = name,						\
+	.bpf_obj_file = "test_core_reloc_module.o",			\
+	.btf_src_file = NULL, /* find in kernel module BTFs */		\
+	.input = "",							\
+	.input_len = 0,							\
+	.output = STRUCT_TO_CHAR_PTR(core_reloc_module_output) {	\
+		.read_ctx_sz = sizeof(struct bpf_testmod_test_read_ctx),\
+		.read_ctx_exists = true,				\
+		.buf_exists = true,					\
+		.len_exists = true,					\
+		.off_exists = true,					\
+		.len = 123,						\
+		.off = 0,						\
+		.comm = "test_progs",					\
+		.comm_len = sizeof("test_progs"),			\
+	},								\
+	.output_len = sizeof(struct core_reloc_module_output),		\
+	.prog_sec_name = sec_name,					\
+	.raw_tp_name = tp_name,						\
+	.trigger = trigger_module_test_read,				\
+	.needs_testmod = true,						\
+}
+
 #define FLAVORS_DATA(struct_name) STRUCT_TO_CHAR_PTR(struct_name) {	\
 	.a = 42,							\
 	.b = 0xc001,							\
@@ -211,7 +236,7 @@ static int duration = 0;
 	.output = STRUCT_TO_CHAR_PTR(core_reloc_bitfields_output)	\
 		__VA_ARGS__,						\
 	.output_len = sizeof(struct core_reloc_bitfields_output),	\
-	.direct_raw_tp = true,						\
+	.prog_sec_name = "tp_btf/sys_enter",				\
 }
 
 
@@ -222,7 +247,7 @@ static int duration = 0;
 }, {									\
 	BITFIELDS_CASE_COMMON("test_core_reloc_bitfields_direct.o",	\
 			      "direct:", name),				\
-	.direct_raw_tp = true,						\
+	.prog_sec_name = "tp_btf/sys_enter",				\
 	.fails = true,							\
 }
 
@@ -309,6 +334,7 @@ static int duration = 0;
 struct core_reloc_test_case;
 
 typedef int (*setup_test_fn)(struct core_reloc_test_case *test);
+typedef int (*trigger_test_fn)(const struct core_reloc_test_case *test);
 
 struct core_reloc_test_case {
 	const char *case_name;
@@ -319,9 +345,12 @@ struct core_reloc_test_case {
 	const char *output;
 	int output_len;
 	bool fails;
+	bool needs_testmod;
 	bool relaxed_core_relocs;
-	bool direct_raw_tp;
+	const char *prog_sec_name;
+	const char *raw_tp_name;
 	setup_test_fn setup;
+	trigger_test_fn trigger;
 };
 
 static int find_btf_type(const struct btf *btf, const char *name, __u32 kind)
@@ -451,6 +480,23 @@ static int setup_type_id_case_failure(struct core_reloc_test_case *test)
 	return 0;
 }
 
+static int trigger_module_test_read(const struct core_reloc_test_case *test)
+{
+	struct core_reloc_module_output *exp = (void *)test->output;
+	int fd, err;
+
+	fd = open("/sys/kernel/bpf_testmod", O_RDONLY);
+	err = -errno;
+	if (CHECK(fd < 0, "testmod_file_open", "failed: %d\n", err))
+		return err;
+
+	read(fd, NULL, exp->len); /* request expected number of bytes */
+	close(fd);
+
+	return 0;
+}
+
+
 static struct core_reloc_test_case test_cases[] = {
 	/* validate we can find kernel image and use its BTF for relocs */
 	{
@@ -467,6 +513,9 @@ static struct core_reloc_test_case test_cases[] = {
 		.output_len = sizeof(struct core_reloc_kernel_output),
 	},
 
+	/* validate we can find kernel module BTF types for relocs/attach */
+	MODULES_CASE("module", "raw_tp/bpf_testmod_test_read", "bpf_testmod_test_read"),
+
 	/* validate BPF program can use multiple flavors to match against
 	 * single target BTF type
 	 */
@@ -779,6 +828,11 @@ void test_core_reloc(void)
 		if (!test__start_subtest(test_case->case_name))
 			continue;
 
+		if (test_case->needs_testmod && !env.has_testmod) {
+			test__skip();
+			continue;
+		}
+
 		if (test_case->setup) {
 			err = test_case->setup(test_case);
 			if (CHECK(err, "test_setup", "test #%d setup failed: %d\n", i, err))
@@ -790,13 +844,11 @@ void test_core_reloc(void)
 			  test_case->bpf_obj_file, PTR_ERR(obj)))
 			continue;
 
-		/* for typed raw tracepoints, NULL should be specified */
-		if (test_case->direct_raw_tp) {
-			probe_name = "tp_btf/sys_enter";
-			tp_name = NULL;
-		} else {
-			probe_name = "raw_tracepoint/sys_enter";
-			tp_name = "sys_enter";
+		probe_name = "raw_tracepoint/sys_enter";
+		tp_name = "sys_enter";
+		if (test_case->prog_sec_name) {
+			probe_name = test_case->prog_sec_name;
+			tp_name = test_case->raw_tp_name; /* NULL for tp_btf */
 		}
 
 		prog = bpf_object__find_program_by_title(obj, probe_name);
@@ -837,7 +889,12 @@ void test_core_reloc(void)
 			goto cleanup;
 
 		/* trigger test run */
-		usleep(1);
+		if (test_case->trigger) {
+			if (!ASSERT_OK(test_case->trigger(test_case), "test_trigger"))
+				goto cleanup;
+		} else {
+			usleep(1);
+		}
 
 		if (data->skip) {
 			test__skip();
diff --git a/tools/testing/selftests/bpf/progs/core_reloc_types.h b/tools/testing/selftests/bpf/progs/core_reloc_types.h
index e6e616cb7bc9..9a2850850121 100644
--- a/tools/testing/selftests/bpf/progs/core_reloc_types.h
+++ b/tools/testing/selftests/bpf/progs/core_reloc_types.h
@@ -15,6 +15,23 @@ struct core_reloc_kernel_output {
 	int comm_len;
 };
 
+/*
+ * MODULE
+ */
+
+struct core_reloc_module_output {
+	long long len;
+	long long off;
+	int read_ctx_sz;
+	bool read_ctx_exists;
+	bool buf_exists;
+	bool len_exists;
+	bool off_exists;
+	/* we have test_progs[-flavor], so cut flavor part */
+	char comm[sizeof("test_progs")];
+	int comm_len;
+};
+
 /*
  * FLAVORS
  */
diff --git a/tools/testing/selftests/bpf/progs/test_core_reloc_module.c b/tools/testing/selftests/bpf/progs/test_core_reloc_module.c
new file mode 100644
index 000000000000..d1840c1a9d36
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_core_reloc_module.c
@@ -0,0 +1,66 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2020 Facebook */
+
+#include "vmlinux.h"
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_core_read.h>
+#include <bpf/bpf_tracing.h>
+
+char _license[] SEC("license") = "GPL";
+
+struct bpf_testmod_test_read_ctx {
+	/* field order is mixed up */
+	size_t len;
+	char *buf;
+	loff_t off;
+} __attribute__((preserve_access_index));
+
+struct {
+	char in[256];
+	char out[256];
+	bool skip;
+	uint64_t my_pid_tgid;
+} data = {};
+
+struct core_reloc_module_output {
+	long long len;
+	long long off;
+	int read_ctx_sz;
+	bool read_ctx_exists;
+	bool buf_exists;
+	bool len_exists;
+	bool off_exists;
+	/* we have test_progs[-flavor], so cut flavor part */
+	char comm[sizeof("test_progs")];
+	int comm_len;
+};
+
+SEC("raw_tp/bpf_testmod_test_read")
+int BPF_PROG(test_core_module,
+	     struct task_struct *task,
+	     struct bpf_testmod_test_read_ctx *read_ctx)
+{
+	struct core_reloc_module_output *out = (void *)&data.out;
+	__u64 pid_tgid = bpf_get_current_pid_tgid();
+	__u32 real_tgid = (__u32)(pid_tgid >> 32);
+	__u32 real_pid = (__u32)pid_tgid;
+
+	if (data.my_pid_tgid != pid_tgid)
+		return 0;
+
+	if (BPF_CORE_READ(task, pid) != real_pid || BPF_CORE_READ(task, tgid) != real_tgid)
+		return 0;
+
+	out->len = BPF_CORE_READ(read_ctx, len);
+	out->off = BPF_CORE_READ(read_ctx, off);
+
+	out->read_ctx_sz = bpf_core_type_size(struct bpf_testmod_test_read_ctx);
+	out->read_ctx_exists = bpf_core_type_exists(struct bpf_testmod_test_read_ctx);
+	out->buf_exists = bpf_core_field_exists(read_ctx->buf);
+	out->off_exists = bpf_core_field_exists(read_ctx->off);
+	out->len_exists = bpf_core_field_exists(read_ctx->len);
+
+	out->comm_len = BPF_CORE_READ_STR_INTO(&out->comm, task, comm);
+
+	return 0;
+}
-- 
2.24.1

