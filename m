Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BDE54105A8
	for <lists+netdev@lfdr.de>; Wed,  1 May 2019 08:56:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726150AbfEAG4a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 May 2019 02:56:30 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:47818 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726005AbfEAG43 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 May 2019 02:56:29 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x416qWVn017325
        for <netdev@vger.kernel.org>; Tue, 30 Apr 2019 23:56:28 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=UnnjVKA4o3llI1vxekgXOcSRB/T0mKqe0BaJWhnqp28=;
 b=jCRkMQaqkKFZsneOMgI0NZTWHls/w1Bnt9U2aEVHVzuKjp+p72wJKqYE7G2gaVFigtEI
 aJsAXAeqcdyd4m5x8ealn85W0hcHb5/6cmM18zmiagQzjabbhli14LVyl5R+DS+FOBDL
 KoZq7gxMVxi03/WbT26b7inIzqa6xw8aovQ= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2s6xhp16u7-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 30 Apr 2019 23:56:28 -0700
Received: from mx-out.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Tue, 30 Apr 2019 23:56:26 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id 8260E3702FB8; Tue, 30 Apr 2019 23:56:24 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Yonghong Song <yhs@fb.com>
Smtp-Origin-Hostname: devbig003.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Yonghong Song <yhs@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [RFC PATCH bpf-next 3/3] tools/bpf: add a selftest for bpf_send_signal() helper
Date:   Tue, 30 Apr 2019 23:56:24 -0700
Message-ID: <20190501065624.2600001-1-yhs@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190501065621.2599742-1-yhs@fb.com>
References: <20190501065621.2599742-1-yhs@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-01_03:,,
 signatures=0
X-Proofpoint-Spam-Reason: safe
X-FB-Internal: Safe
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The test covered both nmi and tracepoint perf events.
  $ ./test_send_signal_user
  test_send_signal (tracepoint): OK
  test_send_signal (perf_event): OK

Signed-off-by: Yonghong Song <yhs@fb.com>
---
 tools/testing/selftests/bpf/Makefile          |   5 +-
 tools/testing/selftests/bpf/bpf_helpers.h     |   2 +
 .../bpf/progs/test_send_signal_kern.c         |  50 +++++
 .../selftests/bpf/test_send_signal_user.c     | 186 ++++++++++++++++++
 4 files changed, 241 insertions(+), 2 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/progs/test_send_signal_kern.c
 create mode 100644 tools/testing/selftests/bpf/test_send_signal_user.c

diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index 66f2dca1dee1..c3aa33dfae18 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -23,7 +23,8 @@ TEST_GEN_PROGS = test_verifier test_tag test_maps test_lru_map test_lpm_map test
 	test_align test_verifier_log test_dev_cgroup test_tcpbpf_user \
 	test_sock test_btf test_sockmap test_lirc_mode2_user get_cgroup_id_user \
 	test_socket_cookie test_cgroup_storage test_select_reuseport test_section_names \
