Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 040486806EA
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 09:07:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235727AbjA3IHl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 03:07:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235616AbjA3IHd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 03:07:33 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B11DE298F9
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 00:07:30 -0800 (PST)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1pMPCB-0003fD-2h; Mon, 30 Jan 2023 09:07:19 +0100
Received: from [2a0a:edc0:0:1101:1d::ac] (helo=dude04.red.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1pMPCA-001PwJ-TS; Mon, 30 Jan 2023 09:07:18 +0100
Received: from ore by dude04.red.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1pMPC7-000aLB-PN; Mon, 30 Jan 2023 09:07:15 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Arun.Ramadoss@microchip.com
Subject: [PATCH net-next v3 15/15] net: fec: add support for PHYs with SmartEEE support
Date:   Mon, 30 Jan 2023 09:07:14 +0100
Message-Id: <20230130080714.139492-16-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230130080714.139492-1-o.rempel@pengutronix.de>
References: <20230130080714.139492-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ethernet controller in i.MX6*/i.MX7* series do not provide EEE support.
But this chips are used sometimes in combinations with SmartEEE capable
PHYs.
So, instead of aborting get/set_eee access on MACs without EEE support,
ask PHY if it is able to do the EEE job by using SmartEEE.

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 drivers/net/ethernet/freescale/fec_main.c | 22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index e6238e53940d..25a2a9d860de 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -3102,8 +3102,15 @@ fec_enet_get_eee(struct net_device *ndev, struct ethtool_eee *edata)
 	struct fec_enet_private *fep = netdev_priv(ndev);
 	struct ethtool_eee *p = &fep->eee;
 
-	if (!(fep->quirks & FEC_QUIRK_HAS_EEE))
-		return -EOPNOTSUPP;
+	if (!(fep->quirks & FEC_QUIRK_HAS_EEE)) {
+		if (!netif_running(ndev))
+			return -ENETDOWN;
+
+		if (!phy_has_smarteee(ndev->phydev))
+			return -EOPNOTSUPP;
+
+		return phy_ethtool_get_eee(ndev->phydev, edata);
+	}
 
 	if (!netif_running(ndev))
 		return -ENETDOWN;
@@ -3123,8 +3130,15 @@ fec_enet_set_eee(struct net_device *ndev, struct ethtool_eee *edata)
 	struct ethtool_eee *p = &fep->eee;
 	int ret = 0;
 
-	if (!(fep->quirks & FEC_QUIRK_HAS_EEE))
-		return -EOPNOTSUPP;
+	if (!(fep->quirks & FEC_QUIRK_HAS_EEE)) {
+		if (!netif_running(ndev))
+			return -ENETDOWN;
+
+		if (!phy_has_smarteee(ndev->phydev))
+			return -EOPNOTSUPP;
+
+		return phy_ethtool_set_eee(ndev->phydev, edata);
+	}
 
 	if (!netif_running(ndev))
 		return -ENETDOWN;
-- 
2.30.2

