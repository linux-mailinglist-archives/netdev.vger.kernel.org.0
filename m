Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDF303118BA
	for <lists+netdev@lfdr.de>; Sat,  6 Feb 2021 03:49:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229999AbhBFCcK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 21:32:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229587AbhBFCcF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Feb 2021 21:32:05 -0500
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B43DC0611C1
        for <netdev@vger.kernel.org>; Fri,  5 Feb 2021 14:03:23 -0800 (PST)
Received: by mail-ej1-x629.google.com with SMTP id a9so14473394ejr.2
        for <netdev@vger.kernel.org>; Fri, 05 Feb 2021 14:03:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=EdEKlddiPMEq5s0RcOpO54B9BUtWLJWqLn2v/XNUweQ=;
        b=HUbl68u/gvpoj2CR692ce3RGaxzOFESByu6wbzQ/pQDwyQ16cLd5GGsQElbn/jpL2C
         /0K6jodfZpAIFhgtMeddBfGwfupJa48PL/wYqn5FI7hojnITa2T71CX9vpUmx9IdMow4
         BwR3hFyA/pHxWE8iX5j3oDhgtPzHRzwZLQUr42W69CJp0gyUbKyXjaQzAcGq7caEKrcj
         yLO0b+KRMEdVP4HkcXAWHj6xgVUqCHLYTWN735UTfQKovb5l6FVWzzn3ubp09XvGR9YA
         4c1kjDloBneZSUamOkTYQ9msHaSbhjzaCEbwKBXeq3QtyGKVwwku2EaUX49zqV7Bl6lI
         Xlaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EdEKlddiPMEq5s0RcOpO54B9BUtWLJWqLn2v/XNUweQ=;
        b=V6Kb3NwQOh5RGL2hraJ1UaPV4/S0Sf+5ilw8lPtVF5o02fh+Hxwl6lmA8MHLwxG3GW
         LNADifXVwrYr/l2qYii/Q9sPldmI+msEBvTtJi3ZVB+LUOzTxp097FTrDidWpdbv78dU
         v6diq3Wtyii7vh5o1H+UKozBR1mIetu9wu8DjwYwqbD/HukriwoLBmTe+Qr5lmSxBBP/
         sgth0dHeATHi2SuqQ7QyUjJYpJiOvEYLpJBe0akNbSVh+gvkL0cwtHejWct4Pt7Yiu8d
         cx8c38DH/O0grbObXmldpO4VD3biHIJVsInq1pfH8U8GN4azaf6ULWUyd0Cjgj12MmzX
         J7Zg==
X-Gm-Message-State: AOAM531vNs/ApebS650xgrCyfLpP6dtcQJSv89d8GxIXC5M8VUm+ZOdJ
        xI2+TFLMPMpgK58o+M1D+hE=
X-Google-Smtp-Source: ABdhPJwm5Vqvj9gmkQZlLZyfEoFWIa/e4H/8z/Z+AW+0iAxJttqYHcFnURL3OeicK8yd8Yg1Q9+XWQ==
X-Received: by 2002:a17:906:2e0c:: with SMTP id n12mr6033617eji.312.1612562602376;
        Fri, 05 Feb 2021 14:03:22 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id t16sm4969909edi.60.2021.02.05.14.03.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Feb 2021 14:03:21 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: [PATCH RESEND v3 net-next 10/12] net: mscc: ocelot: rebalance LAGs on link up/down events
Date:   Sat,  6 Feb 2021 00:02:19 +0200
Message-Id: <20210205220221.255646-11-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210205220221.255646-1-olteanv@gmail.com>
References: <20210205220221.255646-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

At present there is an issue when ocelot is offloading a bonding
interface, but one of the links of the physical ports goes down. Traffic
keeps being hashed towards that destination, and of course gets dropped
on egress.

Monitor the netdev notifier events emitted by the bonding driver for
changes in the physical state of lower interfaces, to determine which
ports are active and which ones are no longer.

Then extend ocelot_get_bond_mask to return either the configured bonding
interfaces, or the active ones, depending on a boolean argument. The
code that does rebalancing only needs to do so among the active ports,
whereas the bridge forwarding mask and the logical port IDs still need
to look at the permanently bonded ports.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v3:
- Return a proper notifier error code in
  ocelot_netdevice_changelowerstate.
