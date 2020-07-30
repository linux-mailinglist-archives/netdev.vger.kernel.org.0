Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46BD72339BC
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 22:37:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730343AbgG3Uh0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 16:37:26 -0400
Received: from mga14.intel.com ([192.55.52.115]:30885 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728630AbgG3UhZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Jul 2020 16:37:25 -0400
IronPort-SDR: Qs271AQmbZR7eKDmPZMnukItDTdk+izVLDqgEgrGfbLXqQfmrALsnR2EDHB9c7szslMyjdz7+X
 dbCzc+eCFetA==
X-IronPort-AV: E=McAfee;i="6000,8403,9698"; a="150885525"
X-IronPort-AV: E=Sophos;i="5.75,415,1589266800"; 
   d="scan'208";a="150885525"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jul 2020 13:37:24 -0700
IronPort-SDR: 2S8knesL2VTr5rCBvdKPhJISuyC4AykOMkMaJiZwYsqpz1NkWL/WDN9f/az+v+EW18KbQDxEsi
 QzVtJZUHVMwA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,415,1589266800"; 
   d="scan'208";a="274324246"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga008.fm.intel.com with ESMTP; 30 Jul 2020 13:37:24 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net
Cc:     Vaibhav Gupta <vaibhavgupta40@gmail.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        jeffrey.t.kirsher@intel.com, anthony.l.nguyen@intel.com,
        Andrew Bowers <andrewx.bowers@intel.com>
Subject: [net-next 01/12] iavf: use generic power management
Date:   Thu, 30 Jul 2020 13:37:09 -0700
Message-Id: <20200730203720.3843018-2-anthony.l.nguyen@intel.com>
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

With the support of generic PM callbacks, drivers no longer need to use
legacy .suspend() and .resume() in which they had to maintain PCI states
changes and device's power state themselves. The required operations are
done by PCI core.

PCI drivers are not expected to invoke PCI helper functions like
pci_save/restore_state(), pci_enable/disable_device(),
pci_set_power_state(), etc. Their tasks are completed by PCI core itself.

Compile-tested only.

Signed-off-by: Vaibhav Gupta <vaibhavgupta40@gmail.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/iavf/iavf_main.c | 45 ++++++---------------
 1 file changed, 12 insertions(+), 33 deletions(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index 48c956d90b90..d870343cf689 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -3766,7 +3766,6 @@ static int iavf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	return err;
 }
 
-#ifdef CONFIG_PM
 /**
  * iavf_suspend - Power management suspend routine
  * @pdev: PCI device information struct
@@ -3774,11 +3773,10 @@ static int iavf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
  *
  * Called when the system (VM) is entering sleep/suspend.
  **/
-static int iavf_suspend(struct pci_dev *pdev, pm_message_t state)
+static int __maybe_unused iavf_suspend(struct device *dev_d)
 {
-	struct net_device *netdev = pci_get_drvdata(pdev);
+	struct net_device *netdev = dev_get_drvdata(dev_d);
 	struct iavf_adapter *adapter = netdev_priv(netdev);
-	int retval = 0;
 
 	netif_device_detach(netdev);
 
@@ -3796,12 +3794,6 @@ static int iavf_suspend(struct pci_dev *pdev, pm_message_t state)
 
 	clear_bit(__IAVF_IN_CRITICAL_TASK, &adapter->crit_section);
 
-	retval = pci_save_state(pdev);
-	if (retval)
-		return retval;
-
-	pci_disable_device(pdev);
-
 	return 0;
 }
 
@@ -3811,24 +3803,13 @@ static int iavf_suspend(struct pci_dev *pdev, pm_message_t state)
  *
  * Called when the system (VM) is resumed from sleep/suspend.
  **/
-static int iavf_resume(struct pci_dev *pdev)
+static int __maybe_unused iavf_resume(struct device *dev_d)
 {
+	struct pci_dev *pdev = to_pci_dev(dev_d);
 	struct iavf_adapter *adapter = pci_get_drvdata(pdev);
 	struct net_device *netdev = adapter->netdev;
 	u32 err;
 
-	pci_set_power_state(pdev, PCI_D0);
-	pci_restore_state(pdev);
-	/* pci_restore_state clears dev->state_saved so call
-	 * pci_save_state to restore it.
-	 */
-	pci_save_state(pdev);
-
-	err = pci_enable_device_mem(pdev);
-	if (err) {
-		dev_err(&pdev->dev, "Cannot enable PCI device from suspend.\n");
-		return err;
-	}
 	pci_set_master(pdev);
 
 	rtnl_lock();
@@ -3852,7 +3833,6 @@ static int iavf_resume(struct pci_dev *pdev)
 	return err;
 }
 
-#endif /* CONFIG_PM */
 /**
  * iavf_remove - Device Removal Routine
  * @pdev: PCI device information struct
@@ -3954,16 +3934,15 @@ static void iavf_remove(struct pci_dev *pdev)
 	pci_disable_device(pdev);
 }
 
+static SIMPLE_DEV_PM_OPS(iavf_pm_ops, iavf_suspend, iavf_resume);
+
 static struct pci_driver iavf_driver = {
-	.name     = iavf_driver_name,
-	.id_table = iavf_pci_tbl,
-	.probe    = iavf_probe,
-	.remove   = iavf_remove,
-#ifdef CONFIG_PM
-	.suspend  = iavf_suspend,
-	.resume   = iavf_resume,
-#endif
-	.shutdown = iavf_shutdown,
+	.name      = iavf_driver_name,
+	.id_table  = iavf_pci_tbl,
+	.probe     = iavf_probe,
+	.remove    = iavf_remove,
+	.driver.pm = &iavf_pm_ops,
+	.shutdown  = iavf_shutdown,
 };
 
 /**
-- 
2.26.2

