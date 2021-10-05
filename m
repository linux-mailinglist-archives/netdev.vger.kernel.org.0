Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD0A1422499
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 13:07:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234289AbhJELI7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 07:08:59 -0400
Received: from relmlor2.renesas.com ([210.160.252.172]:11860 "EHLO
        relmlie6.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S234320AbhJELI4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Oct 2021 07:08:56 -0400
X-IronPort-AV: E=Sophos;i="5.85,348,1624287600"; 
   d="scan'208";a="96182787"
Received: from unknown (HELO relmlir5.idc.renesas.com) ([10.200.68.151])
  by relmlie6.idc.renesas.com with ESMTP; 05 Oct 2021 20:07:05 +0900
Received: from localhost.localdomain (unknown [10.226.93.104])
        by relmlir5.idc.renesas.com (Postfix) with ESMTP id C763D40078B9;
        Tue,  5 Oct 2021 20:07:02 +0900 (JST)
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
Subject: [RFC 05/12] ravb: Fillup ravb_rx_ring_free_gbeth() stub
Date:   Tue,  5 Oct 2021 12:06:35 +0100
Message-Id: <20211005110642.3744-6-biju.das.jz@bp.renesas.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211005110642.3744-1-biju.das.jz@bp.renesas.com>
References: <20211005110642.3744-1-biju.das.jz@bp.renesas.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fillup ravb_rx_ring_free_gbeth() function to support RZ/G2L.

This patch also renames ravb_rx_ring_free to ravb_rx_ring_free_rcar
to be consistent with the naming convention used in sh_eth driver.

Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Reviewed-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
---
RFC Changes:
 * moved "gbeth_rx_ring" to previous patch
 * started using "gbeth_rx_ring" instead of gbeth_rx_ring[q].
 * renamed ravb_rx_ring_free to ravb_rx_ring_free_rcar
---
 drivers/net/ethernet/renesas/ravb_main.c | 28 ++++++++++++++++++++----
 1 file changed, 24 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index 31de4e544525..69a2cd871344 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -236,10 +236,30 @@ static int ravb_tx_free(struct net_device *ndev, int q, bool free_txed_only)
 
 static void ravb_rx_ring_free_gbeth(struct net_device *ndev, int q)
 {
-	/* Place holder */
+	struct ravb_private *priv = netdev_priv(ndev);
+	unsigned int ring_size;
+	unsigned int i;
+
+	if (!priv->gbeth_rx_ring)
+		return;
+
+	for (i = 0; i < priv->num_rx_ring[q]; i++) {
+		struct ravb_rx_desc *desc = &priv->gbeth_rx_ring[i];
+
+		if (!dma_mapping_error(ndev->dev.parent,
+				       le32_to_cpu(desc->dptr)))
+			dma_unmap_single(ndev->dev.parent,
+					 le32_to_cpu(desc->dptr),
+					 GBETH_RX_BUFF_MAX,
+					 DMA_FROM_DEVICE);
+	}
+	ring_size = sizeof(struct ravb_rx_desc) * (priv->num_rx_ring[q] + 1);
+	dma_free_coherent(ndev->dev.parent, ring_size, priv->gbeth_rx_ring,
+			  priv->rx_desc_dma[q]);
+	priv->gbeth_rx_ring = NULL;
 }
 
-static void ravb_rx_ring_free(struct net_device *ndev, int q)
+static void ravb_rx_ring_free_rcar(struct net_device *ndev, int q)
 {
 	struct ravb_private *priv = netdev_priv(ndev);
 	unsigned int ring_size;
@@ -2220,7 +2240,7 @@ static int ravb_mdio_release(struct ravb_private *priv)
 }
 
 static const struct ravb_hw_info ravb_gen3_hw_info = {
-	.rx_ring_free = ravb_rx_ring_free,
+	.rx_ring_free = ravb_rx_ring_free_rcar,
 	.rx_ring_format = ravb_rx_ring_format,
 	.alloc_rx_desc = ravb_alloc_rx_desc_rcar,
 	.receive = ravb_rcar_rx,
@@ -2245,7 +2265,7 @@ static const struct ravb_hw_info ravb_gen3_hw_info = {
 };
 
 static const struct ravb_hw_info ravb_gen2_hw_info = {
-	.rx_ring_free = ravb_rx_ring_free,
+	.rx_ring_free = ravb_rx_ring_free_rcar,
 	.rx_ring_format = ravb_rx_ring_format,
 	.alloc_rx_desc = ravb_alloc_rx_desc_rcar,
 	.receive = ravb_rcar_rx,
-- 
2.17.1

