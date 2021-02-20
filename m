Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5861E32037B
	for <lists+netdev@lfdr.de>; Sat, 20 Feb 2021 04:20:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229925AbhBTDTP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Feb 2021 22:19:15 -0500
Received: from out30-131.freemail.mail.aliyun.com ([115.124.30.131]:57411 "EHLO
        out30-131.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229745AbhBTDTI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Feb 2021 22:19:08 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R321e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=yang.lee@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0UP.D3-J_1613791104;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:yang.lee@linux.alibaba.com fp:SMTPD_---0UP.D3-J_1613791104)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sat, 20 Feb 2021 11:18:25 +0800
From:   Yang Li <yang.lee@linux.alibaba.com>
To:     steffen.klassert@secunet.com
Cc:     herbert@gondor.apana.org.au, davem@davemloft.net, kuba@kernel.org,
        fw@strlen.de, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yang Li <yang.lee@linux.alibaba.com>
Subject: [PATCH v2] xfrm: Fix incorrect types in assignment
Date:   Sat, 20 Feb 2021 11:18:23 +0800
Message-Id: <1613791103-127057-1-git-send-email-yang.lee@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the following sparse warnings:
net/xfrm/xfrm_policy.c:1303:22: warning: incorrect type in assignment
(different address spaces)

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
---
 net/xfrm/xfrm_policy.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index b74f28c..aac5e88 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -1300,7 +1300,8 @@ static void xfrm_hash_rebuild(struct work_struct *work)
 		}
 
 		hmask = net->xfrm.policy_bydst[dir].hmask;
-		odst = net->xfrm.policy_bydst[dir].table;
+		odst = rcu_dereference_protected(net->xfrm.policy_bydst[dir].table,
+						 lockdep_is_held(&net->xfrm.xfrm_policy_lock));
 		for (i = hmask; i >= 0; i--) {
 			hlist_for_each_entry_safe(policy, n, odst + i, bydst)
 				hlist_del_rcu(&policy->bydst);
-- 
1.8.3.1

