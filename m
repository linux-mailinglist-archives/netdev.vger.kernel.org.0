Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7F84185381
	for <lists+netdev@lfdr.de>; Sat, 14 Mar 2020 01:55:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727896AbgCNAzZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 20:55:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:53546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727629AbgCNAzI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Mar 2020 20:55:08 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D381820769;
        Sat, 14 Mar 2020 00:55:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584147307;
        bh=A9LxF9QepjNmz5aiELSRd7cWBXPKdmZaxZjEEzMbCvs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XyRqrhsjjfjgCfcV9f18JmjI8C47v87Zkh4lw4IIj2J739ULLIPMXUqf8A/t26gD8
         xzCy+UPZsFvTlPpoztaDBTj9GfJUOdGPYH3e2aezXeezmV/opiu0QmOzPuEZ5AZSdf
         +bbrBHQBGvXtaax2eYEfaQZkrlL9neDX2bvClWYQ=
From:   Jakub Kicinski <kuba@kernel.org>
To:     shuah@kernel.org, keescook@chromium.org
Cc:     luto@amacapital.net, wad@chromium.org,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-team@fb.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH v2 2/4] kselftest: create fixture objects
Date:   Fri, 13 Mar 2020 17:54:59 -0700
Message-Id: <20200314005501.2446494-3-kuba@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200314005501.2446494-1-kuba@kernel.org>
References: <20200314005501.2446494-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Grouping tests by fixture will allow us to parametrize
test runs. Create full objects for fixtures.

Add a "global" fixture for tests without a fixture.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Acked-by: Kees Cook <keescook@chromium.org>
--
v2:
 - remove the fixture list, we won't iterate over
   fixtures so it's not needed
---
 tools/testing/selftests/kselftest_harness.h | 31 ++++++++++++++++-----
 1 file changed, 24 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/kselftest_harness.h b/tools/testing/selftests/kselftest_harness.h
index 5336b26506ab..66c2397d8c51 100644
--- a/tools/testing/selftests/kselftest_harness.h
+++ b/tools/testing/selftests/kselftest_harness.h
@@ -169,8 +169,10 @@
 #define __TEST_IMPL(test_name, _signal) \
 	static void test_name(struct __test_metadata *_metadata); \
 	static struct __test_metadata _##test_name##_object = \
-		{ .name = "global." #test_name, \
-		  .fn = &test_name, .termsig = _signal, \
+		{ .name = #test_name, \
+		  .fn = &test_name, \
+		  .fixture = &_fixture_global, \
+		  .termsig = _signal, \
 		  .timeout = TEST_TIMEOUT_DEFAULT, }; \
 	static void __attribute__((constructor)) _register_##test_name(void) \
 	{ \
@@ -212,6 +214,8 @@
  * populated and cleaned up using FIXTURE_SETUP() and FIXTURE_TEARDOWN().
  */
 #define FIXTURE(fixture_name) \
+	static struct __fixture_metadata _##fixture_name##_fixture_object = \
+		{ .name =  #fixture_name, }; \
 	static void __attribute__((constructor)) \
 	_register_##fixture_name##_data(void) \
 	{ \
@@ -309,8 +313,9 @@
 	} \
 	static struct __test_metadata \
 		      _##fixture_name##_##test_name##_object = { \
-		.name = #fixture_name "." #test_name, \
+		.name = #test_name, \
 		.fn = &wrapper_##fixture_name##_##test_name, \
+		.fixture = &_##fixture_name##_fixture_object, \
 		.termsig = signal, \
 		.timeout = tmout, \
 	 }; \
@@ -632,9 +637,12 @@
 } while (0); OPTIONAL_HANDLER(_assert)
 
 /* Contains all the information for test execution and status checking. */
+struct __fixture_metadata;
+
 struct __test_metadata {
 	const char *name;
 	void (*fn)(struct __test_metadata *);
+	struct __fixture_metadata *fixture;
 	int termsig;
 	int passed;
 	int trigger; /* extra handler after the evaluation */
@@ -685,6 +693,13 @@ static inline void __register_test(struct __test_metadata *t)
 	}
 }
 
+/* Contains all the information about a fixture */
+struct __fixture_metadata {
+	const char *name;
+} _fixture_global __attribute__((unused)) = {
+	.name = "global",
+};
+
 static inline int __bail(int for_realz, bool no_print, __u8 step)
 {
 	if (for_realz) {
@@ -695,14 +710,15 @@ static inline int __bail(int for_realz, bool no_print, __u8 step)
 	return 0;
 }
 
-void __run_test(struct __test_metadata *t)
+void __run_test(struct __fixture_metadata *f,
+		struct __test_metadata *t)
 {
 	pid_t child_pid;
 	int status;
 
 	t->passed = 1;
 	t->trigger = 0;
-	printf("[ RUN      ] %s\n", t->name);
+	printf("[ RUN      ] %s.%s\n", f->name, t->name);
 	alarm(t->timeout);
 	child_pid = fork();
 	if (child_pid < 0) {
@@ -751,7 +767,8 @@ void __run_test(struct __test_metadata *t)
 				status);
 		}
 	}
-	printf("[     %4s ] %s\n", (t->passed ? "OK" : "FAIL"), t->name);
+	printf("[     %4s ] %s.%s\n", (t->passed ? "OK" : "FAIL"),
+	       f->name, t->name);
 	alarm(0);
 }
 
@@ -768,7 +785,7 @@ static int test_harness_run(int __attribute__((unused)) argc,
 	       __test_count, __fixture_count + 1);
 	for (t = __test_list; t; t = t->next) {
 		count++;
-		__run_test(t);
+		__run_test(t->fixture, t);
 		if (t->passed)
 			pass_count++;
 		else
-- 
2.24.1

