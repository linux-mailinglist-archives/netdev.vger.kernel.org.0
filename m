Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8503239FB9F
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 18:03:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233393AbhFHQEw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 12:04:52 -0400
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:6185 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231243AbhFHQEv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Jun 2021 12:04:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1623168179; x=1654704179;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=MfAe2sAPDcC7ZOMSHm6tlxwu1PsW1JKomiCi+0hiWi0=;
  b=GF7P5DNjGUw/L2b7ORF+6Zfk9jWR64eGsPCOOf1EJUUBtNjgzPRWQ4fi
   Oy8AwAGZ/WP7rBdyN0ugrUhSEjYIznVOW4Gr9hcPLa4JY3F+VU/gSyOwE
   kZVXDKW3qrsdoXb6Rjuvh/mLEE4mAP4ebZA2vAz8tcM+T4RZD7R4CFG/f
   M=;
X-IronPort-AV: E=Sophos;i="5.83,258,1616457600"; 
   d="scan'208";a="112932490"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2b-a7fdc47a.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-4101.iad4.amazon.com with ESMTP; 08 Jun 2021 16:02:58 +0000
Received: from EX13D28EUC001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2b-a7fdc47a.us-west-2.amazon.com (Postfix) with ESMTPS id AF7B7C0098;
        Tue,  8 Jun 2021 16:02:57 +0000 (UTC)
Received: from u570694869fb251.ant.amazon.com (10.43.160.137) by
 EX13D28EUC001.ant.amazon.com (10.43.164.4) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Tue, 8 Jun 2021 16:02:49 +0000
From:   Shay Agroskin <shayagr@amazon.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     Shay Agroskin <shayagr@amazon.com>,
        "Woodhouse, David" <dwmw@amazon.com>,
        "Machulsky, Zorik" <zorik@amazon.com>,
        "Matushevsky, Alexander" <matua@amazon.com>,
        Saeed Bshara <saeedb@amazon.com>,
        "Wilson, Matt" <msw@amazon.com>,
        "Liguori, Anthony" <aliguori@amazon.com>,
        "Bshara, Nafea" <nafea@amazon.com>,
        "Belgazal, Netanel" <netanel@amazon.com>,
        "Saidi, Ali" <alisaidi@amazon.com>,
        "Herrenschmidt, Benjamin" <benh@amazon.com>,
        "Kiyanovski, Arthur" <akiyano@amazon.com>,
        "Dagan, Noam" <ndagan@amazon.com>,
        Sameeh Jubran <sameehj@amazon.com>
Subject: [Patch v1 net-next 05/10] net: ena: add jiffies of last napi call to stats
Date:   Tue, 8 Jun 2021 19:01:13 +0300
Message-ID: <20210608160118.3767932-6-shayagr@amazon.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210608160118.3767932-1-shayagr@amazon.com>
References: <20210608160118.3767932-1-shayagr@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.137]
X-ClientProxiedBy: EX13D35UWC003.ant.amazon.com (10.43.162.130) To
 EX13D28EUC001.ant.amazon.com (10.43.164.4)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are instances when we want to know when the last napi was
called for debugging.

On stuck / heavy loaded CPUs, the ena napi handler might not be
called for a long period of time. This stat can help us to
determine how much time passed since the last execution of napi.

Signed-off-by: Sameeh Jubran <sameehj@amazon.com>
Signed-off-by: Shay Agroskin <shayagr@amazon.com>
---
 drivers/net/ethernet/amazon/ena/ena_netdev.c | 28 ++++++++++++++------
 drivers/net/ethernet/amazon/ena/ena_netdev.h |  1 +
 2 files changed, 21 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index d7bc4f45e5df..f013fa312937 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -228,6 +228,7 @@ static int ena_xdp_io_poll(struct napi_struct *napi, int budget)
 	xdp_ring->tx_stats.napi_comp += napi_comp_call;
 	xdp_ring->tx_stats.tx_poll++;
 	u64_stats_update_end(&xdp_ring->syncp);
+	xdp_ring->tx_stats.last_napi_jiffies = jiffies;
 
 	return ret;
 }
@@ -1989,6 +1990,8 @@ static int ena_io_poll(struct napi_struct *napi, int budget)
 	tx_ring->tx_stats.tx_poll++;
 	u64_stats_update_end(&tx_ring->syncp);
 
+	tx_ring->tx_stats.last_napi_jiffies = jiffies;
+
 	return ret;
 }
 
@@ -3695,6 +3698,9 @@ static int check_missing_comp_in_tx_queue(struct ena_adapter *adapter,
 					  struct ena_ring *tx_ring)
 {
 	struct ena_napi *ena_napi = container_of(tx_ring->napi, struct ena_napi, napi);
+	unsigned int time_since_last_napi;
+	unsigned int missing_tx_comp_to;
+	bool is_tx_comp_time_expired;
 	struct ena_tx_buffer *tx_buf;
 	unsigned long last_jiffies;
 	u32 missed_tx = 0;
@@ -3708,9 +3714,10 @@ static int check_missing_comp_in_tx_queue(struct ena_adapter *adapter,
 			/* no pending Tx at this location */
 			continue;
 
-		if (unlikely(!READ_ONCE(ena_napi->first_interrupt) &&
-			time_is_before_jiffies(last_jiffies + 2 *
-				adapter->missing_tx_completion_to))) {
+		is_tx_comp_time_expired = time_is_before_jiffies(last_jiffies +
+			 2 * adapter->missing_tx_completion_to);
+
+		if (unlikely(!READ_ONCE(ena_napi->first_interrupt) && is_tx_comp_time_expired)) {
 			/* If after graceful period interrupt is still not
 			 * received, we schedule a reset
 			 */
@@ -3723,12 +3730,17 @@ static int check_missing_comp_in_tx_queue(struct ena_adapter *adapter,
 			return -EIO;
 		}
 
-		if (unlikely(time_is_before_jiffies(last_jiffies +
-				adapter->missing_tx_completion_to))) {
-			if (!tx_buf->print_once)
+		is_tx_comp_time_expired = time_is_before_jiffies(last_jiffies +
+			adapter->missing_tx_completion_to);
+
+		if (unlikely(is_tx_comp_time_expired)) {
+			if (!tx_buf->print_once) {
+				time_since_last_napi = jiffies_to_usecs(jiffies - tx_ring->tx_stats.last_napi_jiffies);
+				missing_tx_comp_to = jiffies_to_msecs(adapter->missing_tx_completion_to);
 				netif_notice(adapter, tx_err, adapter->netdev,
-					     "Found a Tx that wasn't completed on time, qid %d, index %d.\n",
-					     tx_ring->qid, i);
+					     "Found a Tx that wasn't completed on time, qid %d, index %d. %u usecs have passed since last napi execution. Missing Tx timeout value %u msecs\n",
+					     tx_ring->qid, i, time_since_last_napi, missing_tx_comp_to);
+			}
 
 			tx_buf->print_once = 1;
 			missed_tx++;
diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.h b/drivers/net/ethernet/amazon/ena/ena_netdev.h
index 834348fcdf3c..0c39fc2fa345 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.h
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.h
@@ -206,6 +206,7 @@ struct ena_stats_tx {
 	u64 llq_buffer_copy;
 	u64 missed_tx;
 	u64 unmask_interrupt;
+	u64 last_napi_jiffies;
 };
 
 struct ena_stats_rx {
-- 
2.25.1

