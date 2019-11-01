Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8EFBBEC383
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 14:08:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726859AbfKANIa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 09:08:30 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:35243 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726620AbfKANIa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Nov 2019 09:08:30 -0400
Received: by mail-pf1-f193.google.com with SMTP id d13so7061969pfq.2;
        Fri, 01 Nov 2019 06:08:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=BCGcxJCGkVSBBtoLTQqSW2BXDPrWdoGsB/plgvakBHE=;
        b=NVlb9421mvHYxdh5dfRawAiNtkvzgxli9xlDgsWIXOBQqyW+LIKqWTbPo0t6IbEGgj
         UEzkMnqEQO4cNgCT9Yj79NeG/4tsDRXmGkuh/axLgndw2KH9M9ME3YRCJsyRzjyS4Sd+
         oJ1XaG1YpAbyXetxEpctDN4jkSboIPT34GC1yTd3lG/o+muSLuMxA7d4ZqhXHqCRh301
         IQNfXdnhDIu7YK3jo/Oo1+WhXCPJA1ip2ymydvnT+YbnlHsoXSMq0Mfl8iPDqkKjdNdk
         OoWh6RFvyyUsYYZFmF9FblLKbfUeQ106Vp/Ozz/9W61X+cZgL/Xdu3pR31v0NEiPZWvu
         nN3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=BCGcxJCGkVSBBtoLTQqSW2BXDPrWdoGsB/plgvakBHE=;
        b=mlF+SUqEaFbgACJIqdlzpp+Z13r6PMU1fGkbnmllNafhvMsAYHdybAlFfwhlfBw25C
         xzDnzZlPAL7D0LEbKr+QpQ+go4Zuu+bdbCwAbAGR2FtkyAMiSPOWyC60J8IUuue8tbih
         +D6fnVXEAB+ViPv8/2WJLrk7ghu9KgCT4HDxscrPJgb/LERMoYiI2+P/Pteri19AjzcE
         q4AWk7J3hXm5QQ7x+eP2RDHRnRdV253k8zhNBaNFDwIwinLKNHzV+IVay4USGMo1orqD
         uGtCu4vBCjb16K4iEWWCdVJqcrLmSM0MFRNQJ4OtSoaryugH6q1CmrWX101Lpl2+R/1Y
         HZSg==
X-Gm-Message-State: APjAAAXbzxZKZV9YmhqxDDPlT2y+fUKxjeewO0tRm7s3Wcrpv3OLtQu8
        dY7WYotfyoXrvWvpd4u7eGzDa5kdDpU=
X-Google-Smtp-Source: APXvYqy7op31R6jhiFnfnUUKjDEj/sO1orsJ4qTU4n126yB0xHTaT6uHLXKvUYeQumV+OCZi33zEmQ==
X-Received: by 2002:a17:90a:2551:: with SMTP id j75mr4285794pje.122.1572613709276;
        Fri, 01 Nov 2019 06:08:29 -0700 (PDT)
Received: from ubuntu-18.04-x8664 ([128.1.49.85])
        by smtp.gmail.com with ESMTPSA id h5sm10888393pjc.9.2019.11.01.06.08.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Nov 2019 06:08:28 -0700 (PDT)
From:   Wenbo Zhang <ethercflow@gmail.com>
To:     bpf@vger.kernel.org
Cc:     yhs@fb.com, daniel@iogearbox.net, andrii.nakryiko@gmail.com,
        netdev@vger.kernel.org, Wenbo Zhang <ethercflow@gmail.com>
Subject: [PATCH bpf-next v2] selftests/bpf: test for bpf_get_file_path() from raw tracepoint
Date:   Fri,  1 Nov 2019 09:08:17 -0400
Message-Id: <20191101130817.11744-1-ethercflow@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

trace fstat events by raw tracepoint sys_enter:newfstat, and handle events
only produced by fd2path_loadgen, the fd2path_loadgen call fstat on several
different types of files to test bpf_get_file_path's feature.
---
 tools/testing/selftests/bpf/Makefile          |   8 +-
 tools/testing/selftests/bpf/fd2path_loadgen.c |  75 ++++++++++
 .../selftests/bpf/prog_tests/get_file_path.c  | 130 ++++++++++++++++++
 .../selftests/bpf/progs/test_get_file_path.c  |  58 ++++++++
 4 files changed, 269 insertions(+), 2 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/fd2path_loadgen.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/get_file_path.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_get_file_path.c

diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index b334a6db15c1..6c7e5cabc4e6 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -72,7 +72,7 @@ TEST_GEN_PROGS_EXTENDED = test_sock_addr test_skb_cgroup_id_user \
 	flow_dissector_load test_flow_dissector test_tcp_check_syncookie_user \
 	test_lirc_mode2_user
 
-TEST_CUSTOM_PROGS = urandom_read
+TEST_CUSTOM_PROGS = urandom_read fd2path_loadgen
 
 include ../lib.mk
 
@@ -92,6 +92,9 @@ $(OUTPUT)/urandom_read: urandom_read.c
 $(OUTPUT)/test_stub.o: test_stub.c
 	$(CC) -c $(CFLAGS) -o $@ $<
 
+$(OUTPUT)/fd2path_loadgen: fd2path_loadgen.c
+	$(CC) -o $@ $< -Wl,--build-id
+
 BPFOBJ := $(OUTPUT)/libbpf.a
 
 $(TEST_GEN_PROGS) $(TEST_GEN_PROGS_EXTENDED): $(OUTPUT)/test_stub.o $(BPFOBJ)
@@ -266,7 +269,8 @@ TRUNNER_TESTS_DIR := prog_tests
 TRUNNER_BPF_PROGS_DIR := progs
 TRUNNER_EXTRA_SOURCES := test_progs.c cgroup_helpers.c trace_helpers.c	\
 			 flow_dissector_load.h
-TRUNNER_EXTRA_FILES := $(OUTPUT)/urandom_read				\
+TRUNNER_EXTRA_FILES := $(OUTPUT)/urandom_read 				\
+		       $(OUTPUT)/fd2path_loadgen                        \
 		       $(wildcard progs/btf_dump_test_case_*.c)
 TRUNNER_BPF_BUILD_RULE := CLANG_BPF_BUILD_RULE
 TRUNNER_BPF_CFLAGS := -I. -I$(OUTPUT) $(BPF_CFLAGS) $(CLANG_CFLAGS)
