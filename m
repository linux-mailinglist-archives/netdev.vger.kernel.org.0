Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA292660F9D
	for <lists+netdev@lfdr.de>; Sat,  7 Jan 2023 15:51:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230384AbjAGOve (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Jan 2023 09:51:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229904AbjAGOvb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Jan 2023 09:51:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE6B94FD67
        for <netdev@vger.kernel.org>; Sat,  7 Jan 2023 06:51:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 495F7B8196F
        for <netdev@vger.kernel.org>; Sat,  7 Jan 2023 14:51:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2554C433EF;
        Sat,  7 Jan 2023 14:51:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673103088;
        bh=bw1ec3pKGpb+GBBanQlISCF/qA9bXpn0M+IOi41r4ao=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M9c8Nv8SLhacdZaG80FS3as8fqlP2c5qqcG/Rhamk3n8KdQ7TPsK7wwU7LbjcYOqJ
         yFjU3BwM7vWJMRvTQ6hSEQh4PtpGrpG6BwSYfXPreia4wBwKCCGKEAaeHmFped3mRJ
         NuKNqJlHptJFPb3diNo+RNA2+dGlhO3ZXjQKz9ZiCSxID76Amv7WQMXNh9027LzGOc
         HP46a8756Yxe7ER7GZvyNGZNeJWKY9YYEwXRdjTMnEaCxJbroaN7zmb0gdsOWbWV/W
         /+nizsbn4gYn5ggXVhhSCCuZYFRkycN7JAWt/K2uYwftLWv8gjgWNFOiqY85dXV96D
         9qr6bHIsfufsg==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, lorenzo.bianconi@redhat.com, nbd@nbd.name,
        john@phrozen.org, sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        sujuan.chen@mediatek.com, daniel@makrotopia.org, leon@kernel.org
Subject: [PATCH v3 net-next 2/5] net: ethernet: mtk_eth_soc: introduce mtk_hw_warm_reset support
Date:   Sat,  7 Jan 2023 15:50:51 +0100
Message-Id: <6bdcaf8ce5093e6e9e48b35f02524bfc3cf9f90f.1673102767.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <cover.1673102767.git.lorenzo@kernel.org>
References: <cover.1673102767.git.lorenzo@kernel.org>
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

Tested-by: Daniel Golle <daniel@makrotopia.org>
Co-developed-by: Sujuan Chen <sujuan.chen@mediatek.com>
Signed-off-by: Sujuan Chen <sujuan.chen@mediatek.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 59 +++++++++++++++++++--
 1 file changed, 55 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index ce429deea389..ffd4dbee0488 100644
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
@@ -3531,7 +3578,11 @@ static int mtk_hw_init(struct mtk_eth *eth)
 		return 0;
 	}
 
-	mtk_hw_reset(eth);
+	mdelay(100);
+	if (reset)
+		mtk_hw_warm_reset(eth);
+	else
+		mtk_hw_reset(eth);
 
 	if (MTK_HAS_CAPS(eth->soc->caps, MTK_NETSYS_V2)) {
 		/* Set FE to PDMAv2 if necessary */
@@ -3743,7 +3794,7 @@ static void mtk_pending_work(struct work_struct *work)
 	if (eth->dev->pins)
 		pinctrl_select_state(eth->dev->pins->p,
 				     eth->dev->pins->default_state);
-	mtk_hw_init(eth);
+	mtk_hw_init(eth, true);
 
 	/* restart DMA and enable IRQs */
 	for (i = 0; i < MTK_MAC_COUNT; i++) {
@@ -4372,7 +4423,7 @@ static int mtk_probe(struct platform_device *pdev)
 	eth->msg_enable = netif_msg_init(mtk_msg_level, MTK_DEFAULT_MSG_ENABLE);
 	INIT_WORK(&eth->pending_work, mtk_pending_work);
 
-	err = mtk_hw_init(eth);
+	err = mtk_hw_init(eth, false);
 	if (err)
 		goto err_wed_exit;
 
-- 
2.39.0

