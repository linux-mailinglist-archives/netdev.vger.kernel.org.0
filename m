Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43A842412CC
	for <lists+netdev@lfdr.de>; Tue, 11 Aug 2020 00:06:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726800AbgHJWGs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Aug 2020 18:06:48 -0400
Received: from lists.nic.cz ([217.31.204.67]:42718 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726775AbgHJWGs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 Aug 2020 18:06:48 -0400
Received: from dellmb.labs.office.nic.cz (unknown [IPv6:2001:1488:fffe:6:cac7:3539:7f1f:463])
        by mail.nic.cz (Postfix) with ESMTP id B8B69140A42;
        Tue, 11 Aug 2020 00:06:46 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1597097206; bh=B1zLheSS8qRHr4MBzfrL7XirvFiyI7+FOXSk6RmlDxs=;
        h=From:To:Date;
        b=aG7cWZPuBK4fI8QGHi+Epgxnq/G7dO0DBimD2m1zGSBWKGbTNLhu/GYmA/pfx7UfU
         o1bpMmpfPaCkCAaInWNu+Q8cDEfWUQEOfqEM+f0LwhWIlU9vYQtbJeW3oo3p7y/BXF
         BVgSk9iygCts38s0NQVHqEyl0RLzK5zTW+rTgTm8=
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        Baruch Siach <baruch@tkos.co.il>,
        Chris Healy <cphealy@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>
Subject: [PATCH RFC russell-king 2/4] net: phy: sfp: add support for multigig RollBall modules
Date:   Tue, 11 Aug 2020 00:06:43 +0200
Message-Id: <20200810220645.19326-3-marek.behun@nic.cz>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200810220645.19326-1-marek.behun@nic.cz>
References: <20200810220645.19326-1-marek.behun@nic.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.nic.cz
X-Spam-Status: No, score=0.00
X-Spamd-Bar: /
X-Virus-Scanned: clamav-milter 0.102.2 at mail
X-Virus-Status: Clean
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds support for multigig copper SFP modules from RollBall/Hilink.
These modules have a specific way to access clause 45 registers of the
internal PHY.

We also need to wait at least 25 seconds after deasserting TX disable
before accessing the PHY. The code waits for 30 seconds just to be sure.

Signed-off-by: Marek Behún <marek.behun@nic.cz>
---
 drivers/net/phy/sfp.c | 57 ++++++++++++++++++++++++++++++++++++-------
 1 file changed, 48 insertions(+), 9 deletions(-)

diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index a62fa2e5ae4e6..fe72282e96c7d 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -167,6 +167,7 @@ static const enum gpiod_flags gpio_flags[] = {
 #define T_WAIT			msecs_to_jiffies(50)
 #define T_START_UP		msecs_to_jiffies(300)
 #define T_START_UP_BAD_GPON	msecs_to_jiffies(60000)
+#define T_START_UP_LONG_PHY	msecs_to_jiffies(30000)
 
 /* t_reset is the time required to assert the TX_DISABLE signal to reset
  * an indicated TX_FAULT.
@@ -243,6 +244,7 @@ struct sfp {
 	struct sfp_eeprom_id id;
 	unsigned int module_power_mW;
 	unsigned int module_t_start_up;
+	bool rollball_mii;
 
 #if IS_ENABLED(CONFIG_HWMON)
 	struct sfp_diag diag;
@@ -394,9 +396,6 @@ static int sfp_i2c_write(struct sfp *sfp, bool a2, u8 dev_addr, void *buf,
 
 static int sfp_i2c_configure(struct sfp *sfp, struct i2c_adapter *i2c)
 {
-	struct mii_bus *i2c_mii;
-	int ret;
-
 	if (!i2c_check_functionality(i2c, I2C_FUNC_I2C))
 		return -EINVAL;
 
@@ -404,7 +403,19 @@ static int sfp_i2c_configure(struct sfp *sfp, struct i2c_adapter *i2c)
 	sfp->read = sfp_i2c_read;
 	sfp->write = sfp_i2c_write;
 
-	i2c_mii = mdio_i2c_alloc(sfp->dev, i2c);
+	return 0;
+}
+
+static int sfp_i2c_mii_probe(struct sfp *sfp)
+{
+	struct mii_bus *i2c_mii;
+	int ret;
+
+	if (sfp->rollball_mii)
+		i2c_mii = mdio_i2c_rollball_alloc(sfp->dev, sfp->i2c);
+	else
+		i2c_mii = mdio_i2c_alloc(sfp->dev, sfp->i2c);
+
 	if (IS_ERR(i2c_mii))
 		return PTR_ERR(i2c_mii);
 
@@ -422,6 +433,14 @@ static int sfp_i2c_configure(struct sfp *sfp, struct i2c_adapter *i2c)
 	return 0;
 }
 
+static void sfp_i2c_mii_remove(struct sfp *sfp)
+{
+	if (sfp->i2c_mii) {
+		mdiobus_unregister(sfp->i2c_mii);
+		mdiobus_free(sfp->i2c_mii);
+	}
+}
+
 /* Interface */
 static int sfp_read(struct sfp *sfp, bool a2, u8 addr, void *buf, size_t len)
 {
@@ -1419,6 +1438,7 @@ static void sfp_sm_phy_detach(struct sfp *sfp)
 	phy_device_remove(sfp->mod_phy);
 	phy_device_free(sfp->mod_phy);
 	sfp->mod_phy = NULL;
+	sfp_i2c_mii_remove(sfp);
 }
 
 static int sfp_sm_probe_phy(struct sfp *sfp, bool is_c45)
@@ -1426,10 +1446,17 @@ static int sfp_sm_probe_phy(struct sfp *sfp, bool is_c45)
 	struct phy_device *phy;
 	int err;
 
+	err = sfp_i2c_mii_probe(sfp);
+	if (err)
+		return err;
+
 	phy = get_phy_device(sfp->i2c_mii, SFP_PHY_ADDR, is_c45);
-	if (phy == ERR_PTR(-ENODEV))
+	if (phy == ERR_PTR(-ENODEV)) {
+		sfp_i2c_mii_remove(sfp);
 		return PTR_ERR(phy);
+	}
 	if (IS_ERR(phy)) {
+		sfp_i2c_mii_remove(sfp);
 		dev_err(sfp->dev, "mdiobus scan returned %ld\n", PTR_ERR(phy));
 		return PTR_ERR(phy);
 	}
@@ -1437,6 +1464,7 @@ static int sfp_sm_probe_phy(struct sfp *sfp, bool is_c45)
 	err = phy_device_register(phy);
 	if (err) {
 		phy_device_free(phy);
+		sfp_i2c_mii_remove(sfp);
 		dev_err(sfp->dev, "phy_device_register failed: %d\n", err);
 		return err;
 	}
@@ -1445,6 +1473,7 @@ static int sfp_sm_probe_phy(struct sfp *sfp, bool is_c45)
 	if (err) {
 		phy_device_remove(phy);
 		phy_device_free(phy);
+		sfp_i2c_mii_remove(sfp);
 		dev_err(sfp->dev, "sfp_add_phy failed: %d\n", err);
 		return err;
 	}
@@ -1665,6 +1694,7 @@ static int sfp_sm_mod_probe(struct sfp *sfp, bool report)
 	struct sfp_eeprom_id id;
 	bool cotsworks_sfbg;
 	bool cotsworks;
+	bool rollball;
 	u8 check;
 	int ret;
 
@@ -1730,7 +1760,17 @@ static int sfp_sm_mod_probe(struct sfp *sfp, bool report)
 		}
 	}
 
