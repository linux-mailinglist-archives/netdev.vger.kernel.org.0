Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D9BD404D95
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 14:05:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346662AbhIIMDd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 08:03:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:41250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245640AbhIIMBW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Sep 2021 08:01:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BCCBF61222;
        Thu,  9 Sep 2021 11:46:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631187984;
        bh=RgyEE/gxv2+PbwT+Twl7+jMwQK+Cn83YUGhdVMiZbVs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BNIJvHB6ZUd/fVq8ngTeDvk3bILJTASO6uO4lzppBaifgcCDQ5qPj5VAkiZFf6opv
         6GFGf0/gop1ESVZmrDeiDLsRbEVZe7KFNmTQzOd/Od7ne5AWCWSAd3VtPvkDQ0HUzS
         epzWa3ZZYxqw4MeALNF/N4REDgB+SO4t4+mJKrKNjGZV5lwuhZw8EcGorfIsHfbHvf
         spjvXg72vTACvcLI9S+o7ySMHq7LmVNjO9hwQBphfaGtjxthrWqw1pvJ3nZ8HV6EnG
         D5227dP6dEkA3+GYsvrUlQybhK2cefnuDCEwAl1i+h6BBKzUJXrHJTmBLRrqml1wZZ
         ZQnaiAKnil4aw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chengfeng Ye <cyeaa@connect.ust.hk>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 245/252] selftests/bpf: Fix potential unreleased lock
Date:   Thu,  9 Sep 2021 07:40:59 -0400
Message-Id: <20210909114106.141462-245-sashal@kernel.org>
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

From: Chengfeng Ye <cyeaa@connect.ust.hk>

[ Upstream commit 47bb27a20d6ea22cd092c1fc2bb4fcecac374838 ]

This lock is not released if the program
return at the patched branch.

Signed-off-by: Chengfeng Ye <cyeaa@connect.ust.hk>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/bpf/20210827074140.118671-1-cyeaa@connect.ust.hk
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/prog_tests/sockopt_inherit.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/sockopt_inherit.c b/tools/testing/selftests/bpf/prog_tests/sockopt_inherit.c
index ec281b0363b8..86f97681ad89 100644
--- a/tools/testing/selftests/bpf/prog_tests/sockopt_inherit.c
+++ b/tools/testing/selftests/bpf/prog_tests/sockopt_inherit.c
@@ -195,8 +195,10 @@ static void run_test(int cgroup_fd)
 
 	pthread_mutex_lock(&server_started_mtx);
 	if (CHECK_FAIL(pthread_create(&tid, NULL, server_thread,
-				      (void *)&server_fd)))
+				      (void *)&server_fd))) {
+		pthread_mutex_unlock(&server_started_mtx);
 		goto close_server_fd;
+	}
 	pthread_cond_wait(&server_started, &server_started_mtx);
 	pthread_mutex_unlock(&server_started_mtx);
 
-- 
2.30.2

