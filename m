Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B262183F79
	for <lists+netdev@lfdr.de>; Fri, 13 Mar 2020 04:18:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726716AbgCMDSS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 23:18:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:33840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726377AbgCMDSB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Mar 2020 23:18:01 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 294EE206F7;
        Fri, 13 Mar 2020 03:18:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584069480;
        bh=PlCamJTnvAikiLhrMigIC4HZB975Y4esN2CyxHaljVg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j8c6KBRnKhiuDK3Mv20hHV8q+rrR5AyZ3HS1dfPb7Onx/qQDLRbU2IvwFX4Mxt2vY
         jcaVbtPn5NXV7XQxGzXdiH+uyU5xa3Cr2BsUu3Jzqeyg3S0joS4bM9ThftcOcE3X2e
         V+tDw5ecHZEqq4VZutd3YM5DIreveeqD87hpjL3M=
From:   Jakub Kicinski <kuba@kernel.org>
To:     shuah@kernel.org
Cc:     keescook@chromium.org, luto@amacapital.net, wad@chromium.org,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-team@fb.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 3/5] kselftest: run tests by fixture
Date:   Thu, 12 Mar 2020 20:17:50 -0700
Message-Id: <20200313031752.2332565-4-kuba@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200313031752.2332565-1-kuba@kernel.org>
References: <20200313031752.2332565-1-kuba@kernel.org>
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
 tools/testing/selftests/kselftest_harness.h | 42 ++++++++++++---------
 1 file changed, 25 insertions(+), 17 deletions(-)

diff --git a/tools/testing/selftests/kselftest_harness.h b/tools/testing/selftests/kselftest_harness.h
index a396afe4a579..7a3392941a5b 100644
--- a/tools/testing/selftests/kselftest_harness.h
+++ b/tools/testing/selftests/kselftest_harness.h
@@ -637,8 +637,11 @@
 } while (0); OPTIONAL_HANDLER(_assert)
 
 /* Contains all the information about a fixture */
+struct __test_metadata;
+
 struct __fixture_metadata {
 	const char *name;
+	struct __test_metadata *tests;
 	struct __fixture_metadata *prev, *next;
 } _fixture_global __attribute__((unused)) = {
 	.name = "global",
@@ -684,7 +687,6 @@ struct __test_metadata {
 };
 
 /* Storage for the (global) tests to be run. */
-static struct __test_metadata *__test_list;
 static unsigned int __test_count;
 
 /*
@@ -698,24 +700,26 @@ static unsigned int __test_count;
  */
 static inline void __register_test(struct __test_metadata *t)
 {
+	struct __fixture_metadata *f = t->fixture;
+
 	__test_count++;
 	/* Circular linked list where only prev is circular. */
-	if (__test_list == NULL) {
-		__test_list = t;
+	if (f->tests == NULL) {
+		f->tests = t;
 		t->next = NULL;
 		t->prev = t;
 		return;
 	}
 	if (__constructor_order == _CONSTRUCTOR_ORDER_FORWARD) {
 		t->next = NULL;
-		t->prev = __test_list->prev;
+		t->prev = f->tests->prev;
 		t->prev->next = t;
-		__test_list->prev = t;
+		f->tests->prev = t;
 	} else {
-		t->next = __test_list;
+		t->next = f->tests;
 		t->next->prev = t;
 		t->prev = t;
-		__test_list = t;
+		f->tests = t;
 	}
 }
 
@@ -729,14 +733,15 @@ static inline int __bail(int for_realz, bool no_print, __u8 step)
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
@@ -786,13 +791,14 @@ void __run_test(struct __test_metadata *t)
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
@@ -801,13 +807,15 @@ static int test_harness_run(int __attribute__((unused)) argc,
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

