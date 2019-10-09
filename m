Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A614BD1CA8
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 01:19:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732524AbfJIXTR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 19:19:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:37028 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732483AbfJIXTN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Oct 2019 19:19:13 -0400
Received: from localhost.localdomain (unknown [151.66.37.67])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 69DAF21929;
        Wed,  9 Oct 2019 23:19:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570663153;
        bh=S1LhbpV16ZnX952Qwc5a9L7X3jghZgy1Yjs2LoAPoJ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vtOXMZDGVi4TWiH8r66TosVTL9z0tyTikB8yWeBM1WGSv8izgyKCEKy+XLVsP1/59
         KpQsXo+d+6ffZ8uYOIVzif2UO14YNr/EsIP5b/qWo9ifXv4objzH3XC8GMbsan11/D
         rtdEdpPi+F0269hwbMrTIVpQ5bRXVfDuIraAZWNA=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net,
        thomas.petazzoni@bootlin.com, brouer@redhat.com,
        ilias.apalodimas@linaro.org, matteo.croce@redhat.com,
        mw@semihalf.com
Subject: [PATCH v2 net-next 6/8] net: mvneta: move header prefetch in mvneta_swbm_rx_frame
Date:   Thu, 10 Oct 2019 01:18:36 +0200
Message-Id: <eb0cdfc9f5f3e61e38e303f908abd7beb57360e4.1570662004.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <cover.1570662004.git.lorenzo@kernel.org>
References: <cover.1570662004.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move data buffer prefetch in mvneta_swbm_rx_frame after
dma_sync_single_range_for_cpu

Signed-off-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/marvell/mvneta.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index e2795dddbcaf..91d8cb45104f 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -2009,11 +2009,8 @@ mvneta_swbm_rx_frame(struct mvneta_port *pp,
 	struct net_device *dev = pp->dev;
 	enum dma_data_direction dma_dir;
 	struct xdp_buff xdp = {
-		.data_hard_start = data,
-		.data = data + MVNETA_SKB_HEADROOM + MVNETA_MH_SIZE,
 		.rxq = &rxq->xdp_rxq,
 	};
-	xdp_set_data_meta_invalid(&xdp);
 
 	if (MVNETA_SKB_SIZE(rx_desc->data_size) > PAGE_SIZE) {
 		len = MVNETA_MAX_RX_BUF_SIZE;
@@ -2022,13 +2019,20 @@ mvneta_swbm_rx_frame(struct mvneta_port *pp,
 		len = rx_desc->data_size;
 		data_len += len - ETH_FCS_LEN;
 	}
-	xdp.data_end = xdp.data + data_len;
 
 	dma_dir = page_pool_get_dma_dir(rxq->page_pool);
 	dma_sync_single_range_for_cpu(dev->dev.parent,
 				      rx_desc->buf_phys_addr, 0,
 				      len, dma_dir);
 
+	/* Prefetch header */
+	prefetch(data);
+
+	xdp.data_hard_start = data;
+	xdp.data = data + MVNETA_SKB_HEADROOM + MVNETA_MH_SIZE;
+	xdp.data_end = xdp.data + data_len;
+	xdp_set_data_meta_invalid(&xdp);
+
 	if (xdp_prog) {
 		u32 ret;
 
@@ -2117,15 +2121,11 @@ static int mvneta_rx_swbm(struct napi_struct *napi,
 	/* Fairness NAPI loop */
 	while (done < budget && done < rx_pending) {
 		struct mvneta_rx_desc *rx_desc = mvneta_rxq_next_desc_get(rxq);
-		unsigned char *data;
 		struct page *page;
 		int index;
 
 		index = rx_desc - rxq->descs;
 		page = (struct page *)rxq->buf_virt_addr[index];
-		data = page_address(page);
-		/* Prefetch header */
-		prefetch(data);
 
 		rxq->refill_num++;
 		done++;
-- 
2.21.0

