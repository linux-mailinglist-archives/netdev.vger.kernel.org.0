Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF18336A6B5
	for <lists+netdev@lfdr.de>; Sun, 25 Apr 2021 12:35:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229889AbhDYKgM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Apr 2021 06:36:12 -0400
Received: from out30-57.freemail.mail.aliyun.com ([115.124.30.57]:48599 "EHLO
        out30-57.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229466AbhDYKgI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Apr 2021 06:36:08 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0UWgTzAH_1619346920;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0UWgTzAH_1619346920)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sun, 25 Apr 2021 18:35:27 +0800
From:   Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To:     pcnet32@frontier.com
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Subject: [PATCH] pcnet32: Remove redundant variable prev_link and curr_link
Date:   Sun, 25 Apr 2021 18:35:18 +0800
Message-Id: <1619346918-49035-1-git-send-email-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Variable prev_link and curr_link is being assigned a value from a
calculation however the variable is never read, so this redundant
variable can be removed.

Cleans up the following clang-analyzer warning:

drivers/net/ethernet/amd/pcnet32.c:2857:4: warning: Value stored to
'prev_link' is never read [clang-analyzer-deadcode.DeadStores].

drivers/net/ethernet/amd/pcnet32.c:2856:4: warning: Value stored to
'curr_link' is never read [clang-analyzer-deadcode.DeadStores].

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
 drivers/net/ethernet/amd/pcnet32.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/amd/pcnet32.c b/drivers/net/ethernet/amd/pcnet32.c
index f78daba..aa41250 100644
--- a/drivers/net/ethernet/amd/pcnet32.c
+++ b/drivers/net/ethernet/amd/pcnet32.c
@@ -2853,8 +2853,7 @@ static void pcnet32_check_media(struct net_device *dev, int verbose)
 			netif_info(lp, link, dev, "link down\n");
 		}
 		if (lp->phycount > 1) {
-			curr_link = pcnet32_check_otherphy(dev);
-			prev_link = 0;
+			pcnet32_check_otherphy(dev);
 		}
 	} else if (verbose || !prev_link) {
 		netif_carrier_on(dev);
-- 
1.8.3.1

