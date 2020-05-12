Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A3761CF788
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 16:44:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729382AbgELOnv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 10:43:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726055AbgELOnu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 10:43:50 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 783C8C061A0C;
        Tue, 12 May 2020 07:43:50 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id a7so9509646pju.2;
        Tue, 12 May 2020 07:43:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mCDKgW4OvG6cvNVG3/sGHRXZYiIJxQLc1V+nqtERAPw=;
        b=soIElSoXSHSvNrkLUqSsWyuUzzV+agMCQurO+N5oVhGa6rETQR7U3EkN1rtB2WZcOW
         Hwz38/PkktpiGS8Ahn7QHATtOvvLVwTdg2wU9+rIfdAUPUSL7XqePPtHoCXVeLg7hGtF
         +TgojZ5ysJtSheVAlEPKVQthNSiyB2FZ0tacV7w/xkQOAj/dqg729lMetVT1cG5FUHC/
         WBKHded7ZVb4idzRl0QVr5jAZnT/lyHiQsx4kZ9ai9gQ9YuK3axFxzTlQum63XIhgRjw
         m+8m7d8T2CbXiXdp5coNOs4fJ4sn+LwHCz5rnn8qZDjZdBDZrJgb5ra6UyQo3KHGy7eR
         OUuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mCDKgW4OvG6cvNVG3/sGHRXZYiIJxQLc1V+nqtERAPw=;
        b=nEH/A6UKR1fFQg399prNuFCwALfi8gk8ooCeR04pgXSSofos4rXBSPfqEgCv1o+bm6
         fY36iooCh/1LgAQibKM0XLlRq6mp+gedAlJFkf4c6fe9uJRggdCex4WjY0ycN45WmVug
         vMZUEwN7g80Ay/SqrfClQdkPPw9fdzG21pzN1WQCbj3+u7jOTmbcYMmsGVfua6DxDqBd
         JWlvKf+7+4ePmWqZCNQ0tAfixRNj/FM0XGklCa3mqqKBlTQu70TvcqvvTmlc7XA26BUt
         sDYPV/SvnovPSd7Vb7zbEXedUaCQVV+25/FX0LtrovAV/f1Ac5mIl2y1dOmudDNDD2r8
         trZw==
X-Gm-Message-State: AGi0PuYdWXKI82DsO5DkToiHJf43RWW7gL8VueXNHuQfYbEi49GadNH/
        OdWLpsy2AKA8MD1rvt+zjQ==
X-Google-Smtp-Source: APiQypLS0/AvmgwLbUYJVl+t+l5JTZqJ9T4q+Ck4I8zwapP6yTITxyO3Q6e5Iv+oqHWg7gJPkg0enQ==
X-Received: by 2002:a17:90a:252b:: with SMTP id j40mr27737344pje.60.1589294629947;
        Tue, 12 May 2020 07:43:49 -0700 (PDT)
Received: from localhost.localdomain ([219.255.158.173])
        by smtp.gmail.com with ESMTPSA id w11sm10786581pgj.4.2020.05.12.07.43.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 May 2020 07:43:49 -0700 (PDT)
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>
Subject: [PATCH bpf-next 1/3] samples: bpf: refactor kprobe tracing user progs with libbpf
Date:   Tue, 12 May 2020 23:43:37 +0900
Message-Id: <20200512144339.1617069-2-danieltimlee@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200512144339.1617069-1-danieltimlee@gmail.com>
References: <20200512144339.1617069-1-danieltimlee@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, the kprobe BPF program attachment method for bpf_load is
quite old. The implementation of bpf_load "directly" controls and
manages(create, delete) the kprobe events of DEBUGFS. On the other hand,
using using the libbpf automatically manages the kprobe event.
(under bpf_link interface)

By calling bpf_program__attach(_kprobe) in libbpf, the corresponding
kprobe is created and the BPF program will be attached to this kprobe.
To remove this, by simply invoking bpf_link__destroy will clean up the
event.

This commit refactors kprobe tracing programs (tracex{1~7}_user.c) with
libbpf using bpf_link interface and bpf_program__attach.

