Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9ED71C335C
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 09:12:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728009AbgEDHMb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 03:12:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727981AbgEDHM3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 03:12:29 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC72EC061A10
        for <netdev@vger.kernel.org>; Mon,  4 May 2020 00:12:28 -0700 (PDT)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1jVVH2-0001TZ-0P; Mon, 04 May 2020 09:12:20 +0200
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1jVVGx-0001YC-Rx; Mon, 04 May 2020 09:12:15 +0200
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
        Russell King <linux@armlinux.org.uk>, mkl@pengutronix.de,
        Marek Vasut <marex@denx.de>,
        Christian Herber <christian.herber@nxp.com>
Subject: [PATCH v5 1/2] ethtool: provide UAPI for PHY master/slave configuration.
Date:   Mon,  4 May 2020 09:12:13 +0200
Message-Id: <20200504071214.5890-2-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200504071214.5890-1-o.rempel@pengutronix.de>
References: <20200504071214.5890-1-o.rempel@pengutronix.de>
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
 Documentation/networking/ethtool-netlink.rst | 35 ++++----
 drivers/net/phy/phy.c                        |  4 +-
 drivers/net/phy/phy_device.c                 | 94 ++++++++++++++++++++
 include/linux/phy.h                          |  3 +
 include/uapi/linux/ethtool.h                 | 16 +++-
 include/uapi/linux/ethtool_netlink.h         |  2 +
 include/uapi/linux/mii.h                     |  2 +
 net/ethtool/linkmodes.c                      | 45 ++++++++++
 8 files changed, 183 insertions(+), 18 deletions(-)

diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation/networking/ethtool-netlink.rst
index 567326491f80b..8f5cefc539cf1 100644
--- a/Documentation/networking/ethtool-netlink.rst
+++ b/Documentation/networking/ethtool-netlink.rst
@@ -392,14 +392,16 @@ Request contents:
 
 Kernel response contents:
 
-  ====================================  ======  ==========================
-  ``ETHTOOL_A_LINKMODES_HEADER``        nested  reply header
-  ``ETHTOOL_A_LINKMODES_AUTONEG``       u8      autonegotiation status
-  ``ETHTOOL_A_LINKMODES_OURS``          bitset  advertised link modes
-  ``ETHTOOL_A_LINKMODES_PEER``          bitset  partner link modes
-  ``ETHTOOL_A_LINKMODES_SPEED``         u32     link speed (Mb/s)
-  ``ETHTOOL_A_LINKMODES_DUPLEX``        u8      duplex mode
-  ====================================  ======  ==========================
+  ==========================================  ======  ==========================
+  ``ETHTOOL_A_LINKMODES_HEADER``              nested  reply header
+  ``ETHTOOL_A_LINKMODES_AUTONEG``             u8      autonegotiation status
+  ``ETHTOOL_A_LINKMODES_OURS``                bitset  advertised link modes
+  ``ETHTOOL_A_LINKMODES_PEER``                bitset  partner link modes
+  ``ETHTOOL_A_LINKMODES_SPEED``               u32     link speed (Mb/s)
+  ``ETHTOOL_A_LINKMODES_DUPLEX``              u8      duplex mode
+  ``ETHTOOL_A_LINKMODES_MASTER_SLAVE_CFG``    u8      Master/slave port mode
+  ``ETHTOOL_A_LINKMODES_MASTER_SLAVE_STATE``  u8      Master/slave port state
+  ==========================================  ======  ==========================
 
 For ``ETHTOOL_A_LINKMODES_OURS``, value represents advertised modes and mask
 represents supported modes. ``ETHTOOL_A_LINKMODES_PEER`` in the reply is a bit
@@ -414,14 +416,15 @@ LINKMODES_SET
 
 Request contents:
 
