Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96E4D1BFCC
	for <lists+netdev@lfdr.de>; Tue, 14 May 2019 01:19:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726722AbfEMXT2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 May 2019 19:19:28 -0400
Received: from www62.your-server.de ([213.133.104.62]:57890 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726646AbfEMXTX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 May 2019 19:19:23 -0400
Received: from [178.199.41.31] (helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hQKE4-0001s4-Uo; Tue, 14 May 2019 01:19:21 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     ast@kernel.org
Cc:     kafai@fb.com, bpf@vger.kernel.org, netdev@vger.kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH bpf 3/3] bpf: test ref bit from data path and add new tests for syscall path
Date:   Tue, 14 May 2019 01:18:57 +0200
Message-Id: <a3e4b430b4f95e1b2ca0ef477883d80815bd9758.1557789256.git.daniel@iogearbox.net>
X-Mailer: git-send-email 2.9.5
In-Reply-To: <cover.1557789256.git.daniel@iogearbox.net>
References: <cover.1557789256.git.daniel@iogearbox.net>
In-Reply-To: <cover.1557789256.git.daniel@iogearbox.net>
References: <cover.1557789256.git.daniel@iogearbox.net>
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25448/Mon May 13 09:57:34 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The test_lru_map is relying on marking the LRU map entry via regular
BPF map lookup from system call side. This is basically for simplicity
reasons. Given we fixed marking entries in that case, the test needs
to be fixed as well. Here we add a small drop-in replacement to retain
existing behavior for the tests by marking out of the BPF program and
transferring the retrieved value out via temporary map. This also adds
new test cases to track the new behavior where two elements are marked,
one via system call side and one via program side, where the next update
then evicts the key looked up only from system call side.

  # ./test_lru_map
  nr_cpus:8

  test_lru_sanity0 (map_type:9 map_flags:0x0): Pass
  test_lru_sanity1 (map_type:9 map_flags:0x0): Pass
  test_lru_sanity2 (map_type:9 map_flags:0x0): Pass
  test_lru_sanity3 (map_type:9 map_flags:0x0): Pass
  test_lru_sanity4 (map_type:9 map_flags:0x0): Pass
  test_lru_sanity5 (map_type:9 map_flags:0x0): Pass
  test_lru_sanity7 (map_type:9 map_flags:0x0): Pass
  test_lru_sanity8 (map_type:9 map_flags:0x0): Pass

  test_lru_sanity0 (map_type:10 map_flags:0x0): Pass
  test_lru_sanity1 (map_type:10 map_flags:0x0): Pass
  test_lru_sanity2 (map_type:10 map_flags:0x0): Pass
  test_lru_sanity3 (map_type:10 map_flags:0x0): Pass
  test_lru_sanity4 (map_type:10 map_flags:0x0): Pass
  test_lru_sanity5 (map_type:10 map_flags:0x0): Pass
  test_lru_sanity7 (map_type:10 map_flags:0x0): Pass
  test_lru_sanity8 (map_type:10 map_flags:0x0): Pass

  test_lru_sanity0 (map_type:9 map_flags:0x2): Pass
  test_lru_sanity4 (map_type:9 map_flags:0x2): Pass
  test_lru_sanity6 (map_type:9 map_flags:0x2): Pass
  test_lru_sanity7 (map_type:9 map_flags:0x2): Pass
  test_lru_sanity8 (map_type:9 map_flags:0x2): Pass

  test_lru_sanity0 (map_type:10 map_flags:0x2): Pass
  test_lru_sanity4 (map_type:10 map_flags:0x2): Pass
  test_lru_sanity6 (map_type:10 map_flags:0x2): Pass
  test_lru_sanity7 (map_type:10 map_flags:0x2): Pass
  test_lru_sanity8 (map_type:10 map_flags:0x2): Pass

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Martin KaFai Lau <kafai@fb.com>
---
 tools/testing/selftests/bpf/test_lru_map.c | 288 +++++++++++++++++++++++++++--
 1 file changed, 274 insertions(+), 14 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_lru_map.c b/tools/testing/selftests/bpf/test_lru_map.c
index 781c7de..1b25a7e 100644
--- a/tools/testing/selftests/bpf/test_lru_map.c
+++ b/tools/testing/selftests/bpf/test_lru_map.c
@@ -18,9 +18,11 @@
 #include <sys/wait.h>
 
 #include <bpf/bpf.h>
+#include <bpf/libbpf.h>
 
 #include "bpf_util.h"
 #include "bpf_rlimit.h"
+#include "../../../include/linux/filter.h"
 
 #define LOCAL_FREE_TARGET	(128)
 #define PERCPU_FREE_TARGET	(4)
@@ -40,6 +42,68 @@ static int create_map(int map_type, int map_flags, unsigned int size)
 	return map_fd;
 }
 
