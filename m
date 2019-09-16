Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15F33B3958
	for <lists+netdev@lfdr.de>; Mon, 16 Sep 2019 13:32:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725912AbfIPLcK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Sep 2019 07:32:10 -0400
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:9889 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731431AbfIPLcK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Sep 2019 07:32:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1568633528; x=1600169528;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=3NUsmoknub72PrhO1cTpYeGAtXXUE+3HnufiEej7DvA=;
  b=WgB0EsgvQx7LRipaOuCoagQ3Ld/V8EojFMOT2Kpwb8h9KCvSneOkRmy4
   PAUba8qCxEpoTP4uAJT9vOLOD0CwDBAwZMKjCQ9KUOO65r+Y9J/QlOn1X
   hAxP29gyKMmoRJOFKzqamK9Tvz9wkSYVIYOdVNLaLs8z18gSRv8foNbyZ
   U=;
X-IronPort-AV: E=Sophos;i="5.64,512,1559520000"; 
   d="scan'208";a="785141919"
Received: from iad6-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1e-97fdccfd.us-east-1.amazon.com) ([10.124.125.6])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP; 16 Sep 2019 11:32:06 +0000
Received: from EX13MTAUEA001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1e-97fdccfd.us-east-1.amazon.com (Postfix) with ESMTPS id 51ACCA2163;
        Mon, 16 Sep 2019 11:32:06 +0000 (UTC)
Received: from EX13D08UEE004.ant.amazon.com (10.43.62.182) by
 EX13MTAUEA001.ant.amazon.com (10.43.61.82) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Mon, 16 Sep 2019 11:31:51 +0000
Received: from EX13MTAUEE001.ant.amazon.com (10.43.62.200) by
 EX13D08UEE004.ant.amazon.com (10.43.62.182) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Mon, 16 Sep 2019 11:31:51 +0000
Received: from HFA15-G63729NC.hfa16.amazon.com (10.218.52.89) by
 mail-relay.amazon.com (10.43.62.226) with Microsoft SMTP Server id
 15.0.1367.3 via Frontend Transport; Mon, 16 Sep 2019 11:31:48 +0000
From:   <akiyano@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Arthur Kiyanovski <akiyano@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <sameehj@amazon.com>, <ndagan@amazon.com>
Subject: [PATCH V2 net-next 03/11] net: ena: reimplement set/get_coalesce()
Date:   Mon, 16 Sep 2019 14:31:28 +0300
Message-ID: <1568633496-4143-4-git-send-email-akiyano@amazon.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1568633496-4143-1-git-send-email-akiyano@amazon.com>
References: <1568633496-4143-1-git-send-email-akiyano@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arthur Kiyanovski <akiyano@amazon.com>

1. Remove old adaptive interrupt moderation code from set/get_coalesce()
2. Add ena_update_rx_rings_intr_moderation() function for updating
   nonadaptive interrupt moderation intervals similarly to
   ena_update_tx_rings_intr_moderation().
3. Remove checks of multiple unsupported received interrupt coalescing
   parameters. This makes code cleaner and cancels the need to update
   it every time a new coalescing parameter is invented.

Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
---
 drivers/net/ethernet/amazon/ena/ena_ethtool.c | 84 ++++++-------------
 1 file changed, 26 insertions(+), 58 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_ethtool.c b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
