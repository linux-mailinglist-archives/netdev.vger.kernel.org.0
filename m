Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE234575457
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 20:02:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239107AbiGNSCL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 14:02:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238688AbiGNSCK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 14:02:10 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A73F8675B6
        for <netdev@vger.kernel.org>; Thu, 14 Jul 2022 11:02:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657821729; x=1689357729;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Tr97oGc8LslVNwWKhzcTGDh/fyEzrC7fLyJ5Szw2KZ8=;
  b=MeMsmLXmotw4ABMx1zAs3c1U8cwXJm1Q5kp/ZguyVhOLlkazUvm0slkk
   Tnv1K1O0z3SpYahIC6K6P3aPJZ5XLjxDxJnrcXoGC+GDJMo41hu0Lq1ft
   bBydXighqc0KecYq2NIW2z8h0de1KTTK0bslE+IZ1jDJwhvn5hYUqwRIa
   nba3UglKQ5x4zKU+0fQK05RtQJ99e8A6PSE0JDxrN9I7+zLqhuWktlyqM
   ISdheVitfRy7fwQrPjmBDhpy+PWkQ+J3VDNyagD1FwtzTD650qlIhatxQ
   Z3kGhRqMjic30uUkGNMtigqeMLDu++VnunmTc74+fCWvj/2obz5vf0SBO
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10408"; a="283151249"
X-IronPort-AV: E=Sophos;i="5.92,272,1650956400"; 
   d="scan'208";a="283151249"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2022 11:01:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,272,1650956400"; 
   d="scan'208";a="842235649"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga006.fm.intel.com with ESMTP; 14 Jul 2022 11:01:56 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Sasha Neftin <sasha.neftin@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com,
        Naama Meir <naamax.meir@linux.intel.com>
Subject: [PATCH net 2/3] Revert "e1000e: Fix possible HW unit hang after an s0ix exit"
Date:   Thu, 14 Jul 2022 10:58:56 -0700
Message-Id: <20220714175857.933537-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220714175857.933537-1-anthony.l.nguyen@intel.com>
References: <20220714175857.933537-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sasha Neftin <sasha.neftin@intel.com>

This reverts commit 1866aa0d0d6492bc2f8d22d0df49abaccf50cddd.