- Export ocelot_port_lag_change.
- Adapt to changes in ocelot_apply_bridge_fwd_mask.

Changes in v2:
- Adapt to the merged version of the DSA API, which now passes just a
  bool lag_tx_active in .port_lag_change instead of the full struct
  netdev_lag_lower_state_info *info.
- Renamed "just_active_ports" -> "only_active_ports"

 drivers/net/ethernet/mscc/ocelot.c     | 41 ++++++++++++++++++++------
 drivers/net/ethernet/mscc/ocelot.h     |  1 +
 drivers/net/ethernet/mscc/ocelot_net.c | 30 +++++++++++++++++++
 include/soc/mscc/ocelot.h              |  1 +
 4 files changed, 64 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 380a5a661702..f8b85ab8be5d 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -889,7 +889,8 @@ int ocelot_get_ts_info(struct ocelot *ocelot, int port,
 }
 EXPORT_SYMBOL(ocelot_get_ts_info);
 
-static u32 ocelot_get_bond_mask(struct ocelot *ocelot, struct net_device *bond)
+static u32 ocelot_get_bond_mask(struct ocelot *ocelot, struct net_device *bond,
+				bool only_active_ports)
 {
 	u32 mask = 0;
 	int port;
@@ -900,8 +901,12 @@ static u32 ocelot_get_bond_mask(struct ocelot *ocelot, struct net_device *bond)
 		if (!ocelot_port)
 			continue;
 
-		if (ocelot_port->bond == bond)
+		if (ocelot_port->bond == bond) {
+			if (only_active_ports && !ocelot_port->lag_tx_active)
+				continue;
+
 			mask |= BIT(port);
+		}
 	}
 
 	return mask;
@@ -960,8 +965,10 @@ void ocelot_apply_bridge_fwd_mask(struct ocelot *ocelot)
 			struct net_device *bond = ocelot_port->bond;
 
 			mask = ocelot->bridge_fwd_mask & ~BIT(port);
