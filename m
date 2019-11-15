Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF3DBFDF91
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 14:59:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727614AbfKON7x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Nov 2019 08:59:53 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:36913 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727438AbfKON7x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Nov 2019 08:59:53 -0500
Received: by mail-pf1-f194.google.com with SMTP id p24so6729226pfn.4;
        Fri, 15 Nov 2019 05:59:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=3A2MX6HtZFZ1kTf8WxpdKJiidP05Sgi2ukVRpZmmeTU=;
        b=q3lmtRvxYG8uKTV/4nYfWs+WKVi8INMqXtt7m5UV65jupDu7E+JLTSgMoUdHskDybl
         7O8CawhzNR3B7uVxC8CDYIxJFBbF7of/3PhfWm19h8J4JPqRlIaGp+EIWNlfX9Lt0YYj
         g0AyK5lS15cBKnbJ4DzxE8A/omo//fpQXrVaPNMXw3VWHWXZ+9fkt6cdPbBI6DbSYp2D
         IBQs72qsXGisCEZwuuCEY/SeM74/hw4wGyyQOh8dhEzRFBsjDJD/N08Sm5R8+CiYhUOc
         CmjSYitM6j1Q8yof2lTkrZu5LCj27capZ6qpp5L0WTzj2IB4KVivqFienULrU4AenpV2
         +UgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=3A2MX6HtZFZ1kTf8WxpdKJiidP05Sgi2ukVRpZmmeTU=;
        b=bj+Mg+yStZYfWJfm1FB+oQhEYJ9zOQUcZNMOFGPgcrd42GvbMzq0lvqWcKcDsUNwR4
         TJZxby6d86C0AEB02stCEHeYufKQOqn48G5vNGi9za/lacF+eIjst+2xip8zNMelWrN2
         /Kf0ltQv8XT8oca3LZFP3pvk/C3afCb6V24i6RkAmNw7Nhytaizdqr8yEXWt5/ggvHGn
         becGLUj7HYHyxq2zAolQ2Yp88WAZuFYrTU1ub+Su7EipDTwVsuuiuC+9z3bOFApULHUt
         yIU+ppMlTrqUSswwpy+phKgTvOUo52mQinrEPngSik2Yv/CcWxQ7EWFjupx4yTtqHDZq
         bG4Q==
X-Gm-Message-State: APjAAAUk//cIhp4NTuvqalTDJ0m/TP6ix5l0Sq+eTH1hF27TMa4QsVyz
        2Mdoiv+6zn8oM5VhznwVzy9La/SXgBg=
X-Google-Smtp-Source: APXvYqyx8yEFbA1Cxu9RO8t54/rAS25Y6XwAxilVNFSf3IrnE4T55/KHrdA6z7Av5U3DhnQa/mIowA==
X-Received: by 2002:a63:c0a:: with SMTP id b10mr13472041pgl.168.1573826391383;
        Fri, 15 Nov 2019 05:59:51 -0800 (PST)
Received: from ubuntu-18.04-x8664 ([128.1.49.85])
        by smtp.gmail.com with ESMTPSA id u3sm9500299pjn.0.2019.11.15.05.59.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Nov 2019 05:59:51 -0800 (PST)
From:   Wenbo Zhang <ethercflow@gmail.com>
To:     bpf@vger.kernel.org
Cc:     alexei.starovoitov@gmail.com, daniel@iogearbox.net, yhs@fb.com,
        andrii.nakryiko@gmail.com, netdev@vger.kernel.org,
        Wenbo Zhang <ethercflow@gmail.com>
Subject: [PATCH bpf-next v4] selftests/bpf: test for bpf_get_file_path() from raw tracepoint
Date:   Fri, 15 Nov 2019 08:59:01 -0500
Message-Id: <20191115135901.8114-1-ethercflow@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

trace fstat events by raw tracepoint sys_enter:newfstat, and handle events
only produced by test_file_get_path, which call fstat on several different
types of files to test bpf_get_file_path's feature.

