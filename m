Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CE73404C41
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 13:55:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243946AbhIIL4U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 07:56:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:34238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243678AbhIILyW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Sep 2021 07:54:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 06D8F6103D;
        Thu,  9 Sep 2021 11:44:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631187888;
        bh=Jh5NE7jztA+6OO7D91sSydLB1UH+UHC6Tmy4Sbywk7U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LaYLZAM/DeVf0FYCw8rJjJgxPL4NfLy/U3TfhiI50HKrnKYNcGgvh4TdHm5CI5xzk
         Px99QriOrD4jNAreDmzOXSATgDfGkb23Ad0qf1tbzI/mkmPkiZEW46xYzOP0kqRX63
         Kzv6XaQaU/tK2sOat4Weh5B8w3d+8NXQkPg3Z/Vgqj0gA24wHsz1itlual3VKUj3NH
         Vkvptw2k9GoR0Q/lZUXE4wjECrZboJPUp/vE7/Rwe5ZvJbg8pl0LymwKSvc8Rxjs7p
         fdXyd412kIyVd/xtraCvGZtXhJbBd879l+ddWh24yaMK1AV7Mo97IOnyA29cgv9q7V
         yczcJzpkhH75Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yucong Sun <fallentree@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 170/252] selftests/bpf: Correctly display subtest skip status
Date:   Thu,  9 Sep 2021 07:39:44 -0400
Message-Id: <20210909114106.141462-170-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909114106.141462-1-sashal@kernel.org>
References: <20210909114106.141462-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yucong Sun <fallentree@fb.com>

[ Upstream commit f667d1d66760fcb27aee6c9964eefde39a464afe ]

In skip_account(), test->skip_cnt is set to 0 at the end, this makes next print
statement never display SKIP status for the subtest. This patch moves the
accounting logic after the print statement, fixing the issue.

This patch also added SKIP status display for normal tests.

Signed-off-by: Yucong Sun <fallentree@fb.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20210817044732.3263066-3-fallentree@fb.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/test_progs.c | 25 ++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_progs.c b/tools/testing/selftests/bpf/test_progs.c
index 6f103106a39b..bfbf2277b61a 100644
--- a/tools/testing/selftests/bpf/test_progs.c
+++ b/tools/testing/selftests/bpf/test_progs.c
@@ -148,18 +148,18 @@ void test__end_subtest()
 	struct prog_test_def *test = env.test;
 	int sub_error_cnt = test->error_cnt - test->old_error_cnt;
 
-	if (sub_error_cnt)
-		env.fail_cnt++;
-	else if (test->skip_cnt == 0)
-		env.sub_succ_cnt++;
-	skip_account();
-
 	dump_test_log(test, sub_error_cnt);
 
 	fprintf(env.stdout, "#%d/%d %s:%s\n",
 	       test->test_num, test->subtest_num, test->subtest_name,
 	       sub_error_cnt ? "FAIL" : (test->skip_cnt ? "SKIP" : "OK"));
 
+	if (sub_error_cnt)
+		env.fail_cnt++;
+	else if (test->skip_cnt == 0)
+		env.sub_succ_cnt++;
+	skip_account();
+
 	free(test->subtest_name);
 	test->subtest_name = NULL;
 }
@@ -786,17 +786,18 @@ int main(int argc, char **argv)
 			test__end_subtest();
 
 		test->tested = true;
-		if (test->error_cnt)
-			env.fail_cnt++;
-		else
-			env.succ_cnt++;
-		skip_account();
 
 		dump_test_log(test, test->error_cnt);
 
 		fprintf(env.stdout, "#%d %s:%s\n",
 			test->test_num, test->test_name,
-			test->error_cnt ? "FAIL" : "OK");
+			test->error_cnt ? "FAIL" : (test->skip_cnt ? "SKIP" : "OK"));
+
+		if (test->error_cnt)
+			env.fail_cnt++;
+		else
+			env.succ_cnt++;
+		skip_account();
 
 		reset_affinity();
 		restore_netns();
-- 
2.30.2

