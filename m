Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D0AF2008A7
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 14:27:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731479AbgFSM1B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 08:27:01 -0400
Received: from relay12.mail.gandi.net ([217.70.178.232]:50583 "EHLO
        relay12.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733039AbgFSMZZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jun 2020 08:25:25 -0400
Received: from localhost (lfbn-tou-1-1075-236.w90-76.abo.wanadoo.fr [90.76.143.236])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay12.mail.gandi.net (Postfix) with ESMTPSA id 7514720000E;
        Fri, 19 Jun 2020 12:25:23 +0000 (UTC)
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     davem@davemloft.net, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com, richardcochran@gmail.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        thomas.petazzoni@bootlin.com, allan.nielsen@microchip.com,
        foss@0leil.net, antoine.tenart@bootlin.com
Subject: [PATCH net-next v3 3/8] net: phy: mscc: remove the TR CLK disable magic value
Date:   Fri, 19 Jun 2020 14:22:55 +0200
Message-Id: <20200619122300.2510533-4-antoine.tenart@bootlin.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200619122300.2510533-1-antoine.tenart@bootlin.com>
References: <20200619122300.2510533-1-antoine.tenart@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Quentin Schulz <quentin.schulz@bootlin.com>

This patch adds a define for the 0x8000 magic value used to perform
enable/disable actions on the "token ring clock". The patch is only
cosmetic.

Signed-off-by: Quentin Schulz <quentin.schulz@bootlin.com>
Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>
---
 drivers/net/phy/mscc/mscc.h      |  1 +
 drivers/net/phy/mscc/mscc_main.c | 10 +++++-----
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/net/phy/mscc/mscc.h b/drivers/net/phy/mscc/mscc.h
index fbcee5fce7b2..756ec418f4f8 100644
--- a/drivers/net/phy/mscc/mscc.h
+++ b/drivers/net/phy/mscc/mscc.h
@@ -252,6 +252,7 @@ enum rgmii_clock_delay {
 /* Test page Registers */
 #define MSCC_PHY_TEST_PAGE_5		  5
 #define MSCC_PHY_TEST_PAGE_8		  8
+#define TR_CLK_DISABLE			  0x8000
 #define MSCC_PHY_TEST_PAGE_9		  9
 #define MSCC_PHY_TEST_PAGE_20		  20
 #define MSCC_PHY_TEST_PAGE_24		  24
diff --git a/drivers/net/phy/mscc/mscc_main.c b/drivers/net/phy/mscc/mscc_main.c
index 5ddc44f87eaf..052a0def6e83 100644
--- a/drivers/net/phy/mscc/mscc_main.c
+++ b/drivers/net/phy/mscc/mscc_main.c
@@ -629,7 +629,7 @@ static int vsc8531_pre_init_seq_set(struct phy_device *phydev)
 	if (rc < 0)
 		return rc;
 	rc = phy_modify_paged(phydev, MSCC_PHY_PAGE_TEST,
-			      MSCC_PHY_TEST_PAGE_8, 0x8000, 0x8000);
+			      MSCC_PHY_TEST_PAGE_8, TR_CLK_DISABLE, TR_CLK_DISABLE);
 	if (rc < 0)
 		return rc;
 
@@ -1026,7 +1026,7 @@ static int vsc8574_config_pre_init(struct phy_device *phydev)
 	phy_base_write(phydev, MSCC_PHY_TEST_PAGE_5, 0x1b20);
 
 	reg = phy_base_read(phydev, MSCC_PHY_TEST_PAGE_8);
-	reg |= 0x8000;
+	reg |= TR_CLK_DISABLE;
 	phy_base_write(phydev, MSCC_PHY_TEST_PAGE_8, reg);
 
 	phy_base_write(phydev, MSCC_EXT_PAGE_ACCESS, MSCC_PHY_PAGE_TR);
@@ -1046,7 +1046,7 @@ static int vsc8574_config_pre_init(struct phy_device *phydev)
 	phy_base_write(phydev, MSCC_EXT_PAGE_ACCESS, MSCC_PHY_PAGE_TEST);
 
 	reg = phy_base_read(phydev, MSCC_PHY_TEST_PAGE_8);
-	reg &= ~0x8000;
+	reg &= ~TR_CLK_DISABLE;
 	phy_base_write(phydev, MSCC_PHY_TEST_PAGE_8, reg);
 
 	phy_base_write(phydev, MSCC_EXT_PAGE_ACCESS, MSCC_PHY_PAGE_STANDARD);
@@ -1196,7 +1196,7 @@ static int vsc8584_config_pre_init(struct phy_device *phydev)
 	phy_base_write(phydev, MSCC_PHY_TEST_PAGE_5, 0x1f20);
 
 	reg = phy_base_read(phydev, MSCC_PHY_TEST_PAGE_8);
-	reg |= 0x8000;
+	reg |= TR_CLK_DISABLE;
 	phy_base_write(phydev, MSCC_PHY_TEST_PAGE_8, reg);
 
 	phy_base_write(phydev, MSCC_EXT_PAGE_ACCESS, MSCC_PHY_PAGE_TR);
@@ -1225,7 +1225,7 @@ static int vsc8584_config_pre_init(struct phy_device *phydev)
 	phy_base_write(phydev, MSCC_EXT_PAGE_ACCESS, MSCC_PHY_PAGE_TEST);
 
 	reg = phy_base_read(phydev, MSCC_PHY_TEST_PAGE_8);
-	reg &= ~0x8000;
+	reg &= ~TR_CLK_DISABLE;
 	phy_base_write(phydev, MSCC_PHY_TEST_PAGE_8, reg);
 
 	phy_base_write(phydev, MSCC_EXT_PAGE_ACCESS, MSCC_PHY_PAGE_STANDARD);
-- 
2.26.2

