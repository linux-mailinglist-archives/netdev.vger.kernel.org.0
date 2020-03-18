Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69E6018936B
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 02:02:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727414AbgCRBCm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 21:02:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:39306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727304AbgCRBCb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Mar 2020 21:02:31 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 68A392076A;
        Wed, 18 Mar 2020 01:02:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584493350;
        bh=DUPo3GN8HipNjHM66Tef9TzikURLlcvTLv5WTvpF2To=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2XGUHII62Ic4JN7mT7RuCedPBBUENc3wBazq+MbWkTp/ry5w7uWHzqPifFm4r8S8+
         ok3AgiR/wQVi3pomJ6dM+8O348DgW/r16vd3MhQtXAswk3oBAKWoXxTzhss2wgzPn+
         XDLZpzTkdpItNikto4E1vuaUR66mQy/WQvQsElbc=
From:   Jakub Kicinski <kuba@kernel.org>
To:     keescook@chromium.org, shuah@kernel.org
Cc:     netdev@vger.kernel.org, luto@amacapital.net, wad@chromium.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-team@fb.com, Tim.Bird@sony.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH v5 3/5] kselftest: run tests by fixture
Date:   Tue, 17 Mar 2020 18:01:51 -0700
Message-Id: <20200318010153.40797-4-kuba@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200318010153.40797-1-kuba@kernel.org>
References: <20200318010153.40797-1-kuba@kernel.org>
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
Acked-by: Kees Cook <keescook@chromium.org>
---
v5 (Kees):
 - move a comment;
 - remove temporary variable.
---
 tools/testing/selftests/kselftest_harness.h | 23 +++++++++++++--------
 1 file changed, 14 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/kselftest_harness.h b/tools/testing/selftests/kselftest_harness.h
index 2dc9b7a63467..de38d6898c3f 100644
--- a/tools/testing/selftests/kselftest_harness.h
+++ b/tools/testing/selftests/kselftest_harness.h
@@ -659,9 +659,12 @@
 	} \
 }
 
+struct __test_metadata;
+
 /* Contains all the information about a fixture. */
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
@@ -711,7 +713,7 @@ static unsigned int __test_count;
 static inline void __register_test(struct __test_metadata *t)
 {
 	__test_count++;
-	__LIST_APPEND(__test_list, t);
+	__LIST_APPEND(t->fixture->tests, t);
 }
 
 static inline int __bail(int for_realz, bool no_print, __u8 step)
@@ -789,6 +791,7 @@ void __run_test(struct __fixture_metadata *f,
 static int test_harness_run(int __attribute__((unused)) argc,
 			    char __attribute__((unused)) **argv)
 {
+	struct __fixture_metadata *f;
 	struct __test_metadata *t;
 	int ret = 0;
 	unsigned int count = 0;
@@ -797,13 +800,15 @@ static int test_harness_run(int __attribute__((unused)) argc,
 	/* TODO(wad) add optional arguments similar to gtest. */
 	printf("[==========] Running %u tests from %u test cases.\n",
 	       __test_count, __fixture_count + 1);
-	for (t = __test_list; t; t = t->next) {
-		count++;
-		__run_test(t->fixture, t);
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
2.25.1

