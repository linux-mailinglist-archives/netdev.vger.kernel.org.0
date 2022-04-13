Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3084B4FFC28
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 19:11:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237245AbiDMRNi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 13:13:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237295AbiDMRNb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 13:13:31 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE6806B092
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 10:11:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649869869; x=1681405869;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=jtxWZCk3Mwm0hcwhXaHTGpY8jrK1JNSCvtnU6VajyXw=;
  b=cQVarVZ3RXBsTDFXY+jsLvHg+FcVmZRA/+YGjJuWRq9GlJ70eRfYdDnY
   EKbv0V8NPY7RdPrOCydiW4sT+9+VwHPYlRpdi5LRfnDr0HyWdcV9m9FOU
   aWKY/L5ow9oMFeaJKnRIzwhGuVqv3/Ndy9dclcqvjdiEy8Ar/yKsUf5Hi
   ZcsguygaDZmnbpQxAdVK6KJaUcKFdpRxERfTHOjvaOPilss+xp4gQnnqn
   pSc8ggax2RKJ8KcOxupBCoL0MTgEtnBbMLX2qQERaj60KrBfXpCJNMT9P
   gaAwOG/8gM24A/oeXf9OjL3Ugx6QGcuUj0YDd7RT92CkgTLLVlwPLrwRf
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10316"; a="349158021"
X-IronPort-AV: E=Sophos;i="5.90,257,1643702400"; 
   d="scan'208";a="349158021"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2022 10:11:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,257,1643702400"; 
   d="scan'208";a="573360518"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga008.jf.intel.com with ESMTP; 13 Apr 2022 10:11:06 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        Naama Meir <naamax.meir@linux.intel.com>,
        Paul Menzel <pmenzel@molgen.mpg.de>
Subject: [PATCH net 3/4] igc: Fix suspending when PTM is active
Date:   Wed, 13 Apr 2022 10:08:13 -0700
Message-Id: <20220413170814.2066855-4-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220413170814.2066855-1-anthony.l.nguyen@intel.com>
References: <20220413170814.2066855-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vinicius Costa Gomes <vinicius.gomes@intel.com>

Some mainboard/CPU combinations, in particular, Alder Lake-S with a
W680 mainboard, have shown problems (system hangs usually, no kernel
logs) with suspend/resume when PCIe PTM is enabled and active. In some
cases, it could be reproduced when removing the igc module.

The best we can do is to stop PTM dialogs from the downstream/device
side before the interface is brought down. PCIe PTM will be re-enabled
when the interface is being brought up.

Fixes: a90ec8483732 ("igc: Add support for PTP getcrosststamp()")
Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Tested-by: Naama Meir <naamax.meir@linux.intel.com>
Acked-by: Paul Menzel <pmenzel@molgen.mpg.de>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_ptp.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_ptp.c b/drivers/net/ethernet/intel/igc/igc_ptp.c
index 0d6e3215e98f..653e9f1e35b5 100644
--- a/drivers/net/ethernet/intel/igc/igc_ptp.c
+++ b/drivers/net/ethernet/intel/igc/igc_ptp.c
@@ -992,6 +992,17 @@ static void igc_ptp_time_restore(struct igc_adapter *adapter)
 	igc_ptp_write_i225(adapter, &ts);
 }
 
+static void igc_ptm_stop(struct igc_adapter *adapter)
+{
+	struct igc_hw *hw = &adapter->hw;
+	u32 ctrl;
+
+	ctrl = rd32(IGC_PTM_CTRL);
+	ctrl &= ~IGC_PTM_CTRL_EN;
+
+	wr32(IGC_PTM_CTRL, ctrl);
+}
+
 /**
  * igc_ptp_suspend - Disable PTP work items and prepare for suspend
  * @adapter: Board private structure
@@ -1009,8 +1020,10 @@ void igc_ptp_suspend(struct igc_adapter *adapter)
 	adapter->ptp_tx_skb = NULL;
 	clear_bit_unlock(__IGC_PTP_TX_IN_PROGRESS, &adapter->state);
 
-	if (pci_device_is_present(adapter->pdev))
+	if (pci_device_is_present(adapter->pdev)) {
 		igc_ptp_time_save(adapter);
+		igc_ptm_stop(adapter);
+	}
 }
 
 /**
-- 
2.31.1

