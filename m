Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 216A552BDC9
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 17:25:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238857AbiEROzW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 10:55:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238846AbiEROzT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 10:55:19 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DAF21C104
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 07:55:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=qTR7tguZVqWTKHqaxpxfr1hVmkrP0o67/WVbuFXV1sM=; b=ic4dponEBLDBKoqgvCbw2Q72/B
        TVoei6PwXZnU7BsfxJkd7+cGmZ1qPcNktn5UwjxIfnxTB0eDQ8hfvEADCxfor7IfJkBIxbC51bKa5
        D+HEMlJsSriH+7nDP5IzGvuEgUXRQyE+/phWBX20gb+NjtBPECVRwF8YSZ4NCgt32JvlLgpdC+7qy
        SqttYay2LBExKc+R6baq7LAFjkmfxJmE2VKeyeQXYPcOcM5p4ZcUW1zl7dpJ8FZBGltPYdG7WfWLP
        pnBnX/QO7g4vXgOES1HEU/oCxZYftpoiVqrOQRTygKgluDCzNsiD8K+Chj8yVkKhX59bqUfdOIluQ
        gQ7UHTog==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:38626 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1nrL4y-0002GK-Q6; Wed, 18 May 2022 15:55:13 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1nrL4y-00AM5R-NM; Wed, 18 May 2022 15:55:12 +0100
In-Reply-To: <YoUIX+BN/ZbyXzTT@shell.armlinux.org.uk>
References: <YoUIX+BN/ZbyXzTT@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Eric Dumazet <edumazet@google.com>
Subject: [PATCH net-next 09/12] net: mtk_eth_soc: move MAC_MCR setting to
 mac_finish()
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1nrL4y-00AM5R-NM@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Wed, 18 May 2022 15:55:12 +0100
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move the setting of the MTK_MAC_MCR register from the end of mac_config
into the phylink mac_finish() method, to keep it as the very last write
that is done during configuration.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 33 ++++++++++++++-------
 1 file changed, 22 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index 211457a8831d..d9947faa2cd3 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -269,8 +269,8 @@ static void mtk_mac_config(struct phylink_config *config, unsigned int mode,
 	struct mtk_mac *mac = container_of(config, struct mtk_mac,
 					   phylink_config);
 	struct mtk_eth *eth = mac->hw;
-	u32 mcr_cur, mcr_new, sid, i;
 	int val, ge_mode, err = 0;
+	u32 sid, i;
 
 	/* MT76x8 has no hardware settings between for the MAC */
 	if (!MTK_HAS_CAPS(eth->soc->caps, MTK_SOC_MT7628) &&
@@ -408,16 +408,6 @@ static void mtk_mac_config(struct phylink_config *config, unsigned int mode,
 		return;
 	}
 
-	/* Setup gmac */
-	mcr_cur = mtk_r32(mac->hw, MTK_MAC_MCR(mac->id));
-	mcr_new = mcr_cur;
-	mcr_new |= MAC_MCR_IPG_CFG | MAC_MCR_FORCE_MODE |
-		   MAC_MCR_BACKOFF_EN | MAC_MCR_BACKPR_EN | MAC_MCR_FORCE_LINK;
-
-	/* Only update control register when needed! */
-	if (mcr_new != mcr_cur)
-		mtk_w32(mac->hw, mcr_new, MTK_MAC_MCR(mac->id));
-
 	return;
 
 err_phy:
@@ -430,6 +420,26 @@ static void mtk_mac_config(struct phylink_config *config, unsigned int mode,
 		mac->id, phy_modes(state->interface), err);
 }
 
+static int mtk_mac_finish(struct phylink_config *config, unsigned int mode,
+			  phy_interface_t interface)
+{
+	struct mtk_mac *mac = container_of(config, struct mtk_mac,
+					   phylink_config);
+	u32 mcr_cur, mcr_new;
+
+	/* Setup gmac */
+	mcr_cur = mtk_r32(mac->hw, MTK_MAC_MCR(mac->id));
+	mcr_new = mcr_cur;
+	mcr_new |= MAC_MCR_IPG_CFG | MAC_MCR_FORCE_MODE |
+		   MAC_MCR_BACKOFF_EN | MAC_MCR_BACKPR_EN | MAC_MCR_FORCE_LINK;
+
+	/* Only update control register when needed! */
+	if (mcr_new != mcr_cur)
+		mtk_w32(mac->hw, mcr_new, MTK_MAC_MCR(mac->id));
+
+	return 0;
+}
+
 static void mtk_mac_pcs_get_state(struct phylink_config *config,
 				  struct phylink_link_state *state)
 {
@@ -534,6 +544,7 @@ static const struct phylink_mac_ops mtk_phylink_ops = {
 	.mac_pcs_get_state = mtk_mac_pcs_get_state,
 	.mac_an_restart = mtk_mac_an_restart,
 	.mac_config = mtk_mac_config,
+	.mac_finish = mtk_mac_finish,
 	.mac_link_down = mtk_mac_link_down,
 	.mac_link_up = mtk_mac_link_up,
 };
-- 
2.30.2

