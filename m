Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 894AA54303A
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 14:24:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239146AbiFHMXp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 08:23:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239138AbiFHMXn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 08:23:43 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1650F1CA5F6
        for <netdev@vger.kernel.org>; Wed,  8 Jun 2022 05:23:41 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1nyuid-0005zU-Sp; Wed, 08 Jun 2022 14:23:27 +0200
Received: from [2a0a:edc0:0:1101:1d::ac] (helo=dude04.red.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1nyuid-007BL7-PF; Wed, 08 Jun 2022 14:23:26 +0200
Received: from ore by dude04.red.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1nyuib-003F69-FR; Wed, 08 Jun 2022 14:23:25 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Michal Kubecek <mkubecek@suse.cz>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next v2 2/2] net: phy: add remote fault support
Date:   Wed,  8 Jun 2022 14:23:22 +0200
Message-Id: <20220608122322.772950-3-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220608122322.772950-1-o.rempel@pengutronix.de>
References: <20220608122322.772950-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch implements PHY remote fault support for C45 BaseT1 compatible
PHYs. It has been tested on TI DP83TD510 T1L PHYs.

Remote fault is defined by IEEE 802.3-2018 and provides the possibility
to notify the link partner about different kinds of issues. Here is the
list of error codes which can be potentially transfered as autoneg next
page message:

/* IEEE 802.3-2018 28.2.1.2.4 Fault without additional information */
/* IEEE 802.3-2018 28C.5 Message code 4: 0 - RF Test */
/* IEEE 802.3-2018 28C.5 Message code 4: 1 - Link Loss */
/* IEEE 802.3-2018 28C.5 Message code 4: 2 - Jabber */
/* IEEE 802.3-2018 28C.5 Message code 4: 3 - Parallel Detection Fault */
/* IEEE 802.3-2018 37.2.1.5.2 Offline */
/* IEEE 802.3-2018 37.2.1.5.3 Link_Failure */
/* IEEE 802.3-2018 37.2.1.5.4 Auto-Negotiation_Error */

The code added by this patch does not provide any handlers (no effect on
PHY state machine nor netif_carrier) and only allows to read and send
the remote fault (currently without next page extensions). But even now,
in this state, it can be used to see if the link partner is reporting
some remote fault state, or we can use it to test the functionality of
the link partner.

This example illustrates the ethtool interface, here eth1 and eth2 are
connected via a T1L link:

$ ethtool eth1 | grep remote
    remote fault cfg: ok
    remote fault status: ok
$ ethtool eth2 | grep remote
    remote fault cfg: ok
    remote fault status: ok

$ ethtool -s eth1 remote-fault error
$ ethtool eth1 | grep remote
        remote fault cfg: error
        remote fault status: ok
$ ethtool eth2 | grep remote
        remote fault cfg: ok
        remote fault status: error

$ ethtool -s eth1 remote-fault ok
$ ethtool eth1 | grep remote
        remote fault cfg: ok
        remote fault status: ok
$ ethtool eth2 | grep remote
        remote fault cfg: ok
        remote fault status: error
$ ethtool -s eth2 remote-fault-state clr
$ ethtool eth2 | grep remote
        remote fault cfg: ok
        remote fault status: ok

My personal idea is to use this functionality for the cooperative link
diagnostic. For example, set remote fault with vendor specific next page
extension (as described in IEEE 802.3-2018 28C.6 Message code 5) to ask
link partner to stop transmitting for some amount of time or to enable
remote loopback.

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 Documentation/networking/ethtool-netlink.rst |  2 +
 drivers/net/phy/phy-c45.c                    | 26 +++++-
 drivers/net/phy/phy.c                        |  4 +
 include/linux/phy.h                          |  5 ++
 include/uapi/linux/ethtool.h                 | 46 +++++++++-
 include/uapi/linux/ethtool_netlink.h         |  2 +
 net/ethtool/ioctl.c                          |  6 ++
 net/ethtool/linkmodes.c                      | 88 +++++++++++++++++++-
 net/ethtool/netlink.h                        |  2 +-
 9 files changed, 173 insertions(+), 8 deletions(-)

diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation/networking/ethtool-netlink.rst
index dbca3e9ec782..0747602ac3a7 100644
--- a/Documentation/networking/ethtool-netlink.rst
+++ b/Documentation/networking/ethtool-netlink.rst
@@ -426,6 +426,8 @@ Kernel response contents:
   ``ETHTOOL_A_LINKMODES_DUPLEX``              u8      duplex mode
   ``ETHTOOL_A_LINKMODES_MASTER_SLAVE_CFG``    u8      Master/slave port mode
   ``ETHTOOL_A_LINKMODES_MASTER_SLAVE_STATE``  u8      Master/slave port state
+  ``ETHTOOL_A_LINKMODES_REMOTE_FAULT_CFG``    u8      Remote fault port mode
+  ``ETHTOOL_A_LINKMODES_REMOTE_FAULT_STATE``  u8      Remote fault port state
   ==========================================  ======  ==========================
 
 For ``ETHTOOL_A_LINKMODES_OURS``, value represents advertised modes and mask
diff --git a/drivers/net/phy/phy-c45.c b/drivers/net/phy/phy-c45.c
index c67bf3060173..6c55c7f9b680 100644
--- a/drivers/net/phy/phy-c45.c
+++ b/drivers/net/phy/phy-c45.c
@@ -205,7 +205,7 @@ static int genphy_c45_baset1_an_config_aneg(struct phy_device *phydev)
 		break;
 	case MASTER_SLAVE_CFG_UNKNOWN:
 	case MASTER_SLAVE_CFG_UNSUPPORTED:
-		return 0;
+		break;
 	default:
 		phydev_warn(phydev, "Unsupported Master/Slave mode\n");
 		return -EOPNOTSUPP;
@@ -223,11 +223,16 @@ static int genphy_c45_baset1_an_config_aneg(struct phy_device *phydev)
 		break;
 	}
 
+	if (phydev->remote_fault_set >= REMOTE_FAULT_CFG_ERROR)
+		adv_l |= MDIO_AN_T1_ADV_L_REMOTE_FAULT;
+
 	adv_l |= linkmode_adv_to_mii_t1_adv_l_t(phydev->advertising);
 
 	ret = phy_modify_mmd_changed(phydev, MDIO_MMD_AN, MDIO_AN_T1_ADV_L,
-				     (MDIO_AN_T1_ADV_L_FORCE_MS | MDIO_AN_T1_ADV_L_PAUSE_CAP
-				     | MDIO_AN_T1_ADV_L_PAUSE_ASYM), adv_l);
+				     (MDIO_AN_T1_ADV_L_FORCE_MS |
+				      MDIO_AN_T1_ADV_L_PAUSE_CAP |
+				      MDIO_AN_T1_ADV_L_PAUSE_ASYM |
+				      MDIO_AN_T1_ADV_L_REMOTE_FAULT), adv_l);
 	if (ret < 0)
 		return ret;
 	if (ret > 0)
@@ -389,6 +394,15 @@ int genphy_c45_aneg_done(struct phy_device *phydev)
 
 	val = phy_read_mmd(phydev, MDIO_MMD_AN, reg);
 
+	if (val & MDIO_AN_STAT1_RFAULT) {
+		phydev->remote_fault_state = REMOTE_FAULT_STATE_ERROR;
+	} else if (phydev->remote_fault_state <= REMOTE_FAULT_STATE_UNKNOWN) {
+		/* keep error state until it is cleared by kernel or users space
+		 * handler
+		 */
+		phydev->remote_fault_state = REMOTE_FAULT_STATE_NO_ERROR;
+	}
+
 	return val < 0 ? val : val & MDIO_AN_STAT1_COMPLETE ? 1 : 0;
 }
 EXPORT_SYMBOL_GPL(genphy_c45_aneg_done);
