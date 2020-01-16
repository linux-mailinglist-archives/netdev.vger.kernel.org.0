Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51A7013D136
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 01:41:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729463AbgAPAlV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 19:41:21 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:33726 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729112AbgAPAlV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jan 2020 19:41:21 -0500
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00G0eTQG004516
        for <netdev@vger.kernel.org>; Wed, 15 Jan 2020 16:41:20 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=5fw0EdQWhPregdFqrz5HdcFntTryiFK3a6OZkKg8buA=;
 b=nKsSRODJgnLzEXWptZjmtc9iaPdyOL5/2mL/tZj3+tlyR0B392Z6EJP0+cTN5JJxUxet
 sWl+jOsrGGL7qh+JasKuV29q/wCY9e58896ZwTmUiZxAl1fy3mWpXi5YKNCqoWoBwpbF
 BYohZ98DOJW5Ll9bh7WQBQ+pC7ZjV7jef3w= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2xjc3w8b09-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 15 Jan 2020 16:41:20 -0800
Received: from intmgw003.06.prn3.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 15 Jan 2020 16:41:18 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 42F062EC20D3; Wed, 15 Jan 2020 16:41:06 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>, Julia Kartseva <hex@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next] selftests/bpf: add whitelist/blacklist of test names to test_progs
Date:   Wed, 15 Jan 2020 16:41:01 -0800
Message-ID: <20200116004101.3596474-1-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-15_03:2020-01-15,2020-01-15 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=999
 adultscore=0 malwarescore=0 lowpriorityscore=0 suspectscore=29 mlxscore=0
 phishscore=0 clxscore=1015 bulkscore=0 spamscore=0 impostorscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-2001160002
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add ability to specify a list of test name substrings for selecting which
tests to run. So now -t is accepting a comma-separated list of strings,
similarly to how -n accepts a comma-separated list of test numbers.

Additionally, add ability to blacklist tests by name. Blacklist takes
precedence over whitelist. Blacklisting is important for cases where it's
known that some tests can't pass (e.g., due to perf hardware events that are
not available within VM). This is going to be used for libbpf testing in
Travis CI in its Github repo.

Example runs with just whitelist and whitelist + blacklist:

$ sudo ./test_progs -tattach,core/existence
Summary: 8/8 PASSED, 0 SKIPPED, 0 FAILED

$ sudo ./test_progs -tattach,core/existence -bcgroup,flow/arr
Summary: 4/6 PASSED, 0 SKIPPED, 0 FAILED

Cc: Julia Kartseva <hex@fb.com>
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/testing/selftests/bpf/test_progs.c | 83 +++++++++++++++++++++---
 tools/testing/selftests/bpf/test_progs.h |  8 ++-
 2 files changed, 80 insertions(+), 11 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_progs.c b/tools/testing/selftests/bpf/test_progs.c
index 7fa7d08a8104..bab1e6f1d8f1 100644
--- a/tools/testing/selftests/bpf/test_progs.c
+++ b/tools/testing/selftests/bpf/test_progs.c
@@ -8,7 +8,7 @@
 #include <string.h>
 
 /* defined in test_progs.h */
