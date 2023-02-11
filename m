Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0943692F2A
	for <lists+netdev@lfdr.de>; Sat, 11 Feb 2023 08:41:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229740AbjBKHll (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Feb 2023 02:41:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229761AbjBKHlf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Feb 2023 02:41:35 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9975B6E561
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 23:41:32 -0800 (PST)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1pQkVc-0003zX-Rt; Sat, 11 Feb 2023 08:41:21 +0100
Received: from [2a0a:edc0:0:1101:1d::ac] (helo=dude04.red.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1pQkVX-004ALc-6G; Sat, 11 Feb 2023 08:41:16 +0100
Received: from ore by dude04.red.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1pQkVX-00Bft4-4N; Sat, 11 Feb 2023 08:41:15 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Wei Fang <wei.fang@nxp.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Arun.Ramadoss@microchip.com, intel-wired-lan@lists.osuosl.org
Subject: [PATCH net-next v8 6/9] net: phy: c22: migrate to genphy_c45_write_eee_adv()
Date:   Sat, 11 Feb 2023 08:41:10 +0100
Message-Id: <20230211074113.2782508-7-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230211074113.2782508-1-o.rempel@pengutronix.de>
References: <20230211074113.2782508-1-o.rempel@pengutronix.de>
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

Migrate from genphy_config_eee_advert() to genphy_c45_write_eee_adv().

It should work as before except write operation to the EEE adv registers
will be done only if some EEE abilities was detected.

If some driver will have a regression, related driver should provide own
.get_features callback. See micrel.c:ksz9477_get_features() as example.

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/phy/phy_device.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 66a4e62009bb..8d927c5e3bf8 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -2231,7 +2231,10 @@ int __genphy_config_aneg(struct phy_device *phydev, bool changed)
 {
 	int err;
 
-	if (genphy_config_eee_advert(phydev))
+	err = genphy_c45_write_eee_adv(phydev, phydev->supported_eee);
+	if (err < 0)
+		return err;
+	else if (err)
 		changed = true;
 
 	err = genphy_setup_master_slave(phydev);
@@ -2653,6 +2656,11 @@ int genphy_read_abilities(struct phy_device *phydev)
 				 phydev->supported, val & ESTATUS_1000_XFULL);
 	}
 
+	/* This is optional functionality. If not supported, we may get an error
+	 * which should be ignored.
+	 */
+	genphy_c45_read_eee_abilities(phydev);
+
 	return 0;
 }
 EXPORT_SYMBOL(genphy_read_abilities);
-- 
2.30.2