-	test_netcnt test_tcpnotify_user test_sock_fields test_sysctl
+	test_netcnt test_tcpnotify_user test_sock_fields test_sysctl \
+	test_send_signal_user
 
 BPF_OBJ_FILES = $(patsubst %.c,%.o, $(notdir $(wildcard progs/*.c)))
 TEST_GEN_FILES = $(BPF_OBJ_FILES)
@@ -124,7 +125,7 @@ endif
 CLANG_SYS_INCLUDES := $(shell $(CLANG) -v -E - </dev/null 2>&1 \
 	| sed -n '/<...> search starts here:/,/End of search list./{ s| \(/.*\)|-idirafter \1|p }')
 
-CLANG_FLAGS = -I. -I./include/uapi -I../../../include/uapi \
+CLANG_FLAGS = -I. -I./include/uapi -I../../../include/uapi -I../../../include \
 	      $(CLANG_SYS_INCLUDES) \
 	      -Wno-compare-distinct-pointer-types
 
diff --git a/tools/testing/selftests/bpf/bpf_helpers.h b/tools/testing/selftests/bpf/bpf_helpers.h
index 6e80b66d7fb1..4517bca4f9ed 100644
--- a/tools/testing/selftests/bpf/bpf_helpers.h
+++ b/tools/testing/selftests/bpf/bpf_helpers.h
@@ -216,6 +216,8 @@ static void *(*bpf_sk_storage_get)(void *map, struct bpf_sock *sk,
 	(void *) BPF_FUNC_sk_storage_get;
 static int (*bpf_sk_storage_delete)(void *map, struct bpf_sock *sk) =
 	(void *)BPF_FUNC_sk_storage_delete;
+static int (*bpf_send_signal)(unsigned pid, unsigned sig) =
+	(void *)BPF_FUNC_send_signal;
 
 /* llvm builtin functions that eBPF C program may use to
  * emit BPF_LD_ABS and BPF_LD_IND instructions
diff --git a/tools/testing/selftests/bpf/progs/test_send_signal_kern.c b/tools/testing/selftests/bpf/progs/test_send_signal_kern.c
new file mode 100644
index 000000000000..b81dbbf60b3d
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_send_signal_kern.c
@@ -0,0 +1,50 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright (c) 2019 Facebook
+#include <linux/bpf.h>
+#include <linux/bpf_perf_event.h>
+#include <linux/version.h>
+#include "bpf_helpers.h"
+
+struct bpf_map_def SEC("maps") info_map = {
+	.type = BPF_MAP_TYPE_ARRAY,
+	.key_size = sizeof(__u32),
+	.value_size = sizeof(__u64),
+	.max_entries = 1,
+};
+
+BPF_ANNOTATE_KV_PAIR(info_map, __u32, __u64);
+
+struct bpf_map_def SEC("maps") status_map = {
+	.type = BPF_MAP_TYPE_ARRAY,
+	.key_size = sizeof(__u32),
+	.value_size = sizeof(__u64),
+	.max_entries = 1,
+};
+
+BPF_ANNOTATE_KV_PAIR(status_map, __u32, __u64);
+
+SEC("send_signal_demo")
+int bpf_send_signal_test(void *ctx)
+{
+	__u64 *info_val, *status_val;
+	__u32 key = 0, pid, sig;
+	int ret;
+
+	status_val = bpf_map_lookup_elem(&status_map, &key);
+	if (!status_val || *status_val != 0)
+		return 0;
+
+	info_val = bpf_map_lookup_elem(&info_map, &key);
+	if (!info_val || *info_val == 0)
+		return 0;
+
+	sig = *info_val >> 32;
+	pid = *info_val & 0xffffFFFF;
+
+	ret = bpf_send_signal(pid, sig);
+	if (ret == 0)
+		*status_val = 1;
+
+	return 0;
+}
+char __license[] SEC("license") = "GPL";
diff --git a/tools/testing/selftests/bpf/test_send_signal_user.c b/tools/testing/selftests/bpf/test_send_signal_user.c
new file mode 100644
index 000000000000..38898c575bd2
--- /dev/null
+++ b/tools/testing/selftests/bpf/test_send_signal_user.c
@@ -0,0 +1,186 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <errno.h>
+#include <signal.h>
+#include <syscall.h>
+#include <sys/ioctl.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <sys/wait.h>
+#include <fcntl.h>
+#include <unistd.h>
+
+#include <linux/perf_event.h>
+#include <bpf/bpf.h>
+#include <bpf/libbpf.h>
+
+#include "bpf_rlimit.h"
+
+static volatile int signal_received = 0;
+
+static void sigusr1_handler(int signum)
+{
+	signal_received++;
+}
+
+static void test_common(struct perf_event_attr *attr, int prog_type,
+			const char *test_name, int trace_pid, int cpu)
+{
+	int pmu_fd, prog_fd, info_map_fd, status_map_fd;
+	const char *file = "./test_send_signal_kern.o";
+	struct bpf_object *obj = NULL;
+	int pipe_c2p[2], pipe_p2c[2];
+	char buf[256];
+	int err = 0;
+	u32 key = 0;
+	pid_t pid;
+	u64 val;
+
+	if (pipe(pipe_c2p) < 0) {
+		fprintf(stderr, "Creating pipe c2p error\n");
+		return;
+	}
+	if (pipe(pipe_p2c) < 0) {
+		fprintf(stderr, "Creating pipe p2c error\n");
+		return;
+	}
+
+	pid = fork();
+	if (pid == 0) {
+		/* install signal handler and notify parent */
+		signal(SIGUSR1, sigusr1_handler);
+
+		close(pipe_c2p[0]); /* close read */
+		close(pipe_p2c[1]); /* close write */
+
+		/* notify parent signal handler is installed */
+		write(pipe_c2p[1], buf, 1);
+
+		/* make sense parent enabled bpf program to send_signal */
+		read(pipe_p2c[0], buf, 1);
+
+		/* wait a little for signal handler */
+		sleep(1);
+
+		if (signal_received)
+			write(pipe_c2p[1], "2", 1);
+		else
+			write(pipe_c2p[1], "0", 1);
+
+		/* wait for parent notification and exit */
+		read(pipe_p2c[0], buf, 1);
+		exit(0);
+	}
+
+	close(pipe_c2p[1]); /* close write */
+	close(pipe_p2c[0]); /* close read */
+
+	err = bpf_prog_load(file, prog_type, &obj, &prog_fd);
+	if (err) {
+		printf("test_send_signal:bpf_prog_load errno %d\n", errno);
+		goto close_prog;
+	}
+
+	pmu_fd = syscall(__NR_perf_event_open, attr, trace_pid, cpu,
+			 -1 /* group id */, 0 /* flags */);
+	if (pmu_fd < 0)
+		goto close_prog;
+
+	err = ioctl(pmu_fd, PERF_EVENT_IOC_ENABLE, 0);
+	if (err)
+		goto disable_pmu;
+
+	err = ioctl(pmu_fd, PERF_EVENT_IOC_SET_BPF, prog_fd);
+	if (err)
+		goto disable_pmu;
+
+	info_map_fd = bpf_object__find_map_fd_by_name(obj, "info_map");
+	if (info_map_fd < 0)
+		goto disable_pmu;
+
+	status_map_fd = bpf_object__find_map_fd_by_name(obj, "status_map");
+	if (status_map_fd < 0)
+		goto disable_pmu;
+
+	/* wait until child signal handler installed */
+	read(pipe_c2p[0], buf, 1);
+
+	/* trigger the bpf send_signal */
+	key = 0;
+	val = (((u64)(SIGUSR1)) << 32) | pid;
+	bpf_map_update_elem(info_map_fd, &key, &val, 0);
+
+	/* notify child that bpf program can send_signal now */
+	write(pipe_p2c[1], buf, 1);
+
+	/* wait for result */
+	read(pipe_c2p[0], buf, 1);
+
+	if (buf[0] == '2')
+		printf("test_send_signal (%s): OK\n", test_name);
+	else
+		printf("test_send_signal (%s): FAIL\n", test_name);
+
+	/* notify child safe to exit */
+	write(pipe_p2c[1], buf, 1);
+
+	goto close_prog_noerr;
+
+close_prog:
+disable_pmu:
+	printf("test_send_signal (%s) :FAIL\n", test_name);
+close_prog_noerr:
+	bpf_object__close(obj);
+
+	wait(NULL);
+}
+
+static void test_tracepoint(void)
+{
+	struct perf_event_attr attr = {
+		.type = PERF_TYPE_TRACEPOINT,
+		.sample_type = PERF_SAMPLE_RAW | PERF_SAMPLE_CALLCHAIN,
+		.sample_period = 1,
+		.wakeup_events = 1,
+	};
+	int bytes, efd;
+	char buf[256];
+
+	snprintf(buf, sizeof(buf),
+		 "/sys/kernel/debug/tracing/events/syscalls/sys_enter_nanosleep/id");
+	efd = open(buf, O_RDONLY, 0);
+	if (efd < 0) {
+		printf("test_send_signal:bpf_prog_load errno %d\n", errno);
+		return;
+	}
+
+	bytes = read(efd, buf, sizeof(buf));
+	close(efd);
+	if (bytes <= 0 || bytes >= sizeof(buf))
+		return;
+
+	attr.config = strtol(buf, NULL, 0);
+
+	test_common(&attr, BPF_PROG_TYPE_TRACEPOINT, "tracepoint", -1, 0);
+}
+
+static void test_nmi_perf_event(void)
+{
+	struct perf_event_attr attr = {
+		.sample_freq = 50,
+		.freq = 1,
+		.type = PERF_TYPE_HARDWARE,
+		.config = PERF_COUNT_HW_CPU_CYCLES,
+	};
+
+	test_common(&attr, BPF_PROG_TYPE_PERF_EVENT, "perf_event", -1, 0);
+}
+
+int main(void)
+{
+	test_tracepoint();
+	test_nmi_perf_event();
+	return 0;
+}
-- 
2.17.1