-struct test_env env;
+struct test_env env = {};
 
 struct prog_test_def {
 	const char *test_name;
@@ -29,10 +29,19 @@ struct prog_test_def {
 
 static bool should_run(struct test_selector *sel, int num, const char *name)
 {
-	if (sel->name && sel->name[0] && !strstr(name, sel->name))
-		return false;
+	int i;
+
+	for (i = 0; i < sel->blacklist.cnt; i++) {
+		if (strstr(name, sel->blacklist.strs[i]))
+			return false;
+	}
 
-	if (!sel->num_set)
+	for (i = 0; i < sel->whitelist.cnt; i++) {
+		if (strstr(name, sel->whitelist.strs[i]))
+			return true;
+	}
+
+	if (!sel->whitelist.cnt && !sel->num_set)
 		return true;
 
 	return num < sel->num_set_len && sel->num_set[num];
@@ -334,6 +343,7 @@ const char argp_program_doc[] = "BPF selftests test runner";
 enum ARG_KEYS {
 	ARG_TEST_NUM = 'n',
 	ARG_TEST_NAME = 't',
+	ARG_TEST_NAME_BLACKLIST = 'b',
 	ARG_VERIFIER_STATS = 's',
 	ARG_VERBOSE = 'v',
 };
@@ -341,8 +351,10 @@ enum ARG_KEYS {
 static const struct argp_option opts[] = {
 	{ "num", ARG_TEST_NUM, "NUM", 0,
 	  "Run test number NUM only " },
-	{ "name", ARG_TEST_NAME, "NAME", 0,
-	  "Run tests with names containing NAME" },
+	{ "name", ARG_TEST_NAME, "NAMES", 0,
+	  "Run tests with names containing any string from NAMES list" },
+	{ "name-blacklist", ARG_TEST_NAME_BLACKLIST, "NAMES", 0,
+	  "Don't run tests with names containing any string from NAMES list" },
 	{ "verifier-stats", ARG_VERIFIER_STATS, NULL, 0,
 	  "Output verifier statistics", },
 	{ "verbose", ARG_VERBOSE, "LEVEL", OPTION_ARG_OPTIONAL,
@@ -359,6 +371,41 @@ static int libbpf_print_fn(enum libbpf_print_level level,
 	return 0;
 }
 
+static int parse_str_list(const char *s, struct str_set *set)
+{
+	char *input, *state = NULL, *next, **tmp, **strs = NULL;
+	int cnt = 0;
+
+	input = strdup(s);
+	if (!input)
+		return -ENOMEM;
+
+	set->cnt = 0;
+	set->strs = NULL;
+
+	while ((next = strtok_r(state ? NULL : input, ",", &state))) {
+		tmp = realloc(strs, sizeof(*strs) * (cnt + 1));
+		if (!tmp)
+			goto err;
+		strs = tmp;
+
+		strs[cnt] = strdup(next);
+		if (!strs[cnt])
+			goto err;
+
+		cnt++;
+	}
+
+	set->cnt = cnt;
+	set->strs = (const char **)strs;
+	free(input);
+	return 0;
+err:
+	free(strs);
+	free(input);
+	return -ENOMEM;
+}
+
 int parse_num_list(const char *s, struct test_selector *sel)
 {
 	int i, set_len = 0, num, start = 0, end = -1;
@@ -449,12 +496,24 @@ static error_t parse_arg(int key, char *arg, struct argp_state *state)
 
 		if (subtest_str) {
 			*subtest_str = '\0';
-			env->subtest_selector.name = strdup(subtest_str + 1);
-			if (!env->subtest_selector.name)
+			if (parse_str_list(subtest_str + 1,
+					   &env->subtest_selector.whitelist))
+				return -ENOMEM;
+		}
+		if (parse_str_list(arg, &env->test_selector.whitelist))
+			return -ENOMEM;
+		break;
+	}
+	case ARG_TEST_NAME_BLACKLIST: {
+		char *subtest_str = strchr(arg, '/');
+
+		if (subtest_str) {
+			*subtest_str = '\0';
+			if (parse_str_list(subtest_str + 1,
+					   &env->subtest_selector.blacklist))
 				return -ENOMEM;
 		}
-		env->test_selector.name = strdup(arg);
-		if (!env->test_selector.name)
+		if (parse_str_list(arg, &env->test_selector.blacklist))
 			return -ENOMEM;
 		break;
 	}
@@ -617,7 +676,11 @@ int main(int argc, char **argv)
 	printf("Summary: %d/%d PASSED, %d SKIPPED, %d FAILED\n",
 	       env.succ_cnt, env.sub_succ_cnt, env.skip_cnt, env.fail_cnt);
 
+	free(env.test_selector.blacklist.strs);
+	free(env.test_selector.whitelist.strs);
 	free(env.test_selector.num_set);
+	free(env.subtest_selector.blacklist.strs);
+	free(env.subtest_selector.whitelist.strs);
 	free(env.subtest_selector.num_set);
 
 	return env.fail_cnt ? EXIT_FAILURE : EXIT_SUCCESS;
diff --git a/tools/testing/selftests/bpf/test_progs.h b/tools/testing/selftests/bpf/test_progs.h
index de1fdaa4e7b4..99933a1857ca 100644
--- a/tools/testing/selftests/bpf/test_progs.h
+++ b/tools/testing/selftests/bpf/test_progs.h
@@ -46,8 +46,14 @@ enum verbosity {
 	VERBOSE_SUPER,
 };
 
+struct str_set {
+	const char **strs;
+	int cnt;
+};
+
 struct test_selector {
-	const char *name;
+	struct str_set whitelist;
+	struct str_set blacklist;
 	bool *num_set;
 	int num_set_len;
 };
-- 
2.17.1

