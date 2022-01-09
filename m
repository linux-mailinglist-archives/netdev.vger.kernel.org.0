Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87CB4488D02
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 00:16:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237380AbiAIXQw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jan 2022 18:16:52 -0500
Received: from mail.netfilter.org ([217.70.188.207]:42106 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236098AbiAIXQu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jan 2022 18:16:50 -0500
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 57AE26428F;
        Mon, 10 Jan 2022 00:13:59 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 01/32] netfilter: nfnetlink: add netns refcount tracker to struct nfulnl_instance
Date:   Mon, 10 Jan 2022 00:16:09 +0100
Message-Id: <20220109231640.104123-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220109231640.104123-1-pablo@netfilter.org>
References: <20220109231640.104123-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

If compiled with CONFIG_NET_NS_REFCNT_TRACKER=y,
using put_net_track() in nfulnl_instance_free_rcu()
and get_net_track() in instance_create()
might help us finding netns refcount imbalances.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nfnetlink_log.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index 691ef4cffdd9..7a3a91fc7ffa 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -66,6 +66,7 @@ struct nfulnl_instance {
 	struct sk_buff *skb;		/* pre-allocatd skb */
 	struct timer_list timer;
 	struct net *net;
+	netns_tracker ns_tracker;
 	struct user_namespace *peer_user_ns;	/* User namespace of the peer process */
 	u32 peer_portid;		/* PORTID of the peer process */
 
@@ -140,7 +141,7 @@ static void nfulnl_instance_free_rcu(struct rcu_head *head)
 	struct nfulnl_instance *inst =
 		container_of(head, struct nfulnl_instance, rcu);
 
-	put_net(inst->net);
+	put_net_track(inst->net, &inst->ns_tracker);
 	kfree(inst);
 	module_put(THIS_MODULE);
 }
@@ -187,7 +188,7 @@ instance_create(struct net *net, u_int16_t group_num,
 
 	timer_setup(&inst->timer, nfulnl_timer, 0);
 
-	inst->net = get_net(net);
+	inst->net = get_net_track(net, &inst->ns_tracker, GFP_ATOMIC);
 	inst->peer_user_ns = user_ns;
 	inst->peer_portid = portid;
 	inst->group_num = group_num;
-- 
2.30.2

