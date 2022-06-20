Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72A07551456
	for <lists+netdev@lfdr.de>; Mon, 20 Jun 2022 11:29:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240755AbiFTJ3C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jun 2022 05:29:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240859AbiFTJ2r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jun 2022 05:28:47 -0400
Received: from mailout1.hostsharing.net (mailout1.hostsharing.net [IPv6:2a01:37:1000::53df:5fcc:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E807511839
        for <netdev@vger.kernel.org>; Mon, 20 Jun 2022 02:28:43 -0700 (PDT)
Received: from h08.hostsharing.net (h08.hostsharing.net [83.223.95.28])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256
         client-signature RSA-PSS (4096 bits) client-digest SHA256)
        (Client CN "*.hostsharing.net", Issuer "RapidSSL TLS DV RSA Mixed SHA256 2020 CA-1" (verified OK))
        by mailout1.hostsharing.net (Postfix) with ESMTPS id F34A410191786;
        Mon, 20 Jun 2022 11:28:39 +0200 (CEST)
Received: from localhost (unknown [89.246.108.87])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by h08.hostsharing.net (Postfix) with ESMTPSA id D212B6190EF9;
        Mon, 20 Jun 2022 11:28:39 +0200 (CEST)
X-Mailbox-Line: From 0254edf48bddc96c6248c4414043a3699e94614a Mon Sep 17 00:00:00 2001
Message-Id: <0254edf48bddc96c6248c4414043a3699e94614a.1655716767.git.lukas@wunner.de>
From:   Lukas Wunner <lukas@wunner.de>
Date:   Mon, 20 Jun 2022 11:28:39 +0200
Subject: [PATCH net-next] net: phy: smsc: Deduplicate interrupt
 acknowledgement upon phy_init_hw()
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, Andre Edich <andre.edich@microchip.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since commit 4c0d2e96ba05 ("net: phy: consider that suspend2ram may cut
off PHY power"), phy_init_hw() invokes both, the ->config_init() and
->config_intr() callbacks.

In the SMSC PHY driver, the latter acknowledges stale interrupts, hence
there's no longer a need to acknowledge them in the former as well.

There are no other callers of ->config_init() besides phy_init_hw().

Drop the redundant code.

Signed-off-by: Lukas Wunner <lukas@wunner.de>
---
 drivers/net/phy/smsc.c | 13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff --git a/drivers/net/phy/smsc.c b/drivers/net/phy/smsc.c
index 1b54684b68a0..dcd160785f95 100644
--- a/drivers/net/phy/smsc.c
+++ b/drivers/net/phy/smsc.c
@@ -121,10 +121,7 @@ static int smsc_phy_config_init(struct phy_device *phydev)
 	/* Enable energy detect mode for this SMSC Transceivers */
 	rc = phy_write(phydev, MII_LAN83C185_CTRL_STATUS,
 		       rc | MII_LAN83C185_EDPWRDOWN);
-	if (rc < 0)
-		return rc;
-
-	return smsc_phy_ack_interrupt(phydev);
+	return rc;
 }
 
 static int smsc_phy_reset(struct phy_device *phydev)
@@ -146,11 +143,6 @@ static int smsc_phy_reset(struct phy_device *phydev)
 	return genphy_soft_reset(phydev);
 }
 
-static int lan911x_config_init(struct phy_device *phydev)
-{
-	return smsc_phy_ack_interrupt(phydev);
-}
-
 static int lan87xx_config_aneg(struct phy_device *phydev)
 {
 	int rc;
@@ -418,9 +410,6 @@ static struct phy_driver smsc_phy_driver[] = {
 
 	.probe		= smsc_phy_probe,
 
-	/* basic functions */
-	.config_init	= lan911x_config_init,
-
 	/* IRQ related */
 	.config_intr	= smsc_phy_config_intr,
 	.handle_interrupt = smsc_phy_handle_interrupt,
-- 
2.35.2

