Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 141B01FF70A
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 17:39:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731536AbgFRPjF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 11:39:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727841AbgFRPjD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 11:39:03 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A13EEC06174E
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 08:39:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=QTa5f93tbYxSvSq6YqLnjz9WH6R291Jz9y5DV+lHV98=; b=Ex4bysbFmhxvfVaDOQg/gcpQzy
        Md/2i8b9xNojMi2rIVxmbbYpwmXTbs+B9HCw3EMHzW1cE4OQqFotpMXmjEVRFFplkEAT43Adh4ntU
        YU7ZW3KjbrJTPIhERMGyR8hDT7JNWYStVq/jKHTAtArZet3nmX0bXA2LiRaMV4fgBQfG46ZZClDqN
        Jr6w4cNwknr8VXCbAirjNdXG4zp7436pUc9hmBLrqOf6wIvPq9AaZiWveNJ5M7Unr2fNmsfSmPs8r
        KgX3WF6XdQU/QMo7d/xrOD6+gMO35iBb9vKAf/9XlZnsjbNsbzCq+zWXDvaQddznQpM9k3fZKjaQl
        +wvg4i/w==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:38270 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jlwd4-0005IT-5K; Thu, 18 Jun 2020 16:39:02 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jlwd3-0005I8-UI; Thu, 18 Jun 2020 16:39:01 +0100
In-Reply-To: <20200618153818.GD1551@shell.armlinux.org.uk>
References: <20200618153818.GD1551@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Antoine Tenart <antoine.tenart@bootlin.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH net-next 4/4] net: mvpp2: set xlg flow control in
 mvpp2_mac_link_up()
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1jlwd3-0005I8-UI@rmk-PC.armlinux.org.uk>
Date:   Thu, 18 Jun 2020 16:39:01 +0100
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Set the flow control settings in mvpp2_mac_link_up() for 10G links
just as we do for 1G and slower links. This is now the preferred
location.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 .../net/ethernet/marvell/mvpp2/mvpp2_main.c   | 23 +++++++++----------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index 9edd8fbf18a6..1eb5652cd674 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -4960,17 +4960,9 @@ static void mvpp2_xlg_config(struct mvpp2_port *port, unsigned int mode,
 {
 	u32 val;
 
-	val = MVPP22_XLG_CTRL0_MAC_RESET_DIS;
-	if (state->pause & MLO_PAUSE_TX)
-		val |= MVPP22_XLG_CTRL0_TX_FLOW_CTRL_EN;
-
-	if (state->pause & MLO_PAUSE_RX)
-		val |= MVPP22_XLG_CTRL0_RX_FLOW_CTRL_EN;
-
 	mvpp2_modify(port->base + MVPP22_XLG_CTRL0_REG,
-		     MVPP22_XLG_CTRL0_MAC_RESET_DIS |
-		     MVPP22_XLG_CTRL0_TX_FLOW_CTRL_EN |
-		     MVPP22_XLG_CTRL0_RX_FLOW_CTRL_EN, val);
+		     MVPP22_XLG_CTRL0_MAC_RESET_DIS,
+		     MVPP22_XLG_CTRL0_MAC_RESET_DIS);
 	mvpp2_modify(port->base + MVPP22_XLG_CTRL4_REG,
 		     MVPP22_XLG_CTRL4_MACMODSELECT_GMAC |
 		     MVPP22_XLG_CTRL4_EN_IDLE_CHECK |
@@ -5160,10 +5152,17 @@ static void mvpp2_mac_link_up(struct phylink_config *config,
 
 	if (mvpp2_is_xlg(interface)) {
 		if (!phylink_autoneg_inband(mode)) {
+			val = MVPP22_XLG_CTRL0_FORCE_LINK_PASS;
+			if (tx_pause)
+				val |= MVPP22_XLG_CTRL0_TX_FLOW_CTRL_EN;
+			if (rx_pause)
+				val |= MVPP22_XLG_CTRL0_RX_FLOW_CTRL_EN;
+
 			mvpp2_modify(port->base + MVPP22_XLG_CTRL0_REG,
 				     MVPP22_XLG_CTRL0_FORCE_LINK_DOWN |
-				     MVPP22_XLG_CTRL0_FORCE_LINK_PASS,
-				     MVPP22_XLG_CTRL0_FORCE_LINK_PASS);
+				     MVPP22_XLG_CTRL0_FORCE_LINK_PASS |
+				     MVPP22_XLG_CTRL0_TX_FLOW_CTRL_EN |
+				     MVPP22_XLG_CTRL0_RX_FLOW_CTRL_EN, val);
 		}
 	} else {
 		if (!phylink_autoneg_inband(mode)) {
-- 
2.20.1

