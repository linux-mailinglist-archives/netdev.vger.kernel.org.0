Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25F70CEF31
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 00:47:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729577AbfJGWrZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 18:47:25 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:26806 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729517AbfJGWrY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Oct 2019 18:47:24 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x97MhZZq012554
        for <netdev@vger.kernel.org>; Mon, 7 Oct 2019 15:47:23 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=E0rLXJzD5WGpFiEUAqRzqTjHrFHoUYQPvGt1eoR5myA=;
 b=d+DrqzccP1qo4J0Bt5lvyNDpVUvK+rJZQz9FvOvbQ2dByZM/WrmyYlS04dcXDz0yjtiU
 7BRiS1HIEEXqpGy5kkw5bkceNVPb7zaKhoh5thaOMN++Rn19fCIdO+nXZDDl/Bm2lI2P
 42tjoQiZfUlkMfuS99uwxD+D13kRiHnrPlw= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2vgdb3r90e-7
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 07 Oct 2019 15:47:23 -0700
Received: from 2401:db00:30:6007:face:0:1:0 (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::129) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Mon, 7 Oct 2019 15:47:22 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id 92BE5861891; Mon,  7 Oct 2019 15:47:21 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH v4 bpf-next 2/7] selftests/bpf: samples/bpf: split off legacy stuff from bpf_helpers.h
Date:   Mon, 7 Oct 2019 15:47:07 -0700
Message-ID: <20191007224712.1984401-3-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191007224712.1984401-1-andriin@fb.com>
References: <20191007224712.1984401-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-07_04:2019-10-07,2019-10-07 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0
 lowpriorityscore=0 phishscore=0 suspectscore=8 bulkscore=0 impostorscore=0
 priorityscore=1501 malwarescore=0 mlxlogscore=999 clxscore=1015
 spamscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910070202
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Split off few legacy things from bpf_helpers.h into separate
bpf_legacy.h file:
- load_{byte|half|word};
- remove extra inner_idx and numa_node fields from bpf_map_def and
  introduce bpf_map_def_legacy for use in samples;
- move BPF_ANNOTATE_KV_PAIR into bpf_legacy.h.

Adjust samples and selftests accordingly by either including
bpf_legacy.h and using bpf_map_def_legacy, or switching to BTF-defined
maps altogether.

Acked-by: John Fastabend <john.fastabend@gmail.com>
Acked-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 samples/bpf/hbm_kern.h                        | 27 ++++++-------
 samples/bpf/map_perf_test_kern.c              | 23 +++++------
 samples/bpf/parse_ldabs.c                     |  1 +
 samples/bpf/sockex1_kern.c                    |  1 +
 samples/bpf/sockex2_kern.c                    |  1 +
 samples/bpf/sockex3_kern.c                    |  1 +
 samples/bpf/tcbpf1_kern.c                     |  1 +
 samples/bpf/test_map_in_map_kern.c            | 15 +++----
 tools/testing/selftests/bpf/bpf_helpers.h     | 24 +-----------
 tools/testing/selftests/bpf/bpf_legacy.h      | 39 +++++++++++++++++++
 .../testing/selftests/bpf/progs/sockopt_sk.c  | 13 +++----
 tools/testing/selftests/bpf/progs/tcp_rtt.c   | 13 +++----
 .../selftests/bpf/progs/test_btf_haskv.c      |  1 +
 .../selftests/bpf/progs/test_btf_newkv.c      |  1 +
 14 files changed, 91 insertions(+), 70 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/bpf_legacy.h

diff --git a/samples/bpf/hbm_kern.h b/samples/bpf/hbm_kern.h
index aa207a2eebbd..4edaf47876ca 100644
--- a/samples/bpf/hbm_kern.h
+++ b/samples/bpf/hbm_kern.h
@@ -59,21 +59,18 @@
 #define BYTES_PER_NS(delta, rate) ((((u64)(delta)) * (rate)) >> 20)
 #define BYTES_TO_NS(bytes, rate) div64_u64(((u64)(bytes)) << 20, (u64)(rate))
 
