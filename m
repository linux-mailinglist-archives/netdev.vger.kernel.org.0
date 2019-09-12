Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13163B1626
	for <lists+netdev@lfdr.de>; Fri, 13 Sep 2019 00:10:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729373AbfILWKv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Sep 2019 18:10:51 -0400
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:44194 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726937AbfILWKu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Sep 2019 18:10:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1568326248; x=1599862248;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=wbQpeQrZYsBeRQD2rGsDLDV/ALPJq9ws98lGU+5Hamc=;
  b=uDkTF9FsNOgl8ByFBiqwyoX4R2771QUVhXj4p6VwUxsZImNjC7bmArvP
   8rV3rRny2uYe0UuQViN4ki3q9FkOKaEk4y3zdGHjLlyP72GF+JpDc1YNW
   ueMhOYvIsIFZUpLb2ljO/rxur3P3ruVVyPj4R/a8ZLzcPbJYuxWkQMzm1
   0=;
X-IronPort-AV: E=Sophos;i="5.64,498,1559520000"; 
   d="scan'208";a="420914983"
Received: from iad6-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1e-c7c08562.us-east-1.amazon.com) ([10.124.125.6])
  by smtp-border-fw-out-6002.iad6.amazon.com with ESMTP; 12 Sep 2019 22:10:45 +0000
Received: from EX13MTAUWA001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1e-c7c08562.us-east-1.amazon.com (Postfix) with ESMTPS id 5C894240C31;
        Thu, 12 Sep 2019 22:10:46 +0000 (UTC)
Received: from EX13D10UWA003.ant.amazon.com (10.43.160.248) by
 EX13MTAUWA001.ant.amazon.com (10.43.160.58) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Thu, 12 Sep 2019 22:10:11 +0000
Received: from EX13MTAUWA001.ant.amazon.com (10.43.160.58) by
 EX13D10UWA003.ant.amazon.com (10.43.160.248) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Thu, 12 Sep 2019 22:10:10 +0000
Received: from HFA15-G63729NC.amazon.com (10.95.77.90) by
 mail-relay.amazon.com (10.43.160.118) with Microsoft SMTP Server id
 15.0.1367.3 via Frontend Transport; Thu, 12 Sep 2019 22:10:05 +0000
From:   <akiyano@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Arthur Kiyanovski <akiyano@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <sameehj@amazon.com>, <ndagan@amazon.com>
Subject: [PATCH V1 net-next 08/11] net: ena: remove all old adaptive rx interrupt moderation code from ena_com
Date:   Fri, 13 Sep 2019 01:08:45 +0300
Message-ID: <1568326128-4057-9-git-send-email-akiyano@amazon.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1568326128-4057-1-git-send-email-akiyano@amazon.com>
References: <1568326128-4057-1-git-send-email-akiyano@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arthur Kiyanovski <akiyano@amazon.com>

Remove previous implementation of adaptive rx interrupt moderation
from ena_com files.

Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
---
 drivers/net/ethernet/amazon/ena/ena_com.c | 110 -----------------
 drivers/net/ethernet/amazon/ena/ena_com.h | 142 ----------------------
 2 files changed, 252 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_com.c b/drivers/net/ethernet/amazon/ena/ena_com.c
index ea859ecf664d..c3f4846aa845 100644
--- a/drivers/net/ethernet/amazon/ena/ena_com.c
+++ b/drivers/net/ethernet/amazon/ena/ena_com.c
@@ -1278,22 +1278,6 @@ static int ena_com_ind_tbl_convert_from_device(struct ena_com_dev *ena_dev)
 	return 0;
 }
 
-static int ena_com_init_interrupt_moderation_table(struct ena_com_dev *ena_dev)
-{
-	size_t size;
-
-	size = sizeof(struct ena_intr_moder_entry) * ENA_INTR_MAX_NUM_OF_LEVELS;
-
-	ena_dev->intr_moder_tbl =
-		devm_kzalloc(ena_dev->dmadev, size, GFP_KERNEL);
-	if (!ena_dev->intr_moder_tbl)
-		return -ENOMEM;
-
-	ena_com_config_default_interrupt_moderation_table(ena_dev);
-
-	return 0;
-}
-
 static void ena_com_update_intr_delay_resolution(struct ena_com_dev *ena_dev,
 						 u16 intr_delay_resolution)
 {
@@ -2803,13 +2787,6 @@ int ena_com_update_nonadaptive_moderation_interval_rx(struct ena_com_dev *ena_de
 							      &ena_dev->intr_moder_rx_interval);
 }
 
