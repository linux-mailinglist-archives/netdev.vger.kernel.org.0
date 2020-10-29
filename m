Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C753229F7E0
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 23:25:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725945AbgJ2WZV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 18:25:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:43768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725946AbgJ2WZS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Oct 2020 18:25:18 -0400
Received: from dellmb.labs.office.nic.cz (nat-1.nic.cz [217.31.205.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8811621582;
        Thu, 29 Oct 2020 22:25:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604010317;
        bh=ECb8LqLVJTmUMVz8vWcp2vmQfYZ3bmjQjlXSPBsEhi8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r7cu6bLH6iPPRVyVA6SU9IL//XgwRgU1myFZhwIV+hWS4Rra9NcnWDouhJzW81+kG
         S5aKbHd5bT4C41KbVDra81i+KnkiWKdeliNzV1JBma7h8JnHT6th3rmPndKwaxP/7c
         aAmL6G6v5qagT3vtJqBHAoIJeWaH6athl4LRXf5w=
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King <rmk+kernel@armlinux.org.uk>
Subject: [PATCH net-next v2 3/5] net: sfp: create/destroy I2C mdiobus before PHY probe/after PHY release
Date:   Thu, 29 Oct 2020 23:25:07 +0100
Message-Id: <20201029222509.27201-4-kabel@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201029222509.27201-1-kabel@kernel.org>
References: <20201029222509.27201-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Instead of configuring the I2C mdiobus when SFP driver is probed,
create/destroy the mdiobus before the PHY is probed for/after it is
released.

This way we can tell the mdio-i2c code which protocol to use for each
SFP transceiver.

Signed-off-by: Marek Behún <kabel@kernel.org>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/sfp.c | 32 +++++++++++++++++++++++++++-----
 1 file changed, 27 insertions(+), 5 deletions(-)

diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index b1f9fc3a5584..3c3da19039d5 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -217,6 +217,7 @@ struct sfp {
 	struct i2c_adapter *i2c;
 	struct mii_bus *i2c_mii;
 	struct sfp_bus *sfp_bus;
+	enum mdio_i2c_proto mdio_protocol;
 	struct phy_device *mod_phy;
 	const struct sff_data *type;
 	u32 max_power_mW;
@@ -399,9 +400,6 @@ static int sfp_i2c_write(struct sfp *sfp, bool a2, u8 dev_addr, void *buf,
 
 static int sfp_i2c_configure(struct sfp *sfp, struct i2c_adapter *i2c)
 {
-	struct mii_bus *i2c_mii;
-	int ret;
-
 	if (!i2c_check_functionality(i2c, I2C_FUNC_I2C))
 		return -EINVAL;
 
@@ -409,7 +407,15 @@ static int sfp_i2c_configure(struct sfp *sfp, struct i2c_adapter *i2c)
 	sfp->read = sfp_i2c_read;
 	sfp->write = sfp_i2c_write;
 
-	i2c_mii = mdio_i2c_alloc(sfp->dev, i2c, MDIO_I2C_DEFAULT);
+	return 0;
+}
+
+static int sfp_i2c_mdiobus_create(struct sfp *sfp)
+{
+	struct mii_bus *i2c_mii;
+	int ret;
+
+	i2c_mii = mdio_i2c_alloc(sfp->dev, sfp->i2c, sfp->mdio_protocol);
 	if (IS_ERR(i2c_mii))
 		return PTR_ERR(i2c_mii);
 
@@ -427,6 +433,12 @@ static int sfp_i2c_configure(struct sfp *sfp, struct i2c_adapter *i2c)
 	return 0;
 }
 
+static void sfp_i2c_mdiobus_destroy(struct sfp *sfp)
+{
+	mdiobus_unregister(sfp->i2c_mii);
+	sfp->i2c_mii = NULL;
+}
+
 /* Interface */
 static int sfp_read(struct sfp *sfp, bool a2, u8 addr, void *buf, size_t len)
 {
@@ -1768,6 +1780,8 @@ static int sfp_sm_mod_probe(struct sfp *sfp, bool report)
 	else
 		sfp->module_t_start_up = T_START_UP;
 
+	sfp->mdio_protocol = MDIO_I2C_DEFAULT;
+
 	return 0;
 }
 
@@ -1936,8 +1950,10 @@ static void sfp_sm_main(struct sfp *sfp, unsigned int event)
 			sfp_sm_link_down(sfp);
 		if (sfp->sm_state > SFP_S_INIT)
 			sfp_module_stop(sfp->sfp_bus);
-		if (sfp->mod_phy)
+		if (sfp->mod_phy) {
 			sfp_sm_phy_detach(sfp);
+			sfp_i2c_mdiobus_destroy(sfp);
+		}
 		sfp_module_tx_disable(sfp);
 		sfp_soft_stop_poll(sfp);
 		sfp_sm_next(sfp, SFP_S_DOWN, 0);
@@ -2000,6 +2016,12 @@ static void sfp_sm_main(struct sfp *sfp, unsigned int event)
 				     sfp->sm_fault_retries == N_FAULT_INIT);
 		} else if (event == SFP_E_TIMEOUT || event == SFP_E_TX_CLEAR) {
 	init_done:
+			/* Create mdiobus and start trying for PHY */
+			ret = sfp_i2c_mdiobus_create(sfp);
+			if (ret < 0) {
+				sfp_sm_next(sfp, SFP_S_FAIL, 0);
+				break;
+			}
 			sfp->sm_phy_retries = R_PHY_RETRY;
 			goto phy_probe;
 		}
-- 
2.26.2

