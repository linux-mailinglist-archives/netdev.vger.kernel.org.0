Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3FABAF5F43
	for <lists+netdev@lfdr.de>; Sat,  9 Nov 2019 14:03:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726405AbfKINDX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Nov 2019 08:03:23 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:39518 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726289AbfKINDX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Nov 2019 08:03:23 -0500
Received: by mail-wm1-f65.google.com with SMTP id t26so8887315wmi.4
        for <netdev@vger.kernel.org>; Sat, 09 Nov 2019 05:03:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=GT00wJBJ626KfE9Lm8MCr5EXLgOCnl2tAWyG9RqqqDg=;
        b=GjC+R0A4qP1tVwLc3PDjoAMTnixy+8i1dtiNRvMDNtER0ie7ImX/dUF+fdOZ/LOhJ3
         GSWTS38i18F1rN5+LOkWoOUvjCBNT5hwjZcSaPRoKCpOGjYW30GGhVFaG+L5BxFlYRpq
         zFw9EEcTD5NmZti4vNjVHq2qlHZhHD1kR99hw9CqjqdoZHfULJ885xdOlVNeh7RMhAEf
         ixVLMwXQBqMHMthBF79z6uVsoC1GF5Y+aYjiVCRp1P9n8cijibzXOK0C24ZbvjVt+MqV
         h/HNJvQgi3tJpIyH1nujSfMS1rC3kI2Lsxt2qRrhT0gJO/yufRC92Y8pmk45hVNR8gS4
         QvnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=GT00wJBJ626KfE9Lm8MCr5EXLgOCnl2tAWyG9RqqqDg=;
        b=aMCtfp68e4XSAxbklqp2KkxO3DhvdkTF10yb72u2BzKpRI9oWB31/RQvDtU2ZePoDm
         ZT8YASgmN3Gt3DDg4keyv4WsIh/5GVgKIzkNlXkA/3YZ87wsBIh3takm2xd8DyR38Se7
         CqZgDPUSKNFkxWY/oFJg1oIeDucof5xB/rp8gLV6ws2w7vck1lsBVFKqzbNL9BelTceb
         9bAxkHoPfT38VUPTuRhmMNcYUGwUTXoRqAj2ya1Z5akaaHpAcKswEokBha/uSA0ZZ/uX
         L899ygpCSVRhFUpA/GOC0v7HhwuiEu5H2otyKMjFCb4YJiDw7fEVRFjBG7vN9w67QeLR
         WfxQ==
X-Gm-Message-State: APjAAAVPEBfSUA2RlZraKQ+hpzxUFdg+W3nmu1NeHLvegTY7hDOiUuke
        jnOr3DJsNQXup1O/tA0D4gM=
X-Google-Smtp-Source: APXvYqyBPDNZD2MMQ+8w80hZExnRRVAoDZWW1VstMff8twuv8Kvr9i2UZjcsQlu/iyoGe7Tx2uHCwQ==
X-Received: by 2002:a1c:2e09:: with SMTP id u9mr12432575wmu.108.1573304600473;
        Sat, 09 Nov 2019 05:03:20 -0800 (PST)
Received: from localhost.localdomain ([86.121.29.241])
        by smtp.gmail.com with ESMTPSA id n13sm8370908wmi.25.2019.11.09.05.03.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Nov 2019 05:03:19 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     jakub.kicinski@netronome.com, davem@davemloft.net,
        alexandre.belloni@bootlin.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        joergen.andreasen@microchip.com, allan.nielsen@microchip.com,
        horatiu.vultur@microchip.com, claudiu.manoil@nxp.com,
        netdev@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next 01/15] net: mscc: ocelot: break apart ocelot_vlan_port_apply
Date:   Sat,  9 Nov 2019 15:02:47 +0200
Message-Id: <20191109130301.13716-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191109130301.13716-1-olteanv@gmail.com>
References: <20191109130301.13716-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

