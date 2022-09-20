Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 946BB5BE2D5
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 12:14:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229797AbiITKMl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 06:12:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229723AbiITKMI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 06:12:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ECC85F7FC;
        Tue, 20 Sep 2022 03:12:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 34FA7B81996;
        Tue, 20 Sep 2022 10:12:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9779EC433D6;
        Tue, 20 Sep 2022 10:12:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663668725;
        bh=HTELgz85dgkOVYCUXWEEGsWAO5SlTj5qt8mMqZOd+0o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GTrEDVRTJI+js4t1CaulOeuPP0GFDlX9/UdCnae3im7u6zS/d+fefAcTtrPhcPD/I
         f9RuWl2gaXluqALRo8ZZWtw6KujZdQKbYeLZ0F83LKTiChhMIxQ9h92wW4fbPbo6kR
         y1x3q/b/rVTyTBme0WcgeXyy5dN2BxOWZfuJiHmumWTFLGhlRJWQ07RlQF5Hu4NN8B
         +qzmF8aRbOzNWxxHax9KjhqjHALYLF2NvgKl9BdTLdm4QhlxjR4RAuVrggif3Tc8dX
         UbGGu2a0/rK0uVQceohmUDKxk2JzIL7RcAr3cV97lmLyx0pWkO6pgcwwMYvLPjo6LI
         nHjnsb8bwQQ9A==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, matthias.bgg@gmail.com,
        linux-mediatek@lists.infradead.org, lorenzo.bianconi@redhat.com,
        Bo.Jiao@mediatek.com, sujuan.chen@mediatek.com,
        ryder.Lee@mediatek.com, evelyn.tsai@mediatek.com,
        devicetree@vger.kernel.org, robh@kernel.org, daniel@makrotopia.org
Subject: [PATCH v3 net-next 03/11] net: ethernet: mtk_eth_soc: move gdma_to_ppe and ppe_base definitions in mtk register map
Date:   Tue, 20 Sep 2022 12:11:15 +0200
Message-Id: <38accf9b69e8d10e0f9dd3e1f561d14a84661742.1663668203.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <cover.1663668203.git.lorenzo@kernel.org>
References: <cover.1663668203.git.lorenzo@kernel.org>
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

This is a preliminary patch to introduce mt7986 hw packet engine.

Tested-by: Daniel Golle <daniel@makrotopia.org>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 15 +++++++++++----
 drivers/net/ethernet/mediatek/mtk_eth_soc.h |  3 ++-
 drivers/net/ethernet/mediatek/mtk_ppe.h     |  2 --
 3 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index c19c67a480ae..b2b92fe2a96a 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -73,6 +73,8 @@ static const struct mtk_reg_map mtk_reg_map = {
 		.fq_blen	= 0x1b2c,
 	},
 	.gdm1_cnt		= 0x2400,
+	.gdma_to_ppe		= 0x4444,
+	.ppe_base		= 0x0c00,
 };
 
 static const struct mtk_reg_map mt7628_reg_map = {
@@ -126,6 +128,8 @@ static const struct mtk_reg_map mt7986_reg_map = {
 		.fq_blen	= 0x472c,
 	},
 	.gdm1_cnt		= 0x1c00,
+	.gdma_to_ppe		= 0x3333,
+	.ppe_base		= 0x2000,
 };
 
 /* strings used by ethtool */
@@ -2978,21 +2982,22 @@ static int mtk_open(struct net_device *dev)
 
 	/* we run 2 netdevs on the same dma ring so we only bring it up once */
 	if (!refcount_read(&eth->dma_refcnt)) {
+		const struct mtk_soc_data *soc = eth->soc;
 		u32 gdm_config = MTK_GDMA_TO_PDMA;
 
 		err = mtk_start_dma(eth);
 		if (err)
 			return err;
 
-		if (eth->soc->offload_version && mtk_ppe_start(eth->ppe) == 0)
-			gdm_config = MTK_GDMA_TO_PPE;
+		if (soc->offload_version && mtk_ppe_start(eth->ppe) == 0)
+			gdm_config = soc->reg_map->gdma_to_ppe;
 
 		mtk_gdm_config(eth, gdm_config);
 
 		napi_enable(&eth->tx_napi);
 		napi_enable(&eth->rx_napi);
 		mtk_tx_irq_enable(eth, MTK_TX_DONE_INT);
-		mtk_rx_irq_enable(eth, eth->soc->txrx.rx_irq_done_mask);
+		mtk_rx_irq_enable(eth, soc->txrx.rx_irq_done_mask);
 		refcount_set(&eth->dma_refcnt, 1);
 	}
 	else
@@ -4098,7 +4103,9 @@ static int mtk_probe(struct platform_device *pdev)
 	}
 
 	if (eth->soc->offload_version) {
-		eth->ppe = mtk_ppe_init(eth, eth->base + MTK_ETH_PPE_BASE, 2);
+		u32 ppe_addr = eth->soc->reg_map->ppe_base;
+
+		eth->ppe = mtk_ppe_init(eth, eth->base + ppe_addr, 2);
 		if (!eth->ppe) {
 			err = -ENOMEM;
 			goto err_free_dev;
diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.h b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
index ecf85e9ed824..2617cbecdfca 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.h
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
@@ -105,7 +105,6 @@
 #define MTK_GDMA_TCS_EN		BIT(21)
 #define MTK_GDMA_UCS_EN		BIT(20)
 #define MTK_GDMA_TO_PDMA	0x0
-#define MTK_GDMA_TO_PPE		0x4444
 #define MTK_GDMA_DROP_ALL       0x7777
 
 /* Unicast Filter MAC Address Register - Low */
@@ -955,6 +954,8 @@ struct mtk_reg_map {
 		u32	fq_blen;	/* fq free page buffer length */
 	} qdma;
 	u32	gdm1_cnt;
+	u32	gdma_to_ppe;
+	u32	ppe_base;
 };
 
 /* struct mtk_eth_data -	This is the structure holding all differences
diff --git a/drivers/net/ethernet/mediatek/mtk_ppe.h b/drivers/net/ethernet/mediatek/mtk_ppe.h
index 8f786c47b61a..bb079e3c0417 100644
--- a/drivers/net/ethernet/mediatek/mtk_ppe.h
+++ b/drivers/net/ethernet/mediatek/mtk_ppe.h
@@ -8,8 +8,6 @@
 #include <linux/bitfield.h>
 #include <linux/rhashtable.h>
 
-#define MTK_ETH_PPE_BASE		0xc00
-
 #define MTK_PPE_ENTRIES_SHIFT		3
 #define MTK_PPE_ENTRIES			(1024 << MTK_PPE_ENTRIES_SHIFT)
 #define MTK_PPE_HASH_MASK		(MTK_PPE_ENTRIES - 1)
-- 
2.37.3

