Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 607B1511130
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 08:31:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358115AbiD0GeH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 02:34:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242098AbiD0GeG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 02:34:06 -0400
X-Greylist: delayed 1589 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 26 Apr 2022 23:30:56 PDT
Received: from mailout2.hostsharing.net (mailout2.hostsharing.net [83.223.78.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C7971C126
        for <netdev@vger.kernel.org>; Tue, 26 Apr 2022 23:30:56 -0700 (PDT)
Received: from h08.hostsharing.net (h08.hostsharing.net [IPv6:2a01:37:1000::53df:5f1c:0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256
         client-signature RSA-PSS (4096 bits) client-digest SHA256)
        (Client CN "*.hostsharing.net", Issuer "RapidSSL TLS DV RSA Mixed SHA256 2020 CA-1" (verified OK))
        by mailout2.hostsharing.net (Postfix) with ESMTPS id D784B1008D087;
        Wed, 27 Apr 2022 08:30:54 +0200 (CEST)
Received: from localhost (unknown [89.246.108.87])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by h08.hostsharing.net (Postfix) with ESMTPSA id AA9586000F33;
        Wed, 27 Apr 2022 08:30:54 +0200 (CEST)
X-Mailbox-Line: From 805ccdc606bd8898d59931bd4c7c68537ed6e550 Mon Sep 17 00:00:00 2001
Message-Id: <805ccdc606bd8898d59931bd4c7c68537ed6e550.1651040826.git.lukas@wunner.de>
From:   Lukas Wunner <lukas@wunner.de>
Date:   Wed, 27 Apr 2022 08:30:51 +0200
Subject: [PATCH net-next] net: phy: Deduplicate interrupt disablement on PHY
 attach
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

phy_attach_direct() first calls phy_init_hw() (which restores interrupt
settings through ->config_intr()), then calls phy_disable_interrupts().

So if phydev->interrupts was previously set to 1, interrupts are briefly
enabled, then disabled, which seems nonsensical.

If it was previously set to 0, interrupts are disabled twice, which is
equally nonsensical.

Deduplicate interrupt disablement.

Signed-off-by: Lukas Wunner <lukas@wunner.de>
---
 drivers/net/phy/phy_device.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 8406ac739def..f867042b2eb4 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -1449,6 +1449,8 @@ int phy_attach_direct(struct net_device *dev, struct phy_device *phydev,
 
 	phydev->state = PHY_READY;
 
+	phydev->interrupts = PHY_INTERRUPT_DISABLED;
+
 	/* Port is set to PORT_TP by default and the actual PHY driver will set
 	 * it to different value depending on the PHY configuration. If we have
 	 * the generic PHY driver we can't figure it out, thus set the old
@@ -1471,10 +1473,6 @@ int phy_attach_direct(struct net_device *dev, struct phy_device *phydev,
 	if (err)
 		goto error;
 
-	err = phy_disable_interrupts(phydev);
-	if (err)
-		return err;
-
 	phy_resume(phydev);
 	phy_led_triggers_register(phydev);
 
-- 
2.35.2

