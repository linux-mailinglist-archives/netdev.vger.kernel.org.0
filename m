Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A700A1D5E66
	for <lists+netdev@lfdr.de>; Sat, 16 May 2020 06:06:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726591AbgEPEGY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 May 2020 00:06:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725275AbgEPEGW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 May 2020 00:06:22 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3DE3C061A0C;
        Fri, 15 May 2020 21:06:21 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id b190so1979606pfg.6;
        Fri, 15 May 2020 21:06:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4bkCYAyCLpWXPMIeX9khejTQn+aDjYTmgkU8aZ+L2NE=;
        b=h6NdwQROtZfXaFruZGolxJ/PXWYyVYmW/fcBv0phh/HupNER0hu6Nyz1C5Ogd6kJuq
         ZTENmL1dnnskpFjz0ylzVm2m/4xqSHcI5mvLXjNdH4jtPd1iT9c1pwtnQjy4z+qiYK/K
         e1YPwRJ7+2jm/7iEkp7YtrM1MuVVgoEC06N9etVO604EmkTY82aGcEKX6ArW8kdhsEiY
         /xQmkcbZwr51PyISC6hc1P8VFKQ058kaDxRWL4c3C4KQRof1CYoDAhcHhU2nh9kGYriv
         EexFsTqg7Sr/OAgypnqGKH2HigKZoj0ly1vLdtOai7V189DQuk79FjNiEkhEOM/MuSgi
         ER5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4bkCYAyCLpWXPMIeX9khejTQn+aDjYTmgkU8aZ+L2NE=;
        b=Gssm9kiHwWWKRD6asMHP9I1ARjCPo9QcTM2yf6Wz1q9gu536+e/VYPwGxB+ikE8Jtq
         wgpcJyCc2CO/I9tYSNezjl+bcM6xJ7++Qyx8Yw6rUDzWTE1iPyQXDCxph4BGv2zWZm35
         pMSnNRd7l0H6jeVFQ4rZWeaJRmZcXOaYhFMmghNmNQE59fg7/mRn2pHj6nxrbHswWEi2
         jVCo/0sWbBlhasUY5SnqMgsLXf9fSE9S9rRA6PGR4gOmdzAtmgWTOw3jGiVAD65aJH1t
         CXZtmEy7ebl0KRITr2ja1WtyKjo4XT280KiX4dQTpnid9zo62JIk/TfrYZGYvdllqxUg
         7LHQ==
X-Gm-Message-State: AOAM532iFVA4/W82Wfng1PdaVCTEr/5/Uqkr/eceHHSwAew8cZXk2i0K
        jl/F5tbIxdA3iBY0p9LP+A==
X-Google-Smtp-Source: ABdhPJzgD/w2MVT1+WNtQSS7MpnWa89yfrEG2JrW2H/bkO6T3zogXxYbVdcpe/1Rbfif7QdU5QMzhA==
X-Received: by 2002:a63:514:: with SMTP id 20mr6071588pgf.150.1589601981395;
        Fri, 15 May 2020 21:06:21 -0700 (PDT)
Received: from localhost.localdomain ([219.255.158.173])
        by smtp.gmail.com with ESMTPSA id b11sm98663pjz.54.2020.05.15.21.06.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 May 2020 21:06:20 -0700 (PDT)
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Yonghong Song <yhs@fb.com>
Subject: [PATCH bpf-next v2 2/5] samples: bpf: refactor kprobe tracing user progs with libbpf
Date:   Sat, 16 May 2020 13:06:05 +0900
Message-Id: <20200516040608.1377876-3-danieltimlee@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200516040608.1377876-1-danieltimlee@gmail.com>
References: <20200516040608.1377876-1-danieltimlee@gmail.com>
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
Changes in V2:
 - refactor pointer error check with libbpf_get_error
 - on bpf object open failure, return instead jump to cleanup
 - add macro for adding architecture prefix to system calls (sys_*)

 samples/bpf/Makefile       | 12 ++++----
 samples/bpf/trace_common.h | 13 ++++++++
 samples/bpf/tracex1_user.c | 37 ++++++++++++++++++-----
 samples/bpf/tracex2_kern.c |  3 +-
 samples/bpf/tracex2_user.c | 51 +++++++++++++++++++++++++------
 samples/bpf/tracex3_user.c | 61 ++++++++++++++++++++++++++++----------
 samples/bpf/tracex4_user.c | 51 ++++++++++++++++++++++++-------
 samples/bpf/tracex6_user.c | 49 ++++++++++++++++++++++++++----
 samples/bpf/tracex7_user.c | 39 +++++++++++++++++++-----
 9 files changed, 252 insertions(+), 64 deletions(-)
 create mode 100644 samples/bpf/trace_common.h

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
diff --git a/samples/bpf/trace_common.h b/samples/bpf/trace_common.h
new file mode 100644
index 000000000000..8cb5400aed1f
--- /dev/null
+++ b/samples/bpf/trace_common.h
@@ -0,0 +1,13 @@
+// SPDX-License-Identifier: GPL-2.0
+#ifndef __TRACE_COMMON_H
+#define __TRACE_COMMON_H
+
+#ifdef __x86_64__
+#define SYSCALL(SYS) "__x64_" __stringify(SYS)
+#elif defined(__s390x__)
+#define SYSCALL(SYS) "__s390x_" __stringify(SYS)
+#else
+#define SYSCALL(SYS)  __stringify(SYS)
+#endif
+
+#endif
diff --git a/samples/bpf/tracex1_user.c b/samples/bpf/tracex1_user.c
index 55fddbd08702..9d4adb7fd834 100644
--- a/samples/bpf/tracex1_user.c
+++ b/samples/bpf/tracex1_user.c
@@ -1,21 +1,41 @@
 // SPDX-License-Identifier: GPL-2.0
 #include <stdio.h>
