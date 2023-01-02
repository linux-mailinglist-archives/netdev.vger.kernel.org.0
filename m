Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3C5A65B443
	for <lists+netdev@lfdr.de>; Mon,  2 Jan 2023 16:33:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236155AbjABPc4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Jan 2023 10:32:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236404AbjABPco (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Jan 2023 10:32:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 072D1A1A2
        for <netdev@vger.kernel.org>; Mon,  2 Jan 2023 07:32:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A640FB80D85
        for <netdev@vger.kernel.org>; Mon,  2 Jan 2023 15:32:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 069E7C433D2;
        Mon,  2 Jan 2023 15:32:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672673560;
        bh=/sRFg6SqmVPO/qpLKPE3qyTl/CBHUjVYNZNwPNnVhZk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y5XxGIJ7tMzzS7rtnA8nXQcAq/zM7Fm+Njc9F5IUPyXlKelDd8PJAteAAgspsj9H3
         LJlH1RAhpRd6pcVqcB8gxYhn0mr7sN35Yvn3BBV10+iWkSju3Bq7F+KAvEhYkqaaXP
         QmZBh6M8/wIe5NcY2xTtby0ylRvgz0y6/eteulmP5ulvJvKRzKPcJ3E7FIrmQ11jhy
         b+mkwq2eMdtl7E/n5s0lpC0DltyOV3QP6xl/C82gxPpb2HEvB3eQTJqVkIUArOE1gH
         2L2dLAOuGVi7xHqY4dBLWpuwgVtNTzL0438qTTVZxgBZ9227PfWNKFohPOuDZcB55f
         2LtWiK35l/y7Q==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, lorenzo.bianconi@redhat.com, nbd@nbd.name,
        john@phrozen.org, sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        sujuan.chen@mediatek.com, daniel@makrotopia.org
Subject: [PATCH net-next 3/5] net: ethernet: mtk_eth_soc: align reset procedure to vendor sdk
Date:   Mon,  2 Jan 2023 16:32:17 +0100
Message-Id: <e40e80cf8214c20578afdf27330a0a9a9547e7a6.1672672965.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <cover.1672672965.git.lorenzo@kernel.org>
References: <cover.1672672965.git.lorenzo@kernel.org>
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

Avoid to power-down the ethernet chip during hw reset and align reset
procedure to vendor sdk.

Tested-by: Daniel Golle <daniel@makrotopia.org>
Co-developed-by: Sujuan Chen <sujuan.chen@mediatek.com>
Signed-off-by: Sujuan Chen <sujuan.chen@mediatek.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c  | 86 ++++++++++++++------
 drivers/net/ethernet/mediatek/mtk_eth_soc.h  | 12 +++
 drivers/net/ethernet/mediatek/mtk_ppe.c      | 27 ++++++
 drivers/net/ethernet/mediatek/mtk_ppe.h      |  1 +
 drivers/net/ethernet/mediatek/mtk_ppe_regs.h |  6 ++
 5 files changed, 108 insertions(+), 24 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index ffd4dbee0488..ba924ceb6c94 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -2984,14 +2984,29 @@ static void mtk_dma_free(struct mtk_eth *eth)
 	kfree(eth->scratch_head);
 }
 
+static bool mtk_hw_reset_check(struct mtk_eth *eth)
+{
+	u32 val = mtk_r32(eth, MTK_INT_STATUS2);
+
+	return (val & MTK_FE_INT_FQ_EMPTY) || (val & MTK_FE_INT_RFIFO_UF) ||
+	       (val & MTK_FE_INT_RFIFO_OV) || (val & MTK_FE_INT_TSO_FAIL) ||
+	       (val & MTK_FE_INT_TSO_ALIGN) || (val & MTK_FE_INT_TSO_ILLEGAL);
+}
+
 static void mtk_tx_timeout(struct net_device *dev, unsigned int txqueue)
 {
 	struct mtk_mac *mac = netdev_priv(dev);
 	struct mtk_eth *eth = mac->hw;
 
+	if (!mtk_hw_reset_check(eth))
+		return;
+
 	eth->netdev[mac->id]->stats.tx_errors++;
-	netif_err(eth, tx_err, dev,
-		  "transmit timed out\n");
+	netif_err(eth, tx_err, dev, "transmit timed out\n");
+
+	if (test_bit(MTK_RESETTING, &eth->state))
+		return;
+
 	schedule_work(&eth->pending_work);
 }
 
@@ -3546,15 +3561,17 @@ static int mtk_hw_init(struct mtk_eth *eth, bool reset)
 	const struct mtk_reg_map *reg_map = eth->soc->reg_map;
 	int i, val, ret;
 
-	if (test_and_set_bit(MTK_HW_INIT, &eth->state))
+	if (!reset && test_and_set_bit(MTK_HW_INIT, &eth->state))
 		return 0;
 
