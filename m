Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8CAD772DA
	for <lists+netdev@lfdr.de>; Fri, 26 Jul 2019 22:38:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727559AbfGZUiL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jul 2019 16:38:11 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:16504 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727518AbfGZUiL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jul 2019 16:38:11 -0400
Received: from pps.filterd (m0044008.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6QKUvN7008489
        for <netdev@vger.kernel.org>; Fri, 26 Jul 2019 13:38:09 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=vZgjULanoYwPTbRsMZpkA4omkUuL2BYdYX0u5BDwp0s=;
 b=bmNnORpZgV5qD+svwfnsJfdru5zMrt2DM8nsue/jWKypNT2QB4WBTzLhcai2/DWzG6h4
 7cQx3HPV5YmirrVtimXWpv4S/QxSjHMHA2Mwx5MizQ/KOTAmdXUYcfMxpfgrWqtqjICg
 FDWz5XSVB7DX8QyjtYoonfvVgdbEFxe0njg= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2u033rhct2-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 26 Jul 2019 13:38:09 -0700
Received: from mx-out.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 26 Jul 2019 13:38:08 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id 1B7E1861663; Fri, 26 Jul 2019 13:38:07 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH bpf-next 7/9] selftests/bpf: add sub-tests support for test_progs
Date:   Fri, 26 Jul 2019 13:37:45 -0700
Message-ID: <20190726203747.1124677-8-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190726203747.1124677-1-andriin@fb.com>
References: <20190726203747.1124677-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-26_15:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=29 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1907260234
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Allow tests to have their own set of sub-tests. Also add ability to do
test/subtest selection using `-t <test-name>/<subtest-name>` and `-n
<test-nums-set>/<subtest-nums-set>`, as an extension of existing -t/-n
selector options. For the <test-num-set> format: it's a comma-separated
list of either individual test numbers (1-based), or range of test
numbers. E.g., all of the following are valid sets of test numbers:
  - 10
  - 1,2,3
  - 1-3
  - 5-10,1,3-4

'/<subtest' part is optional, but has the same format. E.g., to select
test #3 and its sub-tests #10 through #15, use: -t 3/10-15.

Similarly, to select tests by name, use `-t verif/strobe`:

  $ sudo ./test_progs -t verif/strobe
  #3/12 strobemeta.o:OK
  #3/13 strobemeta_nounroll1.o:OK
  #3/14 strobemeta_nounroll2.o:OK
  #3 bpf_verif_scale:OK
  Summary: 1/3 PASSED, 0 FAILED

Example of using subtest API is in the next patch, converting
bpf_verif_scale.c tests to use sub-tests.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/testing/selftests/bpf/test_progs.c | 198 ++++++++++++++++++++---
 tools/testing/selftests/bpf/test_progs.h |  16 +-
 2 files changed, 185 insertions(+), 29 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_progs.c b/tools/testing/selftests/bpf/test_progs.c
index 3cf3ebda1d31..7a2db48b6fd1 100644
--- a/tools/testing/selftests/bpf/test_progs.c
+++ b/tools/testing/selftests/bpf/test_progs.c
@@ -7,9 +7,7 @@
 #include <string.h>
 
 /* defined in test_progs.h */
