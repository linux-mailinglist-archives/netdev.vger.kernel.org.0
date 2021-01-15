Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 058712F8574
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 20:31:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388329AbhAOTaF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 14:30:05 -0500
Received: from fllv0015.ext.ti.com ([198.47.19.141]:36904 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388219AbhAOTaC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 14:30:02 -0500
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 10FJTITJ008514;
        Fri, 15 Jan 2021 13:29:18 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1610738958;
        bh=YU8h/JKbEX8iab3wV0fKVymghQSmxnIshynrNKiOPt8=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=k7zMEuAYcYfakQcRARVi92n9LKUM3Y7Bhro3IWvf6DlQR+wVRSdaZwkQwCbpGrNRA
         A+4Q5IWfdnSnLFCeQF6gR0DbS+7dKw+9iVV7zgSvehA8QoTtY9PN3tmy3+eQDM9NgI
         C8vRZMg18313mH8wJK1ylkiF77hAayU/yg6si9W4=
Received: from DFLE108.ent.ti.com (dfle108.ent.ti.com [10.64.6.29])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 10FJTIdf015485
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 15 Jan 2021 13:29:18 -0600
Received: from DFLE113.ent.ti.com (10.64.6.34) by DFLE108.ent.ti.com
 (10.64.6.29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Fri, 15
 Jan 2021 13:29:18 -0600
Received: from lelv0327.itg.ti.com (10.180.67.183) by DFLE113.ent.ti.com
 (10.64.6.34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Fri, 15 Jan 2021 13:29:18 -0600
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 10FJTHq9058655;
        Fri, 15 Jan 2021 13:29:17 -0600
From:   Grygorii Strashko <grygorii.strashko@ti.com>
To:     "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Peter Ujfalusi <peter.ujfalusi@gmail.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Rob Herring <robh+dt@kernel.org>
CC:     <linux-kernel@vger.kernel.org>, Sekhar Nori <nsekhar@ti.com>,
        <devicetree@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [net-next 4/6] net: ethernet: ti: am65-cpsw-nuss: Support for transparent ASEL handling
Date:   Fri, 15 Jan 2021 21:28:51 +0200
Message-ID: <20210115192853.5469-5-grygorii.strashko@ti.com>
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

Use the glue layer's functions to convert the dma_addr_t to and from CPPI5
address (with the ASEL bits), which should be used within the descriptors
and data buffers.

- Per channel coherency support
The DMAs use the 'ASEL' bits to select data and configuration fetch path.
The ASEL bits are placed at the unused parts of any address field used by
the DMAs (pointers to descriptors, addresses in descriptors, ring base
addresses). The ASEL is not part of the address (the DMAs can address
48bits). Individual channels can be configured to be coherent (via ACP
port) or non coherent individually by configuring the ASEL to appropriate
value.

[1] https://lore.kernel.org/patchwork/cover/1350756/
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
Co-developed-by: Vignesh Raghavendra <vigneshr@ti.com>
Signed-off-by: Vignesh Raghavendra <vigneshr@ti.com>
Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
---
 drivers/net/ethernet/ti/am65-cpsw-nuss.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index 8bf48cf3be9b..d060744dd0b2 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -376,6 +376,7 @@ static int am65_cpsw_nuss_rx_push(struct am65_cpsw_common *common,
 
 	cppi5_hdesc_init(desc_rx, CPPI5_INFO0_HDESC_EPIB_PRESENT,
 			 AM65_CPSW_NAV_PS_DATA_SIZE);
+	k3_udma_glue_rx_dma_to_cppi5_addr(rx_chn->rx_chn, &buf_dma);
 	cppi5_hdesc_attach_buf(desc_rx, buf_dma, skb_tailroom(skb), buf_dma, skb_tailroom(skb));
 	swdata = cppi5_hdesc_get_swdata(desc_rx);
 	*((void **)swdata) = skb;
@@ -692,6 +693,7 @@ static void am65_cpsw_nuss_rx_cleanup(void *data, dma_addr_t desc_dma)
 	swdata = cppi5_hdesc_get_swdata(desc_rx);
 	skb = *swdata;
 	cppi5_hdesc_get_obuf(desc_rx, &buf_dma, &buf_dma_len);
+	k3_udma_glue_rx_cppi5_to_dma_addr(rx_chn->rx_chn, &buf_dma);
 
 	dma_unmap_single(rx_chn->dma_dev, buf_dma, buf_dma_len, DMA_FROM_DEVICE);
 	k3_cppi_desc_pool_free(rx_chn->desc_pool, desc_rx);
@@ -780,6 +782,7 @@ static int am65_cpsw_nuss_rx_packets(struct am65_cpsw_common *common,
 	swdata = cppi5_hdesc_get_swdata(desc_rx);
 	skb = *swdata;
 	cppi5_hdesc_get_obuf(desc_rx, &buf_dma, &buf_dma_len);
+	k3_udma_glue_rx_cppi5_to_dma_addr(rx_chn->rx_chn, &buf_dma);
 	pkt_len = cppi5_hdesc_get_pktlen(desc_rx);
 	cppi5_desc_get_tags_ids(&desc_rx->hdr, &port_id, NULL);
 	dev_dbg(dev, "%s rx port_id:%d\n", __func__, port_id);
@@ -875,19 +878,23 @@ static void am65_cpsw_nuss_xmit_free(struct am65_cpsw_tx_chn *tx_chn,
 	next_desc = first_desc;
 
 	cppi5_hdesc_get_obuf(first_desc, &buf_dma, &buf_dma_len);
+	k3_udma_glue_tx_cppi5_to_dma_addr(tx_chn->tx_chn, &buf_dma);
 
 	dma_unmap_single(tx_chn->dma_dev, buf_dma, buf_dma_len, DMA_TO_DEVICE);
 
 	next_desc_dma = cppi5_hdesc_get_next_hbdesc(first_desc);
+	k3_udma_glue_tx_cppi5_to_dma_addr(tx_chn->tx_chn, &next_desc_dma);
 	while (next_desc_dma) {
 		next_desc = k3_cppi_desc_pool_dma2virt(tx_chn->desc_pool,
 						       next_desc_dma);
 		cppi5_hdesc_get_obuf(next_desc, &buf_dma, &buf_dma_len);
+		k3_udma_glue_tx_cppi5_to_dma_addr(tx_chn->tx_chn, &buf_dma);
 
 		dma_unmap_page(tx_chn->dma_dev, buf_dma, buf_dma_len,
 			       DMA_TO_DEVICE);
 
 		next_desc_dma = cppi5_hdesc_get_next_hbdesc(next_desc);
+		k3_udma_glue_tx_cppi5_to_dma_addr(tx_chn->tx_chn, &next_desc_dma);
 
 		k3_cppi_desc_pool_free(tx_chn->desc_pool, next_desc);
 	}
@@ -1140,6 +1147,7 @@ static netdev_tx_t am65_cpsw_nuss_ndo_slave_xmit(struct sk_buff *skb,
 	cppi5_hdesc_set_pkttype(first_desc, 0x7);
 	cppi5_desc_set_tags_ids(&first_desc->hdr, 0, port->port_id);
 
+	k3_udma_glue_tx_dma_to_cppi5_addr(tx_chn->tx_chn, &buf_dma);
 	cppi5_hdesc_attach_buf(first_desc, buf_dma, pkt_len, buf_dma, pkt_len);
 	swdata = cppi5_hdesc_get_swdata(first_desc);
 	*(swdata) = skb;
@@ -1185,11 +1193,13 @@ static netdev_tx_t am65_cpsw_nuss_ndo_slave_xmit(struct sk_buff *skb,
 		}
 
 		cppi5_hdesc_reset_hbdesc(next_desc);
+		k3_udma_glue_tx_dma_to_cppi5_addr(tx_chn->tx_chn, &buf_dma);
 		cppi5_hdesc_attach_buf(next_desc,
 				       buf_dma, frag_size, buf_dma, frag_size);
 
 		desc_dma = k3_cppi_desc_pool_virt2dma(tx_chn->desc_pool,
 						      next_desc);
+		k3_udma_glue_tx_dma_to_cppi5_addr(tx_chn->tx_chn, &desc_dma);
 		cppi5_hdesc_link_hbdesc(cur_desc, desc_dma);
 
 		pkt_len += frag_size;
-- 
2.17.1

