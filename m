Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B766542FB8
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 14:04:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238585AbiFHMEB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 08:04:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238533AbiFHMD6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 08:03:58 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D41A12296A;
        Wed,  8 Jun 2022 05:03:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654689838; x=1686225838;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=A/KTS84ZoHA+r17AcI19edhkFKnIut364sqGDUAJQkA=;
  b=nrBRUiUwuH78ItTU3N8cwiTb2kQOcLHQ3DgUyvNgvSIZCRQqLKBpiHrh
   YB23FvxvMGZgrnOBM7Qq9UhuDqZqAkjMcyoydNweJ6gjhbfs2uu9opYdY
   Ms2VifbfqkkHsw8lIEXca26zJb8Br1Bevkb/mqAPbHMaMA1SW/Jm90nmg
   yeYlGPpB0oSMVaAq0N2scMOw0ytqdKuCPJoORKog7t7OMwVrPO30MSiHy
   mxEMTjw7ynpsCaokrAHkMWm3+FTAYx+sePhTYAXW4rDwoO4g3zKAfnWVp
   Lh50x9VFfTyxdp5wog4nHnqG8BxdaHZ7RvtZJI3/SYxPEbnMrKOuMde+u
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10371"; a="256701611"
X-IronPort-AV: E=Sophos;i="5.91,286,1647327600"; 
   d="scan'208";a="256701611"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2022 05:03:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,286,1647327600"; 
   d="scan'208";a="636792040"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga008.fm.intel.com with ESMTP; 08 Jun 2022 05:03:56 -0700
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id B1FE51D0; Wed,  8 Jun 2022 15:03:59 +0300 (EEST)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Jonathan Lemon <jonathan.lemon@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Richard Cochran <richardcochran@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH net-next v1 1/5] ptp_ocp: use dev_err_probe()
Date:   Wed,  8 Jun 2022 15:03:54 +0300
Message-Id: <20220608120358.81147-2-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220608120358.81147-1-andriy.shevchenko@linux.intel.com>
References: <20220608120358.81147-1-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Simplify the error path in ->probe() and unify message format a bit
by using dev_err_probe().

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/ptp/ptp_ocp.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/ptp/ptp_ocp.c b/drivers/ptp/ptp_ocp.c
index 4519ef42b458..17930762fde9 100644
--- a/drivers/ptp/ptp_ocp.c
+++ b/drivers/ptp/ptp_ocp.c
@@ -3722,14 +3722,12 @@ ptp_ocp_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	int err;
 
 	devlink = devlink_alloc(&ptp_ocp_devlink_ops, sizeof(*bp), &pdev->dev);
-	if (!devlink) {
-		dev_err(&pdev->dev, "devlink_alloc failed\n");
-		return -ENOMEM;
-	}
+	if (!devlink)
+		return dev_err_probe(&pdev->dev, -ENOMEM, "devlink_alloc failed\n");
 
 	err = pci_enable_device(pdev);
 	if (err) {
-		dev_err(&pdev->dev, "pci_enable_device\n");
+		dev_err_probe(&pdev->dev, err, "pci_enable_device\n");
 		goto out_free;
 	}
 
@@ -3745,7 +3743,7 @@ ptp_ocp_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	 */
 	err = pci_alloc_irq_vectors(pdev, 1, 17, PCI_IRQ_MSI | PCI_IRQ_MSIX);
 	if (err < 0) {
-		dev_err(&pdev->dev, "alloc_irq_vectors err: %d\n", err);
+		dev_err_probe(&pdev->dev, err, "alloc_irq_vectors\n");
 		goto out;
 	}
 	bp->n_irqs = err;
@@ -3757,8 +3755,7 @@ ptp_ocp_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	bp->ptp = ptp_clock_register(&bp->ptp_info, &pdev->dev);
 	if (IS_ERR(bp->ptp)) {
-		err = PTR_ERR(bp->ptp);
-		dev_err(&pdev->dev, "ptp_clock_register: %d\n", err);
+		err = dev_err_probe(&pdev->dev, PTR_ERR(bp->ptp), "ptp_clock_register\n");
 		bp->ptp = NULL;
 		goto out;
 	}
-- 
2.35.1

