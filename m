Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B1A43DD69E
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 15:11:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233813AbhHBNLQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 09:11:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233886AbhHBNK6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Aug 2021 09:10:58 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F3FAC06179C
        for <netdev@vger.kernel.org>; Mon,  2 Aug 2021 06:10:47 -0700 (PDT)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1mAXiK-0003Mb-Oa; Mon, 02 Aug 2021 15:10:40 +0200
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1mAXiJ-00008E-Hv; Mon, 02 Aug 2021 15:10:39 +0200
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
Subject: [PATCH net-next v3 3/6] net: dsa: qca: ar9331: add forwarding database support
Date:   Mon,  2 Aug 2021 15:10:34 +0200
Message-Id: <20210802131037.32326-4-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210802131037.32326-1-o.rempel@pengutronix.de>
References: <20210802131037.32326-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This switch provides simple address resolution table, without VLAN or
multicast specific information.
With this patch we are able now to read, modify unicast and multicast
addresses.

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 drivers/net/dsa/qca/ar9331.c | 349 +++++++++++++++++++++++++++++++++++
 1 file changed, 349 insertions(+)

diff --git a/drivers/net/dsa/qca/ar9331.c b/drivers/net/dsa/qca/ar9331.c
index 2f5673ea3140..d94c7ea163c4 100644
--- a/drivers/net/dsa/qca/ar9331.c
+++ b/drivers/net/dsa/qca/ar9331.c
@@ -66,6 +66,47 @@
 #define AR9331_SW_REG_GLOBAL_CTRL		0x30
 #define AR9331_SW_GLOBAL_CTRL_MFS_M		GENMASK(13, 0)
 
+/* Size of the address resolution table (ARL) */
+#define AR9331_SW_NUM_ARL_RECORDS		1024
+
+#define AR9331_SW_REG_ADDR_TABLE_FUNCTION0	0x50
+#define AR9331_SW_AT_ADDR_BYTES4		GENMASK(31, 24)
+#define AR9331_SW_AT_ADDR_BYTES5		GENMASK(23, 16)
+#define AR9331_SW_AT_FULL_VIO			BIT(12)
+#define AR9331_SW_AT_PORT_NUM			GENMASK(11, 8)
+#define AR9331_SW_AT_FLUSH_STATIC_EN		BIT(4)
+#define AR9331_SW_AT_BUSY			BIT(3)
+#define AR9331_SW_AT_FUNC			GENMASK(2, 0)
+#define AR9331_SW_AT_FUNC_NOP			0
+#define AR9331_SW_AT_FUNC_FLUSH_ALL		1
+#define AR9331_SW_AT_FUNC_LOAD_ENTRY		2
+#define AR9331_SW_AT_FUNC_PURGE_ENTRY		3
+#define AR9331_SW_AT_FUNC_FLUSH_ALL_UNLOCKED	4
+#define AR9331_SW_AT_FUNC_FLUSH_PORT		5
+#define AR9331_SW_AT_FUNC_GET_NEXT		6
+#define AR9331_SW_AT_FUNC_FIND_MAC		7
+
+#define AR9331_SW_REG_ADDR_TABLE_FUNCTION1	0x54
+#define AR9331_SW_AT_ADDR_BYTES0		GENMASK(31, 24)
+#define AR9331_SW_AT_ADDR_BYTES1		GENMASK(23, 16)
+#define AR9331_SW_AT_ADDR_BYTES2		GENMASK(15, 8)
+#define AR9331_SW_AT_ADDR_BYTES3		GENMASK(7, 0)
+
+#define AR9331_SW_REG_ADDR_TABLE_FUNCTION2	0x58
+#define AR9331_SW_AT_COPY_TO_CPU		BIT(26)
+#define AR9331_SW_AT_REDIRECT_TOCPU		BIT(25)
+#define AR9331_SW_AT_LEAKY_EN			BIT(24)
+#define AR9331_SW_AT_STATUS			GENMASK(19, 16)
+#define AR9331_SW_AT_STATUS_EMPTY		0
+/* STATUS values from 7 to 1 are different aging levels */
+#define AR9331_SW_AT_STATUS_STATIC		0xf
+
+#define AR9331_SW_AT_SA_DROP_EN			BIT(14)
+#define AR9331_SW_AT_MIRROR_EN			BIT(13)
+#define AR9331_SW_AT_PRIORITY_EN		BIT(12)
+#define AR9331_SW_AT_PRIORITY			GENMASK(11, 10)
+#define AR9331_SW_AT_DES_PORT			GENMASK(5, 0)
+
 #define AR9331_SW_REG_ADDR_TABLE_CTRL		0x5c
 #define AR9331_SW_AT_ARP_EN			BIT(20)
 #define AR9331_SW_AT_LEARN_CHANGE_EN		BIT(18)
