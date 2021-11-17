Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5279F454EDD
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 22:01:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239825AbhKQVEb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 16:04:31 -0500
Received: from mga12.intel.com ([192.55.52.136]:53253 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239777AbhKQVE3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Nov 2021 16:04:29 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10171"; a="214088389"
X-IronPort-AV: E=Sophos;i="5.87,241,1631602800"; 
   d="scan'208";a="214088389"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2021 13:01:29 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,241,1631602800"; 
   d="scan'208";a="604878278"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga004.jf.intel.com with ESMTP; 17 Nov 2021 13:01:29 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        Vaibhav Gupta <vaibhavgupta40@gmail.com>,
        Alexey Kuznetsov <axet@me.com>
Subject: [PATCH net 1/1] e100: fix device suspend/resume
Date:   Wed, 17 Nov 2021 12:59:52 -0800
Message-Id: <20211117205952.3792122-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jesse Brandeburg <jesse.brandeburg@intel.com>

As reported in [1], e100 was no longer working for suspend/resume
cycles. The previous commit mentioned in the fixes appears to have
broken things and this attempts to practice best known methods for
device power management and keep wake-up working while allowing
suspend/resume to work. To do this, I reorder a little bit of code
and fix the resume path to make sure the device is enabled.

[1] https://bugzilla.kernel.org/show_bug.cgi?id=214933

Fixes: 69a74aef8a18 ("e100: use generic power management")
Cc: Vaibhav Gupta <vaibhavgupta40@gmail.com>
Reported-by: Alexey Kuznetsov <axet@me.com>
Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Tested-by: Alexey Kuznetsov <axet@me.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/e100.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/intel/e100.c b/drivers/net/ethernet/intel/e100.c
index 5039a2536951..0bf3d47bb90d 100644
--- a/drivers/net/ethernet/intel/e100.c
+++ b/drivers/net/ethernet/intel/e100.c
@@ -3003,9 +3003,10 @@ static void __e100_shutdown(struct pci_dev *pdev, bool *enable_wake)
 	struct net_device *netdev = pci_get_drvdata(pdev);
 	struct nic *nic = netdev_priv(netdev);
 
+	netif_device_detach(netdev);
+
 	if (netif_running(netdev))
 		e100_down(nic);
-	netif_device_detach(netdev);
 
 	if ((nic->flags & wol_magic) | e100_asf(nic)) {
 		/* enable reverse auto-negotiation */
@@ -3022,7 +3023,7 @@ static void __e100_shutdown(struct pci_dev *pdev, bool *enable_wake)
 		*enable_wake = false;
 	}
 
-	pci_clear_master(pdev);
+	pci_disable_device(pdev);
 }
 
 static int __e100_power_off(struct pci_dev *pdev, bool wake)
@@ -3042,8 +3043,6 @@ static int __maybe_unused e100_suspend(struct device *dev_d)
 
 	__e100_shutdown(to_pci_dev(dev_d), &wake);
 
-	device_wakeup_disable(dev_d);
-
 	return 0;
 }
 
@@ -3051,6 +3050,14 @@ static int __maybe_unused e100_resume(struct device *dev_d)
 {
 	struct net_device *netdev = dev_get_drvdata(dev_d);
 	struct nic *nic = netdev_priv(netdev);
+	int err;
+
+	err = pci_enable_device(to_pci_dev(dev_d));
+	if (err) {
+		netdev_err(netdev, "Resume cannot enable PCI device, aborting\n");
+		return err;
+	}
+	pci_set_master(to_pci_dev(dev_d));
 
 	/* disable reverse auto-negotiation */
 	if (nic->phy == phy_82552_v) {
@@ -3062,10 +3069,11 @@ static int __maybe_unused e100_resume(struct device *dev_d)
 		           smartspeed & ~(E100_82552_REV_ANEG));
 	}
 
-	netif_device_attach(netdev);
 	if (netif_running(netdev))
 		e100_up(nic);
 
+	netif_device_attach(netdev);
+
 	return 0;
 }
 
-- 
2.31.1

