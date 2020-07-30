Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AAEC2339C5
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 22:37:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730505AbgG3Uhm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 16:37:42 -0400
Received: from mga14.intel.com ([192.55.52.115]:30887 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728750AbgG3Uh1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Jul 2020 16:37:27 -0400
IronPort-SDR: ixvAG4Uyf13yeNBLlNcieI+EkQjqC+w7gIB3fZUAe51zs45vtcT9a7VI+0hp7gBLuyoFz1b1u0
 38dx3/PDPeVQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9698"; a="150885530"
X-IronPort-AV: E=Sophos;i="5.75,415,1589266800"; 
   d="scan'208";a="150885530"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jul 2020 13:37:25 -0700
IronPort-SDR: UvnlHKLN8jhNIwUtXRyztDopoI5a+2sLZDj1go2Svy5oTmMC9sSnPluRAsxkQgNcojjqD202S7
 AnY7ODCV95hQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,415,1589266800"; 
   d="scan'208";a="274324259"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga008.fm.intel.com with ESMTP; 30 Jul 2020 13:37:25 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net
Cc:     Vaibhav Gupta <vaibhavgupta40@gmail.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        jeffrey.t.kirsher@intel.com, anthony.l.nguyen@intel.com,
        Aaron Brown <aaron.f.brown@intel.com>
Subject: [net-next 05/12] e100: use generic power management
Date:   Thu, 30 Jul 2020 13:37:13 -0700
Message-Id: <20200730203720.3843018-6-anthony.l.nguyen@intel.com>
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

e100_suspend() calls __e100_shutdown() to perform intermediate tasks.
__e100_shutdown() calls pci_save_state() which is not recommended.

e100_suspend() also calls __e100_power_off() which is calling PCI helper
functions, pci_prepare_to_sleep(), pci_set_power_state(), along with
pci_wake_from_d3(...,false). Hence, the functin call is removed and wol is
disabled as earlier using device_wakeup_disable().

Compile-tested only.

Signed-off-by: Vaibhav Gupta <vaibhavgupta40@gmail.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/e100.c | 32 ++++++++++++++-----------------
 1 file changed, 14 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/intel/e100.c b/drivers/net/ethernet/intel/e100.c
index 91c64f91a835..36da059388dc 100644
--- a/drivers/net/ethernet/intel/e100.c
+++ b/drivers/net/ethernet/intel/e100.c
@@ -2993,8 +2993,6 @@ static void __e100_shutdown(struct pci_dev *pdev, bool *enable_wake)
 		e100_down(nic);
 	netif_device_detach(netdev);
 
-	pci_save_state(pdev);
-
 	if ((nic->flags & wol_magic) | e100_asf(nic)) {
 		/* enable reverse auto-negotiation */
 		if (nic->phy == phy_82552_v) {
@@ -3024,24 +3022,22 @@ static int __e100_power_off(struct pci_dev *pdev, bool wake)
 	return 0;
 }
 
-#ifdef CONFIG_PM
-static int e100_suspend(struct pci_dev *pdev, pm_message_t state)
+static int __maybe_unused e100_suspend(struct device *dev_d)
 {
 	bool wake;
-	__e100_shutdown(pdev, &wake);
-	return __e100_power_off(pdev, wake);
+
+	__e100_shutdown(to_pci_dev(dev_d), &wake);
+
+	device_wakeup_disable(dev_d);
+
+	return 0;
 }
 
-static int e100_resume(struct pci_dev *pdev)
+static int __maybe_unused e100_resume(struct device *dev_d)
 {
-	struct net_device *netdev = pci_get_drvdata(pdev);
+	struct net_device *netdev = dev_get_drvdata(dev_d);
 	struct nic *nic = netdev_priv(netdev);
 
-	pci_set_power_state(pdev, PCI_D0);
-	pci_restore_state(pdev);
-	/* ack any pending wake events, disable PME */
-	pci_enable_wake(pdev, PCI_D0, 0);
-
 	/* disable reverse auto-negotiation */
 	if (nic->phy == phy_82552_v) {
 		u16 smartspeed = mdio_read(netdev, nic->mii.phy_id,
@@ -3058,7 +3054,6 @@ static int e100_resume(struct pci_dev *pdev)
 
 	return 0;
 }
-#endif /* CONFIG_PM */
 
 static void e100_shutdown(struct pci_dev *pdev)
 {
@@ -3146,16 +3141,17 @@ static const struct pci_error_handlers e100_err_handler = {
 	.resume = e100_io_resume,
 };
 
+static SIMPLE_DEV_PM_OPS(e100_pm_ops, e100_suspend, e100_resume);
+
 static struct pci_driver e100_driver = {
 	.name =         DRV_NAME,
 	.id_table =     e100_id_table,
 	.probe =        e100_probe,
 	.remove =       e100_remove,
-#ifdef CONFIG_PM
+
 	/* Power Management hooks */
-	.suspend =      e100_suspend,
-	.resume =       e100_resume,
-#endif
+	.driver.pm =	&e100_pm_ops,
+
 	.shutdown =     e100_shutdown,
 	.err_handler = &e100_err_handler,
 };
-- 
2.26.2