tracex2_kern.c, which tracks system calls (sys_*), has been modified to
append prefix depending on architecture.

Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
---
 samples/bpf/Makefile       | 12 +++----
 samples/bpf/tracex1_user.c | 41 ++++++++++++++++++++----
 samples/bpf/tracex2_kern.c |  8 ++++-
 samples/bpf/tracex2_user.c | 55 ++++++++++++++++++++++++++------
 samples/bpf/tracex3_user.c | 65 ++++++++++++++++++++++++++++----------
 samples/bpf/tracex4_user.c | 55 +++++++++++++++++++++++++-------
 samples/bpf/tracex6_user.c | 53 +++++++++++++++++++++++++++----
 samples/bpf/tracex7_user.c | 43 ++++++++++++++++++++-----
 8 files changed, 268 insertions(+), 64 deletions(-)

diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
index 424f6fe7ce38..4c91e5914329 100644
--- a/samples/bpf/Makefile
+++ b/samples/bpf/Makefile
@@ -64,13 +64,13 @@ fds_example-objs := fds_example.o
 sockex1-objs := sockex1_user.o
 sockex2-objs := sockex2_user.o
 sockex3-objs := bpf_load.o sockex3_user.o
-tracex1-objs := bpf_load.o tracex1_user.o $(TRACE_HELPERS)
-tracex2-objs := bpf_load.o tracex2_user.o
-tracex3-objs := bpf_load.o tracex3_user.o
-tracex4-objs := bpf_load.o tracex4_user.o
+tracex1-objs := tracex1_user.o $(TRACE_HELPERS)
+tracex2-objs := tracex2_user.o
+tracex3-objs := tracex3_user.o
+tracex4-objs := tracex4_user.o
 tracex5-objs := bpf_load.o tracex5_user.o $(TRACE_HELPERS)
-tracex6-objs := bpf_load.o tracex6_user.o
-tracex7-objs := bpf_load.o tracex7_user.o
+tracex6-objs := tracex6_user.o
+tracex7-objs := tracex7_user.o
 test_probe_write_user-objs := bpf_load.o test_probe_write_user_user.o
 trace_output-objs := bpf_load.o trace_output_user.o $(TRACE_HELPERS)
 lathist-objs := bpf_load.o lathist_user.o
diff --git a/samples/bpf/tracex1_user.c b/samples/bpf/tracex1_user.c
index 55fddbd08702..1b15ab98f7d3 100644
--- a/samples/bpf/tracex1_user.c
+++ b/samples/bpf/tracex1_user.c
@@ -1,21 +1,45 @@
 // SPDX-License-Identifier: GPL-2.0
 #include <stdio.h>
-#include <linux/bpf.h>
 #include <unistd.h>
-#include <bpf/bpf.h>
-#include "bpf_load.h"
+#include <bpf/libbpf.h>
 #include "trace_helpers.h"
 
