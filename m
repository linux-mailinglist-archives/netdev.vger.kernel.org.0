Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5069673FB0
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 18:15:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229654AbjASRPq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 12:15:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229634AbjASRPq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 12:15:46 -0500
X-Greylist: delayed 101 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 19 Jan 2023 09:15:43 PST
Received: from dilbert.mork.no (dilbert.mork.no [IPv6:2a01:4f9:c010:a439::d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A047A4DCE4
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 09:15:43 -0800 (PST)
Received: from canardo.dyn.mork.no ([IPv6:2a01:799:c9a:3200:0:0:0:1])
        (authenticated bits=0)
        by dilbert.mork.no (8.15.2/8.15.2) with ESMTPSA id 30JHDBKV2320860
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=OK);
        Thu, 19 Jan 2023 17:13:12 GMT
Received: from canardo.dyn.mork.no (ip6-localhost [IPv6:0:0:0:0:0:0:0:1])
        by canardo.dyn.mork.no (8.15.2/8.15.2) with ESMTPS id 30JHD6pY3882108
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=OK);
        Thu, 19 Jan 2023 18:13:06 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mork.no; s=b;
        t=1674148386; bh=9t0DiBYdHMl73DD2xIAiQTfZIQBgy1yPA2EX1rsSIwA=;
        h=From:To:Cc:Subject:Date:Message-Id:References:From;
        b=BezwIzDKiKNevrevZ7F7/aLHAv7ijNnqCAEypC2U6tzCUYiAsgqmcLuiMXwlJVNLe
         2o47zqrMWwa6Yb7YA1WpH1rGF86sXZUAWP5/eWrzkDhuQiYhZho7Imv7mrOBr/ilF8
         LBNQjom3kThilFGW2EjKaTn3IpuiGmq3oDd/MN1E=
Received: (from bjorn@localhost)
        by canardo.dyn.mork.no (8.15.2/8.15.2/Submit) id 30JHD61G3882102;
        Thu, 19 Jan 2023 18:13:06 +0100
From:   =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>
To:     netdev@vger.kernel.org
Cc:     Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Daniel Golle <daniel@makrotopia.org>,
        Alexander Couzens <lynxis@fe80.eu>,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>
Subject: [PATCH net 1/3] net: mediatek: sgmii: ensure the SGMII PHY is powered down on configuration
Date:   Thu, 19 Jan 2023 18:12:46 +0100
Message-Id: <20230119171248.3882021-2-bjorn@mork.no>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230119171248.3882021-1-bjorn@mork.no>
References: <20230119171248.3882021-1-bjorn@mork.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Virus-Scanned: clamav-milter 0.103.7 at canardo
X-Virus-Status: Clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexander Couzens <lynxis@fe80.eu>

The code expect the PHY to be in power down which is only true after reset.
Allow changes of the SGMII parameters more than once.

There are cases when the SGMII_PHYA_PWD register contains 0x9 which
prevents SGMII from working. The SGMII still shows link but no traffic
can flow. Writing 0x0 to the PHYA_PWD register fix the issue. 0x0 was
taken from a good working state of the SGMII interface.

Signed-off-by: Alexander Couzens <lynxis@fe80.eu>
[ bmork: rebased and squashed into one patch ]
Signed-off-by: Bjørn Mork <bjorn@mork.no>
---
 drivers/net/ethernet/mediatek/mtk_sgmii.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_sgmii.c b/drivers/net/ethernet/mediatek/mtk_sgmii.c
index 5c286f2c9418..481f2f1e39f5 100644
--- a/drivers/net/ethernet/mediatek/mtk_sgmii.c
+++ b/drivers/net/ethernet/mediatek/mtk_sgmii.c
@@ -88,6 +88,10 @@ static int mtk_pcs_config(struct phylink_pcs *pcs, unsigned int mode,
 		bmcr = 0;
 	}
 
+	/* PHYA power down */
+	regmap_update_bits(mpcs->regmap, SGMSYS_QPHY_PWR_STATE_CTRL,
+			   SGMII_PHYA_PWD, SGMII_PHYA_PWD);
+
 	/* Configure the underlying interface speed */
 	regmap_update_bits(mpcs->regmap, mpcs->ana_rgc3,
 			   RG_PHY_SPEED_3_125G, rgc3);
@@ -108,9 +112,17 @@ static int mtk_pcs_config(struct phylink_pcs *pcs, unsigned int mode,
 	regmap_update_bits(mpcs->regmap, SGMSYS_PCS_CONTROL_1,
 			   SGMII_AN_RESTART | SGMII_AN_ENABLE, bmcr);
 
-	/* Release PHYA power down state */
-	regmap_update_bits(mpcs->regmap, SGMSYS_QPHY_PWR_STATE_CTRL,
-			   SGMII_PHYA_PWD, 0);
+	/* Release PHYA power down state
+	 * Only removing bit SGMII_PHYA_PWD isn't enough.
+	 * There are cases when the SGMII_PHYA_PWD register contains 0x9 which
+	 * prevents SGMII from working. The SGMII still shows link but no traffic
+	 * can flow. Writing 0x0 to the PHYA_PWD register fix the issue. 0x0 was
+	 * taken from a good working state of the SGMII interface.
+	 * Unknown how much the QPHY needs but it is racy without a sleep.
+	 * Tested on mt7622 & mt7986.
+	 */
+	usleep_range(50, 100);
+	regmap_write(mpcs->regmap, SGMSYS_QPHY_PWR_STATE_CTRL, 0);
 
 	return changed;
 }
-- 
2.30.2

