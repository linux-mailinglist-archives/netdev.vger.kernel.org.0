Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 401C05BC4A6
	for <lists+netdev@lfdr.de>; Mon, 19 Sep 2022 10:48:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230084AbiISIsq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 04:48:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230079AbiISIsh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 04:48:37 -0400
Received: from mail.base45.de (mail.base45.de [80.241.60.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F3E622503;
        Mon, 19 Sep 2022 01:48:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=fe80.eu;
        s=20190804; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=dT1y+29LfGYYXr/kgVW5snS+ww+Guphm3qcxKvTGRM4=; b=WghFA2VplecHWY3tR2poQdmoj7
        l1v/yX0/m76QpmmFOXecuePay3hY6lrWOuB8J3u8hIX4Al0nUZPRFvxUi0k8qI48OeZNEVUZE4HDg
        tm11LZGt5teydPJmAIJ25pakjd1K4p5xjpyMaAgjjUCTXn1dEIV63TctkqOvp2Ny9j0sqbCjVYeac
        88/9jqkeNxewWNU7f9P+T0s9+vsiYbJVz3zIGBz542guXLaSXkJAxwRFkbcZFCh6O8obMJ1TSt2Mp
        MkUG4BN+m1Q0VuL0FxDIFC6o01+VAN/NAZGfsucw20DhDdhNxmp957paXgIvngVBHrguhj9OkUrqa
        hFJ3ddpA==;
Received: from dynamic-089-204-138-189.89.204.138.pool.telefonica.de ([89.204.138.189] helo=localhost.localdomain)
        by mail.base45.de with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <lynxis@fe80.eu>)
        id 1oaCHL-0015f0-Pe; Mon, 19 Sep 2022 08:37:23 +0000
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
Subject: [PATCH net-next v2 3/5] net: mediatek: sgmii: mtk_pcs_setup_mode_an: don't rely on register defaults
Date:   Mon, 19 Sep 2022 10:37:10 +0200
Message-Id: <20220919083713.730512-4-lynxis@fe80.eu>
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

Ensure autonegotiation is enabled.

Signed-off-by: Alexander Couzens <lynxis@fe80.eu>
---
 drivers/net/ethernet/mediatek/mtk_sgmii.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_sgmii.c b/drivers/net/ethernet/mediatek/mtk_sgmii.c
index 18de85709e87..6f4c1ca5a36f 100644
--- a/drivers/net/ethernet/mediatek/mtk_sgmii.c
+++ b/drivers/net/ethernet/mediatek/mtk_sgmii.c
@@ -32,12 +32,13 @@ static int mtk_pcs_setup_mode_an(struct mtk_pcs *mpcs)
 	regmap_write(mpcs->regmap, SGMSYS_PCS_LINK_TIMER,
 		     SGMII_LINK_TIMER_DEFAULT);
 
+	/* disable remote fault & enable auto neg */
 	regmap_read(mpcs->regmap, SGMSYS_SGMII_MODE, &val);
-	val |= SGMII_REMOTE_FAULT_DIS;
+	val |= SGMII_REMOTE_FAULT_DIS | SGMII_SPEED_DUPLEX_AN;
 	regmap_write(mpcs->regmap, SGMSYS_SGMII_MODE, val);
 
 	regmap_read(mpcs->regmap, SGMSYS_PCS_CONTROL_1, &val);
-	val |= SGMII_AN_RESTART;
+	val |= SGMII_AN_RESTART | SGMII_AN_ENABLE;
 	regmap_write(mpcs->regmap, SGMSYS_PCS_CONTROL_1, val);
 
 	/* Release PHYA power down state
-- 
2.37.3

