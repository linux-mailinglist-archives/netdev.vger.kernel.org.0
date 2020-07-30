Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD9312339D1
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 22:38:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730530AbgG3Uhr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 16:37:47 -0400
Received: from mga14.intel.com ([192.55.52.115]:30885 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728745AbgG3Uh0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Jul 2020 16:37:26 -0400
IronPort-SDR: LEYm9SVyV9VReNT7ElnJVGFmlg1HI4BsoW/lMdrg5ni2cpKX5eqrh70KEjNyV09J1iU7V4XIxY
 M0b+Zy4kq7NQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9698"; a="150885528"
X-IronPort-AV: E=Sophos;i="5.75,415,1589266800"; 
   d="scan'208";a="150885528"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jul 2020 13:37:25 -0700
IronPort-SDR: IOJ6AXM06kFNyBgrYEDjtFQ/9om5DSFsMN/XWuHu1zq8/sGs3BJL8E4UwSbRbfun4HAlexiXip
 lF60RzeXHGtA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,415,1589266800"; 
   d="scan'208";a="274324255"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga008.fm.intel.com with ESMTP; 30 Jul 2020 13:37:24 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net
Cc:     Vaibhav Gupta <vaibhavgupta40@gmail.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        jeffrey.t.kirsher@intel.com, anthony.l.nguyen@intel.com,
        Andrew Bowers <andrewx.bowers@intel.com>
Subject: [net-next 04/12] ixgbevf: use generic power management
Date:   Thu, 30 Jul 2020 13:37:12 -0700
Message-Id: <20200730203720.3843018-5-anthony.l.nguyen@intel.com>
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

With legacy PM, drivers themselves were responsible for managing the
device's power states and takes care of register states.

After upgrading to the generic structure, PCI core will take care of
required tasks and drivers should do only device-specific operations.

The driver was invoking PCI helper functions like pci_save/restore_state(),
and pci_enable/disable_device(), which is not recommended.

Compile-tested only.

Signed-off-by: Vaibhav Gupta <vaibhavgupta40@gmail.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 .../net/ethernet/intel/ixgbevf/ixgbevf_main.c | 44 +++++--------------
 1 file changed, 10 insertions(+), 34 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
index 6e9a397db583..c3d26cc0cf51 100644
--- a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
+++ b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
@@ -4297,13 +4297,10 @@ static int ixgbevf_change_mtu(struct net_device *netdev, int new_mtu)
 	return 0;
 }
 
-static int ixgbevf_suspend(struct pci_dev *pdev, pm_message_t state)
+static int __maybe_unused ixgbevf_suspend(struct device *dev_d)
 {
-	struct net_device *netdev = pci_get_drvdata(pdev);
+	struct net_device *netdev = dev_get_drvdata(dev_d);
 	struct ixgbevf_adapter *adapter = netdev_priv(netdev);
-#ifdef CONFIG_PM
-	int retval = 0;
-#endif
 
 	rtnl_lock();
 	netif_device_detach(netdev);
@@ -4314,37 +4311,16 @@ static int ixgbevf_suspend(struct pci_dev *pdev, pm_message_t state)
 	ixgbevf_clear_interrupt_scheme(adapter);
 	rtnl_unlock();
 
-#ifdef CONFIG_PM
-	retval = pci_save_state(pdev);
-	if (retval)
-		return retval;
-
-#endif
-	if (!test_and_set_bit(__IXGBEVF_DISABLED, &adapter->state))
-		pci_disable_device(pdev);
-
 	return 0;
 }
 
-#ifdef CONFIG_PM
-static int ixgbevf_resume(struct pci_dev *pdev)
+static int __maybe_unused ixgbevf_resume(struct device *dev_d)
 {
+	struct pci_dev *pdev = to_pci_dev(dev_d);
 	struct net_device *netdev = pci_get_drvdata(pdev);
 	struct ixgbevf_adapter *adapter = netdev_priv(netdev);
 	u32 err;
 
-	pci_restore_state(pdev);
-	/* pci_restore_state clears dev->state_saved so call
-	 * pci_save_state to restore it.
-	 */
-	pci_save_state(pdev);
-
-	err = pci_enable_device_mem(pdev);
-	if (err) {
-		dev_err(&pdev->dev, "Cannot enable PCI device from suspend\n");
-		return err;
-	}
-
 	adapter->hw.hw_addr = adapter->io_addr;
 	smp_mb__before_atomic();
 	clear_bit(__IXGBEVF_DISABLED, &adapter->state);
@@ -4365,10 +4341,9 @@ static int ixgbevf_resume(struct pci_dev *pdev)
 	return err;
 }
 
-#endif /* CONFIG_PM */
 static void ixgbevf_shutdown(struct pci_dev *pdev)
 {
-	ixgbevf_suspend(pdev, PMSG_SUSPEND);
+	ixgbevf_suspend(&pdev->dev);
 }
 
 static void ixgbevf_get_tx_ring_stats(struct rtnl_link_stats64 *stats,
@@ -4888,16 +4863,17 @@ static const struct pci_error_handlers ixgbevf_err_handler = {
 	.resume = ixgbevf_io_resume,
 };
 
+static SIMPLE_DEV_PM_OPS(ixgbevf_pm_ops, ixgbevf_suspend, ixgbevf_resume);
+
 static struct pci_driver ixgbevf_driver = {
 	.name		= ixgbevf_driver_name,
 	.id_table	= ixgbevf_pci_tbl,
 	.probe		= ixgbevf_probe,
 	.remove		= ixgbevf_remove,
-#ifdef CONFIG_PM
+
 	/* Power Management Hooks */
-	.suspend	= ixgbevf_suspend,
-	.resume		= ixgbevf_resume,
-#endif
+	.driver.pm	= &ixgbevf_pm_ops,
+
 	.shutdown	= ixgbevf_shutdown,
 	.err_handler	= &ixgbevf_err_handler
 };
-- 
2.26.2

