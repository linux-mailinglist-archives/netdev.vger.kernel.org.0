Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCDC33C70BE
	for <lists+netdev@lfdr.de>; Tue, 13 Jul 2021 14:53:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236242AbhGMM4b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Jul 2021 08:56:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236164AbhGMM4a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Jul 2021 08:56:30 -0400
Received: from out1.migadu.com (out1.migadu.com [IPv6:2001:41d0:2:863f::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D70AC0613DD;
        Tue, 13 Jul 2021 05:53:40 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1626180817;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=7LjZkWC74fDIMPYNeGmPc/K5Xi038BMB6L+xT27MYqE=;
        b=w8iSkPr5eesyu4f5GGaFk/2JEkyviH25L+GHL43w+G3PjuvuMdfz3HKCe25FLfngxXJRSI
        qWxM9BT/SKTFX4v4n+WhWqcY7g/CL1pwqOiWtJLxDRzcWzVykion7/nv/MxFWOuwrazxdy
        6OUgw9PwkKcr6nuGaDTaf/WAMEvV80k=
From:   Yajun Deng <yajun.deng@linux.dev>
To:     davem@davemloft.net, kuba@kernel.org, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, yajun.deng@linux.dev,
        johannes.berg@intel.com, ryazanov.s.a@gmail.com, avagin@gmail.com,
        vladimir.oltean@nxp.com, roopa@cumulusnetworks.com,
        zhudi21@huawei.com
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 2/2] net/sched: Remove unnecessary judgment statements
Date:   Tue, 13 Jul 2021 20:53:18 +0800
Message-Id: <20210713125318.2682-1-yajun.deng@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: yajun.deng@linux.dev
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It has been deal with the 'if (err' statement in rtnl_{send, unicast},
so use rtnl_{send, unicast} instead of netlink_{send, unicast}.

Signed-off-by: Yajun Deng <yajun.deng@linux.dev>
---
 net/sched/act_api.c | 20 ++++++--------------
 net/sched/cls_api.c | 28 +++++++++++-----------------
 net/sched/sch_api.c | 18 ++++++------------
 3 files changed, 23 insertions(+), 43 deletions(-)

diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index d17a66aab8ee..96fc6f3d080a 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -1349,10 +1349,8 @@ static int tca_action_flush(struct net *net, struct nlattr *nla,
 	nlh->nlmsg_len = skb_tail_pointer(skb) - b;
 	nlh->nlmsg_flags |= NLM_F_ROOT;
 	module_put(ops->owner);
-	err = rtnetlink_send(skb, net, portid, RTNLGRP_TC,
-			     n->nlmsg_flags & NLM_F_ECHO);
-	if (err > 0)
-		return 0;
+	err = rtnl_send(skb, net, portid, RTNLGRP_TC,
+			n->nlmsg_flags & NLM_F_ECHO);
 	if (err < 0)
 		NL_SET_ERR_MSG(extack, "Failed to send TC action flush notification");
 
@@ -1421,10 +1419,8 @@ tcf_del_notify(struct net *net, struct nlmsghdr *n, struct tc_action *actions[],
 		return ret;
 	}
 
-	ret = rtnetlink_send(skb, net, portid, RTNLGRP_TC,
-			     n->nlmsg_flags & NLM_F_ECHO);
-	if (ret > 0)
-		return 0;
+	ret = rtnl_send(skb, net, portid, RTNLGRP_TC,
+			n->nlmsg_flags & NLM_F_ECHO);
 	return ret;
 }
 
@@ -1481,7 +1477,6 @@ tcf_add_notify(struct net *net, struct nlmsghdr *n, struct tc_action *actions[],
 	       u32 portid, size_t attr_size, struct netlink_ext_ack *extack)
 {
 	struct sk_buff *skb;
-	int err = 0;
 
 	skb = alloc_skb(attr_size <= NLMSG_GOODSIZE ? NLMSG_GOODSIZE : attr_size,
 			GFP_KERNEL);
@@ -1495,11 +1490,8 @@ tcf_add_notify(struct net *net, struct nlmsghdr *n, struct tc_action *actions[],
 		return -EINVAL;
 	}
 
-	err = rtnetlink_send(skb, net, portid, RTNLGRP_TC,
-			     n->nlmsg_flags & NLM_F_ECHO);
-	if (err > 0)
-		err = 0;
-	return err;
+	return rtnl_send(skb, net, portid, RTNLGRP_TC,
+			 n->nlmsg_flags & NLM_F_ECHO);
 }
 
 static int tcf_action_add(struct net *net, struct nlattr *nla,
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index d73b5c5514a9..bbf1bd028e7c 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -1870,13 +1870,11 @@ static int tfilter_notify(struct net *net, struct sk_buff *oskb,
 	}
 
 	if (unicast)
-		err = netlink_unicast(net->rtnl, skb, portid, MSG_DONTWAIT);
+		err = rtnl_unicast(skb, net, portid);
 	else
-		err = rtnetlink_send(skb, net, portid, RTNLGRP_TC,
-				     n->nlmsg_flags & NLM_F_ECHO);
+		err = rtnl_send(skb, net, portid, RTNLGRP_TC,
+				n->nlmsg_flags & NLM_F_ECHO);
 
-	if (err > 0)
-		err = 0;
 	return err;
 }
 
@@ -1909,15 +1907,13 @@ static int tfilter_del_notify(struct net *net, struct sk_buff *oskb,
 	}
 
 	if (unicast)
-		err = netlink_unicast(net->rtnl, skb, portid, MSG_DONTWAIT);
+		err = rtnl_unicast(skb, net, portid);
 	else
-		err = rtnetlink_send(skb, net, portid, RTNLGRP_TC,
-				     n->nlmsg_flags & NLM_F_ECHO);
+		err = rtnl_send(skb, net, portid, RTNLGRP_TC,
+				n->nlmsg_flags & NLM_F_ECHO);
 	if (err < 0)
 		NL_SET_ERR_MSG(extack, "Failed to send filter delete notification");
 
-	if (err > 0)
-		err = 0;
 	return err;
 }
 
