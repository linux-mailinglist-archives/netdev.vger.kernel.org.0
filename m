Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8ED7C6CB464
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 04:58:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229946AbjC1C6E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 22:58:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjC1C6D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 22:58:03 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D36F91BFF
        for <netdev@vger.kernel.org>; Mon, 27 Mar 2023 19:58:01 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pgzX2-009NnY-U5; Tue, 28 Mar 2023 10:57:57 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 28 Mar 2023 10:57:56 +0800
From:   "Herbert Xu" <herbert@gondor.apana.org.au>
Date:   Tue, 28 Mar 2023 10:57:56 +0800
Subject: [PATCH 1/2] macvlan: Skip broadcast queue if multicast with single receiver
References: <ZCJXefIhSrd7Hm2Z@gondor.apana.org.au>
To:     netdev@vger.kernel.org
Message-Id: <E1pgzX2-009NnY-U5@formenos.hmeau.com>
X-Spam-Status: No, score=4.3 required=5.0 tests=HELO_DYNAMIC_IPADDR2,
        PDS_RDNS_DYNAMIC_FP,RDNS_DYNAMIC,SPF_HELO_NONE,SPF_PASS,TVD_RCVD_IP
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As it stands all broadcast and multicast packets are queued and
processed in a work queue.  This is so that we don't overwhelm
the receive softirq path by generating thousands of packets or
more (see commit 412ca1550cbe "macvlan: Move broadcasts into a
work queue").

As such all multicast packets will be delayed, even if they will
be received by a single macvlan device.  As using a workqueue
is not free in terms of latency, we should avoid this where possible.

This patch adds a new filter to determine which addresses should
be delayed and which ones won't.  This is done using a crude
counter of how many times an address has been added to the macvlan
port (ha->synced).  For now if an address has been added more than
once, then it will be considered to be broadcast.  This could be
tuned further by making this threshold configurable.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 drivers/net/macvlan.c |   74 +++++++++++++++++++++++++++++++-------------------
 1 file changed, 46 insertions(+), 28 deletions(-)

diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
index 99a971929c8e..62b4748d3836 100644
--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -50,6 +50,7 @@ struct macvlan_port {
 	u32			flags;
 	int			count;
 	struct hlist_head	vlan_source_hash[MACVLAN_HASH_SIZE];
+	DECLARE_BITMAP(bc_filter, MACVLAN_MC_FILTER_SZ);
 	DECLARE_BITMAP(mc_filter, MACVLAN_MC_FILTER_SZ);
 	unsigned char           perm_addr[ETH_ALEN];
 };
@@ -291,6 +292,31 @@ static void macvlan_broadcast(struct sk_buff *skb,
 	}
 }
 
