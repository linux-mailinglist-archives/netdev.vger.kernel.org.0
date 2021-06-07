Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C81B539E327
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 18:39:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232115AbhFGQVj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 12:21:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:48832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232591AbhFGQTf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Jun 2021 12:19:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3AD9F61874;
        Mon,  7 Jun 2021 16:14:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623082484;
        bh=BYIYTlizhazvwA/ycfrbXSk+j1HNLyl4SnXOEnTLaSA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j4aYSLuLOiQsGcIp5jvQXk630iMe883P5dcPgxOB6dTl0CD7B+rRm6jE1UwiUgPlY
         D3gdQtFZ9NiwES0pfLOYlzQrtU3XI+MKmmirazIPZMb/6fbftLW61MaaQ1/snN5Oc4
         i4/ZMNKk0NO94RHX7P0qPsLfoC9D51HKuusV6KEBX0Jx3kTSHecTGK3IFn5m7wXCAl
         3MD0nwhlkFopu+O0dr/GRDQX/S6V8uMK1YsOochN7sq1ohXkDe4JnEi8wN474yGevP
         PBwdJ6gmId+9Kw/iZf4mfg7AKc5pt7J5BcUlr3VWJ0T0jzFOK9BDGXZv9Ff6HbxrIJ
         BwQQVRXKpMfJw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 26/29] rtnetlink: Fix missing error code in rtnl_bridge_notify()
Date:   Mon,  7 Jun 2021 12:14:07 -0400
Message-Id: <20210607161410.3584036-26-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210607161410.3584036-1-sashal@kernel.org>
References: <20210607161410.3584036-1-sashal@kernel.org>
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
index 73c09b5864d7..bdeb169a7a99 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -4535,8 +4535,10 @@ static int rtnl_bridge_notify(struct net_device *dev)
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

