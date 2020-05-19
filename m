Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12B8F1D9167
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 09:52:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728639AbgESHwT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 03:52:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728621AbgESHwQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 03:52:16 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF210C05BD09
        for <netdev@vger.kernel.org>; Tue, 19 May 2020 00:52:15 -0700 (PDT)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1jax2k-0002vU-Of; Tue, 19 May 2020 09:52:06 +0200
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1jax2f-0006QB-Mn; Tue, 19 May 2020 09:52:01 +0200
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
Subject: [PATCH net-next v1 1/2] ethtool: provide UAPI for PHY Signal Quality Index (SQI)
Date:   Tue, 19 May 2020 09:51:59 +0200
Message-Id: <20200519075200.24631-1-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.26.2
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

Signal Quality Index is a mandatory value required by "OPEN Alliance
SIG" for the 100Base-T1 PHYs [1]. This indicator can be used for cable
integrity diagnostic and investigating other noise sources and
implement by at least two vendors: NXP[2] and TI[3].

[1] http://www.opensig.org/download/document/218/Advanced_PHY_features_for_automotive_Ethernet_V1.0.pdf
[2] https://www.nxp.com/docs/en/data-sheet/TJA1100.pdf
[3] https://www.ti.com/product/DP83TC811R-Q1

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 Documentation/networking/ethtool-netlink.rst |  1 +
 include/linux/phy.h                          |  1 +
 include/uapi/linux/ethtool.h                 | 11 +++++++++
 include/uapi/linux/ethtool_netlink.h         |  1 +
 net/ethtool/common.c                         | 10 ++++++++
 net/ethtool/common.h                         |  1 +
 net/ethtool/linkstate.c                      | 25 +++++++++++++++++++-
 7 files changed, 49 insertions(+), 1 deletion(-)

diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation/networking/ethtool-netlink.rst
index eed46b6aa07df..4485e622182fc 100644
--- a/Documentation/networking/ethtool-netlink.rst
+++ b/Documentation/networking/ethtool-netlink.rst
@@ -457,6 +457,7 @@ Kernel response contents:
   ====================================  ======  ==========================
   ``ETHTOOL_A_LINKSTATE_HEADER``        nested  reply header
   ``ETHTOOL_A_LINKSTATE_LINK``          bool    link state (up/down)
+  ``ETHTOOL_A_LINKSTATE_SQI``           u8      Current Signal Quality Index
   ====================================  ======  ==========================
 
 For most NIC drivers, the value of ``ETHTOOL_A_LINKSTATE_LINK`` returns
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 59344db43fcb1..b2fd230460d77 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -706,6 +706,7 @@ struct phy_driver {
 			    struct ethtool_tunable *tuna,
 			    const void *data);
 	int (*set_loopback)(struct phy_device *dev, bool enable);
+	int (*get_sqi)(struct phy_device *dev);
 };
 #define to_phy_driver(d) container_of(to_mdio_common_driver(d),		\
 				      struct phy_driver, mdiodrv)
diff --git a/include/uapi/linux/ethtool.h b/include/uapi/linux/ethtool.h
index f4662b3a9e1ef..e55caacd1886c 100644
--- a/include/uapi/linux/ethtool.h
+++ b/include/uapi/linux/ethtool.h
@@ -1678,6 +1678,17 @@ static inline int ethtool_validate_duplex(__u8 duplex)
 #define MASTER_SLAVE_STATE_SLAVE		3
 #define MASTER_SLAVE_STATE_ERR			4
 
+#define SQI_STATE_UNSUPPORTED			0
+#define SQI_STATE_0				1
+#define SQI_STATE_1				2
+#define SQI_STATE_2				3
+#define SQI_STATE_3				4
+#define SQI_STATE_4				5
+#define SQI_STATE_5				6
+#define SQI_STATE_6				7
+#define SQI_STATE_7				8
+#define SQI_STATE_8				9
+
 /* Which connector port. */
 #define PORT_TP			0x00
 #define PORT_AUI		0x01
diff --git a/include/uapi/linux/ethtool_netlink.h b/include/uapi/linux/ethtool_netlink.h
index 2881af411f761..1fd80ec0c952f 100644
--- a/include/uapi/linux/ethtool_netlink.h
+++ b/include/uapi/linux/ethtool_netlink.h
@@ -232,6 +232,7 @@ enum {
 	ETHTOOL_A_LINKSTATE_UNSPEC,
 	ETHTOOL_A_LINKSTATE_HEADER,		/* nest - _A_HEADER_* */
 	ETHTOOL_A_LINKSTATE_LINK,		/* u8 */
+	ETHTOOL_A_LINKSTATE_SQI,		/* u8 */
 
 	/* add new constants above here */
 	__ETHTOOL_A_LINKSTATE_CNT,
diff --git a/net/ethtool/common.c b/net/ethtool/common.c
index 423e640e3876d..f3c905e59124f 100644
--- a/net/ethtool/common.c
+++ b/net/ethtool/common.c
@@ -310,6 +310,16 @@ int __ethtool_get_link(struct net_device *dev)
 	return netif_running(dev) && dev->ethtool_ops->get_link(dev);
 }
 
