Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AA9221770E
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 20:49:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728678AbgGGStV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 14:49:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728149AbgGGStU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jul 2020 14:49:20 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB8E7C061755;
        Tue,  7 Jul 2020 11:49:20 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id ch3so58238pjb.5;
        Tue, 07 Jul 2020 11:49:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=N1JVcTckOnQFYFPy9mVUqe4c+hcg36ecHdr+kNBKk5I=;
        b=B60pJc7A0u8jhezHJiDDCBxAJ8FGpvwed6cQpvyvQsGAzoJdRc04yHOYbt0SS2OUnm
         9Je4wmRR3gIOWgOqxYDH3Y+4QZnFYq6OU8DytnRZs0jMADAQSImDGwt8tOnaGQ8vYcCT
         0B1BKcWimMMytfqK3kFQo8F07A9s1KBtM6FaWZqYApHLePnak54J2LsKyFTONSUVBrvE
         3MmbwkAUq5knGWCkM64emzGBj7fqOVUSVSTzCV0AQk2lLEei+TykUooDzBww8kKk+cwv
         HUZR+Cif2drCW06lnZwOXEaLb7s3DyWX3sWmeaK6ybsCMRmtp46lg5rOUBfvXmr6Bkpg
         4mZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=N1JVcTckOnQFYFPy9mVUqe4c+hcg36ecHdr+kNBKk5I=;
        b=tACFOKhHoVHLPHo6t4CFignZ0GnwGeD1jH82DgCvFSmy/NLZxGYC5A8XbV+hw/5739
         Y8VZticUzlfVnzAgsu+6kHDD89h4MYdtDIlsCSfws+QJiB6U8t+a/wiycPn89rmkqUQu
         aesVohrFE6LjyENVvdXTLl1VPL9U6UJEfPn+qK71ue3EaiL5cSoh8fBGeoJFpsQXstr2
         ovs7+2Y7dEuXTVUl9s2Js3G6XaytBdsYp+BzvE14H2X7kUefxe1u28AC4OScct837tp9
         c6fnwul9x9VWkfHEM1dEZFOLlv7/5FunQNQsS5Z09RnGw2dykapP7/zC/Tt/nnEoEw7l
         1zCw==
X-Gm-Message-State: AOAM530tBxUBKFQri/VOH+RsSHQRmzycB96hOE5afl/tEN+0OKDGpbrW
        n9rJPubIlQXGGDAYRdyaPw==
X-Google-Smtp-Source: ABdhPJxa1EUWdKp9G3NRhADkbc2ge91O24d4nS7Y5Q2S84eC2MGeQzaqqnCVxZ6/d+QxRq+KMSsqVA==
X-Received: by 2002:a17:902:8348:: with SMTP id z8mr29800632pln.113.1594147760121;
        Tue, 07 Jul 2020 11:49:20 -0700 (PDT)
Received: from localhost.localdomain ([182.209.58.45])
        by smtp.gmail.com with ESMTPSA id r7sm1625278pgu.51.2020.07.07.11.49.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jul 2020 11:49:19 -0700 (PDT)
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Yonghong Song <yhs@fb.com>, Martin KaFai Lau <kafai@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH bpf-next v2 3/4] samples: bpf: refactor BPF map performance test with libbpf
Date:   Wed,  8 Jul 2020 03:48:54 +0900
Message-Id: <20200707184855.30968-4-danieltimlee@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200707184855.30968-1-danieltimlee@gmail.com>
References: <20200707184855.30968-1-danieltimlee@gmail.com>
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
getters/setters for map definitions") added the numa_node attribute and
allowed it to be set in the map.

By using libbpf instead of bpf_load, the inner map definition has
been explicitly declared with BTF-defined format. Also, the element of
ARRAY_OF_MAPS was also statically specified using the BTF format. And
for this reason some logic in fixup_map() was not needed and changed
or removed.

Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>

