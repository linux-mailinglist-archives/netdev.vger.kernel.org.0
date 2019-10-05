Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A294CCCBD
	for <lists+netdev@lfdr.de>; Sat,  5 Oct 2019 22:45:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726066AbfJEUpn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Oct 2019 16:45:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:34154 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725789AbfJEUpn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 5 Oct 2019 16:45:43 -0400
Received: from lore-desk.lan (unknown [151.66.37.67])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3A321222C8;
        Sat,  5 Oct 2019 20:45:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570308342;
        bh=5i+d0dkw/9StI6IZ6FNFze/ui5p0q7boovC9cQoAB7Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KmzjY6++XAo1CEL9bXpTplGs2ayA4xWk+6cbS7mv9flKMq5r7V5ohXuFHOP5/N4QX
         8kwEJmCoe0lxQsS8TSEBW2uL66O7E/JdAUkxAyDnMS++XF2Y+ccqzmJk4+0DhhHlVQ
         gToLafNc2Pqz6nd8f4XvV5ObF8xY5o6tvN2eaX2w=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, thomas.petazzoni@bootlin.com,
        ilias.apalodimas@linaro.org, brouer@redhat.com,
        lorenzo.bianconi@redhat.com, matteo.croce@redhat.com
Subject: [PATCH 5/7] net: mvneta: move header prefetch in mvneta_swbm_rx_frame
Date:   Sat,  5 Oct 2019 22:44:38 +0200
Message-Id: <2c38a268b3edd0370fae4df331aae0504dbec9da.1570307172.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <cover.1570307172.git.lorenzo@kernel.org>
References: <cover.1570307172.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move data buffer prefetch in mvneta_swbm_rx_frame after
dma_sync_single_range_for_cpu

Tested-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
Signed-off-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/marvell/mvneta.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index 7cbcf1b54da6..45dcae52f34b 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -2004,11 +2004,8 @@ mvneta_swbm_rx_frame(struct mvneta_port *pp,
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
@@ -2017,13 +2014,20 @@ mvneta_swbm_rx_frame(struct mvneta_port *pp,
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
 
@@ -2114,15 +2118,11 @@ static int mvneta_rx_swbm(struct napi_struct *napi,
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