-void ena_com_destroy_interrupt_moderation(struct ena_com_dev *ena_dev)
-{
-	if (ena_dev->intr_moder_tbl)
-		devm_kfree(ena_dev->dmadev, ena_dev->intr_moder_tbl);
-	ena_dev->intr_moder_tbl = NULL;
-}
-
 int ena_com_init_interrupt_moderation(struct ena_com_dev *ena_dev)
 {
 	struct ena_admin_get_feat_resp get_resp;
@@ -2834,10 +2811,6 @@ int ena_com_init_interrupt_moderation(struct ena_com_dev *ena_dev)
 		return rc;
 	}
 
-	rc = ena_com_init_interrupt_moderation_table(ena_dev);
-	if (rc)
-		goto err;
-
 	/* if moderation is supported by device we set adaptive moderation */
 	delay_resolution = get_resp.u.intr_moderation.intr_delay_resolution;
 	ena_com_update_intr_delay_resolution(ena_dev, delay_resolution);
@@ -2846,52 +2819,6 @@ int ena_com_init_interrupt_moderation(struct ena_com_dev *ena_dev)
 	ena_com_disable_adaptive_moderation(ena_dev);
 
 	return 0;
-err:
-	ena_com_destroy_interrupt_moderation(ena_dev);
-	return rc;
-}
-
-void ena_com_config_default_interrupt_moderation_table(struct ena_com_dev *ena_dev)
-{
-	struct ena_intr_moder_entry *intr_moder_tbl = ena_dev->intr_moder_tbl;
-
-	if (!intr_moder_tbl)
-		return;
-
-	intr_moder_tbl[ENA_INTR_MODER_LOWEST].intr_moder_interval =
-		ENA_INTR_LOWEST_USECS;
-	intr_moder_tbl[ENA_INTR_MODER_LOWEST].pkts_per_interval =
-		ENA_INTR_LOWEST_PKTS;
-	intr_moder_tbl[ENA_INTR_MODER_LOWEST].bytes_per_interval =
-		ENA_INTR_LOWEST_BYTES;
-
-	intr_moder_tbl[ENA_INTR_MODER_LOW].intr_moder_interval =
-		ENA_INTR_LOW_USECS;
-	intr_moder_tbl[ENA_INTR_MODER_LOW].pkts_per_interval =
-		ENA_INTR_LOW_PKTS;
-	intr_moder_tbl[ENA_INTR_MODER_LOW].bytes_per_interval =
-		ENA_INTR_LOW_BYTES;
-
-	intr_moder_tbl[ENA_INTR_MODER_MID].intr_moder_interval =
-		ENA_INTR_MID_USECS;
-	intr_moder_tbl[ENA_INTR_MODER_MID].pkts_per_interval =
-		ENA_INTR_MID_PKTS;
-	intr_moder_tbl[ENA_INTR_MODER_MID].bytes_per_interval =
-		ENA_INTR_MID_BYTES;
-
-	intr_moder_tbl[ENA_INTR_MODER_HIGH].intr_moder_interval =
-		ENA_INTR_HIGH_USECS;
-	intr_moder_tbl[ENA_INTR_MODER_HIGH].pkts_per_interval =
-		ENA_INTR_HIGH_PKTS;
-	intr_moder_tbl[ENA_INTR_MODER_HIGH].bytes_per_interval =
-		ENA_INTR_HIGH_BYTES;
-
-	intr_moder_tbl[ENA_INTR_MODER_HIGHEST].intr_moder_interval =
-		ENA_INTR_HIGHEST_USECS;
-	intr_moder_tbl[ENA_INTR_MODER_HIGHEST].pkts_per_interval =
-		ENA_INTR_HIGHEST_PKTS;
-	intr_moder_tbl[ENA_INTR_MODER_HIGHEST].bytes_per_interval =
-		ENA_INTR_HIGHEST_BYTES;
 }
 
 unsigned int ena_com_get_nonadaptive_moderation_interval_tx(struct ena_com_dev *ena_dev)
