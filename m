Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 553F411EEE4
	for <lists+netdev@lfdr.de>; Sat, 14 Dec 2019 00:52:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726690AbfLMXwL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Dec 2019 18:52:11 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:57396 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726590AbfLMXwL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Dec 2019 18:52:11 -0500
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBDNpfA9017898
        for <netdev@vger.kernel.org>; Fri, 13 Dec 2019 15:52:10 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=nSzhC/ufed+W/5uy85WblWvRZ4Z+IAXYB2k6meO+bPI=;
 b=b2hRIEIwNnjSevf46gwKoMx7VgU8O/Gy6WkJddHy1l9T7YCDfUqEWrSDDNBNeWRNgCXY
 /Ldqs7NwuoMHGpnP03aeYZgZ2mLoqarYFvQhKYD/FKUV97WNveZHbIoCGoSjE73UGnwj
 kPGIAc/mJKbemZXq0KwV6jgmenL9OmzNhHI= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2wvm79r394-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 13 Dec 2019 15:52:10 -0800
Received: from intmgw001.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 13 Dec 2019 15:51:55 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 3BD0D2EC1A1D; Fri, 13 Dec 2019 15:51:55 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v3 bpf-next 4/4] selftests/bpf: add tests for libbpf-provided externs
Date:   Fri, 13 Dec 2019 15:51:44 -0800
Message-ID: <20191213235144.3063354-5-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191213235144.3063354-1-andriin@fb.com>
References: <20191213235144.3063354-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-13_09:2019-12-13,2019-12-13 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 suspectscore=8 bulkscore=0 priorityscore=1501 mlxscore=0 impostorscore=0
 clxscore=1015 spamscore=0 adultscore=0 phishscore=0 mlxlogscore=999
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912130165
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a set of tests validating libbpf-provided extern variables. One crucial
feature that's tested is dead code elimination together with using invalid BPF
helper. CONFIG_MISSING is not supposed to exist and should always be specified
by libbpf as zero, which allows BPF verifier to correctly do branch pruning
and not fail validation, when invalid BPF helper is called from dead if branch.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 .../selftests/bpf/prog_tests/core_extern.c    | 193 ++++++++++++++++++
 .../selftests/bpf/prog_tests/skeleton.c       |  18 +-
 .../selftests/bpf/progs/test_core_extern.c    |  62 ++++++
 .../selftests/bpf/progs/test_skeleton.c       |   9 +
 4 files changed, 281 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/core_extern.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_core_extern.c

