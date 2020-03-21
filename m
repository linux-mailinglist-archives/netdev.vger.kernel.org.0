Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C49C318DF51
	for <lists+netdev@lfdr.de>; Sat, 21 Mar 2020 11:04:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728368AbgCUKEx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Mar 2020 06:04:53 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:33066 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726345AbgCUKEx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Mar 2020 06:04:53 -0400
Received: by mail-pg1-f194.google.com with SMTP id d17so3813067pgo.0;
        Sat, 21 Mar 2020 03:04:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=l0uoy/7ATBN5y2bUcak0O8t8JN8wuuXcJ7OANnM6kfU=;
        b=E/svJZGUIuuIQb+4x86xRdPwAzhZBmD3UQnaZw7DJulCVamRIB9l65ZitQM22Np/Wq
         IzUbuUzzbhATIbT0czupvo322Tka2XBluOtScOD+TraegvDOTV1b9FaRjmMDzHiBwpoZ
         ClRFvr8vu+qZ5wNsfvrV6Vq76vYUSXdIz6GTeaY4XMKtJycDHxBh7ltDU2Ip8G2yhWfD
         CgZt1kImkC7jSQTQfDsE4yahZO/XhbI8OVLk9htwYCLnxsY155RDDSiWLKTOfTEJsmUB
         FfccgVbvE0zdbijojoJPiAIM4jnXafdBJEKH0B3w45gOEhXlRkQigESg9kF1oXIPiWor
         bRTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=l0uoy/7ATBN5y2bUcak0O8t8JN8wuuXcJ7OANnM6kfU=;
        b=XlwBgwaj6LU+4WSz+HDd1tme/aA1gXhd5IC5P0XYBRH4mX+b5OU4YhD1t6ynNVSks6
         mkd8gsglRNKdP/6utVDloBSae66PDNTk3xjVjomR3ImtaUU8IDQ6H90J5y6mR9C+KMjz
         St1zv5iPQ90XPdB0xeFyujTNBZYBGYgJ8CLr8DHZrMXWX0U4VWDHpCk2pYjqqXM2m5fW
         +JEmTQgE5CEgTTDi1jIBS2JXM9fS/Mr6lRwmSjcXao/bHpaZ8uM7RAZsl9Rbax/4PvhQ
         uOUMJVreZmCLjfdF7NYqONH4AKm5yaVffJ2Ry0u0gu85b6iVKpbTND4ADl7+bvW2JNu+
         +yKg==
X-Gm-Message-State: ANhLgQ2WUipY2IXf5kbX9eYFNOSmQ+mqZglns/wBCIDk+RlHRqYEgPVM
        DnHc2/PAY93X6HPX3UDnrX1Jw5PpzfUd
X-Google-Smtp-Source: ADFU+vv1hSr8tJp1ZqDQQNQ53JQyz5j1omIBNxIWXCpCpf/+eIBt8C+nwcJJWRHNo7qJu8GhpjqQNQ==
X-Received: by 2002:a62:e909:: with SMTP id j9mr14584504pfh.134.1584785091103;
        Sat, 21 Mar 2020 03:04:51 -0700 (PDT)
Received: from localhost.localdomain ([110.35.161.54])
        by smtp.gmail.com with ESMTPSA id f22sm3811384pgl.20.2020.03.21.03.04.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Mar 2020 03:04:50 -0700 (PDT)
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH bpf-next v5 2/2] samples: bpf: refactor perf_event user program with libbpf bpf_link
Date:   Sat, 21 Mar 2020 19:04:24 +0900
Message-Id: <20200321100424.1593964-3-danieltimlee@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200321100424.1593964-1-danieltimlee@gmail.com>
References: <20200321100424.1593964-1-danieltimlee@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The bpf_program__attach of libbpf(using bpf_link) is much more intuitive
than the previous method using ioctl.

bpf_program__attach_perf_event manages the enable of perf_event and
attach of BPF programs to it, so there's no neeed to do this
directly with ioctl.

In addition, bpf_link provides consistency in the use of API because it
allows disable (detach, destroy) for multiple events to be treated as
one bpf_link__destroy. Also, bpf_link__destroy manages the close() of
perf_event fd.

This commit refactors samples that attach the bpf program to perf_event
by using libbbpf instead of ioctl. Also the bpf_load in the samples were
removed and migrated to use libbbpf API.

Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>