-	pm_runtime_enable(eth->dev);
-	pm_runtime_get_sync(eth->dev);
+	if (!reset) {
+		pm_runtime_enable(eth->dev);
+		pm_runtime_get_sync(eth->dev);
 
-	ret = mtk_clk_enable(eth);
-	if (ret)
-		goto err_disable_pm;
+		ret = mtk_clk_enable(eth);
+		if (ret)
+			goto err_disable_pm;
+	}
 
 	if (eth->ethsys)
 		regmap_update_bits(eth->ethsys, ETHSYS_DMA_AG_MAP, dma_mask,
@@ -3686,8 +3703,10 @@ static int mtk_hw_init(struct mtk_eth *eth, bool reset)
 	return 0;
 
 err_disable_pm:
-	pm_runtime_put_sync(eth->dev);
-	pm_runtime_disable(eth->dev);
+	if (!reset) {
+		pm_runtime_put_sync(eth->dev);
+		pm_runtime_disable(eth->dev);
+	}
 
 	return ret;
 }
@@ -3769,46 +3788,65 @@ static int mtk_do_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 static void mtk_pending_work(struct work_struct *work)
 {
 	struct mtk_eth *eth = container_of(work, struct mtk_eth, pending_work);
-	int err, i;
 	unsigned long restart = 0;
+	u32 val;
+	int i;
 
 	rtnl_lock();
-
-	dev_dbg(eth->dev, "[%s][%d] reset\n", __func__, __LINE__);
 	set_bit(MTK_RESETTING, &eth->state);
 
+	/* disabe FE P3 and P4 */
+	val = mtk_r32(eth, MTK_FE_GLO_CFG) | MTK_FE_LINK_DOWN_P3;
+	if (MTK_HAS_CAPS(eth->soc->caps, MTK_RSTCTRL_PPE1))
+		val |= MTK_FE_LINK_DOWN_P4;
+	mtk_w32(eth, val, MTK_FE_GLO_CFG);
+
+	/* adjust PPE configurations to prepare for reset */
+	for (i = 0; i < ARRAY_SIZE(eth->ppe); i++)
+		mtk_ppe_prepare_reset(eth->ppe[i]);
+
+	/* disable NETSYS interrupts */
+	mtk_w32(eth, 0, MTK_FE_INT_ENABLE);
+
+	/* force link down GMAC */
+	for (i = 0; i < 2; i++) {
+		val = mtk_r32(eth, MTK_MAC_MCR(i)) & ~MAC_MCR_FORCE_LINK;
+		mtk_w32(eth, val, MTK_MAC_MCR(i));
+	}
+
 	/* stop all devices to make sure that dma is properly shut down */
 	for (i = 0; i < MTK_MAC_COUNT; i++) {
-		if (!eth->netdev[i])
+		if (!eth->netdev[i] || !netif_running(eth->netdev[i]))
 			continue;
+
 		mtk_stop(eth->netdev[i]);
 		__set_bit(i, &restart);
 	}
-	dev_dbg(eth->dev, "[%s][%d] mtk_stop ends\n", __func__, __LINE__);
-
-	/* restart underlying hardware such as power, clock, pin mux
-	 * and the connected phy
-	 */
-	mtk_hw_deinit(eth);
+	mdelay(15);
 
 	if (eth->dev->pins)
 		pinctrl_select_state(eth->dev->pins->p,
 				     eth->dev->pins->default_state);
+
 	mtk_hw_init(eth, true);
 
 	/* restart DMA and enable IRQs */
 	for (i = 0; i < MTK_MAC_COUNT; i++) {
 		if (!test_bit(i, &restart))
 			continue;
-		err = mtk_open(eth->netdev[i]);
-		if (err) {
+
+		if (mtk_open(eth->netdev[i])) {
 			netif_alert(eth, ifup, eth->netdev[i],
-			      "Driver up/down cycle failed, closing device.\n");
+				    "Driver up/down cycle failed\n");
 			dev_close(eth->netdev[i]);
 		}
 	}
 
-	dev_dbg(eth->dev, "[%s][%d] reset done\n", __func__, __LINE__);
+	/* enabe FE P3 and P4 */
+	val = mtk_r32(eth, MTK_FE_GLO_CFG) & ~MTK_FE_LINK_DOWN_P3;
+	if (MTK_HAS_CAPS(eth->soc->caps, MTK_RSTCTRL_PPE1))
+		val &= ~MTK_FE_LINK_DOWN_P4;
+	mtk_w32(eth, val, MTK_FE_GLO_CFG);
 
 	clear_bit(MTK_RESETTING, &eth->state);
 
diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.h b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
index 18a50529ce7b..a8066b3ee3ed 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.h
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
@@ -77,12 +77,24 @@
 #define	MTK_HW_LRO_REPLACE_DELTA	1000
 #define	MTK_HW_LRO_SDL_REMAIN_ROOM	1522
 
+/* Frame Engine Global Configuration */
+#define MTK_FE_GLO_CFG		0x00
+#define MTK_FE_LINK_DOWN_P3	BIT(11)
+#define MTK_FE_LINK_DOWN_P4	BIT(12)
+
 /* Frame Engine Global Reset Register */
 #define MTK_RST_GL		0x04
 #define RST_GL_PSE		BIT(0)
 
 /* Frame Engine Interrupt Status Register */
 #define MTK_INT_STATUS2		0x08
+#define MTK_FE_INT_ENABLE	0x0c
+#define MTK_FE_INT_FQ_EMPTY	BIT(8)
+#define MTK_FE_INT_TSO_FAIL	BIT(12)
+#define MTK_FE_INT_TSO_ILLEGAL	BIT(13)
+#define MTK_FE_INT_TSO_ALIGN	BIT(14)
+#define MTK_FE_INT_RFIFO_OV	BIT(18)
+#define MTK_FE_INT_RFIFO_UF	BIT(19)
 #define MTK_GDM1_AF		BIT(28)
 #define MTK_GDM2_AF		BIT(29)
 
diff --git a/drivers/net/ethernet/mediatek/mtk_ppe.c b/drivers/net/ethernet/mediatek/mtk_ppe.c
index 269208a841c7..994408d8f416 100644
--- a/drivers/net/ethernet/mediatek/mtk_ppe.c
+++ b/drivers/net/ethernet/mediatek/mtk_ppe.c
@@ -730,6 +730,33 @@ int mtk_foe_entry_idle_time(struct mtk_ppe *ppe, struct mtk_flow_entry *entry)
 	return __mtk_foe_entry_idle_time(ppe, entry->data.ib1);
 }
 
