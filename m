Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38A92405387
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 14:52:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356123AbhIIMwx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 08:52:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:42574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1355327AbhIIMtm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Sep 2021 08:49:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BDC94613A1;
        Thu,  9 Sep 2021 11:57:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188621;
        bh=ZWep0WPF1IjUAje+ZQ5KO+fruCBz/AcdChbTVOFIS7I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d0RvDZ5g1+x6ukxZjSJHxbCr5Afl/65u3EqDfTT27dcDUa0GtC2c0KIoVw4P7wAQM
         SUVe8JJt+nqYk8BZLaGuwSFjZxoBDMIiwiaV42jYCaJzTSBCA80NeCu58t5LYT6L+R
         ZWq070Eu/Ftm0EWv40U7hrN7nhV36KqCwQPuvkpMKq1xqeUCrIZBaPImsqp6ZYedar
         3Cfl2FlX6ddFgeLI6QBOiXuJTyXZesVLNqnkoEHli+MhiT66+HU1pT3a/qidmKBRRT
         CLNvPcZqOzQZuEHUpU8QQ/7jp9s/lwIjiHE8S/uG8mFgMm10OX+9rz5YmZMOP12tKc
         arP6pVn3BgXDQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Li Zhijian <lizhijian@cn.fujitsu.com>,
        kernel test robot <lkp@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Song Liu <songliubraving@fb.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 090/109] selftests/bpf: Enlarge select() timeout for test_maps
Date:   Thu,  9 Sep 2021 07:54:47 -0400
Message-Id: <20210909115507.147917-90-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909115507.147917-1-sashal@kernel.org>
References: <20210909115507.147917-1-sashal@kernel.org>
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
index 1c4219ceced2..45c7a55f0b8b 100644
--- a/tools/testing/selftests/bpf/test_maps.c
+++ b/tools/testing/selftests/bpf/test_maps.c
@@ -972,7 +972,7 @@ static void test_sockmap(unsigned int tasks, void *data)
 
 		FD_ZERO(&w);
 		FD_SET(sfd[3], &w);
-		to.tv_sec = 1;
+		to.tv_sec = 30;
 		to.tv_usec = 0;
 		s = select(sfd[3] + 1, &w, NULL, NULL, &to);
 		if (s == -1) {
-- 
2.30.2

