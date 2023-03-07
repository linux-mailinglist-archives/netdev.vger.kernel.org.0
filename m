Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8ECA56AE635
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 17:20:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230184AbjCGQUU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 11:20:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229998AbjCGQTr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 11:19:47 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C160973029
        for <netdev@vger.kernel.org>; Tue,  7 Mar 2023 08:19:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=9OIhci/zYM8WVXXXP4dJ8pS/3BNyD1Ofot8GqQvSd7Y=; b=ZKgefcoSAFlXoRmjV4K+i9FDl5
        Smg6/YVLkbaj5JKQ6i56+yxe/ms2AfAxyaajVYxJnepXzdqsVSQeCR8yWvUe7owvwdNWzOh52hb5n
        sfuMxO8KT34MUkf1iUv8yA08fiwU4dassnwZ/ytbEe+SD8aBurHZJM3QPaNnUl0dR11070Tsde8GD
        M5H2Pij6vbubbcIfLgZeBzyriVnABupm/S8Cyllx8ru+MX9bHgPyPXtHOI4EG7cLSbsVcK/YLpWKw
        LiR9SeFp9lVYWyPmciLaDIwM/KMqM0ACoU+sMRsJlGHb+hGe1/ADWhI/g3st0zO6q2R4pvmd1hVdq
        xBVCj3Hw==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:49550 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1pZa2G-0000n4-AJ; Tue, 07 Mar 2023 16:19:32 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1pZa2F-00DFfK-Mg; Tue, 07 Mar 2023 16:19:31 +0000
In-Reply-To: <ZAdj9qUXcHUsK7Gt@shell.armlinux.org.uk>
References: <ZAdj9qUXcHUsK7Gt@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Daniel Golle <daniel@makrotopia.org>, Felix Fietkau <nbd@nbd.name>,
        John Crispin <john@phrozen.org>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH net-next 2/4] net: mtk_eth_soc: move trgmii ddr2 check to
 probe function
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1pZa2F-00DFfK-Mg@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Tue, 07 Mar 2023 16:19:31 +0000
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If TRGMII mode is not permitted when using DDR2 mode, we should handle
that when setting up phylink's ->supported_interfaces so phylink knows
that this is not supported by the hardware. Move this check to
mtk_add_mac().

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index c63f17929ccf..1b385dfe620f 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -374,17 +374,6 @@ static int mt7621_gmac0_rgmii_adjust(struct mtk_eth *eth,
 {
 	u32 val;
 
-	/* Check DDR memory type.
-	 * Currently TRGMII mode with DDR2 memory is not supported.
-	 */
-	regmap_read(eth->ethsys, ETHSYS_SYSCFG, &val);
-	if (interface == PHY_INTERFACE_MODE_TRGMII &&
-	    val & SYSCFG_DRAM_TYPE_DDR2) {
-		dev_err(eth->dev,
-			"TRGMII mode with DDR2 memory is not supported!\n");
-		return -EOPNOTSUPP;
-	}
-
 	val = (interface == PHY_INTERFACE_MODE_TRGMII) ?
 		ETHSYS_TRGMII_MT7621_DDR_PLL : 0;
 
@@ -4333,6 +4322,7 @@ static int mtk_add_mac(struct mtk_eth *eth, struct device_node *np)
 	struct mtk_mac *mac;
 	int id, err;
 	int txqs = 1;
+	u32 val;
 
 	if (!_id) {
 		dev_err(eth->dev, "missing mac id\n");
@@ -4409,6 +4399,15 @@ static int mtk_add_mac(struct mtk_eth *eth, struct device_node *np)
 		__set_bit(PHY_INTERFACE_MODE_TRGMII,
 			  mac->phylink_config.supported_interfaces);
 
+	/* TRGMII is not permitted on MT7621 if using DDR2 */
+	if (MTK_HAS_CAPS(mac->hw->soc->caps, MTK_GMAC1_TRGMII) &&
+	    MTK_HAS_CAPS(mac->hw->soc->caps, MTK_TRGMII_MT7621_CLK)) {
+		regmap_read(eth->ethsys, ETHSYS_SYSCFG, &val);
+		if (val & SYSCFG_DRAM_TYPE_DDR2)
+			__clear_bit(PHY_INTERFACE_MODE_TRGMII,
+				    mac->phylink_config.supported_interfaces);
+	}
+
 	if (MTK_HAS_CAPS(mac->hw->soc->caps, MTK_SGMII)) {
 		__set_bit(PHY_INTERFACE_MODE_SGMII,
 			  mac->phylink_config.supported_interfaces);
-- 
2.30.2

