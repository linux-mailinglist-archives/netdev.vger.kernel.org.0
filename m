Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C13856D2141
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 15:14:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232238AbjCaNN7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 09:13:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232776AbjCaNNv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 09:13:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A97C81A944;
        Fri, 31 Mar 2023 06:13:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 31A9C62908;
        Fri, 31 Mar 2023 13:13:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B04DC433D2;
        Fri, 31 Mar 2023 13:13:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680268427;
        bh=iXJPhBHDQg2tjMUV/aUNW08i5wKVl3q2xMq8Iulzdpo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jyqdu4ZqH8jKKsKkEKYXmG/tJLnw/KRGgCnUJasU02/vKuL7PojM739thQGSiuESC
         RV88IsI4GaqK2nNDJNTw9vXJFlHfxn9jEfiK5f8qyR8H81P6iJkB7DmPlahRzJcur4
         ZX6wh+55tulzpmBz4Va5XM11fuOoOu2NjfJJai2422ikyODBrDA2Wa5MDUA/B8gPBZ
         n2t55cYQhxmcR0Sw1dVGueFApwOSJSIfRX7jXSFRplBsnIJfdPxvokVtXDhueXjTGG
         q4iwBEISCAhheodfW7vP0zyyILtNd5OQP/qpsd+ETyn75+sP/4LadPEH4XnxOXZo5k
         PTUFRRz1LDegw==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        kuba@kernel.org, matthias.bgg@gmail.com,
        linux-mediatek@lists.infradead.org, nbd@nbd.name, john@phrozen.org,
        sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        lorenzo.bianconi@redhat.com, daniel@makrotopia.org,
        krzysztof.kozlowski+dt@linaro.org, robh+dt@kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH v2 net-next 05/10] net: ethernet: mtk_wed: move ilm a dedicated dts node
Date:   Fri, 31 Mar 2023 15:12:41 +0200
Message-Id: <44c210cd9135e9574ae7c2c01070aa58d39d018f.1680268101.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <cover.1680268101.git.lorenzo@kernel.org>
References: <cover.1680268101.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since the ilm memory region is not part of the MT7986 RAM SoC, move ilm
in a deidicated syscon node.
Keep backward-compatibility with older dts version where ilm was defined
as reserved-memory child node.

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/mediatek/mtk_wed_mcu.c | 55 ++++++++++++++++++---
 1 file changed, 49 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_wed_mcu.c b/drivers/net/ethernet/mediatek/mtk_wed_mcu.c
index 797c3b412ab6..a19db914ebd2 100644
--- a/drivers/net/ethernet/mediatek/mtk_wed_mcu.c
+++ b/drivers/net/ethernet/mediatek/mtk_wed_mcu.c
@@ -299,6 +299,52 @@ mtk_wed_mcu_run_firmware(struct mtk_wed_wo *wo, const struct firmware *fw,
 	return -EINVAL;
 }
 
+static int
+mtk_wed_mcu_load_memory_regions(struct mtk_wed_wo *wo,
+				struct mtk_wed_wo_memory_region *region)
+{
+	struct device_node *np;
+	int ret;
+
+	/* firmware EMI memory region */
+	ret = mtk_wed_get_reserved_memory_region(wo,
+			&region[MTK_WED_WO_REGION_EMI]);
+	if (ret)
+		return ret;
+
+	/* firmware DATA memory region */
+	ret = mtk_wed_get_reserved_memory_region(wo,
+			&region[MTK_WED_WO_REGION_DATA]);
+	if (ret)
+		return ret;
+
+	np = of_parse_phandle(wo->hw->node, "mediatek,wo-ilm", 0);
+	if (np) {
+		struct mtk_wed_wo_memory_region *ilm_region;
+		struct resource res;
+
+		ret = of_address_to_resource(np, 0, &res);
+		of_node_put(np);
+
+		if (ret < 0)
+			return ret;
+
+		ilm_region = &region[MTK_WED_WO_REGION_ILM];
+		ilm_region->phy_addr = res.start;
+		ilm_region->size = resource_size(&res);
+		ilm_region->addr = devm_ioremap(wo->hw->dev, ilm_region->phy_addr,
+						ilm_region->size);
+
+		return ilm_region->addr ? 0 : -ENOMEM;
+	}
+
+	/* For backward compatibility, we need to check if ILM
+	 * node is defined through reserved memory property.
+	 */
+	return mtk_wed_get_reserved_memory_region(wo,
+			&region[MTK_WED_WO_REGION_ILM]);
+}
+
 static int
 mtk_wed_mcu_load_firmware(struct mtk_wed_wo *wo)
 {
@@ -320,12 +366,9 @@ mtk_wed_mcu_load_firmware(struct mtk_wed_wo *wo)
 	u32 val, boot_cr;
 	int ret, i;
 
-	/* load firmware region metadata */
-	for (i = 0; i < ARRAY_SIZE(mem_region); i++) {
-		ret = mtk_wed_get_reserved_memory_region(wo, &mem_region[i]);
-		if (ret)
-			return ret;
-	}
+	ret = mtk_wed_mcu_load_memory_regions(wo, mem_region);
+	if (ret)
+		return ret;
 
 	wo->boot_regmap = syscon_regmap_lookup_by_phandle(wo->hw->node,
 							  "mediatek,wo-cpuboot");
-- 
2.39.2

