Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82D5E183F75
	for <lists+netdev@lfdr.de>; Fri, 13 Mar 2020 04:18:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726702AbgCMDSL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 23:18:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:33856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726610AbgCMDSB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Mar 2020 23:18:01 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A3F4C20746;
        Fri, 13 Mar 2020 03:18:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584069481;
        bh=V+9fuoaJ3miIbGpMqDeScz30txZDBgabbSNwz3tgdrE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eHw23A9vEOGWhYBHDPniLW7NOLjrCN9FydRG8ZfY/GCPbODEcUE13cP0q8K7sLSOL
         OW+jiulVASJlmNkDT1+chCvdDQIHuSes5np3A/rk9ju3EZgAvMCBuSF8773z+L1zxF
         greEDENwEaGQecU0vykAUml0fmiJZ+Be/blVKqJw=
From:   Jakub Kicinski <kuba@kernel.org>
To:     shuah@kernel.org
Cc:     keescook@chromium.org, luto@amacapital.net, wad@chromium.org,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-team@fb.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4/5] kselftest: add fixture parameters
Date:   Thu, 12 Mar 2020 20:17:51 -0700
Message-Id: <20200313031752.2332565-5-kuba@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200313031752.2332565-1-kuba@kernel.org>
References: <20200313031752.2332565-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Allow users to pass parameters to fixtures.

Each fixture will be evaluated for each of its parameter
sets.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 Documentation/dev-tools/kselftest.rst       |   3 +-
 tools/testing/selftests/kselftest_harness.h | 159 ++++++++++++++++----
 2 files changed, 135 insertions(+), 27 deletions(-)

diff --git a/Documentation/dev-tools/kselftest.rst b/Documentation/dev-tools/kselftest.rst
index 61ae13c44f91..3c41f7494762 100644
--- a/Documentation/dev-tools/kselftest.rst
+++ b/Documentation/dev-tools/kselftest.rst
@@ -301,7 +301,8 @@ Helpers
 
 .. kernel-doc:: tools/testing/selftests/kselftest_harness.h
     :functions: TH_LOG TEST TEST_SIGNAL FIXTURE FIXTURE_DATA FIXTURE_SETUP
-                FIXTURE_TEARDOWN TEST_F TEST_HARNESS_MAIN
+                FIXTURE_TEARDOWN TEST_F TEST_HARNESS_MAIN FIXTURE_PARAMS
+                FIXTURE_PARAMS_ADD
 
 Operators
 ---------
diff --git a/tools/testing/selftests/kselftest_harness.h b/tools/testing/selftests/kselftest_harness.h
index 7a3392941a5b..78b963f75d3b 100644
--- a/tools/testing/selftests/kselftest_harness.h
+++ b/tools/testing/selftests/kselftest_harness.h
@@ -168,9 +168,15 @@
 
 #define __TEST_IMPL(test_name, _signal) \
 	static void test_name(struct __test_metadata *_metadata); \
+	static inline void wrapper_##test_name( \
+		struct __test_metadata *_metadata, \
+		struct __fixture_params_metadata *p) \
+	{ \
+		test_name(_metadata); \
+	} \
 	static struct __test_metadata _##test_name##_object = \
 		{ .name = #test_name, \
-		  .fn = &test_name, \
+		  .fn = &wrapper_##test_name, \
 		  .fixture = &_fixture_global, \
 		  .termsig = _signal, \
 		  .timeout = TEST_TIMEOUT_DEFAULT, }; \
@@ -214,6 +220,7 @@
  * populated and cleaned up using FIXTURE_SETUP() and FIXTURE_TEARDOWN().
  */
 #define FIXTURE(fixture_name) \
