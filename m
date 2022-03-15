Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A6804D95BA
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 08:56:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237754AbiCOH5e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 03:57:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235395AbiCOH5d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 03:57:33 -0400
X-Greylist: delayed 465 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 15 Mar 2022 00:56:21 PDT
Received: from mout-u-107.mailbox.org (mout-u-107.mailbox.org [91.198.250.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 077134BBA6
        for <netdev@vger.kernel.org>; Tue, 15 Mar 2022 00:56:20 -0700 (PDT)
Received: from smtp202.mailbox.org (unknown [91.198.250.118])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-u-107.mailbox.org (Postfix) with ESMTPS id 4KHlrw4G1Pz9sR2;
        Tue, 15 Mar 2022 08:48:32 +0100 (CET)
From:   Stefan Roese <sr@denx.de>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>
Subject: [PATCH] net: phy: marvell: Add errata section 5.1 for Alaska PHY
Date:   Tue, 15 Mar 2022 08:48:27 +0100
Message-Id: <20220315074827.1439941-1-sr@denx.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NEUTRAL,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leszek Polak <lpolak@arri.de>

As per Errata Section 5.1, if EEE is intended to be used, some register
writes must be done once after every hardware reset. This patch now adds
the necessary register writes as listed in the Marvell errata.

Without this fix we experience ethernet problems on some of our boards
equipped with a new version of this ethernet PHY (different supplier).

The fix applies to Marvell Alaska 88E1510/88E1518/88E1512/88E1514
Rev. A0.

Signed-off-by: Leszek Polak <lpolak@arri.de>
Signed-off-by: Stefan Roese <sr@denx.de>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Heiner Kallweit <hkallweit1@gmail.com>
Cc: Russell King <linux@armlinux.org.uk>
Cc: David S. Miller <davem@davemloft.net>
---
 drivers/net/phy/marvell.c | 42 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 42 insertions(+)

diff --git a/drivers/net/phy/marvell.c b/drivers/net/phy/marvell.c
index 2429db614b59..0f4a3ab4a415 100644
--- a/drivers/net/phy/marvell.c
+++ b/drivers/net/phy/marvell.c
@@ -1179,6 +1179,48 @@ static int m88e1510_config_init(struct phy_device *phydev)
 {
 	int err;
 
+	/* As per Marvell Release Notes - Alaska 88E1510/88E1518/88E1512/
+	 * 88E1514 Rev A0, Errata Section 5.1:
+	 * If EEE is intended to be used, the following register writes
+	 * must be done once after every hardware reset.
+	 */
+	err = marvell_set_page(phydev, 0x00FF);
+	if (err < 0)
+		return err;
+	err = phy_write(phydev, 17, 0x214B);
+	if (err < 0)
+		return err;
+	err = phy_write(phydev, 16, 0x2144);
+	if (err < 0)
+		return err;
+	err = phy_write(phydev, 17, 0x0C28);
+	if (err < 0)
+		return err;
+	err = phy_write(phydev, 16, 0x2146);
+	if (err < 0)
+		return err;
+	err = phy_write(phydev, 17, 0xB233);
+	if (err < 0)
+		return err;
+	err = phy_write(phydev, 16, 0x214D);
+	if (err < 0)
+		return err;
+	err = phy_write(phydev, 17, 0xCC0C);
+	if (err < 0)
+		return err;
+	err = phy_write(phydev, 16, 0x2159);
+	if (err < 0)
+		return err;
+	err = marvell_set_page(phydev, 0x00FB);
+	if (err < 0)
+		return err;
+	err = phy_write(phydev, 07, 0xC00D);
+	if (err < 0)
+		return err;
+	err = marvell_set_page(phydev, MII_MARVELL_COPPER_PAGE);
+	if (err < 0)
+		return err;
+
 	/* SGMII-to-Copper mode initialization */
 	if (phydev->interface == PHY_INTERFACE_MODE_SGMII) {
 		/* Select page 18 */
-- 
2.35.1

