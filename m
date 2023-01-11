Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E2C8665AE4
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 12:59:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233861AbjAKL7K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 06:59:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233901AbjAKL6l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 06:58:41 -0500
Received: from relay7-d.mail.gandi.net (relay7-d.mail.gandi.net [217.70.183.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9B82EE20;
        Wed, 11 Jan 2023 03:54:22 -0800 (PST)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 3178820002;
        Wed, 11 Jan 2023 11:54:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1673438061;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=vtTWhKMn6fz/4f4AIzfy0Nm+S7hjHo9VA3x1ewZ7ex0=;
        b=jpxlWv6dqI2EA79phngp/E0jApo9TXkBUEyVeFBwhN17V5+lm6XOFetPn7RIZvlhLvfq9Y
        LvxDrY24isG+CjL1YzeYfsFhbKkSW5t9a9HA659Sj/dB2DatcB5j8VxOkSdy5P2AB1piEO
        pfO2gtAU1nHTp4muhRtUH+JeTlO8pdXnA5+FyMKONryqA81x0mEsY9acOoLFIR4oVRK/46
        oViMLQTohkTjXXSq13NFoIqhg+SQLq4/fo6i4yd//K7pS5c6A0fVXYLET/WdWTyeENg2Zk
        c3pV9af787pOzgRq66Po9v6ypcP1LOShn0KOUMVVXy/NFuX6lxGS2CjSERZfmQ==
From:   =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>,
        linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Herve Codina <herve.codina@bootlin.com>,
        =?UTF-8?q?Miqu=C3=A8l=20Raynal?= <miquel.raynal@bootlin.com>,
        Milan Stevanovic <milan.stevanovic@se.com>,
        Jimmy Lalande <jimmy.lalande@se.com>,
        Pascal Eberhard <pascal.eberhard@se.com>
Subject: [PATCH net-next] net: dsa: rzn1-a5psw: Add vlan support
Date:   Wed, 11 Jan 2023 12:56:07 +0100
Message-Id: <20230111115607.1146502-1-clement.leger@bootlin.com>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for vlan operation (add, del, filtering) on the RZN1
driver. The a5psw switch supports up to 32 VLAN IDs with filtering,
tagged/untagged VLANs and PVID for each ports.

Signed-off-by: Clément Léger <clement.leger@bootlin.com>
---
 drivers/net/dsa/rzn1_a5psw.c | 182 +++++++++++++++++++++++++++++++++++
 drivers/net/dsa/rzn1_a5psw.h |  10 +-
 2 files changed, 189 insertions(+), 3 deletions(-)

diff --git a/drivers/net/dsa/rzn1_a5psw.c b/drivers/net/dsa/rzn1_a5psw.c
index ed413d555bec..8ecb9214b5e6 100644
--- a/drivers/net/dsa/rzn1_a5psw.c
+++ b/drivers/net/dsa/rzn1_a5psw.c
@@ -540,6 +540,161 @@ static int a5psw_port_fdb_dump(struct dsa_switch *ds, int port,
 	return ret;
 }
 
+static int a5psw_port_vlan_filtering(struct dsa_switch *ds, int port,
+				     bool vlan_filtering,
+				     struct netlink_ext_ack *extack)
+{
+	u32 mask = BIT(port + A5PSW_VLAN_VERI_SHIFT)
+		   | BIT(port + A5PSW_VLAN_DISC_SHIFT);
+	struct a5psw *a5psw = ds->priv;
+	u32 val = 0;
+
+	if (vlan_filtering)
+		val = BIT(port + A5PSW_VLAN_VERI_SHIFT)
+		      | BIT(port + A5PSW_VLAN_DISC_SHIFT);
+
+	a5psw_reg_rmw(a5psw, A5PSW_VLAN_VERIFY, mask, val);
+
+	return 0;
+}
+
+static int a5psw_find_vlan_entry(struct a5psw *a5psw, u16 vid)
+{
+	u32 vlan_res;
+	int i;
+
+	/* Find vlan for this port */
+	for (i = 0; i < A5PSW_VLAN_COUNT; i++) {
+		vlan_res = a5psw_reg_readl(a5psw, A5PSW_VLAN_RES(i));
+		if (FIELD_GET(A5PSW_VLAN_RES_VLANID, vlan_res) == vid)
+			return i;
+	}
+
+	return -1;
+}
+
+static int a5psw_get_vlan_res_entry(struct a5psw *a5psw, u16 newvid)
+{
+	u32 vlan_res;
+	int i;
+
+	/* Find a free VLAN entry */
+	for (i = 0; i < A5PSW_VLAN_COUNT; i++) {
+		vlan_res = a5psw_reg_readl(a5psw, A5PSW_VLAN_RES(i));
+		if (!(FIELD_GET(A5PSW_VLAN_RES_PORTMASK, vlan_res))) {
+			vlan_res = FIELD_PREP(A5PSW_VLAN_RES_VLANID, newvid);
+			a5psw_reg_writel(a5psw, A5PSW_VLAN_RES(i), vlan_res);
+			return i;
+		}
+	}
+
+	return -1;
+}
+
+static void a5psw_port_vlan_tagged_cfg(struct a5psw *a5psw, int vlan_res_id,
+				       int port, bool set)
+{
+	u32 mask = A5PSW_VLAN_RES_WR_PORTMASK | A5PSW_VLAN_RES_RD_TAGMASK |
+		   BIT(port);
+	u32 vlan_res_off = A5PSW_VLAN_RES(vlan_res_id);
+	u32 val = A5PSW_VLAN_RES_WR_TAGMASK, reg;
+
+	if (set)
+		val |= BIT(port);
+
+	/* Toggle tag mask read */
+	a5psw_reg_writel(a5psw, vlan_res_off, A5PSW_VLAN_RES_RD_TAGMASK);
+	reg = a5psw_reg_readl(a5psw, vlan_res_off);
+	a5psw_reg_writel(a5psw, vlan_res_off, A5PSW_VLAN_RES_RD_TAGMASK);
+
+	reg &= ~mask;
+	reg |= val;
+	a5psw_reg_writel(a5psw, vlan_res_off, reg);
+}
+
+static void a5psw_port_vlan_cfg(struct a5psw *a5psw, int vlan_res_id, int port,
+				bool set)
+{
+	u32 mask = A5PSW_VLAN_RES_WR_TAGMASK | BIT(port);
+	u32 reg = A5PSW_VLAN_RES_WR_PORTMASK;
+
+	if (set)
+		reg |= BIT(port);
+
+	a5psw_reg_rmw(a5psw, A5PSW_VLAN_RES(vlan_res_id), mask, reg);
+}
+
+static int a5psw_port_vlan_add(struct dsa_switch *ds, int port,
+			       const struct switchdev_obj_port_vlan *vlan,
+			       struct netlink_ext_ack *extack)
+{
+	bool tagged = !(vlan->flags & BRIDGE_VLAN_INFO_UNTAGGED);
+	bool pvid = vlan->flags & BRIDGE_VLAN_INFO_PVID;
+	struct a5psw *a5psw = ds->priv;
+	u16 vid = vlan->vid;
+	int ret = -EINVAL;
+	int vlan_res_id;
+
+	dev_dbg(a5psw->dev, "Add VLAN %d on port %d, %s, %s\n",
+		vid, port, tagged ? "tagged" : "untagged",
+		pvid ? "PVID" : "no PVID");
+
+	mutex_lock(&a5psw->vlan_lock);
+
+	vlan_res_id = a5psw_find_vlan_entry(a5psw, vid);
+	if (vlan_res_id < 0) {
+		vlan_res_id = a5psw_get_vlan_res_entry(a5psw, vid);
+		if (vlan_res_id < 0)
+			goto out;
+	}
+
+	a5psw_port_vlan_cfg(a5psw, vlan_res_id, port, true);
+	if (tagged)
+		a5psw_port_vlan_tagged_cfg(a5psw, vlan_res_id, port, true);
+
+	if (pvid) {
+		a5psw_reg_rmw(a5psw, A5PSW_VLAN_IN_MODE_ENA, BIT(port),
+			      BIT(port));
+		a5psw_reg_writel(a5psw, A5PSW_SYSTEM_TAGINFO(port), vid);
+	}
+
+	ret = 0;
+out:
+	mutex_unlock(&a5psw->vlan_lock);
+
+	return ret;
+}
+
+static int a5psw_port_vlan_del(struct dsa_switch *ds, int port,
+			       const struct switchdev_obj_port_vlan *vlan)
+{
+	struct a5psw *a5psw = ds->priv;
+	u16 vid = vlan->vid;
+	int ret = -EINVAL;
+	int vlan_res_id;
+
+	dev_dbg(a5psw->dev, "Removing VLAN %d on port %d\n", vid, port);
+
+	mutex_lock(&a5psw->vlan_lock);
+
+	vlan_res_id = a5psw_find_vlan_entry(a5psw, vid);
+	if (vlan_res_id < 0)
+		goto out;
+
+	a5psw_port_vlan_cfg(a5psw, vlan_res_id, port, false);
+	a5psw_port_vlan_tagged_cfg(a5psw, vlan_res_id, port, false);
+
+	/* Disable PVID if the vid is matching the port one */
+	if (vid == a5psw_reg_readl(a5psw, A5PSW_SYSTEM_TAGINFO(port)))
+		a5psw_reg_rmw(a5psw, A5PSW_VLAN_IN_MODE_ENA, BIT(port), 0);
+
+	ret = 0;
+out:
+	mutex_unlock(&a5psw->vlan_lock);
+
+	return ret;
+}
+
 static u64 a5psw_read_stat(struct a5psw *a5psw, u32 offset, int port)
 {
 	u32 reg_lo, reg_hi;
@@ -657,6 +812,27 @@ static void a5psw_get_eth_ctrl_stats(struct dsa_switch *ds, int port,
 	ctrl_stats->MACControlFramesReceived = stat;
 }
 
+static void a5psw_vlan_setup(struct a5psw *a5psw, int port)
+{
+	u32 reg;
+
+	/* Enable TAG always mode for the port, this is actually controlled
+	 * by VLAN_IN_MODE_ENA field which will be used for PVID insertion
+	 */
+	reg = A5PSW_VLAN_IN_MODE_TAG_ALWAYS;
+	reg <<= A5PSW_VLAN_IN_MODE_PORT_SHIFT(port);
+	a5psw_reg_rmw(a5psw, A5PSW_VLAN_IN_MODE, A5PSW_VLAN_IN_MODE_PORT(port),
+		      reg);
+
+	/* Set transparent mode for output frame manipulation, this will depend
+	 * on the VLAN_RES configuration mode
+	 */
+	reg = A5PSW_VLAN_OUT_MODE_TRANSPARENT;
+	reg <<= A5PSW_VLAN_OUT_MODE_PORT_SHIFT(port);
+	a5psw_reg_rmw(a5psw, A5PSW_VLAN_OUT_MODE,
+		      A5PSW_VLAN_OUT_MODE_PORT(port), reg);
+}
+
 static int a5psw_setup(struct dsa_switch *ds)
 {
 	struct a5psw *a5psw = ds->priv;
@@ -729,6 +905,8 @@ static int a5psw_setup(struct dsa_switch *ds)
 		/* Enable management forward only for user ports */
 		if (dsa_port_is_user(dp))
 			a5psw_port_mgmtfwd_set(a5psw, port, true);
+
+		a5psw_vlan_setup(a5psw, port);
 	}
 
 	return 0;
@@ -756,6 +934,9 @@ static const struct dsa_switch_ops a5psw_switch_ops = {
 	.port_bridge_leave = a5psw_port_bridge_leave,
 	.port_stp_state_set = a5psw_port_stp_state_set,
 	.port_fast_age = a5psw_port_fast_age,
+	.port_vlan_filtering = a5psw_port_vlan_filtering,
+	.port_vlan_add = a5psw_port_vlan_add,
+	.port_vlan_del = a5psw_port_vlan_del,
 	.port_fdb_add = a5psw_port_fdb_add,
 	.port_fdb_del = a5psw_port_fdb_del,
 	.port_fdb_dump = a5psw_port_fdb_dump,
@@ -945,6 +1126,7 @@ static int a5psw_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	a5psw->dev = dev;
+	mutex_init(&a5psw->vlan_lock);
 	mutex_init(&a5psw->lk_lock);
 	spin_lock_init(&a5psw->reg_lock);
 	a5psw->base = devm_platform_ioremap_resource(pdev, 0);
diff --git a/drivers/net/dsa/rzn1_a5psw.h b/drivers/net/dsa/rzn1_a5psw.h
index c67abd49c013..614453d9a59e 100644
--- a/drivers/net/dsa/rzn1_a5psw.h
+++ b/drivers/net/dsa/rzn1_a5psw.h
@@ -50,7 +50,9 @@
 #define A5PSW_VLAN_IN_MODE_TAG_ALWAYS		0x2
 
 #define A5PSW_VLAN_OUT_MODE		0x2C
-#define A5PSW_VLAN_OUT_MODE_PORT(port)	(GENMASK(1, 0) << ((port) * 2))
+#define A5PSW_VLAN_OUT_MODE_PORT_SHIFT(port)	((port) * 2)
+#define A5PSW_VLAN_OUT_MODE_PORT(port)	(GENMASK(1, 0) << \
+					A5PSW_VLAN_OUT_MODE_PORT_SHIFT(port))
 #define A5PSW_VLAN_OUT_MODE_DIS		0x0
 #define A5PSW_VLAN_OUT_MODE_STRIP	0x1
 #define A5PSW_VLAN_OUT_MODE_TAG_THROUGH	0x2
@@ -59,7 +61,7 @@
 #define A5PSW_VLAN_IN_MODE_ENA		0x30
 #define A5PSW_VLAN_TAG_ID		0x34
 
-#define A5PSW_SYSTEM_TAGINFO(port)	(0x200 + A5PSW_PORT_OFFSET(port))
+#define A5PSW_SYSTEM_TAGINFO(port)	(0x200 + 4 * (port))
 
 #define A5PSW_AUTH_PORT(port)		(0x240 + 4 * (port))
 #define A5PSW_AUTH_PORT_AUTHORIZED	BIT(0)
@@ -68,7 +70,7 @@
 #define A5PSW_VLAN_RES_WR_PORTMASK	BIT(30)
 #define A5PSW_VLAN_RES_WR_TAGMASK	BIT(29)
 #define A5PSW_VLAN_RES_RD_TAGMASK	BIT(28)
-#define A5PSW_VLAN_RES_ID		GENMASK(16, 5)
+#define A5PSW_VLAN_RES_VLANID		GENMASK(16, 5)
 #define A5PSW_VLAN_RES_PORTMASK		GENMASK(4, 0)
 
 #define A5PSW_RXMATCH_CONFIG(port)	(0x3e80 + 4 * (port))
@@ -240,6 +242,7 @@ union lk_data {
  * @ds: DSA switch struct
  * @stats_lock: lock to access statistics (shared HI counter)
  * @lk_lock: Lock for the lookup table
+ * @vlan_lock: Lock for the vlan operation
  * @reg_lock: Lock for register read-modify-write operation
  * @bridged_ports: Mask of ports that are bridged and should be flooded
  * @br_dev: Bridge net device
@@ -253,6 +256,7 @@ struct a5psw {
 	struct phylink_pcs *pcs[A5PSW_PORTS_NUM - 1];
 	struct dsa_switch ds;
 	struct mutex lk_lock;
+	struct mutex vlan_lock;
 	spinlock_t reg_lock;
 	u32 bridged_ports;
 	struct net_device *br_dev;
-- 
2.39.0

