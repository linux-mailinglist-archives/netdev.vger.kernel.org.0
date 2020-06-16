Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDBC91FC1E2
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 00:54:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726463AbgFPWyE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jun 2020 18:54:04 -0400
Received: from mga01.intel.com ([192.55.52.88]:27234 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725964AbgFPWyE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Jun 2020 18:54:04 -0400
IronPort-SDR: 1ltJcwNZz0NqfYTsz4Ws9msRLwQ8R86MZM3ZQ21wWwh7TWJpaMGCW7yDKbpVfprj02niMmYtjm
 hPel3iygxP+g==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2020 15:54:02 -0700
IronPort-SDR: emVEg9a1qXm8HEInDW0EiO+eofzVRd1/MbiSbB80jIuxPWJqd3d/GjoNTO/qId76/xsetxNnL3
 E24c3XNwKyWA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,520,1583222400"; 
   d="scan'208";a="317362151"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by FMSMGA003.fm.intel.com with ESMTP; 16 Jun 2020 15:53:57 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Arnd Bergmann <arnd@arndb.de>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net 3/3] e1000e: fix unused-function warning
Date:   Tue, 16 Jun 2020 15:53:54 -0700
Message-Id: <20200616225354.2744572-4-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200616225354.2744572-1-jeffrey.t.kirsher@intel.com>
References: <20200616225354.2744572-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

The CONFIG_PM_SLEEP #ifdef checks in this file are inconsistent,
leading to a warning about sometimes unused function:

drivers/net/ethernet/intel/e1000e/netdev.c:137:13: error: unused function 'e1000e_check_me' [-Werror,-Wunused-function]

Rather than adding more #ifdefs, just remove them completely
and mark the PM functions as __maybe_unused to let the compiler
work it out on it own.

Fixes: e086ba2fccda ("e1000e: disable s0ix entry and exit flows for ME systems")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/e1000e/netdev.c | 16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index e2ad3f38c75c..6f6479ca1267 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -6349,7 +6349,6 @@ static void e1000e_flush_lpic(struct pci_dev *pdev)
 	pm_runtime_put_sync(netdev->dev.parent);
 }
 
-#ifdef CONFIG_PM_SLEEP
 /* S0ix implementation */
 static void e1000e_s0ix_entry_flow(struct e1000_adapter *adapter)
 {
@@ -6571,7 +6570,6 @@ static void e1000e_s0ix_exit_flow(struct e1000_adapter *adapter)
 	mac_data &= ~E1000_CTRL_EXT_FORCE_SMBUS;
 	ew32(CTRL_EXT, mac_data);
 }
-#endif /* CONFIG_PM_SLEEP */
 
 static int e1000e_pm_freeze(struct device *dev)
 {
@@ -6875,7 +6873,6 @@ static int e1000e_pm_thaw(struct device *dev)
 	return rc;
 }
 
-#ifdef CONFIG_PM
 static int __e1000_resume(struct pci_dev *pdev)
 {
 	struct net_device *netdev = pci_get_drvdata(pdev);
@@ -6941,8 +6938,7 @@ static int __e1000_resume(struct pci_dev *pdev)
 	return 0;
 }
 
-#ifdef CONFIG_PM_SLEEP
-static int e1000e_pm_suspend(struct device *dev)
+static __maybe_unused int e1000e_pm_suspend(struct device *dev)
 {
 	struct net_device *netdev = pci_get_drvdata(to_pci_dev(dev));
 	struct e1000_adapter *adapter = netdev_priv(netdev);
@@ -6966,7 +6962,7 @@ static int e1000e_pm_suspend(struct device *dev)
 	return rc;
 }
 
-static int e1000e_pm_resume(struct device *dev)
+static __maybe_unused int e1000e_pm_resume(struct device *dev)
 {
 	struct net_device *netdev = pci_get_drvdata(to_pci_dev(dev));
 	struct e1000_adapter *adapter = netdev_priv(netdev);
@@ -6985,9 +6981,8 @@ static int e1000e_pm_resume(struct device *dev)
 
 	return e1000e_pm_thaw(dev);
 }
-#endif /* CONFIG_PM_SLEEP */
 
-static int e1000e_pm_runtime_idle(struct device *dev)
+static __maybe_unused int e1000e_pm_runtime_idle(struct device *dev)
 {
 	struct net_device *netdev = dev_get_drvdata(dev);
 	struct e1000_adapter *adapter = netdev_priv(netdev);
@@ -7003,7 +6998,7 @@ static int e1000e_pm_runtime_idle(struct device *dev)
 	return -EBUSY;
 }
 
-static int e1000e_pm_runtime_resume(struct device *dev)
+static __maybe_unused int e1000e_pm_runtime_resume(struct device *dev)
 {
 	struct pci_dev *pdev = to_pci_dev(dev);
 	struct net_device *netdev = pci_get_drvdata(pdev);
@@ -7020,7 +7015,7 @@ static int e1000e_pm_runtime_resume(struct device *dev)
 	return rc;
 }
 
-static int e1000e_pm_runtime_suspend(struct device *dev)
+static __maybe_unused int e1000e_pm_runtime_suspend(struct device *dev)
 {
 	struct pci_dev *pdev = to_pci_dev(dev);
 	struct net_device *netdev = pci_get_drvdata(pdev);
@@ -7045,7 +7040,6 @@ static int e1000e_pm_runtime_suspend(struct device *dev)
 
 	return 0;
 }
-#endif /* CONFIG_PM */
 
 static void e1000_shutdown(struct pci_dev *pdev)
 {
-- 
2.26.2

