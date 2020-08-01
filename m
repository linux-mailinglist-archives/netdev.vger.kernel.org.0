Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 155412352B1
	for <lists+netdev@lfdr.de>; Sat,  1 Aug 2020 16:21:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728753AbgHAOVh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Aug 2020 10:21:37 -0400
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:15849 "EHLO
        smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726888AbgHAOVg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Aug 2020 10:21:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1596291696; x=1627827696;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=DFK6B0qWTTgj5h4NKyg4TXJQ2WIL6UM+Uuoqh8RXgBw=;
  b=jKu1hXHtq5hCsEjea9L1tR4s3hZf+nBqXGThWFVhKqNN+yTZI50lNBBb
   2LvmukUfEcsiBPMwiL84I4d7DQeiKddnYa7XNUjBkMN50ayTG/NRSXkPS
   NGSn12I2tFSp0eMReSWAoGsBplJCEqEZ7PnDhs8g7o27dhUVNoM0UiUJ2
   I=;
IronPort-SDR: k3IuqeT5X43On1gzckvERsqT8p/HQDKtrUmBkeMZXVYgjhlqYLl1SEryd0MSzJgR0nKewK5UtC
 ol61ESW6xaAg==
X-IronPort-AV: E=Sophos;i="5.75,422,1589241600"; 
   d="scan'208";a="56534486"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1a-821c648d.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP; 01 Aug 2020 14:21:34 +0000
Received: from EX13MTAUEE002.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1a-821c648d.us-east-1.amazon.com (Postfix) with ESMTPS id 5777BA2B47;
        Sat,  1 Aug 2020 14:21:33 +0000 (UTC)
Received: from EX13D08UEE004.ant.amazon.com (10.43.62.182) by
 EX13MTAUEE002.ant.amazon.com (10.43.62.24) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Sat, 1 Aug 2020 14:21:32 +0000
Received: from EX13MTAUEE002.ant.amazon.com (10.43.62.24) by
 EX13D08UEE004.ant.amazon.com (10.43.62.182) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Sat, 1 Aug 2020 14:21:32 +0000
Received: from dev-dsk-sameehj-1c-1edacdb5.eu-west-1.amazon.com (172.19.82.3)
 by mail-relay.amazon.com (10.43.62.224) with Microsoft SMTP Server id
 15.0.1497.2 via Frontend Transport; Sat, 1 Aug 2020 14:21:32 +0000
Received: by dev-dsk-sameehj-1c-1edacdb5.eu-west-1.amazon.com (Postfix, from userid 9775579)
        id 54A768C7F5; Sat,  1 Aug 2020 14:21:32 +0000 (UTC)
From:   <sameehj@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Sameeh Jubran <sameehj@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <akiyano@amazon.com>, <ndagan@amazon.com>,
        Shay Agroskin <shayagr@amazon.com>
Subject: [PATCH V1 net-next 2/3] net: ena: ethtool: add stats printing to XDP queues
Date:   Sat, 1 Aug 2020 14:21:29 +0000
Message-ID: <20200801142130.6537-3-sameehj@amazon.com>
X-Mailer: git-send-email 2.16.6
In-Reply-To: <20200801142130.6537-1-sameehj@amazon.com>
References: <20200801142130.6537-1-sameehj@amazon.com>
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
 drivers/net/ethernet/amazon/ena/ena_ethtool.c | 47 +++++++++++++++++----------
 1 file changed, 29 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_ethtool.c b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
index 7a2b8c70f..1713abe79 100644
--- a/drivers/net/ethernet/amazon/ena/ena_ethtool.c
+++ b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
@@ -152,7 +152,7 @@ static void ena_queue_stats(struct ena_adapter *adapter, u64 **data)
 	u64 *ptr;
 	int i, j;
 
-	for (i = 0; i < adapter->num_io_queues; i++) {
+	for (i = 0; i < adapter->num_io_queues + adapter->xdp_num_queues; i++) {
 		/* Tx stats */
 		ring = &adapter->tx_ring[i];
 
@@ -164,17 +164,19 @@ static void ena_queue_stats(struct ena_adapter *adapter, u64 **data)
 
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
+				ptr = (u64 *)((uintptr_t)&ring->rx_stats +
+					(uintptr_t)ena_stats->stat_offset);
 
-			ptr = (u64 *)((uintptr_t)&ring->rx_stats +
-				(uintptr_t)ena_stats->stat_offset);
-
-			ena_safe_update_stat(ptr, (*data)++, &ring->syncp);
+				ena_safe_update_stat(ptr, (*data)++, &ring->syncp);
+			}
 		}
 	}
 }
@@ -240,6 +242,7 @@ static void ena_get_ethtool_stats(struct net_device *netdev,
 static int ena_get_sw_stats_count(struct ena_adapter *adapter)
 {
 	return adapter->num_io_queues * (ENA_STATS_ARRAY_TX + ENA_STATS_ARRAY_RX)
+		+ adapter->xdp_num_queues * ENA_STATS_ARRAY_TX
 		+ ENA_STATS_ARRAY_GLOBAL + ENA_STATS_ARRAY_ENA_COM;
 }
 
@@ -261,24 +264,32 @@ int ena_get_sset_count(struct net_device *netdev, int sset)
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
-			(*data) += ETH_GSTRING_LEN;
+				 "queue_%u_%s_%s", i,
+				 is_xdp ? "xdp_tx" : "tx", ena_stats->name);
+			 (*data) += ETH_GSTRING_LEN;
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

