Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEF2B242817
	for <lists+netdev@lfdr.de>; Wed, 12 Aug 2020 12:12:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727901AbgHLKMd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Aug 2020 06:12:33 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:34417 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727066AbgHLKMc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Aug 2020 06:12:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1597227152; x=1628763152;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1uh5TEN61PnHNu1WcbvErdSj2tc/99va2TOc9GBn7l4=;
  b=e0pIkjgx/dec0Nt3czmWpJE3ZwyKtzRs0N0+mBEmG4jJj1QlVc3Dazgu
   NLBGtxkNyU6pSeyQtqDgapPIduQ3NMcyLdD5OVm+PFi7SuIiorpWhCgxd
   cMhkBp/tDP7aKtqcsb+7JudtEcfw7lIuOjhRqU/0Ds6bPFNmvwQDgrUOw
   U=;
IronPort-SDR: vAvU0i1ck2YuvevxQluo7CtHCWWFjFWHRHawEXcoNhwoRlB7HQOOAS2WPZbFTzyI3uDYH8p92d
 ikRVV1PQEiAQ==
X-IronPort-AV: E=Sophos;i="5.76,303,1592870400"; 
   d="scan'208";a="66195425"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1a-af6a10df.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 12 Aug 2020 10:12:32 +0000
Received: from EX13MTAUEA002.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1a-af6a10df.us-east-1.amazon.com (Postfix) with ESMTPS id 6BEDEA2660;
        Wed, 12 Aug 2020 10:12:31 +0000 (UTC)
Received: from EX13D28EUC001.ant.amazon.com (10.43.164.4) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 12 Aug 2020 10:12:30 +0000
Received: from u4b1e9be9d67d5a.ant.amazon.com (10.43.161.34) by
 EX13D28EUC001.ant.amazon.com (10.43.164.4) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 12 Aug 2020 10:12:22 +0000
From:   Shay Agroskin <shayagr@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     <dwmw@amazon.com>, <zorik@amazon.com>, <matua@amazon.com>,
        <saeedb@amazon.com>, <msw@amazon.com>, <aliguori@amazon.com>,
        <nafea@amazon.com>, <gtzalik@amazon.com>, <netanel@amazon.com>,
        <alisaidi@amazon.com>, <benh@amazon.com>, <akiyano@amazon.com>,
        <sameehj@amazon.com>, <ndagan@amazon.com>,
        Shay Agroskin <shayagr@amazon.com>
Subject: [PATCH V1 net 1/3] net: ena: Prevent reset after device destruction
Date:   Wed, 12 Aug 2020 13:10:57 +0300
Message-ID: <20200812101059.5501-2-shayagr@amazon.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200812101059.5501-1-shayagr@amazon.com>
References: <20200812101059.5501-1-shayagr@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.161.34]
X-ClientProxiedBy: EX13D03UWA001.ant.amazon.com (10.43.160.141) To
 EX13D28EUC001.ant.amazon.com (10.43.164.4)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The reset work is scheduled by the timer routine whenever it
detects that a device reset is required (e.g. when a keep_alive signal
is missing).
When releasing device resources in ena_destroy() the driver cancels the
scheduling of the timer routine without destroying the reset
work explicitly.

This creates the following bug:
    The driver is suspended and the ena_suspend() function is called
	-> This function calls ena_destroy() to free the net device
	   resources
	    -> The driver waits for the timer routine to finish
	    its execution and then cancels it, thus preventing from it
	    to be called again.

    If, in its final execution, the timer routine schedules a reset,
    the reset routine might be called after the device resources are
    freed, which might cause a kernel panic.

By changing the reset routine so that it cannot run simultaneously with
the destruction routine, we allow the reset routine read the device's
state accurately.
This is achieved by checking whether ENA_FLAG_TRIGGER_RESET flag is set
before resetting the device and making both the destruction function and
the flag check are under rtnl lock.
The ENA_FLAG_TRIGGER_RESET is cleared at the end of the destruction
routine. Also surround the flag check with 'likely' because
we expect that the reset routine would be called only when
ENA_FLAG_TRIGGER_RESET flag is set.

This patch also removes the destruction of the timer and reset services
from ena_remove() since the timer is destroyed by the destruction
routine and the reset work is handled by this patch.

Fixes: 8c5c7abdeb2d ("net: ena: add power management ops to the ENA driver")
Signed-off-by: Shay Agroskin <shayagr@amazon.com>
---
 drivers/net/ethernet/amazon/ena/ena_netdev.c | 17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index 2a6c9725e092..0488fcbf48f7 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -3601,16 +3601,14 @@ static void ena_fw_reset_device(struct work_struct *work)
 {
 	struct ena_adapter *adapter =
 		container_of(work, struct ena_adapter, reset_task);
-	struct pci_dev *pdev = adapter->pdev;
 
-	if (unlikely(!test_bit(ENA_FLAG_TRIGGER_RESET, &adapter->flags))) {
-		dev_err(&pdev->dev,
-			"device reset schedule while reset bit is off\n");
-		return;
-	}
 	rtnl_lock();
-	ena_destroy_device(adapter, false);
-	ena_restore_device(adapter);
+
+	if (likely(test_bit(ENA_FLAG_TRIGGER_RESET, &adapter->flags))) {
+		ena_destroy_device(adapter, false);
+		ena_restore_device(adapter);
+	}
+
 	rtnl_unlock();
 }
 
@@ -4389,9 +4387,6 @@ static void __ena_shutoff(struct pci_dev *pdev, bool shutdown)
 		netdev->rx_cpu_rmap = NULL;
 	}
 #endif /* CONFIG_RFS_ACCEL */
-	del_timer_sync(&adapter->timer_service);
-
-	cancel_work_sync(&adapter->reset_task);
 
 	rtnl_lock(); /* lock released inside the below if-else block */
 	adapter->reset_reason = ENA_REGS_RESET_SHUTDOWN;
-- 
2.28.0

