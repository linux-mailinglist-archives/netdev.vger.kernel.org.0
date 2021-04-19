Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 987A036422D
	for <lists+netdev@lfdr.de>; Mon, 19 Apr 2021 15:01:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239283AbhDSNBx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 09:01:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231942AbhDSNBt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Apr 2021 09:01:49 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25C2BC06174A
        for <netdev@vger.kernel.org>; Mon, 19 Apr 2021 06:01:17 -0700 (PDT)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1lYTWa-0003tk-VR; Mon, 19 Apr 2021 15:01:12 +0200
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1lYTWX-0001ma-4d; Mon, 19 Apr 2021 15:01:09 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Fugang Duan <fugang.duan@nxp.com>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>, kernel@pengutronix.de,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-imx@nxp.com,
        Fabio Estevam <festevam@gmail.com>,
        David Jander <david@protonic.nl>,
        Russell King <linux@armlinux.org.uk>,
        Philippe Schenker <philippe.schenker@toradex.com>
Subject: [PATCH net-next v3 6/6] net: dsa: enable selftest support for all switches by default
Date:   Mon, 19 Apr 2021 15:01:06 +0200
Message-Id: <20210419130106.6707-7-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210419130106.6707-1-o.rempel@pengutronix.de>
References: <20210419130106.6707-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Most of generic selftest should be able to work with probably all ethernet
controllers. The DSA switches are not exception, so enable it by default at
least for DSA.

This patch was tested with SJA1105 and AR9331.

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 include/net/dsa.h |  2 ++
 net/dsa/Kconfig   |  1 +
 net/dsa/slave.c   | 21 +++++++++++++++++++++
 3 files changed, 24 insertions(+)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 57b2c49f72f4..b4f89522b545 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -577,6 +577,8 @@ struct dsa_switch_ops {
 					 int port, uint64_t *data);
 	void	(*get_stats64)(struct dsa_switch *ds, int port,
 				   struct rtnl_link_stats64 *s);
+	void	(*self_test)(struct dsa_switch *ds, int port,
+			     struct ethtool_test *etest, u64 *data);
 
 	/*
 	 * ethtool Wake-on-LAN
diff --git a/net/dsa/Kconfig b/net/dsa/Kconfig
index 8746b07668ae..cbc2bd643ab2 100644
--- a/net/dsa/Kconfig
+++ b/net/dsa/Kconfig
@@ -9,6 +9,7 @@ menuconfig NET_DSA
 	select NET_SWITCHDEV
 	select PHYLINK
 	select NET_DEVLINK
+	select NET_SELFTESTS
 	help
 	  Say Y if you want to enable support for the hardware switches supported
 	  by the Distributed Switch Architecture.
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 995e0e16f295..e282b422f733 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -15,6 +15,7 @@
 #include <linux/mdio.h>
 #include <net/rtnetlink.h>
 #include <net/pkt_cls.h>
+#include <net/selftests.h>
 #include <net/tc_act/tc_mirred.h>
 #include <linux/if_bridge.h>
 #include <linux/if_hsr.h>
@@ -748,7 +749,10 @@ static void dsa_slave_get_strings(struct net_device *dev,
 		if (ds->ops->get_strings)
 			ds->ops->get_strings(ds, dp->index, stringset,
 					     data + 4 * len);
+	} else if (stringset ==  ETH_SS_TEST) {
+		net_selftest_get_strings(data);
 	}
+
 }
 
 static void dsa_slave_get_ethtool_stats(struct net_device *dev,
@@ -794,11 +798,27 @@ static int dsa_slave_get_sset_count(struct net_device *dev, int sset)
 			count += ds->ops->get_sset_count(ds, dp->index, sset);
 
 		return count;
+	} else if (sset ==  ETH_SS_TEST) {
+		return net_selftest_get_count();
 	}
 
 	return -EOPNOTSUPP;
 }
 
+static void dsa_slave_net_selftest(struct net_device *ndev,
+				   struct ethtool_test *etest, u64 *buf)
+{
+	struct dsa_port *dp = dsa_slave_to_port(ndev);
+	struct dsa_switch *ds = dp->ds;
+
+	if (ds->ops->self_test) {
+		ds->ops->self_test(ds, dp->index, etest, buf);
+		return;
+	}
+
+	net_selftest(ndev, etest, buf);
+}
+
 static void dsa_slave_get_wol(struct net_device *dev, struct ethtool_wolinfo *w)
 {
 	struct dsa_port *dp = dsa_slave_to_port(dev);
@@ -1630,6 +1650,7 @@ static const struct ethtool_ops dsa_slave_ethtool_ops = {
 	.get_rxnfc		= dsa_slave_get_rxnfc,
 	.set_rxnfc		= dsa_slave_set_rxnfc,
 	.get_ts_info		= dsa_slave_get_ts_info,
+	.self_test		= dsa_slave_net_selftest,
 };
 
 /* legacy way, bypassing the bridge *****************************************/
-- 
2.29.2

