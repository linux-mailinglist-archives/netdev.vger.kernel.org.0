Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E692129678
	for <lists+netdev@lfdr.de>; Mon, 23 Dec 2019 14:29:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726890AbfLWN3E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Dec 2019 08:29:04 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:56043 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726867AbfLWN3D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Dec 2019 08:29:03 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id A876421E5B;
        Mon, 23 Dec 2019 08:29:02 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Mon, 23 Dec 2019 08:29:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=GgOqc1DY3h8qUg3cvNO7X3iBmqJbc9VFtBvTHXhOQRA=; b=Ah/hE/sd
        SEjgaIAG//TVPd9BOQziqUQXb2F/WoekfDHIkZIh+/iFyFWvQ6o9XIB9uHgZizsG
        737bsh1ESh8SsDcdkO0X13oaHtTxxa94ng/zqxgikqbas/LaH7yalsMfNoSHhWIA
        ilzEWoNTxQovyyMAqPRwTON0n6OfpzVZ735cNKnqrsyhpI7OpWQSXPgefqtgFm8G
        aOYbT3j2/mp+s4b5LFqEC00LOl+rbBnTE04ynVT4mY8v39BT7GIY8fVG69tKaKtV
        lEDWBlk1elkeVNO5gcuOZPzs1meRlGeXfO7598xp23FWY0WzQweGi8iAlgkLxTwU
        hmoA4E2xhYu7iw==
X-ME-Sender: <xms:HsEAXvTgdKWVtllFjx0b8xmaaopCfmWG4Yhwo6RgitUw_CX-26XMXw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvddvtddghedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpeeg
X-ME-Proxy: <xmx:HsEAXjp99TxFwz5DS5EmA5ogOu0MjgKLeQ2p0xdm-lR6UGsaZAYzLQ>
    <xmx:HsEAXt2gqcSTRtGWr-BCJZcO3eW_zksCfCXnTTHWDHlPdJwKNsEupg>
    <xmx:HsEAXuga67ETrQwGnXUw58GWwZnTtLF5N9A1uWb2exqB3pVJyHzbmw>
    <xmx:HsEAXv3PnzMf_qvaYLAE6dGTSBVNgWtI2CY1qW6irW6TnW0LJdN0GQ>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 527B03060802;
        Mon, 23 Dec 2019 08:29:01 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, dsahern@gmail.com, roopa@cumulusnetworks.com,
        jakub.kicinski@netronome.com, jiri@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 6/9] ipv6: Handle route deletion notification
Date:   Mon, 23 Dec 2019 15:28:17 +0200
Message-Id: <20191223132820.888247-7-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191223132820.888247-1-idosch@idosch.org>
References: <20191223132820.888247-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

For the purpose of route offload, when a single route is deleted, it is
only of interest if it is the first route in the node or if it is
sibling to such a route.

In the first case, distinguish between several possibilities:

1. Route is the last route in the node. Emit a delete notification

2. Route is followed by a non-multipath route. Emit a replace
notification for the non-multipath route.

3. Route is followed by a multipath route. Emit a replace notification
for the multipath route.

In the second case, only emit a delete notification to ensure the route
is no longer used as a valid nexthop.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 include/net/ip6_fib.h |  1 +
 net/ipv6/ip6_fib.c    | 44 ++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 44 insertions(+), 1 deletion(-)

diff --git a/include/net/ip6_fib.h b/include/net/ip6_fib.h
index f1535f172935..b579faea41e9 100644
--- a/include/net/ip6_fib.h
+++ b/include/net/ip6_fib.h
@@ -487,6 +487,7 @@ int call_fib6_multipath_entry_notifiers(struct net *net,
 					struct fib6_info *rt,
 					unsigned int nsiblings,
 					struct netlink_ext_ack *extack);
