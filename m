Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3F873F7000
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 09:02:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239219AbhHYHDO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 03:03:14 -0400
Received: from relmlor2.renesas.com ([210.160.252.172]:5816 "EHLO
        relmlie6.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S238536AbhHYHCy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 03:02:54 -0400
X-IronPort-AV: E=Sophos;i="5.84,349,1620658800"; 
   d="scan'208";a="91716440"
Received: from unknown (HELO relmlir6.idc.renesas.com) ([10.200.68.152])
  by relmlie6.idc.renesas.com with ESMTP; 25 Aug 2021 16:02:08 +0900
Received: from localhost.localdomain (unknown [10.226.92.232])
        by relmlir6.idc.renesas.com (Postfix) with ESMTP id CF1B34202725;
        Wed, 25 Aug 2021 16:02:04 +0900 (JST)
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Biju Das <biju.das.jz@bp.renesas.com>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Adam Ford <aford173@gmail.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>
Subject: [PATCH net-next 02/13] ravb: Add multi_irq to struct ravb_hw_info
Date:   Wed, 25 Aug 2021 08:01:43 +0100
Message-Id: <20210825070154.14336-3-biju.das.jz@bp.renesas.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210825070154.14336-1-biju.das.jz@bp.renesas.com>
References: <20210825070154.14336-1-biju.das.jz@bp.renesas.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

R-Car Gen3 supports separate interrupts for E-MAC and DMA queues,
whereas R-Car Gen2 and RZ/G2L have a single interrupt instead.

Add a multi_irq hw feature bit to struct ravb_hw_info to enable
this only for R-Car Gen3.

Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Reviewed-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
---
 drivers/net/ethernet/renesas/ravb.h      |  1 +
 drivers/net/ethernet/renesas/ravb_main.c | 22 ++++++++++++++--------
 drivers/net/ethernet/renesas/ravb_ptp.c  |  8 +++++---
 3 files changed, 20 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/renesas/ravb.h b/drivers/net/ethernet/renesas/ravb.h
index 84700a82a41c..da486e06b322 100644
--- a/drivers/net/ethernet/renesas/ravb.h
+++ b/drivers/net/ethernet/renesas/ravb.h
@@ -997,6 +997,7 @@ struct ravb_hw_info {
 	/* hardware features */
 	unsigned internal_delay:1;	/* AVB-DMAC has internal delays */
 	unsigned tx_counters:1;		/* E-MAC has TX counters */
+	unsigned multi_irqs:1;		/* AVB-DMAC and E-MAC has multiple irqs */
 };
 
 struct ravb_private {
diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index 073e690ab830..28b8dcae57a8 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -427,6 +427,7 @@ static void ravb_emac_init(struct net_device *ndev)
 static int ravb_dmac_init(struct net_device *ndev)
 {
 	struct ravb_private *priv = netdev_priv(ndev);
+	const struct ravb_hw_info *info = priv->info;
 	int error;
 
 	/* Set CONFIG mode */
@@ -458,7 +459,7 @@ static int ravb_dmac_init(struct net_device *ndev)
 	ravb_write(ndev, TCCR_TFEN, TCCR);
 
 	/* Interrupt init: */
-	if (priv->chip_id == RCAR_GEN3) {
+	if (info->multi_irqs) {
 		/* Clear DIL.DPLx */
 		ravb_write(ndev, 0, DIL);
 		/* Set queue specific interrupt */
@@ -758,6 +759,7 @@ static void ravb_error_interrupt(struct net_device *ndev)
 static bool ravb_queue_interrupt(struct net_device *ndev, int q)
 {
 	struct ravb_private *priv = netdev_priv(ndev);
+	const struct ravb_hw_info *info = priv->info;
 	u32 ris0 = ravb_read(ndev, RIS0);
 	u32 ric0 = ravb_read(ndev, RIC0);
 	u32 tis  = ravb_read(ndev, TIS);
@@ -766,7 +768,7 @@ static bool ravb_queue_interrupt(struct net_device *ndev, int q)
 	if (((ris0 & ric0) & BIT(q)) || ((tis  & tic)  & BIT(q))) {
 		if (napi_schedule_prep(&priv->napi[q])) {
 			/* Mask RX and TX interrupts */
-			if (priv->chip_id == RCAR_GEN2) {
+			if (!info->multi_irqs) {
 				ravb_write(ndev, ric0 & ~BIT(q), RIC0);
 				ravb_write(ndev, tic & ~BIT(q), TIC);
 			} else {
@@ -909,6 +911,7 @@ static int ravb_poll(struct napi_struct *napi, int budget)
 {
 	struct net_device *ndev = napi->dev;
 	struct ravb_private *priv = netdev_priv(ndev);
+	const struct ravb_hw_info *info = priv->info;
 	unsigned long flags;
 	int q = napi - priv->napi;
 	int mask = BIT(q);
@@ -932,7 +935,7 @@ static int ravb_poll(struct napi_struct *napi, int budget)
 
 	/* Re-enable RX/TX interrupts */
 	spin_lock_irqsave(&priv->lock, flags);
-	if (priv->chip_id == RCAR_GEN2) {
+	if (!info->multi_irqs) {
 		ravb_modify(ndev, RIC0, mask, mask);
 		ravb_modify(ndev, TIC,  mask, mask);
 	} else {
@@ -1338,6 +1341,7 @@ static inline int ravb_hook_irq(unsigned int irq, irq_handler_t handler,
 static int ravb_open(struct net_device *ndev)
 {
 	struct ravb_private *priv = netdev_priv(ndev);
+	const struct ravb_hw_info *info = priv->info;
 	struct platform_device *pdev = priv->pdev;
 	struct device *dev = &pdev->dev;
 	int error;
@@ -1345,7 +1349,7 @@ static int ravb_open(struct net_device *ndev)
 	napi_enable(&priv->napi[RAVB_BE]);
 	napi_enable(&priv->napi[RAVB_NC]);
 
-	if (priv->chip_id == RCAR_GEN2) {
+	if (!info->multi_irqs) {
 		error = request_irq(ndev->irq, ravb_interrupt, IRQF_SHARED,
 				    ndev->name, ndev);
 		if (error) {
@@ -1403,7 +1407,7 @@ static int ravb_open(struct net_device *ndev)
 	if (priv->chip_id == RCAR_GEN2)
 		ravb_ptp_stop(ndev);
 out_free_irq_nc_tx:
-	if (priv->chip_id == RCAR_GEN2)
+	if (!info->multi_irqs)
 		goto out_free_irq;
 	free_irq(priv->tx_irqs[RAVB_NC], ndev);
 out_free_irq_nc_rx:
@@ -1680,6 +1684,7 @@ static int ravb_close(struct net_device *ndev)
 {
 	struct device_node *np = ndev->dev.parent->of_node;
 	struct ravb_private *priv = netdev_priv(ndev);
+	const struct ravb_hw_info *info = priv->info;
 	struct ravb_tstamp_skb *ts_skb, *ts_skb2;
 
 	netif_tx_stop_all_queues(ndev);
@@ -1713,7 +1718,7 @@ static int ravb_close(struct net_device *ndev)
 			of_phy_deregister_fixed_link(np);
 	}
 
-	if (priv->chip_id != RCAR_GEN2) {
+	if (info->multi_irqs) {
 		free_irq(priv->tx_irqs[RAVB_NC], ndev);
 		free_irq(priv->rx_irqs[RAVB_NC], ndev);
 		free_irq(priv->tx_irqs[RAVB_BE], ndev);
@@ -1939,6 +1944,7 @@ static const struct ravb_hw_info ravb_gen3_hw_info = {
 	.max_rx_len = RX_BUF_SZ + RAVB_ALIGN - 1,
 	.internal_delay = 1,
 	.tx_counters = 1,
+	.multi_irqs = 1,
 };
 
 static const struct ravb_hw_info ravb_gen2_hw_info = {
@@ -2077,7 +2083,7 @@ static int ravb_probe(struct platform_device *pdev)
 	pm_runtime_enable(&pdev->dev);
 	pm_runtime_get_sync(&pdev->dev);
 
-	if (info->chip_id == RCAR_GEN3)
+	if (info->multi_irqs)
 		irq = platform_get_irq_byname(pdev, "ch22");
 	else
 		irq = platform_get_irq(pdev, 0);
@@ -2117,7 +2123,7 @@ static int ravb_probe(struct platform_device *pdev)
 	priv->avb_link_active_low =
 		of_property_read_bool(np, "renesas,ether-link-active-low");
 
-	if (info->chip_id == RCAR_GEN3) {
+	if (info->multi_irqs) {
 		irq = platform_get_irq_byname(pdev, "ch24");
 		if (irq < 0) {
 			error = irq;
diff --git a/drivers/net/ethernet/renesas/ravb_ptp.c b/drivers/net/ethernet/renesas/ravb_ptp.c
index 6984bd5b7da9..c099656dd75b 100644
--- a/drivers/net/ethernet/renesas/ravb_ptp.c
+++ b/drivers/net/ethernet/renesas/ravb_ptp.c
@@ -179,6 +179,7 @@ static int ravb_ptp_extts(struct ptp_clock_info *ptp,
 {
 	struct ravb_private *priv = container_of(ptp, struct ravb_private,
 						 ptp.info);
+	const struct ravb_hw_info *info = priv->info;
 	struct net_device *ndev = priv->ndev;
 	unsigned long flags;
 
@@ -197,7 +198,7 @@ static int ravb_ptp_extts(struct ptp_clock_info *ptp,
 	priv->ptp.extts[req->index] = on;
 
 	spin_lock_irqsave(&priv->lock, flags);
-	if (priv->chip_id == RCAR_GEN2)
+	if (!info->multi_irqs)
 		ravb_modify(ndev, GIC, GIC_PTCE, on ? GIC_PTCE : 0);
 	else if (on)
 		ravb_write(ndev, GIE_PTCS, GIE);
@@ -213,6 +214,7 @@ static int ravb_ptp_perout(struct ptp_clock_info *ptp,
 {
 	struct ravb_private *priv = container_of(ptp, struct ravb_private,
 						 ptp.info);
+	const struct ravb_hw_info *info = priv->info;
 	struct net_device *ndev = priv->ndev;
 	struct ravb_ptp_perout *perout;
 	unsigned long flags;
@@ -252,7 +254,7 @@ static int ravb_ptp_perout(struct ptp_clock_info *ptp,
 		error = ravb_ptp_update_compare(priv, (u32)start_ns);
 		if (!error) {
 			/* Unmask interrupt */
-			if (priv->chip_id == RCAR_GEN2)
+			if (!info->multi_irqs)
 				ravb_modify(ndev, GIC, GIC_PTME, GIC_PTME);
 			else
 				ravb_write(ndev, GIE_PTMS0, GIE);
@@ -264,7 +266,7 @@ static int ravb_ptp_perout(struct ptp_clock_info *ptp,
 		perout->period = 0;
 
 		/* Mask interrupt */
-		if (priv->chip_id == RCAR_GEN2)
+		if (!info->multi_irqs)
 			ravb_modify(ndev, GIC, GIC_PTME, 0);
 		else
 			ravb_write(ndev, GID_PTMD0, GID);
-- 
2.17.1

