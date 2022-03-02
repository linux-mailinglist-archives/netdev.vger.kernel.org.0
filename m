Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB2FC4CAA9B
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 17:40:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243351AbiCBQku (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 11:40:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239774AbiCBQks (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 11:40:48 -0500
Received: from simonwunderlich.de (simonwunderlich.de [IPv6:2a01:4f8:c17:e8c0::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD072CEA01
        for <netdev@vger.kernel.org>; Wed,  2 Mar 2022 08:40:03 -0800 (PST)
Received: from kero.packetmixer.de (p200300C597470fc0d439fbe5C3508408.dip0.t-ipconnect.de [IPv6:2003:c5:9747:fc0:d439:fbe5:c350:8408])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by simonwunderlich.de (Postfix) with ESMTPSA id D24A5FA746;
        Wed,  2 Mar 2022 17:30:52 +0100 (CET)
From:   Simon Wunderlich <sw@simonwunderlich.de>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, b.a.t.m.a.n@lists.open-mesh.org,
        Sven Eckelmann <sven@narfation.org>,
        Sabrina Dubroca <sd@queasysnail.net>,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 3/3] batman-adv: Don't expect inter-netns unique iflink indices
Date:   Wed,  2 Mar 2022 17:30:49 +0100
Message-Id: <20220302163049.101957-4-sw@simonwunderlich.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220302163049.101957-1-sw@simonwunderlich.de>
References: <20220302163049.101957-1-sw@simonwunderlich.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sven Eckelmann <sven@narfation.org>

The ifindex doesn't have to be unique for multiple network namespaces on
the same machine.

  $ ip netns add test1
  $ ip -net test1 link add dummy1 type dummy
  $ ip netns add test2
  $ ip -net test2 link add dummy2 type dummy

  $ ip -net test1 link show dev dummy1
  6: dummy1: <BROADCAST,NOARP> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
      link/ether 96:81:55:1e:dd:85 brd ff:ff:ff:ff:ff:ff
  $ ip -net test2 link show dev dummy2
  6: dummy2: <BROADCAST,NOARP> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
      link/ether 5a:3c:af:35:07:c3 brd ff:ff:ff:ff:ff:ff

But the batman-adv code to walk through the various layers of virtual
interfaces uses this assumption because dev_get_iflink handles it
internally and doesn't return the actual netns of the iflink. And
dev_get_iflink only documents the situation where ifindex == iflink for
physical devices.

But only checking for dev->netdev_ops->ndo_get_iflink is also not an option
because ipoib_get_iflink implements it even when it sometimes returns an
iflink != ifindex and sometimes iflink == ifindex. The caller must
therefore make sure itself to check both netns and iflink + ifindex for
equality. Only when they are equal, a "physical" interface was detected
which should stop the traversal. On the other hand, vxcan_get_iflink can
also return 0 in case there was currently no valid peer. In this case, it
is still necessary to stop.

Fixes: b7eddd0b3950 ("batman-adv: prevent using any virtual device created on batman-adv as hard-interface")
Fixes: 5ed4a460a1d3 ("batman-adv: additional checks for virtual interfaces on top of WiFi")
Reported-by: Sabrina Dubroca <sd@queasysnail.net>
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
---
 net/batman-adv/hard-interface.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/net/batman-adv/hard-interface.c b/net/batman-adv/hard-interface.c
index e2760cfce190..35fadb924849 100644
--- a/net/batman-adv/hard-interface.c
+++ b/net/batman-adv/hard-interface.c
@@ -157,13 +157,15 @@ static bool batadv_is_on_batman_iface(const struct net_device *net_dev)
 		return true;
 
 	iflink = dev_get_iflink(net_dev);
-
-	/* no more parents..stop recursion */
-	if (iflink == 0 || iflink == net_dev->ifindex)
+	if (iflink == 0)
 		return false;
 
 	parent_net = batadv_getlink_net(net_dev, net);
 
+	/* iflink to itself, most likely physical device */
+	if (net == parent_net && iflink == net_dev->ifindex)
+		return false;
+
 	/* recurse over the parent device */
 	parent_dev = __dev_get_by_index((struct net *)parent_net, iflink);
 	/* if we got a NULL parent_dev there is something broken.. */
@@ -223,8 +225,7 @@ static struct net_device *batadv_get_real_netdevice(struct net_device *netdev)
 		return NULL;
 
 	iflink = dev_get_iflink(netdev);
-
-	if (netdev->ifindex == iflink) {
+	if (iflink == 0) {
 		dev_hold(netdev);
 		return netdev;
 	}
@@ -235,6 +236,14 @@ static struct net_device *batadv_get_real_netdevice(struct net_device *netdev)
 
 	net = dev_net(hard_iface->soft_iface);
 	real_net = batadv_getlink_net(netdev, net);
+
+	/* iflink to itself, most likely physical device */
+	if (net == real_net && netdev->ifindex == iflink) {
+		real_netdev = netdev;
+		dev_hold(real_netdev);
+		goto out;
+	}
+
 	real_netdev = dev_get_by_index(real_net, iflink);
 
 out:
-- 
2.30.2

