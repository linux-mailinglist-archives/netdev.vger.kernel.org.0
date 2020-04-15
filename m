Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C34941A9F77
	for <lists+netdev@lfdr.de>; Wed, 15 Apr 2020 14:14:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S368624AbgDOMMm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Apr 2020 08:12:42 -0400
Received: from metis.ext.pengutronix.de ([85.220.165.71]:39789 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2898086AbgDOMMi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Apr 2020 08:12:38 -0400
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1jOgty-0007dM-5F; Wed, 15 Apr 2020 14:12:22 +0200
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1jOgtt-0004Pk-GB; Wed, 15 Apr 2020 14:12:17 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Michal Kubecek <mkubecek@suse.cz>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        David Jander <david@protonic.nl>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>, mkl@pengutronix.de
Subject: [PATCH v1] ethtool: provide UAPI for PHY master/slave configuration.
Date:   Wed, 15 Apr 2020 14:12:09 +0200
Message-Id: <20200415121209.12197-1-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.26.0.rc2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This UAPI is needed for BroadR-Reach 100BASE-T1 devices. Due to lack of
auto-negotiation support, we needed to be able to configure the
MASTER-SLAVE role of the port manually or from an application in user
space.

The same UAPI can be used for 1000BASE-T or MultiGBASE-T devices to
force MASTER or SLAVE role. See IEEE 802.3-2018:
22.2.4.3.7 MASTER-SLAVE control register (Register 9)
22.2.4.3.8 MASTER-SLAVE status register (Register 10)
40.5.2 MASTER-SLAVE configuration resolution
45.2.1.185.1 MASTER-SLAVE config value (1.2100.14)
45.2.7.10 MultiGBASE-T AN control 1 register (Register 7.32)

The MASTER-SLAVE role affects the clock configuration:

-------------------------------------------------------------------------------
When the  PHY is configured as MASTER, the PMA Transmit function shall
source TX_TCLK from a local clock source. When configured as SLAVE, the
PMA Transmit function shall source TX_TCLK from the clock recovered from
data stream provided by MASTER.

iMX6Q                     KSZ9031                XXX
------\                /-----------\        /------------\
      |                |           |        |            |
 MAC  |<----RGMII----->| PHY Slave |<------>| PHY Master |
      |<--- 125 MHz ---+-<------/  |        | \          |
------/                \-----------/        \------------/
                                               ^
                                                \-TX_TCLK

-------------------------------------------------------------------------------

Since some clock or link related issues are only reproducible in a
specific MASTER-SLAVE-role, MAC and PHY configuration, it is beneficial
to provide generic (not 100BASE-T1 specific) interface to the user space
for configuration flexibility and trouble shooting.

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 Documentation/networking/ethtool-netlink.rst |  2 +
 drivers/net/phy/phy.c                        |  3 +-
 drivers/net/phy/phy_device.c                 | 75 ++++++++++++++++++++
 include/linux/phy.h                          |  1 +
 include/uapi/linux/ethtool.h                 | 11 ++-
 include/uapi/linux/ethtool_netlink.h         |  1 +
 include/uapi/linux/mii.h                     |  2 +
 net/ethtool/linkmodes.c                      |  9 ++-
 8 files changed, 101 insertions(+), 3 deletions(-)

diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation/networking/ethtool-netlink.rst
index f1f868479ceb8..83127a6e42b17 100644
--- a/Documentation/networking/ethtool-netlink.rst
+++ b/Documentation/networking/ethtool-netlink.rst
@@ -368,6 +368,7 @@ Kernel response contents:
   ``ETHTOOL_A_LINKMODES_PEER``          bitset  partner link modes
   ``ETHTOOL_A_LINKMODES_SPEED``         u32     link speed (Mb/s)
   ``ETHTOOL_A_LINKMODES_DUPLEX``        u8      duplex mode
+  ``ETHTOOL_A_LINKMODES_MASTER_SLAVE``  u8      Master/slave port mode
   ====================================  ======  ==========================
 
 For ``ETHTOOL_A_LINKMODES_OURS``, value represents advertised modes and mask
@@ -390,6 +391,7 @@ Request contents:
   ``ETHTOOL_A_LINKMODES_PEER``          bitset  partner link modes
   ``ETHTOOL_A_LINKMODES_SPEED``         u32     link speed (Mb/s)
   ``ETHTOOL_A_LINKMODES_DUPLEX``        u8      duplex mode
+  ``ETHTOOL_A_LINKMODES_MASTER_SLAVE``  u8      Master/slave port mode
   ====================================  ======  ==========================
 
 ``ETHTOOL_A_LINKMODES_OURS`` bit set allows setting advertised link modes. If
diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index d76e038cf2cb5..9f48141f1e701 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -294,7 +294,7 @@ int phy_ethtool_ksettings_set(struct phy_device *phydev,
 			 phydev->advertising, autoneg == AUTONEG_ENABLE);
 
 	phydev->duplex = duplex;
-
+	phydev->master_slave = cmd->base.master_slave;
 	phydev->mdix_ctrl = cmd->base.eth_tp_mdix_ctrl;
 
 	/* Restart the PHY */
@@ -313,6 +313,7 @@ void phy_ethtool_ksettings_get(struct phy_device *phydev,
 
 	cmd->base.speed = phydev->speed;
 	cmd->base.duplex = phydev->duplex;
+	cmd->base.master_slave = phydev->master_slave;
 	if (phydev->interface == PHY_INTERFACE_MODE_MOCA)
 		cmd->base.port = PORT_BNC;
 	else
diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index c8b0c34030d32..d5edf2bc40e43 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -604,6 +604,7 @@ struct phy_device *phy_device_create(struct mii_bus *bus, int addr, u32 phy_id,
 	dev->asym_pause = 0;
 	dev->link = 0;
 	dev->interface = PHY_INTERFACE_MODE_GMII;
+	dev->master_slave = PORT_MODE_UNKNOWN;
 
 	dev->autoneg = AUTONEG_ENABLE;
 
@@ -1772,6 +1773,68 @@ int genphy_setup_forced(struct phy_device *phydev)
 }
 EXPORT_SYMBOL(genphy_setup_forced);
 
+static int genphy_setup_master_slave(struct phy_device *phydev)
+{
+	u16 ctl = 0;
+
+	if (!phydev->is_gigabit_capable)
+		return 0;
+
+	switch (phydev->master_slave) {
+	case PORT_MODE_MASTER:
+		ctl |= CTL1000_PREFER_MASTER;
+		/* fallthrough */
+	case PORT_MODE_SLAVE:
+		/* CTL1000_ENABLE_MASTER is zero */
+		break;
+	case PORT_MODE_MASTER_FORCE:
+		ctl |= CTL1000_AS_MASTER;
+		/* fallthrough */
+	case PORT_MODE_SLAVE_FORCE:
+		ctl |= CTL1000_ENABLE_MASTER;
+		break;
+	case PORT_MODE_UNKNOWN:
+		return 0;
+	default:
+		phydev_warn(phydev, "Unsupported Master/Slave mode\n");
+		return 0;
+	}
+
+	return phy_modify_changed(phydev, MII_CTRL1000,
+				  (CTL1000_ENABLE_MASTER | CTL1000_AS_MASTER |
+				   CTL1000_PREFER_MASTER), ctl);
+}
+
+static int genphy_read_master_slave(struct phy_device *phydev)
+{
+	u16 ctl, stat;
+
+	if (!phydev->is_gigabit_capable)
+		return 0;
+
+	ctl = phy_read(phydev, MII_CTRL1000);
+	if (ctl < 0)
+		return ctl;
+
+	stat = phy_read(phydev, MII_STAT1000);
+	if (stat < 0)
+		return stat;
+
+	if (ctl & CTL1000_ENABLE_MASTER) {
+		if (stat & LPA_1000MSRES)
+			phydev->master_slave = PORT_MODE_MASTER_FORCE;
+		else
+			phydev->master_slave = PORT_MODE_SLAVE_FORCE;
+	} else {
+		if (stat & LPA_1000MSRES)
+			phydev->master_slave = PORT_MODE_MASTER;
+		else
+			phydev->master_slave = PORT_MODE_SLAVE;
+	}
+
+	return 0;
+}
+
 /**
  * genphy_restart_aneg - Enable and Restart Autonegotiation
  * @phydev: target phy_device struct
@@ -1830,6 +1893,12 @@ int __genphy_config_aneg(struct phy_device *phydev, bool changed)
 	if (genphy_config_eee_advert(phydev))
 		changed = true;
 
+	err = genphy_setup_master_slave(phydev);
+	if (err < 0)
+		return err;
+	else if (err)
+		changed = true;
+
 	if (AUTONEG_ENABLE != phydev->autoneg)
 		return genphy_setup_forced(phydev);
 
@@ -2062,6 +2131,11 @@ int genphy_read_status(struct phy_device *phydev)
 	phydev->duplex = DUPLEX_UNKNOWN;
 	phydev->pause = 0;
 	phydev->asym_pause = 0;
+	phydev->master_slave = PORT_MODE_UNKNOWN;
+
+	err = genphy_read_master_slave(phydev);
+	if (err < 0)
+		return err;
 
 	err = genphy_read_lpa(phydev);
 	if (err < 0)
@@ -2103,6 +2177,7 @@ int genphy_c37_read_status(struct phy_device *phydev)
 	phydev->duplex = DUPLEX_UNKNOWN;
 	phydev->pause = 0;
 	phydev->asym_pause = 0;
+	phydev->master_slave = PORT_MODE_UNKNOWN;
 
 	if (phydev->autoneg == AUTONEG_ENABLE && phydev->autoneg_complete) {
 		lpa = phy_read(phydev, MII_LPA);
diff --git a/include/linux/phy.h b/include/linux/phy.h
index c570e162e05e5..de5f934223069 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -421,6 +421,7 @@ struct phy_device {
 	int duplex;
 	int pause;
 	int asym_pause;
+	int master_slave;
 
 	/* Union of PHY and Attached devices' supported link modes */
 	/* See ethtool.h for more info */
diff --git a/include/uapi/linux/ethtool.h b/include/uapi/linux/ethtool.h
index 2405ab2263779..bcbc44003c823 100644
--- a/include/uapi/linux/ethtool.h
+++ b/include/uapi/linux/ethtool.h
@@ -1659,6 +1659,13 @@ static inline int ethtool_validate_duplex(__u8 duplex)
 	return 0;
 }
 
+/* Port mode */
+#define PORT_MODE_MASTER	0x00
+#define PORT_MODE_SLAVE		0x01
+#define PORT_MODE_MASTER_FORCE	0x02
+#define PORT_MODE_SLAVE_FORCE	0x03
+#define PORT_MODE_UNKNOWN	0xff
+
 /* Which connector port. */
 #define PORT_TP			0x00
 #define PORT_AUI		0x01
@@ -1850,6 +1857,7 @@ enum ethtool_reset_flags {
  *	autonegotiation; 0 if unknown or not applicable.  Read-only.
  * @transceiver: Used to distinguish different possible PHY types,
  *	reported consistently by PHYLIB.  Read-only.
+ * @master_slave: Master or slave port mode.
  *
  * If autonegotiation is disabled, the speed and @duplex represent the
  * fixed link mode and are writable if the driver supports multiple
@@ -1897,7 +1905,8 @@ struct ethtool_link_settings {
 	__u8	eth_tp_mdix_ctrl;
 	__s8	link_mode_masks_nwords;
 	__u8	transceiver;
-	__u8	reserved1[3];
+	__u8	master_slave;
+	__u8	reserved1[2];
 	__u32	reserved[7];
 	__u32	link_mode_masks[0];
 	/* layout of link_mode_masks fields:
diff --git a/include/uapi/linux/ethtool_netlink.h b/include/uapi/linux/ethtool_netlink.h
index 7e0b460f872c0..e04d47cb5f227 100644
--- a/include/uapi/linux/ethtool_netlink.h
+++ b/include/uapi/linux/ethtool_netlink.h
@@ -185,6 +185,7 @@ enum {
 	ETHTOOL_A_LINKMODES_PEER,		/* bitset */
 	ETHTOOL_A_LINKMODES_SPEED,		/* u32 */
 	ETHTOOL_A_LINKMODES_DUPLEX,		/* u8 */
+	ETHTOOL_A_LINKMODES_MASTER_SLAVE,	/* u8 */
 
 	/* add new constants above here */
 	__ETHTOOL_A_LINKMODES_CNT,
diff --git a/include/uapi/linux/mii.h b/include/uapi/linux/mii.h
index 0b9c3beda345b..78eac603a84fb 100644
--- a/include/uapi/linux/mii.h
+++ b/include/uapi/linux/mii.h
@@ -146,11 +146,13 @@
 /* 1000BASE-T Control register */
 #define ADVERTISE_1000FULL	0x0200  /* Advertise 1000BASE-T full duplex */
 #define ADVERTISE_1000HALF	0x0100  /* Advertise 1000BASE-T half duplex */
+#define CTL1000_PREFER_MASTER	0x0400  /* prefer to operate as master */
 #define CTL1000_AS_MASTER	0x0800
 #define CTL1000_ENABLE_MASTER	0x1000
 
 /* 1000BASE-T Status register */
 #define LPA_1000MSFAIL		0x8000	/* Master/Slave resolution failure */
+#define LPA_1000MSRES		0x4000	/* Master/Slave resolution status */
 #define LPA_1000LOCALRXOK	0x2000	/* Link partner local receiver status */
 #define LPA_1000REMRXOK		0x1000	/* Link partner remote receiver status */
 #define LPA_1000FULL		0x0800	/* Link partner 1000BASE-T full duplex */
diff --git a/net/ethtool/linkmodes.c b/net/ethtool/linkmodes.c
index 96f20be64553e..dc15b88e64c6a 100644
--- a/net/ethtool/linkmodes.c
+++ b/net/ethtool/linkmodes.c
@@ -27,6 +27,7 @@ linkmodes_get_policy[ETHTOOL_A_LINKMODES_MAX + 1] = {
 	[ETHTOOL_A_LINKMODES_PEER]		= { .type = NLA_REJECT },
 	[ETHTOOL_A_LINKMODES_SPEED]		= { .type = NLA_REJECT },
 	[ETHTOOL_A_LINKMODES_DUPLEX]		= { .type = NLA_REJECT },
+	[ETHTOOL_A_LINKMODES_MASTER_SLAVE]	= { .type = NLA_REJECT },
 };
 
 static int linkmodes_prepare_data(const struct ethnl_req_info *req_base,
@@ -69,6 +70,7 @@ static int linkmodes_reply_size(const struct ethnl_req_info *req_base,
 	len = nla_total_size(sizeof(u8)) /* LINKMODES_AUTONEG */
 		+ nla_total_size(sizeof(u32)) /* LINKMODES_SPEED */
 		+ nla_total_size(sizeof(u8)) /* LINKMODES_DUPLEX */
+		+ nla_total_size(sizeof(u8)) /* LINKMODES_MASTER_SLAVE */
 		+ 0;
 	ret = ethnl_bitset_size(ksettings->link_modes.advertising,
 				ksettings->link_modes.supported,
@@ -119,7 +121,9 @@ static int linkmodes_fill_reply(struct sk_buff *skb,
 	}
 
 	if (nla_put_u32(skb, ETHTOOL_A_LINKMODES_SPEED, lsettings->speed) ||
-	    nla_put_u8(skb, ETHTOOL_A_LINKMODES_DUPLEX, lsettings->duplex))
+	    nla_put_u8(skb, ETHTOOL_A_LINKMODES_DUPLEX, lsettings->duplex) ||
+	    nla_put_u8(skb, ETHTOOL_A_LINKMODES_MASTER_SLAVE,
+		       lsettings->master_slave))
 		return -EMSGSIZE;
 
 	return 0;
@@ -248,6 +252,7 @@ linkmodes_set_policy[ETHTOOL_A_LINKMODES_MAX + 1] = {
 	[ETHTOOL_A_LINKMODES_PEER]		= { .type = NLA_REJECT },
 	[ETHTOOL_A_LINKMODES_SPEED]		= { .type = NLA_U32 },
 	[ETHTOOL_A_LINKMODES_DUPLEX]		= { .type = NLA_U8 },
+	[ETHTOOL_A_LINKMODES_MASTER_SLAVE]	= { .type = NLA_U8 },
 };
 
 /* Set advertised link modes to all supported modes matching requested speed
@@ -310,6 +315,8 @@ static int ethnl_update_linkmodes(struct genl_info *info, struct nlattr **tb,
 			 mod);
 	ethnl_update_u8(&lsettings->duplex, tb[ETHTOOL_A_LINKMODES_DUPLEX],
 			mod);
+	ethnl_update_u8(&lsettings->master_slave,
+			tb[ETHTOOL_A_LINKMODES_MASTER_SLAVE], mod);
 
 	if (!tb[ETHTOOL_A_LINKMODES_OURS] && lsettings->autoneg &&
 	    (req_speed || req_duplex) &&
-- 
2.26.0.rc2