-			if (bond)
-				mask &= ~ocelot_get_bond_mask(ocelot, bond);
+			if (bond) {
+				mask &= ~ocelot_get_bond_mask(ocelot, bond,
+							      false);
+			}
 		} else {
 			/* Standalone ports forward only to DSA tag_8021q CPU
 			 * ports (if those exist), or to the hardware CPU port
@@ -1298,20 +1305,20 @@ static void ocelot_set_aggr_pgids(struct ocelot *ocelot)
 	/* Now, set PGIDs for each active LAG */
 	for (lag = 0; lag < ocelot->num_phys_ports; lag++) {
 		struct net_device *bond = ocelot->ports[lag]->bond;
-		int num_ports_in_lag = 0;
+		int num_active_ports = 0;
 		unsigned long bond_mask;
 		u8 aggr_idx[16];
 
 		if (!bond || (visited & BIT(lag)))
 			continue;
 
-		bond_mask = ocelot_get_bond_mask(ocelot, bond);
+		bond_mask = ocelot_get_bond_mask(ocelot, bond, true);
 
 		for_each_set_bit(port, &bond_mask, ocelot->num_phys_ports) {
 			// Destination mask
 			ocelot_write_rix(ocelot, bond_mask,
 					 ANA_PGID_PGID, port);
-			aggr_idx[num_ports_in_lag++] = port;
+			aggr_idx[num_active_ports++] = port;
 		}
 
 		for_each_aggr_pgid(ocelot, i) {
@@ -1319,7 +1326,11 @@ static void ocelot_set_aggr_pgids(struct ocelot *ocelot)
 
 			ac = ocelot_read_rix(ocelot, ANA_PGID_PGID, i);
 			ac &= ~bond_mask;
-			ac |= BIT(aggr_idx[i % num_ports_in_lag]);
+			/* Don't do division by zero if there was no active
+			 * port. Just make all aggregation codes zero.
+			 */
+			if (num_active_ports)
+				ac |= BIT(aggr_idx[i % num_active_ports]);
 			ocelot_write_rix(ocelot, ac, ANA_PGID_PGID, i);
 		}
 
@@ -1356,7 +1367,8 @@ static void ocelot_setup_logical_port_ids(struct ocelot *ocelot)
 
 		bond = ocelot_port->bond;
 		if (bond) {
-			int lag = __ffs(ocelot_get_bond_mask(ocelot, bond));
+			int lag = __ffs(ocelot_get_bond_mask(ocelot, bond,
+							     false));
 
 			ocelot_rmw_gix(ocelot,
 				       ANA_PORT_PORT_CFG_PORTID_VAL(lag),
@@ -1399,6 +1411,17 @@ void ocelot_port_lag_leave(struct ocelot *ocelot, int port,
 }
 EXPORT_SYMBOL(ocelot_port_lag_leave);
 
+void ocelot_port_lag_change(struct ocelot *ocelot, int port, bool lag_tx_active)
+{
+	struct ocelot_port *ocelot_port = ocelot->ports[port];
+
+	ocelot_port->lag_tx_active = lag_tx_active;
+
+	/* Rebalance the LAGs */
+	ocelot_set_aggr_pgids(ocelot);
+}
+EXPORT_SYMBOL(ocelot_port_lag_change);
+
 /* Configure the maximum SDU (L2 payload) on RX to the value specified in @sdu.
  * The length of VLAN tags is accounted for automatically via DEV_MAC_TAGS_CFG.
  * In the special case that it's the NPI port that we're configuring, the
diff --git a/drivers/net/ethernet/mscc/ocelot.h b/drivers/net/ethernet/mscc/ocelot.h
index 12dc74453076..b18f6644726a 100644
--- a/drivers/net/ethernet/mscc/ocelot.h
+++ b/drivers/net/ethernet/mscc/ocelot.h
@@ -114,6 +114,7 @@ int ocelot_port_lag_join(struct ocelot *ocelot, int port,
 			 struct netdev_lag_upper_info *info);
 void ocelot_port_lag_leave(struct ocelot *ocelot, int port,
 			   struct net_device *bond);
+void ocelot_port_lag_change(struct ocelot *ocelot, int port, bool lag_tx_active);
 struct net_device *ocelot_port_to_netdev(struct ocelot *ocelot, int port);
 int ocelot_netdev_to_port(struct net_device *dev);
 
diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
index 0a4de949f4d9..8f12fa45b1b5 100644
--- a/drivers/net/ethernet/mscc/ocelot_net.c
+++ b/drivers/net/ethernet/mscc/ocelot_net.c
@@ -1164,6 +1164,27 @@ ocelot_netdevice_lag_changeupper(struct net_device *dev,
 	return NOTIFY_DONE;
 }
 
+static int
+ocelot_netdevice_changelowerstate(struct net_device *dev,
+				  struct netdev_lag_lower_state_info *info)
+{
+	struct ocelot_port_private *priv = netdev_priv(dev);
+	bool is_active = info->link_up && info->tx_enabled;
+	struct ocelot_port *ocelot_port = &priv->port;
+	struct ocelot *ocelot = ocelot_port->ocelot;
+	int port = priv->chip_port;
+
+	if (!ocelot_port->bond)
+		return NOTIFY_DONE;
+
+	if (ocelot_port->lag_tx_active == is_active)
+		return NOTIFY_DONE;
+
+	ocelot_port_lag_change(ocelot, port, is_active);
+
+	return NOTIFY_OK;
+}
+
 static int ocelot_netdevice_event(struct notifier_block *unused,
 				  unsigned long event, void *ptr)
 {
@@ -1181,6 +1202,15 @@ static int ocelot_netdevice_event(struct notifier_block *unused,
 
 		break;
 	}
+	case NETDEV_CHANGELOWERSTATE: {
+		struct netdev_notifier_changelowerstate_info *info = ptr;
+
+		if (!ocelot_netdevice_dev_check(dev))
+			break;
+
+		return ocelot_netdevice_changelowerstate(dev,
+							 info->lower_state_info);
+	}
 	default:
 		break;
 	}
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 089e552719e0..6e806872cd24 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -613,6 +613,7 @@ struct ocelot_port {
 	bool				is_dsa_8021q_cpu;
 
 	struct net_device		*bond;
+	bool				lag_tx_active;
 };
 
 struct ocelot {
-- 
2.25.1

