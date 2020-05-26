Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 170B21E325E
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 00:22:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404373AbgEZWWL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 18:22:11 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:50624 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390126AbgEZWWJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 May 2020 18:22:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=uTZVX20GYC11tTKXaXcAKh/XJKTm7+hWDZKI6MqgTr8=; b=xyrV2DZPhhZkaFHG71AQ4VwqIT
        yQopTXrzcXY2GDxv6j3n3llM3e6CiED+IcSWOP+HItbmR0D7hyy0gF2O1eRgWsbOtv5FSyIMp++r2
        iUHYN8TVPKFnuU+r7lT4xpD54fKFvqModIQ8rx4IxJFYdt25o/YvEAjbNMuiqNlwIIsg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jdhxK-003KTJ-68; Wed, 27 May 2020 00:21:54 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Chris Healy <cphealy@gmail.com>,
        Michal Kubecek <mkubecek@suse.cz>, Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH v3 net-next 5/7] net: ethtool: Allow PHY cable test TDR data to configured
Date:   Wed, 27 May 2020 00:21:41 +0200
Message-Id: <20200526222143.793613-6-andrew@lunn.ch>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200526222143.793613-1-andrew@lunn.ch>
References: <20200526222143.793613-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Allow the user to configure where on the cable the TDR data should be
retrieved, in terms of first and last sample, and the step between
samples. Also add the ability to ask for TDR data for just one pair.

If this configuration is not provided, it defaults to 1-150m at 1m
intervals for all pairs.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>

v3:
Move the TDR configuration into a structure
Add a range check on step
Use NL_SET_ERR_MSG_ATTR() when appropriate
Move TDR configuration into a nest
Document attributes in the request
---
 Documentation/networking/ethtool-netlink.rst |  22 +++-
 drivers/net/phy/marvell.c                    |  59 ++++++++---
 drivers/net/phy/phy.c                        |   5 +-
 include/linux/phy.h                          |  21 +++-
 include/uapi/linux/ethtool_netlink.h         |  13 +++
 net/ethtool/cabletest.c                      | 104 ++++++++++++++++++-
 6 files changed, 197 insertions(+), 27 deletions(-)

diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation/networking/ethtool-netlink.rst
index dae36227d590..d42661b91128 100644
--- a/Documentation/networking/ethtool-netlink.rst
+++ b/Documentation/networking/ethtool-netlink.rst
@@ -1023,9 +1023,25 @@ Start a cable test and report raw TDR data
 
 Request contents:
 
-  ====================================  ======  ==========================
-  ``ETHTOOL_A_CABLE_TEST_TDR_HEADER``   nested  request header
-  ====================================  ======  ==========================
+ +--------------------------------------------+--------+-----------------------+
+ | ``ETHTOOL_A_CABLE_TEST_TDR_HEADER``        | nested | reply header          |
+ +--------------------------------------------+--------+-----------------------+
+ | ``ETHTOOL_A_CABLE_TEST_TDR_CFG``           | nested | test configuration    |
+ +-+------------------------------------------+--------+-----------------------+
+ | | ``ETHTOOL_A_CABLE_STEP_FIRST_DISTANCE `` | u32    | first data distance   |
+ +-+-+----------------------------------------+--------+-----------------------+
+ | | ``ETHTOOL_A_CABLE_STEP_LAST_DISTANCE ``  | u32    | last data distance    |
+ +-+-+----------------------------------------+--------+-----------------------+
+ | | ``ETHTOOL_A_CABLE_STEP_STEP_DISTANCE ``  | u32    | distance of each step |
+ +-+-+----------------------------------------+--------+-----------------------+
+ | | ``ETHTOOL_A_CABLE_TEST_TDR_CFG_PAIR``    | u8     | pair to test          |
+ +-+-+----------------------------------------+--------+-----------------------+
+
+The ETHTOOL_A_CABLE_TEST_TDR_CFG is optional, as well as all members
+of the nest. All distances are expressed in centimeters. The PHY takes
+the distances as a guide, and rounds to the nearest distance it
+actually supports. If a pair is passed, only that one pair will be
+tested. Otherwise all pairs are tested.
 
 Notification contents:
 
