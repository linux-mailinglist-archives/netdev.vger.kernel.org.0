Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C678F518573
	for <lists+netdev@lfdr.de>; Tue,  3 May 2022 15:28:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236165AbiECNcI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 09:32:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236182AbiECNcD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 09:32:03 -0400
Received: from mailout2.hostsharing.net (mailout2.hostsharing.net [IPv6:2a01:37:3000::53df:4ee9:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98FD41D0D9;
        Tue,  3 May 2022 06:28:29 -0700 (PDT)
Received: from h08.hostsharing.net (h08.hostsharing.net [IPv6:2a01:37:1000::53df:5f1c:0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256
         client-signature RSA-PSS (4096 bits) client-digest SHA256)
        (Client CN "*.hostsharing.net", Issuer "RapidSSL TLS DV RSA Mixed SHA256 2020 CA-1" (verified OK))
        by mailout2.hostsharing.net (Postfix) with ESMTPS id E34BD10189E0A;
        Tue,  3 May 2022 15:28:27 +0200 (CEST)
Received: from localhost (unknown [89.246.108.87])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by h08.hostsharing.net (Postfix) with ESMTPSA id C374A630FA12;
        Tue,  3 May 2022 15:28:27 +0200 (CEST)
X-Mailbox-Line: From 95ff93fffa161a7a96604b4dfe2be933fe740785 Mon Sep 17 00:00:00 2001
Message-Id: <95ff93fffa161a7a96604b4dfe2be933fe740785.1651574194.git.lukas@wunner.de>
In-Reply-To: <cover.1651574194.git.lukas@wunner.de>
References: <cover.1651574194.git.lukas@wunner.de>
From:   Lukas Wunner <lukas@wunner.de>
Date:   Tue, 3 May 2022 15:15:07 +0200
Subject: [PATCH net-next v2 7/7] net: phy: smsc: Cope with hot-removal in
 interrupt handler
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        Steve Glendinning <steve.glendinning@shawell.net>,
        UNGLinuxDriver@microchip.com, Oliver Neukum <oneukum@suse.com>,
        Andre Edich <andre.edich@microchip.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Martyn Welch <martyn.welch@collabora.com>,
        Gabriel Hojda <ghojda@yo2urs.ro>,
        Christoph Fritz <chf.fritz@googlemail.com>,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>,
        Philipp Rosenberger <p.rosenberger@kunbus.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@armlinux.org.uk>,
        Ferry Toth <fntoth@gmail.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If reading the Interrupt Source Flag register fails with -ENODEV, then
the PHY has been hot-removed and the correct response is to bail out
instead of throwing a WARN splat and attempting to suspend the PHY.
The PHY should be stopped in due course anyway as the kernel
asynchronously tears down the device.

Tested-by: Oleksij Rempel <o.rempel@pengutronix.de> # LAN9514/9512/9500
Tested-by: Ferry Toth <fntoth@gmail.com> # LAN9514
Signed-off-by: Lukas Wunner <lukas@wunner.de>
---
 drivers/net/phy/smsc.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/smsc.c b/drivers/net/phy/smsc.c
index a521d48b22a7..35bff7fd234c 100644
--- a/drivers/net/phy/smsc.c
+++ b/drivers/net/phy/smsc.c
@@ -91,7 +91,9 @@ static irqreturn_t smsc_phy_handle_interrupt(struct phy_device *phydev)
 
 	irq_status = phy_read(phydev, MII_LAN83C185_ISF);
 	if (irq_status < 0) {
-		phy_error(phydev);
+		if (irq_status != -ENODEV)
+			phy_error(phydev);
+
 		return IRQ_NONE;
 	}
 
-- 
2.35.2

