Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 429BB50FFB8
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 15:56:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351283AbiDZN6m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 09:58:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232625AbiDZN6d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 09:58:33 -0400
X-Greylist: delayed 348 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 26 Apr 2022 06:55:24 PDT
Received: from mxout3.routing.net (mxout3.routing.net [IPv6:2a03:2900:1:a::8])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E852B11161
        for <netdev@vger.kernel.org>; Tue, 26 Apr 2022 06:55:23 -0700 (PDT)
Received: from mxbox3.masterlogin.de (unknown [192.168.10.78])
        by mxout3.routing.net (Postfix) with ESMTP id 7C63A604E7;
        Tue, 26 Apr 2022 13:49:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailerdienst.de;
        s=20200217; t=1650980975;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6jTVoJoSuZ+zKU9/cyXVGH1N5uHRu6ZfzkxNTQ8xK/k=;
        b=oAVOfnoClJRUJsrvWGj/RxqWclN/S8DQTgFfNVQTpop5UhcQsNkH0NFqLaZX/uVpRG9VlF
        rvm1P+4JfHdOsyaIBWo+V6Qzq0IL0bL47cX4AYbDi574G1XndLLjNCzaZ29rGD8rde6lI3
        wICrf4vnfWDyIHlmd8PLLGyipTdvM6I=
Received: from localhost.localdomain (fttx-pool-80.245.77.37.bambit.de [80.245.77.37])
        by mxbox3.masterlogin.de (Postfix) with ESMTPSA id 873B53606E6;
        Tue, 26 Apr 2022 13:49:34 +0000 (UTC)
From:   Frank Wunderlich <linux@fw-web.de>
To:     linux-mediatek@lists.infradead.org,
        linux-rockchip@lists.infradead.org
Cc:     Frank Wunderlich <frank-w@public-files.de>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Peter Geis <pgwipeout@gmail.com>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [RFC v1 2/3] net: dsa: mt753x: make CPU-Port dynamic
Date:   Tue, 26 Apr 2022 15:49:23 +0200
Message-Id: <20220426134924.30372-3-linux@fw-web.de>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220426134924.30372-1-linux@fw-web.de>
References: <20220426134924.30372-1-linux@fw-web.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Mail-ID: a85721db-24ff-47c7-afcd-beff66f08711
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Frank Wunderlich <frank-w@public-files.de>

Currently CPU-Port is hardcoded to Port 6.

On BPI-R2-Pro board this port is not connected and only Port 5 is
connected to gmac of SoC.

Replace this hardcoded CPU-Port with a member in mt7530_priv struct
which is set in mt753x_cpu_port_enable to the right port.

I defined a default in probe (in case no CPU-Port will be setup) and
if both cpu-port were setup port 6 will be used like the const prior
this patch.

In mt7531_setup first access is before we know which port should be used
(mt753x_cpu_port_enable) so section "BPDU to CPU port" needs to be moved
down.

Signed-off-by: Frank Wunderlich <frank-w@public-files.de>
---
 drivers/net/dsa/mt7530.c | 46 ++++++++++++++++++++++------------------
 drivers/net/dsa/mt7530.h |  2 +-
 2 files changed, 26 insertions(+), 22 deletions(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index ccf4cb944167..4789105b8137 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -1004,6 +1004,7 @@ mt753x_cpu_port_enable(struct dsa_switch *ds, int port)
 			return ret;
 	}
 
+	priv->cpu_port = port;
 	/* Enable Mediatek header mode on the cpu port */
 	mt7530_write(priv, MT7530_PVC_P(port),
 		     PORT_SPEC_TAG);