-#include <linux/bpf.h>
 #include <unistd.h>
-#include <bpf/bpf.h>
-#include "bpf_load.h"
+#include <bpf/libbpf.h>
 #include "trace_helpers.h"
 
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
+	if (libbpf_get_error(obj)) {
+		fprintf(stderr, "ERROR: opening BPF object file failed\n");
+		return 0;
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
+	if (libbpf_get_error(link)) {
+		fprintf(stderr, "ERROR: bpf_program__attach failed\n");
+		link = NULL;
+		goto cleanup;
 	}
 
 	f = popen("taskset 1 ping -c5 localhost", "r");
@@ -23,5 +43,8 @@ int main(int ac, char **argv)
 
 	read_trace_pipe();
 
+cleanup:
+	bpf_link__destroy(link);
+	bpf_object__close(obj);
 	return 0;
 }
diff --git a/samples/bpf/tracex2_kern.c b/samples/bpf/tracex2_kern.c
index d865bb309bcb..cc5f94c098f8 100644
--- a/samples/bpf/tracex2_kern.c
+++ b/samples/bpf/tracex2_kern.c
@@ -10,6 +10,7 @@
 #include <uapi/linux/bpf.h>
 #include <bpf/bpf_helpers.h>
 #include <bpf/bpf_tracing.h>
