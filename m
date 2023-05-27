Return-Path: <netdev+bounces-5840-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 22B5271318B
	for <lists+netdev@lfdr.de>; Sat, 27 May 2023 03:39:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B23AC2816F7
	for <lists+netdev@lfdr.de>; Sat, 27 May 2023 01:39:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AEB24383;
	Sat, 27 May 2023 01:39:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 994E137D
	for <netdev@vger.kernel.org>; Sat, 27 May 2023 01:39:23 +0000 (UTC)
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E836EFB
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 18:39:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1685151558; x=1716687558;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=44IQh0pXJbJpoejBpPqEJFoFaBorD+sYkeIPitTchSI=;
  b=iX56ABfsaOYR3a3WSqSsnOU7mEqmIIwZtukKGND55v4lVPm9EXuELMJ6
   rouT1MILtcIdHMH/g7Uj4u61ttlF2gaBx+u4KQYgyKRkDV/lP9ltFLHhX
   H2UXSshPZtUSR3NFJEOC/rChz6jpc5qORbrwInZ8HJkCqFHCKYx3mzjgS
   e/NbLwDeiMgMtQiUF19GZ2/2GD+4M76vVeoC1FkzNsk+HyUS+IQDbIOuq
   RetYHkh0F2KZQ1ckE8c5bLCTJRCuq/WaDU2YIzgRSPDSFLg80udnHMozb
   HBAxmXLcgqtd98VJh+4Z0hyGBUX8tACXH9sltbP23zW+iLLoRtPu99mxR
   w==;
X-IronPort-AV: E=Sophos;i="6.00,195,1681196400"; 
   d="scan'208";a="215114823"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 26 May 2023 18:39:18 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 26 May 2023 18:39:17 -0700
Received: from hat-linux.microchip.com (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2507.21 via Frontend Transport; Fri, 26 May 2023 18:39:17 -0700
From: <Tristram.Ha@microchip.com>
To: "David S. Miller" <davem@davemloft.net>, Andrew Lunn <andrew@lunn.ch>,
	Florian Fainelli <f.fainelli@gmail.com>
CC: <netdev@vger.kernel.org>, <UNGLinuxDriver@microchip.com>, Tristram Ha
	<Tristram.Ha@microchip.com>
Subject: [PATCH net-next] net: phy: smsc: add WoL support to LAN8740/LAN8742 PHYs.
Date: Fri, 26 May 2023 18:39:34 -0700
Message-ID: <1685151574-2752-1-git-send-email-Tristram.Ha@microchip.com>
X-Mailer: git-send-email 1.9.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Tristram Ha <Tristram.Ha@microchip.com>

Microchip LAN8740/LAN8742 PHYs support basic unicast, broadcast, and
Magic Packet WoL.  They have one pattern filter matching up to 128 bytes
of frame data, which can be used to implement ARP or multicast WoL.

ARP WoL matches ARP request for IPv4 address of the net device using the
PHY.

Multicast WoL matches IPv6 Neighbor Solicitation which is sent when
somebody wants to talk to the net device using IPv6.  This
implementation may not be appropriate and can be changed by users later.

Signed-off-by: Tristram Ha <Tristram.Ha@microchip.com>
---
 drivers/net/phy/smsc.c  | 297 +++++++++++++++++++++++++++++++++++++++-
 include/linux/smscphy.h |  34 +++++
 2 files changed, 329 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/smsc.c b/drivers/net/phy/smsc.c
index 692930750215..99c1eb0ab395 100644
--- a/drivers/net/phy/smsc.c
+++ b/drivers/net/phy/smsc.c
@@ -20,6 +20,11 @@
 #include <linux/of.h>
 #include <linux/phy.h>
 #include <linux/netdevice.h>
+#include <linux/crc16.h>
+#include <linux/etherdevice.h>
+#include <linux/inetdevice.h>
+#include <net/if_inet6.h>
+#include <net/ipv6.h>
 #include <linux/smscphy.h>
 
 /* Vendor-specific PHY Definitions */
@@ -51,6 +56,7 @@ struct smsc_phy_priv {
 	unsigned int edpd_enable:1;
 	unsigned int edpd_mode_set_by_user:1;
 	unsigned int edpd_max_wait_ms;
+	bool wol_arp;
 };
 
 static int smsc_phy_ack_interrupt(struct phy_device *phydev)
@@ -258,6 +264,285 @@ int lan87xx_read_status(struct phy_device *phydev)
 }
 EXPORT_SYMBOL_GPL(lan87xx_read_status);
 
