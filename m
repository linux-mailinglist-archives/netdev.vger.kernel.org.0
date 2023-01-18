Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96448672CE6
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 00:48:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230192AbjARXsA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 18:48:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230188AbjARXr3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 18:47:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7530458A4;
        Wed, 18 Jan 2023 15:47:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0630661AC4;
        Wed, 18 Jan 2023 23:47:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42631C433D2;
        Wed, 18 Jan 2023 23:47:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674085624;
        bh=pLbQ/HGmJ0E41EsVj1qrzz7ZQK/1deMQHyH8FrWG9c8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y7PPT4VstGXz7JfMrERSl7oaxAJY3RMktbR01aCo+HyYqZ9D2WZJviA16585gX9bp
         Z3o29/mZMxhs+Uq8V6YqtIWyxQDqFji5V79Xew/JblsbBoNcUiIDIN4EMUSdpCI/CC
         HYarjE0Y6q2IbZ8iqFE/1WNbGYRVYGXf6FxNgPeJqNsLeqcvBSrsijazrc+os6G+L7
         Zuf//lsgWYMME5bhkdlxLUi7nnwG2umUJSUZqMaIbhJTNuD1Cna6VvzQjAa7aXcOvE
         UXWwGwEb/j9k6vMknIpjxQKwfGJrxcM+ELewyuPWOG7zANRIUmnNYA0C/yzykvFpyb
         5kW1Gcz0QhwiA==
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     linux-pci@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org
Subject: [PATCH 9/9] ixgbe: Remove redundant pci_enable_pcie_error_reporting()
Date:   Wed, 18 Jan 2023 17:46:12 -0600
Message-Id: <20230118234612.272916-10-helgaas@kernel.org>
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
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index ab8370c413f3..cb718c6216fc 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -10808,8 +10808,6 @@ static int ixgbe_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		goto err_pci_reg;
 	}
 
-	pci_enable_pcie_error_reporting(pdev);
-
 	pci_set_master(pdev);
 	pci_save_state(pdev);
 
@@ -11237,7 +11235,6 @@ static int ixgbe_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	disable_dev = !test_and_set_bit(__IXGBE_DISABLED, &adapter->state);
 	free_netdev(netdev);
 err_alloc_etherdev:
-	pci_disable_pcie_error_reporting(pdev);
 	pci_release_mem_regions(pdev);
 err_pci_reg:
 err_dma:
@@ -11326,8 +11323,6 @@ static void ixgbe_remove(struct pci_dev *pdev)
 	disable_dev = !test_and_set_bit(__IXGBE_DISABLED, &adapter->state);
 	free_netdev(netdev);
 
-	pci_disable_pcie_error_reporting(pdev);
-
 	if (disable_dev)
 		pci_disable_device(pdev);
 }
-- 
2.25.1

