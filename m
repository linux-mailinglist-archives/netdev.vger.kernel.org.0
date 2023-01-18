Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5599A672CE9
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 00:48:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230253AbjARXsD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 18:48:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230209AbjARXrf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 18:47:35 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 147254A209;
        Wed, 18 Jan 2023 15:47:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BE56EB81F9C;
        Wed, 18 Jan 2023 23:47:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36586C433F1;
        Wed, 18 Jan 2023 23:47:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674085622;
        bh=jU3LaV/UIN+dmBuggye012PcdlnkG7nIjHD98dbjUpk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i4ewNbWLwndEi0QGob/RnVhLVMjzuxxSDIsj4Wz1njkOXrN9upsBTs0ek+BPlL5as
         abQIZHzIDFX9Jwrt81zSgXU7iG8Dbwt1h94kki3ko5cioXiZCIEOkfZy25ZCh1f3dr
         cwwgILQ4BWtV58AG2KtydiFYCCAOURTCsyziY0YAzmDaWvSTIo8CbjQ0m+Kduuv8KF
         a5m+O4VBqcZLRX63ASPiFiX6tv4WrapyoAdu8xmNdUJFKlAq3GU9Bbw/9tXyKRoDdh
         ioomQ2xowXpviJFHoiZqGEtYa8ZQnlTel79kH9P1YvHZBQ3eW1ffOOj5raLHnFojuh
         cQDucPtnpq7qQ==
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     linux-pci@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org
Subject: [PATCH 8/9] igc: Remove redundant pci_enable_pcie_error_reporting()
Date:   Wed, 18 Jan 2023 17:46:11 -0600
Message-Id: <20230118234612.272916-9-helgaas@kernel.org>
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
 drivers/net/ethernet/intel/igc/igc_main.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 44b1740dc098..a4df4ef088a9 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -6430,8 +6430,6 @@ static int igc_probe(struct pci_dev *pdev,
 	if (err)
 		goto err_pci_reg;
 
-	pci_enable_pcie_error_reporting(pdev);
-
 	err = pci_enable_ptm(pdev, NULL);
 	if (err < 0)
 		dev_info(&pdev->dev, "PCIe PTM not supported by PCIe bus/controller\n");
@@ -6636,7 +6634,6 @@ static int igc_probe(struct pci_dev *pdev,
 err_ioremap:
 	free_netdev(netdev);
 err_alloc_etherdev:
-	pci_disable_pcie_error_reporting(pdev);
 	pci_release_mem_regions(pdev);
 err_pci_reg:
 err_dma:
@@ -6684,8 +6681,6 @@ static void igc_remove(struct pci_dev *pdev)
 
 	free_netdev(netdev);
 
-	pci_disable_pcie_error_reporting(pdev);
-
 	pci_disable_device(pdev);
 }
 
-- 
2.25.1