@@ -267,6 +308,12 @@ struct ar9331_sw_port {
 	struct spinlock stats_lock;
 };
 
+struct ar9331_sw_fdb {
+	u8 port_mask;
+	u8 aging;
+	u8 mac[ETH_ALEN];
+};
+
 struct ar9331_sw_priv {
 	struct device *dev;
 	struct dsa_switch ds;
@@ -731,6 +778,302 @@ static void ar9331_get_stats64(struct dsa_switch *ds, int port,
 	spin_unlock(&p->stats_lock);
 }
 
+static int ar9331_sw_fdb_wait(struct ar9331_sw_priv *priv, u32 *f0)
+{
+	struct regmap *regmap = priv->regmap;
+
+	return regmap_read_poll_timeout(regmap,
+					AR9331_SW_REG_ADDR_TABLE_FUNCTION0,
+					*f0, !(*f0 & AR9331_SW_AT_BUSY),
+					10, 2000);
+}
+
+static int ar9331_sw_port_fdb_write(struct ar9331_sw_priv *priv,
+				    u32 f0, u32 f1, u32 f2)
+{
+	struct regmap *regmap = priv->regmap;
+	int ret;
+
+	ret = regmap_write(regmap, AR9331_SW_REG_ADDR_TABLE_FUNCTION2, f2);
+	if (ret)
+		return ret;
+
+	ret = regmap_write(regmap, AR9331_SW_REG_ADDR_TABLE_FUNCTION1, f1);
+	if (ret)
+		return ret;
+
+	return regmap_write(regmap, AR9331_SW_REG_ADDR_TABLE_FUNCTION0, f0);
+}
+
+static int ar9331_sw_fdb_next(struct ar9331_sw_priv *priv,
+			      struct ar9331_sw_fdb *fdb, int port)
+{
+	struct regmap *regmap = priv->regmap;
+	unsigned int status, ports;
+	u32 f0, f1, f2;
+	int ret;
+
+	/* Keep AT_ADDR_BYTES4/5 to search next entry after current */
+	ret = regmap_update_bits(regmap, AR9331_SW_REG_ADDR_TABLE_FUNCTION0,
+				 AR9331_SW_AT_FUNC | AR9331_SW_AT_BUSY,
+				 AR9331_SW_AT_BUSY |
+				 FIELD_PREP(AR9331_SW_AT_FUNC,
+					    AR9331_SW_AT_FUNC_GET_NEXT));
+	if (ret)
+		return ret;
+
+	ret = ar9331_sw_fdb_wait(priv, &f0);
+	if (ret)
+		return ret;
+
+	ret = regmap_read(regmap, AR9331_SW_REG_ADDR_TABLE_FUNCTION2, &f2);
+	if (ret)
+		return ret;
+
+	/* If the hardware returns an MAC != 0 and the AT_STATUS is zero, there
+	 * is no next valid entry in the address table.
+	 */
+	status = FIELD_GET(AR9331_SW_AT_STATUS, f2);
+	fdb->aging = status;
+	if (!status)
+		return 0;
+
+	ret = regmap_read(regmap, AR9331_SW_REG_ADDR_TABLE_FUNCTION1, &f1);
+	if (ret)
+		return ret;
+
+	fdb->mac[0] = FIELD_GET(AR9331_SW_AT_ADDR_BYTES0, f1);
+	fdb->mac[1] = FIELD_GET(AR9331_SW_AT_ADDR_BYTES1, f1);
+	fdb->mac[2] = FIELD_GET(AR9331_SW_AT_ADDR_BYTES2, f1);
+	fdb->mac[3] = FIELD_GET(AR9331_SW_AT_ADDR_BYTES3, f1);
+	fdb->mac[4] = FIELD_GET(AR9331_SW_AT_ADDR_BYTES4, f0);
+	fdb->mac[5] = FIELD_GET(AR9331_SW_AT_ADDR_BYTES5, f0);
+
+	ports = FIELD_GET(AR9331_SW_AT_DES_PORT, f2);
+	if (!(ports & BIT(port)))
+		return -EAGAIN;
+
+	return 0;
+}
+
+static void ar9331_sw_port_fdb_prepare(const unsigned char *mac, u32 *f0,
+				       u32 *f1, unsigned int func)
+{
+	*f1 = FIELD_PREP(AR9331_SW_AT_ADDR_BYTES0, mac[0]) |
+	      FIELD_PREP(AR9331_SW_AT_ADDR_BYTES1, mac[1]) |
+	      FIELD_PREP(AR9331_SW_AT_ADDR_BYTES2, mac[2]) |
+	      FIELD_PREP(AR9331_SW_AT_ADDR_BYTES3, mac[3]);
+	*f0 = FIELD_PREP(AR9331_SW_AT_ADDR_BYTES4, mac[4]) |
+	      FIELD_PREP(AR9331_SW_AT_ADDR_BYTES5, mac[5]) |
+	      FIELD_PREP(AR9331_SW_AT_FUNC, func) | AR9331_SW_AT_BUSY;
+}
+
+static int ar9331_sw_port_fdb_dump(struct dsa_switch *ds, int port,
+				   dsa_fdb_dump_cb_t *cb, void *data)
+{
+	struct ar9331_sw_priv *priv = (struct ar9331_sw_priv *)ds->priv;
+	int cnt = AR9331_SW_NUM_ARL_RECORDS;
+	struct ar9331_sw_fdb fdb = { 0 };
+	bool is_static;
+	int ret;
+	u32 f0;
+
+	/* Make sure no pending operation is in progress. Since no timeout and
+	 * interval values are documented, we use here "seems to be sane, works
+	 * for me" values.
+	 */
+	ret = ar9331_sw_fdb_wait(priv, &f0);
+	if (ret)
+		return ret;
+
+	/* If the address and the AT_STATUS are both zero, the hardware will
+	 * search the first valid entry from entry0.
+	 * If the address is set to zero and the AT_STATUS is not zero, the
+	 * hardware will discover the next valid entry which has an address
+	 * of 0x0.
+	 */
+	ret = ar9331_sw_port_fdb_write(priv, 0, 0, 0);
+	if (ret)
+		return ret;
+
+	while (cnt--) {
+		ret = ar9331_sw_fdb_next(priv, &fdb, port);
+		if (ret == -EAGAIN)
+			continue;
+		else if (ret)
+			return ret;
+
+		if (!fdb.aging)
+			break;
+
+		is_static = (fdb.aging == AR9331_SW_AT_STATUS_STATIC);
+		ret = cb(fdb.mac, 0, is_static, data);
+		if (ret)
+			break;
+	}
+
+	return ret;
+}
+
+static int ar9331_sw_port_fdb_rmw(struct ar9331_sw_priv *priv,
+				  const unsigned char *mac,
+				  u8 port_mask_set,
+				  u8 port_mask_clr)
+{
+	u8 port_mask, port_mask_new, status, func;
+	struct regmap *regmap = priv->regmap;
+	u32 f0, f1, f2 = 0;
+	int ret;
+
+	ret = ar9331_sw_fdb_wait(priv, &f0);
+	if (ret)
+		return ret;
+
+	ar9331_sw_port_fdb_prepare(mac, &f0, &f1, AR9331_SW_AT_FUNC_FIND_MAC);
+
+	ret = ar9331_sw_port_fdb_write(priv, f0, f1, f2);
+	if (ret)
+		return ret;
+
+	ret = ar9331_sw_fdb_wait(priv, &f0);
+	if (ret)
+		return ret;
+
+	ret = regmap_read(regmap, AR9331_SW_REG_ADDR_TABLE_FUNCTION2, &f2);
+	if (ret)
+		return ret;
+
+	port_mask = FIELD_GET(AR9331_SW_AT_DES_PORT, f2);
+	status = FIELD_GET(AR9331_SW_AT_STATUS, f2);
+	if (status > 0 && status < AR9331_SW_AT_STATUS_STATIC) {
+		dev_dbg(priv->dev, "%s: found existing dynamic entry on %x\n",
+			__func__, port_mask);
+
+		if (port_mask_set && port_mask_set != port_mask)
+			dev_dbg(priv->dev, "%s: found existing dynamic entry on %x, replacing it with static on %x\n",
+				__func__, port_mask, port_mask_set);
+		port_mask = 0;
+	} else if (!status && !port_mask_set) {
+		return 0;
+	}
+
+	port_mask_new = port_mask & ~port_mask_clr;
+	port_mask_new |= port_mask_set;
+
+	if (port_mask_new == port_mask &&
+	    status == AR9331_SW_AT_STATUS_STATIC) {
+		dev_dbg(priv->dev, "%s: no need to overwrite existing valid entry on %x\n",
+			__func__, port_mask_new);
+		return 0;
+	}
+
+	if (port_mask_new) {
+		func = AR9331_SW_AT_FUNC_LOAD_ENTRY;
+	} else {
+		func = AR9331_SW_AT_FUNC_PURGE_ENTRY;
+		port_mask_new = port_mask;
+	}
+
+	f2 = FIELD_PREP(AR9331_SW_AT_DES_PORT, port_mask_new) |
+		FIELD_PREP(AR9331_SW_AT_STATUS, AR9331_SW_AT_STATUS_STATIC);
+
+	ar9331_sw_port_fdb_prepare(mac, &f0, &f1, func);
+
+	ret = ar9331_sw_port_fdb_write(priv, f0, f1, f2);
+	if (ret)
+		return ret;
+
+	ret = ar9331_sw_fdb_wait(priv, &f0);
+	if (ret)
+		return ret;
+
+	if (f0 & AR9331_SW_AT_FULL_VIO) {
+		/* cleanup error status */
+		regmap_write(regmap, AR9331_SW_REG_ADDR_TABLE_FUNCTION0, 0);
+		dev_err(priv->dev, "%s: can't add new entry, ATU is full\n", __func__);
+		return -ENOMEM;
+	}
+
+	return 0;
+}
+
+static int ar9331_sw_port_fdb_add(struct dsa_switch *ds, int port,
+				  const unsigned char *mac, u16 vid)
+{
+	struct ar9331_sw_priv *priv = (struct ar9331_sw_priv *)ds->priv;
+	u16 port_mask = BIT(port);
+
+	if (vid)
+		return -EINVAL;
+
+	return ar9331_sw_port_fdb_rmw(priv, mac, port_mask, 0);
+}
+
+static int ar9331_sw_port_fdb_del(struct dsa_switch *ds, int port,
+				  const unsigned char *mac, u16 vid)
+{
+	struct ar9331_sw_priv *priv = (struct ar9331_sw_priv *)ds->priv;
+	u16 port_mask = BIT(port);
+
+	if (vid)
+		return -EINVAL;
+
+	return ar9331_sw_port_fdb_rmw(priv, mac, 0, port_mask);
+}
+
+static int ar9331_sw_port_mdb_add(struct dsa_switch *ds, int port,
+				  const struct switchdev_obj_port_mdb *mdb)
+{
+	struct ar9331_sw_priv *priv = (struct ar9331_sw_priv *)ds->priv;
+	u16 port_mask = BIT(port);
+
+	if (mdb->vid)
+		return -EOPNOTSUPP;
+
+	return ar9331_sw_port_fdb_rmw(priv, mdb->addr, port_mask, 0);
+}
+
+static int ar9331_sw_port_mdb_del(struct dsa_switch *ds, int port,
+				  const struct switchdev_obj_port_mdb *mdb)
+{
+	struct ar9331_sw_priv *priv = (struct ar9331_sw_priv *)ds->priv;
+	u16 port_mask = BIT(port);
+
+	if (mdb->vid)
+		return -EOPNOTSUPP;
+
+	return ar9331_sw_port_fdb_rmw(priv, mdb->addr, 0, port_mask);
+}
+
+static void ar9331_sw_port_fast_age(struct dsa_switch *ds, int port)
+{
+	struct ar9331_sw_priv *priv = (struct ar9331_sw_priv *)ds->priv;
+	struct regmap *regmap = priv->regmap;
+	int ret;
+	u32 f0;
+
+	ret = ar9331_sw_fdb_wait(priv, &f0);
+	if (ret)
+		goto error;
+
+	/* Flush all non static unicast address on a given port */
+	f0 = FIELD_PREP(AR9331_SW_AT_PORT_NUM, port) |
+		FIELD_PREP(AR9331_SW_AT_FUNC, AR9331_SW_AT_FUNC_FLUSH_PORT) |
+		AR9331_SW_AT_BUSY;
+
+	ret = regmap_write(regmap, AR9331_SW_REG_ADDR_TABLE_FUNCTION0, f0);
+	if (ret)
+		goto error;
+
+	ret = ar9331_sw_fdb_wait(priv, &f0);
+	if (ret)
+		goto error;
+
+	return;
+error:
+	dev_err(priv->dev, "%s: error: %i\n", __func__, ret);
+}
+
 static const struct dsa_switch_ops ar9331_sw_ops = {
 	.get_tag_protocol	= ar9331_sw_get_tag_protocol,
 	.setup			= ar9331_sw_setup,
@@ -740,6 +1083,12 @@ static const struct dsa_switch_ops ar9331_sw_ops = {
 	.phylink_mac_link_down	= ar9331_sw_phylink_mac_link_down,
 	.phylink_mac_link_up	= ar9331_sw_phylink_mac_link_up,
 	.get_stats64		= ar9331_get_stats64,
+	.port_fast_age          = ar9331_sw_port_fast_age,
+	.port_fdb_del		= ar9331_sw_port_fdb_del,
+	.port_fdb_add		= ar9331_sw_port_fdb_add,
+	.port_fdb_dump		= ar9331_sw_port_fdb_dump,
+	.port_mdb_add           = ar9331_sw_port_mdb_add,
+	.port_mdb_del           = ar9331_sw_port_mdb_del,
 };
 
 static irqreturn_t ar9331_sw_irq(int irq, void *data)
-- 
2.30.2

