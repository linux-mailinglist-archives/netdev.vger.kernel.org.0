Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B72B51F300B
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 02:56:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728331AbgFHXJG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jun 2020 19:09:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:54628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728314AbgFHXJC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Jun 2020 19:09:02 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AB0CB208E4;
        Mon,  8 Jun 2020 23:09:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591657741;
        bh=t8EX+OcVvPjkVogK7HTxyL6ukX9m/HBgPkG41B/CT7o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IroOBB1iUIAbfWFEHwfez+w4FimyjYl1vuD59NknoZ2ENcif8Ul+4Z7s9EM+6mNXx
         OdNuQ9pXXqiVIg/He419YAyJvdXbpePYsXTJUHCaSXxKlxdJnJGNLAC5+ci33MozDM
         8S4O/QBqADEG0DZtfGNkdVyHBR/7e6zUNrS2TKGA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andrii Nakryiko <andriin@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 130/274] selftests/bpf: Fix memory leak in test selector
Date:   Mon,  8 Jun 2020 19:03:43 -0400
Message-Id: <20200608230607.3361041-130-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608230607.3361041-1-sashal@kernel.org>
References: <20200608230607.3361041-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrii Nakryiko <andriin@fb.com>

[ Upstream commit f25d5416d64c796aa639136eb0b076c8bd579b54 ]

Free test selector substrings, which were strdup()'ed.

Fixes: b65053cd94f4 ("selftests/bpf: Add whitelist/blacklist of test names to test_progs")
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/bpf/20200429012111.277390-6-andriin@fb.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/test_progs.c | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_progs.c b/tools/testing/selftests/bpf/test_progs.c
index b521e0a512b6..86d0020c9eec 100644
--- a/tools/testing/selftests/bpf/test_progs.c
+++ b/tools/testing/selftests/bpf/test_progs.c
@@ -420,6 +420,18 @@ static int libbpf_print_fn(enum libbpf_print_level level,
 	return 0;
 }
 
+static void free_str_set(const struct str_set *set)
+{
+	int i;
+
+	if (!set)
+		return;
+
+	for (i = 0; i < set->cnt; i++)
+		free((void *)set->strs[i]);
+	free(set->strs);
+}
+
 static int parse_str_list(const char *s, struct str_set *set)
 {
 	char *input, *state = NULL, *next, **tmp, **strs = NULL;
@@ -756,11 +768,11 @@ int main(int argc, char **argv)
 	fprintf(stdout, "Summary: %d/%d PASSED, %d SKIPPED, %d FAILED\n",
 		env.succ_cnt, env.sub_succ_cnt, env.skip_cnt, env.fail_cnt);
 
-	free(env.test_selector.blacklist.strs);
-	free(env.test_selector.whitelist.strs);
+	free_str_set(&env.test_selector.blacklist);
+	free_str_set(&env.test_selector.whitelist);
 	free(env.test_selector.num_set);
-	free(env.subtest_selector.blacklist.strs);
-	free(env.subtest_selector.whitelist.strs);
+	free_str_set(&env.subtest_selector.blacklist);
+	free_str_set(&env.subtest_selector.whitelist);
 	free(env.subtest_selector.num_set);
 
 	return env.fail_cnt ? EXIT_FAILURE : EXIT_SUCCESS;
-- 
2.25.1

