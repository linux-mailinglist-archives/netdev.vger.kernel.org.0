Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C7A219F8FB
	for <lists+netdev@lfdr.de>; Mon,  6 Apr 2020 17:37:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728940AbgDFPhS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Apr 2020 11:37:18 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:60280 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728777AbgDFPhS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Apr 2020 11:37:18 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from paulb@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 6 Apr 2020 18:37:09 +0300
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (reg-r-vrt-019-180.mtr.labs.mlnx [10.213.19.180])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 036Fb9IH025336;
        Mon, 6 Apr 2020 18:37:09 +0300
From:   Paul Blakey <paulb@mellanox.com>
To:     Paul Blakey <paulb@mellanox.com>, Oz Shlomo <ozsh@mellanox.com>,
        Roi Dayan <roid@mellanox.com>, netdev@vger.kernel.org,
        Jiri Pirko <jiri@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net] net: sched: Fix setting last executed chain on skb extension
Date:   Mon,  6 Apr 2020 18:36:56 +0300
Message-Id: <1586187416-22454-1-git-send-email-paulb@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After driver sets the missed chain on the tc skb extension it is
consumed (deleted) by tc_classify_ingress and tc jumps to that chain.
If tc now misses on this chain (either no match, or no goto action),
then last executed chain remains 0, and the skb extension is not re-added,
and the next datapath (ovs) will start from 0.

Fix that by setting last executed chain to the chain read from the skb
extension, so if there is a miss, we set it back.

Fixes: af699626ee26 ("net: sched: Support specifying a starting chain via tc skb ext")
Reviewed-by: Oz Shlomo <ozsh@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Paul Blakey <paulb@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 net/sched/cls_api.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index f6a3b96..55bd142 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -1667,6 +1667,7 @@ int tcf_classify_ingress(struct sk_buff *skb,
 		skb_ext_del(skb, TC_SKB_EXT);
 
 		tp = rcu_dereference_bh(fchain->filter_chain);
+		last_executed_chain = fchain->index;
 	}
 
 	ret = __tcf_classify(skb, tp, orig_tp, res, compat_mode,
-- 
1.8.3.1

