Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1187695DEB
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 10:03:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230193AbjBNJDh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 04:03:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231697AbjBNJDc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 04:03:32 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B14D0CDCD
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 01:03:30 -0800 (PST)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1pRrDa-0004UG-JN; Tue, 14 Feb 2023 10:03:18 +0100
Received: from [2a0a:edc0:0:1101:1d::ac] (helo=dude04.red.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1pRrDY-004qDm-G1; Tue, 14 Feb 2023 10:03:17 +0100
Received: from ore by dude04.red.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1pRrDX-008V6W-Js; Tue, 14 Feb 2023 10:03:15 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Wei Fang <wei.fang@nxp.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Shenwei Wang <shenwei.wang@nxp.com>,
        Clark Wang <xiaoning.wang@nxp.com>,
        NXP Linux Team <linux-imx@nxp.com>
Subject: [PATCH net-next v1 7/7] net: fec: add support for PHYs with SmartEEE support
Date:   Tue, 14 Feb 2023 10:03:14 +0100
Message-Id: <20230214090314.2026067-8-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230214090314.2026067-1-o.rempel@pengutronix.de>
References: <20230214090314.2026067-1-o.rempel@pengutronix.de>
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
index c73e25f8995e..00f3703db69d 100644
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

