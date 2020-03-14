Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2110B185379
	for <lists+netdev@lfdr.de>; Sat, 14 Mar 2020 01:55:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727828AbgCNAzJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 20:55:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:53564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727804AbgCNAzI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Mar 2020 20:55:08 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5ED6C2076B;
        Sat, 14 Mar 2020 00:55:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584147307;
        bh=1PE5F9GBO7z+taYxIwLOk+XjIk+3OynVr7wbWiBe/IY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MR3t5A8Sqqzn8lj28eViideZffAcUJuBxfFfM7fHLl5VmWcV62r0tvWxdgWEYrvVa
         PU8RUp/I38HPR5vHrLBWqnq9QJVFeQbgRwc7VUZoLN2u+eCbqW1gdLbmfVs5URc+j6
         35LLjh02QHlX2J6chXoMG093FfalrgBeDAf++hUg=
From:   Jakub Kicinski <kuba@kernel.org>
To:     shuah@kernel.org, keescook@chromium.org
Cc:     luto@amacapital.net, wad@chromium.org,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-team@fb.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH v2 3/4] kselftest: add fixture parameters
Date:   Fri, 13 Mar 2020 17:55:00 -0700
Message-Id: <20200314005501.2446494-4-kuba@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200314005501.2446494-1-kuba@kernel.org>
References: <20200314005501.2446494-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Allow users to pass parameters to fixtures.

Each test will be run once for each set of
its fixture parameter sets (or once if none).

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
--
v2:
 - don't pass params to functions, use a member
   of _metadata instead
---
 Documentation/dev-tools/kselftest.rst       |   3 +-
 tools/testing/selftests/kselftest_harness.h | 133 ++++++++++++++++++--
 2 files changed, 126 insertions(+), 10 deletions(-)

diff --git a/Documentation/dev-tools/kselftest.rst b/Documentation/dev-tools/kselftest.rst
index 61ae13c44f91..8aff58d11937 100644
--- a/Documentation/dev-tools/kselftest.rst
+++ b/Documentation/dev-tools/kselftest.rst
@@ -301,7 +301,8 @@ Helpers
 
 .. kernel-doc:: tools/testing/selftests/kselftest_harness.h
     :functions: TH_LOG TEST TEST_SIGNAL FIXTURE FIXTURE_DATA FIXTURE_SETUP
-                FIXTURE_TEARDOWN TEST_F TEST_HARNESS_MAIN
+                FIXTURE_TEARDOWN TEST_F TEST_HARNESS_MAIN FIXTURE_PARAMS
+                FIXTURE_PARAMS_ADD CURRENT_PARAMS
 
 Operators
 ---------
diff --git a/tools/testing/selftests/kselftest_harness.h b/tools/testing/selftests/kselftest_harness.h
index 66c2397d8c51..b7e1ecda441c 100644
--- a/tools/testing/selftests/kselftest_harness.h
+++ b/tools/testing/selftests/kselftest_harness.h
@@ -214,6 +214,7 @@
  * populated and cleaned up using FIXTURE_SETUP() and FIXTURE_TEARDOWN().
  */
 #define FIXTURE(fixture_name) \
+	FIXTURE_PARAMS(fixture_name); \
 	static struct __fixture_metadata _##fixture_name##_fixture_object = \
 		{ .name =  #fixture_name, }; \
 	static void __attribute__((constructor)) \
@@ -246,6 +247,7 @@
 	void fixture_name##_setup( \
 		struct __test_metadata __attribute__((unused)) *_metadata, \
 		FIXTURE_DATA(fixture_name) __attribute__((unused)) *self)
+
 /**
  * FIXTURE_TEARDOWN(fixture_name)
  * *_metadata* is included so that EXPECT_* and ASSERT_* work correctly.
@@ -267,6 +269,72 @@
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
+ * Defines an instance of parameters accessible in FIXTURE_SETUP(),
+ * FIXTURE_TEARDOWN() and TEST_F(). Tests will be run once for each
+ * parameter set.
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
+/**
+ * CURRENT_PARAMS(fixture_name) - Access fixture parameters of the current test
+ *
+ * @fixture_name: fixture name
+ *
+ * .. code-block:: c
+ *
+ *     CURRENT_PARAMS(fixture name)->property1
+ *
+ * Helper macro for accessing parameters of current test. Can be used inside
+ * FIXTURE_SETUP(), FIXTURE_TEARDOWN() and TEST_F().
+ */
+#define CURRENT_PARAMS(fixture_name) \
+	((const FIXTURE_PARAMS(fixture_name) *) _metadata->current_params->data)
+
 /**
  * TEST_F(fixture_name, test_name) - Emits test registration and helpers for
  * fixture-based test cases
@@ -638,11 +706,13 @@
 
 /* Contains all the information for test execution and status checking. */
 struct __fixture_metadata;
+struct __fixture_params_metadata;
 
 struct __test_metadata {
 	const char *name;
 	void (*fn)(struct __test_metadata *);
 	struct __fixture_metadata *fixture;
+	struct __fixture_params_metadata *current_params;
 	int termsig;
 	int passed;
 	int trigger; /* extra handler after the evaluation */
@@ -696,10 +766,41 @@ static inline void __register_test(struct __test_metadata *t)
 /* Contains all the information about a fixture */
 struct __fixture_metadata {
 	const char *name;
+	struct __fixture_params_metadata *params;
 } _fixture_global __attribute__((unused)) = {
 	.name = "global",
 };
 
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
 static inline int __bail(int for_realz, bool no_print, __u8 step)
 {
 	if (for_realz) {
@@ -711,14 +812,21 @@ static inline int __bail(int for_realz, bool no_print, __u8 step)
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
+	t->current_params = p;
+
+	printf("[ RUN      ] %s%s.%s\n", f->name, p->name, t->name);
 	alarm(t->timeout);
 	child_pid = fork();
 	if (child_pid < 0) {
@@ -767,14 +875,17 @@ void __run_test(struct __fixture_metadata *f,
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
+	struct __fixture_metadata *f;
 	struct __test_metadata *t;
 	int ret = 0;
 	unsigned int count = 0;
@@ -784,12 +895,16 @@ static int test_harness_run(int __attribute__((unused)) argc,
 	printf("[==========] Running %u tests from %u test cases.\n",
 	       __test_count, __fixture_count + 1);
 	for (t = __test_list; t; t = t->next) {
-		count++;
-		__run_test(t->fixture, t);
-		if (t->passed)
-			pass_count++;
-		else
-			ret = 1;
+		f = t->fixture;
+
+		for (p = f->params ?: &no_param; p; p = p->next) {
+			count++;
+			__run_test(f, p, t);
+			if (t->passed)
+				pass_count++;
+			else
+				ret = 1;
+		}
 	}
 	printf("[==========] %u / %u tests passed.\n", pass_count, count);
 	printf("[  %s  ]\n", (ret ? "FAILED" : "PASSED"));
-- 
2.24.1

