Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 065F247B446
	for <lists+netdev@lfdr.de>; Mon, 20 Dec 2021 21:20:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229970AbhLTUTm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Dec 2021 15:19:42 -0500
Received: from mga03.intel.com ([134.134.136.65]:56197 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229531AbhLTUTm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Dec 2021 15:19:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1640031582; x=1671567582;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=a4VMoGHztcKfoljjEtCLwSrsbmVcdmXZ7bRU/8E6z6U=;
  b=NJq5HvpcZ4PcgBmpSypGddzI68moiN/VtnYdT+cKtA5dN+t7ua1xlq+u
   Oy2O16kE2wqYumwlhb4la78tSJWaCmkGKhzlBSL0H2t5G6RGmu0SYsxnE
   iQ/6T2gW5hxwkir8UAMNdbu4BX2y3tqOh+ZNiyrTerjykX2ILE2D/gN0f
   XWkU+xIDJ2YEUTYQ7rau3ZFOb8Noi/58CsZjkXR27pJmH14jWnavziWct
   7caOgK+QgAG9bCuXEWXOhC1S3/Kc8bbEhDXzQb6lyvLZQLPwEnMKv1CNq
   2ZOwWFNHtjM52ESpQt7KtjJzrmXgb3tddWg5i87ewn4n5qd3n8Gr9oOZp
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10204"; a="240216649"
X-IronPort-AV: E=Sophos;i="5.88,221,1635231600"; 
   d="scan'208";a="240216649"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Dec 2021 12:19:41 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,221,1635231600"; 
   d="scan'208";a="755518406"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga006.fm.intel.com with ESMTP; 20 Dec 2021 12:19:41 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, stable@vger.kernel.org,
        Martin Stolpe <martin.stolpe@gmail.com>
Subject: [PATCH net 1/1] igb: fix deadlock caused by taking RTNL in RPM resume path
Date:   Mon, 20 Dec 2021 12:18:44 -0800
Message-Id: <20211220201844.2714498-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>

Recent net core changes caused an issue with few Intel drivers
(reportedly igb), where taking RTNL in RPM resume path results in a
deadlock. See [0] for a bug report. I don't think the core changes
are wrong, but taking RTNL in RPM resume path isn't needed.
The Intel drivers are the only ones doing this. See [1] for a
discussion on the issue. Following patch changes the RPM resume path
to not take RTNL.

[0] https://bugzilla.kernel.org/show_bug.cgi?id=215129
[1] https://lore.kernel.org/netdev/20211125074949.5f897431@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com/t/

Cc: stable@vger.kernel.org
Fixes: bd869245a3dc ("net: core: try to runtime-resume detached device in __dev_open")
Fixes: f32a21376573 ("ethtool: runtime-resume netdev parent before ethtool ioctl ops")
Tested-by: Martin Stolpe <martin.stolpe@gmail.com>
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/igb/igb_main.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index b597b8bfb910..446894dde182 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -9254,7 +9254,7 @@ static int __maybe_unused igb_suspend(struct device *dev)
 	return __igb_shutdown(to_pci_dev(dev), NULL, 0);
 }
 
-static int __maybe_unused igb_resume(struct device *dev)
+static int __maybe_unused __igb_resume(struct device *dev, bool rpm)
 {
 	struct pci_dev *pdev = to_pci_dev(dev);
 	struct net_device *netdev = pci_get_drvdata(pdev);
@@ -9297,17 +9297,24 @@ static int __maybe_unused igb_resume(struct device *dev)
 
 	wr32(E1000_WUS, ~0);
 
-	rtnl_lock();
+	if (!rpm)
+		rtnl_lock();
 	if (!err && netif_running(netdev))
 		err = __igb_open(netdev, true);
 
 	if (!err)
 		netif_device_attach(netdev);
-	rtnl_unlock();
+	if (!rpm)
+		rtnl_unlock();
 
 	return err;
 }
 
+static int __maybe_unused igb_resume(struct device *dev)
+{
+	return __igb_resume(dev, false);
+}
+
 static int __maybe_unused igb_runtime_idle(struct device *dev)
 {
 	struct net_device *netdev = dev_get_drvdata(dev);
@@ -9326,7 +9333,7 @@ static int __maybe_unused igb_runtime_suspend(struct device *dev)
 
 static int __maybe_unused igb_runtime_resume(struct device *dev)
 {
-	return igb_resume(dev);
+	return __igb_resume(dev, true);
 }
 
 static void igb_shutdown(struct pci_dev *pdev)
@@ -9442,7 +9449,7 @@ static pci_ers_result_t igb_io_error_detected(struct pci_dev *pdev,
  *  @pdev: Pointer to PCI device
  *
  *  Restart the card from scratch, as if from a cold-boot. Implementation
- *  resembles the first-half of the igb_resume routine.
+ *  resembles the first-half of the __igb_resume routine.
  **/
 static pci_ers_result_t igb_io_slot_reset(struct pci_dev *pdev)
 {
@@ -9482,7 +9489,7 @@ static pci_ers_result_t igb_io_slot_reset(struct pci_dev *pdev)
  *
  *  This callback is called when the error recovery driver tells us that
  *  its OK to resume normal operation. Implementation resembles the
- *  second-half of the igb_resume routine.
+ *  second-half of the __igb_resume routine.
  */
 static void igb_io_resume(struct pci_dev *pdev)
 {
-- 
2.31.1

