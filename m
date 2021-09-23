Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92FAE415679
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 05:40:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239547AbhIWDlb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 23:41:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:41226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239236AbhIWDkW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Sep 2021 23:40:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A03A661130;
        Thu, 23 Sep 2021 03:38:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632368331;
        bh=jgOM98fyfpg/ItXplawLWjUml575szh0tv6ThdXxb08=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LUyH4LqGpxtSY4XqHTfwuI/OYnFNhS3MzkEsZH/N8STOZ4VkMRo4nMCaTo5ZqgmFt
         KOIZxlNPxomWEGuEGYqBnABr8/IcYHjomrnM6ku6AZpbpr0x5r54nA9SimZhJKWKU3
         mGPGdc41DjnDYTPBRy1+dDA+4o531glB0RwbqIuN1Pu+ZQRzG8dZ3lcL6HTurdtM2A
         Mo5o7hrSU4kITADX+1Tlc2pY5yzDUrcTSxejJ1iT6xcLLp5XtsIpBoheYFCnS//qhD
         www0iTuKmApzXwelNI/EefS8vBfUZSnnx1EyX1xTQ6/e/K5vipquiLf/jw5Qeau3F5
         qmKhdiom8A1Fw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     zhang kai <zhangkaiheb@126.com>, David Ahern <dsahern@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, yoshfuji@linux-ipv6.org,
        kuba@kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 07/26] ipv6: delay fib6_sernum increase in fib6_add
Date:   Wed, 22 Sep 2021 23:38:20 -0400
Message-Id: <20210923033839.1421034-7-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210923033839.1421034-1-sashal@kernel.org>
References: <20210923033839.1421034-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: zhang kai <zhangkaiheb@126.com>

[ Upstream commit e87b5052271e39d62337ade531992b7e5d8c2cfa ]

only increase fib6_sernum in net namespace after add fib6_info
successfully.

Signed-off-by: zhang kai <zhangkaiheb@126.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/ip6_fib.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/ipv6/ip6_fib.c b/net/ipv6/ip6_fib.c
index 1fb79dbde0cb..e43f1fbac28b 100644
--- a/net/ipv6/ip6_fib.c
+++ b/net/ipv6/ip6_fib.c
@@ -1376,7 +1376,6 @@ int fib6_add(struct fib6_node *root, struct fib6_info *rt,
 	int err = -ENOMEM;
 	int allow_create = 1;
 	int replace_required = 0;
-	int sernum = fib6_new_sernum(info->nl_net);
 
 	if (info->nlh) {
 		if (!(info->nlh->nlmsg_flags & NLM_F_CREATE))
@@ -1476,7 +1475,7 @@ int fib6_add(struct fib6_node *root, struct fib6_info *rt,
 	if (!err) {
 		if (rt->nh)
 			list_add(&rt->nh_list, &rt->nh->f6i_list);
-		__fib6_update_sernum_upto_root(rt, sernum);
+		__fib6_update_sernum_upto_root(rt, fib6_new_sernum(info->nl_net));
 		fib6_start_gc(info->nl_net, rt);
 	}
 
-- 
2.30.2

