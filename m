Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D417F681A5E
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 20:25:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235392AbjA3TZn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 14:25:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237508AbjA3TZf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 14:25:35 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 529301EBC3
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 11:25:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675106734; x=1706642734;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=7SAKN1SMmBh75NXwdgiUY0auYWu0Q1FeMjxA8CfYJtg=;
  b=A8NDHCa0p15KeZPH5sCzcfAlo8FoaOM72BJjPCawseVXiQrYrmI5a7g/
   kXTvkwl1a/0oG1VgALUGwCh3AAeL1FCyr3UR7Be90JtYA6mlmLQQubahJ
   cxi0nkA3SkAc0TCzC5UVE8t/KVi6eelQZqlVj4QfALSpezOkgO49Caa9R
   L0KJpP7+KqpnSMlx1ORGhEl8hLJm+EpN/TKZR0QBk8CXIwSTuF8kO/Eys
   G6Vw3XY5KV9rjYilX1TjDQhEu/c3iqS2Vepk0mJ2SECDDbsTcTuHCrreT
   sR7Qzdu0Fyv3NkZZBj8TAka1z3KRk41o6trhiPiHO8qszrMd0yHVob0EM
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10606"; a="392198613"
X-IronPort-AV: E=Sophos;i="5.97,259,1669104000"; 
   d="scan'208";a="392198613"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jan 2023 11:25:25 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10606"; a="696534370"
X-IronPort-AV: E=Sophos;i="5.97,259,1669104000"; 
   d="scan'208";a="696534370"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by orsmga001.jf.intel.com with ESMTP; 30 Jan 2023 11:25:25 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Bjorn Helgaas <bhelgaas@google.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        intel-wired-lan@lists.osuosl.org,
        Gurucharan G <gurucharanx.g@intel.com>
Subject: [PATCH net-next 5/8] ice: Remove redundant pci_enable_pcie_error_reporting()
Date:   Mon, 30 Jan 2023 11:25:16 -0800
Message-Id: <20230130192519.686446-6-anthony.l.nguyen@intel.com>
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
Tested-by: Gurucharan G <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_main.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index fce86e8ff834..4aa19562fe93 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -4664,7 +4664,6 @@ ice_probe(struct pci_dev *pdev, const struct pci_device_id __always_unused *ent)
 		return err;
 	}
 
-	pci_enable_pcie_error_reporting(pdev);
 	pci_set_master(pdev);
 
 	pf->pdev = pdev;
@@ -4981,7 +4980,6 @@ ice_probe(struct pci_dev *pdev, const struct pci_device_id __always_unused *ent)
 	ice_devlink_destroy_regions(pf);
 	ice_deinit_hw(hw);
 err_exit_unroll:
-	pci_disable_pcie_error_reporting(pdev);
 	pci_disable_device(pdev);
 	return err;
 }
@@ -5113,7 +5111,6 @@ static void ice_remove(struct pci_dev *pdev)
 	ice_reset(hw, ICE_RESET_PFR);
 	pci_wait_for_pending_transaction(pdev);
 	ice_clear_interrupt_scheme(pf);
-	pci_disable_pcie_error_reporting(pdev);
 	pci_disable_device(pdev);
 }
 
-- 
2.38.1

