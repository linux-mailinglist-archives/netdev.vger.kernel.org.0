Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DED3E3676F8
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 03:46:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234321AbhDVBqv convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 21 Apr 2021 21:46:51 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:49924 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S234234AbhDVBqr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Apr 2021 21:46:47 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.43/8.16.0.43) with SMTP id 13M1hDer023493
        for <netdev@vger.kernel.org>; Wed, 21 Apr 2021 18:46:12 -0700
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 38270e08tg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 21 Apr 2021 18:46:12 -0700
Received: from intmgw002.25.frc3.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 21 Apr 2021 18:46:11 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id D586D2ED59F8; Wed, 21 Apr 2021 18:46:10 -0700 (PDT)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii@kernel.org>, <kernel-team@fb.com>
Subject: [PATCH bpf-next 6/6] selftests/bpf: extend linked_maps selftests with static maps
Date:   Wed, 21 Apr 2021 18:45:56 -0700
Message-ID: <20210422014556.3451936-7-andrii@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210422014556.3451936-1-andrii@kernel.org>
References: <20210422014556.3451936-1-andrii@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: jj_G6g1NgsM4ZNMohM55NPhzBFCCq1Fr
X-Proofpoint-GUID: jj_G6g1NgsM4ZNMohM55NPhzBFCCq1Fr
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-21_08:2021-04-21,2021-04-21 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 lowpriorityscore=0 bulkscore=0 spamscore=0 impostorscore=0 mlxlogscore=867
 phishscore=0 suspectscore=0 malwarescore=0 mlxscore=0 adultscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104220014
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add static maps to linked_maps selftests, validating that static maps with the
same name can co-exists in separate files and local references to such maps
are resolved correctly within each individual file.

Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
---
 .../selftests/bpf/prog_tests/linked_maps.c    | 20 ++++++++++++++++++-
 .../selftests/bpf/progs/linked_maps1.c        | 13 ++++++++++++
 .../selftests/bpf/progs/linked_maps2.c        | 18 +++++++++++++++++
 3 files changed, 50 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/linked_maps.c b/tools/testing/selftests/bpf/prog_tests/linked_maps.c
