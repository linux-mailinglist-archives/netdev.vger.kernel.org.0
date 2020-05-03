Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FBD21C2B00
	for <lists+netdev@lfdr.de>; Sun,  3 May 2020 11:52:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728021AbgECJw1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 May 2020 05:52:27 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:17577 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726445AbgECJw0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 May 2020 05:52:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1588499547; x=1620035547;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=T/5RHHQCvNAPrkXjqCtaVNAejLQ8XFTylf6DypsFlhE=;
  b=sDv4mkgC2AeNDQ+ynkOMvGGZITb93BmrVbM4kS+wSzV/hy05+q8AAxAy
   5NmitKUiC9LbBiGm6t71bzUIYH6rqIw6xf96veBuK0J/uNbzX+VH98N5E
   Ul/gI0ylJgWMcaMSn2rbz2FhSt7UT6aE5sx3blmgDuLMT4W7MYXSADByv
   U=;
IronPort-SDR: 4cUNe5280438jtwGDQ7irhCcDovG1vtoEePom+4e5I3Byes89U2cN6l32mSFHW2mawQ5C3XBXJ
 DQMJ6d8Si6jw==
X-IronPort-AV: E=Sophos;i="5.73,347,1583193600"; 
   d="scan'208";a="42280415"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2a-d0be17ee.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 03 May 2020 09:52:26 +0000
Received: from EX13MTAUEE002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2a-d0be17ee.us-west-2.amazon.com (Postfix) with ESMTPS id E7661A187A;
        Sun,  3 May 2020 09:52:24 +0000 (UTC)
Received: from EX13D08UEE003.ant.amazon.com (10.43.62.118) by
 EX13MTAUEE002.ant.amazon.com (10.43.62.24) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Sun, 3 May 2020 09:52:24 +0000
Received: from EX13MTAUEA002.ant.amazon.com (10.43.61.77) by
 EX13D08UEE003.ant.amazon.com (10.43.62.118) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Sun, 3 May 2020 09:52:24 +0000
Received: from dev-dsk-sameehj-1c-1edacdb5.eu-west-1.amazon.com (172.19.82.3)
 by mail-relay.amazon.com (10.43.61.169) with Microsoft SMTP Server id
 15.0.1497.2 via Frontend Transport; Sun, 3 May 2020 09:52:24 +0000
Received: by dev-dsk-sameehj-1c-1edacdb5.eu-west-1.amazon.com (Postfix, from userid 9775579)
        id 804C481F22; Sun,  3 May 2020 09:52:23 +0000 (UTC)
From:   <sameehj@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Sameeh Jubran <sameehj@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <akiyano@amazon.com>, <ndagan@amazon.com>,
        Igor Chauskin <igorch@amazon.com>
Subject: [PATCH V3 net-next 08/12] net: ena: add support for reporting of packet drops
Date:   Sun, 3 May 2020 09:52:17 +0000
Message-ID: <20200503095221.6408-9-sameehj@amazon.com>
X-Mailer: git-send-email 2.24.1.AMZN
In-Reply-To: <20200503095221.6408-1-sameehj@amazon.com>
References: <20200503095221.6408-1-sameehj@amazon.com>
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
2. Report tx via netdev stats.

Signed-off-by: Igor Chauskin <igorch@amazon.com>
Signed-off-by: Guy Tzalik <gtzalik@amazon.com>
Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
Signed-off-by: Sameeh Jubran <sameehj@amazon.com>
---
 drivers/net/ethernet/amazon/ena/ena_admin_defs.h | 8 ++++++++
 drivers/net/ethernet/amazon/ena/ena_netdev.c     | 6 ++++++
 drivers/net/ethernet/amazon/ena/ena_netdev.h     | 1 +
 3 files changed, 15 insertions(+)

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

