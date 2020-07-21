Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E93EC228121
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 15:39:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728494AbgGUNjg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 09:39:36 -0400
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:48390 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726654AbgGUNjg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 09:39:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1595338774; x=1626874774;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=xFkje4D14xgNvm8ZphZt2ox4ro9g8sYw5/vPXbS/QY0=;
  b=M7xxjp93z75E1TNwbYPR9k9wASxce/fClMLO8uT+9EVXo2tSrxRuIjr9
   Ps4vPsmykBHBiMnrezQKE5eBYb+p+oPZLia3pTJDrNGsJKRbSRORg44Gm
   WMtIWk2eB0MUAh0U6kYs+fwUo5IY4P4K0Wuq2WjMrO2RelAW8pOYKKd8f
   4=;
IronPort-SDR: UfZqRoTqgzuRIhnwL3/hKwkgh1fYH5UWjZ5MdHCE0KbMYdpMbO6aJi/pxwX6YCqrXARTqDLCk1
 kiSDZd0QWh8A==
X-IronPort-AV: E=Sophos;i="5.75,379,1589241600"; 
   d="scan'208";a="43139242"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1d-f273de60.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-2101.iad2.amazon.com with ESMTP; 21 Jul 2020 13:39:33 +0000
Received: from EX13MTAUWA001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1d-f273de60.us-east-1.amazon.com (Postfix) with ESMTPS id B47AEA22EB;
        Tue, 21 Jul 2020 13:39:32 +0000 (UTC)
Received: from EX13D10UWA002.ant.amazon.com (10.43.160.228) by
 EX13MTAUWA001.ant.amazon.com (10.43.160.118) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 21 Jul 2020 13:39:10 +0000
Received: from EX13MTAUWA001.ant.amazon.com (10.43.160.58) by
 EX13D10UWA002.ant.amazon.com (10.43.160.228) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 21 Jul 2020 13:39:10 +0000
Received: from HFA15-G63729NC.amazon.com (10.1.213.6) by mail-relay.amazon.com
 (10.43.160.118) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 21 Jul 2020 13:39:05 +0000
From:   <akiyano@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Arthur Kiyanovski <akiyano@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <ndagan@amazon.com>, <shayagr@amazon.com>,
        <sameehj@amazon.com>
Subject: [PATCH V3 net-next 8/8] net: ena: support new LLQ acceleration mode
Date:   Tue, 21 Jul 2020 16:38:11 +0300
Message-ID: <1595338691-3130-9-git-send-email-akiyano@amazon.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1595338691-3130-1-git-send-email-akiyano@amazon.com>
References: <1595338691-3130-1-git-send-email-akiyano@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arthur Kiyanovski <akiyano@amazon.com>

New devices add a new hardware acceleration engine, which adds some
restrictions to the driver.
Metadata descriptor must be present for each packet and the maximum
burst size between two doorbells is now limited to a number
advertised by the device.

This patch adds:
1. A handshake protocol between the driver and the device, so the
device will enable the accelerated queues only when both sides
support it.

2. The driver support for the new acceleration engine:
2.1. Send metadata descriptor for each Tx packet.
2.2. Limit the number of packets sent between doorbells.(*)

(*) A previous driver implementation of this feature was comitted in
commit 05d62ca218f8 ("net: ena: add handling of llq max tx burst size")
however the design of the interface between the driver and device
changed since then. This change is reflected in this commit.

Signed-off-by: Netanel Belgazal <netanel@amazon.com>
Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
---
 .../net/ethernet/amazon/ena/ena_admin_defs.h  | 39 ++++++++++++--
 drivers/net/ethernet/amazon/ena/ena_com.c     | 19 ++++++-
 drivers/net/ethernet/amazon/ena/ena_com.h     |  3 ++
 drivers/net/ethernet/amazon/ena/ena_eth_com.c | 51 +++++++++++++------
 drivers/net/ethernet/amazon/ena/ena_eth_com.h |  3 +-
 drivers/net/ethernet/amazon/ena/ena_netdev.c  | 16 ++++--
 drivers/net/ethernet/amazon/ena/ena_netdev.h  |  2 +
 7 files changed, 109 insertions(+), 24 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_admin_defs.h b/drivers/net/ethernet/amazon/ena/ena_admin_defs.h
