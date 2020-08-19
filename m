Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54DAB249904
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 11:06:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727097AbgHSJGG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 05:06:06 -0400
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:18045 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726110AbgHSJGF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 05:06:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1597827965; x=1629363965;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=MliiYzzKkWKjfG4i0b3+kOeMkW0YilzxyqHgCxiaXtc=;
  b=Y+7GAR7rdMQTGwqp5HcnbGQ9Ev5kIMhRARZSPvwroCB8w7rDupq7Fdqs
   0y8Luhgkw3Rsc62oNBtrNVKnxeTyg4T6PuXtqV+axx1vg8Cb5An8paRed
   15A9aXJqn/qaSIK6Z1cPfexX/7KppcbH5X6rFW29FwEfiD1wZRs+M07pv
   A=;
X-IronPort-AV: E=Sophos;i="5.76,330,1592870400"; 
   d="scan'208";a="48656492"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2c-397e131e.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-6002.iad6.amazon.com with ESMTP; 19 Aug 2020 09:06:04 +0000
Received: from EX13MTAUEA001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2c-397e131e.us-west-2.amazon.com (Postfix) with ESMTPS id 2525BA256B;
        Wed, 19 Aug 2020 09:06:03 +0000 (UTC)
Received: from EX13D28EUC001.ant.amazon.com (10.43.164.4) by
 EX13MTAUEA001.ant.amazon.com (10.43.61.82) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 19 Aug 2020 09:06:02 +0000
Received: from u68c7b5b1d2d758.ant.amazon.com (10.43.160.100) by
 EX13D28EUC001.ant.amazon.com (10.43.164.4) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 19 Aug 2020 09:05:54 +0000
From:   Shay Agroskin <shayagr@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Shay Agroskin <shayagr@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <akiyano@amazon.com>, <sameehj@amazon.com>,
        <ndagan@amazon.com>
Subject: [PATCH V2 net 3/3] net: ena: Make missed_tx stat incremental
Date:   Wed, 19 Aug 2020 12:04:43 +0300
Message-ID: <20200819090443.24917-4-shayagr@amazon.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200819090443.24917-1-shayagr@amazon.com>
References: <20200819090443.24917-1-shayagr@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.160.100]
X-ClientProxiedBy: EX13D20UWA004.ant.amazon.com (10.43.160.62) To
 EX13D28EUC001.ant.amazon.com (10.43.164.4)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Most statistics in ena driver are incremented, meaning that a stat's
value is a sum of all increases done to it since driver/queue
initialization.

This patch makes all statistics this way, effectively making missed_tx
statistic incremental.
Also added a comment regarding rx_drops and tx_drops to make it
clearer how these counters are calculated.

Fixes: 11095fdb712b ("net: ena: add statistics for missed tx packets")
Signed-off-by: Shay Agroskin <shayagr@amazon.com>
---
 drivers/net/ethernet/amazon/ena/ena_netdev.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index 233db15c970d..a3a8edf9a734 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -3687,7 +3687,7 @@ static int check_missing_comp_in_tx_queue(struct ena_adapter *adapter,
 	}
 
 	u64_stats_update_begin(&tx_ring->syncp);
-	tx_ring->tx_stats.missed_tx = missed_tx;
+	tx_ring->tx_stats.missed_tx += missed_tx;
 	u64_stats_update_end(&tx_ring->syncp);
 
 	return rc;
@@ -4556,6 +4556,9 @@ static void ena_keep_alive_wd(void *adapter_data,
 	tx_drops = ((u64)desc->tx_drops_high << 32) | desc->tx_drops_low;
 
 	u64_stats_update_begin(&adapter->syncp);
+	/* These stats are accumulated by the device, so the counters indicate
+	 * all drops since last reset.
+	 */
 	adapter->dev_stats.rx_drops = rx_drops;
 	adapter->dev_stats.tx_drops = tx_drops;
 	u64_stats_update_end(&adapter->syncp);
-- 
2.17.1