+	rollball = (!memcmp(id.base.vendor_name, "OEM             ", 16) &&
+		    (!memcmp(id.base.vendor_pn, "SFP-10G-T       ", 16) ||
+		     !memcmp(id.base.vendor_pn, "RTSFP-10        ", 16) ||
+		     !memcmp(id.base.vendor_pn, "RTSFP-2.5G      ", 16)));
+	if (rollball) {
+		/* TODO: try to write this to EEPROM */
+		id.base.extended_cc = SFF8024_ECC_10GBASE_T_SFI;
+	}
+
 	sfp->id = id;
+	sfp->rollball_mii = rollball;
 
 	dev_info(sfp->dev, "module %.*s %.*s rev %.*s sn %.*s dc %.*s\n",
 		 (int)sizeof(id.base.vendor_name), id.base.vendor_name,
@@ -1760,6 +1800,8 @@ static int sfp_sm_mod_probe(struct sfp *sfp, bool report)
 	if (!memcmp(id.base.vendor_name, "ALCATELLUCENT   ", 16) &&
 	    !memcmp(id.base.vendor_pn, "3FE46541AA      ", 16))
 		sfp->module_t_start_up = T_START_UP_BAD_GPON;
+	else if (rollball)
+		sfp->module_t_start_up = T_START_UP_LONG_PHY;
 	else
 		sfp->module_t_start_up = T_START_UP;
 
@@ -2264,10 +2306,7 @@ static void sfp_cleanup(void *data)
 
 	cancel_delayed_work_sync(&sfp->poll);
 	cancel_delayed_work_sync(&sfp->timeout);
-	if (sfp->i2c_mii) {
-		mdiobus_unregister(sfp->i2c_mii);
-		mdiobus_free(sfp->i2c_mii);
-	}
+	sfp_i2c_mii_remove(sfp);
 	if (sfp->i2c)
 		i2c_put_adapter(sfp->i2c);
 	kfree(sfp);
-- 
2.26.2

