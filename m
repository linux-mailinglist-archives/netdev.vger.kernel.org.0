Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6280017F040
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 06:52:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726316AbgCJFwO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 01:52:14 -0400
Received: from mail-pj1-f68.google.com ([209.85.216.68]:36112 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726100AbgCJFwO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 01:52:14 -0400
Received: by mail-pj1-f68.google.com with SMTP id l41so253454pjb.1;
        Mon, 09 Mar 2020 22:52:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UUX8Z3POGeq6os5VSjEcIwHmIyDqD6J3BYVOyxZrdCI=;
        b=uVXC/xhKWAkN67S8HK+f3ajicQBwIj/xFHtyfRim9ZVmrRxZQP1NyLCtKydUs0wImg
         tdPe6bpow4v1KSDmLqy0HX4qItZBEOon6Q55Tje9dt04IaWuFZBb3F8ZaauGobDoWa73
         VGgKNsdmLFxvXgLwy3Co2o8bowbK9uj812tnhGhTa6UIZEvA31vsAJtsYGdUpvbUvuux
         jtTMQtZwVjQNgw7lMmM/v+tfyRLZWXA4B8tap4mL1btvmtFswqL7FS/dHc8kb9oN53mv
         VC5PV9+voeoJL9Dmt9qei7/I9h/EjKQT6ZaDY7cumIPomc8UuSgoTl1GsE5l8PKs1MAm
         uWQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UUX8Z3POGeq6os5VSjEcIwHmIyDqD6J3BYVOyxZrdCI=;
        b=FUIg0ds3DF1zxT8d+kMUs3Z2EFAAFy1xa47u5eXtFMfEOMMh8Lo9jATr47+s0YlkRI
         tZBN8pBkcfpT3jKc4YlSGAPsGs3BmXHZmPw4kukQxAX3yveIQK5ifV0WtPf+eC6uYUkK
         iJezWVlnoJJZKZyiEoYyIUCG2sKWXnWezrLUE0aQ5WzX+7ONR8MV7kW2vs7E7UjW/nx1
         7hpLEVQo94jeFfnbVLHDgwV8DAYV4LpUuIGgRlh8Q7xw0KfLISbDmOaaBPrwywOImOcY
         tm3ssyk2hagOeZpthAq5e8kgHqzyjjaXMsM1p9OmA/y3WjXsGv79HD2Q80TE9lA0TgVu
         eUBA==
X-Gm-Message-State: ANhLgQ0FkFiCvcLGnWoSJO5ktqrhByoFFSbuOy7mZsYjM21ap1F/qxt6
        RcByaY5u9jGHQmtkzwFY3A==
X-Google-Smtp-Source: ADFU+vs0l6Iv2wyP+R8ZOyRhr3r5+2iOpqH1O+A/ZLOQkLpjhoz4LJ1dPTchStfltIg8/9vXL5iVQg==
X-Received: by 2002:a17:90a:e012:: with SMTP id u18mr50047pjy.190.1583819530854;
        Mon, 09 Mar 2020 22:52:10 -0700 (PDT)
Received: from localhost.localdomain ([110.35.161.54])
        by smtp.gmail.com with ESMTPSA id c17sm5018980pfn.187.2020.03.09.22.52.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Mar 2020 22:52:10 -0700 (PDT)
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH bpf-next 2/2] samples: bpf: refactor perf_event user program with libbpf bpf_link
Date:   Tue, 10 Mar 2020 14:51:47 +0900
Message-Id: <20200310055147.26678-3-danieltimlee@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310055147.26678-1-danieltimlee@gmail.com>
References: <20200310055147.26678-1-danieltimlee@gmail.com>
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
one bpf_link__destroy.

This commit refactors samples that attach the bpf program to perf_event
by using libbbpf instead of ioctl. Also the bpf_load in the samples were
removed and migrated to use libbbpf API.

Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
---
 samples/bpf/Makefile           |  4 +--
 samples/bpf/sampleip_user.c    | 58 ++++++++++++++++++++++------------
 samples/bpf/trace_event_user.c | 57 ++++++++++++++++++++++-----------
 3 files changed, 78 insertions(+), 41 deletions(-)

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
index b0f115f938bc..8a94ff558b17 100644
--- a/samples/bpf/sampleip_user.c
+++ b/samples/bpf/sampleip_user.c
@@ -10,13 +10,11 @@
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
 
@@ -25,6 +23,7 @@
 #define MAX_IPS		8192
 #define PAGE_OFFSET	0xffff880000000000
 
+static int map_fd;
 static int nr_cpus;
 
 static void usage(void)
@@ -34,7 +33,8 @@ static void usage(void)
 	printf("       duration   # sampling duration (seconds), default 5\n");
 }
 
