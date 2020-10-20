Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCF18293F3C
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 17:06:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408505AbgJTPG0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 11:06:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:38778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731491AbgJTPGX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Oct 2020 11:06:23 -0400
Received: from dellmb.labs.office.nic.cz (nat-1.nic.cz [217.31.205.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B3C5322251;
        Tue, 20 Oct 2020 15:06:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603206382;
        bh=wkpWkmsemFSQMGwGRKxqoomcaNREmpJ1h5yxj1FUFvs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wPDvTdaVGMIh9cBlztWfs5/FlR1h2ws6mH/bnUBmLS5IWz4ztfNRTjzZ7f+K3YBAQ
         4OsLWVFa8/N3uGoEdLyRk+GLh8JOrYzPPDmPn4Ijl44R0FaD4XT5WVP6NcKufSLJhd
         8KWo6r1kcgJkkzV8U+hsEhMQ4m8vbrxUu7nUughY=
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH russell-kings-net-queue v2 2/3] net: phy: sfp: add support for multigig RollBall modules
Date:   Tue, 20 Oct 2020 17:06:14 +0200
Message-Id: <20201020150615.11969-3-kabel@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201020150615.11969-1-kabel@kernel.org>
References: <20201020150615.11969-1-kabel@kernel.org>
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
---
 drivers/net/phy/sfp.c | 69 +++++++++++++++++++++++++++++++++++++++----
 1 file changed, 63 insertions(+), 6 deletions(-)

diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index 4e47c8e8a529..37b1a9f57ce1 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -167,6 +167,7 @@ static const enum gpiod_flags gpio_flags[] = {
  * on board (for a copper SFP) time to initialise.
  */
 #define T_WAIT			msecs_to_jiffies(50)
+#define T_WAIT_LONG_PHY		msecs_to_jiffies(30000)
 #define T_START_UP		msecs_to_jiffies(300)
 #define T_START_UP_BAD_GPON	msecs_to_jiffies(60000)
 #define T_START_UP_COOLED	msecs_to_jiffies(90000)
@@ -207,8 +208,11 @@ static const enum gpiod_flags gpio_flags[] = {
 
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
@@ -223,6 +227,7 @@ struct sfp {
 	struct phy_device *mod_phy;
 	const struct sff_data *type;
 	u32 max_power_mW;
+	int phy_addr;
 
 	unsigned int (*get_state)(struct sfp *);
 	void (*set_state)(struct sfp *, unsigned int);
@@ -251,6 +256,7 @@ struct sfp {
 	struct sfp_eeprom_id id;
 	unsigned int module_power_mW;
 	unsigned int module_t_start_up;
+	unsigned int module_t_wait;
 
 #if IS_ENABLED(CONFIG_HWMON)
 	struct sfp_diag diag;
@@ -1594,7 +1600,7 @@ static int sfp_sm_probe_phy(struct sfp *sfp, bool is_c45)
 	struct phy_device *phy;
 	int err;
 
-	phy = get_phy_device(sfp->i2c_mii, SFP_PHY_ADDR, is_c45);
+	phy = get_phy_device(sfp->i2c_mii, sfp->phy_addr, is_c45);
 	if (phy == ERR_PTR(-ENODEV))
 		return PTR_ERR(phy);
 	if (IS_ERR(phy)) {
@@ -1931,12 +1937,40 @@ static void sfp_print_module_info(struct sfp *sfp, const struct sfp_eeprom_id *i
 			      id->ext.enhopts));
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
+		dev_err(sfp->dev, "Failed to write password for RollBall MDIO access; %d\n", err);
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
 
@@ -2006,6 +2040,23 @@ static int sfp_sm_mod_probe(struct sfp *sfp, bool report)
 
 	sfp->id = id;
 
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
+		 * To try to probe for PHY we need the correct one */
+		id.base.extended_cc = SFF8024_ECC_10GBASE_T_SFI;
+	}
+
 	/* Check whether we support this module */
 	if (!sfp->type->module_supported(&id)) {
 		dev_err(sfp->dev,
@@ -2032,6 +2083,11 @@ static int sfp_sm_mod_probe(struct sfp *sfp, bool report)
 	else
 		sfp->module_t_start_up = T_START_UP;
 
+	if (rollball)
+		sfp->module_t_wait = T_WAIT_LONG_PHY;
+	else
+		sfp->module_t_wait = T_WAIT;
+
 	return 0;
 }
 
@@ -2225,9 +2281,10 @@ static void sfp_sm_main(struct sfp *sfp, unsigned int event)
 
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
@@ -2241,8 +2298,8 @@ static void sfp_sm_main(struct sfp *sfp, unsigned int event)
 			 * indicated by TX_FAULT deasserting.
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

