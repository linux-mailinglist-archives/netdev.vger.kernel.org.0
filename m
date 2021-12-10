Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D901470252
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 15:02:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239310AbhLJOFR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 09:05:17 -0500
Received: from szxga03-in.huawei.com ([45.249.212.189]:29180 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239203AbhLJOFO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 09:05:14 -0500
Received: from dggpeml500025.china.huawei.com (unknown [172.30.72.54])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4J9XZp1VtJz8vpp;
        Fri, 10 Dec 2021 21:59:30 +0800 (CST)
Received: from huawei.com (10.175.124.27) by dggpeml500025.china.huawei.com
 (7.185.36.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.20; Fri, 10 Dec
 2021 22:01:37 +0800
From:   Hou Tao <houtao1@huawei.com>
To:     Alexei Starovoitov <ast@kernel.org>
CC:     Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <houtao1@huawei.com>
Subject: [PATCH bpf-next v2 4/4] selftests/bpf: add test cases for bpf_strncmp()
Date:   Fri, 10 Dec 2021 22:16:52 +0800
Message-ID: <20211210141652.877186-5-houtao1@huawei.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20211210141652.877186-1-houtao1@huawei.com>
References: <20211210141652.877186-1-houtao1@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.124.27]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpeml500025.china.huawei.com (7.185.36.35)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Four test cases are added:
(1) ensure the return value is expected
(2) ensure no const string size is rejected
(3) ensure writable target is rejected
(4) ensure no null-terminated target is rejected

Signed-off-by: Hou Tao <houtao1@huawei.com>
---
 .../selftests/bpf/prog_tests/test_strncmp.c   | 167 ++++++++++++++++++
 .../selftests/bpf/progs/strncmp_test.c        |  54 ++++++
 2 files changed, 221 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/test_strncmp.c
 create mode 100644 tools/testing/selftests/bpf/progs/strncmp_test.c

diff --git a/tools/testing/selftests/bpf/prog_tests/test_strncmp.c b/tools/testing/selftests/bpf/prog_tests/test_strncmp.c
new file mode 100644
index 000000000000..b57a3009465f
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/test_strncmp.c
@@ -0,0 +1,167 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (C) 2021. Huawei Technologies Co., Ltd */
+#include <test_progs.h>
+#include "strncmp_test.skel.h"
+
+static int trigger_strncmp(const struct strncmp_test *skel)
+{
+	int cmp;
+
+	usleep(1);
+
+	cmp = skel->bss->cmp_ret;
+	if (cmp > 0)
+		return 1;
+	if (cmp < 0)
+		return -1;
+	return 0;
+}
+
+/*
+ * Compare str and target after making str[i] != target[i].
+ * When exp is -1, make str[i] < target[i] and delta = -1.
+ */
+static void strncmp_full_str_cmp(struct strncmp_test *skel, const char *name,
+				 int exp)
+{
+	size_t nr = sizeof(skel->bss->str);
+	char *str = skel->bss->str;
+	int delta = exp;
+	int got;
+	size_t i;
+
+	memcpy(str, skel->rodata->target, nr);
+	for (i = 0; i < nr - 1; i++) {
+		str[i] += delta;
+
+		got = trigger_strncmp(skel);
+		ASSERT_EQ(got, exp, name);
+
+		str[i] -= delta;
+	}
+}
+
+static void test_strncmp_ret(void)
+{
+	struct strncmp_test *skel;
+	struct bpf_program *prog;
+	int err, got;
+
+	skel = strncmp_test__open();
+	if (!ASSERT_OK_PTR(skel, "strncmp_test open"))
+		return;
+
+	bpf_object__for_each_program(prog, skel->obj)
+		bpf_program__set_autoload(prog, false);
+
+	bpf_program__set_autoload(skel->progs.do_strncmp, true);
+
+	err = strncmp_test__load(skel);
+	if (!ASSERT_EQ(err, 0, "strncmp_test load"))
+		goto out;
+
+	err = strncmp_test__attach(skel);
+	if (!ASSERT_EQ(err, 0, "strncmp_test attach"))
+		goto out;
+
+	skel->bss->target_pid = getpid();
+
+	/* Empty str */
+	skel->bss->str[0] = '\0';
+	got = trigger_strncmp(skel);
+	ASSERT_EQ(got, -1, "strncmp: empty str");
+
+	/* Same string */
+	memcpy(skel->bss->str, skel->rodata->target, sizeof(skel->bss->str));
+	got = trigger_strncmp(skel);
+	ASSERT_EQ(got, 0, "strncmp: same str");
+
+	/* Not-null-termainted string  */
+	memcpy(skel->bss->str, skel->rodata->target, sizeof(skel->bss->str));
+	skel->bss->str[sizeof(skel->bss->str) - 1] = 'A';
+	got = trigger_strncmp(skel);
+	ASSERT_EQ(got, 1, "strncmp: not-null-term str");
+
+	strncmp_full_str_cmp(skel, "strncmp: less than", -1);
+	strncmp_full_str_cmp(skel, "strncmp: greater than", 1);
+out:
+	strncmp_test__destroy(skel);
+}
+
+static void test_strncmp_bad_not_const_str_size(void)
+{
+	struct strncmp_test *skel;
+	struct bpf_program *prog;
+	int err;
+
+	skel = strncmp_test__open();
+	if (!ASSERT_OK_PTR(skel, "strncmp_test open"))
+		return;
+
+	bpf_object__for_each_program(prog, skel->obj)
+		bpf_program__set_autoload(prog, false);
+
+	bpf_program__set_autoload(skel->progs.strncmp_bad_not_const_str_size,
+				  true);
+
+	err = strncmp_test__load(skel);
+	ASSERT_ERR(err, "strncmp_test load bad_not_const_str_size");
+
+	strncmp_test__destroy(skel);
+}
+
+static void test_strncmp_bad_writable_target(void)
+{
+	struct strncmp_test *skel;
+	struct bpf_program *prog;
+	int err;
+
+	skel = strncmp_test__open();
+	if (!ASSERT_OK_PTR(skel, "strncmp_test open"))
+		return;
+
+	bpf_object__for_each_program(prog, skel->obj)
+		bpf_program__set_autoload(prog, false);
+
+	bpf_program__set_autoload(skel->progs.strncmp_bad_writable_target,
+				  true);
+
+	err = strncmp_test__load(skel);
+	ASSERT_ERR(err, "strncmp_test load bad_writable_target");
+
+	strncmp_test__destroy(skel);
+}
+
+static void test_strncmp_bad_not_null_term_target(void)
+{
+	struct strncmp_test *skel;
+	struct bpf_program *prog;
+	int err;
+
+	skel = strncmp_test__open();
+	if (!ASSERT_OK_PTR(skel, "strncmp_test open"))
+		return;
+
+	bpf_object__for_each_program(prog, skel->obj)
+		bpf_program__set_autoload(prog, false);
+
+	bpf_program__set_autoload(skel->progs.strncmp_bad_not_null_term_target,
+				  true);
+
+	err = strncmp_test__load(skel);
+	ASSERT_ERR(err, "strncmp_test load bad_not_null_term_target");
+
+	strncmp_test__destroy(skel);
+}
+
+void test_test_strncmp(void)
+{
+	if (test__start_subtest("strncmp_ret"))
+		test_strncmp_ret();
+	if (test__start_subtest("strncmp_bad_not_const_str_size"))
+		test_strncmp_bad_not_const_str_size();
+	if (test__start_subtest("strncmp_bad_writable_target"))
+		test_strncmp_bad_writable_target();
+	if (test__start_subtest("strncmp_bad_not_null_term_target"))
+		test_strncmp_bad_not_null_term_target();
+}
diff --git a/tools/testing/selftests/bpf/progs/strncmp_test.c b/tools/testing/selftests/bpf/progs/strncmp_test.c
new file mode 100644
index 000000000000..900d930d48a8
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/strncmp_test.c
@@ -0,0 +1,54 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (C) 2021. Huawei Technologies Co., Ltd */
+#include <stdbool.h>
+#include <linux/types.h>
+#include <linux/bpf.h>
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
+
+#define STRNCMP_STR_SZ 8
+
+const char target[STRNCMP_STR_SZ] = "EEEEEEE";
+char str[STRNCMP_STR_SZ];
+int cmp_ret = 0;
+int target_pid = 0;
+
+const char no_str_target[STRNCMP_STR_SZ] = "12345678";
+char writable_target[STRNCMP_STR_SZ];
+unsigned int no_const_str_size = STRNCMP_STR_SZ;
+
+char _license[] SEC("license") = "GPL";
+
+SEC("tp/syscalls/sys_enter_nanosleep")
+int do_strncmp(void *ctx)
+{
+	if ((bpf_get_current_pid_tgid() >> 32) != target_pid)
+		return 0;
+
+	cmp_ret = bpf_strncmp(str, STRNCMP_STR_SZ, target);
+	return 0;
+}
+
+SEC("tp/syscalls/sys_enter_nanosleep")
+int strncmp_bad_not_const_str_size(void *ctx)
+{
+	/* The value of string size is not const, so will fail */
+	cmp_ret = bpf_strncmp(str, no_const_str_size, target);
+	return 0;
+}
+
+SEC("tp/syscalls/sys_enter_nanosleep")
+int strncmp_bad_writable_target(void *ctx)
+{
+	/* Compared target is not read-only, so will fail */
+	cmp_ret = bpf_strncmp(str, STRNCMP_STR_SZ, writable_target);
+	return 0;
+}
+
+SEC("tp/syscalls/sys_enter_nanosleep")
+int strncmp_bad_not_null_term_target(void *ctx)
+{
+	/* Compared target is not null-terminated, so will fail */
+	cmp_ret = bpf_strncmp(str, STRNCMP_STR_SZ, no_str_target);
+	return 0;
+}
-- 
2.29.2

