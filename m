Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65B9DEF469
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 05:15:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730423AbfKEEPS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Nov 2019 23:15:18 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:33298 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730302AbfKEEPR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Nov 2019 23:15:17 -0500
Received: by mail-pl1-f196.google.com with SMTP id ay6so1720804plb.0;
        Mon, 04 Nov 2019 20:15:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=s7V9QuJBpH0pZMq1hA2jL71rRUGbKZ8eHiZmmGf3xos=;
        b=I3Inbirds6JniWjO71kNzUGjaVpOmEX2aSlBIwlqzr5xFfl00BSHnhyusPaK1J40U0
         2olKrRVK9VrEGP/u+yuUxV3rIqrPKwTV6MMqixRIDlPTvt/k76MhKN4SyaezU2ofG21x
         xwx8FHxq6+zPeyden+AeBeAPBUZkSJaNiMN3HaKNwMz7wbQTbzZo2L7mt2XmbkKT6rqc
         4Up4xW/ESaBnjdno9jW+fng1OgbEOoRfr9dhWn3t10MoFTywggRgerekdqofRBWMkkRE
         Yn3B4yIcJLmDsFbJjQxmrYv1XIyDk8wvmZZdiR2Or6KT9aUz76CwqsRaxoQKHzwNZGPk
         P9BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=s7V9QuJBpH0pZMq1hA2jL71rRUGbKZ8eHiZmmGf3xos=;
        b=RWMEo9QlPxuxHVfV1kOIh2VaxQgdoqfcetQlqVDMN5nJXjI7O2SjF0uzxup4Wat15G
         RlJ5McTPczyBxPKPxE5YwQ4FR8Xs4Df8EfWbxj8ujN01KehxPzpGX/nQ2v5Bg3X0e8IS
         Ib20s0fEPU7uV9otn+yk3qyfiOsHHVMAYCXqIaEQqUYLT5Jm3InyNOAOX0nKH1z1hwzF
         ONHtMoRiAsIo1mSI1PXtk4ZjoOFOiZaFQg7i785VZxjEh8HPgpfGG8m7tKZ2Rh4bp8Nw
         gRzkGBXkC4zzOm+Als7abGY4vDTXdZBywnBTWs8bvGBgyyldhjrwyy+IUcvyq81ckMN9
         rbcQ==
X-Gm-Message-State: APjAAAU5ECc9fEZYrN7pZC5bCY4v0PqL6I33nTnRwQoKGtNKMvY6jPHF
        8cGFQ4dHYJ+LXDOlT/34U+yfSWjF
X-Google-Smtp-Source: APXvYqzkhp53IN9HidBbo+RHyzFQgH4bnIMRD7Eb/hKdtPgHPw0+9K0OBKnnvS4suGThzk1+UHOrLw==
X-Received: by 2002:a17:902:bcca:: with SMTP id o10mr31360669pls.46.1572927316458;
        Mon, 04 Nov 2019 20:15:16 -0800 (PST)
Received: from ubuntu-18.04-x8664 ([128.1.49.85])
        by smtp.gmail.com with ESMTPSA id t13sm17522223pfh.12.2019.11.04.20.15.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Nov 2019 20:15:16 -0800 (PST)
From:   Wenbo Zhang <ethercflow@gmail.com>
To:     bpf@vger.kernel.org
Cc:     yhs@fb.com, daniel@iogearbox.net, andrii.nakryiko@gmail.com,
        netdev@vger.kernel.org, Wenbo Zhang <ethercflow@gmail.com>
Subject: [PATCH bpf-next v3] selftests/bpf: test for bpf_get_file_path() from raw tracepoint
Date:   Mon,  4 Nov 2019 23:12:23 -0500
Message-Id: <20191105041223.5622-1-ethercflow@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

trace fstat events by raw tracepoint sys_enter:newfstat, and handle events
only produced by test_file_get_path, which call fstat on several different
types of files to test bpf_get_file_path's feature.

v2->v3: addressed Andrii's feedback
- use global data instead of perf_buffer to simplified code

v1->v2: addressed Daniel's feedback
- rename bpf_fd2path to bpf_get_file_path to be consistent with other
helper's names

Signed-off-by: Wenbo Zhang <ethercflow@gmail.com>
---
 .../selftests/bpf/prog_tests/get_file_path.c  | 171 ++++++++++++++++++
 .../selftests/bpf/progs/test_get_file_path.c  |  71 ++++++++
 2 files changed, 242 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/get_file_path.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_get_file_path.c

