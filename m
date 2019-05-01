Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7826910E3B
	for <lists+netdev@lfdr.de>; Wed,  1 May 2019 22:45:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726283AbfEAUpq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 May 2019 16:45:46 -0400
Received: from mx1.mailbox.org ([80.241.60.212]:63122 "EHLO mx1.mailbox.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726088AbfEAUpq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 May 2019 16:45:46 -0400
Received: from smtp1.mailbox.org (smtp1.mailbox.org [IPv6:2001:67c:2050:105:465:1:1:0])
        (using TLSv1.2 with cipher ECDHE-RSA-CHACHA20-POLY1305 (256/256 bits))
        (No client certificate requested)
        by mx1.mailbox.org (Postfix) with ESMTPS id 0EB124CB10;
        Wed,  1 May 2019 22:45:44 +0200 (CEST)
X-Virus-Scanned: amavisd-new at heinlein-support.de
Received: from smtp1.mailbox.org ([80.241.60.240])
        by spamfilter02.heinlein-hosting.de (spamfilter02.heinlein-hosting.de [80.241.56.116]) (amavisd-new, port 10030)
        with ESMTP id aPFJXt9jLFk9; Wed,  1 May 2019 22:45:32 +0200 (CEST)
From:   Hauke Mehrtens <hauke@hauke-m.de>
To:     davem@davemloft.net
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        netdev@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 3/5] net: dsa: lantiq: Add VLAN aware bridge offloading
Date:   Wed,  1 May 2019 22:45:04 +0200
Message-Id: <20190501204506.21579-4-hauke@hauke-m.de>
In-Reply-To: <20190501204506.21579-1-hauke@hauke-m.de>
References: <20190501204506.21579-1-hauke@hauke-m.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The VLAN aware bridge offloading is similar to the VLAN unaware
offloading, this makes it possible to offload the VLAN bridge
functionalities.

The hardware supports up to 64 VLAN bridge entries, we already use one
entry for each LAN port to prevent forwarding of packets between the
ports when the ports are not in a bridge, so in the end we have 57
possible VLANs.

The VLAN filtering is currently only active when the ports are in a
bridge, VLAN filtering for ports not in a bridge is not implemented.

It is currently not possible to change between VLAN filtering and not
filtering while the port is already in a bridge, this would make the
driver more complicated.

The VLANs are only defined on bridge entries, so we will not add
anything into the hardware when the port joins a bridge if it is doing
VLAN filtering, but only when an allowed VLAN is added.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/net/dsa/lantiq_gswip.c | 201 ++++++++++++++++++++++++++++++++-
 1 file changed, 197 insertions(+), 4 deletions(-)

