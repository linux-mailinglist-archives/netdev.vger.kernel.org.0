Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96AC46E81A3
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 21:05:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231535AbjDSTFk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 15:05:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231577AbjDSTFi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 15:05:38 -0400
Received: from fudo.makrotopia.org (fudo.makrotopia.org [IPv6:2a07:2ec0:3002::71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B48749E7;
        Wed, 19 Apr 2023 12:05:25 -0700 (PDT)
Received: from local
        by fudo.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
         (Exim 4.96)
        (envelope-from <daniel@makrotopia.org>)
        id 1ppD7K-0003n3-2L;
        Wed, 19 Apr 2023 21:05:22 +0200
Date:   Wed, 19 Apr 2023 20:05:16 +0100
From:   Daniel Golle <daniel@makrotopia.org>
To:     netdev@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>
Subject: [PATCH net-next 2/2] net: ethernet: mtk_eth_soc: use WO firmware for
 MT7981
Message-ID: <2651cfd1427175ac1ad08d5b7be146c55d94b674.1681930898.git.daniel@makrotopia.org>
References: <cover.1681930898.git.daniel@makrotopia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1681930898.git.daniel@makrotopia.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order to support wireless offloading on MT7981 we need to load the
appropriate firmware. Recognize MT7981 and load mt7981_wo.bin.

Signed-off-by: Daniel Golle <daniel@makrotopia.org>
---
 drivers/net/ethernet/mediatek/mtk_wed_mcu.c | 7 ++++++-
 drivers/net/ethernet/mediatek/mtk_wed_wo.h  | 1 +
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_wed_mcu.c b/drivers/net/ethernet/mediatek/mtk_wed_mcu.c
index 6bad0d262f286..071ed3dea860d 100644
--- a/drivers/net/ethernet/mediatek/mtk_wed_mcu.c
+++ b/drivers/net/ethernet/mediatek/mtk_wed_mcu.c
@@ -326,7 +326,11 @@ mtk_wed_mcu_load_firmware(struct mtk_wed_wo *wo)
 		wo->hw->index + 1);
 
 	/* load firmware */
-	fw_name = wo->hw->index ? MT7986_FIRMWARE_WO1 : MT7986_FIRMWARE_WO0;
+	if (of_device_is_compatible(wo->hw->node, "mediatek,mt7981-wed"))
+		fw_name = MT7981_FIRMWARE_WO;
+	else
+		fw_name = wo->hw->index ? MT7986_FIRMWARE_WO1 : MT7986_FIRMWARE_WO0;
+
 	ret = request_firmware(&fw, fw_name, wo->hw->dev);
 	if (ret)
 		return ret;
@@ -386,5 +390,6 @@ int mtk_wed_mcu_init(struct mtk_wed_wo *wo)
 				  100, MTK_FW_DL_TIMEOUT);
 }
 
+MODULE_FIRMWARE(MT7981_FIRMWARE_WO);
 MODULE_FIRMWARE(MT7986_FIRMWARE_WO0);
 MODULE_FIRMWARE(MT7986_FIRMWARE_WO1);
diff --git a/drivers/net/ethernet/mediatek/mtk_wed_wo.h b/drivers/net/ethernet/mediatek/mtk_wed_wo.h
index dbcf42ce9173c..7a1a2a28f1acb 100644
--- a/drivers/net/ethernet/mediatek/mtk_wed_wo.h
+++ b/drivers/net/ethernet/mediatek/mtk_wed_wo.h
@@ -88,6 +88,7 @@ enum mtk_wed_dummy_cr_idx {
 	MTK_WED_DUMMY_CR_WO_STATUS,
 };
 
+#define MT7981_FIRMWARE_WO	"mediatek/mt7981_wo.bin"
 #define MT7986_FIRMWARE_WO0	"mediatek/mt7986_wo_0.bin"
 #define MT7986_FIRMWARE_WO1	"mediatek/mt7986_wo_1.bin"
 
-- 
2.40.0