---
Changes in v2:
 - check memory allocation is successful
 - clean up allocated memory on error

Changes in v3:
 - Improve pointer error check (IS_ERR())
 - change to calloc for easier destroy of bpf_link
 - remove perf_event fd list since bpf_link handles fd
 - use newer bpf_object__{open/load} API instead of bpf_prog_load
 - perf_event for _SC_NPROCESSORS_ONLN instead of _SC_NPROCESSORS_CONF
 - find program with name explicitly instead of bpf_program__next
 - unconditional bpf_link__destroy() on cleanup

Changes in v4:
 - bpf_link *, bpf_object * set NULL on init & err for easier destroy
 - close bpf object with bpf_object__close()

Changes in v5:
 - on error, return error code with exit

 samples/bpf/Makefile           |   4 +-
 samples/bpf/sampleip_user.c    |  98 +++++++++++++++--------
 samples/bpf/trace_event_user.c | 139 ++++++++++++++++++++++-----------
 3 files changed, 159 insertions(+), 82 deletions(-)

diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
index ff0061467dd3..424f6fe7ce38 100644
--- a/samples/bpf/Makefile
+++ b/samples/bpf/Makefile
@@ -88,8 +88,8 @@ xdp2-objs := xdp1_user.o
 xdp_router_ipv4-objs := xdp_router_ipv4_user.o
 test_current_task_under_cgroup-objs := bpf_load.o $(CGROUP_HELPERS) \
 				       test_current_task_under_cgroup_user.o
-trace_event-objs := bpf_load.o trace_event_user.o $(TRACE_HELPERS)
-sampleip-objs := bpf_load.o sampleip_user.o $(TRACE_HELPERS)
+trace_event-objs := trace_event_user.o $(TRACE_HELPERS)
+sampleip-objs := sampleip_user.o $(TRACE_HELPERS)
 tc_l2_redirect-objs := bpf_load.o tc_l2_redirect_user.o
 lwt_len_hist-objs := bpf_load.o lwt_len_hist_user.o
 xdp_tx_iptunnel-objs := xdp_tx_iptunnel_user.o
diff --git a/samples/bpf/sampleip_user.c b/samples/bpf/sampleip_user.c
index b0f115f938bc..4372d2da2f9e 100644
--- a/samples/bpf/sampleip_user.c
+++ b/samples/bpf/sampleip_user.c
@@ -10,21 +10,23 @@
 #include <errno.h>
 #include <signal.h>
 #include <string.h>
-#include <assert.h>
 #include <linux/perf_event.h>
 #include <linux/ptrace.h>
 #include <linux/bpf.h>
-#include <sys/ioctl.h>
+#include <bpf/bpf.h>
 #include <bpf/libbpf.h>
-#include "bpf_load.h"
 #include "perf-sys.h"
 #include "trace_helpers.h"
 
+#define __must_check
+#include <linux/err.h>
+
 #define DEFAULT_FREQ	99
 #define DEFAULT_SECS	5
 #define MAX_IPS		8192
 #define PAGE_OFFSET	0xffff880000000000
 
+static int map_fd;
 static int nr_cpus;
 
 static void usage(void)
@@ -34,9 +36,10 @@ static void usage(void)
 	printf("       duration   # sampling duration (seconds), default 5\n");
 }
 
