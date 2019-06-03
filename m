Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 464DA33277
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 16:43:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729325AbfFCOnn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 10:43:43 -0400
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:46504 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728882AbfFCOnm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jun 2019 10:43:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1559573021; x=1591109021;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=cqtNxkTjJf+IpuDObO6mF0Z0UEhth1Dbyc8bu8AAOtk=;
  b=Wh0w+eggU6eKmySWC3+9uvMbnzJjL4Zhkzg5sZ/0o0aiuBSSkPHKcNJD
   Us0KC4MvCgqSJxsC+tHDm9R0ZS3M53z8YcgUD+Xg0Tvfl2vKpSUrTa6il
   YirPrcUei7/HZ2G0yoibQB4/YBTXiXTkRmx9jHSyaevVZJ+eC3W3Wk/q+
   M=;
X-IronPort-AV: E=Sophos;i="5.60,547,1549929600"; 
   d="scan'208";a="735848744"
Received: from iad6-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1d-98acfc19.us-east-1.amazon.com) ([10.124.125.2])
  by smtp-border-fw-out-2101.iad2.amazon.com with ESMTP; 03 Jun 2019 14:43:40 +0000
Received: from EX13MTAUEA001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1d-98acfc19.us-east-1.amazon.com (Postfix) with ESMTPS id 38647A2039;
        Mon,  3 Jun 2019 14:43:39 +0000 (UTC)
Received: from EX13D08UEE002.ant.amazon.com (10.43.62.92) by
 EX13MTAUEA001.ant.amazon.com (10.43.61.243) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Mon, 3 Jun 2019 14:43:39 +0000
Received: from EX13MTAUEE001.ant.amazon.com (10.43.62.200) by
 EX13D08UEE002.ant.amazon.com (10.43.62.92) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Mon, 3 Jun 2019 14:43:39 +0000
Received: from HFA16-8226Y22.hfa16.amazon.com (10.218.60.55) by
 mail-relay.amazon.com (10.43.62.226) with Microsoft SMTP Server id
 15.0.1367.3 via Frontend Transport; Mon, 3 Jun 2019 14:43:36 +0000
From:   <sameehj@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Sameeh Jubran <sameehj@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <akiyano@amazon.com>
Subject: [PATCH V2 net 01/11] net: ena: add handling of llq max tx burst size
Date:   Mon, 3 Jun 2019 17:43:19 +0300
Message-ID: <20190603144329.16366-2-sameehj@amazon.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190603144329.16366-1-sameehj@amazon.com>
References: <20190603144329.16366-1-sameehj@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sameeh Jubran <sameehj@amazon.com>

There is a maximum TX burst size that the ENA device can handle.
It is exposed by the device to the driver and the driver
needs to comply with it to avoid bugs.

In this commit we:
1. Add ena_com_is_doorbell_needed(), which calculates the number of
   llq entries that will be used to hold a packet, and will return
   true if they exceed the number of allowed entries in a burst.
   If the function returns true, a doorbell needs to be invoked
   to send this packet in the next burst.

2. Follow the available entries in the current burst:
   - Every doorbell a new burst begins
   - With each write of an llq entry, the available entries in the
     current burst are decreased by 1.

Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
Signed-off-by: Sameeh Jubran <sameehj@amazon.com>
---
 .../net/ethernet/amazon/ena/ena_admin_defs.h  |  5 ++
 drivers/net/ethernet/amazon/ena/ena_com.c     |  7 +++
 drivers/net/ethernet/amazon/ena/ena_com.h     |  2 +
 drivers/net/ethernet/amazon/ena/ena_eth_com.c | 28 ++++------
 drivers/net/ethernet/amazon/ena/ena_eth_com.h | 53 +++++++++++++++++++
 drivers/net/ethernet/amazon/ena/ena_netdev.c  |  7 +++
 6 files changed, 85 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_admin_defs.h b/drivers/net/ethernet/amazon/ena/ena_admin_defs.h
