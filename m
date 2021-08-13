Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D7CD3EB583
	for <lists+netdev@lfdr.de>; Fri, 13 Aug 2021 14:29:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240545AbhHMMaS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Aug 2021 08:30:18 -0400
Received: from mga18.intel.com ([134.134.136.126]:25646 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240145AbhHMMaN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Aug 2021 08:30:13 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10074"; a="202711827"
X-IronPort-AV: E=Sophos;i="5.84,318,1620716400"; 
   d="scan'208";a="202711827"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2021 05:29:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,318,1620716400"; 
   d="scan'208";a="591099845"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga001.fm.intel.com with ESMTP; 13 Aug 2021 05:29:38 -0700
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id AB21C4CF; Fri, 13 Aug 2021 15:29:37 +0300 (EEST)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Richard Cochran <richardcochran@gmail.com>
Subject: [PATCH v1 net-next 5/7] ptp_pch: Convert to use managed functions pcim_* and devm_*
Date:   Fri, 13 Aug 2021 15:29:30 +0300
Message-Id: <20210813122932.46152-5-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210813122932.46152-1-andriy.shevchenko@linux.intel.com>
References: <20210813122932.46152-1-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This makes the error handling much more simpler than open-coding everything
and in addition makes the probe function smaller an tidier.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/ptp/ptp_pch.c | 73 ++++++-------------------------------------
 1 file changed, 10 insertions(+), 63 deletions(-)

diff --git a/drivers/ptp/ptp_pch.c b/drivers/ptp/ptp_pch.c
index f3aafe45e1a6..29f793b04f2f 100644
--- a/drivers/ptp/ptp_pch.c
+++ b/drivers/ptp/ptp_pch.c
@@ -115,8 +115,6 @@ struct pch_dev {
 	int exts0_enabled;
 	int exts1_enabled;
 
-	u32 mem_base;
-	u32 mem_size;
 	u32 irq;
 	struct pci_dev *pdev;
 	spinlock_t register_lock;
@@ -456,24 +454,8 @@ static void pch_remove(struct pci_dev *pdev)
 {
 	struct pch_dev *chip = pci_get_drvdata(pdev);
 
+	free_irq(pdev->irq, chip);
 	ptp_clock_unregister(chip->ptp_clock);
-	/* free the interrupt */
-	if (pdev->irq != 0)
-		free_irq(pdev->irq, chip);
-
-	/* unmap the virtual IO memory space */
-	if (chip->regs != NULL) {
-		iounmap(chip->regs);
-		chip->regs = NULL;
-	}
-	/* release the reserved IO memory space */
-	if (chip->mem_base != 0) {
-		release_mem_region(chip->mem_base, chip->mem_size);
-		chip->mem_base = 0;
-	}
-	pci_disable_device(pdev);
-	kfree(chip);
-	dev_info(&pdev->dev, "complete\n");
 }
 
 static s32
@@ -483,50 +465,29 @@ pch_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	unsigned long flags;
 	struct pch_dev *chip;
 
-	chip = kzalloc(sizeof(struct pch_dev), GFP_KERNEL);
+	chip = devm_kzalloc(&pdev->dev, sizeof(*chip), GFP_KERNEL);
 	if (chip == NULL)
 		return -ENOMEM;
 
 	/* enable the 1588 pci device */
-	ret = pci_enable_device(pdev);
+	ret = pcim_enable_device(pdev);
 	if (ret != 0) {
 		dev_err(&pdev->dev, "could not enable the pci device\n");
-		goto err_pci_en;
+		return ret;
 	}
 
-	chip->mem_base = pci_resource_start(pdev, IO_MEM_BAR);
-	if (!chip->mem_base) {
+	ret = pcim_iomap_regions(pdev, BIT(IO_MEM_BAR), "1588_regs");
+	if (ret) {
 		dev_err(&pdev->dev, "could not locate IO memory address\n");
-		ret = -ENODEV;
-		goto err_pci_start;
-	}
-
-	/* retrieve the available length of the IO memory space */
-	chip->mem_size = pci_resource_len(pdev, IO_MEM_BAR);
-
-	/* allocate the memory for the device registers */
-	if (!request_mem_region(chip->mem_base, chip->mem_size, "1588_regs")) {
-		dev_err(&pdev->dev,
-			"could not allocate register memory space\n");
-		ret = -EBUSY;
-		goto err_req_mem_region;
+		return ret;
 	}
 
 	/* get the virtual address to the 1588 registers */
-	chip->regs = ioremap(chip->mem_base, chip->mem_size);
-
-	if (!chip->regs) {
-		dev_err(&pdev->dev, "Could not get virtual address\n");
-		ret = -ENOMEM;
-		goto err_ioremap;
-	}
-
+	chip->regs = pcim_iomap_table(pdev)[IO_MEM_BAR];
 	chip->caps = ptp_pch_caps;
 	chip->ptp_clock = ptp_clock_register(&chip->caps, &pdev->dev);
-	if (IS_ERR(chip->ptp_clock)) {
-		ret = PTR_ERR(chip->ptp_clock);
-		goto err_ptp_clock_reg;
-	}
+	if (IS_ERR(chip->ptp_clock))
+		return PTR_ERR(chip->ptp_clock);
 
 	spin_lock_init(&chip->register_lock);
 
@@ -564,21 +525,7 @@ pch_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 err_req_irq:
 	ptp_clock_unregister(chip->ptp_clock);
-err_ptp_clock_reg:
-	iounmap(chip->regs);
-	chip->regs = NULL;
-
-err_ioremap:
-	release_mem_region(chip->mem_base, chip->mem_size);
-
-err_req_mem_region:
-	chip->mem_base = 0;
-
-err_pci_start:
-	pci_disable_device(pdev);
 
-err_pci_en:
-	kfree(chip);
 	dev_err(&pdev->dev, "probe failed(ret=0x%x)\n", ret);
 
 	return ret;
-- 
2.30.2

