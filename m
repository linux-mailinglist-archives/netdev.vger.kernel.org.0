Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A681629D66A
	for <lists+netdev@lfdr.de>; Wed, 28 Oct 2020 23:15:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731037AbgJ1WOq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 18:14:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:58244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731222AbgJ1WOl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Oct 2020 18:14:41 -0400
Received: from dellmb.labs.office.nic.cz (nat-1.nic.cz [217.31.205.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F34D424754;
        Wed, 28 Oct 2020 22:14:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603923280;
        bh=6VF/lnLwH+/bEXWRfT1dm3LJfdZF7pZqfllV2YFD/1o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BhQAR6fUyPTYWVbinUDJi2ynsaF3LZ3lHsaW/M9PP3myjmBZwcpY/U3V6XI2eC9uF
         dr6G/BDwD2PdeKfDfM1L88KqlyfiqkTGSqmPcV4TVtDSZhOdcNmnHS3X4K2RQ36TGP
         /Aa68xVIF42jC8KO8hZShuTeymCuvSMmZBaRQRdc=
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King <rmk+kernel@armlinux.org.uk>
Subject: [PATCH net-next 5/5] net: sfp: add support for multigig RollBall transceivers
Date:   Wed, 28 Oct 2020 23:14:27 +0100
Message-Id: <20201028221427.22968-6-kabel@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201028221427.22968-1-kabel@kernel.org>
References: <20201028221427.22968-1-kabel@kernel.org>
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
 drivers/net/phy/sfp.c | 72 ++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 65 insertions(+), 7 deletions(-)

diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index a392d5fc6ab4..379358f194ee 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -165,6 +165,7 @@ static const enum gpiod_flags gpio_flags[] = {
  * on board (for a copper SFP) time to initialise.
  */
 #define T_WAIT			msecs_to_jiffies(50)
+#define T_WAIT_LONG_PHY		msecs_to_jiffies(30000)
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
@@ -220,6 +224,7 @@ struct sfp {
 	struct phy_device *mod_phy;
 	const struct sff_data *type;
 	u32 max_power_mW;
+	int phy_addr;
 
 	unsigned int (*get_state)(struct sfp *);
 	void (*set_state)(struct sfp *, unsigned int);
@@ -248,6 +253,7 @@ struct sfp {
 	struct sfp_eeprom_id id;
 	unsigned int module_power_mW;
 	unsigned int module_t_start_up;
+	unsigned int module_t_wait;
 
 #if IS_ENABLED(CONFIG_HWMON)
 	struct sfp_diag diag;
@@ -1442,7 +1448,7 @@ static int sfp_sm_probe_phy(struct sfp *sfp, bool is_c45)
 	struct phy_device *phy;
 	int err;
 
-	phy = get_phy_device(sfp->i2c_mii, SFP_PHY_ADDR, is_c45);
+	phy = get_phy_device(sfp->i2c_mii, sfp->phy_addr, is_c45);
 	if (phy == ERR_PTR(-ENODEV))
 		return PTR_ERR(phy);
 	if (IS_ERR(phy)) {
@@ -1675,12 +1681,40 @@ static int sfp_cotsworks_fixup_check(struct sfp *sfp, struct sfp_eeprom_id *id)
 	return 0;
 }
 
+static int sfp_rollball_init_mdio(struct sfp *sfp)
+{
+	u8 page, password[4];
+	int err;
+
+	page = 3;
+
+	err = sfp_write(sfp, true, SFP_PAGE, &page, 1);
+	if (err != 1) {
+		dev_err(sfp->dev, "Failed to set SFP page for RollBall MDIO access: %d\n", err);
+		return err;
+	}
+
+	password[0] = 0xff;
+	password[1] = 0xff;
+	password[2] = 0xff;
+	password[3] = 0xff;
+
+	err = sfp_write(sfp, true, 0x7b, password, 4);
+	if (err != 4) {
+		dev_err(sfp->dev, "Failed to write password for RollBall MDIO access: %d\n", err);
+		return err;
+	}
+
+	return 0;
+}
+
 static int sfp_sm_mod_probe(struct sfp *sfp, bool report)
 {
 	/* SFP module inserted - read I2C data */
 	struct sfp_eeprom_id id;
 	bool cotsworks_sfbg;
 	bool cotsworks;
+	bool rollball;
 	u8 check;
 	int ret;
 
@@ -1755,6 +1789,24 @@ static int sfp_sm_mod_probe(struct sfp *sfp, bool report)
 		 (int)sizeof(id.ext.vendor_sn), id.ext.vendor_sn,
 		 (int)sizeof(id.ext.datecode), id.ext.datecode);
 
+	sfp->phy_addr = SFP_PHY_ADDR;
+
+	rollball = ((!memcmp(id.base.vendor_name, "OEM             ", 16) ||
+		     !memcmp(id.base.vendor_name, "Turris          ", 16)) &&
+		    (!memcmp(id.base.vendor_pn, "SFP-10G-T       ", 16) ||
+		     !memcmp(id.base.vendor_pn, "RTSFP-10", 8)));
+	if (rollball) {
+		sfp->phy_addr = SFP_PHY_ADDR_ROLLBALL;
+		ret = sfp_rollball_init_mdio(sfp);
+		if (ret < 0)
+			return ret;
+
+		/* RollBall SFPs may have wrong (zero) extended compliacne code burned in EEPROM.
+		 * For PHY probing we need the correct one.
+		 */
+		id.base.extended_cc = SFF8024_ECC_10GBASE_T_SFI;
+	}
+
 	/* Check whether we support this module */
 	if (!sfp->type->module_supported(&id)) {
 		dev_err(sfp->dev,
@@ -1779,8 +1831,13 @@ static int sfp_sm_mod_probe(struct sfp *sfp, bool report)
 	else
 		sfp->module_t_start_up = T_START_UP;
 
+	if (rollball)
+		sfp->module_t_wait = T_WAIT_LONG_PHY;
+	else
+		sfp->module_t_wait = T_WAIT;
+
 	/* Configure mdiobus */
-	ret = sfp_i2c_mdiobus_configure(sfp, MDIO_I2C_DEFAULT);
+	ret = sfp_i2c_mdiobus_configure(sfp, rollball ? MDIO_I2C_ROLLBALL : MDIO_I2C_DEFAULT);
 	if (ret < 0)
 		return ret;
 
@@ -1979,9 +2036,10 @@ static void sfp_sm_main(struct sfp *sfp, unsigned int event)
 
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
@@ -1995,8 +2053,8 @@ static void sfp_sm_main(struct sfp *sfp, unsigned int event)
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

