Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A10F3F2878
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 10:33:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234461AbhHTIdt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 04:33:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233248AbhHTIdq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Aug 2021 04:33:46 -0400
Received: from simonwunderlich.de (packetmixer.de [IPv6:2001:4d88:2000:24::c0de])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B82DC061757
        for <netdev@vger.kernel.org>; Fri, 20 Aug 2021 01:33:08 -0700 (PDT)
Received: from kero.packetmixer.de (p200300c5970e73c0a32126881010a2d4.dip0.t-ipconnect.de [IPv6:2003:c5:970e:73c0:a321:2688:1010:a2d4])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by simonwunderlich.de (Postfix) with ESMTPSA id 90B19174028;
        Fri, 20 Aug 2021 10:33:06 +0200 (CEST)
From:   Simon Wunderlich <sw@simonwunderlich.de>
To:     kuba@kernel.org, davem@davemloft.net
Cc:     netdev@vger.kernel.org, b.a.t.m.a.n@lists.open-mesh.org,
        Sven Eckelmann <sven@narfation.org>,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 5/6] batman-adv: Drop NULL check before dropping references
Date:   Fri, 20 Aug 2021 10:32:59 +0200
Message-Id: <20210820083300.32289-6-sw@simonwunderlich.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210820083300.32289-1-sw@simonwunderlich.de>
References: <20210820083300.32289-1-sw@simonwunderlich.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sven Eckelmann <sven@narfation.org>

The check if a batman-adv related object is NULL or not is now directly in
the batadv_*_put functions. It is not needed anymore to perform this check
outside these function:

The changes were generated using a coccinelle semantic patch:

  @@
  expression E;
  @@
  - if (likely(E != NULL))
  (
  batadv_backbone_gw_put
  |
  batadv_claim_put
  |
  batadv_dat_entry_put
  |
  batadv_gw_node_put
  |
  batadv_hardif_neigh_put
  |
  batadv_hardif_put
  |
  batadv_nc_node_put
  |
  batadv_nc_path_put
  |
  batadv_neigh_ifinfo_put
  |
  batadv_neigh_node_put
  |
  batadv_orig_ifinfo_put
  |
  batadv_orig_node_put
  |
  batadv_orig_node_vlan_put
  |
  batadv_softif_vlan_put
  |
  batadv_tp_vars_put
  |
  batadv_tt_global_entry_put
  |
  batadv_tt_local_entry_put
  |
  batadv_tt_orig_list_entry_put
  |
  batadv_tt_req_node_put
  |
  batadv_tvlv_container_put
  |
  batadv_tvlv_handler_put
  )(E);

Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
---
 net/batman-adv/bat_iv_ogm.c            | 75 +++++++++----------------
 net/batman-adv/bat_v.c                 | 30 ++++------
 net/batman-adv/bat_v_elp.c             |  9 +--
 net/batman-adv/bat_v_ogm.c             | 39 +++++--------
 net/batman-adv/bridge_loop_avoidance.c | 27 +++------
 net/batman-adv/distributed-arp-table.c | 21 +++----
 net/batman-adv/fragmentation.c         |  6 +-
 net/batman-adv/gateway_client.c        | 45 +++++----------
 net/batman-adv/hard-interface.c        | 21 +++----
 net/batman-adv/multicast.c             |  2 +-
 net/batman-adv/netlink.c               |  6 +-
 net/batman-adv/network-coding.c        | 18 ++----
 net/batman-adv/originator.c            | 30 ++++------
 net/batman-adv/routing.c               | 39 +++++--------
 net/batman-adv/send.c                  | 21 +++----
 net/batman-adv/soft-interface.c        | 12 ++--
 net/batman-adv/tp_meter.c              | 24 +++-----
 net/batman-adv/translation-table.c     | 78 +++++++++-----------------
 net/batman-adv/tvlv.c                  |  3 +-
 19 files changed, 169 insertions(+), 337 deletions(-)

diff --git a/net/batman-adv/bat_iv_ogm.c b/net/batman-adv/bat_iv_ogm.c
index 12022378f892..f94f538fa382 100644
--- a/net/batman-adv/bat_iv_ogm.c
+++ b/net/batman-adv/bat_iv_ogm.c
@@ -519,8 +519,7 @@ batadv_iv_ogm_can_aggregate(const struct batadv_ogm_packet *new_bat_ogm_packet,
 	}
 
 out:
-	if (primary_if)
-		batadv_hardif_put(primary_if);
+	batadv_hardif_put(primary_if);
 	return res;
 }
 
@@ -857,8 +856,7 @@ static void batadv_iv_ogm_schedule_buff(struct batadv_hard_iface *hard_iface)
 	rcu_read_unlock();
 
 out:
-	if (primary_if)
-		batadv_hardif_put(primary_if);
+	batadv_hardif_put(primary_if);
 }
 
 static void batadv_iv_ogm_schedule(struct batadv_hard_iface *hard_iface)
@@ -1046,14 +1044,10 @@ batadv_iv_ogm_orig_update(struct batadv_priv *bat_priv,
 unlock:
 	rcu_read_unlock();
 out:
-	if (neigh_node)
-		batadv_neigh_node_put(neigh_node);
-	if (router)
-		batadv_neigh_node_put(router);
-	if (neigh_ifinfo)
-		batadv_neigh_ifinfo_put(neigh_ifinfo);
-	if (router_ifinfo)
-		batadv_neigh_ifinfo_put(router_ifinfo);
+	batadv_neigh_node_put(neigh_node);
+	batadv_neigh_node_put(router);
+	batadv_neigh_ifinfo_put(neigh_ifinfo);
+	batadv_neigh_ifinfo_put(router_ifinfo);
 }
 
 /**
@@ -1194,8 +1188,7 @@ static bool batadv_iv_ogm_calc_tq(struct batadv_orig_node *orig_node,
 		ret = true;
 
 out:
-	if (neigh_node)
-		batadv_neigh_node_put(neigh_node);
+	batadv_neigh_node_put(neigh_node);
 	return ret;
 }
 
@@ -1496,16 +1489,11 @@ batadv_iv_ogm_process_per_outif(const struct sk_buff *skb, int ogm_offset,
 	if (orig_neigh_node && !is_single_hop_neigh)
 		batadv_orig_node_put(orig_neigh_node);
 out:
-	if (router_ifinfo)
-		batadv_neigh_ifinfo_put(router_ifinfo);
-	if (router)
-		batadv_neigh_node_put(router);
-	if (router_router)
-		batadv_neigh_node_put(router_router);
-	if (orig_neigh_router)
-		batadv_neigh_node_put(orig_neigh_router);
-	if (hardif_neigh)
-		batadv_hardif_neigh_put(hardif_neigh);
+	batadv_neigh_ifinfo_put(router_ifinfo);
+	batadv_neigh_node_put(router);
+	batadv_neigh_node_put(router_router);
+	batadv_neigh_node_put(orig_neigh_router);
+	batadv_hardif_neigh_put(hardif_neigh);
 
 	consume_skb(skb_priv);
 }
@@ -1926,8 +1914,7 @@ batadv_iv_ogm_orig_dump_entry(struct sk_buff *msg, u32 portid, u32 seq,
 	}
 
  out:
-	if (neigh_node_best)
-		batadv_neigh_node_put(neigh_node_best);
+	batadv_neigh_node_put(neigh_node_best);
 
 	*sub_s = 0;
 	return 0;
@@ -2049,10 +2036,8 @@ static bool batadv_iv_ogm_neigh_diff(struct batadv_neigh_node *neigh1,
 	*diff = (int)tq1 - (int)tq2;
 
 out:
-	if (neigh1_ifinfo)
-		batadv_neigh_ifinfo_put(neigh1_ifinfo);
-	if (neigh2_ifinfo)
-		batadv_neigh_ifinfo_put(neigh2_ifinfo);
+	batadv_neigh_ifinfo_put(neigh1_ifinfo);
+	batadv_neigh_ifinfo_put(neigh2_ifinfo);
 
 	return ret;
 }
@@ -2299,8 +2284,7 @@ batadv_iv_gw_get_best_gw_node(struct batadv_priv *bat_priv)
 			if (tmp_gw_factor > max_gw_factor ||
 			    (tmp_gw_factor == max_gw_factor &&
 			     tq_avg > max_tq)) {
-				if (curr_gw)
-					batadv_gw_node_put(curr_gw);
+				batadv_gw_node_put(curr_gw);
 				curr_gw = gw_node;
 				kref_get(&curr_gw->refcount);
 			}
@@ -2314,8 +2298,7 @@ batadv_iv_gw_get_best_gw_node(struct batadv_priv *bat_priv)
 			  *     $routing_class more tq points)
 			  */
 			if (tq_avg > max_tq) {
-				if (curr_gw)
-					batadv_gw_node_put(curr_gw);
+				batadv_gw_node_put(curr_gw);
 				curr_gw = gw_node;
 				kref_get(&curr_gw->refcount);
 			}
