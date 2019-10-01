Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89914C3D77
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 19:00:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732604AbfJAQ76 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 12:59:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:52536 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730545AbfJAQlF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Oct 2019 12:41:05 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8FECF2168B;
        Tue,  1 Oct 2019 16:41:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569948064;
        bh=lg4NZhD6aEiaPEorh6MHcLCVlbXhvN9IA9cMZA+xJcI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W5W2Jz99PPkHkl2IGDR0cf/R/2mwrc+Q9IIbfQ6SI0KDuLJBoz2VjYLWO0fUkSvzb
         a5p5F7ODZAZ4MVAqFzhBov+MPiOsceOdvncLcYDOHmkGZVZ7rUEJxPvNq46dMfvzEz
         6mbezP+KGxtSyBlbxxX/Bwk02fE3K25YCBV3i5EA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Thierry Reding <treding@nvidia.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.3 61/71] net: stmmac: Fix page pool size
Date:   Tue,  1 Oct 2019 12:39:11 -0400
Message-Id: <20191001163922.14735-61-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191001163922.14735-1-sashal@kernel.org>
References: <20191001163922.14735-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

[ Upstream commit 4f28bd956e081fc018fe9b41ffa31573f17bfb61 ]

The size of individual pages in the page pool in given by an order. The
order is the binary logarithm of the number of pages that make up one of
the pages in the pool. However, the driver currently passes the number
of pages rather than the order, so it ends up wasting quite a bit of
memory.

Fix this by taking the binary logarithm and passing that in the order
field.

Fixes: 2af6106ae949 ("net: stmmac: Introducing support for Page Pool")
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index b19ab09cb18f7..5c4408bdc843a 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -1532,13 +1532,15 @@ static int alloc_dma_rx_desc_resources(struct stmmac_priv *priv)
 	for (queue = 0; queue < rx_count; queue++) {
 		struct stmmac_rx_queue *rx_q = &priv->rx_queue[queue];
 		struct page_pool_params pp_params = { 0 };
+		unsigned int num_pages;
 
 		rx_q->queue_index = queue;
 		rx_q->priv_data = priv;
 
 		pp_params.flags = PP_FLAG_DMA_MAP;
 		pp_params.pool_size = DMA_RX_SIZE;
-		pp_params.order = DIV_ROUND_UP(priv->dma_buf_sz, PAGE_SIZE);
+		num_pages = DIV_ROUND_UP(priv->dma_buf_sz, PAGE_SIZE);
+		pp_params.order = ilog2(num_pages);
 		pp_params.nid = dev_to_node(priv->device);
 		pp_params.dev = priv->device;
 		pp_params.dma_dir = DMA_FROM_DEVICE;
-- 
2.20.1