diff --git a/drivers/net/phy/marvell.c b/drivers/net/phy/marvell.c
index e597bee2e966..335e51d6f138 100644
--- a/drivers/net/phy/marvell.c
+++ b/drivers/net/phy/marvell.c
@@ -198,6 +198,7 @@
 #define MII_VCT5_CTRL_PEEK_HYST_DEFAULT			3
 
 #define MII_VCT5_SAMPLE_POINT_DISTANCE		0x18
+#define MII_VCT5_SAMPLE_POINT_DISTANCE_MAX	511
 #define MII_VCT5_TX_PULSE_CTRL			0x1c
 #define MII_VCT5_TX_PULSE_CTRL_DONT_WAIT_LINK_DOWN	BIT(12)
 #define MII_VCT5_TX_PULSE_CTRL_PULSE_WIDTH_128nS	(0x0 << 10)
@@ -270,6 +271,10 @@ struct marvell_priv {
 	char *hwmon_name;
 	struct device *hwmon_dev;
 	bool cable_test_tdr;
+	u32 first;
+	u32 last;
+	u32 step;
+	s8 pair;
 };
 
 static int marvell_read_page(struct phy_device *phydev)
@@ -1787,12 +1792,18 @@ static u32 marvell_vct5_distance2cm(int distance)
 	return distance * 805 / 10;
 }
 
