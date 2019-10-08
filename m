Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F392ED03D9
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 01:10:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729655AbfJHXKY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 19:10:24 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:38994 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725953AbfJHXKY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Oct 2019 19:10:24 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id x98N9vpd012220
        for <netdev@vger.kernel.org>; Tue, 8 Oct 2019 16:10:22 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=knznhfI3h/QRMnYKDtKpwytlxFy5HLpAVbpc2kAM4E4=;
 b=ehxVmXn3bUrwTjc7v7FSQG9FUCYz702Fp5mZFSsFajY3aFMp3Vy/nRmfNOy6cWq58C3T
 ovS8puqTkNPagHKaGzyEMvZH+2P+qGCuNMbBknflm0aItEH+Mo9ECu6R9UB5LWEgPRfy
 gXaCwOUDdPfppjibyy2+A5rPIlnOeAIPdVA= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by m0089730.ppops.net with ESMTP id 2vgprk496a-16
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 08 Oct 2019 16:10:22 -0700
Received: from 2401:db00:30:600c:face:0:1f:0 (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Tue, 8 Oct 2019 16:10:16 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id 043E28618FA; Tue,  8 Oct 2019 16:10:14 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>, <john.fastabend@gmail.com>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH bpf-next 2/3] selftests/bpf: convert test_btf_dump into test_progs test
Date:   Tue, 8 Oct 2019 16:10:07 -0700
Message-ID: <20191008231009.2991130-3-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191008231009.2991130-1-andriin@fb.com>
References: <20191008231009.2991130-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-08_09:2019-10-08,2019-10-08 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0
 priorityscore=1501 adultscore=0 malwarescore=0 phishscore=0 mlxscore=0
 mlxlogscore=999 impostorscore=0 spamscore=0 clxscore=1015 suspectscore=25
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910080183
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert test_btf_dump into a part of test_progs, instead of
a stand-alone test binary.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/testing/selftests/bpf/Makefile          |  2 +-
 .../btf_dump.c}                               | 88 +++++++------------
 2 files changed, 35 insertions(+), 55 deletions(-)
 rename tools/testing/selftests/bpf/{test_btf_dump.c => prog_tests/btf_dump.c} (51%)

diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index 771a4e82128b..0de5d6eb62de 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -29,7 +29,7 @@ TEST_GEN_PROGS = test_verifier test_tag test_maps test_lru_map test_lpm_map test
 	test_sock test_btf test_sockmap get_cgroup_id_user test_socket_cookie \
 	test_cgroup_storage test_select_reuseport test_section_names \
 	test_netcnt test_tcpnotify_user test_sock_fields test_sysctl test_hashmap \
