Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A9302339D0
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 22:38:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729166AbgG3Uh0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 16:37:26 -0400
Received: from mga14.intel.com ([192.55.52.115]:30887 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728722AbgG3UhZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Jul 2020 16:37:25 -0400
IronPort-SDR: JqoGvJChQVksGPApYKezU0phieC7zo0pvTOQCC3jOH31plp+NichDKYb01Rd/0vEyIGV/D+h0B
 /hWVO/qm3xiA==
X-IronPort-AV: E=McAfee;i="6000,8403,9698"; a="150885526"
X-IronPort-AV: E=Sophos;i="5.75,415,1589266800"; 
   d="scan'208";a="150885526"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jul 2020 13:37:24 -0700
IronPort-SDR: cDmsRKr+d3bQ7FVefk4bEfOUMJ3gM6756WugplZ84hZ70WjQs6ilbTZ76dgOKGbXIQyjZSg2NR
 78vKgT1MKlFQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,415,1589266800"; 
   d="scan'208";a="274324249"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga008.fm.intel.com with ESMTP; 30 Jul 2020 13:37:24 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net
Cc:     Vaibhav Gupta <vaibhavgupta40@gmail.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        jeffrey.t.kirsher@intel.com, anthony.l.nguyen@intel.com,
        Aaron Brown <aaron.f.brown@intel.com>
Subject: [net-next 02/12] igbvf: use generic power management
Date:   Thu, 30 Jul 2020 13:37:10 -0700
Message-Id: <20200730203720.3843018-3-anthony.l.nguyen@intel.com>
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

Remove legacy PM callbacks and use generic operations. With legacy code,
drivers were responsible for handling PCI PM operations like
pci_save_state(). In generic code, all these are handled by PCI core.

The generic suspend() and resume() are called at the same point the legacy
ones were called. Thus, it does not affect the normal functioning of the
driver.

__maybe_unused attribute is used with .resume() but not with .suspend(), as
.suspend() is called by .shutdown().

Compile-tested only.

Signed-off-by: Vaibhav Gupta <vaibhavgupta40@gmail.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/igbvf/netdev.c | 37 +++++------------------
 1 file changed, 8 insertions(+), 29 deletions(-)

diff --git a/drivers/net/ethernet/intel/igbvf/netdev.c b/drivers/net/ethernet/intel/igbvf/netdev.c
index 97a065928976..19269f5d52bc 100644
--- a/drivers/net/ethernet/intel/igbvf/netdev.c
+++ b/drivers/net/ethernet/intel/igbvf/netdev.c
@@ -2457,13 +2457,10 @@ static int igbvf_ioctl(struct net_device *netdev, struct ifreq *ifr, int cmd)
 	}
 }
 
-static int igbvf_suspend(struct pci_dev *pdev, pm_message_t state)
+static int igbvf_suspend(struct device *dev_d)
 {
-	struct net_device *netdev = pci_get_drvdata(pdev);
+	struct net_device *netdev = dev_get_drvdata(dev_d);
 	struct igbvf_adapter *adapter = netdev_priv(netdev);
-#ifdef CONFIG_PM
-	int retval = 0;
-#endif
 
 	netif_device_detach(netdev);
 
@@ -2473,31 +2470,16 @@ static int igbvf_suspend(struct pci_dev *pdev, pm_message_t state)
 		igbvf_free_irq(adapter);
 	}
 
-#ifdef CONFIG_PM
-	retval = pci_save_state(pdev);
-	if (retval)
-		return retval;
-#endif
-
-	pci_disable_device(pdev);
-
 	return 0;
 }
 
-#ifdef CONFIG_PM
-static int igbvf_resume(struct pci_dev *pdev)
+static int __maybe_unused igbvf_resume(struct device *dev_d)
 {
+	struct pci_dev *pdev = to_pci_dev(dev_d);
 	struct net_device *netdev = pci_get_drvdata(pdev);
 	struct igbvf_adapter *adapter = netdev_priv(netdev);
 	u32 err;
 
-	pci_restore_state(pdev);
-	err = pci_enable_device_mem(pdev);
-	if (err) {
-		dev_err(&pdev->dev, "Cannot enable PCI device from suspend\n");
-		return err;
-	}
-
 	pci_set_master(pdev);
 
 	if (netif_running(netdev)) {
@@ -2515,11 +2497,10 @@ static int igbvf_resume(struct pci_dev *pdev)
 
 	return 0;
 }
-#endif
 
 static void igbvf_shutdown(struct pci_dev *pdev)
 {
-	igbvf_suspend(pdev, PMSG_SUSPEND);
+	igbvf_suspend(&pdev->dev);
 }
 
 #ifdef CONFIG_NET_POLL_CONTROLLER
@@ -2960,17 +2941,15 @@ static const struct pci_device_id igbvf_pci_tbl[] = {
 };
 MODULE_DEVICE_TABLE(pci, igbvf_pci_tbl);
 
+static SIMPLE_DEV_PM_OPS(igbvf_pm_ops, igbvf_suspend, igbvf_resume);
+
 /* PCI Device API Driver */
 static struct pci_driver igbvf_driver = {
 	.name		= igbvf_driver_name,
 	.id_table	= igbvf_pci_tbl,
 	.probe		= igbvf_probe,
 	.remove		= igbvf_remove,
-#ifdef CONFIG_PM
-	/* Power Management Hooks */
-	.suspend	= igbvf_suspend,
-	.resume		= igbvf_resume,
-#endif
+	.driver.pm	= &igbvf_pm_ops,
 	.shutdown	= igbvf_shutdown,
 	.err_handler	= &igbvf_err_handler
 };
-- 
2.26.2

