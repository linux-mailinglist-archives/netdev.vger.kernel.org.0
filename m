Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B38D24A4F0
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 19:29:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726796AbgHSR3t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 13:29:49 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:33700 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726734AbgHSR3h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 13:29:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1597858177; x=1629394177;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=arqa1oygtgFoNvn8EjFImRhsvbr6pDtVm5wPhFjlvLk=;
  b=TFqBH5o29eXqyvgUeFe/aX4mfkP7oVOWgpLayZravrPrwgABKgeHi33z
   Q84pYc4IyFm/+9Kzwd5ynXHsVElwPTWvc+z0QrLB0CbpjvdiJYaXVJPDb
   m/cRFQVz1wTKSlFRGGLTqT2jHZCkmqgzhdz2/f6jvri7yX5twYz2AR98I
   s=;
X-IronPort-AV: E=Sophos;i="5.76,332,1592870400"; 
   d="scan'208";a="68046623"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1e-62350142.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 19 Aug 2020 17:29:27 +0000
Received: from EX13MTAUEA002.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1e-62350142.us-east-1.amazon.com (Postfix) with ESMTPS id 6E87CA2237;
        Wed, 19 Aug 2020 17:29:26 +0000 (UTC)
Received: from EX13D28EUC001.ant.amazon.com (10.43.164.4) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 19 Aug 2020 17:29:25 +0000
Received: from u68c7b5b1d2d758.ant.amazon.com (10.43.160.192) by
 EX13D28EUC001.ant.amazon.com (10.43.164.4) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 19 Aug 2020 17:29:17 +0000
From:   Shay Agroskin <shayagr@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Shay Agroskin <shayagr@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <akiyano@amazon.com>, <sameehj@amazon.com>,
        <ndagan@amazon.com>
Subject: [PATCH V3 net 1/3] net: ena: Prevent reset after device destruction
Date:   Wed, 19 Aug 2020 20:28:36 +0300
Message-ID: <20200819172838.20564-2-shayagr@amazon.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200819172838.20564-1-shayagr@amazon.com>
References: <20200819172838.20564-1-shayagr@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.160.192]
X-ClientProxiedBy: EX13P01UWB003.ant.amazon.com (10.43.161.209) To
 EX13D28EUC001.ant.amazon.com (10.43.164.4)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The reset work is scheduled by the timer routine whenever it
detects that a device reset is required (e.g. when a keep_alive signal
is missing).
When releasing device resources in ena_destroy_device() the driver
cancels the scheduling of the timer routine without destroying the reset
work explicitly.

This creates the following bug:
    The driver is suspended and the ena_suspend() function is called
	-> This function calls ena_destroy_device() to free the net device
	   resources
	    -> The driver waits for the timer routine to finish
	    its execution and then cancels it, thus preventing from it
	    to be called again.

    If, in its final execution, the timer routine schedules a reset,
    the reset routine might be called afterwards,and a redundant call to
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

Fixes: 8c5c7abdeb2d ("net: ena: add power management ops to the ENA driver")
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

