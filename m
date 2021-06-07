Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5A4C39E36C
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 18:39:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233236AbhFGQXr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 12:23:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:33900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233234AbhFGQVs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Jun 2021 12:21:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7C4D06191F;
        Mon,  7 Jun 2021 16:15:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623082512;
        bh=hr2/c60Q5FWoGRk9+/fstlgyxlH/GO5PPiTTaHnAlFA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B7cIlcFKbVVVHB6vN5OBQAqS9OMC/DbPDcdPdX5sZTf0M4k9DnpyjRvEcuqZA1YT0
         X7bN0UI8vE3GGCY/UMDXAQVny5XWi+tnP68ufLL1nywFBn9NYVC5veoAfcQ0LMrSCf
         OMljvfe+fUUjZYcTLg7P8sldIaWXeazp+uPKgzusAh0rHmvJGp8hoTmjz16QnPTGCD
         qlubF9EHGwnB1j4wsUwy6wynGTydXdVPke/DghMYufVr43PsgyKzu9I6UTtTw6gaGd
         FTlojyPnNo/NXZxeekpRAmSqCDwTsRMa6CIfswFIboBrr8tf2NpGNNn70hv90b9dm6
         ZeugIcQDOPaqQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 18/21] rtnetlink: Fix missing error code in rtnl_bridge_notify()
Date:   Mon,  7 Jun 2021 12:14:45 -0400
Message-Id: <20210607161448.3584332-18-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210607161448.3584332-1-sashal@kernel.org>
References: <20210607161448.3584332-1-sashal@kernel.org>
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
index 935053ee7765..7f2dda27f9e7 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -4102,8 +4102,10 @@ static int rtnl_bridge_notify(struct net_device *dev)
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

