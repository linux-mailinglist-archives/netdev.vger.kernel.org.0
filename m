Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F37FFE558
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 20:02:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726953AbfKOTCU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Nov 2019 14:02:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:52404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726323AbfKOTCU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 Nov 2019 14:02:20 -0500
Received: from localhost.localdomain.com (unknown [77.139.212.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 90D1E20732;
        Fri, 15 Nov 2019 19:02:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573844539;
        bh=tL3P3NllXbEjBAgMEpB5lSiaZCbNyPK98J/s+flQSOQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KFhMoYHriy616sCdxr7oSN66clojNirFsE4kO9Zb/MF/v/KfyXW8Y5U0f0WKSGMO5
         jMiMS3GWXFEicPqhWGu+hLqlD8h3ZtpDH4iessC/Q7cj2/+Ul6wwkpqd0TWJ1HLRzG
         cPYGJwa+Z0ktRll2mMoibtANK5cjQMiYic3Kv/i0=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, ilias.apalodimas@linaro.org,
        brouer@redhat.com, lorenzo.bianconi@redhat.com, mcroce@redhat.com
Subject: [PATCH v3 net-next 3/3] net: mvneta: get rid of huge dma sync in mvneta_rx_refill
Date:   Fri, 15 Nov 2019 21:01:39 +0200
Message-Id: <07bf40cd4677af47f53a949323bed778ee950c1b.1573844190.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <cover.1573844190.git.lorenzo@kernel.org>
References: <cover.1573844190.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Get rid of costly dma_sync_single_for_device in mvneta_rx_refill
since now the driver can let page_pool API to manage needed DMA
sync with a proper size.

- XDP_DROP DMA sync managed by mvneta driver:	~420Kpps
- XDP_DROP DMA sync managed by page_pool API:	~595Kpps

Tested-by: Matteo Croce <mcroce@redhat.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/marvell/mvneta.c | 26 +++++++++++++++-----------
 1 file changed, 15 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index f7713c2c68e1..a06d109c9e80 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -1846,7 +1846,6 @@ static int mvneta_rx_refill(struct mvneta_port *pp,
 			    struct mvneta_rx_queue *rxq,
 			    gfp_t gfp_mask)
 {
-	enum dma_data_direction dma_dir;
 	dma_addr_t phys_addr;
 	struct page *page;
 
@@ -1856,9 +1855,6 @@ static int mvneta_rx_refill(struct mvneta_port *pp,
 		return -ENOMEM;
 
 	phys_addr = page_pool_get_dma_addr(page) + pp->rx_offset_correction;
-	dma_dir = page_pool_get_dma_dir(rxq->page_pool);
-	dma_sync_single_for_device(pp->dev->dev.parent, phys_addr,
-				   MVNETA_MAX_RX_BUF_SIZE, dma_dir);
 	mvneta_rx_desc_fill(rx_desc, phys_addr, page, rxq);
 
 	return 0;
@@ -2097,8 +2093,10 @@ mvneta_run_xdp(struct mvneta_port *pp, struct mvneta_rx_queue *rxq,
 		err = xdp_do_redirect(pp->dev, xdp, prog);
 		if (err) {
 			ret = MVNETA_XDP_DROPPED;
-			page_pool_recycle_direct(rxq->page_pool,
-						 virt_to_head_page(xdp->data));
+			__page_pool_put_page(rxq->page_pool,
+					virt_to_head_page(xdp->data),
+					xdp->data_end - xdp->data_hard_start,
+					true);
 		} else {
 			ret = MVNETA_XDP_REDIR;
 		}
@@ -2107,8 +2105,10 @@ mvneta_run_xdp(struct mvneta_port *pp, struct mvneta_rx_queue *rxq,
 	case XDP_TX:
 		ret = mvneta_xdp_xmit_back(pp, xdp);
 		if (ret != MVNETA_XDP_TX)
-			page_pool_recycle_direct(rxq->page_pool,
-						 virt_to_head_page(xdp->data));
+			__page_pool_put_page(rxq->page_pool,
+					virt_to_head_page(xdp->data),
+					xdp->data_end - xdp->data_hard_start,
+					true);
 		break;
 	default:
 		bpf_warn_invalid_xdp_action(act);
@@ -2117,8 +2117,10 @@ mvneta_run_xdp(struct mvneta_port *pp, struct mvneta_rx_queue *rxq,
 		trace_xdp_exception(pp->dev, prog, act);
 		/* fall through */
 	case XDP_DROP:
-		page_pool_recycle_direct(rxq->page_pool,
-					 virt_to_head_page(xdp->data));
+		__page_pool_put_page(rxq->page_pool,
+				     virt_to_head_page(xdp->data),
+				     xdp->data_end - xdp->data_hard_start,
+				     true);
 		ret = MVNETA_XDP_DROPPED;
 		break;
 	}
@@ -3067,11 +3069,13 @@ static int mvneta_create_page_pool(struct mvneta_port *pp,
 	struct bpf_prog *xdp_prog = READ_ONCE(pp->xdp_prog);
 	struct page_pool_params pp_params = {
 		.order = 0,
-		.flags = PP_FLAG_DMA_MAP,
+		.flags = PP_FLAG_DMA_MAP | PP_FLAG_DMA_SYNC_DEV,
 		.pool_size = size,
 		.nid = cpu_to_node(0),
 		.dev = pp->dev->dev.parent,
 		.dma_dir = xdp_prog ? DMA_BIDIRECTIONAL : DMA_FROM_DEVICE,
+		.offset = pp->rx_offset_correction,
+		.max_len = MVNETA_MAX_RX_BUF_SIZE,
 	};
 	int err;
 
-- 
2.21.0

