Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A76934160B5
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 16:09:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241685AbhIWOKk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 10:10:40 -0400
Received: from relmlor2.renesas.com ([210.160.252.172]:46334 "EHLO
        relmlie6.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S241606AbhIWOKi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Sep 2021 10:10:38 -0400
X-IronPort-AV: E=Sophos;i="5.85,316,1624287600"; 
   d="scan'208";a="94936120"
Received: from unknown (HELO relmlir6.idc.renesas.com) ([10.200.68.152])
  by relmlie6.idc.renesas.com with ESMTP; 23 Sep 2021 23:09:06 +0900
Received: from localhost.localdomain (unknown [10.226.92.2])
        by relmlir6.idc.renesas.com (Postfix) with ESMTP id D20EB437F0B8;
        Thu, 23 Sep 2021 23:09:03 +0900 (JST)
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
Subject: [RFC/PATCH 14/18] ravb: Add rx_ring_format function for GbEthernet
Date:   Thu, 23 Sep 2021 15:08:09 +0100
Message-Id: <20210923140813.13541-15-biju.das.jz@bp.renesas.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210923140813.13541-1-biju.das.jz@bp.renesas.com>
References: <20210923140813.13541-1-biju.das.jz@bp.renesas.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds rx_ring_format function for GbEthernet found on
RZ/G2L SoC.

Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
---
 drivers/net/ethernet/renesas/ravb.h      |  1 +
 drivers/net/ethernet/renesas/ravb_main.c | 27 +++++++++++++++++++++++-
 2 files changed, 27 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/renesas/ravb.h b/drivers/net/ethernet/renesas/ravb.h
index 2505de5d4a28..b0e067a6a8ee 100644
--- a/drivers/net/ethernet/renesas/ravb.h
+++ b/drivers/net/ethernet/renesas/ravb.h
@@ -982,6 +982,7 @@ enum CSR0_BIT {
 #define RX_BUF_SZ	(2048 - ETH_FCS_LEN + sizeof(__sum16))
 
 #define RGETH_RX_BUFF_MAX 8192
+#define RGETH_RX_DESC_DATA_SIZE 4080
 
 struct ravb_tstamp_skb {
 	struct list_head list;
diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index 038af36141bb..ee1066fedc4a 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -327,7 +327,32 @@ static void ravb_ring_free(struct net_device *ndev, int q)
 
 static void ravb_rx_ring_format_rgeth(struct net_device *ndev, int q)
 {
-	/* Place holder */
+	struct ravb_private *priv = netdev_priv(ndev);
+	struct ravb_rx_desc *rx_desc;
+	unsigned int rx_ring_size = sizeof(*rx_desc) * priv->num_rx_ring[q];
+	dma_addr_t dma_addr;
+	unsigned int i;
+
+	memset(priv->rgeth_rx_ring[q], 0, rx_ring_size);
+	/* Build RX ring buffer */
+	for (i = 0; i < priv->num_rx_ring[q]; i++) {
+		/* RX descriptor */
+		rx_desc = &priv->rgeth_rx_ring[q][i];
+		rx_desc->ds_cc = cpu_to_le16(RGETH_RX_DESC_DATA_SIZE);
+		dma_addr = dma_map_single(ndev->dev.parent, priv->rx_skb[q][i]->data,
+					  RGETH_RX_BUFF_MAX,
+					  DMA_FROM_DEVICE);
+		/* We just set the data size to 0 for a failed mapping which
+		 * should prevent DMA from happening...
+		 */
+		if (dma_mapping_error(ndev->dev.parent, dma_addr))
+			rx_desc->ds_cc = cpu_to_le16(0);
+		rx_desc->dptr = cpu_to_le32(dma_addr);
+		rx_desc->die_dt = DT_FEMPTY;
+	}
+	rx_desc = &priv->rgeth_rx_ring[q][i];
+	rx_desc->dptr = cpu_to_le32((u32)priv->rx_desc_dma[q]);
+	rx_desc->die_dt = DT_LINKFIX; /* type */
 }
 
 static void ravb_rx_ring_format(struct net_device *ndev, int q)
-- 
2.17.1

