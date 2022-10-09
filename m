Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1047B5F8FA8
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 00:11:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230115AbiJIWLm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Oct 2022 18:11:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230457AbiJIWLO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Oct 2022 18:11:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D6CE27FD7;
        Sun,  9 Oct 2022 15:09:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1E370B80D9A;
        Sun,  9 Oct 2022 22:09:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 717FCC433C1;
        Sun,  9 Oct 2022 22:09:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665353354;
        bh=R9mXsIyShsVWJOH9MSgqLniCVDqACxw0AMWjzPQJhRE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mYQ4D93Q6surmHfriW0qNuFosg5Iys1pOtw7ZNJMUvlIo5Oyih+kwY/CggXhao588
         x6UybxQzWj/EAVzqvnOL/9kTa21wiJ1BznL327Wv+G6HKoRui729W4L2wysa+nLAOL
         zAlff5D1cd/OW1GAXEf4+VtpDSINS8MH7UXn/8Ackp2GkXu29PJZ7fHZnhmfW8Je0u
         wb1N6YlJ4ICzoR9h8A8jIr/YK5gquCJpPbhpZc6KXr7YNuMqtlI+GNBUut1vQinFTb
         YhGOqSHfUNh7C+q/tXTg/MQ2vsd38zRUUiHZXfg+6yBNf60D6vrnUv7UBugCYW7UdL
         q4sc7VeLlU1tw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Robert Hancock <robert.hancock@calian.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        radhey.shyam.pandey@xilinx.com, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, michal.simek@xilinx.com,
        linux@armlinux.org.uk, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 6.0 23/77] net: axienet: Switch to 64-bit RX/TX statistics
Date:   Sun,  9 Oct 2022 18:07:00 -0400
Message-Id: <20221009220754.1214186-23-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221009220754.1214186-1-sashal@kernel.org>
References: <20221009220754.1214186-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Robert Hancock <robert.hancock@calian.com>

[ Upstream commit cb45a8bf4693965e89d115cd2c510f12bc127c37 ]

The RX and TX byte/packet statistics in this driver could be overflowed
relatively quickly on a 32-bit platform. Switch these stats to use the
u64_stats infrastructure to avoid this.

Signed-off-by: Robert Hancock <robert.hancock@calian.com>
Link: https://lore.kernel.org/r/20220829233901.3429419-1-robert.hancock@calian.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/xilinx/xilinx_axienet.h  | 12 ++++++
 .../net/ethernet/xilinx/xilinx_axienet_main.c | 37 +++++++++++++++++--
 2 files changed, 45 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet.h b/drivers/net/ethernet/xilinx/xilinx_axienet.h
