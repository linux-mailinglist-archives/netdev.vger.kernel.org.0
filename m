Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 456EA1064D7
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 07:20:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729122AbfKVGUC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 01:20:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:58654 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728678AbfKVFwr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Nov 2019 00:52:47 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D8EFD2071B;
        Fri, 22 Nov 2019 05:52:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574401966;
        bh=A/Gyt4u7QrLQqefxIrkznJtIypsCEwCYUtwHl31T/So=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WlRB+KchPHi74X42dGiNKcyPAs6SoKC9RT0c2jVkV8jANfqW8cnTgb/O/rWqLi7+b
         ANCwxP5apRmiAe0UVuB79UC5w/qHyf6h/jMH3oqDtLUBZPkPKOYwimJFM4fNLtwtZx
         kOwM4A+Z5pBY89l4N3KDrGACQFLF//Wn6IXqZGhI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hoang Le <hoang.h.le@dektech.com.au>,
        Ying Xue <ying.xue@windriver.com>,
        Jon Maloy <maloy@donjonn.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net
Subject: [PATCH AUTOSEL 4.19 187/219] tipc: fix skb may be leaky in tipc_link_input
Date:   Fri, 22 Nov 2019 00:48:39 -0500
Message-Id: <20191122054911.1750-180-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191122054911.1750-1-sashal@kernel.org>
References: <20191122054911.1750-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hoang Le <hoang.h.le@dektech.com.au>

[ Upstream commit 7384b538d3aed2ed49d3575483d17aeee790fb06 ]

When we free skb at tipc_data_input, we return a 'false' boolean.
Then, skb passed to subcalling tipc_link_input in tipc_link_rcv,

<snip>
1303 int tipc_link_rcv:
...
1354    if (!tipc_data_input(l, skb, l->inputq))
1355        rc |= tipc_link_input(l, skb, l->inputq);
</snip>

Fix it by simple changing to a 'true' boolean when skb is being free-ed.
Then, tipc_link_rcv will bypassed to subcalling tipc_link_input as above
condition.

Acked-by: Ying Xue <ying.xue@windriver.com>
Acked-by: Jon Maloy <maloy@donjonn.com>
Signed-off-by: Hoang Le <hoang.h.le@dektech.com.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tipc/link.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/tipc/link.c b/net/tipc/link.c
index 6344aca4487b6..0fbf8ea18ce04 100644
--- a/net/tipc/link.c
+++ b/net/tipc/link.c
@@ -1114,7 +1114,7 @@ static bool tipc_data_input(struct tipc_link *l, struct sk_buff *skb,
 	default:
 		pr_warn("Dropping received illegal msg type\n");
 		kfree_skb(skb);
-		return false;
+		return true;
 	};
 }
 
-- 
2.20.1

