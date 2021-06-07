Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00E9939E2AD
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 18:17:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232170AbhFGQSu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 12:18:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:49406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232166AbhFGQQp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Jun 2021 12:16:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EBBFD61469;
        Mon,  7 Jun 2021 16:14:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623082445;
        bh=gnIHSmiRm2ZA2eahi/RuH956Cu8q5rAqA8rv2HTFy0s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lYH5ETPkGEbeVRM3iDG+bisWAhJ7CqUybLGFAud9IYfJx08y5AqrP6Or4Y4Ix+Xqt
         3knT8OYDd82GVUame35iQPevxX+2Md3LBlCMA2WnwOqkFpJ4h56iRva55HXfk3HzQ7
         u0Q/ga9Iwg9N6Rr8opSOh8GiUMe5HajFqjR3DiHuvsIuzPyPkigstM+UeVALx6j579
         2QH7XXO6UOrcptogi6V9Zoqh887O5Mj5TFynItSgCIXxYIWW6bSeHzz6kfE/FRFVFt
         3T926hGzCFMdKuHn0hOwhh7LhmrqODWsDRBWLwTzTVLA9CaMI71u6dhA9nJf4awgQs
         wcSV+OjizLddA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 36/39] rtnetlink: Fix missing error code in rtnl_bridge_notify()
Date:   Mon,  7 Jun 2021 12:13:15 -0400
Message-Id: <20210607161318.3583636-36-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210607161318.3583636-1-sashal@kernel.org>
References: <20210607161318.3583636-1-sashal@kernel.org>
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
index eae8e87930cd..83894723ebee 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -4842,8 +4842,10 @@ static int rtnl_bridge_notify(struct net_device *dev)
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

