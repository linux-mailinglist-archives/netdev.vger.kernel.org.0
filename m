Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 699D334111F
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 00:37:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233313AbhCRXhJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 19:37:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232321AbhCRXgx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 19:36:53 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA3A8C06174A
        for <netdev@vger.kernel.org>; Thu, 18 Mar 2021 16:36:52 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id k10so6693186ejg.0
        for <netdev@vger.kernel.org>; Thu, 18 Mar 2021 16:36:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EO1Cjy0mGqMKjpmJvRzT15b9BU2cZE1GVQLDWVI1ZIE=;
        b=KYtifb+y4FhK8MAAnTUWXTwhLzQ6j4v1YB0yOM2xnSohrjCPIoPET69akbDyXojF1K
         98hG3jMvGS08zK3zksLxmZtxY+nsrwdvktYU9+LjaX0pIbtk23HcVNpwsXps6NCNK3cn
         E7fJFAARpQ6RfOwbVb4H/OJM6q4aXbmiFz07HO4C3o4+FxQtnAbS6hUWKVxkv9ojDBRf
         uR0EyEtppeBSPbQc0JOnqBj/7sgyu4HwvXIoCEkUfEfU9gId1Mqnaj3CmttFVofGw1mt
         LhIuWs0XIV/pOxD1xdNXeR5Ig6Ypm84Iw2WzScb+B9PMf8eJ5amW6y35+UBuu7Ouymf8
         WGtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EO1Cjy0mGqMKjpmJvRzT15b9BU2cZE1GVQLDWVI1ZIE=;
        b=Oqhu4SV/R02jYxf/KbeEOsU/hwg56ylMyJXa/7aLqTQZXfZipmrJU5WKDKQPVqPkdc
         hq7iQVS9A0iGoLNKZfECOdrldAUxVEhOWWtVSddglqSIlLTrFSuVejbV/TswByDSgwUG
         2S6z4Zr2yKKs1CF5ZuXtURZkfG7XvqumeyR5bA7LLJwDtAk/RMOsG09BszoWY+5jpac5
         0fogWTnsvU/NBoolXlaQiP3sUHUBFFY32GeCG+sQK67ohT9mWfV5hT9+LPsRdkfstmey
         VzIZQx+1Hbt2gich1YkvlG/3x5qOkOd/83YKf4NKiofNOSAs0WgwHQ0h5Aq36E07XInh
         aSDQ==
X-Gm-Message-State: AOAM5337iptcWct+40XYFXQ0L5G0LY0QDMQD8d2YK4sPA6URJynYs6Ho
        tBROAWzNw7dzLOnPtjQ8FUY=
X-Google-Smtp-Source: ABdhPJwwq0j3uaDdy7eBv1eW8YmzfrkmY4wErjjBqPeXkdJIjT6UzTEASSGCjn93wurWa5N+aS/G0g==
X-Received: by 2002:a17:906:7389:: with SMTP id f9mr1133369ejl.423.1616110611734;
        Thu, 18 Mar 2021 16:36:51 -0700 (PDT)
Received: from localhost.localdomain (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id e4sm2767480ejz.4.2021.03.18.16.36.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Mar 2021 16:36:51 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        UNGLinuxDriver@microchip.com,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next] net: ocelot: support multiple bridges
Date:   Fri, 19 Mar 2021 01:36:36 +0200
Message-Id: <20210318233636.3901069-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

The ocelot switches are a bit odd in that they do not have an STP state
to put the ports into. Instead, the forwarding configuration is delayed
from the typical port_bridge_join into stp_state_set, when the port enters
the BR_STATE_FORWARDING state.

I can only guess that the implementation of this quirk is the reason that
led to the simplification of the driver such that only one bridge could
be offloaded at a time.

We can simplify the data structures somewhat, and introduce a per-port
bridge device pointer and STP state, similar to how the LAG offload
works now (there we have a per-port bonding device pointer and TX
enabled state). This allows offloading multiple bridges with relative
ease, while still keeping in place the quirk to delay the programming of
the PGIDs.

We actually need this change now because we need to remove the bogus
restriction from ocelot_bridge_stp_state_set that ocelot->bridge_mask
needs to contain BIT(port), otherwise that function is a no-op.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
This patch is split from the larger RFC series at:
https://lore.kernel.org/netdev/20210318231829.3892920-12-olteanv@gmail.com/T/#u
because I figured I could submit it separately and reduce the patch
count there to 15.

 drivers/net/ethernet/mscc/ocelot.c | 72 +++++++++++++++---------------
 include/soc/mscc/ocelot.h          |  7 ++-
 2 files changed, 39 insertions(+), 40 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 9f0c9bdd9f5d..ce57929ba3d1 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -766,7 +766,7 @@ int ocelot_xtr_poll_frame(struct ocelot *ocelot, int grp, struct sk_buff **nskb)
 	/* Everything we see on an interface that is in the HW bridge
 	 * has already been forwarded.
 	 */
-	if (ocelot->bridge_mask & BIT(src_port))
+	if (ocelot->ports[src_port]->bridge)
 		skb->offload_fwd_mark = 1;
 
 	skb->protocol = eth_type_trans(skb, dev);
@@ -1183,6 +1183,26 @@ static u32 ocelot_get_bond_mask(struct ocelot *ocelot, struct net_device *bond,
 	return mask;
 }
 
