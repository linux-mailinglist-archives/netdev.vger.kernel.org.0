Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49D8739E3E8
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 18:40:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233441AbhFGQ2T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 12:28:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:60368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234152AbhFGQZ0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Jun 2021 12:25:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 67F0B61960;
        Mon,  7 Jun 2021 16:16:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623082580;
        bh=HVjKU5j5ADRcQuZap9hsVaBsfM9OKQPMVLRn/zeOQCU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VAgaTNCo49Hf2hG3260QJSt2fPEp2QTMuE2heHduUdJf17moW9Hq+cPxMxc8xXXhu
         4SYW1FDOr7u07F05CmdNcU6XVGKfcZGd795yw4NA2JcUtpj3Lj8vEUSRt9NnthnPZy
         G+1KZ6/qsfSMGXnUwVi/55SjrKJ4zowa+6FCduKLS9PcahtJ74F1WSPNUEYmsfMyqx
         1+zHvKE7PIX9tCp9AhOLnugwPKTv9b7qNPpFTpC0kaRLu9vOGMFcTmcAuv55S53/kY
         Cy7EYmjj/9sWaH+7OJbqGesgelDO54MY6UKOFRPsLmA2xB/uek334l/9Je4EJNZjR2
         iCMF7/SUqKC6Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 11/14] rtnetlink: Fix missing error code in rtnl_bridge_notify()
Date:   Mon,  7 Jun 2021 12:16:02 -0400
Message-Id: <20210607161605.3584954-11-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210607161605.3584954-1-sashal@kernel.org>
References: <20210607161605.3584954-1-sashal@kernel.org>
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
index e2a0aed52983..11d2da8abd73 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -3240,8 +3240,10 @@ static int rtnl_bridge_notify(struct net_device *dev)
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