index b997c3ce9e2b..0f90e2296630 100644
--- a/drivers/net/ethernet/amazon/ena/ena_ethtool.c
+++ b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
@@ -305,7 +305,6 @@ static int ena_get_coalesce(struct net_device *net_dev,
 {
 	struct ena_adapter *adapter = netdev_priv(net_dev);
 	struct ena_com_dev *ena_dev = adapter->ena_dev;
-	struct ena_intr_moder_entry intr_moder_entry;
 
 	if (!ena_com_interrupt_moderation_supported(ena_dev)) {
 		/* the devie doesn't support interrupt moderation */
@@ -314,23 +313,12 @@ static int ena_get_coalesce(struct net_device *net_dev,
 	coalesce->tx_coalesce_usecs =
 		ena_com_get_nonadaptive_moderation_interval_tx(ena_dev) /
 			ena_dev->intr_delay_resolution;
-	if (!ena_com_get_adaptive_moderation_enabled(ena_dev)) {
+
+	if (!ena_com_get_adaptive_moderation_enabled(ena_dev))
 		coalesce->rx_coalesce_usecs =
 			ena_com_get_nonadaptive_moderation_interval_rx(ena_dev)
 			/ ena_dev->intr_delay_resolution;
-	} else {
-		ena_com_get_intr_moderation_entry(adapter->ena_dev, ENA_INTR_MODER_LOWEST, &intr_moder_entry);
-		coalesce->rx_coalesce_usecs_low = intr_moder_entry.intr_moder_interval;
-		coalesce->rx_max_coalesced_frames_low = intr_moder_entry.pkts_per_interval;
-
-		ena_com_get_intr_moderation_entry(adapter->ena_dev, ENA_INTR_MODER_MID, &intr_moder_entry);
-		coalesce->rx_coalesce_usecs = intr_moder_entry.intr_moder_interval;
-		coalesce->rx_max_coalesced_frames = intr_moder_entry.pkts_per_interval;
-
-		ena_com_get_intr_moderation_entry(adapter->ena_dev, ENA_INTR_MODER_HIGHEST, &intr_moder_entry);
-		coalesce->rx_coalesce_usecs_high = intr_moder_entry.intr_moder_interval;
-		coalesce->rx_max_coalesced_frames_high = intr_moder_entry.pkts_per_interval;
-	}
+
 	coalesce->use_adaptive_rx_coalesce =
 		ena_com_get_adaptive_moderation_enabled(ena_dev);
 
@@ -348,12 +336,22 @@ static void ena_update_tx_rings_intr_moderation(struct ena_adapter *adapter)
 		adapter->tx_ring[i].smoothed_interval = val;
 }
 
+static void ena_update_rx_rings_intr_moderation(struct ena_adapter *adapter)
+{
+	unsigned int val;
+	int i;
+
+	val = ena_com_get_nonadaptive_moderation_interval_rx(adapter->ena_dev);
+
+	for (i = 0; i < adapter->num_queues; i++)
+		adapter->rx_ring[i].smoothed_interval = val;
+}
+
 static int ena_set_coalesce(struct net_device *net_dev,
 			    struct ethtool_coalesce *coalesce)
 {
 	struct ena_adapter *adapter = netdev_priv(net_dev);
 	struct ena_com_dev *ena_dev = adapter->ena_dev;
-	struct ena_intr_moder_entry intr_moder_entry;
 	int rc;
 
 	if (!ena_com_interrupt_moderation_supported(ena_dev)) {
@@ -361,22 +359,6 @@ static int ena_set_coalesce(struct net_device *net_dev,
 		return -EOPNOTSUPP;
 	}
 
-	if (coalesce->rx_coalesce_usecs_irq ||
-	    coalesce->rx_max_coalesced_frames_irq ||
-	    coalesce->tx_coalesce_usecs_irq ||
-	    coalesce->tx_max_coalesced_frames ||
-	    coalesce->tx_max_coalesced_frames_irq ||
-	    coalesce->stats_block_coalesce_usecs ||
-	    coalesce->use_adaptive_tx_coalesce ||
-	    coalesce->pkt_rate_low ||
-	    coalesce->tx_coalesce_usecs_low ||
-	    coalesce->tx_max_coalesced_frames_low ||
-	    coalesce->pkt_rate_high ||
-	    coalesce->tx_coalesce_usecs_high ||
-	    coalesce->tx_max_coalesced_frames_high ||
-	    coalesce->rate_sample_interval)
-		return -EINVAL;
-
 	rc = ena_com_update_nonadaptive_moderation_interval_tx(ena_dev,
 							       coalesce->tx_coalesce_usecs);
 	if (rc)
@@ -384,37 +366,23 @@ static int ena_set_coalesce(struct net_device *net_dev,
 
 	ena_update_tx_rings_intr_moderation(adapter);
 
-	if (ena_com_get_adaptive_moderation_enabled(ena_dev)) {
-		if (!coalesce->use_adaptive_rx_coalesce) {
-			ena_com_disable_adaptive_moderation(ena_dev);
-			rc = ena_com_update_nonadaptive_moderation_interval_rx(ena_dev,
-									       coalesce->rx_coalesce_usecs);
-			return rc;
-		}
-	} else { /* was in non-adaptive mode */
-		if (coalesce->use_adaptive_rx_coalesce) {
+	if (coalesce->use_adaptive_rx_coalesce) {
+		if (!ena_com_get_adaptive_moderation_enabled(ena_dev))
 			ena_com_enable_adaptive_moderation(ena_dev);
-		} else {
-			rc = ena_com_update_nonadaptive_moderation_interval_rx(ena_dev,
-									       coalesce->rx_coalesce_usecs);
-			return rc;
-		}
+		return 0;
 	}
 
-	intr_moder_entry.intr_moder_interval = coalesce->rx_coalesce_usecs_low;
-	intr_moder_entry.pkts_per_interval = coalesce->rx_max_coalesced_frames_low;
-	intr_moder_entry.bytes_per_interval = ENA_INTR_BYTE_COUNT_NOT_SUPPORTED;
-	ena_com_init_intr_moderation_entry(adapter->ena_dev, ENA_INTR_MODER_LOWEST, &intr_moder_entry);
+	rc = ena_com_update_nonadaptive_moderation_interval_rx(ena_dev,
+							       coalesce->rx_coalesce_usecs);
+	if (rc)
+		return rc;
 
-	intr_moder_entry.intr_moder_interval = coalesce->rx_coalesce_usecs;
-	intr_moder_entry.pkts_per_interval = coalesce->rx_max_coalesced_frames;
-	intr_moder_entry.bytes_per_interval = ENA_INTR_BYTE_COUNT_NOT_SUPPORTED;
-	ena_com_init_intr_moderation_entry(adapter->ena_dev, ENA_INTR_MODER_MID, &intr_moder_entry);
+	ena_update_rx_rings_intr_moderation(adapter);
 
-	intr_moder_entry.intr_moder_interval = coalesce->rx_coalesce_usecs_high;
-	intr_moder_entry.pkts_per_interval = coalesce->rx_max_coalesced_frames_high;
-	intr_moder_entry.bytes_per_interval = ENA_INTR_BYTE_COUNT_NOT_SUPPORTED;
-	ena_com_init_intr_moderation_entry(adapter->ena_dev, ENA_INTR_MODER_HIGHEST, &intr_moder_entry);
+	if (!coalesce->use_adaptive_rx_coalesce) {
+		if (ena_com_get_adaptive_moderation_enabled(ena_dev))
+			ena_com_disable_adaptive_moderation(ena_dev);
+	}
 
 	return 0;
 }
-- 
2.17.2