+#include "trace_common.h"
 
 struct bpf_map_def SEC("maps") my_map = {
 	.type = BPF_MAP_TYPE_HASH,
@@ -77,7 +78,7 @@ struct bpf_map_def SEC("maps") my_hist_map = {
 	.max_entries = 1024,
 };
 
-SEC("kprobe/sys_write")
+SEC("kprobe/" SYSCALL(sys_write))
 int bpf_prog3(struct pt_regs *ctx)
 {
 	long write_size = PT_REGS_PARM3(ctx);
diff --git a/samples/bpf/tracex2_user.c b/samples/bpf/tracex2_user.c
index c9544a4ce61a..3e36b3e4e3ef 100644
--- a/samples/bpf/tracex2_user.c
+++ b/samples/bpf/tracex2_user.c
@@ -3,17 +3,19 @@
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
 
 #define MAX_INDEX	64
 #define MAX_STARS	38
 
+/* my_map, my_hist_map */
+static int map_fd[2];
+
 static void stars(char *str, long val, long max, int width)
 {
 	int i;
@@ -115,18 +117,39 @@ static void int_exit(int sig)
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
+	if (libbpf_get_error(obj)) {
+		fprintf(stderr, "ERROR: opening BPF object file failed\n");
+		return 0;
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
 
@@ -138,9 +161,14 @@ int main(int ac, char **argv)
 	f = popen("dd if=/dev/zero of=/dev/null count=5000000", "r");
 	(void) f;
 
-	if (load_bpf_file(filename)) {
-		printf("%s", bpf_log_buf);
-		return 1;
+	bpf_object__for_each_program(prog, obj) {
+		links[j] = bpf_program__attach(prog);
+		if (libbpf_get_error(links[j])) {
+			fprintf(stderr, "ERROR: bpf_program__attach failed\n");
+			links[j] = NULL;
+			goto cleanup;
+		}
+		j++;
 	}
 
 	for (i = 0; i < 5; i++) {
@@ -156,5 +184,10 @@ int main(int ac, char **argv)
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
index cf8fedc773f2..70e987775c15 100644
--- a/samples/bpf/tracex3_user.c
+++ b/samples/bpf/tracex3_user.c
@@ -7,11 +7,10 @@
 #include <unistd.h>
 #include <stdbool.h>
 #include <string.h>
-#include <linux/bpf.h>
 #include <sys/resource.h>
 
 #include <bpf/bpf.h>
-#include "bpf_load.h"
+#include <bpf/libbpf.h>
 #include "bpf_util.h"
 
 #define SLOTS 100
@@ -109,20 +108,11 @@ static void print_hist(int fd)
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
@@ -137,6 +127,40 @@ int main(int ac, char **argv)
 		}
 	}
 
+	if (setrlimit(RLIMIT_MEMLOCK, &r)) {
+		perror("setrlimit(RLIMIT_MEMLOCK)");
+		return 1;
+	}
+
+	snprintf(filename, sizeof(filename), "%s_kern.o", argv[0]);
+	obj = bpf_object__open_file(filename, NULL);
+	if (libbpf_get_error(obj)) {
+		fprintf(stderr, "ERROR: opening BPF object file failed\n");
+		return 0;
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
+		if (libbpf_get_error(links[j])) {
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
@@ -153,9 +177,14 @@ int main(int ac, char **argv)
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
index ec52203fce39..e8faf8f184ae 100644
--- a/samples/bpf/tracex4_user.c
+++ b/samples/bpf/tracex4_user.c
@@ -8,11 +8,10 @@
 #include <stdbool.h>
 #include <string.h>
 #include <time.h>
-#include <linux/bpf.h>
 #include <sys/resource.h>
 
 #include <bpf/bpf.h>
-#include "bpf_load.h"
+#include <bpf/libbpf.h>
 
 struct pair {
 	long long val;
@@ -36,8 +35,8 @@ static void print_old_objects(int fd)
 	key = write(1, "\e[1;1H\e[2J", 12); /* clear screen */
 
 	key = -1;
-	while (bpf_map_get_next_key(map_fd[0], &key, &next_key) == 0) {
-		bpf_map_lookup_elem(map_fd[0], &next_key, &v);
+	while (bpf_map_get_next_key(fd, &key, &next_key) == 0) {
+		bpf_map_lookup_elem(fd, &next_key, &v);
 		key = next_key;
 		if (val - v.val < 1000000000ll)
 			/* object was allocated more then 1 sec ago */
@@ -50,25 +49,55 @@ static void print_old_objects(int fd)
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
+	if (libbpf_get_error(obj)) {
+		fprintf(stderr, "ERROR: opening BPF object file failed\n");
+		return 0;
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
+		if (libbpf_get_error(links[j])) {
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
index 4bb3c830adb2..33df9784775d 100644
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
@@ -15,12 +14,15 @@
 #include <sys/wait.h>
 #include <unistd.h>
 
-#include "bpf_load.h"
 #include <bpf/bpf.h>
+#include <bpf/libbpf.h>
 #include "perf-sys.h"
 
 #define SAMPLE_PERIOD  0x7fffffffffffffffULL
 
+/* counters, values, values2 */
+static int map_fd[3];
+
 static void check_on_cpu(int cpu, struct perf_event_attr *attr)
 {
 	struct bpf_perf_event_value value2;
@@ -174,16 +176,51 @@ static void test_bpf_perf_event(void)
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
+	if (libbpf_get_error(obj)) {
+		fprintf(stderr, "ERROR: opening BPF object file failed\n");
+		return 0;
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
+		if (libbpf_get_error(links[i])) {
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
index ea6dae78f0df..fdcd6580dd73 100644
--- a/samples/bpf/tracex7_user.c
+++ b/samples/bpf/tracex7_user.c
@@ -1,28 +1,51 @@
 #define _GNU_SOURCE
 
 #include <stdio.h>
-#include <linux/bpf.h>
 #include <unistd.h>
-#include <bpf/bpf.h>
-#include "bpf_load.h"
+#include <bpf/libbpf.h>
 
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
+	if (libbpf_get_error(obj)) {
+		fprintf(stderr, "ERROR: opening BPF object file failed\n");
+		return 0;
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
+	if (libbpf_get_error(link)) {
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

