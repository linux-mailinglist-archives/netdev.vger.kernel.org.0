Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E70E4681A61
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 20:25:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238102AbjA3TZq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 14:25:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237973AbjA3TZf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 14:25:35 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C78437F2E
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 11:25:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675106734; x=1706642734;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=IvEeE5pG6QUgFcRFdBdI2Kw1MlZctNMcLkayKSKY7eg=;
  b=BAN+BVa8rVcLoiu4rMPdFXJDJoDdYZvn9be521MMea1D9hoIX1gkwY4N
   6mb2uFmHPvPisNQ1Qm86nFlnj9u+lHfTnQsrccriuWFzfo4FoJnddXukC
   nWtvUYj04AyMPkgCXngfxzt7xzauUpvknayQVXZcXH6ofN6oRNtfELp1j
   EUtymnDgz+U8Pn192XizFtSJ7QTiR3Scxa+tJKMcvFA/FnxavTiKUz8ci
   0WSHrDs2XlivuQkwnHa17A3XypZUmpeEwM4mUYv8ry2NFg0kiFJUM4JAF
   A2xmLs4CnqPSAVhd7dnxATO6YzJxEzH5BmK5MtZFlWaB9OQ5JqtGK8ZfM
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10606"; a="392198625"
X-IronPort-AV: E=Sophos;i="5.97,259,1669104000"; 
   d="scan'208";a="392198625"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jan 2023 11:25:26 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10606"; a="696534376"
X-IronPort-AV: E=Sophos;i="5.97,259,1669104000"; 
   d="scan'208";a="696534376"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by orsmga001.jf.intel.com with ESMTP; 30 Jan 2023 11:25:25 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Bjorn Helgaas <bhelgaas@google.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        intel-wired-lan@lists.osuosl.org,
        Naama Meir <naamax.meir@linux.intel.com>
Subject: [PATCH net-next 7/8] igc: Remove redundant pci_enable_pcie_error_reporting()
Date:   Mon, 30 Jan 2023 11:25:18 -0800
Message-Id: <20230130192519.686446-8-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230130192519.686446-1-anthony.l.nguyen@intel.com>
References: <20230130192519.686446-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
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
Tested-by: Naama Meir <naamax.meir@linux.intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_main.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index e86b15efaeb8..6ddcbc8b7b6a 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -6434,8 +6434,6 @@ static int igc_probe(struct pci_dev *pdev,
 	if (err)
 		goto err_pci_reg;
 
-	pci_enable_pcie_error_reporting(pdev);
-
 	err = pci_enable_ptm(pdev, NULL);
 	if (err < 0)
 		dev_info(&pdev->dev, "PCIe PTM not supported by PCIe bus/controller\n");
@@ -6640,7 +6638,6 @@ static int igc_probe(struct pci_dev *pdev,
 err_ioremap:
 	free_netdev(netdev);
 err_alloc_etherdev:
-	pci_disable_pcie_error_reporting(pdev);
 	pci_release_mem_regions(pdev);
 err_pci_reg:
 err_dma:
@@ -6688,8 +6685,6 @@ static void igc_remove(struct pci_dev *pdev)
 
 	free_netdev(netdev);
 
-	pci_disable_pcie_error_reporting(pdev);
-
 	pci_disable_device(pdev);
 }
 
-- 
2.38.1

