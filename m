Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EF1E211A06
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 04:17:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728043AbgGBCRM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 22:17:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726451AbgGBCRK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 22:17:10 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED638C08C5C1;
        Wed,  1 Jul 2020 19:17:09 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id cm21so2430969pjb.3;
        Wed, 01 Jul 2020 19:17:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UFw4xyzBhHeeZCplfBUmGfZsCKHLEW4XnomnMF3zJ0k=;
        b=ZvwzlsM3EXZuWHBvN6/ZTMmT7LjmKlAoDsYtG+BoDtGZHJD9dsqUZRqZGswCX5NcTS
         ZmmuH0OdwpFKtqwjwFZUj3aHwFl2qzRGeCgHw+09Mp5LW9maBDAe7T87fAY8im8EttdZ
         AGn36aG3VezNUyDkUAJdqCJVbF5LAjhFaAhCTXDbXewmPcp1d9L8coAaTnCe8KF9L/xX
         Q6LuHaa8uD4sgebCVeFfHydUXYh5s8gbd5lWcPie7f7ARxxmp/mxOf+elu4jN0o8wsJn
         OGNhxwWI4bfVoEp0zegPxuMo/+phcv8Ajdvi7uf3ilTqzuZkDzEepN2xWIwU081fYDRk
         XYRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UFw4xyzBhHeeZCplfBUmGfZsCKHLEW4XnomnMF3zJ0k=;
        b=EXI0TuOXneyB1yMQchxQHYGzwq8E7pFuBQImiuObAupyIF2t5+Dgjr+N/bvUcwPDJG
         JNSvmel9JkRRzrmhJ0LR17FzEh6VTzOHadUEcaD4fX/jY8KPdi+zbEpoVHkrWoaMo8VP
         QMxemlGXSSByxgICSXZAyPVzfZxBFWRaMG5sGuF4rKbvL+0GV17akFDKloebpbP7UsGK
         G1fuURyeJn+nrWD9ul0m7eyW3ic08Leo8YQvYmfnYhqCu924a4zEfk1XlEdV9+ioC7KJ
         /LlX2OhJvVkwocHmJn8mAo86prPXl/UsF4o9YHgQO2pX0AGgQWsSE9HYJvc1XCQDGQgx
         N3WQ==
X-Gm-Message-State: AOAM531mEBC2f0rZObz+4YAOoq9uHPLcA2BFCnEVMS9RwSbTwSezwd+T
        8bt7mfEWgdj4jwLjE4hilA==
X-Google-Smtp-Source: ABdhPJy7l/poTD/WhjiY8F1uc4R9SJCLrzVC+2b9tEZLPK7lJ/Fc3vL4YIg6HWSqQgsw094k66eK2g==
X-Received: by 2002:a17:902:a987:: with SMTP id bh7mr12329061plb.197.1593656229143;
        Wed, 01 Jul 2020 19:17:09 -0700 (PDT)
Received: from localhost.localdomain ([182.209.58.45])
        by smtp.gmail.com with ESMTPSA id s1sm6428828pjp.14.2020.07.01.19.17.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jul 2020 19:17:08 -0700 (PDT)
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Yonghong Song <yhs@fb.com>, Martin KaFai Lau <kafai@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH bpf-next 3/4] samples: bpf: refactor BPF map performance test with libbpf
Date:   Thu,  2 Jul 2020 11:16:45 +0900
Message-Id: <20200702021646.90347-4-danieltimlee@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200702021646.90347-1-danieltimlee@gmail.com>
References: <20200702021646.90347-1-danieltimlee@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Previously, in order to set the numa_node attribute at the time of map
creation using "libbpf", it was necessary to call bpf_create_map_node()
directly (bpf_load approach), instead of calling bpf_object_load()
that handles everything on its own, including map creation. And because
of this problem, this sample had problems with refactoring from bpf_load
to libbbpf.

