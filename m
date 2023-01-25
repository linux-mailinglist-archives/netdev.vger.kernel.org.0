Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 044D367B91A
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 19:17:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235768AbjAYSRL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 13:17:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235659AbjAYSRK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 13:17:10 -0500
Received: from dilbert.mork.no (dilbert.mork.no [IPv6:2a01:4f9:c010:a439::d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1918D2BF25
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 10:17:07 -0800 (PST)
Received: from canardo.dyn.mork.no ([IPv6:2a01:799:c9a:3200:0:0:0:1])
        (authenticated bits=0)
        by dilbert.mork.no (8.15.2/8.15.2) with ESMTPSA id 30PIGD0C135831
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=OK);
        Wed, 25 Jan 2023 18:16:15 GMT
Received: from canardo.dyn.mork.no (ip6-localhost [IPv6:0:0:0:0:0:0:0:1])
        by canardo.dyn.mork.no (8.15.2/8.15.2) with ESMTPS id 30PIG85H861919
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=OK);
        Wed, 25 Jan 2023 19:16:08 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mork.no; s=b;
        t=1674670568; bh=cVTWG8EgRaDyLSKu2bbD5E5px/hLAXsGRmw+BmGt+ro=;
        h=From:To:Cc:Subject:Date:Message-Id:References:From;
        b=UFxIYIMCcPEs3Mh8x6iIaQZmKAXOVmhUgf7DtEv0Pz3VOeCo40pLaRQcYuCQTckpg
         CPUsBdszjdODWStt4Ozq6RnEhAmoP9D9mvCEmqGX5BDxNDUlcxMyhRXq16pdHy0rFj
         hsU6gAxhC7Wkisi3z7UWoSiH7ibrvkVVvx8CVeO0=
Received: (from bjorn@localhost)
        by canardo.dyn.mork.no (8.15.2/8.15.2/Submit) id 30PIG8sK861913;
        Wed, 25 Jan 2023 19:16:08 +0100
From:   =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>
To:     netdev@vger.kernel.org
Cc:     Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Daniel Golle <daniel@makrotopia.org>,
        Alexander Couzens <lynxis@fe80.eu>,
        Simon Horman <simon.horman@corigine.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>
Subject: [PATCH v4 net 1/3] net: mediatek: sgmii: ensure the SGMII PHY is powered down on configuration
Date:   Wed, 25 Jan 2023 19:16:00 +0100
Message-Id: <20230125181602.861843-2-bjorn@mork.no>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230125181602.861843-1-bjorn@mork.no>
References: <20230125181602.861843-1-bjorn@mork.no>
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

Only power down when reconfiguring to avoid bouncing the link when there's
no reason to - based on code from Russell King.

There are cases when the SGMII_PHYA_PWD register contains 0x9 which
prevents SGMII from working. The SGMII still shows link but no traffic
can flow. Writing 0x0 to the PHYA_PWD register fix the issue. 0x0 was
taken from a good working state of the SGMII interface.

Fixes: 42c03844e93d ("net-next: mediatek: add support for MediaTek MT7622 SoC")
Suggested-by: Russell King (Oracle) <linux@armlinux.org.uk>
Signed-off-by: Alexander Couzens <lynxis@fe80.eu>
[ bmork: rebased and squashed into one patch ]
Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Bjørn Mork <bjorn@mork.no>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.h |  2 ++
 drivers/net/ethernet/mediatek/mtk_sgmii.c   | 39 +++++++++++++++------
 2 files changed, 30 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.h b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
index 18a50529ce7b..b299a7df3c30 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.h
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
@@ -1037,10 +1037,12 @@ struct mtk_soc_data {
  *                     SGMII modes
  * @ana_rgc3:          The offset refers to register ANA_RGC3 related to regmap
  * @pcs:               Phylink PCS structure
+ * @interface:         Currently configured interface mode
  */
 struct mtk_pcs {
 	struct regmap	*regmap;
 	u32             ana_rgc3;
+	phy_interface_t	interface;
 	struct phylink_pcs pcs;
 };
 
diff --git a/drivers/net/ethernet/mediatek/mtk_sgmii.c b/drivers/net/ethernet/mediatek/mtk_sgmii.c
index 5c286f2c9418..0a06995099cf 100644
--- a/drivers/net/ethernet/mediatek/mtk_sgmii.c
+++ b/drivers/net/ethernet/mediatek/mtk_sgmii.c
@@ -43,11 +43,6 @@ static int mtk_pcs_config(struct phylink_pcs *pcs, unsigned int mode,
 	int advertise, link_timer;
 	bool changed, use_an;
 
-	if (interface == PHY_INTERFACE_MODE_2500BASEX)
-		rgc3 = RG_PHY_SPEED_3_125G;
-	else
-		rgc3 = 0;
-
 	advertise = phylink_mii_c22_pcs_encode_advertisement(interface,
 							     advertising);
 	if (advertise < 0)
@@ -88,9 +83,22 @@ static int mtk_pcs_config(struct phylink_pcs *pcs, unsigned int mode,
 		bmcr = 0;
 	}
 
-	/* Configure the underlying interface speed */
-	regmap_update_bits(mpcs->regmap, mpcs->ana_rgc3,
-			   RG_PHY_SPEED_3_125G, rgc3);
+	if (mpcs->interface != interface) {
+		/* PHYA power down */
+		regmap_update_bits(mpcs->regmap, SGMSYS_QPHY_PWR_STATE_CTRL,
+				   SGMII_PHYA_PWD, SGMII_PHYA_PWD);
+
+		if (interface == PHY_INTERFACE_MODE_2500BASEX)
+			rgc3 = RG_PHY_SPEED_3_125G;
+		else
+			rgc3 = 0;
+
+		/* Configure the underlying interface speed */
+		regmap_update_bits(mpcs->regmap, mpcs->ana_rgc3,
+				   RG_PHY_SPEED_3_125G, rgc3);
+
+		mpcs->interface = interface;
+	}
 
 	/* Update the advertisement, noting whether it has changed */
 	regmap_update_bits_check(mpcs->regmap, SGMSYS_PCS_ADVERTISE,
@@ -108,9 +116,17 @@ static int mtk_pcs_config(struct phylink_pcs *pcs, unsigned int mode,
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
@@ -171,6 +187,7 @@ int mtk_sgmii_init(struct mtk_sgmii *ss, struct device_node *r, u32 ana_rgc3)
 			return PTR_ERR(ss->pcs[i].regmap);
 
 		ss->pcs[i].pcs.ops = &mtk_pcs_ops;
+		ss->pcs[i].interface = PHY_INTERFACE_MODE_NA;
 	}
 
 	return 0;
-- 
2.30.2