+int mtk_ppe_prepare_reset(struct mtk_ppe *ppe)
+{
+	if (!ppe)
+		return -EINVAL;
+
+	/* disable KA */
+	ppe_clear(ppe, MTK_PPE_TB_CFG, MTK_PPE_TB_CFG_KEEPALIVE);
+	ppe_clear(ppe, MTK_PPE_BIND_LMT1, MTK_PPE_NTU_KEEPALIVE);
+	ppe_w32(ppe, MTK_PPE_KEEPALIVE, 0);
+	mdelay(10);
+
+	/* set KA timer to maximum */
+	ppe_set(ppe, MTK_PPE_BIND_LMT1, MTK_PPE_NTU_KEEPALIVE);
+	ppe_w32(ppe, MTK_PPE_KEEPALIVE, 0xffffffff);
+
+	/* set KA tick select */
+	ppe_set(ppe, MTK_PPE_TB_CFG, MTK_PPE_TB_TICK_SEL);
+	ppe_set(ppe, MTK_PPE_TB_CFG, MTK_PPE_TB_CFG_KEEPALIVE);
+	mdelay(10);
+
+	/* disable scan mode */
+	ppe_clear(ppe, MTK_PPE_TB_CFG, MTK_PPE_TB_CFG_SCAN_MODE);
+	mdelay(10);
+
+	return mtk_ppe_wait_busy(ppe);
+}
+
 struct mtk_ppe *mtk_ppe_init(struct mtk_eth *eth, void __iomem *base,
 			     int version, int index)
 {
diff --git a/drivers/net/ethernet/mediatek/mtk_ppe.h b/drivers/net/ethernet/mediatek/mtk_ppe.h
index ea64fac1d425..16b02e1d4649 100644
--- a/drivers/net/ethernet/mediatek/mtk_ppe.h
+++ b/drivers/net/ethernet/mediatek/mtk_ppe.h
@@ -309,6 +309,7 @@ struct mtk_ppe *mtk_ppe_init(struct mtk_eth *eth, void __iomem *base,
 void mtk_ppe_deinit(struct mtk_eth *eth);
 void mtk_ppe_start(struct mtk_ppe *ppe);
 int mtk_ppe_stop(struct mtk_ppe *ppe);
+int mtk_ppe_prepare_reset(struct mtk_ppe *ppe);
 
 void __mtk_ppe_check_skb(struct mtk_ppe *ppe, struct sk_buff *skb, u16 hash);
 
diff --git a/drivers/net/ethernet/mediatek/mtk_ppe_regs.h b/drivers/net/ethernet/mediatek/mtk_ppe_regs.h
index 59596d823d8b..0fdb983b0a88 100644
--- a/drivers/net/ethernet/mediatek/mtk_ppe_regs.h
+++ b/drivers/net/ethernet/mediatek/mtk_ppe_regs.h
@@ -58,6 +58,12 @@
 #define MTK_PPE_TB_CFG_SCAN_MODE		GENMASK(17, 16)
 #define MTK_PPE_TB_CFG_HASH_DEBUG		GENMASK(19, 18)
 #define MTK_PPE_TB_CFG_INFO_SEL			BIT(20)
+#define MTK_PPE_TB_TICK_SEL			BIT(24)
+
+#define MTK_PPE_BIND_LMT1			0x230
+#define MTK_PPE_NTU_KEEPALIVE			GENMASK(23, 16)
+
+#define MTK_PPE_KEEPALIVE			0x234
 
 enum {
 	MTK_PPE_SCAN_MODE_DISABLED,
-- 
2.39.0