-  ====================================  ======  ==========================
-  ``ETHTOOL_A_LINKMODES_HEADER``        nested  request header
-  ``ETHTOOL_A_LINKMODES_AUTONEG``       u8      autonegotiation status
-  ``ETHTOOL_A_LINKMODES_OURS``          bitset  advertised link modes
-  ``ETHTOOL_A_LINKMODES_PEER``          bitset  partner link modes
-  ``ETHTOOL_A_LINKMODES_SPEED``         u32     link speed (Mb/s)
-  ``ETHTOOL_A_LINKMODES_DUPLEX``        u8      duplex mode
-  ====================================  ======  ==========================
+  ==========================================  ======  ==========================
+  ``ETHTOOL_A_LINKMODES_HEADER``              nested  request header
+  ``ETHTOOL_A_LINKMODES_AUTONEG``             u8      autonegotiation status
+  ``ETHTOOL_A_LINKMODES_OURS``                bitset  advertised link modes
+  ``ETHTOOL_A_LINKMODES_PEER``                bitset  partner link modes
+  ``ETHTOOL_A_LINKMODES_SPEED``               u32     link speed (Mb/s)
+  ``ETHTOOL_A_LINKMODES_DUPLEX``              u8      duplex mode
+  ``ETHTOOL_A_LINKMODES_MASTER_SLAVE_CFG``    u8      Master/slave port mode
+  ==========================================  ======  ==========================
 
 ``ETHTOOL_A_LINKMODES_OURS`` bit set allows setting advertised link modes. If
 autonegotiation is on (either set now or kept from before), advertised modes
diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index 72c69a9c8a98a..8c22d02b4218e 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -295,7 +295,7 @@ int phy_ethtool_ksettings_set(struct phy_device *phydev,
 			 phydev->advertising, autoneg == AUTONEG_ENABLE);
 
 	phydev->duplex = duplex;
-
+	phydev->master_slave_set = cmd->base.master_slave_cfg;
 	phydev->mdix_ctrl = cmd->base.eth_tp_mdix_ctrl;
 
 	/* Restart the PHY */
@@ -314,6 +314,8 @@ void phy_ethtool_ksettings_get(struct phy_device *phydev,
 
 	cmd->base.speed = phydev->speed;
 	cmd->base.duplex = phydev->duplex;
+	cmd->base.master_slave_cfg = phydev->master_slave_get;
+	cmd->base.master_slave_state = phydev->master_slave_state;
 	if (phydev->interface == PHY_INTERFACE_MODE_MOCA)
 		cmd->base.port = PORT_BNC;
 	else
diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index ac2784192472f..42dda9d2082ee 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -1768,6 +1768,90 @@ int genphy_setup_forced(struct phy_device *phydev)
 }
 EXPORT_SYMBOL(genphy_setup_forced);
 
