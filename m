Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BDA86B161F
	for <lists+netdev@lfdr.de>; Fri, 13 Sep 2019 00:09:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729275AbfILWJx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Sep 2019 18:09:53 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:12163 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726937AbfILWJx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Sep 2019 18:09:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1568326192; x=1599862192;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=3NUsmoknub72PrhO1cTpYeGAtXXUE+3HnufiEej7DvA=;
  b=bKz614qkfEEE4ufKpTx3ODhfxYH3521Kxu9PkfdQp4ay3MeYfglotdTg
   aysJh1l3+L8hcZX0IHKmupuE6ePwelWZi++9ZiZ7wCh9nkBNKCbqcjR+A
   6+Rs2FVRGjIm/Wk9rgHaPqwtH8A5IRHSprViOtwXz8gePrYnXQH1JhBVx
   I=;
X-IronPort-AV: E=Sophos;i="5.64,498,1559520000"; 
   d="scan'208";a="831292445"
Received: from sea3-co-svc-lb6-vlan2.sea.amazon.com (HELO email-inbound-relay-1a-16acd5e0.us-east-1.amazon.com) ([10.47.22.34])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 12 Sep 2019 22:09:49 +0000
Received: from EX13MTAUWA001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1a-16acd5e0.us-east-1.amazon.com (Postfix) with ESMTPS id A522FA2470;
        Thu, 12 Sep 2019 22:09:49 +0000 (UTC)
Received: from EX13D21UWA003.ant.amazon.com (10.43.160.184) by
 EX13MTAUWA001.ant.amazon.com (10.43.160.118) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Thu, 12 Sep 2019 22:09:31 +0000
Received: from EX13MTAUWA001.ant.amazon.com (10.43.160.58) by
 EX13D21UWA003.ant.amazon.com (10.43.160.184) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Thu, 12 Sep 2019 22:09:31 +0000
Received: from HFA15-G63729NC.amazon.com (10.95.77.90) by
 mail-relay.amazon.com (10.43.160.118) with Microsoft SMTP Server id
 15.0.1367.3 via Frontend Transport; Thu, 12 Sep 2019 22:09:23 +0000
From:   <akiyano@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Arthur Kiyanovski <akiyano@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <sameehj@amazon.com>, <ndagan@amazon.com>
Subject: [PATCH V1 net-next 03/11] net: ena: reimplement set/get_coalesce()
Date:   Fri, 13 Sep 2019 01:08:40 +0300
Message-ID: <1568326128-4057-4-git-send-email-akiyano@amazon.com>
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

