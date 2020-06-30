Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9062320F2B0
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 12:28:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732541AbgF3K2U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 06:28:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732315AbgF3K2U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 06:28:20 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF73FC061755
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 03:28:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=DzSnXWgUABjf2oGFBkHyHwE7ni0HkRZQ1U5rSdRu1sU=; b=uczM9wyWfr6hlAXpjn4mpKgxTi
        MEpm7k1Punobu1CgnrZHFHrd56ySUc3YSavngUZNZYLOsal4p+qgustBeLo9vE7E+bxEegw/55uWq
        VybZh8NLvqI7leUeGyXuQQpRLypAKXpEbC08e64+PcsAySD2aIgYjCzWboM9n/dcxzplj1OoMiE38
        szkShfFLAh6jSGRFbZUqOED8M4Z7jDYzH6V4H/BQM77fC87cAtYTndf1uXx0R2v/qFy9OMUXraiE+
        ihJ7INDIKFqrrS5VHH6EvzYL4Y8NU1o/EOpO1peRCgO4vmJtSxGcOtEi78iNMyQORbk1YpoOi0TZU
        k17odkaQ==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:45958 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jqDUw-0000Pm-PM; Tue, 30 Jun 2020 11:28:18 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jqDUw-0004uL-Ip; Tue, 30 Jun 2020 11:28:18 +0100
In-Reply-To: <20200630102751.GA1551@shell.armlinux.org.uk>
References: <20200630102751.GA1551@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 3/3] net: dsa/bcm_sf2: move pause mode setting into
 mac_link_up()
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1jqDUw-0004uL-Ip@rmk-PC.armlinux.org.uk>
Date:   Tue, 30 Jun 2020 11:28:18 +0100
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

bcm_sf2 only appears to support pause modes on RGMII interfaces (the
enable bits are in the RGMII control register.)  Setup the pause modes
for RGMII connections.

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Tested-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/dsa/bcm_sf2.c | 23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

diff --git a/drivers/net/dsa/bcm_sf2.c b/drivers/net/dsa/bcm_sf2.c
index 062e6efad53f..45e4d40d7e25 100644
--- a/drivers/net/dsa/bcm_sf2.c
+++ b/drivers/net/dsa/bcm_sf2.c
@@ -587,18 +587,11 @@ static void bcm_sf2_sw_mac_config(struct dsa_switch *ds, int port,
 	reg = reg_readl(priv, REG_RGMII_CNTRL_P(port));
 	reg &= ~ID_MODE_DIS;
 	reg &= ~(PORT_MODE_MASK << PORT_MODE_SHIFT);
-	reg &= ~(RX_PAUSE_EN | TX_PAUSE_EN);
 
 	reg |= port_mode;
 	if (id_mode_dis)
 		reg |= ID_MODE_DIS;
 
-	if (state->pause & MLO_PAUSE_TXRX_MASK) {
-		if (state->pause & MLO_PAUSE_TX)
-			reg |= TX_PAUSE_EN;
-		reg |= RX_PAUSE_EN;
-	}
-
 	reg_writel(priv, reg, REG_RGMII_CNTRL_P(port));
 }
 
@@ -662,6 +655,22 @@ static void bcm_sf2_sw_mac_link_up(struct dsa_switch *ds, int port,
 		else
 			offset = CORE_STS_OVERRIDE_GMIIP2_PORT(port);
 
+		if (interface == PHY_INTERFACE_MODE_RGMII ||
+		    interface == PHY_INTERFACE_MODE_RGMII_TXID ||
+		    interface == PHY_INTERFACE_MODE_MII ||
+		    interface == PHY_INTERFACE_MODE_REVMII) {
+			reg = reg_readl(priv, REG_RGMII_CNTRL_P(port));
+			reg &= ~(RX_PAUSE_EN | TX_PAUSE_EN);
+
+			if (tx_pause)
+				reg |= TX_PAUSE_EN;
+			if (rx_pause)
+				reg |= RX_PAUSE_EN;
+
+			reg_writel(priv, reg, REG_RGMII_CNTRL_P(port));
+		}
+
+
 		reg = SW_OVERRIDE | LINK_STS;
 		switch (speed) {
 		case SPEED_1000:
-- 
2.20.1

