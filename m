Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 449D7112334
	for <lists+netdev@lfdr.de>; Wed,  4 Dec 2019 08:01:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727349AbfLDHA7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Dec 2019 02:00:59 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:57796 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727320AbfLDHAy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Dec 2019 02:00:54 -0500
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id xB46xHwR026427
        for <netdev@vger.kernel.org>; Tue, 3 Dec 2019 23:00:53 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=SG18/sThYVUhO+lp14ytaA8FU1xE/vARTz3Cslj7d/s=;
 b=S1EE4fwztjj+EnzYbD5lNNDq1UE9NqfRRhZN0z75n+a6zH21hDButxiimjg/JNDDsXNI
 pZLO4TS/IJ8Av5YMF3E25qJndirl/yU1lpXxMUOaFNiw/pnSPiVt3e2Txqz22yw83Jgi
 uRqpFNVbWU2XFKkj37sHwjxIKXSkUhDWtS0= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 2wp7q4g2pr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 03 Dec 2019 23:00:52 -0800
Received: from 2401:db00:2120:81ca:face:0:31:0 (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 3 Dec 2019 23:00:52 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 62BA52EC1853; Tue,  3 Dec 2019 23:00:49 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [RFC PATCH bpf-next 14/16] selftests/bpf: convert few more selftest to skeletons
Date:   Tue, 3 Dec 2019 23:00:13 -0800
Message-ID: <20191204070015.3523523-15-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191204070015.3523523-1-andriin@fb.com>
References: <20191204070015.3523523-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-04_01:2019-12-04,2019-12-03 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=8
 impostorscore=0 lowpriorityscore=0 malwarescore=0 mlxlogscore=999
 bulkscore=0 mlxscore=0 adultscore=0 phishscore=0 clxscore=1015 spamscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912040051
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert few more selftests to use generated BPF skeletons as a demonstration
on how to use it.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 .../selftests/bpf/prog_tests/fentry_fexit.c   | 105 ++++++------------
 .../selftests/bpf/prog_tests/fentry_test.c    |  72 +++++-------
 tools/testing/selftests/bpf/prog_tests/mmap.c |  58 ++++------
 .../bpf/prog_tests/stacktrace_build_id.c      |  79 +++++--------
 .../bpf/prog_tests/stacktrace_build_id_nmi.c  |  84 ++++++--------
 5 files changed, 149 insertions(+), 249 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/fentry_fexit.c b/tools/testing/selftests/bpf/prog_tests/fentry_fexit.c
index 40bcff2cc274..110fcf053fd0 100644
--- a/tools/testing/selftests/bpf/prog_tests/fentry_fexit.c
+++ b/tools/testing/selftests/bpf/prog_tests/fentry_fexit.c
@@ -1,90 +1,59 @@
 // SPDX-License-Identifier: GPL-2.0
 /* Copyright (c) 2019 Facebook */
 #include <test_progs.h>
+#include "test_pkt_access.skel.h"
+#include "fentry_test.skel.h"
+#include "fexit_test.skel.h"
+
+BPF_EMBED_OBJ(pkt_access, "test_pkt_access.o");
+BPF_EMBED_OBJ(fentry, "fentry_test.o");
+BPF_EMBED_OBJ(fexit, "fexit_test.o");
 
 void test_fentry_fexit(void)
 {
-	struct bpf_prog_load_attr attr_fentry = {
-		.file = "./fentry_test.o",
-	};
-	struct bpf_prog_load_attr attr_fexit = {
-		.file = "./fexit_test.o",
-	};
-
-	struct bpf_object *obj_fentry = NULL, *obj_fexit = NULL, *pkt_obj;
-	struct bpf_map *data_map_fentry, *data_map_fexit;
-	char fentry_name[] = "fentry/bpf_fentry_testX";
-	char fexit_name[] = "fexit/bpf_fentry_testX";
-	int err, pkt_fd, kfree_skb_fd, i;
-	struct bpf_link *link[12] = {};
-	struct bpf_program *prog[12];
-	__u32 duration, retval;
-	const int zero = 0;
-	u64 result[12];
-
-	err = bpf_prog_load("./test_pkt_access.o", BPF_PROG_TYPE_SCHED_CLS,
-			    &pkt_obj, &pkt_fd);
-	if (CHECK(err, "prog_load sched cls", "err %d errno %d\n", err, errno))
+	struct test_pkt_access *pkt_skel = NULL;
+	struct fentry_test *fentry_skel = NULL;
+	struct fexit_test *fexit_skel = NULL;
+	__u64 *fentry_res, *fexit_res;
+	__u32 duration = 0, retval;
+	int err, pkt_fd, i;
+
+	pkt_skel = test_pkt_access__open_and_load(&pkt_access_embed);
+	if (CHECK(!pkt_skel, "pkt_skel_load", "pkt_access skeleton failed\n"))
 		return;
-	err = bpf_prog_load_xattr(&attr_fentry, &obj_fentry, &kfree_skb_fd);
-	if (CHECK(err, "prog_load fail", "err %d errno %d\n", err, errno))
+	fentry_skel = fentry_test__open_and_load(&fentry_embed);
+	if (CHECK(!fentry_skel, "fentry_skel_load", "fentry skeleton failed\n"))
 		goto close_prog;
-	err = bpf_prog_load_xattr(&attr_fexit, &obj_fexit, &kfree_skb_fd);
-	if (CHECK(err, "prog_load fail", "err %d errno %d\n", err, errno))
+	fexit_skel = fexit_test__open_and_load(&fexit_embed);
+	if (CHECK(!fexit_skel, "fexit_skel_load", "fexit skeleton failed\n"))
 		goto close_prog;
 
-	for (i = 0; i < 6; i++) {
-		fentry_name[sizeof(fentry_name) - 2] = '1' + i;
-		prog[i] = bpf_object__find_program_by_title(obj_fentry, fentry_name);
-		if (CHECK(!prog[i], "find_prog", "prog %s not found\n", fentry_name))
-			goto close_prog;
-		link[i] = bpf_program__attach_trace(prog[i]);
-		if (CHECK(IS_ERR(link[i]), "attach_trace", "failed to link\n"))
-			goto close_prog;
-	}
-	data_map_fentry = bpf_object__find_map_by_name(obj_fentry, "fentry_t.bss");
-	if (CHECK(!data_map_fentry, "find_data_map", "data map not found\n"))
+	err = fentry_test__attach(fentry_skel);
+	if (CHECK(err, "fentry_attach", "fentry attach failed: %d\n", err))
 		goto close_prog;
-
-	for (i = 6; i < 12; i++) {
-		fexit_name[sizeof(fexit_name) - 2] = '1' + i - 6;
-		prog[i] = bpf_object__find_program_by_title(obj_fexit, fexit_name);
-		if (CHECK(!prog[i], "find_prog", "prog %s not found\n", fexit_name))
-			goto close_prog;
-		link[i] = bpf_program__attach_trace(prog[i]);
-		if (CHECK(IS_ERR(link[i]), "attach_trace", "failed to link\n"))
-			goto close_prog;
-	}
-	data_map_fexit = bpf_object__find_map_by_name(obj_fexit, "fexit_te.bss");
-	if (CHECK(!data_map_fexit, "find_data_map", "data map not found\n"))
+	err = fexit_test__attach(fexit_skel);
+	if (CHECK(err, "fexit_attach", "fexit attach failed: %d\n", err))
 		goto close_prog;
 
+	pkt_fd = bpf_program__fd(pkt_skel->progs.test_pkt_access);
 	err = bpf_prog_test_run(pkt_fd, 1, &pkt_v6, sizeof(pkt_v6),
 				NULL, NULL, &retval, &duration);
 	CHECK(err || retval, "ipv6",
 	      "err %d errno %d retval %d duration %d\n",
 	      err, errno, retval, duration);
 
-	err = bpf_map_lookup_elem(bpf_map__fd(data_map_fentry), &zero, &result);
-	if (CHECK(err, "get_result",
-		  "failed to get output data: %d\n", err))
-		goto close_prog;
-
-	err = bpf_map_lookup_elem(bpf_map__fd(data_map_fexit), &zero, result + 6);
-	if (CHECK(err, "get_result",
-		  "failed to get output data: %d\n", err))
-		goto close_prog;
-
-	for (i = 0; i < 12; i++)
-		if (CHECK(result[i] != 1, "result", "bpf_fentry_test%d failed err %ld\n",
-			  i % 6 + 1, result[i]))
-			goto close_prog;
+	fentry_res = (__u64 *)fentry_skel->bss;
+	fexit_res = (__u64 *)fexit_skel->bss;
+	printf("%lld\n", fentry_skel->bss->test1_result);
+	for (i = 0; i < 6; i++) {
+		CHECK(fentry_res[i] != 1, "result",
+		      "fentry_test%d failed err %lld\n", i + 1, fentry_res[i]);
+		CHECK(fexit_res[i] != 1, "result",
+		      "fexit_test%d failed err %lld\n", i + 1, fexit_res[i]);
+	}
 
 close_prog:
-	for (i = 0; i < 12; i++)
-		if (!IS_ERR_OR_NULL(link[i]))
-			bpf_link__destroy(link[i]);
-	bpf_object__close(obj_fentry);
-	bpf_object__close(obj_fexit);
-	bpf_object__close(pkt_obj);
+	test_pkt_access__destroy(pkt_skel);
+	fentry_test__destroy(fentry_skel);
+	fexit_test__destroy(fexit_skel);
 }
diff --git a/tools/testing/selftests/bpf/prog_tests/fentry_test.c b/tools/testing/selftests/bpf/prog_tests/fentry_test.c
index 9fb103193878..46a4afdf507a 100644
--- a/tools/testing/selftests/bpf/prog_tests/fentry_test.c
+++ b/tools/testing/selftests/bpf/prog_tests/fentry_test.c
@@ -1,64 +1,46 @@
 // SPDX-License-Identifier: GPL-2.0
 /* Copyright (c) 2019 Facebook */
 #include <test_progs.h>
+#include "test_pkt_access.skel.h"
+#include "fentry_test.skel.h"
+
+BPF_EMBED_OBJ_DECLARE(pkt_access);
+BPF_EMBED_OBJ_DECLARE(fentry);
 
 void test_fentry_test(void)
 {
-	struct bpf_prog_load_attr attr = {
-		.file = "./fentry_test.o",
-	};
-
-	char prog_name[] = "fentry/bpf_fentry_testX";
-	struct bpf_object *obj = NULL, *pkt_obj;
-	int err, pkt_fd, kfree_skb_fd, i;
-	struct bpf_link *link[6] = {};
-	struct bpf_program *prog[6];
+	struct test_pkt_access *pkt_skel = NULL;
+	struct fentry_test *fentry_skel = NULL;
+	int err, pkt_fd, i;
 	__u32 duration, retval;
-	struct bpf_map *data_map;
-	const int zero = 0;
-	u64 result[6];
+	__u64 *result;
 
-	err = bpf_prog_load("./test_pkt_access.o", BPF_PROG_TYPE_SCHED_CLS,
-			    &pkt_obj, &pkt_fd);
-	if (CHECK(err, "prog_load sched cls", "err %d errno %d\n", err, errno))
+	pkt_skel = test_pkt_access__open_and_load(&pkt_access_embed);
+	if (CHECK(!pkt_skel, "pkt_skel_load", "pkt_access skeleton failed\n"))
 		return;
-	err = bpf_prog_load_xattr(&attr, &obj, &kfree_skb_fd);
-	if (CHECK(err, "prog_load fail", "err %d errno %d\n", err, errno))
-		goto close_prog;
+	fentry_skel = fentry_test__open_and_load(&fentry_embed);
+	if (CHECK(!fentry_skel, "fentry_skel_load", "fentry skeleton failed\n"))
+		goto cleanup;
 
-	for (i = 0; i < 6; i++) {
-		prog_name[sizeof(prog_name) - 2] = '1' + i;
-		prog[i] = bpf_object__find_program_by_title(obj, prog_name);
-		if (CHECK(!prog[i], "find_prog", "prog %s not found\n", prog_name))
-			goto close_prog;
-		link[i] = bpf_program__attach_trace(prog[i]);
-		if (CHECK(IS_ERR(link[i]), "attach_trace", "failed to link\n"))
-			goto close_prog;
-	}
-	data_map = bpf_object__find_map_by_name(obj, "fentry_t.bss");
-	if (CHECK(!data_map, "find_data_map", "data map not found\n"))
-		goto close_prog;
+	err = fentry_test__attach(fentry_skel);
+	if (CHECK(err, "fentry_attach", "fentry attach failed: %d\n", err))
+		goto cleanup;
 
+	pkt_fd = bpf_program__fd(pkt_skel->progs.test_pkt_access);
 	err = bpf_prog_test_run(pkt_fd, 1, &pkt_v6, sizeof(pkt_v6),
 				NULL, NULL, &retval, &duration);
 	CHECK(err || retval, "ipv6",
 	      "err %d errno %d retval %d duration %d\n",
 	      err, errno, retval, duration);
 
-	err = bpf_map_lookup_elem(bpf_map__fd(data_map), &zero, &result);
-	if (CHECK(err, "get_result",
-		  "failed to get output data: %d\n", err))
-		goto close_prog;
-
-	for (i = 0; i < 6; i++)
-		if (CHECK(result[i] != 1, "result", "bpf_fentry_test%d failed err %ld\n",
-			  i + 1, result[i]))
-			goto close_prog;
+	result = (__u64 *)fentry_skel->bss;
+	for (i = 0; i < 6; i++) {
+		if (CHECK(result[i] != 1, "result",
+			  "fentry_test%d failed err %lld\n", i + 1, result[i]))
+			goto cleanup;
+	}
 
-close_prog:
-	for (i = 0; i < 6; i++)
-		if (!IS_ERR_OR_NULL(link[i]))
-			bpf_link__destroy(link[i]);
-	bpf_object__close(obj);
-	bpf_object__close(pkt_obj);
+cleanup:
+	fentry_test__destroy(fentry_skel);
+	test_pkt_access__destroy(pkt_skel);
 }
diff --git a/tools/testing/selftests/bpf/prog_tests/mmap.c b/tools/testing/selftests/bpf/prog_tests/mmap.c
index 051a6d48762c..95a44d37ccea 100644
--- a/tools/testing/selftests/bpf/prog_tests/mmap.c
+++ b/tools/testing/selftests/bpf/prog_tests/mmap.c
@@ -1,59 +1,41 @@
 // SPDX-License-Identifier: GPL-2.0
 #include <test_progs.h>
 #include <sys/mman.h>
+#include "test_mmap.skel.h"
 
 struct map_data {
 	__u64 val[512 * 4];
 };
 
-struct bss_data {
-	__u64 in_val;
-	__u64 out_val;
-};
-
 static size_t roundup_page(size_t sz)
 {
 	long page_size = sysconf(_SC_PAGE_SIZE);
 	return (sz + page_size - 1) / page_size * page_size;
 }
 
+BPF_EMBED_OBJ(test_mmap, "test_mmap.o");
+
 void test_mmap(void)
 {
-	const char *file = "test_mmap.o";
-	const char *probe_name = "raw_tracepoint/sys_enter";
-	const char *tp_name = "sys_enter";
-	const size_t bss_sz = roundup_page(sizeof(struct bss_data));
+	const size_t bss_sz = roundup_page(sizeof(struct test_mmap__bss));
 	const size_t map_sz = roundup_page(sizeof(struct map_data));
 	const int zero = 0, one = 1, two = 2, far = 1500;
 	const long page_size = sysconf(_SC_PAGE_SIZE);
 	int err, duration = 0, i, data_map_fd;
-	struct bpf_program *prog;
-	struct bpf_object *obj;
-	struct bpf_link *link = NULL;
 	struct bpf_map *data_map, *bss_map;
 	void *bss_mmaped = NULL, *map_mmaped = NULL, *tmp1, *tmp2;
-	volatile struct bss_data *bss_data;
-	volatile struct map_data *map_data;
+	struct test_mmap__bss *bss_data;
+	struct map_data *map_data;
+	struct test_mmap *skel;
 	__u64 val = 0;
 
-	obj = bpf_object__open_file("test_mmap.o", NULL);
-	if (CHECK(IS_ERR(obj), "obj_open", "failed to open '%s': %ld\n",
-		  file, PTR_ERR(obj)))
+
+	skel = test_mmap__open_and_load(&test_mmap_embed);
+	if (CHECK(!skel, "skel_open_and_load", "skeleton open/load failed\n"))
 		return;
-	prog = bpf_object__find_program_by_title(obj, probe_name);
-	if (CHECK(!prog, "find_probe", "prog '%s' not found\n", probe_name))
-		goto cleanup;
-	err = bpf_object__load(obj);
-	if (CHECK(err, "obj_load", "failed to load prog '%s': %d\n",
-		  probe_name, err))
-		goto cleanup;
 
-	bss_map = bpf_object__find_map_by_name(obj, "test_mma.bss");
-	if (CHECK(!bss_map, "find_bss_map", ".bss map not found\n"))
-		goto cleanup;
-	data_map = bpf_object__find_map_by_name(obj, "data_map");
-	if (CHECK(!data_map, "find_data_map", "data_map map not found\n"))
-		goto cleanup;
+	bss_map = skel->maps.bss;
+	data_map = skel->maps.data_map;
 	data_map_fd = bpf_map__fd(data_map);
 
 	bss_mmaped = mmap(NULL, bss_sz, PROT_READ | PROT_WRITE, MAP_SHARED,
@@ -77,13 +59,15 @@ void test_mmap(void)
 
 	CHECK_FAIL(bss_data->in_val);
 	CHECK_FAIL(bss_data->out_val);
+	CHECK_FAIL(skel->bss->in_val);
+	CHECK_FAIL(skel->bss->out_val);
 	CHECK_FAIL(map_data->val[0]);
 	CHECK_FAIL(map_data->val[1]);
 	CHECK_FAIL(map_data->val[2]);
 	CHECK_FAIL(map_data->val[far]);
 
-	link = bpf_program__attach_raw_tracepoint(prog, tp_name);
-	if (CHECK(IS_ERR(link), "attach_raw_tp", "err %ld\n", PTR_ERR(link)))
+	err = test_mmap__attach(skel);
+	if (CHECK(err, "attach_raw_tp", "err %d\n", err))
 		goto cleanup;
 
 	bss_data->in_val = 123;
@@ -94,6 +78,8 @@ void test_mmap(void)
 
 	CHECK_FAIL(bss_data->in_val != 123);
 	CHECK_FAIL(bss_data->out_val != 123);
+	CHECK_FAIL(skel->bss->in_val != 123);
+	CHECK_FAIL(skel->bss->out_val != 123);
 	CHECK_FAIL(map_data->val[0] != 111);
 	CHECK_FAIL(map_data->val[1] != 222);
 	CHECK_FAIL(map_data->val[2] != 123);
@@ -160,6 +146,8 @@ void test_mmap(void)
 	usleep(1);
 	CHECK_FAIL(bss_data->in_val != 321);
 	CHECK_FAIL(bss_data->out_val != 321);
+	CHECK_FAIL(skel->bss->in_val != 321);
+	CHECK_FAIL(skel->bss->out_val != 321);
 	CHECK_FAIL(map_data->val[0] != 111);
 	CHECK_FAIL(map_data->val[1] != 222);
 	CHECK_FAIL(map_data->val[2] != 321);
@@ -203,6 +191,8 @@ void test_mmap(void)
 	map_data = tmp2;
 	CHECK_FAIL(bss_data->in_val != 321);
 	CHECK_FAIL(bss_data->out_val != 321);
+	CHECK_FAIL(skel->bss->in_val != 321);
+	CHECK_FAIL(skel->bss->out_val != 321);
 	CHECK_FAIL(map_data->val[0] != 111);
 	CHECK_FAIL(map_data->val[1] != 222);
 	CHECK_FAIL(map_data->val[2] != 321);
@@ -214,7 +204,5 @@ void test_mmap(void)
 		CHECK_FAIL(munmap(bss_mmaped, bss_sz));
 	if (map_mmaped)
 		CHECK_FAIL(munmap(map_mmaped, map_sz));
-	if (!IS_ERR_OR_NULL(link))
-		bpf_link__destroy(link);
-	bpf_object__close(obj);
+	test_mmap__destroy(skel);
 }
diff --git a/tools/testing/selftests/bpf/prog_tests/stacktrace_build_id.c b/tools/testing/selftests/bpf/prog_tests/stacktrace_build_id.c
index d841dced971f..4af8b8253f25 100644
--- a/tools/testing/selftests/bpf/prog_tests/stacktrace_build_id.c
+++ b/tools/testing/selftests/bpf/prog_tests/stacktrace_build_id.c
@@ -1,16 +1,16 @@
 // SPDX-License-Identifier: GPL-2.0
 #include <test_progs.h>
+#include "test_stacktrace_build_id.skel.h"
+
+BPF_EMBED_OBJ(stacktrace_build_id, "test_stacktrace_build_id.o");
 
 void test_stacktrace_build_id(void)
 {
+
 	int control_map_fd, stackid_hmap_fd, stackmap_fd, stack_amap_fd;
-	const char *prog_name = "tracepoint/random/urandom_read";
-	const char *file = "./test_stacktrace_build_id.o";
-	int err, prog_fd, stack_trace_len;
+	struct test_stacktrace_build_id *skel;
+	int err, stack_trace_len;
 	__u32 key, previous_key, val, duration = 0;
-	struct bpf_program *prog;
-	struct bpf_object *obj;
-	struct bpf_link *link = NULL;
 	char buf[256];
 	int i, j;
 	struct bpf_stack_build_id id_offs[PERF_MAX_STACK_DEPTH];
@@ -18,43 +18,24 @@ void test_stacktrace_build_id(void)
 	int retry = 1;
 
 retry:
-	err = bpf_prog_load(file, BPF_PROG_TYPE_TRACEPOINT, &obj, &prog_fd);
-	if (CHECK(err, "prog_load", "err %d errno %d\n", err, errno))
+	skel = test_stacktrace_build_id__open_and_load(&stacktrace_build_id_embed);
+	if (CHECK(!skel, "skel_open_and_load", "skeleton open/load failed\n"))
 		return;
 
-	prog = bpf_object__find_program_by_title(obj, prog_name);
-	if (CHECK(!prog, "find_prog", "prog '%s' not found\n", prog_name))
-		goto close_prog;
-
-	link = bpf_program__attach_tracepoint(prog, "random", "urandom_read");
-	if (CHECK(IS_ERR(link), "attach_tp", "err %ld\n", PTR_ERR(link)))
-		goto close_prog;
+	err = test_stacktrace_build_id__attach(skel);
+	if (CHECK(err, "attach_tp", "err %d\n", err))
+		goto cleanup;
 
 	/* find map fds */
-	control_map_fd = bpf_find_map(__func__, obj, "control_map");
-	if (CHECK(control_map_fd < 0, "bpf_find_map control_map",
-		  "err %d errno %d\n", err, errno))
-		goto disable_pmu;
-
-	stackid_hmap_fd = bpf_find_map(__func__, obj, "stackid_hmap");
-	if (CHECK(stackid_hmap_fd < 0, "bpf_find_map stackid_hmap",
-		  "err %d errno %d\n", err, errno))
-		goto disable_pmu;
-
-	stackmap_fd = bpf_find_map(__func__, obj, "stackmap");
-	if (CHECK(stackmap_fd < 0, "bpf_find_map stackmap", "err %d errno %d\n",
-		  err, errno))
-		goto disable_pmu;
-
-	stack_amap_fd = bpf_find_map(__func__, obj, "stack_amap");
-	if (CHECK(stack_amap_fd < 0, "bpf_find_map stack_amap",
-		  "err %d errno %d\n", err, errno))
-		goto disable_pmu;
+	control_map_fd = bpf_map__fd(skel->maps.control_map);
+	stackid_hmap_fd = bpf_map__fd(skel->maps.stackid_hmap);
+	stackmap_fd = bpf_map__fd(skel->maps.stackmap);
+	stack_amap_fd = bpf_map__fd(skel->maps.stack_amap);
 
 	if (CHECK_FAIL(system("dd if=/dev/urandom of=/dev/zero count=4 2> /dev/null")))
-		goto disable_pmu;
+		goto cleanup;
 	if (CHECK_FAIL(system("./urandom_read")))
-		goto disable_pmu;
+		goto cleanup;
 	/* disable stack trace collection */
 	key = 0;
 	val = 1;
@@ -66,23 +47,23 @@ void test_stacktrace_build_id(void)
 	err = compare_map_keys(stackid_hmap_fd, stackmap_fd);
 	if (CHECK(err, "compare_map_keys stackid_hmap vs. stackmap",
 		  "err %d errno %d\n", err, errno))
-		goto disable_pmu;
+		goto cleanup;
 
 	err = compare_map_keys(stackmap_fd, stackid_hmap_fd);
 	if (CHECK(err, "compare_map_keys stackmap vs. stackid_hmap",
 		  "err %d errno %d\n", err, errno))
-		goto disable_pmu;
+		goto cleanup;
 
 	err = extract_build_id(buf, 256);
 
 	if (CHECK(err, "get build_id with readelf",
 		  "err %d errno %d\n", err, errno))
-		goto disable_pmu;
+		goto cleanup;
 
 	err = bpf_map_get_next_key(stackmap_fd, NULL, &key);
 	if (CHECK(err, "get_next_key from stackmap",
 		  "err %d, errno %d\n", err, errno))
-		goto disable_pmu;
+		goto cleanup;
 
 	do {
 		char build_id[64];
@@ -90,7 +71,7 @@ void test_stacktrace_build_id(void)
 		err = bpf_map_lookup_elem(stackmap_fd, &key, id_offs);
 		if (CHECK(err, "lookup_elem from stackmap",
 			  "err %d, errno %d\n", err, errno))
-			goto disable_pmu;
+			goto cleanup;
 		for (i = 0; i < PERF_MAX_STACK_DEPTH; ++i)
 			if (id_offs[i].status == BPF_STACK_BUILD_ID_VALID &&
 			    id_offs[i].offset != 0) {
@@ -108,8 +89,7 @@ void test_stacktrace_build_id(void)
 	 * try it one more time.
 	 */
 	if (build_id_matches < 1 && retry--) {
-		bpf_link__destroy(link);
-		bpf_object__close(obj);
+		test_stacktrace_build_id__destroy(skel);
 		printf("%s:WARN:Didn't find expected build ID from the map, retrying\n",
 		       __func__);
 		goto retry;
@@ -117,17 +97,14 @@ void test_stacktrace_build_id(void)
 
 	if (CHECK(build_id_matches < 1, "build id match",
 		  "Didn't find expected build ID from the map\n"))
-		goto disable_pmu;
+		goto cleanup;
 
-	stack_trace_len = PERF_MAX_STACK_DEPTH
-		* sizeof(struct bpf_stack_build_id);
+	stack_trace_len = PERF_MAX_STACK_DEPTH *
+			  sizeof(struct bpf_stack_build_id);
 	err = compare_stack_ips(stackmap_fd, stack_amap_fd, stack_trace_len);
 	CHECK(err, "compare_stack_ips stackmap vs. stack_amap",
 	      "err %d errno %d\n", err, errno);
 
-disable_pmu:
-	bpf_link__destroy(link);
-
-close_prog:
-	bpf_object__close(obj);
+cleanup:
+	test_stacktrace_build_id__destroy(skel);
 }
diff --git a/tools/testing/selftests/bpf/prog_tests/stacktrace_build_id_nmi.c b/tools/testing/selftests/bpf/prog_tests/stacktrace_build_id_nmi.c
index f62aa0eb959b..32fb03881a7b 100644
--- a/tools/testing/selftests/bpf/prog_tests/stacktrace_build_id_nmi.c
+++ b/tools/testing/selftests/bpf/prog_tests/stacktrace_build_id_nmi.c
@@ -1,5 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 #include <test_progs.h>
+#include "test_stacktrace_build_id.skel.h"
 
 static __u64 read_perf_max_sample_freq(void)
 {
@@ -14,21 +15,19 @@ static __u64 read_perf_max_sample_freq(void)
 	return sample_freq;
 }
 
+BPF_EMBED_OBJ_DECLARE(stacktrace_build_id);
+
 void test_stacktrace_build_id_nmi(void)
 {
-	int control_map_fd, stackid_hmap_fd, stackmap_fd, stack_amap_fd;
-	const char *prog_name = "tracepoint/random/urandom_read";
-	const char *file = "./test_stacktrace_build_id.o";
-	int err, pmu_fd, prog_fd;
+	int control_map_fd, stackid_hmap_fd, stackmap_fd;
+	struct test_stacktrace_build_id *skel;
+	int err, pmu_fd;
 	struct perf_event_attr attr = {
 		.freq = 1,
 		.type = PERF_TYPE_HARDWARE,
 		.config = PERF_COUNT_HW_CPU_CYCLES,
 	};
 	__u32 key, previous_key, val, duration = 0;
-	struct bpf_program *prog;
-	struct bpf_object *obj;
-	struct bpf_link *link;
 	char buf[256];
 	int i, j;
 	struct bpf_stack_build_id id_offs[PERF_MAX_STACK_DEPTH];
@@ -38,13 +37,16 @@ void test_stacktrace_build_id_nmi(void)
 	attr.sample_freq = read_perf_max_sample_freq();
 
 retry:
-	err = bpf_prog_load(file, BPF_PROG_TYPE_PERF_EVENT, &obj, &prog_fd);
-	if (CHECK(err, "prog_load", "err %d errno %d\n", err, errno))
+	skel = test_stacktrace_build_id__open(&stacktrace_build_id_embed);
+	if (CHECK(!skel, "skel_open", "skeleton open failed\n"))
 		return;
 
-	prog = bpf_object__find_program_by_title(obj, prog_name);
-	if (CHECK(!prog, "find_prog", "prog '%s' not found\n", prog_name))
-		goto close_prog;
+	/* override program type */
+	bpf_program__set_perf_event(skel->progs.oncpu);
+
+	err = test_stacktrace_build_id__load(skel);
+	if (CHECK(err, "skel_load", "skeleton load failed: %d\n", err))
+		goto cleanup;
 
 	pmu_fd = syscall(__NR_perf_event_open, &attr, -1 /* pid */,
 			 0 /* cpu 0 */, -1 /* group id */,
@@ -52,40 +54,25 @@ void test_stacktrace_build_id_nmi(void)
 	if (CHECK(pmu_fd < 0, "perf_event_open",
 		  "err %d errno %d. Does the test host support PERF_COUNT_HW_CPU_CYCLES?\n",
 		  pmu_fd, errno))
-		goto close_prog;
+		goto cleanup;
 
-	link = bpf_program__attach_perf_event(prog, pmu_fd);
-	if (CHECK(IS_ERR(link), "attach_perf_event",
-		  "err %ld\n", PTR_ERR(link))) {
+	skel->links.oncpu = bpf_program__attach_perf_event(skel->progs.oncpu,
+							   pmu_fd);
+	if (CHECK(IS_ERR(skel->links.oncpu), "attach_perf_event",
+		  "err %ld\n", PTR_ERR(skel->links.oncpu))) {
 		close(pmu_fd);
-		goto close_prog;
+		goto cleanup;
 	}
 
 	/* find map fds */
-	control_map_fd = bpf_find_map(__func__, obj, "control_map");
-	if (CHECK(control_map_fd < 0, "bpf_find_map control_map",
-		  "err %d errno %d\n", err, errno))
-		goto disable_pmu;
-
-	stackid_hmap_fd = bpf_find_map(__func__, obj, "stackid_hmap");
-	if (CHECK(stackid_hmap_fd < 0, "bpf_find_map stackid_hmap",
-		  "err %d errno %d\n", err, errno))
-		goto disable_pmu;
-
-	stackmap_fd = bpf_find_map(__func__, obj, "stackmap");
-	if (CHECK(stackmap_fd < 0, "bpf_find_map stackmap", "err %d errno %d\n",
-		  err, errno))
-		goto disable_pmu;
-
-	stack_amap_fd = bpf_find_map(__func__, obj, "stack_amap");
-	if (CHECK(stack_amap_fd < 0, "bpf_find_map stack_amap",
-		  "err %d errno %d\n", err, errno))
-		goto disable_pmu;
+	control_map_fd = bpf_map__fd(skel->maps.control_map);
+	stackid_hmap_fd = bpf_map__fd(skel->maps.stackid_hmap);
+	stackmap_fd = bpf_map__fd(skel->maps.stackmap);
 
 	if (CHECK_FAIL(system("dd if=/dev/urandom of=/dev/zero count=4 2> /dev/null")))
-		goto disable_pmu;
+		goto cleanup;
 	if (CHECK_FAIL(system("taskset 0x1 ./urandom_read 100000")))
-		goto disable_pmu;
+		goto cleanup;
 	/* disable stack trace collection */
 	key = 0;
 	val = 1;
@@ -97,23 +84,23 @@ void test_stacktrace_build_id_nmi(void)
 	err = compare_map_keys(stackid_hmap_fd, stackmap_fd);
 	if (CHECK(err, "compare_map_keys stackid_hmap vs. stackmap",
 		  "err %d errno %d\n", err, errno))
-		goto disable_pmu;
+		goto cleanup;
 
 	err = compare_map_keys(stackmap_fd, stackid_hmap_fd);
 	if (CHECK(err, "compare_map_keys stackmap vs. stackid_hmap",
 		  "err %d errno %d\n", err, errno))
-		goto disable_pmu;
+		goto cleanup;
 
 	err = extract_build_id(buf, 256);
 
 	if (CHECK(err, "get build_id with readelf",
 		  "err %d errno %d\n", err, errno))
-		goto disable_pmu;
+		goto cleanup;
 
 	err = bpf_map_get_next_key(stackmap_fd, NULL, &key);
 	if (CHECK(err, "get_next_key from stackmap",
 		  "err %d, errno %d\n", err, errno))
-		goto disable_pmu;
+		goto cleanup;
 
 	do {
 		char build_id[64];
@@ -121,7 +108,7 @@ void test_stacktrace_build_id_nmi(void)
 		err = bpf_map_lookup_elem(stackmap_fd, &key, id_offs);
 		if (CHECK(err, "lookup_elem from stackmap",
 			  "err %d, errno %d\n", err, errno))
-			goto disable_pmu;
+			goto cleanup;
 		for (i = 0; i < PERF_MAX_STACK_DEPTH; ++i)
 			if (id_offs[i].status == BPF_STACK_BUILD_ID_VALID &&
 			    id_offs[i].offset != 0) {
@@ -139,8 +126,7 @@ void test_stacktrace_build_id_nmi(void)
 	 * try it one more time.
 	 */
 	if (build_id_matches < 1 && retry--) {
-		bpf_link__destroy(link);
-		bpf_object__close(obj);
+		test_stacktrace_build_id__destroy(skel);
 		printf("%s:WARN:Didn't find expected build ID from the map, retrying\n",
 		       __func__);
 		goto retry;
@@ -148,7 +134,7 @@ void test_stacktrace_build_id_nmi(void)
 
 	if (CHECK(build_id_matches < 1, "build id match",
 		  "Didn't find expected build ID from the map\n"))
-		goto disable_pmu;
+		goto cleanup;
 
 	/*
 	 * We intentionally skip compare_stack_ips(). This is because we
@@ -157,8 +143,6 @@ void test_stacktrace_build_id_nmi(void)
 	 * BPF_STACK_BUILD_ID_IP;
 	 */
 
-disable_pmu:
-	bpf_link__destroy(link);
-close_prog:
-	bpf_object__close(obj);
+cleanup:
+	test_stacktrace_build_id__destroy(skel);
 }
-- 
2.17.1

