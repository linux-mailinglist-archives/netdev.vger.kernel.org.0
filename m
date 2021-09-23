Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E4F74160A1
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 16:08:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241640AbhIWOKP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 10:10:15 -0400
Received: from relmlor2.renesas.com ([210.160.252.172]:47424 "EHLO
        relmlie6.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S241631AbhIWOKM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Sep 2021 10:10:12 -0400
X-IronPort-AV: E=Sophos;i="5.85,316,1624287600"; 
   d="scan'208";a="94936082"
Received: from unknown (HELO relmlir6.idc.renesas.com) ([10.200.68.152])
  by relmlie6.idc.renesas.com with ESMTP; 23 Sep 2021 23:08:39 +0900
Received: from localhost.localdomain (unknown [10.226.92.2])
        by relmlir6.idc.renesas.com (Postfix) with ESMTP id 06486437F0B6;
        Thu, 23 Sep 2021 23:08:36 +0900 (JST)
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
Subject: [RFC/PATCH 06/18] ravb: Add multi_tsrq to struct ravb_hw_info
Date:   Thu, 23 Sep 2021 15:08:01 +0100
Message-Id: <20210923140813.13541-7-biju.das.jz@bp.renesas.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210923140813.13541-1-biju.das.jz@bp.renesas.com>
References: <20210923140813.13541-1-biju.das.jz@bp.renesas.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

R-Car AVB-DMAC has 4 Transmit start Request queues, whereas
RZ/G2L has only 1 Transmit start Request queue(Best Effort)

Add a multi_tsrq hw feature bit to struct ravb_hw_info to enable
this only for R-Car. This will allow us to add single TSRQ support for
RZ/G2L.

Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
---
 drivers/net/ethernet/renesas/ravb.h      |  1 +
 drivers/net/ethernet/renesas/ravb_main.c | 12 ++++++++++--
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/renesas/ravb.h b/drivers/net/ethernet/renesas/ravb.h
index bb92469d770e..c043ee555be4 100644
--- a/drivers/net/ethernet/renesas/ravb.h
+++ b/drivers/net/ethernet/renesas/ravb.h
@@ -1006,6 +1006,7 @@ struct ravb_hw_info {
 	unsigned multi_irqs:1;		/* AVB-DMAC and E-MAC has multiple irqs */
 	unsigned no_gptp:1;		/* AVB-DMAC does not support gPTP feature */
 	unsigned ccc_gac:1;		/* AVB-DMAC has gPTP support active in config mode */
+	unsigned multi_tsrq:1;		/* AVB-DMAC has MULTI TSRQ */
 };
 
 struct ravb_private {
diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index 8663d83507a0..d37d73f6d984 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -776,11 +776,17 @@ static void ravb_rcv_snd_enable(struct net_device *ndev)
 /* function for waiting dma process finished */
 static int ravb_stop_dma(struct net_device *ndev)
 {
+	struct ravb_private *priv = netdev_priv(ndev);
+	const struct ravb_hw_info *info = priv->info;
 	int error;
 
 	/* Wait for stopping the hardware TX process */
-	error = ravb_wait(ndev, TCCR,
-			  TCCR_TSRQ0 | TCCR_TSRQ1 | TCCR_TSRQ2 | TCCR_TSRQ3, 0);
+	if (info->multi_tsrq)
+		error = ravb_wait(ndev, TCCR,
+				  TCCR_TSRQ0 | TCCR_TSRQ1 | TCCR_TSRQ2 | TCCR_TSRQ3, 0);
+	else
+		error = ravb_wait(ndev, TCCR, TCCR_TSRQ0, 0);
+
 	if (error)
 		return error;
 
@@ -2088,6 +2094,7 @@ static const struct ravb_hw_info ravb_gen3_hw_info = {
 	.tx_counters = 1,
 	.multi_irqs = 1,
 	.ccc_gac = 1,
+	.multi_tsrq = 1,
 };
 
 static const struct ravb_hw_info ravb_gen2_hw_info = {
@@ -2106,6 +2113,7 @@ static const struct ravb_hw_info ravb_gen2_hw_info = {
 	.stats_len = ARRAY_SIZE(ravb_gstrings_stats),
 	.max_rx_len = RX_BUF_SZ + RAVB_ALIGN - 1,
 	.aligned_tx = 1,
+	.multi_tsrq = 1,
 };
 
 static const struct ravb_hw_info rgeth_hw_info = {
-- 
2.17.1

