Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5065F4B0E57
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 14:24:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242139AbiBJNXf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 08:23:35 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237587AbiBJNXf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 08:23:35 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77628195;
        Thu, 10 Feb 2022 05:23:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644499416; x=1676035416;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=xaNbbSHH+Oj7f0ul4xNRnJxNvPSGLv4NgNZTbVdjjnc=;
  b=dVlJswngNgiSDMOvl4v7yxuTdzPe9N810sPJsBD6VKv3f026nOiomc5o
   cJ8m179rddLCprPA6dN0uID7KVFoQeCQv/ezbNtk5APDQ0Lb50YPVBW3N
   i81C0fKZ6uWC1202ylvttKP1ozEVkmVgG7TwGBbttE7itXKV0gahenpFy
   R+pC1TIu/UsVdbDWCsUC03yus/itQ9oV8yr1VuWWwV2O3YpYb0DJwjgtf
   deO/cJdYpb9WdaawcoTfWwZTQE09Lr1CjTb+TyO2nl7urIWtqGkxm6YPt
   d01HG90+qk/4ySDCfJEsJJJ1AIQs4Iv2DzPfctQOgfivRAUhmRFkzJhaa
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10253"; a="312774231"
X-IronPort-AV: E=Sophos;i="5.88,358,1635231600"; 
   d="scan'208";a="312774231"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2022 05:23:36 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,358,1635231600"; 
   d="scan'208";a="633663096"
Received: from chenyu-dev.sh.intel.com ([10.239.158.61])
  by orsmga004.jf.intel.com with ESMTP; 10 Feb 2022 05:23:33 -0800
From:   Chen Yu <yu.c.chen@intel.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paul Menzel <pmenzel@molgen.mpg.de>,
        Chen Yu <yu.c.chen@intel.com>,
        Todd Brandt <todd.e.brandt@intel.com>
Subject: [PATCH v2] e1000e: Print PHY register address when MDI read/write fails
Date:   Thu, 10 Feb 2022 21:22:56 +0800
Message-Id: <20220210132256.53589-1-yu.c.chen@intel.com>
X-Mailer: git-send-email 2.25.1
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
2.25.1

