Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32FF22A1DA2
	for <lists+netdev@lfdr.de>; Sun,  1 Nov 2020 12:40:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726452AbgKALk2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Nov 2020 06:40:28 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:58723 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726347AbgKALk1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Nov 2020 06:40:27 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 56B305C00D6;
        Sun,  1 Nov 2020 06:40:26 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Sun, 01 Nov 2020 06:40:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=5LHEyEhzyEE1YXMzP
        Ef6atbZBUZZoHl+OMWSnWvTuRA=; b=iVRfulfp/vO8fcmxT4mw9F3oTC+/OQ7Mm
        QtoISyg9e4zAD8pgOCrGh4USAnrxb4zSmecFTtKzD51yhQvU9PslJA5DWjQ/3Bxw
        qwQ8y6Wz9CoDDuO+Ms7lPC9Mv+46Pt2WLPS1jK4BRtwL64CFZ045u0flVhc7qCdH
        xmxJbfkuNv9YRNxw2DJeB9tt8apmJXu2cwPMQnIETYWM5euYC0HuYIMOogHLL61b
        a1oehyyGQEQEG0p77LMrtjDqNxguHRK++aEoqnvzZsbT1E1+W+yxnrZU/42z6I6o
        TGI5pNYZXcfpvgxG5uF12Ffn35q5SOnYsqOpjoo1+KAE/7YJSAKTA==
X-ME-Sender: <xms:qp6eX__dquBPJdE7bedWBpTV-lODehZVzTxFrTcnaKPM685UNvfM9Q>
    <xme:qp6eX7u7PT2HnYnUWz5EpO_ZgU_Z0dOGOhJdLHOYmNhWC4pcbTbAcpsBxEBKyLvWL
    oX4F2xsiuCW8vA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrleelgdefvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffoggfgsedtkeertdertd
    dtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhstghh
    rdhorhhgqeenucggtffrrghtthgvrhhnpeetveeghfevgffgffekueffuedvhfeuheehte
    ffieekgeehveefvdegledvffduhfenucfkphepkeegrddvvdelrdduheehrddukedvnecu
    vehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstg
    hhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:qp6eX9BIt7tnSfrj_uH6tU5ojuxR38bFqO3AbS5KncBNEdbNgHfedw>
    <xmx:qp6eX7dMGF0109xYCTfZJ0U1aid4YaBRnOAcfWeNFOn1GmnYVgJc3A>
    <xmx:qp6eX0PYPB89QkuoArxNugrxHCz0ovN0a7ccg4Sg8OWuv3ZiJMGq1w>
    <xmx:qp6eX5pqpdBJ7JptBHYIs_DHKCcsh74YKf3kMk5rHeiFYzOYzSlodQ>
Received: from shredder.mtl.com (igld-84-229-155-182.inter.net.il [84.229.155.182])
        by mail.messagingengine.com (Postfix) with ESMTPA id 4CF1C306467E;
        Sun,  1 Nov 2020 06:40:24 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, roopa@nvidia.com,
        dsahern@gmail.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next] vxlan: Use a per-namespace nexthop listener instead of a global one
Date:   Sun,  1 Nov 2020 13:39:26 +0200
Message-Id: <20201101113926.705630-1-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

The nexthop notification chain is a per-namespace chain and not a global
one like the netdev notification chain.

Therefore, a single (global) listener cannot be registered to all these
chains simultaneously as it will result in list corruptions whenever
listeners are registered / unregistered.

Instead, register a different listener in each namespace.

Currently this is not an issue because only the VXLAN driver registers a
listener to this chain, but this is going to change with netdevsim and
mlxsw also registering their own listeners.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/vxlan.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan.c
index 1a557aeba32b..876679af6f7c 100644
--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -66,6 +66,7 @@ struct vxlan_net {
 	struct list_head  vxlan_list;
 	struct hlist_head sock_list[PORT_HASH_SIZE];
 	spinlock_t	  sock_lock;
+	struct notifier_block nexthop_notifier_block;
 };
 
 /* Forwarding table entry */
@@ -4693,10 +4694,6 @@ static int vxlan_nexthop_event(struct notifier_block *nb,
 	return NOTIFY_DONE;
 }
 
-static struct notifier_block vxlan_nexthop_notifier_block __read_mostly = {
-	.notifier_call = vxlan_nexthop_event,
-};
-
 static __net_init int vxlan_init_net(struct net *net)
 {
 	struct vxlan_net *vn = net_generic(net, vxlan_net_id);
@@ -4704,11 +4701,12 @@ static __net_init int vxlan_init_net(struct net *net)
 
 	INIT_LIST_HEAD(&vn->vxlan_list);
 	spin_lock_init(&vn->sock_lock);
+	vn->nexthop_notifier_block.notifier_call = vxlan_nexthop_event;
 
 	for (h = 0; h < PORT_HASH_SIZE; ++h)
 		INIT_HLIST_HEAD(&vn->sock_list[h]);
 
-	return register_nexthop_notifier(net, &vxlan_nexthop_notifier_block);
+	return register_nexthop_notifier(net, &vn->nexthop_notifier_block);
 }
 
 static void vxlan_destroy_tunnels(struct net *net, struct list_head *head)
@@ -4740,8 +4738,11 @@ static void __net_exit vxlan_exit_batch_net(struct list_head *net_list)
 	LIST_HEAD(list);
 
 	rtnl_lock();
-	list_for_each_entry(net, net_list, exit_list)
-		unregister_nexthop_notifier(net, &vxlan_nexthop_notifier_block);
+	list_for_each_entry(net, net_list, exit_list) {
+		struct vxlan_net *vn = net_generic(net, vxlan_net_id);
+
+		unregister_nexthop_notifier(net, &vn->nexthop_notifier_block);
+	}
 	list_for_each_entry(net, net_list, exit_list)
 		vxlan_destroy_tunnels(net, &list);
 
-- 
2.26.2

