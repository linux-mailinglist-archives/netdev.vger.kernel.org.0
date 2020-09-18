Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B19A26FE26
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 15:22:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726783AbgIRNUO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 09:20:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726629AbgIRNUF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 09:20:05 -0400
Received: from simonwunderlich.de (packetmixer.de [IPv6:2001:4d88:2000:24::c0de])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88D01C06174A
        for <netdev@vger.kernel.org>; Fri, 18 Sep 2020 06:20:04 -0700 (PDT)
Received: from kero.packetmixer.de (p200300c59714ead05d12fb7f5a0314d0.dip0.t-ipconnect.de [IPv6:2003:c5:9714:ead0:5d12:fb7f:5a03:14d0])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by simonwunderlich.de (Postfix) with ESMTPSA id 942AB6207A;
        Fri, 18 Sep 2020 15:20:00 +0200 (CEST)
From:   Simon Wunderlich <sw@simonwunderlich.de>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, b.a.t.m.a.n@lists.open-mesh.org,
        =?UTF-8?q?Linus=20L=C3=BCssing?= <linus.luessing@c0d3.blue>,
        Sven Eckelmann <sven@narfation.org>,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 6/6] batman-adv: mcast: fix duplicate mcast packets from BLA backbone to mesh
Date:   Fri, 18 Sep 2020 15:19:56 +0200
Message-Id: <20200918131956.21598-7-sw@simonwunderlich.de>
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
* Multicast frame send from BLA backbone gateways (multiple nodes
  with their bat0 bridged together, with BLA enabled) sharing the same
  LAN to nodes in the mesh

Issue:
* Nodes receive the frame multiple times on bat0 from the mesh,
  once from each foreign BLA backbone gateway which shares the same LAN
  with another

For multicast frames via batman-adv broadcast packets coming from the
same BLA backbone but from different backbone gateways duplicates are
currently detected via a CRC history of previously received packets.

However this CRC so far was not performed for multicast frames received
via batman-adv unicast packets. Fixing this by appyling the same check
for such packets, too.

Room for improvements in the future: Ideally we would introduce the
possibility to not only claim a client, but a complete originator, too.
This would allow us to only send a multicast-in-unicast packet from a BLA
backbone gateway claiming the node and by that avoid potential redundant
transmissions in the first place.

Fixes: 279e89b2281a ("batman-adv: add broadcast duplicate check")
Signed-off-by: Linus Lüssing <linus.luessing@c0d3.blue>
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
---
 net/batman-adv/bridge_loop_avoidance.c | 103 +++++++++++++++++++++----
 1 file changed, 87 insertions(+), 16 deletions(-)

diff --git a/net/batman-adv/bridge_loop_avoidance.c b/net/batman-adv/bridge_loop_avoidance.c
index 68715783a742..c350ab63cd54 100644
--- a/net/batman-adv/bridge_loop_avoidance.c
+++ b/net/batman-adv/bridge_loop_avoidance.c
@@ -1581,13 +1581,16 @@ int batadv_bla_init(struct batadv_priv *bat_priv)
 }
 
 /**
- * batadv_bla_check_bcast_duplist() - Check if a frame is in the broadcast dup.
+ * batadv_bla_check_duplist() - Check if a frame is in the broadcast dup.
  * @bat_priv: the bat priv with all the soft interface information
- * @skb: contains the bcast_packet to be checked
+ * @skb: contains the multicast packet to be checked
+ * @payload_ptr: pointer to position inside the head buffer of the skb
+ *  marking the start of the data to be CRC'ed
+ * @orig: originator mac address, NULL if unknown
  *
- * check if it is on our broadcast list. Another gateway might
- * have sent the same packet because it is connected to the same backbone,
- * so we have to remove this duplicate.
+ * Check if it is on our broadcast list. Another gateway might have sent the
+ * same packet because it is connected to the same backbone, so we have to
+ * remove this duplicate.
  *
  * This is performed by checking the CRC, which will tell us
  * with a good chance that it is the same packet. If it is furthermore
@@ -1596,19 +1599,17 @@ int batadv_bla_init(struct batadv_priv *bat_priv)
  *
  * Return: true if a packet is in the duplicate list, false otherwise.
  */
