Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4B0B20F07C
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 10:28:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731476AbgF3I2C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 04:28:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731462AbgF3I14 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 04:27:56 -0400
Received: from simonwunderlich.de (packetmixer.de [IPv6:2001:4d88:2000:24::c0de])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4604C03E979
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 01:27:55 -0700 (PDT)
Received: from kero.packetmixer.de (p4fd575ab.dip0.t-ipconnect.de [79.213.117.171])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by simonwunderlich.de (Postfix) with ESMTPSA id 74CA96206C;
        Tue, 30 Jun 2020 10:27:53 +0200 (CEST)
From:   Simon Wunderlich <sw@simonwunderlich.de>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, b.a.t.m.a.n@lists.open-mesh.org,
        =?UTF-8?q?Linus=20L=C3=BCssing?= <linus.luessing@c0d3.blue>,
        Sven Eckelmann <sven@narfation.org>,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 4/4] batman-adv: Introduce a configurable per interface hop penalty
Date:   Tue, 30 Jun 2020 10:27:31 +0200
Message-Id: <20200630082731.2397-5-sw@simonwunderlich.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200630082731.2397-1-sw@simonwunderlich.de>
References: <20200630082731.2397-1-sw@simonwunderlich.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Linus Lüssing <linus.luessing@c0d3.blue>

In some setups multiple hard interfaces with similar link qualities
or throughput values are available. But people have expressed the desire
to consider one of them as a backup only.

Some creative solutions are currently in use: Such people are
configuring multiple batman-adv mesh/soft interfaces, wire them
together with some veth pairs and then tune the hop penalty to achieve
an effect similar to a tunable per interface hop penalty.

This patch introduces a new, configurable, per hard interface hop penalty
to simplify such setups.

Signed-off-by: Linus Lüssing <linus.luessing@c0d3.blue>
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
---
 include/uapi/linux/batman_adv.h |  3 ++-
 net/batman-adv/bat_iv_ogm.c     | 17 +++++++++--------
 net/batman-adv/bat_v_ogm.c      | 13 ++++++++++---
 net/batman-adv/hard-interface.c |  2 ++
 net/batman-adv/netlink.c        | 12 +++++++++++-
 net/batman-adv/types.h          |  6 ++++++
 6 files changed, 40 insertions(+), 13 deletions(-)

