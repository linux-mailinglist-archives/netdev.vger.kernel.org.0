Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 621496A1C3E
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 13:36:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229998AbjBXMga (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Feb 2023 07:36:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229602AbjBXMg3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Feb 2023 07:36:29 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E728567E21
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 04:36:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=9OIhci/zYM8WVXXXP4dJ8pS/3BNyD1Ofot8GqQvSd7Y=; b=O/bOruc92YWbZ9DyTj5xYI6z8t
        lHDHvCMpc232LTY/oy4+PJ6F8luxZYxz5iVrGzWqlMK1D7OvdVXH2/KoMFAnIIPR/DCX/xhgO+Dh6
        xIaJTS4Oi4h4FB20NfmBgstq3u5PB3x4JgaUn5OteTUgn46MKYMdvr87/tPrUfCLdyS47LQ3xyC42
        2T/vKAsAAbV3fWx8xOSule8Ms6QpQW6SabtOtmrpI9y3DN3MD2LrTtOtMf5grpbZ9SMsGPD8/4lw3
        4ZwQLxRyEaPvhsfBRK31S+YmLFvcivmoVhRMLjBpt2KHN6dXjmgr/AY1p2n8EtI9YlLBl3nye19GJ
        ZE27T0PQ==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:42320 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1pVXJB-0000dR-Bv; Fri, 24 Feb 2023 12:36:17 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1pVXJA-00CTAX-NA; Fri, 24 Feb 2023 12:36:16 +0000
In-Reply-To: <Y/ivHGroIVTe4YP/@shell.armlinux.org.uk>
References: <Y/ivHGroIVTe4YP/@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Daniel Golle <daniel@makrotopia.org>,
        Daniel Golle <daniel@makrotopia.org>
Cc:     Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH RFC net-next 2/4] net: mtk_eth_soc: move trgmii ddr2 check to
 probe function
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1pVXJA-00CTAX-NA@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Fri, 24 Feb 2023 12:36:16 +0000
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
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

