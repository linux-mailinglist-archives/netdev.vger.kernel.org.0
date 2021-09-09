Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEAF040551A
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 15:32:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345296AbhIINIG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 09:08:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:43766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1355911AbhIINDp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Sep 2021 09:03:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9FB9F6140F;
        Thu,  9 Sep 2021 11:59:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188799;
        bh=dhMsRfuZVwhSZ56t3qLAGsartIx3boKk4d89WZH9zXc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VVSFnYlWQ/ucppI5Xs1VEv9Ejd+8fgDTJvqE7EhKO9X6Sueu0kY9jhNN3jQ6ySZtC
         1a6XgVi/LmlfLMZGxom5h4MPGG6o/jJAeIKqsJJPrUF44R8YU4UiZnQyiD43pnotwX
         9Vcw5FV2YsatdGG+2DUwSiYqlJxfps3DvweDShZXVoFwhgwEmcPX9jwUgOg8+Mo2GA
         OoLv/OU+2H3lvkO8wlqEuxqA4UDQqHCICYCUBY71hh6jT8MAAdbLpCAjrB2qtgzmKJ
         rvU06lbtRlX4QdYso11E3t4k8ByKpMupcO96WtO6GVliGGlfe2d3BBOLqdzNIi8Kyj
         LSWO+niYMi2kw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Li Zhijian <lizhijian@cn.fujitsu.com>,
        kernel test robot <lkp@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Song Liu <songliubraving@fb.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 47/59] selftests/bpf: Enlarge select() timeout for test_maps
Date:   Thu,  9 Sep 2021 07:58:48 -0400
Message-Id: <20210909115900.149795-47-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909115900.149795-1-sashal@kernel.org>
References: <20210909115900.149795-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Li Zhijian <lizhijian@cn.fujitsu.com>

[ Upstream commit 2d82d73da35b72b53fe0d96350a2b8d929d07e42 ]

0Day robot observed that it's easily timeout on a heavy load host.
-------------------
 # selftests: bpf: test_maps
 # Fork 1024 tasks to 'test_update_delete'
 # Fork 1024 tasks to 'test_update_delete'
 # Fork 100 tasks to 'test_hashmap'
 # Fork 100 tasks to 'test_hashmap_percpu'
 # Fork 100 tasks to 'test_hashmap_sizes'
 # Fork 100 tasks to 'test_hashmap_walk'
 # Fork 100 tasks to 'test_arraymap'
 # Fork 100 tasks to 'test_arraymap_percpu'
 # Failed sockmap unexpected timeout
 not ok 3 selftests: bpf: test_maps # exit=1
 # selftests: bpf: test_lru_map
 # nr_cpus:8
-------------------
Since this test will be scheduled by 0Day to a random host that could have
only a few cpus(2-8), enlarge the timeout to avoid a false NG report.

In practice, i tried to pin it to only one cpu by 'taskset 0x01 ./test_maps',
and knew 10S is likely enough, but i still perfer to a larger value 30.

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Li Zhijian <lizhijian@cn.fujitsu.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Song Liu <songliubraving@fb.com>
Link: https://lore.kernel.org/bpf/20210820015556.23276-2-lizhijian@cn.fujitsu.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/test_maps.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/test_maps.c b/tools/testing/selftests/bpf/test_maps.c
index 96c6238a4a1f..3f503ad37a2b 100644
--- a/tools/testing/selftests/bpf/test_maps.c
+++ b/tools/testing/selftests/bpf/test_maps.c
@@ -730,7 +730,7 @@ static void test_sockmap(int tasks, void *data)
 
 		FD_ZERO(&w);
 		FD_SET(sfd[3], &w);
-		to.tv_sec = 1;
+		to.tv_sec = 30;
 		to.tv_usec = 0;
 		s = select(sfd[3] + 1, &w, NULL, NULL, &to);
 		if (s == -1) {
-- 
2.30.2