-static int sampling_start(int *pmu_fd, int freq)
+static int sampling_start(int *pmu_fd, int freq, struct bpf_program *prog,
+			  struct bpf_link **link)
 {
 	int i;
 
@@ -53,20 +53,22 @@ static int sampling_start(int *pmu_fd, int freq)
 			fprintf(stderr, "ERROR: Initializing perf sampling\n");
 			return 1;
 		}
-		assert(ioctl(pmu_fd[i], PERF_EVENT_IOC_SET_BPF,
-			     prog_fd[0]) == 0);
-		assert(ioctl(pmu_fd[i], PERF_EVENT_IOC_ENABLE, 0) == 0);
+		link[i] = bpf_program__attach_perf_event(prog, pmu_fd[i]);
+		if (link[i] < 0) {
+			fprintf(stderr, "ERROR: Attach perf event\n");
+			return 1;
+		}
 	}
 
 	return 0;
 }
 
-static void sampling_end(int *pmu_fd)
+static void sampling_end(struct bpf_link **link)
 {
 	int i;
 
 	for (i = 0; i < nr_cpus; i++)
-		close(pmu_fd[i]);
+		bpf_link__destroy(link[i]);
 }
 
 struct ipcount {
@@ -128,14 +130,17 @@ static void print_ip_map(int fd)
 static void int_exit(int sig)
 {
 	printf("\n");
-	print_ip_map(map_fd[0]);
+	print_ip_map(map_fd);
 	exit(0);
 }
 
 int main(int argc, char **argv)
 {
+	int prog_fd, *pmu_fd, opt, freq = DEFAULT_FREQ, secs = DEFAULT_SECS;
+	struct bpf_program *prog;
+	struct bpf_object *obj;
+	struct bpf_link **link;
 	char filename[256];
-	int *pmu_fd, opt, freq = DEFAULT_FREQ, secs = DEFAULT_SECS;
 
 	/* process arguments */
 	while ((opt = getopt(argc, argv, "F:h")) != -1) {
@@ -165,36 +170,47 @@ int main(int argc, char **argv)
 	/* create perf FDs for each CPU */
 	nr_cpus = sysconf(_SC_NPROCESSORS_CONF);
 	pmu_fd = malloc(nr_cpus * sizeof(int));
-	if (pmu_fd == NULL) {
-		fprintf(stderr, "ERROR: malloc of pmu_fd\n");
+	link = malloc(nr_cpus * sizeof(struct bpf_link *));
+	if (pmu_fd == NULL || link == NULL) {
+		fprintf(stderr, "ERROR: malloc of pmu_fd/link\n");
 		return 1;
 	}
 
 	/* load BPF program */
 	snprintf(filename, sizeof(filename), "%s_kern.o", argv[0]);
-	if (load_bpf_file(filename)) {
+	if (bpf_prog_load(filename, BPF_PROG_TYPE_PERF_EVENT, &obj, &prog_fd)) {
 		fprintf(stderr, "ERROR: loading BPF program (errno %d):\n",
 			errno);
-		if (strcmp(bpf_log_buf, "") == 0)
-			fprintf(stderr, "Try: ulimit -l unlimited\n");
-		else
-			fprintf(stderr, "%s", bpf_log_buf);
 		return 1;
 	}
+
+	prog = bpf_program__next(NULL, obj);
+	if (!prog) {
+		printf("finding a prog in obj file failed\n");
+		return 1;
+	}
+
+	map_fd = bpf_object__find_map_fd_by_name(obj, "ip_map");
+	if (map_fd < 0) {
+		printf("finding a ip_map map in obj file failed\n");
+		return 1;
+	}
+
 	signal(SIGINT, int_exit);
 	signal(SIGTERM, int_exit);
 
 	/* do sampling */
 	printf("Sampling at %d Hertz for %d seconds. Ctrl-C also ends.\n",
 	       freq, secs);
-	if (sampling_start(pmu_fd, freq) != 0)
+	if (sampling_start(pmu_fd, freq, prog, link) != 0)
 		return 1;
 	sleep(secs);
-	sampling_end(pmu_fd);
+	sampling_end(link);
 	free(pmu_fd);
+	free(link);
 
 	/* output sample counts */
-	print_ip_map(map_fd[0]);
+	print_ip_map(map_fd);
 
 	return 0;
 }
diff --git a/samples/bpf/trace_event_user.c b/samples/bpf/trace_event_user.c
index 356171bc392b..fb5c7b91e74c 100644
--- a/samples/bpf/trace_event_user.c
+++ b/samples/bpf/trace_event_user.c
@@ -6,22 +6,21 @@
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
 
 #define SAMPLE_FREQ 50
 
+/* counts, stackmap */
+static int map_fd[2];
+struct bpf_program *prog;
 static bool sys_read_seen, sys_write_seen;
 
 static void print_ksym(__u64 addr)
@@ -137,6 +136,7 @@ static inline int generate_load(void)
 static void test_perf_event_all_cpu(struct perf_event_attr *attr)
 {
 	int nr_cpus = sysconf(_SC_NPROCESSORS_CONF);
+	struct bpf_link **link = malloc(nr_cpus * sizeof(struct bpf_link *));
 	int *pmu_fd = malloc(nr_cpus * sizeof(int));
 	int i, error = 0;
 
@@ -151,8 +151,12 @@ static void test_perf_event_all_cpu(struct perf_event_attr *attr)
 			error = 1;
 			goto all_cpu_err;
 		}
-		assert(ioctl(pmu_fd[i], PERF_EVENT_IOC_SET_BPF, prog_fd[0]) == 0);
-		assert(ioctl(pmu_fd[i], PERF_EVENT_IOC_ENABLE) == 0);
+		link[i] = bpf_program__attach_perf_event(prog, pmu_fd[i]);
+		if (link[i] < 0) {
+			printf("bpf_program__attach_perf_event failed\n");
+			error = 1;
+			goto all_cpu_err;
+		}
 	}
 
 	if (generate_load() < 0) {
@@ -161,11 +165,11 @@ static void test_perf_event_all_cpu(struct perf_event_attr *attr)
 	}
 	print_stacks();
 all_cpu_err:
-	for (i--; i >= 0; i--) {
-		ioctl(pmu_fd[i], PERF_EVENT_IOC_DISABLE);
-		close(pmu_fd[i]);
-	}
+	for (i--; i >= 0; i--)
+		bpf_link__destroy(link[i]);
+
 	free(pmu_fd);
+	free(link);
 	if (error)
 		int_exit(0);
 }
@@ -173,6 +177,7 @@ static void test_perf_event_all_cpu(struct perf_event_attr *attr)
 static void test_perf_event_task(struct perf_event_attr *attr)
 {
 	int pmu_fd, error = 0;
+	struct bpf_link *link;
 
 	/* per task perf event, enable inherit so the "dd ..." command can be traced properly.
 	 * Enabling inherit will cause bpf_perf_prog_read_time helper failure.
@@ -185,8 +190,12 @@ static void test_perf_event_task(struct perf_event_attr *attr)
 		printf("sys_perf_event_open failed\n");
 		int_exit(0);
 	}
-	assert(ioctl(pmu_fd, PERF_EVENT_IOC_SET_BPF, prog_fd[0]) == 0);
-	assert(ioctl(pmu_fd, PERF_EVENT_IOC_ENABLE) == 0);
+	link = bpf_program__attach_perf_event(prog, pmu_fd);
+	if (link < 0) {
+		printf("bpf_program__attach_perf_event failed\n");
+		close(pmu_fd);
+		int_exit(0);
+	}
 
 	if (generate_load() < 0) {
 		error = 1;
@@ -194,8 +203,7 @@ static void test_perf_event_task(struct perf_event_attr *attr)
 	}
 	print_stacks();
 err:
-	ioctl(pmu_fd, PERF_EVENT_IOC_DISABLE);
-	close(pmu_fd);
+	bpf_link__destroy(link);
 	if (error)
 		int_exit(0);
 }
@@ -282,7 +290,9 @@ static void test_bpf_perf_event(void)
 int main(int argc, char **argv)
 {
 	struct rlimit r = {RLIM_INFINITY, RLIM_INFINITY};
+	struct bpf_object *obj;
 	char filename[256];
+	int prog_fd;
 
 	snprintf(filename, sizeof(filename), "%s_kern.o", argv[0]);
 	setrlimit(RLIMIT_MEMLOCK, &r);
@@ -295,9 +305,20 @@ int main(int argc, char **argv)
 		return 1;
 	}
 
-	if (load_bpf_file(filename)) {
-		printf("%s", bpf_log_buf);
-		return 2;
+	if (bpf_prog_load(filename, BPF_PROG_TYPE_PERF_EVENT, &obj, &prog_fd))
+		return 1;
+
+	prog = bpf_program__next(NULL, obj);
+	if (!prog) {
+		printf("finding a prog in obj file failed\n");
+		return 1;
+	}
+
+	map_fd[0] = bpf_object__find_map_fd_by_name(obj, "counts");
+	map_fd[1] = bpf_object__find_map_fd_by_name(obj, "stackmap");
+	if (map_fd[0] < 0 || map_fd[1] < 0) {
+		printf("finding a counts/stackmap map in obj file failed\n");
+		return 1;
 	}
 
 	if (fork() == 0) {
-- 
2.25.1

