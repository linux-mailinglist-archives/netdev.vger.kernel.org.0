Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6681B60F8AF
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 15:12:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235415AbiJ0NMc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 09:12:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236078AbiJ0NLs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 09:11:48 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C11BA78BCA
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 06:11:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=xI8DaM29+IDXZMB5FejDKAyekS110HTrnSErVmAbFjc=; b=Wt53qdcyRJXWUb4XOMkPnIdoat
        IN4ruydk37AWUU0kt124BQ0QWM956CVHg4/649NphzVOk8++pROsE/TmHMpcvFBsOOFTGVr9OtqWB
        08xP/zEMx3JmiJX3wXl+o8++GSgThU8GCWOrNJswjXwnNHJkJWpBOXdd5l7sh5evD5Yn0Nr3ZwHc/
        Vy5wLoH2Q3s9BsH+dFwHk8eg8aV/PL5bQ3Zh5JzePO7x14jhFqocygcnmmCUFDbE+A4JEIlPFLSFB
        y+LHoazDf5ATgalkHtEeeiotr8pzDx8POuTOfFEiiIy8zHCIbtNQBaMf8TaF2uveTUcjsDelPUraf
        eiDDqKTw==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:36756 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1oo2f6-0006z5-SX; Thu, 27 Oct 2022 14:11:08 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1oo2f6-00HF8E-8U; Thu, 27 Oct 2022 14:11:08 +0100
In-Reply-To: <Y1qDMw+DJLAJHT40@shell.armlinux.org.uk>
References: <Y1qDMw+DJLAJHT40@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Frank Wunderlich <frank-w@public-files.de>
Cc:     Eric Dumazet <edumazet@google.com>, Felix Fietkau <nbd@nbd.name>,
        John Crispin <john@phrozen.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Sean Wang <sean.wang@mediatek.com>
Subject: [PATCH net-next 07/11] net: mtk_eth_soc: move PHY power up
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1oo2f6-00HF8E-8U@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Thu, 27 Oct 2022 14:11:08 +0100
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The PHY power up is common to both configuration paths, so move it into
the parent function. We need to do this for all serdes modes.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/ethernet/mediatek/mtk_sgmii.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_sgmii.c b/drivers/net/ethernet/mediatek/mtk_sgmii.c
index d26a0ba2e47b..63b25574caac 100644
--- a/drivers/net/ethernet/mediatek/mtk_sgmii.c
+++ b/drivers/net/ethernet/mediatek/mtk_sgmii.c
@@ -45,9 +45,6 @@ static void mtk_pcs_setup_mode_an(struct mtk_pcs *mpcs)
 
 	regmap_update_bits(mpcs->regmap, SGMSYS_PCS_CONTROL_1,
 			   SGMII_AN_RESTART, SGMII_AN_RESTART);
-
-	regmap_update_bits(mpcs->regmap, SGMSYS_QPHY_PWR_STATE_CTRL,
-			   SGMII_PHYA_PWD, 0);
 }
 
 /* For 1000BASE-X and 2500BASE-X interface modes, which operate at a
@@ -72,10 +69,6 @@ static void mtk_pcs_setup_mode_force(struct mtk_pcs *mpcs,
 	regmap_update_bits(mpcs->regmap, SGMSYS_SGMII_MODE,
 			   SGMII_IF_MODE_MASK & ~SGMII_DUPLEX_FULL,
 			   SGMII_SPEED_1000);
-
-	/* Release PHYA power down state */
-	regmap_update_bits(mpcs->regmap, SGMSYS_QPHY_PWR_STATE_CTRL,
-			   SGMII_PHYA_PWD, 0);
 }
 
 static int mtk_pcs_config(struct phylink_pcs *pcs, unsigned int mode,
@@ -91,6 +84,10 @@ static int mtk_pcs_config(struct phylink_pcs *pcs, unsigned int mode,
 	else if (phylink_autoneg_inband(mode))
 		mtk_pcs_setup_mode_an(mpcs);
 
+	/* Release PHYA power down state */
+	regmap_update_bits(mpcs->regmap, SGMSYS_QPHY_PWR_STATE_CTRL,
+			   SGMII_PHYA_PWD, 0);
+
 	return 0;
 }
 
-- 
2.30.2

