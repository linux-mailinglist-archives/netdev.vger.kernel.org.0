Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E50F12AC6E
	for <lists+netdev@lfdr.de>; Thu, 26 Dec 2019 14:45:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726450AbfLZNmE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Dec 2019 08:42:04 -0500
Received: from internalmail.cumulusnetworks.com ([45.55.219.144]:36866 "EHLO
        internalmail.cumulusnetworks.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725954AbfLZNmD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Dec 2019 08:42:03 -0500
Received: from localhost (fw.cumulusnetworks.com [216.129.126.126])
        by internalmail.cumulusnetworks.com (Postfix) with ESMTPSA id 56E3AC11D0;
        Thu, 26 Dec 2019 05:41:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=cumulusnetworks.com;
        s=mail; t=1577367718;
        bh=u+jmUm+PelAeQKm3voXWArI37Iv6JgRzUibfDUEb48k=;
        h=From:To:Cc:Subject:Date;
        b=Vm0h+psXYYCaBfIIfPaRbZQwSducQDtUYn/oQgsZo8EgMAq5VMvXajAKbWkxMUS1r
         7WpqB9mG/icZByjZ0MtybqV+bo7OCDKHmel0RJ5I4tsnTEDQQCvOTmaSaLhh5PYYlL
         dB2QxVL+pvV1ZE1ANYFfbLyjk0Of1IrdAIRV0cbc=
From:   Andy Roulin <aroulin@cumulusnetworks.com>
To:     netdev@vger.kernel.org
Cc:     dsahern@gmail.com, nikolay@cumulusnetworks.com,
        roopa@cumulusnetworks.com, j.vosburgh@gmail.com, vfalico@gmail.com,
        andy@greyhouse.net, aroulin@cumulusnetworks.com
Subject: [PATCH net-next v2] bonding: rename AD_STATE_* to LACP_STATE_*
Date:   Thu, 26 Dec 2019 05:41:57 -0800
Message-Id: <1577367717-3971-1-git-send-email-aroulin@cumulusnetworks.com>
X-Mailer: git-send-email 1.9.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As the LACP actor/partner state is now part of the uapi, rename the
3ad state defines with LACP prefix. The LACP prefix is preferred over
BOND_3AD as the LACP standard moved to 802.1AX.

Fixes: 826f66b30c2e3 ("bonding: move 802.3ad port state flags to uapi")
Signed-off-by: Andy Roulin <aroulin@cumulusnetworks.com>
---

Notes:
    v2: use LACP_* prefix instead of BOND_3AD_*

 drivers/net/bonding/bond_3ad.c  | 112 ++++++++++++++++----------------
 include/uapi/linux/if_bonding.h |  16 ++---
 2 files changed, 64 insertions(+), 64 deletions(-)

diff --git a/drivers/net/bonding/bond_3ad.c b/drivers/net/bonding/bond_3ad.c
index 34bfe99641a3..31e43a2197a3 100644
--- a/drivers/net/bonding/bond_3ad.c
+++ b/drivers/net/bonding/bond_3ad.c
@@ -447,8 +447,8 @@ static void __choose_matched(struct lacpdu *lacpdu, struct port *port)
 	     MAC_ADDRESS_EQUAL(&(lacpdu->partner_system), &(port->actor_system)) &&
 	     (ntohs(lacpdu->partner_system_priority) == port->actor_system_priority) &&
 	     (ntohs(lacpdu->partner_key) == port->actor_oper_port_key) &&
-	     ((lacpdu->partner_state & AD_STATE_AGGREGATION) == (port->actor_oper_port_state & AD_STATE_AGGREGATION))) ||
-	    ((lacpdu->actor_state & AD_STATE_AGGREGATION) == 0)
+	     ((lacpdu->partner_state & LACP_STATE_AGGREGATION) == (port->actor_oper_port_state & LACP_STATE_AGGREGATION))) ||
+	    ((lacpdu->actor_state & LACP_STATE_AGGREGATION) == 0)
 		) {
 		port->sm_vars |= AD_PORT_MATCHED;
 	} else {
@@ -482,18 +482,18 @@ static void __record_pdu(struct lacpdu *lacpdu, struct port *port)
 		partner->port_state = lacpdu->actor_state;
 
 		/* set actor_oper_port_state.defaulted to FALSE */
-		port->actor_oper_port_state &= ~AD_STATE_DEFAULTED;
+		port->actor_oper_port_state &= ~LACP_STATE_DEFAULTED;
 
 		/* set the partner sync. to on if the partner is sync,
 		 * and the port is matched
 		 */
 		if ((port->sm_vars & AD_PORT_MATCHED) &&
-		    (lacpdu->actor_state & AD_STATE_SYNCHRONIZATION)) {
-			partner->port_state |= AD_STATE_SYNCHRONIZATION;
+		    (lacpdu->actor_state & LACP_STATE_SYNCHRONIZATION)) {
+			partner->port_state |= LACP_STATE_SYNCHRONIZATION;
 			slave_dbg(port->slave->bond->dev, port->slave->dev,
 				  "partner sync=1\n");
 		} else {
-			partner->port_state &= ~AD_STATE_SYNCHRONIZATION;
+			partner->port_state &= ~LACP_STATE_SYNCHRONIZATION;
 			slave_dbg(port->slave->bond->dev, port->slave->dev,
 				  "partner sync=0\n");
 		}
@@ -516,7 +516,7 @@ static void __record_default(struct port *port)
 		       sizeof(struct port_params));
 
 		/* set actor_oper_port_state.defaulted to true */
