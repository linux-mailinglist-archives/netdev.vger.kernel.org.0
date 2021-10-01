Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35BEF41F258
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 18:43:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355217AbhJAQpM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 12:45:12 -0400
Received: from relmlor2.renesas.com ([210.160.252.172]:53132 "EHLO
        relmlie6.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1355151AbhJAQpJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Oct 2021 12:45:09 -0400
X-IronPort-AV: E=Sophos;i="5.85,339,1624287600"; 
   d="scan'208";a="95827544"
Received: from unknown (HELO relmlir5.idc.renesas.com) ([10.200.68.151])
  by relmlie6.idc.renesas.com with ESMTP; 02 Oct 2021 01:43:25 +0900
Received: from localhost.localdomain (unknown [10.226.92.36])
        by relmlir5.idc.renesas.com (Postfix) with ESMTP id 1AFC44001DD6;
        Sat,  2 Oct 2021 01:43:21 +0900 (JST)
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
Subject: [PATCH 4/8] ravb: Fillup ravb_alloc_rx_desc_gbeth() stub
Date:   Fri,  1 Oct 2021 17:43:01 +0100
Message-Id: <20211001164305.8999-5-biju.das.jz@bp.renesas.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211001164305.8999-1-biju.das.jz@bp.renesas.com>
References: <20211001164305.8999-1-biju.das.jz@bp.renesas.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fillup ravb_alloc_rx_desc_gbeth() function to support RZ/G2L.

This patch also renames ravb_alloc_rx_desc to ravb_alloc_rx_desc_rcar
to be consistent with the naming convention used in sh_eth driver.

Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Reviewed-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
---
RFC->v1:
 * renamed "rgeth" to "gbeth".
 * renamed ravb_alloc_rx_desc to ravb_alloc_rx_desc_rcar
---
 drivers/net/ethernet/renesas/ravb_main.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index d4642783afc9..899a7f29046b 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -430,11 +430,18 @@ static void ravb_ring_format(struct net_device *ndev, int q)
 
 static void *ravb_alloc_rx_desc_gbeth(struct net_device *ndev, int q)
 {
-	/* Place holder */
-	return NULL;
+	struct ravb_private *priv = netdev_priv(ndev);
+	unsigned int ring_size;
+
+	ring_size = sizeof(struct ravb_rx_desc) * (priv->num_rx_ring[q] + 1);
+
+	priv->gbeth_rx_ring[q] = dma_alloc_coherent(ndev->dev.parent, ring_size,
+						    &priv->rx_desc_dma[q],
+						    GFP_KERNEL);
+	return priv->gbeth_rx_ring[q];
 }
 
-static void *ravb_alloc_rx_desc(struct net_device *ndev, int q)
+static void *ravb_alloc_rx_desc_rcar(struct net_device *ndev, int q)
 {
 	struct ravb_private *priv = netdev_priv(ndev);
 	unsigned int ring_size;
@@ -2229,7 +2236,7 @@ static int ravb_mdio_release(struct ravb_private *priv)
 static const struct ravb_hw_info ravb_gen3_hw_info = {
 	.rx_ring_free = ravb_rx_ring_free_rcar,
 	.rx_ring_format = ravb_rx_ring_format_rcar,
-	.alloc_rx_desc = ravb_alloc_rx_desc,
+	.alloc_rx_desc = ravb_alloc_rx_desc_rcar,
 	.receive = ravb_rcar_rx,
 	.set_rate = ravb_set_rate_rcar,
 	.set_feature = ravb_set_features_rcar,
@@ -2254,7 +2261,7 @@ static const struct ravb_hw_info ravb_gen3_hw_info = {
 static const struct ravb_hw_info ravb_gen2_hw_info = {
 	.rx_ring_free = ravb_rx_ring_free_rcar,
 	.rx_ring_format = ravb_rx_ring_format_rcar,
-	.alloc_rx_desc = ravb_alloc_rx_desc,
+	.alloc_rx_desc = ravb_alloc_rx_desc_rcar,
 	.receive = ravb_rcar_rx,
 	.set_rate = ravb_set_rate_rcar,
 	.set_feature = ravb_set_features_rcar,
-- 
2.17.1

