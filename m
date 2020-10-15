Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEF7228FBAD
	for <lists+netdev@lfdr.de>; Fri, 16 Oct 2020 01:21:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388978AbgJOXU1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Oct 2020 19:20:27 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:44902 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388776AbgJOXUP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Oct 2020 19:20:15 -0400
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 09FNKBfp080180;
        Thu, 15 Oct 2020 18:20:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1602804011;
        bh=qJtnUJpqxgYLwU+4zhkdOH6RtphmIt3nBWGqIRpWwdw=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=iV+VSu/K2bpqLS/2+XNct16UDJvhoGihXrkOWEvY1rf6Kdj2S0g+2+kXPXNsMD6Yx
         Of9p7+yRvpLfgU1F9a2sm8B7nhJA9w2qq95HCklcs8no++kovzGbkRGHDqYSGQvpfD
         Rba9ttfVuZDr5jTKOrsVDoqKPtUWhFzNJEfqkf0o=
Received: from DFLE112.ent.ti.com (dfle112.ent.ti.com [10.64.6.33])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 09FNKBXN129387
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 15 Oct 2020 18:20:11 -0500
Received: from DFLE107.ent.ti.com (10.64.6.28) by DFLE112.ent.ti.com
 (10.64.6.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Thu, 15
 Oct 2020 18:20:11 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DFLE107.ent.ti.com
 (10.64.6.28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Thu, 15 Oct 2020 18:20:11 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 09FNKAbP059027;
        Thu, 15 Oct 2020 18:20:10 -0500
From:   Grygorii Strashko <grygorii.strashko@ti.com>
To:     "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Vignesh Raghavendra <vigneshr@ti.com>
CC:     Sekhar Nori <nsekhar@ti.com>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [PATCH net-next v2 8/9] net: ethernet: ti: am65-cpsw: prepare xmit/rx path for multi-port devices in mac-only mode
Date:   Fri, 16 Oct 2020 02:19:12 +0300
Message-ID: <20201015231913.30280-9-grygorii.strashko@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201015231913.30280-1-grygorii.strashko@ti.com>
References: <20201015231913.30280-1-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds multi-port support to TI AM65x CPSW driver xmit/rx path in
preparation for adding support for multi-port devices, like Main CPSW0 on
K3 J721E SoC or future CPSW3g on K3 AM64x SoC.
Hence DMA channels are common/shared for all ext Ports and the RX/TX NAPI
and DMA processing going to be assigned to first available netdev this patch:
 - ensures all RX descriptors fields are initialized;
 - adds synchronization for TX DMA push/pop operation (locking) as
Networking core locks are not enough any more;
 - updates TX bql processing for every packet in
am65_cpsw_nuss_tx_compl_packets() as every completed TX skb can have
different ndev assigned (come from different netdevs).

To avoid performance issues for existing one-port CPSW2g devices the above
changes are done only for multi-port devices by splitting xmit path for
one-port and multi-port devices.

Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
---
changes in v2:
- xmit path split for one-port and multi-port devices to avoid
  performance losses

 drivers/net/ethernet/ti/am65-cpsw-nuss.c | 141 +++++++++++++++++------
 drivers/net/ethernet/ti/am65-cpsw-nuss.h |   1 +
 2 files changed, 108 insertions(+), 34 deletions(-)

diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index 2aa0c2acd059..86bfd253e295 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -375,7 +375,7 @@ static int am65_cpsw_nuss_rx_push(struct am65_cpsw_common *common,
 
 	cppi5_hdesc_init(desc_rx, CPPI5_INFO0_HDESC_EPIB_PRESENT,
 			 AM65_CPSW_NAV_PS_DATA_SIZE);
-	cppi5_hdesc_attach_buf(desc_rx, 0, 0, buf_dma, skb_tailroom(skb));
+	cppi5_hdesc_attach_buf(desc_rx, buf_dma, skb_tailroom(skb), buf_dma, skb_tailroom(skb));
 	swdata = cppi5_hdesc_get_swdata(desc_rx);
 	*((void **)swdata) = skb;
 
@@ -911,10 +911,57 @@ static void am65_cpsw_nuss_tx_cleanup(void *data, dma_addr_t desc_dma)
 	dev_kfree_skb_any(skb);
 }
 
+static struct sk_buff *
+am65_cpsw_nuss_tx_compl_packet(struct am65_cpsw_tx_chn *tx_chn,
+			       dma_addr_t desc_dma)
+{
+	struct am65_cpsw_ndev_priv *ndev_priv;
+	struct am65_cpsw_ndev_stats *stats;
+	struct cppi5_host_desc_t *desc_tx;
+	struct net_device *ndev;
+	struct sk_buff *skb;
+	void **swdata;
+
+	desc_tx = k3_cppi_desc_pool_dma2virt(tx_chn->desc_pool,
+					     desc_dma);
+	swdata = cppi5_hdesc_get_swdata(desc_tx);
+	skb = *(swdata);
+	am65_cpsw_nuss_xmit_free(tx_chn, tx_chn->common->dev, desc_tx);
+
+	ndev = skb->dev;
+
+	am65_cpts_tx_timestamp(tx_chn->common->cpts, skb);
+
+	ndev_priv = netdev_priv(ndev);
+	stats = this_cpu_ptr(ndev_priv->stats);
+	u64_stats_update_begin(&stats->syncp);
+	stats->tx_packets++;
+	stats->tx_bytes += skb->len;
+	u64_stats_update_end(&stats->syncp);
+
+	return skb;
+}
+
+static void am65_cpsw_nuss_tx_wake(struct am65_cpsw_tx_chn *tx_chn, struct net_device *ndev,
+				   struct netdev_queue *netif_txq)
+{
+	if (netif_tx_queue_stopped(netif_txq)) {
+		/* Check whether the queue is stopped due to stalled
+		 * tx dma, if the queue is stopped then wake the queue
+		 * as we have free desc for tx
+		 */
+		__netif_tx_lock(netif_txq, smp_processor_id());
+		if (netif_running(ndev) &&
+		    (k3_cppi_desc_pool_avail(tx_chn->desc_pool) >= MAX_SKB_FRAGS))
+			netif_tx_wake_queue(netif_txq);
+
+		__netif_tx_unlock(netif_txq);
+	}
+}
+
 static int am65_cpsw_nuss_tx_compl_packets(struct am65_cpsw_common *common,
 					   int chn, unsigned int budget)
 {
-	struct cppi5_host_desc_t *desc_tx;
 	struct device *dev = common->dev;
 	struct am65_cpsw_tx_chn *tx_chn;
 	struct netdev_queue *netif_txq;
@@ -923,15 +970,13 @@ static int am65_cpsw_nuss_tx_compl_packets(struct am65_cpsw_common *common,
 	struct sk_buff *skb;
 	dma_addr_t desc_dma;
 	int res, num_tx = 0;
-	void **swdata;
 
 	tx_chn = &common->tx_chns[chn];
 
 	while (true) {
-		struct am65_cpsw_ndev_priv *ndev_priv;
-		struct am65_cpsw_ndev_stats *stats;
-
+		spin_lock(&tx_chn->lock);
 		res = k3_udma_glue_pop_tx_chn(tx_chn->tx_chn, &desc_dma);
+		spin_unlock(&tx_chn->lock);
 		if (res == -ENODATA)
 			break;
 
@@ -941,23 +986,52 @@ static int am65_cpsw_nuss_tx_compl_packets(struct am65_cpsw_common *common,
 			break;
 		}
 
-		desc_tx = k3_cppi_desc_pool_dma2virt(tx_chn->desc_pool,
-						     desc_dma);
-		swdata = cppi5_hdesc_get_swdata(desc_tx);
-		skb = *(swdata);
-		am65_cpsw_nuss_xmit_free(tx_chn, dev, desc_tx);
-
+		skb = am65_cpsw_nuss_tx_compl_packet(tx_chn, desc_dma);
+		total_bytes = skb->len;
 		ndev = skb->dev;
+		napi_consume_skb(skb, budget);
+		num_tx++;
 
-		am65_cpts_tx_timestamp(common->cpts, skb);
+		netif_txq = netdev_get_tx_queue(ndev, chn);
 
-		ndev_priv = netdev_priv(ndev);
-		stats = this_cpu_ptr(ndev_priv->stats);
-		u64_stats_update_begin(&stats->syncp);
-		stats->tx_packets++;
-		stats->tx_bytes += skb->len;
-		u64_stats_update_end(&stats->syncp);
+		netdev_tx_completed_queue(netif_txq, num_tx, total_bytes);
+
+		am65_cpsw_nuss_tx_wake(tx_chn, ndev, netif_txq);
+	}
 
+	dev_dbg(dev, "%s:%u pkt:%d\n", __func__, chn, num_tx);
+
+	return num_tx;
+}
+
+static int am65_cpsw_nuss_tx_compl_packets_2g(struct am65_cpsw_common *common,
+					      int chn, unsigned int budget)
+{
+	struct device *dev = common->dev;
+	struct am65_cpsw_tx_chn *tx_chn;
+	struct netdev_queue *netif_txq;
+	unsigned int total_bytes = 0;
+	struct net_device *ndev;
+	struct sk_buff *skb;
+	dma_addr_t desc_dma;
+	int res, num_tx = 0;
+
+	tx_chn = &common->tx_chns[chn];
+
+	while (true) {
+		res = k3_udma_glue_pop_tx_chn(tx_chn->tx_chn, &desc_dma);
+		if (res == -ENODATA)
+			break;
+
+		if (cppi5_desc_is_tdcm(desc_dma)) {
+			if (atomic_dec_and_test(&common->tdown_cnt))
+				complete(&common->tdown_complete);
+			break;
+		}
+
+		skb = am65_cpsw_nuss_tx_compl_packet(tx_chn, desc_dma);
+
+		ndev = skb->dev;
 		total_bytes += skb->len;
 		napi_consume_skb(skb, budget);
 		num_tx++;
@@ -970,19 +1044,8 @@ static int am65_cpsw_nuss_tx_compl_packets(struct am65_cpsw_common *common,
 
 	netdev_tx_completed_queue(netif_txq, num_tx, total_bytes);
 
-	if (netif_tx_queue_stopped(netif_txq)) {
-		/* Check whether the queue is stopped due to stalled tx dma,
-		 * if the queue is stopped then wake the queue as
-		 * we have free desc for tx
-		 */
-		__netif_tx_lock(netif_txq, smp_processor_id());
-		if (netif_running(ndev) &&
-		    (k3_cppi_desc_pool_avail(tx_chn->desc_pool) >=
-		     MAX_SKB_FRAGS))
-			netif_tx_wake_queue(netif_txq);
+	am65_cpsw_nuss_tx_wake(tx_chn, ndev, netif_txq);
 
-		__netif_tx_unlock(netif_txq);
-	}
 	dev_dbg(dev, "%s:%u pkt:%d\n", __func__, chn, num_tx);
 
 	return num_tx;
@@ -993,8 +1056,11 @@ static int am65_cpsw_nuss_tx_poll(struct napi_struct *napi_tx, int budget)
 	struct am65_cpsw_tx_chn *tx_chn = am65_cpsw_napi_to_tx_chn(napi_tx);
 	int num_tx;
 
-	num_tx = am65_cpsw_nuss_tx_compl_packets(tx_chn->common, tx_chn->id,
-						 budget);
+	if (AM65_CPSW_IS_CPSW2G(tx_chn->common))
+		num_tx = am65_cpsw_nuss_tx_compl_packets_2g(tx_chn->common, tx_chn->id, budget);
+	else
+		num_tx = am65_cpsw_nuss_tx_compl_packets(tx_chn->common, tx_chn->id, budget);
+
 	num_tx = min(num_tx, budget);
 	if (num_tx < budget) {
 		napi_complete(napi_tx);
@@ -1139,7 +1205,13 @@ static netdev_tx_t am65_cpsw_nuss_ndo_slave_xmit(struct sk_buff *skb,
 
 	cppi5_hdesc_set_pktlen(first_desc, pkt_len);
 	desc_dma = k3_cppi_desc_pool_virt2dma(tx_chn->desc_pool, first_desc);
-	ret = k3_udma_glue_push_tx_chn(tx_chn->tx_chn, first_desc, desc_dma);
+	if (AM65_CPSW_IS_CPSW2G(common)) {
+		ret = k3_udma_glue_push_tx_chn(tx_chn->tx_chn, first_desc, desc_dma);
+	} else {
+		spin_lock_bh(&tx_chn->lock);
+		ret = k3_udma_glue_push_tx_chn(tx_chn->tx_chn, first_desc, desc_dma);
+		spin_unlock_bh(&tx_chn->lock);
+	}
 	if (ret) {
 		dev_err(dev, "can't push desc %d\n", ret);
 		/* inform bql */
@@ -1470,6 +1542,7 @@ static int am65_cpsw_nuss_init_tx_chns(struct am65_cpsw_common *common)
 		snprintf(tx_chn->tx_chn_name,
 			 sizeof(tx_chn->tx_chn_name), "tx%d", i);
 
+		spin_lock_init(&tx_chn->lock);
 		tx_chn->common = common;
 		tx_chn->id = i;
 		tx_chn->descs_num = max_desc_num;
diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.h b/drivers/net/ethernet/ti/am65-cpsw-nuss.h
index b6f228ddc3a0..8e0dc5728253 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.h
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.h
@@ -60,6 +60,7 @@ struct am65_cpsw_tx_chn {
 	struct am65_cpsw_common	*common;
 	struct k3_cppi_desc_pool *desc_pool;
 	struct k3_udma_glue_tx_channel *tx_chn;
+	spinlock_t lock; /* protect TX rings in multi-port mode */
 	int irq;
 	u32 id;
 	u32 descs_num;
-- 
2.17.1

