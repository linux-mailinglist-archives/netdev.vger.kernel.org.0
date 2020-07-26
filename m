Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69EF422DFC4
	for <lists+netdev@lfdr.de>; Sun, 26 Jul 2020 16:57:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726237AbgGZO4S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jul 2020 10:56:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725982AbgGZO4S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jul 2020 10:56:18 -0400
Received: from the.earth.li (the.earth.li [IPv6:2a00:1098:86:4d:c0ff:ee:15:900d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D3B3C0619D2;
        Sun, 26 Jul 2020 07:56:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=earth.li;
         s=the; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject
        :To:From:Date:Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=1VXAYqhb9ZoRAZACGTY2T4gE6nhXtRtm/AK4oLP4CSM=; b=E2QaGDQWGbH1VvcIDG1QinPCvc
        fvWilXwiIn8xYUYo+GOCTTSBl+U0SoyYPWrbXdPgrSrXZwzkUVg3SGrkr24rfUd4yRLh/WNCfPs5F
        3DzO3aud4TasC8FRiuMLKZA8mKfqbKul75smQGOrN7BfG6c7oq/Gij/UL++z0KfTDPJSVgU3g6nPc
        JmqFt1xRYCCoeVKy2ShSK78K4KDwoRK42zN5uboPZdzQqd9hO2BxYSt2zr9hSn9HTs/j9RgLqVb85
        2c5LcokWJEmd47tx9trKt4q2bo/1rC4VHhbrU7lzEYMbYm86P4wcoFYQuYTOvPMUY0WPXtl6OGga3
        WnNXAbQw==;
Received: from noodles by the.earth.li with local (Exim 4.92)
        (envelope-from <noodles@earth.li>)
        id 1jzi4R-0008F6-2G; Sun, 26 Jul 2020 15:56:11 +0100
Date:   Sun, 26 Jul 2020 15:56:11 +0100
From:   Jonathan McDowell <noodles@earth.li>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Matthew Hagan <mnhagan88@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2] net: dsa: qca8k: Add 802.1q VLAN support
Message-ID: <20200726145611.GA31479@earth.li>
References: <20200721171624.GK23489@earth.li>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200721171624.GK23489@earth.li>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds full 802.1q VLAN support to the qca8k, allowing the use of
vlan_filtering and more complicated bridging setups than allowed by
basic port VLAN support.

Tested with a number of untagged ports with separate VLANs and then a
trunk port with all the VLANs tagged on it.

v2:
- Return sensible errnos on failure rather than -1 (rmk)
- Style cleanups based on Florian's feedback
- Silently allow VLAN 0 as device correctly treats this as no tag

Signed-off-by: Jonathan McDowell <noodles@earth.li>
---
 drivers/net/dsa/qca8k.c | 191 ++++++++++++++++++++++++++++++++++++++--
 drivers/net/dsa/qca8k.h |  28 ++++++
 2 files changed, 214 insertions(+), 5 deletions(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index a5566de82853..1cc61bc8929f 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -408,6 +408,111 @@ qca8k_fdb_flush(struct qca8k_priv *priv)
 	mutex_unlock(&priv->reg_mutex);
 }
 
+static int
+qca8k_vlan_access(struct qca8k_priv *priv, enum qca8k_vlan_cmd cmd, u16 vid)
+{
+	u32 reg;
+
+	/* Set the command and VLAN index */
+	reg = QCA8K_VTU_FUNC1_BUSY;
+	reg |= cmd;
+	reg |= vid << QCA8K_VTU_FUNC1_VID_S;
+
+	/* Write the function register triggering the table access */
+	qca8k_write(priv, QCA8K_REG_VTU_FUNC1, reg);
+
+	/* wait for completion */
+	if (qca8k_busy_wait(priv, QCA8K_REG_VTU_FUNC1, QCA8K_VTU_FUNC1_BUSY))
+		return -ETIMEDOUT;
+
+	/* Check for table full violation when adding an entry */
+	if (cmd == QCA8K_VLAN_LOAD) {
+		reg = qca8k_read(priv, QCA8K_REG_VTU_FUNC1);
+		if (reg & QCA8K_VTU_FUNC1_FULL)
+			return -ENOMEM;
+	}
+
+	return 0;
+}
+
+static int
+qca8k_vlan_add(struct qca8k_priv *priv, u8 port, u16 vid, bool tagged)
+{
+	u32 reg;
+	int ret;
+
+	/* We do the right thing with VLAN 0 and treat it as untagged */
+	if (vid == 0)
+		return 0;
+
+	mutex_lock(&priv->reg_mutex);
+	ret = qca8k_vlan_access(priv, QCA8K_VLAN_READ, vid);
+	if (ret < 0)
+		goto out;
+
+	reg = qca8k_read(priv, QCA8K_REG_VTU_FUNC0);
+	reg |= QCA8K_VTU_FUNC0_VALID | QCA8K_VTU_FUNC0_IVL_EN;
+	reg &= ~(3 << QCA8K_VTU_FUNC0_EG_MODE_S(port));
+	if (tagged)
+		reg |= QCA8K_VTU_FUNC0_EG_MODE_TAG <<
+				QCA8K_VTU_FUNC0_EG_MODE_S(port);
+	else
+		reg |= QCA8K_VTU_FUNC0_EG_MODE_UNTAG <<
+				QCA8K_VTU_FUNC0_EG_MODE_S(port);
+
+	qca8k_write(priv, QCA8K_REG_VTU_FUNC0, reg);
+	ret = qca8k_vlan_access(priv, QCA8K_VLAN_LOAD, vid);
+
+out:
+	mutex_unlock(&priv->reg_mutex);
+
+	return ret;
+}
+
+static int
+qca8k_vlan_del(struct qca8k_priv *priv, u8 port, u16 vid)
+{
+	u32 reg;
+	u32 mask;
+	int ret;
+	int i;
+	bool del;
+
+	mutex_lock(&priv->reg_mutex);
+	ret = qca8k_vlan_access(priv, QCA8K_VLAN_READ, vid);
+	if (ret < 0)
+		goto out;
+
+	reg = qca8k_read(priv, QCA8K_REG_VTU_FUNC0);
+	reg &= ~(3 << QCA8K_VTU_FUNC0_EG_MODE_S(port));
+	reg |= QCA8K_VTU_FUNC0_EG_MODE_NOT <<
+			QCA8K_VTU_FUNC0_EG_MODE_S(port);
+
+	/* Check if we're the last member to be removed */
+	del = true;
+	for (i = 0; i < QCA8K_NUM_PORTS; i++) {
+		mask = QCA8K_VTU_FUNC0_EG_MODE_NOT;
+		mask <<= QCA8K_VTU_FUNC0_EG_MODE_S(i);
+
+		if ((reg & mask) != mask) {
+			del = false;
+			break;
+		}
+	}
+
+	if (del) {
+		ret = qca8k_vlan_access(priv, QCA8K_VLAN_PURGE, vid);
+	} else {
+		qca8k_write(priv, QCA8K_REG_VTU_FUNC0, reg);
+		ret = qca8k_vlan_access(priv, QCA8K_VLAN_LOAD, vid);
+	}
+
+out:
+	mutex_unlock(&priv->reg_mutex);
+
+	return ret;
+}
+
 static void
 qca8k_mib_init(struct qca8k_priv *priv)
 {
@@ -663,10 +768,11 @@ qca8k_setup(struct dsa_switch *ds)
 			 * default egress vid
 			 */
 			qca8k_rmw(priv, QCA8K_EGRESS_VLAN(i),
-				  0xffff << shift, 1 << shift);
+				  0xffff << shift,
+				  QCA8K_PORT_VID_DEF << shift);
 			qca8k_write(priv, QCA8K_REG_PORT_VLAN_CTRL0(i),
-				    QCA8K_PORT_VLAN_CVID(1) |
-				    QCA8K_PORT_VLAN_SVID(1));
+				    QCA8K_PORT_VLAN_CVID(QCA8K_PORT_VID_DEF) |
+				    QCA8K_PORT_VLAN_SVID(QCA8K_PORT_VID_DEF));
 		}
 	}
 