-bool batadv_bla_check_bcast_duplist(struct batadv_priv *bat_priv,
-				    struct sk_buff *skb)
+static bool batadv_bla_check_duplist(struct batadv_priv *bat_priv,
+				     struct sk_buff *skb, u8 *payload_ptr,
+				     const u8 *orig)
 {
-	int i, curr;
-	__be32 crc;
-	struct batadv_bcast_packet *bcast_packet;
 	struct batadv_bcast_duplist_entry *entry;
 	bool ret = false;
-
-	bcast_packet = (struct batadv_bcast_packet *)skb->data;
+	int i, curr;
+	__be32 crc;
 
 	/* calculate the crc ... */
-	crc = batadv_skb_crc32(skb, (u8 *)(bcast_packet + 1));
+	crc = batadv_skb_crc32(skb, payload_ptr);
 
 	spin_lock_bh(&bat_priv->bla.bcast_duplist_lock);
 
@@ -1627,8 +1628,21 @@ bool batadv_bla_check_bcast_duplist(struct batadv_priv *bat_priv,
 		if (entry->crc != crc)
 			continue;
 
-		if (batadv_compare_eth(entry->orig, bcast_packet->orig))
-			continue;
+		/* are the originators both known and not anonymous? */
+		if (orig && !is_zero_ether_addr(orig) &&
+		    !is_zero_ether_addr(entry->orig)) {
+			/* If known, check if the new frame came from
+			 * the same originator:
+			 * We are safe to take identical frames from the
+			 * same orig, if known, as multiplications in
+			 * the mesh are detected via the (orig, seqno) pair.
+			 * So we can be a bit more liberal here and allow
+			 * identical frames from the same orig which the source
+			 * host might have sent multiple times on purpose.
+			 */
+			if (batadv_compare_eth(entry->orig, orig))
+				continue;
+		}
 
 		/* this entry seems to match: same crc, not too old,
 		 * and from another gw. therefore return true to forbid it.
@@ -1644,7 +1658,14 @@ bool batadv_bla_check_bcast_duplist(struct batadv_priv *bat_priv,
 	entry = &bat_priv->bla.bcast_duplist[curr];
 	entry->crc = crc;
 	entry->entrytime = jiffies;
-	ether_addr_copy(entry->orig, bcast_packet->orig);
+
+	/* known originator */
+	if (orig)
+		ether_addr_copy(entry->orig, orig);
+	/* anonymous originator */
+	else
+		eth_zero_addr(entry->orig);
+
 	bat_priv->bla.bcast_duplist_curr = curr;
 
 out:
@@ -1653,6 +1674,48 @@ bool batadv_bla_check_bcast_duplist(struct batadv_priv *bat_priv,
 	return ret;
 }
 
+/**
+ * batadv_bla_check_ucast_duplist() - Check if a frame is in the broadcast dup.
+ * @bat_priv: the bat priv with all the soft interface information
+ * @skb: contains the multicast packet to be checked, decapsulated from a
+ *  unicast_packet
+ *
+ * Check if it is on our broadcast list. Another gateway might have sent the
+ * same packet because it is connected to the same backbone, so we have to
+ * remove this duplicate.
+ *
+ * Return: true if a packet is in the duplicate list, false otherwise.
+ */
+static bool batadv_bla_check_ucast_duplist(struct batadv_priv *bat_priv,
+					   struct sk_buff *skb)
+{
+	return batadv_bla_check_duplist(bat_priv, skb, (u8 *)skb->data, NULL);
+}
+
+/**
+ * batadv_bla_check_bcast_duplist() - Check if a frame is in the broadcast dup.
+ * @bat_priv: the bat priv with all the soft interface information
+ * @skb: contains the bcast_packet to be checked
+ *
+ * Check if it is on our broadcast list. Another gateway might have sent the
+ * same packet because it is connected to the same backbone, so we have to
+ * remove this duplicate.
+ *
+ * Return: true if a packet is in the duplicate list, false otherwise.
+ */
+bool batadv_bla_check_bcast_duplist(struct batadv_priv *bat_priv,
+				    struct sk_buff *skb)
+{
+	struct batadv_bcast_packet *bcast_packet;
+	u8 *payload_ptr;
+
+	bcast_packet = (struct batadv_bcast_packet *)skb->data;
+	payload_ptr = (u8 *)(bcast_packet + 1);
+
+	return batadv_bla_check_duplist(bat_priv, skb, payload_ptr,
+					bcast_packet->orig);
+}
+
 /**
  * batadv_bla_is_backbone_gw_orig() - Check if the originator is a gateway for
  *  the VLAN identified by vid.
@@ -1867,6 +1930,14 @@ bool batadv_bla_rx(struct batadv_priv *bat_priv, struct sk_buff *skb,
 			    packet_type == BATADV_UNICAST)
 				goto handled;
 
+	/* potential duplicates from foreign BLA backbone gateways via
+	 * multicast-in-unicast packets
+	 */
+	if (is_multicast_ether_addr(ethhdr->h_dest) &&
+	    packet_type == BATADV_UNICAST &&
+	    batadv_bla_check_ucast_duplist(bat_priv, skb))
+		goto handled;
+
 	ether_addr_copy(search_claim.addr, ethhdr->h_source);
 	search_claim.vid = vid;
 	claim = batadv_claim_hash_find(bat_priv, &search_claim);
-- 
2.20.1