@@ -2332,8 +2315,7 @@ batadv_iv_gw_get_best_gw_node(struct batadv_priv *bat_priv)
 
 next:
 		batadv_neigh_node_put(router);
-		if (router_ifinfo)
-			batadv_neigh_ifinfo_put(router_ifinfo);
+		batadv_neigh_ifinfo_put(router_ifinfo);
 	}
 	rcu_read_unlock();
 
@@ -2397,14 +2379,10 @@ static bool batadv_iv_gw_is_eligible(struct batadv_priv *bat_priv,
 
 	ret = true;
 out:
-	if (router_gw_ifinfo)
-		batadv_neigh_ifinfo_put(router_gw_ifinfo);
-	if (router_orig_ifinfo)
-		batadv_neigh_ifinfo_put(router_orig_ifinfo);
-	if (router_gw)
-		batadv_neigh_node_put(router_gw);
-	if (router_orig)
-		batadv_neigh_node_put(router_orig);
+	batadv_neigh_ifinfo_put(router_gw_ifinfo);
+	batadv_neigh_ifinfo_put(router_orig_ifinfo);
+	batadv_neigh_node_put(router_gw);
+	batadv_neigh_node_put(router_orig);
 
 	return ret;
 }
@@ -2479,12 +2457,9 @@ static int batadv_iv_gw_dump_entry(struct sk_buff *msg, u32 portid,
 	ret = 0;
 
 out:
-	if (curr_gw)
-		batadv_gw_node_put(curr_gw);
-	if (router_ifinfo)
-		batadv_neigh_ifinfo_put(router_ifinfo);
-	if (router)
-		batadv_neigh_node_put(router);
+	batadv_gw_node_put(curr_gw);
+	batadv_neigh_ifinfo_put(router_ifinfo);
+	batadv_neigh_node_put(router);
 	return ret;
 }
 
diff --git a/net/batman-adv/bat_v.c b/net/batman-adv/bat_v.c
index b98aea958e3d..54e41fc709c3 100644
--- a/net/batman-adv/bat_v.c
+++ b/net/batman-adv/bat_v.c
@@ -106,8 +106,7 @@ static void batadv_v_iface_update_mac(struct batadv_hard_iface *hard_iface)
 
 	batadv_v_primary_iface_set(hard_iface);
 out:
-	if (primary_if)
-		batadv_hardif_put(primary_if);
+	batadv_hardif_put(primary_if);
 }
 
 static void
@@ -366,8 +365,7 @@ batadv_v_orig_dump_entry(struct sk_buff *msg, u32 portid, u32 seq,
 	}
 
  out:
-	if (neigh_node_best)
-		batadv_neigh_node_put(neigh_node_best);
+	batadv_neigh_node_put(neigh_node_best);
 
 	*sub_s = 0;
 	return 0;
@@ -568,10 +566,8 @@ static int batadv_v_gw_throughput_get(struct batadv_gw_node *gw_node, u32 *bw)
 
 	ret = 0;
 out:
-	if (router)
-		batadv_neigh_node_put(router);
-	if (router_ifinfo)
-		batadv_neigh_ifinfo_put(router_ifinfo);
+	batadv_neigh_node_put(router);
+	batadv_neigh_ifinfo_put(router_ifinfo);
 
 	return ret;
 }
@@ -599,8 +595,7 @@ batadv_v_gw_get_best_gw_node(struct batadv_priv *bat_priv)
 		if (curr_gw && bw <= max_bw)
 			goto next;
 
-		if (curr_gw)
-			batadv_gw_node_put(curr_gw);
+		batadv_gw_node_put(curr_gw);
 
 		curr_gw = gw_node;
 		kref_get(&curr_gw->refcount);
@@ -662,10 +657,8 @@ static bool batadv_v_gw_is_eligible(struct batadv_priv *bat_priv,
 
 	ret = true;
 out:
-	if (curr_gw)
-		batadv_gw_node_put(curr_gw);
-	if (orig_gw)
-		batadv_gw_node_put(orig_gw);
+	batadv_gw_node_put(curr_gw);
+	batadv_gw_node_put(orig_gw);
 
 	return ret;
 }
@@ -764,12 +757,9 @@ static int batadv_v_gw_dump_entry(struct sk_buff *msg, u32 portid,
 	ret = 0;
 
 out:
-	if (curr_gw)
-		batadv_gw_node_put(curr_gw);
-	if (router_ifinfo)
-		batadv_neigh_ifinfo_put(router_ifinfo);
-	if (router)
-		batadv_neigh_node_put(router);
+	batadv_gw_node_put(curr_gw);
+	batadv_neigh_ifinfo_put(router_ifinfo);
+	batadv_neigh_node_put(router);
 	return ret;
 }
 
