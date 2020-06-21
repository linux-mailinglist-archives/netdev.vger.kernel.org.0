Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35A7A202B19
	for <lists+netdev@lfdr.de>; Sun, 21 Jun 2020 16:38:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730230AbgFUOgm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Jun 2020 10:36:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730154AbgFUOgm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Jun 2020 10:36:42 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7CC0C061794
        for <netdev@vger.kernel.org>; Sun, 21 Jun 2020 07:36:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:Reply-To:Content-ID
        :Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:
        Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=OO7MBhIF3uuv6rDmcjDqhIxU6W1sKcos8zRQgNu+lwk=; b=XOBSC2jE7GiAhalZ9nE2EHMMO4
        p/PvP8D5gdxWYsgv9UWjPMDUV34FLnQoCxUdj4mnyRn9U4LKpMZAsPFQFNYX+zZaA7AMOMciik5XO
        A+XUaUf0lJ5b5TJbuyoGv6+xB99xJfAHoCsMHFJSLLAyVXePwyLCpjloZXMnbh/w43qPRtwOc2pjj
        B7xcIdVSYSlaigVmgGQk72vInFwP8GJbDB+hKnH2uex/+RSM2BQLwu9kHinzjir7D1N4qwMGyAFEE
        xrKtyYGwiLxY0eXKBN3lxDTmwKrj/XC18SnjSLC+GTsAVIkcaOstvV0U0/6bNjs5aQ2hIW+V2IuIq
        KRdkMxAA==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:41032 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jn15L-0007yS-EI; Sun, 21 Jun 2020 15:36:39 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jn15L-0006zk-5F; Sun, 21 Jun 2020 15:36:39 +0100
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Felix Fietkau <nbd@openwrt.org>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH net-next] net: mtk_eth_soc: use resolved link config in
 mac_link_up()
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1jn15L-0006zk-5F@rmk-PC.armlinux.org.uk>
Date:   Sun, 21 Jun 2020 15:36:39 +0100
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert the mtk_eth_soc driver to use the finalised link parameters in
mac_link_up() rather than the parameters in mac_config().

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
This is my untested stab at converting mtk_eth_soc.c to use the state
passed in via mac_link_up() rather than mac_config(). Please test and
report back. Thanks.

 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 45 ++++++++++++---------
 1 file changed, 25 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index f6a1f8666f95..20db302d31ce 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -344,29 +344,9 @@ static void mtk_mac_config(struct phylink_config *config, unsigned int mode,
 	/* Setup gmac */
 	mcr_cur = mtk_r32(mac->hw, MTK_MAC_MCR(mac->id));
 	mcr_new = mcr_cur;
-	mcr_new &= ~(MAC_MCR_SPEED_100 | MAC_MCR_SPEED_1000 |
-		     MAC_MCR_FORCE_DPX | MAC_MCR_FORCE_TX_FC |
-		     MAC_MCR_FORCE_RX_FC);
 	mcr_new |= MAC_MCR_MAX_RX_1536 | MAC_MCR_IPG_CFG | MAC_MCR_FORCE_MODE |
 		   MAC_MCR_BACKOFF_EN | MAC_MCR_BACKPR_EN | MAC_MCR_FORCE_LINK;
 
-	switch (state->speed) {
-	case SPEED_2500:
-	case SPEED_1000:
-		mcr_new |= MAC_MCR_SPEED_1000;
-		break;
-	case SPEED_100:
-		mcr_new |= MAC_MCR_SPEED_100;
-		break;
-	}
-	if (state->duplex == DUPLEX_FULL) {
-		mcr_new |= MAC_MCR_FORCE_DPX;
-		if (state->pause & MLO_PAUSE_TX)
-			mcr_new |= MAC_MCR_FORCE_TX_FC;
-		if (state->pause & MLO_PAUSE_RX)
-			mcr_new |= MAC_MCR_FORCE_RX_FC;
-	}
-
 	/* Only update control register when needed! */
 	if (mcr_new != mcr_cur)
 		mtk_w32(mac->hw, mcr_new, MTK_MAC_MCR(mac->id));
@@ -443,6 +423,31 @@ static void mtk_mac_link_up(struct phylink_config *config,
 					   phylink_config);
 	u32 mcr = mtk_r32(mac->hw, MTK_MAC_MCR(mac->id));
 
+	mcr &= ~(MAC_MCR_SPEED_100 | MAC_MCR_SPEED_1000 |
+		 MAC_MCR_FORCE_DPX | MAC_MCR_FORCE_TX_FC |
+		 MAC_MCR_FORCE_RX_FC);
+
+	/* Configure speed */
+	switch (speed) {
+	case SPEED_2500:
+	case SPEED_1000:
+		mcr |= MAC_MCR_SPEED_1000;
+		break;
+	case SPEED_100:
+		mcr |= MAC_MCR_SPEED_100;
+		break;
+	}
+
+	/* Configure duplex */
+	if (duplex == DUPLEX_FULL)
+		mcr |= MAC_MCR_FORCE_DPX;
+
+	/* Configure pause modes - phylink will avoid these for half duplex */
+	if (tx_pause)
+		mcr |= MAC_MCR_FORCE_TX_FC;
+	if (rx_pause)
+		mcr |= MAC_MCR_FORCE_RX_FC;
+
 	mcr |= MAC_MCR_TX_EN | MAC_MCR_RX_EN;
 	mtk_w32(mac->hw, mcr, MTK_MAC_MCR(mac->id));
 }
-- 
2.20.1

