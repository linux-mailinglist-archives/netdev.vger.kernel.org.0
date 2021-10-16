Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6779A43029E
	for <lists+netdev@lfdr.de>; Sat, 16 Oct 2021 14:33:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240443AbhJPMfW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Oct 2021 08:35:22 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:13745 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240424AbhJPMfV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Oct 2021 08:35:21 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4HWjDd6SJNzWh9V;
        Sat, 16 Oct 2021 20:31:29 +0800 (CST)
Received: from dggpeml500025.china.huawei.com (7.185.36.35) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Sat, 16 Oct 2021 20:33:11 +0800
Received: from huawei.com (10.175.124.27) by dggpeml500025.china.huawei.com
 (7.185.36.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.8; Sat, 16 Oct
 2021 20:33:09 +0800
From:   Hou Tao <houtao1@huawei.com>
To:     Alexei Starovoitov <ast@kernel.org>
CC:     Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <houtao1@huawei.com>
Subject: [PATCH bpf-next v2 5/5] selftests/bpf: add test cases for struct_ops prog
Date:   Sat, 16 Oct 2021 20:48:06 +0800
Message-ID: <20211016124806.1547989-6-houtao1@huawei.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20211016124806.1547989-1-houtao1@huawei.com>
References: <20211016124806.1547989-1-houtao1@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.124.27]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpeml500025.china.huawei.com (7.185.36.35)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Running a BPF_PROG_TYPE_STRUCT_OPS prog for dummy_st_ops::test_N()
through bpf_prog_test_run(). Four test cases are added:
(1) attach dummy_st_ops should fail
(2) function return value of bpf_dummy_ops::test_1() is expected
(3) pointer argument of bpf_dummy_ops::test_1() works as expected
(4) multiple arguments passed to bpf_dummy_ops::test_2() are correct

Signed-off-by: Hou Tao <houtao1@huawei.com>
---
 .../selftests/bpf/prog_tests/dummy_st_ops.c   | 114 ++++++++++++++++++
 .../selftests/bpf/progs/dummy_st_ops.c        |  50 ++++++++
 2 files changed, 164 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/dummy_st_ops.c
 create mode 100644 tools/testing/selftests/bpf/progs/dummy_st_ops.c

