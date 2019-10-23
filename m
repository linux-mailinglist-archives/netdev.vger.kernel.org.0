Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7762DE11EF
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 08:09:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731961AbfJWGJv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 02:09:51 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:2010 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725796AbfJWGJv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Oct 2019 02:09:51 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x9N69mto015475
        for <netdev@vger.kernel.org>; Tue, 22 Oct 2019 23:09:50 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=CveCnJv9JWTKsW+4AKnwASjvVwxKVlYYo4TDMb7R/xc=;
 b=bwEGumzUNREExDg9O0mVgidwoLFtbHiLjkrSohxIrGJb01PU/JO9IirFHABvdiQvVcUo
 DgfXOMVwPtkOnSLUhXR2ZSMHg9b4rs7Jxux60IdrcO1PVFBQ6ndiO6ApdvUYMpg9Wb6L
 wyi29u9jKoKrRZ/iC8XzGjzfF7u9euPr2mM= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2vt9td1qnf-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 22 Oct 2019 23:09:50 -0700
Received: from 2401:db00:30:6007:face:0:1:0 (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 22 Oct 2019 23:09:16 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id 711E18619F8; Tue, 22 Oct 2019 23:09:14 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH bpf-next] selftests/bpf: move test_section_names into test_progs and fix it
Date:   Tue, 22 Oct 2019 23:09:13 -0700
Message-ID: <20191023060913.1713817-1-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-23_01:2019-10-22,2019-10-23 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=999
 mlxscore=0 bulkscore=0 adultscore=0 lowpriorityscore=0 malwarescore=0
 impostorscore=0 clxscore=1015 spamscore=0 phishscore=0 suspectscore=8
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910230061
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make test_section_names into test_progs test. Also fix ESRCH expected
results. Add uprobe/uretprobe and tp/raw_tp test cases.

Fixes: dd4436bb8383 ("libbpf: Teach bpf_object__open to guess program types")
Reported-by: kernel test robot <rong.a.chen@intel.com>
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/testing/selftests/bpf/Makefile          |  2 +-
 .../section_names.c}                          | 90 +++++++------------
 2 files changed, 31 insertions(+), 61 deletions(-)
 rename tools/testing/selftests/bpf/{test_section_names.c => prog_tests/section_names.c} (73%)

diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index 11ff34e7311b..521fbdada5cc 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -28,7 +28,7 @@ LDLIBS += -lcap -lelf -lrt -lpthread
 TEST_GEN_PROGS = test_verifier test_tag test_maps test_lru_map test_lpm_map test_progs \
 	test_align test_verifier_log test_dev_cgroup test_tcpbpf_user \
 	test_sock test_btf test_sockmap get_cgroup_id_user test_socket_cookie \
-	test_cgroup_storage test_select_reuseport test_section_names \
+	test_cgroup_storage test_select_reuseport \
 	test_netcnt test_tcpnotify_user test_sock_fields test_sysctl test_hashmap \
 	test_cgroup_attach xdping test_progs-no_alu32
 
diff --git a/tools/testing/selftests/bpf/test_section_names.c b/tools/testing/selftests/bpf/prog_tests/section_names.c
similarity index 73%
rename from tools/testing/selftests/bpf/test_section_names.c
rename to tools/testing/selftests/bpf/prog_tests/section_names.c
index 29833aeaf0de..9d9351dc2ded 100644
--- a/tools/testing/selftests/bpf/test_section_names.c
+++ b/tools/testing/selftests/bpf/prog_tests/section_names.c
@@ -1,10 +1,8 @@
 // SPDX-License-Identifier: GPL-2.0
 // Copyright (c) 2018 Facebook
+#include <test_progs.h>
 
