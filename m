Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA4F71A58BE
	for <lists+netdev@lfdr.de>; Sun, 12 Apr 2020 01:32:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728435AbgDKXKE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Apr 2020 19:10:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:48070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727620AbgDKXKC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 11 Apr 2020 19:10:02 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 800EA2173E;
        Sat, 11 Apr 2020 23:10:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586646602;
        bh=V8BCmqsWcg9DM/6hQQ/v3RBg1t9vH6T1JIenRWlxN1c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Je/EHCC/ZVgNvTzDPIWhOWyUnvNfjOXCid3VrNESgYXBEVK2lzrNkps8vtnjM12Dj
         RD7VUHeR7zVOORTpjW1S024LzumFV2zCRYwvLpSQxl+diLBUGhQQWRvmZhJ/C3tfEQ
         vUmP+vl4NPURUKg/e7z+wfnTtAj1HcsBiGzaZCLI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andrii Nakryiko <andriin@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 015/108] selftests/bpf: Fix test_progs's parsing of test numbers
Date:   Sat, 11 Apr 2020 19:08:10 -0400
Message-Id: <20200411230943.24951-15-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200411230943.24951-1-sashal@kernel.org>
References: <20200411230943.24951-1-sashal@kernel.org>
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
index 3bf18364c67c9..751be17980a91 100644
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

