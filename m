Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6FDB548EA2
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 21:27:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729039AbfFQT11 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 15:27:27 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:59060 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729007AbfFQT10 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 15:27:26 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.27/8.16.0.27) with SMTP id x5HJGnCU011530
        for <netdev@vger.kernel.org>; Mon, 17 Jun 2019 12:27:25 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=6H52IT5iBLxVHI00XhLsJuRggePFAgh+pPsx5rYWGLA=;
 b=D4ZUOrKW8zUCOwWpN6zEd68165sFoy5yJ+POuj+6NvC7XX7iyA452wp5O93K5xJO9wc2
 hNcRN04b3kv35oCguzrzxJjdyKKxgJE4mZhhshQWqK9O3Lh7OKMNR8RD8yPv0QnaXZu0
 Ze6iuOYDZskcFUaFqnmlmPfhgsFC7GjUc4w= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by m0001303.ppops.net with ESMTP id 2t6cvx10dh-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 17 Jun 2019 12:27:25 -0700
Received: from mx-out.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::128) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Mon, 17 Jun 2019 12:27:21 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id EF54286173A; Mon, 17 Jun 2019 12:27:19 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <andrii.nakryiko@gmail.com>, <ast@fb.com>, <daniel@iogearbox.net>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <kernel-team@fb.com>
CC:     Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH v2 bpf-next 09/11] selftests/bpf: switch BPF_ANNOTATE_KV_PAIR tests to BTF-defined maps
Date:   Mon, 17 Jun 2019 12:26:58 -0700
Message-ID: <20190617192700.2313445-10-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190617192700.2313445-1-andriin@fb.com>
References: <20190617192700.2313445-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-17_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906170171
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Switch tests that already rely on BTF to BTF-defined map definitions.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 .../testing/selftests/bpf/progs/netcnt_prog.c | 22 ++++---
 .../selftests/bpf/progs/test_map_lock.c       | 22 +++----
 .../bpf/progs/test_send_signal_kern.c         | 22 +++----
 .../bpf/progs/test_sock_fields_kern.c         | 60 +++++++++++--------
 .../selftests/bpf/progs/test_spin_lock.c      | 33 +++++-----
 5 files changed, 87 insertions(+), 72 deletions(-)

diff --git a/tools/testing/selftests/bpf/progs/netcnt_prog.c b/tools/testing/selftests/bpf/progs/netcnt_prog.c
index 9f741e69cebe..a25c82a5b7c8 100644
--- a/tools/testing/selftests/bpf/progs/netcnt_prog.c
+++ b/tools/testing/selftests/bpf/progs/netcnt_prog.c
@@ -10,24 +10,22 @@
 #define REFRESH_TIME_NS	100000000
 #define NS_PER_SEC	1000000000
 