index 9f80b73f9..82cff1e12 100644
--- a/drivers/net/ethernet/amazon/ena/ena_admin_defs.h
+++ b/drivers/net/ethernet/amazon/ena/ena_admin_defs.h
@@ -524,6 +524,11 @@ struct ena_admin_feature_llq_desc {
 
 	/* the stride control the driver selected to use */
 	u16 descriptors_stride_ctrl_enabled;
+
+	/* Maximum size in bytes taken by llq entries in a single tx burst.
+	 * Set to 0 when there is no such limit.
+	 */
+	u32 max_tx_burst_size;
 };
 
 struct ena_admin_queue_feature_desc {
diff --git a/drivers/net/ethernet/amazon/ena/ena_com.c b/drivers/net/ethernet/amazon/ena/ena_com.c
index 7f8266b19..bd0d785b2 100644
--- a/drivers/net/ethernet/amazon/ena/ena_com.c
+++ b/drivers/net/ethernet/amazon/ena/ena_com.c
@@ -396,6 +396,10 @@ static int ena_com_init_io_sq(struct ena_com_dev *ena_dev,
 		       0x0, io_sq->llq_info.desc_list_entry_size);
 		io_sq->llq_buf_ctrl.descs_left_in_line =
 			io_sq->llq_info.descs_num_before_header;
+
+		if (io_sq->llq_info.max_entries_in_tx_burst > 0)
+			io_sq->entries_in_tx_burst_left =
+				io_sq->llq_info.max_entries_in_tx_burst;
 	}
 
 	io_sq->tail = 0;
@@ -727,6 +731,9 @@ static int ena_com_config_llq_info(struct ena_com_dev *ena_dev,
 		       supported_feat, llq_info->descs_num_before_header);
 	}
 
+	llq_info->max_entries_in_tx_burst =
+		(u16)(llq_features->max_tx_burst_size /	llq_default_cfg->llq_ring_entry_size_value);
+
 	rc = ena_com_set_llq(ena_dev);
 	if (rc)
 		pr_err("Cannot set LLQ configuration: %d\n", rc);
