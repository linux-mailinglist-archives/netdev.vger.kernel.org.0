Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6848B56433D
	for <lists+netdev@lfdr.de>; Sun,  3 Jul 2022 01:12:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230044AbiGBW60 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Jul 2022 18:58:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiGBW6Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Jul 2022 18:58:25 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 473F91100
        for <netdev@vger.kernel.org>; Sat,  2 Jul 2022 15:58:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1656802701; x=1688338701;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=MCxx0swcx+1ximT4qwET5Sy6/YO4GToLq9fdGNgeUUc=;
  b=hBdCos7XjBPvsMLzwkdaR+goV53KeyKQbo40iLMnp4V0pyEHCgEfYWJH
   coStqalDbAMKJGnC1FQ5P/OWI9AslNY/GcAnkWCeba7pwJfzy83M7nRWI
   aGex6rf1Rct7ULNeD4FNL8HaJvnh9cVtORREsDJDri3e2+/KI4+qrfXO+
   NN6BCJi7T3XS6C9FBTd0rQ2rhj5Eu9dYAT1FwUjHfSH6qVboSknl4b1fB
   p3hfhGeOftx10jiWk143ozO86ZzkUofNCDFHlt1G6eQ5GA9HmH0t+W79i
   RUYe1ZTKOLeDYG0qjwPBi23/RZef/p/zr0mxofDQKIaf4FhNM4Rlmx1n+
   g==;
X-IronPort-AV: E=Sophos;i="5.92,241,1650956400"; 
   d="scan'208";a="170546639"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 02 Jul 2022 15:58:17 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Sat, 2 Jul 2022 15:58:14 -0700
Received: from hat-linux.microchip.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Sat, 2 Jul 2022 15:58:14 -0700
From:   <Tristram.Ha@microchip.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     Tristram Ha <Tristram.Ha@microchip.com>, <netdev@vger.kernel.org>,
        <UNGLinuxDriver@microchip.com>
Subject: [PATCH net-next 1/2] net: phy: smsc: add WoL support to LAN8740/LAN8742 PHYs.
Date:   Sat, 2 Jul 2022 15:58:27 -0700
Message-ID: <1656802708-7918-2-git-send-email-Tristram.Ha@microchip.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1656802708-7918-1-git-send-email-Tristram.Ha@microchip.com>
References: <1656802708-7918-1-git-send-email-Tristram.Ha@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tristram Ha <Tristram.Ha@microchip.com>

Microchip LAN8740/LAN8742 PHYs support basic unicast, broadcast, and Magic
Packet WoL.  They have one pattern filter matching up to 128 bytes of
frame data, which can be used to implement ARP and multicast WoL.

ARP WoL matches ARP request for IPv4 address of the net device using the
PHY.

Multicast WoL matches IPv6 Neighbor Solicitation which is sent when
sombody wants to talk to the net device using IPv6.  This implementation
may not be appropriate and can be changed by users later.

Signed-off-by: Tristram Ha <Tristram.Ha@microchip.com>
---
 drivers/net/phy/smsc.c  | 324 +++++++++++++++++++++++++++++++++++++++++++++++-
 include/linux/smscphy.h |  36 ++++++
 2 files changed, 358 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/smsc.c b/drivers/net/phy/smsc.c
index 69423b8..5b77f0c 100644
--- a/drivers/net/phy/smsc.c
+++ b/drivers/net/phy/smsc.c
@@ -20,6 +20,11 @@
 #include <linux/of.h>
 #include <linux/phy.h>
 #include <linux/netdevice.h>
+#include <linux/etherdevice.h>
+#include <linux/crc16.h>
+#include <linux/inetdevice.h>
+#include <net/ipv6.h>
+#include <net/if_inet6.h>
 #include <linux/smscphy.h>
 
 /* Vendor-specific PHY Definitions */
@@ -46,6 +51,7 @@ struct smsc_hw_stat {
 struct smsc_phy_priv {
 	u16 intmask;
 	bool energy_enable;
+	struct ethtool_wolinfo wol;
 	struct clk *refclk;
 };
 
@@ -246,6 +252,312 @@ static int lan87xx_read_status(struct phy_device *phydev)
 	return err;
 }
 
