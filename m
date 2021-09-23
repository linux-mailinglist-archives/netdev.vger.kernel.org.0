Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4AB24160A3
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 16:08:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241638AbhIWOKQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 10:10:16 -0400
Received: from relmlor1.renesas.com ([210.160.252.171]:30888 "EHLO
        relmlie5.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S241636AbhIWOKP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Sep 2021 10:10:15 -0400
X-IronPort-AV: E=Sophos;i="5.85,316,1624287600"; 
   d="scan'208";a="94816090"
Received: from unknown (HELO relmlir6.idc.renesas.com) ([10.200.68.152])
  by relmlie5.idc.renesas.com with ESMTP; 23 Sep 2021 23:08:43 +0900
Received: from localhost.localdomain (unknown [10.226.92.2])
        by relmlir6.idc.renesas.com (Postfix) with ESMTP id 592B3437F0B5;
        Thu, 23 Sep 2021 23:08:40 +0900 (JST)
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
Subject: [RFC/PATCH 07/18] ravb: Add magic_pkt to struct ravb_hw_info
Date:   Thu, 23 Sep 2021 15:08:02 +0100
Message-Id: <20210923140813.13541-8-biju.das.jz@bp.renesas.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210923140813.13541-1-biju.das.jz@bp.renesas.com>
References: <20210923140813.13541-1-biju.das.jz@bp.renesas.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

E-MAC on R-Car supports magic packet detection, whereas RZ/G2L
do not support this feature. Add magic_pkt to struct ravb_hw_info
and enable this feature only for R-Car.

Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
---
 drivers/net/ethernet/renesas/ravb.h      | 1 +
 drivers/net/ethernet/renesas/ravb_main.c | 8 ++++++--
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/renesas/ravb.h b/drivers/net/ethernet/renesas/ravb.h
index c043ee555be4..bce480fadb91 100644
--- a/drivers/net/ethernet/renesas/ravb.h
+++ b/drivers/net/ethernet/renesas/ravb.h
@@ -1007,6 +1007,7 @@ struct ravb_hw_info {
 	unsigned no_gptp:1;		/* AVB-DMAC does not support gPTP feature */
 	unsigned ccc_gac:1;		/* AVB-DMAC has gPTP support active in config mode */
 	unsigned multi_tsrq:1;		/* AVB-DMAC has MULTI TSRQ */
+	unsigned magic_pkt:1;		/* E-MAC supports magic packet detection */
 };
 
 struct ravb_private {
diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index d37d73f6d984..529364d8f7fb 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -811,12 +811,13 @@ static int ravb_stop_dma(struct net_device *ndev)
 static void ravb_emac_interrupt_unlocked(struct net_device *ndev)
 {
 	struct ravb_private *priv = netdev_priv(ndev);
+	const struct ravb_hw_info *info = priv->info;
 	u32 ecsr, psr;
 
 	ecsr = ravb_read(ndev, ECSR);
 	ravb_write(ndev, ecsr, ECSR);	/* clear interrupt */
 
-	if (ecsr & ECSR_MPD)
+	if (info->magic_pkt && (ecsr & ECSR_MPD))
 		pm_wakeup_event(&priv->pdev->dev, 0);
 	if (ecsr & ECSR_ICD)
 		ndev->stats.tx_carrier_errors++;
@@ -1416,8 +1417,9 @@ static void ravb_get_wol(struct net_device *ndev, struct ethtool_wolinfo *wol)
 static int ravb_set_wol(struct net_device *ndev, struct ethtool_wolinfo *wol)
 {
 	struct ravb_private *priv = netdev_priv(ndev);
+	const struct ravb_hw_info *info = priv->info;
 
-	if (wol->wolopts & ~WAKE_MAGIC)
+	if (!info->magic_pkt || (wol->wolopts & ~WAKE_MAGIC))
 		return -EOPNOTSUPP;
 
 	priv->wol_enabled = !!(wol->wolopts & WAKE_MAGIC);
@@ -2095,6 +2097,7 @@ static const struct ravb_hw_info ravb_gen3_hw_info = {
 	.multi_irqs = 1,
 	.ccc_gac = 1,
 	.multi_tsrq = 1,
+	.magic_pkt = 1,
 };
 
 static const struct ravb_hw_info ravb_gen2_hw_info = {
@@ -2114,6 +2117,7 @@ static const struct ravb_hw_info ravb_gen2_hw_info = {
 	.max_rx_len = RX_BUF_SZ + RAVB_ALIGN - 1,
 	.aligned_tx = 1,
 	.multi_tsrq = 1,
+	.magic_pkt = 1,
 };
 
 static const struct ravb_hw_info rgeth_hw_info = {
-- 
2.17.1

