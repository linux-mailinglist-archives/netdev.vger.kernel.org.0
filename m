Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51166302081
	for <lists+netdev@lfdr.de>; Mon, 25 Jan 2021 03:41:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726655AbhAYCke (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jan 2021 21:40:34 -0500
Received: from out30-42.freemail.mail.aliyun.com ([115.124.30.42]:45435 "EHLO
        out30-42.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726261AbhAYCk3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Jan 2021 21:40:29 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=abaci-bugfix@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0UMkOXxA_1611542382;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:abaci-bugfix@linux.alibaba.com fp:SMTPD_---0UMkOXxA_1611542382)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 25 Jan 2021 10:39:46 +0800
From:   Jiapeng Zhong <abaci-bugfix@linux.alibaba.com>
To:     roopa@nvidia.com
Cc:     nikolay@nvidia.com, davem@davemloft.net, kuba@kernel.org,
        natechancellor@gmail.com, ndesaulniers@google.com,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com,
        Jiapeng Zhong <abaci-bugfix@linux.alibaba.com>
Subject: [PATCH] bridge: Use PTR_ERR_OR_ZERO instead if(IS_ERR(...)) + PTR_ERR
Date:   Mon, 25 Jan 2021 10:39:41 +0800
Message-Id: <1611542381-91178-1-git-send-email-abaci-bugfix@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

coccicheck suggested using PTR_ERR_OR_ZERO() and looking at the code.

Fix the following coccicheck warnings:

./net/bridge/br_multicast.c:1295:7-13: WARNING: PTR_ERR_OR_ZERO can be
used.

Reported-by: Abaci <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Zhong <abaci-bugfix@linux.alibaba.com>
---
 net/bridge/br_multicast.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index 257ac4e..2229d10 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -1292,7 +1292,7 @@ static int br_multicast_add_group(struct net_bridge *br,
 	pg = __br_multicast_add_group(br, port, group, src, filter_mode,
 				      igmpv2_mldv1, false);
 	/* NULL is considered valid for host joined groups */
-	err = IS_ERR(pg) ? PTR_ERR(pg) : 0;
+	err = PTR_ERR_OR_ZERO(pg);
 	spin_unlock(&br->multicast_lock);
 
 	return err;
-- 
1.8.3.1