+static int bpf_map_lookup_elem_with_ref_bit(int fd, unsigned long long key,
+					    void *value)
+{
+	struct bpf_load_program_attr prog;
+	struct bpf_create_map_attr map;
+	struct bpf_insn insns[] = {
+		BPF_LD_MAP_VALUE(BPF_REG_9, 0, 0),
+		BPF_LD_MAP_FD(BPF_REG_1, fd),
+		BPF_LD_IMM64(BPF_REG_3, key),
+		BPF_MOV64_REG(BPF_REG_2, BPF_REG_10),
+		BPF_ALU64_IMM(BPF_ADD, BPF_REG_2, -8),
+		BPF_STX_MEM(BPF_DW, BPF_REG_2, BPF_REG_3, 0),
+		BPF_EMIT_CALL(BPF_FUNC_map_lookup_elem),
+		BPF_JMP_IMM(BPF_JEQ, BPF_REG_0, 0, 4),
+		BPF_LDX_MEM(BPF_DW, BPF_REG_1, BPF_REG_0, 0),
+		BPF_STX_MEM(BPF_DW, BPF_REG_9, BPF_REG_1, 0),
+		BPF_MOV64_IMM(BPF_REG_0, 42),
+		BPF_JMP_IMM(BPF_JA, 0, 0, 1),
+		BPF_MOV64_IMM(BPF_REG_0, 1),
+		BPF_EXIT_INSN(),
+	};
+	__u8 data[64] = {};
+	int mfd, pfd, ret, zero = 0;
+	__u32 retval = 0;
+
+	memset(&map, 0, sizeof(map));
+	map.map_type = BPF_MAP_TYPE_ARRAY;
+	map.key_size = sizeof(int);
+	map.value_size = sizeof(unsigned long long);
+	map.max_entries = 1;
+
+	mfd = bpf_create_map_xattr(&map);
+	if (mfd < 0)
+		return -1;
+
+	insns[0].imm = mfd;
+
+	memset(&prog, 0, sizeof(prog));
+	prog.prog_type = BPF_PROG_TYPE_SCHED_CLS;
+	prog.insns = insns;
+	prog.insns_cnt = ARRAY_SIZE(insns);
+	prog.license = "GPL";
+
+	pfd = bpf_load_program_xattr(&prog, NULL, 0);
+	if (pfd < 0) {
+		close(mfd);
+		return -1;
+	}
+
+	ret = bpf_prog_test_run(pfd, 1, data, sizeof(data),
+				NULL, NULL, &retval, NULL);
+	if (ret < 0 || retval != 42) {
+		ret = -1;
+	} else {
+		assert(!bpf_map_lookup_elem(mfd, &zero, value));
+		ret = 0;
+	}
+	close(pfd);
+	close(mfd);
+	return ret;
+}
+
 static int map_subset(int map0, int map1)
 {
 	unsigned long long next_key = 0;
@@ -87,7 +151,7 @@ static int sched_next_online(int pid, int *next_to_try)
 	return ret;
 }
 
-/* Size of the LRU amp is 2
+/* Size of the LRU map is 2
  * Add key=1 (+1 key)
  * Add key=2 (+1 key)
  * Lookup Key=1
@@ -157,7 +221,7 @@ static void test_lru_sanity0(int map_type, int map_flags)
 	 * stop LRU from removing key=1
 	 */
 	key = 1;
-	assert(!bpf_map_lookup_elem(lru_map_fd, &key, value));
+	assert(!bpf_map_lookup_elem_with_ref_bit(lru_map_fd, key, value));
 	assert(value[0] == 1234);
 
 	key = 3;
@@ -167,7 +231,8 @@ static void test_lru_sanity0(int map_type, int map_flags)
 
 	/* key=2 has been removed from the LRU */
 	key = 2;
