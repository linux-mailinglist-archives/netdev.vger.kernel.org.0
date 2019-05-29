Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BBCF22D2C0
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 02:17:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727631AbfE2ARj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 20:17:39 -0400
Received: from mga11.intel.com ([192.55.52.93]:59374 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727397AbfE2AR1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 May 2019 20:17:27 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 28 May 2019 17:17:27 -0700
X-ExtLoop1: 1
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by FMSMGA003.fm.intel.com with ESMTP; 28 May 2019 17:17:27 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Konstantin Khlebnikov <khlebnikov@yandex-team.ru>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Joseph Yasi <joe.yasi@gmail.com>,
        Aaron Brown <aaron.f.brown@intel.com>,
        Oleksandr Natalenko <oleksandr@redhat.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 08/10] e1000e: start network tx queue only when link is up
Date:   Tue, 28 May 2019 17:17:24 -0700
Message-Id: <20190529001726.26097-9-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190529001726.26097-1-jeffrey.t.kirsher@intel.com>
References: <20190529001726.26097-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>

Driver does not want to keep packets in Tx queue when link is lost.
But present code only reset NIC to flush them, but does not prevent
queuing new packets. Moreover reset sequence itself could generate
new packets via netconsole and NIC falls into endless reset loop.

This patch wakes Tx queue only when NIC is ready to send packets.

This is proper fix for problem addressed by commit 0f9e980bf5ee
("e1000e: fix cyclic resets at link up with active tx").

Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Suggested-by: Alexander Duyck <alexander.duyck@gmail.com>
Tested-by: Joseph Yasi <joe.yasi@gmail.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Tested-by: Oleksandr Natalenko <oleksandr@redhat.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/e1000e/netdev.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index e21b2ffd1e92..b081a1ef6859 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -4208,7 +4208,7 @@ void e1000e_up(struct e1000_adapter *adapter)
 		e1000_configure_msix(adapter);
 	e1000_irq_enable(adapter);
 
-	netif_start_queue(adapter->netdev);
+	/* Tx queue started by watchdog timer when link is up */
 
 	e1000e_trigger_lsc(adapter);
 }
@@ -4606,6 +4606,7 @@ int e1000e_open(struct net_device *netdev)
 	pm_runtime_get_sync(&pdev->dev);
 
 	netif_carrier_off(netdev);
+	netif_stop_queue(netdev);
 
 	/* allocate transmit descriptors */
 	err = e1000e_setup_tx_resources(adapter->tx_ring);
@@ -4666,7 +4667,6 @@ int e1000e_open(struct net_device *netdev)
 	e1000_irq_enable(adapter);
 
 	adapter->tx_hang_recheck = false;
-	netif_start_queue(netdev);
 
 	hw->mac.get_link_status = true;
 	pm_runtime_put(&pdev->dev);
@@ -5288,6 +5288,7 @@ static void e1000_watchdog_task(struct work_struct *work)
 			if (phy->ops.cfg_on_link_up)
 				phy->ops.cfg_on_link_up(hw);
 
+			netif_wake_queue(netdev);
 			netif_carrier_on(netdev);
 
 			if (!test_bit(__E1000_DOWN, &adapter->state))
@@ -5301,6 +5302,7 @@ static void e1000_watchdog_task(struct work_struct *work)
 			/* Link status message must follow this format */
 			pr_info("%s NIC Link is Down\n", adapter->netdev->name);
 			netif_carrier_off(netdev);
+			netif_stop_queue(netdev);
 			if (!test_bit(__E1000_DOWN, &adapter->state))
 				mod_timer(&adapter->phy_info_timer,
 					  round_jiffies(jiffies + 2 * HZ));
-- 
2.21.0