index 7f7978b135a9..b818a169c193 100644
--- a/drivers/net/ethernet/amazon/ena/ena_admin_defs.h
+++ b/drivers/net/ethernet/amazon/ena/ena_admin_defs.h
@@ -491,6 +491,36 @@ enum ena_admin_llq_stride_ctrl {
 	ENA_ADMIN_MULTIPLE_DESCS_PER_ENTRY          = 2,
 };
 
+enum ena_admin_accel_mode_feat {
+	ENA_ADMIN_DISABLE_META_CACHING              = 0,
+	ENA_ADMIN_LIMIT_TX_BURST                    = 1,
+};
+
+struct ena_admin_accel_mode_get {
+	/* bit field of enum ena_admin_accel_mode_feat */
+	u16 supported_flags;
+
+	/* maximum burst size between two doorbells. The size is in bytes */
+	u16 max_tx_burst_size;
+};
+
+struct ena_admin_accel_mode_set {
+	/* bit field of enum ena_admin_accel_mode_feat */
+	u16 enabled_flags;
+
+	u16 reserved;
+};
+
+struct ena_admin_accel_mode_req {
+	union {
+		u32 raw[2];
+
+		struct ena_admin_accel_mode_get get;
+
+		struct ena_admin_accel_mode_set set;
+	} u;
+};
+
 struct ena_admin_feature_llq_desc {
 	u32 max_llq_num;
 
@@ -536,10 +566,13 @@ struct ena_admin_feature_llq_desc {
 	/* the stride control the driver selected to use */
 	u16 descriptors_stride_ctrl_enabled;
 
-	/* Maximum size in bytes taken by llq entries in a single tx burst.
-	 * Set to 0 when there is no such limit.
+	/* reserved */
+	u32 reserved1;
+
+	/* accelerated low latency queues requirement. driver needs to
+	 * support those requirements in order to use accelerated llq
 	 */
-	u32 max_tx_burst_size;
+	struct ena_admin_accel_mode_req accel_mode;
 };
 
 struct ena_admin_queue_ext_feature_fields {
diff --git a/drivers/net/ethernet/amazon/ena/ena_com.c b/drivers/net/ethernet/amazon/ena/ena_com.c
index 432f143559a1..435bf05a853c 100644
--- a/drivers/net/ethernet/amazon/ena/ena_com.c
+++ b/drivers/net/ethernet/amazon/ena/ena_com.c
@@ -403,6 +403,8 @@ static int ena_com_init_io_sq(struct ena_com_dev *ena_dev,
 		       0x0, io_sq->llq_info.desc_list_entry_size);
 		io_sq->llq_buf_ctrl.descs_left_in_line =
 			io_sq->llq_info.descs_num_before_header;
+		io_sq->disable_meta_caching =
+			io_sq->llq_info.disable_meta_caching;
 
 		if (io_sq->llq_info.max_entries_in_tx_burst > 0)
 			io_sq->entries_in_tx_burst_left =
@@ -626,6 +628,10 @@ static int ena_com_set_llq(struct ena_com_dev *ena_dev)
 	cmd.u.llq.desc_num_before_header_enabled = llq_info->descs_num_before_header;
 	cmd.u.llq.descriptors_stride_ctrl_enabled = llq_info->desc_stride_ctrl;
 
+	cmd.u.llq.accel_mode.u.set.enabled_flags =
+		BIT(ENA_ADMIN_DISABLE_META_CACHING) |
+		BIT(ENA_ADMIN_LIMIT_TX_BURST);
+
 	ret = ena_com_execute_admin_command(admin_queue,
 					    (struct ena_admin_aq_entry *)&cmd,
 					    sizeof(cmd),
@@ -643,6 +649,7 @@ static int ena_com_config_llq_info(struct ena_com_dev *ena_dev,
 				   struct ena_llq_configurations *llq_default_cfg)
 {
 	struct ena_com_llq_info *llq_info = &ena_dev->llq_info;
+	struct ena_admin_accel_mode_get llq_accel_mode_get;
 	u16 supported_feat;
 	int rc;
 
@@ -742,9 +749,17 @@ static int ena_com_config_llq_info(struct ena_com_dev *ena_dev,
 		       llq_default_cfg->llq_num_decs_before_header,
 		       supported_feat, llq_info->descs_num_before_header);
 	}
+	/* Check for accelerated queue supported */
+	llq_accel_mode_get = llq_features->accel_mode.u.get;
+
+	llq_info->disable_meta_caching =
+		!!(llq_accel_mode_get.supported_flags &
+		   BIT(ENA_ADMIN_DISABLE_META_CACHING));
 
-	llq_info->max_entries_in_tx_burst =
-		(u16)(llq_features->max_tx_burst_size /	llq_default_cfg->llq_ring_entry_size_value);
+	if (llq_accel_mode_get.supported_flags & BIT(ENA_ADMIN_LIMIT_TX_BURST))
+		llq_info->max_entries_in_tx_burst =
+			llq_accel_mode_get.max_tx_burst_size /
+			llq_default_cfg->llq_ring_entry_size_value;
 
 	rc = ena_com_set_llq(ena_dev);
 	if (rc)
diff --git a/drivers/net/ethernet/amazon/ena/ena_com.h b/drivers/net/ethernet/amazon/ena/ena_com.h
index 4c98f6f07882..4287d47b2b0b 100644
--- a/drivers/net/ethernet/amazon/ena/ena_com.h
+++ b/drivers/net/ethernet/amazon/ena/ena_com.h
@@ -127,6 +127,7 @@ struct ena_com_llq_info {
 	u16 descs_num_before_header;
 	u16 descs_per_entry;
 	u16 max_entries_in_tx_burst;
+	bool disable_meta_caching;
 };
 
 struct ena_com_io_cq {
@@ -189,6 +190,8 @@ struct ena_com_io_sq {
 	enum queue_direction direction;
 	enum ena_admin_placement_policy_type mem_queue_type;
 
+	bool disable_meta_caching;
+
 	u32 msix_vector;
 	struct ena_com_tx_meta cached_tx_meta;
 	struct ena_com_llq_info llq_info;
diff --git a/drivers/net/ethernet/amazon/ena/ena_eth_com.c b/drivers/net/ethernet/amazon/ena/ena_eth_com.c
index ec8ea25e988d..ccd440589565 100644
--- a/drivers/net/ethernet/amazon/ena/ena_eth_com.c
+++ b/drivers/net/ethernet/amazon/ena/ena_eth_com.c
@@ -285,11 +285,10 @@ static u16 ena_com_cdesc_rx_pkt_get(struct ena_com_io_cq *io_cq,
 	return count;
 }
 
-static int ena_com_create_and_store_tx_meta_desc(struct ena_com_io_sq *io_sq,
-							struct ena_com_tx_ctx *ena_tx_ctx)
+static int ena_com_create_meta(struct ena_com_io_sq *io_sq,
+			       struct ena_com_tx_meta *ena_meta)
 {
 	struct ena_eth_io_tx_meta_desc *meta_desc = NULL;
-	struct ena_com_tx_meta *ena_meta = &ena_tx_ctx->ena_meta;
 
 	meta_desc = get_sq_desc(io_sq);
 	memset(meta_desc, 0x0, sizeof(struct ena_eth_io_tx_meta_desc));
@@ -309,12 +308,13 @@ static int ena_com_create_and_store_tx_meta_desc(struct ena_com_io_sq *io_sq,
 
 	/* Extended meta desc */
 	meta_desc->len_ctrl |= ENA_ETH_IO_TX_META_DESC_ETH_META_TYPE_MASK;
-	meta_desc->len_ctrl |= ENA_ETH_IO_TX_META_DESC_META_STORE_MASK;
 	meta_desc->len_ctrl |= (io_sq->phase <<
 		ENA_ETH_IO_TX_META_DESC_PHASE_SHIFT) &
 		ENA_ETH_IO_TX_META_DESC_PHASE_MASK;
 
 	meta_desc->len_ctrl |= ENA_ETH_IO_TX_META_DESC_FIRST_MASK;
+	meta_desc->len_ctrl |= ENA_ETH_IO_TX_META_DESC_META_STORE_MASK;
+
 	meta_desc->word2 |= ena_meta->l3_hdr_len &
 		ENA_ETH_IO_TX_META_DESC_L3_HDR_LEN_MASK;
 	meta_desc->word2 |= (ena_meta->l3_hdr_offset <<
@@ -325,13 +325,36 @@ static int ena_com_create_and_store_tx_meta_desc(struct ena_com_io_sq *io_sq,
 		ENA_ETH_IO_TX_META_DESC_L4_HDR_LEN_IN_WORDS_SHIFT) &
 		ENA_ETH_IO_TX_META_DESC_L4_HDR_LEN_IN_WORDS_MASK;
 
-	meta_desc->len_ctrl |= ENA_ETH_IO_TX_META_DESC_META_STORE_MASK;
+	return ena_com_sq_update_tail(io_sq);
+}
+
+static int ena_com_create_and_store_tx_meta_desc(struct ena_com_io_sq *io_sq,
+						 struct ena_com_tx_ctx *ena_tx_ctx,
+						 bool *have_meta)
+{
+	struct ena_com_tx_meta *ena_meta = &ena_tx_ctx->ena_meta;
 
-	/* Cached the meta desc */
-	memcpy(&io_sq->cached_tx_meta, ena_meta,
-	       sizeof(struct ena_com_tx_meta));
+	/* When disable meta caching is set, don't bother to save the meta and
+	 * compare it to the stored version, just create the meta
+	 */
+	if (io_sq->disable_meta_caching) {
+		if (unlikely(!ena_tx_ctx->meta_valid))
+			return -EINVAL;
 
-	return ena_com_sq_update_tail(io_sq);
+		*have_meta = true;
+		return ena_com_create_meta(io_sq, ena_meta);
+	}
+
+	if (ena_com_meta_desc_changed(io_sq, ena_tx_ctx)) {
+		*have_meta = true;
+		/* Cache the meta desc */
+		memcpy(&io_sq->cached_tx_meta, ena_meta,
+		       sizeof(struct ena_com_tx_meta));
+		return ena_com_create_meta(io_sq, ena_meta);
+	}
+
+	*have_meta = false;
+	return 0;
 }
 
 static void ena_com_rx_set_flags(struct ena_com_rx_ctx *ena_rx_ctx,
@@ -402,12 +425,10 @@ int ena_com_prepare_tx(struct ena_com_io_sq *io_sq,
 	if (unlikely(rc))
 		return rc;
 
-	have_meta = ena_tx_ctx->meta_valid && ena_com_meta_desc_changed(io_sq,
-			ena_tx_ctx);
-	if (have_meta) {
-		rc = ena_com_create_and_store_tx_meta_desc(io_sq, ena_tx_ctx);
-		if (unlikely(rc))
-			return rc;
+	rc = ena_com_create_and_store_tx_meta_desc(io_sq, ena_tx_ctx, &have_meta);
+	if (unlikely(rc)) {
+		pr_err("failed to create and store tx meta desc\n");
+		return rc;
 	}
 
 	/* If the caller doesn't want to send packets */
diff --git a/drivers/net/ethernet/amazon/ena/ena_eth_com.h b/drivers/net/ethernet/amazon/ena/ena_eth_com.h
index 8b1afd3b32f2..b6592cb93b04 100644
--- a/drivers/net/ethernet/amazon/ena/ena_eth_com.h
+++ b/drivers/net/ethernet/amazon/ena/ena_eth_com.h
@@ -157,7 +157,8 @@ static inline bool ena_com_is_doorbell_needed(struct ena_com_io_sq *io_sq,
 	llq_info = &io_sq->llq_info;
 	num_descs = ena_tx_ctx->num_bufs;
 
-	if (unlikely(ena_com_meta_desc_changed(io_sq, ena_tx_ctx)))
+	if (llq_info->disable_meta_caching ||
+	    unlikely(ena_com_meta_desc_changed(io_sq, ena_tx_ctx)))
 		++num_descs;
 
 	if (num_descs > llq_info->descs_num_before_header) {
diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index 913d698b9834..6478c1e0d137 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -655,6 +655,7 @@ static void ena_init_io_rings(struct ena_adapter *adapter,
 		txr->sgl_size = adapter->max_tx_sgl_size;
 		txr->smoothed_interval =
 			ena_com_get_nonadaptive_moderation_interval_tx(ena_dev);
+		txr->disable_meta_caching = adapter->disable_meta_caching;
 
 		/* Don't init RX queues for xdp queues */
 		if (!ENA_IS_XDP_INDEX(adapter, i)) {
@@ -2783,7 +2784,9 @@ int ena_update_queue_count(struct ena_adapter *adapter, u32 new_channel_count)
 	return dev_was_up ? ena_open(adapter->netdev) : 0;
 }
 
-static void ena_tx_csum(struct ena_com_tx_ctx *ena_tx_ctx, struct sk_buff *skb)
+static void ena_tx_csum(struct ena_com_tx_ctx *ena_tx_ctx,
+			struct sk_buff *skb,
+			bool disable_meta_caching)
 {
 	u32 mss = skb_shinfo(skb)->gso_size;
 	struct ena_com_tx_meta *ena_meta = &ena_tx_ctx->ena_meta;
@@ -2827,7 +2830,9 @@ static void ena_tx_csum(struct ena_com_tx_ctx *ena_tx_ctx, struct sk_buff *skb)
 		ena_meta->l3_hdr_len = skb_network_header_len(skb);
 		ena_meta->l3_hdr_offset = skb_network_offset(skb);
 		ena_tx_ctx->meta_valid = 1;
-
+	} else if (disable_meta_caching) {
+		memset(ena_meta, 0, sizeof(*ena_meta));
+		ena_tx_ctx->meta_valid = 1;
 	} else {
 		ena_tx_ctx->meta_valid = 0;
 	}
@@ -3011,7 +3016,7 @@ static netdev_tx_t ena_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	ena_tx_ctx.header_len = header_len;
 
 	/* set flags and meta data */
-	ena_tx_csum(&ena_tx_ctx, skb);
+	ena_tx_csum(&ena_tx_ctx, skb, tx_ring->disable_meta_caching);
 
 	rc = ena_xmit_common(dev,
 			     tx_ring,
@@ -4260,6 +4265,11 @@ static int ena_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	adapter->xdp_num_queues = 0;
 
 	adapter->rx_copybreak = ENA_DEFAULT_RX_COPYBREAK;
+	if (ena_dev->tx_mem_queue_type == ENA_ADMIN_PLACEMENT_POLICY_DEV)
+		adapter->disable_meta_caching =
+			!!(get_feat_ctx.llq.accel_mode.u.get.supported_flags &
+			   BIT(ENA_ADMIN_DISABLE_META_CACHING));
+
 	adapter->wd_state = wd_state;
 
 	snprintf(adapter->name, ENA_NAME_MAX_LEN, "ena_%d", adapters_found);
diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.h b/drivers/net/ethernet/amazon/ena/ena_netdev.h
index 89304b403995..0c8504006247 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.h
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.h
@@ -298,6 +298,7 @@ struct ena_ring {
 	u8 tx_max_header_size;
 
 	bool first_interrupt;
+	bool disable_meta_caching;
 	u16 no_interrupt_event_cnt;
 
 	/* cpu for TPH */
@@ -399,6 +400,7 @@ struct ena_adapter {
 
 	bool wd_state;
 	bool dev_up_before_reset;
+	bool disable_meta_caching;
 	unsigned long last_keep_alive_jiffies;
 
 	struct u64_stats_sync syncp;
-- 
2.23.3

