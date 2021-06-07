Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9730339E3CA
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 18:40:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233466AbhFGQ1t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 12:27:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:33386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233983AbhFGQZC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Jun 2021 12:25:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 11D0F61953;
        Mon,  7 Jun 2021 16:15:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623082560;
        bh=M1QyCXRvpSYSijtHHKzZN+F7q26OVf+B+7fL4VCMB3I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nO6n5VN9J4c5lFuveERIyJgzLpsZQG7OAEN5oSUGEvDJB+RfNeBxdCtk9PL0Rm5mN
         fgzv7OCb9jAE1OJ/Fr11ZOPyw9znFnwCfUyOZf38ot6jd6b+fhkmTzJbCXIblzhuTx
         bb4o9NYj8IXgJ9ZJsYc1kQtlCVXIMnfb7ONQtBDv8MjvERHAPyV99jOosaz9TTdw3F
         lmx2YtdvifOUeBFq9YNyYXke/8ZjiQodGLGRMoVbqAL/0TK/t8QxFC/HwTl6vqCXrQ
         6EfeaoRS1yadGIcguG99t9qCXGKrK7XpiiplmuSjfs36lAyFkXnBMQ8fdq8ebwoAfl
         AxKYCbVFajerQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 12/15] rtnetlink: Fix missing error code in rtnl_bridge_notify()
Date:   Mon,  7 Jun 2021 12:15:40 -0400
Message-Id: <20210607161543.3584778-12-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210607161543.3584778-1-sashal@kernel.org>
References: <20210607161543.3584778-1-sashal@kernel.org>
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
index e652e376fb30..93de31ca3d65 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -3530,8 +3530,10 @@ static int rtnl_bridge_notify(struct net_device *dev)
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

