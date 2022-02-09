Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F12DD4AF205
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 13:43:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233578AbiBIMnG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 07:43:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233568AbiBIMnF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 07:43:05 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70135C05CB86
        for <netdev@vger.kernel.org>; Wed,  9 Feb 2022 04:43:06 -0800 (PST)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1nHmJG-0008KF-It; Wed, 09 Feb 2022 13:42:58 +0100
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1nHmJF-00CfQI-Bi; Wed, 09 Feb 2022 13:42:57 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Steve Glendinning <steve.glendinning@shawell.net>,
        UNGLinuxDriver@microchip.com
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next v1] net: usb: smsc95xx: add generic selftest support
Date:   Wed,  9 Feb 2022 13:42:55 +0100
Message-Id: <20220209124256.3019116-1-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Provide generic selftest support. Tested with LAN9500 and LAN9512.

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 drivers/net/usb/Kconfig    |  1 +
 drivers/net/usb/smsc95xx.c | 25 +++++++++++++++++++++++++
 2 files changed, 26 insertions(+)

diff --git a/drivers/net/usb/Kconfig b/drivers/net/usb/Kconfig
index b554054a7560..e62fc4f2aee0 100644
--- a/drivers/net/usb/Kconfig
+++ b/drivers/net/usb/Kconfig
@@ -358,6 +358,7 @@ config USB_NET_SMSC95XX
 	select BITREVERSE
 	select CRC16
 	select CRC32
+	imply NET_SELFTESTS
 	help
 	  This option adds support for SMSC LAN95XX based USB 2.0
 	  10/100 Ethernet adapters.
diff --git a/drivers/net/usb/smsc95xx.c b/drivers/net/usb/smsc95xx.c
index bc1e3dd67c04..5567220e9d16 100644
--- a/drivers/net/usb/smsc95xx.c
+++ b/drivers/net/usb/smsc95xx.c
@@ -20,6 +20,8 @@
 #include <linux/of_net.h>
 #include <linux/mdio.h>
 #include <linux/phy.h>
+#include <net/selftests.h>
+
 #include "smsc95xx.h"
 
 #define SMSC_CHIPNAME			"smsc95xx"
@@ -727,6 +729,26 @@ static u32 smsc95xx_get_link(struct net_device *net)
 	return net->phydev->link;
 }
 
+static void smsc95xx_ethtool_get_strings(struct net_device *netdev, u32 sset,
+					u8 *data)
+{
+	switch (sset) {
+	case ETH_SS_TEST:
+		net_selftest_get_strings(data);
+		break;
+	}
+}
+
+static int smsc95xx_ethtool_get_sset_count(struct net_device *ndev, int sset)
+{
+	switch (sset) {
+	case ETH_SS_TEST:
+		return net_selftest_get_count();
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
 static const struct ethtool_ops smsc95xx_ethtool_ops = {
 	.get_link	= smsc95xx_get_link,
 	.nway_reset	= phy_ethtool_nway_reset,
@@ -743,6 +765,9 @@ static const struct ethtool_ops smsc95xx_ethtool_ops = {
 	.get_link_ksettings	= phy_ethtool_get_link_ksettings,
 	.set_link_ksettings	= phy_ethtool_set_link_ksettings,
 	.get_ts_info	= ethtool_op_get_ts_info,
+	.self_test	= net_selftest,
+	.get_strings	= smsc95xx_ethtool_get_strings,
+	.get_sset_count	= smsc95xx_ethtool_get_sset_count,
 };
 
 static int smsc95xx_ioctl(struct net_device *netdev, struct ifreq *rq, int cmd)
-- 
2.30.2

