Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9150F5DFD
	for <lists+netdev@lfdr.de>; Sat,  9 Nov 2019 09:07:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726492AbfKIIHC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Nov 2019 03:07:02 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:22010 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726426AbfKIIHC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Nov 2019 03:07:02 -0500
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xA9871uK014872
        for <netdev@vger.kernel.org>; Sat, 9 Nov 2019 00:07:01 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=UPMHj786aonZ285FJkdHFg/UnwFPbBVJ4enILNAMk8k=;
 b=HTiRB8E6QNhChrgg1r0eCFaCITlK+siLeqcXxEUgbbBQ8LhI25L66w8VfWm0CavnnJJ/
 6xLsoiak4lXvcQVpNwJIs+AHY/KLweilmuCSOpenSFXhNYJm3ZFTSTD80qKUU2kLh50o
 jJW00lKNRBU7GnxdNeZzyd8BI9c1d4UH6us= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2w5snc001y-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Sat, 09 Nov 2019 00:07:01 -0800
Received: from 2401:db00:2050:5102:face:0:37:0 (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Sat, 9 Nov 2019 00:06:41 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id C081D2EC1AC6; Sat,  9 Nov 2019 00:06:40 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v2 bpf-next 3/3] selftests/bpf: add BPF_TYPE_MAP_ARRAY mmap() tests
Date:   Sat, 9 Nov 2019 00:06:32 -0800
Message-ID: <20191109080633.2855561-4-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191109080633.2855561-1-andriin@fb.com>
References: <20191109080633.2855561-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-09_02:2019-11-08,2019-11-09 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0 phishscore=0
 adultscore=0 lowpriorityscore=0 suspectscore=67 mlxlogscore=689
 priorityscore=1501 mlxscore=0 impostorscore=0 malwarescore=0 clxscore=1015
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911090085
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add selftests validating mmap()-ing BPF array maps: both single-element and
multi-element ones. Check that plain bpf_map_update_elem() and
bpf_map_lookup_elem() work correctly with memory-mapped array. Also convert
CO-RE relocation tests to use memory-mapped views of global data.

Acked-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 .../selftests/bpf/prog_tests/core_reloc.c     |  45 +++--
 tools/testing/selftests/bpf/prog_tests/mmap.c | 170 ++++++++++++++++++
 tools/testing/selftests/bpf/progs/test_mmap.c |  41 +++++
 3 files changed, 238 insertions(+), 18 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/mmap.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_mmap.c

diff --git a/tools/testing/selftests/bpf/prog_tests/core_reloc.c b/tools/testing/selftests/bpf/prog_tests/core_reloc.c
index f94bd071536b..ec9e2fdd6b89 100644
--- a/tools/testing/selftests/bpf/prog_tests/core_reloc.c
+++ b/tools/testing/selftests/bpf/prog_tests/core_reloc.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 #include <test_progs.h>
 #include "progs/core_reloc_types.h"
+#include <sys/mman.h>
 
 #define STRUCT_TO_CHAR_PTR(struct_name) (const char *)&(struct struct_name)
 
@@ -453,8 +454,15 @@ struct data {
 	char out[256];
 };
 
