Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4391C4ACAE6
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 22:09:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236321AbiBGVI0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 16:08:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231445AbiBGVIU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 16:08:20 -0500
X-Greylist: delayed 62 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 07 Feb 2022 13:08:20 PST
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 421EFC06173B
        for <netdev@vger.kernel.org>; Mon,  7 Feb 2022 13:08:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644268100; x=1675804100;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=M+Q8hWBGFWSszOeXBZjhxDe98wpuo6TBxix/WKIEaCM=;
  b=GjG2NX/j5FOwjoB9twmAyMwzYrS0s8cfNtKWu/JnQM6UZcDvMwCKj//B
   ciDduz05zYis2UdmClzYUXZ3qDk3ohRUKaZtgL4/vraFUBr8DoPnaAyKS
   423psun/270k2RrXIL3Kqjlajg61vJ+bE7c59ve3DjDzVAndTf2yHu1NF
   zgvmlnrbbhV8JhnlCCxHlF230wmc/DBZ0UIGsc5XCjVkL4G0nTYLAng0I
   czwi3fxRItIejckrgBSc1JnYYR7acAGy6TbFA9YEOh+nxL9Mv2jRBirIX
   m4HShjEXWPbhzrBZX70otmCU3A2OBLKJUK5SLPXnNGO0HXOBoUuhy3g3Y
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10251"; a="335211572"
X-IronPort-AV: E=Sophos;i="5.88,350,1635231600"; 
   d="scan'208";a="335211572"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Feb 2022 13:07:17 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,350,1635231600"; 
   d="scan'208";a="621686120"
Received: from black.fi.intel.com ([10.237.72.28])
  by FMSMGA003.fm.intel.com with ESMTP; 07 Feb 2022 13:07:16 -0800
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id 6A9E953E; Mon,  7 Feb 2022 23:07:31 +0200 (EET)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Richard Cochran <richardcochran@gmail.com>
Subject: [PATCH v2 net-next 5/6] ptp_pch: Convert to use managed functions pcim_* and devm_*
Date:   Mon,  7 Feb 2022 23:07:29 +0200
Message-Id: <20220207210730.75252-5-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220207210730.75252-1-andriy.shevchenko@linux.intel.com>
References: <20220207210730.75252-1-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This makes the error handling much more simpler than open-coding everything
and in addition makes the probe function smaller an tidier.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
v2: no changes
 drivers/ptp/ptp_pch.c | 73 ++++++-------------------------------------
 1 file changed, 10 insertions(+), 63 deletions(-)

diff --git a/drivers/ptp/ptp_pch.c b/drivers/ptp/ptp_pch.c
index 703dbf237382..0d2ffcca608c 100644
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
2.34.1

