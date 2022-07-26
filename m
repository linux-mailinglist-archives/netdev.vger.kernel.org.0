Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C441581C0B
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 00:15:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239837AbiGZWPq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 18:15:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229550AbiGZWPp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 18:15:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70E2B33415;
        Tue, 26 Jul 2022 15:15:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E03EFB81A07;
        Tue, 26 Jul 2022 22:15:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CFFDC433C1;
        Tue, 26 Jul 2022 22:15:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658873741;
        bh=bmiQF0RVND47QHxIIo+hHS/GnuvGDxTLF9Gi7HTKbW8=;
        h=From:To:Cc:Subject:Date:From;
        b=WpaAaR84+D1gzUnnANngZ6kd52hfmT3Tc63+il4DUGFDhBdznXqSD+BiGlQpPmWh5
         s3YAb1s0QplDN08vLKYd1FhwrEOSCgsUUhLH+HCk+1PIJtWu4cntnn/J/KOlTXpg7y
         tABqTq6hnvK/ubR5XM8579TAC/bvHOeCbCUH7v7d3EfM7/nmCHfm8NgZJ0y87jjrXP
         mv7QG3WF3R85V0zeTHg0ybXSJjK5ndQ7VFiyQszC7jLO8oTaGZhAYU3U9LyzyOqG4n
         5EPjWw9k/a8Snur0SIVJ9Uh+CQ7GwZLKlzgYdfA/kMdEt2s5FuT44tlyVkn4HvXo5s
         5Lxm0wvKfa+lw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     shuah@kernel.org
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        keescook@chromium.org, luto@amacapital.net, wad@chromium.org,
        linux-kselftest@vger.kernel.org
Subject: [PATCH] testing: kselftest_harness: add filtering and enumerating tests
Date:   Tue, 26 Jul 2022 15:15:37 -0700
Message-Id: <20220726221537.162521-1-kuba@kernel.org>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As the number of test cases and length of execution grows it's
useful to select only a subset of tests. In TLS for instance we
have a matrix of variants for different crypto protocols and
during development mostly care about testing a handful.
This is quicker and makes reading output easier.

This patch adds argument parsing to kselftest_harness.

It supports a couple of ways to filter things, I could not come
up with one way which will cover all cases.

The first and simplest switch is -r which takes the name of
a test to run (can be specified multiple times). For example:

  $ ./my_test -r some.test.name -r some.other.name

will run tests some.test.name and some.other.name (where "some"
is the fixture, "test" and "other" and "name is the test.)

Then there is a handful of group filtering options. f/v/t for
filtering by fixture/variant/test. They have both positive
(match -> run) and negative versions (match -> skip).
If user specifies any positive option we assume the default
is not to run the tests. If only negative options are set
we assume the tests are supposed to be run by default.

  Usage: ./tools/testing/selftests/net/tls [-h|-l] [-t|-T|-v|-V|-f|-F|-r name]
	-h       print help
	-l       list all tests

	-t name  include test
	-T name  exclude test
	-v name  include variant
	-V name  exclude variant
	-f name  include fixture
	-F name  exclude fixture
	-r name  run specified test

  Test filter options can be specified multiple times. The filtering stops
  at the first match. For example to include all tests from variant 'bla'
  but not test 'foo' specify '-T foo -v bla'.

Here we can request for example all tests from fixture "foo" to run:

 ./my_test -f foo

or to skip variants var1 and var2:

 ./my_test -V var1 -V var2

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
v2:
 - use getopt()

CC: keescook@chromium.org
CC: luto@amacapital.net
CC: wad@chromium.org
CC: shuah@kernel.org
CC: linux-kselftest@vger.kernel.org
---
 tools/testing/selftests/kselftest_harness.h | 142 +++++++++++++++++++-
 1 file changed, 137 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/kselftest_harness.h b/tools/testing/selftests/kselftest_harness.h
index 25f4d54067c0..d8bff2005dfc 100644
--- a/tools/testing/selftests/kselftest_harness.h
+++ b/tools/testing/selftests/kselftest_harness.h
@@ -54,6 +54,7 @@
 #define _GNU_SOURCE
 #endif
 #include <asm/types.h>
+#include <ctype.h>
 #include <errno.h>
 #include <stdbool.h>
 #include <stdint.h>
@@ -985,6 +986,127 @@ void __wait_for_test(struct __test_metadata *t)
 	}
 }
 
