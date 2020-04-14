Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BA1B1A8B00
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 21:38:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504925AbgDNTgc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 15:36:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2504805AbgDNTga (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Apr 2020 15:36:30 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B139EC061A10
        for <netdev@vger.kernel.org>; Tue, 14 Apr 2020 12:36:28 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id k11so15277155wrp.5
        for <netdev@vger.kernel.org>; Tue, 14 Apr 2020 12:36:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=AJXJ+qdHc9HjPsnVFQidvTkknobYKZvliAZvbydsl2s=;
        b=Q4ch+KtHsWcd6pavAXHnLpsh7MuZMPIZ7ceY0qOK/A6WN/esQGhxGn5GwwKyCePhpQ
         13TTTKd3BA28MeAp50rK00F9IbnPC/0w7hjuN3y/0yvhAuAEiyW+tu1NnoQQ/NItuHQX
         PeDkItViJP/j7Fd0mRadiWEOLjiyiee8skSHkXU9RcpLFUXXG5s21B7pKp7/wyfHgiya
         Ag0eYyPZ+olj7YfT2Q8bKBDoGwur+tRcLux8XOE07KGR9/bllZF6xZKmvNFFRIPs24CN
         Z0Sfl78kaSgZ0FYyC48eln9WL8iRnQXYrjIjOrQFx8JICO85RKY1xQ30zFNVWA1tNN7v
         qH5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=AJXJ+qdHc9HjPsnVFQidvTkknobYKZvliAZvbydsl2s=;
        b=qactcW6R9RDf8jQCUl92NHQnY0bINWAE5ZHdsKLurLbhc7E2WezVejE6T02IFdKubE
         j/amt3voOjZJ3mRx1OxxbqdzKLFgYN66jj8da06HABPyOb43OlkQN4qhb8MTG95xeL6W
         dNbbkEsZJgXECx4aEm2QYgpyDV/3oLmH4n5DRJo4W675jayK2AYhVJ5OdQByZksAUsGM
         IFMQQ1y6KJoN7HJH8dDBHGkUju31yqA+rseeYPE4XjAAmoUHGbfCgKA3mk1MN6EO+XTY
         evxSxzEd1LQO5Ml/U47MDYFB8eCzdn+0dXjZl0NA7d2s1O8r/buogm28Y+AAvXSJo8G9
         cMPA==
X-Gm-Message-State: AGi0PuZzzZRD+GFGec+KFMnpnsdoBXqBqG3LNb0CKHrCN7J6rW9BNYJb
        UXbtvZZyKht31aEkn2gAC4w=
X-Google-Smtp-Source: APiQypIqyL7RSzF4Muoos7kXXOPpqD128t7hZVjbvpC2qe0GDXJ5qBq9u7mrd8UTlc6LVZyr0N7D/A==
X-Received: by 2002:adf:f30c:: with SMTP id i12mr7217296wro.426.1586892987289;
        Tue, 14 Apr 2020 12:36:27 -0700 (PDT)
Received: from localhost.localdomain ([188.25.102.96])
        by smtp.gmail.com with ESMTPSA id d7sm20273475wrr.77.2020.04.14.12.36.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Apr 2020 12:36:26 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net
Cc:     horatiu.vultur@microchip.com, alexandre.belloni@bootlin.com,
        antoine.tenart@bootlin.com, andrew@lunn.ch, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, joergen.andreasen@microchip.com,
        allan.nielsen@microchip.com, claudiu.manoil@nxp.com,
        netdev@vger.kernel.org, UNGLinuxDriver@microchip.com,
        alexandru.marginean@nxp.com, xiaoliang.yang_1@nxp.com,
        yangbo.lu@nxp.com, po.liu@nxp.com, jiri@mellanox.com,
        idosch@idosch.org, kuba@kernel.org
Subject: [PATCH net] net: mscc: ocelot: fix untagged packet drops when enslaving to vlan aware bridge
Date:   Tue, 14 Apr 2020 22:36:15 +0300
Message-Id: <20200414193615.29506-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

To rehash a previous explanation given in commit 1c44ce560b4d ("net:
mscc: ocelot: fix vlan_filtering when enslaving to bridge before link is
up"), the switch driver operates the in a mode where a single VLAN can
be transmitted as untagged on a particular egress port. That is the
"native VLAN on trunk port" use case.

The configuration for this native VLAN is driven in 2 ways:
 - Set the egress port rewriter to strip the VLAN tag for the native
   VID (as it is egress-untagged, after all).
 - Configure the ingress port to drop untagged and priority-tagged
   traffic, if there is no native VLAN. The intention of this setting is
   that a trunk port with no native VLAN should not accept untagged
   traffic.

Since both of the above configurations for the native VLAN should only
be done if VLAN awareness is requested, they are actually done from the
ocelot_port_vlan_filtering function, after the basic procedure of
toggling the VLAN awareness flag of the port.

But there's a problem with that simplistic approach: we are trying to
juggle with 2 independent variables from a single function:
 - Native VLAN of the port - its value is held in port->vid.
 - VLAN awareness state of the port - currently there are some issues
   here, more on that later*.
The actual problem can be seen when enslaving the switch ports to a VLAN
filtering bridge:
 0. The driver configures a pvid of zero for each port, when in
    standalone mode. While the bridge configures a default_pvid of 1 for
    each port that gets added as a slave to it.
 1. The bridge calls ocelot_port_vlan_filtering with vlan_aware=true.
    The VLAN-filtering-dependent portion of the native VLAN
    configuration is done, considering that the native VLAN is 0.
 2. The bridge calls ocelot_vlan_add with vid=1, pvid=true,
    untagged=true. The native VLAN changes to 1 (change which gets
    propagated to hardware).
 3. ??? - nobody calls ocelot_port_vlan_filtering again, to reapply the
    VLAN-filtering-dependent portion of the native VLAN configuration,
    for the new native VLAN of 1. One can notice that after toggling "ip
    link set dev br0 type bridge vlan_filtering 0 && ip link set dev br0
    type bridge vlan_filtering 1", the new native VLAN finally makes it
    through and untagged traffic finally starts flowing again. But
    obviously that shouldn't be needed.

So it is clear that 2 independent variables need to both re-trigger the
native VLAN configuration. So we introduce the second variable as
ocelot_port->vlan_aware.

*Actually both the DSA Felix driver and the Ocelot driver already had
each its own variable:
 - Ocelot: ocelot_port_private->vlan_aware
 - Felix: dsa_port->vlan_filtering
but the common Ocelot library needs to work with a single, common,
variable, so there is some refactoring done to move the vlan_aware
property from the private structure into the common ocelot_port
structure.

Fixes: 97bb69e1e36e ("net: mscc: ocelot: break apart ocelot_vlan_port_apply")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
To get full VLAN functionality for the Felix DSA driver, we do also need
someting along the lines of Russell King's patch:
https://patchwork.ozlabs.org/project/netdev/patch/E1jEB0y-0006iF-5g@rmk-PC.armlinux.org.uk/
however that is not material for -net.

 drivers/net/dsa/ocelot/felix.c     |  5 +-
 drivers/net/ethernet/mscc/ocelot.c | 84 +++++++++++++++---------------
 drivers/net/ethernet/mscc/ocelot.h |  2 -
 include/soc/mscc/ocelot.h          |  4 +-
 4 files changed, 47 insertions(+), 48 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 55bf780b7b0e..53f335d83b37 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -77,11 +77,8 @@ static int felix_fdb_add(struct dsa_switch *ds, int port,
 			 const unsigned char *addr, u16 vid)
 {
 	struct ocelot *ocelot = ds->priv;
-	bool vlan_aware;
 
-	vlan_aware = dsa_port_is_vlan_filtering(dsa_to_port(ds, port));
-
-	return ocelot_fdb_add(ocelot, port, addr, vid, vlan_aware);
+	return ocelot_fdb_add(ocelot, port, addr, vid);
 }
 
 static int felix_fdb_del(struct dsa_switch *ds, int port,
diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index f9e9d205b551..a6de5f1bd9b1 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -183,44 +183,47 @@ static void ocelot_vlan_mode(struct ocelot *ocelot, int port,
 	ocelot_write(ocelot, val, ANA_VLANMASK);
 }
 
-void ocelot_port_vlan_filtering(struct ocelot *ocelot, int port,
-				bool vlan_aware)
+static int ocelot_port_set_native_vlan(struct ocelot *ocelot, int port,
+				       u16 vid)
 {
 	struct ocelot_port *ocelot_port = ocelot->ports[port];
-	u32 val;
+	u32 val = 0;
 
-	if (vlan_aware)
-		val = ANA_PORT_VLAN_CFG_VLAN_AWARE_ENA |
-		      ANA_PORT_VLAN_CFG_VLAN_POP_CNT(1);
-	else
-		val = 0;
-	ocelot_rmw_gix(ocelot, val,
-		       ANA_PORT_VLAN_CFG_VLAN_AWARE_ENA |
-		       ANA_PORT_VLAN_CFG_VLAN_POP_CNT_M,
-		       ANA_PORT_VLAN_CFG, port);
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
+		       REW_PORT_VLAN_CFG_PORT_VID_M,
+		       REW_PORT_VLAN_CFG, port);
 
-	if (vlan_aware && !ocelot_port->vid)
+	if (ocelot_port->vlan_aware && !ocelot_port->vid)
 		/* If port is vlan-aware and tagged, drop untagged and priority
 		 * tagged frames.
 		 */
 		val = ANA_PORT_DROP_CFG_DROP_UNTAGGED_ENA |
 		      ANA_PORT_DROP_CFG_DROP_PRIO_S_TAGGED_ENA |
 		      ANA_PORT_DROP_CFG_DROP_PRIO_C_TAGGED_ENA;
-	else
-		val = 0;
 	ocelot_rmw_gix(ocelot, val,
 		       ANA_PORT_DROP_CFG_DROP_UNTAGGED_ENA |
 		       ANA_PORT_DROP_CFG_DROP_PRIO_S_TAGGED_ENA |
 		       ANA_PORT_DROP_CFG_DROP_PRIO_C_TAGGED_ENA,
 		       ANA_PORT_DROP_CFG, port);
 
-	if (vlan_aware) {
+	if (ocelot_port->vlan_aware) {
 		if (ocelot_port->vid)
 			/* Tag all frames except when VID == DEFAULT_VLAN */
-			val |= REW_TAG_CFG_TAG_CFG(1);
+			val = REW_TAG_CFG_TAG_CFG(1);
 		else
 			/* Tag all frames */
-			val |= REW_TAG_CFG_TAG_CFG(3);
+			val = REW_TAG_CFG_TAG_CFG(3);
 	} else {
 		/* Port tagging disabled. */
 		val = REW_TAG_CFG_TAG_CFG(0);
@@ -228,31 +231,31 @@ void ocelot_port_vlan_filtering(struct ocelot *ocelot, int port,
 	ocelot_rmw_gix(ocelot, val,
 		       REW_TAG_CFG_TAG_CFG_M,
 		       REW_TAG_CFG, port);
+
+	return 0;
 }
-EXPORT_SYMBOL(ocelot_port_vlan_filtering);
 
-static int ocelot_port_set_native_vlan(struct ocelot *ocelot, int port,
-				       u16 vid)
+void ocelot_port_vlan_filtering(struct ocelot *ocelot, int port,
+				bool vlan_aware)
 {
 	struct ocelot_port *ocelot_port = ocelot->ports[port];
+	u32 val;
 
-	if (ocelot_port->vid != vid) {
-		/* Always permit deleting the native VLAN (vid = 0) */
-		if (ocelot_port->vid && vid) {
-			dev_err(ocelot->dev,
-				"Port already has a native VLAN: %d\n",
-				ocelot_port->vid);
-			return -EBUSY;
-		}
-		ocelot_port->vid = vid;
-	}
+	ocelot_port->vlan_aware = vlan_aware;
 
-	ocelot_rmw_gix(ocelot, REW_PORT_VLAN_CFG_PORT_VID(vid),
-		       REW_PORT_VLAN_CFG_PORT_VID_M,
-		       REW_PORT_VLAN_CFG, port);
+	if (vlan_aware)
+		val = ANA_PORT_VLAN_CFG_VLAN_AWARE_ENA |
+		      ANA_PORT_VLAN_CFG_VLAN_POP_CNT(1);
+	else
+		val = 0;
+	ocelot_rmw_gix(ocelot, val,
+		       ANA_PORT_VLAN_CFG_VLAN_AWARE_ENA |
+		       ANA_PORT_VLAN_CFG_VLAN_POP_CNT_M,
+		       ANA_PORT_VLAN_CFG, port);
 
-	return 0;
+	ocelot_port_set_native_vlan(ocelot, port, ocelot_port->vid);
 }
+EXPORT_SYMBOL(ocelot_port_vlan_filtering);
 
 /* Default vlan to clasify for untagged frames (may be zero) */
 static void ocelot_port_set_pvid(struct ocelot *ocelot, int port, u16 pvid)
@@ -873,12 +876,12 @@ static void ocelot_get_stats64(struct net_device *dev,
 }
 
 int ocelot_fdb_add(struct ocelot *ocelot, int port,
-		   const unsigned char *addr, u16 vid, bool vlan_aware)
+		   const unsigned char *addr, u16 vid)
 {
 	struct ocelot_port *ocelot_port = ocelot->ports[port];
 
 	if (!vid) {
-		if (!vlan_aware)
+		if (!ocelot_port->vlan_aware)
 			/* If the bridge is not VLAN aware and no VID was
 			 * provided, set it to pvid to ensure the MAC entry
 			 * matches incoming untagged packets
@@ -905,7 +908,7 @@ static int ocelot_port_fdb_add(struct ndmsg *ndm, struct nlattr *tb[],
 	struct ocelot *ocelot = priv->port.ocelot;
 	int port = priv->chip_port;
 
-	return ocelot_fdb_add(ocelot, port, addr, vid, priv->vlan_aware);
+	return ocelot_fdb_add(ocelot, port, addr, vid);
 }
 
 int ocelot_fdb_del(struct ocelot *ocelot, int port,
@@ -1496,8 +1499,8 @@ static int ocelot_port_attr_set(struct net_device *dev,
 		ocelot_port_attr_ageing_set(ocelot, port, attr->u.ageing_time);
 		break;
 	case SWITCHDEV_ATTR_ID_BRIDGE_VLAN_FILTERING:
-		priv->vlan_aware = attr->u.vlan_filtering;
-		ocelot_port_vlan_filtering(ocelot, port, priv->vlan_aware);
+		ocelot_port_vlan_filtering(ocelot, port,
+					   attr->u.vlan_filtering);
 		break;
 	case SWITCHDEV_ATTR_ID_BRIDGE_MC_DISABLED:
 		ocelot_port_attr_mc_set(ocelot, port, !attr->u.mc_disabled);
@@ -1876,7 +1879,6 @@ static int ocelot_netdevice_port_event(struct net_device *dev,
 			} else {
 				err = ocelot_port_bridge_leave(ocelot, port,
 							       info->upper_dev);
-				priv->vlan_aware = false;
 			}
 		}
 		if (netif_is_lag_master(info->upper_dev)) {
diff --git a/drivers/net/ethernet/mscc/ocelot.h b/drivers/net/ethernet/mscc/ocelot.h
index e63bc8743187..7a9c748adda0 100644
--- a/drivers/net/ethernet/mscc/ocelot.h
+++ b/drivers/net/ethernet/mscc/ocelot.h
@@ -57,8 +57,6 @@ struct ocelot_port_private {
 	struct phy_device *phy;
 	u8 chip_port;
 
-	u8 vlan_aware;
-
 	struct phy *serdes;
 
 	struct ocelot_port_tc tc;
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 6f122bd6c3c7..25014c1c91b1 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -482,6 +482,8 @@ struct ocelot_port {
 
 	void __iomem			*regs;
 
+	bool				vlan_aware;
+
 	/* Ingress default VLAN (pvid) */
 	u16				pvid;
 
@@ -616,7 +618,7 @@ int ocelot_port_bridge_leave(struct ocelot *ocelot, int port,
 int ocelot_fdb_dump(struct ocelot *ocelot, int port,
 		    dsa_fdb_dump_cb_t *cb, void *data);
 int ocelot_fdb_add(struct ocelot *ocelot, int port,
-		   const unsigned char *addr, u16 vid, bool vlan_aware);
+		   const unsigned char *addr, u16 vid);
 int ocelot_fdb_del(struct ocelot *ocelot, int port,
 		   const unsigned char *addr, u16 vid);
 int ocelot_vlan_add(struct ocelot *ocelot, int port, u16 vid, bool pvid,
-- 
2.17.1

