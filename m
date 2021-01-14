Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A79D02F5A01
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 05:46:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726897AbhANEof (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 23:44:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:34872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726644AbhANEo3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Jan 2021 23:44:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4070F23976;
        Thu, 14 Jan 2021 04:43:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610599428;
        bh=tosZN6YHVNto1dqqDrDqAohbGtB+J/j1DfbuxP4Ybq8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dt6DTAyiIBq2F8wv7AE+lI9qSHA6soNytPHLidd7CaFOMdcPAgpKAFvQzamEuKwD+
         icTVIp8hWThJDljtJ9I4g0ySIrUVe1V2BgXrXoYQgK/VV01fNU69qQveo076LHYrHY
         fRgnpfReDng8IioH5A4kU5xZXudlgeL3kvkH1aY+dyi35ObjE3lD6gaIKgB9cfm6oj
         LWZlGNREP5XR0z/RBSB9RifupStoAAeol22W69PogScXIzZIOL0l8BmWZ061iZOol4
         DhGCHnm10ozS2/yTHX+P24hbNJvB4znBpvZ9pAVhXWiw/HyIlOKNaIZWdQ2UVGsh9v
         oiYVV8jugkpBw==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org
Cc:     Russell King <rmk+kernel@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>,
        davem@davemloft.net, pali@kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH net-next v5 4/5] net: sfp: create/destroy I2C mdiobus before PHY probe/after PHY release
Date:   Thu, 14 Jan 2021 05:43:30 +0100
Message-Id: <20210114044331.5073-5-kabel@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210114044331.5073-1-kabel@kernel.org>
References: <20210114044331.5073-1-kabel@kernel.org>
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
Reviewed-by: Pali Rohár <pali@kernel.org>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/sfp.c | 30 ++++++++++++++++++++++++++----
 1 file changed, 26 insertions(+), 4 deletions(-)

diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index fac5407c4b87..d1b655f805ab 100644
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
@@ -413,9 +414,6 @@ static int sfp_i2c_write(struct sfp *sfp, bool a2, u8 dev_addr, void *buf,
 
 static int sfp_i2c_configure(struct sfp *sfp, struct i2c_adapter *i2c)
 {
-	struct mii_bus *i2c_mii;
-	int ret;
-
 	if (!i2c_check_functionality(i2c, I2C_FUNC_I2C))
 		return -EINVAL;
 
@@ -423,7 +421,15 @@ static int sfp_i2c_configure(struct sfp *sfp, struct i2c_adapter *i2c)
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
 
@@ -441,6 +447,12 @@ static int sfp_i2c_configure(struct sfp *sfp, struct i2c_adapter *i2c)
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
@@ -1881,6 +1893,8 @@ static int sfp_sm_mod_probe(struct sfp *sfp, bool report)
 	else
 		sfp->module_t_start_up = T_START_UP;
 
+	sfp->mdio_protocol = MDIO_I2C_DEFAULT;
+
 	return 0;
 }
 
@@ -2051,6 +2065,8 @@ static void sfp_sm_main(struct sfp *sfp, unsigned int event)
 			sfp_module_stop(sfp->sfp_bus);
 		if (sfp->mod_phy)
 			sfp_sm_phy_detach(sfp);
+		if (sfp->i2c_mii)
+			sfp_i2c_mdiobus_destroy(sfp);
 		sfp_module_tx_disable(sfp);
 		sfp_soft_stop_poll(sfp);
 		sfp_sm_next(sfp, SFP_S_DOWN, 0);
@@ -2113,6 +2129,12 @@ static void sfp_sm_main(struct sfp *sfp, unsigned int event)
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

