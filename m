Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B34524EC45
	for <lists+netdev@lfdr.de>; Sun, 23 Aug 2020 10:54:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728604AbgHWIx5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Aug 2020 04:53:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728554AbgHWIxw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Aug 2020 04:53:52 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD4E4C061573;
        Sun, 23 Aug 2020 01:53:51 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id y6so2787855plk.10;
        Sun, 23 Aug 2020 01:53:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FXg9rbqhSxdxG9tmlKNfpxDFoTF+pzPSiBWeJzROm6M=;
        b=mg35mkMMbbczFL+fhj6zF3BtYWPHq17RDyvMT1sabc7yi2slZSZLgDgSQpem3zQ4+9
         iXe9sVxLJjw3Nfxms4AU2gmxMEC1U6rui+PhdQ3FP8lFnPyxaJIhh+X3oUIRTA0U39+A
         R19BsvLXjBJXG9+oWYEEwKbSBUBjDumAseav2x9ZFkUuhHVCo87SrVQkWbfGeUYPodyW
         hSUiAVYWLc9GIApF5ptmGJGshJVJPrXcFXZUd78fa1LFF7wbJf05Dff5/z/E1dx8xwXq
         oY7nZBGggdxwgVXu22BRWX/TSfCwN/UBDjnu/xTVQ7g+NDJknNniN0faHYGcbuapdk6K
         Q+SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FXg9rbqhSxdxG9tmlKNfpxDFoTF+pzPSiBWeJzROm6M=;
        b=Vy4V5tLeVEEf3UYdSmp+XHSZasmzuBgWx0pAyzq6OL6QmMTWmEYfdX81Ia4dBTCYfc
         OnkucXh3auOqlPWOaHElCNbiCjLw/cyaQ/CHZhrKTii0dzrpUT6dgr88JMMn+EdRmPlT
         FXwfHugVxRDDtzHvW+lRudCDuQQLJRKwiQAtK18kxDaFqs6ktKm9xCy+27sKhBPDum51
         /5c3FZGL+4OHVSXyeRXH3aFLWriurexkZBljSk5BG+eAxKa5wnPFoOEacafZ3FZHMHWD
         Rx4OrQMTuZsATgnMX9clM/n+30X9NbMnSip+UPBDmxjDXrnHRYKeDmGGR9vBjeJff/fZ
         iW7w==
X-Gm-Message-State: AOAM533+qs9zv9rdl8+wBPKPbEYtMtOQKsF+yFqNQ2sYSL2GxbwE71OD
        CjssNGfUP7oNNLImxj1E8A==
X-Google-Smtp-Source: ABdhPJxoFQaQekRC+XtaCSdXmvd3KS6jiyLFw0F9X5LKA6Ri+ybKR5fjycqXX9nIQVy8adrQKUSSUQ==
X-Received: by 2002:a17:90b:4c0f:: with SMTP id na15mr459204pjb.119.1598172830826;
        Sun, 23 Aug 2020 01:53:50 -0700 (PDT)
Received: from localhost.localdomain ([182.209.58.45])
        by smtp.gmail.com with ESMTPSA id b15sm6128446pgk.14.2020.08.23.01.53.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Aug 2020 01:53:50 -0700 (PDT)
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH bpf-next 2/3] samples: bpf: Refactor kprobe tracing programs with libbpf
Date:   Sun, 23 Aug 2020 17:53:33 +0900
Message-Id: <20200823085334.9413-3-danieltimlee@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200823085334.9413-1-danieltimlee@gmail.com>
References: <20200823085334.9413-1-danieltimlee@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For the problem of increasing fragmentation of the bpf loader programs,
instead of using bpf_loader.o, which is used in samples/bpf, this
commit refactors the existing kprobe tracing programs with libbbpf
bpf loader.

    - For kprobe events pointing to system calls, the SYSCALL() macro in
    trace_common.h was used.
    - Adding a kprobe event and attaching a bpf program to it was done
    through bpf_program_attach().
    - Instead of using the existing BPF MAP definition, MAP definition
    has been refactored with the new BTF-defined MAP format.

Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
---
 samples/bpf/Makefile                          | 10 +--
 samples/bpf/lathist_kern.c                    | 24 +++----
 samples/bpf/lathist_user.c                    | 42 ++++++++++--
 samples/bpf/spintest_kern.c                   | 36 +++++-----
 samples/bpf/spintest_user.c                   | 68 +++++++++++++++----
 .../bpf/test_current_task_under_cgroup_kern.c | 27 ++++----
 .../bpf/test_current_task_under_cgroup_user.c | 52 +++++++++++---
 samples/bpf/test_probe_write_user_kern.c      | 12 ++--
 samples/bpf/test_probe_write_user_user.c      | 49 ++++++++++---
 samples/bpf/trace_output_kern.c               | 15 ++--
 samples/bpf/trace_output_user.c               | 55 ++++++++++-----
 11 files changed, 272 insertions(+), 118 deletions(-)

diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
index 0cac89230c6d..c74d477474e2 100644
--- a/samples/bpf/Makefile
+++ b/samples/bpf/Makefile
@@ -71,11 +71,11 @@ tracex4-objs := tracex4_user.o
 tracex5-objs := tracex5_user.o $(TRACE_HELPERS)
 tracex6-objs := tracex6_user.o
 tracex7-objs := tracex7_user.o
-test_probe_write_user-objs := bpf_load.o test_probe_write_user_user.o
-trace_output-objs := bpf_load.o trace_output_user.o $(TRACE_HELPERS)
-lathist-objs := bpf_load.o lathist_user.o
+test_probe_write_user-objs := test_probe_write_user_user.o
+trace_output-objs := trace_output_user.o $(TRACE_HELPERS)
+lathist-objs := lathist_user.o
 offwaketime-objs := bpf_load.o offwaketime_user.o $(TRACE_HELPERS)
-spintest-objs := bpf_load.o spintest_user.o $(TRACE_HELPERS)
+spintest-objs := spintest_user.o $(TRACE_HELPERS)
 map_perf_test-objs := map_perf_test_user.o
 test_overhead-objs := bpf_load.o test_overhead_user.o
 test_cgrp2_array_pin-objs := test_cgrp2_array_pin.o
@@ -86,7 +86,7 @@ xdp1-objs := xdp1_user.o
 # reuse xdp1 source intentionally
 xdp2-objs := xdp1_user.o
 xdp_router_ipv4-objs := xdp_router_ipv4_user.o
-test_current_task_under_cgroup-objs := bpf_load.o $(CGROUP_HELPERS) \
+test_current_task_under_cgroup-objs := $(CGROUP_HELPERS) \
 				       test_current_task_under_cgroup_user.o
 trace_event-objs := trace_event_user.o $(TRACE_HELPERS)
 sampleip-objs := sampleip_user.o $(TRACE_HELPERS)
diff --git a/samples/bpf/lathist_kern.c b/samples/bpf/lathist_kern.c
index ca9c2e4e69aa..4adfcbbe6ef4 100644
--- a/samples/bpf/lathist_kern.c
+++ b/samples/bpf/lathist_kern.c
@@ -18,12 +18,12 @@
  * trace_preempt_[on|off] tracepoints hooks is not supported.
  */
 
-struct bpf_map_def SEC("maps") my_map = {
-	.type = BPF_MAP_TYPE_ARRAY,
-	.key_size = sizeof(int),
-	.value_size = sizeof(u64),
-	.max_entries = MAX_CPU,
-};
+struct {
+	__uint(type, BPF_MAP_TYPE_ARRAY);
+	__type(key, int);
+	__type(value, u64);
+	__uint(max_entries, MAX_CPU);
+} my_map SEC(".maps");
 
 SEC("kprobe/trace_preempt_off")
 int bpf_prog1(struct pt_regs *ctx)
@@ -61,12 +61,12 @@ static unsigned int log2l(unsigned long v)
 		return log2(v);
 }
 
-struct bpf_map_def SEC("maps") my_lat = {
-	.type = BPF_MAP_TYPE_ARRAY,
-	.key_size = sizeof(int),
-	.value_size = sizeof(long),
-	.max_entries = MAX_CPU * MAX_ENTRIES,
-};
+struct {
+	__uint(type, BPF_MAP_TYPE_ARRAY);
+	__type(key, int);
+	__type(value, long);
+	__uint(max_entries, MAX_CPU * MAX_ENTRIES);
+} my_lat SEC(".maps");
 
 SEC("kprobe/trace_preempt_on")
 int bpf_prog2(struct pt_regs *ctx)