diff --git a/tools/testing/selftests/bpf/prog_tests/core_extern.c b/tools/testing/selftests/bpf/prog_tests/core_extern.c
new file mode 100644
index 000000000000..4f5f8439cb02
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/core_extern.c
@@ -0,0 +1,193 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <test_progs.h>
+#include <sys/mman.h>
+#include <sys/utsname.h>
+#include <linux/version.h>
+#include "test_core_extern.skel.h"
+
+static uint32_t get_kernel_version(void)
+{
+	uint32_t major, minor, patch;
+	struct utsname info;
+
+	uname(&info);
+	if (sscanf(info.release, "%u.%u.%u", &major, &minor, &patch) != 3)
+		return 0;
+	return KERNEL_VERSION(major, minor, patch);
+}
+
+#define CFG "CONFIG_BPF_SYSCALL=n\n"
+
+static struct test_case {
+	const char *name;
+	const char *cfg;
+	const char *cfg_path;
+	bool fails;
+	struct test_core_extern__data data;
+} test_cases[] = {
+	{ .name = "default search path", .cfg_path = NULL,
+	  .data = { .bpf_syscall = true } },
+	{ .name = "/proc/config.gz", .cfg_path = "/proc/config.gz",
+	  .data = { .bpf_syscall = true } },
+	{ .name = "missing config", .fails = true,
+	  .cfg_path = "/proc/invalid-config.gz" },
+	{
+		.name = "custom values",
+		.cfg = "CONFIG_BPF_SYSCALL=y\n"
+		       "CONFIG_TRISTATE=m\n"
+		       "CONFIG_BOOL=y\n"
+		       "CONFIG_CHAR=100\n"
+		       "CONFIG_USHORT=30000\n"
+		       "CONFIG_INT=123456\n"
+		       "CONFIG_ULONG=0xDEADBEEFC0DE\n"
+		       "CONFIG_STR=\"abracad\"\n"
+		       "CONFIG_MISSING=0",
+		.data = {
+			.bpf_syscall = true,
+			.tristate_val = TRI_MODULE,
+			.bool_val = true,
+			.char_val = 100,
+			.ushort_val = 30000,
+			.int_val = 123456,
+			.ulong_val = 0xDEADBEEFC0DE,
+			.str_val = "abracad",
+		},
+	},
+	/* TRISTATE */
+	{ .name = "tristate (y)", .cfg = CFG"CONFIG_TRISTATE=y\n",
+	  .data = { .tristate_val = TRI_YES } },
+	{ .name = "tristate (n)", .cfg = CFG"CONFIG_TRISTATE=n\n",
+	  .data = { .tristate_val = TRI_NO } },
+	{ .name = "tristate (m)", .cfg = CFG"CONFIG_TRISTATE=m\n",
+	  .data = { .tristate_val = TRI_MODULE } },
+	{ .name = "tristate (int)", .fails = 1, .cfg = CFG"CONFIG_TRISTATE=1" },
+	{ .name = "tristate (bad)", .fails = 1, .cfg = CFG"CONFIG_TRISTATE=M" },
+	/* BOOL */
+	{ .name = "bool (y)", .cfg = CFG"CONFIG_BOOL=y\n",
+	  .data = { .bool_val = true } },
+	{ .name = "bool (n)", .cfg = CFG"CONFIG_BOOL=n\n",
+	  .data = { .bool_val = false } },
+	{ .name = "bool (tristate)", .fails = 1, .cfg = CFG"CONFIG_BOOL=m" },
+	{ .name = "bool (int)", .fails = 1, .cfg = CFG"CONFIG_BOOL=1" },
+	/* CHAR */
+	{ .name = "char (tristate)", .cfg = CFG"CONFIG_CHAR=m\n",
+	  .data = { .char_val = 'm' } },
+	{ .name = "char (bad)", .fails = 1, .cfg = CFG"CONFIG_CHAR=q\n" },
+	{ .name = "char (empty)", .fails = 1, .cfg = CFG"CONFIG_CHAR=\n" },
+	{ .name = "char (str)", .fails = 1, .cfg = CFG"CONFIG_CHAR=\"y\"\n" },
+	/* STRING */
+	{ .name = "str (empty)", .cfg = CFG"CONFIG_STR=\"\"\n",
+	  .data = { .str_val = "\0\0\0\0\0\0\0" } },
+	{ .name = "str (padded)", .cfg = CFG"CONFIG_STR=\"abra\"\n",
+	  .data = { .str_val = "abra\0\0\0" } },
+	{ .name = "str (too long)", .cfg = CFG"CONFIG_STR=\"abracada\"\n",
+	  .data = { .str_val = "abracad" } },
+	{ .name = "str (no value)", .fails = 1, .cfg = CFG"CONFIG_STR=\n" },
+	{ .name = "str (bad value)", .fails = 1, .cfg = CFG"CONFIG_STR=bla\n" },
+	/* INTEGERS */
+	{
+		.name = "integer forms",
+		.cfg = CFG
+		       "CONFIG_CHAR=0xA\n"
+		       "CONFIG_USHORT=0462\n"
+		       "CONFIG_INT=-100\n"
+		       "CONFIG_ULONG=+1000000000000",
+		.data = {
+			.char_val = 0xA,
+			.ushort_val = 0462,
+			.int_val = -100,
+			.ulong_val = 1000000000000,
+		},
+	},
+	{ .name = "int (bad)", .fails = 1, .cfg = CFG"CONFIG_INT=abc" },
+	{ .name = "int (str)", .fails = 1, .cfg = CFG"CONFIG_INT=\"abc\"" },
+	{ .name = "int (empty)", .fails = 1, .cfg = CFG"CONFIG_INT=" },
+	{ .name = "int (mixed)", .fails = 1, .cfg = CFG"CONFIG_INT=123abc" },
+	{ .name = "int (max)", .cfg = CFG"CONFIG_INT=2147483647",
+	  .data = { .int_val = 2147483647 } },
+	{ .name = "int (min)", .cfg = CFG"CONFIG_INT=-2147483648",
+	  .data = { .int_val = -2147483648 } },
+	{ .name = "int (max+1)", .fails = 1, .cfg = CFG"CONFIG_INT=2147483648" },
+	{ .name = "int (min-1)", .fails = 1, .cfg = CFG"CONFIG_INT=-2147483649" },
+	{ .name = "ushort (max)", .cfg = CFG"CONFIG_USHORT=65535",
+	  .data = { .ushort_val = 65535 } },
+	{ .name = "ushort (min)", .cfg = CFG"CONFIG_USHORT=0",
+	  .data = { .ushort_val = 0 } },
+	{ .name = "ushort (max+1)", .fails = 1, .cfg = CFG"CONFIG_USHORT=65536" },
+	{ .name = "ushort (min-1)", .fails = 1, .cfg = CFG"CONFIG_USHORT=-1" },
+	{ .name = "u64 (max)", .cfg = CFG"CONFIG_ULONG=0xffffffffffffffff",
+	  .data = { .ulong_val = 0xffffffffffffffff } },
+	{ .name = "u64 (min)", .cfg = CFG"CONFIG_ULONG=0",
+	  .data = { .ulong_val = 0 } },
+	{ .name = "u64 (max+1)", .fails = 1, .cfg = CFG"CONFIG_ULONG=0x10000000000000000" },
+};
+
+BPF_EMBED_OBJ(core_extern, "test_core_extern.o");
+
+void test_core_extern(void)
+{
+	const uint32_t kern_ver = get_kernel_version();
+	int err, duration = 0, i, j;
+	struct test_core_extern *skel = NULL;
+	uint64_t *got, *exp;
+	int n = sizeof(*skel->data) / sizeof(uint64_t);
+
+	for (i = 0; i < ARRAY_SIZE(test_cases); i++) {
+		char tmp_cfg_path[] = "/tmp/test_core_extern_cfg.XXXXXX";
+		struct test_case *t = &test_cases[i];
+		DECLARE_LIBBPF_OPTS(bpf_object_open_opts, opts,
+			.kconfig_path = t->cfg_path,
+		);
+
+		if (!test__start_subtest(t->name))
+			continue;
+
+		if (t->cfg) {
+			size_t n = strlen(t->cfg) + 1;
+			int fd = mkstemp(tmp_cfg_path);
+			int written;
+
+			if (CHECK(fd < 0, "mkstemp", "errno: %d\n", errno))
+				continue;
+			printf("using '%s' as config file\n", tmp_cfg_path);
+			written = write(fd, t->cfg, n);
+			close(fd);
+			if (CHECK_FAIL(written != n))
+				goto cleanup;
+			opts.kconfig_path = tmp_cfg_path;
+		}
+
+		skel = test_core_extern__open_opts(&core_extern_embed, &opts);
+		if (CHECK(!skel, "skel_open", "skeleton open failed\n"))
+			goto cleanup;
+		err = test_core_extern__load(skel);
+		if (t->fails) {
+			CHECK(!err, "skel_load",
+			      "shouldn't succeed open/load of skeleton\n");
+			goto cleanup;
+		} else if (CHECK(err, "skel_load",
+				 "failed to open/load skeleton\n")) {
+			goto cleanup;
+		}
+		err = test_core_extern__attach(skel);
+		if (CHECK(err, "attach_raw_tp", "failed attach: %d\n", err))
+			goto cleanup;
+
+		usleep(1);
+
+		t->data.kern_ver = kern_ver;
+		t->data.missing_val = 0xDEADC0DE;
+		got = (uint64_t *)skel->data;
+		exp = (uint64_t *)&t->data;
+		for (j = 0; j < n; j++) {
+			CHECK(got[j] != exp[j], "check_res",
+			      "result #%d: expected %lx, but got %lx\n",
+			       j, exp[j], got[j]);
+		}
+cleanup:
+		if (t->cfg)
+			unlink(tmp_cfg_path);
+		test_core_extern__destroy(skel);
+		skel = NULL;
+	}
+}
diff --git a/tools/testing/selftests/bpf/prog_tests/skeleton.c b/tools/testing/selftests/bpf/prog_tests/skeleton.c
index 94e0300f437a..3cd3b721764c 100644
--- a/tools/testing/selftests/bpf/prog_tests/skeleton.c
+++ b/tools/testing/selftests/bpf/prog_tests/skeleton.c
@@ -15,11 +15,21 @@ void test_skeleton(void)
 	int duration = 0, err;
 	struct test_skeleton* skel;
 	struct test_skeleton__bss *bss;
