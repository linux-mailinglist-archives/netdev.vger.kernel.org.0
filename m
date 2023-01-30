Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 873A8681A5D
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 20:25:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238033AbjA3TZm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 14:25:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238055AbjA3TZe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 14:25:34 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B84A2E812
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 11:25:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675106732; x=1706642732;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=I7aGjHMxjm7jTuEyVEBNqIG5WBc4USBNJYc7jMuCLJE=;
  b=BZsHm4s9QTidmbDNCDU0IUfutoD4EqHOVXQjng2ci3wnSnwhJO39FW6y
   tSthtMMm2d1IYqqPQQtjS2/Q7ouCjUXWxQ5g3HgAn+SwHcHqigRLXq3UV
   z6Uo6eOcHj3yx3Ege5/mgNyO4lykprooA4rcmQBqddfF/u0R7kurORcx+
   I4j4ADGvbmfLGF4y7huTofw8eOj2FRrBl7sYrVmYb+hAW/KJ3Ll0C25Eo
   tulO7RjWKTMrxtVyFPvVQ7t1+xbKKlDg+OUbagKvZazhq+ssPabAyAu5H
   T0gaVSSeJA9ayinOGxa1pZbyA572ch+or38LtS/kJihSlzN+Irrl7kB7i
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10606"; a="392198606"
X-IronPort-AV: E=Sophos;i="5.97,259,1669104000"; 
   d="scan'208";a="392198606"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jan 2023 11:25:25 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10606"; a="696534366"
X-IronPort-AV: E=Sophos;i="5.97,259,1669104000"; 
   d="scan'208";a="696534366"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by orsmga001.jf.intel.com with ESMTP; 30 Jan 2023 11:25:25 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Bjorn Helgaas <bhelgaas@google.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        intel-wired-lan@lists.osuosl.org,
        Marek Szlosek <marek.szlosek@intel.com>
Subject: [PATCH net-next 4/8] iavf: Remove redundant pci_enable_pcie_error_reporting()
Date:   Mon, 30 Jan 2023 11:25:15 -0800
Message-Id: <20230130192519.686446-5-anthony.l.nguyen@intel.com>
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
Tested-by: Marek Szlosek <marek.szlosek@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/iavf/iavf_main.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index 2c4480b20db3..3273aeb8fa67 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -4868,8 +4868,6 @@ static int iavf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		goto err_pci_reg;
 	}
 
-	pci_enable_pcie_error_reporting(pdev);
-
 	pci_set_master(pdev);
 
 	netdev = alloc_etherdev_mq(sizeof(struct iavf_adapter),
@@ -4957,7 +4955,6 @@ static int iavf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 err_alloc_wq:
 	free_netdev(netdev);
 err_alloc_etherdev:
-	pci_disable_pcie_error_reporting(pdev);
 	pci_release_regions(pdev);
 err_pci_reg:
 err_dma:
@@ -5175,8 +5172,6 @@ static void iavf_remove(struct pci_dev *pdev)
 
 	free_netdev(netdev);
 
-	pci_disable_pcie_error_reporting(pdev);
-
 	pci_disable_device(pdev);
 }
 
-- 
2.38.1

