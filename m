Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95B945BC4BC
	for <lists+netdev@lfdr.de>; Mon, 19 Sep 2022 10:51:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230135AbiISIvm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 04:51:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230089AbiISIvV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 04:51:21 -0400
Received: from mail.base45.de (mail.base45.de [80.241.60.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C67B12638;
        Mon, 19 Sep 2022 01:50:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=fe80.eu;
        s=20190804; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=QBCl0pfQcWqm7TdLuZxzEDBy56PZexf/QrFrNulelxc=; b=ZMB80DSusgcxYXocGFwCxmOfCY
        2NtV1oKiF537zlxG0wWTs+860QIo5U0pA0AkmbVXaJZWYBY38CcGJPJVlB5mrPeNUMp/BQT+ttGPk
        2hSSxpv+VMBLyhb9lpQqGWdPSSUAbV+PCw5Ggc06csB+7wcFbjdEN4ujHupPVTpQ15bcQsUuJ58N0
        uprm4A4USMNqb/LlSIUWrXeIQgAz8e5sYcoDGIL6VdjIuMpI/fNa0Kry4NHeudfIgfCN25bHFuIhM
        TZcOYbqPWldjgursAaeEzDb7L+FXwWjvFTbc+FVg9GGgSqYfLet4t9J/jI8Lqtq0AsN8BtnHwMc9c
        K6tELyYw==;
Received: from dynamic-089-204-138-189.89.204.138.pool.telefonica.de ([89.204.138.189] helo=localhost.localdomain)
        by mail.base45.de with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <lynxis@fe80.eu>)
        id 1oaCHM-0015f0-VR; Mon, 19 Sep 2022 08:37:25 +0000
From:   Alexander Couzens <lynxis@fe80.eu>
To:     Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     Daniel Golle <daniel@makrotopia.org>,
        Alexander Couzens <lynxis@fe80.eu>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2 4/5] net: mediatek: sgmii: set the speed according to the phy interface in AN
Date:   Mon, 19 Sep 2022 10:37:11 +0200
Message-Id: <20220919083713.730512-5-lynxis@fe80.eu>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220919083713.730512-1-lynxis@fe80.eu>
References: <20220919083713.730512-1-lynxis@fe80.eu>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The non auto-negotioting code path is setting the correct speed for the
interface. Ensure auto-negotiation code path is doing it as well.

Signed-off-by: Alexander Couzens <lynxis@fe80.eu>
---
 drivers/net/ethernet/mediatek/mtk_sgmii.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_sgmii.c b/drivers/net/ethernet/mediatek/mtk_sgmii.c
index 6f4c1ca5a36f..4c8e8c7b1d32 100644
--- a/drivers/net/ethernet/mediatek/mtk_sgmii.c
+++ b/drivers/net/ethernet/mediatek/mtk_sgmii.c
@@ -21,13 +21,20 @@ static struct mtk_pcs *pcs_to_mtk_pcs(struct phylink_pcs *pcs)
 }
 
 /* For SGMII interface mode */
-static int mtk_pcs_setup_mode_an(struct mtk_pcs *mpcs)
+static int mtk_pcs_setup_mode_an(struct mtk_pcs *mpcs, phy_interface_t interface)
 {
 	unsigned int val;
 
 	/* PHYA power down */
 	regmap_write(mpcs->regmap, SGMSYS_QPHY_PWR_STATE_CTRL, SGMII_PHYA_PWD);
 
+	/* Set SGMII phy speed */
+	regmap_read(mpcs->regmap, mpcs->ana_rgc3, &val);
+	val &= ~RG_PHY_SPEED_MASK;
+	if (interface == PHY_INTERFACE_MODE_2500BASEX)
+		val |= RG_PHY_SPEED_3_125G;
+	regmap_write(mpcs->regmap, mpcs->ana_rgc3, val);
+
 	/* Setup the link timer and QPHY power up inside SGMIISYS */
 	regmap_write(mpcs->regmap, SGMSYS_PCS_LINK_TIMER,
 		     SGMII_LINK_TIMER_DEFAULT);
@@ -112,7 +119,7 @@ static int mtk_pcs_config(struct phylink_pcs *pcs, unsigned int mode,
 	if (interface != PHY_INTERFACE_MODE_SGMII)
 		err = mtk_pcs_setup_mode_force(mpcs, interface);
 	else if (phylink_autoneg_inband(mode))
-		err = mtk_pcs_setup_mode_an(mpcs);
+		err = mtk_pcs_setup_mode_an(mpcs, interface);
 
 	return err;
 }
-- 
2.37.3

