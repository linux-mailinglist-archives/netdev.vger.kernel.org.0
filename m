Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 384984AF5A3
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 16:44:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236217AbiBIPnd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 10:43:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234255AbiBIPnc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 10:43:32 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A9FBC0613CA;
        Wed,  9 Feb 2022 07:43:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644421415; x=1675957415;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=tT0ubbIOHy9IAuW3heCg9dBzqzLkwpWxBVD1B0pmpaQ=;
  b=BimlXhnafmYZeRAnxWg3H1QUHe49YZWZ8WVj4XUYNhYY0TMlC8la1XUk
   EewQqP+pJxFgBS8Mt+wQ6JbKaxIZgn2wZVKzFuOTKDIz0X0EDAbZq9qSu
   Yt4kqx0515UDxcZkouXQn3giJq8Ny1aSsN0wDEw/71tRVY3kVXpRPAYCp
   6Uz8HdT6h/9aNGBSKueBm/VrTd2xrlhwQpCGQc/Lx+7SejZnx8xXLLWlZ
   Etb5ibPRyOscZV65RYrdKqTKyYpppmQwn/ewLLUIA+nTCHVWoCuNpSScz
   +NiygLpxxOEr26fa8E/6F3xoYeuRuAMWomxroLWiiE+bbrDSQDzZd54t8
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10252"; a="249435521"
X-IronPort-AV: E=Sophos;i="5.88,356,1635231600"; 
   d="scan'208";a="249435521"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2022 07:43:34 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,356,1635231600"; 
   d="scan'208";a="541143751"
Received: from chenyu-dev.sh.intel.com ([10.239.158.61])
  by orsmga008.jf.intel.com with ESMTP; 09 Feb 2022 07:43:28 -0800
From:   Chen Yu <yu.c.chen@intel.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Todd Brandt <todd.e.brandt@intel.com>,
        Len Brown <len.brown@intel.com>, Chen Yu <yu.c.chen@intel.com>
Subject: [PATCH] e1000e: Print PHY register address when MDI read/write fails
Date:   Thu, 10 Feb 2022 07:43:02 +0800
Message-Id: <20220209234302.50833-1-yu.c.chen@intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DATE_IN_FUTURE_06_12,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is occasional suspend error from e1000e which blocks the
system from further suspending:
[   20.078957] PM: pci_pm_suspend(): e1000e_pm_suspend+0x0/0x780 [e1000e] returns -2
[   20.078970] PM: dpm_run_callback(): pci_pm_suspend+0x0/0x170 returns -2
[   20.078974] e1000e 0000:00:1f.6: PM: pci_pm_suspend+0x0/0x170 returned -2 after 371012 usecs
[   20.078978] e1000e 0000:00:1f.6: PM: failed to suspend async: error -2
According to the code flow, this might be caused by broken MDI read/write to PHY registers.
However currently the code does not tell us which register is broken. Thus enhance the debug
information to print the offender PHY register for easier debugging.

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

