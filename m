Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FF241DE2A7
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 11:11:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729580AbgEVJLv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 05:11:51 -0400
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:6612 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728183AbgEVJLu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 May 2020 05:11:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1590138711; x=1621674711;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=IBPgNAuS9OIA9zwaHqpFAoBjV5qFcJF/iIc7z3QC3H4=;
  b=J3jloA2U8yrMOQpBfR36SbJ3KcENK3+pLkAnwfVJQYvKwtFvKovKCQ41
   J2Lq8X1DcL5FCLchrmDeTmBKPATBN48Vd/BsGA9uKvUMwpL2AFJYAUh+D
   35WpzmpWZLpCnIEdtpKTv/C1OdA3b4FRA3PKlEvrkuvwR+UWz4vlwNPQM
   M=;
IronPort-SDR: mVBUUF46R1O8oZZIBEdGs6O8mIngRlKVGv/ngTvhxDShRUai6GlrZQ+n7EBKM622/Nc6mP9a0A
 EKgCm3uzAMzA==
X-IronPort-AV: E=Sophos;i="5.73,421,1583193600"; 
   d="scan'208";a="31625943"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1e-97fdccfd.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-6002.iad6.amazon.com with ESMTP; 22 May 2020 09:11:39 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1e-97fdccfd.us-east-1.amazon.com (Postfix) with ESMTPS id 1817EA2318;
        Fri, 22 May 2020 09:11:37 +0000 (UTC)
Received: from EX13D02UWB002.ant.amazon.com (10.43.161.160) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 22 May 2020 09:11:17 +0000
Received: from EX13MTAUWB001.ant.amazon.com (10.43.161.207) by
 EX13D02UWB002.ant.amazon.com (10.43.161.160) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 22 May 2020 09:11:16 +0000
Received: from HFA15-G63729NC.amazon.com (10.1.213.6) by mail-relay.amazon.com
 (10.43.161.249) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 22 May 2020 09:11:12 +0000
From:   <akiyano@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Arthur Kiyanovski <akiyano@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <ndagan@amazon.com>, <shayagr@amazon.com>,
        <sameehj@amazon.com>
Subject: [PATCH V2 net-next 01/14] net: ena: add support for the rx offset feature
Date:   Fri, 22 May 2020 12:08:52 +0300
Message-ID: <1590138545-501-2-git-send-email-akiyano@amazon.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1590138545-501-1-git-send-email-akiyano@amazon.com>
References: <1590138545-501-1-git-send-email-akiyano@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arthur Kiyanovski <akiyano@amazon.com>

Newer ENA devices can write data to rx buffers with an offset
from the beginning of the buffer.

This commit adds support for this feature in the driver.

Signed-off-by: Sameeh Jubran <sameehj@amazon.com>
Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
---
 .../net/ethernet/amazon/ena/ena_admin_defs.h   |  5 ++++-
 drivers/net/ethernet/amazon/ena/ena_eth_com.c  | 18 ++++++++++++------
 drivers/net/ethernet/amazon/ena/ena_eth_com.h  |  1 +
 .../net/ethernet/amazon/ena/ena_eth_io_defs.h  |  4 +++-
 drivers/net/ethernet/amazon/ena/ena_netdev.c   |  8 ++++++++
 5 files changed, 28 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_admin_defs.h b/drivers/net/ethernet/amazon/ena/ena_admin_defs.h
