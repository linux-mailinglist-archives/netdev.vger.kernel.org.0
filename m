Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09C546C1DC0
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 18:23:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232706AbjCTRXv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 13:23:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232691AbjCTRXZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 13:23:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03CD4BBB0;
        Mon, 20 Mar 2023 10:19:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4457EB80FA6;
        Mon, 20 Mar 2023 16:59:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD177C433EF;
        Mon, 20 Mar 2023 16:59:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679331550;
        bh=zBR/CZyJ28kqYG49+d/k9o/82Jp0pG3tobqqcDf2lo0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rUr/2Xbs9M66djwtqMYR+hNW+hPSW8Y+pWI8x5o51unJK6ZGPSiXxgpeddswGs3FY
         tOxQq/jR+qXdTrfxHjH645JPz3H69hU14TdSX/9AQhqJ7ZsC4ZiYtBlFk6ECzUcgw7
         jQj/p9c+wDqa4fmBCINe8uRS51Q6VO0oNZgUUe6qVbFTW56IDb+8nPNqGWCKwn2/fW
         BWjVtDLOmoqmVocpEjmVVLHZsHpQu/q/d4K/Qj7aOAGcfCkZlJwsrD1QVmKOHSTnvN
         +t6K512qbV7P45bRmBgJqmZpcRlEUXImaMNj33vmHvkIljqVlRAQ4d1KDC5Nyoie6J
         cutm8Dmq5leoA==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, matthias.bgg@gmail.com,
        linux-mediatek@lists.infradead.org, nbd@nbd.name, john@phrozen.org,
        sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        lorenzo.bianconi@redhat.com, daniel@makrotopia.org,
        krzysztof.kozlowski+dt@linaro.org, robh+dt@kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH net-next 05/10] net: ethernet: mtk_wed: move ilm a dedicated dts node
Date:   Mon, 20 Mar 2023 17:57:59 +0100
Message-Id: <93f309bafc6f3f9ddeeba81eea04b3769e70febf.1679330630.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <cover.1679330630.git.lorenzo@kernel.org>
References: <cover.1679330630.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since the ilm memory region is not part of the RAM SoC, move ilm in a
deidicated syscon node.
This patch helps to keep backward-compatibility with older version of
uboot codebase where we have a limit of 8 reserved-memory dts child
nodes.
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

