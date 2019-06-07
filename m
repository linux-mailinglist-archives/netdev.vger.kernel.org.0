Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4BB0738E3B
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 17:00:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729748AbfFGPAq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 11:00:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48404 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729413AbfFGPAP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 7 Jun 2019 11:00:15 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D1B63BB00;
        Fri,  7 Jun 2019 15:00:14 +0000 (UTC)
Received: from hp-dl360pgen8-07.khw2.lab.eng.bos.redhat.com (hp-dl360pgen8-07.khw2.lab.eng.bos.redhat.com [10.16.210.135])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1098882F69;
        Fri,  7 Jun 2019 15:00:12 +0000 (UTC)
From:   Jarod Wilson <jarod@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     Jarod Wilson <jarod@redhat.com>, Joe Perches <joe@perches.com>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>, netdev@vger.kernel.org
Subject: [PATCH net-next 5/7] bonding/802.3ad: convert to using slave printk macros
Date:   Fri,  7 Jun 2019 10:59:30 -0400
Message-Id: <20190607145933.37058-6-jarod@redhat.com>
In-Reply-To: <20190607145933.37058-1-jarod@redhat.com>
References: <20190607145933.37058-1-jarod@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.26]); Fri, 07 Jun 2019 15:00:14 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

All of these printk instances benefit from having both master and slave
device information included, so convert to using a standardized macro
format and remove redundant information.

Suggested-by: Joe Perches <joe@perches.com>
CC: Jay Vosburgh <j.vosburgh@gmail.com>
CC: Veaceslav Falico <vfalico@gmail.com>
CC: Andy Gospodarek <andy@greyhouse.net>
CC: netdev@vger.kernel.org
Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
 drivers/net/bonding/bond_3ad.c | 222 +++++++++++++++++----------------
 1 file changed, 116 insertions(+), 106 deletions(-)

diff --git a/drivers/net/bonding/bond_3ad.c b/drivers/net/bonding/bond_3ad.c
index dfd6f315d2cc..e3b25f310936 100644
--- a/drivers/net/bonding/bond_3ad.c
+++ b/drivers/net/bonding/bond_3ad.c
@@ -325,17 +325,17 @@ static u16 __get_link_speed(struct port *port)
 		default:
 			/* unknown speed value from ethtool. shouldn't happen */
 			if (slave->speed != SPEED_UNKNOWN)
-				pr_warn_once("%s: unknown ethtool speed (%d) for port %d (set it to 0)\n",
+				pr_warn_once("%s: (slave %s): unknown ethtool speed (%d) for port %d (set it to 0)\n",
 					     slave->bond->dev->name,
-					     slave->speed,
+					     slave->dev->name, slave->speed,
 					     port->actor_port_number);
 			speed = 0;
 			break;
 		}
 	}
 
-	netdev_dbg(slave->bond->dev, "Port %d Received link speed %d update from adapter\n",
-		   port->actor_port_number, speed);
+	slave_dbg(slave->bond->dev, slave->dev, "Port %d Received link speed %d update from adapter\n",
+		  port->actor_port_number, speed);
 	return speed;
 }
 
@@ -359,14 +359,14 @@ static u8 __get_duplex(struct port *port)
 		switch (slave->duplex) {
 		case DUPLEX_FULL:
 			retval = 0x1;
-			netdev_dbg(slave->bond->dev, "Port %d Received status full duplex update from adapter\n",
-				   port->actor_port_number);
+			slave_dbg(slave->bond->dev, slave->dev, "Port %d Received status full duplex update from adapter\n",
+				  port->actor_port_number);
 			break;
 		case DUPLEX_HALF:
 		default:
 			retval = 0x0;
-			netdev_dbg(slave->bond->dev, "Port %d Received status NOT full duplex update from adapter\n",
-				   port->actor_port_number);
+			slave_dbg(slave->bond->dev, slave->dev, "Port %d Received status NOT full duplex update from adapter\n",
+				  port->actor_port_number);
 			break;
 		}
 	}