@@ -1041,7 +1042,7 @@ mt7530_port_enable(struct dsa_switch *ds, int port,
 	 * restore the port matrix if the port is the member of a certain
 	 * bridge.
 	 */
-	priv->ports[port].pm |= PCR_MATRIX(BIT(MT7530_CPU_PORT));
+	priv->ports[port].pm |= PCR_MATRIX(BIT(priv->cpu_port));
 	priv->ports[port].enable = true;
 	mt7530_rmw(priv, MT7530_PCR_P(port), PCR_MATRIX_MASK,
 		   priv->ports[port].pm);
@@ -1190,8 +1191,8 @@ mt7530_port_bridge_join(struct dsa_switch *ds, int port,
 			struct netlink_ext_ack *extack)
 {
 	struct dsa_port *dp = dsa_to_port(ds, port), *other_dp;
-	u32 port_bitmap = BIT(MT7530_CPU_PORT);
 	struct mt7530_priv *priv = ds->priv;
+	u32 port_bitmap = BIT(priv->cpu_port);
 
 	mutex_lock(&priv->reg_mutex);
 
@@ -1267,9 +1268,9 @@ mt7530_port_set_vlan_unaware(struct dsa_switch *ds, int port)
 	 * the CPU port get out of VLAN filtering mode.
 	 */
 	if (all_user_ports_removed) {
-		mt7530_write(priv, MT7530_PCR_P(MT7530_CPU_PORT),
+		mt7530_write(priv, MT7530_PCR_P(priv->cpu_port),
 			     PCR_MATRIX(dsa_user_ports(priv->ds)));
-		mt7530_write(priv, MT7530_PVC_P(MT7530_CPU_PORT), PORT_SPEC_TAG
+		mt7530_write(priv, MT7530_PVC_P(priv->cpu_port), PORT_SPEC_TAG
 			     | PVC_EG_TAG(MT7530_VLAN_EG_CONSISTENT));
 	}
 }
@@ -1335,8 +1336,8 @@ mt7530_port_bridge_leave(struct dsa_switch *ds, int port,
 	 */
 	if (priv->ports[port].enable)
 		mt7530_rmw(priv, MT7530_PCR_P(port), PCR_MATRIX_MASK,
-			   PCR_MATRIX(BIT(MT7530_CPU_PORT)));
-	priv->ports[port].pm = PCR_MATRIX(BIT(MT7530_CPU_PORT));
+			   PCR_MATRIX(BIT(priv->cpu_port)));
+	priv->ports[port].pm = PCR_MATRIX(BIT(priv->cpu_port));
 
 	/* When a port is removed from the bridge, the port would be set up
 	 * back to the default as is at initial boot which is a VLAN-unaware
@@ -1503,6 +1504,7 @@ static int
 mt7530_port_vlan_filtering(struct dsa_switch *ds, int port, bool vlan_filtering,
 			   struct netlink_ext_ack *extack)
 {
+	struct mt7530_priv *priv = ds->priv;
 	if (vlan_filtering) {
 		/* The port is being kept as VLAN-unaware port when bridge is
 		 * set up with vlan_filtering not being set, Otherwise, the
@@ -1510,7 +1512,7 @@ mt7530_port_vlan_filtering(struct dsa_switch *ds, int port, bool vlan_filtering,
 		 * for becoming a VLAN-aware port.
 		 */
 		mt7530_port_set_vlan_aware(ds, port);
-		mt7530_port_set_vlan_aware(ds, MT7530_CPU_PORT);
+		mt7530_port_set_vlan_aware(ds, priv->cpu_port);
 	} else {
 		mt7530_port_set_vlan_unaware(ds, port);
 	}
@@ -1526,7 +1528,7 @@ mt7530_hw_vlan_add(struct mt7530_priv *priv,
 	u32 val;
 
 	new_members = entry->old_members | BIT(entry->port) |
-		      BIT(MT7530_CPU_PORT);
+		      BIT(priv->cpu_port);
 
 	/* Validate the entry with independent learning, create egress tag per
 	 * VLAN and joining the port as one of the port members.
@@ -1550,8 +1552,8 @@ mt7530_hw_vlan_add(struct mt7530_priv *priv,
 	 * DSA tag.
 	 */
 	mt7530_rmw(priv, MT7530_VAWD2,
-		   ETAG_CTRL_P_MASK(MT7530_CPU_PORT),
-		   ETAG_CTRL_P(MT7530_CPU_PORT,
+		   ETAG_CTRL_P_MASK(priv->cpu_port),
+		   ETAG_CTRL_P(priv->cpu_port,
 			       MT7530_VLAN_EGRESS_STACK));
 }
 
@@ -1575,7 +1577,7 @@ mt7530_hw_vlan_del(struct mt7530_priv *priv,
 	 * the entry would be kept valid. Otherwise, the entry is got to be
 	 * disabled.
 	 */
-	if (new_members && new_members != BIT(MT7530_CPU_PORT)) {
+	if (new_members && new_members != BIT(priv->cpu_port)) {
 		val = IVL_MAC | VTAG_EN | PORT_MEM(new_members) |
 		      VLAN_VALID;
 		mt7530_write(priv, MT7530_VAWD1, val);
@@ -2105,7 +2107,7 @@ mt7530_setup(struct dsa_switch *ds)
 	 * controller also is the container for two GMACs nodes representing
 	 * as two netdev instances.
 	 */
-	dn = dsa_to_port(ds, MT7530_CPU_PORT)->master->dev.of_node->parent;
+	dn = dsa_to_port(ds, priv->cpu_port)->master->dev.of_node->parent;
 	ds->assisted_learning_on_cpu_port = true;
 	ds->mtu_enforcement_ingress = true;
 
@@ -2337,15 +2339,6 @@ mt7531_setup(struct dsa_switch *ds)
 	mt7531_ind_c45_phy_write(priv, MT753X_CTRL_PHY_ADDR, MDIO_MMD_VEND2,
 				 CORE_PLL_GROUP4, val);
 
-	/* BPDU to CPU port */
-	mt7530_rmw(priv, MT7531_CFC, MT7531_CPU_PMAP_MASK,
-		   BIT(MT7530_CPU_PORT));
-	mt7530_rmw(priv, MT753X_BPC, MT753X_BPDU_PORT_FW_MASK,
-		   MT753X_BPDU_CPU_ONLY);
-
-	/* Enable and reset MIB counters */
-	mt7530_mib_reset(ds);
-
 	for (i = 0; i < MT7530_NUM_PORTS; i++) {
 		/* Disable forwarding by default on all ports */
 		mt7530_rmw(priv, MT7530_PCR_P(i), PCR_MATRIX_MASK,
@@ -2373,6 +2366,15 @@ mt7531_setup(struct dsa_switch *ds)
 			   PVC_EG_TAG(MT7530_VLAN_EG_CONSISTENT));
 	}
 
+	/* BPDU to CPU port */
+	mt7530_rmw(priv, MT7531_CFC, MT7531_CPU_PMAP_MASK,
+		   BIT(priv->cpu_port));
+	mt7530_rmw(priv, MT753X_BPC, MT753X_BPDU_PORT_FW_MASK,
+		   MT753X_BPDU_CPU_ONLY);
+
+	/* Enable and reset MIB counters */
+	mt7530_mib_reset(ds);
+
 	/* Setup VLAN ID 0 for VLAN-unaware bridges */
 	ret = mt7530_setup_vlan0(priv);
 	if (ret)
@@ -3213,6 +3215,8 @@ mt7530_probe(struct mdio_device *mdiodev)
 	if (!priv)
 		return -ENOMEM;
 
+	priv->cpu_port = 6;
+
 	priv->ds = devm_kzalloc(&mdiodev->dev, sizeof(*priv->ds), GFP_KERNEL);
 	if (!priv->ds)
 		return -ENOMEM;
diff --git a/drivers/net/dsa/mt7530.h b/drivers/net/dsa/mt7530.h
index 91508e2feef9..62df8d10f6d4 100644
--- a/drivers/net/dsa/mt7530.h
+++ b/drivers/net/dsa/mt7530.h
@@ -8,7 +8,6 @@
 
 #define MT7530_NUM_PORTS		7
 #define MT7530_NUM_PHYS			5
-#define MT7530_CPU_PORT			6
 #define MT7530_NUM_FDB_RECORDS		2048
 #define MT7530_ALL_MEMBERS		0xff
 
@@ -823,6 +822,7 @@ struct mt7530_priv {
 	u8			mirror_tx;
 
 	struct mt7530_port	ports[MT7530_NUM_PORTS];
+	int			cpu_port;
 	/* protect among processes for registers access*/
 	struct mutex reg_mutex;
 	int irq;
-- 
2.25.1

