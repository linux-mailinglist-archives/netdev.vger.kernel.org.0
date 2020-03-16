Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96C95186B2F
	for <lists+netdev@lfdr.de>; Mon, 16 Mar 2020 13:39:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731193AbgCPMim (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Mar 2020 08:38:42 -0400
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:11530 "EHLO
        smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731027AbgCPMil (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Mar 2020 08:38:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1584362322; x=1615898322;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=7zss6choObteD0uYOG2Vc9bv6L6OReHPlL72tTjOKWs=;
  b=Hmyvmt1ssFugFC6fI8/4IJJ4bA5ADr7jAMrlxIe6mQwUITMJzdtDMFqq
   esNjeNUZrrAf1dCyqywirSXdlKWufHAydHV+mEO3x5fXUJoMpWhb8grNE
   YnHxxcalfeA05WZl3xxtdidTgPmjXQTm8WJKhdVUypbNZw+3Nx+5/xBGb
   c=;
IronPort-SDR: dCYGY+1waBXg2NZktEaHX4Ibb1f8/YGpT8061jus0OfYlPhjgOygAENvTaTEsfng26VojT8KT5
 bNEhA/0+d6Mw==
X-IronPort-AV: E=Sophos;i="5.70,560,1574121600"; 
   d="scan'208";a="23049271"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1d-2c665b5d.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP; 16 Mar 2020 12:38:40 +0000
Received: from EX13MTAUWA001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1d-2c665b5d.us-east-1.amazon.com (Postfix) with ESMTPS id D154FA0609;
        Mon, 16 Mar 2020 12:38:38 +0000 (UTC)
Received: from EX13D21UWA002.ant.amazon.com (10.43.160.246) by
 EX13MTAUWA001.ant.amazon.com (10.43.160.118) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Mon, 16 Mar 2020 12:38:37 +0000
Received: from EX13MTAUWA001.ant.amazon.com (10.43.160.58) by
 EX13D21UWA002.ant.amazon.com (10.43.160.246) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 16 Mar 2020 12:38:36 +0000
Received: from HFA15-G63729NC.amazon.com (10.1.213.27) by
 mail-relay.amazon.com (10.43.160.118) with Microsoft SMTP Server id
 15.0.1367.3 via Frontend Transport; Mon, 16 Mar 2020 12:38:32 +0000
From:   <akiyano@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Arthur Kiyanovski <akiyano@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <ndagan@amazon.com>, <shayagr@amazon.com>,
        <sameehj@amazon.com>
Subject: [PATCH V1 net 1/7] net: ena: fix incorrect setting of the number of msix vectors
Date:   Mon, 16 Mar 2020 14:38:18 +0200
Message-ID: <1584362304-274-2-git-send-email-akiyano@amazon.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1584362304-274-1-git-send-email-akiyano@amazon.com>
References: <1584362304-274-1-git-send-email-akiyano@amazon.com>
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

