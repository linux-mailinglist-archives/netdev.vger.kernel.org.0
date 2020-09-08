Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09AE7260E5D
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 11:11:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729049AbgIHJLi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 05:11:38 -0400
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:34125 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728676AbgIHJLa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 05:11:30 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id E334BF6F;
        Tue,  8 Sep 2020 05:11:28 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Tue, 08 Sep 2020 05:11:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=o8CL35/tDz9hT2dDPwtsvg0IdrwfweXwsPs1FjulMhY=; b=WahzIRz/
        4yE2JDM10rzpkfF0W6pPlR7o+RJzflVvHUm3S4Hp4cXU5Ai9wxjMapUFjZeeTZvE
        Eo+n/pugywSBWdzuDefHTVbETmhAFe82rwYtY1Qi45tqDQ6HhcQ23owaPfxhWnVd
        qZHab0ve9vk0/viPuYe4AfTOmp4J01lUPhQXv4j5i4yXToV2gtmmrLhj7ZNsjFDA
        j81KN9N5LqLn6XPCZUUc+Fr4/ViEm6tinok+ilqleLySaFAQvf6ZrsrTHG6GXPvn
        F+McCiaUTdqm6TXSMtUPa5fG7Q8m3kM3B/C6jwmcmxGepgcxyouHAJqxLTrUBt1V
        JAaUggtZ6RVMHQ==
X-ME-Sender: <xms:wEpXX768J443G82003K9s4d1yTjKVLJXKNpk7mfZgT8X7T9qIol0jg>
    <xme:wEpXXw4tnEXWEJPeybHHv8hDwFVQEcnGJCAlqnhaGZK9Gx-9kW33ePefb36HmhsH_
    HAl-SKu-gNbQxQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudehvddguddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrfeeirdduvdek
    necuvehluhhsthgvrhfuihiivgepudenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:wEpXXycbQpg4g4ek2Bxw0pwanYiqhJLwsbtQJqC7qsipcmW8awB__g>
    <xmx:wEpXX8IFYlcP4oHuhs-4I0MFL9k8iAWB2pqOIUNONvlszSV3Snz_1A>
    <xmx:wEpXX_KDBA2erq8N7SZ7GPLtRAdRoRMPxy1pUKT9aMHZDggmV9cQCw>
    <xmx:wEpXX32L9BicBS2rPn5mIkRT1nMPnV4VNWKU6fLRS4sJRGGi3V2GGw>
Received: from shredder.mtl.com (igld-84-229-36-128.inter.net.il [84.229.36.128])
        by mail.messagingengine.com (Postfix) with ESMTPA id 3B1FE306467D;
        Tue,  8 Sep 2020 05:11:27 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, dsahern@gmail.com,
        roopa@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [RFC PATCH net-next 02/22] nexthop: Convert to blocking notification chain
Date:   Tue,  8 Sep 2020 12:10:17 +0300
Message-Id: <20200908091037.2709823-3-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200908091037.2709823-1-idosch@idosch.org>
References: <20200908091037.2709823-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Currently, the only listener of the nexthop notification chain is the
VXLAN driver. Subsequent patches will add more listeners (e.g., device
drivers such as netdevsim) that need to be able to block when processing
notifications.

Therefore, convert the notification chain to a blocking one. This is
safe as notifications are always emitted from process context.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 include/net/netns/nexthop.h |  2 +-
 net/ipv4/nexthop.c          | 13 +++++++------
 2 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/include/net/netns/nexthop.h b/include/net/netns/nexthop.h
index 1937476c94a0..1849e77eb68a 100644
--- a/include/net/netns/nexthop.h
+++ b/include/net/netns/nexthop.h
@@ -14,6 +14,6 @@ struct netns_nexthop {
 
 	unsigned int		seq;		/* protected by rtnl_mutex */
 	u32			last_id_allocated;
-	struct atomic_notifier_head notifier_chain;
+	struct blocking_notifier_head notifier_chain;
 };
 #endif
diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
index bf9d4cd2d6e5..13d9219a9aa1 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -42,8 +42,8 @@ static int call_nexthop_notifiers(struct net *net,
 {
 	int err;
 
-	err = atomic_notifier_call_chain(&net->nexthop.notifier_chain,
-					 event_type, nh);
+	err = blocking_notifier_call_chain(&net->nexthop.notifier_chain,
+					   event_type, nh);
 	return notifier_to_errno(err);
 }
 
@@ -1959,14 +1959,15 @@ static struct notifier_block nh_netdev_notifier = {
 
 int register_nexthop_notifier(struct net *net, struct notifier_block *nb)
 {
-	return atomic_notifier_chain_register(&net->nexthop.notifier_chain, nb);
+	return blocking_notifier_chain_register(&net->nexthop.notifier_chain,
+						nb);
 }
 EXPORT_SYMBOL(register_nexthop_notifier);
 
 int unregister_nexthop_notifier(struct net *net, struct notifier_block *nb)
 {
-	return atomic_notifier_chain_unregister(&net->nexthop.notifier_chain,
-						nb);
+	return blocking_notifier_chain_unregister(&net->nexthop.notifier_chain,
+						  nb);
 }
 EXPORT_SYMBOL(unregister_nexthop_notifier);
 
@@ -1986,7 +1987,7 @@ static int __net_init nexthop_net_init(struct net *net)
 	net->nexthop.devhash = kzalloc(sz, GFP_KERNEL);
 	if (!net->nexthop.devhash)
 		return -ENOMEM;
-	ATOMIC_INIT_NOTIFIER_HEAD(&net->nexthop.notifier_chain);
+	BLOCKING_INIT_NOTIFIER_HEAD(&net->nexthop.notifier_chain);
 
 	return 0;
 }
-- 
2.26.2

