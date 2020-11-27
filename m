Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADF532C6882
	for <lists+netdev@lfdr.de>; Fri, 27 Nov 2020 16:14:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730045AbgK0PMY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Nov 2020 10:12:24 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:58189 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729113AbgK0PMY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Nov 2020 10:12:24 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from vladbu@nvidia.com)
        with SMTP; 27 Nov 2020 17:12:22 +0200
Received: from reg-r-vrt-018-180.mtr.labs.mlnx. (reg-r-vrt-018-180.mtr.labs.mlnx [10.215.1.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 0ARFCLbJ021792;
        Fri, 27 Nov 2020 17:12:21 +0200
From:   Vlad Buslov <vladbu@nvidia.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, Vlad Buslov <vladbu@nvidia.com>
Subject: [PATCH net-next] net: sched: remove redundant 'rtnl_held' argument
Date:   Fri, 27 Nov 2020 17:12:05 +0200
Message-Id: <20201127151205.23492-1-vladbu@nvidia.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Functions tfilter_notify_chain() and tcf_get_next_proto() are always called
with rtnl lock held in current implementation. Moreover, attempting to call
them without rtnl lock would cause a warning down the call chain in
function __tcf_get_next_proto() that requires the lock to be held by
callers. Remove the 'rtnl_held' argument in order to simplify the code and
make rtnl lock requirement explicit.

Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
---
 include/net/pkt_cls.h |  2 +-
 net/sched/cls_api.c   | 18 ++++++++----------
 net/sched/sch_api.c   |  4 ++--
 3 files changed, 11 insertions(+), 13 deletions(-)

diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h
index 133f9ad4d4f9..0f2a9c44171c 100644
--- a/include/net/pkt_cls.h
+++ b/include/net/pkt_cls.h
@@ -48,7 +48,7 @@ void tcf_chain_put_by_act(struct tcf_chain *chain);
 struct tcf_chain *tcf_get_next_chain(struct tcf_block *block,
 				     struct tcf_chain *chain);
 struct tcf_proto *tcf_get_next_proto(struct tcf_chain *chain,
-				     struct tcf_proto *tp, bool rtnl_held);
+				     struct tcf_proto *tp);
 void tcf_block_netif_keep_dst(struct tcf_block *block);
 int tcf_block_get(struct tcf_block **p_block,
 		  struct tcf_proto __rcu **p_filter_chain, struct Qdisc *q,
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index ff3e943febaa..37b77bd30974 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -991,13 +991,12 @@ __tcf_get_next_proto(struct tcf_chain *chain, struct tcf_proto *tp)
  */
 
 struct tcf_proto *
-tcf_get_next_proto(struct tcf_chain *chain, struct tcf_proto *tp,
-		   bool rtnl_held)
+tcf_get_next_proto(struct tcf_chain *chain, struct tcf_proto *tp)
 {
 	struct tcf_proto *tp_next = __tcf_get_next_proto(chain, tp);
 
 	if (tp)
-		tcf_proto_put(tp, rtnl_held, NULL);
+		tcf_proto_put(tp, true, NULL);
 
 	return tp_next;
 }
@@ -1924,15 +1923,14 @@ static int tfilter_del_notify(struct net *net, struct sk_buff *oskb,
 static void tfilter_notify_chain(struct net *net, struct sk_buff *oskb,
 				 struct tcf_block *block, struct Qdisc *q,
 				 u32 parent, struct nlmsghdr *n,
-				 struct tcf_chain *chain, int event,
-				 bool rtnl_held)
+				 struct tcf_chain *chain, int event)
 {
 	struct tcf_proto *tp;
 
-	for (tp = tcf_get_next_proto(chain, NULL, rtnl_held);
-	     tp; tp = tcf_get_next_proto(chain, tp, rtnl_held))
+	for (tp = tcf_get_next_proto(chain, NULL);
+	     tp; tp = tcf_get_next_proto(chain, tp))
 		tfilter_notify(net, oskb, n, tp, block,
-			       q, parent, NULL, event, false, rtnl_held);
+			       q, parent, NULL, event, false, true);
 }
 
 static void tfilter_put(struct tcf_proto *tp, void *fh)
@@ -2262,7 +2260,7 @@ static int tc_del_tfilter(struct sk_buff *skb, struct nlmsghdr *n,
 
 	if (prio == 0) {
 		tfilter_notify_chain(net, skb, block, q, parent, n,
-				     chain, RTM_DELTFILTER, rtnl_held);
+				     chain, RTM_DELTFILTER);
 		tcf_chain_flush(chain, rtnl_held);
 		err = 0;
 		goto errout;
@@ -2895,7 +2893,7 @@ static int tc_ctl_chain(struct sk_buff *skb, struct nlmsghdr *n,
 		break;
 	case RTM_DELCHAIN:
 		tfilter_notify_chain(net, skb, block, q, parent, n,
-				     chain, RTM_DELTFILTER, true);
+				     chain, RTM_DELTFILTER);
 		/* Flush the chain first as the user requested chain removal. */
 		tcf_chain_flush(chain, true);
 		/* In case the chain was successfully deleted, put a reference
diff --git a/net/sched/sch_api.c b/net/sched/sch_api.c
index 1a2d2471b078..51cb553e4317 100644
--- a/net/sched/sch_api.c
+++ b/net/sched/sch_api.c
@@ -1943,8 +1943,8 @@ static int tc_bind_class_walker(struct Qdisc *q, unsigned long cl,
 	     chain = tcf_get_next_chain(block, chain)) {
 		struct tcf_proto *tp;
 
-		for (tp = tcf_get_next_proto(chain, NULL, true);
-		     tp; tp = tcf_get_next_proto(chain, tp, true)) {
+		for (tp = tcf_get_next_proto(chain, NULL);
+		     tp; tp = tcf_get_next_proto(chain, tp)) {
 			struct tcf_bind_args arg = {};
 
 			arg.w.fn = tcf_node_bind;
-- 
2.21.0

