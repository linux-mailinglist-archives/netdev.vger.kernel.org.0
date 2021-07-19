Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C4503CD518
	for <lists+netdev@lfdr.de>; Mon, 19 Jul 2021 14:48:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237107AbhGSMHU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 08:07:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237057AbhGSMHT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Jul 2021 08:07:19 -0400
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB387C061574;
        Mon, 19 Jul 2021 05:05:54 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1626698877;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=2tHvku8/g1vkYpeP7udTvdw5L1jmMz/OXu2RwKUP18o=;
        b=WjML7vTV2lCITQaTXT1VELh5eJuS93yUQPdbWmV4RjF5O9u+X4/JTIcxoATJxFQ8/f8UFs
        1KsAc4LtIKvASLeVuS0p/U2qJVmPavIbB5iLxcBtKI0RDRgS9NMRmmkajtNUjQC+WS547z
        E9C+j/PL6XeorD7aBOSmgUCfzFiGbLM=
From:   Yajun Deng <yajun.deng@linux.dev>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-decnet-user@lists.sourceforge.net
Cc:     Yajun Deng <yajun.deng@linux.dev>
Subject: [PATCH 4/4] net/sched: use rtnl_notify() instead of rtnetlink_send()
Date:   Mon, 19 Jul 2021 20:47:43 +0800
Message-Id: <20210719124743.9076-1-yajun.deng@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: yajun.deng@linux.dev
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The rtnetlink_send() is already removed. use rtnl_notify() instead.

Signed-off-by: Yajun Deng <yajun.deng@linux.dev>
---
 net/sched/act_api.c | 13 ++++++-------
 net/sched/cls_api.c | 14 +++++++-------
 net/sched/sch_api.c | 13 ++++++-------
 3 files changed, 19 insertions(+), 21 deletions(-)

diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index 998a2374f7ae..d25678b1ebec 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -1349,8 +1349,8 @@ static int tca_action_flush(struct net *net, struct nlattr *nla,
 	nlh->nlmsg_len = skb_tail_pointer(skb) - b;
 	nlh->nlmsg_flags |= NLM_F_ROOT;
 	module_put(ops->owner);
-	err = rtnetlink_send(skb, net, portid, RTNLGRP_TC,
-			     n->nlmsg_flags & NLM_F_ECHO);
+	err = rtnl_notify(skb, net, portid, RTNLGRP_TC,
+			  nlmsg_report(n), GFP_KERNEL);
 	if (err < 0)
 		NL_SET_ERR_MSG(extack, "Failed to send TC action flush notification");
 
@@ -1419,9 +1419,8 @@ tcf_del_notify(struct net *net, struct nlmsghdr *n, struct tc_action *actions[],
 		return ret;
 	}
 
-	ret = rtnetlink_send(skb, net, portid, RTNLGRP_TC,
-			     n->nlmsg_flags & NLM_F_ECHO);
-	return ret;
+	return rtnl_notify(skb, net, portid, RTNLGRP_TC,
+			   nlmsg_report(n), GFP_KERNEL);
 }
 
 static int
@@ -1490,8 +1489,8 @@ tcf_add_notify(struct net *net, struct nlmsghdr *n, struct tc_action *actions[],
 		return -EINVAL;
 	}
 
-	return rtnetlink_send(skb, net, portid, RTNLGRP_TC,
-			      n->nlmsg_flags & NLM_F_ECHO);
+	return rtnl_notify(skb, net, portid, RTNLGRP_TC,
+			   nlmsg_report(n), GFP_KERNEL);
 }
 
 static int tcf_action_add(struct net *net, struct nlattr *nla,
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index c8cb59a11098..63ca7afc472d 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -1872,8 +1872,8 @@ static int tfilter_notify(struct net *net, struct sk_buff *oskb,
 	if (unicast)
 		err = rtnl_unicast(skb, net, portid);
 	else
-		err = rtnetlink_send(skb, net, portid, RTNLGRP_TC,
-				     n->nlmsg_flags & NLM_F_ECHO);
+		err = rtnl_notify(skb, net, portid, RTNLGRP_TC,
+				  nlmsg_report(n), GFP_KERNEL);
 	return err;
 }
 
@@ -1908,8 +1908,8 @@ static int tfilter_del_notify(struct net *net, struct sk_buff *oskb,
 	if (unicast)
 		err = rtnl_unicast(skb, net, portid);
 	else
-		err = rtnetlink_send(skb, net, portid, RTNLGRP_TC,
-				     n->nlmsg_flags & NLM_F_ECHO);
+		err = rtnl_notify(skb, net, portid, RTNLGRP_TC,
+				  nlmsg_report(n), GFP_KERNEL);
 	if (err < 0)
 		NL_SET_ERR_MSG(extack, "Failed to send filter delete notification");
 
@@ -2708,8 +2708,8 @@ static int tc_chain_notify(struct tcf_chain *chain, struct sk_buff *oskb,
 	if (unicast)
 		err = rtnl_unicast(skb, net, portid);
 	else
-		err = rtnetlink_send(skb, net, portid, RTNLGRP_TC,
-				     flags & NLM_F_ECHO);
+		err = rtnl_notify(skb, net, portid, RTNLGRP_TC,
+				  flags & NLM_F_ECHO, GFP_KERNEL);
 
 	return err;
 }
@@ -2736,7 +2736,7 @@ static int tc_chain_notify_delete(const struct tcf_proto_ops *tmplt_ops,
 	if (unicast)
 		return rtnl_unicast(skb, net, portid);
 
-	return rtnetlink_send(skb, net, portid, RTNLGRP_TC, flags & NLM_F_ECHO);
+	return rtnl_notify(skb, net, portid, RTNLGRP_TC, flags & NLM_F_ECHO, GFP_KERNEL);
 }
 
 static int tc_chain_tmplt_add(struct tcf_chain *chain, struct net *net,
diff --git a/net/sched/sch_api.c b/net/sched/sch_api.c
index 5e90e9b160e3..01858fd08b2a 100644
--- a/net/sched/sch_api.c
+++ b/net/sched/sch_api.c
@@ -987,8 +987,8 @@ static int qdisc_notify(struct net *net, struct sk_buff *oskb,
 	}
 
 	if (skb->len)
-		return rtnetlink_send(skb, net, portid, RTNLGRP_TC,
-				      n->nlmsg_flags & NLM_F_ECHO);
+		return rtnl_notify(skb, net, portid, RTNLGRP_TC,
+				   nlmsg_report(n), GFP_KERNEL);
 
 err_out:
 	kfree_skb(skb);
@@ -1855,8 +1855,8 @@ static int tclass_notify(struct net *net, struct sk_buff *oskb,
 		return -EINVAL;
 	}
 
-	return rtnetlink_send(skb, net, portid, RTNLGRP_TC,
-			      n->nlmsg_flags & NLM_F_ECHO);
+	return rtnl_notify(skb, net, portid, RTNLGRP_TC,
+			   nlmsg_report(n), GFP_KERNEL);
 }
 
 static int tclass_del_notify(struct net *net,
@@ -1888,9 +1888,8 @@ static int tclass_del_notify(struct net *net,
 		return err;
 	}
 
-	err = rtnetlink_send(skb, net, portid, RTNLGRP_TC,
-			     n->nlmsg_flags & NLM_F_ECHO);
-	return err;
+	return rtnl_notify(skb, net, portid, RTNLGRP_TC,
+			   nlmsg_report(n), GFP_KERNEL);
 }
 
 #ifdef CONFIG_NET_CLS
-- 
2.32.0

