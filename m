Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84B3E364236
	for <lists+netdev@lfdr.de>; Mon, 19 Apr 2021 15:03:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239339AbhDSNCG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 09:02:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239293AbhDSNBy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Apr 2021 09:01:54 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFAE4C061760
        for <netdev@vger.kernel.org>; Mon, 19 Apr 2021 06:01:24 -0700 (PDT)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1lYTWa-0003ti-VR; Mon, 19 Apr 2021 15:01:12 +0200
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1lYTWX-0001mH-2Q; Mon, 19 Apr 2021 15:01:09 +0200
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
Subject: [PATCH net-next v3 4/6] net: fec: make use of generic NET_SELFTESTS library
Date:   Mon, 19 Apr 2021 15:01:04 +0200
Message-Id: <20210419130106.6707-5-o.rempel@pengutronix.de>
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

With this patch FEC on iMX will able to run generic net selftests

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 drivers/net/ethernet/freescale/Kconfig    | 1 +
 drivers/net/ethernet/freescale/fec_main.c | 7 +++++++
 2 files changed, 8 insertions(+)

diff --git a/drivers/net/ethernet/freescale/Kconfig b/drivers/net/ethernet/freescale/Kconfig
index 3f9175bdce77..3d937b4650b2 100644
--- a/drivers/net/ethernet/freescale/Kconfig
+++ b/drivers/net/ethernet/freescale/Kconfig
@@ -26,6 +26,7 @@ config FEC
 		   ARCH_MXC || SOC_IMX28 || COMPILE_TEST)
 	default ARCH_MXC || SOC_IMX28 if ARM
 	select CRC32
+	select NET_SELFTESTS
 	select PHYLIB
 	imply PTP_1588_CLOCK
 	help
diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 70aea9c274fe..d51b2eb1de71 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -38,6 +38,7 @@
 #include <linux/in.h>
 #include <linux/ip.h>
 #include <net/ip.h>
+#include <net/selftests.h>
 #include <net/tso.h>
 #include <linux/tcp.h>
 #include <linux/udp.h>
@@ -2481,6 +2482,9 @@ static void fec_enet_get_strings(struct net_device *netdev,
 			memcpy(data + i * ETH_GSTRING_LEN,
 				fec_stats[i].name, ETH_GSTRING_LEN);
 		break;
+	case ETH_SS_TEST:
+		net_selftest_get_strings(data);
+		break;
 	}
 }
 
@@ -2489,6 +2493,8 @@ static int fec_enet_get_sset_count(struct net_device *dev, int sset)
 	switch (sset) {
 	case ETH_SS_STATS:
 		return ARRAY_SIZE(fec_stats);
+	case ETH_SS_TEST:
+		return net_selftest_get_count();
 	default:
 		return -EOPNOTSUPP;
 	}
@@ -2740,6 +2746,7 @@ static const struct ethtool_ops fec_enet_ethtool_ops = {
 	.set_wol		= fec_enet_set_wol,
 	.get_link_ksettings	= phy_ethtool_get_link_ksettings,
 	.set_link_ksettings	= phy_ethtool_set_link_ksettings,
+	.self_test		= net_selftest,
 };
 
 static int fec_enet_ioctl(struct net_device *ndev, struct ifreq *rq, int cmd)
-- 
2.29.2

