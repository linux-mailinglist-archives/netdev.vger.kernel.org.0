Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FCFB427FC2
	for <lists+netdev@lfdr.de>; Sun, 10 Oct 2021 09:29:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231205AbhJJHbo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Oct 2021 03:31:44 -0400
Received: from relmlor2.renesas.com ([210.160.252.172]:18551 "EHLO
        relmlie6.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231203AbhJJHbm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Oct 2021 03:31:42 -0400
X-IronPort-AV: E=Sophos;i="5.85,362,1624287600"; 
   d="scan'208";a="96694920"
Received: from unknown (HELO relmlir5.idc.renesas.com) ([10.200.68.151])
  by relmlie6.idc.renesas.com with ESMTP; 10 Oct 2021 16:29:43 +0900
Received: from localhost.localdomain (unknown [10.226.92.12])
        by relmlir5.idc.renesas.com (Postfix) with ESMTP id 349B74005152;
        Sun, 10 Oct 2021 16:29:40 +0900 (JST)
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Biju Das <biju.das.jz@bp.renesas.com>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        Adam Ford <aford173@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Yuusuke Ashizuka <ashiduka@fujitsu.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>
Subject: [PATCH net-next v2 05/14] ravb: Fillup ravb_rx_ring_format_gbeth() stub
Date:   Sun, 10 Oct 2021 08:29:11 +0100
Message-Id: <20211010072920.20706-6-biju.das.jz@bp.renesas.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211010072920.20706-1-biju.das.jz@bp.renesas.com>
References: <20211010072920.20706-1-biju.das.jz@bp.renesas.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fillup ravb_rx_ring_format_gbeth() function to support RZ/G2L.

This patch also renames ravb_rx_ring_format to ravb_rx_ring_format_rcar
to be consistent with the naming convention used in sh_eth driver.

Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Reviewed-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Reviewed-by: Sergey Shtylyov <s.shtylyov@omp.ru>
---
V1->V2:
 * No change
RFC->V1:
 * No change. Added Sergey's Rb tag.
RFC changes:
 * Started using gbeth_rx_ring instead of gbeth_rx_ring[q].
 * renamed ravb_rx_ring_format to ravb_rx_ring_format_rcar
---
 drivers/net/ethernet/renesas/ravb.h      |  1 +
 drivers/net/ethernet/renesas/ravb_main.c | 34 +++++++++++++++++++++---
 2 files changed, 31 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/renesas/ravb.h b/drivers/net/ethernet/renesas/ravb.h
index ed771ead61b9..e9de3f8306ce 100644
--- a/drivers/net/ethernet/renesas/ravb.h
+++ b/drivers/net/ethernet/renesas/ravb.h
@@ -970,6 +970,7 @@ enum CXR31_BIT {
 #define RX_BUF_SZ	(2048 - ETH_FCS_LEN + sizeof(__sum16))
 
 #define GBETH_RX_BUFF_MAX 8192
+#define GBETH_RX_DESC_DATA_SIZE 4080
 
 struct ravb_tstamp_skb {
 	struct list_head list;
diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index 1fc2abd3dc0e..7e6ed6eda741 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -327,10 +327,36 @@ static void ravb_ring_free(struct net_device *ndev, int q)
 
 static void ravb_rx_ring_format_gbeth(struct net_device *ndev, int q)
 {
-	/* Place holder */
+	struct ravb_private *priv = netdev_priv(ndev);
+	struct ravb_rx_desc *rx_desc;
+	unsigned int rx_ring_size;
+	dma_addr_t dma_addr;
+	unsigned int i;
+
+	rx_ring_size = sizeof(*rx_desc) * priv->num_rx_ring[q];
+	memset(priv->gbeth_rx_ring, 0, rx_ring_size);
+	/* Build RX ring buffer */
+	for (i = 0; i < priv->num_rx_ring[q]; i++) {
+		/* RX descriptor */
+		rx_desc = &priv->gbeth_rx_ring[i];
+		rx_desc->ds_cc = cpu_to_le16(GBETH_RX_DESC_DATA_SIZE);
+		dma_addr = dma_map_single(ndev->dev.parent, priv->rx_skb[q][i]->data,
+					  GBETH_RX_BUFF_MAX,
+					  DMA_FROM_DEVICE);
+		/* We just set the data size to 0 for a failed mapping which
+		 * should prevent DMA from happening...
+		 */
+		if (dma_mapping_error(ndev->dev.parent, dma_addr))
+			rx_desc->ds_cc = cpu_to_le16(0);
+		rx_desc->dptr = cpu_to_le32(dma_addr);
+		rx_desc->die_dt = DT_FEMPTY;
+	}
+	rx_desc = &priv->gbeth_rx_ring[i];
+	rx_desc->dptr = cpu_to_le32((u32)priv->rx_desc_dma[q]);
+	rx_desc->die_dt = DT_LINKFIX; /* type */
 }
 
-static void ravb_rx_ring_format(struct net_device *ndev, int q)
+static void ravb_rx_ring_format_rcar(struct net_device *ndev, int q)
 {
 	struct ravb_private *priv = netdev_priv(ndev);
 	struct ravb_ex_rx_desc *rx_desc;
@@ -2210,7 +2236,7 @@ static int ravb_mdio_release(struct ravb_private *priv)
 
 static const struct ravb_hw_info ravb_gen3_hw_info = {
 	.rx_ring_free = ravb_rx_ring_free_rcar,
-	.rx_ring_format = ravb_rx_ring_format,
+	.rx_ring_format = ravb_rx_ring_format_rcar,
 	.alloc_rx_desc = ravb_alloc_rx_desc_rcar,
 	.receive = ravb_rcar_rx,
 	.set_rate = ravb_set_rate_rcar,
@@ -2235,7 +2261,7 @@ static const struct ravb_hw_info ravb_gen3_hw_info = {
 
 static const struct ravb_hw_info ravb_gen2_hw_info = {
 	.rx_ring_free = ravb_rx_ring_free_rcar,
-	.rx_ring_format = ravb_rx_ring_format,
+	.rx_ring_format = ravb_rx_ring_format_rcar,
 	.alloc_rx_desc = ravb_alloc_rx_desc_rcar,
 	.receive = ravb_rcar_rx,
 	.set_rate = ravb_set_rate_rcar,
-- 
2.17.1

