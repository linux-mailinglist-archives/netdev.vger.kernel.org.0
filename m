Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88F3E3533D0
	for <lists+netdev@lfdr.de>; Sat,  3 Apr 2021 13:49:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236684AbhDCLtL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Apr 2021 07:49:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236412AbhDCLtJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Apr 2021 07:49:09 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24A19C0613E6
        for <netdev@vger.kernel.org>; Sat,  3 Apr 2021 04:49:06 -0700 (PDT)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1lSelp-0000ey-7B; Sat, 03 Apr 2021 13:48:53 +0200
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1lSell-0007yg-UG; Sat, 03 Apr 2021 13:48:49 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mips@vger.kernel.org
Subject: [PATCH net-next v1 9/9] net: dsa: qca: ar9331: add vlan support
Date:   Sat,  3 Apr 2021 13:48:48 +0200
Message-Id: <20210403114848.30528-10-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210403114848.30528-1-o.rempel@pengutronix.de>
References: <20210403114848.30528-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This switch provides simple VLAN resolution database for 16 entries (VLANs).
With this database we can cover typical functionalities as port based
VLANs, untagged and tagged egress. Port based ingress filtering.

The VLAN database is working on top of forwarding database. So,
potentially, we can have multiple VLANs on top of multiple bridges.
Hawing one VLAN on top of multiple bridges will fail on different
levels, most probably DSA framework should warn if some one wont to make
something likes this.

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 drivers/net/dsa/qca/ar9331.c | 255 +++++++++++++++++++++++++++++++++++
 1 file changed, 255 insertions(+)

diff --git a/drivers/net/dsa/qca/ar9331.c b/drivers/net/dsa/qca/ar9331.c
index 83b59e771a5f..40062388d4a7 100644
--- a/drivers/net/dsa/qca/ar9331.c
+++ b/drivers/net/dsa/qca/ar9331.c
@@ -67,6 +67,27 @@
 #define AR9331_SW_REG_GLOBAL_CTRL		0x30
 #define AR9331_SW_GLOBAL_CTRL_MFS_M		GENMASK(13, 0)
 
+#define AR9331_SW_NUM_VLAN_RECORDS		16
+
+#define AR9331_SW_REG_VLAN_TABLE_FUNCTION0	0x40
+#define AR9331_SW_VT0_PRI_EN			BIT(31)
+#define AR9331_SW_VT0_PRI			GENMASK(30, 28)
+#define AR9331_SW_VT0_VID			GENMASK(27, 16)
+#define AR9331_SW_VT0_PORT_NUM			GENMASK(11, 8)
+#define AR9331_SW_VT0_FULL_VIO			BIT(4)
+#define AR9331_SW_VT0_BUSY			BIT(3)
+#define AR9331_SW_VT0_FUNC			GENMASK(2, 0)
+#define AR9331_SW_VT0_FUNC_NOP			0
+#define AR9331_SW_VT0_FUNC_FLUSH_ALL		1
+#define AR9331_SW_VT0_FUNC_LOAD_ENTRY		2
+#define AR9331_SW_VT0_FUNC_PURGE_ENTRY		3
+#define AR9331_SW_VT0_FUNC_DEL_PORT		4
+#define AR9331_SW_VT0_FUNC_GET_NEXT		5
+
+#define AR9331_SW_REG_VLAN_TABLE_FUNCTION1	0x44
+#define AR9331_SW_VT1_VALID			BIT(11)
+#define AR9331_SW_VT1_VID_MEM			GENMASK(9, 0)
+
 /* Size of the address resolution table (ARL) */
 #define AR9331_SW_NUM_ARL_RECORDS		1024
 
@@ -308,6 +329,11 @@ struct ar9331_sw_port {
 	struct spinlock stats_lock;
 };
 