-	assert(bpf_map_lookup_elem(lru_map_fd, &key, value) == -1);
+	assert(bpf_map_lookup_elem(lru_map_fd, &key, value) == -1 &&
+	       errno == ENOENT);
 
 	assert(map_equal(lru_map_fd, expected_map_fd));
 
@@ -221,7 +286,7 @@ static void test_lru_sanity1(int map_type, int map_flags, unsigned int tgt_free)
 	/* Lookup 1 to tgt_free/2 */
 	end_key = 1 + batch_size;
 	for (key = 1; key < end_key; key++) {
-		assert(!bpf_map_lookup_elem(lru_map_fd, &key, value));
+		assert(!bpf_map_lookup_elem_with_ref_bit(lru_map_fd, key, value));
 		assert(!bpf_map_update_elem(expected_map_fd, &key, value,
 					    BPF_NOEXIST));
 	}
@@ -322,10 +387,11 @@ static void test_lru_sanity2(int map_type, int map_flags, unsigned int tgt_free)
 	end_key = 1 + batch_size;
 	value[0] = 4321;
 	for (key = 1; key < end_key; key++) {
-		assert(bpf_map_lookup_elem(lru_map_fd, &key, value));
+		assert(bpf_map_lookup_elem(lru_map_fd, &key, value) == -1 &&
+		       errno == ENOENT);
 		assert(!bpf_map_update_elem(lru_map_fd, &key, value,
 					    BPF_NOEXIST));
-		assert(!bpf_map_lookup_elem(lru_map_fd, &key, value));
+		assert(!bpf_map_lookup_elem_with_ref_bit(lru_map_fd, key, value));
 		assert(value[0] == 4321);
 		assert(!bpf_map_update_elem(expected_map_fd, &key, value,
 					    BPF_NOEXIST));
@@ -404,7 +470,7 @@ static void test_lru_sanity3(int map_type, int map_flags, unsigned int tgt_free)
 	/* Lookup key 1 to tgt_free*3/2 */
 	end_key = tgt_free + batch_size;
 	for (key = 1; key < end_key; key++) {
-		assert(!bpf_map_lookup_elem(lru_map_fd, &key, value));
+		assert(!bpf_map_lookup_elem_with_ref_bit(lru_map_fd, key, value));
 		assert(!bpf_map_update_elem(expected_map_fd, &key, value,
 					    BPF_NOEXIST));
 	}
@@ -463,7 +529,7 @@ static void test_lru_sanity4(int map_type, int map_flags, unsigned int tgt_free)
 	assert(bpf_map_update_elem(lru_map_fd, &key, value, BPF_NOEXIST));
 
 	for (key = 1; key <= tgt_free; key++) {
-		assert(!bpf_map_lookup_elem(lru_map_fd, &key, value));
+		assert(!bpf_map_lookup_elem_with_ref_bit(lru_map_fd, key, value));
 		assert(!bpf_map_update_elem(expected_map_fd, &key, value,
 					    BPF_NOEXIST));
 	}
@@ -494,16 +560,16 @@ static void do_test_lru_sanity5(unsigned long long last_key, int map_fd)
 	unsigned long long key, value[nr_cpus];
 
 	/* Ensure the last key inserted by previous CPU can be found */
-	assert(!bpf_map_lookup_elem(map_fd, &last_key, value));
-
+	assert(!bpf_map_lookup_elem_with_ref_bit(map_fd, last_key, value));
 	value[0] = 1234;
 
 	key = last_key + 1;
 	assert(!bpf_map_update_elem(map_fd, &key, value, BPF_NOEXIST));
-	assert(!bpf_map_lookup_elem(map_fd, &key, value));
+	assert(!bpf_map_lookup_elem_with_ref_bit(map_fd, key, value));
 
 	/* Cannot find the last key because it was removed by LRU */
-	assert(bpf_map_lookup_elem(map_fd, &last_key, value));
+	assert(bpf_map_lookup_elem(map_fd, &last_key, value) == -1 &&
+	       errno == ENOENT);
 }
 
 /* Test map with only one element */