This patch transforms the ocelot_vlan_port_apply function ("apply
what?") into 3 standalone functions:

- ocelot_port_vlan_filtering
- ocelot_port_set_native_vlan
- ocelot_port_set_pvid

These functions have a prototype that is better aligned to the DSA API.

The function also had some static initialization (TPID, drop frames with
multicast source MAC) which was not being changed from any place, so
that was just moved to ocelot_probe_port (one of the 6 callers of
ocelot_vlan_port_apply).

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot.c | 168 +++++++++++++++++------------
 1 file changed, 100 insertions(+), 68 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 672ea1342add..029c5ea59e35 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -185,65 +185,97 @@ static void ocelot_vlan_mode(struct ocelot_port *port,
 	ocelot_write(ocelot, val, ANA_VLANMASK);
 }
 
-static void ocelot_vlan_port_apply(struct ocelot *ocelot,
-				   struct ocelot_port *port)
+static void ocelot_port_vlan_filtering(struct ocelot *ocelot, int port,
+				       bool vlan_aware)
 {
+	struct ocelot_port *ocelot_port = ocelot->ports[port];
 	u32 val;
 
-	/* Ingress clasification (ANA_PORT_VLAN_CFG) */
-	/* Default vlan to clasify for untagged frames (may be zero) */
-	val = ANA_PORT_VLAN_CFG_VLAN_VID(port->pvid);
-	if (port->vlan_aware)
-		val |= ANA_PORT_VLAN_CFG_VLAN_AWARE_ENA |
-		       ANA_PORT_VLAN_CFG_VLAN_POP_CNT(1);
-
+	if (vlan_aware)
+		val = ANA_PORT_VLAN_CFG_VLAN_AWARE_ENA |
+		      ANA_PORT_VLAN_CFG_VLAN_POP_CNT(1);
+	else
+		val = 0;
 	ocelot_rmw_gix(ocelot, val,
-		       ANA_PORT_VLAN_CFG_VLAN_VID_M |
 		       ANA_PORT_VLAN_CFG_VLAN_AWARE_ENA |
 		       ANA_PORT_VLAN_CFG_VLAN_POP_CNT_M,
-		       ANA_PORT_VLAN_CFG, port->chip_port);
+		       ANA_PORT_VLAN_CFG, port);
 
-	/* Drop frames with multicast source address */
-	val = ANA_PORT_DROP_CFG_DROP_MC_SMAC_ENA;
-	if (port->vlan_aware && !port->vid)
+	if (vlan_aware && !ocelot_port->vid)
 		/* If port is vlan-aware and tagged, drop untagged and priority
 		 * tagged frames.
 		 */
-		val |= ANA_PORT_DROP_CFG_DROP_UNTAGGED_ENA |
+		val = ANA_PORT_DROP_CFG_DROP_UNTAGGED_ENA |
+		      ANA_PORT_DROP_CFG_DROP_PRIO_S_TAGGED_ENA |
+		      ANA_PORT_DROP_CFG_DROP_PRIO_C_TAGGED_ENA;
+	else
+		val = 0;
+	ocelot_rmw_gix(ocelot, val,
+		       ANA_PORT_DROP_CFG_DROP_UNTAGGED_ENA |
 		       ANA_PORT_DROP_CFG_DROP_PRIO_S_TAGGED_ENA |
-		       ANA_PORT_DROP_CFG_DROP_PRIO_C_TAGGED_ENA;
-	ocelot_write_gix(ocelot, val, ANA_PORT_DROP_CFG, port->chip_port);
-
-	/* Egress configuration (REW_TAG_CFG): VLAN tag type to 8021Q. */
-	val = REW_TAG_CFG_TAG_TPID_CFG(0);
+		       ANA_PORT_DROP_CFG_DROP_PRIO_C_TAGGED_ENA,
+		       ANA_PORT_DROP_CFG, port);
 
-	if (port->vlan_aware) {
-		if (port->vid)
+	if (vlan_aware) {
+		if (ocelot_port->vid)
 			/* Tag all frames except when VID == DEFAULT_VLAN */
 			val |= REW_TAG_CFG_TAG_CFG(1);
 		else
 			/* Tag all frames */
 			val |= REW_TAG_CFG_TAG_CFG(3);
+	} else {
+		/* Port tagging disabled. */
+		val = REW_TAG_CFG_TAG_CFG(0);
 	}
 	ocelot_rmw_gix(ocelot, val,
-		       REW_TAG_CFG_TAG_TPID_CFG_M |
 		       REW_TAG_CFG_TAG_CFG_M,
-		       REW_TAG_CFG, port->chip_port);
+		       REW_TAG_CFG, port);
 
-	/* Set default VLAN and tag type to 8021Q. */
-	val = REW_PORT_VLAN_CFG_PORT_TPID(ETH_P_8021Q) |
-	      REW_PORT_VLAN_CFG_PORT_VID(port->vid);
-	ocelot_rmw_gix(ocelot, val,
-		       REW_PORT_VLAN_CFG_PORT_TPID_M |
+	ocelot_port->vlan_aware = vlan_aware;
+}
+
+static int ocelot_port_set_native_vlan(struct ocelot *ocelot, int port,
+				       u16 vid)
+{
+	struct ocelot_port *ocelot_port = ocelot->ports[port];
+
+	if (ocelot_port->vid != vid) {
+		/* Always permit deleting the native VLAN (vid = 0) */
+		if (ocelot_port->vid && vid) {
+			dev_err(ocelot->dev,
+				"Port already has a native VLAN: %d\n",
+				ocelot_port->vid);
+			return -EBUSY;
+		}
+		ocelot_port->vid = vid;
+	}
+
+	ocelot_rmw_gix(ocelot, REW_PORT_VLAN_CFG_PORT_VID(vid),
 		       REW_PORT_VLAN_CFG_PORT_VID_M,
-		       REW_PORT_VLAN_CFG, port->chip_port);
+		       REW_PORT_VLAN_CFG, port);
+
+	return 0;
+}
+
+/* Default vlan to clasify for untagged frames (may be zero) */
+static void ocelot_port_set_pvid(struct ocelot *ocelot, int port, u16 pvid)
+{
+	struct ocelot_port *ocelot_port = ocelot->ports[port];
+
+	ocelot_rmw_gix(ocelot,
+		       ANA_PORT_VLAN_CFG_VLAN_VID(pvid),
+		       ANA_PORT_VLAN_CFG_VLAN_VID_M,
+		       ANA_PORT_VLAN_CFG, port);
+
+	ocelot_port->pvid = pvid;
 }
 
 static int ocelot_vlan_vid_add(struct net_device *dev, u16 vid, bool pvid,
 			       bool untagged)
 {
-	struct ocelot_port *port = netdev_priv(dev);
-	struct ocelot *ocelot = port->ocelot;
+	struct ocelot_port *ocelot_port = netdev_priv(dev);
+	struct ocelot *ocelot = ocelot_port->ocelot;
+	int port = ocelot_port->chip_port;
 	int ret;
 
 	/* Add the port MAC address to with the right VLAN information */
@@ -251,35 +283,30 @@ static int ocelot_vlan_vid_add(struct net_device *dev, u16 vid, bool pvid,
 			  ENTRYTYPE_LOCKED);
 
 	/* Make the port a member of the VLAN */
-	ocelot->vlan_mask[vid] |= BIT(port->chip_port);
+	ocelot->vlan_mask[vid] |= BIT(port);
 	ret = ocelot_vlant_set_mask(ocelot, vid, ocelot->vlan_mask[vid]);
 	if (ret)
 		return ret;
 
 	/* Default ingress vlan classification */
 	if (pvid)
-		port->pvid = vid;
+		ocelot_port_set_pvid(ocelot, port, vid);
 
 	/* Untagged egress vlan clasification */
-	if (untagged && port->vid != vid) {
-		if (port->vid) {
-			dev_err(ocelot->dev,
-				"Port already has a native VLAN: %d\n",
-				port->vid);
-			return -EBUSY;
-		}
-		port->vid = vid;
+	if (untagged) {
+		ret = ocelot_port_set_native_vlan(ocelot, port, vid);
+		if (ret)
+			return ret;
 	}
 
-	ocelot_vlan_port_apply(ocelot, port);
-
 	return 0;
 }
 
 static int ocelot_vlan_vid_del(struct net_device *dev, u16 vid)
 {
-	struct ocelot_port *port = netdev_priv(dev);
-	struct ocelot *ocelot = port->ocelot;
+	struct ocelot_port *ocelot_port = netdev_priv(dev);
+	struct ocelot *ocelot = ocelot_port->ocelot;
+	int port = ocelot_port->chip_port;
 	int ret;
 
 	/* 8021q removes VID 0 on module unload for all interfaces
@@ -293,20 +320,18 @@ static int ocelot_vlan_vid_del(struct net_device *dev, u16 vid)
 	ocelot_mact_forget(ocelot, dev->dev_addr, vid);
 
 	/* Stop the port from being a member of the vlan */
-	ocelot->vlan_mask[vid] &= ~BIT(port->chip_port);
+	ocelot->vlan_mask[vid] &= ~BIT(port);
 	ret = ocelot_vlant_set_mask(ocelot, vid, ocelot->vlan_mask[vid]);
 	if (ret)
 		return ret;
 
 	/* Ingress */
-	if (port->pvid == vid)
-		port->pvid = 0;
+	if (ocelot_port->pvid == vid)
+		ocelot_port_set_pvid(ocelot, port, 0);
 
 	/* Egress */
-	if (port->vid == vid)
-		port->vid = 0;
-
-	ocelot_vlan_port_apply(ocelot, port);
+	if (ocelot_port->vid == vid)
+		ocelot_port_set_native_vlan(ocelot, port, 0);
 
 	return 0;
 }
@@ -1306,6 +1331,7 @@ static int ocelot_port_attr_set(struct net_device *dev,
 				struct switchdev_trans *trans)
 {
 	struct ocelot_port *ocelot_port = netdev_priv(dev);
+	struct ocelot *ocelot = ocelot_port->ocelot;
 	int err = 0;
 
 	switch (attr->id) {
@@ -1317,8 +1343,8 @@ static int ocelot_port_attr_set(struct net_device *dev,
 		ocelot_port_attr_ageing_set(ocelot_port, attr->u.ageing_time);
 		break;
 	case SWITCHDEV_ATTR_ID_BRIDGE_VLAN_FILTERING:
-		ocelot_port->vlan_aware = attr->u.vlan_filtering;
-		ocelot_vlan_port_apply(ocelot_port->ocelot, ocelot_port);
+		ocelot_port_vlan_filtering(ocelot, ocelot_port->chip_port,
+					   attr->u.vlan_filtering);
 		break;
 	case SWITCHDEV_ATTR_ID_BRIDGE_MC_DISABLED:
 		ocelot_port_attr_mc_set(ocelot_port, !attr->u.mc_disabled);
@@ -1520,20 +1546,20 @@ static int ocelot_port_bridge_join(struct ocelot_port *ocelot_port,
 	return 0;
 }
 
-static void ocelot_port_bridge_leave(struct ocelot_port *ocelot_port,
-				     struct net_device *bridge)
+static int ocelot_port_bridge_leave(struct ocelot_port *ocelot_port,
+				    struct net_device *bridge)
 {
 	struct ocelot *ocelot = ocelot_port->ocelot;
+	int port = ocelot_port->chip_port;
 
-	ocelot->bridge_mask &= ~BIT(ocelot_port->chip_port);
+	ocelot->bridge_mask &= ~BIT(port);
 
 	if (!ocelot->bridge_mask)
 		ocelot->hw_bridge_dev = NULL;
 
-	/* Clear bridge vlan settings before calling ocelot_vlan_port_apply */
-	ocelot_port->vlan_aware = 0;
-	ocelot_port->pvid = 0;
-	ocelot_port->vid = 0;
+	ocelot_port_vlan_filtering(ocelot, port, 0);
+	ocelot_port_set_pvid(ocelot, port, 0);
+	return ocelot_port_set_native_vlan(ocelot, port, 0);
 }
 
 static void ocelot_set_aggr_pgids(struct ocelot *ocelot)
@@ -1687,11 +1713,8 @@ static int ocelot_netdevice_port_event(struct net_device *dev,
 				err = ocelot_port_bridge_join(ocelot_port,
 							      info->upper_dev);
 			else
-				ocelot_port_bridge_leave(ocelot_port,
-							 info->upper_dev);
-
-			ocelot_vlan_port_apply(ocelot_port->ocelot,
-					       ocelot_port);
+				err = ocelot_port_bridge_leave(ocelot_port,
+							       info->upper_dev);
 		}
 		if (netif_is_lag_master(info->upper_dev)) {
 			if (info->linking)
@@ -2007,6 +2030,7 @@ int ocelot_probe_port(struct ocelot *ocelot, u8 port,
 {
 	struct ocelot_port *ocelot_port;
 	struct net_device *dev;
+	u32 val;
 	int err;
 
 	dev = alloc_etherdev(sizeof(struct ocelot_port));
@@ -2042,7 +2066,15 @@ int ocelot_probe_port(struct ocelot *ocelot, u8 port,
 	}
 
 	/* Basic L2 initialization */
-	ocelot_vlan_port_apply(ocelot, ocelot_port);
+
+	/* Drop frames with multicast source address */
+	val = ANA_PORT_DROP_CFG_DROP_MC_SMAC_ENA;
+	ocelot_rmw_gix(ocelot, val, val, ANA_PORT_DROP_CFG, port);
+
+	/* Set default VLAN and tag type to 8021Q. */
+	ocelot_rmw_gix(ocelot, REW_PORT_VLAN_CFG_PORT_TPID(ETH_P_8021Q),
+		       REW_PORT_VLAN_CFG_PORT_TPID_M,
+		       REW_PORT_VLAN_CFG, port);
 
 	/* Enable vcap lookups */
 	ocelot_vcap_enable(ocelot, ocelot_port);
-- 
2.17.1

