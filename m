Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9B4D97D7B
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 16:46:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729597AbfHUOp6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 10:45:58 -0400
Received: from mx.0dd.nl ([5.2.79.48]:54182 "EHLO mx.0dd.nl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728608AbfHUOp5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Aug 2019 10:45:57 -0400
Received: from mail.vdorst.com (mail.vdorst.com [IPv6:fd01::250])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.0dd.nl (Postfix) with ESMTPS id EEEF25FD17;
        Wed, 21 Aug 2019 16:45:55 +0200 (CEST)
Authentication-Results: mx.0dd.nl;
        dkim=pass (2048-bit key) header.d=vdorst.com header.i=@vdorst.com header.b="XgjSnZux";
        dkim-atps=neutral
Received: from pc-rene.vdorst.com (pc-rene.vdorst.com [192.168.2.125])
        by mail.vdorst.com (Postfix) with ESMTPA id B9F841D82911;
        Wed, 21 Aug 2019 16:45:55 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.vdorst.com B9F841D82911
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vdorst.com;
        s=default; t=1566398755;
        bh=HulUafNo2EBPd5w17SksS5OZnl4pFM5rmXfPBBrjDZY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XgjSnZuxP3l8snxfA1h5xJsirI+kZmxPsGbH/6H2hrK49/UEa0FvDrEMOe7t8JjXf
         kzydMxYmCpnvJ5QabchSfMSFTBoJV8MQfx/SyiSHCM3nNP6LIN5T6ID/0sAVCSt9st
         7BXcucrP95uxXeC5Mt670JBS6rXLKtcT0ABDQUxY76FQv05D27EQ+4losizTVmZ9rV
         kAKNOjdq20oGo1wn0gJd6hfJLp+tWpuu/iCpSiFoBPmtTGDAajNDiBpJxkZJiWGKrq
         WUUrmmjXHs+r9PLhIHPndFOpRsj8P/3/KTzBfms+VZUxH7LJe8DS31XXZs2AjolfnC
         AurJ0yiztHpAg==
From:   =?UTF-8?q?Ren=C3=A9=20van=20Dorst?= <opensource@vdorst.com>
To:     Sean Wang <sean.wang@mediatek.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>
Cc:     netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        John Crispin <john@phrozen.org>, linux-mips@vger.kernel.org,
        Frank Wunderlich <frank-w@public-files.de>,
        =?UTF-8?q?Ren=C3=A9=20van=20Dorst?= <opensource@vdorst.com>
Subject: [PATCH net-next v2 3/3] net: dsa: mt7530: Add support for port 5
Date:   Wed, 21 Aug 2019 16:45:47 +0200
Message-Id: <20190821144547.15113-4-opensource@vdorst.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190821144547.15113-1-opensource@vdorst.com>
References: <20190821144547.15113-1-opensource@vdorst.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding support for port 5.

Port 5 can muxed/interface to:
- internal 5th GMAC of the switch; can be used as 2nd CPU port or as
  extra port with an external phy for a 6th ethernet port.
- internal PHY of port 0 or 4; Used in most applications so that port 0
  or 4 is the WAN port and interfaces with the 2nd GMAC of the SOC.

Signed-off-by: René van Dorst <opensource@vdorst.com>

v1->v2:
* Also report 1000base-x support for port 5 suggested by Russell King
* Reorder variable declaraiant in reverse christmas tree suggested by
  Daved Miller
* Refactor phy-handle lookup for 2nd GMAC.
* Use of_mdio_parse_addr() instead of do it manualy suggested by
  Florian Fainelli
* Refactor port 5 setup in mt7530_phylink_mac_config()
rfc->v1:
* Removed unnecessary info print suggested by Andrew Lunn
* Added support for MII mode for port 5
---
 drivers/net/dsa/mt7530.c | 145 +++++++++++++++++++++++++++++++++++++--
 drivers/net/dsa/mt7530.h |  29 ++++++++
 2 files changed, 168 insertions(+), 6 deletions(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index ecc13b57e619..43407a9b80ac 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -633,6 +633,77 @@ mt7530_get_sset_count(struct dsa_switch *ds, int port, int sset)
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
+	switch (priv->p5_intf_sel) {
+	case P5_INTF_SEL_PHY_P0:
+		/* MT7530_P5_MODE_GPHY_P0: 2nd GMAC -> P5 -> P0 */
+		val |= MHWTRAP_PHY0_SEL;
+		/* fall through */
+	case P5_INTF_SEL_PHY_P4:
+		/* MT7530_P5_MODE_GPHY_P4: 2nd GMAC -> P5 -> P4 */
+		val &= ~MHWTRAP_P5_MAC_SEL & ~MHWTRAP_P5_DIS;
+
+		/* Setup the MAC by default for the cpu port */
+		mt7530_write(priv, MT7530_PMCR_P(5), 0x56300);
+		break;
+	case P5_INTF_SEL_GMAC5:
+		/* MT7530_P5_MODE_GMAC: P5 -> External phy or 2nd GMAC */
+		val &= ~MHWTRAP_P5_DIS;
+		break;
+	case P5_DISABLED:
+		interface = PHY_INTERFACE_MODE_NA;
+		break;
+	default:
+		dev_err(ds->dev, "Unsupported p5_intf_sel %d\n",
+			priv->p5_intf_sel);
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
+		     interface == PHY_INTERFACE_MODE_RGMII_ID))
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
+	dev_info(ds->dev, "Setup P5, HWTRAP=0x%x, intf_sel=%s, phy-mode=%s\n",
+		 val, p5_intf_modes(priv->p5_intf_sel), phy_modes(interface));
+
+	priv->p5_interface = interface;
+
+unlock_exit:
+	mutex_unlock(&priv->reg_mutex);
+}
+
 static int
 mt7530_cpu_port_enable(struct mt7530_priv *priv,
 		       int port)
