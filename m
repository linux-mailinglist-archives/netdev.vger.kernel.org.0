Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD6C513D14D
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 01:56:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729742AbgAPAz7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 19:55:59 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:60328 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726513AbgAPAz7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jan 2020 19:55:59 -0500
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 00G0rda2002814
        for <netdev@vger.kernel.org>; Wed, 15 Jan 2020 16:55:58 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=AXUzoGhL1JE0ZSHtdJfUzay0wgBrAYWZN7sLS55H4as=;
 b=HeJtYEQX9w5ics7Ck8xBu9ICKj1fq5r8YRJOpVaNp/K9sf63jLR5WinKTHBeqteDp+xu
 fbO5Bq7/ukV81b7yHTtocbyK1XszPkEhUdwjMisBaEVjgv/hcNGedpEUNZy5ES9ephhP
 jMLag8kePqDfiGb6UE5ulR2lykJNcb4nhcI= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net with ESMTP id 2xj5ptaf42-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 15 Jan 2020 16:55:57 -0800
Received: from intmgw003.08.frc2.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:11d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Wed, 15 Jan 2020 16:55:56 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 9B4532EC1D7C; Wed, 15 Jan 2020 16:55:51 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>, Julia Kartseva <hex@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v2 bpf-next] selftests/bpf: add whitelist/blacklist of test names to test_progs
Date:   Wed, 15 Jan 2020 16:55:49 -0800
Message-ID: <20200116005549.3644118-1-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-15_03:2020-01-15,2020-01-15 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 adultscore=0
 malwarescore=0 suspectscore=29 clxscore=1015 spamscore=0 phishscore=0
 bulkscore=0 priorityscore=1501 mlxlogscore=999 impostorscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-2001160004
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
  #1 attach_probe:OK
  #6 cgroup_attach_autodetach:OK
  #7 cgroup_attach_multi:OK
  #8 cgroup_attach_override:OK
  #9 core_extern:OK
  #10/44 existence:OK
  #10/45 existence___minimal:OK
  #10/46 existence__err_int_sz:OK
  #10/47 existence__err_int_type:OK
  #10/48 existence__err_int_kind:OK
  #10/49 existence__err_arr_kind:OK
  #10/50 existence__err_arr_value_type:OK
  #10/51 existence__err_struct_type:OK
  #10 core_reloc:OK
  #19 flow_dissector_reattach:OK
  #60 tp_attach_query:OK
  Summary: 8/8 PASSED, 0 SKIPPED, 0 FAILED

  $ sudo ./test_progs -tattach,core/existence -bcgroup,flow/arr
  #1 attach_probe:OK
  #9 core_extern:OK
  #10/44 existence:OK
  #10/45 existence___minimal:OK
  #10/46 existence__err_int_sz:OK
  #10/47 existence__err_int_type:OK
  #10/48 existence__err_int_kind:OK
  #10/51 existence__err_struct_type:OK
  #10 core_reloc:OK
  #60 tp_attach_query:OK
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

