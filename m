Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D058F60F8B4
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 15:12:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236078AbiJ0NMg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 09:12:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236020AbiJ0NL4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 09:11:56 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A67F7B58B
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 06:11:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=iwRx3hvs+0T47VE5Oc94f6PsAxK95EdNX2ogWTFiGPg=; b=kCEvDruXnQdCepGj7OSKs8ebKK
        h8Guaioz8GCMpir3bPVvsVD7gKRcnYx/GFyj5ZdpflekD/azZyKcbK0S+ecBOhicJwF+vjmVG0ez6
        j6GEtusK7mAaIigVDdPuARrrDZs7ndxGEYHzwfc1wfN1nS+Nst+NlxtzDHgLREcYZfatNduDnGvEP
        gPJ85vsfGXj11gMtkX6gjo2ng40Vyb6I96U7J1EOekO8NnSXS4NmvqpAUjn/cBlEKaWflT9NvZ0PG
        P3D+eTJuQ1b9mO146kMqEcxqKhkLqMRNTMHlWRc1mo/er9IdfH5uexdG4RRA0xAq0K2pPiRByDtPb
        yEPSCZ6Q==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:38416 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1oo2fM-0006zv-6w; Thu, 27 Oct 2022 14:11:24 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1oo2fL-00HF8W-JF; Thu, 27 Oct 2022 14:11:23 +0100
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
Subject: [PATCH net-next 10/11] net: mtk_eth_soc: move and correct link timer
 programming
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1oo2fL-00HF8W-JF@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Thu, 27 Oct 2022 14:11:23 +0100
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Program the link timer appropriately for the interface mode being
used, using the newly introduced phylink helper that provides the
nanosecond link timer interval.

The intervals are 1.6ms for SGMII based protocols and 10ms for
802.3z based protocols.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/ethernet/mediatek/mtk_sgmii.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_sgmii.c b/drivers/net/ethernet/mediatek/mtk_sgmii.c
index 1f6e58cba162..12e01d0ef52d 100644
--- a/drivers/net/ethernet/mediatek/mtk_sgmii.c
+++ b/drivers/net/ethernet/mediatek/mtk_sgmii.c
@@ -36,10 +36,6 @@ static void mtk_pcs_get_state(struct phylink_pcs *pcs,
 /* For SGMII interface mode */
 static void mtk_pcs_setup_mode_an(struct mtk_pcs *mpcs)
 {
-	/* Setup the link timer and QPHY power up inside SGMIISYS */
-	regmap_write(mpcs->regmap, SGMSYS_PCS_LINK_TIMER,
-		     SGMII_LINK_TIMER_DEFAULT);
-
 	regmap_update_bits(mpcs->regmap, SGMSYS_SGMII_MODE,
 			   SGMII_REMOTE_FAULT_DIS, SGMII_REMOTE_FAULT_DIS);
 
@@ -69,8 +65,8 @@ static int mtk_pcs_config(struct phylink_pcs *pcs, unsigned int mode,
 			  bool permit_pause_to_mac)
 {
 	struct mtk_pcs *mpcs = pcs_to_mtk_pcs(pcs);
+	int advertise, link_timer;
 	unsigned int rgc3;
-	int advertise;
 	bool changed;
 
 	if (interface == PHY_INTERFACE_MODE_2500BASEX)
@@ -83,6 +79,10 @@ static int mtk_pcs_config(struct phylink_pcs *pcs, unsigned int mode,
 	if (advertise < 0)
 		return advertise;
 
+	link_timer = phylink_get_link_timer_ns(interface);
+	if (link_timer < 0)
+		return link_timer;
+
 	/* Configure the underlying interface speed */
 	regmap_update_bits(mpcs->regmap, mpcs->ana_rgc3,
 			   RG_PHY_SPEED_3_125G, rgc3);
@@ -91,6 +91,9 @@ static int mtk_pcs_config(struct phylink_pcs *pcs, unsigned int mode,
 	regmap_update_bits_check(mpcs->regmap, SGMSYS_PCS_ADVERTISE,
 				 SGMII_ADVERTISE, advertise, &changed);
 
+	/* Setup the link timer and QPHY power up inside SGMIISYS */
+	regmap_write(mpcs->regmap, SGMSYS_PCS_LINK_TIMER, link_timer / 2 / 8);
+
 	/* Setup SGMIISYS with the determined property */
 	if (interface != PHY_INTERFACE_MODE_SGMII)
 		mtk_pcs_setup_mode_force(mpcs, interface);
-- 
2.30.2

