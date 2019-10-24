Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80B22E35B2
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 16:39:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502812AbfJXOjU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 10:39:20 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:40026 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732293AbfJXOjT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Oct 2019 10:39:19 -0400
Received: by mail-pg1-f195.google.com with SMTP id 15so9027023pgt.7;
        Thu, 24 Oct 2019 07:39:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=Jzc7LhCBxGMbYGgopiuGmeEGdC7uNTilkbbvrKKKc8I=;
        b=t/WSyKDRLo1JijHVP8J20c0sWxbYGXqwQhcB+uUNDAVVsR9/EBelsgOZJLHNi0XfKP
         Tjd7fnqtItabGXFwLnoutW3QRXtKcqpclhjgTpzrubY6UMxhuNK/itdQG8RoJozOD2Fl
         msYmfgeaP95MdF3haqfK4rkeGRsqTwYreG0VEYH779dZE5CHnT+Z6FN+rtDMs8M+u2JB
         ltco4v6MmEK3qv4QiwU5V3BlHso4CPz/MB6He/AsztSPC1DU5FPB7XpLqTD/501n8B4z
         xHEuh/kPcspmM8NpWYPCxVcE9ON1aBq5KM6VT5oFKUC8WTgdZZ8iLExS3eSMy7PZQDVX
         si4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Jzc7LhCBxGMbYGgopiuGmeEGdC7uNTilkbbvrKKKc8I=;
        b=OGJXjVss8bi46WQFqxEY8aVpmOaw2rnGDBPWoSmHzKQRqYVDKEkkCly9w1mw/+4bnG
         fdQbMoq8exSzU+Vs61hxjgaIcZBqqz8HP9lbF7pTTDB8qSk/QAg9YQkI0mj0rgr8kOP1
         R2t/IJOKCLXKuik8rxZ0eUoYr7eLsAIn+ZSjV9/xDddCAcxPcIPSh9kq8+FT4QezT3GG
         bUy7+SHPXF0Rfknd/lQ5fBFtzazUaenhWKQzUY0VDAKQclpRHKMRhTcaCvvS9wlH6zRe
         F8MdU2WqhyJXLLNqQCdqVGJsXY+ExH4tBuod/g3eTE/pV8BBqTvlilWOuoYTVIsx2Kcj
         HdFw==
X-Gm-Message-State: APjAAAWASq7co56oY4f+BZTCRzgqKXEJbOZR2ZFe0utIe6g7q5grUHfd
        2tvhqv8be4QMaK033xYyycDtOD04
X-Google-Smtp-Source: APXvYqzOJ15mc4G/N3lzTzVzhLcecW66Q2HFb8gUmHSqeMKJbvN0fFuMxcDLmEjZqmqA9MGg1KS1UQ==
X-Received: by 2002:a63:d651:: with SMTP id d17mr4951177pgj.106.1571927956270;
        Thu, 24 Oct 2019 07:39:16 -0700 (PDT)
Received: from ubuntu-18.04-x8664 ([128.1.49.85])
        by smtp.gmail.com with ESMTPSA id y11sm2708010pfq.1.2019.10.24.07.39.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2019 07:39:15 -0700 (PDT)
From:   Wenbo Zhang <ethercflow@gmail.com>
To:     bpf@vger.kernel.org
Cc:     yhs@fb.com, daniel@iogearbox.net, netdev@vger.kernel.org,
        Wenbo Zhang <ethercflow@gmail.com>
Subject: [PATCH bpf-next v3] bpf: add new helper fd2path for mapping a file descriptor to a pathname
Date:   Thu, 24 Oct 2019 10:38:56 -0400
Message-Id: <20191024143856.30562-1-ethercflow@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When people want to identify which file system files are being opened,
read, and written to, they can use this helper with file descriptor as
input to achieve this goal. Other pseudo filesystems are also supported.

This requirement is mainly discussed here:

  https://github.com/iovisor/bcc/issues/237

v2->v3:
- remove unnecessary LOCKDOWN_BPF_READ
- refactor error handling section for enhanced readability
- provide a test case in tools/testing/selftests/bpf

v1->v2:
- fix backward compatibility
- add this helper description
- fix signed-off name

Signed-off-by: Wenbo Zhang <ethercflow@gmail.com>
---
 include/linux/bpf.h                           |   1 +
 include/uapi/linux/bpf.h                      |  12 +-
 kernel/bpf/core.c                             |   1 +
 kernel/bpf/helpers.c                          |  36 +++++
 kernel/trace/bpf_trace.c                      |   2 +
 tools/include/uapi/linux/bpf.h                |  12 +-
 tools/testing/selftests/bpf/Makefile          |   8 +-
 tools/testing/selftests/bpf/fd2path_loadgen.c |  75 ++++++++++
 .../selftests/bpf/prog_tests/fd2path.c        | 131 ++++++++++++++++++
 .../selftests/bpf/progs/test_fd2path.c        |  56 ++++++++
 10 files changed, 330 insertions(+), 4 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/fd2path_loadgen.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/fd2path.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_fd2path.c

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 2c2c29b49845..d73314a7e674 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1082,6 +1082,7 @@ extern const struct bpf_func_proto bpf_get_local_storage_proto;
 extern const struct bpf_func_proto bpf_strtol_proto;
 extern const struct bpf_func_proto bpf_strtoul_proto;
 extern const struct bpf_func_proto bpf_tcp_sock_proto;