+static size_t roundup_page(size_t sz)
+{
+	long page_size = sysconf(_SC_PAGE_SIZE);
+	return (sz + page_size - 1) / page_size * page_size;
+}
+
 void test_core_reloc(void)
 {
+	const size_t mmap_sz = roundup_page(sizeof(struct data));
 	struct bpf_object_load_attr load_attr = {};
 	struct core_reloc_test_case *test_case;
 	const char *tp_name, *probe_name;
@@ -463,8 +471,8 @@ void test_core_reloc(void)
 	struct bpf_map *data_map;
 	struct bpf_program *prog;
 	struct bpf_object *obj;
-	const int zero = 0;
-	struct data data;
+	struct data *data;
+	void *mmap_data = NULL;
 
 	for (i = 0; i < ARRAY_SIZE(test_cases); i++) {
 		test_case = &test_cases[i];
@@ -476,8 +484,7 @@ void test_core_reloc(void)
 		);
 
 		obj = bpf_object__open_file(test_case->bpf_obj_file, &opts);
-		if (CHECK(IS_ERR_OR_NULL(obj), "obj_open",
-			  "failed to open '%s': %ld\n",
+		if (CHECK(IS_ERR(obj), "obj_open", "failed to open '%s': %ld\n",
 			  test_case->bpf_obj_file, PTR_ERR(obj)))
 			continue;
 
@@ -519,24 +526,22 @@ void test_core_reloc(void)
 		if (CHECK(!data_map, "find_data_map", "data map not found\n"))
 			goto cleanup;
 
-		memset(&data, 0, sizeof(data));
-		memcpy(data.in, test_case->input, test_case->input_len);
-
-		err = bpf_map_update_elem(bpf_map__fd(data_map),
-					  &zero, &data, 0);
-		if (CHECK(err, "update_data_map",
-			  "failed to update .data map: %d\n", err))
+		mmap_data = mmap(NULL, mmap_sz, PROT_READ | PROT_WRITE,
+				 MAP_SHARED, bpf_map__fd(data_map), 0);
+		if (CHECK(mmap_data == MAP_FAILED, "mmap",
+			  ".bss mmap failed: %d", errno)) {
+			mmap_data = NULL;
 			goto cleanup;
+		}
+		data = mmap_data;
+
+		memset(mmap_data, 0, sizeof(*data));
+		memcpy(data->in, test_case->input, test_case->input_len);
 
 		/* trigger test run */
 		usleep(1);
 
-		err = bpf_map_lookup_elem(bpf_map__fd(data_map), &zero, &data);
-		if (CHECK(err, "get_result",
-			  "failed to get output data: %d\n", err))
-			goto cleanup;
-
-		equal = memcmp(data.out, test_case->output,
+		equal = memcmp(data->out, test_case->output,
 			       test_case->output_len) == 0;
 		if (CHECK(!equal, "check_result",
 			  "input/output data don't match\n")) {
@@ -548,12 +553,16 @@ void test_core_reloc(void)
 			}
 			for (j = 0; j < test_case->output_len; j++) {
 				printf("output byte #%d: EXP 0x%02hhx GOT 0x%02hhx\n",
-				       j, test_case->output[j], data.out[j]);
+				       j, test_case->output[j], data->out[j]);
 			}
 			goto cleanup;
 		}
 
 cleanup:
+		if (mmap_data) {
+			CHECK_FAIL(munmap(mmap_data, mmap_sz));
+			mmap_data = NULL;
+		}
 		if (!IS_ERR_OR_NULL(link)) {
 			bpf_link__destroy(link);
 			link = NULL;
diff --git a/tools/testing/selftests/bpf/prog_tests/mmap.c b/tools/testing/selftests/bpf/prog_tests/mmap.c
new file mode 100644
index 000000000000..ef3a4f926764
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/mmap.c
@@ -0,0 +1,170 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <test_progs.h>
+#include <sys/mman.h>
+
+struct map_data {
+	__u64 val[3];
+};
+
+struct bss_data {
+	__u64 in_val;
+	__u64 out_val;
+};
+
+static size_t roundup_page(size_t sz)
+{
+	long page_size = sysconf(_SC_PAGE_SIZE);
+	return (sz + page_size - 1) / page_size * page_size;
+}
+
+void test_mmap(void)
+{
+	const char *file = "test_mmap.o";
+	const char *probe_name = "raw_tracepoint/sys_enter";
+	const char *tp_name = "sys_enter";
+	const size_t bss_sz = roundup_page(sizeof(struct bss_data));
+	const size_t map_sz = roundup_page(sizeof(struct map_data));
+	int err, duration = 0, i, data_map_fd, zero = 0, one = 1, two = 2;
+	struct bpf_program *prog;
+	struct bpf_object *obj;
+	struct bpf_link *link = NULL;
+	struct bpf_map *data_map, *bss_map;
+	void *bss_mmaped = NULL, *map_mmaped = NULL, *tmp_mmaped;
+	volatile struct bss_data *bss_data;
+	volatile struct map_data *map_data;
+	__u64 val = 0;
+
+	obj = bpf_object__open_file("test_mmap.o", NULL);
+	if (CHECK(IS_ERR(obj), "obj_open", "failed to open '%s': %ld\n",
+		  file, PTR_ERR(obj)))
+		return;
+	prog = bpf_object__find_program_by_title(obj, probe_name);
+	if (CHECK(!prog, "find_probe", "prog '%s' not found\n", probe_name))
+		goto cleanup;
+	err = bpf_object__load(obj);
+	if (CHECK(err, "obj_load", "failed to load prog '%s': %d\n",
+		  probe_name, err))
+		goto cleanup;
+
+	bss_map = bpf_object__find_map_by_name(obj, "test_mma.bss");
+	if (CHECK(!bss_map, "find_bss_map", ".bss map not found\n"))
+		goto cleanup;
+	data_map = bpf_object__find_map_by_name(obj, "data_map");
+	if (CHECK(!data_map, "find_data_map", "data_map map not found\n"))
+		goto cleanup;
+	data_map_fd = bpf_map__fd(data_map);
+
+	bss_mmaped = mmap(NULL, bss_sz, PROT_READ | PROT_WRITE, MAP_SHARED,
+			  bpf_map__fd(bss_map), 0);
+	if (CHECK(bss_mmaped == MAP_FAILED, "bss_mmap",
+		  ".bss mmap failed: %d\n", errno)) {
+		bss_mmaped = NULL;
+		goto cleanup;
+	}
+	/* map as R/W first */
+	map_mmaped = mmap(NULL, map_sz, PROT_READ | PROT_WRITE, MAP_SHARED,
+			  data_map_fd, 0);
+	if (CHECK(map_mmaped == MAP_FAILED, "data_mmap",
+		  "data_map mmap failed: %d\n", errno)) {
+		map_mmaped = NULL;
+		goto cleanup;
+	}
+
+	bss_data = bss_mmaped;
+	map_data = map_mmaped;
+
+	CHECK_FAIL(bss_data->in_val);
+	CHECK_FAIL(bss_data->out_val);
+	CHECK_FAIL(map_data->val[0]);
+	CHECK_FAIL(map_data->val[1]);
+	CHECK_FAIL(map_data->val[2]);
+
+	link = bpf_program__attach_raw_tracepoint(prog, tp_name);
+	if (CHECK(IS_ERR(link), "attach_raw_tp", "err %ld\n", PTR_ERR(link)))
+		goto cleanup;
+
+	bss_data->in_val = 123;
+	val = 111;
+	CHECK_FAIL(bpf_map_update_elem(data_map_fd, &zero, &val, 0));
+
+	usleep(1);
+
+	CHECK_FAIL(bss_data->in_val != 123);
+	CHECK_FAIL(bss_data->out_val != 123);
+	CHECK_FAIL(map_data->val[0] != 111);
+	CHECK_FAIL(map_data->val[1] != 222);
+	CHECK_FAIL(map_data->val[2] != 123);
+
+	CHECK_FAIL(bpf_map_lookup_elem(data_map_fd, &zero, &val));
+	CHECK_FAIL(val != 111);
+	CHECK_FAIL(bpf_map_lookup_elem(data_map_fd, &one, &val));
+	CHECK_FAIL(val != 222);
+	CHECK_FAIL(bpf_map_lookup_elem(data_map_fd, &two, &val));
+	CHECK_FAIL(val != 123);
+
+	/* data_map freeze should fail due to R/W mmap() */
+	err = bpf_map_freeze(data_map_fd);
+	if (CHECK(!err || errno != EBUSY, "no_freeze",
+		  "data_map freeze succeeded: err=%d, errno=%d\n", err, errno))
+		goto cleanup;
+
+	/* unmap R/W mapping */
+	err = munmap(map_mmaped, map_sz);
+	map_mmaped = NULL;
+	if (CHECK(err, "data_map_munmap", "data_map munmap failed: %d\n", errno))
+		goto cleanup;
+
+	/* re-map as R/O now */
+	map_mmaped = mmap(NULL, map_sz, PROT_READ, MAP_SHARED, data_map_fd, 0);
+	if (CHECK(map_mmaped == MAP_FAILED, "data_mmap",
+		  "data_map R/O mmap failed: %d\n", errno)) {
+		map_mmaped = NULL;
+		goto cleanup;
+	}
+	map_data = map_mmaped;
+
+	/* map/unmap in a loop to test ref counting */
+	for (i = 0; i < 10; i++) {
+		int flags = i % 2 ? PROT_READ : PROT_WRITE;
+		void *p;
+
+		p = mmap(NULL, map_sz, flags, MAP_SHARED, data_map_fd, 0);
+		if (CHECK_FAIL(p == MAP_FAILED))
+			goto cleanup;
+		err = munmap(p, map_sz);
+		if (CHECK_FAIL(err))
+			goto cleanup;
+	}
+
+	/* data_map freeze should now succeed due to no R/W mapping */
+	err = bpf_map_freeze(data_map_fd);
+	if (CHECK(err, "freeze", "data_map freeze failed: err=%d, errno=%d\n",
+		  err, errno))
+		goto cleanup;
+
+	/* mapping as R/W now should fail */
+	tmp_mmaped = mmap(NULL, map_sz, PROT_READ | PROT_WRITE, MAP_SHARED,
+			  data_map_fd, 0);
+	if (CHECK(tmp_mmaped != MAP_FAILED, "data_mmap",
+		  "data_map mmap succeeded\n")) {
+		munmap(tmp_mmaped, map_sz);
+		goto cleanup;
+	}
+
+	bss_data->in_val = 321;
+	usleep(1);
+	CHECK_FAIL(bss_data->in_val != 321);
+	CHECK_FAIL(bss_data->out_val != 321);
+	CHECK_FAIL(map_data->val[0] != 111);
+	CHECK_FAIL(map_data->val[1] != 222);
+	CHECK_FAIL(map_data->val[2] != 321);
+
+cleanup:
+	if (bss_mmaped)
+		CHECK_FAIL(munmap(bss_mmaped, bss_sz));
+	if (map_mmaped)
+		CHECK_FAIL(munmap(map_mmaped, map_sz));
+	if (!IS_ERR_OR_NULL(link))
+		bpf_link__destroy(link);
+	bpf_object__close(obj);
+}
diff --git a/tools/testing/selftests/bpf/progs/test_mmap.c b/tools/testing/selftests/bpf/progs/test_mmap.c
new file mode 100644
index 000000000000..98e3ea36b88e
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_mmap.c
@@ -0,0 +1,41 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright (c) 2019 Facebook
+
+#include <linux/bpf.h>
+#include <stdint.h>
+#include "bpf_helpers.h"
+
+char _license[] SEC("license") = "GPL";
+
+struct {
+	__uint(type, BPF_MAP_TYPE_ARRAY);
+	__uint(max_entries, 3);
+	__uint(map_flags, BPF_F_MMAPABLE);
+	__type(key, __u32);
+	__type(value, __u64);
+} data_map SEC(".maps");
+
+static volatile __u64 in_val;
+static volatile __u64 out_val;
+
+SEC("raw_tracepoint/sys_enter")
+int test_mmap(void *ctx)
+{
+	int zero = 0, one = 1, two = 2;
+	__u64 val, *p;
+
+	out_val = in_val;
+
+	/* data_map[2] = in_val */
+	bpf_map_update_elem(&data_map, &two, (const void *)&in_val, 0);
+
+	/* data_map[1] = data_map[0] * 2; */
+	p = bpf_map_lookup_elem(&data_map, &zero);
+	if (p) {
+		val = (*p) * 2;
+		bpf_map_update_elem(&data_map, &one, &val, 0);
+	}
+
+	return 0;
+}
+
-- 
2.17.1