@@ -500,10 +500,12 @@ static void __record_pdu(struct lacpdu *lacpdu, struct port *port)
 		if ((port->sm_vars & AD_PORT_MATCHED) &&
 		    (lacpdu->actor_state & AD_STATE_SYNCHRONIZATION)) {
 			partner->port_state |= AD_STATE_SYNCHRONIZATION;
-			pr_debug("%s partner sync=1\n", port->slave->dev->name);
+			slave_dbg(port->slave->bond->dev, port->slave->dev,
+				  "partner sync=1\n");
 		} else {
 			partner->port_state &= ~AD_STATE_SYNCHRONIZATION;
-			pr_debug("%s partner sync=0\n", port->slave->dev->name);
+			slave_dbg(port->slave->bond->dev, port->slave->dev,
+				  "partner sync=0\n");
 		}
 	}
 }
@@ -789,8 +791,9 @@ static inline void __update_lacpdu_from_port(struct port *port)
 	lacpdu->actor_port_priority = htons(port->actor_port_priority);
 	lacpdu->actor_port = htons(port->actor_port_number);
 	lacpdu->actor_state = port->actor_oper_port_state;
-	pr_debug("update lacpdu: %s, actor port state %x\n",
-		 port->slave->dev->name, port->actor_oper_port_state);
+	slave_dbg(port->slave->bond->dev, port->slave->dev,
+		  "update lacpdu: actor port state %x\n",
+		  port->actor_oper_port_state);
 
 	/* lacpdu->reserved_3_1              initialized
 	 * lacpdu->tlv_type_partner_info     initialized
@@ -1022,11 +1025,11 @@ static void ad_mux_machine(struct port *port, bool *update_slave_arr)
 
 	/* check if the state machine was changed */
 	if (port->sm_mux_state != last_state) {
-		pr_debug("Mux Machine: Port=%d (%s), Last State=%d, Curr State=%d\n",
-			 port->actor_port_number,
-			 port->slave->dev->name,
-			 last_state,
-			 port->sm_mux_state);
+		slave_dbg(port->slave->bond->dev, port->slave->dev,
+			  "Mux Machine: Port=%d, Last State=%d, Curr State=%d\n",
+			  port->actor_port_number,
+			  last_state,
+			  port->sm_mux_state);
 		switch (port->sm_mux_state) {
 		case AD_MUX_DETACHED:
 			port->actor_oper_port_state &= ~AD_STATE_SYNCHRONIZATION;
@@ -1140,11 +1143,11 @@ static void ad_rx_machine(struct lacpdu *lacpdu, struct port *port)
 
 	/* check if the State machine was changed or new lacpdu arrived */
 	if ((port->sm_rx_state != last_state) || (lacpdu)) {
-		pr_debug("Rx Machine: Port=%d (%s), Last State=%d, Curr State=%d\n",
-			 port->actor_port_number,
-			 port->slave->dev->name,
-			 last_state,
-			 port->sm_rx_state);
+		slave_dbg(port->slave->bond->dev, port->slave->dev,
+			  "Rx Machine: Port=%d, Last State=%d, Curr State=%d\n",
+			  port->actor_port_number,
+			  last_state,
+			  port->sm_rx_state);
 		switch (port->sm_rx_state) {
 		case AD_RX_INITIALIZE:
 			if (!(port->actor_oper_port_key & AD_DUPLEX_KEY_MASKS))
@@ -1192,9 +1195,8 @@ static void ad_rx_machine(struct lacpdu *lacpdu, struct port *port)
 			/* detect loopback situation */
 			if (MAC_ADDRESS_EQUAL(&(lacpdu->actor_system),
 					      &(port->actor_system))) {
-				netdev_err(port->slave->bond->dev, "An illegal loopback occurred on adapter (%s)\n"
-				       "Check the configuration to verify that all adapters are connected to 802.3ad compliant switch ports\n",
-				       port->slave->dev->name);
+				slave_err(port->slave->bond->dev, port->slave->dev, "An illegal loopback occurred on slave\n"
+					  "Check the configuration to verify that all adapters are connected to 802.3ad compliant switch ports\n");
 				return;
 			}
 			__update_selected(lacpdu, port);
@@ -1263,8 +1265,10 @@ static void ad_tx_machine(struct port *port)
 			__update_lacpdu_from_port(port);
 
 			if (ad_lacpdu_send(port) >= 0) {
-				pr_debug("Sent LACPDU on port %d\n",
-					 port->actor_port_number);
+				slave_dbg(port->slave->bond->dev,
+					  port->slave->dev,
+					  "Sent LACPDU on port %d\n",
+					  port->actor_port_number);
 
 				/* mark ntt as false, so it will not be sent
 				 * again until demanded
@@ -1343,9 +1347,10 @@ static void ad_periodic_machine(struct port *port)
 
 	/* check if the state machine was changed */
 	if (port->sm_periodic_state != last_state) {
-		pr_debug("Periodic Machine: Port=%d, Last State=%d, Curr State=%d\n",
-			 port->actor_port_number, last_state,
-			 port->sm_periodic_state);
+		slave_dbg(port->slave->bond->dev, port->slave->dev,
+			  "Periodic Machine: Port=%d, Last State=%d, Curr State=%d\n",
+			  port->actor_port_number, last_state,
+			  port->sm_periodic_state);
 		switch (port->sm_periodic_state) {
 		case AD_NO_PERIODIC:
 			port->sm_periodic_timer_counter = 0;
@@ -1421,9 +1426,9 @@ static void ad_port_selection_logic(struct port *port, bool *update_slave_arr)
 				port->next_port_in_aggregator = NULL;
 				port->actor_port_aggregator_identifier = 0;
 
-				netdev_dbg(bond->dev, "Port %d left LAG %d\n",
-					   port->actor_port_number,
-					   temp_aggregator->aggregator_identifier);
+				slave_dbg(bond->dev, port->slave->dev, "Port %d left LAG %d\n",
+					  port->actor_port_number,
+					  temp_aggregator->aggregator_identifier);
 				/* if the aggregator is empty, clear its
 				 * parameters, and set it ready to be attached
 				 */
@@ -1436,10 +1441,10 @@ static void ad_port_selection_logic(struct port *port, bool *update_slave_arr)
 			/* meaning: the port was related to an aggregator
 			 * but was not on the aggregator port list
 			 */
-			net_warn_ratelimited("%s: Warning: Port %d (on %s) was related to aggregator %d but was not on its port list\n",
+			net_warn_ratelimited("%s: (slave %s): Warning: Port %d was related to aggregator %d but was not on its port list\n",
 					     port->slave->bond->dev->name,
-					     port->actor_port_number,
 					     port->slave->dev->name,
+					     port->actor_port_number,
 					     port->aggregator->aggregator_identifier);
 		}
 	}
@@ -1470,9 +1475,9 @@ static void ad_port_selection_logic(struct port *port, bool *update_slave_arr)
 			port->next_port_in_aggregator = aggregator->lag_ports;
 			port->aggregator->num_of_ports++;
 			aggregator->lag_ports = port;
-			netdev_dbg(bond->dev, "Port %d joined LAG %d(existing LAG)\n",
-				   port->actor_port_number,
-				   port->aggregator->aggregator_identifier);
+			slave_dbg(bond->dev, slave->dev, "Port %d joined LAG %d (existing LAG)\n",
+				  port->actor_port_number,
+				  port->aggregator->aggregator_identifier);
 
 			/* mark this port as selected */
 			port->sm_vars |= AD_PORT_SELECTED;
@@ -1517,12 +1522,13 @@ static void ad_port_selection_logic(struct port *port, bool *update_slave_arr)
 			/* mark this port as selected */
 			port->sm_vars |= AD_PORT_SELECTED;
 
-			netdev_dbg(bond->dev, "Port %d joined LAG %d(new LAG)\n",
-				   port->actor_port_number,
-				   port->aggregator->aggregator_identifier);
+			slave_dbg(bond->dev, port->slave->dev, "Port %d joined LAG %d (new LAG)\n",
+				  port->actor_port_number,
+				  port->aggregator->aggregator_identifier);
 		} else {
-			netdev_err(bond->dev, "Port %d (on %s) did not find a suitable aggregator\n",
-			       port->actor_port_number, port->slave->dev->name);
+			slave_err(bond->dev, port->slave->dev,
+				  "Port %d did not find a suitable aggregator\n",
+				  port->actor_port_number);
 		}
 	}
 	/* if all aggregator's ports are READY_N == TRUE, set ready=TRUE
@@ -1601,8 +1607,9 @@ static struct aggregator *ad_agg_selection_test(struct aggregator *best,
 		break;
 
 	default:
-		net_warn_ratelimited("%s: Impossible agg select mode %d\n",
+		net_warn_ratelimited("%s: (slave %s): Impossible agg select mode %d\n",
 				     curr->slave->bond->dev->name,
+				     curr->slave->dev->name,
 				     __get_agg_selection_mode(curr->lag_ports));
 		break;
 	}
@@ -1703,36 +1710,37 @@ static void ad_agg_selection_logic(struct aggregator *agg,
 
 	/* if there is new best aggregator, activate it */
 	if (best) {
-		netdev_dbg(bond->dev, "best Agg=%d; P=%d; a k=%d; p k=%d; Ind=%d; Act=%d\n",
+		netdev_dbg(bond->dev, "(slave %s): best Agg=%d; P=%d; a k=%d; p k=%d; Ind=%d; Act=%d\n",
+			   best->slave ? best->slave->dev->name : "NULL",
 			   best->aggregator_identifier, best->num_of_ports,
 			   best->actor_oper_aggregator_key,
 			   best->partner_oper_aggregator_key,
 			   best->is_individual, best->is_active);
-		netdev_dbg(bond->dev, "best ports %p slave %p %s\n",
-			   best->lag_ports, best->slave,
-			   best->slave ? best->slave->dev->name : "NULL");
+		netdev_dbg(bond->dev, "(slave %s): best ports %p slave %p\n",
+			   best->slave ? best->slave->dev->name : "NULL",
+			   best->lag_ports, best->slave);
 
 		bond_for_each_slave_rcu(bond, slave, iter) {
 			agg = &(SLAVE_AD_INFO(slave)->aggregator);
 
-			netdev_dbg(bond->dev, "Agg=%d; P=%d; a k=%d; p k=%d; Ind=%d; Act=%d\n",
-				   agg->aggregator_identifier, agg->num_of_ports,
-				   agg->actor_oper_aggregator_key,
-				   agg->partner_oper_aggregator_key,
-				   agg->is_individual, agg->is_active);
+			slave_dbg(bond->dev, slave->dev, "Agg=%d; P=%d; a k=%d; p k=%d; Ind=%d; Act=%d\n",
+				  agg->aggregator_identifier, agg->num_of_ports,
+				  agg->actor_oper_aggregator_key,
+				  agg->partner_oper_aggregator_key,
+				  agg->is_individual, agg->is_active);
 		}
 
-		/* check if any partner replys */
-		if (best->is_individual) {
+		/* check if any partner replies */
+		if (best->is_individual)
 			net_warn_ratelimited("%s: Warning: No 802.3ad response from the link partner for any adapters in the bond\n",
-					     best->slave ?
-					     best->slave->bond->dev->name : "NULL");
-		}
+					     bond->dev->name);
 
 		best->is_active = 1;
-		netdev_dbg(bond->dev, "LAG %d chosen as the active LAG\n",
+		netdev_dbg(bond->dev, "(slave %s): LAG %d chosen as the active LAG\n",
+			   best->slave ? best->slave->dev->name : "NULL",
 			   best->aggregator_identifier);
-		netdev_dbg(bond->dev, "Agg=%d; P=%d; a k=%d; p k=%d; Ind=%d; Act=%d\n",
+		netdev_dbg(bond->dev, "(slave %s): Agg=%d; P=%d; a k=%d; p k=%d; Ind=%d; Act=%d\n",
+			   best->slave ? best->slave->dev->name : "NULL",
 			   best->aggregator_identifier, best->num_of_ports,
 			   best->actor_oper_aggregator_key,
 			   best->partner_oper_aggregator_key,
@@ -1788,7 +1796,9 @@ static void ad_clear_agg(struct aggregator *aggregator)
 		aggregator->lag_ports = NULL;
 		aggregator->is_active = 0;
 		aggregator->num_of_ports = 0;
-		pr_debug("LAG %d was cleared\n",
+		pr_debug("%s: LAG %d was cleared\n",
+			 aggregator->slave ?
+			 aggregator->slave->dev->name : "NULL",
 			 aggregator->aggregator_identifier);
 	}
 }
@@ -1885,9 +1895,10 @@ static void ad_enable_collecting_distributing(struct port *port,
 					      bool *update_slave_arr)
 {
 	if (port->aggregator->is_active) {
-		pr_debug("Enabling port %d(LAG %d)\n",
-			 port->actor_port_number,
-			 port->aggregator->aggregator_identifier);
+		slave_dbg(port->slave->bond->dev, port->slave->dev,
+			  "Enabling port %d (LAG %d)\n",
+			  port->actor_port_number,
+			  port->aggregator->aggregator_identifier);
 		__enable_port(port);
 		/* Slave array needs update */
 		*update_slave_arr = true;
@@ -1905,9 +1916,10 @@ static void ad_disable_collecting_distributing(struct port *port,
 	if (port->aggregator &&
 	    !MAC_ADDRESS_EQUAL(&(port->aggregator->partner_system),
 			       &(null_mac_addr))) {
-		pr_debug("Disabling port %d(LAG %d)\n",
-			 port->actor_port_number,
-			 port->aggregator->aggregator_identifier);
+		slave_dbg(port->slave->bond->dev, port->slave->dev,
+			  "Disabling port %d (LAG %d)\n",
+			  port->actor_port_number,
+			  port->aggregator->aggregator_identifier);
 		__disable_port(port);
 		/* Slave array needs an update */
 		*update_slave_arr = true;
@@ -1920,7 +1932,7 @@ static void ad_disable_collecting_distributing(struct port *port,
  * @port: the port we're looking at
  */
 static void ad_marker_info_received(struct bond_marker *marker_info,
-	struct port *port)
+				    struct port *port)
 {
 	struct bond_marker marker;
 
@@ -1933,10 +1945,10 @@ static void ad_marker_info_received(struct bond_marker *marker_info,
 	marker.tlv_type = AD_MARKER_RESPONSE_SUBTYPE;
 
 	/* send the marker response */
-	if (ad_marker_send(port, &marker) >= 0) {
-		pr_debug("Sent Marker Response on port %d\n",
-			 port->actor_port_number);
-	}
+	if (ad_marker_send(port, &marker) >= 0)
+		slave_dbg(port->slave->bond->dev, port->slave->dev,
+			  "Sent Marker Response on port %d\n",
+			  port->actor_port_number);
 }
 
 /**
@@ -2085,13 +2097,12 @@ void bond_3ad_unbind_slave(struct slave *slave)
 
 	/* if slave is null, the whole port is not initialized */
 	if (!port->slave) {
-		netdev_warn(bond->dev, "Trying to unbind an uninitialized port on %s\n",
-			    slave->dev->name);
+		slave_warn(bond->dev, slave->dev, "Trying to unbind an uninitialized port\n");
 		goto out;
 	}
 
-	netdev_dbg(bond->dev, "Unbinding Link Aggregation Group %d\n",
-		   aggregator->aggregator_identifier);
+	slave_dbg(bond->dev, slave->dev, "Unbinding Link Aggregation Group %d\n",
+		  aggregator->aggregator_identifier);
 
 	/* Tell the partner that this port is not suitable for aggregation */
 	port->actor_oper_port_state &= ~AD_STATE_SYNCHRONIZATION;
@@ -2129,13 +2140,13 @@ void bond_3ad_unbind_slave(struct slave *slave)
 			 * new aggregator
 			 */
 			if ((new_aggregator) && ((!new_aggregator->lag_ports) || ((new_aggregator->lag_ports == port) && !new_aggregator->lag_ports->next_port_in_aggregator))) {
-				netdev_dbg(bond->dev, "Some port(s) related to LAG %d - replacing with LAG %d\n",
-					   aggregator->aggregator_identifier,
-					   new_aggregator->aggregator_identifier);
+				slave_dbg(bond->dev, slave->dev, "Some port(s) related to LAG %d - replacing with LAG %d\n",
+					  aggregator->aggregator_identifier,
+					  new_aggregator->aggregator_identifier);
 
 				if ((new_aggregator->lag_ports == port) &&
 				    new_aggregator->is_active) {
-					netdev_info(bond->dev, "Removing an active aggregator\n");
+					slave_info(bond->dev, slave->dev, "Removing an active aggregator\n");
 					select_new_active_agg = 1;
 				}
 
@@ -2166,7 +2177,7 @@ void bond_3ad_unbind_slave(struct slave *slave)
 					ad_agg_selection_logic(__get_first_agg(port),
 							       &dummy_slave_update);
 			} else {
-				netdev_warn(bond->dev, "unbinding aggregator, and could not find a new aggregator for its ports\n");
+				slave_warn(bond->dev, slave->dev, "unbinding aggregator, and could not find a new aggregator for its ports\n");
 			}
 		} else {
 			/* in case that the only port related to this
@@ -2175,7 +2186,7 @@ void bond_3ad_unbind_slave(struct slave *slave)
 			select_new_active_agg = aggregator->is_active;
 			ad_clear_agg(aggregator);
 			if (select_new_active_agg) {
-				netdev_info(bond->dev, "Removing an active aggregator\n");
+				slave_info(bond->dev, slave->dev, "Removing an active aggregator\n");
 				/* select new active aggregator */
 				temp_aggregator = __get_first_agg(port);
 				if (temp_aggregator)
@@ -2185,7 +2196,7 @@ void bond_3ad_unbind_slave(struct slave *slave)
 		}
 	}
 
-	netdev_dbg(bond->dev, "Unbinding port %d\n", port->actor_port_number);
+	slave_dbg(bond->dev, slave->dev, "Unbinding port %d\n", port->actor_port_number);
 
 	/* find the aggregator that this port is connected to */
 	bond_for_each_slave(bond, slave_iter, iter) {
@@ -2208,7 +2219,7 @@ void bond_3ad_unbind_slave(struct slave *slave)
 					select_new_active_agg = temp_aggregator->is_active;
 					ad_clear_agg(temp_aggregator);
 					if (select_new_active_agg) {
-						netdev_info(bond->dev, "Removing an active aggregator\n");
+						slave_info(bond->dev, slave->dev, "Removing an active aggregator\n");
 						/* select new active aggregator */
 						ad_agg_selection_logic(__get_first_agg(port),
 							               &dummy_slave_update);
@@ -2379,9 +2390,9 @@ static int bond_3ad_rx_indication(struct lacpdu *lacpdu, struct slave *slave)
 	switch (lacpdu->subtype) {
 	case AD_TYPE_LACPDU:
 		ret = RX_HANDLER_CONSUMED;
-		netdev_dbg(slave->bond->dev,
-			   "Received LACPDU on port %d slave %s\n",
-			   port->actor_port_number, slave->dev->name);
+		slave_dbg(slave->bond->dev, slave->dev,
+			  "Received LACPDU on port %d\n",
+			  port->actor_port_number);
 		/* Protect against concurrent state machines */
 		spin_lock(&slave->bond->mode_lock);
 		ad_rx_machine(lacpdu, port);
@@ -2395,18 +2406,18 @@ static int bond_3ad_rx_indication(struct lacpdu *lacpdu, struct slave *slave)
 		marker = (struct bond_marker *)lacpdu;
 		switch (marker->tlv_type) {
 		case AD_MARKER_INFORMATION_SUBTYPE:
-			netdev_dbg(slave->bond->dev, "Received Marker Information on port %d\n",
-				   port->actor_port_number);
+			slave_dbg(slave->bond->dev, slave->dev, "Received Marker Information on port %d\n",
+				  port->actor_port_number);
 			ad_marker_info_received(marker, port);
 			break;
 		case AD_MARKER_RESPONSE_SUBTYPE:
-			netdev_dbg(slave->bond->dev, "Received Marker Response on port %d\n",
-				   port->actor_port_number);
+			slave_dbg(slave->bond->dev, slave->dev, "Received Marker Response on port %d\n",
+				  port->actor_port_number);
 			ad_marker_response_received(marker, port);
 			break;
 		default:
-			netdev_dbg(slave->bond->dev, "Received an unknown Marker subtype on slot %d\n",
-				   port->actor_port_number);
+			slave_dbg(slave->bond->dev, slave->dev, "Received an unknown Marker subtype on port %d\n",
+				  port->actor_port_number);
 			stat = &SLAVE_AD_INFO(slave)->stats.marker_unknown_rx;
 			atomic64_inc(stat);
 			stat = &BOND_AD_INFO(bond).stats.marker_unknown_rx;
@@ -2456,9 +2467,10 @@ static void ad_update_actor_keys(struct port *port, bool reset)
 
 		if (!reset) {
 			if (!speed) {
-				netdev_err(port->slave->dev,
-					   "speed changed to 0 for port %s",
-					   port->slave->dev->name);
+				slave_err(port->slave->bond->dev,
+					  port->slave->dev,
+					  "speed changed to 0 on port %d\n",
+					  port->actor_port_number);
 			} else if (duplex && ospeed != speed) {
 				/* Speed change restarts LACP state-machine */
 				port->sm_vars |= AD_PORT_BEGIN;
@@ -2483,17 +2495,16 @@ void bond_3ad_adapter_speed_duplex_changed(struct slave *slave)
 
 	/* if slave is null, the whole port is not initialized */
 	if (!port->slave) {
-		netdev_warn(slave->bond->dev,
-			    "speed/duplex changed for uninitialized port %s\n",
-			    slave->dev->name);
+		slave_warn(slave->bond->dev, slave->dev,
+			   "speed/duplex changed for uninitialized port\n");
 		return;
 	}
 
 	spin_lock_bh(&slave->bond->mode_lock);
 	ad_update_actor_keys(port, false);
 	spin_unlock_bh(&slave->bond->mode_lock);
-	netdev_dbg(slave->bond->dev, "Port %d slave %s changed speed/duplex\n",
-		   port->actor_port_number, slave->dev->name);
+	slave_dbg(slave->bond->dev, slave->dev, "Port %d changed speed/duplex\n",
+		  port->actor_port_number);
 }
 
 /**
@@ -2513,8 +2524,7 @@ void bond_3ad_handle_link_change(struct slave *slave, char link)
 
 	/* if slave is null, the whole port is not initialized */
 	if (!port->slave) {
-		netdev_warn(slave->bond->dev, "link status changed for uninitialized port on %s\n",
-			    slave->dev->name);
+		slave_warn(slave->bond->dev, slave->dev, "link status changed for uninitialized port\n");
 		return;
 	}
 
@@ -2539,9 +2549,9 @@ void bond_3ad_handle_link_change(struct slave *slave, char link)
 
 	spin_unlock_bh(&slave->bond->mode_lock);
 
-	netdev_dbg(slave->bond->dev, "Port %d changed link status to %s\n",
-		   port->actor_port_number,
-		   link == BOND_LINK_UP ? "UP" : "DOWN");
+	slave_dbg(slave->bond->dev, slave->dev, "Port %d changed link status to %s\n",
+		  port->actor_port_number,
+		  link == BOND_LINK_UP ? "UP" : "DOWN");
 
 	/* RTNL is held and mode_lock is released so it's safe
 	 * to update slave_array here.
-- 
2.20.1