diff --git a/samples/bpf/lathist_user.c b/samples/bpf/lathist_user.c
index 2ff2839a52d5..7d8ff2418303 100644
--- a/samples/bpf/lathist_user.c
+++ b/samples/bpf/lathist_user.c
@@ -6,9 +6,8 @@
 #include <unistd.h>
 #include <stdlib.h>
 #include <signal.h>
-#include <linux/bpf.h>
+#include <bpf/libbpf.h>
 #include <bpf/bpf.h>
-#include "bpf_load.h"
 
 #define MAX_ENTRIES	20
 #define MAX_CPU		4
@@ -81,20 +80,51 @@ static void get_data(int fd)
 
 int main(int argc, char **argv)
 {
+	struct bpf_link *links[2];
+	struct bpf_program *prog;
+	struct bpf_object *obj;
 	char filename[256];
+	int map_fd, i = 0;
 
 	snprintf(filename, sizeof(filename), "%s_kern.o", argv[0]);
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
 
-	if (load_bpf_file(filename)) {
-		printf("%s", bpf_log_buf);
-		return 1;
+	map_fd = bpf_object__find_map_fd_by_name(obj, "my_lat");
+	if (map_fd < 0) {
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
 
 	while (1) {
-		get_data(map_fd[1]);
+		get_data(map_fd);
 		print_hist();
 		sleep(5);
 	}
 
+cleanup:
+	for (i--; i >= 0; i--)
+		bpf_link__destroy(links[i]);
+
+	bpf_object__close(obj);
 	return 0;
 }
diff --git a/samples/bpf/spintest_kern.c b/samples/bpf/spintest_kern.c
index f508af357251..455da77319d9 100644
--- a/samples/bpf/spintest_kern.c
+++ b/samples/bpf/spintest_kern.c
@@ -12,25 +12,25 @@
 #include <bpf/bpf_helpers.h>
 #include <bpf/bpf_tracing.h>
 
-struct bpf_map_def SEC("maps") my_map = {
-	.type = BPF_MAP_TYPE_HASH,
-	.key_size = sizeof(long),
-	.value_size = sizeof(long),
-	.max_entries = 1024,
-};
-struct bpf_map_def SEC("maps") my_map2 = {
-	.type = BPF_MAP_TYPE_PERCPU_HASH,
-	.key_size = sizeof(long),
-	.value_size = sizeof(long),
-	.max_entries = 1024,
-};
+struct {
+	__uint(type, BPF_MAP_TYPE_HASH);
+	__type(key, long);
+	__type(value, long);
+	__uint(max_entries, 1024);
+} my_map SEC(".maps");
+struct {
+	__uint(type, BPF_MAP_TYPE_PERCPU_HASH);
+	__uint(key_size, sizeof(long));
+	__uint(value_size, sizeof(long));
+	__uint(max_entries, 1024);
+} my_map2 SEC(".maps");
 
-struct bpf_map_def SEC("maps") stackmap = {
-	.type = BPF_MAP_TYPE_STACK_TRACE,
-	.key_size = sizeof(u32),
-	.value_size = PERF_MAX_STACK_DEPTH * sizeof(u64),
-	.max_entries = 10000,
-};
+struct {
+	__uint(type, BPF_MAP_TYPE_STACK_TRACE);
+	__uint(key_size, sizeof(u32));
+	__uint(value_size, PERF_MAX_STACK_DEPTH * sizeof(u64));
+	__uint(max_entries, 10000);
+} stackmap SEC(".maps");
 
 #define PROG(foo) \
 int foo(struct pt_regs *ctx) \
diff --git a/samples/bpf/spintest_user.c b/samples/bpf/spintest_user.c
index fb430ea2ef51..847da9284fa8 100644
--- a/samples/bpf/spintest_user.c
+++ b/samples/bpf/spintest_user.c
@@ -1,40 +1,77 @@
 // SPDX-License-Identifier: GPL-2.0
 #include <stdio.h>
 #include <unistd.h>
-#include <linux/bpf.h>
 #include <string.h>
 #include <assert.h>
 #include <sys/resource.h>
 #include <bpf/libbpf.h>
-#include "bpf_load.h"
+#include <bpf/bpf.h>
 #include "trace_helpers.h"
 
 int main(int ac, char **argv)
 {
 	struct rlimit r = {RLIM_INFINITY, RLIM_INFINITY};
+	char filename[256], symbol[256];
+	struct bpf_object *obj = NULL;
+	struct bpf_link *links[20];
 	long key, next_key, value;
-	char filename[256];
+	struct bpf_program *prog;
+	int map_fd, i, j = 0;
+	const char *title;
 	struct ksym *sym;
-	int i;
 
-	snprintf(filename, sizeof(filename), "%s_kern.o", argv[0]);
-	setrlimit(RLIMIT_MEMLOCK, &r);
+	if (setrlimit(RLIMIT_MEMLOCK, &r)) {
+		perror("setrlimit(RLIMIT_MEMLOCK)");
+		return 1;
+	}
 
 	if (load_kallsyms()) {
 		printf("failed to process /proc/kallsyms\n");
 		return 2;
 	}
 
-	if (load_bpf_file(filename)) {
-		printf("%s", bpf_log_buf);
-		return 1;
+	snprintf(filename, sizeof(filename), "%s_kern.o", argv[0]);
+	obj = bpf_object__open_file(filename, NULL);
+	if (libbpf_get_error(obj)) {
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
+		title = bpf_program__title(prog, false);
+		if (sscanf(title, "kprobe/%s", symbol) != 1)
+			continue;
+
+		/* Attach prog only when symbol exists */
+		if (ksym_get_addr(symbol)) {
+			links[j] = bpf_program__attach(prog);
+			if (libbpf_get_error(links[j])) {
+				fprintf(stderr, "bpf_program__attach failed\n");
+				links[j] = NULL;
+				goto cleanup;
+			}
+			j++;
+		}
 	}
 
 	for (i = 0; i < 5; i++) {
 		key = 0;
 		printf("kprobing funcs:");
-		while (bpf_map_get_next_key(map_fd[0], &key, &next_key) == 0) {
-			bpf_map_lookup_elem(map_fd[0], &next_key, &value);
+		while (bpf_map_get_next_key(map_fd, &key, &next_key) == 0) {
+			bpf_map_lookup_elem(map_fd, &next_key, &value);
 			assert(next_key == value);
 			sym = ksym_search(value);
 			key = next_key;
@@ -48,10 +85,15 @@ int main(int ac, char **argv)
 		if (key)
 			printf("\n");
 		key = 0;
-		while (bpf_map_get_next_key(map_fd[0], &key, &next_key) == 0)
-			bpf_map_delete_elem(map_fd[0], &next_key);
+		while (bpf_map_get_next_key(map_fd, &key, &next_key) == 0)
+			bpf_map_delete_elem(map_fd, &next_key);
 		sleep(1);
 	}
 
+cleanup:
+	for (j--; j >= 0; j--)
+		bpf_link__destroy(links[j]);
+
+	bpf_object__close(obj);
 	return 0;
 }
diff --git a/samples/bpf/test_current_task_under_cgroup_kern.c b/samples/bpf/test_current_task_under_cgroup_kern.c
index 6dc4f41bb6cb..fbd43e2bb4d3 100644
--- a/samples/bpf/test_current_task_under_cgroup_kern.c
+++ b/samples/bpf/test_current_task_under_cgroup_kern.c
@@ -10,23 +10,24 @@
 #include <linux/version.h>
 #include <bpf/bpf_helpers.h>
 #include <uapi/linux/utsname.h>
+#include "trace_common.h"
 
-struct bpf_map_def SEC("maps") cgroup_map = {
-	.type			= BPF_MAP_TYPE_CGROUP_ARRAY,
-	.key_size		= sizeof(u32),
-	.value_size		= sizeof(u32),
-	.max_entries	= 1,
-};
+struct {
+	__uint(type, BPF_MAP_TYPE_CGROUP_ARRAY);
+	__uint(key_size, sizeof(u32));
+	__uint(value_size, sizeof(u32));
+	__uint(max_entries, 1);
+} cgroup_map SEC(".maps");
 
-struct bpf_map_def SEC("maps") perf_map = {
-	.type			= BPF_MAP_TYPE_ARRAY,
-	.key_size		= sizeof(u32),
-	.value_size		= sizeof(u64),
-	.max_entries	= 1,
-};
+struct {
+	__uint(type, BPF_MAP_TYPE_ARRAY);
+	__type(key, u32);
+	__type(value, u64);
+	__uint(max_entries, 1);
+} perf_map SEC(".maps");
 
 /* Writes the last PID that called sync to a map at index 0 */
-SEC("kprobe/sys_sync")
+SEC("kprobe/" SYSCALL(sys_sync))
 int bpf_prog1(struct pt_regs *ctx)
 {
 	u64 pid = bpf_get_current_pid_tgid();
diff --git a/samples/bpf/test_current_task_under_cgroup_user.c b/samples/bpf/test_current_task_under_cgroup_user.c
index 06e9f8ce42e2..ac251a417f45 100644
--- a/samples/bpf/test_current_task_under_cgroup_user.c
+++ b/samples/bpf/test_current_task_under_cgroup_user.c
@@ -4,10 +4,9 @@
 
 #define _GNU_SOURCE
 #include <stdio.h>
-#include <linux/bpf.h>
 #include <unistd.h>
 #include <bpf/bpf.h>
-#include "bpf_load.h"
+#include <bpf/libbpf.h>
 #include "cgroup_helpers.h"
 
 #define CGROUP_PATH		"/my-cgroup"
@@ -15,13 +14,44 @@
 int main(int argc, char **argv)
 {
 	pid_t remote_pid, local_pid = getpid();
-	int cg2, idx = 0, rc = 0;
+	struct bpf_link *link = NULL;
+	struct bpf_program *prog;
+	int cg2, idx = 0, rc = 1;
+	struct bpf_object *obj;
 	char filename[256];
+	int map_fd[2];
 
 	snprintf(filename, sizeof(filename), "%s_kern.o", argv[0]);
-	if (load_bpf_file(filename)) {
-		printf("%s", bpf_log_buf);
-		return 1;
+	obj = bpf_object__open_file(filename, NULL);
+	if (libbpf_get_error(obj)) {
+		fprintf(stderr, "ERROR: opening BPF object file failed\n");
+		return 0;
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
+		fprintf(stderr, "ERROR: loading BPF object file failed\n");
+		goto cleanup;
+	}
+
+	map_fd[0] = bpf_object__find_map_fd_by_name(obj, "cgroup_map");
+	map_fd[1] = bpf_object__find_map_fd_by_name(obj, "perf_map");
+	if (map_fd[0] < 0 || map_fd[1] < 0) {
+		fprintf(stderr, "ERROR: finding a map in obj file failed\n");
+		goto cleanup;
+	}
+
+	link = bpf_program__attach(prog);
+	if (libbpf_get_error(link)) {
+		fprintf(stderr, "ERROR: bpf_program__attach failed\n");
+		link = NULL;
+		goto cleanup;
 	}
 
 	if (setup_cgroup_environment())
@@ -70,12 +100,14 @@ int main(int argc, char **argv)
 		goto err;
 	}
 
-	goto out;
-err:
-	rc = 1;
+	rc = 0;
 
-out:
+err:
 	close(cg2);
 	cleanup_cgroup_environment();
+
+cleanup:
+	bpf_link__destroy(link);
+	bpf_object__close(obj);
 	return rc;
 }
diff --git a/samples/bpf/test_probe_write_user_kern.c b/samples/bpf/test_probe_write_user_kern.c
index fd651a65281e..220a96438d75 100644
--- a/samples/bpf/test_probe_write_user_kern.c
+++ b/samples/bpf/test_probe_write_user_kern.c
@@ -13,12 +13,12 @@
 #include <bpf/bpf_core_read.h>
 #include "trace_common.h"
 
-struct bpf_map_def SEC("maps") dnat_map = {
-	.type = BPF_MAP_TYPE_HASH,
-	.key_size = sizeof(struct sockaddr_in),
-	.value_size = sizeof(struct sockaddr_in),
-	.max_entries = 256,
-};
+struct {
+	__uint(type, BPF_MAP_TYPE_HASH);
+	__type(key, struct sockaddr_in);
+	__type(value, struct sockaddr_in);
+	__uint(max_entries, 256);
+} dnat_map SEC(".maps");
 
 /* kprobe is NOT a stable ABI
  * kernel functions can be removed, renamed or completely change semantics.
diff --git a/samples/bpf/test_probe_write_user_user.c b/samples/bpf/test_probe_write_user_user.c
index 045eb5e30f54..00ccfb834e45 100644
--- a/samples/bpf/test_probe_write_user_user.c
+++ b/samples/bpf/test_probe_write_user_user.c
@@ -1,21 +1,22 @@
 // SPDX-License-Identifier: GPL-2.0
 #include <stdio.h>
 #include <assert.h>
-#include <linux/bpf.h>
 #include <unistd.h>
 #include <bpf/bpf.h>
-#include "bpf_load.h"
+#include <bpf/libbpf.h>
 #include <sys/socket.h>
-#include <string.h>
 #include <netinet/in.h>
 #include <arpa/inet.h>
 
 int main(int ac, char **argv)
 {
-	int serverfd, serverconnfd, clientfd;
-	socklen_t sockaddr_len;
-	struct sockaddr serv_addr, mapped_addr, tmp_addr;
 	struct sockaddr_in *serv_addr_in, *mapped_addr_in, *tmp_addr_in;
+	struct sockaddr serv_addr, mapped_addr, tmp_addr;
+	int serverfd, serverconnfd, clientfd, map_fd;
+	struct bpf_link *link = NULL;
+	struct bpf_program *prog;
+	struct bpf_object *obj;
+	socklen_t sockaddr_len;
 	char filename[256];
 	char *ip;
 
@@ -24,10 +25,35 @@ int main(int ac, char **argv)
 	tmp_addr_in = (struct sockaddr_in *)&tmp_addr;
 
 	snprintf(filename, sizeof(filename), "%s_kern.o", argv[0]);
+	obj = bpf_object__open_file(filename, NULL);
+	if (libbpf_get_error(obj)) {
+		fprintf(stderr, "ERROR: opening BPF object file failed\n");
+		return 0;
+	}
+
+	prog = bpf_object__find_program_by_name(obj, "bpf_prog1");
+	if (libbpf_get_error(prog)) {
+		fprintf(stderr, "ERROR: finding a prog in obj file failed\n");
+		goto cleanup;
+	}
+
+	/* load BPF program */
+	if (bpf_object__load(obj)) {
+		fprintf(stderr, "ERROR: loading BPF object file failed\n");
+		goto cleanup;
+	}
+
+	map_fd = bpf_object__find_map_fd_by_name(obj, "dnat_map");
+	if (map_fd < 0) {
+		fprintf(stderr, "ERROR: finding a map in obj file failed\n");
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
 
 	assert((serverfd = socket(AF_INET, SOCK_STREAM, 0)) > 0);
@@ -51,7 +77,7 @@ int main(int ac, char **argv)
 	mapped_addr_in->sin_port = htons(5555);
 	mapped_addr_in->sin_addr.s_addr = inet_addr("255.255.255.255");
 
-	assert(!bpf_map_update_elem(map_fd[0], &mapped_addr, &serv_addr, BPF_ANY));
+	assert(!bpf_map_update_elem(map_fd, &mapped_addr, &serv_addr, BPF_ANY));
 
 	assert(listen(serverfd, 5) == 0);
 
@@ -75,5 +101,8 @@ int main(int ac, char **argv)
 	/* Is the server's getsockname = the socket getpeername */
 	assert(memcmp(&serv_addr, &tmp_addr, sizeof(struct sockaddr_in)) == 0);
 
+cleanup:
+	bpf_link__destroy(link);
+	bpf_object__close(obj);
 	return 0;
 }
diff --git a/samples/bpf/trace_output_kern.c b/samples/bpf/trace_output_kern.c
index 1d7d422cae6f..b64815af0943 100644
--- a/samples/bpf/trace_output_kern.c
+++ b/samples/bpf/trace_output_kern.c
@@ -2,15 +2,16 @@
 #include <linux/version.h>
 #include <uapi/linux/bpf.h>
 #include <bpf/bpf_helpers.h>
+#include "trace_common.h"
 
-struct bpf_map_def SEC("maps") my_map = {
-	.type = BPF_MAP_TYPE_PERF_EVENT_ARRAY,
-	.key_size = sizeof(int),
-	.value_size = sizeof(u32),
-	.max_entries = 2,
-};
+struct {
+	__uint(type, BPF_MAP_TYPE_PERF_EVENT_ARRAY);
+	__uint(key_size, sizeof(int));
+	__uint(value_size, sizeof(u32));
+	__uint(max_entries, 2);
+} my_map SEC(".maps");
 
-SEC("kprobe/sys_write")
+SEC("kprobe/" SYSCALL(sys_write))
 int bpf_prog1(struct pt_regs *ctx)
 {
 	struct S {
diff --git a/samples/bpf/trace_output_user.c b/samples/bpf/trace_output_user.c
index 60a17dd05345..364b98764d54 100644
--- a/samples/bpf/trace_output_user.c
+++ b/samples/bpf/trace_output_user.c
@@ -1,23 +1,10 @@
 // SPDX-License-Identifier: GPL-2.0-only
 #include <stdio.h>
-#include <unistd.h>
-#include <stdlib.h>
-#include <stdbool.h>
-#include <string.h>
 #include <fcntl.h>
 #include <poll.h>
-#include <linux/perf_event.h>
-#include <linux/bpf.h>
-#include <errno.h>
-#include <assert.h>
-#include <sys/syscall.h>
-#include <sys/ioctl.h>
-#include <sys/mman.h>
 #include <time.h>
 #include <signal.h>
 #include <bpf/libbpf.h>
-#include "bpf_load.h"
-#include "perf-sys.h"
 
 static __u64 time_get_ns(void)
 {
@@ -57,20 +44,48 @@ static void print_bpf_output(void *ctx, int cpu, void *data, __u32 size)
 int main(int argc, char **argv)
 {
 	struct perf_buffer_opts pb_opts = {};
+	struct bpf_link *link = NULL;
+	struct bpf_program *prog;
 	struct perf_buffer *pb;
+	struct bpf_object *obj;
+	int map_fd, ret = 0;
 	char filename[256];
 	FILE *f;
-	int ret;
 
 	snprintf(filename, sizeof(filename), "%s_kern.o", argv[0]);
+	obj = bpf_object__open_file(filename, NULL);
+	if (libbpf_get_error(obj)) {
+		fprintf(stderr, "ERROR: opening BPF object file failed\n");
+		return 0;
+	}
 
-	if (load_bpf_file(filename)) {
-		printf("%s", bpf_log_buf);
-		return 1;
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
+	prog = bpf_object__find_program_by_name(obj, "bpf_prog1");
+	if (libbpf_get_error(prog)) {
+		fprintf(stderr, "ERROR: finding a prog in obj file failed\n");
+		goto cleanup;
+	}
+
+	link = bpf_program__attach(prog);
+	if (libbpf_get_error(link)) {
+		fprintf(stderr, "ERROR: bpf_program__attach failed\n");
+		link = NULL;
+		goto cleanup;
 	}
 
 	pb_opts.sample_cb = print_bpf_output;
-	pb = perf_buffer__new(map_fd[0], 8, &pb_opts);
+	pb = perf_buffer__new(map_fd, 8, &pb_opts);
 	ret = libbpf_get_error(pb);
 	if (ret) {
 		printf("failed to setup perf_buffer: %d\n", ret);
@@ -84,5 +99,9 @@ int main(int argc, char **argv)
 	while ((ret = perf_buffer__poll(pb, 1000)) >= 0 && cnt < MAX_CNT) {
 	}
 	kill(0, SIGINT);
+
+cleanup:
+	bpf_link__destroy(link);
+	bpf_object__close(obj);
 	return ret;
 }
-- 
2.25.1

