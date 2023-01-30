Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93F46681A57
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 20:25:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231538AbjA3TZg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 14:25:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238011AbjA3TZd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 14:25:33 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3C503C2B5
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 11:25:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675106726; x=1706642726;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=y4ZU9lhglY/gkMiPforuAPcrYTPYahFpSTsptB+MY+c=;
  b=XyRpLfTv47zqxdDN8bBwF/mlUuuUsm1MmhOzA3c/5xJjkU/SpuD7/+q3
   5ot67oM/T5rhOAEcbgDxKvULfjLLNkf3vpv5KV9qxrd6HKC/vlOYWfmGm
   vlUFVSusZwpOPwAOIboIHhmg30F0/lSEPyevPYCuT5ty4B5E6sSqh5T8e
   yGgc6LZ1e7eVwih845Xu2Jr424mOVsDvnuI590WPEprk5GmYd/gcZ6bZH
   jyGRDs2JMbwhaXrYaOmaTYSqLU+tly5lGgA9iTYUndkiogn4Fsjht4YLD
   t52S17HVMJ/wMlxcmqFApj9gaq67iwnyC0Q8eBESoY5xQc+oQpKkv2J0V
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10606"; a="392198588"
X-IronPort-AV: E=Sophos;i="5.97,259,1669104000"; 
   d="scan'208";a="392198588"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jan 2023 11:25:25 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10606"; a="696534355"
X-IronPort-AV: E=Sophos;i="5.97,259,1669104000"; 
   d="scan'208";a="696534355"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by orsmga001.jf.intel.com with ESMTP; 30 Jan 2023 11:25:25 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Bjorn Helgaas <bhelgaas@google.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        intel-wired-lan@lists.osuosl.org
Subject: [PATCH net-next 1/8] e1000e: Remove redundant pci_enable_pcie_error_reporting()
Date:   Mon, 30 Jan 2023 11:25:12 -0800
Message-Id: <20230130192519.686446-2-anthony.l.nguyen@intel.com>
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
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
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
2.38.1

