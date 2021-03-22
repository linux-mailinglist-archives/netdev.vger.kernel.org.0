Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B6E634514B
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 22:00:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231160AbhCVVAS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 17:00:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230274AbhCVU72 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 16:59:28 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01118C061756
        for <netdev@vger.kernel.org>; Mon, 22 Mar 2021 13:59:28 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id e14so5352484ejz.11
        for <netdev@vger.kernel.org>; Mon, 22 Mar 2021 13:59:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+qkY7r0ZE2yJZqukhmqaqDgUB9c+oVFs+zy9IRdKvxM=;
        b=rpYGnu87i4JNbjvTqxZsBtedI0b2BDCya6MhnHM0/IkTt6DIzEf97FSvWl0s4oiUZ6
         DwNbjy7f1WN+mgbFq0oAM/B+8gkBmRRhvicOxV8/X41v7vzfilC5I6KmOrfWZpm3LGOa
         PduMChWryOJJlygOZliTfZAXkKbeTEQ5jgtU2zoauoa3uXLgF+SSPk1F10EEfIv8A7WA
         S/aPeKH0xfn3D06DfxFf+R5+VQgrpkeqVJcRuZqAGeDv2irLoH9DJwupcOTHc6maPUaD
         FLTqKtUTv2hDyZnWCVevc8fa2f2apOS0f22anzDVuiZeEzW9lhPsXZwp3ezdbfa+EDQK
         bNqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+qkY7r0ZE2yJZqukhmqaqDgUB9c+oVFs+zy9IRdKvxM=;
        b=SbfCGsu8c/Xnm7V9QBj7hRZ4wZiotaBiTysrLa+6t4/+fN4Y0r8klOUngbpalU9VWF
         jfT+owYX7Ho7AR4BbNsQsRfr3SWhF25b4WPCosYpniyC0X0aeeKgv7kyuZLUrV0uRq7d
         BBMcfJ8Ezd6CHckUZglfFPKzA3FL3IP3Np8Oa2ugkDd36+kk6Aw52W8cK8pYvWlZvcDM
         xUCcKd1mGnGReJGTZZjBXYSBjEKV2/hY57dWzWc0uiOBO2xQM7DrSchyyLPG8aV8lA43
         FaiIMF7+hC3pB/GAERERVV4em8aXbubM7SRMcJ3NZWyk7kiRVeo9tRODmRZYWdYWamyu
         0CMA==
X-Gm-Message-State: AOAM530ZNJoZ0k+YBl+ZclHbXglsSr/zigv87of0IL0cmXK6lb+JYipB
        /aMgT3w+QYtRtvFWeWCTkro=
X-Google-Smtp-Source: ABdhPJw+wSX6ZXrnvr2g8LcBbuGo7IEk3Y7DSFapMjkLjF5PRpolRD1ZTGOq+LqHQeljhSuXS/aljA==
X-Received: by 2002:a17:906:7946:: with SMTP id l6mr1594690ejo.500.1616446766740;
        Mon, 22 Mar 2021 13:59:26 -0700 (PDT)
Received: from yoga-910.localhost (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id v25sm11621074edr.18.2021.03.22.13.59.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Mar 2021 13:59:26 -0700 (PDT)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, olteanv@gmail.com,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next 4/6] dpaa2-switch: add support for configuring per port broadcast flooding
Date:   Mon, 22 Mar 2021 22:58:57 +0200
Message-Id: <20210322205859.606704-5-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210322205859.606704-1-ciorneiioana@gmail.com>
References: <20210322205859.606704-1-ciorneiioana@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Ciornei <ioana.ciornei@nxp.com>

The BR_BCAST_FLOOD bridge port flag is now accepted by the driver and a
change in its state will determine a reconfiguration of the broadcast
egress flooding list on the FDB associated with the port.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 .../ethernet/freescale/dpaa2/dpaa2-switch.c   | 32 +++++++++++++++++--
 .../ethernet/freescale/dpaa2/dpaa2-switch.h   |  2 +-
 2 files changed, 31 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
