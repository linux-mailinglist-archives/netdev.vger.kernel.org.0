Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B32252339BE
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 22:37:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730400AbgG3Uh1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 16:37:27 -0400
Received: from mga14.intel.com ([192.55.52.115]:30890 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726838AbgG3Uh0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Jul 2020 16:37:26 -0400
IronPort-SDR: YdWkdlrZOoTYQp+sxBWpH+HeEy5WRiYbHmqygAZZ8MJ6kXS6gMvBRq6CiAjkG5YuA7GFnf70sP
 aAGUjcdvwtFQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9698"; a="150885527"
X-IronPort-AV: E=Sophos;i="5.75,415,1589266800"; 
   d="scan'208";a="150885527"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jul 2020 13:37:24 -0700
IronPort-SDR: t5tt9fO24XonELhg9KYNDPwhJuNmlaGDoMy3WDf+CNT+6kVlv49HSmnRyUYHF6wgGbpTfhIAYc
 6N+FvHLhWEbg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,415,1589266800"; 
   d="scan'208";a="274324252"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga008.fm.intel.com with ESMTP; 30 Jul 2020 13:37:24 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net
Cc:     Vaibhav Gupta <vaibhavgupta40@gmail.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        jeffrey.t.kirsher@intel.com, anthony.l.nguyen@intel.com,
        Andrew Bowers <andrewx.bowers@intel.com>
Subject: [net-next 03/12] ixgbe: use generic power management
Date:   Thu, 30 Jul 2020 13:37:11 -0700
Message-Id: <20200730203720.3843018-4-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200730203720.3843018-1-anthony.l.nguyen@intel.com>
References: <20200730203720.3843018-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vaibhav Gupta <vaibhavgupta40@gmail.com>

With legacy PM hooks, it was the responsibility of a driver to manage PCI
states and also the device's power state. The generic approach is to let
PCI core handle the work.

ixgbe_suspend() calls __ixgbe_shutdown() to perform intermediate tasks.
__ixgbe_shutdown() modifies the value of "wake" (device should be wakeup
enabled or not), responsible for controlling the flow of legacy PM.

Since, PCI core has no idea about the value of "wake", new code for generic
PM may produce unexpected results. Thus, use "device_set_wakeup_enable()"
to wakeup-enable the device accordingly.

Compile-tested only.

Signed-off-by: Vaibhav Gupta <vaibhavgupta40@gmail.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 61 +++++--------------
 1 file changed, 15 insertions(+), 46 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index 4d898ff21a46..e339edd0b593 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -6877,32 +6877,20 @@ int ixgbe_close(struct net_device *netdev)
 	return 0;
 }
 
-#ifdef CONFIG_PM
-static int ixgbe_resume(struct pci_dev *pdev)
+static int __maybe_unused ixgbe_resume(struct device *dev_d)
 {
+	struct pci_dev *pdev = to_pci_dev(dev_d);
 	struct ixgbe_adapter *adapter = pci_get_drvdata(pdev);
 	struct net_device *netdev = adapter->netdev;
 	u32 err;
 
 	adapter->hw.hw_addr = adapter->io_addr;
-	pci_set_power_state(pdev, PCI_D0);
-	pci_restore_state(pdev);
-	/*
-	 * pci_restore_state clears dev->state_saved so call
-	 * pci_save_state to restore it.
-	 */
-	pci_save_state(pdev);
 
-	err = pci_enable_device_mem(pdev);
-	if (err) {
-		e_dev_err("Cannot enable PCI device from suspend\n");
-		return err;
-	}
 	smp_mb__before_atomic();
 	clear_bit(__IXGBE_DISABLED, &adapter->state);
 	pci_set_master(pdev);
 
-	pci_wake_from_d3(pdev, false);
+	device_wakeup_disable(dev_d);
 
 	ixgbe_reset(adapter);
 
@@ -6920,7 +6908,6 @@ static int ixgbe_resume(struct pci_dev *pdev)
 
 	return err;
 }
-#endif /* CONFIG_PM */
 
 static int __ixgbe_shutdown(struct pci_dev *pdev, bool *enable_wake)
 {
@@ -6929,9 +6916,6 @@ static int __ixgbe_shutdown(struct pci_dev *pdev, bool *enable_wake)
 	struct ixgbe_hw *hw = &adapter->hw;
 	u32 ctrl;
 	u32 wufc = adapter->wol;
-#ifdef CONFIG_PM
-	int retval = 0;
-#endif
 
 	rtnl_lock();
 	netif_device_detach(netdev);
@@ -6942,12 +6926,6 @@ static int __ixgbe_shutdown(struct pci_dev *pdev, bool *enable_wake)
 	ixgbe_clear_interrupt_scheme(adapter);
 	rtnl_unlock();
 
-#ifdef CONFIG_PM
-	retval = pci_save_state(pdev);
-	if (retval)
-		return retval;
-
-#endif
 	if (hw->mac.ops.stop_link_on_d3)
 		hw->mac.ops.stop_link_on_d3(hw);
 
@@ -7002,26 +6980,18 @@ static int __ixgbe_shutdown(struct pci_dev *pdev, bool *enable_wake)
 	return 0;
 }
 
-#ifdef CONFIG_PM
-static int ixgbe_suspend(struct pci_dev *pdev, pm_message_t state)
+static int __maybe_unused ixgbe_suspend(struct device *dev_d)
 {
+	struct pci_dev *pdev = to_pci_dev(dev_d);
 	int retval;
 	bool wake;
 
 	retval = __ixgbe_shutdown(pdev, &wake);
-	if (retval)
-		return retval;
 
-	if (wake) {
-		pci_prepare_to_sleep(pdev);
-	} else {
-		pci_wake_from_d3(pdev, false);
-		pci_set_power_state(pdev, PCI_D3hot);
-	}
+	device_set_wakeup_enable(dev_d, wake);
 
-	return 0;
+	return retval;
 }
-#endif /* CONFIG_PM */
 
 static void ixgbe_shutdown(struct pci_dev *pdev)
 {
@@ -11383,16 +11353,15 @@ static const struct pci_error_handlers ixgbe_err_handler = {
 	.resume = ixgbe_io_resume,
 };
 
+static SIMPLE_DEV_PM_OPS(ixgbe_pm_ops, ixgbe_suspend, ixgbe_resume);
+
 static struct pci_driver ixgbe_driver = {
-	.name     = ixgbe_driver_name,
-	.id_table = ixgbe_pci_tbl,
-	.probe    = ixgbe_probe,
-	.remove   = ixgbe_remove,
-#ifdef CONFIG_PM
-	.suspend  = ixgbe_suspend,
-	.resume   = ixgbe_resume,
-#endif
-	.shutdown = ixgbe_shutdown,
+	.name      = ixgbe_driver_name,
+	.id_table  = ixgbe_pci_tbl,
+	.probe     = ixgbe_probe,
+	.remove    = ixgbe_remove,
+	.driver.pm = &ixgbe_pm_ops,
+	.shutdown  = ixgbe_shutdown,
 	.sriov_configure = ixgbe_pci_sriov_configure,
 	.err_handler = &ixgbe_err_handler
 };
-- 
2.26.2

