Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B4A277D80
	for <lists+netdev@lfdr.de>; Sun, 28 Jul 2019 05:25:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726173AbfG1DZx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jul 2019 23:25:53 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:36508 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726013AbfG1DZs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Jul 2019 23:25:48 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6S3Pctl021452
        for <netdev@vger.kernel.org>; Sat, 27 Jul 2019 20:25:47 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=XL/3BQOO67wRVex3Vl3Z6QlWQL+soOan2NuJ2UsVDvo=;
 b=kI9XbhlRJFrMtSEVqE22wJu8yrwvjoaPiGJbgw84wPYobhjhnzOSt9xLdqcEaV07dL4L
 syXYCHQHi8wAXUxRuv4o9tQLDQf/Sin+cBRonSqvFIZ8H3k7Qf3Rphbfg4v2Pxh/0mCH
 tBq/GSw2ATs7FKADfK1N7ieJ7iW+ZMtQOJI= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2u0jn3j8u0-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Sat, 27 Jul 2019 20:25:47 -0700
Received: from mx-out.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Sat, 27 Jul 2019 20:25:44 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id A6C2D8615B1; Sat, 27 Jul 2019 20:25:42 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>, <sdf@fomichev.me>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH v3 bpf-next 3/9] selftests/bpf: add test selectors by number and name to test_progs
Date:   Sat, 27 Jul 2019 20:25:25 -0700
Message-ID: <20190728032531.2358749-4-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190728032531.2358749-1-andriin@fb.com>
References: <20190728032531.2358749-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-28_01:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=8 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1907280042
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add ability to specify either test number or test name substring to
narrow down a set of test to run.

Usage:
sudo ./test_progs -n 1
sudo ./test_progs -t attach_probe

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/testing/selftests/bpf/test_progs.c | 43 +++++++++++++++++++++---
 1 file changed, 39 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_progs.c b/tools/testing/selftests/bpf/test_progs.c
index eea88ba59225..6e04b9f83777 100644
--- a/tools/testing/selftests/bpf/test_progs.c
+++ b/tools/testing/selftests/bpf/test_progs.c
@@ -4,6 +4,7 @@
 #include "test_progs.h"
 #include "bpf_rlimit.h"
 #include <argp.h>
+#include <string.h>
 
 int error_cnt, pass_cnt;
 bool jit_enabled;
@@ -164,6 +165,7 @@ void *spin_lock_thread(void *arg)
 
 struct prog_test_def {
 	const char *test_name;
+	int test_num;
 	void (*run_test)(void);
 };
 
@@ -181,26 +183,49 @@ const char *argp_program_bug_address = "<bpf@vger.kernel.org>";
 const char argp_program_doc[] = "BPF selftests test runner";
 
 enum ARG_KEYS {
+	ARG_TEST_NUM = 'n',
+	ARG_TEST_NAME = 't',
 	ARG_VERIFIER_STATS = 's',
 };
 	
 static const struct argp_option opts[] = {
+	{ "num", ARG_TEST_NUM, "NUM", 0,
+	  "Run test number NUM only " },
+	{ "name", ARG_TEST_NAME, "NAME", 0,
+	  "Run tests with names containing NAME" },
 	{ "verifier-stats", ARG_VERIFIER_STATS, NULL, 0,
 	  "Output verifier statistics", },
 	{},
 };
 
 struct test_env {
+	int test_num_selector;
+	const char *test_name_selector;
 	bool verifier_stats;
 };
 
-static struct test_env env = {};
+static struct test_env env = {
+	.test_num_selector = -1,
+};
 
 static error_t parse_arg(int key, char *arg, struct argp_state *state)
 {
 	struct test_env *env = state->input;
 
 	switch (key) {
+	case ARG_TEST_NUM: {
+		int test_num;
+
+		errno = 0;
+		test_num = strtol(arg, NULL, 10);
+		if (errno)
+			return -errno;
+		env->test_num_selector = test_num;
+		break;
+	}
+	case ARG_TEST_NAME:
+		env->test_name_selector = arg;
+		break;
 	case ARG_VERIFIER_STATS:
 		env->verifier_stats = true;
 		break;
@@ -223,7 +248,7 @@ int main(int argc, char **argv)
 		.parser = parse_arg,
 		.doc = argp_program_doc,
 	};
-	const struct prog_test_def *def;
+	struct prog_test_def *test;
 	int err, i;
 
 	err = argp_parse(&argp, argc, argv, 0, NULL, &env);
@@ -237,8 +262,18 @@ int main(int argc, char **argv)
 	verifier_stats = env.verifier_stats;
 
 	for (i = 0; i < ARRAY_SIZE(prog_test_defs); i++) {
-		def = &prog_test_defs[i];
-		def->run_test();
+		test = &prog_test_defs[i];
+
+		test->test_num = i + 1;
+
+		if (env.test_num_selector >= 0 &&
+		    test->test_num != env.test_num_selector)
+			continue;
+		if (env.test_name_selector &&
+		    !strstr(test->test_name, env.test_name_selector))
+			continue;
+
+		test->run_test();
 	}
 
 	printf("Summary: %d PASSED, %d FAILED\n", pass_cnt, error_cnt);
-- 
2.17.1