diff --git a/net/batman-adv/bat_v_elp.c b/net/batman-adv/bat_v_elp.c
index 423c2d171703..71999e13f729 100644
--- a/net/batman-adv/bat_v_elp.c
+++ b/net/batman-adv/bat_v_elp.c
@@ -486,14 +486,11 @@ static void batadv_v_elp_neigh_update(struct batadv_priv *bat_priv,
 	hardif_neigh->bat_v.elp_interval = ntohl(elp_packet->elp_interval);
 
 hardif_free:
-	if (hardif_neigh)
-		batadv_hardif_neigh_put(hardif_neigh);
+	batadv_hardif_neigh_put(hardif_neigh);
 neigh_free:
-	if (neigh)
-		batadv_neigh_node_put(neigh);
+	batadv_neigh_node_put(neigh);
 orig_free:
-	if (orig_neigh)
-		batadv_orig_node_put(orig_neigh);
+	batadv_orig_node_put(orig_neigh);
 }
 
 /**
diff --git a/net/batman-adv/bat_v_ogm.c b/net/batman-adv/bat_v_ogm.c
index a0a9636d1740..1d750f3cb2e4 100644
--- a/net/batman-adv/bat_v_ogm.c
+++ b/net/batman-adv/bat_v_ogm.c
@@ -584,12 +584,9 @@ static void batadv_v_ogm_forward(struct batadv_priv *bat_priv,
 	batadv_v_ogm_queue_on_if(skb, if_outgoing);
 
 out:
-	if (orig_ifinfo)
-		batadv_orig_ifinfo_put(orig_ifinfo);
-	if (router)
-		batadv_neigh_node_put(router);
-	if (neigh_ifinfo)
-		batadv_neigh_ifinfo_put(neigh_ifinfo);
+	batadv_orig_ifinfo_put(orig_ifinfo);
+	batadv_neigh_node_put(router);
+	batadv_neigh_ifinfo_put(neigh_ifinfo);
 }
 
 /**
@@ -669,10 +666,8 @@ static int batadv_v_ogm_metric_update(struct batadv_priv *bat_priv,
 	else
 		ret = 0;
 out:
-	if (orig_ifinfo)
-		batadv_orig_ifinfo_put(orig_ifinfo);
-	if (neigh_ifinfo)
-		batadv_neigh_ifinfo_put(neigh_ifinfo);
+	batadv_orig_ifinfo_put(orig_ifinfo);
+	batadv_neigh_ifinfo_put(neigh_ifinfo);
 
 	return ret;
 }
@@ -763,16 +758,11 @@ static bool batadv_v_ogm_route_update(struct batadv_priv *bat_priv,
 
 	batadv_update_route(bat_priv, orig_node, if_outgoing, neigh_node);
 out:
-	if (router)
-		batadv_neigh_node_put(router);
-	if (orig_neigh_router)
-		batadv_neigh_node_put(orig_neigh_router);
-	if (orig_neigh_node)
-		batadv_orig_node_put(orig_neigh_node);
-	if (router_ifinfo)
-		batadv_neigh_ifinfo_put(router_ifinfo);
-	if (neigh_ifinfo)
-		batadv_neigh_ifinfo_put(neigh_ifinfo);
+	batadv_neigh_node_put(router);
+	batadv_neigh_node_put(orig_neigh_router);
+	batadv_orig_node_put(orig_neigh_node);
+	batadv_neigh_ifinfo_put(router_ifinfo);
+	batadv_neigh_ifinfo_put(neigh_ifinfo);
 
 	return forward;
 }
@@ -978,12 +968,9 @@ static void batadv_v_ogm_process(const struct sk_buff *skb, int ogm_offset,
 	}
 	rcu_read_unlock();
 out:
-	if (orig_node)
-		batadv_orig_node_put(orig_node);
-	if (neigh_node)
-		batadv_neigh_node_put(neigh_node);
-	if (hardif_neigh)
-		batadv_hardif_neigh_put(hardif_neigh);
+	batadv_orig_node_put(orig_node);
+	batadv_neigh_node_put(neigh_node);
+	batadv_hardif_neigh_put(hardif_neigh);
 }
 
 /**
diff --git a/net/batman-adv/bridge_loop_avoidance.c b/net/batman-adv/bridge_loop_avoidance.c
index 134db98a4606..1669744304c5 100644
--- a/net/batman-adv/bridge_loop_avoidance.c
+++ b/net/batman-adv/bridge_loop_avoidance.c
@@ -445,8 +445,7 @@ static void batadv_bla_send_claim(struct batadv_priv *bat_priv, u8 *mac,
 
 	netif_rx_any_context(skb);
 out:
-	if (primary_if)
-		batadv_hardif_put(primary_if);
+	batadv_hardif_put(primary_if);
 }
 
 /**
@@ -1504,8 +1503,7 @@ static void batadv_bla_periodic_work(struct work_struct *work)
 		rcu_read_unlock();
 	}
 out:
-	if (primary_if)
-		batadv_hardif_put(primary_if);
+	batadv_hardif_put(primary_if);
 
 	queue_delayed_work(batadv_event_workqueue, &bat_priv->bla.work,
 			   msecs_to_jiffies(BATADV_BLA_PERIOD_LENGTH));
@@ -1814,8 +1812,7 @@ void batadv_bla_free(struct batadv_priv *bat_priv)
 		batadv_hash_destroy(bat_priv->bla.backbone_hash);
 		bat_priv->bla.backbone_hash = NULL;
 	}
-	if (primary_if)
-		batadv_hardif_put(primary_if);
+	batadv_hardif_put(primary_if);
 }
 
 /**
@@ -2002,10 +1999,8 @@ bool batadv_bla_rx(struct batadv_priv *bat_priv, struct sk_buff *skb,
 	ret = true;
 
 out:
-	if (primary_if)
-		batadv_hardif_put(primary_if);
-	if (claim)
-		batadv_claim_put(claim);
+	batadv_hardif_put(primary_if);
+	batadv_claim_put(claim);
 	return ret;
 }
 
@@ -2109,10 +2104,8 @@ bool batadv_bla_tx(struct batadv_priv *bat_priv, struct sk_buff *skb,
 handled:
 	ret = true;
 out:
-	if (primary_if)
-		batadv_hardif_put(primary_if);
-	if (claim)
-		batadv_claim_put(claim);
+	batadv_hardif_put(primary_if);
+	batadv_claim_put(claim);
 	return ret;
 }
 
@@ -2277,8 +2270,7 @@ int batadv_bla_claim_dump(struct sk_buff *msg, struct netlink_callback *cb)
 	ret = msg->len;
 
 out:
-	if (primary_if)
-		batadv_hardif_put(primary_if);
+	batadv_hardif_put(primary_if);
 
 	dev_put(soft_iface);
 
@@ -2448,8 +2440,7 @@ int batadv_bla_backbone_dump(struct sk_buff *msg, struct netlink_callback *cb)
 	ret = msg->len;
 
 out:
-	if (primary_if)
-		batadv_hardif_put(primary_if);
+	batadv_hardif_put(primary_if);
 
 	dev_put(soft_iface);
 
diff --git a/net/batman-adv/distributed-arp-table.c b/net/batman-adv/distributed-arp-table.c
index 60f1ae1abd81..2f008e329007 100644
--- a/net/batman-adv/distributed-arp-table.c
+++ b/net/batman-adv/distributed-arp-table.c
@@ -408,8 +408,7 @@ static void batadv_dat_entry_add(struct batadv_priv *bat_priv, __be32 ip,
 		   &dat_entry->ip, dat_entry->mac_addr, batadv_print_vid(vid));
 
 out:
-	if (dat_entry)
-		batadv_dat_entry_put(dat_entry);
+	batadv_dat_entry_put(dat_entry);
 }
 
 #ifdef CONFIG_BATMAN_ADV_DEBUG
@@ -597,8 +596,7 @@ static void batadv_choose_next_candidate(struct batadv_priv *bat_priv,
 				continue;
 
 			max = tmp_max;
-			if (max_orig_node)
-				batadv_orig_node_put(max_orig_node);
+			batadv_orig_node_put(max_orig_node);
 			max_orig_node = orig_node;
 		}
 		rcu_read_unlock();
@@ -984,8 +982,7 @@ int batadv_dat_cache_dump(struct sk_buff *msg, struct netlink_callback *cb)
 	ret = msg->len;
 
 out:
-	if (primary_if)
-		batadv_hardif_put(primary_if);
+	batadv_hardif_put(primary_if);
 
 	dev_put(soft_iface);
 
@@ -1220,8 +1217,7 @@ bool batadv_dat_snoop_outgoing_arp_request(struct batadv_priv *bat_priv,
 					      BATADV_P_DAT_DHT_GET);
 	}
 out:
-	if (dat_entry)
-		batadv_dat_entry_put(dat_entry);
+	batadv_dat_entry_put(dat_entry);
 	return ret;
 }
 
@@ -1288,8 +1284,7 @@ bool batadv_dat_snoop_incoming_arp_request(struct batadv_priv *bat_priv,
 		ret = true;
 	}
 out:
-	if (dat_entry)
-		batadv_dat_entry_put(dat_entry);
+	batadv_dat_entry_put(dat_entry);
 	if (ret)
 		kfree_skb(skb);
 	return ret;
@@ -1422,8 +1417,7 @@ bool batadv_dat_snoop_incoming_arp_reply(struct batadv_priv *bat_priv,
 out:
 	if (dropped)
 		kfree_skb(skb);
-	if (dat_entry)
-		batadv_dat_entry_put(dat_entry);
+	batadv_dat_entry_put(dat_entry);
 	/* if dropped == false -> deliver to the interface */
 	return dropped;
 }
