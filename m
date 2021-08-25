Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11AA23F700B
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 09:02:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238483AbhHYHD0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 03:03:26 -0400
Received: from relmlor2.renesas.com ([210.160.252.172]:5816 "EHLO
        relmlie6.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S239141AbhHYHDL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 03:03:11 -0400
X-IronPort-AV: E=Sophos;i="5.84,349,1620658800"; 
   d="scan'208";a="91716487"
Received: from unknown (HELO relmlir6.idc.renesas.com) ([10.200.68.152])
  by relmlie6.idc.renesas.com with ESMTP; 25 Aug 2021 16:02:22 +0900
Received: from localhost.localdomain (unknown [10.226.92.232])
        by relmlir6.idc.renesas.com (Postfix) with ESMTP id 4288842016B7;
        Wed, 25 Aug 2021 16:02:19 +0900 (JST)
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
Subject: [PATCH net-next 06/13] ravb: Factorise ravb_ring_format function
Date:   Wed, 25 Aug 2021 08:01:47 +0100
Message-Id: <20210825070154.14336-7-biju.das.jz@bp.renesas.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210825070154.14336-1-biju.das.jz@bp.renesas.com>
References: <20210825070154.14336-1-biju.das.jz@bp.renesas.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ravb_ring_format function uses an extended descriptor in RX
for R-Car compared to the normal descriptor for RZ/G2L. Factorise
RX ring buffer buildup to extend the support for later SoC.

Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Reviewed-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
---
 drivers/net/ethernet/renesas/ravb.h      |  1 +
 drivers/net/ethernet/renesas/ravb_main.c | 35 ++++++++++++++++--------
 2 files changed, 24 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/renesas/ravb.h b/drivers/net/ethernet/renesas/ravb.h
index 7cb30319524a..dbf114d2ceef 100644
--- a/drivers/net/ethernet/renesas/ravb.h
+++ b/drivers/net/ethernet/renesas/ravb.h
@@ -981,6 +981,7 @@ struct ravb_ptp {
 
 struct ravb_hw_info {
 	void (*rx_ring_free)(struct net_device *ndev, int q);
+	void (*rx_ring_format)(struct net_device *ndev, int q);
 	const char (*gstrings_stats)[ETH_GSTRING_LEN];
 	size_t gstrings_size;
 	netdev_features_t net_hw_features;
diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index dc388a32496a..e52e36ccd1c6 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -282,25 +282,14 @@ static void ravb_ring_free(struct net_device *ndev, int q)
 	priv->tx_skb[q] = NULL;
 }
 
-/* Format skb and descriptor buffer for Ethernet AVB */
-static void ravb_ring_format(struct net_device *ndev, int q)
+static void ravb_rx_ring_format(struct net_device *ndev, int q)
 {
 	struct ravb_private *priv = netdev_priv(ndev);
-	unsigned int num_tx_desc = priv->num_tx_desc;
 	struct ravb_ex_rx_desc *rx_desc;
-	struct ravb_tx_desc *tx_desc;
-	struct ravb_desc *desc;
 	unsigned int rx_ring_size = sizeof(*rx_desc) * priv->num_rx_ring[q];
-	unsigned int tx_ring_size = sizeof(*tx_desc) * priv->num_tx_ring[q] *
-				    num_tx_desc;
 	dma_addr_t dma_addr;
 	unsigned int i;
 
-	priv->cur_rx[q] = 0;
-	priv->cur_tx[q] = 0;
-	priv->dirty_rx[q] = 0;
-	priv->dirty_tx[q] = 0;
-
 	memset(priv->rx_ring[q], 0, rx_ring_size);
 	/* Build RX ring buffer */
 	for (i = 0; i < priv->num_rx_ring[q]; i++) {
@@ -321,6 +310,26 @@ static void ravb_ring_format(struct net_device *ndev, int q)
 	rx_desc = &priv->rx_ring[q][i];
 	rx_desc->dptr = cpu_to_le32((u32)priv->rx_desc_dma[q]);
 	rx_desc->die_dt = DT_LINKFIX; /* type */
+}
+
+/* Format skb and descriptor buffer for Ethernet AVB */
+static void ravb_ring_format(struct net_device *ndev, int q)
+{
+	struct ravb_private *priv = netdev_priv(ndev);
+	const struct ravb_hw_info *info = priv->info;
+	unsigned int num_tx_desc = priv->num_tx_desc;
+	struct ravb_tx_desc *tx_desc;
+	struct ravb_desc *desc;
+	unsigned int tx_ring_size = sizeof(*tx_desc) * priv->num_tx_ring[q] *
+				    num_tx_desc;
+	unsigned int i;
+
+	priv->cur_rx[q] = 0;
+	priv->cur_tx[q] = 0;
+	priv->dirty_rx[q] = 0;
+	priv->dirty_tx[q] = 0;
+
+	info->rx_ring_format(ndev, q);
 
 	memset(priv->tx_ring[q], 0, tx_ring_size);
 	/* Build TX ring buffer */
@@ -1949,6 +1958,7 @@ static int ravb_mdio_release(struct ravb_private *priv)
 
 static const struct ravb_hw_info ravb_gen3_hw_info = {
 	.rx_ring_free = ravb_rx_ring_free,
+	.rx_ring_format = ravb_rx_ring_format,
 	.gstrings_stats = ravb_gstrings_stats,
 	.gstrings_size = sizeof(ravb_gstrings_stats),
 	.net_hw_features = NETIF_F_RXCSUM,
@@ -1963,6 +1973,7 @@ static const struct ravb_hw_info ravb_gen3_hw_info = {
 
 static const struct ravb_hw_info ravb_gen2_hw_info = {
 	.rx_ring_free = ravb_rx_ring_free,
+	.rx_ring_format = ravb_rx_ring_format,
 	.gstrings_stats = ravb_gstrings_stats,
 	.gstrings_size = sizeof(ravb_gstrings_stats),
 	.net_hw_features = NETIF_F_RXCSUM,
-- 
2.17.1

