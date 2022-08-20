Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66B9259B0D3
	for <lists+netdev@lfdr.de>; Sun, 21 Aug 2022 00:48:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234116AbiHTWq0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Aug 2022 18:46:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231313AbiHTWqY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Aug 2022 18:46:24 -0400
Received: from mail.base45.de (mail.base45.de [IPv6:2001:67c:2050:320::77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61AB7222BE;
        Sat, 20 Aug 2022 15:46:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=fe80.eu;
        s=20190804; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Skn6knx7DWTwYsEOVvaiAtKq6ITBTeteroMRofDadYM=; b=spSguYHK4keCpgMbpmRvLdz+5x
        Pb9Fy+vc0wQ1M6KAG5JWjqBaJygPLJyyXjaRPkSvm1GsgPtxKYFNZEL75M9xbXQR8ywXw2em+jfD4
        CoMLAdIPdQTUrEsLitBiCE6EA9dhjJxWR5vgSThJyaGb6pmG/+4gdl5YZuvwUtv4ZxX5NzmkbtjUC
        3dHWRf014xypVG+VTMWpXyZ6HeIVMuT+mbInEu0TFsEBMHACYdQeWMem2Owv82FiMCQPHpwVJt1in
        iJSMVY0XOmbpKIf5CAcv/KCl7ucfuxVPfh/pwaMjKnvlH8/Pj//NXoxTgPp4Xtr1XMoa/FZnSZa16
        GqML8KZw==;
Received: from [2a02:2454:9869:1a:9eb6:54ff:0:fa5] (helo=cerator.lan)
        by mail.base45.de with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <lynxis@fe80.eu>)
        id 1oPXE5-00G2sh-Mn; Sat, 20 Aug 2022 22:45:57 +0000
From:   Alexander Couzens <lynxis@fe80.eu>
To:     Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        Daniel Golle <daniel@makrotopia.org>,
        Alexander Couzens <lynxis@fe80.eu>
Subject: [PATCH 2/4] net: mediatek: sgmii: ensure the SGMII PHY is powered down on configuration
Date:   Sun, 21 Aug 2022 00:45:36 +0200
Message-Id: <20220820224538.59489-3-lynxis@fe80.eu>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220820224538.59489-1-lynxis@fe80.eu>
References: <20220820224538.59489-1-lynxis@fe80.eu>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The code expect the PHY to be in power down which is only true after reset.
Allow changes of the SGMII parameters more than once.

Signed-off-by: Alexander Couzens <lynxis@fe80.eu>
---
 drivers/net/ethernet/mediatek/mtk_sgmii.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_sgmii.c b/drivers/net/ethernet/mediatek/mtk_sgmii.c
index a01bb20ea957..782812434367 100644
--- a/drivers/net/ethernet/mediatek/mtk_sgmii.c
+++ b/drivers/net/ethernet/mediatek/mtk_sgmii.c
@@ -7,6 +7,7 @@
  *
  */
 
+#include <linux/delay.h>
 #include <linux/mfd/syscon.h>
 #include <linux/of.h>
 #include <linux/phylink.h>
@@ -24,6 +25,9 @@ static int mtk_pcs_setup_mode_an(struct mtk_pcs *mpcs)
 {
 	unsigned int val;
 
+	/* PHYA power down */
+	regmap_write(mpcs->regmap, SGMSYS_QPHY_PWR_STATE_CTRL, SGMII_PHYA_PWD);
+
 	/* Setup the link timer and QPHY power up inside SGMIISYS */
 	regmap_write(mpcs->regmap, SGMSYS_PCS_LINK_TIMER,
 		     SGMII_LINK_TIMER_DEFAULT);
@@ -36,6 +40,10 @@ static int mtk_pcs_setup_mode_an(struct mtk_pcs *mpcs)
 	val |= SGMII_AN_RESTART;
 	regmap_write(mpcs->regmap, SGMSYS_PCS_CONTROL_1, val);
 
+	/* Release PHYA power down state
+	 * unknown how much the QPHY needs but it is racy without a sleep
+	 */
+	usleep_range(50, 100);
 	regmap_write(mpcs->regmap, SGMSYS_QPHY_PWR_STATE_CTRL, 0);
 
 	return 0;
@@ -50,6 +58,9 @@ static int mtk_pcs_setup_mode_force(struct mtk_pcs *mpcs,
 {
 	unsigned int val;
 
+	/* PHYA power down */
+	regmap_write(mpcs->regmap, SGMSYS_QPHY_PWR_STATE_CTRL, SGMII_PHYA_PWD);
+
 	regmap_read(mpcs->regmap, mpcs->ana_rgc3, &val);
 	val &= ~RG_PHY_SPEED_MASK;
 	if (interface == PHY_INTERFACE_MODE_2500BASEX)
@@ -67,7 +78,10 @@ static int mtk_pcs_setup_mode_force(struct mtk_pcs *mpcs,
 	val |= SGMII_SPEED_1000;
 	regmap_write(mpcs->regmap, SGMSYS_SGMII_MODE, val);
 
-	/* Release PHYA power down state */
+	/* Release PHYA power down state
+	 * unknown how much the QPHY needs but it is racy without a sleep
+	 */
+	usleep_range(50, 100);
 	regmap_write(mpcs->regmap, SGMSYS_QPHY_PWR_STATE_CTRL, 0);
 
 	return 0;
-- 
2.35.1

