Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECF56369A82
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 20:54:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243807AbhDWSzB convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 23 Apr 2021 14:55:01 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:53682 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S243760AbhDWSy4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Apr 2021 14:54:56 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.43/8.16.0.43) with SMTP id 13NIPx9q025504
        for <netdev@vger.kernel.org>; Fri, 23 Apr 2021 11:54:19 -0700
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 383h1unt0t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 23 Apr 2021 11:54:19 -0700
Received: from intmgw001.37.frc1.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 23 Apr 2021 11:54:18 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 7F5202ED5CA8; Fri, 23 Apr 2021 11:54:11 -0700 (PDT)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii@kernel.org>, <kernel-team@fb.com>
Subject: [PATCH v2 bpf-next 6/6] selftests/bpf: extend linked_maps selftests with static maps
Date:   Fri, 23 Apr 2021 11:53:57 -0700
Message-ID: <20210423185357.1992756-7-andrii@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210423185357.1992756-1-andrii@kernel.org>
References: <20210423185357.1992756-1-andrii@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: 1m0r_wPSlEuy9CUf3TxAJDo-qyLX6jbu
X-Proofpoint-ORIG-GUID: 1m0r_wPSlEuy9CUf3TxAJDo-qyLX6jbu
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-23_07:2021-04-23,2021-04-23 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015
 adultscore=0 malwarescore=0 mlxscore=0 spamscore=0 bulkscore=0
 phishscore=0 impostorscore=0 priorityscore=1501 lowpriorityscore=0
 mlxlogscore=867 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2104060000 definitions=main-2104230121
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
index 52291515cc72..308a13f865ef 100644
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
 int output_first1;
 int output_second1;
 int output_weak1;
+int output_static1;
 
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
index 0693687474ed..840554d5e484 100644
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
 int output_first2;
 int output_second2;
 int output_weak2;
+int output_static2;
 
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

