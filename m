Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65DAEB395B
	for <lists+netdev@lfdr.de>; Mon, 16 Sep 2019 13:32:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731632AbfIPLcR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Sep 2019 07:32:17 -0400
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:58084 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731582AbfIPLcQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Sep 2019 07:32:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1568633536; x=1600169536;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=ToLfYeEYFm5djKJ4sQys7nAVQsn/Mv6mFYJ6zAZGyWs=;
  b=Y2ssmpFtQJmD7xkcW84WDlG2HY7q56s5k8BOzO8+UqiL2NcYuU/XeCar
   vVkVe85o77Xop9upQiV+2UIjcrE7Zoh0d5dQ+jBvCQejyCqY1dRfAIK+l
   QHBWG6p7DxVbrQmVFyKcwXEAMzVmaakOfJfqguQS/cWZ59b+TA4jx25Pa
   w=;
X-IronPort-AV: E=Sophos;i="5.64,512,1559520000"; 
   d="scan'208";a="415450172"
Received: from iad6-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1e-62350142.us-east-1.amazon.com) ([10.124.125.6])
  by smtp-border-fw-out-6001.iad6.amazon.com with ESMTP; 16 Sep 2019 11:32:16 +0000
Received: from EX13MTAUEA001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1e-62350142.us-east-1.amazon.com (Postfix) with ESMTPS id E9727A1F11;
        Mon, 16 Sep 2019 11:32:15 +0000 (UTC)
Received: from EX13D08UEE004.ant.amazon.com (10.43.62.182) by
 EX13MTAUEA001.ant.amazon.com (10.43.61.82) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Mon, 16 Sep 2019 11:32:02 +0000
Received: from EX13MTAUEE001.ant.amazon.com (10.43.62.200) by
 EX13D08UEE004.ant.amazon.com (10.43.62.182) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Mon, 16 Sep 2019 11:32:01 +0000
Received: from HFA15-G63729NC.hfa16.amazon.com (10.218.52.89) by
 mail-relay.amazon.com (10.43.62.226) with Microsoft SMTP Server id
 15.0.1367.3 via Frontend Transport; Mon, 16 Sep 2019 11:31:58 +0000
From:   <akiyano@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Arthur Kiyanovski <akiyano@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <sameehj@amazon.com>, <ndagan@amazon.com>
Subject: [PATCH V2 net-next 06/11] net: ena: remove old adaptive interrupt moderation code from ena_netdev
Date:   Mon, 16 Sep 2019 14:31:31 +0300
Message-ID: <1568633496-4143-7-git-send-email-akiyano@amazon.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1568633496-4143-1-git-send-email-akiyano@amazon.com>
References: <1568633496-4143-1-git-send-email-akiyano@amazon.com>
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

