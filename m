Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 021AA33C64A
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 20:02:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232881AbhCOTBs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 15:01:48 -0400
Received: from mga06.intel.com ([134.134.136.31]:1827 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231916AbhCOTBm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Mar 2021 15:01:42 -0400
IronPort-SDR: g+g/VxUXkb21Utx/FVMufRN0cFnwAMtEwd5YT/ogUfguVv5PKeocT1dU+dwHD8FRR6LnqJFijk
 GnAst3matiaQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9924"; a="250506211"
X-IronPort-AV: E=Sophos;i="5.81,251,1610438400"; 
   d="scan'208";a="250506211"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2021 12:01:16 -0700
IronPort-SDR: 2NjtNKSSKMz3n7VJuwb4yD5EjwCH2BuoGK1fkiNYI2tlBf0cYbhC3bxe/mYjBJcxD8BnSntqQz
 n62woH/9Te4A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,251,1610438400"; 
   d="scan'208";a="405264527"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga008.fm.intel.com with ESMTP; 15 Mar 2021 12:01:15 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Chen Yu <yu.c.chen@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com,
        kai.heng.feng@canonical.com, rjw@rjwysocki.net,
        len.brown@intel.com, todd.e.brandt@intel.com,
        sasha.neftin@intel.com, vitaly.lifshits@intel.com,
        Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>
Subject: [PATCH net-next 1/2] e1000e: Leverage direct_complete to speed up s2ram
Date:   Mon, 15 Mar 2021 12:02:30 -0700
Message-Id: <20210315190231.3302869-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210315190231.3302869-1-anthony.l.nguyen@intel.com>
References: <20210315190231.3302869-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chen Yu <yu.c.chen@intel.com>

The NIC is put in runtime suspend status when there is no cable connected.
As a result, it is safe to keep non-wakeup NIC in runtime suspended during
s2ram because the system does not rely on the NIC plug event nor WoL to wake
up the system. Besides that, unlike the s2idle, s2ram does not need to
manipulate S0ix settings during suspend.

This patch introduces the .prepare() for e1000e so that if the NIC is runtime
suspended the subsequent suspend/resume hooks will be skipped so as to speed
up the s2ram. The pm core will check whether the NIC is a wake up device so
there's no need to check it again in .prepare(). DPM_FLAG_SMART_PREPARE flag
should be set during probe to ask the pci subsystem to honor the driver's
prepare() result. Besides, the NIC remains runtime suspended after resumed
from s2ram as there is no need to resume it.

Tested on i7-2600K with 82579V NIC
Before the patch:
e1000e 0000:00:19.0: pci_pm_suspend+0x0/0x160 returned 0 after 225146 usecs
e1000e 0000:00:19.0: pci_pm_resume+0x0/0x90 returned 0 after 140588 usecs

After the patch:
echo disabled > //sys/devices/pci0000\:00/0000\:00\:19.0/power/wakeup
becomes 0 usecs because the hooks will be skipped.

Suggested-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Signed-off-by: Chen Yu <yu.c.chen@intel.com>
Tested-by: Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/e1000e/netdev.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index e9b82c209c2d..8cd1b3e9e514 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -25,6 +25,7 @@
 #include <linux/pm_runtime.h>
 #include <linux/aer.h>
 #include <linux/prefetch.h>
+#include <linux/suspend.h>
 
 #include "e1000.h"
 
@@ -6918,6 +6919,12 @@ static int __e1000_resume(struct pci_dev *pdev)
 	return 0;
 }
 
+static __maybe_unused int e1000e_pm_prepare(struct device *dev)
+{
+	return pm_runtime_suspended(dev) &&
+		pm_suspend_via_firmware();
+}
+
 static __maybe_unused int e1000e_pm_suspend(struct device *dev)
 {
 	struct net_device *netdev = pci_get_drvdata(to_pci_dev(dev));
@@ -7626,7 +7633,7 @@ static int e1000_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	e1000_print_device_info(adapter);
 
-	dev_pm_set_driver_flags(&pdev->dev, DPM_FLAG_NO_DIRECT_COMPLETE);
+	dev_pm_set_driver_flags(&pdev->dev, DPM_FLAG_SMART_PREPARE);
 
 	if (pci_dev_run_wake(pdev) && hw->mac.type < e1000_pch_cnp)
 		pm_runtime_put_noidle(&pdev->dev);
@@ -7851,6 +7858,7 @@ MODULE_DEVICE_TABLE(pci, e1000_pci_tbl);
 
 static const struct dev_pm_ops e1000_pm_ops = {
 #ifdef CONFIG_PM_SLEEP
+	.prepare	= e1000e_pm_prepare,
 	.suspend	= e1000e_pm_suspend,
 	.resume		= e1000e_pm_resume,
 	.freeze		= e1000e_pm_freeze,
-- 
2.26.2

