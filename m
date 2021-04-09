Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D477635A90B
	for <lists+netdev@lfdr.de>; Sat, 10 Apr 2021 00:55:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235090AbhDIWyu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 18:54:50 -0400
Received: from mx.i2x.nl ([5.2.79.48]:35934 "EHLO mx.i2x.nl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234880AbhDIWyt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Apr 2021 18:54:49 -0400
Received: from mail.vdorst.com (mail.vdorst.com [IPv6:fd00::1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mx.i2x.nl (Postfix) with ESMTPS id 09BBF5FC67;
        Sat, 10 Apr 2021 00:54:35 +0200 (CEST)
Authentication-Results: mx.i2x.nl;
        dkim=pass (2048-bit key; secure) header.d=vdorst.com header.i=@vdorst.com header.b="RoJrOTA2";
        dkim-atps=neutral
Received: from pc-rene.vdorst.com (pc-rene.vdorst.com [192.168.2.14])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.vdorst.com (Postfix) with ESMTPSA id BCBB1BC6B76;
        Sat, 10 Apr 2021 00:54:34 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.vdorst.com BCBB1BC6B76
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vdorst.com;
        s=default; t=1618008874;
        bh=gcbDGkUdDnJOBYT7ozbn4FoVr2Zh2eTcQINGngwB6vM=;
        h=From:To:Cc:Subject:Date:From;
        b=RoJrOTA20W/AspLCGjaeOvZHiW3QtsQ2KJJCjpR3HEjkRFY0GFUaGO0I7OnhPWt7j
         xkem4eOUyNFd5UBKPRLJoUcomEuyfpA7LUEruh5C+wlwip2GRiIeM3mdp6nVHdM8qV
         alMQqMQm81+lPWM4L326atRc9CTeVwy/g8HY9yHqbbTn7QPS/rKTX8myGA+NwL67XM
         yuzWtwg6lTBmUzC8AIDXz0SRfFvn8hScPfRbin28djhzlW6NW8l2c+xQtjFkyBlUnF
         N78U1xdurSqRUqZ2jqggMVEgvDsWP5hBp2LbZgirijXZccE5D3bIAYkBGv5GZi31fZ
         mGf/wumQek2kQ==
From:   =?UTF-8?q?Ren=C3=A9=20van=20Dorst?= <opensource@vdorst.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Sean Wang <sean.wang@mediatek.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        linux-mediatek@lists.infradead.org, netdev@vger.kernel.org
Cc:     Sergio Paracuellos <sergio.paracuellos@gmail.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        DENG Qingfang <dqfext@gmail.com>,
        =?UTF-8?q?Ren=C3=A9=20van=20Dorst?= <opensource@vdorst.com>
Subject: [PATCH net-next] net: dsa: mt7530: Add support for EEE features
Date:   Sat, 10 Apr 2021 00:53:46 +0200
Message-Id: <20210409225346.432312-1-opensource@vdorst.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds EEE support.

Signed-off-by: René van Dorst <opensource@vdorst.com>
---
 drivers/net/dsa/mt7530.c | 50 ++++++++++++++++++++++++++++++++++++++++
 drivers/net/dsa/mt7530.h | 16 ++++++++++++-
 2 files changed, 65 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 2bd1bab71497..daa87b0baa65 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -2568,6 +2568,11 @@ static void mt753x_phylink_mac_link_up(struct dsa_switch *ds, int port,
 			mcr |= PMCR_TX_FC_EN;
 		if (rx_pause)
 			mcr |= PMCR_RX_FC_EN;
+
+		if (mode == MLO_AN_PHY && phydev &&
+		    !(priv->eee_disabled & BIT(port)) &&
+		    phy_init_eee(phydev, 0) >= 0)
+			mcr |= PMCR_FORCE_EEE1G | PMCR_FORCE_EEE100;
 	}
 
 	mt7530_set(priv, MT7530_PMCR_P(port), mcr);
@@ -2800,6 +2805,49 @@ mt753x_phy_write(struct dsa_switch *ds, int port, int regnum, u16 val)
 	return priv->info->phy_write(ds, port, regnum, val);
 }
 
+static int mt753x_get_mac_eee(struct dsa_switch *ds, int port,
+			      struct ethtool_eee *e)
+{
+	struct mt7530_priv *priv = ds->priv;
+	u32 eeecr, pmsr;
+
+	e->eee_enabled = !(priv->eee_disabled & BIT(port));
+
+	if (e->eee_enabled) {
+		eeecr = mt7530_read(priv, MT7530_PMEEECR_P(port));
+		e->tx_lpi_enabled = !(eeecr & LPI_MODE_EN);
+		e->tx_lpi_timer = GET_LPI_THRESH(eeecr);
+		pmsr = mt7530_read(priv, MT7530_PMSR_P(port));
+		e->eee_active = e->eee_enabled && !!(pmsr & PMSR_EEE1G);
+	}
+
+	return 0;
+}
+
+static int mt753x_set_mac_eee(struct dsa_switch *ds, int port,
+			      struct ethtool_eee *e)
+{
+	struct mt7530_priv *priv = ds->priv;
+	u32 eeecr;
+
+	if (e->eee_enabled) {
+		if (e->tx_lpi_timer > 0xFFF)
+			return -EINVAL;
+		priv->eee_disabled &= ~BIT(port);
+		eeecr = mt7530_read(priv, MT7530_PMEEECR_P(port));
+		eeecr &= ~(LPI_THRESH_MASK | LPI_MODE_EN);
+		if (!e->tx_lpi_enabled)
+			/* Force LPI Mode without a delay */
+			eeecr |= LPI_MODE_EN;
+		eeecr |= SET_LPI_THRESH(e->tx_lpi_timer);
+		mt7530_write(priv, MT7530_PMEEECR_P(port), eeecr);
+	} else {
+		priv->eee_disabled |= BIT(port);
+	}
+
+	return 0;
+}
+
 static const struct dsa_switch_ops mt7530_switch_ops = {
 	.get_tag_protocol	= mtk_get_tag_protocol,
 	.setup			= mt753x_setup,
@@ -2835,6 +2883,8 @@ static const struct dsa_switch_ops mt7530_switch_ops = {
 	.phylink_mac_an_restart	= mt753x_phylink_mac_an_restart,
 	.phylink_mac_link_down	= mt753x_phylink_mac_link_down,
 	.phylink_mac_link_up	= mt753x_phylink_mac_link_up,
+	.get_mac_eee		= mt753x_get_mac_eee,
+	.set_mac_eee		= mt753x_set_mac_eee,
 };
 
 static const struct mt753x_info mt753x_table[] = {
diff --git a/drivers/net/dsa/mt7530.h b/drivers/net/dsa/mt7530.h
index ec36ea5dfd57..02f983df26bc 100644
--- a/drivers/net/dsa/mt7530.h
+++ b/drivers/net/dsa/mt7530.h
@@ -257,6 +257,8 @@ enum mt7530_vlan_port_attr {
 #define  PMCR_RX_EN			BIT(13)
 #define  PMCR_BACKOFF_EN		BIT(9)
 #define  PMCR_BACKPR_EN			BIT(8)
+#define  PMCR_FORCE_EEE1G		BIT(7)
+#define  PMCR_FORCE_EEE100		BIT(6)
 #define  PMCR_TX_FC_EN			BIT(5)
 #define  PMCR_RX_FC_EN			BIT(4)
 #define  PMCR_FORCE_SPEED_1000		BIT(3)
@@ -288,7 +290,17 @@ enum mt7530_vlan_port_attr {
 					 PMCR_TX_EN | PMCR_RX_EN | \
 					 PMCR_TX_FC_EN | PMCR_RX_FC_EN | \
 					 PMCR_FORCE_SPEED_1000 | \
-					 PMCR_FORCE_FDX | PMCR_FORCE_LNK)
+					 PMCR_FORCE_FDX | PMCR_FORCE_LNK | \
+					 PMCR_FORCE_EEE1G | PMCR_FORCE_EEE100)
+
+#define MT7530_PMEEECR_P(x)		(0x3004 + (x) * 0x100)
+#define  WAKEUP_TIME_1000(x)		(((x) & 0xFF) << 24)
+#define  WAKEUP_TIME_100(x)		(((x) & 0xFF) << 16)
+#define  LPI_THRESH_MASK		GENMASK(15, 4)
+#define  LPI_THRESH_SHT			4
+#define  SET_LPI_THRESH(x)		(((x) << LPI_THRESH_SHT) & LPI_THRESH_MASK)
+#define  GET_LPI_THRESH(x)		(((x) & LPI_THRESH_MASK) >> LPI_THRESH_SHT)
+#define  LPI_MODE_EN			BIT(0)
 
 #define MT7530_PMSR_P(x)		(0x3008 + (x) * 0x100)
 #define  PMSR_EEE1G			BIT(7)
@@ -761,6 +773,7 @@ struct mt753x_info {
  *			registers
  * @p6_interface	Holding the current port 6 interface
  * @p5_intf_sel:	Holding the current port 5 interface select
+ * @eee_disabled:	Holding the current eee user disabled bits
  */
 struct mt7530_priv {
 	struct device		*dev;
@@ -778,6 +791,7 @@ struct mt7530_priv {
 	unsigned int		p5_intf_sel;
 	u8			mirror_rx;
 	u8			mirror_tx;
+	u8			eee_disabled;
 
 	struct mt7530_port	ports[MT7530_NUM_PORTS];
 	/* protect among processes for registers access*/
-- 
2.30.2