@@ -2904,43 +2831,6 @@ unsigned int ena_com_get_nonadaptive_moderation_interval_rx(struct ena_com_dev *
 	return ena_dev->intr_moder_rx_interval;
 }
 
-void ena_com_init_intr_moderation_entry(struct ena_com_dev *ena_dev,
-					enum ena_intr_moder_level level,
-					struct ena_intr_moder_entry *entry)
-{
-	struct ena_intr_moder_entry *intr_moder_tbl = ena_dev->intr_moder_tbl;
-
-	if (level >= ENA_INTR_MAX_NUM_OF_LEVELS)
-		return;
-
-	intr_moder_tbl[level].intr_moder_interval = entry->intr_moder_interval;
-	if (ena_dev->intr_delay_resolution)
-		intr_moder_tbl[level].intr_moder_interval /=
-			ena_dev->intr_delay_resolution;
-	intr_moder_tbl[level].pkts_per_interval = entry->pkts_per_interval;
-
-	/* use hardcoded value until ethtool supports bytecount parameter */
-	if (entry->bytes_per_interval != ENA_INTR_BYTE_COUNT_NOT_SUPPORTED)
-		intr_moder_tbl[level].bytes_per_interval = entry->bytes_per_interval;
-}
-
-void ena_com_get_intr_moderation_entry(struct ena_com_dev *ena_dev,
-				       enum ena_intr_moder_level level,
-				       struct ena_intr_moder_entry *entry)
-{
-	struct ena_intr_moder_entry *intr_moder_tbl = ena_dev->intr_moder_tbl;
-
-	if (level >= ENA_INTR_MAX_NUM_OF_LEVELS)
-		return;
-
-	entry->intr_moder_interval = intr_moder_tbl[level].intr_moder_interval;
-	if (ena_dev->intr_delay_resolution)
-		entry->intr_moder_interval *= ena_dev->intr_delay_resolution;
-	entry->pkts_per_interval =
-	intr_moder_tbl[level].pkts_per_interval;
-	entry->bytes_per_interval = intr_moder_tbl[level].bytes_per_interval;
-}
-
 int ena_com_config_dev_mode(struct ena_com_dev *ena_dev,
 			    struct ena_admin_feature_llq_desc *llq_features,
 			    struct ena_llq_configurations *llq_default_cfg)
diff --git a/drivers/net/ethernet/amazon/ena/ena_com.h b/drivers/net/ethernet/amazon/ena/ena_com.h
index baeefc6af4f3..ddc2a8c50333 100644
--- a/drivers/net/ethernet/amazon/ena/ena_com.h
+++ b/drivers/net/ethernet/amazon/ena/ena_com.h
@@ -72,46 +72,13 @@
 /*****************************************************************************/
 /* ENA adaptive interrupt moderation settings */
 
-#define ENA_INTR_LOWEST_USECS           (0)
-#define ENA_INTR_LOWEST_PKTS            (3)
-#define ENA_INTR_LOWEST_BYTES           (2 * 1524)
-
-#define ENA_INTR_LOW_USECS              (32)
-#define ENA_INTR_LOW_PKTS               (12)
-#define ENA_INTR_LOW_BYTES              (16 * 1024)
-
-#define ENA_INTR_MID_USECS              (80)
-#define ENA_INTR_MID_PKTS               (48)
-#define ENA_INTR_MID_BYTES              (64 * 1024)
-
-#define ENA_INTR_HIGH_USECS             (128)
-#define ENA_INTR_HIGH_PKTS              (96)
-#define ENA_INTR_HIGH_BYTES             (128 * 1024)
-
-#define ENA_INTR_HIGHEST_USECS          (192)
-#define ENA_INTR_HIGHEST_PKTS           (128)
-#define ENA_INTR_HIGHEST_BYTES          (192 * 1024)
-
 #define ENA_INTR_INITIAL_TX_INTERVAL_USECS		196
 #define ENA_INTR_INITIAL_RX_INTERVAL_USECS		0