@@ -1832,7 +1826,6 @@ bool batadv_dat_drop_broadcast_packet(struct batadv_priv *bat_priv,
 	ret = true;
 
 out:
-	if (dat_entry)
-		batadv_dat_entry_put(dat_entry);
+	batadv_dat_entry_put(dat_entry);
 	return ret;
 }
diff --git a/net/batman-adv/fragmentation.c b/net/batman-adv/fragmentation.c
index a5d9d800082b..0899a729a23f 100644
--- a/net/batman-adv/fragmentation.c
+++ b/net/batman-adv/fragmentation.c
@@ -381,10 +381,8 @@ bool batadv_frag_skb_fwd(struct sk_buff *skb,
 	}
 
 out:
-	if (orig_node_dst)
-		batadv_orig_node_put(orig_node_dst);
-	if (neigh_node)
-		batadv_neigh_node_put(neigh_node);
+	batadv_orig_node_put(orig_node_dst);
+	batadv_neigh_node_put(neigh_node);
 	return ret;
 }
 
diff --git a/net/batman-adv/gateway_client.c b/net/batman-adv/gateway_client.c
index c36a813249a9..b7466136e292 100644
--- a/net/batman-adv/gateway_client.c
+++ b/net/batman-adv/gateway_client.c
@@ -120,8 +120,7 @@ batadv_gw_get_selected_orig(struct batadv_priv *bat_priv)
 unlock:
 	rcu_read_unlock();
 out:
-	if (gw_node)
-		batadv_gw_node_put(gw_node);
+	batadv_gw_node_put(gw_node);
 	return orig_node;
 }
 
@@ -138,8 +137,7 @@ static void batadv_gw_select(struct batadv_priv *bat_priv,
 	curr_gw_node = rcu_replace_pointer(bat_priv->gw.curr_gw, new_gw_node,
 					   true);
 
-	if (curr_gw_node)
-		batadv_gw_node_put(curr_gw_node);
+	batadv_gw_node_put(curr_gw_node);
 
 	spin_unlock_bh(&bat_priv->gw.list_lock);
 }
@@ -274,14 +272,10 @@ void batadv_gw_election(struct batadv_priv *bat_priv)
 	batadv_gw_select(bat_priv, next_gw);
 
 out:
-	if (curr_gw)
-		batadv_gw_node_put(curr_gw);
-	if (next_gw)
-		batadv_gw_node_put(next_gw);
-	if (router)
-		batadv_neigh_node_put(router);
-	if (router_ifinfo)
-		batadv_neigh_ifinfo_put(router_ifinfo);
+	batadv_gw_node_put(curr_gw);
+	batadv_gw_node_put(next_gw);
+	batadv_neigh_node_put(router);
+	batadv_neigh_ifinfo_put(router_ifinfo);
 }
 
 /**
@@ -315,8 +309,7 @@ void batadv_gw_check_election(struct batadv_priv *bat_priv,
 reselect:
 	batadv_gw_reselect(bat_priv);
 out:
-	if (curr_gw_orig)
-		batadv_orig_node_put(curr_gw_orig);
+	batadv_orig_node_put(curr_gw_orig);
 }
 
 /**
@@ -456,13 +449,11 @@ void batadv_gw_node_update(struct batadv_priv *bat_priv,
 		if (gw_node == curr_gw)
 			batadv_gw_reselect(bat_priv);
 
-		if (curr_gw)
-			batadv_gw_node_put(curr_gw);
+		batadv_gw_node_put(curr_gw);
 	}
 
 out:
-	if (gw_node)
-		batadv_gw_node_put(gw_node);
+	batadv_gw_node_put(gw_node);
 }
 
 /**
@@ -545,8 +536,7 @@ int batadv_gw_dump(struct sk_buff *msg, struct netlink_callback *cb)
 	ret = msg->len;
 
 out:
-	if (primary_if)
-		batadv_hardif_put(primary_if);
+	batadv_hardif_put(primary_if);
 	dev_put(soft_iface);
 
 	return ret;
@@ -769,15 +759,10 @@ bool batadv_gw_out_of_range(struct batadv_priv *bat_priv,
 	batadv_neigh_ifinfo_put(old_ifinfo);
 
 out:
-	if (orig_dst_node)
-		batadv_orig_node_put(orig_dst_node);
-	if (curr_gw)
-		batadv_gw_node_put(curr_gw);
-	if (gw_node)
-		batadv_gw_node_put(gw_node);
-	if (neigh_old)
-		batadv_neigh_node_put(neigh_old);
-	if (neigh_curr)
-		batadv_neigh_node_put(neigh_curr);
+	batadv_orig_node_put(orig_dst_node);
+	batadv_gw_node_put(curr_gw);
+	batadv_gw_node_put(gw_node);
+	batadv_neigh_node_put(neigh_old);
+	batadv_neigh_node_put(neigh_curr);
 	return out_of_range;
 }
diff --git a/net/batman-adv/hard-interface.c b/net/batman-adv/hard-interface.c
index 55d97e18aa4a..8a2b78f9c4b2 100644
--- a/net/batman-adv/hard-interface.c
+++ b/net/batman-adv/hard-interface.c
@@ -236,8 +236,7 @@ static struct net_device *batadv_get_real_netdevice(struct net_device *netdev)
 	real_netdev = dev_get_by_index(real_net, ifindex);
 
 out:
-	if (hard_iface)
-		batadv_hardif_put(hard_iface);
+	batadv_hardif_put(hard_iface);
 	return real_netdev;
 }
 
@@ -457,8 +456,7 @@ static void batadv_primary_if_update_addr(struct batadv_priv *bat_priv,
 	batadv_dat_init_own_addr(bat_priv, primary_if);
 	batadv_bla_update_orig_address(bat_priv, primary_if, oldif);
 out:
-	if (primary_if)
-		batadv_hardif_put(primary_if);
+	batadv_hardif_put(primary_if);
 }
 
 static void batadv_primary_if_select(struct batadv_priv *bat_priv,
@@ -481,8 +479,7 @@ static void batadv_primary_if_select(struct batadv_priv *bat_priv,
 	batadv_primary_if_update_addr(bat_priv, curr_hard_iface);
 
 out:
-	if (curr_hard_iface)
-		batadv_hardif_put(curr_hard_iface);
+	batadv_hardif_put(curr_hard_iface);
 }
 
 static bool
@@ -657,8 +654,7 @@ batadv_hardif_activate_interface(struct batadv_hard_iface *hard_iface)
 		bat_priv->algo_ops->iface.activate(hard_iface);
 
 out:
-	if (primary_if)
-		batadv_hardif_put(primary_if);
+	batadv_hardif_put(primary_if);
 }
 
 static void
@@ -811,8 +807,7 @@ void batadv_hardif_disable_interface(struct batadv_hard_iface *hard_iface)
 		new_if = batadv_hardif_get_active(hard_iface->soft_iface);
 		batadv_primary_if_select(bat_priv, new_if);
 
-		if (new_if)
-			batadv_hardif_put(new_if);
+		batadv_hardif_put(new_if);
 	}
 
 	bat_priv->algo_ops->iface.disable(hard_iface);
@@ -834,8 +829,7 @@ void batadv_hardif_disable_interface(struct batadv_hard_iface *hard_iface)
 	batadv_hardif_put(hard_iface);
 
 out:
-	if (primary_if)
-		batadv_hardif_put(primary_if);
+	batadv_hardif_put(primary_if);
 }
 
 static struct batadv_hard_iface *
@@ -990,8 +984,7 @@ static int batadv_hard_if_event(struct notifier_block *this,
 hardif_put:
 	batadv_hardif_put(hard_iface);
 out:
-	if (primary_if)
-		batadv_hardif_put(primary_if);
+	batadv_hardif_put(primary_if);
 	return NOTIFY_DONE;
 }
 
diff --git a/net/batman-adv/multicast.c b/net/batman-adv/multicast.c
index 0158f267c403..a3b6658ed789 100644
--- a/net/batman-adv/multicast.c
+++ b/net/batman-adv/multicast.c
@@ -2241,7 +2241,7 @@ batadv_mcast_netlink_get_primary(struct netlink_callback *cb,
 
 	if (!ret && primary_if)
 		*primary_if = hard_iface;
-	else if (hard_iface)
+	else
 		batadv_hardif_put(hard_iface);
 
 	return ret;
diff --git a/net/batman-adv/netlink.c b/net/batman-adv/netlink.c
index b6cc746e01a6..29276284d281 100644
--- a/net/batman-adv/netlink.c
+++ b/net/batman-adv/netlink.c
@@ -359,15 +359,13 @@ static int batadv_netlink_mesh_fill(struct sk_buff *msg,
 			atomic_read(&bat_priv->orig_interval)))
 		goto nla_put_failure;
 
-	if (primary_if)
-		batadv_hardif_put(primary_if);
+	batadv_hardif_put(primary_if);
 
 	genlmsg_end(msg, hdr);
 	return 0;
 
 nla_put_failure:
-	if (primary_if)
-		batadv_hardif_put(primary_if);
+	batadv_hardif_put(primary_if);
 
 	genlmsg_cancel(msg, hdr);
 	return -EMSGSIZE;
diff --git a/net/batman-adv/network-coding.c b/net/batman-adv/network-coding.c
index 136b1a8e5127..9f06132e007d 100644
--- a/net/batman-adv/network-coding.c
+++ b/net/batman-adv/network-coding.c
@@ -936,10 +936,8 @@ void batadv_nc_update_nc_node(struct batadv_priv *bat_priv,
 	out_nc_node->last_seen = jiffies;
 
 out:
-	if (in_nc_node)
-		batadv_nc_node_put(in_nc_node);
-	if (out_nc_node)
-		batadv_nc_node_put(out_nc_node);
+	batadv_nc_node_put(in_nc_node);
+	batadv_nc_node_put(out_nc_node);
 }
 
 /**
@@ -1215,14 +1213,10 @@ static bool batadv_nc_code_packets(struct batadv_priv *bat_priv,
 	batadv_send_unicast_skb(skb_dest, first_dest);
 	res = true;
 out:
-	if (router_neigh)
-		batadv_neigh_node_put(router_neigh);
-	if (router_coding)
-		batadv_neigh_node_put(router_coding);
-	if (router_neigh_ifinfo)
-		batadv_neigh_ifinfo_put(router_neigh_ifinfo);
-	if (router_coding_ifinfo)
-		batadv_neigh_ifinfo_put(router_coding_ifinfo);
+	batadv_neigh_node_put(router_neigh);
+	batadv_neigh_node_put(router_coding);
+	batadv_neigh_ifinfo_put(router_neigh_ifinfo);
+	batadv_neigh_ifinfo_put(router_coding_ifinfo);
 	return res;
 }
 
diff --git a/net/batman-adv/originator.c b/net/batman-adv/originator.c
index 3693f47d7a9e..aadc653ca1d8 100644
--- a/net/batman-adv/originator.c
+++ b/net/batman-adv/originator.c
@@ -664,8 +664,7 @@ batadv_neigh_node_create(struct batadv_orig_node *orig_node,
 out:
 	spin_unlock_bh(&orig_node->neigh_list_lock);
 
-	if (hardif_neigh)
-		batadv_hardif_neigh_put(hardif_neigh);
+	batadv_hardif_neigh_put(hardif_neigh);
 	return neigh_node;
 }
 
@@ -757,11 +756,9 @@ int batadv_hardif_neigh_dump(struct sk_buff *msg, struct netlink_callback *cb)
 	ret = msg->len;
 
  out:
-	if (hardif)
-		batadv_hardif_put(hardif);
+	batadv_hardif_put(hardif);
 	dev_put(hard_iface);
-	if (primary_if)
-		batadv_hardif_put(primary_if);
+	batadv_hardif_put(primary_if);
 	dev_put(soft_iface);
 
 	return ret;
@@ -784,8 +781,7 @@ void batadv_orig_ifinfo_release(struct kref *ref)
 
 	/* this is the last reference to this object */
 	router = rcu_dereference_protected(orig_ifinfo->router, true);
-	if (router)
-		batadv_neigh_node_put(router);
+	batadv_neigh_node_put(router);
 
 	kfree_rcu(orig_ifinfo, rcu);
 }
@@ -843,8 +839,7 @@ void batadv_orig_node_release(struct kref *ref)
 	orig_node->last_bonding_candidate = NULL;
 	spin_unlock_bh(&orig_node->neigh_list_lock);
 