+	FIXTURE_PARAMS(fixture_name); \
 	static struct __fixture_metadata _##fixture_name##_fixture_object = \
 		{ .name =  #fixture_name, }; \
 	static void __attribute__((constructor)) \
@@ -245,7 +252,9 @@
 #define FIXTURE_SETUP(fixture_name) \
 	void fixture_name##_setup( \
 		struct __test_metadata __attribute__((unused)) *_metadata, \
-		FIXTURE_DATA(fixture_name) __attribute__((unused)) *self)
+		FIXTURE_DATA(fixture_name) __attribute__((unused)) *self, \
+		const FIXTURE_PARAMS(fixture_name) __attribute__((unused)) *params)
+
 /**
  * FIXTURE_TEARDOWN(fixture_name)
  * *_metadata* is included so that EXPECT_* and ASSERT_* work correctly.
@@ -267,6 +276,56 @@
 		struct __test_metadata __attribute__((unused)) *_metadata, \
 		FIXTURE_DATA(fixture_name) __attribute__((unused)) *self)
 
+/**
+ * FIXTURE_PARAMS(fixture_name) - Optionally called once per fixture
+ * to declare fixture parameters
+ *
+ * @fixture_name: fixture name
+ *
+ * .. code-block:: c
+ *
+ *     FIXTURE_PARAMS(datatype name) {
+ *       type property1;
+ *       ...
+ *     };
+ *
+ * Defines type of constant parameters provided to FIXTURE_SETUP() and TEST_F()
+ * as *params*.
+ */
+#define FIXTURE_PARAMS(fixture_name) struct _fixture_params_##fixture_name
+
+/**
+ * FIXTURE_PARAMS_ADD(fixture_name, params_name) - Called once per fixture
+ * params to setup the data and register
+ *
+ * @fixture_name: fixture name
+ * @params_name: name of the parameter set
+ *
+ * .. code-block:: c
+ *
+ *     FIXTURE_ADD(datatype name) {
+ *       .property1 = val1;
+ *       ...
+ *     };
+ *
+ * Defines an instance of parameters provided to FIXTURE_SETUP() and TEST_F()
+ * as *params*. Tests of each fixture will be run for each parameter set.
+ */
+#define FIXTURE_PARAMS_ADD(fixture_name, params_name) \
+	extern FIXTURE_PARAMS(fixture_name) \
+		_##fixture_name##_##params_name##_params; \
+	static struct __fixture_params_metadata \
+		_##fixture_name##_##params_name##_object = \
+		{ .name = #params_name, \
+		  .data = &_##fixture_name##_##params_name##_params}; \
+	static void __attribute__((constructor)) \
+		_register_##fixture_name##_##params_name(void) \
+	{ \
+		__register_fixture_params(&_##fixture_name##_fixture_object, \
+			&_##fixture_name##_##params_name##_object);	\
+	} \
+	FIXTURE_PARAMS(fixture_name) _##fixture_name##_##params_name##_params =
+
 /**
  * TEST_F(fixture_name, test_name) - Emits test registration and helpers for
  * fixture-based test cases
@@ -297,18 +356,20 @@
 #define __TEST_F_IMPL(fixture_name, test_name, signal, tmout) \
 	static void fixture_name##_##test_name( \
 		struct __test_metadata *_metadata, \
-		FIXTURE_DATA(fixture_name) *self); \
+		FIXTURE_DATA(fixture_name) *self, \
+		const FIXTURE_PARAMS(fixture_name) *params); \
 	static inline void wrapper_##fixture_name##_##test_name( \
-		struct __test_metadata *_metadata) \
+		struct __test_metadata *_metadata, \
+		struct __fixture_params_metadata *p) \
 	{ \
 		/* fixture data is alloced, setup, and torn down per call. */ \
 		FIXTURE_DATA(fixture_name) self; \
 		memset(&self, 0, sizeof(FIXTURE_DATA(fixture_name))); \
-		fixture_name##_setup(_metadata, &self); \
+		fixture_name##_setup(_metadata, &self, p->data); \
 		/* Let setup failure terminate early. */ \
 		if (!_metadata->passed) \
 			return; \
-		fixture_name##_##test_name(_metadata, &self); \
+		fixture_name##_##test_name(_metadata, &self, p->data); \
 		fixture_name##_teardown(_metadata, &self); \
 	} \
 	static struct __test_metadata \
@@ -326,7 +387,8 @@
 	} \
 	static void fixture_name##_##test_name( \
 		struct __test_metadata __attribute__((unused)) *_metadata, \
-		FIXTURE_DATA(fixture_name) __attribute__((unused)) *self)
+		FIXTURE_DATA(fixture_name) __attribute__((unused)) *self, \
+		const FIXTURE_PARAMS(fixture_name) __attribute__((unused)) *params)
 
 /**
  * TEST_HARNESS_MAIN - Simple wrapper to run the test harness
@@ -638,10 +700,12 @@
 
 /* Contains all the information about a fixture */
 struct __test_metadata;
