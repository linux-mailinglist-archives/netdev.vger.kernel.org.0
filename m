Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 651E65F0D72
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 16:22:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231963AbiI3OWw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 10:22:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231921AbiI3OVw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 10:21:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53752B6573
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 07:21:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5EB70622AF
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 14:21:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51CD0C4347C;
        Fri, 30 Sep 2022 14:21:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664547693;
        bh=7a0rkzGXOhlR4VTyX21fIs63/mFfM2nK4yQdfniC9JI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hwOMHCY+FYhTN0X2g3lmc6qnWItI0mYbam0Hch3seaQrcOuVZrQv8SLuI2dJc7euX
         KAuwDt+xZepjtgzaYaY4nJesmNG1glML35GEfhVH8x3Zxx9Y0ezd+wjhpJurjoESYh
         A3UEnfEOUG1pnoEynokaJqtGeZ83bpKU3Bg9+RaBlEBnRFlu5etn2UdLPKedaDp+jR
         gAbX0v6IXbx3nYIbIubPC4TvkiZ355HoYj2k0eQ17kWtcicmEndQs0xuH4Gmf5mIvR
         uj2jD4yObsmKfXXh0SceVEpjc3+qCumEXBv82mvO5Fk2mAFwkSzIrjY+qUbVI70+MY
         qGtTTHJXI9giA==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Russell King <rmk+kernel@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH net-next 10/12] net: sfp: create/destroy I2C mdiobus before PHY probe/after PHY release
Date:   Fri, 30 Sep 2022 16:21:08 +0200
Message-Id: <20220930142110.15372-11-kabel@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220930142110.15372-1-kabel@kernel.org>
References: <20220930142110.15372-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Instead of configuring the I2C mdiobus when SFP driver is probed,
create/destroy the mdiobus before the PHY is probed for/after it is
released.

This way we can tell the mdio-i2c code which protocol to use for each
SFP transceiver.

Move the code that determines MDIO I2C protocol from
sfp_sm_probe_for_phy() to sfp_sm_mod_probe(), where most of the SFP ID
parsing is done. Don't allocate I2C bus if no PHY is expected.

Signed-off-by: Marek Behún <kabel@kernel.org>
---
 drivers/net/phy/sfp.c         | 64 ++++++++++++++++++++++++++++-------
 include/linux/mdio/mdio-i2c.h |  6 ++++
 2 files changed, 57 insertions(+), 13 deletions(-)

diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index 3201e2726e61..ccd7710685f2 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -218,6 +218,7 @@ struct sfp {
 	struct i2c_adapter *i2c;
 	struct mii_bus *i2c_mii;
 	struct sfp_bus *sfp_bus;
+	enum mdio_i2c_proto mdio_protocol;
 	struct phy_device *mod_phy;
 	const struct sff_data *type;
 	size_t i2c_block_size;
@@ -530,9 +531,6 @@ static int sfp_i2c_write(struct sfp *sfp, bool a2, u8 dev_addr, void *buf,
 
 static int sfp_i2c_configure(struct sfp *sfp, struct i2c_adapter *i2c)
 {
-	struct mii_bus *i2c_mii;
-	int ret;
-
 	if (!i2c_check_functionality(i2c, I2C_FUNC_I2C))
 		return -EINVAL;
 
@@ -540,7 +538,15 @@ static int sfp_i2c_configure(struct sfp *sfp, struct i2c_adapter *i2c)
 	sfp->read = sfp_i2c_read;
 	sfp->write = sfp_i2c_write;
 
-	i2c_mii = mdio_i2c_alloc(sfp->dev, i2c);
+	return 0;
+}
+
+static int sfp_i2c_mdiobus_create(struct sfp *sfp)
+{
+	struct mii_bus *i2c_mii;
+	int ret;
+
+	i2c_mii = mdio_i2c_alloc(sfp->dev, sfp->i2c);
 	if (IS_ERR(i2c_mii))
 		return PTR_ERR(i2c_mii);
 
@@ -558,6 +564,12 @@ static int sfp_i2c_configure(struct sfp *sfp, struct i2c_adapter *i2c)
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
@@ -1674,6 +1686,14 @@ static void sfp_sm_fault(struct sfp *sfp, unsigned int next_state, bool warn)
 	}
 }
 
+static int sfp_sm_add_mdio_bus(struct sfp *sfp)
+{
+	if (sfp->mdio_protocol != MDIO_I2C_NONE)
+		return sfp_i2c_mdiobus_create(sfp);
+
+	return 0;
+}
+
 /* Probe a SFP for a PHY device if the module supports copper - the PHY
  * normally sits at I2C bus address 0x56, and may either be a clause 22
  * or clause 45 PHY.
@@ -1689,19 +1709,19 @@ static int sfp_sm_probe_for_phy(struct sfp *sfp)
 {
 	int err = 0;
 
-	switch (sfp->id.base.extended_cc) {
-	case SFF8024_ECC_10GBASE_T_SFI:
-	case SFF8024_ECC_10GBASE_T_SR:
-	case SFF8024_ECC_5GBASE_T:
-	case SFF8024_ECC_2_5GBASE_T:
-		err = sfp_sm_probe_phy(sfp, true);
+	switch (sfp->mdio_protocol) {
+	case MDIO_I2C_NONE:
 		break;
 
-	default:
-		if (sfp->id.base.e1000_base_t)
-			err = sfp_sm_probe_phy(sfp, false);
+	case MDIO_I2C_MARVELL_C22:
+		err = sfp_sm_probe_phy(sfp, false);
+		break;
+
+	case MDIO_I2C_C45:
+		err = sfp_sm_probe_phy(sfp, true);
 		break;
 	}
+
 	return err;
 }
 
@@ -2028,6 +2048,16 @@ static int sfp_sm_mod_probe(struct sfp *sfp, bool report)
 
 	sfp->tx_fault_ignore = false;
 
+	if (sfp->id.base.extended_cc == SFF8024_ECC_10GBASE_T_SFI ||
+	    sfp->id.base.extended_cc == SFF8024_ECC_10GBASE_T_SR ||
+	    sfp->id.base.extended_cc == SFF8024_ECC_5GBASE_T ||
+	    sfp->id.base.extended_cc == SFF8024_ECC_2_5GBASE_T)
+		sfp->mdio_protocol = MDIO_I2C_C45;
+	else if (sfp->id.base.e1000_base_t)
+		sfp->mdio_protocol = MDIO_I2C_MARVELL_C22;
+	else
+		sfp->mdio_protocol = MDIO_I2C_NONE;
+
 	sfp->quirk = sfp_lookup_quirk(&id);
 	if (sfp->quirk && sfp->quirk->fixup)
 		sfp->quirk->fixup(sfp);
@@ -2204,6 +2234,8 @@ static void sfp_sm_main(struct sfp *sfp, unsigned int event)
 			sfp_module_stop(sfp->sfp_bus);
 		if (sfp->mod_phy)
 			sfp_sm_phy_detach(sfp);
+		if (sfp->i2c_mii)
+			sfp_i2c_mdiobus_destroy(sfp);
 		sfp_module_tx_disable(sfp);
 		sfp_soft_stop_poll(sfp);
 		sfp_sm_next(sfp, SFP_S_DOWN, 0);
@@ -2266,6 +2298,12 @@ static void sfp_sm_main(struct sfp *sfp, unsigned int event)
 				     sfp->sm_fault_retries == N_FAULT_INIT);
 		} else if (event == SFP_E_TIMEOUT || event == SFP_E_TX_CLEAR) {
 	init_done:
+			/* Create mdiobus and start trying for PHY */
+			ret = sfp_sm_add_mdio_bus(sfp);
+			if (ret < 0) {
+				sfp_sm_next(sfp, SFP_S_FAIL, 0);
+				break;
+			}
 			sfp->sm_phy_retries = R_PHY_RETRY;
 			goto phy_probe;
 		}
diff --git a/include/linux/mdio/mdio-i2c.h b/include/linux/mdio/mdio-i2c.h
index b1d27f7cd23f..3bde1a555a49 100644
--- a/include/linux/mdio/mdio-i2c.h
+++ b/include/linux/mdio/mdio-i2c.h
@@ -11,6 +11,12 @@ struct device;
 struct i2c_adapter;
 struct mii_bus;
 
+enum mdio_i2c_proto {
+	MDIO_I2C_NONE,
+	MDIO_I2C_MARVELL_C22,
+	MDIO_I2C_C45,
+};
+
 struct mii_bus *mdio_i2c_alloc(struct device *parent, struct i2c_adapter *i2c);
 
 #endif
-- 
2.35.1