+	struct test_skeleton__externs *exts;
 
-	skel = test_skeleton__open_and_load(&skeleton_embed);
+	skel = test_skeleton__open(&skeleton_embed);
 	if (CHECK(!skel, "skel_open", "failed to open skeleton\n"))
 		return;
 
+	printf("EXTERNS BEFORE: %p\n", skel->externs);
+	if (CHECK(skel->externs, "skel_externs", "externs are mmaped()!\n"))
+		goto cleanup;
+
+	err = test_skeleton__load(skel);
+	if (CHECK(err, "skel_load", "failed to load skeleton: %d\n", err))
+		goto cleanup;
+	printf("EXTERNS AFTER: %p\n", skel->externs);
+
 	bss = skel->bss;
 	bss->in1 = 1;
 	bss->in2 = 2;
@@ -27,6 +37,7 @@ void test_skeleton(void)
 	bss->in4 = 4;
 	bss->in5.a = 5;
 	bss->in5.b = 6;
+	exts = skel->externs;
 
 	err = test_skeleton__attach(skel);
 	if (CHECK(err, "skel_attach", "skeleton attach failed: %d\n", err))
@@ -44,6 +55,11 @@ void test_skeleton(void)
 	CHECK(bss->handler_out5.b != 6, "res6", "got %lld != exp %d\n",
 	      bss->handler_out5.b, 6);
 
