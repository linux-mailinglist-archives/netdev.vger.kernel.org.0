Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EB723C8663
	for <lists+netdev@lfdr.de>; Wed, 14 Jul 2021 16:54:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239502AbhGNO5N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Jul 2021 10:57:13 -0400
Received: from relmlor1.renesas.com ([210.160.252.171]:17322 "EHLO
        relmlie5.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231797AbhGNO5L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Jul 2021 10:57:11 -0400
X-IronPort-AV: E=Sophos;i="5.84,239,1620658800"; 
   d="scan'208";a="87641423"
Received: from unknown (HELO relmlir5.idc.renesas.com) ([10.200.68.151])
  by relmlie5.idc.renesas.com with ESMTP; 14 Jul 2021 23:54:18 +0900
Received: from localhost.localdomain (unknown [10.226.92.185])
        by relmlir5.idc.renesas.com (Postfix) with ESMTP id 1966940121CD;
        Wed, 14 Jul 2021 23:54:14 +0900 (JST)
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Biju Das <biju.das.jz@bp.renesas.com>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        Adam Ford <aford173@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Andrew Gabbasov <andrew_gabbasov@mentor.com>,
        Yuusuke Ashizuka <ashiduka@fujitsu.com>,
        netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>
Subject: [PATCH/RFC 1/2] ravb: Preparation for supporting Gigabit Ethernet driver
Date:   Wed, 14 Jul 2021 15:54:07 +0100
Message-Id: <20210714145408.4382-2-biju.das.jz@bp.renesas.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210714145408.4382-1-biju.das.jz@bp.renesas.com>
References: <20210714145408.4382-1-biju.das.jz@bp.renesas.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The DMAC and EMAC blocks of Gigabit Ethernet IP is almost
similar to Ethernet AVB. With few canges in driver we can
support both the IP. This patch is in preparation for
supporting the same.

Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
---
 drivers/net/ethernet/renesas/ravb.h      |   2 +-
 drivers/net/ethernet/renesas/ravb_main.c | 183 ++++++++++++++---------
 2 files changed, 110 insertions(+), 75 deletions(-)

diff --git a/drivers/net/ethernet/renesas/ravb.h b/drivers/net/ethernet/renesas/ravb.h
index 86a1eb0634e8..80e62ca2e3d3 100644
--- a/drivers/net/ethernet/renesas/ravb.h
+++ b/drivers/net/ethernet/renesas/ravb.h
@@ -864,7 +864,7 @@ enum GECMR_BIT {
 
 /* The Ethernet AVB descriptor definitions. */
 struct ravb_desc {
-	__le16 ds;		/* Descriptor size */
+	__le16 ds;	/* Descriptor size */
 	u8 cc;		/* Content control MSBs (reserved) */
 	u8 die_dt;	/* Descriptor interrupt enable and type */
 	__le32 dptr;	/* Descriptor pointer */
diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index 4afff320dfd0..7e6feda59f4a 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -217,6 +217,29 @@ static int ravb_tx_free(struct net_device *ndev, int q, bool free_txed_only)
 }
 
 /* Free skb's and DMA buffers for Ethernet AVB */
+static void ravb_ring_free_ex(struct net_device *ndev, int q)
+{
+	struct ravb_private *priv = netdev_priv(ndev);
+	int ring_size;
+	int i;
+
+	for (i = 0; i < priv->num_rx_ring[q]; i++) {
+		struct ravb_ex_rx_desc *desc = &priv->rx_ring[q][i];
+
+		if (!dma_mapping_error(ndev->dev.parent,
+				       le32_to_cpu(desc->dptr)))
+			dma_unmap_single(ndev->dev.parent,
+					 le32_to_cpu(desc->dptr),
+					 RX_BUF_SZ,
+					 DMA_FROM_DEVICE);
+	}
+	ring_size = sizeof(struct ravb_ex_rx_desc) *
+		    (priv->num_rx_ring[q] + 1);
+	dma_free_coherent(ndev->dev.parent, ring_size, priv->rx_ring[q],
+			  priv->rx_desc_dma[q]);
+	priv->rx_ring[q] = NULL;
+}
+
 static void ravb_ring_free(struct net_device *ndev, int q)
 {
 	struct ravb_private *priv = netdev_priv(ndev);
@@ -225,21 +248,7 @@ static void ravb_ring_free(struct net_device *ndev, int q)
 	int i;
 
 	if (priv->rx_ring[q]) {
-		for (i = 0; i < priv->num_rx_ring[q]; i++) {
-			struct ravb_ex_rx_desc *desc = &priv->rx_ring[q][i];
-
-			if (!dma_mapping_error(ndev->dev.parent,
-					       le32_to_cpu(desc->dptr)))
-				dma_unmap_single(ndev->dev.parent,
-						 le32_to_cpu(desc->dptr),
-						 RX_BUF_SZ,
-						 DMA_FROM_DEVICE);
-		}
-		ring_size = sizeof(struct ravb_ex_rx_desc) *
-			    (priv->num_rx_ring[q] + 1);
-		dma_free_coherent(ndev->dev.parent, ring_size, priv->rx_ring[q],
-				  priv->rx_desc_dma[q]);
-		priv->rx_ring[q] = NULL;
+		ravb_ring_free_ex(ndev, q);
 	}
 
 	if (priv->tx_ring[q]) {
@@ -272,26 +281,15 @@ static void ravb_ring_free(struct net_device *ndev, int q)
 }
 
 /* Format skb and descriptor buffer for Ethernet AVB */
-static void ravb_ring_format(struct net_device *ndev, int q)
+static void ravb_ring_format_ex(struct net_device *ndev, int q)
 {
 	struct ravb_private *priv = netdev_priv(ndev);
-	int num_tx_desc = priv->num_tx_desc;
 	struct ravb_ex_rx_desc *rx_desc;
-	struct ravb_tx_desc *tx_desc;
-	struct ravb_desc *desc;
 	int rx_ring_size = sizeof(*rx_desc) * priv->num_rx_ring[q];
-	int tx_ring_size = sizeof(*tx_desc) * priv->num_tx_ring[q] *
-			   num_tx_desc;
 	dma_addr_t dma_addr;
 	int i;
 
-	priv->cur_rx[q] = 0;
-	priv->cur_tx[q] = 0;
-	priv->dirty_rx[q] = 0;
-	priv->dirty_tx[q] = 0;
-
 	memset(priv->rx_ring[q], 0, rx_ring_size);
-	/* Build RX ring buffer */
 	for (i = 0; i < priv->num_rx_ring[q]; i++) {
 		/* RX descriptor */
 		rx_desc = &priv->rx_ring[q][i];
@@ -310,6 +308,25 @@ static void ravb_ring_format(struct net_device *ndev, int q)
 	rx_desc = &priv->rx_ring[q][i];
 	rx_desc->dptr = cpu_to_le32((u32)priv->rx_desc_dma[q]);
 	rx_desc->die_dt = DT_LINKFIX; /* type */
+}
+
+static void ravb_ring_format(struct net_device *ndev, int q)
+{
+	struct ravb_private *priv = netdev_priv(ndev);
+	int num_tx_desc = priv->num_tx_desc;
+	struct ravb_tx_desc *tx_desc;
+	struct ravb_desc *desc;
+	int tx_ring_size = sizeof(*tx_desc) * priv->num_tx_ring[q] *
+			   num_tx_desc;
+	int i;
+
+	priv->cur_rx[q] = 0;
+	priv->cur_tx[q] = 0;
+	priv->dirty_rx[q] = 0;
+	priv->dirty_tx[q] = 0;
+
+	/* Build RX ring buffer */
+	ravb_ring_format_ex(ndev, q);
 
 	memset(priv->tx_ring[q], 0, tx_ring_size);
 	/* Build TX ring buffer */
@@ -339,6 +356,7 @@ static void ravb_ring_format(struct net_device *ndev, int q)
 static int ravb_ring_init(struct net_device *ndev, int q)
 {
 	struct ravb_private *priv = netdev_priv(ndev);
+	size_t skb_sz = RX_BUF_SZ;
 	int num_tx_desc = priv->num_tx_desc;
 	struct sk_buff *skb;
 	int ring_size;
@@ -353,7 +371,7 @@ static int ravb_ring_init(struct net_device *ndev, int q)
 		goto error;
 
 	for (i = 0; i < priv->num_rx_ring[q]; i++) {
-		skb = netdev_alloc_skb(ndev, RX_BUF_SZ + RAVB_ALIGN - 1);
+		skb = netdev_alloc_skb(ndev, skb_sz + RAVB_ALIGN - 1);
 		if (!skb)
 			goto error;
 		ravb_set_buffer_align(skb);
@@ -396,7 +414,7 @@ static int ravb_ring_init(struct net_device *ndev, int q)
 }
 
 /* E-MAC init function */
-static void ravb_emac_init(struct net_device *ndev)
+static void ravb_emac_init_ex(struct net_device *ndev)
 {
 	/* Receive frame limit set register */
 	ravb_write(ndev, ndev->mtu + ETH_HLEN + VLAN_HLEN + ETH_FCS_LEN, RFLR);
@@ -422,29 +440,15 @@ static void ravb_emac_init(struct net_device *ndev)
 	ravb_write(ndev, ECSIPR_ICDIP | ECSIPR_MPDIP | ECSIPR_LCHNGIP, ECSIPR);
 }
 
+static void ravb_emac_init(struct net_device *ndev)
+{
+	ravb_emac_init_ex(ndev);
+}
+
 /* Device init function for Ethernet AVB */
-static int ravb_dmac_init(struct net_device *ndev)
+static void ravb_dmac_init_ex(struct net_device *ndev)
 {
 	struct ravb_private *priv = netdev_priv(ndev);
-	int error;
-
-	/* Set CONFIG mode */
-	error = ravb_config(ndev);
-	if (error)
-		return error;
-
-	error = ravb_ring_init(ndev, RAVB_BE);
-	if (error)
-		return error;
-	error = ravb_ring_init(ndev, RAVB_NC);
-	if (error) {
-		ravb_ring_free(ndev, RAVB_BE);
-		return error;
-	}
-
-	/* Descriptor format */
-	ravb_ring_format(ndev, RAVB_BE);
-	ravb_ring_format(ndev, RAVB_NC);
 
 	/* Set AVB RX */
 	ravb_write(ndev,
@@ -471,6 +475,31 @@ static int ravb_dmac_init(struct net_device *ndev)
 	ravb_write(ndev, RIC2_QFE0 | RIC2_QFE1 | RIC2_RFFE, RIC2);
 	/* Frame transmitted, timestamp FIFO updated */
 	ravb_write(ndev, TIC_FTE0 | TIC_FTE1 | TIC_TFUE, TIC);
+}
+
+static int ravb_dmac_init(struct net_device *ndev)
+{
+	int error;
+
+	/* Set CONFIG mode */
+	error = ravb_config(ndev);
+	if (error)
+		return error;
+
+	error = ravb_ring_init(ndev, RAVB_BE);
+	if (error)
+		return error;
+	error = ravb_ring_init(ndev, RAVB_NC);
+	if (error) {
+		ravb_ring_free(ndev, RAVB_BE);
+		return error;
+	}
+
+	/* Descriptor format */
+	ravb_ring_format(ndev, RAVB_BE);
+	ravb_ring_format(ndev, RAVB_NC);
+
+	ravb_dmac_init_ex(ndev);
 
 	/* Setting the control will start the AVB-DMAC process. */
 	ravb_modify(ndev, CCC, CCC_OPC, CCC_OPC_OPERATION);
@@ -532,7 +561,7 @@ static void ravb_rx_csum(struct sk_buff *skb)
 }
 
 /* Packet receive function for Ethernet AVB */
-static bool ravb_rx(struct net_device *ndev, int *quota, int q)
+static bool ravb_rx_ex(struct net_device *ndev, int *quota, int q)
 {
 	struct ravb_private *priv = netdev_priv(ndev);
 	int entry = priv->cur_rx[q] % priv->num_rx_ring[q];
@@ -647,6 +676,11 @@ static bool ravb_rx(struct net_device *ndev, int *quota, int q)
 	return boguscnt <= 0;
 }
 
+static bool ravb_rx(struct net_device *ndev, int *quota, int q)
+{
+	return ravb_rx_ex(ndev, quota, q);
+}
+
 static void ravb_rcv_snd_disable(struct net_device *ndev)
 {
 	/* Disable TX and RX */
@@ -766,7 +800,7 @@ static bool ravb_queue_interrupt(struct net_device *ndev, int q)
 	if (((ris0 & ric0) & BIT(q)) || ((tis  & tic)  & BIT(q))) {
 		if (napi_schedule_prep(&priv->napi[q])) {
 			/* Mask RX and TX interrupts */
-			if (priv->chip_id == RCAR_GEN2) {
+			if (priv->chip_id != RCAR_GEN3) {
 				ravb_write(ndev, ric0 & ~BIT(q), RIC0);
 				ravb_write(ndev, tic & ~BIT(q), TIC);
 			} else {
@@ -920,7 +954,7 @@ static int ravb_poll(struct napi_struct *napi, int budget)
 	if (ravb_rx(ndev, &quota, q))
 		goto out;
 
-	/* Processing RX Descriptor Ring */
+	/* Processing TX Descriptor Ring */
 	spin_lock_irqsave(&priv->lock, flags);
 	/* Clear TX interrupt */
 	ravb_write(ndev, ~(mask | TIS_RESERVED), TIS);
@@ -932,7 +966,7 @@ static int ravb_poll(struct napi_struct *napi, int budget)
 
 	/* Re-enable RX/TX interrupts */
 	spin_lock_irqsave(&priv->lock, flags);
-	if (priv->chip_id == RCAR_GEN2) {
+	if (priv->chip_id != RCAR_GEN3) {
 		ravb_modify(ndev, RIC0, mask, mask);
 		ravb_modify(ndev, TIC,  mask, mask);
 	} else {
@@ -1149,11 +1183,12 @@ static void ravb_get_ethtool_stats(struct net_device *ndev,
 				   struct ethtool_stats *estats, u64 *data)
 {
 	struct ravb_private *priv = netdev_priv(ndev);
+	int num_queue = NUM_RX_QUEUE;
 	int i = 0;
 	int q;
 
 	/* Device-specific stats */
-	for (q = RAVB_BE; q < NUM_RX_QUEUE; q++) {
+	for (q = RAVB_BE; q < num_queue; q++) {
 		struct net_device_stats *stats = &priv->stats[q];
 
 		data[i++] = priv->cur_rx[q];
@@ -1341,7 +1376,7 @@ static int ravb_open(struct net_device *ndev)
 	napi_enable(&priv->napi[RAVB_BE]);
 	napi_enable(&priv->napi[RAVB_NC]);
 
-	if (priv->chip_id == RCAR_GEN2) {
+	if (priv->chip_id != RCAR_GEN3) {
 		error = request_irq(ndev->irq, ravb_interrupt, IRQF_SHARED,
 				    ndev->name, ndev);
 		if (error) {
@@ -1708,7 +1743,7 @@ static int ravb_close(struct net_device *ndev)
 			of_phy_deregister_fixed_link(np);
 	}
 
-	if (priv->chip_id != RCAR_GEN2) {
+	if (priv->chip_id == RCAR_GEN3) {
 		free_irq(priv->tx_irqs[RAVB_NC], ndev);
 		free_irq(priv->rx_irqs[RAVB_NC], ndev);
 		free_irq(priv->tx_irqs[RAVB_BE], ndev);
@@ -1963,7 +1998,7 @@ static void ravb_set_config_mode(struct net_device *ndev)
 {
 	struct ravb_private *priv = netdev_priv(ndev);
 
-	if (priv->chip_id == RCAR_GEN2) {
+	if (priv->chip_id != RCAR_GEN3) {
 		ravb_modify(ndev, CCC, CCC_OPC, CCC_OPC_CONFIG);
 		/* Set CSEL value */
 		ravb_modify(ndev, CCC, CCC_CSEL, CCC_CSEL_HPB);
@@ -2059,17 +2094,22 @@ static int ravb_probe(struct platform_device *pdev)
 	if (!ndev)
 		return -ENOMEM;
 
+	/* The Ether-specific entries in the device structure. */
+	ndev->base_addr = res->start;
+
+	chip_id = (enum ravb_chip_id)of_device_get_match_data(&pdev->dev);
+
+	SET_NETDEV_DEV(ndev, &pdev->dev);
+
+	priv = netdev_priv(ndev);
+	priv->chip_id = chip_id;
+
 	ndev->features = NETIF_F_RXCSUM;
 	ndev->hw_features = NETIF_F_RXCSUM;
 
 	pm_runtime_enable(&pdev->dev);
 	pm_runtime_get_sync(&pdev->dev);
 
-	/* The Ether-specific entries in the device structure. */
-	ndev->base_addr = res->start;
-
-	chip_id = (enum ravb_chip_id)of_device_get_match_data(&pdev->dev);
-
 	if (chip_id == RCAR_GEN3)
 		irq = platform_get_irq_byname(pdev, "ch22");
 	else
@@ -2080,9 +2120,6 @@ static int ravb_probe(struct platform_device *pdev)
 	}
 	ndev->irq = irq;
 
-	SET_NETDEV_DEV(ndev, &pdev->dev);
-
-	priv = netdev_priv(ndev);
 	priv->ndev = ndev;
 	priv->pdev = pdev;
 	priv->num_tx_ring[RAVB_BE] = BE_TX_RING_SIZE;
@@ -2131,8 +2168,6 @@ static int ravb_probe(struct platform_device *pdev)
 		}
 	}
 
-	priv->chip_id = chip_id;
-
 	priv->clk = devm_clk_get(&pdev->dev, NULL);
 	if (IS_ERR(priv->clk)) {
 		error = PTR_ERR(priv->clk);
@@ -2149,8 +2184,8 @@ static int ravb_probe(struct platform_device *pdev)
 	ndev->max_mtu = 2048 - (ETH_HLEN + VLAN_HLEN + ETH_FCS_LEN);
 	ndev->min_mtu = ETH_MIN_MTU;
 
-	priv->num_tx_desc = chip_id == RCAR_GEN2 ?
-		NUM_TX_DESC_GEN2 : NUM_TX_DESC_GEN3;
+	priv->num_tx_desc = chip_id == RCAR_GEN3 ?
+		NUM_TX_DESC_GEN3 : NUM_TX_DESC_GEN2;
 
 	/* Set function */
 	ndev->netdev_ops = &ravb_netdev_ops;
@@ -2167,7 +2202,7 @@ static int ravb_probe(struct platform_device *pdev)
 	/* Request GTI loading */
 	ravb_modify(ndev, GCCR, GCCR_LTI, GCCR_LTI);
 
-	if (priv->chip_id != RCAR_GEN2) {
+	if (priv->chip_id == RCAR_GEN3) {
 		ravb_parse_delay_mode(np, ndev);
 		ravb_set_delay_mode(ndev);
 	}
@@ -2191,7 +2226,7 @@ static int ravb_probe(struct platform_device *pdev)
 	INIT_LIST_HEAD(&priv->ts_skb_list);
 
 	/* Initialise PTP Clock driver */
-	if (chip_id != RCAR_GEN2)
+	if (chip_id == RCAR_GEN3)
 		ravb_ptp_init(ndev, pdev);
 
 	/* Debug message level */
@@ -2239,7 +2274,7 @@ static int ravb_probe(struct platform_device *pdev)
 			  priv->desc_bat_dma);
 
 	/* Stop PTP Clock driver */
-	if (chip_id != RCAR_GEN2)
+	if (chip_id == RCAR_GEN3)
 		ravb_ptp_stop(ndev);
 out_disable_refclk:
 	clk_disable_unprepare(priv->refclk);
@@ -2257,7 +2292,7 @@ static int ravb_remove(struct platform_device *pdev)
 	struct ravb_private *priv = netdev_priv(ndev);
 
 	/* Stop PTP Clock driver */
-	if (priv->chip_id != RCAR_GEN2)
+	if (priv->chip_id == RCAR_GEN3)
 		ravb_ptp_stop(ndev);
 
 	clk_disable_unprepare(priv->refclk);
@@ -2362,7 +2397,7 @@ static int __maybe_unused ravb_resume(struct device *dev)
 	/* Request GTI loading */
 	ravb_modify(ndev, GCCR, GCCR_LTI, GCCR_LTI);
 
-	if (priv->chip_id != RCAR_GEN2)
+	if (priv->chip_id == RCAR_GEN3)
 		ravb_set_delay_mode(ndev);
 
 	/* Restore descriptor base address table */
-- 
2.17.1

