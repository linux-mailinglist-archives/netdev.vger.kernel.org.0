Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8FBB31875EF
	for <lists+netdev@lfdr.de>; Mon, 16 Mar 2020 23:57:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733006AbgCPW5U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Mar 2020 18:57:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:60174 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732906AbgCPW45 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Mar 2020 18:56:57 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4F66D20736;
        Mon, 16 Mar 2020 22:56:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584399417;
        bh=OcVY4eRoS/U8w8yp3h14C8F705LeNMy1yjqKo01PSco=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=02UC0T5oDz89azih3fbWDjL8Y0bG0BiGO+i4rEE+MfpytZBYa8APxOH3AWYZ+Axr7
         WBn+2Feot/rm3eTMixJahN6CrcNKFswGDhJsrYTf1PDV+leVWqAWzi3CND095zYati
         w5YJLzlHcmHWSKp0VJh3vqLVD3Q1PGpRNpnhBJWo=
From:   Jakub Kicinski <kuba@kernel.org>
To:     shuah@kernel.org, keescook@chromium.org
Cc:     luto@amacapital.net, wad@chromium.org,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-team@fb.com,
        Tim.Bird@sony.com, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH v3 3/6] kselftest: create fixture objects
Date:   Mon, 16 Mar 2020 15:56:43 -0700
Message-Id: <20200316225647.3129354-4-kuba@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200316225647.3129354-1-kuba@kernel.org>
References: <20200316225647.3129354-1-kuba@kernel.org>
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
---
 tools/testing/selftests/kselftest_harness.h | 46 ++++++++++++++++-----
 1 file changed, 35 insertions(+), 11 deletions(-)

diff --git a/tools/testing/selftests/kselftest_harness.h b/tools/testing/selftests/kselftest_harness.h
index aaf58fffc8f7..0f68943d6f04 100644
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
@@ -212,10 +214,12 @@
  * populated and cleaned up using FIXTURE_SETUP() and FIXTURE_TEARDOWN().
  */
 #define FIXTURE(fixture_name) \
+	static struct __fixture_metadata _##fixture_name##_fixture_object = \
+		{ .name =  #fixture_name, }; \
 	static void __attribute__((constructor)) \
 	_register_##fixture_name##_data(void) \
 	{ \
-		__fixture_count++; \
+		__register_fixture(&_##fixture_name##_fixture_object); \
 	} \
 	FIXTURE_DATA(fixture_name)
 
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
@@ -654,10 +659,33 @@
 	} \
 }
 
+/* Contains all the information about a fixture */
+struct __fixture_metadata {
+	const char *name;
+	struct __fixture_metadata *prev, *next;
+} _fixture_global __attribute__((unused)) = {
+	.name = "global",
+	.prev = &_fixture_global,
+};
+
+static struct __fixture_metadata *__fixture_list = &_fixture_global;
+static unsigned int __fixture_count;
+static int __constructor_order;
+
+#define _CONSTRUCTOR_ORDER_FORWARD   1
+#define _CONSTRUCTOR_ORDER_BACKWARD -1
+
+static inline void __register_fixture(struct __fixture_metadata *f)
+{
+	__fixture_count++;
+	__LIST_APPEND(__fixture_list, f);
+}
+
 /* Contains all the information for test execution and status checking. */
 struct __test_metadata {
 	const char *name;
 	void (*fn)(struct __test_metadata *);
+	struct __fixture_metadata *fixture;
 	int termsig;
 	int passed;
 	int trigger; /* extra handler after the evaluation */
@@ -670,11 +698,6 @@ struct __test_metadata {
 /* Storage for the (global) tests to be run. */
 static struct __test_metadata *__test_list;
 static unsigned int __test_count;
-static unsigned int __fixture_count;
-static int __constructor_order;
-
-#define _CONSTRUCTOR_ORDER_FORWARD   1
-#define _CONSTRUCTOR_ORDER_BACKWARD -1
 
 /*
  * Since constructors are called in reverse order, reverse the test
@@ -708,7 +731,7 @@ void __run_test(struct __test_metadata *t)
 
 	t->passed = 1;
 	t->trigger = 0;
-	printf("[ RUN      ] %s\n", t->name);
+	printf("[ RUN      ] %s.%s\n", t->fixture->name, t->name);
 	alarm(t->timeout);
 	child_pid = fork();
 	if (child_pid < 0) {
@@ -757,7 +780,8 @@ void __run_test(struct __test_metadata *t)
 				status);
 		}
 	}
-	printf("[     %4s ] %s\n", (t->passed ? "OK" : "FAIL"), t->name);
+	printf("[     %4s ] %s.%s\n", (t->passed ? "OK" : "FAIL"),
+	       t->fixture->name, t->name);
 	alarm(0);
 }
 
-- 
2.24.1

