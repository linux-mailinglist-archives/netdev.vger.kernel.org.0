Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9172926FE22
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 15:22:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726699AbgIRNUF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 09:20:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726548AbgIRNUC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 09:20:02 -0400
Received: from simonwunderlich.de (packetmixer.de [IPv6:2001:4d88:2000:24::c0de])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40B85C06178B
        for <netdev@vger.kernel.org>; Fri, 18 Sep 2020 06:20:02 -0700 (PDT)
Received: from kero.packetmixer.de (p200300c59714ead05d12fb7f5a0314d0.dip0.t-ipconnect.de [IPv6:2003:c5:9714:ead0:5d12:fb7f:5a03:14d0])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by simonwunderlich.de (Postfix) with ESMTPSA id E55C762077;
        Fri, 18 Sep 2020 15:19:59 +0200 (CEST)
From:   Simon Wunderlich <sw@simonwunderlich.de>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, b.a.t.m.a.n@lists.open-mesh.org,
        =?UTF-8?q?Linus=20L=C3=BCssing?= <linus.luessing@c0d3.blue>,
        Sven Eckelmann <sven@narfation.org>,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 4/6] batman-adv: mcast: fix duplicate mcast packets in BLA backbone from LAN
Date:   Fri, 18 Sep 2020 15:19:54 +0200
Message-Id: <20200918131956.21598-5-sw@simonwunderlich.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200918131956.21598-1-sw@simonwunderlich.de>
References: <20200918131956.21598-1-sw@simonwunderlich.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Linus Lüssing <linus.luessing@c0d3.blue>

Scenario:
* Multicast frame send from a BLA backbone (multiple nodes with
  their bat0 bridged together, with BLA enabled)

Issue:
* BLA backbone nodes receive the frame multiple times on bat0

For multicast frames received via batman-adv broadcast packets the
originator of the broadcast packet is checked before decapsulating and
forwarding the frame to bat0 (batadv_bla_is_backbone_gw()->
batadv_recv_bcast_packet()). If it came from a node which shares the
same BLA backbone with us then it is not forwarded to bat0 to avoid a
loop.

When sending a multicast frame in a non-4-address batman-adv unicast
packet we are currently missing this check - and cannot do so because
the batman-adv unicast packet has no originator address field.

However, we can simply fix this on the sender side by only sending the
multicast frame via unicasts to interested nodes which do not share the
same BLA backbone with us. This also nicely avoids some unnecessary
transmissions on mesh side.

Note that no infinite loop was observed, probably because of dropping
via batadv_interface_tx()->batadv_bla_tx(). However the duplicates still
utterly confuse switches/bridges, ICMPv6 duplicate address detection and
neighbor discovery and therefore leads to long delays before being able
to establish TCP connections, for instance. And it also leads to the Linux
bridge printing messages like:
"br-lan: received packet on eth1 with own address as source address ..."

Fixes: 2d3f6ccc4ea5 ("batman-adv: Modified forwarding behaviour for multicast packets")
Signed-off-by: Linus Lüssing <linus.luessing@c0d3.blue>
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
---
 net/batman-adv/multicast.c      | 46 ++++++++++++++++++++++++++-------
 net/batman-adv/multicast.h      | 15 +++++++++++
 net/batman-adv/soft-interface.c |  5 ++--
 3 files changed, 53 insertions(+), 13 deletions(-)

diff --git a/net/batman-adv/multicast.c b/net/batman-adv/multicast.c
index bdc4a1fba1c6..ca24a2e522b7 100644
--- a/net/batman-adv/multicast.c
+++ b/net/batman-adv/multicast.c
@@ -51,6 +51,7 @@
 #include <uapi/linux/batadv_packet.h>
 #include <uapi/linux/batman_adv.h>
 
+#include "bridge_loop_avoidance.h"
 #include "hard-interface.h"
 #include "hash.h"
 #include "log.h"
@@ -1434,6 +1435,35 @@ batadv_mcast_forw_mode(struct batadv_priv *bat_priv, struct sk_buff *skb,
 	return BATADV_FORW_ALL;
 }
 
