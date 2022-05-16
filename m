Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 834F7527E64
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 09:17:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240859AbiEPHRZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 03:17:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231464AbiEPHRY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 03:17:24 -0400
X-Greylist: delayed 496 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 16 May 2022 00:17:23 PDT
Received: from mout-u-107.mailbox.org (mout-u-107.mailbox.org [IPv6:2001:67c:2050:101:465::107])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D31B13CCE
        for <netdev@vger.kernel.org>; Mon, 16 May 2022 00:17:23 -0700 (PDT)
Received: from smtp2.mailbox.org (unknown [91.198.250.124])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-u-107.mailbox.org (Postfix) with ESMTPS id 4L1r2j2h09z9t2j;
        Mon, 16 May 2022 09:09:01 +0200 (CEST)
From:   Stefan Roese <sr@denx.de>
To:     netdev@vger.kernel.org
Cc:     Leszek Polak <lpolak@arri.de>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>
Subject: [PATCH v2] net: phy: marvell: Add errata section 5.1 for Alaska PHY
Date:   Mon, 16 May 2022 09:08:59 +0200
Message-Id: <20220516070859.549170-1-sr@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4L1r2j2h09z9t2j
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NEUTRAL,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
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
Cc: Marek Behún <kabel@kernel.org>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Heiner Kallweit <hkallweit1@gmail.com>
Cc: Russell King <linux@armlinux.org.uk>
Cc: David S. Miller <davem@davemloft.net>
---
v2:
- Implement struct with errata reg values and loop over this
  struct instead of using single phy_write() call for each PHY
  reg value, as suggested by Marek

 drivers/net/phy/marvell.c | 37 +++++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/drivers/net/phy/marvell.c b/drivers/net/phy/marvell.c
index 2702faf7b0f6..41353f615a66 100644
--- a/drivers/net/phy/marvell.c
+++ b/drivers/net/phy/marvell.c
@@ -1177,7 +1177,44 @@ static int m88e1318_config_init(struct phy_device *phydev)
 
 static int m88e1510_config_init(struct phy_device *phydev)
 {
+	static const struct {
+		u16 reg17, reg16;
+	} errata_vals[] = {
+		{ 0x214b, 0x2144 },
+		{ 0x0c28, 0x2146 },
+		{ 0xb233, 0x214d },
+		{ 0xcc0c, 0x2159 },
+	};
 	int err;
+	int i;
+
+	/* As per Marvell Release Notes - Alaska 88E1510/88E1518/88E1512/
+	 * 88E1514 Rev A0, Errata Section 5.1:
+	 * If EEE is intended to be used, the following register writes
+	 * must be done once after every hardware reset.
+	 */
+	err = marvell_set_page(phydev, 0x00FF);
+	if (err < 0)
+		return err;
+
+	for (i = 0; i < ARRAY_SIZE(errata_vals); ++i) {
+		err = phy_write(phydev, 17, errata_vals[i].reg17);
+		if (err)
+			return err;
+		err = phy_write(phydev, 16, errata_vals[i].reg16);
+		if (err)
+			return err;
+	}
+
+	err = marvell_set_page(phydev, 0x00FB);
+	if (err < 0)
+		return err;
+	err = phy_write(phydev, 07, 0xC00D);
+	if (err < 0)
+		return err;
+	err = marvell_set_page(phydev, MII_MARVELL_COPPER_PAGE);
+	if (err < 0)
+		return err;
 
 	/* SGMII-to-Copper mode initialization */
 	if (phydev->interface == PHY_INTERFACE_MODE_SGMII) {
-- 
2.36.1