+int call_fib6_entry_notifiers_replace(struct net *net, struct fib6_info *rt);
 void fib6_rt_update(struct net *net, struct fib6_info *rt,
 		    struct nl_info *info);
 void inet6_rt_notify(int event, struct fib6_info *rt, struct nl_info *info,
diff --git a/net/ipv6/ip6_fib.c b/net/ipv6/ip6_fib.c
index 51cf848e38f0..67ddee539f77 100644
--- a/net/ipv6/ip6_fib.c
+++ b/net/ipv6/ip6_fib.c
@@ -415,6 +415,18 @@ int call_fib6_multipath_entry_notifiers(struct net *net,
 	return call_fib6_notifiers(net, event_type, &info.info);
 }
 
+int call_fib6_entry_notifiers_replace(struct net *net, struct fib6_info *rt)
+{
+	struct fib6_entry_notifier_info info = {
+		.rt = rt,
+		.nsiblings = rt->fib6_nsiblings,
+	};
+
+	rt->fib6_table->fib_seq++;
+	return call_fib6_notifiers(net, FIB_EVENT_ENTRY_REPLACE_TMP,
+				   &info.info);
+}
+
 struct fib6_dump_arg {
 	struct net *net;
 	struct notifier_block *nb;
@@ -1910,13 +1922,29 @@ static struct fib6_node *fib6_repair_tree(struct net *net,
 static void fib6_del_route(struct fib6_table *table, struct fib6_node *fn,
 			   struct fib6_info __rcu **rtp, struct nl_info *info)
 {
+	struct fib6_info *leaf, *replace_rt = NULL;
 	struct fib6_walker *w;
 	struct fib6_info *rt = rcu_dereference_protected(*rtp,
 				    lockdep_is_held(&table->tb6_lock));
 	struct net *net = info->nl_net;
+	bool notify_del = false;
 
 	RT6_TRACE("fib6_del_route\n");
 
+	/* If the deleted route is the first in the node and it is not part of
+	 * a multipath route, then we need to replace it with the next route
+	 * in the node, if exists.
+	 */
+	leaf = rcu_dereference_protected(fn->leaf,
+					 lockdep_is_held(&table->tb6_lock));
+	if (leaf == rt && !rt->fib6_nsiblings) {
+		if (rcu_access_pointer(rt->fib6_next))
+			replace_rt = rcu_dereference_protected(rt->fib6_next,
+					    lockdep_is_held(&table->tb6_lock));
+		else
+			notify_del = true;
+	}
+
 	/* Unlink it */
 	*rtp = rt->fib6_next;
 	rt->fib6_node = NULL;
@@ -1934,6 +1962,14 @@ static void fib6_del_route(struct fib6_table *table, struct fib6_node *fn,
 	if (rt->fib6_nsiblings) {
 		struct fib6_info *sibling, *next_sibling;
 
+		/* The route is deleted from a multipath route. If this
+		 * multipath route is the first route in the node, then we need
+		 * to emit a delete notification. Otherwise, we need to skip
+		 * the notification.
+		 */
+		if (rt->fib6_metric == leaf->fib6_metric &&
+		    rt6_qualify_for_ecmp(leaf))
+			notify_del = true;
 		list_for_each_entry_safe(sibling, next_sibling,
 					 &rt->fib6_siblings, fib6_siblings)
 			sibling->fib6_nsiblings--;
@@ -1969,8 +2005,14 @@ static void fib6_del_route(struct fib6_table *table, struct fib6_node *fn,
 
 	fib6_purge_rt(rt, fn, net);
 
-	if (!info->skip_notify_kernel)
+	if (!info->skip_notify_kernel) {
+		if (notify_del)
+			call_fib6_entry_notifiers(net, FIB_EVENT_ENTRY_DEL_TMP,
+						  rt, NULL);
+		else if (replace_rt)
+			call_fib6_entry_notifiers_replace(net, replace_rt);
 		call_fib6_entry_notifiers(net, FIB_EVENT_ENTRY_DEL, rt, NULL);
+	}
 	if (!info->skip_notify)
 		inet6_rt_notify(RTM_DELROUTE, rt, info, 0);
 
-- 
2.24.1

