Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E2AB672CD2
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 00:47:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230097AbjARXrD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 18:47:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230064AbjARXqz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 18:46:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8ABED37F1D;
        Wed, 18 Jan 2023 15:46:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0796E61AC8;
        Wed, 18 Jan 2023 23:46:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DF8EC433D2;
        Wed, 18 Jan 2023 23:46:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674085613;
        bh=AzdQucESujCjaM/FV302gVI8jy+O9nQfIiRUb375jaI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eXtdJ/IB16lmVAEkHnK0pRbnieB+wPnG20X6yAZh/xJCJdFx4qcyHHCVjqZP82ofK
         +uIw0mNsmjxtbDD0mi569vDvBvOh1lSIYgq3Do2GV+5ws1MfgTnrLwTW2M068dLyi5
         M4uDGkz3IvNrAJ51hOjm+BirkD8GcUzQd4SYm9fn/ssYB3g0gNP1GCL3h+hmBsw241
         aBFLDIt3oCh3PxQMvRIb3gks0lDW5ttxlnMUJi8igbgGQQpFixbCEcKhXk0T5oTbSD
         KOg/0UdeayJuVu5krDf64bdkMrwQ0X/tgtrN0BjGxTYduVrhsikf6nwc/VcoYoOpvD
         wUbK9uFbXqVzg==
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     linux-pci@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org
Subject: [PATCH 4/9] i40e: Remove redundant pci_enable_pcie_error_reporting()
Date:   Wed, 18 Jan 2023 17:46:07 -0600
Message-Id: <20230118234612.272916-5-helgaas@kernel.org>
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
 drivers/net/ethernet/intel/i40e/i40e_main.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 53d0083e35da..43693f902c27 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -15589,7 +15589,6 @@ static int i40e_init_recovery_mode(struct i40e_pf *pf, struct i40e_hw *hw)
 	timer_shutdown_sync(&pf->service_timer);
 	i40e_shutdown_adminq(hw);
 	iounmap(hw->hw_addr);
-	pci_disable_pcie_error_reporting(pf->pdev);
 	pci_release_mem_regions(pf->pdev);
 	pci_disable_device(pf->pdev);
 	kfree(pf);
@@ -15660,7 +15659,6 @@ static int i40e_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		goto err_pci_reg;
 	}
 
-	pci_enable_pcie_error_reporting(pdev);
 	pci_set_master(pdev);
 
 	/* Now that we have a PCI connection, we need to do the
@@ -16218,7 +16216,6 @@ static int i40e_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 err_ioremap:
 	kfree(pf);
 err_pf_alloc:
-	pci_disable_pcie_error_reporting(pdev);
 	pci_release_mem_regions(pdev);
 err_pci_reg:
 err_dma:
@@ -16366,7 +16363,6 @@ static void i40e_remove(struct pci_dev *pdev)
 	kfree(pf);
 	pci_release_mem_regions(pdev);
 
-	pci_disable_pcie_error_reporting(pdev);
 	pci_disable_device(pdev);
 }
 
-- 
2.25.1

