Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B13455110CE
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 08:01:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357951AbiD0GEt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 02:04:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348733AbiD0GEt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 02:04:49 -0400
Received: from mailout3.hostsharing.net (mailout3.hostsharing.net [IPv6:2a01:4f8:150:2161:1:b009:f236:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 530D444A1E;
        Tue, 26 Apr 2022 23:01:39 -0700 (PDT)
Received: from h08.hostsharing.net (h08.hostsharing.net [83.223.95.28])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256
         client-signature RSA-PSS (4096 bits) client-digest SHA256)
        (Client CN "*.hostsharing.net", Issuer "RapidSSL TLS DV RSA Mixed SHA256 2020 CA-1" (verified OK))
        by mailout3.hostsharing.net (Postfix) with ESMTPS id 9E867100B0166;
        Wed, 27 Apr 2022 08:01:35 +0200 (CEST)
Received: from localhost (unknown [89.246.108.87])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by h08.hostsharing.net (Postfix) with ESMTPSA id 5DADE61ABA99;
        Wed, 27 Apr 2022 08:01:35 +0200 (CEST)
X-Mailbox-Line: From cf64096387a685596b3590452b899618d46de433 Mon Sep 17 00:00:00 2001
Message-Id: <cf64096387a685596b3590452b899618d46de433.1651037513.git.lukas@wunner.de>
In-Reply-To: <cover.1651037513.git.lukas@wunner.de>
References: <cover.1651037513.git.lukas@wunner.de>
From:   Lukas Wunner <lukas@wunner.de>
Date:   Wed, 27 Apr 2022 07:48:03 +0200
Subject: [PATCH net-next 3/7] usbnet: smsc95xx: Don't reset PHY behind PHY
 driver's back
To:     Steve Glendinning <steve.glendinning@shawell.net>,
        UNGLinuxDriver@microchip.com, Oliver Neukum <oneukum@suse.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        Andre Edich <andre.edich@microchip.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Martyn Welch <martyn.welch@collabora.com>,
        Gabriel Hojda <ghojda@yo2urs.ro>,
        Christoph Fritz <chf.fritz@googlemail.com>,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>,
        Philipp Rosenberger <p.rosenberger@kunbus.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@armlinux.org.uk>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

smsc95xx_reset() resets the PHY behind the PHY driver's back, which
seems like a bad idea generally.  Remove that portion of the function.

We're about to use PHY interrupts instead of polling to detect link
changes on SMSC LAN95xx chips.  Because smsc95xx_reset() is called from
usbnet_open(), PHY interrupt settings are lost whenever the net_device
is brought up.

There are two other callers of smsc95xx_reset(), namely smsc95xx_bind()
and smsc95xx_reset_resume(), and both may indeed benefit from a PHY
reset.  However they already perform one through their calls to
phy_connect_direct() and phy_init_hw().

Signed-off-by: Lukas Wunner <lukas@wunner.de>
Cc: Martyn Welch <martyn.welch@collabora.com>
Cc: Gabriel Hojda <ghojda@yo2urs.ro>
---
 drivers/net/usb/smsc95xx.c | 18 ------------------
 1 file changed, 18 deletions(-)

diff --git a/drivers/net/usb/smsc95xx.c b/drivers/net/usb/smsc95xx.c
index 2cb44d65bbc3..6c37c7adde1b 100644
--- a/drivers/net/usb/smsc95xx.c
+++ b/drivers/net/usb/smsc95xx.c
@@ -887,24 +887,6 @@ static int smsc95xx_reset(struct usbnet *dev)
 		return ret;
 	}
 
-	ret = smsc95xx_write_reg(dev, PM_CTRL, PM_CTL_PHY_RST_);
-	if (ret < 0)
-		return ret;
-
-	timeout = 0;
-	do {
-		msleep(10);
-		ret = smsc95xx_read_reg(dev, PM_CTRL, &read_buf);
-		if (ret < 0)
-			return ret;
-		timeout++;
-	} while ((read_buf & PM_CTL_PHY_RST_) && (timeout < 100));
-
-	if (timeout >= 100) {
-		netdev_warn(dev->net, "timeout waiting for PHY Reset\n");
-		return ret;
-	}
-
 	ret = smsc95xx_set_mac_address(dev);
 	if (ret < 0)
 		return ret;
-- 
2.35.2

