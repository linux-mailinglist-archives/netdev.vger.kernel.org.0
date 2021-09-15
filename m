Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA42840BE25
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 05:24:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236144AbhIODZR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 23:25:17 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:16203 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229758AbhIODZP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Sep 2021 23:25:15 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4H8QWz0GNGz1DH0s;
        Wed, 15 Sep 2021 11:22:55 +0800 (CST)
Received: from dggpeml500025.china.huawei.com (7.185.36.35) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 15 Sep 2021 11:23:52 +0800
Received: from huawei.com (10.175.124.27) by dggpeml500025.china.huawei.com
 (7.185.36.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.8; Wed, 15 Sep
 2021 11:23:52 +0800
From:   Hou Tao <houtao1@huawei.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <houtao1@huawei.com>
Subject: [RFC PATCH bpf-next 3/3] selftests/bpf: add test for BPF STRUCT_OPS
Date:   Wed, 15 Sep 2021 11:37:53 +0800
Message-ID: <20210915033753.1201597-4-houtao1@huawei.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210915033753.1201597-1-houtao1@huawei.com>
References: <20210915033753.1201597-1-houtao1@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.124.27]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpeml500025.china.huawei.com (7.185.36.35)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add two test cases for BPF STRUCT_OPS: one to check the return
value of BPF_PROG_TYPE_STRUCT_OPS is returned, another to check
the returned value through output parameter is expected.

Signed-off-by: Hou Tao <houtao1@huawei.com>
---
 .../selftests/bpf/prog_tests/bpf_dummy_ops.c  | 95 +++++++++++++++++++
 .../selftests/bpf/progs/bpf_dummy_ops.c       | 34 +++++++
 2 files changed, 129 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/bpf_dummy_ops.c
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_dummy_ops.c

diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_dummy_ops.c b/tools/testing/selftests/bpf/prog_tests/bpf_dummy_ops.c
new file mode 100644
index 000000000000..d9a45579c716
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/bpf_dummy_ops.c
@@ -0,0 +1,95 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (C) 2021. Huawei Technologies Co., Ltd */
+#include <linux/err.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <fcntl.h>
+#include <unistd.h>
+#include <stdlib.h>
+#include <assert.h>
+#include <string.h>
+#include <errno.h>
+#include <test_progs.h>
+
+#include "bpf_dummy_ops.skel.h"
+
+#define OPS_CTL_CMD_SIZE 64
+
+static void do_ctl(const char *cmd)
+{
+	int duration = 0;
+	int fd;
+	size_t len;
+	ssize_t wr;
+
+	fd = open("/sys/kernel/bpf_test/dummy_ops_ctl", O_WRONLY);
+	if (CHECK(fd < 0, "open", "open errno %d", errno))
+		goto out;
+
+	len = strlen(cmd);
+	wr = write(fd, cmd, len);
+	if (CHECK(wr != len, "write", "write cmd %s errno %d", cmd, errno))
+		goto out;
+out:
+	if (fd >= 0)
+		close(fd);
+}
+
+static void test_ret_value(void)
+{
+	int duration = 0;
+	struct bpf_dummy_ops *skel;
+	struct bpf_link *link;
+	char cmd[OPS_CTL_CMD_SIZE];
+
+	skel = bpf_dummy_ops__open_and_load();
+	if (CHECK(!skel, "bpf_dummy_ops__open_and_load", "failed\n"))
+		return;
+
+	skel->bss->init_ret = 1024;
+	link = bpf_map__attach_struct_ops(skel->maps.dummy);
+	if (!ASSERT_OK_PTR(link, "bpf_map__attach_struct_ops"))
+		goto out;
+
+	snprintf(cmd, sizeof(cmd), "init_1 %d", skel->bss->init_ret);
+	do_ctl(cmd);
+out:
+	bpf_link__destroy(link);
+	bpf_dummy_ops__destroy(skel);
+}
+
+static void test_ret_by_ptr(void)
+{
+	int duration = 0;
+	struct bpf_dummy_ops *skel;
+	struct bpf_link *link;
+	char cmd[OPS_CTL_CMD_SIZE];
+
+	skel = bpf_dummy_ops__open_and_load();
+	if (CHECK(!skel, "bpf_dummy_ops__open_and_load", "failed\n"))
+		return;
+
+	skel->bss->state_val = 0x5a;
+	link = bpf_map__attach_struct_ops(skel->maps.dummy);
+	if (!ASSERT_OK_PTR(link, "bpf_map__attach_struct_ops"))
+		goto out;
+
+	snprintf(cmd, sizeof(cmd), "init_2 %d", skel->bss->state_val);
+	do_ctl(cmd);
+out:
+	bpf_link__destroy(link);
+	bpf_dummy_ops__destroy(skel);
+}
+
+void test_bpf_dummy_ops(void)
+{
+	if (!env.has_testmod) {
+		test__skip();
+		return;
+	}
+
+	if (test__start_subtest("ret_value"))
+		test_ret_value();
+	if (test__start_subtest("ret_by_ptr"))
+		test_ret_by_ptr();
+}
diff --git a/tools/testing/selftests/bpf/progs/bpf_dummy_ops.c b/tools/testing/selftests/bpf/progs/bpf_dummy_ops.c
new file mode 100644
index 000000000000..e414532b3fc0
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/bpf_dummy_ops.c
@@ -0,0 +1,34 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (C) 2021. Huawei Technologies Co., Ltd */
+#include <stddef.h>
+#include <linux/bpf.h>
+#include <linux/types.h>
+#include <linux/stddef.h>
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
+
+struct bpf_dummy_ops_state {
+	int val;
+};
+
+struct bpf_dummy_ops {
+	int (*init)(void);
+};
+
+int state_val = 0;
+int init_ret = 0;
+
+SEC("struct_ops/dummy_ops_init")
+int BPF_PROG(dummy_ops_init, struct bpf_dummy_ops_state *state)
+{
+	if (state)
+		state->val = state_val;
+	return init_ret;
+}
+
+SEC(".struct_ops")
+struct bpf_dummy_ops dummy = {
+	.init = (void *)dummy_ops_init,
+};
+
+char _license[] SEC("license") = "GPL";
-- 
2.29.2

