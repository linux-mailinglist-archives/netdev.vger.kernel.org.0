Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C79816D2147
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 15:14:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232777AbjCaNOS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 09:14:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232774AbjCaNOK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 09:14:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D72CA20C2F;
        Fri, 31 Mar 2023 06:14:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 16797B82F6A;
        Fri, 31 Mar 2023 13:14:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8137FC433EF;
        Fri, 31 Mar 2023 13:13:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680268438;
        bh=N4DT9nDSliiFONQaT3jUyRHewbKeqGxRRHMjesy9rxc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jNYohSc0UcD9cddo/U7K31IbDSvz89gZSLvZUWkQXOqF/wvHNss9OWZIWy0Rq7ujh
         asHIMyuS2EWDoGW5Q27wlCkiRcb+erpnHE0iB8GXLwfA20nfmsRrrqmVwXsP04/DpG
         DrItq8R/XuQzqr2j/RlAbTeuWjl0h2trtxpfX//x3fqbgjfnpzhKrs8phEm4gT1yxZ
         4IwlTQA4lbC35RVkD10iAi6Qh6CYRipo6KIrP/10HcGB9EHiiJnVeG68ePOmMhlchC
         2d5sGpxfxMw7zDbNYuXhIsDpPGZ8wAaJtJZmNEllw+dYoHlAZNSUBDWwNRTzjJ470W
         xA9wjZNMTyuKw==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        kuba@kernel.org, matthias.bgg@gmail.com,
        linux-mediatek@lists.infradead.org, nbd@nbd.name, john@phrozen.org,
        sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        lorenzo.bianconi@redhat.com, daniel@makrotopia.org,
        krzysztof.kozlowski+dt@linaro.org, robh+dt@kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH v2 net-next 08/10] net: ethernet: mtk_wed: move dlm a dedicated dts node
Date:   Fri, 31 Mar 2023 15:12:44 +0200
Message-Id: <ba52543d377b0be558175ab4aaa9b6761e3760a4.1680268101.git.lorenzo@kernel.org>
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

Since the dlm memory region is not part of the MT7986 RAM SoC, move dlm
in a deidicated syscon node.
Keep backward-compatibility with older dts version where dlm was defined
as reserved-memory child node.

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/mediatek/mtk_wed.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/net/ethernet/mediatek/mtk_wed.c b/drivers/net/ethernet/mediatek/mtk_wed.c
index 95d890870984..e479ff924ed6 100644
--- a/drivers/net/ethernet/mediatek/mtk_wed.c
+++ b/drivers/net/ethernet/mediatek/mtk_wed.c
@@ -799,6 +799,24 @@ mtk_wed_rro_alloc(struct mtk_wed_device *dev)
 	struct device_node *np;
 	int index;
 
+	np = of_parse_phandle(dev->hw->node, "mediatek,wo-dlm", 0);
+	if (np) {
+		struct resource res;
+		int ret;
+
+		ret = of_address_to_resource(np, 0, &res);
+		of_node_put(np);
+
+		if (ret < 0)
+			return ret;
+
+		dev->rro.miod_phys = res.start;
+		goto out;
+	}
+
+	/* For backward compatibility, we need to check if DLM
+	 * node is defined through reserved memory property.
+	 */
 	index = of_property_match_string(dev->hw->node, "memory-region-names",
 					 "wo-dlm");
 	if (index < 0)
@@ -815,6 +833,7 @@ mtk_wed_rro_alloc(struct mtk_wed_device *dev)
 		return -ENODEV;
 
 	dev->rro.miod_phys = rmem->base;
+out:
 	dev->rro.fdbk_phys = MTK_WED_MIOD_COUNT + dev->rro.miod_phys;
 
 	return mtk_wed_rro_ring_alloc(dev, &dev->rro.ring,
-- 
2.39.2

