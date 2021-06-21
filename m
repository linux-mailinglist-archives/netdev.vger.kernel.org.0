Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D67433AF3A3
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 20:01:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233117AbhFUSCh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 14:02:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:45832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233684AbhFUSAe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Jun 2021 14:00:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3B317611C1;
        Mon, 21 Jun 2021 17:54:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624298085;
        bh=sEMjuJyeiH7mC1MERJDZIj1DEzlkMXOzy00kRSLaBtA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nxyiOreJVa0WZI9zBQbmXl/ptUBuK5ordT6s/Fr0HL877zg8HfGhC8LLsD3wZToQA
         wNsftsRcuQ2qnRW4eVfUMbL7Q7bV/bDbAOoJqYHYaGZJC7zQr+pGQpLGh1uBVIYuFf
         PRyMopiBjs5TtT/QHCWkgQF9gPRUZClh96rl1OCs6CExw+bn2YZskCliBgjDlCAgrq
         /nQ8gkZcbrlVW4zqx0xtTu8JqRn4g/GFYyoBNyxaji3TJbiywA1Z0gw0BdILU+Oh6S
         HHbAxjVXz3kLlr1VHd48X5gjnsdz7kLj6wJq3loPXyIoqrP2Q4Vv/lMzL+3qrtnAbu
         9yFDDbqgOSnrA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Esben Haabendal <esben@geanix.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 25/26] net: ll_temac: Add memory-barriers for TX BD access
Date:   Mon, 21 Jun 2021 13:53:58 -0400
Message-Id: <20210621175400.735800-25-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210621175400.735800-1-sashal@kernel.org>
References: <20210621175400.735800-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Esben Haabendal <esben@geanix.com>

[ Upstream commit 28d9fab458b16bcd83f9dd07ede3d585c3e1a69e ]

Add a couple of memory-barriers to ensure correct ordering of read/write
access to TX BDs.

In xmit_done, we should ensure that reading the additional BD fields are
only done after STS_CTRL_APP0_CMPLT bit is set.

When xmit_done marks the BD as free by setting APP0=0, we need to ensure
that the other BD fields are reset first, so we avoid racing with the xmit
path, which writes to the same fields.

Finally, making sure to read APP0 of next BD after the current BD, ensures
that we see all available buffers.

Signed-off-by: Esben Haabendal <esben@geanix.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/xilinx/ll_temac_main.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/xilinx/ll_temac_main.c b/drivers/net/ethernet/xilinx/ll_temac_main.c
index 5b8451c58aa4..63aabe051332 100644
--- a/drivers/net/ethernet/xilinx/ll_temac_main.c
+++ b/drivers/net/ethernet/xilinx/ll_temac_main.c
@@ -770,12 +770,15 @@ static void temac_start_xmit_done(struct net_device *ndev)
 	stat = be32_to_cpu(cur_p->app0);
 
 	while (stat & STS_CTRL_APP0_CMPLT) {
+		/* Make sure that the other fields are read after bd is
+		 * released by dma
+		 */
+		rmb();
 		dma_unmap_single(ndev->dev.parent, be32_to_cpu(cur_p->phys),
 				 be32_to_cpu(cur_p->len), DMA_TO_DEVICE);
 		skb = (struct sk_buff *)ptr_from_txbd(cur_p);
 		if (skb)
 			dev_consume_skb_irq(skb);
-		cur_p->app0 = 0;
 		cur_p->app1 = 0;
 		cur_p->app2 = 0;
 		cur_p->app3 = 0;
@@ -784,6 +787,12 @@ static void temac_start_xmit_done(struct net_device *ndev)
 		ndev->stats.tx_packets++;
 		ndev->stats.tx_bytes += be32_to_cpu(cur_p->len);
 
+		/* app0 must be visible last, as it is used to flag
+		 * availability of the bd
+		 */
+		smp_mb();
+		cur_p->app0 = 0;
+
 		lp->tx_bd_ci++;
 		if (lp->tx_bd_ci >= TX_BD_NUM)
 			lp->tx_bd_ci = 0;
@@ -810,6 +819,9 @@ static inline int temac_check_tx_bd_space(struct temac_local *lp, int num_frag)
 		if (cur_p->app0)
 			return NETDEV_TX_BUSY;
 
+		/* Make sure to read next bd app0 after this one */
+		rmb();
+
 		tail++;
 		if (tail >= TX_BD_NUM)
 			tail = 0;
-- 
2.30.2