-		port->actor_oper_port_state |= AD_STATE_DEFAULTED;
+		port->actor_oper_port_state |= LACP_STATE_DEFAULTED;
 	}
 }
 
@@ -546,7 +546,7 @@ static void __update_selected(struct lacpdu *lacpdu, struct port *port)
 		    !MAC_ADDRESS_EQUAL(&lacpdu->actor_system, &partner->system) ||
 		    ntohs(lacpdu->actor_system_priority) != partner->system_priority ||
 		    ntohs(lacpdu->actor_key) != partner->key ||
-		    (lacpdu->actor_state & AD_STATE_AGGREGATION) != (partner->port_state & AD_STATE_AGGREGATION)) {
+		    (lacpdu->actor_state & LACP_STATE_AGGREGATION) != (partner->port_state & LACP_STATE_AGGREGATION)) {
 			port->sm_vars &= ~AD_PORT_SELECTED;
 		}
 	}
@@ -578,8 +578,8 @@ static void __update_default_selected(struct port *port)
 		    !MAC_ADDRESS_EQUAL(&admin->system, &oper->system) ||
 		    admin->system_priority != oper->system_priority ||
 		    admin->key != oper->key ||
-		    (admin->port_state & AD_STATE_AGGREGATION)
-			!= (oper->port_state & AD_STATE_AGGREGATION)) {
+		    (admin->port_state & LACP_STATE_AGGREGATION)
+			!= (oper->port_state & LACP_STATE_AGGREGATION)) {
 			port->sm_vars &= ~AD_PORT_SELECTED;
 		}
 	}
@@ -609,10 +609,10 @@ static void __update_ntt(struct lacpdu *lacpdu, struct port *port)
 		    !MAC_ADDRESS_EQUAL(&(lacpdu->partner_system), &(port->actor_system)) ||
 		    (ntohs(lacpdu->partner_system_priority) != port->actor_system_priority) ||
 		    (ntohs(lacpdu->partner_key) != port->actor_oper_port_key) ||
-		    ((lacpdu->partner_state & AD_STATE_LACP_ACTIVITY) != (port->actor_oper_port_state & AD_STATE_LACP_ACTIVITY)) ||
-		    ((lacpdu->partner_state & AD_STATE_LACP_TIMEOUT) != (port->actor_oper_port_state & AD_STATE_LACP_TIMEOUT)) ||
-		    ((lacpdu->partner_state & AD_STATE_SYNCHRONIZATION) != (port->actor_oper_port_state & AD_STATE_SYNCHRONIZATION)) ||
-		    ((lacpdu->partner_state & AD_STATE_AGGREGATION) != (port->actor_oper_port_state & AD_STATE_AGGREGATION))
+		    ((lacpdu->partner_state & LACP_STATE_LACP_ACTIVITY) != (port->actor_oper_port_state & LACP_STATE_LACP_ACTIVITY)) ||
+		    ((lacpdu->partner_state & LACP_STATE_LACP_TIMEOUT) != (port->actor_oper_port_state & LACP_STATE_LACP_TIMEOUT)) ||
+		    ((lacpdu->partner_state & LACP_STATE_SYNCHRONIZATION) != (port->actor_oper_port_state & LACP_STATE_SYNCHRONIZATION)) ||
+		    ((lacpdu->partner_state & LACP_STATE_AGGREGATION) != (port->actor_oper_port_state & LACP_STATE_AGGREGATION))
 		   ) {
 			port->ntt = true;
 		}