+	CHECK(bss->bpf_syscall != exts->CONFIG_BPF_SYSCALL, "ext1",
+	      "got %d != exp %d\n", bss->bpf_syscall, exts->CONFIG_BPF_SYSCALL);
+	CHECK(bss->kern_ver != exts->LINUX_KERNEL_VERSION, "ext2",
+	      "got %d != exp %d\n", bss->kern_ver, exts->LINUX_KERNEL_VERSION);
+
 cleanup:
 	test_skeleton__destroy(skel);
 }
diff --git a/tools/testing/selftests/bpf/progs/test_core_extern.c b/tools/testing/selftests/bpf/progs/test_core_extern.c
new file mode 100644
index 000000000000..5cf7b57202ec
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_core_extern.c
@@ -0,0 +1,62 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright (c) 2017 Facebook
+
+#include <stdint.h>
+#include <stdbool.h>
+#include <linux/ptrace.h>
+#include <linux/bpf.h>
+#include "bpf_helpers.h"
+
+/* non-existing BPF helper, to test dead code elimination */
+static int (*bpf_missing_helper)(const void *arg1, int arg2) = (void *) 999;
+
+extern int LINUX_KERNEL_VERSION;
+extern bool CONFIG_BPF_SYSCALL; /* strong */
+extern enum libbpf_tristate CONFIG_TRISTATE __weak;
+extern bool CONFIG_BOOL __weak;
+extern char CONFIG_CHAR __weak;
+extern uint16_t CONFIG_USHORT __weak;
+extern int CONFIG_INT __weak;
+extern uint64_t CONFIG_ULONG __weak;
+extern const char CONFIG_STR[8] __weak;
+extern uint64_t CONFIG_MISSING __weak;
+
+uint64_t kern_ver = -1;
+uint64_t bpf_syscall = -1;
+uint64_t tristate_val = -1;
+uint64_t bool_val = -1;
+uint64_t char_val = -1;
+uint64_t ushort_val = -1;
+uint64_t int_val = -1;
+uint64_t ulong_val = -1;
+char str_val[8] = {-1, -1, -1, -1, -1, -1, -1, -1};
+uint64_t missing_val = -1;
+
+SEC("raw_tp/sys_enter")
+int handle_sys_enter(struct pt_regs *ctx)
+{
+	int i;
+
+	kern_ver = LINUX_KERNEL_VERSION;
+	bpf_syscall = CONFIG_BPF_SYSCALL;
+	tristate_val = CONFIG_TRISTATE;
+	bool_val = CONFIG_BOOL;
+	char_val = CONFIG_CHAR;
+	ushort_val = CONFIG_USHORT;
+	int_val = CONFIG_INT;
+	ulong_val = CONFIG_ULONG;
+
+	for (i = 0; i < sizeof(CONFIG_STR); i++) {
+		str_val[i] = CONFIG_STR[i];
+	}
+
+	if (CONFIG_MISSING)
+		/* invalid, but dead code - never executed */
+		missing_val = bpf_missing_helper(ctx, 123);
+	else
+		missing_val = 0xDEADC0DE;
+
+	return 0;
+}
+
+char _license[] SEC("license") = "GPL";
diff --git a/tools/testing/selftests/bpf/progs/test_skeleton.c b/tools/testing/selftests/bpf/progs/test_skeleton.c
index db4fd88f3ecb..8d53341be013 100644
--- a/tools/testing/selftests/bpf/progs/test_skeleton.c
+++ b/tools/testing/selftests/bpf/progs/test_skeleton.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 // Copyright (c) 2017 Facebook
 
+#include <stdbool.h>
 #include <linux/bpf.h>
 #include "bpf_helpers.h"
 
@@ -20,6 +21,10 @@ char out3 = 0;
 long long out4 = 0;
 int out1 = 0;
 
+extern bool CONFIG_BPF_SYSCALL;
+extern int LINUX_KERNEL_VERSION;
+bool bpf_syscall = 0;
+int kern_ver = 0;
 
 SEC("raw_tp/sys_enter")
 int handler(const void *ctx)
@@ -31,6 +36,10 @@ int handler(const void *ctx)
 	out3 = in3;
 	out4 = in4;
 	out5 = in5;
+
+	bpf_syscall = CONFIG_BPF_SYSCALL;
+	kern_ver = LINUX_KERNEL_VERSION;
+
 	return 0;
 }
 
-- 
2.17.1