+static void macvlan_multicast_rx(const struct macvlan_port *port,
+				 const struct macvlan_dev *src,
+				 struct sk_buff *skb)
+{
+	if (!src)
+		/* frame comes from an external address */
+		macvlan_broadcast(skb, port, NULL,
+				  MACVLAN_MODE_PRIVATE |
+				  MACVLAN_MODE_VEPA    |
+				  MACVLAN_MODE_PASSTHRU|
+				  MACVLAN_MODE_BRIDGE);
+	else if (src->mode == MACVLAN_MODE_VEPA)
+		/* flood to everyone except source */
+		macvlan_broadcast(skb, port, src->dev,
+				  MACVLAN_MODE_VEPA |
+				  MACVLAN_MODE_BRIDGE);
+	else
+		/*
+		 * flood only to VEPA ports, bridge ports
+		 * already saw the frame on the way out.
+		 */
+		macvlan_broadcast(skb, port, src->dev,
+				  MACVLAN_MODE_VEPA);
+}
+
 static void macvlan_process_broadcast(struct work_struct *w)
 {
 	struct macvlan_port *port = container_of(w, struct macvlan_port,
@@ -308,27 +334,7 @@ static void macvlan_process_broadcast(struct work_struct *w)
 		const struct macvlan_dev *src = MACVLAN_SKB_CB(skb)->src;
 
 		rcu_read_lock();
-
-		if (!src)
-			/* frame comes from an external address */
-			macvlan_broadcast(skb, port, NULL,
-					  MACVLAN_MODE_PRIVATE |
-					  MACVLAN_MODE_VEPA    |
-					  MACVLAN_MODE_PASSTHRU|
-					  MACVLAN_MODE_BRIDGE);
-		else if (src->mode == MACVLAN_MODE_VEPA)
-			/* flood to everyone except source */
-			macvlan_broadcast(skb, port, src->dev,
-					  MACVLAN_MODE_VEPA |
-					  MACVLAN_MODE_BRIDGE);
-		else
-			/*
-			 * flood only to VEPA ports, bridge ports
-			 * already saw the frame on the way out.
-			 */
-			macvlan_broadcast(skb, port, src->dev,
-					  MACVLAN_MODE_VEPA);
-
+		macvlan_multicast_rx(port, src, skb);
 		rcu_read_unlock();
 
 		if (src)
@@ -476,8 +482,10 @@ static rx_handler_result_t macvlan_handle_frame(struct sk_buff **pskb)
 		}
 
 		hash = mc_hash(NULL, eth->h_dest);
-		if (test_bit(hash, port->mc_filter))
+		if (test_bit(hash, port->bc_filter))
 			macvlan_broadcast_enqueue(port, src, skb);
+		else if (test_bit(hash, port->mc_filter))
+			macvlan_multicast_rx(port, src, skb);
 
 		return RX_HANDLER_PASS;
 	}
@@ -780,20 +788,27 @@ static void macvlan_change_rx_flags(struct net_device *dev, int change)
 
 static void macvlan_compute_filter(unsigned long *mc_filter,
 				   struct net_device *dev,
-				   struct macvlan_dev *vlan)
+				   struct macvlan_dev *vlan, int cutoff)
 {
 	if (dev->flags & (IFF_PROMISC | IFF_ALLMULTI)) {
-		bitmap_fill(mc_filter, MACVLAN_MC_FILTER_SZ);
+		if (cutoff >= 0)
+			bitmap_fill(mc_filter, MACVLAN_MC_FILTER_SZ);
+		else
+			bitmap_zero(mc_filter, MACVLAN_MC_FILTER_SZ);
 	} else {
-		struct netdev_hw_addr *ha;
 		DECLARE_BITMAP(filter, MACVLAN_MC_FILTER_SZ);
+		struct netdev_hw_addr *ha;
 
 		bitmap_zero(filter, MACVLAN_MC_FILTER_SZ);
 		netdev_for_each_mc_addr(ha, dev) {
+			if (cutoff >= 0 && ha->synced <= cutoff)
+				continue;
+
 			__set_bit(mc_hash(vlan, ha->addr), filter);
 		}
 
-		__set_bit(mc_hash(vlan, dev->broadcast), filter);
+		if (cutoff >= 0)
+			__set_bit(mc_hash(vlan, dev->broadcast), filter);
 
 		bitmap_copy(mc_filter, filter, MACVLAN_MC_FILTER_SZ);
 	}
@@ -803,7 +818,7 @@ static void macvlan_set_mac_lists(struct net_device *dev)
 {
 	struct macvlan_dev *vlan = netdev_priv(dev);
 
-	macvlan_compute_filter(vlan->mc_filter, dev, vlan);
+	macvlan_compute_filter(vlan->mc_filter, dev, vlan, 0);
 
 	dev_uc_sync(vlan->lowerdev, dev);
 	dev_mc_sync(vlan->lowerdev, dev);
@@ -821,7 +836,10 @@ static void macvlan_set_mac_lists(struct net_device *dev)
 	 * The solution is to maintain a list of broadcast addresses like
 	 * we do for uc/mc, if you care.
 	 */
-	macvlan_compute_filter(vlan->port->mc_filter, vlan->lowerdev, NULL);
+	macvlan_compute_filter(vlan->port->mc_filter, vlan->lowerdev, NULL,
+			       0);
+	macvlan_compute_filter(vlan->port->bc_filter, vlan->lowerdev, NULL,
+			       1);
 }
 
 static int macvlan_change_mtu(struct net_device *dev, int new_mtu)