+static u32 marvell_vct5_cm2distance(int cm)
+{
+	return cm * 10 / 805;
+}
+
 static int marvell_vct5_amplitude_distance(struct phy_device *phydev,
-					   int distance)
+					   int distance, int pair)
 {
-	int mV_pair0, mV_pair1, mV_pair2, mV_pair3;
 	u16 reg;
 	int err;
+	int mV;
+	int i;
 
 	err = phy_write_paged(phydev, MII_MARVELL_VCT5_PAGE,
 			      MII_VCT5_SAMPLE_POINT_DISTANCE,
@@ -1814,21 +1825,20 @@ static int marvell_vct5_amplitude_distance(struct phy_device *phydev,
 	if (err)
 		return err;
 
-	mV_pair0 = marvell_vct5_amplitude(phydev, 0);
-	mV_pair1 = marvell_vct5_amplitude(phydev, 1);
-	mV_pair2 = marvell_vct5_amplitude(phydev, 2);
-	mV_pair3 = marvell_vct5_amplitude(phydev, 3);
+	for (i = 0; i < 4; i++) {
+		if (pair != PHY_PAIR_ALL && i != pair)
+			continue;
 
-	ethnl_cable_test_amplitude(phydev, ETHTOOL_A_CABLE_PAIR_A, mV_pair0);
-	ethnl_cable_test_amplitude(phydev, ETHTOOL_A_CABLE_PAIR_B, mV_pair1);
-	ethnl_cable_test_amplitude(phydev, ETHTOOL_A_CABLE_PAIR_C, mV_pair2);
-	ethnl_cable_test_amplitude(phydev, ETHTOOL_A_CABLE_PAIR_D, mV_pair3);
+		mV = marvell_vct5_amplitude(phydev, i);
+		ethnl_cable_test_amplitude(phydev, i, mV);
+	}
 
 	return 0;
 }
 
 static int marvell_vct5_amplitude_graph(struct phy_device *phydev)
 {
+	struct marvell_priv *priv = phydev->priv;
 	int distance;
 	int err;
 	u16 reg;
@@ -1843,8 +1853,11 @@ static int marvell_vct5_amplitude_graph(struct phy_device *phydev)
 	if (err)
 		return err;
 
-	for (distance = 0; distance <= 100; distance++) {
-		err = marvell_vct5_amplitude_distance(phydev, distance);
+	for (distance = priv->first;
+	     distance <= priv->last;
+	     distance += priv->step) {
+		err = marvell_vct5_amplitude_distance(phydev, distance,
+						      priv->pair);
 		if (err)
 			return err;
 	}
@@ -1918,11 +1931,24 @@ static int marvell_vct7_cable_test_start(struct phy_device *phydev)
 			       MII_VCT7_CTRL_CENTIMETERS);
 }
 
-static int marvell_vct5_cable_test_tdr_start(struct phy_device *phydev)
+static int marvell_vct5_cable_test_tdr_start(struct phy_device *phydev,
+					     const struct phy_tdr_config *cfg)
 {
 	struct marvell_priv *priv = phydev->priv;
 	int ret;
 
+	priv->cable_test_tdr = true;
+	priv->first = marvell_vct5_cm2distance(cfg->first);
+	priv->last = marvell_vct5_cm2distance(cfg->last);
+	priv->step = marvell_vct5_cm2distance(cfg->step);
+	priv->pair = cfg->pair;
+
+	if (priv->first > MII_VCT5_SAMPLE_POINT_DISTANCE_MAX)
+		return -EINVAL;
+
+	if (priv->last > MII_VCT5_SAMPLE_POINT_DISTANCE_MAX)
+		return -EINVAL;
+
 	/* Disable  VCT7 */
 	ret = phy_write_paged(phydev, MII_MARVELL_VCT7_PAGE,
 			      MII_VCT7_CTRL, 0);
@@ -1933,15 +1959,14 @@ static int marvell_vct5_cable_test_tdr_start(struct phy_device *phydev)
 	if (ret)
 		return ret;
 
-	priv->cable_test_tdr = true;
 	ret = ethnl_cable_test_pulse(phydev, 1000);
 	if (ret)
 		return ret;
 
 	return ethnl_cable_test_step(phydev,
-				     marvell_vct5_distance2cm(0),
-				     marvell_vct5_distance2cm(100),
-				     marvell_vct5_distance2cm(1));
+				     marvell_vct5_distance2cm(priv->first),
+				     marvell_vct5_distance2cm(priv->last),
+				     marvell_vct5_distance2cm(priv->step));
 }
 
 static int marvell_vct7_distance_to_length(int distance, bool meter)
diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index f5a2396127b2..e90fc1953507 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -553,7 +553,8 @@ int phy_start_cable_test(struct phy_device *phydev,
 EXPORT_SYMBOL(phy_start_cable_test);
 
 int phy_start_cable_test_tdr(struct phy_device *phydev,
-			     struct netlink_ext_ack *extack)
+			     struct netlink_ext_ack *extack,
+			     const struct phy_tdr_config *config)
 {
 	struct net_device *dev = phydev->attached_dev;
 	int err = -ENOMEM;
@@ -590,7 +591,7 @@ int phy_start_cable_test_tdr(struct phy_device *phydev,
 	phy_link_down(phydev);
 
 	netif_testing_on(dev);
-	err = phydev->drv->cable_test_tdr_start(phydev);
+	err = phydev->drv->cable_test_tdr_start(phydev, config);
 	if (err) {
 		netif_testing_off(dev);
 		phy_link_up(phydev);
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 11fc06299650..7b863a538782 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -554,6 +554,18 @@ struct phy_device {
 #define to_phy_device(d) container_of(to_mdio_device(d), \
 				      struct phy_device, mdio)
 
+/* A structure containing possible configuration parameters
+ * for a TDR cable test. The driver does not need to implement
+ * all the parameters, but should report what is actually used.
+ */
+struct phy_tdr_config {
+	u32 first;
+	u32 last;
+	u32 step;
+	s8 pair;
+};
+#define PHY_PAIR_ALL -1
+
 /* struct phy_driver: Driver structure for a particular PHY type
  *
  * driver_data: static driver data
@@ -707,7 +719,8 @@ struct phy_driver {
 	int (*cable_test_start)(struct phy_device *dev);
 
 	/* Start a raw TDR cable test */
-	int (*cable_test_tdr_start)(struct phy_device *dev);
+	int (*cable_test_tdr_start)(struct phy_device *dev,
+				    const struct phy_tdr_config *config);
 
 	/* Once per second, or on interrupt, request the status of the
 	 * test.
@@ -1262,7 +1275,8 @@ int phy_reset_after_clk_enable(struct phy_device *phydev);
 int phy_start_cable_test(struct phy_device *phydev,
 			 struct netlink_ext_ack *extack);
 int phy_start_cable_test_tdr(struct phy_device *phydev,
-			     struct netlink_ext_ack *extack);
+			     struct netlink_ext_ack *extack,
+			     const struct phy_tdr_config *config);
 #else
 static inline
 int phy_start_cable_test(struct phy_device *phydev,
@@ -1273,7 +1287,8 @@ int phy_start_cable_test(struct phy_device *phydev,
 }
 static inline
 int phy_start_cable_test_tdr(struct phy_device *phydev,
-			     struct netlink_ext_ack *extack)
+			     struct netlink_ext_ack *extack,
+			     const struct phy_tdr_config *config)
 {
 	NL_SET_ERR_MSG(extack, "Kernel not compiled with PHYLIB support");
 	return -EOPNOTSUPP;
diff --git a/include/uapi/linux/ethtool_netlink.h b/include/uapi/linux/ethtool_netlink.h
index 739faa7070c6..fc9051f2eeac 100644
--- a/include/uapi/linux/ethtool_netlink.h
+++ b/include/uapi/linux/ethtool_netlink.h
@@ -482,9 +482,22 @@ enum {
 
 /* CABLE TEST TDR */
 
+enum {
+	ETHTOOL_A_CABLE_TEST_TDR_CFG_UNSPEC,
+	ETHTOOL_A_CABLE_TEST_TDR_CFG_FIRST,		/* u32 */
+	ETHTOOL_A_CABLE_TEST_TDR_CFG_LAST,		/* u32 */
+	ETHTOOL_A_CABLE_TEST_TDR_CFG_STEP,		/* u32 */
+	ETHTOOL_A_CABLE_TEST_TDR_CFG_PAIR,		/* u8 */
+
+	/* add new constants above here */
+	__ETHTOOL_A_CABLE_TEST_TDR_CFG_CNT,
+	ETHTOOL_A_CABLE_TEST_TDR_CFG_MAX = __ETHTOOL_A_CABLE_TEST_TDR_CFG_CNT - 1
+};
+
 enum {
 	ETHTOOL_A_CABLE_TEST_TDR_UNSPEC,
 	ETHTOOL_A_CABLE_TEST_TDR_HEADER,	/* nest - _A_HEADER_* */
+	ETHTOOL_A_CABLE_TEST_TDR_CFG,		/* nest - *_TDR_CFG_* */
 
 	/* add new constants above here */
 	__ETHTOOL_A_CABLE_TEST_TDR_CNT,
diff --git a/net/ethtool/cabletest.c b/net/ethtool/cabletest.c
index c02575e26336..c30b6dcbe797 100644
--- a/net/ethtool/cabletest.c
+++ b/net/ethtool/cabletest.c
@@ -5,7 +5,11 @@
 #include "netlink.h"
 #include "common.h"
 
-/* CABLE_TEST_ACT */
+/* 802.3 standard allows 100 meters for BaseT cables. However longer
+ * cables might work, depending on the quality of the cables and the
+ * PHY. So allow testing for up to 150 meters.
+ */
+#define MAX_CABLE_LENGTH_CM (150 * 100)
 
 static const struct nla_policy
 cable_test_act_policy[ETHTOOL_A_CABLE_TEST_MAX + 1] = {
@@ -203,16 +207,107 @@ int ethnl_cable_test_fault_length(struct phy_device *phydev, u8 pair, u32 cm)
 }
 EXPORT_SYMBOL_GPL(ethnl_cable_test_fault_length);
 
+struct cable_test_tdr_req_info {
+	struct ethnl_req_info		base;
+};
+
+static const struct nla_policy
+cable_test_tdr_act_cfg_policy[ETHTOOL_A_CABLE_TEST_TDR_CFG_MAX + 1] = {
+	[ETHTOOL_A_CABLE_TEST_TDR_CFG_FIRST]	= { .type = NLA_U32 },
+	[ETHTOOL_A_CABLE_TEST_TDR_CFG_LAST]	= { .type = NLA_U32 },
+	[ETHTOOL_A_CABLE_TEST_TDR_CFG_STEP]	= { .type = NLA_U32 },
+	[ETHTOOL_A_CABLE_TEST_TDR_CFG_PAIR]	= { .type = NLA_U8 },
+};
+
 static const struct nla_policy
 cable_test_tdr_act_policy[ETHTOOL_A_CABLE_TEST_TDR_MAX + 1] = {
 	[ETHTOOL_A_CABLE_TEST_TDR_UNSPEC]	= { .type = NLA_REJECT },
 	[ETHTOOL_A_CABLE_TEST_TDR_HEADER]	= { .type = NLA_NESTED },
+	[ETHTOOL_A_CABLE_TEST_TDR_CFG]		= { .type = NLA_NESTED },
 };
 
+/* CABLE_TEST_TDR_ACT */
+int ethnl_act_cable_test_tdr_cfg(const struct nlattr *nest,
+				 struct genl_info *info,
+				 struct phy_tdr_config *cfg)
+{
+	struct nlattr *tb[ETHTOOL_A_CABLE_TEST_TDR_CFG_MAX + 1];
+	int ret;
+
+	ret = nla_parse_nested(tb, ETHTOOL_A_CABLE_TEST_TDR_CFG_MAX, nest,
+			       cable_test_tdr_act_cfg_policy, info->extack);
+	if (ret < 0)
+		return ret;
+
+	if (tb[ETHTOOL_A_CABLE_TEST_TDR_CFG_FIRST])
+		cfg->first = nla_get_u32(
+			tb[ETHTOOL_A_CABLE_TEST_TDR_CFG_FIRST]);
+	else
+		cfg->first = 100;
+	if (tb[ETHTOOL_A_CABLE_TEST_TDR_CFG_LAST])
+		cfg->last = nla_get_u32(tb[ETHTOOL_A_CABLE_TEST_TDR_CFG_LAST]);
+	else
+		cfg->last = MAX_CABLE_LENGTH_CM;
+
+	if (tb[ETHTOOL_A_CABLE_TEST_TDR_CFG_STEP])
+		cfg->step = nla_get_u32(tb[ETHTOOL_A_CABLE_TEST_TDR_CFG_STEP]);
+	else
+		cfg->step = 100;
+
+	if (tb[ETHTOOL_A_CABLE_TEST_TDR_CFG_PAIR]) {
+		cfg->pair = nla_get_u8(tb[ETHTOOL_A_CABLE_TEST_TDR_CFG_PAIR]);
+		if (cfg->pair > ETHTOOL_A_CABLE_PAIR_D) {
+			NL_SET_ERR_MSG_ATTR(
+				info->extack,
+				tb[ETHTOOL_A_CABLE_TEST_TDR_CFG_PAIR],
+				"invalid pair parameter");
+			return -EINVAL;
+		}
+	} else {
+		cfg->pair = PHY_PAIR_ALL;
+	}
+
+	if (cfg->first > MAX_CABLE_LENGTH_CM) {
+		NL_SET_ERR_MSG_ATTR(info->extack,
+				    tb[ETHTOOL_A_CABLE_TEST_TDR_CFG_FIRST],
+				    "invalid first parameter");
+		return -EINVAL;
+	}
+
+	if (cfg->last > MAX_CABLE_LENGTH_CM) {
+		NL_SET_ERR_MSG_ATTR(info->extack,
+				    tb[ETHTOOL_A_CABLE_TEST_TDR_CFG_LAST],
+				    "invalid last parameter");
+		return -EINVAL;
+	}
+
+	if (cfg->first > cfg->last) {
+		NL_SET_ERR_MSG(info->extack, "invalid first/last parameter");
+		return -EINVAL;
+	}
+
+	if (!cfg->step) {
+		NL_SET_ERR_MSG_ATTR(info->extack,
+				    tb[ETHTOOL_A_CABLE_TEST_TDR_CFG_STEP],
+				    "invalid step parameter");
+		return -EINVAL;
+	}
+
+	if (cfg->step > (cfg->last - cfg->first)) {
+		NL_SET_ERR_MSG_ATTR(info->extack,
+				    tb[ETHTOOL_A_CABLE_TEST_TDR_CFG_STEP],
+				    "step parameter too big");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 int ethnl_act_cable_test_tdr(struct sk_buff *skb, struct genl_info *info)
 {
 	struct nlattr *tb[ETHTOOL_A_CABLE_TEST_TDR_MAX + 1];
 	struct ethnl_req_info req_info = {};
+	struct phy_tdr_config cfg;
 	struct net_device *dev;
 	int ret;
 
@@ -235,12 +330,17 @@ int ethnl_act_cable_test_tdr(struct sk_buff *skb, struct genl_info *info)
 		goto out_dev_put;
 	}
 
+	ret = ethnl_act_cable_test_tdr_cfg(tb[ETHTOOL_A_CABLE_TEST_TDR_CFG],
+					   info, &cfg);
+	if (ret)
+		goto out_dev_put;
+
 	rtnl_lock();
 	ret = ethnl_ops_begin(dev);
 	if (ret < 0)
 		goto out_rtnl;
 
-	ret = phy_start_cable_test_tdr(dev->phydev, info->extack);
+	ret = phy_start_cable_test_tdr(dev->phydev, info->extack, &cfg);
 
 	ethnl_ops_complete(dev);
 
-- 
2.27.0.rc0

