Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C0DD46361E
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 15:07:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242023AbhK3OKa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 09:10:30 -0500
Received: from szxga02-in.huawei.com ([45.249.212.188]:27323 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242007AbhK3OKW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 09:10:22 -0500
Received: from dggpeml500025.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4J3PCy4ChqzbjDh;
        Tue, 30 Nov 2021 22:06:54 +0800 (CST)
Received: from huawei.com (10.175.124.27) by dggpeml500025.china.huawei.com
 (7.185.36.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.20; Tue, 30 Nov
 2021 22:07:00 +0800
From:   Hou Tao <houtao1@huawei.com>
To:     Alexei Starovoitov <ast@kernel.org>
CC:     Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <houtao1@huawei.com>
Subject: [PATCH bpf-next 5/5] selftests/bpf: add test cases for bpf_strncmp()
Date:   Tue, 30 Nov 2021 22:22:15 +0800
Message-ID: <20211130142215.1237217-6-houtao1@huawei.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20211130142215.1237217-1-houtao1@huawei.com>
References: <20211130142215.1237217-1-houtao1@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.124.27]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpeml500025.china.huawei.com (7.185.36.35)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Four test cases are added:
(1) ensure the return value is expected
(2) ensure no const size is rejected
(3) ensure writable str is rejected
(4) ensure no null-terminated str is rejected

Signed-off-by: Hou Tao <houtao1@huawei.com>
---
 .../selftests/bpf/prog_tests/test_strncmp.c   | 170 ++++++++++++++++++
 .../selftests/bpf/progs/strncmp_test.c        |  59 ++++++
 2 files changed, 229 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/test_strncmp.c
 create mode 100644 tools/testing/selftests/bpf/progs/strncmp_test.c

diff --git a/tools/testing/selftests/bpf/prog_tests/test_strncmp.c b/tools/testing/selftests/bpf/prog_tests/test_strncmp.c
new file mode 100644
index 000000000000..3ed54b55f96a
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/test_strncmp.c
@@ -0,0 +1,170 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (C) 2021. Huawei Technologies Co., Ltd */
+#include <test_progs.h>
+#include "strncmp_test.skel.h"
+
+static struct strncmp_test *strncmp_test_open_and_disable_autoload(void)
+{
+	struct strncmp_test *skel;
+	struct bpf_program *prog;
+
+	skel = strncmp_test__open();
+	if (libbpf_get_error(skel))
+		return skel;
+
+	bpf_object__for_each_program(prog, skel->obj)
+		bpf_program__set_autoload(prog, false);
+
+	return skel;
+}
+
+static inline int to_tristate_ret(int ret)
+{
+	if (ret > 0)
+		return 1;
+	if (ret < 0)
+		return -1;
+	return 0;
+}
+
+static int trigger_strncmp(const struct strncmp_test *skel)
+{
+	struct timespec wait = {.tv_sec = 0, .tv_nsec = 1};
+
+	nanosleep(&wait, NULL);
+	return to_tristate_ret(skel->bss->cmp_ret);
+}
+
+/*
+ * Compare str and target after making str[i] != target[i].
+ * When exp is -1, make str[i] < target[i] and delta is -1.
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
+	int err, got;
+
+	skel = strncmp_test_open_and_disable_autoload();
+	if (!ASSERT_OK_PTR(skel, "strncmp_test open"))
+		return;
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
+	int err;
+
+	skel = strncmp_test_open_and_disable_autoload();
+	if (!ASSERT_OK_PTR(skel, "strncmp_test open"))
+		return;
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
+	int err;
+
+	skel = strncmp_test_open_and_disable_autoload();
+	if (!ASSERT_OK_PTR(skel, "strncmp_test open"))
+		return;
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
+	int err;
+
+	skel = strncmp_test_open_and_disable_autoload();
+	if (!ASSERT_OK_PTR(skel, "strncmp_test open"))
+		return;
+
+	bpf_program__set_autoload(skel->progs.strncmp_bad_not_null_term_target,
+				  true);
+	skel->rodata->target[sizeof(skel->rodata->target) - 1] = 'A';
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
index 000000000000..8cdf950a0ce1
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/strncmp_test.c
@@ -0,0 +1,59 @@
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
+
+char str[STRNCMP_STR_SZ];
+int cmp_ret = 0;
+int target_pid = 0;
+
+char bad_target[STRNCMP_STR_SZ];
+unsigned int bad_cmp_str_size = STRNCMP_STR_SZ;
+
+char _license[] SEC("license") = "GPL";
+
+static __always_inline bool called_by_target_pid(void)
+{
+	__u32 pid = bpf_get_current_pid_tgid() >> 32;
+
+	return pid == target_pid;
+}
+
+SEC("tp/syscalls/sys_enter_nanosleep")
+int do_strncmp(void *ctx)
+{
+	if (!called_by_target_pid())
+		return 0;
+
+	cmp_ret = bpf_strncmp(str, STRNCMP_STR_SZ, target);
+
+	return 0;
+}
+
+SEC("tp/syscalls/sys_enter_nanosleep")
+int strncmp_bad_not_const_str_size(void *ctx)
+{
+	cmp_ret = bpf_strncmp(str, bad_cmp_str_size, target);
+	return 0;
+}
+
+SEC("tp/syscalls/sys_enter_nanosleep")
+int strncmp_bad_writable_target(void *ctx)
+{
+	cmp_ret = bpf_strncmp(str, STRNCMP_STR_SZ, bad_target);
+	return 0;
+}
+
+SEC("tp/syscalls/sys_enter_nanosleep")
+int strncmp_bad_not_null_term_target(void *ctx)
+{
+	cmp_ret = bpf_strncmp(str, STRNCMP_STR_SZ, target);
+	return 0;
+}
-- 
2.29.2