---
Changes in V2:
 - set numa_node 0 declaratively at map definition instead of setting it
 from user-space
 - static initialization of ARRAY_OF_MAPS element with '.values'

 samples/bpf/map_perf_test_kern.c | 179 ++++++++++++++++---------------
 samples/bpf/map_perf_test_user.c | 164 ++++++++++++++++++----------
 2 files changed, 196 insertions(+), 147 deletions(-)

diff --git a/samples/bpf/map_perf_test_kern.c b/samples/bpf/map_perf_test_kern.c
index c9b31193ca12..8773f22b6a98 100644
--- a/samples/bpf/map_perf_test_kern.c
+++ b/samples/bpf/map_perf_test_kern.c
@@ -9,7 +9,6 @@
 #include <linux/version.h>
 #include <uapi/linux/bpf.h>
 #include <bpf/bpf_helpers.h>
-#include "bpf_legacy.h"
 #include <bpf/bpf_tracing.h>
 #include <bpf/bpf_core_read.h>
 #include "trace_common.h"
@@ -17,89 +16,93 @@
 #define MAX_ENTRIES 1000
 #define MAX_NR_CPUS 1024
 
-struct bpf_map_def_legacy SEC("maps") hash_map = {
-	.type = BPF_MAP_TYPE_HASH,
-	.key_size = sizeof(u32),
-	.value_size = sizeof(long),
-	.max_entries = MAX_ENTRIES,
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
+	__uint(map_flags, BPF_F_NUMA_NODE);
+	__uint(numa_node, 0);
+} inner_lru_hash_map SEC(".maps");
+
+struct {
+	__uint(type, BPF_MAP_TYPE_ARRAY_OF_MAPS);
+	__uint(max_entries, MAX_NR_CPUS);
+	__uint(key_size, sizeof(u32));
+	__array(values, struct inner_lru); /* use inner_lru as inner map */
+} array_of_lru_hashs SEC(".maps") = {
+	/* statically initialize the first element */
+	.values = { &inner_lru_hash_map },
 };
 
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
@@ -114,7 +117,7 @@ int stress_hmap(struct pt_regs *ctx)
 	return 0;
 }
 
-SEC("kprobe/sys_geteuid")
+SEC("kprobe/" SYSCALL(sys_geteuid))
 int stress_percpu_hmap(struct pt_regs *ctx)
 {
 	u32 key = bpf_get_current_pid_tgid();
@@ -128,7 +131,7 @@ int stress_percpu_hmap(struct pt_regs *ctx)
 	return 0;
 }
 
-SEC("kprobe/sys_getgid")
+SEC("kprobe/" SYSCALL(sys_getgid))
 int stress_hmap_alloc(struct pt_regs *ctx)
 {
 	u32 key = bpf_get_current_pid_tgid();
@@ -142,7 +145,7 @@ int stress_hmap_alloc(struct pt_regs *ctx)
 	return 0;
 }
 
-SEC("kprobe/sys_getegid")
+SEC("kprobe/" SYSCALL(sys_getegid))
 int stress_percpu_hmap_alloc(struct pt_regs *ctx)
 {
 	u32 key = bpf_get_current_pid_tgid();
@@ -236,7 +239,7 @@ int stress_lru_hmap_alloc(struct pt_regs *ctx)
 	return 0;
 }
 
