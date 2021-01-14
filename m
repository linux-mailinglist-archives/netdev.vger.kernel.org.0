Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2ED552F5A02
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 05:46:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727054AbhANEpD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 23:45:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:34988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726640AbhANEpC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Jan 2021 23:45:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E8C20239D3;
        Thu, 14 Jan 2021 04:43:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610599430;
        bh=G9xPNinZ7l0pEHVaxcUfxEJr7h8qSlkgWk0+EGwZbaw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fXDALwgBCQnKhwQlYKgrcxWMUYzVqp4VDJz4iQpYLht2x6Eh8AbggUhx7oOEzSBqU
         tdz+Vd0CWuKDRrf9neQEBkl18YzG267rGuQgjZcBOOGZEF6xS+SlEVEY/9o5/RuG6U
         MtzOdrnA02zBC7SQgeFltj4QH9ycs3sodCPdJ/iYqsb5umkg2DYlIiYpmXIQWJyEFd
         BwW6bC9HnvuZEm8Z70/7Wcot4OsRkEwaWJjk8ZEt5zEnCooTNaVucYmvoTF2fFMI91
         oYuLupnSPSAgkcrcbtwJ+WeI1/Iv0zAowhdfMCJ4nw598LGkuojPu01b3mREGWKQMP
         ZksARDQoHtCCQ==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org
Cc:     Russell King <rmk+kernel@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>,
        davem@davemloft.net, pali@kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH net-next v5 5/5] net: sfp: add support for multigig RollBall transceivers
Date:   Thu, 14 Jan 2021 05:43:31 +0100
Message-Id: <20210114044331.5073-6-kabel@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210114044331.5073-1-kabel@kernel.org>
References: <20210114044331.5073-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds support for multigig copper SFP modules from RollBall/Hilink.
These modules have a specific way to access clause 45 registers of the
internal PHY.

We also need to wait at least 22 seconds after deasserting TX disable
before accessing the PHY. The code waits for 25 seconds just to be sure.

Signed-off-by: Marek Behún <kabel@kernel.org>
Reviewed-by: Russell King <rmk+kernel@armlinux.org.uk>
Cc: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/phy/sfp.c | 36 ++++++++++++++++++++++++++++++------
 1 file changed, 30 insertions(+), 6 deletions(-)

diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index d1b655f805ab..9f4270c19380 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -166,6 +166,7 @@ static const enum gpiod_flags gpio_flags[] = {
  * on board (for a copper SFP) time to initialise.
  */
 #define T_WAIT			msecs_to_jiffies(50)
+#define T_WAIT_ROLLBALL		msecs_to_jiffies(25000)
 #define T_START_UP		msecs_to_jiffies(300)
 #define T_START_UP_BAD_GPON	msecs_to_jiffies(60000)
 
@@ -205,8 +206,11 @@ static const enum gpiod_flags gpio_flags[] = {
 
 /* SFP modules appear to always have their PHY configured for bus address
  * 0x56 (which with mdio-i2c, translates to a PHY address of 22).
+ * RollBall SFPs access phy via SFP Enhanced Digital Diagnostic Interface
+ * via address 0x51 (mdio-i2c will use RollBall protocol on this address).
  */
-#define SFP_PHY_ADDR	22
+#define SFP_PHY_ADDR		22
+#define SFP_PHY_ADDR_ROLLBALL	17
 
 struct sff_data {
 	unsigned int gpios;
@@ -219,6 +223,7 @@ struct sfp {
 	struct mii_bus *i2c_mii;
 	struct sfp_bus *sfp_bus;
 	enum mdio_i2c_proto mdio_protocol;
+	int phy_addr;
 	struct phy_device *mod_phy;
 	const struct sff_data *type;
 	size_t i2c_block_size;
@@ -251,6 +256,7 @@ struct sfp {
 	struct sfp_eeprom_id id;
 	unsigned int module_power_mW;
 	unsigned int module_t_start_up;
+	unsigned int module_t_wait;
 
 #if IS_ENABLED(CONFIG_HWMON)
 	struct sfp_diag diag;
@@ -1505,7 +1511,7 @@ static int sfp_sm_probe_phy(struct sfp *sfp, bool is_c45)
 	struct phy_device *phy;
 	int err;
 
-	phy = get_phy_device(sfp->i2c_mii, SFP_PHY_ADDR, is_c45);
+	phy = get_phy_device(sfp->i2c_mii, sfp->phy_addr, is_c45);
 	if (phy == ERR_PTR(-ENODEV))
 		return PTR_ERR(phy);
 	if (IS_ERR(phy)) {
@@ -1895,6 +1901,23 @@ static int sfp_sm_mod_probe(struct sfp *sfp, bool report)
 
 	sfp->mdio_protocol = MDIO_I2C_DEFAULT;
 
+	sfp->phy_addr = SFP_PHY_ADDR;
+	sfp->module_t_wait = T_WAIT;
+
+	if (((!memcmp(id.base.vendor_name, "OEM             ", 16) ||
+	      !memcmp(id.base.vendor_name, "Turris          ", 16)) &&
+	     (!memcmp(id.base.vendor_pn, "SFP-10G-T       ", 16) ||
+	      !memcmp(id.base.vendor_pn, "RTSFP-10", 8)))) {
+		sfp->mdio_protocol = MDIO_I2C_ROLLBALL;
+		sfp->phy_addr = SFP_PHY_ADDR_ROLLBALL;
+		sfp->module_t_wait = T_WAIT_ROLLBALL;
+
+		/* RollBall SFPs may have wrong (zero) extended compliance code
+		 * burned in EEPROM. For PHY probing we need the correct one.
+		 */
+		id.base.extended_cc = SFF8024_ECC_10GBASE_T_SFI;
+	}
+
 	return 0;
 }
 
@@ -2090,9 +2113,10 @@ static void sfp_sm_main(struct sfp *sfp, unsigned int event)
 
 		/* We need to check the TX_FAULT state, which is not defined
 		 * while TX_DISABLE is asserted. The earliest we want to do
-		 * anything (such as probe for a PHY) is 50ms.
+		 * anything (such as probe for a PHY) is 50ms. (or more on
+		 * specific modules).
 		 */
-		sfp_sm_next(sfp, SFP_S_WAIT, T_WAIT);
+		sfp_sm_next(sfp, SFP_S_WAIT, sfp->module_t_wait);
 		break;
 
 	case SFP_S_WAIT:
@@ -2106,8 +2130,8 @@ static void sfp_sm_main(struct sfp *sfp, unsigned int event)
 			 * deasserting.
 			 */
 			timeout = sfp->module_t_start_up;
-			if (timeout > T_WAIT)
-				timeout -= T_WAIT;
+			if (timeout > sfp->module_t_wait)
+				timeout -= sfp->module_t_wait;
 			else
 				timeout = 1;
 
-- 
2.26.2

