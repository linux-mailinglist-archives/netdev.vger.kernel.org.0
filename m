Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4A4E660FA0
	for <lists+netdev@lfdr.de>; Sat,  7 Jan 2023 15:51:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229704AbjAGOvp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Jan 2023 09:51:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231809AbjAGOvk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Jan 2023 09:51:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A82B5C904
        for <netdev@vger.kernel.org>; Sat,  7 Jan 2023 06:51:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E9C74B81913
        for <netdev@vger.kernel.org>; Sat,  7 Jan 2023 14:51:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54A91C433D2;
        Sat,  7 Jan 2023 14:51:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673103095;
        bh=8mzlzFAzx1Qx4ytWK2ouQXOwX3UbxBN1s2kwD4Z5Nys=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cWsv0NFHCV/m9Co3KEEmNEkJzVRZiidoFMZ3ihRJItsNr7C4uzDlT18YlVF6NXu6t
         af4HHcWldCkALbtXyjNPQX2IAGgxD4bttjHsY27vbjjxAe4ly+xfw+5rbSeczZMy0x
         3VfghCenGeHH/ucH1hrQhS8ZQqxHjuLJEdR4uwKu8t0pF0pt7nzc3JU3I4I2T9n0pa
         dPU2DeRxjXX78wiwg3/E6NsoR8N/Kj+RxTlyaeRsm4x5xDA0MwjBdo9WhwrMc4NPRM
         BDK6G5rDSCoffY6riGULWLtjb91WsKTTp80I1l8AMwxbFncsFyoIbxb5c+jA/79jzO
         PlAi9/GKmyv4Q==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, lorenzo.bianconi@redhat.com, nbd@nbd.name,
        john@phrozen.org, sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        sujuan.chen@mediatek.com, daniel@makrotopia.org, leon@kernel.org
Subject: [PATCH v3 net-next 4/5] net: ethernet: mtk_eth_soc: add dma checks to mtk_hw_reset_check
Date:   Sat,  7 Jan 2023 15:50:53 +0100
Message-Id: <0128a91db1788deef5bc48bd7c2760d8e2d28a7b.1673102767.git.lorenzo@kernel.org>
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

Introduce mtk_hw_check_dma_hang routine to monitor possible dma hangs.

Tested-by: Daniel Golle <daniel@makrotopia.org>
Co-developed-by: Sujuan Chen <sujuan.chen@mediatek.com>
Signed-off-by: Sujuan Chen <sujuan.chen@mediatek.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 106 ++++++++++++++++++++
 drivers/net/ethernet/mediatek/mtk_eth_soc.h |  26 +++++
 2 files changed, 132 insertions(+)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index 40bfffd2c6c0..f38a2f5a7d1e 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -51,6 +51,7 @@ static const struct mtk_reg_map mtk_reg_map = {
 		.delay_irq	= 0x0a0c,
 		.irq_status	= 0x0a20,
 		.irq_mask	= 0x0a28,
+		.adma_rx_dbg0	= 0x0a38,
 		.int_grp	= 0x0a50,
 	},
 	.qdma = {
@@ -82,6 +83,8 @@ static const struct mtk_reg_map mtk_reg_map = {
 		[0]		= 0x2800,
 		[1]		= 0x2c00,
 	},
+	.pse_iq_sta		= 0x0110,
+	.pse_oq_sta		= 0x0118,
 };
 
 static const struct mtk_reg_map mt7628_reg_map = {
@@ -112,6 +115,7 @@ static const struct mtk_reg_map mt7986_reg_map = {
 		.delay_irq	= 0x620c,
 		.irq_status	= 0x6220,
 		.irq_mask	= 0x6228,
+		.adma_rx_dbg0	= 0x6238,
 		.int_grp	= 0x6250,
 	},
 	.qdma = {
@@ -143,6 +147,8 @@ static const struct mtk_reg_map mt7986_reg_map = {
 		[0]		= 0x4800,
 		[1]		= 0x4c00,
 	},
+	.pse_iq_sta		= 0x0180,
+	.pse_oq_sta		= 0x01a0,
 };
 
 /* strings used by ethtool */
@@ -3554,6 +3560,102 @@ static void mtk_hw_warm_reset(struct mtk_eth *eth)
 			val, rst_mask);
 }
 
