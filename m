Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6A0A57F0C4
	for <lists+netdev@lfdr.de>; Sat, 23 Jul 2022 19:47:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238638AbiGWRrb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Jul 2022 13:47:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238613AbiGWRra (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Jul 2022 13:47:30 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49FF5193FC
        for <netdev@vger.kernel.org>; Sat, 23 Jul 2022 10:47:29 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1oFJDf-0006Ng-4x; Sat, 23 Jul 2022 19:47:15 +0200
Received: from [2a0a:edc0:0:1101:1d::ac] (helo=dude04.red.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1oFJDd-002l2h-Ti; Sat, 23 Jul 2022 19:47:13 +0200
Received: from ore by dude04.red.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1oFJDd-006SWu-9g; Sat, 23 Jul 2022 19:47:13 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Lukas Wunner <lukas@wunner.de>,
        Russell King <linux@armlinux.org.uk>
Subject: [PATCH net-next v1 2/2] net: asix: ax88772: add ethtool pause configuration
Date:   Sat, 23 Jul 2022 19:47:11 +0200
Message-Id: <20220723174711.1539574-2-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220723174711.1539574-1-o.rempel@pengutronix.de>
References: <20220723174711.1539574-1-o.rempel@pengutronix.de>
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

Add phylink based ethtool pause configuration

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 drivers/net/usb/asix_devices.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/net/usb/asix_devices.c b/drivers/net/usb/asix_devices.c
index 3f93bc46a7eb..4ba4f4251300 100644
--- a/drivers/net/usb/asix_devices.c
+++ b/drivers/net/usb/asix_devices.c
@@ -303,6 +303,24 @@ static int ax88772_ethtool_get_sset_count(struct net_device *ndev, int sset)
 	}
 }
 
+static void ax88772_ethtool_get_pauseparam(struct net_device *ndev,
+					  struct ethtool_pauseparam *pause)
+{
+	struct usbnet *dev = netdev_priv(ndev);
+	struct asix_common_private *priv = dev->driver_priv;
+
+	phylink_ethtool_get_pauseparam(priv->phylink, pause);
+}
+
+static int ax88772_ethtool_set_pauseparam(struct net_device *ndev,
+					 struct ethtool_pauseparam *pause)
+{
+	struct usbnet *dev = netdev_priv(ndev);
+	struct asix_common_private *priv = dev->driver_priv;
+
+	return phylink_ethtool_set_pauseparam(priv->phylink, pause);
+}
+
 static const struct ethtool_ops ax88772_ethtool_ops = {
 	.get_drvinfo		= asix_get_drvinfo,
 	.get_link		= usbnet_get_link,
@@ -319,6 +337,8 @@ static const struct ethtool_ops ax88772_ethtool_ops = {
 	.self_test		= net_selftest,
 	.get_strings		= ax88772_ethtool_get_strings,
 	.get_sset_count		= ax88772_ethtool_get_sset_count,
+	.get_pauseparam		= ax88772_ethtool_get_pauseparam,
+	.set_pauseparam		= ax88772_ethtool_set_pauseparam,
 };
 
 static int ax88772_reset(struct usbnet *dev)
-- 
2.30.2

