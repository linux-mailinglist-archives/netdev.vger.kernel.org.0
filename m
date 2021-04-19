Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 018DC364233
	for <lists+netdev@lfdr.de>; Mon, 19 Apr 2021 15:03:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239319AbhDSNCA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 09:02:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238408AbhDSNBt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Apr 2021 09:01:49 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25CAAC061760
        for <netdev@vger.kernel.org>; Mon, 19 Apr 2021 06:01:17 -0700 (PDT)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1lYTWa-0003tj-VR; Mon, 19 Apr 2021 15:01:12 +0200
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1lYTWX-0001mQ-3Q; Mon, 19 Apr 2021 15:01:09 +0200
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
Subject: [PATCH net-next v3 5/6] net: ag71xx: make use of generic NET_SELFTESTS library
Date:   Mon, 19 Apr 2021 15:01:05 +0200
Message-Id: <20210419130106.6707-6-o.rempel@pengutronix.de>
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

With this patch the ag71xx on Atheros AR9331 will able to run generic net
selftests.

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 drivers/net/ethernet/atheros/Kconfig  |  1 +
 drivers/net/ethernet/atheros/ag71xx.c | 20 ++++++++++++++++----
 2 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/atheros/Kconfig b/drivers/net/ethernet/atheros/Kconfig
index fb803bf92ded..6842b74b0696 100644
--- a/drivers/net/ethernet/atheros/Kconfig
+++ b/drivers/net/ethernet/atheros/Kconfig
@@ -20,6 +20,7 @@ if NET_VENDOR_ATHEROS
 config AG71XX
 	tristate "Atheros AR7XXX/AR9XXX built-in ethernet mac support"
 	depends on ATH79
+	select NET_SELFTESTS
 	select PHYLINK
 	help
 	  If you wish to compile a kernel for AR7XXX/91XXX and enable
diff --git a/drivers/net/ethernet/atheros/ag71xx.c b/drivers/net/ethernet/atheros/ag71xx.c
index 7352f98123c7..eb067ce978ae 100644
--- a/drivers/net/ethernet/atheros/ag71xx.c
+++ b/drivers/net/ethernet/atheros/ag71xx.c
@@ -37,6 +37,7 @@
 #include <linux/reset.h>
 #include <linux/clk.h>
 #include <linux/io.h>
+#include <net/selftests.h>
 
 /* For our NAPI weight bigger does *NOT* mean better - it means more
  * D-cache misses and lots more wasted cycles than we'll ever
@@ -497,12 +498,17 @@ static int ag71xx_ethtool_set_pauseparam(struct net_device *ndev,
 static void ag71xx_ethtool_get_strings(struct net_device *netdev, u32 sset,
 				       u8 *data)
 {
-	if (sset == ETH_SS_STATS) {
-		int i;
+	int i;
 
+	switch (sset) {
+	case ETH_SS_STATS:
 		for (i = 0; i < ARRAY_SIZE(ag71xx_statistics); i++)
 			memcpy(data + i * ETH_GSTRING_LEN,
 			       ag71xx_statistics[i].name, ETH_GSTRING_LEN);
+		break;
+	case ETH_SS_TEST:
+		net_selftest_get_strings(data);
+		break;
 	}
 }
 
@@ -519,9 +525,14 @@ static void ag71xx_ethtool_get_stats(struct net_device *ndev,
 
 static int ag71xx_ethtool_get_sset_count(struct net_device *ndev, int sset)
 {
-	if (sset == ETH_SS_STATS)
+	switch (sset) {
+	case ETH_SS_STATS:
 		return ARRAY_SIZE(ag71xx_statistics);
-	return -EOPNOTSUPP;
+	case ETH_SS_TEST:
+		return net_selftest_get_count();
+	default:
+		return -EOPNOTSUPP;
+	}
 }
 
 static const struct ethtool_ops ag71xx_ethtool_ops = {
@@ -536,6 +547,7 @@ static const struct ethtool_ops ag71xx_ethtool_ops = {
 	.get_strings			= ag71xx_ethtool_get_strings,
 	.get_ethtool_stats		= ag71xx_ethtool_get_stats,
 	.get_sset_count			= ag71xx_ethtool_get_sset_count,
+	.self_test			= net_selftest,
 };
 
 static int ag71xx_mdio_wait_busy(struct ag71xx *ag)
-- 
2.29.2

