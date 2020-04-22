Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CD251B39DD
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 10:17:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726604AbgDVIQx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 04:16:53 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:25981 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726558AbgDVIQt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 04:16:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1587543409; x=1619079409;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=12qALQNg/C7LkNPy5MNf39b6MNoz8bOf5SHCYVOlVEM=;
  b=hLhzJgP9jeEP8VePnJDdrrW0qy/5arC4TOC3XpKZMf9OZNMAgEOUt/T9
   AGBf+nfM4XB8tQzHzrh+kWvIFgvI5pRrZFetLfjs+5P7OCTuS/yWJRb1f
   JrQSgdrwfNrHSicNy1Lh5vGPaeiJZAPWrTJna5wRC0qW1I2ofqSl2Khmy
   g=;
IronPort-SDR: 9+ULoCqR1rUDe/9HheKwA60qZcgcT0PVmxSeBlqZC/xfTqLxY3YnaFwnMYsaG/oZ4/lPkLSUOo
 Gt2Vxq3RtYJg==
X-IronPort-AV: E=Sophos;i="5.72,412,1580774400"; 
   d="scan'208";a="38703251"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1a-67b371d8.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 22 Apr 2020 08:16:47 +0000
Received: from EX13MTAUEB002.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1a-67b371d8.us-east-1.amazon.com (Postfix) with ESMTPS id C8B82A1F07;
        Wed, 22 Apr 2020 08:16:46 +0000 (UTC)
Received: from EX13D08UEB002.ant.amazon.com (10.43.60.107) by
 EX13MTAUEB002.ant.amazon.com (10.43.60.12) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 22 Apr 2020 08:16:31 +0000
Received: from EX13MTAUEB002.ant.amazon.com (10.43.60.12) by
 EX13D08UEB002.ant.amazon.com (10.43.60.107) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 22 Apr 2020 08:16:31 +0000
Received: from dev-dsk-sameehj-1c-1edacdb5.eu-west-1.amazon.com (172.19.82.3)
 by mail-relay.amazon.com (10.43.60.234) with Microsoft SMTP Server id
 15.0.1497.2 via Frontend Transport; Wed, 22 Apr 2020 08:16:31 +0000
Received: by dev-dsk-sameehj-1c-1edacdb5.eu-west-1.amazon.com (Postfix, from userid 9775579)
        id 7AEB581D15; Wed, 22 Apr 2020 08:16:30 +0000 (UTC)
From:   <sameehj@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Sameeh Jubran <sameehj@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <akiyano@amazon.com>, <ndagan@amazon.com>,
        Igor Chauskin <igorch@amazon.com>
Subject: [PATCH V1 net-next 08/13] net: ena: add support for reporting of packet drops
Date:   Wed, 22 Apr 2020 08:16:23 +0000
Message-ID: <20200422081628.8103-9-sameehj@amazon.com>
X-Mailer: git-send-email 2.24.1.AMZN
In-Reply-To: <20200422081628.8103-1-sameehj@amazon.com>
References: <20200422081628.8103-1-sameehj@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sameeh Jubran <sameehj@amazon.com>

1. Add support for getting tx drops from the device and saving them
in the driver.
2. Report tx and rx drops via ethtool.
3. Report tx via netdev stats.

Signed-off-by: Igor Chauskin <igorch@amazon.com>
Signed-off-by: Guy Tzalik <gtzalik@amazon.com>
Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
Signed-off-by: Sameeh Jubran <sameehj@amazon.com>
---
 drivers/net/ethernet/amazon/ena/ena_admin_defs.h | 8 ++++++++
 drivers/net/ethernet/amazon/ena/ena_ethtool.c    | 2 ++
 drivers/net/ethernet/amazon/ena/ena_netdev.c     | 6 ++++++
 drivers/net/ethernet/amazon/ena/ena_netdev.h     | 1 +
 4 files changed, 17 insertions(+)