+static int genphy_setup_master_slave(struct phy_device *phydev)
+{
+	u16 ctl = 0;
+
+	if (!phydev->is_gigabit_capable)
+		return 0;
+
+	switch (phydev->master_slave_set) {
+	case MASTER_SLAVE_CFG_MASTER_PREFERRED:
+		ctl |= CTL1000_PREFER_MASTER;
+		break;
+	case MASTER_SLAVE_CFG_SLAVE_PREFERRED:
+		break;
+	case MASTER_SLAVE_CFG_MASTER_FORCE:
+		ctl |= CTL1000_AS_MASTER;
+		/* fallthrough */
+	case MASTER_SLAVE_CFG_SLAVE_FORCE:
+		ctl |= CTL1000_ENABLE_MASTER;
+		break;
+	case MASTER_SLAVE_CFG_UNKNOWN:
+	case MASTER_SLAVE_CFG_UNSUPPORTED:
+		return 0;
+	default:
+		phydev_warn(phydev, "Unsupported Master/Slave mode\n");
+		return -EOPNOTSUPP;
+	}
+
+	return phy_modify_changed(phydev, MII_CTRL1000,
+				  (CTL1000_ENABLE_MASTER | CTL1000_AS_MASTER |
+				   CTL1000_PREFER_MASTER), ctl);
+}
+
+static int genphy_read_master_slave(struct phy_device *phydev)
+{
+	int cfg, state;
+	u16 val;
+
+	if (!phydev->is_gigabit_capable) {
+		phydev->master_slave_get = MASTER_SLAVE_CFG_UNSUPPORTED;
+		phydev->master_slave_state = MASTER_SLAVE_STATE_UNSUPPORTED;
+		return 0;
+	}
+
+	phydev->master_slave_get = MASTER_SLAVE_CFG_UNKNOWN;
+	phydev->master_slave_state = MASTER_SLAVE_STATE_UNKNOWN;
+
+	val = phy_read(phydev, MII_CTRL1000);
+	if (val < 0)
+		return val;
+
+	if (val & CTL1000_ENABLE_MASTER) {
+		if (val & CTL1000_AS_MASTER)
+			cfg = MASTER_SLAVE_CFG_MASTER_FORCE;
+		else
+			cfg = MASTER_SLAVE_CFG_SLAVE_FORCE;
+	} else {
+		if (val & CTL1000_PREFER_MASTER)
+			cfg = MASTER_SLAVE_CFG_MASTER_PREFERRED;
+		else
+			cfg = MASTER_SLAVE_CFG_SLAVE_PREFERRED;
+	}
+
+	val = phy_read(phydev, MII_STAT1000);
+	if (val < 0)
+		return val;
+
+	if (val & LPA_1000MSFAIL) {
+		state = MASTER_SLAVE_STATE_ERR;
+	} else if (phydev->link) {
+		/* this bits are valid only for active link */
+		if (val & LPA_1000MSRES)
+			state = MASTER_SLAVE_STATE_MASTER;
+		else
+			state = MASTER_SLAVE_STATE_SLAVE;
+	} else {
+		state = MASTER_SLAVE_STATE_UNKNOWN;
+	}
+
+	phydev->master_slave_get = cfg;
+	phydev->master_slave_state = state;
+
+	return 0;
+}
+
 /**
  * genphy_restart_aneg - Enable and Restart Autonegotiation
  * @phydev: target phy_device struct
@@ -1826,6 +1910,12 @@ int __genphy_config_aneg(struct phy_device *phydev, bool changed)
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
 
@@ -2060,6 +2150,10 @@ int genphy_read_status(struct phy_device *phydev)
 	phydev->pause = 0;
 	phydev->asym_pause = 0;
 
+	err = genphy_read_master_slave(phydev);
+	if (err < 0)
+		return err;
+
 	err = genphy_read_lpa(phydev);
 	if (err < 0)
 		return err;
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 2432ca463ddc0..19cd4fe6efbf1 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -431,6 +431,9 @@ struct phy_device {
 	int duplex;
 	int pause;
 	int asym_pause;
+	u8 master_slave_get;
+	u8 master_slave_set;
+	u8 master_slave_state;
 
 	/* Union of PHY and Attached devices' supported link modes */
 	/* See ethtool.h for more info */
diff --git a/include/uapi/linux/ethtool.h b/include/uapi/linux/ethtool.h
index 92f737f101178..f4662b3a9e1ef 100644
--- a/include/uapi/linux/ethtool.h
+++ b/include/uapi/linux/ethtool.h
@@ -1666,6 +1666,18 @@ static inline int ethtool_validate_duplex(__u8 duplex)
 	return 0;
 }
 
+#define MASTER_SLAVE_CFG_UNSUPPORTED		0
+#define MASTER_SLAVE_CFG_UNKNOWN		1
+#define MASTER_SLAVE_CFG_MASTER_PREFERRED	2
+#define MASTER_SLAVE_CFG_SLAVE_PREFERRED	3
+#define MASTER_SLAVE_CFG_MASTER_FORCE		4
+#define MASTER_SLAVE_CFG_SLAVE_FORCE		5
+#define MASTER_SLAVE_STATE_UNSUPPORTED		0
+#define MASTER_SLAVE_STATE_UNKNOWN		1
+#define MASTER_SLAVE_STATE_MASTER		2
+#define MASTER_SLAVE_STATE_SLAVE		3
+#define MASTER_SLAVE_STATE_ERR			4
+
 /* Which connector port. */
 #define PORT_TP			0x00
 #define PORT_AUI		0x01
