Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 131C81B2247
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 11:05:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728447AbgDUJFA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 05:05:00 -0400
Received: from guitar.tcltek.co.il ([192.115.133.116]:51686 "EHLO
        mx.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728332AbgDUJEy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Apr 2020 05:04:54 -0400
Received: from tarshish.tkos.co.il (unknown [10.0.8.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx.tkos.co.il (Postfix) with ESMTPS id 0188644046E;
        Tue, 21 Apr 2020 12:04:49 +0300 (IDT)
From:   Baruch Siach <baruch@tkos.co.il>
To:     Russell King <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Baruch Siach <baruch@tkos.co.il>
Subject: [PATCH net] net: phy: marvell10g: limit soft reset to 88x3310
Date:   Tue, 21 Apr 2020 12:04:46 +0300
Message-Id: <616c799433477943d782bda9d8a825d56fc70c9d.1587459886.git.baruch@tkos.co.il>
X-Mailer: git-send-email 2.26.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The MV_V2_PORT_CTRL_SWRST bit in MV_V2_PORT_CTRL is reserved on 88E2110.
Setting SWRST on 88E2110 breaks packets transfer after interface down/up
cycle.

Fixes: 8f48c2ac85ed ("net: marvell10g: soft-reset the PHY when coming out of low power")
Signed-off-by: Baruch Siach <baruch@tkos.co.il>
---
 drivers/net/phy/marvell10g.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/marvell10g.c b/drivers/net/phy/marvell10g.c
index d3cb88651ad2..601686f64341 100644
--- a/drivers/net/phy/marvell10g.c
+++ b/drivers/net/phy/marvell10g.c
@@ -263,7 +263,8 @@ static int mv3310_power_up(struct phy_device *phydev)
 	ret = phy_clear_bits_mmd(phydev, MDIO_MMD_VEND2, MV_V2_PORT_CTRL,
 				 MV_V2_PORT_CTRL_PWRDOWN);
 
-	if (priv->firmware_ver < 0x00030000)
+	if (phydev->drv->phy_id != MARVELL_PHY_ID_88X3310 ||
+	    priv->firmware_ver < 0x00030000)
 		return ret;
 
 	return phy_set_bits_mmd(phydev, MDIO_MMD_VEND2, MV_V2_PORT_CTRL,
-- 
2.26.1