+static int lan874x_phy_config_init(struct phy_device *phydev)
+{
+	u16 val;
+	int rc;
+
+	/* set nPME self clear delay time */
+	rc = phy_write_mmd(phydev, MDIO_MMD_PCS, MII_LAN874X_PHY_MMD_MCFGR,
+			   MII_LAN874X_PHY_PME_SELF_CLEAR_DELAY);
+	if (rc < 0)
+		return rc;
+
+	/* MII_LAN874X_PHY_PME1_SET set LED1/nINT/nPME pin function as nPME */
+	/* MII_LAN874X_PHY_PME2_SET set LED2/nINT/nPME pin function as nPME */
+	/* set nPME auto clear */
+	val = (MII_LAN874X_PHY_PME2_SET | MII_LAN874X_PHY_PME_SELF_CLEAR);
+	rc = phy_write_mmd(phydev, MDIO_MMD_PCS, MII_LAN874X_PHY_MMD_WOL_WUCSR,
+			   val);
+	if (rc < 0)
+		return rc;
+
+	return smsc_phy_config_init(phydev);
+}
+
+static void lan874x_get_wol(struct phy_device *phydev,
+			    struct ethtool_wolinfo *wol)
+{
+	struct smsc_phy_priv *priv = phydev->priv;
+	u16 val_wucsr;
+	int rc;
+
+	wol->supported = (WAKE_UCAST | WAKE_BCAST | WAKE_MAGIC |
+			  WAKE_ARP | WAKE_MCAST);
+	wol->wolopts = 0;
+
+	rc = phy_read_mmd(phydev, MDIO_MMD_PCS, MII_LAN874X_PHY_MMD_WOL_WUCSR);
+	if (rc < 0)
+		return;
+
+	val_wucsr = (u16)rc;
+
+	if (val_wucsr & MII_LAN874X_PHY_WOL_PFDAEN)
+		wol->wolopts |= WAKE_UCAST;
+
+	if (val_wucsr & MII_LAN874X_PHY_WOL_BCSTEN)
+		wol->wolopts |= WAKE_BCAST;
+
+	if (val_wucsr & MII_LAN874X_PHY_WOL_MPEN)
+		wol->wolopts |= WAKE_MAGIC;
+
+	if (val_wucsr & MII_LAN874X_PHY_WOL_WUEN) {
+		if (priv->wol.wolopts & WAKE_ARP)
+			wol->wolopts |= WAKE_ARP;
+		if (priv->wol.wolopts & WAKE_MCAST)
+			wol->wolopts |= WAKE_MCAST;
+	}
+
+	/* WoL event notification */
+	if (val_wucsr & MII_LAN874X_PHY_WOL_WUFR) {
+		if (wol->wolopts & WAKE_ARP)
+			phydev_info(phydev, "ARP WoL event received\n");
+		if (wol->wolopts & WAKE_MCAST)
+			phydev_info(phydev, "MCAST WoL event received\n");
+	}
+
+	if (val_wucsr & MII_LAN874X_PHY_WOL_PFDA_FR)
+		phydev_info(phydev, "UCAST WoL event received\n");
+
+	if (val_wucsr & MII_LAN874X_PHY_WOL_BCAST_FR)
+		phydev_info(phydev, "BCAST WoL event received\n");
+
+	if (val_wucsr & MII_LAN874X_PHY_WOL_MPR)
+		phydev_info(phydev, "Magic WoL event received\n");
+
+	/* clear WoL event */
+	rc = phy_write_mmd(phydev, MDIO_MMD_PCS, MII_LAN874X_PHY_MMD_WOL_WUCSR,
+			   val_wucsr);
+	if (rc < 0)
+		return;
+}
+
+static u16 smsc_crc16(const u8 *buffer, size_t len)
+{
+	u16 crc = bitrev16(crc16(0xFFFF, buffer, len));
+	return crc;
+}
+
+static int lan874x_chk_wol_pattern(const u8 pattern[], const u16 *mask,
+				   u8 len, u8 *data, u8 *datalen)
+{
+	size_t i, j, k;
+	u16 bits;
+
+	i = 0;
+	k = 0;
+	while (len > 0) {
+		bits = *mask;
+		for (j = 0; j < 16; j++, i++, len--) {
+			/* No more pattern. */
+			if (!len) {
+				/* The rest of bitmap is not empty. */
+				if (bits)
+					return i + 1;
+				break;
+			}
+			if (bits & 1)
+				data[k++] = pattern[i];
+			bits >>= 1;
+		}
+		mask++;
+	}
+	*datalen = k;
+	return 0;
+}
+
+static int lan874x_set_wol_pattern(struct phy_device *phydev, u16 val,
+				   const u8 data[], u8 datalen,
+				   const u16 *mask, u8 masklen)
+{
+	u16 crc, reg;
+	int rc;
+
+	val |= MII_LAN874X_PHY_WOL_FILTER_EN;
+	rc = phy_write_mmd(phydev, MDIO_MMD_PCS,
+			   MII_LAN874X_PHY_MMD_WOL_WUF_CFGA, val);
+	if (rc < 0)
+		return rc;
+
+	crc = smsc_crc16(data, datalen);
+	rc = phy_write_mmd(phydev, MDIO_MMD_PCS,
+			   MII_LAN874X_PHY_MMD_WOL_WUF_CFGB, crc);
+	if (rc < 0)
+		return rc;
+
+	masklen = (masklen + 15) & ~0xf;
+	reg = MII_LAN874X_PHY_MMD_WOL_WUF_MASK7;
+	while (masklen >= 16) {
+		rc = phy_write_mmd(phydev, MDIO_MMD_PCS, reg, *mask);
+		if (rc < 0)
+			return rc;
+		reg--;
+		mask++;
+		masklen -= 16;
+	}
+
+	/* Clear out the rest of mask registers. */
+	while (reg != MII_LAN874X_PHY_MMD_WOL_WUF_MASK0) {
+		phy_write_mmd(phydev, MDIO_MMD_PCS, reg, 0);
+		reg--;
+	}
+	return rc;
+}
+
+static int lan874x_set_wol(struct phy_device *phydev,
+			   struct ethtool_wolinfo *wol)
+{
+	struct net_device *ndev = phydev->attached_dev;
+	struct smsc_phy_priv *priv = phydev->priv;
+	u16 val, val_wucsr;
+	int i = 0, rc;
+	u8 data[128];
+	u8 datalen;
+
+	if (wol->wolopts & WAKE_PHY)
+		return -EOPNOTSUPP;
+
+	/* lan874x has only one WoL filter pattern */
+	if (wol->wolopts & (WAKE_ARP | WAKE_MCAST)) {
+		if (wol->wolopts & WAKE_ARP)
+			i++;
+		if (wol->wolopts & WAKE_MCAST)
+			i++;
+		if (i >= 2) {
+			phydev_info(phydev,
+				    "lan874x WoL supports one of ARP|MCAST at a time\n");
+			return -EOPNOTSUPP;
+		}
+	}
+
+	rc = phy_read_mmd(phydev, MDIO_MMD_PCS, MII_LAN874X_PHY_MMD_WOL_WUCSR);
+	if (rc < 0)
+		return rc;
+
+	val_wucsr = (u16)rc;
+
+	if (wol->wolopts & WAKE_UCAST)
+		val_wucsr |= MII_LAN874X_PHY_WOL_PFDAEN;
+	else
+		val_wucsr &= ~MII_LAN874X_PHY_WOL_PFDAEN;
+
+	if (wol->wolopts & WAKE_BCAST)
+		val_wucsr |= MII_LAN874X_PHY_WOL_BCSTEN;
+	else
+		val_wucsr &= ~MII_LAN874X_PHY_WOL_BCSTEN;
+
+	if (wol->wolopts & WAKE_MAGIC)
+		val_wucsr |= MII_LAN874X_PHY_WOL_MPEN;
+	else
+		val_wucsr &= ~MII_LAN874X_PHY_WOL_MPEN;
+
+	/* Need to use pattern matching */
+	if (i > 0)
+		val_wucsr |= MII_LAN874X_PHY_WOL_WUEN;
+	else
+		val_wucsr &= ~MII_LAN874X_PHY_WOL_WUEN;
+
+	if (wol->wolopts & WAKE_ARP) {
+		const u8 *ip_addr =
+			((const u8 *)&((ndev->ip_ptr)->ifa_list)->ifa_address);
+		u8 pattern[42] = {
+			0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
+			0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+			0x08, 0x06,
+			0x00, 0x01, 0x08, 0x00, 0x06, 0x04, 0x00, 0x01,
+			0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+			0x00, 0x00, 0x00, 0x00,
+			0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+			0x00, 0x00, 0x00, 0x00 };
+		const u16 mask[3] = { 0xF03F, 0x003F, 0x03C0 };
+		u16 offset = 0;
+		u8 len = 42;
+
+		memcpy(&pattern[38], ip_addr, 4);
+		rc = lan874x_chk_wol_pattern(&pattern[offset], mask, len,
+					     data, &datalen);
+		if (rc)
+			phydev_info(phydev, "pattern not valid at %d\n", rc);
+
+		/* Need to match broadcast destination address. */
+		val = offset |
+		      MII_LAN874X_PHY_WOL_FILTER_BCSTEN;
+		rc = lan874x_set_wol_pattern(phydev, val, data, datalen, mask,
+					     len);
+		if (rc < 0)
+			return rc;
+	}
+
+	if (wol->wolopts & WAKE_MCAST) {
+		u8 pattern[6] = { 0x33, 0x33, 0xFF, 0x00, 0x00, 0x00 };
+		u16 mask[1] = { 0x0007 };
+		u8 len = 3;
+
+		/* Try to match IPv6 Neighbor Solicitation. */
+		if (ndev->ip6_ptr) {
+			struct list_head *addr_list =
+				&ndev->ip6_ptr->addr_list;
+			struct inet6_ifaddr *ifa;
+
+			list_for_each_entry(ifa, addr_list, if_list) {
+				if (ifa->scope == IFA_LINK) {
+					memcpy(&pattern[3],
+					       &ifa->addr.in6_u.u6_addr8[13],
+					       3);
+					mask[0] = 0x003F;
+					len = 6;
+					break;
+				}
+			}
+		}
+		rc = lan874x_chk_wol_pattern(pattern, mask, len,
+					     data, &datalen);
+		if (rc)
+			phydev_info(phydev, "pattern not valid at %d\n", rc);
+
+		/* Need to match multicast destination address. */
+		val = 0 |
+		      MII_LAN874X_PHY_WOL_FILTER_MCASTTEN;
+		rc = lan874x_set_wol_pattern(phydev, val, data, datalen, mask,
+					     len);
+		if (rc < 0)
+			return rc;
+	}
+
+	if (wol->wolopts & (WAKE_MAGIC | WAKE_UCAST)) {
+		const u8 *mac = (const u8 *)ndev->dev_addr;
+
+		if (!is_valid_ether_addr(mac))
+			return -EINVAL;
+
+		rc = phy_write_mmd(phydev, MDIO_MMD_PCS,
+				   MII_LAN874X_PHY_MMD_WOL_RX_ADDRC,
+				   ((mac[1] << 8) | mac[0]));
+		if (rc < 0)
+			return rc;
+
+		rc = phy_write_mmd(phydev, MDIO_MMD_PCS,
+				   MII_LAN874X_PHY_MMD_WOL_RX_ADDRB,
+				   ((mac[3] << 8) | mac[2]));
+		if (rc < 0)
+			return rc;
+
+		rc = phy_write_mmd(phydev, MDIO_MMD_PCS,
+				   MII_LAN874X_PHY_MMD_WOL_RX_ADDRA,
+				   ((mac[5] << 8) | mac[4]));
+		if (rc < 0)
+			return rc;
+	}
+
+	rc = phy_write_mmd(phydev, MDIO_MMD_PCS, MII_LAN874X_PHY_MMD_WOL_WUCSR,
+			   val_wucsr);
+	if (rc < 0)
+		return rc;
+
+	priv->wol = *wol;
+	return 0;
+}
+
 static int smsc_get_sset_count(struct phy_device *phydev)
 {
 	return ARRAY_SIZE(smsc_hw_stats);
@@ -460,7 +772,7 @@ static int smsc_phy_probe(struct phy_device *phydev)
 
 	/* basic functions */
 	.read_status	= lan87xx_read_status,
-	.config_init	= smsc_phy_config_init,
+	.config_init	= lan874x_phy_config_init,
 	.soft_reset	= smsc_phy_reset,
 
 	/* IRQ related */
@@ -472,6 +784,10 @@ static int smsc_phy_probe(struct phy_device *phydev)
 	.get_strings	= smsc_get_strings,
 	.get_stats	= smsc_get_stats,
 
+	/* WoL */
+	.set_wol	= lan874x_set_wol,
+	.get_wol	= lan874x_get_wol,
+
 	.suspend	= genphy_suspend,
 	.resume		= genphy_resume,
 }, {
@@ -490,7 +806,7 @@ static int smsc_phy_probe(struct phy_device *phydev)
 
 	/* basic functions */
 	.read_status	= lan87xx_read_status,
-	.config_init	= smsc_phy_config_init,
+	.config_init	= lan874x_phy_config_init,
 	.soft_reset	= smsc_phy_reset,
 
 	/* IRQ related */
@@ -502,6 +818,10 @@ static int smsc_phy_probe(struct phy_device *phydev)
 	.get_strings	= smsc_get_strings,
 	.get_stats	= smsc_get_stats,
 
+	/* WoL */
+	.set_wol	= lan874x_set_wol,
+	.get_wol	= lan874x_get_wol,
+
 	.suspend	= genphy_suspend,
 	.resume		= genphy_resume,
 } };
