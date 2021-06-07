Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3487B39E3A2
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 18:40:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233382AbhFGQ1O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 12:27:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:33900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233510AbhFGQXo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Jun 2021 12:23:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 739A061940;
        Mon,  7 Jun 2021 16:15:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623082538;
        bh=YPfVsIP4uCZ7IM44bwqCjKcDi1lb2f8isXM2kOjgkkE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GQSBVYLngK2jeDLLEnQ8Nsw4M1e+88t0je5BSADUVBbZf2AwmApeFgGV0DPZP3wc+
         9eM+BD+7qwgE8IkQOzn9y8iNvj2lZiG3uhjphd3vn1iluIguqfpepnoC6PbJRLcBhg
         +PkqmNuCKfsLAz9bIwC6elCx+P6yuyq5/2RR0++NkFLeKGJKYr+nmBEOmGURkqmuGp
         sltuYvp+/NsKh5UKWPT/qe037ElGliSGe8QgWu6NPdYKGYCPTZbT6RqjGeh51hQ4Tt
         V6sThzX8r2Hj82JK3umARFJn+iZpL1oh550zMlswWuE8fKbNOwbpkhPfL0pzCQ6GcP
         OE173Sm1strKg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 15/18] rtnetlink: Fix missing error code in rtnl_bridge_notify()
Date:   Mon,  7 Jun 2021 12:15:13 -0400
Message-Id: <20210607161517.3584577-15-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210607161517.3584577-1-sashal@kernel.org>
References: <20210607161517.3584577-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>

[ Upstream commit a8db57c1d285c758adc7fb43d6e2bad2554106e1 ]

The error code is missing in this code scenario, add the error code
'-EINVAL' to the return value 'err'.

Eliminate the follow smatch warning:

net/core/rtnetlink.c:4834 rtnl_bridge_notify() warn: missing error code
'err'.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/rtnetlink.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 0168c700a201..fa3ed51f846b 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -3648,8 +3648,10 @@ static int rtnl_bridge_notify(struct net_device *dev)
 	if (err < 0)
 		goto errout;
 
-	if (!skb->len)
+	if (!skb->len) {
+		err = -EINVAL;
 		goto errout;
+	}
 
 	rtnl_notify(skb, net, 0, RTNLGRP_LINK, NULL, GFP_ATOMIC);
 	return 0;
-- 
2.30.2

