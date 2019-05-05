Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99B471426E
	for <lists+netdev@lfdr.de>; Sun,  5 May 2019 23:16:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727932AbfEEVP7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 May 2019 17:15:59 -0400
Received: from mx1.mailbox.org ([80.241.60.212]:26228 "EHLO mx1.mailbox.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727765AbfEEVP5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 5 May 2019 17:15:57 -0400
Received: from smtp2.mailbox.org (smtp2.mailbox.org [80.241.60.241])
        (using TLSv1.2 with cipher ECDHE-RSA-CHACHA20-POLY1305 (256/256 bits))
        (No client certificate requested)
        by mx1.mailbox.org (Postfix) with ESMTPS id 4FF134CD16;
        Sun,  5 May 2019 23:15:55 +0200 (CEST)
X-Virus-Scanned: amavisd-new at heinlein-support.de
Received: from smtp2.mailbox.org ([80.241.60.241])
        by spamfilter05.heinlein-hosting.de (spamfilter05.heinlein-hosting.de [80.241.56.123]) (amavisd-new, port 10030)
        with ESMTP id LBPB9eCFwrEI; Sun,  5 May 2019 23:15:37 +0200 (CEST)
From:   Hauke Mehrtens <hauke@hauke-m.de>
To:     davem@davemloft.net
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        netdev@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH v2 2/5] net: dsa: lantiq: Add VLAN unaware bridge offloading
Date:   Sun,  5 May 2019 23:15:14 +0200
Message-Id: <20190505211517.25237-3-hauke@hauke-m.de>
In-Reply-To: <20190505211517.25237-1-hauke@hauke-m.de>
References: <20190505211517.25237-1-hauke@hauke-m.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This allows to offload bridges with DSA to the switch hardware and do
the packet forwarding in hardware.

This implements generic functions to access the switch hardware tables,
which are used to control many features of the switch.

This patch activates the MAC learning by removing the MAC address table
lock, to prevent uncontrolled forwarding of packets between all the LAN
ports, they are added into individual bridge tables entries with
individual flow ids and the switch will do the MAC learning for each
port separately before they are added to a real bridge.

Each bridge consist of an entry in the active VLAN table and the VLAN
mapping table, table entries with the same index are matching. In the
VLAN unaware mode we configure everything with VLAN ID 0, but we use
different flow IDs, the switch should handle all VLANs as normal payload
and ignore them. When the hardware looks for the port of the destination
MAC address it only takes the entries which have the same flow ID of the
ingress packet.

The bridges are configured with 64 possible entries with these
information:
Table Index, 0...63
VLAN ID, 0...4095: VLAN ID 0 is untagged
flow ID, 0..63: Same flow IDs share entries in MAC learning table
port map, one bit for each port number
tagged port map, one bit for each port number

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/net/dsa/lantiq_gswip.c | 476 ++++++++++++++++++++++++++++++++-
 1 file changed, 469 insertions(+), 7 deletions(-)

diff --git a/drivers/net/dsa/lantiq_gswip.c b/drivers/net/dsa/lantiq_gswip.c
index 0a2259cb09df..c7b2d6219627 100644
--- a/drivers/net/dsa/lantiq_gswip.c
+++ b/drivers/net/dsa/lantiq_gswip.c
@@ -4,7 +4,25 @@
  *
  * Copyright (C) 2010 Lantiq Deutschland
  * Copyright (C) 2012 John Crispin <john@phrozen.org>
- * Copyright (C) 2017 - 2018 Hauke Mehrtens <hauke@hauke-m.de>
+ * Copyright (C) 2017 - 2019 Hauke Mehrtens <hauke@hauke-m.de>
+ *
+ * The VLAN and bridge model the GSWIP hardware uses does not directly
+ * matches the model DSA uses.
+ *
+ * The hardware has 64 possible table entries for bridges with one VLAN
+ * ID, one flow id and a list of ports for each bridge. All entries which
+ * match the same flow ID are combined in the mac learning table, they
+ * act as one global bridge.
+ * The hardware does not support VLAN filter on the port, but on the
+ * bridge, this driver converts the DSA model to the hardware.
+ *
+ * The CPU gets all the exception frames which do not match any forwarding
+ * rule and the CPU port is also added to all bridges. This makes it possible
+ * to handle all the special cases easily in software.
+ * At the initialization the driver allocates one bridge table entry for
+ * each switch port which is used when the port is used without an
+ * explicit bridge. This prevents the frames from being forwarded
+ * between all LAN ports by default.
  */
 
 #include <linux/clk.h>