+/**
+ * batadv_mcast_forw_send_orig() - send a multicast packet to an originator
+ * @bat_priv: the bat priv with all the soft interface information
+ * @skb: the multicast packet to send
+ * @vid: the vlan identifier
+ * @orig_node: the originator to send the packet to
+ *
+ * Return: NET_XMIT_DROP in case of error or NET_XMIT_SUCCESS otherwise.
+ */
+int batadv_mcast_forw_send_orig(struct batadv_priv *bat_priv,
+				struct sk_buff *skb,
+				unsigned short vid,
+				struct batadv_orig_node *orig_node)
+{
+	/* Avoid sending multicast-in-unicast packets to other BLA
+	 * gateways - they already got the frame from the LAN side
+	 * we share with them.
+	 * TODO: Refactor to take BLA into account earlier, to avoid
+	 * reducing the mcast_fanout count.
+	 */
+	if (batadv_bla_is_backbone_gw_orig(bat_priv, orig_node->orig, vid)) {
+		dev_kfree_skb(skb);
+		return NET_XMIT_SUCCESS;
+	}
+
+	return batadv_send_skb_unicast(bat_priv, skb, BATADV_UNICAST, 0,
+				       orig_node, vid);
+}
+
 /**
  * batadv_mcast_forw_tt() - forwards a packet to multicast listeners
  * @bat_priv: the bat priv with all the soft interface information
@@ -1471,8 +1501,8 @@ batadv_mcast_forw_tt(struct batadv_priv *bat_priv, struct sk_buff *skb,
 			break;
 		}
 
-		batadv_send_skb_unicast(bat_priv, newskb, BATADV_UNICAST, 0,
-					orig_entry->orig_node, vid);
+		batadv_mcast_forw_send_orig(bat_priv, newskb, vid,
+					    orig_entry->orig_node);
 	}
 	rcu_read_unlock();
 
@@ -1513,8 +1543,7 @@ batadv_mcast_forw_want_all_ipv4(struct batadv_priv *bat_priv,
 			break;
 		}
 
-		batadv_send_skb_unicast(bat_priv, newskb, BATADV_UNICAST, 0,
-					orig_node, vid);
+		batadv_mcast_forw_send_orig(bat_priv, newskb, vid, orig_node);
 	}
 	rcu_read_unlock();
 	return ret;
@@ -1551,8 +1580,7 @@ batadv_mcast_forw_want_all_ipv6(struct batadv_priv *bat_priv,
 			break;
 		}
 
-		batadv_send_skb_unicast(bat_priv, newskb, BATADV_UNICAST, 0,
-					orig_node, vid);
+		batadv_mcast_forw_send_orig(bat_priv, newskb, vid, orig_node);
 	}
 	rcu_read_unlock();
 	return ret;
@@ -1618,8 +1646,7 @@ batadv_mcast_forw_want_all_rtr4(struct batadv_priv *bat_priv,
 			break;
 		}
 
-		batadv_send_skb_unicast(bat_priv, newskb, BATADV_UNICAST, 0,
-					orig_node, vid);
+		batadv_mcast_forw_send_orig(bat_priv, newskb, vid, orig_node);
 	}
 	rcu_read_unlock();
 	return ret;
@@ -1656,8 +1683,7 @@ batadv_mcast_forw_want_all_rtr6(struct batadv_priv *bat_priv,
 			break;
 		}
 
-		batadv_send_skb_unicast(bat_priv, newskb, BATADV_UNICAST, 0,
-					orig_node, vid);
+		batadv_mcast_forw_send_orig(bat_priv, newskb, vid, orig_node);
 	}
 	rcu_read_unlock();
 	return ret;
diff --git a/net/batman-adv/multicast.h b/net/batman-adv/multicast.h
index ebf825991ecd..3e114bc5ca3b 100644
--- a/net/batman-adv/multicast.h
+++ b/net/batman-adv/multicast.h
@@ -46,6 +46,11 @@ enum batadv_forw_mode
 batadv_mcast_forw_mode(struct batadv_priv *bat_priv, struct sk_buff *skb,
 		       struct batadv_orig_node **mcast_single_orig);
 
+int batadv_mcast_forw_send_orig(struct batadv_priv *bat_priv,
+				struct sk_buff *skb,
+				unsigned short vid,
+				struct batadv_orig_node *orig_node);
+
 int batadv_mcast_forw_send(struct batadv_priv *bat_priv, struct sk_buff *skb,
 			   unsigned short vid);
 
@@ -71,6 +76,16 @@ batadv_mcast_forw_mode(struct batadv_priv *bat_priv, struct sk_buff *skb,
 	return BATADV_FORW_ALL;
 }
 
+static inline int
+batadv_mcast_forw_send_orig(struct batadv_priv *bat_priv,
+			    struct sk_buff *skb,
+			    unsigned short vid,
+			    struct batadv_orig_node *orig_node)
+{
+	kfree_skb(skb);
+	return NET_XMIT_DROP;
+}
+
 static inline int
 batadv_mcast_forw_send(struct batadv_priv *bat_priv, struct sk_buff *skb,
 		       unsigned short vid)
diff --git a/net/batman-adv/soft-interface.c b/net/batman-adv/soft-interface.c
index 23833a0ba5e6..3d037b17f3a7 100644
--- a/net/batman-adv/soft-interface.c
+++ b/net/batman-adv/soft-interface.c
@@ -364,9 +364,8 @@ static netdev_tx_t batadv_interface_tx(struct sk_buff *skb,
 				goto dropped;
 			ret = batadv_send_skb_via_gw(bat_priv, skb, vid);
 		} else if (mcast_single_orig) {
-			ret = batadv_send_skb_unicast(bat_priv, skb,
-						      BATADV_UNICAST, 0,
-						      mcast_single_orig, vid);
+			ret = batadv_mcast_forw_send_orig(bat_priv, skb, vid,
+							  mcast_single_orig);
 		} else if (forw_mode == BATADV_FORW_SOME) {
 			ret = batadv_mcast_forw_send(bat_priv, skb, vid);
 		} else {
-- 
2.20.1

