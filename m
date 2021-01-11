Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8C412F0C0B
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 06:03:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726760AbhAKFBl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 00:01:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:52254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725355AbhAKFBk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Jan 2021 00:01:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 43EEB225AB;
        Mon, 11 Jan 2021 05:00:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610341259;
        bh=dp+dfVD35WYfV9r8qMZR1uY8DShRhaGepZG99Xc+oC4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HYw56bcB9X2eHf9l7nQ6bBzgXp14Z9FoIIWAH6ctj8oEC/rzGmzrrXh6nm1m6GTla
         U18j1jd8klofblby/B1OFmpDfuBkJ2hDY4cg3GcRBx8A5wE6eIzxnv3IhDvFnK2TW1
         w+b520tnlJGVOGcBNkWf9FlmcsxgYLKEJMx/C/ilAZdDxIw+b6np1uVACUE0OvH2gm
         ybmFSSHOn3jnPuOn94+KJ1g+EZOK1pXBKZVYTrVBwZjN0okSpEfpeSI6BqZd2OCAqR
         HNKdCHcPGpfSVaVagPhw2wTlJiWjyDEkiK8rII/zQvNQMB/VYS/+KjnNeT7oCdeIdj
         /b5bXziiNAogA==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org
Cc:     Russell King <rmk+kernel@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>,
        davem@davemloft.net, pali@kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH net-next v4 4/4] net: sfp: add support for multigig RollBall transceivers
Date:   Mon, 11 Jan 2021 06:00:44 +0100
Message-Id: <20210111050044.22002-5-kabel@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210111050044.22002-1-kabel@kernel.org>
References: <20210111050044.22002-1-kabel@kernel.org>
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
index 0621d12cf878..21fb96899518 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -165,6 +165,7 @@ static const enum gpiod_flags gpio_flags[] = {
  * on board (for a copper SFP) time to initialise.
  */
 #define T_WAIT			msecs_to_jiffies(50)
+#define T_WAIT_ROLLBALL		msecs_to_jiffies(25000)
 #define T_START_UP		msecs_to_jiffies(300)
 #define T_START_UP_BAD_GPON	msecs_to_jiffies(60000)
 
@@ -204,8 +205,11 @@ static const enum gpiod_flags gpio_flags[] = {
 
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
@@ -218,6 +222,7 @@ struct sfp {
 	struct mii_bus *i2c_mii;
 	struct sfp_bus *sfp_bus;
 	enum mdio_i2c_proto mdio_protocol;
+	int phy_addr;
 	struct phy_device *mod_phy;
 	const struct sff_data *type;
 	size_t i2c_block_size;
@@ -250,6 +255,7 @@ struct sfp {
 	struct sfp_eeprom_id id;
 	unsigned int module_power_mW;
 	unsigned int module_t_start_up;
+	unsigned int module_t_wait;
 
 #if IS_ENABLED(CONFIG_HWMON)
 	struct sfp_diag diag;
@@ -1453,7 +1459,7 @@ static int sfp_sm_probe_phy(struct sfp *sfp, bool is_c45)
 	struct phy_device *phy;
 	int err;
 
-	phy = get_phy_device(sfp->i2c_mii, SFP_PHY_ADDR, is_c45);
+	phy = get_phy_device(sfp->i2c_mii, sfp->phy_addr, is_c45);
 	if (phy == ERR_PTR(-ENODEV))
 		return PTR_ERR(phy);
 	if (IS_ERR(phy)) {
@@ -1835,6 +1841,23 @@ static int sfp_sm_mod_probe(struct sfp *sfp, bool report)
 
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
+		/* RollBall SFPs may have wrong (zero) extended compliacne code
+		 * burned in EEPROM. For PHY probing we need the correct one.
+		 */
+		id.base.extended_cc = SFF8024_ECC_10GBASE_T_SFI;
+	}
+
 	return 0;
 }
 
@@ -2030,9 +2053,10 @@ static void sfp_sm_main(struct sfp *sfp, unsigned int event)
 
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
@@ -2046,8 +2070,8 @@ static void sfp_sm_main(struct sfp *sfp, unsigned int event)
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

