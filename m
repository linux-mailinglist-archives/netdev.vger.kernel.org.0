Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B696629F7E2
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 23:25:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725993AbgJ2WZY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 18:25:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:43816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725962AbgJ2WZV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Oct 2020 18:25:21 -0400
Received: from dellmb.labs.office.nic.cz (nat-1.nic.cz [217.31.205.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9BA0D2151B;
        Thu, 29 Oct 2020 22:25:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604010320;
        bh=/w6vqCGbHDT7DL5PBsoUHDLsxRc+51YK6t2ac7UbdOo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Jt2rxLJ21J1W3YWvSVqPv3FRrdPBZterKa9tvp/kyEApyZFZhowcRvr7NO1h2M+w8
         XVIOmJ7mcJioMoWTbJmxRc0Ki3jzbJrtFxx58+pLnU31Fd9x95EpzuYroEzK9xaPvc
         V8eWsBqQTyEaiJbaFBSf5iDRabpYKx0eYpzyxFYo=
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King <rmk+kernel@armlinux.org.uk>
Subject: [PATCH net-next v2 5/5] net: sfp: add support for multigig RollBall transceivers
Date:   Thu, 29 Oct 2020 23:25:09 +0100
Message-Id: <20201029222509.27201-6-kabel@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201029222509.27201-1-kabel@kernel.org>
References: <20201029222509.27201-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds support for multigig copper SFP modules from RollBall/Hilink.
These modules have a specific way to access clause 45 registers of the
internal PHY.

We also need to wait at least 25 seconds after deasserting TX disable
before accessing the PHY. The code waits for 30 seconds just to be sure.

Signed-off-by: Marek Behún <kabel@kernel.org>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/sfp.c | 35 +++++++++++++++++++++++++++++------
 1 file changed, 29 insertions(+), 6 deletions(-)

diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index 3c3da19039d5..a0a2af817c0f 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -165,6 +165,7 @@ static const enum gpiod_flags gpio_flags[] = {
  * on board (for a copper SFP) time to initialise.
  */
 #define T_WAIT			msecs_to_jiffies(50)
+#define T_WAIT_ROLLBALL		msecs_to_jiffies(30000)
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
 	u32 max_power_mW;
@@ -249,6 +254,7 @@ struct sfp {
 	struct sfp_eeprom_id id;
 	unsigned int module_power_mW;
 	unsigned int module_t_start_up;
+	unsigned int module_t_wait;
 
 #if IS_ENABLED(CONFIG_HWMON)
 	struct sfp_diag diag;
@@ -1443,7 +1449,7 @@ static int sfp_sm_probe_phy(struct sfp *sfp, bool is_c45)
 	struct phy_device *phy;
 	int err;
 
-	phy = get_phy_device(sfp->i2c_mii, SFP_PHY_ADDR, is_c45);
+	phy = get_phy_device(sfp->i2c_mii, sfp->phy_addr, is_c45);
 	if (phy == ERR_PTR(-ENODEV))
 		return PTR_ERR(phy);
 	if (IS_ERR(phy)) {
@@ -1781,6 +1787,22 @@ static int sfp_sm_mod_probe(struct sfp *sfp, bool report)
 		sfp->module_t_start_up = T_START_UP;
 
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
 
 	return 0;
 }
@@ -1977,9 +1999,10 @@ static void sfp_sm_main(struct sfp *sfp, unsigned int event)
 
 		/* We need to check the TX_FAULT state, which is not defined
 		 * while TX_DISABLE is asserted. The earliest we want to do
-		 * anything (such as probe for a PHY) is 50ms.
+		 * anything (such as probe for a PHY) is 50ms (or more on
+		 * specific modules).
 		 */
-		sfp_sm_next(sfp, SFP_S_WAIT, T_WAIT);
+		sfp_sm_next(sfp, SFP_S_WAIT, sfp->module_t_wait);
 		break;
 
 	case SFP_S_WAIT:
@@ -1993,8 +2016,8 @@ static void sfp_sm_main(struct sfp *sfp, unsigned int event)
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

