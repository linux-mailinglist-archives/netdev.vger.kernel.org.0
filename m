Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D7E5446E05
	for <lists+netdev@lfdr.de>; Sat,  6 Nov 2021 14:13:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233710AbhKFNP6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Nov 2021 09:15:58 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:15369 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230463AbhKFNP5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Nov 2021 09:15:57 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Hmd8p6bGPz90fj;
        Sat,  6 Nov 2021 21:12:58 +0800 (CST)
Received: from dggpeml500025.china.huawei.com (7.185.36.35) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Sat, 6 Nov 2021 21:13:10 +0800
Received: from huawei.com (10.175.124.27) by dggpeml500025.china.huawei.com
 (7.185.36.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.15; Sat, 6 Nov
 2021 21:13:04 +0800
From:   Hou Tao <houtao1@huawei.com>
To:     Alexei Starovoitov <ast@kernel.org>
CC:     Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        Song Liu <songliubraving@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "Andrii Nakryiko" <andrii@kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <houtao1@huawei.com>
Subject: [RFC PATCH bpf-next 2/2] selftests/bpf: add benchmark bpf_strcmp
Date:   Sat, 6 Nov 2021 21:28:22 +0800
Message-ID: <20211106132822.1396621-3-houtao1@huawei.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20211106132822.1396621-1-houtao1@huawei.com>
References: <20211106132822.1396621-1-houtao1@huawei.com>
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

The benchmark runs a loop 5000 times. In the loop it reads the file name
from kprobe argument into stack by using bpf_probe_read_kernel_str(),
and compares the file name with a target character or string.

Three cases are compared: only compare one character, compare the whole
string by a home-made strncmp() and compare the whole string by
bpf_strcmp().

The following is the result:

x86-64 host:

one character: 2613499 ns
whole str by strncmp: 2920348 ns
whole str by helper: 2779332 ns

arm64 host:

one character: 3898867 ns
whole str by strncmp: 4396787 ns
whole str by helper: 3968113 ns

Compared with home-made strncmp, the performance of bpf_strncmp helper
improves 80% under x86-64 and 600% under arm64. The big performance win
on arm64 may comes from its arch-optimized strncmp().

Signed-off-by: Hou Tao <houtao1@huawei.com>
---
 .../bpf/prog_tests/test_strncmp_helper.c      |  75 ++++++++++++
 .../selftests/bpf/progs/strncmp_helper.c      | 109 ++++++++++++++++++
 2 files changed, 184 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/test_strncmp_helper.c
 create mode 100644 tools/testing/selftests/bpf/progs/strncmp_helper.c

diff --git a/tools/testing/selftests/bpf/prog_tests/test_strncmp_helper.c b/tools/testing/selftests/bpf/prog_tests/test_strncmp_helper.c
new file mode 100644
index 000000000000..1b48ef3402ff
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/test_strncmp_helper.c
@@ -0,0 +1,75 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (C) 2021. Huawei Technologies Co., Ltd */
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <unistd.h>
+#include <fcntl.h>
+#include <time.h>
+#include <test_progs.h>
+
+#include "strncmp_helper.skel.h"
+
+static void run_strncmp_bench(struct strncmp_helper *skel, const char *name,
+			      int fd, int loop)
+{
+	struct timespec begin, end;
+	struct stat stat;
+	double nsecs;
+	int i;
+
+	skel->bss->equal = 0;
+	clock_gettime(CLOCK_MONOTONIC, &begin);
+	for (i = 0; i < loop; i++)
+		fstat(fd, &stat);
+	clock_gettime(CLOCK_MONOTONIC, &end);
+
+	nsecs = (end.tv_sec - begin.tv_sec) * 1e9 + (end.tv_nsec - begin.tv_nsec);
+	fprintf(stdout, "%s: loop %d nsecs %.0f\n", name, loop, nsecs);
+	fprintf(stdout, "equal nr %u\n", skel->bss->equal);
+}
+
+void test_test_strncmp_helper(void)
+{
+	const char *fpath = "/tmp/1234123412341234123412341234123412341234";
+	struct strncmp_helper *skel;
+	struct bpf_link *link;
+	int fd, loop;
+
+	skel = strncmp_helper__open_and_load();
+	if (!ASSERT_OK_PTR(skel, "helper load"))
+		return;
+
+	fd = open(fpath, O_CREAT | O_RDONLY, 0644);
+	if (!ASSERT_GE(fd, 0, "create file"))
+		goto close_prog;
+
+	loop = 5000;
+	skel->bss->pid = getpid();
+
+	link = bpf_program__attach(skel->progs.vfs_getattr_nocmp);
+	if (!ASSERT_EQ(libbpf_get_error(link), 0, "attach nocmp"))
+		goto clean_file;
+
+	run_strncmp_bench(skel, "nocmp", fd, loop);
+	bpf_link__destroy(link);
+
+	link = bpf_program__attach(skel->progs.vfs_getattr_cmp);
+	if (!ASSERT_EQ(libbpf_get_error(link), 0, "attach cmp"))
+		goto clean_file;
+
+	run_strncmp_bench(skel, "cmp", fd, loop);
+	bpf_link__destroy(link);
+
+	link = bpf_program__attach(skel->progs.vfs_getattr_cmp_v2);
+	if (!ASSERT_EQ(libbpf_get_error(link), 0, "attach cmp_v2"))
+		goto clean_file;
+
+	run_strncmp_bench(skel, "cmp_v2", fd, loop);
+	bpf_link__destroy(link);
+
+clean_file:
+	close(fd);
+	unlink(fpath);
+close_prog:
+	strncmp_helper__destroy(skel);
+}
diff --git a/tools/testing/selftests/bpf/progs/strncmp_helper.c b/tools/testing/selftests/bpf/progs/strncmp_helper.c
new file mode 100644
index 000000000000..f212c1f50099
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/strncmp_helper.c
@@ -0,0 +1,109 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (C) 2021. Huawei Technologies Co., Ltd */
+#include <linux/types.h>
+#include <linux/ptrace.h>
+#include <linux/bpf.h>
+#include <bpf/bpf_core_read.h>
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
+
+#define TARGET_FILE_NAME "1234123412341234123412341234123412341234"
+
+char _license[] SEC("license") = "GPL";
+
+__u32 pid = 0;
+__u32 equal = 0;
+
+struct qstr {
+	const char *name;
+} __attribute__((preserve_access_index));
+
+struct dentry {
+	struct qstr d_name;
+} __attribute__((preserve_access_index));
+
+struct path {
+	struct dentry *dentry;
+} __attribute__((preserve_access_index));
+
+static __always_inline int read_file_name(const struct path *path, char *buf,
+					  unsigned int len)
+{
+	const char *name;
+	int err;
+
+	if ((bpf_get_current_pid_tgid() >> 32) != pid)
+		return -1;
+
+	name = BPF_CORE_READ(path, dentry, d_name.name);
+	err = bpf_probe_read_kernel_str(buf, len, name);
+	if (err <= 0)
+		return -1;
+
+	return err;
+}
+
+static __always_inline int local_strncmp(const char *s1, const char *s2,
+					 unsigned int sz)
+{
+	int ret = 0;
+	unsigned int i;
+
+	for (i = 0; i < sz; i++) {
+		ret = s1[i] - s2[i];
+		if (ret || !s1[i])
+			break;
+	}
+
+	return ret;
+}
+
+SEC("kprobe/vfs_getattr")
+int BPF_KPROBE(vfs_getattr_nocmp, const struct path *path)
+{
+	char buf[64] = {0};
+	int err;
+
+	err = read_file_name(path, buf, sizeof(buf));
+	if (err < 0)
+		return 0;
+
+	if (buf[0] == '1')
+		equal++;
+
+	return 0;
+}
+
+SEC("kprobe/vfs_getattr")
+int BPF_KPROBE(vfs_getattr_cmp, const struct path *path)
+{
+	char buf[64] = {0};
+	int err;
+
+	err = read_file_name(path, buf, sizeof(buf));
+	if (err < 0)
+		return 0;
+
+	err = local_strncmp(TARGET_FILE_NAME, buf, sizeof(buf));
+	if (!err)
+		equal++;
+
+	return 0;
+}
+
+SEC("kprobe/vfs_getattr")
+int BPF_KPROBE(vfs_getattr_cmp_v2, const struct path *path)
+{
+	char buf[64] = {0};
+	int err;
+
+	err = read_file_name(path, buf, sizeof(buf));
+	if (err < 0)
+		return 0;
+
+	err = bpf_strncmp(TARGET_FILE_NAME, buf, sizeof(buf));
+	if (!err)
+		equal++;
+
+	return 0;
+}
-- 
2.29.2

