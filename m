Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3596129675
	for <lists+netdev@lfdr.de>; Mon, 23 Dec 2019 14:29:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726828AbfLWN27 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Dec 2019 08:28:59 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:34277 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726676AbfLWN26 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Dec 2019 08:28:58 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id DD9FB21B7C;
        Mon, 23 Dec 2019 08:28:56 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Mon, 23 Dec 2019 08:28:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=U6H5iYnxtZ0IT6nlwrqLRT83q9FWmrUr8wnWHWM9iR8=; b=uiJhIGu5
        NesAX0mZMLz2nFTtCZF0zyMvmHx3lYo+BGFClFlqpSL3DaO/4Iut8T4iwgjekC5a
        JhM63J5VPLCNR5UwSUU+/Knu3Xl7/Us9NEemRHC9P0rrn/wrEYmYeDeLzSJwdwc7
        KJBEFSqi1sPFqLoq5ClDXyZJjgk8jl9xWoqbckkWvwD8kDpnYQ4Z18HcxSzrxJit
        u3pA4gS/8fdUMQwegFcTHrde4TLm+zmKEli4BvpGtz0+eewU7HcjqbRVYVsuYcfr
        4t/6EYnoO74YClSaj3qgWJCU968W3L0jnX7uXboNMmSnQhmP4hMHRU2Nn++9LRz1
        Q6RBmzCrtRBtrA==
X-ME-Sender: <xms:GMEAXgi1BcYfjCO_oWH4nC0hKqnw55ZMhxkyCxu1EtFeXJWVBZ2aqQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvddvtddghedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpedt
X-ME-Proxy: <xmx:GMEAXs3DxNJDEQz5pVam0tTFl-LUNUT-TFpVqGs5KZj1w4xVPucqQQ>
    <xmx:GMEAXmTcyrhl9E5nT09zEREHGds06jU8Wjc8-kCpMgeFvNkF8D-0ew>
    <xmx:GMEAXrELBFVZt_jU3bYwoIfywKt8SpZHA-9I-0yA96eCGnwqF4gEIg>
    <xmx:GMEAXsxh786bzY_5F1qUUveMbRpYhaF9k0JoRKOg2KQ_JXcj68UBiA>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 87DA930609A0;
        Mon, 23 Dec 2019 08:28:55 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, dsahern@gmail.com, roopa@cumulusnetworks.com,
        jakub.kicinski@netronome.com, jiri@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 2/9] ipv6: Notify newly added route if should be offloaded
Date:   Mon, 23 Dec 2019 15:28:13 +0200
Message-Id: <20191223132820.888247-3-idosch@idosch.org>
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

fib6_add_rt2node() takes care of adding a single route ('struct
fib6_info') to a FIB node. The route in question should only be notified
in case it is added as the first route in the node (lowest metric) or if
it is added as a sibling route to the first route in the node.

The first criterion can be tested by checking if the route is pointed to
by 'fn->leaf'. The second criterion can be tested by checking the new
'notify_sibling_rt' variable that is set when the route is added as a
sibling to the first route in the node.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 net/ipv6/ip6_fib.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/net/ipv6/ip6_fib.c b/net/ipv6/ip6_fib.c
index 7bae6a91b487..045bcaf5e770 100644
--- a/net/ipv6/ip6_fib.c
+++ b/net/ipv6/ip6_fib.c
@@ -1039,6 +1039,7 @@ static int fib6_add_rt2node(struct fib6_node *fn, struct fib6_info *rt,
 		   (info->nlh->nlmsg_flags & NLM_F_CREATE));
 	int found = 0;
 	bool rt_can_ecmp = rt6_qualify_for_ecmp(rt);
+	bool notify_sibling_rt = false;
 	u16 nlflags = NLM_F_EXCL;
 	int err;
 
@@ -1130,6 +1131,7 @@ static int fib6_add_rt2node(struct fib6_node *fn, struct fib6_info *rt,
 
 		/* Find the first route that have the same metric */
 		sibling = leaf;
+		notify_sibling_rt = true;
 		while (sibling) {
 			if (sibling->fib6_metric == rt->fib6_metric &&
 			    rt6_qualify_for_ecmp(sibling)) {
@@ -1139,6 +1141,7 @@ static int fib6_add_rt2node(struct fib6_node *fn, struct fib6_info *rt,
 			}
 			sibling = rcu_dereference_protected(sibling->fib6_next,
 				    lockdep_is_held(&rt->fib6_table->tb6_lock));
+			notify_sibling_rt = false;
 		}
 		/* For each sibling in the list, increment the counter of
 		 * siblings. BUG() if counters does not match, list of siblings
@@ -1166,6 +1169,21 @@ static int fib6_add_rt2node(struct fib6_node *fn, struct fib6_info *rt,
 		nlflags |= NLM_F_CREATE;
 
 		if (!info->skip_notify_kernel) {
+			enum fib_event_type fib_event;
+
+			if (notify_sibling_rt)
+				fib_event = FIB_EVENT_ENTRY_APPEND;
+			else
+				fib_event = FIB_EVENT_ENTRY_REPLACE_TMP;
+			/* The route should only be notified if it is the first
+			 * route in the node or if it is added as a sibling
+			 * route to the first route in the node.
+			 */
+			if (notify_sibling_rt || ins == &fn->leaf)
+				err = call_fib6_entry_notifiers(info->nl_net,
+								fib_event, rt,
+								extack);
+
 			err = call_fib6_entry_notifiers(info->nl_net,
 							FIB_EVENT_ENTRY_ADD,
 							rt, extack);
-- 
2.24.1