index 2ea3a4dac49d..2ae4faf81b1f 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
@@ -127,7 +127,10 @@ static void dpaa2_switch_fdb_get_flood_cfg(struct ethsw_core *ethsw, u16 fdb_id,
 		if (ethsw->ports[j]->fdb->fdb_id != fdb_id)
 			continue;
 
-		cfg->if_id[i++] = ethsw->ports[j]->idx;
+		if (type == DPSW_BROADCAST && ethsw->ports[j]->bcast_flood)
+			cfg->if_id[i++] = ethsw->ports[j]->idx;
+		else if (type == DPSW_FLOODING)
+			cfg->if_id[i++] = ethsw->ports[j]->idx;
 	}
 
 	/* Add the CTRL interface to the egress flooding domain */
@@ -1260,11 +1263,22 @@ static int dpaa2_switch_port_set_learning(struct ethsw_port_priv *port_priv, boo
 	return err;
 }
 
+static int dpaa2_switch_port_flood(struct ethsw_port_priv *port_priv,
+				   struct switchdev_brport_flags flags)
+{
+	struct ethsw_core *ethsw = port_priv->ethsw_data;
+
+	if (flags.mask & BR_BCAST_FLOOD)
+		port_priv->bcast_flood = !!(flags.val & BR_BCAST_FLOOD);
+
+	return dpaa2_switch_fdb_set_egress_flood(ethsw, port_priv->fdb->fdb_id);
+}
+
 static int dpaa2_switch_port_pre_bridge_flags(struct net_device *netdev,
 					      struct switchdev_brport_flags flags,
 					      struct netlink_ext_ack *extack)
 {
-	if (flags.mask & ~(BR_LEARNING))
+	if (flags.mask & ~(BR_LEARNING | BR_BCAST_FLOOD))
 		return -EINVAL;
 
 	return 0;
@@ -1285,6 +1299,12 @@ static int dpaa2_switch_port_bridge_flags(struct net_device *netdev,
 			return err;
 	}
 
+	if (flags.mask & BR_BCAST_FLOOD) {
+		err = dpaa2_switch_port_flood(port_priv, flags);
+		if (err)
+			return err;
+	}
+
 	return 0;
 }
 
@@ -1643,6 +1663,12 @@ static int dpaa2_switch_port_bridge_leave(struct net_device *netdev)
 	if (err)
 		netdev_err(netdev, "Unable to restore RX VLANs to the new FDB, err (%d)\n", err);
 
+	/* Reset the flooding state to denote that this port can send any
+	 * packet in standalone mode. With this, we are also ensuring that any
+	 * later bridge join will have the flooding flag on.
+	 */
+	port_priv->bcast_flood = true;
+
 	/* Setup the egress flood policy (broadcast, unknown unicast).
 	 * When the port is not under a bridge, only the CTRL interface is part
 	 * of the flooding domain besides the actual port
@@ -2728,6 +2754,8 @@ static int dpaa2_switch_probe_port(struct ethsw_core *ethsw,
 
 	port_netdev->needed_headroom = DPAA2_SWITCH_NEEDED_HEADROOM;
 
+	port_priv->bcast_flood = true;
+
 	/* Set MTU limits */
 	port_netdev->min_mtu = ETH_MIN_MTU;
 	port_netdev->max_mtu = ETHSW_MAX_FRAME_LENGTH;
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.h b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.h
index 933563064015..65ede6036870 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.h
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.h
@@ -105,13 +105,13 @@ struct ethsw_port_priv {
 	struct ethsw_core	*ethsw_data;
 	u8			link_state;
 	u8			stp_state;
-	bool			flood;
 
 	u8			vlans[VLAN_VID_MASK + 1];
 	u16			pvid;
 	u16			tx_qdid;
 
 	struct dpaa2_switch_fdb	*fdb;
+	bool			bcast_flood;
 };
 
 /* Switch data */
-- 
2.30.0

