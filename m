Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CA42225E01
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 13:59:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728683AbgGTL7j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 07:59:39 -0400
Received: from relmlor2.renesas.com ([210.160.252.172]:23339 "EHLO
        relmlie6.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728614AbgGTL7j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 07:59:39 -0400
X-IronPort-AV: E=Sophos;i="5.75,374,1589209200"; 
   d="scan'208";a="52390977"
Received: from unknown (HELO relmlir6.idc.renesas.com) ([10.200.68.152])
  by relmlie6.idc.renesas.com with ESMTP; 20 Jul 2020 20:59:38 +0900
Received: from localhost.localdomain (unknown [10.166.252.89])
        by relmlir6.idc.renesas.com (Postfix) with ESMTP id 2F832427AAC8;
        Mon, 20 Jul 2020 20:59:38 +0900 (JST)
From:   Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
To:     sergei.shtylyov@gmail.com, davem@davemloft.net, kuba@kernel.org
Cc:     dirk.behme@de.bosch.com, Shashikant.Suguni@in.bosch.com,
        netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Subject: [PATCH/RFC v2] net: ethernet: ravb: exit if hardware is in-progress in tx timeout
Date:   Mon, 20 Jul 2020 20:58:18 +0900
Message-Id: <1595246298-29260-1-git-send-email-yoshihiro.shimoda.uh@renesas.com>
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
the return value of ravb_stop_dma() whether this hardware can be
re-initialized or not. If ravb_stop_dma() fails, ravb_tx_timeout_work()
re-enables TX and RX and just exits.

[1]
https://lore.kernel.org/linux-renesas-soc/20200518045452.2390-1-dirk.behme@de.bosch.com/

Reported-by: Dirk Behme <dirk.behme@de.bosch.com>
Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
---
 Changes from RFC v1:
 - Check the return value of ravb_stop_dma() and exit if the hardware
   condition can not be initialized in the tx timeout.
 - Update the commit subject and description.
 - Fix some typo.
 https://patchwork.kernel.org/patch/11570217/

 Unfortunately, I still didn't reproduce the issue yet. So, I still
 marked RFC on this patch.

 drivers/net/ethernet/renesas/ravb_main.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index a442bcf6..500f5c1 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -1458,7 +1458,18 @@ static void ravb_tx_timeout_work(struct work_struct *work)
 		ravb_ptp_stop(ndev);
 
 	/* Wait for DMA stopping */
-	ravb_stop_dma(ndev);
+	if (ravb_stop_dma(ndev)) {
+		/* If ravb_stop_dma() fails, the hardware is still in-progress
+		 * as "Operation" mode for TX and/or RX. So, this should not
+		 * call the following functions because ravb_dmac_init() is
+		 * possible to fail too. Also, this should not retry
+		 * ravb_stop_dma() again and again here because it's possible
+		 * to wait forever. So, this just re-enables the TX and RX and
+		 * skip the following re-initialization procedure.
+		 */
+		ravb_rcv_snd_enable(ndev);
+		goto out;
+	}
 
 	ravb_ring_free(ndev, RAVB_BE);
 	ravb_ring_free(ndev, RAVB_NC);
@@ -1467,6 +1478,7 @@ static void ravb_tx_timeout_work(struct work_struct *work)
 	ravb_dmac_init(ndev);
 	ravb_emac_init(ndev);
 
+out:
 	/* Initialise PTP Clock driver */
 	if (priv->chip_id == RCAR_GEN2)
 		ravb_ptp_init(ndev, priv->pdev);
-- 
2.7.4

