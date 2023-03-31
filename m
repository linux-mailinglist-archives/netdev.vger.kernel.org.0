Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDD4D6D213B
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 15:13:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232377AbjCaNNm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 09:13:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232760AbjCaNNk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 09:13:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 848611B7D0;
        Fri, 31 Mar 2023 06:13:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2CC0CB82F6A;
        Fri, 31 Mar 2023 13:13:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 846DEC433EF;
        Fri, 31 Mar 2023 13:13:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680268415;
        bh=hLAVugf0wJMRhEaxQsvqqH7c9szSLlu5vrY4HfSo9tU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EIbzxKeiYwg4H5W5KbXKGlMazIyivy0rCuyVuSKwL6EuM9HG2PbqrCHGOgpdq6AUj
         Zx/DsteS5DrWzVcrx0dKvjlwx3Z4f2HLUvT5IXxvgZ3H9jEpax0Qoc89VqONaU77+Q
         7zUzavyXeHuqR2kYJ2tHBIHXYXtQmgH4FnoQ/V1p8RurjADnS0MIoC36MrHkJGfzlP
         aWZAroYpC23dNVzCrW09maHjIylqy5BpOkETQkw68ED994GniBBc9qPEJDLSXY/vXg
         fI70Mp+tWHu9kx1lwikE0O6haXvo1Zks7pYEhuaLjUNuu+SEWD1CuZU7BsZKwvpNsb
         glkwmp/b1s0PA==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        kuba@kernel.org, matthias.bgg@gmail.com,
        linux-mediatek@lists.infradead.org, nbd@nbd.name, john@phrozen.org,
        sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        lorenzo.bianconi@redhat.com, daniel@makrotopia.org,
        krzysztof.kozlowski+dt@linaro.org, robh+dt@kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH v2 net-next 02/10] net: ethernet: mtk_wed: move cpuboot in a dedicated dts node
Date:   Fri, 31 Mar 2023 15:12:38 +0200
Message-Id: <56ed497762b1c031c553210a0e5c7717c6069642.1680268101.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <cover.1680268101.git.lorenzo@kernel.org>
References: <cover.1680268101.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since the cpuboot memory region is not part of the RAM MT7986 SoC,
move cpuboot in a deidicated syscon node.
Keep backward-compatibility with older dts version where cpuboot was
defined as reserved-memory child node.

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/mediatek/mtk_wed_mcu.c | 34 +++++++++++++++++----
 drivers/net/ethernet/mediatek/mtk_wed_wo.h  |  3 +-
 2 files changed, 30 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_wed_mcu.c b/drivers/net/ethernet/mediatek/mtk_wed_mcu.c
index 6624f6d6abdd..797c3b412ab6 100644
--- a/drivers/net/ethernet/mediatek/mtk_wed_mcu.c
+++ b/drivers/net/ethernet/mediatek/mtk_wed_mcu.c
@@ -18,12 +18,23 @@
 
 static u32 wo_r32(struct mtk_wed_wo *wo, u32 reg)
 {
-	return readl(wo->boot.addr + reg);
+	u32 val;
+
+	if (!wo->boot_regmap)
+		return readl(wo->boot.addr + reg);
+
+	if (regmap_read(wo->boot_regmap, reg, &val))
+		val = ~0;
+
+	return val;
 }
 
 static void wo_w32(struct mtk_wed_wo *wo, u32 reg, u32 val)
 {
-	writel(val, wo->boot.addr + reg);
+	if (wo->boot_regmap)
+		regmap_write(wo->boot_regmap, reg, val);
+	else
+		writel(val, wo->boot.addr + reg);
 }
 
 static struct sk_buff *
@@ -316,10 +327,21 @@ mtk_wed_mcu_load_firmware(struct mtk_wed_wo *wo)
 			return ret;
 	}
 
-	wo->boot.name = "wo-boot";
-	ret = mtk_wed_get_reserved_memory_region(wo, &wo->boot);
-	if (ret)
-		return ret;
+	wo->boot_regmap = syscon_regmap_lookup_by_phandle(wo->hw->node,
+							  "mediatek,wo-cpuboot");
+	if (IS_ERR(wo->boot_regmap)) {
+		if (wo->boot_regmap != ERR_PTR(-ENODEV))
+			return PTR_ERR(wo->boot_regmap);
+
+		/* For backward compatibility, we need to check if cpu_boot
+		 * is defined through reserved memory property.
+		 */
+		wo->boot_regmap = NULL;
+		wo->boot.name = "wo-boot";
+		ret = mtk_wed_get_reserved_memory_region(wo, &wo->boot);
+		if (ret)
+			return ret;
+	}
 
 	/* set dummy cr */
 	wed_w32(wo->hw->wed_dev, MTK_WED_SCR0 + 4 * MTK_WED_DUMMY_CR_FWDL,
diff --git a/drivers/net/ethernet/mediatek/mtk_wed_wo.h b/drivers/net/ethernet/mediatek/mtk_wed_wo.h
index dbcf42ce9173..c03071203cc0 100644
--- a/drivers/net/ethernet/mediatek/mtk_wed_wo.h
+++ b/drivers/net/ethernet/mediatek/mtk_wed_wo.h
@@ -227,7 +227,8 @@ struct mtk_wed_wo_queue {
 
 struct mtk_wed_wo {
 	struct mtk_wed_hw *hw;
-	struct mtk_wed_wo_memory_region boot;
+	struct mtk_wed_wo_memory_region boot; /* backward compatibility */
+	struct regmap *boot_regmap;
 
 	struct mtk_wed_wo_queue q_tx;
 	struct mtk_wed_wo_queue q_rx;
-- 
2.39.2

