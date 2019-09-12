Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C5E3B1624
	for <lists+netdev@lfdr.de>; Fri, 13 Sep 2019 00:10:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729351AbfILWKQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Sep 2019 18:10:16 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:12290 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726937AbfILWKP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Sep 2019 18:10:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1568326215; x=1599862215;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=ToLfYeEYFm5djKJ4sQys7nAVQsn/Mv6mFYJ6zAZGyWs=;
  b=X9oSGNoxqEp99IcUAPse3nVa5xkasG2WTRaXOx4RqgBnI6kExLmKSEQM
   Nr0J9Mqx4Iqb8BW0sBa/WdWqhQHansBnZMW5+VtkFa3mylTAVv/blHy+z
   HYhmGrLkW+khpEjgZSlg2vM80hAKZrUQOt4FDaMg+F3tV2yekitI3XNpY
   g=;
X-IronPort-AV: E=Sophos;i="5.64,498,1559520000"; 
   d="scan'208";a="831292549"
Received: from sea3-co-svc-lb6-vlan2.sea.amazon.com (HELO email-inbound-relay-1a-67b371d8.us-east-1.amazon.com) ([10.47.22.34])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 12 Sep 2019 22:10:14 +0000
Received: from EX13MTAUWA001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1a-67b371d8.us-east-1.amazon.com (Postfix) with ESMTPS id 17CE8A29E1;
        Thu, 12 Sep 2019 22:10:13 +0000 (UTC)
Received: from EX13D10UWA001.ant.amazon.com (10.43.160.216) by
 EX13MTAUWA001.ant.amazon.com (10.43.160.118) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Thu, 12 Sep 2019 22:09:57 +0000
Received: from EX13MTAUWA001.ant.amazon.com (10.43.160.58) by
 EX13D10UWA001.ant.amazon.com (10.43.160.216) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Thu, 12 Sep 2019 22:09:57 +0000
Received: from HFA15-G63729NC.amazon.com (10.95.77.90) by
 mail-relay.amazon.com (10.43.160.118) with Microsoft SMTP Server id
 15.0.1367.3 via Frontend Transport; Thu, 12 Sep 2019 22:09:50 +0000
From:   <akiyano@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Arthur Kiyanovski <akiyano@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <sameehj@amazon.com>, <ndagan@amazon.com>
Subject: [PATCH V1 net-next 06/11] net: ena: remove old adaptive interrupt moderation code from ena_netdev
Date:   Fri, 13 Sep 2019 01:08:43 +0300
Message-ID: <1568326128-4057-7-git-send-email-akiyano@amazon.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1568326128-4057-1-git-send-email-akiyano@amazon.com>
References: <1568326128-4057-1-git-send-email-akiyano@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arthur Kiyanovski <akiyano@amazon.com>

1. Out of the fields {per_napi_bytes, per_napi_packets} in struct ena_ring,
   only rx_ring->per_napi_packets are used to determine if napi did work
   for dim.
   This commit removes all other uses of these fields.
2. Remove ena_ring->moder_tbl_idx, which is not used by dim.
3. Remove all calls to ena_com_destroy_interrupt_moderation(), since all it
   did was to destroy the interrupt moderation table, which is removed as
   part of removing old interrupt moderation code.

Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
---
 drivers/net/ethernet/amazon/ena/ena_netdev.c | 8 --------
 drivers/net/ethernet/amazon/ena/ena_netdev.h | 2 --
 2 files changed, 10 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index f19736493c01..1d8855ab8624 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -158,7 +158,6 @@ static void ena_init_io_rings_common(struct ena_adapter *adapter,
 	ring->adapter = adapter;
 	ring->ena_dev = adapter->ena_dev;
 	ring->per_napi_packets = 0;
-	ring->per_napi_bytes = 0;
 	ring->cpu = 0;
 	ring->first_interrupt = false;
 	ring->no_interrupt_event_cnt = 0;
@@ -834,9 +833,6 @@ static int ena_clean_tx_irq(struct ena_ring *tx_ring, u32 budget)
 		__netif_tx_unlock(txq);
 	}
 
-	tx_ring->per_napi_bytes += tx_bytes;
-	tx_ring->per_napi_packets += tx_pkts;
-
 	return tx_pkts;
 }
 
@@ -1120,7 +1116,6 @@ static int ena_clean_rx_irq(struct ena_ring *rx_ring, struct napi_struct *napi,
 	} while (likely(res_budget));
 
 	work_done = budget - res_budget;
-	rx_ring->per_napi_bytes += total_len;
 	rx_ring->per_napi_packets += work_done;
 	u64_stats_update_begin(&rx_ring->syncp);
 	rx_ring->rx_stats.bytes += total_len;
@@ -3641,7 +3636,6 @@ static int ena_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	ena_free_mgmnt_irq(adapter);
 	ena_disable_msix(adapter);
 err_worker_destroy:
-	ena_com_destroy_interrupt_moderation(ena_dev);
 	del_timer(&adapter->timer_service);
 err_netdev_destroy:
 	free_netdev(netdev);
@@ -3702,8 +3696,6 @@ static void ena_remove(struct pci_dev *pdev)
 
 	pci_disable_device(pdev);
 
-	ena_com_destroy_interrupt_moderation(ena_dev);
-
 	vfree(ena_dev);
 }
 
diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.h b/drivers/net/ethernet/amazon/ena/ena_netdev.h
index f67ecab3389a..e9450991ab74 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.h
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.h
@@ -280,8 +280,6 @@ struct ena_ring {
 	struct ena_com_rx_buf_info ena_bufs[ENA_PKT_MAX_BUFS];
 	u32  smoothed_interval;
 	u32  per_napi_packets;
-	u32  per_napi_bytes;
-	enum ena_intr_moder_level moder_tbl_idx;
 	u16 non_empty_napi_events;
 	struct u64_stats_sync syncp;
 	union {
-- 
2.17.2

