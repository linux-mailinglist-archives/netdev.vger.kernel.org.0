Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B211860F8B0
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 15:12:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233548AbiJ0NMe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 09:12:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235576AbiJ0NLt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 09:11:49 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EF2177566
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 06:11:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=XEsr6JdL5xo8xL/pVM9/e/VJ0yZE5nTVNcivYVm6JRU=; b=OzOhu6OcYxNRPW6o76nWBb9VQ4
        03Jeq4CPB1RfzkBIHUmzcFytlMTsrPpl+2CfmXHIM/eqbzpQvHSVzvtquo94bd//Gd0B6P9WR6N7X
        x7WC2Red7DoyIpTepUtb1ecYpep+nvdbF2zxrH9jX7nRpYJGxtYuyRr0HWE/uA19TEC+gZJAvIoGo
        0cNlmrfOaxDyNjQ6jFb3WCl++XwX06Z6uHZF6Y6t6PN6sULn7sPbld3/0rZ2u3XEa/98UK4BnrrmJ
        OEUkW0DOauzbYG0ay0BjQ9LskW/NC4FUROfOwcSmBLj7RrGonVxM05dsVdwzpVzJpKm44gik/NxsX
        arrQllzw==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:33334 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1oo2fB-0006zL-Vc; Thu, 27 Oct 2022 14:11:13 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1oo2fB-00HF8K-CV; Thu, 27 Oct 2022 14:11:13 +0100
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
Subject: [PATCH net-next 08/11] net: mtk_eth_soc: move interface speed
 selection
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1oo2fB-00HF8K-CV@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Thu, 27 Oct 2022 14:11:13 +0100
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move the selection of the underlying interface speed to the pcs_config
function, so we always program the interface speed.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/ethernet/mediatek/mtk_sgmii.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_sgmii.c b/drivers/net/ethernet/mediatek/mtk_sgmii.c
index 63b25574caac..c590d5847e2e 100644
--- a/drivers/net/ethernet/mediatek/mtk_sgmii.c
+++ b/drivers/net/ethernet/mediatek/mtk_sgmii.c
@@ -53,14 +53,6 @@ static void mtk_pcs_setup_mode_an(struct mtk_pcs *mpcs)
 static void mtk_pcs_setup_mode_force(struct mtk_pcs *mpcs,
 				     phy_interface_t interface)
 {
-	unsigned int rgc3;
-
-	if (interface == PHY_INTERFACE_MODE_2500BASEX)
-		rgc3 = RG_PHY_SPEED_3_125G;
-
-	regmap_update_bits(mpcs->regmap, mpcs->ana_rgc3,
-			   RG_PHY_SPEED_3_125G, rgc3);
-
 	/* Disable SGMII AN */
 	regmap_update_bits(mpcs->regmap, SGMSYS_PCS_CONTROL_1,
 			   SGMII_AN_ENABLE, 0);
@@ -77,6 +69,16 @@ static int mtk_pcs_config(struct phylink_pcs *pcs, unsigned int mode,
 			  bool permit_pause_to_mac)
 {
 	struct mtk_pcs *mpcs = pcs_to_mtk_pcs(pcs);
+	unsigned int rgc3;
+
+	if (interface == PHY_INTERFACE_MODE_2500BASEX)
+		rgc3 = RG_PHY_SPEED_3_125G;
+	else
+		rgc3 = 0;
+
+	/* Configure the underlying interface speed */
+	regmap_update_bits(mpcs->regmap, mpcs->ana_rgc3,
+			   RG_PHY_SPEED_3_125G, rgc3);
 
 	/* Setup SGMIISYS with the determined property */
 	if (interface != PHY_INTERFACE_MODE_SGMII)
-- 
2.30.2

