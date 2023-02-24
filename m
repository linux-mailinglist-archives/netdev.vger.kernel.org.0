Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB9426A1C42
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 13:36:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230023AbjBXMgh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Feb 2023 07:36:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230017AbjBXMgg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Feb 2023 07:36:36 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07F6867E3A
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 04:36:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=dNuvrGSIwTA5NXb6MRBDQvk5XI9567Ybm3Y4p+pxJr8=; b=qat1waqG+EQvm+f1yKAxBEHyZP
        ozECbjI+yFfLN7bEtDbPZF8VKA5fjiiZJ7zvTo51pIa4rJParXVOIDxvhImeUDWyRORXxyOYFQz5m
        fHUkjqj4tsaV5cIz0PCfZNrw4cTUaPkHUxrDQcp8bJ7t0DBqVFWQLm2fnOkMV1SmyR8i16q9U92TS
        pWYqKVSCPcVSskQKHN2y+5bq9NpYE7HlfriL6cSwzAd0UZ6zavaRX9jOxULcr0v96B0Qx9SZGWYNY
        4/ra3IaMstM+m+CDE7VLrsKpJWZRZ8/QVWIRWDDfykoylTWCNePRgwJ/eL4c0Fsm8Tws7meBd1cSR
        CIxWlXcg==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:42332 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1pVXJG-0000dh-Hx; Fri, 24 Feb 2023 12:36:22 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1pVXJF-00CTAf-Qu; Fri, 24 Feb 2023 12:36:21 +0000
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
Subject: [PATCH RFC net-next 3/4] net: mtk_eth_soc: remove unnecessary checks
 in mtk_mac_config()
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1pVXJF-00CTAf-Qu@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Fri, 24 Feb 2023 12:36:21 +0000
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

mtk_mac_config() checks that the interface mode is permitted for the
capabilities, but we already do these checks in mtk_add_mac() when
initialising phylink's supported_interfaces bitmap. Remove the
unnecessary tests.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index 1b385dfe620f..f78810717f66 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -458,12 +458,6 @@ static void mtk_mac_config(struct phylink_config *config, unsigned int mode,
 		/* Setup soc pin functions */
 		switch (state->interface) {
 		case PHY_INTERFACE_MODE_TRGMII:
-			if (mac->id)
-				goto err_phy;
-			if (!MTK_HAS_CAPS(mac->hw->soc->caps,
-					  MTK_GMAC1_TRGMII))
-				goto err_phy;
-			fallthrough;
 		case PHY_INTERFACE_MODE_RGMII_TXID:
 		case PHY_INTERFACE_MODE_RGMII_RXID:
 		case PHY_INTERFACE_MODE_RGMII_ID:
@@ -480,11 +474,9 @@ static void mtk_mac_config(struct phylink_config *config, unsigned int mode,
 		case PHY_INTERFACE_MODE_1000BASEX:
 		case PHY_INTERFACE_MODE_2500BASEX:
 		case PHY_INTERFACE_MODE_SGMII:
-			if (MTK_HAS_CAPS(eth->soc->caps, MTK_SGMII)) {
-				err = mtk_gmac_sgmii_path_setup(eth, mac->id);
-				if (err)
-					goto init_err;
-			}
+			err = mtk_gmac_sgmii_path_setup(eth, mac->id);
+			if (err)
+				goto init_err;
 			break;
 		case PHY_INTERFACE_MODE_GMII:
 			if (MTK_HAS_CAPS(eth->soc->caps, MTK_GEPHY)) {
-- 
2.30.2

