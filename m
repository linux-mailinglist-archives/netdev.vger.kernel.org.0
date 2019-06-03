Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E731E3328F
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 16:44:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729395AbfFCOoi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 10:44:38 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:17924 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729151AbfFCOoh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jun 2019 10:44:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1559573077; x=1591109077;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=NJA+iuBkhIRB8vuS1bk6jiR56ll2BslmQ8xkPzB1kHc=;
  b=dJn6NBKvM43V87xUSv/xTok/ICYqoaa+pJkbwbLtSbkEcUCfNwOZOloC
   rOYnIhcqa8uGdcMTXH9dVXonZq8WJPgSCDeNPF+R2ttw57T6UXmQvOWD1
   /ZdTsyF5qJyaEQld6SBpLQeGAc+jlgkR++Oy88dhxqwYQ7N/SrabDAmR1
   U=;
X-IronPort-AV: E=Sophos;i="5.60,547,1549929600"; 
   d="scan'208";a="803248440"
Received: from sea3-co-svc-lb6-vlan2.sea.amazon.com (HELO email-inbound-relay-1a-821c648d.us-east-1.amazon.com) ([10.47.22.34])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 03 Jun 2019 14:44:36 +0000
Received: from EX13MTAUEA001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1a-821c648d.us-east-1.amazon.com (Postfix) with ESMTPS id E9DA1A0310;
        Mon,  3 Jun 2019 14:44:35 +0000 (UTC)
Received: from EX13D08UEE002.ant.amazon.com (10.43.62.92) by
 EX13MTAUEA001.ant.amazon.com (10.43.61.243) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Mon, 3 Jun 2019 14:44:07 +0000
Received: from EX13MTAUEE001.ant.amazon.com (10.43.62.200) by
 EX13D08UEE002.ant.amazon.com (10.43.62.92) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Mon, 3 Jun 2019 14:44:06 +0000
Received: from HFA16-8226Y22.hfa16.amazon.com (10.218.60.55) by
 mail-relay.amazon.com (10.43.62.226) with Microsoft SMTP Server id
 15.0.1367.3 via Frontend Transport; Mon, 3 Jun 2019 14:44:03 +0000
From:   <sameehj@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Sameeh Jubran <sameehj@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <akiyano@amazon.com>,
        Evgeny Shmeilin <evgeny@annapurnaLabs.com>
Subject: [PATCH V2 net 10/11] net: ena: add good checksum counter
Date:   Mon, 3 Jun 2019 17:43:28 +0300
Message-ID: <20190603144329.16366-11-sameehj@amazon.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190603144329.16366-1-sameehj@amazon.com>
References: <20190603144329.16366-1-sameehj@amazon.com>
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
index 28fe4c6ef..5687a2860 100644
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

