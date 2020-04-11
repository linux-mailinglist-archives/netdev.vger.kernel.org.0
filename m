Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 094181A59FA
	for <lists+netdev@lfdr.de>; Sun, 12 Apr 2020 01:40:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729832AbgDKXkN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Apr 2020 19:40:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:43344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727919AbgDKXH2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 11 Apr 2020 19:07:28 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DE7FF20787;
        Sat, 11 Apr 2020 23:07:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586646447;
        bh=h08k/XGB9YiKKAdTyYQIrzIjmYkhYs7ZSTs9y0CzzVs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N/835YQ1eNIDhLkRpzm8i108HL7ND/KuyET/gCOxgrgvJKcUgkxWN6aq0OP1l7Fui
         Fhj1zJT0iIgTH2yq9ne1CA/VwxErlG32O9+N6Z/38QQsQhsCEjnL5VWqRWvvyckMpq
         HQGlSumYC82iCqDERcec3WpLUxVEqmgVpS9LUEWQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andrii Nakryiko <andriin@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 018/121] selftests/bpf: Fix test_progs's parsing of test numbers
Date:   Sat, 11 Apr 2020 19:05:23 -0400
Message-Id: <20200411230706.23855-18-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200411230706.23855-1-sashal@kernel.org>
References: <20200411230706.23855-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrii Nakryiko <andriin@fb.com>

[ Upstream commit fc32490bff855a539d253c8a52c5a1ba51d1325a ]

When specifying disjoint set of tests, test_progs doesn't set skipped test's
array elements to false. This leads to spurious execution of tests that should
have been skipped. Fix it by explicitly initializing them to false.

Fixes: 3a516a0a3a7b ("selftests/bpf: add sub-tests support for test_progs")
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Martin KaFai Lau <kafai@fb.com>
Link: https://lore.kernel.org/bpf/20200314013932.4035712-2-andriin@fb.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/test_progs.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_progs.c b/tools/testing/selftests/bpf/test_progs.c
index 7fa7d08a8104d..849c1e8b8e3dc 100644
--- a/tools/testing/selftests/bpf/test_progs.c
+++ b/tools/testing/selftests/bpf/test_progs.c
@@ -361,7 +361,7 @@ static int libbpf_print_fn(enum libbpf_print_level level,
 
 int parse_num_list(const char *s, struct test_selector *sel)
 {
-	int i, set_len = 0, num, start = 0, end = -1;
+	int i, set_len = 0, new_len, num, start = 0, end = -1;
 	bool *set = NULL, *tmp, parsing_end = false;
 	char *next;
 
@@ -396,18 +396,19 @@ int parse_num_list(const char *s, struct test_selector *sel)
 			return -EINVAL;
 
 		if (end + 1 > set_len) {
-			set_len = end + 1;
-			tmp = realloc(set, set_len);
+			new_len = end + 1;
+			tmp = realloc(set, new_len);
 			if (!tmp) {
 				free(set);
 				return -ENOMEM;
 			}
+			for (i = set_len; i < start; i++)
+				tmp[i] = false;
 			set = tmp;
+			set_len = new_len;
 		}
-		for (i = start; i <= end; i++) {
+		for (i = start; i <= end; i++)
 			set[i] = true;
-		}
-
 	}
 
 	if (!set)
-- 
2.20.1

