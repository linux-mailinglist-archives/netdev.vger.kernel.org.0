Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 190582FBB53
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 16:38:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389695AbhASPhG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 10:37:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389393AbhASPgn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jan 2021 10:36:43 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AC8BC0613C1
        for <netdev@vger.kernel.org>; Tue, 19 Jan 2021 07:36:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=j1MrpyViz6YngU5WVsNH1qztY92ET4WNz2XQl1bDY2s=; b=PTUpZr5s1wQDMWKcRVdk8lFiCd
        Va/l2fdgwhY5dzSLdkVbCcWkISsvPO/OkKHYzyj+WSfUzWF+aJA6jDoTFxgP4Musrd18AIbnGQY4A
        n2iZaXCBUODTsKmvMruGQavCeOtVdgNJoEJeEp1uzpPCZc1pBVbOvuxGQhicjgfrVRevUukEuwmRt
        i63VlVYCACySjG2BIXN7la/kO/VxYvnlzrsylf7Us2rTQdRGX6FhFI08fM1X3VTP8XcC7He2CMm5V
        6zrLEJFjDmmehJAJk1f2nfRKyJKvd+3BPpZPn4YD6ksDibtRkE4lrS9+rQwkjTnhhETkw+AJH5UgV
        gLsJOoUg==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:38342 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1l1t31-0007cI-0t; Tue, 19 Jan 2021 15:35:59 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1l1t30-0005VL-Qx; Tue, 19 Jan 2021 15:35:58 +0000
In-Reply-To: <20210119153545.GK1551@shell.armlinux.org.uk>
References: <20210119153545.GK1551@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ioana Radulescu <ruxandra.radulescu@nxp.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH net-next 1/3] net: pcs: add pcs-lynx 1000BASE-X support
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1l1t30-0005VL-Qx@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Tue, 19 Jan 2021 15:35:58 +0000
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for 1000BASE-X to pcs-lynx for the LX2160A.

This commit prepares the ground work for allowing 1G fiber connections
to be used with DPAA2 on the SolidRun CEX7 platforms.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/pcs/pcs-lynx.c | 36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/drivers/net/pcs/pcs-lynx.c b/drivers/net/pcs/pcs-lynx.c
index 62bb9272dcb2..af36cd647bf5 100644
--- a/drivers/net/pcs/pcs-lynx.c
+++ b/drivers/net/pcs/pcs-lynx.c
@@ -11,6 +11,7 @@
 #define LINK_TIMER_VAL(ns)		((u32)((ns) / SGMII_CLOCK_PERIOD_NS))
 
 #define SGMII_AN_LINK_TIMER_NS		1600000 /* defined by SGMII spec */
+#define IEEE8023_LINK_TIMER_NS		10000000
 
 #define LINK_TIMER_LO			0x12
 #define LINK_TIMER_HI			0x13
@@ -83,6 +84,7 @@ static void lynx_pcs_get_state(struct phylink_pcs *pcs,
 	struct lynx_pcs *lynx = phylink_pcs_to_lynx(pcs);
 
 	switch (state->interface) {
+	case PHY_INTERFACE_MODE_1000BASEX:
 	case PHY_INTERFACE_MODE_SGMII:
 	case PHY_INTERFACE_MODE_QSGMII:
 		phylink_mii_c22_pcs_get_state(lynx->mdio, state);
@@ -108,6 +110,30 @@ static void lynx_pcs_get_state(struct phylink_pcs *pcs,
 		state->link, state->an_enabled, state->an_complete);
 }
 
+static int lynx_pcs_config_1000basex(struct mdio_device *pcs,
+				     unsigned int mode,
+				     const unsigned long *advertising)
+{
+	struct mii_bus *bus = pcs->bus;
+	int addr = pcs->addr;
+	u32 link_timer;
+	int err;
+
+	link_timer = LINK_TIMER_VAL(IEEE8023_LINK_TIMER_NS);
+	mdiobus_write(bus, addr, LINK_TIMER_LO, link_timer & 0xffff);
+	mdiobus_write(bus, addr, LINK_TIMER_HI, link_timer >> 16);
+
+	err = mdiobus_modify(bus, addr, IF_MODE,
+			     IF_MODE_SGMII_EN | IF_MODE_USE_SGMII_AN,
+			     0);
+	if (err)
+		return err;
+
+	return phylink_mii_c22_pcs_config(pcs, mode,
+					  PHY_INTERFACE_MODE_1000BASEX,
+					  advertising);
+}
+
 static int lynx_pcs_config_sgmii(struct mdio_device *pcs, unsigned int mode,
 				 const unsigned long *advertising)
 {
@@ -163,6 +189,8 @@ static int lynx_pcs_config(struct phylink_pcs *pcs, unsigned int mode,
 	struct lynx_pcs *lynx = phylink_pcs_to_lynx(pcs);
 
 	switch (ifmode) {
+	case PHY_INTERFACE_MODE_1000BASEX:
+		return lynx_pcs_config_1000basex(lynx->mdio, mode, advertising);
 	case PHY_INTERFACE_MODE_SGMII:
 	case PHY_INTERFACE_MODE_QSGMII:
 		return lynx_pcs_config_sgmii(lynx->mdio, mode, advertising);
@@ -185,6 +213,13 @@ static int lynx_pcs_config(struct phylink_pcs *pcs, unsigned int mode,
 	return 0;
 }
 
+static void lynx_pcs_an_restart(struct phylink_pcs *pcs)
+{
+	struct lynx_pcs *lynx = phylink_pcs_to_lynx(pcs);
+
+	phylink_mii_c22_pcs_an_restart(lynx->mdio);
+}
+
 static void lynx_pcs_link_up_sgmii(struct mdio_device *pcs, unsigned int mode,
 				   int speed, int duplex)
 {
@@ -290,6 +325,7 @@ static void lynx_pcs_link_up(struct phylink_pcs *pcs, unsigned int mode,
 static const struct phylink_pcs_ops lynx_pcs_phylink_ops = {
 	.pcs_get_state = lynx_pcs_get_state,
 	.pcs_config = lynx_pcs_config,
+	.pcs_an_restart = lynx_pcs_an_restart,
 	.pcs_link_up = lynx_pcs_link_up,
 };
 
-- 
2.20.1