-SEC("kprobe/sys_gettid")
+SEC("kprobe/" SYSCALL(sys_gettid))
 int stress_lpm_trie_map_alloc(struct pt_regs *ctx)
 {
 	union {
@@ -258,7 +261,7 @@ int stress_lpm_trie_map_alloc(struct pt_regs *ctx)
 	return 0;
 }
 
-SEC("kprobe/sys_getpgid")
+SEC("kprobe/" SYSCALL(sys_getpgid))
 int stress_hash_map_lookup(struct pt_regs *ctx)
 {
 	u32 key = 1, i;
@@ -271,7 +274,7 @@ int stress_hash_map_lookup(struct pt_regs *ctx)
 	return 0;
 }
 
-SEC("kprobe/sys_getppid")
+SEC("kprobe/" SYSCALL(sys_getppid))
 int stress_array_map_lookup(struct pt_regs *ctx)
 {
 	u32 key = 1, i;
diff --git a/samples/bpf/map_perf_test_user.c b/samples/bpf/map_perf_test_user.c
index fe5564bff39b..8b13230b4c46 100644
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
@@ -61,12 +60,18 @@ const char *test_map_names[NR_TESTS] = {
 	[LRU_HASH_LOOKUP] = "lru_hash_lookup_map",
 };
 
+enum map_idx {
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
 
@@ -122,30 +127,30 @@ static void do_test_lru(enum test_type test, int cpu)
 	__u64 start_time;
 	int i, ret;
 
-	if (test == INNER_LRU_HASH_PREALLOC) {
+	if (test == INNER_LRU_HASH_PREALLOC && cpu) {
+		/* If CPU is not 0, create inner_lru hash map and insert the fd
+		 * value into the array_of_lru_hash map. In case of CPU 0,
+		 * 'inner_lru_hash_map' was statically inserted on the map init
+		 */
 		int outer_fd = map_fd[array_of_lru_hashs_idx];
 		unsigned int mycpu, mynode;
 
 		assert(cpu < MAX_NR_CPUS);
 
-		if (cpu) {
-			ret = syscall(__NR_getcpu, &mycpu, &mynode, NULL);
-			assert(!ret);
-
-			inner_lru_map_fds[cpu] =
-				bpf_create_map_node(BPF_MAP_TYPE_LRU_HASH,
-						    test_map_names[INNER_LRU_HASH_PREALLOC],
-						    sizeof(uint32_t),
-						    sizeof(long),
-						    inner_lru_hash_size, 0,
-						    mynode);
-			if (inner_lru_map_fds[cpu] == -1) {
-				printf("cannot create BPF_MAP_TYPE_LRU_HASH %s(%d)\n",
-				       strerror(errno), errno);
-				exit(1);
-			}
-		} else {
-			inner_lru_map_fds[cpu] = map_fd[inner_lru_hash_idx];
+		ret = syscall(__NR_getcpu, &mycpu, &mynode, NULL);
+		assert(!ret);
+
+		inner_lru_map_fds[cpu] =
+			bpf_create_map_node(BPF_MAP_TYPE_LRU_HASH,
+					    test_map_names[INNER_LRU_HASH_PREALLOC],
+					    sizeof(uint32_t),
+					    sizeof(long),
+					    inner_lru_hash_size, 0,
+					    mynode);
+		if (inner_lru_map_fds[cpu] == -1) {
+			printf("cannot create BPF_MAP_TYPE_LRU_HASH %s(%d)\n",
+			       strerror(errno), errno);
+			exit(1);
 		}
 
 		ret = bpf_map_update_elem(outer_fd, &cpu,
@@ -377,7 +382,8 @@ static void fill_lpm_trie(void)
 		key->data[1] = rand() & 0xff;
 		key->data[2] = rand() & 0xff;
 		key->data[3] = rand() & 0xff;
-		r = bpf_map_update_elem(map_fd[6], key, &value, 0);
+		r = bpf_map_update_elem(map_fd[hash_map_alloc_idx],
+					key, &value, 0);
 		assert(!r);
 	}
 
@@ -388,59 +394,52 @@ static void fill_lpm_trie(void)
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
+	int i = 0;
 
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
@@ -448,14 +447,61 @@ int main(int argc, char **argv)
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
+	inner_lru_hash_size = bpf_map__max_entries(map);
+	if (!inner_lru_hash_size) {
+		fprintf(stderr, "ERROR: failed to get map attribute\n");
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
+	map_fd[0] = bpf_object__find_map_fd_by_name(obj, "array_of_lru_hashs");
+	map_fd[1] = bpf_object__find_map_fd_by_name(obj, "hash_map_alloc");
+	map_fd[2] = bpf_object__find_map_fd_by_name(obj, "lru_hash_lookup_map");
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

