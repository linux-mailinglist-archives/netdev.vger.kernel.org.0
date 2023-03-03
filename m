Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2177B6A9BF6
	for <lists+netdev@lfdr.de>; Fri,  3 Mar 2023 17:43:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231171AbjCCQnL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Mar 2023 11:43:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231254AbjCCQnI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Mar 2023 11:43:08 -0500
Received: from relay2-d.mail.gandi.net (relay2-d.mail.gandi.net [217.70.183.194])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9DA3BBAF;
        Fri,  3 Mar 2023 08:43:05 -0800 (PST)
Received: (Authenticated sender: kory.maincent@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id EB74C40003;
        Fri,  3 Mar 2023 16:43:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1677861784;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=//XnOC4QFhmJ7i1YYoN/2+RccvSoeB5H6nk0zPIwbOo=;
        b=CfYES1Mn4SKovvzDlfSASlocr5IrxtmT4WFJGnwtTM9zvgONA9y/2oY+UPaK9nmDMzeEkK
        ce60mxgA8wP2cglpzFD2VSg6GCqxJyfFfm6Lc4C0Hgg9vZlY3WsFPI2yfXUFXPJeAlJDNZ
        WMPAVbLXuJxQi3rm6FC4Qm2Ernwga8Cv5oghIb0nAa2sfzQpBBgu4foACtNKMoi56R33iI
        N5Pc4vdcnrRjgfy4XRhkbE89f6bR7/61/BAqSj0wdu3kZgnsNUfD4iXxNs4GCBr+iN04Pe
        zndpeWA51yrMlymqj0pAr2dvIN0Mg1KlqzIG99RF1+hjKhkHFmetRK2W4qovww==
From:   =?UTF-8?q?K=C3=B6ry=20Maincent?= <kory.maincent@bootlin.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-omap@vger.kernel.org
Cc:     Michael Walle <michael@walle.cc>,
        Richard Cochran <richardcochran@gmail.com>,
        Kory Maincent <kory.maincent@bootlin.com>,
        thomas.petazzoni@bootlin.com, Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Minghao Chi <chi.minghao@zte.com.cn>,
        Jie Wang <wangjie125@huawei.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Wang Yufen <wangyufen@huawei.com>,
        Alexandru Tachici <alexandru.tachici@analog.com>
Subject: [PATCH v2 1/4] net: ethtool: Refactor identical get_ts_info implementations.
Date:   Fri,  3 Mar 2023 17:42:38 +0100
Message-Id: <20230303164248.499286-2-kory.maincent@bootlin.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230303164248.499286-1-kory.maincent@bootlin.com>
References: <20230303164248.499286-1-kory.maincent@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Richard Cochran <richardcochran@gmail.com>

The vlan, macvlan and the bonding drivers call their "real" device driver
in order to report the time stamping capabilities.  Provide a core
ethtool helper function to avoid copy/paste in the stack.

Signed-off-by: Richard Cochran <richardcochran@gmail.com>
Signed-off-by: Kory Maincent <kory.maincent@bootlin.com>
---

Notes:
    Changes in V2:
    - Refactor also macvlan driver

 drivers/net/bonding/bond_main.c | 14 ++------------
 drivers/net/macvlan.c           | 14 +-------------
 include/linux/ethtool.h         |  8 ++++++++
 net/8021q/vlan_dev.c            | 15 +--------------
 net/ethtool/common.c            |  6 ++++++
 5 files changed, 18 insertions(+), 39 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index fce9301c8ebb..11e025074594 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -5683,9 +5683,7 @@ static int bond_ethtool_get_ts_info(struct net_device *bond_dev,
 				    struct ethtool_ts_info *info)
 {
 	struct bonding *bond = netdev_priv(bond_dev);
-	const struct ethtool_ops *ops;
 	struct net_device *real_dev;
-	struct phy_device *phydev;
 	int ret = 0;
 
 	rcu_read_lock();
@@ -5694,16 +5692,8 @@ static int bond_ethtool_get_ts_info(struct net_device *bond_dev,
 	rcu_read_unlock();
 
 	if (real_dev) {
-		ops = real_dev->ethtool_ops;
-		phydev = real_dev->phydev;
-
-		if (phy_has_tsinfo(phydev)) {
-			ret = phy_ts_info(phydev, info);
-			goto out;
-		} else if (ops->get_ts_info) {
-			ret = ops->get_ts_info(real_dev, info);
-			goto out;
-		}
+		ret = ethtool_get_ts_info_by_layer(real_dev, info);
+		goto out;
 	}
 
 	info->so_timestamping = SOF_TIMESTAMPING_RX_SOFTWARE |
diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
index b8cc55b2d721..7e923d27196f 100644
--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -1059,20 +1059,8 @@ static int macvlan_ethtool_get_ts_info(struct net_device *dev,
 				       struct ethtool_ts_info *info)
 {
 	struct net_device *real_dev = macvlan_dev_real_dev(dev);
-	const struct ethtool_ops *ops = real_dev->ethtool_ops;
-	struct phy_device *phydev = real_dev->phydev;
 
-	if (phy_has_tsinfo(phydev)) {
-		return phy_ts_info(phydev, info);
-	} else if (ops->get_ts_info) {
-		return ops->get_ts_info(real_dev, info);
-	} else {
-		info->so_timestamping = SOF_TIMESTAMPING_RX_SOFTWARE |
-			SOF_TIMESTAMPING_SOFTWARE;
-		info->phc_index = -1;
-	}
-
-	return 0;
+	return ethtool_get_ts_info_by_layer(real_dev, info);
 }
 
 static netdev_features_t macvlan_fix_features(struct net_device *dev,
diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h
index 99dc7bfbcd3c..fa20abec4b93 100644
--- a/include/linux/ethtool.h
+++ b/include/linux/ethtool.h
@@ -834,6 +834,14 @@ ethtool_params_from_link_mode(struct ethtool_link_ksettings *link_ksettings,
  */
 int ethtool_get_phc_vclocks(struct net_device *dev, int **vclock_index);
 
+/**
+ * ethtool_get_ts_info_by_layer - Obtains time stamping capabilities from the MAC or PHY layer.
+ * @dev: pointer to net_device structure
+ * @info: buffer to hold the result
+ * Returns zero on sauces, non-zero otherwise.
+ */
+int ethtool_get_ts_info_by_layer(struct net_device *dev, struct ethtool_ts_info *info);
+
 /**
  * ethtool_sprintf - Write formatted string to ethtool string data
  * @data: Pointer to start of string to update
diff --git a/net/8021q/vlan_dev.c b/net/8021q/vlan_dev.c
index e1bb41a443c4..3e475feae543 100644
--- a/net/8021q/vlan_dev.c
+++ b/net/8021q/vlan_dev.c
@@ -683,20 +683,7 @@ static int vlan_ethtool_get_ts_info(struct net_device *dev,
 				    struct ethtool_ts_info *info)
 {
 	const struct vlan_dev_priv *vlan = vlan_dev_priv(dev);
-	const struct ethtool_ops *ops = vlan->real_dev->ethtool_ops;
-	struct phy_device *phydev = vlan->real_dev->phydev;
-
-	if (phy_has_tsinfo(phydev)) {
-		return phy_ts_info(phydev, info);
-	} else if (ops->get_ts_info) {
-		return ops->get_ts_info(vlan->real_dev, info);
-	} else {
-		info->so_timestamping = SOF_TIMESTAMPING_RX_SOFTWARE |
-			SOF_TIMESTAMPING_SOFTWARE;
-		info->phc_index = -1;
-	}
-
-	return 0;
+	return ethtool_get_ts_info_by_layer(vlan->real_dev, info);
 }
 
 static void vlan_dev_get_stats64(struct net_device *dev,
diff --git a/net/ethtool/common.c b/net/ethtool/common.c
index 566adf85e658..64a7e05cf2c2 100644
--- a/net/ethtool/common.c
+++ b/net/ethtool/common.c
@@ -572,6 +572,12 @@ int ethtool_get_phc_vclocks(struct net_device *dev, int **vclock_index)
 }
 EXPORT_SYMBOL(ethtool_get_phc_vclocks);
 
+int ethtool_get_ts_info_by_layer(struct net_device *dev, struct ethtool_ts_info *info)
+{
+	return __ethtool_get_ts_info(dev, info);
+}
+EXPORT_SYMBOL(ethtool_get_ts_info_by_layer);
+
 const struct ethtool_phy_ops *ethtool_phy_ops;
 
 void ethtool_set_ethtool_phy_ops(const struct ethtool_phy_ops *ops)
-- 
2.25.1

