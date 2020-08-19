Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8335249901
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 11:06:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727042AbgHSJFw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 05:05:52 -0400
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:12279 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726640AbgHSJFv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 05:05:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1597827951; x=1629363951;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=/2WeLwkzmJyRW84J9dVfRx2kQwyzk8bLLG13GmH0Ju8=;
  b=QVkl7moJ0Vtl0vBhr/ZSnxbCjPi6t092bcWbO4ZvmJMysyZYBC+VU0yB
   kvAdrS6WAwFGVSrXtY/fgaY4XhJDWZApHEoYua6AzMq62nXB09o6dkng2
   VTGBTx+fjj7ekRDJiuTdviHTtN46CPSuBe+RxHhB42ekDSnQ1POqP3qGx
   E=;
X-IronPort-AV: E=Sophos;i="5.76,330,1592870400"; 
   d="scan'208";a="48755538"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2a-538b0bfb.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP; 19 Aug 2020 09:05:49 +0000
Received: from EX13MTAUEA001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2a-538b0bfb.us-west-2.amazon.com (Postfix) with ESMTPS id 1F3EBA211E;
        Wed, 19 Aug 2020 09:05:48 +0000 (UTC)
Received: from EX13D28EUC001.ant.amazon.com (10.43.164.4) by
 EX13MTAUEA001.ant.amazon.com (10.43.61.82) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 19 Aug 2020 09:05:46 +0000
Received: from u68c7b5b1d2d758.ant.amazon.com (10.43.160.100) by
 EX13D28EUC001.ant.amazon.com (10.43.164.4) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 19 Aug 2020 09:05:38 +0000
From:   Shay Agroskin <shayagr@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Shay Agroskin <shayagr@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <akiyano@amazon.com>, <sameehj@amazon.com>,
        <ndagan@amazon.com>
Subject: [PATCH V2 net 1/3] net: ena: Prevent reset after device destruction
Date:   Wed, 19 Aug 2020 12:04:41 +0300
Message-ID: <20200819090443.24917-2-shayagr@amazon.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200819090443.24917-1-shayagr@amazon.com>
References: <20200819090443.24917-1-shayagr@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.160.100]
X-ClientProxiedBy: EX13D20UWA004.ant.amazon.com (10.43.160.62) To
 EX13D28EUC001.ant.amazon.com (10.43.164.4)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The reset work is scheduled by the timer routine whenever it
detects that a device reset is required (e.g. when a keep_alive signal
is missing).
When releasing device resources in ena_destroy_device() the driver cancels the
scheduling of the timer routine without destroying the reset
work explicitly.

This creates the following bug:
    The driver is suspended and the ena_suspend() function is called
	-> This function calls ena_destroy_device() to free the net device
	   resources
	    -> The driver waits for the timer routine to finish
	    its execution and then cancels it, thus preventing from it
	    to be called again.

    If, in its final execution, the timer routine schedules a reset,
    the reset routine might be called afterwards, and a redundant call to
    ena_restore_device() would be made.

By changing the reset routine we allow it to read the device's state
accurately.
This is achieved by checking whether ENA_FLAG_TRIGGER_RESET flag is set
before resetting the device and making both the destruction function and
the flag check are under rtnl lock.
The ENA_FLAG_TRIGGER_RESET is cleared at the end of the destruction
routine. Also surround the flag check with 'likely' because
we expect that the reset routine would be called only when
ENA_FLAG_TRIGGER_RESET flag is set.

The destruction of the timer and reset services in __ena_shutoff() have to
stay, even though the timer routine is destroyed in ena_destroy_device().
This is to avoid a case in which the reset routine is scheduled after
free_netdev() in __ena_shutoff(), which would create an access to freed
memory in adapter->flags.

Fixes: 84a629e ("[New feature] ena_netdev: Add hibernation support")
Signed-off-by: Shay Agroskin <shayagr@amazon.com>
---
 drivers/net/ethernet/amazon/ena/ena_netdev.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index 2a6c9725e092..44aeace196f0 100644
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
 
@@ -4389,8 +4387,11 @@ static void __ena_shutoff(struct pci_dev *pdev, bool shutdown)
 		netdev->rx_cpu_rmap = NULL;
 	}
 #endif /* CONFIG_RFS_ACCEL */
-	del_timer_sync(&adapter->timer_service);
 
+	/* Make sure timer and reset routine won't be called after
+	 * freeing device resources.
+	 */
+	del_timer_sync(&adapter->timer_service);
 	cancel_work_sync(&adapter->reset_task);
 
 	rtnl_lock(); /* lock released inside the below if-else block */
-- 
2.17.1

