Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF9C95110F3
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 08:12:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236953AbiD0GPm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 02:15:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229930AbiD0GPk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 02:15:40 -0400
Received: from mailout2.hostsharing.net (mailout2.hostsharing.net [IPv6:2a01:37:3000::53df:4ee9:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4065275D4;
        Tue, 26 Apr 2022 23:12:30 -0700 (PDT)
Received: from h08.hostsharing.net (h08.hostsharing.net [IPv6:2a01:37:1000::53df:5f1c:0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256
         client-signature RSA-PSS (4096 bits) client-digest SHA256)
        (Client CN "*.hostsharing.net", Issuer "RapidSSL TLS DV RSA Mixed SHA256 2020 CA-1" (verified OK))
        by mailout2.hostsharing.net (Postfix) with ESMTPS id 3C06C10321188;
        Wed, 27 Apr 2022 08:12:29 +0200 (CEST)
Received: from localhost (unknown [89.246.108.87])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by h08.hostsharing.net (Postfix) with ESMTPSA id 081F661ABA99;
        Wed, 27 Apr 2022 08:12:28 +0200 (CEST)
X-Mailbox-Line: From 7603f74ddc32bbaa55e9f1bea5d4024b6e376035 Mon Sep 17 00:00:00 2001
Message-Id: <7603f74ddc32bbaa55e9f1bea5d4024b6e376035.1651037513.git.lukas@wunner.de>
In-Reply-To: <cover.1651037513.git.lukas@wunner.de>
References: <cover.1651037513.git.lukas@wunner.de>
From:   Lukas Wunner <lukas@wunner.de>
Date:   Wed, 27 Apr 2022 07:48:06 +0200
Subject: [PATCH net-next 6/7] net: phy: smsc: Cache interrupt mask
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

Cache the interrupt mask to avoid re-reading it from the PHY upon every
interrupt.  The PHY may be located on a USB device, so the additional
read may unnecessarily increase interrupt overhead and latency.

Signed-off-by: Lukas Wunner <lukas@wunner.de>
---
 drivers/net/phy/smsc.c | 24 +++++++++++-------------
 1 file changed, 11 insertions(+), 13 deletions(-)

diff --git a/drivers/net/phy/smsc.c b/drivers/net/phy/smsc.c
index d8cac02a79b9..a521d48b22a7 100644
--- a/drivers/net/phy/smsc.c
+++ b/drivers/net/phy/smsc.c
@@ -44,6 +44,7 @@ static struct smsc_hw_stat smsc_hw_stats[] = {
 };
 
 struct smsc_phy_priv {
+	u16 intmask;
 	bool energy_enable;
 	struct clk *refclk;
 };
@@ -58,7 +59,6 @@ static int smsc_phy_ack_interrupt(struct phy_device *phydev)
 static int smsc_phy_config_intr(struct phy_device *phydev)
 {
 	struct smsc_phy_priv *priv = phydev->priv;
-	u16 intmask = 0;
 	int rc;
 
 	if (phydev->interrupts == PHY_INTERRUPT_ENABLED) {
@@ -66,12 +66,15 @@ static int smsc_phy_config_intr(struct phy_device *phydev)
 		if (rc)
 			return rc;
 
-		intmask = MII_LAN83C185_ISF_INT4 | MII_LAN83C185_ISF_INT6;
+		priv->intmask = MII_LAN83C185_ISF_INT4 | MII_LAN83C185_ISF_INT6;
 		if (priv->energy_enable)
-			intmask |= MII_LAN83C185_ISF_INT7;
-		rc = phy_write(phydev, MII_LAN83C185_IM, intmask);
+			priv->intmask |= MII_LAN83C185_ISF_INT7;
+
+		rc = phy_write(phydev, MII_LAN83C185_IM, priv->intmask);
 	} else {
-		rc = phy_write(phydev, MII_LAN83C185_IM, intmask);
+		priv->intmask = 0;
+
+		rc = phy_write(phydev, MII_LAN83C185_IM, 0);
 		if (rc)
 			return rc;
 
@@ -83,13 +86,8 @@ static int smsc_phy_config_intr(struct phy_device *phydev)
 
 static irqreturn_t smsc_phy_handle_interrupt(struct phy_device *phydev)
 {
-	int irq_status, irq_enabled;
-
-	irq_enabled = phy_read(phydev, MII_LAN83C185_IM);
-	if (irq_enabled < 0) {
-		phy_error(phydev);
-		return IRQ_NONE;
-	}
+	struct smsc_phy_priv *priv = phydev->priv;
+	int irq_status;
 
 	irq_status = phy_read(phydev, MII_LAN83C185_ISF);
 	if (irq_status < 0) {
@@ -97,7 +95,7 @@ static irqreturn_t smsc_phy_handle_interrupt(struct phy_device *phydev)
 		return IRQ_NONE;
 	}
 
-	if (!(irq_status & irq_enabled))
+	if (!(irq_status & priv->intmask))
 		return IRQ_NONE;
 
 	phy_trigger_machine(phydev);
-- 
2.35.2