diff --git a/tools/testing/selftests/bpf/prog_tests/get_file_path.c b/tools/testing/selftests/bpf/prog_tests/get_file_path.c
new file mode 100644
index 000000000000..26126e55c1f0
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/get_file_path.c
@@ -0,0 +1,171 @@
+// SPDX-License-Identifier: GPL-2.0
+#define _GNU_SOURCE
+#include <test_progs.h>
+#include <alloca.h>
+#include <sys/stat.h>
+
+#ifndef MAX_PATH_LENGTH
+#define MAX_PATH_LENGTH		128
+#endif
+
+#ifndef TASK_COMM_LEN
+#define TASK_COMM_LEN		16
+#endif
+
+struct get_path_trace_t {
+	unsigned long fd;
+	char path[MAX_PATH_LENGTH];
+};
+
+enum FS_TYPE {
+	PIPE_0,
+	PIPE_1,
+	SOCK,
+	PROC,
+	DEV,
+	LOCAL,
+	INDICATOR,
+	MAX_FDS
+};
+
+struct path_info {
+	int fd;
+	char name[MAX_PATH_LENGTH];
+};
+
+static struct path_info path_infos[MAX_FDS];
+static int path_info_index;
+static int hits;
+
+static inline int set_pathname(pid_t pid, int fd)
+{
+	char buf[MAX_PATH_LENGTH] = {'0'};
+
+	snprintf(buf, MAX_PATH_LENGTH, "/proc/%d/fd/%d", pid, fd);
+	path_infos[path_info_index].fd = fd;
+	return readlink(buf, path_infos[path_info_index++].name,
+			MAX_PATH_LENGTH);
+}
+
+static inline int compare_pathname(struct get_path_trace_t *data)
+{
+	for (int i = 0; i < MAX_FDS; i++) {
+		if (path_infos[i].fd == data->fd) {
+			hits++;
+			return strncmp(path_infos[i].name, data->path,
+					MAX_PATH_LENGTH);
+		}
+	}
+	return 0;
+}
+
+static int trigger_fstat_events(void)
+{
+	int *fds = alloca(sizeof(int) * MAX_FDS);
+	int *pipefd = fds;
+	int *sockfd = fds + SOCK;
+	int *procfd = fds + PROC;
+	int *devfd = fds + DEV;
+	int *localfd = fds + LOCAL;
+	int *indicatorfd = fds + INDICATOR;
+	pid_t pid = getpid();
+
+	/* unmountable pseudo-filesystems */
+	if (pipe(pipefd) < 0 || set_pathname(pid, *pipefd++) < 0 ||
+		set_pathname(pid, *pipefd) < 0)
+		return -1;
+
+	/* unmountable pseudo-filesystems */
+	*sockfd = socket(AF_INET, SOCK_STREAM, 0);
+	if (*sockfd < 0 || set_pathname(pid, *sockfd) < 0)
+		return -1;
+
+	/* mountable pseudo-filesystems */
+	*procfd = open("/proc/self/comm", O_RDONLY);
+	if (*procfd < 0 || set_pathname(pid, *procfd) < 0)
+		return -1;
+
+	*devfd = open("/dev/urandom", O_RDONLY);
+	if (*devfd < 0 || set_pathname(pid, *devfd) < 0)
+		return -1;
+
+	*localfd = open("/tmp/fd2path_loadgen.txt", O_CREAT|O_RDONLY);
+	if (*localfd < 0 || set_pathname(pid, *localfd) < 0)
+		return -1;
+
+	*indicatorfd = open("/tmp/", O_PATH);
+	if (*indicatorfd < 0 || set_pathname(pid, *indicatorfd) < 0)
+		return -1;
+
+	for (int i = 0; i < MAX_FDS; i++)
+		close(fds[i]);
+
+	remove("/tmp/fd2path_loadgen.txt");
+	return 0;
+}
+
+void test_get_file_path(void)
+{
+	const char *prog_name = "raw_tracepoint/sys_enter:newfstat";
+	const char *file = "./test_get_file_path.o";
+	int pidfilter_map_fd, pathdata_map_fd;
+	__u32 key, previous_key, duration = 0;
+	struct get_path_trace_t val = {};
+	struct bpf_program *prog = NULL;
+	struct bpf_object *obj = NULL;
+	struct bpf_link *link = NULL;
+	__u32 pid = getpid();
+	int err, prog_fd;
+
+	err = bpf_prog_load(file, BPF_PROG_TYPE_RAW_TRACEPOINT, &obj, &prog_fd);
+	if (CHECK(err, "prog_load", "err %d errno %d\n", err, errno))
+		return;
+
+	prog = bpf_object__find_program_by_title(obj, prog_name);
+	if (CHECK(!prog, "find_prog", "prog %s not found\n", prog_name))
+		goto out_close;
+
+	link = bpf_program__attach_raw_tracepoint(prog, "sys_enter");
+	if (CHECK(IS_ERR(link), "attach_tp", "err %ld\n", PTR_ERR(link)))
+		goto out_close;
+
+	pidfilter_map_fd = bpf_find_map(__func__, obj, "pidfilter_map");
+	if (CHECK(pidfilter_map_fd < 0, "bpf_find_map pidfilter_map",
+		  "err: %s\n", strerror(errno)))
+		goto out_detach;
+
+	err = bpf_map_update_elem(pidfilter_map_fd, &key, &pid, 0);
+	if (CHECK(err, "pidfilter_map update_elem", "err: %s\n",
+			  strerror(errno)))
+		goto out_detach;
+
+	err = trigger_fstat_events();
+	if (CHECK(err, "trigger_fstat_events", "open fd failed: %s\n",
+			  strerror(errno)))
+		goto out_detach;
+
+	pathdata_map_fd = bpf_find_map(__func__, obj, "pathdata_map");
+	if (CHECK_FAIL(pathdata_map_fd < 0))
+		goto out_detach;
+
+	do {
+		err = bpf_map_lookup_elem(pathdata_map_fd, &key, &val);
+		if (CHECK(err, "lookup_elem from pathdata_map",
+				  "err %s\n", strerror(errno)))
+			goto out_detach;
+
+		CHECK(compare_pathname(&val) != 0,
+			  "get_file_path", "failed to get path: %lu->%s\n",
+			  val.fd, val.path);
+
+		previous_key = key;
+	} while (bpf_map_get_next_key(pathdata_map_fd,
+					&previous_key, &key) == 0);
+
+	CHECK(hits != MAX_FDS, "Lost event?", "%d != %d\n", hits, MAX_FDS);
+
+out_detach:
+	bpf_link__destroy(link);
+out_close:
+	bpf_object__close(obj);
+}
diff --git a/tools/testing/selftests/bpf/progs/test_get_file_path.c b/tools/testing/selftests/bpf/progs/test_get_file_path.c
new file mode 100644
index 000000000000..10ec9a70c81c
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_get_file_path.c
@@ -0,0 +1,71 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <linux/bpf.h>
+#include <linux/ptrace.h>
+#include <linux/sched.h>
+#include <stdbool.h>
+#include <string.h>
+#include "bpf_helpers.h"
+
+#ifndef MAX_PATH_LENGTH
+#define MAX_PATH_LENGTH		128
+#endif
+
+#ifndef MAX_EVENT_NUM
+#define MAX_EVENT_NUM		32
+#endif
+
+struct path_trace_t {
+	unsigned long fd;
+	char path[MAX_PATH_LENGTH];
+};
+
+struct {
+	__uint(type, BPF_MAP_TYPE_ARRAY);
+	__uint(max_entries, MAX_EVENT_NUM);
+	__type(key, __u32);
+	__type(value, struct path_trace_t);
+} pathdata_map SEC(".maps");
+
+struct {
+	__uint(type, BPF_MAP_TYPE_ARRAY);
+	__uint(max_entries, 1);
+	__type(key, __u32);
+	__type(value, __u32);
+} pidfilter_map SEC(".maps");
+
+struct {
+	__uint(type, BPF_MAP_TYPE_ARRAY);
+	__uint(max_entries, 1);
+	__type(key, __u32);
+	__type(value, __u32);
+} index_map SEC(".maps");
+
+SEC("raw_tracepoint/sys_enter:newfstat")
+int bpf_prog(struct bpf_raw_tracepoint_args *ctx)
+{
+	struct path_trace_t *data;
+	struct pt_regs *regs;
+	__u32 key = 0, *i, *pidfilter, pid;
+
+	pidfilter = bpf_map_lookup_elem(&pidfilter_map, &key);
+	if (!pidfilter || *pidfilter == 0)
+		return 0;
+	i = bpf_map_lookup_elem(&index_map, &key);
+	if (!i || *i == MAX_EVENT_NUM)
+		return 0;
+	pid = bpf_get_current_pid_tgid() >> 32;
+	if (pid != *pidfilter)
+		return 0;
+	data = bpf_map_lookup_elem(&pathdata_map, i);
+	if (!data)
+		return 0;
+
+	regs = (struct pt_regs *)ctx->args[0];
+	bpf_probe_read(&data->fd, sizeof(data->fd), &regs->rdi);
+	bpf_get_file_path(data->path, MAX_PATH_LENGTH, data->fd);
+	*i += 1;
+
+	return 0;
+}
+
+char _license[] SEC("license") = "GPL";
-- 
2.17.1

