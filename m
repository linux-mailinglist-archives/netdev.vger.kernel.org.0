Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 236B11030CA
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 01:36:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727403AbfKTAgC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 19:36:02 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:38458 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727357AbfKTAgC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 19:36:02 -0500
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xAK0Xo5J012411
        for <netdev@vger.kernel.org>; Tue, 19 Nov 2019 16:36:01 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=3kUpRZHj702Y/yob3JDZBCRSHqUTPZrzsJVFLNJXR9Q=;
 b=VJF1L/hsJ8vkk3EoMMx5hrZOZpSBEExKvVE8OSzM82/gij8WNtClqk6RFyGZGfAmBYtU
 qbbYJfXZWqkWZuuRrmB3OHYyQEwKfXTYui+0nRjcdWgVvNWPJNU5lpWt3XN/hkniVdkH
 p+6Op7uEaJIYIS8SOsC4H5MhsxFf498XI0A= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2wb1pwdh4u-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 19 Nov 2019 16:36:01 -0800
Received: from 2401:db00:2120:81ca:face:0:31:0 (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 19 Nov 2019 16:35:58 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 43A072EC1A59; Tue, 19 Nov 2019 16:35:57 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next] selftests/bpf: integrate verbose verifier log into test_progs
Date:   Tue, 19 Nov 2019 16:35:48 -0800
Message-ID: <20191120003548.4159797-1-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-19_08:2019-11-15,2019-11-19 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0
 malwarescore=0 clxscore=1015 lowpriorityscore=0 mlxlogscore=999
 suspectscore=8 impostorscore=0 bulkscore=0 spamscore=0 mlxscore=0
 priorityscore=1501 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1910280000 definitions=main-1911200004
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add exra level of verboseness, activated by -vvv argument. When -vv is
specified, verbose libbpf and verifier log (level 1) is output, even for
successful tests. With -vvv, verifier log goes to level 2.

This is extremely useful to debug verifier failures, as well as just see the
state and flow of verification. Before this, you'd have to go and modify
load_program()'s source code inside libbpf to specify extra log_level flags,
which is suboptimal to say the least.

Currently -vv and -vvv triggering verifier output is integrated into
test_stub's bpf_prog_load as well as bpf_verif_scale.c tests.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 .../selftests/bpf/prog_tests/bpf_verif_scale.c |  4 +++-
 tools/testing/selftests/bpf/test_progs.c       | 18 ++++++++++++------
 tools/testing/selftests/bpf/test_progs.h       | 10 ++++++++--
 tools/testing/selftests/bpf/test_stub.c        |  4 ++++
 4 files changed, 27 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_verif_scale.c b/tools/testing/selftests/bpf/prog_tests/bpf_verif_scale.c
index 1c01ee2600a9..9486c13af6b2 100644
--- a/tools/testing/selftests/bpf/prog_tests/bpf_verif_scale.c
+++ b/tools/testing/selftests/bpf/prog_tests/bpf_verif_scale.c
@@ -15,6 +15,8 @@ static int libbpf_debug_print(enum libbpf_print_level level,
 	return 0;
 }
 