@@ -792,6 +806,7 @@ int genphy_c45_baset1_read_status(struct phy_device *phydev)
 
 	phydev->master_slave_get = MASTER_SLAVE_CFG_UNKNOWN;
 	phydev->master_slave_state = MASTER_SLAVE_STATE_UNKNOWN;
+	phydev->remote_fault_get = REMOTE_FAULT_CFG_UNKNOWN;
 
 	ret = phy_read_mmd(phydev, MDIO_MMD_AN, MDIO_AN_T1_ADV_L);
 	if (ret < 0)
@@ -813,6 +828,11 @@ int genphy_c45_baset1_read_status(struct phy_device *phydev)
 			phydev->master_slave_get = MASTER_SLAVE_CFG_SLAVE_PREFERRED;
 	}
 
+	if (ret & MDIO_AN_T1_ADV_L_REMOTE_FAULT)
+		phydev->remote_fault_get = REMOTE_FAULT_CFG_ERROR;
+	else
+		phydev->remote_fault_get = REMOTE_FAULT_CFG_NO_ERROR;
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(genphy_c45_baset1_read_status);
diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index ef62f357b76d..5751ef831b2e 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -255,6 +255,8 @@ void phy_ethtool_ksettings_get(struct phy_device *phydev,
 	cmd->base.duplex = phydev->duplex;
 	cmd->base.master_slave_cfg = phydev->master_slave_get;
 	cmd->base.master_slave_state = phydev->master_slave_state;
+	cmd->base.remote_fault_cfg = phydev->remote_fault_get;
+	cmd->base.remote_fault_state = phydev->remote_fault_state;
 	if (phydev->interface == PHY_INTERFACE_MODE_MOCA)
 		cmd->base.port = PORT_BNC;
 	else
@@ -816,6 +818,8 @@ int phy_ethtool_ksettings_set(struct phy_device *phydev,
 			 phydev->advertising, autoneg == AUTONEG_ENABLE);
 
 	phydev->master_slave_set = cmd->base.master_slave_cfg;
+	phydev->remote_fault_set = cmd->base.remote_fault_cfg;
+	phydev->remote_fault_state = cmd->base.remote_fault_state;
 	phydev->mdix_ctrl = cmd->base.eth_tp_mdix_ctrl;
 
 	/* Restart the PHY */
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 508f1149665b..94a95e60cb45 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -564,6 +564,7 @@ struct macsec_ops;
  * @advertising: Currently advertised linkmodes
  * @adv_old: Saved advertised while power saving for WoL
  * @lp_advertising: Current link partner advertised linkmodes
+ * @lp_remote_fault: Current link partner advertised remote fault
  * @eee_broken_modes: Energy efficient ethernet modes which should be prohibited
  * @autoneg: Flag autoneg being used
  * @link: Current link state
@@ -646,6 +647,10 @@ struct phy_device {
 	u8 master_slave_set;
 	u8 master_slave_state;
 
+	u8 remote_fault_set;
+	u8 remote_fault_get;
+	u8 remote_fault_state;
+
 	/* Union of PHY and Attached devices' supported link modes */
 	/* See ethtool.h for more info */
 	__ETHTOOL_DECLARE_LINK_MODE_MASK(supported);
diff --git a/include/uapi/linux/ethtool.h b/include/uapi/linux/ethtool.h
index e0f0ee9bc89e..7d04e9e5ea1a 100644
--- a/include/uapi/linux/ethtool.h
+++ b/include/uapi/linux/ethtool.h
@@ -1840,6 +1840,46 @@ static inline int ethtool_validate_duplex(__u8 duplex)
 #define MASTER_SLAVE_STATE_SLAVE		3
 #define MASTER_SLAVE_STATE_ERR			4
 
+#define REMOTE_FAULT_CFG_UNSUPPORTED		0
+#define REMOTE_FAULT_CFG_UNKNOWN		1
+#define REMOTE_FAULT_CFG_NO_ERROR		2
+/* IEEE 802.3-2018 28.2.1.2.4 Fault without additional information */
+#define REMOTE_FAULT_CFG_ERROR			3
+/* IEEE 802.3-2018 28C.5 Message code 4: 0 - RF Test */
+#define REMOTE_FAULT_CFG_TEST			4
+/* IEEE 802.3-2018 28C.5 Message code 4: 1 - Link Loss */
+#define REMOTE_FAULT_CFG_LINK_LOSS		5
+/* IEEE 802.3-2018 28C.5 Message code 4: 2 - Jabber */
+#define REMOTE_FAULT_CFG_JABBER			6
+/* IEEE 802.3-2018 28C.5 Message code 4: 3 - Parallel Detection Fault */
+#define REMOTE_FAULT_CFG_PDF			7
+/* IEEE 802.3-2018 37.2.1.5.2 Offline */
+#define REMOTE_FAULT_CFG_OFFLINE		8
+/* IEEE 802.3-2018 37.2.1.5.3 Link_Failure */
+#define REMOTE_FAULT_CFG_LINK_FAIL		9
+/* IEEE 802.3-2018 37.2.1.5.4 Auto-Negotiation_Error */
+#define REMOTE_FAULT_CFG_AN_ERROR		10
+
+#define REMOTE_FAULT_STATE_UNSUPPORTED		0
+#define REMOTE_FAULT_STATE_UNKNOWN		1
+#define REMOTE_FAULT_STATE_NO_ERROR		2
+/* IEEE 802.3-2018 28.2.1.2.4 Fault without additional information */
+#define REMOTE_FAULT_STATE_ERROR		3
+/* IEEE 802.3-2018 28C.5 Message code 4: 0 - RF Test */
+#define REMOTE_FAULT_STATE_TEST			4
+/* IEEE 802.3-2018 28C.5 Message code 4: 1 - Link Loss */
+#define REMOTE_FAULT_STATE_LINK_LOSS		5
+/* IEEE 802.3-2018 28C.5 Message code 4: 2 - Jabber */
+#define REMOTE_FAULT_STATE_JABBER		6
+/* IEEE 802.3-2018 28C.5 Message code 4: 3 - Parallel Detection Fault */
+#define REMOTE_FAULT_STATE_PDF			7
+/* IEEE 802.3-2018 37.2.1.5.2 Offline */
+#define REMOTE_FAULT_STATE_OFFLINE		8
+/* IEEE 802.3-2018 37.2.1.5.3 Link_Failure */
+#define REMOTE_FAULT_STATE_LINK_FAIL		9
+/* IEEE 802.3-2018 37.2.1.5.4 Auto-Negotiation_Error */
+#define REMOTE_FAULT_STATE_AN_ERROR		10
+
 /* Which connector port. */
 #define PORT_TP			0x00
 #define PORT_AUI		0x01
@@ -2085,8 +2125,10 @@ struct ethtool_link_settings {
 	__u8	transceiver;
 	__u8	master_slave_cfg;
 	__u8	master_slave_state;
-	__u8	reserved1[1];
-	__u32	reserved[7];
+	__u8	remote_fault_cfg;
+	__u8	remote_fault_state;
+	__u8	reserved1[3];
+	__u32	reserved[6];
 	__u32	link_mode_masks[0];
 	/* layout of link_mode_masks fields:
 	 * __u32 map_supported[link_mode_masks_nwords];
diff --git a/include/uapi/linux/ethtool_netlink.h b/include/uapi/linux/ethtool_netlink.h
index d2fb4f7be61b..35563d8f5776 100644
--- a/include/uapi/linux/ethtool_netlink.h
+++ b/include/uapi/linux/ethtool_netlink.h
@@ -242,6 +242,8 @@ enum {
 	ETHTOOL_A_LINKMODES_MASTER_SLAVE_CFG,	/* u8 */
 	ETHTOOL_A_LINKMODES_MASTER_SLAVE_STATE,	/* u8 */
 	ETHTOOL_A_LINKMODES_LANES,		/* u32 */
+	ETHTOOL_A_LINKMODES_REMOTE_FAULT_CFG,	/* u8 */
+	ETHTOOL_A_LINKMODES_REMOTE_FAULT_STATE,	/* u8 */
 
 	/* add new constants above here */
 	__ETHTOOL_A_LINKMODES_CNT,
diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index 326e14ee05db..64aaa73f50a2 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -584,6 +584,8 @@ static int ethtool_get_link_ksettings(struct net_device *dev,
 		= __ETHTOOL_LINK_MODE_MASK_NU32;
 	link_ksettings.base.master_slave_cfg = MASTER_SLAVE_CFG_UNSUPPORTED;
 	link_ksettings.base.master_slave_state = MASTER_SLAVE_STATE_UNSUPPORTED;
+	link_ksettings.base.remote_fault_cfg = REMOTE_FAULT_CFG_UNSUPPORTED;
+	link_ksettings.base.remote_fault_state = REMOTE_FAULT_STATE_UNSUPPORTED;
 
 	return store_link_ksettings_for_user(useraddr, &link_ksettings);
 }
@@ -625,6 +627,10 @@ static int ethtool_set_link_ksettings(struct net_device *dev,
 	    link_ksettings.base.master_slave_state)
 		return -EINVAL;
 
+	if (link_ksettings.base.remote_fault_cfg ||
+	    link_ksettings.base.remote_fault_state)
+		return -EINVAL;
+
 	err = dev->ethtool_ops->set_link_ksettings(dev, &link_ksettings);
 	if (err >= 0) {
 		ethtool_notify(dev, ETHTOOL_MSG_LINKINFO_NTF, NULL);
diff --git a/net/ethtool/linkmodes.c b/net/ethtool/linkmodes.c
index 99b29b4fe947..dc4fdaf414c8 100644
--- a/net/ethtool/linkmodes.c
+++ b/net/ethtool/linkmodes.c
@@ -93,6 +93,12 @@ static int linkmodes_reply_size(const struct ethnl_req_info *req_base,
 	if (lsettings->master_slave_state != MASTER_SLAVE_STATE_UNSUPPORTED)
 		len += nla_total_size(sizeof(u8));
 
+	if (lsettings->remote_fault_cfg != REMOTE_FAULT_CFG_UNSUPPORTED)
+		len += nla_total_size(sizeof(u8));
+
+	if (lsettings->remote_fault_state != REMOTE_FAULT_STATE_UNSUPPORTED)
+		len += nla_total_size(sizeof(u8));
+
 	return len;
 }
 
@@ -143,6 +149,16 @@ static int linkmodes_fill_reply(struct sk_buff *skb,
 		       lsettings->master_slave_state))
 		return -EMSGSIZE;
 
+	if (lsettings->remote_fault_cfg != REMOTE_FAULT_CFG_UNSUPPORTED &&
+	    nla_put_u8(skb, ETHTOOL_A_LINKMODES_REMOTE_FAULT_CFG,
+		       lsettings->remote_fault_cfg))
+		return -EMSGSIZE;
+
+	if (lsettings->remote_fault_state != REMOTE_FAULT_STATE_UNSUPPORTED &&
+	    nla_put_u8(skb, ETHTOOL_A_LINKMODES_REMOTE_FAULT_STATE,
+		       lsettings->remote_fault_state))
+		return -EMSGSIZE;
+
 	return 0;
 }
 
@@ -169,6 +185,8 @@ const struct nla_policy ethnl_linkmodes_set_policy[] = {
 	[ETHTOOL_A_LINKMODES_DUPLEX]		= { .type = NLA_U8 },
 	[ETHTOOL_A_LINKMODES_MASTER_SLAVE_CFG]	= { .type = NLA_U8 },
 	[ETHTOOL_A_LINKMODES_LANES]		= NLA_POLICY_RANGE(NLA_U32, 1, 8),
+	[ETHTOOL_A_LINKMODES_REMOTE_FAULT_CFG]	= { .type = NLA_U8 },
+	[ETHTOOL_A_LINKMODES_REMOTE_FAULT_STATE] = { .type = NLA_U8 },
 };
 
 /* Set advertised link modes to all supported modes matching requested speed,
@@ -218,9 +236,38 @@ static bool ethnl_validate_master_slave_cfg(u8 cfg)
 	return false;
 }
 
+static bool ethnl_validate_remote_fault_cfg(u8 cfg)
+{
+	switch (cfg) {
+	case REMOTE_FAULT_CFG_NO_ERROR:
+	case REMOTE_FAULT_CFG_ERROR:
+	case REMOTE_FAULT_CFG_TEST:
+	case REMOTE_FAULT_CFG_LINK_LOSS:
+	case REMOTE_FAULT_CFG_JABBER:
+	case REMOTE_FAULT_CFG_PDF:
+	case REMOTE_FAULT_CFG_OFFLINE:
+	case REMOTE_FAULT_CFG_LINK_FAIL:
+	case REMOTE_FAULT_CFG_AN_ERROR:
+		return true;
+	}
+
+	return false;
+}
+
+static bool ethnl_validate_remote_fault_state(u8 cfg)
+{
+	switch (cfg) {
+	case REMOTE_FAULT_STATE_UNKNOWN:
+		return true;
+	}
+
+	return false;
+}
+
 static int ethnl_check_linkmodes(struct genl_info *info, struct nlattr **tb)
 {
-	const struct nlattr *master_slave_cfg, *lanes_cfg;
+	const struct nlattr *master_slave_cfg, *lanes_cfg, *remote_fault_cfg,
+	      *remote_fault_state;
 
 	master_slave_cfg = tb[ETHTOOL_A_LINKMODES_MASTER_SLAVE_CFG];
 	if (master_slave_cfg &&
@@ -230,6 +277,22 @@ static int ethnl_check_linkmodes(struct genl_info *info, struct nlattr **tb)
 		return -EOPNOTSUPP;
 	}
 
+	remote_fault_cfg = tb[ETHTOOL_A_LINKMODES_REMOTE_FAULT_CFG];
+	if (remote_fault_cfg &&
+	    !ethnl_validate_remote_fault_cfg(nla_get_u8(remote_fault_cfg))) {
+		NL_SET_ERR_MSG_ATTR(info->extack, remote_fault_cfg,
+				    "remote-fault-cfg value is invalid");
+		return -EOPNOTSUPP;
+	}
+
+	remote_fault_state = tb[ETHTOOL_A_LINKMODES_REMOTE_FAULT_STATE];
+	if (remote_fault_state &&
+	    !ethnl_validate_remote_fault_state(nla_get_u8(remote_fault_state))) {
+		NL_SET_ERR_MSG_ATTR(info->extack, remote_fault_state,
+				    "remote-fault-state value is invalid");
+		return -EOPNOTSUPP;
+	}
+
 	lanes_cfg = tb[ETHTOOL_A_LINKMODES_LANES];
 	if (lanes_cfg && !is_power_of_2(nla_get_u32(lanes_cfg))) {
 		NL_SET_ERR_MSG_ATTR(info->extack, lanes_cfg,
@@ -246,7 +309,8 @@ static int ethnl_update_linkmodes(struct genl_info *info, struct nlattr **tb,
 {
 	struct ethtool_link_settings *lsettings = &ksettings->base;
 	bool req_speed, req_lanes, req_duplex;
-	const struct nlattr *master_slave_cfg, *lanes_cfg;
+	const struct nlattr *master_slave_cfg, *lanes_cfg, *remote_fault_cfg,
+	      *remote_fault_state;
 	int ret;
 
 	master_slave_cfg = tb[ETHTOOL_A_LINKMODES_MASTER_SLAVE_CFG];
@@ -258,6 +322,24 @@ static int ethnl_update_linkmodes(struct genl_info *info, struct nlattr **tb,
 		}
 	}
 
+	remote_fault_cfg = tb[ETHTOOL_A_LINKMODES_REMOTE_FAULT_CFG];
+	if (remote_fault_cfg) {
+		if (lsettings->remote_fault_cfg == REMOTE_FAULT_CFG_UNSUPPORTED) {
+			NL_SET_ERR_MSG_ATTR(info->extack, remote_fault_cfg,
+					    "Remote fault notification is not supported by device");
+			return -EOPNOTSUPP;
+		}
+	}
+
+	remote_fault_state = tb[ETHTOOL_A_LINKMODES_REMOTE_FAULT_STATE];
+	if (remote_fault_state) {
+		if (lsettings->remote_fault_state == REMOTE_FAULT_STATE_UNSUPPORTED) {
+			NL_SET_ERR_MSG_ATTR(info->extack, remote_fault_state,
+					    "Remote fault notification is not supported by device");
+			return -EOPNOTSUPP;
+		}
+	}
+
 	*mod = false;
 	req_speed = tb[ETHTOOL_A_LINKMODES_SPEED];
 	req_lanes = tb[ETHTOOL_A_LINKMODES_LANES];
@@ -296,6 +378,8 @@ static int ethnl_update_linkmodes(struct genl_info *info, struct nlattr **tb,
 	ethnl_update_u8(&lsettings->duplex, tb[ETHTOOL_A_LINKMODES_DUPLEX],
 			mod);
 	ethnl_update_u8(&lsettings->master_slave_cfg, master_slave_cfg, mod);
+	ethnl_update_u8(&lsettings->remote_fault_cfg, remote_fault_cfg, mod);
+	ethnl_update_u8(&lsettings->remote_fault_state, remote_fault_state, mod);
 
 	if (!tb[ETHTOOL_A_LINKMODES_OURS] && lsettings->autoneg &&
 	    (req_speed || req_lanes || req_duplex) &&
diff --git a/net/ethtool/netlink.h b/net/ethtool/netlink.h
index 7919ddb2371c..a6d4187d82e2 100644
--- a/net/ethtool/netlink.h
+++ b/net/ethtool/netlink.h
@@ -352,7 +352,7 @@ extern const struct nla_policy ethnl_strset_get_policy[ETHTOOL_A_STRSET_COUNTS_O
 extern const struct nla_policy ethnl_linkinfo_get_policy[ETHTOOL_A_LINKINFO_HEADER + 1];
 extern const struct nla_policy ethnl_linkinfo_set_policy[ETHTOOL_A_LINKINFO_TP_MDIX_CTRL + 1];
 extern const struct nla_policy ethnl_linkmodes_get_policy[ETHTOOL_A_LINKMODES_HEADER + 1];
-extern const struct nla_policy ethnl_linkmodes_set_policy[ETHTOOL_A_LINKMODES_LANES + 1];
+extern const struct nla_policy ethnl_linkmodes_set_policy[ETHTOOL_A_LINKMODES_REMOTE_FAULT_STATE + 1];
 extern const struct nla_policy ethnl_linkstate_get_policy[ETHTOOL_A_LINKSTATE_HEADER + 1];
 extern const struct nla_policy ethnl_debug_get_policy[ETHTOOL_A_DEBUG_HEADER + 1];
 extern const struct nla_policy ethnl_debug_set_policy[ETHTOOL_A_DEBUG_MSGMASK + 1];
-- 
2.30.2

