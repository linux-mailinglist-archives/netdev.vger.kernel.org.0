Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 783C26E9DA7
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 23:07:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232324AbjDTVG6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 17:06:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232050AbjDTVG4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 17:06:56 -0400
Received: from fudo.makrotopia.org (fudo.makrotopia.org [IPv6:2a07:2ec0:3002::71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B269D4220;
        Thu, 20 Apr 2023 14:06:55 -0700 (PDT)
Received: from local
        by fudo.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
         (Exim 4.96)
        (envelope-from <daniel@makrotopia.org>)
        id 1ppbUP-0002gY-0C;
        Thu, 20 Apr 2023 23:06:49 +0200
Date:   Thu, 20 Apr 2023 22:06:42 +0100
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
Subject: [PATCH net-next] net: mtk_eth_soc: mediatek: fix ppe flow accounting
 for v1 hardware
Message-ID: <d8474a95a528a4bec5121252205d179f357c7124.1682024624.git.daniel@makrotopia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Felix Fietkau <nbd@nbd.name>

Older chips (like MT7622) use a different bit in ib2 to enable hardware
counter support. Add macros for both and select the appropriate bit.

Fixes: 3fbe4d8c0e53 ("net: ethernet: mtk_eth_soc: ppe: add support for flow accounting")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Daniel Golle <daniel@makrotopia.org>
---
 drivers/net/ethernet/mediatek/mtk_ppe.c | 10 ++++++++--
 drivers/net/ethernet/mediatek/mtk_ppe.h |  3 ++-
 2 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_ppe.c b/drivers/net/ethernet/mediatek/mtk_ppe.c
index dd9581334b054..9129821f3ab8f 100644
--- a/drivers/net/ethernet/mediatek/mtk_ppe.c
+++ b/drivers/net/ethernet/mediatek/mtk_ppe.c
@@ -601,6 +601,7 @@ __mtk_foe_entry_commit(struct mtk_ppe *ppe, struct mtk_foe_entry *entry,
 	struct mtk_eth *eth = ppe->eth;
 	u16 timestamp = mtk_eth_timestamp(eth);
 	struct mtk_foe_entry *hwe;
+	u32 val;
 
 	if (MTK_HAS_CAPS(eth->soc->caps, MTK_NETSYS_V2)) {
 		entry->ib1 &= ~MTK_FOE_IB1_BIND_TIMESTAMP_V2;
@@ -617,8 +618,13 @@ __mtk_foe_entry_commit(struct mtk_ppe *ppe, struct mtk_foe_entry *entry,
 	wmb();
 	hwe->ib1 = entry->ib1;
 
-	if (ppe->accounting)
-		*mtk_foe_entry_ib2(eth, hwe) |= MTK_FOE_IB2_MIB_CNT;
+	if (ppe->accounting) {
+		if (MTK_HAS_CAPS(eth->soc->caps, MTK_NETSYS_V2))
+			val = MTK_FOE_IB2_MIB_CNT_V2;
+		else
+			val = MTK_FOE_IB2_MIB_CNT;
+		*mtk_foe_entry_ib2(eth, hwe) |= val;
+	}
 
 	dma_wmb();
 
diff --git a/drivers/net/ethernet/mediatek/mtk_ppe.h b/drivers/net/ethernet/mediatek/mtk_ppe.h
index e1aab2e8e2629..e51de31a52ec6 100644
--- a/drivers/net/ethernet/mediatek/mtk_ppe.h
+++ b/drivers/net/ethernet/mediatek/mtk_ppe.h
@@ -55,9 +55,10 @@ enum {
 #define MTK_FOE_IB2_PSE_QOS		BIT(4)
 #define MTK_FOE_IB2_DEST_PORT		GENMASK(7, 5)
 #define MTK_FOE_IB2_MULTICAST		BIT(8)
+#define MTK_FOE_IB2_MIB_CNT		BIT(10)
 
 #define MTK_FOE_IB2_WDMA_QID2		GENMASK(13, 12)
-#define MTK_FOE_IB2_MIB_CNT		BIT(15)
+#define MTK_FOE_IB2_MIB_CNT_V2		BIT(15)
 #define MTK_FOE_IB2_WDMA_DEVIDX		BIT(16)
 #define MTK_FOE_IB2_WDMA_WINFO		BIT(17)
 
-- 
2.40.0

