Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 726BB32CF30
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 10:01:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237278AbhCDI7n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Mar 2021 03:59:43 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:47243 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237261AbhCDI7d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Mar 2021 03:59:33 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 5446F5C0103;
        Thu,  4 Mar 2021 03:58:28 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Thu, 04 Mar 2021 03:58:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=7ES+NblSBDb5mo4eEVRyWQtGnBK0VISFkGKxCVXpH2I=; b=twE/XJUH
        SMP/f0aIbTWiJ2RPx6rFr7W9yITYbUglx5n/B9X3noGEzKBtZyBRpUYSjUrI6Umz
        pGo2PfOwagCVoqZ4cLRuJLcBxBu8+rrNj5j91vagClCCD06favhyzR7jM3ivWGF4
        nktSWn45sR0DnaVEL0m0vfF0/dvQaTa1VNGSYrMf9mo/Kpsa1rz5G22ez+XUoVM1
        a1pOGROLsJO9+rzh62ZwTrLGX4MULZoreo3EyHx4nrm/XroSdpjyVgLidnXsGms8
        TwUCcSLtZWuu5zWOvr61edKFM32VysADiCdcH5sVF/VEBanluxkUJJRpVOhJhEEZ
        YdfTZ+Swm4RfoA==
X-ME-Sender: <xms:NKFAYJjRR8Kp40c2bHT20vbPj0Y-n1S1XSlpJOcvge0xd3pfabdIiQ>
    <xme:NKFAYODp-I41uIV7E5KittYt9ge8-iC8Qvrxn9owDdMIcbq-g7ak3Ox-eQPYs7Hya
    zOfKGklXJtyE7Y>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledruddtfedguddugecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhf
    ekhefgtdfftefhledvjefggfehgfevjeekhfenucfkphepkeegrddvvdelrdduheefrdeg
    geenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:NKFAYJEs-1NCmQjAgi0lFLghjVhcXajNKAri0gboU8LqXDKqO_PIDg>
    <xmx:NKFAYOSri4QN0LNKvFFHvMmCAXl-D1QOQZ4okPvhZWoMey_SZabXkw>
    <xmx:NKFAYGzMWlZUjVxLj9CinWdrMsXU_QKhJUrNpP9WRZIkkWa-5v0Kaw>
    <xmx:NKFAYAvHA3dZQGzhjT7JGZsnKxOuH0tsmBmqvrV0lw1VmPitlDds9Q>
Received: from shredder.mellanox.com (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id 3F5CA1080054;
        Thu,  4 Mar 2021 03:58:26 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, dsahern@gmail.com,
        roopa@nvidia.com, sharpd@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net 1/2] nexthop: Do not flush blackhole nexthops when loopback goes down
Date:   Thu,  4 Mar 2021 10:57:53 +0200
Message-Id: <20210304085754.1929848-2-idosch@idosch.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210304085754.1929848-1-idosch@idosch.org>
References: <20210304085754.1929848-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

As far as user space is concerned, blackhole nexthops do not have a
nexthop device and therefore should not be affected by the
administrative or carrier state of any netdev.

However, when the loopback netdev goes down all the blackhole nexthops
are flushed. This happens because internally the kernel associates
blackhole nexthops with the loopback netdev.

This behavior is both confusing to those not familiar with kernel
internals and also diverges from the legacy API where blackhole IPv4
routes are not flushed when the loopback netdev goes down:

 # ip route add blackhole 198.51.100.0/24
 # ip link set dev lo down
 # ip route show 198.51.100.0/24
 blackhole 198.51.100.0/24

Blackhole IPv6 routes are flushed, but at least user space knows that
they are associated with the loopback netdev:

 # ip -6 route show 2001:db8:1::/64
 blackhole 2001:db8:1::/64 dev lo metric 1024 pref medium

Fix this by only flushing blackhole nexthops when the loopback netdev is
unregistered.

Fixes: ab84be7e54fc ("net: Initial nexthop code")
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reported-by: Donald Sharp <sharpd@nvidia.com>
Reviewed-by: David Ahern <dsahern@gmail.com>
---
 net/ipv4/nexthop.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
index f1c6cbdb9e43..743777bce179 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -1399,7 +1399,7 @@ static int insert_nexthop(struct net *net, struct nexthop *new_nh,
 
 /* rtnl */
 /* remove all nexthops tied to a device being deleted */
-static void nexthop_flush_dev(struct net_device *dev)
+static void nexthop_flush_dev(struct net_device *dev, unsigned long event)
 {
 	unsigned int hash = nh_dev_hashfn(dev->ifindex);
 	struct net *net = dev_net(dev);
@@ -1411,6 +1411,10 @@ static void nexthop_flush_dev(struct net_device *dev)
 		if (nhi->fib_nhc.nhc_dev != dev)
 			continue;
 
+		if (nhi->reject_nh &&
+		    (event == NETDEV_DOWN || event == NETDEV_CHANGE))
+			continue;
+
 		remove_nexthop(net, nhi->nh_parent, NULL);
 	}
 }
@@ -2189,11 +2193,11 @@ static int nh_netdev_event(struct notifier_block *this,
 	switch (event) {
 	case NETDEV_DOWN:
 	case NETDEV_UNREGISTER:
-		nexthop_flush_dev(dev);
+		nexthop_flush_dev(dev, event);
 		break;
 	case NETDEV_CHANGE:
 		if (!(dev_get_flags(dev) & (IFF_RUNNING | IFF_LOWER_UP)))
-			nexthop_flush_dev(dev);
+			nexthop_flush_dev(dev, event);
 		break;
 	case NETDEV_CHANGEMTU:
 		info_ext = ptr;
-- 
2.29.2