index 85dcaaaf2775..6f51dae65b44 100644
--- a/tools/testing/selftests/bpf/prog_tests/linked_maps.c
+++ b/tools/testing/selftests/bpf/prog_tests/linked_maps.c
@@ -7,13 +7,21 @@
 
 void test_linked_maps(void)
 {
-	int err;
+	int key1 = 1, key2 = 2;
+	int val1 = 42, val2 = 24, val;
+	int err, map_fd1, map_fd2;
 	struct linked_maps *skel;
 
 	skel = linked_maps__open_and_load();
 	if (!ASSERT_OK_PTR(skel, "skel_open"))
 		return;
 
+	map_fd1 = bpf_map__fd(skel->maps.linked_maps1__map_static);
+	ASSERT_OK(bpf_map_update_elem(map_fd1, &key2, &val2, 0), "static_map1_update");
+
+	map_fd2 = bpf_map__fd(skel->maps.linked_maps2__map_static);
+	ASSERT_OK(bpf_map_update_elem(map_fd2, &key1, &val1, 0), "static_map2_update");
+
 	err = linked_maps__attach(skel);
 	if (!ASSERT_OK(err, "skel_attach"))
 		goto cleanup;
@@ -24,6 +32,16 @@ void test_linked_maps(void)
 	ASSERT_EQ(skel->bss->output_first1, 2000, "output_first1");
 	ASSERT_EQ(skel->bss->output_second1, 2, "output_second1");
 	ASSERT_EQ(skel->bss->output_weak1, 2, "output_weak1");
+	ASSERT_EQ(skel->bss->output_static1, val2, "output_static1");
+	ASSERT_OK(bpf_map_lookup_elem(map_fd1, &key1, &val), "static_map1_lookup");
+	ASSERT_EQ(val, 1, "static_map1_key1");
+
+	ASSERT_EQ(skel->bss->output_first2, 1000, "output_first2");
+	ASSERT_EQ(skel->bss->output_second2, 1, "output_second2");
+	ASSERT_EQ(skel->bss->output_weak2, 1, "output_weak2");
+	ASSERT_EQ(skel->bss->output_static2, val1, "output_static2");
+	ASSERT_OK(bpf_map_lookup_elem(map_fd2, &key2, &val), "static_map2_lookup");
+	ASSERT_EQ(val, 2, "static_map2_key2");
 
 cleanup:
 	linked_maps__destroy(skel);
diff --git a/tools/testing/selftests/bpf/progs/linked_maps1.c b/tools/testing/selftests/bpf/progs/linked_maps1.c
index 2f4bab565e64..5644949d63f8 100644
--- a/tools/testing/selftests/bpf/progs/linked_maps1.c
+++ b/tools/testing/selftests/bpf/progs/linked_maps1.c
@@ -37,9 +37,17 @@ struct {
 	__uint(max_entries, 16);
 } map_weak __weak SEC(".maps");
 
+static struct {
+	__uint(type, BPF_MAP_TYPE_HASH);
+	__type(key, int);
+	__type(value, int);
+	__uint(max_entries, 4);
+} map_static SEC(".maps");
+
 int output_first1 = 0;
 int output_second1 = 0;
 int output_weak1 = 0;
+int output_static1 = 0;
 
 SEC("raw_tp/sys_enter")
 int BPF_PROG(handler_enter1)
@@ -52,6 +60,7 @@ int BPF_PROG(handler_enter1)
 	bpf_map_update_elem(&map1, &key_struct, &val_struct, 0);
 	bpf_map_update_elem(&map2, &key, &val, 0);
 	bpf_map_update_elem(&map_weak, &key, &val, 0);
+	bpf_map_update_elem(&map_static, &key, &val, 0);
 
 	return 0;
 }
@@ -76,6 +85,10 @@ int BPF_PROG(handler_exit1)
 	if (val)
 		output_weak1 = *val;
 	
+	val = bpf_map_lookup_elem(&map_static, &key);
+	if (val)
+		output_static1 = *val;
+
 	return 0;
 }
 
diff --git a/tools/testing/selftests/bpf/progs/linked_maps2.c b/tools/testing/selftests/bpf/progs/linked_maps2.c
index 3f1490ea8f37..2b9e11ac0335 100644
--- a/tools/testing/selftests/bpf/progs/linked_maps2.c
+++ b/tools/testing/selftests/bpf/progs/linked_maps2.c
@@ -31,9 +31,22 @@ struct {
 	__uint(max_entries, 16);
 } map_weak __weak SEC(".maps");
 
+static struct {
+	/* different type */
+	__uint(type, BPF_MAP_TYPE_ARRAY);
+	/* key and value are kept int for convenience, they don't have to
+	 * match with map_static in linked_maps1
+	 */
+	__type(key, int);
+	__type(value, int);
+	/* different max_entries */
+	__uint(max_entries, 20);
+} map_static SEC(".maps");
+
 int output_first2 = 0;
 int output_second2 = 0;
 int output_weak2 = 0;
+int output_static2 = 0;
 
 SEC("raw_tp/sys_enter")
 int BPF_PROG(handler_enter2)
@@ -46,6 +59,7 @@ int BPF_PROG(handler_enter2)
 	bpf_map_update_elem(&map1, &key_struct, &val_struct, 0);
 	bpf_map_update_elem(&map2, &key, &val, 0);
 	bpf_map_update_elem(&map_weak, &key, &val, 0);
+	bpf_map_update_elem(&map_static, &key, &val, 0);
 
 	return 0;
 }
@@ -70,6 +84,10 @@ int BPF_PROG(handler_exit2)
 	if (val)
 		output_weak2 = *val;
 
+	val = bpf_map_lookup_elem(&map_static, &key);
+	if (val)
+		output_static2 = *val;
+
 	return 0;
 }
 
-- 
2.30.2

