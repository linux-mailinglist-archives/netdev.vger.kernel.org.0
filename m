Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42AB320F2AF
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 12:28:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732526AbgF3K2P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 06:28:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732315AbgF3K2P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 06:28:15 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8BA5C061755
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 03:28:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=ftZlwWjxrKhWI3Ja/ESxl19UtT5ffviXHwTEEk4qcNE=; b=LvMhM55gpe5g9BhSHlHLlDUXi7
        atuAFr8ZxVDa8mOqFjjPp9i9+d3o/gztHLfaYwzxBH5j7Fkmofj2Wgbgw0S6mJtniogLyOfuEj3RS
        F/dDz3OBcHtM0M6TWADbEg8YQ0xhn9ctWHvW/FEJu3BZ3Ej3rDpIrHoNNxrd8jsy7yXrDv2YuSicm
        F0KBpD/yUcN5rT/JV2qzaQ1STprWuXry9+uQVmm2BwYUpm3BeAscwimhEqwJ5OX8bI3kUHIHx5YLn
        jDNX2kzICNyiyqzgQcp9eCfCMii8AgCqEwqLQVcB2Bj+Y3NZhz39jypw0vvEU1ssj3w7zWZl9u+dG
        j5bisjww==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:45954 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jqDUr-0000Pc-Lp; Tue, 30 Jun 2020 11:28:13 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jqDUr-0004u8-E9; Tue, 30 Jun 2020 11:28:13 +0100
In-Reply-To: <20200630102751.GA1551@shell.armlinux.org.uk>
References: <20200630102751.GA1551@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 2/3] net: dsa/bcm_sf2: move speed/duplex forcing to
 mac_link_up()
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1jqDUr-0004u8-E9@rmk-PC.armlinux.org.uk>
Date:   Tue, 30 Jun 2020 11:28:13 +0100
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert the bcm_sf2 to use the finalised speed and duplex in its
mac_link_up() call rather than the parameters in mac_config().

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Tested-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/dsa/bcm_sf2.c | 43 +++++++++++++++------------------------
 1 file changed, 16 insertions(+), 27 deletions(-)

diff --git a/drivers/net/dsa/bcm_sf2.c b/drivers/net/dsa/bcm_sf2.c
index 5a8759d2de6c..062e6efad53f 100644
--- a/drivers/net/dsa/bcm_sf2.c
+++ b/drivers/net/dsa/bcm_sf2.c
@@ -558,16 +558,11 @@ static void bcm_sf2_sw_mac_config(struct dsa_switch *ds, int port,
 {
 	struct bcm_sf2_priv *priv = bcm_sf2_to_priv(ds);
 	u32 id_mode_dis = 0, port_mode;
-	u32 reg, offset;
+	u32 reg;
 
 	if (port == core_readl(priv, CORE_IMP0_PRT_ID))
 		return;
 
-	if (priv->type == BCM7445_DEVICE_ID)
-		offset = CORE_STS_OVERRIDE_GMIIP_PORT(port);
-	else
-		offset = CORE_STS_OVERRIDE_GMIIP2_PORT(port);
-
 	switch (state->interface) {
 	case PHY_INTERFACE_MODE_RGMII:
 		id_mode_dis = 1;
@@ -582,8 +577,8 @@ static void bcm_sf2_sw_mac_config(struct dsa_switch *ds, int port,
 		port_mode = EXT_REVMII;
 		break;
 	default:
-		/* all other PHYs: internal and MoCA */
-		goto force_link;
+		/* Nothing required for all other PHYs: internal and MoCA */
+		return;
 	}
 
 	/* Clear id_mode_dis bit, and the existing port mode, let
@@ -605,23 +600,6 @@ static void bcm_sf2_sw_mac_config(struct dsa_switch *ds, int port,
 	}
 
 	reg_writel(priv, reg, REG_RGMII_CNTRL_P(port));
-
-force_link:
-	/* Force link settings detected from the PHY */
-	reg = SW_OVERRIDE;
-	switch (state->speed) {
-	case SPEED_1000:
-		reg |= SPDSTS_1000 << SPEED_SHIFT;
-		break;
-	case SPEED_100:
-		reg |= SPDSTS_100 << SPEED_SHIFT;
-		break;
-	}
-
-	if (state->duplex == DUPLEX_FULL)
-		reg |= DUPLX_MODE;
-
-	core_writel(priv, reg, offset);
 }
 
 static void bcm_sf2_sw_mac_link_set(struct dsa_switch *ds, int port,
@@ -684,8 +662,19 @@ static void bcm_sf2_sw_mac_link_up(struct dsa_switch *ds, int port,
 		else
 			offset = CORE_STS_OVERRIDE_GMIIP2_PORT(port);
 
-		reg = core_readl(priv, offset);
-		reg |= LINK_STS;
+		reg = SW_OVERRIDE | LINK_STS;
+		switch (speed) {
+		case SPEED_1000:
+			reg |= SPDSTS_1000 << SPEED_SHIFT;
+			break;
+		case SPEED_100:
+			reg |= SPDSTS_100 << SPEED_SHIFT;
+			break;
+		}
+
+		if (duplex == DUPLEX_FULL)
+			reg |= DUPLX_MODE;
+
 		core_writel(priv, reg, offset);
 	}
 
-- 
2.20.1

