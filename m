Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C22391853E6
	for <lists+netdev@lfdr.de>; Sat, 14 Mar 2020 02:39:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727387AbgCNBjv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 21:39:51 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:18048 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726643AbgCNBjt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Mar 2020 21:39:49 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02E1UNID027814
        for <netdev@vger.kernel.org>; Fri, 13 Mar 2020 18:39:47 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=aQXsMx35YZiVw4Cb6/bj9qHwhuQW31yJbw9gG1FBgr4=;
 b=RAyxCP9GXKYgdGmCwUM4OkL3azQAc2pb3tS6OjwbZ5MabJ10t6n48QGRZErl/7QbfaRC
 bD6fr8fLFPpUtR8/ljve+OcHZud4OuNiAQJ+jaCHUyw+yzseiq8RRetORRAXPqk2HAa5
 qVV8k+SKy2FJTOlHFlU/l1IXLLXxCGwxW1g= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2yqt7fqf1q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 13 Mar 2020 18:39:47 -0700
Received: from intmgw002.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Fri, 13 Mar 2020 18:39:46 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 639882EC2D6B; Fri, 13 Mar 2020 18:39:39 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 3/3] selftests/bpf: reset process and thread affinity after each test/sub-test
Date:   Fri, 13 Mar 2020 18:39:32 -0700
Message-ID: <20200314013932.4035712-3-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200314013932.4035712-1-andriin@fb.com>
References: <20200314013932.4035712-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-13_12:2020-03-12,2020-03-13 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=999
 clxscore=1015 malwarescore=0 adultscore=0 suspectscore=25
 priorityscore=1501 bulkscore=0 phishscore=0 impostorscore=0 spamscore=0
 mlxscore=0 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2003140006
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some tests and sub-tests are setting "custom" thread/process affinity and
don't reset it back. Instead of requiring each test to undo all this, ensure
that thread affinity is restored by test_progs test runner itself.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/testing/selftests/bpf/test_progs.c | 42 +++++++++++++++++++++++-
 tools/testing/selftests/bpf/test_progs.h |  1 +
 2 files changed, 42 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/test_progs.c b/tools/testing/selftests/bpf/test_progs.c
index c8cb407482c6..b521e0a512b6 100644
--- a/tools/testing/selftests/bpf/test_progs.c
+++ b/tools/testing/selftests/bpf/test_progs.c
@@ -1,12 +1,15 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /* Copyright (c) 2017 Facebook
  */
+#define _GNU_SOURCE
 #include "test_progs.h"
 #include "cgroup_helpers.h"
 #include "bpf_rlimit.h"
 #include <argp.h>
-#include <string.h>
+#include <pthread.h>
+#include <sched.h>
 #include <signal.h>
+#include <string.h>
 #include <execinfo.h> /* backtrace */
 
 /* defined in test_progs.h */
@@ -90,6 +93,34 @@ static void skip_account(void)
 	}
 }
 
+static void stdio_restore(void);
+
+/* A bunch of tests set custom affinity per-thread and/or per-process. Reset
+ * it after each test/sub-test.
+ */
+static void reset_affinity() {
+
+	cpu_set_t cpuset;
+	int i, err;
+
+	CPU_ZERO(&cpuset);
+	for (i = 0; i < env.nr_cpus; i++)
+		CPU_SET(i, &cpuset);
+
+	err = sched_setaffinity(0, sizeof(cpuset), &cpuset);
+	if (err < 0) {
+		stdio_restore();
+		fprintf(stderr, "Failed to reset process affinity: %d!\n", err);
+		exit(-1);
+	}
+	err = pthread_setaffinity_np(pthread_self(), sizeof(cpuset), &cpuset);
+	if (err < 0) {
+		stdio_restore();
+		fprintf(stderr, "Failed to reset thread affinity: %d!\n", err);
+		exit(-1);
+	}
+}
+
 void test__end_subtest()
 {
 	struct prog_test_def *test = env.test;
@@ -107,6 +138,8 @@ void test__end_subtest()
 	       test->test_num, test->subtest_num,
 	       test->subtest_name, sub_error_cnt ? "FAIL" : "OK");
 
+	reset_affinity();
+
 	free(test->subtest_name);
 	test->subtest_name = NULL;
 }
@@ -679,6 +712,12 @@ int main(int argc, char **argv)
 	srand(time(NULL));
 
 	env.jit_enabled = is_jit_enabled();
+	env.nr_cpus = libbpf_num_possible_cpus();
+	if (env.nr_cpus < 0) {
+		fprintf(stderr, "Failed to get number of CPUs: %d!\n",
+			env.nr_cpus);
+		return -1;
+	}
 
 	stdio_hijack();
 	for (i = 0; i < prog_test_cnt; i++) {
@@ -709,6 +748,7 @@ int main(int argc, char **argv)
 			test->test_num, test->test_name,
 			test->error_cnt ? "FAIL" : "OK");
 
+		reset_affinity();
 		if (test->need_cgroup_cleanup)
 			cleanup_cgroup_environment();
 	}
diff --git a/tools/testing/selftests/bpf/test_progs.h b/tools/testing/selftests/bpf/test_progs.h
index fd85fa61dbf7..f4aff6b8284b 100644
--- a/tools/testing/selftests/bpf/test_progs.h
+++ b/tools/testing/selftests/bpf/test_progs.h
@@ -71,6 +71,7 @@ struct test_env {
 	FILE *stderr;
 	char *log_buf;
 	size_t log_cnt;
+	int nr_cpus;
 
 	int succ_cnt; /* successful tests */
 	int sub_succ_cnt; /* successful sub-tests */
-- 
2.17.1

