Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B8BB1FC1E5
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 00:54:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726500AbgFPWyJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jun 2020 18:54:09 -0400
Received: from mga01.intel.com ([192.55.52.88]:27234 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726456AbgFPWyF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Jun 2020 18:54:05 -0400
IronPort-SDR: aJC8e9wEl0VHgiCFixDQMWALmm9+OdcD5ri/UzUiyPhy1qBMBorl7vNb9+Nfzu3hORtAXMieFk
 wnDYo94zmYcQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2020 15:54:02 -0700
IronPort-SDR: R7nPnRYHbNGNjpgq9KitgTkpGlKjIL1xlwnw06ZmOWHY4V/GKTqwzip26Pmgoob3nfsBFt8wQE
 iOTKI0eE3sDA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,520,1583222400"; 
   d="scan'208";a="317362146"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by FMSMGA003.fm.intel.com with ESMTP; 16 Jun 2020 15:53:56 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Vaibhav Gupta <vaibhavgupta40@gmail.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net 2/3] e1000: use generic power management
Date:   Tue, 16 Jun 2020 15:53:53 -0700
Message-Id: <20200616225354.2744572-3-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200616225354.2744572-1-jeffrey.t.kirsher@intel.com>
References: <20200616225354.2744572-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vaibhav Gupta <vaibhavgupta40@gmail.com>

With legacy PM hooks, it was the responsibility of a driver to manage PCI
states and also the device's power state. The generic approach is to let PCI
core handle the work.

e1000_suspend() calls __e1000_shutdown() to perform intermediate tasks.
__e1000_shutdown() modifies the value of "wake" (device should be wakeup
enabled or not), responsible for controlling the flow of legacy PM.

Since, PCI core has no idea about the value of "wake", new code for generic
PM may produce unexpected results. Thus, use "device_set_wakeup_enable()"
to wakeup-enable the device accordingly.

Signed-off-by: Vaibhav Gupta <vaibhavgupta40@gmail.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/e1000/e1000_main.c | 49 +++++--------------
 1 file changed, 13 insertions(+), 36 deletions(-)

diff --git a/drivers/net/ethernet/intel/e1000/e1000_main.c b/drivers/net/ethernet/intel/e1000/e1000_main.c
index d9fa4600f745..4b2de08137be 100644
--- a/drivers/net/ethernet/intel/e1000/e1000_main.c
+++ b/drivers/net/ethernet/intel/e1000/e1000_main.c
@@ -151,10 +151,8 @@ static int e1000_vlan_rx_kill_vid(struct net_device *netdev,
 				  __be16 proto, u16 vid);
 static void e1000_restore_vlan(struct e1000_adapter *adapter);
 
-#ifdef CONFIG_PM
-static int e1000_suspend(struct pci_dev *pdev, pm_message_t state);
-static int e1000_resume(struct pci_dev *pdev);
-#endif
+static int __maybe_unused e1000_suspend(struct device *dev);
+static int __maybe_unused e1000_resume(struct device *dev);
 static void e1000_shutdown(struct pci_dev *pdev);
 
 #ifdef CONFIG_NET_POLL_CONTROLLER
@@ -179,16 +177,16 @@ static const struct pci_error_handlers e1000_err_handler = {
 	.resume = e1000_io_resume,
 };
 
+static SIMPLE_DEV_PM_OPS(e1000_pm_ops, e1000_suspend, e1000_resume);
+
 static struct pci_driver e1000_driver = {
 	.name     = e1000_driver_name,
 	.id_table = e1000_pci_tbl,
 	.probe    = e1000_probe,
 	.remove   = e1000_remove,
-#ifdef CONFIG_PM
-	/* Power Management Hooks */
-	.suspend  = e1000_suspend,
-	.resume   = e1000_resume,
-#endif
+	.driver = {
+		.pm = &e1000_pm_ops,
+	},
 	.shutdown = e1000_shutdown,
 	.err_handler = &e1000_err_handler
 };
@@ -5060,9 +5058,6 @@ static int __e1000_shutdown(struct pci_dev *pdev, bool *enable_wake)
 	struct e1000_hw *hw = &adapter->hw;
 	u32 ctrl, ctrl_ext, rctl, status;
 	u32 wufc = adapter->wol;
-#ifdef CONFIG_PM
-	int retval = 0;
-#endif
 
 	netif_device_detach(netdev);
 
@@ -5076,12 +5071,6 @@ static int __e1000_shutdown(struct pci_dev *pdev, bool *enable_wake)
 		e1000_down(adapter);
 	}
 
-#ifdef CONFIG_PM
-	retval = pci_save_state(pdev);
-	if (retval)
-		return retval;
-#endif
-
 	status = er32(STATUS);
 	if (status & E1000_STATUS_LU)
 		wufc &= ~E1000_WUFC_LNKC;
@@ -5142,37 +5131,26 @@ static int __e1000_shutdown(struct pci_dev *pdev, bool *enable_wake)
 	return 0;
 }
 
-#ifdef CONFIG_PM
-static int e1000_suspend(struct pci_dev *pdev, pm_message_t state)
+static int __maybe_unused e1000_suspend(struct device *dev)
 {
 	int retval;
+	struct pci_dev *pdev = to_pci_dev(dev);
 	bool wake;
 
 	retval = __e1000_shutdown(pdev, &wake);
-	if (retval)
-		return retval;
-
-	if (wake) {
-		pci_prepare_to_sleep(pdev);
-	} else {
-		pci_wake_from_d3(pdev, false);
-		pci_set_power_state(pdev, PCI_D3hot);
-	}
+	device_set_wakeup_enable(dev, wake);
 
-	return 0;
+	return retval;
 }
 
-static int e1000_resume(struct pci_dev *pdev)
+static int __maybe_unused e1000_resume(struct device *dev)
 {
+	struct pci_dev *pdev = to_pci_dev(dev);
 	struct net_device *netdev = pci_get_drvdata(pdev);
 	struct e1000_adapter *adapter = netdev_priv(netdev);
 	struct e1000_hw *hw = &adapter->hw;
 	u32 err;
 
-	pci_set_power_state(pdev, PCI_D0);
-	pci_restore_state(pdev);
-	pci_save_state(pdev);
-
 	if (adapter->need_ioport)
 		err = pci_enable_device(pdev);
 	else
@@ -5209,7 +5187,6 @@ static int e1000_resume(struct pci_dev *pdev)
 
 	return 0;
 }
-#endif
 
 static void e1000_shutdown(struct pci_dev *pdev)
 {
-- 
2.26.2