index f2e2261b4b7d..8ff4333de2ad 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet.h
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet.h
@@ -402,6 +402,9 @@ struct axidma_bd {
  * @rx_bd_num:	Size of RX buffer descriptor ring
  * @rx_bd_ci:	Stores the index of the Rx buffer descriptor in the ring being
  *		accessed currently.
+ * @rx_packets: RX packet count for statistics
+ * @rx_bytes:	RX byte count for statistics
+ * @rx_stat_sync: Synchronization object for RX stats
  * @napi_tx:	NAPI TX control structure
  * @tx_dma_cr:  Nominal content of TX DMA control register
  * @tx_bd_v:	Virtual address of the TX buffer descriptor ring
@@ -411,6 +414,9 @@ struct axidma_bd {
  *		complete. Only updated at runtime by TX NAPI poll.
  * @tx_bd_tail:	Stores the index of the next Tx buffer descriptor in the ring
  *              to be populated.
+ * @tx_packets: TX packet count for statistics
+ * @tx_bytes:	TX byte count for statistics
+ * @tx_stat_sync: Synchronization object for TX stats
  * @dma_err_task: Work structure to process Axi DMA errors
  * @tx_irq:	Axidma TX IRQ number
  * @rx_irq:	Axidma RX IRQ number
@@ -458,6 +464,9 @@ struct axienet_local {
 	dma_addr_t rx_bd_p;
 	u32 rx_bd_num;
 	u32 rx_bd_ci;
+	u64_stats_t rx_packets;
+	u64_stats_t rx_bytes;
+	struct u64_stats_sync rx_stat_sync;
 
 	struct napi_struct napi_tx;
 	u32 tx_dma_cr;
@@ -466,6 +475,9 @@ struct axienet_local {
 	u32 tx_bd_num;
 	u32 tx_bd_ci;
 	u32 tx_bd_tail;
+	u64_stats_t tx_packets;
+	u64_stats_t tx_bytes;
+	struct u64_stats_sync tx_stat_sync;
 
 	struct work_struct dma_err_task;
 
diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index 1760930ec0c4..9262988d26a3 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -752,8 +752,10 @@ static int axienet_tx_poll(struct napi_struct *napi, int budget)
 		if (lp->tx_bd_ci >= lp->tx_bd_num)
 			lp->tx_bd_ci %= lp->tx_bd_num;
 
-		ndev->stats.tx_packets += packets;
-		ndev->stats.tx_bytes += size;
+		u64_stats_update_begin(&lp->tx_stat_sync);
+		u64_stats_add(&lp->tx_packets, packets);
+		u64_stats_add(&lp->tx_bytes, size);
+		u64_stats_update_end(&lp->tx_stat_sync);
 
 		/* Matches barrier in axienet_start_xmit */
 		smp_mb();
@@ -984,8 +986,10 @@ static int axienet_rx_poll(struct napi_struct *napi, int budget)
 		cur_p = &lp->rx_bd_v[lp->rx_bd_ci];
 	}
 
-	lp->ndev->stats.rx_packets += packets;
-	lp->ndev->stats.rx_bytes += size;
+	u64_stats_update_begin(&lp->rx_stat_sync);
+	u64_stats_add(&lp->rx_packets, packets);
+	u64_stats_add(&lp->rx_bytes, size);
+	u64_stats_update_end(&lp->rx_stat_sync);
 
 	if (tail_p)
 		axienet_dma_out_addr(lp, XAXIDMA_RX_TDESC_OFFSET, tail_p);
@@ -1292,10 +1296,32 @@ static int axienet_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
 	return phylink_mii_ioctl(lp->phylink, rq, cmd);
 }
 
+static void
+axienet_get_stats64(struct net_device *dev, struct rtnl_link_stats64 *stats)
+{
+	struct axienet_local *lp = netdev_priv(dev);
+	unsigned int start;
+
+	netdev_stats_to_stats64(stats, &dev->stats);
+
+	do {
+		start = u64_stats_fetch_begin_irq(&lp->rx_stat_sync);
+		stats->rx_packets = u64_stats_read(&lp->rx_packets);
+		stats->rx_bytes = u64_stats_read(&lp->rx_bytes);
+	} while (u64_stats_fetch_retry_irq(&lp->rx_stat_sync, start));
+
+	do {
+		start = u64_stats_fetch_begin_irq(&lp->tx_stat_sync);
+		stats->tx_packets = u64_stats_read(&lp->tx_packets);
+		stats->tx_bytes = u64_stats_read(&lp->tx_bytes);
+	} while (u64_stats_fetch_retry_irq(&lp->tx_stat_sync, start));
+}
+
 static const struct net_device_ops axienet_netdev_ops = {
 	.ndo_open = axienet_open,
 	.ndo_stop = axienet_stop,
 	.ndo_start_xmit = axienet_start_xmit,
+	.ndo_get_stats64 = axienet_get_stats64,
 	.ndo_change_mtu	= axienet_change_mtu,
 	.ndo_set_mac_address = netdev_set_mac_address,
 	.ndo_validate_addr = eth_validate_addr,
@@ -1850,6 +1876,9 @@ static int axienet_probe(struct platform_device *pdev)
 	lp->rx_bd_num = RX_BD_NUM_DEFAULT;
 	lp->tx_bd_num = TX_BD_NUM_DEFAULT;
 
+	u64_stats_init(&lp->rx_stat_sync);
+	u64_stats_init(&lp->tx_stat_sync);
+
 	netif_napi_add(ndev, &lp->napi_rx, axienet_rx_poll, NAPI_POLL_WEIGHT);
 	netif_napi_add(ndev, &lp->napi_tx, axienet_tx_poll, NAPI_POLL_WEIGHT);
 
-- 
2.35.1