-#define ENA_INTR_DELAY_OLD_VALUE_WEIGHT			6
-#define ENA_INTR_DELAY_NEW_VALUE_WEIGHT			4
-#define ENA_INTR_MODER_LEVEL_STRIDE			2
-#define ENA_INTR_BYTE_COUNT_NOT_SUPPORTED		0xFFFFFF
 
 #define ENA_HW_HINTS_NO_TIMEOUT				0xFFFF
 
 #define ENA_FEATURE_MAX_QUEUE_EXT_VER	1
 
-enum ena_intr_moder_level {
-	ENA_INTR_MODER_LOWEST = 0,
-	ENA_INTR_MODER_LOW,
-	ENA_INTR_MODER_MID,
-	ENA_INTR_MODER_HIGH,
-	ENA_INTR_MODER_HIGHEST,
-	ENA_INTR_MAX_NUM_OF_LEVELS,
-};
-
 struct ena_llq_configurations {
 	enum ena_admin_llq_header_location llq_header_location;
 	enum ena_admin_llq_ring_entry_size llq_ring_entry_size;
@@ -120,12 +87,6 @@ struct ena_llq_configurations {
 	u16 llq_ring_entry_size_value;
 };
 
-struct ena_intr_moder_entry {
-	unsigned int intr_moder_interval;
-	unsigned int pkts_per_interval;
-	unsigned int bytes_per_interval;
-};
-
 enum queue_direction {
 	ENA_COM_IO_QUEUE_DIRECTION_TX,
 	ENA_COM_IO_QUEUE_DIRECTION_RX
@@ -920,11 +881,6 @@ int ena_com_execute_admin_command(struct ena_com_admin_queue *admin_queue,
  */
 int ena_com_init_interrupt_moderation(struct ena_com_dev *ena_dev);
 
-/* ena_com_destroy_interrupt_moderation - Destroy interrupt moderation resources
- * @ena_dev: ENA communication layer struct
- */
-void ena_com_destroy_interrupt_moderation(struct ena_com_dev *ena_dev);
-
 /* ena_com_interrupt_moderation_supported - Return if interrupt moderation
  * capability is supported by the device.
  *
@@ -932,12 +888,6 @@ void ena_com_destroy_interrupt_moderation(struct ena_com_dev *ena_dev);
  */
 bool ena_com_interrupt_moderation_supported(struct ena_com_dev *ena_dev);
 
-/* ena_com_config_default_interrupt_moderation_table - Restore the interrupt
- * moderation table back to the default parameters.
- * @ena_dev: ENA communication layer struct
- */
-void ena_com_config_default_interrupt_moderation_table(struct ena_com_dev *ena_dev);
-
 /* ena_com_update_nonadaptive_moderation_interval_tx - Update the
  * non-adaptive interval in Tx direction.
  * @ena_dev: ENA communication layer struct
@@ -974,29 +924,6 @@ unsigned int ena_com_get_nonadaptive_moderation_interval_tx(struct ena_com_dev *
  */
 unsigned int ena_com_get_nonadaptive_moderation_interval_rx(struct ena_com_dev *ena_dev);
 
-/* ena_com_init_intr_moderation_entry - Update a single entry in the interrupt
- * moderation table.
- * @ena_dev: ENA communication layer struct
- * @level: Interrupt moderation table level
- * @entry: Entry value
- *
- * Update a single entry in the interrupt moderation table.
- */
-void ena_com_init_intr_moderation_entry(struct ena_com_dev *ena_dev,
-					enum ena_intr_moder_level level,
-					struct ena_intr_moder_entry *entry);
-
-/* ena_com_get_intr_moderation_entry - Init ena_intr_moder_entry.
- * @ena_dev: ENA communication layer struct
- * @level: Interrupt moderation table level
- * @entry: Entry to fill.
- *
- * Initialize the entry according to the adaptive interrupt moderation table.
- */
-void ena_com_get_intr_moderation_entry(struct ena_com_dev *ena_dev,
-				       enum ena_intr_moder_level level,
-				       struct ena_intr_moder_entry *entry);
-
 /* ena_com_config_dev_mode - Configure the placement policy of the device.
  * @ena_dev: ENA communication layer struct
  * @llq_features: LLQ feature descriptor, retrieve via
@@ -1022,75 +949,6 @@ static inline void ena_com_disable_adaptive_moderation(struct ena_com_dev *ena_d
 	ena_dev->adaptive_coalescing = false;
 }
 
-/* ena_com_calculate_interrupt_delay - Calculate new interrupt delay
- * @ena_dev: ENA communication layer struct
- * @pkts: Number of packets since the last update
- * @bytes: Number of bytes received since the last update.
- * @smoothed_interval: Returned interval
- * @moder_tbl_idx: Current table level as input update new level as return
- * value.
- */
-static inline void ena_com_calculate_interrupt_delay(struct ena_com_dev *ena_dev,
-						     unsigned int pkts,
-						     unsigned int bytes,
-						     unsigned int *smoothed_interval,
-						     unsigned int *moder_tbl_idx)
-{
-	enum ena_intr_moder_level curr_moder_idx, new_moder_idx;
-	struct ena_intr_moder_entry *curr_moder_entry;
-	struct ena_intr_moder_entry *pred_moder_entry;
-	struct ena_intr_moder_entry *new_moder_entry;
-	struct ena_intr_moder_entry *intr_moder_tbl = ena_dev->intr_moder_tbl;
-	unsigned int interval;
-
-	/* We apply adaptive moderation on Rx path only.
-	 * Tx uses static interrupt moderation.
-	 */
-	if (!pkts || !bytes)
-		/* Tx interrupt, or spurious interrupt,
-		 * in both cases we just use same delay values
-		 */
-		return;
-
-	curr_moder_idx = (enum ena_intr_moder_level)(*moder_tbl_idx);
-	if (unlikely(curr_moder_idx >= ENA_INTR_MAX_NUM_OF_LEVELS)) {
-		pr_err("Wrong moderation index %u\n", curr_moder_idx);
-		return;
-	}
-
-	curr_moder_entry = &intr_moder_tbl[curr_moder_idx];
-	new_moder_idx = curr_moder_idx;
-
-	if (curr_moder_idx == ENA_INTR_MODER_LOWEST) {
-		if ((pkts > curr_moder_entry->pkts_per_interval) ||
-		    (bytes > curr_moder_entry->bytes_per_interval))
-			new_moder_idx =
-				(enum ena_intr_moder_level)(curr_moder_idx + ENA_INTR_MODER_LEVEL_STRIDE);
-	} else {
-		pred_moder_entry = &intr_moder_tbl[curr_moder_idx - ENA_INTR_MODER_LEVEL_STRIDE];
-
-		if ((pkts <= pred_moder_entry->pkts_per_interval) ||
-		    (bytes <= pred_moder_entry->bytes_per_interval))
-			new_moder_idx =
-				(enum ena_intr_moder_level)(curr_moder_idx - ENA_INTR_MODER_LEVEL_STRIDE);
-		else if ((pkts > curr_moder_entry->pkts_per_interval) ||
-			 (bytes > curr_moder_entry->bytes_per_interval)) {
-			if (curr_moder_idx != ENA_INTR_MODER_HIGHEST)
-				new_moder_idx =
-					(enum ena_intr_moder_level)(curr_moder_idx + ENA_INTR_MODER_LEVEL_STRIDE);
-		}
-	}
-	new_moder_entry = &intr_moder_tbl[new_moder_idx];
-
-	interval = new_moder_entry->intr_moder_interval;
-	*smoothed_interval = (
-		(interval * ENA_INTR_DELAY_NEW_VALUE_WEIGHT +
-		ENA_INTR_DELAY_OLD_VALUE_WEIGHT * (*smoothed_interval)) + 5) /
-		10;
-
-	*moder_tbl_idx = new_moder_idx;
-}
-
 /* ena_com_update_intr_reg - Prepare interrupt register
  * @intr_reg: interrupt register to update.
  * @rx_delay_interval: Rx interval in usecs
-- 
2.17.2

