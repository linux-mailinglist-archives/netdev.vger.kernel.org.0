Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF49E355E92
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 00:11:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243641AbhDFWMC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 18:12:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:52464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243573AbhDFWL6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Apr 2021 18:11:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AFC59613D0;
        Tue,  6 Apr 2021 22:11:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617747110;
        bh=FOevhU8i3XRTM11GzF7iMvZTBmKxyy06ejTi2+SjdN0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nUU8Z9fy0bLqhDLZKKoOvrEFfNJ+CrSHu5OqdP+ON9VmjrvFV2uJAM28U3OD2PI0Y
         GrnAQfuT6+0ulNkR6O+wJ1fZXgZLarVy9kYIB/G7YojgaeP8MEt4Yshvyx9dhvUFlj
         NROPrwGgn1+5tNsMd3DuyujPwgK34tA7drSdPwW1chCtasL6JSAeiNA3fRjv/QYdV/
         S/gmLwWz+EsOFS+Lo837si+AeUCtFwYCKDGAyJiq/VBtvnPi9r5oZsam27KxXOfcFq
         VPAYpa5M9k3dLwbFS2ibFkWoFwUHhG5D1ocHcgnk2NYKL1qbKaxBoi78F3lKGhjjr7
         TVQBTGwBn3QsA==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org, Russell King <rmk+kernel@armlinux.org.uk>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, kuba@kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH net-next v3 03/18] net: phy: marvell10g: allow 5gbase-r and usxgmii
Date:   Wed,  7 Apr 2021 00:10:52 +0200
Message-Id: <20210406221107.1004-4-kabel@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210406221107.1004-1-kabel@kernel.org>
References: <20210406221107.1004-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These modes are also supported by these PHYs.

Signed-off-by: Marek Behún <kabel@kernel.org>
---
 drivers/net/phy/marvell10g.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/marvell10g.c b/drivers/net/phy/marvell10g.c
index f2f0da9717be..881a0717846e 100644
--- a/drivers/net/phy/marvell10g.c
+++ b/drivers/net/phy/marvell10g.c
@@ -462,9 +462,11 @@ static int mv3310_config_init(struct phy_device *phydev)
 	/* Check that the PHY interface type is compatible */
 	if (phydev->interface != PHY_INTERFACE_MODE_SGMII &&
 	    phydev->interface != PHY_INTERFACE_MODE_2500BASEX &&
+	    phydev->interface != PHY_INTERFACE_MODE_5GBASER &&
 	    phydev->interface != PHY_INTERFACE_MODE_XAUI &&
 	    phydev->interface != PHY_INTERFACE_MODE_RXAUI &&
-	    phydev->interface != PHY_INTERFACE_MODE_10GBASER)
+	    phydev->interface != PHY_INTERFACE_MODE_10GBASER &&
+	    phydev->interface != PHY_INTERFACE_MODE_USXGMII)
 		return -ENODEV;
 
 	phydev->mdix_ctrl = ETH_TP_MDI_AUTO;
@@ -599,6 +601,7 @@ static void mv3310_update_interface(struct phy_device *phydev)
 
 	if ((phydev->interface == PHY_INTERFACE_MODE_SGMII ||
 	     phydev->interface == PHY_INTERFACE_MODE_2500BASEX ||
+	     phydev->interface == PHY_INTERFACE_MODE_5GBASER ||
 	     phydev->interface == PHY_INTERFACE_MODE_10GBASER) &&
 	    phydev->link) {
 		/* The PHY automatically switches its serdes interface (and
@@ -611,6 +614,9 @@ static void mv3310_update_interface(struct phy_device *phydev)
 		case SPEED_10000:
 			phydev->interface = PHY_INTERFACE_MODE_10GBASER;
 			break;
+		case SPEED_5000:
+			phydev->interface = PHY_INTERFACE_MODE_5GBASER;
+			break;
 		case SPEED_2500:
 			phydev->interface = PHY_INTERFACE_MODE_2500BASEX;
 			break;
-- 
2.26.2

