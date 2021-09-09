Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC46E405368
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 14:52:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354864AbhIIMvu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 08:51:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:55854 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1355100AbhIIMlC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Sep 2021 08:41:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 020C461BF9;
        Thu,  9 Sep 2021 11:54:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188496;
        bh=RgyEE/gxv2+PbwT+Twl7+jMwQK+Cn83YUGhdVMiZbVs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RIV6mbAjy/2HiIsbNfP99F04YOBbm9spod9GJTbRZhuZkQIgO7plBE0Z+D4gYPjaH
         SnHTSyWM7UU4ABtCliVQA1xJe+VyCVREdTKrW88AjUymZU/BweOj28Tp4bGHApwcml
         PU2/0JBl1j83zi00dEwWVQQWjzI/ZKeBbMc3FqhmDhA79Zi/DvSJGQJnx3OJCchzkG
         3er1o6kHskC5y2O6EVa2w3FTg5W9+BEMkaQw/8xeIBigriDBh8XcG1L766m2ZVktG+
         Xfpyv0UGMTUn5e61nTtoXn68Fm/2odcrUMKOjjoQB6/z0cpHLYx6fhWWg+Pn9CqSPF
         pCcekQDlV2bgg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chengfeng Ye <cyeaa@connect.ust.hk>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 169/176] selftests/bpf: Fix potential unreleased lock
Date:   Thu,  9 Sep 2021 07:51:11 -0400
Message-Id: <20210909115118.146181-169-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909115118.146181-1-sashal@kernel.org>
References: <20210909115118.146181-1-sashal@kernel.org>
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