-struct bpf_map_def SEC("maps") queue_state = {
-	.type = BPF_MAP_TYPE_CGROUP_STORAGE,
-	.key_size = sizeof(struct bpf_cgroup_storage_key),
-	.value_size = sizeof(struct hbm_vqueue),
-};
-BPF_ANNOTATE_KV_PAIR(queue_state, struct bpf_cgroup_storage_key,
-		     struct hbm_vqueue);
-
-struct bpf_map_def SEC("maps") queue_stats = {
-	.type = BPF_MAP_TYPE_ARRAY,
-	.key_size = sizeof(u32),
-	.value_size = sizeof(struct hbm_queue_stats),
-	.max_entries = 1,
-};
-BPF_ANNOTATE_KV_PAIR(queue_stats, int, struct hbm_queue_stats);
+struct {
+	__uint(type, BPF_MAP_TYPE_CGROUP_STORAGE);
+	__type(key, struct bpf_cgroup_storage_key);
+	__type(value, struct hbm_vqueue);
+} queue_state SEC(".maps");
+
+struct {
+	__uint(type, BPF_MAP_TYPE_ARRAY);
+	__uint(max_entries, 1);
+	__type(key, u32);
+	__type(value, struct hvm_queue_stats);
+} queue_stats SEC(".maps");
 
 struct hbm_pkt_info {
 	int	cwnd;
diff --git a/samples/bpf/map_perf_test_kern.c b/samples/bpf/map_perf_test_kern.c
index 2b2ffb97018b..f47ee513cb7c 100644
--- a/samples/bpf/map_perf_test_kern.c
+++ b/samples/bpf/map_perf_test_kern.c
@@ -9,25 +9,26 @@
 #include <linux/version.h>
 #include <uapi/linux/bpf.h>
 #include "bpf_helpers.h"
+#include "bpf_legacy.h"
 
 #define MAX_ENTRIES 1000
 #define MAX_NR_CPUS 1024
 
-struct bpf_map_def SEC("maps") hash_map = {
+struct bpf_map_def_legacy SEC("maps") hash_map = {
 	.type = BPF_MAP_TYPE_HASH,
 	.key_size = sizeof(u32),
 	.value_size = sizeof(long),
 	.max_entries = MAX_ENTRIES,
 };
 
-struct bpf_map_def SEC("maps") lru_hash_map = {
+struct bpf_map_def_legacy SEC("maps") lru_hash_map = {
 	.type = BPF_MAP_TYPE_LRU_HASH,
 	.key_size = sizeof(u32),
 	.value_size = sizeof(long),
 	.max_entries = 10000,
 };
 
-struct bpf_map_def SEC("maps") nocommon_lru_hash_map = {
+struct bpf_map_def_legacy SEC("maps") nocommon_lru_hash_map = {
 	.type = BPF_MAP_TYPE_LRU_HASH,
 	.key_size = sizeof(u32),
 	.value_size = sizeof(long),
@@ -35,7 +36,7 @@ struct bpf_map_def SEC("maps") nocommon_lru_hash_map = {
 	.map_flags = BPF_F_NO_COMMON_LRU,
 };
 
-struct bpf_map_def SEC("maps") inner_lru_hash_map = {
+struct bpf_map_def_legacy SEC("maps") inner_lru_hash_map = {
 	.type = BPF_MAP_TYPE_LRU_HASH,
 	.key_size = sizeof(u32),
 	.value_size = sizeof(long),
@@ -44,20 +45,20 @@ struct bpf_map_def SEC("maps") inner_lru_hash_map = {
 	.numa_node = 0,
 };
 
-struct bpf_map_def SEC("maps") array_of_lru_hashs = {
+struct bpf_map_def_legacy SEC("maps") array_of_lru_hashs = {
 	.type = BPF_MAP_TYPE_ARRAY_OF_MAPS,
 	.key_size = sizeof(u32),
 	.max_entries = MAX_NR_CPUS,
 };
 
-struct bpf_map_def SEC("maps") percpu_hash_map = {
+struct bpf_map_def_legacy SEC("maps") percpu_hash_map = {
 	.type = BPF_MAP_TYPE_PERCPU_HASH,
 	.key_size = sizeof(u32),
 	.value_size = sizeof(long),
 	.max_entries = MAX_ENTRIES,
 };
 
-struct bpf_map_def SEC("maps") hash_map_alloc = {
+struct bpf_map_def_legacy SEC("maps") hash_map_alloc = {
 	.type = BPF_MAP_TYPE_HASH,
 	.key_size = sizeof(u32),
 	.value_size = sizeof(long),
@@ -65,7 +66,7 @@ struct bpf_map_def SEC("maps") hash_map_alloc = {
 	.map_flags = BPF_F_NO_PREALLOC,
 };
 
-struct bpf_map_def SEC("maps") percpu_hash_map_alloc = {
+struct bpf_map_def_legacy SEC("maps") percpu_hash_map_alloc = {
 	.type = BPF_MAP_TYPE_PERCPU_HASH,
 	.key_size = sizeof(u32),
 	.value_size = sizeof(long),
@@ -73,7 +74,7 @@ struct bpf_map_def SEC("maps") percpu_hash_map_alloc = {
 	.map_flags = BPF_F_NO_PREALLOC,
 };
 
-struct bpf_map_def SEC("maps") lpm_trie_map_alloc = {
+struct bpf_map_def_legacy SEC("maps") lpm_trie_map_alloc = {
 	.type = BPF_MAP_TYPE_LPM_TRIE,
 	.key_size = 8,
 	.value_size = sizeof(long),
@@ -81,14 +82,14 @@ struct bpf_map_def SEC("maps") lpm_trie_map_alloc = {
 	.map_flags = BPF_F_NO_PREALLOC,
 };
 
-struct bpf_map_def SEC("maps") array_map = {
+struct bpf_map_def_legacy SEC("maps") array_map = {
 	.type = BPF_MAP_TYPE_ARRAY,
 	.key_size = sizeof(u32),
 	.value_size = sizeof(long),
 	.max_entries = MAX_ENTRIES,
 };
 
-struct bpf_map_def SEC("maps") lru_hash_lookup_map = {
+struct bpf_map_def_legacy SEC("maps") lru_hash_lookup_map = {
 	.type = BPF_MAP_TYPE_LRU_HASH,
 	.key_size = sizeof(u32),
 	.value_size = sizeof(long),
diff --git a/samples/bpf/parse_ldabs.c b/samples/bpf/parse_ldabs.c
index 6db6b21fdc6d..ef5892377beb 100644
--- a/samples/bpf/parse_ldabs.c
+++ b/samples/bpf/parse_ldabs.c
@@ -12,6 +12,7 @@
 #include <linux/udp.h>
 #include <uapi/linux/bpf.h>
 #include "bpf_helpers.h"
+#include "bpf_legacy.h"
 
 #define DEFAULT_PKTGEN_UDP_PORT	9
 #define IP_MF			0x2000
diff --git a/samples/bpf/sockex1_kern.c b/samples/bpf/sockex1_kern.c
index ed18e9a4909c..f96943f443ab 100644
--- a/samples/bpf/sockex1_kern.c
+++ b/samples/bpf/sockex1_kern.c
@@ -3,6 +3,7 @@
 #include <uapi/linux/if_packet.h>
 #include <uapi/linux/ip.h>
 #include "bpf_helpers.h"
+#include "bpf_legacy.h"
 
 struct bpf_map_def SEC("maps") my_map = {
 	.type = BPF_MAP_TYPE_ARRAY,
diff --git a/samples/bpf/sockex2_kern.c b/samples/bpf/sockex2_kern.c
index f2f9dbc021b0..5566fa7d92fa 100644
--- a/samples/bpf/sockex2_kern.c
+++ b/samples/bpf/sockex2_kern.c
@@ -1,5 +1,6 @@
 #include <uapi/linux/bpf.h>
 #include "bpf_helpers.h"
+#include "bpf_legacy.h"
 #include <uapi/linux/in.h>
 #include <uapi/linux/if.h>
 #include <uapi/linux/if_ether.h>
diff --git a/samples/bpf/sockex3_kern.c b/samples/bpf/sockex3_kern.c
index c527b57d3ec8..151dd842ecc0 100644
--- a/samples/bpf/sockex3_kern.c
+++ b/samples/bpf/sockex3_kern.c
@@ -6,6 +6,7 @@
  */
 #include <uapi/linux/bpf.h>
 #include "bpf_helpers.h"
+#include "bpf_legacy.h"
 #include <uapi/linux/in.h>
 #include <uapi/linux/if.h>
 #include <uapi/linux/if_ether.h>
diff --git a/samples/bpf/tcbpf1_kern.c b/samples/bpf/tcbpf1_kern.c
index 274c884c87fe..ff43341bdfce 100644
--- a/samples/bpf/tcbpf1_kern.c
+++ b/samples/bpf/tcbpf1_kern.c
@@ -8,6 +8,7 @@
 #include <uapi/linux/filter.h>
 #include <uapi/linux/pkt_cls.h>
 #include "bpf_helpers.h"
+#include "bpf_legacy.h"
 
 /* compiler workaround */
 #define _htonl __builtin_bswap32
diff --git a/samples/bpf/test_map_in_map_kern.c b/samples/bpf/test_map_in_map_kern.c
index 42c44d091dd1..8101bf3dc7f7 100644
--- a/samples/bpf/test_map_in_map_kern.c
+++ b/samples/bpf/test_map_in_map_kern.c
@@ -11,11 +11,12 @@
 #include <uapi/linux/bpf.h>
 #include <uapi/linux/in6.h>
 #include "bpf_helpers.h"
+#include "bpf_legacy.h"
 
 #define MAX_NR_PORTS 65536
 
 /* map #0 */
-struct bpf_map_def SEC("maps") port_a = {
+struct bpf_map_def_legacy SEC("maps") port_a = {
 	.type = BPF_MAP_TYPE_ARRAY,
 	.key_size = sizeof(u32),
 	.value_size = sizeof(int),
@@ -23,7 +24,7 @@ struct bpf_map_def SEC("maps") port_a = {
 };
 
 /* map #1 */
-struct bpf_map_def SEC("maps") port_h = {
+struct bpf_map_def_legacy SEC("maps") port_h = {
 	.type = BPF_MAP_TYPE_HASH,
 	.key_size = sizeof(u32),
 	.value_size = sizeof(int),
@@ -31,7 +32,7 @@ struct bpf_map_def SEC("maps") port_h = {
 };
 
 /* map #2 */
-struct bpf_map_def SEC("maps") reg_result_h = {
+struct bpf_map_def_legacy SEC("maps") reg_result_h = {
 	.type = BPF_MAP_TYPE_HASH,
 	.key_size = sizeof(u32),
 	.value_size = sizeof(int),
@@ -39,7 +40,7 @@ struct bpf_map_def SEC("maps") reg_result_h = {
 };
 
 /* map #3 */
-struct bpf_map_def SEC("maps") inline_result_h = {
+struct bpf_map_def_legacy SEC("maps") inline_result_h = {
 	.type = BPF_MAP_TYPE_HASH,
 	.key_size = sizeof(u32),
 	.value_size = sizeof(int),
@@ -47,7 +48,7 @@ struct bpf_map_def SEC("maps") inline_result_h = {
 };
 
 /* map #4 */ /* Test case #0 */
-struct bpf_map_def SEC("maps") a_of_port_a = {
+struct bpf_map_def_legacy SEC("maps") a_of_port_a = {
 	.type = BPF_MAP_TYPE_ARRAY_OF_MAPS,
 	.key_size = sizeof(u32),
 	.inner_map_idx = 0, /* map_fd[0] is port_a */
@@ -55,7 +56,7 @@ struct bpf_map_def SEC("maps") a_of_port_a = {
 };
 
 /* map #5 */ /* Test case #1 */
-struct bpf_map_def SEC("maps") h_of_port_a = {
+struct bpf_map_def_legacy SEC("maps") h_of_port_a = {
 	.type = BPF_MAP_TYPE_HASH_OF_MAPS,
 	.key_size = sizeof(u32),
 	.inner_map_idx = 0, /* map_fd[0] is port_a */
@@ -63,7 +64,7 @@ struct bpf_map_def SEC("maps") h_of_port_a = {
 };
 
 /* map #6 */ /* Test case #2 */
-struct bpf_map_def SEC("maps") h_of_port_h = {
+struct bpf_map_def_legacy SEC("maps") h_of_port_h = {
 	.type = BPF_MAP_TYPE_HASH_OF_MAPS,
 	.key_size = sizeof(u32),
 	.inner_map_idx = 1, /* map_fd[1] is port_h */
diff --git a/tools/testing/selftests/bpf/bpf_helpers.h b/tools/testing/selftests/bpf/bpf_helpers.h
index ffd4d8c9a087..c7cfc27063d4 100644
--- a/tools/testing/selftests/bpf/bpf_helpers.h
+++ b/tools/testing/selftests/bpf/bpf_helpers.h
@@ -21,19 +21,8 @@
  */
 #define SEC(NAME) __attribute__((section(NAME), used))
 
-/* llvm builtin functions that eBPF C program may use to
- * emit BPF_LD_ABS and BPF_LD_IND instructions
- */
-struct sk_buff;
-unsigned long long load_byte(void *skb,
-			     unsigned long long off) asm("llvm.bpf.load.byte");
-unsigned long long load_half(void *skb,
-			     unsigned long long off) asm("llvm.bpf.load.half");
-unsigned long long load_word(void *skb,
-			     unsigned long long off) asm("llvm.bpf.load.word");
-
 /* a helper structure used by eBPF C program
- * to describe map attributes to elf_bpf loader
+ * to describe BPF map attributes to libbpf loader
  */
 struct bpf_map_def {
 	unsigned int type;
@@ -41,19 +30,8 @@ struct bpf_map_def {
 	unsigned int value_size;
 	unsigned int max_entries;
 	unsigned int map_flags;
-	unsigned int inner_map_idx;
-	unsigned int numa_node;
 };
 
-#define BPF_ANNOTATE_KV_PAIR(name, type_key, type_val)		\
-	struct ____btf_map_##name {				\
-		type_key key;					\
-		type_val value;					\
-	};							\
-	struct ____btf_map_##name				\
-	__attribute__ ((section(".maps." #name), used))		\
-		____btf_map_##name = { }
-
 /* Scan the ARCH passed in from ARCH env variable (see Makefile) */
 #if defined(__TARGET_ARCH_x86)
 	#define bpf_target_x86
diff --git a/tools/testing/selftests/bpf/bpf_legacy.h b/tools/testing/selftests/bpf/bpf_legacy.h
new file mode 100644
index 000000000000..6f8988738bc1
--- /dev/null
+++ b/tools/testing/selftests/bpf/bpf_legacy.h
@@ -0,0 +1,39 @@
+/* SPDX-License-Identifier: (LGPL-2.1 OR BSD-2-Clause) */
+#ifndef __BPF_LEGACY__
+#define __BPF_LEGACY__
+
+/*
+ * legacy bpf_map_def with extra fields supported only by bpf_load(), do not
+ * use outside of samples/bpf
+ */
+struct bpf_map_def_legacy {
+	unsigned int type;
+	unsigned int key_size;
+	unsigned int value_size;
+	unsigned int max_entries;
+	unsigned int map_flags;
+	unsigned int inner_map_idx;
+	unsigned int numa_node;
+};
+
+#define BPF_ANNOTATE_KV_PAIR(name, type_key, type_val)		\
+	struct ____btf_map_##name {				\
+		type_key key;					\
+		type_val value;					\
+	};							\
+	struct ____btf_map_##name				\
+	__attribute__ ((section(".maps." #name), used))		\
+		____btf_map_##name = { }
+
+/* llvm builtin functions that eBPF C program may use to
+ * emit BPF_LD_ABS and BPF_LD_IND instructions
+ */
+unsigned long long load_byte(void *skb,
+			     unsigned long long off) asm("llvm.bpf.load.byte");
+unsigned long long load_half(void *skb,
+			     unsigned long long off) asm("llvm.bpf.load.half");
+unsigned long long load_word(void *skb,
+			     unsigned long long off) asm("llvm.bpf.load.word");
+
+#endif
+
diff --git a/tools/testing/selftests/bpf/progs/sockopt_sk.c b/tools/testing/selftests/bpf/progs/sockopt_sk.c
index 9a3d1c79e6fe..1bafbb944e37 100644
--- a/tools/testing/selftests/bpf/progs/sockopt_sk.c
+++ b/tools/testing/selftests/bpf/progs/sockopt_sk.c
@@ -14,13 +14,12 @@ struct sockopt_sk {
 	__u8 val;
 };
 
-struct bpf_map_def SEC("maps") socket_storage_map = {
-	.type = BPF_MAP_TYPE_SK_STORAGE,
-	.key_size = sizeof(int),
-	.value_size = sizeof(struct sockopt_sk),
-	.map_flags = BPF_F_NO_PREALLOC,
-};
-BPF_ANNOTATE_KV_PAIR(socket_storage_map, int, struct sockopt_sk);
+struct {
+	__uint(type, BPF_MAP_TYPE_SK_STORAGE);
+	__uint(map_flags, BPF_F_NO_PREALLOC);
+	__type(key, int);
+	__type(value, struct sockopt_sk);
+} socket_storage_map SEC(".maps");
 
 SEC("cgroup/getsockopt")
 int _getsockopt(struct bpf_sockopt *ctx)
diff --git a/tools/testing/selftests/bpf/progs/tcp_rtt.c b/tools/testing/selftests/bpf/progs/tcp_rtt.c
index 233bdcb1659e..2cf813a06b83 100644
--- a/tools/testing/selftests/bpf/progs/tcp_rtt.c
+++ b/tools/testing/selftests/bpf/progs/tcp_rtt.c
@@ -13,13 +13,12 @@ struct tcp_rtt_storage {
 	__u32 icsk_retransmits;
 };
 
-struct bpf_map_def SEC("maps") socket_storage_map = {
-	.type = BPF_MAP_TYPE_SK_STORAGE,
-	.key_size = sizeof(int),
-	.value_size = sizeof(struct tcp_rtt_storage),
-	.map_flags = BPF_F_NO_PREALLOC,
-};
-BPF_ANNOTATE_KV_PAIR(socket_storage_map, int, struct tcp_rtt_storage);
+struct {
+	__uint(type, BPF_MAP_TYPE_SK_STORAGE);
+	__uint(map_flags, BPF_F_NO_PREALLOC);
+	__type(key, int);
+	__type(value, struct tcp_rtt_storage);
+} socket_storage_map SEC(".maps");
 
 SEC("sockops")
 int _sockops(struct bpf_sock_ops *ctx)
diff --git a/tools/testing/selftests/bpf/progs/test_btf_haskv.c b/tools/testing/selftests/bpf/progs/test_btf_haskv.c
index e5c79fe0ffdb..763c51447c19 100644
--- a/tools/testing/selftests/bpf/progs/test_btf_haskv.c
+++ b/tools/testing/selftests/bpf/progs/test_btf_haskv.c
@@ -2,6 +2,7 @@
 /* Copyright (c) 2018 Facebook */
 #include <linux/bpf.h>
 #include "bpf_helpers.h"
+#include "bpf_legacy.h"
 
 int _version SEC("version") = 1;
 
diff --git a/tools/testing/selftests/bpf/progs/test_btf_newkv.c b/tools/testing/selftests/bpf/progs/test_btf_newkv.c
index 5ee3622ddebb..96f9e8451029 100644
--- a/tools/testing/selftests/bpf/progs/test_btf_newkv.c
+++ b/tools/testing/selftests/bpf/progs/test_btf_newkv.c
@@ -2,6 +2,7 @@
 /* Copyright (c) 2018 Facebook */
 #include <linux/bpf.h>
 #include "bpf_helpers.h"
+#include "bpf_legacy.h"
 
 int _version SEC("version") = 1;
 
-- 
2.17.1