However, by commit 1bdb6c9a1c43 ("libbpf: Add a bunch of attribute
getters/setters for map definitions"), a helper function which allows
the numa_node attribute to be set in the map prior to calling
bpf_object_load() has been added.

By using libbpf instead of bpf_load, the inner map definition has
been explicitly declared with BTF-defined format. And for this reason
some logic in fixup_map() was not needed and changed or removed.

Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
---
 samples/bpf/Makefile             |   2 +-
 samples/bpf/map_perf_test_kern.c | 180 +++++++++++++++----------------
 samples/bpf/map_perf_test_user.c | 130 +++++++++++++++-------
 3 files changed, 181 insertions(+), 131 deletions(-)

diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
index 78678d4e6842..0cc7f18370c6 100644
--- a/samples/bpf/Makefile
+++ b/samples/bpf/Makefile
@@ -76,7 +76,7 @@ trace_output-objs := trace_output_user.o $(TRACE_HELPERS)
 lathist-objs := lathist_user.o
 offwaketime-objs := offwaketime_user.o $(TRACE_HELPERS)
 spintest-objs := spintest_user.o $(TRACE_HELPERS)
-map_perf_test-objs := bpf_load.o map_perf_test_user.o
+map_perf_test-objs := map_perf_test_user.o
 test_overhead-objs := bpf_load.o test_overhead_user.o
 test_cgrp2_array_pin-objs := test_cgrp2_array_pin.o
 test_cgrp2_attach-objs := test_cgrp2_attach.o
diff --git a/samples/bpf/map_perf_test_kern.c b/samples/bpf/map_perf_test_kern.c
index cebe2098bb24..13ca14e34f66 100644
--- a/samples/bpf/map_perf_test_kern.c
+++ b/samples/bpf/map_perf_test_kern.c
@@ -9,95 +9,95 @@
 #include <linux/version.h>
 #include <uapi/linux/bpf.h>
 #include <bpf/bpf_helpers.h>
-#include "bpf_legacy.h"
 #include <bpf/bpf_tracing.h>
+#include "trace_common.h"
 
 #define MAX_ENTRIES 1000
 #define MAX_NR_CPUS 1024
 
-struct bpf_map_def_legacy SEC("maps") hash_map = {
-	.type = BPF_MAP_TYPE_HASH,
-	.key_size = sizeof(u32),
-	.value_size = sizeof(long),
-	.max_entries = MAX_ENTRIES,
-};
-
-struct bpf_map_def_legacy SEC("maps") lru_hash_map = {
-	.type = BPF_MAP_TYPE_LRU_HASH,
-	.key_size = sizeof(u32),
-	.value_size = sizeof(long),
-	.max_entries = 10000,
-};
-
-struct bpf_map_def_legacy SEC("maps") nocommon_lru_hash_map = {
-	.type = BPF_MAP_TYPE_LRU_HASH,
-	.key_size = sizeof(u32),
-	.value_size = sizeof(long),
-	.max_entries = 10000,
-	.map_flags = BPF_F_NO_COMMON_LRU,
-};
-
-struct bpf_map_def_legacy SEC("maps") inner_lru_hash_map = {
-	.type = BPF_MAP_TYPE_LRU_HASH,
-	.key_size = sizeof(u32),
-	.value_size = sizeof(long),
-	.max_entries = MAX_ENTRIES,
-	.map_flags = BPF_F_NUMA_NODE,
-	.numa_node = 0,
-};
-
-struct bpf_map_def_legacy SEC("maps") array_of_lru_hashs = {
-	.type = BPF_MAP_TYPE_ARRAY_OF_MAPS,
-	.key_size = sizeof(u32),
-	.max_entries = MAX_NR_CPUS,
-};
-
-struct bpf_map_def_legacy SEC("maps") percpu_hash_map = {
-	.type = BPF_MAP_TYPE_PERCPU_HASH,
-	.key_size = sizeof(u32),
-	.value_size = sizeof(long),
-	.max_entries = MAX_ENTRIES,
-};
-
-struct bpf_map_def_legacy SEC("maps") hash_map_alloc = {
-	.type = BPF_MAP_TYPE_HASH,
-	.key_size = sizeof(u32),
-	.value_size = sizeof(long),
-	.max_entries = MAX_ENTRIES,
-	.map_flags = BPF_F_NO_PREALLOC,
-};
-
-struct bpf_map_def_legacy SEC("maps") percpu_hash_map_alloc = {
-	.type = BPF_MAP_TYPE_PERCPU_HASH,
-	.key_size = sizeof(u32),
-	.value_size = sizeof(long),
-	.max_entries = MAX_ENTRIES,
-	.map_flags = BPF_F_NO_PREALLOC,
-};
-
-struct bpf_map_def_legacy SEC("maps") lpm_trie_map_alloc = {
-	.type = BPF_MAP_TYPE_LPM_TRIE,
-	.key_size = 8,
-	.value_size = sizeof(long),
-	.max_entries = 10000,
-	.map_flags = BPF_F_NO_PREALLOC,
-};
-
-struct bpf_map_def_legacy SEC("maps") array_map = {
-	.type = BPF_MAP_TYPE_ARRAY,
-	.key_size = sizeof(u32),
-	.value_size = sizeof(long),
-	.max_entries = MAX_ENTRIES,
-};
-
-struct bpf_map_def_legacy SEC("maps") lru_hash_lookup_map = {
-	.type = BPF_MAP_TYPE_LRU_HASH,
-	.key_size = sizeof(u32),
-	.value_size = sizeof(long),
-	.max_entries = MAX_ENTRIES,
-};
-
-SEC("kprobe/sys_getuid")
+struct {
+	__uint(type, BPF_MAP_TYPE_HASH);
+	__type(key, u32);
+	__type(value, long);
+	__uint(max_entries, MAX_ENTRIES);
+} hash_map SEC(".maps");
+
+struct {
+	__uint(type, BPF_MAP_TYPE_LRU_HASH);
+	__type(key, u32);
+	__type(value, long);
+	__uint(max_entries, 10000);
+} lru_hash_map SEC(".maps");
+
+struct {
+	__uint(type, BPF_MAP_TYPE_LRU_HASH);
+	__type(key, u32);
+	__type(value, long);
+	__uint(max_entries, 10000);
+	__uint(map_flags, BPF_F_NO_COMMON_LRU);
+} nocommon_lru_hash_map SEC(".maps");
+
+struct inner_lru {
+	__uint(type, BPF_MAP_TYPE_LRU_HASH);
+	__type(key, u32);
+	__type(value, long);
+	__uint(max_entries, MAX_ENTRIES);
+	__uint(map_flags, BPF_F_NUMA_NODE); /* from _user.c, set numa_node to 0 */
+} inner_lru_hash_map SEC(".maps");
+
+struct {
+	__uint(type, BPF_MAP_TYPE_ARRAY_OF_MAPS);
+	__uint(max_entries, MAX_NR_CPUS);
+	__uint(key_size, sizeof(u32));
+	__array(values, struct inner_lru); /* use inner_lru as inner map */
+} array_of_lru_hashs SEC(".maps");
+
+struct {
+	__uint(type, BPF_MAP_TYPE_PERCPU_HASH);
+	__uint(key_size, sizeof(u32));
+	__uint(value_size, sizeof(long));
+	__uint(max_entries, MAX_ENTRIES);
+} percpu_hash_map SEC(".maps");
+
+struct {
+	__uint(type, BPF_MAP_TYPE_HASH);
+	__type(key, u32);
+	__type(value, long);
+	__uint(max_entries, MAX_ENTRIES);
+	__uint(map_flags, BPF_F_NO_PREALLOC);
+} hash_map_alloc SEC(".maps");
+
+struct {
+	__uint(type, BPF_MAP_TYPE_PERCPU_HASH);
+	__uint(key_size, sizeof(u32));
+	__uint(value_size, sizeof(long));
+	__uint(max_entries, MAX_ENTRIES);
+	__uint(map_flags, BPF_F_NO_PREALLOC);
+} percpu_hash_map_alloc SEC(".maps");
+
+struct {
+	__uint(type, BPF_MAP_TYPE_LPM_TRIE);
+	__uint(key_size, 8);
+	__uint(value_size, sizeof(long));
+	__uint(max_entries, 10000);
+	__uint(map_flags, BPF_F_NO_PREALLOC);
+} lpm_trie_map_alloc SEC(".maps");
+
+struct {
+	__uint(type, BPF_MAP_TYPE_ARRAY);
+	__type(key, u32);
+	__type(value, long);
+	__uint(max_entries, MAX_ENTRIES);
+} array_map SEC(".maps");
+
+struct {
+	__uint(type, BPF_MAP_TYPE_LRU_HASH);
+	__type(key, u32);
+	__type(value, long);
+	__uint(max_entries, MAX_ENTRIES);
+} lru_hash_lookup_map SEC(".maps");
+
+SEC("kprobe/" SYSCALL(sys_getuid))
 int stress_hmap(struct pt_regs *ctx)
 {
 	u32 key = bpf_get_current_pid_tgid();
@@ -112,7 +112,7 @@ int stress_hmap(struct pt_regs *ctx)
 	return 0;
 }
 
-SEC("kprobe/sys_geteuid")
+SEC("kprobe/" SYSCALL(sys_geteuid))
 int stress_percpu_hmap(struct pt_regs *ctx)
 {
 	u32 key = bpf_get_current_pid_tgid();
@@ -126,7 +126,7 @@ int stress_percpu_hmap(struct pt_regs *ctx)
 	return 0;
 }
 
-SEC("kprobe/sys_getgid")
+SEC("kprobe/" SYSCALL(sys_getgid))
 int stress_hmap_alloc(struct pt_regs *ctx)
 {
 	u32 key = bpf_get_current_pid_tgid();
@@ -140,7 +140,7 @@ int stress_hmap_alloc(struct pt_regs *ctx)
 	return 0;
 }
 
-SEC("kprobe/sys_getegid")
+SEC("kprobe/" SYSCALL(sys_getegid))
 int stress_percpu_hmap_alloc(struct pt_regs *ctx)
 {
 	u32 key = bpf_get_current_pid_tgid();
@@ -233,7 +233,7 @@ int stress_lru_hmap_alloc(struct pt_regs *ctx)
 	return 0;
 }
 
-SEC("kprobe/sys_gettid")
+SEC("kprobe/" SYSCALL(sys_gettid))
 int stress_lpm_trie_map_alloc(struct pt_regs *ctx)
 {
 	union {
@@ -255,7 +255,7 @@ int stress_lpm_trie_map_alloc(struct pt_regs *ctx)
 	return 0;
 }
 
-SEC("kprobe/sys_getpgid")
+SEC("kprobe/" SYSCALL(sys_getpgid))
 int stress_hash_map_lookup(struct pt_regs *ctx)
 {
 	u32 key = 1, i;
@@ -268,7 +268,7 @@ int stress_hash_map_lookup(struct pt_regs *ctx)
 	return 0;
 }
 
-SEC("kprobe/sys_getppid")
+SEC("kprobe/" SYSCALL(sys_getppid))
 int stress_array_map_lookup(struct pt_regs *ctx)
 {
 	u32 key = 1, i;
diff --git a/samples/bpf/map_perf_test_user.c b/samples/bpf/map_perf_test_user.c
index fe5564bff39b..e067bda07fd7 100644
--- a/samples/bpf/map_perf_test_user.c
+++ b/samples/bpf/map_perf_test_user.c
@@ -11,7 +11,6 @@
 #include <sys/wait.h>
 #include <stdlib.h>
 #include <signal.h>
-#include <linux/bpf.h>
 #include <string.h>
 #include <time.h>
 #include <sys/resource.h>
@@ -19,7 +18,7 @@
 #include <errno.h>
 
 #include <bpf/bpf.h>
-#include "bpf_load.h"
+#include <bpf/libbpf.h>
 
 #define TEST_BIT(t) (1U << (t))
 #define MAX_NR_CPUS 1024
@@ -61,12 +60,19 @@ const char *test_map_names[NR_TESTS] = {
 	[LRU_HASH_LOOKUP] = "lru_hash_lookup_map",
 };
 
+enum map_idx {
+	inner_lru_hash_idx,
+	array_of_lru_hashs_idx,
+	hash_map_alloc_idx,
+	lru_hash_lookup_idx,
+	NR_IDXES,
+};
+
+static int map_fd[NR_IDXES];
+
 static int test_flags = ~0;
 static uint32_t num_map_entries;
 static uint32_t inner_lru_hash_size;
-static int inner_lru_hash_idx = -1;
-static int array_of_lru_hashs_idx = -1;
-static int lru_hash_lookup_idx = -1;
 static int lru_hash_lookup_test_entries = 32;
 static uint32_t max_cnt = 1000000;
 
@@ -377,7 +383,8 @@ static void fill_lpm_trie(void)
 		key->data[1] = rand() & 0xff;
 		key->data[2] = rand() & 0xff;
 		key->data[3] = rand() & 0xff;
-		r = bpf_map_update_elem(map_fd[6], key, &value, 0);
+		r = bpf_map_update_elem(map_fd[hash_map_alloc_idx],
+					key, &value, 0);
 		assert(!r);
 	}
 
@@ -388,59 +395,52 @@ static void fill_lpm_trie(void)
 	key->data[3] = 1;
 	value = 128;
 
-	r = bpf_map_update_elem(map_fd[6], key, &value, 0);
+	r = bpf_map_update_elem(map_fd[hash_map_alloc_idx], key, &value, 0);
 	assert(!r);
 }
 
-static void fixup_map(struct bpf_map_data *map, int idx)
+static void fixup_map(struct bpf_object *obj)
 {
+	struct bpf_map *map;
 	int i;
 
-	if (!strcmp("inner_lru_hash_map", map->name)) {
-		inner_lru_hash_idx = idx;
-		inner_lru_hash_size = map->def.max_entries;
-	}
+	bpf_object__for_each_map(map, obj) {
+		const char *name = bpf_map__name(map);
 
-	if (!strcmp("array_of_lru_hashs", map->name)) {
-		if (inner_lru_hash_idx == -1) {
-			printf("inner_lru_hash_map must be defined before array_of_lru_hashs\n");
-			exit(1);
+		/* Only change the max_entries for the enabled test(s) */
+		for (i = 0; i < NR_TESTS; i++) {
+			if (!strcmp(test_map_names[i], name) &&
+			    (check_test_flags(i))) {
+				bpf_map__resize(map, num_map_entries);
+				continue;
+			}
 		}
-		map->def.inner_map_idx = inner_lru_hash_idx;
-		array_of_lru_hashs_idx = idx;
 	}
 
-	if (!strcmp("lru_hash_lookup_map", map->name))
-		lru_hash_lookup_idx = idx;
-
-	if (num_map_entries <= 0)
-		return;
-
 	inner_lru_hash_size = num_map_entries;
-
-	/* Only change the max_entries for the enabled test(s) */
-	for (i = 0; i < NR_TESTS; i++) {
-		if (!strcmp(test_map_names[i], map->name) &&
-		    (check_test_flags(i))) {
-			map->def.max_entries = num_map_entries;
-		}
-	}
 }
 
 int main(int argc, char **argv)
 {
 	struct rlimit r = {RLIM_INFINITY, RLIM_INFINITY};
+	int nr_cpus = sysconf(_SC_NPROCESSORS_ONLN);
+	struct bpf_link *links[8];
+	struct bpf_program *prog;
+	struct bpf_object *obj;
+	struct bpf_map *map;
 	char filename[256];
-	int num_cpu = 8;
+	int err, i = 0;
 
-	snprintf(filename, sizeof(filename), "%s_kern.o", argv[0]);
-	setrlimit(RLIMIT_MEMLOCK, &r);
+	if (setrlimit(RLIMIT_MEMLOCK, &r)) {
+		perror("setrlimit(RLIMIT_MEMLOCK)");
+		return 1;
+	}
 
 	if (argc > 1)
 		test_flags = atoi(argv[1]) ? : test_flags;
 
 	if (argc > 2)
-		num_cpu = atoi(argv[2]) ? : num_cpu;
+		nr_cpus = atoi(argv[2]) ? : nr_cpus;
 
 	if (argc > 3)
 		num_map_entries = atoi(argv[3]);
@@ -448,14 +448,64 @@ int main(int argc, char **argv)
 	if (argc > 4)
 		max_cnt = atoi(argv[4]);
 
-	if (load_bpf_file_fixup_map(filename, fixup_map)) {
-		printf("%s", bpf_log_buf);
-		return 1;
+	snprintf(filename, sizeof(filename), "%s_kern.o", argv[0]);
+	obj = bpf_object__open_file(filename, NULL);
+	if (libbpf_get_error(obj)) {
+		fprintf(stderr, "ERROR: opening BPF object file failed\n");
+		return 0;
+	}
+
+	map = bpf_object__find_map_by_name(obj, "inner_lru_hash_map");
+	if (libbpf_get_error(map)) {
+		fprintf(stderr, "ERROR: finding a map in obj file failed\n");
+		goto cleanup;
+	}
+
+	/* set inner_lru_hash_map numa_node attribute to 0 */
+	err = bpf_map__set_numa_node(map, 0);
+	inner_lru_hash_size = bpf_map__max_entries(map);
+	if (err || !inner_lru_hash_size) {
+		fprintf(stderr, "ERROR: failed to set/get map attribute\n");
+		goto cleanup;
+	}
+
+	/* resize BPF map prior to loading */
+	if (num_map_entries > 0)
+		fixup_map(obj);
+
+	/* load BPF program */
+	if (bpf_object__load(obj)) {
+		fprintf(stderr, "ERROR: loading BPF object file failed\n");
+		goto cleanup;
+	}
+
+	map_fd[0] = bpf_map__fd(map);
+	map_fd[1] = bpf_object__find_map_fd_by_name(obj, "array_of_lru_hashs");
+	map_fd[2] = bpf_object__find_map_fd_by_name(obj, "hash_map_alloc");
+	map_fd[3] = bpf_object__find_map_fd_by_name(obj, "lru_hash_lookup_map");
+	if (map_fd[0] < 0 || map_fd[1] < 0 || map_fd[2] < 0 || map_fd[3] < 0) {
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
 
 	fill_lpm_trie();
 
-	run_perf_test(num_cpu);
+	run_perf_test(nr_cpus);
+
+cleanup:
+	for (i--; i >= 0; i--)
+		bpf_link__destroy(links[i]);
 
+	bpf_object__close(obj);
 	return 0;
 }
-- 
2.25.1