@@ -2711,13 +2707,11 @@ static int tc_chain_notify(struct tcf_chain *chain, struct sk_buff *oskb,
 	}
 
 	if (unicast)
-		err = netlink_unicast(net->rtnl, skb, portid, MSG_DONTWAIT);
+		err = rtnl_unicast(skb, net, portid);
 	else
-		err = rtnetlink_send(skb, net, portid, RTNLGRP_TC,
-				     flags & NLM_F_ECHO);
+		err = rtnl_send(skb, net, portid, RTNLGRP_TC,
+				flags & NLM_F_ECHO);
 
-	if (err > 0)
-		err = 0;
 	return err;
 }
 
@@ -2741,9 +2735,9 @@ static int tc_chain_notify_delete(const struct tcf_proto_ops *tmplt_ops,
 	}
 
 	if (unicast)
-		return netlink_unicast(net->rtnl, skb, portid, MSG_DONTWAIT);
+		return rtnl_unicast(skb, net, portid);
 
-	return rtnetlink_send(skb, net, portid, RTNLGRP_TC, flags & NLM_F_ECHO);
+	return rtnl_send(skb, net, portid, RTNLGRP_TC, flags & NLM_F_ECHO);
 }
 
 static int tc_chain_tmplt_add(struct tcf_chain *chain, struct net *net,
diff --git a/net/sched/sch_api.c b/net/sched/sch_api.c
index f87d07736a14..aaec80a047d6 100644
--- a/net/sched/sch_api.c
+++ b/net/sched/sch_api.c
@@ -987,8 +987,8 @@ static int qdisc_notify(struct net *net, struct sk_buff *oskb,
 	}
 
 	if (skb->len)
-		return rtnetlink_send(skb, net, portid, RTNLGRP_TC,
-				      n->nlmsg_flags & NLM_F_ECHO);
+		return rtnl_send(skb, net, portid, RTNLGRP_TC,
+				 n->nlmsg_flags & NLM_F_ECHO);
 
 err_out:
 	kfree_skb(skb);
@@ -1845,7 +1845,6 @@ static int tclass_notify(struct net *net, struct sk_buff *oskb,
 {
 	struct sk_buff *skb;
 	u32 portid = oskb ? NETLINK_CB(oskb).portid : 0;
-	int err = 0;
 
 	skb = alloc_skb(NLMSG_GOODSIZE, GFP_KERNEL);
 	if (!skb)
@@ -1856,11 +1855,8 @@ static int tclass_notify(struct net *net, struct sk_buff *oskb,
 		return -EINVAL;
 	}
 
-	err = rtnetlink_send(skb, net, portid, RTNLGRP_TC,
-			     n->nlmsg_flags & NLM_F_ECHO);
-	if (err > 0)
-		err = 0;
-	return err;
+	return rtnl_send(skb, net, portid, RTNLGRP_TC,
+			 n->nlmsg_flags & NLM_F_ECHO);
 }
 
 static int tclass_del_notify(struct net *net,
@@ -1892,10 +1888,8 @@ static int tclass_del_notify(struct net *net,
 		return err;
 	}
 
-	err = rtnetlink_send(skb, net, portid, RTNLGRP_TC,
-			     n->nlmsg_flags & NLM_F_ECHO);
-	if (err > 0)
-		err = 0;
+	err = rtnl_send(skb, net, portid, RTNLGRP_TC,
+			n->nlmsg_flags & NLM_F_ECHO);
 	return err;
 }
 
-- 
2.32.0