-	if (last_candidate)
-		batadv_orig_ifinfo_put(last_candidate);
+	batadv_orig_ifinfo_put(last_candidate);
 
 	spin_lock_bh(&orig_node->vlan_list_lock);
 	hlist_for_each_entry_safe(vlan, node_tmp, &orig_node->vlan_list, list) {
@@ -1151,8 +1146,7 @@ batadv_find_best_neighbor(struct batadv_priv *bat_priv,
 		if (!kref_get_unless_zero(&neigh->refcount))
 			continue;
 
-		if (best)
-			batadv_neigh_node_put(best);
+		batadv_neigh_node_put(best);
 
 		best = neigh;
 	}
@@ -1197,8 +1191,7 @@ static bool batadv_purge_orig_node(struct batadv_priv *bat_priv,
 						    BATADV_IF_DEFAULT);
 	batadv_update_route(bat_priv, orig_node, BATADV_IF_DEFAULT,
 			    best_neigh_node);
-	if (best_neigh_node)
-		batadv_neigh_node_put(best_neigh_node);
+	batadv_neigh_node_put(best_neigh_node);
 
 	/* ... then for all other interfaces. */
 	rcu_read_lock();
@@ -1217,8 +1210,7 @@ static bool batadv_purge_orig_node(struct batadv_priv *bat_priv,
 							    hard_iface);
 		batadv_update_route(bat_priv, orig_node, hard_iface,
 				    best_neigh_node);
-		if (best_neigh_node)
-			batadv_neigh_node_put(best_neigh_node);
+		batadv_neigh_node_put(best_neigh_node);
 
 		batadv_hardif_put(hard_iface);
 	}
@@ -1348,11 +1340,9 @@ int batadv_orig_dump(struct sk_buff *msg, struct netlink_callback *cb)
 	ret = msg->len;
 
  out:
-	if (hardif)
-		batadv_hardif_put(hardif);
+	batadv_hardif_put(hardif);
 	dev_put(hard_iface);
-	if (primary_if)
-		batadv_hardif_put(primary_if);
+	batadv_hardif_put(primary_if);
 	dev_put(soft_iface);
 
 	return ret;
diff --git a/net/batman-adv/routing.c b/net/batman-adv/routing.c
index bb9e93e3d98c..970d0d7ccc98 100644
--- a/net/batman-adv/routing.c
+++ b/net/batman-adv/routing.c
@@ -101,8 +101,7 @@ static void _batadv_update_route(struct batadv_priv *bat_priv,
 	}
 
 	/* decrease refcount of previous best neighbor */
-	if (curr_router)
-		batadv_neigh_node_put(curr_router);
+	batadv_neigh_node_put(curr_router);
 }
 
 /**
@@ -128,8 +127,7 @@ void batadv_update_route(struct batadv_priv *bat_priv,
 		_batadv_update_route(bat_priv, orig_node, recv_if, neigh_node);
 
 out:
-	if (router)
-		batadv_neigh_node_put(router);
+	batadv_neigh_node_put(router);
 }
 
 /**
@@ -269,10 +267,8 @@ static int batadv_recv_my_icmp_packet(struct batadv_priv *bat_priv,
 		goto out;
 	}
 out:
-	if (primary_if)
-		batadv_hardif_put(primary_if);
-	if (orig_node)
-		batadv_orig_node_put(orig_node);
+	batadv_hardif_put(primary_if);
+	batadv_orig_node_put(orig_node);
 
 	kfree_skb(skb);
 
@@ -324,10 +320,8 @@ static int batadv_recv_icmp_ttl_exceeded(struct batadv_priv *bat_priv,
 	skb = NULL;
 
 out:
-	if (primary_if)
-		batadv_hardif_put(primary_if);
-	if (orig_node)
-		batadv_orig_node_put(orig_node);
+	batadv_hardif_put(primary_if);
+	batadv_orig_node_put(orig_node);
 
 	kfree_skb(skb);
 
@@ -425,8 +419,7 @@ int batadv_recv_icmp_packet(struct sk_buff *skb,
 	skb = NULL;
 
 put_orig_node:
-	if (orig_node)
-		batadv_orig_node_put(orig_node);
+	batadv_orig_node_put(orig_node);
 free_skb:
 	kfree_skb(skb);
 
@@ -513,8 +506,7 @@ batadv_last_bonding_replace(struct batadv_orig_node *orig_node,
 	orig_node->last_bonding_candidate = new_candidate;
 	spin_unlock_bh(&orig_node->neigh_list_lock);
 
-	if (old_candidate)
-		batadv_orig_ifinfo_put(old_candidate);
+	batadv_orig_ifinfo_put(old_candidate);
 }
 
 /**
@@ -656,8 +648,7 @@ batadv_find_router(struct batadv_priv *bat_priv,
 		batadv_orig_ifinfo_put(next_candidate);
 	}
 
-	if (last_candidate)
-		batadv_orig_ifinfo_put(last_candidate);
+	batadv_orig_ifinfo_put(last_candidate);
 
 	return router;
 }
@@ -785,10 +776,8 @@ batadv_reroute_unicast_packet(struct batadv_priv *bat_priv, struct sk_buff *skb,
 
 	ret = true;
 out:
-	if (primary_if)
-		batadv_hardif_put(primary_if);
-	if (orig_node)
-		batadv_orig_node_put(orig_node);
+	batadv_hardif_put(primary_if);
+	batadv_orig_node_put(orig_node);
 
 	return ret;
 }
@@ -1031,8 +1020,7 @@ int batadv_recv_unicast_packet(struct sk_buff *skb,
 				    orig_node);
 
 rx_success:
-		if (orig_node)
-			batadv_orig_node_put(orig_node);
+		batadv_orig_node_put(orig_node);
 
 		return NET_RX_SUCCESS;
 	}
@@ -1279,7 +1267,6 @@ int batadv_recv_bcast_packet(struct sk_buff *skb,
 	kfree_skb(skb);
 	ret = NET_RX_DROP;
 out:
-	if (orig_node)
-		batadv_orig_node_put(orig_node);
+	batadv_orig_node_put(orig_node);
 	return ret;
 }
diff --git a/net/batman-adv/send.c b/net/batman-adv/send.c
index 0b9dd29d3b6a..2a33458be65c 100644
--- a/net/batman-adv/send.c
+++ b/net/batman-adv/send.c
@@ -152,8 +152,7 @@ int batadv_send_unicast_skb(struct sk_buff *skb,
 	if (hardif_neigh && ret != NET_XMIT_DROP)
 		hardif_neigh->bat_v.last_unicast_tx = jiffies;
 
-	if (hardif_neigh)
-		batadv_hardif_neigh_put(hardif_neigh);
+	batadv_hardif_neigh_put(hardif_neigh);
 #endif
 
 	return ret;
@@ -309,8 +308,7 @@ bool batadv_send_skb_prepare_unicast_4addr(struct batadv_priv *bat_priv,
 
 	ret = true;
 out:
-	if (primary_if)
-		batadv_hardif_put(primary_if);
+	batadv_hardif_put(primary_if);
 	return ret;
 }
 
@@ -425,8 +423,7 @@ int batadv_send_skb_via_tt_generic(struct batadv_priv *bat_priv,
 	ret = batadv_send_skb_unicast(bat_priv, skb, packet_type,
 				      packet_subtype, orig_node, vid);
 
-	if (orig_node)
-		batadv_orig_node_put(orig_node);
+	batadv_orig_node_put(orig_node);
 
 	return ret;
 }
@@ -452,8 +449,7 @@ int batadv_send_skb_via_gw(struct batadv_priv *bat_priv, struct sk_buff *skb,
 	ret = batadv_send_skb_unicast(bat_priv, skb, BATADV_UNICAST_4ADDR,
 				      BATADV_P_DATA, orig_node, vid);
 
-	if (orig_node)
-		batadv_orig_node_put(orig_node);
+	batadv_orig_node_put(orig_node);
 
 	return ret;
 }
@@ -474,10 +470,8 @@ void batadv_forw_packet_free(struct batadv_forw_packet *forw_packet,
 	else
 		consume_skb(forw_packet->skb);
 
-	if (forw_packet->if_incoming)
-		batadv_hardif_put(forw_packet->if_incoming);
-	if (forw_packet->if_outgoing)
-		batadv_hardif_put(forw_packet->if_outgoing);
+	batadv_hardif_put(forw_packet->if_incoming);
+	batadv_hardif_put(forw_packet->if_outgoing);
 	if (forw_packet->queue_left)
 		atomic_inc(forw_packet->queue_left);
 	kfree(forw_packet);
@@ -867,8 +861,7 @@ static bool batadv_send_no_broadcast(struct batadv_priv *bat_priv,
 	ret = batadv_hardif_no_broadcast(if_out, bcast_packet->orig,
 					 orig_neigh);
 
-	if (neigh_node)
-		batadv_hardif_neigh_put(neigh_node);
+	batadv_hardif_neigh_put(neigh_node);
 
 	/* ok, may broadcast */
 	if (!ret)