diff --git a/tools/testing/selftests/bpf/prog_tests/dummy_st_ops.c b/tools/testing/selftests/bpf/prog_tests/dummy_st_ops.c
new file mode 100644
index 000000000000..e59a674b5052
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/dummy_st_ops.c
@@ -0,0 +1,114 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (C) 2021. Huawei Technologies Co., Ltd */
+#include <test_progs.h>
+#include "dummy_st_ops.skel.h"
+
+/* Need to keep consistent with definition in include/linux/bpf.h */
+struct bpf_dummy_ops_state {
+	int val;
+};
+
+static void test_dummy_st_ops_attach(void)
+{
+	struct dummy_st_ops *skel;
+	struct bpf_link *link;
+
+	skel = dummy_st_ops__open_and_load();
+	if (!ASSERT_OK_PTR(skel, "dummy_st_ops_load"))
+		return;
+
+	link = bpf_map__attach_struct_ops(skel->maps.dummy_1);
+	ASSERT_EQ(libbpf_get_error(link), -EOPNOTSUPP, "dummy_st_ops_attach");
+
+	dummy_st_ops__destroy(skel);
+}
+
+static void test_dummy_init_ret_value(void)
+{
+	__u64 args[1] = {0};
+	struct bpf_prog_test_run_attr attr = {
+		.ctx_size_in = sizeof(args),
+		.ctx_in = args,
+	};
+	struct dummy_st_ops *skel;
+	int fd, err;
+
+	skel = dummy_st_ops__open_and_load();
+	if (!ASSERT_OK_PTR(skel, "dummy_st_ops_load"))
+		return;
+
+	fd = bpf_program__fd(skel->progs.test_1);
+	attr.prog_fd = fd;
+	err = bpf_prog_test_run_xattr(&attr);
+	ASSERT_OK(err, "test_run");
+	ASSERT_EQ(attr.retval, 0xf2f3f4f5, "test_ret");
+
+	dummy_st_ops__destroy(skel);
+}
+
+static void test_dummy_init_ptr_arg(void)
+{
+	int exp_retval = 0xbeef;
+	struct bpf_dummy_ops_state in_state = {
+		.val = exp_retval,
+	};
+	__u64 args[1] = {(unsigned long)&in_state};
+	struct bpf_prog_test_run_attr attr = {
+		.ctx_size_in = sizeof(args),
+		.ctx_in = args,
+	};
+	struct dummy_st_ops *skel;
+	int fd, err;
+
+	skel = dummy_st_ops__open_and_load();
+	if (!ASSERT_OK_PTR(skel, "dummy_st_ops_load"))
+		return;
+
+	fd = bpf_program__fd(skel->progs.test_1);
+	attr.prog_fd = fd;
+	err = bpf_prog_test_run_xattr(&attr);
+	ASSERT_OK(err, "test_run");
+	ASSERT_EQ(in_state.val, 0x5a, "test_ptr_ret");
+	ASSERT_EQ(attr.retval, exp_retval, "test_ret");
+
+	dummy_st_ops__destroy(skel);
+}
+
+static void test_dummy_multiple_args(void)
+{
+	__u64 args[5] = {0, -100, 0x8a5f, 'c', 0x1234567887654321ULL};
+	struct bpf_prog_test_run_attr attr = {
+		.ctx_size_in = sizeof(args),
+		.ctx_in = args,
+	};
+	struct dummy_st_ops *skel;
+	int fd, err;
+
+	skel = dummy_st_ops__open_and_load();
+	if (!ASSERT_OK_PTR(skel, "dummy_st_ops_load"))
+		return;
+
+	fd = bpf_program__fd(skel->progs.test_2);
+	attr.prog_fd = fd;
+	err = bpf_prog_test_run_xattr(&attr);
+	ASSERT_OK(err, "test_run");
+	ASSERT_EQ(skel->bss->test_2_args[0], args[0], "arg 0");
+	ASSERT_EQ(skel->bss->test_2_args[1], args[1], "arg 1");
+	ASSERT_EQ(skel->bss->test_2_args[2], args[2], "arg 2");
+	ASSERT_EQ(skel->bss->test_2_args[3], args[3], "arg 3");
+	ASSERT_EQ(skel->bss->test_2_args[4], args[4], "arg 4");
+
+	dummy_st_ops__destroy(skel);
+}
+
+void test_dummy_st_ops(void)
+{
+	if (test__start_subtest("dummy_st_ops_attach"))
+		test_dummy_st_ops_attach();
+	if (test__start_subtest("dummy_init_ret_value"))
+		test_dummy_init_ret_value();
+	if (test__start_subtest("dummy_init_ptr_arg"))
+		test_dummy_init_ptr_arg();
+	if (test__start_subtest("dummy_multiple_args"))
+		test_dummy_multiple_args();
+}
diff --git a/tools/testing/selftests/bpf/progs/dummy_st_ops.c b/tools/testing/selftests/bpf/progs/dummy_st_ops.c
new file mode 100644
index 000000000000..ead87edb75e2
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/dummy_st_ops.c
@@ -0,0 +1,50 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (C) 2021. Huawei Technologies Co., Ltd */
+#include <linux/bpf.h>
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
+
+struct bpf_dummy_ops_state {
+	int val;
+} __attribute__((preserve_access_index));
+
+struct bpf_dummy_ops {
+	int (*test_1)(struct bpf_dummy_ops_state *state);
+	int (*test_2)(struct bpf_dummy_ops_state *state, int a1, unsigned short a2,
+		      char a3, unsigned long a4);
+};
+
+char _license[] SEC("license") = "GPL";
+
+SEC("struct_ops/test_1")
+int BPF_PROG(test_1, struct bpf_dummy_ops_state *state)
+{
+	int ret;
+
+	if (!state)
+		return 0xf2f3f4f5;
+
+	ret = state->val;
+	state->val = 0x5a;
+	return ret;
+}
+
+__u64 test_2_args[5];
+
+SEC("struct_ops/test_2")
+int BPF_PROG(test_2, struct bpf_dummy_ops_state *state, int a1, unsigned short a2,
+	     char a3, unsigned long a4)
+{
+	test_2_args[0] = (unsigned long)state;
+	test_2_args[1] = a1;
+	test_2_args[2] = a2;
+	test_2_args[3] = a3;
+	test_2_args[4] = a4;
+	return 0;
+}
+
+SEC(".struct_ops")
+struct bpf_dummy_ops dummy_1 = {
+	.test_1 = (void *)test_1,
+	.test_2 = (void *)test_2,
+};
-- 
2.29.2