@@ -1169,7 +1240,10 @@ static int
 mt7530_setup(struct dsa_switch *ds)
 {
 	struct mt7530_priv *priv = ds->priv;
+	struct device_node *phy_node;
+	struct device_node *mac_np;
 	struct mt7530_dummy_poll p;
+	phy_interface_t interface;
 	struct device_node *dn;
 	u32 id, val;
 	int ret, i;
@@ -1260,6 +1334,40 @@ mt7530_setup(struct dsa_switch *ds)
 			mt7530_port_disable(ds, i);
 	}
 
+	/* Setup port 5 */
+	priv->p5_intf_sel = P5_DISABLED;
+	interface = PHY_INTERFACE_MODE_NA;
+
+	if (!dsa_is_unused_port(ds, 5)) {
+		priv->p5_intf_sel = P5_INTF_SEL_GMAC5;
+		interface = of_get_phy_mode(ds->ports[5].dn);
+	} else {
+		/* Scan the ethernet nodes. look for GMAC1, lookup used phy */
+		for_each_child_of_node(dn, mac_np) {
+			if (!of_device_is_compatible(mac_np,
+						     "mediatek,eth-mac"))
+				continue;
+
+			ret = of_property_read_u32(mac_np, "reg", &id);
+			if (ret < 0 || id != 1)
+				continue;
+
+			phy_node = of_parse_phandle(mac_np, "phy-handle", 0);
+			if (phy_node->parent == priv->dev->of_node->parent) {
+				interface = of_get_phy_mode(mac_np);
+				id = of_mdio_parse_addr(ds->dev, phy_node);
+				if (id == 0)
+					priv->p5_intf_sel = P5_INTF_SEL_PHY_P0;
+				if (id == 4)
+					priv->p5_intf_sel = P5_INTF_SEL_PHY_P4;
+			}
+			of_node_put(phy_node);
+			break;
+		}
+	}
+
+	mt7530_setup_port5(ds, interface);
+
 	/* Flush the FDB table */
 	ret = mt7530_fdb_cmd(priv, MT7530_FDB_FLUSH, NULL);
 	if (ret < 0)
