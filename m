Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C73E2819E7
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 19:42:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388582AbgJBRkz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 13:40:55 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:43597 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388206AbgJBRko (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Oct 2020 13:40:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601660433;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OtJXmelxTJX+ripZaBOlBEpGWyf9/LMCpQCsCLoBh9Y=;
        b=e08OPrTFBsgL3xia7mnyLaTWTgDbOOfm2q08mU0t/M7pafuQkgAB+7GkCAQiRdJ5Jd42om
        Pj1xx+yJ8xmRHJMUf/69NB2/Uy2lXIv0BdWbjvHe98hW/tQJIaa3nf3etiIoxGtPxg6Ey0
        t4ZW/OUMVXxzFFN9AKxDuYfq/qjodEM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-273-etQsYLcKN6iv0G2NY70upw-1; Fri, 02 Oct 2020 13:40:31 -0400
X-MC-Unique: etQsYLcKN6iv0G2NY70upw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 95A05801AF2;
        Fri,  2 Oct 2020 17:40:29 +0000 (UTC)
Received: from hpe-dl360pgen9-01.klab.eng.bos.redhat.com (hpe-dl360pgen9-01.klab.eng.bos.redhat.com [10.16.160.31])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1EE6D1002C14;
        Fri,  2 Oct 2020 17:40:18 +0000 (UTC)
From:   Jarod Wilson <jarod@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     Jarod Wilson <jarod@redhat.com>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Davis <tadavis@lbl.gov>, netdev@vger.kernel.org
Subject: [PATCH net-next v2 1/6] bonding: rename 802.3ad's struct port to ad_port
Date:   Fri,  2 Oct 2020 13:39:56 -0400
Message-Id: <20201002174001.3012643-2-jarod@redhat.com>
In-Reply-To: <20201002174001.3012643-1-jarod@redhat.com>
References: <20201002174001.3012643-1-jarod@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The intention is to reuse "port" in place of "slave" in the bonding driver
after making this change, as port is consistent with the bridge and team
drivers, and allows us to remove socially problematic language from the
bonding driver.

Cc: Jay Vosburgh <j.vosburgh@gmail.com>
Cc: Veaceslav Falico <vfalico@gmail.com>
Cc: Andy Gospodarek <andy@greyhouse.net>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Thomas Davis <tadavis@lbl.gov>
Cc: netdev@vger.kernel.org
Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
 drivers/net/bonding/bond_3ad.c         | 1307 ++++++++++++------------
 drivers/net/bonding/bond_main.c        |    4 +-
 drivers/net/bonding/bond_netlink.c     |    6 +-
 drivers/net/bonding/bond_procfs.c      |   36 +-
 drivers/net/bonding/bond_sysfs_slave.c |   10 +-
 include/net/bond_3ad.h                 |   14 +-
 6 files changed, 688 insertions(+), 689 deletions(-)

diff --git a/drivers/net/bonding/bond_3ad.c b/drivers/net/bonding/bond_3ad.c
index aa001b16765a..0eb717b0bfc6 100644
--- a/drivers/net/bonding/bond_3ad.c
+++ b/drivers/net/bonding/bond_3ad.c
@@ -89,60 +89,60 @@ static const u8 lacpdu_mcast_addr[ETH_ALEN + 2] __long_aligned =
 	MULTICAST_LACPDU_ADDR;
 
 /* ================= main 802.3ad protocol functions ================== */
-static int ad_lacpdu_send(struct port *port);
-static int ad_marker_send(struct port *port, struct bond_marker *marker);
-static void ad_mux_machine(struct port *port, bool *update_slave_arr);
-static void ad_rx_machine(struct lacpdu *lacpdu, struct port *port);
-static void ad_tx_machine(struct port *port);
-static void ad_periodic_machine(struct port *port);
-static void ad_port_selection_logic(struct port *port, bool *update_slave_arr);
+static int ad_lacpdu_send(struct ad_port *ad_port);
+static int ad_marker_send(struct ad_port *ad_port, struct bond_marker *marker);
+static void ad_mux_machine(struct ad_port *ad_port, bool *update_slave_arr);
+static void ad_rx_machine(struct lacpdu *lacpdu, struct ad_port *ad_port);
+static void ad_tx_machine(struct ad_port *ad_port);
+static void ad_periodic_machine(struct ad_port *ad_port);
+static void ad_port_selection_logic(struct ad_port *ad_port, bool *update_slave_arr);
 static void ad_agg_selection_logic(struct aggregator *aggregator,
 				   bool *update_slave_arr);
 static void ad_clear_agg(struct aggregator *aggregator);
 static void ad_initialize_agg(struct aggregator *aggregator);
-static void ad_initialize_port(struct port *port, int lacp_fast);
-static void ad_enable_collecting_distributing(struct port *port,
+static void ad_initialize_port(struct ad_port *ad_port, int lacp_fast);
+static void ad_enable_collecting_distributing(struct ad_port *ad_port,
 					      bool *update_slave_arr);
-static void ad_disable_collecting_distributing(struct port *port,
+static void ad_disable_collecting_distributing(struct ad_port *ad_port,
 					       bool *update_slave_arr);
 static void ad_marker_info_received(struct bond_marker *marker_info,
-				    struct port *port);
+				    struct ad_port *ad_port);
 static void ad_marker_response_received(struct bond_marker *marker,
-					struct port *port);
-static void ad_update_actor_keys(struct port *port, bool reset);
+					struct ad_port *ad_port);
+static void ad_update_actor_keys(struct ad_port *ad_port, bool reset);
 
 
 /* ================= api to bonding and kernel code ================== */
 
 /**
- * __get_bond_by_port - get the port's bonding struct
- * @port: the port we're looking at
+ * __get_bond_by_ad_port - get the ad_port's bonding struct
+ * @ad_port: the ad_port we're looking at
  *
- * Return @port's bonding struct, or %NULL if it can't be found.
+ * Return @ad_port's bonding struct, or %NULL if it can't be found.
  */
-static inline struct bonding *__get_bond_by_port(struct port *port)
+static inline struct bonding *__get_bond_by_ad_port(struct ad_port *ad_port)
 {
-	if (port->slave == NULL)
+	if (ad_port->slave == NULL)
 		return NULL;
 
-	return bond_get_bond_by_slave(port->slave);
+	return bond_get_bond_by_slave(ad_port->slave);
 }
 
 /**
  * __get_first_agg - get the first aggregator in the bond
- * @port: the port we're looking at
+ * @ad_port: the ad_port we're looking at
  *
  * Return the aggregator of the first slave in @bond, or %NULL if it can't be
  * found.
  * The caller must hold RCU or RTNL lock.
  */
-static inline struct aggregator *__get_first_agg(struct port *port)
+static inline struct aggregator *__get_first_agg(struct ad_port *ad_port)
 {
-	struct bonding *bond = __get_bond_by_port(port);
+	struct bonding *bond = __get_bond_by_ad_port(ad_port);
 	struct slave *first_slave;
 	struct aggregator *agg;
 
-	/* If there's no bond for this port, or bond has no slaves */
+	/* If there's no bond for this ad_port, or bond has no slaves */
 	if (bond == NULL)
 		return NULL;
 
@@ -167,44 +167,44 @@ static inline int __agg_has_partner(struct aggregator *agg)
 }
 
 /**
- * __disable_port - disable the port's slave
- * @port: the port we're looking at
+ * __disable_ad_port - disable the ad_port's slave
+ * @ad_port: the ad_port we're looking at
  */
-static inline void __disable_port(struct port *port)
+static inline void __disable_ad_port(struct ad_port *ad_port)
 {
-	bond_set_slave_inactive_flags(port->slave, BOND_SLAVE_NOTIFY_LATER);
+	bond_set_slave_inactive_flags(ad_port->slave, BOND_SLAVE_NOTIFY_LATER);
 }
 
 /**
- * __enable_port - enable the port's slave, if it's up
- * @port: the port we're looking at
+ * __enable_ad_port - enable the ad_port's slave, if it's up
+ * @ad_port: the ad_port we're looking at
  */
-static inline void __enable_port(struct port *port)
+static inline void __enable_ad_port(struct ad_port *ad_port)
 {
-	struct slave *slave = port->slave;
+	struct slave *slave = ad_port->slave;
 
 	if ((slave->link == BOND_LINK_UP) && bond_slave_is_up(slave))
 		bond_set_slave_active_flags(slave, BOND_SLAVE_NOTIFY_LATER);
 }
 
 /**
- * __port_is_enabled - check if the port's slave is in active state
- * @port: the port we're looking at
+ * __ad_port_is_enabled - check if the ad_port's slave is in active state
+ * @ad_port: the ad_port we're looking at
  */
-static inline int __port_is_enabled(struct port *port)
+static inline int __ad_port_is_enabled(struct ad_port *ad_port)
 {
-	return bond_is_active_slave(port->slave);
+	return bond_is_active_slave(ad_port->slave);
 }
 
 /**
  * __get_agg_selection_mode - get the aggregator selection mode
- * @port: the port we're looking at
+ * @ad_port: the ad_port we're looking at
  *
  * Get the aggregator selection mode. Can be %STABLE, %BANDWIDTH or %COUNT.
  */
-static inline u32 __get_agg_selection_mode(struct port *port)
+static inline u32 __get_agg_selection_mode(struct ad_port *ad_port)
 {
-	struct bonding *bond = __get_bond_by_port(port);
+	struct bonding *bond = __get_bond_by_ad_port(ad_port);
 
 	if (bond == NULL)
 		return BOND_AD_STABLE;
@@ -214,11 +214,11 @@ static inline u32 __get_agg_selection_mode(struct port *port)
 
 /**
  * __check_agg_selection_timer - check if the selection timer has expired
- * @port: the port we're looking at
+ * @ad_port: the ad_port we're looking at
  */
-static inline int __check_agg_selection_timer(struct port *port)
+static inline int __check_agg_selection_timer(struct ad_port *ad_port)
 {
-	struct bonding *bond = __get_bond_by_port(port);
+	struct bonding *bond = __get_bond_by_ad_port(ad_port);
 
 	if (bond == NULL)
 		return 0;
@@ -227,10 +227,10 @@ static inline int __check_agg_selection_timer(struct port *port)
 }
 
 /**
- * __get_link_speed - get a port's speed
- * @port: the port we're looking at
+ * __get_link_speed - get an ad_port's speed
+ * @ad_port: the ad_port we're looking at
  *
- * Return @port's speed in 802.3ad enum format. i.e. one of:
+ * Return @ad_port's speed in 802.3ad enum format. i.e. one of:
  *     0,
  *     %AD_LINK_SPEED_10MBPS,
  *     %AD_LINK_SPEED_100MBPS,
@@ -246,9 +246,9 @@ static inline int __check_agg_selection_timer(struct port *port)
  *     %AD_LINK_SPEED_56000MBPS
  *     %AD_LINK_SPEED_100000MBPS
  */
-static u16 __get_link_speed(struct port *port)
+static u16 __get_link_speed(struct ad_port *ad_port)
 {
-	struct slave *slave = port->slave;
+	struct slave *slave = ad_port->slave;
 	u16 speed;
 
 	/* this if covers only a special case: when the configuration starts
@@ -318,28 +318,28 @@ static u16 __get_link_speed(struct port *port)
 				pr_warn_once("%s: (slave %s): unknown ethtool speed (%d) for port %d (set it to 0)\n",
 					     slave->bond->dev->name,
 					     slave->dev->name, slave->speed,
-					     port->actor_port_number);
+					     ad_port->actor_port_number);
 			speed = 0;
 			break;
 		}
 	}
 
 	slave_dbg(slave->bond->dev, slave->dev, "Port %d Received link speed %d update from adapter\n",
-		  port->actor_port_number, speed);
+		  ad_port->actor_port_number, speed);
 	return speed;
 }
 
 /**
- * __get_duplex - get a port's duplex
- * @port: the port we're looking at
+ * __get_duplex - get an ad_port's duplex
+ * @ad_port: the ad_port we're looking at
  *
- * Return @port's duplex in 802.3ad bitmask format. i.e.:
+ * Return @ad_port's duplex in 802.3ad bitmask format. i.e.:
  *     0x01 if in full duplex
  *     0x00 otherwise
  */
-static u8 __get_duplex(struct port *port)
+static u8 __get_duplex(struct ad_port *ad_port)
 {
-	struct slave *slave = port->slave;
+	struct slave *slave = ad_port->slave;
 	u8 retval = 0x0;
 
 	/* handling a special case: when the configuration starts with
@@ -350,25 +350,25 @@ static u8 __get_duplex(struct port *port)
 		case DUPLEX_FULL:
 			retval = 0x1;
 			slave_dbg(slave->bond->dev, slave->dev, "Port %d Received status full duplex update from adapter\n",
-				  port->actor_port_number);
+				  ad_port->actor_port_number);
 			break;
 		case DUPLEX_HALF:
 		default:
 			retval = 0x0;
 			slave_dbg(slave->bond->dev, slave->dev, "Port %d Received status NOT full duplex update from adapter\n",
-				  port->actor_port_number);
+				  ad_port->actor_port_number);
 			break;
 		}
 	}
 	return retval;
 }
 
-static void __ad_actor_update_port(struct port *port)
+static void __ad_actor_update_port(struct ad_port *ad_port)
 {
-	const struct bonding *bond = bond_get_bond_by_slave(port->slave);
+	const struct bonding *bond = bond_get_bond_by_slave(ad_port->slave);
 
-	port->actor_system = BOND_AD_INFO(bond).system.sys_mac_addr;
-	port->actor_system_priority = BOND_AD_INFO(bond).system.sys_priority;
+	ad_port->actor_system = BOND_AD_INFO(bond).system.sys_mac_addr;
+	ad_port->actor_system_priority = BOND_AD_INFO(bond).system.sys_priority;
 }
 
 /* Conversions */
@@ -414,9 +414,9 @@ static u16 __ad_timer_to_ticks(u16 timer_type, u16 par)
 /* ================= ad_rx_machine helper functions ================== */
 
 /**
- * __choose_matched - update a port's matched variable from a received lacpdu
+ * __choose_matched - update an ad_port's matched variable from a received lacpdu
  * @lacpdu: the lacpdu we've received
- * @port: the port we're looking at
+ * @ad_port: the ad_port we're looking at
  *
  * Update the value of the matched variable, using parameter values from a
  * newly received lacpdu. Parameter values for the partner carried in the
@@ -436,41 +436,41 @@ static u16 __ad_timer_to_ticks(u16 timer_type, u16 par)
  * used here to implement the language from 802.3ad 43.4.9 that requires
  * recordPDU to "match" the LACPDU parameters to the stored values.
  */
-static void __choose_matched(struct lacpdu *lacpdu, struct port *port)
+static void __choose_matched(struct lacpdu *lacpdu, struct ad_port *ad_port)
 {
 	/* check if all parameters are alike
 	 * or this is individual link(aggregation == FALSE)
 	 * then update the state machine Matched variable.
 	 */
-	if (((ntohs(lacpdu->partner_port) == port->actor_port_number) &&
-	     (ntohs(lacpdu->partner_port_priority) == port->actor_port_priority) &&
-	     MAC_ADDRESS_EQUAL(&(lacpdu->partner_system), &(port->actor_system)) &&
-	     (ntohs(lacpdu->partner_system_priority) == port->actor_system_priority) &&
-	     (ntohs(lacpdu->partner_key) == port->actor_oper_port_key) &&
-	     ((lacpdu->partner_state & LACP_STATE_AGGREGATION) == (port->actor_oper_port_state & LACP_STATE_AGGREGATION))) ||
+	if (((ntohs(lacpdu->partner_port) == ad_port->actor_port_number) &&
+	     (ntohs(lacpdu->partner_port_priority) == ad_port->actor_port_priority) &&
+	     MAC_ADDRESS_EQUAL(&(lacpdu->partner_system), &(ad_port->actor_system)) &&
+	     (ntohs(lacpdu->partner_system_priority) == ad_port->actor_system_priority) &&
+	     (ntohs(lacpdu->partner_key) == ad_port->actor_oper_port_key) &&
+	     ((lacpdu->partner_state & LACP_STATE_AGGREGATION) == (ad_port->actor_oper_port_state & LACP_STATE_AGGREGATION))) ||
 	    ((lacpdu->actor_state & LACP_STATE_AGGREGATION) == 0)
 		) {
-		port->sm_vars |= AD_PORT_MATCHED;
+		ad_port->sm_vars |= AD_PORT_MATCHED;
 	} else {
-		port->sm_vars &= ~AD_PORT_MATCHED;
+		ad_port->sm_vars &= ~AD_PORT_MATCHED;
 	}
 }
 
 /**
  * __record_pdu - record parameters from a received lacpdu
  * @lacpdu: the lacpdu we've received
- * @port: the port we're looking at
+ * @ad_port: the ad_port we're looking at
  *
  * Record the parameter values for the Actor carried in a received lacpdu as
  * the current partner operational parameter values and sets
  * actor_oper_port_state.defaulted to FALSE.
  */
-static void __record_pdu(struct lacpdu *lacpdu, struct port *port)
+static void __record_pdu(struct lacpdu *lacpdu, struct ad_port *ad_port)
 {
-	if (lacpdu && port) {
-		struct port_params *partner = &port->partner_oper;
+	if (lacpdu && ad_port) {
+		struct port_params *partner = &ad_port->partner_oper;
 
-		__choose_matched(lacpdu, port);
+		__choose_matched(lacpdu, ad_port);
 		/* record the new parameter values for the partner
 		 * operational
 		 */
@@ -482,19 +482,19 @@ static void __record_pdu(struct lacpdu *lacpdu, struct port *port)
 		partner->port_state = lacpdu->actor_state;
 
 		/* set actor_oper_port_state.defaulted to FALSE */
-		port->actor_oper_port_state &= ~LACP_STATE_DEFAULTED;
+		ad_port->actor_oper_port_state &= ~LACP_STATE_DEFAULTED;
 
 		/* set the partner sync. to on if the partner is sync,
-		 * and the port is matched
+		 * and the ad_port is matched
 		 */
-		if ((port->sm_vars & AD_PORT_MATCHED) &&
+		if ((ad_port->sm_vars & AD_PORT_MATCHED) &&
 		    (lacpdu->actor_state & LACP_STATE_SYNCHRONIZATION)) {
 			partner->port_state |= LACP_STATE_SYNCHRONIZATION;
-			slave_dbg(port->slave->bond->dev, port->slave->dev,
+			slave_dbg(ad_port->slave->bond->dev, ad_port->slave->dev,
 				  "partner sync=1\n");
 		} else {
 			partner->port_state &= ~LACP_STATE_SYNCHRONIZATION;
-			slave_dbg(port->slave->bond->dev, port->slave->dev,
+			slave_dbg(ad_port->slave->bond->dev, ad_port->slave->dev,
 				  "partner sync=0\n");
 		}
 	}
@@ -502,41 +502,41 @@ static void __record_pdu(struct lacpdu *lacpdu, struct port *port)
 
 /**
  * __record_default - record default parameters
- * @port: the port we're looking at
+ * @ad_port: the ad_port we're looking at
  *
  * This function records the default parameter values for the partner carried
  * in the Partner Admin parameters as the current partner operational parameter
  * values and sets actor_oper_port_state.defaulted to TRUE.
  */
-static void __record_default(struct port *port)
+static void __record_default(struct ad_port *ad_port)
 {
-	if (port) {
+	if (ad_port) {
 		/* record the partner admin parameters */
-		memcpy(&port->partner_oper, &port->partner_admin,
+		memcpy(&ad_port->partner_oper, &ad_port->partner_admin,
 		       sizeof(struct port_params));
 
 		/* set actor_oper_port_state.defaulted to true */
-		port->actor_oper_port_state |= LACP_STATE_DEFAULTED;
+		ad_port->actor_oper_port_state |= LACP_STATE_DEFAULTED;
 	}
 }
 
 /**
- * __update_selected - update a port's Selected variable from a received lacpdu
+ * __update_selected - update an ad_port's Selected variable from a received lacpdu
  * @lacpdu: the lacpdu we've received
- * @port: the port we're looking at
+ * @ad_port: the ad_port we're looking at
  *
  * Update the value of the selected variable, using parameter values from a
  * newly received lacpdu. The parameter values for the Actor carried in the
  * received PDU are compared with the corresponding operational parameter
- * values for the ports partner. If one or more of the comparisons shows that
+ * values for the ad_ports partner. If one or more of the comparisons shows that
  * the value(s) received in the PDU differ from the current operational values,
  * then selected is set to FALSE and actor_oper_port_state.synchronization is
  * set to out_of_sync. Otherwise, selected remains unchanged.
  */
-static void __update_selected(struct lacpdu *lacpdu, struct port *port)
+static void __update_selected(struct lacpdu *lacpdu, struct ad_port *ad_port)
 {
-	if (lacpdu && port) {
-		const struct port_params *partner = &port->partner_oper;
+	if (lacpdu && ad_port) {
+		const struct port_params *partner = &ad_port->partner_oper;
 
 		/* check if any parameter is different then
 		 * update the state machine selected variable.
@@ -547,14 +547,14 @@ static void __update_selected(struct lacpdu *lacpdu, struct port *port)
 		    ntohs(lacpdu->actor_system_priority) != partner->system_priority ||
 		    ntohs(lacpdu->actor_key) != partner->key ||
 		    (lacpdu->actor_state & LACP_STATE_AGGREGATION) != (partner->port_state & LACP_STATE_AGGREGATION)) {
-			port->sm_vars &= ~AD_PORT_SELECTED;
+			ad_port->sm_vars &= ~AD_PORT_SELECTED;
 		}
 	}
 }
 
 /**
- * __update_default_selected - update a port's Selected variable from Partner
- * @port: the port we're looking at
+ * __update_default_selected - update an ad_port's Selected variable from Partner
+ * @ad_port: the ad_port we're looking at
  *
  * This function updates the value of the selected variable, using the partner
  * administrative parameter values. The administrative values are compared with
@@ -564,11 +564,11 @@ static void __update_selected(struct lacpdu *lacpdu, struct port *port)
  * actor_oper_port_state.synchronization is set to OUT_OF_SYNC. Otherwise,
  * Selected remains unchanged.
  */
-static void __update_default_selected(struct port *port)
+static void __update_default_selected(struct ad_port *ad_port)
 {
-	if (port) {
-		const struct port_params *admin = &port->partner_admin;
-		const struct port_params *oper = &port->partner_oper;
+	if (ad_port) {
+		const struct port_params *admin = &ad_port->partner_admin;
+		const struct port_params *oper = &ad_port->partner_oper;
 
 		/* check if any parameter is different then
 		 * update the state machine selected variable.
@@ -580,15 +580,15 @@ static void __update_default_selected(struct port *port)
 		    admin->key != oper->key ||
 		    (admin->port_state & LACP_STATE_AGGREGATION)
 			!= (oper->port_state & LACP_STATE_AGGREGATION)) {
-			port->sm_vars &= ~AD_PORT_SELECTED;
+			ad_port->sm_vars &= ~AD_PORT_SELECTED;
 		}
 	}
 }
 
 /**
- * __update_ntt - update a port's ntt variable from a received lacpdu
+ * __update_ntt - update an ad_port's ntt variable from a received lacpdu
  * @lacpdu: the lacpdu we've received
- * @port: the port we're looking at
+ * @ad_port: the ad_port we're looking at
  *
  * Updates the value of the ntt variable, using parameter values from a newly
  * received lacpdu. The parameter values for the partner carried in the
@@ -597,46 +597,46 @@ static void __update_default_selected(struct port *port)
  * value(s) received in the PDU differ from the current operational values,
  * then ntt is set to TRUE. Otherwise, ntt remains unchanged.
  */
-static void __update_ntt(struct lacpdu *lacpdu, struct port *port)
+static void __update_ntt(struct lacpdu *lacpdu, struct ad_port *ad_port)
 {
-	/* validate lacpdu and port */
-	if (lacpdu && port) {
+	/* validate lacpdu and ad_port */
+	if (lacpdu && ad_port) {
 		/* check if any parameter is different then
-		 * update the port->ntt.
+		 * update the ad_port->ntt.
 		 */
-		if ((ntohs(lacpdu->partner_port) != port->actor_port_number) ||
-		    (ntohs(lacpdu->partner_port_priority) != port->actor_port_priority) ||
-		    !MAC_ADDRESS_EQUAL(&(lacpdu->partner_system), &(port->actor_system)) ||
-		    (ntohs(lacpdu->partner_system_priority) != port->actor_system_priority) ||
-		    (ntohs(lacpdu->partner_key) != port->actor_oper_port_key) ||
-		    ((lacpdu->partner_state & LACP_STATE_LACP_ACTIVITY) != (port->actor_oper_port_state & LACP_STATE_LACP_ACTIVITY)) ||
-		    ((lacpdu->partner_state & LACP_STATE_LACP_TIMEOUT) != (port->actor_oper_port_state & LACP_STATE_LACP_TIMEOUT)) ||
-		    ((lacpdu->partner_state & LACP_STATE_SYNCHRONIZATION) != (port->actor_oper_port_state & LACP_STATE_SYNCHRONIZATION)) ||
-		    ((lacpdu->partner_state & LACP_STATE_AGGREGATION) != (port->actor_oper_port_state & LACP_STATE_AGGREGATION))
+		if ((ntohs(lacpdu->partner_port) != ad_port->actor_port_number) ||
+		    (ntohs(lacpdu->partner_port_priority) != ad_port->actor_port_priority) ||
+		    !MAC_ADDRESS_EQUAL(&(lacpdu->partner_system), &(ad_port->actor_system)) ||
+		    (ntohs(lacpdu->partner_system_priority) != ad_port->actor_system_priority) ||
+		    (ntohs(lacpdu->partner_key) != ad_port->actor_oper_port_key) ||
+		    ((lacpdu->partner_state & LACP_STATE_LACP_ACTIVITY) != (ad_port->actor_oper_port_state & LACP_STATE_LACP_ACTIVITY)) ||
+		    ((lacpdu->partner_state & LACP_STATE_LACP_TIMEOUT) != (ad_port->actor_oper_port_state & LACP_STATE_LACP_TIMEOUT)) ||
+		    ((lacpdu->partner_state & LACP_STATE_SYNCHRONIZATION) != (ad_port->actor_oper_port_state & LACP_STATE_SYNCHRONIZATION)) ||
+		    ((lacpdu->partner_state & LACP_STATE_AGGREGATION) != (ad_port->actor_oper_port_state & LACP_STATE_AGGREGATION))
 		   ) {
-			port->ntt = true;
+			ad_port->ntt = true;
 		}
 	}
 }
 
 /**
- * __agg_ports_are_ready - check if all ports in an aggregator are ready
+ * __agg_ports_are_ready - check if all ad_ports in an aggregator are ready
  * @aggregator: the aggregator we're looking at
  *
  */
 static int __agg_ports_are_ready(struct aggregator *aggregator)
 {
-	struct port *port;
+	struct ad_port *ad_port;
 	int retval = 1;
 
 	if (aggregator) {
-		/* scan all ports in this aggregator to verfy if they are
+		/* scan all ad_ports in this aggregator to verfy if they are
 		 * all ready.
 		 */
-		for (port = aggregator->lag_ports;
-		     port;
-		     port = port->next_port_in_aggregator) {
-			if (!(port->sm_vars & AD_PORT_READY_N)) {
+		for (ad_port = aggregator->lag_ports;
+		     ad_port;
+		     ad_port = ad_port->next_port_in_aggregator) {
+			if (!(ad_port->sm_vars & AD_PORT_READY_N)) {
 				retval = 0;
 				break;
 			}
@@ -647,32 +647,32 @@ static int __agg_ports_are_ready(struct aggregator *aggregator)
 }
 
 /**
- * __set_agg_ports_ready - set value of Ready bit in all ports of an aggregator
+ * __set_agg_ports_ready - set value of Ready bit in all ad_ports of an aggregator
  * @aggregator: the aggregator we're looking at
- * @val: Should the ports' ready bit be set on or off
+ * @val: Should the ad_ports' ready bit be set on or off
  *
  */
 static void __set_agg_ports_ready(struct aggregator *aggregator, int val)
 {
-	struct port *port;
+	struct ad_port *ad_port;
 
-	for (port = aggregator->lag_ports; port;
-	     port = port->next_port_in_aggregator) {
+	for (ad_port = aggregator->lag_ports; ad_port;
+	     ad_port = ad_port->next_port_in_aggregator) {
 		if (val)
-			port->sm_vars |= AD_PORT_READY;
+			ad_port->sm_vars |= AD_PORT_READY;
 		else
-			port->sm_vars &= ~AD_PORT_READY;
+			ad_port->sm_vars &= ~AD_PORT_READY;
 	}
 }
 
-static int __agg_active_ports(struct aggregator *agg)
+static int __agg_active_ad_ports(struct aggregator *agg)
 {
-	struct port *port;
+	struct ad_port *ad_port;
 	int active = 0;
 
-	for (port = agg->lag_ports; port;
-	     port = port->next_port_in_aggregator) {
-		if (port->is_enabled)
+	for (ad_port = agg->lag_ports; ad_port;
+	     ad_port = ad_port->next_port_in_aggregator) {
+		if (ad_port->is_enabled)
 			active++;
 	}
 
@@ -686,7 +686,7 @@ static int __agg_active_ports(struct aggregator *agg)
  */
 static u32 __get_agg_bandwidth(struct aggregator *aggregator)
 {
-	int nports = __agg_active_ports(aggregator);
+	int nports = __agg_active_ad_ports(aggregator);
 	u32 bandwidth = 0;
 
 	if (nports) {
@@ -760,13 +760,13 @@ static struct aggregator *__get_active_agg(struct aggregator *aggregator)
 }
 
 /**
- * __update_lacpdu_from_port - update a port's lacpdu fields
- * @port: the port we're looking at
+ * __update_lacpdu_from_ad_port - update an ad_port's lacpdu fields
+ * @ad_port: the ad_port we're looking at
  */
-static inline void __update_lacpdu_from_port(struct port *port)
+static inline void __update_lacpdu_from_ad_port(struct ad_port *ad_port)
 {
-	struct lacpdu *lacpdu = &port->lacpdu;
-	const struct port_params *partner = &port->partner_oper;
+	struct lacpdu *lacpdu = &ad_port->lacpdu;
+	const struct port_params *partner = &ad_port->partner_oper;
 
 	/* update current actual Actor parameters
 	 * lacpdu->subtype                   initialized
@@ -775,15 +775,15 @@ static inline void __update_lacpdu_from_port(struct port *port)
 	 * lacpdu->actor_information_length  initialized
 	 */
 
-	lacpdu->actor_system_priority = htons(port->actor_system_priority);
-	lacpdu->actor_system = port->actor_system;
-	lacpdu->actor_key = htons(port->actor_oper_port_key);
-	lacpdu->actor_port_priority = htons(port->actor_port_priority);
-	lacpdu->actor_port = htons(port->actor_port_number);
-	lacpdu->actor_state = port->actor_oper_port_state;
-	slave_dbg(port->slave->bond->dev, port->slave->dev,
-		  "update lacpdu: actor port state %x\n",
-		  port->actor_oper_port_state);
+	lacpdu->actor_system_priority = htons(ad_port->actor_system_priority);
+	lacpdu->actor_system = ad_port->actor_system;
+	lacpdu->actor_key = htons(ad_port->actor_oper_port_key);
+	lacpdu->actor_port_priority = htons(ad_port->actor_port_priority);
+	lacpdu->actor_port = htons(ad_port->actor_port_number);
+	lacpdu->actor_state = ad_port->actor_oper_port_state;
+	slave_dbg(ad_port->slave->bond->dev, ad_port->slave->dev,
+		  "update lacpdu: actor ad port state %x\n",
+		  ad_port->actor_oper_port_state);
 
 	/* lacpdu->reserved_3_1              initialized
 	 * lacpdu->tlv_type_partner_info     initialized
@@ -811,15 +811,15 @@ static inline void __update_lacpdu_from_port(struct port *port)
 /* ================= main 802.3ad protocol code ========================= */
 
 /**
- * ad_lacpdu_send - send out a lacpdu packet on a given port
- * @port: the port we're looking at
+ * ad_lacpdu_send - send out a lacpdu packet on a given ad_port
+ * @ad_port: the ad_port we're looking at
  *
  * Returns:   0 on success
  *          < 0 on error
  */
-static int ad_lacpdu_send(struct port *port)
+static int ad_lacpdu_send(struct ad_port *ad_port)
 {
-	struct slave *slave = port->slave;
+	struct slave *slave = ad_port->slave;
 	struct sk_buff *skb;
 	struct lacpdu_header *lacpdu_header;
 	int length = sizeof(struct lacpdu_header);
@@ -846,7 +846,7 @@ static int ad_lacpdu_send(struct port *port)
 	ether_addr_copy(lacpdu_header->hdr.h_source, slave->perm_hwaddr);
 	lacpdu_header->hdr.h_proto = PKT_TYPE_LACPDU;
 
-	lacpdu_header->lacpdu = port->lacpdu;
+	lacpdu_header->lacpdu = ad_port->lacpdu;
 
 	dev_queue_xmit(skb);
 
@@ -854,16 +854,16 @@ static int ad_lacpdu_send(struct port *port)
 }
 
 /**
- * ad_marker_send - send marker information/response on a given port
- * @port: the port we're looking at
+ * ad_marker_send - send marker information/response on a given ad_port
+ * @ad_port: the ad_port we're looking at
  * @marker: marker data to send
  *
  * Returns:   0 on success
  *          < 0 on error
  */
-static int ad_marker_send(struct port *port, struct bond_marker *marker)
+static int ad_marker_send(struct ad_port *ad_port, struct bond_marker *marker)
 {
-	struct slave *slave = port->slave;
+	struct slave *slave = ad_port->slave;
 	struct sk_buff *skb;
 	struct bond_marker_header *marker_header;
 	int length = sizeof(struct bond_marker_header);
@@ -907,104 +907,104 @@ static int ad_marker_send(struct port *port, struct bond_marker *marker)
 }
 
 /**
- * ad_mux_machine - handle a port's mux state machine
- * @port: the port we're looking at
+ * ad_mux_machine - handle an ad_port's mux state machine
+ * @ad_port: the ad_port we're looking at
  * @update_slave_arr: Does slave array need update?
  */
-static void ad_mux_machine(struct port *port, bool *update_slave_arr)
+static void ad_mux_machine(struct ad_port *ad_port, bool *update_slave_arr)
 {
 	mux_states_t last_state;
 
 	/* keep current State Machine state to compare later if it was
 	 * changed
 	 */
-	last_state = port->sm_mux_state;
+	last_state = ad_port->sm_mux_state;
 
-	if (port->sm_vars & AD_PORT_BEGIN) {
-		port->sm_mux_state = AD_MUX_DETACHED;
+	if (ad_port->sm_vars & AD_PORT_BEGIN) {
+		ad_port->sm_mux_state = AD_MUX_DETACHED;
 	} else {
-		switch (port->sm_mux_state) {
+		switch (ad_port->sm_mux_state) {
 		case AD_MUX_DETACHED:
-			if ((port->sm_vars & AD_PORT_SELECTED)
-			    || (port->sm_vars & AD_PORT_STANDBY))
+			if ((ad_port->sm_vars & AD_PORT_SELECTED)
+			    || (ad_port->sm_vars & AD_PORT_STANDBY))
 				/* if SELECTED or STANDBY */
-				port->sm_mux_state = AD_MUX_WAITING;
+				ad_port->sm_mux_state = AD_MUX_WAITING;
 			break;
 		case AD_MUX_WAITING:
 			/* if SELECTED == FALSE return to DETACH state */
-			if (!(port->sm_vars & AD_PORT_SELECTED)) {
-				port->sm_vars &= ~AD_PORT_READY_N;
+			if (!(ad_port->sm_vars & AD_PORT_SELECTED)) {
+				ad_port->sm_vars &= ~AD_PORT_READY_N;
 				/* in order to withhold the Selection Logic to
 				 * check all ports READY_N value every callback
 				 * cycle to update ready variable, we check
 				 * READY_N and update READY here
 				 */
-				__set_agg_ports_ready(port->aggregator, __agg_ports_are_ready(port->aggregator));
-				port->sm_mux_state = AD_MUX_DETACHED;
+				__set_agg_ports_ready(ad_port->aggregator, __agg_ports_are_ready(ad_port->aggregator));
+				ad_port->sm_mux_state = AD_MUX_DETACHED;
 				break;
 			}
 
 			/* check if the wait_while_timer expired */
-			if (port->sm_mux_timer_counter
-			    && !(--port->sm_mux_timer_counter))
-				port->sm_vars |= AD_PORT_READY_N;
+			if (ad_port->sm_mux_timer_counter
+			    && !(--ad_port->sm_mux_timer_counter))
+				ad_port->sm_vars |= AD_PORT_READY_N;
 
 			/* in order to withhold the selection logic to check
 			 * all ports READY_N value every callback cycle to
 			 * update ready variable, we check READY_N and update
 			 * READY here
 			 */
-			__set_agg_ports_ready(port->aggregator, __agg_ports_are_ready(port->aggregator));
+			__set_agg_ports_ready(ad_port->aggregator, __agg_ports_are_ready(ad_port->aggregator));
 
-			/* if the wait_while_timer expired, and the port is
+			/* if the wait_while_timer expired, and the ad_port is
 			 * in READY state, move to ATTACHED state
 			 */
-			if ((port->sm_vars & AD_PORT_READY)
-			    && !port->sm_mux_timer_counter)
-				port->sm_mux_state = AD_MUX_ATTACHED;
+			if ((ad_port->sm_vars & AD_PORT_READY)
+			    && !ad_port->sm_mux_timer_counter)
+				ad_port->sm_mux_state = AD_MUX_ATTACHED;
 			break;
 		case AD_MUX_ATTACHED:
 			/* check also if agg_select_timer expired (so the
-			 * edable port will take place only after this timer)
+			 * edable ad_port will take place only after this timer)
 			 */
-			if ((port->sm_vars & AD_PORT_SELECTED) &&
-			    (port->partner_oper.port_state & LACP_STATE_SYNCHRONIZATION) &&
-			    !__check_agg_selection_timer(port)) {
-				if (port->aggregator->is_active)
-					port->sm_mux_state =
+			if ((ad_port->sm_vars & AD_PORT_SELECTED) &&
+			    (ad_port->partner_oper.port_state & LACP_STATE_SYNCHRONIZATION) &&
+			    !__check_agg_selection_timer(ad_port)) {
+				if (ad_port->aggregator->is_active)
+					ad_port->sm_mux_state =
 					    AD_MUX_COLLECTING_DISTRIBUTING;
-			} else if (!(port->sm_vars & AD_PORT_SELECTED) ||
-				   (port->sm_vars & AD_PORT_STANDBY)) {
+			} else if (!(ad_port->sm_vars & AD_PORT_SELECTED) ||
+				   (ad_port->sm_vars & AD_PORT_STANDBY)) {
 				/* if UNSELECTED or STANDBY */
-				port->sm_vars &= ~AD_PORT_READY_N;
+				ad_port->sm_vars &= ~AD_PORT_READY_N;
 				/* in order to withhold the selection logic to
 				 * check all ports READY_N value every callback
 				 * cycle to update ready variable, we check
 				 * READY_N and update READY here
 				 */
-				__set_agg_ports_ready(port->aggregator, __agg_ports_are_ready(port->aggregator));
-				port->sm_mux_state = AD_MUX_DETACHED;
-			} else if (port->aggregator->is_active) {
-				port->actor_oper_port_state |=
+				__set_agg_ports_ready(ad_port->aggregator, __agg_ports_are_ready(ad_port->aggregator));
+				ad_port->sm_mux_state = AD_MUX_DETACHED;
+			} else if (ad_port->aggregator->is_active) {
+				ad_port->actor_oper_port_state |=
 				    LACP_STATE_SYNCHRONIZATION;
 			}
 			break;
 		case AD_MUX_COLLECTING_DISTRIBUTING:
-			if (!(port->sm_vars & AD_PORT_SELECTED) ||
-			    (port->sm_vars & AD_PORT_STANDBY) ||
-			    !(port->partner_oper.port_state & LACP_STATE_SYNCHRONIZATION) ||
-			    !(port->actor_oper_port_state & LACP_STATE_SYNCHRONIZATION)) {
-				port->sm_mux_state = AD_MUX_ATTACHED;
+			if (!(ad_port->sm_vars & AD_PORT_SELECTED) ||
+			    (ad_port->sm_vars & AD_PORT_STANDBY) ||
+			    !(ad_port->partner_oper.port_state & LACP_STATE_SYNCHRONIZATION) ||
+			    !(ad_port->actor_oper_port_state & LACP_STATE_SYNCHRONIZATION)) {
+				ad_port->sm_mux_state = AD_MUX_ATTACHED;
 			} else {
-				/* if port state hasn't changed make
+				/* if ad_port state hasn't changed make
 				 * sure that a collecting distributing
-				 * port in an active aggregator is enabled
+				 * ad_port in an active aggregator is enabled
 				 */
-				if (port->aggregator &&
-				    port->aggregator->is_active &&
-				    !__port_is_enabled(port)) {
+				if (ad_port->aggregator &&
+				    ad_port->aggregator->is_active &&
+				    !__ad_port_is_enabled(ad_port)) {
 
-					__enable_port(port);
+					__enable_ad_port(ad_port);
 				}
 			}
 			break;
@@ -1014,44 +1014,43 @@ static void ad_mux_machine(struct port *port, bool *update_slave_arr)
 	}
 
 	/* check if the state machine was changed */
-	if (port->sm_mux_state != last_state) {
-		slave_dbg(port->slave->bond->dev, port->slave->dev,
+	if (ad_port->sm_mux_state != last_state) {
+		slave_dbg(ad_port->slave->bond->dev, ad_port->slave->dev,
 			  "Mux Machine: Port=%d, Last State=%d, Curr State=%d\n",
-			  port->actor_port_number,
-			  last_state,
-			  port->sm_mux_state);
-		switch (port->sm_mux_state) {
+			  ad_port->actor_port_number, last_state,
+			  ad_port->sm_mux_state);
+		switch (ad_port->sm_mux_state) {
 		case AD_MUX_DETACHED:
-			port->actor_oper_port_state &= ~LACP_STATE_SYNCHRONIZATION;
-			ad_disable_collecting_distributing(port,
+			ad_port->actor_oper_port_state &= ~LACP_STATE_SYNCHRONIZATION;
+			ad_disable_collecting_distributing(ad_port,
 							   update_slave_arr);
-			port->actor_oper_port_state &= ~LACP_STATE_COLLECTING;
-			port->actor_oper_port_state &= ~LACP_STATE_DISTRIBUTING;
-			port->ntt = true;
+			ad_port->actor_oper_port_state &= ~LACP_STATE_COLLECTING;
+			ad_port->actor_oper_port_state &= ~LACP_STATE_DISTRIBUTING;
+			ad_port->ntt = true;
 			break;
 		case AD_MUX_WAITING:
-			port->sm_mux_timer_counter = __ad_timer_to_ticks(AD_WAIT_WHILE_TIMER, 0);
+			ad_port->sm_mux_timer_counter = __ad_timer_to_ticks(AD_WAIT_WHILE_TIMER, 0);
 			break;
 		case AD_MUX_ATTACHED:
-			if (port->aggregator->is_active)
-				port->actor_oper_port_state |=
+			if (ad_port->aggregator->is_active)
+				ad_port->actor_oper_port_state |=
 				    LACP_STATE_SYNCHRONIZATION;
 			else
-				port->actor_oper_port_state &=
+				ad_port->actor_oper_port_state &=
 				    ~LACP_STATE_SYNCHRONIZATION;
-			port->actor_oper_port_state &= ~LACP_STATE_COLLECTING;
-			port->actor_oper_port_state &= ~LACP_STATE_DISTRIBUTING;
-			ad_disable_collecting_distributing(port,
+			ad_port->actor_oper_port_state &= ~LACP_STATE_COLLECTING;
+			ad_port->actor_oper_port_state &= ~LACP_STATE_DISTRIBUTING;
+			ad_disable_collecting_distributing(ad_port,
 							   update_slave_arr);
-			port->ntt = true;
+			ad_port->ntt = true;
 			break;
 		case AD_MUX_COLLECTING_DISTRIBUTING:
-			port->actor_oper_port_state |= LACP_STATE_COLLECTING;
-			port->actor_oper_port_state |= LACP_STATE_DISTRIBUTING;
-			port->actor_oper_port_state |= LACP_STATE_SYNCHRONIZATION;
-			ad_enable_collecting_distributing(port,
+			ad_port->actor_oper_port_state |= LACP_STATE_COLLECTING;
+			ad_port->actor_oper_port_state |= LACP_STATE_DISTRIBUTING;
+			ad_port->actor_oper_port_state |= LACP_STATE_SYNCHRONIZATION;
+			ad_enable_collecting_distributing(ad_port,
 							  update_slave_arr);
-			port->ntt = true;
+			ad_port->ntt = true;
 			break;
 		default:
 			break;
@@ -1060,69 +1059,69 @@ static void ad_mux_machine(struct port *port, bool *update_slave_arr)
 }
 
 /**
- * ad_rx_machine - handle a port's rx State Machine
+ * ad_rx_machine - handle an ad_port's rx State Machine
  * @lacpdu: the lacpdu we've received
- * @port: the port we're looking at
+ * @ad_port: the ad_port we're looking at
  *
  * If lacpdu arrived, stop previous timer (if exists) and set the next state as
  * CURRENT. If timer expired set the state machine in the proper state.
  * In other cases, this function checks if we need to switch to other state.
  */
-static void ad_rx_machine(struct lacpdu *lacpdu, struct port *port)
+static void ad_rx_machine(struct lacpdu *lacpdu, struct ad_port *ad_port)
 {
 	rx_states_t last_state;
 
 	/* keep current State Machine state to compare later if it was
 	 * changed
 	 */
-	last_state = port->sm_rx_state;
+	last_state = ad_port->sm_rx_state;
 
 	if (lacpdu) {
-		atomic64_inc(&SLAVE_AD_INFO(port->slave)->stats.lacpdu_rx);
-		atomic64_inc(&BOND_AD_INFO(port->slave->bond).stats.lacpdu_rx);
+		atomic64_inc(&SLAVE_AD_INFO(ad_port->slave)->stats.lacpdu_rx);
+		atomic64_inc(&BOND_AD_INFO(ad_port->slave->bond).stats.lacpdu_rx);
 	}
 	/* check if state machine should change state */
 
-	/* first, check if port was reinitialized */
-	if (port->sm_vars & AD_PORT_BEGIN) {
-		port->sm_rx_state = AD_RX_INITIALIZE;
-		port->sm_vars |= AD_PORT_CHURNED;
+	/* first, check if ad_port was reinitialized */
+	if (ad_port->sm_vars & AD_PORT_BEGIN) {
+		ad_port->sm_rx_state = AD_RX_INITIALIZE;
+		ad_port->sm_vars |= AD_PORT_CHURNED;
 	/* check if port is not enabled */
-	} else if (!(port->sm_vars & AD_PORT_BEGIN) && !port->is_enabled)
-		port->sm_rx_state = AD_RX_PORT_DISABLED;
+	} else if (!(ad_port->sm_vars & AD_PORT_BEGIN) && !ad_port->is_enabled)
+		ad_port->sm_rx_state = AD_RX_PORT_DISABLED;
 	/* check if new lacpdu arrived */
-	else if (lacpdu && ((port->sm_rx_state == AD_RX_EXPIRED) ||
-		 (port->sm_rx_state == AD_RX_DEFAULTED) ||
-		 (port->sm_rx_state == AD_RX_CURRENT))) {
-		if (port->sm_rx_state != AD_RX_CURRENT)
-			port->sm_vars |= AD_PORT_CHURNED;
-		port->sm_rx_timer_counter = 0;
-		port->sm_rx_state = AD_RX_CURRENT;
+	else if (lacpdu && ((ad_port->sm_rx_state == AD_RX_EXPIRED) ||
+		 (ad_port->sm_rx_state == AD_RX_DEFAULTED) ||
+		 (ad_port->sm_rx_state == AD_RX_CURRENT))) {
+		if (ad_port->sm_rx_state != AD_RX_CURRENT)
+			ad_port->sm_vars |= AD_PORT_CHURNED;
+		ad_port->sm_rx_timer_counter = 0;
+		ad_port->sm_rx_state = AD_RX_CURRENT;
 	} else {
 		/* if timer is on, and if it is expired */
-		if (port->sm_rx_timer_counter &&
-		    !(--port->sm_rx_timer_counter)) {
-			switch (port->sm_rx_state) {
+		if (ad_port->sm_rx_timer_counter &&
+		    !(--ad_port->sm_rx_timer_counter)) {
+			switch (ad_port->sm_rx_state) {
 			case AD_RX_EXPIRED:
-				port->sm_rx_state = AD_RX_DEFAULTED;
+				ad_port->sm_rx_state = AD_RX_DEFAULTED;
 				break;
 			case AD_RX_CURRENT:
-				port->sm_rx_state = AD_RX_EXPIRED;
+				ad_port->sm_rx_state = AD_RX_EXPIRED;
 				break;
 			default:
 				break;
 			}
 		} else {
 			/* if no lacpdu arrived and no timer is on */
-			switch (port->sm_rx_state) {
+			switch (ad_port->sm_rx_state) {
 			case AD_RX_PORT_DISABLED:
-				if (port->is_enabled &&
-				    (port->sm_vars & AD_PORT_LACP_ENABLED))
-					port->sm_rx_state = AD_RX_EXPIRED;
-				else if (port->is_enabled
-					 && ((port->sm_vars
+				if (ad_port->is_enabled &&
+				    (ad_port->sm_vars & AD_PORT_LACP_ENABLED))
+					ad_port->sm_rx_state = AD_RX_EXPIRED;
+				else if (ad_port->is_enabled
+					 && ((ad_port->sm_vars
 					      & AD_PORT_LACP_ENABLED) == 0))
-					port->sm_rx_state = AD_RX_LACP_DISABLED;
+					ad_port->sm_rx_state = AD_RX_LACP_DISABLED;
 				break;
 			default:
 				break;
@@ -1132,68 +1131,68 @@ static void ad_rx_machine(struct lacpdu *lacpdu, struct port *port)
 	}
 
 	/* check if the State machine was changed or new lacpdu arrived */
-	if ((port->sm_rx_state != last_state) || (lacpdu)) {
-		slave_dbg(port->slave->bond->dev, port->slave->dev,
+	if ((ad_port->sm_rx_state != last_state) || (lacpdu)) {
+		slave_dbg(ad_port->slave->bond->dev, ad_port->slave->dev,
 			  "Rx Machine: Port=%d, Last State=%d, Curr State=%d\n",
-			  port->actor_port_number,
+			  ad_port->actor_port_number,
 			  last_state,
-			  port->sm_rx_state);
-		switch (port->sm_rx_state) {
+			  ad_port->sm_rx_state);
+		switch (ad_port->sm_rx_state) {
 		case AD_RX_INITIALIZE:
-			if (!(port->actor_oper_port_key & AD_DUPLEX_KEY_MASKS))
-				port->sm_vars &= ~AD_PORT_LACP_ENABLED;
+			if (!(ad_port->actor_oper_port_key & AD_DUPLEX_KEY_MASKS))
+				ad_port->sm_vars &= ~AD_PORT_LACP_ENABLED;
 			else
-				port->sm_vars |= AD_PORT_LACP_ENABLED;
-			port->sm_vars &= ~AD_PORT_SELECTED;
-			__record_default(port);
-			port->actor_oper_port_state &= ~LACP_STATE_EXPIRED;
-			port->sm_rx_state = AD_RX_PORT_DISABLED;
+				ad_port->sm_vars |= AD_PORT_LACP_ENABLED;
+			ad_port->sm_vars &= ~AD_PORT_SELECTED;
+			__record_default(ad_port);
+			ad_port->actor_oper_port_state &= ~LACP_STATE_EXPIRED;
+			ad_port->sm_rx_state = AD_RX_PORT_DISABLED;
 
 			fallthrough;
 		case AD_RX_PORT_DISABLED:
-			port->sm_vars &= ~AD_PORT_MATCHED;
+			ad_port->sm_vars &= ~AD_PORT_MATCHED;
 			break;
 		case AD_RX_LACP_DISABLED:
-			port->sm_vars &= ~AD_PORT_SELECTED;
-			__record_default(port);
-			port->partner_oper.port_state &= ~LACP_STATE_AGGREGATION;
-			port->sm_vars |= AD_PORT_MATCHED;
-			port->actor_oper_port_state &= ~LACP_STATE_EXPIRED;
+			ad_port->sm_vars &= ~AD_PORT_SELECTED;
+			__record_default(ad_port);
+			ad_port->partner_oper.port_state &= ~LACP_STATE_AGGREGATION;
+			ad_port->sm_vars |= AD_PORT_MATCHED;
+			ad_port->actor_oper_port_state &= ~LACP_STATE_EXPIRED;
 			break;
 		case AD_RX_EXPIRED:
 			/* Reset of the Synchronization flag (Standard 43.4.12)
-			 * This reset cause to disable this port in the
+			 * This reset cause to disable this ad_port in the
 			 * COLLECTING_DISTRIBUTING state of the mux machine in
 			 * case of EXPIRED even if LINK_DOWN didn't arrive for
-			 * the port.
+			 * the ad_port.
 			 */
-			port->partner_oper.port_state &= ~LACP_STATE_SYNCHRONIZATION;
-			port->sm_vars &= ~AD_PORT_MATCHED;
-			port->partner_oper.port_state |= LACP_STATE_LACP_TIMEOUT;
-			port->partner_oper.port_state |= LACP_STATE_LACP_ACTIVITY;
-			port->sm_rx_timer_counter = __ad_timer_to_ticks(AD_CURRENT_WHILE_TIMER, (u16)(AD_SHORT_TIMEOUT));
-			port->actor_oper_port_state |= LACP_STATE_EXPIRED;
-			port->sm_vars |= AD_PORT_CHURNED;
+			ad_port->partner_oper.port_state &= ~LACP_STATE_SYNCHRONIZATION;
+			ad_port->sm_vars &= ~AD_PORT_MATCHED;
+			ad_port->partner_oper.port_state |= LACP_STATE_LACP_TIMEOUT;
+			ad_port->partner_oper.port_state |= LACP_STATE_LACP_ACTIVITY;
+			ad_port->sm_rx_timer_counter = __ad_timer_to_ticks(AD_CURRENT_WHILE_TIMER, (u16)(AD_SHORT_TIMEOUT));
+			ad_port->actor_oper_port_state |= LACP_STATE_EXPIRED;
+			ad_port->sm_vars |= AD_PORT_CHURNED;
 			break;
 		case AD_RX_DEFAULTED:
-			__update_default_selected(port);
-			__record_default(port);
-			port->sm_vars |= AD_PORT_MATCHED;
-			port->actor_oper_port_state &= ~LACP_STATE_EXPIRED;
+			__update_default_selected(ad_port);
+			__record_default(ad_port);
+			ad_port->sm_vars |= AD_PORT_MATCHED;
+			ad_port->actor_oper_port_state &= ~LACP_STATE_EXPIRED;
 			break;
 		case AD_RX_CURRENT:
 			/* detect loopback situation */
 			if (MAC_ADDRESS_EQUAL(&(lacpdu->actor_system),
-					      &(port->actor_system))) {
-				slave_err(port->slave->bond->dev, port->slave->dev, "An illegal loopback occurred on slave\n"
+					      &(ad_port->actor_system))) {
+				slave_err(ad_port->slave->bond->dev, ad_port->slave->dev, "An illegal loopback occurred on slave\n"
 					  "Check the configuration to verify that all adapters are connected to 802.3ad compliant switch ports\n");
 				return;
 			}
-			__update_selected(lacpdu, port);
-			__update_ntt(lacpdu, port);
-			__record_pdu(lacpdu, port);
-			port->sm_rx_timer_counter = __ad_timer_to_ticks(AD_CURRENT_WHILE_TIMER, (u16)(port->actor_oper_port_state & LACP_STATE_LACP_TIMEOUT));
-			port->actor_oper_port_state &= ~LACP_STATE_EXPIRED;
+			__update_selected(lacpdu, ad_port);
+			__update_ntt(lacpdu, ad_port);
+			__record_pdu(lacpdu, ad_port);
+			ad_port->sm_rx_timer_counter = __ad_timer_to_ticks(AD_CURRENT_WHILE_TIMER, (u16)(ad_port->actor_oper_port_state & LACP_STATE_LACP_TIMEOUT));
+			ad_port->actor_oper_port_state &= ~LACP_STATE_EXPIRED;
 			break;
 		default:
 			break;
@@ -1202,116 +1201,116 @@ static void ad_rx_machine(struct lacpdu *lacpdu, struct port *port)
 }
 
 /**
- * ad_churn_machine - handle port churn's state machine
- * @port: the port we're looking at
+ * ad_churn_machine - handle ad_port churn's state machine
+ * @ad_port: the ad_port we're looking at
  *
  */
-static void ad_churn_machine(struct port *port)
+static void ad_churn_machine(struct ad_port *ad_port)
 {
-	if (port->sm_vars & AD_PORT_CHURNED) {
-		port->sm_vars &= ~AD_PORT_CHURNED;
-		port->sm_churn_actor_state = AD_CHURN_MONITOR;
-		port->sm_churn_partner_state = AD_CHURN_MONITOR;
-		port->sm_churn_actor_timer_counter =
+	if (ad_port->sm_vars & AD_PORT_CHURNED) {
+		ad_port->sm_vars &= ~AD_PORT_CHURNED;
+		ad_port->sm_churn_actor_state = AD_CHURN_MONITOR;
+		ad_port->sm_churn_partner_state = AD_CHURN_MONITOR;
+		ad_port->sm_churn_actor_timer_counter =
 			__ad_timer_to_ticks(AD_ACTOR_CHURN_TIMER, 0);
-		port->sm_churn_partner_timer_counter =
+		ad_port->sm_churn_partner_timer_counter =
 			 __ad_timer_to_ticks(AD_PARTNER_CHURN_TIMER, 0);
 		return;
 	}
-	if (port->sm_churn_actor_timer_counter &&
-	    !(--port->sm_churn_actor_timer_counter) &&
-	    port->sm_churn_actor_state == AD_CHURN_MONITOR) {
-		if (port->actor_oper_port_state & LACP_STATE_SYNCHRONIZATION) {
-			port->sm_churn_actor_state = AD_NO_CHURN;
+	if (ad_port->sm_churn_actor_timer_counter &&
+	    !(--ad_port->sm_churn_actor_timer_counter) &&
+	    ad_port->sm_churn_actor_state == AD_CHURN_MONITOR) {
+		if (ad_port->actor_oper_port_state & LACP_STATE_SYNCHRONIZATION) {
+			ad_port->sm_churn_actor_state = AD_NO_CHURN;
 		} else {
-			port->churn_actor_count++;
-			port->sm_churn_actor_state = AD_CHURN;
+			ad_port->churn_actor_count++;
+			ad_port->sm_churn_actor_state = AD_CHURN;
 		}
 	}
-	if (port->sm_churn_partner_timer_counter &&
-	    !(--port->sm_churn_partner_timer_counter) &&
-	    port->sm_churn_partner_state == AD_CHURN_MONITOR) {
-		if (port->partner_oper.port_state & LACP_STATE_SYNCHRONIZATION) {
-			port->sm_churn_partner_state = AD_NO_CHURN;
+	if (ad_port->sm_churn_partner_timer_counter &&
+	    !(--ad_port->sm_churn_partner_timer_counter) &&
+	    ad_port->sm_churn_partner_state == AD_CHURN_MONITOR) {
+		if (ad_port->partner_oper.port_state & LACP_STATE_SYNCHRONIZATION) {
+			ad_port->sm_churn_partner_state = AD_NO_CHURN;
 		} else {
-			port->churn_partner_count++;
-			port->sm_churn_partner_state = AD_CHURN;
+			ad_port->churn_partner_count++;
+			ad_port->sm_churn_partner_state = AD_CHURN;
 		}
 	}
 }
 
 /**
- * ad_tx_machine - handle a port's tx state machine
- * @port: the port we're looking at
+ * ad_tx_machine - handle an ad_port's tx state machine
+ * @ad_port: the ad_port we're looking at
  */
-static void ad_tx_machine(struct port *port)
+static void ad_tx_machine(struct ad_port *ad_port)
 {
 	/* check if tx timer expired, to verify that we do not send more than
 	 * 3 packets per second
 	 */
-	if (port->sm_tx_timer_counter && !(--port->sm_tx_timer_counter)) {
+	if (ad_port->sm_tx_timer_counter && !(--ad_port->sm_tx_timer_counter)) {
 		/* check if there is something to send */
-		if (port->ntt && (port->sm_vars & AD_PORT_LACP_ENABLED)) {
-			__update_lacpdu_from_port(port);
+		if (ad_port->ntt && (ad_port->sm_vars & AD_PORT_LACP_ENABLED)) {
+			__update_lacpdu_from_ad_port(ad_port);
 
-			if (ad_lacpdu_send(port) >= 0) {
-				slave_dbg(port->slave->bond->dev,
-					  port->slave->dev,
+			if (ad_lacpdu_send(ad_port) >= 0) {
+				slave_dbg(ad_port->slave->bond->dev,
+					  ad_port->slave->dev,
 					  "Sent LACPDU on port %d\n",
-					  port->actor_port_number);
+					  ad_port->actor_port_number);
 
 				/* mark ntt as false, so it will not be sent
 				 * again until demanded
 				 */
-				port->ntt = false;
+				ad_port->ntt = false;
 			}
 		}
 		/* restart tx timer(to verify that we will not exceed
 		 * AD_MAX_TX_IN_SECOND
 		 */
-		port->sm_tx_timer_counter = ad_ticks_per_sec/AD_MAX_TX_IN_SECOND;
+		ad_port->sm_tx_timer_counter = ad_ticks_per_sec/AD_MAX_TX_IN_SECOND;
 	}
 }
 
 /**
- * ad_periodic_machine - handle a port's periodic state machine
- * @port: the port we're looking at
+ * ad_periodic_machine - handle an ad_port's periodic state machine
+ * @ad_port: the ad_port we're looking at
  *
  * Turn ntt flag on priodically to perform periodic transmission of lacpdu's.
  */
-static void ad_periodic_machine(struct port *port)
+static void ad_periodic_machine(struct ad_port *ad_port)
 {
 	periodic_states_t last_state;
 
 	/* keep current state machine state to compare later if it was changed */
-	last_state = port->sm_periodic_state;
+	last_state = ad_port->sm_periodic_state;
 
-	/* check if port was reinitialized */
-	if (((port->sm_vars & AD_PORT_BEGIN) || !(port->sm_vars & AD_PORT_LACP_ENABLED) || !port->is_enabled) ||
-	    (!(port->actor_oper_port_state & LACP_STATE_LACP_ACTIVITY) && !(port->partner_oper.port_state & LACP_STATE_LACP_ACTIVITY))
+	/* check if ad_port was reinitialized */
+	if (((ad_port->sm_vars & AD_PORT_BEGIN) || !(ad_port->sm_vars & AD_PORT_LACP_ENABLED) || !ad_port->is_enabled) ||
+	    (!(ad_port->actor_oper_port_state & LACP_STATE_LACP_ACTIVITY) && !(ad_port->partner_oper.port_state & LACP_STATE_LACP_ACTIVITY))
 	   ) {
-		port->sm_periodic_state = AD_NO_PERIODIC;
+		ad_port->sm_periodic_state = AD_NO_PERIODIC;
 	}
 	/* check if state machine should change state */
-	else if (port->sm_periodic_timer_counter) {
+	else if (ad_port->sm_periodic_timer_counter) {
 		/* check if periodic state machine expired */
-		if (!(--port->sm_periodic_timer_counter)) {
+		if (!(--ad_port->sm_periodic_timer_counter)) {
 			/* if expired then do tx */
-			port->sm_periodic_state = AD_PERIODIC_TX;
+			ad_port->sm_periodic_state = AD_PERIODIC_TX;
 		} else {
 			/* If not expired, check if there is some new timeout
 			 * parameter from the partner state
 			 */
-			switch (port->sm_periodic_state) {
+			switch (ad_port->sm_periodic_state) {
 			case AD_FAST_PERIODIC:
-				if (!(port->partner_oper.port_state
+				if (!(ad_port->partner_oper.port_state
 				      & LACP_STATE_LACP_TIMEOUT))
-					port->sm_periodic_state = AD_SLOW_PERIODIC;
+					ad_port->sm_periodic_state = AD_SLOW_PERIODIC;
 				break;
 			case AD_SLOW_PERIODIC:
-				if ((port->partner_oper.port_state & LACP_STATE_LACP_TIMEOUT)) {
-					port->sm_periodic_timer_counter = 0;
-					port->sm_periodic_state = AD_PERIODIC_TX;
+				if ((ad_port->partner_oper.port_state & LACP_STATE_LACP_TIMEOUT)) {
+					ad_port->sm_periodic_timer_counter = 0;
+					ad_port->sm_periodic_state = AD_PERIODIC_TX;
 				}
 				break;
 			default:
@@ -1319,16 +1318,16 @@ static void ad_periodic_machine(struct port *port)
 			}
 		}
 	} else {
-		switch (port->sm_periodic_state) {
+		switch (ad_port->sm_periodic_state) {
 		case AD_NO_PERIODIC:
-			port->sm_periodic_state = AD_FAST_PERIODIC;
+			ad_port->sm_periodic_state = AD_FAST_PERIODIC;
 			break;
 		case AD_PERIODIC_TX:
-			if (!(port->partner_oper.port_state &
+			if (!(ad_port->partner_oper.port_state &
 			    LACP_STATE_LACP_TIMEOUT))
-				port->sm_periodic_state = AD_SLOW_PERIODIC;
+				ad_port->sm_periodic_state = AD_SLOW_PERIODIC;
 			else
-				port->sm_periodic_state = AD_FAST_PERIODIC;
+				ad_port->sm_periodic_state = AD_FAST_PERIODIC;
 			break;
 		default:
 			break;
@@ -1336,25 +1335,25 @@ static void ad_periodic_machine(struct port *port)
 	}
 
 	/* check if the state machine was changed */
-	if (port->sm_periodic_state != last_state) {
-		slave_dbg(port->slave->bond->dev, port->slave->dev,
+	if (ad_port->sm_periodic_state != last_state) {
+		slave_dbg(ad_port->slave->bond->dev, ad_port->slave->dev,
 			  "Periodic Machine: Port=%d, Last State=%d, Curr State=%d\n",
-			  port->actor_port_number, last_state,
-			  port->sm_periodic_state);
-		switch (port->sm_periodic_state) {
+			  ad_port->actor_port_number, last_state,
+			  ad_port->sm_periodic_state);
+		switch (ad_port->sm_periodic_state) {
 		case AD_NO_PERIODIC:
-			port->sm_periodic_timer_counter = 0;
+			ad_port->sm_periodic_timer_counter = 0;
 			break;
 		case AD_FAST_PERIODIC:
 			/* decrement 1 tick we lost in the PERIODIC_TX cycle */
-			port->sm_periodic_timer_counter = __ad_timer_to_ticks(AD_PERIODIC_TIMER, (u16)(AD_FAST_PERIODIC_TIME))-1;
+			ad_port->sm_periodic_timer_counter = __ad_timer_to_ticks(AD_PERIODIC_TIMER, (u16)(AD_FAST_PERIODIC_TIME))-1;
 			break;
 		case AD_SLOW_PERIODIC:
 			/* decrement 1 tick we lost in the PERIODIC_TX cycle */
-			port->sm_periodic_timer_counter = __ad_timer_to_ticks(AD_PERIODIC_TIMER, (u16)(AD_SLOW_PERIODIC_TIME))-1;
+			ad_port->sm_periodic_timer_counter = __ad_timer_to_ticks(AD_PERIODIC_TIMER, (u16)(AD_SLOW_PERIODIC_TIME))-1;
 			break;
 		case AD_PERIODIC_TX:
-			port->ntt = true;
+			ad_port->ntt = true;
 			break;
 		default:
 			break;
@@ -1364,60 +1363,60 @@ static void ad_periodic_machine(struct port *port)
 
 /**
  * ad_port_selection_logic - select aggregation groups
- * @port: the port we're looking at
+ * @ad_port: the ad_port we're looking at
  * @update_slave_arr: Does slave array need update?
  *
- * Select aggregation groups, and assign each port for it's aggregetor. The
+ * Select aggregation groups, and assign each ad_port for it's aggregetor. The
  * selection logic is called in the inititalization (after all the handshkes),
  * and after every lacpdu receive (if selected is off).
  */
-static void ad_port_selection_logic(struct port *port, bool *update_slave_arr)
+static void ad_port_selection_logic(struct ad_port *ad_port, bool *update_slave_arr)
 {
 	struct aggregator *aggregator, *free_aggregator = NULL, *temp_aggregator;
-	struct port *last_port = NULL, *curr_port;
+	struct ad_port *last_port = NULL, *curr_port;
 	struct list_head *iter;
 	struct bonding *bond;
 	struct slave *slave;
 	int found = 0;
 
-	/* if the port is already Selected, do nothing */
-	if (port->sm_vars & AD_PORT_SELECTED)
+	/* if the ad_port is already Selected, do nothing */
+	if (ad_port->sm_vars & AD_PORT_SELECTED)
 		return;
 
-	bond = __get_bond_by_port(port);
+	bond = __get_bond_by_ad_port(ad_port);
 
-	/* if the port is connected to other aggregator, detach it */
-	if (port->aggregator) {
-		/* detach the port from its former aggregator */
-		temp_aggregator = port->aggregator;
+	/* if the ad_port is connected to other aggregator, detach it */
+	if (ad_port->aggregator) {
+		/* detach the ad_port from its former aggregator */
+		temp_aggregator = ad_port->aggregator;
 		for (curr_port = temp_aggregator->lag_ports; curr_port;
 		     last_port = curr_port,
 		     curr_port = curr_port->next_port_in_aggregator) {
-			if (curr_port == port) {
+			if (curr_port == ad_port) {
 				temp_aggregator->num_of_ports--;
-				/* if it is the first port attached to the
+				/* if it is the first ad_port attached to the
 				 * aggregator
 				 */
 				if (!last_port) {
 					temp_aggregator->lag_ports =
-						port->next_port_in_aggregator;
+						ad_port->next_port_in_aggregator;
 				} else {
-					/* not the first port attached to the
+					/* not the first ad_port attached to the
 					 * aggregator
 					 */
 					last_port->next_port_in_aggregator =
-						port->next_port_in_aggregator;
+						ad_port->next_port_in_aggregator;
 				}
 
-				/* clear the port's relations to this
+				/* clear the ad_port's relations to this
 				 * aggregator
 				 */
-				port->aggregator = NULL;
-				port->next_port_in_aggregator = NULL;
-				port->actor_port_aggregator_identifier = 0;
+				ad_port->aggregator = NULL;
+				ad_port->next_port_in_aggregator = NULL;
+				ad_port->actor_port_aggregator_identifier = 0;
 
-				slave_dbg(bond->dev, port->slave->dev, "Port %d left LAG %d\n",
-					  port->actor_port_number,
+				slave_dbg(bond->dev, ad_port->slave->dev, "Port %d left LAG %d\n",
+					  ad_port->actor_port_number,
 					  temp_aggregator->aggregator_identifier);
 				/* if the aggregator is empty, clear its
 				 * parameters, and set it ready to be attached
@@ -1428,17 +1427,17 @@ static void ad_port_selection_logic(struct port *port, bool *update_slave_arr)
 			}
 		}
 		if (!curr_port) {
-			/* meaning: the port was related to an aggregator
-			 * but was not on the aggregator port list
+			/* meaning: the ad_port was related to an aggregator
+			 * but was not on the aggregator ad_port list
 			 */
 			net_warn_ratelimited("%s: (slave %s): Warning: Port %d was related to aggregator %d but was not on its port list\n",
-					     port->slave->bond->dev->name,
-					     port->slave->dev->name,
-					     port->actor_port_number,
-					     port->aggregator->aggregator_identifier);
+					     ad_port->slave->bond->dev->name,
+					     ad_port->slave->dev->name,
+					     ad_port->actor_port_number,
+					     ad_port->aggregator->aggregator_identifier);
 		}
 	}
-	/* search on all aggregators for a suitable aggregator for this port */
+	/* search all aggregators for a suitable aggregator for this ad_port */
 	bond_for_each_slave(bond, slave, iter) {
 		aggregator = &(SLAVE_AD_INFO(slave)->aggregator);
 
@@ -1449,90 +1448,90 @@ static void ad_port_selection_logic(struct port *port, bool *update_slave_arr)
 			continue;
 		}
 		/* check if current aggregator suits us */
-		if (((aggregator->actor_oper_aggregator_key == port->actor_oper_port_key) && /* if all parameters match AND */
-		     MAC_ADDRESS_EQUAL(&(aggregator->partner_system), &(port->partner_oper.system)) &&
-		     (aggregator->partner_system_priority == port->partner_oper.system_priority) &&
-		     (aggregator->partner_oper_aggregator_key == port->partner_oper.key)
+		if (((aggregator->actor_oper_aggregator_key == ad_port->actor_oper_port_key) && /* if all parameters match AND */
+		     MAC_ADDRESS_EQUAL(&(aggregator->partner_system), &(ad_port->partner_oper.system)) &&
+		     (aggregator->partner_system_priority == ad_port->partner_oper.system_priority) &&
+		     (aggregator->partner_oper_aggregator_key == ad_port->partner_oper.key)
 		    ) &&
-		    ((!MAC_ADDRESS_EQUAL(&(port->partner_oper.system), &(null_mac_addr)) && /* partner answers */
+		    ((!MAC_ADDRESS_EQUAL(&(ad_port->partner_oper.system), &(null_mac_addr)) && /* partner answers */
 		      !aggregator->is_individual)  /* but is not individual OR */
 		    )
 		   ) {
 			/* attach to the founded aggregator */
-			port->aggregator = aggregator;
-			port->actor_port_aggregator_identifier =
-				port->aggregator->aggregator_identifier;
-			port->next_port_in_aggregator = aggregator->lag_ports;
-			port->aggregator->num_of_ports++;
-			aggregator->lag_ports = port;
+			ad_port->aggregator = aggregator;
+			ad_port->actor_port_aggregator_identifier =
+				ad_port->aggregator->aggregator_identifier;
+			ad_port->next_port_in_aggregator = aggregator->lag_ports;
+			ad_port->aggregator->num_of_ports++;
+			aggregator->lag_ports = ad_port;
 			slave_dbg(bond->dev, slave->dev, "Port %d joined LAG %d (existing LAG)\n",
-				  port->actor_port_number,
-				  port->aggregator->aggregator_identifier);
+				  ad_port->actor_port_number,
+				  ad_port->aggregator->aggregator_identifier);
 
-			/* mark this port as selected */
-			port->sm_vars |= AD_PORT_SELECTED;
+			/* mark this ad_port as selected */
+			ad_port->sm_vars |= AD_PORT_SELECTED;
 			found = 1;
 			break;
 		}
 	}
 
-	/* the port couldn't find an aggregator - attach it to a new
+	/* the ad_port couldn't find an aggregator - attach it to a new
 	 * aggregator
 	 */
 	if (!found) {
 		if (free_aggregator) {
-			/* assign port a new aggregator */
-			port->aggregator = free_aggregator;
-			port->actor_port_aggregator_identifier =
-				port->aggregator->aggregator_identifier;
+			/* assign ad_port a new aggregator */
+			ad_port->aggregator = free_aggregator;
+			ad_port->actor_port_aggregator_identifier =
+				ad_port->aggregator->aggregator_identifier;
 
 			/* update the new aggregator's parameters
-			 * if port was responsed from the end-user
+			 * if ad_port was responsed from the end-user
 			 */
-			if (port->actor_oper_port_key & AD_DUPLEX_KEY_MASKS)
+			if (ad_port->actor_oper_port_key & AD_DUPLEX_KEY_MASKS)
 				/* if port is full duplex */
-				port->aggregator->is_individual = false;
+				ad_port->aggregator->is_individual = false;
 			else
-				port->aggregator->is_individual = true;
-
-			port->aggregator->actor_admin_aggregator_key =
-				port->actor_admin_port_key;
-			port->aggregator->actor_oper_aggregator_key =
-				port->actor_oper_port_key;
-			port->aggregator->partner_system =
-				port->partner_oper.system;
-			port->aggregator->partner_system_priority =
-				port->partner_oper.system_priority;
-			port->aggregator->partner_oper_aggregator_key = port->partner_oper.key;
-			port->aggregator->receive_state = 1;
-			port->aggregator->transmit_state = 1;
-			port->aggregator->lag_ports = port;
-			port->aggregator->num_of_ports++;
+				ad_port->aggregator->is_individual = true;
+
+			ad_port->aggregator->actor_admin_aggregator_key =
+				ad_port->actor_admin_port_key;
+			ad_port->aggregator->actor_oper_aggregator_key =
+				ad_port->actor_oper_port_key;
+			ad_port->aggregator->partner_system =
+				ad_port->partner_oper.system;
+			ad_port->aggregator->partner_system_priority =
+				ad_port->partner_oper.system_priority;
+			ad_port->aggregator->partner_oper_aggregator_key = ad_port->partner_oper.key;
+			ad_port->aggregator->receive_state = 1;
+			ad_port->aggregator->transmit_state = 1;
+			ad_port->aggregator->lag_ports = ad_port;
+			ad_port->aggregator->num_of_ports++;
 
 			/* mark this port as selected */
-			port->sm_vars |= AD_PORT_SELECTED;
+			ad_port->sm_vars |= AD_PORT_SELECTED;
 
-			slave_dbg(bond->dev, port->slave->dev, "Port %d joined LAG %d (new LAG)\n",
-				  port->actor_port_number,
-				  port->aggregator->aggregator_identifier);
+			slave_dbg(bond->dev, ad_port->slave->dev, "Port %d joined LAG %d (new LAG)\n",
+				  ad_port->actor_port_number,
+				  ad_port->aggregator->aggregator_identifier);
 		} else {
-			slave_err(bond->dev, port->slave->dev,
+			slave_err(bond->dev, ad_port->slave->dev,
 				  "Port %d did not find a suitable aggregator\n",
-				  port->actor_port_number);
+				  ad_port->actor_port_number);
 		}
 	}
-	/* if all aggregator's ports are READY_N == TRUE, set ready=TRUE
-	 * in all aggregator's ports, else set ready=FALSE in all
-	 * aggregator's ports
+	/* if all aggregator's ad_ports are READY_N == TRUE, set ready=TRUE
+	 * in all aggregator's ad_ports, else set ready=FALSE in all
+	 * aggregator's ad_ports
 	 */
-	__set_agg_ports_ready(port->aggregator,
-			      __agg_ports_are_ready(port->aggregator));
+	__set_agg_ports_ready(ad_port->aggregator,
+			      __agg_ports_are_ready(ad_port->aggregator));
 
-	aggregator = __get_first_agg(port);
+	aggregator = __get_first_agg(ad_port);
 	ad_agg_selection_logic(aggregator, update_slave_arr);
 
-	if (!port->aggregator->is_active)
-		port->actor_oper_port_state &= ~LACP_STATE_SYNCHRONIZATION;
+	if (!ad_port->aggregator->is_active)
+		ad_port->actor_oper_port_state &= ~LACP_STATE_SYNCHRONIZATION;
 }
 
 /* Decide if "agg" is a better choice for the new active aggregator that
@@ -1560,7 +1559,7 @@ static struct aggregator *ad_agg_selection_test(struct aggregator *best,
 	 * 4.  Therefore, current and best both have partner replies or
 	 *     both do not, so perform selection policy:
 	 *
-	 * BOND_AD_COUNT: Select by count of ports.  If count is equal,
+	 * BOND_AD_COUNT: Select by count of ad_ports.  If count is equal,
 	 *     select by bandwidth.
 	 *
 	 * BOND_AD_STABLE, BOND_AD_BANDWIDTH: Select by bandwidth.
@@ -1582,10 +1581,10 @@ static struct aggregator *ad_agg_selection_test(struct aggregator *best,
 
 	switch (__get_agg_selection_mode(curr->lag_ports)) {
 	case BOND_AD_COUNT:
-		if (__agg_active_ports(curr) > __agg_active_ports(best))
+		if (__agg_active_ad_ports(curr) > __agg_active_ad_ports(best))
 			return curr;
 
-		if (__agg_active_ports(curr) < __agg_active_ports(best))
+		if (__agg_active_ad_ports(curr) < __agg_active_ad_ports(best))
 			return best;
 
 		fallthrough;
@@ -1609,15 +1608,15 @@ static struct aggregator *ad_agg_selection_test(struct aggregator *best,
 
 static int agg_device_up(const struct aggregator *agg)
 {
-	struct port *port = agg->lag_ports;
+	struct ad_port *ad_port = agg->lag_ports;
 
-	if (!port)
+	if (!ad_port)
 		return 0;
 
-	for (port = agg->lag_ports; port;
-	     port = port->next_port_in_aggregator) {
-		if (netif_running(port->slave->dev) &&
-		    netif_carrier_ok(port->slave->dev))
+	for (ad_port = agg->lag_ports; ad_port;
+	     ad_port = ad_port->next_port_in_aggregator) {
+		if (netif_running(ad_port->slave->dev) &&
+		    netif_carrier_ok(ad_port->slave->dev))
 			return 1;
 	}
 
@@ -1634,15 +1633,15 @@ static int agg_device_up(const struct aggregator *agg)
  * The logic of this function is to select the aggregator according to
  * the ad_select policy:
  *
- * BOND_AD_STABLE: select the aggregator with the most ports attached to
+ * BOND_AD_STABLE: select the aggregator with the most ad_ports attached to
  * it, and to reselect the active aggregator only if the previous
- * aggregator has no more ports related to it.
+ * aggregator has no more ad_ports related to it.
  *
  * BOND_AD_BANDWIDTH: select the aggregator with the highest total
  * bandwidth, and reselect whenever a link state change takes place or the
  * set of slaves in the bond changes.
  *
- * BOND_AD_COUNT: select the aggregator with largest number of ports
+ * BOND_AD_COUNT: select the aggregator with largest number of ad_ports
  * (slaves), and reselect whenever a link state change takes place or the
  * set of slaves in the bond changes.
  *
@@ -1657,7 +1656,7 @@ static void ad_agg_selection_logic(struct aggregator *agg,
 	struct bonding *bond = agg->slave->bond;
 	struct list_head *iter;
 	struct slave *slave;
-	struct port *port;
+	struct ad_port *ad_port;
 
 	rcu_read_lock();
 	origin = agg;
@@ -1669,7 +1668,7 @@ static void ad_agg_selection_logic(struct aggregator *agg,
 
 		agg->is_active = 0;
 
-		if (__agg_active_ports(agg) && agg_device_up(agg))
+		if (__agg_active_ad_ports(agg) && agg_device_up(agg))
 			best = ad_agg_selection_test(best, agg);
 	}
 
@@ -1681,7 +1680,7 @@ static void ad_agg_selection_logic(struct aggregator *agg,
 		 * answering partner.
 		 */
 		if (active && active->lag_ports &&
-		    __agg_active_ports(active) &&
+		    __agg_active_ad_ports(active) &&
 		    (__agg_has_partner(active) ||
 		     (!__agg_has_partner(active) &&
 		     !__agg_has_partner(best)))) {
@@ -1736,13 +1735,13 @@ static void ad_agg_selection_logic(struct aggregator *agg,
 			   best->partner_oper_aggregator_key,
 			   best->is_individual, best->is_active);
 
-		/* disable the ports that were related to the former
+		/* disable the ad_ports that were related to the former
 		 * active_aggregator
 		 */
 		if (active) {
-			for (port = active->lag_ports; port;
-			     port = port->next_port_in_aggregator) {
-				__disable_port(port);
+			for (ad_port = active->lag_ports; ad_port;
+			     ad_port = ad_port->next_port_in_aggregator) {
+				__disable_ad_port(ad_port);
 			}
 		}
 		/* Slave array needs update. */
@@ -1750,15 +1749,15 @@ static void ad_agg_selection_logic(struct aggregator *agg,
 	}
 
 	/* if the selected aggregator is of join individuals
-	 * (partner_system is NULL), enable their ports
+	 * (partner_system is NULL), enable their ad_ports
 	 */
 	active = __get_active_agg(origin);
 
 	if (active) {
 		if (!__agg_has_partner(active)) {
-			for (port = active->lag_ports; port;
-			     port = port->next_port_in_aggregator) {
-				__enable_port(port);
+			for (ad_port = active->lag_ports; ad_port;
+			     ad_port = ad_port->next_port_in_aggregator) {
+				__enable_ad_port(ad_port);
 			}
 		}
 	}
@@ -1809,11 +1808,11 @@ static void ad_initialize_agg(struct aggregator *aggregator)
 }
 
 /**
- * ad_initialize_port - initialize a given port's parameters
- * @port: the port we're looking at
+ * ad_initialize_port - initialize a given ad_port's parameters
+ * @ad_port: the ad_port we're looking at
  * @lacp_fast: boolean. whether fast periodic should be used
  */
-static void ad_initialize_port(struct port *port, int lacp_fast)
+static void ad_initialize_port(struct ad_port *ad_port, int lacp_fast)
 {
 	static const struct port_params tmpl = {
 		.system_priority = 0xffff,
@@ -1834,83 +1833,83 @@ static void ad_initialize_port(struct port *port, int lacp_fast)
 		.collector_max_delay = htons(AD_COLLECTOR_MAX_DELAY),
 	};
 
-	if (port) {
-		port->actor_port_priority = 0xff;
-		port->actor_port_aggregator_identifier = 0;
-		port->ntt = false;
-		port->actor_admin_port_state = LACP_STATE_AGGREGATION |
+	if (ad_port) {
+		ad_port->actor_port_priority = 0xff;
+		ad_port->actor_port_aggregator_identifier = 0;
+		ad_port->ntt = false;
+		ad_port->actor_admin_port_state = LACP_STATE_AGGREGATION |
 					       LACP_STATE_LACP_ACTIVITY;
-		port->actor_oper_port_state  = LACP_STATE_AGGREGATION |
+		ad_port->actor_oper_port_state  = LACP_STATE_AGGREGATION |
 					       LACP_STATE_LACP_ACTIVITY;
 
 		if (lacp_fast)
-			port->actor_oper_port_state |= LACP_STATE_LACP_TIMEOUT;
+			ad_port->actor_oper_port_state |= LACP_STATE_LACP_TIMEOUT;
 
-		memcpy(&port->partner_admin, &tmpl, sizeof(tmpl));
-		memcpy(&port->partner_oper, &tmpl, sizeof(tmpl));
+		memcpy(&ad_port->partner_admin, &tmpl, sizeof(tmpl));
+		memcpy(&ad_port->partner_oper, &tmpl, sizeof(tmpl));
 
-		port->is_enabled = true;
+		ad_port->is_enabled = true;
 		/* private parameters */
-		port->sm_vars = AD_PORT_BEGIN | AD_PORT_LACP_ENABLED;
-		port->sm_rx_state = 0;
-		port->sm_rx_timer_counter = 0;
-		port->sm_periodic_state = 0;
-		port->sm_periodic_timer_counter = 0;
-		port->sm_mux_state = 0;
-		port->sm_mux_timer_counter = 0;
-		port->sm_tx_state = 0;
-		port->aggregator = NULL;
-		port->next_port_in_aggregator = NULL;
-		port->transaction_id = 0;
-
-		port->sm_churn_actor_timer_counter = 0;
-		port->sm_churn_actor_state = 0;
-		port->churn_actor_count = 0;
-		port->sm_churn_partner_timer_counter = 0;
-		port->sm_churn_partner_state = 0;
-		port->churn_partner_count = 0;
-
-		memcpy(&port->lacpdu, &lacpdu, sizeof(lacpdu));
+		ad_port->sm_vars = AD_PORT_BEGIN | AD_PORT_LACP_ENABLED;
+		ad_port->sm_rx_state = 0;
+		ad_port->sm_rx_timer_counter = 0;
+		ad_port->sm_periodic_state = 0;
+		ad_port->sm_periodic_timer_counter = 0;
+		ad_port->sm_mux_state = 0;
+		ad_port->sm_mux_timer_counter = 0;
+		ad_port->sm_tx_state = 0;
+		ad_port->aggregator = NULL;
+		ad_port->next_port_in_aggregator = NULL;
+		ad_port->transaction_id = 0;
+
+		ad_port->sm_churn_actor_timer_counter = 0;
+		ad_port->sm_churn_actor_state = 0;
+		ad_port->churn_actor_count = 0;
+		ad_port->sm_churn_partner_timer_counter = 0;
+		ad_port->sm_churn_partner_state = 0;
+		ad_port->churn_partner_count = 0;
+
+		memcpy(&ad_port->lacpdu, &lacpdu, sizeof(lacpdu));
 	}
 }
 
 /**
- * ad_enable_collecting_distributing - enable a port's transmit/receive
- * @port: the port we're looking at
+ * ad_enable_collecting_distributing - enable an ad_port's transmit/receive
+ * @ad_port: the ad_port we're looking at
  * @update_slave_arr: Does slave array need update?
  *
- * Enable @port if it's in an active aggregator
+ * Enable @ad_port if it's in an active aggregator
  */
-static void ad_enable_collecting_distributing(struct port *port,
+static void ad_enable_collecting_distributing(struct ad_port *ad_port,
 					      bool *update_slave_arr)
 {
-	if (port->aggregator->is_active) {
-		slave_dbg(port->slave->bond->dev, port->slave->dev,
+	if (ad_port->aggregator->is_active) {
+		slave_dbg(ad_port->slave->bond->dev, ad_port->slave->dev,
 			  "Enabling port %d (LAG %d)\n",
-			  port->actor_port_number,
-			  port->aggregator->aggregator_identifier);
-		__enable_port(port);
+			  ad_port->actor_port_number,
+			  ad_port->aggregator->aggregator_identifier);
+		__enable_ad_port(ad_port);
 		/* Slave array needs update */
 		*update_slave_arr = true;
 	}
 }
 
 /**
- * ad_disable_collecting_distributing - disable a port's transmit/receive
- * @port: the port we're looking at
+ * ad_disable_collecting_distributing - disable an ad_port's transmit/receive
+ * @ad_port: the ad_port we're looking at
  * @update_slave_arr: Does slave array need update?
  */
-static void ad_disable_collecting_distributing(struct port *port,
+static void ad_disable_collecting_distributing(struct ad_port *ad_port,
 					       bool *update_slave_arr)
 {
-	if (port->aggregator &&
-	    !MAC_ADDRESS_EQUAL(&(port->aggregator->partner_system),
+	if (ad_port->aggregator &&
+	    !MAC_ADDRESS_EQUAL(&(ad_port->aggregator->partner_system),
 			       &(null_mac_addr))) {
-		slave_dbg(port->slave->bond->dev, port->slave->dev,
+		slave_dbg(ad_port->slave->bond->dev, ad_port->slave->dev,
 			  "Disabling port %d (LAG %d)\n",
-			  port->actor_port_number,
-			  port->aggregator->aggregator_identifier);
-		__disable_port(port);
+			  ad_port->actor_port_number,
+			  ad_port->aggregator->aggregator_identifier);
+		__disable_ad_port(ad_port);
 		/* Slave array needs an update */
 		*update_slave_arr = true;
 	}
@@ -1919,15 +1918,15 @@ static void ad_disable_collecting_distributing(struct port *port,
 /**
  * ad_marker_info_received - handle receive of a Marker information frame
  * @marker_info: Marker info received
- * @port: the port we're looking at
+ * @ad_port: the ad_port we're looking at
  */
 static void ad_marker_info_received(struct bond_marker *marker_info,
-				    struct port *port)
+				    struct ad_port *ad_port)
 {
 	struct bond_marker marker;
 
-	atomic64_inc(&SLAVE_AD_INFO(port->slave)->stats.marker_rx);
-	atomic64_inc(&BOND_AD_INFO(port->slave->bond).stats.marker_rx);
+	atomic64_inc(&SLAVE_AD_INFO(ad_port->slave)->stats.marker_rx);
+	atomic64_inc(&BOND_AD_INFO(ad_port->slave->bond).stats.marker_rx);
 
 	/* copy the received marker data to the response marker */
 	memcpy(&marker, marker_info, sizeof(struct bond_marker));
@@ -1935,26 +1934,26 @@ static void ad_marker_info_received(struct bond_marker *marker_info,
 	marker.tlv_type = AD_MARKER_RESPONSE_SUBTYPE;
 
 	/* send the marker response */
-	if (ad_marker_send(port, &marker) >= 0)
-		slave_dbg(port->slave->bond->dev, port->slave->dev,
+	if (ad_marker_send(ad_port, &marker) >= 0)
+		slave_dbg(ad_port->slave->bond->dev, ad_port->slave->dev,
 			  "Sent Marker Response on port %d\n",
-			  port->actor_port_number);
+			  ad_port->actor_port_number);
 }
 
 /**
  * ad_marker_response_received - handle receive of a marker response frame
  * @marker: marker PDU received
- * @port: the port we're looking at
+ * @ad_port: the ad_port we're looking at
  *
  * This function does nothing since we decided not to implement send and handle
  * response for marker PDU's, in this stage, but only to respond to marker
  * information.
  */
 static void ad_marker_response_received(struct bond_marker *marker,
-					struct port *port)
+					struct ad_port *ad_port)
 {
-	atomic64_inc(&SLAVE_AD_INFO(port->slave)->stats.marker_resp_rx);
-	atomic64_inc(&BOND_AD_INFO(port->slave->bond).stats.marker_resp_rx);
+	atomic64_inc(&SLAVE_AD_INFO(ad_port->slave)->stats.marker_resp_rx);
+	atomic64_inc(&BOND_AD_INFO(ad_port->slave->bond).stats.marker_resp_rx);
 
 	/* DO NOTHING, SINCE WE DECIDED NOT TO IMPLEMENT THIS FEATURE FOR NOW */
 }
@@ -2014,7 +2013,7 @@ void bond_3ad_initialize(struct bonding *bond, u16 tick_resolution)
 }
 
 /**
- * bond_3ad_bind_slave - initialize a slave's port
+ * bond_3ad_bind_slave - initialize a slave's ad_port
  * @slave: slave struct to work on
  *
  * Returns:   0 on success
@@ -2023,32 +2022,32 @@ void bond_3ad_initialize(struct bonding *bond, u16 tick_resolution)
 void bond_3ad_bind_slave(struct slave *slave)
 {
 	struct bonding *bond = bond_get_bond_by_slave(slave);
-	struct port *port;
+	struct ad_port *ad_port;
 	struct aggregator *aggregator;
 
 	/* check that the slave has not been initialized yet. */
-	if (SLAVE_AD_INFO(slave)->port.slave != slave) {
+	if (SLAVE_AD_INFO(slave)->ad_port.slave != slave) {
 
-		/* port initialization */
-		port = &(SLAVE_AD_INFO(slave)->port);
+		/* ad_port initialization */
+		ad_port = &(SLAVE_AD_INFO(slave)->ad_port);
 
-		ad_initialize_port(port, bond->params.lacp_fast);
+		ad_initialize_port(ad_port, bond->params.lacp_fast);
 
-		port->slave = slave;
-		port->actor_port_number = SLAVE_AD_INFO(slave)->id;
+		ad_port->slave = slave;
+		ad_port->actor_port_number = SLAVE_AD_INFO(slave)->id;
 		/* key is determined according to the link speed, duplex and
 		 * user key
 		 */
-		port->actor_admin_port_key = bond->params.ad_user_port_key << 6;
-		ad_update_actor_keys(port, false);
+		ad_port->actor_admin_port_key = bond->params.ad_user_port_key << 6;
+		ad_update_actor_keys(ad_port, false);
 		/* actor system is the bond's system */
-		__ad_actor_update_port(port);
+		__ad_actor_update_port(ad_port);
 		/* tx timer(to verify that no more than MAX_TX_IN_SECOND
 		 * lacpdu's are sent in one second)
 		 */
-		port->sm_tx_timer_counter = ad_ticks_per_sec/AD_MAX_TX_IN_SECOND;
+		ad_port->sm_tx_timer_counter = ad_ticks_per_sec/AD_MAX_TX_IN_SECOND;
 
-		__disable_port(port);
+		__disable_ad_port(ad_port);
 
 		/* aggregator initialization */
 		aggregator = &(SLAVE_AD_INFO(slave)->aggregator);
@@ -2064,16 +2063,16 @@ void bond_3ad_bind_slave(struct slave *slave)
 }
 
 /**
- * bond_3ad_unbind_slave - deinitialize a slave's port
+ * bond_3ad_unbind_slave - deinitialize a slave's ad_port
  * @slave: slave struct to work on
  *
- * Search for the aggregator that is related to this port, remove the
- * aggregator and assign another aggregator for other port related to it
- * (if any), and remove the port.
+ * Search for the aggregator that is related to this ad_port, remove the
+ * aggregator and assign another aggregator for other ad_port related to it
+ * (if any), and remove the ad_port.
  */
 void bond_3ad_unbind_slave(struct slave *slave)
 {
-	struct port *port, *prev_port, *temp_port;
+	struct ad_port *ad_port, *prev_port, *temp_port;
 	struct aggregator *aggregator, *new_aggregator, *temp_aggregator;
 	int select_new_active_agg = 0;
 	struct bonding *bond = slave->bond;
@@ -2084,10 +2083,10 @@ void bond_3ad_unbind_slave(struct slave *slave)
 	/* Sync against bond_3ad_state_machine_handler() */
 	spin_lock_bh(&bond->mode_lock);
 	aggregator = &(SLAVE_AD_INFO(slave)->aggregator);
-	port = &(SLAVE_AD_INFO(slave)->port);
+	ad_port = &(SLAVE_AD_INFO(slave)->ad_port);
 
-	/* if slave is null, the whole port is not initialized */
-	if (!port->slave) {
+	/* if slave is null, the whole ad_port is not initialized */
+	if (!ad_port->slave) {
 		slave_warn(bond->dev, slave->dev, "Trying to unbind an uninitialized port\n");
 		goto out;
 	}
@@ -2095,31 +2094,31 @@ void bond_3ad_unbind_slave(struct slave *slave)
 	slave_dbg(bond->dev, slave->dev, "Unbinding Link Aggregation Group %d\n",
 		  aggregator->aggregator_identifier);
 
-	/* Tell the partner that this port is not suitable for aggregation */
-	port->actor_oper_port_state &= ~LACP_STATE_SYNCHRONIZATION;
-	port->actor_oper_port_state &= ~LACP_STATE_COLLECTING;
-	port->actor_oper_port_state &= ~LACP_STATE_DISTRIBUTING;
-	port->actor_oper_port_state &= ~LACP_STATE_AGGREGATION;
-	__update_lacpdu_from_port(port);
-	ad_lacpdu_send(port);
+	/* Tell the partner that this ad_port is not suitable for aggregation */
+	ad_port->actor_oper_port_state &= ~LACP_STATE_SYNCHRONIZATION;
+	ad_port->actor_oper_port_state &= ~LACP_STATE_COLLECTING;
+	ad_port->actor_oper_port_state &= ~LACP_STATE_DISTRIBUTING;
+	ad_port->actor_oper_port_state &= ~LACP_STATE_AGGREGATION;
+	__update_lacpdu_from_ad_port(ad_port);
+	ad_lacpdu_send(ad_port);
 
 	/* check if this aggregator is occupied */
 	if (aggregator->lag_ports) {
-		/* check if there are other ports related to this aggregator
-		 * except the port related to this slave(thats ensure us that
+		/* check if there are other ad_ports related to this aggregator
+		 * except the ad_port related to this slave(thats ensure us that
 		 * there is a reason to search for new aggregator, and that we
 		 * will find one
 		 */
-		if ((aggregator->lag_ports != port) ||
+		if ((aggregator->lag_ports != ad_port) ||
 		    (aggregator->lag_ports->next_port_in_aggregator)) {
-			/* find new aggregator for the related port(s) */
+			/* find new aggregator for the related ad_port(s) */
 			bond_for_each_slave(bond, slave_iter, iter) {
 				new_aggregator = &(SLAVE_AD_INFO(slave_iter)->aggregator);
 				/* if the new aggregator is empty, or it is
-				 * connected to our port only
+				 * connected to our ad_port only
 				 */
 				if (!new_aggregator->lag_ports ||
-				    ((new_aggregator->lag_ports == port) &&
+				    ((new_aggregator->lag_ports == ad_port) &&
 				     !new_aggregator->lag_ports->next_port_in_aggregator))
 					break;
 			}
@@ -2130,12 +2129,12 @@ void bond_3ad_unbind_slave(struct slave *slave)
 			 * parameters and connect the related lag_ports to the
 			 * new aggregator
 			 */
-			if ((new_aggregator) && ((!new_aggregator->lag_ports) || ((new_aggregator->lag_ports == port) && !new_aggregator->lag_ports->next_port_in_aggregator))) {
+			if ((new_aggregator) && ((!new_aggregator->lag_ports) || ((new_aggregator->lag_ports == ad_port) && !new_aggregator->lag_ports->next_port_in_aggregator))) {
 				slave_dbg(bond->dev, slave->dev, "Some port(s) related to LAG %d - replacing with LAG %d\n",
 					  aggregator->aggregator_identifier,
 					  new_aggregator->aggregator_identifier);
 
-				if ((new_aggregator->lag_ports == port) &&
+				if ((new_aggregator->lag_ports == ad_port) &&
 				    new_aggregator->is_active) {
 					slave_info(bond->dev, slave->dev, "Removing an active aggregator\n");
 					select_new_active_agg = 1;
@@ -2165,13 +2164,13 @@ void bond_3ad_unbind_slave(struct slave *slave)
 				ad_clear_agg(aggregator);
 
 				if (select_new_active_agg)
-					ad_agg_selection_logic(__get_first_agg(port),
+					ad_agg_selection_logic(__get_first_agg(ad_port),
 							       &dummy_slave_update);
 			} else {
 				slave_warn(bond->dev, slave->dev, "unbinding aggregator, and could not find a new aggregator for its ports\n");
 			}
 		} else {
-			/* in case that the only port related to this
+			/* in case that the only ad_port related to this
 			 * aggregator is the one we want to remove
 			 */
 			select_new_active_agg = aggregator->is_active;
@@ -2179,7 +2178,7 @@ void bond_3ad_unbind_slave(struct slave *slave)
 			if (select_new_active_agg) {
 				slave_info(bond->dev, slave->dev, "Removing an active aggregator\n");
 				/* select new active aggregator */
-				temp_aggregator = __get_first_agg(port);
+				temp_aggregator = __get_first_agg(ad_port);
 				if (temp_aggregator)
 					ad_agg_selection_logic(temp_aggregator,
 							       &dummy_slave_update);
@@ -2187,17 +2186,17 @@ void bond_3ad_unbind_slave(struct slave *slave)
 		}
 	}
 
-	slave_dbg(bond->dev, slave->dev, "Unbinding port %d\n", port->actor_port_number);
+	slave_dbg(bond->dev, slave->dev, "Unbinding port %d\n", ad_port->actor_port_number);
 
-	/* find the aggregator that this port is connected to */
+	/* find the aggregator that this ad_port is connected to */
 	bond_for_each_slave(bond, slave_iter, iter) {
 		temp_aggregator = &(SLAVE_AD_INFO(slave_iter)->aggregator);
 		prev_port = NULL;
-		/* search the port in the aggregator's related ports */
+		/* search the ad_port in the aggregator's related ad_ports */
 		for (temp_port = temp_aggregator->lag_ports; temp_port;
 		     prev_port = temp_port,
 		     temp_port = temp_port->next_port_in_aggregator) {
-			if (temp_port == port) {
+			if (temp_port == ad_port) {
 				/* the aggregator found - detach the port from
 				 * this aggregator
 				 */
@@ -2206,13 +2205,13 @@ void bond_3ad_unbind_slave(struct slave *slave)
 				else
 					temp_aggregator->lag_ports = temp_port->next_port_in_aggregator;
 				temp_aggregator->num_of_ports--;
-				if (__agg_active_ports(temp_aggregator) == 0) {
+				if (__agg_active_ad_ports(temp_aggregator) == 0) {
 					select_new_active_agg = temp_aggregator->is_active;
 					ad_clear_agg(temp_aggregator);
 					if (select_new_active_agg) {
 						slave_info(bond->dev, slave->dev, "Removing an active aggregator\n");
 						/* select new active aggregator */
-						ad_agg_selection_logic(__get_first_agg(port),
+						ad_agg_selection_logic(__get_first_agg(ad_port),
 							               &dummy_slave_update);
 					}
 				}
@@ -2220,17 +2219,17 @@ void bond_3ad_unbind_slave(struct slave *slave)
 			}
 		}
 	}
-	port->slave = NULL;
+	ad_port->slave = NULL;
 
 out:
 	spin_unlock_bh(&bond->mode_lock);
 }
 
 /**
- * bond_3ad_update_ad_actor_settings - reflect change of actor settings to ports
+ * bond_3ad_update_ad_actor_settings - reflect change of actor settings to ad_ports
  * @bond: bonding struct to work on
  *
- * If an ad_actor setting gets changed we need to update the individual port
+ * If an ad_actor setting gets changed we need to update the individual ad_port
  * settings so the bond device will use the new values when it gets upped.
  */
 void bond_3ad_update_ad_actor_settings(struct bonding *bond)
@@ -2250,10 +2249,10 @@ void bond_3ad_update_ad_actor_settings(struct bonding *bond)
 
 	spin_lock_bh(&bond->mode_lock);
 	bond_for_each_slave(bond, slave, iter) {
-		struct port *port = &(SLAVE_AD_INFO(slave))->port;
+		struct ad_port *ad_port = &(SLAVE_AD_INFO(slave))->ad_port;
 
-		__ad_actor_update_port(port);
-		port->ntt = true;
+		__ad_actor_update_port(ad_port);
+		ad_port->ntt = true;
 	}
 	spin_unlock_bh(&bond->mode_lock);
 }
@@ -2268,7 +2267,7 @@ void bond_3ad_update_ad_actor_settings(struct bonding *bond)
  * reply of one to each other might be delayed until next tick.
  *
  * This function also complete the initialization when the agg_select_timer
- * times out, and it selects an aggregator for the ports that are yet not
+ * times out, and it selects an aggregator for the ad_ports that are yet not
  * related to any aggregator, and selects the active aggregator for a bond.
  */
 void bond_3ad_state_machine_handler(struct work_struct *work)
@@ -2278,11 +2277,11 @@ void bond_3ad_state_machine_handler(struct work_struct *work)
 	struct aggregator *aggregator;
 	struct list_head *iter;
 	struct slave *slave;
-	struct port *port;
+	struct ad_port *ad_port;
 	bool should_notify_rtnl = BOND_SLAVE_NOTIFY_LATER;
 	bool update_slave_arr = false;
 
-	/* Lock to protect data accessed by all (e.g., port->sm_vars) and
+	/* Lock to protect data accessed by all (e.g., ad_port->sm_vars) and
 	 * against running with bond_3ad_unbind_slave. ad_rx_machine may run
 	 * concurrently due to incoming LACPDU as well.
 	 */
@@ -2297,41 +2296,41 @@ void bond_3ad_state_machine_handler(struct work_struct *work)
 	if (BOND_AD_INFO(bond).agg_select_timer &&
 	    !(--BOND_AD_INFO(bond).agg_select_timer)) {
 		slave = bond_first_slave_rcu(bond);
-		port = slave ? &(SLAVE_AD_INFO(slave)->port) : NULL;
+		ad_port = slave ? &(SLAVE_AD_INFO(slave)->ad_port) : NULL;
 
 		/* select the active aggregator for the bond */
-		if (port) {
-			if (!port->slave) {
+		if (ad_port) {
+			if (!ad_port->slave) {
 				net_warn_ratelimited("%s: Warning: bond's first port is uninitialized\n",
 						     bond->dev->name);
 				goto re_arm;
 			}
 
-			aggregator = __get_first_agg(port);
+			aggregator = __get_first_agg(ad_port);
 			ad_agg_selection_logic(aggregator, &update_slave_arr);
 		}
 		bond_3ad_set_carrier(bond);
 	}
 
-	/* for each port run the state machines */
+	/* for each ad_port run the state machines */
 	bond_for_each_slave_rcu(bond, slave, iter) {
-		port = &(SLAVE_AD_INFO(slave)->port);
-		if (!port->slave) {
+		ad_port = &(SLAVE_AD_INFO(slave)->ad_port);
+		if (!ad_port->slave) {
 			net_warn_ratelimited("%s: Warning: Found an uninitialized port\n",
 					    bond->dev->name);
 			goto re_arm;
 		}
 
-		ad_rx_machine(NULL, port);
-		ad_periodic_machine(port);
-		ad_port_selection_logic(port, &update_slave_arr);
-		ad_mux_machine(port, &update_slave_arr);
-		ad_tx_machine(port);
-		ad_churn_machine(port);
+		ad_rx_machine(NULL, ad_port);
+		ad_periodic_machine(ad_port);
+		ad_port_selection_logic(ad_port, &update_slave_arr);
+		ad_mux_machine(ad_port, &update_slave_arr);
+		ad_tx_machine(ad_port);
+		ad_churn_machine(ad_port);
 
 		/* turn off the BEGIN bit, since we already handled it */
-		if (port->sm_vars & AD_PORT_BEGIN)
-			port->sm_vars &= ~AD_PORT_BEGIN;
+		if (ad_port->sm_vars & AD_PORT_BEGIN)
+			ad_port->sm_vars &= ~AD_PORT_BEGIN;
 	}
 
 re_arm:
@@ -2368,11 +2367,11 @@ static int bond_3ad_rx_indication(struct lacpdu *lacpdu, struct slave *slave)
 	struct bonding *bond = slave->bond;
 	int ret = RX_HANDLER_ANOTHER;
 	struct bond_marker *marker;
-	struct port *port;
+	struct ad_port *ad_port;
 	atomic64_t *stat;
 
-	port = &(SLAVE_AD_INFO(slave)->port);
-	if (!port->slave) {
+	ad_port = &(SLAVE_AD_INFO(slave)->ad_port);
+	if (!ad_port->slave) {
 		net_warn_ratelimited("%s: Warning: port of slave %s is uninitialized\n",
 				     slave->dev->name, slave->bond->dev->name);
 		return ret;
@@ -2383,10 +2382,10 @@ static int bond_3ad_rx_indication(struct lacpdu *lacpdu, struct slave *slave)
 		ret = RX_HANDLER_CONSUMED;
 		slave_dbg(slave->bond->dev, slave->dev,
 			  "Received LACPDU on port %d\n",
-			  port->actor_port_number);
+			  ad_port->actor_port_number);
 		/* Protect against concurrent state machines */
 		spin_lock(&slave->bond->mode_lock);
-		ad_rx_machine(lacpdu, port);
+		ad_rx_machine(lacpdu, ad_port);
 		spin_unlock(&slave->bond->mode_lock);
 		break;
 	case AD_TYPE_MARKER:
@@ -2398,17 +2397,17 @@ static int bond_3ad_rx_indication(struct lacpdu *lacpdu, struct slave *slave)
 		switch (marker->tlv_type) {
 		case AD_MARKER_INFORMATION_SUBTYPE:
 			slave_dbg(slave->bond->dev, slave->dev, "Received Marker Information on port %d\n",
-				  port->actor_port_number);
-			ad_marker_info_received(marker, port);
+				  ad_port->actor_port_number);
+			ad_marker_info_received(marker, ad_port);
 			break;
 		case AD_MARKER_RESPONSE_SUBTYPE:
 			slave_dbg(slave->bond->dev, slave->dev, "Received Marker Response on port %d\n",
-				  port->actor_port_number);
-			ad_marker_response_received(marker, port);
+				  ad_port->actor_port_number);
+			ad_marker_response_received(marker, ad_port);
 			break;
 		default:
 			slave_dbg(slave->bond->dev, slave->dev, "Received an unknown Marker subtype on port %d\n",
-				  port->actor_port_number);
+				  ad_port->actor_port_number);
 			stat = &SLAVE_AD_INFO(slave)->stats.marker_unknown_rx;
 			atomic64_inc(stat);
 			stat = &BOND_AD_INFO(bond).stats.marker_unknown_rx;
@@ -2424,47 +2423,47 @@ static int bond_3ad_rx_indication(struct lacpdu *lacpdu, struct slave *slave)
 }
 
 /**
- * ad_update_actor_keys - Update the oper / admin keys for a port based on
+ * ad_update_actor_keys - Update the oper / admin keys for an ad_port based on
  * its current speed and duplex settings.
  *
- * @port: the port we'are looking at
+ * @ad_port: the ad_port we'are looking at
  * @reset: Boolean to just reset the speed and the duplex part of the key
  *
  * The logic to change the oper / admin keys is:
  * (a) A full duplex port can participate in LACP with partner.
  * (b) When the speed is changed, LACP need to be reinitiated.
  */
-static void ad_update_actor_keys(struct port *port, bool reset)
+static void ad_update_actor_keys(struct ad_port *ad_port, bool reset)
 {
 	u8 duplex = 0;
 	u16 ospeed = 0, speed = 0;
-	u16 old_oper_key = port->actor_oper_port_key;
+	u16 old_oper_key = ad_port->actor_oper_port_key;
 
-	port->actor_admin_port_key &= ~(AD_SPEED_KEY_MASKS|AD_DUPLEX_KEY_MASKS);
+	ad_port->actor_admin_port_key &= ~(AD_SPEED_KEY_MASKS|AD_DUPLEX_KEY_MASKS);
 	if (!reset) {
-		speed = __get_link_speed(port);
+		speed = __get_link_speed(ad_port);
 		ospeed = (old_oper_key & AD_SPEED_KEY_MASKS) >> 1;
-		duplex = __get_duplex(port);
-		port->actor_admin_port_key |= (speed << 1) | duplex;
+		duplex = __get_duplex(ad_port);
+		ad_port->actor_admin_port_key |= (speed << 1) | duplex;
 	}
-	port->actor_oper_port_key = port->actor_admin_port_key;
+	ad_port->actor_oper_port_key = ad_port->actor_admin_port_key;
 
-	if (old_oper_key != port->actor_oper_port_key) {
+	if (old_oper_key != ad_port->actor_oper_port_key) {
 		/* Only 'duplex' port participates in LACP */
 		if (duplex)
-			port->sm_vars |= AD_PORT_LACP_ENABLED;
+			ad_port->sm_vars |= AD_PORT_LACP_ENABLED;
 		else
-			port->sm_vars &= ~AD_PORT_LACP_ENABLED;
+			ad_port->sm_vars &= ~AD_PORT_LACP_ENABLED;
 
 		if (!reset) {
 			if (!speed) {
-				slave_err(port->slave->bond->dev,
-					  port->slave->dev,
+				slave_err(ad_port->slave->bond->dev,
+					  ad_port->slave->dev,
 					  "speed changed to 0 on port %d\n",
-					  port->actor_port_number);
+					  ad_port->actor_port_number);
 			} else if (duplex && ospeed != speed) {
 				/* Speed change restarts LACP state-machine */
-				port->sm_vars |= AD_PORT_BEGIN;
+				ad_port->sm_vars |= AD_PORT_BEGIN;
 			}
 		}
 	}
@@ -2476,26 +2475,26 @@ static void ad_update_actor_keys(struct port *port, bool reset)
  *
  * @slave: slave struct to work on
  *
- * Handle reselection of aggregator (if needed) for this port.
+ * Handle reselection of aggregator (if needed) for this ad_port.
  */
 void bond_3ad_adapter_speed_duplex_changed(struct slave *slave)
 {
-	struct port *port;
+	struct ad_port *ad_port;
 
-	port = &(SLAVE_AD_INFO(slave)->port);
+	ad_port = &(SLAVE_AD_INFO(slave)->ad_port);
 
-	/* if slave is null, the whole port is not initialized */
-	if (!port->slave) {
+	/* if slave is null, the whole ad_port is not initialized */
+	if (!ad_port->slave) {
 		slave_warn(slave->bond->dev, slave->dev,
 			   "speed/duplex changed for uninitialized port\n");
 		return;
 	}
 
 	spin_lock_bh(&slave->bond->mode_lock);
-	ad_update_actor_keys(port, false);
+	ad_update_actor_keys(ad_port, false);
 	spin_unlock_bh(&slave->bond->mode_lock);
 	slave_dbg(slave->bond->dev, slave->dev, "Port %d changed speed/duplex\n",
-		  port->actor_port_number);
+		  ad_port->actor_port_number);
 }
 
 /**
@@ -2503,18 +2502,18 @@ void bond_3ad_adapter_speed_duplex_changed(struct slave *slave)
  * @slave: slave struct to work on
  * @link: whether the link is now up or down
  *
- * Handle reselection of aggregator (if needed) for this port.
+ * Handle reselection of aggregator (if needed) for this ad_port.
  */
 void bond_3ad_handle_link_change(struct slave *slave, char link)
 {
 	struct aggregator *agg;
-	struct port *port;
+	struct ad_port *ad_port;
 	bool dummy;
 
-	port = &(SLAVE_AD_INFO(slave)->port);
+	ad_port = &(SLAVE_AD_INFO(slave)->ad_port);
 
-	/* if slave is null, the whole port is not initialized */
-	if (!port->slave) {
+	/* if slave is null, the whole ad_port is not initialized */
+	if (!ad_port->slave) {
 		slave_warn(slave->bond->dev, slave->dev, "link status changed for uninitialized port\n");
 		return;
 	}
@@ -2528,20 +2527,20 @@ void bond_3ad_handle_link_change(struct slave *slave, char link)
 	 * some of he adaptors(ce1000.lan) report.
 	 */
 	if (link == BOND_LINK_UP) {
-		port->is_enabled = true;
-		ad_update_actor_keys(port, false);
+		ad_port->is_enabled = true;
+		ad_update_actor_keys(ad_port, false);
 	} else {
 		/* link has failed */
-		port->is_enabled = false;
-		ad_update_actor_keys(port, true);
+		ad_port->is_enabled = false;
+		ad_update_actor_keys(ad_port, true);
 	}
-	agg = __get_first_agg(port);
+	agg = __get_first_agg(ad_port);
 	ad_agg_selection_logic(agg, &dummy);
 
 	spin_unlock_bh(&slave->bond->mode_lock);
 
 	slave_dbg(slave->bond->dev, slave->dev, "Port %d changed link status to %s\n",
-		  port->actor_port_number,
+		  ad_port->actor_port_number,
 		  link == BOND_LINK_UP ? "UP" : "DOWN");
 
 	/* RTNL is held and mode_lock is released so it's safe
@@ -2578,7 +2577,7 @@ int bond_3ad_set_carrier(struct bonding *bond)
 	active = __get_active_agg(&(SLAVE_AD_INFO(first_slave)->aggregator));
 	if (active) {
 		/* are enough slaves available to consider link up? */
-		if (__agg_active_ports(active) < bond->params.min_links) {
+		if (__agg_active_ad_ports(active) < bond->params.min_links) {
 			if (netif_carrier_ok(bond->dev)) {
 				netif_carrier_off(bond->dev);
 				goto out;
@@ -2609,12 +2608,12 @@ int __bond_3ad_get_active_agg_info(struct bonding *bond,
 	struct aggregator *aggregator = NULL;
 	struct list_head *iter;
 	struct slave *slave;
-	struct port *port;
+	struct ad_port *ad_port;
 
 	bond_for_each_slave_rcu(bond, slave, iter) {
-		port = &(SLAVE_AD_INFO(slave)->port);
-		if (port->aggregator && port->aggregator->is_active) {
-			aggregator = port->aggregator;
+		ad_port = &(SLAVE_AD_INFO(slave)->ad_port);
+		if (ad_port->aggregator && ad_port->aggregator->is_active) {
+			aggregator = ad_port->aggregator;
 			break;
 		}
 	}
@@ -2623,7 +2622,7 @@ int __bond_3ad_get_active_agg_info(struct bonding *bond,
 		return -1;
 
 	ad_info->aggregator_id = aggregator->aggregator_identifier;
-	ad_info->ports = __agg_active_ports(aggregator);
+	ad_info->ports = __agg_active_ad_ports(aggregator);
 	ad_info->actor_key = aggregator->actor_oper_aggregator_key;
 	ad_info->partner_key = aggregator->partner_oper_aggregator_key;
 	ether_addr_copy(ad_info->partner_system,
@@ -2668,15 +2667,15 @@ int bond_3ad_lacpdu_recv(const struct sk_buff *skb, struct bonding *bond,
  * @bond: bonding struct
  *
  * When modify lacp_rate parameter via sysfs,
- * update actor_oper_port_state of each port.
+ * update actor_oper_port_state of each ad_port.
  *
  * Hold bond->mode_lock,
- * so we can modify port->actor_oper_port_state,
+ * so we can modify ad_port->actor_oper_port_state,
  * no matter bond is up or down.
  */
 void bond_3ad_update_lacp_rate(struct bonding *bond)
 {
-	struct port *port = NULL;
+	struct ad_port *ad_port = NULL;
 	struct list_head *iter;
 	struct slave *slave;
 	int lacp_fast;
@@ -2684,11 +2683,11 @@ void bond_3ad_update_lacp_rate(struct bonding *bond)
 	lacp_fast = bond->params.lacp_fast;
 	spin_lock_bh(&bond->mode_lock);
 	bond_for_each_slave(bond, slave, iter) {
-		port = &(SLAVE_AD_INFO(slave)->port);
+		ad_port = &(SLAVE_AD_INFO(slave)->ad_port);
 		if (lacp_fast)
-			port->actor_oper_port_state |= LACP_STATE_LACP_TIMEOUT;
+			ad_port->actor_oper_port_state |= LACP_STATE_LACP_TIMEOUT;
 		else
-			port->actor_oper_port_state &= ~LACP_STATE_LACP_TIMEOUT;
+			ad_port->actor_oper_port_state &= ~LACP_STATE_LACP_TIMEOUT;
 	}
 	spin_unlock_bh(&bond->mode_lock);
 }
diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 42ef25ec0af5..28c04a7a5105 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -1151,7 +1151,7 @@ static void bond_poll_controller(struct net_device *bond_dev)
 
 		if (BOND_MODE(bond) == BOND_MODE_8023AD) {
 			struct aggregator *agg =
-			    SLAVE_AD_INFO(slave)->port.aggregator;
+			    SLAVE_AD_INFO(slave)->ad_port.aggregator;
 
 			if (agg &&
 			    agg->aggregator_identifier != ad_info.aggregator_id)
@@ -4334,7 +4334,7 @@ int bond_update_slave_arr(struct bonding *bond, struct slave *skipslave)
 		if (BOND_MODE(bond) == BOND_MODE_8023AD) {
 			struct aggregator *agg;
 
-			agg = SLAVE_AD_INFO(slave)->port.aggregator;
+			agg = SLAVE_AD_INFO(slave)->ad_port.aggregator;
 			if (!agg || agg->aggregator_identifier != agg_id)
 				continue;
 		}
diff --git a/drivers/net/bonding/bond_netlink.c b/drivers/net/bonding/bond_netlink.c
index f0f9138e967f..fa7304d3eefe 100644
--- a/drivers/net/bonding/bond_netlink.c
+++ b/drivers/net/bonding/bond_netlink.c
@@ -54,10 +54,10 @@ static int bond_fill_slave_info(struct sk_buff *skb,
 
 	if (BOND_MODE(slave->bond) == BOND_MODE_8023AD) {
 		const struct aggregator *agg;
-		const struct port *ad_port;
+		const struct ad_port *ad_port;
 
-		ad_port = &SLAVE_AD_INFO(slave)->port;
-		agg = SLAVE_AD_INFO(slave)->port.aggregator;
+		ad_port = &SLAVE_AD_INFO(slave)->ad_port;
+		agg = SLAVE_AD_INFO(slave)->ad_port.aggregator;
 		if (agg) {
 			if (nla_put_u16(skb, IFLA_BOND_SLAVE_AD_AGGREGATOR_ID,
 					agg->aggregator_identifier))
diff --git a/drivers/net/bonding/bond_procfs.c b/drivers/net/bonding/bond_procfs.c
index fd5c9cbe45b1..9017bc163088 100644
--- a/drivers/net/bonding/bond_procfs.c
+++ b/drivers/net/bonding/bond_procfs.c
@@ -191,49 +191,49 @@ static void bond_info_show_slave(struct seq_file *seq,
 	seq_printf(seq, "Slave queue ID: %d\n", slave->queue_id);
 
 	if (BOND_MODE(bond) == BOND_MODE_8023AD) {
-		const struct port *port = &SLAVE_AD_INFO(slave)->port;
-		const struct aggregator *agg = port->aggregator;
+		const struct ad_port *ad_port = &SLAVE_AD_INFO(slave)->ad_port;
+		const struct aggregator *agg = ad_port->aggregator;
 
 		if (agg) {
 			seq_printf(seq, "Aggregator ID: %d\n",
 				   agg->aggregator_identifier);
 			seq_printf(seq, "Actor Churn State: %s\n",
-				   bond_3ad_churn_desc(port->sm_churn_actor_state));
+				   bond_3ad_churn_desc(ad_port->sm_churn_actor_state));
 			seq_printf(seq, "Partner Churn State: %s\n",
-				   bond_3ad_churn_desc(port->sm_churn_partner_state));
+				   bond_3ad_churn_desc(ad_port->sm_churn_partner_state));
 			seq_printf(seq, "Actor Churned Count: %d\n",
-				   port->churn_actor_count);
+				   ad_port->churn_actor_count);
 			seq_printf(seq, "Partner Churned Count: %d\n",
-				   port->churn_partner_count);
+				   ad_port->churn_partner_count);
 
 			if (capable(CAP_NET_ADMIN)) {
 				seq_puts(seq, "details actor lacp pdu:\n");
 				seq_printf(seq, "    system priority: %d\n",
-					   port->actor_system_priority);
+					   ad_port->actor_system_priority);
 				seq_printf(seq, "    system mac address: %pM\n",
-					   &port->actor_system);
+					   &ad_port->actor_system);
 				seq_printf(seq, "    port key: %d\n",
-					   port->actor_oper_port_key);
+					   ad_port->actor_oper_port_key);
 				seq_printf(seq, "    port priority: %d\n",
-					   port->actor_port_priority);
+					   ad_port->actor_port_priority);
 				seq_printf(seq, "    port number: %d\n",
-					   port->actor_port_number);
+					   ad_port->actor_port_number);
 				seq_printf(seq, "    port state: %d\n",
-					   port->actor_oper_port_state);
+					   ad_port->actor_oper_port_state);
 
 				seq_puts(seq, "details partner lacp pdu:\n");
 				seq_printf(seq, "    system priority: %d\n",
-					   port->partner_oper.system_priority);
+					   ad_port->partner_oper.system_priority);
 				seq_printf(seq, "    system mac address: %pM\n",
-					   &port->partner_oper.system);
+					   &ad_port->partner_oper.system);
 				seq_printf(seq, "    oper key: %d\n",
-					   port->partner_oper.key);
+					   ad_port->partner_oper.key);
 				seq_printf(seq, "    port priority: %d\n",
-					   port->partner_oper.port_priority);
+					   ad_port->partner_oper.port_priority);
 				seq_printf(seq, "    port number: %d\n",
-					   port->partner_oper.port_number);
+					   ad_port->partner_oper.port_number);
 				seq_printf(seq, "    port state: %d\n",
-					   port->partner_oper.port_state);
+					   ad_port->partner_oper.port_state);
 			}
 		} else {
 			seq_puts(seq, "Aggregator ID: N/A\n");
diff --git a/drivers/net/bonding/bond_sysfs_slave.c b/drivers/net/bonding/bond_sysfs_slave.c
index 9b8346638f69..5c0b30d5cadb 100644
--- a/drivers/net/bonding/bond_sysfs_slave.c
+++ b/drivers/net/bonding/bond_sysfs_slave.c
@@ -68,7 +68,7 @@ static ssize_t ad_aggregator_id_show(struct slave *slave, char *buf)
 	const struct aggregator *agg;
 
 	if (BOND_MODE(slave->bond) == BOND_MODE_8023AD) {
-		agg = SLAVE_AD_INFO(slave)->port.aggregator;
+		agg = SLAVE_AD_INFO(slave)->ad_port.aggregator;
 		if (agg)
 			return sprintf(buf, "%d\n",
 				       agg->aggregator_identifier);
@@ -80,10 +80,10 @@ static SLAVE_ATTR_RO(ad_aggregator_id);
 
 static ssize_t ad_actor_oper_port_state_show(struct slave *slave, char *buf)
 {
-	const struct port *ad_port;
+	const struct ad_port *ad_port;
 
 	if (BOND_MODE(slave->bond) == BOND_MODE_8023AD) {
-		ad_port = &SLAVE_AD_INFO(slave)->port;
+		ad_port = &SLAVE_AD_INFO(slave)->ad_port;
 		if (ad_port->aggregator)
 			return sprintf(buf, "%u\n",
 				       ad_port->actor_oper_port_state);
@@ -95,10 +95,10 @@ static SLAVE_ATTR_RO(ad_actor_oper_port_state);
 
 static ssize_t ad_partner_oper_port_state_show(struct slave *slave, char *buf)
 {
-	const struct port *ad_port;
+	const struct ad_port *ad_port;
 
 	if (BOND_MODE(slave->bond) == BOND_MODE_8023AD) {
-		ad_port = &SLAVE_AD_INFO(slave)->port;
+		ad_port = &SLAVE_AD_INFO(slave)->ad_port;
 		if (ad_port->aggregator)
 			return sprintf(buf, "%u\n",
 				       ad_port->partner_oper.port_state);
diff --git a/include/net/bond_3ad.h b/include/net/bond_3ad.h
index c8696a230b7d..8c838eb9a997 100644
--- a/include/net/bond_3ad.h
+++ b/include/net/bond_3ad.h
@@ -157,7 +157,7 @@ typedef struct bond_marker_header {
 struct slave;
 struct bonding;
 struct ad_info;
-struct port;
+struct ad_port;
 
 #ifdef __ia64__
 #pragma pack(8)
@@ -188,7 +188,7 @@ typedef struct aggregator {
 	u16 partner_oper_aggregator_key;
 	u16 receive_state;	/* BOOLEAN */
 	u16 transmit_state;	/* BOOLEAN */
-	struct port *lag_ports;
+	struct ad_port *lag_ports;
 	/* ****** PRIVATE PARAMETERS ****** */
 	struct slave *slave;	/* pointer to the bond slave that this aggregator belongs to */
 	u16 is_active;		/* BOOLEAN. Indicates if this aggregator is active */
@@ -204,8 +204,8 @@ struct port_params {
 	u16 port_state;
 };
 
-/* port structure(43.4.6 in the 802.3ad standard) */
-typedef struct port {
+/* ad_port structure(43.4.6 in the 802.3ad standard) */
+typedef struct ad_port {
 	u16 actor_port_number;
 	u16 actor_port_priority;
 	struct mac_addr actor_system;	/* This parameter is added here although it is not specified in the standard, just for simplification */
@@ -240,10 +240,10 @@ typedef struct port {
 	churn_state_t sm_churn_partner_state;
 	struct slave *slave;		/* pointer to the bond slave that this port belongs to */
 	struct aggregator *aggregator;	/* pointer to an aggregator that this port related to */
-	struct port *next_port_in_aggregator;	/* Next port on the linked list of the parent aggregator */
+	struct ad_port *next_port_in_aggregator;	/* Next port on the linked list of the parent aggregator */
 	u32 transaction_id;		/* continuous number for identification of Marker PDU's; */
 	struct lacpdu lacpdu;		/* the lacpdu that will be sent for this port */
-} port_t;
+} ad_port_t;
 
 /* system structure */
 struct ad_system {
@@ -268,7 +268,7 @@ struct ad_bond_info {
 
 struct ad_slave_info {
 	struct aggregator aggregator;	/* 802.3ad aggregator structure */
-	struct port port;		/* 802.3ad port structure */
+	struct ad_port ad_port;		/* 802.3ad port structure */
 	struct bond_3ad_stats stats;
 	u16 id;
 };
-- 
2.27.0