index 7be3dcbf3d16..727836f638ad 100644
--- a/drivers/net/ethernet/amazon/ena/ena_admin_defs.h
+++ b/drivers/net/ethernet/amazon/ena/ena_admin_defs.h
@@ -813,7 +813,8 @@ struct ena_admin_host_info {
 
 	u16 reserved;
 
-	/* 1 :0 : reserved
+	/* 0 : reserved
+	 * 1 : rx_offset
 	 * 2 : interrupt_moderation
 	 * 31:3 : reserved
 	 */
@@ -1124,6 +1125,8 @@ struct ena_admin_ena_mmio_req_read_less_resp {
 #define ENA_ADMIN_HOST_INFO_DEVICE_MASK                     GENMASK(7, 3)
 #define ENA_ADMIN_HOST_INFO_BUS_SHIFT                       8
 #define ENA_ADMIN_HOST_INFO_BUS_MASK                        GENMASK(15, 8)
+#define ENA_ADMIN_HOST_INFO_RX_OFFSET_SHIFT                 1
+#define ENA_ADMIN_HOST_INFO_RX_OFFSET_MASK                  BIT(1)
 #define ENA_ADMIN_HOST_INFO_INTERRUPT_MODERATION_SHIFT      2
 #define ENA_ADMIN_HOST_INFO_INTERRUPT_MODERATION_MASK       BIT(2)
 
diff --git a/drivers/net/ethernet/amazon/ena/ena_eth_com.c b/drivers/net/ethernet/amazon/ena/ena_eth_com.c
index 2845ac277724..a014f514c069 100644
--- a/drivers/net/ethernet/amazon/ena/ena_eth_com.c
+++ b/drivers/net/ethernet/amazon/ena/ena_eth_com.c
@@ -519,7 +519,7 @@ int ena_com_rx_pkt(struct ena_com_io_cq *io_cq,
 	struct ena_eth_io_rx_cdesc_base *cdesc = NULL;
 	u16 cdesc_idx = 0;
 	u16 nb_hw_desc;
-	u16 i;
+	u16 i = 0;
 
 	WARN(io_cq->direction != ENA_COM_IO_QUEUE_DIRECTION_RX, "wrong Q type");
 
@@ -538,13 +538,19 @@ int ena_com_rx_pkt(struct ena_com_io_cq *io_cq,
 		return -ENOSPC;
 	}
 
-	for (i = 0; i < nb_hw_desc; i++) {
+	cdesc = ena_com_rx_cdesc_idx_to_ptr(io_cq, cdesc_idx);
+	ena_rx_ctx->pkt_offset = cdesc->offset;
+
+	do {
+		ena_buf[i].len = cdesc->length;
+		ena_buf[i].req_id = cdesc->req_id;
+
+		if (++i >= nb_hw_desc)
+			break;
+
 		cdesc = ena_com_rx_cdesc_idx_to_ptr(io_cq, cdesc_idx + i);
 
-		ena_buf->len = cdesc->length;
-		ena_buf->req_id = cdesc->req_id;
-		ena_buf++;
-	}
+	} while (1);
 
 	/* Update SQ head ptr */
 	io_sq->next_to_comp += nb_hw_desc;
diff --git a/drivers/net/ethernet/amazon/ena/ena_eth_com.h b/drivers/net/ethernet/amazon/ena/ena_eth_com.h
index 77986c0ea52c..9834b5cdb655 100644
--- a/drivers/net/ethernet/amazon/ena/ena_eth_com.h
+++ b/drivers/net/ethernet/amazon/ena/ena_eth_com.h
@@ -73,6 +73,7 @@ struct ena_com_rx_ctx {
 	u32 hash;
 	u16 descs;
 	int max_bufs;
+	u8 pkt_offset;
 };
 
 int ena_com_prepare_tx(struct ena_com_io_sq *io_sq,
diff --git a/drivers/net/ethernet/amazon/ena/ena_eth_io_defs.h b/drivers/net/ethernet/amazon/ena/ena_eth_io_defs.h
index 00e0f056a741..ee28fb067d8c 100644
--- a/drivers/net/ethernet/amazon/ena/ena_eth_io_defs.h
+++ b/drivers/net/ethernet/amazon/ena/ena_eth_io_defs.h
@@ -264,7 +264,9 @@ struct ena_eth_io_rx_cdesc_base {
 
 	u16 sub_qid;
 
-	u16 reserved;
+	u8 offset;
+
+	u8 reserved;
 };
 
 /* 8-word format */
diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index 85b87ed02dd5..33578297dc56 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -1435,6 +1435,8 @@ static struct sk_buff *ena_rx_skb(struct ena_ring *rx_ring,
 
 		skb_add_rx_frag(skb, skb_shinfo(skb)->nr_frags, rx_info->page,
 				rx_info->page_offset, len, ENA_PAGE_SIZE);
+		/* The offset is non zero only for the first buffer */
+		rx_info->page_offset = 0;
 
 		netif_dbg(rx_ring->adapter, rx_status, rx_ring->netdev,
 			  "rx skb updated. len %d. data_len %d\n",
@@ -1590,6 +1592,7 @@ static int ena_clean_rx_irq(struct ena_ring *rx_ring, struct napi_struct *napi,
 {
 	u16 next_to_clean = rx_ring->next_to_clean;
 	struct ena_com_rx_ctx ena_rx_ctx;
+	struct ena_rx_buffer *rx_info;
 	struct ena_adapter *adapter;
 	u32 res_budget, work_done;
 	int rx_copybreak_pkt = 0;
@@ -1614,6 +1617,7 @@ static int ena_clean_rx_irq(struct ena_ring *rx_ring, struct napi_struct *napi,
 		ena_rx_ctx.ena_bufs = rx_ring->ena_bufs;
 		ena_rx_ctx.max_bufs = rx_ring->sgl_size;
 		ena_rx_ctx.descs = 0;
+		ena_rx_ctx.pkt_offset = 0;
 		rc = ena_com_rx_pkt(rx_ring->ena_com_io_cq,
 				    rx_ring->ena_com_io_sq,
 				    &ena_rx_ctx);
@@ -1623,6 +1627,9 @@ static int ena_clean_rx_irq(struct ena_ring *rx_ring, struct napi_struct *napi,
 		if (unlikely(ena_rx_ctx.descs == 0))
 			break;
 
+		rx_info = &rx_ring->rx_buffer_info[rx_ring->ena_bufs[0].req_id];
+		rx_info->page_offset = ena_rx_ctx.pkt_offset;
+
 		netif_dbg(rx_ring->adapter, rx_status, rx_ring->netdev,
 			  "rx_poll: q %d got packet from ena. descs #: %d l3 proto %d l4 proto %d hash: %x\n",
 			  rx_ring->qid, ena_rx_ctx.descs, ena_rx_ctx.l3_proto,
@@ -3111,6 +3118,7 @@ static void ena_config_host_info(struct ena_com_dev *ena_dev,
 	host_info->num_cpus = num_online_cpus();
 
 	host_info->driver_supported_features =
+		ENA_ADMIN_HOST_INFO_RX_OFFSET_MASK |
 		ENA_ADMIN_HOST_INFO_INTERRUPT_MODERATION_MASK;
 
 	rc = ena_com_set_host_attributes(ena_dev);
-- 
2.23.1

