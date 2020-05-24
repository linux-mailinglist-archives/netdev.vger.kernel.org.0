Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E219D1DFFD0
	for <lists+netdev@lfdr.de>; Sun, 24 May 2020 17:28:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387636AbgEXP2M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 May 2020 11:28:12 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:46970 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728934AbgEXP2M (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 24 May 2020 11:28:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=BC/WucMJYt6aviY5gFfjbE+BONYZKfPLiPOTaECdZZI=; b=z47nGCS2Lg9UokkcvprOBqeiHJ
        atTMfpufMb7h7qBLSX4yW1putsVVVfoLalIGrf5/UANc5dgG7erXfHMLDlkqetKyc90GG7fQoS4s2
        pvloRcLuiYfp5fAJhgKz1QgqBJ60JGian7F7scqNI+lP+94HIkbKMNNS9nX31VUhcV3k=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jcsXl-00383e-45; Sun, 24 May 2020 17:28:05 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Chris Healy <cphealy@gmail.com>,
        Michal Kubecek <mkubecek@suse.cz>, Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH v2 net-next 5/6] net: ethtool: Allow PHY cable test TDR data to configured
Date:   Sun, 24 May 2020 17:27:45 +0200
Message-Id: <20200524152747.745893-6-andrew@lunn.ch>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200524152747.745893-1-andrew@lunn.ch>
References: <20200524152747.745893-1-andrew@lunn.ch>
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
---
 drivers/net/phy/marvell.c            | 60 ++++++++++++++++++-------
 drivers/net/phy/phy.c                |  6 ++-
 include/linux/phy.h                  | 10 +++--
 include/uapi/linux/ethtool_netlink.h |  4 ++
 net/ethtool/cabletest.c              | 67 +++++++++++++++++++++++++++-
 5 files changed, 123 insertions(+), 24 deletions(-)

diff --git a/drivers/net/phy/marvell.c b/drivers/net/phy/marvell.c
index e597bee2e966..7e1d95337a28 100644
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
@@ -1918,11 +1931,25 @@ static int marvell_vct7_cable_test_start(struct phy_device *phydev)
 			       MII_VCT7_CTRL_CENTIMETERS);
 }
 
