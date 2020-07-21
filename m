Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B733C2278D4
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 08:24:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728005AbgGUGYF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 02:24:05 -0400
Received: from relmlor1.renesas.com ([210.160.252.171]:46216 "EHLO
        relmlie5.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726039AbgGUGYF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 02:24:05 -0400
X-IronPort-AV: E=Sophos;i="5.75,377,1589209200"; 
   d="scan'208";a="52678294"
Received: from unknown (HELO relmlir6.idc.renesas.com) ([10.200.68.152])
  by relmlie5.idc.renesas.com with ESMTP; 21 Jul 2020 15:24:03 +0900
Received: from localhost.localdomain (unknown [10.166.252.89])
        by relmlir6.idc.renesas.com (Postfix) with ESMTP id E133341E1BED;
        Tue, 21 Jul 2020 15:24:03 +0900 (JST)
From:   Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
To:     sergei.shtylyov@gmail.com, davem@davemloft.net, kuba@kernel.org
Cc:     dirk.behme@de.bosch.com, Shashikant.Suguni@in.bosch.com,
        netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Subject: [PATCH v3] net: ethernet: ravb: exit if re-initialization fails in tx timeout
Date:   Tue, 21 Jul 2020 15:23:12 +0900
Message-Id: <1595312592-28666-1-git-send-email-yoshihiro.shimoda.uh@renesas.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

According to the report of [1], this driver is possible to cause
the following error in ravb_tx_timeout_work().

ravb e6800000.ethernet ethernet: failed to switch device to config mode

This error means that the hardware could not change the state
from "Operation" to "Configuration" while some tx and/or rx queue
are operating. After that, ravb_config() in ravb_dmac_init() will fail,
and then any descriptors will be not allocaled anymore so that NULL
pointer dereference happens after that on ravb_start_xmit().

To fix the issue, the ravb_tx_timeout_work() should check
the return values of ravb_stop_dma() and ravb_dmac_init().
If ravb_stop_dma() fails, ravb_tx_timeout_work() re-enables TX and RX
and just exits. If ravb_dmac_init() fails, just exits.

[1]
https://lore.kernel.org/linux-renesas-soc/20200518045452.2390-1-dirk.behme@de.bosch.com/

Reported-by: Dirk Behme <dirk.behme@de.bosch.com>
Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Reviewed-by: Sergei Shtylyov <sergei.shtylyov@gmail.com>
---
 Changes from RFC v2:
 - Check the return value of ravb_init_dmac() too.
 - Update the subject and description.
 - Fix the comment in the code.
 - Add Reviewed-by Sergei.
 https://patchwork.kernel.org/patch/11673621/

 Changes from RFC v1:
 - Check the return value of ravb_stop_dma() and exit if the hardware
   condition can not be initialized in the tx timeout.
 - Update the commit subject and description.
 - Fix some typo.
 https://patchwork.kernel.org/patch/11570217/

 Unfortunately, I still didn't reproduce the issue yet. But,
 I got review from Sergei in v2. So, I removed RFC on this patch.

 drivers/net/ethernet/renesas/ravb_main.c | 26 ++++++++++++++++++++++++--
 1 file changed, 24 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index a442bcf6..99f7aae 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -1450,6 +1450,7 @@ static void ravb_tx_timeout_work(struct work_struct *work)
 	struct ravb_private *priv = container_of(work, struct ravb_private,
 						 work);
 	struct net_device *ndev = priv->ndev;
+	int error;
 
 	netif_tx_stop_all_queues(ndev);
 
@@ -1458,15 +1459,36 @@ static void ravb_tx_timeout_work(struct work_struct *work)
 		ravb_ptp_stop(ndev);
 
 	/* Wait for DMA stopping */
-	ravb_stop_dma(ndev);
+	if (ravb_stop_dma(ndev)) {
+		/* If ravb_stop_dma() fails, the hardware is still operating
+		 * for TX and/or RX. So, this should not call the following
+		 * functions because ravb_dmac_init() is possible to fail too.
+		 * Also, this should not retry ravb_stop_dma() again and again
+		 * here because it's possible to wait forever. So, this just
+		 * re-enables the TX and RX and skip the following
+		 * re-initialization procedure.
+		 */
+		ravb_rcv_snd_enable(ndev);
+		goto out;
+	}
 
 	ravb_ring_free(ndev, RAVB_BE);
 	ravb_ring_free(ndev, RAVB_NC);
 
 	/* Device init */
-	ravb_dmac_init(ndev);
+	error = ravb_dmac_init(ndev);
+	if (error) {
+		/* If ravb_dmac_init() fails, descriptors are freed. So, this
+		 * should return here to avoid re-enabling the TX and RX in
+		 * ravb_emac_init().
+		 */
+		netdev_err(ndev, "%s: ravb_dmac_init() failed, error %d\n",
+			   __func__, error);
+		return;
+	}
 	ravb_emac_init(ndev);
 
+out:
 	/* Initialise PTP Clock driver */
 	if (priv->chip_id == RCAR_GEN2)
 		ravb_ptp_init(ndev, priv->pdev);
-- 
2.7.4

