Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D52E559484
	for <lists+netdev@lfdr.de>; Fri, 24 Jun 2022 10:04:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230242AbiFXICS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jun 2022 04:02:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230217AbiFXICR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jun 2022 04:02:17 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE9F96B8F0
        for <netdev@vger.kernel.org>; Fri, 24 Jun 2022 01:02:16 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1o4eGY-0007MN-GR; Fri, 24 Jun 2022 10:02:10 +0200
Received: from [2a0a:edc0:0:1101:1d::ac] (helo=dude04.red.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1o4eGW-002Nzj-4h; Fri, 24 Jun 2022 10:02:09 +0200
Received: from ore by dude04.red.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1o4eGW-00DBgC-Mm; Fri, 24 Jun 2022 10:02:08 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Lukas Wunner <lukas@wunner.de>
Subject: [PATCH net-next v1 1/1] net: asix: add optional flow control support
Date:   Fri, 24 Jun 2022 10:02:07 +0200
Message-Id: <20220624080208.3143093-1-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add optional flow control support with respect to the link partners
abilities.

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 drivers/net/usb/asix_common.c  | 10 ++++++++++
 drivers/net/usb/asix_devices.c |  2 ++
 2 files changed, 12 insertions(+)

diff --git a/drivers/net/usb/asix_common.c b/drivers/net/usb/asix_common.c
index b4a1b7abcfc9..c9df7cd8daae 100644
--- a/drivers/net/usb/asix_common.c
+++ b/drivers/net/usb/asix_common.c
@@ -420,6 +420,8 @@ void asix_adjust_link(struct net_device *netdev)
 	u16 mode = 0;
 
 	if (phydev->link) {
+		bool tx_pause, rx_pause;
+
 		mode = AX88772_MEDIUM_DEFAULT;
 
 		if (phydev->duplex == DUPLEX_HALF)
@@ -427,6 +429,14 @@ void asix_adjust_link(struct net_device *netdev)
 
 		if (phydev->speed != SPEED_100)
 			mode &= ~AX_MEDIUM_PS;
+
+		phy_get_pause(phydev, &tx_pause, &rx_pause);
+
+		if (rx_pause)
+			mode |= AX_MEDIUM_RFC;
+
+		if (tx_pause)
+			mode |= AX_MEDIUM_TFC;
 	}
 
 	asix_write_medium_mode(dev, mode, 0);
diff --git a/drivers/net/usb/asix_devices.c b/drivers/net/usb/asix_devices.c
index 5b5eb630c4b7..1bb12bbc34bf 100644
--- a/drivers/net/usb/asix_devices.c
+++ b/drivers/net/usb/asix_devices.c
@@ -677,6 +677,8 @@ static int ax88772_init_phy(struct usbnet *dev)
 	phy_suspend(priv->phydev);
 	priv->phydev->mac_managed_pm = 1;
 
+	phy_support_asym_pause(priv->phydev);
+
 	phy_attached_info(priv->phydev);
 
 	if (priv->embd_phy)
-- 
2.30.2

