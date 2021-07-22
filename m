Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03CAB3D255F
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 16:15:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232408AbhGVNeR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 09:34:17 -0400
Received: from relmlor1.renesas.com ([210.160.252.171]:11822 "EHLO
        relmlie5.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S232274AbhGVNdv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Jul 2021 09:33:51 -0400
X-IronPort-AV: E=Sophos;i="5.84,261,1620658800"; 
   d="scan'208";a="88463946"
Received: from unknown (HELO relmlir5.idc.renesas.com) ([10.200.68.151])
  by relmlie5.idc.renesas.com with ESMTP; 22 Jul 2021 23:14:22 +0900
Received: from localhost.localdomain (unknown [10.226.92.164])
        by relmlir5.idc.renesas.com (Postfix) with ESMTP id 1FFBC401224A;
        Thu, 22 Jul 2021 23:14:18 +0900 (JST)
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Biju Das <biju.das.jz@bp.renesas.com>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        Adam Ford <aford173@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Yuusuke Ashizuka <ashiduka@fujitsu.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>
Subject: [PATCH net-next 07/18] ravb: Add features specific to R-Car Gen3
Date:   Thu, 22 Jul 2021 15:13:40 +0100
Message-Id: <20210722141351.13668-8-biju.das.jz@bp.renesas.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210722141351.13668-1-biju.das.jz@bp.renesas.com>
References: <20210722141351.13668-1-biju.das.jz@bp.renesas.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Multiple irqs, internal delay and tx drop counter is present only
in R-Car Gen3. Add feature bits to support the same.

Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Reviewed-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
---
 drivers/net/ethernet/renesas/ravb_main.c | 36 ++++++++++++++++--------
 1 file changed, 24 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index e966b76df32c..b3c99f974632 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -42,10 +42,18 @@
 
 #define RAVB_PTP_CONFIG_ACTIVE		BIT(0)
 #define RAVB_PTP_CONFIG_INACTIVE	BIT(1)
+#define RAVB_MULTI_IRQS			BIT(2)
+#define RAVB_INTERNAL_DELAY		BIT(3)
+#define RAVB_TX_DROP_COUNTER		BIT(4)
 
 #define RAVB_PTP	(RAVB_PTP_CONFIG_ACTIVE | RAVB_PTP_CONFIG_INACTIVE)
 
-#define RAVB_RCAR_GEN3_FEATURES	RAVB_PTP_CONFIG_ACTIVE
+#define RAVB_RCAR_GEN3_FEATURES \
+		(RAVB_PTP_CONFIG_ACTIVE		| \
+		 RAVB_MULTI_IRQS		| \
+		 RAVB_INTERNAL_DELAY		| \
+		 RAVB_TX_DROP_COUNTER)
+
 #define RAVB_RCAR_GEN2_FEATURES	RAVB_PTP_CONFIG_INACTIVE
 
 static const char *ravb_rx_irqs[NUM_RX_QUEUE] = {
@@ -435,6 +443,7 @@ static void ravb_emac_init(struct net_device *ndev)
 static int ravb_dmac_init(struct net_device *ndev)
 {
 	struct ravb_private *priv = netdev_priv(ndev);
+	const struct ravb_drv_data *info = priv->info;
 	int error;
 
 	/* Set CONFIG mode */
@@ -466,7 +475,7 @@ static int ravb_dmac_init(struct net_device *ndev)
 	ravb_write(ndev, TCCR_TFEN, TCCR);
 
 	/* Interrupt init: */
-	if (priv->chip_id == RCAR_GEN3) {
+	if (info->features & RAVB_MULTI_IRQS) {
 		/* Clear DIL.DPLx */
 		ravb_write(ndev, 0, DIL);
 		/* Set queue specific interrupt */
@@ -767,6 +776,7 @@ static void ravb_error_interrupt(struct net_device *ndev)
 static bool ravb_queue_interrupt(struct net_device *ndev, int q)
 {
 	struct ravb_private *priv = netdev_priv(ndev);
+	const struct ravb_drv_data *info = priv->info;
 	u32 ris0 = ravb_read(ndev, RIS0);
 	u32 ric0 = ravb_read(ndev, RIC0);
 	u32 tis  = ravb_read(ndev, TIS);
@@ -775,7 +785,7 @@ static bool ravb_queue_interrupt(struct net_device *ndev, int q)
 	if (((ris0 & ric0) & BIT(q)) || ((tis  & tic)  & BIT(q))) {
 		if (napi_schedule_prep(&priv->napi[q])) {
 			/* Mask RX and TX interrupts */
-			if (priv->chip_id == RCAR_GEN2) {
+			if (!(info->features & RAVB_MULTI_IRQS)) {
 				ravb_write(ndev, ric0 & ~BIT(q), RIC0);
 				ravb_write(ndev, tic & ~BIT(q), TIC);
 			} else {
@@ -919,6 +929,7 @@ static int ravb_poll(struct napi_struct *napi, int budget)
 {
 	struct net_device *ndev = napi->dev;
 	struct ravb_private *priv = netdev_priv(ndev);
+	const struct ravb_drv_data *info = priv->info;
 	unsigned long flags;
 	int q = napi - priv->napi;
 	int mask = BIT(q);
@@ -942,7 +953,7 @@ static int ravb_poll(struct napi_struct *napi, int budget)
 
 	/* Re-enable RX/TX interrupts */
 	spin_lock_irqsave(&priv->lock, flags);
-	if (priv->chip_id == RCAR_GEN2) {
+	if (!(info->features & RAVB_MULTI_IRQS)) {
 		ravb_modify(ndev, RIC0, mask, mask);
 		ravb_modify(ndev, TIC,  mask, mask);
 	} else {
@@ -1360,7 +1371,7 @@ static int ravb_open(struct net_device *ndev)
 	napi_enable(&priv->napi[RAVB_BE]);
 	napi_enable(&priv->napi[RAVB_NC]);
 
-	if (priv->chip_id == RCAR_GEN2) {
+	if (!(info->features & RAVB_MULTI_IRQS)) {
 		error = request_irq(ndev->irq, ravb_interrupt, IRQF_SHARED,
 				    ndev->name, ndev);
 		if (error) {
@@ -1418,7 +1429,7 @@ static int ravb_open(struct net_device *ndev)
 	if (info->features & RAVB_PTP_CONFIG_INACTIVE)
 		ravb_ptp_stop(ndev);
 out_free_irq_nc_tx:
-	if (priv->chip_id == RCAR_GEN2)
+	if (!(info->features & RAVB_MULTI_IRQS))
 		goto out_free_irq;
 	free_irq(priv->tx_irqs[RAVB_NC], ndev);
 out_free_irq_nc_rx:
@@ -1648,13 +1659,14 @@ static u16 ravb_select_queue(struct net_device *ndev, struct sk_buff *skb,
 static struct net_device_stats *ravb_get_stats(struct net_device *ndev)
 {
 	struct ravb_private *priv = netdev_priv(ndev);
+	const struct ravb_drv_data *info = priv->info;
 	struct net_device_stats *nstats, *stats0, *stats1;
 
 	nstats = &ndev->stats;
 	stats0 = &priv->stats[RAVB_BE];
 	stats1 = &priv->stats[RAVB_NC];
 
-	if (priv->chip_id == RCAR_GEN3) {
+	if (info->features & RAVB_TX_DROP_COUNTER) {
 		nstats->tx_dropped += ravb_read(ndev, TROCR);
 		ravb_write(ndev, 0, TROCR);	/* (write clear) */
 	}
@@ -1729,7 +1741,7 @@ static int ravb_close(struct net_device *ndev)
 			of_phy_deregister_fixed_link(np);
 	}
 
-	if (priv->chip_id != RCAR_GEN2) {
+	if (info->features & RAVB_MULTI_IRQS) {
 		free_irq(priv->tx_irqs[RAVB_NC], ndev);
 		free_irq(priv->rx_irqs[RAVB_NC], ndev);
 		free_irq(priv->tx_irqs[RAVB_BE], ndev);
@@ -2113,7 +2125,7 @@ static int ravb_probe(struct platform_device *pdev)
 	pm_runtime_enable(&pdev->dev);
 	pm_runtime_get_sync(&pdev->dev);
 
-	if (info->chip_id == RCAR_GEN3)
+	if (info->features & RAVB_MULTI_IRQS)
 		irq = platform_get_irq_byname(pdev, "ch22");
 	else
 		irq = platform_get_irq(pdev, 0);
@@ -2153,7 +2165,7 @@ static int ravb_probe(struct platform_device *pdev)
 	priv->avb_link_active_low =
 		of_property_read_bool(np, "renesas,ether-link-active-low");
 
-	if (info->chip_id == RCAR_GEN3) {
+	if (info->features & RAVB_MULTI_IRQS) {
 		irq = platform_get_irq_byname(pdev, "ch24");
 		if (irq < 0) {
 			error = irq;
@@ -2215,7 +2227,7 @@ static int ravb_probe(struct platform_device *pdev)
 		ravb_modify(ndev, GCCR, GCCR_LTI, GCCR_LTI);
 	}
 
-	if (priv->chip_id != RCAR_GEN2) {
+	if (info->features & RAVB_INTERNAL_DELAY) {
 		ravb_parse_delay_mode(np, ndev);
 		ravb_set_delay_mode(ndev);
 	}
@@ -2414,7 +2426,7 @@ static int __maybe_unused ravb_resume(struct device *dev)
 		ravb_modify(ndev, GCCR, GCCR_LTI, GCCR_LTI);
 	}
 
-	if (priv->chip_id != RCAR_GEN2)
+	if (info->features & RAVB_INTERNAL_DELAY)
 		ravb_set_delay_mode(ndev);
 
 	/* Restore descriptor base address table */
-- 
2.17.1