@@ -968,7 +968,7 @@ static void ad_mux_machine(struct port *port, bool *update_slave_arr)
 			 * edable port will take place only after this timer)
 			 */
 			if ((port->sm_vars & AD_PORT_SELECTED) &&
-			    (port->partner_oper.port_state & AD_STATE_SYNCHRONIZATION) &&
+			    (port->partner_oper.port_state & LACP_STATE_SYNCHRONIZATION) &&
 			    !__check_agg_selection_timer(port)) {
 				if (port->aggregator->is_active)
 					port->sm_mux_state =
@@ -986,14 +986,14 @@ static void ad_mux_machine(struct port *port, bool *update_slave_arr)
 				port->sm_mux_state = AD_MUX_DETACHED;
 			} else if (port->aggregator->is_active) {
 				port->actor_oper_port_state |=
-				    AD_STATE_SYNCHRONIZATION;
+				    LACP_STATE_SYNCHRONIZATION;
 			}
 			break;
 		case AD_MUX_COLLECTING_DISTRIBUTING:
 			if (!(port->sm_vars & AD_PORT_SELECTED) ||
 			    (port->sm_vars & AD_PORT_STANDBY) ||
-			    !(port->partner_oper.port_state & AD_STATE_SYNCHRONIZATION) ||
-			    !(port->actor_oper_port_state & AD_STATE_SYNCHRONIZATION)) {
+			    !(port->partner_oper.port_state & LACP_STATE_SYNCHRONIZATION) ||
+			    !(port->actor_oper_port_state & LACP_STATE_SYNCHRONIZATION)) {
 				port->sm_mux_state = AD_MUX_ATTACHED;
 			} else {
 				/* if port state hasn't changed make
@@ -1022,11 +1022,11 @@ static void ad_mux_machine(struct port *port, bool *update_slave_arr)
 			  port->sm_mux_state);
 		switch (port->sm_mux_state) {
 		case AD_MUX_DETACHED:
-			port->actor_oper_port_state &= ~AD_STATE_SYNCHRONIZATION;
+			port->actor_oper_port_state &= ~LACP_STATE_SYNCHRONIZATION;
 			ad_disable_collecting_distributing(port,
 							   update_slave_arr);
-			port->actor_oper_port_state &= ~AD_STATE_COLLECTING;
-			port->actor_oper_port_state &= ~AD_STATE_DISTRIBUTING;
+			port->actor_oper_port_state &= ~LACP_STATE_COLLECTING;
+			port->actor_oper_port_state &= ~LACP_STATE_DISTRIBUTING;
 			port->ntt = true;
 			break;
 		case AD_MUX_WAITING:
@@ -1035,20 +1035,20 @@ static void ad_mux_machine(struct port *port, bool *update_slave_arr)
 		case AD_MUX_ATTACHED:
 			if (port->aggregator->is_active)
 				port->actor_oper_port_state |=
-				    AD_STATE_SYNCHRONIZATION;
+				    LACP_STATE_SYNCHRONIZATION;
 			else
 				port->actor_oper_port_state &=
-				    ~AD_STATE_SYNCHRONIZATION;
-			port->actor_oper_port_state &= ~AD_STATE_COLLECTING;
-			port->actor_oper_port_state &= ~AD_STATE_DISTRIBUTING;
+				    ~LACP_STATE_SYNCHRONIZATION;
+			port->actor_oper_port_state &= ~LACP_STATE_COLLECTING;
+			port->actor_oper_port_state &= ~LACP_STATE_DISTRIBUTING;
 			ad_disable_collecting_distributing(port,
 							   update_slave_arr);
 			port->ntt = true;
 			break;
 		case AD_MUX_COLLECTING_DISTRIBUTING:
-			port->actor_oper_port_state |= AD_STATE_COLLECTING;
-			port->actor_oper_port_state |= AD_STATE_DISTRIBUTING;
-			port->actor_oper_port_state |= AD_STATE_SYNCHRONIZATION;
+			port->actor_oper_port_state |= LACP_STATE_COLLECTING;
+			port->actor_oper_port_state |= LACP_STATE_DISTRIBUTING;
+			port->actor_oper_port_state |= LACP_STATE_SYNCHRONIZATION;
 			ad_enable_collecting_distributing(port,
 							  update_slave_arr);
 			port->ntt = true;
@@ -1146,7 +1146,7 @@ static void ad_rx_machine(struct lacpdu *lacpdu, struct port *port)
 				port->sm_vars |= AD_PORT_LACP_ENABLED;
 			port->sm_vars &= ~AD_PORT_SELECTED;
 			__record_default(port);
-			port->actor_oper_port_state &= ~AD_STATE_EXPIRED;
+			port->actor_oper_port_state &= ~LACP_STATE_EXPIRED;
 			port->sm_rx_state = AD_RX_PORT_DISABLED;
 
 			/* Fall Through */
@@ -1156,9 +1156,9 @@ static void ad_rx_machine(struct lacpdu *lacpdu, struct port *port)
 		case AD_RX_LACP_DISABLED:
 			port->sm_vars &= ~AD_PORT_SELECTED;
 			__record_default(port);
-			port->partner_oper.port_state &= ~AD_STATE_AGGREGATION;
+			port->partner_oper.port_state &= ~LACP_STATE_AGGREGATION;
 			port->sm_vars |= AD_PORT_MATCHED;
-			port->actor_oper_port_state &= ~AD_STATE_EXPIRED;
+			port->actor_oper_port_state &= ~LACP_STATE_EXPIRED;
 			break;
 		case AD_RX_EXPIRED:
 			/* Reset of the Synchronization flag (Standard 43.4.12)
@@ -1167,19 +1167,19 @@ static void ad_rx_machine(struct lacpdu *lacpdu, struct port *port)
 			 * case of EXPIRED even if LINK_DOWN didn't arrive for
 			 * the port.
 			 */
-			port->partner_oper.port_state &= ~AD_STATE_SYNCHRONIZATION;
+			port->partner_oper.port_state &= ~LACP_STATE_SYNCHRONIZATION;
 			port->sm_vars &= ~AD_PORT_MATCHED;
-			port->partner_oper.port_state |= AD_STATE_LACP_TIMEOUT;
-			port->partner_oper.port_state |= AD_STATE_LACP_ACTIVITY;
+			port->partner_oper.port_state |= LACP_STATE_LACP_TIMEOUT;
+			port->partner_oper.port_state |= LACP_STATE_LACP_ACTIVITY;
 			port->sm_rx_timer_counter = __ad_timer_to_ticks(AD_CURRENT_WHILE_TIMER, (u16)(AD_SHORT_TIMEOUT));
-			port->actor_oper_port_state |= AD_STATE_EXPIRED;
+			port->actor_oper_port_state |= LACP_STATE_EXPIRED;
 			port->sm_vars |= AD_PORT_CHURNED;
 			break;
 		case AD_RX_DEFAULTED:
 			__update_default_selected(port);
 			__record_default(port);
 			port->sm_vars |= AD_PORT_MATCHED;
-			port->actor_oper_port_state &= ~AD_STATE_EXPIRED;
+			port->actor_oper_port_state &= ~LACP_STATE_EXPIRED;
 			break;
 		case AD_RX_CURRENT:
 			/* detect loopback situation */
@@ -1192,8 +1192,8 @@ static void ad_rx_machine(struct lacpdu *lacpdu, struct port *port)
 			__update_selected(lacpdu, port);
 			__update_ntt(lacpdu, port);
 			__record_pdu(lacpdu, port);
-			port->sm_rx_timer_counter = __ad_timer_to_ticks(AD_CURRENT_WHILE_TIMER, (u16)(port->actor_oper_port_state & AD_STATE_LACP_TIMEOUT));
-			port->actor_oper_port_state &= ~AD_STATE_EXPIRED;
+			port->sm_rx_timer_counter = __ad_timer_to_ticks(AD_CURRENT_WHILE_TIMER, (u16)(port->actor_oper_port_state & LACP_STATE_LACP_TIMEOUT));
+			port->actor_oper_port_state &= ~LACP_STATE_EXPIRED;
 			break;
 		default:
 			break;
@@ -1221,7 +1221,7 @@ static void ad_churn_machine(struct port *port)
 	if (port->sm_churn_actor_timer_counter &&
 	    !(--port->sm_churn_actor_timer_counter) &&
 	    port->sm_churn_actor_state == AD_CHURN_MONITOR) {
-		if (port->actor_oper_port_state & AD_STATE_SYNCHRONIZATION) {
+		if (port->actor_oper_port_state & LACP_STATE_SYNCHRONIZATION) {
 			port->sm_churn_actor_state = AD_NO_CHURN;
 		} else {
 			port->churn_actor_count++;
@@ -1231,7 +1231,7 @@ static void ad_churn_machine(struct port *port)
 	if (port->sm_churn_partner_timer_counter &&
 	    !(--port->sm_churn_partner_timer_counter) &&
 	    port->sm_churn_partner_state == AD_CHURN_MONITOR) {
-		if (port->partner_oper.port_state & AD_STATE_SYNCHRONIZATION) {
+		if (port->partner_oper.port_state & LACP_STATE_SYNCHRONIZATION) {
 			port->sm_churn_partner_state = AD_NO_CHURN;
 		} else {
 			port->churn_partner_count++;
@@ -1288,7 +1288,7 @@ static void ad_periodic_machine(struct port *port)
 
 	/* check if port was reinitialized */
 	if (((port->sm_vars & AD_PORT_BEGIN) || !(port->sm_vars & AD_PORT_LACP_ENABLED) || !port->is_enabled) ||
-	    (!(port->actor_oper_port_state & AD_STATE_LACP_ACTIVITY) && !(port->partner_oper.port_state & AD_STATE_LACP_ACTIVITY))
+	    (!(port->actor_oper_port_state & LACP_STATE_LACP_ACTIVITY) && !(port->partner_oper.port_state & LACP_STATE_LACP_ACTIVITY))
 	   ) {
 		port->sm_periodic_state = AD_NO_PERIODIC;
 	}
@@ -1305,11 +1305,11 @@ static void ad_periodic_machine(struct port *port)
 			switch (port->sm_periodic_state) {
 			case AD_FAST_PERIODIC:
 				if (!(port->partner_oper.port_state
-				      & AD_STATE_LACP_TIMEOUT))
+				      & LACP_STATE_LACP_TIMEOUT))
 					port->sm_periodic_state = AD_SLOW_PERIODIC;
 				break;
 			case AD_SLOW_PERIODIC:
-				if ((port->partner_oper.port_state & AD_STATE_LACP_TIMEOUT)) {
+				if ((port->partner_oper.port_state & LACP_STATE_LACP_TIMEOUT)) {
 					port->sm_periodic_timer_counter = 0;
 					port->sm_periodic_state = AD_PERIODIC_TX;
 				}
@@ -1325,7 +1325,7 @@ static void ad_periodic_machine(struct port *port)
 			break;
 		case AD_PERIODIC_TX:
 			if (!(port->partner_oper.port_state &
-			    AD_STATE_LACP_TIMEOUT))
+			    LACP_STATE_LACP_TIMEOUT))
 				port->sm_periodic_state = AD_SLOW_PERIODIC;
 			else
 				port->sm_periodic_state = AD_FAST_PERIODIC;
@@ -1532,7 +1532,7 @@ static void ad_port_selection_logic(struct port *port, bool *update_slave_arr)
 	ad_agg_selection_logic(aggregator, update_slave_arr);
 
 	if (!port->aggregator->is_active)
-		port->actor_oper_port_state &= ~AD_STATE_SYNCHRONIZATION;
+		port->actor_oper_port_state &= ~LACP_STATE_SYNCHRONIZATION;
 }
 
 /* Decide if "agg" is a better choice for the new active aggregator that
@@ -1838,13 +1838,13 @@ static void ad_initialize_port(struct port *port, int lacp_fast)
 		port->actor_port_priority = 0xff;
 		port->actor_port_aggregator_identifier = 0;
 		port->ntt = false;
-		port->actor_admin_port_state = AD_STATE_AGGREGATION |
-					       AD_STATE_LACP_ACTIVITY;
-		port->actor_oper_port_state  = AD_STATE_AGGREGATION |
-					       AD_STATE_LACP_ACTIVITY;
+		port->actor_admin_port_state = LACP_STATE_AGGREGATION |
+					       LACP_STATE_LACP_ACTIVITY;
+		port->actor_oper_port_state  = LACP_STATE_AGGREGATION |
+					       LACP_STATE_LACP_ACTIVITY;
 
 		if (lacp_fast)
-			port->actor_oper_port_state |= AD_STATE_LACP_TIMEOUT;
+			port->actor_oper_port_state |= LACP_STATE_LACP_TIMEOUT;
 
 		memcpy(&port->partner_admin, &tmpl, sizeof(tmpl));
 		memcpy(&port->partner_oper, &tmpl, sizeof(tmpl));
@@ -2095,10 +2095,10 @@ void bond_3ad_unbind_slave(struct slave *slave)
 		  aggregator->aggregator_identifier);
 
 	/* Tell the partner that this port is not suitable for aggregation */
-	port->actor_oper_port_state &= ~AD_STATE_SYNCHRONIZATION;
-	port->actor_oper_port_state &= ~AD_STATE_COLLECTING;
-	port->actor_oper_port_state &= ~AD_STATE_DISTRIBUTING;
-	port->actor_oper_port_state &= ~AD_STATE_AGGREGATION;
+	port->actor_oper_port_state &= ~LACP_STATE_SYNCHRONIZATION;
+	port->actor_oper_port_state &= ~LACP_STATE_COLLECTING;
+	port->actor_oper_port_state &= ~LACP_STATE_DISTRIBUTING;
+	port->actor_oper_port_state &= ~LACP_STATE_AGGREGATION;
 	__update_lacpdu_from_port(port);
 	ad_lacpdu_send(port);
 
@@ -2685,9 +2685,9 @@ void bond_3ad_update_lacp_rate(struct bonding *bond)
 	bond_for_each_slave(bond, slave, iter) {
 		port = &(SLAVE_AD_INFO(slave)->port);
 		if (lacp_fast)
-			port->actor_oper_port_state |= AD_STATE_LACP_TIMEOUT;
+			port->actor_oper_port_state |= LACP_STATE_LACP_TIMEOUT;
 		else
-			port->actor_oper_port_state &= ~AD_STATE_LACP_TIMEOUT;
+			port->actor_oper_port_state &= ~LACP_STATE_LACP_TIMEOUT;
 	}
 	spin_unlock_bh(&bond->mode_lock);
 }
diff --git a/include/uapi/linux/if_bonding.h b/include/uapi/linux/if_bonding.h
index 6829213a54c5..45f3750aa861 100644
--- a/include/uapi/linux/if_bonding.h
+++ b/include/uapi/linux/if_bonding.h
@@ -96,14 +96,14 @@
 #define BOND_XMIT_POLICY_ENCAP34	4 /* encapsulated layer 3+4 */
 
 /* 802.3ad port state definitions (43.4.2.2 in the 802.3ad standard) */
-#define AD_STATE_LACP_ACTIVITY   0x1
-#define AD_STATE_LACP_TIMEOUT    0x2
-#define AD_STATE_AGGREGATION     0x4
-#define AD_STATE_SYNCHRONIZATION 0x8
-#define AD_STATE_COLLECTING      0x10
-#define AD_STATE_DISTRIBUTING    0x20
-#define AD_STATE_DEFAULTED       0x40
-#define AD_STATE_EXPIRED         0x80
+#define LACP_STATE_LACP_ACTIVITY   0x1
+#define LACP_STATE_LACP_TIMEOUT    0x2
+#define LACP_STATE_AGGREGATION     0x4
+#define LACP_STATE_SYNCHRONIZATION 0x8
+#define LACP_STATE_COLLECTING      0x10
+#define LACP_STATE_DISTRIBUTING    0x20
+#define LACP_STATE_DEFAULTED       0x40
+#define LACP_STATE_EXPIRED         0x80
 
 typedef struct ifbond {
 	__s32 bond_mode;
-- 
2.20.1

