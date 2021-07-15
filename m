Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC7E63C9E8B
	for <lists+netdev@lfdr.de>; Thu, 15 Jul 2021 14:24:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237063AbhGOM1j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Jul 2021 08:27:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236901AbhGOM1i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Jul 2021 08:27:38 -0400
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05359C06175F;
        Thu, 15 Jul 2021 05:24:45 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1626351883;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=bLnC6D7WqAiEHTjNk6+Eut4EG3WR1cDV6217ErNEGBg=;
        b=YV5BtMWbHMS+cd5U0JRSS/eDnEztG59jleqjHcgfeHZaJu007N1redR6n3kKa8hjFeWN6h
        fgy8apEyrtLTvRjsYt5UlUYcH++dmMdDD6FRTmRgnGQfX0eiTFdCF+BKIjICMQjhFbR1zS
        olYj7NKb5v7lqePvzxuuOzl9mvn1ovw=
From:   Yajun Deng <yajun.deng@linux.dev>
To:     davem@davemloft.net, kuba@kernel.org, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us,
        johannes.berg@intel.com, avagin@gmail.com, ryazanov.s.a@gmail.com,
        vladimir.oltean@nxp.com, roopa@cumulusnetworks.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yajun Deng <yajun.deng@linux.dev>
Subject: [PATCH v2 2/2] net/sched: Remove unnecessary if statement
Date:   Thu, 15 Jul 2021 20:24:24 +0800
Message-Id: <20210715122424.19809-1-yajun.deng@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: yajun.deng@linux.dev
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It has been deal with the 'if (err' statement in rtnetlink_send()
and rtnl_unicast(). so remove unnecessary if statement.

v2: use the raw name rtnetlink_send().

Signed-off-by: Yajun Deng <yajun.deng@linux.dev>
---
 net/sched/act_api.c | 12 ++----------
 net/sched/cls_api.c | 15 ++++-----------
 net/sched/sch_api.c | 10 ++--------
 3 files changed, 8 insertions(+), 29 deletions(-)

diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index d17a66aab8ee..998a2374f7ae 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -1351,8 +1351,6 @@ static int tca_action_flush(struct net *net, struct nlattr *nla,
 	module_put(ops->owner);
 	err = rtnetlink_send(skb, net, portid, RTNLGRP_TC,
 			     n->nlmsg_flags & NLM_F_ECHO);
-	if (err > 0)
-		return 0;
 	if (err < 0)
 		NL_SET_ERR_MSG(extack, "Failed to send TC action flush notification");
 
@@ -1423,8 +1421,6 @@ tcf_del_notify(struct net *net, struct nlmsghdr *n, struct tc_action *actions[],
 
 	ret = rtnetlink_send(skb, net, portid, RTNLGRP_TC,
 			     n->nlmsg_flags & NLM_F_ECHO);
-	if (ret > 0)
-		return 0;
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
+	return rtnetlink_send(skb, net, portid, RTNLGRP_TC,
+			      n->nlmsg_flags & NLM_F_ECHO);
 }
 
 static int tcf_action_add(struct net *net, struct nlattr *nla,
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index d73b5c5514a9..c8cb59a11098 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -1870,13 +1870,10 @@ static int tfilter_notify(struct net *net, struct sk_buff *oskb,
 	}
 
 	if (unicast)
-		err = netlink_unicast(net->rtnl, skb, portid, MSG_DONTWAIT);
+		err = rtnl_unicast(skb, net, portid);
 	else
 		err = rtnetlink_send(skb, net, portid, RTNLGRP_TC,
 				     n->nlmsg_flags & NLM_F_ECHO);
-
-	if (err > 0)
-		err = 0;
 	return err;
 }
 
@@ -1909,15 +1906,13 @@ static int tfilter_del_notify(struct net *net, struct sk_buff *oskb,
 	}
 
 	if (unicast)
-		err = netlink_unicast(net->rtnl, skb, portid, MSG_DONTWAIT);
+		err = rtnl_unicast(skb, net, portid);
 	else
 		err = rtnetlink_send(skb, net, portid, RTNLGRP_TC,
 				     n->nlmsg_flags & NLM_F_ECHO);
 	if (err < 0)
 		NL_SET_ERR_MSG(extack, "Failed to send filter delete notification");
 
-	if (err > 0)
-		err = 0;
 	return err;
 }
 
@@ -2711,13 +2706,11 @@ static int tc_chain_notify(struct tcf_chain *chain, struct sk_buff *oskb,
 	}
 
 	if (unicast)
-		err = netlink_unicast(net->rtnl, skb, portid, MSG_DONTWAIT);
+		err = rtnl_unicast(skb, net, portid);
 	else
 		err = rtnetlink_send(skb, net, portid, RTNLGRP_TC,
 				     flags & NLM_F_ECHO);
 
-	if (err > 0)
-		err = 0;
 	return err;
 }
 
@@ -2741,7 +2734,7 @@ static int tc_chain_notify_delete(const struct tcf_proto_ops *tmplt_ops,
 	}
 
 	if (unicast)
-		return netlink_unicast(net->rtnl, skb, portid, MSG_DONTWAIT);
+		return rtnl_unicast(skb, net, portid);
 
 	return rtnetlink_send(skb, net, portid, RTNLGRP_TC, flags & NLM_F_ECHO);
 }
diff --git a/net/sched/sch_api.c b/net/sched/sch_api.c
index f87d07736a14..5e90e9b160e3 100644
--- a/net/sched/sch_api.c
+++ b/net/sched/sch_api.c
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
+	return rtnetlink_send(skb, net, portid, RTNLGRP_TC,
+			      n->nlmsg_flags & NLM_F_ECHO);
 }
 
 static int tclass_del_notify(struct net *net,
@@ -1894,8 +1890,6 @@ static int tclass_del_notify(struct net *net,
 
 	err = rtnetlink_send(skb, net, portid, RTNLGRP_TC,
 			     n->nlmsg_flags & NLM_F_ECHO);
-	if (err > 0)
-		err = 0;
 	return err;
 }
 
-- 
2.32.0

