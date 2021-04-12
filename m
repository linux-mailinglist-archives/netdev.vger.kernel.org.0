Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2890935BA4C
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 08:50:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236646AbhDLGvC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 02:51:02 -0400
Received: from mx.i2x.nl ([5.2.79.48]:42294 "EHLO mx.i2x.nl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229461AbhDLGvB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Apr 2021 02:51:01 -0400
Received: from mail.vdorst.com (mail.vdorst.com [IPv6:fd00::1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mx.i2x.nl (Postfix) with ESMTPS id 409415FB39;
        Mon, 12 Apr 2021 08:50:42 +0200 (CEST)
Authentication-Results: mx.i2x.nl;
        dkim=pass (2048-bit key; secure) header.d=vdorst.com header.i=@vdorst.com header.b="m1S786pa";
        dkim-atps=neutral
Received: from pc-rene.vdorst.com (pc-rene.vdorst.com [192.168.2.14])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.vdorst.com (Postfix) with ESMTPSA id F3579BC9FC5;
        Mon, 12 Apr 2021 08:50:41 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.vdorst.com F3579BC9FC5
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vdorst.com;
        s=default; t=1618210242;
        bh=d+FNPoVyUuFfNwKhrRN87D3cxES+p+PMfh3mHzlZDpA=;
        h=From:To:Cc:Subject:Date:From;
        b=m1S786pal22OrkVRkpR1NgBcBbx4kW4WS2O+K8dJg9xt/qWvNZM3IjGmGQ8jXmEtc
         oH8jML3UjEH1bJ0H6Ge4L6rsTcAR5tQ1dQWQTS/B1LZZ/TJ7O1PmQ+2y07RR4qUvWF
         J6okSwJYvKleW5PECIve46Cb7Jw4oc0tKur28CclcAY0hg5v3S8wO8/Pk48j3OxVmq
         2j2EOPXLE48Pgmv4/aFlrV1bMXWYAQQ9MMhDPMsvSd/P0xeslkQRNd5kMAUura6hr3
         cqLQInxjgKVPmlJxggXYP9MWBC789hf+Ke/KDn47oBUorIa59nlBCx93lUe6rfKlmh
         7+snbEx/20ozA==
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
Subject: [PATCH net-next v2] net: dsa: mt7530: Add support for EEE features
Date:   Mon, 12 Apr 2021 08:50:31 +0200
Message-Id: <20210412065031.29492-1-opensource@vdorst.com>
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
v1 -> v2:
- Refactor the mt753x_{get,set}_mac_eee().
  As DENQ Qingfang mentioned, most things are set else were.
  These functions only set/report the LPI timeout value/LPI timeout enable bit.
- Removed the variable "eee_enabled", don't need too track the EEE status.
- Refactor mt753x_phylink_mac_link_up().
  phy_init_eee() reports is the EEE is active, this function also checks
  the PHY, duplex and broken DTS modes.
  When active set the MAC EEE bit based on the speed.
- Add {GET,SET)_LPI_THRESH(x) macro
- PMCR_FORCE_EEE1G | PMCR_FORCE_EEE100 are now placed in the right MASK variable

 drivers/net/dsa/mt7530.c | 43 ++++++++++++++++++++++++++++++++++++++++
 drivers/net/dsa/mt7530.h | 14 ++++++++++++-
 2 files changed, 56 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 2bd1bab71497..96f7c9eede35 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -2570,6 +2570,17 @@ static void mt753x_phylink_mac_link_up(struct dsa_switch *ds, int port,
 			mcr |= PMCR_RX_FC_EN;
 	}
 
+	if (mode == MLO_AN_PHY && phydev && phy_init_eee(phydev, 0) >= 0) {
+		switch (speed) {
+		case SPEED_1000:
+			mcr |= PMCR_FORCE_EEE1G;
+			break;
+		case SPEED_100:
+			mcr |= PMCR_FORCE_EEE100;
+			break;
+		}
+	}
+
 	mt7530_set(priv, MT7530_PMCR_P(port), mcr);
 }
 
@@ -2800,6 +2811,36 @@ mt753x_phy_write(struct dsa_switch *ds, int port, int regnum, u16 val)
 	return priv->info->phy_write(ds, port, regnum, val);
 }
 
+static int mt753x_get_mac_eee(struct dsa_switch *ds, int port,
+			      struct ethtool_eee *e)
+{
+	struct mt7530_priv *priv = ds->priv;
+	u32 eeecr = mt7530_read(priv, MT7530_PMEEECR_P(port));
+
+	e->tx_lpi_enabled = !(eeecr & LPI_MODE_EN);
+	e->tx_lpi_timer = GET_LPI_THRESH(eeecr);
+
+	return 0;
+}
+
+static int mt753x_set_mac_eee(struct dsa_switch *ds, int port,
+			      struct ethtool_eee *e)
+{
+	struct mt7530_priv *priv = ds->priv;
+	u32 set, mask = LPI_THRESH_MASK | LPI_MODE_EN;
+
+	if (e->tx_lpi_timer > 0xFFF)
+		return -EINVAL;
+
+	set = SET_LPI_THRESH(e->tx_lpi_timer);
+	if (!e->tx_lpi_enabled)
+		/* Force LPI Mode without a delay */
+		set |= LPI_MODE_EN;
+	mt7530_rmw(priv, MT7530_PMEEECR_P(port), mask, set);
+
+	return 0;
+}
+
 static const struct dsa_switch_ops mt7530_switch_ops = {
 	.get_tag_protocol	= mtk_get_tag_protocol,
 	.setup			= mt753x_setup,
@@ -2835,6 +2876,8 @@ static const struct dsa_switch_ops mt7530_switch_ops = {
 	.phylink_mac_an_restart	= mt753x_phylink_mac_an_restart,
 	.phylink_mac_link_down	= mt753x_phylink_mac_link_down,
 	.phylink_mac_link_up	= mt753x_phylink_mac_link_up,
+	.get_mac_eee		= mt753x_get_mac_eee,
+	.set_mac_eee		= mt753x_set_mac_eee,
 };
 
 static const struct mt753x_info mt753x_table[] = {
diff --git a/drivers/net/dsa/mt7530.h b/drivers/net/dsa/mt7530.h
index ec36ea5dfd57..0204da486f3a 100644
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
@@ -281,7 +283,8 @@ enum mt7530_vlan_port_attr {
 #define  PMCR_LINK_SETTINGS_MASK	(PMCR_TX_EN | PMCR_FORCE_SPEED_1000 | \
 					 PMCR_RX_EN | PMCR_FORCE_SPEED_100 | \
 					 PMCR_TX_FC_EN | PMCR_RX_FC_EN | \
-					 PMCR_FORCE_FDX | PMCR_FORCE_LNK)
+					 PMCR_FORCE_FDX | PMCR_FORCE_LNK | \
+					 PMCR_FORCE_EEE1G | PMCR_FORCE_EEE100)
 #define  PMCR_CPU_PORT_SETTING(id)	(PMCR_FORCE_MODE_ID((id)) | \
 					 PMCR_IFG_XMIT(1) | PMCR_MAC_MODE | \
 					 PMCR_BACKOFF_EN | PMCR_BACKPR_EN | \
@@ -290,6 +293,15 @@ enum mt7530_vlan_port_attr {
 					 PMCR_FORCE_SPEED_1000 | \
 					 PMCR_FORCE_FDX | PMCR_FORCE_LNK)
 
+#define MT7530_PMEEECR_P(x)		(0x3004 + (x) * 0x100)
+#define  WAKEUP_TIME_1000(x)		(((x) & 0xFF) << 24)
+#define  WAKEUP_TIME_100(x)		(((x) & 0xFF) << 16)
+#define  LPI_THRESH_MASK		GENMASK(15, 4)
+#define  LPI_THRESH_SHT			4
+#define  SET_LPI_THRESH(x)		(((x) << LPI_THRESH_SHT) & LPI_THRESH_MASK)
+#define  GET_LPI_THRESH(x)		(((x) & LPI_THRESH_MASK) >> LPI_THRESH_SHT)
+#define  LPI_MODE_EN			BIT(0)
+
 #define MT7530_PMSR_P(x)		(0x3008 + (x) * 0x100)
 #define  PMSR_EEE1G			BIT(7)
 #define  PMSR_EEE100M			BIT(6)
-- 
2.30.2

