Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A7CD672CC9
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 00:46:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230048AbjARXqy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 18:46:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230040AbjARXqv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 18:46:51 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6CB71E9F3;
        Wed, 18 Jan 2023 15:46:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 71D3661AC1;
        Wed, 18 Jan 2023 23:46:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADA93C433EF;
        Wed, 18 Jan 2023 23:46:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674085608;
        bh=r7IHUtrt4W5zrGZVocaSLlMLC6+XXKVft9gvWcA0qEA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KzKMYlw9fGv+/adsbwH38hW9O4JEc2u4m7eaj3mVOMxGw2ynCo0NzS+FIpcg6Olwq
         MVryBQQATlqawf+Ipu1CdWji6gdhbjcy+foqJH0Yqc0MTRBA4mt1ouLN7KXdTfY6UX
         jyYPgYyqwOaR3S8FBz7H2ll9keheO13FcF1xH0y0CvVlFAtYqoYpXtq5g0ikg3jiCz
         FuDiFcJ4qwGqyhVR+NdW3f06CoZ7ZtG12J053lP66SC19UmnGX+FKDhUSGgooqncKU
         sFjmQinwDFWsjtYWpezelfV1mSA2Z/7G+W4vRs6eO+8D6b0utvpOUy/QZ2p1Iwetoh
         x98nk/s2AJ+Ow==
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     linux-pci@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org
Subject: [PATCH 2/9] e1000e: Remove redundant pci_enable_pcie_error_reporting()
Date:   Wed, 18 Jan 2023 17:46:05 -0600
Message-Id: <20230118234612.272916-3-helgaas@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230118234612.272916-1-helgaas@kernel.org>
References: <20230118234612.272916-1-helgaas@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bjorn Helgaas <bhelgaas@google.com>

pci_enable_pcie_error_reporting() enables the device to send ERR_*
Messages.  Since f26e58bf6f54 ("PCI/AER: Enable error reporting when AER is
native"), the PCI core does this for all devices during enumeration.

Remove the redundant pci_enable_pcie_error_reporting() call from the
driver.  Also remove the corresponding pci_disable_pcie_error_reporting()
from the driver .remove() path.

Note that this doesn't control interrupt generation by the Root Port; that
is controlled by the AER Root Error Command register, which is managed by
the AER service driver.

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Cc: Jesse Brandeburg <jesse.brandeburg@intel.com>
Cc: Tony Nguyen <anthony.l.nguyen@intel.com>
Cc: intel-wired-lan@lists.osuosl.org
Cc: netdev@vger.kernel.org
---
 drivers/net/ethernet/intel/e1000e/netdev.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index 04acd1a992fa..e1eb1de88bf9 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -7418,9 +7418,6 @@ static int e1000_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (err)
 		goto err_pci_reg;
 
-	/* AER (Advanced Error Reporting) hooks */
-	pci_enable_pcie_error_reporting(pdev);
-
 	pci_set_master(pdev);
 	/* PCI config space info */
 	err = pci_save_state(pdev);
@@ -7708,7 +7705,6 @@ static int e1000_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 err_ioremap:
 	free_netdev(netdev);
 err_alloc_etherdev:
-	pci_disable_pcie_error_reporting(pdev);
 	pci_release_mem_regions(pdev);
 err_pci_reg:
 err_dma:
@@ -7775,9 +7771,6 @@ static void e1000_remove(struct pci_dev *pdev)
 
 	free_netdev(netdev);
 
-	/* AER disable */
-	pci_disable_pcie_error_reporting(pdev);
-
 	pci_disable_device(pdev);
 }
 
-- 
2.25.1

