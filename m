Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F207842BCD
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 18:07:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408871AbfFLQHZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 12:07:25 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:49372 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406640AbfFLQHZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 Jun 2019 12:07:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Sender:Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=5RzmyATgnQe0+fO6aDqx4heqSZnykvSDIPTshc8Kczg=; b=qc8usuoOHyrDKd1FmhI/JKRyg2
        bBUiDgeovSfx7etLs0CjMw6lIlTBx5nz8LZwMTD5qbQJTijb70aIWGO8gERsb9oueeLBHQP4HyZ1g
        KsFFocvyOxauSf5fk25z4nrcPA1Ig9l4iUEXFKPpwWkq+gZbgQFmKtFfnhLIwP/lHouM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hb5lD-000693-9u; Wed, 12 Jun 2019 18:06:03 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     netdev <netdev@vger.kernel.org>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Raju.Lakkaraju@microchip.com, Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH RFC 10/13] net: phy: Allow options to be passed to the cable test
Date:   Wed, 12 Jun 2019 18:05:31 +0200
Message-Id: <20190612160534.23533-11-andrew@lunn.ch>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190612160534.23533-1-andrew@lunn.ch>
References: <20190612160534.23533-1-andrew@lunn.ch>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some PHYs can do more than just measure the distance to a fault.  But
these additional actions are expensive. So allow options to be passed
to enable these additional actions.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/phy/marvell.c            |  6 +++++-
 drivers/net/phy/phy.c                |  5 +++--
 include/linux/phy.h                  |  7 ++++---
 include/uapi/linux/ethtool_netlink.h |  1 +
 net/ethtool/actions.c                | 10 ++++++++--
 5 files changed, 21 insertions(+), 8 deletions(-)

diff --git a/drivers/net/phy/marvell.c b/drivers/net/phy/marvell.c
index 96354513daba..11a19c354533 100644
--- a/drivers/net/phy/marvell.c
+++ b/drivers/net/phy/marvell.c
@@ -1667,10 +1667,14 @@ static void marvell_get_stats(struct phy_device *phydev,
 		data[i] = marvell_get_stat(phydev, i);
 }
 