@@ -1904,7 +1916,9 @@ struct ethtool_link_settings {
 	__u8	eth_tp_mdix_ctrl;
 	__s8	link_mode_masks_nwords;
 	__u8	transceiver;
-	__u8	reserved1[3];
+	__u8	master_slave_cfg;
+	__u8	master_slave_state;
+	__u8	reserved1[1];
 	__u32	reserved[7];
 	__u32	link_mode_masks[0];
 	/* layout of link_mode_masks fields:
diff --git a/include/uapi/linux/ethtool_netlink.h b/include/uapi/linux/ethtool_netlink.h
index 7fde76366ba46..bf1d310e20bc6 100644
--- a/include/uapi/linux/ethtool_netlink.h
+++ b/include/uapi/linux/ethtool_netlink.h
@@ -216,6 +216,8 @@ enum {
 	ETHTOOL_A_LINKMODES_PEER,		/* bitset */
 	ETHTOOL_A_LINKMODES_SPEED,		/* u32 */
 	ETHTOOL_A_LINKMODES_DUPLEX,		/* u8 */
+	ETHTOOL_A_LINKMODES_MASTER_SLAVE_CFG,	/* u8 */
+	ETHTOOL_A_LINKMODES_MASTER_SLAVE_STATE,	/* u8 */
 
 	/* add new constants above here */
 	__ETHTOOL_A_LINKMODES_CNT,
diff --git a/include/uapi/linux/mii.h b/include/uapi/linux/mii.h
index 90f9b4e1ba277..39f7c44baf535 100644
--- a/include/uapi/linux/mii.h
+++ b/include/uapi/linux/mii.h
@@ -151,11 +151,13 @@
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
index 452608c6d8562..1a6815e5698cf 100644
--- a/net/ethtool/linkmodes.c
+++ b/net/ethtool/linkmodes.c
@@ -27,6 +27,8 @@ linkmodes_get_policy[ETHTOOL_A_LINKMODES_MAX + 1] = {
 	[ETHTOOL_A_LINKMODES_PEER]		= { .type = NLA_REJECT },
 	[ETHTOOL_A_LINKMODES_SPEED]		= { .type = NLA_REJECT },
 	[ETHTOOL_A_LINKMODES_DUPLEX]		= { .type = NLA_REJECT },
+	[ETHTOOL_A_LINKMODES_MASTER_SLAVE_CFG]	= { .type = NLA_REJECT },
+	[ETHTOOL_A_LINKMODES_MASTER_SLAVE_STATE]	= { .type = NLA_REJECT },
 };
 
 static int linkmodes_prepare_data(const struct ethnl_req_info *req_base,
@@ -63,6 +65,7 @@ static int linkmodes_reply_size(const struct ethnl_req_info *req_base,
 {
 	const struct linkmodes_reply_data *data = LINKMODES_REPDATA(reply_base);
 	const struct ethtool_link_ksettings *ksettings = &data->ksettings;
+	const struct ethtool_link_settings *lsettings = &ksettings->base;
 	bool compact = req_base->flags & ETHTOOL_FLAG_COMPACT_BITSETS;
 	int len, ret;
 
@@ -86,6 +89,12 @@ static int linkmodes_reply_size(const struct ethnl_req_info *req_base,
 		len += ret;
 	}
 
+	if (lsettings->master_slave_cfg != MASTER_SLAVE_CFG_UNSUPPORTED)
+		len += nla_total_size(sizeof(u8));
+
+	if (lsettings->master_slave_state != MASTER_SLAVE_STATE_UNSUPPORTED)
+		len += nla_total_size(sizeof(u8));
+
 	return len;
 }
 
@@ -122,6 +131,16 @@ static int linkmodes_fill_reply(struct sk_buff *skb,
 	    nla_put_u8(skb, ETHTOOL_A_LINKMODES_DUPLEX, lsettings->duplex))
 		return -EMSGSIZE;
 
+	if (lsettings->master_slave_cfg != MASTER_SLAVE_CFG_UNSUPPORTED &&
+	    nla_put_u8(skb, ETHTOOL_A_LINKMODES_MASTER_SLAVE_CFG,
+		       lsettings->master_slave_cfg))
+		return -EMSGSIZE;
+
+	if (lsettings->master_slave_state != MASTER_SLAVE_STATE_UNSUPPORTED &&
+	    nla_put_u8(skb, ETHTOOL_A_LINKMODES_MASTER_SLAVE_STATE,
+		       lsettings->master_slave_state))
+		return -EMSGSIZE;
+
 	return 0;
 }
 
@@ -249,6 +268,8 @@ linkmodes_set_policy[ETHTOOL_A_LINKMODES_MAX + 1] = {
 	[ETHTOOL_A_LINKMODES_PEER]		= { .type = NLA_REJECT },
 	[ETHTOOL_A_LINKMODES_SPEED]		= { .type = NLA_U32 },
 	[ETHTOOL_A_LINKMODES_DUPLEX]		= { .type = NLA_U8 },
+	[ETHTOOL_A_LINKMODES_MASTER_SLAVE_CFG]	= { .type = NLA_U8 },
+	[ETHTOOL_A_LINKMODES_MASTER_SLAVE_STATE]	= { .type = NLA_REJECT },
 };
 
 /* Set advertised link modes to all supported modes matching requested speed
@@ -287,14 +308,37 @@ static bool ethnl_auto_linkmodes(struct ethtool_link_ksettings *ksettings,
 			     __ETHTOOL_LINK_MODE_MASK_NBITS);
 }
 
+static int ethnl_validate_master_slave_cfg(u8 cfg)
+{
+	switch (cfg) {
+	case MASTER_SLAVE_CFG_MASTER_PREFERRED:
+	case MASTER_SLAVE_CFG_SLAVE_PREFERRED:
+	case MASTER_SLAVE_CFG_MASTER_FORCE:
+	case MASTER_SLAVE_CFG_SLAVE_FORCE:
+		return 1;
+	}
+
+	return 0;
+}
+
 static int ethnl_update_linkmodes(struct genl_info *info, struct nlattr **tb,
 				  struct ethtool_link_ksettings *ksettings,
 				  bool *mod)
 {
 	struct ethtool_link_settings *lsettings = &ksettings->base;
 	bool req_speed, req_duplex;
+	const struct nlattr *master_slave_cfg;
 	int ret;
 
+	master_slave_cfg = tb[ETHTOOL_A_LINKMODES_MASTER_SLAVE_CFG];
+	if (master_slave_cfg) {
+		u8 cfg = nla_get_u8(master_slave_cfg);
+		if (!ethnl_validate_master_slave_cfg(cfg)) {
+			GENL_SET_ERR_MSG(info, "LINKMODES_MASTER_SLAVE_CFG contains not valid value");
+			return -EOPNOTSUPP;
+		}
+	}
+
 	*mod = false;
 	req_speed = tb[ETHTOOL_A_LINKMODES_SPEED];
 	req_duplex = tb[ETHTOOL_A_LINKMODES_DUPLEX];
@@ -311,6 +355,7 @@ static int ethnl_update_linkmodes(struct genl_info *info, struct nlattr **tb,
 			 mod);
 	ethnl_update_u8(&lsettings->duplex, tb[ETHTOOL_A_LINKMODES_DUPLEX],
 			mod);
+	ethnl_update_u8(&lsettings->master_slave_cfg, master_slave_cfg, mod);
 
 	if (!tb[ETHTOOL_A_LINKMODES_OURS] && lsettings->autoneg &&
 	    (req_speed || req_duplex) &&
-- 
2.26.2