+extern const struct bpf_func_proto bpf_fd2path_proto;
 
 /* Shared helpers among cBPF and eBPF. */
 void bpf_user_rnd_init_once(void);
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 4af8b0819a32..fdb37740951f 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -2773,6 +2773,15 @@ union bpf_attr {
  *
  * 		This helper is similar to **bpf_perf_event_output**\ () but
  * 		restricted to raw_tracepoint bpf programs.
+ *
+ * int bpf_fd2path(char *path, u32 size, int fd)
+ *	Description
+ *		Get **file** atrribute from the current task by *fd*, then call
+ *		**d_path** to get it's absolute path and copy it as string into
+ *		*path* of *size*. The **path** also support pseudo filesystems
+ *		(whether or not it can be mounted). The *size* must be strictly
+ *		positive. On success, the helper makes sure that the *path* is
+ *		NUL-terminated. On failure, it is filled with zeroes.
  * 	Return
  * 		0 on success, or a negative error in case of failure.
  */
@@ -2888,7 +2897,8 @@ union bpf_attr {
 	FN(sk_storage_delete),		\
 	FN(send_signal),		\
 	FN(tcp_gen_syncookie),		\
-	FN(skb_output),
+	FN(skb_output),			\
+	FN(fd2path),
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
  * function eBPF program intends to call
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 673f5d40a93e..6b44ed804280 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -2079,6 +2079,7 @@ const struct bpf_func_proto bpf_get_current_uid_gid_proto __weak;
 const struct bpf_func_proto bpf_get_current_comm_proto __weak;
 const struct bpf_func_proto bpf_get_current_cgroup_id_proto __weak;
 const struct bpf_func_proto bpf_get_local_storage_proto __weak;
+const struct bpf_func_proto bpf_fd2path_proto __weak;
 
 const struct bpf_func_proto * __weak bpf_get_trace_printk_proto(void)
 {
diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index 5e28718928ca..8e6b4189a456 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -487,3 +487,39 @@ const struct bpf_func_proto bpf_strtoul_proto = {
 	.arg4_type	= ARG_PTR_TO_LONG,
 };
 #endif
+
+BPF_CALL_3(bpf_fd2path, char *, dst, u32, size, int, fd)
+{
+	struct fd f;
+	char *p;
+	int ret = -EINVAL;
+
+	f = fdget_raw(fd);
+	if (!f.file)
+		goto error;
+
+	p = d_path(&f.file->f_path, dst, size);
+	if (IS_ERR_OR_NULL(p)) {
+		ret = PTR_ERR(p);
+		goto error;
+	}
+
+	ret = strlen(p);
+	memmove(dst, p, ret);
+	dst[ret] = '\0';
+	goto end;
+
+error:
+	memset(dst, '0', size);
+end:
+	return ret;
+}
+
+const struct bpf_func_proto bpf_fd2path_proto = {
+	.func       = bpf_fd2path,
+	.gpl_only   = true,
+	.ret_type   = RET_INTEGER,
+	.arg1_type  = ARG_PTR_TO_UNINIT_MEM,
+	.arg2_type  = ARG_CONST_SIZE,
+	.arg3_type  = ARG_ANYTHING,
+};
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index c3240898cc44..26f65abdb249 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -735,6 +735,8 @@ tracing_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 #endif
 	case BPF_FUNC_send_signal:
 		return &bpf_send_signal_proto;
+	case BPF_FUNC_fd2path:
+		return &bpf_fd2path_proto;
 	default:
 		return NULL;
 	}
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 4af8b0819a32..fdb37740951f 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -2773,6 +2773,15 @@ union bpf_attr {
  *
  * 		This helper is similar to **bpf_perf_event_output**\ () but
  * 		restricted to raw_tracepoint bpf programs.
+ *
+ * int bpf_fd2path(char *path, u32 size, int fd)
+ *	Description
+ *		Get **file** atrribute from the current task by *fd*, then call
+ *		**d_path** to get it's absolute path and copy it as string into
+ *		*path* of *size*. The **path** also support pseudo filesystems
+ *		(whether or not it can be mounted). The *size* must be strictly
+ *		positive. On success, the helper makes sure that the *path* is
+ *		NUL-terminated. On failure, it is filled with zeroes.
  * 	Return
  * 		0 on success, or a negative error in case of failure.
  */
@@ -2888,7 +2897,8 @@ union bpf_attr {
 	FN(sk_storage_delete),		\
 	FN(send_signal),		\
 	FN(tcp_gen_syncookie),		\
-	FN(skb_output),
+	FN(skb_output),			\
+	FN(fd2path),
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
  * function eBPF program intends to call
diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index 933f39381039..32883cca7ea7 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -72,7 +72,7 @@ TEST_GEN_PROGS_EXTENDED = test_sock_addr test_skb_cgroup_id_user \
 	flow_dissector_load test_flow_dissector test_tcp_check_syncookie_user \
 	test_lirc_mode2_user
 
-TEST_CUSTOM_PROGS = urandom_read
+TEST_CUSTOM_PROGS = urandom_read fd2path_loadgen
 
 include ../lib.mk
 
@@ -89,6 +89,9 @@ $(notdir $(TEST_GEN_PROGS)						\
 $(OUTPUT)/urandom_read: urandom_read.c
 	$(CC) -o $@ $< -Wl,--build-id
 
+$(OUTPUT)/fd2path_loadgen: fd2path_loadgen.c
+	$(CC) -o $@ $< -Wl,--build-id
+
 BPFOBJ := $(OUTPUT)/libbpf.a
 
 $(TEST_GEN_PROGS) $(TEST_GEN_PROGS_EXTENDED): $(OUTPUT)/test_stub.o $(BPFOBJ)
@@ -258,7 +261,8 @@ TRUNNER_TESTS_DIR := prog_tests
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
index 000000000000..7e8af41f2611
--- /dev/null
+++ b/tools/testing/selftests/bpf/fd2path_loadgen.c
@@ -0,0 +1,75 @@
+// SPDX-License-Identifier: GPL-2.0
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
+	int times = MAX_LOOP_TIMES;
+
+	/* filter ld.so's fstat events, otherwise we'll get wrong link when we
+	 * call readlink with pipefd and sockfd in bpf/prog_tests/fdpath.c due
+	 * to reuse of file descriptors.
+	 */
+	sleep(1);
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
+	while (times--) {
+		struct stat fileStat;
+
+		for (int i = 0; i < MAX_FDS; i++)
+			fstat(fds[i], &fileStat);
+		usleep(1);
+	}
+
+	for (int i = 0; i < MAX_FDS; i++)
+		close(fds[i]);
+
+	remove("/tmp/fd2path_loadgen.txt");
+
+	return 0;
+}
diff --git a/tools/testing/selftests/bpf/prog_tests/fd2path.c b/tools/testing/selftests/bpf/prog_tests/fd2path.c
new file mode 100644
index 000000000000..c0e6994133a5
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/fd2path.c
@@ -0,0 +1,131 @@
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
+#define MAX_STAT_EVENTS		16ull
+#endif
+
+struct get_path_trace_t {
+	int pid;
+	int fd;
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
+	snprintf(pathname, MAX_PATH_LENGTH, "/proc/%d/fd/%d", e->pid, e->fd);
+	if (strncmp(e->comm, &loadgen[2], MAX_PATH_LENGTH))
+		return;
+	ret = readlink(pathname, buf, MAX_PATH_LENGTH);
+	if (ret < 0)
+		return;
+	exp_cnt--;
+	ret = strncmp(buf, e->path, MAX_PATH_LENGTH);
+	CHECK(ret != 0, "fd2path", "failed to get path: %s:%s\n", buf, e->path);
+}
+
+void test_fd2path(void)
+{
+	const char *prog_name = "raw_tracepoint/sys_enter:newfstat";
+	const char *file = "./test_fd2path.o";
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
+		return;
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
diff --git a/tools/testing/selftests/bpf/progs/test_fd2path.c b/tools/testing/selftests/bpf/progs/test_fd2path.c
new file mode 100644
index 000000000000..72b188df3da9
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_fd2path.c
@@ -0,0 +1,56 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <linux/bpf.h>
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
+	int fd;
+	char comm[TASK_COMM_LEN];
+	char path[MAX_PATH_LENGTH];
+};
+
+struct {
+	__uint(type, BPF_MAP_TYPE_PERF_EVENT_ARRAY);
+	__uint(max_entries, 64);
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
+	__u32 key = 0;
+
+	data = bpf_map_lookup_elem(&pathdata_map, &key);
+	if (!data)
+		return 0;
+
+	data->pid = bpf_get_current_pid_tgid() >> 32;
+	data->fd = (int)ctx->args[1];
+	bpf_get_current_comm(&data->comm, TASK_COMM_LEN);
+	if (bpf_fd2path(data->path, MAX_PATH_LENGTH, data->fd) < 0)
+		return 0;
+	bpf_perf_event_output(ctx, &perfmap, BPF_F_CURRENT_CPU,
+			data, sizeof(*data));
+	return 0;
+}
+
+char _license[] SEC("license") = "GPL";
-- 
2.17.1

