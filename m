Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18C27404FDD
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 14:22:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352882AbhIIMXN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 08:23:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:57790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353059AbhIIMUM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Sep 2021 08:20:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 35D8061A89;
        Thu,  9 Sep 2021 11:50:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188234;
        bh=irqyFv88sOHnPHJmIZxNFsH3dUiHqespwnL0sn7K1eU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ssUGol4xSt4EwNz46/Bai1uL8AnuAU22waKYXzScE03xvG5gk9fiz4I7vB+sbCSBP
         +GajHH+8lPltndLVhChGCiJqVlc1pwvuuot7Yw1BSIE9Q/6E8kSGjUKms4tRA8DcQE
         0y5wemStj9D9vWCcLXkjbgoz4avCobZ3BsznWdWNj+G1GMWvEqHhFzi1SYnzD5Wyjl
         AaruSsBVEEG0e0uWApu3Mgb5Kr65wUqCLDKC+trBKNcROfADSZuC+J6AfNf+oQacUK
         2qnK9V9gZKS2xkCFOekfGQei41rbTZkuarmzwGT5/q/ZHqFu3BhmpBS1eatoAZDmI/
         UU/4wy8mfKedQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Li Zhijian <lizhijian@cn.fujitsu.com>,
        kernel test robot <lkp@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Song Liu <songliubraving@fb.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 185/219] selftests/bpf: Enlarge select() timeout for test_maps
Date:   Thu,  9 Sep 2021 07:46:01 -0400
Message-Id: <20210909114635.143983-185-sashal@kernel.org>
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
index 51adc42b2b40..7fed68492a2e 100644
--- a/tools/testing/selftests/bpf/test_maps.c
+++ b/tools/testing/selftests/bpf/test_maps.c
@@ -968,7 +968,7 @@ static void test_sockmap(unsigned int tasks, void *data)
 
 		FD_ZERO(&w);
 		FD_SET(sfd[3], &w);
-		to.tv_sec = 1;
+		to.tv_sec = 30;
 		to.tv_usec = 0;
 		s = select(sfd[3] + 1, &w, NULL, NULL, &to);
 		if (s == -1) {
-- 
2.30.2

