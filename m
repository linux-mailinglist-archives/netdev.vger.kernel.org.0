Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54CFB20A822
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 00:14:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407519AbgFYWOL convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 25 Jun 2020 18:14:11 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:38558 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2407510AbgFYWOK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jun 2020 18:14:10 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-356-THOrCUthPSS8F3Y0UWXv8Q-1; Thu, 25 Jun 2020 18:14:05 -0400
X-MC-Unique: THOrCUthPSS8F3Y0UWXv8Q-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4286380400A;
        Thu, 25 Jun 2020 22:14:03 +0000 (UTC)
Received: from krava.redhat.com (unknown [10.40.192.78])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2118379303;
        Thu, 25 Jun 2020 22:13:59 +0000 (UTC)
From:   Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     Wenbo Zhang <ethercflow@gmail.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>, Martin KaFai Lau <kafai@fb.com>,
        David Miller <davem@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Brendan Gregg <bgregg@netflix.com>,
        Florent Revest <revest@chromium.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH v4 bpf-next 13/14] selftests/bpf: Add test for d_path helper
Date:   Fri, 26 Jun 2020 00:13:03 +0200
Message-Id: <20200625221304.2817194-14-jolsa@kernel.org>
In-Reply-To: <20200625221304.2817194-1-jolsa@kernel.org>
References: <20200625221304.2817194-1-jolsa@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Mimecast-Spam-Score: 0
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

I've failed so far to compile the test with <linux/fs.h>
kernel header, so for now adding 'struct file' with f_path
member that has same offset as kernel's file object.

Original-patch-by: Wenbo Zhang <ethercflow@gmail.com>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 .../testing/selftests/bpf/prog_tests/d_path.c | 145 ++++++++++++++++++
 .../testing/selftests/bpf/progs/test_d_path.c |  50 ++++++
 2 files changed, 195 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/d_path.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_d_path.c