Commit 1866aa0d0d64 ("e1000e: Fix possible HW unit hang after an s0ix
exit") was a workaround for CSME problem to handle messages comes via H2ME
mailbox. This problem has been fixed by patch "e1000e: Enable the GPT
clock before sending message to the CSME".

Fixes: 3e55d231716e ("e1000e: Add handshake with the CSME to support S0ix")
Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=214821
Signed-off-by: Sasha Neftin <sasha.neftin@intel.com>
Tested-by: Naama Meir <naamax.meir@linux.intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/e1000e/hw.h      |  1 -
 drivers/net/ethernet/intel/e1000e/ich8lan.c |  4 ----
 drivers/net/ethernet/intel/e1000e/ich8lan.h |  1 -
 drivers/net/ethernet/intel/e1000e/netdev.c  | 26 ---------------------
 4 files changed, 32 deletions(-)

diff --git a/drivers/net/ethernet/intel/e1000e/hw.h b/drivers/net/ethernet/intel/e1000e/hw.h
index 13382df2f2ef..bcf680e83811 100644
--- a/drivers/net/ethernet/intel/e1000e/hw.h
+++ b/drivers/net/ethernet/intel/e1000e/hw.h
@@ -630,7 +630,6 @@ struct e1000_phy_info {
 	bool disable_polarity_correction;
 	bool is_mdix;
 	bool polarity_correction;
-	bool reset_disable;
 	bool speed_downgraded;
 	bool autoneg_wait_to_complete;
 };
diff --git a/drivers/net/ethernet/intel/e1000e/ich8lan.c b/drivers/net/ethernet/intel/e1000e/ich8lan.c
index e6c8e6d5234f..9466f65a6da7 100644
--- a/drivers/net/ethernet/intel/e1000e/ich8lan.c
+++ b/drivers/net/ethernet/intel/e1000e/ich8lan.c
@@ -2050,10 +2050,6 @@ static s32 e1000_check_reset_block_ich8lan(struct e1000_hw *hw)
 	bool blocked = false;
 	int i = 0;
 
-	/* Check the PHY (LCD) reset flag */
-	if (hw->phy.reset_disable)
-		return true;
-
 	while ((blocked = !(er32(FWSM) & E1000_ICH_FWSM_RSPCIPHY)) &&
 	       (i++ < 30))
 		usleep_range(10000, 11000);
diff --git a/drivers/net/ethernet/intel/e1000e/ich8lan.h b/drivers/net/ethernet/intel/e1000e/ich8lan.h
index 638a3ddd7ada..2504b11c3169 100644
--- a/drivers/net/ethernet/intel/e1000e/ich8lan.h
+++ b/drivers/net/ethernet/intel/e1000e/ich8lan.h
@@ -271,7 +271,6 @@
 #define I217_CGFREG_ENABLE_MTA_RESET	0x0002
 #define I217_MEMPWR			PHY_REG(772, 26)
 #define I217_MEMPWR_DISABLE_SMB_RELEASE	0x0010
-#define I217_MEMPWR_MOEM		0x1000
 
 /* Receive Address Initial CRC Calculation */
 #define E1000_PCH_RAICC(_n)	(0x05F50 + ((_n) * 4))
diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index c64102b29862..f1729940e46c 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -6991,21 +6991,8 @@ static __maybe_unused int e1000e_pm_suspend(struct device *dev)
 	struct net_device *netdev = pci_get_drvdata(to_pci_dev(dev));
 	struct e1000_adapter *adapter = netdev_priv(netdev);
 	struct pci_dev *pdev = to_pci_dev(dev);
-	struct e1000_hw *hw = &adapter->hw;
-	u16 phy_data;
 	int rc;
 
-	if (er32(FWSM) & E1000_ICH_FWSM_FW_VALID &&
-	    hw->mac.type >= e1000_pch_adp) {
-		/* Mask OEM Bits / Gig Disable / Restart AN (772_26[12] = 1) */
-		e1e_rphy(hw, I217_MEMPWR, &phy_data);
-		phy_data |= I217_MEMPWR_MOEM;
-		e1e_wphy(hw, I217_MEMPWR, phy_data);
-
-		/* Disable LCD reset */
-		hw->phy.reset_disable = true;
-	}
-
 	e1000e_flush_lpic(pdev);
 
 	e1000e_pm_freeze(dev);
@@ -7027,8 +7014,6 @@ static __maybe_unused int e1000e_pm_resume(struct device *dev)
 	struct net_device *netdev = pci_get_drvdata(to_pci_dev(dev));
 	struct e1000_adapter *adapter = netdev_priv(netdev);
 	struct pci_dev *pdev = to_pci_dev(dev);
-	struct e1000_hw *hw = &adapter->hw;
-	u16 phy_data;
 	int rc;
 
 	/* Introduce S0ix implementation */
@@ -7039,17 +7024,6 @@ static __maybe_unused int e1000e_pm_resume(struct device *dev)
 	if (rc)
 		return rc;
 
-	if (er32(FWSM) & E1000_ICH_FWSM_FW_VALID &&
-	    hw->mac.type >= e1000_pch_adp) {
-		/* Unmask OEM Bits / Gig Disable / Restart AN 772_26[12] = 0 */
-		e1e_rphy(hw, I217_MEMPWR, &phy_data);
-		phy_data &= ~I217_MEMPWR_MOEM;
-		e1e_wphy(hw, I217_MEMPWR, phy_data);
-
-		/* Enable LCD reset */
-		hw->phy.reset_disable = false;
-	}
-
 	return e1000e_pm_thaw(dev);
 }
 
-- 
2.35.1