@@ -590,8 +656,8 @@ static void test_lru_sanity6(int map_type, int map_flags, int tgt_free)
 		/* Make ref bit sticky for key: [1, tgt_free] */
 		for (stable_key = 1; stable_key <= tgt_free; stable_key++) {
 			/* Mark the ref bit */
-			assert(!bpf_map_lookup_elem(lru_map_fd, &stable_key,
-						    value));
+			assert(!bpf_map_lookup_elem_with_ref_bit(lru_map_fd,
+								 stable_key, value));
 		}
 		assert(!bpf_map_update_elem(lru_map_fd, &key, value,
 					    BPF_NOEXIST));
@@ -612,6 +678,198 @@ static void test_lru_sanity6(int map_type, int map_flags, int tgt_free)
 	printf("Pass\n");
 }
 
+/* Size of the LRU map is 2
+ * Add key=1 (+1 key)
+ * Add key=2 (+1 key)
+ * Lookup Key=1 (datapath)
+ * Lookup Key=2 (syscall)
+ * Add Key=3
+ *   => Key=2 will be removed by LRU
+ * Iterate map.  Only found key=1 and key=3
+ */
+static void test_lru_sanity7(int map_type, int map_flags)
+{
+	unsigned long long key, value[nr_cpus];
+	int lru_map_fd, expected_map_fd;
+	int next_cpu = 0;
+
+	printf("%s (map_type:%d map_flags:0x%X): ", __func__, map_type,
+	       map_flags);
+
+	assert(sched_next_online(0, &next_cpu) != -1);
+
+	if (map_flags & BPF_F_NO_COMMON_LRU)
+		lru_map_fd = create_map(map_type, map_flags, 2 * nr_cpus);
+	else
+		lru_map_fd = create_map(map_type, map_flags, 2);
+	assert(lru_map_fd != -1);
+
+	expected_map_fd = create_map(BPF_MAP_TYPE_HASH, 0, 2);
+	assert(expected_map_fd != -1);
+
+	value[0] = 1234;
+
+	/* insert key=1 element */
+
+	key = 1;
+	assert(!bpf_map_update_elem(lru_map_fd, &key, value, BPF_NOEXIST));
+	assert(!bpf_map_update_elem(expected_map_fd, &key, value,
+				    BPF_NOEXIST));
+
+	/* BPF_NOEXIST means: add new element if it doesn't exist */
+	assert(bpf_map_update_elem(lru_map_fd, &key, value, BPF_NOEXIST) == -1
+	       /* key=1 already exists */
+	       && errno == EEXIST);
+
+	/* insert key=2 element */
+
+	/* check that key=2 is not found */
+	key = 2;
+	assert(bpf_map_lookup_elem(lru_map_fd, &key, value) == -1 &&
+	       errno == ENOENT);
+
+	/* BPF_EXIST means: update existing element */
+	assert(bpf_map_update_elem(lru_map_fd, &key, value, BPF_EXIST) == -1 &&
+	       /* key=2 is not there */
+	       errno == ENOENT);
+
+	assert(!bpf_map_update_elem(lru_map_fd, &key, value, BPF_NOEXIST));
+
+	/* insert key=3 element */
+
+	/* check that key=3 is not found */
+	key = 3;
+	assert(bpf_map_lookup_elem(lru_map_fd, &key, value) == -1 &&
+	       errno == ENOENT);
+
+	/* check that key=1 can be found and mark the ref bit to
+	 * stop LRU from removing key=1
+	 */
+	key = 1;
+	assert(!bpf_map_lookup_elem_with_ref_bit(lru_map_fd, key, value));
+	assert(value[0] == 1234);
+
+	/* check that key=2 can be found and do _not_ mark ref bit.
+	 * this will be evicted on next update.
+	 */
+	key = 2;
+	assert(!bpf_map_lookup_elem(lru_map_fd, &key, value));
+	assert(value[0] == 1234);
+
+	key = 3;
+	assert(!bpf_map_update_elem(lru_map_fd, &key, value, BPF_NOEXIST));
+	assert(!bpf_map_update_elem(expected_map_fd, &key, value,
+				    BPF_NOEXIST));
+
+	/* key=2 has been removed from the LRU */
+	key = 2;
+	assert(bpf_map_lookup_elem(lru_map_fd, &key, value) == -1 &&
+	       errno == ENOENT);
+
+	assert(map_equal(lru_map_fd, expected_map_fd));
+
+	close(expected_map_fd);
+	close(lru_map_fd);
+
+	printf("Pass\n");
+}
+
+/* Size of the LRU map is 2
+ * Add key=1 (+1 key)
+ * Add key=2 (+1 key)
+ * Lookup Key=1 (syscall)
+ * Lookup Key=2 (datapath)
+ * Add Key=3
+ *   => Key=1 will be removed by LRU
+ * Iterate map.  Only found key=2 and key=3
+ */
+static void test_lru_sanity8(int map_type, int map_flags)
+{
+	unsigned long long key, value[nr_cpus];
+	int lru_map_fd, expected_map_fd;
+	int next_cpu = 0;
+
+	printf("%s (map_type:%d map_flags:0x%X): ", __func__, map_type,
+	       map_flags);
+
+	assert(sched_next_online(0, &next_cpu) != -1);
+
+	if (map_flags & BPF_F_NO_COMMON_LRU)
+		lru_map_fd = create_map(map_type, map_flags, 2 * nr_cpus);
+	else
+		lru_map_fd = create_map(map_type, map_flags, 2);
+	assert(lru_map_fd != -1);
+
+	expected_map_fd = create_map(BPF_MAP_TYPE_HASH, 0, 2);
+	assert(expected_map_fd != -1);
+
+	value[0] = 1234;
+
+	/* insert key=1 element */
+
+	key = 1;
+	assert(!bpf_map_update_elem(lru_map_fd, &key, value, BPF_NOEXIST));
+
+	/* BPF_NOEXIST means: add new element if it doesn't exist */
+	assert(bpf_map_update_elem(lru_map_fd, &key, value, BPF_NOEXIST) == -1
+	       /* key=1 already exists */
+	       && errno == EEXIST);
+
+	/* insert key=2 element */
+
+	/* check that key=2 is not found */
+	key = 2;
+	assert(bpf_map_lookup_elem(lru_map_fd, &key, value) == -1 &&
+	       errno == ENOENT);
+
+	/* BPF_EXIST means: update existing element */
+	assert(bpf_map_update_elem(lru_map_fd, &key, value, BPF_EXIST) == -1 &&
+	       /* key=2 is not there */
+	       errno == ENOENT);
+
+	assert(!bpf_map_update_elem(lru_map_fd, &key, value, BPF_NOEXIST));
+	assert(!bpf_map_update_elem(expected_map_fd, &key, value,
+				    BPF_NOEXIST));
+
+	/* insert key=3 element */
+
+	/* check that key=3 is not found */
+	key = 3;
+	assert(bpf_map_lookup_elem(lru_map_fd, &key, value) == -1 &&
+	       errno == ENOENT);
+
+	/* check that key=1 can be found and do _not_ mark ref bit.
+	 * this will be evicted on next update.
+	 */
+	key = 1;
+	assert(!bpf_map_lookup_elem(lru_map_fd, &key, value));
+	assert(value[0] == 1234);
+
+	/* check that key=2 can be found and mark the ref bit to
+	 * stop LRU from removing key=2
+	 */
+	key = 2;
+	assert(!bpf_map_lookup_elem_with_ref_bit(lru_map_fd, key, value));
+	assert(value[0] == 1234);
+
+	key = 3;
+	assert(!bpf_map_update_elem(lru_map_fd, &key, value, BPF_NOEXIST));
+	assert(!bpf_map_update_elem(expected_map_fd, &key, value,
+				    BPF_NOEXIST));
+
+	/* key=1 has been removed from the LRU */
+	key = 1;
+	assert(bpf_map_lookup_elem(lru_map_fd, &key, value) == -1 &&
+	       errno == ENOENT);
+
+	assert(map_equal(lru_map_fd, expected_map_fd));
+
+	close(expected_map_fd);
+	close(lru_map_fd);
+
+	printf("Pass\n");
+}
+
 int main(int argc, char **argv)
 {
 	int map_types[] = {BPF_MAP_TYPE_LRU_HASH,
@@ -637,6 +895,8 @@ int main(int argc, char **argv)
 			test_lru_sanity4(map_types[t], map_flags[f], tgt_free);
 			test_lru_sanity5(map_types[t], map_flags[f]);
 			test_lru_sanity6(map_types[t], map_flags[f], tgt_free);
+			test_lru_sanity7(map_types[t], map_flags[f]);
+			test_lru_sanity8(map_types[t], map_flags[f]);
 
 			printf("\n");
 		}
-- 
2.9.5