-static int marvell_vct5_cable_test_tdr_start(struct phy_device *phydev)
+static int marvell_vct5_cable_test_tdr_start(struct phy_device *phydev,
+					     u32 first, u32 last, u32 step,
+					     s8 pair)
 {
 	struct marvell_priv *priv = phydev->priv;
 	int ret;
 
+	priv->cable_test_tdr = true;
+	priv->first = marvell_vct5_cm2distance(first);
+	priv->last = marvell_vct5_cm2distance(last);
+	priv->step = marvell_vct5_cm2distance(step);
+	priv->pair = pair;
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
@@ -1933,15 +1960,14 @@ static int marvell_vct5_cable_test_tdr_start(struct phy_device *phydev)
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
index f5a2396127b2..f04575de672a 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -553,7 +553,8 @@ int phy_start_cable_test(struct phy_device *phydev,
 EXPORT_SYMBOL(phy_start_cable_test);
 
 int phy_start_cable_test_tdr(struct phy_device *phydev,
-			     struct netlink_ext_ack *extack)
+			     struct netlink_ext_ack *extack,
+			     u32 first, u32 last, u32 step, s8 pair)
 {
 	struct net_device *dev = phydev->attached_dev;
 	int err = -ENOMEM;
@@ -590,7 +591,8 @@ int phy_start_cable_test_tdr(struct phy_device *phydev,
 	phy_link_down(phydev);
 
 	netif_testing_on(dev);
-	err = phydev->drv->cable_test_tdr_start(phydev);
+	err = phydev->drv->cable_test_tdr_start(phydev, first, last, step,
+						pair);
 	if (err) {
 		netif_testing_off(dev);
 		phy_link_up(phydev);
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 11fc06299650..929b7100d982 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -706,8 +706,10 @@ struct phy_driver {
 	/* Start a cable test */
 	int (*cable_test_start)(struct phy_device *dev);
 
+#define PHY_PAIR_ALL -1
 	/* Start a raw TDR cable test */
-	int (*cable_test_tdr_start)(struct phy_device *dev);
+	int (*cable_test_tdr_start)(struct phy_device *dev,
+				    u32 first, u32 last, u32 step, s8 pair);
 
 	/* Once per second, or on interrupt, request the status of the
 	 * test.
@@ -1262,7 +1264,8 @@ int phy_reset_after_clk_enable(struct phy_device *phydev);
 int phy_start_cable_test(struct phy_device *phydev,
 			 struct netlink_ext_ack *extack);
 int phy_start_cable_test_tdr(struct phy_device *phydev,
-			     struct netlink_ext_ack *extack);
+			     struct netlink_ext_ack *extack,
+			     u32 start, u32 last, u32 step, s8 pair);
 #else
 static inline
 int phy_start_cable_test(struct phy_device *phydev,
@@ -1273,7 +1276,8 @@ int phy_start_cable_test(struct phy_device *phydev,
 }
 static inline
 int phy_start_cable_test_tdr(struct phy_device *phydev,
-			     struct netlink_ext_ack *extack)
+			     struct netlink_ext_ack *extack,
+			     u32 start, u32 last, u32 step, s8 pair)
 {
 	NL_SET_ERR_MSG(extack, "Kernel not compiled with PHYLIB support");
 	return -EOPNOTSUPP;
diff --git a/include/uapi/linux/ethtool_netlink.h b/include/uapi/linux/ethtool_netlink.h
index 739faa7070c6..0b68ab7d08ea 100644
--- a/include/uapi/linux/ethtool_netlink.h
+++ b/include/uapi/linux/ethtool_netlink.h
@@ -485,6 +485,10 @@ enum {
 enum {
 	ETHTOOL_A_CABLE_TEST_TDR_UNSPEC,
 	ETHTOOL_A_CABLE_TEST_TDR_HEADER,	/* nest - _A_HEADER_* */
+	ETHTOOL_A_CABLE_TEST_TDR_FIRST,		/* u32 */
+	ETHTOOL_A_CABLE_TEST_TDR_LAST,		/* u32 */
+	ETHTOOL_A_CABLE_TEST_TDR_STEP,		/* u32 */
+	ETHTOOL_A_CABLE_TEST_TDR_PAIR,		/* u8 */
 
 	/* add new constants above here */
 	__ETHTOOL_A_CABLE_TEST_TDR_CNT,
diff --git a/net/ethtool/cabletest.c b/net/ethtool/cabletest.c
index c02575e26336..ddf678eae44f 100644
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
@@ -203,18 +207,30 @@ int ethnl_cable_test_fault_length(struct phy_device *phydev, u8 pair, u32 cm)
 }
 EXPORT_SYMBOL_GPL(ethnl_cable_test_fault_length);
 
+struct cable_test_tdr_req_info {
+	struct ethnl_req_info		base;
+};
+
 static const struct nla_policy
 cable_test_tdr_act_policy[ETHTOOL_A_CABLE_TEST_TDR_MAX + 1] = {
 	[ETHTOOL_A_CABLE_TEST_TDR_UNSPEC]	= { .type = NLA_REJECT },
 	[ETHTOOL_A_CABLE_TEST_TDR_HEADER]	= { .type = NLA_NESTED },
+	[ETHTOOL_A_CABLE_TEST_TDR_FIRST]	= { .type = NLA_U32 },
+	[ETHTOOL_A_CABLE_TEST_TDR_LAST]		= { .type = NLA_U32 },
+	[ETHTOOL_A_CABLE_TEST_TDR_STEP]		= { .type = NLA_U32 },
+	[ETHTOOL_A_CABLE_TEST_TDR_PAIR]		= { .type = NLA_U8 },
 };
 
+/* CABLE_TEST_TDR_ACT */
+
 int ethnl_act_cable_test_tdr(struct sk_buff *skb, struct genl_info *info)
 {
 	struct nlattr *tb[ETHTOOL_A_CABLE_TEST_TDR_MAX + 1];
 	struct ethnl_req_info req_info = {};
 	struct net_device *dev;
+	u32 first, last, step;
 	int ret;
+	u8 pair;
 
 	ret = nlmsg_parse(info->nlhdr, GENL_HDRLEN, tb,
 			  ETHTOOL_A_CABLE_TEST_TDR_MAX,
@@ -235,12 +251,59 @@ int ethnl_act_cable_test_tdr(struct sk_buff *skb, struct genl_info *info)
 		goto out_dev_put;
 	}
 
+	if (tb[ETHTOOL_A_CABLE_TEST_TDR_FIRST])
+		first = nla_get_u32(tb[ETHTOOL_A_CABLE_TEST_TDR_FIRST]);
+	else
+		first = 100;
+	if (tb[ETHTOOL_A_CABLE_TEST_TDR_LAST])
+		last = nla_get_u32(tb[ETHTOOL_A_CABLE_TEST_TDR_LAST]);
+	else
+		last = MAX_CABLE_LENGTH_CM;
+
+	if (tb[ETHTOOL_A_CABLE_TEST_TDR_STEP])
+		step = nla_get_u32(tb[ETHTOOL_A_CABLE_TEST_TDR_STEP]);
+	else
+		step = 100;
+
+	if (tb[ETHTOOL_A_CABLE_TEST_TDR_PAIR]) {
+		pair = nla_get_u8(tb[ETHTOOL_A_CABLE_TEST_TDR_PAIR]);
+		if (pair < ETHTOOL_A_CABLE_PAIR_A ||
+		    pair > ETHTOOL_A_CABLE_PAIR_D) {
+			NL_SET_ERR_MSG(info->extack,
+				       "invalid pair parameter");
+			return -EINVAL;
+		}
+	} else {
+		pair = PHY_PAIR_ALL;
+	}
+
+	if (first > MAX_CABLE_LENGTH_CM) {
+		NL_SET_ERR_MSG(info->extack, "invalid first parameter");
+		return -EINVAL;
+	}
+
+	if (last > MAX_CABLE_LENGTH_CM) {
+		NL_SET_ERR_MSG(info->extack, "invalid last parameter");
+		return -EINVAL;
+	}
+
+	if (first > last) {
+		NL_SET_ERR_MSG(info->extack, "invalid first/last parameter");
+		return -EINVAL;
+	}
+
+	if (!step) {
+		NL_SET_ERR_MSG(info->extack, "invalid step parameter");
+		return -EINVAL;
+	}
+
 	rtnl_lock();
 	ret = ethnl_ops_begin(dev);
 	if (ret < 0)
 		goto out_rtnl;
 
-	ret = phy_start_cable_test_tdr(dev->phydev, info->extack);
+	ret = phy_start_cable_test_tdr(dev->phydev, info->extack,
+				       first, last, step, pair);
 
 	ethnl_ops_complete(dev);
 
-- 
2.27.0.rc0

