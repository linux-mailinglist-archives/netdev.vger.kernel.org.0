Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5634262752
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 08:46:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726642AbgIIGqs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 02:46:48 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:58832 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726414AbgIIGqq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 02:46:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1599634005; x=1631170005;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=YUkjWSJHuZQ4gc8zv4WJVmsD1uSTYM3vwJlpIJpg+fk=;
  b=U6Agmr4RtouPMm/269xwwATOl2AHgTTvBr7hFmbJj5PpHP5f9qDND4tv
   zrwoDRgLwjxOIaG4uUtpW7zELSO775dbOIJ7PeQO6WX1N7+WBs2AVlDPw
   CYXeg82r8G+FqX0y3nIhb95m5AtpLBEK90gG+50KR8MyO3w8Emk29qADy
   k=;
X-IronPort-AV: E=Sophos;i="5.76,408,1592870400"; 
   d="scan'208";a="73478572"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2b-859fe132.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 09 Sep 2020 06:46:31 +0000
Received: from EX13MTAUEB002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2b-859fe132.us-west-2.amazon.com (Postfix) with ESMTPS id AF74822304A;
        Wed,  9 Sep 2020 06:46:30 +0000 (UTC)
Received: from EX13D08UEB004.ant.amazon.com (10.43.60.142) by
 EX13MTAUEB002.ant.amazon.com (10.43.60.12) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 9 Sep 2020 06:46:29 +0000
Received: from EX13MTAUEB002.ant.amazon.com (10.43.60.12) by
 EX13D08UEB004.ant.amazon.com (10.43.60.142) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 9 Sep 2020 06:46:29 +0000
Received: from dev-dsk-sameehj-1c-1edacdb5.eu-west-1.amazon.com (172.19.82.3)
 by mail-relay.amazon.com (10.43.60.234) with Microsoft SMTP Server id
 15.0.1497.2 via Frontend Transport; Wed, 9 Sep 2020 06:46:29 +0000
Received: by dev-dsk-sameehj-1c-1edacdb5.eu-west-1.amazon.com (Postfix, from userid 9775579)
        id 518C681C71; Wed,  9 Sep 2020 06:46:28 +0000 (UTC)
From:   <sameehj@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Sameeh Jubran <sameehj@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <akiyano@amazon.com>, <ndagan@amazon.com>
Subject: [PATCH V3 net-next 1/4] net: ena: ethtool: convert stat_offset to 64 bit resolution
Date:   Wed, 9 Sep 2020 06:46:24 +0000
Message-ID: <20200909064627.30104-2-sameehj@amazon.com>
X-Mailer: git-send-email 2.16.6
In-Reply-To: <20200909064627.30104-1-sameehj@amazon.com>
References: <20200909064627.30104-1-sameehj@amazon.com>
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

