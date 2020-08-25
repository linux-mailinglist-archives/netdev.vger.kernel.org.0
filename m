Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE6AB251FDA
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 21:22:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726968AbgHYTWl convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 25 Aug 2020 15:22:41 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:56708 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726090AbgHYTWh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Aug 2020 15:22:37 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-435-1uoXkRgrNxu5QqLw8H2b3Q-1; Tue, 25 Aug 2020 15:22:29 -0400
X-MC-Unique: 1uoXkRgrNxu5QqLw8H2b3Q-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 52C0551B1;
        Tue, 25 Aug 2020 19:22:27 +0000 (UTC)
Received: from krava.redhat.com (unknown [10.40.192.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9FEBE19C4F;
        Tue, 25 Aug 2020 19:22:24 +0000 (UTC)
From:   Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     Wenbo Zhang <ethercflow@gmail.com>,
        Andrii Nakryiko <andriin@fb.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>
Subject: [PATCH v12 bpf-next 13/14] selftests/bpf: Add test for d_path helper
Date:   Tue, 25 Aug 2020 21:21:23 +0200
Message-Id: <20200825192124.710397-14-jolsa@kernel.org>
In-Reply-To: <20200825192124.710397-1-jolsa@kernel.org>
References: <20200825192124.710397-1-jolsa@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=jolsa@kernel.org
X-Mimecast-Spam-Score: 0.001
X-Mimecast-Originator: kernel.org
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding test for d_path helper which is pretty much
copied from Wenbo Zhang's test for bpf_get_fd_path,
which never made it in.

The test is doing fstat/close on several fd types,
and verifies we got the d_path helper working on
kernel probes for vfs_getattr/filp_close functions.

Original-patch-by: Wenbo Zhang <ethercflow@gmail.com>
Acked-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 .../testing/selftests/bpf/prog_tests/d_path.c | 147 ++++++++++++++++++
 .../testing/selftests/bpf/progs/test_d_path.c |  58 +++++++
 2 files changed, 205 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/d_path.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_d_path.c

diff --git a/tools/testing/selftests/bpf/prog_tests/d_path.c b/tools/testing/selftests/bpf/prog_tests/d_path.c
new file mode 100644
index 000000000000..058765da17e6
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/d_path.c
@@ -0,0 +1,147 @@
+// SPDX-License-Identifier: GPL-2.0
+#define _GNU_SOURCE
+#include <test_progs.h>
+#include <sys/stat.h>
+#include <linux/sched.h>
+#include <sys/syscall.h>
+
+#define MAX_PATH_LEN		128
+#define MAX_FILES		7
+
+#include "test_d_path.skel.h"
+
+static int duration;
+
+static struct {
+	__u32 cnt;
+	char paths[MAX_FILES][MAX_PATH_LEN];
+} src;
+
+static int set_pathname(int fd, pid_t pid)
+{
+	char buf[MAX_PATH_LEN];
+
+	snprintf(buf, MAX_PATH_LEN, "/proc/%d/fd/%d", pid, fd);
+	return readlink(buf, src.paths[src.cnt++], MAX_PATH_LEN);
+}
+
+static int trigger_fstat_events(pid_t pid)
+{
+	int sockfd = -1, procfd = -1, devfd = -1;
+	int localfd = -1, indicatorfd = -1;
+	int pipefd[2] = { -1, -1 };
+	struct stat fileStat;
+	int ret = -1;
+
+	/* unmountable pseudo-filesystems */
+	if (CHECK(pipe(pipefd) < 0, "trigger", "pipe failed\n"))
+		return ret;
+	/* unmountable pseudo-filesystems */
+	sockfd = socket(AF_INET, SOCK_STREAM, 0);
+	if (CHECK(sockfd < 0, "trigger", "scoket failed\n"))
+		goto out_close;
+	/* mountable pseudo-filesystems */
+	procfd = open("/proc/self/comm", O_RDONLY);
+	if (CHECK(procfd < 0, "trigger", "open /proc/self/comm failed\n"))
+		goto out_close;
+	devfd = open("/dev/urandom", O_RDONLY);
+	if (CHECK(devfd < 0, "trigger", "open /dev/urandom failed\n"))
+		goto out_close;
+	localfd = open("/tmp/d_path_loadgen.txt", O_CREAT | O_RDONLY);
+	if (CHECK(localfd < 0, "trigger", "open /tmp/d_path_loadgen.txt failed\n"))
+		goto out_close;
+	/* bpf_d_path will return path with (deleted) */
+	remove("/tmp/d_path_loadgen.txt");
+	indicatorfd = open("/tmp/", O_PATH);
+	if (CHECK(indicatorfd < 0, "trigger", "open /tmp/ failed\n"))
+		goto out_close;
+
+	ret = set_pathname(pipefd[0], pid);
+	if (CHECK(ret < 0, "trigger", "set_pathname failed for pipe[0]\n"))
+		goto out_close;
+	ret = set_pathname(pipefd[1], pid);
+	if (CHECK(ret < 0, "trigger", "set_pathname failed for pipe[1]\n"))
+		goto out_close;
+	ret = set_pathname(sockfd, pid);
+	if (CHECK(ret < 0, "trigger", "set_pathname failed for socket\n"))
+		goto out_close;
+	ret = set_pathname(procfd, pid);
+	if (CHECK(ret < 0, "trigger", "set_pathname failed for proc\n"))
+		goto out_close;
+	ret = set_pathname(devfd, pid);
+	if (CHECK(ret < 0, "trigger", "set_pathname failed for dev\n"))
+		goto out_close;
+	ret = set_pathname(localfd, pid);
+	if (CHECK(ret < 0, "trigger", "set_pathname failed for file\n"))
+		goto out_close;
+	ret = set_pathname(indicatorfd, pid);
+	if (CHECK(ret < 0, "trigger", "set_pathname failed for dir\n"))
+		goto out_close;
+
+	/* triggers vfs_getattr */
+	fstat(pipefd[0], &fileStat);
+	fstat(pipefd[1], &fileStat);
+	fstat(sockfd, &fileStat);
+	fstat(procfd, &fileStat);
+	fstat(devfd, &fileStat);
+	fstat(localfd, &fileStat);
+	fstat(indicatorfd, &fileStat);
+
+out_close:
+	/* triggers filp_close */
+	close(pipefd[0]);
+	close(pipefd[1]);
+	close(sockfd);
+	close(procfd);
+	close(devfd);
+	close(localfd);
+	close(indicatorfd);
+	return ret;
+}
+
+void test_d_path(void)
+{
+	struct test_d_path__bss *bss;
+	struct test_d_path *skel;
+	int err;
+
+	skel = test_d_path__open_and_load();
+	if (CHECK(!skel, "setup", "d_path skeleton failed\n"))
+		goto cleanup;
+
+	err = test_d_path__attach(skel);
+	if (CHECK(err, "setup", "attach failed: %d\n", err))
+		goto cleanup;
+
+	bss = skel->bss;
+	bss->my_pid = getpid();
+
+	err = trigger_fstat_events(bss->my_pid);
+	if (err < 0)
+		goto cleanup;
+
+	for (int i = 0; i < MAX_FILES; i++) {
+		CHECK(strncmp(src.paths[i], bss->paths_stat[i], MAX_PATH_LEN),
+		      "check",
+		      "failed to get stat path[%d]: %s vs %s\n",
+		      i, src.paths[i], bss->paths_stat[i]);
+		CHECK(strncmp(src.paths[i], bss->paths_close[i], MAX_PATH_LEN),
+		      "check",
+		      "failed to get close path[%d]: %s vs %s\n",
+		      i, src.paths[i], bss->paths_close[i]);
+		/* The d_path helper returns size plus NUL char, hence + 1 */
+		CHECK(bss->rets_stat[i] != strlen(bss->paths_stat[i]) + 1,
+		      "check",
+		      "failed to match stat return [%d]: %d vs %zd [%s]\n",
+		      i, bss->rets_stat[i], strlen(bss->paths_stat[i]) + 1,
+		      bss->paths_stat[i]);
+		CHECK(bss->rets_close[i] != strlen(bss->paths_stat[i]) + 1,
+		      "check",
+		      "failed to match stat return [%d]: %d vs %zd [%s]\n",
+		      i, bss->rets_close[i], strlen(bss->paths_close[i]) + 1,
+		      bss->paths_stat[i]);
+	}
+
+cleanup:
+	test_d_path__destroy(skel);
+}
diff --git a/tools/testing/selftests/bpf/progs/test_d_path.c b/tools/testing/selftests/bpf/progs/test_d_path.c
new file mode 100644
index 000000000000..61f007855649
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_d_path.c
@@ -0,0 +1,58 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include "vmlinux.h"
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
+
+#define MAX_PATH_LEN		128
+#define MAX_FILES		7
+
+pid_t my_pid = 0;
+__u32 cnt_stat = 0;
+__u32 cnt_close = 0;
+char paths_stat[MAX_FILES][MAX_PATH_LEN] = {};
+char paths_close[MAX_FILES][MAX_PATH_LEN] = {};
+int rets_stat[MAX_FILES] = {};
+int rets_close[MAX_FILES] = {};
+
+SEC("fentry/vfs_getattr")
+int BPF_PROG(prog_stat, struct path *path, struct kstat *stat,
+	     __u32 request_mask, unsigned int query_flags)
+{
+	pid_t pid = bpf_get_current_pid_tgid() >> 32;
+	__u32 cnt = cnt_stat;
+	int ret;
+
+	if (pid != my_pid)
+		return 0;
+
+	if (cnt >= MAX_FILES)
+		return 0;
+	ret = bpf_d_path(path, paths_stat[cnt], MAX_PATH_LEN);
+
+	rets_stat[cnt] = ret;
+	cnt_stat++;
+	return 0;
+}
+
+SEC("fentry/filp_close")
+int BPF_PROG(prog_close, struct file *file, void *id)
+{
+	pid_t pid = bpf_get_current_pid_tgid() >> 32;
+	__u32 cnt = cnt_close;
+	int ret;
+
+	if (pid != my_pid)
+		return 0;
+
+	if (cnt >= MAX_FILES)
+		return 0;
+	ret = bpf_d_path(&file->f_path,
+			 paths_close[cnt], MAX_PATH_LEN);
+
+	rets_close[cnt] = ret;
+	cnt_close++;
+	return 0;
+}
+
+char _license[] SEC("license") = "GPL";
-- 
2.25.4

