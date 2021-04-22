Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AC3D367853
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 06:13:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234952AbhDVEKi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 00:10:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234645AbhDVEKU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 00:10:20 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2EDEC061346;
        Wed, 21 Apr 2021 21:09:45 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id u7so21031959plr.6;
        Wed, 21 Apr 2021 21:09:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LeGN1TIsHoTlnNDOMwFfeD11Nj0rbSCDk8ueVuxEr88=;
        b=XIG86n4D2xFHlkDV3DZy1psGU+CGPH6veAipUmMg41/cibcBYQxDajZK4wzfBji9ID
         NVRw2A2M9M4Jh7fBPXqLKWL1tOSp3GEq01j+qb+1lHD8S4JA6NanuYZjJK5+NU5H4H/n
         wcCdRq837aKGKHpK5OeSn9RxMbdpROsX0gz1AiLM2IK1i49IdRogRDwcSjjrdfh9slfu
         try2qMLl9JHXY+Ki5SBBPoOY2ZtiwxwLxv0PLLmUaDhYB37+2TIldaWOPL9PkKtqWHWY
         52O5KtfPJi1OuTObgV0NmDi35CBO7dmeXqSaKwHtSkse2eB/sxyzKO2bCDx9YaqD+QZo
         SSDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LeGN1TIsHoTlnNDOMwFfeD11Nj0rbSCDk8ueVuxEr88=;
        b=WkWh5xPKtgmS3j6DOK3CT8J5SWgT9u2BtWj/OtTq7oX8mYCVaGUngVwmEX9VQ0vWjb
         BnXBsMzSV5F3uqs32j7ChSESkfA56kL8d6dt4JDypoYEdOrSsqz3YmKqzekVBWLSPH1s
         1mgozX4pNFlOJa0PWs8A5hwh5qNwbmvOBkz5awZJhK2/KeT8t8UFUtu9nD4KCmYoH2A6
         ceQQItFxqP7hEvc7DZBbCyJus+xWQjtsGazGSDhjHuFInY3uQgSihRYoj4nWO10KGHzu
         F2xKiQuCj0zs5KMoRFEs0+x/afTRhHZnmub1gCVks+fylKsuHh4rTy+QNcXYY+j2ZT4B
         j7FQ==
X-Gm-Message-State: AOAM530RcLwO1xBGpBBg2W+lb1MJjZSTnrB8Urm7PdJuv4jXYgU9zXmn
        yxlf7zWSVk10H+zIHzVyI/E=
X-Google-Smtp-Source: ABdhPJxjRgQf2k8PaCcPaM/QTjOWWMn7i1PDQmqEGIEEb4tYvev5okFJp7JF/VKhCYqdyaKiQPzf/w==
X-Received: by 2002:a17:90a:cd06:: with SMTP id d6mr1752435pju.91.1619064585218;
        Wed, 21 Apr 2021 21:09:45 -0700 (PDT)
Received: from z640-arch.lan ([2602:61:7344:f100::678])
        by smtp.gmail.com with ESMTPSA id i17sm635354pfd.84.2021.04.21.21.09.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Apr 2021 21:09:44 -0700 (PDT)
From:   Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
To:     Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Cc:     Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
Subject: [PATCH net-next 09/14] net: ethernet: mtk_eth_soc: implement dynamic interrupt moderation
Date:   Wed, 21 Apr 2021 21:09:09 -0700
Message-Id: <20210422040914.47788-10-ilya.lipnitskiy@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210422040914.47788-1-ilya.lipnitskiy@gmail.com>
References: <20210422040914.47788-1-ilya.lipnitskiy@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Felix Fietkau <nbd@nbd.name>

Reduces the number of interrupts under load

Signed-off-by: Felix Fietkau <nbd@nbd.name>
[Ilya: add documentation for new struct fields]
Signed-off-by: Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
---
 drivers/net/ethernet/mediatek/Kconfig       |  1 +
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 96 +++++++++++++++++++--
 drivers/net/ethernet/mediatek/mtk_eth_soc.h | 41 +++++++--
 3 files changed, 124 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/Kconfig b/drivers/net/ethernet/mediatek/Kconfig
index 08c2e446d3d5..c357c193378e 100644
--- a/drivers/net/ethernet/mediatek/Kconfig
+++ b/drivers/net/ethernet/mediatek/Kconfig
@@ -11,6 +11,7 @@ config NET_MEDIATEK_SOC
 	tristate "MediaTek SoC Gigabit Ethernet support"
 	depends on NET_DSA || !NET_DSA
 	select PHYLINK
+	select DIMLIB
 	help
 	  This driver supports the gigabit ethernet MACs in the
 	  MediaTek SoC family.
diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index 5a67bbe9bd90..043ab5446524 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -1231,12 +1231,13 @@ static void mtk_update_rx_cpu_idx(struct mtk_eth *eth)
 static int mtk_poll_rx(struct napi_struct *napi, int budget,
 		       struct mtk_eth *eth)
 {
+	struct dim_sample dim_sample = {};
 	struct mtk_rx_ring *ring;
 	int idx;
 	struct sk_buff *skb;
 	u8 *data, *new_data;
 	struct mtk_rx_dma *rxd, trxd;
-	int done = 0;
+	int done = 0, bytes = 0;
 
 	while (done < budget) {
 		struct net_device *netdev;
@@ -1310,6 +1311,7 @@ static int mtk_poll_rx(struct napi_struct *napi, int budget,
 		else
 			skb_checksum_none_assert(skb);
 		skb->protocol = eth_type_trans(skb, netdev);
+		bytes += pktlen;
 
 		if (netdev->features & NETIF_F_HW_VLAN_CTAG_RX &&
 		    (trxd.rxd2 & RX_DMA_VTAG))
@@ -1342,6 +1344,12 @@ static int mtk_poll_rx(struct napi_struct *napi, int budget,
 		mtk_update_rx_cpu_idx(eth);
 	}
 
+	eth->rx_packets += done;
+	eth->rx_bytes += bytes;
+	dim_update_sample(eth->rx_events, eth->rx_packets, eth->rx_bytes,
+			  &dim_sample);
+	net_dim(&eth->rx_dim, dim_sample);
+
 	return done;
 }
 
@@ -1434,6 +1442,7 @@ static int mtk_poll_tx_pdma(struct mtk_eth *eth, int budget,
 static int mtk_poll_tx(struct mtk_eth *eth, int budget)
 {
 	struct mtk_tx_ring *ring = &eth->tx_ring;
+	struct dim_sample dim_sample = {};
 	unsigned int done[MTK_MAX_DEVS];
 	unsigned int bytes[MTK_MAX_DEVS];
 	int total = 0, i;
@@ -1451,8 +1460,14 @@ static int mtk_poll_tx(struct mtk_eth *eth, int budget)
 			continue;
 		netdev_completed_queue(eth->netdev[i], done[i], bytes[i]);
 		total += done[i];
+		eth->tx_packets += done[i];
+		eth->tx_bytes += bytes[i];
 	}
 
+	dim_update_sample(eth->tx_events, eth->tx_packets, eth->tx_bytes,
+			  &dim_sample);
+	net_dim(&eth->tx_dim, dim_sample);
+
 	if (mtk_queue_stopped(eth) &&
 	    (atomic_read(&ring->free_count) > ring->thresh))
 		mtk_wake_queue(eth);
@@ -2127,6 +2142,7 @@ static irqreturn_t mtk_handle_irq_rx(int irq, void *_eth)
 {
 	struct mtk_eth *eth = _eth;
 
+	eth->rx_events++;
 	if (likely(napi_schedule_prep(&eth->rx_napi))) {
 		__napi_schedule(&eth->rx_napi);
 		mtk_rx_irq_disable(eth, MTK_RX_DONE_INT);
@@ -2139,6 +2155,7 @@ static irqreturn_t mtk_handle_irq_tx(int irq, void *_eth)
 {
 	struct mtk_eth *eth = _eth;
 
+	eth->tx_events++;
 	if (likely(napi_schedule_prep(&eth->tx_napi))) {
 		__napi_schedule(&eth->tx_napi);
 		mtk_tx_irq_disable(eth, MTK_TX_DONE_INT);
@@ -2323,6 +2340,9 @@ static int mtk_stop(struct net_device *dev)
 	napi_disable(&eth->tx_napi);
 	napi_disable(&eth->rx_napi);
 
+	cancel_work_sync(&eth->rx_dim.work);
+	cancel_work_sync(&eth->tx_dim.work);
+
 	if (MTK_HAS_CAPS(eth->soc->caps, MTK_QDMA))
 		mtk_stop_dma(eth, MTK_QDMA_GLO_CFG);
 	mtk_stop_dma(eth, MTK_PDMA_GLO_CFG);
@@ -2375,6 +2395,64 @@ static int mtk_clk_enable(struct mtk_eth *eth)
 	return ret;
 }
 
+static void mtk_dim_rx(struct work_struct *work)
+{
+	struct dim *dim = container_of(work, struct dim, work);
+	struct mtk_eth *eth = container_of(dim, struct mtk_eth, rx_dim);
+	struct dim_cq_moder cur_profile;
+	u32 val, cur;
+
+	cur_profile = net_dim_get_rx_moderation(eth->rx_dim.mode,
+						dim->profile_ix);
+	spin_lock_bh(&eth->dim_lock);
+
+	val = mtk_r32(eth, MTK_PDMA_DELAY_INT);
+	val &= MTK_PDMA_DELAY_TX_MASK;
+	val |= MTK_PDMA_DELAY_RX_EN;
+
+	cur = min_t(u32, DIV_ROUND_UP(cur_profile.usec, 20), MTK_PDMA_DELAY_PTIME_MASK);
+	val |= cur << MTK_PDMA_DELAY_RX_PTIME_SHIFT;
+
+	cur = min_t(u32, cur_profile.pkts, MTK_PDMA_DELAY_PINT_MASK);
+	val |= cur << MTK_PDMA_DELAY_RX_PINT_SHIFT;
+
+	mtk_w32(eth, val, MTK_PDMA_DELAY_INT);
+	mtk_w32(eth, val, MTK_QDMA_DELAY_INT);
+
+	spin_unlock_bh(&eth->dim_lock);
+
+	dim->state = DIM_START_MEASURE;
+}
+
+static void mtk_dim_tx(struct work_struct *work)
+{
+	struct dim *dim = container_of(work, struct dim, work);
+	struct mtk_eth *eth = container_of(dim, struct mtk_eth, tx_dim);
+	struct dim_cq_moder cur_profile;
+	u32 val, cur;
+
+	cur_profile = net_dim_get_tx_moderation(eth->tx_dim.mode,
+						dim->profile_ix);
+	spin_lock_bh(&eth->dim_lock);
+
+	val = mtk_r32(eth, MTK_PDMA_DELAY_INT);
+	val &= MTK_PDMA_DELAY_RX_MASK;
+	val |= MTK_PDMA_DELAY_TX_EN;
+
+	cur = min_t(u32, DIV_ROUND_UP(cur_profile.usec, 20), MTK_PDMA_DELAY_PTIME_MASK);
+	val |= cur << MTK_PDMA_DELAY_TX_PTIME_SHIFT;
+
+	cur = min_t(u32, cur_profile.pkts, MTK_PDMA_DELAY_PINT_MASK);
+	val |= cur << MTK_PDMA_DELAY_TX_PINT_SHIFT;
+
+	mtk_w32(eth, val, MTK_PDMA_DELAY_INT);
+	mtk_w32(eth, val, MTK_QDMA_DELAY_INT);
+
+	spin_unlock_bh(&eth->dim_lock);
+
+	dim->state = DIM_START_MEASURE;
+}
+
 static int mtk_hw_init(struct mtk_eth *eth)
 {
 	int i, val, ret;
@@ -2396,9 +2474,6 @@ static int mtk_hw_init(struct mtk_eth *eth)
 			goto err_disable_pm;
 		}
 
-		/* enable interrupt delay for RX */
-		mtk_w32(eth, MTK_PDMA_DELAY_RX_DELAY, MTK_PDMA_DELAY_INT);
-
 		/* disable delay and normal interrupt */
 		mtk_tx_irq_disable(eth, ~0);
 		mtk_rx_irq_disable(eth, ~0);
@@ -2437,11 +2512,11 @@ static int mtk_hw_init(struct mtk_eth *eth)
 	/* Enable RX VLan Offloading */
 	mtk_w32(eth, 1, MTK_CDMP_EG_CTRL);
 
-	/* enable interrupt delay for RX */
-	mtk_w32(eth, MTK_PDMA_DELAY_RX_DELAY, MTK_PDMA_DELAY_INT);
+	/* set interrupt delays based on current Net DIM sample */
+	mtk_dim_rx(&eth->rx_dim.work);
+	mtk_dim_tx(&eth->tx_dim.work);
 
 	/* disable delay and normal interrupt */
-	mtk_w32(eth, 0, MTK_QDMA_DELAY_INT);
 	mtk_tx_irq_disable(eth, ~0);
 	mtk_rx_irq_disable(eth, ~0);
 
@@ -2976,6 +3051,13 @@ static int mtk_probe(struct platform_device *pdev)
 	spin_lock_init(&eth->page_lock);
 	spin_lock_init(&eth->tx_irq_lock);
 	spin_lock_init(&eth->rx_irq_lock);
+	spin_lock_init(&eth->dim_lock);
+
+	eth->rx_dim.mode = DIM_CQ_PERIOD_MODE_START_FROM_EQE;
+	INIT_WORK(&eth->rx_dim.work, mtk_dim_rx);
+
+	eth->tx_dim.mode = DIM_CQ_PERIOD_MODE_START_FROM_EQE;
+	INIT_WORK(&eth->tx_dim.work, mtk_dim_tx);
 
 	if (!MTK_HAS_CAPS(eth->soc->caps, MTK_SOC_MT7628)) {
 		eth->ethsys = syscon_regmap_lookup_by_phandle(pdev->dev.of_node,
diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.h b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
index 4999f8123180..a8d388b02558 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.h
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
@@ -16,6 +16,7 @@
 #include <linux/refcount.h>
 #include <linux/phylink.h>
 #include <linux/rhashtable.h>
+#include <linux/dim.h>
 #include "mtk_ppe.h"
 
 #define MTK_QDMA_PAGE_SIZE	2048
@@ -137,13 +138,18 @@
 
 /* PDMA Delay Interrupt Register */
 #define MTK_PDMA_DELAY_INT		0xa0c
+#define MTK_PDMA_DELAY_RX_MASK		GENMASK(15, 0)
 #define MTK_PDMA_DELAY_RX_EN		BIT(15)
-#define MTK_PDMA_DELAY_RX_PINT		4
 #define MTK_PDMA_DELAY_RX_PINT_SHIFT	8
-#define MTK_PDMA_DELAY_RX_PTIME		4
-#define MTK_PDMA_DELAY_RX_DELAY		\
-	(MTK_PDMA_DELAY_RX_EN | MTK_PDMA_DELAY_RX_PTIME | \
-	(MTK_PDMA_DELAY_RX_PINT << MTK_PDMA_DELAY_RX_PINT_SHIFT))
+#define MTK_PDMA_DELAY_RX_PTIME_SHIFT	0
+
+#define MTK_PDMA_DELAY_TX_MASK		GENMASK(31, 16)
+#define MTK_PDMA_DELAY_TX_EN		BIT(31)
+#define MTK_PDMA_DELAY_TX_PINT_SHIFT	24
+#define MTK_PDMA_DELAY_TX_PTIME_SHIFT	16
+
+#define MTK_PDMA_DELAY_PINT_MASK	0x7f
+#define MTK_PDMA_DELAY_PTIME_MASK	0xff
 
 /* PDMA Interrupt Status Register */
 #define MTK_PDMA_INT_STATUS	0xa20
@@ -225,6 +231,7 @@
 /* QDMA Interrupt Status Register */
 #define MTK_QDMA_INT_STATUS	0x1A18
 #define MTK_RX_DONE_DLY		BIT(30)
+#define MTK_TX_DONE_DLY		BIT(28)
 #define MTK_RX_DONE_INT3	BIT(19)
 #define MTK_RX_DONE_INT2	BIT(18)
 #define MTK_RX_DONE_INT1	BIT(17)
@@ -234,8 +241,7 @@
 #define MTK_TX_DONE_INT1	BIT(1)
 #define MTK_TX_DONE_INT0	BIT(0)
 #define MTK_RX_DONE_INT		MTK_RX_DONE_DLY
-#define MTK_TX_DONE_INT		(MTK_TX_DONE_INT0 | MTK_TX_DONE_INT1 | \
-				 MTK_TX_DONE_INT2 | MTK_TX_DONE_INT3)
+#define MTK_TX_DONE_INT		MTK_TX_DONE_DLY
 
 /* QDMA Interrupt grouping registers */
 #define MTK_QDMA_INT_GRP1	0x1a20
@@ -849,6 +855,7 @@ struct mtk_sgmii {
  * @page_lock:		Make sure that register operations are atomic
  * @tx_irq__lock:	Make sure that IRQ register operations are atomic
  * @rx_irq__lock:	Make sure that IRQ register operations are atomic
+ * @dim_lock:		Make sure that Net DIM operations are atomic
  * @dummy_dev:		we run 2 netdevs on 1 physical DMA ring and need a
  *			dummy for NAPI to work
  * @netdev:		The netdev instances
@@ -867,6 +874,14 @@ struct mtk_sgmii {
  * @rx_ring_qdma:	Pointer to the memory holding info about the QDMA RX ring
  * @tx_napi:		The TX NAPI struct
  * @rx_napi:		The RX NAPI struct
+ * @rx_events:		Net DIM RX event counter
+ * @rx_packets:		Net DIM RX packet counter
+ * @rx_bytes:		Net DIM RX byte counter
+ * @rx_dim:		Net DIM RX context
+ * @tx_events:		Net DIM TX event counter
+ * @tx_packets:		Net DIM TX packet counter
+ * @tx_bytes:		Net DIM TX byte counter
+ * @tx_dim:		Net DIM TX context
  * @scratch_ring:	Newer SoCs need memory for a second HW managed TX ring
  * @phy_scratch_ring:	physical address of scratch_ring
  * @scratch_head:	The scratch memory that scratch_ring points to.
@@ -911,6 +926,18 @@ struct mtk_eth {
 
 	const struct mtk_soc_data	*soc;
 
+	spinlock_t			dim_lock;
+
+	u32				rx_events;
+	u32				rx_packets;
+	u32				rx_bytes;
+	struct dim			rx_dim;
+
+	u32				tx_events;
+	u32				tx_packets;
+	u32				tx_bytes;
+	struct dim			tx_dim;
+
 	u32				tx_int_mask_reg;
 	u32				tx_int_status_reg;
 	u32				rx_dma_l4_valid;
-- 
2.31.1

