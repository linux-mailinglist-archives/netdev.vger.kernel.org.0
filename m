Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B06972653BF
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 23:40:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728216AbgIJVkI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 17:40:08 -0400
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:3344 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730356AbgIJNH0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 09:07:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1599743246; x=1631279246;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=p0QYqEIWUCVTbqMI3V2KGkzCD9u7Axc2x6Ti2Zu/AMo=;
  b=W5lDb5zquSuWNW5hFt/Wu1lGSIM+nFu17gUSz1n9z9XmFT+SFASAFrCA
   lEFtb4fC6THepmdtp1V+8EmOTAT7yhdqx+nEu0JRmkygYeyjggzbA6/Vy
   6z886CdmHCLx/T3mC+KMXLv9g0S7SPVjT6RxUQqmjfXOqk3/e1VKEE/A5
   k=;
X-IronPort-AV: E=Sophos;i="5.76,413,1592870400"; 
   d="scan'208";a="53234551"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1d-5dd976cd.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP; 10 Sep 2020 13:07:24 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-1d-5dd976cd.us-east-1.amazon.com (Postfix) with ESMTPS id 69AEEA1CAC;
        Thu, 10 Sep 2020 13:07:23 +0000 (UTC)
Received: from EX13D02UWB003.ant.amazon.com (10.43.161.48) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 10 Sep 2020 13:07:22 +0000
Received: from EX13MTAUWB001.ant.amazon.com (10.43.161.207) by
 EX13D02UWB003.ant.amazon.com (10.43.161.48) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 10 Sep 2020 13:07:22 +0000
Received: from dev-dsk-sameehj-1c-1edacdb5.eu-west-1.amazon.com (172.19.82.3)
 by mail-relay.amazon.com (10.43.161.249) with Microsoft SMTP Server id
 15.0.1497.2 via Frontend Transport; Thu, 10 Sep 2020 13:07:22 +0000
Received: by dev-dsk-sameehj-1c-1edacdb5.eu-west-1.amazon.com (Postfix, from userid 9775579)
        id 1D70381C74; Thu, 10 Sep 2020 13:07:22 +0000 (UTC)
From:   <sameehj@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Sameeh Jubran <sameehj@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <akiyano@amazon.com>, <ndagan@amazon.com>,
        Shay Agroskin <shayagr@amazon.com>
Subject: [PATCH V4 net-next 3/4] net: ena: ethtool: add stats printing to XDP queues
Date:   Thu, 10 Sep 2020 13:07:12 +0000
Message-ID: <20200910130713.26074-4-sameehj@amazon.com>
X-Mailer: git-send-email 2.16.6
In-Reply-To: <20200910130713.26074-1-sameehj@amazon.com>
References: <20200910130713.26074-1-sameehj@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sameeh Jubran <sameehj@amazon.com>

Added statistics for TX queues that are used for XDP TX. The statistics
are the same as the ones printed for regular non-XDP TX queues.

The XDP queue statistics can be queried using
`ethtool -S <ifname>`

Signed-off-by: Shay Agroskin <shayagr@amazon.com>
Signed-off-by: Sameeh Jubran <sameehj@amazon.com>
---
 drivers/net/ethernet/amazon/ena/ena_ethtool.c | 45 +++++++++++++++++----------
 1 file changed, 28 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_ethtool.c b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
index 07e9f3df0..137a36a6b 100644
--- a/drivers/net/ethernet/amazon/ena/ena_ethtool.c
+++ b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
@@ -152,7 +152,7 @@ static void ena_queue_stats(struct ena_adapter *adapter, u64 **data)
 	u64 *ptr;
 	int i, j;
 
-	for (i = 0; i < adapter->num_io_queues; i++) {
+	for (i = 0; i < adapter->num_io_queues + adapter->xdp_num_queues; i++) {
 		/* Tx stats */
 		ring = &adapter->tx_ring[i];
 
@@ -163,17 +163,19 @@ static void ena_queue_stats(struct ena_adapter *adapter, u64 **data)
 
 			ena_safe_update_stat(ptr, (*data)++, &ring->syncp);
 		}
+		/* XDP TX queues don't have a RX queue counterpart */
+		if (!ENA_IS_XDP_INDEX(adapter, i)) {
+			/* Rx stats */
+			ring = &adapter->rx_ring[i];
 
-		/* Rx stats */
-		ring = &adapter->rx_ring[i];
+			for (j = 0; j < ENA_STATS_ARRAY_RX; j++) {
+				ena_stats = &ena_stats_rx_strings[j];
 
-		for (j = 0; j < ENA_STATS_ARRAY_RX; j++) {
-			ena_stats = &ena_stats_rx_strings[j];
+				ptr = (u64 *)&ring->rx_stats +
+					ena_stats->stat_offset;
 
-			ptr = (u64 *)&ring->rx_stats +
-				ena_stats->stat_offset;
-
-			ena_safe_update_stat(ptr, (*data)++, &ring->syncp);
+				ena_safe_update_stat(ptr, (*data)++, &ring->syncp);
+			}
 		}
 	}
 }
@@ -238,6 +240,7 @@ static void ena_get_ethtool_stats(struct net_device *netdev,
 static int ena_get_sw_stats_count(struct ena_adapter *adapter)
 {
 	return adapter->num_io_queues * (ENA_STATS_ARRAY_TX + ENA_STATS_ARRAY_RX)
+		+ adapter->xdp_num_queues * ENA_STATS_ARRAY_TX
 		+ ENA_STATS_ARRAY_GLOBAL + ENA_STATS_ARRAY_ENA_COM;
 }
 
@@ -259,24 +262,32 @@ int ena_get_sset_count(struct net_device *netdev, int sset)
 static void ena_queue_strings(struct ena_adapter *adapter, u8 **data)
 {
 	const struct ena_stats *ena_stats;
+	bool is_xdp;
 	int i, j;
 
-	for (i = 0; i < adapter->num_io_queues; i++) {
+	for (i = 0; i < adapter->num_io_queues + adapter->xdp_num_queues; i++) {
+		is_xdp = ENA_IS_XDP_INDEX(adapter, i);
 		/* Tx stats */
 		for (j = 0; j < ENA_STATS_ARRAY_TX; j++) {
 			ena_stats = &ena_stats_tx_strings[j];
 
 			snprintf(*data, ETH_GSTRING_LEN,
-				 "queue_%u_tx_%s", i, ena_stats->name);
+				 "queue_%u_%s_%s", i,
+				 is_xdp ? "xdp_tx" : "tx", ena_stats->name);
 			(*data) += ETH_GSTRING_LEN;
 		}
-		/* Rx stats */
-		for (j = 0; j < ENA_STATS_ARRAY_RX; j++) {
-			ena_stats = &ena_stats_rx_strings[j];
 
-			snprintf(*data, ETH_GSTRING_LEN,
-				 "queue_%u_rx_%s", i, ena_stats->name);
-			(*data) += ETH_GSTRING_LEN;
+		if (!is_xdp) {
+			/* RX stats, in XDP there isn't a RX queue
+			 * counterpart
+			 */
+			for (j = 0; j < ENA_STATS_ARRAY_RX; j++) {
+				ena_stats = &ena_stats_rx_strings[j];
+
+				snprintf(*data, ETH_GSTRING_LEN,
+					 "queue_%u_rx_%s", i, ena_stats->name);
+				(*data) += ETH_GSTRING_LEN;
+			}
 		}
 	}
 }
-- 
2.16.6

