Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A87033D2568
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 16:15:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232426AbhGVNe3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 09:34:29 -0400
Received: from relmlor2.renesas.com ([210.160.252.172]:5527 "EHLO
        relmlie6.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S232335AbhGVNeA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Jul 2021 09:34:00 -0400
X-IronPort-AV: E=Sophos;i="5.84,261,1620658800"; 
   d="scan'208";a="88414770"
Received: from unknown (HELO relmlir5.idc.renesas.com) ([10.200.68.151])
  by relmlie6.idc.renesas.com with ESMTP; 22 Jul 2021 23:14:33 +0900
Received: from localhost.localdomain (unknown [10.226.92.164])
        by relmlir5.idc.renesas.com (Postfix) with ESMTP id 28A81401224A;
        Thu, 22 Jul 2021 23:14:29 +0900 (JST)
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
Subject: [PATCH net-next 10/18] ravb: Factorise ravb_ring_format function
Date:   Thu, 22 Jul 2021 15:13:43 +0100
Message-Id: <20210722141351.13668-11-biju.das.jz@bp.renesas.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210722141351.13668-1-biju.das.jz@bp.renesas.com>
References: <20210722141351.13668-1-biju.das.jz@bp.renesas.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ravb_ring_format function uses extended descriptor in rx for
R-Car where as it use normal descriptor for RZ/G2L. Factorise
rx ring buffer buildup to extend the support for later SoC.

Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Reviewed-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
---
 drivers/net/ethernet/renesas/ravb.h      |  1 +
 drivers/net/ethernet/renesas/ravb_main.c | 34 +++++++++++++++---------
 2 files changed, 23 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/renesas/ravb.h b/drivers/net/ethernet/renesas/ravb.h
index 3a9cf6e8671a..a3258c5d0c3d 100644
--- a/drivers/net/ethernet/renesas/ravb.h
+++ b/drivers/net/ethernet/renesas/ravb.h
@@ -990,6 +990,7 @@ enum ravb_chip_id {
 
 struct ravb_ops {
 	void (*ring_free)(struct net_device *ndev, int q);
+	void (*ring_format)(struct net_device *ndev, int q);
 };
 
 struct ravb_drv_data {
diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index a3b8b243fd54..c23f0d420c70 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -311,26 +311,15 @@ static void ravb_ring_free(struct net_device *ndev, int q)
 }
 
 /* Format skb and descriptor buffer for Ethernet AVB */
-static void ravb_ring_format(struct net_device *ndev, int q)
+static void ravb_ring_format_rx(struct net_device *ndev, int q)
 {
 	struct ravb_private *priv = netdev_priv(ndev);
-	int num_tx_desc = priv->num_tx_desc;
 	struct ravb_ex_rx_desc *rx_desc;
-	struct ravb_tx_desc *tx_desc;
-	struct ravb_desc *desc;
 	int rx_ring_size = sizeof(*rx_desc) * priv->num_rx_ring[q];
-	int tx_ring_size = sizeof(*tx_desc) * priv->num_tx_ring[q] *
-			   num_tx_desc;
 	dma_addr_t dma_addr;
 	int i;
 
-	priv->cur_rx[q] = 0;
-	priv->cur_tx[q] = 0;
-	priv->dirty_rx[q] = 0;
-	priv->dirty_tx[q] = 0;
-
 	memset(priv->rx_ring[q], 0, rx_ring_size);
-	/* Build RX ring buffer */
 	for (i = 0; i < priv->num_rx_ring[q]; i++) {
 		/* RX descriptor */
 		rx_desc = &priv->rx_ring[q][i];
@@ -349,6 +338,26 @@ static void ravb_ring_format(struct net_device *ndev, int q)
 	rx_desc = &priv->rx_ring[q][i];
 	rx_desc->dptr = cpu_to_le32((u32)priv->rx_desc_dma[q]);
 	rx_desc->die_dt = DT_LINKFIX; /* type */
+}
+
+static void ravb_ring_format(struct net_device *ndev, int q)
+{
+	struct ravb_private *priv = netdev_priv(ndev);
+	const struct ravb_drv_data *info = priv->info;
+	int num_tx_desc = priv->num_tx_desc;
+	struct ravb_tx_desc *tx_desc;
+	struct ravb_desc *desc;
+	int tx_ring_size = sizeof(*tx_desc) * priv->num_tx_ring[q] *
+			   num_tx_desc;
+	int i;
+
+	priv->cur_rx[q] = 0;
+	priv->cur_tx[q] = 0;
+	priv->dirty_rx[q] = 0;
+	priv->dirty_tx[q] = 0;
+
+	/* Build RX ring buffer */
+	info->ravb_ops->ring_format(ndev, q);
 
 	memset(priv->tx_ring[q], 0, tx_ring_size);
 	/* Build TX ring buffer */
@@ -1998,6 +2007,7 @@ static int ravb_mdio_release(struct ravb_private *priv)
 
 static const struct ravb_ops ravb_gen3_ops = {
 	.ring_free = ravb_ring_free_rx,
+	.ring_format = ravb_ring_format_rx,
 };
 
 static const struct ravb_drv_data ravb_gen3_data = {
-- 
2.17.1

