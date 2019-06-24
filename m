Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23FD950F36
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 16:53:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729421AbfFXOxb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 10:53:31 -0400
Received: from mx.0dd.nl ([5.2.79.48]:33532 "EHLO mx.0dd.nl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726414AbfFXOxb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Jun 2019 10:53:31 -0400
Received: from mail.vdorst.com (mail.vdorst.com [IPv6:fd01::250])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.0dd.nl (Postfix) with ESMTPS id 2F1965FEAA;
        Mon, 24 Jun 2019 16:53:28 +0200 (CEST)
Authentication-Results: mx.0dd.nl;
        dkim=pass (2048-bit key) header.d=vdorst.com header.i=@vdorst.com header.b="ap3bsTdE";
        dkim-atps=neutral
Received: from pc-rene.vdorst.com (pc-rene.vdorst.com [192.168.2.125])
        by mail.vdorst.com (Postfix) with ESMTPA id ED9D11CC6F19;
        Mon, 24 Jun 2019 16:53:27 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.vdorst.com ED9D11CC6F19
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vdorst.com;
        s=default; t=1561388008;
        bh=inaANzeGYZ3EgYB3duDullrdCzEiKUVwyGOseNfS7s0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ap3bsTdEAExFgwd28a/2Ei5ujPioBtPz7GbITjiNFpvN8ANMKdeOyom6Lrl5H+qad
         IUXB7QwPwrmAQQd6WVMFQuWPA9GM4e0C8KqVbMdo2YE0K2fG4ghHlXh46kl1fg8WBG
         qrKcC9Cb0C4aD2/3nv7cV639hfQAQJwQdNFmNMa+RdDENL5eqV31SNp+O3HNNbjg+k
         xw10bNKteewYxO/PNAPwyLH0K4CBhdP5NbEJ+Oi4rUydphcHrCK3u451Vpv7blb5Ft
         qyEG1UMHMtXF2wN+6YC82zXvTYqiA7fos1/6pCm5oclbA6sSR0GX8C3aDm5KFTTBkn
         PF2y0axaSgNFg==
From:   =?UTF-8?q?Ren=C3=A9=20van=20Dorst?= <opensource@vdorst.com>
To:     sean.wang@mediatek.com, f.fainelli@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, matthias.bgg@gmail.com,
        andrew@lunn.ch, vivien.didelot@gmail.com
Cc:     frank-w@public-files.de, netdev@vger.kernel.org,
        linux-mediatek@lists.infradead.org, linux-mips@vger.kernel.org,
        =?UTF-8?q?Ren=C3=A9=20van=20Dorst?= <opensource@vdorst.com>
Subject: [PATCH RFC net-next 3/5] net: dsa: mt7530: Add support for port 5
Date:   Mon, 24 Jun 2019 16:52:49 +0200
Message-Id: <20190624145251.4849-4-opensource@vdorst.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190624145251.4849-1-opensource@vdorst.com>
References: <20190624145251.4849-1-opensource@vdorst.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding support for port 5.

Port 5 ca muxed/interface to:
- internal 5th GMAC of the switch; can be used as 2nd CPU port or as
  extra port with an external phy for a 6th ethernet port.
- internal PHY of port 0 or 4; Used in most applications so that port 0
  or 4 is the WAN port and interfaces with the 2nd GMAC of the SOC.

Signed-off-by: René van Dorst <opensource@vdorst.com>
---
 drivers/net/dsa/mt7530.c | 135 +++++++++++++++++++++++++++++++++++++--
 drivers/net/dsa/mt7530.h |  28 ++++++++
 2 files changed, 159 insertions(+), 4 deletions(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 9c5e4dd00826..838a921ca83e 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -633,6 +633,74 @@ mt7530_get_sset_count(struct dsa_switch *ds, int port, int sset)
 	return ARRAY_SIZE(mt7530_mib);
 }
 
+static void mt7530_setup_port5(struct dsa_switch *ds, phy_interface_t interface)
+{
+	struct mt7530_priv *priv = ds->priv;
+	u8 tx_delay = 0;
+	int val;
+
+	mutex_lock(&priv->reg_mutex);
+
+	val = mt7530_read(priv, MT7530_MHWTRAP);
+
+	val |= MHWTRAP_MANUAL | MHWTRAP_P5_MAC_SEL | MHWTRAP_P5_DIS;
+	val &= ~MHWTRAP_P5_RGMII_MODE & ~MHWTRAP_PHY0_SEL;
+
+	switch (priv->p5_mode) {
+	case P5_MODE_GPHY_P0:
+		/* MT7530_P5_MODE_GPHY_P0: 2nd GMAC -> P5 -> P0 */
+		val |= MHWTRAP_PHY0_SEL;
+		/* fall through */
+	case P5_MODE_GPHY_P4:
+		/* MT7530_P5_MODE_GPHY_P4: 2nd GMAC -> P5 -> P4 */
+		val &= ~MHWTRAP_P5_MAC_SEL & ~MHWTRAP_P5_DIS;
+
+		/* Setup the MAC by default for the cpu port */
+		mt7530_write(priv, MT7530_PMCR_P(5), 0x56300);
+		break;
+	case P5_MODE_GMAC:
+		/* MT7530_P5_MODE_GMAC: P5 -> External phy or 2nd GMAC */
+		val &= ~MHWTRAP_P5_DIS;
+		break;
+	case P5_MODE_DISABLED:
+		interface = PHY_INTERFACE_MODE_NA;
+		break;
+	default:
+		dev_err(ds->dev, "Unsupported p5_mode %d\n", priv->p5_mode);
+		goto unlock_exit;
+	}
+
+	/* Setup RGMII settings */
+	if (phy_interface_mode_is_rgmii(interface)) {
+		val |= MHWTRAP_P5_RGMII_MODE;
+
+		/* P5 RGMII RX Clock Control: delay setting for 1000M */
+		mt7530_write(priv, MT7530_P5RGMIIRXCR, CSR_RGMII_EDGE_ALIGN);
+
+		/* Don't set delay in DSA mode */
+		if (!dsa_is_dsa_port(priv->ds, 5) &&
+		    (interface == PHY_INTERFACE_MODE_RGMII_TXID ||
+		    interface == PHY_INTERFACE_MODE_RGMII_ID))
+			tx_delay = 4; /* n * 0.5 ns */
+
+		/* P5 RGMII TX Clock Control: delay x */
+		mt7530_write(priv, MT7530_P5RGMIITXCR,
+			     CSR_RGMII_TXC_CFG(0x10 + tx_delay));
+
+		/* reduce P5 RGMII Tx driving, 8mA */
+		mt7530_write(priv, MT7530_IO_DRV_CR,
+			     P5_IO_CLK_DRV(1) | P5_IO_DATA_DRV(1));
+	}
+
+	mt7530_write(priv, MT7530_MHWTRAP, val);
+
+	dev_info(ds->dev, "Setup P5, HWTRAP=0x%x, port-mode=%s, phy-mode=%s\n",
+		 val, p5_modes(priv->p5_mode), phy_modes(interface));
+
+unlock_exit:
+	mutex_unlock(&priv->reg_mutex);
+}
+
 static int
 mt7530_cpu_port_enable(struct mt7530_priv *priv,
 		       int port)
@@ -1173,6 +1241,10 @@ mt7530_setup(struct dsa_switch *ds)
 	u32 id, val;
 	struct device_node *dn;
 	struct mt7530_dummy_poll p;
+	phy_interface_t interface;
+	struct device_node *mac_np;
+	struct device_node *phy_node;
+	const __be32 *_id;
 
 	/* The parent node of master netdev which holds the common system
 	 * controller also is the container for two GMACs nodes representing
@@ -1258,6 +1330,40 @@ mt7530_setup(struct dsa_switch *ds)
 			mt7530_port_disable(ds, i);
 	}
 
+	/* Setup port 5 */
+	priv->p5_mode = P5_MODE_DISABLED;
+	interface = PHY_INTERFACE_MODE_NA;
+
+	if (!dsa_is_unused_port(ds, 5)) {
+		priv->p5_mode = P5_MODE_GMAC;
+		interface = of_get_phy_mode(ds->ports[5].dn);
+	} else {
+		/* Scan the ethernet nodes. Look for GMAC1, Lookup used phy */
+		for_each_child_of_node(dn, mac_np) {
+			if (!of_device_is_compatible(mac_np,
+						     "mediatek,eth-mac"))
+				continue;
+			_id = of_get_property(mac_np, "reg", NULL);
+			if (be32_to_cpup(_id)  != 1)
+				continue;
+
+			interface = of_get_phy_mode(mac_np);
+			phy_node = of_parse_phandle(mac_np, "phy-handle", 0);
+
+			if (phy_node->parent == priv->dev->of_node->parent) {
+				_id = of_get_property(phy_node, "reg", NULL);
+				id = be32_to_cpup(_id);
+				if (id == 0)
+					priv->p5_mode = P5_MODE_GPHY_P0;
+				if (id == 4)
+					priv->p5_mode = P5_MODE_GPHY_P4;
+			}
+			break;
+		}
+	}
+
+	mt7530_setup_port5(ds, interface);
+
 	/* Flush the FDB table */
 	ret = mt7530_fdb_cmd(priv, MT7530_FDB_FLUSH, NULL);
 	if (ret < 0)
@@ -1283,7 +1389,20 @@ static void mt7530_phylink_mac_config(struct dsa_switch *ds, int port,
 		if (state->interface != PHY_INTERFACE_MODE_GMII)
 			goto unsupported;
 		break;
-	/* case 5: Port 5 is not supported! */
+	case 5: /* 2nd cpu port with phy of port 0 or 4 / external phy */
+		if (!phy_interface_mode_is_rgmii(state->interface) &&
+		    state->interface != PHY_INTERFACE_MODE_MII)
+			goto unsupported;
+		if (priv->p5_mode != P5_MODE_GMAC) {
+			priv->p5_mode = P5_MODE_GMAC;
+			mt7530_port_disable(ds, port);
+			mt7530_setup_port5(ds, state->interface);
+			mt7530_port_enable(ds, port, NULL);
+		}
+		/* We are connected to external phy */
+		if (dsa_is_user_port(ds, 5))
+			mcr |= PMCR_EXT_PHY;
+		break;
 	case 6: /* 1st cpu port */
 		if (state->interface != PHY_INTERFACE_MODE_RGMII &&
 		    state->interface != PHY_INTERFACE_MODE_TRGMII)
@@ -1364,7 +1483,12 @@ static void mt7530_phylink_validate(struct dsa_switch *ds, int port,
 		    state->interface != PHY_INTERFACE_MODE_GMII)
 			goto unsupported;
 		break;
-	/* case 5: Port 5 not supported! */
+	case 5: /* 2nd cpu port with phy of port 0 or 4 / external phy */
+		if (!phy_interface_mode_is_rgmii(state->interface) &&
+		    state->interface != PHY_INTERFACE_MODE_MII &&
+		    state->interface != PHY_INTERFACE_MODE_NA)
+			goto unsupported;
+		break;
 	case 6: /* 1st cpu port */
 		if (state->interface != PHY_INTERFACE_MODE_RGMII &&
 		    state->interface != PHY_INTERFACE_MODE_TRGMII)
@@ -1385,8 +1509,11 @@ static void mt7530_phylink_validate(struct dsa_switch *ds, int port,
 	phylink_set(mask, 10baseT_Full);
 	phylink_set(mask, 100baseT_Half);
 	phylink_set(mask, 100baseT_Full);
-	phylink_set(mask, 1000baseT_Full);
-	phylink_set(mask, 1000baseT_Half);
+
+	if (state->interface != PHY_INTERFACE_MODE_MII) {
+		phylink_set(mask, 1000baseT_Full);
+		phylink_set(mask, 1000baseT_Half);
+	}
 
 	linkmode_and(supported, supported, mask);
 	linkmode_and(state->advertising, state->advertising, mask);
diff --git a/drivers/net/dsa/mt7530.h b/drivers/net/dsa/mt7530.h
index 41d9a132ac70..f2a84ef48548 100644
--- a/drivers/net/dsa/mt7530.h
+++ b/drivers/net/dsa/mt7530.h
@@ -186,6 +186,7 @@ enum mt7530_vlan_port_attr {
 /* Register for port MAC control register */
 #define MT7530_PMCR_P(x)		(0x3000 + ((x) * 0x100))
 #define  PMCR_IFG_XMIT(x)		(((x) & 0x3) << 18)
+#define  PMCR_EXT_PHY			BIT(17)
 #define  PMCR_MAC_MODE			BIT(16)
 #define  PMCR_FORCE_MODE		BIT(15)
 #define  PMCR_TX_EN			BIT(14)
@@ -260,6 +261,7 @@ enum mt7530_vlan_port_attr {
 
 /* Register for hw trap modification */
 #define MT7530_MHWTRAP			0x7804
+#define  MHWTRAP_PHY0_SEL		BIT(20)
 #define  MHWTRAP_MANUAL			BIT(16)
 #define  MHWTRAP_P5_MAC_SEL		BIT(13)
 #define  MHWTRAP_P6_DIS			BIT(8)
@@ -417,6 +419,30 @@ struct mt7530_port {
 	u16 pvid;
 };
 
+/* Port 5 Mode definitions */
+enum p5_mode {
+	P5_MODE_DISABLED = 0,
+	P5_MODE_GPHY_P0,
+	P5_MODE_GPHY_P4,
+	P5_MODE_GMAC,
+};
+
+static const char *p5_modes(unsigned int p5_mode)
+{
+	switch (p5_mode) {
+	case P5_MODE_DISABLED:
+		return "DISABLED";
+	case P5_MODE_GPHY_P0:
+		return "PHY P0";
+	case P5_MODE_GPHY_P4:
+		return "PHY P4";
+	case P5_MODE_GMAC:
+		return "GMAC";
+	default:
+		return "unknown";
+	}
+}
+
 /* struct mt7530_priv -	This is the main data structure for holding the state
  *			of the driver
  * @dev:		The device pointer
@@ -432,6 +458,7 @@ struct mt7530_port {
  * @ports:		Holding the state among ports
  * @reg_mutex:		The lock for protecting among process accessing
  *			registers
+ * @p5_mode:		PORT 5 mode status
  */
 struct mt7530_priv {
 	struct device		*dev;
@@ -444,6 +471,7 @@ struct mt7530_priv {
 	struct gpio_desc	*reset;
 	unsigned int		id;
 	bool			mcm;
+	unsigned int		p5_mode;
 
 	struct mt7530_port	ports[MT7530_NUM_PORTS];
 	/* protect among processes for registers access*/
-- 
2.20.1

