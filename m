Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 734F6355E99
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 00:12:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344000AbhDFWMT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 18:12:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:52636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344035AbhDFWMK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Apr 2021 18:12:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 786C5613CD;
        Tue,  6 Apr 2021 22:12:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617747121;
        bh=MgjaySJZ5hjvZRj353kL+XmRyamXl14agsejMbBtngA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MOSfM5PAfYJ2nhWs6exBAIMoD518m7brqdD81q4+Mbkv3MV+ghD1auzudkg+B+B63
         iT7Ur5EoFdZ/2EKDkebjhyLMTVbssx1/+7nd6VUG2PJUilz+7tgh7OoGldhrCbKT2s
         bDHJqa10Vl1UWdQyDswLRDHpvXx/ljRNds6+YZjE1fcogT1uhgRWJL0bCERlq/mbMW
         dyENsmQl9VheDv20dQpY0V8PE9rdlJne8DzUWEI4zM22Nmz4LfNfok0nMXTRvaS8Tr
         0tXWvHTSMzwKpJmoIR5e0oQx3RNXGXOM42H7EIXXezm2BReoMSi0V7p+ZIvWD0eZwa
         bCazsBzSyPniw==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org, Russell King <rmk+kernel@armlinux.org.uk>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, kuba@kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH net-next v3 10/18] net: phy: marvell10g: check for correct supported interface mode
Date:   Wed,  7 Apr 2021 00:10:59 +0200
Message-Id: <20210406221107.1004-11-kabel@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210406221107.1004-1-kabel@kernel.org>
References: <20210406221107.1004-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 88E2110 does not support xaui nor rxaui modes. Check for correct
interface mode for different chips.

Signed-off-by: Marek Behún <kabel@kernel.org>
---
 drivers/net/phy/marvell10g.c | 25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

diff --git a/drivers/net/phy/marvell10g.c b/drivers/net/phy/marvell10g.c
index fc298e53f165..e3ced38f40c9 100644
--- a/drivers/net/phy/marvell10g.c
+++ b/drivers/net/phy/marvell10g.c
@@ -109,6 +109,7 @@ enum {
 };
 
 struct mv3310_chip {
+	DECLARE_BITMAP(supported_interfaces, PHY_INTERFACE_MODE_MAX);
 	int (*get_mactype)(struct phy_device *phydev);
 	int (*init_interface)(struct phy_device *phydev, int mactype);
 };
@@ -545,13 +546,7 @@ static int mv3310_config_init(struct phy_device *phydev)
 	int err, mactype;
 
 	/* Check that the PHY interface type is compatible */
-	if (phydev->interface != PHY_INTERFACE_MODE_SGMII &&
-	    phydev->interface != PHY_INTERFACE_MODE_2500BASEX &&
-	    phydev->interface != PHY_INTERFACE_MODE_5GBASER &&
-	    phydev->interface != PHY_INTERFACE_MODE_XAUI &&
-	    phydev->interface != PHY_INTERFACE_MODE_RXAUI &&
-	    phydev->interface != PHY_INTERFACE_MODE_10GBASER &&
-	    phydev->interface != PHY_INTERFACE_MODE_USXGMII)
+	if (!test_bit(phydev->interface, chip->supported_interfaces))
 		return -ENODEV;
 
 	phydev->mdix_ctrl = ETH_TP_MDI_AUTO;
@@ -859,11 +854,27 @@ static int mv3310_set_tunable(struct phy_device *phydev,
 }
 
 static const struct mv3310_chip mv3310_type = {
+	.supported_interfaces =
+		INITIALIZE_BITMAP(PHY_INTERFACE_MODE_MAX,
+				  PHY_INTERFACE_MODE_SGMII,
+				  PHY_INTERFACE_MODE_2500BASEX,
+				  PHY_INTERFACE_MODE_5GBASER,
+				  PHY_INTERFACE_MODE_XAUI,
+				  PHY_INTERFACE_MODE_RXAUI,
+				  PHY_INTERFACE_MODE_10GBASER,
+				  PHY_INTERFACE_MODE_USXGMII),
 	.get_mactype = mv3310_get_mactype,
 	.init_interface = mv3310_init_interface,
 };
 
 static const struct mv3310_chip mv2110_type = {
+	.supported_interfaces =
+		INITIALIZE_BITMAP(PHY_INTERFACE_MODE_MAX,
+				  PHY_INTERFACE_MODE_SGMII,
+				  PHY_INTERFACE_MODE_2500BASEX,
+				  PHY_INTERFACE_MODE_5GBASER,
+				  PHY_INTERFACE_MODE_10GBASER,
+				  PHY_INTERFACE_MODE_USXGMII),
 	.get_mactype = mv2110_get_mactype,
 	.init_interface = mv2110_init_interface,
 };
-- 
2.26.2

