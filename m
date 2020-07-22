Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8095422A130
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 23:13:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733025AbgGVVNW convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 22 Jul 2020 17:13:22 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:57079 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1733021AbgGVVNV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 17:13:21 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-91-OUWEx-chNhe75FG3lkmE6w-1; Wed, 22 Jul 2020 17:13:14 -0400
X-MC-Unique: OUWEx-chNhe75FG3lkmE6w-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8E994185BDF3;
        Wed, 22 Jul 2020 21:13:12 +0000 (UTC)
Received: from krava.redhat.com (unknown [10.40.194.40])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8115219C4F;
        Wed, 22 Jul 2020 21:13:09 +0000 (UTC)
From:   Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>
Cc:     Wenbo Zhang <ethercflow@gmail.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>, Martin KaFai Lau <kafai@fb.com>,
        David Miller <davem@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Brendan Gregg <bgregg@netflix.com>,
        Florent Revest <revest@chromium.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH v8 bpf-next 12/13] selftests/bpf: Add test for d_path helper
Date:   Wed, 22 Jul 2020 23:12:22 +0200
Message-Id: <20200722211223.1055107-13-jolsa@kernel.org>
In-Reply-To: <20200722211223.1055107-1-jolsa@kernel.org>
References: <20200722211223.1055107-1-jolsa@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=jolsa@kernel.org
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

The test is doing fstat/close on several fd types,
and verifies we got the d_path helper working on
kernel probes for vfs_getattr/filp_close functions.

Original-patch-by: Wenbo Zhang <ethercflow@gmail.com>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 .../testing/selftests/bpf/prog_tests/d_path.c | 162 ++++++++++++++++++
 .../testing/selftests/bpf/progs/test_d_path.c |  64 +++++++
 2 files changed, 226 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/d_path.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_d_path.c

diff --git a/tools/testing/selftests/bpf/prog_tests/d_path.c b/tools/testing/selftests/bpf/prog_tests/d_path.c
new file mode 100644
index 000000000000..3b8f87fb17d7
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/d_path.c
@@ -0,0 +1,162 @@
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
+			CHECK((bss->rets_stat[i] < 0), "d_path",
+			      "failed to filter fs [%d]: %s vs %s\n",
+			      i, src.paths[i], bss->paths_close[i]);
+			CHECK((bss->rets_close[i] < 0), "d_path",
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
+			/* The d_path helper returns size plus NUL char, hence + 1 */
+			CHECK(bss->rets_stat[i] != strlen(bss->paths_stat[i]) + 1,
+			      "d_path",
+			      "failed to match stat return [%d]: %d vs %zd [%s]\n",
+			      i, bss->rets_stat[i], strlen(bss->paths_stat[i]) + 1,
+			      bss->paths_stat[i]);
+			CHECK(bss->rets_close[i] != strlen(bss->paths_stat[i]) + 1,
+			      "d_path",
+			      "failed to match stat return [%d]: %d vs %zd [%s]\n",
+			      i, bss->rets_close[i], strlen(bss->paths_close[i]) + 1,
+			      bss->paths_stat[i]);
+		}
+	}
+
+cleanup:
+	test_d_path__destroy(skel);
+}
diff --git a/tools/testing/selftests/bpf/progs/test_d_path.c b/tools/testing/selftests/bpf/progs/test_d_path.c
new file mode 100644
index 000000000000..e02dce614256
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_d_path.c
@@ -0,0 +1,64 @@
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
+int rets_stat[MAX_EVENT_NUM];
+int rets_close[MAX_EVENT_NUM];
+
+SEC("fentry/vfs_getattr")
+int BPF_PROG(prog_stat, struct path *path, struct kstat *stat,
+	     __u32 request_mask, unsigned int query_flags)
+{
+	pid_t pid = bpf_get_current_pid_tgid() >> 32;
+	int ret;
+
+	if (pid != my_pid)
+		return 0;
+
+	if (cnt_stat >= MAX_EVENT_NUM)
+		return 0;
+	ret = bpf_d_path(path, paths_stat[cnt_stat], MAX_PATH_LEN);
+
+	/* We need to recheck cnt_stat for verifier. */
+	if (cnt_stat >= MAX_EVENT_NUM)
+		return 0;
+	rets_stat[cnt_stat] = ret;
+
+	cnt_stat++;
+	return 0;
+}
+
+SEC("fentry/filp_close")
+int BPF_PROG(prog_close, struct file *file, void *id)
+{
+	pid_t pid = bpf_get_current_pid_tgid() >> 32;
+	int ret;
+
+	if (pid != my_pid)
+		return 0;
+
+	if (cnt_close >= MAX_EVENT_NUM)
+		return 0;
+	ret = bpf_d_path(&file->f_path,
+			 paths_close[cnt_close], MAX_PATH_LEN);
+
+	/* We need to recheck cnt_stat for verifier. */
+	if (cnt_close >= MAX_EVENT_NUM)
+		return 0;
+	rets_close[cnt_close] = ret;
+
+	cnt_close++;
+	return 0;
+}
+
+char _license[] SEC("license") = "GPL";
-- 
2.25.4