diff --git a/tools/testing/selftests/bpf/prog_tests/d_path.c b/tools/testing/selftests/bpf/prog_tests/d_path.c
new file mode 100644
index 000000000000..c0ea45d43634
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/d_path.c
@@ -0,0 +1,145 @@
+// SPDX-License-Identifier: GPL-2.0
+#define _GNU_SOURCE
+#include <test_progs.h>
+#include <sys/stat.h>
+#include <linux/sched.h>
+#include <sys/syscall.h>
+
+#define MAX_PATH_LEN		128
+#define MAX_FILES		7
+#define MAX_EVENT_NUM		16
+
+#include "test_d_path.skel.h"
+
+static struct {
+	__u32 cnt;
+	char paths[MAX_EVENT_NUM][MAX_PATH_LEN];
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
+	if (CHECK_FAIL(pipe(pipefd) < 0))
+		return ret;
+	/* unmountable pseudo-filesystems */
+	sockfd = socket(AF_INET, SOCK_STREAM, 0);
+	if (CHECK_FAIL(sockfd < 0))
+		goto out_close;
+	/* mountable pseudo-filesystems */
+	procfd = open("/proc/self/comm", O_RDONLY);
+	if (CHECK_FAIL(procfd < 0))
+		goto out_close;
+	devfd = open("/dev/urandom", O_RDONLY);
+	if (CHECK_FAIL(devfd < 0))
+		goto out_close;
+	localfd = open("/tmp/d_path_loadgen.txt", O_CREAT | O_RDONLY);
+	if (CHECK_FAIL(localfd < 0))
+		goto out_close;
+	/* bpf_d_path will return path with (deleted) */
+	remove("/tmp/d_path_loadgen.txt");
+	indicatorfd = open("/tmp/", O_PATH);
+	if (CHECK_FAIL(indicatorfd < 0))
+		goto out_close;
+
+	ret = set_pathname(pipefd[0], pid);
+	if (CHECK_FAIL(ret < 0))
+		goto out_close;
+	ret = set_pathname(pipefd[1], pid);
+	if (CHECK_FAIL(ret < 0))
+		goto out_close;
+	ret = set_pathname(sockfd, pid);
+	if (CHECK_FAIL(ret < 0))
+		goto out_close;
+	ret = set_pathname(procfd, pid);
+	if (CHECK_FAIL(ret < 0))
+		goto out_close;
+	ret = set_pathname(devfd, pid);
+	if (CHECK_FAIL(ret < 0))
+		goto out_close;
+	ret = set_pathname(localfd, pid);
+	if (CHECK_FAIL(ret < 0))
+		goto out_close;
+	ret = set_pathname(indicatorfd, pid);
+	if (CHECK_FAIL(ret < 0))
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
+	__u32 duration = 0;
+	int err;
+
+	skel = test_d_path__open_and_load();
+	if (CHECK(!skel, "test_d_path_load", "d_path skeleton failed\n"))
+		goto cleanup;
+
+	err = test_d_path__attach(skel);
+	if (CHECK(err, "modify_return", "attach failed: %d\n", err))
+		goto cleanup;
+
+	bss = skel->bss;
+	bss->my_pid = getpid();
+
+	err = trigger_fstat_events(bss->my_pid);
+	if (CHECK_FAIL(err < 0))
+		goto cleanup;
+
+	for (int i = 0; i < MAX_FILES; i++) {
+		if (i < 3) {
+			CHECK((bss->paths_stat[i][0] == 0), "d_path",
+			      "failed to filter fs [%d]: %s vs %s\n",
+			      i, src.paths[i], bss->paths_stat[i]);
+			CHECK((bss->paths_close[i][0] == 0), "d_path",
+			      "failed to filter fs [%d]: %s vs %s\n",
+			      i, src.paths[i], bss->paths_close[i]);
+		} else {
+			CHECK(strncmp(src.paths[i], bss->paths_stat[i], MAX_PATH_LEN),
+			      "d_path",
+			      "failed to get stat path[%d]: %s vs %s\n",
+			      i, src.paths[i], bss->paths_stat[i]);
+			CHECK(strncmp(src.paths[i], bss->paths_close[i], MAX_PATH_LEN),
+			      "d_path",
+			      "failed to get close path[%d]: %s vs %s\n",
+			      i, src.paths[i], bss->paths_close[i]);
+		}
+	}
+
+cleanup:
+	test_d_path__destroy(skel);
+}
diff --git a/tools/testing/selftests/bpf/progs/test_d_path.c b/tools/testing/selftests/bpf/progs/test_d_path.c
new file mode 100644
index 000000000000..6096aef2bafc
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_d_path.c
@@ -0,0 +1,50 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include "vmlinux.h"
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
+
+#define MAX_PATH_LEN		128
+#define MAX_EVENT_NUM		16
+
+pid_t my_pid;
+__u32 cnt_stat;
+__u32 cnt_close;
+char paths_stat[MAX_EVENT_NUM][MAX_PATH_LEN];
+char paths_close[MAX_EVENT_NUM][MAX_PATH_LEN];
+
+SEC("fentry/vfs_getattr")
+int BPF_PROG(prog_stat, struct path *path, struct kstat *stat,
+	     __u32 request_mask, unsigned int query_flags)
+{
+	pid_t pid = bpf_get_current_pid_tgid() >> 32;
+
+	if (pid != my_pid)
+		return 0;
+
+	if (cnt_stat >= MAX_EVENT_NUM)
+		return 0;
+
+	bpf_d_path(path, paths_stat[cnt_stat], MAX_PATH_LEN);
+	cnt_stat++;
+	return 0;
+}
+
+SEC("fentry/filp_close")
+int BPF_PROG(prog_close, struct file *file, void *id)
+{
+	pid_t pid = bpf_get_current_pid_tgid() >> 32;
+
+	if (pid != my_pid)
+		return 0;
+
+	if (cnt_close >= MAX_EVENT_NUM)
+		return 0;
+
+	bpf_d_path((struct path *) &file->f_path,
+		   paths_close[cnt_close], MAX_PATH_LEN);
+	cnt_close++;
+	return 0;
+}
+
+char _license[] SEC("license") = "GPL";
-- 
2.25.4

