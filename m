Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32E69398617
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 12:15:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231287AbhFBKRG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 06:17:06 -0400
Received: from out30-43.freemail.mail.aliyun.com ([115.124.30.43]:44556 "EHLO
        out30-43.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229826AbhFBKRA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Jun 2021 06:17:00 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R851e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=alimailimapcm10staff010182156082;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=15;SR=0;TI=SMTPD_---0Ub2Bs4M_1622628910;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0Ub2Bs4M_1622628910)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 02 Jun 2021 18:15:15 +0800
From:   Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        hawk@kernel.org, john.fastabend@gmail.com, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        kpsingh@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Subject: [PATCH] rtnetlink: Fix missing error code in rtnl_bridge_notify()
Date:   Wed,  2 Jun 2021 18:15:04 +0800
Message-Id: <1622628904-93532-1-git-send-email-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The error code is missing in this code scenario, add the error code
'-EINVAL' to the return value 'err'.

Eliminate the follow smatch warning:

net/core/rtnetlink.c:4834 rtnl_bridge_notify() warn: missing error code
'err'.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
 net/core/rtnetlink.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 714d5fa..3e84279 100644
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
1.8.3.1

