Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2BA03187A2A
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 08:07:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725943AbgCQHHI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 03:07:08 -0400
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:20776 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725783AbgCQHHI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Mar 2020 03:07:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1584428828; x=1615964828;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=7zss6choObteD0uYOG2Vc9bv6L6OReHPlL72tTjOKWs=;
  b=clYB+1nSjOYt/uORbJqSwhgbwJSFIwXDi9YX0HDuD7WHvaG3msrDiSbF
   2XXV1JwMK6CT/MzbDxqWsDFt15R3SXvgxXIj8txE5+yKvFdOOi+r8NEjo
   kRTvvBSBLmvI6IUlO3MEzT2ZePajoOj0rINaBcXkCguJ+X25PuxK8xeRN
   Q=;
IronPort-SDR: f4Hi54wgmz5AVv1mgGH/MW72B2gxZg52OUDlwQBzJYpOYx2R3AMOh8bK3NrzsA4Swyu8hbP+im
 FrnawLIeNsCA==
X-IronPort-AV: E=Sophos;i="5.70,563,1574121600"; 
   d="scan'208";a="21523975"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1e-a70de69e.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP; 17 Mar 2020 07:06:56 +0000
Received: from EX13MTAUWA001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1e-a70de69e.us-east-1.amazon.com (Postfix) with ESMTPS id B4BFEA28AE;
        Tue, 17 Mar 2020 07:06:54 +0000 (UTC)
Received: from EX13D21UWA002.ant.amazon.com (10.43.160.246) by
 EX13MTAUWA001.ant.amazon.com (10.43.160.118) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Tue, 17 Mar 2020 07:06:54 +0000
Received: from EX13MTAUWA001.ant.amazon.com (10.43.160.58) by
 EX13D21UWA002.ant.amazon.com (10.43.160.246) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 17 Mar 2020 07:06:53 +0000
Received: from HFA15-G63729NC.amazon.com (10.95.76.85) by
 mail-relay.amazon.com (10.43.160.118) with Microsoft SMTP Server id
 15.0.1367.3 via Frontend Transport; Tue, 17 Mar 2020 07:06:49 +0000
From:   <akiyano@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Arthur Kiyanovski <akiyano@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <ndagan@amazon.com>, <shayagr@amazon.com>,
        <sameehj@amazon.com>
Subject: [PATCH V2 net 1/4] net: ena: fix incorrect setting of the number of msix vectors
Date:   Tue, 17 Mar 2020 09:06:39 +0200
Message-ID: <1584428802-440-2-git-send-email-akiyano@amazon.com>
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

Overview:
We don't frequently change the msix vectors throughout the life cycle of
the driver. We do so in two functions: ena_probe() and ena_restore().
ena_probe() is only called when the driver is loaded. ena_restore() on the
other hand is called during device reset / resume operations.

We use num_io_queues for calculating and allocating the number of msix
vectors. At ena_probe() this value is equal to max_num_io_queues and thus
this is not an issue, however ena_restore() might be called after the
number of io queues has changed.

A possible bug scenario is as follows:

* Change number of queues from 8 to 4.
  (num_io_queues = 4, max_num_io_queues = 8, msix_vecs = 9,)
* Trigger reset occurs -> ena_restore is called.
  (num_io_queues = 4, max_num_io_queues =8 , msix_vecs = 5)
* Change number of queues from 4 to 6.
  (num_io_queues = 6, max_num_io_queues = 8, msix_vecs = 5)
* The driver will reset due to failure of check_for_rx_interrupt_queue()

Fix:
This can be easily fixed by always using max_num_io_queues to init the
msix_vecs, since this number won't change as opposed to num_io_queues.

Fixes: 4d19266022ec ("net: ena: multiple queue creation related cleanups")
Signed-off-by: Sameeh Jubran <sameehj@amazon.com>
Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
---
 drivers/net/ethernet/amazon/ena/ena_netdev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index 0b2fd96b93d7..39f290f4458f 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -1968,7 +1968,7 @@ static int ena_enable_msix(struct ena_adapter *adapter)
 	}
 
 	/* Reserved the max msix vectors we might need */
-	msix_vecs = ENA_MAX_MSIX_VEC(adapter->num_io_queues);
+	msix_vecs = ENA_MAX_MSIX_VEC(adapter->max_num_io_queues);
 	netif_dbg(adapter, probe, adapter->netdev,
 		  "trying to enable MSI-X, vectors %d\n", msix_vecs);
 
-- 
2.17.1