@@ -148,19 +166,29 @@
 #define GSWIP_PCE_PMAP2			0x454	/* Default Multicast port map */
 #define GSWIP_PCE_PMAP3			0x455	/* Default Unknown Unicast port map */
 #define GSWIP_PCE_GCTRL_0		0x456
+#define  GSWIP_PCE_GCTRL_0_MTFL		BIT(0)  /* MAC Table Flushing */
 #define  GSWIP_PCE_GCTRL_0_MC_VALID	BIT(3)
 #define  GSWIP_PCE_GCTRL_0_VLAN		BIT(14) /* VLAN aware Switching */
 #define GSWIP_PCE_GCTRL_1		0x457
 #define  GSWIP_PCE_GCTRL_1_MAC_GLOCK	BIT(2)	/* MAC Address table lock */
 #define  GSWIP_PCE_GCTRL_1_MAC_GLOCK_MOD	BIT(3) /* Mac address table lock forwarding mode */
 #define GSWIP_PCE_PCTRL_0p(p)		(0x480 + ((p) * 0xA))
-#define  GSWIP_PCE_PCTRL_0_INGRESS	BIT(11)
+#define  GSWIP_PCE_PCTRL_0_TVM		BIT(5)	/* Transparent VLAN mode */
+#define  GSWIP_PCE_PCTRL_0_VREP		BIT(6)	/* VLAN Replace Mode */
+#define  GSWIP_PCE_PCTRL_0_INGRESS	BIT(11)	/* Accept special tag in ingress */
 #define  GSWIP_PCE_PCTRL_0_PSTATE_LISTEN	0x0
 #define  GSWIP_PCE_PCTRL_0_PSTATE_RX		0x1
 #define  GSWIP_PCE_PCTRL_0_PSTATE_TX		0x2
 #define  GSWIP_PCE_PCTRL_0_PSTATE_LEARNING	0x3
 #define  GSWIP_PCE_PCTRL_0_PSTATE_FORWARDING	0x7
 #define  GSWIP_PCE_PCTRL_0_PSTATE_MASK	GENMASK(2, 0)
+#define GSWIP_PCE_VCTRL(p)		(0x485 + ((p) * 0xA))
+#define  GSWIP_PCE_VCTRL_UVR		BIT(0)	/* Unknown VLAN Rule */
+#define  GSWIP_PCE_VCTRL_VIMR		BIT(3)	/* VLAN Ingress Member violation rule */
+#define  GSWIP_PCE_VCTRL_VEMR		BIT(4)	/* VLAN Egress Member violation rule */
+#define  GSWIP_PCE_VCTRL_VSR		BIT(5)	/* VLAN Security */
+#define  GSWIP_PCE_VCTRL_VID0		BIT(6)	/* Priority Tagged Rule */
+#define GSWIP_PCE_DEFPVID(p)		(0x486 + ((p) * 0xA))
 
 #define GSWIP_MAC_FLEN			0x8C5
 #define GSWIP_MAC_CTRL_2p(p)		(0x905 + ((p) * 0xC))
@@ -183,6 +211,10 @@
 #define  GSWIP_SDMA_PCTRL_FCEN		BIT(1)	/* Flow Control Enable */
 #define  GSWIP_SDMA_PCTRL_PAUFWD	BIT(1)	/* Pause Frame Forwarding */
 