diff --git a/drivers/net/ethernet/amazon/ena/ena_admin_defs.h b/drivers/net/ethernet/amazon/ena/ena_admin_defs.h
index 8baf847e8622..7be3dcbf3d16 100644
--- a/drivers/net/ethernet/amazon/ena/ena_admin_defs.h
+++ b/drivers/net/ethernet/amazon/ena/ena_admin_defs.h
@@ -404,6 +404,10 @@ struct ena_admin_basic_stats {
 	u32 rx_drops_low;
 
 	u32 rx_drops_high;
+
+	u32 tx_drops_low;
+
+	u32 tx_drops_high;
 };
 
 struct ena_admin_acq_get_stats_resp {
@@ -1017,6 +1021,10 @@ struct ena_admin_aenq_keep_alive_desc {
 	u32 rx_drops_low;
 
 	u32 rx_drops_high;
+
+	u32 tx_drops_low;
+
+	u32 tx_drops_high;
 };
 
 struct ena_admin_ena_mmio_req_read_less_resp {
diff --git a/drivers/net/ethernet/amazon/ena/ena_ethtool.c b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
index 74725d606964..a736ad62af78 100644
--- a/drivers/net/ethernet/amazon/ena/ena_ethtool.c
+++ b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
@@ -66,6 +66,8 @@ static const struct ena_stats ena_stats_global_strings[] = {
 	ENA_STAT_GLOBAL_ENTRY(interface_up),
 	ENA_STAT_GLOBAL_ENTRY(interface_down),
 	ENA_STAT_GLOBAL_ENTRY(admin_q_pause),
+	ENA_STAT_GLOBAL_ENTRY(rx_drops),
+	ENA_STAT_GLOBAL_ENTRY(tx_drops),
 };
 
 static const struct ena_stats ena_stats_tx_strings[] = {
diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index 3cea4c9090c2..517681319a57 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -3172,6 +3172,7 @@ static void ena_get_stats64(struct net_device *netdev,
 	struct ena_ring *rx_ring, *tx_ring;
 	unsigned int start;
 	u64 rx_drops;
+	u64 tx_drops;
 	int i;
 
 	if (!test_bit(ENA_FLAG_DEV_UP, &adapter->flags))
@@ -3206,9 +3207,11 @@ static void ena_get_stats64(struct net_device *netdev,
 	do {
 		start = u64_stats_fetch_begin_irq(&adapter->syncp);
 		rx_drops = adapter->dev_stats.rx_drops;
+		tx_drops = adapter->dev_stats.tx_drops;
 	} while (u64_stats_fetch_retry_irq(&adapter->syncp, start));
 
 	stats->rx_dropped = rx_drops;
+	stats->tx_dropped = tx_drops;
 
 	stats->multicast = 0;
 	stats->collisions = 0;
@@ -4517,14 +4520,17 @@ static void ena_keep_alive_wd(void *adapter_data,
 	struct ena_adapter *adapter = (struct ena_adapter *)adapter_data;
 	struct ena_admin_aenq_keep_alive_desc *desc;
 	u64 rx_drops;
+	u64 tx_drops;
 
 	desc = (struct ena_admin_aenq_keep_alive_desc *)aenq_e;
 	adapter->last_keep_alive_jiffies = jiffies;
 
 	rx_drops = ((u64)desc->rx_drops_high << 32) | desc->rx_drops_low;
+	tx_drops = ((u64)desc->tx_drops_high << 32) | desc->tx_drops_low;
 
 	u64_stats_update_begin(&adapter->syncp);
 	adapter->dev_stats.rx_drops = rx_drops;
+	adapter->dev_stats.tx_drops = tx_drops;
 	u64_stats_update_end(&adapter->syncp);
 }
 
diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.h b/drivers/net/ethernet/amazon/ena/ena_netdev.h
index ebeb911c0efb..bd278c4721c6 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.h
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.h
@@ -334,6 +334,7 @@ struct ena_stats_dev {
 	u64 interface_down;
 	u64 admin_q_pause;
 	u64 rx_drops;
+	u64 tx_drops;
 };
 
 enum ena_flags_t {
-- 
2.24.1.AMZN

