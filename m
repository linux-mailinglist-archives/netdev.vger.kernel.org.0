Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC881772D5
	for <lists+netdev@lfdr.de>; Fri, 26 Jul 2019 22:38:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727202AbfGZUiB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jul 2019 16:38:01 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:7654 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726305AbfGZUiB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jul 2019 16:38:01 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6QKTaoO025988
        for <netdev@vger.kernel.org>; Fri, 26 Jul 2019 13:38:00 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=44ceatmvJcmJn22R9vBTITFdEuxhvHirtmB4yCAIeQk=;
 b=LUAUJTHtrNyRFe1ic4KR3PCguQBGXsEwS1UhcxaviCkZQ1lCmcq9uXlQEi1lK8DfrJQB
 CpDemPDpj2BZBPgZAKVnj7sgtAKJlK+tGbLqEAmWDfpK4H6WjOvyfw/P/XQGqzypIcpT
 8hse/q7bf7DqSyVDy3lOFyLoEI90FY+hPiQ= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2u07sk06ky-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 26 Jul 2019 13:38:00 -0700
Received: from mx-out.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 26 Jul 2019 13:37:57 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id D27A5861663; Fri, 26 Jul 2019 13:37:56 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH bpf-next 2/9] selftests/bpf: revamp test_progs to allow more control
Date:   Fri, 26 Jul 2019 13:37:40 -0700
Message-ID: <20190726203747.1124677-3-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190726203747.1124677-1-andriin@fb.com>
References: <20190726203747.1124677-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-26_15:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=8 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1907260234
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Refactor test_progs to allow better control on what's being run.
Also use argp to do argument parsing, so that it's easier to keep adding
more options.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/testing/selftests/bpf/Makefile     |  8 +--
 tools/testing/selftests/bpf/test_progs.c | 84 +++++++++++++++++++++---
 2 files changed, 77 insertions(+), 15 deletions(-)

diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index bb66cc4a7f34..3bd0f4a0336a 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -239,14 +239,8 @@ $(OUTPUT)/test_progs: test_progs.c $(PROG_TESTS_FILES) | $(PROG_TESTS_H)
 $(PROG_TESTS_H): $(PROG_TESTS_FILES) | $(PROG_TESTS_DIR)
 	$(shell ( cd prog_tests/; \
 		  echo '/* Generated header, do not edit */'; \
-		  echo '#ifdef DECLARE'; \
 		  ls *.c 2> /dev/null | \
-			sed -e 's@\([^\.]*\)\.c@extern void test_\1(void);@'; \
-		  echo '#endif'; \
-		  echo '#ifdef CALL'; \
-		  ls *.c 2> /dev/null | \
-			sed -e 's@\([^\.]*\)\.c@test_\1();@'; \
-		  echo '#endif' \
+			sed -e 's@\([^\.]*\)\.c@DEFINE_TEST(\1)@'; \
 		 ) > $(PROG_TESTS_H))
 
 MAP_TESTS_DIR = $(OUTPUT)/map_tests
diff --git a/tools/testing/selftests/bpf/test_progs.c b/tools/testing/selftests/bpf/test_progs.c
index dae0819b1141..eea88ba59225 100644
--- a/tools/testing/selftests/bpf/test_progs.c
+++ b/tools/testing/selftests/bpf/test_progs.c
@@ -3,6 +3,7 @@
  */
 #include "test_progs.h"
 #include "bpf_rlimit.h"
+#include <argp.h>
 
 int error_cnt, pass_cnt;
 bool jit_enabled;
@@ -156,22 +157,89 @@ void *spin_lock_thread(void *arg)
 	pthread_exit(arg);
 }
 
-#define DECLARE
+/* extern declarations for test funcs */
+#define DEFINE_TEST(name) extern void test_##name();
 #include <prog_tests/tests.h>
-#undef DECLARE
+#undef DEFINE_TEST
 
-int main(int ac, char **av)
+struct prog_test_def {
+	const char *test_name;
+	void (*run_test)(void);
+};
+
+static struct prog_test_def prog_test_defs[] = {
+#define DEFINE_TEST(name) {	      \
+	.test_name = #name,	      \
+	.run_test = &test_##name,   \
+},
+#include <prog_tests/tests.h>
+#undef DEFINE_TEST
+};
+
+const char *argp_program_version = "test_progs 0.1";
+const char *argp_program_bug_address = "<bpf@vger.kernel.org>";
+const char argp_program_doc[] = "BPF selftests test runner";
+
+enum ARG_KEYS {
+	ARG_VERIFIER_STATS = 's',
+};
+	
+static const struct argp_option opts[] = {
+	{ "verifier-stats", ARG_VERIFIER_STATS, NULL, 0,
+	  "Output verifier statistics", },
+	{},
+};
+
+struct test_env {
+	bool verifier_stats;
+};
+
+static struct test_env env = {};
+
+static error_t parse_arg(int key, char *arg, struct argp_state *state)
 {
+	struct test_env *env = state->input;
+
+	switch (key) {
+	case ARG_VERIFIER_STATS:
+		env->verifier_stats = true;
+		break;
+	case ARGP_KEY_ARG:
+		argp_usage(state);
+		break;
+	case ARGP_KEY_END:
+		break;
+	default:
+		return ARGP_ERR_UNKNOWN;
+	}
+	return 0;
+}
+
+
+int main(int argc, char **argv)
+{
+	static const struct argp argp = {
+		.options = opts,
+		.parser = parse_arg,
+		.doc = argp_program_doc,
+	};
+	const struct prog_test_def *def;
+	int err, i;
+
+	err = argp_parse(&argp, argc, argv, 0, NULL, &env);
+	if (err)
+		return err;
+
 	srand(time(NULL));
 
 	jit_enabled = is_jit_enabled();
 
-	if (ac == 2 && strcmp(av[1], "-s") == 0)
-		verifier_stats = true;
+	verifier_stats = env.verifier_stats;
 
-#define CALL
-#include <prog_tests/tests.h>
-#undef CALL
+	for (i = 0; i < ARRAY_SIZE(prog_test_defs); i++) {
+		def = &prog_test_defs[i];
+		def->run_test();
+	}
 
 	printf("Summary: %d PASSED, %d FAILED\n", pass_cnt, error_cnt);
 	return error_cnt ? EXIT_FAILURE : EXIT_SUCCESS;
-- 
2.17.1

