Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6369C2653B8
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 23:39:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728111AbgIJVjv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 17:39:51 -0400
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:17474 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730287AbgIJNH0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 09:07:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1599743245; x=1631279245;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=YUkjWSJHuZQ4gc8zv4WJVmsD1uSTYM3vwJlpIJpg+fk=;
  b=fPdppn84awaKec0DfcbiCYjFEqc6audSeH+YDkh0FDJ0FoMHHp+mppIC
   P5T4ThCyMJCBOjqCDIlqdsFPHKwW2OngIcAzcHWbBTUVtVFui9sXU2hs9
   OPwuDdwrVf3cSrTwWJwQe0Xct8lhJoU0SJ2S9pxFWw0PE5hVSOYnr4hag
   4=;
X-IronPort-AV: E=Sophos;i="5.76,413,1592870400"; 
   d="scan'208";a="52996836"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1a-807d4a99.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-2101.iad2.amazon.com with ESMTP; 10 Sep 2020 13:07:24 +0000
Received: from EX13MTAUWC002.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-1a-807d4a99.us-east-1.amazon.com (Postfix) with ESMTPS id 3992FA2456;
        Thu, 10 Sep 2020 13:07:23 +0000 (UTC)
Received: from EX13d09UWC002.ant.amazon.com (10.43.162.102) by
 EX13MTAUWC002.ant.amazon.com (10.43.162.240) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 10 Sep 2020 13:07:22 +0000
Received: from EX13MTAUWC001.ant.amazon.com (10.43.162.135) by
 EX13d09UWC002.ant.amazon.com (10.43.162.102) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 10 Sep 2020 13:07:22 +0000
Received: from dev-dsk-sameehj-1c-1edacdb5.eu-west-1.amazon.com (172.19.82.3)
 by mail-relay.amazon.com (10.43.162.232) with Microsoft SMTP Server id
 15.0.1497.2 via Frontend Transport; Thu, 10 Sep 2020 13:07:22 +0000
Received: by dev-dsk-sameehj-1c-1edacdb5.eu-west-1.amazon.com (Postfix, from userid 9775579)
        id 17C6C81C1B; Thu, 10 Sep 2020 13:07:22 +0000 (UTC)
From:   <sameehj@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Sameeh Jubran <sameehj@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <akiyano@amazon.com>, <ndagan@amazon.com>
Subject: [PATCH V4 net-next 1/4] net: ena: ethtool: convert stat_offset to 64 bit resolution
Date:   Thu, 10 Sep 2020 13:07:10 +0000
Message-ID: <20200910130713.26074-2-sameehj@amazon.com>
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

The type of all stat fields is u64, therefore when iterating over stat
fields in a stats struct, it makes sense to use an offset in 64 bit
resolution. Doing so allows us to drop some of the casting that is
currently used when referencing stats.

Signed-off-by: Sameeh Jubran <sameehj@amazon.com>
---
 drivers/net/ethernet/amazon/ena/ena_ethtool.c | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_ethtool.c b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
index 430275bc0..291d169dd 100644
--- a/drivers/net/ethernet/amazon/ena/ena_ethtool.c
+++ b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
@@ -41,12 +41,12 @@ struct ena_stats {
 
 #define ENA_STAT_ENA_COM_ENTRY(stat) { \
 	.name = #stat, \
-	.stat_offset = offsetof(struct ena_com_stats_admin, stat) \
+	.stat_offset = offsetof(struct ena_com_stats_admin, stat) / sizeof(u64) \
 }
 
 #define ENA_STAT_ENTRY(stat, stat_type) { \
 	.name = #stat, \
-	.stat_offset = offsetof(struct ena_stats_##stat_type, stat) \
+	.stat_offset = offsetof(struct ena_stats_##stat_type, stat) / sizeof(u64) \
 }
 
 #define ENA_STAT_RX_ENTRY(stat) \
@@ -141,8 +141,7 @@ static void ena_queue_stats(struct ena_adapter *adapter, u64 **data)
 		for (j = 0; j < ENA_STATS_ARRAY_TX; j++) {
 			ena_stats = &ena_stats_tx_strings[j];
 
-			ptr = (u64 *)((uintptr_t)&ring->tx_stats +
-				(uintptr_t)ena_stats->stat_offset);
+			ptr = (u64 *)&ring->tx_stats + ena_stats->stat_offset;
 
 			ena_safe_update_stat(ptr, (*data)++, &ring->syncp);
 		}
@@ -153,8 +152,8 @@ static void ena_queue_stats(struct ena_adapter *adapter, u64 **data)
 		for (j = 0; j < ENA_STATS_ARRAY_RX; j++) {
 			ena_stats = &ena_stats_rx_strings[j];
 
-			ptr = (u64 *)((uintptr_t)&ring->rx_stats +
-				(uintptr_t)ena_stats->stat_offset);
+			ptr = (u64 *)&ring->rx_stats +
+				ena_stats->stat_offset;
 
 			ena_safe_update_stat(ptr, (*data)++, &ring->syncp);
 		}
@@ -170,8 +169,8 @@ static void ena_dev_admin_queue_stats(struct ena_adapter *adapter, u64 **data)
 	for (i = 0; i < ENA_STATS_ARRAY_ENA_COM; i++) {
 		ena_stats = &ena_stats_ena_com_strings[i];
 
-		ptr = (u64 *)((uintptr_t)&adapter->ena_dev->admin_queue.stats +
-			(uintptr_t)ena_stats->stat_offset);
+		ptr = (u64 *)&adapter->ena_dev->admin_queue.stats +
+			ena_stats->stat_offset;
 
 		*(*data)++ = *ptr;
 	}
@@ -189,8 +188,7 @@ static void ena_get_ethtool_stats(struct net_device *netdev,
 	for (i = 0; i < ENA_STATS_ARRAY_GLOBAL; i++) {
 		ena_stats = &ena_stats_global_strings[i];
 
-		ptr = (u64 *)((uintptr_t)&adapter->dev_stats +
-			(uintptr_t)ena_stats->stat_offset);
+		ptr = (u64 *)&adapter->dev_stats + ena_stats->stat_offset;
 
 		ena_safe_update_stat(ptr, data++, &adapter->syncp);
 	}
-- 
2.16.6

