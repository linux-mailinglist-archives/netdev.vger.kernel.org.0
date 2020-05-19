Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 734811D9761
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 15:15:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729037AbgESNOv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 09:14:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729022AbgESNOu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 09:14:50 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBCA3C08C5C0
        for <netdev@vger.kernel.org>; Tue, 19 May 2020 06:14:49 -0700 (PDT)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1jb24v-0007Jx-Kj; Tue, 19 May 2020 15:14:41 +0200
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1jb24p-00017A-U6; Tue, 19 May 2020 15:14:35 +0200
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
Subject: [PATCH net-next v2 1/2] ethtool: provide UAPI for PHY Signal Quality Index (SQI)
Date:   Tue, 19 May 2020 15:14:32 +0200
Message-Id: <20200519131433.4224-2-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200519131433.4224-1-o.rempel@pengutronix.de>
References: <20200519131433.4224-1-o.rempel@pengutronix.de>
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
 Documentation/networking/ethtool-netlink.rst |  6 ++--
 include/linux/phy.h                          |  2 ++
 include/uapi/linux/ethtool_netlink.h         |  2 ++
 net/ethtool/common.c                         | 20 +++++++++++
 net/ethtool/common.h                         |  2 ++
 net/ethtool/linkstate.c                      | 38 +++++++++++++++++++-
 6 files changed, 67 insertions(+), 3 deletions(-)

diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation/networking/ethtool-netlink.rst
index eed46b6aa07df..7e651ea33eabb 100644
--- a/Documentation/networking/ethtool-netlink.rst
+++ b/Documentation/networking/ethtool-netlink.rst
@@ -454,10 +454,12 @@ Request contents:
 
 Kernel response contents:
 
-  ====================================  ======  ==========================
+  ====================================  ======  ============================
   ``ETHTOOL_A_LINKSTATE_HEADER``        nested  reply header
   ``ETHTOOL_A_LINKSTATE_LINK``          bool    link state (up/down)
-  ====================================  ======  ==========================
+  ``ETHTOOL_A_LINKSTATE_SQI``           u32     Current Signal Quality Index
+  ``ETHTOOL_A_LINKSTATE_SQI_MAX``       u32     Max support SQI value
+  ====================================  ======  ============================
 
 For most NIC drivers, the value of ``ETHTOOL_A_LINKSTATE_LINK`` returns
 carrier flag provided by ``netif_carrier_ok()`` but there are drivers which
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 59344db43fcb1..950ba479754bd 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -706,6 +706,8 @@ struct phy_driver {
 			    struct ethtool_tunable *tuna,
 			    const void *data);
 	int (*set_loopback)(struct phy_device *dev, bool enable);
+	int (*get_sqi)(struct phy_device *dev);
+	int (*get_sqi_max)(struct phy_device *dev);
 };
 #define to_phy_driver(d) container_of(to_mdio_common_driver(d),		\
 				      struct phy_driver, mdiodrv)
diff --git a/include/uapi/linux/ethtool_netlink.h b/include/uapi/linux/ethtool_netlink.h
index 2881af411f761..e6f109b76c9aa 100644
--- a/include/uapi/linux/ethtool_netlink.h
+++ b/include/uapi/linux/ethtool_netlink.h
@@ -232,6 +232,8 @@ enum {
 	ETHTOOL_A_LINKSTATE_UNSPEC,
 	ETHTOOL_A_LINKSTATE_HEADER,		/* nest - _A_HEADER_* */
 	ETHTOOL_A_LINKSTATE_LINK,		/* u8 */
+	ETHTOOL_A_LINKSTATE_SQI,		/* u32 */
+	ETHTOOL_A_LINKSTATE_SQI_MAX,		/* u32 */
 
 	/* add new constants above here */
 	__ETHTOOL_A_LINKSTATE_CNT,
diff --git a/net/ethtool/common.c b/net/ethtool/common.c
index 423e640e3876d..f7572723a07b7 100644
--- a/net/ethtool/common.c
+++ b/net/ethtool/common.c
@@ -310,6 +310,26 @@ int __ethtool_get_link(struct net_device *dev)
 	return netif_running(dev) && dev->ethtool_ops->get_link(dev);
 }
 