+struct __fixture_params_metadata;
 
 struct __fixture_metadata {
 	const char *name;
 	struct __test_metadata *tests;
+	struct __fixture_params_metadata *params;
 	struct __fixture_metadata *prev, *next;
 } _fixture_global __attribute__((unused)) = {
 	.name = "global",
@@ -649,7 +713,6 @@ struct __fixture_metadata {
 };
 
 static struct __fixture_metadata *__fixture_list = &_fixture_global;
-static unsigned int __fixture_count;
 static int __constructor_order;
 
 #define _CONSTRUCTOR_ORDER_FORWARD   1
@@ -657,7 +720,6 @@ static int __constructor_order;
 
 static inline void __register_fixture(struct __fixture_metadata *f)
 {
-	__fixture_count++;
 	/* Circular linked list where only prev is circular. */
 	if (__constructor_order == _CONSTRUCTOR_ORDER_FORWARD) {
 		f->next = NULL;
@@ -672,10 +734,41 @@ static inline void __register_fixture(struct __fixture_metadata *f)
 	}
 }
 
+struct __fixture_params_metadata {
+	const char *name;
+	const void *data;
+	struct __fixture_params_metadata *prev, *next;
+};
+
+static inline void
+__register_fixture_params(struct __fixture_metadata *f,
+			  struct __fixture_params_metadata *p)
+{
+	/* Circular linked list where only prev is circular. */
+	if (f->params == NULL) {
+		f->params = p;
+		p->next = NULL;
+		p->prev = p;
+		return;
+	}
+	if (__constructor_order == _CONSTRUCTOR_ORDER_FORWARD) {
+		p->next = NULL;
+		p->prev = f->params->prev;
+		p->prev->next = p;
+		f->params->prev = p;
+	} else {
+		p->next = f->params;
+		p->next->prev = p;
+		p->prev = p;
+		f->params = p;
+	}
+}
+
 /* Contains all the information for test execution and status checking. */
 struct __test_metadata {
 	const char *name;
-	void (*fn)(struct __test_metadata *);
+	void (*fn)(struct __test_metadata *,
+		   struct __fixture_params_metadata *);
 	struct __fixture_metadata *fixture;
 	int termsig;
 	int passed;
@@ -686,9 +779,6 @@ struct __test_metadata {
 	struct __test_metadata *prev, *next;
 };
 
-/* Storage for the (global) tests to be run. */
-static unsigned int __test_count;
-
 /*
  * Since constructors are called in reverse order, reverse the test
  * list so tests are run in source declaration order.
@@ -702,7 +792,6 @@ static inline void __register_test(struct __test_metadata *t)
 {
 	struct __fixture_metadata *f = t->fixture;
 
-	__test_count++;
 	/* Circular linked list where only prev is circular. */
 	if (f->tests == NULL) {
 		f->tests = t;
@@ -734,21 +823,26 @@ static inline int __bail(int for_realz, bool no_print, __u8 step)
 }
 
 void __run_test(struct __fixture_metadata *f,
+		struct __fixture_params_metadata *p,
 		struct __test_metadata *t)
 {
 	pid_t child_pid;
 	int status;
 
+	/* reset test struct */
 	t->passed = 1;
 	t->trigger = 0;
-	printf("[ RUN      ] %s.%s\n", f->name, t->name);
+	t->step = 0;
+	t->no_print = 0;
+
+	printf("[ RUN      ] %s%s.%s\n", f->name, p->name, t->name);
 	alarm(t->timeout);
 	child_pid = fork();
 	if (child_pid < 0) {
 		printf("ERROR SPAWNING TEST CHILD\n");
 		t->passed = 0;
 	} else if (child_pid == 0) {
-		t->fn(t);
+		t->fn(t, p);
 		/* return the step that failed or 0 */
 		_exit(t->passed ? 0 : t->step);
 	} else {
@@ -790,31 +884,44 @@ void __run_test(struct __fixture_metadata *f,
 				status);
 		}
 	}
-	printf("[     %4s ] %s.%s\n", (t->passed ? "OK" : "FAIL"),
-	       f->name, t->name);
+	printf("[     %4s ] %s%s.%s\n", (t->passed ? "OK" : "FAIL"),
+	       f->name, p->name, t->name);
 	alarm(0);
 }
 
 static int test_harness_run(int __attribute__((unused)) argc,
 			    char __attribute__((unused)) **argv)
 {
+	struct __fixture_params_metadata no_param = { .name = "", };
+	struct __fixture_params_metadata *p;
 	struct __fixture_metadata *f;
 	struct __test_metadata *t;
 	int ret = 0;
+	unsigned int fixture_count = 0, test_count = 0;
 	unsigned int count = 0;
 	unsigned int pass_count = 0;
 
+	for (f = __fixture_list; f; f = f->next) {
+		fixture_count++;
+		for (p = f->params ?: &no_param; p; p = p->next) {
+			for (t = f->tests; t; t = t->next)
+				test_count++;
+		}
+	}
+
 	/* TODO(wad) add optional arguments similar to gtest. */
 	printf("[==========] Running %u tests from %u test cases.\n",
-	       __test_count, __fixture_count + 1);
+	       test_count, fixture_count);
 	for (f = __fixture_list; f; f = f->next) {
-		for (t = f->tests; t; t = t->next) {
-			count++;
-			__run_test(f, t);
-			if (t->passed)
-				pass_count++;
-			else
-				ret = 1;
+		for (p = f->params ?: &no_param; p; p = p->next) {
+			for (t = f->tests; t; t = t->next) {
+				count++;
+				__run_test(f, p, t);
+				if (t->passed)
+					pass_count++;
+				else
+					ret = 1;
+			}
 		}
 	}
 	printf("[==========] %u / %u tests passed.\n", pass_count, count);
-- 
2.24.1

