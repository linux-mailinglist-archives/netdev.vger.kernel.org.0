Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F21AA39FAED
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 17:36:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232942AbhFHPhi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 11:37:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233028AbhFHPhZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Jun 2021 11:37:25 -0400
Received: from simonwunderlich.de (packetmixer.de [IPv6:2001:4d88:2000:24::c0de])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48979C061787
        for <netdev@vger.kernel.org>; Tue,  8 Jun 2021 08:35:32 -0700 (PDT)
Received: from kero.packetmixer.de (p200300c5970dd3e020a52263b5aabfb3.dip0.t-ipconnect.de [IPv6:2003:c5:970d:d3e0:20a5:2263:b5aa:bfb3])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by simonwunderlich.de (Postfix) with ESMTPSA id 0A073174029;
        Tue,  8 Jun 2021 17:27:04 +0200 (CEST)
From:   Simon Wunderlich <sw@simonwunderlich.de>
To:     kuba@kernel.org, davem@davemloft.net
Cc:     netdev@vger.kernel.org, b.a.t.m.a.n@lists.open-mesh.org,
        =?UTF-8?q?Linus=20L=C3=BCssing?= <linus.luessing@c0d3.blue>,
        Sven Eckelmann <sven@narfation.org>,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 05/11] batman-adv: mcast: add MRD + routable IPv4 multicast with bridges support
Date:   Tue,  8 Jun 2021 17:26:54 +0200
Message-Id: <20210608152700.30315-6-sw@simonwunderlich.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210608152700.30315-1-sw@simonwunderlich.de>
References: <20210608152700.30315-1-sw@simonwunderlich.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Linus Lüssing <linus.luessing@c0d3.blue>

This adds support for routable IPv4 multicast addresses
(224.0.0.0/4, excluding 224.0.0.0/24) in bridged setups.

This utilizes the Multicast Router Discovery (MRD, RFC4286) support
in the Linux bridge. batman-adv will now query the Linux bridge for
IPv4 multicast routers, which the bridge has previously learned about
via MRD.

This allows us to then safely send routable IPv4 multicast packets in
bridged setups to multicast listeners and multicast routers only. Before
we had to flood such packets to avoid potential multicast packet loss to
IPv4 multicast routers, which we were not able to detect before.

With the bridge MRD integration, we are now also able to perform more
fine-grained detection of IPv6 multicast routers in bridged setups:
Before we were "guessing" IPv6 multicast routers by looking up multicast
listeners for the link-local All Routers multicast address (ff02::2),
which every IPv6 multicast router is listening to. However this would
also include more nodes than necessary: For instance nodes which are
just a router for unicast, but not multicast would be included, too.

Signed-off-by: Linus Lüssing <linus.luessing@c0d3.blue>
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
---
 net/batman-adv/multicast.c | 41 +++++---------------------------------
 1 file changed, 5 insertions(+), 36 deletions(-)

diff --git a/net/batman-adv/multicast.c b/net/batman-adv/multicast.c
index 1d63c8cbbfe7..923e2197c2db 100644
--- a/net/batman-adv/multicast.c
+++ b/net/batman-adv/multicast.c
@@ -193,53 +193,22 @@ static u8 batadv_mcast_mla_rtr_flags_softif_get(struct batadv_priv *bat_priv,
  *	BATADV_MCAST_WANT_NO_RTR6: No IPv6 multicast router is present
  *	The former two OR'd: no multicast router is present
  */
-#if IS_ENABLED(CONFIG_IPV6)
 static u8 batadv_mcast_mla_rtr_flags_bridge_get(struct batadv_priv *bat_priv,
 						struct net_device *bridge)
 {
-	struct list_head bridge_mcast_list = LIST_HEAD_INIT(bridge_mcast_list);
 	struct net_device *dev = bat_priv->soft_iface;
-	struct br_ip_list *br_ip_entry, *tmp;
-	u8 flags = BATADV_MCAST_WANT_NO_RTR6;
-	int ret;
+	u8 flags = BATADV_NO_FLAGS;
 
 	if (!bridge)
 		return BATADV_MCAST_WANT_NO_RTR4 | BATADV_MCAST_WANT_NO_RTR6;
 
-	/* TODO: ask the bridge if a multicast router is present (the bridge
-	 * is capable of performing proper RFC4286 multicast router
-	 * discovery) instead of searching for a ff02::2 listener here
-	 */
-	ret = br_multicast_list_adjacent(dev, &bridge_mcast_list);
-	if (ret < 0)
-		return BATADV_NO_FLAGS;
-
-	list_for_each_entry_safe(br_ip_entry, tmp, &bridge_mcast_list, list) {
-		/* the bridge snooping does not maintain IPv4 link-local
-		 * addresses - therefore we won't find any IPv4 multicast router
-		 * address here, only IPv6 ones
-		 */
-		if (br_ip_entry->addr.proto == htons(ETH_P_IPV6) &&
-		    ipv6_addr_is_ll_all_routers(&br_ip_entry->addr.dst.ip6))
-			flags &= ~BATADV_MCAST_WANT_NO_RTR6;
-
-		list_del(&br_ip_entry->list);
-		kfree(br_ip_entry);
-	}
+	if (!br_multicast_has_router_adjacent(dev, ETH_P_IP))
+		flags |= BATADV_MCAST_WANT_NO_RTR4;
+	if (!br_multicast_has_router_adjacent(dev, ETH_P_IPV6))
+		flags |= BATADV_MCAST_WANT_NO_RTR6;
 
 	return flags;
 }
-#else
-static inline u8
-batadv_mcast_mla_rtr_flags_bridge_get(struct batadv_priv *bat_priv,
-				      struct net_device *bridge)
-{
-	if (bridge)
-		return BATADV_NO_FLAGS;
-	else
-		return BATADV_MCAST_WANT_NO_RTR4 | BATADV_MCAST_WANT_NO_RTR6;
-}
-#endif
 
 /**
  * batadv_mcast_mla_rtr_flags_get() - get multicast router flags
-- 
2.20.1

