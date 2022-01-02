Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11923482A84
	for <lists+netdev@lfdr.de>; Sun,  2 Jan 2022 08:37:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232910AbiABHh5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Jan 2022 02:37:57 -0500
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:1060 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232907AbiABHh4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Jan 2022 02:37:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1641109077; x=1672645077;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=TN/5fSHXRZwb0IWAZIpL885p5r4M5uL9c1Gs/Nr7EMc=;
  b=KJ7JwbcZ8VuIpRejHZE/CosCpGjOa3nOSMmILTWG9+Ic4t7JlvoUzwtE
   uYyIVVYNiWMm0Yn9AqBTl7MFH5VG9l97HJtNa1zIroIJcxKhe3Wvkdw1N
   gQ3raxe2BXcrsHLLe1KTA1j5uNHKjvRREo4G7N/ekVcCiWm+pAkEiUlCy
   8=;
X-IronPort-AV: E=Sophos;i="5.88,255,1635206400"; 
   d="scan'208";a="167547237"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-iad-1d-10222bbc.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-33001.sea14.amazon.com with ESMTP; 02 Jan 2022 07:37:43 +0000
Received: from EX13MTAUEB002.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1d-10222bbc.us-east-1.amazon.com (Postfix) with ESMTPS id 32BE41A0081;
        Sun,  2 Jan 2022 07:37:41 +0000 (UTC)
Received: from EX13D08UEB003.ant.amazon.com (10.43.60.11) by
 EX13MTAUEB002.ant.amazon.com (10.43.60.12) with Microsoft SMTP Server (TLS)
 id 15.0.1497.26; Sun, 2 Jan 2022 07:37:40 +0000
Received: from EX13MTAUEB002.ant.amazon.com (10.43.60.12) by
 EX13D08UEB003.ant.amazon.com (10.43.60.11) with Microsoft SMTP Server (TLS)
 id 15.0.1497.26; Sun, 2 Jan 2022 07:37:40 +0000
Received: from dev-dsk-akiyano-1c-2138b29d.eu-west-1.amazon.com (172.19.83.6)
 by mail-relay.amazon.com (10.43.60.234) with Microsoft SMTP Server id
 15.0.1497.26 via Frontend Transport; Sun, 2 Jan 2022 07:37:39 +0000
From:   Arthur Kiyanovski <akiyano@amazon.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     Arthur Kiyanovski <akiyano@amazon.com>,
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
        "Dagan, Noam" <ndagan@amazon.com>,
        "Agroskin, Shay" <shayagr@amazon.com>,
        "Arinzon, David" <darinzon@amazon.com>
Subject: [PATCH V2 net 3/3] net: ena: Fix error handling when calculating max IO queues number
Date:   Sun, 2 Jan 2022 07:37:28 +0000
Message-ID: <20220102073728.12242-4-akiyano@amazon.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220102073728.12242-1-akiyano@amazon.com>
References: <20220102073728.12242-1-akiyano@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The role of ena_calc_max_io_queue_num() is to return the number
of queues supported by the device, which means the return value
should be >=0.

The function that calls ena_calc_max_io_queue_num(), checks
the return value. If it is 0, it means the device reported
it supports 0 IO queues. This case is considered an error
and is handled by the calling function accordingly.

However the current implementation of ena_calc_max_io_queue_num()
is wrong, since when it detects the device supports 0 IO queues,
it returns -EFAULT.

In such a case the calling function doesn't detect the error,
and therefore doesn't handle it.

This commit changes ena_calc_max_io_queue_num() to return 0
in case the device reported it supports 0 queues, allowing the
calling function to properly handle the error case.

Fixes: 736ce3f414cc ("net: ena: make ethtool -l show correct max number of queues")
Signed-off-by: Shay Agroskin <shayagr@amazon.com>
Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
---
 drivers/net/ethernet/amazon/ena/ena_netdev.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index 52a8c60b7e29..c72f0c7ff4aa 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -4026,10 +4026,6 @@ static u32 ena_calc_max_io_queue_num(struct pci_dev *pdev,
 	max_num_io_queues = min_t(u32, max_num_io_queues, io_tx_cq_num);
 	/* 1 IRQ for mgmnt and 1 IRQs for each IO direction */
 	max_num_io_queues = min_t(u32, max_num_io_queues, pci_msix_vec_count(pdev) - 1);
-	if (unlikely(!max_num_io_queues)) {
-		dev_err(&pdev->dev, "The device doesn't have io queues\n");
-		return -EFAULT;
-	}
 
 	return max_num_io_queues;
 }
-- 
2.32.0