diff --git a/tools/testing/selftests/bpf/fd2path_loadgen.c b/tools/testing/selftests/bpf/fd2path_loadgen.c
new file mode 100644
index 000000000000..afa9d6b233b2
--- /dev/null
+++ b/tools/testing/selftests/bpf/fd2path_loadgen.c
@@ -0,0 +1,75 @@
+// SPDX-License-Identifier: GPL-2.0
+#define _GNU_SOURCE
+#include <stdio.h>
+#include <unistd.h>
+#include <fcntl.h>
+#include <sys/socket.h>
+#include <alloca.h>
+#include <sys/stat.h>
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
+#ifndef MAX_LOOP_TIMES
+#define MAX_LOOP_TIMES		100
+#endif
+
+int main(int argc, char *argv[])
+{
+	int *fds = alloca(sizeof(int) * MAX_FDS);
+	int *pipefd = fds;
+	int *sockfd = fds + SOCK;
+	int *procfd = fds + PROC;
+	int *devfd = fds + DEV;
+	int *localfd = fds + LOCAL;
+	int *indicatorfd = fds + INDICATOR;
+	int times = MAX_LOOP_TIMES;
+
+	/* unmountable pseudo-filesystems */
+	if (pipe(pipefd) < 0)
+		return 1;
+
+	/* unmountable pseudo-filesystems */
+	*sockfd = socket(AF_INET, SOCK_STREAM, 0);
+	if (sockfd < 0)
+		return 1;
+
+	/* mountable pseudo-filesystems */
+	*procfd = open("/proc/self/comm", O_RDONLY);
+	if (procfd < 0)
+		return 1;
+
+	*devfd = open("/dev/urandom", O_RDONLY);
+	if (devfd < 0)
+		return 1;
+
+	*localfd = open("/tmp/fd2path_loadgen.txt", O_CREAT|O_RDONLY);
+	if (localfd < 0)
+		return 1;
+
+	*indicatorfd = open("/tmp/", O_PATH);
+
+	while (times--) {
+		struct stat fileStat;
+
+		for (int i = 0; i < MAX_FDS; i++) {
+			fstat(fds[i], &fileStat);
+			usleep(1);
+		}
+	}
+
+	for (int i = 0; i < MAX_FDS; i++)
+		close(fds[i]);
+
+	remove("/tmp/fd2path_loadgen.txt");
+
+	return 0;
+}
diff --git a/tools/testing/selftests/bpf/prog_tests/get_file_path.c b/tools/testing/selftests/bpf/prog_tests/get_file_path.c
new file mode 100644
index 000000000000..00e96151faaa
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/get_file_path.c
@@ -0,0 +1,130 @@
+// SPDX-License-Identifier: GPL-2.0
+#define _GNU_SOURCE
+#include <pthread.h>
+#include <test_progs.h>
+
+#ifndef MAX_PATH_LENGTH
+#define MAX_PATH_LENGTH		128
+#endif
+
+#ifndef TASK_COMM_LEN
+#define TASK_COMM_LEN		16
+#endif
+
+#ifndef MAX_STAT_EVENTS
+#define MAX_STAT_EVENTS		64ull
+#endif
+
+struct get_path_trace_t {
+	int pid;
+	unsigned long fd;
+	char comm[TASK_COMM_LEN];
+	char path[MAX_PATH_LENGTH];
+};
+
+static const char *loadgen = "./fd2path_loadgen";
+static int exp_cnt = MAX_STAT_EVENTS;
+
+void *thread_loadgen(void *arg)
+{
+	assert(system(loadgen) == 0);
+	return NULL;
+}
+
+static void get_path_print_output(void *ctx, int cpu, void *data, __u32 size)
+{
+	struct get_path_trace_t *e = data;
+	char pathname[MAX_PATH_LENGTH] = {'0'};
+	char buf[MAX_PATH_LENGTH] = {'0'};
+	int ret, duration = 0;
+
+	if (strncmp(e->comm, &loadgen[2], MAX_PATH_LENGTH))
+		return;
+	snprintf(pathname, MAX_PATH_LENGTH, "/proc/%d/fd/%lu", e->pid, e->fd);
+	readlink(pathname, buf, MAX_PATH_LENGTH);
+	exp_cnt--;
+	ret = strncmp(buf, e->path, MAX_PATH_LENGTH);
+	CHECK(ret != 0, "get_file_path", "failed to get path: %lu->%s\n",
+			e->fd, e->path);
+}
+
+void test_get_file_path(void)
+{
+	const char *prog_name = "raw_tracepoint/sys_enter:newfstat";
+	const char *file = "./test_get_file_path.o";
+	int err, nr_cpus, duration = 0;
+	struct perf_buffer_opts pb_opts = {};
+	struct perf_buffer *pb = NULL;
+	struct bpf_map *perf_buf_map;
+	cpu_set_t cpu_set, cpu_seen;
+	struct bpf_link *link = NULL;
+	struct timespec tv = {0, 10};
+	struct bpf_program *prog;
+	struct bpf_object *obj;
+	pthread_t t = 0;
+
+	obj = bpf_object__open_file(file, NULL);
+	if (CHECK(IS_ERR(obj), "obj_open", "err %ld\n", PTR_ERR(obj)))
+		return;
+
+	err = bpf_object__load(obj);
+	if (CHECK(err, "obj_load", "err %d errno %d\n", err, errno))
+		goto out_close;
+
+	prog = bpf_object__find_program_by_title(obj, prog_name);
+	if (CHECK(!prog, "find_prog", "prog '%s' not found\n", prog_name))
+		goto out_close;
+
+	link = bpf_program__attach_raw_tracepoint(prog, "sys_enter");
+	if (CHECK(IS_ERR(link), "attach_tp", "err %ld\n", PTR_ERR(link)))
+		goto out_close;
+
+	nr_cpus = libbpf_num_possible_cpus();
+	if (CHECK(nr_cpus < 0, "nr_cpus", "err %d\n", nr_cpus))
+		goto out_close;
+
+	CPU_ZERO(&cpu_seen);
+	for (int i = 0; i < nr_cpus; i++) {
+		CPU_ZERO(&cpu_set);
+		CPU_SET(i, &cpu_set);
+
+		err = pthread_setaffinity_np(pthread_self(), sizeof(cpu_set),
+				&cpu_set);
+		if (err && CHECK(err, "set_affinity", "cpu #%d, err %d\n",
+				i, err))
+			goto out_detach;
+
+		usleep(1);
+	}
+
+	perf_buf_map = bpf_object__find_map_by_name(obj, "perfmap");
+	if (CHECK(!perf_buf_map, "bpf_find_map", "not found\n"))
+		goto out_close;
+
+	pb_opts.sample_cb = get_path_print_output;
+	pb_opts.ctx = &cpu_seen;
+	pb = perf_buffer__new(bpf_map__fd(perf_buf_map), 1, &pb_opts);
+	if (CHECK(IS_ERR(pb), "perf_buf__new", "err %ld\n", PTR_ERR(pb)))
+		goto out_detach;
+
+	pthread_create(&t, NULL, thread_loadgen, NULL);
+
+	/* trigger some fstat syscall action */
+	for (int i = 0; i < MAX_STAT_EVENTS; i++)
+		nanosleep(&tv, NULL);
+
+	while (exp_cnt > 0) {
+		err = perf_buffer__poll(pb, 100);
+		if (err < 0 && CHECK(err < 0, "pb__poll", "err %d\n", err))
+			goto out_free_pb;
+	}
+
+out_free_pb:
+	perf_buffer__free(pb);
+out_detach:
+	bpf_link__destroy(link);
+out_close:
+	bpf_object__close(obj);
+
+	pthread_join(t, NULL);
+}
diff --git a/tools/testing/selftests/bpf/progs/test_get_file_path.c b/tools/testing/selftests/bpf/progs/test_get_file_path.c
new file mode 100644
index 000000000000..2d3efb6b71f2
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_get_file_path.c
@@ -0,0 +1,58 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <linux/bpf.h>
+#include <linux/ptrace.h>
+#include <stdbool.h>
+#include <string.h>
+#include "bpf_helpers.h"
+
+#ifndef MAX_PATH_LENGTH
+#define MAX_PATH_LENGTH		128
+#endif
+
+#ifndef TASK_COMM_LEN
+#define TASK_COMM_LEN		16
+#endif
+
+struct path_trace_t {
+	int pid;
+	unsigned long fd;
+	char comm[TASK_COMM_LEN];
+	char path[MAX_PATH_LENGTH];
+};
+
+struct {
+	__uint(type, BPF_MAP_TYPE_PERF_EVENT_ARRAY);
+	__uint(max_entries, 128);
+	__uint(key_size, sizeof(int));
+	__uint(value_size, sizeof(__u32));
+} perfmap SEC(".maps");
+
+struct {
+	__uint(type, BPF_MAP_TYPE_PERCPU_ARRAY);
+	__uint(max_entries, 1);
+	__type(key, __u32);
+	__type(value, struct path_trace_t);
+} pathdata_map SEC(".maps");
+
+SEC("raw_tracepoint/sys_enter:newfstat")
+int bpf_prog(struct bpf_raw_tracepoint_args *ctx)
+{
+	struct path_trace_t *data;
+	struct pt_regs *regs;
+	__u32 key = 0;
+
+	data = bpf_map_lookup_elem(&pathdata_map, &key);
+	if (!data)
+		return 0;
+	data->pid = bpf_get_current_pid_tgid() >> 32;
+	regs = (struct pt_regs *)ctx->args[0];
+	bpf_probe_read(&data->fd, sizeof(data->fd), &regs->rdi);
+	bpf_get_current_comm(&data->comm, TASK_COMM_LEN);
+	if (bpf_get_file_path(data->path, MAX_PATH_LENGTH, data->fd) < 0)
+		return 0;
+	bpf_perf_event_output(ctx, &perfmap, BPF_F_CURRENT_CPU,
+			data, sizeof(*data));
+	return 0;
+}
+
+char _license[] SEC("license") = "GPL";
-- 
2.17.1

