Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FC6A2022D1
	for <lists+netdev@lfdr.de>; Sat, 20 Jun 2020 11:22:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727883AbgFTJVq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Jun 2020 05:21:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726533AbgFTJVo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Jun 2020 05:21:44 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93839C06174E
        for <netdev@vger.kernel.org>; Sat, 20 Jun 2020 02:21:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=UpcgkCqf+ZwRMNEBVOVhOVEqCUwwLtSScWeu+WNIK+k=; b=eNaCBdGEH1DVfh9WHtK68TBcjR
        xxB66JW2Pw9iFNtgmuXKP/pzMQWCVxVCvvUt/4YFNZISWqVsocsr/cWaZFXTOLdc7MVfiSCEH3P85
        dL2PwY2GQCC3QzxYgN0sAaJAUOGVf2slhLNRdXn8wJyOTEJ/QRywuFXSpzuS0BEnIbZ7UeGf7LBGQ
        a31I0+1oXGaeTtts5GWF2xIjAhlRazKpQM/Zffg2SMhJe1GYnovK0aI8j1ixjpRZQ3Ljfh2KZ7Ptk
        3tKUaOVeQQh3yAUyu/LtMHaw6DcZICPMKWiomfRdu5yImBRKCU/oobX8bBMlTiLROXagvoS6R/9JS
        1GfFkXdg==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:49228 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jmZh0-0007Oi-I3; Sat, 20 Jun 2020 10:21:42 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jmZh0-0001Uf-A2; Sat, 20 Jun 2020 10:21:42 +0100
In-Reply-To: <20200620092047.GR1551@shell.armlinux.org.uk>
References: <20200620092047.GR1551@shell.armlinux.org.uk>
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
Message-Id: <E1jmZh0-0001Uf-A2@rmk-PC.armlinux.org.uk>
Date:   Sat, 20 Jun 2020 10:21:42 +0100
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
index 375e3c657162..22891f588c8a 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -4959,17 +4959,9 @@ static void mvpp2_xlg_config(struct mvpp2_port *port, unsigned int mode,
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
@@ -5159,10 +5151,17 @@ static void mvpp2_mac_link_up(struct phylink_config *config,
 
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

