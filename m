Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2550040567F
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 15:37:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359806AbhIINUX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 09:20:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:36122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1358967AbhIINLk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Sep 2021 09:11:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2CFC260F6C;
        Thu,  9 Sep 2021 12:01:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188895;
        bh=K5gwc1hm6QAcBwI9w5qko2ajGG95XuMHVbJfJJua3zE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OPUIYBYEjIH+ZejMzQWwhiEtNilpkI8nmL5DLsiKGmRzQ+QA0G6hGKdKX8tVAmVjt
         0Eig82fWhslyQ/AZQ54+b5razfsIJ3J2FYyq+rAsRwVC0OaetgKANggPEDOUgpVvMD
         2ISiZn7X+k9WHcRsXtGXUxJ3xvIVvrf2RJ7C1vv+szSs+cZoGeXGo8EDCBt3XHetYt
         fw8vVOFgx5LG2XIrvZ5jVS0JVEOrGpDES4hXyQXzMvtveFMG65juHqJh4Jg6O/ExtB
         9rug3uca2He67bgP9WROGMzlQutcbBL293znVz3JfHAi1TfjKAwA7I67pT/ftxWduQ
         2+vWyeojgXyfg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        kernel test robot <lkp@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 15/35] ipv4: ip_output.c: Fix out-of-bounds warning in ip_copy_addrs()
Date:   Thu,  9 Sep 2021 08:00:56 -0400
Message-Id: <20210909120116.150912-15-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909120116.150912-1-sashal@kernel.org>
References: <20210909120116.150912-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Gustavo A. R. Silva" <gustavoars@kernel.org>

[ Upstream commit 6321c7acb82872ef6576c520b0e178eaad3a25c0 ]

Fix the following out-of-bounds warning:

    In function 'ip_copy_addrs',
        inlined from '__ip_queue_xmit' at net/ipv4/ip_output.c:517:2:
net/ipv4/ip_output.c:449:2: warning: 'memcpy' offset [40, 43] from the object at 'fl' is out of the bounds of referenced subobject 'saddr' with type 'unsigned int' at offset 36 [-Warray-bounds]
      449 |  memcpy(&iph->saddr, &fl4->saddr,
          |  ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      450 |         sizeof(fl4->saddr) + sizeof(fl4->daddr));
          |         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The problem is that the original code is trying to copy data into a
couple of struct members adjacent to each other in a single call to
memcpy(). This causes a legitimate compiler warning because memcpy()
overruns the length of &iph->saddr and &fl4->saddr. As these are just
a couple of struct members, fix this by using direct assignments,
instead of memcpy().

This helps with the ongoing efforts to globally enable -Warray-bounds
and get us closer to being able to tighten the FORTIFY_SOURCE routines
on memcpy().

Link: https://github.com/KSPP/linux/issues/109
Reported-by: kernel test robot <lkp@intel.com>
Link: https://lore.kernel.org/lkml/d5ae2e65-1f18-2577-246f-bada7eee6ccd@intel.com/
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/ip_output.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index e808227c58d6..477540b3d320 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -376,8 +376,9 @@ static void ip_copy_addrs(struct iphdr *iph, const struct flowi4 *fl4)
 {
 	BUILD_BUG_ON(offsetof(typeof(*fl4), daddr) !=
 		     offsetof(typeof(*fl4), saddr) + sizeof(fl4->saddr));
-	memcpy(&iph->saddr, &fl4->saddr,
-	       sizeof(fl4->saddr) + sizeof(fl4->daddr));
+
+	iph->saddr = fl4->saddr;
+	iph->daddr = fl4->daddr;
 }
 
 /* Note: skb->sk can be different from sk, in case of tunnels */
-- 
2.30.2