+int __ethtool_get_sqi(struct net_device *dev)
+{
+	struct phy_device *phydev = dev->phydev;
+
+	if (!phydev->drv->get_sqi)
+		return -EOPNOTSUPP;
+
+	return phydev->drv->get_sqi(phydev);
+}
+
 int ethtool_get_max_rxfh_channel(struct net_device *dev, u32 *max)
 {
 	u32 dev_size, current_max = 0;
diff --git a/net/ethtool/common.h b/net/ethtool/common.h
index a62f68ccc43ab..a251040d967db 100644
--- a/net/ethtool/common.h
+++ b/net/ethtool/common.h
@@ -30,6 +30,7 @@ extern const char ts_tx_type_names[][ETH_GSTRING_LEN];
 extern const char ts_rx_filter_names[][ETH_GSTRING_LEN];
 
 int __ethtool_get_link(struct net_device *dev);
+int __ethtool_get_sqi(struct net_device *dev);
 
 bool convert_legacy_settings_to_link_ksettings(
 	struct ethtool_link_ksettings *link_ksettings,
diff --git a/net/ethtool/linkstate.c b/net/ethtool/linkstate.c
index 2740cde0a182b..5013ee275176d 100644
--- a/net/ethtool/linkstate.c
+++ b/net/ethtool/linkstate.c
@@ -10,6 +10,7 @@ struct linkstate_req_info {
 struct linkstate_reply_data {
 	struct ethnl_reply_data		base;
 	int				link;
+	u8				sqi;
 };
 
 #define LINKSTATE_REPDATA(__reply_base) \
@@ -20,6 +21,7 @@ linkstate_get_policy[ETHTOOL_A_LINKSTATE_MAX + 1] = {
 	[ETHTOOL_A_LINKSTATE_UNSPEC]		= { .type = NLA_REJECT },
 	[ETHTOOL_A_LINKSTATE_HEADER]		= { .type = NLA_NESTED },
 	[ETHTOOL_A_LINKSTATE_LINK]		= { .type = NLA_REJECT },
+	[ETHTOOL_A_LINKSTATE_SQI]		= { .type = NLA_REJECT },
 };
 
 static int linkstate_prepare_data(const struct ethnl_req_info *req_base,
@@ -34,6 +36,15 @@ static int linkstate_prepare_data(const struct ethnl_req_info *req_base,
 	if (ret < 0)
 		return ret;
 	data->link = __ethtool_get_link(dev);
+
+	ret = __ethtool_get_sqi(dev);
+	if (ret == -EOPNOTSUPP)
+		ret = SQI_STATE_UNSUPPORTED;
+	if (ret < 0)
+		return ret;
+
+	data->sqi = ret;
+
 	ethnl_ops_complete(dev);
 
 	return 0;
@@ -42,8 +53,16 @@ static int linkstate_prepare_data(const struct ethnl_req_info *req_base,
 static int linkstate_reply_size(const struct ethnl_req_info *req_base,
 				const struct ethnl_reply_data *reply_base)
 {
-	return nla_total_size(sizeof(u8)) /* LINKSTATE_LINK */
+	struct linkstate_reply_data *data = LINKSTATE_REPDATA(reply_base);
+	int len;
+
+	len = nla_total_size(sizeof(u8)) /* LINKSTATE_LINK */
 		+ 0;
+
+	if (data->sqi != SQI_STATE_UNSUPPORTED)
+		len += nla_total_size(sizeof(u8));
+
+	return len;
 }
 
 static int linkstate_fill_reply(struct sk_buff *skb,
@@ -56,6 +75,10 @@ static int linkstate_fill_reply(struct sk_buff *skb,
 	    nla_put_u8(skb, ETHTOOL_A_LINKSTATE_LINK, !!data->link))
 		return -EMSGSIZE;
 
+	if (data->sqi != SQI_STATE_UNSUPPORTED &&
+	    nla_put_u8(skb, ETHTOOL_A_LINKSTATE_SQI, data->sqi))
+		return -EMSGSIZE;
+
 	return 0;
 }
 
-- 
2.26.2

