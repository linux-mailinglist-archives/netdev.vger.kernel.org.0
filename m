Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 005BA404FBA
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 14:22:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349806AbhIIMWV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 08:22:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:53658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347513AbhIIMRI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Sep 2021 08:17:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5336861A86;
        Thu,  9 Sep 2021 11:49:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188190;
        bh=fXUm+1P8jqrO3JjwbNQzdbjMaWrfv6nz8zqrQTyzUZY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n+cOCDr7SfRl5eDJOowGC/xxNstZ/6M1YOQQMfFMv/cdPrgcw414oH/oIV1oYJqAl
         /4JaMkL0lAYkWS2KXvOzMaEJEiHSxP74sb4OYXdS0qJKXFuaNQ4E6W7gCQkzIBu4C+
         irYWlUbH8BcHw9WqaM7kyfwynMe2csiirZw1RZokq8a0eLBwu9MaQPQiLRM57nAd+I
         7odO+W0Tem5eY+Gtm1xxfG4lBHdRqXQrKM+F6pSH6TIetEGNipsLgUDF/HPmvU3zW5
         8qcZOMKVJ8EPQZQwyDcn32TzPG2LgmMkbEfoftzkxCJ+7ScGqFpfFOPxhifL5Q58J7
         4N3D+8mVE1Ahg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yucong Sun <fallentree@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 150/219] selftests/bpf: Correctly display subtest skip status
Date:   Thu,  9 Sep 2021 07:45:26 -0400
Message-Id: <20210909114635.143983-150-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909114635.143983-1-sashal@kernel.org>
References: <20210909114635.143983-1-sashal@kernel.org>
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
index 6396932b97e2..9ed13187136c 100644
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
@@ -783,17 +783,18 @@ int main(int argc, char **argv)
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