+static int lan874x_phy_config_init(struct phy_device *phydev)
+{
+	u16 val;
+	int rc;
+
+	/* Setup LED2/nINT/nPME pin to function as nPME.  May need user option
+	 * to use LED1/nINT/nPME.
+	 */
+	val = MII_LAN874X_PHY_PME2_SET;
+
+	/* The bits MII_LAN874X_PHY_WOL_PFDA_FR, MII_LAN874X_PHY_WOL_WUFR,
+	 * MII_LAN874X_PHY_WOL_MPR, and MII_LAN874X_PHY_WOL_BCAST_FR need to
+	 * be cleared to de-assert PME signal after a WoL event happens, but
+	 * using PME auto clear gets around that.
+	 */
+	val |= MII_LAN874X_PHY_PME_SELF_CLEAR;
+	rc = phy_write_mmd(phydev, MDIO_MMD_PCS, MII_LAN874X_PHY_MMD_WOL_WUCSR,
+			   val);
+	if (rc < 0)
+		return rc;
+
+	/* set nPME self clear delay time */
+	rc = phy_write_mmd(phydev, MDIO_MMD_PCS, MII_LAN874X_PHY_MMD_MCFGR,
+			   MII_LAN874X_PHY_PME_SELF_CLEAR_DELAY);
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
+	if (rc & MII_LAN874X_PHY_WOL_PFDAEN)
+		wol->wolopts |= WAKE_UCAST;
+
+	if (rc & MII_LAN874X_PHY_WOL_BCSTEN)
+		wol->wolopts |= WAKE_BCAST;
+
+	if (rc & MII_LAN874X_PHY_WOL_MPEN)
+		wol->wolopts |= WAKE_MAGIC;
+
+	if (rc & MII_LAN874X_PHY_WOL_WUEN) {
+		if (priv->wol_arp)
+			wol->wolopts |= WAKE_ARP;
+		else
+			wol->wolopts |= WAKE_MCAST;
+	}
+}
+
+static u16 smsc_crc16(const u8 *buffer, size_t len)
+{
+	return bitrev16(crc16(0xFFFF, buffer, len));
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
+	u8 data[128];
+	u8 datalen;
+	int rc;
+
+	if (wol->wolopts & WAKE_PHY)
+		return -EOPNOTSUPP;
+
+	/* lan874x has only one WoL filter pattern */
+	if ((wol->wolopts & (WAKE_ARP | WAKE_MCAST)) ==
+	    (WAKE_ARP | WAKE_MCAST)) {
+		phydev_info(phydev,
+			    "lan874x WoL supports one of ARP|MCAST at a time\n");
+		return -EOPNOTSUPP;
+	}
+
+	rc = phy_read_mmd(phydev, MDIO_MMD_PCS, MII_LAN874X_PHY_MMD_WOL_WUCSR);
+	if (rc < 0)
+		return rc;
+
+	val_wucsr = rc;
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
+	if (wol->wolopts & (WAKE_ARP | WAKE_MCAST))
+		val_wucsr |= MII_LAN874X_PHY_WOL_WUEN;
+	else
+		val_wucsr &= ~MII_LAN874X_PHY_WOL_WUEN;
+
+	if (wol->wolopts & WAKE_ARP) {
+		const u8 *ip_addr =
+			((const u8 *)&((ndev->ip_ptr)->ifa_list)->ifa_address);
+		const u16 mask[3] = { 0xF03F, 0x003F, 0x03C0 };
+		u8 pattern[42] = {
+			0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
+			0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+			0x08, 0x06,
+			0x00, 0x01, 0x08, 0x00, 0x06, 0x04, 0x00, 0x01,
+			0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+			0x00, 0x00, 0x00, 0x00,
+			0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+			0x00, 0x00, 0x00, 0x00 };
+		u8 len = 42;
+
+		memcpy(&pattern[38], ip_addr, 4);
+		rc = lan874x_chk_wol_pattern(pattern, mask, len,
+					     data, &datalen);
+		if (rc)
+			phydev_dbg(phydev, "pattern not valid at %d\n", rc);
+
+		/* Need to match broadcast destination address. */
+		val = MII_LAN874X_PHY_WOL_FILTER_BCSTEN;
+		rc = lan874x_set_wol_pattern(phydev, val, data, datalen, mask,
+					     len);
+		if (rc < 0)
+			return rc;
+		priv->wol_arp = true;
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
+			phydev_dbg(phydev, "pattern not valid at %d\n", rc);
+
+		/* Need to match multicast destination address. */
+		val = MII_LAN874X_PHY_WOL_FILTER_MCASTTEN;
+		rc = lan874x_set_wol_pattern(phydev, val, data, datalen, mask,
+					     len);
+		if (rc < 0)
+			return rc;
+		priv->wol_arp = false;
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
+	return 0;
+}
+
 static int smsc_get_sset_count(struct phy_device *phydev)
 {
 	return ARRAY_SIZE(smsc_hw_stats);
@@ -533,7 +818,7 @@ static struct phy_driver smsc_phy_driver[] = {
 
 	/* basic functions */
 	.read_status	= lan87xx_read_status,
-	.config_init	= smsc_phy_config_init,
+	.config_init	= lan874x_phy_config_init,
 	.soft_reset	= smsc_phy_reset,
 
 	/* IRQ related */
@@ -548,6 +833,10 @@ static struct phy_driver smsc_phy_driver[] = {
 	.get_tunable	= smsc_phy_get_tunable,
 	.set_tunable	= smsc_phy_set_tunable,
 
+	/* WoL */
+	.set_wol	= lan874x_set_wol,
+	.get_wol	= lan874x_get_wol,
+
 	.suspend	= genphy_suspend,
 	.resume		= genphy_resume,
 }, {
@@ -566,7 +855,7 @@ static struct phy_driver smsc_phy_driver[] = {
 
 	/* basic functions */
 	.read_status	= lan87xx_read_status,
-	.config_init	= smsc_phy_config_init,
+	.config_init	= lan874x_phy_config_init,
 	.soft_reset	= smsc_phy_reset,
 
 	/* IRQ related */
@@ -581,6 +870,10 @@ static struct phy_driver smsc_phy_driver[] = {
 	.get_tunable	= smsc_phy_get_tunable,
 	.set_tunable	= smsc_phy_set_tunable,
 
+	/* WoL */
+	.set_wol	= lan874x_set_wol,
+	.get_wol	= lan874x_get_wol,
+
 	.suspend	= genphy_suspend,
 	.resume		= genphy_resume,
 } };
diff --git a/include/linux/smscphy.h b/include/linux/smscphy.h
index e1c88627755a..b876333257bf 100644
--- a/include/linux/smscphy.h
+++ b/include/linux/smscphy.h
@@ -38,4 +38,38 @@ int smsc_phy_set_tunable(struct phy_device *phydev,
 			 struct ethtool_tunable *tuna, const void *data);
 int smsc_phy_probe(struct phy_device *phydev);
 
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
 #endif /* __LINUX_SMSCPHY_H__ */
-- 
2.17.1