-	test_btf_dump test_cgroup_attach xdping
+	test_cgroup_attach xdping
 
 BPF_OBJ_FILES = $(patsubst %.c,%.o, $(notdir $(wildcard progs/*.c)))
 TEST_GEN_FILES = $(BPF_OBJ_FILES)
diff --git a/tools/testing/selftests/bpf/test_btf_dump.c b/tools/testing/selftests/bpf/prog_tests/btf_dump.c
similarity index 51%
rename from tools/testing/selftests/bpf/test_btf_dump.c
rename to tools/testing/selftests/bpf/prog_tests/btf_dump.c
index 6e75dd3cb14f..7390d3061065 100644
--- a/tools/testing/selftests/bpf/test_btf_dump.c
+++ b/tools/testing/selftests/bpf/prog_tests/btf_dump.c
@@ -1,36 +1,26 @@
-#include <stdio.h>
-#include <stdlib.h>
-#include <string.h>
-#include <unistd.h>
-#include <errno.h>
-#include <linux/err.h>
-#include <btf.h>
-
-#define CHECK(condition, format...) ({					\
-	int __ret = !!(condition);					\
-	if (__ret) {							\
-		fprintf(stderr, "%s:%d:FAIL ", __func__, __LINE__);	\
-		fprintf(stderr, format);				\
-	}								\
-	__ret;								\
-})
+// SPDX-License-Identifier: GPL-2.0
+#include <test_progs.h>
+#include <bpf/btf.h>
+
+static int duration = 0;
 
 void btf_dump_printf(void *ctx, const char *fmt, va_list args)
 {
 	vfprintf(ctx, fmt, args);
 }
 
-struct btf_dump_test_case {
+static struct btf_dump_test_case {
 	const char *name;
+	const char *file;
 	struct btf_dump_opts opts;
 } btf_dump_test_cases[] = {
-	{.name = "btf_dump_test_case_syntax", .opts = {}},
-	{.name = "btf_dump_test_case_ordering", .opts = {}},
-	{.name = "btf_dump_test_case_padding", .opts = {}},
-	{.name = "btf_dump_test_case_packing", .opts = {}},
-	{.name = "btf_dump_test_case_bitfields", .opts = {}},
-	{.name = "btf_dump_test_case_multidim", .opts = {}},
-	{.name = "btf_dump_test_case_namespacing", .opts = {}},
+	{"btf_dump: syntax", "btf_dump_test_case_syntax", {}},
+	{"btf_dump: ordering", "btf_dump_test_case_ordering", {}},
+	{"btf_dump: padding", "btf_dump_test_case_padding", {}},
+	{"btf_dump: packing", "btf_dump_test_case_packing", {}},
+	{"btf_dump: bitfields", "btf_dump_test_case_bitfields", {}},
+	{"btf_dump: multidim", "btf_dump_test_case_multidim", {}},
+	{"btf_dump: namespacing", "btf_dump_test_case_namespacing", {}},
 };
 
 static int btf_dump_all_types(const struct btf *btf,
@@ -55,55 +45,51 @@ static int btf_dump_all_types(const struct btf *btf,
 	return err;
 }
 
-int test_btf_dump_case(int n, struct btf_dump_test_case *test_case)
+static int test_btf_dump_case(int n, struct btf_dump_test_case *t)
 {
 	char test_file[256], out_file[256], diff_cmd[1024];
 	struct btf *btf = NULL;
 	int err = 0, fd = -1;
 	FILE *f = NULL;
 
-	fprintf(stderr, "Test case #%d (%s): ", n, test_case->name);
-
-	snprintf(test_file, sizeof(test_file), "%s.o", test_case->name);
+	snprintf(test_file, sizeof(test_file), "%s.o", t->file);
 
 	btf = btf__parse_elf(test_file, NULL);
-	if (CHECK(IS_ERR(btf),
+	if (CHECK(IS_ERR(btf), "btf_parse_elf",
 	    "failed to load test BTF: %ld\n", PTR_ERR(btf))) {
 		err = -PTR_ERR(btf);
 		btf = NULL;
 		goto done;
 	}
 
-	snprintf(out_file, sizeof(out_file),
-		 "/tmp/%s.output.XXXXXX", test_case->name);
+	snprintf(out_file, sizeof(out_file), "/tmp/%s.output.XXXXXX", t->file);
 	fd = mkstemp(out_file);
-	if (CHECK(fd < 0, "failed to create temp output file: %d\n", fd)) {
+	if (CHECK(fd < 0, "create_tmp", "failed to create file: %d\n", fd)) {
 		err = fd;
 		goto done;
 	}
 	f = fdopen(fd, "w");
-	if (CHECK(f == NULL, "failed to open temp output file: %s(%d)\n",
+	if (CHECK(f == NULL, "open_tmp",  "failed to open file: %s(%d)\n",
 		  strerror(errno), errno)) {
 		close(fd);
 		goto done;
 	}
 
-	test_case->opts.ctx = f;
-	err = btf_dump_all_types(btf, &test_case->opts);
+	t->opts.ctx = f;
+	err = btf_dump_all_types(btf, &t->opts);
 	fclose(f);
 	close(fd);
-	if (CHECK(err, "failure during C dumping: %d\n", err)) {
+	if (CHECK(err, "btf_dump", "failure during C dumping: %d\n", err)) {
 		goto done;
 	}
 
-	snprintf(test_file, sizeof(test_file), "progs/%s.c", test_case->name);
+	snprintf(test_file, sizeof(test_file), "progs/%s.c", t->file);
 	if (access(test_file, R_OK) == -1)
 		/*
 		 * When the test is run with O=, kselftest copies TEST_FILES
 		 * without preserving the directory structure.
 		 */
-		snprintf(test_file, sizeof(test_file), "%s.c",
-			test_case->name);
+		snprintf(test_file, sizeof(test_file), "%s.c", t->file);
 	/*
 	 * Diff test output and expected test output, contained between
 	 * START-EXPECTED-OUTPUT and END-EXPECTED-OUTPUT lines in test case.
@@ -118,33 +104,27 @@ int test_btf_dump_case(int n, struct btf_dump_test_case *test_case)
 		 "out {sub(/^[ \\t]*\\*/, \"\"); print}' '%s' | diff -u - '%s'",
 		 test_file, out_file);
 	err = system(diff_cmd);
-	if (CHECK(err,
+	if (CHECK(err, "diff",
 		  "differing test output, output=%s, err=%d, diff cmd:\n%s\n",
 		  out_file, err, diff_cmd))
 		goto done;
 
 	remove(out_file);
-	fprintf(stderr, "OK\n");
 
 done:
 	btf__free(btf);
 	return err;
 }
 
-int main() {
-	int test_case_cnt, i, err, failed = 0;
-
-	test_case_cnt = sizeof(btf_dump_test_cases) /
-			sizeof(btf_dump_test_cases[0]);
+void test_btf_dump() {
+	int i;
 
-	for (i = 0; i < test_case_cnt; i++) {
-		err = test_btf_dump_case(i, &btf_dump_test_cases[i]);
-		if (err)
-			failed++;
-	}
+	for (i = 0; i < ARRAY_SIZE(btf_dump_test_cases); i++) {
+		struct btf_dump_test_case *t = &btf_dump_test_cases[i];
 
-	fprintf(stderr, "%d tests succeeded, %d tests failed.\n",
-		test_case_cnt - failed, failed);
+		if (!test__start_subtest(t->name))
+			continue;
 
-	return failed;
+		 test_btf_dump_case(i, &btf_dump_test_cases[i]);
+	}
 }
-- 
2.17.1