+struct ar9331_sw_vlan_db {
+	u16 vid;
+	u8 port_mask;
+};
+
 struct ar9331_sw_fdb {
 	u8 port_mask;
 	u8 aging;
@@ -328,6 +354,7 @@ struct ar9331_sw_priv {
 	struct ar9331_sw_port port[AR9331_SW_PORTS];
 	int cpu_port;
 	u32 isolated_ports;
+	struct ar9331_sw_vlan_db vdb[AR9331_SW_NUM_VLAN_RECORDS];
 };
 
 static struct ar9331_sw_priv *ar9331_sw_port_to_priv(struct ar9331_sw_port *port)
@@ -1273,6 +1300,231 @@ static void ar9331_sw_port_stp_state_set(struct dsa_switch *ds, int port,
 	dev_err_ratelimited(priv->dev, "%s: error: %i\n", __func__, ret);
 }
 
+static int ar9331_port_vlan_filtering(struct dsa_switch *ds, int port,
+				      bool vlan_filtering,
+				      struct netlink_ext_ack *extack)
+{
+	struct ar9331_sw_priv *priv = (struct ar9331_sw_priv *)ds->priv;
+	struct regmap *regmap = priv->regmap;
+	u32 mode;
+	int ret;
+
+	if (vlan_filtering)
+		mode = AR9331_SW_8021Q_MODE_SECURE;
+	else
+		mode = AR9331_SW_8021Q_MODE_NONE;
+
+	ret = regmap_update_bits(regmap, AR9331_SW_REG_PORT_VLAN(port),
+				 AR9331_SW_PORT_VLAN_8021Q_MODE,
+				 FIELD_PREP(AR9331_SW_PORT_VLAN_8021Q_MODE,
+					    mode));
+	if (ret)
+		dev_err_ratelimited(priv->dev, "%s: error: %pe\n",
+				    __func__, ERR_PTR(ret));
+
+	return ret;
+}
+
+static int ar9331_sw_vt_wait(struct ar9331_sw_priv *priv, u32 *f0)
+{
+	struct regmap *regmap = priv->regmap;
+
+	return regmap_read_poll_timeout(regmap,
+				        AR9331_SW_REG_VLAN_TABLE_FUNCTION0,
+				        *f0, !(*f0 & AR9331_SW_VT0_BUSY),
+				        100, 2000);
+}
+
+static int ar9331_sw_port_vt_rmw(struct ar9331_sw_priv *priv, u16 vid,
+				 u8 port_mask_set, u8 port_mask_clr)
+{
+	struct regmap *regmap = priv->regmap;
+	u32 f0, f1, port_mask = 0, port_mask_new, func;
+	struct ar9331_sw_vlan_db *vdb = NULL;
+	int ret, i;
+
+	if (!vid)
+		return 0;
+
+	ret = ar9331_sw_vt_wait(priv, &f0);
+	if (ret)
+		return ret;
+
+	ret = regmap_write(regmap, AR9331_SW_REG_VLAN_TABLE_FUNCTION0, 0);
+	if (ret)
+		goto error;
+
+	ret = regmap_write(regmap, AR9331_SW_REG_VLAN_TABLE_FUNCTION1, 0);
+	if (ret)
+		goto error;
+
+	for (i = 0; i < ARRAY_SIZE(priv->vdb); i++) {
+		if (priv->vdb[i].vid == vid) {
+			vdb = &priv->vdb[i];
+			break;
+		}
+	}
+
+	ret = regmap_read(regmap, AR9331_SW_REG_VLAN_TABLE_FUNCTION1, &f1);
+	if (ret)
+		return ret;
+
+	if (vdb) {
+		port_mask = vdb->port_mask;
+	}
+
+	port_mask_new = port_mask & ~port_mask_clr;
+	port_mask_new |= port_mask_set;
+
+	if (port_mask_new && port_mask_new == port_mask) {
+		dev_info(priv->dev, "%s: no need to overwrite existing valid entry on %x\n",
+				    __func__, port_mask_new);
+		return 0;
+	}
+
+	if (port_mask_new) {
+		func = AR9331_SW_VT0_FUNC_LOAD_ENTRY;
+	} else {
+		func = AR9331_SW_VT0_FUNC_PURGE_ENTRY;
+		port_mask_new = port_mask;
+	}
+
+	if (vdb) {
+		vdb->port_mask = port_mask_new;
+
+		if (!port_mask_new)
+			vdb->vid = 0;
+	} else {
+		for (i = 0; i < ARRAY_SIZE(priv->vdb); i++) {
+			if (!priv->vdb[i].vid) {
+				vdb = &priv->vdb[i];
+				break;
+			}
+		}
+
+		if (!vdb) {
+			dev_err_ratelimited(priv->dev, "Local VDB is full\n");
+			return -ENOMEM;
+		}
+		vdb->vid = vid;
+		vdb->port_mask = port_mask_new;
+	}
+
+	f0 = FIELD_PREP(AR9331_SW_VT0_VID, vid) |
+	     FIELD_PREP(AR9331_SW_VT0_FUNC, func) |
+	     AR9331_SW_VT0_BUSY;
+	f1 = FIELD_PREP(AR9331_SW_VT1_VID_MEM, port_mask_new) |
+		AR9331_SW_VT1_VALID;
+
+	ret = regmap_write(regmap, AR9331_SW_REG_VLAN_TABLE_FUNCTION1, f1);
+	if (ret)
+		return ret;
+
+	ret = regmap_write(regmap, AR9331_SW_REG_VLAN_TABLE_FUNCTION0, f0);
+	if (ret)
+		return ret;
+
+	ret = ar9331_sw_vt_wait(priv, &f0);
+	if (ret)
+		return ret;
+
+	if (f0 & AR9331_SW_VT0_FULL_VIO) {
+		/* cleanup error status */
+		regmap_write(regmap, AR9331_SW_REG_VLAN_TABLE_FUNCTION0, 0);
+		dev_err_ratelimited(priv->dev, "%s: can't add new entry, VT is full\n", __func__);
+		return -ENOMEM;
+	}
+
+	return 0;
+
+error:
+	dev_err_ratelimited(priv->dev, "%s: error: %pe\n", __func__,
+			    ERR_PTR(ret));
+
+	return ret;
+}
+
+static int ar9331_port_vlan_set_pvid(struct ar9331_sw_priv *priv, int port,
+				     u16 pvid)
+{
+	struct regmap *regmap = priv->regmap;
+	int ret;
+	u32 mask, val;
+
+	mask = AR9331_SW_PORT_VLAN_8021Q_MODE |
+		AR9331_SW_PORT_VLAN_FORCE_DEFALUT_VID_EN |
+		AR9331_SW_PORT_VLAN_FORCE_PORT_VLAN_EN;
+	val = AR9331_SW_PORT_VLAN_FORCE_DEFALUT_VID_EN |
+		AR9331_SW_PORT_VLAN_FORCE_PORT_VLAN_EN |
+		FIELD_PREP(AR9331_SW_PORT_VLAN_8021Q_MODE,
+			   AR9331_SW_8021Q_MODE_FALLBACK);
+
+	ret = regmap_update_bits(regmap, AR9331_SW_REG_PORT_VLAN(port),
+				 mask, val);
+	if (ret)
+		return ret;
+
+	return regmap_update_bits(regmap, AR9331_SW_REG_PORT_VLAN(port),
+				  AR9331_SW_PORT_VLAN_PORT_VID,
+				  FIELD_PREP(AR9331_SW_PORT_VLAN_PORT_VID,
+					     pvid));
+}
+
+static int ar9331_port_vlan_add(struct dsa_switch *ds, int port,
+				const struct switchdev_obj_port_vlan *vlan,
+				struct netlink_ext_ack *extack)
+{
+	struct ar9331_sw_priv *priv = (struct ar9331_sw_priv *)ds->priv;
+	struct regmap *regmap = priv->regmap;
+	int ret, mode;
+
+	ret = ar9331_sw_port_vt_rmw(priv, vlan->vid, BIT(port), 0);
+	if (ret)
+		goto error;
+
+	if (vlan->flags & BRIDGE_VLAN_INFO_PVID)
+		ret = ar9331_port_vlan_set_pvid(priv, port, vlan->vid);
+
+	if (ret)
+		goto error;
+
+	if (vlan->flags & BRIDGE_VLAN_INFO_UNTAGGED)
+		mode = AR9331_SW_PORT_CTRL_EG_VLAN_MODE_STRIP;
+	else
+		mode = AR9331_SW_PORT_CTRL_EG_VLAN_MODE_ADD;
+
+	ret = regmap_update_bits(regmap, AR9331_SW_REG_PORT_CTRL(port),
+				 AR9331_SW_PORT_CTRL_EG_VLAN_MODE, mode);
+	if (ret)
+		goto error;
+
+	return 0;
+error:
+	dev_err_ratelimited(priv->dev, "%s: error: %pe\n", __func__,
+			    ERR_PTR(ret));
+
+	return ret;
+}
+
+static int ar9331_port_vlan_del(struct dsa_switch *ds, int port,
+				const struct switchdev_obj_port_vlan *vlan)
+{
+	struct ar9331_sw_priv *priv = (struct ar9331_sw_priv *)ds->priv;
+	int ret;
+
+	ret = ar9331_sw_port_vt_rmw(priv, vlan->vid, 0, BIT(port));
+	if (ret)
+		goto error;
+
+	return 0;
+
+error:
+	dev_err_ratelimited(priv->dev, "%s: error: %pe\n", __func__,
+			    ERR_PTR(ret));
+
+	return ret;
+}
+
 static const struct dsa_switch_ops ar9331_sw_ops = {
 	.get_tag_protocol	= ar9331_sw_get_tag_protocol,
 	.setup			= ar9331_sw_setup,
@@ -1292,6 +1544,9 @@ static const struct dsa_switch_ops ar9331_sw_ops = {
 	.port_bridge_join	= ar9331_sw_port_bridge_join,
 	.port_bridge_leave	= ar9331_sw_port_bridge_leave,
 	.port_stp_state_set	= ar9331_sw_port_stp_state_set,
+	.port_vlan_filtering	= ar9331_port_vlan_filtering,
+	.port_vlan_add		= ar9331_port_vlan_add,
+	.port_vlan_del		= ar9331_port_vlan_del,
 };
 
 static irqreturn_t ar9331_sw_irq(int irq, void *data)
-- 
2.29.2

