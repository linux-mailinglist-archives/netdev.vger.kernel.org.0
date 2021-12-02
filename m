Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C169B465F89
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 09:34:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240957AbhLBIhb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 03:37:31 -0500
Received: from out30-130.freemail.mail.aliyun.com ([115.124.30.130]:53477 "EHLO
        out30-130.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230404AbhLBIha (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 03:37:30 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0Uz9Y2pc_1638434043;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0Uz9Y2pc_1638434043)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 02 Dec 2021 16:34:06 +0800
From:   Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Subject: [PATCH] net: mpls: use kmemdup() to replace kmalloc + memcpy
Date:   Thu,  2 Dec 2021 16:33:57 +0800
Message-Id: <1638434037-44171-1-git-send-email-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Eliminate the follow coccicheck warning:

./net/mpls/af_mpls.c:1530:9-16: WARNING opportunity for kmemdup.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
 net/mpls/af_mpls.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/mpls/af_mpls.c b/net/mpls/af_mpls.c
index 48f75a5..38c8a1f 100644
--- a/net/mpls/af_mpls.c
+++ b/net/mpls/af_mpls.c
@@ -1527,10 +1527,9 @@ static int mpls_ifdown(struct net_device *dev, int event)
 					rt->rt_nh_size;
 				struct mpls_route *orig = rt;
 
-				rt = kmalloc(size, GFP_KERNEL);
+				rt = kmemdup(orig, size, GFP_KERNEL);
 				if (!rt)
 					return -ENOMEM;
-				memcpy(rt, orig, size);
 			}
 		}
 
-- 
1.8.3.1

