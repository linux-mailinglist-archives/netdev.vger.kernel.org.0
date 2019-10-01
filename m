Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47342C3022
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 11:25:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729719AbfJAJZG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 05:25:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:49226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729245AbfJAJZF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Oct 2019 05:25:05 -0400
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com [149.6.153.186])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BD56B2133F;
        Tue,  1 Oct 2019 09:25:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569921904;
        bh=fkUDzkRcTof4Rgn8uzB0cJ4aPeylYDU+on9ps+33+Dw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1jWUGEsucjbODxnnYJwiY5dB+gPkAfuspTCZFOWNwxZLiP1NQow6/sbHAU2Zft/BD
         O14HfRyDsnXzTSHZHluvKFdJOGRvvxe6eJPw8gsf5l+4OWO6slmhSHaDlRH3ykyb/L
         S8PIBxGRGof2242vSK94GgEt0qxPUyfQK8ngRmf0=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     thomas.petazzoni@bootlin.com, ilias.apalodimas@linaro.org,
        brouer@redhat.com, mcroce@redhat.com
Subject: [RFC 4/4] net: mvneta: move header prefetch in mvneta_swbm_rx_frame
Date:   Tue,  1 Oct 2019 11:24:44 +0200
Message-Id: <d6209a5b09e1ba70a833391c32cbe5916177033e.1569920973.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <cover.1569920973.git.lorenzo@kernel.org>
References: <cover.1569920973.git.lorenzo@kernel.org>
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
index f2d12556efa8..e7ce08fe4ab1 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -1979,11 +1979,8 @@ mvneta_swbm_rx_frame(struct mvneta_port *pp,
 	struct net_device *dev = pp->dev;
 	enum dma_data_direction dma_dir;
 	struct xdp_buff xdp = {
-		.data_hard_start = data,
-		.data = data + MVNETA_SKB_HEADROOM,
 		.rxq = &rxq->xdp_rxq,
 	};
-	xdp_set_data_meta_invalid(&xdp);
 
 	if (MVNETA_SKB_SIZE(rx_desc->data_size) > PAGE_SIZE) {
 		len = MVNETA_MAX_RX_BUF_SIZE;
@@ -1992,13 +1989,20 @@ mvneta_swbm_rx_frame(struct mvneta_port *pp,
 		len = rx_desc->data_size;
 		data_len += (len - ETH_FCS_LEN);
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
+	xdp.data = data + MVNETA_SKB_HEADROOM;
+	xdp.data_end = xdp.data + data_len;
+	xdp_set_data_meta_invalid(&xdp);
+
 	if (xdp_prog) {
 		int ret;
 
@@ -2083,15 +2087,11 @@ static int mvneta_rx_swbm(struct napi_struct *napi,
 	/* Fairness NAPI loop */
 	while (rcvd_pkts < budget && rx_proc < rx_todo) {
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
 		rcvd_pkts++;
-- 
2.21.0