+extern int extra_prog_load_log_flags;
+
 static int check_load(const char *file, enum bpf_prog_type type)
 {
 	struct bpf_prog_load_attr attr;
@@ -24,7 +26,7 @@ static int check_load(const char *file, enum bpf_prog_type type)
 	memset(&attr, 0, sizeof(struct bpf_prog_load_attr));
 	attr.file = file;
 	attr.prog_type = type;
-	attr.log_level = 4;
+	attr.log_level = 4 | extra_prog_load_log_flags;
 	attr.prog_flags = BPF_F_TEST_RND_HI32;
 	err = bpf_prog_load_xattr(&attr, &obj, &prog_fd);
 	bpf_object__close(obj);
diff --git a/tools/testing/selftests/bpf/test_progs.c b/tools/testing/selftests/bpf/test_progs.c
index a05a807840c0..7fa7d08a8104 100644
--- a/tools/testing/selftests/bpf/test_progs.c
+++ b/tools/testing/selftests/bpf/test_progs.c
@@ -45,7 +45,7 @@ static void dump_test_log(const struct prog_test_def *test, bool failed)
 
 	fflush(stdout); /* exports env.log_buf & env.log_cnt */
 
-	if (env.verbose || test->force_log || failed) {
+	if (env.verbosity > VERBOSE_NONE || test->force_log || failed) {
 		if (env.log_cnt) {
 			env.log_buf[env.log_cnt] = '\0';
 			fprintf(env.stdout, "%s", env.log_buf);
@@ -346,14 +346,14 @@ static const struct argp_option opts[] = {
 	{ "verifier-stats", ARG_VERIFIER_STATS, NULL, 0,
 	  "Output verifier statistics", },
 	{ "verbose", ARG_VERBOSE, "LEVEL", OPTION_ARG_OPTIONAL,
-	  "Verbose output (use -vv for extra verbose output)" },
+	  "Verbose output (use -vv or -vvv for progressively verbose output)" },
 	{},
 };
 
 static int libbpf_print_fn(enum libbpf_print_level level,
 			   const char *format, va_list args)
 {
-	if (!env.very_verbose && level == LIBBPF_DEBUG)
+	if (env.verbosity < VERBOSE_VERY && level == LIBBPF_DEBUG)
 		return 0;
 	vprintf(format, args);
 	return 0;
@@ -419,6 +419,8 @@ int parse_num_list(const char *s, struct test_selector *sel)
 	return 0;
 }
 
+extern int extra_prog_load_log_flags;
+
 static error_t parse_arg(int key, char *arg, struct argp_state *state)
 {
 	struct test_env *env = state->input;
@@ -460,9 +462,14 @@ static error_t parse_arg(int key, char *arg, struct argp_state *state)
 		env->verifier_stats = true;
 		break;
 	case ARG_VERBOSE:
+		env->verbosity = VERBOSE_NORMAL;
 		if (arg) {
 			if (strcmp(arg, "v") == 0) {
-				env->very_verbose = true;
+				env->verbosity = VERBOSE_VERY;
+				extra_prog_load_log_flags = 1;
+			} else if (strcmp(arg, "vv") == 0) {
+				env->verbosity = VERBOSE_SUPER;
+				extra_prog_load_log_flags = 2;
 			} else {
 				fprintf(stderr,
 					"Unrecognized verbosity setting ('%s'), only -v and -vv are supported\n",
@@ -470,7 +477,6 @@ static error_t parse_arg(int key, char *arg, struct argp_state *state)
 				return -EINVAL;
 			}
 		}
-		env->verbose = true;
 		break;
 	case ARGP_KEY_ARG:
 		argp_usage(state);
@@ -489,7 +495,7 @@ static void stdio_hijack(void)
 	env.stdout = stdout;
 	env.stderr = stderr;
 
-	if (env.verbose) {
+	if (env.verbosity > VERBOSE_NONE) {
 		/* nothing to do, output to stdout by default */
 		return;
 	}
diff --git a/tools/testing/selftests/bpf/test_progs.h b/tools/testing/selftests/bpf/test_progs.h
index 0c48f64f732b..8477df835979 100644
--- a/tools/testing/selftests/bpf/test_progs.h
+++ b/tools/testing/selftests/bpf/test_progs.h
@@ -39,6 +39,13 @@ typedef __u16 __sum16;
 #include "trace_helpers.h"
 #include "flow_dissector_load.h"
 
+enum verbosity {
+	VERBOSE_NONE,
+	VERBOSE_NORMAL,
+	VERBOSE_VERY,
+	VERBOSE_SUPER,
+};
+
 struct test_selector {
 	const char *name;
 	bool *num_set;
@@ -49,8 +56,7 @@ struct test_env {
 	struct test_selector test_selector;
 	struct test_selector subtest_selector;
 	bool verifier_stats;
-	bool verbose;
-	bool very_verbose;
+	enum verbosity verbosity;
 
 	bool jit_enabled;
 
diff --git a/tools/testing/selftests/bpf/test_stub.c b/tools/testing/selftests/bpf/test_stub.c
index 84e81a89e2f9..47e132726203 100644
--- a/tools/testing/selftests/bpf/test_stub.c
+++ b/tools/testing/selftests/bpf/test_stub.c
@@ -5,6 +5,8 @@
 #include <bpf/libbpf.h>
 #include <string.h>
 
+int extra_prog_load_log_flags = 0;
+
 int bpf_prog_test_load(const char *file, enum bpf_prog_type type,
 		       struct bpf_object **pobj, int *prog_fd)
 {
@@ -15,6 +17,7 @@ int bpf_prog_test_load(const char *file, enum bpf_prog_type type,
 	attr.prog_type = type;
 	attr.expected_attach_type = 0;
 	attr.prog_flags = BPF_F_TEST_RND_HI32;
+	attr.log_level = extra_prog_load_log_flags;
 
 	return bpf_prog_load_xattr(&attr, pobj, prog_fd);
 }
@@ -35,6 +38,7 @@ int bpf_test_load_program(enum bpf_prog_type type, const struct bpf_insn *insns,
 	load_attr.license = license;
 	load_attr.kern_version = kern_version;
 	load_attr.prog_flags = BPF_F_TEST_RND_HI32;
+	load_attr.log_level = extra_prog_load_log_flags;
 
 	return bpf_load_program_xattr(&load_attr, log_buf, log_buf_sz);
 }
-- 
2.17.1