diff --git a/net/batman-adv/soft-interface.c b/net/batman-adv/soft-interface.c
index e3580ddbf040..0604b0279573 100644
--- a/net/batman-adv/soft-interface.c
+++ b/net/batman-adv/soft-interface.c
@@ -383,10 +383,8 @@ static netdev_tx_t batadv_interface_tx(struct sk_buff *skb,
 dropped_freed:
 	batadv_inc_counter(bat_priv, BATADV_CNT_TX_DROPPED);
 end:
-	if (mcast_single_orig)
-		batadv_orig_node_put(mcast_single_orig);
-	if (primary_if)
-		batadv_hardif_put(primary_if);
+	batadv_orig_node_put(mcast_single_orig);
+	batadv_hardif_put(primary_if);
 	return NETDEV_TX_OK;
 }
 
@@ -838,8 +836,7 @@ static int batadv_softif_slave_add(struct net_device *dev,
 	ret = batadv_hardif_enable_interface(hard_iface, dev);
 
 out:
-	if (hard_iface)
-		batadv_hardif_put(hard_iface);
+	batadv_hardif_put(hard_iface);
 	return ret;
 }
 
@@ -865,8 +862,7 @@ static int batadv_softif_slave_del(struct net_device *dev,
 	ret = 0;
 
 out:
-	if (hard_iface)
-		batadv_hardif_put(hard_iface);
+	batadv_hardif_put(hard_iface);
 	return ret;
 }
 
diff --git a/net/batman-adv/tp_meter.c b/net/batman-adv/tp_meter.c
index b0e67cd51873..56b9fe97b3b4 100644
--- a/net/batman-adv/tp_meter.c
+++ b/net/batman-adv/tp_meter.c
@@ -751,12 +751,9 @@ static void batadv_tp_recv_ack(struct batadv_priv *bat_priv,
 
 	wake_up(&tp_vars->more_bytes);
 out:
-	if (likely(primary_if))
-		batadv_hardif_put(primary_if);
-	if (likely(orig_node))
-		batadv_orig_node_put(orig_node);
-	if (likely(tp_vars))
-		batadv_tp_vars_put(tp_vars);
+	batadv_hardif_put(primary_if);
+	batadv_orig_node_put(orig_node);
+	batadv_tp_vars_put(tp_vars);
 }
 
 /**
@@ -885,10 +882,8 @@ static int batadv_tp_send(void *arg)
 	}
 
 out:
-	if (likely(primary_if))
-		batadv_hardif_put(primary_if);
-	if (likely(orig_node))
-		batadv_orig_node_put(orig_node);
+	batadv_hardif_put(primary_if);
+	batadv_orig_node_put(orig_node);
 
 	batadv_tp_sender_end(bat_priv, tp_vars);
 	batadv_tp_sender_cleanup(bat_priv, tp_vars);
@@ -1208,10 +1203,8 @@ static int batadv_tp_send_ack(struct batadv_priv *bat_priv, const u8 *dst,
 	ret = 0;
 
 out:
-	if (likely(orig_node))
-		batadv_orig_node_put(orig_node);
-	if (likely(primary_if))
-		batadv_hardif_put(primary_if);
+	batadv_orig_node_put(orig_node);
+	batadv_hardif_put(primary_if);
 
 	return ret;
 }
@@ -1459,8 +1452,7 @@ static void batadv_tp_recv_msg(struct batadv_priv *bat_priv,
 	batadv_tp_send_ack(bat_priv, icmp->orig, tp_vars->last_recv,
 			   icmp->timestamp, icmp->session, icmp->uid);
 out:
-	if (likely(tp_vars))
-		batadv_tp_vars_put(tp_vars);
+	batadv_tp_vars_put(tp_vars);
 }
 
 /**
diff --git a/net/batman-adv/translation-table.c b/net/batman-adv/translation-table.c
index b89a4ed51eb8..e0b3dace2020 100644
--- a/net/batman-adv/translation-table.c
+++ b/net/batman-adv/translation-table.c
@@ -813,13 +813,10 @@ bool batadv_tt_local_add(struct net_device *soft_iface, const u8 *addr,
 
 	ret = true;
 out:
-	if (in_hardif)
-		batadv_hardif_put(in_hardif);
+	batadv_hardif_put(in_hardif);
 	dev_put(in_dev);
-	if (tt_local)
-		batadv_tt_local_entry_put(tt_local);
-	if (tt_global)
-		batadv_tt_global_entry_put(tt_global);
+	batadv_tt_local_entry_put(tt_local);
+	batadv_tt_global_entry_put(tt_global);
 	return ret;
 }
 
@@ -1209,8 +1206,7 @@ int batadv_tt_local_dump(struct sk_buff *msg, struct netlink_callback *cb)
 	ret = msg->len;
 
  out:
-	if (primary_if)
-		batadv_hardif_put(primary_if);
+	batadv_hardif_put(primary_if);
 	dev_put(soft_iface);
 
 	cb->args[0] = bucket;
@@ -1298,8 +1294,7 @@ u16 batadv_tt_local_remove(struct batadv_priv *bat_priv, const u8 *addr,
 	batadv_tt_local_entry_put(tt_removed_entry);
 
 out:
-	if (tt_local_entry)
-		batadv_tt_local_entry_put(tt_local_entry);
+	batadv_tt_local_entry_put(tt_local_entry);
 
 	return curr_flags;
 }
@@ -1569,8 +1564,7 @@ batadv_tt_global_orig_entry_add(struct batadv_tt_global_entry *tt_global,
 sync_flags:
 	batadv_tt_global_sync_flags(tt_global);
 out:
-	if (orig_entry)
-		batadv_tt_orig_list_entry_put(orig_entry);
+	batadv_tt_orig_list_entry_put(orig_entry);
 
 	spin_unlock_bh(&tt_global->list_lock);
 }
@@ -1743,10 +1737,8 @@ static bool batadv_tt_global_add(struct batadv_priv *bat_priv,
 		tt_global_entry->common.flags &= ~BATADV_TT_CLIENT_ROAM;
 
 out:
-	if (tt_global_entry)
-		batadv_tt_global_entry_put(tt_global_entry);
-	if (tt_local_entry)
-		batadv_tt_local_entry_put(tt_local_entry);
+	batadv_tt_global_entry_put(tt_global_entry);
+	batadv_tt_local_entry_put(tt_local_entry);
 	return ret;
 }
 
@@ -1782,15 +1774,13 @@ batadv_transtable_best_orig(struct batadv_priv *bat_priv,
 		}
 
 		/* release the refcount for the "old" best */
