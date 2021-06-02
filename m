Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9DD7398FB4
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 18:09:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229956AbhFBQLl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 12:11:41 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:25612 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229607AbhFBQLk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Jun 2021 12:11:40 -0400
Received: from localhost (scalar.blr.asicdesigners.com [10.193.185.94])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 152G9o5u005218;
        Wed, 2 Jun 2021 09:09:51 -0700
From:   Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, rajur@chelsio.com
Subject: [PATCH net] cxgb4: fix regression with HASH tc prio value update
Date:   Wed,  2 Jun 2021 19:38:59 +0530
Message-Id: <1622642939-21710-1-git-send-email-rahul.lakkireddy@chelsio.com>
X-Mailer: git-send-email 2.5.3
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

commit db43b30cd89c ("cxgb4: add ethtool n-tuple filter deletion")
has moved searching for next highest priority HASH filter rule to
cxgb4_flow_rule_destroy(), which searches the rhashtable before the
the rule is removed from it and hence always finds at least 1 entry.
Fix by removing the rule from rhashtable first before calling
cxgb4_flow_rule_destroy() and hence avoid fetching stale info.

Fixes: db43b30cd89c ("cxgb4: add ethtool n-tuple filter deletion")
Signed-off-by: Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
---
 .../net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c   | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c
index 1b88bd1c2dbe..dd9be229819a 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c
@@ -997,20 +997,16 @@ int cxgb4_tc_flower_destroy(struct net_device *dev,
 	if (!ch_flower)
 		return -ENOENT;
 
+	rhashtable_remove_fast(&adap->flower_tbl, &ch_flower->node,
+			       adap->flower_ht_params);
+
 	ret = cxgb4_flow_rule_destroy(dev, ch_flower->fs.tc_prio,
 				      &ch_flower->fs, ch_flower->filter_id);
 	if (ret)
-		goto err;
+		netdev_err(dev, "Flow rule destroy failed for tid: %u, ret: %d",
+			   ch_flower->filter_id, ret);
 
-	ret = rhashtable_remove_fast(&adap->flower_tbl, &ch_flower->node,
-				     adap->flower_ht_params);
-	if (ret) {
-		netdev_err(dev, "Flow remove from rhashtable failed");
-		goto err;
-	}
 	kfree_rcu(ch_flower, rcu);
-
-err:
 	return ret;
 }
 
-- 
2.27.0