@@ -1133,7 +1239,7 @@ qca8k_port_fdb_insert(struct qca8k_priv *priv, const u8 *addr,
 {
 	/* Set the vid to the port vlan id if no vid is set */
 	if (!vid)
-		vid = 1;
+		vid = QCA8K_PORT_VID_DEF;
 
 	return qca8k_fdb_add(priv, addr, port_mask, vid,
 			     QCA8K_ATU_STATUS_STATIC);
@@ -1157,7 +1263,7 @@ qca8k_port_fdb_del(struct dsa_switch *ds, int port,
 	u16 port_mask = BIT(port);
 
 	if (!vid)
-		vid = 1;
+		vid = QCA8K_PORT_VID_DEF;
 
 	return qca8k_fdb_del(priv, addr, port_mask, vid);
 }
@@ -1186,6 +1292,76 @@ qca8k_port_fdb_dump(struct dsa_switch *ds, int port,
 	return 0;
 }
 
+static int
+qca8k_port_vlan_filtering(struct dsa_switch *ds, int port, bool vlan_filtering)
+{
+	struct qca8k_priv *priv = ds->priv;
+
+	if (vlan_filtering) {
+		qca8k_rmw(priv, QCA8K_PORT_LOOKUP_CTRL(port),
+			  QCA8K_PORT_LOOKUP_VLAN_MODE,
+			  QCA8K_PORT_LOOKUP_VLAN_MODE_SECURE);
+	} else {
+		qca8k_rmw(priv, QCA8K_PORT_LOOKUP_CTRL(port),
+			  QCA8K_PORT_LOOKUP_VLAN_MODE,
+			  QCA8K_PORT_LOOKUP_VLAN_MODE_NONE);
+	}
+
+	return 0;
+}
+
+static int
+qca8k_port_vlan_prepare(struct dsa_switch *ds, int port,
+			const struct switchdev_obj_port_vlan *vlan)
+{
+	return 0;
+}
+
+static void
+qca8k_port_vlan_add(struct dsa_switch *ds, int port,
+		    const struct switchdev_obj_port_vlan *vlan)
+{
+	struct qca8k_priv *priv = ds->priv;
+	bool untagged = vlan->flags & BRIDGE_VLAN_INFO_UNTAGGED;
+	bool pvid = vlan->flags & BRIDGE_VLAN_INFO_PVID;
+	u16 vid;
+	int ret = 0;
+
+	for (vid = vlan->vid_begin; vid <= vlan->vid_end && !ret; ++vid)
+		ret = qca8k_vlan_add(priv, port, vid, !untagged);
+
+	if (ret)
+		dev_err(priv->dev, "Failed to add VLAN to port %d (%d)", port, ret);
+
+	if (pvid) {
+		int shift = 16 * (port % 2);
+
+		qca8k_rmw(priv, QCA8K_EGRESS_VLAN(port),
+			  0xffff << shift,
+			  vlan->vid_end << shift);
+		qca8k_write(priv, QCA8K_REG_PORT_VLAN_CTRL0(port),
+			    QCA8K_PORT_VLAN_CVID(vlan->vid_end) |
+			    QCA8K_PORT_VLAN_SVID(vlan->vid_end));
+	}
+}
+
+static int
+qca8k_port_vlan_del(struct dsa_switch *ds, int port,
+		    const struct switchdev_obj_port_vlan *vlan)
+{
+	struct qca8k_priv *priv = ds->priv;
+	u16 vid;
+	int ret = 0;
+
+	for (vid = vlan->vid_begin; vid <= vlan->vid_end && !ret; ++vid)
+		ret = qca8k_vlan_del(priv, port, vid);
+
+	if (ret)
+		dev_err(priv->dev, "Failed to delete VLAN from port %d (%d)", port, ret);
+
+	return ret;
+}
+
 static enum dsa_tag_protocol
 qca8k_get_tag_protocol(struct dsa_switch *ds, int port,
 		       enum dsa_tag_protocol mp)
@@ -1211,6 +1387,10 @@ static const struct dsa_switch_ops qca8k_switch_ops = {
 	.port_fdb_add		= qca8k_port_fdb_add,
 	.port_fdb_del		= qca8k_port_fdb_del,
 	.port_fdb_dump		= qca8k_port_fdb_dump,
+	.port_vlan_filtering	= qca8k_port_vlan_filtering,
+	.port_vlan_prepare	= qca8k_port_vlan_prepare,
+	.port_vlan_add		= qca8k_port_vlan_add,
+	.port_vlan_del		= qca8k_port_vlan_del,
 	.phylink_validate	= qca8k_phylink_validate,
 	.phylink_mac_link_state	= qca8k_phylink_mac_link_state,
 	.phylink_mac_config	= qca8k_phylink_mac_config,
@@ -1261,6 +1441,7 @@ qca8k_sw_probe(struct mdio_device *mdiodev)
 
 	priv->ds->dev = &mdiodev->dev;
 	priv->ds->num_ports = QCA8K_NUM_PORTS;
+	priv->ds->configure_vlan_while_not_filtering = true;
 	priv->ds->priv = priv;
 	priv->ops = qca8k_switch_ops;
 	priv->ds->ops = &priv->ops;
diff --git a/drivers/net/dsa/qca8k.h b/drivers/net/dsa/qca8k.h
index 31439396401c..4e96275cbc3e 100644
--- a/drivers/net/dsa/qca8k.h
+++ b/drivers/net/dsa/qca8k.h
@@ -22,6 +22,8 @@
 
 #define QCA8K_CPU_PORT					0
 
+#define QCA8K_PORT_VID_DEF				1
+
 /* Global control registers */
 #define QCA8K_REG_MASK_CTRL				0x000
 #define   QCA8K_MASK_CTRL_ID_M				0xff
@@ -126,6 +128,18 @@
 #define   QCA8K_ATU_FUNC_FULL				BIT(12)
 #define   QCA8K_ATU_FUNC_PORT_M				0xf
 #define   QCA8K_ATU_FUNC_PORT_S				8
+#define QCA8K_REG_VTU_FUNC0				0x610
+#define   QCA8K_VTU_FUNC0_VALID				BIT(20)
+#define   QCA8K_VTU_FUNC0_IVL_EN			BIT(19)
+#define   QCA8K_VTU_FUNC0_EG_MODE_S(_i)			(4 + (_i) * 2)
+#define   QCA8K_VTU_FUNC0_EG_MODE_UNMOD			0
+#define   QCA8K_VTU_FUNC0_EG_MODE_UNTAG			1
+#define   QCA8K_VTU_FUNC0_EG_MODE_TAG			2
+#define   QCA8K_VTU_FUNC0_EG_MODE_NOT			3
+#define QCA8K_REG_VTU_FUNC1				0x614
+#define   QCA8K_VTU_FUNC1_BUSY				BIT(31)
+#define   QCA8K_VTU_FUNC1_VID_S				16
+#define   QCA8K_VTU_FUNC1_FULL				BIT(4)
 #define QCA8K_REG_GLOBAL_FW_CTRL0			0x620
 #define   QCA8K_GLOBAL_FW_CTRL0_CPU_PORT_EN		BIT(10)
 #define QCA8K_REG_GLOBAL_FW_CTRL1			0x624
@@ -135,6 +149,11 @@
 #define   QCA8K_GLOBAL_FW_CTRL1_UC_DP_S			0
 #define QCA8K_PORT_LOOKUP_CTRL(_i)			(0x660 + (_i) * 0xc)
 #define   QCA8K_PORT_LOOKUP_MEMBER			GENMASK(6, 0)
+#define   QCA8K_PORT_LOOKUP_VLAN_MODE			GENMASK(9, 8)
+#define   QCA8K_PORT_LOOKUP_VLAN_MODE_NONE		(0 << 8)
+#define   QCA8K_PORT_LOOKUP_VLAN_MODE_FALLBACK		(1 << 8)
+#define   QCA8K_PORT_LOOKUP_VLAN_MODE_CHECK		(2 << 8)
+#define   QCA8K_PORT_LOOKUP_VLAN_MODE_SECURE		(3 << 8)
 #define   QCA8K_PORT_LOOKUP_STATE_MASK			GENMASK(18, 16)
 #define   QCA8K_PORT_LOOKUP_STATE_DISABLED		(0 << 16)
 #define   QCA8K_PORT_LOOKUP_STATE_BLOCKING		(1 << 16)
@@ -178,6 +197,15 @@ enum qca8k_fdb_cmd {
 	QCA8K_FDB_SEARCH = 7,
 };
 
+enum qca8k_vlan_cmd {
+	QCA8K_VLAN_FLUSH = 1,
+	QCA8K_VLAN_LOAD = 2,
+	QCA8K_VLAN_PURGE = 3,
+	QCA8K_VLAN_REMOVE_PORT = 4,
+	QCA8K_VLAN_NEXT = 5,
+	QCA8K_VLAN_READ = 6,
+};
+
 struct ar8xxx_port_status {
 	int enabled;
 };
-- 
2.20.1

