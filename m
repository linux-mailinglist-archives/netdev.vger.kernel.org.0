Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAA2526B8A8
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 02:48:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726725AbgIPAsf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 20:48:35 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:49419 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726347AbgIOLm0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 07:42:26 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 09A555C007D;
        Tue, 15 Sep 2020 07:41:55 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Tue, 15 Sep 2020 07:41:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=THAPThjulp5KjXmunii3GZDziWYRvLoLnl3sB/KnlKk=; b=DMsLUho9
        JitzekBf2EDlsQqDksuFuhAv0APUYa2YTVgzGcmXTTLrHy8Q/0bSGQWSMZ+ljNwL
        g60IsV+AnDHSyH5688ayfbQfYCUnLTjEw629g64sgzvcZsdRl4LLnZUe9hLEC9x2
        Mll/cmQKPYGJLpREZW08tJJSC9UoS9BRdS6Ydc3gxmZOqa5lI1w2XI/zy7k1cFWb
        PwWx4MUoxFoNToUCdjJUbbuS/cslK7G/0QMH1UUm8EmDuNrIbi85MzVzxA03OYpj
        uBnaUUxgP0qHCyuk5qLtEN5exYP4/vX6jWFJcW7UL7qYVq3K/NLCaP9Xg/J6T4yp
        /4sn0p8PowGxgQ==
X-ME-Sender: <xms:gqhgXxMW4TNdLnCfc7f6Bd6-ukD_BSfzDnJI4tx-xOfhUkknYAQftw>
    <xme:gqhgXz-UJWxb-V_vEMIIvFkrOGUo6KVrm3RF31-WHKzDpm4nGRRmwf297mmM0lVtJ
    1W32C6mlK-dnyg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrtddtgdduvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhfekhe
    fgtdfftefhledvjefggfehgfevjeekhfenucfkphepkeegrddvvdelrdefiedrkedvnecu
    vehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstg
    hhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:gqhgXwQRpRK1yUp3jEd-AxufNi7fht0KVHFhQh1TKL1hYWLkyMkv8A>
    <xmx:gqhgX9tCJaoXiI2hFuPHtK8Yoemf-kF_34H1Tey6RUW2CKbkK-YCUA>
    <xmx:gqhgX5f9FbRwOC7b_5DZQb2SYtmropsi3A7SsDoJ3DNxNDbMFkP2Rw>
    <xmx:g6hgX6qG9AveRrhrtQHvPsNAcAfP_aPlOmjoI0V5G2oHHsO0Muc8sw>
Received: from shredder.mtl.com (igld-84-229-36-82.inter.net.il [84.229.36.82])
        by mail.messagingengine.com (Postfix) with ESMTPA id 87B4B3064674;
        Tue, 15 Sep 2020 07:41:53 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, dsahern@gmail.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 3/5] nexthop: Convert to blocking notification chain
Date:   Tue, 15 Sep 2020 14:41:01 +0300
Message-Id: <20200915114103.88883-4-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200915114103.88883-1-idosch@idosch.org>
References: <20200915114103.88883-1-idosch@idosch.org>
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
Reviewed-by: David Ahern <dsahern@gmail.com>
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