diff --git a/include/uapi/linux/batman_adv.h b/include/uapi/linux/batman_adv.h
index 8cf2ad11ead9..bb0ae945b36a 100644
--- a/include/uapi/linux/batman_adv.h
+++ b/include/uapi/linux/batman_adv.h
@@ -427,7 +427,8 @@ enum batadv_nl_attrs {
 
 	/**
 	 * @BATADV_ATTR_HOP_PENALTY: defines the penalty which will be applied
-	 *  to an originator message's tq-field on every hop.
+	 *  to an originator message's tq-field on every hop and/or per
+	 *  hard interface
 	 */
 	BATADV_ATTR_HOP_PENALTY,
 
diff --git a/net/batman-adv/bat_iv_ogm.c b/net/batman-adv/bat_iv_ogm.c
index 5b3a41983156..a4faf5f904d9 100644
--- a/net/batman-adv/bat_iv_ogm.c
+++ b/net/batman-adv/bat_iv_ogm.c
@@ -1075,10 +1075,10 @@ static bool batadv_iv_ogm_calc_tq(struct batadv_orig_node *orig_node,
 	struct batadv_neigh_ifinfo *neigh_ifinfo;
 	u8 total_count;
 	u8 orig_eq_count, neigh_rq_count, neigh_rq_inv, tq_own;
+	unsigned int tq_iface_hop_penalty = BATADV_TQ_MAX_VALUE;
 	unsigned int neigh_rq_inv_cube, neigh_rq_max_cube;
 	unsigned int tq_asym_penalty, inv_asym_penalty;
 	unsigned int combined_tq;
-	unsigned int tq_iface_penalty;
 	bool ret = false;
 
 	/* find corresponding one hop neighbor */
@@ -1157,31 +1157,32 @@ static bool batadv_iv_ogm_calc_tq(struct batadv_orig_node *orig_node,
 	inv_asym_penalty = BATADV_TQ_MAX_VALUE * neigh_rq_inv_cube;
 	inv_asym_penalty /= neigh_rq_max_cube;
 	tq_asym_penalty = BATADV_TQ_MAX_VALUE - inv_asym_penalty;
+	tq_iface_hop_penalty -= atomic_read(&if_incoming->hop_penalty);
 
 	/* penalize if the OGM is forwarded on the same interface. WiFi
 	 * interfaces and other half duplex devices suffer from throughput
 	 * drops as they can't send and receive at the same time.
 	 */
-	tq_iface_penalty = BATADV_TQ_MAX_VALUE;
 	if (if_outgoing && if_incoming == if_outgoing &&
 	    batadv_is_wifi_hardif(if_outgoing))
-		tq_iface_penalty = batadv_hop_penalty(BATADV_TQ_MAX_VALUE,
-						      bat_priv);
+		tq_iface_hop_penalty = batadv_hop_penalty(tq_iface_hop_penalty,
+							  bat_priv);
 
 	combined_tq = batadv_ogm_packet->tq *
 		      tq_own *
 		      tq_asym_penalty *
-		      tq_iface_penalty;
+		      tq_iface_hop_penalty;
 	combined_tq /= BATADV_TQ_MAX_VALUE *
 		       BATADV_TQ_MAX_VALUE *
 		       BATADV_TQ_MAX_VALUE;
 	batadv_ogm_packet->tq = combined_tq;
 
 	batadv_dbg(BATADV_DBG_BATMAN, bat_priv,
-		   "bidirectional: orig = %pM neigh = %pM => own_bcast = %2i, real recv = %2i, local tq: %3i, asym_penalty: %3i, iface_penalty: %3i, total tq: %3i, if_incoming = %s, if_outgoing = %s\n",
+		   "bidirectional: orig = %pM neigh = %pM => own_bcast = %2i, real recv = %2i, local tq: %3i, asym_penalty: %3i, iface_hop_penalty: %3i, total tq: %3i, if_incoming = %s, if_outgoing = %s\n",
 		   orig_node->orig, orig_neigh_node->orig, total_count,
-		   neigh_rq_count, tq_own, tq_asym_penalty, tq_iface_penalty,
-		   batadv_ogm_packet->tq, if_incoming->net_dev->name,
+		   neigh_rq_count, tq_own, tq_asym_penalty,
+		   tq_iface_hop_penalty, batadv_ogm_packet->tq,
+		   if_incoming->net_dev->name,
 		   if_outgoing ? if_outgoing->net_dev->name : "DEFAULT");
 
 	/* if link has the minimum required transmission quality
diff --git a/net/batman-adv/bat_v_ogm.c b/net/batman-adv/bat_v_ogm.c
index 0d404f7bcd9f..0f8495b9eeb1 100644
--- a/net/batman-adv/bat_v_ogm.c
+++ b/net/batman-adv/bat_v_ogm.c
@@ -455,15 +455,17 @@ void batadv_v_ogm_primary_iface_set(struct batadv_hard_iface *primary_iface)
  * @throughput: the current throughput
  *
  * Apply a penalty on the current throughput metric value based on the
- * characteristic of the interface where the OGM has been received. The return
- * value is computed as follows:
+ * characteristic of the interface where the OGM has been received.
+ *
+ * Initially the per hardif hop penalty is applied to the throughput. After
+ * that the return value is then computed as follows:
  * - throughput * 50%          if the incoming and outgoing interface are the
  *                             same WiFi interface and the throughput is above
  *                             1MBit/s
  * - throughput                if the outgoing interface is the default
  *                             interface (i.e. this OGM is processed for the
  *                             internal table and not forwarded)
- * - throughput * hop penalty  otherwise
+ * - throughput * node hop penalty  otherwise
  *
  * Return: the penalised throughput metric.
  */
@@ -472,9 +474,14 @@ static u32 batadv_v_forward_penalty(struct batadv_priv *bat_priv,
 				    struct batadv_hard_iface *if_outgoing,
 				    u32 throughput)
 {
+	int if_hop_penalty = atomic_read(&if_incoming->hop_penalty);
 	int hop_penalty = atomic_read(&bat_priv->hop_penalty);
 	int hop_penalty_max = BATADV_TQ_MAX_VALUE;
 
+	/* Apply per hardif hop penalty */
+	throughput = throughput * (hop_penalty_max - if_hop_penalty) /
+		     hop_penalty_max;
+
 	/* Don't apply hop penalty in default originator table. */
 	if (if_outgoing == BATADV_IF_DEFAULT)
 		return throughput;
diff --git a/net/batman-adv/hard-interface.c b/net/batman-adv/hard-interface.c
index 53c27c67cc11..fa06b51c0144 100644
--- a/net/batman-adv/hard-interface.c
+++ b/net/batman-adv/hard-interface.c
@@ -939,6 +939,8 @@ batadv_hardif_add_interface(struct net_device *net_dev)
 	if (batadv_is_wifi_hardif(hard_iface))
 		hard_iface->num_bcasts = BATADV_NUM_BCASTS_WIRELESS;
 
+	atomic_set(&hard_iface->hop_penalty, 0);
+
 	batadv_v_hardif_init(hard_iface);
 
 	batadv_check_known_mac_addr(hard_iface->net_dev);
diff --git a/net/batman-adv/netlink.c b/net/batman-adv/netlink.c
index cfb00dfa468a..dc193618a761 100644
--- a/net/batman-adv/netlink.c
+++ b/net/batman-adv/netlink.c
@@ -826,6 +826,10 @@ static int batadv_netlink_hardif_fill(struct sk_buff *msg,
 			goto nla_put_failure;
 	}
 
+	if (nla_put_u8(msg, BATADV_ATTR_HOP_PENALTY,
+		       atomic_read(&hard_iface->hop_penalty)))
+		goto nla_put_failure;
+
 #ifdef CONFIG_BATMAN_ADV_BATMAN_V
 	if (nla_put_u32(msg, BATADV_ATTR_ELP_INTERVAL,
 			atomic_read(&hard_iface->bat_v.elp_interval)))
@@ -920,9 +924,15 @@ static int batadv_netlink_set_hardif(struct sk_buff *skb,
 {
 	struct batadv_hard_iface *hard_iface = info->user_ptr[1];
 	struct batadv_priv *bat_priv = info->user_ptr[0];
+	struct nlattr *attr;
+
+	if (info->attrs[BATADV_ATTR_HOP_PENALTY]) {
+		attr = info->attrs[BATADV_ATTR_HOP_PENALTY];
+
+		atomic_set(&hard_iface->hop_penalty, nla_get_u8(attr));
+	}
 
 #ifdef CONFIG_BATMAN_ADV_BATMAN_V
-	struct nlattr *attr;
 
 	if (info->attrs[BATADV_ATTR_ELP_INTERVAL]) {
 		attr = info->attrs[BATADV_ATTR_ELP_INTERVAL];
diff --git a/net/batman-adv/types.h b/net/batman-adv/types.h
index cc151e1f23b2..ed519efa3c36 100644
--- a/net/batman-adv/types.h
+++ b/net/batman-adv/types.h
@@ -208,6 +208,12 @@ struct batadv_hard_iface {
 	/** @rcu: struct used for freeing in an RCU-safe manner */
 	struct rcu_head rcu;
 
+	/**
+	 * @hop_penalty: penalty which will be applied to the tq-field
+	 * of an OGM received via this interface
+	 */
+	atomic_t hop_penalty;
+
 	/** @bat_iv: per hard-interface B.A.T.M.A.N. IV data */
 	struct batadv_hard_iface_bat_iv bat_iv;
 
-- 
2.20.1

