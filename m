Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37F4D242819
	for <lists+netdev@lfdr.de>; Wed, 12 Aug 2020 12:12:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727929AbgHLKMv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Aug 2020 06:12:51 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:34471 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727822AbgHLKMt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Aug 2020 06:12:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1597227169; x=1628763169;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=JSTcKpQGbU4Hlyo6aiY3G4/WOLzVLWrmatTRT63KG1o=;
  b=qHJ6vBA9MO3NmvbLfbwMdLD/eme2oVLIp3InMUqTK89pdIzyA+5HM5O7
   J4BrHLbl+3xQ4JBUpixa45Xbotzh9+Aox+kIwbTG3UlR4roU53n77nkOV
   MajXXhCd3Peb1CnKlJefjGfGyDBgr3VkmeqMUu/LTnBQPXN1vb/lFSLRI
   I=;
IronPort-SDR: zMC06vIw7jEUWtNfBux05Mb1fmixsAL7TD7y2V2agVD4XJZ6AlU5evr7zntrA6UFwNbUzUUIda
 A93ugoVtDtEQ==
X-IronPort-AV: E=Sophos;i="5.76,303,1592870400"; 
   d="scan'208";a="66195468"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1e-a70de69e.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 12 Aug 2020 10:12:49 +0000
Received: from EX13MTAUEA002.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1e-a70de69e.us-east-1.amazon.com (Postfix) with ESMTPS id 3AAC9A251D;
        Wed, 12 Aug 2020 10:12:47 +0000 (UTC)
Received: from EX13D28EUC001.ant.amazon.com (10.43.164.4) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 12 Aug 2020 10:12:47 +0000
Received: from u4b1e9be9d67d5a.ant.amazon.com (10.43.161.34) by
 EX13D28EUC001.ant.amazon.com (10.43.164.4) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 12 Aug 2020 10:12:38 +0000
From:   Shay Agroskin <shayagr@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     <dwmw@amazon.com>, <zorik@amazon.com>, <matua@amazon.com>,
        <saeedb@amazon.com>, <msw@amazon.com>, <aliguori@amazon.com>,
        <nafea@amazon.com>, <gtzalik@amazon.com>, <netanel@amazon.com>,
        <alisaidi@amazon.com>, <benh@amazon.com>, <akiyano@amazon.com>,
        <sameehj@amazon.com>, <ndagan@amazon.com>,
        Shay Agroskin <shayagr@amazon.com>
Subject: [PATCH V1 net 3/3] net: ena: Make missed_tx stat incremental
Date:   Wed, 12 Aug 2020 13:10:59 +0300
Message-ID: <20200812101059.5501-4-shayagr@amazon.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200812101059.5501-1-shayagr@amazon.com>
References: <20200812101059.5501-1-shayagr@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.161.34]
X-ClientProxiedBy: EX13D03UWA001.ant.amazon.com (10.43.160.141) To
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
index 3e12065482c2..7a11a759d053 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -3687,7 +3687,7 @@ static int check_missing_comp_in_tx_queue(struct ena_adapter *adapter,
 	}
 
 	u64_stats_update_begin(&tx_ring->syncp);
-	tx_ring->tx_stats.missed_tx = missed_tx;
+	tx_ring->tx_stats.missed_tx += missed_tx;
 	u64_stats_update_end(&tx_ring->syncp);
 
 	return rc;
@@ -4550,6 +4550,9 @@ static void ena_keep_alive_wd(void *adapter_data,
 	tx_drops = ((u64)desc->tx_drops_high << 32) | desc->tx_drops_low;
 
 	u64_stats_update_begin(&adapter->syncp);
+	/* These stats are accumulated by the device, so the counters indicate
+	 * all drops since last reset.
+	 */
 	adapter->dev_stats.rx_drops = rx_drops;
 	adapter->dev_stats.tx_drops = tx_drops;
 	u64_stats_update_end(&adapter->syncp);
-- 
2.28.0

