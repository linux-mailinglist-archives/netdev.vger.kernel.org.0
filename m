Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64B7E39E23C
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 18:16:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232208AbhFGQPz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 12:15:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:49460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231908AbhFGQPF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Jun 2021 12:15:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4344C613F3;
        Mon,  7 Jun 2021 16:13:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623082394;
        bh=YRi77UcDOJNead1RFidPUpOuVFKS6mzpqGTWMQ3J2q0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I5KWN1gnxhUgdtUENud1/iydVw+Y613tBqjMHggu1IiFpuLaD7Wy/yt4FZZQRatkv
         unOkGXzRxiHucq2nkY3UrYQokseFEm6yaPPb3F5fQCqRgwOf4px9OXXMNkk6JA2oP0
         LOxw6V46jqOmK11ZVcGiwbQNgXtgoByFbGEvd4FiAzffRRKXOCMl8igHwMgLKa6teM
         FZ75s1aI+B0z7fJ+0Svuu9PMrbTI8FZ7ypJaWwo5HuQH2WbA7ZaJjmQz3uaPgoU+1F
         r/TA3WGe4HGGPHXSNdZzEbHAYRst03IdSJg1vORX8RNMX+RgMaeEB5Isd+OKrodZld
         DjM5E6Wa0tIcQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 46/49] rtnetlink: Fix missing error code in rtnl_bridge_notify()
Date:   Mon,  7 Jun 2021 12:12:12 -0400
Message-Id: <20210607161215.3583176-46-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210607161215.3583176-1-sashal@kernel.org>
References: <20210607161215.3583176-1-sashal@kernel.org>
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
index 3485b16a7ff3..9ad046917b34 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -4833,8 +4833,10 @@ static int rtnl_bridge_notify(struct net_device *dev)
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