-static int sampling_start(int *pmu_fd, int freq)
+static int sampling_start(int freq, struct bpf_program *prog,
+			  struct bpf_link *links[])
 {
-	int i;
+	int i, pmu_fd;
 
 	struct perf_event_attr pe_sample_attr = {
 		.type = PERF_TYPE_SOFTWARE,
@@ -47,26 +50,30 @@ static int sampling_start(int *pmu_fd, int freq)
 	};
 
 	for (i = 0; i < nr_cpus; i++) {
-		pmu_fd[i] = sys_perf_event_open(&pe_sample_attr, -1 /* pid */, i,
+		pmu_fd = sys_perf_event_open(&pe_sample_attr, -1 /* pid */, i,
 					    -1 /* group_fd */, 0 /* flags */);
-		if (pmu_fd[i] < 0) {
+		if (pmu_fd < 0) {
 			fprintf(stderr, "ERROR: Initializing perf sampling\n");
 			return 1;
 		}
-		assert(ioctl(pmu_fd[i], PERF_EVENT_IOC_SET_BPF,
-			     prog_fd[0]) == 0);
-		assert(ioctl(pmu_fd[i], PERF_EVENT_IOC_ENABLE, 0) == 0);
+		links[i] = bpf_program__attach_perf_event(prog, pmu_fd);
+		if (IS_ERR(links[i])) {
+			fprintf(stderr, "ERROR: Attach perf event\n");
+			links[i] = NULL;
+			close(pmu_fd);
+			return 1;
+		}
 	}
 
 	return 0;
 }
 
-static void sampling_end(int *pmu_fd)
+static void sampling_end(struct bpf_link *links[])
 {
 	int i;
 
 	for (i = 0; i < nr_cpus; i++)
-		close(pmu_fd[i]);
+		bpf_link__destroy(links[i]);
 }
 
 struct ipcount {
@@ -128,14 +135,17 @@ static void print_ip_map(int fd)
 static void int_exit(int sig)
 {
 	printf("\n");
-	print_ip_map(map_fd[0]);
+	print_ip_map(map_fd);
 	exit(0);
 }
 
 int main(int argc, char **argv)
 {
+	int opt, freq = DEFAULT_FREQ, secs = DEFAULT_SECS, error = 1;
+	struct bpf_object *obj = NULL;
+	struct bpf_program *prog;
+	struct bpf_link **links;
 	char filename[256];
-	int *pmu_fd, opt, freq = DEFAULT_FREQ, secs = DEFAULT_SECS;
 
 	/* process arguments */
 	while ((opt = getopt(argc, argv, "F:h")) != -1) {
@@ -163,38 +173,58 @@ int main(int argc, char **argv)
 	}
 
 	/* create perf FDs for each CPU */
-	nr_cpus = sysconf(_SC_NPROCESSORS_CONF);
-	pmu_fd = malloc(nr_cpus * sizeof(int));
-	if (pmu_fd == NULL) {
-		fprintf(stderr, "ERROR: malloc of pmu_fd\n");
-		return 1;
+	nr_cpus = sysconf(_SC_NPROCESSORS_ONLN);
+	links = calloc(nr_cpus, sizeof(struct bpf_link *));
+	if (!links) {
+		fprintf(stderr, "ERROR: malloc of links\n");
+		goto cleanup;
 	}
 
-	/* load BPF program */
 	snprintf(filename, sizeof(filename), "%s_kern.o", argv[0]);
-	if (load_bpf_file(filename)) {
-		fprintf(stderr, "ERROR: loading BPF program (errno %d):\n",
-			errno);
-		if (strcmp(bpf_log_buf, "") == 0)
-			fprintf(stderr, "Try: ulimit -l unlimited\n");
-		else
-			fprintf(stderr, "%s", bpf_log_buf);
-		return 1;
+	obj = bpf_object__open_file(filename, NULL);
+	if (IS_ERR(obj)) {
+		fprintf(stderr, "ERROR: opening BPF object file failed\n");
+		obj = NULL;
+		goto cleanup;
+	}
+
+	prog = bpf_object__find_program_by_name(obj, "do_sample");
+	if (!prog) {
+		fprintf(stderr, "ERROR: finding a prog in obj file failed\n");
+		goto cleanup;
 	}
+
+	/* load BPF program */
+	if (bpf_object__load(obj)) {
+		fprintf(stderr, "ERROR: loading BPF object file failed\n");
+		goto cleanup;
+	}
+
+	map_fd = bpf_object__find_map_fd_by_name(obj, "ip_map");
+	if (map_fd < 0) {
+		fprintf(stderr, "ERROR: finding a map in obj file failed\n");
+		goto cleanup;
+	}
+
 	signal(SIGINT, int_exit);
 	signal(SIGTERM, int_exit);
 
 	/* do sampling */
 	printf("Sampling at %d Hertz for %d seconds. Ctrl-C also ends.\n",
 	       freq, secs);
-	if (sampling_start(pmu_fd, freq) != 0)
-		return 1;
+	if (sampling_start(freq, prog, links) != 0)
+		goto cleanup;
+
 	sleep(secs);
-	sampling_end(pmu_fd);
-	free(pmu_fd);
+	error = 0;
 
+cleanup:
+	sampling_end(links);
 	/* output sample counts */
-	print_ip_map(map_fd[0]);
+	if (!error)
+		print_ip_map(map_fd);
 
-	return 0;
+	free(links);
+	bpf_object__close(obj);
+	return error;
 }
diff --git a/samples/bpf/trace_event_user.c b/samples/bpf/trace_event_user.c
index 356171bc392b..f934544c994e 100644
--- a/samples/bpf/trace_event_user.c
+++ b/samples/bpf/trace_event_user.c
@@ -6,22 +6,25 @@
 #include <stdlib.h>
 #include <stdbool.h>
 #include <string.h>
-#include <fcntl.h>
-#include <poll.h>
-#include <sys/ioctl.h>
 #include <linux/perf_event.h>
 #include <linux/bpf.h>
 #include <signal.h>
-#include <assert.h>
 #include <errno.h>
 #include <sys/resource.h>
+#include <bpf/bpf.h>
 #include <bpf/libbpf.h>
-#include "bpf_load.h"
 #include "perf-sys.h"
 #include "trace_helpers.h"
 
+#define __must_check
+#include <linux/err.h>
+
 #define SAMPLE_FREQ 50
 
+static int pid;
+/* counts, stackmap */
+static int map_fd[2];
+struct bpf_program *prog;
 static bool sys_read_seen, sys_write_seen;
 
 static void print_ksym(__u64 addr)
@@ -91,10 +94,10 @@ static void print_stack(struct key_t *key, __u64 count)
 	}
 }
 
-static void int_exit(int sig)
+static void err_exit(int err)
 {
-	kill(0, SIGKILL);
-	exit(0);
+	kill(pid, SIGKILL);
+	exit(err);
 }
 
 static void print_stacks(void)
@@ -102,7 +105,7 @@ static void print_stacks(void)
 	struct key_t key = {}, next_key;
 	__u64 value;
 	__u32 stackid = 0, next_id;
-	int fd = map_fd[0], stack_map = map_fd[1];
+	int error = 1, fd = map_fd[0], stack_map = map_fd[1];
 
 	sys_read_seen = sys_write_seen = false;
 	while (bpf_map_get_next_key(fd, &key, &next_key) == 0) {
@@ -114,7 +117,7 @@ static void print_stacks(void)
 	printf("\n");
 	if (!sys_read_seen || !sys_write_seen) {
 		printf("BUG kernel stack doesn't contain sys_read() and sys_write()\n");
-		int_exit(0);
+		err_exit(error);
 	}
 
 	/* clear stack map */
@@ -136,43 +139,52 @@ static inline int generate_load(void)
 
 static void test_perf_event_all_cpu(struct perf_event_attr *attr)
 {
-	int nr_cpus = sysconf(_SC_NPROCESSORS_CONF);
-	int *pmu_fd = malloc(nr_cpus * sizeof(int));
-	int i, error = 0;
+	int nr_cpus = sysconf(_SC_NPROCESSORS_ONLN);
+	struct bpf_link **links = calloc(nr_cpus, sizeof(struct bpf_link *));
+	int i, pmu_fd, error = 1;
+
+	if (!links) {
+		printf("malloc of links failed\n");
+		goto err;
+	}
 
 	/* system wide perf event, no need to inherit */
 	attr->inherit = 0;
 
 	/* open perf_event on all cpus */
 	for (i = 0; i < nr_cpus; i++) {
-		pmu_fd[i] = sys_perf_event_open(attr, -1, i, -1, 0);
-		if (pmu_fd[i] < 0) {
+		pmu_fd = sys_perf_event_open(attr, -1, i, -1, 0);
+		if (pmu_fd < 0) {
 			printf("sys_perf_event_open failed\n");
-			error = 1;
 			goto all_cpu_err;
 		}
-		assert(ioctl(pmu_fd[i], PERF_EVENT_IOC_SET_BPF, prog_fd[0]) == 0);
-		assert(ioctl(pmu_fd[i], PERF_EVENT_IOC_ENABLE) == 0);
+		links[i] = bpf_program__attach_perf_event(prog, pmu_fd);
+		if (IS_ERR(links[i])) {
+			printf("bpf_program__attach_perf_event failed\n");
+			links[i] = NULL;
+			close(pmu_fd);
+			goto all_cpu_err;
+		}
 	}
 
-	if (generate_load() < 0) {
-		error = 1;
+	if (generate_load() < 0)
 		goto all_cpu_err;
-	}
+
 	print_stacks();
+	error = 0;
 all_cpu_err:
-	for (i--; i >= 0; i--) {
-		ioctl(pmu_fd[i], PERF_EVENT_IOC_DISABLE);
-		close(pmu_fd[i]);
-	}
-	free(pmu_fd);
+	for (i--; i >= 0; i--)
+		bpf_link__destroy(links[i]);
+err:
+	free(links);
 	if (error)
-		int_exit(0);
+		err_exit(error);
 }
 
 static void test_perf_event_task(struct perf_event_attr *attr)
 {
-	int pmu_fd, error = 0;
+	struct bpf_link *link = NULL;
+	int pmu_fd, error = 1;
 
 	/* per task perf event, enable inherit so the "dd ..." command can be traced properly.
 	 * Enabling inherit will cause bpf_perf_prog_read_time helper failure.
@@ -183,21 +195,25 @@ static void test_perf_event_task(struct perf_event_attr *attr)
 	pmu_fd = sys_perf_event_open(attr, 0, -1, -1, 0);
 	if (pmu_fd < 0) {
 		printf("sys_perf_event_open failed\n");
-		int_exit(0);
+		goto err;
 	}
-	assert(ioctl(pmu_fd, PERF_EVENT_IOC_SET_BPF, prog_fd[0]) == 0);
-	assert(ioctl(pmu_fd, PERF_EVENT_IOC_ENABLE) == 0);
-
-	if (generate_load() < 0) {
-		error = 1;
+	link = bpf_program__attach_perf_event(prog, pmu_fd);
+	if (IS_ERR(link)) {
+		printf("bpf_program__attach_perf_event failed\n");
+		link = NULL;
+		close(pmu_fd);
 		goto err;
 	}
+
+	if (generate_load() < 0)
+		goto err;
+
 	print_stacks();
+	error = 0;
 err:
-	ioctl(pmu_fd, PERF_EVENT_IOC_DISABLE);
-	close(pmu_fd);
+	bpf_link__destroy(link);
 	if (error)
-		int_exit(0);
+		err_exit(error);
 }
 
 static void test_bpf_perf_event(void)
@@ -282,29 +298,60 @@ static void test_bpf_perf_event(void)
 int main(int argc, char **argv)
 {
 	struct rlimit r = {RLIM_INFINITY, RLIM_INFINITY};
+	struct bpf_object *obj = NULL;
 	char filename[256];
+	int error = 1;
 
 	snprintf(filename, sizeof(filename), "%s_kern.o", argv[0]);
 	setrlimit(RLIMIT_MEMLOCK, &r);
 
-	signal(SIGINT, int_exit);
-	signal(SIGTERM, int_exit);
+	signal(SIGINT, err_exit);
+	signal(SIGTERM, err_exit);
 
 	if (load_kallsyms()) {
 		printf("failed to process /proc/kallsyms\n");
-		return 1;
+		goto cleanup;
+	}
+
+	obj = bpf_object__open_file(filename, NULL);
+	if (IS_ERR(obj)) {
+		printf("opening BPF object file failed\n");
+		obj = NULL;
+		goto cleanup;
+	}
+
+	prog = bpf_object__find_program_by_name(obj, "bpf_prog1");
+	if (!prog) {
+		printf("finding a prog in obj file failed\n");
+		goto cleanup;
+	}
+
+	/* load BPF program */
+	if (bpf_object__load(obj)) {
+		printf("loading BPF object file failed\n");
+		goto cleanup;
 	}
 
-	if (load_bpf_file(filename)) {
-		printf("%s", bpf_log_buf);
-		return 2;
+	map_fd[0] = bpf_object__find_map_fd_by_name(obj, "counts");
+	map_fd[1] = bpf_object__find_map_fd_by_name(obj, "stackmap");
+	if (map_fd[0] < 0 || map_fd[1] < 0) {
+		printf("finding a counts/stackmap map in obj file failed\n");
+		goto cleanup;
 	}
 
-	if (fork() == 0) {
+	pid = fork();
+	if (pid == 0) {
 		read_trace_pipe();
 		return 0;
+	} else if (pid == -1) {
+		printf("couldn't spawn process\n");
+		goto cleanup;
 	}
+
 	test_bpf_perf_event();
-	int_exit(0);
-	return 0;
+	error = 0;
+
+cleanup:
+	bpf_object__close(obj);
+	err_exit(error);
 }
-- 
2.25.1

