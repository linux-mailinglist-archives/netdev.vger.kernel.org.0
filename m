Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 065D036E2FE
	for <lists+netdev@lfdr.de>; Thu, 29 Apr 2021 03:32:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235332AbhD2Bd2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Apr 2021 21:33:28 -0400
Received: from out30-132.freemail.mail.aliyun.com ([115.124.30.132]:41643 "EHLO
        out30-132.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229888AbhD2Bd0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Apr 2021 21:33:26 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=yang.lee@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0UX6f0qb_1619659958;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:yang.lee@linux.alibaba.com fp:SMTPD_---0UX6f0qb_1619659958)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 29 Apr 2021 09:32:39 +0800
From:   Yang Li <yang.lee@linux.alibaba.com>
To:     davem@davemloft.net
Cc:     yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org,
        nathan@kernel.org, ndesaulniers@google.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com,
        Yang Li <yang.lee@linux.alibaba.com>
Subject: [PATCH] net: Remove redundant assignment to err
Date:   Thu, 29 Apr 2021 09:32:36 +0800
Message-Id: <1619659956-9635-1-git-send-email-yang.lee@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Variable 'err' is set to -ENOMEM but this value is never read as it is
overwritten with a new value later on, hence the 'If statements' and 
assignments are redundantand and can be removed.

Cleans up the following clang-analyzer warning:

net/ipv6/seg6.c:126:4: warning: Value stored to 'err' is never read
[clang-analyzer-deadcode.DeadStores]

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
---
 net/ipv6/seg6.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/net/ipv6/seg6.c b/net/ipv6/seg6.c
index d2f8138..e412817 100644
--- a/net/ipv6/seg6.c
+++ b/net/ipv6/seg6.c
@@ -122,9 +122,6 @@ static int seg6_genl_sethmac(struct sk_buff *skb, struct genl_info *info)
 	hinfo = seg6_hmac_info_lookup(net, hmackeyid);
 
 	if (!slen) {
-		if (!hinfo)
-			err = -ENOENT;
-
 		err = seg6_hmac_info_del(net, hmackeyid);
 
 		goto out_unlock;
-- 
1.8.3.1

