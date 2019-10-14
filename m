Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3D2ED6091
	for <lists+netdev@lfdr.de>; Mon, 14 Oct 2019 12:50:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731699AbfJNKuo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Oct 2019 06:50:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:58120 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731449AbfJNKun (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Oct 2019 06:50:43 -0400
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com [149.6.153.186])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 89B20214AE;
        Mon, 14 Oct 2019 10:50:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571050243;
        bh=B+wzdxHGBKQZypJwuUNSsX+DgdjyG6GaAeubBfA6Ym8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rxxJBIGMtL2TTpm0JiqgpZ/+iA9B1Biq4NitVboc2IWgyrnLr88S6ZIR7t8MHS6Mz
         FOpnKkNRuEeJRHSwiCOe3QJ6uUB/TnuDsr7BoUWW9Ki2HoG2tMngNbKaeQHWhRHdf5
         ++l49cin3Tlq2i9DisbzwumBJsOW2TzXHfWgaBX8=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net,
        thomas.petazzoni@bootlin.com, brouer@redhat.com,
        ilias.apalodimas@linaro.org, matteo.croce@redhat.com,
        mw@semihalf.com
Subject: [PATCH v3 net-next 4/8] net: mvneta: sync dma buffers before refilling hw queues
Date:   Mon, 14 Oct 2019 12:49:51 +0200
Message-Id: <e458e8e4e1d9aa936d64346ca02e432b3b0b7b34.1571049326.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <cover.1571049326.git.lorenzo@kernel.org>
References: <cover.1571049326.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

mvneta driver can run on not cache coherent devices so it is
necessary to sync DMA buffers before sending them to the device
in order to avoid memory corruptions. Running perf analysis we can
see a performance cost associated with this DMA-sync (anyway it is
already there in the original driver code). In follow up patches we
will add more logic to reduce DMA-sync as much as possible.

Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/marvell/mvneta.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index 77d4e8a48dd9..1722dffe265d 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -1821,6 +1821,7 @@ static int mvneta_rx_refill(struct mvneta_port *pp,
 			    struct mvneta_rx_queue *rxq,
 			    gfp_t gfp_mask)
 {
+	enum dma_data_direction dma_dir;
 	dma_addr_t phys_addr;
 	struct page *page;
 
@@ -1830,6 +1831,9 @@ static int mvneta_rx_refill(struct mvneta_port *pp,
 		return -ENOMEM;
 
 	phys_addr = page_pool_get_dma_addr(page) + pp->rx_offset_correction;
+	dma_dir = page_pool_get_dma_dir(rxq->page_pool);
+	dma_sync_single_for_device(pp->dev->dev.parent, phys_addr,
+				   MVNETA_MAX_RX_BUF_SIZE, dma_dir);
 	mvneta_rx_desc_fill(rx_desc, phys_addr, page, rxq);
 
 	return 0;
-- 
2.21.0