@@ -1284,7 +1392,16 @@ static void mt7530_phylink_mac_config(struct dsa_switch *ds, int port,
 		if (state->interface != PHY_INTERFACE_MODE_GMII)
 			return;
 		break;
-	/* case 5: Port 5 is not supported! */
+	case 5: /* 2nd cpu port with phy of port 0 or 4 / external phy */
+		if (priv->p5_interface == state->interface)
+			break;
+		if (!phy_interface_mode_is_rgmii(state->interface) &&
+		    state->interface != PHY_INTERFACE_MODE_MII &&
+		    state->interface != PHY_INTERFACE_MODE_GMII)
+			return;
+
+		mt7530_setup_port5(ds, state->interface);
+		break;
 	case 6: /* 1st cpu port */
 		if (priv->p6_interface == state->interface)
 			break;
@@ -1324,6 +1441,10 @@ static void mt7530_phylink_mac_config(struct dsa_switch *ds, int port,
 	mcr_new |= PMCR_IFG_XMIT(1) | PMCR_MAC_MODE | PMCR_BACKOFF_EN |
 		   PMCR_BACKPR_EN | PMCR_FORCE_MODE | PMCR_FORCE_LNK;
 
+	/* Are we connected to external phy */
+	if (port == 5 && dsa_is_user_port(ds, 5))
+		mcr_new |= PMCR_EXT_PHY;
+
 	switch (state->speed) {
 	case SPEED_1000:
 		mcr_new |= PMCR_FORCE_SPEED_1000;
@@ -1379,7 +1500,13 @@ static void mt7530_phylink_validate(struct dsa_switch *ds, int port,
 		    state->interface != PHY_INTERFACE_MODE_GMII)
 			goto unsupported;
 		break;
-	/* case 5: Port 5 not supported! */
+	case 5: /* 2nd cpu port with phy of port 0 or 4 / external phy */
+		if (state->interface != PHY_INTERFACE_MODE_NA &&
+		    !phy_interface_mode_is_rgmii(state->interface) &&
+		    state->interface != PHY_INTERFACE_MODE_MII &&
+		    state->interface != PHY_INTERFACE_MODE_GMII)
+			goto unsupported;
+		break;
 	case 6: /* 1st cpu port */
 		if (state->interface != PHY_INTERFACE_MODE_NA &&
 		    state->interface != PHY_INTERFACE_MODE_RGMII &&
@@ -1396,15 +1523,21 @@ static void mt7530_phylink_validate(struct dsa_switch *ds, int port,
 	phylink_set_port_modes(mask);
 	phylink_set(mask, Autoneg);
 
-	if (state->interface != PHY_INTERFACE_MODE_TRGMII) {
+	if (state->interface == PHY_INTERFACE_MODE_TRGMII) {
+		phylink_set(mask, 1000baseT_Full);
+	} else {
 		phylink_set(mask, 10baseT_Half);
 		phylink_set(mask, 10baseT_Full);
 		phylink_set(mask, 100baseT_Half);
 		phylink_set(mask, 100baseT_Full);
-		phylink_set(mask, 1000baseT_Half);
-	}
 
-	phylink_set(mask, 1000baseT_Full);
+		if (state->interface != PHY_INTERFACE_MODE_MII) {
+			phylink_set(mask, 1000baseT_Half);
+			phylink_set(mask, 1000baseT_Full);
+			if (port == 5)
+				phylink_set(mask, 1000baseX_Full);
+		}
+	}
 
 	phylink_set(mask, Pause);
 	phylink_set(mask, Asym_Pause);
diff --git a/drivers/net/dsa/mt7530.h b/drivers/net/dsa/mt7530.h
index 107dd04acede..ccb9da8cad0d 100644
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
@@ -245,6 +246,7 @@ enum mt7530_vlan_port_attr {
 
 /* Register for hw trap modification */
 #define MT7530_MHWTRAP			0x7804
+#define  MHWTRAP_PHY0_SEL		BIT(20)
 #define  MHWTRAP_MANUAL			BIT(16)
 #define  MHWTRAP_P5_MAC_SEL		BIT(13)
 #define  MHWTRAP_P6_DIS			BIT(8)
@@ -402,6 +404,30 @@ struct mt7530_port {
 	u16 pvid;
 };
 
+/* Port 5 interface select definitions */
+enum p5_interface_select {
+	P5_DISABLED = 0,
+	P5_INTF_SEL_PHY_P0,
+	P5_INTF_SEL_PHY_P4,
+	P5_INTF_SEL_GMAC5,
+};
+
+static const char *p5_intf_modes(unsigned int p5_interface)
+{
+	switch (p5_interface) {
+	case P5_DISABLED:
+		return "DISABLED";
+	case P5_INTF_SEL_PHY_P0:
+		return "PHY P0";
+	case P5_INTF_SEL_PHY_P4:
+		return "PHY P4";
+	case P5_INTF_SEL_GMAC5:
+		return "GMAC5";
+	default:
+		return "unknown";
+	}
+}
+
 /* struct mt7530_priv -	This is the main data structure for holding the state
  *			of the driver
  * @dev:		The device pointer
@@ -418,6 +444,7 @@ struct mt7530_port {
  * @reg_mutex:		The lock for protecting among process accessing
  *			registers
  * @p6_interface	Holding the current port 6 interface
+ * @p5_intf_sel:	Holding the current port 5 interface select
  */
 struct mt7530_priv {
 	struct device		*dev;
@@ -431,6 +458,8 @@ struct mt7530_priv {
 	unsigned int		id;
 	bool			mcm;
 	phy_interface_t		p6_interface;
+	phy_interface_t		p5_interface;
+	unsigned int		p5_intf_sel;
 
 	struct mt7530_port	ports[MT7530_NUM_PORTS];
 	/* protect among processes for registers access*/
-- 
2.20.1

