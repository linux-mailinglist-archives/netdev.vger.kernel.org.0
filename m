Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BDA0CF66B1
	for <lists+netdev@lfdr.de>; Sun, 10 Nov 2019 04:15:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728715AbfKJDPC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Nov 2019 22:15:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:37018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727675AbfKJCl7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 Nov 2019 21:41:59 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 654AC21D7B;
        Sun, 10 Nov 2019 02:41:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573353718;
        bh=8a5AlZCsb1Xf90Q9T0DttIH8Ll4wN+BtclWVVTiNXeg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T4xIv7nSR64xVwUiIoMylWqpK5uwqGMH810pmuJYHsgGkkiAGr2mE6PC+mytTMvPm
         qKBW8HuXyCimNjIASNTAHWg8om1o4P1R3p0SIa9+CqEbwMqrGHYWdRhFk0vM872d6E
         VCPp69jg38wq2eTY+DE1cEKnlW/Uyd4b+bpO3pmc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Dirk van der Merwe <dirk.vandermerwe@netronome.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, oss-drivers@netronome.com,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 051/191] nfp: provide a better warning when ring allocation fails
Date:   Sat,  9 Nov 2019 21:37:53 -0500
Message-Id: <20191110024013.29782-51-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191110024013.29782-1-sashal@kernel.org>
References: <20191110024013.29782-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <jakub.kicinski@netronome.com>

[ Upstream commit 23d9f5531c7c28546954b0bf332134a9b8a38c0a ]

NFP supports fairly enormous ring sizes (up to 256k descriptors).
In commit 466271703867 ("nfp: use kvcalloc() to allocate SW buffer
descriptor arrays") we have started using kvcalloc() functions to
make sure the allocation of software state arrays doesn't hit
the MAX_ORDER limit.  Unfortunately, we can't use virtual mappings
for the DMA region holding HW descriptors.  In case this allocation
fails instead of the generic (and fairly scary) warning/splat in
the logs print a helpful message explaining what happened and
suggesting how to fix it.

Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: Dirk van der Merwe <dirk.vandermerwe@netronome.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/netronome/nfp/nfp_net_common.c  | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
index c6d29fdbb880f..d288c7eebacd8 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
@@ -2187,9 +2187,13 @@ nfp_net_tx_ring_alloc(struct nfp_net_dp *dp, struct nfp_net_tx_ring *tx_ring)
 
 	tx_ring->size = array_size(tx_ring->cnt, sizeof(*tx_ring->txds));
 	tx_ring->txds = dma_zalloc_coherent(dp->dev, tx_ring->size,
-					    &tx_ring->dma, GFP_KERNEL);
-	if (!tx_ring->txds)
+					    &tx_ring->dma,
+					    GFP_KERNEL | __GFP_NOWARN);
+	if (!tx_ring->txds) {
+		netdev_warn(dp->netdev, "failed to allocate TX descriptor ring memory, requested descriptor count: %d, consider lowering descriptor count\n",
+			    tx_ring->cnt);
 		goto err_alloc;
+	}
 
 	tx_ring->txbufs = kvcalloc(tx_ring->cnt, sizeof(*tx_ring->txbufs),
 				   GFP_KERNEL);
@@ -2341,9 +2345,13 @@ nfp_net_rx_ring_alloc(struct nfp_net_dp *dp, struct nfp_net_rx_ring *rx_ring)
 	rx_ring->cnt = dp->rxd_cnt;
 	rx_ring->size = array_size(rx_ring->cnt, sizeof(*rx_ring->rxds));
 	rx_ring->rxds = dma_zalloc_coherent(dp->dev, rx_ring->size,
-					    &rx_ring->dma, GFP_KERNEL);
-	if (!rx_ring->rxds)
+					    &rx_ring->dma,
+					    GFP_KERNEL | __GFP_NOWARN);
+	if (!rx_ring->rxds) {
+		netdev_warn(dp->netdev, "failed to allocate RX descriptor ring memory, requested descriptor count: %d, consider lowering descriptor count\n",
+			    rx_ring->cnt);
 		goto err_alloc;
+	}
 
 	rx_ring->rxbufs = kvcalloc(rx_ring->cnt, sizeof(*rx_ring->rxbufs),
 				   GFP_KERNEL);
-- 
2.20.1

