Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0344A2866B6
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 20:16:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728105AbgJGSPN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 14:15:13 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:46627 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728858AbgJGSPE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Oct 2020 14:15:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602094473;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rlM1JyoebMq6uJNg06QVh/ljS1aelDKN/qkFqkINyQ8=;
        b=JAyPAUX+61hmWwp1DKTpR/A0Gd62VzxsSn35pQzeC3UanpPhC72Ccz0TrXcHf1azz/CU9B
        d2Ui2TGeVOGUPAHC6f2YrewXxCJOSL7mIhcfNSU3k7Xkvgj7puLqLwDTeUWYsc+CNztUVr
        7m9MqzjnVS3Cpck8PTyfNGIVICgkqyU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-501-ykvPQsK3PpmpQBf1JCeWLA-1; Wed, 07 Oct 2020 14:14:28 -0400
X-MC-Unique: ykvPQsK3PpmpQBf1JCeWLA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 45ED784A5E0;
        Wed,  7 Oct 2020 18:14:27 +0000 (UTC)
Received: from hpe-dl360pgen9-01.klab.eng.bos.redhat.com (hpe-dl360pgen9-01.klab.eng.bos.redhat.com [10.16.160.31])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4CEB955764;
        Wed,  7 Oct 2020 18:14:26 +0000 (UTC)
From:   Jarod Wilson <jarod@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     Jarod Wilson <jarod@redhat.com>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Davis <tadavis@lbl.gov>, netdev@vger.kernel.org
Subject: [PATCH net-next v3 3/5] bonding: rename slave to port where possible
Date:   Wed,  7 Oct 2020 14:14:07 -0400
Message-Id: <20201007181409.1275639-4-jarod@redhat.com>
In-Reply-To: <20201007181409.1275639-1-jarod@redhat.com>
References: <20201007181409.1275639-1-jarod@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use "port" to denote individual component interfaces in a bond, rather
than "slave". This is more consistent with the team and bridge drivers,
and eliminates the use of a good amount of problematic language in the
bonding driver.

Legacy sysfs, procfs and module parameter bits that use slave in their
names are retained for the purposes of not breaking anyone's userspace.

v3: simply omit interfaces with new names, sysfs and procfs should already
be deprecated in favor of netlink/iproute2.

Cc: Jay Vosburgh <j.vosburgh@gmail.com>
Cc: Veaceslav Falico <vfalico@gmail.com>
Cc: Andy Gospodarek <andy@greyhouse.net>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Thomas Davis <tadavis@lbl.gov>
Cc: netdev@vger.kernel.org
Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
 .clang-format                                 |    4 +-
 drivers/infiniband/core/roce_gid_mgmt.c       |    4 +-
 drivers/infiniband/hw/mlx4/main.c             |    2 +-
 drivers/net/bonding/bond_3ad.c                |  598 ++---
 drivers/net/bonding/bond_alb.c                |  689 ++---
 drivers/net/bonding/bond_debugfs.c            |    2 +-
 drivers/net/bonding/bond_main.c               | 2319 +++++++++--------
 drivers/net/bonding/bond_netlink.c            |  112 +-
 drivers/net/bonding/bond_options.c            |  258 +-
 drivers/net/bonding/bond_procfs.c             |   48 +-
 drivers/net/bonding/bond_sysfs.c              |   70 +-
 drivers/net/bonding/bond_sysfs_slave.c        |  159 +-
 .../ethernet/chelsio/cxgb3/cxgb3_offload.c    |    2 +-
 .../net/ethernet/mellanox/mlx4/en_netdev.c    |    4 +-
 .../ethernet/mellanox/mlx5/core/en/rep/bond.c |    4 +-
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   |    2 +-
 .../ethernet/qlogic/netxen/netxen_nic_main.c  |    4 +-
 include/linux/netdevice.h                     |   16 +-
 include/net/bond_3ad.h                        |   30 +-
 include/net/bond_alb.h                        |   74 +-
 include/net/bond_options.h                    |   18 +-
 include/net/bonding.h                         |  358 +--
 include/net/lag.h                             |    2 +-
 23 files changed, 2419 insertions(+), 2360 deletions(-)

diff --git a/.clang-format b/.clang-format
index badfc1ba440a..1f1a16388ccb 100644
--- a/.clang-format
+++ b/.clang-format
@@ -92,8 +92,8 @@ ForEachMacros:
   - 'blkg_for_each_descendant_post'
   - 'blkg_for_each_descendant_pre'
   - 'blk_queue_for_each_rl'
-  - 'bond_for_each_slave'
-  - 'bond_for_each_slave_rcu'
+  - 'bond_for_each_port'
+  - 'bond_for_each_port_rcu'
   - 'bpf_for_each_spilled_reg'
   - 'btree_for_each_safe128'
   - 'btree_for_each_safe32'
diff --git a/drivers/infiniband/core/roce_gid_mgmt.c b/drivers/infiniband/core/roce_gid_mgmt.c
index 85c48977be6c..fe95d928c5cf 100644
--- a/drivers/infiniband/core/roce_gid_mgmt.c
+++ b/drivers/infiniband/core/roce_gid_mgmt.c
@@ -131,7 +131,7 @@ static enum bonding_slave_state is_eth_active_slave_of_bonding_rcu(struct net_de
 {
 	if (upper && netif_is_bond_dev(upper)) {
 		struct net_device *pdev =
-			bond_option_active_slave_get_rcu(netdev_priv(upper));
+			bond_option_active_port_get_rcu(netdev_priv(upper));
 
 		if (pdev)
 			return dev == pdev ? BONDING_SLAVE_STATE_ACTIVE :
@@ -215,7 +215,7 @@ is_ndev_for_default_gid_filter(struct ib_device *ib_dev, u8 port,
 	 * Additionally when event(cookie) netdevice is bond master device,
 	 * make sure that it the upper netdevice of rdma netdevice.
 	 */
-	res = ((cookie_ndev == rdma_ndev && !netif_is_bond_slave(rdma_ndev)) ||
+	res = ((cookie_ndev == rdma_ndev && !netif_is_bond_port(rdma_ndev)) ||
 	       (netif_is_bond_dev(cookie_ndev) &&
 		rdma_is_upper_dev_rcu(rdma_ndev, cookie_ndev)));
 
diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index bd4f975e7f9a..8a964224b8b1 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -145,7 +145,7 @@ static struct net_device *mlx4_ib_get_netdev(struct ib_device *device, u8 port_n
 			if (upper) {
 				struct net_device *active;
 
-				active = bond_option_active_slave_get_rcu(netdev_priv(upper));
+				active = bond_option_active_port_get_rcu(netdev_priv(upper));
 				if (active)
 					dev = active;
 			}
diff --git a/drivers/net/bonding/bond_3ad.c b/drivers/net/bonding/bond_3ad.c
index 852b9c4f6a47..4d5cb982e7ea 100644
--- a/drivers/net/bonding/bond_3ad.c
+++ b/drivers/net/bonding/bond_3ad.c
@@ -91,20 +91,20 @@ static const u8 lacpdu_mcast_addr[ETH_ALEN + 2] __long_aligned =
 /* ================= main 802.3ad protocol functions ================== */
 static int ad_lacpdu_send(struct ad_port *ad_port);
 static int ad_marker_send(struct ad_port *ad_port, struct bond_marker *marker);
-static void ad_mux_machine(struct ad_port *ad_port, bool *update_slave_arr);
+static void ad_mux_machine(struct ad_port *ad_port, bool *update_port_arr);
 static void ad_rx_machine(struct lacpdu *lacpdu, struct ad_port *ad_port);
 static void ad_tx_machine(struct ad_port *ad_port);
 static void ad_periodic_machine(struct ad_port *ad_port);
-static void ad_port_selection_logic(struct ad_port *ad_port, bool *update_slave_arr);
+static void ad_port_selection_logic(struct ad_port *ad_port, bool *update_port_arr);
 static void ad_agg_selection_logic(struct aggregator *aggregator,
-				   bool *update_slave_arr);
+				   bool *update_port_arr);
 static void ad_clear_agg(struct aggregator *aggregator);
 static void ad_initialize_agg(struct aggregator *aggregator);
 static void ad_initialize_port(struct ad_port *ad_port, int lacp_fast);
 static void ad_enable_collecting_distributing(struct ad_port *ad_port,
-					      bool *update_slave_arr);
+					      bool *update_port_arr);
 static void ad_disable_collecting_distributing(struct ad_port *ad_port,
-					       bool *update_slave_arr);
+					       bool *update_port_arr);
 static void ad_marker_info_received(struct bond_marker *marker_info,
 				    struct ad_port *ad_port);
 static void ad_marker_response_received(struct bond_marker *marker,
@@ -122,33 +122,33 @@ static void ad_update_actor_keys(struct ad_port *ad_port, bool reset);
  */
 static inline struct bonding *__get_bond_by_ad_port(struct ad_port *ad_port)
 {
-	if (ad_port->slave == NULL)
+	if (ad_port->port == NULL)
 		return NULL;
 
-	return bond_get_bond_by_slave(ad_port->slave);
+	return bond_get_bond_by_port(ad_port->port);
 }
 
 /**
  * __get_first_agg - get the first aggregator in the bond
  * @ad_port: the ad_port we're looking at
  *
- * Return the aggregator of the first slave in @bond, or %NULL if it can't be
+ * Return the aggregator of the first port in @bond, or %NULL if it can't be
  * found.
  * The caller must hold RCU or RTNL lock.
  */
 static inline struct aggregator *__get_first_agg(struct ad_port *ad_port)
 {
 	struct bonding *bond = __get_bond_by_ad_port(ad_port);
-	struct slave *first_slave;
+	struct bond_port *first_port;
 	struct aggregator *agg;
 
-	/* If there's no bond for this ad_port, or bond has no slaves */
+	/* If there's no bond for this ad_port, or bond has no ports */
 	if (bond == NULL)
 		return NULL;
 
 	rcu_read_lock();
-	first_slave = bond_first_slave_rcu(bond);
-	agg = first_slave ? &(SLAVE_AD_INFO(first_slave)->aggregator) : NULL;
+	first_port = bond_first_port_rcu(bond);
+	agg = first_port ? &(PORT_AD_INFO(first_port)->aggregator) : NULL;
 	rcu_read_unlock();
 
 	return agg;
@@ -167,33 +167,33 @@ static inline int __agg_has_partner(struct aggregator *agg)
 }
 
 /**
- * __disable_ad_port - disable the ad_port's slave
+ * __disable_ad_port - disable the ad_port's port
  * @ad_port: the ad_port we're looking at
  */
 static inline void __disable_ad_port(struct ad_port *ad_port)
 {
-	bond_set_slave_inactive_flags(ad_port->slave, BOND_SLAVE_NOTIFY_LATER);
+	bond_set_port_inactive_flags(ad_port->port, BOND_PORT_NOTIFY_LATER);
 }
 
 /**
- * __enable_ad_port - enable the ad_port's slave, if it's up
+ * __enable_ad_port - enable the ad_port's port, if it's up
  * @ad_port: the ad_port we're looking at
  */
 static inline void __enable_ad_port(struct ad_port *ad_port)
 {
-	struct slave *slave = ad_port->slave;
+	struct bond_port *port = ad_port->port;
 
-	if ((slave->link == BOND_LINK_UP) && bond_slave_is_up(slave))
-		bond_set_slave_active_flags(slave, BOND_SLAVE_NOTIFY_LATER);
+	if ((port->link == BOND_LINK_UP) && bond_port_is_up(port))
+		bond_set_port_active_flags(port, BOND_PORT_NOTIFY_LATER);
 }
 
 /**
- * __ad_port_is_enabled - check if the ad_port's slave is in active state
+ * __ad_port_is_enabled - check if the ad_port's port is in active state
  * @ad_port: the ad_port we're looking at
  */
 static inline int __ad_port_is_enabled(struct ad_port *ad_port)
 {
-	return bond_is_active_slave(ad_port->slave);
+	return bond_is_active_port(ad_port->port);
 }
 
 /**
@@ -248,7 +248,7 @@ static inline int __check_agg_selection_timer(struct ad_port *ad_port)
  */
 static u16 __get_link_speed(struct ad_port *ad_port)
 {
-	struct slave *slave = ad_port->slave;
+	struct bond_port *port = ad_port->port;
 	u16 speed;
 
 	/* this if covers only a special case: when the configuration starts
@@ -256,10 +256,10 @@ static u16 __get_link_speed(struct ad_port *ad_port)
 	 * This is done in spite of the fact that the e100 driver reports 0
 	 * to be compatible with MVT in the future.
 	 */
-	if (slave->link != BOND_LINK_UP)
+	if (port->link != BOND_LINK_UP)
 		speed = 0;
 	else {
-		switch (slave->speed) {
+		switch (port->speed) {
 		case SPEED_10:
 			speed = AD_LINK_SPEED_10MBPS;
 			break;
@@ -314,18 +314,18 @@ static u16 __get_link_speed(struct ad_port *ad_port)
 
 		default:
 			/* unknown speed value from ethtool. shouldn't happen */
-			if (slave->speed != SPEED_UNKNOWN)
-				pr_warn_once("%s: (slave %s): unknown ethtool speed (%d) for port %d (set it to 0)\n",
-					     slave->bond->dev->name,
-					     slave->dev->name, slave->speed,
+			if (port->speed != SPEED_UNKNOWN)
+				pr_warn_once("%s: (port %s): unknown ethtool speed (%d) for port %d (set it to 0)\n",
+					     port->bond->dev->name,
+					     port->dev->name, port->speed,
 					     ad_port->actor_port_number);
 			speed = 0;
 			break;
 		}
 	}
 
-	slave_dbg(slave->bond->dev, slave->dev, "Port %d Received link speed %d update from adapter\n",
-		  ad_port->actor_port_number, speed);
+	port_dbg(port->bond->dev, port->dev, "Port %d Received link speed %d update from adapter\n",
+		 ad_port->actor_port_number, speed);
 	return speed;
 }
 
@@ -339,24 +339,24 @@ static u16 __get_link_speed(struct ad_port *ad_port)
  */
 static u8 __get_duplex(struct ad_port *ad_port)
 {
-	struct slave *slave = ad_port->slave;
+	struct bond_port *port = ad_port->port;
 	u8 retval = 0x0;
 
 	/* handling a special case: when the configuration starts with
 	 * link down, it sets the duplex to 0.
 	 */
-	if (slave->link == BOND_LINK_UP) {
-		switch (slave->duplex) {
+	if (port->link == BOND_LINK_UP) {
+		switch (port->duplex) {
 		case DUPLEX_FULL:
 			retval = 0x1;
-			slave_dbg(slave->bond->dev, slave->dev, "Port %d Received status full duplex update from adapter\n",
-				  ad_port->actor_port_number);
+			port_dbg(port->bond->dev, port->dev, "Port %d Received status full duplex update from adapter\n",
+				 ad_port->actor_port_number);
 			break;
 		case DUPLEX_HALF:
 		default:
 			retval = 0x0;
-			slave_dbg(slave->bond->dev, slave->dev, "Port %d Received status NOT full duplex update from adapter\n",
-				  ad_port->actor_port_number);
+			port_dbg(port->bond->dev, port->dev, "Port %d Received status NOT full duplex update from adapter\n",
+				 ad_port->actor_port_number);
 			break;
 		}
 	}
@@ -365,7 +365,7 @@ static u8 __get_duplex(struct ad_port *ad_port)
 
 static void __ad_actor_update_port(struct ad_port *ad_port)
 {
-	const struct bonding *bond = bond_get_bond_by_slave(ad_port->slave);
+	const struct bonding *bond = bond_get_bond_by_port(ad_port->port);
 
 	ad_port->actor_system = BOND_AD_INFO(bond).system.sys_mac_addr;
 	ad_port->actor_system_priority = BOND_AD_INFO(bond).system.sys_priority;
@@ -490,12 +490,12 @@ static void __record_pdu(struct lacpdu *lacpdu, struct ad_port *ad_port)
 		if ((ad_port->sm_vars & AD_PORT_MATCHED) &&
 		    (lacpdu->actor_state & LACP_STATE_SYNCHRONIZATION)) {
 			partner->port_state |= LACP_STATE_SYNCHRONIZATION;
-			slave_dbg(ad_port->slave->bond->dev, ad_port->slave->dev,
-				  "partner sync=1\n");
+			port_dbg(ad_port->port->bond->dev, ad_port->port->dev,
+				 "partner sync=1\n");
 		} else {
 			partner->port_state &= ~LACP_STATE_SYNCHRONIZATION;
-			slave_dbg(ad_port->slave->bond->dev, ad_port->slave->dev,
-				  "partner sync=0\n");
+			port_dbg(ad_port->port->bond->dev, ad_port->port->dev,
+				 "partner sync=0\n");
 		}
 	}
 }
@@ -748,13 +748,13 @@ static u32 __get_agg_bandwidth(struct aggregator *aggregator)
  */
 static struct aggregator *__get_active_agg(struct aggregator *aggregator)
 {
-	struct bonding *bond = aggregator->slave->bond;
+	struct bonding *bond = aggregator->port->bond;
 	struct list_head *iter;
-	struct slave *slave;
+	struct bond_port *port;
 
-	bond_for_each_slave_rcu(bond, slave, iter)
-		if (SLAVE_AD_INFO(slave)->aggregator.is_active)
-			return &(SLAVE_AD_INFO(slave)->aggregator);
+	bond_for_each_port_rcu(bond, port, iter)
+		if (PORT_AD_INFO(port)->aggregator.is_active)
+			return &(PORT_AD_INFO(port)->aggregator);
 
 	return NULL;
 }
@@ -781,9 +781,9 @@ static inline void __update_lacpdu_from_ad_port(struct ad_port *ad_port)
 	lacpdu->actor_port_priority = htons(ad_port->actor_port_priority);
 	lacpdu->actor_port = htons(ad_port->actor_port_number);
 	lacpdu->actor_state = ad_port->actor_oper_port_state;
-	slave_dbg(ad_port->slave->bond->dev, ad_port->slave->dev,
-		  "update lacpdu: actor ad port state %x\n",
-		  ad_port->actor_oper_port_state);
+	port_dbg(ad_port->port->bond->dev, ad_port->port->dev,
+		 "update lacpdu: actor ad port state %x\n",
+		 ad_port->actor_oper_port_state);
 
 	/* lacpdu->reserved_3_1              initialized
 	 * lacpdu->tlv_type_partner_info     initialized
@@ -819,7 +819,7 @@ static inline void __update_lacpdu_from_ad_port(struct ad_port *ad_port)
  */
 static int ad_lacpdu_send(struct ad_port *ad_port)
 {
-	struct slave *slave = ad_port->slave;
+	struct bond_port *port = ad_port->port;
 	struct sk_buff *skb;
 	struct lacpdu_header *lacpdu_header;
 	int length = sizeof(struct lacpdu_header);
@@ -828,10 +828,10 @@ static int ad_lacpdu_send(struct ad_port *ad_port)
 	if (!skb)
 		return -ENOMEM;
 
-	atomic64_inc(&SLAVE_AD_INFO(slave)->stats.lacpdu_tx);
-	atomic64_inc(&BOND_AD_INFO(slave->bond).stats.lacpdu_tx);
+	atomic64_inc(&PORT_AD_INFO(port)->stats.lacpdu_tx);
+	atomic64_inc(&BOND_AD_INFO(port->bond).stats.lacpdu_tx);
 
-	skb->dev = slave->dev;
+	skb->dev = port->dev;
 	skb_reset_mac_header(skb);
 	skb->network_header = skb->mac_header + ETH_HLEN;
 	skb->protocol = PKT_TYPE_LACPDU;
@@ -843,7 +843,7 @@ static int ad_lacpdu_send(struct ad_port *ad_port)
 	/* Note: source address is set to be the member's PERMANENT address,
 	 * because we use it to identify loopback lacpdus in receive.
 	 */
-	ether_addr_copy(lacpdu_header->hdr.h_source, slave->perm_hwaddr);
+	ether_addr_copy(lacpdu_header->hdr.h_source, port->perm_hwaddr);
 	lacpdu_header->hdr.h_proto = PKT_TYPE_LACPDU;
 
 	lacpdu_header->lacpdu = ad_port->lacpdu;
@@ -863,7 +863,7 @@ static int ad_lacpdu_send(struct ad_port *ad_port)
  */
 static int ad_marker_send(struct ad_port *ad_port, struct bond_marker *marker)
 {
-	struct slave *slave = ad_port->slave;
+	struct bond_port *port = ad_port->port;
 	struct sk_buff *skb;
 	struct bond_marker_header *marker_header;
 	int length = sizeof(struct bond_marker_header);
@@ -874,18 +874,18 @@ static int ad_marker_send(struct ad_port *ad_port, struct bond_marker *marker)
 
 	switch (marker->tlv_type) {
 	case AD_MARKER_INFORMATION_SUBTYPE:
-		atomic64_inc(&SLAVE_AD_INFO(slave)->stats.marker_tx);
-		atomic64_inc(&BOND_AD_INFO(slave->bond).stats.marker_tx);
+		atomic64_inc(&PORT_AD_INFO(port)->stats.marker_tx);
+		atomic64_inc(&BOND_AD_INFO(port->bond).stats.marker_tx);
 		break;
 	case AD_MARKER_RESPONSE_SUBTYPE:
-		atomic64_inc(&SLAVE_AD_INFO(slave)->stats.marker_resp_tx);
-		atomic64_inc(&BOND_AD_INFO(slave->bond).stats.marker_resp_tx);
+		atomic64_inc(&PORT_AD_INFO(port)->stats.marker_resp_tx);
+		atomic64_inc(&BOND_AD_INFO(port->bond).stats.marker_resp_tx);
 		break;
 	}
 
 	skb_reserve(skb, 16);
 
-	skb->dev = slave->dev;
+	skb->dev = port->dev;
 	skb_reset_mac_header(skb);
 	skb->network_header = skb->mac_header + ETH_HLEN;
 	skb->protocol = PKT_TYPE_LACPDU;
@@ -896,7 +896,7 @@ static int ad_marker_send(struct ad_port *ad_port, struct bond_marker *marker)
 	/* Note: source address is set to be the member's PERMANENT address,
 	 * because we use it to identify loopback MARKERs in receive.
 	 */
-	ether_addr_copy(marker_header->hdr.h_source, slave->perm_hwaddr);
+	ether_addr_copy(marker_header->hdr.h_source, port->perm_hwaddr);
 	marker_header->hdr.h_proto = PKT_TYPE_LACPDU;
 
 	marker_header->marker = *marker;
@@ -909,9 +909,9 @@ static int ad_marker_send(struct ad_port *ad_port, struct bond_marker *marker)
 /**
  * ad_mux_machine - handle an ad_port's mux state machine
  * @ad_port: the ad_port we're looking at
- * @update_slave_arr: Does slave array need update?
+ * @update_port_arr: Does port array need update?
  */
-static void ad_mux_machine(struct ad_port *ad_port, bool *update_slave_arr)
+static void ad_mux_machine(struct ad_port *ad_port, bool *update_port_arr)
 {
 	mux_states_t last_state;
 
@@ -1015,15 +1015,15 @@ static void ad_mux_machine(struct ad_port *ad_port, bool *update_slave_arr)
 
 	/* check if the state machine was changed */
 	if (ad_port->sm_mux_state != last_state) {
-		slave_dbg(ad_port->slave->bond->dev, ad_port->slave->dev,
-			  "Mux Machine: Port=%d, Last State=%d, Curr State=%d\n",
-			  ad_port->actor_port_number, last_state,
-			  ad_port->sm_mux_state);
+		port_dbg(ad_port->port->bond->dev, ad_port->port->dev,
+			 "Mux Machine: Port=%d, Last State=%d, Curr State=%d\n",
+			 ad_port->actor_port_number, last_state,
+			 ad_port->sm_mux_state);
 		switch (ad_port->sm_mux_state) {
 		case AD_MUX_DETACHED:
 			ad_port->actor_oper_port_state &= ~LACP_STATE_SYNCHRONIZATION;
 			ad_disable_collecting_distributing(ad_port,
-							   update_slave_arr);
+							   update_port_arr);
 			ad_port->actor_oper_port_state &= ~LACP_STATE_COLLECTING;
 			ad_port->actor_oper_port_state &= ~LACP_STATE_DISTRIBUTING;
 			ad_port->ntt = true;
@@ -1041,7 +1041,7 @@ static void ad_mux_machine(struct ad_port *ad_port, bool *update_slave_arr)
 			ad_port->actor_oper_port_state &= ~LACP_STATE_COLLECTING;
 			ad_port->actor_oper_port_state &= ~LACP_STATE_DISTRIBUTING;
 			ad_disable_collecting_distributing(ad_port,
-							   update_slave_arr);
+							   update_port_arr);
 			ad_port->ntt = true;
 			break;
 		case AD_MUX_COLLECTING_DISTRIBUTING:
@@ -1049,7 +1049,7 @@ static void ad_mux_machine(struct ad_port *ad_port, bool *update_slave_arr)
 			ad_port->actor_oper_port_state |= LACP_STATE_DISTRIBUTING;
 			ad_port->actor_oper_port_state |= LACP_STATE_SYNCHRONIZATION;
 			ad_enable_collecting_distributing(ad_port,
-							  update_slave_arr);
+							  update_port_arr);
 			ad_port->ntt = true;
 			break;
 		default:
@@ -1077,8 +1077,8 @@ static void ad_rx_machine(struct lacpdu *lacpdu, struct ad_port *ad_port)
 	last_state = ad_port->sm_rx_state;
 
 	if (lacpdu) {
-		atomic64_inc(&SLAVE_AD_INFO(ad_port->slave)->stats.lacpdu_rx);
-		atomic64_inc(&BOND_AD_INFO(ad_port->slave->bond).stats.lacpdu_rx);
+		atomic64_inc(&PORT_AD_INFO(ad_port->port)->stats.lacpdu_rx);
+		atomic64_inc(&BOND_AD_INFO(ad_port->port->bond).stats.lacpdu_rx);
 	}
 	/* check if state machine should change state */
 
@@ -1132,11 +1132,11 @@ static void ad_rx_machine(struct lacpdu *lacpdu, struct ad_port *ad_port)
 
 	/* check if the State machine was changed or new lacpdu arrived */
 	if ((ad_port->sm_rx_state != last_state) || (lacpdu)) {
-		slave_dbg(ad_port->slave->bond->dev, ad_port->slave->dev,
-			  "Rx Machine: Port=%d, Last State=%d, Curr State=%d\n",
-			  ad_port->actor_port_number,
-			  last_state,
-			  ad_port->sm_rx_state);
+		port_dbg(ad_port->port->bond->dev, ad_port->port->dev,
+			 "Rx Machine: Port=%d, Last State=%d, Curr State=%d\n",
+			 ad_port->actor_port_number,
+			 last_state,
+			 ad_port->sm_rx_state);
 		switch (ad_port->sm_rx_state) {
 		case AD_RX_INITIALIZE:
 			if (!(ad_port->actor_oper_port_key & AD_DUPLEX_KEY_MASKS))
@@ -1184,8 +1184,8 @@ static void ad_rx_machine(struct lacpdu *lacpdu, struct ad_port *ad_port)
 			/* detect loopback situation */
 			if (MAC_ADDRESS_EQUAL(&(lacpdu->actor_system),
 					      &(ad_port->actor_system))) {
-				slave_err(ad_port->slave->bond->dev, ad_port->slave->dev, "An illegal loopback occurred on slave\n"
-					  "Check the configuration to verify that all adapters are connected to 802.3ad compliant switch ports\n");
+				port_err(ad_port->port->bond->dev, ad_port->port->dev, "An illegal loopback occurred on port\n"
+					 "Check the configuration to verify that all adapters are connected to 802.3ad compliant switch ports\n");
 				return;
 			}
 			__update_selected(lacpdu, ad_port);
@@ -1254,10 +1254,10 @@ static void ad_tx_machine(struct ad_port *ad_port)
 			__update_lacpdu_from_ad_port(ad_port);
 
 			if (ad_lacpdu_send(ad_port) >= 0) {
-				slave_dbg(ad_port->slave->bond->dev,
-					  ad_port->slave->dev,
-					  "Sent LACPDU on port %d\n",
-					  ad_port->actor_port_number);
+				port_dbg(ad_port->port->bond->dev,
+					 ad_port->port->dev,
+					 "Sent LACPDU on port %d\n",
+					 ad_port->actor_port_number);
 
 				/* mark ntt as false, so it will not be sent
 				 * again until demanded
@@ -1336,10 +1336,10 @@ static void ad_periodic_machine(struct ad_port *ad_port)
 
 	/* check if the state machine was changed */
 	if (ad_port->sm_periodic_state != last_state) {
-		slave_dbg(ad_port->slave->bond->dev, ad_port->slave->dev,
-			  "Periodic Machine: Port=%d, Last State=%d, Curr State=%d\n",
-			  ad_port->actor_port_number, last_state,
-			  ad_port->sm_periodic_state);
+		port_dbg(ad_port->port->bond->dev, ad_port->port->dev,
+			 "Periodic Machine: Port=%d, Last State=%d, Curr State=%d\n",
+			 ad_port->actor_port_number, last_state,
+			 ad_port->sm_periodic_state);
 		switch (ad_port->sm_periodic_state) {
 		case AD_NO_PERIODIC:
 			ad_port->sm_periodic_timer_counter = 0;
@@ -1364,19 +1364,19 @@ static void ad_periodic_machine(struct ad_port *ad_port)
 /**
  * ad_port_selection_logic - select aggregation groups
  * @ad_port: the ad_port we're looking at
- * @update_slave_arr: Does slave array need update?
+ * @update_port_arr: Does port array need update?
  *
  * Select aggregation groups, and assign each ad_port for it's aggregetor. The
  * selection logic is called in the inititalization (after all the handshkes),
  * and after every lacpdu receive (if selected is off).
  */
-static void ad_port_selection_logic(struct ad_port *ad_port, bool *update_slave_arr)
+static void ad_port_selection_logic(struct ad_port *ad_port, bool *update_port_arr)
 {
 	struct aggregator *aggregator, *free_aggregator = NULL, *temp_aggregator;
 	struct ad_port *last_port = NULL, *curr_port;
 	struct list_head *iter;
 	struct bonding *bond;
-	struct slave *slave;
+	struct bond_port *port;
 	int found = 0;
 
 	/* if the ad_port is already Selected, do nothing */
@@ -1415,9 +1415,9 @@ static void ad_port_selection_logic(struct ad_port *ad_port, bool *update_slave_
 				ad_port->next_port_in_aggregator = NULL;
 				ad_port->actor_port_aggregator_identifier = 0;
 
-				slave_dbg(bond->dev, ad_port->slave->dev, "Port %d left LAG %d\n",
-					  ad_port->actor_port_number,
-					  temp_aggregator->aggregator_identifier);
+				port_dbg(bond->dev, ad_port->port->dev, "Port %d left LAG %d\n",
+					 ad_port->actor_port_number,
+					 temp_aggregator->aggregator_identifier);
 				/* if the aggregator is empty, clear its
 				 * parameters, and set it ready to be attached
 				 */
@@ -1430,16 +1430,16 @@ static void ad_port_selection_logic(struct ad_port *ad_port, bool *update_slave_
 			/* meaning: the ad_port was related to an aggregator
 			 * but was not on the aggregator ad_port list
 			 */
-			net_warn_ratelimited("%s: (slave %s): Warning: Port %d was related to aggregator %d but was not on its port list\n",
-					     ad_port->slave->bond->dev->name,
-					     ad_port->slave->dev->name,
+			net_warn_ratelimited("%s: (port %s): Warning: Port %d was related to aggregator %d but was not on its port list\n",
+					     ad_port->port->bond->dev->name,
+					     ad_port->port->dev->name,
 					     ad_port->actor_port_number,
 					     ad_port->aggregator->aggregator_identifier);
 		}
 	}
 	/* search all aggregators for a suitable aggregator for this ad_port */
-	bond_for_each_slave(bond, slave, iter) {
-		aggregator = &(SLAVE_AD_INFO(slave)->aggregator);
+	bond_for_each_port(bond, port, iter) {
+		aggregator = &(PORT_AD_INFO(port)->aggregator);
 
 		/* keep a free aggregator for later use(if needed) */
 		if (!aggregator->lag_ports) {
@@ -1464,9 +1464,9 @@ static void ad_port_selection_logic(struct ad_port *ad_port, bool *update_slave_
 			ad_port->next_port_in_aggregator = aggregator->lag_ports;
 			ad_port->aggregator->num_of_ports++;
 			aggregator->lag_ports = ad_port;
-			slave_dbg(bond->dev, slave->dev, "Port %d joined LAG %d (existing LAG)\n",
-				  ad_port->actor_port_number,
-				  ad_port->aggregator->aggregator_identifier);
+			port_dbg(bond->dev, port->dev, "Port %d joined LAG %d (existing LAG)\n",
+				 ad_port->actor_port_number,
+				 ad_port->aggregator->aggregator_identifier);
 
 			/* mark this ad_port as selected */
 			ad_port->sm_vars |= AD_PORT_SELECTED;
@@ -1511,13 +1511,13 @@ static void ad_port_selection_logic(struct ad_port *ad_port, bool *update_slave_
 			/* mark this port as selected */
 			ad_port->sm_vars |= AD_PORT_SELECTED;
 
-			slave_dbg(bond->dev, ad_port->slave->dev, "Port %d joined LAG %d (new LAG)\n",
-				  ad_port->actor_port_number,
-				  ad_port->aggregator->aggregator_identifier);
+			port_dbg(bond->dev, ad_port->port->dev, "Port %d joined LAG %d (new LAG)\n",
+				 ad_port->actor_port_number,
+				 ad_port->aggregator->aggregator_identifier);
 		} else {
-			slave_err(bond->dev, ad_port->slave->dev,
-				  "Port %d did not find a suitable aggregator\n",
-				  ad_port->actor_port_number);
+			port_err(bond->dev, ad_port->port->dev,
+				 "Port %d did not find a suitable aggregator\n",
+				 ad_port->actor_port_number);
 		}
 	}
 	/* if all aggregator's ad_ports are READY_N == TRUE, set ready=TRUE
@@ -1528,7 +1528,7 @@ static void ad_port_selection_logic(struct ad_port *ad_port, bool *update_slave_
 			      __agg_ports_are_ready(ad_port->aggregator));
 
 	aggregator = __get_first_agg(ad_port);
-	ad_agg_selection_logic(aggregator, update_slave_arr);
+	ad_agg_selection_logic(aggregator, update_port_arr);
 
 	if (!ad_port->aggregator->is_active)
 		ad_port->actor_oper_port_state &= ~LACP_STATE_SYNCHRONIZATION;
@@ -1596,9 +1596,9 @@ static struct aggregator *ad_agg_selection_test(struct aggregator *best,
 		break;
 
 	default:
-		net_warn_ratelimited("%s: (slave %s): Impossible agg select mode %d\n",
-				     curr->slave->bond->dev->name,
-				     curr->slave->dev->name,
+		net_warn_ratelimited("%s: (port %s): Impossible agg select mode %d\n",
+				     curr->port->bond->dev->name,
+				     curr->port->dev->name,
 				     __get_agg_selection_mode(curr->lag_ports));
 		break;
 	}
@@ -1615,8 +1615,8 @@ static int agg_device_up(const struct aggregator *agg)
 
 	for (ad_port = agg->lag_ports; ad_port;
 	     ad_port = ad_port->next_port_in_aggregator) {
-		if (netif_running(ad_port->slave->dev) &&
-		    netif_carrier_ok(ad_port->slave->dev))
+		if (netif_running(ad_port->port->dev) &&
+		    netif_carrier_ok(ad_port->port->dev))
 			return 1;
 	}
 
@@ -1626,7 +1626,7 @@ static int agg_device_up(const struct aggregator *agg)
 /**
  * ad_agg_selection_logic - select an aggregation group for a team
  * @agg: the aggregator we're looking at
- * @update_slave_arr: Does slave array need update?
+ * @update_port_arr: Does port array need update?
  *
  * It is assumed that only one aggregator may be selected for a team.
  *
@@ -1639,23 +1639,23 @@ static int agg_device_up(const struct aggregator *agg)
  *
  * BOND_AD_BANDWIDTH: select the aggregator with the highest total
  * bandwidth, and reselect whenever a link state change takes place or the
- * set of slaves in the bond changes.
+ * set of ports in the bond changes.
  *
  * BOND_AD_COUNT: select the aggregator with largest number of ad_ports
- * (slaves), and reselect whenever a link state change takes place or the
- * set of slaves in the bond changes.
+ * (ports), and reselect whenever a link state change takes place or the
+ * set of ports in the bond changes.
  *
  * FIXME: this function MUST be called with the first agg in the bond, or
  * __get_active_agg() won't work correctly. This function should be better
  * called with the bond itself, and retrieve the first agg from it.
  */
 static void ad_agg_selection_logic(struct aggregator *agg,
-				   bool *update_slave_arr)
+				   bool *update_port_arr)
 {
 	struct aggregator *best, *active, *origin;
-	struct bonding *bond = agg->slave->bond;
+	struct bonding *bond = agg->port->bond;
 	struct list_head *iter;
-	struct slave *slave;
+	struct bond_port *port;
 	struct ad_port *ad_port;
 
 	rcu_read_lock();
@@ -1663,8 +1663,8 @@ static void ad_agg_selection_logic(struct aggregator *agg,
 	active = __get_active_agg(agg);
 	best = (active && agg_device_up(active)) ? active : NULL;
 
-	bond_for_each_slave_rcu(bond, slave, iter) {
-		agg = &(SLAVE_AD_INFO(slave)->aggregator);
+	bond_for_each_port_rcu(bond, port, iter) {
+		agg = &(PORT_AD_INFO(port)->aggregator);
 
 		agg->is_active = 0;
 
@@ -1699,24 +1699,24 @@ static void ad_agg_selection_logic(struct aggregator *agg,
 
 	/* if there is new best aggregator, activate it */
 	if (best) {
-		netdev_dbg(bond->dev, "(slave %s): best Agg=%d; P=%d; a k=%d; p k=%d; Ind=%d; Act=%d\n",
-			   best->slave ? best->slave->dev->name : "NULL",
+		netdev_dbg(bond->dev, "(port %s): best Agg=%d; P=%d; a k=%d; p k=%d; Ind=%d; Act=%d\n",
+			   best->port ? best->port->dev->name : "NULL",
 			   best->aggregator_identifier, best->num_of_ports,
 			   best->actor_oper_aggregator_key,
 			   best->partner_oper_aggregator_key,
 			   best->is_individual, best->is_active);
-		netdev_dbg(bond->dev, "(slave %s): best ports %p slave %p\n",
-			   best->slave ? best->slave->dev->name : "NULL",
-			   best->lag_ports, best->slave);
-
-		bond_for_each_slave_rcu(bond, slave, iter) {
-			agg = &(SLAVE_AD_INFO(slave)->aggregator);
-
-			slave_dbg(bond->dev, slave->dev, "Agg=%d; P=%d; a k=%d; p k=%d; Ind=%d; Act=%d\n",
-				  agg->aggregator_identifier, agg->num_of_ports,
-				  agg->actor_oper_aggregator_key,
-				  agg->partner_oper_aggregator_key,
-				  agg->is_individual, agg->is_active);
+		netdev_dbg(bond->dev, "(port %s): best ports %p port %p\n",
+			   best->port ? best->port->dev->name : "NULL",
+			   best->lag_ports, best->port);
+
+		bond_for_each_port_rcu(bond, port, iter) {
+			agg = &(PORT_AD_INFO(port)->aggregator);
+
+			port_dbg(bond->dev, port->dev, "Agg=%d; P=%d; a k=%d; p k=%d; Ind=%d; Act=%d\n",
+				 agg->aggregator_identifier, agg->num_of_ports,
+				 agg->actor_oper_aggregator_key,
+				 agg->partner_oper_aggregator_key,
+				 agg->is_individual, agg->is_active);
 		}
 
 		/* check if any partner replies */
@@ -1725,11 +1725,11 @@ static void ad_agg_selection_logic(struct aggregator *agg,
 					     bond->dev->name);
 
 		best->is_active = 1;
-		netdev_dbg(bond->dev, "(slave %s): LAG %d chosen as the active LAG\n",
-			   best->slave ? best->slave->dev->name : "NULL",
+		netdev_dbg(bond->dev, "(port %s): LAG %d chosen as the active LAG\n",
+			   best->port ? best->port->dev->name : "NULL",
 			   best->aggregator_identifier);
-		netdev_dbg(bond->dev, "(slave %s): Agg=%d; P=%d; a k=%d; p k=%d; Ind=%d; Act=%d\n",
-			   best->slave ? best->slave->dev->name : "NULL",
+		netdev_dbg(bond->dev, "(port %s): Agg=%d; P=%d; a k=%d; p k=%d; Ind=%d; Act=%d\n",
+			   best->port ? best->port->dev->name : "NULL",
 			   best->aggregator_identifier, best->num_of_ports,
 			   best->actor_oper_aggregator_key,
 			   best->partner_oper_aggregator_key,
@@ -1744,8 +1744,8 @@ static void ad_agg_selection_logic(struct aggregator *agg,
 				__disable_ad_port(ad_port);
 			}
 		}
-		/* Slave array needs update. */
-		*update_slave_arr = true;
+		/* Port array needs update. */
+		*update_port_arr = true;
 	}
 
 	/* if the selected aggregator is of join individuals
@@ -1786,8 +1786,8 @@ static void ad_clear_agg(struct aggregator *aggregator)
 		aggregator->is_active = 0;
 		aggregator->num_of_ports = 0;
 		pr_debug("%s: LAG %d was cleared\n",
-			 aggregator->slave ?
-			 aggregator->slave->dev->name : "NULL",
+			 aggregator->port ?
+			 aggregator->port->dev->name : "NULL",
 			 aggregator->aggregator_identifier);
 	}
 }
@@ -1803,7 +1803,7 @@ static void ad_initialize_agg(struct aggregator *aggregator)
 
 		eth_zero_addr(aggregator->aggregator_mac_address.mac_addr_value);
 		aggregator->aggregator_identifier = 0;
-		aggregator->slave = NULL;
+		aggregator->port = NULL;
 	}
 }
 
@@ -1876,42 +1876,42 @@ static void ad_initialize_port(struct ad_port *ad_port, int lacp_fast)
 /**
  * ad_enable_collecting_distributing - enable an ad_port's transmit/receive
  * @ad_port: the ad_port we're looking at
- * @update_slave_arr: Does slave array need update?
+ * @update_port_arr: Does port array need update?
  *
  * Enable @ad_port if it's in an active aggregator
  */
 static void ad_enable_collecting_distributing(struct ad_port *ad_port,
-					      bool *update_slave_arr)
+					      bool *update_port_arr)
 {
 	if (ad_port->aggregator->is_active) {
-		slave_dbg(ad_port->slave->bond->dev, ad_port->slave->dev,
-			  "Enabling port %d (LAG %d)\n",
-			  ad_port->actor_port_number,
-			  ad_port->aggregator->aggregator_identifier);
+		port_dbg(ad_port->port->bond->dev, ad_port->port->dev,
+			 "Enabling port %d (LAG %d)\n",
+			 ad_port->actor_port_number,
+			 ad_port->aggregator->aggregator_identifier);
 		__enable_ad_port(ad_port);
-		/* Slave array needs update */
-		*update_slave_arr = true;
+		/* Port array needs update */
+		*update_port_arr = true;
 	}
 }
 
 /**
  * ad_disable_collecting_distributing - disable an ad_port's transmit/receive
  * @ad_port: the ad_port we're looking at
- * @update_slave_arr: Does slave array need update?
+ * @update_port_arr: Does port array need update?
  */
 static void ad_disable_collecting_distributing(struct ad_port *ad_port,
-					       bool *update_slave_arr)
+					       bool *update_port_arr)
 {
 	if (ad_port->aggregator &&
 	    !MAC_ADDRESS_EQUAL(&(ad_port->aggregator->partner_system),
 			       &(null_mac_addr))) {
-		slave_dbg(ad_port->slave->bond->dev, ad_port->slave->dev,
-			  "Disabling port %d (LAG %d)\n",
-			  ad_port->actor_port_number,
-			  ad_port->aggregator->aggregator_identifier);
+		port_dbg(ad_port->port->bond->dev, ad_port->port->dev,
+			 "Disabling port %d (LAG %d)\n",
+			 ad_port->actor_port_number,
+			 ad_port->aggregator->aggregator_identifier);
 		__disable_ad_port(ad_port);
-		/* Slave array needs an update */
-		*update_slave_arr = true;
+		/* Port array needs an update */
+		*update_port_arr = true;
 	}
 }
 
@@ -1925,8 +1925,8 @@ static void ad_marker_info_received(struct bond_marker *marker_info,
 {
 	struct bond_marker marker;
 
-	atomic64_inc(&SLAVE_AD_INFO(ad_port->slave)->stats.marker_rx);
-	atomic64_inc(&BOND_AD_INFO(ad_port->slave->bond).stats.marker_rx);
+	atomic64_inc(&PORT_AD_INFO(ad_port->port)->stats.marker_rx);
+	atomic64_inc(&BOND_AD_INFO(ad_port->port->bond).stats.marker_rx);
 
 	/* copy the received marker data to the response marker */
 	memcpy(&marker, marker_info, sizeof(struct bond_marker));
@@ -1935,9 +1935,9 @@ static void ad_marker_info_received(struct bond_marker *marker_info,
 
 	/* send the marker response */
 	if (ad_marker_send(ad_port, &marker) >= 0)
-		slave_dbg(ad_port->slave->bond->dev, ad_port->slave->dev,
-			  "Sent Marker Response on port %d\n",
-			  ad_port->actor_port_number);
+		port_dbg(ad_port->port->bond->dev, ad_port->port->dev,
+			 "Sent Marker Response on port %d\n",
+			 ad_port->actor_port_number);
 }
 
 /**
@@ -1952,8 +1952,8 @@ static void ad_marker_info_received(struct bond_marker *marker_info,
 static void ad_marker_response_received(struct bond_marker *marker,
 					struct ad_port *ad_port)
 {
-	atomic64_inc(&SLAVE_AD_INFO(ad_port->slave)->stats.marker_resp_rx);
-	atomic64_inc(&BOND_AD_INFO(ad_port->slave->bond).stats.marker_resp_rx);
+	atomic64_inc(&PORT_AD_INFO(ad_port->port)->stats.marker_resp_rx);
+	atomic64_inc(&BOND_AD_INFO(ad_port->port->bond).stats.marker_resp_rx);
 
 	/* DO NOTHING, SINCE WE DECIDED NOT TO IMPLEMENT THIS FEATURE FOR NOW */
 }
@@ -2013,28 +2013,28 @@ void bond_3ad_initialize(struct bonding *bond, u16 tick_resolution)
 }
 
 /**
- * bond_3ad_bind_slave - initialize a slave's ad_port
- * @slave: slave struct to work on
+ * bond_3ad_bind_port - initialize a port's ad_port
+ * @port: port struct to work on
  *
  * Returns:   0 on success
  *          < 0 on error
  */
-void bond_3ad_bind_slave(struct slave *slave)
+void bond_3ad_bind_port(struct bond_port *port)
 {
-	struct bonding *bond = bond_get_bond_by_slave(slave);
+	struct bonding *bond = bond_get_bond_by_port(port);
 	struct ad_port *ad_port;
 	struct aggregator *aggregator;
 
-	/* check that the slave has not been initialized yet. */
-	if (SLAVE_AD_INFO(slave)->ad_port.slave != slave) {
+	/* check that the port has not been initialized yet. */
+	if (PORT_AD_INFO(port)->ad_port.port != port) {
 
 		/* ad_port initialization */
-		ad_port = &(SLAVE_AD_INFO(slave)->ad_port);
+		ad_port = &(PORT_AD_INFO(port)->ad_port);
 
 		ad_initialize_port(ad_port, bond->params.lacp_fast);
 
-		ad_port->slave = slave;
-		ad_port->actor_port_number = SLAVE_AD_INFO(slave)->id;
+		ad_port->port = port;
+		ad_port->actor_port_number = PORT_AD_INFO(port)->id;
 		/* key is determined according to the link speed, duplex and
 		 * user key
 		 */
@@ -2050,49 +2050,49 @@ void bond_3ad_bind_slave(struct slave *slave)
 		__disable_ad_port(ad_port);
 
 		/* aggregator initialization */
-		aggregator = &(SLAVE_AD_INFO(slave)->aggregator);
+		aggregator = &(PORT_AD_INFO(port)->aggregator);
 
 		ad_initialize_agg(aggregator);
 
 		aggregator->aggregator_mac_address = *((struct mac_addr *)bond->dev->dev_addr);
 		aggregator->aggregator_identifier = ++BOND_AD_INFO(bond).aggregator_identifier;
-		aggregator->slave = slave;
+		aggregator->port = port;
 		aggregator->is_active = 0;
 		aggregator->num_of_ports = 0;
 	}
 }
 
 /**
- * bond_3ad_unbind_slave - deinitialize a slave's ad_port
- * @slave: slave struct to work on
+ * bond_3ad_unbind_port - deinitialize a port's ad_port
+ * @port: port struct to work on
  *
  * Search for the aggregator that is related to this ad_port, remove the
  * aggregator and assign another aggregator for other ad_port related to it
  * (if any), and remove the ad_port.
  */
-void bond_3ad_unbind_slave(struct slave *slave)
+void bond_3ad_unbind_port(struct bond_port *port)
 {
 	struct ad_port *ad_port, *prev_port, *temp_port;
 	struct aggregator *aggregator, *new_aggregator, *temp_aggregator;
 	int select_new_active_agg = 0;
-	struct bonding *bond = slave->bond;
-	struct slave *slave_iter;
+	struct bonding *bond = port->bond;
+	struct bond_port *port_iter;
 	struct list_head *iter;
-	bool dummy_slave_update; /* Ignore this value as caller updates array */
+	bool dummy_port_update; /* Ignore this value as caller updates array */
 
 	/* Sync against bond_3ad_state_machine_handler() */
 	spin_lock_bh(&bond->mode_lock);
-	aggregator = &(SLAVE_AD_INFO(slave)->aggregator);
-	ad_port = &(SLAVE_AD_INFO(slave)->ad_port);
+	aggregator = &(PORT_AD_INFO(port)->aggregator);
+	ad_port = &(PORT_AD_INFO(port)->ad_port);
 
-	/* if slave is null, the whole ad_port is not initialized */
-	if (!ad_port->slave) {
-		slave_warn(bond->dev, slave->dev, "Trying to unbind an uninitialized port\n");
+	/* if port is null, the whole ad_port is not initialized */
+	if (!ad_port->port) {
+		port_warn(bond->dev, port->dev, "Trying to unbind an uninitialized port\n");
 		goto out;
 	}
 
-	slave_dbg(bond->dev, slave->dev, "Unbinding Link Aggregation Group %d\n",
-		  aggregator->aggregator_identifier);
+	port_dbg(bond->dev, port->dev, "Unbinding Link Aggregation Group %d\n",
+		 aggregator->aggregator_identifier);
 
 	/* Tell the partner that this ad_port is not suitable for aggregation */
 	ad_port->actor_oper_port_state &= ~LACP_STATE_SYNCHRONIZATION;
@@ -2105,15 +2105,15 @@ void bond_3ad_unbind_slave(struct slave *slave)
 	/* check if this aggregator is occupied */
 	if (aggregator->lag_ports) {
 		/* check if there are other ad_ports related to this aggregator
-		 * except the ad_port related to this slave(thats ensure us that
+		 * except the ad_port related to this port (thats ensure us that
 		 * there is a reason to search for new aggregator, and that we
 		 * will find one
 		 */
 		if ((aggregator->lag_ports != ad_port) ||
 		    (aggregator->lag_ports->next_port_in_aggregator)) {
 			/* find new aggregator for the related ad_port(s) */
-			bond_for_each_slave(bond, slave_iter, iter) {
-				new_aggregator = &(SLAVE_AD_INFO(slave_iter)->aggregator);
+			bond_for_each_port(bond, port_iter, iter) {
+				new_aggregator = &(PORT_AD_INFO(port_iter)->aggregator);
 				/* if the new aggregator is empty, or it is
 				 * connected to our ad_port only
 				 */
@@ -2122,7 +2122,7 @@ void bond_3ad_unbind_slave(struct slave *slave)
 				     !new_aggregator->lag_ports->next_port_in_aggregator))
 					break;
 			}
-			if (!slave_iter)
+			if (!port_iter)
 				new_aggregator = NULL;
 
 			/* if new aggregator found, copy the aggregator's
@@ -2130,13 +2130,13 @@ void bond_3ad_unbind_slave(struct slave *slave)
 			 * new aggregator
 			 */
 			if ((new_aggregator) && ((!new_aggregator->lag_ports) || ((new_aggregator->lag_ports == ad_port) && !new_aggregator->lag_ports->next_port_in_aggregator))) {
-				slave_dbg(bond->dev, slave->dev, "Some port(s) related to LAG %d - replacing with LAG %d\n",
-					  aggregator->aggregator_identifier,
-					  new_aggregator->aggregator_identifier);
+				port_dbg(bond->dev, port->dev, "Some port(s) related to LAG %d - replacing with LAG %d\n",
+					 aggregator->aggregator_identifier,
+					 new_aggregator->aggregator_identifier);
 
 				if ((new_aggregator->lag_ports == ad_port) &&
 				    new_aggregator->is_active) {
-					slave_info(bond->dev, slave->dev, "Removing an active aggregator\n");
+					port_info(bond->dev, port->dev, "Removing an active aggregator\n");
 					select_new_active_agg = 1;
 				}
 
@@ -2165,9 +2165,9 @@ void bond_3ad_unbind_slave(struct slave *slave)
 
 				if (select_new_active_agg)
 					ad_agg_selection_logic(__get_first_agg(ad_port),
-							       &dummy_slave_update);
+							       &dummy_port_update);
 			} else {
-				slave_warn(bond->dev, slave->dev, "unbinding aggregator, and could not find a new aggregator for its ports\n");
+				port_warn(bond->dev, port->dev, "unbinding aggregator, and could not find a new aggregator for its ports\n");
 			}
 		} else {
 			/* in case that the only ad_port related to this
@@ -2176,21 +2176,21 @@ void bond_3ad_unbind_slave(struct slave *slave)
 			select_new_active_agg = aggregator->is_active;
 			ad_clear_agg(aggregator);
 			if (select_new_active_agg) {
-				slave_info(bond->dev, slave->dev, "Removing an active aggregator\n");
+				port_info(bond->dev, port->dev, "Removing an active aggregator\n");
 				/* select new active aggregator */
 				temp_aggregator = __get_first_agg(ad_port);
 				if (temp_aggregator)
 					ad_agg_selection_logic(temp_aggregator,
-							       &dummy_slave_update);
+							       &dummy_port_update);
 			}
 		}
 	}
 
-	slave_dbg(bond->dev, slave->dev, "Unbinding port %d\n", ad_port->actor_port_number);
+	port_dbg(bond->dev, port->dev, "Unbinding port %d\n", ad_port->actor_port_number);
 
 	/* find the aggregator that this ad_port is connected to */
-	bond_for_each_slave(bond, slave_iter, iter) {
-		temp_aggregator = &(SLAVE_AD_INFO(slave_iter)->aggregator);
+	bond_for_each_port(bond, port_iter, iter) {
+		temp_aggregator = &(PORT_AD_INFO(port_iter)->aggregator);
 		prev_port = NULL;
 		/* search the ad_port in the aggregator's related ad_ports */
 		for (temp_port = temp_aggregator->lag_ports; temp_port;
@@ -2209,17 +2209,17 @@ void bond_3ad_unbind_slave(struct slave *slave)
 					select_new_active_agg = temp_aggregator->is_active;
 					ad_clear_agg(temp_aggregator);
 					if (select_new_active_agg) {
-						slave_info(bond->dev, slave->dev, "Removing an active aggregator\n");
+						port_info(bond->dev, port->dev, "Removing an active aggregator\n");
 						/* select new active aggregator */
 						ad_agg_selection_logic(__get_first_agg(ad_port),
-							               &dummy_slave_update);
+							               &dummy_port_update);
 					}
 				}
 				break;
 			}
 		}
 	}
-	ad_port->slave = NULL;
+	ad_port->port = NULL;
 
 out:
 	spin_unlock_bh(&bond->mode_lock);
@@ -2235,7 +2235,7 @@ void bond_3ad_unbind_slave(struct slave *slave)
 void bond_3ad_update_ad_actor_settings(struct bonding *bond)
 {
 	struct list_head *iter;
-	struct slave *slave;
+	struct bond_port *port;
 
 	ASSERT_RTNL();
 
@@ -2248,8 +2248,8 @@ void bond_3ad_update_ad_actor_settings(struct bonding *bond)
 		    *((struct mac_addr *)bond->params.ad_actor_system);
 
 	spin_lock_bh(&bond->mode_lock);
-	bond_for_each_slave(bond, slave, iter) {
-		struct ad_port *ad_port = &(SLAVE_AD_INFO(slave))->ad_port;
+	bond_for_each_port(bond, port, iter) {
+		struct ad_port *ad_port = &(PORT_AD_INFO(port))->ad_port;
 
 		__ad_actor_update_port(ad_port);
 		ad_port->ntt = true;
@@ -2276,46 +2276,46 @@ void bond_3ad_state_machine_handler(struct work_struct *work)
 					    ad_work.work);
 	struct aggregator *aggregator;
 	struct list_head *iter;
-	struct slave *slave;
+	struct bond_port *port;
 	struct ad_port *ad_port;
-	bool should_notify_rtnl = BOND_SLAVE_NOTIFY_LATER;
-	bool update_slave_arr = false;
+	bool should_notify_rtnl = BOND_PORT_NOTIFY_LATER;
+	bool update_port_arr = false;
 
 	/* Lock to protect data accessed by all (e.g., ad_port->sm_vars) and
-	 * against running with bond_3ad_unbind_slave. ad_rx_machine may run
+	 * against running with bond_3ad_unbind_port. ad_rx_machine may run
 	 * concurrently due to incoming LACPDU as well.
 	 */
 	spin_lock_bh(&bond->mode_lock);
 	rcu_read_lock();
 
-	/* check if there are any slaves */
-	if (!bond_has_slaves(bond))
+	/* check if there are any ports */
+	if (!bond_has_ports(bond))
 		goto re_arm;
 
 	/* check if agg_select_timer timer after initialize is timed out */
 	if (BOND_AD_INFO(bond).agg_select_timer &&
 	    !(--BOND_AD_INFO(bond).agg_select_timer)) {
-		slave = bond_first_slave_rcu(bond);
-		ad_port = slave ? &(SLAVE_AD_INFO(slave)->ad_port) : NULL;
+		port = bond_first_port_rcu(bond);
+		ad_port = port ? &(PORT_AD_INFO(port)->ad_port) : NULL;
 
 		/* select the active aggregator for the bond */
 		if (ad_port) {
-			if (!ad_port->slave) {
+			if (!ad_port->port) {
 				net_warn_ratelimited("%s: Warning: bond's first port is uninitialized\n",
 						     bond->dev->name);
 				goto re_arm;
 			}
 
 			aggregator = __get_first_agg(ad_port);
-			ad_agg_selection_logic(aggregator, &update_slave_arr);
+			ad_agg_selection_logic(aggregator, &update_port_arr);
 		}
 		bond_3ad_set_carrier(bond);
 	}
 
 	/* for each ad_port run the state machines */
-	bond_for_each_slave_rcu(bond, slave, iter) {
-		ad_port = &(SLAVE_AD_INFO(slave)->ad_port);
-		if (!ad_port->slave) {
+	bond_for_each_port_rcu(bond, port, iter) {
+		ad_port = &(PORT_AD_INFO(port)->ad_port);
+		if (!ad_port->port) {
 			net_warn_ratelimited("%s: Warning: Found an uninitialized port\n",
 					    bond->dev->name);
 			goto re_arm;
@@ -2323,8 +2323,8 @@ void bond_3ad_state_machine_handler(struct work_struct *work)
 
 		ad_rx_machine(NULL, ad_port);
 		ad_periodic_machine(ad_port);
-		ad_port_selection_logic(ad_port, &update_slave_arr);
-		ad_mux_machine(ad_port, &update_slave_arr);
+		ad_port_selection_logic(ad_port, &update_port_arr);
+		ad_mux_machine(ad_port, &update_port_arr);
 		ad_tx_machine(ad_port);
 		ad_churn_machine(ad_port);
 
@@ -2334,20 +2334,20 @@ void bond_3ad_state_machine_handler(struct work_struct *work)
 	}
 
 re_arm:
-	bond_for_each_slave_rcu(bond, slave, iter) {
-		if (slave->should_notify) {
-			should_notify_rtnl = BOND_SLAVE_NOTIFY_NOW;
+	bond_for_each_port_rcu(bond, port, iter) {
+		if (port->should_notify) {
+			should_notify_rtnl = BOND_PORT_NOTIFY_NOW;
 			break;
 		}
 	}
 	rcu_read_unlock();
 	spin_unlock_bh(&bond->mode_lock);
 
-	if (update_slave_arr)
-		bond_slave_arr_work_rearm(bond, 0);
+	if (update_port_arr)
+		bond_port_arr_work_rearm(bond, 0);
 
 	if (should_notify_rtnl && rtnl_trylock()) {
-		bond_slave_state_notify(bond);
+		bond_port_state_notify(bond);
 		rtnl_unlock();
 	}
 	queue_delayed_work(bond->wq, &bond->ad_work, ad_delta_in_ticks);
@@ -2356,37 +2356,37 @@ void bond_3ad_state_machine_handler(struct work_struct *work)
 /**
  * bond_3ad_rx_indication - handle a received frame
  * @lacpdu: received lacpdu
- * @slave: slave struct to work on
+ * @port: port struct to work on
  *
  * It is assumed that frames that were sent on this NIC don't returned as new
  * received frames (loopback). Since only the payload is given to this
  * function, it check for loopback.
  */
-static int bond_3ad_rx_indication(struct lacpdu *lacpdu, struct slave *slave)
+static int bond_3ad_rx_indication(struct lacpdu *lacpdu, struct bond_port *port)
 {
-	struct bonding *bond = slave->bond;
+	struct bonding *bond = port->bond;
 	int ret = RX_HANDLER_ANOTHER;
 	struct bond_marker *marker;
 	struct ad_port *ad_port;
 	atomic64_t *stat;
 
-	ad_port = &(SLAVE_AD_INFO(slave)->ad_port);
-	if (!ad_port->slave) {
-		net_warn_ratelimited("%s: Warning: port of slave %s is uninitialized\n",
-				     slave->dev->name, slave->bond->dev->name);
+	ad_port = &(PORT_AD_INFO(port)->ad_port);
+	if (!ad_port->port) {
+		net_warn_ratelimited("%s: Warning: port of bond %s is uninitialized\n",
+				     port->dev->name, port->bond->dev->name);
 		return ret;
 	}
 
 	switch (lacpdu->subtype) {
 	case AD_TYPE_LACPDU:
 		ret = RX_HANDLER_CONSUMED;
-		slave_dbg(slave->bond->dev, slave->dev,
-			  "Received LACPDU on port %d\n",
-			  ad_port->actor_port_number);
+		port_dbg(port->bond->dev, port->dev,
+			 "Received LACPDU on port %d\n",
+			 ad_port->actor_port_number);
 		/* Protect against concurrent state machines */
-		spin_lock(&slave->bond->mode_lock);
+		spin_lock(&port->bond->mode_lock);
 		ad_rx_machine(lacpdu, ad_port);
-		spin_unlock(&slave->bond->mode_lock);
+		spin_unlock(&port->bond->mode_lock);
 		break;
 	case AD_TYPE_MARKER:
 		ret = RX_HANDLER_CONSUMED;
@@ -2396,26 +2396,26 @@ static int bond_3ad_rx_indication(struct lacpdu *lacpdu, struct slave *slave)
 		marker = (struct bond_marker *)lacpdu;
 		switch (marker->tlv_type) {
 		case AD_MARKER_INFORMATION_SUBTYPE:
-			slave_dbg(slave->bond->dev, slave->dev, "Received Marker Information on port %d\n",
-				  ad_port->actor_port_number);
+			port_dbg(port->bond->dev, port->dev, "Received Marker Information on port %d\n",
+				 ad_port->actor_port_number);
 			ad_marker_info_received(marker, ad_port);
 			break;
 		case AD_MARKER_RESPONSE_SUBTYPE:
-			slave_dbg(slave->bond->dev, slave->dev, "Received Marker Response on port %d\n",
-				  ad_port->actor_port_number);
+			port_dbg(port->bond->dev, port->dev, "Received Marker Response on port %d\n",
+				 ad_port->actor_port_number);
 			ad_marker_response_received(marker, ad_port);
 			break;
 		default:
-			slave_dbg(slave->bond->dev, slave->dev, "Received an unknown Marker subtype on port %d\n",
-				  ad_port->actor_port_number);
-			stat = &SLAVE_AD_INFO(slave)->stats.marker_unknown_rx;
+			port_dbg(port->bond->dev, port->dev, "Received an unknown Marker subtype on port %d\n",
+				 ad_port->actor_port_number);
+			stat = &PORT_AD_INFO(port)->stats.marker_unknown_rx;
 			atomic64_inc(stat);
 			stat = &BOND_AD_INFO(bond).stats.marker_unknown_rx;
 			atomic64_inc(stat);
 		}
 		break;
 	default:
-		atomic64_inc(&SLAVE_AD_INFO(slave)->stats.lacpdu_unknown_rx);
+		atomic64_inc(&PORT_AD_INFO(port)->stats.lacpdu_unknown_rx);
 		atomic64_inc(&BOND_AD_INFO(bond).stats.lacpdu_unknown_rx);
 	}
 
@@ -2457,10 +2457,10 @@ static void ad_update_actor_keys(struct ad_port *ad_port, bool reset)
 
 		if (!reset) {
 			if (!speed) {
-				slave_err(ad_port->slave->bond->dev,
-					  ad_port->slave->dev,
-					  "speed changed to 0 on port %d\n",
-					  ad_port->actor_port_number);
+				port_err(ad_port->port->bond->dev,
+					 ad_port->port->dev,
+					 "speed changed to 0 on port %d\n",
+					 ad_port->actor_port_number);
 			} else if (duplex && ospeed != speed) {
 				/* Speed change restarts LACP state-machine */
 				ad_port->sm_vars |= AD_PORT_BEGIN;
@@ -2470,55 +2470,55 @@ static void ad_update_actor_keys(struct ad_port *ad_port, bool reset)
 }
 
 /**
- * bond_3ad_adapter_speed_duplex_changed - handle a slave's speed / duplex
+ * bond_3ad_adapter_speed_duplex_changed - handle a port's speed / duplex
  * change indication
  *
- * @slave: slave struct to work on
+ * @port: port struct to work on
  *
  * Handle reselection of aggregator (if needed) for this ad_port.
  */
-void bond_3ad_adapter_speed_duplex_changed(struct slave *slave)
+void bond_3ad_adapter_speed_duplex_changed(struct bond_port *port)
 {
 	struct ad_port *ad_port;
 
-	ad_port = &(SLAVE_AD_INFO(slave)->ad_port);
+	ad_port = &(PORT_AD_INFO(port)->ad_port);
 
-	/* if slave is null, the whole ad_port is not initialized */
-	if (!ad_port->slave) {
-		slave_warn(slave->bond->dev, slave->dev,
-			   "speed/duplex changed for uninitialized port\n");
+	/* if port is null, the whole ad_port is not initialized */
+	if (!ad_port->port) {
+		port_warn(port->bond->dev, port->dev,
+			  "speed/duplex changed for uninitialized port\n");
 		return;
 	}
 
-	spin_lock_bh(&slave->bond->mode_lock);
+	spin_lock_bh(&port->bond->mode_lock);
 	ad_update_actor_keys(ad_port, false);
-	spin_unlock_bh(&slave->bond->mode_lock);
-	slave_dbg(slave->bond->dev, slave->dev, "Port %d changed speed/duplex\n",
-		  ad_port->actor_port_number);
+	spin_unlock_bh(&port->bond->mode_lock);
+	port_dbg(port->bond->dev, port->dev, "Port %d changed speed/duplex\n",
+		 ad_port->actor_port_number);
 }
 
 /**
- * bond_3ad_handle_link_change - handle a slave's link status change indication
- * @slave: slave struct to work on
+ * bond_3ad_handle_link_change - handle a port's link status change indication
+ * @port: port struct to work on
  * @link: whether the link is now up or down
  *
  * Handle reselection of aggregator (if needed) for this ad_port.
  */
-void bond_3ad_handle_link_change(struct slave *slave, char link)
+void bond_3ad_handle_link_change(struct bond_port *port, char link)
 {
 	struct aggregator *agg;
 	struct ad_port *ad_port;
 	bool dummy;
 
-	ad_port = &(SLAVE_AD_INFO(slave)->ad_port);
+	ad_port = &(PORT_AD_INFO(port)->ad_port);
 
-	/* if slave is null, the whole ad_port is not initialized */
-	if (!ad_port->slave) {
-		slave_warn(slave->bond->dev, slave->dev, "link status changed for uninitialized port\n");
+	/* if port is null, the whole ad_port is not initialized */
+	if (!ad_port->port) {
+		port_warn(port->bond->dev, port->dev, "link status changed for uninitialized port\n");
 		return;
 	}
 
-	spin_lock_bh(&slave->bond->mode_lock);
+	spin_lock_bh(&port->bond->mode_lock);
 	/* on link down we are zeroing duplex and speed since
 	 * some of the adaptors(ce1000.lan) report full duplex/speed
 	 * instead of N/A(duplex) / 0(speed).
@@ -2537,16 +2537,16 @@ void bond_3ad_handle_link_change(struct slave *slave, char link)
 	agg = __get_first_agg(ad_port);
 	ad_agg_selection_logic(agg, &dummy);
 
-	spin_unlock_bh(&slave->bond->mode_lock);
+	spin_unlock_bh(&port->bond->mode_lock);
 
-	slave_dbg(slave->bond->dev, slave->dev, "Port %d changed link status to %s\n",
-		  ad_port->actor_port_number,
-		  link == BOND_LINK_UP ? "UP" : "DOWN");
+	port_dbg(port->bond->dev, port->dev, "Port %d changed link status to %s\n",
+		 ad_port->actor_port_number,
+		 link == BOND_LINK_UP ? "UP" : "DOWN");
 
 	/* RTNL is held and mode_lock is released so it's safe
-	 * to update slave_array here.
+	 * to update port_array here.
 	 */
-	bond_update_slave_arr(slave->bond, NULL);
+	bond_update_port_arr(port->bond, NULL);
 }
 
 /**
@@ -2555,7 +2555,7 @@ void bond_3ad_handle_link_change(struct slave *slave, char link)
  *
  * if we have an active aggregator, we're up, if not, we're down.
  * Presumes that we cannot have an active aggregator if there are
- * no slaves with link up.
+ * no ports with link up.
  *
  * This behavior complies with IEEE 802.3 section 43.3.9.
  *
@@ -2565,18 +2565,18 @@ void bond_3ad_handle_link_change(struct slave *slave, char link)
 int bond_3ad_set_carrier(struct bonding *bond)
 {
 	struct aggregator *active;
-	struct slave *first_slave;
+	struct bond_port *first_port;
 	int ret = 1;
 
 	rcu_read_lock();
-	first_slave = bond_first_slave_rcu(bond);
-	if (!first_slave) {
+	first_port = bond_first_port_rcu(bond);
+	if (!first_port) {
 		ret = 0;
 		goto out;
 	}
-	active = __get_active_agg(&(SLAVE_AD_INFO(first_slave)->aggregator));
+	active = __get_active_agg(&(PORT_AD_INFO(first_port)->aggregator));
 	if (active) {
-		/* are enough slaves available to consider link up? */
+		/* are enough ports available to consider link up? */
 		if (__agg_active_ad_ports(active) < bond->params.min_links) {
 			if (netif_carrier_ok(bond->dev)) {
 				netif_carrier_off(bond->dev);
@@ -2607,11 +2607,11 @@ int __bond_3ad_get_active_agg_info(struct bonding *bond,
 {
 	struct aggregator *aggregator = NULL;
 	struct list_head *iter;
-	struct slave *slave;
+	struct bond_port *port;
 	struct ad_port *ad_port;
 
-	bond_for_each_slave_rcu(bond, slave, iter) {
-		ad_port = &(SLAVE_AD_INFO(slave)->ad_port);
+	bond_for_each_port_rcu(bond, port, iter) {
+		ad_port = &(PORT_AD_INFO(port)->ad_port);
 		if (ad_port->aggregator && ad_port->aggregator->is_active) {
 			aggregator = ad_port->aggregator;
 			break;
@@ -2642,7 +2642,7 @@ int bond_3ad_get_active_agg_info(struct bonding *bond, struct ad_info *ad_info)
 }
 
 int bond_3ad_lacpdu_recv(const struct sk_buff *skb, struct bonding *bond,
-			 struct slave *slave)
+			 struct bond_port *port)
 {
 	struct lacpdu *lacpdu, _lacpdu;
 
@@ -2654,12 +2654,12 @@ int bond_3ad_lacpdu_recv(const struct sk_buff *skb, struct bonding *bond,
 
 	lacpdu = skb_header_pointer(skb, 0, sizeof(_lacpdu), &_lacpdu);
 	if (!lacpdu) {
-		atomic64_inc(&SLAVE_AD_INFO(slave)->stats.lacpdu_illegal_rx);
+		atomic64_inc(&PORT_AD_INFO(port)->stats.lacpdu_illegal_rx);
 		atomic64_inc(&BOND_AD_INFO(bond).stats.lacpdu_illegal_rx);
 		return RX_HANDLER_ANOTHER;
 	}
 
-	return bond_3ad_rx_indication(lacpdu, slave);
+	return bond_3ad_rx_indication(lacpdu, port);
 }
 
 /**
@@ -2677,13 +2677,13 @@ void bond_3ad_update_lacp_rate(struct bonding *bond)
 {
 	struct ad_port *ad_port = NULL;
 	struct list_head *iter;
-	struct slave *slave;
+	struct bond_port *port;
 	int lacp_fast;
 
 	lacp_fast = bond->params.lacp_fast;
 	spin_lock_bh(&bond->mode_lock);
-	bond_for_each_slave(bond, slave, iter) {
-		ad_port = &(SLAVE_AD_INFO(slave)->ad_port);
+	bond_for_each_port(bond, port, iter) {
+		ad_port = &(PORT_AD_INFO(port)->ad_port);
 		if (lacp_fast)
 			ad_port->actor_oper_port_state |= LACP_STATE_LACP_TIMEOUT;
 		else
diff --git a/drivers/net/bonding/bond_alb.c b/drivers/net/bonding/bond_alb.c
index 4e1b7deb724b..fd8f208c5852 100644
--- a/drivers/net/bonding/bond_alb.c
+++ b/drivers/net/bonding/bond_alb.c
@@ -51,7 +51,7 @@ struct arp_pkt {
 #pragma pack()
 
 /* Forward declaration */
-static void alb_send_learning_packets(struct slave *slave, u8 mac_addr[],
+static void alb_send_learning_packets(struct bond_port *port, u8 mac_addr[],
 				      bool strict_match);
 static void rlb_purge_src_ip(struct bonding *bond, struct arp_pkt *arp);
 static void rlb_src_unlink(struct bonding *bond, u32 index);
@@ -79,29 +79,29 @@ static inline void tlb_init_table_entry(struct tlb_client_info *entry, int save_
 		entry->tx_bytes = 0;
 	}
 
-	entry->tx_slave = NULL;
+	entry->tx_port = NULL;
 	entry->next = TLB_NULL_INDEX;
 	entry->prev = TLB_NULL_INDEX;
 }
 
-static inline void tlb_init_slave(struct slave *slave)
+static inline void tlb_init_port(struct bond_port *port)
 {
-	SLAVE_TLB_INFO(slave).load = 0;
-	SLAVE_TLB_INFO(slave).head = TLB_NULL_INDEX;
+	PORT_TLB_INFO(port).load = 0;
+	PORT_TLB_INFO(port).head = TLB_NULL_INDEX;
 }
 
-static void __tlb_clear_slave(struct bonding *bond, struct slave *slave,
-			 int save_load)
+static void __tlb_clear_port(struct bonding *bond, struct bond_port *port,
+			     int save_load)
 {
 	struct tlb_client_info *tx_hash_table;
 	u32 index;
 
-	/* clear slave from tx_hashtbl */
+	/* clear port from tx_hashtbl */
 	tx_hash_table = BOND_ALB_INFO(bond).tx_hashtbl;
 
 	/* skip this if we've already freed the tx hash table */
 	if (tx_hash_table) {
-		index = SLAVE_TLB_INFO(slave).head;
+		index = PORT_TLB_INFO(port).head;
 		while (index != TLB_NULL_INDEX) {
 			u32 next_index = tx_hash_table[index].next;
 			tlb_init_table_entry(&tx_hash_table[index], save_load);
@@ -109,14 +109,14 @@ static void __tlb_clear_slave(struct bonding *bond, struct slave *slave,
 		}
 	}
 
-	tlb_init_slave(slave);
+	tlb_init_port(port);
 }
 
-static void tlb_clear_slave(struct bonding *bond, struct slave *slave,
-			 int save_load)
+static void tlb_clear_port(struct bonding *bond, struct bond_port *port,
+			   int save_load)
 {
 	spin_lock_bh(&bond->mode_lock);
-	__tlb_clear_slave(bond, slave, save_load);
+	__tlb_clear_port(bond, port, save_load);
 	spin_unlock_bh(&bond->mode_lock);
 }
 
@@ -144,7 +144,7 @@ static int tlb_initialize(struct bonding *bond)
 	return 0;
 }
 
-/* Must be called only after all slaves have been released */
+/* Must be called only after all ports have been released */
 static void tlb_deinitialize(struct bonding *bond)
 {
 	struct alb_bond_info *bond_info = &(BOND_ALB_INFO(bond));
@@ -157,28 +157,28 @@ static void tlb_deinitialize(struct bonding *bond)
 	spin_unlock_bh(&bond->mode_lock);
 }
 
-static long long compute_gap(struct slave *slave)
+static long long compute_gap(struct bond_port *port)
 {
-	return (s64) (slave->speed << 20) - /* Convert to Megabit per sec */
-	       (s64) (SLAVE_TLB_INFO(slave).load << 3); /* Bytes to bits */
+	return (s64) (port->speed << 20) - /* Convert to Megabit per sec */
+	       (s64) (PORT_TLB_INFO(port).load << 3); /* Bytes to bits */
 }
 
-static struct slave *tlb_get_least_loaded_slave(struct bonding *bond)
+static struct bond_port *tlb_get_least_loaded_port(struct bonding *bond)
 {
-	struct slave *slave, *least_loaded;
+	struct bond_port *port, *least_loaded;
 	struct list_head *iter;
 	long long max_gap;
 
 	least_loaded = NULL;
 	max_gap = LLONG_MIN;
 
-	/* Find the slave with the largest gap */
-	bond_for_each_slave_rcu(bond, slave, iter) {
-		if (bond_slave_can_tx(slave)) {
-			long long gap = compute_gap(slave);
+	/* Find the port with the largest gap */
+	bond_for_each_port_rcu(bond, port, iter) {
+		if (bond_port_can_tx(port)) {
+			long long gap = compute_gap(port);
 
 			if (max_gap < gap) {
-				least_loaded = slave;
+				least_loaded = port;
 				max_gap = gap;
 			}
 		}
@@ -187,56 +187,56 @@ static struct slave *tlb_get_least_loaded_slave(struct bonding *bond)
 	return least_loaded;
 }
 
-static struct slave *__tlb_choose_channel(struct bonding *bond, u32 hash_index,
+static struct bond_port *__tlb_choose_channel(struct bonding *bond, u32 hash_index,
 						u32 skb_len)
 {
 	struct alb_bond_info *bond_info = &(BOND_ALB_INFO(bond));
 	struct tlb_client_info *hash_table;
-	struct slave *assigned_slave;
+	struct bond_port *assigned_port;
 
 	hash_table = bond_info->tx_hashtbl;
-	assigned_slave = hash_table[hash_index].tx_slave;
-	if (!assigned_slave) {
-		assigned_slave = tlb_get_least_loaded_slave(bond);
+	assigned_port = hash_table[hash_index].tx_port;
+	if (!assigned_port) {
+		assigned_port = tlb_get_least_loaded_port(bond);
 
-		if (assigned_slave) {
-			struct tlb_slave_info *slave_info =
-				&(SLAVE_TLB_INFO(assigned_slave));
-			u32 next_index = slave_info->head;
+		if (assigned_port) {
+			struct tlb_port_info *port_info =
+				&(PORT_TLB_INFO(assigned_port));
+			u32 next_index = port_info->head;
 
-			hash_table[hash_index].tx_slave = assigned_slave;
+			hash_table[hash_index].tx_port = assigned_port;
 			hash_table[hash_index].next = next_index;
 			hash_table[hash_index].prev = TLB_NULL_INDEX;
 
 			if (next_index != TLB_NULL_INDEX)
 				hash_table[next_index].prev = hash_index;
 
-			slave_info->head = hash_index;
-			slave_info->load +=
+			port_info->head = hash_index;
+			port_info->load +=
 				hash_table[hash_index].load_history;
 		}
 	}
 
-	if (assigned_slave)
+	if (assigned_port)
 		hash_table[hash_index].tx_bytes += skb_len;
 
-	return assigned_slave;
+	return assigned_port;
 }
 
-static struct slave *tlb_choose_channel(struct bonding *bond, u32 hash_index,
+static struct bond_port *tlb_choose_channel(struct bonding *bond, u32 hash_index,
 					u32 skb_len)
 {
-	struct slave *tx_slave;
+	struct bond_port *tx_port;
 
 	/* We don't need to disable softirq here, becase
 	 * tlb_choose_channel() is only called by bond_alb_xmit()
 	 * which already has softirq disabled.
 	 */
 	spin_lock(&bond->mode_lock);
-	tx_slave = __tlb_choose_channel(bond, hash_index, skb_len);
+	tx_port = __tlb_choose_channel(bond, hash_index, skb_len);
 	spin_unlock(&bond->mode_lock);
 
-	return tx_slave;
+	return tx_port;
 }
 
 /*********************** rlb specific functions ***************************/
@@ -269,7 +269,7 @@ static void rlb_update_entry_from_arp(struct bonding *bond, struct arp_pkt *arp)
 }
 
 static int rlb_arp_recv(const struct sk_buff *skb, struct bonding *bond,
-			struct slave *slave)
+			struct bond_port *port)
 {
 	struct arp_pkt *arp, _arp;
 
@@ -295,67 +295,67 @@ static int rlb_arp_recv(const struct sk_buff *skb, struct bonding *bond,
 	if (arp->op_code == htons(ARPOP_REPLY)) {
 		/* update rx hash table for this ARP */
 		rlb_update_entry_from_arp(bond, arp);
-		slave_dbg(bond->dev, slave->dev, "Server received an ARP Reply from client\n");
+		port_dbg(bond->dev, port->dev, "Server received an ARP Reply from client\n");
 	}
 out:
 	return RX_HANDLER_ANOTHER;
 }
 
 /* Caller must hold rcu_read_lock() */
-static struct slave *__rlb_next_rx_slave(struct bonding *bond)
+static struct bond_port *__rlb_next_rx_port(struct bonding *bond)
 {
 	struct alb_bond_info *bond_info = &(BOND_ALB_INFO(bond));
-	struct slave *before = NULL, *rx_slave = NULL, *slave;
+	struct bond_port *before = NULL, *rx_port = NULL, *port;
 	struct list_head *iter;
 	bool found = false;
 
-	bond_for_each_slave_rcu(bond, slave, iter) {
-		if (!bond_slave_can_tx(slave))
+	bond_for_each_port_rcu(bond, port, iter) {
+		if (!bond_port_can_tx(port))
 			continue;
 		if (!found) {
-			if (!before || before->speed < slave->speed)
-				before = slave;
+			if (!before || before->speed < port->speed)
+				before = port;
 		} else {
-			if (!rx_slave || rx_slave->speed < slave->speed)
-				rx_slave = slave;
+			if (!rx_port || rx_port->speed < port->speed)
+				rx_port = port;
 		}
-		if (slave == bond_info->rx_slave)
+		if (port == bond_info->rx_port)
 			found = true;
 	}
 	/* we didn't find anything after the current or we have something
-	 * better before and up to the current slave
+	 * better before and up to the current port
 	 */
-	if (!rx_slave || (before && rx_slave->speed < before->speed))
-		rx_slave = before;
+	if (!rx_port || (before && rx_port->speed < before->speed))
+		rx_port = before;
 
-	if (rx_slave)
-		bond_info->rx_slave = rx_slave;
+	if (rx_port)
+		bond_info->rx_port = rx_port;
 
-	return rx_slave;
+	return rx_port;
 }
 
 /* Caller must hold RTNL, rcu_read_lock is obtained only to silence checkers */
-static struct slave *rlb_next_rx_slave(struct bonding *bond)
+static struct bond_port *rlb_next_rx_port(struct bonding *bond)
 {
-	struct slave *rx_slave;
+	struct bond_port *rx_port;
 
 	ASSERT_RTNL();
 
 	rcu_read_lock();
-	rx_slave = __rlb_next_rx_slave(bond);
+	rx_port = __rlb_next_rx_port(bond);
 	rcu_read_unlock();
 
-	return rx_slave;
+	return rx_port;
 }
 
-/* teach the switch the mac of a disabled slave
+/* teach the switch the mac of a disabled port
  * on the primary for fault tolerance
  *
  * Caller must hold RTNL
  */
 static void rlb_teach_disabled_mac_on_primary(struct bonding *bond, u8 addr[])
 {
-	struct slave *curr_active = rtnl_dereference(bond->curr_active_slave);
+	struct bond_port *curr_active = rtnl_dereference(bond->curr_active_port);
 
 	if (!curr_active)
 		return;
@@ -372,32 +372,32 @@ static void rlb_teach_disabled_mac_on_primary(struct bonding *bond, u8 addr[])
 	alb_send_learning_packets(curr_active, addr, true);
 }
 
-/* slave being removed should not be active at this point
+/* port being removed should not be active at this point
  *
  * Caller must hold rtnl.
  */
-static void rlb_clear_slave(struct bonding *bond, struct slave *slave)
+static void rlb_clear_port(struct bonding *bond, struct bond_port *port)
 {
 	struct alb_bond_info *bond_info = &(BOND_ALB_INFO(bond));
 	struct rlb_client_info *rx_hash_table;
 	u32 index, next_index;
 
-	/* clear slave from rx_hashtbl */
+	/* clear port from rx_hashtbl */
 	spin_lock_bh(&bond->mode_lock);
 
 	rx_hash_table = bond_info->rx_hashtbl;
 	index = bond_info->rx_hashtbl_used_head;
 	for (; index != RLB_NULL_INDEX; index = next_index) {
 		next_index = rx_hash_table[index].used_next;
-		if (rx_hash_table[index].slave == slave) {
-			struct slave *assigned_slave = rlb_next_rx_slave(bond);
+		if (rx_hash_table[index].port == port) {
+			struct bond_port *assigned_port = rlb_next_rx_port(bond);
 
-			if (assigned_slave) {
-				rx_hash_table[index].slave = assigned_slave;
+			if (assigned_port) {
+				rx_hash_table[index].port = assigned_port;
 				if (is_valid_ether_addr(rx_hash_table[index].mac_dst)) {
 					bond_info->rx_hashtbl[index].ntt = 1;
 					bond_info->rx_ntt = 1;
-					/* A slave has been removed from the
+					/* A port has been removed from the
 					 * table because it is either disabled
 					 * or being released. We must retry the
 					 * update to avoid clients from not
@@ -407,23 +407,23 @@ static void rlb_clear_slave(struct bonding *bond, struct slave *slave)
 					bond_info->rlb_update_retry_counter =
 						RLB_UPDATE_RETRY;
 				}
-			} else {  /* there is no active slave */
-				rx_hash_table[index].slave = NULL;
+			} else {  /* there is no active port */
+				rx_hash_table[index].port = NULL;
 			}
 		}
 	}
 
 	spin_unlock_bh(&bond->mode_lock);
 
-	if (slave != rtnl_dereference(bond->curr_active_slave))
-		rlb_teach_disabled_mac_on_primary(bond, slave->dev->dev_addr);
+	if (port != rtnl_dereference(bond->curr_active_port))
+		rlb_teach_disabled_mac_on_primary(bond, port->dev->dev_addr);
 }
 
 static void rlb_update_client(struct rlb_client_info *client_info)
 {
 	int i;
 
-	if (!client_info->slave || !is_valid_ether_addr(client_info->mac_dst))
+	if (!client_info->port || !is_valid_ether_addr(client_info->mac_dst))
 		return;
 
 	for (i = 0; i < RLB_ARP_BURST_SIZE; i++) {
@@ -431,19 +431,19 @@ static void rlb_update_client(struct rlb_client_info *client_info)
 
 		skb = arp_create(ARPOP_REPLY, ETH_P_ARP,
 				 client_info->ip_dst,
-				 client_info->slave->dev,
+				 client_info->port->dev,
 				 client_info->ip_src,
 				 client_info->mac_dst,
-				 client_info->slave->dev->dev_addr,
+				 client_info->port->dev->dev_addr,
 				 client_info->mac_dst);
 		if (!skb) {
-			slave_err(client_info->slave->bond->dev,
-				  client_info->slave->dev,
-				  "failed to create an ARP packet\n");
+			port_err(client_info->port->bond->dev,
+				 client_info->port->dev,
+				 "failed to create an ARP packet\n");
 			continue;
 		}
 
-		skb->dev = client_info->slave->dev;
+		skb->dev = client_info->port->dev;
 
 		if (client_info->vlan_id) {
 			__vlan_hwaccel_put_tag(skb, htons(ETH_P_8021Q),
@@ -482,8 +482,8 @@ static void rlb_update_rx_clients(struct bonding *bond)
 	spin_unlock_bh(&bond->mode_lock);
 }
 
-/* The slave was assigned a new mac address - update the clients */
-static void rlb_req_update_slave_clients(struct bonding *bond, struct slave *slave)
+/* The port was assigned a new mac address - update the clients */
+static void rlb_req_update_port_clients(struct bonding *bond, struct bond_port *port)
 {
 	struct alb_bond_info *bond_info = &(BOND_ALB_INFO(bond));
 	struct rlb_client_info *client_info;
@@ -497,7 +497,7 @@ static void rlb_req_update_slave_clients(struct bonding *bond, struct slave *sla
 	     hash_index = client_info->used_next) {
 		client_info = &(bond_info->rx_hashtbl[hash_index]);
 
-		if ((client_info->slave == slave) &&
+		if ((client_info->port == port) &&
 		    is_valid_ether_addr(client_info->mac_dst)) {
 			client_info->ntt = 1;
 			ntt = 1;
@@ -528,16 +528,16 @@ static void rlb_req_update_subnet_clients(struct bonding *bond, __be32 src_ip)
 	     hash_index = client_info->used_next) {
 		client_info = &(bond_info->rx_hashtbl[hash_index]);
 
-		if (!client_info->slave) {
+		if (!client_info->port) {
 			netdev_err(bond->dev, "found a client with no channel in the client's hash table\n");
 			continue;
 		}
 		/* update all clients using this src_ip, that are not assigned
-		 * to the team's address (curr_active_slave) and have a known
+		 * to the team's address (curr_active_port) and have a known
 		 * unicast mac address.
 		 */
 		if ((client_info->ip_src == src_ip) &&
-		    !ether_addr_equal_64bits(client_info->slave->dev->dev_addr,
+		    !ether_addr_equal_64bits(client_info->port->dev->dev_addr,
 					     bond->dev->dev_addr) &&
 		    is_valid_ether_addr(client_info->mac_dst)) {
 			client_info->ntt = 1;
@@ -548,18 +548,18 @@ static void rlb_req_update_subnet_clients(struct bonding *bond, __be32 src_ip)
 	spin_unlock(&bond->mode_lock);
 }
 
-static struct slave *rlb_choose_channel(struct sk_buff *skb,
+static struct bond_port *rlb_choose_channel(struct sk_buff *skb,
 					struct bonding *bond,
 					const struct arp_pkt *arp)
 {
 	struct alb_bond_info *bond_info = &(BOND_ALB_INFO(bond));
-	struct slave *assigned_slave, *curr_active_slave;
+	struct bond_port *assigned_port, *curr_active_port;
 	struct rlb_client_info *client_info;
 	u32 hash_index = 0;
 
 	spin_lock(&bond->mode_lock);
 
-	curr_active_slave = rcu_dereference(bond->curr_active_slave);
+	curr_active_port = rcu_dereference(bond->curr_active_port);
 
 	hash_index = _simple_hash((u8 *)&arp->ip_dst, sizeof(arp->ip_dst));
 	client_info = &(bond_info->rx_hashtbl[hash_index]);
@@ -574,27 +574,27 @@ static struct slave *rlb_choose_channel(struct sk_buff *skb,
 			}
 			ether_addr_copy(client_info->mac_src, arp->mac_src);
 
-			assigned_slave = client_info->slave;
-			if (assigned_slave) {
+			assigned_port = client_info->port;
+			if (assigned_port) {
 				spin_unlock(&bond->mode_lock);
-				return assigned_slave;
+				return assigned_port;
 			}
 		} else {
 			/* the entry is already assigned to some other client,
-			 * move the old client to primary (curr_active_slave) so
+			 * move the old client to primary (curr_active_port) so
 			 * that the new client can be assigned to this entry.
 			 */
-			if (curr_active_slave &&
-			    client_info->slave != curr_active_slave) {
-				client_info->slave = curr_active_slave;
+			if (curr_active_port &&
+			    client_info->port != curr_active_port) {
+				client_info->port = curr_active_port;
 				rlb_update_client(client_info);
 			}
 		}
 	}
-	/* assign a new slave */
-	assigned_slave = __rlb_next_rx_slave(bond);
+	/* assign a new port */
+	assigned_port = __rlb_next_rx_port(bond);
 
-	if (assigned_slave) {
+	if (assigned_port) {
 		if (!(client_info->assigned &&
 		      client_info->ip_src == arp->ip_src)) {
 			/* ip_src is going to be updated,
@@ -614,7 +614,7 @@ static struct slave *rlb_choose_channel(struct sk_buff *skb,
 		 */
 		ether_addr_copy(client_info->mac_dst, arp->mac_dst);
 		ether_addr_copy(client_info->mac_src, arp->mac_src);
-		client_info->slave = assigned_slave;
+		client_info->port = assigned_port;
 
 		if (is_valid_ether_addr(client_info->mac_dst)) {
 			client_info->ntt = 1;
@@ -640,16 +640,16 @@ static struct slave *rlb_choose_channel(struct sk_buff *skb,
 
 	spin_unlock(&bond->mode_lock);
 
-	return assigned_slave;
+	return assigned_port;
 }
 
 /* chooses (and returns) transmit channel for arp reply
  * does not choose channel for other arp types since they are
- * sent on the curr_active_slave
+ * sent on the curr_active_port
  */
-static struct slave *rlb_arp_xmit(struct sk_buff *skb, struct bonding *bond)
+static struct bond_port *rlb_arp_xmit(struct sk_buff *skb, struct bonding *bond)
 {
-	struct slave *tx_slave = NULL;
+	struct bond_port *tx_port = NULL;
 	struct arp_pkt *arp;
 
 	if (!pskb_network_may_pull(skb, sizeof(*arp)))
@@ -659,24 +659,24 @@ static struct slave *rlb_arp_xmit(struct sk_buff *skb, struct bonding *bond)
 	/* Don't modify or load balance ARPs that do not originate locally
 	 * (e.g.,arrive via a bridge).
 	 */
-	if (!bond_slave_has_mac_rx(bond, arp->mac_src))
+	if (!bond_port_has_mac_rx(bond, arp->mac_src))
 		return NULL;
 
 	if (arp->op_code == htons(ARPOP_REPLY)) {
 		/* the arp must be sent on the selected rx channel */
-		tx_slave = rlb_choose_channel(skb, bond, arp);
-		if (tx_slave)
-			bond_hw_addr_copy(arp->mac_src, tx_slave->dev->dev_addr,
-					  tx_slave->dev->addr_len);
-		netdev_dbg(bond->dev, "(slave %s): Server sent ARP Reply packet\n",
-			   tx_slave ? tx_slave->dev->name : "NULL");
+		tx_port = rlb_choose_channel(skb, bond, arp);
+		if (tx_port)
+			bond_hw_addr_copy(arp->mac_src, tx_port->dev->dev_addr,
+					  tx_port->dev->addr_len);
+		netdev_dbg(bond->dev, "(port %s): Server sent ARP Reply packet\n",
+			   tx_port ? tx_port->dev->name : "NULL");
 	} else if (arp->op_code == htons(ARPOP_REQUEST)) {
 		/* Create an entry in the rx_hashtbl for this client as a
 		 * place holder.
 		 * When the arp reply is received the entry will be updated
 		 * with the correct unicast address of the client.
 		 */
-		tx_slave = rlb_choose_channel(skb, bond, arp);
+		tx_port = rlb_choose_channel(skb, bond, arp);
 
 		/* The ARP reply packets must be delayed so that
 		 * they can cancel out the influence of the ARP request.
@@ -685,21 +685,21 @@ static struct slave *rlb_arp_xmit(struct sk_buff *skb, struct bonding *bond)
 
 		/* arp requests are broadcast and are sent on the primary
 		 * the arp request will collapse all clients on the subnet to
-		 * the primary slave. We must register these clients to be
+		 * the primary port. We must register these clients to be
 		 * updated with their assigned mac.
 		 */
 		rlb_req_update_subnet_clients(bond, arp->ip_src);
-		netdev_dbg(bond->dev, "(slave %s): Server sent ARP Request packet\n",
-			   tx_slave ? tx_slave->dev->name : "NULL");
+		netdev_dbg(bond->dev, "(port %s): Server sent ARP Request packet\n",
+			   tx_port ? tx_port->dev->name : "NULL");
 	}
 
-	return tx_slave;
+	return tx_port;
 }
 
 static void rlb_rebalance(struct bonding *bond)
 {
 	struct alb_bond_info *bond_info = &(BOND_ALB_INFO(bond));
-	struct slave *assigned_slave;
+	struct bond_port *assigned_port;
 	struct rlb_client_info *client_info;
 	int ntt;
 	u32 hash_index;
@@ -711,9 +711,9 @@ static void rlb_rebalance(struct bonding *bond)
 	for (; hash_index != RLB_NULL_INDEX;
 	     hash_index = client_info->used_next) {
 		client_info = &(bond_info->rx_hashtbl[hash_index]);
-		assigned_slave = __rlb_next_rx_slave(bond);
-		if (assigned_slave && (client_info->slave != assigned_slave)) {
-			client_info->slave = assigned_slave;
+		assigned_port = __rlb_next_rx_port(bond);
+		if (assigned_port && (client_info->port != assigned_port)) {
+			client_info->port = assigned_port;
 			if (!is_zero_ether_addr(client_info->mac_dst)) {
 				client_info->ntt = 1;
 				ntt = 1;
@@ -733,7 +733,7 @@ static void rlb_init_table_entry_dst(struct rlb_client_info *entry)
 	entry->used_next = RLB_NULL_INDEX;
 	entry->used_prev = RLB_NULL_INDEX;
 	entry->assigned = 0;
-	entry->slave = NULL;
+	entry->port = NULL;
 	entry->vlan_id = 0;
 }
 static void rlb_init_table_entry_src(struct rlb_client_info *entry)
@@ -902,7 +902,7 @@ static void rlb_clear_vlan(struct bonding *bond, unsigned short vlan_id)
 
 /*********************** tlb/rlb shared functions *********************/
 
-static void alb_send_lp_vid(struct slave *slave, u8 mac_addr[],
+static void alb_send_lp_vid(struct bond_port *port, u8 mac_addr[],
 			    __be16 vlan_proto, u16 vid)
 {
 	struct learning_pkt pkt;
@@ -924,10 +924,10 @@ static void alb_send_lp_vid(struct slave *slave, u8 mac_addr[],
 	skb->network_header = skb->mac_header + ETH_HLEN;
 	skb->protocol = pkt.type;
 	skb->priority = TC_PRIO_CONTROL;
-	skb->dev = slave->dev;
+	skb->dev = port->dev;
 
-	slave_dbg(slave->bond->dev, slave->dev,
-		  "Send learning packet: mac %pM vlan %d\n", mac_addr, vid);
+	port_dbg(port->bond->dev, port->dev,
+		 "Send learning packet: mac %pM vlan %d\n", mac_addr, vid);
 
 	if (vid)
 		__vlan_hwaccel_put_tag(skb, vlan_proto, vid);
@@ -937,7 +937,7 @@ static void alb_send_lp_vid(struct slave *slave, u8 mac_addr[],
 
 struct alb_walk_data {
 	struct bonding *bond;
-	struct slave *slave;
+	struct bond_port *port;
 	u8 *mac_addr;
 	bool strict_match;
 };
@@ -947,18 +947,18 @@ static int alb_upper_dev_walk(struct net_device *upper, void *_data)
 	struct alb_walk_data *data = _data;
 	bool strict_match = data->strict_match;
 	struct bonding *bond = data->bond;
-	struct slave *slave = data->slave;
+	struct bond_port *port = data->port;
 	u8 *mac_addr = data->mac_addr;
 	struct bond_vlan_tag *tags;
 
 	if (is_vlan_dev(upper) &&
 	    bond->dev->lower_level == upper->lower_level - 1) {
 		if (upper->addr_assign_type == NET_ADDR_STOLEN) {
-			alb_send_lp_vid(slave, mac_addr,
+			alb_send_lp_vid(port, mac_addr,
 					vlan_dev_vlan_proto(upper),
 					vlan_dev_vlan_id(upper));
 		} else {
-			alb_send_lp_vid(slave, upper->dev_addr,
+			alb_send_lp_vid(port, upper->dev_addr,
 					vlan_dev_vlan_proto(upper),
 					vlan_dev_vlan_id(upper));
 		}
@@ -971,7 +971,7 @@ static int alb_upper_dev_walk(struct net_device *upper, void *_data)
 		tags = bond_verify_device_path(bond->dev, upper, 0);
 		if (IS_ERR_OR_NULL(tags))
 			BUG();
-		alb_send_lp_vid(slave, upper->dev_addr,
+		alb_send_lp_vid(port, upper->dev_addr,
 				tags[0].vlan_proto, tags[0].vlan_id);
 		kfree(tags);
 	}
@@ -979,19 +979,19 @@ static int alb_upper_dev_walk(struct net_device *upper, void *_data)
 	return 0;
 }
 
-static void alb_send_learning_packets(struct slave *slave, u8 mac_addr[],
+static void alb_send_learning_packets(struct bond_port *port, u8 mac_addr[],
 				      bool strict_match)
 {
-	struct bonding *bond = bond_get_bond_by_slave(slave);
+	struct bonding *bond = bond_get_bond_by_port(port);
 	struct alb_walk_data data = {
 		.strict_match = strict_match,
 		.mac_addr = mac_addr,
-		.slave = slave,
+		.port = port,
 		.bond = bond,
 	};
 
 	/* send untagged */
-	alb_send_lp_vid(slave, mac_addr, 0, 0);
+	alb_send_lp_vid(port, mac_addr, 0, 0);
 
 	/* loop through all devices and see if we need to send a packet
 	 * for that device.
@@ -1001,43 +1001,43 @@ static void alb_send_learning_packets(struct slave *slave, u8 mac_addr[],
 	rcu_read_unlock();
 }
 
-static int alb_set_slave_mac_addr(struct slave *slave, u8 addr[],
+static int alb_set_port_mac_addr(struct bond_port *port, u8 addr[],
 				  unsigned int len)
 {
-	struct net_device *dev = slave->dev;
+	struct net_device *dev = port->dev;
 	struct sockaddr_storage ss;
 
-	if (BOND_MODE(slave->bond) == BOND_MODE_TLB) {
+	if (BOND_MODE(port->bond) == BOND_MODE_TLB) {
 		memcpy(dev->dev_addr, addr, len);
 		return 0;
 	}
 
-	/* for rlb each slave must have a unique hw mac addresses so that
-	 * each slave will receive packets destined to a different mac
+	/* for rlb each port must have a unique hw mac addresses so that
+	 * each port will receive packets destined to a different mac
 	 */
 	memcpy(ss.__data, addr, len);
 	ss.ss_family = dev->type;
 	if (dev_set_mac_address(dev, (struct sockaddr *)&ss, NULL)) {
-		slave_err(slave->bond->dev, dev, "dev_set_mac_address on slave failed! ALB mode requires that the base driver support setting the hw address also when the network device's interface is open\n");
+		port_err(port->bond->dev, dev, "dev_set_mac_address on port failed! ALB mode requires that the base driver support setting the hw address also when the network device's interface is open\n");
 		return -EOPNOTSUPP;
 	}
 	return 0;
 }
 
-/* Swap MAC addresses between two slaves.
+/* Swap MAC addresses between two ports.
  *
  * Called with RTNL held, and no other locks.
  */
-static void alb_swap_mac_addr(struct slave *slave1, struct slave *slave2)
+static void alb_swap_mac_addr(struct bond_port *port1, struct bond_port *port2)
 {
 	u8 tmp_mac_addr[MAX_ADDR_LEN];
 
-	bond_hw_addr_copy(tmp_mac_addr, slave1->dev->dev_addr,
-			  slave1->dev->addr_len);
-	alb_set_slave_mac_addr(slave1, slave2->dev->dev_addr,
-			       slave2->dev->addr_len);
-	alb_set_slave_mac_addr(slave2, tmp_mac_addr,
-			       slave1->dev->addr_len);
+	bond_hw_addr_copy(tmp_mac_addr, port1->dev->dev_addr,
+			  port1->dev->addr_len);
+	alb_set_port_mac_addr(port1, port2->dev->dev_addr,
+			       port2->dev->addr_len);
+	alb_set_port_mac_addr(port2, tmp_mac_addr,
+			       port1->dev->addr_len);
 
 }
 
@@ -1045,77 +1045,77 @@ static void alb_swap_mac_addr(struct slave *slave1, struct slave *slave2)
  *
  * Called with RTNL and no other locks
  */
-static void alb_fasten_mac_swap(struct bonding *bond, struct slave *slave1,
-				struct slave *slave2)
+static void alb_fasten_mac_swap(struct bonding *bond, struct bond_port *port1,
+				struct bond_port *port2)
 {
-	int slaves_state_differ = (bond_slave_can_tx(slave1) != bond_slave_can_tx(slave2));
-	struct slave *disabled_slave = NULL;
+	int ports_state_differ = (bond_port_can_tx(port1) != bond_port_can_tx(port2));
+	struct bond_port *disabled_port = NULL;
 
 	ASSERT_RTNL();
 
 	/* fasten the change in the switch */
-	if (bond_slave_can_tx(slave1)) {
-		alb_send_learning_packets(slave1, slave1->dev->dev_addr, false);
+	if (bond_port_can_tx(port1)) {
+		alb_send_learning_packets(port1, port1->dev->dev_addr, false);
 		if (bond->alb_info.rlb_enabled) {
 			/* inform the clients that the mac address
 			 * has changed
 			 */
-			rlb_req_update_slave_clients(bond, slave1);
+			rlb_req_update_port_clients(bond, port1);
 		}
 	} else {
-		disabled_slave = slave1;
+		disabled_port = port1;
 	}
 
-	if (bond_slave_can_tx(slave2)) {
-		alb_send_learning_packets(slave2, slave2->dev->dev_addr, false);
+	if (bond_port_can_tx(port2)) {
+		alb_send_learning_packets(port2, port2->dev->dev_addr, false);
 		if (bond->alb_info.rlb_enabled) {
 			/* inform the clients that the mac address
 			 * has changed
 			 */
-			rlb_req_update_slave_clients(bond, slave2);
+			rlb_req_update_port_clients(bond, port2);
 		}
 	} else {
-		disabled_slave = slave2;
+		disabled_port = port2;
 	}
 
-	if (bond->alb_info.rlb_enabled && slaves_state_differ) {
-		/* A disabled slave was assigned an active mac addr */
+	if (bond->alb_info.rlb_enabled && ports_state_differ) {
+		/* A disabled port was assigned an active mac addr */
 		rlb_teach_disabled_mac_on_primary(bond,
-						  disabled_slave->dev->dev_addr);
+						  disabled_port->dev->dev_addr);
 	}
 }
 
 /**
  * alb_change_hw_addr_on_detach
  * @bond: bonding we're working on
- * @slave: the slave that was just detached
+ * @port: the port that was just detached
  *
- * We assume that @slave was already detached from the slave list.
+ * We assume that @port was already detached from the port list.
  *
- * If @slave's permanent hw address is different both from its current
+ * If @port's permanent hw address is different both from its current
  * address and from @bond's address, then somewhere in the bond there's
- * a slave that has @slave's permanet address as its current address.
- * We'll make sure that that slave no longer uses @slave's permanent address.
+ * a port that has @port's permanet address as its current address.
+ * We'll make sure that that port no longer uses @port's permanent address.
  *
  * Caller must hold RTNL and no other locks
  */
-static void alb_change_hw_addr_on_detach(struct bonding *bond, struct slave *slave)
+static void alb_change_hw_addr_on_detach(struct bonding *bond, struct bond_port *port)
 {
 	int perm_curr_diff;
 	int perm_bond_diff;
-	struct slave *found_slave;
+	struct bond_port *found_port;
 
-	perm_curr_diff = !ether_addr_equal_64bits(slave->perm_hwaddr,
-						  slave->dev->dev_addr);
-	perm_bond_diff = !ether_addr_equal_64bits(slave->perm_hwaddr,
+	perm_curr_diff = !ether_addr_equal_64bits(port->perm_hwaddr,
+						  port->dev->dev_addr);
+	perm_bond_diff = !ether_addr_equal_64bits(port->perm_hwaddr,
 						  bond->dev->dev_addr);
 
 	if (perm_curr_diff && perm_bond_diff) {
-		found_slave = bond_slave_has_mac(bond, slave->perm_hwaddr);
+		found_port = bond_port_has_mac(bond, port->perm_hwaddr);
 
-		if (found_slave) {
-			alb_swap_mac_addr(slave, found_slave);
-			alb_fasten_mac_swap(bond, slave, found_slave);
+		if (found_port) {
+			alb_swap_mac_addr(port, found_port);
+			alb_fasten_mac_swap(bond, port, found_port);
 		}
 	}
 }
@@ -1123,81 +1123,81 @@ static void alb_change_hw_addr_on_detach(struct bonding *bond, struct slave *sla
 /**
  * alb_handle_addr_collision_on_attach
  * @bond: bonding we're working on
- * @slave: the slave that was just attached
+ * @port: the port that was just attached
  *
- * checks uniqueness of slave's mac address and handles the case the
- * new slave uses the bonds mac address.
+ * checks uniqueness of port's mac address and handles the case the
+ * new port uses the bonds mac address.
  *
- * If the permanent hw address of @slave is @bond's hw address, we need to
- * find a different hw address to give @slave, that isn't in use by any other
- * slave in the bond. This address must be, of course, one of the permanent
- * addresses of the other slaves.
+ * If the permanent hw address of @port is @bond's hw address, we need to
+ * find a different hw address to give @port, that isn't in use by any other
+ * port in the bond. This address must be, of course, one of the permanent
+ * addresses of the other ports.
  *
- * We go over the slave list, and for each slave there we compare its
- * permanent hw address with the current address of all the other slaves.
- * If no match was found, then we've found a slave with a permanent address
- * that isn't used by any other slave in the bond, so we can assign it to
- * @slave.
+ * We go over the port list, and for each port there we compare its
+ * permanent hw address with the current address of all the other ports.
+ * If no match was found, then we've found a port with a permanent address
+ * that isn't used by any other port in the bond, so we can assign it to
+ * @port.
  *
- * assumption: this function is called before @slave is attached to the
- *	       bond slave list.
+ * assumption: this function is called before @port is attached to the
+ *	       bond port list.
  */
-static int alb_handle_addr_collision_on_attach(struct bonding *bond, struct slave *slave)
+static int alb_handle_addr_collision_on_attach(struct bonding *bond, struct bond_port *port)
 {
-	struct slave *has_bond_addr = rcu_access_pointer(bond->curr_active_slave);
-	struct slave *tmp_slave1, *free_mac_slave = NULL;
+	struct bond_port *has_bond_addr = rcu_access_pointer(bond->curr_active_port);
+	struct bond_port *tmp_port1, *free_mac_port = NULL;
 	struct list_head *iter;
 
-	if (!bond_has_slaves(bond)) {
-		/* this is the first slave */
+	if (!bond_has_ports(bond)) {
+		/* this is the first port */
 		return 0;
 	}
 
-	/* if slave's mac address differs from bond's mac address
-	 * check uniqueness of slave's mac address against the other
-	 * slaves in the bond.
+	/* if port's mac address differs from bond's mac address
+	 * check uniqueness of port's mac address against the other
+	 * ports in the bond.
 	 */
-	if (!ether_addr_equal_64bits(slave->perm_hwaddr, bond->dev->dev_addr)) {
-		if (!bond_slave_has_mac(bond, slave->dev->dev_addr))
+	if (!ether_addr_equal_64bits(port->perm_hwaddr, bond->dev->dev_addr)) {
+		if (!bond_port_has_mac(bond, port->dev->dev_addr))
 			return 0;
 
-		/* Try setting slave mac to bond address and fall-through
+		/* Try setting port mac to bond address and fall-through
 		 * to code handling that situation below...
 		 */
-		alb_set_slave_mac_addr(slave, bond->dev->dev_addr,
+		alb_set_port_mac_addr(port, bond->dev->dev_addr,
 				       bond->dev->addr_len);
 	}
 
-	/* The slave's address is equal to the address of the bond.
-	 * Search for a spare address in the bond for this slave.
+	/* The port's address is equal to the address of the bond.
+	 * Search for a spare address in the bond for this port.
 	 */
-	bond_for_each_slave(bond, tmp_slave1, iter) {
-		if (!bond_slave_has_mac(bond, tmp_slave1->perm_hwaddr)) {
-			/* no slave has tmp_slave1's perm addr
+	bond_for_each_port(bond, tmp_port1, iter) {
+		if (!bond_port_has_mac(bond, tmp_port1->perm_hwaddr)) {
+			/* no port has tmp_port1's perm addr
 			 * as its curr addr
 			 */
-			free_mac_slave = tmp_slave1;
+			free_mac_port = tmp_port1;
 			break;
 		}
 
 		if (!has_bond_addr) {
-			if (ether_addr_equal_64bits(tmp_slave1->dev->dev_addr,
+			if (ether_addr_equal_64bits(tmp_port1->dev->dev_addr,
 						    bond->dev->dev_addr)) {
 
-				has_bond_addr = tmp_slave1;
+				has_bond_addr = tmp_port1;
 			}
 		}
 	}
 
-	if (free_mac_slave) {
-		alb_set_slave_mac_addr(slave, free_mac_slave->perm_hwaddr,
-				       free_mac_slave->dev->addr_len);
+	if (free_mac_port) {
+		alb_set_port_mac_addr(port, free_mac_port->perm_hwaddr,
+				       free_mac_port->dev->addr_len);
 
-		slave_warn(bond->dev, slave->dev, "the slave hw address is in use by the bond; giving it the hw address of %s\n",
-			   free_mac_slave->dev->name);
+		port_warn(bond->dev, port->dev, "the port hw address is in use by the bond; giving it the hw address of %s\n",
+			  free_mac_port->dev->name);
 
 	} else if (has_bond_addr) {
-		slave_err(bond->dev, slave->dev, "the slave hw address is in use by the bond; couldn't find a slave with a free hw address to give it (this should not have happened)\n");
+		port_err(bond->dev, port->dev, "the port hw address is in use by the bond; couldn't find a port with a free hw address to give it (this should not have happened)\n");
 		return -EFAULT;
 	}
 
@@ -1209,18 +1209,18 @@ static int alb_handle_addr_collision_on_attach(struct bonding *bond, struct slav
  * @bond: bonding we're working on
  * @addr: MAC address to set
  *
- * In TLB mode all slaves are configured to the bond's hw address, but set
+ * In TLB mode all ports are configured to the bond's hw address, but set
  * their dev_addr field to different addresses (based on their permanent hw
  * addresses).
  *
- * For each slave, this function sets the interface to the new address and then
+ * For each port, this function sets the interface to the new address and then
  * changes its dev_addr field to its previous value.
  *
  * Unwinding assumes bond's mac address has not yet changed.
  */
 static int alb_set_mac_address(struct bonding *bond, void *addr)
 {
-	struct slave *slave, *rollback_slave;
+	struct bond_port *port, *rollback_port;
 	struct list_head *iter;
 	struct sockaddr_storage ss;
 	char tmp_addr[MAX_ADDR_LEN];
@@ -1229,16 +1229,16 @@ static int alb_set_mac_address(struct bonding *bond, void *addr)
 	if (bond->alb_info.rlb_enabled)
 		return 0;
 
-	bond_for_each_slave(bond, slave, iter) {
+	bond_for_each_port(bond, port, iter) {
 		/* save net_device's current hw address */
-		bond_hw_addr_copy(tmp_addr, slave->dev->dev_addr,
-				  slave->dev->addr_len);
+		bond_hw_addr_copy(tmp_addr, port->dev->dev_addr,
+				  port->dev->addr_len);
 
-		res = dev_set_mac_address(slave->dev, addr, NULL);
+		res = dev_set_mac_address(port->dev, addr, NULL);
 
 		/* restore net_device's hw address */
-		bond_hw_addr_copy(slave->dev->dev_addr, tmp_addr,
-				  slave->dev->addr_len);
+		bond_hw_addr_copy(port->dev->dev_addr, tmp_addr,
+				  port->dev->addr_len);
 
 		if (res)
 			goto unwind;
@@ -1250,16 +1250,16 @@ static int alb_set_mac_address(struct bonding *bond, void *addr)
 	memcpy(ss.__data, bond->dev->dev_addr, bond->dev->addr_len);
 	ss.ss_family = bond->dev->type;
 
-	/* unwind from head to the slave that failed */
-	bond_for_each_slave(bond, rollback_slave, iter) {
-		if (rollback_slave == slave)
+	/* unwind from head to the port that failed */
+	bond_for_each_port(bond, rollback_port, iter) {
+		if (rollback_port == port)
 			break;
-		bond_hw_addr_copy(tmp_addr, rollback_slave->dev->dev_addr,
-				  rollback_slave->dev->addr_len);
-		dev_set_mac_address(rollback_slave->dev,
+		bond_hw_addr_copy(tmp_addr, rollback_port->dev->dev_addr,
+				  rollback_port->dev->addr_len);
+		dev_set_mac_address(rollback_port->dev,
 				    (struct sockaddr *)&ss, NULL);
-		bond_hw_addr_copy(rollback_slave->dev->dev_addr, tmp_addr,
-				  rollback_slave->dev->addr_len);
+		bond_hw_addr_copy(rollback_port->dev->dev_addr, tmp_addr,
+				  rollback_port->dev->addr_len);
 	}
 
 	return res;
@@ -1300,30 +1300,30 @@ void bond_alb_deinitialize(struct bonding *bond)
 }
 
 static netdev_tx_t bond_do_alb_xmit(struct sk_buff *skb, struct bonding *bond,
-				    struct slave *tx_slave)
+				    struct bond_port *tx_port)
 {
 	struct alb_bond_info *bond_info = &(BOND_ALB_INFO(bond));
 	struct ethhdr *eth_data = eth_hdr(skb);
 
-	if (!tx_slave) {
+	if (!tx_port) {
 		/* unbalanced or unassigned, send through primary */
-		tx_slave = rcu_dereference(bond->curr_active_slave);
+		tx_port = rcu_dereference(bond->curr_active_port);
 		if (bond->params.tlb_dynamic_lb)
 			bond_info->unbalanced_load += skb->len;
 	}
 
-	if (tx_slave && bond_slave_can_tx(tx_slave)) {
-		if (tx_slave != rcu_access_pointer(bond->curr_active_slave)) {
+	if (tx_port && bond_port_can_tx(tx_port)) {
+		if (tx_port != rcu_access_pointer(bond->curr_active_port)) {
 			ether_addr_copy(eth_data->h_source,
-					tx_slave->dev->dev_addr);
+					tx_port->dev->dev_addr);
 		}
 
-		return bond_dev_queue_xmit(bond, skb, tx_slave->dev);
+		return bond_dev_queue_xmit(bond, skb, tx_port->dev);
 	}
 
-	if (tx_slave && bond->params.tlb_dynamic_lb) {
+	if (tx_port && bond->params.tlb_dynamic_lb) {
 		spin_lock(&bond->mode_lock);
-		__tlb_clear_slave(bond, tx_slave, 0);
+		__tlb_clear_port(bond, tx_port, 0);
 		spin_unlock(&bond->mode_lock);
 	}
 
@@ -1331,10 +1331,10 @@ static netdev_tx_t bond_do_alb_xmit(struct sk_buff *skb, struct bonding *bond,
 	return bond_tx_drop(bond->dev, skb);
 }
 
-struct slave *bond_xmit_tlb_slave_get(struct bonding *bond,
-				      struct sk_buff *skb)
+struct bond_port *bond_xmit_tlb_port_get(struct bonding *bond,
+					 struct sk_buff *skb)
 {
-	struct slave *tx_slave = NULL;
+	struct bond_port *tx_port = NULL;
 	struct ethhdr *eth_data;
 	u32 hash_index;
 
@@ -1350,40 +1350,40 @@ struct slave *bond_xmit_tlb_slave_get(struct bonding *bond,
 		case htons(ETH_P_IPV6):
 			hash_index = bond_xmit_hash(bond, skb);
 			if (bond->params.tlb_dynamic_lb) {
-				tx_slave = tlb_choose_channel(bond,
+				tx_port = tlb_choose_channel(bond,
 							      hash_index & 0xFF,
 							      skb->len);
 			} else {
-				struct bond_up_slave *slaves;
+				struct bond_up_port *ports;
 				unsigned int count;
 
-				slaves = rcu_dereference(bond->usable_slaves);
-				count = slaves ? READ_ONCE(slaves->count) : 0;
+				ports = rcu_dereference(bond->usable_ports);
+				count = ports ? READ_ONCE(ports->count) : 0;
 				if (likely(count))
-					tx_slave = slaves->arr[hash_index %
+					tx_port = ports->arr[hash_index %
 							       count];
 			}
 			break;
 		}
 	}
-	return tx_slave;
+	return tx_port;
 }
 
 netdev_tx_t bond_tlb_xmit(struct sk_buff *skb, struct net_device *bond_dev)
 {
 	struct bonding *bond = netdev_priv(bond_dev);
-	struct slave *tx_slave;
+	struct bond_port *tx_port;
 
-	tx_slave = bond_xmit_tlb_slave_get(bond, skb);
-	return bond_do_alb_xmit(skb, bond, tx_slave);
+	tx_port = bond_xmit_tlb_port_get(bond, skb);
+	return bond_do_alb_xmit(skb, bond, tx_port);
 }
 
-struct slave *bond_xmit_alb_slave_get(struct bonding *bond,
+struct bond_port *bond_xmit_alb_port_get(struct bonding *bond,
 				      struct sk_buff *skb)
 {
 	struct alb_bond_info *bond_info = &(BOND_ALB_INFO(bond));
 	static const __be32 ip_bcast = htonl(0xffffffff);
-	struct slave *tx_slave = NULL;
+	struct bond_port *tx_port = NULL;
 	const u8 *hash_start = NULL;
 	bool do_tx_balance = true;
 	struct ethhdr *eth_data;
@@ -1480,7 +1480,7 @@ struct slave *bond_xmit_alb_slave_get(struct bonding *bond,
 	case ETH_P_ARP:
 		do_tx_balance = false;
 		if (bond_info->rlb_enabled)
-			tx_slave = rlb_arp_xmit(skb, bond);
+			tx_port = rlb_arp_xmit(skb, bond);
 		break;
 	default:
 		do_tx_balance = false;
@@ -1490,33 +1490,33 @@ struct slave *bond_xmit_alb_slave_get(struct bonding *bond,
 	if (do_tx_balance) {
 		if (bond->params.tlb_dynamic_lb) {
 			hash_index = _simple_hash(hash_start, hash_size);
-			tx_slave = tlb_choose_channel(bond, hash_index, skb->len);
+			tx_port = tlb_choose_channel(bond, hash_index, skb->len);
 		} else {
 			/*
-			 * do_tx_balance means we are free to select the tx_slave
+			 * do_tx_balance means we are free to select the tx_port
 			 * So we do exactly what tlb would do for hash selection
 			 */
 
-			struct bond_up_slave *slaves;
+			struct bond_up_port *ports;
 			unsigned int count;
 
-			slaves = rcu_dereference(bond->usable_slaves);
-			count = slaves ? READ_ONCE(slaves->count) : 0;
+			ports = rcu_dereference(bond->usable_ports);
+			count = ports ? READ_ONCE(ports->count) : 0;
 			if (likely(count))
-				tx_slave = slaves->arr[bond_xmit_hash(bond, skb) %
+				tx_port = ports->arr[bond_xmit_hash(bond, skb) %
 						       count];
 		}
 	}
-	return tx_slave;
+	return tx_port;
 }
 
 netdev_tx_t bond_alb_xmit(struct sk_buff *skb, struct net_device *bond_dev)
 {
 	struct bonding *bond = netdev_priv(bond_dev);
-	struct slave *tx_slave = NULL;
+	struct bond_port *tx_port = NULL;
 
-	tx_slave = bond_xmit_alb_slave_get(bond, skb);
-	return bond_do_alb_xmit(skb, bond, tx_slave);
+	tx_port = bond_xmit_alb_port_get(bond, skb);
+	return bond_do_alb_xmit(skb, bond, tx_port);
 }
 
 void bond_alb_monitor(struct work_struct *work)
@@ -1525,9 +1525,9 @@ void bond_alb_monitor(struct work_struct *work)
 					    alb_work.work);
 	struct alb_bond_info *bond_info = &(BOND_ALB_INFO(bond));
 	struct list_head *iter;
-	struct slave *slave;
+	struct bond_port *port;
 
-	if (!bond_has_slaves(bond)) {
+	if (!bond_has_ports(bond)) {
 		bond_info->tx_rebalance_counter = 0;
 		bond_info->lp_counter = 0;
 		goto re_arm;
@@ -1542,15 +1542,15 @@ void bond_alb_monitor(struct work_struct *work)
 	if (bond_info->lp_counter >= BOND_ALB_LP_TICKS(bond)) {
 		bool strict_match;
 
-		bond_for_each_slave_rcu(bond, slave, iter) {
+		bond_for_each_port_rcu(bond, port, iter) {
 			/* If updating current_active, use all currently
 			 * user mac addreses (!strict_match).  Otherwise, only
-			 * use mac of the slave device.
+			 * use mac of the port device.
 			 * In RLB mode, we always use strict matches.
 			 */
-			strict_match = (slave != rcu_access_pointer(bond->curr_active_slave) ||
+			strict_match = (port != rcu_access_pointer(bond->curr_active_port) ||
 					bond_info->rlb_enabled);
-			alb_send_learning_packets(slave, slave->dev->dev_addr,
+			alb_send_learning_packets(port, port->dev->dev_addr,
 						  strict_match);
 		}
 		bond_info->lp_counter = 0;
@@ -1558,10 +1558,10 @@ void bond_alb_monitor(struct work_struct *work)
 
 	/* rebalance tx traffic */
 	if (bond_info->tx_rebalance_counter >= BOND_TLB_REBALANCE_TICKS) {
-		bond_for_each_slave_rcu(bond, slave, iter) {
-			tlb_clear_slave(bond, slave, 1);
-			if (slave == rcu_access_pointer(bond->curr_active_slave)) {
-				SLAVE_TLB_INFO(slave).load =
+		bond_for_each_port_rcu(bond, port, iter) {
+			tlb_clear_port(bond, port, 1);
+			if (port == rcu_access_pointer(bond->curr_active_port)) {
+				PORT_TLB_INFO(port).load =
 					bond_info->unbalanced_load /
 						BOND_TLB_REBALANCE_INTERVAL;
 				bond_info->unbalanced_load = 0;
@@ -1584,10 +1584,10 @@ void bond_alb_monitor(struct work_struct *work)
 			bond_info->rlb_promisc_timeout_counter = 0;
 
 			/* If the primary was set to promiscuous mode
-			 * because a slave was disabled then
+			 * because a port was disabled then
 			 * it can now leave promiscuous mode.
 			 */
-			dev_set_promiscuity(rtnl_dereference(bond->curr_active_slave)->dev,
+			dev_set_promiscuity(rtnl_dereference(bond->curr_active_port)->dev,
 					    -1);
 			bond_info->primary_is_promisc = 0;
 
@@ -1618,23 +1618,23 @@ void bond_alb_monitor(struct work_struct *work)
 	queue_delayed_work(bond->wq, &bond->alb_work, alb_delta_in_ticks);
 }
 
-/* assumption: called before the slave is attached to the bond
+/* assumption: called before the port is attached to the bond
  * and not locked by the bond lock
  */
-int bond_alb_init_slave(struct bonding *bond, struct slave *slave)
+int bond_alb_init_port(struct bonding *bond, struct bond_port *port)
 {
 	int res;
 
-	res = alb_set_slave_mac_addr(slave, slave->perm_hwaddr,
-				     slave->dev->addr_len);
+	res = alb_set_port_mac_addr(port, port->perm_hwaddr,
+				     port->dev->addr_len);
 	if (res)
 		return res;
 
-	res = alb_handle_addr_collision_on_attach(bond, slave);
+	res = alb_handle_addr_collision_on_attach(bond, port);
 	if (res)
 		return res;
 
-	tlb_init_slave(slave);
+	tlb_init_port(port);
 
 	/* order a rebalance ASAP */
 	bond->alb_info.tx_rebalance_counter = BOND_TLB_REBALANCE_TICKS;
@@ -1645,33 +1645,34 @@ int bond_alb_init_slave(struct bonding *bond, struct slave *slave)
 	return 0;
 }
 
-/* Remove slave from tlb and rlb hash tables, and fix up MAC addresses
+/* Remove port from tlb and rlb hash tables, and fix up MAC addresses
  * if necessary.
  *
  * Caller must hold RTNL and no other locks
  */
-void bond_alb_deinit_slave(struct bonding *bond, struct slave *slave)
+void bond_alb_deinit_port(struct bonding *bond, struct bond_port *port)
 {
-	if (bond_has_slaves(bond))
-		alb_change_hw_addr_on_detach(bond, slave);
+	if (bond_has_ports(bond))
+		alb_change_hw_addr_on_detach(bond, port);
 
-	tlb_clear_slave(bond, slave, 0);
+	tlb_clear_port(bond, port, 0);
 
 	if (bond->alb_info.rlb_enabled) {
-		bond->alb_info.rx_slave = NULL;
-		rlb_clear_slave(bond, slave);
+		bond->alb_info.rx_port = NULL;
+		rlb_clear_port(bond, port);
 	}
 
 }
 
-void bond_alb_handle_link_change(struct bonding *bond, struct slave *slave, char link)
+void bond_alb_handle_link_change(struct bonding *bond, struct bond_port *port,
+				 char link)
 {
 	struct alb_bond_info *bond_info = &(BOND_ALB_INFO(bond));
 
 	if (link == BOND_LINK_DOWN) {
-		tlb_clear_slave(bond, slave, 0);
+		tlb_clear_port(bond, port, 0);
 		if (bond->alb_info.rlb_enabled)
-			rlb_clear_slave(bond, slave);
+			rlb_clear_port(bond, port);
 	} else if (link == BOND_LINK_UP) {
 		/* order a rebalance ASAP */
 		bond_info->tx_rebalance_counter = BOND_TLB_REBALANCE_TICKS;
@@ -1686,28 +1687,28 @@ void bond_alb_handle_link_change(struct bonding *bond, struct slave *slave, char
 	}
 
 	if (bond_is_nondyn_tlb(bond)) {
-		if (bond_update_slave_arr(bond, NULL))
-			pr_err("Failed to build slave-array for TLB mode.\n");
+		if (bond_update_port_arr(bond, NULL))
+			pr_err("Failed to build port-array for TLB mode.\n");
 	}
 }
 
 /**
- * bond_alb_handle_active_change - assign new curr_active_slave
+ * bond_alb_handle_active_change - assign new curr_active_port
  * @bond: our bonding struct
- * @new_slave: new slave to assign
+ * @new_port: new port to assign
  *
- * Set the bond->curr_active_slave to @new_slave and handle
+ * Set the bond->curr_active_port to @new_port and handle
  * mac address swapping and promiscuity changes as needed.
  *
  * Caller must hold RTNL
  */
-void bond_alb_handle_active_change(struct bonding *bond, struct slave *new_slave)
+void bond_alb_handle_active_change(struct bonding *bond, struct bond_port *new_port)
 {
-	struct slave *swap_slave;
-	struct slave *curr_active;
+	struct bond_port *swap_port;
+	struct bond_port *curr_active;
 
-	curr_active = rtnl_dereference(bond->curr_active_slave);
-	if (curr_active == new_slave)
+	curr_active = rtnl_dereference(bond->curr_active_port);
+	if (curr_active == new_port)
 		return;
 
 	if (curr_active && bond->alb_info.primary_is_promisc) {
@@ -1716,57 +1717,57 @@ void bond_alb_handle_active_change(struct bonding *bond, struct slave *new_slave
 		bond->alb_info.rlb_promisc_timeout_counter = 0;
 	}
 
-	swap_slave = curr_active;
-	rcu_assign_pointer(bond->curr_active_slave, new_slave);
+	swap_port = curr_active;
+	rcu_assign_pointer(bond->curr_active_port, new_port);
 
-	if (!new_slave || !bond_has_slaves(bond))
+	if (!new_port || !bond_has_ports(bond))
 		return;
 
-	/* set the new curr_active_slave to the bonds mac address
-	 * i.e. swap mac addresses of old curr_active_slave and new curr_active_slave
+	/* set the new curr_active_port to the bonds mac address
+	 * i.e. swap mac addresses of old curr_active_port and new curr_active_port
 	 */
-	if (!swap_slave)
-		swap_slave = bond_slave_has_mac(bond, bond->dev->dev_addr);
+	if (!swap_port)
+		swap_port = bond_port_has_mac(bond, bond->dev->dev_addr);
 
-	/* Arrange for swap_slave and new_slave to temporarily be
+	/* Arrange for swap_port and new_port to temporarily be
 	 * ignored so we can mess with their MAC addresses without
 	 * fear of interference from transmit activity.
 	 */
-	if (swap_slave)
-		tlb_clear_slave(bond, swap_slave, 1);
-	tlb_clear_slave(bond, new_slave, 1);
+	if (swap_port)
+		tlb_clear_port(bond, swap_port, 1);
+	tlb_clear_port(bond, new_port, 1);
 
-	/* in TLB mode, the slave might flip down/up with the old dev_addr,
+	/* in TLB mode, the port might flip down/up with the old dev_addr,
 	 * and thus filter bond->dev_addr's packets, so force bond's mac
 	 */
 	if (BOND_MODE(bond) == BOND_MODE_TLB) {
 		struct sockaddr_storage ss;
 		u8 tmp_addr[MAX_ADDR_LEN];
 
-		bond_hw_addr_copy(tmp_addr, new_slave->dev->dev_addr,
-				  new_slave->dev->addr_len);
+		bond_hw_addr_copy(tmp_addr, new_port->dev->dev_addr,
+				  new_port->dev->addr_len);
 
 		bond_hw_addr_copy(ss.__data, bond->dev->dev_addr,
 				  bond->dev->addr_len);
 		ss.ss_family = bond->dev->type;
 		/* we don't care if it can't change its mac, best effort */
-		dev_set_mac_address(new_slave->dev, (struct sockaddr *)&ss,
+		dev_set_mac_address(new_port->dev, (struct sockaddr *)&ss,
 				    NULL);
 
-		bond_hw_addr_copy(new_slave->dev->dev_addr, tmp_addr,
-				  new_slave->dev->addr_len);
+		bond_hw_addr_copy(new_port->dev->dev_addr, tmp_addr,
+				  new_port->dev->addr_len);
 	}
 
-	/* curr_active_slave must be set before calling alb_swap_mac_addr */
-	if (swap_slave) {
+	/* curr_active_port must be set before calling alb_swap_mac_addr */
+	if (swap_port) {
 		/* swap mac address */
-		alb_swap_mac_addr(swap_slave, new_slave);
-		alb_fasten_mac_swap(bond, swap_slave, new_slave);
+		alb_swap_mac_addr(swap_port, new_port);
+		alb_fasten_mac_swap(bond, swap_port, new_port);
 	} else {
-		/* set the new_slave to the bond mac address */
-		alb_set_slave_mac_addr(new_slave, bond->dev->dev_addr,
+		/* set the new_port to the bond mac address */
+		alb_set_port_mac_addr(new_port, bond->dev->dev_addr,
 				       bond->dev->addr_len);
-		alb_send_learning_packets(new_slave, bond->dev->dev_addr,
+		alb_send_learning_packets(new_port, bond->dev->dev_addr,
 					  false);
 	}
 }
@@ -1776,8 +1777,8 @@ int bond_alb_set_mac_address(struct net_device *bond_dev, void *addr)
 {
 	struct bonding *bond = netdev_priv(bond_dev);
 	struct sockaddr_storage *ss = addr;
-	struct slave *curr_active;
-	struct slave *swap_slave;
+	struct bond_port *curr_active;
+	struct bond_port *swap_port;
 	int res;
 
 	if (!is_valid_ether_addr(ss->__data))
@@ -1789,28 +1790,28 @@ int bond_alb_set_mac_address(struct net_device *bond_dev, void *addr)
 
 	bond_hw_addr_copy(bond_dev->dev_addr, ss->__data, bond_dev->addr_len);
 
-	/* If there is no curr_active_slave there is nothing else to do.
+	/* If there is no curr_active_port there is nothing else to do.
 	 * Otherwise we'll need to pass the new address to it and handle
 	 * duplications.
 	 */
-	curr_active = rtnl_dereference(bond->curr_active_slave);
+	curr_active = rtnl_dereference(bond->curr_active_port);
 	if (!curr_active)
 		return 0;
 
-	swap_slave = bond_slave_has_mac(bond, bond_dev->dev_addr);
+	swap_port = bond_port_has_mac(bond, bond_dev->dev_addr);
 
-	if (swap_slave) {
-		alb_swap_mac_addr(swap_slave, curr_active);
-		alb_fasten_mac_swap(bond, swap_slave, curr_active);
+	if (swap_port) {
+		alb_swap_mac_addr(swap_port, curr_active);
+		alb_fasten_mac_swap(bond, swap_port, curr_active);
 	} else {
-		alb_set_slave_mac_addr(curr_active, bond_dev->dev_addr,
+		alb_set_port_mac_addr(curr_active, bond_dev->dev_addr,
 				       bond_dev->addr_len);
 
 		alb_send_learning_packets(curr_active,
 					  bond_dev->dev_addr, false);
 		if (bond->alb_info.rlb_enabled) {
 			/* inform clients mac address has changed */
-			rlb_req_update_slave_clients(bond, curr_active);
+			rlb_req_update_port_clients(bond, curr_active);
 		}
 	}
 
diff --git a/drivers/net/bonding/bond_debugfs.c b/drivers/net/bonding/bond_debugfs.c
index f3f86ef68ae0..a547e1cbb31a 100644
--- a/drivers/net/bonding/bond_debugfs.c
+++ b/drivers/net/bonding/bond_debugfs.c
@@ -38,7 +38,7 @@ static int bond_debug_rlb_hash_show(struct seq_file *m, void *v)
 			&client_info->ip_src,
 			&client_info->ip_dst,
 			&client_info->mac_dst,
-			client_info->slave->dev->name);
+			client_info->port->dev->name);
 	}
 
 	spin_unlock_bh(&bond->mode_lock);
diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 405d230b8ea3..b8a351d85da4 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -17,14 +17,14 @@
  *    ifconfig bond0 ipaddress netmask up
  *      will setup a network device, with an ip address.  No mac address
  *	will be assigned at this time.  The hw mac address will come from
- *	the first slave bonded to the channel.  All slaves will then use
+ *	the first port bonded to the channel.  All ports will then use
  *	this hw mac address.
  *
  *    ifconfig bond0 down
- *         will release all slaves, marking them as down.
+ *         will release all ports, marking them as down.
  *
  *    ifenslave bond0 eth0
- *	will attach eth0 to bond0 as a slave.  eth0 hw mac address will either
+ *	will attach eth0 to bond0 as a port.  eth0 hw mac address will either
  *	a: be used as initial mac address
  *	b: if a hw mac address already is there, eth0's hw mac address
  *	   will then be set from bond0.
@@ -109,10 +109,10 @@ static char *arp_ip_target[BOND_MAX_ARP_TARGETS];
 static char *arp_validate;
 static char *arp_all_targets;
 static char *fail_over_mac;
-static int all_slaves_active;
+static int apa;
 static struct bond_params bonding_defaults;
 static int resend_igmp = BOND_DEFAULT_RESEND_IGMP;
-static int packets_per_slave = 1;
+static int rr_ppp = 1;
 static int lp_interval = BOND_ALB_DEFAULT_LP_INTERVAL;
 
 module_param(max_bonds, int, 0);
@@ -143,12 +143,12 @@ MODULE_PARM_DESC(mode, "Mode of operation; 0 for balance-rr, "
 module_param(primary, charp, 0);
 MODULE_PARM_DESC(primary, "Primary network device to use");
 module_param(primary_reselect, charp, 0);
-MODULE_PARM_DESC(primary_reselect, "Reselect primary slave "
+MODULE_PARM_DESC(primary_reselect, "Reselect primary port "
 				   "once it comes up; "
 				   "0 for always (default), "
 				   "1 for only if speed of primary is "
 				   "better, "
-				   "2 for only on active slave "
+				   "2 for only on active port "
 				   "failure");
 module_param(lacp_rate, charp, 0);
 MODULE_PARM_DESC(lacp_rate, "LACPDU tx rate to request from 802.3ad partner; "
@@ -176,24 +176,36 @@ MODULE_PARM_DESC(arp_validate, "validate src/dst of ARP probes; "
 module_param(arp_all_targets, charp, 0);
 MODULE_PARM_DESC(arp_all_targets, "fail on any/all arp targets timeout; 0 for any (default), 1 for all");
 module_param(fail_over_mac, charp, 0);
-MODULE_PARM_DESC(fail_over_mac, "For active-backup, do not set all slaves to "
+MODULE_PARM_DESC(fail_over_mac, "For active-backup, do not set all ports to "
 				"the same MAC; 0 for none (default), "
 				"1 for active, 2 for follow");
-module_param(all_slaves_active, int, 0);
-MODULE_PARM_DESC(all_slaves_active, "Keep all frames received on an interface "
-				     "by setting active flag for all slaves; "
+module_param_named(all_ports_active, apa, int, 0644);
+MODULE_PARM_DESC(all_ports_active, "Keep all frames received on an interface "
+				     "by setting active flag for all ports; "
 				     "0 for never (default), 1 for always.");
 module_param(resend_igmp, int, 0);
 MODULE_PARM_DESC(resend_igmp, "Number of IGMP membership reports to send on "
 			      "link failure");
-module_param(packets_per_slave, int, 0);
-MODULE_PARM_DESC(packets_per_slave, "Packets to send per slave in balance-rr "
-				    "mode; 0 for a random slave, 1 packet per "
-				    "slave (default), >1 packets per slave.");
+module_param_named(packets_per_port, rr_ppp, int, 0644);
+MODULE_PARM_DESC(packets_per_port, "Packets to send per port in balance-rr "
+				    "mode; 0 for a random port, 1 packet per "
+				    "port (default), >1 packets per port.");
 module_param(lp_interval, uint, 0);
 MODULE_PARM_DESC(lp_interval, "The number of seconds between instances where "
 			      "the bonding driver sends learning packets to "
-			      "each slaves peer switch. The default is 1.");
+			      "each port's peer switch. The default is 1.");
+/* legacy compatability module parameters */
+module_param_named(all_slaves_active, apa, int, 0644);
+MODULE_PARM_DESC(all_slaves_active, "Keep all frames received on an interface "
+				     "by setting active flag for all slaves; "
+				     "0 for never (default), 1 for always. "
+				     "(Legacy compat synonym for all_ports_active).");
+module_param_named(packets_per_slave, rr_ppp, int, 0644);
+MODULE_PARM_DESC(packets_per_slave, "Packets to send per slave in balance-rr "
+				    "mode; 0 for a random slave, 1 packet per "
+				    "slave (default), >1 packets per slave. "
+				    "(Legacy compat synonym for packets_per_port).");
+/* end legacy compatability module parameters */
 
 /*----------------------------- Global variables ----------------------------*/
 
@@ -254,7 +266,7 @@ static int bond_init(struct net_device *bond_dev);
 static void bond_uninit(struct net_device *bond_dev);
 static void bond_get_stats(struct net_device *bond_dev,
 			   struct rtnl_link_stats64 *stats);
-static void bond_slave_arr_handler(struct work_struct *work);
+static void bond_port_arr_handler(struct work_struct *work);
 static bool bond_time_in_interval(struct bonding *bond, unsigned long last_act,
 				  int mod);
 static void bond_netdev_notify_work(struct work_struct *work);
@@ -284,19 +296,19 @@ const char *bond_mode_name(int mode)
  *
  * @bond: bond device that got this skb for tx.
  * @skb: hw accel VLAN tagged skb to transmit
- * @slave_dev: slave that is supposed to xmit this skbuff
+ * @port_dev: port that is supposed to xmit this skbuff
  */
 netdev_tx_t bond_dev_queue_xmit(struct bonding *bond, struct sk_buff *skb,
-			struct net_device *slave_dev)
+			struct net_device *port_dev)
 {
-	skb->dev = slave_dev;
+	skb->dev = port_dev;
 
 	BUILD_BUG_ON(sizeof(skb->queue_mapping) !=
 		     sizeof(qdisc_skb_cb(skb)->slave_dev_queue_mapping));
 	skb_set_queue_mapping(skb, qdisc_skb_cb(skb)->slave_dev_queue_mapping);
 
 	if (unlikely(netpoll_tx_running(bond->dev)))
-		return bond_netpoll_send_skb(bond_get_slave_by_dev(bond, slave_dev), skb);
+		return bond_netpoll_send_skb(bond_get_port_by_dev(bond, port_dev), skb);
 
 	return dev_queue_xmit(skb);
 }
@@ -304,7 +316,7 @@ netdev_tx_t bond_dev_queue_xmit(struct bonding *bond, struct sk_buff *skb,
 /*---------------------------------- VLAN -----------------------------------*/
 
 /* In the following 2 functions, bond_vlan_rx_add_vid and bond_vlan_rx_kill_vid,
- * We don't protect the slave list iteration with a lock because:
+ * We don't protect the port list iteration with a lock because:
  * a. This operation is performed in IOCTL context,
  * b. The operation is protected by the RTNL semaphore in the 8021q code,
  * c. Holding a lock with BH disabled while directly calling a base driver
@@ -320,7 +332,7 @@ netdev_tx_t bond_dev_queue_xmit(struct bonding *bond, struct sk_buff *skb,
 */
 
 /**
- * bond_vlan_rx_add_vid - Propagates adding an id to slaves
+ * bond_vlan_rx_add_vid - Propagates adding an id to ports
  * @bond_dev: bonding net device that got called
  * @proto: network protocol ID
  * @vid: vlan id being added
@@ -329,12 +341,12 @@ static int bond_vlan_rx_add_vid(struct net_device *bond_dev,
 				__be16 proto, u16 vid)
 {
 	struct bonding *bond = netdev_priv(bond_dev);
-	struct slave *slave, *rollback_slave;
+	struct bond_port *port, *rollback_port;
 	struct list_head *iter;
 	int res;
 
-	bond_for_each_slave(bond, slave, iter) {
-		res = vlan_vid_add(slave->dev, proto, vid);
+	bond_for_each_port(bond, port, iter) {
+		res = vlan_vid_add(port->dev, proto, vid);
 		if (res)
 			goto unwind;
 	}
@@ -342,19 +354,19 @@ static int bond_vlan_rx_add_vid(struct net_device *bond_dev,
 	return 0;
 
 unwind:
-	/* unwind to the slave that failed */
-	bond_for_each_slave(bond, rollback_slave, iter) {
-		if (rollback_slave == slave)
+	/* unwind to the port that failed */
+	bond_for_each_port(bond, rollback_port, iter) {
+		if (rollback_port == port)
 			break;
 
-		vlan_vid_del(rollback_slave->dev, proto, vid);
+		vlan_vid_del(rollback_port->dev, proto, vid);
 	}
 
 	return res;
 }
 
 /**
- * bond_vlan_rx_kill_vid - Propagates deleting an id to slaves
+ * bond_vlan_rx_kill_vid - Propagates deleting an id to ports
  * @bond_dev: bonding net device that got called
  * @proto: network protocol ID
  * @vid: vlan id being removed
@@ -364,10 +376,10 @@ static int bond_vlan_rx_kill_vid(struct net_device *bond_dev,
 {
 	struct bonding *bond = netdev_priv(bond_dev);
 	struct list_head *iter;
-	struct slave *slave;
+	struct bond_port *port;
 
-	bond_for_each_slave(bond, slave, iter)
-		vlan_vid_del(slave->dev, proto, vid);
+	bond_for_each_port(bond, port, iter)
+		vlan_vid_del(port->dev, proto, vid);
 
 	if (bond_is_lb(bond))
 		bond_alb_clear_vlan(bond, vid);
@@ -386,23 +398,23 @@ static int bond_ipsec_add_sa(struct xfrm_state *xs)
 {
 	struct net_device *bond_dev = xs->xso.dev;
 	struct bonding *bond;
-	struct slave *slave;
+	struct bond_port *port;
 
 	if (!bond_dev)
 		return -EINVAL;
 
 	bond = netdev_priv(bond_dev);
-	slave = rcu_dereference(bond->curr_active_slave);
-	xs->xso.real_dev = slave->dev;
+	port = rcu_dereference(bond->curr_active_port);
+	xs->xso.real_dev = port->dev;
 	bond->xs = xs;
 
-	if (!(slave->dev->xfrmdev_ops
-	      && slave->dev->xfrmdev_ops->xdo_dev_state_add)) {
-		slave_warn(bond_dev, slave->dev, "Slave does not support ipsec offload\n");
+	if (!(port->dev->xfrmdev_ops
+	      && port->dev->xfrmdev_ops->xdo_dev_state_add)) {
+		port_warn(bond_dev, port->dev, "Port does not support ipsec offload\n");
 		return -EINVAL;
 	}
 
-	return slave->dev->xfrmdev_ops->xdo_dev_state_add(xs);
+	return port->dev->xfrmdev_ops->xdo_dev_state_add(xs);
 }
 
 /**
@@ -413,26 +425,26 @@ static void bond_ipsec_del_sa(struct xfrm_state *xs)
 {
 	struct net_device *bond_dev = xs->xso.dev;
 	struct bonding *bond;
-	struct slave *slave;
+	struct bond_port *port;
 
 	if (!bond_dev)
 		return;
 
 	bond = netdev_priv(bond_dev);
-	slave = rcu_dereference(bond->curr_active_slave);
+	port = rcu_dereference(bond->curr_active_port);
 
-	if (!slave)
+	if (!port)
 		return;
 
-	xs->xso.real_dev = slave->dev;
+	xs->xso.real_dev = port->dev;
 
-	if (!(slave->dev->xfrmdev_ops
-	      && slave->dev->xfrmdev_ops->xdo_dev_state_delete)) {
-		slave_warn(bond_dev, slave->dev, "%s: no slave xdo_dev_state_delete\n", __func__);
+	if (!(port->dev->xfrmdev_ops
+	      && port->dev->xfrmdev_ops->xdo_dev_state_delete)) {
+		port_warn(bond_dev, port->dev, "%s: no port xdo_dev_state_delete\n", __func__);
 		return;
 	}
 
-	slave->dev->xfrmdev_ops->xdo_dev_state_delete(xs);
+	port->dev->xfrmdev_ops->xdo_dev_state_delete(xs);
 }
 
 /**
@@ -444,20 +456,20 @@ static bool bond_ipsec_offload_ok(struct sk_buff *skb, struct xfrm_state *xs)
 {
 	struct net_device *bond_dev = xs->xso.dev;
 	struct bonding *bond = netdev_priv(bond_dev);
-	struct slave *curr_active = rcu_dereference(bond->curr_active_slave);
-	struct net_device *slave_dev = curr_active->dev;
+	struct bond_port *curr_active = rcu_dereference(bond->curr_active_port);
+	struct net_device *port_dev = curr_active->dev;
 
 	if (BOND_MODE(bond) != BOND_MODE_ACTIVEBACKUP)
 		return true;
 
-	if (!(slave_dev->xfrmdev_ops
-	      && slave_dev->xfrmdev_ops->xdo_dev_offload_ok)) {
-		slave_warn(bond_dev, slave_dev, "%s: no slave xdo_dev_offload_ok\n", __func__);
+	if (!(port_dev->xfrmdev_ops
+	      && port_dev->xfrmdev_ops->xdo_dev_offload_ok)) {
+		port_warn(bond_dev, port_dev, "%s: no port xdo_dev_offload_ok\n", __func__);
 		return false;
 	}
 
-	xs->xso.real_dev = slave_dev;
-	return slave_dev->xfrmdev_ops->xdo_dev_offload_ok(skb, xs);
+	xs->xso.real_dev = port_dev;
+	return port_dev->xfrmdev_ops->xdo_dev_offload_ok(skb, xs);
 }
 
 static const struct xfrmdev_ops bond_xfrmdev_ops = {
@@ -470,7 +482,7 @@ static const struct xfrmdev_ops bond_xfrmdev_ops = {
 /*------------------------------- Link status -------------------------------*/
 
 /* Set the carrier state for the bond according to the state of its
- * slaves.  If any slaves are up, the bond is up.  In 802.3ad mode,
+ * ports.  If any ports are up, the bond is up.  In 802.3ad mode,
  * do special 802.3ad magic.
  *
  * Returns zero if carrier state does not change, nonzero if it does.
@@ -478,16 +490,16 @@ static const struct xfrmdev_ops bond_xfrmdev_ops = {
 int bond_set_carrier(struct bonding *bond)
 {
 	struct list_head *iter;
-	struct slave *slave;
+	struct bond_port *port;
 
-	if (!bond_has_slaves(bond))
+	if (!bond_has_ports(bond))
 		goto down;
 
 	if (BOND_MODE(bond) == BOND_MODE_8023AD)
 		return bond_3ad_set_carrier(bond);
 
-	bond_for_each_slave(bond, slave, iter) {
-		if (slave->link == BOND_LINK_UP) {
+	bond_for_each_port(bond, port, iter) {
+		if (port->link == BOND_LINK_UP) {
 			if (!netif_carrier_ok(bond->dev)) {
 				netif_carrier_on(bond->dev);
 				return 1;
@@ -504,22 +516,22 @@ int bond_set_carrier(struct bonding *bond)
 	return 0;
 }
 
-/* Get link speed and duplex from the slave's base driver
+/* Get link speed and duplex from the port's base driver
  * using ethtool. If for some reason the call fails or the
  * values are invalid, set speed and duplex to -1,
  * and return. Return 1 if speed or duplex settings are
  * UNKNOWN; 0 otherwise.
  */
-static int bond_update_speed_duplex(struct slave *slave)
+static int bond_update_speed_duplex(struct bond_port *port)
 {
-	struct net_device *slave_dev = slave->dev;
+	struct net_device *port_dev = port->dev;
 	struct ethtool_link_ksettings ecmd;
 	int res;
 
-	slave->speed = SPEED_UNKNOWN;
-	slave->duplex = DUPLEX_UNKNOWN;
+	port->speed = SPEED_UNKNOWN;
+	port->duplex = DUPLEX_UNKNOWN;
 
-	res = __ethtool_get_link_ksettings(slave_dev, &ecmd);
+	res = __ethtool_get_link_ksettings(port_dev, &ecmd);
 	if (res < 0)
 		return 1;
 	if (ecmd.base.speed == 0 || ecmd.base.speed == ((__u32)-1))
@@ -532,13 +544,13 @@ static int bond_update_speed_duplex(struct slave *slave)
 		return 1;
 	}
 
-	slave->speed = ecmd.base.speed;
-	slave->duplex = ecmd.base.duplex;
+	port->speed = ecmd.base.speed;
+	port->duplex = ecmd.base.duplex;
 
 	return 0;
 }
 
-const char *bond_slave_link_status(s8 link)
+const char *bond_port_link_status(s8 link)
 {
 	switch (link) {
 	case BOND_LINK_UP:
@@ -570,26 +582,26 @@ const char *bond_slave_link_status(s8 link)
  * netif_carrier, but there really isn't.
  */
 static int bond_check_dev_link(struct bonding *bond,
-			       struct net_device *slave_dev, int reporting)
+			       struct net_device *port_dev, int reporting)
 {
-	const struct net_device_ops *slave_ops = slave_dev->netdev_ops;
+	const struct net_device_ops *port_ops = port_dev->netdev_ops;
 	int (*ioctl)(struct net_device *, struct ifreq *, int);
 	struct ifreq ifr;
 	struct mii_ioctl_data *mii;
 
-	if (!reporting && !netif_running(slave_dev))
+	if (!reporting && !netif_running(port_dev))
 		return 0;
 
 	if (bond->params.use_carrier)
-		return netif_carrier_ok(slave_dev) ? BMSR_LSTATUS : 0;
+		return netif_carrier_ok(port_dev) ? BMSR_LSTATUS : 0;
 
 	/* Try to get link status using Ethtool first. */
-	if (slave_dev->ethtool_ops->get_link)
-		return slave_dev->ethtool_ops->get_link(slave_dev) ?
+	if (port_dev->ethtool_ops->get_link)
+		return port_dev->ethtool_ops->get_link(port_dev) ?
 			BMSR_LSTATUS : 0;
 
 	/* Ethtool can't be used, fallback to MII ioctls. */
-	ioctl = slave_ops->ndo_do_ioctl;
+	ioctl = port_ops->ndo_do_ioctl;
 	if (ioctl) {
 		/* TODO: set pointer to correct ioctl on a per team member
 		 *       bases to make this more efficient. that is, once
@@ -604,11 +616,11 @@ static int bond_check_dev_link(struct bonding *bond,
 		 */
 
 		/* Yes, the mii is overlaid on the ifreq.ifr_ifru */
-		strncpy(ifr.ifr_name, slave_dev->name, IFNAMSIZ);
+		strncpy(ifr.ifr_name, port_dev->name, IFNAMSIZ);
 		mii = if_mii(&ifr);
-		if (ioctl(slave_dev, &ifr, SIOCGMIIPHY) == 0) {
+		if (ioctl(port_dev, &ifr, SIOCGMIIPHY) == 0) {
 			mii->reg_num = MII_BMSR;
-			if (ioctl(slave_dev, &ifr, SIOCGMIIREG) == 0)
+			if (ioctl(port_dev, &ifr, SIOCGMIIREG) == 0)
 				return mii->val_out & BMSR_LSTATUS;
 		}
 	}
@@ -623,22 +635,22 @@ static int bond_check_dev_link(struct bonding *bond,
 
 /*----------------------------- Multicast list ------------------------------*/
 
-/* Push the promiscuity flag down to appropriate slaves */
+/* Push the promiscuity flag down to appropriate ports */
 static int bond_set_promiscuity(struct bonding *bond, int inc)
 {
 	struct list_head *iter;
 	int err = 0;
 
 	if (bond_uses_primary(bond)) {
-		struct slave *curr_active = rtnl_dereference(bond->curr_active_slave);
+		struct bond_port *curr_active = rtnl_dereference(bond->curr_active_port);
 
 		if (curr_active)
 			err = dev_set_promiscuity(curr_active->dev, inc);
 	} else {
-		struct slave *slave;
+		struct bond_port *port;
 
-		bond_for_each_slave(bond, slave, iter) {
-			err = dev_set_promiscuity(slave->dev, inc);
+		bond_for_each_port(bond, port, iter) {
+			err = dev_set_promiscuity(port->dev, inc);
 			if (err)
 				return err;
 		}
@@ -646,22 +658,22 @@ static int bond_set_promiscuity(struct bonding *bond, int inc)
 	return err;
 }
 
-/* Push the allmulti flag down to all slaves */
+/* Push the allmulti flag down to all ports */
 static int bond_set_allmulti(struct bonding *bond, int inc)
 {
 	struct list_head *iter;
 	int err = 0;
 
 	if (bond_uses_primary(bond)) {
-		struct slave *curr_active = rtnl_dereference(bond->curr_active_slave);
+		struct bond_port *curr_active = rtnl_dereference(bond->curr_active_port);
 
 		if (curr_active)
 			err = dev_set_allmulti(curr_active->dev, inc);
 	} else {
-		struct slave *slave;
+		struct bond_port *port;
 
-		bond_for_each_slave(bond, slave, iter) {
-			err = dev_set_allmulti(slave->dev, inc);
+		bond_for_each_port(bond, port, iter) {
+			err = dev_set_allmulti(port->dev, inc);
 			if (err)
 				return err;
 		}
@@ -671,7 +683,7 @@ static int bond_set_allmulti(struct bonding *bond, int inc)
 
 /* Retrieve the list of registered multicast addresses for the bonding
  * device and retransmit an IGMP JOIN request to the current active
- * slave.
+ * port.
  */
 static void bond_resend_igmp_join_requests_delayed(struct work_struct *work)
 {
@@ -691,32 +703,32 @@ static void bond_resend_igmp_join_requests_delayed(struct work_struct *work)
 	rtnl_unlock();
 }
 
-/* Flush bond's hardware addresses from slave */
+/* Flush bond's hardware addresses from port */
 static void bond_hw_addr_flush(struct net_device *bond_dev,
-			       struct net_device *slave_dev)
+			       struct net_device *port_dev)
 {
 	struct bonding *bond = netdev_priv(bond_dev);
 
-	dev_uc_unsync(slave_dev, bond_dev);
-	dev_mc_unsync(slave_dev, bond_dev);
+	dev_uc_unsync(port_dev, bond_dev);
+	dev_mc_unsync(port_dev, bond_dev);
 
 	if (BOND_MODE(bond) == BOND_MODE_8023AD) {
 		/* del lacpdu mc addr from mc list */
 		u8 lacpdu_multicast[ETH_ALEN] = MULTICAST_LACPDU_ADDR;
 
-		dev_mc_del(slave_dev, lacpdu_multicast);
+		dev_mc_del(port_dev, lacpdu_multicast);
 	}
 }
 
-/*--------------------------- Active slave change ---------------------------*/
+/*--------------------------- Active port change ---------------------------*/
 
 /* Update the hardware address list and promisc/allmulti for the new and
- * old active slaves (if any).  Modes that are not using primary keep all
- * slaves up date at all times; only the modes that use primary need to call
+ * old active ports (if any).  Modes that are not using primary keep all
+ * ports up date at all times; only the modes that use primary need to call
  * this function to swap these settings during a failover.
  */
-static void bond_hw_addr_swap(struct bonding *bond, struct slave *new_active,
-			      struct slave *old_active)
+static void bond_hw_addr_swap(struct bonding *bond, struct bond_port *new_active,
+			      struct bond_port *old_active)
 {
 	if (old_active) {
 		if (bond->dev->flags & IFF_PROMISC)
@@ -744,41 +756,41 @@ static void bond_hw_addr_swap(struct bonding *bond, struct slave *new_active,
 }
 
 /**
- * bond_set_dev_addr - clone slave's address to bond
+ * bond_set_dev_addr - clone port's address to bond
  * @bond_dev: bond net device
- * @slave_dev: slave net device
+ * @port_dev: port net device
  *
  * Should be called with RTNL held.
  */
 static int bond_set_dev_addr(struct net_device *bond_dev,
-			     struct net_device *slave_dev)
+			     struct net_device *port_dev)
 {
 	int err;
 
-	slave_dbg(bond_dev, slave_dev, "bond_dev=%p slave_dev=%p slave_dev->addr_len=%d\n",
-		  bond_dev, slave_dev, slave_dev->addr_len);
-	err = dev_pre_changeaddr_notify(bond_dev, slave_dev->dev_addr, NULL);
+	port_dbg(bond_dev, port_dev, "bond_dev=%p port_dev=%p port_dev->addr_len=%d\n",
+		 bond_dev, port_dev, port_dev->addr_len);
+	err = dev_pre_changeaddr_notify(bond_dev, port_dev->dev_addr, NULL);
 	if (err)
 		return err;
 
-	memcpy(bond_dev->dev_addr, slave_dev->dev_addr, slave_dev->addr_len);
+	memcpy(bond_dev->dev_addr, port_dev->dev_addr, port_dev->addr_len);
 	bond_dev->addr_assign_type = NET_ADDR_STOLEN;
 	call_netdevice_notifiers(NETDEV_CHANGEADDR, bond_dev);
 	return 0;
 }
 
-static struct slave *bond_get_old_active(struct bonding *bond,
-					 struct slave *new_active)
+static struct bond_port *bond_get_old_active(struct bonding *bond,
+					 struct bond_port *new_active)
 {
-	struct slave *slave;
+	struct bond_port *port;
 	struct list_head *iter;
 
-	bond_for_each_slave(bond, slave, iter) {
-		if (slave == new_active)
+	bond_for_each_port(bond, port, iter) {
+		if (port == new_active)
 			continue;
 
-		if (ether_addr_equal(bond->dev->dev_addr, slave->dev->dev_addr))
-			return slave;
+		if (ether_addr_equal(bond->dev->dev_addr, port->dev->dev_addr))
+			return port;
 	}
 
 	return NULL;
@@ -791,8 +803,8 @@ static struct slave *bond_get_old_active(struct bonding *bond,
  * Called with RTNL
  */
 static void bond_do_fail_over_mac(struct bonding *bond,
-				  struct slave *new_active,
-				  struct slave *old_active)
+				  struct bond_port *new_active,
+				  struct bond_port *old_active)
 {
 	u8 tmp_mac[MAX_ADDR_LEN];
 	struct sockaddr_storage ss;
@@ -803,13 +815,13 @@ static void bond_do_fail_over_mac(struct bonding *bond,
 		if (new_active) {
 			rv = bond_set_dev_addr(bond->dev, new_active->dev);
 			if (rv)
-				slave_err(bond->dev, new_active->dev, "Error %d setting bond MAC from slave\n",
-					  -rv);
+				port_err(bond->dev, new_active->dev, "Error %d setting bond MAC from port\n",
+					 -rv);
 		}
 		break;
 	case BOND_FOM_FOLLOW:
 		/* if new_active && old_active, swap them
-		 * if just old_active, do nothing (going to no active slave)
+		 * if just old_active, do nothing (going to no active port)
 		 * if just new_active, set new_active to bond's MAC
 		 */
 		if (!new_active)
@@ -834,8 +846,8 @@ static void bond_do_fail_over_mac(struct bonding *bond,
 		rv = dev_set_mac_address(new_active->dev,
 					 (struct sockaddr *)&ss, NULL);
 		if (rv) {
-			slave_err(bond->dev, new_active->dev, "Error %d setting MAC of new active slave\n",
-				  -rv);
+			port_err(bond->dev, new_active->dev, "Error %d setting MAC of new active port\n",
+				 -rv);
 			goto out;
 		}
 
@@ -849,8 +861,8 @@ static void bond_do_fail_over_mac(struct bonding *bond,
 		rv = dev_set_mac_address(old_active->dev,
 					 (struct sockaddr *)&ss, NULL);
 		if (rv)
-			slave_err(bond->dev, old_active->dev, "Error %d setting MAC of old active slave\n",
-				  -rv);
+			port_err(bond->dev, old_active->dev, "Error %d setting MAC of old active port\n",
+				 -rv);
 out:
 		break;
 	default:
@@ -861,10 +873,10 @@ static void bond_do_fail_over_mac(struct bonding *bond,
 
 }
 
-static struct slave *bond_choose_primary_or_current(struct bonding *bond)
+static struct bond_port *bond_choose_primary_or_current(struct bonding *bond)
 {
-	struct slave *prim = rtnl_dereference(bond->primary_slave);
-	struct slave *curr = rtnl_dereference(bond->curr_active_slave);
+	struct bond_port *prim = rtnl_dereference(bond->primary_port);
+	struct bond_port *curr = rtnl_dereference(bond->curr_active_port);
 
 	if (!prim || prim->link != BOND_LINK_UP) {
 		if (!curr || curr->link != BOND_LINK_UP)
@@ -900,75 +912,75 @@ static struct slave *bond_choose_primary_or_current(struct bonding *bond)
 }
 
 /**
- * bond_find_best_slave - select the best available slave to be the active one
+ * bond_find_best_port - select the best available port to be the active one
  * @bond: our bonding struct
  */
-static struct slave *bond_find_best_slave(struct bonding *bond)
+static struct bond_port *bond_find_best_port(struct bonding *bond)
 {
-	struct slave *slave, *bestslave = NULL;
+	struct bond_port *port, *bestport = NULL;
 	struct list_head *iter;
 	int mintime = bond->params.updelay;
 
-	slave = bond_choose_primary_or_current(bond);
-	if (slave)
-		return slave;
-
-	bond_for_each_slave(bond, slave, iter) {
-		if (slave->link == BOND_LINK_UP)
-			return slave;
-		if (slave->link == BOND_LINK_BACK && bond_slave_is_up(slave) &&
-		    slave->delay < mintime) {
-			mintime = slave->delay;
-			bestslave = slave;
+	port = bond_choose_primary_or_current(bond);
+	if (port)
+		return port;
+
+	bond_for_each_port(bond, port, iter) {
+		if (port->link == BOND_LINK_UP)
+			return port;
+		if (port->link == BOND_LINK_BACK && bond_port_is_up(port) &&
+		    port->delay < mintime) {
+			mintime = port->delay;
+			bestport = port;
 		}
 	}
 
-	return bestslave;
+	return bestport;
 }
 
 static bool bond_should_notify_peers(struct bonding *bond)
 {
-	struct slave *slave;
+	struct bond_port *port;
 
 	rcu_read_lock();
-	slave = rcu_dereference(bond->curr_active_slave);
+	port = rcu_dereference(bond->curr_active_port);
 	rcu_read_unlock();
 
-	netdev_dbg(bond->dev, "bond_should_notify_peers: slave %s\n",
-		   slave ? slave->dev->name : "NULL");
+	netdev_dbg(bond->dev, "bond_should_notify_peers: port %s\n",
+		   port ? port->dev->name : "NULL");
 
-	if (!slave || !bond->send_peer_notif ||
+	if (!port || !bond->send_peer_notif ||
 	    bond->send_peer_notif %
 	    max(1, bond->params.peer_notif_delay) != 0 ||
 	    !netif_carrier_ok(bond->dev) ||
-	    test_bit(__LINK_STATE_LINKWATCH_PENDING, &slave->dev->state))
+	    test_bit(__LINK_STATE_LINKWATCH_PENDING, &port->dev->state))
 		return false;
 
 	return true;
 }
 
 /**
- * change_active_interface - change the active slave into the specified one
+ * change_active_interface - change the active port into the specified one
  * @bond: our bonding struct
- * @new_active: the new slave to make the active one
+ * @new_active: the new port to make the active one
  *
- * Set the new slave to the bond's settings and unset them on the old
- * curr_active_slave.
+ * Set the new port to the bond's settings and unset them on the old
+ * curr_active_port.
  * Setting include flags, mc-list, promiscuity, allmulti, etc.
  *
  * If @new's link state is %BOND_LINK_BACK we'll set it to %BOND_LINK_UP,
- * because it is apparently the best available slave we have, even though its
+ * because it is apparently the best available port we have, even though its
  * updelay hasn't timed out yet.
  *
  * Caller must hold RTNL.
  */
-void bond_change_active_slave(struct bonding *bond, struct slave *new_active)
+void bond_change_active_port(struct bonding *bond, struct bond_port *new_active)
 {
-	struct slave *old_active;
+	struct bond_port *old_active;
 
 	ASSERT_RTNL();
 
-	old_active = rtnl_dereference(bond->curr_active_slave);
+	old_active = rtnl_dereference(bond->curr_active_port);
 
 	if (old_active == new_active)
 		return;
@@ -983,13 +995,13 @@ void bond_change_active_slave(struct bonding *bond, struct slave *new_active)
 
 		if (new_active->link == BOND_LINK_BACK) {
 			if (bond_uses_primary(bond)) {
-				slave_info(bond->dev, new_active->dev, "making interface the new active one %d ms earlier\n",
-					   (bond->params.updelay - new_active->delay) * bond->params.miimon);
+				port_info(bond->dev, new_active->dev, "making interface the new active one %d ms earlier\n",
+					  (bond->params.updelay - new_active->delay) * bond->params.miimon);
 			}
 
 			new_active->delay = 0;
-			bond_set_slave_link_state(new_active, BOND_LINK_UP,
-						  BOND_SLAVE_NOTIFY_NOW);
+			bond_set_port_link_state(new_active, BOND_LINK_UP,
+						 BOND_PORT_NOTIFY_NOW);
 
 			if (BOND_MODE(bond) == BOND_MODE_8023AD)
 				bond_3ad_handle_link_change(new_active, BOND_LINK_UP);
@@ -998,7 +1010,7 @@ void bond_change_active_slave(struct bonding *bond, struct slave *new_active)
 				bond_alb_handle_link_change(bond, new_active, BOND_LINK_UP);
 		} else {
 			if (bond_uses_primary(bond)) {
-				slave_info(bond->dev, new_active->dev, "making interface the new active one\n");
+				port_info(bond->dev, new_active->dev, "making interface the new active one\n");
 			}
 		}
 	}
@@ -1009,25 +1021,25 @@ void bond_change_active_slave(struct bonding *bond, struct slave *new_active)
 	if (bond_is_lb(bond)) {
 		bond_alb_handle_active_change(bond, new_active);
 		if (old_active)
-			bond_set_slave_inactive_flags(old_active,
-						      BOND_SLAVE_NOTIFY_NOW);
+			bond_set_port_inactive_flags(old_active,
+						      BOND_PORT_NOTIFY_NOW);
 		if (new_active)
-			bond_set_slave_active_flags(new_active,
-						    BOND_SLAVE_NOTIFY_NOW);
+			bond_set_port_active_flags(new_active,
+						    BOND_PORT_NOTIFY_NOW);
 	} else {
-		rcu_assign_pointer(bond->curr_active_slave, new_active);
+		rcu_assign_pointer(bond->curr_active_port, new_active);
 	}
 
 	if (BOND_MODE(bond) == BOND_MODE_ACTIVEBACKUP) {
 		if (old_active)
-			bond_set_slave_inactive_flags(old_active,
-						      BOND_SLAVE_NOTIFY_NOW);
+			bond_set_port_inactive_flags(old_active,
+						      BOND_PORT_NOTIFY_NOW);
 
 		if (new_active) {
 			bool should_notify_peers = false;
 
-			bond_set_slave_active_flags(new_active,
-						    BOND_SLAVE_NOTIFY_NOW);
+			bond_set_port_active_flags(new_active,
+						    BOND_PORT_NOTIFY_NOW);
 
 			if (bond->params.fail_over_mac)
 				bond_do_fail_over_mac(bond, new_active,
@@ -1057,8 +1069,8 @@ void bond_change_active_slave(struct bonding *bond, struct slave *new_active)
 	}
 #endif /* CONFIG_XFRM_OFFLOAD */
 
-	/* resend IGMP joins since active slave has changed or
-	 * all were sent on curr_active_slave.
+	/* resend IGMP joins since active port has changed or
+	 * all were sent on curr_active_port.
 	 * resend only if bond is brought up with the affected
 	 * bonding modes and the retransmission is enabled
 	 */
@@ -1071,26 +1083,26 @@ void bond_change_active_slave(struct bonding *bond, struct slave *new_active)
 }
 
 /**
- * bond_select_active_slave - select a new active slave, if needed
+ * bond_select_active_port - select a new active port, if needed
  * @bond: our bonding struct
  *
  * This functions should be called when one of the following occurs:
- * - The old curr_active_slave has been released or lost its link.
- * - The primary_slave has got its link back.
- * - A slave has got its link back and there's no old curr_active_slave.
+ * - The old curr_active_port has been released or lost its link.
+ * - The primary_port has got its link back.
+ * - A port has got its link back and there's no old curr_active_port.
  *
  * Caller must hold RTNL.
  */
-void bond_select_active_slave(struct bonding *bond)
+void bond_select_active_port(struct bonding *bond)
 {
-	struct slave *best_slave;
+	struct bond_port *best_port;
 	int rv;
 
 	ASSERT_RTNL();
 
-	best_slave = bond_find_best_slave(bond);
-	if (best_slave != rtnl_dereference(bond->curr_active_slave)) {
-		bond_change_active_slave(bond, best_slave);
+	best_port = bond_find_best_port(bond);
+	if (best_port != rtnl_dereference(bond->curr_active_port)) {
+		bond_change_active_port(bond, best_port);
 		rv = bond_set_carrier(bond);
 		if (!rv)
 			return;
@@ -1103,7 +1115,7 @@ void bond_select_active_slave(struct bonding *bond)
 }
 
 #ifdef CONFIG_NET_POLL_CONTROLLER
-static inline int slave_enable_netpoll(struct slave *slave)
+static inline int bond_port_enable_netpoll(struct bond_port *port)
 {
 	struct netpoll *np;
 	int err = 0;
@@ -1113,23 +1125,23 @@ static inline int slave_enable_netpoll(struct slave *slave)
 	if (!np)
 		goto out;
 
-	err = __netpoll_setup(np, slave->dev);
+	err = __netpoll_setup(np, port->dev);
 	if (err) {
 		kfree(np);
 		goto out;
 	}
-	slave->np = np;
+	port->np = np;
 out:
 	return err;
 }
-static inline void slave_disable_netpoll(struct slave *slave)
+static inline void bond_port_disable_netpoll(struct bond_port *port)
 {
-	struct netpoll *np = slave->np;
+	struct netpoll *np = port->np;
 
 	if (!np)
 		return;
 
-	slave->np = NULL;
+	port->np = NULL;
 
 	__netpoll_free(np);
 }
@@ -1137,7 +1149,7 @@ static inline void slave_disable_netpoll(struct slave *slave)
 static void bond_poll_controller(struct net_device *bond_dev)
 {
 	struct bonding *bond = netdev_priv(bond_dev);
-	struct slave *slave = NULL;
+	struct bond_port *port = NULL;
 	struct list_head *iter;
 	struct ad_info ad_info;
 
@@ -1145,20 +1157,20 @@ static void bond_poll_controller(struct net_device *bond_dev)
 		if (bond_3ad_get_active_agg_info(bond, &ad_info))
 			return;
 
-	bond_for_each_slave_rcu(bond, slave, iter) {
-		if (!bond_slave_is_up(slave))
+	bond_for_each_port_rcu(bond, port, iter) {
+		if (!bond_port_is_up(port))
 			continue;
 
 		if (BOND_MODE(bond) == BOND_MODE_8023AD) {
 			struct aggregator *agg =
-			    SLAVE_AD_INFO(slave)->ad_port.aggregator;
+			    PORT_AD_INFO(port)->ad_port.aggregator;
 
 			if (agg &&
 			    agg->aggregator_identifier != ad_info.aggregator_id)
 				continue;
 		}
 
-		netpoll_poll_dev(slave->dev);
+		netpoll_poll_dev(port->dev);
 	}
 }
 
@@ -1166,22 +1178,22 @@ static void bond_netpoll_cleanup(struct net_device *bond_dev)
 {
 	struct bonding *bond = netdev_priv(bond_dev);
 	struct list_head *iter;
-	struct slave *slave;
+	struct bond_port *port;
 
-	bond_for_each_slave(bond, slave, iter)
-		if (bond_slave_is_up(slave))
-			slave_disable_netpoll(slave);
+	bond_for_each_port(bond, port, iter)
+		if (bond_port_is_up(port))
+			bond_port_disable_netpoll(port);
 }
 
 static int bond_netpoll_setup(struct net_device *dev, struct netpoll_info *ni)
 {
 	struct bonding *bond = netdev_priv(dev);
 	struct list_head *iter;
-	struct slave *slave;
+	struct bond_port *port;
 	int err = 0;
 
-	bond_for_each_slave(bond, slave, iter) {
-		err = slave_enable_netpoll(slave);
+	bond_for_each_port(bond, port, iter) {
+		err = bond_port_enable_netpoll(port);
 		if (err) {
 			bond_netpoll_cleanup(dev);
 			break;
@@ -1190,11 +1202,11 @@ static int bond_netpoll_setup(struct net_device *dev, struct netpoll_info *ni)
 	return err;
 }
 #else
-static inline int slave_enable_netpoll(struct slave *slave)
+static inline int bond_port_enable_netpoll(struct bond_port *port)
 {
 	return 0;
 }
-static inline void slave_disable_netpoll(struct slave *slave)
+static inline void bond_port_disable_netpoll(struct bond_port *port)
 {
 }
 static void bond_netpoll_cleanup(struct net_device *bond_dev)
@@ -1210,16 +1222,16 @@ static netdev_features_t bond_fix_features(struct net_device *dev,
 	struct bonding *bond = netdev_priv(dev);
 	struct list_head *iter;
 	netdev_features_t mask;
-	struct slave *slave;
+	struct bond_port *port;
 
 	mask = features;
 
 	features &= ~NETIF_F_ONE_FOR_ALL;
 	features |= NETIF_F_ALL_FOR_ALL;
 
-	bond_for_each_slave(bond, slave, iter) {
+	bond_for_each_port(bond, port, iter) {
 		features = netdev_increment_features(features,
-						     slave->dev->features,
+						     port->dev->features,
 						     mask);
 	}
 	features = netdev_add_tso_features(features, mask);
@@ -1250,40 +1262,40 @@ static void bond_compute_features(struct bonding *bond)
 	netdev_features_t mpls_features  = BOND_MPLS_FEATURES;
 	struct net_device *bond_dev = bond->dev;
 	struct list_head *iter;
-	struct slave *slave;
+	struct bond_port *port;
 	unsigned short max_hard_header_len = ETH_HLEN;
 	unsigned int gso_max_size = GSO_MAX_SIZE;
 	u16 gso_max_segs = GSO_MAX_SEGS;
 
-	if (!bond_has_slaves(bond))
+	if (!bond_has_ports(bond))
 		goto done;
 	vlan_features &= NETIF_F_ALL_FOR_ALL;
 	mpls_features &= NETIF_F_ALL_FOR_ALL;
 
-	bond_for_each_slave(bond, slave, iter) {
+	bond_for_each_port(bond, port, iter) {
 		vlan_features = netdev_increment_features(vlan_features,
-			slave->dev->vlan_features, BOND_VLAN_FEATURES);
+			port->dev->vlan_features, BOND_VLAN_FEATURES);
 
 		enc_features = netdev_increment_features(enc_features,
-							 slave->dev->hw_enc_features,
+							 port->dev->hw_enc_features,
 							 BOND_ENC_FEATURES);
 
 #ifdef CONFIG_XFRM_OFFLOAD
 		xfrm_features = netdev_increment_features(xfrm_features,
-							  slave->dev->hw_enc_features,
+							  port->dev->hw_enc_features,
 							  BOND_XFRM_FEATURES);
 #endif /* CONFIG_XFRM_OFFLOAD */
 
 		mpls_features = netdev_increment_features(mpls_features,
-							  slave->dev->mpls_features,
+							  port->dev->mpls_features,
 							  BOND_MPLS_FEATURES);
 
-		dst_release_flag &= slave->dev->priv_flags;
-		if (slave->dev->hard_header_len > max_hard_header_len)
-			max_hard_header_len = slave->dev->hard_header_len;
+		dst_release_flag &= port->dev->priv_flags;
+		if (port->dev->hard_header_len > max_hard_header_len)
+			max_hard_header_len = port->dev->hard_header_len;
 
-		gso_max_size = min(gso_max_size, slave->dev->gso_max_size);
-		gso_max_segs = min(gso_max_segs, slave->dev->gso_max_segs);
+		gso_max_size = min(gso_max_size, port->dev->gso_max_size);
+		gso_max_segs = min(gso_max_segs, port->dev->gso_max_segs);
 	}
 	bond_dev->hard_header_len = max_hard_header_len;
 
@@ -1308,27 +1320,27 @@ static void bond_compute_features(struct bonding *bond)
 	netdev_change_features(bond_dev);
 }
 
-static void bond_setup_by_slave(struct net_device *bond_dev,
-				struct net_device *slave_dev)
+static void bond_setup_by_port(struct net_device *bond_dev,
+			       struct net_device *port_dev)
 {
-	bond_dev->header_ops	    = slave_dev->header_ops;
+	bond_dev->header_ops	    = port_dev->header_ops;
 
-	bond_dev->type		    = slave_dev->type;
-	bond_dev->hard_header_len   = slave_dev->hard_header_len;
-	bond_dev->addr_len	    = slave_dev->addr_len;
+	bond_dev->type		    = port_dev->type;
+	bond_dev->hard_header_len   = port_dev->hard_header_len;
+	bond_dev->addr_len	    = port_dev->addr_len;
 
-	memcpy(bond_dev->broadcast, slave_dev->broadcast,
-		slave_dev->addr_len);
+	memcpy(bond_dev->broadcast, port_dev->broadcast,
+		port_dev->addr_len);
 }
 
-/* On bonding slaves other than the currently active slave, suppress
+/* On bonding ports other than the currently active port, suppress
  * duplicates except for alb non-mcast/bcast.
  */
 static bool bond_should_deliver_exact_match(struct sk_buff *skb,
-					    struct slave *slave,
+					    struct bond_port *port,
 					    struct bonding *bond)
 {
-	if (bond_is_slave_inactive(slave)) {
+	if (bond_is_port_inactive(port)) {
 		if (BOND_MODE(bond) == BOND_MODE_ALB &&
 		    skb->pkt_type != PACKET_BROADCAST &&
 		    skb->pkt_type != PACKET_MULTICAST)
@@ -1341,10 +1353,10 @@ static bool bond_should_deliver_exact_match(struct sk_buff *skb,
 static rx_handler_result_t bond_handle_frame(struct sk_buff **pskb)
 {
 	struct sk_buff *skb = *pskb;
-	struct slave *slave;
+	struct bond_port *port;
 	struct bonding *bond;
 	int (*recv_probe)(const struct sk_buff *, struct bonding *,
-			  struct slave *);
+			  struct bond_port *);
 	int ret = RX_HANDLER_ANOTHER;
 
 	skb = skb_share_check(skb, GFP_ATOMIC);
@@ -1353,12 +1365,12 @@ static rx_handler_result_t bond_handle_frame(struct sk_buff **pskb)
 
 	*pskb = skb;
 
-	slave = bond_slave_get_rcu(skb->dev);
-	bond = slave->bond;
+	port = bond_port_get_rcu(skb->dev);
+	bond = port->bond;
 
 	recv_probe = READ_ONCE(bond->recv_probe);
 	if (recv_probe) {
-		ret = recv_probe(skb, bond, slave);
+		ret = recv_probe(skb, bond, port);
 		if (ret == RX_HANDLER_CONSUMED) {
 			consume_skb(skb);
 			return ret;
@@ -1369,14 +1381,14 @@ static rx_handler_result_t bond_handle_frame(struct sk_buff **pskb)
 	 * For packets determined by bond_should_deliver_exact_match() call to
 	 * be suppressed we want to make an exception for link-local packets.
 	 * This is necessary for e.g. LLDP daemons to be able to monitor
-	 * inactive slave links without being forced to bind to them
+	 * inactive port links without being forced to bind to them
 	 * explicitly.
 	 *
-	 * At the same time, packets that are passed to the bonding bond
+	 * At the same time, packets that are passed to the bonding dev
 	 * (including link-local ones) can have their originating interface
 	 * determined via PACKET_ORIGDEV socket option.
 	 */
-	if (bond_should_deliver_exact_match(skb, slave, bond)) {
+	if (bond_should_deliver_exact_match(skb, port, bond)) {
 		if (is_link_local_ether_addr(eth_hdr(skb)->h_dest))
 			return RX_HANDLER_PASS;
 		return RX_HANDLER_EXACT;
@@ -1439,7 +1451,7 @@ static enum netdev_lag_hash bond_lag_hash_type(struct bonding *bond,
 	}
 }
 
-static int bond_upper_dev_link(struct bonding *bond, struct slave *slave,
+static int bond_upper_dev_link(struct bonding *bond, struct bond_port *port,
 			       struct netlink_ext_ack *extack)
 {
 	struct netdev_lag_upper_info lag_upper_info;
@@ -1449,172 +1461,172 @@ static int bond_upper_dev_link(struct bonding *bond, struct slave *slave,
 	lag_upper_info.tx_type = type;
 	lag_upper_info.hash_type = bond_lag_hash_type(bond, type);
 
-	return netdev_master_upper_dev_link(slave->dev, bond->dev, slave,
+	return netdev_master_upper_dev_link(port->dev, bond->dev, port,
 					    &lag_upper_info, extack);
 }
 
-static void bond_upper_dev_unlink(struct bonding *bond, struct slave *slave)
+static void bond_upper_dev_unlink(struct bonding *bond, struct bond_port *port)
 {
-	netdev_upper_dev_unlink(slave->dev, bond->dev);
-	slave->dev->flags &= ~IFF_SLAVE;
+	netdev_upper_dev_unlink(port->dev, bond->dev);
+	port->dev->flags &= ~IFF_SLAVE;
 }
 
-static struct slave *bond_alloc_slave(struct bonding *bond)
+static struct bond_port *bond_alloc_port(struct bonding *bond)
 {
-	struct slave *slave = NULL;
+	struct bond_port *port = NULL;
 
-	slave = kzalloc(sizeof(*slave), GFP_KERNEL);
-	if (!slave)
+	port = kzalloc(sizeof(*port), GFP_KERNEL);
+	if (!port)
 		return NULL;
 
 	if (BOND_MODE(bond) == BOND_MODE_8023AD) {
-		SLAVE_AD_INFO(slave) = kzalloc(sizeof(struct ad_slave_info),
-					       GFP_KERNEL);
-		if (!SLAVE_AD_INFO(slave)) {
-			kfree(slave);
+		PORT_AD_INFO(port) = kzalloc(sizeof(struct ad_bond_port_info),
+					     GFP_KERNEL);
+		if (!PORT_AD_INFO(port)) {
+			kfree(port);
 			return NULL;
 		}
 	}
-	INIT_DELAYED_WORK(&slave->notify_work, bond_netdev_notify_work);
+	INIT_DELAYED_WORK(&port->notify_work, bond_netdev_notify_work);
 
-	return slave;
+	return port;
 }
 
-static void bond_free_slave(struct slave *slave)
+static void bond_free_port(struct bond_port *port)
 {
-	struct bonding *bond = bond_get_bond_by_slave(slave);
+	struct bonding *bond = bond_get_bond_by_port(port);
 
-	cancel_delayed_work_sync(&slave->notify_work);
+	cancel_delayed_work_sync(&port->notify_work);
 	if (BOND_MODE(bond) == BOND_MODE_8023AD)
-		kfree(SLAVE_AD_INFO(slave));
+		kfree(PORT_AD_INFO(port));
 
-	kfree(slave);
+	kfree(port);
 }
 
 static void bond_fill_ifbond(struct bonding *bond, struct ifbond *info)
 {
 	info->bond_mode = BOND_MODE(bond);
 	info->miimon = bond->params.miimon;
-	info->num_slaves = bond->slave_cnt;
+	info->num_slaves = bond->port_cnt;
 }
 
-static void bond_fill_ifslave(struct slave *slave, struct ifslave *info)
+static void bond_fill_ifslave(struct bond_port *port, struct ifslave *info)
 {
-	strcpy(info->slave_name, slave->dev->name);
-	info->link = slave->link;
-	info->state = bond_slave_state(slave);
-	info->link_failure_count = slave->link_failure_count;
+	strcpy(info->slave_name, port->dev->name);
+	info->link = port->link;
+	info->state = bond_port_state(port);
+	info->link_failure_count = port->link_failure_count;
 }
 
 static void bond_netdev_notify_work(struct work_struct *_work)
 {
-	struct slave *slave = container_of(_work, struct slave,
+	struct bond_port *port = container_of(_work, struct bond_port,
 					   notify_work.work);
 
 	if (rtnl_trylock()) {
 		struct netdev_bonding_info binfo;
 
-		bond_fill_ifslave(slave, &binfo.slave);
-		bond_fill_ifbond(slave->bond, &binfo.bond);
-		netdev_bonding_info_change(slave->dev, &binfo);
+		bond_fill_ifslave(port, &binfo.port);
+		bond_fill_ifbond(port->bond, &binfo.bond);
+		netdev_bonding_info_change(port->dev, &binfo);
 		rtnl_unlock();
 	} else {
-		queue_delayed_work(slave->bond->wq, &slave->notify_work, 1);
+		queue_delayed_work(port->bond->wq, &port->notify_work, 1);
 	}
 }
 
-void bond_queue_slave_event(struct slave *slave)
+void bond_queue_port_event(struct bond_port *port)
 {
-	queue_delayed_work(slave->bond->wq, &slave->notify_work, 0);
+	queue_delayed_work(port->bond->wq, &port->notify_work, 0);
 }
 
-void bond_lower_state_changed(struct slave *slave)
+void bond_lower_state_changed(struct bond_port *port)
 {
 	struct netdev_lag_lower_state_info info;
 
-	info.link_up = slave->link == BOND_LINK_UP ||
-		       slave->link == BOND_LINK_FAIL;
-	info.tx_enabled = bond_is_active_slave(slave);
-	netdev_lower_state_changed(slave->dev, &info);
+	info.link_up = port->link == BOND_LINK_UP ||
+		       port->link == BOND_LINK_FAIL;
+	info.tx_enabled = bond_is_active_port(port);
+	netdev_lower_state_changed(port->dev, &info);
 }
 
-/* enslave device <slave> to bond device <bond> */
-int bond_enslave(struct net_device *bond_dev, struct net_device *slave_dev,
+/* connect device <port> to bond device <bond> */
+int bond_connect(struct net_device *bond_dev, struct net_device *port_dev,
 		 struct netlink_ext_ack *extack)
 {
 	struct bonding *bond = netdev_priv(bond_dev);
-	const struct net_device_ops *slave_ops = slave_dev->netdev_ops;
-	struct slave *new_slave = NULL, *prev_slave;
+	const struct net_device_ops *port_ops = port_dev->netdev_ops;
+	struct bond_port *new_port = NULL, *prev_port;
 	struct sockaddr_storage ss;
 	int link_reporting;
 	int res = 0, i;
 
 	if (!bond->params.use_carrier &&
-	    slave_dev->ethtool_ops->get_link == NULL &&
-	    slave_ops->ndo_do_ioctl == NULL) {
-		slave_warn(bond_dev, slave_dev, "no link monitoring support\n");
+	    port_dev->ethtool_ops->get_link == NULL &&
+	    port_ops->ndo_do_ioctl == NULL) {
+		port_warn(bond_dev, port_dev, "no link monitoring support\n");
 	}
 
 	/* already in-use? */
-	if (netdev_is_rx_handler_busy(slave_dev)) {
-		NL_SET_ERR_MSG(extack, "Device is in use and cannot be enslaved");
-		slave_err(bond_dev, slave_dev,
-			  "Error: Device is in use and cannot be enslaved\n");
+	if (netdev_is_rx_handler_busy(port_dev)) {
+		NL_SET_ERR_MSG(extack, "Device is in use and cannot be connected");
+		port_err(bond_dev, port_dev,
+			 "Error: Device is in use and cannot be connected\n");
 		return -EBUSY;
 	}
 
-	if (bond_dev == slave_dev) {
-		NL_SET_ERR_MSG(extack, "Cannot enslave bond to itself.");
-		netdev_err(bond_dev, "cannot enslave bond to itself.\n");
+	if (bond_dev == port_dev) {
+		NL_SET_ERR_MSG(extack, "Cannot connect bond to itself.");
+		netdev_err(bond_dev, "cannot connect bond to itself.\n");
 		return -EPERM;
 	}
 
 	/* vlan challenged mutual exclusion */
 	/* no need to lock since we're protected by rtnl_lock */
-	if (slave_dev->features & NETIF_F_VLAN_CHALLENGED) {
-		slave_dbg(bond_dev, slave_dev, "is NETIF_F_VLAN_CHALLENGED\n");
+	if (port_dev->features & NETIF_F_VLAN_CHALLENGED) {
+		port_dbg(bond_dev, port_dev, "is NETIF_F_VLAN_CHALLENGED\n");
 		if (vlan_uses_dev(bond_dev)) {
-			NL_SET_ERR_MSG(extack, "Can not enslave VLAN challenged device to VLAN enabled bond");
-			slave_err(bond_dev, slave_dev, "Error: cannot enslave VLAN challenged slave on VLAN enabled bond\n");
+			NL_SET_ERR_MSG(extack, "Can not connect VLAN challenged device to VLAN enabled bond");
+			port_err(bond_dev, port_dev, "Error: cannot connect VLAN challenged port on VLAN enabled bond\n");
 			return -EPERM;
 		} else {
-			slave_warn(bond_dev, slave_dev, "enslaved VLAN challenged slave. Adding VLANs will be blocked as long as it is part of bond.\n");
+			port_warn(bond_dev, port_dev, "connected VLAN challenged port. Adding VLANs will be blocked as long as it is part of bond.\n");
 		}
 	} else {
-		slave_dbg(bond_dev, slave_dev, "is !NETIF_F_VLAN_CHALLENGED\n");
+		port_dbg(bond_dev, port_dev, "is !NETIF_F_VLAN_CHALLENGED\n");
 	}
 
-	if (slave_dev->features & NETIF_F_HW_ESP)
-		slave_dbg(bond_dev, slave_dev, "is esp-hw-offload capable\n");
+	if (port_dev->features & NETIF_F_HW_ESP)
+		port_dbg(bond_dev, port_dev, "is esp-hw-offload capable\n");
 
 	/* Old ifenslave binaries are no longer supported.  These can
-	 * be identified with moderate accuracy by the state of the slave:
+	 * be identified with moderate accuracy by the state of the port:
 	 * the current ifenslave will set the interface down prior to
-	 * enslaving it; the old ifenslave will not.
+	 * connecting it; the old ifenslave will not.
 	 */
-	if (slave_dev->flags & IFF_UP) {
-		NL_SET_ERR_MSG(extack, "Device can not be enslaved while up");
-		slave_err(bond_dev, slave_dev, "slave is up - this may be due to an out of date ifenslave\n");
+	if (port_dev->flags & IFF_UP) {
+		NL_SET_ERR_MSG(extack, "Device can not be connected while up");
+		port_err(bond_dev, port_dev, "port is up - this may be due to an out of date ifenslave\n");
 		return -EPERM;
 	}
 
-	/* set bonding device ether type by slave - bonding netdevices are
-	 * created with ether_setup, so when the slave type is not ARPHRD_ETHER
+	/* set bonding device ether type by port - bonding netdevices are
+	 * created with ether_setup, so when the port type is not ARPHRD_ETHER
 	 * there is a need to override some of the type dependent attribs/funcs.
 	 *
-	 * bond ether type mutual exclusion - don't allow slaves of dissimilar
+	 * bond ether type mutual exclusion - don't allow ports of dissimilar
 	 * ether type (eg ARPHRD_ETHER and ARPHRD_INFINIBAND) share the same bond
 	 */
-	if (!bond_has_slaves(bond)) {
-		if (bond_dev->type != slave_dev->type) {
-			slave_dbg(bond_dev, slave_dev, "change device type from %d to %d\n",
-				  bond_dev->type, slave_dev->type);
+	if (!bond_has_ports(bond)) {
+		if (bond_dev->type != port_dev->type) {
+			port_dbg(bond_dev, port_dev, "change device type from %d to %d\n",
+				 bond_dev->type, port_dev->type);
 
 			res = call_netdevice_notifiers(NETDEV_PRE_TYPE_CHANGE,
 						       bond_dev);
 			res = notifier_to_errno(res);
 			if (res) {
-				slave_err(bond_dev, slave_dev, "refused to change device type\n");
+				port_err(bond_dev, port_dev, "refused to change device type\n");
 				return -EBUSY;
 			}
 
@@ -1622,8 +1634,8 @@ int bond_enslave(struct net_device *bond_dev, struct net_device *slave_dev,
 			dev_uc_flush(bond_dev);
 			dev_mc_flush(bond_dev);
 
-			if (slave_dev->type != ARPHRD_ETHER)
-				bond_setup_by_slave(bond_dev, slave_dev);
+			if (port_dev->type != ARPHRD_ETHER)
+				bond_setup_by_port(bond_dev, port_dev);
 			else {
 				ether_setup(bond_dev);
 				bond_dev->priv_flags &= ~IFF_TX_SKB_SHARING;
@@ -1632,139 +1644,139 @@ int bond_enslave(struct net_device *bond_dev, struct net_device *slave_dev,
 			call_netdevice_notifiers(NETDEV_POST_TYPE_CHANGE,
 						 bond_dev);
 		}
-	} else if (bond_dev->type != slave_dev->type) {
-		NL_SET_ERR_MSG(extack, "Device type is different from other slaves");
-		slave_err(bond_dev, slave_dev, "ether type (%d) is different from other slaves (%d), can not enslave it\n",
-			  slave_dev->type, bond_dev->type);
+	} else if (bond_dev->type != port_dev->type) {
+		NL_SET_ERR_MSG(extack, "Device type is different from other ports");
+		port_err(bond_dev, port_dev, "ether type (%d) is different from other ports (%d), can not connect it\n",
+			 port_dev->type, bond_dev->type);
 		return -EINVAL;
 	}
 
-	if (slave_dev->type == ARPHRD_INFINIBAND &&
+	if (port_dev->type == ARPHRD_INFINIBAND &&
 	    BOND_MODE(bond) != BOND_MODE_ACTIVEBACKUP) {
-		NL_SET_ERR_MSG(extack, "Only active-backup mode is supported for infiniband slaves");
-		slave_warn(bond_dev, slave_dev, "Type (%d) supports only active-backup mode\n",
-			   slave_dev->type);
+		NL_SET_ERR_MSG(extack, "Only active-backup mode is supported for infiniband ports");
+		port_warn(bond_dev, port_dev, "Type (%d) supports only active-backup mode\n",
+			  port_dev->type);
 		res = -EOPNOTSUPP;
 		goto err_undo_flags;
 	}
 
-	if (!slave_ops->ndo_set_mac_address ||
-	    slave_dev->type == ARPHRD_INFINIBAND) {
-		slave_warn(bond_dev, slave_dev, "The slave device specified does not support setting the MAC address\n");
+	if (!port_ops->ndo_set_mac_address ||
+	    port_dev->type == ARPHRD_INFINIBAND) {
+		port_warn(bond_dev, port_dev, "The port device specified does not support setting the MAC address\n");
 		if (BOND_MODE(bond) == BOND_MODE_ACTIVEBACKUP &&
 		    bond->params.fail_over_mac != BOND_FOM_ACTIVE) {
-			if (!bond_has_slaves(bond)) {
+			if (!bond_has_ports(bond)) {
 				bond->params.fail_over_mac = BOND_FOM_ACTIVE;
-				slave_warn(bond_dev, slave_dev, "Setting fail_over_mac to active for active-backup mode\n");
+				port_warn(bond_dev, port_dev, "Setting fail_over_mac to active for active-backup mode\n");
 			} else {
-				NL_SET_ERR_MSG(extack, "Slave device does not support setting the MAC address, but fail_over_mac is not set to active");
-				slave_err(bond_dev, slave_dev, "The slave device specified does not support setting the MAC address, but fail_over_mac is not set to active\n");
+				NL_SET_ERR_MSG(extack, "Port device does not support setting the MAC address, but fail_over_mac is not set to active");
+				port_err(bond_dev, port_dev, "The port device specified does not support setting the MAC address, but fail_over_mac is not set to active\n");
 				res = -EOPNOTSUPP;
 				goto err_undo_flags;
 			}
 		}
 	}
 
-	call_netdevice_notifiers(NETDEV_JOIN, slave_dev);
+	call_netdevice_notifiers(NETDEV_JOIN, port_dev);
 
-	/* If this is the first slave, then we need to set the bond's hardware
-	 * address to be the same as the slave's.
+	/* If this is the first port, then we need to set the bond's hardware
+	 * address to be the same as the port's.
 	 */
-	if (!bond_has_slaves(bond) &&
+	if (!bond_has_ports(bond) &&
 	    bond->dev->addr_assign_type == NET_ADDR_RANDOM) {
-		res = bond_set_dev_addr(bond->dev, slave_dev);
+		res = bond_set_dev_addr(bond->dev, port_dev);
 		if (res)
 			goto err_undo_flags;
 	}
 
-	new_slave = bond_alloc_slave(bond);
-	if (!new_slave) {
+	new_port = bond_alloc_port(bond);
+	if (!new_port) {
 		res = -ENOMEM;
 		goto err_undo_flags;
 	}
 
-	new_slave->bond = bond;
-	new_slave->dev = slave_dev;
-	/* Set the new_slave's queue_id to be zero.  Queue ID mapping
+	new_port->bond = bond;
+	new_port->dev = port_dev;
+	/* Set the new_port's queue_id to be zero.  Queue ID mapping
 	 * is set via sysfs or module option if desired.
 	 */
-	new_slave->queue_id = 0;
+	new_port->queue_id = 0;
 
-	/* Save slave's original mtu and then set it to match the bond */
-	new_slave->original_mtu = slave_dev->mtu;
-	res = dev_set_mtu(slave_dev, bond->dev->mtu);
+	/* Save port's original mtu and then set it to match the bond */
+	new_port->original_mtu = port_dev->mtu;
+	res = dev_set_mtu(port_dev, bond->dev->mtu);
 	if (res) {
-		slave_err(bond_dev, slave_dev, "Error %d calling dev_set_mtu\n", res);
+		port_err(bond_dev, port_dev, "Error %d calling dev_set_mtu\n", res);
 		goto err_free;
 	}
 
-	/* Save slave's original ("permanent") mac address for modes
+	/* Save port's original ("permanent") mac address for modes
 	 * that need it, and for restoring it upon release, and then
 	 * set it to the bond's address
 	 */
-	bond_hw_addr_copy(new_slave->perm_hwaddr, slave_dev->dev_addr,
-			  slave_dev->addr_len);
+	bond_hw_addr_copy(new_port->perm_hwaddr, port_dev->dev_addr,
+			  port_dev->addr_len);
 
 	if (!bond->params.fail_over_mac ||
 	    BOND_MODE(bond) != BOND_MODE_ACTIVEBACKUP) {
-		/* Set slave to bond's mac address.  The application already
-		 * set the bond's mac address to that of the first slave
+		/* Set port to bond's mac address.  The application already
+		 * set the bond's mac address to that of the first port
 		 */
 		memcpy(ss.__data, bond_dev->dev_addr, bond_dev->addr_len);
-		ss.ss_family = slave_dev->type;
-		res = dev_set_mac_address(slave_dev, (struct sockaddr *)&ss,
+		ss.ss_family = port_dev->type;
+		res = dev_set_mac_address(port_dev, (struct sockaddr *)&ss,
 					  extack);
 		if (res) {
-			slave_err(bond_dev, slave_dev, "Error %d calling set_mac_address\n", res);
+			port_err(bond_dev, port_dev, "Error %d calling set_mac_address\n", res);
 			goto err_restore_mtu;
 		}
 	}
 
-	/* set slave flag before open to prevent IPv6 addrconf */
-	slave_dev->flags |= IFF_SLAVE;
+	/* set port flag before open to prevent IPv6 addrconf */
+	port_dev->flags |= IFF_SLAVE;
 
-	/* open the slave since the application closed it */
-	res = dev_open(slave_dev, extack);
+	/* open the port since the application closed it */
+	res = dev_open(port_dev, extack);
 	if (res) {
-		slave_err(bond_dev, slave_dev, "Opening slave failed\n");
+		port_err(bond_dev, port_dev, "Opening port failed\n");
 		goto err_restore_mac;
 	}
 
-	slave_dev->priv_flags |= IFF_BONDING;
-	/* initialize slave stats */
-	dev_get_stats(new_slave->dev, &new_slave->slave_stats);
+	port_dev->priv_flags |= IFF_BONDING;
+	/* initialize port stats */
+	dev_get_stats(new_port->dev, &new_port->port_stats);
 
 	if (bond_is_lb(bond)) {
-		/* bond_alb_init_slave() must be called before all other stages since
+		/* bond_alb_init_port() must be called before all other stages since
 		 * it might fail and we do not want to have to undo everything
 		 */
-		res = bond_alb_init_slave(bond, new_slave);
+		res = bond_alb_init_port(bond, new_port);
 		if (res)
 			goto err_close;
 	}
 
-	res = vlan_vids_add_by_dev(slave_dev, bond_dev);
+	res = vlan_vids_add_by_dev(port_dev, bond_dev);
 	if (res) {
-		slave_err(bond_dev, slave_dev, "Couldn't add bond vlan ids\n");
+		port_err(bond_dev, port_dev, "Couldn't add bond vlan ids\n");
 		goto err_close;
 	}
 
-	prev_slave = bond_last_slave(bond);
+	prev_port = bond_last_port(bond);
 
-	new_slave->delay = 0;
-	new_slave->link_failure_count = 0;
+	new_port->delay = 0;
+	new_port->link_failure_count = 0;
 
-	if (bond_update_speed_duplex(new_slave) &&
+	if (bond_update_speed_duplex(new_port) &&
 	    bond_needs_speed_duplex(bond))
-		new_slave->link = BOND_LINK_DOWN;
+		new_port->link = BOND_LINK_DOWN;
 
-	new_slave->last_rx = jiffies -
+	new_port->last_rx = jiffies -
 		(msecs_to_jiffies(bond->params.arp_interval) + 1);
 	for (i = 0; i < BOND_MAX_ARP_TARGETS; i++)
-		new_slave->target_last_arp_rx[i] = new_slave->last_rx;
+		new_port->target_last_arp_rx[i] = new_port->last_rx;
 
 	if (bond->params.miimon && !bond->params.use_carrier) {
-		link_reporting = bond_check_dev_link(bond, slave_dev, 1);
+		link_reporting = bond_check_dev_link(bond, port_dev, 1);
 
 		if ((link_reporting == -1) && !bond->params.arp_interval) {
 			/* miimon is set but a bonded network driver
@@ -1775,106 +1787,104 @@ int bond_enslave(struct net_device *bond_dev, struct net_device *slave_dev,
 			 * supported); thus, we don't need to change
 			 * the messages for netif_carrier.
 			 */
-			slave_warn(bond_dev, slave_dev, "MII and ETHTOOL support not available for slave, and arp_interval/arp_ip_target module parameters not specified, thus bonding will not detect link failures! see bonding.txt for details\n");
+			port_warn(bond_dev, port_dev, "MII and ETHTOOL support not available for port, and arp_interval/arp_ip_target module parameters not specified, thus bonding will not detect link failures! see bonding.txt for details\n");
 		} else if (link_reporting == -1) {
 			/* unable get link status using mii/ethtool */
-			slave_warn(bond_dev, slave_dev, "can't get link status from slave; the network driver associated with this interface does not support MII or ETHTOOL link status reporting, thus miimon has no effect on this interface\n");
+			port_warn(bond_dev, port_dev, "can't get link status from port; the network driver associated with this interface does not support MII or ETHTOOL link status reporting, thus miimon has no effect on this interface\n");
 		}
 	}
 
 	/* check for initial state */
-	new_slave->link = BOND_LINK_NOCHANGE;
+	new_port->link = BOND_LINK_NOCHANGE;
 	if (bond->params.miimon) {
-		if (bond_check_dev_link(bond, slave_dev, 0) == BMSR_LSTATUS) {
+		if (bond_check_dev_link(bond, port_dev, 0) == BMSR_LSTATUS) {
 			if (bond->params.updelay) {
-				bond_set_slave_link_state(new_slave,
-							  BOND_LINK_BACK,
-							  BOND_SLAVE_NOTIFY_NOW);
-				new_slave->delay = bond->params.updelay;
+				bond_set_port_link_state(new_port,
+							 BOND_LINK_BACK,
+							 BOND_PORT_NOTIFY_NOW);
+				new_port->delay = bond->params.updelay;
 			} else {
-				bond_set_slave_link_state(new_slave,
-							  BOND_LINK_UP,
-							  BOND_SLAVE_NOTIFY_NOW);
+				bond_set_port_link_state(new_port, BOND_LINK_UP,
+							 BOND_PORT_NOTIFY_NOW);
 			}
 		} else {
-			bond_set_slave_link_state(new_slave, BOND_LINK_DOWN,
-						  BOND_SLAVE_NOTIFY_NOW);
+			bond_set_port_link_state(new_port, BOND_LINK_DOWN,
+						 BOND_PORT_NOTIFY_NOW);
 		}
 	} else if (bond->params.arp_interval) {
-		bond_set_slave_link_state(new_slave,
-					  (netif_carrier_ok(slave_dev) ?
-					  BOND_LINK_UP : BOND_LINK_DOWN),
-					  BOND_SLAVE_NOTIFY_NOW);
+		bond_set_port_link_state(new_port,
+					 (netif_carrier_ok(port_dev) ?
+					 BOND_LINK_UP : BOND_LINK_DOWN),
+					 BOND_PORT_NOTIFY_NOW);
 	} else {
-		bond_set_slave_link_state(new_slave, BOND_LINK_UP,
-					  BOND_SLAVE_NOTIFY_NOW);
+		bond_set_port_link_state(new_port, BOND_LINK_UP,
+					 BOND_PORT_NOTIFY_NOW);
 	}
 
-	if (new_slave->link != BOND_LINK_DOWN)
-		new_slave->last_link_up = jiffies;
-	slave_dbg(bond_dev, slave_dev, "Initial state of slave is BOND_LINK_%s\n",
-		  new_slave->link == BOND_LINK_DOWN ? "DOWN" :
-		  (new_slave->link == BOND_LINK_UP ? "UP" : "BACK"));
+	if (new_port->link != BOND_LINK_DOWN)
+		new_port->last_link_up = jiffies;
+	port_dbg(bond_dev, port_dev, "Initial state of port is BOND_LINK_%s\n",
+		 new_port->link == BOND_LINK_DOWN ? "DOWN" :
+		 (new_port->link == BOND_LINK_UP ? "UP" : "BACK"));
 
 	if (bond_uses_primary(bond) && bond->params.primary[0]) {
-		/* if there is a primary slave, remember it */
-		if (strcmp(bond->params.primary, new_slave->dev->name) == 0) {
-			rcu_assign_pointer(bond->primary_slave, new_slave);
+		/* if there is a primary port, remember it */
+		if (strcmp(bond->params.primary, new_port->dev->name) == 0) {
+			rcu_assign_pointer(bond->primary_port, new_port);
 			bond->force_primary = true;
 		}
 	}
 
 	switch (BOND_MODE(bond)) {
 	case BOND_MODE_ACTIVEBACKUP:
-		bond_set_slave_inactive_flags(new_slave,
-					      BOND_SLAVE_NOTIFY_NOW);
+		bond_set_port_inactive_flags(new_port, BOND_PORT_NOTIFY_NOW);
 		break;
 	case BOND_MODE_8023AD:
 		/* in 802.3ad mode, the internal mechanism
-		 * will activate the slaves in the selected
+		 * will activate the ports in the selected
 		 * aggregator
 		 */
-		bond_set_slave_inactive_flags(new_slave, BOND_SLAVE_NOTIFY_NOW);
-		/* if this is the first slave */
-		if (!prev_slave) {
-			SLAVE_AD_INFO(new_slave)->id = 1;
+		bond_set_port_inactive_flags(new_port, BOND_PORT_NOTIFY_NOW);
+		/* if this is the first port */
+		if (!prev_port) {
+			PORT_AD_INFO(new_port)->id = 1;
 			/* Initialize AD with the number of times that the AD timer is called in 1 second
 			 * can be called only after the mac address of the bond is set
 			 */
 			bond_3ad_initialize(bond, 1000/AD_TIMER_INTERVAL);
 		} else {
-			SLAVE_AD_INFO(new_slave)->id =
-				SLAVE_AD_INFO(prev_slave)->id + 1;
+			PORT_AD_INFO(new_port)->id =
+				PORT_AD_INFO(prev_port)->id + 1;
 		}
 
-		bond_3ad_bind_slave(new_slave);
+		bond_3ad_bind_port(new_port);
 		break;
 	case BOND_MODE_TLB:
 	case BOND_MODE_ALB:
-		bond_set_active_slave(new_slave);
-		bond_set_slave_inactive_flags(new_slave, BOND_SLAVE_NOTIFY_NOW);
+		bond_set_active_port(new_port);
+		bond_set_port_inactive_flags(new_port, BOND_PORT_NOTIFY_NOW);
 		break;
 	default:
-		slave_dbg(bond_dev, slave_dev, "This slave is always active in trunk mode\n");
+		port_dbg(bond_dev, port_dev, "This port is always active in trunk mode\n");
 
 		/* always active in trunk mode */
-		bond_set_active_slave(new_slave);
+		bond_set_active_port(new_port);
 
-		/* In trunking mode there is little meaning to curr_active_slave
+		/* In trunking mode there is little meaning to curr_active_port
 		 * anyway (it holds no special properties of the bond device),
 		 * so we can change it without calling change_active_interface()
 		 */
-		if (!rcu_access_pointer(bond->curr_active_slave) &&
-		    new_slave->link == BOND_LINK_UP)
-			rcu_assign_pointer(bond->curr_active_slave, new_slave);
+		if (!rcu_access_pointer(bond->curr_active_port) &&
+		    new_port->link == BOND_LINK_UP)
+			rcu_assign_pointer(bond->curr_active_port, new_port);
 
 		break;
 	} /* switch(bond_mode) */
 
 #ifdef CONFIG_NET_POLL_CONTROLLER
 	if (bond->dev->npinfo) {
-		if (slave_enable_netpoll(new_slave)) {
-			slave_info(bond_dev, slave_dev, "bond_dev is using netpoll, but new slave device does not support netpoll\n");
+		if (bond_port_enable_netpoll(new_port)) {
+			port_info(bond_dev, port_dev, "bond_dev is using netpoll, but new port device does not support netpoll\n");
 			res = -EBUSY;
 			goto err_detach;
 		}
@@ -1882,137 +1892,137 @@ int bond_enslave(struct net_device *bond_dev, struct net_device *slave_dev,
 #endif
 
 	if (!(bond_dev->features & NETIF_F_LRO))
-		dev_disable_lro(slave_dev);
+		dev_disable_lro(port_dev);
 
-	res = netdev_rx_handler_register(slave_dev, bond_handle_frame,
-					 new_slave);
+	res = netdev_rx_handler_register(port_dev, bond_handle_frame,
+					 new_port);
 	if (res) {
-		slave_dbg(bond_dev, slave_dev, "Error %d calling netdev_rx_handler_register\n", res);
+		port_dbg(bond_dev, port_dev, "Error %d calling netdev_rx_handler_register\n", res);
 		goto err_detach;
 	}
 
-	res = bond_upper_dev_link(bond, new_slave, extack);
+	res = bond_upper_dev_link(bond, new_port, extack);
 	if (res) {
-		slave_dbg(bond_dev, slave_dev, "Error %d calling bond_upper_dev_link\n", res);
+		port_dbg(bond_dev, port_dev, "Error %d calling bond_upper_dev_link\n", res);
 		goto err_unregister;
 	}
 
-	res = bond_sysfs_slave_add(new_slave);
+	res = bond_sysfs_port_add(new_port);
 	if (res) {
-		slave_dbg(bond_dev, slave_dev, "Error %d calling bond_sysfs_slave_add\n", res);
+		port_dbg(bond_dev, port_dev, "Error %d calling bond_sysfs_port_add\n", res);
 		goto err_upper_unlink;
 	}
 
 	/* If the mode uses primary, then the following is handled by
-	 * bond_change_active_slave().
+	 * bond_change_active_port().
 	 */
 	if (!bond_uses_primary(bond)) {
-		/* set promiscuity level to new slave */
+		/* set promiscuity level to new port */
 		if (bond_dev->flags & IFF_PROMISC) {
-			res = dev_set_promiscuity(slave_dev, 1);
+			res = dev_set_promiscuity(port_dev, 1);
 			if (res)
 				goto err_sysfs_del;
 		}
 
-		/* set allmulti level to new slave */
+		/* set allmulti level to new port */
 		if (bond_dev->flags & IFF_ALLMULTI) {
-			res = dev_set_allmulti(slave_dev, 1);
+			res = dev_set_allmulti(port_dev, 1);
 			if (res) {
 				if (bond_dev->flags & IFF_PROMISC)
-					dev_set_promiscuity(slave_dev, -1);
+					dev_set_promiscuity(port_dev, -1);
 				goto err_sysfs_del;
 			}
 		}
 
 		netif_addr_lock_bh(bond_dev);
-		dev_mc_sync_multiple(slave_dev, bond_dev);
-		dev_uc_sync_multiple(slave_dev, bond_dev);
+		dev_mc_sync_multiple(port_dev, bond_dev);
+		dev_uc_sync_multiple(port_dev, bond_dev);
 		netif_addr_unlock_bh(bond_dev);
 
 		if (BOND_MODE(bond) == BOND_MODE_8023AD) {
 			/* add lacpdu mc addr to mc list */
 			u8 lacpdu_multicast[ETH_ALEN] = MULTICAST_LACPDU_ADDR;
 
-			dev_mc_add(slave_dev, lacpdu_multicast);
+			dev_mc_add(port_dev, lacpdu_multicast);
 		}
 	}
 
-	bond->slave_cnt++;
+	bond->port_cnt++;
 	bond_compute_features(bond);
 	bond_set_carrier(bond);
 
 	if (bond_uses_primary(bond)) {
 		block_netpoll_tx();
-		bond_select_active_slave(bond);
+		bond_select_active_port(bond);
 		unblock_netpoll_tx();
 	}
 
 	if (bond_mode_can_use_xmit_hash(bond))
-		bond_update_slave_arr(bond, NULL);
+		bond_update_port_arr(bond, NULL);
 
 
-	slave_info(bond_dev, slave_dev, "Enslaving as %s interface with %s link\n",
-		   bond_is_active_slave(new_slave) ? "an active" : "a backup",
-		   new_slave->link != BOND_LINK_DOWN ? "an up" : "a down");
+	port_info(bond_dev, port_dev, "Connecting as %s interface with %s link\n",
+		  bond_is_active_port(new_port) ? "an active" : "a backup",
+		  new_port->link != BOND_LINK_DOWN ? "an up" : "a down");
 
-	/* enslave is successful */
-	bond_queue_slave_event(new_slave);
+	/* connect is successful */
+	bond_queue_port_event(new_port);
 	return 0;
 
 /* Undo stages on error */
 err_sysfs_del:
-	bond_sysfs_slave_del(new_slave);
+	bond_sysfs_port_del(new_port);
 
 err_upper_unlink:
-	bond_upper_dev_unlink(bond, new_slave);
+	bond_upper_dev_unlink(bond, new_port);
 
 err_unregister:
-	netdev_rx_handler_unregister(slave_dev);
+	netdev_rx_handler_unregister(port_dev);
 
 err_detach:
-	vlan_vids_del_by_dev(slave_dev, bond_dev);
-	if (rcu_access_pointer(bond->primary_slave) == new_slave)
-		RCU_INIT_POINTER(bond->primary_slave, NULL);
-	if (rcu_access_pointer(bond->curr_active_slave) == new_slave) {
+	vlan_vids_del_by_dev(port_dev, bond_dev);
+	if (rcu_access_pointer(bond->primary_port) == new_port)
+		RCU_INIT_POINTER(bond->primary_port, NULL);
+	if (rcu_access_pointer(bond->curr_active_port) == new_port) {
 		block_netpoll_tx();
-		bond_change_active_slave(bond, NULL);
-		bond_select_active_slave(bond);
+		bond_change_active_port(bond, NULL);
+		bond_select_active_port(bond);
 		unblock_netpoll_tx();
 	}
-	/* either primary_slave or curr_active_slave might've changed */
+	/* either primary_port or curr_active_port might've changed */
 	synchronize_rcu();
-	slave_disable_netpoll(new_slave);
+	bond_port_disable_netpoll(new_port);
 
 err_close:
-	if (!netif_is_bond_dev(slave_dev))
-		slave_dev->priv_flags &= ~IFF_BONDING;
-	dev_close(slave_dev);
+	if (!netif_is_bond_dev(port_dev))
+		port_dev->priv_flags &= ~IFF_BONDING;
+	dev_close(port_dev);
 
 err_restore_mac:
-	slave_dev->flags &= ~IFF_SLAVE;
+	port_dev->flags &= ~IFF_SLAVE;
 	if (!bond->params.fail_over_mac ||
 	    BOND_MODE(bond) != BOND_MODE_ACTIVEBACKUP) {
 		/* XXX TODO - fom follow mode needs to change bond's
-		 * MAC if this slave's MAC is in use by the bond, or at
+		 * MAC if this port's MAC is in use by the bond, or at
 		 * least print a warning.
 		 */
-		bond_hw_addr_copy(ss.__data, new_slave->perm_hwaddr,
-				  new_slave->dev->addr_len);
-		ss.ss_family = slave_dev->type;
-		dev_set_mac_address(slave_dev, (struct sockaddr *)&ss, NULL);
+		bond_hw_addr_copy(ss.__data, new_port->perm_hwaddr,
+				  new_port->dev->addr_len);
+		ss.ss_family = port_dev->type;
+		dev_set_mac_address(port_dev, (struct sockaddr *)&ss, NULL);
 	}
 
 err_restore_mtu:
-	dev_set_mtu(slave_dev, new_slave->original_mtu);
+	dev_set_mtu(port_dev, new_port->original_mtu);
 
 err_free:
-	bond_free_slave(new_slave);
+	bond_free_port(new_port);
 
 err_undo_flags:
-	/* Enslave of first slave has failed and we need to fix bond's mac */
-	if (!bond_has_slaves(bond)) {
+	/* Connection of first port has failed and we need to fix bond's mac */
+	if (!bond_has_ports(bond)) {
 		if (ether_addr_equal_64bits(bond_dev->dev_addr,
-					    slave_dev->dev_addr))
+					    port_dev->dev_addr))
 			eth_hw_addr_random(bond_dev);
 		if (bond_dev->type != ARPHRD_ETHER) {
 			dev_close(bond_dev);
@@ -2025,113 +2035,113 @@ int bond_enslave(struct net_device *bond_dev, struct net_device *slave_dev,
 	return res;
 }
 
-/* Try to release the slave device <slave> from the bond device <bond>
- * It is legal to access curr_active_slave without a lock because all the function
+/* Try to release the port device <port> from the bond device <bond>
+ * It is legal to access curr_active_port without a lock because all the function
  * is RTNL-locked. If "all" is true it means that the function is being called
- * while destroying a bond interface and all slaves are being released.
+ * while destroying a bond interface and all ports are being released.
  *
- * The rules for slave state should be:
+ * The rules for port state should be:
  *   for Active/Backup:
  *     Active stays on all backups go down
  *   for Bonded connections:
  *     The first up interface should be left on and all others downed.
  */
 static int __bond_release_one(struct net_device *bond_dev,
-			      struct net_device *slave_dev,
+			      struct net_device *port_dev,
 			      bool all, bool unregister)
 {
 	struct bonding *bond = netdev_priv(bond_dev);
-	struct slave *slave, *oldcurrent;
+	struct bond_port *port, *oldcurrent;
 	struct sockaddr_storage ss;
 	int old_flags = bond_dev->flags;
 	netdev_features_t old_features = bond_dev->features;
 
-	/* slave is not a slave or bond is not bond of this slave */
-	if (!(slave_dev->flags & IFF_SLAVE) ||
-	    !netdev_has_upper_dev(slave_dev, bond_dev)) {
-		slave_dbg(bond_dev, slave_dev, "cannot release slave\n");
+	/* port is not a port or bond is not bond of this port */
+	if (!(port_dev->flags & IFF_SLAVE) ||
+	    !netdev_has_upper_dev(port_dev, bond_dev)) {
+		port_dbg(bond_dev, port_dev, "cannot release port\n");
 		return -EINVAL;
 	}
 
 	block_netpoll_tx();
 
-	slave = bond_get_slave_by_dev(bond, slave_dev);
-	if (!slave) {
-		/* not a slave of this bond */
-		slave_info(bond_dev, slave_dev, "interface not enslaved\n");
+	port = bond_get_port_by_dev(bond, port_dev);
+	if (!port) {
+		/* not a port of this bond */
+		port_info(bond_dev, port_dev, "interface not connected\n");
 		unblock_netpoll_tx();
 		return -EINVAL;
 	}
 
-	bond_set_slave_inactive_flags(slave, BOND_SLAVE_NOTIFY_NOW);
+	bond_set_port_inactive_flags(port, BOND_PORT_NOTIFY_NOW);
 
-	bond_sysfs_slave_del(slave);
+	bond_sysfs_port_del(port);
 
-	/* recompute stats just before removing the slave */
+	/* recompute stats just before removing the port */
 	bond_get_stats(bond->dev, &bond->bond_stats);
 
-	bond_upper_dev_unlink(bond, slave);
+	bond_upper_dev_unlink(bond, port);
 	/* unregister rx_handler early so bond_handle_frame wouldn't be called
-	 * for this slave anymore.
+	 * for this port anymore.
 	 */
-	netdev_rx_handler_unregister(slave_dev);
+	netdev_rx_handler_unregister(port_dev);
 
 	if (BOND_MODE(bond) == BOND_MODE_8023AD)
-		bond_3ad_unbind_slave(slave);
+		bond_3ad_unbind_port(port);
 
 	if (bond_mode_can_use_xmit_hash(bond))
-		bond_update_slave_arr(bond, slave);
+		bond_update_port_arr(bond, port);
 
-	slave_info(bond_dev, slave_dev, "Releasing %s interface\n",
-		    bond_is_active_slave(slave) ? "active" : "backup");
+	port_info(bond_dev, port_dev, "Releasing %s interface\n",
+		  bond_is_active_port(port) ? "active" : "backup");
 
-	oldcurrent = rcu_access_pointer(bond->curr_active_slave);
+	oldcurrent = rcu_access_pointer(bond->curr_active_port);
 
-	RCU_INIT_POINTER(bond->current_arp_slave, NULL);
+	RCU_INIT_POINTER(bond->current_arp_port, NULL);
 
 	if (!all && (!bond->params.fail_over_mac ||
 		     BOND_MODE(bond) != BOND_MODE_ACTIVEBACKUP)) {
-		if (ether_addr_equal_64bits(bond_dev->dev_addr, slave->perm_hwaddr) &&
-		    bond_has_slaves(bond))
-			slave_warn(bond_dev, slave_dev, "the permanent HWaddr of slave - %pM - is still in use by bond - set the HWaddr of slave to a different address to avoid conflicts\n",
-				   slave->perm_hwaddr);
+		if (ether_addr_equal_64bits(bond_dev->dev_addr, port->perm_hwaddr) &&
+		    bond_has_ports(bond))
+			port_warn(bond_dev, port_dev, "the permanent HWaddr of port - %pM - is still in use by bond - set the HWaddr of port to a different address to avoid conflicts\n",
+				  port->perm_hwaddr);
 	}
 
-	if (rtnl_dereference(bond->primary_slave) == slave)
-		RCU_INIT_POINTER(bond->primary_slave, NULL);
+	if (rtnl_dereference(bond->primary_port) == port)
+		RCU_INIT_POINTER(bond->primary_port, NULL);
 
-	if (oldcurrent == slave)
-		bond_change_active_slave(bond, NULL);
+	if (oldcurrent == port)
+		bond_change_active_port(bond, NULL);
 
 	if (bond_is_lb(bond)) {
-		/* Must be called only after the slave has been
-		 * detached from the list and the curr_active_slave
-		 * has been cleared (if our_slave == old_current),
-		 * but before a new active slave is selected.
+		/* Must be called only after the port has been
+		 * detached from the list and the curr_active_port
+		 * has been cleared (if our_port == old_current),
+		 * but before a new active port is selected.
 		 */
-		bond_alb_deinit_slave(bond, slave);
+		bond_alb_deinit_port(bond, port);
 	}
 
 	if (all) {
-		RCU_INIT_POINTER(bond->curr_active_slave, NULL);
-	} else if (oldcurrent == slave) {
+		RCU_INIT_POINTER(bond->curr_active_port, NULL);
+	} else if (oldcurrent == port) {
 		/* Note that we hold RTNL over this sequence, so there
-		 * is no concern that another slave add/remove event
+		 * is no concern that another port add/remove event
 		 * will interfere.
 		 */
-		bond_select_active_slave(bond);
+		bond_select_active_port(bond);
 	}
 
-	if (!bond_has_slaves(bond)) {
+	if (!bond_has_ports(bond)) {
 		bond_set_carrier(bond);
 		eth_hw_addr_random(bond_dev);
 	}
 
 	unblock_netpoll_tx();
 	synchronize_rcu();
-	bond->slave_cnt--;
+	bond->port_cnt--;
 
-	if (!bond_has_slaves(bond)) {
+	if (!bond_has_ports(bond)) {
 		call_netdevice_notifiers(NETDEV_CHANGEADDR, bond->dev);
 		call_netdevice_notifiers(NETDEV_RELEASE, bond->dev);
 	}
@@ -2139,75 +2149,75 @@ static int __bond_release_one(struct net_device *bond_dev,
 	bond_compute_features(bond);
 	if (!(bond_dev->features & NETIF_F_VLAN_CHALLENGED) &&
 	    (old_features & NETIF_F_VLAN_CHALLENGED))
-		slave_info(bond_dev, slave_dev, "last VLAN challenged slave left bond - VLAN blocking is removed\n");
+		port_info(bond_dev, port_dev, "last VLAN challenged port left bond - VLAN blocking is removed\n");
 
-	vlan_vids_del_by_dev(slave_dev, bond_dev);
+	vlan_vids_del_by_dev(port_dev, bond_dev);
 
 	/* If the mode uses primary, then this case was handled above by
-	 * bond_change_active_slave(..., NULL)
+	 * bond_change_active_port(..., NULL)
 	 */
 	if (!bond_uses_primary(bond)) {
-		/* unset promiscuity level from slave
+		/* unset promiscuity level from port
 		 * NOTE: The NETDEV_CHANGEADDR call above may change the value
 		 * of the IFF_PROMISC flag in the bond_dev, but we need the
 		 * value of that flag before that change, as that was the value
-		 * when this slave was attached, so we cache at the start of the
+		 * when this port was attached, so we cache at the start of the
 		 * function and use it here. Same goes for ALLMULTI below
 		 */
 		if (old_flags & IFF_PROMISC)
-			dev_set_promiscuity(slave_dev, -1);
+			dev_set_promiscuity(port_dev, -1);
 
-		/* unset allmulti level from slave */
+		/* unset allmulti level from port */
 		if (old_flags & IFF_ALLMULTI)
-			dev_set_allmulti(slave_dev, -1);
+			dev_set_allmulti(port_dev, -1);
 
-		bond_hw_addr_flush(bond_dev, slave_dev);
+		bond_hw_addr_flush(bond_dev, port_dev);
 	}
 
-	slave_disable_netpoll(slave);
+	bond_port_disable_netpoll(port);
 
-	/* close slave before restoring its mac address */
-	dev_close(slave_dev);
+	/* close port before restoring its mac address */
+	dev_close(port_dev);
 
 	if (bond->params.fail_over_mac != BOND_FOM_ACTIVE ||
 	    BOND_MODE(bond) != BOND_MODE_ACTIVEBACKUP) {
 		/* restore original ("permanent") mac address */
-		bond_hw_addr_copy(ss.__data, slave->perm_hwaddr,
-				  slave->dev->addr_len);
-		ss.ss_family = slave_dev->type;
-		dev_set_mac_address(slave_dev, (struct sockaddr *)&ss, NULL);
+		bond_hw_addr_copy(ss.__data, port->perm_hwaddr,
+				  port->dev->addr_len);
+		ss.ss_family = port_dev->type;
+		dev_set_mac_address(port_dev, (struct sockaddr *)&ss, NULL);
 	}
 
 	if (unregister)
-		__dev_set_mtu(slave_dev, slave->original_mtu);
+		__dev_set_mtu(port_dev, port->original_mtu);
 	else
-		dev_set_mtu(slave_dev, slave->original_mtu);
+		dev_set_mtu(port_dev, port->original_mtu);
 
-	if (!netif_is_bond_dev(slave_dev))
-		slave_dev->priv_flags &= ~IFF_BONDING;
+	if (!netif_is_bond_dev(port_dev))
+		port_dev->priv_flags &= ~IFF_BONDING;
 
-	bond_free_slave(slave);
+	bond_free_port(port);
 
 	return 0;
 }
 
 /* A wrapper used because of ndo_del_link */
-int bond_release(struct net_device *bond_dev, struct net_device *slave_dev)
+int bond_release(struct net_device *bond_dev, struct net_device *port_dev)
 {
-	return __bond_release_one(bond_dev, slave_dev, false, false);
+	return __bond_release_one(bond_dev, port_dev, false, false);
 }
 
-/* First release a slave and then destroy the bond if no more slaves are left.
+/* First release a port and then destroy the bond if no more ports are left.
  * Must be under rtnl_lock when this function is called.
  */
 static int bond_release_and_destroy(struct net_device *bond_dev,
-				    struct net_device *slave_dev)
+				    struct net_device *port_dev)
 {
 	struct bonding *bond = netdev_priv(bond_dev);
 	int ret;
 
-	ret = __bond_release_one(bond_dev, slave_dev, false, true);
-	if (ret == 0 && !bond_has_slaves(bond) &&
+	ret = __bond_release_one(bond_dev, port_dev, false, true);
+	if (ret == 0 && !bond_has_ports(bond) &&
 	    bond_dev->reg_state != NETREG_UNREGISTERING) {
 		bond_dev->priv_flags |= IFF_DISABLE_NETPOLL;
 		netdev_info(bond_dev, "Destroying bond\n");
@@ -2223,17 +2233,17 @@ static void bond_info_query(struct net_device *bond_dev, struct ifbond *info)
 	bond_fill_ifbond(bond, info);
 }
 
-static int bond_slave_info_query(struct net_device *bond_dev, struct ifslave *info)
+static int bond_port_info_query(struct net_device *bond_dev, struct ifslave *info)
 {
 	struct bonding *bond = netdev_priv(bond_dev);
 	struct list_head *iter;
 	int i = 0, res = -ENODEV;
-	struct slave *slave;
+	struct bond_port *port;
 
-	bond_for_each_slave(bond, slave, iter) {
+	bond_for_each_port(bond, port, iter) {
 		if (i++ == (int)info->slave_id) {
 			res = 0;
-			bond_fill_ifslave(slave, info);
+			bond_fill_ifslave(port, info);
 			break;
 		}
 	}
@@ -2248,90 +2258,90 @@ static int bond_miimon_inspect(struct bonding *bond)
 {
 	int link_state, commit = 0;
 	struct list_head *iter;
-	struct slave *slave;
+	struct bond_port *port;
 	bool ignore_updelay;
 
-	ignore_updelay = !rcu_dereference(bond->curr_active_slave);
+	ignore_updelay = !rcu_dereference(bond->curr_active_port);
 
-	bond_for_each_slave_rcu(bond, slave, iter) {
-		bond_propose_link_state(slave, BOND_LINK_NOCHANGE);
+	bond_for_each_port_rcu(bond, port, iter) {
+		bond_propose_link_state(port, BOND_LINK_NOCHANGE);
 
-		link_state = bond_check_dev_link(bond, slave->dev, 0);
+		link_state = bond_check_dev_link(bond, port->dev, 0);
 
-		switch (slave->link) {
+		switch (port->link) {
 		case BOND_LINK_UP:
 			if (link_state)
 				continue;
 
-			bond_propose_link_state(slave, BOND_LINK_FAIL);
+			bond_propose_link_state(port, BOND_LINK_FAIL);
 			commit++;
-			slave->delay = bond->params.downdelay;
-			if (slave->delay) {
-				slave_info(bond->dev, slave->dev, "link status down for %sinterface, disabling it in %d ms\n",
-					   (BOND_MODE(bond) ==
-					    BOND_MODE_ACTIVEBACKUP) ?
-					    (bond_is_active_slave(slave) ?
-					     "active " : "backup ") : "",
-					   bond->params.downdelay * bond->params.miimon);
+			port->delay = bond->params.downdelay;
+			if (port->delay) {
+				port_info(bond->dev, port->dev, "link status down for %sinterface, disabling it in %d ms\n",
+					  (BOND_MODE(bond) ==
+					   BOND_MODE_ACTIVEBACKUP) ?
+					   (bond_is_active_port(port) ?
+					    "active " : "backup ") : "",
+					  bond->params.downdelay * bond->params.miimon);
 			}
 			fallthrough;
 		case BOND_LINK_FAIL:
 			if (link_state) {
 				/* recovered before downdelay expired */
-				bond_propose_link_state(slave, BOND_LINK_UP);
-				slave->last_link_up = jiffies;
-				slave_info(bond->dev, slave->dev, "link status up again after %d ms\n",
-					   (bond->params.downdelay - slave->delay) *
-					   bond->params.miimon);
+				bond_propose_link_state(port, BOND_LINK_UP);
+				port->last_link_up = jiffies;
+				port_info(bond->dev, port->dev, "link status up again after %d ms\n",
+					  (bond->params.downdelay - port->delay) *
+					  bond->params.miimon);
 				commit++;
 				continue;
 			}
 
-			if (slave->delay <= 0) {
-				bond_propose_link_state(slave, BOND_LINK_DOWN);
+			if (port->delay <= 0) {
+				bond_propose_link_state(port, BOND_LINK_DOWN);
 				commit++;
 				continue;
 			}
 
-			slave->delay--;
+			port->delay--;
 			break;
 
 		case BOND_LINK_DOWN:
 			if (!link_state)
 				continue;
 
-			bond_propose_link_state(slave, BOND_LINK_BACK);
+			bond_propose_link_state(port, BOND_LINK_BACK);
 			commit++;
-			slave->delay = bond->params.updelay;
+			port->delay = bond->params.updelay;
 
-			if (slave->delay) {
-				slave_info(bond->dev, slave->dev, "link status up, enabling it in %d ms\n",
-					   ignore_updelay ? 0 :
-					   bond->params.updelay *
-					   bond->params.miimon);
+			if (port->delay) {
+				port_info(bond->dev, port->dev, "link status up, enabling it in %d ms\n",
+					  ignore_updelay ? 0 :
+					  bond->params.updelay *
+					  bond->params.miimon);
 			}
 			fallthrough;
 		case BOND_LINK_BACK:
 			if (!link_state) {
-				bond_propose_link_state(slave, BOND_LINK_DOWN);
-				slave_info(bond->dev, slave->dev, "link status down again after %d ms\n",
-					   (bond->params.updelay - slave->delay) *
-					   bond->params.miimon);
+				bond_propose_link_state(port, BOND_LINK_DOWN);
+				port_info(bond->dev, port->dev, "link status down again after %d ms\n",
+					  (bond->params.updelay - port->delay) *
+					  bond->params.miimon);
 				commit++;
 				continue;
 			}
 
 			if (ignore_updelay)
-				slave->delay = 0;
+				port->delay = 0;
 
-			if (slave->delay <= 0) {
-				bond_propose_link_state(slave, BOND_LINK_UP);
+			if (port->delay <= 0) {
+				bond_propose_link_state(port, BOND_LINK_UP);
 				commit++;
 				ignore_updelay = false;
 				continue;
 			}
 
-			slave->delay--;
+			port->delay--;
 			break;
 		}
 	}
@@ -2340,19 +2350,19 @@ static int bond_miimon_inspect(struct bonding *bond)
 }
 
 static void bond_miimon_link_change(struct bonding *bond,
-				    struct slave *slave,
+				    struct bond_port *port,
 				    char link)
 {
 	switch (BOND_MODE(bond)) {
 	case BOND_MODE_8023AD:
-		bond_3ad_handle_link_change(slave, link);
+		bond_3ad_handle_link_change(port, link);
 		break;
 	case BOND_MODE_TLB:
 	case BOND_MODE_ALB:
-		bond_alb_handle_link_change(bond, slave, link);
+		bond_alb_handle_link_change(bond, port, link);
 		break;
 	case BOND_MODE_XOR:
-		bond_update_slave_arr(bond, NULL);
+		bond_update_port_arr(bond, NULL);
 		break;
 	}
 }
@@ -2360,87 +2370,87 @@ static void bond_miimon_link_change(struct bonding *bond,
 static void bond_miimon_commit(struct bonding *bond)
 {
 	struct list_head *iter;
-	struct slave *slave, *primary;
+	struct bond_port *port, *primary;
 
-	bond_for_each_slave(bond, slave, iter) {
-		switch (slave->link_new_state) {
+	bond_for_each_port(bond, port, iter) {
+		switch (port->link_new_state) {
 		case BOND_LINK_NOCHANGE:
-			/* For 802.3ad mode, check current slave speed and
+			/* For 802.3ad mode, check current port speed and
 			 * duplex again in case its port was disabled after
 			 * invalid speed/duplex reporting but recovered before
 			 * link monitoring could make a decision on the actual
 			 * link status
 			 */
 			if (BOND_MODE(bond) == BOND_MODE_8023AD &&
-			    slave->link == BOND_LINK_UP)
-				bond_3ad_adapter_speed_duplex_changed(slave);
+			    port->link == BOND_LINK_UP)
+				bond_3ad_adapter_speed_duplex_changed(port);
 			continue;
 
 		case BOND_LINK_UP:
-			if (bond_update_speed_duplex(slave) &&
+			if (bond_update_speed_duplex(port) &&
 			    bond_needs_speed_duplex(bond)) {
-				slave->link = BOND_LINK_DOWN;
+				port->link = BOND_LINK_DOWN;
 				if (net_ratelimit())
-					slave_warn(bond->dev, slave->dev,
-						   "failed to get link speed/duplex\n");
+					port_warn(bond->dev, port->dev,
+						  "failed to get link speed/duplex\n");
 				continue;
 			}
-			bond_set_slave_link_state(slave, BOND_LINK_UP,
-						  BOND_SLAVE_NOTIFY_NOW);
-			slave->last_link_up = jiffies;
+			bond_set_port_link_state(port, BOND_LINK_UP,
+						 BOND_PORT_NOTIFY_NOW);
+			port->last_link_up = jiffies;
 
-			primary = rtnl_dereference(bond->primary_slave);
+			primary = rtnl_dereference(bond->primary_port);
 			if (BOND_MODE(bond) == BOND_MODE_8023AD) {
 				/* prevent it from being the active one */
-				bond_set_backup_slave(slave);
+				bond_set_backup_port(port);
 			} else if (BOND_MODE(bond) != BOND_MODE_ACTIVEBACKUP) {
 				/* make it immediately active */
-				bond_set_active_slave(slave);
+				bond_set_active_port(port);
 			}
 
-			slave_info(bond->dev, slave->dev, "link status definitely up, %u Mbps %s duplex\n",
-				   slave->speed == SPEED_UNKNOWN ? 0 : slave->speed,
-				   slave->duplex ? "full" : "half");
+			port_info(bond->dev, port->dev, "link status definitely up, %u Mbps %s duplex\n",
+				  port->speed == SPEED_UNKNOWN ? 0 : port->speed,
+				  port->duplex ? "full" : "half");
 
-			bond_miimon_link_change(bond, slave, BOND_LINK_UP);
+			bond_miimon_link_change(bond, port, BOND_LINK_UP);
 
-			if (!bond->curr_active_slave || slave == primary)
+			if (!bond->curr_active_port || port == primary)
 				goto do_failover;
 
 			continue;
 
 		case BOND_LINK_DOWN:
-			if (slave->link_failure_count < UINT_MAX)
-				slave->link_failure_count++;
+			if (port->link_failure_count < UINT_MAX)
+				port->link_failure_count++;
 
-			bond_set_slave_link_state(slave, BOND_LINK_DOWN,
-						  BOND_SLAVE_NOTIFY_NOW);
+			bond_set_port_link_state(port, BOND_LINK_DOWN,
+						 BOND_PORT_NOTIFY_NOW);
 
 			if (BOND_MODE(bond) == BOND_MODE_ACTIVEBACKUP ||
 			    BOND_MODE(bond) == BOND_MODE_8023AD)
-				bond_set_slave_inactive_flags(slave,
-							      BOND_SLAVE_NOTIFY_NOW);
+				bond_set_port_inactive_flags(port,
+							      BOND_PORT_NOTIFY_NOW);
 
-			slave_info(bond->dev, slave->dev, "link status definitely down, disabling slave\n");
+			port_info(bond->dev, port->dev, "link status definitely down, disabling port\n");
 
-			bond_miimon_link_change(bond, slave, BOND_LINK_DOWN);
+			bond_miimon_link_change(bond, port, BOND_LINK_DOWN);
 
-			if (slave == rcu_access_pointer(bond->curr_active_slave))
+			if (port == rcu_access_pointer(bond->curr_active_port))
 				goto do_failover;
 
 			continue;
 
 		default:
-			slave_err(bond->dev, slave->dev, "invalid new link %d on slave\n",
-				  slave->link_new_state);
-			bond_propose_link_state(slave, BOND_LINK_NOCHANGE);
+			port_err(bond->dev, port->dev, "invalid new link %d on port\n",
+				 port->link_new_state);
+			bond_propose_link_state(port, BOND_LINK_NOCHANGE);
 
 			continue;
 		}
 
 do_failover:
 		block_netpoll_tx();
-		bond_select_active_slave(bond);
+		bond_select_active_port(bond);
 		unblock_netpoll_tx();
 	}
 
@@ -2461,12 +2471,12 @@ static void bond_mii_monitor(struct work_struct *work)
 	bool should_notify_peers = false;
 	bool commit;
 	unsigned long delay;
-	struct slave *slave;
+	struct bond_port *port;
 	struct list_head *iter;
 
 	delay = msecs_to_jiffies(bond->params.miimon);
 
-	if (!bond_has_slaves(bond))
+	if (!bond_has_ports(bond))
 		goto re_arm;
 
 	rcu_read_lock();
@@ -2490,8 +2500,8 @@ static void bond_mii_monitor(struct work_struct *work)
 			goto re_arm;
 		}
 
-		bond_for_each_slave(bond, slave, iter) {
-			bond_commit_link_state(slave, BOND_SLAVE_NOTIFY_LATER);
+		bond_for_each_port(bond, port, iter) {
+			bond_commit_link_state(port, BOND_PORT_NOTIFY_LATER);
 		}
 		bond_miimon_commit(bond);
 
@@ -2536,19 +2546,19 @@ static bool bond_has_this_ip(struct bonding *bond, __be32 ip)
  * switches in VLAN mode (especially if ports are configured as
  * "native" to a VLAN) might not pass non-tagged frames.
  */
-static void bond_arp_send(struct slave *slave, int arp_op, __be32 dest_ip,
+static void bond_arp_send(struct bond_port *port, int arp_op, __be32 dest_ip,
 			  __be32 src_ip, struct bond_vlan_tag *tags)
 {
 	struct sk_buff *skb;
 	struct bond_vlan_tag *outer_tag = tags;
-	struct net_device *slave_dev = slave->dev;
-	struct net_device *bond_dev = slave->bond->dev;
+	struct net_device *port_dev = port->dev;
+	struct net_device *bond_dev = port->bond->dev;
 
-	slave_dbg(bond_dev, slave_dev, "arp %d on slave: dst %pI4 src %pI4\n",
-		  arp_op, &dest_ip, &src_ip);
+	port_dbg(bond_dev, port_dev, "arp %d on port: dst %pI4 src %pI4\n",
+		 arp_op, &dest_ip, &src_ip);
 
-	skb = arp_create(arp_op, ETH_P_ARP, dest_ip, slave_dev, src_ip,
-			 NULL, slave_dev->dev_addr, NULL);
+	skb = arp_create(arp_op, ETH_P_ARP, dest_ip, port_dev, src_ip,
+			 NULL, port_dev->dev_addr, NULL);
 
 	if (!skb) {
 		net_err_ratelimited("ARP packet allocation failed\n");
@@ -2567,8 +2577,8 @@ static void bond_arp_send(struct slave *slave, int arp_op, __be32 dest_ip,
 			continue;
 		}
 
-		slave_dbg(bond_dev, slave_dev, "inner tag: proto %X vid %X\n",
-			  ntohs(outer_tag->vlan_proto), tags->vlan_id);
+		port_dbg(bond_dev, port_dev, "inner tag: proto %X vid %X\n",
+			 ntohs(outer_tag->vlan_proto), tags->vlan_id);
 		skb = vlan_insert_tag_set_proto(skb, tags->vlan_proto,
 						tags->vlan_id);
 		if (!skb) {
@@ -2580,8 +2590,8 @@ static void bond_arp_send(struct slave *slave, int arp_op, __be32 dest_ip,
 	}
 	/* Set the outer tag */
 	if (outer_tag->vlan_id) {
-		slave_dbg(bond_dev, slave_dev, "outer tag: proto %X vid %X\n",
-			  ntohs(outer_tag->vlan_proto), outer_tag->vlan_id);
+		port_dbg(bond_dev, port_dev, "outer tag: proto %X vid %X\n",
+			 ntohs(outer_tag->vlan_proto), outer_tag->vlan_id);
 		__vlan_hwaccel_put_tag(skb, outer_tag->vlan_proto,
 				       outer_tag->vlan_id);
 	}
@@ -2630,7 +2640,7 @@ struct bond_vlan_tag *bond_verify_device_path(struct net_device *start_dev,
 	return NULL;
 }
 
-static void bond_arp_send_all(struct bonding *bond, struct slave *slave)
+static void bond_arp_send_all(struct bonding *bond, struct bond_port *port)
 {
 	struct rtable *rt;
 	struct bond_vlan_tag *tags;
@@ -2638,8 +2648,8 @@ static void bond_arp_send_all(struct bonding *bond, struct slave *slave)
 	int i;
 
 	for (i = 0; i < BOND_MAX_ARP_TARGETS && targets[i]; i++) {
-		slave_dbg(bond->dev, slave->dev, "%s: target %pI4\n",
-			  __func__, &targets[i]);
+		port_dbg(bond->dev, port->dev, "%s: target %pI4\n",
+			 __func__, &targets[i]);
 		tags = NULL;
 
 		/* Find out through which dev should the packet go */
@@ -2653,7 +2663,7 @@ static void bond_arp_send_all(struct bonding *bond, struct slave *slave)
 				net_warn_ratelimited("%s: no route to arp_ip_target %pI4 and arp_validate is set\n",
 						     bond->dev->name,
 						     &targets[i]);
-			bond_arp_send(slave, ARPOP_REQUEST, targets[i],
+			bond_arp_send(port, ARPOP_REQUEST, targets[i],
 				      0, tags);
 			continue;
 		}
@@ -2670,8 +2680,8 @@ static void bond_arp_send_all(struct bonding *bond, struct slave *slave)
 			goto found;
 
 		/* Not our device - skip */
-		slave_dbg(bond->dev, slave->dev, "no path to arp_ip_target %pI4 via rt.dev %s\n",
-			   &targets[i], rt->dst.dev ? rt->dst.dev->name : "NULL");
+		port_dbg(bond->dev, port->dev, "no path to arp_ip_target %pI4 via rt.dev %s\n",
+			 &targets[i], rt->dst.dev ? rt->dst.dev->name : "NULL");
 
 		ip_rt_put(rt);
 		continue;
@@ -2679,45 +2689,45 @@ static void bond_arp_send_all(struct bonding *bond, struct slave *slave)
 found:
 		addr = bond_confirm_addr(rt->dst.dev, targets[i], 0);
 		ip_rt_put(rt);
-		bond_arp_send(slave, ARPOP_REQUEST, targets[i], addr, tags);
+		bond_arp_send(port, ARPOP_REQUEST, targets[i], addr, tags);
 		kfree(tags);
 	}
 }
 
-static void bond_validate_arp(struct bonding *bond, struct slave *slave, __be32 sip, __be32 tip)
+static void bond_validate_arp(struct bonding *bond, struct bond_port *port, __be32 sip, __be32 tip)
 {
 	int i;
 
 	if (!sip || !bond_has_this_ip(bond, tip)) {
-		slave_dbg(bond->dev, slave->dev, "%s: sip %pI4 tip %pI4 not found\n",
-			   __func__, &sip, &tip);
+		port_dbg(bond->dev, port->dev, "%s: sip %pI4 tip %pI4 not found\n",
+			 __func__, &sip, &tip);
 		return;
 	}
 
 	i = bond_get_targets_ip(bond->params.arp_targets, sip);
 	if (i == -1) {
-		slave_dbg(bond->dev, slave->dev, "%s: sip %pI4 not found in targets\n",
-			   __func__, &sip);
+		port_dbg(bond->dev, port->dev, "%s: sip %pI4 not found in targets\n",
+			 __func__, &sip);
 		return;
 	}
-	slave->last_rx = jiffies;
-	slave->target_last_arp_rx[i] = jiffies;
+	port->last_rx = jiffies;
+	port->target_last_arp_rx[i] = jiffies;
 }
 
 int bond_arp_rcv(const struct sk_buff *skb, struct bonding *bond,
-		 struct slave *slave)
+		 struct bond_port *port)
 {
 	struct arphdr *arp = (struct arphdr *)skb->data;
-	struct slave *curr_active_slave, *curr_arp_slave;
+	struct bond_port *curr_active_port, *curr_arp_port;
 	unsigned char *arp_ptr;
 	__be32 sip, tip;
 	int is_arp = skb->protocol == __cpu_to_be16(ETH_P_ARP);
 	unsigned int alen;
 
-	if (!slave_do_arp_validate(bond, slave)) {
-		if ((slave_do_arp_validate_only(bond) && is_arp) ||
-		    !slave_do_arp_validate_only(bond))
-			slave->last_rx = jiffies;
+	if (!port_do_arp_validate(bond, port)) {
+		if ((port_do_arp_validate_only(bond) && is_arp) ||
+		    !port_do_arp_validate_only(bond))
+			port->last_rx = jiffies;
 		return RX_HANDLER_ANOTHER;
 	} else if (!is_arp) {
 		return RX_HANDLER_ANOTHER;
@@ -2725,8 +2735,8 @@ int bond_arp_rcv(const struct sk_buff *skb, struct bonding *bond,
 
 	alen = arp_hdr_len(bond->dev);
 
-	slave_dbg(bond->dev, slave->dev, "%s: skb->dev %s\n",
-		   __func__, skb->dev->name);
+	port_dbg(bond->dev, port->dev, "%s: skb->dev %s\n",
+		 __func__, skb->dev->name);
 
 	if (alen > skb_headlen(skb)) {
 		arp = kmalloc(alen, GFP_ATOMIC);
@@ -2750,47 +2760,47 @@ int bond_arp_rcv(const struct sk_buff *skb, struct bonding *bond,
 	arp_ptr += 4 + bond->dev->addr_len;
 	memcpy(&tip, arp_ptr, 4);
 
-	slave_dbg(bond->dev, slave->dev, "%s: %s/%d av %d sv %d sip %pI4 tip %pI4\n",
-		  __func__, slave->dev->name, bond_slave_state(slave),
-		  bond->params.arp_validate, slave_do_arp_validate(bond, slave),
-		  &sip, &tip);
+	port_dbg(bond->dev, port->dev, "%s: %s/%d av %d sv %d sip %pI4 tip %pI4\n",
+		 __func__, port->dev->name, bond_port_state(port),
+		 bond->params.arp_validate, port_do_arp_validate(bond, port),
+		 &sip, &tip);
 
-	curr_active_slave = rcu_dereference(bond->curr_active_slave);
-	curr_arp_slave = rcu_dereference(bond->current_arp_slave);
+	curr_active_port = rcu_dereference(bond->curr_active_port);
+	curr_arp_port = rcu_dereference(bond->current_arp_port);
 
 	/* We 'trust' the received ARP enough to validate it if:
 	 *
-	 * (a) the slave receiving the ARP is active (which includes the
-	 * current ARP slave, if any), or
+	 * (a) the port receiving the ARP is active (which includes the
+	 * current ARP port, if any), or
 	 *
-	 * (b) the receiving slave isn't active, but there is a currently
-	 * active slave and it received valid arp reply(s) after it became
-	 * the currently active slave, or
+	 * (b) the receiving port isn't active, but there is a currently
+	 * active port and it received valid arp reply(s) after it became
+	 * the currently active port, or
 	 *
-	 * (c) there is an ARP slave that sent an ARP during the prior ARP
-	 * interval, and we receive an ARP reply on any slave.  We accept
+	 * (c) there is an ARP port that sent an ARP during the prior ARP
+	 * interval, and we receive an ARP reply on any port.  We accept
 	 * these because switch FDB update delays may deliver the ARP
-	 * reply to a slave other than the sender of the ARP request.
+	 * reply to a port other than the sender of the ARP request.
 	 *
-	 * Note: for (b), backup slaves are receiving the broadcast ARP
+	 * Note: for (b), backup ports are receiving the broadcast ARP
 	 * request, not a reply.  This request passes from the sending
-	 * slave through the L2 switch(es) to the receiving slave.  Since
+	 * port through the L2 switch(es) to the receiving port.  Since
 	 * this is checking the request, sip/tip are swapped for
 	 * validation.
 	 *
 	 * This is done to avoid endless looping when we can't reach the
 	 * arp_ip_target and fool ourselves with our own arp requests.
 	 */
-	if (bond_is_active_slave(slave))
-		bond_validate_arp(bond, slave, sip, tip);
-	else if (curr_active_slave &&
-		 time_after(slave_last_rx(bond, curr_active_slave),
-			    curr_active_slave->last_link_up))
-		bond_validate_arp(bond, slave, tip, sip);
-	else if (curr_arp_slave && (arp->ar_op == htons(ARPOP_REPLY)) &&
+	if (bond_is_active_port(port))
+		bond_validate_arp(bond, port, sip, tip);
+	else if (curr_active_port &&
+		 time_after(port_last_rx(bond, curr_active_port),
+			    curr_active_port->last_link_up))
+		bond_validate_arp(bond, port, tip, sip);
+	else if (curr_arp_port && (arp->ar_op == htons(ARPOP_REPLY)) &&
 		 bond_time_in_interval(bond,
-				       dev_trans_start(curr_arp_slave->dev), 1))
-		bond_validate_arp(bond, slave, sip, tip);
+				       dev_trans_start(curr_arp_port->dev), 1))
+		bond_validate_arp(bond, port, sip, tip);
 
 out_unlock:
 	if (arp != (struct arphdr *)skb->data)
@@ -2812,7 +2822,7 @@ static bool bond_time_in_interval(struct bonding *bond, unsigned long last_act,
 			     last_act + mod * delta_in_ticks + delta_in_ticks/2);
 }
 
-/* This function is called regularly to monitor each slave's link
+/* This function is called regularly to monitor each port's link
  * ensuring that traffic is being sent and received when arp monitoring
  * is used in load-balancing mode. if the adapter has been dormant, then an
  * arp is transmitted to generate traffic. see activebackup_arp_monitor for
@@ -2820,67 +2830,67 @@ static bool bond_time_in_interval(struct bonding *bond, unsigned long last_act,
  */
 static void bond_loadbalance_arp_mon(struct bonding *bond)
 {
-	struct slave *slave, *oldcurrent;
+	struct bond_port *port, *oldcurrent;
 	struct list_head *iter;
-	int do_failover = 0, slave_state_changed = 0;
+	int do_failover = 0, port_state_changed = 0;
 
-	if (!bond_has_slaves(bond))
+	if (!bond_has_ports(bond))
 		goto re_arm;
 
 	rcu_read_lock();
 
-	oldcurrent = rcu_dereference(bond->curr_active_slave);
+	oldcurrent = rcu_dereference(bond->curr_active_port);
 	/* see if any of the previous devices are up now (i.e. they have
-	 * xmt and rcv traffic). the curr_active_slave does not come into
-	 * the picture unless it is null. also, slave->last_link_up is not
-	 * needed here because we send an arp on each slave and give a slave
+	 * xmt and rcv traffic). the curr_active_port does not come into
+	 * the picture unless it is null. also, port->last_link_up is not
+	 * needed here because we send an arp on each port and give a port
 	 * as long as it needs to get the tx/rx within the delta.
 	 * TODO: what about up/down delay in arp mode? it wasn't here before
 	 *       so it can wait
 	 */
-	bond_for_each_slave_rcu(bond, slave, iter) {
-		unsigned long trans_start = dev_trans_start(slave->dev);
+	bond_for_each_port_rcu(bond, port, iter) {
+		unsigned long trans_start = dev_trans_start(port->dev);
 
-		bond_propose_link_state(slave, BOND_LINK_NOCHANGE);
+		bond_propose_link_state(port, BOND_LINK_NOCHANGE);
 
-		if (slave->link != BOND_LINK_UP) {
+		if (port->link != BOND_LINK_UP) {
 			if (bond_time_in_interval(bond, trans_start, 1) &&
-			    bond_time_in_interval(bond, slave->last_rx, 1)) {
+			    bond_time_in_interval(bond, port->last_rx, 1)) {
 
-				bond_propose_link_state(slave, BOND_LINK_UP);
-				slave_state_changed = 1;
+				bond_propose_link_state(port, BOND_LINK_UP);
+				port_state_changed = 1;
 
-				/* primary_slave has no meaning in round-robin
-				 * mode. the window of a slave being up and
-				 * curr_active_slave being null after enslaving
+				/* primary_port has no meaning in round-robin
+				 * mode. the window of a port being up and
+				 * curr_active_port being null after connecting
 				 * is closed.
 				 */
 				if (!oldcurrent) {
-					slave_info(bond->dev, slave->dev, "link status definitely up\n");
+					port_info(bond->dev, port->dev, "link status definitely up\n");
 					do_failover = 1;
 				} else {
-					slave_info(bond->dev, slave->dev, "interface is now up\n");
+					port_info(bond->dev, port->dev, "interface is now up\n");
 				}
 			}
 		} else {
-			/* slave->link == BOND_LINK_UP */
+			/* port->link == BOND_LINK_UP */
 
 			/* not all switches will respond to an arp request
 			 * when the source ip is 0, so don't take the link down
 			 * if we don't know our ip yet
 			 */
 			if (!bond_time_in_interval(bond, trans_start, 2) ||
-			    !bond_time_in_interval(bond, slave->last_rx, 2)) {
+			    !bond_time_in_interval(bond, port->last_rx, 2)) {
 
-				bond_propose_link_state(slave, BOND_LINK_DOWN);
-				slave_state_changed = 1;
+				bond_propose_link_state(port, BOND_LINK_DOWN);
+				port_state_changed = 1;
 
-				if (slave->link_failure_count < UINT_MAX)
-					slave->link_failure_count++;
+				if (port->link_failure_count < UINT_MAX)
+					port->link_failure_count++;
 
-				slave_info(bond->dev, slave->dev, "interface is now down\n");
+				port_info(bond->dev, port->dev, "interface is now down\n");
 
-				if (slave == oldcurrent)
+				if (port == oldcurrent)
 					do_failover = 1;
 			}
 		}
@@ -2889,32 +2899,32 @@ static void bond_loadbalance_arp_mon(struct bonding *bond)
 		 * must tx arp to ensure all links rx an arp - otherwise
 		 * links may oscillate or not come up at all; if switch is
 		 * in something like xor mode, there is nothing we can
-		 * do - all replies will be rx'ed on same link causing slaves
+		 * do - all replies will be rx'ed on same link causing ports
 		 * to be unstable during low/no traffic periods
 		 */
-		if (bond_slave_is_up(slave))
-			bond_arp_send_all(bond, slave);
+		if (bond_port_is_up(port))
+			bond_arp_send_all(bond, port);
 	}
 
 	rcu_read_unlock();
 
-	if (do_failover || slave_state_changed) {
+	if (do_failover || port_state_changed) {
 		if (!rtnl_trylock())
 			goto re_arm;
 
-		bond_for_each_slave(bond, slave, iter) {
-			if (slave->link_new_state != BOND_LINK_NOCHANGE)
-				slave->link = slave->link_new_state;
+		bond_for_each_port(bond, port, iter) {
+			if (port->link_new_state != BOND_LINK_NOCHANGE)
+				port->link = port->link_new_state;
 		}
 
-		if (slave_state_changed) {
-			bond_slave_state_change(bond);
+		if (port_state_changed) {
+			bond_port_state_change(bond);
 			if (BOND_MODE(bond) == BOND_MODE_XOR)
-				bond_update_slave_arr(bond, NULL);
+				bond_update_port_arr(bond, NULL);
 		}
 		if (do_failover) {
 			block_netpoll_tx();
-			bond_select_active_slave(bond);
+			bond_select_active_port(bond);
 			unblock_netpoll_tx();
 		}
 		rtnl_unlock();
@@ -2926,9 +2936,9 @@ static void bond_loadbalance_arp_mon(struct bonding *bond)
 				   msecs_to_jiffies(bond->params.arp_interval));
 }
 
-/* Called to inspect slaves for active-backup mode ARP monitor link state
- * changes.  Sets proposed link state in slaves to specify what action
- * should take place for the slave.  Returns 0 if no changes are found, >0
+/* Called to inspect ports for active-backup mode ARP monitor link state
+ * changes.  Sets proposed link state in ports to specify what action
+ * should take place for the port.  Returns 0 if no changes are found, >0
  * if changes to link states must be committed.
  *
  * Called with rcu_read_lock held.
@@ -2937,60 +2947,60 @@ static int bond_ab_arp_inspect(struct bonding *bond)
 {
 	unsigned long trans_start, last_rx;
 	struct list_head *iter;
-	struct slave *slave;
+	struct bond_port *port;
 	int commit = 0;
 
-	bond_for_each_slave_rcu(bond, slave, iter) {
-		bond_propose_link_state(slave, BOND_LINK_NOCHANGE);
-		last_rx = slave_last_rx(bond, slave);
+	bond_for_each_port_rcu(bond, port, iter) {
+		bond_propose_link_state(port, BOND_LINK_NOCHANGE);
+		last_rx = port_last_rx(bond, port);
 
-		if (slave->link != BOND_LINK_UP) {
+		if (port->link != BOND_LINK_UP) {
 			if (bond_time_in_interval(bond, last_rx, 1)) {
-				bond_propose_link_state(slave, BOND_LINK_UP);
+				bond_propose_link_state(port, BOND_LINK_UP);
 				commit++;
-			} else if (slave->link == BOND_LINK_BACK) {
-				bond_propose_link_state(slave, BOND_LINK_FAIL);
+			} else if (port->link == BOND_LINK_BACK) {
+				bond_propose_link_state(port, BOND_LINK_FAIL);
 				commit++;
 			}
 			continue;
 		}
 
-		/* Give slaves 2*delta after being enslaved or made
+		/* Give ports 2*delta after being connected or made
 		 * active.  This avoids bouncing, as the last receive
 		 * times need a full ARP monitor cycle to be updated.
 		 */
-		if (bond_time_in_interval(bond, slave->last_link_up, 2))
+		if (bond_time_in_interval(bond, port->last_link_up, 2))
 			continue;
 
-		/* Backup slave is down if:
-		 * - No current_arp_slave AND
+		/* Backup port is down if:
+		 * - No current_arp_port AND
 		 * - more than 3*delta since last receive AND
 		 * - the bond has an IP address
 		 *
-		 * Note: a non-null current_arp_slave indicates
-		 * the curr_active_slave went down and we are
+		 * Note: a non-null current_arp_port indicates
+		 * the curr_active_port went down and we are
 		 * searching for a new one; under this condition
-		 * we only take the curr_active_slave down - this
-		 * gives each slave a chance to tx/rx traffic
+		 * we only take the curr_active_port down - this
+		 * gives each port a chance to tx/rx traffic
 		 * before being taken out
 		 */
-		if (!bond_is_active_slave(slave) &&
-		    !rcu_access_pointer(bond->current_arp_slave) &&
+		if (!bond_is_active_port(port) &&
+		    !rcu_access_pointer(bond->current_arp_port) &&
 		    !bond_time_in_interval(bond, last_rx, 3)) {
-			bond_propose_link_state(slave, BOND_LINK_DOWN);
+			bond_propose_link_state(port, BOND_LINK_DOWN);
 			commit++;
 		}
 
-		/* Active slave is down if:
+		/* Active port is down if:
 		 * - more than 2*delta since transmitting OR
 		 * - (more than 2*delta since receive AND
 		 *    the bond has an IP address)
 		 */
-		trans_start = dev_trans_start(slave->dev);
-		if (bond_is_active_slave(slave) &&
+		trans_start = dev_trans_start(port->dev);
+		if (bond_is_active_port(port) &&
 		    (!bond_time_in_interval(bond, trans_start, 2) ||
 		     !bond_time_in_interval(bond, last_rx, 2))) {
-			bond_propose_link_state(slave, BOND_LINK_DOWN);
+			bond_propose_link_state(port, BOND_LINK_DOWN);
 			commit++;
 		}
 	}
@@ -3007,34 +3017,34 @@ static void bond_ab_arp_commit(struct bonding *bond)
 {
 	unsigned long trans_start;
 	struct list_head *iter;
-	struct slave *slave;
+	struct bond_port *port;
 
-	bond_for_each_slave(bond, slave, iter) {
-		switch (slave->link_new_state) {
+	bond_for_each_port(bond, port, iter) {
+		switch (port->link_new_state) {
 		case BOND_LINK_NOCHANGE:
 			continue;
 
 		case BOND_LINK_UP:
-			trans_start = dev_trans_start(slave->dev);
-			if (rtnl_dereference(bond->curr_active_slave) != slave ||
-			    (!rtnl_dereference(bond->curr_active_slave) &&
+			trans_start = dev_trans_start(port->dev);
+			if (rtnl_dereference(bond->curr_active_port) != port ||
+			    (!rtnl_dereference(bond->curr_active_port) &&
 			     bond_time_in_interval(bond, trans_start, 1))) {
-				struct slave *current_arp_slave;
-
-				current_arp_slave = rtnl_dereference(bond->current_arp_slave);
-				bond_set_slave_link_state(slave, BOND_LINK_UP,
-							  BOND_SLAVE_NOTIFY_NOW);
-				if (current_arp_slave) {
-					bond_set_slave_inactive_flags(
-						current_arp_slave,
-						BOND_SLAVE_NOTIFY_NOW);
-					RCU_INIT_POINTER(bond->current_arp_slave, NULL);
+				struct bond_port *current_arp_port;
+
+				current_arp_port = rtnl_dereference(bond->current_arp_port);
+				bond_set_port_link_state(port, BOND_LINK_UP,
+							 BOND_PORT_NOTIFY_NOW);
+				if (current_arp_port) {
+					bond_set_port_inactive_flags(
+						current_arp_port,
+						BOND_PORT_NOTIFY_NOW);
+					RCU_INIT_POINTER(bond->current_arp_port, NULL);
 				}
 
-				slave_info(bond->dev, slave->dev, "link status definitely up\n");
+				port_info(bond->dev, port->dev, "link status definitely up\n");
 
-				if (!rtnl_dereference(bond->curr_active_slave) ||
-				    slave == rtnl_dereference(bond->primary_slave))
+				if (!rtnl_dereference(bond->curr_active_port) ||
+				    port == rtnl_dereference(bond->primary_port))
 					goto do_failover;
 
 			}
@@ -3042,46 +3052,46 @@ static void bond_ab_arp_commit(struct bonding *bond)
 			continue;
 
 		case BOND_LINK_DOWN:
-			if (slave->link_failure_count < UINT_MAX)
-				slave->link_failure_count++;
+			if (port->link_failure_count < UINT_MAX)
+				port->link_failure_count++;
 
-			bond_set_slave_link_state(slave, BOND_LINK_DOWN,
-						  BOND_SLAVE_NOTIFY_NOW);
-			bond_set_slave_inactive_flags(slave,
-						      BOND_SLAVE_NOTIFY_NOW);
+			bond_set_port_link_state(port, BOND_LINK_DOWN,
+						 BOND_PORT_NOTIFY_NOW);
+			bond_set_port_inactive_flags(port,
+						     BOND_PORT_NOTIFY_NOW);
 
-			slave_info(bond->dev, slave->dev, "link status definitely down, disabling slave\n");
+			port_info(bond->dev, port->dev, "link status definitely down, disabling port\n");
 
-			if (slave == rtnl_dereference(bond->curr_active_slave)) {
-				RCU_INIT_POINTER(bond->current_arp_slave, NULL);
+			if (port == rtnl_dereference(bond->curr_active_port)) {
+				RCU_INIT_POINTER(bond->current_arp_port, NULL);
 				goto do_failover;
 			}
 
 			continue;
 
 		case BOND_LINK_FAIL:
-			bond_set_slave_link_state(slave, BOND_LINK_FAIL,
-						  BOND_SLAVE_NOTIFY_NOW);
-			bond_set_slave_inactive_flags(slave,
-						      BOND_SLAVE_NOTIFY_NOW);
+			bond_set_port_link_state(port, BOND_LINK_FAIL,
+						 BOND_PORT_NOTIFY_NOW);
+			bond_set_port_inactive_flags(port,
+						     BOND_PORT_NOTIFY_NOW);
 
-			/* A slave has just been enslaved and has become
-			 * the current active slave.
+			/* A port has just been connected and has become
+			 * the current active port.
 			 */
-			if (rtnl_dereference(bond->curr_active_slave))
-				RCU_INIT_POINTER(bond->current_arp_slave, NULL);
+			if (rtnl_dereference(bond->curr_active_port))
+				RCU_INIT_POINTER(bond->current_arp_port, NULL);
 			continue;
 
 		default:
-			slave_err(bond->dev, slave->dev,
-				  "impossible: link_new_state %d on slave\n",
-				  slave->link_new_state);
+			port_err(bond->dev, port->dev,
+				 "impossible: link_new_state %d on port\n",
+				 port->link_new_state);
 			continue;
 		}
 
 do_failover:
 		block_netpoll_tx();
-		bond_select_active_slave(bond);
+		bond_select_active_port(bond);
 		unblock_netpoll_tx();
 	}
 
@@ -3094,79 +3104,79 @@ static void bond_ab_arp_commit(struct bonding *bond)
  */
 static bool bond_ab_arp_probe(struct bonding *bond)
 {
-	struct slave *slave, *before = NULL, *new_slave = NULL,
-		     *curr_arp_slave = rcu_dereference(bond->current_arp_slave),
-		     *curr_active_slave = rcu_dereference(bond->curr_active_slave);
+	struct bond_port *port, *before = NULL, *new_port = NULL,
+		     *curr_arp_port = rcu_dereference(bond->current_arp_port),
+		     *curr_active_port = rcu_dereference(bond->curr_active_port);
 	struct list_head *iter;
 	bool found = false;
-	bool should_notify_rtnl = BOND_SLAVE_NOTIFY_LATER;
+	bool should_notify_rtnl = BOND_PORT_NOTIFY_LATER;
 
-	if (curr_arp_slave && curr_active_slave)
+	if (curr_arp_port && curr_active_port)
 		netdev_info(bond->dev, "PROBE: c_arp %s && cas %s BAD\n",
-			    curr_arp_slave->dev->name,
-			    curr_active_slave->dev->name);
+			    curr_arp_port->dev->name,
+			    curr_active_port->dev->name);
 
-	if (curr_active_slave) {
-		bond_arp_send_all(bond, curr_active_slave);
+	if (curr_active_port) {
+		bond_arp_send_all(bond, curr_active_port);
 		return should_notify_rtnl;
 	}
 
-	/* if we don't have a curr_active_slave, search for the next available
-	 * backup slave from the current_arp_slave and make it the candidate
-	 * for becoming the curr_active_slave
+	/* if we don't have a curr_active_port, search for the next available
+	 * backup port from the current_arp_port and make it the candidate
+	 * for becoming the curr_active_port
 	 */
 
-	if (!curr_arp_slave) {
-		curr_arp_slave = bond_first_slave_rcu(bond);
-		if (!curr_arp_slave)
+	if (!curr_arp_port) {
+		curr_arp_port = bond_first_port_rcu(bond);
+		if (!curr_arp_port)
 			return should_notify_rtnl;
 	}
 
-	bond_for_each_slave_rcu(bond, slave, iter) {
-		if (!found && !before && bond_slave_is_up(slave))
-			before = slave;
+	bond_for_each_port_rcu(bond, port, iter) {
+		if (!found && !before && bond_port_is_up(port))
+			before = port;
 
-		if (found && !new_slave && bond_slave_is_up(slave))
-			new_slave = slave;
+		if (found && !new_port && bond_port_is_up(port))
+			new_port = port;
 		/* if the link state is up at this point, we
 		 * mark it down - this can happen if we have
 		 * simultaneous link failures and
 		 * reselect_active_interface doesn't make this
-		 * one the current slave so it is still marked
+		 * one the current port so it is still marked
 		 * up when it is actually down
 		 */
-		if (!bond_slave_is_up(slave) && slave->link == BOND_LINK_UP) {
-			bond_set_slave_link_state(slave, BOND_LINK_DOWN,
-						  BOND_SLAVE_NOTIFY_LATER);
-			if (slave->link_failure_count < UINT_MAX)
-				slave->link_failure_count++;
+		if (!bond_port_is_up(port) && port->link == BOND_LINK_UP) {
+			bond_set_port_link_state(port, BOND_LINK_DOWN,
+						 BOND_PORT_NOTIFY_LATER);
+			if (port->link_failure_count < UINT_MAX)
+				port->link_failure_count++;
 
-			bond_set_slave_inactive_flags(slave,
-						      BOND_SLAVE_NOTIFY_LATER);
+			bond_set_port_inactive_flags(port,
+						     BOND_PORT_NOTIFY_LATER);
 
-			slave_info(bond->dev, slave->dev, "backup interface is now down\n");
+			port_info(bond->dev, port->dev, "backup interface is now down\n");
 		}
-		if (slave == curr_arp_slave)
+		if (port == curr_arp_port)
 			found = true;
 	}
 
-	if (!new_slave && before)
-		new_slave = before;
+	if (!new_port && before)
+		new_port = before;
 
-	if (!new_slave)
+	if (!new_port)
 		goto check_state;
 
-	bond_set_slave_link_state(new_slave, BOND_LINK_BACK,
-				  BOND_SLAVE_NOTIFY_LATER);
-	bond_set_slave_active_flags(new_slave, BOND_SLAVE_NOTIFY_LATER);
-	bond_arp_send_all(bond, new_slave);
-	new_slave->last_link_up = jiffies;
-	rcu_assign_pointer(bond->current_arp_slave, new_slave);
+	bond_set_port_link_state(new_port, BOND_LINK_BACK,
+				 BOND_PORT_NOTIFY_LATER);
+	bond_set_port_active_flags(new_port, BOND_PORT_NOTIFY_LATER);
+	bond_arp_send_all(bond, new_port);
+	new_port->last_link_up = jiffies;
+	rcu_assign_pointer(bond->current_arp_port, new_port);
 
 check_state:
-	bond_for_each_slave_rcu(bond, slave, iter) {
-		if (slave->should_notify || slave->should_notify_link) {
-			should_notify_rtnl = BOND_SLAVE_NOTIFY_NOW;
+	bond_for_each_port_rcu(bond, port, iter) {
+		if (port->should_notify || port->should_notify_link) {
+			should_notify_rtnl = BOND_PORT_NOTIFY_NOW;
 			break;
 		}
 	}
@@ -3181,7 +3191,7 @@ static void bond_activebackup_arp_mon(struct bonding *bond)
 
 	delta_in_ticks = msecs_to_jiffies(bond->params.arp_interval);
 
-	if (!bond_has_slaves(bond))
+	if (!bond_has_ports(bond))
 		goto re_arm;
 
 	rcu_read_lock();
@@ -3219,8 +3229,8 @@ static void bond_activebackup_arp_mon(struct bonding *bond)
 			call_netdevice_notifiers(NETDEV_NOTIFY_PEERS,
 						 bond->dev);
 		if (should_notify_rtnl) {
-			bond_slave_state_notify(bond);
-			bond_slave_link_notify(bond);
+			bond_port_state_notify(bond);
+			bond_port_link_notify(bond);
 		}
 
 		rtnl_unlock();
@@ -3274,76 +3284,76 @@ static int bond_dev_netdev_event(unsigned long event,
 	return NOTIFY_DONE;
 }
 
-static int bond_slave_netdev_event(unsigned long event,
-				   struct net_device *slave_dev)
+static int bond_port_netdev_event(unsigned long event,
+				   struct net_device *port_dev)
 {
-	struct slave *slave = bond_slave_get_rtnl(slave_dev), *primary;
+	struct bond_port *port = bond_port_get_rtnl(port_dev), *primary;
 	struct bonding *bond;
 	struct net_device *bond_dev;
 
-	/* A netdev event can be generated while enslaving a device
+	/* A netdev event can be generated while connecting a device
 	 * before netdev_rx_handler_register is called in which case
-	 * slave will be NULL
+	 * port will be NULL
 	 */
-	if (!slave) {
-		netdev_dbg(slave_dev, "%s called on NULL slave\n", __func__);
+	if (!port) {
+		netdev_dbg(port_dev, "%s called on NULL port\n", __func__);
 		return NOTIFY_DONE;
 	}
 
-	bond_dev = slave->bond->dev;
-	bond = slave->bond;
-	primary = rtnl_dereference(bond->primary_slave);
+	bond_dev = port->bond->dev;
+	bond = port->bond;
+	primary = rtnl_dereference(bond->primary_port);
 
-	slave_dbg(bond_dev, slave_dev, "%s called\n", __func__);
+	port_dbg(bond_dev, port_dev, "%s called\n", __func__);
 
 	switch (event) {
 	case NETDEV_UNREGISTER:
 		if (bond_dev->type != ARPHRD_ETHER)
-			bond_release_and_destroy(bond_dev, slave_dev);
+			bond_release_and_destroy(bond_dev, port_dev);
 		else
-			__bond_release_one(bond_dev, slave_dev, false, true);
+			__bond_release_one(bond_dev, port_dev, false, true);
 		break;
 	case NETDEV_UP:
 	case NETDEV_CHANGE:
 		/* For 802.3ad mode only:
-		 * Getting invalid Speed/Duplex values here will put slave
+		 * Getting invalid Speed/Duplex values here will put port
 		 * in weird state. Mark it as link-fail if the link was
 		 * previously up or link-down if it hasn't yet come up, and
 		 * let link-monitoring (miimon) set it right when correct
 		 * speeds/duplex are available.
 		 */
-		if (bond_update_speed_duplex(slave) &&
+		if (bond_update_speed_duplex(port) &&
 		    BOND_MODE(bond) == BOND_MODE_8023AD) {
-			if (slave->last_link_up)
-				slave->link = BOND_LINK_FAIL;
+			if (port->last_link_up)
+				port->link = BOND_LINK_FAIL;
 			else
-				slave->link = BOND_LINK_DOWN;
+				port->link = BOND_LINK_DOWN;
 		}
 
 		if (BOND_MODE(bond) == BOND_MODE_8023AD)
-			bond_3ad_adapter_speed_duplex_changed(slave);
+			bond_3ad_adapter_speed_duplex_changed(port);
 		fallthrough;
 	case NETDEV_DOWN:
-		/* Refresh slave-array if applicable!
+		/* Refresh port-array if applicable!
 		 * If the setup does not use miimon or arpmon (mode-specific!),
-		 * then these events will not cause the slave-array to be
-		 * refreshed. This will cause xmit to use a slave that is not
+		 * then these events will not cause the port-array to be
+		 * refreshed. This will cause xmit to use a port that is not
 		 * usable. Avoid such situation by refeshing the array at these
 		 * events. If these (miimon/arpmon) parameters are configured
 		 * then array gets refreshed twice and that should be fine!
 		 */
 		if (bond_mode_can_use_xmit_hash(bond))
-			bond_update_slave_arr(bond, NULL);
+			bond_update_port_arr(bond, NULL);
 		break;
 	case NETDEV_CHANGEMTU:
-		/* TODO: Should slaves be allowed to
+		/* TODO: Should ports be allowed to
 		 * independently alter their MTU?  For
-		 * an active-backup bond, slaves need
+		 * an active-backup bond, ports need
 		 * not be the same type of device, so
 		 * MTUs may vary.  For other modes,
-		 * slaves arguably should have the
+		 * ports arguably should have the
 		 * same MTUs. To do this, we'd need to
-		 * take over the slave's change_mtu
+		 * take over the port's change_mtu
 		 * function for the duration of their
 		 * servitude.
 		 */
@@ -3354,21 +3364,21 @@ static int bond_slave_netdev_event(unsigned long event,
 		    !bond->params.primary[0])
 			break;
 
-		if (slave == primary) {
-			/* slave's name changed - he's no longer primary */
-			RCU_INIT_POINTER(bond->primary_slave, NULL);
-		} else if (!strcmp(slave_dev->name, bond->params.primary)) {
-			/* we have a new primary slave */
-			rcu_assign_pointer(bond->primary_slave, slave);
+		if (port == primary) {
+			/* port's name changed - he's no longer primary */
+			RCU_INIT_POINTER(bond->primary_port, NULL);
+		} else if (!strcmp(port_dev->name, bond->params.primary)) {
+			/* we have a new primary port */
+			rcu_assign_pointer(bond->primary_port, port);
 		} else { /* we didn't change primary - exit */
 			break;
 		}
 
-		netdev_info(bond->dev, "Primary slave changed to %s, reselecting active slave\n",
-			    primary ? slave_dev->name : "none");
+		netdev_info(bond->dev, "Primary port changed to %s, reselecting active port\n",
+			    primary ? port_dev->name : "none");
 
 		block_netpoll_tx();
-		bond_select_active_slave(bond);
+		bond_select_active_port(bond);
 		unblock_netpoll_tx();
 		break;
 	case NETDEV_FEAT_CHANGE:
@@ -3376,7 +3386,7 @@ static int bond_slave_netdev_event(unsigned long event,
 		break;
 	case NETDEV_RESEND_IGMP:
 		/* Propagate to bond device */
-		call_netdevice_notifiers(event, slave->bond->dev);
+		call_netdevice_notifiers(event, port->bond->dev);
 		break;
 	default:
 		break;
@@ -3389,7 +3399,7 @@ static int bond_slave_netdev_event(unsigned long event,
  *
  * This function receives events for the netdev chain.  The caller (an
  * ioctl handler calling blocking_notifier_call_chain) holds the necessary
- * locks for us to safely manipulate the slave devices (RTNL lock,
+ * locks for us to safely manipulate the port devices (RTNL lock,
  * dev_probe_lock).
  */
 static int bond_netdev_event(struct notifier_block *this,
@@ -3412,7 +3422,7 @@ static int bond_netdev_event(struct notifier_block *this,
 	}
 
 	if (event_dev->flags & IFF_SLAVE)
-		return bond_slave_netdev_event(event, event_dev);
+		return bond_port_netdev_event(event, event_dev);
 
 	return NOTIFY_DONE;
 }
@@ -3558,7 +3568,7 @@ void bond_work_init_all(struct bonding *bond)
 	INIT_DELAYED_WORK(&bond->mii_work, bond_mii_monitor);
 	INIT_DELAYED_WORK(&bond->arp_work, bond_arp_monitor);
 	INIT_DELAYED_WORK(&bond->ad_work, bond_3ad_state_machine_handler);
-	INIT_DELAYED_WORK(&bond->slave_arr_work, bond_slave_arr_handler);
+	INIT_DELAYED_WORK(&bond->port_arr_work, bond_port_arr_handler);
 }
 
 static void bond_work_cancel_all(struct bonding *bond)
@@ -3568,25 +3578,25 @@ static void bond_work_cancel_all(struct bonding *bond)
 	cancel_delayed_work_sync(&bond->alb_work);
 	cancel_delayed_work_sync(&bond->ad_work);
 	cancel_delayed_work_sync(&bond->mcast_work);
-	cancel_delayed_work_sync(&bond->slave_arr_work);
+	cancel_delayed_work_sync(&bond->port_arr_work);
 }
 
 static int bond_open(struct net_device *bond_dev)
 {
 	struct bonding *bond = netdev_priv(bond_dev);
 	struct list_head *iter;
-	struct slave *slave;
+	struct bond_port *port;
 
-	/* reset slave->backup and slave->inactive */
-	if (bond_has_slaves(bond)) {
-		bond_for_each_slave(bond, slave, iter) {
+	/* reset port->backup and port->inactive */
+	if (bond_has_ports(bond)) {
+		bond_for_each_port(bond, port, iter) {
 			if (bond_uses_primary(bond) &&
-			    slave != rcu_access_pointer(bond->curr_active_slave)) {
-				bond_set_slave_inactive_flags(slave,
-							      BOND_SLAVE_NOTIFY_NOW);
+			    port != rcu_access_pointer(bond->curr_active_port)) {
+				bond_set_port_inactive_flags(port,
+							     BOND_PORT_NOTIFY_NOW);
 			} else if (BOND_MODE(bond) != BOND_MODE_8023AD) {
-				bond_set_slave_active_flags(slave,
-							    BOND_SLAVE_NOTIFY_NOW);
+				bond_set_port_active_flags(port,
+							   BOND_PORT_NOTIFY_NOW);
 			}
 		}
 	}
@@ -3617,7 +3627,7 @@ static int bond_open(struct net_device *bond_dev)
 	}
 
 	if (bond_mode_can_use_xmit_hash(bond))
-		bond_update_slave_arr(bond, NULL);
+		bond_update_port_arr(bond, NULL);
 
 	return 0;
 }
@@ -3711,7 +3721,7 @@ static void bond_get_stats(struct net_device *bond_dev,
 	struct bonding *bond = netdev_priv(bond_dev);
 	struct rtnl_link_stats64 temp;
 	struct list_head *iter;
-	struct slave *slave;
+	struct bond_port *port;
 	int nest_level = 0;
 
 
@@ -3723,14 +3733,14 @@ static void bond_get_stats(struct net_device *bond_dev,
 	spin_lock_nested(&bond->stats_lock, nest_level);
 	memcpy(stats, &bond->bond_stats, sizeof(*stats));
 
-	bond_for_each_slave_rcu(bond, slave, iter) {
+	bond_for_each_port_rcu(bond, port, iter) {
 		const struct rtnl_link_stats64 *new =
-			dev_get_stats(slave->dev, &temp);
+			dev_get_stats(port->dev, &temp);
 
-		bond_fold_stats(stats, new, &slave->slave_stats);
+		bond_fold_stats(stats, new, &port->port_stats);
 
-		/* save off the slave stats for the next run */
-		memcpy(&slave->slave_stats, new, sizeof(*new));
+		/* save off the port stats for the next run */
+		memcpy(&port->port_stats, new, sizeof(*new));
 	}
 
 	memcpy(&bond->bond_stats, stats, sizeof(*stats));
@@ -3741,7 +3751,7 @@ static void bond_get_stats(struct net_device *bond_dev,
 static int bond_do_ioctl(struct net_device *bond_dev, struct ifreq *ifr, int cmd)
 {
 	struct bonding *bond = netdev_priv(bond_dev);
-	struct net_device *slave_dev = NULL;
+	struct net_device *port_dev = NULL;
 	struct ifbond k_binfo;
 	struct ifbond __user *u_binfo = NULL;
 	struct ifslave k_sinfo;
@@ -3795,7 +3805,7 @@ static int bond_do_ioctl(struct net_device *bond_dev, struct ifreq *ifr, int cmd
 		if (copy_from_user(&k_sinfo, u_sinfo, sizeof(ifslave)))
 			return -EFAULT;
 
-		res = bond_slave_info_query(bond_dev, &k_sinfo);
+		res = bond_port_info_query(bond_dev, &k_sinfo);
 		if (res == 0 &&
 		    copy_to_user(u_sinfo, &k_sinfo, sizeof(ifslave)))
 			return -EFAULT;
@@ -3810,30 +3820,30 @@ static int bond_do_ioctl(struct net_device *bond_dev, struct ifreq *ifr, int cmd
 	if (!ns_capable(net->user_ns, CAP_NET_ADMIN))
 		return -EPERM;
 
-	slave_dev = __dev_get_by_name(net, ifr->ifr_slave);
+	port_dev = __dev_get_by_name(net, ifr->ifr_slave);
 
-	slave_dbg(bond_dev, slave_dev, "slave_dev=%p:\n", slave_dev);
+	port_dbg(bond_dev, port_dev, "port_dev=%p:\n", port_dev);
 
-	if (!slave_dev)
+	if (!port_dev)
 		return -ENODEV;
 
 	switch (cmd) {
 	case BOND_ENSLAVE_OLD:
 	case SIOCBONDENSLAVE:
-		res = bond_enslave(bond_dev, slave_dev, NULL);
+		res = bond_connect(bond_dev, port_dev, NULL);
 		break;
 	case BOND_RELEASE_OLD:
 	case SIOCBONDRELEASE:
-		res = bond_release(bond_dev, slave_dev);
+		res = bond_release(bond_dev, port_dev);
 		break;
 	case BOND_SETHWADDR_OLD:
 	case SIOCBONDSETHWADDR:
-		res = bond_set_dev_addr(bond_dev, slave_dev);
+		res = bond_set_dev_addr(bond_dev, port_dev);
 		break;
 	case BOND_CHANGE_ACTIVE_OLD:
 	case SIOCBONDCHANGEACTIVE:
-		bond_opt_initstr(&newval, slave_dev->name);
-		res = __bond_opt_set_notify(bond, BOND_OPT_ACTIVE_SLAVE,
+		bond_opt_initstr(&newval, port_dev->name);
+		res = __bond_opt_set_notify(bond, BOND_OPT_ACTIVE_PORT,
 					    &newval);
 		break;
 	default:
@@ -3860,19 +3870,19 @@ static void bond_set_rx_mode(struct net_device *bond_dev)
 {
 	struct bonding *bond = netdev_priv(bond_dev);
 	struct list_head *iter;
-	struct slave *slave;
+	struct bond_port *port;
 
 	rcu_read_lock();
 	if (bond_uses_primary(bond)) {
-		slave = rcu_dereference(bond->curr_active_slave);
-		if (slave) {
-			dev_uc_sync(slave->dev, bond_dev);
-			dev_mc_sync(slave->dev, bond_dev);
+		port = rcu_dereference(bond->curr_active_port);
+		if (port) {
+			dev_uc_sync(port->dev, bond_dev);
+			dev_mc_sync(port->dev, bond_dev);
 		}
 	} else {
-		bond_for_each_slave_rcu(bond, slave, iter) {
-			dev_uc_sync_multiple(slave->dev, bond_dev);
-			dev_mc_sync_multiple(slave->dev, bond_dev);
+		bond_for_each_port_rcu(bond, port, iter) {
+			dev_uc_sync_multiple(port->dev, bond_dev);
+			dev_mc_sync_multiple(port->dev, bond_dev);
 		}
 	}
 	rcu_read_unlock();
@@ -3881,17 +3891,17 @@ static void bond_set_rx_mode(struct net_device *bond_dev)
 static int bond_neigh_init(struct neighbour *n)
 {
 	struct bonding *bond = netdev_priv(n->dev);
-	const struct net_device_ops *slave_ops;
+	const struct net_device_ops *port_ops;
 	struct neigh_parms parms;
-	struct slave *slave;
+	struct bond_port *port;
 	int ret = 0;
 
 	rcu_read_lock();
-	slave = bond_first_slave_rcu(bond);
-	if (!slave)
+	port = bond_first_port_rcu(bond);
+	if (!port)
 		goto out;
-	slave_ops = slave->dev->netdev_ops;
-	if (!slave_ops->ndo_neigh_setup)
+	port_ops = port->dev->netdev_ops;
+	if (!port_ops->ndo_neigh_setup)
 		goto out;
 
 	/* TODO: find another way [1] to implement this.
@@ -3903,7 +3913,7 @@ static int bond_neigh_init(struct neighbour *n)
 	 *     back to ___neigh_create() / neigh_parms_alloc()
 	 */
 	memset(&parms, 0, sizeof(parms));
-	ret = slave_ops->ndo_neigh_setup(slave->dev, &parms);
+	ret = port_ops->ndo_neigh_setup(port->dev, &parms);
 
 	if (ret)
 		goto out;
@@ -3916,8 +3926,8 @@ static int bond_neigh_init(struct neighbour *n)
 }
 
 /* The bonding ndo_neigh_setup is called at init time beofre any
- * slave exists. So we must declare proxy setup function which will
- * be used at run time to resolve the actual slave neigh param setup.
+ * port exists. So we must declare proxy setup function which will
+ * be used at run time to resolve the actual port neigh param setup.
  *
  * It's also called by upper-level devices (such as vlans) to setup their
  * underlying devices. In that case - do nothing, we're already set up from
@@ -3933,33 +3943,33 @@ static int bond_neigh_setup(struct net_device *dev,
 	return 0;
 }
 
-/* Change the MTU of all of a bond's slaves to match the bond */
+/* Change the MTU of all of a bond's ports to match the bond */
 static int bond_change_mtu(struct net_device *bond_dev, int new_mtu)
 {
 	struct bonding *bond = netdev_priv(bond_dev);
-	struct slave *slave, *rollback_slave;
+	struct bond_port *port, *rollback_port;
 	struct list_head *iter;
 	int res = 0;
 
 	netdev_dbg(bond_dev, "bond=%p, new_mtu=%d\n", bond, new_mtu);
 
-	bond_for_each_slave(bond, slave, iter) {
-		slave_dbg(bond_dev, slave->dev, "s %p c_m %p\n",
-			   slave, slave->dev->netdev_ops->ndo_change_mtu);
+	bond_for_each_port(bond, port, iter) {
+		port_dbg(bond_dev, port->dev, "s %p c_m %p\n",
+			 port, port->dev->netdev_ops->ndo_change_mtu);
 
-		res = dev_set_mtu(slave->dev, new_mtu);
+		res = dev_set_mtu(port->dev, new_mtu);
 
 		if (res) {
-			/* If we failed to set the slave's mtu to the new value
+			/* If we failed to set the port's mtu to the new value
 			 * we must abort the operation even in ACTIVE_BACKUP
-			 * mode, because if we allow the backup slaves to have
-			 * different mtu values than the active slave we'll
+			 * mode, because if we allow the backup ports to have
+			 * different mtu values than the active port we'll
 			 * need to change their mtu when doing a failover. That
 			 * means changing their mtu from timer context, which
 			 * is probably not a good idea.
 			 */
-			slave_dbg(bond_dev, slave->dev, "err %d setting mtu to %d\n",
-				  res, new_mtu);
+			port_dbg(bond_dev, port->dev, "err %d setting mtu to %d\n",
+				 res, new_mtu);
 			goto unwind;
 		}
 	}
@@ -3969,17 +3979,17 @@ static int bond_change_mtu(struct net_device *bond_dev, int new_mtu)
 	return 0;
 
 unwind:
-	/* unwind from head to the slave that failed */
-	bond_for_each_slave(bond, rollback_slave, iter) {
+	/* unwind from head to the port that failed */
+	bond_for_each_port(bond, rollback_port, iter) {
 		int tmp_res;
 
-		if (rollback_slave == slave)
+		if (rollback_port == port)
 			break;
 
-		tmp_res = dev_set_mtu(rollback_slave->dev, bond_dev->mtu);
+		tmp_res = dev_set_mtu(rollback_port->dev, bond_dev->mtu);
 		if (tmp_res)
-			slave_dbg(bond_dev, rollback_slave->dev, "unwind err %d\n",
-				  tmp_res);
+			port_dbg(bond_dev, rollback_port->dev, "unwind err %d\n",
+				 tmp_res);
 	}
 
 	return res;
@@ -3988,13 +3998,13 @@ static int bond_change_mtu(struct net_device *bond_dev, int new_mtu)
 /* Change HW address
  *
  * Note that many devices must be down to change the HW address, and
- * downing the bond releases all slaves.  We can make bonds full of
+ * downing the bond releases all ports.  We can make bonds full of
  * bonding devices to test this, however.
  */
 static int bond_set_mac_address(struct net_device *bond_dev, void *addr)
 {
 	struct bonding *bond = netdev_priv(bond_dev);
-	struct slave *slave, *rollback_slave;
+	struct bond_port *port, *rollback_port;
 	struct sockaddr_storage *ss = addr, tmp_ss;
 	struct list_head *iter;
 	int res = 0;
@@ -4015,19 +4025,18 @@ static int bond_set_mac_address(struct net_device *bond_dev, void *addr)
 	if (!is_valid_ether_addr(ss->__data))
 		return -EADDRNOTAVAIL;
 
-	bond_for_each_slave(bond, slave, iter) {
-		slave_dbg(bond_dev, slave->dev, "%s: slave=%p\n",
-			  __func__, slave);
-		res = dev_set_mac_address(slave->dev, addr, NULL);
+	bond_for_each_port(bond, port, iter) {
+		port_dbg(bond_dev, port->dev, "%s: port=%p\n", __func__, port);
+		res = dev_set_mac_address(port->dev, addr, NULL);
 		if (res) {
-			/* TODO: consider downing the slave
+			/* TODO: consider downing the port
 			 * and retry ?
 			 * User should expect communications
 			 * breakage anyway until ARP finish
 			 * updating, so...
 			 */
-			slave_dbg(bond_dev, slave->dev, "%s: err %d\n",
-				  __func__, res);
+			port_dbg(bond_dev, port->dev, "%s: err %d\n",
+				 __func__, res);
 			goto unwind;
 		}
 	}
@@ -4040,18 +4049,18 @@ static int bond_set_mac_address(struct net_device *bond_dev, void *addr)
 	memcpy(tmp_ss.__data, bond_dev->dev_addr, bond_dev->addr_len);
 	tmp_ss.ss_family = bond_dev->type;
 
-	/* unwind from head to the slave that failed */
-	bond_for_each_slave(bond, rollback_slave, iter) {
+	/* unwind from head to the port that failed */
+	bond_for_each_port(bond, rollback_port, iter) {
 		int tmp_res;
 
-		if (rollback_slave == slave)
+		if (rollback_port == port)
 			break;
 
-		tmp_res = dev_set_mac_address(rollback_slave->dev,
+		tmp_res = dev_set_mac_address(rollback_port->dev,
 					      (struct sockaddr *)&tmp_ss, NULL);
 		if (tmp_res) {
-			slave_dbg(bond_dev, rollback_slave->dev, "%s: unwind err %d\n",
-				   __func__, tmp_res);
+			port_dbg(bond_dev, rollback_port->dev, "%s: unwind err %d\n",
+				 __func__, tmp_res);
 		}
 	}
 
@@ -4059,84 +4068,84 @@ static int bond_set_mac_address(struct net_device *bond_dev, void *addr)
 }
 
 /**
- * bond_get_slave_by_id - get xmit slave with slave_id
+ * bond_get_port_by_id - get xmit port with port_id
  * @bond: bonding device that is transmitting
- * @slave_id: slave id up to slave_cnt-1 through which to transmit
+ * @port_id: port id up to port_cnt-1 through which to transmit
  *
- * This function tries to get slave with slave_id but in case
- * it fails, it tries to find the first available slave for transmission.
+ * This function tries to get port with port_id but in case
+ * it fails, it tries to find the first available port for transmission.
  */
-static struct slave *bond_get_slave_by_id(struct bonding *bond,
-					  int slave_id)
+static struct bond_port *bond_get_port_by_id(struct bonding *bond,
+					  int port_id)
 {
 	struct list_head *iter;
-	struct slave *slave;
-	int i = slave_id;
+	struct bond_port *port;
+	int i = port_id;
 
-	/* Here we start from the slave with slave_id */
-	bond_for_each_slave_rcu(bond, slave, iter) {
+	/* Here we start from the port with port_id */
+	bond_for_each_port_rcu(bond, port, iter) {
 		if (--i < 0) {
-			if (bond_slave_can_tx(slave))
-				return slave;
+			if (bond_port_can_tx(port))
+				return port;
 		}
 	}
 
-	/* Here we start from the first slave up to slave_id */
-	i = slave_id;
-	bond_for_each_slave_rcu(bond, slave, iter) {
+	/* Here we start from the first port up to port_id */
+	i = port_id;
+	bond_for_each_port_rcu(bond, port, iter) {
 		if (--i < 0)
 			break;
-		if (bond_slave_can_tx(slave))
-			return slave;
+		if (bond_port_can_tx(port))
+			return port;
 	}
-	/* no slave that can tx has been found */
+	/* no port that can tx has been found */
 	return NULL;
 }
 
 /**
- * bond_rr_gen_slave_id - generate slave id based on packets_per_slave
+ * bond_rr_gen_port_id - generate port id based on packets_per_port
  * @bond: bonding device to use
  *
- * Based on the value of the bonding device's packets_per_slave parameter
- * this function generates a slave id, which is usually used as the next
- * slave to transmit through.
+ * Based on the value of the bonding device's packets_per_port parameter
+ * this function generates a port id, which is usually used as the next
+ * port to transmit through.
  */
-static u32 bond_rr_gen_slave_id(struct bonding *bond)
+static u32 bond_rr_gen_port_id(struct bonding *bond)
 {
-	u32 slave_id;
-	struct reciprocal_value reciprocal_packets_per_slave;
-	int packets_per_slave = bond->params.packets_per_slave;
+	u32 port_id;
+	struct reciprocal_value reciprocal_packets_per_port;
+	int packets_per_port = bond->params.packets_per_port;
 
-	switch (packets_per_slave) {
+	switch (packets_per_port) {
 	case 0:
-		slave_id = prandom_u32();
+		port_id = prandom_u32();
 		break;
 	case 1:
-		slave_id = bond->rr_tx_counter;
+		port_id = bond->rr_tx_counter;
 		break;
 	default:
-		reciprocal_packets_per_slave =
-			bond->params.reciprocal_packets_per_slave;
-		slave_id = reciprocal_divide(bond->rr_tx_counter,
-					     reciprocal_packets_per_slave);
+		reciprocal_packets_per_port =
+			bond->params.reciprocal_packets_per_port;
+		port_id = reciprocal_divide(bond->rr_tx_counter,
+					     reciprocal_packets_per_port);
 		break;
 	}
 	bond->rr_tx_counter++;
 
-	return slave_id;
+	return port_id;
 }
 
-static struct slave *bond_xmit_roundrobin_slave_get(struct bonding *bond,
+static struct bond_port *bond_xmit_roundrobin_port_get(struct bonding *bond,
 						    struct sk_buff *skb)
 {
-	struct slave *slave;
-	int slave_cnt;
-	u32 slave_id;
+	struct bond_port *port;
+	int port_cnt;
+	u32 port_id;
 
-	/* Start with the curr_active_slave that joined the bond as the
+	/* Start with the curr_active_port that joined the bond as the
 	 * default for sending IGMP traffic.  For failover purposes one
 	 * needs to maintain some consistency for the interface that will
-	 * send the join/membership reports.  The curr_active_slave found
+	 * send the join/membership reports.  The curr_active_port found
 	 * will send all of this type of traffic.
 	 */
 	if (skb->protocol == htons(ETH_P_IP)) {
@@ -4148,18 +4157,18 @@ static struct slave *bond_xmit_roundrobin_slave_get(struct bonding *bond,
 
 		iph = ip_hdr(skb);
 		if (iph->protocol == IPPROTO_IGMP) {
-			slave = rcu_dereference(bond->curr_active_slave);
-			if (slave)
-				return slave;
-			return bond_get_slave_by_id(bond, 0);
+			port = rcu_dereference(bond->curr_active_port);
+			if (port)
+				return port;
+			return bond_get_port_by_id(bond, 0);
 		}
 	}
 
 non_igmp:
-	slave_cnt = READ_ONCE(bond->slave_cnt);
-	if (likely(slave_cnt)) {
-		slave_id = bond_rr_gen_slave_id(bond) % slave_cnt;
-		return bond_get_slave_by_id(bond, slave_id);
+	port_cnt = READ_ONCE(bond->port_cnt);
+	if (likely(port_cnt)) {
+		port_id = bond_rr_gen_port_id(bond) % port_cnt;
+		return bond_get_port_by_id(bond, port_id);
 	}
 	return NULL;
 }
@@ -4168,135 +4177,135 @@ static netdev_tx_t bond_xmit_roundrobin(struct sk_buff *skb,
 					struct net_device *bond_dev)
 {
 	struct bonding *bond = netdev_priv(bond_dev);
-	struct slave *slave;
+	struct bond_port *port;
 
-	slave = bond_xmit_roundrobin_slave_get(bond, skb);
-	if (likely(slave))
-		return bond_dev_queue_xmit(bond, skb, slave->dev);
+	port = bond_xmit_roundrobin_port_get(bond, skb);
+	if (likely(port))
+		return bond_dev_queue_xmit(bond, skb, port->dev);
 
 	return bond_tx_drop(bond_dev, skb);
 }
 
-static struct slave *bond_xmit_activebackup_slave_get(struct bonding *bond,
+static struct bond_port *bond_xmit_activebackup_port_get(struct bonding *bond,
 						      struct sk_buff *skb)
 {
-	return rcu_dereference(bond->curr_active_slave);
+	return rcu_dereference(bond->curr_active_port);
 }
 
-/* In active-backup mode, we know that bond->curr_active_slave is always valid if
+/* In active-backup mode, we know that bond->curr_active_port is always valid if
  * the bond has a usable interface.
  */
 static netdev_tx_t bond_xmit_activebackup(struct sk_buff *skb,
 					  struct net_device *bond_dev)
 {
 	struct bonding *bond = netdev_priv(bond_dev);
-	struct slave *slave;
+	struct bond_port *port;
 
-	slave = bond_xmit_activebackup_slave_get(bond, skb);
-	if (slave)
-		return bond_dev_queue_xmit(bond, skb, slave->dev);
+	port = bond_xmit_activebackup_port_get(bond, skb);
+	if (port)
+		return bond_dev_queue_xmit(bond, skb, port->dev);
 
 	return bond_tx_drop(bond_dev, skb);
 }
 
-/* Use this to update slave_array when (a) it's not appropriate to update
- * slave_array right away (note that update_slave_array() may sleep)
+/* Use this to update port_array when (a) it's not appropriate to update
+ * port_array right away (note that update_port_array() may sleep)
  * and / or (b) RTNL is not held.
  */
-void bond_slave_arr_work_rearm(struct bonding *bond, unsigned long delay)
+void bond_port_arr_work_rearm(struct bonding *bond, unsigned long delay)
 {
-	queue_delayed_work(bond->wq, &bond->slave_arr_work, delay);
+	queue_delayed_work(bond->wq, &bond->port_arr_work, delay);
 }
 
-/* Slave array work handler. Holds only RTNL */
-static void bond_slave_arr_handler(struct work_struct *work)
+/* port array work handler. Holds only RTNL */
+static void bond_port_arr_handler(struct work_struct *work)
 {
 	struct bonding *bond = container_of(work, struct bonding,
-					    slave_arr_work.work);
+					    port_arr_work.work);
 	int ret;
 
 	if (!rtnl_trylock())
 		goto err;
 
-	ret = bond_update_slave_arr(bond, NULL);
+	ret = bond_update_port_arr(bond, NULL);
 	rtnl_unlock();
 	if (ret) {
-		pr_warn_ratelimited("Failed to update slave array from WT\n");
+		pr_warn_ratelimited("Failed to update port array from WT\n");
 		goto err;
 	}
 	return;
 
 err:
-	bond_slave_arr_work_rearm(bond, 1);
+	bond_port_arr_work_rearm(bond, 1);
 }
 
-static void bond_skip_slave(struct bond_up_slave *slaves,
-			    struct slave *skipslave)
+static void bond_skip_port(struct bond_up_port *ports,
+			   struct bond_port *skipport)
 {
 	int idx;
 
 	/* Rare situation where caller has asked to skip a specific
-	 * slave but allocation failed (most likely!). BTW this is
+	 * port but allocation failed (most likely!). BTW this is
 	 * only possible when the call is initiated from
 	 * __bond_release_one(). In this situation; overwrite the
-	 * skipslave entry in the array with the last entry from the
+	 * skipport entry in the array with the last entry from the
 	 * array to avoid a situation where the xmit path may choose
-	 * this to-be-skipped slave to send a packet out.
+	 * this to-be-skipped port to send a packet out.
 	 */
-	for (idx = 0; slaves && idx < slaves->count; idx++) {
-		if (skipslave == slaves->arr[idx]) {
-			slaves->arr[idx] =
-				slaves->arr[slaves->count - 1];
-			slaves->count--;
+	for (idx = 0; ports && idx < ports->count; idx++) {
+		if (skipport == ports->arr[idx]) {
+			ports->arr[idx] =
+				ports->arr[ports->count - 1];
+			ports->count--;
 			break;
 		}
 	}
 }
 
-static void bond_set_slave_arr(struct bonding *bond,
-			       struct bond_up_slave *usable_slaves,
-			       struct bond_up_slave *all_slaves)
+static void bond_set_port_arr(struct bonding *bond,
+			       struct bond_up_port *usable_ports,
+			       struct bond_up_port *all_ports)
 {
-	struct bond_up_slave *usable, *all;
+	struct bond_up_port *usable, *all;
 
-	usable = rtnl_dereference(bond->usable_slaves);
-	rcu_assign_pointer(bond->usable_slaves, usable_slaves);
+	usable = rtnl_dereference(bond->usable_ports);
+	rcu_assign_pointer(bond->usable_ports, usable_ports);
 	kfree_rcu(usable, rcu);
 
-	all = rtnl_dereference(bond->all_slaves);
-	rcu_assign_pointer(bond->all_slaves, all_slaves);
+	all = rtnl_dereference(bond->all_ports);
+	rcu_assign_pointer(bond->all_ports, all_ports);
 	kfree_rcu(all, rcu);
 }
 
-static void bond_reset_slave_arr(struct bonding *bond)
+static void bond_reset_port_arr(struct bonding *bond)
 {
-	struct bond_up_slave *usable, *all;
+	struct bond_up_port *usable, *all;
 
-	usable = rtnl_dereference(bond->usable_slaves);
+	usable = rtnl_dereference(bond->usable_ports);
 	if (usable) {
-		RCU_INIT_POINTER(bond->usable_slaves, NULL);
+		RCU_INIT_POINTER(bond->usable_ports, NULL);
 		kfree_rcu(usable, rcu);
 	}
 
-	all = rtnl_dereference(bond->all_slaves);
+	all = rtnl_dereference(bond->all_ports);
 	if (all) {
-		RCU_INIT_POINTER(bond->all_slaves, NULL);
+		RCU_INIT_POINTER(bond->all_ports, NULL);
 		kfree_rcu(all, rcu);
 	}
 }
 
-/* Build the usable slaves array in control path for modes that use xmit-hash
- * to determine the slave interface -
+/* Build the usable ports array in control path for modes that use xmit-hash
+ * to determine the port interface -
  * (a) BOND_MODE_8023AD
  * (b) BOND_MODE_XOR
  * (c) (BOND_MODE_TLB || BOND_MODE_ALB) && tlb_dynamic_lb == 0
  *
  * The caller is expected to hold RTNL only and NO other lock!
  */
-int bond_update_slave_arr(struct bonding *bond, struct slave *skipslave)
+int bond_update_port_arr(struct bonding *bond, struct bond_port *skipport)
 {
-	struct bond_up_slave *usable_slaves = NULL, *all_slaves = NULL;
-	struct slave *slave;
+	struct bond_up_port *usable_ports = NULL, *all_ports = NULL;
+	struct bond_port *port;
 	struct list_head *iter;
 	int agg_id = 0;
 	int ret = 0;
@@ -4305,11 +4314,11 @@ int bond_update_slave_arr(struct bonding *bond, struct slave *skipslave)
 	WARN_ON(lockdep_is_held(&bond->mode_lock));
 #endif
 
-	usable_slaves = kzalloc(struct_size(usable_slaves, arr,
-					    bond->slave_cnt), GFP_KERNEL);
-	all_slaves = kzalloc(struct_size(all_slaves, arr,
-					 bond->slave_cnt), GFP_KERNEL);
-	if (!usable_slaves || !all_slaves) {
+	usable_ports = kzalloc(struct_size(usable_ports, arr,
+					    bond->port_cnt), GFP_KERNEL);
+	all_ports = kzalloc(struct_size(all_ports, arr,
+					 bond->port_cnt), GFP_KERNEL);
+	if (!usable_ports || !all_ports) {
 		ret = -ENOMEM;
 		goto out;
 	}
@@ -4321,79 +4330,79 @@ int bond_update_slave_arr(struct bonding *bond, struct slave *skipslave)
 			/* No active aggragator means it's not safe to use
 			 * the previous array.
 			 */
-			bond_reset_slave_arr(bond);
+			bond_reset_port_arr(bond);
 			goto out;
 		}
 		agg_id = ad_info.aggregator_id;
 	}
-	bond_for_each_slave(bond, slave, iter) {
-		if (skipslave == slave)
+	bond_for_each_port(bond, port, iter) {
+		if (skipport == port)
 			continue;
 
-		all_slaves->arr[all_slaves->count++] = slave;
+		all_ports->arr[all_ports->count++] = port;
 		if (BOND_MODE(bond) == BOND_MODE_8023AD) {
 			struct aggregator *agg;
 
-			agg = SLAVE_AD_INFO(slave)->ad_port.aggregator;
+			agg = PORT_AD_INFO(port)->ad_port.aggregator;
 			if (!agg || agg->aggregator_identifier != agg_id)
 				continue;
 		}
-		if (!bond_slave_can_tx(slave))
+		if (!bond_port_can_tx(port))
 			continue;
 
-		slave_dbg(bond->dev, slave->dev, "Adding slave to tx hash array[%d]\n",
-			  usable_slaves->count);
+		port_dbg(bond->dev, port->dev, "Adding port to tx hash array[%d]\n",
+			 usable_ports->count);
 
-		usable_slaves->arr[usable_slaves->count++] = slave;
+		usable_ports->arr[usable_ports->count++] = port;
 	}
 
-	bond_set_slave_arr(bond, usable_slaves, all_slaves);
+	bond_set_port_arr(bond, usable_ports, all_ports);
 	return ret;
 out:
-	if (ret != 0 && skipslave) {
-		bond_skip_slave(rtnl_dereference(bond->all_slaves),
-				skipslave);
-		bond_skip_slave(rtnl_dereference(bond->usable_slaves),
-				skipslave);
+	if (ret != 0 && skipport) {
+		bond_skip_port(rtnl_dereference(bond->all_ports),
+				skipport);
+		bond_skip_port(rtnl_dereference(bond->usable_ports),
+				skipport);
 	}
-	kfree_rcu(all_slaves, rcu);
-	kfree_rcu(usable_slaves, rcu);
+	kfree_rcu(all_ports, rcu);
+	kfree_rcu(usable_ports, rcu);
 
 	return ret;
 }
 
-static struct slave *bond_xmit_3ad_xor_slave_get(struct bonding *bond,
+static struct bond_port *bond_xmit_3ad_xor_port_get(struct bonding *bond,
 						 struct sk_buff *skb,
-						 struct bond_up_slave *slaves)
+						 struct bond_up_port *ports)
 {
-	struct slave *slave;
+	struct bond_port *port;
 	unsigned int count;
 	u32 hash;
 
 	hash = bond_xmit_hash(bond, skb);
-	count = slaves ? READ_ONCE(slaves->count) : 0;
+	count = ports ? READ_ONCE(ports->count) : 0;
 	if (unlikely(!count))
 		return NULL;
 
-	slave = slaves->arr[hash % count];
-	return slave;
+	port = ports->arr[hash % count];
+	return port;
 }
 
 /* Use this Xmit function for 3AD as well as XOR modes. The current
- * usable slave array is formed in the control path. The xmit function
+ * usable port array is formed in the control path. The xmit function
  * just calculates hash and sends the packet out.
  */
 static netdev_tx_t bond_3ad_xor_xmit(struct sk_buff *skb,
 				     struct net_device *dev)
 {
 	struct bonding *bond = netdev_priv(dev);
-	struct bond_up_slave *slaves;
-	struct slave *slave;
+	struct bond_up_port *ports;
+	struct bond_port *port;
 
-	slaves = rcu_dereference(bond->usable_slaves);
-	slave = bond_xmit_3ad_xor_slave_get(bond, skb, slaves);
-	if (likely(slave))
-		return bond_dev_queue_xmit(bond, skb, slave->dev);
+	ports = rcu_dereference(bond->usable_ports);
+	port = bond_xmit_3ad_xor_port_get(bond, skb, ports);
+	if (likely(port))
+		return bond_dev_queue_xmit(bond, skb, port->dev);
 
 	return bond_tx_drop(dev, skb);
 }
@@ -4403,13 +4412,13 @@ static netdev_tx_t bond_xmit_broadcast(struct sk_buff *skb,
 				       struct net_device *bond_dev)
 {
 	struct bonding *bond = netdev_priv(bond_dev);
-	struct slave *slave = NULL;
+	struct bond_port *port = NULL;
 	struct list_head *iter;
 
-	bond_for_each_slave_rcu(bond, slave, iter) {
-		if (bond_is_last_slave(bond, slave))
+	bond_for_each_port_rcu(bond, port, iter) {
+		if (bond_is_last_port(bond, port))
 			break;
-		if (bond_slave_is_up(slave) && slave->link == BOND_LINK_UP) {
+		if (bond_port_is_up(port) && port->link == BOND_LINK_UP) {
 			struct sk_buff *skb2 = skb_clone(skb, GFP_ATOMIC);
 
 			if (!skb2) {
@@ -4417,36 +4426,36 @@ static netdev_tx_t bond_xmit_broadcast(struct sk_buff *skb,
 						    bond_dev->name, __func__);
 				continue;
 			}
-			bond_dev_queue_xmit(bond, skb2, slave->dev);
+			bond_dev_queue_xmit(bond, skb2, port->dev);
 		}
 	}
-	if (slave && bond_slave_is_up(slave) && slave->link == BOND_LINK_UP)
-		return bond_dev_queue_xmit(bond, skb, slave->dev);
+	if (port && bond_port_is_up(port) && port->link == BOND_LINK_UP)
+		return bond_dev_queue_xmit(bond, skb, port->dev);
 
 	return bond_tx_drop(bond_dev, skb);
 }
 
 /*------------------------- Device initialization ---------------------------*/
 
-/* Lookup the slave that corresponds to a qid */
-static inline int bond_slave_override(struct bonding *bond,
+/* Lookup the port that corresponds to a qid */
+static inline int bond_port_override(struct bonding *bond,
 				      struct sk_buff *skb)
 {
-	struct slave *slave = NULL;
+	struct bond_port *port = NULL;
 	struct list_head *iter;
 
 	if (!skb_rx_queue_recorded(skb))
 		return 1;
 
-	/* Find out if any slaves have the same mapping as this skb. */
-	bond_for_each_slave_rcu(bond, slave, iter) {
-		if (slave->queue_id == skb_get_queue_mapping(skb)) {
-			if (bond_slave_is_up(slave) &&
-			    slave->link == BOND_LINK_UP) {
-				bond_dev_queue_xmit(bond, skb, slave->dev);
+	/* Find out if any ports have the same mapping as this skb. */
+	bond_for_each_port_rcu(bond, port, iter) {
+		if (port->queue_id == skb_get_queue_mapping(skb)) {
+			if (bond_port_is_up(port) &&
+			    port->link == BOND_LINK_UP) {
+				bond_dev_queue_xmit(bond, skb, port->dev);
 				return 0;
 			}
-			/* If the slave isn't UP, use default transmit policy. */
+			/* If the port isn't UP, use default transmit policy. */
 			break;
 		}
 	}
@@ -4476,36 +4485,36 @@ static u16 bond_select_queue(struct net_device *dev, struct sk_buff *skb,
 	return txq;
 }
 
-static struct net_device *bond_xmit_get_slave(struct net_device *bond_dev,
-					      struct sk_buff *skb,
-					      bool all_slaves)
+static struct net_device *bond_xmit_get_port(struct net_device *bond_dev,
+					     struct sk_buff *skb,
+					     bool all_ports)
 {
 	struct bonding *bond = netdev_priv(bond_dev);
-	struct bond_up_slave *slaves;
-	struct slave *slave = NULL;
+	struct bond_up_port *ports;
+	struct bond_port *port = NULL;
 
 	switch (BOND_MODE(bond)) {
 	case BOND_MODE_ROUNDROBIN:
-		slave = bond_xmit_roundrobin_slave_get(bond, skb);
+		port = bond_xmit_roundrobin_port_get(bond, skb);
 		break;
 	case BOND_MODE_ACTIVEBACKUP:
-		slave = bond_xmit_activebackup_slave_get(bond, skb);
+		port = bond_xmit_activebackup_port_get(bond, skb);
 		break;
 	case BOND_MODE_8023AD:
 	case BOND_MODE_XOR:
-		if (all_slaves)
-			slaves = rcu_dereference(bond->all_slaves);
+		if (all_ports)
+			ports = rcu_dereference(bond->all_ports);
 		else
-			slaves = rcu_dereference(bond->usable_slaves);
-		slave = bond_xmit_3ad_xor_slave_get(bond, skb, slaves);
+			ports = rcu_dereference(bond->usable_ports);
+		port = bond_xmit_3ad_xor_port_get(bond, skb, ports);
 		break;
 	case BOND_MODE_BROADCAST:
 		break;
 	case BOND_MODE_ALB:
-		slave = bond_xmit_alb_slave_get(bond, skb);
+		port = bond_xmit_alb_port_get(bond, skb);
 		break;
 	case BOND_MODE_TLB:
-		slave = bond_xmit_tlb_slave_get(bond, skb);
+		port = bond_xmit_tlb_port_get(bond, skb);
 		break;
 	default:
 		/* Should never happen, mode already checked */
@@ -4513,8 +4522,8 @@ static struct net_device *bond_xmit_get_slave(struct net_device *bond_dev,
 		break;
 	}
 
-	if (slave)
-		return slave->dev;
+	if (port)
+		return port->dev;
 	return NULL;
 }
 
@@ -4523,7 +4532,7 @@ static netdev_tx_t __bond_start_xmit(struct sk_buff *skb, struct net_device *dev
 	struct bonding *bond = netdev_priv(dev);
 
 	if (bond_should_override_tx_queue(bond) &&
-	    !bond_slave_override(bond, skb))
+	    !bond_port_override(bond, skb))
 		return NETDEV_TX_OK;
 
 	switch (BOND_MODE(bond)) {
@@ -4560,7 +4569,7 @@ static netdev_tx_t bond_start_xmit(struct sk_buff *skb, struct net_device *dev)
 		return NETDEV_TX_BUSY;
 
 	rcu_read_lock();
-	if (bond_has_slaves(bond))
+	if (bond_has_ports(bond))
 		ret = __bond_start_xmit(skb, dev);
 	else
 		ret = bond_tx_drop(dev, skb);
@@ -4569,12 +4578,12 @@ static netdev_tx_t bond_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	return ret;
 }
 
-static u32 bond_mode_bcast_speed(struct slave *slave, u32 speed)
+static u32 bond_mode_bcast_speed(struct bond_port *port, u32 speed)
 {
 	if (speed == 0 || speed == SPEED_UNKNOWN)
-		speed = slave->speed;
+		speed = port->speed;
 	else
-		speed = min(speed, slave->speed);
+		speed = min(speed, port->speed);
 
 	return speed;
 }
@@ -4584,29 +4593,29 @@ static int bond_ethtool_get_link_ksettings(struct net_device *bond_dev,
 {
 	struct bonding *bond = netdev_priv(bond_dev);
 	struct list_head *iter;
-	struct slave *slave;
+	struct bond_port *port;
 	u32 speed = 0;
 
 	cmd->base.duplex = DUPLEX_UNKNOWN;
 	cmd->base.port = PORT_OTHER;
 
-	/* Since bond_slave_can_tx returns false for all inactive or down slaves, we
+	/* Since bond_port_can_tx returns false for all inactive or down ports, we
 	 * do not need to check mode.  Though link speed might not represent
 	 * the true receive or transmit bandwidth (not all modes are symmetric)
 	 * this is an accurate maximum.
 	 */
-	bond_for_each_slave(bond, slave, iter) {
-		if (bond_slave_can_tx(slave)) {
-			if (slave->speed != SPEED_UNKNOWN) {
+	bond_for_each_port(bond, port, iter) {
+		if (bond_port_can_tx(port)) {
+			if (port->speed != SPEED_UNKNOWN) {
 				if (BOND_MODE(bond) == BOND_MODE_BROADCAST)
-					speed = bond_mode_bcast_speed(slave,
+					speed = bond_mode_bcast_speed(port,
 								      speed);
 				else
-					speed += slave->speed;
+					speed += port->speed;
 			}
 			if (cmd->base.duplex == DUPLEX_UNKNOWN &&
-			    slave->duplex != DUPLEX_UNKNOWN)
-				cmd->base.duplex = slave->duplex;
+			    port->duplex != DUPLEX_UNKNOWN)
+				cmd->base.duplex = port->duplex;
 		}
 	}
 	cmd->base.speed = speed ? : SPEED_UNKNOWN;
@@ -4649,11 +4658,11 @@ static const struct net_device_ops bond_netdev_ops = {
 	.ndo_netpoll_cleanup	= bond_netpoll_cleanup,
 	.ndo_poll_controller	= bond_poll_controller,
 #endif
-	.ndo_add_slave		= bond_enslave,
+	.ndo_add_slave		= bond_connect,
 	.ndo_del_slave		= bond_release,
 	.ndo_fix_features	= bond_fix_features,
 	.ndo_features_check	= passthru_features_check,
-	.ndo_get_xmit_slave	= bond_xmit_get_slave,
+	.ndo_get_xmit_slave	= bond_xmit_get_port,
 };
 
 static const struct device_type bond_type = {
@@ -4705,7 +4714,7 @@ void bond_setup(struct net_device *bond_dev)
 	/* By default, we declare the bond to be fully
 	 * VLAN hardware accelerated capable. Special
 	 * care is taken in the various xmit functions
-	 * when there are slaves that are not hw accel
+	 * when there are ports that are not hw accel
 	 * capable
 	 */
 
@@ -4735,26 +4744,26 @@ void bond_setup(struct net_device *bond_dev)
 static void bond_uninit(struct net_device *bond_dev)
 {
 	struct bonding *bond = netdev_priv(bond_dev);
-	struct bond_up_slave *usable, *all;
+	struct bond_up_port *usable, *all;
 	struct list_head *iter;
-	struct slave *slave;
+	struct bond_port *port;
 
 	bond_netpoll_cleanup(bond_dev);
 
-	/* Release the bonded slaves */
-	bond_for_each_slave(bond, slave, iter)
-		__bond_release_one(bond_dev, slave->dev, true, true);
-	netdev_info(bond_dev, "Released all slaves\n");
+	/* Release the bonded ports */
+	bond_for_each_port(bond, port, iter)
+		__bond_release_one(bond_dev, port->dev, true, true);
+	netdev_info(bond_dev, "Released all ports\n");
 
-	usable = rtnl_dereference(bond->usable_slaves);
+	usable = rtnl_dereference(bond->usable_ports);
 	if (usable) {
-		RCU_INIT_POINTER(bond->usable_slaves, NULL);
+		RCU_INIT_POINTER(bond->usable_ports, NULL);
 		kfree_rcu(usable, rcu);
 	}
 
-	all = rtnl_dereference(bond->all_slaves);
+	all = rtnl_dereference(bond->all_ports);
 	if (all) {
-		RCU_INIT_POINTER(bond->all_slaves, NULL);
+		RCU_INIT_POINTER(bond->all_ports, NULL);
 		kfree_rcu(all, rcu);
 	}
 
@@ -4893,10 +4902,10 @@ static int bond_check_params(struct bond_params *params)
 		tx_queues = BOND_DEFAULT_TX_QUEUES;
 	}
 
-	if ((all_slaves_active != 0) && (all_slaves_active != 1)) {
-		pr_warn("Warning: all_slaves_active module parameter (%d), not of valid value (0/1), so it was set to 0\n",
-			all_slaves_active);
-		all_slaves_active = 0;
+	if ((apa != 0) && (apa != 1)) {
+		pr_warn("Warning: all_ports_active module parameter (%d), not of valid value (0/1), so it was set to 0\n",
+			apa);
+		apa = 0;
 	}
 
 	if (resend_igmp < 0 || resend_igmp > 255) {
@@ -4905,11 +4914,11 @@ static int bond_check_params(struct bond_params *params)
 		resend_igmp = BOND_DEFAULT_RESEND_IGMP;
 	}
 
-	bond_opt_initval(&newval, packets_per_slave);
-	if (!bond_opt_parse(bond_opt_get(BOND_OPT_PACKETS_PER_SLAVE), &newval)) {
-		pr_warn("Warning: packets_per_slave (%d) should be between 0 and %u resetting to 1\n",
-			packets_per_slave, USHRT_MAX);
-		packets_per_slave = 1;
+	bond_opt_initval(&newval, rr_ppp);
+	if (!bond_opt_parse(bond_opt_get(BOND_OPT_PACKETS_PER_PORT), &newval)) {
+		pr_warn("Warning: packets_per_port (%d) should be between 0 and %u resetting to 1\n",
+			rr_ppp, USHRT_MAX);
+		rr_ppp = 1;
 	}
 
 	if (bond_mode == BOND_MODE_ALB) {
@@ -5121,23 +5130,23 @@ static int bond_check_params(struct bond_params *params)
 	params->primary_reselect = primary_reselect_value;
 	params->fail_over_mac = fail_over_mac_value;
 	params->tx_queues = tx_queues;
-	params->all_slaves_active = all_slaves_active;
+	params->all_ports_active = apa;
 	params->resend_igmp = resend_igmp;
 	params->min_links = min_links;
 	params->lp_interval = lp_interval;
-	params->packets_per_slave = packets_per_slave;
+	params->packets_per_port = rr_ppp;
 	params->tlb_dynamic_lb = tlb_dynamic_lb;
 	params->ad_actor_sys_prio = ad_actor_sys_prio;
 	eth_zero_addr(params->ad_actor_system);
 	params->ad_user_port_key = ad_user_port_key;
-	if (packets_per_slave > 0) {
-		params->reciprocal_packets_per_slave =
-			reciprocal_value(packets_per_slave);
+	if (rr_ppp > 0) {
+		params->reciprocal_packets_per_port =
+			reciprocal_value(rr_ppp);
 	} else {
-		/* reciprocal_packets_per_slave is unused if
-		 * packets_per_slave is 0 or 1, just initialize it
+		/* reciprocal_packets_per_port is unused if
+		 * packets_per_port is 0 or 1, just initialize it
 		 */
-		params->reciprocal_packets_per_slave =
+		params->reciprocal_packets_per_port =
 			(struct reciprocal_value) { 0 };
 	}
 
diff --git a/drivers/net/bonding/bond_netlink.c b/drivers/net/bonding/bond_netlink.c
index fa7304d3eefe..9e0be0bc8000 100644
--- a/drivers/net/bonding/bond_netlink.c
+++ b/drivers/net/bonding/bond_netlink.c
@@ -15,8 +15,8 @@
 #include <net/rtnetlink.h>
 #include <net/bonding.h>
 
-static size_t bond_get_slave_size(const struct net_device *bond_dev,
-				  const struct net_device *slave_dev)
+static size_t bond_get_port_size(const struct net_device *bond_dev,
+				 const struct net_device *port_dev)
 {
 	return nla_total_size(sizeof(u8)) +	/* IFLA_BOND_SLAVE_STATE */
 		nla_total_size(sizeof(u8)) +	/* IFLA_BOND_SLAVE_MII_STATUS */
@@ -29,35 +29,35 @@ static size_t bond_get_slave_size(const struct net_device *bond_dev,
 		0;
 }
 
-static int bond_fill_slave_info(struct sk_buff *skb,
-				const struct net_device *bond_dev,
-				const struct net_device *slave_dev)
+static int bond_fill_port_info(struct sk_buff *skb,
+			       const struct net_device *bond_dev,
+			       const struct net_device *port_dev)
 {
-	struct slave *slave = bond_slave_get_rtnl(slave_dev);
+	struct bond_port *port = bond_port_get_rtnl(port_dev);
 
-	if (nla_put_u8(skb, IFLA_BOND_SLAVE_STATE, bond_slave_state(slave)))
+	if (nla_put_u8(skb, IFLA_BOND_SLAVE_STATE, bond_port_state(port)))
 		goto nla_put_failure;
 
-	if (nla_put_u8(skb, IFLA_BOND_SLAVE_MII_STATUS, slave->link))
+	if (nla_put_u8(skb, IFLA_BOND_SLAVE_MII_STATUS, port->link))
 		goto nla_put_failure;
 
 	if (nla_put_u32(skb, IFLA_BOND_SLAVE_LINK_FAILURE_COUNT,
-			slave->link_failure_count))
+			port->link_failure_count))
 		goto nla_put_failure;
 
 	if (nla_put(skb, IFLA_BOND_SLAVE_PERM_HWADDR,
-		    slave_dev->addr_len, slave->perm_hwaddr))
+		    port_dev->addr_len, port->perm_hwaddr))
 		goto nla_put_failure;
 
-	if (nla_put_u16(skb, IFLA_BOND_SLAVE_QUEUE_ID, slave->queue_id))
+	if (nla_put_u16(skb, IFLA_BOND_SLAVE_QUEUE_ID, port->queue_id))
 		goto nla_put_failure;
 
-	if (BOND_MODE(slave->bond) == BOND_MODE_8023AD) {
+	if (BOND_MODE(port->bond) == BOND_MODE_8023AD) {
 		const struct aggregator *agg;
 		const struct ad_port *ad_port;
 
-		ad_port = &SLAVE_AD_INFO(slave)->ad_port;
-		agg = SLAVE_AD_INFO(slave)->ad_port.aggregator;
+		ad_port = &PORT_AD_INFO(port)->ad_port;
+		agg = PORT_AD_INFO(port)->ad_port.aggregator;
 		if (agg) {
 			if (nla_put_u16(skb, IFLA_BOND_SLAVE_AD_AGGREGATOR_ID,
 					agg->aggregator_identifier))
@@ -111,7 +111,7 @@ static const struct nla_policy bond_policy[IFLA_BOND_MAX + 1] = {
 	[IFLA_BOND_PEER_NOTIF_DELAY]    = { .type = NLA_U32 },
 };
 
-static const struct nla_policy bond_slave_policy[IFLA_BOND_SLAVE_MAX + 1] = {
+static const struct nla_policy bond_port_policy[IFLA_BOND_SLAVE_MAX + 1] = {
 	[IFLA_BOND_SLAVE_QUEUE_ID]	= { .type = NLA_U16 },
 };
 
@@ -127,10 +127,10 @@ static int bond_validate(struct nlattr *tb[], struct nlattr *data[],
 	return 0;
 }
 
-static int bond_slave_changelink(struct net_device *bond_dev,
-				 struct net_device *slave_dev,
-				 struct nlattr *tb[], struct nlattr *data[],
-				 struct netlink_ext_ack *extack)
+static int bond_port_changelink(struct net_device *bond_dev,
+				struct net_device *port_dev,
+				struct nlattr *tb[], struct nlattr *data[],
+				struct netlink_ext_ack *extack)
 {
 	struct bonding *bond = netdev_priv(bond_dev);
 	struct bond_opt_value newval;
@@ -143,9 +143,9 @@ static int bond_slave_changelink(struct net_device *bond_dev,
 		u16 queue_id = nla_get_u16(data[IFLA_BOND_SLAVE_QUEUE_ID]);
 		char queue_id_str[IFNAMSIZ + 7];
 
-		/* queue_id option setting expects slave_name:queue_id */
+		/* queue_id option setting expects port_name:queue_id */
 		snprintf(queue_id_str, sizeof(queue_id_str), "%s:%u\n",
-			 slave_dev->name, queue_id);
+			 port_dev->name, queue_id);
 		bond_opt_initstr(&newval, queue_id_str);
 		err = __bond_opt_set(bond, BOND_OPT_QUEUE_ID, &newval);
 		if (err)
@@ -177,18 +177,18 @@ static int bond_changelink(struct net_device *bond_dev, struct nlattr *tb[],
 	}
 	if (data[IFLA_BOND_ACTIVE_SLAVE]) {
 		int ifindex = nla_get_u32(data[IFLA_BOND_ACTIVE_SLAVE]);
-		struct net_device *slave_dev;
-		char *active_slave = "";
+		struct net_device *port_dev;
+		char *active_port = "";
 
 		if (ifindex != 0) {
-			slave_dev = __dev_get_by_index(dev_net(bond_dev),
-						       ifindex);
-			if (!slave_dev)
+			port_dev = __dev_get_by_index(dev_net(bond_dev),
+						      ifindex);
+			if (!port_dev)
 				return -ENODEV;
-			active_slave = slave_dev->name;
+			active_port = port_dev->name;
 		}
-		bond_opt_initstr(&newval, active_slave);
-		err = __bond_opt_set(bond, BOND_OPT_ACTIVE_SLAVE, &newval);
+		bond_opt_initstr(&newval, active_port);
+		err = __bond_opt_set(bond, BOND_OPT_ACTIVE_PORT, &newval);
 		if (err)
 			return err;
 	}
@@ -352,11 +352,11 @@ static int bond_changelink(struct net_device *bond_dev, struct nlattr *tb[],
 			return err;
 	}
 	if (data[IFLA_BOND_ALL_SLAVES_ACTIVE]) {
-		int all_slaves_active =
+		int all_ports_active =
 			nla_get_u8(data[IFLA_BOND_ALL_SLAVES_ACTIVE]);
 
-		bond_opt_initval(&newval, all_slaves_active);
-		err = __bond_opt_set(bond, BOND_OPT_ALL_SLAVES_ACTIVE, &newval);
+		bond_opt_initval(&newval, all_ports_active);
+		err = __bond_opt_set(bond, BOND_OPT_ALL_PORTS_ACTIVE, &newval);
 		if (err)
 			return err;
 	}
@@ -379,11 +379,11 @@ static int bond_changelink(struct net_device *bond_dev, struct nlattr *tb[],
 			return err;
 	}
 	if (data[IFLA_BOND_PACKETS_PER_SLAVE]) {
-		int packets_per_slave =
+		int packets_per_port =
 			nla_get_u32(data[IFLA_BOND_PACKETS_PER_SLAVE]);
 
-		bond_opt_initval(&newval, packets_per_slave);
-		err = __bond_opt_set(bond, BOND_OPT_PACKETS_PER_SLAVE, &newval);
+		bond_opt_initval(&newval, packets_per_port);
+		err = __bond_opt_set(bond, BOND_OPT_PACKETS_PER_PORT, &newval);
 		if (err)
 			return err;
 	}
@@ -506,14 +506,14 @@ static size_t bond_get_size(const struct net_device *bond_dev)
 		0;
 }
 
-static int bond_option_active_slave_get_ifindex(struct bonding *bond)
+static int bond_option_active_port_get_ifindex(struct bonding *bond)
 {
-	const struct net_device *slave;
+	const struct net_device *port;
 	int ifindex;
 
 	rcu_read_lock();
-	slave = bond_option_active_slave_get_rcu(bond);
-	ifindex = slave ? slave->ifindex : 0;
+	port = bond_option_active_port_get_rcu(bond);
+	ifindex = port ? port->ifindex : 0;
 	rcu_read_unlock();
 	return ifindex;
 }
@@ -522,15 +522,15 @@ static int bond_fill_info(struct sk_buff *skb,
 			  const struct net_device *bond_dev)
 {
 	struct bonding *bond = netdev_priv(bond_dev);
-	unsigned int packets_per_slave;
+	unsigned int packets_per_port;
 	int ifindex, i, targets_added;
 	struct nlattr *targets;
-	struct slave *primary;
+	struct bond_port *primary;
 
 	if (nla_put_u8(skb, IFLA_BOND_MODE, BOND_MODE(bond)))
 		goto nla_put_failure;
 
-	ifindex = bond_option_active_slave_get_ifindex(bond);
+	ifindex = bond_option_active_port_get_ifindex(bond);
 	if (ifindex && nla_put_u32(skb, IFLA_BOND_ACTIVE_SLAVE, ifindex))
 		goto nla_put_failure;
 
@@ -580,7 +580,7 @@ static int bond_fill_info(struct sk_buff *skb,
 			bond->params.arp_all_targets))
 		goto nla_put_failure;
 
-	primary = rtnl_dereference(bond->primary_slave);
+	primary = rtnl_dereference(bond->primary_port);
 	if (primary &&
 	    nla_put_u32(skb, IFLA_BOND_PRIMARY, primary->dev->ifindex))
 		goto nla_put_failure;
@@ -606,7 +606,7 @@ static int bond_fill_info(struct sk_buff *skb,
 		goto nla_put_failure;
 
 	if (nla_put_u8(skb, IFLA_BOND_ALL_SLAVES_ACTIVE,
-		       bond->params.all_slaves_active))
+		       bond->params.all_ports_active))
 		goto nla_put_failure;
 
 	if (nla_put_u32(skb, IFLA_BOND_MIN_LINKS,
@@ -617,9 +617,9 @@ static int bond_fill_info(struct sk_buff *skb,
 			bond->params.lp_interval))
 		goto nla_put_failure;
 
-	packets_per_slave = bond->params.packets_per_slave;
+	packets_per_port = bond->params.packets_per_port;
 	if (nla_put_u32(skb, IFLA_BOND_PACKETS_PER_SLAVE,
-			packets_per_slave))
+			packets_per_port))
 		goto nla_put_failure;
 
 	if (nla_put_u8(skb, IFLA_BOND_AD_LACP_RATE,
@@ -702,7 +702,7 @@ static int bond_fill_linkxstats(struct sk_buff *skb,
 				int *prividx, int attr)
 {
 	struct nlattr *nla __maybe_unused;
-	struct slave *slave = NULL;
+	struct bond_port *port = NULL;
 	struct nlattr *nest, *nest2;
 	struct bonding *bond;
 
@@ -711,10 +711,10 @@ static int bond_fill_linkxstats(struct sk_buff *skb,
 		bond = netdev_priv(dev);
 		break;
 	case IFLA_STATS_LINK_XSTATS_SLAVE:
-		slave = bond_slave_get_rtnl(dev);
-		if (!slave)
+		port = bond_port_get_rtnl(dev);
+		if (!port)
 			return 0;
-		bond = slave->bond;
+		bond = port->bond;
 		break;
 	default:
 		return -EINVAL;
@@ -726,8 +726,8 @@ static int bond_fill_linkxstats(struct sk_buff *skb,
 	if (BOND_MODE(bond) == BOND_MODE_8023AD) {
 		struct bond_3ad_stats *stats;
 
-		if (slave)
-			stats = &SLAVE_AD_INFO(slave)->stats;
+		if (port)
+			stats = &PORT_AD_INFO(port)->stats;
 		else
 			stats = &BOND_AD_INFO(bond).stats;
 
@@ -766,10 +766,10 @@ struct rtnl_link_ops bond_link_ops __read_mostly = {
 	.fill_linkxstats        = bond_fill_linkxstats,
 	.get_linkxstats_size    = bond_get_linkxstats_size,
 	.slave_maxtype		= IFLA_BOND_SLAVE_MAX,
-	.slave_policy		= bond_slave_policy,
-	.slave_changelink	= bond_slave_changelink,
-	.get_slave_size		= bond_get_slave_size,
-	.fill_slave_info	= bond_fill_slave_info,
+	.slave_policy		= bond_port_policy,
+	.slave_changelink	= bond_port_changelink,
+	.get_slave_size		= bond_get_port_size,
+	.fill_slave_info	= bond_fill_port_info,
 };
 
 int __init bond_netlink_init(void)
diff --git a/drivers/net/bonding/bond_options.c b/drivers/net/bonding/bond_options.c
index 9abfaae1c6f7..8e4050c2b08e 100644
--- a/drivers/net/bonding/bond_options.c
+++ b/drivers/net/bonding/bond_options.c
@@ -16,7 +16,7 @@
 
 #include <net/bonding.h>
 
-static int bond_option_active_slave_set(struct bonding *bond,
+static int bond_option_active_port_set(struct bonding *bond,
 					const struct bond_opt_value *newval);
 static int bond_option_miimon_set(struct bonding *bond,
 				  const struct bond_opt_value *newval);
@@ -50,7 +50,7 @@ static int bond_option_resend_igmp_set(struct bonding *bond,
 				       const struct bond_opt_value *newval);
 static int bond_option_num_peer_notif_set(struct bonding *bond,
 					  const struct bond_opt_value *newval);
-static int bond_option_all_slaves_active_set(struct bonding *bond,
+static int bond_option_all_ports_active_set(struct bonding *bond,
 					     const struct bond_opt_value *newval);
 static int bond_option_min_links_set(struct bonding *bond,
 				     const struct bond_opt_value *newval);
@@ -66,7 +66,7 @@ static int bond_option_queue_id_set(struct bonding *bond,
 				    const struct bond_opt_value *newval);
 static int bond_option_mode_set(struct bonding *bond,
 				const struct bond_opt_value *newval);
-static int bond_option_slaves_set(struct bonding *bond,
+static int bond_option_ports_set(struct bonding *bond,
 				  const struct bond_opt_value *newval);
 static int bond_option_tlb_dynamic_lb_set(struct bonding *bond,
 				  const struct bond_opt_value *newval);
@@ -167,7 +167,7 @@ static const struct bond_opt_value bond_use_carrier_tbl[] = {
 	{ NULL,  -1, 0}
 };
 
-static const struct bond_opt_value bond_all_slaves_active_tbl[] = {
+static const struct bond_opt_value bond_all_ports_active_tbl[] = {
 	{ "off", 0,  BOND_VALFLAG_DEFAULT},
 	{ "on",  1,  0},
 	{ NULL,  -1, 0}
@@ -209,14 +209,14 @@ static const struct bond_option bond_opts[BOND_OPT_LAST] = {
 		.id = BOND_OPT_MODE,
 		.name = "mode",
 		.desc = "bond device mode",
-		.flags = BOND_OPTFLAG_NOSLAVES | BOND_OPTFLAG_IFDOWN,
+		.flags = BOND_OPTFLAG_NOPORTS | BOND_OPTFLAG_IFDOWN,
 		.values = bond_mode_tbl,
 		.set = bond_option_mode_set
 	},
-	[BOND_OPT_PACKETS_PER_SLAVE] = {
-		.id = BOND_OPT_PACKETS_PER_SLAVE,
-		.name = "packets_per_slave",
-		.desc = "Packets to send per slave in RR mode",
+	[BOND_OPT_PACKETS_PER_PORT] = {
+		.id = BOND_OPT_PACKETS_PER_PORT,
+		.name = "packets_per_port",
+		.desc = "Packets to send per port in RR mode",
 		.unsuppmodes = BOND_MODE_ALL_EX(BIT(BOND_MODE_ROUNDROBIN)),
 		.values = bond_pps_tbl,
 		.set = bond_option_pps_set
@@ -247,8 +247,8 @@ static const struct bond_option bond_opts[BOND_OPT_LAST] = {
 	[BOND_OPT_FAIL_OVER_MAC] = {
 		.id = BOND_OPT_FAIL_OVER_MAC,
 		.name = "fail_over_mac",
-		.desc = "For active-backup, do not set all slaves to the same MAC",
-		.flags = BOND_OPTFLAG_NOSLAVES,
+		.desc = "For active-backup, do not set all ports to the same MAC",
+		.flags = BOND_OPTFLAG_NOPORTS,
 		.values = bond_fail_over_mac_tbl,
 		.set = bond_option_fail_over_mac_set
 	},
@@ -333,7 +333,7 @@ static const struct bond_option bond_opts[BOND_OPT_LAST] = {
 	[BOND_OPT_PRIMARY_RESELECT] = {
 		.id = BOND_OPT_PRIMARY_RESELECT,
 		.name = "primary_reselect",
-		.desc = "Reselect primary slave once it comes up",
+		.desc = "Reselect primary port once it comes up",
 		.values = bond_primary_reselect_tbl,
 		.set = bond_option_primary_reselect_set
 	},
@@ -344,29 +344,29 @@ static const struct bond_option bond_opts[BOND_OPT_LAST] = {
 		.values = bond_use_carrier_tbl,
 		.set = bond_option_use_carrier_set
 	},
-	[BOND_OPT_ACTIVE_SLAVE] = {
-		.id = BOND_OPT_ACTIVE_SLAVE,
-		.name = "active_slave",
-		.desc = "Currently active slave",
+	[BOND_OPT_ACTIVE_PORT] = {
+		.id = BOND_OPT_ACTIVE_PORT,
+		.name = "active_port",
+		.desc = "Currently active port",
 		.flags = BOND_OPTFLAG_RAWVAL,
 		.unsuppmodes = BOND_MODE_ALL_EX(BIT(BOND_MODE_ACTIVEBACKUP) |
 						BIT(BOND_MODE_TLB) |
 						BIT(BOND_MODE_ALB)),
-		.set = bond_option_active_slave_set
+		.set = bond_option_active_port_set
 	},
 	[BOND_OPT_QUEUE_ID] = {
 		.id = BOND_OPT_QUEUE_ID,
 		.name = "queue_id",
-		.desc = "Set queue id of a slave",
+		.desc = "Set queue id of a port",
 		.flags = BOND_OPTFLAG_RAWVAL,
 		.set = bond_option_queue_id_set
 	},
-	[BOND_OPT_ALL_SLAVES_ACTIVE] = {
-		.id = BOND_OPT_ALL_SLAVES_ACTIVE,
-		.name = "all_slaves_active",
-		.desc = "Keep all frames received on an interface by setting active flag for all slaves",
-		.values = bond_all_slaves_active_tbl,
-		.set = bond_option_all_slaves_active_set
+	[BOND_OPT_ALL_PORTS_ACTIVE] = {
+		.id = BOND_OPT_ALL_PORTS_ACTIVE,
+		.name = "all_ports_active",
+		.desc = "Keep all frames received on an interface by setting active flag for all ports",
+		.values = bond_all_ports_active_tbl,
+		.set = bond_option_all_ports_active_set
 	},
 	[BOND_OPT_RESEND_IGMP] = {
 		.id = BOND_OPT_RESEND_IGMP,
@@ -378,16 +378,16 @@ static const struct bond_option bond_opts[BOND_OPT_LAST] = {
 	[BOND_OPT_LP_INTERVAL] = {
 		.id = BOND_OPT_LP_INTERVAL,
 		.name = "lp_interval",
-		.desc = "The number of seconds between instances where the bonding driver sends learning packets to each slave's peer switch",
+		.desc = "The number of seconds between instances where the bonding driver sends learning packets to each port's peer switch",
 		.values = bond_lp_interval_tbl,
 		.set = bond_option_lp_interval_set
 	},
-	[BOND_OPT_SLAVES] = {
-		.id = BOND_OPT_SLAVES,
-		.name = "slaves",
-		.desc = "Slave membership management",
+	[BOND_OPT_PORTS] = {
+		.id = BOND_OPT_PORTS,
+		.name = "ports",
+		.desc = "Port membership management",
 		.flags = BOND_OPTFLAG_RAWVAL,
-		.set = bond_option_slaves_set
+		.set = bond_option_ports_set
 	},
 	[BOND_OPT_TLB_DYNAMIC_LB] = {
 		.id = BOND_OPT_TLB_DYNAMIC_LB,
@@ -433,7 +433,41 @@ static const struct bond_option bond_opts[BOND_OPT_LAST] = {
 		.desc = "Delay between each peer notification on failover event, in milliseconds",
 		.values = bond_intmax_tbl,
 		.set = bond_option_peer_notif_delay_set
-	}
+	},
+/* legacy sysfs interfaces */
+	[BOND_OPT_PACKETS_PER_SLAVE] = {
+		.id = BOND_OPT_PACKETS_PER_SLAVE,
+		.name = "packets_per_slave",
+		.desc = "Packets to send per slave in RR mode",
+		.unsuppmodes = BOND_MODE_ALL_EX(BIT(BOND_MODE_ROUNDROBIN)),
+		.values = bond_pps_tbl,
+		.set = bond_option_pps_set
+	},
+	[BOND_OPT_ACTIVE_SLAVE] = {
+		.id = BOND_OPT_ACTIVE_SLAVE,
+		.name = "active_slave",
+		.desc = "Currently active slave",
+		.flags = BOND_OPTFLAG_RAWVAL,
+		.unsuppmodes = BOND_MODE_ALL_EX(BIT(BOND_MODE_ACTIVEBACKUP) |
+						BIT(BOND_MODE_TLB) |
+						BIT(BOND_MODE_ALB)),
+		.set = bond_option_active_port_set
+	},
+	[BOND_OPT_ALL_SLAVES_ACTIVE] = {
+		.id = BOND_OPT_ALL_SLAVES_ACTIVE,
+		.name = "all_slaves_active",
+		.desc = "Keep all frames received on an interface by setting active flag for all slaves",
+		.values = bond_all_ports_active_tbl,
+		.set = bond_option_all_ports_active_set
+	},
+	[BOND_OPT_SLAVES] = {
+		.id = BOND_OPT_SLAVES,
+		.name = "slaves",
+		.desc = "Slave membership management",
+		.flags = BOND_OPTFLAG_RAWVAL,
+		.set = bond_option_ports_set
+	},
+/* end legacy sysfs interfaces */
 };
 
 /* Searches for an option by name */
@@ -578,7 +612,7 @@ static int bond_opt_check_deps(struct bonding *bond,
 
 	if (test_bit(params->mode, &opt->unsuppmodes))
 		return -EACCES;
-	if ((opt->flags & BOND_OPTFLAG_NOSLAVES) && bond_has_slaves(bond))
+	if ((opt->flags & BOND_OPTFLAG_NOPORTS) && bond_has_ports(bond))
 		return -ENOTEMPTY;
 	if ((opt->flags & BOND_OPTFLAG_IFDOWN) && (bond->dev->flags & IFF_UP))
 		return -EBUSY;
@@ -632,7 +666,7 @@ static void bond_opt_error_interpret(struct bonding *bond,
 		bond_opt_dep_print(bond, opt);
 		break;
 	case -ENOTEMPTY:
-		netdev_err(bond->dev, "option %s: unable to set because the bond device has slaves\n",
+		netdev_err(bond->dev, "option %s: unable to set because the bond device has ports\n",
 			   opt->name);
 		break;
 	case -EBUSY:
@@ -782,57 +816,57 @@ static int bond_option_mode_set(struct bonding *bond,
 	return 0;
 }
 
-static int bond_option_active_slave_set(struct bonding *bond,
-					const struct bond_opt_value *newval)
+static int bond_option_active_port_set(struct bonding *bond,
+				       const struct bond_opt_value *newval)
 {
 	char ifname[IFNAMSIZ] = { 0, };
-	struct net_device *slave_dev;
+	struct net_device *port_dev;
 	int ret = 0;
 
 	sscanf(newval->string, "%15s", ifname); /* IFNAMSIZ */
 	if (!strlen(ifname) || newval->string[0] == '\n') {
-		slave_dev = NULL;
+		port_dev = NULL;
 	} else {
-		slave_dev = __dev_get_by_name(dev_net(bond->dev), ifname);
-		if (!slave_dev)
+		port_dev = __dev_get_by_name(dev_net(bond->dev), ifname);
+		if (!port_dev)
 			return -ENODEV;
 	}
 
-	if (slave_dev) {
-		if (!netif_is_bond_slave(slave_dev)) {
-			slave_err(bond->dev, slave_dev, "Device is not bonding slave\n");
+	if (port_dev) {
+		if (!netif_is_bond_port(port_dev)) {
+			port_err(bond->dev, port_dev, "Device is not bonding port\n");
 			return -EINVAL;
 		}
 
-		if (bond->dev != netdev_master_upper_dev_get(slave_dev)) {
-			slave_err(bond->dev, slave_dev, "Device is not our slave\n");
+		if (bond->dev != netdev_master_upper_dev_get(port_dev)) {
+			port_err(bond->dev, port_dev, "Device is not our port\n");
 			return -EINVAL;
 		}
 	}
 
 	block_netpoll_tx();
 	/* check to see if we are clearing active */
-	if (!slave_dev) {
-		netdev_dbg(bond->dev, "Clearing current active slave\n");
-		RCU_INIT_POINTER(bond->curr_active_slave, NULL);
-		bond_select_active_slave(bond);
+	if (!port_dev) {
+		netdev_dbg(bond->dev, "Clearing current active port\n");
+		RCU_INIT_POINTER(bond->curr_active_port, NULL);
+		bond_select_active_port(bond);
 	} else {
-		struct slave *old_active = rtnl_dereference(bond->curr_active_slave);
-		struct slave *new_active = bond_slave_get_rtnl(slave_dev);
+		struct bond_port *old_active = rtnl_dereference(bond->curr_active_port);
+		struct bond_port *new_active = bond_port_get_rtnl(port_dev);
 
 		BUG_ON(!new_active);
 
 		if (new_active == old_active) {
 			/* do nothing */
-			slave_dbg(bond->dev, new_active->dev, "is already the current active slave\n");
+			port_dbg(bond->dev, new_active->dev, "is already the current active port\n");
 		} else {
 			if (old_active && (new_active->link == BOND_LINK_UP) &&
-			    bond_slave_is_up(new_active)) {
-				slave_dbg(bond->dev, new_active->dev, "Setting as active slave\n");
-				bond_change_active_slave(bond, new_active);
+			    bond_port_is_up(new_active)) {
+				port_dbg(bond->dev, new_active->dev, "Setting as active port\n");
+				bond_change_active_port(bond, new_active);
 			} else {
-				slave_err(bond->dev, new_active->dev, "Could not set as active slave; either %s is down or the link is down\n",
-					  new_active->dev->name);
+				port_err(bond->dev, new_active->dev, "Could not set as active port; either %s is down or the link is down\n",
+					 new_active->dev->name);
 				ret = -EINVAL;
 			}
 		}
@@ -903,15 +937,13 @@ static int _bond_option_delay_set(struct bonding *bond,
 	if ((value % bond->params.miimon) != 0) {
 		netdev_warn(bond->dev,
 			    "%s (%d) is not a multiple of miimon (%d), value rounded to %d ms\n",
-			    name,
-			    value, bond->params.miimon,
+			    name, value, bond->params.miimon,
 			    (value / bond->params.miimon) *
 			    bond->params.miimon);
 	}
 	*target = value / bond->params.miimon;
 	netdev_dbg(bond->dev, "Setting %s to %d\n",
-		   name,
-		   *target * bond->params.miimon);
+		   name, *target * bond->params.miimon);
 
 	return 0;
 }
@@ -994,11 +1026,11 @@ static void _bond_options_arp_ip_target_set(struct bonding *bond, int slot,
 {
 	__be32 *targets = bond->params.arp_targets;
 	struct list_head *iter;
-	struct slave *slave;
+	struct bond_port *port;
 
 	if (slot >= 0 && slot < BOND_MAX_ARP_TARGETS) {
-		bond_for_each_slave(bond, slave, iter)
-			slave->target_last_arp_rx[slot] = last_rx;
+		bond_for_each_port(bond, port, iter)
+			port->target_last_arp_rx[slot] = last_rx;
 		targets[slot] = target;
 	}
 }
@@ -1042,7 +1074,7 @@ static int bond_option_arp_ip_target_rem(struct bonding *bond, __be32 target)
 {
 	__be32 *targets = bond->params.arp_targets;
 	struct list_head *iter;
-	struct slave *slave;
+	struct bond_port *port;
 	unsigned long *targets_rx;
 	int ind, i;
 
@@ -1064,8 +1096,8 @@ static int bond_option_arp_ip_target_rem(struct bonding *bond, __be32 target)
 
 	netdev_dbg(bond->dev, "Removing ARP target %pI4\n", &target);
 
-	bond_for_each_slave(bond, slave, iter) {
-		targets_rx = slave->target_last_arp_rx;
+	bond_for_each_port(bond, port, iter) {
+		targets_rx = port->target_last_arp_rx;
 		for (i = ind; (i < BOND_MAX_ARP_TARGETS-1) && targets[i+1]; i++)
 			targets_rx[i] = targets_rx[i+1];
 		targets_rx[i] = 0;
@@ -1136,7 +1168,7 @@ static int bond_option_primary_set(struct bonding *bond,
 {
 	char *p, *primary = newval->string;
 	struct list_head *iter;
-	struct slave *slave;
+	struct bond_port *port;
 
 	block_netpoll_tx();
 
@@ -1145,33 +1177,33 @@ static int bond_option_primary_set(struct bonding *bond,
 		*p = '\0';
 	/* check to see if we are clearing primary */
 	if (!strlen(primary)) {
-		netdev_dbg(bond->dev, "Setting primary slave to None\n");
-		RCU_INIT_POINTER(bond->primary_slave, NULL);
+		netdev_dbg(bond->dev, "Setting primary port to None\n");
+		RCU_INIT_POINTER(bond->primary_port, NULL);
 		memset(bond->params.primary, 0, sizeof(bond->params.primary));
-		bond_select_active_slave(bond);
+		bond_select_active_port(bond);
 		goto out;
 	}
 
-	bond_for_each_slave(bond, slave, iter) {
-		if (strncmp(slave->dev->name, primary, IFNAMSIZ) == 0) {
-			slave_dbg(bond->dev, slave->dev, "Setting as primary slave\n");
-			rcu_assign_pointer(bond->primary_slave, slave);
-			strcpy(bond->params.primary, slave->dev->name);
+	bond_for_each_port(bond, port, iter) {
+		if (strncmp(port->dev->name, primary, IFNAMSIZ) == 0) {
+			port_dbg(bond->dev, port->dev, "Setting as primary port\n");
+			rcu_assign_pointer(bond->primary_port, port);
+			strcpy(bond->params.primary, port->dev->name);
 			bond->force_primary = true;
-			bond_select_active_slave(bond);
+			bond_select_active_port(bond);
 			goto out;
 		}
 	}
 
-	if (rtnl_dereference(bond->primary_slave)) {
-		netdev_dbg(bond->dev, "Setting primary slave to None\n");
-		RCU_INIT_POINTER(bond->primary_slave, NULL);
-		bond_select_active_slave(bond);
+	if (rtnl_dereference(bond->primary_port)) {
+		netdev_dbg(bond->dev, "Setting primary port to None\n");
+		RCU_INIT_POINTER(bond->primary_port, NULL);
+		bond_select_active_port(bond);
 	}
 	strncpy(bond->params.primary, primary, IFNAMSIZ);
 	bond->params.primary[IFNAMSIZ - 1] = 0;
 
-	netdev_dbg(bond->dev, "Recording %s as primary, but it has not been enslaved yet\n",
+	netdev_dbg(bond->dev, "Recording %s as primary, but it has not been connected yet\n",
 		   primary);
 
 out:
@@ -1188,7 +1220,7 @@ static int bond_option_primary_reselect_set(struct bonding *bond,
 	bond->params.primary_reselect = newval->value;
 
 	block_netpoll_tx();
-	bond_select_active_slave(bond);
+	bond_select_active_port(bond);
 	unblock_netpoll_tx();
 
 	return 0;
@@ -1232,21 +1264,21 @@ static int bond_option_num_peer_notif_set(struct bonding *bond,
 	return 0;
 }
 
-static int bond_option_all_slaves_active_set(struct bonding *bond,
+static int bond_option_all_ports_active_set(struct bonding *bond,
 					     const struct bond_opt_value *newval)
 {
 	struct list_head *iter;
-	struct slave *slave;
+	struct bond_port *port;
 
-	if (newval->value == bond->params.all_slaves_active)
+	if (newval->value == bond->params.all_ports_active)
 		return 0;
-	bond->params.all_slaves_active = newval->value;
-	bond_for_each_slave(bond, slave, iter) {
-		if (!bond_is_active_slave(slave)) {
+	bond->params.all_ports_active = newval->value;
+	bond_for_each_port(bond, port, iter) {
+		if (!bond_is_active_port(port)) {
 			if (newval->value)
-				slave->inactive = 0;
+				port->inactive = 0;
 			else
-				slave->inactive = 1;
+				port->inactive = 1;
 		}
 	}
 
@@ -1275,17 +1307,17 @@ static int bond_option_lp_interval_set(struct bonding *bond,
 static int bond_option_pps_set(struct bonding *bond,
 			       const struct bond_opt_value *newval)
 {
-	netdev_dbg(bond->dev, "Setting packets per slave to %llu\n",
+	netdev_dbg(bond->dev, "Setting packets per port to %llu\n",
 		   newval->value);
-	bond->params.packets_per_slave = newval->value;
+	bond->params.packets_per_port = newval->value;
 	if (newval->value > 0) {
-		bond->params.reciprocal_packets_per_slave =
+		bond->params.reciprocal_packets_per_port =
 			reciprocal_value(newval->value);
 	} else {
-		/* reciprocal_packets_per_slave is unused if
-		 * packets_per_slave is 0 or 1, just initialize it
+		/* reciprocal_packets_per_port is unused if
+		 * packets_per_port is 0 or 1, just initialize it
 		 */
-		bond->params.reciprocal_packets_per_slave =
+		bond->params.reciprocal_packets_per_port =
 			(struct reciprocal_value) { 0 };
 	}
 
@@ -1316,7 +1348,7 @@ static int bond_option_ad_select_set(struct bonding *bond,
 static int bond_option_queue_id_set(struct bonding *bond,
 				    const struct bond_opt_value *newval)
 {
-	struct slave *slave, *update_slave;
+	struct bond_port *port, *update_port;
 	struct net_device *sdev;
 	struct list_head *iter;
 	char *delim;
@@ -1345,24 +1377,24 @@ static int bond_option_queue_id_set(struct bonding *bond,
 	if (!sdev)
 		goto err_no_cmd;
 
-	/* Search for thes slave and check for duplicate qids */
-	update_slave = NULL;
-	bond_for_each_slave(bond, slave, iter) {
-		if (sdev == slave->dev)
+	/* Search for thes port and check for duplicate qids */
+	update_port = NULL;
+	bond_for_each_port(bond, port, iter) {
+		if (sdev == port->dev)
 			/* We don't need to check the matching
-			 * slave for dups, since we're overwriting it
+			 * port for dups, since we're overwriting it
 			 */
-			update_slave = slave;
-		else if (qid && qid == slave->queue_id) {
+			update_port = port;
+		else if (qid && qid == port->queue_id) {
 			goto err_no_cmd;
 		}
 	}
 
-	if (!update_slave)
+	if (!update_port)
 		goto err_no_cmd;
 
-	/* Actually set the qids for the slave */
-	update_slave->queue_id = qid;
+	/* Actually set the qids for the port */
+	update_port->queue_id = qid;
 
 out:
 	return ret;
@@ -1374,8 +1406,8 @@ static int bond_option_queue_id_set(struct bonding *bond,
 
 }
 
-static int bond_option_slaves_set(struct bonding *bond,
-				  const struct bond_opt_value *newval)
+static int bond_option_ports_set(struct bonding *bond,
+				 const struct bond_opt_value *newval)
 {
 	char command[IFNAMSIZ + 1] = { 0, };
 	struct net_device *dev;
@@ -1399,12 +1431,12 @@ static int bond_option_slaves_set(struct bonding *bond,
 
 	switch (command[0]) {
 	case '+':
-		slave_dbg(bond->dev, dev, "Enslaving interface\n");
-		ret = bond_enslave(bond->dev, dev, NULL);
+		port_dbg(bond->dev, dev, "Connecting interface\n");
+		ret = bond_connect(bond->dev, dev, NULL);
 		break;
 
 	case '-':
-		slave_dbg(bond->dev, dev, "Releasing interface\n");
+		port_dbg(bond->dev, dev, "Releasing interface\n");
 		ret = bond_release(bond->dev, dev);
 		break;
 
@@ -1417,7 +1449,7 @@ static int bond_option_slaves_set(struct bonding *bond,
 	return ret;
 
 err_no_cmd:
-	netdev_err(bond->dev, "no command found in slaves file - use +ifname or -ifname\n");
+	netdev_err(bond->dev, "no command found in ports file - use +ifname or -ifname\n");
 	ret = -EPERM;
 	goto out;
 }
diff --git a/drivers/net/bonding/bond_procfs.c b/drivers/net/bonding/bond_procfs.c
index 2ac60cff9b3a..226ea88de378 100644
--- a/drivers/net/bonding/bond_procfs.c
+++ b/drivers/net/bonding/bond_procfs.c
@@ -12,7 +12,7 @@ static void *bond_info_seq_start(struct seq_file *seq, loff_t *pos)
 {
 	struct bonding *bond = PDE_DATA(file_inode(seq->file));
 	struct list_head *iter;
-	struct slave *slave;
+	struct bond_port *port;
 	loff_t off = 0;
 
 	rcu_read_lock();
@@ -20,9 +20,9 @@ static void *bond_info_seq_start(struct seq_file *seq, loff_t *pos)
 	if (*pos == 0)
 		return SEQ_START_TOKEN;
 
-	bond_for_each_slave_rcu(bond, slave, iter)
+	bond_for_each_port_rcu(bond, port, iter)
 		if (++off == *pos)
-			return slave;
+			return port;
 
 	return NULL;
 }
@@ -31,17 +31,17 @@ static void *bond_info_seq_next(struct seq_file *seq, void *v, loff_t *pos)
 {
 	struct bonding *bond = PDE_DATA(file_inode(seq->file));
 	struct list_head *iter;
-	struct slave *slave;
+	struct bond_port *port;
 	bool found = false;
 
 	++*pos;
 	if (v == SEQ_START_TOKEN)
-		return bond_first_slave_rcu(bond);
+		return bond_first_port_rcu(bond);
 
-	bond_for_each_slave_rcu(bond, slave, iter) {
+	bond_for_each_port_rcu(bond, port, iter) {
 		if (found)
-			return slave;
-		if (slave == v)
+			return port;
+		if (port == v)
 			found = true;
 	}
 
@@ -58,10 +58,10 @@ static void bond_info_show_bond_dev(struct seq_file *seq)
 {
 	struct bonding *bond = PDE_DATA(file_inode(seq->file));
 	const struct bond_opt_value *optval;
-	struct slave *curr, *primary;
+	struct bond_port *curr, *primary;
 	int i;
 
-	curr = rcu_dereference(bond->curr_active_slave);
+	curr = rcu_dereference(bond->curr_active_port);
 
 	seq_printf(seq, "Bonding Mode: %s",
 		   bond_mode_name(BOND_MODE(bond)));
@@ -83,7 +83,7 @@ static void bond_info_show_bond_dev(struct seq_file *seq)
 	}
 
 	if (bond_uses_primary(bond)) {
-		primary = rcu_dereference(bond->primary_slave);
+		primary = rcu_dereference(bond->primary_port);
 		seq_printf(seq, "Primary Slave: %s",
 			   primary ? primary->dev->name : "None");
 		if (primary) {
@@ -166,32 +166,32 @@ static void bond_info_show_bond_dev(struct seq_file *seq)
 	}
 }
 
-static void bond_info_show_slave(struct seq_file *seq,
-				 const struct slave *slave)
+static void bond_info_show_port(struct seq_file *seq,
+				 const struct bond_port *port)
 {
 	struct bonding *bond = PDE_DATA(file_inode(seq->file));
 
-	seq_printf(seq, "\nSlave Interface: %s\n", slave->dev->name);
-	seq_printf(seq, "MII Status: %s\n", bond_slave_link_status(slave->link));
-	if (slave->speed == SPEED_UNKNOWN)
+	seq_printf(seq, "\nSlave Interface: %s\n", port->dev->name);
+	seq_printf(seq, "MII Status: %s\n", bond_port_link_status(port->link));
+	if (port->speed == SPEED_UNKNOWN)
 		seq_printf(seq, "Speed: %s\n", "Unknown");
 	else
-		seq_printf(seq, "Speed: %d Mbps\n", slave->speed);
+		seq_printf(seq, "Speed: %d Mbps\n", port->speed);
 
-	if (slave->duplex == DUPLEX_UNKNOWN)
+	if (port->duplex == DUPLEX_UNKNOWN)
 		seq_printf(seq, "Duplex: %s\n", "Unknown");
 	else
-		seq_printf(seq, "Duplex: %s\n", slave->duplex ? "full" : "half");
+		seq_printf(seq, "Duplex: %s\n", port->duplex ? "full" : "half");
 
 	seq_printf(seq, "Link Failure Count: %u\n",
-		   slave->link_failure_count);
+		   port->link_failure_count);
 
 	seq_printf(seq, "Permanent HW addr: %*phC\n",
-		   slave->dev->addr_len, slave->perm_hwaddr);
-	seq_printf(seq, "Slave queue ID: %d\n", slave->queue_id);
+		   port->dev->addr_len, port->perm_hwaddr);
+	seq_printf(seq, "Slave queue ID: %d\n", port->queue_id);
 
 	if (BOND_MODE(bond) == BOND_MODE_8023AD) {
-		const struct ad_port *ad_port = &SLAVE_AD_INFO(slave)->ad_port;
+		const struct ad_port *ad_port = &PORT_AD_INFO(port)->ad_port;
 		const struct aggregator *agg = ad_port->aggregator;
 
 		if (agg) {
@@ -247,7 +247,7 @@ static int bond_info_seq_show(struct seq_file *seq, void *v)
 		seq_printf(seq, "%s\n", bond_version);
 		bond_info_show_bond_dev(seq);
 	} else
-		bond_info_show_slave(seq, v);
+		bond_info_show_port(seq, v);
 
 	return 0;
 }
diff --git a/drivers/net/bonding/bond_sysfs.c b/drivers/net/bonding/bond_sysfs.c
index f3b9db1a4a84..fceeeb6c0ffa 100644
--- a/drivers/net/bonding/bond_sysfs.c
+++ b/drivers/net/bonding/bond_sysfs.c
@@ -161,19 +161,19 @@ static ssize_t bonding_sysfs_store_option(struct device *d,
 	return ret;
 }
 
-/* Show the slaves in the current bond. */
-static ssize_t bonding_show_slaves(struct device *d,
-				   struct device_attribute *attr, char *buf)
+/* Show the ports in the current bond. */
+static ssize_t bonding_show_ports(struct device *d,
+				  struct device_attribute *attr, char *buf)
 {
 	struct bonding *bond = to_bond(d);
 	struct list_head *iter;
-	struct slave *slave;
+	struct bond_port *port;
 	int res = 0;
 
 	if (!rtnl_trylock())
 		return restart_syscall();
 
-	bond_for_each_slave(bond, slave, iter) {
+	bond_for_each_port(bond, port, iter) {
 		if (res > (PAGE_SIZE - IFNAMSIZ)) {
 			/* not enough space for another interface name */
 			if ((PAGE_SIZE - res) > 10)
@@ -181,7 +181,7 @@ static ssize_t bonding_show_slaves(struct device *d,
 			res += sprintf(buf + res, "++more++ ");
 			break;
 		}
-		res += sprintf(buf + res, "%s ", slave->dev->name);
+		res += sprintf(buf + res, "%s ", port->dev->name);
 	}
 
 	rtnl_unlock();
@@ -191,7 +191,7 @@ static ssize_t bonding_show_slaves(struct device *d,
 
 	return res;
 }
-static DEVICE_ATTR(slaves, 0644, bonding_show_slaves,
+static DEVICE_ATTR(slaves, 0644, bonding_show_ports,
 		   bonding_sysfs_store_option);
 
 /* Show the bonding mode. */
@@ -404,17 +404,17 @@ static ssize_t bonding_show_miimon(struct device *d,
 static DEVICE_ATTR(miimon, 0644,
 		   bonding_show_miimon, bonding_sysfs_store_option);
 
-/* Show the primary slave. */
+/* Show the primary port. */
 static ssize_t bonding_show_primary(struct device *d,
 				    struct device_attribute *attr,
 				    char *buf)
 {
 	struct bonding *bond = to_bond(d);
-	struct slave *primary;
+	struct bond_port *primary;
 	int count = 0;
 
 	rcu_read_lock();
-	primary = rcu_dereference(bond->primary_slave);
+	primary = rcu_dereference(bond->primary_port);
 	if (primary)
 		count = sprintf(buf, "%s\n", primary->dev->name);
 	rcu_read_unlock();
@@ -454,25 +454,25 @@ static DEVICE_ATTR(use_carrier, 0644,
 		   bonding_show_carrier, bonding_sysfs_store_option);
 
 
-/* Show currently active_slave. */
-static ssize_t bonding_show_active_slave(struct device *d,
-					 struct device_attribute *attr,
-					 char *buf)
+/* Show currently active_port. */
+static ssize_t bonding_show_active_port(struct device *d,
+					struct device_attribute *attr,
+					char *buf)
 {
 	struct bonding *bond = to_bond(d);
-	struct net_device *slave_dev;
+	struct net_device *port_dev;
 	int count = 0;
 
 	rcu_read_lock();
-	slave_dev = bond_option_active_slave_get_rcu(bond);
-	if (slave_dev)
-		count = sprintf(buf, "%s\n", slave_dev->name);
+	port_dev = bond_option_active_port_get_rcu(bond);
+	if (port_dev)
+		count = sprintf(buf, "%s\n", port_dev->name);
 	rcu_read_unlock();
 
 	return count;
 }
 static DEVICE_ATTR(active_slave, 0644,
-		   bonding_show_active_slave, bonding_sysfs_store_option);
+		   bonding_show_active_port, bonding_sysfs_store_option);
 
 /* Show link status of the bond interface. */
 static ssize_t bonding_show_mii_status(struct device *d,
@@ -584,20 +584,20 @@ static ssize_t bonding_show_ad_partner_mac(struct device *d,
 }
 static DEVICE_ATTR(ad_partner_mac, 0444, bonding_show_ad_partner_mac, NULL);
 
-/* Show the queue_ids of the slaves in the current bond. */
+/* Show the queue_ids of the ports in the current bond. */
 static ssize_t bonding_show_queue_id(struct device *d,
 				     struct device_attribute *attr,
 				     char *buf)
 {
 	struct bonding *bond = to_bond(d);
 	struct list_head *iter;
-	struct slave *slave;
+	struct bond_port *port;
 	int res = 0;
 
 	if (!rtnl_trylock())
 		return restart_syscall();
 
-	bond_for_each_slave(bond, slave, iter) {
+	bond_for_each_port(bond, port, iter) {
 		if (res > (PAGE_SIZE - IFNAMSIZ - 6)) {
 			/* not enough space for another interface_name:queue_id pair */
 			if ((PAGE_SIZE - res) > 10)
@@ -606,7 +606,7 @@ static ssize_t bonding_show_queue_id(struct device *d,
 			break;
 		}
 		res += sprintf(buf + res, "%s:%d ",
-			       slave->dev->name, slave->queue_id);
+			       port->dev->name, port->queue_id);
 	}
 	if (res)
 		buf[res-1] = '\n'; /* eat the leftover space */
@@ -619,17 +619,17 @@ static DEVICE_ATTR(queue_id, 0644, bonding_show_queue_id,
 		   bonding_sysfs_store_option);
 
 
-/* Show the all_slaves_active flag. */
-static ssize_t bonding_show_slaves_active(struct device *d,
-					  struct device_attribute *attr,
-					  char *buf)
+/* Show the all_ports_active flag. */
+static ssize_t bonding_show_ports_active(struct device *d,
+					 struct device_attribute *attr,
+					 char *buf)
 {
 	struct bonding *bond = to_bond(d);
 
-	return sprintf(buf, "%d\n", bond->params.all_slaves_active);
+	return sprintf(buf, "%d\n", bond->params.all_ports_active);
 }
 static DEVICE_ATTR(all_slaves_active, 0644,
-		   bonding_show_slaves_active, bonding_sysfs_store_option);
+		   bonding_show_ports_active, bonding_sysfs_store_option);
 
 /* Show the number of IGMP membership reports to send on link failure */
 static ssize_t bonding_show_resend_igmp(struct device *d,
@@ -665,17 +665,17 @@ static ssize_t bonding_show_tlb_dynamic_lb(struct device *d,
 static DEVICE_ATTR(tlb_dynamic_lb, 0644,
 		   bonding_show_tlb_dynamic_lb, bonding_sysfs_store_option);
 
-static ssize_t bonding_show_packets_per_slave(struct device *d,
-					      struct device_attribute *attr,
-					      char *buf)
+static ssize_t bonding_show_packets_per_port(struct device *d,
+					     struct device_attribute *attr,
+					     char *buf)
 {
 	struct bonding *bond = to_bond(d);
-	unsigned int packets_per_slave = bond->params.packets_per_slave;
+	unsigned int packets_per_port = bond->params.packets_per_port;
 
-	return sprintf(buf, "%u\n", packets_per_slave);
+	return sprintf(buf, "%u\n", packets_per_port);
 }
 static DEVICE_ATTR(packets_per_slave, 0644,
-		   bonding_show_packets_per_slave, bonding_sysfs_store_option);
+		   bonding_show_packets_per_port, bonding_sysfs_store_option);
 
 static ssize_t bonding_show_ad_actor_sys_prio(struct device *d,
 					      struct device_attribute *attr,
diff --git a/drivers/net/bonding/bond_sysfs_slave.c b/drivers/net/bonding/bond_sysfs_slave.c
index 5c0b30d5cadb..0d427b407fcb 100644
--- a/drivers/net/bonding/bond_sysfs_slave.c
+++ b/drivers/net/bonding/bond_sysfs_slave.c
@@ -1,5 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
-/*	Sysfs attributes of bond slaves
+/*	Sysfs attributes of bond ports
  *
  *      Copyright (c) 2014 Scott Feldman <sfeldma@cumulusnetworks.com>
  */
@@ -10,23 +10,23 @@
 
 #include <net/bonding.h>
 
-struct slave_attribute {
+struct port_attribute {
 	struct attribute attr;
-	ssize_t (*show)(struct slave *, char *);
+	ssize_t (*show)(struct bond_port *, char *);
 };
 
-#define SLAVE_ATTR(_name, _mode, _show)				\
-const struct slave_attribute slave_attr_##_name = {		\
+#define PORT_ATTR(_name, _mode, _show)				\
+const struct port_attribute port_attr_##_name = {		\
 	.attr = {.name = __stringify(_name),			\
 		 .mode = _mode },				\
 	.show	= _show,					\
 };
-#define SLAVE_ATTR_RO(_name)					\
-	SLAVE_ATTR(_name, 0444, _name##_show)
+#define PORT_ATTR_RO(_name)					\
+	PORT_ATTR(_name, 0444, _name##_show)
 
-static ssize_t state_show(struct slave *slave, char *buf)
+static ssize_t state_show(struct bond_port *port, char *buf)
 {
-	switch (bond_slave_state(slave)) {
+	switch (bond_port_state(port)) {
 	case BOND_STATE_ACTIVE:
 		return sprintf(buf, "active\n");
 	case BOND_STATE_BACKUP:
@@ -35,40 +35,40 @@ static ssize_t state_show(struct slave *slave, char *buf)
 		return sprintf(buf, "UNKNOWN\n");
 	}
 }
-static SLAVE_ATTR_RO(state);
+static PORT_ATTR_RO(state);
 
-static ssize_t mii_status_show(struct slave *slave, char *buf)
+static ssize_t mii_status_show(struct bond_port *port, char *buf)
 {
-	return sprintf(buf, "%s\n", bond_slave_link_status(slave->link));
+	return sprintf(buf, "%s\n", bond_port_link_status(port->link));
 }
-static SLAVE_ATTR_RO(mii_status);
+static PORT_ATTR_RO(mii_status);
 
-static ssize_t link_failure_count_show(struct slave *slave, char *buf)
+static ssize_t link_failure_count_show(struct bond_port *port, char *buf)
 {
-	return sprintf(buf, "%d\n", slave->link_failure_count);
+	return sprintf(buf, "%d\n", port->link_failure_count);
 }
-static SLAVE_ATTR_RO(link_failure_count);
+static PORT_ATTR_RO(link_failure_count);
 
-static ssize_t perm_hwaddr_show(struct slave *slave, char *buf)
+static ssize_t perm_hwaddr_show(struct bond_port *port, char *buf)
 {
 	return sprintf(buf, "%*phC\n",
-		       slave->dev->addr_len,
-		       slave->perm_hwaddr);
+		       port->dev->addr_len,
+		       port->perm_hwaddr);
 }
-static SLAVE_ATTR_RO(perm_hwaddr);
+static PORT_ATTR_RO(perm_hwaddr);
 
-static ssize_t queue_id_show(struct slave *slave, char *buf)
+static ssize_t queue_id_show(struct bond_port *port, char *buf)
 {
-	return sprintf(buf, "%d\n", slave->queue_id);
+	return sprintf(buf, "%d\n", port->queue_id);
 }
-static SLAVE_ATTR_RO(queue_id);
+static PORT_ATTR_RO(queue_id);
 
-static ssize_t ad_aggregator_id_show(struct slave *slave, char *buf)
+static ssize_t ad_aggregator_id_show(struct bond_port *port, char *buf)
 {
 	const struct aggregator *agg;
 
-	if (BOND_MODE(slave->bond) == BOND_MODE_8023AD) {
-		agg = SLAVE_AD_INFO(slave)->ad_port.aggregator;
+	if (BOND_MODE(port->bond) == BOND_MODE_8023AD) {
+		agg = PORT_AD_INFO(port)->ad_port.aggregator;
 		if (agg)
 			return sprintf(buf, "%d\n",
 				       agg->aggregator_identifier);
@@ -76,14 +76,14 @@ static ssize_t ad_aggregator_id_show(struct slave *slave, char *buf)
 
 	return sprintf(buf, "N/A\n");
 }
-static SLAVE_ATTR_RO(ad_aggregator_id);
+static PORT_ATTR_RO(ad_aggregator_id);
 
-static ssize_t ad_actor_oper_port_state_show(struct slave *slave, char *buf)
+static ssize_t ad_actor_oper_port_state_show(struct bond_port *port, char *buf)
 {
 	const struct ad_port *ad_port;
 
-	if (BOND_MODE(slave->bond) == BOND_MODE_8023AD) {
-		ad_port = &SLAVE_AD_INFO(slave)->ad_port;
+	if (BOND_MODE(port->bond) == BOND_MODE_8023AD) {
+		ad_port = &PORT_AD_INFO(port)->ad_port;
 		if (ad_port->aggregator)
 			return sprintf(buf, "%u\n",
 				       ad_port->actor_oper_port_state);
@@ -91,14 +91,14 @@ static ssize_t ad_actor_oper_port_state_show(struct slave *slave, char *buf)
 
 	return sprintf(buf, "N/A\n");
 }
-static SLAVE_ATTR_RO(ad_actor_oper_port_state);
+static PORT_ATTR_RO(ad_actor_oper_port_state);
 
-static ssize_t ad_partner_oper_port_state_show(struct slave *slave, char *buf)
+static ssize_t ad_partner_oper_port_state_show(struct bond_port *port, char *buf)
 {
 	const struct ad_port *ad_port;
 
-	if (BOND_MODE(slave->bond) == BOND_MODE_8023AD) {
-		ad_port = &SLAVE_AD_INFO(slave)->ad_port;
+	if (BOND_MODE(port->bond) == BOND_MODE_8023AD) {
+		ad_port = &PORT_AD_INFO(port)->ad_port;
 		if (ad_port->aggregator)
 			return sprintf(buf, "%u\n",
 				       ad_port->partner_oper.port_state);
@@ -106,71 +106,80 @@ static ssize_t ad_partner_oper_port_state_show(struct slave *slave, char *buf)
 
 	return sprintf(buf, "N/A\n");
 }
-static SLAVE_ATTR_RO(ad_partner_oper_port_state);
-
-static const struct slave_attribute *slave_attrs[] = {
-	&slave_attr_state,
-	&slave_attr_mii_status,
-	&slave_attr_link_failure_count,
-	&slave_attr_perm_hwaddr,
-	&slave_attr_queue_id,
-	&slave_attr_ad_aggregator_id,
-	&slave_attr_ad_actor_oper_port_state,
-	&slave_attr_ad_partner_oper_port_state,
+static PORT_ATTR_RO(ad_partner_oper_port_state);
+
+static const struct port_attribute *port_attrs[] = {
+	&port_attr_state,
+	&port_attr_mii_status,
+	&port_attr_link_failure_count,
+	&port_attr_perm_hwaddr,
+	&port_attr_queue_id,
+	&port_attr_ad_aggregator_id,
+	&port_attr_ad_actor_oper_port_state,
+	&port_attr_ad_partner_oper_port_state,
 	NULL
 };
 
-#define to_slave_attr(_at) container_of(_at, struct slave_attribute, attr)
-#define to_slave(obj)	container_of(obj, struct slave, kobj)
+#define to_port_attr(_at) container_of(_at, struct port_attribute, attr)
+#define to_port(obj)	container_of(obj, struct bond_port, kobj)
 
-static ssize_t slave_show(struct kobject *kobj,
+static ssize_t port_show(struct kobject *kobj,
 			  struct attribute *attr, char *buf)
 {
-	struct slave_attribute *slave_attr = to_slave_attr(attr);
-	struct slave *slave = to_slave(kobj);
+	struct port_attribute *port_attr = to_port_attr(attr);
+	struct bond_port *port = to_port(kobj);
 
-	return slave_attr->show(slave, buf);
+	return port_attr->show(port, buf);
 }
 
-static const struct sysfs_ops slave_sysfs_ops = {
-	.show = slave_show,
+static const struct sysfs_ops port_sysfs_ops = {
+	.show = port_show,
 };
 
-static struct kobj_type slave_ktype = {
+static struct kobj_type port_ktype = {
 #ifdef CONFIG_SYSFS
-	.sysfs_ops = &slave_sysfs_ops,
+	.sysfs_ops = &port_sysfs_ops,
 #endif
 };
 
-int bond_sysfs_slave_add(struct slave *slave)
+int bond_sysfs_port_add(struct bond_port *port)
 {
-	const struct slave_attribute **a;
+	const struct port_attribute **a;
 	int err;
 
-	err = kobject_init_and_add(&slave->kobj, &slave_ktype,
-				   &(slave->dev->dev.kobj), "bonding_slave");
-	if (err) {
-		kobject_put(&slave->kobj);
-		return err;
-	}
-
-	for (a = slave_attrs; *a; ++a) {
-		err = sysfs_create_file(&slave->kobj, &((*a)->attr));
-		if (err) {
-			kobject_put(&slave->kobj);
-			return err;
-		}
+	err = kobject_init_and_add(&port->kobj, &port_ktype,
+				   &(port->dev->dev.kobj), "bonding_port");
+	if (err)
+		goto err_kobject_put;
+
+	/* legacy sysfs interface */
+	err = sysfs_create_link(&(port->dev->dev.kobj), &port->kobj,
+				"bonding_slave");
+	if (err)
+		goto err_kobject_put;
+
+	for (a = port_attrs; *a; ++a) {
+		err = sysfs_create_file(&port->kobj, &((*a)->attr));
+		if (err)
+			goto err_kobject_put;
 	}
 
 	return 0;
+
+err_kobject_put:
+	kobject_put(&port->kobj);
+	return err;
 }
 
-void bond_sysfs_slave_del(struct slave *slave)
+void bond_sysfs_port_del(struct bond_port *port)
 {
-	const struct slave_attribute **a;
+	const struct port_attribute **a;
+
+	for (a = port_attrs; *a; ++a)
+		sysfs_remove_file(&port->kobj, &((*a)->attr));
 
-	for (a = slave_attrs; *a; ++a)
-		sysfs_remove_file(&slave->kobj, &((*a)->attr));
+	/* legacy sysfs interface */
+	sysfs_remove_link(&(port->dev->dev.kobj), "bonding_slave");
 
-	kobject_put(&slave->kobj);
+	kobject_put(&port->kobj);
 }
diff --git a/drivers/net/ethernet/chelsio/cxgb3/cxgb3_offload.c b/drivers/net/ethernet/chelsio/cxgb3/cxgb3_offload.c
index 84604aff53ce..5cb931228b6d 100644
--- a/drivers/net/ethernet/chelsio/cxgb3/cxgb3_offload.c
+++ b/drivers/net/ethernet/chelsio/cxgb3/cxgb3_offload.c
@@ -186,7 +186,7 @@ static struct net_device *get_iff_from_mac(struct adapter *adapter,
 			rcu_read_lock();
 			if (vlan && vlan != VLAN_VID_MASK) {
 				dev = __vlan_find_dev_deep_rcu(dev, htons(ETH_P_8021Q), vlan);
-			} else if (netif_is_bond_slave(dev)) {
+			} else if (netif_is_bond_port(dev)) {
 				struct net_device *upper_dev;
 
 				while ((upper_dev =
diff --git a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
index 598aaf8ae7ae..abcef955e55a 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
@@ -2998,7 +2998,7 @@ int mlx4_en_netdev_event(struct notifier_block *this,
 				/* in active-backup mode virtual ports are
 				 * mapped to the physical port of the active
 				 * slave */
-				if (bonding_info->slave.state ==
+				if (bonding_info->port.state ==
 				    BOND_STATE_BACKUP) {
 					if (port == 1) {
 						v2p_port1 = 2;
@@ -3020,7 +3020,7 @@ int mlx4_en_netdev_event(struct notifier_block *this,
 				/* in active-active mode a virtual port is
 				 * mapped to the native physical port if and only
 				 * if the physical port is up */
-				__s8 link = bonding_info->slave.link;
+				__s8 link = bonding_info->port.link;
 
 				if (port == 1)
 					v2p_port2 = 2;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bond.c b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bond.c
index 3e44e4d820c5..908c1755e6fb 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bond.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bond.c
@@ -186,8 +186,8 @@ static bool mlx5e_rep_is_lag_netdev(struct net_device *netdev)
 	struct mlx5e_rep_priv *rpriv;
 	struct mlx5e_priv *priv;
 
-	/* A given netdev is not a representor or not a slave of LAG configuration */
-	if (!mlx5e_eswitch_rep(netdev) || !bond_slave_get_rtnl(netdev))
+	/* A given netdev is not a representor or not a port of LAG configuration */
+	if (!mlx5e_eswitch_rep(netdev) || !bond_port_get_rtnl(netdev))
 		return false;
 
 	priv = netdev_priv(netdev);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index a0c356987e1a..dbf98be3080c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -3954,7 +3954,7 @@ static struct net_device *get_fdb_out_dev(struct net_device *uplink_dev,
 	    uplink_upper == out_dev) {
 		fdb_out_dev = uplink_dev;
 	} else if (netif_is_lag_master(out_dev)) {
-		fdb_out_dev = bond_option_active_slave_get_rcu(netdev_priv(out_dev));
+		fdb_out_dev = bond_option_active_port_get_rcu(netdev_priv(out_dev));
 		if (fdb_out_dev &&
 		    (!mlx5e_eswitch_rep(fdb_out_dev) ||
 		     !netdev_port_same_parent_id(fdb_out_dev, uplink_dev)))
diff --git a/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c b/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c
index aa28a7d8e2ea..6de1da62fcce 100644
--- a/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c
+++ b/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c
@@ -3318,12 +3318,12 @@ static void netxen_config_master(struct net_device *dev, unsigned long event)
 	master = netdev_master_upper_dev_get_rcu(dev);
 	/*
 	 * This is the case where the netxen nic is being
-	 * enslaved and is dev_open()ed in bond_enslave()
+	 * connected and is dev_open()ed in bond_connect()
 	 * Now we should program the bond's (and its vlans')
 	 * addresses in the netxen NIC.
 	 */
 	if (master && netif_is_bond_dev(master) &&
-	    !netif_is_bond_slave(dev)) {
+	    !netif_is_bond_port(dev)) {
 		netxen_config_indev_addr(adapter, master, event);
 		for_each_netdev_rcu(&init_net, slave)
 			if (is_vlan_dev(slave) &&
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 66c47631407a..ccdecdaf1c69 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1497,7 +1497,7 @@ struct net_device_ops {
  *
  * @IFF_802_1Q_VLAN: 802.1Q VLAN device
  * @IFF_EBRIDGE: Ethernet bridging device
- * @IFF_BONDING: bonding netdev or slave
+ * @IFF_BONDING: bonding netdev or port
  * @IFF_ISATAP: ISATAP interface (RFC4214)
  * @IFF_WAN_HDLC: WAN HDLC device
  * @IFF_XMIT_DST_RELEASE: dev_hard_start_xmit() is allowed to
@@ -1623,7 +1623,7 @@ enum netdev_priv_flags {
  *	@ptype_all:     Device-specific packet handlers for all protocols
  *	@ptype_specific: Device-specific, protocol-specific packet handlers
  *
- *	@adj_list:	Directly linked devices, like slaves for bonding
+ *	@adj_list:	Directly linked devices, like ports for bonding
  *	@features:	Currently active device features
  *	@hw_features:	User-changeable features
  *
@@ -2719,9 +2719,9 @@ extern rwlock_t				dev_base_lock;		/* Device list lock */
 						     dev_list)
 #define for_each_netdev_continue_rcu(net, d)		\
 	list_for_each_entry_continue_rcu(d, &(net)->dev_base_head, dev_list)
-#define for_each_netdev_in_bond_rcu(bond, slave)	\
-		for_each_netdev_rcu(&init_net, slave)	\
-			if (netdev_master_upper_dev_get_rcu(slave) == (bond))
+#define for_each_netdev_in_bond_rcu(bond, port)	\
+		for_each_netdev_rcu(&init_net, port)	\
+			if (netdev_master_upper_dev_get_rcu(port) == (bond))
 #define net_device_entry(lh)	list_entry(lh, struct net_device, dev_list)
 
 static inline struct net_device *next_net_device(struct net_device *dev)
@@ -4580,7 +4580,7 @@ struct sk_buff *skb_mac_gso_segment(struct sk_buff *skb,
 				    netdev_features_t features);
 
 struct netdev_bonding_info {
-	ifslave	slave;
+	ifslave	port;
 	ifbond	bond;
 };
 
@@ -4810,7 +4810,7 @@ static inline bool netif_is_bond_dev(const struct net_device *dev)
 	return dev->flags & IFF_MASTER && dev->priv_flags & IFF_BONDING;
 }
 
-static inline bool netif_is_bond_slave(const struct net_device *dev)
+static inline bool netif_is_bond_port(const struct net_device *dev)
 {
 	return dev->flags & IFF_SLAVE && dev->priv_flags & IFF_BONDING;
 }
@@ -4877,7 +4877,7 @@ static inline bool netif_is_lag_master(const struct net_device *dev)
 
 static inline bool netif_is_lag_port(const struct net_device *dev)
 {
-	return netif_is_bond_slave(dev) || netif_is_team_port(dev);
+	return netif_is_bond_port(dev) || netif_is_team_port(dev);
 }
 
 static inline bool netif_is_rxfh_configured(const struct net_device *dev)
diff --git a/include/net/bond_3ad.h b/include/net/bond_3ad.h
index 8c838eb9a997..751d6055a53d 100644
--- a/include/net/bond_3ad.h
+++ b/include/net/bond_3ad.h
@@ -138,7 +138,7 @@ typedef struct bond_marker {
 	u8 tlv_type;		/* = 0x01  (marker information) */
 	/* = 0x02  (marker response information) */
 	u8 marker_length;	/* = 0x16 */
-	u16 requester_port;	/* The number assigned to the port by the requester */
+	u16 requester_port;	/* The number assigned to the ad_port by the requester */
 	struct mac_addr requester_system;	/* The requester's system id */
 	u32 requester_transaction_id;		/* The transaction id allocated by the requester, */
 	u16 pad;		/* = 0 */
@@ -154,7 +154,7 @@ typedef struct bond_marker_header {
 
 #pragma pack()
 
-struct slave;
+struct bond_port;
 struct bonding;
 struct ad_info;
 struct ad_port;
@@ -190,7 +190,7 @@ typedef struct aggregator {
 	u16 transmit_state;	/* BOOLEAN */
 	struct ad_port *lag_ports;
 	/* ****** PRIVATE PARAMETERS ****** */
-	struct slave *slave;	/* pointer to the bond slave that this aggregator belongs to */
+	struct bond_port *port;	/* pointer to the bond port that this aggregator belongs to */
 	u16 is_active;		/* BOOLEAN. Indicates if this aggregator is active */
 	u16 num_of_ports;
 } aggregator_t;
@@ -204,7 +204,7 @@ struct port_params {
 	u16 port_state;
 };
 
-/* ad_port structure(43.4.6 in the 802.3ad standard) */
+/* ad_port structure (43.4.6 in the 802.3ad standard) */
 typedef struct ad_port {
 	u16 actor_port_number;
 	u16 actor_port_priority;
@@ -223,7 +223,7 @@ typedef struct ad_port {
 	bool is_enabled;
 
 	/* ****** PRIVATE PARAMETERS ****** */
-	u16 sm_vars;		/* all state machines variables for this port */
+	u16 sm_vars;		/* all state machines variables for this ad_port */
 	rx_states_t sm_rx_state;	/* state machine rx state */
 	u16 sm_rx_timer_counter;	/* state machine rx timer counter */
 	periodic_states_t sm_periodic_state;	/* state machine periodic state */
@@ -238,11 +238,11 @@ typedef struct ad_port {
 	u32 churn_partner_count;
 	churn_state_t sm_churn_actor_state;
 	churn_state_t sm_churn_partner_state;
-	struct slave *slave;		/* pointer to the bond slave that this port belongs to */
-	struct aggregator *aggregator;	/* pointer to an aggregator that this port related to */
+	struct bond_port *port;		/* pointer to the bond port that this ad_port belongs to */
+	struct aggregator *aggregator;	/* pointer to an aggregator that this ad_port related to */
 	struct ad_port *next_port_in_aggregator;	/* Next port on the linked list of the parent aggregator */
 	u32 transaction_id;		/* continuous number for identification of Marker PDU's; */
-	struct lacpdu lacpdu;		/* the lacpdu that will be sent for this port */
+	struct lacpdu lacpdu;		/* the lacpdu that will be sent for this ad_port */
 } ad_port_t;
 
 /* system structure */
@@ -257,7 +257,7 @@ struct ad_system {
 
 /* ========== AD Exported structures to the main bonding code ========== */
 #define BOND_AD_INFO(bond)   ((bond)->ad_info)
-#define SLAVE_AD_INFO(slave) ((slave)->ad_info)
+#define PORT_AD_INFO(port) ((port)->ad_info)
 
 struct ad_bond_info {
 	struct ad_system system;	/* 802.3ad system structure */
@@ -266,7 +266,7 @@ struct ad_bond_info {
 	u16 aggregator_identifier;
 };
 
-struct ad_slave_info {
+struct ad_bond_port_info {
 	struct aggregator aggregator;	/* 802.3ad aggregator structure */
 	struct ad_port ad_port;		/* 802.3ad port structure */
 	struct bond_3ad_stats stats;
@@ -291,17 +291,17 @@ static inline const char *bond_3ad_churn_desc(churn_state_t state)
 
 /* ========== AD Exported functions to the main bonding code ========== */
 void bond_3ad_initialize(struct bonding *bond, u16 tick_resolution);
-void bond_3ad_bind_slave(struct slave *slave);
-void bond_3ad_unbind_slave(struct slave *slave);
+void bond_3ad_bind_port(struct bond_port *port);
+void bond_3ad_unbind_port(struct bond_port *port);
 void bond_3ad_state_machine_handler(struct work_struct *);
 void bond_3ad_initiate_agg_selection(struct bonding *bond, int timeout);
-void bond_3ad_adapter_speed_duplex_changed(struct slave *slave);
-void bond_3ad_handle_link_change(struct slave *slave, char link);
+void bond_3ad_adapter_speed_duplex_changed(struct bond_port *port);
+void bond_3ad_handle_link_change(struct bond_port *port, char link);
 int  bond_3ad_get_active_agg_info(struct bonding *bond, struct ad_info *ad_info);
 int  __bond_3ad_get_active_agg_info(struct bonding *bond,
 				    struct ad_info *ad_info);
 int bond_3ad_lacpdu_recv(const struct sk_buff *skb, struct bonding *bond,
-			 struct slave *slave);
+			 struct bond_port *port);
 int bond_3ad_set_carrier(struct bonding *bond);
 void bond_3ad_update_lacp_rate(struct bonding *bond);
 void bond_3ad_update_ad_actor_settings(struct bonding *bond);
diff --git a/include/net/bond_alb.h b/include/net/bond_alb.h
index f6af76c87a6c..2ebec8a9248f 100644
--- a/include/net/bond_alb.h
+++ b/include/net/bond_alb.h
@@ -9,10 +9,10 @@
 #include <linux/if_ether.h>
 
 struct bonding;
-struct slave;
+struct bond_port;
 
 #define BOND_ALB_INFO(bond)   ((bond)->alb_info)
-#define SLAVE_TLB_INFO(slave) ((slave)->tlb_info)
+#define PORT_TLB_INFO(port) ((port)->tlb_info)
 
 #define ALB_TIMER_TICKS_PER_SEC	    10	/* should be a divisor of HZ */
 #define BOND_TLB_REBALANCE_INTERVAL 10	/* In seconds, periodic re-balancing.
@@ -46,33 +46,33 @@ struct slave;
 #define RLB_UPDATE_RETRY	3 /* 3-ticks - must be smaller than the rlb
 				   * rebalance interval (5 min).
 				   */
-/* RLB_PROMISC_TIMEOUT = 10 sec equals the time that the current slave is
+/* RLB_PROMISC_TIMEOUT = 10 sec equals the time that the current port is
  * promiscuous after failover
  */
 #define RLB_PROMISC_TIMEOUT	(10*ALB_TIMER_TICKS_PER_SEC)
 
 
 struct tlb_client_info {
-	struct slave *tx_slave;	/* A pointer to slave used for transmiting
-				 * packets to a Client that the Hash function
-				 * gave this entry index.
-				 */
-	u32 tx_bytes;		/* Each Client accumulates the BytesTx that
-				 * were transmitted to it, and after each
-				 * CallBack the LoadHistory is divided
-				 * by the balance interval
-				 */
-	u32 load_history;	/* This field contains the amount of Bytes
-				 * that were transmitted to this client by
-				 * the server on the previous balance
-				 * interval in Bps.
-				 */
-	u32 next;		/* The next Hash table entry index, assigned
-				 * to use the same adapter for transmit.
-				 */
-	u32 prev;		/* The previous Hash table entry index,
-				 * assigned to use the same
-				 */
+	struct bond_port *tx_port; /* A pointer to port used for transmiting
+				    * packets to a Client that the Hash function
+				    * gave this entry index.
+				    */
+	u32 tx_bytes;		   /* Each Client accumulates the BytesTx that
+				    * were transmitted to it, and after each
+				    * CallBack the LoadHistory is divided
+				    * by the balance interval
+				    */
+	u32 load_history;	   /* This field contains the amount of Bytes
+				    * that were transmitted to this client by
+				    * the server on the previous balance
+				    * interval in Bps.
+				    */
+	u32 next;		   /* The next Hash table entry index, assigned
+				    * to use the same adapter for transmit.
+				    */
+	u32 prev;		   /* The previous Hash table entry index,
+				    * assigned to use the same
+				    */
 };
 
 /* -------------------------------------------------------------------------
@@ -108,17 +108,17 @@ struct rlb_client_info {
 
 	u8  assigned;		/* checking whether this entry is assigned */
 	u8  ntt;		/* flag - need to transmit client info */
-	struct slave *slave;	/* the slave assigned to this client */
+	struct bond_port *port;	/* the port assigned to this client */
 	unsigned short vlan_id;	/* VLAN tag associated with IP address */
 };
 
-struct tlb_slave_info {
+struct tlb_port_info {
 	u32 head;	/* Index to the head of the bi-directional clients
 			 * hash table entries list. The entries in the list
 			 * are the entries that were assigned to use this
-			 * slave for transmit.
+			 * port for transmit.
 			 */
-	u32 load;	/* Each slave sums the loadHistory of all clients
+	u32 load;	/* Each port sums the loadHistory of all clients
 			 * assigned to it
 			 */
 };
@@ -135,7 +135,7 @@ struct alb_bond_info {
 	u8			rx_ntt;	/* flag - need to transmit
 					 * to all rx clients
 					 */
-	struct slave		*rx_slave;/* last slave to xmit from */
+	struct bond_port	*rx_port;/* last port to xmit from */
 	u8			primary_is_promisc;	   /* boolean */
 	u32			rlb_promisc_timeout_counter;/* counts primary
 							     * promiscuity time
@@ -152,16 +152,18 @@ struct alb_bond_info {
 
 int bond_alb_initialize(struct bonding *bond, int rlb_enabled);
 void bond_alb_deinitialize(struct bonding *bond);
-int bond_alb_init_slave(struct bonding *bond, struct slave *slave);
-void bond_alb_deinit_slave(struct bonding *bond, struct slave *slave);
-void bond_alb_handle_link_change(struct bonding *bond, struct slave *slave, char link);
-void bond_alb_handle_active_change(struct bonding *bond, struct slave *new_slave);
+int bond_alb_init_port(struct bonding *bond, struct bond_port *port);
+void bond_alb_deinit_port(struct bonding *bond, struct bond_port *port);
+void bond_alb_handle_link_change(struct bonding *bond, struct bond_port *port,
+				 char link);
+void bond_alb_handle_active_change(struct bonding *bond,
+				   struct bond_port *new_port);
 int bond_alb_xmit(struct sk_buff *skb, struct net_device *bond_dev);
 int bond_tlb_xmit(struct sk_buff *skb, struct net_device *bond_dev);
-struct slave *bond_xmit_alb_slave_get(struct bonding *bond,
-				      struct sk_buff *skb);
-struct slave *bond_xmit_tlb_slave_get(struct bonding *bond,
-				      struct sk_buff *skb);
+struct bond_port *bond_xmit_alb_port_get(struct bonding *bond,
+					 struct sk_buff *skb);
+struct bond_port *bond_xmit_tlb_port_get(struct bonding *bond,
+					 struct sk_buff *skb);
 void bond_alb_monitor(struct work_struct *);
 int bond_alb_set_mac_address(struct net_device *bond_dev, void *addr);
 void bond_alb_clear_vlan(struct bonding *bond, unsigned short vlan_id);
diff --git a/include/net/bond_options.h b/include/net/bond_options.h
index 9d382f2f0bc5..424e627877a5 100644
--- a/include/net/bond_options.h
+++ b/include/net/bond_options.h
@@ -12,12 +12,12 @@
 #define BOND_MODE_ALL_EX(x) (~(x))
 
 /* Option flags:
- * BOND_OPTFLAG_NOSLAVES - check if the bond device is empty before setting
+ * BOND_OPTFLAG_NOPORTS - check if the bond device is empty before setting
  * BOND_OPTFLAG_IFDOWN - check if the bond device is down before setting
  * BOND_OPTFLAG_RAWVAL - the option parses the value itself
  */
 enum {
-	BOND_OPTFLAG_NOSLAVES	= BIT(0),
+	BOND_OPTFLAG_NOPORTS	= BIT(0),
 	BOND_OPTFLAG_IFDOWN	= BIT(1),
 	BOND_OPTFLAG_RAWVAL	= BIT(2)
 };
@@ -35,7 +35,7 @@ enum {
 /* Option IDs, their bit positions correspond to their IDs */
 enum {
 	BOND_OPT_MODE,
-	BOND_OPT_PACKETS_PER_SLAVE,
+	BOND_OPT_PACKETS_PER_PORT,
 	BOND_OPT_XMIT_HASH,
 	BOND_OPT_ARP_VALIDATE,
 	BOND_OPT_ARP_ALL_TARGETS,
@@ -52,18 +52,24 @@ enum {
 	BOND_OPT_PRIMARY,
 	BOND_OPT_PRIMARY_RESELECT,
 	BOND_OPT_USE_CARRIER,
-	BOND_OPT_ACTIVE_SLAVE,
+	BOND_OPT_ACTIVE_PORT,
 	BOND_OPT_QUEUE_ID,
-	BOND_OPT_ALL_SLAVES_ACTIVE,
+	BOND_OPT_ALL_PORTS_ACTIVE,
 	BOND_OPT_RESEND_IGMP,
 	BOND_OPT_LP_INTERVAL,
-	BOND_OPT_SLAVES,
+	BOND_OPT_PORTS,
 	BOND_OPT_TLB_DYNAMIC_LB,
 	BOND_OPT_AD_ACTOR_SYS_PRIO,
 	BOND_OPT_AD_ACTOR_SYSTEM,
 	BOND_OPT_AD_USER_PORT_KEY,
 	BOND_OPT_NUM_PEER_NOTIF_ALIAS,
 	BOND_OPT_PEER_NOTIF_DELAY,
+/* legacy sysfs interface names */
+	BOND_OPT_PACKETS_PER_SLAVE,
+	BOND_OPT_ACTIVE_SLAVE,
+	BOND_OPT_ALL_SLAVES_ACTIVE,
+	BOND_OPT_SLAVES,
+/* end legacy sysfs interface names */
 	BOND_OPT_LAST
 };
 
diff --git a/include/net/bonding.h b/include/net/bonding.h
index bf4f0e1dc2bf..ed130621a506 100644
--- a/include/net/bonding.h
+++ b/include/net/bonding.h
@@ -38,52 +38,52 @@
 #define __long_aligned __attribute__((aligned((sizeof(long)))))
 #endif
 
-#define slave_info(bond_dev, slave_dev, fmt, ...) \
-	netdev_info(bond_dev, "(slave %s): " fmt, (slave_dev)->name, ##__VA_ARGS__)
-#define slave_warn(bond_dev, slave_dev, fmt, ...) \
-	netdev_warn(bond_dev, "(slave %s): " fmt, (slave_dev)->name, ##__VA_ARGS__)
-#define slave_dbg(bond_dev, slave_dev, fmt, ...) \
-	netdev_dbg(bond_dev, "(slave %s): " fmt, (slave_dev)->name, ##__VA_ARGS__)
-#define slave_err(bond_dev, slave_dev, fmt, ...) \
-	netdev_err(bond_dev, "(slave %s): " fmt, (slave_dev)->name, ##__VA_ARGS__)
+#define port_info(bond_dev, port_dev, fmt, ...) \
+	netdev_info(bond_dev, "(port %s): " fmt, (port_dev)->name, ##__VA_ARGS__)
+#define port_warn(bond_dev, port_dev, fmt, ...) \
+	netdev_warn(bond_dev, "(port %s): " fmt, (port_dev)->name, ##__VA_ARGS__)
+#define port_dbg(bond_dev, port_dev, fmt, ...) \
+	netdev_dbg(bond_dev, "(port %s): " fmt, (port_dev)->name, ##__VA_ARGS__)
+#define port_err(bond_dev, port_dev, fmt, ...) \
+	netdev_err(bond_dev, "(port %s): " fmt, (port_dev)->name, ##__VA_ARGS__)
 
 #define BOND_MODE(bond) ((bond)->params.mode)
 
-/* slave list primitives */
-#define bond_slave_list(bond) (&(bond)->dev->adj_list.lower)
+/* port list primitives */
+#define bond_port_list(bond) (&(bond)->dev->adj_list.lower)
 
-#define bond_has_slaves(bond) !list_empty(bond_slave_list(bond))
+#define bond_has_ports(bond) !list_empty(bond_port_list(bond))
 
-/* IMPORTANT: bond_first/last_slave can return NULL in case of an empty list */
-#define bond_first_slave(bond) \
-	(bond_has_slaves(bond) ? \
-		netdev_adjacent_get_private(bond_slave_list(bond)->next) : \
+/* IMPORTANT: bond_first/last_port can return NULL in case of an empty list */
+#define bond_first_port(bond) \
+	(bond_has_ports(bond) ? \
+		netdev_adjacent_get_private(bond_port_list(bond)->next) : \
 		NULL)
-#define bond_last_slave(bond) \
-	(bond_has_slaves(bond) ? \
-		netdev_adjacent_get_private(bond_slave_list(bond)->prev) : \
+#define bond_last_port(bond) \
+	(bond_has_ports(bond) ? \
+		netdev_adjacent_get_private(bond_port_list(bond)->prev) : \
 		NULL)
 
 /* Caller must have rcu_read_lock */
-#define bond_first_slave_rcu(bond) \
+#define bond_first_port_rcu(bond) \
 	netdev_lower_get_first_private_rcu(bond->dev)
 
-#define bond_is_first_slave(bond, pos) (pos == bond_first_slave(bond))
-#define bond_is_last_slave(bond, pos) (pos == bond_last_slave(bond))
+#define bond_is_first_port(bond, pos) (pos == bond_first_port(bond))
+#define bond_is_last_port(bond, pos) (pos == bond_last_port(bond))
 
 /**
- * bond_for_each_slave - iterate over all slaves
+ * bond_for_each_port - iterate over all ports
  * @bond:	the bond holding this list
- * @pos:	current slave
+ * @pos:	current port
  * @iter:	list_head * iterator
  *
  * Caller must hold RTNL
  */
-#define bond_for_each_slave(bond, pos, iter) \
+#define bond_for_each_port(bond, pos, iter) \
 	netdev_for_each_lower_private((bond)->dev, pos, iter)
 
 /* Caller must have rcu_read_lock */
-#define bond_for_each_slave_rcu(bond, pos, iter) \
+#define bond_for_each_port_rcu(bond, pos, iter) \
 	netdev_for_each_lower_private_rcu((bond)->dev, pos, iter)
 
 #ifdef CONFIG_XFRM_OFFLOAD
@@ -136,12 +136,12 @@ struct bond_params {
 	int primary_reselect;
 	__be32 arp_targets[BOND_MAX_ARP_TARGETS];
 	int tx_queues;
-	int all_slaves_active;
+	int all_ports_active;
 	int resend_igmp;
 	int lp_interval;
-	int packets_per_slave;
+	int packets_per_port;
 	int tlb_dynamic_lb;
-	struct reciprocal_value reciprocal_packets_per_slave;
+	struct reciprocal_value reciprocal_packets_per_port;
 	u16 ad_actor_sys_prio;
 	u16 ad_user_port_key;
 
@@ -154,7 +154,7 @@ struct bond_parm_tbl {
 	int mode;
 };
 
-struct slave {
+struct bond_port {
 	struct net_device *dev; /* first - useful for panic debug */
 	struct bonding *bond; /* our bond link aggregator */
 	int    delay;
@@ -164,9 +164,9 @@ struct slave {
 	unsigned long target_last_arp_rx[BOND_MAX_ARP_TARGETS];
 	s8     link;		/* one of BOND_LINK_XXXX */
 	s8     link_new_state;	/* one of BOND_LINK_XXXX */
-	u8     backup:1,   /* indicates backup slave. Value corresponds with
+	u8     backup:1,   /* indicates backup port. Value corresponds with
 			      BOND_STATE_ACTIVE and BOND_STATE_BACKUP */
-	       inactive:1, /* indicates inactive slave */
+	       inactive:1, /* indicates inactive port */
 	       should_notify:1, /* indicates whether the state changed */
 	       should_notify_link:1; /* indicates whether the link changed */
 	u8     duplex;
@@ -175,20 +175,20 @@ struct slave {
 	u32    speed;
 	u16    queue_id;
 	u8     perm_hwaddr[MAX_ADDR_LEN];
-	struct ad_slave_info *ad_info;
-	struct tlb_slave_info tlb_info;
+	struct ad_bond_port_info *ad_info;
+	struct tlb_port_info tlb_info;
 #ifdef CONFIG_NET_POLL_CONTROLLER
 	struct netpoll *np;
 #endif
 	struct delayed_work notify_work;
 	struct kobject kobj;
-	struct rtnl_link_stats64 slave_stats;
+	struct rtnl_link_stats64 port_stats;
 };
 
-struct bond_up_slave {
-	unsigned int	count;
-	struct rcu_head rcu;
-	struct slave	*arr[];
+struct bond_up_port {
+	unsigned int		count;
+	struct rcu_head		rcu;
+	struct bond_port	*arr[];
 };
 
 /*
@@ -198,21 +198,21 @@ struct bond_up_slave {
 
 /*
  * Here are the locking policies for the two bonding locks:
- * Get rcu_read_lock when reading or RTNL when writing slave list.
+ * Get rcu_read_lock when reading or RTNL when writing port list.
  */
 struct bonding {
 	struct   net_device *dev; /* first - useful for panic debug */
-	struct   slave __rcu *curr_active_slave;
-	struct   slave __rcu *current_arp_slave;
-	struct   slave __rcu *primary_slave;
-	struct   bond_up_slave __rcu *usable_slaves;
-	struct   bond_up_slave __rcu *all_slaves;
+	struct   bond_port __rcu *curr_active_port;
+	struct   bond_port __rcu *current_arp_port;
+	struct   bond_port __rcu *primary_port;
+	struct   bond_up_port __rcu *usable_ports;
+	struct   bond_up_port __rcu *all_ports;
 	bool     force_primary;
-	s32      slave_cnt; /* never change this value outside the attach/detach wrappers */
+	s32      port_cnt; /* never change this value outside the attach/detach wrappers */
 	int     (*recv_probe)(const struct sk_buff *, struct bonding *,
-			      struct slave *);
+			      struct bond_port *);
 	/* mode_lock is used for mode-specific locking needs, currently used by:
-	 * 3ad mode (4) - protect against running bond_3ad_unbind_slave() and
+	 * 3ad mode (4) - protect against running bond_3ad_unbind_port() and
 	 *                bond_3ad_state_machine_handler() concurrently and also
 	 *                the access to the state machine shared variables.
 	 * TLB mode (5) - to sync the use and modifications of its hash table
@@ -237,7 +237,7 @@ struct bonding {
 	struct   delayed_work alb_work;
 	struct   delayed_work ad_work;
 	struct   delayed_work mcast_work;
-	struct   delayed_work slave_arr_work;
+	struct   delayed_work port_arr_work;
 #ifdef CONFIG_DEBUG_FS
 	/* debugging support via debugfs */
 	struct	 dentry *debug_dir;
@@ -248,14 +248,14 @@ struct bonding {
 #endif /* CONFIG_XFRM_OFFLOAD */
 };
 
-#define bond_slave_get_rcu(dev) \
-	((struct slave *) rcu_dereference(dev->rx_handler_data))
+#define bond_port_get_rcu(dev) \
+	((struct bond_port *) rcu_dereference(dev->rx_handler_data))
 
-#define bond_slave_get_rtnl(dev) \
-	((struct slave *) rtnl_dereference(dev->rx_handler_data))
+#define bond_port_get_rtnl(dev) \
+	((struct bond_port *) rtnl_dereference(dev->rx_handler_data))
 
-void bond_queue_slave_event(struct slave *slave);
-void bond_lower_state_changed(struct slave *slave);
+void bond_queue_port_event(struct bond_port *port);
+void bond_lower_state_changed(struct bond_port *port);
 
 struct bond_vlan_tag {
 	__be16		vlan_proto;
@@ -263,19 +263,19 @@ struct bond_vlan_tag {
 };
 
 /**
- * Returns NULL if the net_device does not belong to any of the bond's slaves
+ * Returns NULL if the net_device does not belong to any of the bond's ports
  *
  * Caller must hold bond lock for read
  */
-static inline struct slave *bond_get_slave_by_dev(struct bonding *bond,
-						  struct net_device *slave_dev)
+static inline struct bond_port *bond_get_port_by_dev(struct bonding *bond,
+						     struct net_device *port_dev)
 {
-	return netdev_lower_dev_get_private(bond->dev, slave_dev);
+	return netdev_lower_dev_get_private(bond->dev, port_dev);
 }
 
-static inline struct bonding *bond_get_bond_by_slave(struct slave *slave)
+static inline struct bonding *bond_get_bond_by_port(struct bond_port *port)
 {
-	return slave->bond;
+	return port->bond;
 }
 
 static inline bool bond_should_override_tx_queue(struct bonding *bond)
@@ -332,74 +332,74 @@ static inline bool bond_uses_primary(struct bonding *bond)
 	return bond_mode_uses_primary(BOND_MODE(bond));
 }
 
-static inline struct net_device *bond_option_active_slave_get_rcu(struct bonding *bond)
+static inline struct net_device *bond_option_active_port_get_rcu(struct bonding *bond)
 {
-	struct slave *slave = rcu_dereference(bond->curr_active_slave);
+	struct bond_port *port = rcu_dereference(bond->curr_active_port);
 
-	return bond_uses_primary(bond) && slave ? slave->dev : NULL;
+	return bond_uses_primary(bond) && port ? port->dev : NULL;
 }
 
-static inline bool bond_slave_is_up(struct slave *slave)
+static inline bool bond_port_is_up(struct bond_port *port)
 {
-	return netif_running(slave->dev) && netif_carrier_ok(slave->dev);
+	return netif_running(port->dev) && netif_carrier_ok(port->dev);
 }
 
-static inline void bond_set_active_slave(struct slave *slave)
+static inline void bond_set_active_port(struct bond_port *port)
 {
-	if (slave->backup) {
-		slave->backup = 0;
-		bond_queue_slave_event(slave);
-		bond_lower_state_changed(slave);
+	if (port->backup) {
+		port->backup = 0;
+		bond_queue_port_event(port);
+		bond_lower_state_changed(port);
 	}
 }
 
-static inline void bond_set_backup_slave(struct slave *slave)
+static inline void bond_set_backup_port(struct bond_port *port)
 {
-	if (!slave->backup) {
-		slave->backup = 1;
-		bond_queue_slave_event(slave);
-		bond_lower_state_changed(slave);
+	if (!port->backup) {
+		port->backup = 1;
+		bond_queue_port_event(port);
+		bond_lower_state_changed(port);
 	}
 }
 
-static inline void bond_set_slave_state(struct slave *slave,
-					int slave_state, bool notify)
+static inline void bond_set_port_state(struct bond_port *port,
+				       int port_state, bool notify)
 {
-	if (slave->backup == slave_state)
+	if (port->backup == port_state)
 		return;
 
-	slave->backup = slave_state;
+	port->backup = port_state;
 	if (notify) {
-		bond_lower_state_changed(slave);
-		bond_queue_slave_event(slave);
-		slave->should_notify = 0;
+		bond_lower_state_changed(port);
+		bond_queue_port_event(port);
+		port->should_notify = 0;
 	} else {
-		if (slave->should_notify)
-			slave->should_notify = 0;
+		if (port->should_notify)
+			port->should_notify = 0;
 		else
-			slave->should_notify = 1;
+			port->should_notify = 1;
 	}
 }
 
-static inline void bond_slave_state_change(struct bonding *bond)
+static inline void bond_port_state_change(struct bonding *bond)
 {
 	struct list_head *iter;
-	struct slave *tmp;
+	struct bond_port *tmp;
 
-	bond_for_each_slave(bond, tmp, iter) {
+	bond_for_each_port(bond, tmp, iter) {
 		if (tmp->link == BOND_LINK_UP)
-			bond_set_active_slave(tmp);
+			bond_set_active_port(tmp);
 		else if (tmp->link == BOND_LINK_DOWN)
-			bond_set_backup_slave(tmp);
+			bond_set_backup_port(tmp);
 	}
 }
 
-static inline void bond_slave_state_notify(struct bonding *bond)
+static inline void bond_port_state_notify(struct bonding *bond)
 {
 	struct list_head *iter;
-	struct slave *tmp;
+	struct bond_port *tmp;
 
-	bond_for_each_slave(bond, tmp, iter) {
+	bond_for_each_port(bond, tmp, iter) {
 		if (tmp->should_notify) {
 			bond_lower_state_changed(tmp);
 			tmp->should_notify = 0;
@@ -407,30 +407,30 @@ static inline void bond_slave_state_notify(struct bonding *bond)
 	}
 }
 
-static inline int bond_slave_state(struct slave *slave)
+static inline int bond_port_state(struct bond_port *port)
 {
-	return slave->backup;
+	return port->backup;
 }
 
-static inline bool bond_is_active_slave(struct slave *slave)
+static inline bool bond_is_active_port(struct bond_port *port)
 {
-	return !bond_slave_state(slave);
+	return !bond_port_state(port);
 }
 
-static inline bool bond_slave_can_tx(struct slave *slave)
+static inline bool bond_port_can_tx(struct bond_port *port)
 {
-	return bond_slave_is_up(slave) && slave->link == BOND_LINK_UP &&
-	       bond_is_active_slave(slave);
+	return bond_port_is_up(port) && port->link == BOND_LINK_UP &&
+	       bond_is_active_port(port);
 }
 
-static inline bool bond_is_active_slave_dev(const struct net_device *slave_dev)
+static inline bool bond_is_active_port_dev(const struct net_device *port_dev)
 {
-	struct slave *slave;
+	struct bond_port *port;
 	bool active;
 
 	rcu_read_lock();
-	slave = bond_slave_get_rcu(slave_dev);
-	active = bond_is_active_slave(slave);
+	port = bond_port_get_rcu(port_dev);
+	active = bond_is_active_port(port);
 	rcu_read_unlock();
 
 	return active;
@@ -468,16 +468,16 @@ static inline void bond_hw_addr_copy(u8 *dst, const u8 *src, unsigned int len)
 #define BOND_ARP_FILTER_BACKUP		(BOND_ARP_VALIDATE_BACKUP | \
 					 BOND_ARP_FILTER)
 
-#define BOND_SLAVE_NOTIFY_NOW		true
-#define BOND_SLAVE_NOTIFY_LATER		false
+#define BOND_PORT_NOTIFY_NOW		true
+#define BOND_PORT_NOTIFY_LATER		false
 
-static inline int slave_do_arp_validate(struct bonding *bond,
-					struct slave *slave)
+static inline int port_do_arp_validate(struct bonding *bond,
+				       struct bond_port *port)
 {
-	return bond->params.arp_validate & (1 << bond_slave_state(slave));
+	return bond->params.arp_validate & (1 << bond_port_state(port));
 }
 
-static inline int slave_do_arp_validate_only(struct bonding *bond)
+static inline int port_do_arp_validate_only(struct bonding *bond)
 {
 	return bond->params.arp_validate & BOND_ARP_FILTER;
 }
@@ -487,105 +487,105 @@ static inline int bond_is_ip_target_ok(__be32 addr)
 	return !ipv4_is_lbcast(addr) && !ipv4_is_zeronet(addr);
 }
 
-/* Get the oldest arp which we've received on this slave for bond's
+/* Get the oldest arp which we've received on this port for bond's
  * arp_targets.
  */
-static inline unsigned long slave_oldest_target_arp_rx(struct bonding *bond,
-						       struct slave *slave)
+static inline unsigned long port_oldest_target_arp_rx(struct bonding *bond,
+						      struct bond_port *port)
 {
 	int i = 1;
-	unsigned long ret = slave->target_last_arp_rx[0];
+	unsigned long ret = port->target_last_arp_rx[0];
 
 	for (; (i < BOND_MAX_ARP_TARGETS) && bond->params.arp_targets[i]; i++)
-		if (time_before(slave->target_last_arp_rx[i], ret))
-			ret = slave->target_last_arp_rx[i];
+		if (time_before(port->target_last_arp_rx[i], ret))
+			ret = port->target_last_arp_rx[i];
 
 	return ret;
 }
 
-static inline unsigned long slave_last_rx(struct bonding *bond,
-					struct slave *slave)
+static inline unsigned long port_last_rx(struct bonding *bond,
+					 struct bond_port *port)
 {
 	if (bond->params.arp_all_targets == BOND_ARP_TARGETS_ALL)
-		return slave_oldest_target_arp_rx(bond, slave);
+		return port_oldest_target_arp_rx(bond, port);
 
-	return slave->last_rx;
+	return port->last_rx;
 }
 
 #ifdef CONFIG_NET_POLL_CONTROLLER
-static inline netdev_tx_t bond_netpoll_send_skb(const struct slave *slave,
-					 struct sk_buff *skb)
+static inline netdev_tx_t bond_netpoll_send_skb(const struct bond_port *port,
+						struct sk_buff *skb)
 {
-	return netpoll_send_skb(slave->np, skb);
+	return netpoll_send_skb(port->np, skb);
 }
 #else
-static inline netdev_tx_t bond_netpoll_send_skb(const struct slave *slave,
-					 struct sk_buff *skb)
+static inline netdev_tx_t bond_netpoll_send_skb(const struct bond_port *port,
+						struct sk_buff *skb)
 {
 	BUG();
 	return NETDEV_TX_OK;
 }
 #endif
 
-static inline void bond_set_slave_inactive_flags(struct slave *slave,
-						 bool notify)
+static inline void bond_set_port_inactive_flags(struct bond_port *port,
+						bool notify)
 {
-	if (!bond_is_lb(slave->bond))
-		bond_set_slave_state(slave, BOND_STATE_BACKUP, notify);
-	if (!slave->bond->params.all_slaves_active)
-		slave->inactive = 1;
+	if (!bond_is_lb(port->bond))
+		bond_set_port_state(port, BOND_STATE_BACKUP, notify);
+	if (!port->bond->params.all_ports_active)
+		port->inactive = 1;
 }
 
-static inline void bond_set_slave_active_flags(struct slave *slave,
-					       bool notify)
+static inline void bond_set_port_active_flags(struct bond_port *port,
+					      bool notify)
 {
-	bond_set_slave_state(slave, BOND_STATE_ACTIVE, notify);
-	slave->inactive = 0;
+	bond_set_port_state(port, BOND_STATE_ACTIVE, notify);
+	port->inactive = 0;
 }
 
-static inline bool bond_is_slave_inactive(struct slave *slave)
+static inline bool bond_is_port_inactive(struct bond_port *port)
 {
-	return slave->inactive;
+	return port->inactive;
 }
 
-static inline void bond_propose_link_state(struct slave *slave, int state)
+static inline void bond_propose_link_state(struct bond_port *port, int state)
 {
-	slave->link_new_state = state;
+	port->link_new_state = state;
 }
 
-static inline void bond_commit_link_state(struct slave *slave, bool notify)
+static inline void bond_commit_link_state(struct bond_port *port, bool notify)
 {
-	if (slave->link_new_state == BOND_LINK_NOCHANGE)
+	if (port->link_new_state == BOND_LINK_NOCHANGE)
 		return;
 
-	slave->link = slave->link_new_state;
+	port->link = port->link_new_state;
 	if (notify) {
-		bond_queue_slave_event(slave);
-		bond_lower_state_changed(slave);
-		slave->should_notify_link = 0;
+		bond_queue_port_event(port);
+		bond_lower_state_changed(port);
+		port->should_notify_link = 0;
 	} else {
-		if (slave->should_notify_link)
-			slave->should_notify_link = 0;
+		if (port->should_notify_link)
+			port->should_notify_link = 0;
 		else
-			slave->should_notify_link = 1;
+			port->should_notify_link = 1;
 	}
 }
 
-static inline void bond_set_slave_link_state(struct slave *slave, int state,
-					     bool notify)
+static inline void bond_set_port_link_state(struct bond_port *port, int state,
+					    bool notify)
 {
-	bond_propose_link_state(slave, state);
-	bond_commit_link_state(slave, notify);
+	bond_propose_link_state(port, state);
+	bond_commit_link_state(port, notify);
 }
 
-static inline void bond_slave_link_notify(struct bonding *bond)
+static inline void bond_port_link_notify(struct bonding *bond)
 {
 	struct list_head *iter;
-	struct slave *tmp;
+	struct bond_port *tmp;
 
-	bond_for_each_slave(bond, tmp, iter) {
+	bond_for_each_port(bond, tmp, iter) {
 		if (tmp->should_notify_link) {
-			bond_queue_slave_event(tmp);
+			bond_queue_port_event(tmp);
 			bond_lower_state_changed(tmp);
 			tmp->should_notify_link = 0;
 		}
@@ -618,21 +618,21 @@ struct bond_net {
 	struct class_attribute	class_attr_bonding_devs;
 };
 
-int bond_arp_rcv(const struct sk_buff *skb, struct bonding *bond, struct slave *slave);
-netdev_tx_t bond_dev_queue_xmit(struct bonding *bond, struct sk_buff *skb, struct net_device *slave_dev);
+int bond_arp_rcv(const struct sk_buff *skb, struct bonding *bond, struct bond_port *port);
+netdev_tx_t bond_dev_queue_xmit(struct bonding *bond, struct sk_buff *skb, struct net_device *port_dev);
 int bond_create(struct net *net, const char *name);
 int bond_create_sysfs(struct bond_net *net);
 void bond_destroy_sysfs(struct bond_net *net);
 void bond_prepare_sysfs_group(struct bonding *bond);
-int bond_sysfs_slave_add(struct slave *slave);
-void bond_sysfs_slave_del(struct slave *slave);
-int bond_enslave(struct net_device *bond_dev, struct net_device *slave_dev,
+int bond_sysfs_port_add(struct bond_port *port);
+void bond_sysfs_port_del(struct bond_port *port);
+int bond_connect(struct net_device *bond_dev, struct net_device *port_dev,
 		 struct netlink_ext_ack *extack);
-int bond_release(struct net_device *bond_dev, struct net_device *slave_dev);
+int bond_release(struct net_device *bond_dev, struct net_device *port_dev);
 u32 bond_xmit_hash(struct bonding *bond, struct sk_buff *skb);
 int bond_set_carrier(struct bonding *bond);
-void bond_select_active_slave(struct bonding *bond);
-void bond_change_active_slave(struct bonding *bond, struct slave *new_active);
+void bond_select_active_port(struct bonding *bond);
+void bond_change_active_port(struct bonding *bond, struct bond_port *new_active);
 void bond_create_debugfs(void);
 void bond_destroy_debugfs(void);
 void bond_debug_register(struct bonding *bond);
@@ -643,13 +643,13 @@ void bond_setup(struct net_device *bond_dev);
 unsigned int bond_get_num_tx_queues(void);
 int bond_netlink_init(void);
 void bond_netlink_fini(void);
-struct net_device *bond_option_active_slave_get_rcu(struct bonding *bond);
-const char *bond_slave_link_status(s8 link);
+struct net_device *bond_option_active_port_get_rcu(struct bonding *bond);
+const char *bond_port_link_status(s8 link);
 struct bond_vlan_tag *bond_verify_device_path(struct net_device *start_dev,
 					      struct net_device *end_dev,
 					      int level);
-int bond_update_slave_arr(struct bonding *bond, struct slave *skipslave);
-void bond_slave_arr_work_rearm(struct bonding *bond, unsigned long delay);
+int bond_update_port_arr(struct bonding *bond, struct bond_port *skipport);
+void bond_port_arr_work_rearm(struct bonding *bond, unsigned long delay);
 void bond_work_init_all(struct bonding *bond);
 
 #ifdef CONFIG_PROC_FS
@@ -675,13 +675,13 @@ static inline void bond_destroy_proc_dir(struct bond_net *bn)
 }
 #endif
 
-static inline struct slave *bond_slave_has_mac(struct bonding *bond,
-					       const u8 *mac)
+static inline struct bond_port *bond_port_has_mac(struct bonding *bond,
+						  const u8 *mac)
 {
 	struct list_head *iter;
-	struct slave *tmp;
+	struct bond_port *tmp;
 
-	bond_for_each_slave(bond, tmp, iter)
+	bond_for_each_port(bond, tmp, iter)
 		if (ether_addr_equal_64bits(mac, tmp->dev->dev_addr))
 			return tmp;
 
@@ -689,13 +689,13 @@ static inline struct slave *bond_slave_has_mac(struct bonding *bond,
 }
 
 /* Caller must hold rcu_read_lock() for read */
-static inline struct slave *bond_slave_has_mac_rcu(struct bonding *bond,
-					       const u8 *mac)
+static inline struct bond_port *bond_port_has_mac_rcu(struct bonding *bond,
+						      const u8 *mac)
 {
 	struct list_head *iter;
-	struct slave *tmp;
+	struct bond_port *tmp;
 
-	bond_for_each_slave_rcu(bond, tmp, iter)
+	bond_for_each_port_rcu(bond, tmp, iter)
 		if (ether_addr_equal_64bits(mac, tmp->dev->dev_addr))
 			return tmp;
 
@@ -703,13 +703,13 @@ static inline struct slave *bond_slave_has_mac_rcu(struct bonding *bond,
 }
 
 /* Caller must hold rcu_read_lock() for read */
-static inline bool bond_slave_has_mac_rx(struct bonding *bond, const u8 *mac)
+static inline bool bond_port_has_mac_rx(struct bonding *bond, const u8 *mac)
 {
 	struct list_head *iter;
-	struct slave *tmp;
+	struct bond_port *tmp;
 	struct netdev_hw_addr *ha;
 
-	bond_for_each_slave_rcu(bond, tmp, iter)
+	bond_for_each_port_rcu(bond, tmp, iter)
 		if (ether_addr_equal_64bits(mac, tmp->dev->dev_addr))
 			return true;
 
diff --git a/include/net/lag.h b/include/net/lag.h
index 95b880e6fdde..8a7e7af74e92 100644
--- a/include/net/lag.h
+++ b/include/net/lag.h
@@ -11,7 +11,7 @@ static inline bool net_lag_port_dev_txable(const struct net_device *port_dev)
 	if (netif_is_team_port(port_dev))
 		return team_port_dev_txable(port_dev);
 	else
-		return bond_is_active_slave_dev(port_dev);
+		return bond_is_active_port_dev(port_dev);
 }
 
 #endif /* _LINUX_IF_LAG_H */
-- 
2.27.0