+#define __must_check
+#include <linux/err.h>
+
 int main(int ac, char **argv)
 {
-	FILE *f;
+	struct bpf_link *link = NULL;
+	struct bpf_program *prog;
+	struct bpf_object *obj;
 	char filename[256];
+	FILE *f;
 
 	snprintf(filename, sizeof(filename), "%s_kern.o", argv[0]);
+	obj = bpf_object__open_file(filename, NULL);
+	if (IS_ERR(obj)) {
+		fprintf(stderr, "ERROR: opening BPF object file failed\n");
+		obj = NULL;
+		goto cleanup;
+	}
+
+	prog = bpf_object__find_program_by_name(obj, "bpf_prog1");
+	if (!prog) {
+		fprintf(stderr, "ERROR: finding a prog in obj file failed\n");
+		goto cleanup;
+	}
+
+	/* load BPF program */
+	if (bpf_object__load(obj)) {
+		fprintf(stderr, "ERROR: loading BPF object file failed\n");
+		goto cleanup;
+	}
 
-	if (load_bpf_file(filename)) {
-		printf("%s", bpf_log_buf);
-		return 1;
+	link = bpf_program__attach(prog);
+	if (IS_ERR(link)) {
+		fprintf(stderr, "ERROR: bpf_program__attach failed\n");
+		link = NULL;
+		goto cleanup;
 	}
 
 	f = popen("taskset 1 ping -c5 localhost", "r");
@@ -23,5 +47,8 @@ int main(int ac, char **argv)
 
 	read_trace_pipe();
 
+cleanup:
+	bpf_link__destroy(link);
+	bpf_object__close(obj);
 	return 0;
 }
diff --git a/samples/bpf/tracex2_kern.c b/samples/bpf/tracex2_kern.c
index d865bb309bcb..ff5d00916733 100644
--- a/samples/bpf/tracex2_kern.c
+++ b/samples/bpf/tracex2_kern.c
@@ -11,6 +11,12 @@
 #include <bpf/bpf_helpers.h>
 #include <bpf/bpf_tracing.h>
 
+#ifdef __x86_64__
+#define SYSCALL "__x64_"
+#else
+#define SYSCALL
+#endif
+
 struct bpf_map_def SEC("maps") my_map = {
 	.type = BPF_MAP_TYPE_HASH,
 	.key_size = sizeof(long),
@@ -77,7 +83,7 @@ struct bpf_map_def SEC("maps") my_hist_map = {
 	.max_entries = 1024,
 };
 
-SEC("kprobe/sys_write")
+SEC("kprobe/" SYSCALL "sys_write")
 int bpf_prog3(struct pt_regs *ctx)
 {
 	long write_size = PT_REGS_PARM3(ctx);
diff --git a/samples/bpf/tracex2_user.c b/samples/bpf/tracex2_user.c
index c9544a4ce61a..71bdf2a9543f 100644
--- a/samples/bpf/tracex2_user.c
+++ b/samples/bpf/tracex2_user.c
@@ -3,17 +3,22 @@
 #include <unistd.h>
 #include <stdlib.h>
 #include <signal.h>
-#include <linux/bpf.h>
 #include <string.h>
 #include <sys/resource.h>
 
 #include <bpf/bpf.h>
-#include "bpf_load.h"
+#include <bpf/libbpf.h>
 #include "bpf_util.h"
 
+#define __must_check
+#include <linux/err.h>
+
 #define MAX_INDEX	64
 #define MAX_STARS	38
 
+/* my_map, my_hist_map */
+static int map_fd[2];
+
 static void stars(char *str, long val, long max, int width)
 {
 	int i;
@@ -115,18 +120,40 @@ static void int_exit(int sig)
 int main(int ac, char **argv)
 {
 	struct rlimit r = {1024*1024, RLIM_INFINITY};
-	char filename[256];
 	long key, next_key, value;
+	struct bpf_link *links[2];
+	struct bpf_program *prog;
+	struct bpf_object *obj;
+	char filename[256];
+	int i, j = 0;
 	FILE *f;
-	int i;
-
-	snprintf(filename, sizeof(filename), "%s_kern.o", argv[0]);
 
 	if (setrlimit(RLIMIT_MEMLOCK, &r)) {
 		perror("setrlimit(RLIMIT_MEMLOCK)");
 		return 1;
 	}
 
+	snprintf(filename, sizeof(filename), "%s_kern.o", argv[0]);
+	obj = bpf_object__open_file(filename, NULL);
+	if (IS_ERR(obj)) {
+		fprintf(stderr, "ERROR: opening BPF object file failed\n");
+		obj = NULL;
+		goto cleanup;
+	}
+
+	/* load BPF program */
+	if (bpf_object__load(obj)) {
+		fprintf(stderr, "ERROR: loading BPF object file failed\n");
+		goto cleanup;
+	}
+
+	map_fd[0] = bpf_object__find_map_fd_by_name(obj, "my_map");
+	map_fd[1] = bpf_object__find_map_fd_by_name(obj, "my_hist_map");
+	if (map_fd[0] < 0 || map_fd[1] < 0) {
+		fprintf(stderr, "ERROR: finding a map in obj file failed\n");
+		goto cleanup;
+	}
+
 	signal(SIGINT, int_exit);
 	signal(SIGTERM, int_exit);
 
@@ -138,9 +165,14 @@ int main(int ac, char **argv)
 	f = popen("dd if=/dev/zero of=/dev/null count=5000000", "r");
 	(void) f;
 
-	if (load_bpf_file(filename)) {
-		printf("%s", bpf_log_buf);
-		return 1;
+	bpf_object__for_each_program(prog, obj) {
+		links[j] = bpf_program__attach(prog);
+		if (IS_ERR(links[j])) {
+			fprintf(stderr, "ERROR: bpf_program__attach failed\n");
+			links[j] = NULL;
+			goto cleanup;
+		}
+		j++;
 	}
 
 	for (i = 0; i < 5; i++) {
@@ -156,5 +188,10 @@ int main(int ac, char **argv)
 	}
 	print_hist(map_fd[1]);
 
+cleanup:
+	for (j--; j >= 0; j--)
+		bpf_link__destroy(links[j]);
+
+	bpf_object__close(obj);
 	return 0;
 }
diff --git a/samples/bpf/tracex3_user.c b/samples/bpf/tracex3_user.c
index cf8fedc773f2..3045e118199a 100644
--- a/samples/bpf/tracex3_user.c
+++ b/samples/bpf/tracex3_user.c
@@ -7,13 +7,15 @@
 #include <unistd.h>
 #include <stdbool.h>
 #include <string.h>
-#include <linux/bpf.h>
 #include <sys/resource.h>
 
 #include <bpf/bpf.h>
-#include "bpf_load.h"
+#include <bpf/libbpf.h>
 #include "bpf_util.h"
 
+#define __must_check
+#include <linux/err.h>
+
 #define SLOTS 100
 
 static void clear_stats(int fd)
@@ -109,20 +111,11 @@ static void print_hist(int fd)
 int main(int ac, char **argv)
 {
 	struct rlimit r = {1024*1024, RLIM_INFINITY};
+	struct bpf_link *links[2];
+	struct bpf_program *prog;
+	struct bpf_object *obj;
 	char filename[256];
-	int i;
-
-	snprintf(filename, sizeof(filename), "%s_kern.o", argv[0]);
-
-	if (setrlimit(RLIMIT_MEMLOCK, &r)) {
-		perror("setrlimit(RLIMIT_MEMLOCK)");
-		return 1;
-	}
-
-	if (load_bpf_file(filename)) {
-		printf("%s", bpf_log_buf);
-		return 1;
-	}
+	int map_fd, i, j = 0;
 
 	for (i = 1; i < ac; i++) {
 		if (strcmp(argv[i], "-a") == 0) {
@@ -137,6 +130,41 @@ int main(int ac, char **argv)
 		}
 	}
 
+	if (setrlimit(RLIMIT_MEMLOCK, &r)) {
+		perror("setrlimit(RLIMIT_MEMLOCK)");
+		return 1;
+	}
+
+	snprintf(filename, sizeof(filename), "%s_kern.o", argv[0]);
+	obj = bpf_object__open_file(filename, NULL);
+	if (IS_ERR(obj)) {
+		fprintf(stderr, "ERROR: opening BPF object file failed\n");
+		obj = NULL;
+		goto cleanup;
+	}
+
+	/* load BPF program */
+	if (bpf_object__load(obj)) {
+		fprintf(stderr, "ERROR: loading BPF object file failed\n");
+		goto cleanup;
+	}
+
+	map_fd = bpf_object__find_map_fd_by_name(obj, "lat_map");
+	if (map_fd < 0) {
+		fprintf(stderr, "ERROR: finding a map in obj file failed\n");
+		goto cleanup;
+	}
+
+	bpf_object__for_each_program(prog, obj) {
+		links[j] = bpf_program__attach(prog);
+		if (IS_ERR(links[j])) {
+			fprintf(stderr, "ERROR: bpf_program__attach failed\n");
+			links[j] = NULL;
+			goto cleanup;
+		}
+		j++;
+	}
+
 	printf("  heatmap of IO latency\n");
 	if (text_only)
 		printf("  %s", sym[num_colors - 1]);
@@ -153,9 +181,14 @@ int main(int ac, char **argv)
 	for (i = 0; ; i++) {
 		if (i % 20 == 0)
 			print_banner();
-		print_hist(map_fd[1]);
+		print_hist(map_fd);
 		sleep(2);
 	}
 
+cleanup:
+	for (j--; j >= 0; j--)
+		bpf_link__destroy(links[j]);
+
+	bpf_object__close(obj);
 	return 0;
 }
diff --git a/samples/bpf/tracex4_user.c b/samples/bpf/tracex4_user.c
index ec52203fce39..a131a48bc15a 100644
--- a/samples/bpf/tracex4_user.c
+++ b/samples/bpf/tracex4_user.c
@@ -8,11 +8,13 @@
 #include <stdbool.h>
 #include <string.h>
 #include <time.h>
-#include <linux/bpf.h>
 #include <sys/resource.h>
 
 #include <bpf/bpf.h>
-#include "bpf_load.h"
+#include <bpf/libbpf.h>
+
+#define __must_check
+#include <linux/err.h>
 
 struct pair {
 	long long val;
@@ -36,8 +38,8 @@ static void print_old_objects(int fd)
 	key = write(1, "\e[1;1H\e[2J", 12); /* clear screen */
 
 	key = -1;
-	while (bpf_map_get_next_key(map_fd[0], &key, &next_key) == 0) {
-		bpf_map_lookup_elem(map_fd[0], &next_key, &v);
+	while (bpf_map_get_next_key(fd, &key, &next_key) == 0) {
+		bpf_map_lookup_elem(fd, &next_key, &v);
 		key = next_key;
 		if (val - v.val < 1000000000ll)
 			/* object was allocated more then 1 sec ago */
@@ -50,25 +52,56 @@ static void print_old_objects(int fd)
 int main(int ac, char **argv)
 {
 	struct rlimit r = {RLIM_INFINITY, RLIM_INFINITY};
+	struct bpf_link *links[2];
+	struct bpf_program *prog;
+	struct bpf_object *obj;
 	char filename[256];
-	int i;
-
-	snprintf(filename, sizeof(filename), "%s_kern.o", argv[0]);
+	int map_fd, i, j = 0;
 
 	if (setrlimit(RLIMIT_MEMLOCK, &r)) {
 		perror("setrlimit(RLIMIT_MEMLOCK, RLIM_INFINITY)");
 		return 1;
 	}
 
-	if (load_bpf_file(filename)) {
-		printf("%s", bpf_log_buf);
-		return 1;
+	snprintf(filename, sizeof(filename), "%s_kern.o", argv[0]);
+	obj = bpf_object__open_file(filename, NULL);
+	if (IS_ERR(obj)) {
+		fprintf(stderr, "ERROR: opening BPF object file failed\n");
+		obj = NULL;
+		goto cleanup;
+	}
+
+	/* load BPF program */
+	if (bpf_object__load(obj)) {
+		fprintf(stderr, "ERROR: loading BPF object file failed\n");
+		goto cleanup;
+	}
+
+	map_fd = bpf_object__find_map_fd_by_name(obj, "my_map");
+	if (map_fd < 0) {
+		fprintf(stderr, "ERROR: finding a map in obj file failed\n");
+		goto cleanup;
+	}
+
+	bpf_object__for_each_program(prog, obj) {
+		links[j] = bpf_program__attach(prog);
+		if (IS_ERR(links[j])) {
+			fprintf(stderr, "ERROR: bpf_program__attach failed\n");
+			links[j] = NULL;
+			goto cleanup;
+		}
+		j++;
 	}
 
 	for (i = 0; ; i++) {
-		print_old_objects(map_fd[1]);
+		print_old_objects(map_fd);
 		sleep(1);
 	}
 
+cleanup:
+	for (j--; j >= 0; j--)
+		bpf_link__destroy(links[j]);
+
+	bpf_object__close(obj);
 	return 0;
 }
diff --git a/samples/bpf/tracex6_user.c b/samples/bpf/tracex6_user.c
index 4bb3c830adb2..e363dcb1c2dd 100644
--- a/samples/bpf/tracex6_user.c
+++ b/samples/bpf/tracex6_user.c
@@ -4,7 +4,6 @@
 #include <assert.h>
 #include <fcntl.h>
 #include <linux/perf_event.h>
-#include <linux/bpf.h>
 #include <sched.h>
 #include <stdio.h>
 #include <stdlib.h>
@@ -15,12 +14,18 @@
 #include <sys/wait.h>
 #include <unistd.h>
 
-#include "bpf_load.h"
 #include <bpf/bpf.h>
+#include <bpf/libbpf.h>
 #include "perf-sys.h"
 
+#define __must_check
+#include <linux/err.h>
+
 #define SAMPLE_PERIOD  0x7fffffffffffffffULL
 
+/* counters, values, values2 */
+static int map_fd[3];
+
 static void check_on_cpu(int cpu, struct perf_event_attr *attr)
 {
 	struct bpf_perf_event_value value2;
@@ -174,16 +179,52 @@ static void test_bpf_perf_event(void)
 int main(int argc, char **argv)
 {
 	struct rlimit r = {RLIM_INFINITY, RLIM_INFINITY};
+	struct bpf_link *links[2];
+	struct bpf_program *prog;
+	struct bpf_object *obj;
 	char filename[256];
+	int i = 0;
+
+	setrlimit(RLIMIT_MEMLOCK, &r);
 
 	snprintf(filename, sizeof(filename), "%s_kern.o", argv[0]);
+	obj = bpf_object__open_file(filename, NULL);
+	if (IS_ERR(obj)) {
+		fprintf(stderr, "ERROR: opening BPF object file failed\n");
+		obj = NULL;
+		goto cleanup;
+	}
 
-	setrlimit(RLIMIT_MEMLOCK, &r);
-	if (load_bpf_file(filename)) {
-		printf("%s", bpf_log_buf);
-		return 1;
+	/* load BPF program */
+	if (bpf_object__load(obj)) {
+		fprintf(stderr, "ERROR: loading BPF object file failed\n");
+		goto cleanup;
+	}
+
+	map_fd[0] = bpf_object__find_map_fd_by_name(obj, "counters");
+	map_fd[1] = bpf_object__find_map_fd_by_name(obj, "values");
+	map_fd[2] = bpf_object__find_map_fd_by_name(obj, "values2");
+	if (map_fd[0] < 0 || map_fd[1] < 0 || map_fd[2] < 0) {
+		fprintf(stderr, "ERROR: finding a map in obj file failed\n");
+		goto cleanup;
+	}
+
+	bpf_object__for_each_program(prog, obj) {
+		links[i] = bpf_program__attach(prog);
+		if (IS_ERR(links[i])) {
+			fprintf(stderr, "ERROR: bpf_program__attach failed\n");
+			links[i] = NULL;
+			goto cleanup;
+		}
+		i++;
 	}
 
 	test_bpf_perf_event();
+
+cleanup:
+	for (i--; i >= 0; i--)
+		bpf_link__destroy(links[i]);
+
+	bpf_object__close(obj);
 	return 0;
 }
diff --git a/samples/bpf/tracex7_user.c b/samples/bpf/tracex7_user.c
index ea6dae78f0df..699755eb6850 100644
--- a/samples/bpf/tracex7_user.c
+++ b/samples/bpf/tracex7_user.c
@@ -1,28 +1,55 @@
 #define _GNU_SOURCE
 
 #include <stdio.h>
-#include <linux/bpf.h>
 #include <unistd.h>
-#include <bpf/bpf.h>
-#include "bpf_load.h"
+#include <bpf/libbpf.h>
+
+#define __must_check
+#include <linux/err.h>
 
 int main(int argc, char **argv)
 {
-	FILE *f;
+	struct bpf_link *link = NULL;
+	struct bpf_program *prog;
+	struct bpf_object *obj;
 	char filename[256];
 	char command[256];
-	int ret;
+	int ret = 0;
+	FILE *f;
 
 	snprintf(filename, sizeof(filename), "%s_kern.o", argv[0]);
+	obj = bpf_object__open_file(filename, NULL);
+	if (IS_ERR(obj)) {
+		fprintf(stderr, "ERROR: opening BPF object file failed\n");
+		obj = NULL;
+		goto cleanup;
+	}
+
+	prog = bpf_object__find_program_by_name(obj, "bpf_prog1");
+	if (!prog) {
+		fprintf(stderr, "ERROR: finding a prog in obj file failed\n");
+		goto cleanup;
+	}
+
+	/* load BPF program */
+	if (bpf_object__load(obj)) {
+		fprintf(stderr, "ERROR: loading BPF object file failed\n");
+		goto cleanup;
+	}
 
-	if (load_bpf_file(filename)) {
-		printf("%s", bpf_log_buf);
-		return 1;
+	link = bpf_program__attach(prog);
+	if (IS_ERR(link)) {
+		fprintf(stderr, "ERROR: bpf_program__attach failed\n");
+		link = NULL;
+		goto cleanup;
 	}
 
 	snprintf(command, 256, "mount %s tmpmnt/", argv[1]);
 	f = popen(command, "r");
 	ret = pclose(f);
 
+cleanup:
+	bpf_link__destroy(link);
+	bpf_object__close(obj);
 	return ret ? 0 : 1;
 }
-- 
2.25.1

