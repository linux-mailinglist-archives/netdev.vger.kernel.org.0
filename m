Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4AE51189365
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 02:02:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727341AbgCRBCc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 21:02:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:39334 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727324AbgCRBCc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Mar 2020 21:02:32 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E327520770;
        Wed, 18 Mar 2020 01:02:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584493351;
        bh=cABuhCTkMtuGM44qoVy4jHonsF1WkMNTGRhYX0kzk+s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OXgaAoMMVAz5X+AB6ki/8SGDuQr2Qae8pDchKoMgIefUWmfnHeUVa/3rhDOwiE5PT
         TcxxUYpIq9UCwWTbQvda62b2tsaCj7LxhsQxfNp30SIGEfIQBa+laEU3Brv/RmU4XG
         yjKIfzpwGFnYg/uwjQiC28W37TJOisE49A+0WSi0=
From:   Jakub Kicinski <kuba@kernel.org>
To:     keescook@chromium.org, shuah@kernel.org
Cc:     netdev@vger.kernel.org, luto@amacapital.net, wad@chromium.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-team@fb.com, Tim.Bird@sony.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH v5 4/5] kselftest: add fixture variants
Date:   Tue, 17 Mar 2020 18:01:52 -0700
Message-Id: <20200318010153.40797-5-kuba@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200318010153.40797-1-kuba@kernel.org>
References: <20200318010153.40797-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Allow users to build parameterized variants of fixtures.

If fixtures want variants, they call FIXTURE_VARIANT() to declare
the structure to fill for each variant. Each fixture will be re-run
for each of the variants defined by calling FIXTURE_VARIANT_ADD()
with the differing parameters initializing the structure.

Since tests are being re-run, additional initialization (steps,
no_print) is also added.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Acked-by: Kees Cook <keescook@chromium.org>
--
v3:
 - separate variant name out with a dot;
 - count variants as "cases" in the opening print.
v4:
 - realign and break lines after s/params/variant/
v5:
 - reword the commit message;

Kees also notes after his series for timeouts is merged the new
"timed_out" field will need to be initialized in __run_test().
---
 Documentation/dev-tools/kselftest.rst       |   3 +-
 tools/testing/selftests/kselftest_harness.h | 148 ++++++++++++++++----
 2 files changed, 124 insertions(+), 27 deletions(-)

diff --git a/Documentation/dev-tools/kselftest.rst b/Documentation/dev-tools/kselftest.rst
index 61ae13c44f91..5d1f56fcd2e7 100644
--- a/Documentation/dev-tools/kselftest.rst
+++ b/Documentation/dev-tools/kselftest.rst
@@ -301,7 +301,8 @@ Helpers
 
 .. kernel-doc:: tools/testing/selftests/kselftest_harness.h
     :functions: TH_LOG TEST TEST_SIGNAL FIXTURE FIXTURE_DATA FIXTURE_SETUP
-                FIXTURE_TEARDOWN TEST_F TEST_HARNESS_MAIN
+                FIXTURE_TEARDOWN TEST_F TEST_HARNESS_MAIN FIXTURE_VARIANT
+                FIXTURE_VARIANT_ADD
 
 Operators
 ---------
diff --git a/tools/testing/selftests/kselftest_harness.h b/tools/testing/selftests/kselftest_harness.h
index de38d6898c3f..76e8ee57116f 100644
--- a/tools/testing/selftests/kselftest_harness.h
+++ b/tools/testing/selftests/kselftest_harness.h
@@ -168,9 +168,15 @@
 
 #define __TEST_IMPL(test_name, _signal) \
 	static void test_name(struct __test_metadata *_metadata); \
