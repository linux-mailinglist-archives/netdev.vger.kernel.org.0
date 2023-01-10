Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE8E36647A6
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 18:49:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233607AbjAJRtx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 12:49:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231901AbjAJRts (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 12:49:48 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72C195F906
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 09:49:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EA5D2615DB
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 17:49:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDBD6C43396;
        Tue, 10 Jan 2023 17:49:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673372986;
        bh=84Wz7Jt9iYzWSBV2lxhpj+patoulksrKzLEtGfjx7T8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MUDJY4nyTShv4ksSjyqjsVsb3Zhqijl1Bbxiv6VJ9cVbhcJ6anDT6VXe4CVCN0CqD
         k+49XOLZi2Hwm8zVgyFOQ/OSaXKyf8VB1hcOaZVreSMXhINtTTTxyqZPky6dxzBC9d
         JYpxJ895p6lFn/lKTRc+4Gjo3zRuxWzQQoLJOQf7zCD7FMaGCefcduRxA/bty8c0Px
         lnEH0CLNG1lECGtg7SZO9wMpyXINFkJeK52yLT6amcmJ/kRdrD9BcNw3cFC5pcMvSw
         nZ8mg804pJoJcaEJlw2/PmY2r1i588mQjOBu6lmjoYchVRBA4MIYbVF3wj0m9y9uLU
         UPuIaeCQ3bGeA==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, lorenzo.bianconi@redhat.com, nbd@nbd.name,
        john@phrozen.org, sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        sujuan.chen@mediatek.com, daniel@makrotopia.org, leon@kernel.org
Subject: [PATCH v4 net-next 2/5] net: ethernet: mtk_eth_soc: introduce mtk_hw_warm_reset support
Date:   Tue, 10 Jan 2023 18:49:22 +0100
Message-Id: <781324174da25b7f3ee005726ea8c425ec714e59.1673372414.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <cover.1673372414.git.lorenzo@kernel.org>
References: <cover.1673372414.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce mtk_hw_warm_reset utility routine. This is a preliminary patch
to align reset procedure to vendor sdk and avoid to power down the chip
during hw reset.

Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Tested-by: Daniel Golle <daniel@makrotopia.org>
Co-developed-by: Sujuan Chen <sujuan.chen@mediatek.com>
Signed-off-by: Sujuan Chen <sujuan.chen@mediatek.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 60 +++++++++++++++++++--
 1 file changed, 56 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index ce429deea389..051c81eff403 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -3492,7 +3492,54 @@ static void mtk_hw_reset(struct mtk_eth *eth)
 			     0x3ffffff);
 }
 
-static int mtk_hw_init(struct mtk_eth *eth)
+static u32 mtk_hw_reset_read(struct mtk_eth *eth)
+{
+	u32 val;
+
+	regmap_read(eth->ethsys, ETHSYS_RSTCTRL, &val);
+	return val;
+}
+
+static void mtk_hw_warm_reset(struct mtk_eth *eth)
+{
+	u32 rst_mask, val;
+
+	regmap_update_bits(eth->ethsys, ETHSYS_RSTCTRL, RSTCTRL_FE,
+			   RSTCTRL_FE);
+	if (readx_poll_timeout_atomic(mtk_hw_reset_read, eth, val,
+				      val & RSTCTRL_FE, 1, 1000)) {
+		dev_err(eth->dev, "warm reset failed\n");
+		mtk_hw_reset(eth);
+		return;
+	}
+
+	if (MTK_HAS_CAPS(eth->soc->caps, MTK_NETSYS_V2))
+		rst_mask = RSTCTRL_ETH | RSTCTRL_PPE0_V2;
+	else
+		rst_mask = RSTCTRL_ETH | RSTCTRL_PPE0;
+
+	if (MTK_HAS_CAPS(eth->soc->caps, MTK_RSTCTRL_PPE1))
+		rst_mask |= RSTCTRL_PPE1;
+
+	regmap_update_bits(eth->ethsys, ETHSYS_RSTCTRL, rst_mask, rst_mask);
+
+	udelay(1);
+	val = mtk_hw_reset_read(eth);
+	if (!(val & rst_mask))
+		dev_err(eth->dev, "warm reset stage0 failed %08x (%08x)\n",
+			val, rst_mask);
+
+	rst_mask |= RSTCTRL_FE;
+	regmap_update_bits(eth->ethsys, ETHSYS_RSTCTRL, rst_mask, ~rst_mask);
+
+	udelay(1);
+	val = mtk_hw_reset_read(eth);
+	if (val & rst_mask)
+		dev_err(eth->dev, "warm reset stage1 failed %08x (%08x)\n",
+			val, rst_mask);
+}
+
+static int mtk_hw_init(struct mtk_eth *eth, bool reset)
 {
 	u32 dma_mask = ETHSYS_DMA_AG_MAP_PDMA | ETHSYS_DMA_AG_MAP_QDMA |
 		       ETHSYS_DMA_AG_MAP_PPE;
@@ -3531,7 +3578,12 @@ static int mtk_hw_init(struct mtk_eth *eth)
 		return 0;
 	}
 
-	mtk_hw_reset(eth);
+	msleep(100);
+
+	if (reset)
+		mtk_hw_warm_reset(eth);
+	else
+		mtk_hw_reset(eth);
 
 	if (MTK_HAS_CAPS(eth->soc->caps, MTK_NETSYS_V2)) {
 		/* Set FE to PDMAv2 if necessary */
@@ -3743,7 +3795,7 @@ static void mtk_pending_work(struct work_struct *work)
 	if (eth->dev->pins)
 		pinctrl_select_state(eth->dev->pins->p,
 				     eth->dev->pins->default_state);
-	mtk_hw_init(eth);
+	mtk_hw_init(eth, true);
 
 	/* restart DMA and enable IRQs */
 	for (i = 0; i < MTK_MAC_COUNT; i++) {
@@ -4372,7 +4424,7 @@ static int mtk_probe(struct platform_device *pdev)
 	eth->msg_enable = netif_msg_init(mtk_msg_level, MTK_DEFAULT_MSG_ENABLE);
 	INIT_WORK(&eth->pending_work, mtk_pending_work);
 
-	err = mtk_hw_init(eth);
+	err = mtk_hw_init(eth, false);
 	if (err)
 		goto err_wed_exit;
 
-- 
2.39.0

