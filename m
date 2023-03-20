Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4984A6C1D44
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 18:07:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233375AbjCTRHB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 13:07:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232489AbjCTRGW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 13:06:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F2CC144A1;
        Mon, 20 Mar 2023 10:01:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 11BE161707;
        Mon, 20 Mar 2023 16:59:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 226FBC433EF;
        Mon, 20 Mar 2023 16:59:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679331561;
        bh=JtDTeOb+XfC/OkGaG3mNl+0+89/XnhPEztBv7Gcpg0k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mgnp5ehW8FoncfryGLBiiQ7ZfcPZRvHraZzOp9LBphJgbNAoghJsjwI/+It5GkAWf
         AVcHZIwVL36R39b4KNfytJXLwE491hffko00Y36Fmxw0879/hrWfELOoWamZPb7yPM
         fcMgV51QMuZNCwCYHj7kgvc4noeICyEwxh9xcg1txK59UMhrwufkGyXj1uS8fwgjHi
         kjcybCx3hYxgqVJd0quEib0FtpXD4F/8PxsFcEKh5J0h60QhC86P6/TOxoOvMcxIAD
         vsb2FjYq8S8m2y9G391+VgXH+cAlKka9nJKWQMCGassbE7Zp3AB0xpNIvr0X4vNKRt
         EjKLAk3sRZGjQ==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, matthias.bgg@gmail.com,
        linux-mediatek@lists.infradead.org, nbd@nbd.name, john@phrozen.org,
        sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        lorenzo.bianconi@redhat.com, daniel@makrotopia.org,
        krzysztof.kozlowski+dt@linaro.org, robh+dt@kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH net-next 08/10] net: ethernet: mtk_wed: move dlm a dedicated dts node
Date:   Mon, 20 Mar 2023 17:58:02 +0100
Message-Id: <a51411424bdb0a5c1a1662e157521bb101f52fe4.1679330630.git.lorenzo@kernel.org>
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

Since the dlm memory region is not part of the RAM SoC, move dlm in a
deidicated syscon node.
This patch helps to keep backward-compatibility with older version of
uboot codebase where we have a limit of 8 reserved-memory dts child
nodes.
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

