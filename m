Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2940187749
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 02:04:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387489AbgCQBE0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Mar 2020 21:04:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:59900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387413AbgCQBEX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Mar 2020 21:04:23 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BF4AB206E2;
        Tue, 17 Mar 2020 01:04:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584407063;
        bh=45fsYffh3Uo6wUAOX3qL24WDiWQ9Qas3Ng0BML8C6MM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OVFmdKMcvpdRfx2RxIki2DkuketG8Dzz0YmkFBlEo6xCI1wWdy3UqCi5BgAY59M17
         SS7uiJrU6zaN/uXIlP/321soC9Hq+ntHLqN815hhPI0F6OQjRHBdgUIQ6h4O96nLXR
         eSdIOv/sbzMaOO44q7vsYU6UOBcGyk+2ZXUogaBY=
From:   Jakub Kicinski <kuba@kernel.org>
To:     shuah@kernel.org, keescook@chromium.org
Cc:     luto@amacapital.net, wad@chromium.org,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-team@fb.com,
        Tim.Bird@sony.com, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH v4 3/5] kselftest: run tests by fixture
Date:   Mon, 16 Mar 2020 18:04:17 -0700
Message-Id: <20200317010419.3268916-4-kuba@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200317010419.3268916-1-kuba@kernel.org>
References: <20200317010419.3268916-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that all tests have a fixture object move from a global
list of tests to a list of tests per fixture.

Order of tests may change as we will now group and run test
fixture by fixture, rather than in declaration order.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 tools/testing/selftests/kselftest_harness.h | 32 +++++++++++++--------
 1 file changed, 20 insertions(+), 12 deletions(-)

diff --git a/tools/testing/selftests/kselftest_harness.h b/tools/testing/selftests/kselftest_harness.h
index 0f68943d6f04..36ab1b92eb35 100644
--- a/tools/testing/selftests/kselftest_harness.h
+++ b/tools/testing/selftests/kselftest_harness.h
@@ -660,8 +660,11 @@
 }
 
 /* Contains all the information about a fixture */
+struct __test_metadata;
+
 struct __fixture_metadata {
 	const char *name;
+	struct __test_metadata *tests;
 	struct __fixture_metadata *prev, *next;
 } _fixture_global __attribute__((unused)) = {
 	.name = "global",
@@ -696,7 +699,6 @@ struct __test_metadata {
 };
 
 /* Storage for the (global) tests to be run. */
-static struct __test_metadata *__test_list;
 static unsigned int __test_count;
 
 /*
@@ -710,8 +712,10 @@ static unsigned int __test_count;
  */
 static inline void __register_test(struct __test_metadata *t)
 {
+	struct __fixture_metadata *f = t->fixture;
+
 	__test_count++;
-	__LIST_APPEND(__test_list, t);
+	__LIST_APPEND(f->tests, t);
 }
 
 static inline int __bail(int for_realz, bool no_print, __u8 step)
@@ -724,14 +728,15 @@ static inline int __bail(int for_realz, bool no_print, __u8 step)
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
-	printf("[ RUN      ] %s.%s\n", t->fixture->name, t->name);
+	printf("[ RUN      ] %s.%s\n", f->name, t->name);
 	alarm(t->timeout);
 	child_pid = fork();
 	if (child_pid < 0) {
@@ -781,13 +786,14 @@ void __run_test(struct __test_metadata *t)
 		}
 	}
 	printf("[     %4s ] %s.%s\n", (t->passed ? "OK" : "FAIL"),
-	       t->fixture->name, t->name);
+	       f->name, t->name);
 	alarm(0);
 }
 
 static int test_harness_run(int __attribute__((unused)) argc,
 			    char __attribute__((unused)) **argv)
 {
+	struct __fixture_metadata *f;
 	struct __test_metadata *t;
 	int ret = 0;
 	unsigned int count = 0;
@@ -796,13 +802,15 @@ static int test_harness_run(int __attribute__((unused)) argc,
 	/* TODO(wad) add optional arguments similar to gtest. */
 	printf("[==========] Running %u tests from %u test cases.\n",
 	       __test_count, __fixture_count + 1);
-	for (t = __test_list; t; t = t->next) {
-		count++;
-		__run_test(t);
-		if (t->passed)
-			pass_count++;
-		else
-			ret = 1;
+	for (f = __fixture_list; f; f = f->next) {
+		for (t = f->tests; t; t = t->next) {
+			count++;
+			__run_test(f, t);
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

