Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16CC2CE109
	for <lists+netdev@lfdr.de>; Mon,  7 Oct 2019 13:58:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727793AbfJGL6n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 07:58:43 -0400
Received: from host.76.145.23.62.rev.coltfrance.com ([62.23.145.76]:37901 "EHLO
        proxy.6wind.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727467AbfJGL6n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Oct 2019 07:58:43 -0400
Received: from bretzel.dev.6wind.com (unknown [10.16.0.19])
        by proxy.6wind.com (Postfix) with ESMTPS id 77669328D1C;
        Mon,  7 Oct 2019 13:58:39 +0200 (CEST)
Received: from dichtel by bretzel.dev.6wind.com with local (Exim 4.92)
        (envelope-from <dichtel@bretzel.dev.6wind.com>)
        id 1iHRex-0004fj-CE; Mon, 07 Oct 2019 13:58:39 +0200
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
To:     davem@davemloft.net
Cc:     gnault@redhat.com, netdev@vger.kernel.org,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>
Subject: [PATCH net] netns: fix NLM_F_ECHO mechanism for RTM_NEWNSID
Date:   Mon,  7 Oct 2019 13:58:35 +0200
Message-Id: <20191007115835.17882-1-nicolas.dichtel@6wind.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003161940.GA31862@linux.home>
References: <20191003161940.GA31862@linux.home>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The flag NLM_F_ECHO aims to reply to the user the message notified to all
listeners.
It was not the case with the command RTM_NEWNSID, let's fix this.

Fixes: 0c7aecd4bde4 ("netns: add rtnl cmd to add and get peer netns ids")
Reported-by: Guillaume Nault <gnault@redhat.com>
Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
---
 net/core/net_namespace.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/net/core/net_namespace.c b/net/core/net_namespace.c
index a0e0d298c991..f496ce0e8da8 100644
--- a/net/core/net_namespace.c
+++ b/net/core/net_namespace.c
@@ -245,7 +245,8 @@ static int __peernet2id(struct net *net, struct net *peer)
 	return __peernet2id_alloc(net, peer, &no);
 }
 
-static void rtnl_net_notifyid(struct net *net, int cmd, int id);
+static void rtnl_net_notifyid(struct net *net, int cmd, int id, u32 portid,
+			      struct nlmsghdr *nlh);
 /* This function returns the id of a peer netns. If no id is assigned, one will
  * be allocated and returned.
  */
@@ -268,7 +269,7 @@ int peernet2id_alloc(struct net *net, struct net *peer)
 	id = __peernet2id_alloc(net, peer, &alloc);
 	spin_unlock_bh(&net->nsid_lock);
 	if (alloc && id >= 0)
-		rtnl_net_notifyid(net, RTM_NEWNSID, id);
+		rtnl_net_notifyid(net, RTM_NEWNSID, id, 0, NULL);
 	if (alive)
 		put_net(peer);
 	return id;
@@ -532,7 +533,7 @@ static void unhash_nsid(struct net *net, struct net *last)
 			idr_remove(&tmp->netns_ids, id);
 		spin_unlock_bh(&tmp->nsid_lock);
 		if (id >= 0)
-			rtnl_net_notifyid(tmp, RTM_DELNSID, id);
+			rtnl_net_notifyid(tmp, RTM_DELNSID, id, 0, NULL);
 		if (tmp == last)
 			break;
 	}
@@ -764,7 +765,8 @@ static int rtnl_net_newid(struct sk_buff *skb, struct nlmsghdr *nlh,
 	err = alloc_netid(net, peer, nsid);
 	spin_unlock_bh(&net->nsid_lock);
 	if (err >= 0) {
-		rtnl_net_notifyid(net, RTM_NEWNSID, err);
+		rtnl_net_notifyid(net, RTM_NEWNSID, err, NETLINK_CB(skb).portid,
+				  nlh);
 		err = 0;
 	} else if (err == -ENOSPC && nsid >= 0) {
 		err = -EEXIST;
@@ -1051,7 +1053,8 @@ static int rtnl_net_dumpid(struct sk_buff *skb, struct netlink_callback *cb)
 	return err < 0 ? err : skb->len;
 }
 
-static void rtnl_net_notifyid(struct net *net, int cmd, int id)
+static void rtnl_net_notifyid(struct net *net, int cmd, int id, u32 portid,
+			      struct nlmsghdr *nlh)
 {
 	struct net_fill_args fillargs = {
 		.cmd = cmd,
@@ -1068,7 +1071,7 @@ static void rtnl_net_notifyid(struct net *net, int cmd, int id)
 	if (err < 0)
 		goto err_out;
 
-	rtnl_notify(msg, net, 0, RTNLGRP_NSID, NULL, 0);
+	rtnl_notify(msg, net, portid, RTNLGRP_NSID, nlh, 0);
 	return;
 
 err_out:
-- 
2.23.0

