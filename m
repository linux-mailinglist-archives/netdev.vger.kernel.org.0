Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB2BC67B919
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 19:17:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235764AbjAYSRK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 13:17:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230347AbjAYSRK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 13:17:10 -0500
Received: from dilbert.mork.no (dilbert.mork.no [IPv6:2a01:4f9:c010:a439::d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A463360B2
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 10:17:07 -0800 (PST)
Received: from canardo.dyn.mork.no ([IPv6:2a01:799:c9a:3200:0:0:0:1])
        (authenticated bits=0)
        by dilbert.mork.no (8.15.2/8.15.2) with ESMTPSA id 30PIGEOr135832
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=OK);
        Wed, 25 Jan 2023 18:16:15 GMT
Received: from canardo.dyn.mork.no (ip6-localhost [IPv6:0:0:0:0:0:0:0:1])
        by canardo.dyn.mork.no (8.15.2/8.15.2) with ESMTPS id 30PIG8Rl861929
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=OK);
        Wed, 25 Jan 2023 19:16:08 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mork.no; s=b;
        t=1674670569; bh=RS7/fN6uxO1vGCl5EqgqwECp7khvBrPg/BxuXt17egk=;
        h=From:To:Cc:Subject:Date:Message-Id:References:From;
        b=XXTv8oI6ZIlN2FGgY0fwbJhVS7SBBIk/ovVenkBCXtFXBYVbMZJ+Jik4qn5blbEVW
         9qh5TaDuFVIhgNyO1dRUvwXcRFNKS9mF70dmuetYjrwbYCNYbm6vX9JUaLo312hCgh
         S7IP/2kUUamM4/iTW4+k9Y/pxjj1elStY/+6XfAo=
Received: (from bjorn@localhost)
        by canardo.dyn.mork.no (8.15.2/8.15.2/Submit) id 30PIG8ds861924;
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
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        Russell King <rmk+kernel@armlinux.org.uk>
Subject: [PATCH v4 net 2/3] net: mediatek: sgmii: fix duplex configuration
Date:   Wed, 25 Jan 2023 19:16:01 +0100
Message-Id: <20230125181602.861843-3-bjorn@mork.no>
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

The logic of the duplex bit is inverted.  Setting it means half
duplex, not full duplex.

Fix and rename macro to avoid confusion.

Fixes: 7e538372694b ("net: ethernet: mediatek: Re-add support SGMII")
Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Bjørn Mork <bjorn@mork.no>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.h | 2 +-
 drivers/net/ethernet/mediatek/mtk_sgmii.c   | 6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.h b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
index b299a7df3c30..966d8ed384ee 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.h
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
@@ -519,7 +519,7 @@
 #define SGMII_SPEED_10			FIELD_PREP(SGMII_SPEED_MASK, 0)
 #define SGMII_SPEED_100			FIELD_PREP(SGMII_SPEED_MASK, 1)
 #define SGMII_SPEED_1000		FIELD_PREP(SGMII_SPEED_MASK, 2)
-#define SGMII_DUPLEX_FULL		BIT(4)
+#define SGMII_DUPLEX_HALF		BIT(4)
 #define SGMII_IF_MODE_BIT5		BIT(5)
 #define SGMII_REMOTE_FAULT_DIS		BIT(8)
 #define SGMII_CODE_SYNC_SET_VAL		BIT(9)
diff --git a/drivers/net/ethernet/mediatek/mtk_sgmii.c b/drivers/net/ethernet/mediatek/mtk_sgmii.c
index 0a06995099cf..c4261069b521 100644
--- a/drivers/net/ethernet/mediatek/mtk_sgmii.c
+++ b/drivers/net/ethernet/mediatek/mtk_sgmii.c
@@ -154,11 +154,11 @@ static void mtk_pcs_link_up(struct phylink_pcs *pcs, unsigned int mode,
 		else
 			sgm_mode = SGMII_SPEED_1000;
 
-		if (duplex == DUPLEX_FULL)
-			sgm_mode |= SGMII_DUPLEX_FULL;
+		if (duplex != DUPLEX_FULL)
+			sgm_mode |= SGMII_DUPLEX_HALF;
 
 		regmap_update_bits(mpcs->regmap, SGMSYS_SGMII_MODE,
-				   SGMII_DUPLEX_FULL | SGMII_SPEED_MASK,
+				   SGMII_DUPLEX_HALF | SGMII_SPEED_MASK,
 				   sgm_mode);
 	}
 }
-- 
2.30.2