+int __ethtool_get_sqi(struct net_device *dev)
+{
+	struct phy_device *phydev = dev->phydev;
+
+	if (!phydev || !phydev->drv->get_sqi)
+		return -EOPNOTSUPP;
+
+	return phydev->drv->get_sqi(phydev);
+}
+
+int __ethtool_get_sqi_max(struct net_device *dev)
+{
+	struct phy_device *phydev = dev->phydev;
+
+	if (!phydev || !phydev->drv->get_sqi_max)
+		return -EOPNOTSUPP;
+
+	return phydev->drv->get_sqi_max(phydev);
+}
+
 int ethtool_get_max_rxfh_channel(struct net_device *dev, u32 *max)
 {
 	u32 dev_size, current_max = 0;
diff --git a/net/ethtool/common.h b/net/ethtool/common.h
index a62f68ccc43ab..24c8d7f10d1d4 100644
--- a/net/ethtool/common.h
+++ b/net/ethtool/common.h
@@ -30,6 +30,8 @@ extern const char ts_tx_type_names[][ETH_GSTRING_LEN];
 extern const char ts_rx_filter_names[][ETH_GSTRING_LEN];
 
 int __ethtool_get_link(struct net_device *dev);
+int __ethtool_get_sqi(struct net_device *dev);
+int __ethtool_get_sqi_max(struct net_device *dev);
 
 bool convert_legacy_settings_to_link_ksettings(
 	struct ethtool_link_ksettings *link_ksettings,
diff --git a/net/ethtool/linkstate.c b/net/ethtool/linkstate.c
index 2740cde0a182b..dc8bb4fff3bf5 100644
--- a/net/ethtool/linkstate.c
+++ b/net/ethtool/linkstate.c
@@ -10,6 +10,8 @@ struct linkstate_req_info {
 struct linkstate_reply_data {
 	struct ethnl_reply_data		base;
 	int				link;
+	int				sqi;
+	int				sqi_max;
 };
 
 #define LINKSTATE_REPDATA(__reply_base) \
@@ -20,6 +22,8 @@ linkstate_get_policy[ETHTOOL_A_LINKSTATE_MAX + 1] = {
 	[ETHTOOL_A_LINKSTATE_UNSPEC]		= { .type = NLA_REJECT },
 	[ETHTOOL_A_LINKSTATE_HEADER]		= { .type = NLA_NESTED },
 	[ETHTOOL_A_LINKSTATE_LINK]		= { .type = NLA_REJECT },
+	[ETHTOOL_A_LINKSTATE_SQI]		= { .type = NLA_REJECT },
+	[ETHTOOL_A_LINKSTATE_SQI_MAX]		= { .type = NLA_REJECT },
 };
 
 static int linkstate_prepare_data(const struct ethnl_req_info *req_base,
@@ -34,6 +38,19 @@ static int linkstate_prepare_data(const struct ethnl_req_info *req_base,
 	if (ret < 0)
 		return ret;
 	data->link = __ethtool_get_link(dev);
+
+	ret = __ethtool_get_sqi(dev);
+	if (ret < 0 && ret != -EOPNOTSUPP)
+		return ret;
+
+	data->sqi = ret;
+
+	ret = __ethtool_get_sqi_max(dev);
+	if (ret < 0 && ret != -EOPNOTSUPP)
+		return ret;
+
+	data->sqi_max = ret;
+
 	ethnl_ops_complete(dev);
 
 	return 0;
@@ -42,8 +59,19 @@ static int linkstate_prepare_data(const struct ethnl_req_info *req_base,
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
+	if (data->sqi != -EOPNOTSUPP)
+		len += nla_total_size(sizeof(u32));
+
+	if (data->sqi_max != -EOPNOTSUPP)
+		len += nla_total_size(sizeof(u32));
+
+	return len;
 }
 
 static int linkstate_fill_reply(struct sk_buff *skb,
@@ -56,6 +84,14 @@ static int linkstate_fill_reply(struct sk_buff *skb,
 	    nla_put_u8(skb, ETHTOOL_A_LINKSTATE_LINK, !!data->link))
 		return -EMSGSIZE;
 
+	if (data->sqi != -EOPNOTSUPP &&
+	    nla_put_u32(skb, ETHTOOL_A_LINKSTATE_SQI, data->sqi))
+		return -EMSGSIZE;
+
+	if (data->sqi_max != -EOPNOTSUPP &&
+	    nla_put_u32(skb, ETHTOOL_A_LINKSTATE_SQI_MAX, data->sqi_max))
+		return -EMSGSIZE;
+
 	return 0;
 }
 
-- 
2.26.2

