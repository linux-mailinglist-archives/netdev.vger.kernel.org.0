Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3C133EB579
	for <lists+netdev@lfdr.de>; Fri, 13 Aug 2021 14:27:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240522AbhHMM2S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Aug 2021 08:28:18 -0400
Received: from mga07.intel.com ([134.134.136.100]:22440 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229474AbhHMM2O (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Aug 2021 08:28:14 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10074"; a="279292439"
X-IronPort-AV: E=Sophos;i="5.84,318,1620716400"; 
   d="scan'208";a="279292439"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2021 05:27:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,318,1620716400"; 
   d="scan'208";a="528512741"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga002.fm.intel.com with ESMTP; 13 Aug 2021 05:27:45 -0700
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id 6BF82B1; Fri, 13 Aug 2021 15:27:45 +0300 (EEST)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Jonathan Lemon <jonathan.lemon@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Richard Cochran <richardcochran@gmail.com>
Subject: [PATCH v1 net-next 2/3] ptp_ocp: Convert to use managed functions pcim_* and devm_*
Date:   Fri, 13 Aug 2021 15:27:36 +0300
Message-Id: <20210813122737.45860-2-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210813122737.45860-1-andriy.shevchenko@linux.intel.com>
References: <20210813122737.45860-1-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This makes the error handling much more simpler than open-coding everything
and in addition makes the probe function smaller an tidier.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/ptp/ptp_ocp.c | 40 +++++++++-------------------------------
 1 file changed, 9 insertions(+), 31 deletions(-)

diff --git a/drivers/ptp/ptp_ocp.c b/drivers/ptp/ptp_ocp.c
index 874ea7930079..5d0c0c0734f2 100644
--- a/drivers/ptp/ptp_ocp.c
+++ b/drivers/ptp/ptp_ocp.c
@@ -301,30 +301,25 @@ ptp_ocp_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	struct ptp_ocp *bp;
 	int err;
 
-	bp = kzalloc(sizeof(*bp), GFP_KERNEL);
+	bp = devm_kzalloc(&pdev->dev, sizeof(*bp), GFP_KERNEL);
 	if (!bp)
 		return -ENOMEM;
 	bp->pdev = pdev;
 	pci_set_drvdata(pdev, bp);
 
-	err = pci_enable_device(pdev);
+	err = pcim_enable_device(pdev);
 	if (err) {
 		dev_err(&pdev->dev, "pci_enable_device\n");
-		goto out_free;
+		return err;
 	}
 
-	err = pci_request_regions(pdev, KBUILD_MODNAME);
+	err = pcim_iomap_regions(pdev, BIT(0), KBUILD_MODNAME);
 	if (err) {
-		dev_err(&pdev->dev, "pci_request_region\n");
-		goto out_disable;
-	}
-
-	bp->base = pci_ioremap_bar(pdev, 0);
-	if (!bp->base) {
 		dev_err(&pdev->dev, "io_remap bar0\n");
-		err = -ENOMEM;
-		goto out_release_regions;
+		return err;
 	}
+
+	bp->base = pcim_iomap_table(pdev)[0];
 	bp->reg = bp->base + OCP_REGISTER_OFFSET;
 	bp->tod = bp->base + TOD_REGISTER_OFFSET;
 	bp->ptp_info = ptp_ocp_clock_info;
@@ -332,29 +327,17 @@ ptp_ocp_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	err = ptp_ocp_check_clock(bp);
 	if (err)
-		goto out;
+		return err;
 
 	bp->ptp = ptp_clock_register(&bp->ptp_info, &pdev->dev);
 	if (IS_ERR(bp->ptp)) {
 		dev_err(&pdev->dev, "ptp_clock_register\n");
-		err = PTR_ERR(bp->ptp);
-		goto out;
+		return PTR_ERR(bp->ptp);
 	}
 
 	ptp_ocp_info(bp);
 
 	return 0;
-
-out:
-	pci_iounmap(pdev, bp->base);
-out_release_regions:
-	pci_release_regions(pdev);
-out_disable:
-	pci_disable_device(pdev);
-out_free:
-	kfree(bp);
-
-	return err;
 }
 
 static void
@@ -363,11 +346,6 @@ ptp_ocp_remove(struct pci_dev *pdev)
 	struct ptp_ocp *bp = pci_get_drvdata(pdev);
 
 	ptp_clock_unregister(bp->ptp);
-	pci_iounmap(pdev, bp->base);
-	pci_release_regions(pdev);
-	pci_disable_device(pdev);
-	pci_set_drvdata(pdev, NULL);
-	kfree(bp);
 }
 
 static struct pci_driver ptp_ocp_driver = {
-- 
2.30.2

