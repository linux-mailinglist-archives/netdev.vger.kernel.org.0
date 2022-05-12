Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00D7552485A
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 10:54:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351761AbiELIxs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 04:53:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350936AbiELIxj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 04:53:39 -0400
X-Greylist: delayed 409 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 12 May 2022 01:53:04 PDT
Received: from mailout2.hostsharing.net (mailout2.hostsharing.net [83.223.78.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB6F914040B;
        Thu, 12 May 2022 01:53:03 -0700 (PDT)
Received: from h08.hostsharing.net (h08.hostsharing.net [83.223.95.28])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256
         client-signature RSA-PSS (4096 bits) client-digest SHA256)
        (Client CN "*.hostsharing.net", Issuer "RapidSSL TLS DV RSA Mixed SHA256 2020 CA-1" (verified OK))
        by mailout2.hostsharing.net (Postfix) with ESMTPS id 2B6F410189E11;
        Thu, 12 May 2022 10:53:02 +0200 (CEST)
Received: from localhost (unknown [89.246.108.87])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by h08.hostsharing.net (Postfix) with ESMTPSA id 0746660E98D9;
        Thu, 12 May 2022 10:53:02 +0200 (CEST)
X-Mailbox-Line: From cf9f1b5d1b07e0fa5f78bc8557216ef04f401af5 Mon Sep 17 00:00:00 2001
Message-Id: <cf9f1b5d1b07e0fa5f78bc8557216ef04f401af5.1652343655.git.lukas@wunner.de>
In-Reply-To: <cover.1652343655.git.lukas@wunner.de>
References: <cover.1652343655.git.lukas@wunner.de>
From:   Lukas Wunner <lukas@wunner.de>
Date:   Thu, 12 May 2022 10:42:06 +0200
Subject: [PATCH net-next v3 6/7] net: phy: smsc: Cache interrupt mask
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
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
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cache the interrupt mask to avoid re-reading it from the PHY upon every
interrupt.

This will simplify a subsequent commit which detects hot-removal in the
interrupt handler and bails out.

Analyzing and debugging PHY transactions also becomes simpler if such
redundant reads are avoided.

Last not least, interrupt overhead and latency is slightly improved.

Tested-by: Oleksij Rempel <o.rempel@pengutronix.de> # LAN9514/9512/9500
Tested-by: Ferry Toth <fntoth@gmail.com> # LAN9514
Signed-off-by: Lukas Wunner <lukas@wunner.de>
---
 drivers/net/phy/smsc.c | 24 +++++++++++-------------
 1 file changed, 11 insertions(+), 13 deletions(-)

diff --git a/drivers/net/phy/smsc.c b/drivers/net/phy/smsc.c
index 92225d0fc246..e0eadea4b4b5 100644
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

