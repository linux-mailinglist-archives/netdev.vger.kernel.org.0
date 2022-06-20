Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52620551689
	for <lists+netdev@lfdr.de>; Mon, 20 Jun 2022 13:05:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241217AbiFTLFI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jun 2022 07:05:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240930AbiFTLFH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jun 2022 07:05:07 -0400
Received: from mailout3.hostsharing.net (mailout3.hostsharing.net [IPv6:2a01:4f8:150:2161:1:b009:f236:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F86C12AA2;
        Mon, 20 Jun 2022 04:05:06 -0700 (PDT)
Received: from h08.hostsharing.net (h08.hostsharing.net [83.223.95.28])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256
         client-signature RSA-PSS (4096 bits) client-digest SHA256)
        (Client CN "*.hostsharing.net", Issuer "RapidSSL TLS DV RSA Mixed SHA256 2020 CA-1" (verified OK))
        by mailout3.hostsharing.net (Postfix) with ESMTPS id 6E4AD10029E11;
        Mon, 20 Jun 2022 13:05:01 +0200 (CEST)
Received: from localhost (unknown [89.246.108.87])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by h08.hostsharing.net (Postfix) with ESMTPSA id 2CD1861975D7;
        Mon, 20 Jun 2022 13:05:01 +0200 (CEST)
X-Mailbox-Line: From 439a3f3168c2f9d44b5fd9bb8d2b551711316be6 Mon Sep 17 00:00:00 2001
Message-Id: <439a3f3168c2f9d44b5fd9bb8d2b551711316be6.1655714438.git.lukas@wunner.de>
From:   Lukas Wunner <lukas@wunner.de>
Date:   Mon, 20 Jun 2022 13:04:50 +0200
Subject: [PATCH net] net: phy: smsc: Disable Energy Detect Power-Down in
 interrupt mode
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
        Simon Han <z.han@kunbus.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@armlinux.org.uk>,
        Ferry Toth <fntoth@gmail.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        linux-samsung-soc@vger.kernel.org
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Simon reports that if two LAN9514 USB adapters are directly connected
without an intermediate switch, the link fails to come up and link LEDs
remain dark.  The issue was introduced by commit 1ce8b37241ed ("usbnet:
smsc95xx: Forward PHY interrupts to PHY driver to avoid polling").

The PHY suffers from a known erratum wherein link detection becomes
unreliable if Energy Detect Power-Down is used.  In poll mode, the
driver works around the erratum by briefly disabling EDPD for 640 msec
to detect a neighbor, then re-enabling it to save power.

In interrupt mode, no interrupt is signaled if EDPD is used by both link
partners, so it must not be enabled at all.

We'll recoup the power savings by enabling SUSPEND1 mode on affected
LAN95xx chips in a forthcoming commit.

Fixes: 1ce8b37241ed ("usbnet: smsc95xx: Forward PHY interrupts to PHY driver to avoid polling")
Reported-by: Simon Han <z.han@kunbus.com>
Signed-off-by: Lukas Wunner <lukas@wunner.de>
---
 drivers/net/phy/smsc.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/smsc.c b/drivers/net/phy/smsc.c
index 1b54684b68a0..96d3c40932d8 100644
--- a/drivers/net/phy/smsc.c
+++ b/drivers/net/phy/smsc.c
@@ -110,7 +110,7 @@ static int smsc_phy_config_init(struct phy_device *phydev)
 	struct smsc_phy_priv *priv = phydev->priv;
 	int rc;
 
-	if (!priv->energy_enable)
+	if (!priv->energy_enable || phydev->irq != PHY_POLL)
 		return 0;
 
 	rc = phy_read(phydev, MII_LAN83C185_CTRL_STATUS);
@@ -210,6 +210,8 @@ static int lan95xx_config_aneg_ext(struct phy_device *phydev)
  * response on link pulses to detect presence of plugged Ethernet cable.
  * The Energy Detect Power-Down mode is enabled again in the end of procedure to
  * save approximately 220 mW of power if cable is unplugged.
+ * The workaround is only applicable to poll mode. Energy Detect Power-Down may
+ * not be used in interrupt mode lest link change detection becomes unreliable.
  */
 static int lan87xx_read_status(struct phy_device *phydev)
 {
@@ -217,7 +219,7 @@ static int lan87xx_read_status(struct phy_device *phydev)
 
 	int err = genphy_read_status(phydev);
 
-	if (!phydev->link && priv->energy_enable) {
+	if (!phydev->link && priv->energy_enable && phydev->irq == PHY_POLL) {
 		/* Disable EDPD to wake up PHY */
 		int rc = phy_read(phydev, MII_LAN83C185_CTRL_STATUS);
 		if (rc < 0)
-- 
2.35.2