+	static inline void wrapper_##test_name( \
+		struct __test_metadata *_metadata, \
+		struct __fixture_variant_metadata *variant) \
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
+	FIXTURE_VARIANT(fixture_name); \
 	static struct __fixture_metadata _##fixture_name##_fixture_object = \
 		{ .name =  #fixture_name, }; \
 	static void __attribute__((constructor)) \
@@ -245,7 +252,10 @@
 #define FIXTURE_SETUP(fixture_name) \
 	void fixture_name##_setup( \
 		struct __test_metadata __attribute__((unused)) *_metadata, \
-		FIXTURE_DATA(fixture_name) __attribute__((unused)) *self)
+		FIXTURE_DATA(fixture_name) __attribute__((unused)) *self, \
+		const FIXTURE_VARIANT(fixture_name) \
+			__attribute__((unused)) *variant)
+
 /**
  * FIXTURE_TEARDOWN(fixture_name)
  * *_metadata* is included so that EXPECT_* and ASSERT_* work correctly.
@@ -267,6 +277,59 @@
 		struct __test_metadata __attribute__((unused)) *_metadata, \
 		FIXTURE_DATA(fixture_name) __attribute__((unused)) *self)
 
+/**
+ * FIXTURE_VARIANT(fixture_name) - Optionally called once per fixture
+ * to declare fixture variant
+ *
+ * @fixture_name: fixture name
+ *
+ * .. code-block:: c
+ *
+ *     FIXTURE_VARIANT(datatype name) {
+ *       type property1;
+ *       ...
+ *     };
+ *
+ * Defines type of constant parameters provided to FIXTURE_SETUP() and TEST_F()
+ * as *variant*. Variants allow the same tests to be run with different
+ * arguments.
+ */
+#define FIXTURE_VARIANT(fixture_name) struct _fixture_variant_##fixture_name
+
+/**
+ * FIXTURE_VARIANT_ADD(fixture_name, variant_name) - Called once per fixture
+ * variant to setup and register the data
+ *
+ * @fixture_name: fixture name
+ * @variant_name: name of the parameter set
+ *
+ * .. code-block:: c
+ *
+ *     FIXTURE_ADD(datatype name) {
+ *       .property1 = val1;
+ *       ...
+ *     };
+ *
+ * Defines a variant of the test fixture, provided to FIXTURE_SETUP() and
+ * TEST_F() as *variant*. Tests of each fixture will be run once for each
+ * variant.
+ */
+#define FIXTURE_VARIANT_ADD(fixture_name, variant_name) \
+	extern FIXTURE_VARIANT(fixture_name) \
+		_##fixture_name##_##variant_name##_variant; \
+	static struct __fixture_variant_metadata \
+		_##fixture_name##_##variant_name##_object = \
+		{ .name = #variant_name, \
+		  .data = &_##fixture_name##_##variant_name##_variant}; \
+	static void __attribute__((constructor)) \
+		_register_##fixture_name##_##variant_name(void) \
+	{ \
+		__register_fixture_variant(&_##fixture_name##_fixture_object, \
+			&_##fixture_name##_##variant_name##_object);	\
+	} \
+	FIXTURE_VARIANT(fixture_name) \
+		_##fixture_name##_##variant_name##_variant =
+
 /**
  * TEST_F(fixture_name, test_name) - Emits test registration and helpers for
  * fixture-based test cases
@@ -297,18 +360,20 @@
 #define __TEST_F_IMPL(fixture_name, test_name, signal, tmout) \
 	static void fixture_name##_##test_name( \
 		struct __test_metadata *_metadata, \
-		FIXTURE_DATA(fixture_name) *self); \
+		FIXTURE_DATA(fixture_name) *self, \
+		const FIXTURE_VARIANT(fixture_name) *variant); \
 	static inline void wrapper_##fixture_name##_##test_name( \
-		struct __test_metadata *_metadata) \
+		struct __test_metadata *_metadata, \
+		struct __fixture_variant_metadata *variant) \
 	{ \
 		/* fixture data is alloced, setup, and torn down per call. */ \
 		FIXTURE_DATA(fixture_name) self; \
 		memset(&self, 0, sizeof(FIXTURE_DATA(fixture_name))); \
-		fixture_name##_setup(_metadata, &self); \
+		fixture_name##_setup(_metadata, &self, variant->data); \
 		/* Let setup failure terminate early. */ \
 		if (!_metadata->passed) \
 			return; \
-		fixture_name##_##test_name(_metadata, &self); \
+		fixture_name##_##test_name(_metadata, &self, variant->data); \
 		fixture_name##_teardown(_metadata, &self); \
 	} \
 	static struct __test_metadata \
@@ -326,7 +391,9 @@
 	} \
 	static void fixture_name##_##test_name( \
 		struct __test_metadata __attribute__((unused)) *_metadata, \
