Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50AF4404E85
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 14:18:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346632AbhIIMMS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 08:12:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:47664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350589AbhIIMIc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Sep 2021 08:08:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B4C3D61989;
        Thu,  9 Sep 2021 11:47:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188077;
        bh=FIgcBaf1x/mj2ueC9NL0wLHh1TCLgr9fKcH5mALS70Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZNTAqOiBuJgDfD85VwOlwdgSuGXygyzH49OP2oPM77Nk9rE0eATGeblONOlx+g2sN
         YEITgDTvWoBWU2Bxags773Ok0aW+tOaVk3mTyjWlm69wUj3tQ6TbyZ1rAIbDf9P/fj
         WJF78Vp179qH+HJXo53/1jU7NArvIQ8ZqC/L4X9OU7zUpFZY5osVCmL9s3wQy36Hxn
         89nL8mfIBWAsWIaQFJMCNLu/gmBgPQSFxr9XuqE2ms36fB6eeciby7Oe7TaNCOgHAN
         YS0AqgqiOuq2q7ELHrTPX7ohVrWBprmGb9q8dUThlvLS6YDJy/AXGnB73xAgfViFdE
         ke/Z7kywvtnoQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        kernel test robot <lkp@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 063/219] ipv4: ip_output.c: Fix out-of-bounds warning in ip_copy_addrs()
Date:   Thu,  9 Sep 2021 07:43:59 -0400
Message-Id: <20210909114635.143983-63-sashal@kernel.org>
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
index 8d8a8da3ae7e..a202dcec0dc2 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -446,8 +446,9 @@ static void ip_copy_addrs(struct iphdr *iph, const struct flowi4 *fl4)
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

