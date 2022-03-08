Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACD5D4D1F1A
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 18:28:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241921AbiCHR3l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 12:29:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231911AbiCHR3k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 12:29:40 -0500
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D282A54BE0
        for <netdev@vger.kernel.org>; Tue,  8 Mar 2022 09:28:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646760523; x=1678296523;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=DHCZhe0lo2hPxcPuVMUuNoh+7xFqoamFCrSBenJdRU4=;
  b=ad0RTb5nXTkHDitQn28F+6EFnNpc2Yl/nyJzDAEWh0vLHziqhgB356Po
   uNjdnuvwDl0vQUEGqboLzBHySwpDW70TJD6eRHMqz4BsptOjc3BQBA8wC
   0iofmS7D6JfMJeNosEqygFxXEVIQMNPN4mRDIY6NpVJgW17hGGtcPkKzF
   fdF9SpTo/IdDEfs+I4MT8+XLiepBurzwJxTr5rihHR0Rpm+9Jm+1DGRt2
   k2xcZ3yXwGFoliLlrzPkC0Z+YhNwg0r18VMsvlbEc5WZziKq+czOvD2x4
   D3YrZkrEE5zt6U++g8RegqsTShu0yaOEkw8v9XMKVijWCstqQKz1hfUAf
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10280"; a="315469501"
X-IronPort-AV: E=Sophos;i="5.90,165,1643702400"; 
   d="scan'208";a="315469501"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Mar 2022 09:20:14 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,165,1643702400"; 
   d="scan'208";a="643727787"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga004.jf.intel.com with ESMTP; 08 Mar 2022 09:20:13 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Chen Yu <yu.c.chen@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, sasha.neftin@intel.com,
        vitaly.lifshits@intel.com, Paul Menzel <pmenzel@molgen.mpg.de>,
        Todd Brandt <todd.e.brandt@intel.com>,
        Naama Meir <naamax.meir@linux.intel.com>
Subject: [PATCH net-next 1/1] e1000e: Print PHY register address when MDI read/write fails
Date:   Tue,  8 Mar 2022 09:20:30 -0800
Message-Id: <20220308172030.451566-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chen Yu <yu.c.chen@intel.com>

There is occasional suspend error from e1000e which blocks the
system from further suspending. And the issue was found on
a WhiskeyLake-U platform with I219-V:

[   20.078957] PM: pci_pm_suspend(): e1000e_pm_suspend+0x0/0x780 [e1000e] returns -2
[   20.078970] PM: dpm_run_callback(): pci_pm_suspend+0x0/0x170 returns -2
[   20.078974] e1000e 0000:00:1f.6: PM: pci_pm_suspend+0x0/0x170 returned -2 after 371012 usecs
[   20.078978] e1000e 0000:00:1f.6: PM: failed to suspend async: error -2

According to the code flow, this might be caused by broken MDI read/write
to PHY registers. However currently the code does not tell us which
register is broken. Thus enhance the debug information to print the
offender PHY register. So the next the issue is reproduced, this
information could be used for narrow down.

Acked-by: Paul Menzel <pmenzel@molgen.mpg.de>
Reported-by: Todd Brandt <todd.e.brandt@intel.com>
Signed-off-by: Chen Yu <yu.c.chen@intel.com>
Tested-by: Naama Meir <naamax.meir@linux.intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/e1000e/phy.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/e1000e/phy.c b/drivers/net/ethernet/intel/e1000e/phy.c
index 0f0efee5fc8e..fd07c3679bb1 100644
--- a/drivers/net/ethernet/intel/e1000e/phy.c
+++ b/drivers/net/ethernet/intel/e1000e/phy.c
@@ -146,11 +146,11 @@ s32 e1000e_read_phy_reg_mdic(struct e1000_hw *hw, u32 offset, u16 *data)
 			break;
 	}
 	if (!(mdic & E1000_MDIC_READY)) {
-		e_dbg("MDI Read did not complete\n");
+		e_dbg("MDI Read PHY Reg Address %d did not complete\n", offset);
 		return -E1000_ERR_PHY;
 	}
 	if (mdic & E1000_MDIC_ERROR) {
-		e_dbg("MDI Error\n");
+		e_dbg("MDI Read PHY Reg Address %d Error\n", offset);
 		return -E1000_ERR_PHY;
 	}
 	if (((mdic & E1000_MDIC_REG_MASK) >> E1000_MDIC_REG_SHIFT) != offset) {
@@ -210,11 +210,11 @@ s32 e1000e_write_phy_reg_mdic(struct e1000_hw *hw, u32 offset, u16 data)
 			break;
 	}
 	if (!(mdic & E1000_MDIC_READY)) {
-		e_dbg("MDI Write did not complete\n");
+		e_dbg("MDI Write PHY Reg Address %d did not complete\n", offset);
 		return -E1000_ERR_PHY;
 	}
 	if (mdic & E1000_MDIC_ERROR) {
-		e_dbg("MDI Error\n");
+		e_dbg("MDI Write PHY Red Address %d Error\n", offset);
 		return -E1000_ERR_PHY;
 	}
 	if (((mdic & E1000_MDIC_REG_MASK) >> E1000_MDIC_REG_SHIFT) != offset) {
-- 
2.31.1

