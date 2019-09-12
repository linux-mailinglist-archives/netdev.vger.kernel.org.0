Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F27BDB1627
	for <lists+netdev@lfdr.de>; Fri, 13 Sep 2019 00:11:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729393AbfILWKz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Sep 2019 18:10:55 -0400
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:11079 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726937AbfILWKy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Sep 2019 18:10:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1568326254; x=1599862254;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=nPqKWaXC5Stds8V5vwGR26v0mC4wQ4xq5SQWwqZ5DTg=;
  b=crE5lmUJWrXxL1cwLflt0bXMKmUW9N7xbxFDtYHLEouOYq/2Ji6IeVFO
   pWtZyEcn4huegceggtgRraXfXsg53jppkG+kri+ErxrnqAHnNof3TW7xN
   2VJ3kDs0yW55HoWCdJYmXowPb+516iZFz+mWz5vOJM7qIIjY1MCo0YieX
   0=;
X-IronPort-AV: E=Sophos;i="5.64,498,1559520000"; 
   d="scan'208";a="415006203"
Received: from iad6-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1a-807d4a99.us-east-1.amazon.com) ([10.124.125.6])
  by smtp-border-fw-out-6001.iad6.amazon.com with ESMTP; 12 Sep 2019 22:10:53 +0000
Received: from EX13MTAUWA001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1a-807d4a99.us-east-1.amazon.com (Postfix) with ESMTPS id 7B87FA2BBB;
        Thu, 12 Sep 2019 22:10:53 +0000 (UTC)
Received: from EX13D10UWA001.ant.amazon.com (10.43.160.216) by
 EX13MTAUWA001.ant.amazon.com (10.43.160.118) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Thu, 12 Sep 2019 22:10:20 +0000
Received: from EX13MTAUWA001.ant.amazon.com (10.43.160.58) by
 EX13D10UWA001.ant.amazon.com (10.43.160.216) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Thu, 12 Sep 2019 22:10:19 +0000
Received: from HFA15-G63729NC.amazon.com (10.95.77.90) by
 mail-relay.amazon.com (10.43.160.118) with Microsoft SMTP Server id
 15.0.1367.3 via Frontend Transport; Thu, 12 Sep 2019 22:10:11 +0000
From:   <akiyano@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Arthur Kiyanovski <akiyano@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <sameehj@amazon.com>, <ndagan@amazon.com>
Subject: [PATCH V1 net-next 09/11] net: ena: fix update of interrupt moderation register
Date:   Fri, 13 Sep 2019 01:08:46 +0300
Message-ID: <1568326128-4057-10-git-send-email-akiyano@amazon.com>
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

Current implementation always updates the interrupt register with
the smoothed_interval of the rx_ring. However this should be
done only in case of adaptive interrupt moderation. If non-adaptive
interrupt moderation is used, the non-adaptive interrupt moderation
interval should be used. This commit fixes that.

Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
---
 drivers/net/ethernet/amazon/ena/ena_netdev.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index 8b9f8b90e525..617f51890449 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -1187,12 +1187,16 @@ static void ena_unmask_interrupt(struct ena_ring *tx_ring,
 					struct ena_ring *rx_ring)
 {
 	struct ena_eth_io_intr_reg intr_reg;
+	u32 rx_interval = ena_com_get_adaptive_moderation_enabled(rx_ring->ena_dev) ?
+		rx_ring->smoothed_interval :
+		ena_com_get_nonadaptive_moderation_interval_rx(rx_ring->ena_dev);
+
 
 	/* Update intr register: rx intr delay,
 	 * tx intr delay and interrupt unmask
 	 */
 	ena_com_update_intr_reg(&intr_reg,
-				rx_ring->smoothed_interval,
+				rx_interval,
 				tx_ring->smoothed_interval,
 				true);
 
-- 
2.17.2

