Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3E042DB632
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 23:00:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730472AbgLOVvX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 16:51:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729624AbgLOVW4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Dec 2020 16:22:56 -0500
Received: from ssl.serverraum.org (ssl.serverraum.org [IPv6:2a01:4f8:151:8464::1:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 958FEC0617A7;
        Tue, 15 Dec 2020 13:22:13 -0800 (PST)
Received: from mwalle01.fritz.box (unknown [IPv6:2a02:810c:c200:2e91:fa59:71ff:fe9b:b851])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 1CC1A23E65;
        Tue, 15 Dec 2020 22:22:10 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1608067330;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=h+tTFTOl+An9aE5f1UZsrO1gZA1fMYbByO2ZqdIjF/o=;
        b=kkluwGMznY3/4segAHPJbTELsM7NDkN0+Xg28JsnHlBlOOEPsFbm7Mi3Yec1N2VaA6Swtb
        gWLn/Zi3xP5gBpWFfxk1u93apftWm0fHbx1xTu3+2zBsy5YgceO3MGtkIfTe/kL+HUunC5
        iPaFu6vTRb3EEb5Eh/jqVgPmF03tHYY=
From:   Michael Walle <michael@walle.cc>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Claudiu Manoil <claudiu.manoil@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alex Marginean <alexandru.marginean@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Michael Walle <michael@walle.cc>
Subject: [PATCH net-next 1/4] enetc: drop unneeded indirection
Date:   Tue, 15 Dec 2020 22:21:57 +0100
Message-Id: <20201215212200.30915-2-michael@walle.cc>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201215212200.30915-1-michael@walle.cc>
References: <20201215212200.30915-1-michael@walle.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Before commit 6517798dd343 ("enetc: Make MDIO accessors more generic and
export to include/linux/fsl") these macros actually had some benefits.
But after the commit it just makes the code hard to read. Drop the macro
indirections.

Signed-off-by: Michael Walle <michael@walle.cc>
---
 .../net/ethernet/freescale/enetc/enetc_mdio.c | 32 ++++++++-----------
 1 file changed, 14 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc_mdio.c b/drivers/net/ethernet/freescale/enetc/enetc_mdio.c
index ee0116ed4738..94fcc76dc590 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_mdio.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_mdio.c
@@ -14,21 +14,17 @@
 #define	ENETC_MDIO_DATA	0x8	/* MDIO data */
 #define	ENETC_MDIO_ADDR	0xc	/* MDIO address */
 
-static inline u32 _enetc_mdio_rd(struct enetc_mdio_priv *mdio_priv, int off)
+static inline u32 enetc_mdio_rd(struct enetc_mdio_priv *mdio_priv, int off)
 {
 	return enetc_port_rd_mdio(mdio_priv->hw, mdio_priv->mdio_base + off);
 }
 
-static inline void _enetc_mdio_wr(struct enetc_mdio_priv *mdio_priv, int off,
-				  u32 val)
+static inline void enetc_mdio_wr(struct enetc_mdio_priv *mdio_priv, int off,
+				 u32 val)
 {
 	enetc_port_wr_mdio(mdio_priv->hw, mdio_priv->mdio_base + off, val);
 }
 
-#define enetc_mdio_rd(mdio_priv, off) \
-	_enetc_mdio_rd(mdio_priv, ENETC_##off)
-#define enetc_mdio_wr(mdio_priv, off, val) \
-	_enetc_mdio_wr(mdio_priv, ENETC_##off, val)
 #define enetc_mdio_rd_reg(off)	enetc_mdio_rd(mdio_priv, off)
 
 #define MDIO_CFG_CLKDIV(x)	((((x) >> 1) & 0xff) << 8)
@@ -54,7 +50,7 @@ static int enetc_mdio_wait_complete(struct enetc_mdio_priv *mdio_priv)
 {
 	u32 val;
 
-	return readx_poll_timeout(enetc_mdio_rd_reg, MDIO_CFG, val,
+	return readx_poll_timeout(enetc_mdio_rd_reg, ENETC_MDIO_CFG, val,
 				  !(val & MDIO_CFG_BSY), 10, 10 * TIMEOUT);
 }
 
@@ -75,7 +71,7 @@ int enetc_mdio_write(struct mii_bus *bus, int phy_id, int regnum, u16 value)
 		mdio_cfg &= ~MDIO_CFG_ENC45;
 	}
 
-	enetc_mdio_wr(mdio_priv, MDIO_CFG, mdio_cfg);
+	enetc_mdio_wr(mdio_priv, ENETC_MDIO_CFG, mdio_cfg);
 
 	ret = enetc_mdio_wait_complete(mdio_priv);
 	if (ret)
@@ -83,11 +79,11 @@ int enetc_mdio_write(struct mii_bus *bus, int phy_id, int regnum, u16 value)
 
 	/* set port and dev addr */
 	mdio_ctl = MDIO_CTL_PORT_ADDR(phy_id) | MDIO_CTL_DEV_ADDR(dev_addr);
-	enetc_mdio_wr(mdio_priv, MDIO_CTL, mdio_ctl);
+	enetc_mdio_wr(mdio_priv, ENETC_MDIO_CTL, mdio_ctl);
 
 	/* set the register address */
 	if (regnum & MII_ADDR_C45) {
-		enetc_mdio_wr(mdio_priv, MDIO_ADDR, regnum & 0xffff);
+		enetc_mdio_wr(mdio_priv, ENETC_MDIO_ADDR, regnum & 0xffff);
 
 		ret = enetc_mdio_wait_complete(mdio_priv);
 		if (ret)
@@ -95,7 +91,7 @@ int enetc_mdio_write(struct mii_bus *bus, int phy_id, int regnum, u16 value)
 	}
 
 	/* write the value */
-	enetc_mdio_wr(mdio_priv, MDIO_DATA, MDIO_DATA(value));
+	enetc_mdio_wr(mdio_priv, ENETC_MDIO_DATA, MDIO_DATA(value));
 
 	ret = enetc_mdio_wait_complete(mdio_priv);
 	if (ret)
@@ -121,7 +117,7 @@ int enetc_mdio_read(struct mii_bus *bus, int phy_id, int regnum)
 		mdio_cfg &= ~MDIO_CFG_ENC45;
 	}
 
-	enetc_mdio_wr(mdio_priv, MDIO_CFG, mdio_cfg);
+	enetc_mdio_wr(mdio_priv, ENETC_MDIO_CFG, mdio_cfg);
 
 	ret = enetc_mdio_wait_complete(mdio_priv);
 	if (ret)
@@ -129,11 +125,11 @@ int enetc_mdio_read(struct mii_bus *bus, int phy_id, int regnum)
 
 	/* set port and device addr */
 	mdio_ctl = MDIO_CTL_PORT_ADDR(phy_id) | MDIO_CTL_DEV_ADDR(dev_addr);
-	enetc_mdio_wr(mdio_priv, MDIO_CTL, mdio_ctl);
+	enetc_mdio_wr(mdio_priv, ENETC_MDIO_CTL, mdio_ctl);
 
 	/* set the register address */
 	if (regnum & MII_ADDR_C45) {
-		enetc_mdio_wr(mdio_priv, MDIO_ADDR, regnum & 0xffff);
+		enetc_mdio_wr(mdio_priv, ENETC_MDIO_ADDR, regnum & 0xffff);
 
 		ret = enetc_mdio_wait_complete(mdio_priv);
 		if (ret)
@@ -141,21 +137,21 @@ int enetc_mdio_read(struct mii_bus *bus, int phy_id, int regnum)
 	}
 
 	/* initiate the read */
-	enetc_mdio_wr(mdio_priv, MDIO_CTL, mdio_ctl | MDIO_CTL_READ);
+	enetc_mdio_wr(mdio_priv, ENETC_MDIO_CTL, mdio_ctl | MDIO_CTL_READ);
 
 	ret = enetc_mdio_wait_complete(mdio_priv);
 	if (ret)
 		return ret;
 
 	/* return all Fs if nothing was there */
-	if (enetc_mdio_rd(mdio_priv, MDIO_CFG) & MDIO_CFG_RD_ER) {
+	if (enetc_mdio_rd(mdio_priv, ENETC_MDIO_CFG) & MDIO_CFG_RD_ER) {
 		dev_dbg(&bus->dev,
 			"Error while reading PHY%d reg at %d.%hhu\n",
 			phy_id, dev_addr, regnum);
 		return 0xffff;
 	}
 
-	value = enetc_mdio_rd(mdio_priv, MDIO_DATA) & 0xffff;
+	value = enetc_mdio_rd(mdio_priv, ENETC_MDIO_DATA) & 0xffff;
 
 	return value;
 }
-- 
2.20.1

