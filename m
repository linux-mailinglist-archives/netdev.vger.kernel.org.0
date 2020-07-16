Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE044222AAF
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 20:11:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729454AbgGPSL0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 14:11:26 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:6285 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729433AbgGPSLY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 14:11:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1594923083; x=1626459083;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=8raKFXwAY8gI2c6yux7WTO/i6JYJquQBlJPLmljyLYs=;
  b=Dzp3VcLKlfsXSi/VrimYmutAQz68qsC8HdpCDlBuZu5lBje30tu2AHXt
   qEaEp8kVcJnUS3oEsYlt2ExjagQx4tZ1gc5XHRSaSB61r35djUQ0F9+tZ
   yeYSJhf/zjQpDjnQIggfyAL8P4a/fIlxeK3uwGAveuSfvN9UiZKZ/6mJm
   I=;
IronPort-SDR: /S5h46o5/XDniT1fbKjAZSluk4zkSLRUQScKIy4EGeW4cpOr52jxRP85k65OMPRRe+Z0SR6Meq
 9CEAT/BUIJPg==
X-IronPort-AV: E=Sophos;i="5.75,360,1589241600"; 
   d="scan'208";a="59153954"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1a-e34f1ddc.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 16 Jul 2020 18:11:19 +0000
Received: from EX13MTAUEE002.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1a-e34f1ddc.us-east-1.amazon.com (Postfix) with ESMTPS id 821E7A2260;
        Thu, 16 Jul 2020 18:11:18 +0000 (UTC)
Received: from EX13D08UEE003.ant.amazon.com (10.43.62.118) by
 EX13MTAUEE002.ant.amazon.com (10.43.62.24) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 16 Jul 2020 18:11:07 +0000
Received: from EX13MTAUEE002.ant.amazon.com (10.43.62.24) by
 EX13D08UEE003.ant.amazon.com (10.43.62.118) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 16 Jul 2020 18:11:07 +0000
Received: from HFA15-G63729NC.amazon.com (10.1.212.20) by
 mail-relay.amazon.com (10.43.62.224) with Microsoft SMTP Server id
 15.0.1497.2 via Frontend Transport; Thu, 16 Jul 2020 18:11:04 +0000
From:   <akiyano@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Arthur Kiyanovski <akiyano@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <ndagan@amazon.com>, <shayagr@amazon.com>,
        <sameehj@amazon.com>
Subject: [PATCH V3 net-next 5/8] net: ena: add support for traffic mirroring
Date:   Thu, 16 Jul 2020 21:10:07 +0300
Message-ID: <1594923010-6234-6-git-send-email-akiyano@amazon.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1594923010-6234-1-git-send-email-akiyano@amazon.com>
References: <1594923010-6234-1-git-send-email-akiyano@amazon.com>
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

Rx completion is not generated until mirroring is done to avoid
the situation where the driver changes the buffer before it is
mirrored.

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
2.23.3

