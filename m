Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 208612F8572
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 20:31:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388283AbhAOTaC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 14:30:02 -0500
Received: from fllv0015.ext.ti.com ([198.47.19.141]:36890 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726151AbhAOTaB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 14:30:01 -0500
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 10FJTHxJ008509;
        Fri, 15 Jan 2021 13:29:17 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1610738957;
        bh=NsS7Ns71KarRhQn1mJDXCaPdWQL3qqtZdfa2UL1ELwI=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=MpUl0hG5wmgs8iTqLfl0OMV2J0mEQKipCHRHKRFmcilGSYNZRelMisveiyOsR7hda
         zgS+o7ZVf9WUmsV3YFjlrBmtXzLbfjp8qPpU+/n1MAhf2IEKAT1A6wxw4PMTu/A0va
         Vcj5fcyQqwOlk1puZdEbMybMIOJh9Fm13mP9P2F8=
Received: from DFLE112.ent.ti.com (dfle112.ent.ti.com [10.64.6.33])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 10FJTHs9026250
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 15 Jan 2021 13:29:17 -0600
Received: from DFLE100.ent.ti.com (10.64.6.21) by DFLE112.ent.ti.com
 (10.64.6.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Fri, 15
 Jan 2021 13:29:16 -0600
Received: from lelv0326.itg.ti.com (10.180.67.84) by DFLE100.ent.ti.com
 (10.64.6.21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Fri, 15 Jan 2021 13:29:16 -0600
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 10FJTFrK007702;
        Fri, 15 Jan 2021 13:29:15 -0600
From:   Grygorii Strashko <grygorii.strashko@ti.com>
To:     "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Peter Ujfalusi <peter.ujfalusi@gmail.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Rob Herring <robh+dt@kernel.org>
CC:     <linux-kernel@vger.kernel.org>, Sekhar Nori <nsekhar@ti.com>,
        <devicetree@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [net-next 3/6] net: ethernet: ti: am65-cpsw-nuss: Use DMA device for DMA API
Date:   Fri, 15 Jan 2021 21:28:50 +0200
Message-ID: <20210115192853.5469-4-grygorii.strashko@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210115192853.5469-1-grygorii.strashko@ti.com>
References: <20210115192853.5469-1-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Peter Ujfalusi <peter.ujfalusi@ti.com>

For DMA API the DMA device should be used as cpsw does not accesses to
descriptors or data buffers in any ways. The DMA does.

Also, drop dma_coerce_mask_and_coherent() setting on CPSW device, as it
should be done by DMA driver which does data movement.

This is required for adding AM64x CPSW3g support where DMA coherency
supported per DMA channel.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
Co-developed-by: Vignesh Raghavendra <vigneshr@ti.com>
Signed-off-by: Vignesh Raghavendra <vigneshr@ti.com>
Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
---
 drivers/net/ethernet/ti/am65-cpsw-nuss.c | 79 ++++++++++++------------
 drivers/net/ethernet/ti/am65-cpsw-nuss.h |  2 +
 2 files changed, 40 insertions(+), 41 deletions(-)

diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index 766e8866bbef..8bf48cf3be9b 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -366,8 +366,9 @@ static int am65_cpsw_nuss_rx_push(struct am65_cpsw_common *common,
 	}
 	desc_dma = k3_cppi_desc_pool_virt2dma(rx_chn->desc_pool, desc_rx);
 
-	buf_dma = dma_map_single(dev, skb->data, pkt_len, DMA_FROM_DEVICE);
-	if (unlikely(dma_mapping_error(dev, buf_dma))) {
+	buf_dma = dma_map_single(rx_chn->dma_dev, skb->data, pkt_len,
+				 DMA_FROM_DEVICE);
+	if (unlikely(dma_mapping_error(rx_chn->dma_dev, buf_dma))) {
 		k3_cppi_desc_pool_free(rx_chn->desc_pool, desc_rx);
 		dev_err(dev, "Failed to map rx skb buffer\n");
 		return -EINVAL;
@@ -692,7 +693,7 @@ static void am65_cpsw_nuss_rx_cleanup(void *data, dma_addr_t desc_dma)
 	skb = *swdata;
 	cppi5_hdesc_get_obuf(desc_rx, &buf_dma, &buf_dma_len);
 
-	dma_unmap_single(rx_chn->dev, buf_dma, buf_dma_len, DMA_FROM_DEVICE);
+	dma_unmap_single(rx_chn->dma_dev, buf_dma, buf_dma_len, DMA_FROM_DEVICE);
 	k3_cppi_desc_pool_free(rx_chn->desc_pool, desc_rx);
 
 	dev_kfree_skb_any(skb);
@@ -793,7 +794,7 @@ static int am65_cpsw_nuss_rx_packets(struct am65_cpsw_common *common,
 	csum_info = psdata[2];
 	dev_dbg(dev, "%s rx csum_info:%#x\n", __func__, csum_info);
 
-	dma_unmap_single(dev, buf_dma, buf_dma_len, DMA_FROM_DEVICE);
+	dma_unmap_single(rx_chn->dma_dev, buf_dma, buf_dma_len, DMA_FROM_DEVICE);
 
 	k3_cppi_desc_pool_free(rx_chn->desc_pool, desc_rx);
 
@@ -864,7 +865,6 @@ static int am65_cpsw_nuss_rx_poll(struct napi_struct *napi_rx, int budget)
 }
 
 static void am65_cpsw_nuss_xmit_free(struct am65_cpsw_tx_chn *tx_chn,
-				     struct device *dev,
 				     struct cppi5_host_desc_t *desc)
 {
 	struct cppi5_host_desc_t *first_desc, *next_desc;
@@ -876,8 +876,7 @@ static void am65_cpsw_nuss_xmit_free(struct am65_cpsw_tx_chn *tx_chn,
 
 	cppi5_hdesc_get_obuf(first_desc, &buf_dma, &buf_dma_len);
 
-	dma_unmap_single(dev, buf_dma, buf_dma_len,
-			 DMA_TO_DEVICE);
+	dma_unmap_single(tx_chn->dma_dev, buf_dma, buf_dma_len, DMA_TO_DEVICE);
 
 	next_desc_dma = cppi5_hdesc_get_next_hbdesc(first_desc);
 	while (next_desc_dma) {
@@ -885,7 +884,7 @@ static void am65_cpsw_nuss_xmit_free(struct am65_cpsw_tx_chn *tx_chn,
 						       next_desc_dma);
 		cppi5_hdesc_get_obuf(next_desc, &buf_dma, &buf_dma_len);
 
-		dma_unmap_page(dev, buf_dma, buf_dma_len,
+		dma_unmap_page(tx_chn->dma_dev, buf_dma, buf_dma_len,
 			       DMA_TO_DEVICE);
 
 		next_desc_dma = cppi5_hdesc_get_next_hbdesc(next_desc);
@@ -906,7 +905,7 @@ static void am65_cpsw_nuss_tx_cleanup(void *data, dma_addr_t desc_dma)
 	desc_tx = k3_cppi_desc_pool_dma2virt(tx_chn->desc_pool, desc_dma);
 	swdata = cppi5_hdesc_get_swdata(desc_tx);
 	skb = *(swdata);
-	am65_cpsw_nuss_xmit_free(tx_chn, tx_chn->common->dev, desc_tx);
+	am65_cpsw_nuss_xmit_free(tx_chn, desc_tx);
 
 	dev_kfree_skb_any(skb);
 }
@@ -926,7 +925,7 @@ am65_cpsw_nuss_tx_compl_packet(struct am65_cpsw_tx_chn *tx_chn,
 					     desc_dma);
 	swdata = cppi5_hdesc_get_swdata(desc_tx);
 	skb = *(swdata);
-	am65_cpsw_nuss_xmit_free(tx_chn, tx_chn->common->dev, desc_tx);
+	am65_cpsw_nuss_xmit_free(tx_chn, desc_tx);
 
 	ndev = skb->dev;
 
@@ -1119,9 +1118,9 @@ static netdev_tx_t am65_cpsw_nuss_ndo_slave_xmit(struct sk_buff *skb,
 	netif_txq = netdev_get_tx_queue(ndev, q_idx);
 
 	/* Map the linear buffer */
-	buf_dma = dma_map_single(dev, skb->data, pkt_len,
+	buf_dma = dma_map_single(tx_chn->dma_dev, skb->data, pkt_len,
 				 DMA_TO_DEVICE);
-	if (unlikely(dma_mapping_error(dev, buf_dma))) {
+	if (unlikely(dma_mapping_error(tx_chn->dma_dev, buf_dma))) {
 		dev_err(dev, "Failed to map tx skb buffer\n");
 		ndev->stats.tx_errors++;
 		goto err_free_skb;
@@ -1130,7 +1129,8 @@ static netdev_tx_t am65_cpsw_nuss_ndo_slave_xmit(struct sk_buff *skb,
 	first_desc = k3_cppi_desc_pool_alloc(tx_chn->desc_pool);
 	if (!first_desc) {
 		dev_dbg(dev, "Failed to allocate descriptor\n");
-		dma_unmap_single(dev, buf_dma, pkt_len, DMA_TO_DEVICE);
+		dma_unmap_single(tx_chn->dma_dev, buf_dma, pkt_len,
+				 DMA_TO_DEVICE);
 		goto busy_stop_q;
 	}
 
@@ -1175,9 +1175,9 @@ static netdev_tx_t am65_cpsw_nuss_ndo_slave_xmit(struct sk_buff *skb,
 			goto busy_free_descs;
 		}
 
-		buf_dma = skb_frag_dma_map(dev, frag, 0, frag_size,
+		buf_dma = skb_frag_dma_map(tx_chn->dma_dev, frag, 0, frag_size,
 					   DMA_TO_DEVICE);
-		if (unlikely(dma_mapping_error(dev, buf_dma))) {
+		if (unlikely(dma_mapping_error(tx_chn->dma_dev, buf_dma))) {
 			dev_err(dev, "Failed to map tx skb page\n");
 			k3_cppi_desc_pool_free(tx_chn->desc_pool, next_desc);
 			ndev->stats.tx_errors++;
@@ -1237,14 +1237,14 @@ static netdev_tx_t am65_cpsw_nuss_ndo_slave_xmit(struct sk_buff *skb,
 	return NETDEV_TX_OK;
 
 err_free_descs:
-	am65_cpsw_nuss_xmit_free(tx_chn, dev, first_desc);
+	am65_cpsw_nuss_xmit_free(tx_chn, first_desc);
 err_free_skb:
 	ndev->stats.tx_dropped++;
 	dev_kfree_skb_any(skb);
 	return NETDEV_TX_OK;
 
 busy_free_descs:
-	am65_cpsw_nuss_xmit_free(tx_chn, dev, first_desc);
+	am65_cpsw_nuss_xmit_free(tx_chn, first_desc);
 busy_stop_q:
 	netif_tx_stop_queue(netif_txq);
 	return NETDEV_TX_BUSY;
@@ -1545,16 +1545,6 @@ static int am65_cpsw_nuss_init_tx_chns(struct am65_cpsw_common *common)
 		tx_chn->common = common;
 		tx_chn->id = i;
 		tx_chn->descs_num = max_desc_num;
-		tx_chn->desc_pool =
-			k3_cppi_desc_pool_create_name(dev,
-						      tx_chn->descs_num,
-						      hdesc_size,
-						      tx_chn->tx_chn_name);
-		if (IS_ERR(tx_chn->desc_pool)) {
-			ret = PTR_ERR(tx_chn->desc_pool);
-			dev_err(dev, "Failed to create poll %d\n", ret);
-			goto err;
-		}
 
 		tx_chn->tx_chn =
 			k3_udma_glue_request_tx_chn(dev,
@@ -1565,6 +1555,17 @@ static int am65_cpsw_nuss_init_tx_chns(struct am65_cpsw_common *common)
 					    "Failed to request tx dma channel\n");
 			goto err;
 		}
+		tx_chn->dma_dev = k3_udma_glue_tx_get_dma_device(tx_chn->tx_chn);
+
+		tx_chn->desc_pool = k3_cppi_desc_pool_create_name(tx_chn->dma_dev,
+								  tx_chn->descs_num,
+								  hdesc_size,
+								  tx_chn->tx_chn_name);
+		if (IS_ERR(tx_chn->desc_pool)) {
+			ret = PTR_ERR(tx_chn->desc_pool);
+			dev_err(dev, "Failed to create poll %d\n", ret);
+			goto err;
+		}
 
 		tx_chn->irq = k3_udma_glue_tx_get_irq(tx_chn->tx_chn);
 		if (tx_chn->irq <= 0) {
@@ -1622,14 +1623,6 @@ static int am65_cpsw_nuss_init_rx_chns(struct am65_cpsw_common *common)
 	/* init all flows */
 	rx_chn->dev = dev;
 	rx_chn->descs_num = max_desc_num;
-	rx_chn->desc_pool = k3_cppi_desc_pool_create_name(dev,
-							  rx_chn->descs_num,
-							  hdesc_size, "rx");
-	if (IS_ERR(rx_chn->desc_pool)) {
-		ret = PTR_ERR(rx_chn->desc_pool);
-		dev_err(dev, "Failed to create rx poll %d\n", ret);
-		goto err;
-	}
 
 	rx_chn->rx_chn = k3_udma_glue_request_rx_chn(dev, "rx", &rx_cfg);
 	if (IS_ERR(rx_chn->rx_chn)) {
@@ -1637,6 +1630,16 @@ static int am65_cpsw_nuss_init_rx_chns(struct am65_cpsw_common *common)
 				    "Failed to request rx dma channel\n");
 		goto err;
 	}
+	rx_chn->dma_dev = k3_udma_glue_rx_get_dma_device(rx_chn->rx_chn);
+
+	rx_chn->desc_pool = k3_cppi_desc_pool_create_name(rx_chn->dma_dev,
+							  rx_chn->descs_num,
+							  hdesc_size, "rx");
+	if (IS_ERR(rx_chn->desc_pool)) {
+		ret = PTR_ERR(rx_chn->desc_pool);
+		dev_err(dev, "Failed to create rx poll %d\n", ret);
+		goto err;
+	}
 
 	common->rx_flow_id_base =
 			k3_udma_glue_rx_get_flow_id_base(rx_chn->rx_chn);
@@ -2164,12 +2167,6 @@ static int am65_cpsw_nuss_probe(struct platform_device *pdev)
 	common->tx_ch_num = 1;
 	common->pf_p0_rx_ptype_rrobin = false;
 
-	ret = dma_coerce_mask_and_coherent(dev, DMA_BIT_MASK(48));
-	if (ret) {
-		dev_err(dev, "error setting dma mask: %d\n", ret);
-		return ret;
-	}
-
 	common->ports = devm_kcalloc(dev, common->port_num,
 				     sizeof(*common->ports),
 				     GFP_KERNEL);
diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.h b/drivers/net/ethernet/ti/am65-cpsw-nuss.h
index 02aed4c0ceba..d7f8a0f76fdc 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.h
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.h
@@ -56,6 +56,7 @@ struct am65_cpsw_host {
 };
 
 struct am65_cpsw_tx_chn {
+	struct device *dma_dev;
 	struct napi_struct napi_tx;
 	struct am65_cpsw_common	*common;
 	struct k3_cppi_desc_pool *desc_pool;
@@ -69,6 +70,7 @@ struct am65_cpsw_tx_chn {
 
 struct am65_cpsw_rx_chn {
 	struct device *dev;
+	struct device *dma_dev;
 	struct k3_cppi_desc_pool *desc_pool;
 	struct k3_udma_glue_rx_channel *rx_chn;
 	u32 descs_num;
-- 
2.17.1

