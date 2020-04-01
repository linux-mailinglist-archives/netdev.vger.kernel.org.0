Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72E8519AA7E
	for <lists+netdev@lfdr.de>; Wed,  1 Apr 2020 13:09:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732453AbgDALJc convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 1 Apr 2020 07:09:32 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:30590 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732435AbgDALJb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Apr 2020 07:09:31 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-349-Cjvd_hw1Otaab7kc2uVQ-Q-1; Wed, 01 Apr 2020 07:09:27 -0400
X-MC-Unique: Cjvd_hw1Otaab7kc2uVQ-Q-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1D4DF800D4E;
        Wed,  1 Apr 2020 11:09:25 +0000 (UTC)
Received: from krava.redhat.com (unknown [10.40.194.72])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DF54C10190A0;
        Wed,  1 Apr 2020 11:09:21 +0000 (UTC)
From:   Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     Wenbo Zhang <ethercflow@gmail.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        David Miller <davem@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        KP Singh <kpsingh@chromium.org>,
        Andrii Nakryiko <andriin@fb.com>, bgregg@netflix.com,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 3/3] selftests/bpf: Add test for d_path helper
Date:   Wed,  1 Apr 2020 13:09:07 +0200
Message-Id: <20200401110907.2669564-4-jolsa@kernel.org>
In-Reply-To: <20200401110907.2669564-1-jolsa@kernel.org>
References: <20200401110907.2669564-1-jolsa@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
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
 .../testing/selftests/bpf/prog_tests/d_path.c | 196 ++++++++++++++++++
 .../testing/selftests/bpf/progs/test_d_path.c |  71 +++++++
 2 files changed, 267 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/d_path.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_d_path.c