-struct test_env env = {
-	.test_num_selector = -1,
-};
+struct test_env env;
 int error_cnt, pass_cnt;
 
 struct prog_test_def {
@@ -20,8 +18,82 @@ struct prog_test_def {
 	int pass_cnt;
 	int error_cnt;
 	bool tested;
+
+	const char *subtest_name;
+	int subtest_num;
+
+	/* store counts before subtest started */
+	int old_pass_cnt;
+	int old_error_cnt;
 };
 
+static bool should_run(struct test_selector *sel, int num, const char *name)
+{
+	if (sel->name && sel->name[0] && !strstr(name, sel->name))
+		return false;
+
+	if (!sel->num_set)
+		return true;
+
+	return num < sel->num_set_len && sel->num_set[num];
+}
+
+static void dump_test_log(const struct prog_test_def *test, bool failed)
+{
+	if (env.verbose || test->force_log || failed) {
+		if (env.log_cnt) {
+			fprintf(stdout, "%s", env.log_buf);
+			if (env.log_buf[env.log_cnt - 1] != '\n')
+				fprintf(stdout, "\n");
+		}
+		env.log_cnt = 0;
+	}
+}
+
+void test__end_subtest()
+{
+	struct prog_test_def *test = env.test;
+	int sub_error_cnt = error_cnt - test->old_error_cnt;
+
+	if (sub_error_cnt)
+		env.fail_cnt++;
+	else
+		env.sub_succ_cnt++;
+
+	dump_test_log(test, sub_error_cnt);
+
+	printf("#%d/%d %s:%s\n",
+	       test->test_num, test->subtest_num,
+	       test->subtest_name, sub_error_cnt ? "FAIL" : "OK");
+}
+
+bool test__start_subtest(const char *name)
+{
+	struct prog_test_def *test = env.test;
+
+	if (test->subtest_name) {
+		test__end_subtest();
+		test->subtest_name = NULL;
+	}
+
+	test->subtest_num++;
+
+	if (!name || !name[0]) {
+		fprintf(stderr, "Subtest #%d didn't provide sub-test name!\n",
+			test->subtest_num);
+		return false;
+	}
+
+	if (!should_run(&env.subtest_selector, test->subtest_num, name))
+		return false;
+
+	test->subtest_name = name;
+	env.test->old_pass_cnt = pass_cnt;
+	env.test->old_error_cnt = error_cnt;
+
+	return true;
+}
+
 void test__force_log() {
 	env.test->force_log = true;
 }
@@ -271,24 +343,103 @@ static int libbpf_print_fn(enum libbpf_print_level level,
 	return 0;
 }
 
+int parse_num_list(const char *s, struct test_selector *sel)
+{
+	int i, set_len = 0, num, start = 0, end = -1;
+	bool *set = NULL, *tmp, parsing_end = false;
+	char *next;
+
+	while (s[0]) {
+		errno = 0;
+		num = strtol(s, &next, 10);
+		if (errno)
+			return -errno;
+
+		if (parsing_end)
+			end = num;
+		else
+			start = num;
+
+		if (!parsing_end && *next == '-') {
+			s = next + 1;
+			parsing_end = true;
+			continue;
+		} else if (*next == ',') {
+			parsing_end = false;
+			s = next + 1;
+			end = num;
+		} else if (*next == '\0') {
+			parsing_end = false;
+			s = next;
+			end = num;
+		} else {
+			return -EINVAL;
+		}
+
+		if (start > end)
+			return -EINVAL;
+
+		if (end + 1 > set_len) {
+			set_len = end + 1;
+			tmp = realloc(set, set_len);
+			if (!tmp) {
+				free(set);
+				return -ENOMEM;
+			}
+			set = tmp;
+		}
+		for (i = start; i <= end; i++) {
+			set[i] = true;
+		}
+
+	}
+
+	if (!set)
+		return -EINVAL;
+
+	sel->num_set = set;
+	sel->num_set_len = set_len;
+
+	return 0;
+}
+
 static error_t parse_arg(int key, char *arg, struct argp_state *state)
 {
 	struct test_env *env = state->input;
 
 	switch (key) {
 	case ARG_TEST_NUM: {
-		int test_num;
+		char *subtest_str = strchr(arg, '/');
 
-		errno = 0;
-		test_num = strtol(arg, NULL, 10);
-		if (errno)
-			return -errno;
-		env->test_num_selector = test_num;
+		if (subtest_str) {
+			*subtest_str = '\0';
+			if (parse_num_list(subtest_str + 1,
+					   &env->subtest_selector)) {
+				fprintf(stderr,
+					"Failed to parse subtest numbers.\n");
+				return -EINVAL;
+			}
+		}
+		if (parse_num_list(arg, &env->test_selector)) {
+			fprintf(stderr, "Failed to parse test numbers.\n");
+			return -EINVAL;
+		}
 		break;
 	}
-	case ARG_TEST_NAME:
-		env->test_name_selector = arg;
+	case ARG_TEST_NAME: {
+		char *subtest_str = strchr(arg, '/');
+
+		if (subtest_str) {
+			*subtest_str = '\0';
+			env->subtest_selector.name = strdup(subtest_str + 1);
+			if (!env->subtest_selector.name)
+				return -ENOMEM;
+		}
+		env->test_selector.name = strdup(arg);
+		if (!env->test_selector.name)
+			return -ENOMEM;
 		break;
+	}
 	case ARG_VERIFIER_STATS:
 		env->verifier_stats = true;
 		break;
@@ -343,14 +494,15 @@ int main(int argc, char **argv)
 		env.test = test;
 		test->test_num = i + 1;
 
-		if (env.test_num_selector >= 0 &&
-		    test->test_num != env.test_num_selector)
-			continue;
-		if (env.test_name_selector &&
-		    !strstr(test->test_name, env.test_name_selector))
+		if (!should_run(&env.test_selector,
+				test->test_num, test->test_name))
 			continue;
 
 		test->run_test();
+		/* ensure last sub-test is finalized properly */
+		if (test->subtest_name)
+			test__end_subtest();
+
 		test->tested = true;
 		test->pass_cnt = pass_cnt - old_pass_cnt;
 		test->error_cnt = error_cnt - old_error_cnt;
@@ -359,21 +511,17 @@ int main(int argc, char **argv)
 		else
 			env.succ_cnt++;
 
-		if (env.verbose || test->force_log || test->error_cnt) {
-			if (env.log_cnt) {
-				fprintf(stdout, "%s", env.log_buf);
-				if (env.log_buf[env.log_cnt - 1] != '\n')
-					fprintf(stdout, "\n");
-			}
-		}
-		env.log_cnt = 0;
+		dump_test_log(test, test->error_cnt);
 
 		printf("#%d %s:%s\n", test->test_num, test->test_name,
 		       test->error_cnt ? "FAIL" : "OK");
 	}
-	printf("Summary: %d PASSED, %d FAILED\n", env.succ_cnt, env.fail_cnt);
+	printf("Summary: %d/%d PASSED, %d FAILED\n",
+	       env.succ_cnt, env.sub_succ_cnt, env.fail_cnt);
 
 	free(env.log_buf);
+	free(env.test_selector.num_set);
+	free(env.subtest_selector.num_set);
 
 	return error_cnt ? EXIT_FAILURE : EXIT_SUCCESS;
 }
diff --git a/tools/testing/selftests/bpf/test_progs.h b/tools/testing/selftests/bpf/test_progs.h
index 62f55a4231e9..afd14962456f 100644
--- a/tools/testing/selftests/bpf/test_progs.h
+++ b/tools/testing/selftests/bpf/test_progs.h
@@ -40,9 +40,15 @@ typedef __u16 __sum16;
 
 struct prog_test_def;
 
+struct test_selector {
+	const char *name;
+	bool *num_set;
+	int num_set_len;
+};
+
 struct test_env {
-	int test_num_selector;
-	const char *test_name_selector;
+	struct test_selector test_selector;
+	struct test_selector subtest_selector;
 	bool verifier_stats;
 	bool verbose;
 	bool very_verbose;
@@ -54,8 +60,9 @@ struct test_env {
 	size_t log_cnt;
 	size_t log_cap;
 
-	int succ_cnt;
-	int fail_cnt;
+	int succ_cnt; /* successful tests */
+	int sub_succ_cnt; /* successful sub-tests */
+	int fail_cnt; /* total failed tests + sub-tests */
 };
 
 extern int error_cnt;
@@ -65,6 +72,7 @@ extern struct test_env env;
 extern void test__printf(const char *fmt, ...);
 extern void test__vprintf(const char *fmt, va_list args);
 extern void test__force_log();
+extern bool test__start_subtest(const char *name);
 
 #define MAGIC_BYTES 123
 
-- 
2.17.1

