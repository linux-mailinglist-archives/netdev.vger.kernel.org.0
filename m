Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8296527FDD9
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 12:54:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732319AbgJAKyX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 06:54:23 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:43152 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732208AbgJAKxw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 06:53:52 -0400
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 091Armxn064418;
        Thu, 1 Oct 2020 05:53:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1601549628;
        bh=66sEWHqmhRbEIhyJxu8AJIODHHgyXcivpbtsp1KEzuk=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=GhhuYG1njI6Mx8Ytt81IpgRgNB5dHdQfIRYt3peTACR39nR01IkTF24AVw13yUu8r
         ee1L/1xBqTr3j7p52fJNKXCtbjqH6jJ9zOY2/lkFvWhvcfZ/3PWgaI37GZUPkK4bDn
         tkEl94cVHywxS6BEbKj6NSPBmol8maTbXIaSZUyg=
Received: from DLEE114.ent.ti.com (dlee114.ent.ti.com [157.170.170.25])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 091Armjw130540
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 1 Oct 2020 05:53:48 -0500
Received: from DLEE104.ent.ti.com (157.170.170.34) by DLEE114.ent.ti.com
 (157.170.170.25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Thu, 1 Oct
 2020 05:53:48 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DLEE104.ent.ti.com
 (157.170.170.34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Thu, 1 Oct 2020 05:53:47 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 091Arkw7072576;
        Thu, 1 Oct 2020 05:53:47 -0500
From:   Grygorii Strashko <grygorii.strashko@ti.com>
To:     "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Vignesh Raghavendra <vigneshr@ti.com>
CC:     Sekhar Nori <nsekhar@ti.com>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [PATCH net-next 7/8] net: ethernet: ti: am65-cpsw: prepare xmit/rx path for multi-port devices in mac-only mode
Date:   Thu, 1 Oct 2020 13:52:57 +0300
Message-ID: <20201001105258.2139-8-grygorii.strashko@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201001105258.2139-1-grygorii.strashko@ti.com>
References: <20201001105258.2139-1-grygorii.strashko@ti.com>
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
and DMA processing going to be assigned to first netdev this patch:
 - ensures all RX descriptors fields are initialized;
 - adds synchronization for TX DMA push/pop operation (locking) as
Networking core is not enough any more;
 - updates TX bql processing for every packet in
am65_cpsw_nuss_tx_compl_packets() as every completed TX skb can have
different ndev assigned (come from different netdevs).

Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
---
 drivers/net/ethernet/ti/am65-cpsw-nuss.c | 41 +++++++++++++-----------
 drivers/net/ethernet/ti/am65-cpsw-nuss.h |  1 +
 2 files changed, 23 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index 0bc0eec46709..a8094e8e49ca 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -375,7 +375,7 @@ static int am65_cpsw_nuss_rx_push(struct am65_cpsw_common *common,
 
 	cppi5_hdesc_init(desc_rx, CPPI5_INFO0_HDESC_EPIB_PRESENT,
 			 AM65_CPSW_NAV_PS_DATA_SIZE);
-	cppi5_hdesc_attach_buf(desc_rx, 0, 0, buf_dma, skb_tailroom(skb));
+	cppi5_hdesc_attach_buf(desc_rx, buf_dma, skb_tailroom(skb), buf_dma, skb_tailroom(skb));
 	swdata = cppi5_hdesc_get_swdata(desc_rx);
 	*((void **)swdata) = skb;
 
@@ -933,7 +933,9 @@ static int am65_cpsw_nuss_tx_compl_packets(struct am65_cpsw_common *common,
 		struct am65_cpsw_ndev_priv *ndev_priv;
 		struct am65_cpsw_ndev_stats *stats;
 
+		spin_lock(&tx_chn->lock);
 		res = k3_udma_glue_pop_tx_chn(tx_chn->tx_chn, &desc_dma);
+		spin_unlock(&tx_chn->lock);
 		if (res == -ENODATA)
 			break;
 
@@ -960,31 +962,29 @@ static int am65_cpsw_nuss_tx_compl_packets(struct am65_cpsw_common *common,
 		stats->tx_bytes += skb->len;
 		u64_stats_update_end(&stats->syncp);
 
-		total_bytes += skb->len;
+		total_bytes = skb->len;
 		napi_consume_skb(skb, budget);
 		num_tx++;
-	}
-
-	if (!num_tx)
-		return 0;
 
-	netif_txq = netdev_get_tx_queue(ndev, chn);
+		netif_txq = netdev_get_tx_queue(ndev, chn);
 
-	netdev_tx_completed_queue(netif_txq, num_tx, total_bytes);
+		netdev_tx_completed_queue(netif_txq, num_tx, total_bytes);
 
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
+		if (netif_tx_queue_stopped(netif_txq)) {
+			/* Check whether the queue is stopped due to stalled
+			 * tx dma, if the queue is stopped then wake the queue
+			 * as we have free desc for tx
+			 */
+			__netif_tx_lock(netif_txq, smp_processor_id());
+			if (netif_running(ndev) &&
+			    (k3_cppi_desc_pool_avail(tx_chn->desc_pool) >=
+			     MAX_SKB_FRAGS))
+				netif_tx_wake_queue(netif_txq);
 
-		__netif_tx_unlock(netif_txq);
+			__netif_tx_unlock(netif_txq);
+		}
 	}
+
 	dev_dbg(dev, "%s:%u pkt:%d\n", __func__, chn, num_tx);
 
 	return num_tx;
@@ -1141,7 +1141,9 @@ static netdev_tx_t am65_cpsw_nuss_ndo_slave_xmit(struct sk_buff *skb,
 
 	cppi5_hdesc_set_pktlen(first_desc, pkt_len);
 	desc_dma = k3_cppi_desc_pool_virt2dma(tx_chn->desc_pool, first_desc);
+	spin_lock_bh(&tx_chn->lock);
 	ret = k3_udma_glue_push_tx_chn(tx_chn->tx_chn, first_desc, desc_dma);
+	spin_unlock_bh(&tx_chn->lock);
 	if (ret) {
 		dev_err(dev, "can't push desc %d\n", ret);
 		/* inform bql */
@@ -1498,6 +1500,7 @@ static int am65_cpsw_nuss_init_tx_chns(struct am65_cpsw_common *common)
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

