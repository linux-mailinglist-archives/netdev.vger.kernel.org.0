Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE06C1653E6
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 01:57:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727280AbgBTA5Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 19:57:16 -0500
Received: from mga09.intel.com ([134.134.136.24]:33266 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727020AbgBTA5P (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Feb 2020 19:57:15 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Feb 2020 16:57:15 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,462,1574150400"; 
   d="scan'208";a="408621349"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.76])
  by orsmga005.jf.intel.com with ESMTP; 19 Feb 2020 16:57:15 -0800
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Sasha Neftin <sasha.neftin@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 04/12] igc: Complete to commit Add legacy power management support
Date:   Wed, 19 Feb 2020 16:57:05 -0800
Message-Id: <20200220005713.682605-5-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200220005713.682605-1-jeffrey.t.kirsher@intel.com>
References: <20200220005713.682605-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sasha Neftin <sasha.neftin@intel.com>

commit 9513d2a5dc7f ("igc: Add legacy power management support")
Add power management resume and schedule suspend requests.
Add power management get and put synchronization.

Signed-off-by: Sasha Neftin <sasha.neftin@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_main.c | 27 +++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index d9d5425fe8d9..5f30dcd1e207 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -4029,6 +4029,9 @@ static void igc_watchdog_task(struct work_struct *work)
 		}
 	}
 	if (link) {
+		/* Cancel scheduled suspend requests. */
+		pm_runtime_resume(netdev->dev.parent);
+
 		if (!netif_carrier_ok(netdev)) {
 			u32 ctrl;
 
@@ -4114,6 +4117,8 @@ static void igc_watchdog_task(struct work_struct *work)
 					return;
 				}
 			}
+			pm_schedule_suspend(netdev->dev.parent,
+					    MSEC_PER_SEC * 5);
 
 		/* also check for alternate media here */
 		} else if (!netif_carrier_ok(netdev) &&
@@ -4337,6 +4342,7 @@ static int igc_request_irq(struct igc_adapter *adapter)
 static int __igc_open(struct net_device *netdev, bool resuming)
 {
 	struct igc_adapter *adapter = netdev_priv(netdev);
+	struct pci_dev *pdev = adapter->pdev;
 	struct igc_hw *hw = &adapter->hw;
 	int err = 0;
 	int i = 0;
@@ -4348,6 +4354,9 @@ static int __igc_open(struct net_device *netdev, bool resuming)
 		return -EBUSY;
 	}
 
+	if (!resuming)
+		pm_runtime_get_sync(&pdev->dev);
+
 	netif_carrier_off(netdev);
 
 	/* allocate transmit descriptors */
@@ -4386,6 +4395,9 @@ static int __igc_open(struct net_device *netdev, bool resuming)
 	rd32(IGC_ICR);
 	igc_irq_enable(adapter);
 
+	if (!resuming)
+		pm_runtime_put(&pdev->dev);
+
 	netif_tx_start_all_queues(netdev);
 
 	/* start the watchdog. */
@@ -4404,6 +4416,8 @@ static int __igc_open(struct net_device *netdev, bool resuming)
 	igc_free_all_tx_resources(adapter);
 err_setup_tx:
 	igc_reset(adapter);
+	if (!resuming)
+		pm_runtime_put(&pdev->dev);
 
 	return err;
 }
@@ -4428,9 +4442,13 @@ static int igc_open(struct net_device *netdev)
 static int __igc_close(struct net_device *netdev, bool suspending)
 {
 	struct igc_adapter *adapter = netdev_priv(netdev);
+	struct pci_dev *pdev = adapter->pdev;
 
 	WARN_ON(test_bit(__IGC_RESETTING, &adapter->state));
 
+	if (!suspending)
+		pm_runtime_get_sync(&pdev->dev);
+
 	igc_down(adapter);
 
 	igc_release_hw_control(adapter);
@@ -4440,6 +4458,9 @@ static int __igc_close(struct net_device *netdev, bool suspending)
 	igc_free_all_tx_resources(adapter);
 	igc_free_all_rx_resources(adapter);
 
+	if (!suspending)
+		pm_runtime_put_sync(&pdev->dev);
+
 	return 0;
 }
 
@@ -4792,6 +4813,10 @@ static int igc_probe(struct pci_dev *pdev,
 	pcie_print_link_status(pdev);
 	netdev_info(netdev, "MAC: %pM\n", netdev->dev_addr);
 
+	dev_pm_set_driver_flags(&pdev->dev, DPM_FLAG_NEVER_SKIP);
+
+	pm_runtime_put_noidle(&pdev->dev);
+
 	return 0;
 
 err_register:
@@ -4826,6 +4851,8 @@ static void igc_remove(struct pci_dev *pdev)
 	struct net_device *netdev = pci_get_drvdata(pdev);
 	struct igc_adapter *adapter = netdev_priv(netdev);
 
+	pm_runtime_get_noresume(&pdev->dev);
+
 	igc_ptp_stop(adapter);
 
 	set_bit(__IGC_DOWN, &adapter->state);
-- 
2.24.1