+static bool mtk_hw_check_dma_hang(struct mtk_eth *eth)
+{
+	const struct mtk_reg_map *reg_map = eth->soc->reg_map;
+	bool gmac1_tx, gmac2_tx, gdm1_tx, gdm2_tx;
+	bool oq_hang, cdm1_busy, adma_busy;
+	bool wtx_busy, cdm_full, oq_free;
+	u32 wdidx, val, gdm1_fc, gdm2_fc;
+	bool qfsm_hang, qfwd_hang;
+	bool ret = false;
+
+	if (MTK_HAS_CAPS(eth->soc->caps, MTK_SOC_MT7628))
+		return false;
+
+	/* WDMA sanity checks */
+	wdidx = mtk_r32(eth, reg_map->wdma_base[0] + 0xc);
+
+	val = mtk_r32(eth, reg_map->wdma_base[0] + 0x204);
+	wtx_busy = FIELD_GET(MTK_TX_DMA_BUSY, val);
+
+	val = mtk_r32(eth, reg_map->wdma_base[0] + 0x230);
+	cdm_full = !FIELD_GET(MTK_CDM_TXFIFO_RDY, val);
+
+	oq_free  = (!(mtk_r32(eth, reg_map->pse_oq_sta) & GENMASK(24, 16)) &&
+		    !(mtk_r32(eth, reg_map->pse_oq_sta + 0x4) & GENMASK(8, 0)) &&
+		    !(mtk_r32(eth, reg_map->pse_oq_sta + 0x10) & GENMASK(24, 16)));
+
+	if (wdidx == eth->reset.wdidx && wtx_busy && cdm_full && oq_free) {
+		if (++eth->reset.wdma_hang_count > 2) {
+			eth->reset.wdma_hang_count = 0;
+			ret = true;
+		}
+		goto out;
+	}
+
+	/* QDMA sanity checks */
+	qfsm_hang = !!mtk_r32(eth, reg_map->qdma.qtx_cfg + 0x234);
+	qfwd_hang = !mtk_r32(eth, reg_map->qdma.qtx_cfg + 0x308);
+
+	gdm1_tx = FIELD_GET(GENMASK(31, 16), mtk_r32(eth, MTK_FE_GDM1_FSM)) > 0;
+	gdm2_tx = FIELD_GET(GENMASK(31, 16), mtk_r32(eth, MTK_FE_GDM2_FSM)) > 0;
+	gmac1_tx = FIELD_GET(GENMASK(31, 24), mtk_r32(eth, MTK_MAC_FSM(0))) != 1;
+	gmac2_tx = FIELD_GET(GENMASK(31, 24), mtk_r32(eth, MTK_MAC_FSM(1))) != 1;
+	gdm1_fc = mtk_r32(eth, reg_map->gdm1_cnt + 0x24);
+	gdm2_fc = mtk_r32(eth, reg_map->gdm1_cnt + 0x64);
+
+	if (qfsm_hang && qfwd_hang &&
+	    ((gdm1_tx && gmac1_tx && gdm1_fc < 1) ||
+	     (gdm2_tx && gmac2_tx && gdm2_fc < 1))) {
+		if (++eth->reset.qdma_hang_count > 2) {
+			eth->reset.qdma_hang_count = 0;
+			ret = true;
+		}
+		goto out;
+	}
+
+	/* ADMA sanity checks */
+	oq_hang = !!(mtk_r32(eth, reg_map->pse_oq_sta) & GENMASK(8, 0));
+	cdm1_busy = !!(mtk_r32(eth, MTK_FE_CDM1_FSM) & GENMASK(31, 16));
+	adma_busy = !(mtk_r32(eth, reg_map->pdma.adma_rx_dbg0) & GENMASK(4, 0)) &&
+		    !(mtk_r32(eth, reg_map->pdma.adma_rx_dbg0) & BIT(6));
+
+	if (oq_hang && cdm1_busy && adma_busy) {
+		if (++eth->reset.adma_hang_count > 2) {
+			eth->reset.adma_hang_count = 0;
+			ret = true;
+		}
+		goto out;
+	}
+
+	eth->reset.wdma_hang_count = 0;
+	eth->reset.qdma_hang_count = 0;
+	eth->reset.adma_hang_count = 0;
+out:
+	eth->reset.wdidx = wdidx;
+
+	return ret;
+}
+
+static void mtk_hw_reset_monitor_work(struct work_struct *work)
+{
+	struct delayed_work *del_work = to_delayed_work(work);
+	struct mtk_eth *eth = container_of(del_work, struct mtk_eth,
+					   reset.monitor_work);
+
+	if (test_bit(MTK_RESETTING, &eth->state))
+		goto out;
+
+	/* DMA stuck checks */
+	if (mtk_hw_check_dma_hang(eth))
+		schedule_work(&eth->pending_work);
+
+out:
+	schedule_delayed_work(&eth->reset.monitor_work,
+			      MTK_DMA_MONITOR_TIMEOUT);
+}
+
 static int mtk_hw_init(struct mtk_eth *eth, bool reset)
 {
 	u32 dma_mask = ETHSYS_DMA_AG_MAP_PDMA | ETHSYS_DMA_AG_MAP_QDMA |
@@ -3902,6 +4004,7 @@ static int mtk_cleanup(struct mtk_eth *eth)
 	mtk_unreg_dev(eth);
 	mtk_free_dev(eth);
 	cancel_work_sync(&eth->pending_work);
+	cancel_delayed_work_sync(&eth->reset.monitor_work);
 
 	return 0;
 }