+static u32 ocelot_get_bridge_fwd_mask(struct ocelot *ocelot,
+				      struct net_device *bridge)
+{
+	u32 mask = 0;
+	int port;
+
+	for (port = 0; port < ocelot->num_phys_ports; port++) {
+		struct ocelot_port *ocelot_port = ocelot->ports[port];
+
+		if (!ocelot_port)
+			continue;
+
+		if (ocelot_port->stp_state == BR_STATE_FORWARDING &&
+		    ocelot_port->bridge == bridge)
+			mask |= BIT(port);
+	}
+
+	return mask;
+}
+
 static u32 ocelot_get_dsa_8021q_cpu_mask(struct ocelot *ocelot)
 {
 	u32 mask = 0;
@@ -1232,10 +1252,12 @@ void ocelot_apply_bridge_fwd_mask(struct ocelot *ocelot)
 			 */
 			mask = GENMASK(ocelot->num_phys_ports - 1, 0);
 			mask &= ~cpu_fwd_mask;
-		} else if (ocelot->bridge_fwd_mask & BIT(port)) {
+		} else if (ocelot_port->bridge) {
+			struct net_device *bridge = ocelot_port->bridge;
 			struct net_device *bond = ocelot_port->bond;
 
-			mask = ocelot->bridge_fwd_mask & ~BIT(port);
+			mask = ocelot_get_bridge_fwd_mask(ocelot, bridge);
+			mask &= ~BIT(port);
 			if (bond) {
 				mask &= ~ocelot_get_bond_mask(ocelot, bond,
 							      false);
@@ -1256,29 +1278,16 @@ EXPORT_SYMBOL(ocelot_apply_bridge_fwd_mask);
 void ocelot_bridge_stp_state_set(struct ocelot *ocelot, int port, u8 state)
 {
 	struct ocelot_port *ocelot_port = ocelot->ports[port];
-	u32 port_cfg;
-
-	if (!(BIT(port) & ocelot->bridge_mask))
-		return;
+	u32 learn_ena = 0;
 
-	port_cfg = ocelot_read_gix(ocelot, ANA_PORT_PORT_CFG, port);
+	ocelot_port->stp_state = state;
 
-	switch (state) {
-	case BR_STATE_FORWARDING:
-		ocelot->bridge_fwd_mask |= BIT(port);
-		fallthrough;
-	case BR_STATE_LEARNING:
-		if (ocelot_port->learn_ena)
-			port_cfg |= ANA_PORT_PORT_CFG_LEARN_ENA;
-		break;
-
-	default:
-		port_cfg &= ~ANA_PORT_PORT_CFG_LEARN_ENA;
-		ocelot->bridge_fwd_mask &= ~BIT(port);
-		break;
-	}
+	if ((state == BR_STATE_LEARNING || state == BR_STATE_FORWARDING) &&
+	    ocelot_port->learn_ena)
+		learn_ena = ANA_PORT_PORT_CFG_LEARN_ENA;
 
-	ocelot_write_gix(ocelot, port_cfg, ANA_PORT_PORT_CFG, port);
+	ocelot_rmw_gix(ocelot, learn_ena, ANA_PORT_PORT_CFG_LEARN_ENA,
+		       ANA_PORT_PORT_CFG, port);
 
 	ocelot_apply_bridge_fwd_mask(ocelot);
 }
@@ -1508,16 +1517,9 @@ EXPORT_SYMBOL(ocelot_port_mdb_del);
 int ocelot_port_bridge_join(struct ocelot *ocelot, int port,
 			    struct net_device *bridge)
 {
-	if (!ocelot->bridge_mask) {
-		ocelot->hw_bridge_dev = bridge;
-	} else {
-		if (ocelot->hw_bridge_dev != bridge)
-			/* This is adding the port to a second bridge, this is
-			 * unsupported */
-			return -ENODEV;
-	}
+	struct ocelot_port *ocelot_port = ocelot->ports[port];
 
-	ocelot->bridge_mask |= BIT(port);
+	ocelot_port->bridge = bridge;
 
 	return 0;
 }
@@ -1526,13 +1528,11 @@ EXPORT_SYMBOL(ocelot_port_bridge_join);
 int ocelot_port_bridge_leave(struct ocelot *ocelot, int port,
 			     struct net_device *bridge)
 {
+	struct ocelot_port *ocelot_port = ocelot->ports[port];
 	struct ocelot_vlan pvid = {0}, native_vlan = {0};
 	int ret;
 
-	ocelot->bridge_mask &= ~BIT(port);
-
-	if (!ocelot->bridge_mask)
-		ocelot->hw_bridge_dev = NULL;
+	ocelot_port->bridge = NULL;
 
 	ret = ocelot_port_vlan_filtering(ocelot, port, false);
 	if (ret)
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 0a0751bf97dd..ce7e5c1bd90d 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -615,6 +615,9 @@ struct ocelot_port {
 	bool				lag_tx_active;
 
 	u16				mrp_ring_id;
+
+	struct net_device		*bridge;
+	u8				stp_state;
 };
 
 struct ocelot {
@@ -634,10 +637,6 @@ struct ocelot {
 	int				num_frame_refs;
 	int				num_mact_rows;
 
-	struct net_device		*hw_bridge_dev;
-	u16				bridge_mask;
-	u16				bridge_fwd_mask;
-
 	struct ocelot_port		**ports;
 
 	u8				base_mac[ETH_ALEN];
-- 
2.25.1

