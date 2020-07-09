Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2D2521A432
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 17:57:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728257AbgGIP5w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 11:57:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:50688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728252AbgGIP5u (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Jul 2020 11:57:50 -0400
Received: from localhost.localdomain.com (unknown [151.48.133.17])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 149E0207F9;
        Thu,  9 Jul 2020 15:57:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594310269;
        bh=YDV7+lwTcw8FgYmjUz8GR7fPQnPlVidfwubRzUe8l1w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DzW+Wg5rSFBWjmn+UTZZYsABQEVH0jCF8Hl/9cNMaEuo8lDcN2PppmDWPEONPmeSv
         Nx57FLW/4SZg9SzP6XpOdTusq+iqUy/9gstZHhSDqYx3Is9JuLowjvtOXK3dQuqpxU
         aQo3LYKQq+sJH7TjSIBT7rrzFnLQ7R82PcQ+cibA=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, bpf@vger.kernel.org, kuba@kernel.org,
        ilias.apalodimas@linaro.org, lorenzo.bianconi@redhat.com,
        brouer@redhat.com, echaudro@redhat.com, sameehj@amazon.com
Subject: [PATCH 6/6] net: mvneta: move rxq->left_size on the stack
Date:   Thu,  9 Jul 2020 17:57:23 +0200
Message-Id: <df31ad5ec1eeead08fbfd475abc32461c9bb08f0.1594309075.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1594309075.git.lorenzo@kernel.org>
References: <cover.1594309075.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Allocate rxq->left_size on mvneta_rx_swbm stack since it is used just
in sw bm napi_poll

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/marvell/mvneta.c | 29 ++++++++++++---------------
 1 file changed, 13 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index 1a0f34a9c01e..bf98db56cd88 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -698,8 +698,6 @@ struct mvneta_rx_queue {
 	/* Index of first RX DMA descriptor to refill */
 	int first_to_refill;
 	u32 refill_num;
-
-	int left_size;
 };
 
 static enum cpuhp_state online_hpstate;
@@ -2229,7 +2227,7 @@ static void
 mvneta_swbm_rx_frame(struct mvneta_port *pp,
 		     struct mvneta_rx_desc *rx_desc,
 		     struct mvneta_rx_queue *rxq,
-		     struct xdp_buff *xdp,
+		     struct xdp_buff *xdp, int *size,
 		     struct page *page,
 		     struct mvneta_stats *stats)
 {
@@ -2263,7 +2261,7 @@ mvneta_swbm_rx_frame(struct mvneta_port *pp,
 	sinfo = xdp_get_shared_info_from_buff(xdp);
 	sinfo->nr_frags = 0;
 
-	rxq->left_size = rx_desc->data_size - len;
+	*size = rx_desc->data_size - len;
 	rx_desc->buf_phys_addr = 0;
 }
 
@@ -2271,7 +2269,7 @@ static void
 mvneta_swbm_add_rx_fragment(struct mvneta_port *pp,
 			    struct mvneta_rx_desc *rx_desc,
 			    struct mvneta_rx_queue *rxq,
-			    struct xdp_buff *xdp,
+			    struct xdp_buff *xdp, int *size,
 			    struct page *page)
 {
 	struct skb_shared_info *sinfo = xdp_get_shared_info_from_buff(xdp);
@@ -2279,11 +2277,11 @@ mvneta_swbm_add_rx_fragment(struct mvneta_port *pp,
 	enum dma_data_direction dma_dir;
 	int data_len, len;
 
-	if (rxq->left_size > MVNETA_MAX_RX_BUF_SIZE) {
+	if (*size > MVNETA_MAX_RX_BUF_SIZE) {
 		len = MVNETA_MAX_RX_BUF_SIZE;
 		data_len = len;
 	} else {
-		len = rxq->left_size;
+		len = *size;
 		data_len = len - ETH_FCS_LEN;
 	}
 	dma_dir = page_pool_get_dma_dir(rxq->page_pool);
@@ -2301,7 +2299,7 @@ mvneta_swbm_add_rx_fragment(struct mvneta_port *pp,
 
 		rx_desc->buf_phys_addr = 0;
 	}
-	rxq->left_size -= len;
+	*size -= len;
 }
 
 static struct sk_buff *
@@ -2340,7 +2338,7 @@ static int mvneta_rx_swbm(struct napi_struct *napi,
 			  struct mvneta_port *pp, int budget,
 			  struct mvneta_rx_queue *rxq)
 {
-	int rx_proc = 0, rx_todo, refill;
+	int rx_proc = 0, rx_todo, refill, size = 0;
 	struct net_device *dev = pp->dev;
 	struct xdp_buff xdp_buf = {
 		.frame_sz = PAGE_SIZE,
@@ -2377,25 +2375,25 @@ static int mvneta_rx_swbm(struct napi_struct *napi,
 				goto next;
 			}
 
-			frame_sz = rx_desc->data_size - ETH_FCS_LEN;
+			size = rx_desc->data_size;
+			frame_sz = size - ETH_FCS_LEN;
 			desc_status = rx_desc->status;
 
-			mvneta_swbm_rx_frame(pp, rx_desc, rxq, &xdp_buf, page,
-					     &ps);
+			mvneta_swbm_rx_frame(pp, rx_desc, rxq, &xdp_buf,
+					     &size, page, &ps);
 		} else {
 			if (unlikely(!xdp_buf.data_hard_start))
 				continue;
 
 			mvneta_swbm_add_rx_fragment(pp, rx_desc, rxq, &xdp_buf,
-						    page);
+						    &size, page);
 		} /* Middle or Last descriptor */
 
 		if (!(rx_status & MVNETA_RXD_LAST_DESC))
 			/* no last descriptor this time */
 			continue;
 
-		if (rxq->left_size) {
-			rxq->left_size = 0;
+		if (size) {
 			mvneta_xdp_put_buff(pp, rxq, &xdp_buf, -1, true);
 			goto next;
 		}
@@ -3371,7 +3369,6 @@ static void mvneta_rxq_deinit(struct mvneta_port *pp,
 	rxq->descs_phys        = 0;
 	rxq->first_to_refill   = 0;
 	rxq->refill_num        = 0;
-	rxq->left_size         = 0;
 }
 
 static int mvneta_txq_sw_init(struct mvneta_port *pp,
-- 
2.26.2