@@ -4356,6 +4459,7 @@ static int mtk_probe(struct platform_device *pdev)
 
 	eth->rx_dim.mode = DIM_CQ_PERIOD_MODE_START_FROM_EQE;
 	INIT_WORK(&eth->rx_dim.work, mtk_dim_rx);
+	INIT_DELAYED_WORK(&eth->reset.monitor_work, mtk_hw_reset_monitor_work);
 
 	eth->tx_dim.mode = DIM_CQ_PERIOD_MODE_START_FROM_EQE;
 	INIT_WORK(&eth->tx_dim.work, mtk_dim_tx);
@@ -4558,6 +4662,8 @@ static int mtk_probe(struct platform_device *pdev)
 	netif_napi_add(&eth->dummy_dev, &eth->rx_napi, mtk_napi_rx);
 
 	platform_set_drvdata(pdev, eth);
+	schedule_delayed_work(&eth->reset.monitor_work,
+			      MTK_DMA_MONITOR_TIMEOUT);
 
 	return 0;
 
diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.h b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
index a8066b3ee3ed..dff0e3ad2de6 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.h
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
@@ -284,6 +284,8 @@
 
 #define MTK_RX_DONE_INT_V2	BIT(14)
 
+#define MTK_CDM_TXFIFO_RDY	BIT(7)
+
 /* QDMA Interrupt grouping registers */
 #define MTK_RLS_DONE_INT	BIT(0)
 
@@ -574,6 +576,17 @@
 #define MT7628_SDM_RBCNT	(MT7628_SDM_OFFSET + 0x10c)
 #define MT7628_SDM_CS_ERR	(MT7628_SDM_OFFSET + 0x110)
 
+#define MTK_FE_CDM1_FSM		0x220
+#define MTK_FE_CDM2_FSM		0x224
+#define MTK_FE_CDM3_FSM		0x238
+#define MTK_FE_CDM4_FSM		0x298
+#define MTK_FE_CDM5_FSM		0x318
+#define MTK_FE_CDM6_FSM		0x328
+#define MTK_FE_GDM1_FSM		0x228
+#define MTK_FE_GDM2_FSM		0x22C
+
+#define MTK_MAC_FSM(x)		(0x1010C + ((x) * 0x100))
+
 struct mtk_rx_dma {
 	unsigned int rxd1;
 	unsigned int rxd2;
@@ -970,6 +983,7 @@ struct mtk_reg_map {
 		u32	delay_irq;	/* delay interrupt */
 		u32	irq_status;	/* interrupt status */
 		u32	irq_mask;	/* interrupt mask */
+		u32	adma_rx_dbg0;
 		u32	int_grp;
 	} pdma;
 	struct {
@@ -998,6 +1012,8 @@ struct mtk_reg_map {
 	u32	gdma_to_ppe;
 	u32	ppe_base;
 	u32	wdma_base[2];
+	u32	pse_iq_sta;
+	u32	pse_oq_sta;
 };
 
 /* struct mtk_eth_data -	This is the structure holding all differences
@@ -1040,6 +1056,8 @@ struct mtk_soc_data {
 	} txrx;
 };
 
+#define MTK_DMA_MONITOR_TIMEOUT		msecs_to_jiffies(1000)
+
 /* currently no SoC has more than 2 macs */
 #define MTK_MAX_DEVS			2
 
@@ -1164,6 +1182,14 @@ struct mtk_eth {
 	struct rhashtable		flow_table;
 
 	struct bpf_prog			__rcu *prog;
+
+	struct {
+		struct delayed_work monitor_work;
+		u32 wdidx;
+		u8 wdma_hang_count;
+		u8 qdma_hang_count;
+		u8 adma_hang_count;
+	} reset;
 };
 
 /* struct mtk_mac -	the structure that holds the info about the MACs of the
-- 
2.39.0