diff --git a/include/linux/smscphy.h b/include/linux/smscphy.h
index 1a13627..f5e123b 100644
--- a/include/linux/smscphy.h
+++ b/include/linux/smscphy.h
@@ -28,4 +28,40 @@
 #define MII_LAN83C185_MODE_POWERDOWN 0xC0 /* Power Down mode */
 #define MII_LAN83C185_MODE_ALL       0xE0 /* All capable mode */
 
+#define MII_LAN874X_PHY_MMD_WOL_WUCSR		0x8010
+#define MII_LAN874X_PHY_MMD_WOL_WUF_CFGA	0x8011
+#define MII_LAN874X_PHY_MMD_WOL_WUF_CFGB	0x8012
+#define MII_LAN874X_PHY_MMD_WOL_WUF_MASK0	0x8021
+#define MII_LAN874X_PHY_MMD_WOL_WUF_MASK1	0x8022
+#define MII_LAN874X_PHY_MMD_WOL_WUF_MASK2	0x8023
+#define MII_LAN874X_PHY_MMD_WOL_WUF_MASK3	0x8024
+#define MII_LAN874X_PHY_MMD_WOL_WUF_MASK4	0x8025
+#define MII_LAN874X_PHY_MMD_WOL_WUF_MASK5	0x8026
+#define MII_LAN874X_PHY_MMD_WOL_WUF_MASK6	0x8027
+#define MII_LAN874X_PHY_MMD_WOL_WUF_MASK7	0x8028
+#define MII_LAN874X_PHY_MMD_WOL_RX_ADDRA	0x8061
+#define MII_LAN874X_PHY_MMD_WOL_RX_ADDRB	0x8062
+#define MII_LAN874X_PHY_MMD_WOL_RX_ADDRC	0x8063
+#define MII_LAN874X_PHY_MMD_MCFGR		0x8064
+
+#define MII_LAN874X_PHY_PME1_SET		(2<<13)
+#define MII_LAN874X_PHY_PME2_SET		(2<<11)
+#define MII_LAN874X_PHY_PME_SELF_CLEAR		BIT(9)
+#define MII_LAN874X_PHY_WOL_PFDA_FR		BIT(7)
+#define MII_LAN874X_PHY_WOL_WUFR		BIT(6)
+#define MII_LAN874X_PHY_WOL_MPR			BIT(5)
+#define MII_LAN874X_PHY_WOL_BCAST_FR		BIT(4)
+#define MII_LAN874X_PHY_WOL_PFDAEN		BIT(3)
+#define MII_LAN874X_PHY_WOL_WUEN		BIT(2)
+#define MII_LAN874X_PHY_WOL_MPEN		BIT(1)
+#define MII_LAN874X_PHY_WOL_BCSTEN		BIT(0)
+
+#define MII_LAN874X_PHY_WOL_FILTER_EN		BIT(15)
+#define MII_LAN874X_PHY_WOL_FILTER_MCASTTEN	BIT(9)
+#define MII_LAN874X_PHY_WOL_FILTER_BCSTEN	BIT(8)
+
+#define MII_LAN874X_PHY_PME_SELF_CLEAR_DELAY	0x1000 /* 81 milliseconds */
+
+#define MII_LAN874X_PHY_WOL_IMEN		BIT(8) /* WoL intr enable  */
+
 #endif /* __LINUX_SMSCPHY_H__ */
-- 
1.9.1

