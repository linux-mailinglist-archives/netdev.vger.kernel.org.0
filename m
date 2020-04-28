Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCDCF1BB331
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 03:04:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726458AbgD1BEB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 21:04:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:36588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726379AbgD1BD7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Apr 2020 21:03:59 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4EFC22076A;
        Tue, 28 Apr 2020 01:03:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588035838;
        bh=sI5YlXnxvwDMVw94RKzTs8PTlfcSp9XRW34Ret2ZJaY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SM/E3Vg1Xz5R6NJ9wgCAweS1w8dukvuGLgfaCQoDLX6TRU6ZaJRnKJ5IxGXEHbp93
         rz9fYpX93HNoAhcse6/o7BDLe78XkxaIvjIMGXXrDTXN8MlNRh8FjSU2sM6Q3Ujq5y
         6h+q4H8KUULGOfAfXbuxXH7loCPIDd8WqlEQdcnY=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     keescook@chromium.org, shuah@kernel.org, netdev@vger.kernel.org,
        luto@amacapital.net, wad@chromium.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-team@fb.com, Tim.Bird@sony.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v6 2/5] kselftest: create fixture objects
Date:   Mon, 27 Apr 2020 18:03:48 -0700
Message-Id: <20200428010351.331260-3-kuba@kernel.org>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200428010351.331260-1-kuba@kernel.org>
References: <20200428010351.331260-1-kuba@kernel.org>
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
---
v5:
 - pass fixture as argument to __run_test() right away,
   previously this change was made in the next patch.
---
 tools/testing/selftests/kselftest_harness.h | 51 +++++++++++++++------
 1 file changed, 38 insertions(+), 13 deletions(-)

diff --git a/tools/testing/selftests/kselftest_harness.h b/tools/testing/selftests/kselftest_harness.h
index 77f754854f0d..de283fd6fc4d 100644
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
@@ -654,11 +659,34 @@
 	} \
 }
 
+/* Contains all the information about a fixture. */
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
 	pid_t pid;	/* pid of test when being run */
+	struct __fixture_metadata *fixture;
 	int termsig;
 	int passed;
 	int trigger; /* extra handler after the evaluation */
@@ -672,11 +700,6 @@ struct __test_metadata {
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
@@ -796,11 +819,12 @@ void __wait_for_test(struct __test_metadata *t)
 	}
 }
 
-void __run_test(struct __test_metadata *t)
+void __run_test(struct __fixture_metadata *f,
+		struct __test_metadata *t)
 {
 	t->passed = 1;
 	t->trigger = 0;
-	printf("[ RUN      ] %s\n", t->name);
+	printf("[ RUN      ] %s.%s\n", f->name, t->name);
 	t->pid = fork();
 	if (t->pid < 0) {
 		printf("ERROR SPAWNING TEST CHILD\n");
@@ -812,7 +836,8 @@ void __run_test(struct __test_metadata *t)
 	} else {
 		__wait_for_test(t);
 	}
-	printf("[     %4s ] %s\n", (t->passed ? "OK" : "FAIL"), t->name);
+	printf("[     %4s ] %s.%s\n", (t->passed ? "OK" : "FAIL"),
+	       f->name, t->name);
 }
 
 static int test_harness_run(int __attribute__((unused)) argc,
@@ -828,7 +853,7 @@ static int test_harness_run(int __attribute__((unused)) argc,
 	       __test_count, __fixture_count + 1);
 	for (t = __test_list; t; t = t->next) {
 		count++;
-		__run_test(t);
+		__run_test(t->fixture, t);
 		if (t->passed)
 			pass_count++;
 		else
-- 
2.25.4

