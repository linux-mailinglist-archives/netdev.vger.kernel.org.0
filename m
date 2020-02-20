Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 296151653EA
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 01:57:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727620AbgBTA5X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 19:57:23 -0500
Received: from mga09.intel.com ([134.134.136.24]:33266 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727463AbgBTA5T (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Feb 2020 19:57:19 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Feb 2020 16:57:15 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,462,1574150400"; 
   d="scan'208";a="408621367"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.76])
  by orsmga005.jf.intel.com with ESMTP; 19 Feb 2020 16:57:15 -0800
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Sasha Neftin <sasha.neftin@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 10/12] igc: Add pcie error handler support
Date:   Wed, 19 Feb 2020 16:57:11 -0800
Message-Id: <20200220005713.682605-11-jeffrey.t.kirsher@intel.com>
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

Add pcie error detection, slot reset and resume capability

Signed-off-by: Sasha Neftin <sasha.neftin@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_main.c | 103 ++++++++++++++++++++++
 1 file changed, 103 insertions(+)

diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index b805323e1be6..e982b5f54dc9 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -5076,6 +5076,108 @@ static void igc_shutdown(struct pci_dev *pdev)
 	}
 }
 
+/**
+ *  igc_io_error_detected - called when PCI error is detected
+ *  @pdev: Pointer to PCI device
+ *  @state: The current PCI connection state
+ *
+ *  This function is called after a PCI bus error affecting
+ *  this device has been detected.
+ **/
+static pci_ers_result_t igc_io_error_detected(struct pci_dev *pdev,
+					      pci_channel_state_t state)
+{
+	struct net_device *netdev = pci_get_drvdata(pdev);
+	struct igc_adapter *adapter = netdev_priv(netdev);
+
+	netif_device_detach(netdev);
+
+	if (state == pci_channel_io_perm_failure)
+		return PCI_ERS_RESULT_DISCONNECT;
+
+	if (netif_running(netdev))
+		igc_down(adapter);
+	pci_disable_device(pdev);
+
+	/* Request a slot reset. */
+	return PCI_ERS_RESULT_NEED_RESET;
+}
+
+/**
+ *  igc_io_slot_reset - called after the PCI bus has been reset.
+ *  @pdev: Pointer to PCI device
+ *
+ *  Restart the card from scratch, as if from a cold-boot. Implementation
+ *  resembles the first-half of the igc_resume routine.
+ **/
+static pci_ers_result_t igc_io_slot_reset(struct pci_dev *pdev)
+{
+	struct net_device *netdev = pci_get_drvdata(pdev);
+	struct igc_adapter *adapter = netdev_priv(netdev);
+	struct igc_hw *hw = &adapter->hw;
+	pci_ers_result_t result;
+
+	if (pci_enable_device_mem(pdev)) {
+		dev_err(&pdev->dev,
+			"Could not re-enable PCI device after reset.\n");
+		result = PCI_ERS_RESULT_DISCONNECT;
+	} else {
+		pci_set_master(pdev);
+		pci_restore_state(pdev);
+		pci_save_state(pdev);
+
+		pci_enable_wake(pdev, PCI_D3hot, 0);
+		pci_enable_wake(pdev, PCI_D3cold, 0);
+
+		/* In case of PCI error, adapter loses its HW address
+		 * so we should re-assign it here.
+		 */
+		hw->hw_addr = adapter->io_addr;
+
+		igc_reset(adapter);
+		wr32(IGC_WUS, ~0);
+		result = PCI_ERS_RESULT_RECOVERED;
+	}
+
+	return result;
+}
+
+/**
+ *  igc_io_resume - called when traffic can start to flow again.
+ *  @pdev: Pointer to PCI device
+ *
+ *  This callback is called when the error recovery driver tells us that
+ *  its OK to resume normal operation. Implementation resembles the
+ *  second-half of the igc_resume routine.
+ */
+static void igc_io_resume(struct pci_dev *pdev)
+{
+	struct net_device *netdev = pci_get_drvdata(pdev);
+	struct igc_adapter *adapter = netdev_priv(netdev);
+
+	rtnl_lock();
+	if (netif_running(netdev)) {
+		if (igc_open(netdev)) {
+			dev_err(&pdev->dev, "igc_open failed after reset\n");
+			return;
+		}
+	}
+
+	netif_device_attach(netdev);
+
+	/* let the f/w know that the h/w is now under the control of the
+	 * driver.
+	 */
+	igc_get_hw_control(adapter);
+	rtnl_unlock();
+}
+
+static const struct pci_error_handlers igc_err_handler = {
+	.error_detected = igc_io_error_detected,
+	.slot_reset = igc_io_slot_reset,
+	.resume = igc_io_resume,
+};
+
 #ifdef CONFIG_PM
 static const struct dev_pm_ops igc_pm_ops = {
 	SET_SYSTEM_SLEEP_PM_OPS(igc_suspend, igc_resume)
@@ -5093,6 +5195,7 @@ static struct pci_driver igc_driver = {
 	.driver.pm = &igc_pm_ops,
 #endif
 	.shutdown = igc_shutdown,
+	.err_handler = &igc_err_handler,
 };
 
 /**
-- 
2.24.1

