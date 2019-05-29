Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E87FE2D97C
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 11:51:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726693AbfE2JvT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 05:51:19 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:10744 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726674AbfE2JvS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 05:51:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1559123477; x=1590659477;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=MXIkyNQQacTVJQChKaIWLq1ELKHo40hoK1rqSZMTiEg=;
  b=c3+gDhecsMqpdAlxNCWMqNj/rMEf9xLP5XCZn37i+Vbkv+DFuLaBaRlJ
   WgxxtUYBfoNKCri42Dnba/E7e3RvQyTJZih5Fo6GW45/tBcuCMcbXRTBS
   5iLlvzFLmv/RqnWpq1/1tXBspYpmKQSXyCdaw63/JfSR5q8+eqWkTfqWT
   s=;
X-IronPort-AV: E=Sophos;i="5.60,526,1549929600"; 
   d="scan'208";a="676958154"
Received: from sea3-co-svc-lb6-vlan3.sea.amazon.com (HELO email-inbound-relay-1e-57e1d233.us-east-1.amazon.com) ([10.47.22.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 29 May 2019 09:51:15 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1e-57e1d233.us-east-1.amazon.com (Postfix) with ESMTPS id 5931F14160F;
        Wed, 29 May 2019 09:51:15 +0000 (UTC)
Received: from EX13D02UWB004.ant.amazon.com (10.43.161.11) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Wed, 29 May 2019 09:50:56 +0000
Received: from EX13MTAUWB001.ant.amazon.com (10.43.161.207) by
 EX13D02UWB004.ant.amazon.com (10.43.161.11) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Wed, 29 May 2019 09:50:55 +0000
Received: from HFA16-8226Y22.hfa16.amazon.com (10.218.60.55) by
 mail-relay.amazon.com (10.43.161.249) with Microsoft SMTP Server id
 15.0.1367.3 via Frontend Transport; Wed, 29 May 2019 09:50:51 +0000
From:   <sameehj@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Sameeh Jubran <sameehj@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <akiyano@amazon.com>,
        Evgeny Shmeilin <evgeny@annapurnaLabs.com>
Subject: [PATCH V1 net-next 10/11] net: ena: add good checksum counter
Date:   Wed, 29 May 2019 12:50:03 +0300
Message-ID: <20190529095004.13341-11-sameehj@amazon.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190529095004.13341-1-sameehj@amazon.com>
References: <20190529095004.13341-1-sameehj@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sameeh Jubran <sameehj@amazon.com>

Add a new statistics to ETHTOOL to specify if the device calculated
and validated the Rx csum.

Signed-off-by: Evgeny Shmeilin <evgeny@annapurnaLabs.com>
Signed-off-by: Sameeh Jubran <sameehj@amazon.com>
---
 drivers/net/ethernet/amazon/ena/ena_ethtool.c | 3 ++-
 drivers/net/ethernet/amazon/ena/ena_netdev.c  | 3 +++
 drivers/net/ethernet/amazon/ena/ena_netdev.h  | 3 ++-
 3 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_ethtool.c b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
index 65bc5a2b2..878546a48 100644
--- a/drivers/net/ethernet/amazon/ena/ena_ethtool.c
+++ b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
@@ -88,13 +88,14 @@ static const struct ena_stats ena_stats_tx_strings[] = {
 static const struct ena_stats ena_stats_rx_strings[] = {
 	ENA_STAT_RX_ENTRY(cnt),
 	ENA_STAT_RX_ENTRY(bytes),
+	ENA_STAT_RX_ENTRY(rx_copybreak_pkt),
+	ENA_STAT_RX_ENTRY(csum_good),
 	ENA_STAT_RX_ENTRY(refil_partial),
 	ENA_STAT_RX_ENTRY(bad_csum),
 	ENA_STAT_RX_ENTRY(page_alloc_fail),
 	ENA_STAT_RX_ENTRY(skb_alloc_fail),
 	ENA_STAT_RX_ENTRY(dma_mapping_err),
 	ENA_STAT_RX_ENTRY(bad_desc_num),
-	ENA_STAT_RX_ENTRY(rx_copybreak_pkt),
 	ENA_STAT_RX_ENTRY(bad_req_id),
 	ENA_STAT_RX_ENTRY(empty_rx_ring),
 	ENA_STAT_RX_ENTRY(csum_unchecked),
diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index 399bd5453..cff297e19 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -1001,6 +1001,9 @@ static inline void ena_rx_checksum(struct ena_ring *rx_ring,
 
 		if (likely(ena_rx_ctx->l4_csum_checked)) {
 			skb->ip_summed = CHECKSUM_UNNECESSARY;
+			u64_stats_update_begin(&rx_ring->syncp);
+			rx_ring->rx_stats.csum_good++;
+			u64_stats_update_end(&rx_ring->syncp);
 		} else {
 			u64_stats_update_begin(&rx_ring->syncp);
 			rx_ring->rx_stats.csum_unchecked++;
diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.h b/drivers/net/ethernet/amazon/ena/ena_netdev.h
index 74c316081..ec111cfc5 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.h
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.h
@@ -208,13 +208,14 @@ struct ena_stats_tx {
 struct ena_stats_rx {
 	u64 cnt;
 	u64 bytes;
+	u64 rx_copybreak_pkt;
+	u64 csum_good;
 	u64 refil_partial;
 	u64 bad_csum;
 	u64 page_alloc_fail;
 	u64 skb_alloc_fail;
 	u64 dma_mapping_err;
 	u64 bad_desc_num;
-	u64 rx_copybreak_pkt;
 	u64 bad_req_id;
 	u64 empty_rx_ring;
 	u64 csum_unchecked;
-- 
2.17.1

