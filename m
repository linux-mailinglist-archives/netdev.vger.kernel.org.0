Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8087521042
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 11:04:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238390AbiEJJIK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 05:08:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234681AbiEJJIJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 05:08:09 -0400
Received: from relmlie5.idc.renesas.com (relmlor1.renesas.com [210.160.252.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5E37E2AC6FB;
        Tue, 10 May 2022 02:04:12 -0700 (PDT)
X-IronPort-AV: E=Sophos;i="5.91,214,1647270000"; 
   d="scan'208";a="119233059"
Received: from unknown (HELO relmlir6.idc.renesas.com) ([10.200.68.152])
  by relmlie5.idc.renesas.com with ESMTP; 10 May 2022 18:04:12 +0900
Received: from localhost.localdomain (unknown [10.226.93.89])
        by relmlir6.idc.renesas.com (Postfix) with ESMTP id CACD74275148;
        Tue, 10 May 2022 18:04:08 +0900 (JST)
From:   Phil Edworthy <phil.edworthy@renesas.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Phil Edworthy <phil.edworthy@renesas.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        Biju Das <biju.das.jz@bp.renesas.com>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: [PATCH v3 2/5] ravb: Separate handling of irq enable/disable regs into feature
Date:   Tue, 10 May 2022 10:03:33 +0100
Message-Id: <20220510090336.14272-3-phil.edworthy@renesas.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220510090336.14272-1-phil.edworthy@renesas.com>
References: <20220510090336.14272-1-phil.edworthy@renesas.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, when the HW has a single interrupt, the driver uses the
GIC, TIC, RIC0 registers to enable and disable interrupts.
When the HW has multiple interrupts, it uses the GIE, GID, TIE, TID,
RIE0, RID0 registers.

However, other devices, e.g. RZ/V2M, have multiple irqs and only have
the GIC, TIC, RIC0 registers.
Therefore, split this into a separate feature.

Signed-off-by: Phil Edworthy <phil.edworthy@renesas.com>
Reviewed-by: Biju Das <biju.das.jz@bp.renesas.com>
---
v3:
 - Actually renamed irq_en_dis_regs to irq_en_dis this time
 - Make ravb_ptp_extts() use irq_en_dis instead of multi_irqs
v2:
 - Renamed irq_en_dis_regs to irq_en_dis
 - Squashed use of GIC reg versus GIE/GID into this patch and got rid
   of separate gptp_ptm_gic feature.
 - Minor editing of the commit msg
---
 drivers/net/ethernet/renesas/ravb.h      | 1 +
 drivers/net/ethernet/renesas/ravb_main.c | 5 +++--
 drivers/net/ethernet/renesas/ravb_ptp.c  | 6 +++---
 3 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/renesas/ravb.h b/drivers/net/ethernet/renesas/ravb.h
index 08062d73df10..bb82efd222c7 100644
--- a/drivers/net/ethernet/renesas/ravb.h
+++ b/drivers/net/ethernet/renesas/ravb.h
@@ -1027,6 +1027,7 @@ struct ravb_hw_info {
 	unsigned tx_counters:1;		/* E-MAC has TX counters */
 	unsigned carrier_counters:1;	/* E-MAC has carrier counters */
 	unsigned multi_irqs:1;		/* AVB-DMAC and E-MAC has multiple irqs */
+	unsigned irq_en_dis:1;		/* Has separate irq enable and disable regs */
 	unsigned gptp:1;		/* AVB-DMAC has gPTP support */
 	unsigned ccc_gac:1;		/* AVB-DMAC has gPTP support active in config mode */
 	unsigned nc_queues:1;		/* AVB-DMAC has RX and TX NC queues */
diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index 525d66f71f02..e22c0e6ed0f3 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -1124,7 +1124,7 @@ static bool ravb_queue_interrupt(struct net_device *ndev, int q)
 	if (((ris0 & ric0) & BIT(q)) || ((tis  & tic)  & BIT(q))) {
 		if (napi_schedule_prep(&priv->napi[q])) {
 			/* Mask RX and TX interrupts */
-			if (!info->multi_irqs) {
+			if (!info->irq_en_dis) {
 				ravb_write(ndev, ric0 & ~BIT(q), RIC0);
 				ravb_write(ndev, tic & ~BIT(q), TIC);
 			} else {
@@ -1306,7 +1306,7 @@ static int ravb_poll(struct napi_struct *napi, int budget)
 
 	/* Re-enable RX/TX interrupts */
 	spin_lock_irqsave(&priv->lock, flags);
-	if (!info->multi_irqs) {
+	if (!info->irq_en_dis) {
 		ravb_modify(ndev, RIC0, mask, mask);
 		ravb_modify(ndev, TIC,  mask, mask);
 	} else {
@@ -2410,6 +2410,7 @@ static const struct ravb_hw_info ravb_gen3_hw_info = {
 	.internal_delay = 1,
 	.tx_counters = 1,
 	.multi_irqs = 1,
+	.irq_en_dis = 1,
 	.ccc_gac = 1,
 	.nc_queues = 1,
 	.magic_pkt = 1,
diff --git a/drivers/net/ethernet/renesas/ravb_ptp.c b/drivers/net/ethernet/renesas/ravb_ptp.c
index c099656dd75b..87c4306d66ec 100644
--- a/drivers/net/ethernet/renesas/ravb_ptp.c
+++ b/drivers/net/ethernet/renesas/ravb_ptp.c
@@ -198,7 +198,7 @@ static int ravb_ptp_extts(struct ptp_clock_info *ptp,
 	priv->ptp.extts[req->index] = on;
 
 	spin_lock_irqsave(&priv->lock, flags);
-	if (!info->multi_irqs)
+	if (!info->irq_en_dis)
 		ravb_modify(ndev, GIC, GIC_PTCE, on ? GIC_PTCE : 0);
 	else if (on)
 		ravb_write(ndev, GIE_PTCS, GIE);
@@ -254,7 +254,7 @@ static int ravb_ptp_perout(struct ptp_clock_info *ptp,
 		error = ravb_ptp_update_compare(priv, (u32)start_ns);
 		if (!error) {
 			/* Unmask interrupt */
-			if (!info->multi_irqs)
+			if (!info->irq_en_dis)
 				ravb_modify(ndev, GIC, GIC_PTME, GIC_PTME);
 			else
 				ravb_write(ndev, GIE_PTMS0, GIE);
@@ -266,7 +266,7 @@ static int ravb_ptp_perout(struct ptp_clock_info *ptp,
 		perout->period = 0;
 
 		/* Mask interrupt */
-		if (!info->multi_irqs)
+		if (!info->irq_en_dis)
 			ravb_modify(ndev, GIC, GIC_PTME, 0);
 		else
 			ravb_write(ndev, GID_PTMD0, GID);
-- 
2.32.0

