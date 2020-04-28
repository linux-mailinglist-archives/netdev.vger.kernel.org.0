Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CAD01BB329
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 03:04:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726475AbgD1BEC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 21:04:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:36606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726333AbgD1BD7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Apr 2020 21:03:59 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D127B2087E;
        Tue, 28 Apr 2020 01:03:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588035839;
        bh=g/zxUoV11L3leiURwmH4DyXBiVX/z9vSKwWK/3LSbSM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ypE/NOh5NrKs2lYSEgArtTZbdYavf4VBSDG4smMWrW4aKTRSe0nHPjVsM3YWWfjiB
         SBLc7XG+34A5O9+nUJcoxmynzcWgl7L0qP6kyzZ/BceN2kMbcukfO97uaTIqilqrUa
         +y4BaWZzkZFdKsEsKDywNFVBbcXo3KfTsYatlQwg=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     keescook@chromium.org, shuah@kernel.org, netdev@vger.kernel.org,
        luto@amacapital.net, wad@chromium.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-team@fb.com, Tim.Bird@sony.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v6 3/5] kselftest: run tests by fixture
Date:   Mon, 27 Apr 2020 18:03:49 -0700
Message-Id: <20200428010351.331260-4-kuba@kernel.org>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200428010351.331260-1-kuba@kernel.org>
References: <20200428010351.331260-1-kuba@kernel.org>
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
index de283fd6fc4d..fa7185e45472 100644
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
@@ -698,7 +701,6 @@ struct __test_metadata {
 };
 
 /* Storage for the (global) tests to be run. */
-static struct __test_metadata *__test_list;
 static unsigned int __test_count;
 
 /*
@@ -713,7 +715,7 @@ static unsigned int __test_count;
 static inline void __register_test(struct __test_metadata *t)
 {
 	__test_count++;
-	__LIST_APPEND(__test_list, t);
+	__LIST_APPEND(t->fixture->tests, t);
 }
 
 static inline int __bail(int for_realz, bool no_print, __u8 step)
@@ -843,6 +845,7 @@ void __run_test(struct __fixture_metadata *f,
 static int test_harness_run(int __attribute__((unused)) argc,
 			    char __attribute__((unused)) **argv)
 {
+	struct __fixture_metadata *f;
 	struct __test_metadata *t;
 	int ret = 0;
 	unsigned int count = 0;
@@ -851,13 +854,15 @@ static int test_harness_run(int __attribute__((unused)) argc,
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
2.25.4