diff --git a/drivers/net/dsa/lantiq_gswip.c b/drivers/net/dsa/lantiq_gswip.c
index 8ab29db36bc2..23686b8399ea 100644
--- a/drivers/net/dsa/lantiq_gswip.c
+++ b/drivers/net/dsa/lantiq_gswip.c
@@ -252,6 +252,7 @@ struct gswip_priv {
 	struct gswip_vlan vlans[64];
 	int num_gphy_fw;
 	struct gswip_gphy_fw *gphy_fw;
+	u32 port_vlan_filter;
 };
 
 struct gswip_pce_table_entry {
@@ -731,6 +732,11 @@ static int gswip_port_vlan_filtering(struct dsa_switch *ds, int port,
 				     bool vlan_filtering)
 {
 	struct gswip_priv *priv = ds->priv;
+	struct net_device *bridge = dsa_to_port(ds, port)->bridge_dev;
+
+	/* Do not allow chaning the VLAN filtering options while in bridge */
+	if (!!(priv->port_vlan_filter & BIT(port)) != vlan_filtering && bridge)
+		return -EIO;
 
 	if (vlan_filtering) {
 		/* Use port based VLAN tag */
@@ -952,6 +958,82 @@ static int gswip_vlan_add_unaware(struct gswip_priv *priv,
 	return 0;
 }
 
+static int gswip_vlan_add_aware(struct gswip_priv *priv,
+				struct net_device *bridge, int port,
+				u16 vid, bool untagged,
+				bool pvid)
+{
+	struct gswip_pce_table_entry vlan_mapping = {0,};
+	unsigned int max_ports = priv->hw_info->max_ports;
+	unsigned int cpu_port = priv->hw_info->cpu_port;
+	bool active_vlan_created = false;
+	int idx = -1;
+	int fid = -1;
+	int i;
+	int err;
+
+	/* Check if there is already a page for this bridge */
+	for (i = max_ports; i < ARRAY_SIZE(priv->vlans); i++) {
+		if (priv->vlans[i].bridge == bridge) {
+			if (fid != -1 && fid != priv->vlans[i].fid)
+				dev_err(priv->dev, "one bridge with multiple flow ids\n");
+			fid = priv->vlans[i].fid;
+			if (priv->vlans[i].vid == vid) {
+				idx = i;
+				break;
+			}
+		}
+	}
+
+	/* If this bridge is not programmed yet, add a Active VLAN table
+	 * entry in a free slot and prepare the VLAN mapping table entry.
+	 */
+	if (idx == -1) {
+		idx = gswip_vlan_active_create(priv, bridge, fid, vid);
+		if (idx < 0)
+			return idx;
+		active_vlan_created = true;
+
+		vlan_mapping.index = idx;
+		vlan_mapping.table = GSWIP_TABLE_VLAN_MAPPING;
+		/* VLAN ID byte, maps to the VLAN ID of vlan active table */
+		vlan_mapping.val[0] = vid;
+	} else {
+		/* Read the existing VLAN mapping entry from the switch */
+		vlan_mapping.index = idx;
+		vlan_mapping.table = GSWIP_TABLE_VLAN_MAPPING;
+		err = gswip_pce_table_entry_read(priv, &vlan_mapping);
+		if (err) {
+			dev_err(priv->dev, "failed to read VLAN mapping: %d\n",
+				err);
+			return err;
+		}
+	}
+
+	vlan_mapping.val[0] = vid;
+	/* Update the VLAN mapping entry and write it to the switch */
+	vlan_mapping.val[1] |= BIT(cpu_port);
+	vlan_mapping.val[2] |= BIT(cpu_port);
+	vlan_mapping.val[1] |= BIT(port);
+	if (untagged)
+		vlan_mapping.val[2] &= ~BIT(port);
+	else
+		vlan_mapping.val[2] |= BIT(port);
+	err = gswip_pce_table_entry_write(priv, &vlan_mapping);
+	if (err) {
+		dev_err(priv->dev, "failed to write VLAN mapping: %d\n", err);
+		/* In case an Active VLAN was creaetd delete it again */
+		if (active_vlan_created)
+			gswip_vlan_active_remove(priv, idx);
+		return err;
+	}
+
+	if (pvid)
+		gswip_switch_w(priv, idx, GSWIP_PCE_DEFPVID(port));
+
+	return 0;
+}
+
 static int gswip_vlan_remove(struct gswip_priv *priv,
 			     struct net_device *bridge, int port,
 			     u16 vid, bool pvid, bool vlan_aware)
@@ -1016,9 +1098,17 @@ static int gswip_port_bridge_join(struct dsa_switch *ds, int port,
 	struct gswip_priv *priv = ds->priv;
 	int err;
 
-	err = gswip_vlan_add_unaware(priv, bridge, port);
-	if (err)
-		return err;
+	/* When the bridge uses VLAN filtering we have to configure VLAN
+	 * specific bridges. No bridge is configured here.
+	 */
+	if (!br_vlan_enabled(bridge)) {
+		err = gswip_vlan_add_unaware(priv, bridge, port);
+		if (err)
+			return err;
+		priv->port_vlan_filter &= ~BIT(port);
+	} else {
+		priv->port_vlan_filter |= BIT(port);
+	}
 	return gswip_add_signle_port_br(priv, port, false);
 }
 
@@ -1029,7 +1119,106 @@ static void gswip_port_bridge_leave(struct dsa_switch *ds, int port,
 
 	gswip_add_signle_port_br(priv, port, true);
 
-	gswip_vlan_remove(priv, bridge, port, 0, true, false);
+	/* When the bridge uses VLAN filtering we have to configure VLAN
+	 * specific bridges. No bridge is configured here.
+	 */
+	if (!br_vlan_enabled(bridge))
+		gswip_vlan_remove(priv, bridge, port, 0, true, false);
+}
+
+static int gswip_port_vlan_prepare(struct dsa_switch *ds, int port,
+				   const struct switchdev_obj_port_vlan *vlan)
+{
+	struct gswip_priv *priv = ds->priv;
+	struct net_device *bridge = dsa_to_port(ds, port)->bridge_dev;
+	unsigned int max_ports = priv->hw_info->max_ports;
+	u16 vid;
+	int i;
+	int pos = max_ports;
+
+	/* We only support VLAN filtering on bridges */
+	if (!dsa_is_cpu_port(ds, port) && !bridge)
+		return -EOPNOTSUPP;
+
+	for (vid = vlan->vid_begin; vid <= vlan->vid_end; ++vid) {
+		int idx = -1;
+
+		/* Check if there is already a page for this VLAN */
+		for (i = max_ports; i < ARRAY_SIZE(priv->vlans); i++) {
+			if (priv->vlans[i].bridge == bridge &&
+			    priv->vlans[i].vid == vid) {
+				idx = i;
+				break;
+			}
+		}
+
+		/* If this VLAN is not programmed yet, we have to reserve
+		 * one entry in the VLAN table. Make sure we start at the
+		 * next position round.
+		 */
+		if (idx == -1) {
+			/* Look for a free slot */
+			for (; pos < ARRAY_SIZE(priv->vlans); pos++) {
+				if (!priv->vlans[pos].bridge) {
+					idx = pos;
+					pos++;
+					break;
+				}
+			}
+
+			if (idx == -1)
+				return -ENOSPC;
+		}
+	}
+
+	return 0;
+}
+
+static void gswip_port_vlan_add(struct dsa_switch *ds, int port,
+				const struct switchdev_obj_port_vlan *vlan)
+{
+	struct gswip_priv *priv = ds->priv;
+	struct net_device *bridge = dsa_to_port(ds, port)->bridge_dev;
+	bool untagged = vlan->flags & BRIDGE_VLAN_INFO_UNTAGGED;
+	bool pvid = vlan->flags & BRIDGE_VLAN_INFO_PVID;
+	u16 vid;
+
+	/* We have to receive all packets on the CPU port and should not
+	 * do any VLAN filtering here. This is also called with bridge
+	 * NULL and then we do not know for which bridge to configure
+	 * this.
+	 */
+	if (dsa_is_cpu_port(ds, port))
+		return;
+
+	for (vid = vlan->vid_begin; vid <= vlan->vid_end; ++vid)
+		gswip_vlan_add_aware(priv, bridge, port, vid, untagged, pvid);
+}
+
+static int gswip_port_vlan_del(struct dsa_switch *ds, int port,
+			       const struct switchdev_obj_port_vlan *vlan)
+{
+	struct gswip_priv *priv = ds->priv;
+	struct net_device *bridge = dsa_to_port(ds, port)->bridge_dev;
+	bool pvid = vlan->flags & BRIDGE_VLAN_INFO_PVID;
+	u16 vid;
+	int err;
+
+	/* We have to receive all packets on the CPU port and should not
+	 * do any VLAN filtering here. This is also called with bridge
+	 * NULL and then we do not know for which bridge to configure
+	 * this.
+	 */
+	if (dsa_is_cpu_port(ds, port))
+		return 0;
+
+	for (vid = vlan->vid_begin; vid <= vlan->vid_end; ++vid) {
+		err = gswip_vlan_remove(priv, bridge, port, vid, pvid, true);
+		if (err)
+			return err;
+	}
+
+	return 0;
 }
 
 static void gswip_port_stp_state_set(struct dsa_switch *ds, int port, u8 state)
@@ -1272,6 +1461,10 @@ static const struct dsa_switch_ops gswip_switch_ops = {
 	.port_disable		= gswip_port_disable,
 	.port_bridge_join	= gswip_port_bridge_join,
 	.port_bridge_leave	= gswip_port_bridge_leave,
+	.port_vlan_filtering	= gswip_port_vlan_filtering,
+	.port_vlan_prepare	= gswip_port_vlan_prepare,
+	.port_vlan_add		= gswip_port_vlan_add,
+	.port_vlan_del		= gswip_port_vlan_del,
 	.port_stp_state_set	= gswip_port_stp_state_set,
 	.phylink_validate	= gswip_phylink_validate,
 	.phylink_mac_config	= gswip_phylink_mac_config,
-- 
2.20.1