-		FIXTURE_DATA(fixture_name) __attribute__((unused)) *self)
+		FIXTURE_DATA(fixture_name) __attribute__((unused)) *self, \
+		const FIXTURE_VARIANT(fixture_name) \
+			__attribute__((unused)) *variant)
 
 /**
  * TEST_HARNESS_MAIN - Simple wrapper to run the test harness
@@ -660,11 +727,13 @@
 }
 
 struct __test_metadata;
+struct __fixture_variant_metadata;
 
 /* Contains all the information about a fixture. */
 struct __fixture_metadata {
 	const char *name;
 	struct __test_metadata *tests;
+	struct __fixture_variant_metadata *variant;
 	struct __fixture_metadata *prev, *next;
 } _fixture_global __attribute__((unused)) = {
 	.name = "global",
@@ -672,7 +741,6 @@ struct __fixture_metadata {
 };
 
 static struct __fixture_metadata *__fixture_list = &_fixture_global;
-static unsigned int __fixture_count;
 static int __constructor_order;
 
 #define _CONSTRUCTOR_ORDER_FORWARD   1
@@ -680,14 +748,27 @@ static int __constructor_order;
 
 static inline void __register_fixture(struct __fixture_metadata *f)
 {
-	__fixture_count++;
 	__LIST_APPEND(__fixture_list, f);
 }
 
+struct __fixture_variant_metadata {
+	const char *name;
+	const void *data;
+	struct __fixture_variant_metadata *prev, *next;
+};
+
+static inline void
+__register_fixture_variant(struct __fixture_metadata *f,
+			   struct __fixture_variant_metadata *variant)
+{
+	__LIST_APPEND(f->variant, variant);
+}
+
 /* Contains all the information for test execution and status checking. */
 struct __test_metadata {
 	const char *name;
-	void (*fn)(struct __test_metadata *);
+	void (*fn)(struct __test_metadata *,
+		   struct __fixture_variant_metadata *);
 	struct __fixture_metadata *fixture;
 	int termsig;
 	int passed;
@@ -698,9 +779,6 @@ struct __test_metadata {
 	struct __test_metadata *prev, *next;
 };
 
-/* Storage for the (global) tests to be run. */
-static unsigned int __test_count;
-
 /*
  * Since constructors are called in reverse order, reverse the test
  * list so tests are run in source declaration order.
@@ -712,7 +790,6 @@ static unsigned int __test_count;
  */
 static inline void __register_test(struct __test_metadata *t)
 {
-	__test_count++;
 	__LIST_APPEND(t->fixture->tests, t);
 }
 
@@ -727,21 +804,27 @@ static inline int __bail(int for_realz, bool no_print, __u8 step)
 }
 
 void __run_test(struct __fixture_metadata *f,
+		struct __fixture_variant_metadata *variant,
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
+	printf("[ RUN      ] %s%s%s.%s\n",
+	       f->name, variant->name[0] ? "." : "", variant->name, t->name);
 	alarm(t->timeout);
 	child_pid = fork();
 	if (child_pid < 0) {
 		printf("ERROR SPAWNING TEST CHILD\n");
 		t->passed = 0;
 	} else if (child_pid == 0) {
-		t->fn(t);
+		t->fn(t, variant);
 		/* return the step that failed or 0 */
 		_exit(t->passed ? 0 : t->step);
 	} else {
@@ -783,31 +866,44 @@ void __run_test(struct __fixture_metadata *f,
 				status);
 		}
 	}
-	printf("[     %4s ] %s.%s\n", (t->passed ? "OK" : "FAIL"),
-	       f->name, t->name);
+	printf("[     %4s ] %s%s%s.%s\n", (t->passed ? "OK" : "FAIL"),
+	       f->name, variant->name[0] ? "." : "", variant->name, t->name);
 	alarm(0);
 }
 
 static int test_harness_run(int __attribute__((unused)) argc,
 			    char __attribute__((unused)) **argv)
 {
+	struct __fixture_variant_metadata no_variant = { .name = "", };
+	struct __fixture_variant_metadata *v;
 	struct __fixture_metadata *f;
 	struct __test_metadata *t;
 	int ret = 0;
+	unsigned int case_count = 0, test_count = 0;
 	unsigned int count = 0;
 	unsigned int pass_count = 0;
 
+	for (f = __fixture_list; f; f = f->next) {
+		for (v = f->variant ?: &no_variant; v; v = v->next) {
+			case_count++;
+			for (t = f->tests; t; t = t->next)
+				test_count++;
+		}
+	}
+
 	/* TODO(wad) add optional arguments similar to gtest. */
 	printf("[==========] Running %u tests from %u test cases.\n",
-	       __test_count, __fixture_count + 1);
+	       test_count, case_count);
 	for (f = __fixture_list; f; f = f->next) {
-		for (t = f->tests; t; t = t->next) {
-			count++;
-			__run_test(f, t);
-			if (t->passed)
-				pass_count++;
-			else
-				ret = 1;
+		for (v = f->variant ?: &no_variant; v; v = v->next) {
+			for (t = f->tests; t; t = t->next) {
+				count++;
+				__run_test(f, v, t);
+				if (t->passed)
+					pass_count++;
+				else
+					ret = 1;
+			}
 		}
 	}
 	printf("[==========] %u / %u tests passed.\n", pass_count, count);
-- 
2.25.1

