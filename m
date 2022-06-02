Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4196753BAE3
	for <lists+netdev@lfdr.de>; Thu,  2 Jun 2022 16:40:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236103AbiFBOjn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jun 2022 10:39:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235985AbiFBOje (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jun 2022 10:39:34 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D707828187A;
        Thu,  2 Jun 2022 07:39:32 -0700 (PDT)
Received: from fraeml714-chm.china.huawei.com (unknown [172.18.147.206])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4LDTCZ6DGSz6H6hX;
        Thu,  2 Jun 2022 22:38:34 +0800 (CST)
Received: from roberto-ThinkStation-P620.huawei.com (10.204.63.22) by
 fraeml714-chm.china.huawei.com (10.206.15.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 2 Jun 2022 16:39:30 +0200
From:   Roberto Sassu <roberto.sassu@huawei.com>
To:     <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        <kpsingh@kernel.org>
CC:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kselftest@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Roberto Sassu <roberto.sassu@huawei.com>
Subject: [PATCH v2 9/9] selftests/bpf: Add map access tests
Date:   Thu, 2 Jun 2022 16:37:48 +0200
Message-ID: <20220602143748.673971-10-roberto.sassu@huawei.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220602143748.673971-1-roberto.sassu@huawei.com>
References: <20220602143748.673971-1-roberto.sassu@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.204.63.22]
X-ClientProxiedBy: lhreml754-chm.china.huawei.com (10.201.108.204) To
 fraeml714-chm.china.huawei.com (10.206.15.33)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add some tests to ensure that read-like operations can be performed on a
write-protected map, and that write-like operations fail with a read file
descriptor.

Do the tests programmatically, with the new functions
bpf_map_get_fd_by_id_flags() and bpf_obj_get_flags(), added to libbpf, and
with the bpftool binary.

Also ensure that map search by name works when there is a write-protected
map. Before, iteration over existing maps stopped due to not being able
to get a file descriptor with full permissions.

Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
---
 .../bpf/prog_tests/test_map_check_access.c    | 264 ++++++++++++++++++
 .../selftests/bpf/progs/map_check_access.c    |  65 +++++
 2 files changed, 329 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/test_map_check_access.c
 create mode 100644 tools/testing/selftests/bpf/progs/map_check_access.c

diff --git a/tools/testing/selftests/bpf/prog_tests/test_map_check_access.c b/tools/testing/selftests/bpf/prog_tests/test_map_check_access.c
new file mode 100644
index 000000000000..20ccadcdf10f
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/test_map_check_access.c
@@ -0,0 +1,264 @@
+// SPDX-License-Identifier: GPL-2.0
+
+/*
+ * Copyright (C) 2022 Huawei Technologies Duesseldorf GmbH
+ *
+ * Author: Roberto Sassu <roberto.sassu@huawei.com>
+ */
+
+#include <test_progs.h>
+
+#include "map_check_access.skel.h"
+
+#define PINNED_MAP_PATH "/sys/fs/bpf/test_map_check_access_map"
+#define BPFTOOL_PATH "./tools/build/bpftool/bpftool"
+
+enum check_types { CHECK_NONE, CHECK_PINNED, CHECK_METADATA };
+
+static int populate_argv(char *argv[], int max_args, char *cmdline)
+{
+	char *arg;
+	int i = 0;
+
+	argv[i++] = BPFTOOL_PATH;
+
+	while ((arg = strsep(&cmdline, " "))) {
+		if (i == max_args - 1)
+			break;
+
+		argv[i++] = arg;
+	}
+
+	argv[i] = NULL;
+	return i;
+}
+
+static void restore_cmdline(char *argv[], int num_args)
+{
+	int i;
+
+	for (i = 1; i < num_args - 1; i++)
+		argv[i][strlen(argv[i])] = ' ';
+}
+
+static int _run_bpftool(char *cmdline, enum check_types check)
+{
+	char *argv[20];
+	char output[1024];
+	int ret, fd[2], num_args, child_pid, child_status;
+
+	num_args = populate_argv(argv, ARRAY_SIZE(argv), cmdline);
+
+	ret = pipe(fd);
+	if (ret < 0)
+		return ret;
+
+	child_pid = fork();
+	if (child_pid == 0) {
+		close(fd[0]);
+		close(STDOUT_FILENO);
+		close(STDERR_FILENO);
+
+		ret = dup2(fd[1], STDOUT_FILENO);
+		if (ret < 0) {
+			close(fd[1]);
+			exit(errno);
+		}
+
+		execv(BPFTOOL_PATH, argv);
+		close(fd[1]);
+		exit(errno);
+	} else if (child_pid > 0) {
+		close(fd[1]);
+
+		restore_cmdline(argv, num_args);
+
+		waitpid(child_pid, &child_status, 0);
+		if (WEXITSTATUS(child_status)) {
+			close(fd[0]);
+			return WEXITSTATUS(child_status);
+		}
+
+		ret = read(fd[0], output, sizeof(output) - 1);
+
+		close(fd[0]);
+
+		if (ret < 0)
+			return ret;
+
+		output[ret] = '\0';
+		ret = 0;
+
+		switch (check) {
+		case CHECK_PINNED:
+			if (!strstr(output, PINNED_MAP_PATH))
+				ret = -ENOENT;
+			break;
+		case CHECK_METADATA:
+			if (!strstr(output, "test_var"))
+				ret = -ENOENT;
+			break;
+		default:
+			break;
+		}
+
+		return ret;
+	}
+
+	close(fd[0]);
+	close(fd[1]);
+
+	return -EINVAL;
+}
+
+void test_test_map_check_access(void)
+{
+	struct map_check_access *skel;
+	struct bpf_map_info info_m = { 0 };
+	struct bpf_map *map;
+	__u32 len = sizeof(info_m);
+	char cmdline[1024];
+	int ret, zero = 0, fd, duration = 0;
+
+	skel = map_check_access__open_and_load();
+	if (CHECK(!skel, "skel", "open_and_load failed\n"))
+		goto close_prog;
+
+	ret = map_check_access__attach(skel);
+	if (CHECK(ret < 0, "skel", "attach failed\n"))
+		goto close_prog;
+
+	map = bpf_object__find_map_by_name(skel->obj, "data_input");
+	if (CHECK(!map, "bpf_object__find_map_by_name", "not found\n"))
+		goto close_prog;
+
+	ret = bpf_obj_get_info_by_fd(bpf_map__fd(map), &info_m, &len);
+	if (CHECK(ret < 0, "bpf_obj_get_info_by_fd", "error: %d\n", ret))
+		goto close_prog;
+
+	fd = bpf_map_get_fd_by_id(info_m.id);
+	if (CHECK(fd >= 0, "bpf_map_get_fd_by_id",
+		  "should fail (map write-protected)\n"))
+		goto close_prog;
+
+	fd = bpf_map_get_fd_by_id_flags(info_m.id, 0);
+	if (CHECK(fd >= 0, "bpf_map_get_fd_by_id_flags",
+		  "should fail (map write-protected)\n"))
+		goto close_prog;
+
+	fd = bpf_map_get_fd_by_id_flags(info_m.id, BPF_F_RDONLY);
+	if (CHECK(fd < 0, "bpf_map_get_fd_by_id_flags", "error: %d\n", fd))
+		goto close_prog;
+
+	ret = bpf_map_lookup_elem(fd, &zero, &len);
+	if (CHECK(ret < 0, "bpf_map_lookup_elem", "error: %d\n", ret)) {
+		close(fd);
+		goto close_prog;
+	}
+
+	ret = bpf_map_update_elem(fd, &zero, &len, BPF_ANY);
+
+	close(fd);
+
+	if (CHECK(!ret, "bpf_map_update_elem",
+		  "should fail (read-only permission)\n"))
+		goto close_prog;
+
+	ret = bpf_map_update_elem(bpf_map__fd(map), &zero, &len, BPF_ANY);
+	if (CHECK(ret < 0, "bpf_map_update_elem", "error: %d\n", ret))
+		goto close_prog;
+
+	ret = bpf_map__pin(map, PINNED_MAP_PATH);
+	if (CHECK(ret < 0, "bpf_map__pin", "error: %d\n", ret))
+		goto close_prog;
+
+	fd = bpf_obj_get_flags(PINNED_MAP_PATH, BPF_F_RDONLY);
+	if (CHECK(fd < 0, "bpf_obj_get_flags", "error: %d\n", fd))
+		goto close_prog;
+
+	close(fd);
+
+	fd = bpf_obj_get_flags(PINNED_MAP_PATH, 0);
+	if (CHECK(fd >= 0, "bpf_obj_get_flags",
+		  "should fail (read-only permission)\n")) {
+		close(fd);
+		goto close_prog;
+	}
+
+	snprintf(cmdline, sizeof(cmdline), "map list");
+	ret = _run_bpftool(cmdline, CHECK_NONE);
+	if (CHECK(ret, "bpftool", "%s - error: %d\n", cmdline, ret))
+		goto close_prog;
+
+	snprintf(cmdline, sizeof(cmdline), "map show name data_input");
+	ret = _run_bpftool(cmdline, CHECK_NONE);
+	if (CHECK(ret, "bpftool", "%s - error: %d\n", cmdline, ret))
+		goto close_prog;
+
+	snprintf(cmdline, sizeof(cmdline), "map -f show pinned %s",
+		 PINNED_MAP_PATH);
+	ret = _run_bpftool(cmdline, CHECK_PINNED);
+	if (CHECK(ret, "bpftool", "%s - error: %d\n", cmdline, ret))
+		goto close_prog;
+
+	unlink(PINNED_MAP_PATH);
+
+	snprintf(cmdline, sizeof(cmdline), "map dump name data_input");
+	ret = _run_bpftool(cmdline, CHECK_NONE);
+	if (CHECK(ret, "bpftool", "%s - error: %d\n", cmdline, ret))
+		goto close_prog;
+
+	snprintf(cmdline, sizeof(cmdline),
+		 "map lookup name data_input key 0 0 0 0");
+	ret = _run_bpftool(cmdline, CHECK_NONE);
+	if (CHECK(ret, "bpftool", "%s - error: %d\n", cmdline, ret))
+		goto close_prog;
+
+	snprintf(cmdline, sizeof(cmdline),
+		 "map update name data_input key 0 0 0 0 value 0 0 0 0");
+	ret = _run_bpftool(cmdline, CHECK_NONE);
+	if (CHECK(!ret, "bpftool",
+		  "%s - should fail (read-only permission)\n", cmdline))
+		goto close_prog;
+
+	snprintf(cmdline, sizeof(cmdline),
+		 "map update name data_input_w key 0 0 0 0 value 0 0 0 0");
+	ret = _run_bpftool(cmdline, CHECK_NONE);
+	if (CHECK(ret, "bpftool", "%s - error: %d\n", cmdline, ret))
+		goto close_prog;
+
+	snprintf(cmdline, sizeof(cmdline), "prog show name check_access");
+	ret = _run_bpftool(cmdline, CHECK_METADATA);
+	if (CHECK(ret, "bpftool", "%s - error: %d\n", cmdline, ret))
+		goto close_prog;
+
+	snprintf(cmdline, sizeof(cmdline), "btf show");
+	ret = _run_bpftool(cmdline, CHECK_NONE);
+	if (CHECK(ret, "bpftool", "%s - error: %d\n", cmdline, ret))
+		goto close_prog;
+
+	snprintf(cmdline, sizeof(cmdline), "btf dump map name data_input");
+	ret = _run_bpftool(cmdline, CHECK_NONE);
+	if (CHECK(ret, "bpftool", "%s - error: %d\n", cmdline, ret))
+		goto close_prog;
+
+	snprintf(cmdline, sizeof(cmdline), "map pin name data_input %s",
+		 PINNED_MAP_PATH);
+	ret = _run_bpftool(cmdline, CHECK_NONE);
+	if (CHECK(ret, "bpftool", "%s - error: %d\n", cmdline, ret))
+		goto close_prog;
+
+	snprintf(cmdline, sizeof(cmdline), "struct_ops show name dummy_2");
+	ret = _run_bpftool(cmdline, CHECK_NONE);
+	if (CHECK(ret, "bpftool", "%s - error: %d\n", cmdline, ret))
+		goto close_prog;
+
+	snprintf(cmdline, sizeof(cmdline), "struct_ops dump name dummy_2");
+	ret = _run_bpftool(cmdline, CHECK_NONE);
+
+	CHECK(ret, "_run_bpftool", "%s - error: %d\n", cmdline, ret);
+
+close_prog:
+	map_check_access__destroy(skel);
+	unlink(PINNED_MAP_PATH);
+}
diff --git a/tools/testing/selftests/bpf/progs/map_check_access.c b/tools/testing/selftests/bpf/progs/map_check_access.c
new file mode 100644
index 000000000000..3e75b1114f79
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/map_check_access.c
@@ -0,0 +1,65 @@
+// SPDX-License-Identifier: GPL-2.0
+
+/*
+ * Copyright (C) 2021. Huawei Technologies Co., Ltd
+ * Copyright (C) 2022 Huawei Technologies Duesseldorf GmbH
+ *
+ * Author: Roberto Sassu <roberto.sassu@huawei.com>
+ */
+
+#include "vmlinux.h"
+#include <errno.h>
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
+
+/* From include/linux/mm.h. */
+#define FMODE_WRITE	0x2
+
+const char bpf_metadata_test_var[] SEC(".rodata") = "test_var";
+
+struct {
+	__uint(type, BPF_MAP_TYPE_ARRAY);
+	__uint(max_entries, 1);
+	__type(key, __u32);
+	__type(value, __u32);
+} data_input SEC(".maps");
+
+struct {
+	__uint(type, BPF_MAP_TYPE_ARRAY);
+	__uint(max_entries, 1);
+	__type(key, __u32);
+	__type(value, __u32);
+} data_input_w SEC(".maps");
+
+char _license[] SEC("license") = "GPL";
+
+SEC("lsm/bpf_map")
+int BPF_PROG(check_access, struct bpf_map *map, fmode_t fmode)
+{
+	if (map != (struct bpf_map *)&data_input)
+		return 0;
+
+	if (fmode & FMODE_WRITE)
+		return -EACCES;
+
+	return 0;
+}
+
+SEC("struct_ops/test_1")
+int BPF_PROG(test_1, struct bpf_dummy_ops_state *state)
+{
+	return 0;
+}
+
+SEC("struct_ops/test_2")
+int BPF_PROG(test_2, struct bpf_dummy_ops_state *state, int a1,
+	     unsigned short a2, char a3, unsigned long a4)
+{
+	return 0;
+}
+
+SEC(".struct_ops")
+struct bpf_dummy_ops dummy_2 = {
+	.test_1 = (void *)test_1,
+	.test_2 = (void *)test_2,
+};
-- 
2.25.1