v3->v4: addressed Andrii's feedback
- use a set of fd instead of fds array
- use global variables instead of maps (in v3, I mistakenly thought that
the bpf maps are global variables.)
- remove uncessary global variable path_info_index
- remove fd compare as the fstat's order is fixed

v2->v3: addressed Andrii's feedback
- use global data instead of perf_buffer to simplified code

v1->v2: addressed Daniel's feedback
- rename bpf_fd2path to bpf_get_file_path to be consistent with other
helper's names

Signed-off-by: Wenbo Zhang <ethercflow@gmail.com>
---
 .../selftests/bpf/prog_tests/get_file_path.c  | 173 ++++++++++++++++++
 .../selftests/bpf/progs/test_get_file_path.c  |  43 +++++
 2 files changed, 216 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/get_file_path.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_get_file_path.c

diff --git a/tools/testing/selftests/bpf/prog_tests/get_file_path.c b/tools/testing/selftests/bpf/prog_tests/get_file_path.c
new file mode 100644
index 000000000000..446ee4dd20e2
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/get_file_path.c
@@ -0,0 +1,173 @@
+// SPDX-License-Identifier: GPL-2.0
+#define _GNU_SOURCE
+#include <test_progs.h>
+#include <sys/stat.h>
+#include <linux/sched.h>
+#include <sys/syscall.h>
+
+#define MAX_PATH_LEN		128
+#define MAX_FDS			7
+#define MAX_EVENT_NUM		16
+
+static struct file_path_test_data {
+	pid_t pid;
+	__u32 cnt;
+	__u32 fds[MAX_EVENT_NUM];
+	char paths[MAX_EVENT_NUM][MAX_PATH_LEN];
+} src, dst;
+
+static inline int set_pathname(int fd)
+{
+	char buf[MAX_PATH_LEN];
+
+	snprintf(buf, MAX_PATH_LEN, "/proc/%d/fd/%d", src.pid, fd);
+	src.fds[src.cnt] = fd;
+	return readlink(buf, src.paths[src.cnt++], MAX_PATH_LEN);
+}
+
+static int trigger_fstat_events(pid_t pid)
+{
+	int pipefd[2] = { -1, -1 };
+	int sockfd = -1, procfd = -1, devfd = -1;
+	int localfd = -1, indicatorfd = -1;
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
+	localfd = open("/tmp/fd2path_loadgen.txt", O_CREAT|O_RDONLY);
+	if (CHECK_FAIL(localfd < 0))
+		goto out_close;
+	/* bpf_get_file_path will return path with (deleted) */
+	remove("/tmp/fd2path_loadgen.txt");
+	indicatorfd = open("/tmp/", O_PATH);
+	if (CHECK_FAIL(indicatorfd < 0))
+		goto out_close;
+
+	src.pid = pid;
+
+	ret = set_pathname(pipefd[0]);
+	if (CHECK_FAIL(ret < 0))
+		goto out_close;
+	ret = set_pathname(pipefd[1]);
+	if (CHECK_FAIL(ret < 0))
+		goto out_close;
+	ret = set_pathname(sockfd);
+	if (CHECK_FAIL(ret < 0))
+		goto out_close;
+	ret = set_pathname(procfd);
+	if (CHECK_FAIL(ret < 0))
+		goto out_close;
+	ret = set_pathname(devfd);
+	if (CHECK_FAIL(ret < 0))
+		goto out_close;
+	ret = set_pathname(localfd);
+	if (CHECK_FAIL(ret < 0))
+		goto out_close;
+	ret = set_pathname(indicatorfd);
+	if (CHECK_FAIL(ret < 0))
+		goto out_close;
+
+	fstat(pipefd[0], &fileStat);
+	fstat(pipefd[1], &fileStat);
+	fstat(sockfd, &fileStat);
+	fstat(procfd, &fileStat);
+	fstat(devfd, &fileStat);
+	fstat(localfd, &fileStat);
+	fstat(indicatorfd, &fileStat);
+
+out_close:
+	close(indicatorfd);
+	close(localfd);
+	close(devfd);
+	close(procfd);
+	close(sockfd);
+	close(pipefd[1]);
+	close(pipefd[0]);
+
+	return ret;
+}
+
+void test_get_file_path(void)
+{
+	const char *prog_name = "tracepoint/syscalls/sys_enter_newfstat";
+	const char *obj_file = "./test_get_file_path.o";
+	DECLARE_LIBBPF_OPTS(bpf_object_open_opts, opts, );
+	int err, results_map_fd, duration = 0;
+	struct bpf_program *tp_prog = NULL;
+	struct bpf_link *tp_link = NULL;
+	struct bpf_object *obj = NULL;
+	const int zero = 0;
+
+	obj = bpf_object__open_file(obj_file, &opts);
+	if (CHECK(IS_ERR(obj), "obj_open_file", "err %ld\n", PTR_ERR(obj)))
+		return;
+
+	tp_prog = bpf_object__find_program_by_title(obj, prog_name);
+	if (CHECK(!tp_prog, "find_tp",
+		  "prog '%s' not found\n", prog_name))
+		goto cleanup;
+
+	err = bpf_object__load(obj);
+	if (CHECK(err, "obj_load", "err %d\n", err))
+		goto cleanup;
+
+	results_map_fd = bpf_find_map(__func__, obj, "test_get.bss");
+	if (CHECK(results_map_fd < 0, "find_bss_map",
+		  "err %d\n", results_map_fd))
+		goto cleanup;
+
+	tp_link = bpf_program__attach_tracepoint(tp_prog, "syscalls",
+						 "sys_enter_newfstat");
+	if (CHECK(IS_ERR(tp_link), "attach_tp",
+		  "err %ld\n", PTR_ERR(tp_link))) {
+		tp_link = NULL;
+		goto cleanup;
+	}
+
+	dst.pid = syscall(SYS_gettid);
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
+	for (int i = 0; i < MAX_FDS; i++) {
+		if (i < 3) {
+			CHECK((dst.paths[i][0] != '\0'), "get_file_path",
+			       "failed to filter fs [%d]: %u(%s) vs %u(%s)\n",
+			       i, src.fds[i], src.paths[i], dst.fds[i],
+			       dst.paths[i]);
+		} else {
+			err = strncmp(src.paths[i], dst.paths[i], MAX_PATH_LEN);
+			CHECK(err != 0, "get_file_path",
+			       "failed to get path[%d]: %u(%s) vs %u(%s)\n",
+			       i, src.fds[i], src.paths[i], dst.fds[i],
+			       dst.paths[i]);
+		}
+	}
+
+cleanup:
+	bpf_link__destroy(tp_link);
+	bpf_object__close(obj);
+}
diff --git a/tools/testing/selftests/bpf/progs/test_get_file_path.c b/tools/testing/selftests/bpf/progs/test_get_file_path.c
new file mode 100644
index 000000000000..c006fa05e32b
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_get_file_path.c
@@ -0,0 +1,43 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <linux/bpf.h>
+#include <linux/ptrace.h>
+#include <string.h>
+#include <unistd.h>
+#include "bpf_helpers.h"
+#include "bpf_tracing.h"
+
+#define MAX_PATH_LEN		128
+#define MAX_EVENT_NUM		16
+
+static struct file_path_test_data {
+	pid_t pid;
+	__u32 cnt;
+	__u32 fds[MAX_EVENT_NUM];
+	char paths[MAX_EVENT_NUM][MAX_PATH_LEN];
+} data;
+
+struct sys_enter_newfstat_args {
+	unsigned long long pad1;
+	unsigned long long pad2;
+	unsigned int fd;
+};
+
+SEC("tracepoint/syscalls/sys_enter_newfstat")
+int bpf_prog(struct sys_enter_newfstat_args *args)
+{
+	pid_t pid = bpf_get_current_pid_tgid();
+
+	if (pid != data.pid)
+		return 0;
+	if (data.cnt >= MAX_EVENT_NUM)
+		return 0;
+
+	data.fds[data.cnt] = args->fd;
+	bpf_get_file_path(data.paths[data.cnt], MAX_PATH_LEN, args->fd);
+	data.cnt++;
+
+	return 0;
+}
+
+char _license[] SEC("license") = "GPL";
-- 
2.17.1