+#define GSWIP_TABLE_ACTIVE_VLAN		0x01
+#define GSWIP_TABLE_VLAN_MAPPING	0x02
+#define GSWIP_TABLE_MAC_BRIDGE		0x0b
+
 #define XRX200_GPHY_FW_ALIGN	(16 * 1024)
 
 struct gswip_hw_info {
@@ -202,6 +234,12 @@ struct gswip_gphy_fw {
 	char *fw_name;
 };
 
+struct gswip_vlan {
+	struct net_device *bridge;
+	u16 vid;
+	u8 fid;
+};
+
 struct gswip_priv {
 	__iomem void *gswip;
 	__iomem void *mdio;
@@ -211,10 +249,23 @@ struct gswip_priv {
 	struct dsa_switch *ds;
 	struct device *dev;
 	struct regmap *rcu_regmap;
+	struct gswip_vlan vlans[64];
 	int num_gphy_fw;
 	struct gswip_gphy_fw *gphy_fw;
 };
 
+struct gswip_pce_table_entry {
+	u16 index;      // PCE_TBL_ADDR.ADDR = pData->table_index
+	u16 table;      // PCE_TBL_CTRL.ADDR = pData->table
+	u16 key[8];
+	u16 val[5];
+	u16 mask;
+	u8 gmap;
+	bool type;
+	bool valid;
+	bool key_mode;
+};
+
 struct gswip_rmon_cnt_desc {
 	unsigned int size;
 	unsigned int offset;
@@ -447,10 +498,153 @@ static int gswip_mdio(struct gswip_priv *priv, struct device_node *mdio_np)
 	return of_mdiobus_register(ds->slave_mii_bus, mdio_np);
 }
 
+static int gswip_pce_table_entry_read(struct gswip_priv *priv,
+				      struct gswip_pce_table_entry *tbl)
+{
+	int i;
+	int err;
+	u16 crtl;
+	u16 addr_mode = tbl->key_mode ? GSWIP_PCE_TBL_CTRL_OPMOD_KSRD :
+					GSWIP_PCE_TBL_CTRL_OPMOD_ADRD;
+
+	err = gswip_switch_r_timeout(priv, GSWIP_PCE_TBL_CTRL,
+				     GSWIP_PCE_TBL_CTRL_BAS);
+	if (err)
+		return err;
+
+	gswip_switch_w(priv, tbl->index, GSWIP_PCE_TBL_ADDR);
+	gswip_switch_mask(priv, GSWIP_PCE_TBL_CTRL_ADDR_MASK |
+				GSWIP_PCE_TBL_CTRL_OPMOD_MASK,
+			  tbl->table | addr_mode | GSWIP_PCE_TBL_CTRL_BAS,
+			  GSWIP_PCE_TBL_CTRL);
+
+	err = gswip_switch_r_timeout(priv, GSWIP_PCE_TBL_CTRL,
+				     GSWIP_PCE_TBL_CTRL_BAS);
+	if (err)
+		return err;
+
+	for (i = 0; i < ARRAY_SIZE(tbl->key); i++)
+		tbl->key[i] = gswip_switch_r(priv, GSWIP_PCE_TBL_KEY(i));
+
+	for (i = 0; i < ARRAY_SIZE(tbl->val); i++)
+		tbl->val[i] = gswip_switch_r(priv, GSWIP_PCE_TBL_VAL(i));
+
+	tbl->mask = gswip_switch_r(priv, GSWIP_PCE_TBL_MASK);
+
+	crtl = gswip_switch_r(priv, GSWIP_PCE_TBL_CTRL);
+
+	tbl->type = !!(crtl & GSWIP_PCE_TBL_CTRL_TYPE);
+	tbl->valid = !!(crtl & GSWIP_PCE_TBL_CTRL_VLD);
+	tbl->gmap = (crtl & GSWIP_PCE_TBL_CTRL_GMAP_MASK) >> 7;
+
+	return 0;
+}
+
+static int gswip_pce_table_entry_write(struct gswip_priv *priv,
+				       struct gswip_pce_table_entry *tbl)
+{
+	int i;
+	int err;
+	u16 crtl;
+	u16 addr_mode = tbl->key_mode ? GSWIP_PCE_TBL_CTRL_OPMOD_KSWR :
+					GSWIP_PCE_TBL_CTRL_OPMOD_ADWR;
+
+	err = gswip_switch_r_timeout(priv, GSWIP_PCE_TBL_CTRL,
+				     GSWIP_PCE_TBL_CTRL_BAS);
+	if (err)
+		return err;
+
+	gswip_switch_w(priv, tbl->index, GSWIP_PCE_TBL_ADDR);
+	gswip_switch_mask(priv, GSWIP_PCE_TBL_CTRL_ADDR_MASK |
+				GSWIP_PCE_TBL_CTRL_OPMOD_MASK,
+			  tbl->table | addr_mode,
+			  GSWIP_PCE_TBL_CTRL);
+
+	for (i = 0; i < ARRAY_SIZE(tbl->key); i++)
+		gswip_switch_w(priv, tbl->key[i], GSWIP_PCE_TBL_KEY(i));
+
+	for (i = 0; i < ARRAY_SIZE(tbl->val); i++)
+		gswip_switch_w(priv, tbl->val[i], GSWIP_PCE_TBL_VAL(i));
+
+	gswip_switch_mask(priv, GSWIP_PCE_TBL_CTRL_ADDR_MASK |
+				GSWIP_PCE_TBL_CTRL_OPMOD_MASK,
+			  tbl->table | addr_mode,
+			  GSWIP_PCE_TBL_CTRL);
+
+	gswip_switch_w(priv, tbl->mask, GSWIP_PCE_TBL_MASK);
+
+	crtl = gswip_switch_r(priv, GSWIP_PCE_TBL_CTRL);
+	crtl &= ~(GSWIP_PCE_TBL_CTRL_TYPE | GSWIP_PCE_TBL_CTRL_VLD |
+		  GSWIP_PCE_TBL_CTRL_GMAP_MASK);
+	if (tbl->type)
+		crtl |= GSWIP_PCE_TBL_CTRL_TYPE;
+	if (tbl->valid)
+		crtl |= GSWIP_PCE_TBL_CTRL_VLD;
+	crtl |= (tbl->gmap << 7) & GSWIP_PCE_TBL_CTRL_GMAP_MASK;
+	crtl |= GSWIP_PCE_TBL_CTRL_BAS;
+	gswip_switch_w(priv, crtl, GSWIP_PCE_TBL_CTRL);
+
+	return gswip_switch_r_timeout(priv, GSWIP_PCE_TBL_CTRL,
+				      GSWIP_PCE_TBL_CTRL_BAS);
+}
+
+/* Add the LAN port into a bridge with the CPU port by
+ * default. This prevents automatic forwarding of
+ * packages between the LAN ports when no explicit
+ * bridge is configured.
+ */
+static int gswip_add_single_port_br(struct gswip_priv *priv, int port, bool add)
+{
+	struct gswip_pce_table_entry vlan_active = {0,};
+	struct gswip_pce_table_entry vlan_mapping = {0,};
+	unsigned int cpu_port = priv->hw_info->cpu_port;
+	unsigned int max_ports = priv->hw_info->max_ports;
+	int err;
+
+	if (port >= max_ports) {
+		dev_err(priv->dev, "single port for %i supported\n", port);
+		return -EIO;
+	}
+
+	vlan_active.index = port + 1;
+	vlan_active.table = GSWIP_TABLE_ACTIVE_VLAN;
+	vlan_active.key[0] = 0; /* vid */
+	vlan_active.val[0] = port + 1 /* fid */;
+	vlan_active.valid = add;
+	err = gswip_pce_table_entry_write(priv, &vlan_active);
+	if (err) {
+		dev_err(priv->dev, "failed to write active VLAN: %d\n", err);
+		return err;
+	}
+
+	if (!add)
+		return 0;
+
+	vlan_mapping.index = port + 1;
+	vlan_mapping.table = GSWIP_TABLE_VLAN_MAPPING;
+	vlan_mapping.val[0] = 0 /* vid */;
+	vlan_mapping.val[1] = BIT(port) | BIT(cpu_port);
+	vlan_mapping.val[2] = 0;
+	err = gswip_pce_table_entry_write(priv, &vlan_mapping);
+	if (err) {
+		dev_err(priv->dev, "failed to write VLAN mapping: %d\n", err);
+		return err;
+	}
+
+	return 0;
+}
+
 static int gswip_port_enable(struct dsa_switch *ds, int port,
 			     struct phy_device *phydev)
 {
 	struct gswip_priv *priv = ds->priv;
+	int err;
+
+	if (!dsa_is_cpu_port(ds, port)) {
+		err = gswip_add_single_port_br(priv, port, true);
+		if (err)
+			return err;
+	}
 
 	/* RMON Counter Enable for port */
 	gswip_switch_w(priv, GSWIP_BM_PCFG_CNTEN, GSWIP_BM_PCFGp(port));
@@ -533,6 +727,34 @@ static int gswip_pce_load_microcode(struct gswip_priv *priv)
 	return 0;
 }
 
+static int gswip_port_vlan_filtering(struct dsa_switch *ds, int port,
+				     bool vlan_filtering)
+{
+	struct gswip_priv *priv = ds->priv;
+
+	if (vlan_filtering) {
+		/* Use port based VLAN tag */
+		gswip_switch_mask(priv,
+				  GSWIP_PCE_VCTRL_VSR,
+				  GSWIP_PCE_VCTRL_UVR | GSWIP_PCE_VCTRL_VIMR |
+				  GSWIP_PCE_VCTRL_VEMR,
+				  GSWIP_PCE_VCTRL(port));
+		gswip_switch_mask(priv, GSWIP_PCE_PCTRL_0_TVM, 0,
+				  GSWIP_PCE_PCTRL_0p(port));
+	} else {
+		/* Use port based VLAN tag */
+		gswip_switch_mask(priv,
+				  GSWIP_PCE_VCTRL_UVR | GSWIP_PCE_VCTRL_VIMR |
+				  GSWIP_PCE_VCTRL_VEMR,
+				  GSWIP_PCE_VCTRL_VSR,
+				  GSWIP_PCE_VCTRL(port));
+		gswip_switch_mask(priv, 0, GSWIP_PCE_PCTRL_0_TVM,
+				  GSWIP_PCE_PCTRL_0p(port));
+	}
+
+	return 0;
+}
+
 static int gswip_setup(struct dsa_switch *ds)
 {
 	struct gswip_priv *priv = ds->priv;
@@ -545,8 +767,10 @@ static int gswip_setup(struct dsa_switch *ds)
 	gswip_switch_w(priv, 0, GSWIP_SWRES);
 
 	/* disable port fetch/store dma on all ports */
-	for (i = 0; i < priv->hw_info->max_ports; i++)
+	for (i = 0; i < priv->hw_info->max_ports; i++) {
 		gswip_port_disable(ds, i);
+		gswip_port_vlan_filtering(ds, i, false);
+	}
 
 	/* enable Switch */
 	gswip_mdio_mask(priv, 0, GSWIP_MDIO_GLOB_ENABLE, GSWIP_MDIO_GLOB);
@@ -589,10 +813,15 @@ static int gswip_setup(struct dsa_switch *ds)
 	/* VLAN aware Switching */
 	gswip_switch_mask(priv, 0, GSWIP_PCE_GCTRL_0_VLAN, GSWIP_PCE_GCTRL_0);
 
-	/* Mac Address Table Lock */
-	gswip_switch_mask(priv, 0, GSWIP_PCE_GCTRL_1_MAC_GLOCK |
-				   GSWIP_PCE_GCTRL_1_MAC_GLOCK_MOD,
-			  GSWIP_PCE_GCTRL_1);
+	/* Flush MAC Table */
+	gswip_switch_mask(priv, 0, GSWIP_PCE_GCTRL_0_MTFL, GSWIP_PCE_GCTRL_0);
+
+	err = gswip_switch_r_timeout(priv, GSWIP_PCE_GCTRL_0,
+				     GSWIP_PCE_GCTRL_0_MTFL);
+	if (err) {
+		dev_err(priv->dev, "MAC flushing didn't finish\n");
+		return err;
+	}
 
 	gswip_port_enable(ds, cpu_port, NULL);
 	return 0;
@@ -604,6 +833,236 @@ static enum dsa_tag_protocol gswip_get_tag_protocol(struct dsa_switch *ds,
 	return DSA_TAG_PROTO_GSWIP;
 }
 
+static int gswip_vlan_active_create(struct gswip_priv *priv,
+				    struct net_device *bridge,
+				    int fid, u16 vid)
+{
+	struct gswip_pce_table_entry vlan_active = {0,};
+	unsigned int max_ports = priv->hw_info->max_ports;
+	int idx = -1;
+	int err;
+	int i;
+
+	/* Look for a free slot */
+	for (i = max_ports; i < ARRAY_SIZE(priv->vlans); i++) {
+		if (!priv->vlans[i].bridge) {
+			idx = i;
+			break;
+		}
+	}
+
+	if (idx == -1)
+		return -ENOSPC;
+
+	if (fid == -1)
+		fid = idx;
+
+	vlan_active.index = idx;
+	vlan_active.table = GSWIP_TABLE_ACTIVE_VLAN;
+	vlan_active.key[0] = vid;
+	vlan_active.val[0] = fid;
+	vlan_active.valid = true;
+
+	err = gswip_pce_table_entry_write(priv, &vlan_active);
+	if (err) {
+		dev_err(priv->dev, "failed to write active VLAN: %d\n",	err);
+		return err;
+	}
+
+	priv->vlans[idx].bridge = bridge;
+	priv->vlans[idx].vid = vid;
+	priv->vlans[idx].fid = fid;
+
+	return idx;
+}
+
+static int gswip_vlan_active_remove(struct gswip_priv *priv, int idx)
+{
+	struct gswip_pce_table_entry vlan_active = {0,};
+	int err;
+
+	vlan_active.index = idx;
+	vlan_active.table = GSWIP_TABLE_ACTIVE_VLAN;
+	vlan_active.valid = false;
+	err = gswip_pce_table_entry_write(priv, &vlan_active);
+	if (err)
+		dev_err(priv->dev, "failed to delete active VLAN: %d\n", err);
+	priv->vlans[idx].bridge = NULL;
+
+	return err;
+}
+
+static int gswip_vlan_add_unaware(struct gswip_priv *priv,
+				  struct net_device *bridge, int port)
+{
+	struct gswip_pce_table_entry vlan_mapping = {0,};
+	unsigned int max_ports = priv->hw_info->max_ports;
+	unsigned int cpu_port = priv->hw_info->cpu_port;
+	bool active_vlan_created = false;
+	int idx = -1;
+	int i;
+	int err;
+
+	/* Check if there is already a page for this bridge */
+	for (i = max_ports; i < ARRAY_SIZE(priv->vlans); i++) {
+		if (priv->vlans[i].bridge == bridge) {
+			idx = i;
+			break;
+		}
+	}
+
+	/* If this bridge is not programmed yet, add a Active VLAN table
+	 * entry in a free slot and prepare the VLAN mapping table entry.
+	 */
+	if (idx == -1) {
+		idx = gswip_vlan_active_create(priv, bridge, -1, 0);
+		if (idx < 0)
+			return idx;
+		active_vlan_created = true;
+
+		vlan_mapping.index = idx;
+		vlan_mapping.table = GSWIP_TABLE_VLAN_MAPPING;
+		/* VLAN ID byte, maps to the VLAN ID of vlan active table */
+		vlan_mapping.val[0] = 0;
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
+	/* Update the VLAN mapping entry and write it to the switch */
+	vlan_mapping.val[1] |= BIT(cpu_port);
+	vlan_mapping.val[1] |= BIT(port);
+	err = gswip_pce_table_entry_write(priv, &vlan_mapping);
+	if (err) {
+		dev_err(priv->dev, "failed to write VLAN mapping: %d\n", err);
+		/* In case an Active VLAN was creaetd delete it again */
+		if (active_vlan_created)
+			gswip_vlan_active_remove(priv, idx);
+		return err;
+	}
+
+	gswip_switch_w(priv, 0, GSWIP_PCE_DEFPVID(port));
+	return 0;
+}
+
+static int gswip_vlan_remove(struct gswip_priv *priv,
+			     struct net_device *bridge, int port,
+			     u16 vid, bool pvid, bool vlan_aware)
+{
+	struct gswip_pce_table_entry vlan_mapping = {0,};
+	unsigned int max_ports = priv->hw_info->max_ports;
+	unsigned int cpu_port = priv->hw_info->cpu_port;
+	int idx = -1;
+	int i;
+	int err;
+
+	/* Check if there is already a page for this bridge */
+	for (i = max_ports; i < ARRAY_SIZE(priv->vlans); i++) {
+		if (priv->vlans[i].bridge == bridge &&
+		    (!vlan_aware || priv->vlans[i].vid == vid)) {
+			idx = i;
+			break;
+		}
+	}
+
+	if (idx == -1) {
+		dev_err(priv->dev, "bridge to leave does not exists\n");
+		return -ENOENT;
+	}
+
+	vlan_mapping.index = idx;
+	vlan_mapping.table = GSWIP_TABLE_VLAN_MAPPING;
+	err = gswip_pce_table_entry_read(priv, &vlan_mapping);
+	if (err) {
+		dev_err(priv->dev, "failed to read VLAN mapping: %d\n",	err);
+		return err;
+	}
+
+	vlan_mapping.val[1] &= ~BIT(port);
+	vlan_mapping.val[2] &= ~BIT(port);
+	err = gswip_pce_table_entry_write(priv, &vlan_mapping);
+	if (err) {
+		dev_err(priv->dev, "failed to write VLAN mapping: %d\n", err);
+		return err;
+	}
+
+	/* In case all ports are removed from the bridge, remove the VLAN */
+	if ((vlan_mapping.val[1] & ~BIT(cpu_port)) == 0) {
+		err = gswip_vlan_active_remove(priv, idx);
+		if (err) {
+			dev_err(priv->dev, "failed to write active VLAN: %d\n",
+				err);
+			return err;
+		}
+	}
+
+	/* GSWIP 2.2 (GRX300) and later program here the VID directly. */
+	if (pvid)
+		gswip_switch_w(priv, 0, GSWIP_PCE_DEFPVID(port));
+
+	return 0;
+}
+
+static int gswip_port_bridge_join(struct dsa_switch *ds, int port,
+				  struct net_device *bridge)
+{
+	struct gswip_priv *priv = ds->priv;
+	int err;
+
+	err = gswip_vlan_add_unaware(priv, bridge, port);
+	if (err)
+		return err;
+	return gswip_add_single_port_br(priv, port, false);
+}
+
+static void gswip_port_bridge_leave(struct dsa_switch *ds, int port,
+				    struct net_device *bridge)
+{
+	struct gswip_priv *priv = ds->priv;
+
+	gswip_add_single_port_br(priv, port, true);
+
+	gswip_vlan_remove(priv, bridge, port, 0, true, false);
+}
+
+static void gswip_port_stp_state_set(struct dsa_switch *ds, int port, u8 state)
+{
+	struct gswip_priv *priv = ds->priv;
+	u32 stp_state;
+
+	switch (state) {
+	case BR_STATE_DISABLED:
+		gswip_switch_mask(priv, GSWIP_SDMA_PCTRL_EN, 0,
+				  GSWIP_SDMA_PCTRLp(port));
+		return;
+	case BR_STATE_BLOCKING:
+	case BR_STATE_LISTENING:
+		stp_state = GSWIP_PCE_PCTRL_0_PSTATE_LISTEN;
+		break;
+	case BR_STATE_LEARNING:
+		stp_state = GSWIP_PCE_PCTRL_0_PSTATE_LEARNING;
+		break;
+	case BR_STATE_FORWARDING:
+		stp_state = GSWIP_PCE_PCTRL_0_PSTATE_FORWARDING;
+		break;
+	default:
+		dev_err(priv->dev, "invalid STP state: %d\n", state);
+		return;
+	}
+
+	gswip_switch_mask(priv, 0, GSWIP_SDMA_PCTRL_EN,
+			  GSWIP_SDMA_PCTRLp(port));
+	gswip_switch_mask(priv, GSWIP_PCE_PCTRL_0_PSTATE_MASK, stp_state,
+			  GSWIP_PCE_PCTRL_0p(port));
+}
+
 static void gswip_phylink_validate(struct dsa_switch *ds, int port,
 				   unsigned long *supported,
 				   struct phylink_link_state *state)
@@ -811,6 +1270,9 @@ static const struct dsa_switch_ops gswip_switch_ops = {
 	.setup			= gswip_setup,
 	.port_enable		= gswip_port_enable,
 	.port_disable		= gswip_port_disable,
+	.port_bridge_join	= gswip_port_bridge_join,
+	.port_bridge_leave	= gswip_port_bridge_leave,
+	.port_stp_state_set	= gswip_port_stp_state_set,
 	.phylink_validate	= gswip_phylink_validate,
 	.phylink_mac_config	= gswip_phylink_mac_config,
 	.phylink_mac_link_down	= gswip_phylink_mac_link_down,
-- 
2.20.1

