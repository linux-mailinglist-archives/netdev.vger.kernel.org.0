Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B797CF68DA
	for <lists+netdev@lfdr.de>; Sun, 10 Nov 2019 13:09:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726800AbfKJMJv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Nov 2019 07:09:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:51350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726438AbfKJMJu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 10 Nov 2019 07:09:50 -0500
Received: from localhost.localdomain (unknown [77.139.212.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7A7C920B7C;
        Sun, 10 Nov 2019 12:09:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573387790;
        bh=jDaPaVHqvBmFCZggvccVVlywRpbYL0oLVSi1IBCj3Qc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l2WVmWEHHhwFOe29vrJXWjq/xZMTWkCpkuQ3ZOIwdiiMfPviLtqkMl73ziKGmsZoo
         jykFzWaWnlHZuCijA0DvHdJlqqJ/bizwuxPnxx7pNWzEBRubXt3KrQ79c2kcok9MXn
         Ge+Plp/lID2BfrBYwXCMRfvrk/HiiGqRuM/7tdoU=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net,
        thomas.petazzoni@bootlin.com, brouer@redhat.com,
        ilias.apalodimas@linaro.org, matteo.croce@redhat.com
Subject: [PATCH net-next 3/3] net: mvneta: get rid of huge DMA sync in mvneta_rx_refill
Date:   Sun, 10 Nov 2019 14:09:10 +0200
Message-Id: <b18159e702ec28bb33c492da216a12eaf3e7490c.1573383212.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <cover.1573383212.git.lorenzo@kernel.org>
References: <cover.1573383212.git.lorenzo@kernel.org>
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
 drivers/net/ethernet/marvell/mvneta.c | 25 +++++++++++++++----------
 1 file changed, 15 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index ed93eecb7485..591d580c68b4 100644
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
@@ -3072,6 +3074,9 @@ static int mvneta_create_page_pool(struct mvneta_port *pp,
 		.nid = cpu_to_node(0),
 		.dev = pp->dev->dev.parent,
 		.dma_dir = xdp_prog ? DMA_BIDIRECTIONAL : DMA_FROM_DEVICE,
+		.offset = pp->rx_offset_correction,
+		.max_len = MVNETA_MAX_RX_BUF_SIZE,
+		.sync = 1,
 	};
 	int err;
 
-- 
2.21.0

