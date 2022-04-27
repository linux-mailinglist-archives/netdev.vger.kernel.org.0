Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 487785110C5
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 07:59:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357916AbiD0GCx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 02:02:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242834AbiD0GCw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 02:02:52 -0400
Received: from mailout3.hostsharing.net (mailout3.hostsharing.net [IPv6:2a01:4f8:150:2161:1:b009:f236:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BC383D1F7;
        Tue, 26 Apr 2022 22:59:42 -0700 (PDT)
Received: from h08.hostsharing.net (h08.hostsharing.net [83.223.95.28])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256
         client-signature RSA-PSS (4096 bits) client-digest SHA256)
        (Client CN "*.hostsharing.net", Issuer "RapidSSL TLS DV RSA Mixed SHA256 2020 CA-1" (verified OK))
        by mailout3.hostsharing.net (Postfix) with ESMTPS id 17778100DECB3;
        Wed, 27 Apr 2022 07:59:40 +0200 (CEST)
Received: from localhost (unknown [89.246.108.87])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by h08.hostsharing.net (Postfix) with ESMTPSA id CDAA561ABA99;
        Wed, 27 Apr 2022 07:59:39 +0200 (CEST)
X-Mailbox-Line: From 91a3499156cff9123ede28c95e802d47f4151141 Mon Sep 17 00:00:00 2001
Message-Id: <91a3499156cff9123ede28c95e802d47f4151141.1651037513.git.lukas@wunner.de>
In-Reply-To: <cover.1651037513.git.lukas@wunner.de>
References: <cover.1651037513.git.lukas@wunner.de>
From:   Lukas Wunner <lukas@wunner.de>
Date:   Wed, 27 Apr 2022 07:48:02 +0200
Subject: [PATCH net-next 2/7] usbnet: smsc95xx: Don't clear read-only PHY
 interrupt
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

Upon receiving data from the Interrupt Endpoint, the SMSC LAN95xx driver
attempts to clear the signaled interrupts by writing "all ones" to the
Interrupt Status Register.

However the driver only ever enables a single type of interrupt, namely
the PHY Interrupt.  And according to page 119 of the LAN950x datasheet,
its bit in the Interrupt Status Register is read-only.  There's no other
way to clear it than in a separate PHY register:

https://www.microchip.com/content/dam/mchp/documents/UNG/ProductDocuments/DataSheets/LAN950x-Data-Sheet-DS00001875D.pdf

Consequently, writing "all ones" to the Interrupt Status Register is
pointless and can be dropped.

Signed-off-by: Lukas Wunner <lukas@wunner.de>
---
 drivers/net/usb/smsc95xx.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/usb/smsc95xx.c b/drivers/net/usb/smsc95xx.c
index edf0492ad489..2cb44d65bbc3 100644
--- a/drivers/net/usb/smsc95xx.c
+++ b/drivers/net/usb/smsc95xx.c
@@ -572,10 +572,6 @@ static int smsc95xx_link_reset(struct usbnet *dev)
 	unsigned long flags;
 	int ret;
 
-	ret = smsc95xx_write_reg(dev, INT_STS, INT_STS_CLEAR_ALL_);
-	if (ret < 0)
-		return ret;
-
 	spin_lock_irqsave(&pdata->mac_cr_lock, flags);
 	if (pdata->phydev->duplex != DUPLEX_FULL) {
 		pdata->mac_cr &= ~MAC_CR_FDPX_;
-- 
2.35.2