-#include <err.h>
-#include <bpf/libbpf.h>
-
-#include "bpf_util.h"
+static int duration = 0;
 
 struct sec_name_test {
 	const char sec_name[32];
@@ -20,19 +18,23 @@ struct sec_name_test {
 };
 
 static struct sec_name_test tests[] = {
-	{"InvAliD", {-EINVAL, 0, 0}, {-EINVAL, 0} },
-	{"cgroup", {-EINVAL, 0, 0}, {-EINVAL, 0} },
+	{"InvAliD", {-ESRCH, 0, 0}, {-EINVAL, 0} },
+	{"cgroup", {-ESRCH, 0, 0}, {-EINVAL, 0} },
 	{"socket", {0, BPF_PROG_TYPE_SOCKET_FILTER, 0}, {-EINVAL, 0} },
 	{"kprobe/", {0, BPF_PROG_TYPE_KPROBE, 0}, {-EINVAL, 0} },
+	{"uprobe/", {0, BPF_PROG_TYPE_KPROBE, 0}, {-EINVAL, 0} },
 	{"kretprobe/", {0, BPF_PROG_TYPE_KPROBE, 0}, {-EINVAL, 0} },
+	{"uretprobe/", {0, BPF_PROG_TYPE_KPROBE, 0}, {-EINVAL, 0} },
 	{"classifier", {0, BPF_PROG_TYPE_SCHED_CLS, 0}, {-EINVAL, 0} },
 	{"action", {0, BPF_PROG_TYPE_SCHED_ACT, 0}, {-EINVAL, 0} },
 	{"tracepoint/", {0, BPF_PROG_TYPE_TRACEPOINT, 0}, {-EINVAL, 0} },
+	{"tp/", {0, BPF_PROG_TYPE_TRACEPOINT, 0}, {-EINVAL, 0} },
 	{
 		"raw_tracepoint/",
 		{0, BPF_PROG_TYPE_RAW_TRACEPOINT, 0},
 		{-EINVAL, 0},
 	},
+	{"raw_tp/", {0, BPF_PROG_TYPE_RAW_TRACEPOINT, 0}, {-EINVAL, 0} },
 	{"xdp", {0, BPF_PROG_TYPE_XDP, 0}, {-EINVAL, 0} },
 	{"perf_event", {0, BPF_PROG_TYPE_PERF_EVENT, 0}, {-EINVAL, 0} },
 	{"lwt_in", {0, BPF_PROG_TYPE_LWT_IN, 0}, {-EINVAL, 0} },
@@ -146,7 +148,7 @@ static struct sec_name_test tests[] = {
 	},
 };
 
-static int test_prog_type_by_name(const struct sec_name_test *test)
+static void test_prog_type_by_name(const struct sec_name_test *test)
 {
 	enum bpf_attach_type expected_attach_type;
 	enum bpf_prog_type prog_type;
@@ -155,79 +157,47 @@ static int test_prog_type_by_name(const struct sec_name_test *test)
 	rc = libbpf_prog_type_by_name(test->sec_name, &prog_type,
 				      &expected_attach_type);
 
-	if (rc != test->expected_load.rc) {
-		warnx("prog: unexpected rc=%d for %s", rc, test->sec_name);
-		return -1;
-	}
+	CHECK(rc != test->expected_load.rc, "check_code",
+	      "prog: unexpected rc=%d for %s", rc, test->sec_name);
 
 	if (rc)
-		return 0;
-
-	if (prog_type != test->expected_load.prog_type) {
-		warnx("prog: unexpected prog_type=%d for %s", prog_type,
-		      test->sec_name);
-		return -1;
-	}
+		return;
 
-	if (expected_attach_type != test->expected_load.expected_attach_type) {
-		warnx("prog: unexpected expected_attach_type=%d for %s",
-		      expected_attach_type, test->sec_name);
-		return -1;
-	}
+	CHECK(prog_type != test->expected_load.prog_type, "check_prog_type",
+	      "prog: unexpected prog_type=%d for %s",
+	      prog_type, test->sec_name);
 
-	return 0;
+	CHECK(expected_attach_type != test->expected_load.expected_attach_type,
+	      "check_attach_type", "prog: unexpected expected_attach_type=%d for %s",
+	      expected_attach_type, test->sec_name);
 }
 
-static int test_attach_type_by_name(const struct sec_name_test *test)
+static void test_attach_type_by_name(const struct sec_name_test *test)
 {
 	enum bpf_attach_type attach_type;
 	int rc;
 
 	rc = libbpf_attach_type_by_name(test->sec_name, &attach_type);
 
-	if (rc != test->expected_attach.rc) {
-		warnx("attach: unexpected rc=%d for %s", rc, test->sec_name);
-		return -1;
-	}
+	CHECK(rc != test->expected_attach.rc, "check_ret",
+	      "attach: unexpected rc=%d for %s", rc, test->sec_name);
 
 	if (rc)
-		return 0;
-
-	if (attach_type != test->expected_attach.attach_type) {
-		warnx("attach: unexpected attach_type=%d for %s", attach_type,
-		      test->sec_name);
-		return -1;
-	}
+		return;
 
-	return 0;
+	CHECK(attach_type != test->expected_attach.attach_type,
+	      "check_attach_type", "attach: unexpected attach_type=%d for %s",
+	      attach_type, test->sec_name);
 }
 
-static int run_test_case(const struct sec_name_test *test)
+void test_section_names(void)
 {
-	if (test_prog_type_by_name(test))
-		return -1;
-	if (test_attach_type_by_name(test))
-		return -1;
-	return 0;
-}
-
-static int run_tests(void)
-{
-	int passes = 0;
-	int fails = 0;
 	int i;
 
 	for (i = 0; i < ARRAY_SIZE(tests); ++i) {
-		if (run_test_case(&tests[i]))
-			++fails;
-		else
-			++passes;
-	}
-	printf("Summary: %d PASSED, %d FAILED\n", passes, fails);
-	return fails ? -1 : 0;
-}
+		struct sec_name_test *test = &tests[i];
 
-int main(int argc, char **argv)
-{
-	return run_tests();
+		test_prog_type_by_name(test);
+		test_attach_type_by_name(test);
+	}
 }
-- 
2.17.1