diff --git a/drivers/net/ethernet/amazon/ena/ena_com.h b/drivers/net/ethernet/amazon/ena/ena_com.h
index 078d6f2b4..f0cb043af 100644
--- a/drivers/net/ethernet/amazon/ena/ena_com.h
+++ b/drivers/net/ethernet/amazon/ena/ena_com.h
@@ -159,6 +159,7 @@ struct ena_com_llq_info {
 	u16 desc_list_entry_size;
 	u16 descs_num_before_header;
 	u16 descs_per_entry;
+	u16 max_entries_in_tx_burst;
 };
 
 struct ena_com_io_cq {
@@ -238,6 +239,7 @@ struct ena_com_io_sq {
 	u8 phase;
 	u8 desc_entry_size;
 	u8 dma_addr_bits;
+	u16 entries_in_tx_burst_left;
 } ____cacheline_aligned;
 
 struct ena_com_admin_cq {
diff --git a/drivers/net/ethernet/amazon/ena/ena_eth_com.c b/drivers/net/ethernet/amazon/ena/ena_eth_com.c
index f6c2d3855..cad2b5728 100644
--- a/drivers/net/ethernet/amazon/ena/ena_eth_com.c
+++ b/drivers/net/ethernet/amazon/ena/ena_eth_com.c
@@ -82,6 +82,17 @@ static inline int ena_com_write_bounce_buffer_to_dev(struct ena_com_io_sq *io_sq
 	dst_tail_mask = io_sq->tail & (io_sq->q_depth - 1);
 	dst_offset = dst_tail_mask * llq_info->desc_list_entry_size;
 
+	if (is_llq_max_tx_burst_exists(io_sq)) {
+		if (unlikely(!io_sq->entries_in_tx_burst_left)) {
+			pr_err("Error: trying to send more packets than tx burst allows\n");
+			return -ENOSPC;
+		}
+
+		io_sq->entries_in_tx_burst_left--;
+		pr_debug("decreasing entries_in_tx_burst_left of queue %d to %d\n",
+			 io_sq->qid, io_sq->entries_in_tx_burst_left);
+	}
+
 	/* Make sure everything was written into the bounce buffer before
 	 * writing the bounce buffer to the device
 	 */
@@ -274,23 +285,6 @@ static inline u16 ena_com_cdesc_rx_pkt_get(struct ena_com_io_cq *io_cq,
 	return count;
 }
 
-static inline bool ena_com_meta_desc_changed(struct ena_com_io_sq *io_sq,
-					     struct ena_com_tx_ctx *ena_tx_ctx)
-{
-	int rc;
-
-	if (ena_tx_ctx->meta_valid) {
-		rc = memcmp(&io_sq->cached_tx_meta,
-			    &ena_tx_ctx->ena_meta,
-			    sizeof(struct ena_com_tx_meta));
-
-		if (unlikely(rc != 0))
-			return true;
-	}
-
-	return false;
-}
-
 static inline int ena_com_create_and_store_tx_meta_desc(struct ena_com_io_sq *io_sq,
 							struct ena_com_tx_ctx *ena_tx_ctx)
 {
diff --git a/drivers/net/ethernet/amazon/ena/ena_eth_com.h b/drivers/net/ethernet/amazon/ena/ena_eth_com.h
index 340d02b64..0a3d9180e 100644
--- a/drivers/net/ethernet/amazon/ena/ena_eth_com.h
+++ b/drivers/net/ethernet/amazon/ena/ena_eth_com.h
@@ -125,8 +125,55 @@ static inline bool ena_com_sq_have_enough_space(struct ena_com_io_sq *io_sq,
 	return ena_com_free_desc(io_sq) > temp;
 }
 
+static inline bool ena_com_meta_desc_changed(struct ena_com_io_sq *io_sq,
+					     struct ena_com_tx_ctx *ena_tx_ctx)
+{
+	if (!ena_tx_ctx->meta_valid)
+		return false;
+
+	return !!memcmp(&io_sq->cached_tx_meta,
+			&ena_tx_ctx->ena_meta,
+			sizeof(struct ena_com_tx_meta));
+}
+
+static inline bool is_llq_max_tx_burst_exists(struct ena_com_io_sq *io_sq)
+{
+	return (io_sq->mem_queue_type == ENA_ADMIN_PLACEMENT_POLICY_DEV) &&
+	       io_sq->llq_info.max_entries_in_tx_burst > 0;
+}
+
+static inline bool ena_com_is_doorbell_needed(struct ena_com_io_sq *io_sq,
+					      struct ena_com_tx_ctx *ena_tx_ctx)
+{
+	struct ena_com_llq_info *llq_info;
+	int descs_after_first_entry;
+	int num_entries_needed = 1;
+	u16 num_descs;
+
+	if (!is_llq_max_tx_burst_exists(io_sq))
+		return false;
+
+	llq_info = &io_sq->llq_info;
+	num_descs = ena_tx_ctx->num_bufs;
+
+	if (unlikely(ena_com_meta_desc_changed(io_sq, ena_tx_ctx)))
+		++num_descs;
+
+	if (num_descs > llq_info->descs_num_before_header) {
+		descs_after_first_entry = num_descs - llq_info->descs_num_before_header;
+		num_entries_needed += DIV_ROUND_UP(descs_after_first_entry,
+						   llq_info->descs_per_entry);
+	}
+
+	pr_debug("queue: %d num_descs: %d num_entries_needed: %d\n", io_sq->qid,
+		 num_descs, num_entries_needed);
+
+	return num_entries_needed > io_sq->entries_in_tx_burst_left;
+}
+
 static inline int ena_com_write_sq_doorbell(struct ena_com_io_sq *io_sq)
 {
+	u16 max_entries_in_tx_burst = io_sq->llq_info.max_entries_in_tx_burst;
 	u16 tail = io_sq->tail;
 
 	pr_debug("write submission queue doorbell for queue: %d tail: %d\n",
@@ -134,6 +181,12 @@ static inline int ena_com_write_sq_doorbell(struct ena_com_io_sq *io_sq)
 
 	writel(tail, io_sq->db_addr);
 
+	if (is_llq_max_tx_burst_exists(io_sq)) {
+		pr_debug("reset available entries in tx burst for queue %d to %d\n",
+			 io_sq->qid, max_entries_in_tx_burst);
+		io_sq->entries_in_tx_burst_left = max_entries_in_tx_burst;
+	}
+
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index 9c8364292..d2b82f917 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -2172,6 +2172,13 @@ static netdev_tx_t ena_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	/* set flags and meta data */
 	ena_tx_csum(&ena_tx_ctx, skb);
 
+	if (unlikely(ena_com_is_doorbell_needed(tx_ring->ena_com_io_sq, &ena_tx_ctx))) {
+		netif_dbg(adapter, tx_queued, dev,
+			  "llq tx max burst size of queue %d achieved, writing doorbell to send burst\n",
+			  qid);
+		ena_com_write_sq_doorbell(tx_ring->ena_com_io_sq);
+	}
+
 	/* prepare the packet's descriptors to dma engine */
 	rc = ena_com_prepare_tx(tx_ring->ena_com_io_sq, &ena_tx_ctx,
 				&nb_hw_desc);
-- 
2.17.1

