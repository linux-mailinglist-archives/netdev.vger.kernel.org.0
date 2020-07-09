Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7796321A77D
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 21:06:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726433AbgGITGB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 15:06:01 -0400
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:50484 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726116AbgGITGB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jul 2020 15:06:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1594321560; x=1625857560;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=dRuuTvaH/Jff+Rj9LUzlbeEeIT+yblsTHYhX9lb4fWw=;
  b=K8UBsEA10+DZlaIrkT5qqVBsTcrTHlg9b+jA/wrC9ytMxgf1QbbT3/hE
   niLMBXy8Er7cKOh0C/YBIFY+sPKk1vpT4pfO6BUwvref0r6VOuKWkWHMz
   Vimbv0fPGdAsHvKOoklvvpuGHNkFynjCktx0D750SoZ+JMV0XSyk4Zq2B
   g=;
IronPort-SDR: a/NLD0tMM3rBeYmMAn+dtNG3XimLerCYU+UkKB/eJpAQAm5sCWGxaHzeH1H0qkQNYzRtjTCNPF
 9FkjL1yKLqIA==
X-IronPort-AV: E=Sophos;i="5.75,332,1589241600"; 
   d="scan'208";a="41136664"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1e-17c49630.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP; 09 Jul 2020 19:06:00 +0000
Received: from EX13MTAUWC001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1e-17c49630.us-east-1.amazon.com (Postfix) with ESMTPS id ECB81A20E4;
        Thu,  9 Jul 2020 19:05:58 +0000 (UTC)
Received: from EX13d09UWC004.ant.amazon.com (10.43.162.114) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 9 Jul 2020 19:05:38 +0000
Received: from EX13MTAUWC001.ant.amazon.com (10.43.162.135) by
 EX13d09UWC004.ant.amazon.com (10.43.162.114) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 9 Jul 2020 19:05:37 +0000
Received: from HFA15-G63729NC.amazon.com (10.1.213.15) by
 mail-relay.amazon.com (10.43.162.232) with Microsoft SMTP Server id
 15.0.1497.2 via Frontend Transport; Thu, 9 Jul 2020 19:05:33 +0000
From:   <akiyano@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Arthur Kiyanovski <akiyano@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <ndagan@amazon.com>, <shayagr@amazon.com>,
        <sameehj@amazon.com>
Subject: [PATCH V1 net-next 5/8] net: ena: add support for traffic mirroring
Date:   Thu, 9 Jul 2020 22:05:00 +0300
Message-ID: <1594321503-12256-6-git-send-email-akiyano@amazon.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1594321503-12256-1-git-send-email-akiyano@amazon.com>
References: <1594321503-12256-1-git-send-email-akiyano@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arthur Kiyanovski <akiyano@amazon.com>

Add support for traffic mirroring, where the hardware reads the
buffer from the instance memory directly.

Traffic Mirroring needs access to the rx buffers in the instance.
To have this access, this patch:
1. Changes the code to map and unmap the rx buffers bidirectionally.
2. Enables the relevant bit in driver_supported_features to indicate
   to the FW that this driver supports traffic mirroring.

Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
---
 drivers/net/ethernet/amazon/ena/ena_admin_defs.h |  5 ++++-
 drivers/net/ethernet/amazon/ena/ena_netdev.c     | 15 +++++++++------
 2 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_admin_defs.h b/drivers/net/ethernet/amazon/ena/ena_admin_defs.h
index 336742f6e3c3..afe87ff09b20 100644
--- a/drivers/net/ethernet/amazon/ena/ena_admin_defs.h
+++ b/drivers/net/ethernet/amazon/ena/ena_admin_defs.h
@@ -816,7 +816,8 @@ struct ena_admin_host_info {
 	/* 0 : reserved
 	 * 1 : rx_offset
 	 * 2 : interrupt_moderation
-	 * 31:3 : reserved
+	 * 3 : rx_buf_mirroring
+	 * 31:4 : reserved
 	 */
 	u32 driver_supported_features;
 };
@@ -1129,6 +1130,8 @@ struct ena_admin_ena_mmio_req_read_less_resp {
 #define ENA_ADMIN_HOST_INFO_RX_OFFSET_MASK                  BIT(1)
 #define ENA_ADMIN_HOST_INFO_INTERRUPT_MODERATION_SHIFT      2
 #define ENA_ADMIN_HOST_INFO_INTERRUPT_MODERATION_MASK       BIT(2)
+#define ENA_ADMIN_HOST_INFO_RX_BUF_MIRRORING_SHIFT          3
+#define ENA_ADMIN_HOST_INFO_RX_BUF_MIRRORING_MASK           BIT(3)
 
 /* aenq_common_desc */
 #define ENA_ADMIN_AENQ_COMMON_DESC_PHASE_MASK               BIT(0)
diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index 18a30a81a475..fd5f0d87cc59 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -959,8 +959,11 @@ static int ena_alloc_rx_page(struct ena_ring *rx_ring,
 		return -ENOMEM;
 	}
 
+	/* To enable NIC-side port-mirroring, AKA SPAN port,
+	 * we make the buffer readable from the nic as well
+	 */
 	dma = dma_map_page(rx_ring->dev, page, 0, ENA_PAGE_SIZE,
-			   DMA_FROM_DEVICE);
+			   DMA_BIDIRECTIONAL);
 	if (unlikely(dma_mapping_error(rx_ring->dev, dma))) {
 		u64_stats_update_begin(&rx_ring->syncp);
 		rx_ring->rx_stats.dma_mapping_err++;
@@ -993,10 +996,9 @@ static void ena_free_rx_page(struct ena_ring *rx_ring,
 		return;
 	}
 
-	dma_unmap_page(rx_ring->dev,
-		       ena_buf->paddr - rx_ring->rx_headroom,
+	dma_unmap_page(rx_ring->dev, ena_buf->paddr - rx_ring->rx_headroom,
 		       ENA_PAGE_SIZE,
-		       DMA_FROM_DEVICE);
+		       DMA_BIDIRECTIONAL);
 
 	__free_page(page);
 	rx_info->page = NULL;
@@ -1431,7 +1433,7 @@ static struct sk_buff *ena_rx_skb(struct ena_ring *rx_ring,
 	do {
 		dma_unmap_page(rx_ring->dev,
 			       dma_unmap_addr(&rx_info->ena_buf, paddr),
-			       ENA_PAGE_SIZE, DMA_FROM_DEVICE);
+			       ENA_PAGE_SIZE, DMA_BIDIRECTIONAL);
 
 		skb_add_rx_frag(skb, skb_shinfo(skb)->nr_frags, rx_info->page,
 				rx_info->page_offset, len, ENA_PAGE_SIZE);
@@ -3123,7 +3125,8 @@ static void ena_config_host_info(struct ena_com_dev *ena_dev, struct pci_dev *pd
 
 	host_info->driver_supported_features =
 		ENA_ADMIN_HOST_INFO_RX_OFFSET_MASK |
-		ENA_ADMIN_HOST_INFO_INTERRUPT_MODERATION_MASK;
+		ENA_ADMIN_HOST_INFO_INTERRUPT_MODERATION_MASK |
+		ENA_ADMIN_HOST_INFO_RX_BUF_MIRRORING_MASK;
 
 	rc = ena_com_set_host_attributes(ena_dev);
 	if (rc) {
-- 
2.23.1

