Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62EFF60F8AA
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 15:11:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236013AbiJ0NLx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 09:11:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233548AbiJ0NLJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 09:11:09 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C488A52DFA
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 06:10:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=hCuI3VgccMocVgeiGzU7uyjEe2olId2dWYazu2mv73s=; b=IYeXflN60pkCp7YIYT1OEoU3Qn
        SfA5sw26Cj+7gzMAkCoJfMgIwUschfjueSTfawVHSEhMDs8oCSnrusije+ouFuWwrFpEQb0nycQWB
        6CWtR5ckhX8DXITSDUkjvx2Nf3hL4ThUShoM5cyMkB/6qRZueKJFB0PQNydE423XanEURT0UiqudG
        A55aj1NVpCh6QFZQ9la1Dl+WRzAIp0sO9WgjXX7B4vHqBe4UmUMcqF5xV1AWIrBN8950l+PwVmcel
        oemZkqTvdypgKCQ3nVL3qFKt3hTaEbaXwr+CnumGStWcf14RJm32PxkhxVwxa/QAAolcnLy9RzYI4
        V9NnzRNw==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:57774 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1oo2em-0006xx-CG; Thu, 27 Oct 2022 14:10:48 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1oo2el-00HF7p-P3; Thu, 27 Oct 2022 14:10:47 +0100
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
Subject: [PATCH net-next 03/11] net: mtk_eth_soc: eliminate unnecessary error
 handling
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1oo2el-00HF7p-P3@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Thu, 27 Oct 2022 14:10:47 +0100
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The functions called by the pcs_config() method always return zero, so
there is no point trying to handle an error from these functions. Make
these functions void, eliminate the "err" variable and simply return
zero from the pcs_config() function itself.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/ethernet/mediatek/mtk_sgmii.c | 18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_sgmii.c b/drivers/net/ethernet/mediatek/mtk_sgmii.c
index 736839c84130..7637ba16b44b 100644
--- a/drivers/net/ethernet/mediatek/mtk_sgmii.c
+++ b/drivers/net/ethernet/mediatek/mtk_sgmii.c
@@ -20,7 +20,7 @@ static struct mtk_pcs *pcs_to_mtk_pcs(struct phylink_pcs *pcs)
 }
 
 /* For SGMII interface mode */
-static int mtk_pcs_setup_mode_an(struct mtk_pcs *mpcs)
+static void mtk_pcs_setup_mode_an(struct mtk_pcs *mpcs)
 {
 	unsigned int val;
 
@@ -39,16 +39,13 @@ static int mtk_pcs_setup_mode_an(struct mtk_pcs *mpcs)
 	regmap_read(mpcs->regmap, SGMSYS_QPHY_PWR_STATE_CTRL, &val);
 	val &= ~SGMII_PHYA_PWD;
 	regmap_write(mpcs->regmap, SGMSYS_QPHY_PWR_STATE_CTRL, val);
-
-	return 0;
-
 }
 
 /* For 1000BASE-X and 2500BASE-X interface modes, which operate at a
  * fixed speed.
  */
-static int mtk_pcs_setup_mode_force(struct mtk_pcs *mpcs,
-				    phy_interface_t interface)
+static void mtk_pcs_setup_mode_force(struct mtk_pcs *mpcs,
+				     phy_interface_t interface)
 {
 	unsigned int val;
 
@@ -73,8 +70,6 @@ static int mtk_pcs_setup_mode_force(struct mtk_pcs *mpcs,
 	regmap_read(mpcs->regmap, SGMSYS_QPHY_PWR_STATE_CTRL, &val);
 	val &= ~SGMII_PHYA_PWD;
 	regmap_write(mpcs->regmap, SGMSYS_QPHY_PWR_STATE_CTRL, val);
-
-	return 0;
 }
 
 static int mtk_pcs_config(struct phylink_pcs *pcs, unsigned int mode,
@@ -83,15 +78,14 @@ static int mtk_pcs_config(struct phylink_pcs *pcs, unsigned int mode,
 			  bool permit_pause_to_mac)
 {
 	struct mtk_pcs *mpcs = pcs_to_mtk_pcs(pcs);
-	int err = 0;
 
 	/* Setup SGMIISYS with the determined property */
 	if (interface != PHY_INTERFACE_MODE_SGMII)
-		err = mtk_pcs_setup_mode_force(mpcs, interface);
+		mtk_pcs_setup_mode_force(mpcs, interface);
 	else if (phylink_autoneg_inband(mode))
-		err = mtk_pcs_setup_mode_an(mpcs);
+		mtk_pcs_setup_mode_an(mpcs);
 
-	return err;
+	return 0;
 }
 
 static void mtk_pcs_restart_an(struct phylink_pcs *pcs)
-- 
2.30.2