-struct bpf_map_def SEC("maps") percpu_netcnt = {
+struct {
+	__u32 type;
+	struct bpf_cgroup_storage_key *key;
+	struct percpu_net_cnt *value;
+} percpu_netcnt SEC(".maps") = {
 	.type = BPF_MAP_TYPE_PERCPU_CGROUP_STORAGE,
-	.key_size = sizeof(struct bpf_cgroup_storage_key),
-	.value_size = sizeof(struct percpu_net_cnt),
 };
 
-BPF_ANNOTATE_KV_PAIR(percpu_netcnt, struct bpf_cgroup_storage_key,
-		     struct percpu_net_cnt);
-
-struct bpf_map_def SEC("maps") netcnt = {
+struct {
+	__u32 type;
+	struct bpf_cgroup_storage_key *key;
+	struct net_cnt *value;
+} netcnt SEC(".maps") = {
 	.type = BPF_MAP_TYPE_CGROUP_STORAGE,
-	.key_size = sizeof(struct bpf_cgroup_storage_key),
-	.value_size = sizeof(struct net_cnt),
 };
 
-BPF_ANNOTATE_KV_PAIR(netcnt, struct bpf_cgroup_storage_key,
-		     struct net_cnt);
-
 SEC("cgroup/skb")
 int bpf_nextcnt(struct __sk_buff *skb)
 {
diff --git a/tools/testing/selftests/bpf/progs/test_map_lock.c b/tools/testing/selftests/bpf/progs/test_map_lock.c
index af8cc68ed2f9..40d9c2853393 100644
--- a/tools/testing/selftests/bpf/progs/test_map_lock.c
+++ b/tools/testing/selftests/bpf/progs/test_map_lock.c
@@ -11,29 +11,31 @@ struct hmap_elem {
 	int var[VAR_NUM];
 };
 
-struct bpf_map_def SEC("maps") hash_map = {
+struct {
+	__u32 type;
+	__u32 max_entries;
+	__u32 *key;
+	struct hmap_elem *value;
+} hash_map SEC(".maps") = {
 	.type = BPF_MAP_TYPE_HASH,
-	.key_size = sizeof(int),
-	.value_size = sizeof(struct hmap_elem),
 	.max_entries = 1,
 };
 
-BPF_ANNOTATE_KV_PAIR(hash_map, int, struct hmap_elem);
-
 struct array_elem {
 	struct bpf_spin_lock lock;
 	int var[VAR_NUM];
 };
 
-struct bpf_map_def SEC("maps") array_map = {
+struct {
+	__u32 type;
+	__u32 max_entries;
+	int *key;
+	struct array_elem *value;
+} array_map SEC(".maps") = {
 	.type = BPF_MAP_TYPE_ARRAY,
-	.key_size = sizeof(int),
-	.value_size = sizeof(struct array_elem),
 	.max_entries = 1,
 };
 
-BPF_ANNOTATE_KV_PAIR(array_map, int, struct array_elem);
-
 SEC("map_lock_demo")
 int bpf_map_lock_test(struct __sk_buff *skb)
 {
diff --git a/tools/testing/selftests/bpf/progs/test_send_signal_kern.c b/tools/testing/selftests/bpf/progs/test_send_signal_kern.c
index 45a1a1a2c345..6ac68be5d68b 100644
--- a/tools/testing/selftests/bpf/progs/test_send_signal_kern.c
+++ b/tools/testing/selftests/bpf/progs/test_send_signal_kern.c
@@ -4,24 +4,26 @@
 #include <linux/version.h>
 #include "bpf_helpers.h"
 
-struct bpf_map_def SEC("maps") info_map = {
+struct {
+	__u32 type;
+	__u32 max_entries;
+	__u32 *key;
+	__u64 *value;
+} info_map SEC(".maps") = {
 	.type = BPF_MAP_TYPE_ARRAY,
-	.key_size = sizeof(__u32),
-	.value_size = sizeof(__u64),
 	.max_entries = 1,
 };
 
-BPF_ANNOTATE_KV_PAIR(info_map, __u32, __u64);
-
-struct bpf_map_def SEC("maps") status_map = {
+struct {
+	__u32 type;
+	__u32 max_entries;
+	__u32 *key;
+	__u64 *value;
+} status_map SEC(".maps") = {
 	.type = BPF_MAP_TYPE_ARRAY,
-	.key_size = sizeof(__u32),
-	.value_size = sizeof(__u64),
 	.max_entries = 1,
 };
 
-BPF_ANNOTATE_KV_PAIR(status_map, __u32, __u64);
-
 SEC("send_signal_demo")
 int bpf_send_signal_test(void *ctx)
 {
diff --git a/tools/testing/selftests/bpf/progs/test_sock_fields_kern.c b/tools/testing/selftests/bpf/progs/test_sock_fields_kern.c
index 1c39e4ccb7f1..c3d383d650cb 100644
--- a/tools/testing/selftests/bpf/progs/test_sock_fields_kern.c
+++ b/tools/testing/selftests/bpf/progs/test_sock_fields_kern.c
@@ -27,31 +27,43 @@ enum bpf_linum_array_idx {
 	__NR_BPF_LINUM_ARRAY_IDX,
 };
 
-struct bpf_map_def SEC("maps") addr_map = {
+struct {
+	__u32 type;
+	__u32 max_entries;
+	__u32 *key;
+	struct sockaddr_in6 *value;
+} addr_map SEC(".maps") = {
 	.type = BPF_MAP_TYPE_ARRAY,
-	.key_size = sizeof(__u32),
-	.value_size = sizeof(struct sockaddr_in6),
 	.max_entries = __NR_BPF_ADDR_ARRAY_IDX,
 };
 
-struct bpf_map_def SEC("maps") sock_result_map = {
+struct {
+	__u32 type;
+	__u32 max_entries;
+	__u32 *key;
+	struct bpf_sock *value;
+} sock_result_map SEC(".maps") = {
 	.type = BPF_MAP_TYPE_ARRAY,
-	.key_size = sizeof(__u32),
-	.value_size = sizeof(struct bpf_sock),
 	.max_entries = __NR_BPF_RESULT_ARRAY_IDX,
 };
 
-struct bpf_map_def SEC("maps") tcp_sock_result_map = {
+struct {
+	__u32 type;
+	__u32 max_entries;
+	__u32 *key;
+	struct bpf_tcp_sock *value;
+} tcp_sock_result_map SEC(".maps") = {
 	.type = BPF_MAP_TYPE_ARRAY,
-	.key_size = sizeof(__u32),
-	.value_size = sizeof(struct bpf_tcp_sock),
 	.max_entries = __NR_BPF_RESULT_ARRAY_IDX,
 };
 
-struct bpf_map_def SEC("maps") linum_map = {
+struct {
+	__u32 type;
+	__u32 max_entries;
+	__u32 *key;
+	__u32 *value;
+} linum_map SEC(".maps") = {
 	.type = BPF_MAP_TYPE_ARRAY,
-	.key_size = sizeof(__u32),
-	.value_size = sizeof(__u32),
 	.max_entries = __NR_BPF_LINUM_ARRAY_IDX,
 };
 
@@ -60,26 +72,26 @@ struct bpf_spinlock_cnt {
 	__u32 cnt;
 };
 
-struct bpf_map_def SEC("maps") sk_pkt_out_cnt = {
+struct {
+	__u32 type;
+	__u32 map_flags;
+	int *key;
+	struct bpf_spinlock_cnt *value;
+} sk_pkt_out_cnt SEC(".maps") = {
 	.type = BPF_MAP_TYPE_SK_STORAGE,
-	.key_size = sizeof(int),
-	.value_size = sizeof(struct bpf_spinlock_cnt),
-	.max_entries = 0,
 	.map_flags = BPF_F_NO_PREALLOC,
 };
 
-BPF_ANNOTATE_KV_PAIR(sk_pkt_out_cnt, int, struct bpf_spinlock_cnt);
-
-struct bpf_map_def SEC("maps") sk_pkt_out_cnt10 = {
+struct {
+	__u32 type;
+	__u32 map_flags;
+	int *key;
+	struct bpf_spinlock_cnt *value;
+} sk_pkt_out_cnt10 SEC(".maps") = {
 	.type = BPF_MAP_TYPE_SK_STORAGE,
-	.key_size = sizeof(int),
-	.value_size = sizeof(struct bpf_spinlock_cnt),
-	.max_entries = 0,
 	.map_flags = BPF_F_NO_PREALLOC,
 };
 
-BPF_ANNOTATE_KV_PAIR(sk_pkt_out_cnt10, int, struct bpf_spinlock_cnt);
-
 static bool is_loopback6(__u32 *a6)
 {
 	return !a6[0] && !a6[1] && !a6[2] && a6[3] == bpf_htonl(1);
diff --git a/tools/testing/selftests/bpf/progs/test_spin_lock.c b/tools/testing/selftests/bpf/progs/test_spin_lock.c
index 40f904312090..0a77ae36d981 100644
--- a/tools/testing/selftests/bpf/progs/test_spin_lock.c
+++ b/tools/testing/selftests/bpf/progs/test_spin_lock.c
@@ -10,30 +10,29 @@ struct hmap_elem {
 	int test_padding;
 };
 
-struct bpf_map_def SEC("maps") hmap = {
+struct {
+	__u32 type;
+	__u32 max_entries;
+	int *key;
+	struct hmap_elem *value;
+} hmap SEC(".maps") = {
 	.type = BPF_MAP_TYPE_HASH,
-	.key_size = sizeof(int),
-	.value_size = sizeof(struct hmap_elem),
 	.max_entries = 1,
 };
 
-BPF_ANNOTATE_KV_PAIR(hmap, int, struct hmap_elem);
-
-
 struct cls_elem {
 	struct bpf_spin_lock lock;
 	volatile int cnt;
 };
 
-struct bpf_map_def SEC("maps") cls_map = {
+struct {
+	__u32 type;
+	struct bpf_cgroup_storage_key *key;
+	struct cls_elem *value;
+} cls_map SEC(".maps") = {
 	.type = BPF_MAP_TYPE_CGROUP_STORAGE,
-	.key_size = sizeof(struct bpf_cgroup_storage_key),
-	.value_size = sizeof(struct cls_elem),
 };
 
-BPF_ANNOTATE_KV_PAIR(cls_map, struct bpf_cgroup_storage_key,
-		     struct cls_elem);
-
 struct bpf_vqueue {
 	struct bpf_spin_lock lock;
 	/* 4 byte hole */
@@ -42,14 +41,16 @@ struct bpf_vqueue {
 	unsigned int rate;
 };
 
-struct bpf_map_def SEC("maps") vqueue = {
+struct {
+	__u32 type;
+	__u32 max_entries;
+	int *key;
+	struct bpf_vqueue *value;
+} vqueue SEC(".maps") = {
 	.type = BPF_MAP_TYPE_ARRAY,
-	.key_size = sizeof(int),
-	.value_size = sizeof(struct bpf_vqueue),
 	.max_entries = 1,
 };
 
-BPF_ANNOTATE_KV_PAIR(vqueue, int, struct bpf_vqueue);
 #define CREDIT_PER_NS(delta, rate) (((delta) * rate) >> 20)
 
 SEC("spin_lock_demo")
-- 
2.17.1

