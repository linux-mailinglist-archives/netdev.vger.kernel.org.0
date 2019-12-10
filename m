Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 991D2119715
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 22:31:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728225AbfLJVJg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 16:09:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:58280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728211AbfLJVJf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Dec 2019 16:09:35 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A5565246AF;
        Tue, 10 Dec 2019 21:09:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576012174;
        bh=oW7QC7ZN3sDu53rgPYqBtojvRFrE+jG2HcylGdisCL0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W13duTr1XBqXhgqkrQaTsEqgF+fXheSzF8lFe2Mg5u6YODrQh7oshGRmE8G+M6YqL
         slm3+4vxpN4i9I8fVhbMnhUJDwE+wYskAyz10Hrgt76xT5ZFb0Xh9G/hTlMoOgdPnC
         mQjO8WHg1/J4Bk42ZnuHEng0iIYu97CR3vPLRqUU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andrii Nakryiko <andriin@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 132/350] selftests/bpf: Make a copy of subtest name
Date:   Tue, 10 Dec 2019 16:03:57 -0500
Message-Id: <20191210210735.9077-93-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210210735.9077-1-sashal@kernel.org>
References: <20191210210735.9077-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrii Nakryiko <andriin@fb.com>

[ Upstream commit f90415e9600c5227131531c0ed11514a2d3bbe62 ]

test_progs never created a copy of subtest name, rather just stored
pointer to whatever string test provided. This is bad as that string
might be freed or modified by the end of subtest. Fix this by creating
a copy of given subtest name when subtest starts.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20191021033902.3856966-6-andriin@fb.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/test_progs.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_progs.c b/tools/testing/selftests/bpf/test_progs.c
index af75a1c7a4587..3bf18364c67c9 100644
--- a/tools/testing/selftests/bpf/test_progs.c
+++ b/tools/testing/selftests/bpf/test_progs.c
@@ -20,7 +20,7 @@ struct prog_test_def {
 	bool tested;
 	bool need_cgroup_cleanup;
 
-	const char *subtest_name;
+	char *subtest_name;
 	int subtest_num;
 
 	/* store counts before subtest started */
@@ -81,16 +81,17 @@ void test__end_subtest()
 	fprintf(env.stdout, "#%d/%d %s:%s\n",
 	       test->test_num, test->subtest_num,
 	       test->subtest_name, sub_error_cnt ? "FAIL" : "OK");
+
+	free(test->subtest_name);
+	test->subtest_name = NULL;
 }
 
 bool test__start_subtest(const char *name)
 {
 	struct prog_test_def *test = env.test;
 
-	if (test->subtest_name) {
+	if (test->subtest_name)
 		test__end_subtest();
-		test->subtest_name = NULL;
-	}
 
 	test->subtest_num++;
 
@@ -104,7 +105,13 @@ bool test__start_subtest(const char *name)
 	if (!should_run(&env.subtest_selector, test->subtest_num, name))
 		return false;
 
-	test->subtest_name = name;
+	test->subtest_name = strdup(name);
+	if (!test->subtest_name) {
+		fprintf(env.stderr,
+			"Subtest #%d: failed to copy subtest name!\n",
+			test->subtest_num);
+		return false;
+	}
 	env.test->old_error_cnt = env.test->error_cnt;
 
 	return true;
-- 
2.20.1