+static void test_harness_list_tests(void)
+{
+	struct __fixture_variant_metadata *v;
+	struct __fixture_metadata *f;
+	struct __test_metadata *t;
+
+	for (f = __fixture_list; f; f = f->next) {
+		v = f->variant;
+		t = f->tests;
+
+		if (f == __fixture_list)
+			fprintf(stderr, "%-20s %-25s %s\n",
+				"# FIXTURE", "VARIANT", "TEST");
+		else
+			fprintf(stderr, "--------------------------------------------------------------------------------\n");
+
+		do {
+			fprintf(stderr, "%-20s %-25s %s\n",
+				t == f->tests ? f->name : "",
+				v ? v->name : "",
+				t ? t->name : "");
+
+			v = v ? v->next : NULL;
+			t = t ? t->next : NULL;
+		} while (v || t);
+	}
+}
+
+static int test_harness_argv_check(int argc, char **argv)
+{
+	int opt;
+
+	while ((opt = getopt(argc, argv, "hlF:f:V:v:t:T:r:")) != -1) {
+		switch (opt) {
+		case 'f':
+		case 'F':
+		case 'v':
+		case 'V':
+		case 't':
+		case 'T':
+		case 'r':
+			break;
+		case 'l':
+			test_harness_list_tests();
+			return KSFT_SKIP;
+		case 'h':
+		default:
+			fprintf(stderr,
+				"Usage: %s [-h|-l] [-t|-T|-v|-V|-f|-F|-r name]\n"
+				"\t-h       print help\n"
+				"\t-l       list all tests\n"
+				"\n"
+				"\t-t name  include test\n"
+				"\t-T name  exclude test\n"
+				"\t-v name  include variant\n"
+				"\t-V name  exclude variant\n"
+				"\t-f name  include fixture\n"
+				"\t-F name  exclude fixture\n"
+				"\t-r name  run specified test\n"
+				"\n"
+				"Test filter options can be specified "
+				"multiple times. The filtering stops\n"
+				"at the first match. For example to "
+				"include all tests from variant 'bla'\n"
+				"but not test 'foo' specify '-T foo -v bla'.\n"
+				"", argv[0]);
+			return opt == 'h' ? KSFT_SKIP : KSFT_FAIL;
+		}
+	}
+
+	return KSFT_PASS;
+}
+
+static bool test_enabled(int argc, char **argv,
+			 struct __fixture_metadata *f,
+			 struct __fixture_variant_metadata *v,
+			 struct __test_metadata *t)
+{
+	unsigned int flen = 0, vlen = 0, tlen = 0;
+	bool has_positive = false;
+	int opt;
+
+	optind = 1;
+	while ((opt = getopt(argc, argv, "F:f:V:v:t:T:r:")) != -1) {
+		has_positive |= islower(opt);
+
+		switch (tolower(opt)) {
+		case 't':
+			if (!strcmp(t->name, optarg))
+				return islower(opt);
+			break;
+		case 'f':
+			if (!strcmp(f->name, optarg))
+				return islower(opt);
+			break;
+		case 'v':
+			if (!strcmp(v->name, optarg))
+				return islower(opt);
+			break;
+		case 'r':
+			if (!tlen) {
+				flen = strlen(f->name);
+				vlen = strlen(v->name);
+				tlen = strlen(t->name);
+			}
+			if (strlen(optarg) == flen + 1 + vlen + !!vlen + tlen &&
+			    !strncmp(f->name, &optarg[0], flen) &&
+			    !strncmp(v->name, &optarg[flen + 1], vlen) &&
+			    !strncmp(t->name, &optarg[flen + 1 + vlen + !!vlen], tlen))
+				return true;
+			break;
+		}
+	}
+
+	/*
+	 * If there are no positive tests then we assume user just wants
+	 * exclusions and everything else is a pass.
+	 */
+	return !has_positive;
+}
+
 void __run_test(struct __fixture_metadata *f,
 		struct __fixture_variant_metadata *variant,
 		struct __test_metadata *t)
@@ -1032,24 +1154,32 @@ void __run_test(struct __fixture_metadata *f,
 			f->name, variant->name[0] ? "." : "", variant->name, t->name);
 }
 
-static int test_harness_run(int __attribute__((unused)) argc,
-			    char __attribute__((unused)) **argv)
+static int test_harness_run(int argc, char **argv)
 {
 	struct __fixture_variant_metadata no_variant = { .name = "", };
 	struct __fixture_variant_metadata *v;
 	struct __fixture_metadata *f;
 	struct __test_results *results;
 	struct __test_metadata *t;
-	int ret = 0;
+	int ret;
 	unsigned int case_count = 0, test_count = 0;
 	unsigned int count = 0;
 	unsigned int pass_count = 0;
 
+	ret = test_harness_argv_check(argc, argv);
+	if (ret != KSFT_PASS)
+		return ret;
+
 	for (f = __fixture_list; f; f = f->next) {
 		for (v = f->variant ?: &no_variant; v; v = v->next) {
-			case_count++;
+			unsigned int old_tests = test_count;
+
 			for (t = f->tests; t; t = t->next)
-				test_count++;
+				if (test_enabled(argc, argv, f, v, t))
+					test_count++;
+
+			if (old_tests != test_count)
+				case_count++;
 		}
 	}
 
@@ -1063,6 +1193,8 @@ static int test_harness_run(int __attribute__((unused)) argc,
 	for (f = __fixture_list; f; f = f->next) {
 		for (v = f->variant ?: &no_variant; v; v = v->next) {
 			for (t = f->tests; t; t = t->next) {
+				if (!test_enabled(argc, argv, f, v, t))
+					continue;
 				count++;
 				t->results = results;
 				__run_test(f, v, t);
-- 
2.37.1