diff --git a/tools/testing/selftests/bpf/prog_tests/d_path.c b/tools/testing/selftests/bpf/prog_tests/d_path.c
new file mode 100644
index 000000000000..6b69bfda6c19
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/d_path.c
@@ -0,0 +1,196 @@
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
+static struct d_path_test_data {
+	pid_t pid;
+	__u32 cnt_stat;
+	__u32 cnt_close;
+	char paths_stat[MAX_EVENT_NUM][MAX_PATH_LEN];
+	char paths_close[MAX_EVENT_NUM][MAX_PATH_LEN];
+} dst;
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
+	const char *prog_name_1 = "fentry/vfs_getattr";
+	const char *prog_name_2 = "fentry/filp_close";
+	const char *obj_file = "test_d_path.o";
+	int err, results_map_fd, duration = 0;
+	struct bpf_program *tp_prog1 = NULL;
+	struct bpf_program *tp_prog2 = NULL;
+	struct bpf_link *tp_link1 = NULL;
+	struct bpf_link *tp_link2 = NULL;
+	struct bpf_object *obj = NULL;
+	const int zero = 0;
+
+	obj = bpf_object__open_file(obj_file, NULL);
+	if (CHECK(IS_ERR(obj), "obj_open_file", "err %ld\n", PTR_ERR(obj)))
+		return;
+
+	err = bpf_object__load(obj);
+	if (CHECK(err, "obj_load", "err %d\n", err))
+		goto cleanup;
+
+	tp_prog1 = bpf_object__find_program_by_title(obj, prog_name_1);
+	if (CHECK(!tp_prog1, "find_tp",
+		  "prog '%s' not found\n", prog_name_1))
+		goto cleanup;
+
+	tp_prog2 = bpf_object__find_program_by_title(obj, prog_name_2);
+	if (CHECK(!tp_prog2, "find_tp",
+		  "prog '%s' not found\n", prog_name_2))
+		goto cleanup;
+
+	tp_link1 = bpf_program__attach_trace(tp_prog1);
+	if (CHECK(IS_ERR(tp_link1), "attach_tp",
+		  "err %ld\n", PTR_ERR(tp_link1))) {
+		tp_link1 = NULL;
+		goto cleanup;
+	}
+
+	tp_link2 = bpf_program__attach_trace(tp_prog2);
+	if (CHECK(IS_ERR(tp_link2), "attach_tp",
+		  "err %ld\n", PTR_ERR(tp_link2))) {
+		tp_link2 = NULL;
+		goto cleanup;
+	}
+
+	results_map_fd = bpf_find_map(__func__, obj, "test_d_p.bss");
+	if (CHECK(results_map_fd < 0, "find_bss_map",
+		  "err %d\n", results_map_fd))
+		goto cleanup;
+
+	dst.pid = getpid();
+	err = bpf_map_update_elem(results_map_fd, &zero, &dst, 0);
+	if (CHECK(err, "update_elem",
+		  "failed to set pid filter: %d\n", err))
+		goto cleanup;
+
+	err = trigger_fstat_events(dst.pid);
+	if (CHECK_FAIL(err < 0))
+		goto cleanup;
+
+	err = bpf_map_lookup_elem(results_map_fd, &zero, &dst);
+	if (CHECK(err, "get_results",
+		  "failed to get results: %d\n", err))
+		goto cleanup;
+
+	for (int i = 0; i < MAX_FILES; i++) {
+		if (i < 3) {
+			CHECK((dst.paths_stat[i][0] == 0), "d_path",
+			      "failed to filter fs [%d]: %s vs %s\n",
+			      i, src.paths[i], dst.paths_stat[i]);
+			CHECK((dst.paths_close[i][0] == 0), "d_path",
+			      "failed to filter fs [%d]: %s vs %s\n",
+			      i, src.paths[i], dst.paths_close[i]);
+		} else {
+			CHECK(strncmp(src.paths[i], dst.paths_stat[i], MAX_PATH_LEN),
+			      "d_path",
+			      "failed to get stat path[%d]: %s vs %s\n",
+			      i, src.paths[i], dst.paths_stat[i]);
+			CHECK(strncmp(src.paths[i], dst.paths_close[i], MAX_PATH_LEN),
+			      "d_path",
+			      "failed to get close path[%d]: %s vs %s\n",
+			      i, src.paths[i], dst.paths_close[i]);
+		}
+	}
+
+cleanup:
+	bpf_link__destroy(tp_link2);
+	bpf_link__destroy(tp_link1);
+	bpf_object__close(obj);
+}
diff --git a/tools/testing/selftests/bpf/progs/test_d_path.c b/tools/testing/selftests/bpf/progs/test_d_path.c
new file mode 100644
index 000000000000..f75c108a5773
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_d_path.c
@@ -0,0 +1,71 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <linux/bpf.h>
+#include <linux/ptrace.h>
+#include <linux/fs.h>
+#include <string.h>
+#include <unistd.h>
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
+#include <linux/fs.h>
+
+#define MAX_PATH_LEN		128
+#define MAX_EVENT_NUM		16
+
+static struct d_path_test_data {
+	pid_t pid;
+	__u32 cnt_stat;
+	__u32 cnt_close;
+	char paths_stat[MAX_EVENT_NUM][MAX_PATH_LEN];
+	char paths_close[MAX_EVENT_NUM][MAX_PATH_LEN];
+} data;
+
+struct path;
+struct kstat;
+
+SEC("fentry/vfs_getattr")
+int BPF_PROG(prog_stat, struct path *path, struct kstat *stat,
+	     __u32 request_mask, unsigned int query_flags)
+{
+	pid_t pid = bpf_get_current_pid_tgid() >> 32;
+
+	if (pid != data.pid)
+		return 0;
+
+	if (data.cnt_stat >= MAX_EVENT_NUM)
+		return 0;
+
+	bpf_d_path(path, data.paths_stat[data.cnt_stat], MAX_PATH_LEN);
+	data.cnt_stat++;
+	return 0;
+}
+
+/*
+ * TODO
+ * I've failed so far to compile the test with <linux/fs.h>
+ * kernel header, so for now adding 'struct file' with f_path
+ * member that has same offset as kernel's file object.
+ */
+struct file {
+	__u64	 foo1;
+	__u64	 foo2;
+	void	*f_path;
+};
+
+SEC("fentry/filp_close")
+int BPF_PROG(prog_close, struct file *file, void *id)
+{
+	pid_t pid = bpf_get_current_pid_tgid() >> 32;
+
+	if (pid != data.pid)
+		return 0;
+
+	if (data.cnt_close >= MAX_EVENT_NUM)
+		return 0;
+
+	bpf_d_path((struct path *) &file->f_path, data.paths_close[data.cnt_close], MAX_PATH_LEN);
+	data.cnt_close++;
+	return 0;
+}
+
+char _license[] SEC("license") = "GPL";
-- 
2.25.2