-		if (best_router)
-			batadv_neigh_node_put(best_router);
+		batadv_neigh_node_put(best_router);
 
 		best_entry = orig_entry;
 		best_router = router;
 	}
 
-	if (best_router)
-		batadv_neigh_node_put(best_router);
+	batadv_neigh_node_put(best_router);
 
 	return best_entry;
 }
@@ -1996,8 +1986,7 @@ int batadv_tt_global_dump(struct sk_buff *msg, struct netlink_callback *cb)
 	ret = msg->len;
 
  out:
-	if (primary_if)
-		batadv_hardif_put(primary_if);
+	batadv_hardif_put(primary_if);
 	dev_put(soft_iface);
 
 	cb->args[0] = bucket;
@@ -2188,10 +2177,8 @@ static void batadv_tt_global_del(struct batadv_priv *bat_priv,
 	}
 
 out:
-	if (tt_global_entry)
-		batadv_tt_global_entry_put(tt_global_entry);
-	if (local_entry)
-		batadv_tt_local_entry_put(local_entry);
+	batadv_tt_global_entry_put(tt_global_entry);
+	batadv_tt_local_entry_put(local_entry);
 }
 
 /**
@@ -2418,10 +2405,8 @@ struct batadv_orig_node *batadv_transtable_search(struct batadv_priv *bat_priv,
 	rcu_read_unlock();
 
 out:
-	if (tt_global_entry)
-		batadv_tt_global_entry_put(tt_global_entry);
-	if (tt_local_entry)
-		batadv_tt_local_entry_put(tt_local_entry);
+	batadv_tt_global_entry_put(tt_global_entry);
+	batadv_tt_local_entry_put(tt_local_entry);
 
 	return orig_node;
 }
@@ -2982,8 +2967,7 @@ static bool batadv_send_tt_request(struct batadv_priv *bat_priv,
 	ret = true;
 
 out:
-	if (primary_if)
-		batadv_hardif_put(primary_if);
+	batadv_hardif_put(primary_if);
 
 	if (ret && tt_req_node) {
 		spin_lock_bh(&bat_priv->tt.req_list_lock);
@@ -2994,8 +2978,7 @@ static bool batadv_send_tt_request(struct batadv_priv *bat_priv,
 		spin_unlock_bh(&bat_priv->tt.req_list_lock);
 	}
 
-	if (tt_req_node)
-		batadv_tt_req_node_put(tt_req_node);
+	batadv_tt_req_node_put(tt_req_node);
 
 	kfree(tvlv_tt_data);
 	return ret;
@@ -3126,10 +3109,8 @@ static bool batadv_send_other_tt_response(struct batadv_priv *bat_priv,
 	spin_unlock_bh(&req_dst_orig_node->tt_buff_lock);
 
 out:
-	if (res_dst_orig_node)
-		batadv_orig_node_put(res_dst_orig_node);
-	if (req_dst_orig_node)
-		batadv_orig_node_put(req_dst_orig_node);
+	batadv_orig_node_put(res_dst_orig_node);
+	batadv_orig_node_put(req_dst_orig_node);
 	kfree(tvlv_tt_data);
 	return ret;
 }
@@ -3243,10 +3224,8 @@ static bool batadv_send_my_tt_response(struct batadv_priv *bat_priv,
 	spin_unlock_bh(&bat_priv->tt.last_changeset_lock);
 out:
 	spin_unlock_bh(&bat_priv->tt.commit_lock);
-	if (orig_node)
-		batadv_orig_node_put(orig_node);
-	if (primary_if)
-		batadv_hardif_put(primary_if);
+	batadv_orig_node_put(orig_node);
+	batadv_hardif_put(primary_if);
 	kfree(tvlv_tt_data);
 	/* The packet was for this host, so it doesn't need to be re-routed */
 	return true;
@@ -3331,8 +3310,7 @@ static void batadv_tt_fill_gtable(struct batadv_priv *bat_priv,
 	atomic_set(&orig_node->last_ttvn, ttvn);
 
 out:
-	if (orig_node)
-		batadv_orig_node_put(orig_node);
+	batadv_orig_node_put(orig_node);
 }
 
 static void batadv_tt_update_changes(struct batadv_priv *bat_priv,
@@ -3373,8 +3351,7 @@ bool batadv_is_my_client(struct batadv_priv *bat_priv, const u8 *addr,
 		goto out;
 	ret = true;
 out:
-	if (tt_local_entry)
-		batadv_tt_local_entry_put(tt_local_entry);
+	batadv_tt_local_entry_put(tt_local_entry);
 	return ret;
 }
 
@@ -3437,8 +3414,7 @@ static void batadv_handle_tt_response(struct batadv_priv *bat_priv,
 
 	spin_unlock_bh(&bat_priv->tt.req_list_lock);
 out:
-	if (orig_node)
-		batadv_orig_node_put(orig_node);
+	batadv_orig_node_put(orig_node);
 }
 
 static void batadv_tt_roam_list_free(struct batadv_priv *bat_priv)
@@ -3569,8 +3545,7 @@ static void batadv_send_roam_adv(struct batadv_priv *bat_priv, u8 *client,
 				 &tvlv_roam, sizeof(tvlv_roam));
 
 out:
-	if (primary_if)
-		batadv_hardif_put(primary_if);
+	batadv_hardif_put(primary_if);
 }
 
 static void batadv_tt_purge(struct work_struct *work)
@@ -4165,8 +4140,7 @@ static int batadv_roam_tvlv_unicast_handler_v1(struct batadv_priv *bat_priv,
 			     atomic_read(&orig_node->last_ttvn) + 1);
 
 out:
-	if (orig_node)
-		batadv_orig_node_put(orig_node);
+	batadv_orig_node_put(orig_node);
 	return NET_RX_SUCCESS;
 }
 
diff --git a/net/batman-adv/tvlv.c b/net/batman-adv/tvlv.c
index 1efea0acdd95..992773376e51 100644
--- a/net/batman-adv/tvlv.c
+++ b/net/batman-adv/tvlv.c
@@ -444,8 +444,7 @@ int batadv_tvlv_containers_process(struct batadv_priv *bat_priv,
 						ogm_source, orig_node,
 						src, dst, tvlv_value,
 						tvlv_value_cont_len);
-		if (tvlv_handler)
-			batadv_tvlv_handler_put(tvlv_handler);
+		batadv_tvlv_handler_put(tvlv_handler);
 		tvlv_value = (u8 *)tvlv_value + tvlv_value_cont_len;
 		tvlv_value_len -= tvlv_value_cont_len;
 	}
-- 
2.20.1

