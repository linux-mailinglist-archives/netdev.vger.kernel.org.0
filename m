Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC1DB3D1F12
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 09:34:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230501AbhGVGx7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 02:53:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230137AbhGVGx6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Jul 2021 02:53:58 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1703C061575
        for <netdev@vger.kernel.org>; Thu, 22 Jul 2021 00:34:33 -0700 (PDT)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1m6TDx-0004Qa-OG; Thu, 22 Jul 2021 09:34:29 +0200
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1m6TDw-0006ut-QU; Thu, 22 Jul 2021 09:34:28 +0200
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
Subject: [PATCH net-next v1 1/1] net: selftests: add MTU test
Date:   Thu, 22 Jul 2021 09:34:27 +0200
Message-Id: <20210722073427.26537-1-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Test if we actually can send/receive packets with MTU size. This kind of
issue was detected on ASIX HW with bogus EEPROM.

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 net/core/selftests.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/net/core/selftests.c b/net/core/selftests.c
index ba7b0171974c..9077fa969892 100644
--- a/net/core/selftests.c
+++ b/net/core/selftests.c
@@ -318,6 +318,15 @@ static int net_test_phy_loopback_udp(struct net_device *ndev)
 	return __net_test_loopback(ndev, &attr);
 }
 
+static int net_test_phy_loopback_udp_mtu(struct net_device *ndev)
+{
+	struct net_packet_attrs attr = { };
+
+	attr.dst = ndev->dev_addr;
+	attr.max_size = ndev->mtu;
+	return __net_test_loopback(ndev, &attr);
+}
+
 static int net_test_phy_loopback_tcp(struct net_device *ndev)
 {
 	struct net_packet_attrs attr = { };
@@ -344,6 +353,9 @@ static const struct net_test {
 	}, {
 		.name = "PHY internal loopback, UDP    ",
 		.fn = net_test_phy_loopback_udp,
+	}, {
+		.name = "PHY internal loopback, MTU    ",
+		.fn = net_test_phy_loopback_udp_mtu,
 	}, {
 		.name = "PHY internal loopback, TCP    ",
 		.fn = net_test_phy_loopback_tcp,
-- 
2.30.2

