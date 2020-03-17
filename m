Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90963187A2B
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 08:07:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726066AbgCQHH3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 03:07:29 -0400
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:55167 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725783AbgCQHH2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Mar 2020 03:07:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1584428848; x=1615964848;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=YeuqrfyGKSqUm/b1+3cTKNV/WTze+IOk8lxi8+Y7xH8=;
  b=CulhYpAvzKr5Rt6yLLHUF9S32LI5CCmb4FH6MJCP6FHttg/LsnsOzuYc
   veAwigmgu5vN8ajOBC6zLjWTNeTmiO/vCVOCSb2Pe4n8uTdJ2nzfAjEUe
   4T96dCO4qD5qWHZ4lAe6DtVnL0IJyl4oeEYjHKUlTSaypf4ma1go+SY6w
   8=;
IronPort-SDR: T5B8hAMG4cDLvZl5hJXODhnrSw1R6MjD3l4SYuV1C/0LTNP2Xp1I08PUyQX7a97Znj8tL4S6zh
 Cv1BT8G6iUCA==
X-IronPort-AV: E=Sophos;i="5.70,563,1574121600"; 
   d="scan'208";a="22788229"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1e-62350142.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-6001.iad6.amazon.com with ESMTP; 17 Mar 2020 07:07:16 +0000
Received: from EX13MTAUWA001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1e-62350142.us-east-1.amazon.com (Postfix) with ESMTPS id 11C1FA1F6C;
        Tue, 17 Mar 2020 07:07:15 +0000 (UTC)
Received: from EX13D10UWA004.ant.amazon.com (10.43.160.64) by
 EX13MTAUWA001.ant.amazon.com (10.43.160.118) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Tue, 17 Mar 2020 07:06:59 +0000
Received: from EX13MTAUWA001.ant.amazon.com (10.43.160.58) by
 EX13D10UWA004.ant.amazon.com (10.43.160.64) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 17 Mar 2020 07:06:58 +0000
Received: from HFA15-G63729NC.amazon.com (10.95.76.85) by
 mail-relay.amazon.com (10.43.160.118) with Microsoft SMTP Server id
 15.0.1367.3 via Frontend Transport; Tue, 17 Mar 2020 07:06:54 +0000
From:   <akiyano@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Arthur Kiyanovski <akiyano@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <ndagan@amazon.com>, <shayagr@amazon.com>,
        <sameehj@amazon.com>
Subject: [PATCH V2 net 2/4] net: ena: fix request of incorrect number of IRQ vectors
Date:   Tue, 17 Mar 2020 09:06:40 +0200
Message-ID: <1584428802-440-3-git-send-email-akiyano@amazon.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1584428802-440-1-git-send-email-akiyano@amazon.com>
References: <1584428802-440-1-git-send-email-akiyano@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arthur Kiyanovski <akiyano@amazon.com>

Bug:
In short the main issue is caused by the fact that the number of queues
is changed using ethtool after ena_probe() has been called and before
ena_up() was executed. Here is the full scenario in detail:

* ena_probe() is called when the driver is loaded, the driver is not up
  yet at the end of ena_probe().
* The number of queues is changed -> io_queue_count is changed as well -
  ena_up() is not called since the "dev_was_up" boolean in
  ena_update_queue_count() is false.
* ena_up() is called by the kernel (it's called asynchronously some
  time after ena_probe()). ena_setup_io_intr() is called by ena_up() and
  it uses io_queue_count to get the suitable irq lines for each msix
  vector. The function ena_request_io_irq() is called right after that
  and it uses msix_vecs - This value only changes during ena_probe() and
  ena_restore() - to request the irq vectors. This results in "Failed to
  request I/O IRQ" error for i > io_queue_count.

Numeric example:
* After ena_probe() io_queue_count = 8, msix_vecs = 9.
* The number of queues changes to 4 -> io_queue_count = 4, msix_vecs = 9.
* ena_up() is executed for the first time:
  ** ena_setup_io_intr() inits the vectors only up to io_queue_count.
  ** ena_request_io_irq() calls request_irq() and fails for i = 5.

How to reproduce:
simply run the following commands:
    sudo rmmod ena && sudo insmod ena.ko;
    sudo ethtool -L eth1 combined 3;

Fix:
Use ENA_MAX_MSIX_VEC(adapter->num_io_queues + adapter->xdp_num_queues)
instead of adapter->msix_vecs. We need to take XDP queues into
consideration as they need to have msix vectors assigned to them as well.
Note that the XDP cannot be attached before the driver is up and running
but in XDP mode the issue might occur when the number of queues changes
right after a reset trigger.
The ENA_MAX_MSIX_VEC simply adds one to the argument since the first msix
vector is reserved for management queue.

Fixes: 1738cd3ed342 ("net: ena: Add a driver for Amazon Elastic Network Adapters (ENA)")
Signed-off-by: Sameeh Jubran <sameehj@amazon.com>
Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
---
 drivers/net/ethernet/amazon/ena/ena_netdev.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index 39f290f4458f..836fda585391 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -2068,6 +2068,7 @@ static int ena_request_mgmnt_irq(struct ena_adapter *adapter)
 
 static int ena_request_io_irq(struct ena_adapter *adapter)
 {
+	u32 io_queue_count = adapter->num_io_queues + adapter->xdp_num_queues;
 	unsigned long flags = 0;
 	struct ena_irq *irq;
 	int rc = 0, i, k;
@@ -2078,7 +2079,7 @@ static int ena_request_io_irq(struct ena_adapter *adapter)
 		return -EINVAL;
 	}
 
-	for (i = ENA_IO_IRQ_FIRST_IDX; i < adapter->msix_vecs; i++) {
+	for (i = ENA_IO_IRQ_FIRST_IDX; i < ENA_MAX_MSIX_VEC(io_queue_count); i++) {
 		irq = &adapter->irq_tbl[i];
 		rc = request_irq(irq->vector, irq->handler, flags, irq->name,
 				 irq->data);
@@ -2119,6 +2120,7 @@ static void ena_free_mgmnt_irq(struct ena_adapter *adapter)
 
 static void ena_free_io_irq(struct ena_adapter *adapter)
 {
+	u32 io_queue_count = adapter->num_io_queues + adapter->xdp_num_queues;
 	struct ena_irq *irq;
 	int i;
 
@@ -2129,7 +2131,7 @@ static void ena_free_io_irq(struct ena_adapter *adapter)
 	}
 #endif /* CONFIG_RFS_ACCEL */
 
-	for (i = ENA_IO_IRQ_FIRST_IDX; i < adapter->msix_vecs; i++) {
+	for (i = ENA_IO_IRQ_FIRST_IDX; i < ENA_MAX_MSIX_VEC(io_queue_count); i++) {
 		irq = &adapter->irq_tbl[i];
 		irq_set_affinity_hint(irq->vector, NULL);
 		free_irq(irq->vector, irq->data);
@@ -2144,12 +2146,13 @@ static void ena_disable_msix(struct ena_adapter *adapter)
 
 static void ena_disable_io_intr_sync(struct ena_adapter *adapter)
 {
+	u32 io_queue_count = adapter->num_io_queues + adapter->xdp_num_queues;
 	int i;
 
 	if (!netif_running(adapter->netdev))
 		return;
 
-	for (i = ENA_IO_IRQ_FIRST_IDX; i < adapter->msix_vecs; i++)
+	for (i = ENA_IO_IRQ_FIRST_IDX; i < ENA_MAX_MSIX_VEC(io_queue_count); i++)
 		synchronize_irq(adapter->irq_tbl[i].vector);
 }
 
-- 
2.17.1

