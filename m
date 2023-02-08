Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B734768F2FD
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 17:16:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231463AbjBHQQe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 11:16:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231367AbjBHQQT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 11:16:19 -0500
Received: from relay6-d.mail.gandi.net (relay6-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::226])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFA504C6DD;
        Wed,  8 Feb 2023 08:16:16 -0800 (PST)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id C2FF3C0017;
        Wed,  8 Feb 2023 16:16:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1675872975;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ralSWka2VplAf7srOOppJFqJ95/26O1dSYVu4MsPdfI=;
        b=ipIpZkHOX7u3jPIU8Iyo5FregEJtMtX+h/U70Nx+v9cF5jaL/O9+KQukq+5a/CNNyi5Gar
        tPSJyHHaMtF5uH0bGKrpOIm9M0f6UTwXF7HKYbVrejpl0YiPqi/eC+taLj2/z9ZM4Mr+YE
        cROEE8Xm+bi0+XB5mbhq+Mc495gTRG4vjUH+F+upFP58r/ETAz6Vzq+EDQZVHqJ80NEq3i
        O+D3lnrUmuxj0VT7atNh2rWPFbdx/+iGv/nQ6YI9lRvWhmNn1NjcrrlmIhGbSIhMgR8Q4/
        +4y1HRe7WVMpxBbH5nVdOxRYrUiGdYBCYuqH4O+61s/qSA6/tODUosx6Lx6LlA==
From:   =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Herve Codina <herve.codina@bootlin.com>,
        =?UTF-8?q?Miqu=C3=A8l=20Raynal?= <miquel.raynal@bootlin.com>,
        Milan Stevanovic <milan.stevanovic@se.com>,
        Jimmy Lalande <jimmy.lalande@se.com>,
        Pascal Eberhard <pascal.eberhard@se.com>,
        Arun Ramadoss <Arun.Ramadoss@microchip.com>,
        linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next v3 3/3] net: dsa: rzn1-a5psw: add vlan support
Date:   Wed,  8 Feb 2023 17:17:49 +0100
Message-Id: <20230208161749.331965-4-clement.leger@bootlin.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230208161749.331965-1-clement.leger@bootlin.com>
References: <20230208161749.331965-1-clement.leger@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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
 drivers/net/dsa/rzn1_a5psw.c | 167 +++++++++++++++++++++++++++++++++++
 drivers/net/dsa/rzn1_a5psw.h |   8 +-
 2 files changed, 172 insertions(+), 3 deletions(-)

diff --git a/drivers/net/dsa/rzn1_a5psw.c b/drivers/net/dsa/rzn1_a5psw.c
index 0ce3948952db..de6b18ec647d 100644
--- a/drivers/net/dsa/rzn1_a5psw.c
+++ b/drivers/net/dsa/rzn1_a5psw.c
@@ -583,6 +583,147 @@ static int a5psw_port_fdb_dump(struct dsa_switch *ds, int port,
 	return ret;
 }
 
+static int a5psw_port_vlan_filtering(struct dsa_switch *ds, int port,
+				     bool vlan_filtering,
+				     struct netlink_ext_ack *extack)
+{
+	u32 mask = BIT(port + A5PSW_VLAN_VERI_SHIFT) |
+		   BIT(port + A5PSW_VLAN_DISC_SHIFT);
+	struct a5psw *a5psw = ds->priv;
+	u32 val = 0;
+
+	if (vlan_filtering)
+		val = BIT(port + A5PSW_VLAN_VERI_SHIFT) |
+		      BIT(port + A5PSW_VLAN_DISC_SHIFT);
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
+	int vlan_res_id;
+
+	dev_dbg(a5psw->dev, "Add VLAN %d on port %d, %s, %s\n",
+		vid, port, tagged ? "tagged" : "untagged",
+		pvid ? "PVID" : "no PVID");
+
+	vlan_res_id = a5psw_find_vlan_entry(a5psw, vid);
+	if (vlan_res_id < 0) {
+		vlan_res_id = a5psw_get_vlan_res_entry(a5psw, vid);
+		if (vlan_res_id < 0)
+			return -EINVAL;
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
+	return 0;
+}
+
+static int a5psw_port_vlan_del(struct dsa_switch *ds, int port,
+			       const struct switchdev_obj_port_vlan *vlan)
+{
+	struct a5psw *a5psw = ds->priv;
+	u16 vid = vlan->vid;
+	int vlan_res_id;
+
+	dev_dbg(a5psw->dev, "Removing VLAN %d on port %d\n", vid, port);
+
+	vlan_res_id = a5psw_find_vlan_entry(a5psw, vid);
+	if (vlan_res_id < 0)
+		return -EINVAL;
+
+	a5psw_port_vlan_cfg(a5psw, vlan_res_id, port, false);
+	a5psw_port_vlan_tagged_cfg(a5psw, vlan_res_id, port, false);
+
+	/* Disable PVID if the vid is matching the port one */
+	if (vid == a5psw_reg_readl(a5psw, A5PSW_SYSTEM_TAGINFO(port)))
+		a5psw_reg_rmw(a5psw, A5PSW_VLAN_IN_MODE_ENA, BIT(port), 0);
+
+	return 0;
+}
+
 static u64 a5psw_read_stat(struct a5psw *a5psw, u32 offset, int port)
 {
 	u32 reg_lo, reg_hi;
@@ -700,6 +841,27 @@ static void a5psw_get_eth_ctrl_stats(struct dsa_switch *ds, int port,
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
@@ -772,6 +934,8 @@ static int a5psw_setup(struct dsa_switch *ds)
 		/* Enable management forward only for user ports */
 		if (dsa_port_is_user(dp))
 			a5psw_port_mgmtfwd_set(a5psw, port, true);
+
+		a5psw_vlan_setup(a5psw, port);
 	}
 
 	return 0;
@@ -801,6 +965,9 @@ static const struct dsa_switch_ops a5psw_switch_ops = {
 	.port_bridge_flags = a5psw_port_bridge_flags,
 	.port_stp_state_set = a5psw_port_stp_state_set,
 	.port_fast_age = a5psw_port_fast_age,
+	.port_vlan_filtering = a5psw_port_vlan_filtering,
+	.port_vlan_add = a5psw_port_vlan_add,
+	.port_vlan_del = a5psw_port_vlan_del,
 	.port_fdb_add = a5psw_port_fdb_add,
 	.port_fdb_del = a5psw_port_fdb_del,
 	.port_fdb_dump = a5psw_port_fdb_dump,
diff --git a/drivers/net/dsa/rzn1_a5psw.h b/drivers/net/dsa/rzn1_a5psw.h
index c67abd49c013..2bad2e3edc2a 100644
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
-- 
2.39.0

