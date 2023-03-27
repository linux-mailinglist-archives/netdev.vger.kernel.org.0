Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F9E56CA783
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 16:25:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232460AbjC0OZB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 10:25:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232693AbjC0OYD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 10:24:03 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FB477EC1
        for <netdev@vger.kernel.org>; Mon, 27 Mar 2023 07:22:29 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1pgnja-0008Hl-Ky; Mon, 27 Mar 2023 16:22:06 +0200
Received: from [2a0a:edc0:0:1101:1d::ac] (helo=dude04.red.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1pgnjY-0076IQ-J2; Mon, 27 Mar 2023 16:22:04 +0200
Received: from ore by dude04.red.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1pgnjW-00FkjB-SC; Mon, 27 Mar 2023 16:22:02 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Wei Fang <wei.fang@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Shenwei Wang <shenwei.wang@nxp.com>,
        Clark Wang <xiaoning.wang@nxp.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Amit Cohen <amcohen@nvidia.com>, Gal Pressman <gal@nvidia.com>,
        Alexandru Tachici <alexandru.tachici@analog.com>,
        Piergiorgio Beruto <piergiorgio.beruto@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next v2 4/8] ethtool: eee: Rework get/set handler for SmartEEE-capable PHYs with non-EEE MACs
Date:   Mon, 27 Mar 2023 16:21:58 +0200
Message-Id: <20230327142202.3754446-5-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230327142202.3754446-1-o.rempel@pengutronix.de>
References: <20230327142202.3754446-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-2.3 required=5.0 tests=RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch reworks the ethtool handler to allow accessing set/get EEE
properties of SmartEEE-capable PHYs, even when the associated MAC does
not provide EEE support. Previously, the handler would not allow
configuration or management of EEE properties for such PHYs, limiting
their functionality and energy efficiency.

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 net/ethtool/common.c | 38 ++++++++++++++++++++++++++++++++++++++
 net/ethtool/common.h |  2 ++
 net/ethtool/eee.c    | 17 +++++++++++------
 3 files changed, 51 insertions(+), 6 deletions(-)

diff --git a/net/ethtool/common.c b/net/ethtool/common.c
index 5fb19050991e..267fd3600f15 100644
--- a/net/ethtool/common.c
+++ b/net/ethtool/common.c
@@ -661,6 +661,44 @@ int ethtool_get_phc_vclocks(struct net_device *dev, int **vclock_index)
 }
 EXPORT_SYMBOL(ethtool_get_phc_vclocks);
 
+int __ethtool_get_eee(struct net_device *dev, struct ethtool_eee *eee)
+{
+	const struct ethtool_ops *ops = dev->ethtool_ops;
+	struct phy_device *phydev = dev->phydev;
+	int ret;
+
+	if (ops->get_eee)
+		ret = ops->get_eee(dev, eee);
+	else
+		ret = -EOPNOTSUPP;
+
+	if (ret == -EOPNOTSUPP) {
+		if (phydev && phydev->is_smart_eee_phy)
+			ret = phy_ethtool_get_eee(phydev, eee);
+	}
+
+	return ret;
+}
+
+int __ethtool_set_eee(struct net_device *dev, struct ethtool_eee *eee)
+{
+	const struct ethtool_ops *ops = dev->ethtool_ops;
+	struct phy_device *phydev = dev->phydev;
+	int ret;
+
+	if (ops->set_eee)
+		ret = ops->set_eee(dev, eee);
+	else
+		ret = -EOPNOTSUPP;
+
+	if (ret == -EOPNOTSUPP) {
+		if (phydev && phydev->is_smart_eee_phy)
+			ret = phy_ethtool_set_eee(phydev, eee);
+	}
+
+	return ret;
+}
+
 const struct ethtool_phy_ops *ethtool_phy_ops;
 
 void ethtool_set_ethtool_phy_ops(const struct ethtool_phy_ops *ops)
diff --git a/net/ethtool/common.h b/net/ethtool/common.h
index 28b8aaaf9bcb..59c1906ec800 100644
--- a/net/ethtool/common.h
+++ b/net/ethtool/common.h
@@ -45,6 +45,8 @@ bool convert_legacy_settings_to_link_ksettings(
 int ethtool_get_max_rxfh_channel(struct net_device *dev, u32 *max);
 int ethtool_get_max_rxnfc_channel(struct net_device *dev, u64 *max);
 int __ethtool_get_ts_info(struct net_device *dev, struct ethtool_ts_info *info);
+int __ethtool_get_eee(struct net_device *dev, struct ethtool_eee *eee);
+int __ethtool_set_eee(struct net_device *dev, struct ethtool_eee *eee);
 
 extern const struct ethtool_phy_ops *ethtool_phy_ops;
 extern const struct ethtool_pse_ops *ethtool_pse_ops;
diff --git a/net/ethtool/eee.c b/net/ethtool/eee.c
index 42104bcb0e47..43b866184297 100644
--- a/net/ethtool/eee.c
+++ b/net/ethtool/eee.c
@@ -1,5 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0-only
 
+#include <linux/phy.h>
+
 #include "netlink.h"
 #include "common.h"
 #include "bitset.h"
@@ -32,12 +34,10 @@ static int eee_prepare_data(const struct ethnl_req_info *req_base,
 	struct net_device *dev = reply_base->dev;
 	int ret;
 
-	if (!dev->ethtool_ops->get_eee)
-		return -EOPNOTSUPP;
 	ret = ethnl_ops_begin(dev);
 	if (ret < 0)
 		return ret;
-	ret = dev->ethtool_ops->get_eee(dev, &data->eee);
+	ret =  __ethtool_get_eee(dev, &data->eee);
 	ethnl_ops_complete(dev);
 
 	return ret;
@@ -123,8 +123,13 @@ static int
 ethnl_set_eee_validate(struct ethnl_req_info *req_info, struct genl_info *info)
 {
 	const struct ethtool_ops *ops = req_info->dev->ethtool_ops;
+	struct net_device *dev = req_info->dev;
+
+	if ((ops->get_eee && ops->set_eee) ||
+	    (dev->phydev && dev->phydev->is_smart_eee_phy))
+		return 1;
 
-	return ops->get_eee && ops->set_eee ? 1 : -EOPNOTSUPP;
+	return -EOPNOTSUPP;
 }
 
 static int
@@ -136,7 +141,7 @@ ethnl_set_eee(struct ethnl_req_info *req_info, struct genl_info *info)
 	bool mod = false;
 	int ret;
 
-	ret = dev->ethtool_ops->get_eee(dev, &eee);
+	ret = __ethtool_get_eee(dev, &eee);
 	if (ret < 0)
 		return ret;
 
@@ -153,7 +158,7 @@ ethnl_set_eee(struct ethnl_req_info *req_info, struct genl_info *info)
 	if (!mod)
 		return 0;
 
-	ret = dev->ethtool_ops->set_eee(dev, &eee);
+	ret = __ethtool_set_eee(dev, &eee);
 	return ret < 0 ? ret : 1;
 }
 
-- 
2.30.2

