Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CD855BC4A3
	for <lists+netdev@lfdr.de>; Mon, 19 Sep 2022 10:48:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230056AbiISIso (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 04:48:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230088AbiISIsh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 04:48:37 -0400
Received: from mail.base45.de (mail.base45.de [80.241.60.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7F8BBE36;
        Mon, 19 Sep 2022 01:48:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=fe80.eu;
        s=20190804; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=1DACBHOF6bWkOkqzEWq59C2Rno8KqMCb78TJcrYbS/U=; b=djnNEqg5MEYCs/Rn/KVZvcU6LU
        JBoNaHs5fAcwEVraya2ifpOQqK+exVqSGwjI+ULSNsoQm7P2BX7VW7WHQEWSoqsoiT9nw/ZxamE1N
        iwYqc4jluf6yNZDjGraFCQ2v/MZzzYNjaAEFCQYgtZ5DuMp54i4DbObQB2xbea7CxAYoRDjEpJUqg
        0W985cHB4hScOyyFkeg0ZBjuMV+SCNAX41mqpr3Nr1KHadgud8HgLtJUWmlmXt2/E0JKM6ICa5AdV
        Qy/A+7hvSmRiLEIaF6G0EuthkO38X4LmMsq77f6z4xZ1U4LUKAhDu4gDQGDgejCoVdYBOLzVhxN4+
        CVQ4R2lA==;
Received: from dynamic-089-204-138-189.89.204.138.pool.telefonica.de ([89.204.138.189] helo=localhost.localdomain)
        by mail.base45.de with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <lynxis@fe80.eu>)
        id 1oaCHK-0015f0-MQ; Mon, 19 Sep 2022 08:37:22 +0000
From:   Alexander Couzens <lynxis@fe80.eu>
To:     Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>
Cc:     Daniel Golle <daniel@makrotopia.org>,
        Alexander Couzens <lynxis@fe80.eu>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2 2/5] net: mediatek: sgmii: ensure the SGMII PHY is powered down on configuration
Date:   Mon, 19 Sep 2022 10:37:09 +0200
Message-Id: <20220919083713.730512-3-lynxis@fe80.eu>
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

The code expect the PHY to be in power down which is only true after reset.
Allow changes of the SGMII parameters more than once.

Signed-off-by: Alexander Couzens <lynxis@fe80.eu>
---
 drivers/net/ethernet/mediatek/mtk_sgmii.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/net/ethernet/mediatek/mtk_sgmii.c b/drivers/net/ethernet/mediatek/mtk_sgmii.c
index b9b15e1a292c..18de85709e87 100644
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
@@ -42,8 +46,10 @@ static int mtk_pcs_setup_mode_an(struct mtk_pcs *mpcs)
 	 * prevents SGMII from working. The SGMII still shows link but no traffic
 	 * can flow. Writing 0x0 to the PHYA_PWD register fix the issue. 0x0 was
 	 * taken from a good working state of the SGMII interface.
+	 * Unknown how much the QPHY needs but it is racy without a sleep.
 	 * Tested on mt7622 & mt7986.
 	 */
+	usleep_range(50, 100);
 	regmap_write(mpcs->regmap, SGMSYS_QPHY_PWR_STATE_CTRL, 0);
 
 	return 0;
@@ -58,6 +64,9 @@ static int mtk_pcs_setup_mode_force(struct mtk_pcs *mpcs,
 {
 	unsigned int val;
 
+	/* PHYA power down */
+	regmap_write(mpcs->regmap, SGMSYS_QPHY_PWR_STATE_CTRL, SGMII_PHYA_PWD);
+
 	regmap_read(mpcs->regmap, mpcs->ana_rgc3, &val);
 	val &= ~RG_PHY_SPEED_MASK;
 	if (interface == PHY_INTERFACE_MODE_2500BASEX)
@@ -81,8 +90,10 @@ static int mtk_pcs_setup_mode_force(struct mtk_pcs *mpcs,
 	 * prevents SGMII from working. The SGMII still shows link but no traffic
 	 * can flow. Writing 0x0 to the PHYA_PWD register fix the issue. 0x0 was
 	 * taken from a good working state of the SGMII interface.
+	 * Unknown how much the QPHY needs but it is racy without a sleep.
 	 * Tested on mt7622 & mt7986.
 	 */
+	usleep_range(50, 100);
 	regmap_write(mpcs->regmap, SGMSYS_QPHY_PWR_STATE_CTRL, 0);
 
 	return 0;
-- 
2.37.3

