Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 462B735CA0F
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 17:37:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242970AbhDLPhq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 11:37:46 -0400
Received: from mga05.intel.com ([192.55.52.43]:41987 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242914AbhDLPhp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Apr 2021 11:37:45 -0400
IronPort-SDR: R0K20H000oLk8q4oziQWuz8Pd9wcH0X3HslcBg+8nS71F7fpNp8Zf2h64g0uyBrJtFopSDJ5qN
 mMa6fzrnfweQ==
X-IronPort-AV: E=McAfee;i="6200,9189,9952"; a="279520304"
X-IronPort-AV: E=Sophos;i="5.82,216,1613462400"; 
   d="scan'208";a="279520304"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2021 08:37:17 -0700
IronPort-SDR: Y+VhotsPXfLSlncPOi6QP+SGALop2oO8wwbDTZ1PYuURK7dOdAcdBBm1xQGnV3kSkCEJN3Lmvz
 1ekseQYaOLuA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,216,1613462400"; 
   d="scan'208";a="614609535"
Received: from glass.png.intel.com ([10.158.65.59])
  by fmsmga005.fm.intel.com with ESMTP; 12 Apr 2021 08:37:13 -0700
From:   Ong Boon Leong <boon.leong.ong@intel.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, Ong Boon Leong <boon.leong.ong@intel.com>
Subject: [PATCH net-next 1/7] net: stmmac: rearrange RX buffer allocation and free functions
Date:   Mon, 12 Apr 2021 23:41:24 +0800
Message-Id: <20210412154130.20742-2-boon.leong.ong@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210412154130.20742-1-boon.leong.ong@intel.com>
References: <20210412154130.20742-1-boon.leong.ong@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch restructures the per RX queue buffer allocation from page_pool
to stmmac_alloc_rx_buffers().

We also rearrange dma_free_rx_skbufs() so that it can be used in
init_dma_rx_desc_rings() during freeing of RX buffer in the event of
page_pool allocation failure to replace the more efficient method earlier.
The replacement is needed to make the RX buffer alloc and free method
scalable to XDP ZC xsk_pool alloc and free later.

Signed-off-by: Ong Boon Leong <boon.leong.ong@intel.com>
---
 .../net/ethernet/stmicro/stmmac/stmmac_main.c | 84 +++++++++++--------
 1 file changed, 47 insertions(+), 37 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 77285646c5fc..f6d3d26ce45a 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -1475,6 +1475,43 @@ static void stmmac_free_tx_buffer(struct stmmac_priv *priv, u32 queue, int i)
 	tx_q->tx_skbuff_dma[i].map_as_page = false;
 }
 
+/**
+ * dma_free_rx_skbufs - free RX dma buffers
+ * @priv: private structure
+ * @queue: RX queue index
+ */
+static void dma_free_rx_skbufs(struct stmmac_priv *priv, u32 queue)
+{
+	int i;
+
+	for (i = 0; i < priv->dma_rx_size; i++)
+		stmmac_free_rx_buffer(priv, queue, i);
+}
+
+static int stmmac_alloc_rx_buffers(struct stmmac_priv *priv, u32 queue,
+				   gfp_t flags)
+{
+	struct stmmac_rx_queue *rx_q = &priv->rx_queue[queue];
+	int i;
+
+	for (i = 0; i < priv->dma_rx_size; i++) {
+		struct dma_desc *p;
+		int ret;
+
+		if (priv->extend_desc)
+			p = &((rx_q->dma_erx + i)->basic);
+		else
+			p = rx_q->dma_rx + i;
+
+		ret = stmmac_init_rx_buffers(priv, p, i, flags,
+					     queue);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
 /**
  * stmmac_reinit_rx_buffers - reinit the RX descriptor buffer.
  * @priv: driver private structure
@@ -1547,15 +1584,14 @@ static void stmmac_reinit_rx_buffers(struct stmmac_priv *priv)
 	return;
 
 err_reinit_rx_buffers:
-	do {
-		while (--i >= 0)
-			stmmac_free_rx_buffer(priv, queue, i);
+	while (queue >= 0) {
+		dma_free_rx_skbufs(priv, queue);
 
 		if (queue == 0)
 			break;
 
-		i = priv->dma_rx_size;
-	} while (queue-- > 0);
+		queue--;
+	}
 }
 
 /**
@@ -1572,7 +1608,6 @@ static int init_dma_rx_desc_rings(struct net_device *dev, gfp_t flags)
 	u32 rx_count = priv->plat->rx_queues_to_use;
 	int ret = -ENOMEM;
 	int queue;
-	int i;
 
 	/* RX INITIALIZATION */
 	netif_dbg(priv, probe, priv->dev,
@@ -1580,7 +1615,7 @@ static int init_dma_rx_desc_rings(struct net_device *dev, gfp_t flags)
 
 	for (queue = 0; queue < rx_count; queue++) {
 		struct stmmac_rx_queue *rx_q = &priv->rx_queue[queue];
-		int ret;
+
 
 		netif_dbg(priv, probe, priv->dev,
 			  "(%s) dma_rx_phy=0x%08x\n", __func__,
@@ -1596,22 +1631,12 @@ static int init_dma_rx_desc_rings(struct net_device *dev, gfp_t flags)
 			    "Register MEM_TYPE_PAGE_POOL RxQ-%d\n",
 			    rx_q->queue_index);
 
-		for (i = 0; i < priv->dma_rx_size; i++) {
-			struct dma_desc *p;
-
-			if (priv->extend_desc)
-				p = &((rx_q->dma_erx + i)->basic);
-			else
-				p = rx_q->dma_rx + i;
-
-			ret = stmmac_init_rx_buffers(priv, p, i, flags,
-						     queue);
-			if (ret)
-				goto err_init_rx_buffers;
-		}
+		ret = stmmac_alloc_rx_buffers(priv, queue, flags);
+		if (ret < 0)
+			goto err_init_rx_buffers;
 
 		rx_q->cur_rx = 0;
-		rx_q->dirty_rx = (unsigned int)(i - priv->dma_rx_size);
+		rx_q->dirty_rx = 0;
 
 		/* Setup the chained descriptor addresses */
 		if (priv->mode == STMMAC_CHAIN_MODE) {
@@ -1630,13 +1655,11 @@ static int init_dma_rx_desc_rings(struct net_device *dev, gfp_t flags)
 
 err_init_rx_buffers:
 	while (queue >= 0) {
-		while (--i >= 0)
-			stmmac_free_rx_buffer(priv, queue, i);
+		dma_free_rx_skbufs(priv, queue);
 
 		if (queue == 0)
 			break;
 
-		i = priv->dma_rx_size;
 		queue--;
 	}
 
@@ -1731,19 +1754,6 @@ static int init_dma_desc_rings(struct net_device *dev, gfp_t flags)
 	return ret;
 }
 
-/**
- * dma_free_rx_skbufs - free RX dma buffers
- * @priv: private structure
- * @queue: RX queue index
- */
-static void dma_free_rx_skbufs(struct stmmac_priv *priv, u32 queue)
-{
-	int i;
-
-	for (i = 0; i < priv->dma_rx_size; i++)
-		stmmac_free_rx_buffer(priv, queue, i);
-}
-
 /**
  * dma_free_tx_skbufs - free TX dma buffers
  * @priv: private structure
-- 
2.25.1

