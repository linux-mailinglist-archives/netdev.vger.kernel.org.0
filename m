Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9CF741F092
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 17:07:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355016AbhJAPJF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 11:09:05 -0400
Received: from relmlor1.renesas.com ([210.160.252.171]:8350 "EHLO
        relmlie5.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1355027AbhJAPIx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Oct 2021 11:08:53 -0400
X-IronPort-AV: E=Sophos;i="5.85,339,1624287600"; 
   d="scan'208";a="95671628"
Received: from unknown (HELO relmlir6.idc.renesas.com) ([10.200.68.152])
  by relmlie5.idc.renesas.com with ESMTP; 02 Oct 2021 00:07:08 +0900
Received: from localhost.localdomain (unknown [10.226.92.36])
        by relmlir6.idc.renesas.com (Postfix) with ESMTP id 57A1943DDFC8;
        Sat,  2 Oct 2021 00:07:05 +0900 (JST)
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
Subject: [PATCH 07/10] ravb: Add tsrq to struct ravb_hw_info
Date:   Fri,  1 Oct 2021 16:06:33 +0100
Message-Id: <20211001150636.7500-8-biju.das.jz@bp.renesas.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211001150636.7500-1-biju.das.jz@bp.renesas.com>
References: <20211001150636.7500-1-biju.das.jz@bp.renesas.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

R-Car AVB-DMAC has 4 Transmit start request queues, whereas
RZ/G2L has only 1 Transmit start request queue.

Add a tsrq variable to struct ravb_hw_info to handle this
difference.

Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Reviewed-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
---
RFC->v1:
 * Added tsrq variable instead of multi_tsrq feature bit.
---
 drivers/net/ethernet/renesas/ravb.h      | 1 +
 drivers/net/ethernet/renesas/ravb_main.c | 9 +++++++--
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/renesas/ravb.h b/drivers/net/ethernet/renesas/ravb.h
index 9cd3a15743b4..c586070193ef 100644
--- a/drivers/net/ethernet/renesas/ravb.h
+++ b/drivers/net/ethernet/renesas/ravb.h
@@ -997,6 +997,7 @@ struct ravb_hw_info {
 	netdev_features_t net_features;
 	int stats_len;
 	size_t max_rx_len;
+	u32 tsrq;
 	unsigned aligned_tx: 1;
 
 	/* hardware features */
diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index ac141a491ca2..4784832bd93c 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -790,11 +790,13 @@ static void ravb_rcv_snd_enable(struct net_device *ndev)
 /* function for waiting dma process finished */
 static int ravb_stop_dma(struct net_device *ndev)
 {
+	struct ravb_private *priv = netdev_priv(ndev);
+	const struct ravb_hw_info *info = priv->info;
 	int error;
 
 	/* Wait for stopping the hardware TX process */
-	error = ravb_wait(ndev, TCCR,
-			  TCCR_TSRQ0 | TCCR_TSRQ1 | TCCR_TSRQ2 | TCCR_TSRQ3, 0);
+	error = ravb_wait(ndev, TCCR, info->tsrq, 0);
+
 	if (error)
 		return error;
 
@@ -2128,6 +2130,7 @@ static const struct ravb_hw_info ravb_gen3_hw_info = {
 	.net_features = NETIF_F_RXCSUM,
 	.stats_len = ARRAY_SIZE(ravb_gstrings_stats),
 	.max_rx_len = RX_BUF_SZ + RAVB_ALIGN - 1,
+	.tsrq = TCCR_TSRQ0 | TCCR_TSRQ1 | TCCR_TSRQ2 | TCCR_TSRQ3,
 	.internal_delay = 1,
 	.tx_counters = 1,
 	.multi_irqs = 1,
@@ -2150,6 +2153,7 @@ static const struct ravb_hw_info ravb_gen2_hw_info = {
 	.net_features = NETIF_F_RXCSUM,
 	.stats_len = ARRAY_SIZE(ravb_gstrings_stats),
 	.max_rx_len = RX_BUF_SZ + RAVB_ALIGN - 1,
+	.tsrq = TCCR_TSRQ0 | TCCR_TSRQ1 | TCCR_TSRQ2 | TCCR_TSRQ3,
 	.aligned_tx = 1,
 	.gptp = 1,
 	.nc_queue = 1,
@@ -2165,6 +2169,7 @@ static const struct ravb_hw_info gbeth_hw_info = {
 	.dmac_init = ravb_dmac_init_gbeth,
 	.emac_init = ravb_emac_init_gbeth,
 	.max_rx_len = GBETH_RX_BUFF_MAX + RAVB_ALIGN - 1,
+	.tsrq = TCCR_TSRQ0,
 	.aligned_tx = 1,
 	.tx_counters = 1,
 };
-- 
2.17.1

