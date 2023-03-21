Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33BD66C3B33
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 21:03:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230044AbjCUUDx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 16:03:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229942AbjCUUDv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 16:03:51 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F2E8574D4
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 13:03:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679428986; x=1710964986;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=33DhyLzIboJ5/aOu+eIo7B6T56Ore4GUkBD6Op/VK8s=;
  b=TBG3uvx9F+jxGJ+rulach/D0M7kGkgXgJeU3btoZc5/QVc6qcFOBZIv6
   SRaQjF1JxMndDt/NagsMPRcwZdtfDDdfF1VxVNlc56PHF24BO+1MBsr9y
   ZCUXWQKRchqpdeCSwA5kVdJoecwZWPzNorFhomUYmQKnHxjIpI0U7lVHa
   RH4kJEnfJ7FM0J42jKM3xHyeGqD1fKwzwzJv2tiBCO4+CmsNpqI+8mxkq
   thMMIqHhAKeqEQC6EBlZShgWxI85UQxYNSWU9siy+yVnMu9E5O7rydXGX
   540BObG7z18XatTzIDw49sc/0jLkySYLTW92GCtiPbeMWgy8jLVlGL3RA
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10656"; a="403934794"
X-IronPort-AV: E=Sophos;i="5.98,279,1673942400"; 
   d="scan'208";a="403934794"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2023 13:01:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10656"; a="658911191"
X-IronPort-AV: E=Sophos;i="5.98,279,1673942400"; 
   d="scan'208";a="658911191"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by orsmga006.jf.intel.com with ESMTP; 21 Mar 2023 13:01:58 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org
Cc:     Dawid Wesierski <dawidx.wesierski@intel.com>,
        anthony.l.nguyen@intel.com,
        Kamil Maziarz <kamil.maziarz@intel.com>,
        Michal Kubiak <michal.kubiak@intel.com>,
        Marek Szlosek <marek.szlosek@intel.com>
Subject: [PATCH net-next 2/3] igbvf: add PCI reset handler functions
Date:   Tue, 21 Mar 2023 13:00:12 -0700
Message-Id: <20230321200013.2866582-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230321200013.2866582-1-anthony.l.nguyen@intel.com>
References: <20230321200013.2866582-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dawid Wesierski <dawidx.wesierski@intel.com>

There was a problem with resuming ping after conducting a PCI reset.
This commit adds two functions, igbvf_io_prepare and igbvf_io_done,
which, after being added to the pci_error_handlers struct,
will prepare the drivers for a PCI reset and then bring the interface up
and reset it after. This will prevent the driver from ending up in
incorrect state. Test_and_set_bit is highly reliable in this context,
so we are not including a timeout in this commit

This introduces 900ms - 1100ms of overhead to this operation but it's in
non-time-critical flow. And also allows the driver to continue
functioning after the reset.

Functionality documented in ethernet-controller-i350-datasheet 4.2.1.3
https://www.intel.com/content/www/us/en/products/details/ethernet/gigabit-controllers/i350-controllers/docs.html

Signed-off-by: Dawid Wesierski <dawidx.wesierski@intel.com>
Signed-off-by: Kamil Maziarz <kamil.maziarz@intel.com>
Reviewed-by: Michal Kubiak <michal.kubiak@intel.com>
Tested-by: Marek Szlosek <marek.szlosek@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/igbvf/netdev.c | 29 +++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/drivers/net/ethernet/intel/igbvf/netdev.c b/drivers/net/ethernet/intel/igbvf/netdev.c
index 3a32809510fc..790383078e0d 100644
--- a/drivers/net/ethernet/intel/igbvf/netdev.c
+++ b/drivers/net/ethernet/intel/igbvf/netdev.c
@@ -2589,6 +2589,33 @@ static void igbvf_io_resume(struct pci_dev *pdev)
 	netif_device_attach(netdev);
 }
 
+/**
+ * igbvf_io_prepare - prepare device driver for PCI reset
+ * @pdev: PCI device information struct
+ */
+static void igbvf_io_prepare(struct pci_dev *pdev)
+{
+	struct net_device *netdev = pci_get_drvdata(pdev);
+	struct igbvf_adapter *adapter = netdev_priv(netdev);
+
+	while (test_and_set_bit(__IGBVF_RESETTING, &adapter->state))
+		usleep_range(1000, 2000);
+	igbvf_down(adapter);
+}
+
+/**
+ * igbvf_io_reset_done - PCI reset done, device driver reset can begin
+ * @pdev: PCI device information struct
+ */
+static void igbvf_io_reset_done(struct pci_dev *pdev)
+{
+	struct net_device *netdev = pci_get_drvdata(pdev);
+	struct igbvf_adapter *adapter = netdev_priv(netdev);
+
+	igbvf_up(adapter);
+	clear_bit(__IGBVF_RESETTING, &adapter->state);
+}
+
 static void igbvf_print_device_info(struct igbvf_adapter *adapter)
 {
 	struct e1000_hw *hw = &adapter->hw;
@@ -2916,6 +2943,8 @@ static const struct pci_error_handlers igbvf_err_handler = {
 	.error_detected = igbvf_io_error_detected,
 	.slot_reset = igbvf_io_slot_reset,
 	.resume = igbvf_io_resume,
+	.reset_prepare = igbvf_io_prepare,
+	.reset_done = igbvf_io_reset_done,
 };
 
 static const struct pci_device_id igbvf_pci_tbl[] = {
-- 
2.38.1

