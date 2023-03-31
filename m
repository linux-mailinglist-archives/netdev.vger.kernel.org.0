Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DC9C6D19D8
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 10:29:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230356AbjCaI3v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 04:29:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229646AbjCaI3u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 04:29:50 -0400
Received: from nbd.name (nbd.name [46.4.11.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DF381AE
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 01:29:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
        s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=XEtkwoJ1NZByZ5V1hQ4v+wxmvSQyMvfDrHGJhCYQCOE=; b=PjAGuGs2XQkhMN2Nb1BNSvnoLr
        Mmqs+LWrYyvrQh1aXv4HA25mzL/LxqAdN37gUO5a/DmfJBHbMWoXdZe9+VF+7dKTho1RJ6jNBC6kS
        9caGfr9K99gFk27V0pbqFa/yN9/8yjbTSXGoWd5+Yzg1UIPGYkMioT+SpYp0W1WT6Ryg=;
Received: from p54ae9730.dip0.t-ipconnect.de ([84.174.151.48] helo=Maecks.lan)
        by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305_SHA256
        (Exim 4.94.2)
        (envelope-from <nbd@nbd.name>)
        id 1piA8o-008qbG-IN; Fri, 31 Mar 2023 10:29:46 +0200
From:   Felix Fietkau <nbd@nbd.name>
To:     netdev@vger.kernel.org
Cc:     Daniel Golle <daniel@makrotopia.org>
Subject: [PATCH net-next 3/3] net: ethernet: mtk_eth_soc: fix ppe flow accounting for v1 hardware
Date:   Fri, 31 Mar 2023 10:29:45 +0200
Message-Id: <20230331082945.75075-3-nbd@nbd.name>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230331082945.75075-1-nbd@nbd.name>
References: <20230331082945.75075-1-nbd@nbd.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Older chips (like MT7622) use a different bit in ib2 to enable hardware
counter support.

Fixes: 3fbe4d8c0e53 ("net: ethernet: mtk_eth_soc: ppe: add support for flow accounting")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/ethernet/mediatek/mtk_ppe.c | 10 ++++++++--
 drivers/net/ethernet/mediatek/mtk_ppe.h |  3 ++-
 2 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_ppe.c b/drivers/net/ethernet/mediatek/mtk_ppe.c
index 64e8dc8d814b..5cfa45ba66dd 100644
--- a/drivers/net/ethernet/mediatek/mtk_ppe.c
+++ b/drivers/net/ethernet/mediatek/mtk_ppe.c
@@ -640,6 +640,7 @@ __mtk_foe_entry_commit(struct mtk_ppe *ppe, struct mtk_foe_entry *entry,
 	struct mtk_eth *eth = ppe->eth;
 	u16 timestamp = mtk_eth_timestamp(eth);
 	struct mtk_foe_entry *hwe;
+	u32 val;
 
 	if (MTK_HAS_CAPS(eth->soc->caps, MTK_NETSYS_V2)) {
 		entry->ib1 &= ~MTK_FOE_IB1_BIND_TIMESTAMP_V2;
@@ -656,8 +657,13 @@ __mtk_foe_entry_commit(struct mtk_ppe *ppe, struct mtk_foe_entry *entry,
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
index 13dd7988e95c..321aea4bde85 100644
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
2.39.0

