Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F45A1F300E
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 02:56:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728355AbgFHXJK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jun 2020 19:09:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:54746 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728338AbgFHXJH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Jun 2020 19:09:07 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BAC5120897;
        Mon,  8 Jun 2020 23:09:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591657746;
        bh=gxk9MSh3P8MPirDz3R+VvLbXVPW8bi0sEi+cQ9ZIbSQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lTxNbrXd+EOIMJt2pS99zyO2GfR0vIAOu4a+fGMlJwKVArStOjHwFJNWkQPh7/9bc
         P8DDXjDBa1lrJAe6NRyVD4rNwoczRNN6Xwvg2lJ2Ria87y/i6a5lzSTZJVNc90SVGk
         DE+a9f39QHE+UAU7aQ/ab9wHqtbOlUqYtJRzOkvA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andrii Nakryiko <andriin@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Carlos Neira <cneirabustos@gmail.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 134/274] selftests/bpf: Fix bpf_link leak in ns_current_pid_tgid selftest
Date:   Mon,  8 Jun 2020 19:03:47 -0400
Message-Id: <20200608230607.3361041-134-sashal@kernel.org>
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

[ Upstream commit 8d30e80a049ad699264e4a12911e349f93c7279a ]

If condition is inverted, but it's also just not necessary.

Fixes: 1c1052e0140a ("tools/testing/selftests/bpf: Add self-tests for new helper bpf_get_ns_current_pid_tgid.")
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Cc: Carlos Neira <cneirabustos@gmail.com>
Link: https://lore.kernel.org/bpf/20200429012111.277390-11-andriin@fb.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/prog_tests/ns_current_pid_tgid.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/ns_current_pid_tgid.c b/tools/testing/selftests/bpf/prog_tests/ns_current_pid_tgid.c
index 542240e16564..e74dc501b27f 100644
--- a/tools/testing/selftests/bpf/prog_tests/ns_current_pid_tgid.c
+++ b/tools/testing/selftests/bpf/prog_tests/ns_current_pid_tgid.c
@@ -80,9 +80,6 @@ void test_ns_current_pid_tgid(void)
 		  "User pid/tgid %llu BPF pid/tgid %llu\n", id, bss.pid_tgid))
 		goto cleanup;
 cleanup:
-	if (!link) {
-		bpf_link__destroy(link);
-		link = NULL;
-	}
+	bpf_link__destroy(link);
 	bpf_object__close(obj);
 }
-- 
2.25.1

