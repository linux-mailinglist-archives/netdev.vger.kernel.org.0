Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0768835CA12
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 17:37:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242914AbhDLPhr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 11:37:47 -0400
Received: from mga05.intel.com ([192.55.52.43]:41987 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238815AbhDLPhq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Apr 2021 11:37:46 -0400
IronPort-SDR: anEKIhXqTT9hr0PMFpL60mpVLxwTrFUG57/HWMA5ODhe7oIoIP4aSvLh5Fp2Pd3XXJHf3TTj51
 +fkY91Ee6WNA==
X-IronPort-AV: E=McAfee;i="6200,9189,9952"; a="279520320"
X-IronPort-AV: E=Sophos;i="5.82,216,1613462400"; 
   d="scan'208";a="279520320"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2021 08:37:22 -0700
IronPort-SDR: rU/QyxVH7CHZoRRJbWZmdzItTKVYNwJYF7MWf8wpED05IDgbda7spPyxXfCi3RBrhR9xWdKIAV
 YWqk+WeCgRSg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,216,1613462400"; 
   d="scan'208";a="614609549"
Received: from glass.png.intel.com ([10.158.65.59])
  by fmsmga005.fm.intel.com with ESMTP; 12 Apr 2021 08:37:18 -0700
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
Subject: [PATCH net-next 2/7] net: stmmac: introduce dma_recycle_rx_skbufs for stmmac_reinit_rx_buffers
Date:   Mon, 12 Apr 2021 23:41:25 +0800
Message-Id: <20210412154130.20742-3-boon.leong.ong@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210412154130.20742-1-boon.leong.ong@intel.com>
References: <20210412154130.20742-1-boon.leong.ong@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rearrange RX buffer page_pool recycling logics into dma_recycle_rx_skbufs,
so that we prepare stmmac_reinit_rx_buffers() for XSK pool expansion.

Signed-off-by: Ong Boon Leong <boon.leong.ong@intel.com>
---
 .../net/ethernet/stmicro/stmmac/stmmac_main.c | 44 ++++++++++++-------
 1 file changed, 27 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index f6d3d26ce45a..a6c3414fd231 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -1512,6 +1512,31 @@ static int stmmac_alloc_rx_buffers(struct stmmac_priv *priv, u32 queue,
 	return 0;
 }
 
+/**
+ * dma_recycle_rx_skbufs - recycle RX dma buffers
+ * @priv: private structure
+ * @queue: RX queue index
+ */
+static void dma_recycle_rx_skbufs(struct stmmac_priv *priv, u32 queue)
+{
+	struct stmmac_rx_queue *rx_q = &priv->rx_queue[queue];
+	int i;
+
+	for (i = 0; i < priv->dma_rx_size; i++) {
+		struct stmmac_rx_buffer *buf = &rx_q->buf_pool[i];
+
+		if (buf->page) {
+			page_pool_recycle_direct(rx_q->page_pool, buf->page);
+			buf->page = NULL;
+		}
+
+		if (priv->sph && buf->sec_page) {
+			page_pool_recycle_direct(rx_q->page_pool, buf->sec_page);
+			buf->sec_page = NULL;
+		}
+	}
+}
+
 /**
  * stmmac_reinit_rx_buffers - reinit the RX descriptor buffer.
  * @priv: driver private structure
@@ -1524,23 +1549,8 @@ static void stmmac_reinit_rx_buffers(struct stmmac_priv *priv)
 	u32 queue;
 	int i;
 
-	for (queue = 0; queue < rx_count; queue++) {
-		struct stmmac_rx_queue *rx_q = &priv->rx_queue[queue];
-
-		for (i = 0; i < priv->dma_rx_size; i++) {
-			struct stmmac_rx_buffer *buf = &rx_q->buf_pool[i];
-
-			if (buf->page) {
-				page_pool_recycle_direct(rx_q->page_pool, buf->page);
-				buf->page = NULL;
-			}
-
-			if (priv->sph && buf->sec_page) {
-				page_pool_recycle_direct(rx_q->page_pool, buf->sec_page);
-				buf->sec_page = NULL;
-			}
-		}
-	}
+	for (queue = 0; queue < rx_count; queue++)
+		dma_recycle_rx_skbufs(priv, queue);
 
 	for (queue = 0; queue < rx_count; queue++) {
 		struct stmmac_rx_queue *rx_q = &priv->rx_queue[queue];
-- 
2.25.1