-static int marvell_vct7_cable_test_start(struct phy_device *phydev)
+static int marvell_vct7_cable_test_start(struct phy_device *phydev,
+					 int options)
 {
 	int bmcr, bmsr, ret;
 
+	if (options)
+		return -EOPNOTSUPP;
+
 	/* If auto-negotiation is enabled, but not complete, the
 	   cable test never completes. So disable auto-neg.
 	*/
diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index 6540523d773a..38a766fc0923 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -533,7 +533,8 @@ int phy_cable_test_fault_length(struct phy_device *phydev, u8 pair, u16 cm)
 EXPORT_SYMBOL_GPL(phy_cable_test_fault_length);
 
 int phy_start_cable_test(struct phy_device *phydev,
-			 struct netlink_ext_ack *extack, u32 seq)
+			 struct netlink_ext_ack *extack, u32 seq,
+			 int options)
 {
 	int err = -ENOMEM;
 	int ret;
@@ -577,7 +578,7 @@ int phy_start_cable_test(struct phy_device *phydev,
 	/* Mark the carrier down until the test is complete */
 	phy_link_down(phydev, true);
 
-	err = phydev->drv->cable_test_start(phydev);
+	err = phydev->drv->cable_test_start(phydev, options);
 	if (err) {
 		phy_link_up(phydev);
 		goto out_free;
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 23c18583ea07..2ef7dc37ea44 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -641,7 +641,7 @@ struct phy_driver {
 			     struct ethtool_eeprom *ee, u8 *data);
 
 	/* Start a cable test */
-	int (*cable_test_start)(struct phy_device *dev);
+	int (*cable_test_start)(struct phy_device *dev, int options);
 	/* Once per second, or on interrupt, request the status of the
 	 * test.
 	 */
@@ -1078,12 +1078,12 @@ int phy_reset_after_clk_enable(struct phy_device *phydev);
 #if IS_ENABLED(CONFIG_PHYLIB)
 int phy_start_cable_test(struct phy_device *phydev,
 			 struct netlink_ext_ack *extack,
-			 u32 seq);
+			 u32 seq, int options);
 #else
 static inline
 int phy_start_cable_test(struct phy_device *phydev,
 			 struct netlink_ext_ack *extack,
-			 u32 seq)
+			 u32 seq, int options)
 {
 	NL_SET_ERR_MSG(extack, "Kernel not compiled with PHYLIB support");
 	return -EOPNOTSUPP;
@@ -1093,6 +1093,7 @@ int phy_start_cable_test(struct phy_device *phydev,
 int phy_cable_test_result(struct phy_device *phydev, u8 pair, u16 result);
 int phy_cable_test_fault_length(struct phy_device *phydev, u8 pair,
 				u16 cm);
+#define PHY_CABLE_TEST_AMPLITUDE_GRAPH BIT(0)
 
 static inline void phy_device_reset(struct phy_device *phydev, int value)
 {
diff --git a/include/uapi/linux/ethtool_netlink.h b/include/uapi/linux/ethtool_netlink.h
index aac76a26f97b..841f23ca2306 100644
--- a/include/uapi/linux/ethtool_netlink.h
+++ b/include/uapi/linux/ethtool_netlink.h
@@ -565,6 +565,7 @@ enum {
 enum {
 	ETHTOOL_A_CABLE_TEST_UNSPEC,
 	ETHTOOL_A_CABLE_TEST_DEV,		/* nest - ETHTOOL_A_DEV_* */
+	ETHTOOL_A_CABLE_TEST_AMPLITUDE_GRAPH,
 
 	__ETHTOOL_A_CABLE_TEST_CNT,
 	ETHTOOL_A_CABLE_TEST_MAX = (__ETHTOOL_A_CABLE_TEST_CNT - 1)
diff --git a/net/ethtool/actions.c b/net/ethtool/actions.c
index 8595cc27d532..12ff93c526f0 100644
--- a/net/ethtool/actions.c
+++ b/net/ethtool/actions.c
@@ -382,7 +382,8 @@ int ethnl_act_reset(struct sk_buff *skb, struct genl_info *info)
 static const struct
 nla_policy cable_test_policy[ETHTOOL_A_CABLE_TEST_MAX + 1] = {
 	[ETHTOOL_A_CABLE_TEST_UNSPEC]	= { .type = NLA_REJECT },
-	[ETHTOOL_A_CABLE_TEST_DEV]		= { .type = NLA_NESTED },
+	[ETHTOOL_A_CABLE_TEST_DEV]	= { .type = NLA_NESTED },
+	[ETHTOOL_A_CABLE_TEST_AMPLITUDE_GRAPH] = { .type = NLA_FLAG },
 };
 
 void ethnl_cable_test_notify(struct net_device *dev,
@@ -418,6 +419,7 @@ void ethnl_cable_test_notify(struct net_device *dev,
 int ethnl_act_cable_test(struct sk_buff *skb, struct genl_info *info)
 {
 	struct nlattr *tb[ETHTOOL_A_CABLE_TEST_MAX + 1];
+	int options = 0;
 	struct net_device *dev;
 	int ret;
 
@@ -435,12 +437,16 @@ int ethnl_act_cable_test(struct sk_buff *skb, struct genl_info *info)
 	if (!dev->phydev)
 		goto out_dev;
 
+	if (tb[ETHTOOL_A_CABLE_TEST_AMPLITUDE_GRAPH])
+		options = PHY_CABLE_TEST_AMPLITUDE_GRAPH;
+
 	rtnl_lock();
 	ret = ethnl_before_ops(dev);
 	if (ret < 0)
 		goto out_rtnl;
 
-	ret = phy_start_cable_test(dev->phydev, info->extack, info->snd_seq);
+	ret = phy_start_cable_test(dev->phydev, info->extack, info->snd_seq,
+				   options);
 
 	ethnl_after_ops(dev);
 
-- 
2.20.1

